"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCMergeRecord
	instanceVariableNames:'version packageSnapshot ancestorInfo ancestor ancestorSnapshot
		imagePatch mergePatch'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCMergeRecord class methodsFor:'as yet unclassified'!

version: aVersion
	^ self basicNew initializeWithVersion: aVersion
! !

!MCMergeRecord methodsFor:'as yet unclassified'!

ancestorInfo
	^ ancestorInfo ifNil: [ancestorInfo _ version info commonAncestorWith: version workingCopy ancestry]
!

ancestorSnapshot
	^ ancestorSnapshot ifNil: [ancestorSnapshot _ version workingCopy findSnapshotWithVersionInfo: self ancestorInfo]
!

imageIsClean
	| ancestors |
	ancestors _ version workingCopy ancestors.
	^ ancestors size = 1
		and: [ancestors first = self ancestorInfo]	
		and: [self imagePatch isEmpty]
!

imagePatch
	^ imagePatch ifNil: [imagePatch _ self packageSnapshot patchRelativeToBase: self ancestorSnapshot]
!

initializeWithVersion: aVersion
	version _ aVersion
!

isAncestorMerge
	^ version workingCopy ancestry hasAncestor: version info
!

mergePatch
	^ mergePatch ifNil: [mergePatch _ version snapshot patchRelativeToBase: self ancestorSnapshot]
!

packageSnapshot
	^ packageSnapshot ifNil: [packageSnapshot _ version package snapshot]
!

updateWorkingCopy
	self isAncestorMerge ifFalse:
		[self imageIsClean
			ifTrue: [version workingCopy loaded: version]
			ifFalse: [version workingCopy merged: version]]
!

version
	^ version
! !

!MCMergeRecord class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMergeRecord.st,v 1.2 2012-09-11 21:23:10 cg Exp $'
! !
