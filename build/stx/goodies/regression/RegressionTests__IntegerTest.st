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

TestCase subclass:#IntegerTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Numbers'
!

!IntegerTest class methodsFor:'documentation'!

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
! !

!IntegerTest methodsFor:'misc'!

do:a plus:b
    ^  a + b
!

doAdd2_a:arg
    ^ arg + 2

    "
     (self new doAdd2_a:0) ==   2    
     (self new doAdd2_a:1) ==   3    
     (self new doAdd2_a:SmallInteger maxVal) = (SmallInteger maxVal + 2)  
     (self new doAdd2_a:SmallInteger minVal) = (SmallInteger minVal + 2)
    "

    "Modified: / 9.6.1999 / 16:57:20 / cg"
!

doMul0_a:arg
    ^ arg * 0

    "
     (self doMul0_a:0) ==   0
     (self doMul0_a:1) ==   0
     (self doMul0_a:SmallInteger maxVal) == 0
     (self doMul0_a:SmallInteger minVal) == 0
    "

    "Created: / 9.6.1999 / 15:50:48 / cg"
!

doMul1_a:arg
    ^ arg * 1

    "
     (self doMul1_a:0) ==   0
     (self doMul1_a:1) ==   1
     (self doMul1_a:SmallInteger maxVal) == SmallInteger maxVal
     (self doMul1_a:SmallInteger minVal) == SmallInteger minVal
    "

    "Created: / 9.6.1999 / 15:49:09 / cg"
!

doMul2_a:arg
    ^ arg * 2

    "
     (self doMul2_a:0) ==   0
     (self doMul2_a:1) ==   2
     (self doMul2_a:SmallInteger maxVal) = (SmallInteger maxVal + SmallInteger maxVal)
     (self doMul2_a:SmallInteger minVal) = (SmallInteger minVal + SmallInteger minVal)
    "

    "Modified: / 9.6.1999 / 16:57:20 / cg"
!

doMul3_a:arg
    ^ arg * 3

    "
     (self doMul3_a:0) ==   0
     (self doMul3_a:1) ==   3
     (self doMul3_a:-1) ==  -3
     (self doMul3_a:10000) ==   30000
     (self doMul3_a:SmallInteger maxVal) = (SmallInteger maxVal + SmallInteger maxVal + SmallInteger maxVal)
     (self doMul3_a:SmallInteger minVal) = (SmallInteger minVal + SmallInteger minVal + SmallInteger minVal)
    "

    "Created: / 9.6.1999 / 16:57:47 / cg"
    "Modified: / 9.6.1999 / 17:35:34 / cg"
!

