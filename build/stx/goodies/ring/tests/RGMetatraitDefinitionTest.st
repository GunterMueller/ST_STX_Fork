"{ Package: 'stx:goodies/ring/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#RGMetatraitDefinitionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel-Tests'
!

RGMetatraitDefinitionTest comment:'SUnit tests for Ring classtrait definitions'
!


!RGMetatraitDefinitionTest methodsFor:'testing'!

testAsClassTraitfinition
"/    | rgCTrait cTrait |
"/    cTrait := TClass classTrait.
"/    rgCTrait := cTrait asRingDefinition.
"/    self assert: rgCTrait isRingObject.
"/    self assert: rgCTrait isTrait.
"/    self assert: rgCTrait name == #'TClass classTrait'.
"/    self assert: rgCTrait category == cTrait category.
"/    self assert: rgCTrait theMetaClass == rgCTrait

    "Modified: / 29-08-2015 / 09:46:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RGMetatraitDefinitionTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

