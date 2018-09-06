"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

CharacterWriteStream subclass:#TextStream
	instanceVariableNames:'runs currentEmphasis'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams'
!

!TextStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

!

documentation
"
    a textStream is much like a regular writeStream;
    however, in addition to collecting characters, it keeps
    track of any change of the emphasis, and returns a Text instance
    as its contents (in contrast to a String instance).
    Used to collect attributed text.

    [author:]
        Claus Gittinger

    [see also:]
        WriteStream
        Text String
"
!

examples
"
                                                                [exBegin]
     |s|

     s := TextStream on:''.
     s emphasis:#italic;
       nextPutAll:'hello';
       emphasis:nil;
       space;
       emphasis:#bold;
       nextPutAll:'world ';
       nextPut:(Character codePoint:16r3C7).
     s contents inspect
                                                                [exEnd]

                                                                [exBegin]
     |s|

     s := TextStream on:''.
     s emphasis:#italic;
       nextPutAll:'hello';
       emphasis:nil;
       space;
       emphasis:#bold;
       nextPutAll:'world'.

     Transcript nextPutAll:(s contents)
                                                                [exEnd]

                                                                [exBegin]
     |s|

     s := TextStream on:''.
     s emphasis:#italic;
       nextPutAll:'hello';
       emphasis:nil;
       space;
       emphasis:#bold;
       nextPutAll:'world'.

     Dialog
        warn:(s contents)
                                                                [exEnd]

                                                                [exBegin]
     |s1 s2 flipFlop|

     s1 := PipeStream readingFrom:'ls -l'.
     s2 := TextStream on:''.

     flipFlop := true.
     [s1 atEnd] whileFalse:[
        flipFlop ifTrue:[
            s2 emphasis:(#color->Color red)
        ] ifFalse:[
            s2 emphasis:nil
        ].
        flipFlop := flipFlop not.
        s2 nextPutAll:(s1 nextLine).
        s2 cr.
     ].
     s1 close.

     (EditTextView new contents:s2 contents) open
                                                                [exEnd]
"
! !

!TextStream methodsFor:'accessing'!

contents
    "return the streams collected contents"

    |stringContents|

    stringContents := super contents.

    (currentEmphasis isNil and:[runs isEmptyOrNil]) ifTrue:[
        "no emphasis information: answer a string"
        ^ stringContents
    ].
    self closeRun.
    ^ Text string:stringContents emphasisCollection:runs

    "
     Answer a Text containing unicode characters:
         (TextStream on:'')
            emphasis:#italic;
            nextPutAll:'hello';
            emphasis:nil;
            space;
            emphasis:#bold;
            nextPutAll:'world';
            space;
            nextPut:Character euro;
            contents.

     Answer a String:
         (TextStream on:'')
            nextPutAll:'hello';
            contents.

     Answer a Text:
         (TextStream on:Text new)
            nextPutAll:'hello';
            contents.
    "

    "Modified: / 28-01-2011 / 13:46:48 / cg"
!

stringContents
    "return the streams collected string contents"

    ^ super contents

! !

!TextStream methodsFor:'emphasis'!

emphasis
    "return the current emphasis"

    ^ currentEmphasis 
!

emphasis:newEmphasis
    "change the emphasis; all followup elements are appended with
     that emphasis in effect"

    position ~~ 0 ifTrue:[
        currentEmphasis ~= newEmphasis ifTrue:[
            self closeRun.
        ]
    ].
    currentEmphasis := newEmphasis

    "
     |s|

     s := TextStream on:String new.
     s emphasis:#italic;
       nextPutAll:'hello';
       emphasis:nil;
       space;
       emphasis:#bold;
       nextPutAll:'world'.
     s contents.
     Transcript showCR:s contents.
    "

    "
     |s|

     s := TextStream on:String new.
     s emphasis:#italic;
       nextPutAll:'hello';
       emphasis:nil;
       space;
       emphasis:{#bold. #color->Color red};
       nextPutAll:'world'.
     s contents.
     Transcript showCR:s contents.
    "

    "Modified: / 17-02-2011 / 14:13:07 / cg"
! !

!TextStream methodsFor:'private'!

closeRun
    position ~~ 0 ifTrue:[
        runs isNil ifTrue:[
            runs := RunArray new:position withAll:currentEmphasis.
        ] ifFalse:[
            runs add:currentEmphasis withOccurrences:(position-runs size)
        ]
    ]
! !

!TextStream methodsFor:'writing'!

nextPutAllText:aText
    "write some text to the stream and keep the emphasis
     (notice: 
        nextPutAll: ignores the argument's emphasis,
        and instead writes with the current emphasis.
        In contrast, this ignores the current emphasis, and writes with
        the argument's emphasis."

    |string pos oldEmphasis|

    string := aText string.
    pos := 1.

    oldEmphasis := currentEmphasis.
    aText emphasis runsDo:[:len :emphasis |
        |nextPos|

        nextPos := pos + len.

        self emphasis:emphasis.
        self nextPutAll:string startingAt:pos to:nextPos - 1.
        pos := nextPos
    ].
    self emphasis:oldEmphasis

    "
     |t|
     
     t := TextStream new.
     t nextPutAll:'abc'.
     t nextPutAll:('def' allBold).
     t nextPutAllText:('ghi' allBold).
     t nextPutAllText:'jkl'.
     t contents.
     self assert:(t contents sameStringAndEmphasisAs:('abcdef','ghi' allBold,'jkl')).
    "
! !

!TextStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

