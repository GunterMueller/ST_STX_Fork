"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCMerger
	instanceVariableNames:'conflicts'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Merging'
!


!MCMerger methodsFor:'as yet unclassified'!

addConflictWithOperation: anOperation
	self conflicts add: (MCConflict operation: anOperation)
!

applyTo: anObject
	self isMerged ifFalse: [self error: 'You must resolve all the conflicts first'].
	conflicts do: [:ea | ea applyTo: anObject]
!

conflicts
	^ conflicts ifNil: [conflicts := OrderedCollection new]
!

isMerged
	^ self conflicts allSatisfy: [:ea | ea isResolved]
!

load
	| loader |
	loader := MCPackageLoader new.
	loader provisions addAll: self provisions.
	self applyTo: loader.
	loader load
!

loadWithNameLike: baseName
	| loader |
	loader := MCPackageLoader new.
	loader provisions addAll: self provisions.
	self applyTo: loader.
	loader loadWithNameLike: baseName
!

mergedSnapshot
	^ MCPatcher apply: self to: self baseSnapshot
!

operations
	^ #()
!

provisions
	^ #()
! !

!MCMerger class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMerger.st,v 1.4 2012-09-11 21:23:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMerger.st,v 1.4 2012-09-11 21:23:15 cg Exp $'
!

version_SVN
    ^ '§Id: MCMerger.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
