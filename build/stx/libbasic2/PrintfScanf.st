"{ Encoding: utf8 }"

"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PrintfScanf
	instanceVariableNames:''
	classVariableNames:'Singleton'
	poolDictionaries:''
	category:'System-Support'
!

!PrintfScanf class methodsFor:'documentation'!

documentation
"   
    Contributed by Jan Steinman donated to the
    community in 1989.

    Provided AS-IS - no warranty, use at your own risk.

    Original comment:

        NAME            printf-scanf
        AUTHOR          Jan Steinman <jans@tekgvs.labs.tek.com>
        FUNCTION        printf and scanf for Smalltalk
        ST-VERSIONS     Tek 2.2.2a 4.0
        PREREQUISITES   CharacterComparing
        CONFLICTS       
        DISTRIBUTION    world
        VERSION         1.1
        DATE            Apr 1989?
        SUMMARY 

    The following methods implement printf and scanf functionality.  They
    are intended to be used to ease porting between Smalltalk and C, and
    for facilitating machine-machine communication.  They are not at all
    intended as replacements for Smalltalk's printOn: functionality.

    Jan Steinman - N7JDB
    Tektronix Electronic Systems Laboratory
    Box 500, MS 50-370, Beaverton, OR 97077
    (w)503/627-5881 (h)503/657-7703
"
!

examples
"
    self new printf:'%#x %#X %03o%*.*s' arguments: #(16rABCD 16rEF 5 9 5 ''ghijklmn'') 

    self new printf:'%- 10.4s%.2e' arguments: { 'abcdefghijkl' . Float pi }  

    self new printf:'%8.3f' arguments: { 200 sqrt negated }

    self new printf:'%x' arguments: #(16r41)  
    self new printf:'%#x' arguments: #(16r41)   
    self new printf:'%d' arguments: #(16r41)  
    self new printf:'%b' arguments: #(16r41)  
    self new printf:'%c' arguments: #(16r41) 
    self new printf:'%c' arguments: #( $A )  
    self new printf:'%s' arguments: #( $A )  
    self new printf:'%s' arguments: #( 'hello' )   
    self new printf:'%4s' arguments: #( 'hello' )   
    self new printf:'%7s' arguments: #( 'hello' )   

    self new sscanf:'%f%2s%s%s%s' fromString: '237.0 this is a test' 

    self new sscanf:'%d%f%s' fromString: '25 54.32e-01 monday'

    self new sscanf:'%f%*f %8[A-F0-9]%c%d 0x%x%f' fromString: '12.45 1048.73 AE40Z527 0x75BCD15 34' 

    '%#x %#X %03o%*.*s' printf: #(16rABCD 16rEF 5 9 5 ''ghijklmn'') 

    '%- 10.4s%.2e' printf: { 'abcdefghijkl' . Float pi }  

    '%8.3f' printf: { 200 sqrt negated }

    '%c' printf: #(16r41)

    '%f%2s%s%s%s' sscanf: '237.0 this is a test' 

    '%d%f%s' sscanf: '25 54.32e-01 monday'

    '%f%*f %8[A-F0-9]%c%d 0x%x%f' sscanf: '12.45 1048.73 AE40Z527 0x75BCD15 34'
"
! !

!PrintfScanf class methodsFor:'instance creation'!

new
    Singleton isNil ifTrue:[
        Singleton := self basicNew
    ].    
    ^ Singleton
! !

!PrintfScanf class methodsFor:'printing'!

printf:formatString arguments:args 
    "Format and print the receiver with <args> formatted in C style, 
     as described in the UTek manual page for printf(3)."

    ^ self new printf:formatString arguments:args
!

printf:formatString on:outStream arguments: args
    "Format and print formatString on <outStream> with <args>
     formatted in C style, as described in the UTek manual page for
     printf(3).  This method is designed for producing output
     suitable for a machine."     

    ^ self new printf:formatString on:outStream arguments: args
! !

!PrintfScanf class methodsFor:'scanning'!

scanf:formatString fromStream:dataStream 
    "Return a Collection of objects found in the Character Stream
     <dataStream> as interpreted according to the receiver.  The
     receiver is assumed to be a conversion control string as
     specified in the UTek manual page for scanf(3)."

   ^ self new scanf:formatString fromStream:dataStream
!

sscanf:formatString fromString:aString 
    "Return a Collection of objects found in <string> as
     interpreted according to the receiver.  The receiver is
     assumed to be a conversion control string as specified in the
     UTek manual page for scanf(3)."

   ^ self new sscanf:formatString fromString:aString
! !

!PrintfScanf methodsFor:'helpers'!

