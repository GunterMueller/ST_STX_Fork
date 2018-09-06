"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#UninterpretedBytesTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!


!UninterpretedBytesTest class methodsFor:'queries'!

coveredClassNames
    ^ #( UninterpretedBytes)
! !

!UninterpretedBytesTest methodsFor:'tests'!

test00_byteAccess
    |bytes|

    bytes := #[ 16r10 16r20 16r30 16r40 ].

    self assert:(bytes byteAt:1) == 16r10.
    self assert:(bytes byteAt:2) == 16r20.
    self assert:(bytes byteAt:3) == 16r30.
    self assert:(bytes byteAt:4) == 16r40.

    self assert:(bytes signedByteAt:1) == 16r10.
    self assert:(bytes signedByteAt:2) == 16r20.
    self assert:(bytes signedByteAt:3) == 16r30.
    self assert:(bytes signedByteAt:4) == 16r40.

    bytes := #[ 16rFF 16r7F 16r80 16r81 ].

    self assert:(bytes byteAt:1) == 16rFF.
    self assert:(bytes byteAt:2) == 16r7F.
    self assert:(bytes byteAt:3) == 16r80.
    self assert:(bytes byteAt:4) == 16r81.

    self assert:(bytes signedByteAt:1) == -1.
    self assert:(bytes signedByteAt:2) == 127.
    self assert:(bytes signedByteAt:3) == -128.
    self assert:(bytes signedByteAt:4) == -127.

    bytes := bytes copy.

    bytes byteAt:1 put:16r10.
    self assert:(bytes byteAt:1) == 16r10.
    self assert:(bytes signedByteAt:1) == 16r10.

    bytes byteAt:1 put:16r80.
    self assert:(bytes byteAt:1) == 16r80.
    self assert:(bytes signedByteAt:1) == -128.

    bytes signedByteAt:1 put:16r10.
    self assert:(bytes byteAt:1) == 16r10.
    self assert:(bytes signedByteAt:1) == 16r10.

    bytes signedByteAt:1 put:-1.
    self assert:(bytes byteAt:1) == 16rFF.
    self assert:(bytes signedByteAt:1) == -1.

    "/ check immutablility checks
    bytes :=  #[ 16rFF 16r00 ] beImmutable.
    self
	should:[
	    bytes byteAt:1 put:0
	]
	raise:NoModificationError.
    self assert:(bytes at:1) == 16rFF.

    "/ check bounds checks
    #(3 0 -1 -2) do:[:badIndex |
	self
	    should:[
		#[ 16rFF 16r00 ] byteAt:badIndex
	    ]
	    raise:SubscriptOutOfBoundsError.

	self
	    should:[
		#[ 16rFF 16r00 ] signedByteAt:badIndex
	    ]
	    raise:SubscriptOutOfBoundsError.

	self
	    should:[
		#[ 16rFF 16r00 ] byteAt:badIndex put:0
	    ]
	    raise:SubscriptOutOfBoundsError.

	self
	    should:[
		#[ 16rFF 16r00 ] signedByteAt:badIndex put:0
	    ]
	    raise:SubscriptOutOfBoundsError.
    ]

    "
     self run:#test00_byteAccess
    "
!

