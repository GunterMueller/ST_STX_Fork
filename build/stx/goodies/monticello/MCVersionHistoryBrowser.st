"{ Package: 'stx:goodies/monticello' }"

MCTool subclass:#MCVersionHistoryBrowser
	instanceVariableNames:'ancestry index repositoryGroup package infos'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!


!MCVersionHistoryBrowser methodsFor:'accessing'!

ancestry: anAncestry
	ancestry _ anAncestry
!

baseSnapshot
	^ self snapshotForInfo: ancestry
!

index
	"Answer the value of index"

	^ index
!

index: anObject
	"Set the value of index"

	index _ anObject
!

infos
	^ infos ifNil: [infos _ ancestry withBreadthFirstAncestors]
!

list
	^ self infos collect: [:ea | ea name]
!

package: aMCPackage
	package _ aMCPackage
!

repositoryGroup
	^ MCRepositoryGroup default
!

selectedInfo
	^ self infos at: self selection ifAbsent: [nil]
!

selectedSnapshot
	^ self snapshotForInfo: self selectedInfo
!

selection
	^ index ifNil: [0]
!

selection: aNumber
	index _ aNumber.
	self changed: #selection; changed: #summary
!

snapshotForInfo: aVersionInfo
	^ (self repositoryGroup versionWithInfo: aVersionInfo) snapshot
!

summary
	| selInfo |
	selInfo _ self selectedInfo.
	^ selInfo 
		ifNil: ['']
		ifNotNil: [selInfo summary]
! !

!MCVersionHistoryBrowser methodsFor:'morphic ui'!

defaultExtent
	^ 440@169.
	
!

defaultLabel
	^ ancestry name, ' History'
!

getMenu: aMenu
	index < 2 ifTrue: [^ aMenu].
	self fillMenu: aMenu fromSpecs: 
		(Array
			with: (Array with: 'view changes -> ', ancestry name with: #viewChanges)
			with: #('spawn history' spawnHistory)).
	^ aMenu
!

spawnHistory
	MCVersionHistoryBrowser new
		ancestry: self selectedInfo;
		package: package;
		show
!

viewChanges
	"Note that the patchLabel will be parsed in MCPatchBrowser>>installSelection, so don't translate it!!"
	| patch patchLabel |
	patchLabel _ 'changes between {1} and {2}' format: { self selectedInfo name. ancestry name }.
	patch _ self baseSnapshot patchRelativeToBase: self selectedSnapshot.
	(MCPatchBrowser forPatch: patch) label: patchLabel; show
!

widgetSpecs
	^ #(
		((listMorph:selection:menu: list selection getMenu:) (0 0 0.3 1))
		((textMorph: summary) (0.3 0 1 1))
	 	)
! !

!MCVersionHistoryBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionHistoryBrowser.st,v 1.2 2012-09-11 21:30:22 cg Exp $'
! !
