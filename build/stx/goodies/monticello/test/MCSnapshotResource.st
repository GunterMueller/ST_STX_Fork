"{ Package: 'stx:goodies/monticello/test' }"

TestResource subclass:#MCSnapshotResource
	instanceVariableNames:'snapshot'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCSnapshotResource class methodsFor:'as yet unclassified'!

mockPackage
	^ (MCPackage new name: self mockPackageName)
!

mockPackageName
	^ MCMockPackageInfo new packageName
!

takeSnapshot
	^ self mockPackage snapshot
! !

!MCSnapshotResource methodsFor:'as yet unclassified'!

definitions
	^ snapshot definitions
!

setUp
	snapshot _ self class takeSnapshot.
!

snapshot
	^ snapshot
! !

!MCSnapshotResource class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCSnapshotResource.st,v 1.2 2013-05-29 00:00:24 vrany Exp $'
! !

