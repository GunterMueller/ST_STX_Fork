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

JavaScannerBase subclass:#JavaScanner
	instanceVariableNames:'allowDegeneratedMantissa allowRunawayString keywordTable'
	classVariableNames:'Verbose'
	poolDictionaries:''
	category:'Languages-Java-Parser'
!

Object subclass:#Token
	instanceVariableNames:'type value startPosition endPosition'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScanner
!

!JavaScanner class methodsFor:'documentation'!

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
!

examples
"
    |s in|

    in := '
function scalefactor(value) {
    scalevector[0]=value;
    scalevector[1]=1.;
    scalevector[2]=1.;
}
'.

    s := JavaScanner for:in readStream.
    s nextToken


    |s in|

    in := '
function scalefactor(value) {
    scalevector[0]=value;
    scalevector[1]=1.;
    scalevector[2]=1.;
}
'.
    s := JavaScanner new.
    s scanTokens:(in readStream).


    |s in|

    in := '
function scalefactor(value) {
    scalevector[0]=value;
    scalevector[1]=1.;
    scalevector[2]=1.;
}
'.
    in := in readStream.
    s := JavaScanner for:in.
    [in atEnd] whileFalse:[
	Transcript showCR:s nextToken
    ]

"

    "Created: / 13.5.1998 / 14:54:06 / cg"
! !

!JavaScanner class methodsFor:'initialization'!

