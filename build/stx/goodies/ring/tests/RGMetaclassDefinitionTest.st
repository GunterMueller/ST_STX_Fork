"{ Package: 'stx:goodies/ring/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#RGMetaclassDefinitionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel-Tests'
!

RGMetaclassDefinitionTest comment:'SUnit tests for Ring metaclass definitions'
!

!RGMetaclassDefinitionTest methodsFor:'testing'!

testAsMetaclassDefinition
    | rgClass class |
    class := Class class.
    rgClass:= class asRingDefinition.
    
    self assert: (rgClass isRingObject).
    self assert: (rgClass isClass).  
    self assert: (rgClass name == #'Class class').  
    self assert: (rgClass category == class category).
    self assert: (rgClass theMetaClass == rgClass).
! !

