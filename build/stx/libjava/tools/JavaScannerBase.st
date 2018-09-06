"
 COPYRIGHT (c) 2003 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjava/tools' }"

Object subclass:#JavaScannerBase
	instanceVariableNames:'typeArray actionArray source lineNr tokenType tokenStartPosition
		tokenEndPosition tokenLineNr numberRadix numberScale hereChar
		peekChar peekChar2 requestor saveComments tokenValue
		scaledMantissaValue parserFlags comments reportNewLine
		reportComments'
	classVariableNames:'Warnings'
	poolDictionaries:''
	category:'Languages-Java-Parser'
!

JavaScannerBase class instanceVariableNames:'TypeArray ActionArray KeywordTable'

"
 No other class instance variables are inherited by this class.
"
!

!JavaScannerBase class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaScannerBase class methodsFor:'initialization'!

initialize
    "initialize the classes defaults. Typically, these are changed
     later in the 'private.rc' file."

"/    ScannerError isLoaded ifFalse:[
"/        ScannerError autoload
"/    ].
"/    EmptySourceNotification notifierString:'empty source given to evaluate'.

    Warnings := false.

    "ActionArray := nil.
     TypeArray := nil.
     self initialize
    "

    "Modified: / 15-03-2012 / 00:05:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupActions
    "initialize the scanners tables - these are used to dispatch
     into scanner methods as characters are read"

    self subclassResponsibility

"/    |block|
"/
"/    ActionArray := Array new:256.
"/    TypeArray := Array new:256.
"/
"/    block := [:s :char | s nextNumber].
"/    ($0 asciiValue) to:($9 asciiValue) do:[:index |
"/        ActionArray at:index put:block
"/    ].
"/
"/    block := [:s :char | s nextIdentifier].
"/    ($a asciiValue) to:($z asciiValue) do:[:index |
"/        ActionArray at:index put:block
"/    ].
"/    ($A asciiValue) to:($Z asciiValue) do:[:index |
"/        ActionArray at:index put:block
"/    ].
"/    ActionArray at:$_ asciiValue put:block
"/
! !

!JavaScannerBase class methodsFor:'instance creation'!

for:aStringOrStream
    "create & return a new scanner reading from aStringOrStream"

    ^ (super new) initializeFor:aStringOrStream

    "Modified: 23.5.1997 / 12:08:42 / cg"
!

new
    "create & return a new scanner"

    ^ self basicNew initialize.

    "Modified: / 23.5.1997 / 12:08:42 / cg"
    "Created: / 26.5.1999 / 12:02:16 / stefan"
! !

!JavaScannerBase class methodsFor:'Signal constants'!

emptySourceNotificationSignal
    ^ EmptySourceNotification

    "Created: / 16.5.1998 / 15:55:14 / cg"
!

errorSignal
    ^ ScannerError

    "Created: / 16.5.1998 / 15:55:14 / cg"
!

scannerErrorSignal
    ^ ScannerError

    "Created: / 16.5.1998 / 15:55:14 / cg"
!

warningSignal
    ^ ScannerWarning

    "Created: / 16.5.1998 / 15:55:14 / cg"
! !

!JavaScannerBase class methodsFor:'defaults'!

warnings
    "return true, if any warnings are to be shown"

    ^ Warnings
!

warnings:aBoolean
    "this allows turning on/off all warnings; the default is on.
     You can turn off warnings in your 'private.rc' file with
	 Compiler warnings:false
    "

    Warnings := aBoolean

    "Modified: 23.5.1997 / 12:03:05 / cg"
! !

!JavaScannerBase class methodsFor:'private accessing'!

actionArray
    ^ ActionArray
!

keywordTable
    ^ KeywordTable
!

typeArray
    ^ TypeArray
! !

!JavaScannerBase class methodsFor:'utility scanning'!