absDecimalPrintFloat:aFloat on:aStream digits:digits 
    "Place a string representation of the receiver on <aStream> using <digits> significant digits, using decimal notation."
    
    |exp x fuzz i|

    "x is myself normalized to (1.0, 10.0), exp is my exponent"
    exp := aFloat abs < 1.0 ifTrue:[
                (10.0 / aFloat abs) log floor negated
            ] ifFalse:[
                aFloat abs log floor
            ].
    x := aFloat abs / (10.0 raisedTo:exp).
    fuzz := 10.0 raisedTo:1 - digits.
    x := 0.5 * fuzz + x.
    x >= 10.0 ifTrue:[ 
        "check if rounding has unnormalized x" 
        x := x / 10.0.
        exp := exp + 1
    ].
    exp < 0 ifTrue:[
        1 to:1 - exp do:[:j | 
            aStream nextPut:('0.000000000000' at:j)
        ]
    ].
    [ x >= fuzz ] whileTrue:[ 
        "use fuzz to track significance" 
        i := x truncated.
        aStream nextPut:(48 + i) asCharacter.
        x := (x - i) * 10.0.
        fuzz := fuzz * 10.0.
        exp := exp - 1.
        exp = -1 ifTrue:[
            aStream nextPut:$.
        ]
    ].
    [ exp >= -1 ] whileTrue:[
        aStream nextPut:$0.
        exp := exp - 1.
        exp = -1 ifTrue:[
            aStream nextPut:$.
        ]
    ]
!

absPrintFloat:aFloat on:aStream digits:digits 
    "Place a string representation of the receiver on <aStream> using <digits> significant digits."
    
    (aFloat < 1.0e6 and:[ aFloat > 1.0e-4 ]) ifTrue:[
        self 
            absDecimalPrintFloat:aFloat
            on:aStream
            digits:digits
    ] ifFalse:[
        aFloat 
            absScientificPrintFloat:aFloat
            on:aStream
            digits:digits
    ]
!

absScientificPrintFloat:aFloat on:aStream digits:digits 
    "Place a string representation of the receiver on <aStream> using <digits> significant digits, using scientific notation."
    
    |exp fuzz x q i|

    "x is myself normalized to [1.0, 10.0), exp is my exponent"
    exp := aFloat abs < 1.0 ifTrue:[
                (10.0 / aFloat abs) log floor negated
            ] ifFalse:[
                aFloat abs log floor
            ].
    x := aFloat abs / (10.0 raisedTo:exp).
    fuzz := 10.0 raisedTo:1 - digits.
    x := 0.5 * fuzz + x.
    x >= 10.0 ifTrue:[ "check if rounding has unnormalized x" 
        x := x / 10.0.
        exp := exp + 1
    ].
    q := exp.
    exp := 0.
    [ x >= fuzz ] whileTrue:[
        "use fuzz to track significance" 
        i := x truncated.
        aStream nextPut:(48 + i) asCharacter.
        x := (x - i) * 10.0.
        fuzz := fuzz * 10.0.
        exp := exp - 1.
        exp = -1 ifTrue:[
            aStream nextPut:$.
        ]
    ].
    [ exp >= -1 ] whileTrue:[
        aStream nextPut:$0.
        exp := exp - 1.
        exp = -1 ifTrue:[
            aStream nextPut:$.
        ]
    ].
    aStream nextPut:$e.
    q printOn:aStream
!

formatArgCountFor:aFormatString
    "Return the number of arguments required/produced,
     if the argument is interpreted as a printf/scanf format control string."

    |nonConsecutive count|

    nonConsecutive := true.
    count := 0.
    aFormatString do:[:c |
        c == $% ifTrue:[
            nonConsecutive ifTrue:[
                count := count + 1. 
                nonConsecutive := false
            ] ifFalse:[
                count := count - 1. 
                nonConsecutive := true
            ]
        ] ifFalse:[
            nonConsecutive := true
        ]
    ].
    ^ count
! !

!PrintfScanf methodsFor:'printing'!

