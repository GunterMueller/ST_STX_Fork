"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGContainer subclass:#RGNamespace
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Containers'
!

RGNamespace comment:'A namespace is a container that in addition to managing classes and methods, it also knows how to treat pools and global variables'
!

!RGNamespace methodsFor:'accessing global variables'!

globalVariableNamed: globalVariableName

    ^self elementNamed: globalVariableName in: self globalVariables
!

globalVariables
    "retrieves global variables"

    ^self elementsCategorized: #globalVariables
!

globalVariables: aCollection

    self elementsCategorized: #globalVariables with: aCollection
! !

!RGNamespace methodsFor:'accessing pools'!

poolNamed: poolName

    ^self elementNamed: poolName in: self pools
!

pools
    "retrieves the shares pools"

    ^self elementsCategorized: #pools
!

pools: aCollection

    self elementsCategorized: #pools with: aCollection
! !

!RGNamespace methodsFor:'adding elements'!

addElement: anObject in: aCollection

    anObject environment: self.
    super addElement: anObject in: aCollection
!

addGlobalVariable: anORGlobalVariableDefinition
    "adds anORGlobalVariableDefinition to the globals dictionary if satisfies it #isGlobalVariable"

    anORGlobalVariableDefinition isGlobalVariable ifFalse:[ ^self ].
    self addElement: anORGlobalVariableDefinition in: self globalVariables
!

addGlobalVariableNamed: globalVariableName
    "creates a RGGlobalVariableDefinition with the given name.
    It's verified that a pool with that name does not exist"

    (self includesGlobalVariableNamed: globalVariableName) ifTrue: [ ^self ].
    self addGlobalVariable: (RGGlobalVariableDefinition named: globalVariableName).
!

addPool: anORPoolDefinition
    "adds anORPoolDefinition to the pools dictionary if satisfies it #isPool"

    anORPoolDefinition isPool ifFalse:[ ^self ].
    self addElement: anORPoolDefinition in: self pools
!

addPoolNamed: poolName
    "creates a RGPoolDefinition with the given name.
    It's verified that a pool with that name does not exist"
    | pool |

    (self includesPoolNamed: poolName) ifTrue: [ ^self ].
    "A shared pool is a class inheriting from #SharedPool"
    pool := (RGClassDefinition named: poolName)
            superclassName: #SharedPool;
            isPool: true;
            yourself.
    self addPool: pool.
! !

!RGNamespace methodsFor:'initialization'!

initialize

    super initialize.
    self globalVariables: Dictionary new.
    self pools: Dictionary new.

    "Modified: / 02-09-2015 / 11:15:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RGNamespace methodsFor:'removing elements'!

removeGlobalVariable: anORGlobalVariableDefinition
    "removes anORGlobalVariableDefinition from the globals dictionary if satisfies it #isGlobalVariable"

    anORGlobalVariableDefinition isGlobalVariable ifFalse:[ ^self ].
    self removeElement: anORGlobalVariableDefinition from: self globalVariables
!

removePool: anORPoolDefinition
    "removes anORPoolDefinition from the pools dictionary if satisfies it #isPool"

    anORPoolDefinition isPool ifFalse:[ ^self ].
    self removeElement: anORPoolDefinition from: self pools
!

withoutGlobalVariables

    self removeElementsCategorized: #globalVariables
!

withoutPools

    self removeElementsCategorized: #pools
! !

!RGNamespace methodsFor:'testing'!

includesGlobalVariable: anORGlobalVariableDefinition

    ^self globalVariables includes: anORGlobalVariableDefinition
!

includesGlobalVariableNamed: globalVariableName
    
    ^self includesElementNamed: globalVariableName in: self globalVariables
!

includesPool: anORPoolDefinition

    ^self pools includes: anORPoolDefinition
!

includesPoolNamed: poolName
    
    ^self includesElementNamed: poolName in: self pools
!

isNamespace

    ^true
! !