scanNumberFrom:aStream
    "utility - helper for Number>>readSmalltalkSyntaxFrom:"

    ^ self basicNew scanNumberFrom:aStream

    "
     |s|

     s := '12345abcd' readStream.
     Transcript showCR:(self scanNumberFrom:s).
     Transcript showCR:(s upToEnd).
    "
    "
     |s|

     s := '16rffffxabcd' readStream.
     Transcript showCR:(self scanNumberFrom:s).
     Transcript showCR:(s upToEnd).
    "
    "
     |s|

     s := '1.2345abcd' readStream.
     Transcript showCR:(self scanNumberFrom:s).
     Transcript showCR:(s upToEnd).
    "
    "
     |s|

     s := '1.abcd' readStream.
     Transcript showCR:(self scanNumberFrom:s).
     Transcript showCR:(s upToEnd).
    "

    "Modified: / 18.6.1998 / 23:10:39 / cg"
! !

!JavaScannerBase methodsFor:'Compatibility - ST80'!

endOfLastToken
    "return the position of the token which was just read.
     This method was required by some PD program.
     It is not maintained and may be removed without notice."

    ^ source position

    "Modified: 23.5.1997 / 12:14:27 / cg"
!

scan:aStringOrStream
    "initialize the scanner: set the source-stream and
     preread the first token"

    self initializeFor:aStringOrStream.
    self nextToken

    "Created: / 30.10.1997 / 16:59:39 / cg"
!

scanToken
    "read the next token from my input stream"

    ^ self nextToken

    "Created: / 30.10.1997 / 17:00:16 / cg"
!

