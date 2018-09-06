"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCPatch
	instanceVariableNames:'operations'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Patching'
!


!MCPatch class methodsFor:'as yet unclassified'!

fromBase: baseSnapshot target: targetSnapshot
	^ self new initializeWithBase: baseSnapshot target: targetSnapshot
!

operations: aCollection
	^ self basicNew initializeWithOperations: aCollection
! !

!MCPatch methodsFor:'accessing'!

operations
	^ operations
! !

!MCPatch methodsFor:'applying'!

applyTo: anObject
	operations do: [:ea | ea applyTo: anObject].

! !

!MCPatch methodsFor:'intializing'!

initializeWithBase: baseSnapshot target: targetSnapshot
	| base target |	
	operations := OrderedCollection new.
	base := MCDefinitionIndex definitions: baseSnapshot definitions.
	target := MCDefinitionIndex definitions: targetSnapshot definitions.
	
	target definitions do:
		[:t |
		base
			definitionLike: t
			ifPresent: [:b | (b isSameRevisionAs: t) ifFalse: [operations add: (MCModification of: b to: t)]]
			ifAbsent: [operations add: (MCAddition of: t)]]
		displayingProgress: 'Diffing...'.
		
	base definitions do:
		[:b |
		target
			definitionLike: b
			ifPresent: [:t]
			ifAbsent: [operations add: (MCRemoval of: b)]]		
!

initializeWithOperations: aCollection
	operations := aCollection
! !

!MCPatch methodsFor:'querying'!

isEmpty
	^ operations isEmpty
! !

!MCPatch class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPatch.st,v 1.5 2012-09-11 21:25:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPatch.st,v 1.5 2012-09-11 21:25:17 cg Exp $'
!

version_SVN
    ^ '§Id: MCPatch.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
