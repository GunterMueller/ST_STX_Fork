"{ Package: 'stx:libbasic2' }"

"
 COPYRIGHT (c) 1996 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"



ReadStream subclass:#TokenizedStream
	instanceVariableNames:'inputStream token tokenType tokenPosition tokenName tokenLineNr
		tokenValue tokenRadix hereChar peekChar peekChar2
		beginCommentCharacter endCommentCharacter eolCommentCharacter
		eolCharacter outStream outCol actions types eolIsSignificant
		allowFloatNumbers numbersAreSigned'
	classVariableNames:'DefaultActions DefaultTypes'
	poolDictionaries:''
	category:'Streams-Misc'
!

!TokenizedStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG
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
    a first version of a tokenStream.
    This is still being constructed and will probably be enhanced
    and may finally help a simplified Scanner class.

    For now, it may be useful when textual input files are to be read and
    parsed. For example, ascii data files are often in a simple free form format
    which requires some little processing.
    Dont blame me, if its not powerful enough for your needs.

    operation:

	characters are read from a real input stream
	and the tokenizer dispatches to a token reading method by the help
	of an actionTable, which is indexed by the tokenType.
	The tokenType itself is aquired via another table via
	the characters ascii code.

	By default, the table is setup to only read numbers
	and identifiers.
	Whitespace is ignored, and all other characters return themself.

    The returned tokens are either symbols (#Identifier, #Integer ..) or
    characters ($+ $, etc.)
    If its #Identifier, the name is found in tokenName (there is an access method for that).
    If its #Integer or #Float, the value is found in tokenValue.

    EndOfLine is either ignored or returned as #EOL (if eolIsSignificant is true).
    End of input as #EOF.
    Unrecognized input leads to #Error to be returned.

    Customized tokenizers can be setup, by modifying the action- or typeTables.
    See examples for more.

    [author:]
	Claus Gittinger

    [see also:]
	ReadStream
	Scanner
	Tgen::*
"
!

examples
"
    simple example; tokenizing some string:
									[exBegin]
	|s|

	s := TokenizedStream on:'hello world, how much is 3 + 2'.
	[s atEnd] whileFalse:[
	    Transcript showCR:(s next).
	].
									[exEnd]


    simple example2; tokenizing and checking:
									[exBegin]
	|s token|

	s := TokenizedStream on:'foo bar baz  3 + 2'.
	[s atEnd] whileFalse:[
	    token := s next.
	    token == #Identifier ifTrue:[
		Transcript showCR:(token , ' name=' , s tokenName).
	    ] ifFalse:[
		token == #Integer ifTrue:[
		    Transcript showCR:(token , ' value=' , s tokenValue printString).
		] ifFalse:[
		    Transcript showCR:token.
		]
	    ]
	].
									[exEnd]


    reading simple expressions:
									[exBegin]
	|s num1 num2|

	s := TokenizedStream on:'
3 + 2
4 + 6
1 + 2
'.
	[s atEnd] whileFalse:[
	    s next == #Integer ifTrue:[
		num1 := s tokenValue.
		s next == $+ ifTrue:[
		    s next == #Integer ifTrue:[
			num2 := s tokenValue.
			Transcript showCR:num1 printString
					  , ' + '
					  , num2 printString
					  , ' => '
					  , (num1 + num2) printString.
		    ]
		]
	    ]
	].
									[exEnd]


    with eol-comments:
									[exBegin]
	|s num1 num2|

	s := TokenizedStream on:'