scanTokens:aStringOrStream
    "return a collection of symbolic tokens from the passed input"

    |tokens|

    self initializeFor:aStringOrStream.
    tokens := OrderedCollection new.
    self nextToken.
    [tokenValue notNil] whileTrue:[
	tokens add:tokenValue.
	self nextToken
    ].
    ^ tokens

    "
     Scanner new
	scanTokens:'Boolean subclass:#True
				instanceVariableNames:''''
				classVariableNames:''''
				poolDictionaries:''''
				category:''Kernel-Objects''
	'
    "

    "Modified: 20.6.1997 / 18:22:58 / cg"
! !

!JavaScannerBase methodsFor:'accessing'!

actionArray
    ^ actionArray
!

actionArray:something
    actionArray := something.
!

comments
    "if saveComments is on:
      returns the collection of collected comments (so far)
      clears the internal collection for the next access"

    |ret|

    ret := comments ? #().
    comments := nil.
    ^ ret

    "Created: 20.4.1996 / 20:07:01 / cg"
    "Modified: 23.5.1997 / 12:14:45 / cg"
!

lineNumber
    "the current line number (in the stream)"

    ^ lineNr
!

newSourceStream:aStream
    source := aStream.
    self nextToken.

    "Created: / 29.10.1998 / 21:59:33 / cg"
!

numberRadix
    "the radix of the previously scanned number"

    ^ numberRadix
!

parserFlags:something
    parserFlags := something.
!

reportNewLine
    ^ reportNewLine
!

reportNewLine:aBoolean
    "When set to true, a #NewLine token is generated for each new line character.
     If false, new line is treaded as whitespace"

    reportNewLine := aBoolean.

    "Modified (comment): / 12-05-2014 / 14:50:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveComments:aBoolean
    "toggle to turn on/off comment remembering"

    saveComments := aBoolean

    "Created: 20.4.1996 / 20:03:56 / cg"
    "Modified: 23.5.1997 / 12:14:49 / cg"
!

sourceStream
    ^ source

    "Created: 20.4.1996 / 19:59:58 / cg"
!

token
    "the previously scanned token"

    "/ generated lazily ...
    self halt.
!

tokenEndPosition
    "the previously scanned tokens last character position"

    ^ tokenEndPosition
!

tokenLineNumber
    "the previously scanned tokens line number"

    ^ tokenLineNr
!

tokenName
    "the value (string or number) of the previously scanned token"

    ^ tokenValue

    "Created: / 22-10-2013 / 02:15:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tokenStartPosition
    "the previously scanned tokens first character position"

    ^ tokenStartPosition
!

tokenType
    "the type (symbolic) of the previously scanned token"

    ^ tokenType
!

tokenValue
    "the value (string or number) of the previously scanned token"

    ^ tokenValue
!

typeArray
    ^ typeArray
!

typeArray:something
    typeArray := something.
! !

!JavaScannerBase methodsFor:'error handling'!

correctableError:message position:pos1 to:pos2
    "report an error which can be corrected by compiler -
     return non-false, if correction is wanted (there is more than
     true/false returned here)"

    |correctIt|

    requestor isNil ifTrue:[
"/        self showErrorMessage:message position:pos1.
	correctIt := false
    ] ifFalse:[
	correctIt := requestor correctableError:message position:pos1 to:pos2 from:self
    ].
    ^ correctIt

    "Created: / 13.5.1998 / 16:45:56 / cg"
!

errorMessagePrefix
    ^ 'Error:'
!

ignoreWarnings
    ^ Warnings == false

    "Modified: / 14-03-2012 / 22:36:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lastTokenLineNumber
    "return the line number of the token which was just read."

    ^ tokenLineNr

    "Created: 8.11.1996 / 18:46:36 / cg"
    "Modified: 23.5.1997 / 12:16:12 / cg"
!

notifyError:aMessage position:position to:endPos
    "notify requestor of an error - if there is no requestor
     put it on the transcript. Requestor is typically the CodeView
     in which the accept/doIt was triggered, or the PositionableStream
     which does the fileIn. The requestor may decide how to highlight the
     error (and/or to abort the compile).
     Return the result passed back by the requestor."

    requestor isNil ifTrue:[
	self showErrorMessage:aMessage position:position.
	^ false
    ].
    ^ requestor error:aMessage position:position to:endPos from:self
!

notifyWarning:aMessage position:position to:endPos
    "notify requestor of an warning - if there is no requestor
     put it on the transcript.
     Return the result passed back by the requestor."

    |warn|

    self ignoreWarnings ifFalse:[
	requestor isNil ifTrue:[
	    warn := ScannerWarning new.
	    warn startPosition:position.
	    warn endPosition:endPos.
	    warn lineNumber:tokenLineNr.
	    warn errorString:((self warningMessagePrefix) , ' ' , aMessage).
	    warn raiseRequest.
	    ^ false
	].
	^ requestor warning:aMessage position:position to:endPos from:self
    ].
    ^ false
!

parseError:aMessage
    "report an error"

    ^ self parseError:aMessage position:tokenStartPosition to:nil

    "Created: / 13.5.1998 / 16:45:13 / cg"
!

parseError:aMessage position:position
    "report an error"

    ^ self parseError:aMessage position:position to:nil

    "Created: / 13.5.1998 / 16:45:05 / cg"
!

parseError:aMessage position:position to:endPos
    "report an error"

    |m|

    m := (self errorMessagePrefix) , ' ' , (aMessage ? '???').
    self notifyError:m position:position to:endPos.
    ^ false

    "Created: / 13.5.1998 / 16:44:55 / cg"
    "Modified: / 28.9.1998 / 19:29:27 / cg"
!

showErrorMessage:aMessage position:pos
    "show an errormessage on the Transcript"

    Transcript showCR:(pos printString , ' [line: ' , tokenLineNr printString , '] ' , aMessage)
!

syntaxError:aMessage
    "a syntax error happened - position is not known"

    ^ self syntaxError:aMessage position:tokenStartPosition
!

syntaxError:aMessage position:position
    "a syntax error happened - only start position is known"

    ^ self syntaxError:aMessage position:position to:nil
!

syntaxError:aMessage position:position to:endPos
    "a syntax error happened"

    |err|

    err := ParseError new.
    err errorMessage:((self errorMessagePrefix) , ' ' , aMessage)
        startPosition:tokenStartPosition
        endPosition:tokenEndPosition.
    err lineNumber:tokenLineNr.
    err raiseRequest

    "Modified: / 21-10-2013 / 09:51:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warning:aMessage
    "a warning - position is not known"

    ^ self warning:aMessage position:tokenStartPosition
!

warning:aMessage position:position
    "a warning - only start position is known"

    ^ self warning:aMessage position:position to:nil
!

warning:aMessage position:position to:endPos
    "a warning"

    ^ self notifyWarning:((self warningMessagePrefix) , ' ' , aMessage) position:position to:endPos
!

warningMessagePrefix
    ^ 'Warning:'
! !

!JavaScannerBase methodsFor:'general scanning'!

scanPositionsFor:aTokenString inString:aSourceString
    "scan aSourceString for occurrances of aTokenString.
     Return a collection of start positions.
     Added for VW compatibility (to support syntax-highlight)."

    |searchType searchToken positions t|

    "
     first, look what kind of token we have to search for
    "
    self initializeFor:(ReadStream on:aTokenString).
    self nextToken.
    searchType := tokenType.
    searchToken := tokenValue.

    "
     start the real work ...
    "
    self initializeFor:(ReadStream on:aSourceString).
    positions := OrderedCollection new.

    [(t := self nextToken) ~~ #EOF] whileTrue:[
	searchType == t ifTrue:[
	    (searchToken isNil or:[tokenValue = searchToken]) ifTrue:[
		positions add:tokenStartPosition.
	    ]
	]
    ].

    ^ positions

    "
     Scanner new scanPositionsFor:'hello' inString:'foo bar hello baz hello helloWorld'
     Scanner new scanPositionsFor:'3.14' inString:'foo 3.145 bar hello 3.14 baz hello 3.14 ''3.14'''
     Scanner new scanPositionsFor:'''3.14''' inString:'foo 3.145 bar hello 3.14 baz hello 3.14 ''3.14'' aaa'
     Scanner new scanPositionsFor:'16' inString:'foo 16 bar hello 16r10 baz hello 2r10000'
    "