test01_int16Access
    |check bytes|

    check :=
	[:bytes1 :bytes2 |
	    |wBytes|

	    "/ bytes1 := #[ 16r10 16r20 16r30 16r40 ].
	    self assert:(bytes1 unsignedInt16At:1 MSB:true)  = 16r1020.
	    self assert:(bytes1 unsignedInt16At:1 MSB:false) = 16r2010.
	    self assert:(bytes1 unsignedInt16At:2 MSB:true)  = 16r2030.
	    self assert:(bytes1 unsignedInt16At:2 MSB:false) = 16r3020.
	    self assert:(bytes1 unsignedInt16At:3 MSB:true)  = 16r3040.
	    self assert:(bytes1 unsignedInt16At:3 MSB:false) = 16r4030.

	    self assert:(bytes1 signedInt16At:1 MSB:true)  = 16r1020.
	    self assert:(bytes1 signedInt16At:1 MSB:false) = 16r2010.
	    self assert:(bytes1 signedInt16At:2 MSB:true)  = 16r2030.
	    self assert:(bytes1 signedInt16At:2 MSB:false) = 16r3020.
	    self assert:(bytes1 signedInt16At:3 MSB:true)  = 16r3040.
	    self assert:(bytes1 signedInt16At:3 MSB:false) = 16r4030.

	    "/ bytes2 := #[ 16rFF 16r7F 16r80 16r81 ].
	    self assert:(bytes2 unsignedInt16At:1 MSB:true)  = 16rFF7F.
	    self assert:(bytes2 unsignedInt16At:1 MSB:false) = 16r7FFF.
	    self assert:(bytes2 unsignedInt16At:2 MSB:true)  = 16r7F80.
	    self assert:(bytes2 unsignedInt16At:2 MSB:false) = 16r807F.
	    self assert:(bytes2 unsignedInt16At:3 MSB:true)  = 16r8081.
	    self assert:(bytes2 unsignedInt16At:3 MSB:false) = 16r8180.

	    self assert:(bytes2 signedInt16At:1 MSB:true)  = -129.  "/ 16rFF7F signExtendedShortValue
	    self assert:(bytes2 signedInt16At:1 MSB:false) = 16r7FFF.
	    self assert:(bytes2 signedInt16At:2 MSB:true)  = 16r7F80.
	    self assert:(bytes2 signedInt16At:2 MSB:false) = -32641. "/ 16r807F signExtendedShortValue.
	    self assert:(bytes2 signedInt16At:3 MSB:true)  = -32639. "/ 16r8081 signExtendedShortValue.
	    self assert:(bytes2 signedInt16At:3 MSB:false) = -32384. "/ 16r8180 signExtendedShortValue.

	    wBytes := bytes2 copy.

	    wBytes unsignedInt16At:1 put:16r1020 MSB:false.
	    self assert:(wBytes unsignedInt16At:1 MSB:false) = 16r1020.
	    self assert:(wBytes signedInt16At:1 MSB:false) = 16r1020.

	    wBytes unsignedInt16At:1 put:16r1020 MSB:true.
	    self assert:(wBytes unsignedInt16At:1 MSB:false) = 16r2010.
	    self assert:(wBytes signedInt16At:1 MSB:false) = 16r2010.

	    wBytes unsignedInt16At:1 put:16rFFFE MSB:false.
	    self assert:(wBytes unsignedInt16At:1 MSB:false) = 16rFFFE.
	    self assert:(wBytes signedInt16At:1 MSB:false) = -2.

	    wBytes unsignedInt16At:1 put:16rFFFE MSB:true.
	    self assert:(wBytes unsignedInt16At:1 MSB:false) = 16rFEFF.
	    self assert:(wBytes signedInt16At:1 MSB:false) = -257.  "/ 16rFEFF signExtendedShortValue

	    wBytes signedInt16At:1 put:16r1020 MSB:false.
	    self assert:(wBytes unsignedInt16At:1 MSB:false) = 16r1020.
	    self assert:(wBytes signedInt16At:1 MSB:false) = 16r1020.

	    wBytes signedInt16At:1 put:16r1020 MSB:true.
	    self assert:(wBytes unsignedInt16At:1 MSB:false) = 16r2010.
	    self assert:(wBytes signedInt16At:1 MSB:false) = 16r2010.

	    wBytes signedInt16At:1 put:-3 MSB:false.
	    self assert:(wBytes unsignedInt16At:1 MSB:false) = 16rFFFD.
	    self assert:(wBytes signedInt16At:1 MSB:false) = -3.
	].

    check
	value: #[ 16r10 16r20 16r30 16r40 ]
	value: #[ 16rFF 16r7F 16r80 16r81 ].

    check
	value: (WordArray with:16r2010 with:16r4030)
	value: (WordArray with:16r7FFF with:16r8180).

    check
	value: (IntegerArray with:16r40302010)
	value: (IntegerArray with:16r81807FFF).

    "/ check immutablility checks
    bytes :=  #[ 1 2 ] beImmutable.
    self
	should:[
	    bytes unsignedInt16At:1 put:0
	]
	raise:NoModificationError.
    self assert:(bytes at:1) == 1.
    self assert:(bytes at:2) == 2.

    "/ check bounds checks
    #(2 0 -1 -2) do:[:badIndex |
	self
	    should:[
		#[ 16rFF 16r00 ] unsignedInt16At:badIndex MSB:true
	    ]
	    raise:SubscriptOutOfBoundsError.

	self
	    should:[
		#[ 16rFF 16r00 ] unsignedInt16At:badIndex MSB:false
	    ]
	    raise:SubscriptOutOfBoundsError.
    ]

    "
     self run:#test01_int16Access
    "
