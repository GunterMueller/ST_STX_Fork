"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#QuickTest
	instanceVariableNames:'a b'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!QuickTest methodsFor:'accessing'!

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

!QuickTest methodsFor:'comparing'!

testNE
    a = b ifTrue:[^ false].
    ^ true.
!

testNE0_fltArg
    a = 0.0 ifTrue:[^ false].
    ^ true.
!

testNE0_fltRec
    0.0 = a ifTrue:[^ false].
    ^ true.
!

testNE0_intArg
    a = 0 ifTrue:[^ false].
    ^ true.
!

testNE0_intRec
    0 = a ifTrue:[^ false].
    ^ true.
! !

!QuickTest methodsFor:'tests'!

ioRef
    ^ self
!

r3Name:arg
    self assert:(arg = 'foo')
!

r3PinName
    ^ self
!

refBlockName
    ^ 'foo'
!

test_eqNumberBug
    "reported 09-09-2004;
     stc generated wrong code for some inlined = - compare (shame)."

    self assert: (
       (self
	   a:0;
	   b:0) testNE ) == false.

    self assert: (
       (self
	   a:0;
	   b:0.0) testNE ) == false.

    self assert: (
       (self
	   a:0.0;
	   b:0) testNE ) == false.

    self assert: (
       (self
	   a:0.0;
	   b:0.0) testNE ) == false.


    self assert: (
       (self
	   a:0.0) testNE0_intArg ) == false.
    self assert: (
       (self
	   a:0.0) testNE0_fltArg ) == false.

    self assert: (
       (self
	   a:0.0) testNE0_intRec ) == false.
    self assert: (
       (self
	   a:0.0) testNE0_fltRec ) == false.

    self assert: (
       (self
	   a:0) testNE0_intArg ) == false.
    self assert: (
       (self
	   a:0) testNE0_fltArg ) == false.

    self assert: (
       (self
	   a:0) testNE0_intRec ) == false.
    self assert: (
       (self
	   a:0) testNE0_fltRec ) == false.

    self assert: (
       (self
	   a:1) testNE0_intArg ) == true.
    self assert: (
       (self
	   a:1) testNE0_fltArg ) == true.

    self assert: (
       (self
	   a:1) testNE0_intRec ) == true.
    self assert: (
       (self
	   a:1) testNE0_fltRec ) == true.

    self assert: (
       (self
	   a:1.0) testNE0_intArg ) == true.
    self assert: (
       (self
	   a:1.0) testNE0_fltArg ) == true.

    self assert: (
       (self
	   a:1.0) testNE0_intRec ) == true.
    self assert: (
       (self
	   a:1.0) testNE0_fltRec ) == true.

    "
     self new test_eqNumberBug
    "
!

test_isNilBug
    1000 timesRepeat:[
	10 timesRepeat:[
	    [
		self test_isNilBugForker
	    ] fork.
	].
	Delay waitForSeconds:0.5.
    ]

    "
     self new test_isNilBug
    "
!

test_isNilBugForker
    |bn blk order model pin|

    order := Array with:self with:self with:self.
    model := self.

    [
	order do:[:aPin |
	    (aPin ioRef notNil and:[(bn := aPin ioRef refBlockName) notNil]) ifTrue:[
		blk := model r3Name:bn.
		pin := aPin ioRef r3PinName.
		Processor yield.
	    ].
	].
    ] forkAt:6.
! !

!QuickTest class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !
