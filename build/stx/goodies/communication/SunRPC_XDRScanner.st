"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: SunRPC }"

Scanner subclass:#XDRScanner
	instanceVariableNames:'peekTokens'
	classVariableNames:'Verbose'
	poolDictionaries:''
	category:'Net-Communication-SunRPC-XDR_IDL'
!

!XDRScanner class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    scanner for XDR-definition files - provides token scanning functionality
    for the XDRParser. (normally not used by its own).
    XDR is the IDL of SunRPC.

    [author:]
        Claus Gittinger
"

    "Created: / 13.5.1998 / 14:54:06 / cg"
!

syntax
'
      declaration:
           type-specifier identifier
         | type-specifier identifier "[" value "]"
         | type-specifier identifier "<" [ value ] ">"
         | "opaque" identifier "[" value "]"
         | "opaque" identifier "<" [ value ] ">"
         | "string" identifier "<" [ value ] ">"
         | type-specifier "*" identifier
         | "void"

      value:
           constant
         | identifier

      type-specifier:
           [ "unsigned" ] "int"
         | [ "unsigned" ] "hyper"
         | "float"
         | "double"
         | "bool"
         | enum-type-spec
         | struct-type-spec
         | union-type-spec
         | identifier

      enum-type-spec:
         "enum" enum-body

      enum-body:
         "{"
            ( identifier "=" value )
            ( "," identifier "=" value )*
         "}"

      struct-type-spec:
         "struct" struct-body

      struct-body:
         "{"
            ( declaration ";" )
            ( declaration ";" )*
         "}"

      union-type-spec:
         "union" union-body

      union-body:
         "switch" "(" declaration ")" "{"
            ( "case" value ":" declaration ";" )
            ( "case" value ":" declaration ";" )*
            [ "default" ":" declaration ";" ]
         "}"

      constant-def:
         "const" identifier "=" constant ";"

      type-def:
           "typedef" declaration ";"
         | "enum" identifier enum-body ";"
         | "struct" identifier struct-body ";"
         | "union" identifier union-body ";"

      program-def:
         "program" identifier "{"
            version-def
            version-def *
         "}" "=" constant ";"

      version-def:
         "version" identifier "{"
             procedure-def
             procedure-def *
         "}" "=" constant ";"

      procedure-def:
         type-specifier identifier "(" type-specifier
           ("," type-specifier )* ")" "=" constant ";"

      definition:
           type-def
         | constant-def
         | program-def

      specification:
           definition *
'
! !

!XDRScanner class methodsFor:'initialization'!

initialize
    ObjectMemory addDependent:self.
    self setupActions.

    "Created: / 21.12.2001 / 21:11:17 / cg"
!

