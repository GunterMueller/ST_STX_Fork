"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#LinkedListTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!


!LinkedListTest methodsFor:'Testing'!

testBasic1

    |l|

    l := LinkedList new.
    self assert:l isEmpty.
    self assert:l size == 0.
    self assert:l notEmpty not.

    l add:1.
    self assert:l notEmpty.
    self assert:l size == 1.
    self assert:l isEmpty not.

    l add:2.
    self assert:l size == 2.

    "
     self new testBasic1
    "
!

testIndexOf
    "value comparing (used to work with links only, in previous versions; now works with values also)"

    |l one two three four five|

    one := 'one'.
    two := 'two'.
    three := 'three'.
    four := 'four'.
    five := 'five'.

    l := LinkedList new.
    l add:one.
    l add:two.
    l add:three.
    l add:four.

    self assert:l notEmpty.
    self assert:l size == 4.

    self assert:(l indexOf:one copy) == 1.
    self assert:(l indexOf:two copy) == 2.
    self assert:(l indexOf:three copy) == 3.
    self assert:(l indexOf:four copy) == 4.
    self assert:(l indexOf:five copy) == 0.

    self assert:(l identityIndexOf:one) == 1.
    self assert:(l identityIndexOf:two) == 2.
    self assert:(l identityIndexOf:three) == 3.
    self assert:(l identityIndexOf:four) == 4.
    self assert:(l identityIndexOf:five) == 0.

    self assert:(l identityIndexOf:one copy) == 0.
    self assert:(l identityIndexOf:two copy) == 0.
    self assert:(l identityIndexOf:three copy) == 0.
    self assert:(l identityIndexOf:four copy) == 0.

    "
     self new testBasic1
    "
!

testRemove
    "removing (used to work with links only, in previous versions; now works with values also)"

    |l one two three four five e1 e2|

    one := 'one'.
    two := 'two'.
    three := 'three'.
    four := 'four'.
    five := 'five'.

    l := LinkedList new.
    l add:one.
    l add:two.
    l add:three.
    l add:four.

    self assert:l notEmpty.
    self assert:l size == 4.

    e1 := l remove:'one'.
    self assert:l size == 3.
    self assert:e1 = 'one'.

    e2 := l remove:'one' ifAbsent:nil.
    self assert:e2 isNil.
    self assert:l size == 3.

    e1 := l removeIdentical:two.
    self assert:l size == 2.
    self assert:e1 = 'two'.
    self assert:e1 == two.

    e2 := l removeIdentical:'three' copy ifAbsent:nil.
    self assert:e2 isNil.

    "
     self new testRemove
    "
! !

!LinkedListTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

