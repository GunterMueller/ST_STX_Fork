"{ Package: 'stx:goodies/monticello' }"

PackageInfo subclass:#MCEmptyPackageInfo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Mocks'
!


!MCEmptyPackageInfo class methodsFor:'as yet unclassified'!

initialize
	[self new register] on: MessageNotUnderstood do: []
!

wantsChangeSetLogging
	^ false
! !

!MCEmptyPackageInfo methodsFor:'as yet unclassified'!

classes
	^ #()
!

methods
	^ #()
!

packageName
	^ 'MCEmptyPackage'
! !

!MCEmptyPackageInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCEmptyPackageInfo.st,v 1.4 2012-09-11 21:21:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCEmptyPackageInfo.st,v 1.4 2012-09-11 21:21:51 cg Exp $'
!

version_SVN
    ^ '§Id: MCEmptyPackageInfo.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !

MCEmptyPackageInfo initialize!
