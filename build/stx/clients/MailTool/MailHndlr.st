"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"

Object subclass:#MailHandler
	instanceVariableNames:'mailFile userName headerStartPositions headerEndPositions
		headerLines mailFileSize tempDirName lockFileName canLock
		anyChanges mailDirName cachedHeader cachedHeaderNr
		deletedMessages'
	classVariableNames:'FaceDirectoryPath KeepExtractedFaces'
	poolDictionaries:''
	category:'demos-MailTool'
!

!MailHandler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
!

documentation
"
 interface to the mail-file or mail-handlers (via subclasses)

 I have put all interface to the mail files into this class,
 so that this code is not spread around in many mail-reader programs;
 currently, it can only extract header lines and individual mail
 entries - should be enhanced to allow for deleting / searching etc

 Fancy feature:
    if the directory '/usr/local/lib/faces' exists,
    and it contains subdirectories named after hosts names (such as 'ssw.de', 'foo.com'),
    and those directories contain files named after users, then these are used as faces
    and displayed when a letter is selected.
    (i.e. user@foo.com should have a tiff/gif- or whatever file in /usr/local/lib/faces/foo.com/user)

 written spring/summer 89 by claus
"
! !

!MailHandler class methodsFor:'initialization'!

initialize
    '/usr/local/lib/faces' asFilename exists ifTrue:[
	FaceDirectoryPath := '/usr/local/lib/faces'
    ].
    KeepExtractedFaces := true

    "Created: 18.11.1995 / 16:13:39 / cg"
! !

!MailHandler class methodsFor:'instance creation'!

new
    "answer a new mailhandler for users mail"

    ^ self basicNew initialize
! !

!MailHandler class methodsFor:'defaults'!

listOfMailers
    "return a list of known mail programs, to which a letter can be piped.
     If you dont want the mailer to try them all, change the list below
     to contain a single entry with your mailprograms pathname.
     When sending mail, these are tried in sequence until one responds."

    ^ #(
	'/usr/lib/sendmail'
	'/usr/ucblib/sendmail'
	'/usr/bin/sendmail'
	'/usr/sbin/sendmail'
	'/sbin/sendmail'
	'mailer'
       )

    "Created: 3.11.1995 / 11:54:53 / cg"
! !

!MailHandler methodsFor:'accessing'!

deleteMail:mailNr
    "remove entry from list - should also remove in mailfile ..."

    |nLetters|

    headerStartPositions isNil ifTrue:[^ false].

    nLetters := headerLines size.
    (mailNr > nLetters) ifTrue:[^ false].
    headerStartPositions removeIndex:mailNr.
    headerEndPositions removeIndex:mailNr.
    headerLines removeIndex:mailNr.
    anyChanges := true.
    ^ true
!

faceOf:mailNr
    "extract a headers info consisting of: status, origin, date and subject"

    |info faceString origin host user notFound dir img fullString f s|

    origin := self originOf:mailNr.
    origin notNil ifTrue:[
        user := self userFromOrigin:origin.
        host := self hostFromOrigin:origin.
    ].

    (info := self summaryOf:mailNr) notNil ifTrue:[
        (faceString := info at:#faceString ifAbsent:nil) notNil ifTrue:[
            BlitImageReader notNil ifTrue:[
                img :=  BlitImageReader fromCompressedString:faceString.
                img notNil ifTrue:[
                    KeepExtractedFaces == true ifTrue:[
                        FaceDirectoryPath notNil ifTrue:[
                            dir := (FaceDirectoryPath , '/' , host ) asFilename.
                            dir exists ifFalse:[
                                dir makeDirectory.
                            ].
                            dir := (FaceDirectoryPath , '/' , host , '/' , user) asFilename.
                            dir exists ifFalse:[
                                dir makeDirectory.
                            ].
                            fullString := BlitImageReader uncompressString:faceString.
                            f := (FaceDirectoryPath , '/' , host , '/' , user , '/48x48x1') asFilename.
                            s := f writeStream.
                            s nextPutAll:fullString.
                            s close.
                        ]
                    ].
                ].
                ^ img
            ].
        ].
    ].

    "/
    "/ if FaceDirectoryPath is nonNil, try there
    "/
    FaceDirectoryPath notNil ifTrue:[
        origin notNil ifTrue:[

"/ Transcript showCR:'try ' , host , ' / ' , user.
            (dir := (FaceDirectoryPath , '/' , host , '/' , user) asFilename) exists ifFalse:[
                notFound := true.
                [(host includes:$.) and:[notFound]] whileTrue:[
                    "/
                    "/ strip off sub-host and try again
                    "/
                    host := host copyFrom:(host indexOf:$.)+1.
"/ Transcript showCR:'try ' , host , ' / ' , user.
                    notFound := (dir := (FaceDirectoryPath , '/' , host , '/' , user) asFilename) exists not
                ].
            ].
            dir notNil ifTrue:[
                "/
                "/ that directory should either contain a face-image for the user,
                "/ or a directory containing a single 48x48x1 file
                "/
                dir isDirectory ifTrue:[
                    (dir pathName , '/48x48x1') asFilename exists ifTrue:[
                        img := BlitImageReader fromFile:(dir pathName , '/48x48x1').
                    ]    
                ] ifFalse:[
                    dir exists ifTrue:[
                        img := Image fromFile:dir pathName
                    ]
                ].
                img notNil ifTrue:[^img].
            ]
        ].
        (dir := (FaceDirectoryPath , '/' , user) asFilename) exists ifTrue:[
            dir isDirectory ifTrue:[
                (dir pathName , '/48x48x1') asFilename exists ifTrue:[
                    img := BlitImageReader fromFile:(dir pathName , '/48x48x1').
                ]
            ] ifFalse:[
                dir exists ifTrue:[
                    img := Image fromFile:dir pathName
                ]
            ].
            img notNil ifTrue:[^img].
        ].
        (dir := (FaceDirectoryPath , '/' , user , '.xpm') asFilename) exists ifTrue:[
            img := Image fromFile:dir pathName.
            img notNil ifTrue:[^img].
        ].
    ].

    BlitImageReader notNil ifTrue:[
        user notNil ifTrue:[
            (user , '.48x48x1') asFilename exists ifTrue:[
                (img := BlitImageReader fromFile:(user , '.48x48x1')) notNil ifTrue:[^ img].
            ]    
        ].
        (img := BlitImageReader fromFile:'unknown.48x48x1') notNil ifTrue:[^ img].
    ].

    ^ nil

    "
     FaceDirectoryPath := '/usr/local/lib/faces'
    "

    "Created: 17.11.1995 / 12:53:54 / cg"
    "Modified: 18.6.1996 / 14:44:53 / cg"