printArgFrom:inStream to:outStream arguments:argStream
    "Interpret the required number of arguments from <argStream>
     according to the formatting information in <inStream>.  Place
     the interpretation on <outStream>.  The interpretation is C
     printf(3) style, as described in the UTek manual page for
     printf(3).  <inStream> is assumed to be positioned just past
     $%, and a complete control string is assumed available.     

     Return when the conversion control string is consumed.  
     Leave <inStream> pointing past the last character in the conversion control string.

     This code assumes that <inStream> is formatted according to
     specification, and error checking is minimal.  Unexpected
     results will be obtained by illegal control strings, or when
     argument types do not match conversion codes, but it probably
     won't dump core, like C does in such cases!!!!"    

    | ljust plus pound width precision pad char arg argString |

    ljust := plus := pound := false.
    width := 0.
    precision := SmallInteger maxVal.
    pad := $ .
    char := inStream peek.

    char == $% ifTrue:[ 
        ^ outStream nextPut: inStream next
    ].

    char == $- ifTrue:[
        ljust := true.  
        inStream next.  
        char := inStream peek
    ].

    char == $  ifTrue:[
        outStream space.  
        inStream next.  
        char := inStream peek
    ].

    char == $+ ifTrue:[
        plus := true.  
        inStream next. 
        char := inStream peek
    ].

    char == $# ifTrue:[
        pound := true.  
        inStream next.  
        char := inStream peek
    ].

    char == $* ifTrue:[
        width := argStream next.  
        inStream next.  
        char := inStream peek
    ].

    char isDigit ifTrue:[
        char == $0 ifTrue: [pad := $0].
        width := Integer readFrom: inStream.  
        char := inStream peek
    ].

    char == $. ifTrue:[
        inStream next.  char := inStream peek.
        char == $*
            ifTrue: [precision := argStream next.  inStream next.]
            ifFalse: [precision := Integer readFrom: inStream.].
        char := inStream peek
    ].

    char == $l ifTrue:[
        "Ignore long specifier."
        inStream next.  char := inStream peek
    ].

    ('feg' includes: char) ifTrue:[
            arg := argStream next asFloat.
            precision := precision min: 6.
            argString := WriteStream on:''.
            char == $g ifTrue:
                    [self absPrintFloat:arg on: argString digits: precision + 1].
            char == $f ifTrue:
                    [self absDecimalPrintFloat:arg on: argString digits: precision + arg abs log + 1].
            char == $e ifTrue:
                    [self absScientificPrintFloat:arg on: argString digits: precision + 1].
            argString := argString contents.
            arg < 0
                    ifTrue: [argString := '-', argString]
                    ifFalse: [plus ifTrue: [argString := '+', argString]].
            (precision = 0 and: [pound not]) ifTrue:
                    [(argString includes: $e)
                            ifTrue: ["self halt"]
                            ifFalse:
                                    [argString := arg truncated printString]].
            pound ifTrue:
                    [(argString includes: $e)
                            ifTrue: ["self halt"]
                            ifFalse:
                                    [precision - (argString size - (argString indexOf: $.)) timesRepeat:
                                            [argString := argString, '0']]].
            ljust ifTrue: [outStream nextPutAll: argString].
            width - argString size timesRepeat: [outStream nextPut: pad].
            ljust ifFalse: [outStream nextPutAll: argString].
            ^inStream next
    ].

    char == $c ifTrue:[
        arg := argStream next asCharacter asString
    ].
        
    char == $s ifTrue:[
        "Assume the arg is a String or Symbol."
        arg := argStream next asString
    ].

    char == $d ifTrue:[
        arg := argStream next asInteger printString.
        plus ifTrue: [arg := '+', arg]
    ].

    char == $u ifTrue:[
        arg := argStream next asInteger abs printString
    ].

    char == $o ifTrue:[
        arg := argStream next asInteger abs printStringRadix: 8.
            pound ifTrue: [arg := '0', arg]
    ].

    ('xX' includes: char) ifTrue:[
        arg := argStream next asInteger abs printStringRadix: 16.
        pound ifTrue: [arg := '0x', arg]
    ].
    ('bB' includes: char) ifTrue:[
        arg := argStream next asInteger abs printStringRadix: 2.
        pound ifTrue: [arg := '0b', arg]
    ].

    char == $x ifTrue:[
        1 to: arg size do: [:i |
                    ('ABCDEF' includes: (arg at: i)) ifTrue:
                            [arg at: i put: (arg at: i) asLowercase]
        ]
    ].

    precision := precision min: arg size.
    ljust ifTrue: [outStream nextPutAll: (arg copyFrom: 1 to: precision)].
    width - precision timesRepeat: [outStream nextPut: pad].
    ljust ifFalse: [outStream nextPutAll: (arg copyFrom: 1 to: precision)].
    ^ inStream next

    "Modified (format): / 24-07-2011 / 08:39:04 / cg"
!

printf:aString arguments:args 
    "Format and print the receiver with <args> formatted in C style, 
     as described in the UTek manual page for printf(3)."
    
    |aStream|

    aStream := WriteStream on:(aString species new:100).
    self 
        printf:aString
        on:aStream
        arguments:args.
    ^ aStream contents

    "
     self new printf:'%d %x' arguments:#(1234 45054) 
    "
!

