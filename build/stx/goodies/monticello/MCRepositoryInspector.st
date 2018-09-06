"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCVersionInspector subclass:#MCRepositoryInspector
	instanceVariableNames:'repository packages versions loaded selectedPackage
		selectedVersion'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!


!MCRepositoryInspector class methodsFor:'as yet unclassified'!

repository: aFileBasedRepository workingCopy: aWorkingCopy
	^self new
		setRepository: aFileBasedRepository workingCopy: aWorkingCopy;
		yourself
! !

!MCRepositoryInspector methodsFor:'as yet unclassified'!

hasVersion
	^ selectedVersion notNil
!

load
	self hasVersion ifTrue:
		[super load.
		self version workingCopy repositoryGroup addRepository: repository].
!

refresh
	packages _ repository packages.
	self changed: #packageList.
	self packageSelection: self packageSelection.
!

setRepository: aRepository workingCopy: aWorkingCopy
	repository _ aRepository.
	aWorkingCopy isNil ifFalse: [ selectedPackage _ aWorkingCopy package].
	self refresh
!

summary
	^ selectedVersion
		ifNotNil: [selectedVersion summary]
		ifNil: ['']
!

version
	^ version ifNil: [version _ repository versionWithInfo: selectedVersion]
! !

!MCRepositoryInspector methodsFor:'morphic ui'!

buttonSpecs
	^#(('Refresh' refresh 'refresh the version-list')) , super buttonSpecs
!

defaultExtent
	^450@300
!

defaultLabel
	^'Repository: ' , repository description
!

packageList
	^ packages collect: [:ea | ea name]
!

packageListMenu: aMenu
	^aMenu
!

packageSelection
	^ packages indexOf: selectedPackage
!

packageSelection: aNumber
	selectedPackage _ aNumber isZero ifFalse: [ packages at: aNumber ].
	versions _ repository versionsAvailableForPackage: selectedPackage.
	self changed: #packageSelection; changed: #versionList
!

sortedVersions
	| sorter |
	sorter _ MCVersionSorter new.
	sorter addAllVersionInfos: versions.
	^ sorter sortedVersionInfos select: [:ea | versions includes: ea]
!

versionList
	^ self sortedVersions collect: [:ea | ea name]
!

versionListMenu: aMenu
	^aMenu
!

versionSelection
	^ versions indexOf: selectedVersion
!

versionSelection: aNumber
	aNumber isZero 
		ifTrue: [ selectedVersion _ nil ]
		ifFalse: [ 
			selectedVersion _ versions at: aNumber].
	self changed: #versionSelection; changed: #summary
!

widgetSpecs
	^#(	((buttonRow) (0 0 1 0) (0 0 0 30))
		((listMorph: package) (0 0 0.5 0.6) (0 30 0 0))
		((listMorph: version) (0.5 0 1 0.6) (0 30 0 0))
		((textMorph: summary) (0 0.6 1 1) (0 0 0 0)) )
! !

!MCRepositoryInspector class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRepositoryInspector.st,v 1.2 2012-09-11 21:15:04 cg Exp $'
! !

