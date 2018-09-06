"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCPackageCache
	instanceVariableNames:'sorter fileNames'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!

!MCPackageCache class methodsFor:'documentation'!

documentation
"
    I'm a kind of cache for versions and filenames of packages.
"
! !

!MCPackageCache class methodsFor:'initialization'!

new
    ^self basicNew initialize
! !

!MCPackageCache methodsFor:'as yet unclassified'!

initialize
	super initialize.
	sorter := MCVersionSorter new.
	fileNames := Dictionary new.
!

recordVersionInfo: aVersionInfo forFileNamed: aString
	Transcript cr; show: aString.
	fileNames at: aVersionInfo put: aString.
	sorter addVersionInfo: aVersionInfo
!

versionInfos
	^ sorter sortedVersionInfos 
! !

!MCPackageCache class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPackageCache.st,v 1.5 2013-05-15 11:57:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPackageCache.st,v 1.5 2013-05-15 11:57:44 cg Exp $'
!

version_SVN
    ^ '$Id: MCPackageCache.st,v 1.5 2013-05-15 11:57:44 cg Exp $'
! !