printf:aFormatString on:outStream arguments: args
    "Format and print aFormatString on <outStream> with <args>
     formatted in C style, as described in the UTek manual page for
     printf(3).  This method is designed for producing output
     suitable for a machine."     

    | argStream inStream char |

    argStream := ReadStream on: args.
    inStream := ReadStream on: aFormatString.
    [inStream atEnd] whileFalse:[
        (char := inStream next) == $% ifFalse: [
            outStream nextPut: char
        ] ifTrue: [
            self printArgFrom:inStream to:outStream arguments:argStream
        ]
    ]
! !

!PrintfScanf methodsFor:'scanning'!

scanArgFrom:dataStream to:collection format:format 
    "Add to <collection> an object who's representation is found
     in <dataStream> interpreted according to the conversion
     control string in the Stream <format>.  <format> is assumed to
     be positioned just past a $%, and a complete control string is
     assumed available.    

     Return when the conversion control string is consumed.  Leave
     <format> pointing past the last character in the conversion
     control string, leave <dataStream> pointing past any width
     specified in <format>, or at the first character that doesn't
     make sense for the <format>."
    
    |final width char pos data scanset exclusive return last|

    final := [:retval | 
            collection add:retval.
            data == dataStream ifFalse:[
                dataStream position:dataStream position + data position
            ].
            ^ self
        ].

    char := format peek.
    char == $% ifTrue:[
        ^ dataStream peekFor:char
    ].
    char == $* ifTrue:[
        format next.
        char := format peek.
        final := [:retval | 
                data == dataStream ifFalse:[
                    dataStream position:dataStream position + data position
                ].
                ^ self
            ]
    ].
    width := 0.
    char isDigit ifTrue:[
        width := Integer readFrom:format.
        char := format peek
    ].
    ('slhduoxfeg' includes:char) ifTrue:[
        dataStream skipSeparators
    ].
    width = 0 ifTrue:[
        data := dataStream
    ] ifFalse:[
        pos := dataStream position.
        data := ReadStream on:(dataStream next:width).
        dataStream position:pos
    ].
    char == $s ifTrue:[
        final value:(data upToSeparator)
    ].
    char == $c ifTrue:[
        width = 0 ifTrue:[
            final value:(String with:data next)
        ] ifFalse:[
            final value:data contents
        ]
    ].
    char == $[ ifTrue:[
        "What a mess!!!!" 
        return := CharacterWriteStream on:(String new:8).
        scanset := IdentitySet new.
        format next.
        width = 0 ifTrue:[
            width := SmallInteger maxVal
        ].
        exclusive := format peekFor:$^.
        [
            last := char.
            char := format next.
            char == $]
        ] whileFalse:[
            char == $- ifFalse:[
                scanset add:char
            ] ifTrue:[
                last to:format next do:[:c | 
                    scanset add:c
                ]
            ]
        ].
        [
            data atEnd not and:[ (scanset includes:data peek) xor:exclusive ]
        ] whileTrue:[ return nextPut:data next ].
        final value:return contents
    ].
    ('lh' includes:char) ifTrue:[
        format next.
        char := format peek
    ].
    ('DUdu' includes:char) ifTrue:[
        final value:(Integer readFrom:data)
    ].
    ('FEGfeg' includes:char) ifTrue:[
        final value:(Float readFrom:data)
    ].
    ('Oo' includes:char) ifTrue:[
        final value:(Integer readFrom:data radix:8)
    ].
    ('Xx' includes:char) ifTrue:[
        final value:(Integer readFrom:data radix:16)
    ].
    ('Bb' includes:char) ifTrue:[
        final value:(Integer readFrom:data radix:2)
    ].

    "Modified: / 29-11-2011 / 11:55:32 / cg"
!

scanf:formatString fromStream:dataStream 
    "Return a Collection of objects found in the Character Stream
     <dataStream> as interpreted according to the receiver.  The
     receiver is assumed to be a conversion control string as
     specified in the UTek manual page for scanf(3)."
    
    |results format char|

    results := OrderedCollection new.
    format := ReadStream on:formatString.
    [ format atEnd ] whileFalse:[
        char := format next.
        (char == Character space or:[ char == Character tab ]) ifTrue:[
            dataStream skipSeparators.
            format skipSeparators
        ].
        char == $% ifTrue:[
            self 
                scanArgFrom:dataStream
                to:results
                format:format
        ] ifFalse:[
            dataStream peekFor:char
        ]
    ].
    ^ results
!

sscanf:formatString fromString:aString 
    "Return a Collection of objects found in <string> as
     interpreted according to the receiver.  The receiver is
     assumed to be a conversion control string as specified in the
     UTek manual page for scanf(3)."
    
    ^ self scanf:formatString fromStream:(ReadStream on:aString)

    "
     self new sscanf:'%d %x' fromString:'1234 affe'
    "
! !

!PrintfScanf class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

