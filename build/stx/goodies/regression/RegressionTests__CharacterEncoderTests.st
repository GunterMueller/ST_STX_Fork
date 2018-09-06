"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#CharacterEncoderTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!

!CharacterEncoderTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	Claus Gittinger (cg@alan)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 11.2.2004 / 12:25:54 / cg"
! !

!CharacterEncoderTests methodsFor:'helpers'!

xTestReversability:encoderClass
    self xTestReversability:encoderClass skip:#()

    "
     self new xTestReversability: (CharacterEncoder::ISO8859_1)
    "
!

xTestReversability:encoderClass ignoreInvalid:ignoreInvalid
    self xTestReversability:encoderClass skip:#() ignoreInvalid:ignoreInvalid

    "
     self new xTestReversability: (CharacterEncoder::ISO8859_1)
    "
!

xTestReversability:encoderClass range:range skip:skippedCodes
    self
	xTestReversability:encoderClass
	range:range
	skip:skippedCodes
	ignoreInvalid:false

    "
     self new xTestReversability: (CharacterEncoder::ISO8859_1)
    "
!

xTestReversability:encoderClass range:range skip:skippedCodes ignoreInvalid:ignoreInvalid
    |encoder|

    encoder := encoderClass new.
    range do:[:code |
	|unicode code2 invalid|

	(skippedCodes includes:code) ifTrue:[
	    self should:[ encoder decode:code ] raise:CharacterEncoderError.
	] ifFalse:[
	    ignoreInvalid ifTrue:[
		invalid := false.
		CharacterEncoderError handle:[:ex |
		    invalid := true.
		] do:[
		    unicode := encoder decode:code.
		].
		invalid ifFalse:[
		    code2 := encoder encode:unicode.
		    self assert:(code == code2).
		].
	    ] ifFalse:[
		unicode := encoder decode:code.
		code2 := encoder encode:unicode.
		self assert:(code == code2).
	    ]
	]
    ].

    "
     self new xTestReversability: (CharacterEncoder::ISO8859_1)

     self new
	xTestReversability:(CharacterEncoder::JIS0208)
	range:(16r8140 to:16rEAA4)
	skip:#()
	ignoreInvalid:true
    "
!

xTestReversability:encoderClass skip:skippedCodes
    self
	xTestReversability:encoderClass
	range:(encoderClass minCode to:encoderClass maxCode)
	skip:skippedCodes

    "
     self new xTestReversability: (CharacterEncoder::ISO8859_1)
     self new xTestReversability: (CharacterEncoder::JIS0208)
    "
!

xTestReversability:encoderClass skip:skippedCodes ignoreInvalid:ignoreInvalid
    self
	xTestReversability:encoderClass
	range:(encoderClass minCode to:encoderClass maxCode)
	skip:skippedCodes
	ignoreInvalid:ignoreInvalid

    "
     self new xTestReversability: (CharacterEncoder::ISO8859_1)
     self new xTestReversability: (CharacterEncoder::JIS0208)
    "
! !

!CharacterEncoderTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!CharacterEncoderTests methodsFor:'tests'!

test1
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_1).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_2).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_3) skip:#( 16rA5 16rAE 16rBE 16rC3 16rD0 16rE3 16rF0 ).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_4).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_5).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_6) skip:#(       16rA1 16rA2 16rA3       16rA5 16rA6 16rA7
                                                                    16rA8 16rA9 16rAA 16rAB             16rAE 16rAF
                                                                    16rB0 16rB1 16rB2 16rB3 16rB4 16rB5 16rB6 16rB7
                                                                    16rB8 16rB9 16rBA       16rBC 16rBD 16rBE
                                                                    16rC0
                                                                                      16rDB 16rDC 16rDD 16rDE 16rDF
                                                                                      16rF3 16rF4 16rF5 16rF6 16rF7
                                                                    16rF8 16rF9 16rFA 16rFB 16rFC 16rFD 16rFE 16rFF
                                                                  ).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_7) skip:#( 16rAE 16rD2 16rFF ).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_8) skip:#( 16rA1 16rBF
                                                                    16rC0 16rC1 16rC2 16rC3 16rC4 16rC5 16rC6 16rC7
                                                                    16rC8 16rC9 16rCA 16rCB 16rCC 16rCD 16rCE 16rCF
                                                                    16rD0 16rD1 16rD2 16rD3 16rD4 16rD5 16rD6 16rD7
                                                                    16rD8 16rD9 16rDA 16rDB 16rDC 16rDD 16rDE
                                                                    16rFB 16rFC 16rFF
                                                                  ).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_9).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_10).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_11) skip:#( 16rDB 16rDC 16rDD 16rDE 16rFC 16rFD 16rFE 16rFF ).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_13).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_14).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_15).
     self xTestReversability: (CharacterEncoderImplementations::ISO8859_16).
     self xTestReversability: (CharacterEncoderImplementations::KOI8_U).
     self xTestReversability: (CharacterEncoderImplementations::KOI8_R).

"/     self xTestReversability: (CharacterEncoderImplementations::GSM0338) skip:( 16r80 to: 16rFF).

"/     self xTestReversability: (CharacterEncoderImplementations::JIS0208) ignoreInvalid:true.

    "
     self new test1
    "
!

