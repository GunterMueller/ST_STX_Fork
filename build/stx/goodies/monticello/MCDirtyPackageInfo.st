"{ Package: 'stx:goodies/monticello' }"

PackageInfo subclass:#MCDirtyPackageInfo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Mocks'
!


!MCDirtyPackageInfo class methodsFor:'as yet unclassified'!

initialize
	[self new register] on: MessageNotUnderstood do: []
!

wantsChangeSetLogging
	^ false
! !

!MCDirtyPackageInfo methodsFor:'as yet unclassified'!

classes
	^ Array new: 0.
!

methods
	^ MCMockClassA selectors
		select: [:ea | ea beginsWith: 'ordinal']
		thenCollect:
			[:ea | 
				MethodReference new 
					setStandardClass: MCMockClassA 
					methodSymbol: ea].
!

packageName
	^ 'MCDirtyPackage'
! !

!MCDirtyPackageInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDirtyPackageInfo.st,v 1.4 2012-09-11 21:21:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDirtyPackageInfo.st,v 1.4 2012-09-11 21:21:43 cg Exp $'
!

version_SVN
    ^ '§Id: MCDirtyPackageInfo.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !

MCDirtyPackageInfo initialize!
