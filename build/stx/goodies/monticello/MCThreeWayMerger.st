"{ Package: 'stx:goodies/monticello' }"

MCMerger subclass:#MCThreeWayMerger
	instanceVariableNames:'index operations provisions redundantAdds'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Merging'
!


!MCThreeWayMerger class methodsFor:'initialization'!

new
    ^self basicNew initialize
! !

!MCThreeWayMerger class methodsFor:'as yet unclassified'!

base: aSnapshot patch: aPatch
	aPatch isEmpty ifTrue: [MCNoChangesException signal].
	^ self new
		addBaseSnapshot: aSnapshot;
		applyPatch: aPatch;
		yourself
		
!

base: aSnapshot target: targetSnapshot ancestor: ancestorSnapshot
	^ self base: aSnapshot patch: (targetSnapshot patchRelativeToBase: ancestorSnapshot)
! !

!MCThreeWayMerger methodsFor:'as yet unclassified'!

addBaseSnapshot: aSnapshot
	aSnapshot definitions do:
		[:ea |
		index add: ea.
		provisions addAll: ea provisions]
!

addDefinition: aDefinition

        | op |

        index
                definitionLike: aDefinition
                ifPresent: [:other |
                        (op := (self removalForDefinition: aDefinition))
                                ifNotNil:
                                        [
                                        self addOperation: (MCModification of: other to: aDefinition).
                                        self removeOperation: op.
                                        ^ self].
                        other = aDefinition
                                ifFalse: [self addConflictWithOperation: (MCModification of: other to: aDefinition)]
                                ifTrue: [self redundantAdds add: aDefinition]]
                ifAbsent: [self addOperation: (MCAddition of: aDefinition)]

    "Modified: / 12-09-2010 / 17:39:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addOperation: anOperation
	self operations add: anOperation
!

applyPatch: aPatch
	aPatch applyTo: self
!

applyTo: anObject
	super applyTo: anObject.
	self operations do: [:ea | ea applyTo: anObject]
!

baseSnapshot
	^ (MCSnapshot fromDefinitions: index definitions)
!

initialize
	super initialize.
	index := MCDefinitionIndex new.
	provisions := Set new
!

modificationConflictForDefinition: aDefinition
	^ conflicts ifNotNil:
		[conflicts detect:
			[:ea | (ea definition isRevisionOf: aDefinition) and:
				[ea operation isModification]] ifNone: []]
!

modifyDefinition: baseDefinition to: targetDefinition
	index
		definitionLike: baseDefinition
		ifPresent: [:other | other = baseDefinition
								ifTrue: [self addOperation: (MCModification of:  baseDefinition to: targetDefinition)]
								ifFalse: [other = targetDefinition
											ifFalse: [self addConflictWithOperation:
														(MCModification of: other to: targetDefinition)]]]
		ifAbsent: [self addConflictWithOperation: (MCAddition of: targetDefinition)]
!

operations
	^ operations ifNil: [operations := OrderedCollection new]
!

provisions
	^ provisions
!

redundantAdds
	^ redundantAdds ifNil: [redundantAdds := Set new]
!

removalForDefinition: aDefinition
	^ operations ifNotNil:
		[operations
			detect: [:ea | (ea definition isRevisionOf: aDefinition) and: [ea isRemoval]]
			ifNone: []]
!

removeConflict: aConflict
	conflicts remove: aConflict
!

removeDefinition: aDefinition
	index
		definitionLike: aDefinition
		ifPresent: [:other | | c | other = aDefinition
								ifTrue:
									[(c := self modificationConflictForDefinition: aDefinition)
										ifNotNil:
											[
											self addOperation: c operation.
											self removeConflict: c.
											^ self]. 
									(self redundantAdds includes: aDefinition)
										ifFalse: [self addOperation: (MCRemoval of: aDefinition)]]
								ifFalse:
									[self addConflictWithOperation: (MCRemoval of: other)]]
		ifAbsent: []
!

removeOperation: anOperation
	operations remove: anOperation
! !

!MCThreeWayMerger class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCThreeWayMerger.st,v 1.4 2012-09-11 21:29:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCThreeWayMerger.st,v 1.4 2012-09-11 21:29:38 cg Exp $'
!

version_SVN
    ^ '§Id: MCThreeWayMerger.st 17 2010-10-13 12:07:52Z vranyj1 §'
! !
