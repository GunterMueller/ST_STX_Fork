"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCPatchBrowser subclass:#MCMergeBrowser
	instanceVariableNames:'conflicts merger ok'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!


!MCMergeBrowser class methodsFor:'as yet unclassified'!

resolveConflictsInMerger: aMerger
	| inst |
	inst _ self new merger: aMerger.
	^ inst showModally ifNil: [false]
! !

!MCMergeBrowser methodsFor:'as yet unclassified'!

buttonSpecs
	^ #((Merge merge 'Proceed with the merge' canMerge)
		 (Cancel cancel 'Cancel the merge')
		('All Newer' chooseAllNewerConflicts 'Choose all newer conflict versions')
		('All Older' chooseAllOlderConflicts 'Choose all older conflict versions')
		('Rest Local' chooseAllUnchosenLocal 'Choose local versions of all remaining conflicts')
		('Rest Remote' chooseAllUnchosenRemote 'Choose remote versions of all remaining conflicts')
)
!

canMerge
	^ merger isMerged
!

cancel
	self answer: false
!

chooseAllNewerConflicts
	conflicts do: [ :ea | ea chooseNewer ].
	self changed: #text; changed: #list.
!

chooseAllOlderConflicts
	conflicts do: [ :ea | ea chooseOlder ].
	self changed: #text; changed: #list.
!

chooseAllUnchosenLocal
	conflicts do: [ :ea | ea isResolved ifFalse: [ ea chooseLocal ] ].
	self changed: #text; changed: #list.
!

chooseAllUnchosenRemote
	conflicts do: [ :ea | ea isResolved ifFalse: [ ea chooseRemote ] ].
	self changed: #text; changed: #list.
!

chooseLocal
	self conflictSelectionDo:
		[selection chooseLocal.
		self changed: #text; changed: #list]
!

chooseRemote
	self conflictSelectionDo:
		[selection chooseRemote.
		self changed: #text; changed: #list]
!

clearChoice
	self conflictSelectionDo:
		[selection clearChoice.
		self changed: #text; changed: #list]
!

conflictSelectionDo: aBlock
	self selectionIsConflicted
		ifTrue: aBlock
		ifFalse: [self inform: 'You must have a conflict selected']
!

defaultLabel
	^ 'Merge Browser'
!

getConflictMenu: aMenu
	selection remoteChosen
		ifTrue: [aMenu add: 'undo keep change' target: self selector: #clearChoice]
		ifFalse: [aMenu add: 'keep change' target: self selector: #chooseRemote].
	selection localChosen
		ifTrue: [aMenu add: 'undo reject change' target: self selector: #clearChoice]	
		ifFalse: [aMenu add: 'reject change' target: self selector: #chooseLocal].
	^ aMenu
!

getMenu: aMenu
	selection ifNil: [^ aMenu].
	^ self selectionIsConflicted
		ifTrue: [self getConflictMenu: aMenu]
		ifFalse: [self getOperationMenu: aMenu]
!

getOperationMenu: aMenu
	^ aMenu
!

innerButtonRow
	^ self buttonRow:
		#((Keep chooseRemote 'keep the selected change' selectionIsConflicted)
		  (Reject chooseLocal 'reject the selected change' selectionIsConflicted))
!

items
	^ conflicts, items
!

merge
	merger isMerged
		ifFalse: [self inform: 'You must resolve all the conflicts first']
		ifTrue: [self answer: true] 
!

merger: aMerger
	merger _ aMerger.
	items _ aMerger operations asSortedCollection.
	conflicts _ aMerger conflicts.
!

selectionIsConflicted
	^ selection isKindOf: MCConflict
!

widgetSpecs
	Preferences annotationPanes ifFalse: [ ^#(
		((buttonRow) (0 0 1 0) (0 0 0 30))
		((listMorph:selection:menu: list selection methodListMenu:) (0 0 1 0.4) (0 30 0 0))
		((innerButtonRow) (0 0.4 1 0.4) (0 0 0 30))
		((textMorph: text) (0 0.4 1 1) (0 30 0 0))
		)].

	^ #(
		((buttonRow) (0 0 1 0) (0 0 0 30))
		((listMorph:selection:menu: list selection methodListMenu:) (0 0 1 0.4) (0 30 0 0))
		((innerButtonRow) (0 0.4 1 0.4) (0 0 0 30))
		((textMorph: annotations) (0 0.4 1 0.4) (0 30 0 60))
		((textMorph: text) (0 0.4 1 1) (0 60 0 0))
		)
! !

!MCMergeBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMergeBrowser.st,v 1.2 2012-09-11 21:12:50 cg Exp $'
! !

