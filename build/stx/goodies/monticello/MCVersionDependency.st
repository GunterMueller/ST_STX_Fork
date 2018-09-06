"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCVersionDependency
	instanceVariableNames:'package versionInfo'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCVersionDependency class methodsFor:'as yet unclassified'!

package: aPackage info: aVersionInfo
	^ self basicNew initializeWithPackage: aPackage info: aVersionInfo
! !

!MCVersionDependency methodsFor:'accessing'!

package
	^ package
!

repositoryGroup
	^ self package workingCopy repositoryGroup
!

versionInfo
	^ versionInfo
! !

!MCVersionDependency methodsFor:'comparing'!

= other
	^ other species = self species
		and: [other versionInfo = versionInfo
				and: [other package = package]]
!

hash
	^ versionInfo hash
! !

!MCVersionDependency methodsFor:'initialize-release'!

initializeWithPackage: aPackage info: aVersionInfo
	package _ aPackage.
	versionInfo _ aVersionInfo
! !

!MCVersionDependency methodsFor:'resolving'!

resolve
	^ self repositoryGroup
		versionWithInfo: versionInfo
		ifNone: [ MCRepositoryGroup default versionWithInfo: versionInfo ifNone: []]
! !

!MCVersionDependency methodsFor:'testing'!

isCurrent
	^ package hasWorkingCopy
		and: [self isFulfilled
			and: [package workingCopy modified not]]
!

isFulfilled
	^package hasWorkingCopy
		and: [self isFulfilledBy: package workingCopy ancestry]
!

isFulfilledBy: anAncestry
	^ anAncestry ancestors includes: versionInfo
!

isFulfilledByAncestors
	^ package hasWorkingCopy
		and: [self isFulfilledByAncestorsOf: package workingCopy ancestry]
!

isFulfilledByAncestorsOf: anAncestry
	^ anAncestry hasAncestor: versionInfo
!

isOlder
	"Answer true if I represent an older version of a package that is loaded."
	^ package hasWorkingCopy
		and: [self isFulfilled not
			and: [ self isFulfilledByAncestors
				and: [package workingCopy modified not]]]
! !

!MCVersionDependency class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionDependency.st,v 1.2 2012-09-11 21:30:13 cg Exp $'
! !