testUTF8
    |encoder|

    encoder := CharacterEncoder encoderToEncodeFrom:#unicode into:#utf8.

    "/ reversibility
    (0 to:16r1FFFF) do:[:eachCodePoint |
        |s1 s2 s3|

        s1 := (Character value:eachCodePoint) asString.
        s2 := encoder encodeString:s1.
        s3 := encoder decodeString:s2.
        self assert:(s1 = s3).
    ].

    "/ 00 .. 7F -> 0xxxxxxx
    #[16r00 16r01 16r02 16r04 16r08 16r10 16r20 16r40
                        16r03 16r07 16r0F 16r1F 16r3F 16r7F]
    do:[:eachCodePoint |
        |s1 s2 s3|

        s1 := (Character value:eachCodePoint) asString.
        s2 := encoder encodeString:s1.
        s3 := encoder decodeString:s2.
        self assert:(s1 = s2).
        self assert:(s2 = s3).
        self assert:(s2 size == 1).
    ].

    "/ 80 .. 7FF -> 110xxxxx 10xxxxxx
    #(16r80 16r100 16r200 16r400
            16r0FF 16r1FF 16r3FF 16r7FF)
    do:[:eachCodePoint |
        |s1 s2 s3|

        s1 := (Character value:eachCodePoint) asString.
        s2 := encoder encodeString:s1.
        self assert:(s2 size == 2).
	self assert:((s2 first codePoint bitAnd:2r11100000) == 2r11000000).
	self assert:((s2 second codePoint bitAnd:2r11000000) == 2r10000000).
        s3 := encoder decodeString:s2.
        self assert:(s1 = s3).
    ].

    "/ 800 .. FFFF -> 1110xxxx 10xxxxxx 10xxxxxx
    #(16r800 16r1000 16r2000 16r4000 16r8000
             16r0FFF 16r1FFF 16r3FFF 16r7FFF 16rFFFF)
    do:[:eachCodePoint |
        |s1 s2 s3|

        s1 := (Character value:eachCodePoint) asString.
        s2 := encoder encodeString:s1.
        self assert:(s2 size == 3).
	self assert:((s2 first codePoint bitAnd:2r11110000) == 2r11100000).
	self assert:((s2 second codePoint bitAnd:2r11000000) == 2r10000000).
	self assert:((s2 third codePoint bitAnd:2r11000000) == 2r10000000).
        s3 := encoder decodeString:s2.
        self assert:(s1 = s3).
    ].

    "/ 10000 .. 1FFFFF -> 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
    #(16r10000 16r20000 16r40000 16r80000 16r10000
               16r1FFFF 16r3FFFF 16r7FFFF 16rFFFFF 16r1FFFFF)
    do:[:eachCodePoint |
        |s1 s2 s3|

        s1 := (Character value:eachCodePoint) asString.
        s2 := encoder encodeString:s1.
        self assert:(s2 size == 4).
	self assert:((s2 first codePoint bitAnd:2r11111000) == 2r11110000).
	self assert:((s2 second codePoint bitAnd:2r11000000) == 2r10000000).
	self assert:((s2 third codePoint bitAnd:2r11000000) == 2r10000000).
	self assert:((s2 fourth codePoint bitAnd:2r11000000) == 2r10000000).
        s3 := encoder decodeString:s2.
        self assert:(s1 = s3).
    ].

    "/ 200000 .. 3FFFFFF -> 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
    #(16r200000 16r400000 16r800000 16r1000000 16r2000000
                16r3FFFFF 16r7FFFFF 16r0FFFFFF 16r1FFFFFF 16r3FFFFFF)
    do:[:eachCodePoint |
        |s1 s2 s3|

        s1 := (Character value:eachCodePoint) asString.
        s2 := encoder encodeString:s1.
        self assert:(s2 size == 5).
	self assert:((s2 first codePoint bitAnd:2r11111100) == 2r11111000).
	self assert:((s2 second codePoint bitAnd:2r11000000) == 2r10000000).
	self assert:((s2 third codePoint bitAnd:2r11000000) == 2r10000000).
	self assert:((s2 fourth codePoint bitAnd:2r11000000) == 2r10000000).
	self assert:((s2 fifth codePoint bitAnd:2r11000000) == 2r10000000).
        s3 := encoder decodeString:s2.
        self assert:(s1 = s3).
    ].

    "/ ST/X limitation: only 30 bit integers (to avoid largeInteger codePoint)

    "/ 4000000 .. 7FFFFFFF -> 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
    #(16r4000000 16r8000000 16r10000000 16r20000000 "16r40000000"
                 16r7FFFFFF 16r0FFFFFFF 16r1FFFFFFF "16r3FFFFFFF 16r7FFFFFFF")
    do:[:eachCodePoint |
        |s1 s2 s3|

        s1 := (Character value:eachCodePoint) asString.
        s2 := encoder encodeString:s1.
        self assert:(s2 size == 6).
	self assert:((s2 first codePoint bitAnd:2r11111110) == 2r11111100).
	self assert:((s2 second codePoint bitAnd:2r11000000) == 2r10000000).
	self assert:((s2 third codePoint bitAnd:2r11000000) == 2r10000000).
	self assert:((s2 fourth codePoint bitAnd:2r11000000) == 2r10000000).
	self assert:((s2 fifth codePoint bitAnd:2r11000000) == 2r10000000).
	self assert:((s2 sixth codePoint bitAnd:2r11000000) == 2r10000000).
        s3 := encoder decodeString:s2.
        self assert:(s1 = s3).
    ].

    "
     self new testUTF8
    "
! !

!CharacterEncoderTests class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