!

test02_int32Access
    |bytes|

    bytes := #[ 16r10 16r20 16r30 16r40 16r50 ].

    self assert:(bytes unsignedInt32At:1 MSB:true)  = 16r10203040.
    self assert:(bytes unsignedInt32At:1 MSB:false) = 16r40302010.
    self assert:(bytes unsignedInt32At:2 MSB:true)  = 16r20304050.
    self assert:(bytes unsignedInt32At:2 MSB:false) = 16r50403020.

    self assert:(bytes signedInt32At:1 MSB:true)  = 16r10203040.
    self assert:(bytes signedInt32At:1 MSB:false) = 16r40302010.
    self assert:(bytes signedInt32At:2 MSB:true)  = 16r20304050.
    self assert:(bytes signedInt32At:2 MSB:false) = 16r50403020.


    bytes := #[ 16r80 16rFF 16r01 16r03 16r80 ].

    self assert:(bytes unsignedInt32At:1 MSB:true)  = 16r80FF0103.
    self assert:(bytes unsignedInt32At:1 MSB:false) = 16r0301FF80.
    self assert:(bytes unsignedInt32At:2 MSB:true)  = 16rFF010380.
    self assert:(bytes unsignedInt32At:2 MSB:false) = 16r800301FF.

    self assert:(bytes signedInt32At:1 MSB:true)  = -2130771709.  "/ 16r80FF0103 signExtendedLongValue
    self assert:(bytes signedInt32At:1 MSB:false) = 16r0301FF80.
    self assert:(bytes signedInt32At:2 MSB:true)  = -16710784. "/ 16rFF010380 signExtendedLongValue.
    self assert:(bytes signedInt32At:2 MSB:false) = -2147286529. "/ 16r800301FF signExtendedLongValue.

    bytes := bytes copy.

    bytes unsignedInt32At:1 put:16r10203040 MSB:false.
    self assert:(bytes unsignedInt32At:1 MSB:false) = 16r10203040.
    self assert:(bytes signedInt32At:1 MSB:false) = 16r10203040.

    bytes unsignedInt32At:1 put:16r10203040 MSB:true.
    self assert:(bytes unsignedInt32At:1 MSB:false) = 16r40302010.
    self assert:(bytes signedInt32At:1 MSB:false) = 16r40302010.

    bytes unsignedInt32At:1 put:16r10203080 MSB:true.
    self assert:(bytes unsignedInt32At:1 MSB:false) = 16r80302010.
    self assert:(bytes signedInt32At:1 MSB:false) = -2144329712. "/ 16r80302010 signExtendedLongValue.

    bytes unsignedInt32At:1 put:16rFFFFFFFE MSB:false.
    self assert:(bytes unsignedInt32At:1 MSB:false) = 16rFFFFFFFE.
    self assert:(bytes signedInt32At:1 MSB:false) = -2.

    bytes signedInt32At:1 put:16r40302010 MSB:false.
    self assert:(bytes unsignedInt32At:1 MSB:false) = 16r40302010.
    self assert:(bytes signedInt32At:1 MSB:false) = 16r40302010.

    bytes signedInt32At:1 put:-3 MSB:false.
    self assert:(bytes unsignedInt32At:1 MSB:false) = 16rFFFFFFFD.
    self assert:(bytes signedInt32At:1 MSB:false) = -3.

    "/ check immutablility checks
    bytes :=  #[ 1 2 3 4 ] beImmutable.
    self
	should:[
	    bytes unsignedInt32At:1 put:0
	]
	raise:NoModificationError.
    self assert:(bytes at:1) == 1.
    self assert:(bytes at:2) == 2.
    self assert:(bytes at:3) == 3.
    self assert:(bytes at:4) == 4.

    "/ check bounds checks
    #(2 0 -1 -2) do:[:badIndex |
	self
	    should:[
		#[ 16rFF 16r01 16r02 16r03 ] unsignedInt32At:badIndex MSB:true
	    ]
	    raise:SubscriptOutOfBoundsError.

	self
	    should:[
		#[ 16rFF 16r01 16r02 16r03 ] unsignedInt32At:badIndex MSB:false
	    ]
	    raise:SubscriptOutOfBoundsError.
    ]

    "
     self run:#test02_int32Access
    "