setupActions
    "initialize the scanners actionTables - these are used to dispatch
     into scanner methods as characters are read"

    |block|

    self setupKeywordTable.

    ActionArray := Array new:256.
    TypeArray := Array new:256.

    block := [:s :char | s nextNumber].
    ($0 asciiValue) to:($9 asciiValue) do:[:index |
        ActionArray at:index put:block
    ].

    block := [:s :char | s nextSingleCharacterToken:char].
    #( $: $; $, ${ $} $( $) $[ $] $_ $? $@) do:[:ch |
        ActionArray at:(ch asciiValue) put:block
    ].

    block := [:s :char | s nextIdentifier].
    ($a asciiValue) to:($z asciiValue) do:[:index |
        ActionArray at:index put:block
    ].
    ($A asciiValue) to:($Z asciiValue) do:[:index |
        ActionArray at:index put:block
    ].
    ActionArray at:$_ asciiValue put:block.

    ActionArray at:$$ asciiValue put:block.

    ActionArray at:($. asciiValue) put:[:s :char | s nextDotOrFloatOrEllipsis].

    ActionArray at:($' asciiValue) put:[:s :char | s nextString:$' character:true].
    ActionArray at:($" asciiValue) put:[:s :char | s nextString:$" character:false].
    ActionArray at:($!! asciiValue) put:[:s :char | s nextMulti:#(($= #'!!=')) after:char].
    ActionArray at:($= asciiValue) put:[:s :char | s nextMulti:#(($= #'==')) after:char].
    ActionArray at:($< asciiValue) put:[:s :char | s nextMulti:#(($= #'<=') ($< #'<<')) after:char].
    ActionArray at:($> asciiValue) put:[:s :char | s nextMulti:#(($= #'>=') ($> #'>>' $> #'>>>' $= #'>>>=')) after:char].

    ActionArray at:($- asciiValue) put:[:s :char | s nextMulti:#(($- #'--') ($= #'-=')) after:char].
    ActionArray at:($+ asciiValue) put:[:s :char | s nextMulti:#(($+ #'++') ($= #'+=')) after:char].
    ActionArray at:($* asciiValue) put:[:s :char | s nextMulti:#(($= #'*=')) after:char].
    ActionArray at:($/ asciiValue) put:[:s :char | s nextMulti:#(($= #'/=') ($/ nil #skipEOLComment) ($* nil #skipComment)) after:char].
    ActionArray at:($% asciiValue) put:[:s :char | s nextMulti:#(($= #'%=')) after:char].
    ActionArray at:($& asciiValue) put:[:s :char | s nextMulti:#(($= #'&=') ($& #'&&')) after:char].
    ActionArray at:($^ asciiValue) put:[:s :char | s nextMulti:#(($= #'^=')) after:char].
    ActionArray at:($~ asciiValue) put:[:s :char | s nextMulti:#(($= #'~=')) after:char].
    ActionArray at:($| asciiValue) put:[:s :char | s nextMulti:#(($= #'|=') ($| #'||')) after:char].

    "
     self setupActions
    "

    "Created: / 14-05-1998 / 15:48:03 / cg"
    "Modified: / 17-05-1998 / 21:03:37 / cg"
    "Modified: / 16-03-2012 / 23:49:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupKeywordTable
    "initialize the scanners actionTables - these are used to dispatch
     into scanner methods as characters are read"

    KeywordTable := Dictionary new.

    #(
        'abstract'     abstract
        'boolean'      boolean
        'break'        break
        'byte'         byte
        'case'         case
        'catch'        catch
        'char'         char
        'class'        class
        'continue'     continue
        'default'      default
        'do'           do
        'double'       double
        'enum'         enum
        'else'         else
        'extends'      extends
        'final'        final
        'finally'      finally
        'float'        float
        'for'          for
        'if'           if
        'implements'   implements
        'import'       import
        'instanceof'   instanceof
        'int'          int
        'interface'    interface
        'long'         long
        'native'       native
        'new'          new
        'package'      package
        'private'      private
        'protected'    protected
        'public'       public
        'return'       return
        'short'        short
        'static'       static
        'super'        super
        'strictfp'     strictfp
        'switch'       switch
        'synchronized' synchronized
        'this'         this
        'threadsafe'   threadsafe
        'throw'        throw
        'throws'       throws
        'transient'    transient
        'try'          try
        'void'         void
        'volatile'     volatile
        'while'        while

        "/ Reserved, but Unused KeyWords
        'const'        const
        'byvalue'      byvalue
        'goto'         goto

        "/ literals
        'null'         null
        'true'         boolean
        'false'        boolean
    ) pairWiseDo:[:s :kw |
        KeywordTable at:s put:kw
    ].

    "
     NewJavaScanner setupKeywordTable
    "

    "Created: / 14-05-1998 / 15:48:03 / cg"
    "Modified: / 17-05-1998 / 21:03:37 / cg"
    "Modified: / 15-03-2012 / 22:47:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScanner methodsFor:'accessing'!

allowRunawayString:aBoolean
    allowRunawayString := aBoolean.
!

token
    "the previously scanned token"

    ^Token new
        type: tokenType;
        value: tokenValue;
        startPosition: tokenStartPosition + 1;
        endPosition: tokenEndPosition + 1;
        yourself

    "Created: / 17-03-2012 / 13:32:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-08-2013 / 20:23:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScanner methodsFor:'converting'!

asPetitStream

    ^self

    "Created: / 14-03-2012 / 22:51:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScanner methodsFor:'error handling'!

errorMessagePrefix
    ^ 'Java Error:'
!

warningMessagePrefix
    ^ 'Java Warning:'
! !

!JavaScanner methodsFor:'initialization'!

initialize
    "initialize the scanner"

    super initialize.

    allowDegeneratedMantissa := true.     "/ something like 123.
    allowRunawayString := false.
    keywordTable := self class keywordTable.
    saveComments := true.

    "Modified: / 11-08-2014 / 21:14:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScanner methodsFor:'private'!

checkForKeyword:string
    "check if string is a keyword (as opposed to an identifier)."

    |tok|

    (tok := keywordTable at:string ifAbsent:nil) notNil ifTrue:[
	tokenType := tok.
	^ true
    ].
    ^ false
!

isCommentCharacter:ch
    "return true, if ch is the comment-start character"

    ^ false

    "Created: / 14.5.1998 / 20:53:33 / cg"
!

rememberTokenStartPosition
    self rememberTokenStartPosition:0

    "Created: / 17-03-2012 / 00:19:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rememberTokenStartPosition: offset
    tokenStartPosition := source position - offset

    "Created: / 17-03-2012 / 17:39:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScanner methodsFor:'reading next token'!

characterEscape:char
    |ascii c |

    char == $" ifTrue:[
        ^ $".
    ].

    char == $b ifTrue:[
        ^ Character backspace
    ].
    char == $t ifTrue:[
        ^ Character tab
    ].
    char == $n ifTrue:[
        ^ Character cr
    ].
    char == $r ifTrue:[
        ^ Character return
    ].
    char == $f ifTrue:[
        ^ Character newPage
    ].

    char == $u ifTrue:[
        ascii := 0.
        c := source peekOrNil.
        4 timesRepeat:[
            (c isDigitRadix:16) ifFalse:[
                self syntaxError:'invalid hex character constant'
                        position:source position-2 to:(source position - 1).
                ^ Character value:ascii
            ].
            ascii := (ascii bitShift:4).
            ascii := ascii + c digitValue.
            source next. c := source peekOrNil.
        ].
        ^ Character value:ascii
    ].
"/    char == $x ifTrue:[
"/        ascii := 0.
"/        c := source peekOrNil.
"/        2 timesRepeat:[
"/            (c isDigitRadix:16) ifFalse:[
"/                self syntaxError:'invalid hex character constant'
"/                        position:source position-2 to:(source position - 1).
"/                ^ Character value:ascii
"/            ].
"/            ascii := (ascii bitShift:4).
"/            ascii := ascii + c digitValue.
"/            source next. c := source peekOrNil.
"/        ].
"/        ^ Character value:ascii
"/    ].
    "OctalEscape ::= \ OctalDigit |
                     \ OctalDigit OctalDigit
                     \ ZeroToThree OctalDigit OctalDigit"

    (char between:$0 and:$3) ifTrue:[
        ascii := char digitValue.
        c := source peekOrNil.
        (c between: $0 and: $7) ifTrue:[
            source next.
            ascii := (ascii bitShift:3).
            ascii := ascii + c digitValue.
        ].
        c := source peekOrNil.
        (c between: $0 and: $7) ifTrue:[
            source next.
            ascii := (ascii bitShift:3).
            ascii := ascii + c digitValue.
        ].
        ^ Character value:ascii
    ].
    (char between:$4 and: $7) ifTrue:[
        ascii := char digitValue.            
        c := source peekOrNil.
        (c between: $0 and: $7) ifTrue:[
            source next.
            ascii := (ascii bitShift:3).
            ascii := ascii + c digitValue.
        ].
        ^ Character value:ascii
    ].

    ^ char

    "Modified: / 16-03-2012 / 10:07:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exponentPart:initialValue
    |nextChar value s|

    value := initialValue.
    nextChar := source peekOrNil.

    ((nextChar == $e) or:[nextChar == $E]) ifTrue:[
	nextChar := source nextPeek.
	(nextChar notNil and:[(nextChar isDigitRadix:10) or:['+-' includes:nextChar]]) ifTrue:[
	    s := 1.
	    (nextChar == $+) ifTrue:[
		nextChar := source nextPeek
	    ] ifFalse:[
		(nextChar == $-) ifTrue:[
		    nextChar := source nextPeek.
		    s := s negated
		]
	    ].
	    value := value asFloat
		     * (10.0 raisedToInteger:((Integer readFrom:source radix:10) * s))
	]
    ].
    ^ value
!

hexponentPart:initialValue
    |nextChar value s|

    value := initialValue.
    nextChar := source peekOrNil.

    ((nextChar == $p) or:[nextChar == $P]) ifTrue:[
        nextChar := source nextPeek.
        (nextChar notNil and:[(nextChar isDigitRadix:16) or:['+-' includes:nextChar]]) ifTrue:[
            s := 1.
            (nextChar == $+) ifTrue:[
                nextChar := source nextPeek
            ] ifFalse:[
                (nextChar == $-) ifTrue:[
                    nextChar := source nextPeek.
                    s := s negated
                ]
            ].
            value := value asFloat
                     * (16.0 raisedToInteger:((Integer readFrom:source radix:16) * s))
        ]
    ].
    ^ value

    "Created: / 16-03-2012 / 00:00:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextDotOrFloat
    |nextChar|

    nextChar := source nextPeek.
    nextChar isDigit ifTrue:[
	^ self nextFractionalPart:0.
    ].
    tokenType := tokenValue := $. .
    ^ tokenType
!

nextDotOrFloatOrEllipsis
    |nextChar nextChar2|

    nextChar := source nextPeek.
    (nextChar isNil and:[ source atEnd ]) ifFalse:[
        nextChar isDigit ifTrue:[
            ^ self nextFractionalPart:0.
        ].
        nextChar == $. ifTrue:[
            nextChar2 := source nextPeek.
            nextChar2 == $. ifTrue:[
                source next.
                tokenType := #Ellipsis.
                tokenValue := '...'.
                ^tokenType.
            ] ifFalse:[
                source skip: -1.
            ].
        ].
    ].
    tokenType := tokenValue := $. .
    ^ tokenType

    "Created: / 15-03-2012 / 10:08:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2014 / 16:12:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextFractionalPart:intValue
    |nextChar value|

    value := intValue.
    nextChar := source peekOrNil.

    (nextChar notNil and:[nextChar isDigitRadix:10]) ifTrue:[
        value := value asFloat + (self nextMantissa:10).
        nextChar := source peekOrNil
    ] ifFalse:[
        allowDegeneratedMantissa == true ifTrue:[
            self warning:'degenerated float constant: ' , value printString , '.' .
            tokenValue := value asFloat.
            tokenType := #Float.
            ^ tokenType
        ].
        nextChar := peekChar := $..
    ].

    ((nextChar == $e) or:[nextChar == $E]) ifTrue:[
        value := self exponentPart:value.
        nextChar := source peekOrNil
    ] ifFalse:[
        ((nextChar == $p) or:[nextChar == $P]) ifTrue:[
            value := self hexponentPart:value.
            nextChar := source peekOrNil
        ].
    ].

    tokenValue := value.

    (nextChar == $d or:[nextChar == $D]) ifTrue:[
        source next.
        tokenType := #Double.
    ] ifFalse:[
        (nextChar == $f or:[nextChar == $F]) ifTrue:[
            source next.
        ].
        tokenType := #Float.
    ].

    ^ tokenType

    "Created: / 14-05-1998 / 20:00:25 / cg"
    "Modified: / 16-05-1998 / 15:51:46 / cg"
    "Modified: / 16-03-2012 / 00:00:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextHexFractionalPart:intValue
    |nextChar value|

    value := intValue.
    nextChar := source peekOrNil.

    (nextChar notNil and:[nextChar isDigitRadix:16]) ifTrue:[
        value := value asFloat + (self nextMantissa:16).
        nextChar := source peekOrNil
    ] ifFalse:[
        allowDegeneratedMantissa == true ifTrue:[
            self warning:'degenerated float constant: ' , value printString , '.' .
            tokenValue := value asFloat.
            tokenType := #Float.
            ^ tokenType
        ].
        nextChar := peekChar := $..
    ].

    ((nextChar == $e) or:[nextChar == $E]) ifTrue:[
        value := self exponentPart:value.
        nextChar := source peekOrNil
    ] ifFalse:[
        ((nextChar == $p) or:[nextChar == $P]) ifTrue:[
            value := self hexponentPart:value.
            nextChar := source peekOrNil
        ].
    ].

    tokenValue := value.

    (nextChar == $d or:[nextChar == $D]) ifTrue:[
        source next.
        tokenType := #Double.
    ] ifFalse:[
        (nextChar == $f or:[nextChar == $F]) ifTrue:[
            source next.
        ].
        tokenType := #Float.
    ].

    ^ tokenType

    "Created: / 14-05-1998 / 20:00:25 / cg"
    "Modified: / 16-05-1998 / 15:51:46 / cg"
    "Created: / 16-03-2012 / 00:16:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextIdentifier
    "an alpha character (or underscore) has been read.
     Return the next identifier."

    |nextChar string ok pos|

    hereChar == $_ ifTrue:[
        nextChar := source nextPeek.
        string := '_'.
        [nextChar == $_] whileTrue:[
            string := string copyWith:$_.
            nextChar := source nextPeek.
        ].
        nextChar isAlphaNumeric ifTrue:[
            string := string , source nextAlphaNumericWord.
        ]
    ] ifFalse:[
        string := source nextAlphaNumericWord "self nextId".
    ].
    nextChar := source peekOrNil.

    (nextChar == $_ or:[nextChar == $$]) ifTrue:[
        pos := source position.
        ok := true.
        [ok] whileTrue:[
            string := string copyWith:nextChar.
            nextChar := source nextPeek.
            nextChar isNil ifTrue:[
                ok := false
            ] ifFalse:[
                (nextChar isAlphaNumeric) ifTrue:[
                    string := string , source nextAlphaNumericWord.
                    nextChar := source peekOrNil.
                ].
                (nextChar == $_ or:[nextChar == $$]) ifFalse:[
                    ok := false
                ]
            ]
        ].
    ].

"/    (nextChar == $: and:[scanColonAsLabel]) ifTrue:[
"/        source next.
"/        ch2 := source peekOrNil.
"/        "/ colon follows - care for '::' (nameSpace separator) or ':=' (assignment)
"/        (ch2 == $=) ifFalse:[
"/            (ch2 == $:) ifFalse:[
"/                tokenEndPosition := source position - 1.
"/                token := string copyWith:nextChar.
"/                tokenType := #Keyword.
"/                ^ tokenType
"/            ].
"/            peekChar := $:.
"/            peekChar2 := $:.
"/        ] ifTrue:[
"/            peekChar := $:.
"/            peekChar2 := $=.
"/        ]
"/    ].

    tokenValue := string.
    (self checkForKeyword:string) ifFalse:[
        tokenType := #Identifier.
    ].
    tokenEndPosition := source position - 1.
    peekChar2 notNil ifTrue:[
        tokenEndPosition := tokenEndPosition - 1
    ].
    ^ tokenType

    "Modified: / 15-03-2012 / 20:53:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextMulti:list after:firstChar
    "a char has been read - peek ahead in list"

    |pc|

    peekChar isNil ifTrue:[
	source next.
    ] ifFalse:[
	peekChar := nil.
    ].
    pc := source peek.

    list do:[:spec |
	|ch tok idx|

	ch := spec at:1.
	tok := spec at:2.
	idx := 3.

	pc == ch ifTrue:[
	    peekChar isNil ifTrue:[
		source next.
	    ] ifFalse:[
		peekChar := nil.
	    ].

	    spec size > 2 ifTrue:[
		ch := spec at:3.
		source peek == ch ifTrue:[
		    source next.
		    tok := spec at:4.
		    idx := 5.
		]
	    ].

	    tok isNil ifTrue:[
		^ self perform:(spec at:idx).
	    ].

	    tokenType := tokenValue := tok.
	    ^ tokenType
	]
    ].

    tokenType := tokenValue := firstChar.
    ^ tokenType

    "Created: / 14.5.1998 / 19:19:34 / cg"
    "Modified: / 16.5.1998 / 19:09:59 / cg"
!

nextNumber
    |nextChar value|

    value := 0.
    nextChar := source peekOrNil.
    nextChar == $0 ifTrue:[
        source next.
        nextChar := source peekOrNil.
        (nextChar == $x or:[nextChar == $X]) ifTrue:[
            source next.
            value := Integer readFrom:source radix:16.

            tokenValue := value.
            numberRadix := 16.

            nextChar := source peekOrNil.

            source peekOrNil isNil ifTrue:[
                tokenType := #Integer.
                tokenValue := 0.
                ^tokenType
            ].

            (nextChar == $L or:[nextChar == $l]) ifTrue:[
                source next.
                tokenType := #LongInteger.
            ].
            nextChar == $. ifTrue:[
                source next.
                ^self nextHexFractionalPart: tokenValue.
            ].
            tokenType := #Integer.
            ^ tokenType.

        ].
        (nextChar notNil and:[nextChar between:$0 and:$7]) ifTrue:[
            value := Integer readFrom:source radix:8.
            tokenValue := value.
            numberRadix := 8.

            nextChar := source peekOrNil.
            (nextChar == $L or:[nextChar == $l]) ifTrue:[
                source next.
                tokenType := #LongInteger.
            ] ifFalse:[
                tokenType := #Integer.
            ].
            ^ tokenType
        ].
    ].
    (nextChar == $L or:[nextChar == $l]) ifTrue:[
        source next.
        tokenValue := value.
        tokenType := #LongInteger.
        ^ tokenType
    ].
    (nextChar == $D or:[nextChar == $d]) ifTrue:[
        source next.
        tokenValue := 0.0.
        tokenType := #Double.
        ^ tokenType
    ].



    numberRadix := 10.
    nextChar isDigit ifTrue:[
        value := Integer readFrom:source radix:10.
        nextChar := source peekOrNil.

        (nextChar == $L or:[nextChar == $l]) ifTrue:[
            source next.
            tokenValue := value.
            tokenType := #LongInteger.
            ^ tokenType
        ].
    ].

    (nextChar == $.) ifTrue:[
        nextChar := source nextPeek.
        (nextChar notNil and:[nextChar isDigitRadix:10]) ifTrue:[
            value := value asFloat + (self nextMantissa:10).
            nextChar := source peekOrNil
        ] ifFalse:[
            allowDegeneratedMantissa == true ifTrue:[
                self warning:'degenerated float constant: ' , value printString , '.' .
                tokenValue := value asFloat.
                tokenType := #Float.
                ^ tokenType
            ].

"/            nextChar == (Character cr) ifTrue:[
"/                lineNr := lineNr + 1.
"/            ].
            nextChar := peekChar := $..
        ]
    ].
    ((nextChar == $e) or:[nextChar == $E]) ifTrue:[
        value := self exponentPart:value.
        nextChar := source peekOrNil
    ] ifFalse:[
        ((nextChar == $p) or:[nextChar == $P]) ifTrue:[
            value := self hexponentPart:value.
            nextChar := source peekOrNil
        ]
    ].

    nextChar == $- ifTrue:[
        self
            warnPossibleIncompatibility:'add a space before ''-'' for compatibility with other systems'
            position:(source position) to:source position.
    ].

    (nextChar == $d or:[nextChar == $D]) ifTrue:[
        source next.
        tokenType := #Double.
        value := value asFloat.
    ] ifFalse:[
        (nextChar == $f or:[nextChar == $F]) ifTrue:[
            source next.
            tokenType := #Float.
            value := value asFloat.
        ] ifFalse:[
            (value isMemberOf:Float) ifTrue:[
                tokenType := #Float.
            ] ifFalse:[
                tokenType := #Integer.
            ]
        ]
    ].
    tokenValue := value.
    ^ tokenType

    "Created: / 14-05-1998 / 20:00:25 / cg"
    "Modified: / 16-05-1998 / 15:51:46 / cg"
    "Modified: / 16-03-2012 / 23:34:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextString:delimiter character:isCharacter
    |s pos nextChar inString|

    s := (String new:20) writeStream.

    pos := source position.
    source next.
    nextChar := source next.
    inString := true.

    [inString] whileTrue:[
        nextChar isNil ifTrue:[
            allowRunawayString ifFalse:[
                self syntaxError:'unexpected end-of-input in String'
                        position:pos + 1 to:(source position).
                tokenValue := nil.
                tokenType := #EOF.
                ^ tokenType
            ] ifTrue:[ 
                inString := false.
            ].
        ].
        nextChar == $\ ifTrue:[
            nextChar := source next.
            nextChar := self characterEscape:nextChar.
        ] ifFalse:[
            (nextChar == Character cr) ifTrue:[
                lineNr := lineNr + 1
            ] ifFalse:[
                (nextChar == delimiter) ifTrue:[
                    (source peekOrNil == delimiter) ifTrue:[
                        source next
                    ] ifFalse:[
                        inString := false
                    ]
                ].
            ].
        ].
        inString ifTrue:[
            s nextPut:nextChar.
            nextChar := source next
        ]
    ].

    tokenValue := s contents.
    isCharacter ifTrue:[
        tokenValue size ~~ 1 ifTrue:[
            self syntaxError:'bad (multi-)character constant'
                    position:pos to:(source position - 1).
        ].
        tokenValue := tokenValue at:1.
        tokenType := #Character.
    ] ifFalse:[
        tokenType := #String.
    ].
    ^ tokenType

    "Created: / 16-05-1998 / 19:53:05 / cg"
    "Modified: / 11-08-2014 / 21:19:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextToken
    |t|

    [
        t := super nextToken.
        tokenEndPosition := source position - 1.
        t isNil
    ] whileTrue.
    Verbose == true ifTrue:[
        Transcript 
            show:'JavaScanner nextToken => ';
            show: tokenLineNr printString;
            show: ' | ';
            show: t storeString;
            show: ' | ';
            showCR: tokenValue.
    ].
    ^ t

    "Created: / 14-05-1998 / 15:48:04 / cg"
    "Modified: / 16-05-1998 / 19:12:29 / cg"
    "Modified: / 12-05-2014 / 16:29:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipComment
    |startPos|

    startPos := source position.
    source next.
    hereChar := source peekOrNil.

    [
        [hereChar notNil and:[hereChar ~~ $*]] whileTrue:[
            hereChar == (Character cr) ifTrue:[
                lineNr := lineNr + 1.
            ].
            hereChar := source nextPeek
        ].
    ] doUntil:[
        hereChar := source nextPeek.
        hereChar isNil or:[hereChar == $/].
    ].

    "skip final /"
    source next.

    hereChar isNil ifTrue:[
        self warning:'unclosed comment' position:startPos - 2" '/*' already eaten" to:(source position)
    ].

    saveComments ifTrue:[
        self addComment: (startPos - 2" '/*' already eaten" to: source position - 1)
    ].
    ^ nil. "/ force nextToken again

    "Modified: / 31-03-1998 / 23:45:26 / cg"
    "Modified: / 30-08-2013 / 02:51:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipEOLComment
    hereChar := source peek.
    [hereChar notNil and:[hereChar ~~ Character cr]] whileTrue:[
	hereChar := source nextPeek.
    ].
    lineNr := lineNr + 1.

    ^ nil.

    "Created: / 16.5.1998 / 19:11:05 / cg"
    "Modified: / 16.5.1998 / 19:15:42 / cg"
! !

!JavaScanner methodsFor:'stream api'!

atEnd
    ^ source atEnd

    "Created: / 14-03-2012 / 22:53:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

next
    ^ source next

    "Created: / 14-03-2012 / 22:53:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

next: anInteger 
    "Answer up to anInteger elements of my collection. Overridden for efficiency."

    ^ source nextAvailable: anInteger

    "Modified: / 14-03-2012 / 22:55:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

peek
    "An improved version of peek, that is slightly faster than the built in version."

    ^source peek

    "Modified: / 14-03-2012 / 22:46:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

position
    ^source position

    "Created: / 14-03-2012 / 22:52:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

position: anInteger
    "The receiver does not check for invalid arguments passed to this method, as it is solely used with valid indexes for backtracking."

"/    anInteger = 16 ifTrue:[self halt].

    ^source position: anInteger

    "Modified: / 15-03-2012 / 10:59:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipSeparators

    source skipSeparators

    "Created: / 15-03-2012 / 10:35:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

uncheckedPeek
    "An unchecked version of peek that throws an error if we try to peek over the end of the stream, even faster than #peek."

    ^ self peek

    "Modified: / 14-03-2012 / 22:46:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScanner::Token class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

!JavaScanner::Token methodsFor:'accessing'!

endPosition
    ^ endPosition
!

endPosition:something
    endPosition := something.
!

startPosition
    ^ startPosition
!

startPosition:something
    startPosition := something.
!

stopPosition
    ^ endPosition

    "Created: / 04-04-2013 / 00:32:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    ^ type
!

type:something
    type := something.
!

value
    ^ value
!

value:something
    value := something.
! !

!JavaScanner::Token methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    aStream nextPut: ${.
    type printOn:aStream.
    aStream nextPutAll:' - '.
    value printOn:aStream.
    aStream nextPutAll:' <'.
    startPosition printOn:aStream.
    aStream nextPutAll:'-'.
    endPosition printOn:aStream.
    aStream nextPutAll:' >}'.

    "Modified: / 11-01-2013 / 12:32:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScanner class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaScanner.st,v 1.5 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

