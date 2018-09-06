"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGTraitDescriptionDefinition subclass:#RGMetatraitDefinition
	instanceVariableNames:'baseClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGMetatraitDefinition comment:'RGMetatraitDefinition is a concrete representation of metaclasses of traits'
!

!RGMetatraitDefinition class methodsFor:'class initialization'!

class: anORTraitDefinition

    ^self new
        baseClass: anORTraitDefinition;
        yourself
! !

!RGMetatraitDefinition methodsFor:'accessing'!

baseClass: anRGTraitDefinition

    baseClass:= anRGTraitDefinition.
    self name: (baseClass name, ' classTrait') asSymbol
!

category
    ^ self theNonMetaClass category
!

environment

    ^baseClass environment
!

package

    ^baseClass package
!

realClass

    ^baseClass realClass theMetaClass
!

theMetaClass

    ^self
!

theNonMetaClass

    ^baseClass
! !

!RGMetatraitDefinition methodsFor:'testing'!

isMeta

    ^true
!

isSameRevisionAs: aRGMetatraitDefinition
    "This method look for equality of the properties of the receiver"

    ^(super isSameRevisionAs: aRGMetatraitDefinition)
        and: [ self traitCompositionSource = aRGMetatraitDefinition traitCompositionSource ]
! !