!

fullLetter:mailNr
    "read mail entry, return a MailLetter containing all text (includes all relay stuff)"

    |lines|

    lines := self fullLetterText:mailNr.
    lines isNil ifTrue:[^ nil].
    ^ (MailLetter new type:#text) contents:lines

    "Created: 17.11.1995 / 00:13:19 / cg"
!

fullLetterText:mailNr
    "read mail entry, return a MailLetter containing all text (includes all relay stuff)"

    |firstPosition lastPosition line lines 
     moreToRead hasAttachment ignore|

    headerStartPositions isNil ifTrue:[^ nil].

    firstPosition := headerStartPositions at:mailNr.
    lastPosition := headerEndPositions at:mailNr.

    lines := OrderedCollection new:100.

    mailFile position:firstPosition.
    line := mailFile nextLine.
    moreToRead := true.
    ignore := false.
    hasAttachment := false.

    [moreToRead] whileTrue:[
	ignore := false.

	(line startsWith:'Next-Attachment:') ifTrue:[
	    hasAttachment := true
	].

	hasAttachment ifTrue:[
	    (line startsWith:'begin') ifTrue:[
		lines add:line.
		lines add:' ...'.
		lines add:'end'.
		moreToRead := false.
		ignore := true
	    ]
	].

	ignore ifFalse:[
	    lines add:line.
	].
	line := mailFile nextLine.
	line isNil ifTrue:[
	    moreToRead := false
	].
	((mailFile position) > lastPosition) ifTrue: [
	    moreToRead := false
	]
    ].
    ^ lines

    "Created: 17.11.1995 / 00:12:43 / cg"
!

headerLines
    "return a collection filled with From-lines"

    |numberOfLetters spec|

    headerLines notNil ifTrue:[ ^ headerLines ].

    numberOfLetters := self numberOfLetters. "/ headerStartPositions size.
    numberOfLetters == 0 ifTrue: [
        headerLines := OrderedCollection with:'no mail'.
        ^ headerLines
    ].

    MultiColListEntry notNil ifTrue:[
        spec := TabulatorSpecification new.
        spec unit:#inch.
        spec positions:#(0 0.5 4).
        spec align:    #left.
    ].

    headerLines := OrderedCollection new:numberOfLetters.
    1 to:numberOfLetters do:[:mailNr|
        |line info|

        MultiColListEntry notNil ifTrue:[
            info := self summaryOf:mailNr.
            line := MultiColListEntry new:3.
            line tabulatorSpecification:spec.
            info isNil ifTrue:[
                line colAt:1 put:'?'.
                line colAt:2 put:'?'.
                line colAt:3 put:'?'.
            ] ifFalse:[
                line colAt:1 put:((info at:#read) ifTrue:'R' ifFalse:' ').
                line colAt:2 put:(info at:#name).
                line colAt:3 put:(info at:#subject).
            ]
        ] ifFalse:[
            line := self summaryLineOf:mailNr.
        ].
        headerLines add:line
    ].
    ^ headerLines

    "Created: 17.11.1995 / 10:09:56 / cg"
    "Modified: 18.6.1996 / 13:51:30 / cg"
!

headerText:mailNr
    "read mail entry, return a collection of the letters header lines"

    |firstPosition lastPosition line lines moreToRead|

    cachedHeaderNr == mailNr ifTrue:[
	^ cachedHeader
    ].

    headerStartPositions isNil ifTrue:[^ nil].

    firstPosition := headerStartPositions at:mailNr.
    lastPosition := headerEndPositions at:mailNr.

    lines := OrderedCollection new:100.

    mailFile position:firstPosition.
    line := mailFile nextLine.
    moreToRead := true.

    [moreToRead] whileTrue:[
	line := mailFile nextLine.
	line isNil ifTrue:[
	    moreToRead := false
	].
	line isEmpty ifTrue:[
	    moreToRead := false
	].
	moreToRead ifTrue:[
	    lines add:line
	].
	((mailFile position) > lastPosition) ifTrue: [
	    moreToRead := false
	]
    ].
    cachedHeaderNr := mailNr.
    cachedHeader := lines.
    ^ lines

    "Created: 17.11.1995 / 00:12:43 / cg"
    "Modified: 17.11.1995 / 14:19:10 / cg"
!

letter:mailNr
    "read mail entry, remove all unneeded text (inserted by relay-mailers),
     return a MailLetter containing the entry."

    | line index lines l info |

    tempDirName notNil ifTrue:[
        OperatingSystem executeCommand:('rm -rf ' , tempDirName).
        OperatingSystem executeCommand:('mkdir ' , tempDirName).
    ].

    lines := self fullLetterText:mailNr.
    lines isNil ifTrue:[^ nil].

    info := self summaryFromLines:lines.

    index := lines findFirst:[:l | l isBlank].
    lines removeFromIndex:1 toIndex:index.

    ^ self extractLetterFrom:lines info:info

    "Created: 17.11.1995 / 00:11:16 / cg"
    "Modified: 18.6.1996 / 15:22:10 / cg"
!

numberOfLetters
    "answer the number of letters in mail"

    self scanMailFile.
    ^ headerStartPositions size
!

originOf:mailNr
    "extract origin of mail out of the From-line"

    |info|

    (info := self summaryOf:mailNr) isNil ifTrue:[^ nil].
    ^ info at:#origin ifAbsent:nil

    "Created: 17.11.1995 / 14:39:49 / cg"
!

restoreMailBaox
    "unmark all deleted messages, reset the state to
     the initial state"

    self scanMailFile.
!

sendMail:someText subject:subject cc:cc to:anAddress
    "send someText, aString to the destination anAddress, also a string"

    |stream|

    self class listOfMailers do:[:mailer |
	stream isNil ifTrue:[
	    mailer asFilename isExecutableProgram ifTrue:[  
		stream := PipeStream writingTo:(mailer , ' ' , anAddress).
	    ]
	]
    ].
    stream isNil ifTrue:[
	self warn:'cannot open pipe to mail program.

Saving letter in unsent.letter.'.
	stream := 'unsent.letter' asFilename writeStream.
	stream nextPutAll:someText.
	stream close.
	^ self
    ].

    (subject notNil and:[subject isBlank not]) ifTrue:[
	stream nextPutAll:('Subject: ' , subject).
	stream cr
    ].
    (cc notNil and:[cc isBlank not]) ifTrue:[
	stream nextPutAll:('CC: ' , cc).
	stream cr
    ].
    stream nextPutAll:someText.
    stream close

    "Modified: 3.11.1995 / 11:56:29 / cg"
!

sendMail:someText to:anAddress
    "send someText, aString to the destination anAddress, also a string"

    self sendMail:someText subject:nil cc:nil to:anAddress
!

subjectOf:mailNr
    "answer the subject of letter #mailNr"

    |info|

    info := self summaryOf:mailNr.
    info isNil ifTrue:[^ nil].
    ^ info at:#subject.

    "Created: 17.11.1995 / 10:22:43 / cg"
    "Modified: 17.11.1995 / 12:44:10 / cg"
!

summaryFromLines:lines
    "extract a headers info consisting of: status, origin, date and subject"

    |fromLine fromLine2 subjectLine statusLine summary
     address name dateString date status subject dateLine faceString
     line index index2 moreToRead hasBeenRead idx l origin|

    summary := IdentityDictionary new.

    index := 1. line := lines at:index.
    moreToRead := true.
    [moreToRead] whileTrue:[
	l := line asString asUppercase.

	(l startsWith:'NEXT-ATTACHMENT:') ifTrue:[
	    summary at:#'NEXT-ATTACHMENT:' put:(line copyFrom:17)
	] ifFalse:[
	    (l startsWith:'CONTENT-TYPE:') ifTrue:[
		summary at:#'CONTENT-TYPE:' put:(line copyFrom:15)
	    ] ifFalse:[
		(l startsWith:'CONTENT-TRANSFER-ENCODING:') ifTrue:[
		    summary at:#'CONTENT-TRANSFER-ENCODING:' put:(line copyFrom:28)
		] ifFalse:[
		    (fromLine isNil and:[l startsWith:'FROM ']) ifTrue:[
			fromLine := line copyFrom:6
		    ] ifFalse:[
			(dateLine isNil and:[l startsWith:'DATE: ']) ifTrue:[
			    dateLine := line copyFrom:7
			] ifFalse:[
			    (subjectLine isNil and:[l startsWith:'SUBJECT: ']) ifTrue:[
				subjectLine := line copyFrom:10 
			    ] ifFalse:[
				(statusLine isNil and:[l startsWith:'STATUS: ']) ifTrue:[
				    statusLine := line copyFrom:9
				] ifFalse: [
				    (fromLine2 isNil and:[l startsWith:'FROM: ']) ifTrue:[
					fromLine2 := line copyFrom:7 
				    ] ifFalse:[
					(faceString isNil and:[l startsWith:'X-FACE: ']) ifTrue:[
					    faceString := (line copyFrom:9) withoutSeparators.
					    [(index < lines size)
					    and:[(l := lines at:(index + 1)) isEmpty not
					    and:[l isBlank not
					    and:[(l at:1) isSeparator]]]] whileTrue:[
						index := index + 1.    
						faceString := faceString , l withoutSeparators.
					    ]
					]
				    ]
				]
			    ]
			]
		    ].
		]
	    ].
	].

	moreToRead ifTrue:[
	    index := index + 1.
	    index > lines size ifTrue:[moreToRead := false]
	    ifFalse:[
		line := lines at:index.
		(line isNil or:[line isBlank]) ifTrue:[
		    moreToRead := false
		]
	    ].
	]
    ].

    "now:
	fromLine:    first line matching 'From '
	fromLine2:                       'From: '
	subjectLine:                     'Subject: '
	statusLine:                      'Status: '
    "

    "extract date and email address from fromLine ...
     (format is 'From address date')"

    dateLine notNil ifTrue:[
	dateString := dateLine.
    ].

    fromLine isNil ifTrue:[
	address := 'BAD-ADDRESS'
    ] ifFalse:[
	index := fromLine indexOf:(Character space).
	(index == 0) ifTrue:[
	    address := fromLine
	] ifFalse:[
	    address := fromLine copyTo:(index - 1).
	    dateString isNil ifTrue:[
		dateString := fromLine copyFrom:(index + 1)
	    ]
	]
    ].
    dateString isNil ifTrue:[
	dateString := ''
    ].

    "extract real-life name from fromline2 (if present).
     some From:-lines contain full-name; format is varying (sigh)
     we recognize: 'From: '' full name '' ..... '
		   'From: full name <origin>'
		   'From: origin (full name)'
    "
    name := nil.
    fromLine2 notNil ifTrue:[
	"try name in double quotes"
	index := fromLine2 indexOf:(Character doubleQuote).
	(index == 0) ifFalse:[
	    index2 := fromLine2 indexOf:(Character doubleQuote)
			     startingAt:(index + 1).
	    (index2 ~~ 0) ifTrue:[
		name := fromLine2 copyFrom:(index + 1) to:(index2 - 1)
	    ]
	].

	"/
	"/ look for < ... > if no name found yet, take stuff before that as name
	"/  extract origin from the stuff in-between
	"/
	index := fromLine2 indexOf:$<.
	(index ~~ 0) ifTrue:[
	    index2 := fromLine2 indexOf:$> startingAt:(index + 1).
	    (index2 ~~ 0) ifTrue:[
		name isNil ifTrue:[
		    name := fromLine2 copyTo:(index - 1)
		].
		origin := fromLine2 copyFrom:(index + 1) to:(index2 - 1).
	    ]
	].

	(name isNil or:[origin isNil]) ifTrue:[
	    "try name in ( ... )"
	    index := fromLine2 indexOf:$(.
	    (index == 0) ifFalse:[
		index2 := fromLine2 indexOf:$) startingAt:(index + 1).
		(index2 ~~ 0) ifTrue:[
		    name isNil ifTrue:[
			name := fromLine2 copyFrom:(index + 1) to:(index2 - 1)
		    ].
		    origin isNil ifTrue:[
			origin := fromLine2 copyTo:(index - 1)
		    ]
		]
	    ].
	].
	name isNil ifTrue:[
	    "no, take rest of fromline2 as name"
	    name := fromLine2 
	]
    ].

    "no real name found - take reply address"
    name isNil ifTrue:[
	name := address
    ].

    name notNil ifTrue:[
	name := name withoutSpaces
    ].

    (origin isNil and:[name notNil]) ifTrue:[
	origin := name
    ].

    hasBeenRead := false.

    statusLine isNil ifTrue:[
	status := '  '
    ] ifFalse:[
	hasBeenRead := statusLine includes:$R
    ].

    subjectLine isNil ifTrue:[
	subject := ''
    ] ifFalse:[
	subject := subjectLine 
    ].

    summary at:#read put:hasBeenRead.
    summary at:#name put:name.
    summary at:#date put:dateString.
    summary at:#subject put:subject.
    summary at:#faceString put:faceString.
    origin notNil ifTrue:[
	summary at:#origin put:origin.
    ].
    ^ summary

    "Created: 17.11.1995 / 10:08:49 / cg"
    "Modified: 17.11.1995 / 17:08:53 / cg"
!

summaryLineOf:mailNr
    "extract a header line consisting of: status, origin, date and subject"

    |summaryLine summary subject|

    (summary := self summaryOf:mailNr) isNil ifTrue:[^ nil].

    (summary at:#read) ifFalse:[
	summaryLine := 'U '
    ] ifTrue:[
	summaryLine := '  '
    ].
    summaryLine := summaryLine , (summary at:#name).
    (subject := summary at:#subject) notNil ifTrue:[
	summaryLine := summaryLine , ' '
		   , (Character doubleQuote asString)
		   , subject withoutSpaces
		   , (Character doubleQuote asString)
    ].
    ^ summaryLine

    "Created: 17.11.1995 / 10:08:49 / cg"
    "Modified: 17.11.1995 / 14:10:42 / cg"
!

summaryOf:mailNr
    "extract a headers info consisting of: status, origin, date and subject"

    |lines|

    lines := self headerText:mailNr.
    lines isNil ifTrue:[^ nil].
    lines isEmpty ifTrue:[^ nil].

    ^ self summaryFromLines:lines

    "Created: 17.11.1995 / 16:54:23 / cg"
    "Modified: 18.6.1996 / 13:50:40 / cg"
!

xxoriginOf:mailNr
    "extract origin of mail out of the From-line"

    |firstPosition lastPosition line
     fromLine address blankIndex moreToRead idx1 idx2|

    headerStartPositions isNil ifTrue:[^ nil].

    firstPosition := headerStartPositions at:mailNr.
    lastPosition := headerEndPositions at:mailNr.

    mailFile position:firstPosition.
    line := mailFile nextLine.
    moreToRead := true.
    [moreToRead] whileTrue:[
	(line startsWith:'From: ') ifTrue:[
	    fromLine := line.
	    moreToRead := false
	] ifFalse:[
	    line := mailFile nextLine.
	    moreToRead := line notNil.
	    ((mailFile position) >= lastPosition) ifTrue: [
		moreToRead := false
	    ]
	]
    ].
    fromLine isNil ifTrue:[^ nil].

    "
     look for <....> address
    "
    idx1 := fromLine indexOf:$<.
    idx1 ~~ 0 ifTrue:[
	idx2 := fromLine indexOf:$> startingAt:idx1 + 1.
	idx2 ~~ 0 ifTrue:[
	    address := fromLine copyFrom:idx1+1 to:idx2-1.
	    ^ address
	]
    ].

    blankIndex := fromLine
			indexOf:(Character space)
			startingAt:7.
    (blankIndex == 0) ifTrue:[
	address := fromLine copyFrom:7 to:(fromLine size)
    ] ifFalse:[
	address := fromLine copyFrom:7 to:(blankIndex - 1)
    ].
    ^ address

    "Created: 17.11.1995 / 14:23:37 / cg"
! !

!MailHandler methodsFor:'converting'!

convertImageGIF:lines encoding:encodingLine
    "no image support at the moment - return the letters raw text for now"

    ^ (MailLetter new type:#text) contents:lines
!

convertImageJPG:lines encoding:encodingLine
    "no image support at the moment - return the letters raw text for now"

    ^ (MailLetter new type:#text) contents:lines
!

convertPlainDocument:lines encoding:encodingLine
    "plain text - just decode and return as text"

    ^ (MailLetter new type:#text) contents:(self decodeText:lines encoding:encodingLine)
!

convertPostscriptDocument:lines encoding:encoding info:info
    "/ send the text to ghostscript;
    "/ let it convert it to a bitmap image

    |img f s path|

    f := Filename newTemporary.
    s := f writeStream.
    lines do:[:line | s nextPutAll:line; cr].
    s close.

    self activityNotification:'asking ghostscript for conversion ...'.

    path := f pathName.
    Processor activeProcess withPriority:7 do:[
        OperatingSystem executeCommand:'gs -sDEVICE=tifflzw -r150 -sOutputFile=' , (path , '.tiff') , ' -dNOPAUSE -q ' , path , ' -c quit'.

        img := Image fromFile:(path , '.tiff').
    ].
    f remove.
    (path , '.tiff') asFilename remove.

    ^ (MailLetter new type:#image) contents:img.

    "Created: 18.6.1996 / 15:27:06 / cg"
    "Modified: 18.6.1996 / 16:56:22 / cg"
!

convertRichtextDocument:lines encoding:encodingLine
    "richtext - just decode and return as text"

    ^ (MailLetter new type:#text) contents:(self decodeText:lines encoding:encodingLine)
! !

!MailHandler methodsFor:'decoding'!

decodeBase64:lines
    "see mime spec on whats going on here"

    |s in out 
     count "{ Class: SmallInteger }"
     bits  "{ Class: SmallInteger } - collects bits"
     b6    "{ Class: SmallInteger } - 6 encoded bits"
     pad atEnd c b|

    s := lines asString.
    in := ReadStream on:s.
    out := WriteStream on:(ByteArray new:s size * 3 // 2).
    count := 0.
    bits := 0.
    atEnd := in atEnd.

    [atEnd] whileFalse:[
        c := in next.
        atEnd := in atEnd.

        ((c >= $A) and:[c <= $Z]) ifTrue:[
            b := c asciiValue - $A asciiValue
        ] ifFalse:[
            ((c >= $a) and:[c <= $z]) ifTrue:[
                b := c asciiValue - $a asciiValue + 26
            ] ifFalse:[
                ((c >= $0) and:[c <= $9]) ifTrue:[
                    b := c asciiValue - $0 asciiValue + 52
                ] ifFalse:[
                    c == $+ ifTrue:[
                        b := 62
                    ] ifFalse:[
                        c == $/ ifTrue:[
                            b := 63
                        ] ifFalse:[
                            b := nil.
                        ]
                    ]
                ]
            ]
        ].
        b notNil ifTrue:[
            b6 := b.

            bits := bits bitShift:6.
            bits := bits + b6.

"/          bits := (bits bitShift:6) + b6.
            count := count + 1.
            count == 4 ifTrue:[
                out nextPut:((bits bitShift:-16) bitAnd:16rFF).
                out nextPut:((bits bitShift:-8) bitAnd:16rFF).
                out nextPut:(bits bitAnd:16rFF).
                count := 0.
                bits := 0.

            ]
        ] ifFalse:[
            "other character - might be padding"
            c == $= ifTrue:[
                pad := 1.
                c := in next.
                c == $= ifTrue:[
                    pad := 2.
                ].
                atEnd := true
            ] ifFalse:[
                c == $- ifTrue:[
                    pad := 0.      "will add 0-bytes if not padded correctly"
                    atEnd := true
                ]
            ]
        ]
    ].

    count ~~ 0 ifTrue:[
        "at end, special considerations"

        [count ~~ 4] whileTrue:[
            bits := bits bitShift:6.
            count := count + 1.
        ].

        pad == 2 ifTrue:[
            "only one valid byte"
            out nextPut:((bits bitShift:-16) bitAnd:16rFF).
        ] ifFalse:[
            pad == 1 ifTrue:[
                out nextPut:((bits bitShift:-16) bitAnd:16rFF).
                out nextPut:((bits bitShift:-8) bitAnd:16rFF).
            ] ifFalse:[
                "pad zero - add zero bytes"
                out nextPut:((bits bitShift:-16) bitAnd:16rFF).
                out nextPut:((bits bitShift:-8) bitAnd:16rFF).
                out nextPut:(bits bitAnd:16rFF).
            ]
        ]
    ].
    ^ out contents

    "Modified: 5.5.1997 / 17:44:10 / cg"
!

decodeQuotedPrintable:lines
    |s in out skippingSpace spaceCount c hex1 hex2 hex val|

    s := lines asString.
    in := ReadStream on:s.
    out := WriteStream on:(String new:s size).
    skippingSpace := false.
    spaceCount := 0.
    [in atEnd] whileFalse:[
	c := in next.
	c == Character space ifTrue:[
	    skippingSpace ifFalse:[
		spaceCount := spaceCount + 1.
	    ]
	] ifFalse:[
	    "there is something"
	    skippingSpace := false.
	    c == Character cr ifTrue:[
		spaceCount := 0.
		out cr
	    ] ifFalse:[
		spaceCount ~~ 0 ifTrue:[
		    out spaces:spaceCount.
		    spaceCount := 0
		].
		(c == $=) ifTrue:[            "Rule 1"
		    hex1 := in next.
		    hex1 == Character cr ifTrue:[
			"a soft line break"
			spaceCount := 0
		    ] ifFalse:[
			hex2 := in next.
			hex2 == Character cr ifTrue:[
			    "half of a hex ?"
			    hex := hex1 asString.
			    val := Integer readFrom:(ReadStream on:hex) radix:16.
			    out nextPut:(Character value:val).
			    spaceCount := 0
			] ifFalse:[
			    hex := hex1 asString copyWith:hex2.
			    val := Integer readFrom:(ReadStream on:hex) radix:16.
			    out nextPut:(Character value:val)
			]
		    ]
		] ifFalse:[
		    out nextPut:c
		]
	    ].
	]
    ].
    ^ out contents asText
!

decodeText:lines encoding:encodingLine
    encodingLine notNil ifTrue:[
	(encodingLine asLowercase startsWith:'quoted-printable') ifTrue:[
	    ^ self decodeQuotedPrintable:lines
	].
	(encodingLine asLowercase startsWith:'base64') ifTrue:[
	    ^ (self decodeBase64:lines) asString
	].
    ].
    "default: as is"
    ^ lines
! !

!MailHandler methodsFor:'initialization'!

initialize
    "initialize myself - scan through mailfile - get letter-positions"

    |pid|

    anyChanges := false.
    canLock := false.

    tempDirName := OperatingSystem getHomeDirectory asFilename construct:'STmail'.
    (tempDirName exists) ifFalse:[
        tempDirName makeDirectory.
        (tempDirName exists) ifFalse:[
            self notify:'cannot create temporary directory'.
            ^ self
        ]
    ].

    canLock := self setMailLock.
    self openMailFile.
    (mailFile notNil) ifTrue:[
        self scanMailFile
    ].
    canLock ifTrue:[
        self releaseMailLock
    ]

    "Modified: / 16.2.2000 / 09:18:32 / cg"
! !

!MailHandler methodsFor:'locking'!

createLockLink:lockName from:tmpName
    "try to create a lock file, return true if successful.
     Only try for some time, then give up"

    10 timesRepeat:[
	(OperatingSystem linkFile:tmpName to:lockName) ifTrue:[^ true].
	Transcript showCR:'mail locked - please wait a bit'.
	Transcript endEntry.
	OperatingSystem sleep:1
    ].
    self warn:('could not create mail-lock; mailbox may only be read.\\or remove ' , lockName , ' if lock is a leftover.') withCRs.
    ^ false
!

releaseMailLock
    OperatingSystem removeFile:lockFileName
!

setMailLock
    "create a lock file - stupid, mailers differ in how they lock,
     (I'm not even aware of how some of them do it ...).
     Return true if we have the lock, false if locking is not possible."

    |lockDir mailDir tmpName stream pid userName|

    userName := OperatingSystem getLoginName.

    (OperatingSystem getOSType = 'sunos') ifTrue:[
        "sunos uses a <username>.lock file in the mail-spool directory, which is empty"

        lockFileName := '/usr/spool/mail/' , userName , '.lock'.
        tmpName := '/usr/spool/mail/' , userName, '.' 
                                      , OperatingSystem getProcessId printString , '.tmp'.
        "create a temp file first ..."

        (FileStream newFileNamed:tmpName) isNil ifTrue:[
            self warn:'cannot create temporary for lock. Mailbox may only be read.'.
            ^ false
        ].

        (self createLockLink:lockFileName from:tmpName) ifFalse:[
            OperatingSystem removeFile:tmpName.
            self warn:'cannot greate lockfile. Mailbox may only be read.'.
            ^ false
        ].

        OperatingSystem removeFile:tmpName.
        ^ true
    ].

    "I cant remember if this works ..."
    (OperatingSystem getOSType = 'sco') ifTrue:[
        "sco uses a LCK..<pid> file in the mail-lock directory, which contains the pid"

        pid := OperatingSystem getProcessId printString.
        mailDir := FileDirectory directoryNamed:'/usr/mail'.
        mailDir isNil ifTrue:[
            self warn:'no mail directory'.
            ^ false
        ].

        lockDir := FileDirectory directoryNamed:'/usr/mail/:saved'.
        lockDir isNil ifTrue:[
            self warn:'no maillock directory. Mailbox may only be read.'.
            ^ false
        ].
        tmpName = 'LCK..' , pid.
        stream := FileStream newFileNamed:tmpName in:lockDir.
        stream isNil ifTrue:[
            self warn:'cannot create temporary lock file. Mailbox may only be read.'.
            ^ false
        ].
        stream nextPutAll:pid.
        stream close.

        lockFileName := userName , '.lock'.
        (self createLockLink:lockFileName from:('/usr/mail/:saved/' , tmpName)) ifFalse:[
            self warn:'cannot create lock file. Mailbox may only be read.'.
            ^ false
        ].
        lockDir removeFile:tmpName.
        ^ true
    ].

    "I ony know how to do it in the above systems - for others, code has to be
     added ..."

    self warn:'don''t know how to set a mail lock in this system.
Please implement this functionality in MailHandler>>setMailLock and
return the code to cg@exept.de. Sorry for the inconvenience.'.

    ^ false

    "Modified: / 16.2.2000 / 09:09:59 / cg"
! !

!MailHandler methodsFor:'misc'!

createTemporaryNewMailFile
    ^ self openMailFile:'.tmp' withMode:#writing
!

needToUpdateMailFile
    "return true, if the mailBox needs to be rewritten.
     i.e. if any changes where made (deletions)"

    ^ mailFile notNil 
      and:[anyChanges
      and:[canLock]]
!

openMailFile
    mailFile := self openMailFile:'' withMode:#readonly
!

openMailFile:extension withMode:how
    "try to open the mail file - it looks for it in '/usr/spool/mail and '/usr/mail'"

    | mailFileName stream |

    userName := OperatingSystem getLoginName.
    userName isNil ifTrue:[
        self error:'who are you'.
        ^ nil
    ].
    "try following mailboxes:
                              MAILFILE global  
                              $MAIL from environment,
                              /usr/spool/mail/<USERNAME>
                              /usr/mail/<USERNAME>
    "

    mailFileName := Smalltalk at:#MAILFILE ifAbsent:nil.
    mailFileName isNil ifTrue:[
        mailFileName := OperatingSystem getEnvironment:'MAIL'.
        mailFileName isNil ifTrue:[
            '/usr/spool/mail' asFilename exists ifTrue:[
                mailDirName := '/usr/spool/mail'
            ] ifFalse:[
                mailDirName := '/usr/mail'
            ].

            mailDirName asFilename exists ifFalse:[
                self warn:'no mail directory'.
                mailDirName := nil.
                ^ nil
            ].
            mailFileName := mailDirName , '/' , userName , extension.
        ].
    ].

    how == #readonly ifTrue:[
        stream := FileStream readonlyFileNamed:mailFileName.
    ] ifFalse:[
        stream := FileStream newFileNamed:mailFileName.
    ].
    ^ stream
!

release
    "release the mailbox - if any changes where made (i.e deletions),
     write back mailbox"

    mailFile notNil ifTrue:[
	mailFile close.
	mailFile := nil.
	OperatingSystem executeCommand:('rm -rf ' , tempDirName).
	(anyChanges and:[canLock]) ifTrue:[
	    self updateMailFile
	]
    ]
!

scanMailFile
    "read mail file, fill startPosition and endPositions with From-line positions"

    |line n|

    "no mail yet ? "
    mailFile isNil ifTrue:[self openMailFile].

    "still no mail"
    mailFile isNil ifTrue:[
	headerStartPositions := nil.
	headerEndPositions := nil.
	^ self
    ].

    "size has not changed - just return"
    (mailFileSize == mailFile size) ifTrue:[^ self].

    "preallocating a bigger array avoids reallocating in grow ..."
    headerStartPositions := OrderedCollection new.

    mailFile position:1.
    mailFileSize := mailFile size.
    line := mailFile peekForLineStartingWith:'From '.
    [line notNil] whileTrue:[
	headerStartPositions add:(mailFile position).
	line := mailFile nextLine.
	line := mailFile peekForLineStartingWith:'From '
    ].

    n := headerStartPositions size.
    headerEndPositions := OrderedCollection new:n.
    1 to:n-1 do:[:index |
	headerEndPositions add:(headerStartPositions at:(index + 1))
    ].
    headerEndPositions add:mailFileSize.
    headerLines := nil
!

tempFilePath
    "answer the directory name where temporary files are stored
     i.e. where attachments where extracted"

    ^ tempDirName
!

updateMailFile
    "update the mailbox file"

    |again stream letter text mailFileName|

    [self setMailLock] whileFalse:[
	again := self confirm:'could not lock mail file - try again ?'.
	again ifFalse:[^ false].
    ].

    stream := self createTemporaryNewMailFile.
    stream isNil ifTrue:[
	self warn:'cannot create new mailbox file'.
	^ false
    ].

    "simply append all left over mails ..."

    1 to: self numberOfLetters do:[:index |
	letter := self fullLetter:index.
	text := letter contents.
	text do:[:aLine |
	    stream nextPutAll:aLine.
	    stream cr.
	]
    ].
    stream close.

    "now replace mailbox file by new file"

    mailFileName := mailDirName , '/' , OperatingSystem getLoginName.

    "during development of MailHandler - its a good idea to keep
     the previous mail in a backup - remove next line, when you think
     handler is ok"

    mailFileName asFilename renameTo:(mailFileName , '.bak').
    (mailFileName , '.tmp') asFilename renameTo:mailFileName.

    self releaseMailLock.
! !

!MailHandler methodsFor:'private'!

extractSubjectFromHeader:headerLineCollection
    "answer the subject of letter #mailNr"

    |firstPosition lastPosition line
     subjectLine address blankIndex moreToRead |

    headerLineCollection do:[:line |
	(line startsWith:'Subject: ') ifTrue:[
	    subjectLine := line.
	]
    ].
    subjectLine isNil ifTrue:[^ nil].
    ^ subjectLine copyFrom:10

    "Created: 16.11.1995 / 23:58:08 / cg"
!

hostFromOrigin:origin
    "given an origin (such as user@host.domain),
     extract the host name"

    |idx host|

    ((idx := origin indexOf:$@) ~~ 0) ifTrue:[
	host := origin copyFrom:idx + 1.
	^ host
    ].
    (host := OperatingSystem getDomainName) notNil ifTrue:[^ host].
    (host := OperatingSystem getHostName) notNil ifTrue:[^ host]. 
        
    ^ 'localhost'

    "Created: 17.11.1995 / 14:42:01 / cg"
    "Modified: 17.11.1995 / 15:04:06 / cg"
!

isMailerInfo:line
    "answer true, if the argument line is a mailer-info text line"

    |l|

    l := line asLowercase.
    (l startsWith:'x-: ') ifTrue:[^ true].
    (l startsWith:'in-reply-to: ') ifTrue:[^ true].
    (l startsWith:'apparently-to: ') ifTrue:[^ true].
    (l startsWith:'message-id: ') ifTrue:[^ true].
    (l startsWith:'mailed-from: ') ifTrue:[^ true].
    (l startsWith:'return-path: ') ifTrue:[^ true].
    (l startsWith:'posted-date: ') ifTrue:[^ true].
    (l startsWith:'cc: ') ifTrue:[^ true].
"/    (l startsWith:'x-mailer: ') ifTrue:[^ true].
"/    (l startsWith:'x-nx-transport-id: ') ifTrue:[^ true].
    (l startsWith:'sender: ') ifTrue:[^ true].
    (l startsWith:'status: ') ifTrue:[^ true].
    (l startsWith:'to: ') ifTrue:[^ true].
    (l startsWith:'from: ') ifTrue:[^ true].
    (l startsWith:'received: ') ifTrue:[^ true].
    (l startsWith:'via: ') ifTrue:[^ true].
    (l startsWith:'next-attachment: ') ifTrue:[^ true].
    (l startsWith:'mime-version: ') ifTrue:[^ true].
    (l startsWith:'content-type: ') ifTrue:[^ true].
    (l startsWith:'content-transfer-encoding: ') ifTrue:[^ true].
    (l startsWith:'content-length: ') ifTrue:[^ true].
    (l startsWith:'content-description: ') ifTrue:[^ true].
    (l startsWith:'keywords: ') ifTrue:[^ true].
    (l startsWith:'approved: ') ifTrue:[^ true].
    (l startsWith:'followup-to: ') ifTrue:[^ true].
    (l startsWith:'date: ') ifTrue:[^ true].
"/    (l startsWith:'X-POP3-Rcpt: ') ifTrue:[^ true].

    (l = 'cc:') ifTrue:[^ true].
    ^ false

    "Created: 17.11.1995 / 00:05:19 / cg"
    "Modified: 17.11.1995 / 12:04:35 / cg"
!

userFromOrigin:origin
    "given an origin (such as user@host.domain),
     extract the user name"

    |idx host|

    ((idx := origin indexOf:$@) ~~ 0) ifTrue:[
	^ (origin copyTo:idx - 1) withoutSpaces
    ].
    ^ origin withoutSpaces

    "Created: 17.11.1995 / 14:42:01 / cg"
    "Modified: 17.11.1995 / 15:20:15 / cg"
! !

!MailHandler methodsFor:'unwrapping'!

extractLetterFrom:lines info:info
    "convert text-lines to a MailLetter"

    |contentType contentEncodingLine boundaryString l|

    contentType := (info at:#'CONTENT-TYPE:' ifAbsent:'text/plain') asLowercase.

    (contentType startsWith:'text') ifTrue:[
        (contentType startsWith:'text/plain') ifTrue:[
            ^ self convertPlainDocument:lines encoding:contentEncodingLine
        ].
        (contentType startsWith:'text/richtext') ifTrue:[
            ^ self convertRichtextDocument:lines encoding:contentEncodingLine
        ].
        
        "default: present as-is"
        ^ (MailLetter new type:#text) contents:lines
    ].

    (contentType startsWith:'multipart') ifTrue:[
        ^ self unwrapMultipartDocument:lines info:info
    ].

    (contentType startsWith:'image') ifTrue:[
        (contentType startsWith:'image/jpeg') ifTrue:[
            ^ self convertImageJPG:lines encoding:contentEncodingLine info:info
        ].
        (contentType startsWith:'image/gif') ifTrue:[
            ^ self convertImageGIF:lines encoding:contentEncodingLine info:info
        ].
        "default: present as-is"
        ^ (MailLetter new type:#text) contents:lines
    ].

    (contentType startsWith:'application') ifTrue:[
        (contentType startsWith:'application/postscript') ifTrue:[
            ^ self convertPostscriptDocument:lines encoding:contentEncodingLine info:info
        ].
    ].

    "default: present as-is"
    ^ (MailLetter new type:#text) contents:lines

    "Modified: 18.6.1996 / 15:21:09 / cg"
    "Created: 18.6.1996 / 15:22:20 / cg"
!

unwrapMultipartDocument:lines info:info
    "no multipart unwrap at the moment - return the letters raw text for now"

    |type i i0 i1 b part parts|

    type := info at:#'CONTENT-TYPE:'.
    i := type findString:'boundary='.
    i == 0 ifTrue:[
        i := type findString:'BOUNDARY='.
    ].
    i ~~ 0 ifTrue:[
        b := type copyFrom:i + ('boundary=' size).
        i := b indexOfSeparator.
        i == 0 ifTrue:[
           i := b indexOf:$;
        ].
        i ~~ 0 ifTrue:[
            b := b copyTo:i-1
        ].
        b := '--' , b.
        parts := OrderedCollection new.

        i0 := lines findFirst:[:l | l startsWith:b] startingAt:1.
        i0 == 0 ifTrue:[
            i0 := 1
        ].
        [i0 ~~ 0] whileTrue:[
            i1 := lines findFirst:[:l | l startsWith:b] startingAt:i0+1.
            i1 ~~ 0 ifTrue:[
                part := lines copyFrom:i0+1 to:i1-1.
                i0 := i1.
            ] ifFalse:[
                part := lines copyFrom:i0+1.
                i0 := 0.
            ].
            part isEmpty ifFalse:[
                parts add:part.
            ]
        ].

        parts := parts collect:[:aPart |
            |info index|

            info := self summaryFromLines:aPart.
            index := aPart findFirst:[:l | l isBlank].
            aPart removeFromIndex:1 toIndex:index.

            self extractLetterFrom:aPart info:info.
        ].
        ^ (MailLetter new type:#multipart) parts:parts.
    ].
    ^ (MailLetter new type:#text) contents:lines

    "Created: 18.6.1996 / 14:48:58 / cg"
    "Modified: 18.6.1996 / 15:34:57 / cg"
!

unwrapNeXTAttachment:baseName inDirectory:baseDir
    "unwrap all files in an attachment, return a letter containing the rtf-index file contents"

    |command ok stream contents|

    ok := true.
    Transcript showCR:'uudecoding ...'.
    command := 'cd ' , baseDir , '; uudecode < ' , baseName , '.uu'.
    (OperatingSystem executeCommand:command) ifFalse:[
	self warn:'cannot execute uudecode'.
	ok := false.
    ].

    ok ifTrue:[
	Transcript showCR:'uncompressing ...'.
	OperatingSystem executeCommand:('rm -f ' , baseName).
	command := 'cd ' , baseDir , '; uncompress ' , baseName , '.Z'.
	(OperatingSystem executeCommand:command) ifFalse:[
	    self warn:'cannot execute uncompress'.
	    ok := false
	]
    ].

    ok ifTrue:[
	Transcript showCR:'untaring ...'.
	OperatingSystem isBSDlike ifTrue:[
	    command := 'cd ' , baseDir , '; tar xf ' , baseName.
	    (OperatingSystem executeCommand:command) ifFalse:[
		self warn:'tar cannot extract files'.
		ok := false
	    ]
	] ifFalse:[
	    "on sys5 we use my tarx command (if available)
	     - this one also extracts files with long names"
	    command := 'cd ' , baseDir , '; tarx < ' , baseName.
	    (OperatingSystem executeCommand:command) ifFalse:[
		command := 'cd ' , baseDir , '; tar xf ' , baseName.
		(OperatingSystem executeCommand:command) ifFalse:[
		    self warn:'tar cannot extract files'.
		    ok := false
		]
	    ]
	].
    ].

    ok ifTrue:[
	stream := FileStream oldFileNamed:(baseDir , '/index.rtf').
	stream notNil ifTrue:[
	    contents := stream contents.
	    stream close.
	    ^ (MailLetter new type:#rtf) contents:contents 
	]
    ].

    ^ (MailLetter new type:#text) contents:#('failed to extract contents')
! !

!MailHandler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/MailTool/MailHndlr.st,v 1.23 2000-02-16 08:08:08 cg Exp $'
! !
MailHandler initialize!
