"{ Package: 'stx:libbasic2' }"!

!CharacterArray methodsFor:'matching - phonetic'!

asKoelnerPhoneticCode
    "return a koelner phonetic code.
     The koelnerPhonetic code is for the german language what the soundex code is for english;
     it returns simular strings for similar sounding words.
     There are some differences to soundex, though:
	its length is not limited to 4, but depends on the length of the original string;
	it does not start with the first character of the input.

     Caveat: this phonetic code is especially suited for german words.
	     Please have a look at the other phonetic comparison operators found
	     in PhoneticStringUtilities."

    ^ PhoneticStringUtilities koelnerPhoneticCodeOf:self

    "
     #(
	'Müller'
	'Miller'
	'Mueller'
	'Mühler'
	'Mühlherr'
	'Mülherr'
	'Myler'
	'Millar'
	'Myller'
	'Müllar'
	'Müler'
	'Muehler'
	'Mülller'
	'Müllerr'
	'Muehlherr'
	'Muellar'
	'Mueler'
	'Mülleer'
	'Mueller'
	'Nüller'
	'Nyller'
	'Niler'
	'Czerny'
	'Tscherny'
	'Czernie'
	'Tschernie'
	'Schernie'
	'Scherny'
	'Scherno'
	'Czerne'
	'Zerny'
	'Tzernie'
	'Breschnew'
     ) do:[:w |
	 Transcript show:w; show:'->'; showCR:(w asKoelnerPhoneticCode)
     ].
    "

    "
     'Breschnew' asKoelnerPhoneticCode -> '17863'
     'Breschnew' asKoelnerPhoneticCode -> '17863'
     'Breschneff' asKoelnerPhoneticCode -> '17863'
     'Braeschneff' asKoelnerPhoneticCode -> '17863'
     'Braessneff' asKoelnerPhoneticCode -> '17863'
     'Pressneff' asKoelnerPhoneticCode -> '17863'
     'Presznäph' asKoelnerPhoneticCode -> '17863'
    "
! !

!CharacterArray methodsFor:'matching - phonetic'!