3 + 2
; this is a comment
4 + 6
1 + 2
'.
	s eolCommentCharacter:$;.

	[s atEnd] whileFalse:[
	    s next == #Integer ifTrue:[
		num1 := s tokenValue.
		s next == $+ ifTrue:[
		    s next == #Integer ifTrue:[
			num2 := s tokenValue.
			Transcript showCR:num1 printString
					  , ' + '
					  , num2 printString
					  , ' => '
					  , (num1 + num2) printString.
		    ]
		]
	    ]
	].
									[exEnd]


    allowing float & negative numbers (the default):
									[exBegin]
	|s|

	s := TokenizedStream on:'1.23 4.56 7 8 9 -5 5 -5.0 5.0'.
	[s atEnd] whileFalse:[
	    s next.
	    Transcript showCR:(s tokenType displayString, ' value=' , s tokenValue printString).
	].
									[exEnd]


    not allowing float numbers :
    (notice, how the floats is scanned)
									[exBegin]
	|s|

	s := TokenizedStream on:'1.23 4.56 7 8 9 -5 5 -5.0 5.0 '.
	s allowFloatNumbers:false.

	[s atEnd] whileFalse:[
	    s next.
	    Transcript showCR:(s tokenType displayString , ' value= ' , s tokenValue printString).
	].
									[exEnd]


    not allowing negative numbers :
    (notice, how the signs is scanned)
									[exBegin]
	|s|

	s := TokenizedStream on:'1.23 4.56 7 8 9 -5 5 -5.0 5.0'.
	s numbersAreSigned:false.

	[s atEnd] whileFalse:[
	    s next.
	    Transcript showCR:(s tokenType displayString , ' value= ' , s tokenValue printString).
	].
									[exEnd]


    no radix numbers (the default):
    (notice, how the integer is scanned)
									[exBegin]
	|s|

	s := TokenizedStream on:'1234 0x1234 16r1234'.

	[s atEnd] whileFalse:[
	    s next.
	    Transcript showCR:(s tokenType displayString , ' value= ' , s tokenValue printString , ' name=' , s tokenName displayString).
	].
									[exEnd]


    C-style radix numbers:
    (notice, how the ST-style integer is scanned)
									[exBegin]
	|s|

	s := TokenizedStream on:'0x1234 16r1234'.
	s actionTable at:#digit put:[:s :char | s nextCNumber].

	[s atEnd] whileFalse:[
	    s next.
	    Transcript showCR:(s tokenType displayString , ' value= ' , s tokenValue printString , ' name=' , s tokenName displayString).
	].
									[exEnd]


    smalltalk-style radix numbers:
    (notice, how the C-style integer is scanned)
									[exBegin]
	|s|

	s := TokenizedStream on:'0x1234 16r1234'.
	s actionTable at:#digit put:[:s :char | s nextSmalltalkNumber].

	[s atEnd] whileFalse:[
	    s next.
	    Transcript showCR:(s tokenType displayString , ' value= ' , s tokenValue printString , ' name=' , s tokenName displayString).
	].
									[exEnd]


    scan the '/etc/services' file:
									[exBegin]
	|s t service port protocol|

	s := TokenizedStream on:'/etc/services' asFilename readStream.
	s eolCommentCharacter:$#.
	s typeTable at:($- asciiValue) put:#letter.

	[s atEnd] whileFalse:[
	    t := s next.
	    t == #Identifier ifTrue:[
		service := s tokenName.
		t := s next.
		t == #Integer ifTrue:[
		    port := s tokenValue.
		    s next == $/ ifTrue:[
			t := s next.
			t == #Identifier ifTrue:[
			    protocol := s tokenName.
			    Transcript showCR:('servive: ' , service , ' is ' , protocol , ' port=' , port printString).
			]
		    ]
		]
	    ].
	    s skipToEol
	]
									[exEnd]
"
! !

!TokenizedStream class methodsFor:'initialization'!

initialize
    DefaultActions := IdentityDictionary new.
    DefaultTypes := Array new:256.

    "kludge: action is nextColonOrAssign, but type is special"
    2 to:255 do:[:code |
	DefaultTypes at:code put:(Character value:code).
    ].

    ($0 asciiValue) to:($9 asciiValue) do:[:index |
	DefaultTypes at:index put:#digit.
    ].

    ($a asciiValue) to:($z asciiValue) do:[:index |
	DefaultTypes at:index put:#letter.
    ].
    ($A asciiValue) to:($Z asciiValue) do:[:index |
	DefaultTypes at:index put:#letter.
    ].

    DefaultActions at:#letter put:[:s :char | s nextIdentifier].
    DefaultActions at:#digit  put:[:s :char | s nextNumber].
    DefaultActions at:$-  put:[:s :char | s nextSignedNumber].

    "
     TokenizedStream initialize
    "
! !

!TokenizedStream class methodsFor:'instance creation'!

