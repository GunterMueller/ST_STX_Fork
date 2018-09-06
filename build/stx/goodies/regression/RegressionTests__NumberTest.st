"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#NumberTest
	instanceVariableNames:'a b'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Numbers'
!


!NumberTest methodsFor:'accessing'!

a
    ^ a
!

a:something
    a := something.
!

b
    ^ b
!

b:something
    b := something.
! !

!NumberTest methodsFor:'running'!

tearDown
    Class withoutUpdatingChangesDo:[
	self class removeSelector:#testEQ
    ].
! !

!NumberTest methodsFor:'tests-concrete bugs'!

test_eqNumberBug
    "reported 09-09-2004;
     stc generated wrong code for some inlined = - compare (shame)."

    Class withoutUpdatingChangesDo:[
	self class
	    compile:
'testEQ
    a = b ifTrue:[^ false].
    ^ true.
'
	    classified:'temporary'.
    ].

    self assert: (
       (self
	   a:0;
	   b:0) testEQ ) == false.

    self assert: (
       (self
	   a:0;
	   b:0.0) testEQ ) == false.

    self assert: (
       (self
	   a:0.0;
	   b:0) testEQ ) == false.

    self assert: (
       (self
	   a:0.0;
	   b:0.0) testEQ ) == false.

    Class withoutUpdatingChangesDo:[
	Compiler stcCompileMethod:(self class compiledMethodAt:#testEQ).
    ].

    self assert: (
       (self
	   a:0;
	   b:0) testEQ ) == false.

    self assert: (
       (self
	   a:0;
	   b:0.0) testEQ ) == false.

    self assert: (
       (self
	   a:0.0;
	   b:0) testEQ ) == false.

    self assert: (
       (self
	   a:0.0;
	   b:0.0) testEQ ) == false.

    Class withoutUpdatingChangesDo:[
	self class removeSelector:#testEQ
    ].

    "
     self new test_eqNumberBug
    "
! !

!NumberTest methodsFor:'tests-conversion-rounding'!

test_conversion
    "reported as Bug 388
     Current implementation neither truncate nor round to nearest Floating point
     value, it just accumulate round off errors."


    self assert: 16r1FFFFFFFFFFFF0801 asDouble ~= 16r1FFFFFFFFFFFF0800 asDouble.
    "this test is on 65 bits"

    self assert: 16r1FFFFFFFFFFFF0802 asDouble ~= 16r1FFFFFFFFFFFF0800 asDouble.
    "this test is on 64 bits"

    self assert: 16r1FFFFFFFFFFF1F800 asDouble = 16r1FFFFFFFFFFF20000 asDouble.
    "nearest even is upper"
    self assert: 16r1FFFFFFFFFFFF0800 asDouble = 16r1FFFFFFFFFFFF0000 asDouble.
    "nearest even is lower"

    "Created: / 24-10-2006 / 15:31:20 / cg"
! !

!NumberTest methodsFor:'tests-reading'!

testReadFrom
    self assert: 1.0e-14    = (Number readFrom: '1.0e-14').

    self assert: ('1' asNumber = 1).
    self assert: ('10' asNumber = 10).

    self assert: ('-1' asNumber = -1).
    self assert: ('-10' asNumber = -10).

    self assert: ('1e' asNumber = 1).
    self assert: ('1e1' asNumber = 10).
    self assert: ('1e10' asNumber = 10000000000).

    self assert: ('-1e' asNumber = -1).
    self assert: ('-1e1' asNumber = -10).
    self assert: ('-1e10' asNumber = -10000000000).

    self assert: ('1.0e' asNumber = 1.0).
    self assert: ('1.0e1' asNumber = 10.0).
    self assert: ('1.0e10' asNumber = 10000000000.0).

    self assert: ('-1.0e' asNumber = -1.0).
    self assert: ('-1.0e1' asNumber = -10.0).
    self assert: ('-1.0e10' asNumber = -10000000000.0).

    self assert: ('22.2' asNumber = 22.2).
    self assert: ('-22.2' asNumber = -22.2).

    Smalltalk isSmalltalkX ifTrue:[
	"/ st/x requires this:

	self assert: ((Number readSmalltalkSyntaxFrom:'10r22.2') = 22.2).
	self assert: ((Number readSmalltalkSyntaxFrom:'10r22.2s5') = 22.2).

	self assert: ((Number readSmalltalkSyntaxFrom:'10r-22.2') = -22.2).
	self assert: ((Number readSmalltalkSyntaxFrom:'10r-22.2s5') = -22.2).

	self assert: 2r1e26     = (Number readSmalltalkSyntaxFrom: '2r1e26').
    ] ifFalse:[
	"/ squeak allows this:
	self assert: 2r1e26     = (Number readFrom: '2r1e26').

	self assert: ('10r22.2' asNumber = 22.2).
	self assert: ('10r22.2s5' asNumber = 22.2).

	self assert: ('10r-22.2' asNumber = -22.2).
	self assert: ('10r-22.2s5' asNumber = -22.2).
    ].
! !

!NumberTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