setupActions
    "initialize the scanners actionTables - these are used to dispatch
     into scanner methods as characters are read"

    |block|

    ActionArray := Array new:256.
    TypeArray := Array new:256.

    block := [:s :char | s nextNumber].
    ($0 codePoint) to:($9 codePoint) do:[:index |
        ActionArray at:index put:block
    ].

    block := [:s :char | s nextToken:char].
    #( $: $; $. $, ${ $} $( $) $[ $] "$!!" $~ $^ $& $| $_ $* $% $/ $#) do:[:ch |
        ActionArray at:(ch codePoint) put:block
    ].

    block := [:s :char | s nextIdentifier].
    ($a codePoint) to:($z codePoint) do:[:index |
        ActionArray at:index put:block
    ].
    ($A codePoint) to:($Z codePoint) do:[:index |
        ActionArray at:index put:block
    ].
    ActionArray at:$_ codePoint put:block.

    ActionArray at:($' codePoint) put:[:s :char | s nextCharacter].
    ActionArray at:($" codePoint) put:[:s :char | s nextString].
    ActionArray at:($= codePoint) put:[:s :char | s nextEq].

    ActionArray at:($- codePoint) put:[:s :char | s nextMinus].
    ActionArray at:($+ codePoint) put:[:s :char | s nextPlus].

    ActionArray at:($> codePoint) put:[:s :char | s nextGT].
    ActionArray at:($< codePoint) put:[:s :char | s nextLT].

    ActionArray at:($/ codePoint) put:[:s :char | s nextSlash].

    "
     XDRScanner setupActions
    "

    "Modified: / 11.3.1999 / 22:01:35 / cg"
    "Created: / 21.12.2001 / 21:11:17 / cg"
!

update:something with:parameter from:changedObject
    "/ bug work-around (compiled cheap blocks loose their code)
    something == #earlyRestart ifTrue:[
        changedObject == ObjectMemory ifTrue:[
            self setupActions
        ]
    ]

    "Created: / 21.12.2001 / 21:11:17 / cg"
! !

!XDRScanner methodsFor:'accessing'!

newSource:aStringOrStream
    self source:aStringOrStream.
    errorFlag := false.
    tokenPosition := 1.
    tokenLineNr := lineNr := 1.
    currentComments := nil.

    "Created: / 21.12.2001 / 21:11:16 / cg"
    "Modified: / 22.12.2001 / 02:25:56 / cg"
!

source
    ^ source
! !

!XDRScanner methodsFor:'initialization'!

initialize
    "initialize the scanner"

    super initialize.

    "/ have my own tables ...
    parserFlags := parserFlags copy.
    parserFlags allowUnderscoreInIdentifier:true.
    parserFlags allowDollarInIdentifier:false.
    scanColonAsKeyword := false.

    self class actionArray isNil ifTrue:[
        self class setupActions
    ].
    actionArray := self class actionArray.
    typeArray := self class typeArray.

    "Created: / 21.12.2001 / 21:11:16 / cg"
    "Modified: / 21.12.2001 / 21:31:22 / cg"
! !

!XDRScanner methodsFor:'private'!

checkForKeyword:string
    "check if string is a keyword (as opposed to an identifier)."

    |firstChar|

    firstChar := string at:1.
    (firstChar == $b) ifTrue:[
        (string = 'bool')  ifTrue:[tokenType := #bool. ^true].
    ].
    (firstChar == $c) ifTrue:[
        (string = 'const') ifTrue:[tokenType := #const. ^true].
        (string = 'case') ifTrue:[tokenType := #case. ^true].
        (string = 'char') ifTrue:[tokenType := #char. ^true].
    ].
    (firstChar == $d) ifTrue:[
        (string = 'double') ifTrue:[tokenType := #double. ^true].
        (string = 'default') ifTrue:[tokenType := #default. ^true].
    ].
    (firstChar == $e) ifTrue:[
        (string = 'enum') ifTrue:[tokenType := #enum. ^true].
    ].
    (firstChar == $f) ifTrue:[
        (string = 'float') ifTrue:[tokenType := #float. ^true]
    ].
    (firstChar == $h) ifTrue:[
        (string = 'hyper') ifTrue:[tokenType := #hyper. ^true].
    ].
    (firstChar == $i) ifTrue:[
        (string = 'interface') ifTrue:[tokenType := #interface. ^true].
        (string = 'int') ifTrue:[tokenType := #int. ^true].
    ].
    (firstChar == $l) ifTrue:[
        (string = 'long') ifTrue:[tokenType := #long. ^true]
    ].
    (firstChar == $o) ifTrue:[
        (string = 'opaque') ifTrue:[tokenType := #opaque. ^true]
    ].
    (firstChar == $p) ifTrue:[
        (string = 'program') ifTrue:[tokenType := #program. ^true]
    ].
    (firstChar == $s) ifTrue:[
        (string = 'struct')  ifTrue:[tokenType := #struct. ^true].
        (string = 'string')  ifTrue:[tokenType := #string. ^true].
        (string = 'switch')  ifTrue:[tokenType := #switch. ^true].
        (string = 'short')  ifTrue:[tokenType := #short. ^true].
    ].
    (firstChar == $t) ifTrue:[
        (string = 'typedef')  ifTrue:[tokenType := #typedef. ^true].
    ].
    (firstChar == $u) ifTrue:[
        (string = 'unsigned') ifTrue:[tokenType := #unsigned. ^true].
        (string = 'union') ifTrue:[tokenType := #union. ^true].
    ].
    (firstChar == $v) ifTrue:[
        (string = 'void')  ifTrue:[tokenType := #void. ^true].
        (string = 'version')  ifTrue:[tokenType := #version. ^true].
    ].
    ^ false

    "Modified: / 11.5.1999 / 14:17:14 / stefan"
    "Created: / 21.12.2001 / 21:11:16 / cg"
    "Modified: / 22.12.2001 / 15:31:37 / cg"
!

isCommentCharacter:ch
    "return true, if ch is the comment-start character"

    ^ false

    "Created: / 21.12.2001 / 21:11:16 / cg"
!

pushBack:aToken
    peekTokens isNil ifTrue:[
        peekTokens := OrderedCollection new.
    ].
    peekTokens addFirst:aToken

    "Created: / 21.12.2001 / 21:34:42 / cg"
!

skipForClosing:closingToken with:openingToken
    |level|

    level := 1.
    [level > 0] whileTrue:[
        tokenType == openingToken ifTrue:[
            level := level + 1
        ] ifFalse:[
            tokenType == closingToken ifTrue:[
                level := level - 1
            ]
        ].
        self nextToken.
    ].

    "Created: / 21.12.2001 / 21:11:16 / cg"
! !

!XDRScanner methodsFor:'reading next token'!

nextCharacter
    "a single quote has been scanned; scan the character-string (caring for quotes).
     TODO: C-escapes; \0xx; \0xxx"

    |nextChar string pos
     index "{ Class: SmallInteger }"
     len   "{ Class: SmallInteger }"
     inString|

    string := String basicNew:2.
    len := 2.
    index := 1.
    pos := source position.
    source next.
    nextChar := source next.
    inString := true.

    [inString] whileTrue:[
        nextChar isNil ifTrue:[
            self syntaxError:'unexpected end-of-input in Character'
                    position:pos to:(source position - 1).
            self markStringFrom:pos to:source position-1.
            token := nil.
            tokenType := #EOF.
            ^ tokenType
        ].
        (nextChar == Character cr) ifTrue:[
            lineNr := lineNr + 1
        ].
        (nextChar == Character quote) ifTrue:[
            inString := false
        ].
        (nextChar == $\) ifTrue:[
            nextChar := source next.
            nextChar == $n ifTrue:[
                nextChar := Character nl
            ] ifFalse:[ nextChar == $r ifTrue:[
                nextChar := Character return
            ] ifFalse:[ nextChar == $t ifTrue:[
                nextChar := Character tab
            ] ifFalse:[ nextChar == $b ifTrue:[
                nextChar := Character backspace
            ] ifFalse:[ 

            ]]]].
        ].
        inString ifTrue:[
            string at:index put:nextChar.
            (index == len) ifTrue:[
                string := string , (String new:len).
                len := len * 2
            ].
            index := index + 1.
            nextChar := source next
        ]
    ].
    self markStringFrom:pos to:source position-1.

    tokenValue := token := string copyTo:(index - 1).
    tokenType := #Character.

    string size ~~ 1 ifTrue:[
        self syntaxError:'bad (long) character constant'
                position:pos to:(source position - 1).
        self markStringFrom:pos to:source position-1.
    ].
    tokenValue := token := string at:1.
    ^ tokenType
!

nextEq
    "'=' has been read - look for another '='"

    |next|

    source next.
    next := peekChar ? source peek.

    peekChar == $= ifTrue:[
        self eatPeekChar.
        tokenType := token := #'=='.
        ^ tokenType
    ].

    tokenType := token := $=.
    ^ tokenType

    "Modified: / 24.10.1998 / 17:28:31 / cg"
    "Created: / 21.12.2001 / 21:11:16 / cg"
!

nextGT
    "'>' has been read - look for another '>'"

    |next|

    source next.
    next := peekChar ? source peek.

    peekChar == $> ifTrue:[
        self eatPeekChar.
        tokenType := token := #'>>'.
        ^ tokenType
    ].
    peekChar == $= ifTrue:[
        self eatPeekChar.
        tokenType := token := #'>='.
        ^ tokenType
    ].

    tokenType := token := $>.
    ^ tokenType

    "Modified: / 24.10.1998 / 17:28:46 / cg"
    "Created: / 21.12.2001 / 21:11:16 / cg"
!

nextLT
    "'<' has been read - look for another '<'"

    |next|

    source next.
    next := peekChar ? source peek.

    next == $< ifTrue:[
        self eatPeekChar.
        tokenType := token := #'<<'.
        ^ tokenType
    ].
    next == $= ifTrue:[
        self eatPeekChar.
        tokenType := token := #'<='.
        ^ tokenType
    ].

    tokenType := token := $<.
    ^ tokenType

    "Modified: / 24.10.1998 / 17:28:51 / cg"
    "Created: / 21.12.2001 / 21:11:16 / cg"
!

nextMinus
    "'-' has been read - look for another '-'"

    |next|

    source next.
    next := peekChar ? source peek.

    peekChar == $- ifTrue:[
        self eatPeekChar.
        tokenType := token := #'--'.
        ^ tokenType
    ].
    peekChar == $= ifTrue:[
        self eatPeekChar.
        tokenType := token := #'-='.
        ^ tokenType
    ].

    tokenType := token := $-.
    ^ tokenType

    "Modified: / 24.10.1998 / 17:28:55 / cg"
    "Created: / 21.12.2001 / 21:11:16 / cg"
!

nextNumber
    "a digit has been read; scan a number (0xfoo / 0octal / decimal or float).
     if specialFloat is true, return float value as hi.low (for version numbers)"

    |nextChar value s skipIntegerPart|

    skipIntegerPart := false.
    nextChar := source peekOrNil.
    nextChar == $0 ifTrue:[
        source next.
        nextChar := source peekOrNil.
        (nextChar ~~ $. 
        and:[nextChar ~~ $e 
        and:[nextChar ~~ $E]]) ifTrue:[
            (nextChar == $x or:[nextChar == $X]) ifTrue:[
                source next.
                value := Integer readFrom:source radix:16.

                tokenValue := token := value.
                tokenType := #Integer.
                ^ tokenType
            ].
            nextChar isDigit ifFalse:[
                tokenValue := token := 0.
                tokenType := #Integer.
                ^ tokenType
            ].
            (nextChar between:$0 and:$7) ifTrue:[
                value := Integer readFrom:source radix:8.
                tokenValue := token := value.
                tokenType := #Integer.
                ^ tokenType
            ].
        ] ifFalse:[
            value := 0.
            skipIntegerPart := true.
        ]
    ].

    skipIntegerPart ifFalse:[
        value := Integer readFrom:source radix:10.
        nextChar := source peekOrNil.
    ].

    (nextChar == $.) ifTrue:[
        nextChar := source nextPeek.
        (nextChar notNil and:[nextChar isDigitRadix:10]) ifTrue:[
            value := value asFloat + (self nextMantissa:10).
            nextChar := source peekOrNil
        ] ifFalse:[
"/            nextChar == (Character cr) ifTrue:[
"/                lineNr := lineNr + 1.
"/            ].
            nextChar := peekChar := $..
        ]
    ].
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
    nextChar == $- ifTrue:[
        self
            warnPossibleIncompatibility:'add a space before ''-'' for compatibility with other systems'
            position:(source position) to:source position.
    ].

    tokenValue := token := value.
    (value isMemberOf:Float) ifTrue:[
        (nextChar == $d) ifTrue:[
            source next
        ].
        tokenType := #Float
    ] ifFalse:[
        tokenType := #Integer
    ].
"/    self markConstantFrom:tokenPosition to:(source position - 1).
    ^ tokenType

    "Modified: / 15.5.1998 / 21:29:13 / cg"
    "Created: / 21.12.2001 / 21:11:16 / cg"
!

nextPlus
    "'+' has been read - look for another '+'"

    |next|

    source next.
    next := peekChar ? source peek.

    peekChar == $+ ifTrue:[
        self eatPeekChar.
        tokenType := token := #'++'.
        ^ tokenType
    ].
    peekChar == $= ifTrue:[
        self eatPeekChar.
        tokenType := token := #'+='.
        ^ tokenType
    ].

    tokenType := token := $+.
    ^ tokenType

    "Modified: / 24.10.1998 / 17:29:00 / cg"
    "Created: / 21.12.2001 / 21:11:16 / cg"
!

nextSlash
    "'/' has been read - next could be:
          '/'   - EOL comment 
          '*'   - regular comment
    "

    |next|

    source next.
    next := peekChar ? source peek.

    next == $/ ifTrue:[
        [next notNil and:[next ~~ Character cr]] whileTrue:[
            next := source nextPeek.
        ].
        ^ nil
    ].
    next == $* ifTrue:[
        [
            [next notNil and:[next ~~ $*]] whileTrue:[
                next := source next.
            ].
            next := source next.
        ] doWhile:[ next notNil and:[next ~~ $/] ].
        ^ nil
    ].

    tokenType := token := $/.
    ^ tokenType

    "Modified: / 11.3.1999 / 22:02:31 / cg"
    "Modified: / 11.5.1999 / 14:05:49 / stefan"
    "Created: / 21.12.2001 / 21:11:17 / cg"
!

nextString
    "a doubled quote has been scanned; scan the string (caring for doubled quotes"

    |nextChar string pos
     index "{ Class: SmallInteger }"
     len   "{ Class: SmallInteger }"
     inString|

    string := String basicNew:20.
    len := 20.
    index := 1.
    pos := source position.
    source next.
    nextChar := source next.
    inString := true.

    [inString] whileTrue:[
        nextChar isNil ifTrue:[
            self syntaxError:'unexpected end-of-input in String'
                    position:pos to:(source position - 1).
            self markStringFrom:pos to:source position-1.
            token := nil.
            tokenType := #EOF.
            ^ tokenType
        ].

        (nextChar == Character cr) ifTrue:[
            lineNr := lineNr + 1
        ].
        (nextChar == Character doubleQuote) ifTrue:[
"/            (source peekOrNil == Character doubleQuote) ifTrue:[
"/                source next
"/            ] ifFalse:[
            inString := false
"/            ]
        ].
        (nextChar == $\) ifTrue:[
            nextChar := source next.
            nextChar == $n ifTrue:[
                nextChar := Character nl
            ] ifFalse:[ nextChar == $r ifTrue:[
                nextChar := Character return
            ] ifFalse:[ nextChar == $t ifTrue:[
                nextChar := Character tab
            ] ifFalse:[ nextChar == $b ifTrue:[
                nextChar := Character backspace
            ] ifFalse:[ 

            ]]]].
        ].
        inString ifTrue:[
            string at:index put:nextChar.
            (index == len) ifTrue:[
                string := string , (String new:len).
                len := len * 2
            ].
            index := index + 1.
            nextChar := source next
        ]
    ].
    self markStringFrom:pos to:source position-1.

    tokenValue := token := string copyTo:(index - 1).
    tokenType := #String.
    ^ tokenType

    "Modified: / 31.3.1998 / 17:33:14 / cg"
    "Created: / 21.12.2001 / 21:11:17 / cg"
!

nextToken
    "return the next token from my source-stream"

    |t|

    peekTokens notNil ifTrue:[
        t := peekTokens removeFirst.
        peekTokens isEmpty ifTrue:[
            peekTokens := nil
        ].
    ] ifFalse:[
        t := super nextToken.
    ].

    Verbose == true ifTrue:[Transcript showCR:t].
    ^ t

    "Created: / 21.12.2001 / 21:11:17 / cg"
    "Modified: / 21.12.2001 / 22:09:31 / cg"
! !

!XDRScanner methodsFor:'specials'!

readingStream:aStream do:aBlock
    |momento|

    momento := self shallowCopy.

    source := aStream.
    lineNr := tokenLineNr := 1.
    hereChar := peekChar := peekChar2 := nil.
    self nextToken.

    aBlock
        ensure:[ 
            source := momento source.
            lineNr := momento lineNr.
            tokenLineNr := momento tokenLineNr.
            hereChar := momento hereChar.
            peekChar := momento peekChar.
            peekChar2 := momento peekChar2.
            tokenType := momento tokenType.
            tokenPosition := momento tokenPosition.
            token := momento token.
        ]

    "Created: / 22.12.2001 / 10:18:58 / cg"
    "Modified: / 22.12.2001 / 10:20:00 / cg"
!

restOfLine
    source skipSeparatorsExceptCR.
    ^ source upTo:Character cr.

    "Created: / 21.12.2001 / 21:11:17 / cg"
! !

!XDRScanner class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRScanner.st,v 1.12 2017-11-18 09:52:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRScanner.st,v 1.12 2017-11-18 09:52:03 cg Exp $'
! !


XDRScanner initialize!
