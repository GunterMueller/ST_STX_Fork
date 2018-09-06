"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGTraitDescriptionDefinition subclass:#RGTraitDefinition
	instanceVariableNames:'metaClass comment category package'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGTraitDefinition comment:'RGTraitDefinition is the concrete representation of a trait (no class)'
!

!RGTraitDefinition methodsFor:'accessing'!

category
    "Retrieves the tag-package associated to the receiver"

    ^category
!

category: aSymbol

    category:= aSymbol
!

classVariables

    ^#()
!

comment
    "Retrieves the comment definition object associated to the receiver"
    
    ^comment
!

comment: anObject
    "Sets a RGCommentDefinition object based on the argument"
    
    comment := anObject isRingObject 
        ifFalse: [ 
            RGCommentDefinition new
                parent: self;
                content: anObject; 
                yourself ]
        ifTrue: [anObject ]
    
!

instanceVariables

    ^#()
!

package
    "Retrieves the package in which this trait is contained"
    
    ^package
!

package: aRGPackage
    "Sets the package in which this trait is contained"
    
    package:= aRGPackage
!

sharedPools

    ^#()
!

stamp

    ^self hasComment ifTrue:[ self comment stamp ] ifFalse:[ nil ]
!

stamp: aString

    self hasComment
    ifTrue: [ self comment stamp: aString ]
    ifFalse:[ RGCommentDefinition new
                         parent: self; 
                         stamp: aString ]
!

theMetaClass

    ^metaClass
!

theNonMetaClass

    ^self
! !

!RGTraitDefinition methodsFor:'behavior'!

withMetaclass
    "Registers explicitly the metaclass of a trait"

    metaClass:= RGMetatraitDefinition class: self.
!

withMetaclass: aRGMetatraitDefinition
    "Registers explicitly the metaclass of a class"

    metaClass:= aRGMetatraitDefinition.
    metaClass baseClass: self.  
! !

!RGTraitDefinition methodsFor:'testing'!

hasComment

    ^comment isEmptyOrNil not
!

hasMetaclass

    ^metaClass notNil
!

hasStamp

    ^self stamp isEmptyOrNil not
!

isSameRevisionAs: aRGTraitDefinition
    "This method look for equality of the properties of the receiver"

    ^(super isSameRevisionAs: aRGTraitDefinition)
        and: [ self category = aRGTraitDefinition category 
        and: [ self traitCompositionSource = aRGTraitDefinition traitCompositionSource 
        and: [ ((self hasComment and: [ self comment isSameRevisionAs: aRGTraitDefinition comment ]) or:[ self hasComment not ])
        and: [ (self theMetaClass isSameRevisionAs: aRGTraitDefinition theMetaClass) ] ] ] ]
! !

