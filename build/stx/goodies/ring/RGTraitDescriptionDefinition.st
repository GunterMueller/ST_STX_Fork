"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGBehaviorDefinition subclass:#RGTraitDescriptionDefinition
	instanceVariableNames:'users'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGTraitDescriptionDefinition comment:'RGTraitDescriptionDefinition is the common parent for traits and metatraits that know their users (ie. classes/metaclasses)'
!

!RGTraitDescriptionDefinition methodsFor:'accessing'!

traitUsers
    "Retrieves the receiver's classes and traits"
    
    ^users ifNil:[ users := OrderedCollection new ]
!

traitUsers: aCollection

    users:= aCollection
!

users
    "Retrieves the receiver's classes and traits"
    
    ^users ifNil:[ users := OrderedCollection new ]
!

users: aCollection

    users:= aCollection
! !

!RGTraitDescriptionDefinition methodsFor:'adding/removing users'!

addUser: aRGBehavior

    self users add: aRGBehavior
!

removeUser: aRGBehavior

    self users remove: aRGBehavior ifAbsent:[]
! !

!RGTraitDescriptionDefinition methodsFor:'testing'!

isTrait

    ^true
! !

!RGTraitDescriptionDefinition methodsFor:'variables'!

allClassVarNames

    ^#()
!

allInstVarNames

    ^#()
!

allSharedPoolNames

    ^#()
! !

