"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#StreamTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Streams'
!

!StreamTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!StreamTests class methodsFor:'queries'!

coveredClassNames
    ^ #(
        'PositionableStream'
        'ReadStream'
        'WriteStream'
        'Stream'
    )

    "Created: / 16-09-2011 / 14:56:05 / cg"
! !

!StreamTests methodsFor:'setup'!

setUp
    (Smalltalk classNamed:'stx_libcompat') isNil ifTrue:[
        (Smalltalk loadPackage:'stx:libcompat') ifFalse:[
            self error:'libcompat cannot be loaded'.        
        ].
    ].
    (Smalltalk classNamed:'stx_libcompat') load.
! !

!StreamTests methodsFor:'tests'!

test01_numberReading_squeak
    |b s val|

    b := #[1 2 3 4].
    s := b readStream.
    val := s nextLittleEndianNumber:4.
    self assert:val = 16r04030201.
    self assert:( s atEnd ).

    self assert:( val := #[16r81 16r82 16r83 16r84] readStream nextLittleEndianNumber:4 ) = 16r84838281.
    self assert:( val := #[16r81 16r82 16r83 16r84 16r85 16r86 16r87 16r88] readStream nextLittleEndianNumber:8 ) = 16r8887868584838281.

    "/ signed
    self assert:( val := #[16r01 16r02 16r03 16r04] readStream nextLongMSB:true ) = 16r01020304.
    self assert:( val := #[16rFF 16rFF 16rFF 16rFF] readStream nextLongMSB:true ) = -1.
    self assert:( val := #[16r80 16r00 16r00 16r00] readStream nextLongMSB:true ) = -2147483648.

    s := WriteStream on:ByteArray new.
    s nextPutLong:16r01020304 MSB:true.
    self assert:( val := s contents ) = #[16r01 16r02 16r03 16r04].

    s := WriteStream on:ByteArray new.
    s nextLittleEndianNumber:4 put:16r01020304.
    self assert:( val := s contents ) = #[16r04 16r03 16r02 16r01].

    s := WriteStream on:ByteArray new.
    s nextLittleEndianNumber:8 put:16r0102030405060708.
    self assert:( val := s contents ) = #[16r08 16r07 16r06 16r05 16r04 16r03 16r02 16r01].

    "
     self run:#test01_numberReading
     self new test01_numberReading
    "

    "Created: / 16-09-2011 / 15:26:10 / cg"
!

test02_readStream
    {
        #($a $b $c $d $a $b $c $d $a $b $c $d $a $b $c $d) .
        #[97 98 99 100 97 98 99 100 97 98 99 100]          .
        'abcdabcdabcdabcd'                                 .
        'abcdabcdabcdabcd' asUnicode16String               .
        'abcdabcdabcdabcd' asUnicode32String               .
    } do:[:coll|
        |s e t|

        s := coll readStream.

        "/ initial state?
        self assert:(s atEnd not).
        self assert:(s position == 0).
        "/ peek returns the correct value
        e := s peek.
        self assert:(e asInteger == 97).

        "/ peek should not change any state
        self assert:(s atEnd not).
        self assert:(s position == 0).
        e := s next.
        self assert:(e asInteger == 97).
        self assert:(s position == 1).
        self assert:(s atEnd not).

        e := s peek.
        self assert:(s position == 1).
        self assert:(e asInteger == 98).

        s position:0.
        self assert:(s atEnd not).
        self assert:(s position == 0).
        e := s peek.
        self assert:(e asInteger == 97).

        s position:coll size.
        self assert:(s atEnd).
        self assert:(s position == coll size).

        s position:0.
        self assert:(s position == 0).
        e := s peek.
        self assert:(e asInteger == 97).

        t := s next:2.
        self assert:(t size == 2).
        self assert:(t at:1) asInteger == 97.
        self assert:(t at:2) asInteger == 98.
        self assert:(s position == 2).

        s position:1.
        self assert:(s position == 1).
        e := s peek.
        self assert:(e asInteger == 98).
        t := s upTo:(coll at:1).
        self assert:(t size == 3).
        self assert:(t at:1) == (coll at:2).
        self assert:(t at:2) == (coll at:3).
        self assert:(t at:3) == (coll at:4).

        self assert:(s position == 5).
        self assert:(s peek asInteger == (coll at:2) asInteger).

        s position:1.
        (coll at:1) isCharacter ifTrue:[
            s skipSeparators.
            self assert:(s position == 1).
        ].

        s position:(coll size - 1).
        t := s upToEnd.
        self assert:(s position == coll size).
        self assert:(t size == 1).
        self assert:(t at:1) == (coll at:coll size).

        s position:0.
        (coll at:1) isCharacter ifTrue:[
            t := s nextAlphaNumericWord.
            self assert:(t asArray = coll asArray).
            self assert:(s position == coll size).
        ].
        
    ].

    "
     self run:#test02_readStream
     self new test02_readStream
    "
!

test03_readStream
    {
        #($a $b $c $d $ $a $b $c $d $a $b $c $d $a $b $c $d) .
        #[97 98 99 100 20 97 98 99 100 97 98 99 100]          .
        'abcd abcdabcdabcd'                                 .
        'abcd abcdabcdabcd' asUnicode16String               .
        'abcd abcdabcdabcd' asUnicode32String               .
    } do:[:coll|
        |s e t|

        s := coll readStream.

        s position:3.
        (coll at:1) isCharacter ifTrue:[
            s skipSeparators.
            self assert:(s position == 3).
            s next.
            s skipSeparators.
            self assert:(s position == 5).
        ].

        s position:0.
        (coll at:1) isCharacter ifTrue:[
            t := s nextAlphaNumericWord.
            self assert:(t asArray = (coll asArray copyTo:4)).
            self assert:(s position == 4).
        ].
        
    ].

    "
     self run:#test02_readStream
     self new test02_readStream
    "
!

test04_readIntegers
    |s n|

         "0123456789012345678901"
    s := '1234 56789    123    ' readStream.
    self assert:((n := s nextDecimalInteger) == 1234).
    self assert:(s position == 4).

    s skipSeparators.
    self assert:(s position == 5).

    self assert:((n := s nextDecimalInteger) == 56789).
    self assert:(s position == 10).

    s skipSeparators.
    self assert:(s position == 14).

    self assert:((n := s nextDecimalInteger) == 123).
    self assert:(s position == 17).

    "/ is this the correct behavior?
    self assert:((n := s nextDecimalInteger) == 0).
    self assert:(s position == 17).

    "
     self run:#test04_readIntegers
     self new test04_readIntegers
    "
!

test05_readAlphanumericWords
    |s w|

         "0123456789012345678901"
    s := 'a234 b6789    c23    ' readStream.
    self assert:((w := s nextAlphaNumericWord) = 'a234').
    self assert:(s position == 4).

    self assert:((w := s nextAlphaNumericWord) = 'b6789').
    self assert:(s position == 10).

    self assert:((w := s nextAlphaNumericWord) = 'c23').
    self assert:(s position == 17).

    "/ is this the correct behavior?
    self assert:((w := s nextAlphaNumericWord) isNil).
    self assert:(s position == 21).

    "
     self run:#test05_readAlphanumericWords
     self new test05_readAlphanumericWords
    "
!

test06_writeStream
    |s|

         "0123456789012345678901"
    s := WriteStream on:(String new).
    self assert:(s position == 0).
    self assert:(s readLimit == 0).
    s nextPut:$a.
    self assert:(s position == 1).
    self assert:(s contents = 'a').
    self assert:(s readLimit == 1).

    s nextPut:$b.
    self assert:(s position == 2).
    self assert:(s contents = 'ab').
    self assert:(s readLimit == 2).

    s nextPut:$c.
    self assert:(s position == 3).
    "/ self assert:(s contents = 'abc').
    self assert:(s readLimit == 3).

    "/ fill to right before it has to resize
    s position to:(s collection size) do:[:i | s nextPut:$0+(i\\10)].
    self assert:(s contents = ('abc345678901234567890' copyTo:s size)).

    "
     self run:#test06_writeStream
     self new test06_writeStream
    "
!

test07_writeStream
    |s|

         "0123456789012345678901"
    s := '' writeStream.
    s nextPut:$a.
    self assert:(s last) == $a.       
    self assert:(s last:1) = 'a'.       
    s nextPut:$b.
    self assert:(s last) == $b.       
    self assert:(s last:1) = 'b'.       
    self assert:(s last:2) = 'ab'.       
    s nextPut:$c.
    self assert:(s last) == $c.       
    self assert:(s last:1) = 'c'.       
    self assert:(s last:2) = 'bc'.       
    self assert:(s last:3) = 'abc'.       

    s nextPutAll:'123'.
    self assert:(s last) == $3.       
    self assert:(s last:1) = '3'.       
    self assert:(s last:2) = '23'.       
    self assert:(s last:3) = '123'.       

    s next:1 put:$4.
    self assert:(s last) == $4.       
    self assert:(s last:1) = '4'.       
    self assert:(s last:2) = '34'.       
    self assert:(s last:3) = '234'.       
    self assert:(s size == 7).       

    s next:3 put:$5.
    self assert:(s last) == $5.       
    self assert:(s last:1) = '5'.       
    self assert:(s last:2) = '55'.       
    self assert:(s last:3) = '555'.       
    self assert:(s last:4) = '4555'.       
    self assert:(s size == 10).       

    "
     self run:#test07_writeStream
     self new test07_writeStream
    "
!

test08_writeStream
    |s|

    s := '' writeStream.
    s nextPutAll:'hello '.
    s nextPutAll:'1234world012345' startingAt:5 to:9.
    self assert:( s contents = 'hello world' ). 

    s := '' writeStream.
    s nextPutAll:'hello'.
    s space.
    s nextPutAll:'world'.
    self assert:( s contents = 'hello world' ). 

    "
     self run:#test08_writeStream
     self new test08_writeStream
    "
!

test09_writeStreamErrors
    |s|

    s := '' writeStream.
    self should:[ s nextPutAll:nil ] raise:Error.
    self assert:( s contents = '' ). 

    "
     self run:#test09_writeStreamErrors
     self new test09_writeStreamErrors
    "
!

test20_readWriteStream
    |s ch string|

         "0123456789012345678901"
    s := ReadWriteStream on:(String new).
    self assert:(s position == 0).
    self assert:(s readLimit == 0).

    s nextPutAll:'hello'.
    self assert:(s position == 5).
    self assert:(s contents = 'hello').
    self assert:(s readLimit == 5).

    s nextPut:Character space.
    self assert:(s position == 6).
    self assert:(s contents = 'hello ').
    self assert:(s readLimit == 6).

    s nextPutAll:'world'.
    self assert:(s position == 11).
    self assert:(s contents = 'hello world').
    self assert:(s readLimit == 11).

    s reset.
    self assert:(s position == 0).
    self assert:(s readLimit == 11).

    ch := s next.
    self assert:(ch == $h).
    string := s next:4.
    self assert:(string = 'ello').
    s reset.
    self assert:(s position == 0).
    self assert:(s readLimit == 11).

    string := s upToEnd.
    self assert:(string = 'hello world').

    "
     self run:#test20_readWriteStream
     self new test20_readWriteStream
    "
!

test21_readWriteStreamWithPosition
    |s|

         "0123456789012345678901"
    s := ReadWriteStream on:(String new).
    self assert:(s position == 0).
    self assert:(s readLimit == 0).

    s nextPutAll:'hello'.
    self assert:(s position == 5).
    self assert:(s readLimit == 5).

    s nextPutAll:' world'.
    self assert:(s position == 11).
    self assert:(s readLimit == 11).

    s position:(s position - 5).
    self assert:(s upToEnd = 'world').
    self assert:(s position = 11).
    self assert:(s readLimit = 11).

    "
     self run:#test21_readWriteStreamWithPosition
     self new test21_readWriteStreamWithPosition
    "
!

test22_readWriteStreamWithRewrite
    |s|

         "0123456789012345678901"
    s := ReadWriteStream on:(String new).
    self assert:(s position == 0).
    self assert:(s readLimit == 0).

    s nextPutAll:'hello world'.
    self assert:(s position == 11).
    self assert:(s readLimit == 11).

    s position:(s position - 5).
    self assert:(s position = 6).
    s nextPutAll:'W'.
    
    self assert:(s position = 7).
    self assert:(s readLimit = 11).
    self assert:(s contents = 'hello World').

    
    "
     self run:#test22_readWriteStreamWithRewrite
     self new test21_readWriteStreamWithPosition
    "
!

test30_readWriteBinary
    |testVector f s val|

    #(
        0       #[ 0 0 ]
        1       #[ 0 1 ]
        16r7F   #[ 0 16r7F ]
        16r80   #[ 0 16r80 ]
        16rFF   #[ 0 16rFF ]
        16r100  #[ 1 16r00 ]
        16r7FFF #[ 16r7F 16rFF ]

       -1       #[ 16rFF 16rFF ]
       -16r7F   #[ 16rFF 16r81 ]
       -16r80   #[ 16rFF 16r80 ]
       -16rFF   #[ 16rFF 16r01 ]
       -16r7FFF #[ 16r80 16r01 ]
       -16r8000 #[ 16r80 16r00 ]
    ) pairWiseDo:[:val :expected |    
        s := WriteStream on:(ByteArray new).
        s nextPutShort:val MSB:true.
        self assert:(s contents = expected).

        s := WriteStream on:(ByteArray new).
        s nextPutShort:val MSB:false.
        self assert:(s contents reversed = expected).

        f := Filename newTemporary.
        [    
            s := f writeStream.
            s nextPutShort:val MSB:true.
            s close.
            self assert:(f binaryContentsOfEntireFile = expected).

            s := f writeStream.
            s nextPutShort:val MSB:false.
            s close.
            self assert:(f binaryContentsOfEntireFile reversed = expected).
        ] ensure:[
            f delete
        ].    
    ].
    
    #(
        nextPutShort:MSB:   nextShortMSB:
        nextPutLong:MSB:    nextLongMSB:
        nextPutHyper:MSB:   nextHyperMSB:
        
        nextPutInt16:MSB:   nextInt16MSB:
        nextPutInt32:MSB:   nextInt32MSB:
        nextPutInt64:MSB:   nextInt64MSB:
    ) pairWiseDo:[:writer :reader |
        #(true false) do:[:msb |
            testVector := 
                #(
                    0 1 -1
                    16r7f 16r80 16r81
                    -16r7f -16r80 -16r81
                    16r7fff -16r7fff -16r8000
                ).
                 
            s := ReadWriteStream on:(ByteArray new).
            testVector do:[:written |
                s perform:writer with:written with:msb.
            ].

            s reset.

            testVector do:[:expected |
                self assert:(val := s perform:reader with:msb) == expected.
            ].

            "/ ----
            f := Filename newTemporary.
            [
                s := f writeStream.
                testVector do:[:written |
                    s perform:writer with:written with:msb.
                ].

                s close.
                s := f readStream.

                testVector do:[:expected |
                    self assert:(val := s perform:reader with:msb) == expected.
                ].
                s close.
            ] ensure:[
                f delete
            ]
        ].
    ].
    
    "
     self run:#test30_readWriteBinary
     self new test30_readWriteBinary
    "

    "Modified: / 13-05-2016 / 21:21:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test31_readWriteBinaryIntegers
    |f s|

    #(
        0       1 #[ 0 ]
        0       2 #[ 0 0 ]
        0       3 #[ 0 0 0 ]
        0       4 #[ 0 0 0 0]
        0       6 #[ 0 0 0 0 0 0]

        1       1 #[ 1 ]
        1       2 #[ 0 1 ]
        1       3 #[ 0 0 1 ]
        1       4 #[ 0 0 0 1 ]
        1       6 #[ 0 0 0 0 0 1 ]

       16r8000  2 #[ 16r80 16r00 ]
       16r8000  3 #[ 16r00 16r80 16r00 ]
       16r8000  4 #[ 16r00 16r00 16r80 16r00 ]
       16r8000  5 #[ 16r00 16r00 16r00 16r80 16r00 ]
       16r8000  6 #[ 16r00 16r00 16r00 16r00 16r80 16r00 ]

       16r12345678  4 #[ 16r12 16r34 16r56 16r78 ]
       16r12345678  5 #[ 16r00 16r12 16r34 16r56 16r78 ]
       16r12345678  6 #[ 16r00 16r00 16r12 16r34 16r56 16r78 ]

       16r87654321  4 #[ 16r87 16r65 16r43 16r21 ]
       16r87654321  5 #[ 16r00 16r87 16r65 16r43 16r21 ]
       16r87654321  6 #[ 16r00 16r00 16r87 16r65 16r43 16r21 ]

    ) inGroupsOf:3 do:[:val :nBytes :expected |    

        s := WriteStream on:(ByteArray new).
        s nextNumber:nBytes put:val MSB:true.
        self assert:(s contents = expected).

        s := WriteStream on:(ByteArray new).
        s nextNumber:nBytes put:val MSB:false.
        self assert:(s contents reversed = expected).

        "/ because external streams may have specially tuned output methods,
        "/ test them also
        f := Filename newTemporary.
        [    
            s := f writeStream.
            s nextNumber:nBytes put:val MSB:true.
            s close.
            self assert:(f binaryContentsOfEntireFile = expected).

            s := f writeStream.
            s nextNumber:nBytes put:val MSB:false.
            s close.
            self assert:(f binaryContentsOfEntireFile reversed = expected).
        ] ensure:[
            f delete
        ].    
    ].
    
    
    "
     self run:#test31_readWriteBinaryIntegers
     self new test31_readWriteBinaryIntegers
    "

    "Modified: / 13-05-2016 / 21:22:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    