new
    ^ self basicNew initialize

    "Modified: 11.1.1997 / 19:18:48 / cg"
    "Created: 11.1.1997 / 19:22:40 / cg"
!

on:aStream
    ^ self readingFrom:(aStream readStream)

    "Modified: 11.1.1997 / 19:23:49 / cg"
!

readingFrom:aStream
    ^ self new inputStream:aStream

    "Created: 11.1.1997 / 19:18:58 / cg"
    "Modified: 11.1.1997 / 19:23:17 / cg"
! !

!TokenizedStream methodsFor:'accessing'!

actionTable
    ^ actions

    "Created: 1.2.1996 / 17:42:00 / cg"
!

allowFloatNumbers:aBoolean
    "if false, floating numbers are not read; a period is returned as
     a separate token. If true (the default), floating point numbers are allowed."

    allowFloatNumbers := aBoolean

    "Modified: 1.2.1996 / 18:14:27 / cg"
    "Created: 1.2.1996 / 18:27:41 / cg"
!

beginCommentCharacter:aCharacter
    beginCommentCharacter := aCharacter

    "Created: 1.2.1996 / 17:38:01 / cg"
!

endCommentCharacter:aCharacter
    endCommentCharacter := aCharacter

    "Created: 1.2.1996 / 17:38:06 / cg"
!

eolCommentCharacter:aCharacter
    eolCommentCharacter := aCharacter

    "Created: 1.2.1996 / 17:37:51 / cg"
!

eolIsSignificant:aBoolean
    "if false, EOL is treated like whiteSpace (the default);
     Otherwise, a #EOL token is returned"

    eolIsSignificant := aBoolean

    "Created: 1.2.1996 / 17:37:51 / cg"
    "Modified: 1.2.1996 / 18:14:27 / cg"
!

numbersAreSigned:aBoolean
    "if false, minus signs preceeding numbers are ignored.
     if true (the default) they are recognized"

    numbersAreSigned := aBoolean

    "Modified: 1.2.1996 / 18:14:27 / cg"
    "Created: 1.2.1996 / 18:56:34 / cg"
!

tokenName
    ^ tokenName

    "Created: 1.2.1996 / 17:46:48 / cg"
!

tokenType
    ^ tokenType

    "Created: 1.2.1996 / 17:26:24 / cg"
!

tokenValue
    ^ tokenValue

    "Created: 1.2.1996 / 17:26:30 / cg"
!

typeTable
    ^ types

    "Created: 1.2.1996 / 17:41:54 / cg"
! !

!TokenizedStream methodsFor:'initialization'!

initialize
    tokenLineNr := 1.

    eolCommentCharacter := beginCommentCharacter := endCommentCharacter := nil.
    eolCharacter := Character cr.
    eolIsSignificant := false.

    actions := DefaultActions shallowCopy.
    types := DefaultTypes shallowCopy.
    allowFloatNumbers := true.
    numbersAreSigned := true.

    "Modified: 11.1.1997 / 19:25:49 / cg"
!

inputStream:aStream
    inputStream := aStream

    "Created: 11.1.1997 / 19:25:41 / cg"
! !

!TokenizedStream methodsFor:'private'!

on:aStream
    self initialize.

    inputStream := aStream.

    "Modified: 11.1.1997 / 19:22:10 / cg"
! !

!TokenizedStream methodsFor:'reading'!

next
    ^ self nextToken

    "Created: 1.2.1996 / 17:21:47 / cg"
!