!

test03_int64Access
    |bytes|

    bytes := #[ 16r10 16r20 16r30 16r40 16r50 16r60 16r70 16r80 16r90].

    self assert:(bytes unsignedInt64At:1 MSB:true)  = 16r1020304050607080.
    self assert:(bytes unsignedInt64At:1 MSB:false) = 16r8070605040302010.
    self assert:(bytes unsignedInt64At:2 MSB:true)  = 16r2030405060708090.
    self assert:(bytes unsignedInt64At:2 MSB:false) = 16r9080706050403020.

    self assert:(bytes signedInt64At:1 MSB:true)  = 16r1020304050607080.
    self assert:(bytes signedInt64At:1 MSB:false) = -9191740941672636400. "/ 16r8070605040302010  signExtendedLongLongValue
    self assert:(bytes signedInt64At:2 MSB:true)  = 16r2030405060708090.
    self assert:(bytes signedInt64At:2 MSB:false) = -8034298176263409632. "/ 16r9080706050403020 signExtendedLongLongValue.

    bytes := bytes copy.
    bytes unsignedInt64At:1 put:16r30405060708090A0 MSB:true.
    self assert:(bytes unsignedInt64At:1 MSB:true)   = 16r30405060708090A0.
    self assert:(bytes unsignedInt64At:1 MSB:false)  = 16rA090807060504030.
    self assert:(bytes signedInt64At:1 MSB:true)   = 16r30405060708090A0.
    self assert:(bytes signedInt64At:1 MSB:false)  = -6876855410854182864. "/ 16rA090807060504030 signExtendedLongLongValue.

    bytes signedInt64At:1 put:-6876855410854182864 MSB:true.
    self assert:(bytes unsignedInt64At:1 MSB:true)   = 16rA090807060504030.
    self assert:(bytes signedInt64At:1 MSB:true)   = -6876855410854182864.

    bytes signedInt64At:1 put:-6876855410854182864 MSB:false.
    self assert:(bytes unsignedInt64At:1 MSB:false)   = 16rA090807060504030.
    self assert:(bytes signedInt64At:1 MSB:false)   = -6876855410854182864.

    bytes unsignedInt64At:1 put:16r30405060708090A0 MSB:false.
    self assert:(bytes unsignedInt64At:1 MSB:true)   = 16rA090807060504030.
    self assert:(bytes unsignedInt64At:1 MSB:false)  = 16r30405060708090A0.
    self assert:(bytes signedInt64At:1 MSB:true)  = -6876855410854182864. "/ 16rA090807060504030 signExtendedLongLongValue.
    self assert:(bytes signedInt64At:1 MSB:false)   = 16r30405060708090A0.

    "/ check immutablility checks
    bytes :=  #[ 1 2 3 4 5 6 7 8 ] beImmutable.
    self
	should:[
	    bytes unsignedInt64At:1 put:0
	]
	raise:NoModificationError.
    self assert:(bytes at:1) == 1.
    self assert:(bytes at:2) == 2.
    self assert:(bytes at:3) == 3.
    self assert:(bytes at:4) == 4.
    self assert:(bytes at:5) == 5.
    self assert:(bytes at:6) == 6.
    self assert:(bytes at:7) == 7.
    self assert:(bytes at:8) == 8.

    "/ check bounds checks
    #(2 0 -1 -2) do:[:badIndex |
	self
	    should:[
		#[ 16rFF 16r01 16r02 16r03 16r04 16r05 16r06 16r07 ] unsignedInt64At:badIndex MSB:true
	    ]
	    raise:SubscriptOutOfBoundsError.

	self
	    should:[
		#[ 16rFF 16r01 16r02 16r03 16r04 16r05 16r06 16r07 ] unsignedInt64At:badIndex MSB:false
	    ]
	    raise:SubscriptOutOfBoundsError.
    ]

    "
     self run:#test03_int64Access
    "