doMul4_a:arg
    ^ arg * 4

    "
     (self doMul4_a:0) ==   0
     (self doMul4_a:1) ==   4
     (self doMul4_a:-1) ==  -4
     (self doMul4_a:10000) ==   40000
     (self doMul4_a:SmallInteger maxVal//4) == 4611686018427387900
     (self doMul4_a:SmallInteger maxVal//4+1) = 4611686018427387904
    "

    "Created: / 9.6.1999 / 16:57:47 / cg"
    "Modified: / 9.6.1999 / 17:37:36 / cg"
!

doMul5_a:arg
    ^ arg * 5

    "
     (self doMul5_a:0) ==   0
     (self doMul5_a:1) ==   5
     (self doMul5_a:-1) ==  -5
     (self doMul5_a:10000) ==   50000
     (self doMul5_a:SmallInteger maxVal//5) == 4611686018427387900
     (self doMul5_a:SmallInteger maxVal//4+1) = 4611686018427387905
    "

    "Created: / 9.6.1999 / 17:38:17 / cg"
!

doMulM1_a:arg
    ^ arg * -1

    "
     (self doMulM1_a:0) ==   0
     (self doMulM1_a:1) ==   -1
     (self doMulM1_a:SmallInteger maxVal) == (SmallInteger minVal + 1)
     (self doMulM1_a:SmallInteger minVal) = (SmallInteger maxVal + 1)
    "

    "Modified: / 9.6.1999 / 16:54:02 / cg"
!

doPlus1_a:arg
    ^ arg + 1

    "
     (self doPlus1_a:SmallInteger maxVal) =   1073741824
    "
!

doPlus1_b:arg
    ^ arg perform:#+ with:1

    "
     (self doPlus1_b:SmallInteger maxVal) ==   1073741824
    "
!

testMul0
    self assert: ( (self doMul0_a:0) == 0 ).
    self assert: ( (self doMul0_a:1) == 0 ).
    self assert: ( (self doMul0_a:SmallInteger maxVal) == 0 ).
    self assert: ( (self doMul0_a:SmallInteger minVal) == 0 ).
    self assert: ( (self doMul0_a:SmallInteger maxVal+1) == 0 ).
    self assert: ( (self doMul0_a:SmallInteger minVal-1) == 0 ).

    "
     self basicNew testMul0
    "

    "Created: / 9.6.1999 / 15:50:48 / cg"
!

testMul1
    self assert: ( (self doMul1_a:0) == 0 ).
    self assert: ( (self doMul1_a:1) == 1 ).
    self assert: ( (self doMul1_a:SmallInteger maxVal) == SmallInteger maxVal ).
    self assert: ( (self doMul1_a:SmallInteger minVal) == SmallInteger minVal ).
    self assert: ( (self doMul1_a:SmallInteger maxVal+1) = (SmallInteger maxVal+1) ).
    self assert: ( (self doMul1_a:SmallInteger minVal-1) = (SmallInteger minVal-1) ).

    "
     self basicNew testMul1
    "
!

testMul2
    self assert: ( (self doMul2_a:0) == 0 ).
    self assert: ( (self doMul2_a:1) == 2 ).
    self assert: ( (self doMul2_a:SmallInteger maxVal) = (SmallInteger maxVal + SmallInteger maxVal) ).
    self assert: ( (self doMul2_a:SmallInteger minVal) = (SmallInteger minVal + SmallInteger minVal) ).
    self assert: ( (self doMul2_a:SmallInteger maxVal+1) = ((SmallInteger maxVal+1)+(SmallInteger maxVal+1)) ).
    self assert: ( (self doMul2_a:SmallInteger minVal-1) = ((SmallInteger minVal-1)+(SmallInteger minVal-1)) ).

    "
     self basicNew testMul2
    "

    "Modified: / 9.6.1999 / 16:57:20 / cg"
!

testMul3
    self assert: ( (self doMul3_a:0) == 0 ).
    self assert: ( (self doMul3_a:1) == 3 ).
    self assert: ( (self doMul3_a:-1) == -3 ).
    self assert: ( (self doMul3_a:10000) == 30000 ).
    self assert: ( (self doMul3_a:SmallInteger maxVal) = (SmallInteger maxVal + SmallInteger maxVal + SmallInteger maxVal) ).
    self assert: ( (self doMul3_a:SmallInteger minVal) = (SmallInteger minVal + SmallInteger minVal + SmallInteger minVal) ).

    "
     self basicNew testMul3
    "
!

testMul4
    self assert: ( (self doMul4_a:0) == 0 ).
    self assert: ( (self doMul4_a:1) == 4 ).
    self assert: ( (self doMul4_a:-1) == -4 ).
    self assert: ( (self doMul4_a:10000) == 40000 ).
    self assert: ( (self doMul4_a:SmallInteger maxVal) = (SmallInteger maxVal + SmallInteger maxVal + SmallInteger maxVal + SmallInteger maxVal) ).
    self assert: ( (self doMul4_a:SmallInteger minVal) = (SmallInteger minVal + SmallInteger minVal + SmallInteger minVal + SmallInteger minVal) ).
    self assert: ( (self doMul4_a:SmallInteger maxVal+1//4) = (SmallInteger maxVal + 1) ).
    self assert: ( (self doMul4_a:SmallInteger minVal//4) = (SmallInteger minVal) ).

    "
     self basicNew testMul4
    "
!

testMul5
    self assert: ( (self doMul5_a:0) == 0 ).
    self assert: ( (self doMul5_a:1) == 5 ).
    self assert: ( (self doMul5_a:-1) == -5 ).
    self assert: ( (self doMul5_a:10000) == 50000 ).
    self assert: ( (self doMul5_a:SmallInteger maxVal) = (SmallInteger maxVal + SmallInteger maxVal + SmallInteger maxVal + SmallInteger maxVal + SmallInteger maxVal) ).
    self assert: ( (self doMul5_a:SmallInteger minVal) = (SmallInteger minVal + SmallInteger minVal + SmallInteger minVal + SmallInteger minVal + SmallInteger minVal) ).

    "
     self basicNew testMul5
    "
!

testMulM1
    self assert: ( (self doMulM1_a:0) == 0 ).
    self assert: ( (self doMulM1_a:1) == -1 ).
    self assert: ( (self doMulM1_a:-1) == 1 ).
    self assert: ( (self doMulM1_a:10000) == -10000 ).
    self assert: ( (self doMulM1_a:SmallInteger maxVal) = (SmallInteger minVal + 1) ).
    self assert: ( (self doMulM1_a:SmallInteger minVal) = (SmallInteger maxVal + 1) ).

    "
     self basicNew testMulM1
    "
!

testPlus1
    self assert: ( (self doPlus1_a:0) = 1 ).
    self assert: ( (self doPlus1_a:1) = 2 ).
    self assert: ( (self doPlus1_a:-1) = 0 ).
    ExternalAddress pointerSize == 8 ifTrue:[
	self assert: ( (self doPlus1_a:SmallInteger maxVal) = 4611686018427387904).
	self assert: ( (self doPlus1_a:SmallInteger minVal) = -4611686018427387903 ).
    ] ifFalse:[
	self assert: ( (self doPlus1_a:SmallInteger maxVal) = 1073741824).
	self assert: ( (self doPlus1_a:SmallInteger minVal) = -1073741823 ).
    ].

    "
     self basicNew testPlus1
    "
!

testPlus1perform
    self assert: ( (self doPlus1_b:0) = 1 ).
    self assert: ( (self doPlus1_b:1) = 2 ).
    self assert: ( (self doPlus1_b:-1) = 0 ).
    ExternalAddress pointerSize == 8 ifTrue:[
	self assert: ( (self doPlus1_b:SmallInteger maxVal) = 4611686018427387904).
	self assert: ( (self doPlus1_b:SmallInteger minVal) = -4611686018427387903 ).
    ] ifFalse:[
	self assert: ( (self doPlus1_b:SmallInteger maxVal) = 1073741824).
	self assert: ( (self doPlus1_b:SmallInteger minVal) = -1073741823 ).
    ].

    "
     self basicNew testPlus1perform
    "
! !

!IntegerTest methodsFor:'private'!

absPlusOneOf:arg
			|local1|

			local1 := arg.
			^ local1 abs + 1


"
 self absPlusOneOf:-1
 self absPlusOneOf:-1.0
"

    "Created: / 31.10.2000 / 20:21:52 / cg"
!

alwaysTrue
    ^ true.
!

checkIsInteger:arg
    ^ arg isInteger
!

doConstantIntegerShift
    "arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |flags|

    flags := self flagsSlot.

    self alwaysTrue ifFalse:[self halt].
    ^ flags bitShift:-1.

    "
     self testIntegerShifts3
    "

    "Created: / 6.6.1999 / 14:47:51 / cg"
    "Modified: / 9.6.1999 / 17:49:57 / cg"
!

flagsSlot
    "arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    ^ 2.

    "
     self testIntegerShifts3
    "

    "Created: / 6.6.1999 / 14:47:51 / cg"
    "Modified: / 9.6.1999 / 17:49:57 / cg"
!

num_00000000000007FFF
    ^ 16r00000000000007FFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:34:12 / cg"
!

num_00000000000008000
    ^ 16r00000000000008000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:39:32 / cg"
!

num_0000000000000FFFF
    ^ 16r0000000000000FFFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:34:26 / cg"
!

num_00000000000010000
    ^ 16r00000000000010000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:34:31 / cg"
!

num_00000000000100000
    ^ 16r00000000000100000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:34:36 / cg"
!

num_000000000007FFFFF
    ^ 16r000000000007FFFFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:37:48 / cg"
!

num_00000000000800000
    ^ 16r00000000000800000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:39:43 / cg"
!

num_00000000000FFFFFF
    ^ 16r00000000000FFFFFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:37:52 / cg"
!

num_00000000001000000
    ^ 16r00000000001000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:34:42 / cg"
!

num_0000000000FFF0000
    ^ 16r0000000000FFF0000

    "self num_0000000000FFF0000 hexPrintString"

    "Created: / 4.6.1999 / 17:44:26 / cg"
    "Modified: / 4.6.1999 / 18:40:47 / cg"
!

num_00000000010000000
    ^ 16r00000000010000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:34:46 / cg"
!

num_0000000007FFFFFFF
    ^ 16r0000000007FFFFFFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:37:31 / cg"
!

num_00000000080000000
    ^ 16r00000000080000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:39:56 / cg"
!

num_000000000FFFFFFFF
    ^ 16r000000000FFFFFFFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:36:16 / cg"
!

num_00000000100000000
    ^ 16r00000000100000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:34:51 / cg"
!

num_00000001000000000
    ^ 16r00000001000000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:34:57 / cg"
!

num_0000000FFFFFFFFFF
    ^ 16r0000000FFFFFFFFFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:41:08 / cg"
!

num_00000010000000000
    ^ 16r00000010000000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:35:03 / cg"
!

num_00000100000000000
    ^ 16r00000100000000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:35:07 / cg"
!

num_00000FFFFFFFFFF00
    ^ 16r00000FFFFFFFFFF00

    "self num_00000FFFFFFFFFF00"

    "Created: / 4.6.1999 / 17:44:26 / cg"
    "Modified: / 4.6.1999 / 17:46:20 / cg"
!

num_00000FFFFFFFFFF80
    ^ 16r00000FFFFFFFFFF80

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:44:23 / cg"
!

num_00000FFFFFFFFFFC0
    ^ 16r00000FFFFFFFFFFC0

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:44:20 / cg"
!

num_00000FFFFFFFFFFE0
    ^ 16r00000FFFFFFFFFFE0

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:44:16 / cg"
!

num_00000FFFFFFFFFFF0
    ^ 16r00000FFFFFFFFFFF0

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:44:12 / cg"
!

num_00000FFFFFFFFFFF8
    ^ 16r00000FFFFFFFFFFF8

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:44:09 / cg"
!

num_00000FFFFFFFFFFFC
    ^ 16r00000FFFFFFFFFFFC

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:44:05 / cg"
!

num_00000FFFFFFFFFFFE
    ^ 16r00000FFFFFFFFFFFE

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:45:12 / cg"
!

num_00000FFFFFFFFFFFF
    ^ 16r00000FFFFFFFFFFFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:41:22 / cg"
!

num_00001000000000000
    ^ 16r00001000000000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:35:13 / cg"
!

num_00010000000000000
    ^ 16r00010000000000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:35:18 / cg"
!

num_000FFFFFFFFFFFFFF
    ^ 16r000FFFFFFFFFFFFFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:41:26 / cg"
!

num_00100000000000000
    ^ 16r00100000000000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:35:22 / cg"
!

num_01000000000000000
    ^ 16r01000000000000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:35:27 / cg"
!

num_0FFFFFFFFFFFFFFFF
    ^ 16r0FFFFFFFFFFFFFFFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:41:30 / cg"
!

num_10000000000000000
    ^ 16r10000000000000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 15:35:32 / cg"
!

num_16r80000000
    ^ 16r80000000
!

num_1FFFFFFFFFFFFFFFF
    ^ 16r1FFFFFFFFFFFFFFFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:41:51 / cg"
!

num_20000000000000000
    ^ 16r20000000000000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:40:26 / cg"
!

num_3FFFFFFFFFFFFFFFF
    ^ 16r3FFFFFFFFFFFFFFFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:42:07 / cg"
!

num_40000000000000000
    ^ 16r40000000000000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:40:29 / cg"
!

num_7FFFFFFFFFFFFFFFF
    ^ 16r7FFFFFFFFFFFFFFFF

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:42:24 / cg"
!

num_80000000000000000
    ^ 16r80000000000000000

    "Modified: / 4.6.1999 / 15:29:31 / cg"
    "Created: / 4.6.1999 / 17:40:33 / cg"
!

num_smallInt_maxVal
    ^ SmallInteger maxVal

    "self num_smallInt_maxVal"

    "Modified: / 4.6.1999 / 17:33:22 / cg"
!

num_smallInt_minVal
    ^ SmallInteger minVal

    "self num_smallInt_minVal"

    "Created: / 4.6.1999 / 16:26:05 / cg"
    "Modified: / 4.6.1999 / 17:34:31 / cg"
! !

!IntegerTest methodsFor:'tests'!

doCompare:a againstEqual:b
    self assert:(a < b) not.
    self assert:(a <= b).
    self assert:(a = b).
    self assert:(a ~= b) not.
    self assert:(a > b) not.
    self assert:(a >= b).

    self assert:(a perform:#<   with:b) not.
    self assert:(a perform:#<=  with:b).
    self assert:(a perform:#=   with:b).
    self assert:(a perform:#~=  with:b) not.
    self assert:(a perform:#>   with:b) not.
    self assert:(a perform:#>=  with:b).

    "
     self basicNew doCompare:12 againstEqual:12
    "
!

doCompare:a againstGreater:b
    self assert:(a < b).
    self assert:(a <= b).
    self assert:(a = b) not.
    self assert:(a ~= b).
    self assert:(a == b) not.
    self assert:(a ~~ b).
    self assert:(a > b) not.
    self assert:(a >= b) not.

    self assert:(a perform:#<   with:b).
    self assert:(a perform:#<=  with:b).
    self assert:(a perform:#=   with:b) not.
    self assert:(a perform:#~=  with:b).
    self assert:(a perform:#==  with:b) not.
    self assert:(a perform:#~~  with:b).
    self assert:(a perform:#>   with:b) not.
    self assert:(a perform:#>=  with:b) not.

    "
     self basicNew doCompare:12 againstGreater:16r80000000
    "
!

doTestAll
    "general conversion & arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    self testInteger1.
    self testILC.
    self testSmallIntegerArithmetic.
    self testLiteralNumbers.
    self testLargeAddition.
    self testLargeMultiplication.
    self testLargeDivision.
    self testLargeBitOperations.
    self testIntegerShifts.
    self testEncodeDecode.
    self testIntegerMisc.
    self testInline1

    "
     self basicNew doTestAll
    "

    "Modified: / 31.10.2000 / 20:23:20 / cg"
!

testBinco
     self assert: (10 binomialCoefficient:5) = (10 factorial / (5 factorial * 5 factorial)).
     self assert: (100 binomialCoefficient:78) = (100 factorial / (78 factorial * (100-78) factorial)).
     self assert: (1000 binomialCoefficient:5) = (1000 factorial / (5 factorial * (1000-5) factorial)).
     self assert: (10000 binomialCoefficient:78) = (10000 factorial / (78 factorial * (10000-78) factorial)).

    "
     self basicNew testBinco
    "
!

testByteSwap
    "/ <testedMethods: #( (Integer >> #byteSwapped32) (Integer >> #byteSwapped64)) >

    self assert:(16r1122 byteSwapped16) = 16r2211.
    self assert:(16r2211 byteSwapped16) = 16r1122.

    self assert:(16r11223344 byteSwapped32) = 16r44332211.
    self assert:(16r44332211 byteSwapped32) = 16r11223344.

    self assert:(16r11223344 byteSwapped64) = 16r4433221100000000.
    self assert:(16r44332211 byteSwapped64) = 16r1122334400000000.

    self assert:(16r8877665544332211 byteSwapped64) = 16r1122334455667788.
    self assert:(16r1122334455667788 byteSwapped64) = 16r8877665544332211.

    "/ higher bits are ignored!!
    self assert:(16r33441122 byteSwapped16) = 16r2211.

    self assert:(16r9911223344 byteSwapped32) = 16r44332211.
    self assert:(16r8877665544332211 byteSwapped32) = 16r11223344.
    self assert:(16r998877665544332211 byteSwapped64) = 16r1122334455667788.
    self assert:(16r991122334455667788 byteSwapped64) = 16r8877665544332211.

    "
     self basicNew testByteSwap
    "
!

testComparing
    |a b|

    a := 12.
    b := 16r80000000.
    self doCompare:a againstGreater:b.

    a := 12.
    b := 16r80000000.
    self doCompare:a againstGreater:16r80000000.

    a := 0.
    self doCompare:a againstGreater:16r80000000.

    a := -1.
    self doCompare:a againstGreater:16r80000000.

    a := 16r-80000000.
    self doCompare:a againstGreater:16r80000000.

    a := 16r-40000000.
    self doCompare:a againstGreater:16r80000000.

    a := 16r-40000000.
    self doCompare:a againstGreater:16r40000000.

    a := 16r-3FFFFFFF.
    self doCompare:a againstGreater:16r3FFFFFFF.

    a := 16r-40000000.
    self doCompare:a againstGreater:16r3FFFFFFF.

    a := 16r-3FFFFFFF.
    self doCompare:a againstGreater:16r40000000.

    "/ smallint-largeInt boundaries

    a := 16r3FFFFFFE.
    self doCompare:a againstEqual:16r3FFFFFFE.

    a := 16r3FFFFFFE.
    self doCompare:a againstGreater:16r3FFFFFFF.

    a := 16r3FFFFFFE.
    self doCompare:a againstGreater:16r40000000.

    a := 16r3FFFFFFE.
    self doCompare:a againstGreater:16r80000000.

    a := 16r3FFFFFFE.
    self doCompare:a againstGreater:16rFFFFFFFF.

    a := 16r3FFFFFFF.
    self doCompare:a againstEqual:16r3FFFFFFF.

    a := 16r3FFFFFFF.
    self doCompare:a againstGreater:16r40000000.

    a := 16r3FFFFFFF.
    self doCompare:a againstGreater:16r80000000.

    a := 16r3FFFFFFF.
    self doCompare:a againstGreater:16rFFFFFFFF.

    a := 16r40000000.
    self doCompare:a againstEqual:16r40000000.

    a := 16r40000000.
    self doCompare:a againstGreater:16r80000000.

    a := 16r40000000.
    self doCompare:a againstGreater:16rFFFFFFFF.

    a := 16r7FFFFFFF.
    self doCompare:a againstEqual:16r7FFFFFFF.

    a := 16r7FFFFFFF.
    self doCompare:a againstGreater:16r80000000.

    a := 16r7FFFFFFF.
    self doCompare:a againstGreater:16rFFFFFFFF.

    a := 16r80000000.
    self doCompare:a againstEqual:16r80000000.

    a := 16r80000000.
    self doCompare:a againstGreater:16rFFFFFFFF.

    a := 16rFFFFFFFF.
    self doCompare:a againstEqual:16rFFFFFFFF.

    a := 16rFFFFFFFF.
    self doCompare:a againstGreater:16r100000000.

    "
     self basicNew testComparing
    "
!

testConstants
    |t|

    self assert:((t := self num_16r80000000) > 0).
    self assert:((t := self num_16r80000000) = 16r80000000).

    "
     self basicNew testConstants
    "
!

testDivision1
    |a b op rslt|

    "/ 10 divMod:3       -> #(3 1)   because 3*3 + 1 = 10
    "/ 10 divMod:-3      -> #(-4 -2) because -4*-3 + (-2) = 10
    "/ -10 divMod:3      -> #(-4 2)  because -4*3 + 3 = -10   
    "/ -10 divMod:-3     -> #(3 -1)  because -3*3 + (-1) = -10

    #(
        ((10 3)      // 3            )
        ((10 -3)     // -4           )
        ((-10 3)     // -4           )
        ((-10 -3)    // 3            )

        ((10 3)      \\ 1            )
        ((10 -3)     \\ -2           )
        ((-10 3)     \\ 2            )
        ((-10 -3)    \\ -1           )

        ((10 3)      divMod: (3 1)   )
        ((10 -3)     divMod: (-4 -2) )
        ((-10 3)     divMod: (-4 2)  )
        ((-10 -3)    divMod: (3 -1)  )

        ((100000000000000000000 3)      // 33333333333333333333            )
        ((100000000000000000000 -3)     // -33333333333333333334           )
        ((-100000000000000000000 3)     // -33333333333333333334           )
        ((-100000000000000000000 -3)    // 33333333333333333333            )

        ((100000000000000000000 3)      \\ 1            )
        ((100000000000000000000 -3)     \\ -2           )
        ((-100000000000000000000 3)     \\ 2            )
        ((-100000000000000000000 -3)    \\ -1           )

        ((100000000000000000000 3)      divMod: (33333333333333333333 1)   )
        ((100000000000000000000 -3)     divMod: (-33333333333333333334 -2) )
        ((-100000000000000000000 3)     divMod: (-33333333333333333334 2)  )
        ((-100000000000000000000 -3)    divMod: (33333333333333333333 -1)  )
    ) do:[:each |
        |inValues rcvr arg op expectedRslt gotRslt|

        inValues := each first.
        op := each second.
        expectedRslt := each third.
        rcvr := inValues first.
        arg := inValues second.
        gotRslt := rcvr perform:op with:arg.
        self 
            assert:(gotRslt = expectedRslt) 
            description:('%1 %2 %3 - expected:%4 got:%5' 
                            bindWith:rcvr with:op with:arg
                            with:expectedRslt with:gotRslt).
    ].
        
    op := #//.
    a := -1.
    b := 8.

    "/ to check for both compiler-constant folded and actually computed
    "/ values, these checks are done also with #perform.

    self assert:(-1 // 8 == -1).
    self assert:(a // 8 == -1).
    self assert:(-1 // b == -1).
    self assert:(a // b == -1).

    self assert:((rslt := -1 perform:op with: 8) == -1).
    self assert:((rslt := a perform:op with: 8) == -1).
    self assert:((rslt := -1 perform:op with: b) == -1).
    self assert:((rslt := a perform:op with: b) == -1).

    self assert:((rslt := -1 perform:#// with: 8) == -1).
    self assert:((rslt := a perform:#// with: 8) == -1).
    self assert:((rslt := -1 perform:#// with: b) == -1).
    self assert:((rslt := a perform:#// with: b) == -1).

    a := 1.
    b := -8.
    self assert:(1 // -8 == -1).
    self assert:(a // -8 == -1).
    self assert:(1 // b == -1).
    self assert:(a // b == -1).

    self assert:((rslt := 1 perform:op with: -8) == -1).
    self assert:((rslt := a perform:op with: -8) == -1).
    self assert:((rslt := 1 perform:op with: b) == -1).
    self assert:((rslt := a perform:op with: b) == -1).

    self assert:((rslt := 1 perform:#// with: -8) == -1).
    self assert:((rslt := a perform:#// with: -8) == -1).
    self assert:((rslt := 1 perform:#// with: b) == -1).
    self assert:((rslt := a perform:#// with: b) == -1).

    a := -1.
    b := -8.
    self assert:(-1 // -8 == 0).
    self assert:(a // -8 == 0).
    self assert:(-1 // b == 0).
    self assert:(a // b == 0).

    self assert:((rslt := -1 perform:op with: -8) == 0).
    self assert:((rslt := a perform:op with: -8) == 0).
    self assert:((rslt := -1 perform:op with: b) == 0).
    self assert:((rslt := a perform:op with: b) == 0).

    self assert:((rslt := -1 perform:#// with: -8) == 0).
    self assert:((rslt := a perform:#// with: -8) == 0).
    self assert:((rslt := -1 perform:#// with: b) == 0).
    self assert:((rslt := a perform:#// with: b) == 0).

    a := 1.
    b := 8.
    self assert:(1 // 8 == 0).
    self assert:(a // 8 == 0).
    self assert:(1 // b == 0).
    self assert:(a // b == 0).

    self assert:((rslt := 1 perform:op with: 8) == 0).
    self assert:((rslt := a perform:op with: 8) == 0).
    self assert:((rslt := 1 perform:op with: b) == 0).
    self assert:((rslt := a perform:op with: b) == 0).

    self assert:((rslt := 1 perform:#// with: 8) == 0).
    self assert:((rslt := a perform:#// with: 8) == 0).
    self assert:((rslt := 1 perform:#// with: b) == 0).
    self assert:((rslt := a perform:#// with: b) == 0).

    a := -16.
    b := 8.
    self assert:(-16 // 8 == -2).
    self assert:(a // 8 == -2).
    self assert:(-16 // b == -2).
    self assert:(a // b == -2).

    self assert:((rslt := -16 perform:op with: 8) == -2).
    self assert:((rslt := a perform:op with: 8) == -2).
    self assert:((rslt := -16 perform:op with: b) == -2).
    self assert:((rslt := a perform:op with: b) == -2).

    self assert:((rslt := -16 perform:#// with: 8) == -2).
    self assert:((rslt := a perform:#// with: 8) == -2).
    self assert:((rslt := -16 perform:#// with: b) == -2).
    self assert:((rslt := a perform:#// with: b) == -2).

    a := 16.
    b := -8.
    self assert:(16 // -8 == -2).
    self assert:(a // -8 == -2).
    self assert:(16 // b == -2).
    self assert:(a // b == -2).

    self assert:((rslt := 16 perform:op with: -8) == -2).
    self assert:((rslt := a perform:op with: -8) == -2).
    self assert:((rslt := 16 perform:op with: b) == -2).
    self assert:((rslt := a perform:op with: b) == -2).

    self assert:((rslt := 16 perform:#// with: -8) == -2).
    self assert:((rslt := a perform:#// with: -8) == -2).
    self assert:((rslt := 16 perform:#// with: b) == -2).
    self assert:((rslt := a perform:#// with: b) == -2).

    a := -16.
    b := -8.
    self assert:(-16 // -8 == 2).
    self assert:(a // -8 == 2).
    self assert:(-16 // b == 2).
    self assert:(a // b == 2).

    self assert:((rslt := -16 perform:op with: -8) == 2).
    self assert:((rslt := a perform:op with: -8) == 2).
    self assert:((rslt := -16 perform:op with: b) == 2).
    self assert:((rslt := a perform:op with: b) == 2).

    self assert:((rslt := -16 perform:#// with: -8) == 2).
    self assert:((rslt := a perform:#// with: -8) == 2).
    self assert:((rslt := -16 perform:#// with: b) == 2).
    self assert:((rslt := a perform:#// with: b) == 2).

    a := 16.
    b := 8.
    self assert:(16 // 8 == 2).
    self assert:(a // 8 == 2).
    self assert:(16 // b == 2).
    self assert:(a // b == 2).

    self assert:((rslt := 16 perform:op with: 8) == 2).
    self assert:((rslt := a perform:op with: 8) == 2).
    self assert:((rslt := 16 perform:op with: b) == 2).
    self assert:((rslt := a perform:op with: b) == 2).

    self assert:((rslt := 16 perform:#// with: 8) == 2).
    self assert:((rslt := a perform:#// with: 8) == 2).
    self assert:((rslt := 16 perform:#// with: b) == 2).
    self assert:((rslt := a perform:#// with: b) == 2).

    op := #quo:.
    a := -1.
    b := 8.
    self assert:((rslt := -1 quo: 8) == 0).
    self assert:((rslt := a quo: 8) == 0).
    self assert:((rslt := -1 quo: b) == 0).
    self assert:((rslt := a quo: b) == 0).

    self assert:((rslt := -1 perform:op with: -8) == 0).
    self assert:((rslt := a perform:op with: -8) == 0).
    self assert:((rslt := -1 perform:op with: b) == 0).
    self assert:((rslt := a perform:op with: b) == 0).

    self assert:((rslt := -1 perform:#quo: with: -8) == 0).
    self assert:((rslt := a perform:#quo: with: -8) == 0).
    self assert:((rslt := -1 perform:#quo: with: b) == 0).
    self assert:((rslt := a perform:#quo: with: b) == 0).

    a := 1.
    b := -8.
    self assert:((rslt := 1 quo: -8) == 0).
    self assert:((rslt := a quo: -8) == 0).
    self assert:((rslt := 1 quo: b) == 0).
    self assert:((rslt := a quo: b) == 0).

    self assert:((rslt := 1 perform:op with: -8) == 0).
    self assert:((rslt := a perform:op with: -8) == 0).
    self assert:((rslt := 1 perform:op with: b) == 0).
    self assert:((rslt := a perform:op with: b) == 0).

    self assert:((rslt := 1 perform:#quo: with: -8) == 0).
    self assert:((rslt := a perform:#quo: with: -8) == 0).
    self assert:((rslt := 1 perform:#quo: with: b) == 0).
    self assert:((rslt := a perform:#quo: with: b) == 0).

    a := -1.
    b := -8.
    self assert:((rslt := -1 quo: -8) == 0).
    self assert:((rslt := a quo: -8) == 0).
    self assert:((rslt := -1 quo: b) == 0).
    self assert:((rslt := a quo: b) == 0).

    self assert:((rslt := -1 perform:op with: -8) == 0).
    self assert:((rslt := a perform:op with: -8) == 0).
    self assert:((rslt := -1 perform:op with: b) == 0).
    self assert:((rslt := a perform:op with: b) == 0).

    self assert:((rslt := -1 perform:#quo: with: -8) == 0).
    self assert:((rslt := a perform:#quo: with: -8) == 0).
    self assert:((rslt := -1 perform:#quo: with: b) == 0).
    self assert:((rslt := a perform:#quo: with: b) == 0).

    a := 1.
    b := 8.
    self assert:((rslt := 1 quo: 8) == 0).
    self assert:((rslt := a quo: 8) == 0).
    self assert:((rslt := 1 quo: b) == 0).
    self assert:((rslt := a quo: b) == 0).

    self assert:((rslt := 1 perform:op with: 8) == 0).
    self assert:((rslt := a perform:op with: 8) == 0).
    self assert:((rslt := 1 perform:op with: b) == 0).
    self assert:((rslt := a perform:op with: b) == 0).

    self assert:((rslt := 1 perform:#quo: with: 8) == 0).
    self assert:((rslt := a perform:#quo: with: 8) == 0).
    self assert:((rslt := 1 perform:#quo: with: b) == 0).
    self assert:((rslt := a perform:#quo: with: b) == 0).

    a := -16.
    b := 8.
    self assert:((rslt := -16 quo: 8) == -2).
    self assert:((rslt := a quo: 8) == -2).
    self assert:((rslt := -16 quo: b) == -2).
    self assert:((rslt := a quo: b) == -2).

    self assert:((rslt := -16 perform:op with: 8) == -2).
    self assert:((rslt := a perform:op with: 8) == -2).
    self assert:((rslt := -16 perform:op with: b) == -2).
    self assert:((rslt := a perform:op with: b) == -2).

    self assert:((rslt := -16 perform:#quo: with: 8) == -2).
    self assert:((rslt := a perform:#quo: with: 8) == -2).
    self assert:((rslt := -16 perform:#quo: with: b) == -2).
    self assert:((rslt := a perform:#quo: with: b) == -2).

    a := 16.
    b := -8.
    self assert:((rslt := 16 quo: -8) == -2).
    self assert:((rslt := a quo: -8) == -2).
    self assert:((rslt := 16 quo: b) == -2).
    self assert:((rslt := a quo: b) == -2).

    self assert:((rslt := 16 perform:op with: -8) == -2).
    self assert:((rslt := a perform:op with: -8) == -2).
    self assert:((rslt := 16 perform:op with: b) == -2).
    self assert:((rslt := a perform:op with: b) == -2).

    self assert:((rslt := 16 perform:#quo: with: -8) == -2).
    self assert:((rslt := a perform:#quo: with: -8) == -2).
    self assert:((rslt := 16 perform:#quo: with: b) == -2).
    self assert:((rslt := a perform:#quo: with: b) == -2).

    a := -16.
    b := -8.
    self assert:((rslt := -16 quo: -8) == 2).
    self assert:((rslt := a quo: -8) == 2).
    self assert:((rslt := -16 quo: b) == 2).
    self assert:((rslt := a quo: b) == 2).

    self assert:((rslt := -16 perform:op with: -8) == 2).
    self assert:((rslt := a perform:op with: -8) == 2).
    self assert:((rslt := -16 perform:op with: b) == 2).
    self assert:((rslt := a perform:op with: b) == 2).

    self assert:((rslt := -16 perform:#quo: with: -8) == 2).
    self assert:((rslt := a perform:#quo: with: -8) == 2).
    self assert:((rslt := -16 perform:#quo: with: b) == 2).
    self assert:((rslt := a perform:#quo: with: b) == 2).

    a := 16.
    b := 8.
    self assert:((rslt := 16 quo: 8) == 2).
    self assert:((rslt := a quo: 8) == 2).
    self assert:((rslt := 16 quo: b) == 2).
    self assert:((rslt := a quo: b) == 2).

    self assert:((rslt := 16 perform:op with: 8) == 2).
    self assert:((rslt := a perform:op with: 8) == 2).
    self assert:((rslt := 16 perform:op with: b) == 2).
    self assert:((rslt := a perform:op with: b) == 2).

    self assert:((rslt := 16 perform:#quo: with: 8) == 2).
    self assert:((rslt := a perform:#quo: with: 8) == 2).
    self assert:((rslt := 16 perform:#quo: with: b) == 2).
    self assert:((rslt := a perform:#quo: with: b) == 2).

    "
     self basicNew testDivision
    "
!

testDivision2
    |nr|
    
    2 to:17 do:[:m |
        nr := 1.
        1 to:1000 do:[:n |
            nr := nr * m
        ].
        1 to:1000 do:[:n |
            nr := nr / m
        ].
        self assert:(nr == 1).
    ].

    "
     self new testDivision2
    "
!

testDivision3
    |nr|
    
    #( 
        16r00000000000000003F 
        16r000000000000003FFF 
        16r0000000000003FFFFF 
        16r00000000003FFFFFFF 
        16r000000003FFFFFFFFF
        16r0000003FFFFFFFFFFF
        16r00003FFFFFFFFFFFFF
        16r003FFFFFFFFFFFFFFF
        16r3FFFFFFFFFFFFFFFFF

        16r000000000000000040 
        16r0000000000000040FF 
        16r00000000000040FFFF 
        16r000000000040FFFFFF 
        16r0000000040FFFFFFFF
        16r00000040FFFFFFFFFF
        16r000040FFFFFFFFFFFF
        16r0040FFFFFFFFFFFFFF
        16r40FFFFFFFFFFFFFFFF

        16r00000000000000007F 
        16r000000000000007FFF 
        16r0000000000007FFFFF 
        16r00000000007FFFFFFF 
        16r000000007FFFFFFFFF
        16r0000007FFFFFFFFFFF
        16r00007FFFFFFFFFFFFF
        16r007FFFFFFFFFFFFFFF
        16r7FFFFFFFFFFFFFFFFF

        16r0000000000000000FF 
        16r00000000000000FFFF 
        16r000000000000FFFFFF 
        16r0000000000FFFFFFFF 
        16r00000000FFFFFFFFFF
        16r000000FFFFFFFFFFFF
        16r0000FFFFFFFFFFFFFF
        16r00FFFFFFFFFFFFFFFF
        16rFFFFFFFFFFFFFFFFFF
    ) do:[:m |
        "/ Transcript showCR:m.
        nr := 1.
        1 to:100 do:[:n |
            nr := nr * m
        ].
        1 to:100 do:[:n |
            nr := nr / m
        ].
        self assert:(nr == 1) description:('failed in division of ',m printString).
    ].

    "
     self new testDivision3
     Time millisecondsToRun:[ self new testDivision3 ] 14440
     MessageTally spyOn:[ self new testDivision3 ] 
    "
!

testDivision4
    "boundary conditions, wehre smallInts should be returned"

    |n1 n2 r|
    
    n1 := 1152921504606846976.  "/ 16r1000000000000000
    n2 := -1073741824.          "/ 16r40000000
    r := n1 / n2.
    self assert:(r = -1073741824).
    self assert:(r class == SmallInteger).
    self assert:(r == -1073741824).

    n1 := 1152921504606846976.  "/ 16r1000000000000000
    n2 := 1073741824.           "/ 16r40000000
    r := n1 / n2.
    self assert:(r = 1073741824).
    SmallInteger maxBytes == 8 ifTrue:[
        self assert:(r class == SmallInteger).
        self assert:(r == 1073741824).
    ].

    n1 := 1152921504606846976.  "/ 16r1000000000000000
    n2 := -536870912.           "/ 16r20000000
    r := n1 / n2.
    self assert:(r = -2147483648).
    SmallInteger maxBytes == 8 ifTrue:[
        self assert:(r class == SmallInteger).
        self assert:(r == -2147483648).
    ].

    n1 := 1152921504606846976.  "/ 16r1000000000000000
    n2 := 536870912.            "/ 16r20000000
    r := n1 / n2.
    self assert:(r = 2147483648).
    SmallInteger maxBytes == 8 ifTrue:[
        self assert:(r class == SmallInteger).
        self assert:(r == 2147483648).
    ].

    n1 := 1152921504606846976.  "/ 16r1000000000000000
    n2 := -2147483648.          "/ 16r80000000
    r := n1 / n2.
    self assert:(r = -536870912).
    self assert:(r class == SmallInteger).
    self assert:(r == -536870912).

    n1 := 1152921504606846976.  "/ 16r1000000000000000
    n2 := 2147483648.           "/ 16r80000000
    r := n1 / n2.
    self assert:(r = 536870912).
    self assert:(r class == SmallInteger).
    self assert:(r == 536870912).

    n1 := 21267647932558653966460912964485513216.  "/ 16r10000000000000000000000000000000
    n2 := -4611686018427387904.                    "/ 16r4000000000000000
    r := n1 / n2.
    self assert:(r = -4611686018427387904).
    SmallInteger maxBytes == 8 ifTrue:[
        self assert:(r class == SmallInteger).
        self assert:(r == -4611686018427387904).
    ].

    n1 := 21267647932558653966460912964485513216.  "/ 16r10000000000000000000000000000000
    n2 := 4611686018427387904.                     "/ 16r4000000000000000
    r := n1 / n2.
    self assert:(r = 4611686018427387904).

    n1 := 21267647932558653966460912964485513216.  "/ 16r10000000000000000000000000000000
    n2 := -2305843009213693952.                    "/ 16r2000000000000000
    r := n1 / n2.
    self assert:(r = -9223372036854775808).

    n1 := 21267647932558653966460912964485513216.  "/ 16r10000000000000000000000000000000
    n2 := 2305843009213693952.                     "/ 16r2000000000000000
    r := n1 / n2.
    self assert:(r = 9223372036854775808).

    n1 := 21267647932558653966460912964485513216.  "/ 16r10000000000000000000000000000000
    n2 := -9223372036854775808.                    "/ 16r8000000000000000
    r := n1 / n2.
    self assert:(r = -2305843009213693952).
    SmallInteger maxBytes == 8 ifTrue:[
        self assert:(r class == SmallInteger).
        self assert:(r == -2305843009213693952).
    ].

    n1 := 21267647932558653966460912964485513216.  "/ 16r10000000000000000000000000000000
    n2 := 9223372036854775808.                     "/ 16r8000000000000000
    r := n1 / n2.
    self assert:(r = 2305843009213693952).
    SmallInteger maxBytes == 8 ifTrue:[
        self assert:(r class == SmallInteger).
        self assert:(r == 2305843009213693952).
    ].

    "
     self new testDivision4
    "

    "Created: / 26-02-2016 / 20:21:47 / cg"
!

testEncodeDecode
    self assert:(1 encodeAsBCD hexPrintString = '1').
    self assert:(12 encodeAsBCD hexPrintString = '12').
    self assert:(123 encodeAsBCD hexPrintString = '123').
    self assert:(1234 encodeAsBCD hexPrintString = '1234').
    self assert:(12345 encodeAsBCD hexPrintString = '12345').
    self assert:(123456 encodeAsBCD hexPrintString = '123456').
    self assert:(1234567 encodeAsBCD hexPrintString = '1234567').
    self assert:(12345678 encodeAsBCD hexPrintString = '12345678').
    self assert:(123456789 encodeAsBCD hexPrintString = '123456789').
    self assert:(1234567890 encodeAsBCD hexPrintString = '1234567890').
    self assert:(12345678901 encodeAsBCD hexPrintString = '12345678901').
    self assert:(123456789012 encodeAsBCD hexPrintString = '123456789012').
    self assert:(1234567890123 encodeAsBCD hexPrintString = '1234567890123').
    self assert:(12345678901234 encodeAsBCD hexPrintString = '12345678901234').
    self assert:(123456789012345 encodeAsBCD hexPrintString = '123456789012345').
    self assert:(1234567890123456 encodeAsBCD hexPrintString = '1234567890123456').
    self assert:(12345678901234567 encodeAsBCD hexPrintString = '12345678901234567').
    self assert:(123456789012345678 encodeAsBCD hexPrintString = '123456789012345678').
    self assert:(1234567890123456789 encodeAsBCD hexPrintString = '1234567890123456789').
    self assert:(12345678901234567890 encodeAsBCD hexPrintString = '12345678901234567890').
    self assert:(4611686018427387902 encodeAsBCD hexPrintString = '4611686018427387902').
    self assert:(4611686018427387903 encodeAsBCD hexPrintString = '4611686018427387903').
    self assert:(4611686018427387904 encodeAsBCD hexPrintString = '4611686018427387904').

    self assert:(16r1 decodeFromBCD = 1).
    self assert:(16r12 decodeFromBCD = 12).
    self assert:(16r123 decodeFromBCD = 123).
    self assert:(16r1234 decodeFromBCD = 1234).
    self assert:(16r12345 decodeFromBCD = 12345).
    self assert:(16r123456 decodeFromBCD = 123456).
    self assert:(16r1234567 decodeFromBCD = 1234567).
    self assert:(16r12345678 decodeFromBCD = 12345678).
    self assert:(16r123456789 decodeFromBCD = 123456789).
    self assert:(16r1234567890 decodeFromBCD = 1234567890).
    self assert:(16r12345678901 decodeFromBCD = 12345678901).
    self assert:(16r123456789012 decodeFromBCD = 123456789012).
    self assert:(16r1000000000000 decodeFromBCD = 1000000000000).
    self assert:(16r0000500000000 decodeFromBCD = 500000000).
    self assert:(16r1234500000000 decodeFromBCD = 1234500000000).
    self assert:(16r1234567890000 decodeFromBCD = 1234567890000).

    self assert:(16r1234567890123 decodeFromBCD = 1234567890123).
    self assert:(16r12345678901234 decodeFromBCD = 12345678901234).
    self assert:(16r123456789012345 decodeFromBCD = 123456789012345).
    self assert:(16r1234567890123456 decodeFromBCD = 1234567890123456).
    self assert:(16r12345678901234567 decodeFromBCD = 12345678901234567).
    self assert:(16r123456789012345678 decodeFromBCD = 123456789012345678).
    self assert:(16r1234567890123456789 decodeFromBCD = 1234567890123456789).
    self assert:(16r12345678901234567890 decodeFromBCD = 12345678901234567890).
    self assert:(16r4611686018427387902 decodeFromBCD = 4611686018427387902).
    self assert:(16r4611686018427387903 decodeFromBCD = 4611686018427387903).
    self assert:(16r4611686018427387904 decodeFromBCD = 4611686018427387904).

    "
     self basicNew testEncodeDecode
    "

    "Modified: / 26.10.1999 / 22:01:35 / stefan"
!

testFactorial
    "/ <testedMethods: #( (Integer >> #factorial) (Integer >> #*) ) >

    self assert:(1 factorial = 1).
    self assert:(2 factorial = 2).
    self assert:(10 factorial = 3628800).
    self assert:(11 factorial = 39916800).
    self assert:(12 factorial = 479001600).
    self assert:(13 factorial digitBytes = #[0 204 40 115 1]).
    self assert:(13 factorial = 6227020800).
    self assert:(14 factorial digitBytes = #[0 40 59 76 20]).
    self assert:(14 factorial = 87178291200).
    self assert:(15 factorial digitBytes = #[0 88 119 119 48 1]).
    self assert:(15 factorial = 1307674368000).
    self assert:(16 factorial digitBytes = #[0 128 117 119 7 19]).
    self assert:(16 factorial = 20922789888000).
    self assert:(17 factorial digitBytes = #[0 128 205 238 126 67 1]).
    self assert:(17 factorial = 355687428096000).
    self assert:(18 factorial digitBytes = #[0 0 115 202 236 190 22]).
    self assert:(18 factorial = 6402373705728000).
    self assert:(19 factorial digitBytes = #[0 0 137 6 147 43 176 1]).
    self assert:(19 factorial = 121645100408832000).
    self assert:(20 factorial digitBytes = #[0 0 180 130 124 103 195 33]).
    self assert:(20 factorial = 2432902008176640000).
    self assert:(50 factorial = 30414093201713378043612608166064768844377641568960512000000000000).

    "
     self basicNew testFactorial
    "

    "Created: / 24-04-2010 / 13:52:23 / cg"
    "Modified: / 26-02-2016 / 15:43:16 / cg"
!

testGCD
    "/ <testedMethods: #( (Integer >> #gcd:) ) >

    self assert:(9 gcd:6) = 3.
    self assert:(6 gcd:9) = 3.
    self assert:(2 gcd:0) = 2.
    self assert:(0 gcd:2) = 2.
    self assert:(20 factorial gcd:(5*6*7)) = (5*6*7).
    self assert:(20 factorial gcd:(20 factorial / 20)) = (19 factorial).

    "
     self basicNew testGCD
    "

    "Created: / 27-04-2010 / 09:49:31 / cg"
!

testHighBitLowBit
    self assert:( 2r0 highBit == 0).
    self assert:( 2r1 highBit == 1).
    self assert:( 2r10 highBit == 2).  
    self assert:( 2r100 highBit == 3).  
    self assert:( 2r1000 highBit == 4).  
    self assert:( 16r10 highBit == 5).
    self assert:( 16r100 highBit == 9).
    self assert:( 16r1000 highBit == 13).
    self assert:( 16r10000 highBit == 17).
    self assert:( 16r100000 highBit == 21).
    self assert:( 16r1000000 highBit == 25).
    self assert:( 16r10000000 highBit == 29).
    self assert:( 16r100000000 highBit == 33).
    self assert:( 16r1000000000 highBit == 37).
    self assert:( 16r10000000000 highBit == 41).
    self assert:( 16r100000000000 highBit == 45).
    self assert:( 16r1000000000000 highBit == 49).
    self assert:( 16r10000000000000 highBit == 53).
    self assert:( 16r100000000000000 highBit == 57).
    self assert:( 16r1000000000000000 highBit == 61).
    self assert:( 16r10000000000000000 highBit == 65).
    self assert:( (1 bitShift:1000) highBit == 1001).

    self assert:( 2r0 lowBit == 0).
    self assert:( 2r1 lowBit == 1).
    self assert:( 2r10 lowBit == 2).  
    self assert:( 2r100 lowBit == 3).  
    self assert:( 2r1000 lowBit == 4).  
    self assert:( 16r10 lowBit == 5).
    self assert:( 16r100 lowBit == 9).
    self assert:( 16r1000 lowBit == 13).
    self assert:( 16r10000 lowBit == 17).
    self assert:( 16r100000 lowBit == 21).
    self assert:( 16r1000000 lowBit == 25).
    self assert:( 16r10000000 lowBit == 29).
    self assert:( 16r100000000 lowBit == 33).
    self assert:( 16r1000000000 lowBit == 37).
    self assert:( 16r10000000000 lowBit == 41).
    self assert:( 16r100000000000 lowBit == 45).
    self assert:( 16r1000000000000 lowBit == 49).
    self assert:( 16r10000000000000 lowBit == 53).
    self assert:( 16r100000000000000 lowBit == 57).
    self assert:( 16r1000000000000000 lowBit == 61).
    self assert:( 16r10000000000000000 lowBit == 65).
    self assert:( (1 bitShift:1000) lowBit == 1001).
    
    self assert:(( 2r1 bitOr: 16r10000000000) lowBit = 1).
    self assert:(( 2r10 bitOr: 16r10000000000) lowBit = 2).  
    self assert:(( 2r100 bitOr: 16r10000000000) lowBit = 3).  
    self assert:(( 2r1000 bitOr: 16r10000000000) lowBit = 4).  
    self assert:(( 16r10 bitOr: 16r10000000000) lowBit = 5).
    self assert:(( 16r100 bitOr: 16r10000000000) lowBit = 9).
    self assert:(( 16r1000 bitOr: 16r10000000000) lowBit = 13).
    self assert:(( 16r10000 bitOr: 16r10000000000) lowBit = 17).
    self assert:(( 16r100000 bitOr: 16r10000000000) lowBit = 21).
    self assert:(( 16r1000000 bitOr: 16r10000000000) lowBit = 25).
    self assert:(( 16r10000000 bitOr: 16r10000000000) lowBit = 29).
    self assert:(( 16r100000000 bitOr: 16r10000000000) lowBit = 33).
    self assert:(( 16r1000000000 bitOr: 16r10000000000) lowBit = 37).
    self assert:(( 16r10000000000 bitOr: 16r10000000000) lowBit = 41).
    self assert:(( 16r100000000000 bitOr: 16r100000000000) lowBit = 45).
    self assert:(( 16r1000000000000 bitOr: 16r1000000000000) lowBit = 49).
    self assert:(( 16r10000000000000 bitOr: 16r10000000000000) lowBit = 53).
    self assert:(( 16r100000000000000 bitOr: 16r100000000000000) lowBit = 57).
    self assert:(( 16r1000000000000000 bitOr: 16r1000000000000000) lowBit = 61).
    self assert:(( 16r10000000000000000 bitOr: 16r10000000000000000) lowBit = 65).
    self assert:(( (1 bitShift:1000) bitOr: (1 bitShift:1001)) lowBit = 1001).

    "
     self basicNew testHighBitLowBit
    "
!

testILC
    "inline-cache"

    self assert:((self checkIsInteger:1) == true).
    self assert:((self checkIsInteger:nil) == false).
    self assert:((self checkIsInteger:1) == true).
    self assert:((self checkIsInteger:nil) == false).

    self assert:((self checkIsInteger:0) == true).
    self assert:((self checkIsInteger:nil) == false).
    self assert:((self checkIsInteger:0) == true).
    self assert:((self checkIsInteger:nil) == false).

    "
     self basicNew testILC
    "

    "Created: / 6.6.1999 / 14:47:51 / cg"
    "Modified: / 9.6.1999 / 17:49:57 / cg"
!

testInline1
    "inlined tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    self assert:( (self absPlusOneOf:1) = 2 ).
    self assert:( (self absPlusOneOf:-1) = 2 ).
    self assert:( (self absPlusOneOf:1.0) = 2 ).
    self assert:( (self absPlusOneOf:-1.0) = 2 ).

    "
     self basicNew testInline1
    "

    "Created: / 31.10.2000 / 20:22:48 / cg"
    "Modified: / 31.10.2000 / 20:23:06 / cg"
!

testInteger1
    "general conversion & arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular method's code."

    |minVal maxVal maxValPlus1 minValMinus1 halfMin halfMax t|

    minVal := SmallInteger perform:('minVal' asSymbol).
    maxVal := SmallInteger perform:('maxVal' asSymbol).

    self assert:(minVal class == SmallInteger).
    self assert:(maxVal class == SmallInteger).

    self assert:(minVal == self num_smallInt_minVal).
    self assert:(maxVal == self num_smallInt_maxVal).

    self assert:(minVal == SmallInteger minVal).
    self assert:(maxVal == SmallInteger maxVal).

    t := SmallInteger perform:('maxBytes' asSymbol).
    self assert:(t == SmallInteger maxBytes).
    t := SmallInteger perform:('maxBits' asSymbol).
    self assert:(t == SmallInteger maxBits).

    self testPrinting1.

    self assert:(SmallInteger maxBytes == ExternalAddress pointerSize).
    "/ again, preventing inlining by compiler
    self assert:(SmallInteger perform:#maxBytes) == (ExternalAddress perform:#pointerSize).
    self assert:(SmallInteger perform:'maxBytes' asSymbol) == (ExternalAddress perform:'pointerSize' asSymbol).

    SmallInteger maxBytes == 4 ifTrue:[
        self assert:(minVal hexPrintString = '-40000000').
        self assert:(maxVal hexPrintString = '3FFFFFFF').
        self assert:(minVal == -1073741824).
        self assert:(maxVal == 1073741823).
        maxValPlus1 := 1073741824.
        minValMinus1 := -1073741825.
        self assert:(minValMinus1 hexPrintString = '-40000001').
        self assert:(maxValPlus1 hexPrintString = '40000000').
        halfMin := -16r20000000.
        halfMax := 16r20000000.
    ].
    SmallInteger maxBytes == 8 ifTrue:[
        self assert:(minVal hexPrintString = '-4000000000000000').
        self assert:(maxVal hexPrintString = '3FFFFFFFFFFFFFFF').
        self assert:(minVal == -4611686018427387904).
        self assert:(maxVal == 4611686018427387903).
        maxValPlus1 := 4611686018427387904.
        minValMinus1 := -4611686018427387905.
        self assert:(minValMinus1 hexPrintString = '-4000000000000001').
        self assert:(maxValPlus1 hexPrintString = '4000000000000000').
        halfMin := -16r2000000000000000.
        halfMax := 16r2000000000000000.
    ].
    
    self assert:(minValMinus1 class == LargeInteger).
    self assert:(maxValPlus1 class == LargeInteger).

    "arithmetic overFlow checks"

"/    self assert:((maxVal + 1) inspect.maxValPlus1 inspect. true).
    self assert:((maxVal perform:'+' asSymbol with:1) = maxValPlus1).
    self assert:((maxVal + 1) = maxValPlus1).
    self assert:((minVal perform:'-' asSymbol with:1) = minValMinus1).
    self assert:((minVal - 1) = minValMinus1).

    self assert:((halfMax perform:'+' asSymbol with:halfMax) = maxValPlus1).
    self assert:((halfMax + halfMax) = maxValPlus1).
    self assert:((halfMin perform:'+' asSymbol with:halfMin) == minVal).
    self assert:((halfMin + halfMin) == minVal).
    self assert:((halfMax perform:'*' asSymbol with:2) = maxValPlus1).
    self assert:((halfMax * 2) = maxValPlus1).
    self assert:((halfMin perform:'*' asSymbol with:2) == minVal).
    self assert:((halfMin * 2) == minVal).
    self assert:((maxValPlus1 perform:'//' asSymbol with:2) == halfMax).
    self assert:((maxValPlus1 // 2) == halfMax).
    self assert:((halfMax perform:'bitShift:' asSymbol with:1) = maxValPlus1).
    self assert:((halfMin perform:'bitShift:' asSymbol with:1) == minVal).
    self assert:((halfMax bitShift:1) = maxValPlus1).
    self assert:((halfMin bitShift:1) == minVal).

    "LargeInt op -> SmallInt result"
    t := maxVal + 1.
    self assert:(t - 1 == maxVal).
    t := minVal - 1.
    self assert:(t + 1 == minVal).

    "
     self basicNew testInteger1
    "

    "Modified: / 6.6.1999 / 14:46:11 / cg"
!

testIntegerMisc
    "misc tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |n1 n2 s|

    n1 := 100000.
    n2 := n1 negated.
    s := 1.

    self assert:(n1 printString = '100000').

    self assert:(n1 negated printString = '-100000').
    self assert:((n1 perform:'negated' asSymbol) printString = '-100000').

    self assert:(n1 negated abs printString = '100000').
    self assert:((n1 perform:'negated' asSymbol) abs printString = '100000').

    self assert:(n1 abs negated printString = '-100000').
    self assert:((n1 perform:'abs' asSymbol) negated printString = '-100000').

    n1 := SmallInteger maxVal.
    self assert:(n1 negated class == SmallInteger).
    self assert:((n1 perform:'negated' asSymbol) class == SmallInteger).

    n1 := SmallInteger minVal.
    self assert:(n1 negated class == LargeInteger).
    self assert:((n1 perform:'negated' asSymbol) class == LargeInteger).

    n1 := SmallInteger minVal negated - 1.
    self assert:(n1 negated class == SmallInteger).
    self assert:((n1 perform:'negated' asSymbol) class == SmallInteger).
    self assert:(n1 == SmallInteger maxVal).

    "
     self basicNew testIntegerMisc
    "

    "Created: / 6.6.1999 / 14:47:51 / cg"
    "Modified: / 9.6.1999 / 17:49:57 / cg"
!

testIntegerMisc2
    "misc tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |n sel|

    "/ fib is optional
    (0 respondsTo:#fib) ifFalse:[^ self].

    self assert:(0 fib == 0).
    self assert:(1 fib == 1).
    self assert:(2 fib == 1).
    self assert:(3 fib == 2).
    self assert:(4 fib == 3).
    self assert:(5 fib == 5).
    self assert:(6 fib == 8).
    self assert:(7 fib == 13).

    n := 0.
    self assert:(n fib == 0).
    n := 1.
    self assert:(n fib == 1).
    n := 2.
    self assert:(n fib == 1).
    n := 3.
    self assert:(n fib == 2).
    n := 4.
    self assert:(n fib == 3).
    n := 5.
    self assert:(n fib == 5).
    n := 6.
    self assert:(n fib == 8).
    n := 7.
    self assert:(n fib == 13).

    #(0 1 2 3 4 5 6 7)
    with:#(0 1 1 2 3 5 8 13)
    do:[:n :rslt |
	self assert:(n fib == rslt).
    ].

"/    #(0 1 2 3 4 5 6 7)
"/    with:#(0 1 1 2 3 5 8 13)
"/    do:[:n :rslt |
"/        self assert:(n fib_recursive == rslt).
"/    ].

    sel := #fib.
    self assert:((0 perform:sel) == 0).
    self assert:((1 perform:sel) == 1).
    self assert:((2 perform:sel) == 1).
    self assert:((3 perform:sel) == 2).
    self assert:((4 perform:sel) == 3).
    self assert:((5 perform:sel) == 5).
    self assert:((6 perform:sel) == 8).
    self assert:((7 perform:sel) == 13).

    "
     self basicNew testIntegerMisc2
    "
!

testIntegerShifts
    "arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    self testIntegerShifts1.
    self testIntegerShifts2.

    self assert:(
     (((0 to:64) collect:[:s | 1 bitShift:s])
	collect:[:n | n highBit]) = (1 to:65)
    ).

    1 to:10000 do:[:s |
	self assert:( (1 bitShift:s) highBit == (s+1) )
    ].
    1 to:10000 do:[:s |
	self assert:( ((1 bitShift:s) - 1) highBit == s )
    ].

    "
     self basicNew testIntegerShifts
    "

    "Created: / 6.6.1999 / 14:47:51 / cg"
    "Modified: / 9.6.1999 / 17:49:57 / cg"
!

testIntegerShifts1
    "arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |n1 n2 s|

    n1 := 100000.
    n2 := n1 negated.
    s := 1.

    self assert:(n1 printString = '100000').
    self assert:(n2 printString = '-100000').

    self assert:((n1 bitShift:s) printString = '200000').
    self assert:((n1 bitShift:1) printString = '200000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '200000').
    self assert:((n1 perform:'bitShift:' asSymbol with:1) printString = '200000').

    s := s + 1.
    self assert:((n1 bitShift:s) printString = '400000').
    self assert:((n1 bitShift:2) printString = '400000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '400000').
    self assert:((n1 perform:'bitShift:' asSymbol with:2) printString = '400000').

    s := s + 1.
    self assert:((n1 bitShift:s) printString = '800000').
    self assert:((n1 bitShift:3) printString = '800000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '800000').
    self assert:((n1 perform:'bitShift:' asSymbol with:3) printString = '800000').

    s := s + 1.
    self assert:((n1 bitShift:s) printString = '1600000').
    self assert:((n1 bitShift:4) printString = '1600000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '1600000').
    self assert:((n1 perform:'bitShift:' asSymbol with:4) printString = '1600000').

    s := s + 1.
    self assert:((n1 bitShift:s) printString = '3200000').
    self assert:((n1 bitShift:5) printString = '3200000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '3200000').
    self assert:((n1 perform:'bitShift:' asSymbol with:5) printString = '3200000').

    s := s + 1.
    self assert:((n1 bitShift:s) printString = '6400000').
    self assert:((n1 bitShift:6) printString = '6400000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '6400000').
    self assert:((n1 perform:'bitShift:' asSymbol with:6) printString = '6400000').

    s := s + 1.
    self assert:((n1 bitShift:s) printString = '12800000').
    self assert:((n1 bitShift:7) printString = '12800000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '12800000').
    self assert:((n1 perform:'bitShift:' asSymbol with:7) printString = '12800000').

    "
     self basicNew testIntegerShifts1
    "

    "Created: / 6.6.1999 / 14:47:51 / cg"
    "Modified: / 9.6.1999 / 17:49:57 / cg"
!

testIntegerShifts2
    "arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |n1 s|

    n1 := 12800000.
    s := -1.
    self assert:((n1 bitShift:s) printString = '6400000').
    self assert:((n1 bitShift:-1) printString = '6400000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '6400000').
    self assert:((n1 perform:'bitShift:' asSymbol with:-1) printString = '6400000').

    s := s - 1.
    self assert:((n1 bitShift:s) printString = '3200000').
    self assert:((n1 bitShift:-2) printString = '3200000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '3200000').
    self assert:((n1 perform:'bitShift:' asSymbol with:-2) printString = '3200000').

    s := s - 1.
    self assert:((n1 bitShift:s) printString = '1600000').
    self assert:((n1 bitShift:-3) printString = '1600000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '1600000').
    self assert:((n1 perform:'bitShift:' asSymbol with:-3) printString = '1600000').

    s := s - 1.
    self assert:((n1 bitShift:s) printString = '800000').
    self assert:((n1 bitShift:-4) printString = '800000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '800000').
    self assert:((n1 perform:'bitShift:' asSymbol with:-4) printString = '800000').

    s := s - 1.
    self assert:((n1 bitShift:s) printString = '400000').
    self assert:((n1 bitShift:-5) printString = '400000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '400000').
    self assert:((n1 perform:'bitShift:' asSymbol with:-5) printString = '400000').

    s := s - 1.
    self assert:((n1 bitShift:s) printString = '200000').
    self assert:((n1 bitShift:-6) printString = '200000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '200000').
    self assert:((n1 perform:'bitShift:' asSymbol with:-6) printString = '200000').

    s := s - 1.
    self assert:((n1 bitShift:s) printString = '100000').
    self assert:((n1 bitShift:-7) printString = '100000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '100000').
    self assert:((n1 perform:'bitShift:' asSymbol with:-7) printString = '100000').

    s := s - 1.
    self assert:((n1 bitShift:s) printString = '50000').
    self assert:((n1 bitShift:-8) printString = '50000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '50000').
    self assert:((n1 perform:'bitShift:' asSymbol with:-8) printString = '50000').

    s := s - 1.
    self assert:((n1 bitShift:s) printString = '25000').
    self assert:((n1 bitShift:-9) printString = '25000').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '25000').
    self assert:((n1 perform:'bitShift:' asSymbol with:-9) printString = '25000').

    s := s - 1.
    self assert:((n1 bitShift:s) printString = '12500').
    self assert:((n1 bitShift:-10) printString = '12500').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '12500').
    self assert:((n1 perform:'bitShift:' asSymbol with:-10) printString = '12500').

    s := s - 1.
    self assert:((n1 bitShift:s) printString = '6250').
    self assert:((n1 bitShift:-11) printString = '6250').
    self assert:((n1 perform:'bitShift:' asSymbol with:s) printString = '6250').
    self assert:((n1 perform:'bitShift:' asSymbol with:-11) printString = '6250').

    "
     self basicNew testIntegerShifts2
    "

    "Created: / 6.6.1999 / 14:47:51 / cg"
    "Modified: / 9.6.1999 / 17:49:57 / cg"
!

testIntegerShifts3
    "arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    self assert:( self doConstantIntegerShift == 1).

    "
     self basicNew testIntegerShifts3
    "
!

testIntegerShifts4
    "arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |a|

    a := 16r1234.

    self assert:( ((a bitShift:-4) bitAnd:16rFF) == 16r23 ).
    self assert:( ((a bitShift:-8) bitAnd:16rFF) == 16r12 ).
    self assert:( ((a bitShift:-12) bitAnd:16rFF) == 16r1 ).
    self assert:( ((a bitShift:-16) bitAnd:16rFF) == 0 ).

    "/ should not shift in any sign bits ...
    a := 16r1FFFFFFF.
    self assert:( (a bitShift:-4) == 16r1FFFFFF ).
    a := 16r3FFFFFFF.
    self assert:( (a bitShift:-4) == 16r3FFFFFF ).
    a := 16r7FFFFFFF.
    self assert:( (a bitShift:-4) == 16r7FFFFFF ).
    a := 16rFFFFFFFF.
    self assert:( (a bitShift:-4) == 16rFFFFFFF ).
    a := 16r1FFFFFFFF.
    self assert:( (a bitShift:-4) == 16r1FFFFFFF ).

    a := 16r1FFFFFFF.
    self assert:( (a bitShift:-8) == 16r1FFFFF ).
    a := 16r3FFFFFFF.
    self assert:( (a bitShift:-8) == 16r3FFFFF ).
    a := 16r7FFFFFFF.
    self assert:( (a bitShift:-8) == 16r7FFFFF ).
    a := 16rFFFFFFFF.
    self assert:( (a bitShift:-8) == 16rFFFFFF ).
    a := 16r1FFFFFFFF.
    self assert:( (a bitShift:-8) == 16r1FFFFFF ).

    "
     self basicNew testIntegerShifts4
    "
!

testIsPowerOfTwo
    self assert:(1 isPowerOfTwo).
    self assert:(2 isPowerOfTwo).
    self assert:(4 isPowerOfTwo).
    self assert:(3 isPowerOfTwo not).
    self assert:(16r100000000000000000000000 isPowerOfTwo).
    self assert:(16r300000000000000000000000 isPowerOfTwo not).

    "
     self basicNew testIsPowerOfTwo
    "

    "Created: / 27-04-2010 / 10:35:36 / cg"
!

testLargeAddition
    "general conversion & arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    "Large + Large addition"
    self testReading1.

    self assert:(20 factorial = 2432902008176640000).
    self assert:(20 factorial printString = '2432902008176640000').
    self assert:((20 factorial + 20 factorial) printString = '4865804016353280000').
    self assert:((20 factorial + 1) printString = '2432902008176640001').
    self assert:((20 factorial + 1000) printString = '2432902008176641000').

    "Large + Small addition"

    self testLargeAddition1.

    "Large + Large addition"

    self testLargeAddition2.

    "Large - small subtraction"

    self testLargeAddition3.

    "
     self basicNew testLargeAddition
    "

    "Modified: / 26-02-2016 / 15:39:33 / cg"
!

testLargeAddition1
    "general conversion & arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |s n1 n2 x|

    "Large + Small addition"

    n1 := 16r3FFFFFFF. n2 := 1.
    self assert:((n1 + n2 ) hexPrintString = '40000000').
    self assert:((n1 perform:'+' asSymbol with:n2 ) hexPrintString = '40000000').
    n1 := 16r3FFFFFFFF. n2 := 1.
    self assert:((n1 + n2 ) hexPrintString = '400000000').
    self assert:((n1 perform:'+' asSymbol with:n2 ) hexPrintString = '400000000').
    n1 := 16r3FFFFFFFFF. n2 := 1.
    self assert:((n1 + n2 ) hexPrintString = '4000000000').
    self assert:((n1 perform:'+' asSymbol with:n2 ) hexPrintString = '4000000000').
    n1 := 16r3FFFFFFFFFF. n2 := 1.
    self assert:((n1 + n2 ) hexPrintString = '40000000000').
    self assert:((n1 perform:'+' asSymbol with:n2 ) hexPrintString = '40000000000').
    n1 := 16r3FFFFFFFFFFF. n2 := 1.
    self assert:((n1 + n2 ) hexPrintString = '400000000000').
    self assert:((n1 perform:'+' asSymbol with:n2 ) hexPrintString = '400000000000').
    n1 := 16r3FFFFFFFFFFFF. n2 := 1.
    self assert:((n1 + n2 ) hexPrintString = '4000000000000').
    self assert:((n1 perform:'+' asSymbol with:n2 ) hexPrintString = '4000000000000').
    n1 := 16r3FFFFFFFFFFFFF. n2 := 1.
    self assert:((n1 + n2 ) hexPrintString = '40000000000000').
    self assert:((n1 perform:'+' asSymbol with:n2 ) hexPrintString = '40000000000000').
    n1 := 16r3FFFFFFFFFFFFFF. n2 := 1.
    self assert:((n1 + n2 ) hexPrintString = '400000000000000').
    self assert:((n1 perform:'+' asSymbol with:n2 ) hexPrintString = '400000000000000').
    n1 := 16r3FFFFFFFFFFFFFFF. n2 := 1.
    self assert:((n1 + n2 ) hexPrintString = '4000000000000000').
    self assert:((n1 perform:'+' asSymbol with:n2 ) hexPrintString = '4000000000000000').

    "
     self basicNew testLargeAddition1
    "

    "Modified: / 4.6.1999 / 15:26:55 / cg"
!

testLargeAddition2
    "general conversion & arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |s n1 n2 x|

    "Large + Large addition"

    n1 := 16r100000000. n2 := 16r7FFFFFFF.
    self assert:((n1 - n2 ) hexPrintString = '80000001').
    self assert:((16r100000000 - n2 ) hexPrintString = '80000001').
    self assert:((n1 - 16r7FFFFFFF ) hexPrintString = '80000001').
    self assert:((16r100000000 - 16r7FFFFFFF ) hexPrintString = '80000001').
    self assert:((n1 perform:'-' asSymbol with:n2 ) hexPrintString = '80000001').
    self assert:((16r100000000 perform:'-' asSymbol with:n2 ) hexPrintString = '80000001').
    self assert:((n1 perform:'-' asSymbol with:16r7FFFFFFF ) hexPrintString = '80000001').
    self assert:((16r100000000 perform:'-' asSymbol with:16r7FFFFFFF ) hexPrintString = '80000001').

    n1 := 16r100000000. n2 := 16r80000000.
    self assert:((n1 - n2 ) hexPrintString = '80000000').
    self assert:((16r100000000 - n2 ) hexPrintString = '80000000').
    self assert:((n1 - 16r80000000 ) hexPrintString = '80000000').
    self assert:((16r100000000 - 16r80000000 ) hexPrintString = '80000000').
    self assert:((n1 perform:'-' asSymbol with:n2 ) hexPrintString = '80000000').
    self assert:((16r100000000 perform:'-' asSymbol with:n2 ) hexPrintString = '80000000').
    self assert:((n1 perform:'-' asSymbol with:16r80000000 ) hexPrintString = '80000000').
    self assert:((16r100000000 perform:'-' asSymbol with:16r80000000 ) hexPrintString = '80000000').

    n1 := 16r100000000. n2 := 16rFFFFFFFF.
    self assert:((n1 - n2 ) hexPrintString = '1').
    self assert:((16r100000000 - n2 ) hexPrintString = '1').
    self assert:((x := n1 - 16rFFFFFFFF) == 1).

    self assert:((n1 - 16rFFFFFFFF ) hexPrintString = '1').
    self assert:((16r100000000 - 16rFFFFFFFF ) hexPrintString = '1').
    self assert:((n1 perform:'-' asSymbol with:n2 ) hexPrintString = '1').
    self assert:((16r100000000 perform:'-' asSymbol with:n2 ) hexPrintString = '1').
    self assert:((n1 perform:'-' asSymbol with:16rFFFFFFFF ) hexPrintString = '1').
    self assert:((16r100000000 perform:'-' asSymbol with:16rFFFFFFFF ) hexPrintString = '1').

    n1 := 16r100000000. n2 := 1.
    self assert:((n1 - n2) hexPrintString = 'FFFFFFFF').
    self assert:((n1 - n2) hexPrintString = 'FFFFFFFF').
    self assert:((16r100000000 - n2) hexPrintString = 'FFFFFFFF').
    self assert:((n1 - 1) hexPrintString = 'FFFFFFFF').
    self assert:((16r100000000 - 1) hexPrintString = 'FFFFFFFF').
    self assert:((n1 perform:'-' asSymbol with:n2) hexPrintString = 'FFFFFFFF').
    self assert:((16r100000000 perform:'-' asSymbol with:n2) hexPrintString = 'FFFFFFFF').
    self assert:((n1 perform:'-' asSymbol with:1) hexPrintString = 'FFFFFFFF').
    self assert:((16r100000000 perform:'-' asSymbol with:1) hexPrintString = 'FFFFFFFF').

    n1 := 16r100000000. n2 := 16r10000000.
    self assert:((n1 - n2) hexPrintString = 'F0000000').
    self assert:((16r100000000 - n2) hexPrintString = 'F0000000').
    self assert:((n1 - 16r10000000) hexPrintString = 'F0000000').
    self assert:((16r100000000 - 16r10000000) hexPrintString = 'F0000000').
    self assert:((n1 perform:'-' asSymbol with:n2) hexPrintString = 'F0000000').
    self assert:((16r100000000 perform:'-' asSymbol with:n2) hexPrintString = 'F0000000').
    self assert:((n1 perform:'-' asSymbol with:16r10000000) hexPrintString = 'F0000000').
    self assert:((16r100000000 perform:'-' asSymbol with:16r10000000) hexPrintString = 'F0000000').

    "
     self basicNew testLargeAddition2
    "
!

testLargeAddition3
    "general conversion & arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |s n1 n2 x|

    "Large - small subtraction"
    self assert:((20 factorial + 20 factorial - 1) printString = '4865804016353279999').
    self assert:((20 factorial - 10 factorial + 3628800) printString = '2432902008176640000').
    self assert:((20 factorial - 11 factorial + 39916800) printString = '2432902008176640000').
    self assert:((20 factorial - 12 factorial + 479001600) printString = '2432902008176640000').
    self assert:((20 factorial - 13 factorial + 6227020800) printString = '2432902008176640000').
    self assert:((20 factorial - 14 factorial + 87178291200) printString = '2432902008176640000').
    self assert:((20 factorial - 15 factorial + 1307674368000) printString = '2432902008176640000').
    self assert:((20 factorial - 16 factorial + 20922789888000) printString = '2432902008176640000').
    self assert:((20 factorial + 10 factorial - 3628800) printString = '2432902008176640000').

    self assert:(1000 factorial printString = '402387260077093773543702433923003985719374864210714632543799910429938512398629020592044208486969404800479988610197196058631666872994808558901323829669944590997424504087073759918823627727188732519779505950995276120874975462497043601418278094646496291056393887437886487337119181045825783647849977012476632889835955735432513185323958463075557409114262417474349347553428646576611667797396668820291207379143853719588249808126867838374559731746136085379534524221586593201928090878297308431392844403281231558611036976801357304216168747609675871348312025478589320767169132448426236131412508780208000261683151027341827977704784635868170164365024153691398281264810213092761244896359928705114964975419909342221566832572080821333186116811553615836546984046708975602900950537616475847728421889679646244945160765353408198901385442487984959953319101723355556602139450399736280750137837615307127761926849034352625200015888535147331611702103968175921510907788019393178114194545257223865541461062892187960223838971476088506276862967146674697562911234082439208160153780889893964518263243671616762179168909779911903754031274622289988005195444414282012187361745992642956581746628302955570299024324153181617210465832036786906117260158783520751516284225540265170483304226143974286933061690897968482590125458327168226458066526769958652682272807075781391858178889652208164348344825993266043367660176999612831860788386150279465955131156552036093988180612138558600301435694527224206344631797460594682573103790084024432438465657245014402821885252470935190620929023136493273497565513958720559654228749774011413346962715422845862377387538230483865688976461927383814900140767310446640259899490222221765904339901886018566526485061799702356193897017860040811889729918311021171229845901641921068884387121855646124960798722908519296819372388642614839657382291123125024186649353143970137428531926649875337218940694281434118520158014123344828015051399694290153483077644569099073152433278288269864602789864321139083506217095002597389863554277196742822248757586765752344220207573630569498825087968928162753848863396909959826280956121450994871701244516461260379029309120889086942028510640182154399457156805941872748998094254742173582401063677404595741785160829230135358081840096996372524230560855903700624271243416909004153690105933983835777939410970027753472000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000').

    n1 := n2 := 1.
    self assert:((1000 factorial + n1 - n2) = 1000 factorial).
    n1 := n2 := 1000.
    self assert:((1000 factorial + n1 - n2) = 1000 factorial).
    n1 := n2 := 16rFFFFFFFF.
    self assert:((1000 factorial + n1 - n2) = 1000 factorial).
    n1 := n2 := 16rFFFFFFFFFFFF.
    self assert:((1000 factorial + n1 - n2) = 1000 factorial).
    n1 := n2 := 16rFFFFFFFFFFFFFFFF.
    self assert:((1000 factorial + n1 - n2) = 1000 factorial).
    n1 := n2 := 1000 factorial.
    self assert:((1000 factorial + n1 - n2) = 1000 factorial).


    "
     self basicNew testLargeAddition3
    "

    "Modified: / 27.11.1999 / 16:41:54 / cg"
!

testLargeBitOperations
    "large bit operations test."

     self assert:(16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFF) hexPrintString = '2211'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFF) hexPrintString  = '332211'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFF) hexPrintString = '44332211'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFF) hexPrintString = '5544332211'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFFFF) hexPrintString = '665544332211'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFFFFFF) hexPrintString = '77665544332211'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFFFFFFFF) hexPrintString = '8877665544332211'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFFFFFFFFFF) hexPrintString = '998877665544332211'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFFFFFFFFFFFF) hexPrintString = 'AA998877665544332211'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFFFFFFFFFFFFFF) hexPrintString = 'BBAA998877665544332211'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFFFFFFFFFFFFFFFF) hexPrintString = 'CCBBAA998877665544332211'.

     self assert:(16rFFEEDDCCBBAA998877665544332211 bitOr:16rFFFF) hexPrintString = 'FFEEDDCCBBAA99887766554433FFFF'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitOr:16rFFFFFF) hexPrintString  = 'FFEEDDCCBBAA998877665544FFFFFF'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitOr:16rFFFFFFFF) hexPrintString = 'FFEEDDCCBBAA9988776655FFFFFFFF'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitOr:16rFFFFFFFFFF) hexPrintString = 'FFEEDDCCBBAA99887766FFFFFFFFFF'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitOr:16rFFFFFFFFFFFF) hexPrintString = 'FFEEDDCCBBAA998877FFFFFFFFFFFF'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitOr:16rFFFFFFFFFFFFFF) hexPrintString = 'FFEEDDCCBBAA9988FFFFFFFFFFFFFF'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitOr:16rFFFFFFFFFFFFFFFF) hexPrintString = 'FFEEDDCCBBAA99FFFFFFFFFFFFFFFF'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitOr:16rFFFFFFFFFFFFFFFFFF) hexPrintString = 'FFEEDDCCBBAAFFFFFFFFFFFFFFFFFF'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitOr:16rFFFFFFFFFFFFFFFFFFFF) hexPrintString = 'FFEEDDCCBBFFFFFFFFFFFFFFFFFFFF'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitOr:16rFFFFFFFFFFFFFFFFFFFFFF) hexPrintString = 'FFEEDDCCFFFFFFFFFFFFFFFFFFFFFF'.
     self assert:(16rFFEEDDCCBBAA998877665544332211 bitOr:16rFFFFFFFFFFFFFFFFFFFFFFFF) hexPrintString = 'FFEEDDFFFFFFFFFFFFFFFFFFFFFFFF'.

    Time millisecondsToRun:[
        1000000 timesRepeat:[
            (16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFFFFFFFFFFFFFFFF)
        ]
    ].
    "/ bitAnd inherited via Integer:  1638 1575 1576
    "/ bitAnd tuned in largeInteger:  172 171 172

    Time millisecondsToRun:[
        1000000 timesRepeat:[
            (16rFFEEDDCCBBAA998877665544332211 bitOr:16rFFFFFFFFFFFFFFFFFFFFFFFF)
        ]
    ].
    "/ bitOr inherited via Integer:  1903 1856 1856

    self assert:( 16r800008 signExtendedFromBit:4 ) = -8. 
    self assert:( 16r7FFF07 signExtendedFromBit:4 ) = 7.     
    self assert:( 16r7FFF0F signExtendedFromBit:4 ) = -1.    

    self assert:( 16rFFFFFF signExtendedFromBit:8 ) = -1.   
    self assert:( 16rFFFF7F signExtendedFromBit:8 ) = 16r7F.   

    self assert:( 16rFFFFFF signExtendedByteValue ) = -1.   
    self assert:( 16rFFFF7F signExtendedByteValue ) = 16r7F.   

    self assert:( 16rFFFF signExtendedShortValue ) = -1.   
    self assert:( 16r7FFF signExtendedShortValue ) = 16r7FFF.   
    self assert:( 16rFFFFFFFF signExtendedShortValue ) = -1.   
    self assert:( 16rFFFF7FFF signExtendedShortValue ) = 16r7FFF.   
    self assert:( 16rFFFFFFFFFF signExtendedShortValue ) = -1.   
    self assert:( 16rFFFFFF7FFF signExtendedShortValue ) = 16r7FFF.   
    self assert:( 16rFFFFFFFFFFFF signExtendedShortValue ) = -1.   
    self assert:( 16rFFFFFFFF7FFF signExtendedShortValue ) = 16r7FFF.   

    self assert:( 16rFFFFFFFF signExtendedLongValue ) = -1.   
    self assert:( 16r7FFFFFFF signExtendedLongValue ) = 2147483647.   
    self assert:( 16r80000000 signExtendedLongValue ) = -2147483648.   
    self assert:( 16rFFFFFFFFFFFF signExtendedLongValue ) = -1.   
    self assert:( 16rFFFF7FFFFFFF signExtendedLongValue ) = 2147483647.   
    self assert:( 16rFFFF80000000 signExtendedLongValue ) = -2147483648.   
    self assert:( 16rFFFFFFFFFFFFFFFF signExtendedLongValue ) = -1.   
    self assert:( 16rFFFFFFFF7FFFFFFF signExtendedLongValue ) = 2147483647.   
    self assert:( 16rFFFFFFFF80000000 signExtendedLongValue ) = -2147483648.   

    self assert:( 16rFFFFFFFFFFFFFFFF signExtendedLongLongValue ) = -1.   
    self assert:( 16r7FFFFFFFFFFFFFFF signExtendedLongLongValue ) = 16r7FFFFFFFFFFFFFFF.   
    self assert:( 16rFFFFFFFFFFFFFFFFFFFF signExtendedLongLongValue ) = -1.   
    self assert:( 16rFFFF7FFFFFFFFFFFFFFF signExtendedLongLongValue ) = 16r7FFFFFFFFFFFFFFF.   

    "
     self basicNew testLargeBitOperations
    "

    "Modified: / 26-02-2016 / 19:47:25 / cg"
!

testLargeCompare
    "compare tests"

    #(
        ( 16r3fffffff 16r40000000 #less )
        ( 16r40000000 16r3fffffff #greater )
        ( 16r40000000 16r40000000 #equal )

        ( 16r40000000 16r40000001 #less )
        ( 16r40000001 16r40000000 #greater )
        ( 16r40000001 16r40000001 #equal )
        
        ( 16r3fffffffffffffff 16r4000000000000000 #less )
        ( 16r4000000000000000 16r3fffffffffffffff #greater )
        ( 16r4000000000000000 16r4000000000000000 #equal )

        ( 16r4000000000000000 16r4000000000000001 #less )
        ( 16r4000000000000001 16r4000000000000000 #greater )
        ( 16r4000000000000001 16r4000000000000001 #equal )

        ( 16r3fffffffffffffffffffffff 16r400000000000000000000000 #less )
        ( 16r400000000000000000000000 16r3fffffffffffffffffffffff #greater )
        ( 16r400000000000000000000000 16r400000000000000000000000 #equal )

        ( 16r400000000000000000000000 16r400000000000000000000001 #less )
        ( 16r400000000000000000000001 16r400000000000000000000000 #greater )
        ( 16r400000000000000000000001 16r400000000000000000000001 #equal )

        ( 16r3fffffff 16r400000000000 #less )
        ( 16r400000000000 16r3fffffff #greater )

        ( 16r40000000 16r400000000001 #less )
        ( 16r400000000001 16r40000000 #greater )

        ( 16r3fffffffffffffff 16r40000000000000000000 #less )
        ( 16r40000000000000000000 16r3fffffffffffffff #greater )

        ( 16r4000000000000000 16r40000000000000000001 #less )
        ( 16r40000000000000000001 16r4000000000000000 #greater )

        ( 16r3fffffffffffffffffffffff 16r400000000000000000000000 #less )
        ( 16r400000000000000000000000 16r3fffffffffffffffffffffff #greater )
        ( 16r400000000000000000000000 16r400000000000000000000000 #equal )

        ( 16r400000000000000000000000 16r400000000000000000000001 #less )
        ( 16r400000000000000000000001 16r400000000000000000000000 #greater )
        ( 16r400000000000000000000001 16r400000000000000000000001 #equal )
    ) do:[:triple |
        |v1 v2 expected rslt|
        
        v1 := triple at:1.
        v2 := triple at:2.
        expected := triple at:3.
        expected == #less ifTrue:[
            self assert:(v1 < v2).
            self assert:(v1 <= v2).
            self assert:(v1 > v2) not.
            self assert:(v1 >= v2) not.
            self assert:(v1 = v2) not.
            self assert:(v1 ~= v2).
        ].    
        expected == #greater ifTrue:[
            self assert:(v1 > v2).
            self assert:(v1 >= v2).
            self assert:(v1 < v2) not.
            self assert:(v1 <= v2) not.
            self assert:(v1 = v2) not.
            self assert:(v1 ~= v2).
        ].    
        expected == #equal ifTrue:[
            self assert:(v1 > v2) not.
            self assert:(v1 >= v2).
            self assert:(v1 < v2) not.
            self assert:(v1 <= v2).
            self assert:(v1 = v2).
            self assert:(v1 ~= v2) not.
        ].    
    ].
    self assert:(100 factorial < 101 factorial).
    self assert:(100 factorial > 100 factorial negated).
    
    "
     self basicNew testLargeCompare
    "
!

testLargeCompression1
    |l nullBytes|

    #(
	#[ 1 ]          16r01
	#[ 1 2 ]        16r0201
	#[ 1 2 3]       16r030201
	#[ 1 2 3 4]     16r04030201
    ) pairWiseDo:[:bytes :expected |
	0 to:16 do:[:nNullBytes |
	    nullBytes := ByteArray new:nNullBytes withAll:0.
	    l := LargeInteger digitBytes:(bytes , nullBytes).
	    self assert:( l compressed == expected ).
	].
    ].

    #(
	#[ 1 2 3 4 5]       16r0504030201
	#[ 1 2 3 4 5 6]     16r060504030201
	#[ 1 2 3 4 5 6 7]   16r07060504030201
	#[ 1 2 3 4 5 6 7 8] 16r0807060504030201
    ) pairWiseDo:[:bytes :expected |
	0 to:16 do:[:nNullBytes |
	    nullBytes := ByteArray new:nNullBytes withAll:0.
	    l := LargeInteger digitBytes:(bytes , nullBytes).
	    ExternalAddress pointerSize == 8 ifTrue:[
		self assert:( l compressed == expected ).
	    ] ifFalse:[
		self assert:( l compressed = expected ).
	    ]
	]
    ].

    #(
	#[ 1 2 3 4 5 6 7 8 9]       16r090807060504030201
	#[ 1 2 3 4 5 6 7 8 9 10]    16r0a090807060504030201
	#[ 1 2 3 4 5 6 7 8 9 10 11] 16r0b0a090807060504030201
    ) pairWiseDo:[:bytes :expected |
	0 to:16 do:[:nNullBytes |
	    nullBytes := ByteArray new:nNullBytes withAll:0.
	    l := LargeInteger digitBytes:(bytes , nullBytes).
	    self assert:( l compressed = expected ).
	]
    ].

    "
     self basicNew testLargeCompression1
    "
!

testLargeDivision
    |t v a b|

    "/ on a 64bit machine, this is actually a smallInteger!!
    t := 20 factorial.

    self assert:(t printString = '2432902008176640000').
    self assert:(t \\ 10 == 0).
    t := t // 10.
    self assert:(t printString = '243290200817664000').
    self assert:(t \\ 10 == 0).
    t := t // 10.
    self assert:(t printString = '24329020081766400').
    self assert:(t \\ 10 == 0).
    t := t // 10.
    self assert:(t printString = '2432902008176640').
    self assert:(t \\ 10 == 0).
    t := t // 10.
    self assert:(t printString = '243290200817664').
    self assert:(t \\ 10 == 4).
    t := t // 10.
    self assert:(t printString = '24329020081766').
    self assert:(t \\ 10 == 6).
    t := t // 10.
    self assert:(t printString = '2432902008176').
    self assert:(t \\ 10 == 6).
    t := t // 10.
    self assert:(t printString = '243290200817').
    self assert:(t \\ 10 == 7).
    t := t // 10.
    self assert:(t printString = '24329020081').
    self assert:(t \\ 10 == 1).
    t := t // 10.
    self assert:(t printString = '2432902008').
    self assert:(t \\ 10 == 8).
    t := t // 10.
    self assert:(t printString = '243290200').
    self assert:(t \\ 10 == 0).


    t := 20 factorial.

    self assert:(t printString = '2432902008176640000').
    self assert:(t \\ 1000 == 0).
    t := t // 1000.
    self assert:(t printString = '2432902008176640').
    self assert:(t \\ 1000 == 640).
    t := t // 1000.
    self assert:(t printString = '2432902008176').
    self assert:(t \\ 1000 == 176).
    t := t // 1000.
    self assert:(t printString = '2432902008').
    self assert:(t \\ 1000 == 8).
    t := t // 1000.
    self assert:(t printString = '2432902').
    self assert:(t \\ 1000 == 902).
    t := t // 1000.
    self assert:(t printString = '2432').
    self assert:(t \\ 1000 == 432).
    t := t // 1000.
    self assert:(t == 2).
    self assert:(t \\ 1000 == 2).


    t := 20 factorial.

    "Large // SmallInt division"
    t := t // 20.
    self assert:(t printString = 19 factorial printString).
    t := t // 19.
    self assert:(t printString = 18 factorial printString).
    t := t // 18.
    self assert:(t printString = 17 factorial printString).
    t := t // 17.
    self assert:(t printString = 16 factorial printString).
    t := t // 16.
    self assert:(t printString = 15 factorial printString).
    t := t // 15.
    self assert:(t printString = 14 factorial printString).
    t := t // 14.
    self assert:(t printString = 13 factorial printString).
    t := t // 13.
    self assert:(t printString = 12 factorial printString).
    t := t // 12.
    self assert:(t printString = 11 factorial printString).
    t := t // 11.
    self assert:(t printString = 10 factorial printString).
    self assert:(t == 10 factorial).

    t := 20 factorial.
    t := t + 21 factorial.
    t absDestructiveSubtract:21 factorial.
    self assert:(t compressed = 20 factorial).

    self assert:(
             [
               |v|
               v := 100 factorial copy.
               v absDestructiveSubtract:99 factorial.
               v compressed = (100 factorial - 99 factorial).
             ] value).

    "Large // Large division"
    self assert:((20 factorial // 19 factorial) == 20).
    self assert:((20 factorial * 21 // 20 // 21) = (19 factorial)).
    self assert:((10000 factorial // 9999 factorial) == 10000).
    self assert:((10000 factorial // 9999 factorial) == (10000 factorial / 9999 factorial)).

    a := 40 factorial.
    b := 39 factorial.
    self assert:(a // 40 = b).
    self assert:(a / 40 = b).
    self assert:(a // b = 40).
    self assert:(a // b = 40).

    "
     self basicNew testLargeDivision
    "

    "Modified: / 4.6.1999 / 23:54:57 / cg"
!

testLargeDivision2
    |t|

    t := 30 factorial.

    self assert:(t printString = '265252859812191058636308480000000').
    self assert:(t \\ 10 == 0).
    t := t // 10.
    self assert:(t printString = '26525285981219105863630848000000').
    self assert:(t \\ 10 == 0).
    t := t // 10.
    self assert:(t printString = '2652528598121910586363084800000').
    self assert:(t \\ 10 == 0).
    t := t // 10.
    self assert:(t printString = '265252859812191058636308480000').
    self assert:(t \\ 10 == 0).
    t := t // 10.
    self assert:(t printString = '26525285981219105863630848000').
    self assert:(t \\ 10 == 0).
    t := t // 10.
    self assert:(t printString = '2652528598121910586363084800').
    self assert:(t \\ 10 == 0).
    t := t // 10.
    self assert:(t printString = '265252859812191058636308480').
    self assert:(t \\ 10 == 0).
    t := t // 10.
    self assert:(t printString = '26525285981219105863630848').
    self assert:(t \\ 10 == 8).
    t := t // 10.
    self assert:(t printString = '2652528598121910586363084').
    self assert:(t \\ 10 == 4).
    t := t // 10.
    self assert:(t printString = '265252859812191058636308').
    self assert:(t \\ 10 == 8).
    t := t // 10.
    self assert:(t printString = '26525285981219105863630').
    self assert:(t \\ 10 == 0).
    t := t // 10.
    self assert:(t printString = '2652528598121910586363').
    self assert:(t \\ 10 == 3).


    t := 30 factorial.

    self assert:(t printString = '265252859812191058636308480000000').
    self assert:(t \\ 1000 == 0).
    t := t // 1000.
    self assert:(t printString = '265252859812191058636308480000').
    self assert:(t \\ 1000 == 0).
    t := t // 1000.
    self assert:(t printString = '265252859812191058636308480').
    self assert:(t \\ 1000 == 480).
    t := t // 1000.
    self assert:(t printString = '265252859812191058636308').
    self assert:(t \\ 1000 == 308).
    t := t // 1000.
    self assert:(t printString = '265252859812191058636').
    self assert:(t \\ 1000 == 636).
    t := t // 1000.
    self assert:(t printString = '265252859812191058').
    self assert:(t \\ 1000 == 058).
    t := t // 1000.
    self assert:(t printString = '265252859812191').
    self assert:(t \\ 1000 == 191).
    t := t // 1000.
    self assert:(t printString = '265252859812').
    self assert:(t \\ 1000 == 812).
    t := t // 1000.
    self assert:(t printString = '265252859').
    self assert:(t \\ 1000 == 859).
    t := t // 1000.
    self assert:(t printString = '265252').
    self assert:(t \\ 1000 == 252).
    t := t // 1000.
    self assert:(t == 265).


    t := 30 factorial.

    "Large // SmallInt division"
    t := t // 30.
    self assert:(t printString = 29 factorial printString).
    t := t // 29.
    self assert:(t printString = 28 factorial printString).
    t := t // 28.
    self assert:(t printString = 27 factorial printString).
    t := t // 27.
    self assert:(t printString = 26 factorial printString).
    t := t // 26.
    self assert:(t printString = 25 factorial printString).
    t := t // 25.
    self assert:(t printString = 24 factorial printString).
    t := t // 24.
    self assert:(t printString = 23 factorial printString).
    t := t // 23.
    self assert:(t printString = 22 factorial printString).
    t := t // 22.
    self assert:(t printString = 21 factorial printString).
    t := t // 21.
    self assert:(t printString = 20 factorial printString).
    self assert:(t = 20 factorial).

    t := 30 factorial.
    t := t + 31 factorial.
    t absDestructiveSubtract:31 factorial.
    self assert:(t compressed = 30 factorial).

    "Large // Large division"
    self assert:((30 factorial // 29 factorial) == 30).
    self assert:((30 factorial * 31 // 30 // 31) = (29 factorial)).
    self assert:((10000 factorial // 9999 factorial) == 10000).
    self assert:((10000 factorial // 9999 factorial) == (10000 factorial / 9999 factorial)).

    "
     self basicNew testLargeDivision
    "

    "Modified: / 4.6.1999 / 23:54:57 / cg"
!

testLargeDivision3
    |nr nrDiv divMod|

    nr := 7325642811050717153762789776988268826770436380599581066471363310499109217483708146717300025889347764783245287140288431825827761209734375227679364238973902481615726067110515609260483803343004535447652942957373994975597787908243354307547553217414840584715130217408586553614859382487727371958203670203728210853329589615550643569429545464633535838187607553120280274725090757329790353463095413523805494772650078306205912628165850732646863846576998277181504708528835125953362770982762908435490999280519117904719254192978414037497481935495547720579882482124362070304920033554421042496625143517677519951145301160506529078213700153962585026512916970185197699563558140876733107706727253226098498667726495707224022003616065672008153665539817928251568554484739745047105522527635187163056607022536498632737702947013365938133885169902714284727206577408496549992845715870018995222990562233528977494519678931256347544259771346247230580853991022721956676465120007969950427165372994323753297510475028095488055686092040724169139419916609256577729768013251303221252901814408489603855447556799027832316669978641359003225101118289255692054597992816505634077137939488367815415698567236171805308890522013024780344455911750571267472425322111576828023953254628842107966689828686941644594589250192289779894954314728890652959077550610325243691999405204222390497498029651468304746649735170207150423058209700682117896369093708787314191673370934168117103657952473409299633370355921652776795194998872621267955977007414487536764633556057244697184265399074262010357199308106519621332411646090881806679817777934087907609335095266207222734209276892672802559477129431290377781189460543831892579497032750130070072871363403749763492296712949034307352335981485523440716455874989554006840460427619480548908526831960007098095496673990791644237848915619019143304599320077794055989022733836402514795091748221758967378808917944360112901833917971660803687798356056419168537336005651674223355473407003283134339985506017270361538197141299934143152796116511007721239543588850520897247526805181747313555479146618959531019365744636489763407090552996809230736561767841333905734641055297321262233564674390961392651334871664325693448366323216336135114828870644061243807564587592658360508871312414270046251899865884799855978604603846784154676298841585915992392704588348304942478924343918975195923643629685241735276658813975572655538887395894943154837164154459809363283117923392993892589490540925513342593007784719441705148960453180301530851234688957032066907843949205120201720517233228017689397727501528654849506825446097709482577917667243321350295028575684178929416362809008034715382134959864428148337229371113753679702176851066723014671275176890295101957580814878664773530433540963808618303311433527685959104811072639265393597781952115276199443064654238529377585171747088279186943179071921057535680516445246724050154764542596741670850809674306935131178441317280401304117745258603320024189243969889899010725582438207015597258263941269730866138781215790257519260119642107850957073141852969214624609102867275022012968382626510150354544317157440551595548404866365232107076069108476859713524926579046999471537578555696823173917264727038317433492881860460533993043375675559974541501151536956388184229821825202783315175964857435121268159290087988520427001562311888903167219790907449246265211066597617404797684060743206718943066178740881680422221097537985644933108964245133276088549914210990590138516895520058065054329273143605806169872175805617483836108276041444751410352824841438522369961070941467306815885136393083146953817333717600651525643928410853518305074271285893483690402426110481100118592425979094825294009195497071244959721165805259378411459840402202432070097961411127831244002473025945590264209304535568932141934734427207643570840464365672020197014117057179828617184095466170277658012012082773008797284377020045199741711763429387654482036311118363550554573970722123056838391535176046275151704935927285776048526642046962416364731182508311665455959674818084140845113742927564214026026700188662967826830513695781752328070213377525743249206640596503567193612953686078368856837703275526312899731904806336662979992529567407592246922517958210869076841533625492899752157880746671555381617069359816751254049680535425407993431788796501484592904619815876395056294928500125620366251871965592128092071339931385778018271508366059428400618014316995088662886944531660310582304020782381824044296858444495836641436442114508798254022275527819884050205813610927392719427503886961325971042076759694523773397768263944949829047040250671591798699614674593280712438625552771672046770702177630021735604331681545328668356298896381196151818109965073540758004677376198693809341805742022883291609399453480948898873499293263877270932469009419431439504806048534024219695533951970768718607825512258459988039384671119861525055001257711440159711680468030006281596534069339905726514213495715578762483305792208439143804155140484955582807325734068361219604129672905439850247943374888325363536124220790929563183116800098259005080319976250005938202733026601423198594337116340040753176034747789519724367052821548790017492968600851467986834229393664397355394904449416596664697790294348115918027290369660030404309844866514596162383926922191583735197797285879017756435071691692579228371128194336880861331914026966533592778591975677047531809933445220376204094007852062763024256243247594908739310435742528343941136832141474614646195909007856979265090874937138653336279924669848945653923945059917473576073169113163591124139505027406426534299861184296286788678362064462571791247879481439224580152349380317895688368254981040713360197820623097965776497254219906627282182384583338997949322384688868753460332706063133692787241504223050921158385580293599957894628416295533076654622257184754535802725334290973325498566317654571663237347731966894722724226512101772153274798569796914026876025548743598732008731155930322538300118777605906397797200395073085079799720873331462360859558150294524673319774115422392855072805588331909034084940029643726834272412931634977220530411021804722158153773936709148601033954557711082063893472585895524019049770116104251942887519233166694790693305261370262098403931338638500460698273702483237833362913924748030573151235157079682103767162430861730648127306887340728587348584798432641373495081984444066017235036057867001084876034127575741046842705361078008658574057368371382290972551200828394402811129598512908406453163914133239324104176213439651911165723583312125404951908431958612444626832567425682382934966014402623844134480947328804898904457554990223633471152244935360846846872567395324752446056856314223580293777812792119222808747497257154119637357959526560095149732009525437166278985397825839476104252829701681188291604531178056187506204522297781410939426743458996516122417016297219533676135442588829970042448233678230743338567376323339403790517471808179478793371414460742848940080957249583920379222819120854583169254001656959488520268941651760355412230878512385792248057484840320339298745595785121144213305506256309005073307733101215537859103057428564045191401917751767528573372312728646224212563853090004301461656398621398256865950301741795030996394898498315685734194500204859005200129895914605961077480028024084166201706521017250564954091090761794215977943552136119569181253389728669786275631589077849217875992600354179303147875039054389958249338829071558805071696036014384280708136310202474257546110256018595074859205169417210438407668235772264489532840927011474245787805040250578989944089804487191960609374291147892392946334697862368311103975946562702804600592135283262705727886790284962999933595950396917187809872807890634995550768965917896649379618770995853018273642527941803602373748201162016424346818539699731541437191051272370389920430963850766457735997487836796190622801454117965803454310147963735891677695932780724907240409219933741153684518942237155171214800428187139788975348112515841498442346521529922874142809101317753813000222213844775530569928492214119218158311069973450417965826021228115913570997832587000507462134261658894622095296948660838891202843909918507703517052932194777950892934484326759830164241347516373904518928184219267625128730631587594616533889734599461176472989484051646992794549374972941033191680237511998366596928478133425687348377402191597183609913275115410415042943874922013282223036797766687562234708717228407526539793707192821641982045304637501898951672018353203243730498439561247010157326717850275842340724013349962837828262281859810432128342491502593655870623723538391476208736312646369716279126909024702322290468430221078966596856226868416199720051530940142548869537531144513871342122033366003412041325058744123643998708546094783795853752878277029993558821508050352135005532898315183427096073809860479404735696155895314871310840383963606002446025854182161994409438676534109631384937889800633421957669306238761422314292556501189945069931744515842623180008335951569700303152755271126472218857847432207385749882000533990024894030463892512867955227542394178393580753618051116929938385425024087970203342497063966957812547691207822897841681320712411054476647899997427503220523868363438443638138602058216412755412543898409102222405369299283907058054142505144252800800871766217740818073224044997682418836667094039746104705778772576150819423984585572854317991749574311863090200042587643440109185515699468359875803740167627895880258372380256331670270263041712499710565984020613035159213277572556237587993858247481402455200866484793496257416259856493587482957111225529071072537348695594958918648771418745755086539672404243468435455614922691041334875071267875391058155493338089472329161793182872605415502672937446879754623263952587889465083012515482974024506303700547794278667536739029569027539204865836091781842095979099980597464896983833312033418068148036099416870991217256675646972777065922275910262922486960982071022004929591359754288008776666205314556217272149643659129541170220989690332246883597290512968292817547469960138932109624850558843703432530540563548458251740803818389916128884564107380377927554030955090368431293751439829748472706494577940655099832463005901756121683476039133485795695397208495963616009088796806461291782584789937456739904233218852673930490171837518542422869715022557300014464253539379770130907001828679637745393742942924263739420939777245314275120477043103602195417941946982309000073013714022977049299652046646160515486071522858510125026538512532826758076756521229686019516236643861044256103454896600270127497654777352626796048814315579753595410684034930492848275912546385929478301905388366502770922904296261409762621660749049443869640676686234525730982815147070574292105084954509636183802284297900263494202277262106346273298509408501260925964163271527969153455344760075934784461266832139952514330249768607822250546116328645082232537397149287150870610226985594932674312703921712201689647303170983692623648013718537633610994267304884724686274443142818383020753736848287437672619884752757520891254092091290347766004298705684071656448745211379292411880056341949058778325139319915468910315101214860880624074088224739933628426458311629373094570056389962892015767941405606261884441947643048736689186423401799688135324726895945036118240150307617274590470074687290086181786558717205596918177872025497599170920256707122647400323893910027358803516743974239059498348001168404511372867956344817513606052060286270870628439157590311659998045156965274784647124177936899464082765921232150928558673393867832500877514025700053617920434533154013622992297424683989961395195164544773940494933482997619656975002955401823151470278628829447890583331692520608980058918604588771018141614644472760830547004909601105353723205204277054858100220843067696044358489288417053911779777636685862530733028148648527058888734952577662015452662713320998042221873897730242685299799949020919872610901220937556378878376264157771582659279927771096081291387570641227589263660184974304328800241026371644634693496152671628907116378044361348718616751343481441762999387959144794856149633766264287145359338550543502403574450566297906658227167549659449971682569731597042976899648193306364796761430963500027369518502867183892521528424714258941396654757315537208349927345921504783438385098575904450316533205383619867919490492230433428758373474687945215479480124116968494047912748080744896623860514834802919426785508712839994810630938135518361550388522230840646638453183986357427908650074058682630364404843361587964015212755669857078199544466122571728060539385378015602874360055774274800826080107259485947478571241263310480273433269041612018874608869206907030535684348688412466809171164973900200423516515617084359168072722684263238409355982984938645447365604915324694040110296398069636366148511098339986168750667254777835619946102408620138809371209811284079984973613416027249191446901665098739727142152623855284808133782852451728093569697499517366796585724689797742669468565268872539798878428345541861849015666331916000495956355163844447408071342491131776963020645656976892893787238149867119449591069976736262537015469780716243982143936721917630178728713247937607546958966361901328145570841011084562097642232937625937354868187273321107873039743053276603671355685099229683453605499731141681728718378187532065603510822624958972165532522593635204874376810200781275036766022437927240950798250024393364045682189134704845812286037422441193122739522406536732573140710828441743539780377865147861896193389749380659879327866275653179078947651387828111930396337490811270697985089816201218037506115014234142814682385102523425972998593072640770790725982414228544633029642995101682258901254287806742301366208828162477387463756687281252994501452908836547072102623355315709902776432554014376309587952657925497621653825666951796394661574770097931615332475671105408244630930525159146961999288995770715582728242072913256023911103584836889339253743344246510506913924657087924098478903888180830049760169862122162975453447015711932604661405562458098481070408233950340734255196874895090512289072552940802931818483030211719516961595929768810347559895680375914216324687844321700032530945151286243597286377866371612859700311552506351798213870409353454490411358344277477826150792145755992594822938766358675158288011584257616710623663101210097323109887979417370263612584058408561358753317231537698348461655660755380659581072178207477288688962757072265160490600631588197174512903146276684731753628694529596685824595885678007158393374747938101982904430961928841395951711676378080535123188351635638375470401478450523224920448602818895251564437834189202441655076943081483367064127416752887771318611109757781248425601474160571124303096368062074727513104959974456229598353065136721943994007941337054705132775534896527968122420469283611331960766006310601910252893459785872191278971330399395239110974562830357605556211522784691991561501390889806743958122904782088893727818201559345083867749044489168363772143703073453861134806218832960790409704879310579717552309996536217584965576262756407451564345833758720479629349944383529092132517915571954489963418248400511019703249483828204180370506184025113885649509409399769397711510007228728095574770224464446547044693015123777262159249799920884371538510122463960052058020131241942783200854033288826257878667417602086305216692912715536488620698053698022459949861565969545496357876743594887244566194824704556438285754633336308260058711894417742350590911910751979319176563052975803605412148165461044329096028626360061282229073291691883497842134279789428389371821455228942452798912977912958394511561774867405616536174458495043002980673610932445441383719655132197637184668163335110303541471123350976668674100112488910955928337286996714611124366551465792608110489076815010708899544256516556491056127346270833501757113609337499406611359404510795587423010608098938597650459332997781990621787924888569110021893517402845363268426339706716754389272990470513536737039987732318209821574773158004394368361313988432686443321166887644602545565041603076909330007914163941559127137026301018995229723135409029401064752864596947271438965582579277147631406637452843077049145457341837232159559730366551507472354953899625929803225701422561284852163965527957074334769617150236291205879362139935058355563169747778333904452955956839634568402701244925016745087651928608816736896469987882537309453244944834414373262938906464005059484038244572034326521612529650748538305485316521177247308396706868465169508059682590492304730955362364037150109353102703539473481458183308919847959243679572900240943426756852783203732123528501086255095826959561188972056318497725974188808836112899288753036602467405834455922655584156707363544433003151873583632491497489084045609299373141002646109273485527932587471790254082751973899027694147514158739383819684253034890946834373388441862051909883719721456276038041023850094627569248404828269211588662076341724107938139304211383814235573153888420922122069650074118928661037695827085823059008478593607756083868239999584244123010713329522790683394908267830112016051994957975600649644301974822906420255696156580630141761950629199586872747965112569565095469854869800403281833556388965700255873755860649520760282097467209698862605898434981759137733994266863639515406534007603175251563989668595260982955865634557781963224702857431711084062719151650997813779049906730415588122420262881103439896718580338498764211791089444646113690306378896098332737896635627635707772111276121536695313757806801348052118367819007399440960078665432399602377589467171594166195848994511848676342889852715337165791189020515662167204773204943614199127918332127383021743482576248998849902385077500814075914415851227356664528451616748460466665152976847232020446712913142880265960029344991220490001756182292717800761425879396636844902717038165543316666346164629380858250514747045491468395622679634227153126619733161441602334688751330958487543155598758421785605951110820924317190126071560389113736027517764010449768122991989484777981503183676348308768180078944633796744764632437921469707222455070766402087305156639658996955592139453843175790298794847443059643374415249421787873000204116964718653377159672324783600759484527475614449099007219842795509953657219555506013243218552996721200522560495144292673408433365706761513733674234568711615287301193667910837956568423438400639397963485968493623913712571443662496434067716848785221486690871940013498223030548187623888628374477709165936052912242994609169592340209437745724218818144600119064099826714575548308046604766436374108048400515726390133789845668096714784867008407173380319008417622029995593936143909536352013256938215644416531080180324802324618594097721172967615098799962908130441684305713015684547786299489529752824756501155428933939409296205517218276045889777478407568327206299474573691014209950666820875099905758278156965131476983278829571931391277816150330174477625273228440900552716318825768863185688529954386089451175385273662218329372749649446918354724443567025222349254449500617488028496361898409264103494905512190685896563250346346478211054441208028146386655248314336718654702652948137658435253312869829785373710193043688043958388972024841165561464326457180133203136125912400081649557668375744383899632969559862047404192319326563366004043695206668245499093118179837855729834168890145742251325448274416525637217013782454651636292195303239600214499858171679843470201696427000689391939448538191864553657744525021360343641380208086955930529022030426160885726040281673029309222840802065136346172382864319126701138148007706597835132695333947879760079153539055868548576156789850188497064536338026379929631234929007846807334812010645525172679991044333308985640292227558092752377643275995472992776698475790987837268792851399292228646489527461685929270374165049749069600603160046531920796900241727037869527459596145880819238533080519265651802795555015701064625591610129446123733504319175294781249602732333862539881844001174584054522255651608769617444327599828563581084600909669099440890092395641857086470399143117454131045827055159803551495132022116760892488889653153960587625841910867118206599437776258771080930144854653198726857646093716759295479410273617910942457821712732399190660866650490310710185557517394324308553105747144650750856879369349462377069251837917999202072251775088629659288184803660320127706626903128184146348671588370808814878328754655521943032817668859558325837576523141169778965733166386323397421920651468704737017814665502038341659575691927370030081718281672624943907725801459555157666049437494098603486817488433976626337340941222390329751486891908768166184463762670896534403352931457546379158595470562519774115429755212992688771218914551662191667783721153049023035595877690703411366361819400655202920269631805916454568041073107237253371890381490738743213309620059159993003849604331778047563116240972981607042015453452120068390822980655208034481099171665126640420489382675390866694573945421665672978524248517728079136569669375989021101850354217557422960696302555361297444201614660760149578194625887224649588332477042831119096972466903323569062428962777789251193844890660811230501531481978959612097815608680381821610023703044066176422964276045425566045824291045559057543333711029208777182180667218083104949199239136505834286628001776139959001219218905737418785641440851285017285337841944056173947452985842634788119839741235296336597559262487718554614436546822943903751831157623580674824591472930566041078221877158999849916636775398181102018674052880692512951698697513480517091515255566537032339412246743208266441707025164363377133880339650825219697569785046171337552332893545340847276858565496437706766030630722861762469516812573460899602135044490222233011994495526330459680983366359908902306295944044245771154099378936054217933392621460294966444315839619038214146393712002594553326031581417561314908364002486755770223569034363166238351234653984593425868697240971720773578144266846388819244504828181776390586079945560272760789021959416347716506857324409906002813134675432442066171228067068885528419141038131029179667706526774372963054478099683768936725773364000366960379562118197023510329482012107157344155875448591161595391919815262096502829728473187341874733253651529919979538531811286641534627778595530733985639584783830665988435302841891713116049103963675865435203124837066057645535281252657153315351003929269787455814660826997441903167459298690397042785489023802967671956590687562052329368827775864424049524191769265315949730487923955413049297486674195881931530552325062629106937559254886715285149290376041517510254575017089126238369735731441459908323625000391457129028083634733044760593008952189043595506011162821891237685214611886906091274976179324857590706091796406177625733347163004518021058299015360077008619141355691143129132531858006034134859471413635076801228545121952706746023220117837638086686354108957435599629954680243222435069621658931397374328297390779950081057015375721056239174253648058468325719338788133801151936515595963203703897529311280939274519350260938124229883720011888795447147955456430451126315978438040080489704091830058887795299872925112565712154018417162739997545058930991575800581788972727456060664226272478064852420923999507537882444320718854395590876566227281632171045068514052351501673709403201037188250295301734415546890351185372093093868842689894001551600934381797141922487365311721131325628216317486392434826534327444835813827040146040623702648032380447448136154616398503109030818895785037281436914811186726407883525589623745784053150256537820204779390766220428603926382471986845043607824571153400160052404381575056198801845131518390346351149303614811547311242885120974347678264504367422058114110590584616857433600543740991959073794058140903494097716255074997440636144720728479858818431649567101409884610735460498756656979805396736031128522080195025672224591817816046577402276820084711291274356314869576152330615815241767096386124487945441087050607753895420887678873857176400381643559607194474756870418606846938092225072149441622787084691405251105866384641135662322242739576886322176214547207279725762284255464168735963793003697380346821240816624664408301727144025359059144838660419650159844461274414337264603692360330829781038559372304769177150910295526218586671075425593440499090198871740910802116275754099660717081809348908577040588631693074984232662360693119209505027983812508319223671439887199802525968038619436452231817179841365769913890926114871474823986102558248984056751171047487920908703881344710413315117402556245735859539904885030456237268421343054705364347991234047913856137332488820079750762203668981258672591585746354112878783999551179429905553595428779319618205955760109855092613527644960822047320473227114766963811143741244543560984456111125291941526870369848525824391192559998244670495612381361646167116316134254469202262396491358927397506005317375010817174654504297216767011458286649844846972401675100964256583057423372220731293103426957596949490693959409243387593122271779730186895385509002372128203913747196497707222954185403205774019431819289117303305570247189365499173945821877882947041265338660691701329332190962248344273179360681417405107489124186407998243259234573342968597256163713209217434289027957190422218111924387788256131382512827800678950844810180746534889923898689642780000177422130718538953322034407815417934026037724751662822483375107800778896663583289121202278023801612863043235964927529347161048346388661293376210119688831516982901549177542348947159080101505257893914409911057786247888178114455119581370181777267188461192806263311755813332788407091502471672700680467132633477533561142293966656214747737409578555062844314602141692485230285966094671781847301987395271366469630767558062112328885393287218169191308218491026790992185940472657740498984495459678622709378403150335318468905992328881663104160804687882440812818881405288046436227297457076591968843740953385063083343962623712923639380484489819982491016361780280276169822287192392447562183004485125881771767301867399126196483636819125433619352232936820141550863954332722336201898117119322617189636537779715466381486919126946687930671216141452922541147106709679828617423994874259063229649123229518230937878691439874612244954074507844778683128526476317639118125371158467622560854714456375919537991303413072742967677940130456040692658489636525122293276481109808057346731810379189856938253679165389325994448637996699383494712921721075102752165363287472411045626443402092824653856031130579486630852299223562415803848929872524176136572203720259791428116844323532933588350929434768591652396279151377056649946904423876773164294300631366488764834105010682185485963623493414811764796197305673062714223556389869461430429375897012606458055194019727119699064615147436243860806192462008343479759672764808835547065006227356966938579183385683242312914357531439848379226427244818697458161912778146111681862542149788668492334979217146007920768310239137555938899242435302928517891968231720891496735372779516584037533540785957755005709202109126682981133492715169216867882096335742028123146922474139806442352071726795065748233286421357136259478075789617951692483512515306524891863357257717679489398290018317806682896210611402661100160374226086537049073243154990027642836396613193310176604504810534893772428808909650946232081171095067517581083996381726077971297100787766219854892974450821766776476654920958360090137474327967048906416972057811898669752411033820021430818244474866948828089694542481365682716635711181667411943506580099933345985254871356053492593961261410022611611638590502797062851727396497071058602567774355094747163736356397095850006997424923531112267182732864620909866113824820058603582958531094555020510236027027614431361800988521200399586673119547081726414690946264630190526634425644735734369461310520499007520355499508585543263341743900683573459238052117903500693000834091101712801538465402378378788144062565678935408582810427199506747176661448934111477635429452999529543080018774599929511274133290665853831807027349385053891990116923477073601573652090791807519295421039777391917621497541985415302633144183175238454215017098774097235275853537209261772618306543730724023082803885507581143607139751832537169456162439207812666381128402696526892293998914258723768720017499847984266585234913600117422675602853831759174426206891377825107340342701248119230213445536811698998359038183296563935302499327006034285845728896557943782923399556727004316890263067394203880281380073469638121484580199160819715617289728021829847401418693279991820133854136572587461373226302598594529298221390370775366987990983177009324833219732528831629990421797299223802093648161616663879975810476101783579393868468502081257564874766384664501509001183842063196032638224612125668482059082665228528142159069942060893915606313181707310505441794055294071663547920016602694400545595432136470930681411209271045562029874387463078108850054385998584637189771275294132908369193659781957985776433491190297689914665426509472196522411323928378195300561602310224530015347222547875758340039768542111436297653638278662369121460476330673013642837634923317515965253459144537815213719135592442299298816576373126634138038960909820457612677675783457258671339723120179633081955516804990831567693301696939699672015449317249971642551286584808129342788832029436801657018628358004798080608105909323093198784846845645325386979597398678978830345672780153323968476179576140696425471821998947380199201341358406139850774495886929512793237490160142870088261156365616557904316857668388922739833923102142619761438181312790544717406255524534509231320343527106989160031768626195806563471881286599066109601085681638916394858229430951462409147214901977476398310691648884105776491098520166157330063939443875435796943355719969632950102186397143687779839736579836206933338819143959159363406579332971362010077679786530037433544098847138689261158878246792507024969634114253622560056328316234987527324602651240456647339013865004249242977561395674701577956969389900249185989776680415380350732334128309923836114711035017617747769595002949511282687656602753426366555822017768660677216237740216507472925748667967000999718713527274444690963987157522627787202354721060271353729547313866987732075979117079846732413636459165812839433882317207155027374226318776368857252794717448645253705770992655896057862954179644123532323636460584760744250739359102987786758637467637353356965608822802371506831339109050545031443083639828791912591491173211826408402061094497140550687518456511418634831704222491420398551252188798829570316127890035938622709348295255719221696461602749283552993638948947540135681555161478489620846449605430044941872799703773058974361817501697061476133321363775760636069455030846228779531268123378895993835780337827038608856140980413745864293745914406340229750270769504339465352030356216744024238713735806990797168008854280945697224613839870090197940155282712750709172194380153634146926816676024515823584088231400463312382777203125668639972061892098691453960817235720605917593037228214044515858127191970494660211930516466145592663099310492447409876759547267269546121606395117066909754582947520241309163725053673240679714256180891234020254453276258233353933830411269188099460453101101892000756745988828048282222284444127415763956898935615592190117456834504468742950360516492684416298793335152967766928852074366733814540857573444455528985644845185065034346112640402659226060116640258934520978930605038249624160204759818066247093333611839083145229529279417098896841881437979538519201155777645178826287972935358996390354906995489934248530800713546948968183148003843919015314165041496161557496179086007896577579617867935268933548581362341854451994408726034928832137826659990639338937799609636453283954242809205539456878416214070953644356943389856818432600837207778616720748676938374167354667834832060534863893167858537784770073045535612859851873945303743454718296695298634664951824381963669712257445362562336753508214174025503527830539500054913297955051787866102185934642635331258792400637526092515185350299170488147855128705105659867618088688753087658254737196930525115823965358676681318054168230606026317957031887517498191886041759009170380803971677533808855847935963302413449922868960528689064335811771892647412655405511386556297232825727620645847030173878179578724353115411237535609238689560816107970307741703445451087116907161445232553198068240181847253666995114428407076706548882661985472194213910892387669936605281007133618963508657753133705642673696817486635123227343786590893113124229529397388254617250179612431485026422687552078010821860291619515171241168065674667610207596394151847581338526738718950716228321620075816773740443990198310650129401028199155101511828634637136915354619277160368249371381078808111483113736277999666680765128118757290998894150630894070077301710464719965589744182899605947453537434325424659568476976257807998688140297038415134478560327804024687366732279706746035700937983217159762314919697722630018306620851175305234116716106843307138903094060632759586446063354844094943376435539651295604866223836562905109269402588222614796293798277799468218379916416521276024309764723016595827980045529911394304000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.
    nrDiv := nr // 1099511627776.
    self assert:(nrDiv = 6662633323731567683137463770425046119972136130490599558899123904210782000048955657546048338089665562423074595372134746708823296293971339062117626089251555169190147414256458077270948527569093617282899634080762548342679827245086339014549187793286219479991932728270136570804297100483133701307636938694238970905034502371154888869049996596580545736458232161676533246213776471749761506965201454953608385742563840091139275162427885091025804146353946887012629948484423153743921621737866106228003445067333011961381320536910074258682909144677567128910488902078543169686709037300189304457148994986416728307763424855244492462783182558234861995982025264479668930619989751791520673311176554512802339256928913261821455310942897696812136624011889515033152342298071512274969356920005509130584511715402639886394993433908317400104247253605275804809213311644722625708569208536590845345008858415466399942051501903967025595429523806385287189963483817993580193128873368523227715891492147715101325512000610702205499988933334611073532341758081435343892524554804643431682872519021193151143459141893825137519042963177852473768417547297991124700818539000925406141630391619735578765993129524005603624473698812857747129288247152154569878280492149839872603436792477479782943819217222827905602197688669811923223236876518868169077065932115442814112611272507112872060586623457737282248353708537440207167545131324624997338441147538821782465377847014831893014759727951431431968895008978190868943052008828655078064891320004323949219391175626919627742850388198587106996637256185312818463363915808151256605758842792136336001326613101088899142459264924284800653801657455269721850699589180141531487149252598219454805868157021677473942233257684196639595334983355790828424192909541992782433644995416653317905481191664882406344528748368967757631115924249587936451097739407299792209435266919538221186568760660301420447293747151306991237865002378076318280180526977727975952198908682179738530497531431395267954927026964715297743348074891340859860789456898608224255025187495012594124570391779113664193099927268994661989714354273464562908966902793335276088839025616229178681024727936638794047725854753445121469971920000103358186939952444241621483187255438734831666410707469056761064049453502111688296190428340923841441148946475354163955033838270461267159320949165980839533335114464512294874697208511171752685785408153217445523193778985790372496161721264624578255386880658073907934058789510812259862184677985571129419404726995982428753663670210728075205992308115237575948883416665937774630699551861339250087280966997886464539913201627606531742484162972849780468425532497380768638445224373234076062753384679812079141062759905910765766089004401051262864330797018433052954090763672692099410879958238807338698107808012778508416688011598376942350173207376910229491087872782626788596807338691230630211536158864622893956734099080442020613927228902807774992144293064849356703912470587347365098361451500658414011543243947940570486265588687939149293725873385717495020907919850152172396648759758331493330026994294732515271227954608685062834699381201564024694020978463624585016140470976879181330265581934326720818333847725464851389246839097102050339237267017355400679094305414741521873249018386912379564657226367474609265595843167030823823815888307326919859008114043629727548060061462134640542960003237935595902000153006810199318514370026314665866355006060662101944184764882516982242954519270451909066555817897156024927674610449508845588002992024015689920157493765829176802821931631590241487238873985285696003426340287794076918847820343809440277189797464887583441187676629382340618054613952244943532083179065762391482344807692465983310435881557512776871445023245934926397204809407259057481926925852885928369964436177662848362828687829863675543005561550690069465524227034464836091588464269332378546107140912689644468971000647070233491616299386491375149772573753171449947304356213004974407827081491882519644546780260294370715784722926779399796198511750540506872925851061282487638657519313905164405423591836522816111495281603995252289872385086476469229310711401528527506301257816056801709876959217865896545758738590541706792036682061363760042257088762989112039152701520742768623568505674079807810875863485081257794882308576605276750150366298371039105968353284329219873078273054143543278652910514327315532991571113396292522800982678225773832322663106505081384006672724636320985174081562785472030426212309827534624166323291136226564299729779926610904852724095137745669038747074706380810381924397482883612399986254740569208516035970744086352728731611278556045932012031400560563908745853060950689115708469515692155527082269323865892247308760070844077451853262294943617058144830374014063090229211365020886204814145346309426230627122487421279225644442725951826590928222475412083281764588227804815128066475027958454121524220172577508201782648035333837955540129683619410765000534937610139700875341476734142047589998542737528010306112593043148198988006188165170845763794500602249285494318364329213288147091824616909725569939842842543596840734083524325194154098463289461537667911688662904500980902221288027220544655818218265475837746996472010236584007176738575972462375026150791464142148497925800115687265675808142920616038812782060447067014154305466101224458342793123964105995474584535180862955288460196781648553085262219550209211207588026816531112456709030305544360916191463216584932837523535301571859795009182479596217471466926212940178314362383320867455900637582040017075517949772956047275866807594416084072169300543338235271482325223007196166301392848144570452154384977210957293114632528390739972304218279369363788615170503593817472053417243282259131772615839858816679000902088506393860091327261674653574046859271748229366456048072374228952936986954461812960776844852566037819383835600381330161020048169786575176406335437161125603009418044684750306284400745015540086325935345626867567751378481969009868769532841174689642757402653727086965191901579737800170435839185407005418578658287140871751975359929956215389060409882342023572364751463302859267203670036848697371716329102635164492370580294469523800234173695676967556158058431931901118142098589725146905128352892769397385982936860912089503320533289229159009276510219167066390676852427014511459354368805077084042375052908754180535991959079169140810351777905505393392636393431646479931302422033114524318678899414743110703321665415570194813338103931163016485158053150293320176682849865950119830732697413244124732414049420578484034599229592065444814927955090765319822680007274309290373729622349451338071624805845426576853103003370567780916419402325897239482929120438541569564424943334867982370378410776501847576669342499380514197733899878037687667052618283223365943911896105902249524831410057706578101179674765029139049616899153094252341846800968999185743059608692632244338477301941908375137612702490034105885096135690595893486578406810583373575282511613130846721636016131016419385094668786170270105099382118058667752659173909237179323408143996490057471550438372565855669568075707259687274506958695435449557449093301254608165917100788931501161845710670470989502338362996305132945287246866702609436316376008925088459078082627911685321128243349354229036144786259708802466926683070160849866228958572801968143008687496651087821709717221337749533437341262096267973190948389492727237032475272862079136719557335553937772424498412907282167253204658036522663912861489967343545754246593032273458846618876337536007203682712249257269146062576546910876450005243718339617735736623482032784880126505138707551223982569305519703270511483547382579404918839636852647345161672956598447115365954967174398002999413589275624553356118459301663295512883021676137652660825734676124215499674882903247218052630206577642084012432827740455157014364420171474367291740649414319526344397807373512379561085192818359161938505367228336721095291925155065811136228538259401638220286361061736441517811291787368531134060596121120227508274377982866581596616462970013543016021749257061326685130571812001938788851323431118096288750404400065801469551796490885764071976072881177700325727466583683008951024461863889728341965881114787320729126972054716702704109258400053128328990837507682205316986695881175358221798319366772405548254243978588753267948484911744969711778505544859566371008691126381031647673694280468482450520966964802539436922158737077121750002067704209950517947895275485187950536800011107737855580525830416272726621826086807998163498280837268646635732040394769166712960660791026071702275406585969427586620725056827465122411839751932641129741050664123546627575912560511096417077652349819389991841973046133599693459503547277028739085889123201599430748088793537859468190507211174911898362104739455512577053830969074103537490200197207200049611998015566197237458603889177541028426143550097544365997852341124263498329937465890381606795295955418098232523840580315613869908469965450988802338848428525762122401606821882953426082028665593848700047602082113394220896647213988097023709581111850996949900598384480808761859793798146684096848272987669550104826786271426406384927141254967004421494402774831090228439159876359957377770662840899979305879736692449207314353197306703720694762653242964236415719707807709474598662585817690053244256584634094675588772387320728876893030232700378159568564796767815881221577040003142829035992250009683957501514432958745506657813505062455380239289536840908567419834056655066010679741591568523506419291023346414842722152449355047334627139443779463897483726315136235890415753009343093216483474653995240946721005159273994166538118965875301947867114969329009355586236318538876250685609005070430253377255824432219814984476455677020466705546834887611998078233503929866669094433324734408933206886290341422947478206056966064334662828420717990695296446636482902339973289591596091373182364602203890422888673967906434865718458245218781812358691248643177646331019984492877159627032179896760671627209600850253346391553616574626603287596419349597318213312704240279836597936499176049259238779919659359224267409788742546907956321200282485507559458481839743848993694568980420138364844893768971338467175415458491804391538574796876754405099255829357011671106608209724284478263756619062561946992484466017881479781226530089273673529323906138417286165020182482970033492405254420136568337797393833604513114189281093733322434044566828573546466011111351374026204357974607838989739784779000309310988838440677460786200468664461583688408649555734386828226224795341890764896222022843007212559090108162021383514450324833808323442944564068880379969871474643609232099524672432072065066171371327688290179617734777653046940553660629197979241904416814835983950855274272068765736863745858963201045536085042989062938403688763487261963686964428476887533136063512074332363974690948558717214002383604926898703662000671308292653459533824119645680367911743181294681283019279375110761642291430932623265766493454469257647709146798421760001872528500721048437772780065726775583559870942098046438397119753740490868306016527691410327914835147693629474332656459501972550133927210561728079422781253432105249315186092695867012382237378862014890057147969807959315163943016544546298690088701484361031394763122216597928194997139212034462694811542459062553095389537586038839071235015814370056111693269389352305878495387099950893625189881278100442169827936555834473905275492197948797975758169884639129722925686252861191664712463696502617916924251331904225415709036855212464161811580220910449150251619842632875245719603685469328376161861492205183767960018924893683703862737234341532850039837857211248675033249758162682137534755933837705941315666354487585368176046276495167470532765222994435005694159229340308269782771538682076344939357692679425354738694430715010693246526855161993822050738084109068988456669010456828514452172338697819097988850645322196559280542955237043845644875480294191294243671628138352015652035502147832020273418517146314693212385602848033983824623687143092609964470596861648812591181885313558137704270635608088146327043933109509820109861326543893172335781445926340867738481148623616697386431217916074089554450405103150269058917608330277763824073839949907229906564057762087349990311778587768856946330357372471841275187565424737767435082996992995284357197931917849454730570975669701554500305138158088651708126085216389971524685018121085532248742434165580153047378399460873550609161599238566767462611149933427772707403493393907424627064456087353573406713733285621911399526086839253252364920421564239246508902633182467505840796787479557927720879016862471757675729538193109452262750608872435631538942265160767804915408866767719853735545879556628651112971951932782255758506758251945975744362293034679502078243875384929350503323125647362412515669719705455290178369806457412764733465715860119591022250156219106181326562931513112569640527774437694546186046408836197585138256444950223039512425447239856838567382824787147773363964308297000112321579912390413854219643773041550014586978847525545364794414262966819887507035652321303620752105217176216667343339142387440168685055366893363995549376670079553282967791356972668015843949376745456315682701891383756331415264006206237965084878941733844343257714837038003432752137257495692759685719124680847167412614538657367006068680166919216423380951198784933649947788603088487475981482143383660343066401239813051800174000533422015517445025423914324655725411380579191151076329105654312915546930776739081083130851209560307261559808003595454190858699636192994182698489579919753682299765480387055479694566268008903344458287769365183187828409240957337041346594822068020495286153916970285888477298328581357959138997929436797741893882044055962890321491207955092531472430580766283693859646215925564679002104430854098259562738959271344578729377212911592288946202639427352171631575468303031833703338256634096377869121483169247318904967557580606897753481360433243071165788807886349764388293820695191793366944295901792867034972217834675333738411495592200037471295720880155324101436263128307034059249353748610108195767389020979150086248268345752906071488861276742315827848748423651031498876866413731293699920942666225974254628767337160594389199237190034723264888058437168327407572709723914804838989858772126647736411522980570465381410084236050678330973124991667963023842876969302469279748200467545110485810034399278411447631362160061302813940661759884034612358568237683981191908865801458121853442888039446172937851735631594598045659655670606785063854069117622544099869154206792904842994724111936422163524033921205447454737571280459967114554653337916325943852925554693909749040789538931789414251732580009709193386661331220447753688008685205153591603394795178887882480498680277349305852539404087412513732493890167379734424193689730774421124197396598209807938986005281190551806069183559876875280125104661004987176879496554550976559950467476559304258484634527452519381498017040813588033614753804422807393056528398772163482132360711680090004176924055583698960466571152646455948292335532725821865747613587236595247530568040947130838943692837511089697894954146145800686471738817451943314160624802839788362893581912928352442591061642144413099049343949783668458733212864946888676178097687428090333954322728693913329532371868758870453268823927363537857721619750427589553115439726294751268818431424046653951176908373270894803348106787107152478615187412606784084264974789511303754855340051658833679689870263545431979424720394747263593027757345678621399456268980783872231272861374648345111361698362447451983621128788960537508008651496314069548689924381907425158401685801106563911310636385954732278263100830980578484843580473312548144610442900203565265247985546564550976724435723289297624666247935684674418868117603325806261281593378413719037238943924955877274085741135966282362763193106721357060382514254442887152906589877023423856680625901166776450727839358966536601644959153609144391132902459862060242188807417448009183469264503039581145496052228654052676496725272553819319933882997243226530495493561285061107687030878215808993975387490670647281729045828867173573105303000586136076645167624071720961141090470782549551314716665078642257836261666920413308268644174214574267682237346033030519874726249630752547960543633630157639983049125491329584885469201996544958519723770711888804039467535780543824274815473477301096898595071283422404678758221733495070552923171978588751150443266365227380501603502573111410088460947042358483807313590240913510077173949793948813061142184688143009613447113936857687916497981028674162941533323818450350080181784482364317988060883443497947703206051150533242121659128958857349455686882605353850969092935960402982618118713619556828483369397811281916611054914712416483805731465976494964146531569215799109721805847028410300528694173153527532373153045249500878187581518800314615156447564073770740022098961439234138937750297512946800381652855912829289926467970595537813845166063837126428330597144158673094574735851632185151893903271146216711815228383779829505875249782822697691614321461835203609216607002918525904157716238810383010391065426897393809125134642778347338844701765770751671444268397042348815101706901167231064172608725124761680162478484393439069367788364606593491099359158275214720362749380640577721088524470104995681138292437981278208476931579225731985482925571630931097842007340469617197091896460102706347332362145513466773659918337317572988046499916670479070806370253529002190952670353070666744678967350036570834703676333309881112517065360307108417452733002563964433340667896821473681133465222881870547446871335962511010619755236243761374511519456442193793333594411207392794004105476372366726747732579235992618924015878318955393497608385365476617805871466249190595260047214394069820212568325902033965922654033888417912286484711896882467251228378354183552293400075258206316865187130275079433360393164503976387026629881917025668725831325016331687957472029777811248536434487962818526601321326034011639998240520767133091723253262191478889477732161417549504821178703052409631566820999340775276726216946712534308446072712286153652680439930352040093862145659622442078648977666579419037446128195327816883541805521638906205222812059694261274802822911995857217067861269000490423940129053596411898677534589257055289125128765042939890889550610075923551852304168673133714809214526655242363576702244447943074362796222547671711899207308354482159297375955786574385854460819445028523296167863099823730022352090642566296479684850099511564373087943558717295760938927621289992360634932091140965012523878555060864106373640658546915478306374170806816257322333143836404972687537427918835335849909537778979043364004415979697596187929554163161291338782947874465678267621156819384376292481035494619822724135714643080670449194349117313575477023852251462157100442647234811207590910430078679631359082941846933243892425583167722406828385000563844537531315125606281753470690926728570451420660194661881586853830856879082022622614444211189862027995955847075720472590981636180405264920542673876523908199231895835194289372937814963109185400558429783080140339774478333285537556699238361330987736558384436762855693888604544252644467982372255364280010369297262804435889271193485633563494271128632242998571978869071398448928214066950611845110439059878457358040260838872377738188879643075650321115830111195188171223607598166789592316367410292281897474240707780500277373863291840300035279288645802844513739755083609307623251094215604446493961519719176201768010830924261149752008240975627953538656464432802892397239873841558197762448235088987744283265644123580215828629229847756497333042088017137113845417927907308370118694686418872787249521013870679592265695912127418059324065039553961809510883312277292682811136302844531110387585647794846826942508306109847156295035588893190647972929310585300837929143605036855209909095078529616878524697187949533912616220353861101335179781717322334159325535950830348702683903956713848030991031789277686038206518291309335679266186892665696297646824642372383904924530689265908078515046434592113144186677137514316332139654331264735125017720528644967462490620083319716124344933995590200417291717086036610960506908963278468132327493231742534480298990695134370300218432020485190379781750952733353355873678374453180937874211107688414514621736824496909620169986303101752871651896892513684703338313893053933255183789081818233099194429728174343667583800232334087537030361427268946243458842786771044962553296095536703477989698602508257697525945310759504846774891475733740196021161653485418777347759620656145992080798847727381685645525539961559324870188895773727580412516237803781935982581716437412611301343261776643304819481868619659753341516913182720637517474858444413157832505693243741288479267641371737999729095261543591838054428973561736725472157668326318183044945915784847874576066830414147706853941955038585159805208300597749734377901157203392876608064388184267818682399190422948501056958194837938391733278658784527755984424606731034448309440295924193353554895405585796132948214826002362174122627776551327343879146573828709566085927128207558802117131623323460157076665769242068403665185141160275937828400136620241192456176652835846834240452613661806597521514177023165047302341679295555551508051653415609814912335474376911818568116936865517199968267319797266790612855146314008776741341483924545019506352746861761799184869747515293258290656922190388865397288264923207565564444569202307046632552992848187855320763025731448044322626818272002953585947000990139604564002024944509293877714454845365556042038716302410519861492901060742979671634076805703004367909180382050303746373376482562884571531258606847571505895674729168873404018309675988438701948374926299395721307787395239134493403106002139242002160785480851729136172763278326205183918096527325878045633695581592505417560999763617198587755156744222535295963451807660480724900277337461447992209534969141734072233109797259073570248716353319773293544532922325041060565932210392148625152030199085590108347217176792108238881854901342897723225511945547225075822119388548782819368313852606548106078809355851189880251783054363594122321357531048537249744113050418065369091565603073630514273403592269082568082618298317632108493592673811785028807085323208525403120854794483676644319669608513326174279234197287824669726834966393161538408455310478065279133231953852910635361742906178576755214111517056327801824696461817882594873856805222646175203300964795337063208197930123387100035611442898962537621189321957513145288545491320961201783084023485230318684859529665194381535043030992718697406456699814963178889130392858728202451771804840042186083208062615168997950766084371341242335363877881080966617516431705681821487035566981405152551846308469495319182057575043059043266754766612593919342214655158708509550193047862153144017813642739949190337390404536833912770771422453449645873712360457151269709782651006515869206669914944100670221090425818628601774379853413256806505273043406959924949474450066150399316439803729716402849663145119931714415440906395699971756190018053547116471909246270169142909777111146276158913184245342769165725317045526866422285400296863663896924113569981788011574855928342975415991851606735244243464910312696061102300896479291942510255551582184891858463744530673406535967971578872825659092205865479824130931221984452835683846238511093397524783198334851506279344401387929443807027481880885621453705681630631089489476296770158650928120354413431647606394294397787931502924588063599432632004248814905232532874069922767722869190218991066223241787471443921552795301565594166172669223986011515539182639311651756170781133603153285133649653252244928860946768958545104628751685086750644332576921314119710268248219481287934045631571968130610735349124325810882583205080365791756610466151484981561971003167210505449761394244116973473697036540303439437127913553092230911492056676149949338521015670614036534613837352259788911948678049240902575683723282770265260665156443670989248071839321931056089748674072520359193076479425403027075088844834493105461097317694330573999345150061096450395197333950671837028176159805717611029046806473790966566257139710214116625838120990838702278978040950346826860768941596869691912534837789531369798770098970462048699643710814263334282244825464986836886245787380161175413667682434097411896621020758210415293844773093205586852281989095832718586711802332595251072220032029846195189676026260605198977294380817877532759426557768078860163274145878332404258531245748591785784732434092195479770525481182815991797959825445637531042041590611915627213811517825520630848877424983543969674297016002608547715519350568204779042177473285067882211063589224482812938087537556266733962298371253557488669907498202166954216996752726405369916819110824141254269240923809780103852072731728780585669680264810684354097106594938306148015694140288412584934322450220045927342286585818050261340652821302794356397253238260769202499770588659806660140473202066417966673912609639439160027102210101993702837140062159911232700217576203854458672769125159295245759720586896200403026721146586614053545788918421075536183109733062570888899435174093277080789621706770150853469920781327693942173755821341587589068464271704145993398599584907221853546360342946465638677014265280400684536972824228071999739587025848471588041430734190747718105615643467867746521139598415490025819320522905508995637789651392767316376511141387782210136045154208122686266311800762358065599182356318289546167933132158219689983303226956912482902682742562956882890951086189973976745290171180581408168481701573057620693909613412402204890864681757904552161551141827082091941308643128752309062650317371816701150436066224566268088838544515729608051056365801398632700878033879524508762180929699446191226165581504065642383358322411410368865560901282689855037225200599153216302477288730118415860928953243258084527371265976649892602187894583446506824661341966822666806639851892328985271557775491086085232594029385055865408461916306201785026239230612752353078156174629354046816769484345684696264666983054596622557352665971692310835346574330345201496241524653879367068558567438787799759733850664614404312057082568243566243264611755532824513206338793606426398858650893765086655494206257608941685693604563423189826136067320528442662007709432015815995036214543984892269361804846433637715492042002645350444584698809568222374258222855882789968774096068488352877738383142437491050195487809265738698926470769757932536635347362729215411426989493149132973739280148089755991263176726327550836049914656986188523756036995278451253055657993910940418752312028175505678115214204318754518113471033399453567830296130632358712878292350291176995772240851095811885600382819425746733946859746508324478039308526824527611422610279849667882833495985958014136406544044904587156035768010650365190466997906703837332597903821402668562989161094199987830477977441561503597197569903604778604440785745969156513821971317777734960593729892222534437766021930681857290367110308403828050424387397529924995329948939921686795128871033695479567097677596871009758030829941780656916571404797474936364060896633110223920424892718562704497565532610704069917480058569081099089548670722155086358551588683391157320485122061215935067590527729478682246827509303529818583205679553217829813233875900878129084480249700435621359221893555421656631016079536513126020731283339909012365473738538062828153338806425078848354593519707062428992917258579885576722482493469235679741940285114466917413417283111876766818175178154974443863226366736031059196645787709286298438367096300335933725467680069467499909440931418935197607639590412522403641379231449900907670483429271445608187324020277292393554157047806016393560149763762182381033522232890923572325247499885048067389323525383500510263730424495499130718179426732948176129997648391216839998908481381658481720639121202961279302722168225045179081535042109498981072896761625693992602288769693937005187754145411851890095543833095500128837825669543033101870261359674246173474451228851808299126983017321230451884981315322155989426954244248673352579392307130099271620208255400787072330291414290702789609332401962725750210933255324797504516682254234045089348533324403979456676711927551725019997708120073528175550873441080737501788656523364635812866580670909840195177187069318284588267347979941912802844784345831364593611297335034936808260937486987558839356538174069247197363090244587530678334043312764406429614731545495099078344877149268175885053368093750005550979938553594526646815969088249884254428243750041746556055016888568949674554438216069776702697157696519299935296262333182662282071313712716657449342194593759461100188202234751465974594013604537342017369078900004007398193157716190449076813514282475822804094059889026022698518255021018566613789118518865859608084164256119389391264701034534732838558655538866932858543792259691591598582535802657208941556924876214292388229473818284170474930333525978514942722320793145416739308926751303841482388060395770004407198042502238999916987737347202218320069564664408185847098410976119863674399888748702288385011759248916565214546843591360560021875820058954120036097112067812578695283900444351683579270658485758109768365219991018268073673245141452415153257605271035668837906171755807778795902163789814583104706779368230557138443440606785024625551792656071322197883437365090995952783614348640636205281691939705970217021667929894789600090514708714961369322666305228197508897774024661140458911672537766440222671471229951151624033617881679464177246524344329265010491386519425837542838886652005593924469815109793867033638413339131777000951938840890851243026333877482047177068521520544305276389089112946918609981082936282961399989478134865584383041240801873372522978899733132202333335987926642791396387737460062342731173436754915777886939051823043272012214390567646298815125607368226168423465650669620628282859526350836831070319248452496846476074443081172225109466966238064479543952636729745422601763049244880363951554887868547504711176462185190973960030994451631839790904451546992926093730097537412791241442962734438292246577722247574954339022031246782698069255135790093514932928713132636296283824008266832812586268454522044334878454397088449487448684427415958411238210941094006226613223371481809171527041133037308679802333566255552440291287322458475809170568522887554612352531686985995739790461654054890515084932431410095449297397334371300261611842343335002853735931084493419009859313463150746745937117993181979237854420065153129725284950418550289719097671413347458337380367124698634870313774680629978154230863821318174197007261464601533093656004192580013539666996526642684130218028293355797487475150542981549502578133197157285640759714023684275189549422742879177088739931596862486920921838596493421040431594601794077020970428521385813104989350571619913186328653424264834109846015474715734651184107559529340562123342071075931760092972222917153919505120979479996210276995493277547148424188113124421851635354366780917880121039406318342668232723614810087913563184193944074400000020651241097090115446220825337562270086194397603167464030037171560664411210284016084866369808922429203707401145416737524009418498819459380189832249442354578023256629134645025981931351423342611135080339166792819794476094517020997632103158198364641168737218921911389876768461303546227036899870881483511952646784326359096061070739854717639472509669848383820755259857413438295366884308513205076426798185817815788056573628577324171420253648601799962441876999872888804170580893843687132338423914822285568896284471765223814674175029590016487790058849831286477480407475595110497851792057602582603288109754011617841039164041788939682140507881575497413757336997711464163036851800068102118379858493913037721693270703130811009983095221159466631384296982518861383773854535925194635985429767708644654123929591836266094263942708064706075219923980783237358798820516481950692318906711800446498751709909979900020671710215406281991004707258633142090505396170787878142555678201300875442645229957683266757709158189715737432850344877702847733425342431295550047738114568208344247343496544929502270432466561338343828440563277268125158467734124526783241545350253573063926687226489187301386880367871743773831272945217558791867709670520632159570091273556679942194188558690863824371652669539531915581994312990167794769961244737657221122396671143145348339888308788106472726956314213678731306378350284933844004198724531538225392232209225298926342191000074318091592696527655035644027580633217085239808870166459729569875652231485870496109437295505607599301574917545303951011217758746262472258090053525770922187145661490148423928147902289750267060551777528126663244728440341531399236037845248645045749494529414359698587668031857404946489919370523756221679157359175122237772519306540269608674683717879240004803893267340482396305758047458143591664086334293012096942379962669398733948440446637417238944756499755791140482728310365361208405057637360065404060663154368075449918453718779613880795113316906626929645900669151442129735202430154440704000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000).
    self assert:(nrDiv * 1099511627776 = nr).

    divMod := nr divMod: 1099511627776.
    self assert:((divMod at:1) = nrDiv).
    self assert:((divMod at:2) = 0).
    
    divMod := nr divMod: 1099511627775.
    self assert:((divMod at:1) = (nr // 1099511627775)).
    self assert:((divMod at:2) = (nr \\ 1099511627775)).

    self assert:((divMod at:1) * 1099511627775 + (divMod at:2) = nr).
    
    "
     self basicNew testLargeDivision3
    "
!

testLargeDivision4
    self assert:(9000000000 \\ 4000000000)    = (900 \\ 400 * 10000000).
    self assert:(-9000000000 \\ 4000000000)   = (-900 \\ 400 * 10000000).
    self assert:(9000000000 \\ -4000000000)   = (900 \\ -400 * 10000000).
    self assert:(-9000000000 \\ -4000000000)  = (-900 \\ -400 * 10000000).
    self assert:(16000000000 \\ 4000000000)   = (1600 \\ 400 * 10000000).
    self assert:(-16000000000 \\ 4000000000)  = (-1600 \\ 400 * 10000000).
    self assert:(16000000000 \\ -4000000000)  = (1600 \\ -400 * 10000000).
    self assert:(-16000000000 \\ -4000000000) = (-1600 \\ -400 * 10000000).

    self assert:(9000000000000000000 \\ 4000000000000000000)    = (900 \\ 400 * 10000000000000000).
    self assert:(-9000000000000000000 \\ 4000000000000000000)   = (-900 \\ 400 * 10000000000000000).
    self assert:(9000000000000000000 \\ -4000000000000000000)   = (900 \\ -400 * 10000000000000000).
    self assert:(-9000000000000000000 \\ -4000000000000000000)  = (-900 \\ -400 * 10000000000000000).
    self assert:(16000000000000000000 \\ 4000000000000000000)   = (1600 \\ 400 * 10000000000000000).
    self assert:(-16000000000000000000 \\ 4000000000000000000)  = (-1600 \\ 400 * 10000000000000000).
    self assert:(16000000000000000000 \\ -4000000000000000000)  = (1600 \\ -400 * 10000000000000000).
    self assert:(-16000000000000000000 \\ -4000000000000000000) = (-1600 \\ -400 * 10000000000000000).

    self assert:(9000000000 \\ 7) = 5.
    self assert:(-9000000000 \\ 7) = 2.
    self assert:(9000000000 \\ -7) = -2.
    self assert:(-9000000000 \\ -7) = -5.

    self assert:(900 rem: 400) = 100.
    self assert:(-900 rem: 400) = -100.
    self assert:(900 rem: -400) = 100.
    self assert:(-900 rem: -400) = -100.

    self assert:(9000000000 rem: 4000000000) = 1000000000.
    self assert:(-9000000000 rem: 4000000000) = -1000000000.
    self assert:(9000000000 rem: -4000000000) = 1000000000.
    self assert:(-9000000000 rem: -4000000000) = -1000000000.
    
    "
     self basicNew testLargeDivision4
    "
!

testLargeDivision5
    self assert:(9000000000 quo: 4000000000)    = ((900 quo: 400) ).
    self assert:(-9000000000 quo: 4000000000)   = ((-900 quo: 400) ).
    self assert:(9000000000 quo: -4000000000)   = ((900 quo: -400) ).
    self assert:(-9000000000 quo: -4000000000)  = ((-900 quo: -400) ).
    self assert:(16000000000 quo: 4000000000)   = ((1600 quo: 400) ).
    self assert:(-16000000000 quo: 4000000000)  = ((-1600 quo: 400) ).
    self assert:(16000000000 quo: -4000000000)  = ((1600 quo: -400) ).
    self assert:(-16000000000 quo: -4000000000) = ((-1600 quo: -400) ).

    self assert:(9000000000000000000 quo: 4000000000000000000)    = ((900 quo: 400) ).
    self assert:(-9000000000000000000 quo: 4000000000000000000)   = ((-900 quo: 400) ).
    self assert:(9000000000000000000 quo: -4000000000000000000)   = ((900 quo: -400) ).
    self assert:(-9000000000000000000 quo: -4000000000000000000)  = ((-900 quo: -400) ).
    self assert:(16000000000000000000 quo: 4000000000000000000)   = ((1600 quo: 400) ).
    self assert:(-16000000000000000000 quo: 4000000000000000000)  = ((-1600 quo: 400) ).
    self assert:(16000000000000000000 quo: -4000000000000000000)  = ((1600 quo: -400) ).
    self assert:(-16000000000000000000 quo: -4000000000000000000) = ((-1600 quo: -400) ).

    self assert:(9000000000 quo: 7) = 1285714285.
    self assert:(-9000000000 quo: 7) = -1285714285.
    self assert:(9000000000 quo: -7) = -1285714285.
    self assert:(-9000000000 quo: -7) = 1285714285.
    
    "
     self basicNew testLargeDivision5
    "
!

testLargeDivision6
    |t|

    t := 20 factorial.
    self assert:(t = 2432902008176640000).
    t := t / 20.
    self assert:(t = 19 factorial).
    self assert:(t = 121645100408832000).
    
    t := t / 19.
    self assert:(t = 18 factorial).
    self assert:(t = 6402373705728000).

    t := t / 18.
    self assert:(t = 17 factorial).
    self assert:(t = 355687428096000).

    t := t / 17.
    self assert:(t = 16 factorial).
    self assert:(t = 20922789888000).

    t := t / 16.
    self assert:(t = 15 factorial).
    self assert:(t = 1307674368000).

    t := t / 15.
    self assert:(t = 14 factorial).
    self assert:(t = 87178291200).

    t := t / 14.
    self assert:(t = 13 factorial).
    self assert:(t = 6227020800).

    t := t / 13.
    self assert:(t = 12 factorial).
    self assert:(t = 479001600).

    t := t / 12.
    self assert:(t = 11 factorial).
    self assert:(t = 39916800).

    t := t / 11.
    self assert:(t = 10 factorial).
    self assert:(t = 3628800).

    "
     self basicNew testLargeDivision6
    "
!

testLargeIntegerHelpers
    |t1 t2|

    "/ mul2

    t1 := 16r12345678901234567890.
    t2 := t1 deepCopy.
    self assert:(t2 mul2 = (t1 * 2)).

    t1 := 16r1234567890123456789012345678901234567890.
    t2 := t1 deepCopy.
    self assert:(t2 mul2 = (t1 * 2)).

    t1 := 16r123456789012345678901234567890123456789012345678901234567890.
    t2 := t1 deepCopy.
    self assert:(t2 mul2 = (t1 * 2)).

    t1 := 16r12345678901234567890123456789012345678901234567890123456789012345678901234567890.
    t2 := t1 deepCopy.
    self assert:(t2 mul2 = (t1 * 2)).

    t1 := 10000 factorial.
    t2 := t1 deepCopy.
    self assert:(t2 mul2 = (t1 * 2)).

    t1 := 16r123456789012345678901234567890123456789012345678901234567890.
    t2 := t1 deepCopy.
    self assert:(t2 mul2 = (t1 * 2)).

"/    t1 := 1000 factorial.
"/    t := Time millisecondsToRun:[ 100000 timesRepeat:[ t1 mul2. ] ].
"/    Transcript showCR:t.

    "/ div2

    t1 := 16r12345678901234567890.
    t2 := t1 deepCopy.

    t2 div2.
    "/ do not compare t2 = t1 // x, because t2 may be unnormalized
    self assert:(t2 printStringRadix:16) = ((t1 // 2) printStringRadix:16).

    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 4) printStringRadix:16).
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 8) printStringRadix:16).
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 16) printStringRadix:16).
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 32) printStringRadix:16).
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 64) printStringRadix:16).
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 128) printStringRadix:16).
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 256) printStringRadix:16).
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 512) printStringRadix:16).
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 1024) printStringRadix:16).

    t1 := 16r1234567890123456789012345678901234567890.
    t2 := t1 deepCopy.
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 2) printStringRadix:16).

    t1 := 16r123456789012345678901234567890123456789012345678901234567890.
    t2 := t1 deepCopy.
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 2) printStringRadix:16).

    t1 := 16r12345678901234567890123456789012345678901234567890123456789012345678901234567890.
    t2 := t1 deepCopy.
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 2) printStringRadix:16).
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 4) printStringRadix:16).
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 8) printStringRadix:16).
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 16) printStringRadix:16).

    t1 := 10000 factorial.
    t2 := t1 deepCopy.
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 2) printStringRadix:16).

    t1 := 16r123456789012345678901234567890123456789012345678901234567890.
    t2 := t1 deepCopy.
    t2 div2.
    self assert:(t2 printStringRadix:16) = ((t1 // 2) printStringRadix:16).

    t1 := 12345678901234567890.
    t2 := t1 divMod:1000.
    self assert:(t2 at:1) = 12345678901234567.
    self assert:(t2 at:2) = 890.


    "
     self basicNew testLargeIntegerHelpers
    "

    "Modified: / 20.5.1999 / 09:41:19 / cg"
!

testLargeIntegerHelpers2
    |t1 r|

    "/ absSubtract:

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r00ffffffffffffffff.
    self assert:(t1 digitBytes = #[16r01 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == true).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r010000000000000000.
    self assert:(t1 digitBytes = #[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == false).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r00ffffffffffffffffff.
    self assert:(t1 digitBytes = #[16r01 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == true).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r01000000000000000000.
    self assert:(t1 digitBytes = #[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == false).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r00ffffffffffffffffffff.
    self assert:(t1 digitBytes = #[16r01 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == true).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r0100000000000000000000.
    self assert:(t1 digitBytes = #[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == false).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r00ffffffffffffffffffffff.
    self assert:(t1 digitBytes = #[16r01 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == true).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r010000000000000000000000.
    self assert:(t1 digitBytes = #[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == false).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r00ffffffffffffffffffffffff.
    self assert:(t1 digitBytes = #[16r01 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == true).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r01000000000000000000000000.
    self assert:(t1 digitBytes = #[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == false).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r00ffffffffffffffffffffffffff.
    self assert:(t1 digitBytes = #[16r01 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == true).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r0100000000000000000000000000.
    self assert:(t1 digitBytes = #[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == false).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r00ffffffffffffffffffffffffffff.
    self assert:(t1 digitBytes = #[16r01 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == true).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r010000000000000000000000000000.
    self assert:(t1 digitBytes = #[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == false).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r00ffffffffffffffffffffffffffffff.
    self assert:(t1 digitBytes = #[16r01 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == true).

    t1 := LargeInteger digitBytes:#[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01 ] copy sign:1.
    r := t1 absDestructiveSubtract:16r01000000000000000000000000000000.
    self assert:(t1 digitBytes = #[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00 ]).
    self assert:(r == false).
    "
     self basicNew testLargeIntegerHelpers2
    "
!

testLargeIntegerHelpers3
    "/ absDivMod:

     self assert:(9000000000000000000 absDivMod: 4000) = #(2250000000000000 0).
     self assert:(-9000000000000000000 absDivMod: 4000) = #(2250000000000000 0).
     self assert:(9000000000000000000 absDivMod: -4000) = #(2250000000000000 0).
     self assert:(-9000000000000000000 absDivMod: -4000) = #(2250000000000000 0).

     self assert:(9000000000000000001 absDivMod: 4000) = #(2250000000000000 1).
     self assert:(-9000000000000000001 absDivMod: 4000) = #(2250000000000000 1).
     self assert:(9000000000000000001 absDivMod: -4000) = #(2250000000000000 1).
     self assert:(-9000000000000000001 absDivMod: -4000) = #(2250000000000000 1).

     self assert:(9000000000000000000 absDivMod: 40000) = #(225000000000000 0).
     self assert:(-9000000000000000000 absDivMod: 40000) = #(225000000000000 0).
     self assert:(9000000000000000000 absDivMod: -40000) = #(225000000000000 0).
     self assert:(-9000000000000000000 absDivMod: -40000) = #(225000000000000 0).

     self assert:(9000000000000000000 absDivMod: 400000) = #(22500000000000 0).
     self assert:(-9000000000000000000 absDivMod: 400000) = #(22500000000000 0).
     self assert:(9000000000000000000 absDivMod: -400000) = #(22500000000000 0).
     self assert:(-9000000000000000000 absDivMod: -400000) = #(22500000000000 0).

     self assert:(9000000000000000000 absDivMod: 4000000) = #(2250000000000 0).
     self assert:(-9000000000000000000 absDivMod: 4000000) = #(2250000000000 0).
     self assert:(9000000000000000000 absDivMod: -4000000) = #(2250000000000 0).
     self assert:(-9000000000000000000 absDivMod: -4000000) = #(2250000000000 0).

     self assert:(9000000000000000000 absDivMod: 40000000) = #(225000000000 0).
     self assert:(-9000000000000000000 absDivMod: 40000000) = #(225000000000 0).
     self assert:(9000000000000000000 absDivMod: -40000000) = #(225000000000 0).
     self assert:(-9000000000000000000 absDivMod: -40000000) = #(225000000000 0).

     self assert:(9000000000000000000 absDivMod: 400000000) = #(22500000000 0).
     self assert:(-9000000000000000000 absDivMod: 400000000) = #(22500000000 0).
     self assert:(9000000000000000000 absDivMod: -400000000) = #(22500000000 0).
     self assert:(-9000000000000000000 absDivMod: -400000000) = #(22500000000 0).

     self assert:(9000000000000000000 absDivMod: 4000000000) = #(2250000000 0).
     self assert:(-9000000000000000000 absDivMod: 4000000000) = #(2250000000 0).
     self assert:(9000000000000000000 absDivMod: -4000000000) = #(2250000000 0).
     self assert:(-9000000000000000000 absDivMod: -4000000000) = #(2250000000 0).

     self assert:(9000000000000000000 absDivMod: 40000000000) = #(225000000 0).
     self assert:(-9000000000000000000 absDivMod: 40000000000) = #(225000000 0).
     self assert:(9000000000000000000 absDivMod: -40000000000) = #(225000000 0).
     self assert:(-9000000000000000000 absDivMod: -40000000000) = #(225000000 0).

     self assert:(9000000000000000000 absDivMod: 400000000000) = #(22500000 0).
     self assert:(-9000000000000000000 absDivMod: 400000000000) = #(22500000 0).
     self assert:(9000000000000000000 absDivMod: -400000000000) = #(22500000 0).
     self assert:(-9000000000000000000 absDivMod: -400000000000) = #(22500000 0).

     self assert:(9000000000000000000 absDivMod: 4000000000000) = #(2250000 0).
     self assert:(-9000000000000000000 absDivMod: 4000000000000) = #(2250000 0).
     self assert:(9000000000000000000 absDivMod: -4000000000000) = #(2250000 0).
     self assert:(-9000000000000000000 absDivMod: -4000000000000) = #(2250000 0).

     self assert:(9000000000000000000 absDivMod: 40000000000000) = #(225000 0).
     self assert:(-9000000000000000000 absDivMod: 40000000000000) = #(225000 0).
     self assert:(9000000000000000000 absDivMod: -40000000000000) = #(225000 0).
     self assert:(-9000000000000000000 absDivMod: -40000000000000) = #(225000 0).

     self assert:(9000000000000000000 absDivMod: 400000000000000) = #(22500 0).
     self assert:(-9000000000000000000 absDivMod: 400000000000000) = #(22500 0).
     self assert:(9000000000000000000 absDivMod: -400000000000000) = #(22500 0).
     self assert:(-9000000000000000000 absDivMod: -400000000000000) = #(22500 0).

     self assert:(9000000000000000000 absDivMod: 4000000000000000) = #(2250 0).
     self assert:(-9000000000000000000 absDivMod: 4000000000000000) = #(2250 0).
     self assert:(9000000000000000000 absDivMod: -4000000000000000) = #(2250 0).
     self assert:(-9000000000000000000 absDivMod: -4000000000000000) = #(2250 0).

     self assert:(9000000000000000000 absDivMod: 4000000000000000000) = #(2 1000000000000000000).
     self assert:(-9000000000000000000 absDivMod: 4000000000000000000) = #(2 1000000000000000000).
     self assert:(9000000000000000000 absDivMod: -4000000000000000000) = #(2 1000000000000000000).
     self assert:(-9000000000000000000 absDivMod: -4000000000000000000) = #(2 1000000000000000000).

    "
     self basicNew testLargeIntegerHelpers3
    "
!

testLargeMultiplication
    |t1 t2 p|

    "multiplication"
    t1 := 100.
    self assert:(t1 * t1 == 10000).
    self assert:((t1 perform:'*' asSymbol with:t1) == 10000).
    self assert:((t1 * t1) printString = '10000').
    self assert:((t1 perform:'*' asSymbol with:t1) printString = '10000').

    t1 := 1000.
    self assert:(t1 * t1 == 1000000).
    self assert:((t1 perform:'*' asSymbol with:t1) == 1000000).
    self assert:((t1 * t1) printString = '1000000').
    self assert:((t1 perform:'*' asSymbol with:t1) printString = '1000000').

    t1 := 10000.
    self assert:(t1 * t1 == 100000000).
    self assert:((t1 perform:'*' asSymbol with:t1) == 100000000).
    self assert:((t1 * t1) printString = '100000000').
    self assert:((t1 perform:'*' asSymbol with:t1) printString = '100000000').

    t1 := 100000.
    SmallInteger maxBytes == 4 ifTrue:[
        self assert:(t1 * t1 = 10000000000).
        self assert:((t1 perform:'*' asSymbol with:t1) = 10000000000).
    ].
    SmallInteger maxBytes == 8 ifTrue:[
        self assert:(t1 * t1 == 10000000000).
        self assert:((t1 perform:'*' asSymbol with:t1) == 10000000000).
    ].

    self assert:((t1 * t1) printString = '10000000000').
    self assert:((t1 perform:'*' asSymbol with:t1) printString = '10000000000').

    t1 := 1000000.
    self assert:((t1 * t1) printString = '1000000000000').
    self assert:((t1 perform:'*' asSymbol with:t1) printString = '1000000000000').

    t1 := 10000000.
    self assert:((t1 * t1) printString = '100000000000000').
    self assert:((t1 perform:'*' asSymbol with:t1) printString = '100000000000000').

    t1 := 100000000.
    self assert:((t1 * t1) printString = '10000000000000000').
    self assert:((t1 perform:'*' asSymbol with:t1) printString = '10000000000000000').

    t1 := 1000000000.
    self assert:((t1 * t1) printString = '1000000000000000000').
    self assert:((t1 perform:'*' asSymbol with:t1) printString = '1000000000000000000').


    "Large * SmallInt multiplication"
    self assert:(10 factorial printString = '3628800').
    self assert:(20 factorial printString = '2432902008176640000').
    self assert:(100 factorial printString = '93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000').
    self assert:(1000 factorial printString = '402387260077093773543702433923003985719374864210714632543799910429938512398629020592044208486969404800479988610197196058631666872994808558901323829669944590997424504087073759918823627727188732519779505950995276120874975462497043601418278094646496291056393887437886487337119181045825783647849977012476632889835955735432513185323958463075557409114262417474349347553428646576611667797396668820291207379143853719588249808126867838374559731746136085379534524221586593201928090878297308431392844403281231558611036976801357304216168747609675871348312025478589320767169132448426236131412508780208000261683151027341827977704784635868170164365024153691398281264810213092761244896359928705114964975419909342221566832572080821333186116811553615836546984046708975602900950537616475847728421889679646244945160765353408198901385442487984959953319101723355556602139450399736280750137837615307127761926849034352625200015888535147331611702103968175921510907788019393178114194545257223865541461062892187960223838971476088506276862967146674697562911234082439208160153780889893964518263243671616762179168909779911903754031274622289988005195444414282012187361745992642956581746628302955570299024324153181617210465832036786906117260158783520751516284225540265170483304226143974286933061690897968482590125458327168226458066526769958652682272807075781391858178889652208164348344825993266043367660176999612831860788386150279465955131156552036093988180612138558600301435694527224206344631797460594682573103790084024432438465657245014402821885252470935190620929023136493273497565513958720559654228749774011413346962715422845862377387538230483865688976461927383814900140767310446640259899490222221765904339901886018566526485061799702356193897017860040811889729918311021171229845901641921068884387121855646124960798722908519296819372388642614839657382291123125024186649353143970137428531926649875337218940694281434118520158014123344828015051399694290153483077644569099073152433278288269864602789864321139083506217095002597389863554277196742822248757586765752344220207573630569498825087968928162753848863396909959826280956121450994871701244516461260379029309120889086942028510640182154399457156805941872748998094254742173582401063677404595741785160829230135358081840096996372524230560855903700624271243416909004153690105933983835777939410970027753472000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000').

    t1 := 100000000.                            "/ small
    t2 := 100000000000000000.                   "/ large on 32bit; small on 64bt machines
    p := t1 * t2.
    self assert:(p = 10000000000000000000000000).
    p := t2 * t1.
    self assert:(p = 10000000000000000000000000).
    self assert:((t1 * t2) = 10000000000000000000000000).
    self assert:((t2 * t1) = 10000000000000000000000000).

    t1 := 100000000.                            "/ small
    t2 := 1000000000000000000.                  "/ large on 32bit; small on 64bt machines
    p := t1 * t2.
    self assert:(p = 100000000000000000000000000).
    p := t2 * t1.
    self assert:(p = 100000000000000000000000000).
    self assert:(t1 * t2) = 100000000000000000000000000.
    self assert:(t2 * t1) = 100000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 10000000000000000000.                 "/ large
    self assert:(t1 * t2) = 1000000000000000000000000000.
    self assert:(t2 * t1) = 1000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 100000000000000000000.                "/ large
    self assert:(t1 * t2) = 10000000000000000000000000000.
    self assert:(t2 * t1) = 10000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 1000000000000000000000.               "/ large
    self assert:(t1 * t2) = 100000000000000000000000000000.
    self assert:(t2 * t1) = 100000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 10000000000000000000000.              "/ large
    self assert:(t1 * t2) = 1000000000000000000000000000000.
    self assert:(t2 * t1) = 1000000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 100000000000000000000000.             "/ large
    self assert:(t1 * t2) = 10000000000000000000000000000000.
    self assert:(t2 * t1) = 10000000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 1000000000000000000000000.            "/ large
    self assert:(t1 * t2) = 100000000000000000000000000000000.
    self assert:(t2 * t1) = 100000000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 10000000000000000000000000.           "/ large
    self assert:(t1 * t2) = 1000000000000000000000000000000000.
    self assert:(t2 * t1) = 1000000000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 100000000000000000000000000.          "/ large
    self assert:(t1 * t2) = 10000000000000000000000000000000000.
    self assert:(t2 * t1) = 10000000000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 1000000000000000000000000000.         "/ large
    self assert:(t1 * t2) = 100000000000000000000000000000000000.
    self assert:(t2 * t1) = 100000000000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 10000000000000000000000000000.        "/ large
    self assert:(t1 * t2) = 1000000000000000000000000000000000000.
    self assert:(t2 * t1) = 1000000000000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 100000000000000000000000000000.       "/ large
    self assert:(t1 * t2) = 10000000000000000000000000000000000000.
    self assert:(t2 * t1) = 10000000000000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 1000000000000000000000000000000.      "/ large
    self assert:(t1 * t2) = 100000000000000000000000000000000000000.
    self assert:(t2 * t1) = 100000000000000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 10000000000000000000000000000000.     "/ large
    self assert:(t1 * t2) = 1000000000000000000000000000000000000000.
    self assert:(t2 * t1) = 1000000000000000000000000000000000000000.

    t1 := 100000000.                            "/ small
    t2 := 100000000000000000000000000000000.    "/ large
    self assert:(t1 * t2) = 10000000000000000000000000000000000000000.
    self assert:(t2 * t1) = 10000000000000000000000000000000000000000.

    "Large * Large multiplication"

    self assert:((16r3FFF * 16r3FFF) hexPrintString = 'FFF8001').
    self assert:((16r7FFF * 16r7FFF) hexPrintString = '3FFF0001').
    self assert:((16rFFFF * 16rFFFF) hexPrintString = 'FFFE0001').
    self assert:((16r3FFFFF * 16r3FFFFF) hexPrintString = 'FFFFF800001').
    self assert:((16r7FFFFF * 16r7FFFFF) hexPrintString = '3FFFFF000001').
    self assert:((16rFFFFFF * 16rFFFFFF) hexPrintString = 'FFFFFE000001').
    self assert:((16r3FFFFFFF * 16r3FFFFFFF) hexPrintString = 'FFFFFFF80000001').
    self assert:((16r7FFFFFFF * 16r7FFFFFFF) hexPrintString = '3FFFFFFF00000001').
    self assert:((16rFFFFFFFF * 16rFFFFFFFF) hexPrintString = 'FFFFFFFE00000001').
    self assert:((16r3FFFFFFFFF * 16r3FFFFFFFFF) hexPrintString = 'FFFFFFFFF8000000001').
    self assert:((16r7FFFFFFFFF * 16r7FFFFFFFFF) hexPrintString = '3FFFFFFFFF0000000001').
    self assert:((16rFFFFFFFFFF * 16rFFFFFFFFFF) hexPrintString = 'FFFFFFFFFE0000000001').
    self assert:((20 factorial * 20 factorial) printString = '5919012181389927685417441689600000000').

    self assert:((16rFFFFFFFFFFFF * 16rFFFFFFFFFF) hexPrintString = 'FFFFFFFFFEFF0000000001').
    self assert:((16rFFFFFFFFFFFFFF * 16rFFFFFFFFFF) hexPrintString = 'FFFFFFFFFEFFFF0000000001').
    self assert:((t1 := 16rFFFFFFFFFFFFFFFF * 16rFFFFFFFFFF) hexPrintString = 'FFFFFFFFFEFFFFFF0000000001').
    self assert:((16rFFFFFFFFFFFFFFFFFF * 16rFFFFFFFFFF) hexPrintString = 'FFFFFFFFFEFFFFFFFF0000000001').
    self assert:((16rFFFFFFFFFFFFFFFFFFFF * 16rFFFFFFFFFF) hexPrintString = 'FFFFFFFFFEFFFFFFFFFF0000000001').
    self assert:((16rFFFFFFFFFFFFFFFFFFFFFF * 16rFFFFFFFFFF) hexPrintString = 'FFFFFFFFFEFFFFFFFFFFFF0000000001').

    self assert:((16rFFFFFFFFFFFF * 16rFFFFFFFFFFFF) hexPrintString = 'FFFFFFFFFFFE000000000001').
    self assert:((16rFFFFFFFFFFFFFF * 16rFFFFFFFFFFFFFF) hexPrintString = 'FFFFFFFFFFFFFE00000000000001').
    self assert:((t2 := (t1 := 16rFFFFFFFFFFFFFFFF * 16rFFFFFFFFFFFFFFFF) hexPrintString) = 'FFFFFFFFFFFFFFFE0000000000000001').
    self assert:((16rFFFFFFFFFFFFFFFF * 16rFFFFFFFFFFFFFFFF) hexPrintString = 'FFFFFFFFFFFFFFFE0000000000000001').
    self assert:((16rFFFFFFFFFFFFFFFFFF * 16rFFFFFFFFFFFFFFFFFF) hexPrintString = 'FFFFFFFFFFFFFFFFFE000000000000000001').
    self assert:((16rFFFFFFFFFFFFFFFFFFFF * 16rFFFFFFFFFFFFFFFFFFFF) hexPrintString = 'FFFFFFFFFFFFFFFFFFFE00000000000000000001').
    self assert:((16rFFFFFFFFFFFFFFFFFFFFFF * 16rFFFFFFFFFFFFFFFFFFFFFF) hexPrintString = 'FFFFFFFFFFFFFFFFFFFFFE0000000000000000000001').

    t1 := 699697179634740272935560322271216335182775596927422865716399200802062765682314102885264570100200211251370690926108604161579425545019863369232209949922751354278329212124724267803033599595114924195721823679025053720850308776953208134469115885358619139670731195605237506312288263327925364912720266772715929600.
    self assert:(t1 printString = '699697179634740272935560322271216335182775596927422865716399200802062765682314102885264570100200211251370690926108604161579425545019863369232209949922751354278329212124724267803033599595114924195721823679025053720850308776953208134469115885358619139670731195605237506312288263327925364912720266772715929600').
    self assert:((t1 * t1) = 489576143188809998144298426641311496989165214458056165805143410866108690058261346129614030084813851082564698610174813898740525406243367146120734370570458429364167811695064904353093506532695086211301649001517008746471464304183710723162864634442619484210170532881759249266026059786349673031239277666195699357198366128286910123306594912484590029738722281929300359929462301099981920256369394887701755497894820998573896950238852994224811101315810851671448056042419257789317787959570728520197146733902575090480065597582292177085754523686580725860228636039424698638422538988050350726807943014483010988455057592156160000).
    self assert:((t1 * t1) printString = '489576143188809998144298426641311496989165214458056165805143410866108690058261346129614030084813851082564698610174813898740525406243367146120734370570458429364167811695064904353093506532695086211301649001517008746471464304183710723162864634442619484210170532881759249266026059786349673031239277666195699357198366128286910123306594912484590029738722281929300359929462301099981920256369394887701755497894820998573896950238852994224811101315810851671448056042419257789317787959570728520197146733902575090480065597582292177085754523686580725860228636039424698638422538988050350726807943014483010988455057592156160000').

    #(
        16rFF
        16rFFFF
        16rFFFFFF
        16rFFFFFFFF
        16rFFFFFFFFFF
        16rFFFFFFFFFFFF
        16rFFFFFFFFFFFFFF
        16rFFFFFFFFFFFFFFFF
        16rFFFFFFFFFFFFFFFFFF
        16rFFFFFFFFFFFFFFFFFFFF
        16rFFFFFFFFFFFFFFFFFFFFFF
        16rFFFFFFFFFFFFFFFFFFFFFFFF
    ) do:[:eachFactor1 |
        #(
            16rFF
            16rFFFF
            16rFFFFFF
            16rFFFFFFFF
            16rFFFFFFFFFF
            16rFFFFFFFFFFFF
            16rFFFFFFFFFFFFFF
            16rFFFFFFFFFFFFFFFF
            16rFFFFFFFFFFFFFFFFFF
            16rFFFFFFFFFFFFFFFFFFFF
            16rFFFFFFFFFFFFFFFFFFFFFF
            16rFFFFFFFFFFFFFFFFFFFFFFFF
        ) do:[:eachFactor2 |
            |t3|

            t1 := (eachFactor1 * eachFactor2).
            t2 := (eachFactor2 * eachFactor1).

            self assert:(t1 = t2).
t1 = 20203181441155852828228393631745 ifTrue:[
 eachFactor1 = 1099511627775 ifTrue:[
self halt
]].

            self assert:(t1 / eachFactor1) = eachFactor2.
            self assert:(t1 / eachFactor2) = eachFactor1.
            t3 := (eachFactor1 asLargeInteger * eachFactor2 asLargeInteger).
            self assert: t1 = t3.
        ].
    ].

    "
     self basicNew testLargeMultiplication
    "

    "Modified: / 02-12-2013 / 15:45:39 / cg"
!

testLargeMultiplication2
    "tests many divisions and multiplications (of largeInts by smallInts)"

    |n n2|

    self assert:(1000 factorial printString = '402387260077093773543702433923003985719374864210714632543799910429938512398629020592044208486969404800479988610197196058631666872994808558901323829669944590997424504087073759918823627727188732519779505950995276120874975462497043601418278094646496291056393887437886487337119181045825783647849977012476632889835955735432513185323958463075557409114262417474349347553428646576611667797396668820291207379143853719588249808126867838374559731746136085379534524221586593201928090878297308431392844403281231558611036976801357304216168747609675871348312025478589320767169132448426236131412508780208000261683151027341827977704784635868170164365024153691398281264810213092761244896359928705114964975419909342221566832572080821333186116811553615836546984046708975602900950537616475847728421889679646244945160765353408198901385442487984959953319101723355556602139450399736280750137837615307127761926849034352625200015888535147331611702103968175921510907788019393178114194545257223865541461062892187960223838971476088506276862967146674697562911234082439208160153780889893964518263243671616762179168909779911903754031274622289988005195444414282012187361745992642956581746628302955570299024324153181617210465832036786906117260158783520751516284225540265170483304226143974286933061690897968482590125458327168226458066526769958652682272807075781391858178889652208164348344825993266043367660176999612831860788386150279465955131156552036093988180612138558600301435694527224206344631797460594682573103790084024432438465657245014402821885252470935190620929023136493273497565513958720559654228749774011413346962715422845862377387538230483865688976461927383814900140767310446640259899490222221765904339901886018566526485061799702356193897017860040811889729918311021171229845901641921068884387121855646124960798722908519296819372388642614839657382291123125024186649353143970137428531926649875337218940694281434118520158014123344828015051399694290153483077644569099073152433278288269864602789864321139083506217095002597389863554277196742822248757586765752344220207573630569498825087968928162753848863396909959826280956121450994871701244516461260379029309120889086942028510640182154399457156805941872748998094254742173582401063677404595741785160829230135358081840096996372524230560855903700624271243416909004153690105933983835777939410970027753472000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000').

    n := 1000 factorial.
    1000 to:2 by:-1 do:[:d |
	n2 := n / d.
	self assert:((d-1) factorial = n2).
	(Integer readFrom:n2 printString) * d = n.
	n := n2.
    ].
!

testLargeMultiplicationHelpers1
    |t1 t2 r|

    t1 := LargeInteger digitBytes:#[ 16r00 16rE1 16rF5 16r05 ].
    t2 := LargeInteger digitBytes:#[ 16r00 16r00 16r40 16rB2 16rBA 16rC9 16rE0 16r19 16r1E 16r02].
    r := t1 absMul:t2.
    self assert:(r printString = '1000000000000000000000000000000').
    self assert:(r hexPrintString = 'C9F2C9CD04674EDEA40000000').

    t1 := LargeInteger digitBytes:#[ 16r00 16rE1 16rF5 16r05 ].
    t2 := LargeInteger digitBytes:#[ 16r00 16r00 16rA0 16rDE   16rC5 16rAD 16rC9 16r35   16r36].
    r := t1 absMul:t2.
    self assert:(r printString = '100000000000000000000000000000').
    self assert:(r hexPrintString = '1431E0FAE6D7217CAA0000000').

    "/ -----

    t1 := LargeInteger digitBytes:#[ 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF].
    t2 := LargeInteger digitBytes:#[ 16rFF 16rFF 16rFF 16rFF 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = 'FFFFFFFEFFFFFFFF00000001').

    t1 := LargeInteger digitBytes:#[ 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF].
    t2 := LargeInteger digitBytes:#[ 16rFF 16rFF 16rFF 16rFF 16rFF 0 0 0].
    r := t1 absMul:t2.
    self assert:(r printString = '20282409603633223678774030106625').
    self assert:(r hexPrintString = 'FFFFFFFFFEFFFFFF0000000001').

    t1 := LargeInteger digitBytes:#[ 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF].
    t2 := LargeInteger digitBytes:#[ 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 0 0].
    r := t1 absMul:t2.
    self assert:(r printString = '5192296858534809181504947642957825').
    self assert:(r hexPrintString = 'FFFFFFFFFFFEFFFF000000000001').

    t1 := LargeInteger digitBytes:#[ 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF].
    t2 := LargeInteger digitBytes:#[ 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 0].
    r := t1 absMul:t2.
    self assert:(r printString = '1329227995784915854385005392532865025').
    self assert:(r hexPrintString = 'FFFFFFFFFFFFFEFF00000000000001').

    "
     self basicNew testLargeMultiplicationHelpers1
    "

    "Modified: / 02-12-2013 / 18:48:00 / cg"
!

testLargeMultiplicationHelpers2
    |t1 t2 r|

    "/ testing internal multiplication method
    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '12100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9 10].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '1412100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9 10 11].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '161412100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9 10 11 12].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '18161412100E0C0A08060402').

    "/ --------

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '12100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9 10].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '1412100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9 10 11].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '161412100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9 10 11 12].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '18161412100E0C0A08060402').

    "/ --------

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '12100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9 10].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0 ].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '1412100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9 10 11].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '161412100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9 10 11 12].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '18161412100E0C0A08060402').

    "/ --------

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '12100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9 10].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '1412100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9 10 11].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '161412100E0C0A08060402').

    t1 := LargeInteger digitBytes:#[ 1 2 3 4 5 6 7 8 9 10 11 12].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '18161412100E0C0A08060402').


    "/ ==================0

    t1 := LargeInteger digitBytes:#[ 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '202020202020300').

    t1 := LargeInteger digitBytes:#[ 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '202020202020300').

    t1 := LargeInteger digitBytes:#[ 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '202020202020300').

    t1 := LargeInteger digitBytes:#[ 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '202020202020300').

    "/ ---------

    t1 := LargeInteger digitBytes:#[ 0 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '20202020202030000').

    t1 := LargeInteger digitBytes:#[ 0 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '20202020202030000').

    t1 := LargeInteger digitBytes:#[ 0 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '20202020202030000').

    t1 := LargeInteger digitBytes:#[ 0 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '20202020202030000').

    "/ ---------

    t1 := LargeInteger digitBytes:#[ 0 0 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '2020202020203000000').

    t1 := LargeInteger digitBytes:#[ 0 0 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '2020202020203000000').

    t1 := LargeInteger digitBytes:#[ 0 0 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '2020202020203000000').

    t1 := LargeInteger digitBytes:#[ 0 0 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '2020202020203000000').

    "/ ---------

    t1 := LargeInteger digitBytes:#[ 0 0 0 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '202020202020300000000').

    t1 := LargeInteger digitBytes:#[ 0 0 0 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '202020202020300000000').

    t1 := LargeInteger digitBytes:#[ 0 0 0 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '202020202020300000000').

    t1 := LargeInteger digitBytes:#[ 0 0 0 128 1 1 1 1 1 1 1].
    t2 := LargeInteger digitBytes:#[ 2 0 0 0 0 0 0 0 0 0 0].
    r := t1 absMul:t2.
    self assert:(r hexPrintString = '202020202020300000000').

    "
     self basicNew testLargeMultiplicationHelpers2
    "

    "Modified: / 02-12-2013 / 15:45:39 / cg"
!

testLargeSubtraction1
    |a1 a2 a b1 b2 b c1 c2 c|

    "/ on 32bit machines - these lead to smallint overflow
    self assert:((2770568 + 2770568) printString = '5541136').
    self assert:((2770568 - 2770568) printString = '0').
    self assert:((2770568 negated + 2770568 negated) printString = '-5541136').
    self assert:((5541136 negated - 2770568 negated) printString = '-2770568').

    "Large - small subtraction"

    self assert:((2770568900 + 2770568900) printString = '5541137800').
    self assert:((2770568900 - 2770568900) printString = '0').
    self assert:((2770568900 negated + 2770568900 negated) printString = '-5541137800').
    self assert:((5541137800 negated - 2770568900 negated) printString = '-2770568900').
    self assert:((2770568900 negated - 5541137800 negated) printString = '2770568900').

    a1 := -2770568900. a2 := 59049.
    a := (a1 / a2) negated.
    b1 := -5872025600. b2 := 59049.
    b := (b1 / b2) negated.
    c1 := 344606300. c2 := 6561.
    c := (c1 / c2) negated.
    self assert:(a - b closeTo: c).
    self assert:((a - b) asFloat closeTo: c asFloat).
    self assert:((a asFloat - b) closeTo: c asFloat).
    self assert:((a - b asFloat) closeTo: c asFloat).

    a := -10.
    b := -12.
    self assert:(a - b = 2).

    a := -10000000.
    b := -12000000.
    self assert:(a - b = 2000000).

    a := -100000000000000.
    b := -120000000000000.
    self assert:(a - b = 20000000000000).

    "smallInteger - largeInteger"
    self assert:(-1000000000 - -2000000000 = 1000000000).
    "largeInteger - smallInteger"
    self assert:(-2000000000 - -1000000000 = -1000000000).

    a := 40 factorial.
    b := 39 factorial.
    self assert:(a - b + b = a).

    "
     self basicNew testLargeSubtraction1
    "

    "Modified: / 27.11.1999 / 16:41:54 / cg"
!

testLargeSubtraction2
    "/ on 64bit machines - these lead to smallint overflow
    self assert:((16r3FFFFFFFFFFFFFFF negated - 1 - 1) printString = '-4611686018427387905').

    "
     self basicNew testLargeSubtraction2
    "
!

testLiteralNumbers
    self assert:(self num_00000000000010000 hexPrintString = '10000').
    self assert:(self num_00000000000100000 hexPrintString = '100000').
    self assert:(self num_00000000001000000 hexPrintString = '1000000').
    self assert:(self num_00000000010000000 hexPrintString = '10000000').
    self assert:(self num_00000000100000000 hexPrintString = '100000000').
    self assert:(self num_00000001000000000 hexPrintString = '1000000000').
    self assert:(self num_00000010000000000 hexPrintString = '10000000000').
    self assert:(self num_00000100000000000 hexPrintString = '100000000000').
    self assert:(self num_00001000000000000 hexPrintString = '1000000000000').
    self assert:(self num_00010000000000000 hexPrintString = '10000000000000').
    self assert:(self num_00100000000000000 hexPrintString = '100000000000000').
    self assert:(self num_01000000000000000 hexPrintString = '1000000000000000').
    self assert:(self num_10000000000000000 hexPrintString = '10000000000000000').

    self assert:(self num_00000000000007FFF hexPrintString = '7FFF').
    self assert:(self num_00000000000008000 hexPrintString = '8000').
    self assert:(self num_0000000000000FFFF hexPrintString = 'FFFF').
    self assert:(self num_000000000007FFFFF hexPrintString = '7FFFFF').
    self assert:(self num_00000000000800000 hexPrintString = '800000').
    self assert:(self num_00000000000FFFFFF hexPrintString = 'FFFFFF').
    self assert:(self num_0000000007FFFFFFF hexPrintString = '7FFFFFFF').
    self assert:(self num_00000000080000000 hexPrintString = '80000000').
    self assert:(self num_000000000FFFFFFFF hexPrintString = 'FFFFFFFF').
    self assert:(self num_0000000FFFFFFFFFF hexPrintString = 'FFFFFFFFFF').
    self assert:(self num_00000FFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFF').
    self assert:(self num_000FFFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFFFF').
    self assert:(self num_0FFFFFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFFFFFF').
    self assert:(self num_1FFFFFFFFFFFFFFFF hexPrintString = '1FFFFFFFFFFFFFFFF').
    self assert:(self num_20000000000000000 hexPrintString = '20000000000000000').
    self assert:(self num_3FFFFFFFFFFFFFFFF hexPrintString = '3FFFFFFFFFFFFFFFF').
    self assert:(self num_40000000000000000 hexPrintString = '40000000000000000').
    self assert:(self num_7FFFFFFFFFFFFFFFF hexPrintString = '7FFFFFFFFFFFFFFFF').
    self assert:(self num_80000000000000000 hexPrintString = '80000000000000000').

    self assert:(self num_00000FFFFFFFFFFFE hexPrintString = 'FFFFFFFFFFFE').
    self assert:(self num_00000FFFFFFFFFFFC hexPrintString = 'FFFFFFFFFFFC').
    self assert:(self num_00000FFFFFFFFFFF8 hexPrintString = 'FFFFFFFFFFF8').
    self assert:(self num_00000FFFFFFFFFFF0 hexPrintString = 'FFFFFFFFFFF0').
    self assert:(self num_00000FFFFFFFFFFE0 hexPrintString = 'FFFFFFFFFFE0').
    self assert:(self num_00000FFFFFFFFFFC0 hexPrintString = 'FFFFFFFFFFC0').
    self assert:(self num_00000FFFFFFFFFF80 hexPrintString = 'FFFFFFFFFF80').
    self assert:(self num_00000FFFFFFFFFF00 hexPrintString = 'FFFFFFFFFF00').

    self assert:(self num_0000000000FFF0000 hexPrintString = 'FFF0000').

    "
     self basicNew testLiteralNumbers
    "

    "Modified: / 4.6.1999 / 18:41:09 / cg"
!

testModulu
    |a b op|

    op := #\\.
    a := -1.
    b := 8.
    self assert:(-1 \\ 8 == 7).
    self assert:(a \\ 8 == 7).
    self assert:(-1 \\ b == 7).
    self assert:(a \\ b == 7).

    self assert:((-1 perform:op with: 8) == 7).
    self assert:((a perform:op with: 8) == 7).
    self assert:((-1 perform:op with: b) == 7).
    self assert:((a perform:op with: b) == 7).

    a := 1.
    b := -8.
    self assert:(1 \\ -8 == -7).
    self assert:(a \\ -8 == -7).
    self assert:(1 \\ b == -7).
    self assert:(a \\ b == -7).

    self assert:((1 perform:op with: -8) == -7).
    self assert:((a perform:op with: -8) == -7).
    self assert:((1 perform:op with: b) == -7).
    self assert:((a perform:op with: b) == -7).

    a := -1.
    b := -8.
    self assert:(-1 \\ -8 == -1).
    self assert:(a \\ -8 == -1).
    self assert:(-1 \\ b == -1).
    self assert:(a \\ b == -1).

    self assert:((-1 perform:op with: -8) == -1).
    self assert:((a perform:op with: -8) == -1).
    self assert:((-1 perform:op with: b) == -1).
    self assert:((a perform:op with: b) == -1).

    a := 1.
    b := 8.
    self assert:(1 \\ 8 == 1).
    self assert:(a \\ 8 == 1).
    self assert:(1 \\ b == 1).
    self assert:(a \\ b == 1).

    self assert:((1 perform:op with: 8) == 1).
    self assert:((a perform:op with: 8) == 1).
    self assert:((1 perform:op with: b) == 1).
    self assert:((a perform:op with: b) == 1).


    a := -17.
    b := 8.
    self assert:(-17 \\ 8 == 7).
    self assert:(a \\ 8 == 7).
    self assert:(-17 \\ b == 7).
    self assert:(a \\ b == 7).

    self assert:((-17 perform:op with: 8) == 7).
    self assert:((a perform:op with: 8) == 7).
    self assert:((-17 perform:op with: b) == 7).
    self assert:((a perform:op with: b) == 7).

    a := 17.
    b := -8.
    self assert:(17 \\ -8 == -7).
    self assert:(a \\ -8 == -7).
    self assert:(17 \\ b == -7).
    self assert:(a \\ b == -7).

    self assert:((17 perform:op with: -8) == -7).
    self assert:((a perform:op with: -8) == -7).
    self assert:((17 perform:op with: b) == -7).
    self assert:((a perform:op with: b) == -7).

    a := -17.
    b := -8.
    self assert:(-17 \\ -8 == -1).
    self assert:(a \\ -8 == -1).
    self assert:(-17 \\ b == -1).
    self assert:(a \\ b == -1).

    self assert:((-17 perform:op with: -8) == -1).
    self assert:((a perform:op with: -8) == -1).
    self assert:((-17 perform:op with: b) == -1).
    self assert:((a perform:op with: b) == -1).

    a := 17.
    b := 8.
    self assert:(17 \\ 8 == 1).
    self assert:(a \\ 8 == 1).
    self assert:(17 \\ b == 1).
    self assert:(a \\ b == 1).

    self assert:((17 perform:op with: 8) == 1).
    self assert:((a perform:op with: 8) == 1).
    self assert:((17 perform:op with: b) == 1).
    self assert:((a perform:op with: b) == 1).


    op := #rem:.
    a := -1.
    b := 8.
    self assert:((-1 rem: 8) == -1).
    self assert:((a rem: 8) == -1).
    self assert:((-1 rem: b) == -1).
    self assert:((a rem: b) == -1).

    self assert:((-1 perform:op with: -8) == -1).
    self assert:((a perform:op with: -8) == -1).
    self assert:((-1 perform:op with: b) == -1).
    self assert:((a perform:op with: b) == -1).

    a := 1.
    b := -8.
    self assert:((1 rem: -8) == 1).
    self assert:((a rem: -8) == 1).
    self assert:((1 rem: b) == 1).
    self assert:((a rem: b) == 1).

    self assert:((1 perform:op with: -8) == 1).
    self assert:((a perform:op with: -8) == 1).
    self assert:((1 perform:op with: b) == 1).
    self assert:((a perform:op with: b) == 1).

    a := -1.
    b := -8.
    self assert:((-1 rem: -8) == -1).
    self assert:((a rem: -8) == -1).
    self assert:((-1 rem: b) == -1).
    self assert:((a rem: b) == -1).

    self assert:((-1 perform:op with: -8) == -1).
    self assert:((a perform:op with: -8) == -1).
    self assert:((-1 perform:op with: b) == -1).
    self assert:((a perform:op with: b) == -1).

    a := 1.
    b := 8.
    self assert:((1 rem: 8) == 1).
    self assert:((a rem: 8) == 1).
    self assert:((1 rem: b) == 1).
    self assert:((a rem: b) == 1).

    self assert:((1 perform:op with: 8) == 1).
    self assert:((a perform:op with: 8) == 1).
    self assert:((1 perform:op with: b) == 1).
    self assert:((a perform:op with: b) == 1).

    a := -17.
    b := 8.
    self assert:((-17 rem: 8) == -1).
    self assert:((a rem: 8) == -1).
    self assert:((-17 rem: b) == -1).
    self assert:((a rem: b) == -1).

    self assert:((-17 perform:op with: -8) == -1).
    self assert:((a perform:op with: -8) == -1).
    self assert:((-17 perform:op with: b) == -1).
    self assert:((a perform:op with: b) == -1).

    a := 17.
    b := -8.
    self assert:((17 rem: -8) == 1).
    self assert:((a rem: -8) == 1).
    self assert:((17 rem: b) == 1).
    self assert:((a rem: b) == 1).

    self assert:((17 perform:op with: -8) == 1).
    self assert:((a perform:op with: -8) == 1).
    self assert:((17 perform:op with: b) == 1).
    self assert:((a perform:op with: b) == 1).

    a := -17.
    b := -8.
    self assert:((-17 rem: -8) == -1).
    self assert:((a rem: -8) == -1).
    self assert:((-17 rem: b) == -1).
    self assert:((a rem: b) == -1).

    self assert:((-17 perform:op with: -8) == -1).
    self assert:((a perform:op with: -8) == -1).
    self assert:((-17 perform:op with: b) == -1).
    self assert:((a perform:op with: b) == -1).

    a := 17.
    b := 8.
    self assert:((17 rem: 8) == 1).
    self assert:((a rem: 8) == 1).
    self assert:((17 rem: b) == 1).
    self assert:((a rem: b) == 1).

    self assert:((17 perform:op with: 8) == 1).
    self assert:((a perform:op with: 8) == 1).
    self assert:((17 perform:op with: b) == 1).
    self assert:((a perform:op with: b) == 1).

    "
     self basicNew testModulu
    "
!

testNextPowerOfTwo
    "/ self assert:(0 nextPowerOf2 = 0).
    self assert:(1 nextPowerOf2 = 1).
    self assert:(2 nextPowerOf2 = 2).
    self assert:(3 nextPowerOf2 = 4).
    self assert:(4 nextPowerOf2 = 4).
    self assert:(5 nextPowerOf2 = 8).
    self assert:(6 nextPowerOf2 = 8).
    self assert:(7 nextPowerOf2 = 8).
    self assert:(8 nextPowerOf2 = 8).
    self assert:(9 nextPowerOf2 = 16).

    self assert:(22 nextPowerOf2 = 32).
    self assert:(32 nextPowerOf2 = 32).
    self assert:(16rFFFF nextPowerOf2 = 16r10000).  
    self assert:(16r1FFFFFFF nextPowerOf2 = 16r20000000).  
    self assert:(16r3FFFFFFF nextPowerOf2 = 16r40000000).  
    self assert:(16r7FFFFFFF nextPowerOf2 = 16r80000000).  
    self assert:(16rFFFFFFFF nextPowerOf2 = 16r100000000). 
    self assert:(16r1FFFFFFFFFFFFFFF nextPowerOf2 = 16r2000000000000000).  
    self assert:(16r3FFFFFFFFFFFFFFF nextPowerOf2 = 16r4000000000000000).  
    self assert:(16r7FFFFFFFFFFFFFFF nextPowerOf2 = 16r8000000000000000).  
    self assert:(16rFFFFFFFFFFFFFFFF nextPowerOf2 = 16r10000000000000000).  
    self assert:(16rFFFFFFFFFFFFFFFFFFFF nextPowerOf2 = 16r100000000000000000000).  

    "
     self basicNew testNextPowerOfTwo
    "
!

testPrinting1
    self assert:(10 printString = '10').
    self assert:(100 printString = '100').
    self assert:(1000 printString = '1000').
    self assert:(10000 printString = '10000').
    self assert:(100000 printString = '100000').
    self assert:(1000000 printString = '1000000').
    self assert:(10000000 printString = '10000000').
    self assert:(100000000 printString = '100000000').
    self assert:(1000000000 printString = '1000000000').
    self assert:(10000000000 printString = '10000000000').
    self assert:(100000000000 printString = '100000000000').
    self assert:(1000000000000 printString = '1000000000000').
    self assert:(10000000000000 printString = '10000000000000').
    self assert:(100000000000000 printString = '100000000000000').
    self assert:(1000000000000000 printString = '1000000000000000').
    self assert:(10000000000000000 printString = '10000000000000000').
    self assert:(100000000000000000 printString = '100000000000000000').
    self assert:(1000000000000000000 printString = '1000000000000000000').
    self assert:(10000000000000000000 printString = '10000000000000000000').

    self assert:(16rF hexPrintString = 'F').
    self assert:(16rFF hexPrintString = 'FF').
    self assert:(16rFFF hexPrintString = 'FFF').
    self assert:(16rFFFF hexPrintString = 'FFFF').
    self assert:(16rFFFFF hexPrintString = 'FFFFF').
    self assert:(16rFFFFFF hexPrintString = 'FFFFFF').
    self assert:(16rFFFFFFF hexPrintString = 'FFFFFFF').
    self assert:(16rFFFFFFFF hexPrintString = 'FFFFFFFF').
    self assert:(16rFFFFFFFFF hexPrintString = 'FFFFFFFFF').
    self assert:(16rFFFFFFFFFF hexPrintString = 'FFFFFFFFFF').
    self assert:(16rFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFF').
    self assert:(16rFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFF').
    self assert:(16rFFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFFF').
    self assert:(16rFFFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFFFF').
    self assert:(16rFFFFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFFFFF').
    self assert:(16rFFFFFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFFFFFF').
    self assert:(16rFFFFFFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFFFFFFF').
    self assert:(16rFFFFFFFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFFFFFFFF').
    self assert:(16rFFFFFFFFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFFFFFFFFF').
    self assert:(16rFFFFFFFFFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFFFFFFFFFF').
    self assert:(16rFFFFFFFFFFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFFFFFFFFFFF').
    self assert:(16rFFFFFFFFFFFFFFFFFFFFFF hexPrintString = 'FFFFFFFFFFFFFFFFFFFFFF').

    self assert:(16r10 hexPrintString = '10').
    self assert:(16r100 hexPrintString = '100').
    self assert:(16r1000 hexPrintString = '1000').
    self assert:(16r10000 hexPrintString = '10000').
    self assert:(16r100000 hexPrintString = '100000').
    self assert:(16r1000000 hexPrintString = '1000000').
    self assert:(16r10000000 hexPrintString = '10000000').
    self assert:(16r100000000 hexPrintString = '100000000').
    self assert:(16r1000000000 hexPrintString = '1000000000').
    self assert:(16r10000000000 hexPrintString = '10000000000').
    self assert:(16r100000000000 hexPrintString = '100000000000').
    self assert:(16r1000000000000 hexPrintString = '1000000000000').
    self assert:(16r10000000000000 hexPrintString = '10000000000000').
    self assert:(16r100000000000000 hexPrintString = '100000000000000').
    self assert:(16r1000000000000000 hexPrintString = '1000000000000000').
    self assert:(16r10000000000000000 hexPrintString = '10000000000000000').
    self assert:(16r100000000000000000 hexPrintString = '100000000000000000').

    self assert:(126 printString) = '126'.
    self assert:(127 printString) = '127'.
    self assert:(128 printString) = '128'.

    self assert:(255 printString) = '255'.
    self assert:(256 printString) = '256'.
    self assert:(257 printString) = '257'.

    self assert:(32767 printString) = '32767'.
    self assert:(32768 printString) = '32768'.
    self assert:(32769 printString) = '32769'.

    self assert:(65535 printString) = '65535'.
    self assert:(65536 printString) = '65536'.
    self assert:(65537 printString) = '65537'.

    self assert:(2147483647 printString) = '2147483647'.
    self assert:(2147483648 printString) = '2147483648'.
    self assert:(2147483649 printString) = '2147483649'.

    self assert:(4294967295 printString) = '4294967295'.
    self assert:(4294967296 printString) = '4294967296'.
    self assert:(4294967297 printString) = '4294967297'.

    self assert:(127 printStringRadix:16) = '7F'.
    self assert:(123 printStringRadix:12) = 'A3'.
    self assert:(123 printStringRadix:10) = '123'.
    self assert:(123 printStringRadix:8 ) = '173'.
    self assert:(123 printStringRadix:3 ) = '11120'.
    self assert:(123 printStringRadix:2 ) = '1111011'.
    self should:[ 123 printStringRadix:1 ] raise:Error.

    "
     self basicNew testPrinting1
    "

    "Modified: / 26.10.1999 / 22:01:35 / stefan"
!

testReading1
    |t|

    self assert:((Integer readFrom:'4865804016353280000') printString = '4865804016353280000').
    self assert:((Integer readFrom:'4294967295') printString = '4294967295').
    self assert:((Integer readFrom:'4294967295') = 4294967295).
    self assert:((Integer readFrom:'4294967296') printString = '4294967296').
    self assert:((Integer readFrom:'4294967296') = 4294967296).
    self assert:((Integer readFrom:'4294967297') printString = '4294967297').
    self assert:((Integer readFrom:'4294967297') = 4294967297).

    "/ max-smallint on 32bit machines
    self assert:((Integer readFrom:'1073741823') printString = '1073741823').
    self assert:((Integer readFrom:'1073741823') class == SmallInteger).

    "/ min-smallint on 32bit machines
    self assert:((Integer readFrom:'-1073741824') printString = '-1073741824').
    self assert:((Integer readFrom:'-1073741824') class == SmallInteger).

    "/ max-smallint on 64bit machines
    self assert:((Integer readFrom:'4611686018427387903') printString = '4611686018427387903').
    SmallInteger maxBytes == 8 ifTrue:[
        self assert:((Integer readFrom:'4611686018427387903') class == SmallInteger)
    ].
    "/ max-smallint+1 on 64bit machines
    self assert:((Integer readFrom:'4611686018427387900') printString = '4611686018427387900').
    SmallInteger maxBytes == 8 ifTrue:[
        |t t3 t3b t4a t4b t4c|

        self assert:((Integer readFrom:'4611686018427387900') class == SmallInteger).
        t := (Integer readFrom:'4611686018427387900').
        t3 := t + 3.
        self assert:(t3 class == SmallInteger).
        self assert:(t3 printString = '4611686018427387903').
        t3b := (self do:t plus:3).
        self assert:(t3b class == SmallInteger).
        self assert:(t3b printString = '4611686018427387903').
        t4a := t3 + 1.
        self assert:(t4a class == LargeInteger).
        self assert:(t4a printString = '4611686018427387904').
        t4b := t + 4.
        self assert:(t4b class == LargeInteger).
        self assert:(t4b printString = '4611686018427387904').
        t4c := (self do:t plus:4).
        self assert:(t4c class == LargeInteger).
        self assert:(t4c printString = '4611686018427387904').
    ].
    self assert:((Integer readFrom:'4611686018427387904') printString = '4611686018427387904').
    self assert:((Integer readFrom:'4611686018427387904') class == LargeInteger).

    "/ min-smallint on 64bit machines
    self assert:((Integer readFrom:'-4611686018427387904') printString = '-4611686018427387904').
    SmallInteger maxBytes == 8 ifTrue:[
        self assert:((Integer readFrom:'-4611686018427387904') class == SmallInteger)
    ].
    self assert:((Integer readFrom:'-4611686018427387904') printString = '-4611686018427387904').
    SmallInteger maxBytes == 8 ifTrue:[
        self assert:((Integer readFrom:'-4611686018427387904') class == SmallInteger)
    ].
    self assert:((Integer readFrom:'FFFFFFFF' radix:16) hexPrintString = 'FFFFFFFF').
    self assert:((Integer readFrom:'FFFFFFFFF' radix:16) hexPrintString = 'FFFFFFFFF').
    self assert:((Integer readFrom:'FFFFFFFFFF' radix:16) hexPrintString = 'FFFFFFFFFF').
    self assert:((Integer readFrom:'FFFFFFFFFFF' radix:16) hexPrintString = 'FFFFFFFFFFF').
    self assert:((Integer readFrom:'FFFFFFFFFFFF' radix:16) hexPrintString = 'FFFFFFFFFFFF').
    self assert:((Integer readFrom:'FFFFFFFFFFFFF' radix:16) hexPrintString = 'FFFFFFFFFFFFF').
    self assert:((Integer readFrom:'FFFFFFFFFFFFFF' radix:16) hexPrintString = 'FFFFFFFFFFFFFF').
    self assert:((Integer readFrom:'FFFFFFFFFFFFFFF' radix:16) hexPrintString = 'FFFFFFFFFFFFFFF').
    self assert:((Integer readFrom:'3FFFFFFFFFFFFFF' radix:16) hexPrintString = '3FFFFFFFFFFFFFF').
    self assert:((Integer readFrom:'7FFFFFFFFFFFFFF' radix:16) hexPrintString = '7FFFFFFFFFFFFFF').
    self assert:((Integer readFrom:'400000000000000' radix:16) hexPrintString = '400000000000000').
    self assert:((Integer readFrom:'800000000000000' radix:16) hexPrintString = '800000000000000').

    self assert:((Integer readFrom:'16r-FFFFFFFF') printString = '-4294967295').
    self assert:((Integer readFrom:'-16rFFFFFFFFF') hexPrintString = '-FFFFFFFFF').
    self assert:((Integer readFrom:'-16rFFFFFFFFFF') hexPrintString = '-FFFFFFFFFF').
    self assert:((Integer readFrom:'-16rFFFFFFFFFFF') hexPrintString = '-FFFFFFFFFFF').
    self assert:((Integer readFrom:'-16rFFFFFFFFFFFF') hexPrintString = '-FFFFFFFFFFFF').
    self assert:((Integer readFrom:'-16rFFFFFFFFFFFFF') hexPrintString = '-FFFFFFFFFFFFF').
    self assert:((Integer readFrom:'-16rFFFFFFFFFFFFFF') hexPrintString = '-FFFFFFFFFFFFFF').
    self assert:((Integer readFrom:'-16rFFFFFFFFFFFFFFF') hexPrintString = '-FFFFFFFFFFFFFFF').
    self assert:((Integer readFrom:'-16r3FFFFFFFFFFFFFF') hexPrintString = '-3FFFFFFFFFFFFFF').
    self assert:((Integer readFrom:'-16r7FFFFFFFFFFFFFF') hexPrintString = '-7FFFFFFFFFFFFFF').
    self assert:((Integer readFrom:'-16r400000000000000') hexPrintString = '-400000000000000').
    self assert:((Integer readFrom:'-16r800000000000000') hexPrintString = '-800000000000000').

    self assert:((Integer readFrom:'10000000' radix:16) hexPrintString = '10000000').
    self assert:((Integer readFrom:'100000000' radix:16) hexPrintString = '100000000').
    self assert:((Integer readFrom:'1000000000' radix:16) hexPrintString = '1000000000').
    self assert:((Integer readFrom:'10000000000' radix:16) hexPrintString = '10000000000').
    self assert:((Integer readFrom:'100000000000' radix:16) hexPrintString = '100000000000').
    self assert:((Integer readFrom:'1000000000000' radix:16) hexPrintString = '1000000000000').
    self assert:((Integer readFrom:'10000000000000' radix:16) hexPrintString = '10000000000000').

    self assert:((Integer readFrom:'1152921504606846975' radix:10) hexPrintString = 'FFFFFFFFFFFFFFF').
    self assert:((Integer readFrom:'288230376151711743' radix:10) hexPrintString = '3FFFFFFFFFFFFFF').
    self assert:((Integer readFrom:'576460752303423487' radix:10) hexPrintString = '7FFFFFFFFFFFFFF').
    self assert:((Integer readFrom:'288230376151711744' radix:10) hexPrintString = '400000000000000').
    self assert:((Integer readFrom:'576460752303423488' radix:10) hexPrintString = '800000000000000').

    t := Integer readFrom:'FFFFFFFF' radix:16.
    self assert:((t + 1) hexPrintString = '100000000').
    t := Integer readFrom:'FFFFFFFFF' radix:16.
    self assert:((t + 1) hexPrintString = '1000000000').
    t := Integer readFrom:'FFFFFFFFFF' radix:16.
    self assert:((t + 1) hexPrintString = '10000000000').
    t := Integer readFrom:'FFFFFFFFFFF' radix:16.
    self assert:((t + 1) hexPrintString = '100000000000').

    t := Integer readFrom:'10000000' radix:16.
    self assert:((t + 1) hexPrintString = '10000001').
    t := Integer readFrom:'100000000' radix:16.
    self assert:((t + 1) hexPrintString = '100000001').
    t := Integer readFrom:'1000000000' radix:16.
    self assert:((t + 1) hexPrintString = '1000000001').
    t := Integer readFrom:'10000000000' radix:16.
    self assert:((t + 1) hexPrintString = '10000000001').

    "
     self basicNew testReading1
    "
!

testReadingPrinting1
    |nr inString outString|

    #(2 3 4 5 8 10 16) do:[:radix |
        "/ Transcript showCR:('testing radix %1...' bindWith:radix).
        1 to:1000 do:[:len |
            inString := '1',(String new:len withAll:$0).
            nr := Integer readFrom:inString radix:radix.
            outString := nr printStringRadix:radix.
            self assert:(outString = inString) description:('read/print failed for radix ',radix printString).
        ].    
    ].
    
    "
     self basicNew testReadingPrinting1
    "
!

testSmallIntegerArithmetic
    "arithmetic tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |s n1 n2 t|

    "/ test division and modulu ...
    self assert:(1 printString = '1').
    self assert:(10 printString = '10').
    self assert:(100 printString = '100').
    self assert:(1000 printString = '1000').
    self assert:(10000 printString = '10000').
    self assert:(100000 printString = '100000').

    "addition with overflow"

    SmallInteger maxBytes == 4 ifTrue:[
	n1 := 16r3FFFFFFF.
	n2 := -16r40000000.
    ] ifFalse:[
	n1 := 16r3FFFFFFFFFFFFFFF.
	n2 := -16r4000000000000000.
    ].
    self assert:(n1 class == SmallInteger).
    self assert:(n2 class == SmallInteger).

    self assert:((n1 + 1) class == LargeInteger).
    t := n1 + 1.
    self assert:((t - 1) class == SmallInteger).

    self assert:((n2 - 1) class == LargeInteger).
    t := n2 - 1.
    self assert:((t + 1) class == SmallInteger).

    self assert:((n1 negated) class == SmallInteger).
    self assert:((n2 negated) class == LargeInteger).
    self assert:((n1 perform:'negated' asSymbol) class == SmallInteger).
    self assert:((n2 perform:'negated' asSymbol) class == LargeInteger).

    self assert:((n1 abs == n1)).
    self assert:((n2 abs = n2 negated)).
    self assert:((n1 perform:'abs' asSymbol) == n1).
    self assert:((n2 perform:'abs' asSymbol) = n2 negated).

    self testSmallIntegerMultiplication1.
    self testSmallIntegerMultiplication1b.
    self testSmallIntegerMultiplication2.
    self testSmallIntegerDivision1.

    "
     self basicNew testSmallIntegerArithmetic
    "

    "Created: / 6.6.1999 / 14:47:51 / cg"
    "Modified: / 9.6.1999 / 17:49:57 / cg"
!

testSmallIntegerDivision1
    "division tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |s n1 n2 t|

    n1 := 1000.

    "/ truncation towards...

    "/ ... negative infinity
    n2 := 3.
    self assert:((n1 // n2) == 333).
    self assert:((n1 // n2) printString = '333').
    self assert:((n1 perform:'//' asSymbol with:n2) == 333).

    n2 := -3.
    self assert:((n1 // n2) == -334).
    self assert:((n1 // n2) printString = '-334').
    self assert:((n1 perform:'//' asSymbol with:n2) == -334).

    n2 := 3600000.
    self assert:((n1 // n2) == 0).
    self assert:((n1 // n2) printString = '0').
    self assert:((n1 perform:'//' asSymbol with:n2) == 0).

    n2 := -3600000.
    self assert:((n1 // n2) == -1).
    self assert:((n1 // n2) printString = '-1').
    self assert:((n1 perform:'//' asSymbol with:n2) == -1).

    "/ ... zero
    n2 := 3.
    self assert:((n1 quo: n2) == 333).
    self assert:((n1 quo: n2) printString = '333').
    self assert:((n1 perform:'quo:' asSymbol with:n2) == 333).

    n2 := -3.
    self assert:((n1 quo: n2) == -333).
    self assert:((n1 quo: n2) printString = '-333').
    self assert:((n1 perform:'quo:' asSymbol with:n2) == -333).

    n2 := 3600000.
    self assert:((n1 quo: n2) == 0).
    self assert:((n1 quo: n2) printString = '0').
    self assert:((n1 perform:'quo:' asSymbol with:n2) == 0).

    n2 := -3600000.
    self assert:((n1 quo: n2) == 0).
    self assert:((n1 quo: n2) printString = '0').
    self assert:((n1 perform:'quo:' asSymbol with:n2) == 0).

    "
     self basicNew testSmallIntegerDivision1
    "

    "Modified: / 9.6.1999 / 17:47:56 / cg"
    "Created: / 9.6.1999 / 17:49:45 / cg"
!

testSmallIntegerMultiplication1
    "multiply tests (var * const).
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |s n1 n2 t|

    n1 := 100000.
    n2 := n1 negated.

    self assert:(n1 printString = '100000').
    self assert:(n2 printString = '-100000').

    self assert:((n1 * 0) printString = '0').
    self assert:((n1 perform:'*' asSymbol with:0) printString = '0').

    self assert:((n1 * 1) printString = '100000').
    self assert:((n1 perform:'*' asSymbol with:1) printString = '100000').
    self assert:((n2 * 1) printString = '-100000').
    self assert:((n2 perform:'*' asSymbol with:1) printString = '-100000').

    self assert:((n1 * -1) printString = '-100000').
    self assert:((n1 perform:'*' asSymbol with:-1) printString = '-100000').
    self assert:((n2 * -1) printString = '100000').
    self assert:((n2 perform:'*' asSymbol with:-1) printString = '100000').

    self assert:((n1 * 2) printString = '200000').
    self assert:((n1 perform:'*' asSymbol with:2) printString = '200000').
    self assert:((n1 * 3) printString = '300000').
    self assert:((n1 perform:'*' asSymbol with:3) printString = '300000').
    self assert:((n1 * 4) printString = '400000').
    self assert:((n1 perform:'*' asSymbol with:4) printString = '400000').
    self assert:((n1 * 5) printString = '500000').
    self assert:((n1 perform:'*' asSymbol with:5) printString = '500000').
    self assert:((n1 * 6) printString = '600000').
    self assert:((n1 perform:'*' asSymbol with:6) printString = '600000').
    self assert:((n1 * 7) printString = '700000').
    self assert:((n1 perform:'*' asSymbol with:7) printString = '700000').
    self assert:((n1 * 8) printString = '800000').
    self assert:((n1 perform:'*' asSymbol with:8) printString = '800000').
    self assert:((n1 * 9) printString = '900000').
    self assert:((n1 perform:'*' asSymbol with:9) printString = '900000').
    self assert:((n1 * 10) printString = '1000000').
    self assert:((n1 perform:'*' asSymbol with:10) printString = '1000000').
    self assert:((n1 * 11) printString = '1100000').
    self assert:((n1 perform:'*' asSymbol with:11) printString = '1100000').
    self assert:((n1 * 12) printString = '1200000').
    self assert:((n1 perform:'*' asSymbol with:12) printString = '1200000').
    self assert:((n1 * 13) printString = '1300000').
    self assert:((n1 perform:'*' asSymbol with:13) printString = '1300000').
    self assert:((n1 * 14) printString = '1400000').
    self assert:((n1 perform:'*' asSymbol with:14) printString = '1400000').
    self assert:((n1 * 15) printString = '1500000').
    self assert:((n1 perform:'*' asSymbol with:15) printString = '1500000').
    self assert:((n1 * 16) printString = '1600000').
    self assert:((n1 perform:'*' asSymbol with:16) printString = '1600000').

    n1 := 1.
    n2 := 10.
    self assert:((n1 * n2) printString = '10').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10').
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '100').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100').
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '1000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '1000').
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '10000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10000').
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '100000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100000').
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '1000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '1000000').
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '10000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10000000').
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '100000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100000000').
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '1000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '1000000000').
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '10000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10000000000').
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '100000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100000000000').
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '1000000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '1000000000000').
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '10000000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10000000000000').

    n1 := 1.
    n2 := 10.
    self assert:((n1 * n2) printString = '10').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10').
    n1 := n1 * 10.
    self assert:((n1 * n2) printString = '100').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100').
    n1 := n1 * 10.
    self assert:((n1 * n2) printString = '1000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '1000').
    n1 := n1 * 10.
    self assert:((n1 * n2) printString = '10000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10000').
    n1 := n1 * 10.
    self assert:((n1 * n2) printString = '100000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100000').
    n1 := n1 * 10.
    self assert:((n1 * n2) printString = '1000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '1000000').
    n1 := n1 * 10.
    self assert:((n1 * n2) printString = '10000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10000000').
    n1 := n1 * 10.
    self assert:((n1 * n2) printString = '100000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100000000').
    n1 := n1 * 10.
    self assert:((n1 * n2) printString = '1000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '1000000000').
    n1 := n1 * 10.
    self assert:((n1 * n2) printString = '10000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10000000000').
    n1 := n1 * 10.
    self assert:((n1 * n2) printString = '100000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100000000000').
    n1 := n1 * 10.
    self assert:((n1 * n2) printString = '1000000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '1000000000000').
    n1 := n1 * 10.
    self assert:((n1 * n2) printString = '10000000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10000000000000').

    n1 := 10.
    n2 := 10.
    self assert:((n1 * n2) printString = '100').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100').
    n1 := n1 * 10.
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '10000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10000').
    n1 := n1 * 10.
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '1000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '1000000').
    n1 := n1 * 10.
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '100000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100000000').
    n1 := n1 * 10.
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '10000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10000000000').
    n1 := n1 * 10.
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '1000000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '1000000000000').
    n1 := n1 * 10.
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '100000000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100000000000000').
    n1 := n1 * 10.
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '10000000000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10000000000000000').
    n1 := n1 * 10.
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '1000000000000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '1000000000000000000').
    n1 := n1 * 10.
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '100000000000000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100000000000000000000').
    n1 := n1 * 10.
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '10000000000000000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '10000000000000000000000').
    n1 := n1 * 10.
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '1000000000000000000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '1000000000000000000000000').
    n1 := n1 * 10.
    n2 := n2 * 10.
    self assert:((n1 * n2) printString = '100000000000000000000000000').
    self assert:((n1 perform:'*' asSymbol with:n2) printString = '100000000000000000000000000').

    "
     self basicNew testSmallIntegerMultiplication1
    "

    "Modified: / 9.6.1999 / 17:47:56 / cg"
    "Created: / 9.6.1999 / 17:49:45 / cg"
!

testSmallIntegerMultiplication1b
    "multiply tests (const * var).
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |s n1 n2 t|

    n1 := 100000.
    n2 := n1 negated.

    self assert:((0 * n1) printString = '0').
    self assert:((0 perform:'*' asSymbol with:n1) printString = '0').

    self assert:((1 * n1) printString = '100000').
    self assert:((1 perform:'*' asSymbol with:n1) printString = '100000').
    self assert:((1 * n2) printString = '-100000').
    self assert:((1 perform:'*' asSymbol with:n2) printString = '-100000').

    self assert:((-1 * n1) printString = '-100000').
    self assert:((-1 perform:'*' asSymbol with:n1) printString = '-100000').
    self assert:((-1 * n2) printString = '100000').
    self assert:((-1 perform:'*' asSymbol with:n2) printString = '100000').

    self assert:((2 * n1) printString = '200000').
    self assert:((2 perform:'*' asSymbol with:n1) printString = '200000').
    self assert:((3 * n1) printString = '300000').
    self assert:((3 perform:'*' asSymbol with:n1) printString = '300000').
    self assert:((4 * n1) printString = '400000').
    self assert:((4 perform:'*' asSymbol with:n1) printString = '400000').
    self assert:((5 * n1) printString = '500000').
    self assert:((5 perform:'*' asSymbol with:n1) printString = '500000').
    self assert:((6 * n1) printString = '600000').
    self assert:((6 perform:'*' asSymbol with:n1) printString = '600000').
    self assert:((7 * n1) printString = '700000').
    self assert:((7 perform:'*' asSymbol with:n1) printString = '700000').
    self assert:((8 * n1) printString = '800000').
    self assert:((8 perform:'*' asSymbol with:n1) printString = '800000').
    self assert:((9 * n1) printString = '900000').
    self assert:((9 perform:'*' asSymbol with:n1) printString = '900000').
    self assert:((10 * n1) printString = '1000000').
    self assert:((10 perform:'*' asSymbol with:n1) printString = '1000000').
    self assert:((11 * n1) printString = '1100000').
    self assert:((11 perform:'*' asSymbol with:n1) printString = '1100000').

    "
     self basicNew testSmallIntegerMultiplication1b
    "

    "Modified: / 9.6.1999 / 17:47:56 / cg"
    "Created: / 9.6.1999 / 17:49:45 / cg"
!

testSmallIntegerMultiplication2
    "multiply tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |s n1 n2 t|

    n1 := 100000.
    n2 := n1 negated.

    self assert:((n1 * 2) printString = '200000').
    self assert:((n1 perform:'*' asSymbol with:2) printString = '200000').
    self assert:((n1 * 3) printString = '300000').
    self assert:((n1 perform:'*' asSymbol with:3) printString = '300000').
    self assert:((n1 * 4) printString = '400000').
    self assert:((n1 perform:'*' asSymbol with:4) printString = '400000').
    self assert:((n1 * 5) printString = '500000').
    self assert:((n1 perform:'*' asSymbol with:5) printString = '500000').
    self assert:((n1 * 6) printString = '600000').
    self assert:((n1 perform:'*' asSymbol with:6) printString = '600000').
    self assert:((n1 * 7) printString = '700000').
    self assert:((n1 perform:'*' asSymbol with:7) printString = '700000').
    self assert:((n1 * 8) printString = '800000').
    self assert:((n1 perform:'*' asSymbol with:8) printString = '800000').
    self assert:((n1 * 9) printString = '900000').
    self assert:((n1 perform:'*' asSymbol with:9) printString = '900000').
    self assert:((n1 * 10) printString = '1000000').
    self assert:((n1 perform:'*' asSymbol with:10) printString = '1000000').
    self assert:((n1 * 11) printString = '1100000').
    self assert:((n1 perform:'*' asSymbol with:11) printString = '1100000').
    self assert:((n1 * 12) printString = '1200000').
    self assert:((n1 perform:'*' asSymbol with:12) printString = '1200000').
    self assert:((n1 * 13) printString = '1300000').
    self assert:((n1 perform:'*' asSymbol with:13) printString = '1300000').
    self assert:((n1 * 14) printString = '1400000').
    self assert:((n1 perform:'*' asSymbol with:14) printString = '1400000').
    self assert:((n1 * 15) printString = '1500000').
    self assert:((n1 perform:'*' asSymbol with:15) printString = '1500000').
    self assert:((n1 * 16) printString = '1600000').
    self assert:((n1 perform:'*' asSymbol with:16) printString = '1600000').
    self assert:((n1 * 17) printString = '1700000').
    self assert:((n1 perform:'*' asSymbol with:17) printString = '1700000').
    self assert:((n1 * 18) printString = '1800000').
    self assert:((n1 perform:'*' asSymbol with:18) printString = '1800000').
    self assert:((n1 * 19) printString = '1900000').
    self assert:((n1 perform:'*' asSymbol with:19) printString = '1900000').

    "
     self basicNew testSmallIntegerMultiplication2
    "

    "Modified: / 9.6.1999 / 17:47:56 / cg"
    "Created: / 9.6.1999 / 17:49:45 / cg"
!

testSmallIntegerMultiplication3
    "multiply tests.
     Notice, the arithmetic tests are both performed via regular sends
     and via constructed performs. The reason is to test both inlined
     JIT-compiler code AND the regular methods code."

    |s n1 n2 t|

    n1 := 16rFFFF.
    n2 := n1 negated.

    self assert:((n1 * 2) printString = '131070').
    self assert:((n1 perform:'*' asSymbol with:2) printString = '131070').
    self assert:((n2 * 2) printString = '-131070').
    self assert:((n2 perform:'*' asSymbol with:2) printString = '-131070').

    n1 := 16rFFFFFF.
    n2 := n1 negated.

    self assert:((n1 * 2) printString = '33554430').
    self assert:((n1 perform:'*' asSymbol with:2) printString = '33554430').
    self assert:((n2 * 2) printString = '-33554430').
    self assert:((n2 perform:'*' asSymbol with:2) printString = '-33554430').

    n1 := 16r3FFFFFFF.
    n2 := n1 negated.

    self assert:((n1 * 2) printString = '2147483646').
    self assert:((n1 perform:'*' asSymbol with:2) printString = '2147483646').
    self assert:((n2 * 2) printString = '-2147483646').
    self assert:((n2 perform:'*' asSymbol with:2) printString = '-2147483646').

    SmallInteger maxBytes == 4 ifTrue:[
	n1 := 16r3FFFFFFF.
    ] ifFalse:[
	n1 := 16r3FFFFFFFFFFFFFFF.
    ].
    self assert:(n1 class == SmallInteger).
    self assert:((n1 * 2) class == LargeInteger).
    self assert:((n1 perform:'*' asSymbol with:2) class == LargeInteger).

    n1 := SmallInteger maxVal // 11.
    self assert:((n1 * 11) class == SmallInteger).

    n1 := n1 + 1.
    self assert:((n1 * 11) class == LargeInteger).

    "
     self basicNew testSmallIntegerMultiplication3
    "

    "Modified: / 9.6.1999 / 17:47:56 / cg"
    "Created: / 9.6.1999 / 17:49:45 / cg"
!

testSmallIntegerNegation
    "tests boundary conditions at small/large phase change."

    |n1 n2 n3|

    n1 := 16r3fffffff.
    n2 := n1 negated.
    n3 := n2 negated.

    self assert:(n1 class == SmallInteger).
    self assert:(n2 class == SmallInteger).
    self assert:(n3 == n1).

    self assert:(n1 = 16r3FFFFFFF).
    self assert:(n2 = -16r3FFFFFFF).
    self assert:(n1 == 16r3FFFFFFF).
    self assert:(n2 == -16r3FFFFFFF).
    self assert:(n1 printString = '1073741823').
    self assert:(n2 printString = '-1073741823').

    "/ ---------------------

    n1 := 16rffffffff.
    n2 := n1 negated.
    n3 := n2 negated.

    SmallInteger maxBytes == 8 ifTrue:[
        self assert:(n1 class == SmallInteger).
        self assert:(n2 class == SmallInteger).
        self assert:(n3 == n1).
        self assert:(n2 == -16rfFFFFFFF).
        self assert:(n1 == 16rfFFFFFFF).
    ] ifFalse:[
        self assert:(n1 class == LargeInteger).
        self assert:(n2 class == LargeInteger).
        self assert:(n3 = n1).
    ].
    self assert:(n1 = 16rfFFFFFFF).
    self assert:(n2 = -16rfFFFFFFF).
    self assert:(n1 printString = '4294967295').
    self assert:(n2 printString = '-4294967295').

    "/ ---------------------


    n1 := SmallInteger maxVal.
    n2 := n1 negated.
    n3 := n2 negated.

    self assert:(n1 class == SmallInteger).
    self assert:(n2 class == SmallInteger).
    self assert:(n3 == n1).

    SmallInteger maxBytes == 4 ifTrue:[
        self assert:(n1 = 16r3FFFFFFF).
        self assert:(n2 = -16r3FFFFFFF).
        self assert:(n1 == 16r3FFFFFFF).
        self assert:(n2 == -16r3FFFFFFF).
        self assert:(n1 printString = '1073741823').
        self assert:(n2 printString = '-1073741823').
    ] ifFalse:[
        self assert:(n1 printString = '4611686018427387903').
        self assert:(n2 printString = '-4611686018427387903').
        self assert:(n1 =   16r3FFFFFFFFFFFFFFF).
        self assert:(n2 =  -16r3FFFFFFFFFFFFFFF).
        self assert:(n1 ==  16r3FFFFFFFFFFFFFFF).
        self assert:(n2 == -16r3FFFFFFFFFFFFFFF).
    ].

    "
     self basicNew testSmallIntegerNegation
    "

    "Modified: / 09-11-2016 / 15:38:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-10-2016 / 23:31:11 / cg"
! !

!IntegerTest methodsFor:'tests-class protocol'!

testCreationFromBytes1
  "self run: #testCreationFromBytes1"

  " it is illegal for a LargeInteger to be less than SmallInteger maxVal."
  " here we test that Integer>>byte!!byte2:byte3:byte4: reconstructs SmallInteger maxVal as an instance of SmallInteger. "

   | maxSmallInt hexString
     byte1 byte2 byte3 byte4
     byte5 byte6 byte7 byte8
     builtInteger builtIntegerH builtIntegerL|

    maxSmallInt := SmallInteger maxVal.
    hexString := maxSmallInt printStringHex.
    ExternalAddress pointerSize == 8 ifTrue:[
	self assert: hexString size = 16.

	byte8 := Integer readFrom: (hexString copyFrom: 1 to: 2) base: 16.
	byte7 := Integer readFrom: (hexString copyFrom: 3 to: 4) base: 16.
	byte6 := Integer readFrom: (hexString copyFrom: 5 to: 6) base: 16.
	byte5 := Integer readFrom: (hexString copyFrom: 7 to: 8) base: 16.
	byte4 := Integer readFrom: (hexString copyFrom: 9 to: 10) base: 16.
	byte3 := Integer readFrom: (hexString copyFrom: 11 to: 12) base: 16.
	byte2 := Integer readFrom: (hexString copyFrom: 13 to: 14) base: 16.
	byte1 := Integer readFrom: (hexString copyFrom: 15 to: 16) base: 16.

	builtIntegerH := Integer byte1: byte5 byte2: byte6 byte3: byte7 byte4: byte8.
	builtIntegerL := Integer byte1: byte1 byte2: byte2 byte3: byte3 byte4: byte4.
	builtInteger := (builtIntegerH bitShift:32) bitOr:builtIntegerL.
	self assert: builtInteger = maxSmallInt.
    ] ifFalse:[
	self assert: hexString size = 8.

	byte4 := Integer readFrom: (hexString copyFrom: 1 to: 2) base: 16.
	byte3 := Integer readFrom: (hexString copyFrom: 3 to: 4) base: 16.
	byte2 := Integer readFrom: (hexString copyFrom: 5 to: 6) base: 16.
	byte1 := Integer readFrom: (hexString copyFrom: 7 to: 8) base: 16.

	builtInteger := Integer byte1: byte1 byte2: byte2 byte3: byte3 byte4: byte4.
	self assert: builtInteger = maxSmallInt.
    ].
    self assert: builtInteger class = SmallInteger
! !

!IntegerTest methodsFor:'tests-concrete bugs'!

a_rack:rack subrack:subr board:slot port:port channel:chn typeId:aTypeOrSymbol
    "create an Idn from the given arguments
    "
    |hgEnc typ idn
     eqEnc "{ Class:SmallInteger }"
     oid   "{ Class:SmallInteger }"
     IDN|

    IDN := self class.

    eqEnc := rack.

    eqEnc > 0 ifFalse:[
		 eqEnc < 0    ifTrue:[idn := #Dontcare]
	ifFalse:[port == 256  ifTrue:[idn := #NWNode]
	ifFalse:[ idn := #Unspecified ]].

      ^ idn
    ].

    eqEnc >= 255 ifTrue:[       "/ is a logical resource
	eqEnc > 255 ifTrue:[ ^ #Unspecified ].

	slot == 0 ifTrue:[
	    subr == 1 ifTrue:[ ^ #ConnectManager ].
	    subr == 2 ifTrue:[ ^ #ClockManager   ].
	].
	oid := 4.                               "/ logical resource
    ] ifFalse:[
	oid := 2.                               "/ equipment
    ].
    hgEnc := 0.
    typ   := aTypeOrSymbol.

    subr ~~ 0 ifTrue:[
	subr > 16r0f  ifTrue:[ ^ #Unspecified ].
	eqEnc := eqEnc bitOr:(subr bitShift: 8).

	slot ~~ 0 ifTrue:[
	    slot > 16rff  ifTrue:[ ^ #Unspecified ].
	    eqEnc := eqEnc bitOr:(slot bitShift:12).

	    port ~~ 0 ifTrue:[
		port > 16rff  ifTrue:[ ^ #Unspecified ].
		eqEnc := eqEnc bitOr:(port bitShift:20).

		chn ~~ 0 ifTrue:[
		    chn > 16rfff  ifTrue:[ ^ #Unspecified ].
		    oid   := 3.
		    typ   := aTypeOrSymbol ? 0.
		    hgEnc := chn.
		]
	    ]
	]
    ].

    typ notNil ifTrue:[
	typ isSymbol ifTrue:[
	    typ := 0
	].
	hgEnc := hgEnc bitOr:(typ bitShift:12).
	hgEnc := hgEnc bitOr:(oid bitShift:20).
    ].
    ^ #ok.

"
self basicNew rack:1 subrack:3 board:5 port:33 channel:8 typeId:7
"
!

rack:rack subrack:subr board:slot port:port channel:chn typeId:aTypeOrSymbol
    "create an Idn from the given arguments
    "
    |hgEnc typ idn
     eqEnc "{ Class:SmallInteger }"
     oid   "{ Class:SmallInteger }"|

    eqEnc := rack.

"/    eqEnc > 0 ifFalse:[
"/                 eqEnc < 0    ifTrue:[idn := IDN Dontcare]
"/        ifFalse:[port == 256  ifTrue:[idn := IDN NWNode]
"/        ifFalse:[ idn := IDN Unspecified ]].
"/
"/      ^ self fromIdn:idn
"/    ].

"/    eqEnc >= 255 ifTrue:[       "/ is a logical resource
"/        eqEnc > 255 ifTrue:[ ^ self fromIdn:(IDN Unspecified) ].
"/
"/        slot == 0 ifTrue:[
"/            subr == 1 ifTrue:[ ^ self fromIdn:(IDN ConnectManager) ].
"/            subr == 2 ifTrue:[ ^ self fromIdn:(IDN ClockManager)   ].
"/        ].
"/        oid := 4.                               "/ logical resource
"/    ] ifFalse:[
"/        oid := 2.                               "/ equipment
"/    ].
"/    hgEnc := 0.
"/    typ   := aTypeOrSymbol.

    subr ~~ 0 ifTrue:[
	subr > 16r0f  ifTrue:[ ^ nil "self fromIdn:(IDN Unspecified)" ].
	eqEnc := eqEnc bitOr:(subr bitShift: 8).

	slot ~~ 0 ifTrue:[
	    slot > 16rff  ifTrue:[ ^ nil "self fromIdn:(IDN Unspecified)" ].
	    eqEnc := eqEnc bitOr:(slot bitShift:12).

	    port ~~ 0 ifTrue:[
		port > 16rff  ifTrue:[ ^ self fromIdn:(IDN Unspecified) ].
		eqEnc := eqEnc bitOr:(port bitShift:20).

		chn ~~ 0 ifTrue:[
		    chn > 16rfff  ifTrue:[ ^ self fromIdn:(IDN Unspecified) ].
		    oid   := 3.
		    typ   := aTypeOrSymbol ? 0.
		    hgEnc := chn.
		]
	    ]
	]
    ].

    typ notNil ifTrue:[
	typ isSymbol ifTrue:[
	    typ := (MDT::MDTCType asNumberType:typ) ? 0
	].
	hgEnc := hgEnc bitOr:(typ bitShift:12).
	hgEnc := hgEnc bitOr:(oid bitShift:20).
    ].
    ^ self basicNew eqEncode:eqEnc hgEncode:hgEnc.

"
self basicNew rack:1 subrack:3 board:5 port:33 channel:8 typeId:7
"
!

test_gcdBug1
    |theBase theMersenne theRest theGcd theOldRest theOldGcd|

    theBase := 2.
    132 to:135 do:[:theOrder |
	false " <<<< here i replaced some piece of code by false just to reproduce the error without having to ship all my code >>>>" ifFalse:[
	    theRest := ((theBase raisedTo:theOrder) - 1) / (theBase - 1).
	    30 "theOrder - 1" to:67 do:[:theFactorOrder |
		"/Transcript show:theOrder; space.
		"/Transcript showCR:theFactorOrder.
		(theOrder \\ theFactorOrder) = 0 ifTrue:[
		    " <<<< is a divisor of the order >>>>"
		    self assert:theFactorOrder ~= 131 description:'131 ist kein Teiler von 132'.
		    self assert:(theOrder / theFactorOrder) isFraction not.
		    theMersenne := ((theBase raisedTo:theFactorOrder) - 1) / (theBase - 1).
		    theGcd := theRest gcd:theMersenne.
		    [ theGcd > 1 ] whileTrue:[
			self assert:theFactorOrder < 129.
			theOldRest := theRest asString.
			theOldGcd := theGcd asString.
			theRest := theRest / theGcd.
			theGcd := theGcd gcd:theRest.
			self assert:((theRest \\ theGcd) = 0).
			self assert:(theRest / theGcd) isFraction not.
		    ].
		].
	    ].
	    self assert:theRest ~= 1
		description:'there is no prime factor of order theOrder'
	].
    ].

    "
     self new test_gcdBug1
    "
    "Modified: / 27-04-2010 / 00:02:02 / cg"
!

test_gcdBug2
    |theBase theMersenne theRest theGcd theOldRest theOldGcd|

    theBase := 2.
    132 to:135 do:[:theOrder |
	false " <<<< here i replaced some piece of code by false just to
	 reproduce the error without having to ship all my code >>>>"
		ifFalse:[
		    theRest := ((theBase raisedTo:theOrder) - 1) / (theBase - 1).
		    60 "theOrder - 1" to:67 do:[:theFactorOrder |
			"/Transcript show:theOrder; space.
			"/Transcript showCR:theFactorOrder.
			(theOrder \\ theFactorOrder) = 0 ifTrue:[
			    " <<<< is a divisor of the order >>>>"
			    self assert:theFactorOrder ~= 131 description:'131 ist kein Teiler von 132'.
			    self assert:(theOrder / theFactorOrder) isFraction not.
			    theMersenne := ((theBase raisedTo:theFactorOrder) - 1) / (theBase - 1).
			    theGcd := theRest gcd:theMersenne.
			    [ theGcd > 1 ] whileTrue:[
				self assert:theFactorOrder < 129.
				theOldRest := theRest asString.
				theOldGcd := theGcd asString.
				theRest := theRest / theGcd.
				theGcd := theGcd gcd:theRest.
				self assert:((theRest \\ theGcd) = 0).
				self assert:(theRest / theGcd) isFraction not.
			    ].
			].
		    ].
		    self assert:theRest ~= 1
			description:'there is no prime factor of order theOrder'
		].
    ].

    "
     self new test_gcdBug2
    "
    "Modified: / 27-04-2010 / 00:02:09 / cg"
!

test_gcdBug3
    |theBase theMersenne theRest theGcd theOldRest theOldGcd|

    theBase := 2.
    132 to:135 do:[:theOrder |
	false " <<<< here i replaced some piece of code by false just to
	 reproduce the error without having to ship all my code >>>>"
		ifFalse:[
		    theRest := ((theBase raisedTo:theOrder) - 1) / (theBase - 1).
		    2 to:theOrder - 1 do:[:theFactorOrder |
			"/Transcript show:theOrder; space.
			"/Transcript showCR:theFactorOrder.
			(theOrder \\ theFactorOrder) = 0 ifTrue:[
			    " <<<< is a divisor of the order >>>>"
			    self assert:theFactorOrder ~= 131 description:'131 ist kein Teiler von 132'.
			    self assert:(theOrder / theFactorOrder) isFraction not.
			    theMersenne := ((theBase raisedTo:theFactorOrder) - 1) / (theBase - 1).
			    theGcd := theRest gcd:theMersenne.
			    [ theGcd > 1 ] whileTrue:[
				self assert:theFactorOrder < 129.
				theOldRest := theRest asString.
				theOldGcd := theGcd asString.
				theRest := theRest / theGcd.
				theGcd := theGcd gcd:theRest.
				self assert:((theRest \\ theGcd) = 0).
				self assert:(theRest / theGcd) isFraction not.
			    ].
			].
		    ].
		    self assert:theRest ~= 1
			description:'there is no prime factor of order theOrder'
		].
    ].

    "
     self new test_gcdBug3
    "
    "Modified: / 27-04-2010 / 00:02:15 / cg"
! !

!IntegerTest methodsFor:'tests-misc'!

test_primes
    self 
        assert: ((1 to: 30) select: [:i | i isPrime] as:Array) 
                            = #(2 3 5 7 11 13 17 19 23 29);
        assert: ((0 to: 30) collect: [:i | i nextPrime] as:Array)
                            = #(2 2 3 5 5 7 7 11 11 11 11 13 13 17 17 17 17 19 19 23 23 23 23 29 29 29 29 29 29 31 31).
! !

!IntegerTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

