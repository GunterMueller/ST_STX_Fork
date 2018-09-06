"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCTool
	instanceVariableNames:'morph label modal modalValue'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!


!MCTool methodsFor:'morphic ui'!

answer: anObject
	modalValue _ anObject.
	self close.
!

arrowKey: aCharacter from: aPluggableListMorph 
	"backstop"
!

buildWindow
	| window |
	window _ SystemWindow labelled: self label.
	window model: self.
	self widgetSpecs do:
		[:pair | |send fractions offsets|
		send _ pair first.
		fractions _ pair at: 2 ifAbsent: [#(0 0 1 1)].
		offsets _ pair at: 3 ifAbsent: [#(0 0 0 0)].
		window
			addMorph: (self perform: send first withArguments: send allButFirst )
			fullFrame:
				(LayoutFrame
					fractions: 
					((fractions first)@(fractions second) corner: 
						(fractions third)@(fractions fourth))
					offsets:
						((offsets first)@(offsets second)  corner:
							(offsets third)@(offsets fourth)))].
	^ window
!

buildWith: builder
	|  windowBuilder |

	windowBuilder _ MCToolWindowBuilder builder: builder tool: self.
	self widgetSpecs do:
		[:spec | | send fractions offsets origin corner |
		send _ spec first.
		fractions _ spec at: 2 ifAbsent: [#(0 0 1 1)].
		offsets _ spec at: 3 ifAbsent: [#(0 0 0 0)].
		origin _ (offsets first @ offsets second) 
			/ self defaultExtent asFloatPoint
			+ (fractions first @ fractions second).
		corner _ (offsets third @ offsets fourth) 
			/ self defaultExtent asFloatPoint
			+ (fractions third @ fractions fourth).
		windowBuilder frame: (origin corner: corner).
		windowBuilder perform: send first withArguments: send allButFirst].

	^ windowBuilder build
!

buttonEnabled
	^ true
!

buttonRow
	^ self buttonRow: self buttonSpecs
!

buttonRow: specArray
	| aRow aButton enabled selected |
	aRow _ AlignmentMorph newRow.
	aRow 
		color: (Display depth <= 8 ifTrue: [Color transparent] ifFalse: [Color gray alpha: 0.2]);
		borderWidth: 0.

	aRow hResizing: #spaceFill; vResizing: #spaceFill; rubberBandCells: true.
	aRow clipSubmorphs: true.
	aRow layoutInset: 5@2; cellInset: 3.
	aRow wrapCentering: #center; cellPositioning: #leftCenter.
	specArray do:
		[:triplet |
			enabled _ triplet at: 4 ifAbsent: [#buttonEnabled].
			selected _ triplet at: 5 ifAbsent: [enabled].
			aButton _ PluggableButtonMorph
				on: self
				getState: selected
				action: #performButtonAction:enabled:.
			aButton
				hResizing: #spaceFill;
				vResizing: #spaceFill;
				useRoundedCorners;
				label: triplet first asString;
				arguments: (Array with: triplet second with: enabled); 
				onColor: Color transparent offColor: Color white.
			aRow addMorphBack: aButton.
			aButton setBalloonText: triplet third].
		
	Preferences alternativeWindowLook ifTrue:[
		aRow color: Color transparent.
		aRow submorphsDo:[:m| m borderWidth: 2; borderColor: #raised].
	].

	^ aRow
!

buttonSelected
	^ false
!

buttonSpecs
	^ #()
!

buttonState
	^ true
!

close
	self window delete
!

defaultAnnotationPaneHeight 
	"Answer the receiver's preferred default height for new annotation panes."
	^ Preferences parameterAt: #defaultAnnotationPaneHeight ifAbsentPut: [25]
!

defaultBackgroundColor 
	^ (Color r: 0.627 g: 0.69 b: 0.976)
!

defaultButtonPaneHeight
	"Answer the user's preferred default height for new button panes."

	^ Preferences parameterAt: #defaultButtonPaneHeight ifAbsentPut: [25]
!

defaultExtent
	^ 500@500
!

defaultLabel
	^ self class name
!

fillMenu: aMenu fromSpecs: anArray
	anArray do:
		[:pair |
		aMenu add: pair first target: self selector: pair second].
	^ aMenu
!

findListMorph: aSymbol
	^ morph submorphs detect: [:ea | (ea respondsTo: #getListSelector) and: [ea getListSelector = aSymbol]] ifNone: []
!

findTextMorph: aSymbol
	^ morph submorphs detect: [:ea | (ea respondsTo: #getTextSelector) and: [ea getTextSelector = aSymbol]] ifNone: []
!

getMenu: aMenu
	^aMenu
!

label
	^ label ifNil: [self defaultLabel]
!

label: aString
	label _ aString
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
	^ PluggableListMorph
		on: self
		list: listSymbol
		selected: selectionSymbol
		changeSelected: (selectionSymbol, ':') asSymbol
!

listMorph: listSymbol selection: selectionSymbol menu: menuSymbol
	^ PluggableListMorph
		on: self
		list: listSymbol
		selected: selectionSymbol
		changeSelected: (selectionSymbol, ':') asSymbol
		menu: menuSymbol
!

listMorph: listSymbol selection: selectionSymbol menu: menuSymbol keystroke: keystrokeSymbol
	^ (PluggableListMorph
		on: self
		list: listSymbol
		selected: selectionSymbol
		changeSelected: (selectionSymbol, ':') asSymbol
		menu: menuSymbol)
		keystrokeActionSelector: keystrokeSymbol;
		yourself
!

multiListMorph: listSymbol selection: selectionSymbol listSelection: listSelectionSymbol menu: menuSymbol
	^ PluggableListMorphOfMany
		on: self
		list: listSymbol
		primarySelection: selectionSymbol
		changePrimarySelection: (selectionSymbol, ':') asSymbol
		listSelection: listSelectionSymbol
		changeListSelection: (listSelectionSymbol, 'put:') asSymbol
		menu: menuSymbol
!

perform: selector orSendTo: otherTarget
	"Selector was just chosen from a menu by a user.  If can respond, then
perform it on myself. If not, send it to otherTarget, presumably the
editPane from which the menu was invoked."

	(self respondsTo: selector)
		ifTrue: [^ self perform: selector]
		ifFalse: [^ otherTarget perform: selector]
!

performButtonAction: anActionSelector enabled: anEnabledSelector
	(self perform: anEnabledSelector) 
		ifTrue: [ self perform: anActionSelector ]
!

show
	modal _ false.
	Smalltalk at: #ToolBuilder ifPresent: [:tb | tb open: self. ^ self].
	^self window openInWorldExtent: self defaultExtent; yourself
!

showLabelled: labelString
	modal _ false.
	self label: labelString.
	^(self window)
		openInWorldExtent: self defaultExtent;
		yourself
!

showModally
	modal _ true.
	self window openInWorldExtent: (400@400).
	[self window world notNil] whileTrue: [
		self window outermostWorldMorph doOneCycle.
	].
	morph _ nil.
	^ modalValue
!

step
!

textMorph: aSymbol
	^ PluggableTextMorph on: self text: aSymbol accept: (aSymbol, ':') asSymbol
!

treeMorph: listSymbol
	^ self
		treeMorph: (listSymbol, 'Tree') asSymbol
		selection: (listSymbol, 'SelectionWrapper') asSymbol
		menu: (listSymbol, 'TreeMenu:') asSymbol
!

treeMorph: listSymbol selection: selectionSymbol menu: menuSymbol
	^ SimpleHierarchicalListMorph
		on: self
		list: listSymbol
		selected: selectionSymbol
		changeSelected: (selectionSymbol, ':') asSymbol
		menu: menuSymbol
		keystroke: nil
!

treeOrListMorph: aSymbol
	^ self treeMorph: aSymbol
!

widgetSpecs
	^ #()
!

window
	^ morph ifNil: [morph _ self buildWindow]
! !

!MCTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCTool.st,v 1.2 2012-09-11 21:29:48 cg Exp $'
! !
