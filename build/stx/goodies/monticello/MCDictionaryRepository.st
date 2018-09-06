"{ Package: 'stx:goodies/monticello' }"

MCRepository subclass:#MCDictionaryRepository
	instanceVariableNames:'description dict'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!


!MCDictionaryRepository class methodsFor:'initialization'!

new
    ^self basicNew initialize
! !

!MCDictionaryRepository methodsFor:'accessing'!

description

	^ description ifNil: ['cache']
!

description: aString

	description := aString 
!

dictionary

	^ dict
!

dictionary: aDictionary

	dict := aDictionary
! !

!MCDictionaryRepository methodsFor:'as yet unclassified'!

includesVersionWithInfo: aVersionInfo
	^ dict includesKey: aVersionInfo
!

sortedVersionInfos
	| sorter |
	sorter := MCVersionSorter new.
	self allVersionInfos do: [:ea | sorter addVersionInfo: ea].
	^ sorter sortedVersionInfos

!

versionWithInfo: aVersionInfo ifAbsent: errorBlock
	^ dict at: aVersionInfo ifAbsent: errorBlock
! !

!MCDictionaryRepository methodsFor:'comparing'!

= other
	^ self == other
! !

!MCDictionaryRepository methodsFor:'initialization'!

initialize

	super initialize.
	dict := Dictionary new.

! !

!MCDictionaryRepository methodsFor:'printing & storing'!

basicStoreVersion: aVersion
	dict at: aVersion info put: aVersion
! !

!MCDictionaryRepository methodsFor:'queries'!

allVersionInfos
	^ dict values collect: [:ea | ea info]
!

closestAncestorVersionFor: anAncestry ifNone: errorBlock
	| info |
	info := anAncestry breadthFirstAncestors
			detect: [:ea | self includesVersionWithInfo: ea]
			ifNone: [^ errorBlock value].
	^ self versionWithInfo: info
!

includesVersionNamed: aString
	^ dict anySatisfy: [:ea | ea info name = aString]
! !

!MCDictionaryRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDictionaryRepository.st,v 1.5 2014-02-12 14:53:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDictionaryRepository.st,v 1.5 2014-02-12 14:53:33 cg Exp $'
!

version_SVN
    ^ '$Id: MCDictionaryRepository.st,v 1.5 2014-02-12 14:53:33 cg Exp $'
! !