!

test40_eolMode
    |fn stream lineEnd contents expected eolModeOfStream check eolModePlatformDefault |

    OperatingSystem isMSWINDOWSlike ifTrue:[ 
        eolModePlatformDefault := #crlf
    ] ifFalse:[
        eolModePlatformDefault := #nl.
    ].

    eolModeOfStream :=
        [:stream |
            (stream eolMode == #nl) ifTrue:[
                lineEnd := String lf.
            ] ifFalse:[
                (stream eolMode == #crlf) ifTrue:[
                    lineEnd := String crlf.
                ] ifFalse:[
                    (stream eolMode == #cr) ifTrue:[
                        lineEnd := String return.
                    ] ifFalse:[
                        self error
                    ].    
                ].    
            ].    
        ].
        
    [
        fn := Filename newTemporary.
        stream := fn writeStream.
        "/ all show the same default behavior
        self assert:(stream eolMode == eolModePlatformDefault).
    ] ensure:[
        stream close.
        fn delete.  
    ].
    
    check := 
        [:eolMode |
            fn := Filename newTemporary.
            stream := fn writeStream.
            stream eolMode:eolMode.

            [
                lineEnd := eolModeOfStream value:stream.
                
                stream nextPutAll:'line1'; cr.
                stream nextPutLine:'line2'.
                stream nextPutAll:'line3
line4'; cr.
                stream close.
                
                contents := fn binaryContentsOfEntireFile.
                expected := ('line1*line2*line3*line4*' copyReplaceString:'*' withString:lineEnd) asByteArray.
                
                self assert:(contents = expected ).
            ] ensure:[
                stream close.
                fn delete
            ].    
        ].
    
    check value:#lf.
    check value:#nl.
    check value:#crlf.
    check value:#cr.
    
    "
     self run:#test40_eolMode
     self new test40_eolMode
    "

    "Modified: / 29-04-2016 / 14:20:12 / cg"
    "Modified: / 12-07-2016 / 14:01:15 / jv"
! !

!StreamTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