!

test10_floatAccess
    |bytes|

    bytes := ByteArray new:4.
    bytes floatAt:1 put:1.234.
    self assert:(bytes = #[182 243 157 63]).

    bytes floatAt:1 put:2.345 asShortFloat.
    self assert:(bytes = #[123 20 22 64]).

    bytes floatAt:1 put:345.
    self assert:(bytes = #[0 128 172 67]).


    bytes := ByteArray new:8.
    bytes doubleAt:1 put:1.234.
    self assert:(bytes = #[88 57 180 200 118 190 243 63]).

    bytes doubleAt:1 put:2.345 asShortFloat.
    self assert:(bytes = #[0 0 0 96 143 194 2 64]).

    bytes doubleAt:1 put:345.
    self assert:(bytes = #[0 0 0 0 0 144 117 64]).

    "/ check bounds checks
    #(2 0 -1 -2) do:[:badIndex |
	self
	    should:[
		#[ 16rFF 16r01 16r02 16r03 ] floatAt:badIndex MSB:true
	    ]
	    raise:SubscriptOutOfBoundsError.

	self
	    should:[
		#[ 16rFF 16r01 16r02 16r03 ] floatAt:badIndex MSB:false
	    ]
	    raise:SubscriptOutOfBoundsError.

	self
	    should:[
		#[ 16rFF 16r01 16r02 16r03 16rFF 16r01 16r02 16r03 ] doubleAt:badIndex MSB:true
	    ]
	    raise:SubscriptOutOfBoundsError.

	self
	    should:[
		#[ 16rFF 16r01 16r02 16r03 16rFF 16r01 16r02 16r03 ] doubleAt:badIndex MSB:false
	    ]
	    raise:SubscriptOutOfBoundsError.
    ]

    "
     self run:#test10_floatAccess
    "
!

test90_backwardCompatibility
    "/ backward compatibility stuff
    self assert:(#[ 16r10 16r20 ] wordAt:1 MSB:true)  = 16r1020.
    self assert:(#[ 16r10 16r20 ] wordAt:1 MSB:false) = 16r2010.
    self assert:(#[ 16r80 16r20 ] wordAt:1 MSB:true)  = 16r8020.
    self assert:(#[ 16r80 16r20 ] wordAt:1 MSB:false) = 16r2080.

    self assert:(#[ 16r10 16r20 ] signedWordAt:1 MSB:true)  = 16r1020.
    self assert:(#[ 16r10 16r20 ] signedWordAt:1 MSB:false) = 16r2010.
    self assert:(#[ 16r80 16r20 ] signedWordAt:1 MSB:true)  = -32736. "/ 16r8020 signExtendedShortValue.
    self assert:(#[ 16r80 16r20 ] signedWordAt:1 MSB:false) = 16r2080.

    self assert:(#[ 16r10 16r20 16r30 16r40 ] longAt:1 bigEndian:true)  = 16r10203040.
    self assert:(#[ 16r10 16r20 16r30 16r40 ] longAt:1 bigEndian:false) = 16r40302010.
    self assert:(#[ 16r80 16r20 16r30 16r40 ] longAt:1 bigEndian:true)  = -2145374144. "/ 16r80203040 signExtendedLongValue.
    self assert:(#[ 16r80 16r20 16r30 16r40 ] longAt:1 bigEndian:false) = 16r40302080.

    "
     self run:#test90_backwardCompatibility
    "
! !

!UninterpretedBytesTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

