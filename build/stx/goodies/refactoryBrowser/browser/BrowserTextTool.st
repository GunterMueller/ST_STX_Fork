"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

CodeTool subclass:#BrowserTextTool
	instanceVariableNames:'menu savedText changed textHolder originalText'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Code Tools'
!

BrowserTextTool comment:'BrowserTextTool is an abstract class for all of the CodeTool''s that have a textual display.

Instance Variables:
	changed <Boolean>       has the text changed?
	menu    <Menu>  the menu for the text widget
	savedText       <String>        if the text has changed and we are switched out, then save the text here
	textHolder      <ValueHolder on: String>        contains the original text'
!


!BrowserTextTool class methodsFor:'interface specs'!

windowSpec
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        RBParser isSmalltalkX ifTrue:[
            ^ self windowSpecSTX
        ].
        ^ self windowSpecVW
!

windowSpecSTX
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Unlabeled Canvas' 
                        #bounds: #(#Rectangle 431 495 797 720 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#CodeViewSpec 
                                        #layout: #(#LayoutFrame 0 0 0 0 0 1 0 1 ) 
                                        #name: #textEditor 
                                        #model: #textHolder 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: 
                                                #textAccepted: ) 
                                        #menu: #menu ) ) ) )
!

windowSpecVW
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Unlabeled Canvas' 
                        #bounds: #(#Rectangle 431 495 797 720 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#TextEditorSpec 
                                        #layout: #(#LayoutFrame 0 0 0 0 0 1 0 1 ) 
                                        #name: #textEditor 
                                        #model: #textHolder 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: 
                                                #textAccepted: ) 
                                        #menu: #menu ) ) ) )
! !

!BrowserTextTool class methodsFor:'resources'!

menu
	"UIMenuEditor new openOnClass: self andSelector: #menu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: '&find...' 
				#value: #find ) 
			#(#MenuItem 
				#rawLabel: '&replace...' 
				#value: #replace ) 
			#(#MenuItem 
				#rawLabel: '&undo' 
				#value: #undo ) 
			#(#MenuItem 
				#rawLabel: '&copy' 
				#value: #copySelection ) 
			#(#MenuItem 
				#rawLabel: 'cu&t' 
				#value: #cut ) 
			#(#MenuItem 
				#rawLabel: '&paste' 
				#value: #paste ) 
			#(#MenuItem 
				#rawLabel: '&do it' 
				#value: #doIt ) 
			#(#MenuItem 
				#rawLabel: 'pri&nt it' 
				#value: #printIt ) 
			#(#MenuItem 
				#rawLabel: '&inspect it' 
				#value: #inspectIt ) 
			#(#MenuItem 
				#rawLabel: '&accept' 
				#value: 
				#accept:from: ) 
			#(#MenuItem 
				#rawLabel: 'cancel' 
				#value: #cancelText ) 
			#(#MenuItem 
				#rawLabel: '&hardcopy' 
				#value: #hardcopy ) ) #(2 1 3 3 2 1 ) nil ) decodeAsLiteralArray
! !

!BrowserTextTool methodsFor:'accepting'!

accept: aText from: aController
	^self subclassResponsibility
!

cancelText
	self text: originalText
!

textAccepted: aController 
	self isEnabled ifTrue: [self accept: aController text from: aController]
! !

!BrowserTextTool methodsFor:'accessing'!

doItReceiver
	"Answer the object that should be informed of the result of evaluating a
	text selection."

	^self nonMetaClass
!

insertError: aString at: position 
	self textController insertAndSelect: aString , ' ->' at: position
!

saveState
	| controller |
	controller := self textController.
	controller isNil ifTrue: [^self].
	(changed := controller textHasChanged) ifTrue: [savedText := controller text]
!

text
	| controller |
	controller := self textController.
	^controller notNil
		ifTrue: [controller text]
		ifFalse: ['']
!