! !

!JavaScannerBase methodsFor:'initialization'!

initialize
    "initialize the scanner"

    "/actionArray notNil ifTrue:[ self halt ].

    saveComments := false.
    parserFlags := ParserFlags new.

    (actionArray := self class actionArray) isNil ifTrue:[
        self class setupActions.
        actionArray := self class actionArray
    ].
    typeArray := self class typeArray.
    reportNewLine := false.
    reportComments := false.

    "Modified: / 12-05-2014 / 14:51:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeFor:aStringOrStream
    "initialize the new scanner & prepare for reading from aStringOrStream"

    self initialize.
    self source:aStringOrStream.
!

source:aStringOrStream
    "prepare for reading from aStringOrStream"

    tokenStartPosition := 1.
    tokenLineNr := lineNr := 1.
    comments := nil.

    aStringOrStream isStream ifFalse:[
	source := ReadStream on:aStringOrStream
    ] ifTrue:[
	source := aStringOrStream.
    ].

    "Modified: / 26.5.1999 / 12:02:16 / stefan"
! !

!JavaScannerBase methodsFor:'private'!

addComment:comment
    saveComments ifTrue:[
	comments isNil ifTrue:[
	    comments := OrderedCollection with:comment
	] ifFalse:[
	    comments add:comment
	]
    ].
!

backupPosition
    "if reading from a stream, at the end we might have read
     one token too many"

    (tokenType == #EOF) ifFalse:[
	source position:tokenStartPosition
    ]
!

beginComment
    ^ self
!

requestor:anObject
    "set the requestor to be notified about errors"

    requestor := anObject
! !

!JavaScannerBase methodsFor:'reading next token'!

atEnd
    "true if at the end"

    ^ tokenType == #EOF.

    "Created: / 30-04-2011 / 11:24:13 / cg"
!

isCommentCharacter:aCharacter
    self subclassResponsibility
!

nextSingleCharacterToken:aCharacter
    "return a character token"

    tokenEndPosition := tokenStartPosition.
    tokenType := tokenValue := aCharacter.
    hereChar notNil ifTrue:[source next].
    ^ tokenType

    "Modified: / 13.5.1998 / 15:10:23 / cg"
