"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#AssociationTests
	instanceVariableNames:'empty nonEmpty a b'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!AssociationTests class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!AssociationTests class methodsFor:'queries'!

coveredClassNames
    ^ #( Association )

    "Created: / 06-07-2011 / 21:28:33 / cg"
! !

!AssociationTests methodsFor:'initialize-release'!

setUp
        a := 1 -> 'one'.
        b := 1 -> 'een'.
! !

!AssociationTests methodsFor:'tests-associations'!

testEquality

        self 
                assert: (a key = b key);
                deny: (a value = b value);
                deny: (a = b)
!

testEquality2
        |a1 a2|

        a1 := 10->100.
        a2 := 10->100.
        self assert: (a1 = a2)
!

testHash

        self 
                assert: (a hash = a copy hash);
                deny: (a hash = b hash)
!

testPrinting
    self assert:(a printString = '1->one').

    "Created: / 06-07-2011 / 21:37:59 / cg"
! !

!AssociationTests class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

