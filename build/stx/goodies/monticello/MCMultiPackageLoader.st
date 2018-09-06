"{ Package: 'stx:goodies/monticello' }"

MCPackageLoader subclass:#MCMultiPackageLoader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Loading'
!

MCMultiPackageLoader comment:'A PackageLoader doing some additional cross-package checks'
!


!MCMultiPackageLoader methodsFor:'private'!

analyze
	| index |
	index := MCDefinitionIndex definitions: additions.
	removals removeAllSuchThat: [:removal |
		(index definitionLike: removal
			ifPresent: [:addition | obsoletions at: addition put: removal]
			ifAbsent: []) notNil].
	super analyze
! !

!MCMultiPackageLoader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMultiPackageLoader.st,v 1.3 2012-09-11 21:24:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMultiPackageLoader.st,v 1.3 2012-09-11 21:24:40 cg Exp $'
!

version_SVN
    ^ '§Id: MCMultiPackageLoader.st 29 2011-03-14 12:24:51Z vranyj1 §'
! !