text: aString 
        |editor|

        RBParser isSmalltalkX ifTrue:[
            "/ VW textviews always update the models value
            "/ when modified; ST/X's only does it when accepting.
            "/ so, under ST/X the models value is still the original
            "/ and a change does no update here ...
            (builder notNil
            and:[(editor := self builder componentAt:#textEditor) notNil])
            ifTrue:[
                editor scrolledView notNil ifTrue:[
                    editor contents:aString
                ]
            ].
            self textHolder setValue:aString.
            editor notNil ifTrue:[
                editor modified:false.
            ]
        ] ifFalse:[
            self textHolder value: aString.
        ].
        originalText := aString.
        changed := false

    "Modified: / 6.2.2000 / 17:37:37 / cg"
!

textNoChange: aString
        |textController|

        textController := self textController.

        RBParser isSmalltalkX ifTrue:[
            |prevModified|

            prevModified := textController modified.
            textController contents:aString.
            textController modified:prevModified 
.        ] ifFalse:[
            textController selectFrom: 1 to: textController text size;
                    deselect;
                    replaceSelectionWith: aString asText;
                    selectAt: 1
        ]

    "Modified: / 6.2.2000 / 14:49:13 / cg"
! !

!BrowserTextTool methodsFor:'aspects'!

textHolder
	^textHolder isNil ifTrue: [textHolder := '' asValue] ifFalse: [textHolder]
! !

!BrowserTextTool methodsFor:'initialization & release'!

initialize
	super initialize.
	self text: ''.
	menu := self initializeMenu: self class menu.
! !

!BrowserTextTool methodsFor:'instance variables'!

browseInstVarReaders
	| name |
	name := self selectedVariableName.
	name notNil 
		ifTrue: [self navigator browseGlobalInstVarReadersTo: name in: self selectedClass]
!

browseInstVarRefs
	| name |
	name := self selectedVariableName.
	name notNil 
		ifTrue: [self navigator browseGlobalInstVarRefsTo: name in: self selectedClass]
!

browseInstVarWriters
	| name |
	name := self selectedVariableName.
	name notNil 
		ifTrue: [self navigator browseGlobalInstVarWritersTo: name in: self selectedClass]
!

selectedVariableName
	"Guess the variable name from the selection"

	^self selectedText
! !

!BrowserTextTool methodsFor:'interface opening'!

postBuildWith: aBuilder 
	super postBuildWith: aBuilder.
	(self textController) autoAccept: false;
		continuousAccept: false
! !

!BrowserTextTool methodsFor:'menu'!

enableMenu
	| collection interval |
	interval := self selectedInterval.
	collection := OrderedCollection new.
	interval isEmpty ifTrue: [collection addAll: self noSelectionItems].
	self isEditing
		ifTrue: [self isEnabled ifFalse: [collection add: 'accept']]
		ifFalse: [collection addAll: self noEditItems].
	collection addAll: self otherMenuItems.
	self enableMenu: menu except: collection
!

initializeMenu: aMenu 
        "Hack aMenu so that it can be installed into window, and still send us the messages instead of 
        sending them to the window's model."

        aMenu values: (aMenu values collect: [:each | (#(#find #replace #undo #copySelection #cut #paste #doIt #printIt #inspectIt #hardcopy) includes: each)
                                ifTrue: [[self textController perform: each]]
                                ifFalse: [each isSymbol
                                                ifTrue: [each numArgs == 1
                                                                ifTrue: [[self perform: each with: self textController]]
                                                                ifFalse: [each numArgs == 2
                                                                                ifTrue: [[self
                                                                                                perform: each
                                                                                                with: self textController text
                                                                                                with: self textController]]
                                                                                ifFalse: [[self perform: each]]]]
                                                ifFalse: [each]]]).
        aMenu menuItems do: [:each | each submenu notNil ifTrue: [each submenu: (self initializeMenu: each submenu)]].
        ^aMenu
!

menu
	^
	[self enableMenu.
	menu]
!

noEditItems
	^#('accept' 'cancel')
!

noSelectionItems
	^#('do it' 'print it' 'inspect it')
!

otherMenuItems
	^#()
! !

!BrowserTextTool methodsFor:'private'!

selectedInterval
	| controller |
	controller := self textController.
	controller isNil ifTrue: [^1 to: 0].
	^controller selectionStartIndex to: controller selectionStopIndex - 1
!

selectedText
	| interval |
	interval := self selectedInterval.
	interval isEmpty ifTrue: [^''].
	^self textController text asString copyFrom: interval first to: interval last
!

textController
	^self controllerFor: #textEditor
! !

!BrowserTextTool methodsFor:'refactoring'!

abstractClassVar: aString 
	self performRefactoring: (AbstractClassVariableRefactoring 
				variable: aString asSymbol
				class: (self nonMetaClass whichClassDefinesClassVar: aString))
!

abstractInstVar: aString 
	self 
		performRefactoring: (AbstractInstanceVariableRefactoring variable: aString
				class: (self selectedClass whichClassDefinesInstVar: aString))
!

createAccessorsForClassVar: aString 
	self performRefactoring: (CreateAccessorsForVariableRefactoring 
				variable: aString asSymbol
				class: (self nonMetaClass whichClassDefinesClassVar: aString)
				classVariable: true)
!

createAccessorsForInstVar: aString 
	self performRefactoring: (CreateAccessorsForVariableRefactoring 
				variable: aString
				class: (self selectedClass whichClassDefinesInstVar: aString)
				classVariable: false)
!

performRefactoring: aRefactoring 
	aRefactoring isNil ifTrue: [^self].
	self handleError: 
			[aRefactoring execute.
			codeModel navigate.
			self updateContents]
!

protectInstVar: aString 
	self 
		performRefactoring: (ProtectInstanceVariableRefactoring variable: aString
				class: (self selectedClass whichClassDefinesInstVar: aString))
!

pushUpClassVar: aString 
	self performRefactoring: (PullUpClassVariableRefactoring 
				variable: aString asSymbol
				class: (self nonMetaClass whichClassDefinesClassVar: aString) superclass)
!

pushUpInstVar: aString 
	self 
		performRefactoring: (PullUpInstanceVariableRefactoring variable: aString
				class: (self selectedClass whichClassDefinesInstVar: aString) superclass)
!

renameClassVar: aString 
	self navigator renameClassVar: aString asSymbol
		in: (self nonMetaClass whichClassDefinesClassVar: aString).
	self updateContents
!

renameInstVar: aString 
	self navigator renameInstVar: aString
		in: (self selectedClass whichClassDefinesInstVar: aString).
	self updateContents
! !

!BrowserTextTool methodsFor:'testing'!

isEditing
	"The '== true' below is for people filing in the source with open browsers"

	| controller |
	(super isEditing or: [changed == true])
		ifTrue: [^true].
	controller := self textController.
	^controller notNil and: [controller textHasChanged]
!

isEnabled
	^true
! !

!BrowserTextTool methodsFor:'updating'!

updateDisplay
	| controller |
	super updateDisplay.
	savedText notNil
		ifTrue: 
			[controller := self textController.
			controller view editText: savedText.
			controller textHasChanged: true.
			savedText := nil].
	changed := false
!

updateRequest
	^super updateRequest and: 
			[self isEditing not or: 
					[Dialog
						confirm: 'The text showing has been altered.\Do you wish to discard those changes?'
								withCRs]]
! !

!BrowserTextTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/BrowserTextTool.st,v 1.14 2003-09-23 10:46:04 cg Exp $'
! !