!

nextToken
    "scan the next token from the source-stream;
     as a side effect, leave info in:
        tokenType          - a symbol describing the kind of token
        token              - its value as string or number
        tokenStartPosition - the tokens first characters position in the input stream
        tokenEndPosition   - the tokens last characters position in the input stream
        tokenLineNr        - the tokens first characters lineNumber in the input stream
     returns the tokenType.
    "

    |skipping actionBlock v ch tok|

    [true] whileTrue:[
        peekChar notNil ifTrue:[
            "/ kludge - should be called peekSym.
            "/ used when xlating Foo.Bar into Foo::Bar
            peekChar isSymbol ifTrue:[
                tokenValue := nil.
                tokenType := peekChar.
                peekChar := nil.
                ^ tokenType
            ].

            peekChar isSeparator ifTrue:[
                peekChar == (Character cr) ifTrue:[
                    lineNr := lineNr + 1.
                ].
                peekChar := peekChar2.
                peekChar2 := nil.
            ].
        ].
        peekChar notNil ifTrue:[
            ch := peekChar.
            peekChar := peekChar2.
            peekChar2 := nil.
            hereChar := nil.
            tokenStartPosition := source position - 1.
        ] ifFalse:[
            skipping := true.
            [skipping] whileTrue:[
                hereChar := source skipSeparatorsExceptCR.
                hereChar == (Character cr) ifTrue:[
                    lineNr := lineNr + 1.
                    source next.
                    reportNewLine ifTrue:[ 
                        tokenType := #NewLine.
                        tokenValue := Character cr.
                        tokenStartPosition := tokenEndPosition := source position - 1.
                        ^ tokenType
                    ].
                ] ifFalse:[
                    hereChar == (Character return) ifTrue:[
                        source next.
                    ] ifFalse:[
                        (self isCommentCharacter:hereChar) ifTrue:[
                            "start of a comment"

                            self skipComment.
                            hereChar := source peekOrNil.
                        ] ifFalse:[
                            skipping := false
                        ]
                    ]
                ]
            ].
            hereChar isNil ifTrue:[
                tokenValue := nil.
                tokenType := #EOF.
                ^ tokenType
            ].
            ch := hereChar.
            tokenStartPosition := source position.
        ].
        tokenLineNr := lineNr.

        (v := ch asciiValue) == 0 ifTrue:[
            v := Character space codePoint
        ].
        actionBlock := actionArray at:v.
        actionBlock notNil ifTrue:[
            tok := actionBlock value:self value:ch.
            tok notNil ifTrue:[
                ^ tok
            ].
        ] ifFalse:[
            self syntaxError:('invalid character: ''' , ch asString , ''' ',
                              '(' , v printString , ')')
                    position:tokenStartPosition to:tokenStartPosition.
            source next.
            tokenValue := nil.
            tokenType := #Error.
            ^ #Error
        ]
    ].

    "Modified: / 12-05-2014 / 14:53:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipComment
    self subclassResponsibility
! !

!JavaScannerBase methodsFor:'reading next token - private'!

nextMantissa:radix
    "read the mantissa of a radix number.
     Return post-decimal value (i.e. 0.xxxx); leave number of post-decimal
     digits in numberScale; scaled post-decimal value in scaledMantissaValue (xxx)."

    |nextChar value factor|

    value := scaledMantissaValue := 0.
    factor := 1.0 / radix.
    nextChar := source peekOrNil.
    numberScale := 0.

    [(nextChar notNil and:[nextChar isDigitRadix:radix])] whileTrue:[
	scaledMantissaValue := (scaledMantissaValue * radix) + (nextChar digitValue).
	value := value + (nextChar digitValue * factor).
	factor := factor / radix.
	numberScale := numberScale + 1.
	nextChar := source nextPeek
    ].
    ^ value

    "Modified: / 5.3.1998 / 02:54:11 / cg"
! !

!JavaScannerBase class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaScannerBase.st,v 1.5 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaScannerBase initialize!
