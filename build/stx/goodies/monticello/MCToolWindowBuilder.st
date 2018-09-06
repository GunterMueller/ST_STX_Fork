"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MCToolWindowBuilder
	instanceVariableNames:'builder window currentFrame tool'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!


!MCToolWindowBuilder class methodsFor:'as yet unclassified'!

builder: aBuilder tool: aTool
	^ self basicNew initializeWithBuilder: aBuilder tool: aTool
! !

!MCToolWindowBuilder methodsFor:'as yet unclassified'!

build
	^ builder build: window
!

buttonRow
	^ self buttonRow: tool buttonSpecs
!

buttonRow: specArray
	| panel button |
	panel _ builder pluggablePanelSpec new.
	panel children: OrderedCollection new.
	specArray do:
		[:spec |
		
		button := builder pluggableButtonSpec new.
		button model: tool.
		button label: spec first asString.
		button action: spec second.
		button help: spec third.
		button enabled: (spec at: 4 ifAbsent: [#buttonEnabled]).
		button state: (spec at: 5 ifAbsent: [#buttonSelected]).
		panel children add: button].
	panel layout: #horizontal.
	panel frame: currentFrame.
	window children add: panel
!

frame: aLayoutFrame
	currentFrame _ aLayoutFrame
!

initializeWithBuilder: aBuilder tool: aTool
	builder _ aBuilder.
	tool _ aTool.
	window _ builder pluggableWindowSpec new.
	window children: OrderedCollection new.
	window label: tool label asString.
	window model: tool.
	window extent: tool defaultExtent.
!

listMorph: listSymbol
	^ self
		listMorph: (listSymbol, 'List') asSymbol
		selection: (listSymbol, 'Selection') asSymbol
		menu: (listSymbol, 'ListMenu:') asSymbol
!

listMorph: listSymbol keystroke: keystrokeSymbol
	^ (self
		listMorph: (listSymbol, 'List') asSymbol
		selection: (listSymbol, 'Selection') asSymbol
		menu: (listSymbol, 'ListMenu:') asSymbol)
		keystrokeActionSelector: keystrokeSymbol;
		yourself
!

listMorph: listSymbol selection: selectionSymbol
	self listMorph: listSymbol selection: selectionSymbol menu: nil
!

listMorph: listSymbol selection: selectionSymbol menu: menuSymbol
	self listMorph: listSymbol selection: selectionSymbol menu: menuSymbol keystroke: nil
!

listMorph: listSymbol selection: selectionSymbol menu: menuSymbol keystroke: keystrokeSymbol
	| list |
	list := builder pluggableListSpec new.
	list 
		model: tool;
		list: listSymbol; 
		getIndex: selectionSymbol; 
		setIndex: (selectionSymbol, ':') asSymbol;
		frame: currentFrame.
	menuSymbol ifNotNil: [list menu: menuSymbol].
	keystrokeSymbol ifNotNil: [list keyPress: keystrokeSymbol].
	window children add: list
!

multiListMorph: listSymbol selection: selectionSymbol listSelection: listSelectionSymbol menu: menuSymbol
	| list |
	list := builder pluggableMultiSelectionListSpec new.
	list 
		model: tool;
		list: listSymbol; 
		getIndex: selectionSymbol; 
		setIndex: (selectionSymbol, ':') asSymbol;
		getSelectionList: listSelectionSymbol;
		setSelectionList: (listSelectionSymbol, 'put:') asSymbol;
		frame: currentFrame.
	menuSymbol ifNotNil: [list menu: menuSymbol].
	window children add: list
!

textMorph: aSymbol
	| text |
	text := builder pluggableTextSpec new.
	text 
		model: tool;
		getText: aSymbol; 
		setText: (aSymbol, ':') asSymbol;
		frame: currentFrame.
	window children add: text
!

treeMorph: listSymbol
	^ self
		treeMorph: (listSymbol, 'Tree') asSymbol
		selection: (listSymbol, 'SelectionWrapper') asSymbol
		menu: (listSymbol, 'TreeMenu:') asSymbol
!

treeMorph: listSymbol selection: selectionSymbol menu: menuSymbol
	self notYetImplemented
!

treeOrListMorph: listSymbol
	^ self listMorph: listSymbol
! !

!MCToolWindowBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCToolWindowBuilder.st,v 1.2 2012-09-11 21:14:34 cg Exp $'
! !