nextCNumber
    |nextChar value s|

    tokenRadix := 10.
    inputStream peek == $0 ifTrue:[
	inputStream next.
	inputStream peek == $x ifTrue:[
	    inputStream next.
	    tokenRadix := 16.
	] ifFalse:[
	    tokenRadix := 8
	]
    ].

    value := Integer readFrom:inputStream radix:tokenRadix.
    nextChar := inputStream peek.

    (allowFloatNumbers and:[tokenRadix == 10]) ifTrue:[
	(nextChar == $.) ifTrue:[
	    nextChar := inputStream nextPeek.
	    (nextChar notNil and:[nextChar isDigitRadix:tokenRadix]) ifTrue:[
		value := value asFloat + (self nextMantissa:tokenRadix).
		nextChar := inputStream peek
	    ] ifFalse:[
		nextChar == (Character cr) ifTrue:[
		    tokenLineNr := tokenLineNr + 1.
		].
		peekChar := $.
	    ]
	].
	((nextChar == $e) or:[nextChar == $E]) ifTrue:[
	    nextChar := inputStream nextPeek.
	    (nextChar notNil and:[(nextChar isDigitRadix:tokenRadix) or:['+-' includes:nextChar]]) ifTrue:[
		s := 1.
		(nextChar == $+) ifTrue:[
		    nextChar := inputStream nextPeek
		] ifFalse:[
		    (nextChar == $-) ifTrue:[
			nextChar := inputStream nextPeek.
			s := s negated
		    ]
		].
		value := value asFloat
			 * (10.0 raisedToInteger:((Integer readFrom:inputStream radix:tokenRadix) * s))
	    ]
	].
    ].
    tokenValue := value.
    (value isMemberOf:Float) ifTrue:[
	tokenType := #Float
    ] ifFalse:[
	tokenType := #Integer
    ].
    ^ tokenType

    "Created: 1.2.1996 / 18:26:27 / cg"
    "Modified: 11.1.1997 / 19:24:19 / cg"
!

