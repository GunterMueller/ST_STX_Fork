"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCVersionMerger
	instanceVariableNames:'records merger'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCVersionMerger class methodsFor:'as yet unclassified'!

mergeVersion: aVersion
	self new
		addVersion: aVersion;
		mergeWithNameLike: aVersion info name
!

new
	^ self basicNew initialize
! !

!MCVersionMerger methodsFor:'as yet unclassified'!

addVersion: aVersion
	| dep |
	records add: (MCMergeRecord version: aVersion).
	aVersion dependencies do:
		[:ea |
		dep _ ea resolve.
		(records anySatisfy: [:r | r version = dep]) ifFalse: [self addVersion: dep]]
!

initialize
	records _ OrderedCollection new.
	merger _ MCThreeWayMerger new.
!

merge
	records do: [:ea | merger addBaseSnapshot: ea packageSnapshot].
	records do: [:ea | merger applyPatch: ea mergePatch].
	self resolveConflicts ifTrue:
		[merger load.
		records do: [:ea | ea updateWorkingCopy]].
!

mergeWithNameLike: baseName
	records do: [:ea | merger addBaseSnapshot: ea packageSnapshot].
	records do: [:ea | merger applyPatch: ea mergePatch].
	self resolveConflicts ifTrue:
		[merger loadWithNameLike: baseName.
		records do: [:ea | ea updateWorkingCopy]].
!

resolveConflicts
	(records allSatisfy: [:ea | ea isAncestorMerge]) ifTrue: [MCNoChangesException signal. ^ false].
	^ ((MCMergeResolutionRequest new merger: merger)
		signal: 'Merging ', records first version info name) = true
! !

!MCVersionMerger class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionMerger.st,v 1.2 2012-09-11 21:30:49 cg Exp $'
! !
