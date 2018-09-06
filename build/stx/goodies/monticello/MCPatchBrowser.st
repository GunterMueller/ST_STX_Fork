"{ Package: 'stx:goodies/monticello' }"

MCCodeTool subclass:#MCPatchBrowser
	instanceVariableNames:'selection'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!


!MCPatchBrowser class methodsFor:'as yet unclassified'!

forPatch: aPatch
	^ self new patch: aPatch
! !

!MCPatchBrowser methodsFor:'accessing'!

items
	^ items
!

list
	^ self items collect: [:ea | ea summary]
!

patch: aPatch
	items _ aPatch operations asSortedCollection
! !

!MCPatchBrowser methodsFor:'as yet unclassified'!

annotations
	^selection ifNil: [ super annotations ]
		ifNotNil: [ selection annotations ]
!

changeSetNameForInstall
	"Answer the name of the change set into which my selection will be installed.
	Derive this from my label.
	If I have no label, use the current change set."

	| tokens |
	label ifNil: [ ^ChangeSet current name ].
	tokens := label findTokens: ' '.
	tokens removeAllFoundIn: { 'changes'. 'between'. 'and' }.
	(tokens size = 3 and: [ tokens second = '<working' ]) ifTrue: [ ^tokens first, '-to-working' ].
	tokens size = 2 ifFalse: [ ^'InstalledPatches' ].
	^'{1}-to-{2}' format: tokens 
!

installSelection
	| loader |
	selection ifNotNil:
		[loader _ MCPackageLoader new.
		selection applyTo: loader.
		loader loadWithName: self changeSetNameForInstall ]
! !

!MCPatchBrowser methodsFor:'menus'!

methodListMenu: aMenu
	selection ifNotNil:
		[aMenu addList:#(('install'	 installSelection) -)].
	super methodListMenu: aMenu.
	^ aMenu
! !

!MCPatchBrowser methodsFor:'morphic ui'!

buttonSpecs
	^ #((Invert invert 'Show the reverse set of changes')
		 (Export export 'Export the changes as a change set'))
!

defaultLabel
	^ 'Patch Browser'
!

perform: selector orSendTo: otherTarget
	"Selector was just chosen from a menu by a user.  If can respond, then
perform it on myself. If not, send it to otherTarget, presumably the
editPane from which the menu was invoked."

	(self respondsTo: selector)
		ifTrue: [^ self perform: selector]
		ifFalse: [^ otherTarget perform: selector]
!

widgetSpecs
	Preferences annotationPanes ifFalse: [ ^#(
		((listMorph:selection:menu: list selection methodListMenu:) (0 0 1 0.4) (0 0 0 0))
		((textMorph: text) (0 0.4 1 1))
		) ].

	^ {
		#((listMorph:selection:menu: list selection methodListMenu: ) (0 0 1 0.4) (0 0 0 0)).
		{ #(textMorph: annotations). #(0 0.4 1 0.4). { 0. 0. 0. self defaultAnnotationPaneHeight. } }.
		{ #(textMorph: text). #(0 0.4 1 1). { 0. self defaultAnnotationPaneHeight. 0. 0. } }.
		}
! !

!MCPatchBrowser methodsFor:'selecting'!

invert
	items _ items collect: [:ea | ea inverse].
	self changed: #list; changed: #text; changed: #selection
!

selection
	^ selection 
		ifNil: [0]
		ifNotNil: [self items indexOf: selection]
!

selection: aNumber
	selection _ aNumber = 0 ifFalse: [self items at: aNumber].
	self changed: #selection; changed: #text; changed: #annotations
! !

!MCPatchBrowser methodsFor:'subclassResponsibility'!

selectedClass
	| definition |
	selection ifNil: [ ^nil ].
	(definition _ selection definition) ifNil: [ ^nil ].
	definition isMethodDefinition ifFalse: [ ^nil ].
	^Smalltalk at: definition className ifAbsent: [ ]
!

selectedClassOrMetaClass
	| definition |
	selection ifNil: [ ^nil ].
	(definition _ selection definition) ifNil: [ ^nil ].
	definition isMethodDefinition ifFalse: [ ^nil ].
	^definition actualClass
!

selectedMessageCategoryName
	| definition |
	selection ifNil: [ ^nil ].
	(definition _ selection definition) ifNil: [ ^nil ].
	definition isMethodDefinition ifFalse: [ ^nil ].
	^definition category
!

selectedMessageName
	| definition |
	selection ifNil: [ ^nil ].
	(definition _ selection definition) ifNil: [ ^nil ].
	definition isMethodDefinition ifFalse: [ ^nil ].
	^definition  selector
! !

!MCPatchBrowser methodsFor:'text'!

text
	^ selection ifNil: [''] ifNotNil: [selection source]
!

text: aTextOrString
	self changed: #text
! !

!MCPatchBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPatchBrowser.st,v 1.2 2012-09-11 21:25:27 cg Exp $'
! !
