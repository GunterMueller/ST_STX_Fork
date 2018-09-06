"{ Package: 'stx:goodies/ring/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#RGPackageTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Containers-Tests'
!

RGPackageTest comment:'SUnit tests for packages'
!


!RGPackageTest methodsFor:'testing'!

testAddingClass
    | newPackage newClass |
    
    newPackage:= RGPackage named: #'Collections-Sequenceable'.
    newClass:= RGClassDefinition named: #OrderedCollection.
    newPackage addClass: newClass.
    
    self assert: (newPackage hasClasses).
    self assert: (newClass package == newPackage).
    self assert: ((newPackage classNamed: #OrderedCollection) == newClass)
!

testAddingPackage
    | newPackage childPackage |
    
    newPackage:= RGPackage named: #'Collections'.
    newPackage addPackageNamed: #'Collections-Sequenceable'.
        
    self assert: (newPackage includesPackageNamed: #'Collections-Sequenceable').
    self assert: (newPackage packages size = 1).
    
    childPackage:= newPackage packageNamed: #'Collections-Sequenceable'.
    self assert: (childPackage parent = newPackage parent).
    self assert: (childPackage package = newPackage).
!

testNewPackage
    | newPackage |
    
    newPackage:= RGPackage named: 'Collections-Sequenceable'.
    
    self assert: (newPackage isPackage).
    self assert: (newPackage name = 'Collections-Sequenceable').
    self assert: (newPackage classes isEmpty).
    self assert: (newPackage traits isEmpty).
    self assert: (newPackage packages isEmpty).
    self assert: (newPackage package isNil).
    self assert: (newPackage parent == Smalltalk globals).
! !

!RGPackageTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

