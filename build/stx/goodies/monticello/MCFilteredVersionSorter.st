"{ Package: 'stx:goodies/monticello' }"

MCVersionSorter subclass:#MCFilteredVersionSorter
	instanceVariableNames:'target'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCFilteredVersionSorter methodsFor:'as yet unclassified'!

addVersionInfo: aVersionInfo
	(aVersionInfo hasAncestor: target)
		ifTrue: [super addVersionInfo: aVersionInfo]
!

processVersionInfo: aVersionInfo
	| success |
	aVersionInfo = target ifTrue: [^ true].
	self pushLayer.
	success _ (self knownAncestorsOf: aVersionInfo) anySatisfy:
				[:ea | self processVersionInfo: ea].
	self popLayer.
	success ifTrue: [self addToCurrentLayer: aVersionInfo].
	^ success	
!

target: aVersionInfo
	target _ aVersionInfo
! !

!MCFilteredVersionSorter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCFilteredVersionSorter.st,v 1.2 2012-09-11 21:22:04 cg Exp $'
! !
