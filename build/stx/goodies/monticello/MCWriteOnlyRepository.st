"{ Package: 'stx:goodies/monticello' }"

MCRepository subclass:#MCWriteOnlyRepository
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!


!MCWriteOnlyRepository methodsFor:'as yet unclassified'!

versionWithInfo: aVersionInfo ifAbsent: aBlock
	^ aBlock value
! !

!MCWriteOnlyRepository methodsFor:'queries'!

includesVersionNamed: aString
	^ false
! !

!MCWriteOnlyRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCWriteOnlyRepository.st,v 1.5 2014-02-12 14:53:32 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCWriteOnlyRepository.st,v 1.5 2014-02-12 14:53:32 cg Exp $'
!

version_SVN
    ^ '$Id: MCWriteOnlyRepository.st,v 1.5 2014-02-12 14:53:32 cg Exp $'
! !

