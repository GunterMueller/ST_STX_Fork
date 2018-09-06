"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGClassDescriptionDefinition subclass:#RGMetaclassDefinition
	instanceVariableNames:'baseClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGMetaclassDefinition comment:'RGMetaclassDefinition is a concrete representation of metaclasses of classes (traits are excluded)'
!


!RGMetaclassDefinition class methodsFor:'class initialization'!

class: anORClassDefinition

    ^self new
        baseClass: anORClassDefinition;
        yourself
! !

!RGMetaclassDefinition methodsFor:'accessing'!

baseClass: aRGClassDefinition
    baseClass:= aRGClassDefinition.
    baseClass name notNil ifTrue:[ 
        self name: (baseClass name, ' class') asSymbol
    ].

    "Modified: / 29-08-2015 / 12:03:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

    "Modified: / 29-08-2015 / 10:27:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theMetaClass

    ^self
!

theNonMetaClass

    ^baseClass
! !

!RGMetaclassDefinition methodsFor:'printing'!

storeOn: aStream
    
    aStream nextPut: $(. 
    super storeOn: aStream.
    aStream nextPutAll: ' baseClass:'.
    self theNonMetaClass storeOn: aStream.
    aStream nextPut: $).
    
! !

!RGMetaclassDefinition methodsFor:'testing'!

isMeta

    ^true
!

isSameRevisionAs: aRGMetaclassDefinition
    "This method look for equality of the properties of the receiver"

    ^(super isSameRevisionAs: aRGMetaclassDefinition)
        and:[ self traitCompositionSource = aRGMetaclassDefinition traitCompositionSource ]
! !

!RGMetaclassDefinition methodsFor:'variables'!

allClassVarNames

    ^self theNonMetaClass allClassVarNames
!

allSharedPoolNames

    ^self theNonMetaClass allSharedPoolNames
! !


!RGMetaclassDefinition class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