asSoundexCode
    "return a soundex phonetic code or nil.
     Soundex returns similar codes for similar sounding words, making it a useful
     tool when searching for words where the correct spelling is unknown.
     (read Knuth or search the web if you don't know what a soundex code is).

     Caveat: 'similar sounding words' means: 'similar sounding in ENGLISH'
             Please have a look at the other phonetic comparison operators found
             in PhoneticStringUtilities."

    ^ PhoneticStringUtilities soundexCodeOf:self

    "
     'claus' asSoundexCode
     'clause' asSoundexCode
     'close' asSoundexCode
     'smalltalk' asSoundexCode
     'smaltalk' asSoundexCode
     'smaltak' asSoundexCode
     'smaltok' asSoundexCode
     'smoltok' asSoundexCode
     'aa' asSoundexCode
     'by' asSoundexCode
     'bab' asSoundexCode
     'bob' asSoundexCode
     'bop' asSoundexCode
    "
! !

!CharacterArray methodsFor:'printing & storing'!

printf:args
    "Format and print the receiver with <args> formatted in C style,
     as specified in the Unix C-language manual page for printf(3).
     Return the resulting string (i.e actually, this is more like an sprintf).

     For copyright information, see goodies/String-printf_scanf.chg"

    |aStream|

    aStream := CharacterWriteStream on:(self species uninitializedNew:self size).
    self printf:args on:aStream.
    ^ aStream contents

    "
     ('%05x %d %f %o' printf:{ 123. 234*5. 1.234. 8r377 } )    
     Transcript showCR:('%05x %d %f %o' printf:{ 123. 234*5. 1.234. 8r377 } )
    "

    "
     Transcript showCR: 'Some examples:'!!

     Transcript show:'''%#x %#X %03o%*.*s'' printf: #(16rABCD 16rEF 5 9 5 ''ghijklmn'') = .'.
     Transcript show: ('%#x %#X %03o%*.*s' printf: #(16rABCD 16rEF 5 9 5 'ghijklmn')).
     Transcript showCR: '.'

     Transcript show: '''%- 10.4s%.2e'' printf: (Array with: ''abcdefghijkl'' with: Float pi) = .'.
     Transcript show: ('%- 10.4s%.2e' printf: (Array with: 'abcdefghijkl' with: Float pi)).
     Transcript showCR: '.'

     Transcript show: '''%8.3f'' printf: (Array with: 200 sqrt negated) = .'.
     Transcript show: ('%8.3f' printf: (Array with: 200 sqrt negated)).
     Transcript showCR: '.'

     Transcript show: '''%c'' printf: #(16r41) = .'.
     Transcript show: ('%c' printf: #(16r41)).
     Transcript showCR: '.'

     Transcript show: '''%f%2s%s%s%s'' sscanf: ''237.0 this is a test'' = '.
     Transcript showCR: ('%f%2s%s%s%s'  sscanf: '237.0 this is a test') printString.

     Transcript show: '''%d%f%s'' sscanf: ''25 54.32e-01 monday'' = '.
     Transcript showCR: ('%d%f%s' sscanf: '25 54.32e-01 monday') printString.

     Transcript show: '''%f%*f %8[A-F0-9]%c%d 0x%x%f'' sscanf: ''12.45 1048.73 AE40Z527 0x75BCD15 34'' = '.
     Transcript showCR: ('%f%*f %8[A-F0-9]%c%d 0x%x%f' sscanf: '12.45 1048.73 AE40Z527 0x75BCD15 34') printString.
    "
! !

!CharacterArray methodsFor:'printing & storing'!

printf:args on:outStream
    "Format and print the receiver on <outStream> with <args>
     formatted in C style, as specified in the Unix C-language manual page for printf(3).

     For copyright information, see goodies/String-printf_scanf.chg"

    |argStream inStream char escChar|

    argStream := ReadStream on:args.
    inStream := ReadStream on:self.
    [ inStream atEnd ] whileFalse:[
        (char := inStream next) == $% ifFalse:[
            char == $\ ifTrue:[
                escChar := inStream next.
                escChar == $n ifTrue:[ char := Character nl ]
                ifFalse:[ escChar == $t ifTrue:[ char := Character tab ]
                ifFalse:[ escChar == $r ifTrue:[ char := Character return ]
                ifFalse:[ char := escChar ]]]
            ].        
            outStream nextPut:char
        ] ifTrue:[
            self
                printf_printArgFrom:inStream
                to:outStream
                withData:argStream
        ]
    ]
! !

!CharacterArray methodsFor:'printing & storing'!

printfWith:arg1
    "Format and print the receiver with <arg1> formatted in C style,
     as specified in the Unix C-language manual page for printf(3).
     Return the resulting string (i.e actually, this is more like an sprintf)."

    ^ self printf:(Array with:arg1)

    "
     ('%05x' printfWith:123)
     Transcript showCR:('%05x' printfWith:123)
    "
! !

!CharacterArray methodsFor:'printing & storing'!

printfWith:arg1 with:arg2
    "Format and print the receiver with <argI> formatted in C style,
     as specified in the Unix C-language manual page for printf(3).
     Return the resulting string (i.e actually, this is more like an sprintf)."

    ^ self printf:(Array with:arg1 with:arg2)

    "
     Transcript showCR:('%d %05x' printfWith:123 with:234)
    "
! !

!CharacterArray methodsFor:'printing & storing'!

printfWith:arg1 with:arg2 with:arg3
    "Format and print the receiver with <argI> formatted in C style,
     as specified in the Unix C-language manual page for printf(3).
     Return the resulting string (i.e actually, this is more like an sprintf)."

    ^ self printf:(Array with:arg1 with:arg2 with:arg3)

    "
     Transcript showCR:('%d %05x %08o' printfWith:123 with:234 with:345)
    "
! !

!CharacterArray methodsFor:'printing & storing'!

printfWith:arg1 with:arg2 with:arg3 with:arg4
    "Format and print the receiver with <argI> formatted in C style,
     as specified in the Unix C-language manual page for printf(3).
     Return the resulting string (i.e actually, this is more like an sprintf)."

    ^ self printf:(Array with:arg1 with:arg2 with:arg3 with:arg4)

    "
     Transcript showCR:('%d %05x %08o %b' printfWith:123 with:234 with:345 with:123)
    "
! !

!CharacterArray methodsFor:'printing & storing'!

printf_formatArgCount
    "Return the number of arguments required/produced if the receiver is interpreted
     as a printf/scanf format control string.
     For copyright information, see goodies/String-printf_scanf.chg"

    |nonConsecutive count|

    nonConsecutive := true.
    count := 0.
    self do:[:c |
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

!CharacterArray methodsFor:'private'!

printf_printArgFrom:inStream to:outStream withData:argStream
    "Interpret the required number of arguments from <argStream>
     according to the formatting information in <inStream>.
     Place the interpretation on <outStream>.
     The interpretation is C printf(3) style, as
     specified in the Unix C-language manual page for printf(3).
     <inStream> is assumed to be positioned just past
     $%, and a complete control string is assumed available.

     Return when the conversion control string is consumed.
     Leave <inStream> pointing past the last character in the conversion control string.

     This code assumes that <inStream> is formatted according to
     specification, and error checking is minimal.  Unexpected
     results will be obtained by illegal control strings, or when
     argument types do not match conversion codes, but it probably
     won't dump core, like C does in such cases!!

     For copyright information, see goodies/String-printf_scanf.chg"

    |nextArg ljust plus pound width precision pad char arg argString|

    nextArg := [
                    argStream atEnd ifTrue:[
                        self error:'not enough arguments for format string'
                    ].
                    argStream next
               ].

    ljust := plus := pound := false.
    width := 0.
    precision := SmallInteger maxVal.
    pad := $ .
    char := inStream peek.
    char == $% ifTrue:[
        ^ outStream nextPut:inStream next
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
        width := nextArg value.
        inStream next.
        char := inStream peek
    ].
    char isDigit ifTrue:[
        char == $0 ifTrue:[
            pad := $0
        ].
        width := Integer readFrom:inStream.
        char := inStream peek
    ].
    char == $. ifTrue:[
        inStream next.
        char := inStream peek.
        char == $* ifTrue:[
            precision := nextArg value.
            inStream next.
        ] ifFalse:[
            precision := Integer readFrom:inStream.
        ].
        char := inStream peek
    ].
    char == $l "Ignore long specifier." ifTrue:[
        inStream next.
        char := inStream peek
    ].
    ('feg' includes:char) ifTrue:[
        arg := nextArg value asFloat.
        precision := precision min:6.
        argString := WriteStream on:''.
        char == $g ifTrue:[
            arg absPrintOn:argString digits:precision + 1
        ].
        char == $f ifTrue:[
            arg absDecimalPrintOn:argString digits:precision + arg abs log + 1
        ].
        char == $e ifTrue:[
            arg absScientificPrintOn:argString digits:precision + 1
        ].
        argString := argString contents.
        arg < 0 ifTrue:[
            argString := '-' , argString
        ] ifFalse:[
            plus ifTrue:[
                argString := '+' , argString
            ]
        ].
        (precision = 0 and:[ pound not ]) ifTrue:[
            (argString includes:$e) ifTrue:[
                "self halt"
            ] ifFalse:[
                argString := arg truncated printString
            ]
        ].
        pound ifTrue:[
            (argString includes:$e) ifTrue:[
                "self halt"
            ] ifFalse:[
                precision - (argString size - (argString indexOf:$.)) timesRepeat:[
                    argString := argString , '0'
                ]
            ]
        ].
        ljust ifTrue:[
            outStream nextPutAll:argString
        ].
        width - argString size timesRepeat:[
            outStream space
        ].
        ljust ifFalse:[
            outStream nextPutAll:argString
        ].
        ^ inStream next
    ].
    char == $c ifTrue:[
        arg := String with:nextArg value asCharacter
    ].
    char == $s ifTrue:[
        "Assume the arg is a String or Symbol. (if not, its printString is used)" 
        arg := nextArg value asString
    ].
    char == $d ifTrue:[
        arg := nextArg value asInteger printString.
        plus ifTrue:[
            arg := '+' , arg
        ]
    ].
    char == $u ifTrue:[
        arg := nextArg value asInteger abs printString
    ].
    char == $o ifTrue:[
        arg := nextArg value asInteger abs printStringRadix:8.
        pound ifTrue:[
            arg := '0' , arg
        ]
    ].
    char == $b ifTrue:[
        arg := nextArg value asInteger abs printStringRadix:2.
        pound ifTrue:[
            arg := '0' , arg
        ]
    ].
    ('xX' includes:char) ifTrue:[
        arg := nextArg value asInteger abs printStringRadix:16.
        pound ifTrue:[
            arg := '0x' , arg
        ]
    ].
    char == $x ifTrue:[
        1 to:arg size do:[:i |
            ('ABCDEF' includes:(arg at:i)) ifTrue:[
                arg at:i put:(arg at:i) asLowercase
            ]
        ]
    ].
    precision := precision min:arg size.
    ljust ifTrue:[
        outStream nextPutAll:(arg copyFrom:1 to:precision)
    ].
    width - precision timesRepeat:[
        outStream nextPut:pad
    ].
    ljust ifFalse:[
        outStream nextPutAll:(arg copyFrom:1 to:precision)
    ].
    ^ inStream next

    "Modified: / 24-07-2011 / 07:16:42 / cg"
! !

!CharacterArray methodsFor:'printing & storing'!

printf_printOn:outStream withData:args
    <resource: #obsolete>

    "Format and print the receiver on <outStream> with <args>
     formatted in C style, as specified in the Unix C-language manual page for printf(3).

     For copyright information, see goodies/String-printf_scanf.chg"

    self obsoleteMethodWarning:'use printf:on:'.
    self printf:args on:outStream
! !

!CharacterArray methodsFor:'converting'!

scanf:dataStream
    "Return a Collection of objects found in the Character Stream
     <dataStream> as interpreted according to the receiver.
     The receiver is assumed to be a conversion control string as
     specified in the Unix C-language manual page for scanf(3).
     For copyright information, see goodies/String-printf_scanf.chg"

    |results format char|

    results := OrderedCollection new.
    format := ReadStream on:self.
    [ format atEnd ] whileFalse:[
	char := format next.
	(char == Character space or:[ char == Character tab ]) ifTrue:[
	    dataStream skipSeparators.
	    format skipSeparators
	].
	char == $% ifTrue:[
	    self
		scanf_scanArgFrom:dataStream
		to:results
		format:format
	] ifFalse:[
	    dataStream peekFor:char
	]
    ].
    ^ results

    "
     '%d %x' scanf:(ReadStream on:'1234 ff00')
    "
! !

!CharacterArray methodsFor:'private'!

scanf_scanArgFrom:dataStream to:collection format:format
    "Add to <collection> an object who's representation is found
     in <dataStream> interpreted according to the conversion
     control string in the Stream <format>.
     <format> is assumed to be positioned just past a $%, and a complete control
     string is assumed available.

     Return when the conversion control string is consumed.  Leave
     <format> pointing past the last character in the conversion
     control string, leave <dataStream> pointing past any width
     specified in <format>, or at the first character that doesn't
     make sense for the <format>.

     For copyright information, see goodies/String-printf_scanf.chg"

    |final width char pos data scanset exclusive return last|

    final := [:retval |
            collection add:retval.
            data == dataStream ifFalse:[
                dataStream position:dataStream position + data position
            ].
            ^ self
        ].
    width := 0.
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
    char == $[ "What a mess!!" ifTrue:[
        return := WriteStream on:(String new:8).
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
    ('b' includes:char) ifTrue:[
        final value:(Integer readFrom:data radix:2)
    ].
    ('Oo' includes:char) ifTrue:[
        final value:(Integer readFrom:data radix:8)
    ].
    ('Xx' includes:char) ifTrue:[
        final value:(Integer readFrom:data radix:16)
    ]

    "
     '%d %x' sscanf:'1234 ff00'
     '%d %x %b' sscanf:'1234 ff00 1001'
    "

    "Modified: / 29-11-2011 / 11:55:39 / cg"
! !

!CharacterArray methodsFor:'converting'!

sscanf:string
    "Return a Collection of objects found in <string> as
     interpreted according to the receiver.
     The receiver is assumed to be a conversion control string as
     specified in the Unix C-language manual page for scanf(3).
     For copyright information, see goodies/String-printf_scanf.chg"

    ^ self scanf:(ReadStream on:string)

    "
     '%d %x' sscanf:'1234 ff00'
     '%d %x %b' sscanf:'1234 ff00 1001'
    "
! !

!Float methodsFor:'private'!

absDecimalPrintOn:aStream digits:digits
    "Place a string representation of the receiver's abs value
     on <aStream> using <digits> significant digits, using decimal notation.
     This is a helper for printf."

    |exp x fuzz i|

    "x is myself normalized to (1.0, 10.0), exp is my exponent"
    exp := self abs < 1.0
		ifTrue:[ (10.0 / self abs) log floor negated ]
		ifFalse:[ self abs log floor ].
    x := self abs / (10.0 raisedTo:exp).
    fuzz := 10.0 raisedTo:1 - digits.
     "round the last digit to be printed"
    x := 0.5 * fuzz + x.
    x >= 10.0 "check if rounding has unnormalized x" ifTrue:[
	x := x / 10.0.
	exp := exp + 1
    ].
    exp < 0 ifTrue:[
	1 to:1 - exp do:[:j |
	    aStream nextPut:('0.000000000000' at:j)
	]
    ].
    [ x >= fuzz ] "use fuzz to track significance" whileTrue:[
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
! !

!Float methodsFor:'private'!

absPrintOn:aStream digits:digits
    "Place a string representation of the receiver's abs value on <aStream> using
     <digits> significant digits.
     This is a helper for printf."

    (self < 1.0e6 and:[ self > 1.0e-4 ]) ifTrue:[
	self absDecimalPrintOn:aStream digits:digits
    ] ifFalse:[
	self absScientificPrintOn:aStream digits:digits
    ]
! !

!Float methodsFor:'private'!

absScientificPrintOn:aStream digits:digits
    "Place a string representation of the receiver's abs value on <aStream> using <digits> significant
     digits, using scientific notation.
     This is a helper for printf."

    |exp fuzz x q i|

    "x is myself normalized to [1.0, 10.0), exp is my exponent"
    exp := self abs < 1.0
	    ifTrue:[ (10.0 / self abs) log floor negated ]
	    ifFalse:[ self abs log floor ].
    x := self abs / (10.0 raisedTo:exp).
    fuzz := 10.0 raisedTo:1 - digits.
     "round the last digit to be printed"
    x := 0.5 * fuzz + x.
    x >= 10.0 "check if rounding has unnormalized x" ifTrue:[
	x := x / 10.0.
	exp := exp + 1
    ].
    q := exp.
    exp := 0.
    [ x >= fuzz ] "use fuzz to track significance" whileTrue:[
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
! !

!Object methodsFor:'dependents-interests'!

addInterest:anInterest
    "install an interest forwarder.
     Here, we use the nonWeakDependencies."

    self addNonWeakDependent:anInterest

    "Created: 14.10.1996 / 22:27:34 / stefan"
! !

!Object methodsFor:'converting'!

asDoubleLink
    "return a valueDoubleLink for the receiver.
     Used to make sure the receiver can be added to a double linked list"

    ^ ValueDoubleLink value:self
! !

!Object methodsFor:'dependents-interests'!

expressInterestIn:aspect for:anObject sendBack:aSelector
    "arrange for aSelector to be sent to anObject whenever the receiver
     changes aspect."

    "/ for now, use an interestConverter, which is somewhat less efficient.
    "/ In the future, a more intelligent DependencyCollection class is planned for

    self addInterest:(InterestConverter
			    destination:anObject
			    selector:aSelector
			    aspect:aspect)

    "
     |p b|

     b := [Transcript showCR:' -> the point changed'].

     p := Point new.
     Transcript showCR:'interest in #foo:'.
     p expressInterestIn:#foo for:b sendBack:#value.
     p x:1.
     Transcript showCR:'now changing #bar ... (expect no notification)'.
     p changed:#bar.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'now changing #foo ... (expect notification)'.
     p changed:#foo.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'no more interest in #foo:'.
     p retractInterestIn:#foo for:b.
     Transcript showCR:'now changing #foo ... (expect no notification)'.
     p changed:#foo.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'interest in #bar now:'.
     p expressInterestIn:#bar for:b sendBack:#value.
     Transcript showCR:'now changing #foo ... (expect no notification)'.
     p changed:#foo.
     Transcript showCR:'now changing #bar ... (expect notification)'.
     p changed:#bar.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'interest in #foo now:'.
     p expressInterestIn:#foo for:b sendBack:#value.
     Transcript showCR:'now changing #foo ... (expect notification)'.
     p changed:#foo.
     Transcript showCR:'now changing #bar ... (expect notification)'.
     p changed:#bar.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'no more interests:'.
     p retractInterestsFor:b.
     Transcript showCR:'now changing #foo ... (expect no notification)'.
     p changed:#foo.
     Transcript showCR:'now changing #bar...  (expect no notification)'.
     p changed:#bar.
     Transcript cr.

     p release.
    "

    "Created: 19.4.1996 / 10:26:22 / cg"
    "Modified: 19.4.1996 / 12:34:08 / cg"
    "Modified: 14.10.1996 / 22:28:20 / stefan"
! !

!Object methodsFor:'dependents-interests'!

interests
    "return a Collection of interests - empty if there is none.
     Here, we use the nonWeakDependents for interests."

    ^ self nonWeakDependents

    "Created: / 14.10.1996 / 22:20:51 / stefan"
    "Modified: / 30.1.1998 / 14:07:35 / cg"
! !

!Object methodsFor:'dependents-interests'!

interestsFor:someOne
    "return a collection of interests of someOne - empty if there is none."

    |coll deps|

    deps := self interests.
    deps size == 0 ifTrue:[^ #()].

    coll := IdentitySet new.

    deps do:[:dep |
	(dep isInterestConverter) ifTrue:[
	    dep destination == someOne ifTrue:[
		coll add:dep.
	    ]
	]
    ].
    ^ coll

    "Created: / 30.1.1998 / 14:02:26 / cg"
    "Modified: / 30.1.1998 / 14:08:24 / cg"
! !

!Object methodsFor:'dependents-interests'!

onChangeEvaluate:aBlock
    "arrange for aBlock to be evaluated whenever the receiver changes."

    |na selector|

    na := aBlock argumentCount.
    na == 0 ifTrue:[
        selector := #value
    ] ifFalse:[
        selector := #( #'value:' #'value:value:' #'value:value:value:') at:na
    ].
    ^ self onChangeSend:selector to:aBlock

    "
     |p b|

     b := [Transcript showCR:' -> the point changed'].

     p := Point new.
     Transcript showCR:'interest in #foo:'.
     p onChangeEvaluate:b.
     p x:1.
     Transcript showCR:'now changing #bar ... (expect no notification)'.
     p changed:#bar.

     p retractInterests.
     p changed:#bar.
    "
! !

!Object methodsFor:'dependents-interests'!

onChangeSend:aSelector to:anObject
    "arrange for aSelector to be sent to anObject whenever the receiver
     changes.
     Use retractInterestsFor: in case you are no longer interested"

    "/ for now, use an interestConverter, which is somewhat less efficient.
    "/ In the future, a more intelligent DependencyCollection class is planned for

    ((self interests ? #())
        contains:[:anInterest |
            (anInterest isInterestConverter)
            and:[ anInterest destination == anObject
            and:[ anInterest selector == aSelector]]
        ])
            ifTrue:[^ self].

    self addInterest:(InterestConverter
                          destination:anObject
                          selector:aSelector)

    "
     |p b|

     b := [Transcript showCR:'the point changed'].

     p := Point new.
     p onChangeSend:#value to:b.
     p x:1.
     Transcript showCR:'now changing'.
     p changed.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'now changing'.
     p changed.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'no more interest'.
     p retractInterestsFor:b.
     Transcript showCR:'now changing again'.
     p changed.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'interest again'.
     p onChangeSend:#value to:b.
     Transcript showCR:'now changing again'.
     p changed.
     Transcript cr.
    "

    "Created: 19.4.1996 / 10:26:38 / cg"
    "Modified: 19.4.1996 / 12:34:26 / cg"
    "Modified: 14.10.1996 / 22:28:27 / stefan"
! !

!Object methodsFor:'dependents-st/v event simulation'!

removeActionsForEvent:eventSymbol
    "remove ST/V-style event triggers."

    self retractInterestsIn:eventSymbol
! !

!Object methodsFor:'dependents-st/v event simulation'!

removeActionsWithReceiver:aReceiver
    "remove ST/V-style event triggers."

    self retractInterestsFor:aReceiver
! !

!Object methodsFor:'dependents-st/v event simulation'!

removeAllActionsWithReceiver:anObject
    "remove ST/V-style event triggers."

    self retractInterestsFor:anObject
! !

!Object methodsFor:'dependents-interests'!

removeInterest:anInterest
    "remove an interest forwarder.
     Here, we use the nonWeakDependencies."

    self removeNonWeakDependent:anInterest

    "Created: 14.10.1996 / 22:21:59 / stefan"
! !

!Object methodsFor:'dependents-interests'!

retractInterestIn:aspect for:someOne
    "remove the interest of someOne in the receiver changing aspect
     (as installed with #expressInterestIn:for:sendBack:).
     Answer the retracted interests."

    "/ for now, remove the interestConverter.
    "/ In the future, a more intelligent DependencyCollection class is planned for

    ^ self retractInterestsForWhich:[:i | 
            (i aspect == aspect) and:[i destination == someOne]
        ]

    "
     |p b|

     b := [Transcript showCR:'the point changed'].

     p := Point new.
     Transcript showCR:'interest in #foo'.
     p expressInterestIn:#foo for:b sendBack:#value.
     p x:1.
     Transcript showCR:'now changing #bar'.
     p changed:#bar.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'now changing #foo'.
     p changed:#foo.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'no more interest in #foo'.
     p retractInterestIn:#foo for:b.
     Transcript showCR:'now changing #foo'.
     p changed:#foo.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'interest in #bar now'.
     p expressInterestIn:#bar for:b sendBack:#value.
     Transcript showCR:'now changing #foo'.
     p changed:#foo.
     Transcript showCR:'now changing #bar'.
     p changed:#bar.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'interest in #foo now'.
     p expressInterestIn:#foo for:b sendBack:#value.
     Transcript showCR:'now changing #foo'.
     p changed:#foo.
     Transcript showCR:'now changing #bar'.
     p changed:#bar.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'no more interests'.
     p retractInterestsFor:b.
     Transcript showCR:'now changing #foo'.
     p changed:#foo.
     Transcript showCR:'now changing #bar'.
     p changed:#bar.
     Transcript cr.
    "

    "Created: / 19.4.1996 / 10:27:11 / cg"
    "Modified: / 14.10.1996 / 22:21:19 / stefan"
    "Modified: / 30.1.1998 / 14:05:34 / cg"
! !

!Object methodsFor:'dependents-interests'!

retractInterests
    "remove all interests in the receiver changing aspect
     (as installed with #expressInterestIn:for:sendBack:).
     Answer the retraced interests."

    "/ for now, remove the interestConverter.
    "/ In the future, a more intelligent DependencyCollection class is planned for

    ^ self retractInterestsForWhich:[:i | true ]
! !

!Object methodsFor:'dependents-interests'!

retractInterestsFor:someOne
    "remove the interest of someOne in the receiver
     (as installed with #onChangeSend:to:).
     Answer the retracted interests."

    "/ for now, remove the interestConverter.
    "/ In the future, a more intelligent DependencyCollection class is planned for

    ^ self retractInterestsForWhich:[:i | i destination == someOne ]

    "
     |p b|

     b := [Transcript showCR:'the point changed'].

     p := Point new.
     p onChangeSend:#value to:b.
     p x:1.
     Transcript showCR:'now changing'.
     p changed.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'now changing'.
     p changed.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'no more interest'.
     p retractInterestsFor:b.
     Transcript showCR:'now changing again'.
     p changed.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'interest again'.
     p onChangeSend:#value to:b.
     Transcript showCR:'now changing again'.
     p changed.
     Transcript cr.
    "

    "Created: / 19.4.1996 / 10:23:46 / cg"
    "Modified: / 14.10.1996 / 22:21:25 / stefan"
    "Modified: / 30.1.1998 / 14:04:52 / cg"
! !

!Object methodsFor:'dependents-interests'!

retractInterestsForWhich:aBlock
    "remove all interests in the receiver changing aspect
     (as installed with #expressInterestIn:for:sendBack:).
     Answer the retracted interests."

    "/ for now, remove the interestConverter.
    "/ In the future, a more intelligent DependencyCollection class is planned for

    |deps coll|

    deps := self interests.
    deps size ~~ 0 ifTrue:[
        "/ cannot removeDependent within the loop - the interests collection rehashes
        coll := IdentitySet new.
        deps do:[:dep |
            dep isInterestConverter ifTrue:[
                (aBlock value:dep) ifTrue:[coll add:dep].
            ]
        ].
        coll do:[:dep |
            self removeInterest:dep.
        ].
        ^ coll.
    ].
    ^ #()
! !

!Object methodsFor:'dependents-interests'!

retractInterestsIn:aspect
    "remove all interests in the receiver changing aspect
     (as installed with #expressInterestIn:for:sendBack:).
     Answer the retracted interests."

    "/ for now, remove the interestConverter.
    "/ In the future, a more intelligent DependencyCollection class is planned for

    ^ self retractInterestsForWhich:[:i | i aspect == aspect ]
! !

!Object methodsFor:'Compatibility-Dolphin'!

trigger:anAspect
    self changed:anAspect
! !

!Object methodsFor:'Compatibility-Dolphin'!

trigger:anAspect with:anArgument
    self changed:anAspect with:anArgument
! !

!Object methodsFor:'dependents-st/v event simulation'!

triggerEvent:aSymbol
    self changed:aSymbol
! !

!Object methodsFor:'dependents-st/v event simulation'!

triggerEvent:eventSymbol with:aParameter
    "perform ST/V-style event triggering."

    self changed:eventSymbol with:(Array with:aParameter).
! !

!Object methodsFor:'dependents-st/v event simulation'!

triggerEvent:eventSymbol withArguments:parameters
    "perform ST/V-style event triggering."

    self changed:eventSymbol with:parameters.
! !

!Object methodsFor:'dependents-st/v event simulation'!

when:eventSymbol send:selector to:anObject
    "install an ST/V-style interest forwarder.
     Here, we use the nonWeakDependencies."

    self addInterest:(InterestConverterWithParameters
                            destination:anObject
                            selector:selector
                            aspect:eventSymbol).

    "
     |p b|

     b := [Transcript showCR:'the point changed'].

     p := Point new.
     p when:#foo:bar: send:#value:value: to:[:a :b | Transcript show:'foo: '; show:a; show:' bar: '; showCR:b].
     Transcript showCR:'now changing'.
     p triggerEvent:#foo:bar: withArguments:#('fooArg' 'barArg').
     p removeActionsForEvent:#foo:bar:.
    "
! !

!Object methodsFor:'dependents-st/v event simulation'!

when:eventSymbol send:selector to:anObject with:aParameter
    "install an ST/V-style interest forwarder.
     Here, we use the nonWeakDependencies."

    self addInterest:((InterestConverterWithParameters
                            destination:anObject
                            selector:selector
                            aspect:eventSymbol) 
                        defaultParameters:(Array with:aParameter)).

    "
     |p b|

     b := [Transcript showCR:'the point changed'].

     p := Point new.
     p 
        when:#foo: 
        send:#value: 
        to:[:a | Transcript show:'foo: '; showCR:a]
        with:123.
     Transcript showCR:'now changing'.
     p triggerEvent:#foo:.
     p triggerEvent:#foo: with:987.
     p removeActionsForEvent:#foo:.
    "
! !

!Object methodsFor:'Compatibility-Dolphin'!

when:anAspect sendTo:anObject
    self expressInterestIn:anAspect for:anObject sendBack:anAspect
! !

!Stream methodsFor:'stacked computing streams'!

collecting:aBlock
    "return a stacked computing stream, which reads elements from the receiver,
     applies aBlock to each read element, and provides the results as elements to its reader."

    ^ CollectingReadStream on:self collecting:aBlock

    "
     |s s2|

     s := 'hello world' readStream.
     s2 := s collecting:[:ch | ch asUppercase].
     s2 upToEnd.   
    "
! !

!Stream methodsFor:'stacked computing streams'!

selecting:aBlock
    "return a stacked computing stream, which reads elements from the receiver,
     but only provides elements for which aBlock returns true to its reader."

    ^ SelectingReadStream on:self selecting:aBlock

    "
     |s s2|

     s := 'hello world' readStream.
     s2 := s selecting:[:ch | ch isVowel].
     s2 upToEnd.
    "
! !

!stx_libbasic2 class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header$'
! !