nextIdentifier
    |nextChar string oldString
     index "{ Class: SmallInteger }"
     max   "{ Class: SmallInteger }"
     t done|

    nextChar := inputStream peek.
    string := String basicNew:20.
    index := 0.
    max := 10.

    done := false.
    [done] whileFalse:[
	nextChar isNil ifTrue:[
	    done := true
	] ifFalse:[
	    t := types at:(nextChar asciiValue).
	    done := (t ~~ #letter and:[t ~~ #digit]).
	].
	done ifFalse:[
	    (index == max) ifTrue:[
		oldString := string.
		string := String basicNew:(max * 2).
		string replaceFrom:1 to:max with:oldString.
		max := max * 2
	    ].
	    index := index + 1.
	    string at:index put:nextChar.
	    nextChar := inputStream nextPeek
	]
    ].
    tokenType := #Identifier.
    tokenName := string copyTo:index.
    ^ tokenType

    "Created: 1.2.1996 / 16:35:53 / cg"
    "Modified: 11.1.1997 / 19:24:25 / cg"
!

nextInteger
    tokenValue := Integer readFrom:inputStream radix:10.
    tokenRadix := 10.
    tokenType := #Integer.
    ^ tokenType

    "Created: 1.2.1996 / 16:37:03 / cg"
    "Modified: 11.1.1997 / 19:24:27 / cg"
!

nextMantissa:radix
    |nextChar value factor|

    value := 0.
    factor := 1.0 / radix.
    nextChar := inputStream peek.
    [(nextChar notNil and:[nextChar isDigitRadix:radix])] whileTrue:[
	value := value + (nextChar digitValue * factor).
	factor := factor / radix.
	nextChar := inputStream nextPeek
    ].
    ^ value

    "Created: 1.2.1996 / 18:31:38 / cg"
    "Modified: 11.1.1997 / 19:24:30 / cg"
!

nextNumber
    |nextChar value s|

    tokenRadix := 10.
    value := Integer readFrom:inputStream radix:tokenRadix.
    nextChar := inputStream peek.
    allowFloatNumbers ifTrue:[
	(nextChar == $.) ifTrue:[
	    nextChar := inputStream nextPeek.
	    (nextChar notNil and:[nextChar isDigitRadix:tokenRadix]) ifTrue:[
		value := value asFloat + (self nextMantissa:tokenRadix).
		nextChar := inputStream peek
	    ] ifFalse:[
		nextChar == (Character cr) ifTrue:[
		    tokenLineNr := tokenLineNr + 1.
		].
		peekChar := $.
	    ]
	].
	((nextChar == $e) or:[nextChar == $E]) ifTrue:[
	    nextChar := inputStream nextPeek.
	    (nextChar notNil and:[(nextChar isDigitRadix:tokenRadix) or:['+-' includes:nextChar]]) ifTrue:[
		s := 1.
		(nextChar == $+) ifTrue:[
		    nextChar := inputStream nextPeek
		] ifFalse:[
		    (nextChar == $-) ifTrue:[
			nextChar := inputStream nextPeek.
			s := s negated
		    ]
		].
		value := value asFloat
			 * (10.0 raisedToInteger:((Integer readFrom:inputStream radix:tokenRadix) * s))
	    ]
	].
    ].
    tokenValue := value.
    (value isMemberOf:Float) ifTrue:[
	tokenType := #Float
    ] ifFalse:[
	tokenType := #Integer
    ].
    ^ tokenType

    "Created: 1.2.1996 / 18:31:03 / cg"
    "Modified: 11.1.1997 / 19:24:34 / cg"
!

nextSignedNumber
    |next|

    inputStream next.
    numbersAreSigned ifTrue:[
	next := inputStream peek.
	(next notNil and:[(types at:next asciiValue) == #digit]) ifTrue:[
	    (actions at:#digit) value:self value:next.
	    tokenValue := tokenValue negated.
	]
    ].
    ^ tokenType

    "Modified: 11.1.1997 / 19:24:40 / cg"
!

nextSmalltalkNumber
    |nextChar value s|

    tokenRadix := 10.
    value := Integer readFrom:inputStream radix:tokenRadix.
    nextChar := inputStream peek.
    (nextChar == $r) ifTrue:[
	tokenRadix := value.
	inputStream next.
	s := 1.
	inputStream peek == $- ifTrue:[
	    inputStream next.
	    s := -1
	].
	value := Integer readFrom:inputStream radix:tokenRadix.
	value := value * s.
	nextChar := inputStream peek
    ].
    allowFloatNumbers ifTrue:[
	(nextChar == $.) ifTrue:[
	    nextChar := inputStream nextPeek.
	    (nextChar notNil and:[nextChar isDigitRadix:tokenRadix]) ifTrue:[
		value := value asFloat + (self nextMantissa:tokenRadix).
		nextChar := inputStream peek
	    ] ifFalse:[
		nextChar == (Character cr) ifTrue:[
		    tokenLineNr := tokenLineNr + 1.
		].
		peekChar := $.
	    ]
	].
	((nextChar == $e) or:[nextChar == $E]) ifTrue:[
	    nextChar := inputStream nextPeek.
	    (nextChar notNil and:[(nextChar isDigitRadix:tokenRadix) or:['+-' includes:nextChar]]) ifTrue:[
		s := 1.
		(nextChar == $+) ifTrue:[
		    nextChar := inputStream nextPeek
		] ifFalse:[
		    (nextChar == $-) ifTrue:[
			nextChar := inputStream nextPeek.
			s := s negated
		    ]
		].
		value := value asFloat
			 * (10.0 raisedToInteger:((Integer readFrom:inputStream radix:tokenRadix) * s))
	    ]
	].
    ].
    tokenValue := value.
    (value isMemberOf:Float) ifTrue:[
	tokenType := #Float
    ] ifFalse:[
	tokenType := #Integer
    ].
    ^ tokenType

    "Created: 1.2.1996 / 18:19:05 / cg"
    "Modified: 11.1.1997 / 19:24:49 / cg"
!

nextString:separator
    |nextChar string pos
     index "{ Class: SmallInteger }"
     len   "{ Class: SmallInteger }"
     inString|

    string := String basicNew:20.
    len := 20.
    index := 1.
    pos := inputStream position.
    inputStream next.
    nextChar := inputStream next.
    inString := true.

    [inString] whileTrue:[
	nextChar isNil ifTrue:[
	    self error:'unexpected end-of-input in String'.
	    tokenType := #EOF.
	    ^ tokenType
	].
	(nextChar == Character cr) ifTrue:[
	    tokenLineNr := tokenLineNr + 1
	].
	(nextChar == separator) ifTrue:[
	    (inputStream peek == separator) ifTrue:[
		inputStream next
	    ] ifFalse:[
		inString := false
	    ]
	].
	inString ifTrue:[
	    string at:index put:nextChar.
	    (index == len) ifTrue:[
		string := string , (String new:len).
		len := len * 2
	    ].
	    index := index + 1.
	    nextChar := inputStream next
	]
    ].
    tokenValue := string copyTo:(index - 1).
    tokenType := #String.
    ^ tokenType

    "Created: 1.2.1996 / 16:39:48 / cg"
    "Modified: 11.1.1997 / 19:24:53 / cg"
!

nextToken
    "return the next token from the inputStream-stream"

    |skipping actionBlock|

    tokenValue := tokenName := nil.

    peekChar notNil ifTrue:[
	hereChar := peekChar.
	peekChar := peekChar2.
	peekChar2 := nil
    ] ifFalse:[
	skipping := true.
	[skipping] whileTrue:[
	    outStream notNil ifTrue:[
		[(hereChar := inputStream peek) == Character space] whileTrue:[
		    inputStream next.
		    outStream space.
		    outCol := outCol + 1.
		]
	    ] ifFalse:[
		hereChar := inputStream skipSeparatorsExceptCR.
	    ].
	    hereChar isNil ifTrue:[
		tokenType := #EOF.
		^ tokenType
	    ].
	    hereChar == eolCharacter ifTrue:[
		tokenLineNr := tokenLineNr + 1.
		inputStream next.
		outStream notNil ifTrue:[
		    outStream cr.
		    outCol := 1
		].
		eolIsSignificant ifTrue:[
		    tokenType := #EOL.
		    ^ tokenType
		]
	    ] ifFalse:[
		hereChar == beginCommentCharacter ifTrue:[
		    "start of a comment"

		    self skipComment.
		    hereChar := inputStream peek.
		] ifFalse:[
		    hereChar == eolCommentCharacter ifTrue:[
			"start of an eol comment"

			self skipEolComment.
			hereChar := inputStream peek.
		    ] ifFalse:[
			skipping := false
		    ]
		]
	    ]
	].
	hereChar isNil ifTrue:[
	    tokenType := #EOF.
	    ^ tokenType
	]
    ].
    tokenPosition := inputStream position.

    types notNil ifTrue:[
	tokenType := types at:(hereChar asciiValue).
    ].

    actions notNil ifTrue:[
	actionBlock := actions at:tokenType ifAbsent:nil.
	actionBlock notNil ifTrue:[
	    ^ actionBlock value:self value:hereChar
	]
    ].

    inputStream next.
    tokenType isNil ifTrue:[
	tokenType := #Error.
    ].
    ^ tokenType

    "Modified: 11.1.1997 / 19:25:00 / cg"
!

skipComment
    inputStream next.
    hereChar := inputStream peek.

    [hereChar notNil and:[hereChar ~~ endCommentCharacter]] whileTrue:[
	hereChar == eolCharacter ifTrue:[
	    tokenLineNr := tokenLineNr + 1.
	].
	outStream notNil ifTrue:[
	    outStream nextPut:hereChar.
	    outCol := outCol + 1
	].
	hereChar := inputStream nextPeek
    ].

    "Created: 1.2.1996 / 17:35:24 / cg"
    "Modified: 11.1.1997 / 19:25:02 / cg"
!

skipEolComment
    inputStream next.
    self skipToEol

    "Created: 1.2.1996 / 17:34:17 / cg"
    "Modified: 11.1.1997 / 19:25:04 / cg"
!

skipToEol
    hereChar := inputStream peek.

    [hereChar notNil and:[hereChar ~~ eolCharacter]] whileTrue:[
	outStream notNil ifTrue:[
	    outStream nextPut:hereChar.
	    outCol := outCol + 1
	].
	hereChar := inputStream nextPeek.
    ].
    tokenLineNr := tokenLineNr + 1.

    "Created: 1.2.1996 / 18:06:09 / cg"
    "Modified: 11.1.1997 / 19:25:07 / cg"
! !

!TokenizedStream methodsFor:'testing'!

atEnd
   ^ inputStream atEnd or:[tokenType == #Error or:[tokenType == #EOF]]

    "Created: 1.2.1996 / 17:21:28 / cg"
    "Modified: 11.1.1997 / 19:24:05 / cg"
! !

!TokenizedStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/TokenizedStream.st,v 1.12 2009-12-11 09:28:13 cg Exp $'
! !
TokenizedStream initialize!
