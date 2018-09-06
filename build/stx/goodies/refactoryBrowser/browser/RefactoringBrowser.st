"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserApplicationModel subclass:#RefactoringBrowser
	instanceVariableNames:'navigator tools environment currentBuffer policyClass horizontal'
	classVariableNames:'PatchLevel Version'
	poolDictionaries:''
	category:'Refactory-Browser'
!

RefactoringBrowser class instanceVariableNames:'horizontal multiWindow'

"
 The following class instance variables are inherited by this class:

	BrowserApplicationModel - 
	ApplicationModel - ClassResources
	Model - 
	Object - 
"
!

RefactoringBrowser comment:'RefactoringBrowser is the glue for the browser application. It''s main responsibility is maintaining the buffers for the different code tools.

Instance Variables:

	navigator       <Navigator>     the navigator that displays the environment
	tools   <SequenceableCollection of: CodeModel>  the buffers for all the different code tools
	environment     <BrowserEnvironment>    contains the items that we are browsing
	currentBuffer   <ValueHolder on: CodeModel>     the current buffer that is being displayed by the browser. For multi-window applications, this value is not-updated.
	policyClass     <CodeModelLockPolicy class>     the class of the lock policy for this browser (state or window)
	horizontal      <Boolean>       are we displaying a horizontal navigator'
!


!RefactoringBrowser class methodsFor:'instance creation'!

onEnvironment: anEnvironment 
	| browser |
	browser := self new.
	browser initializeOnEnvironment: anEnvironment.
	horizontal
		ifTrue: [browser beHorizontal]
		ifFalse: [browser beVertical].
	browser policyClass: StateLockPolicy.
	^browser
! !

!RefactoringBrowser class methodsFor:'accessing'!

beHorizontal
	"self beHorizontal"

	horizontal := true
!

beMultiWindow
	multiWindow := true
!

beSingleWindow
	multiWindow := false
!

beVertical
	"self beVertical"

	horizontal := false
!

browserType
	horizontal isNil ifTrue: [self beHorizontal].
	^horizontal
		ifTrue: [self isMultiWindow
				ifTrue: [#horizontalNavigator]
				ifFalse: [#windowSpec]]
		ifFalse: [self isMultiWindow
				ifTrue: [#verticalNavigator]
				ifFalse: [#verticalWindowSpec]]
!

isMultiWindow
	multiWindow isNil ifTrue: [multiWindow := false].
	^multiWindow
!

parcelVersion
	^(Parcel parcelNamed: 'RefactoringBrowser') version
!

patchLevel
	^PatchLevel
!

patchLevel: anObject
	PatchLevel := anObject
!

version: anObject
	Version := anObject
! !

!RefactoringBrowser class methodsFor:'class initialization'!

initialize
	horizontal := true.
	multiWindow := false.
	self version: 2.0.
	self patchLevel: 0
! !

!RefactoringBrowser class methodsFor:'compatibility messages'!

newOnClass: aClass 
	"Set the default VW class browser to be a Refactoring Browser."

	"#(browserType classBrowserType methodListBrowserType) do: [:each | UISettings preferenceFor: each put: #RefactoringBrowser]"

	(RefactoringBrowser open navigator)
		selectClass: aClass;
		changed;
		beHierarchy
!

openListBrowserOn: referenceCollection label: aString initialSelection: selection 
	| environment |
	environment := SelectorEnvironment new.
	environment label: aString.
	selection notNil ifTrue: [environment addSearchString: selection].
	referenceCollection 
		do: [:each | environment addClass: each implementingClass selector: each selector].
	^self openOnEnvironment: environment
!

openListBrowserOn: methodCollection label: aString initialSelection: selection spawnedFrom: aBrowserOrNil 
	^self 
		openListBrowserOn: methodCollection
		label: aString
		initialSelection: selection
! !

!RefactoringBrowser class methodsFor:'interface opening'!

open
	^self openOnEnvironment: BrowserEnvironment new
!

openHorizontal
	^self openOnEnvironment: BrowserEnvironment new spec: #windowSpec
!

openMultiOnEnvironment: anEnvironment spec: aSpec
	| browser |
	anEnvironment isEmpty ifTrue: [^Dialog warn: 'Nobody'].
	browser := self new.
	browser initializeOnEnvironment: anEnvironment.
	aSpec == #horizontalNavigator
		ifTrue: [browser beHorizontal]
		ifFalse: [browser beVertical].
	browser policyClass: WindowLockPolicy.
	browser openInterface: aSpec.
	browser newWindow.
	^browser
!

openMultiWindowHorizontal
	^self openMultiOnEnvironment: BrowserEnvironment new spec: #horizontalNavigator
!

openMultiWindowVertical
	^self openMultiOnEnvironment: BrowserEnvironment new spec: #verticalNavigator
!

openOnEnvironment: anEnvironment
	^self isMultiWindow
		ifTrue: [self openMultiOnEnvironment: anEnvironment spec: self browserType]
		ifFalse: [self openOnEnvironment: anEnvironment spec: self browserType]
!

openOnEnvironment: anEnvironment spec: aSpec 
	| browser |
	anEnvironment isEmpty ifTrue: [^Dialog warn: 'Nobody'].
	browser := self onEnvironment: anEnvironment.
	aSpec == #windowSpec
		ifTrue: [browser beHorizontal]
		ifFalse: [browser beVertical].
	browser openInterface: aSpec.
	browser currentBuffer value tool updateContents.
	^browser
!

openOnSelection
	| dialog |
	dialog := ClassSelectionDialog new.
	dialog open ifFalse: [^self].
	^self openOnEnvironment: dialog selectedEnvironment
!

openVertical
	^self openOnEnvironment: BrowserEnvironment new spec: #verticalWindowSpec
! !

!RefactoringBrowser class methodsFor:'interface specs'!

horizontalNavigator
	"UIPainter new openOnClass: self andSelector: #horizontalNavigator"

	<resource: #canvas>
	^#(#FullSpec
		#window:
		#(#WindowSpec
			#label: 'System Browser'
			#min: #(#Point 527 139 )
			#bounds: #(#Rectangle 205 272 828 411 )
			#flags: 4
			#menu: #navigatorMenuBar )
		#component:
		#(#SpecCollection
			#collection: #(
				#(#SubCanvasSpec
					#layout: #(#LayoutFrame 0 0 0 0 0 1 0 1 )
					#name: #navigator
					#flags: 0
					#majorKey: #NavigatorTool
					#minorKey: #windowSpec
					#clientKey: #navigator ) ) ) )
!

verticalNavigator
	"UIPainter new openOnClass: self andSelector: #verticalNavigator"

	<resource: #canvas>
	^#(#FullSpec
		#window:
		#(#WindowSpec
			#label: 'System Browser'
			#min: #(#Point 40 20 )
			#bounds: #(#Rectangle 300 224 468 676 )
			#flags: 4
			#menu: #navigatorMenuBar )
		#component:
		#(#SpecCollection
			#collection: #(
				#(#SubCanvasSpec
					#layout: #(#LayoutFrame 0 0 0 0 0 1 0 1 )
					#name: #navigator
					#flags: 0
					#majorKey: #NavigatorTool
					#minorKey: #windowSpec
					#clientKey: #navigator ) ) ) )
!

verticalWindowSpec
	"UIPainter new openOnClass: self andSelector: #verticalWindowSpec"

	<resource: #canvas>
	^#(#FullSpec
		#window:
		#(#WindowSpec
			#label: 'System Browser'
			#min: #(#Point 470 314 )
			#bounds: #(#Rectangle 165 181 798 661 )
			#flags: 4
			#menu: #menuBar )
		#component:
		#(#SpecCollection
			#collection: #(
				#(#SubCanvasSpec
					#layout: #(#LayoutFrame 0 0 0 0 0 0.25 0 1 )
					#name: #navigator
					#flags: 0
					#majorKey: #NavigatorTool
					#minorKey: #windowSpec
					#clientKey: #navigator )
				#(#SubCanvasSpec
					#layout: #(#LayoutFrame 3 0.25 2 0 -2 1 -2 1 )
					#name: #codeTool
					#flags: 0
					#majorKey: #CodeModel
					#minorKey: #windowSpec
					#clientKey: #codeTool )
				#(#DividerSpec
					#layout: #(#LayoutFrame 0 0.25 0 0 2 0.25 0 1 )
					#orientation: #vertical ) ) ) )
!

windowSpec
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        RBParser isSmalltalkX ifTrue:[
            "/ provides a variable panel
            ^ self windowSpecSTX
        ].
        ^ self windowSpecVW

    "Modified: / 3.2.2000 / 20:07:16 / cg"
!

windowSpecSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:RefactoringBrowser andSelector:#windowSpecSTX
     RefactoringBrowser new openInterface:#windowSpecSTX
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpecSTX
        #window: 
       #(#WindowSpec
          #label: 'System Browser'
          #name: 'System Browser'
          #min: #(#Point 472 312)
          #bounds: #(#Rectangle 13 23 646 503)
          #menu: #menuBar
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#VariableVerticalPanelSpec
              #name: 'VariableVerticalPanel1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #barWidth: 2
              #showHandle: false
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#SubCanvasSpec
                    #name: #navigator
                    #majorKey: #NavigatorTool
                    #minorKey: #windowSpec
                    #clientKey: #navigator
                  )
                 #(#SubCanvasSpec
                    #name: #codeTool
                    #majorKey: #CodeModel
                    #minorKey: #windowSpec
                    #clientKey: #codeTool
                  )
                 )
               
              )
              #handles: #(#Any 0.297917 1.0)
            )
           )
         
        )
      )

    "Modified: / 3.2.2000 / 20:12:30 / cg"
!

windowSpecVW
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        <resource: #canvas>
        ^#(#FullSpec
                #window:
                #(#WindowSpec
                        #label: 'System Browser'
                        #min: #(#Point 472 312 )
                        #bounds: #(#Rectangle 130 222 763 702 )
                        #flags: 4
                        #menu: #menuBar )
                #component:
                #(#SpecCollection
                        #collection: #(
                                #(#SubCanvasSpec
                                        #layout: #(#LayoutFrame 0 0 0 0 0 1 -1 0.333333 )
                                        #name: #navigator
                                        #flags: 0
                                        #majorKey: #NavigatorTool
                                        #minorKey: #windowSpec
                                        #clientKey: #navigator )
                                #(#SubCanvasSpec
                                        #layout: #(#LayoutFrame 2 0 2 0.333333 -2 1 -2 1 )
                                        #name: #codeTool
                                        #flags: 0
                                        #majorKey: #CodeModel
                                        #minorKey: #windowSpec
                                        #clientKey: #codeTool )
                                #(#DividerSpec
                                        #layout: #(#LayoutFrame 0 0 -1 0.333333 0 1 0 0.333333 ) ) ) ) )

    "Created: / 3.2.2000 / 20:06:04 / cg"
! !

!RefactoringBrowser class methodsFor:'resources'!

browseMenu
	"UIMenuEditor new openOnClass: self andSelector: #browseMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 'References to &class or global...' 
				#value: #browseGlobals ) 
			#(#MenuItem 
				#rawLabel: 'References to &symbol' 
				#value: #browseSymbols ) 
			#(#MenuItem 
				#rawLabel: 'Class defining &variable...' 
				#value: #browseVariables ) 
			#(#MenuItem 
				#rawLabel: '&Implementors matching...' 
				#value: #browseImplementors ) 
			#(#MenuItem 
				#rawLabel: 'Methods with strings &matching...' 
				#value: #browseStringMatches ) 
			#(#MenuItem 
				#rawLabel: 'Re&write' 
				#value: #openRewriter ) ) #(2 2 1 1 ) nil ) decodeAsLiteralArray
! !

!RefactoringBrowser methodsFor:'accessing'!

beHorizontal
	horizontal := true
!

beVertical
	horizontal := false
!

codeTool
	^self currentTool
!

currentTool
	^self currentBuffer value
!

environment
	^navigator environment
!

environment: anEnvironment 
	| navigatorClass |
	navigatorClass := anEnvironment navigatorClass.
	navigatorClass == navigator class 
		ifTrue: [navigator environment: anEnvironment]
		ifFalse: 
			[navigator release.
			navigator := navigatorClass forEnvironment: anEnvironment.
			tools do: [:each | each navigator: navigator]]
!

navigator
	^navigator
!

policyClass: aLockPolicyClass
	policyClass := aLockPolicyClass.
	tools do: [:each | each lockPolicyClass: policyClass]
!

preferredSpec
	^self class browserType
! !

!RefactoringBrowser methodsFor:'actions'!

findAllReferencePaths
	| block |
	block := self promptForReferencePathBlock.
	block isNil ifTrue: [^self].
	self showWaitCursorWhile: 
			[| paths |
			paths := ReferenceFinder new findAllPaths: block.
			paths isEmpty 
				ifTrue: [self warn: 'No paths found']
				ifFalse: [paths inspect]]
!

findReferencePath
	| block |
	block := self promptForReferencePathBlock.
	block isNil ifTrue: [^self].
	self showWaitCursorWhile: 
			[| path |
			path := ReferenceFinder new findPath: block.
			path notNil ifTrue: [path inspect] ifFalse: [self warn: 'No paths found']]
!

navigatorSelectBuffer
	| buffer |
	buffer := Dialog
				choose: 'Select buffer'
				fromList: tools
				values: tools
				lines: 5
				cancel: [nil].
	buffer notNil ifTrue: [buffer bringWindowToTop]
!

newBuffer
	| newBuffer |
	newBuffer := self codeModelClass navigator: navigator.
	newBuffer lockPolicyClass: policyClass.
	tools add: newBuffer.
	self bufferChangeRequest.
	currentBuffer value: newBuffer.
	self changedBuffer.
	currentBuffer value tool updateContents.
	self enable: #removeBuffer
!

newWindow
	| newBuffer |
	newBuffer := self codeModelClass navigator: navigator.
	newBuffer lockPolicyClass: policyClass.
	tools add: newBuffer.
	newBuffer open.
	newBuffer tool updateContents
!

openRewriter
	RewriteRuleEditor rewrite: ''
!

removeBuffer
	currentBuffer value updateRequest ifFalse: [^self].
	tools remove: currentBuffer value.
	currentBuffer value release.
	currentBuffer value: tools first.
	self changedBuffer.
	tools size == 1 ifTrue: [self disable: #removeBuffer]
!

selectBuffer
	| buffer |
	buffer := Dialog
				choose: 'Select buffer'
				fromList: tools
				values: tools
				lines: 5
				cancel: [nil].
	buffer isNil ifTrue: [^self].
	currentBuffer value: buffer.
	self changedBuffer
!

setUndoCount
	"Don't like the isKindOf:, but don't have a portable way to determine if something is a number."

	| undoString undoTree |
	undoString := self request: 'Enter undo stack size:'
				initialAnswer: RefactoryChangeManager undoSize printString.
	undoString isEmpty ifTrue: [^self].
	undoTree := RBParser parseExpression: undoString
				onError: [:str :pos | ^self].
	(undoTree isLiteral and: [undoTree value isKindOf: Integer]) 
		ifFalse: [^self].
	RefactoryChangeManager undoSize: undoTree value
!

spawnBrowser
	| newBrowser |
	newBrowser := self class openOnEnvironment: self environment.
	(newBrowser navigator) setState: self navigator getState; changedCategory.
	self navigator isHierarchy ifTrue: [newBrowser navigator beHierarchy]
! !

!RefactoringBrowser methodsFor:'aspects'!

currentBuffer
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^currentBuffer isNil
		ifTrue:
			[currentBuffer := nil asValue]
		ifFalse:
			[currentBuffer]
! !

!RefactoringBrowser methodsFor:'browsing'!

browseGlobals
	| searchString association |
	searchString := self request: 'Enter a class or global:'.
	(searchString isNil or: [searchString isEmpty]) ifTrue: [^self].
	searchString := searchString asSymbol.
	association := Smalltalk associationAt: searchString
				ifAbsent: [self findPoolAssociationFor: searchString].
	association isNil ifTrue: [^self].
	self navigator browseReferencesTo: association
!

browseImplementors
	| searchString |
	searchString := Dialog request: 'Enter a method name:'.
	searchString isEmpty ifTrue: [^self].
	Cursor wait showWhile: 
			[self class
				openOnEnvironment: (self environment implementorsMatching: searchString)]
!

browseStringMatches
	| searchString |
	searchString := Dialog request: 'Enter a string search for ("*browser*"):'.
	(searchString isNil or: [searchString isEmpty])
		ifTrue: [^self].
	Cursor wait showWhile: [self class openOnEnvironment: (self environment matches: searchString)]
!

browseSymbols
	| searchString |
	searchString := Dialog request: 'Enter a symbol:'.
	(searchString isNil or: [searchString isEmpty])
		ifTrue: [^self].
	self navigator browseReferencesTo: searchString asSymbol
!

browseVariables
	Cursor wait showWhile: 
			[| searchString env |
			searchString := Dialog 
						request: 'Enter variable to search for ("*browser*"):'.
			(searchString isNil or: [searchString isEmpty]) ifTrue: [^self].
			env := SelectorEnvironment onEnvironment: self environment.
			Smalltalk allBehaviorsDo: 
					[:each | 
					(each instVarNames contains: [:name | searchString match: name]) 
						ifTrue: [env addClass: each].
					(each classVarNames contains: [:name | searchString match: name]) 
						ifTrue: 
							[env
								addClass: each;
								addClass: each class]].
			self class openOnEnvironment: env]
! !

!RefactoringBrowser methodsFor:'changing'!

changeRequest
	"The receiver wants to change; check with all dependents that it is OK."

	^super changeRequest and: [navigator changeRequest]
! !

!RefactoringBrowser methodsFor:'events'!

noticeOfWindowClose: aWindow
	navigator closed.
	self release.
	^super noticeOfWindowClose: aWindow
!

requestForWindowClose
	^super requestForWindowClose and: 
			[builder isNil or: 
					[builder window isOpen not or: 
							[(tools inject: true
								into: [:bool :each | bool and: [each isLocked not or: [each isEditing not]]])
									or: [Dialog confirm: 'Modified buffered exists.\Exit anyway?' withCRs]]]]
!

windowEvent: anEvent from: aWindow 
	super windowEvent: anEvent from: aWindow.
	(#(#newGraphicsDevice #reopen) includes: anEvent key) 
		ifTrue: [self reInstallInterface]
! !

!RefactoringBrowser methodsFor:'initialize-release'!

codeModelClass
	^CodeModel
!

initializeOnEnvironment: anEnvironment 
	policyClass := StateLockPolicy.
	tools := OrderedCollection new.
	self environment: anEnvironment.
	currentBuffer := (self codeModelClass navigator: navigator) asValue.
	currentBuffer value lockPolicyClass: policyClass.
	tools add: currentBuffer value.
	horizontal := true
!

release
	navigator release.
	tools do: [:each | each release].
	super release
! !

!RefactoringBrowser methodsFor:'interface opening'!

openInterface
	self openInterface: self class browserType.
	self class isMultiWindow ifTrue: [self newWindow].
	^builder
!

postOpenWith: aBuilder 
	| envPrintString |
	envPrintString := self environment printString.
	aBuilder window 
		label: 'Browser - ' , (envPrintString copyFrom: 1
						to: (self maxLabelLength min: envPrintString size)).
	builder window application: self.
	builder window sendWindowEvents: #(#newGraphicsDevice #reopen).
	^super postOpenWith: aBuilder
!

preBuildWith: aBuilder 
	| spec |
	spec := navigator spec: self isHorizontal not.
	aBuilder 
		subCanvasAt: #NavigatorTool
		at: #windowSpec
		put: spec.
	aBuilder 
		subCanvasAt: #CodeModelSubcanvas
		at: #windowSpec
		put: (self currentTool class perform: self currentTool windowSpecMethod).
	^super preBuildWith: aBuilder
! !

!RefactoringBrowser methodsFor:'menu'!

bufferMenu
	| menu removeItem interval groupItems groupValues |
	menu := Menu new.
	menu addItemLabel: '&Create buffer' value: #newBuffer.
	removeItem := MenuItem labeled: '&Remove buffer'.
	tools size = 1 ifTrue: [removeItem disable].
	menu addItem: removeItem value: #removeBuffer.
	menu addItemGroup: (Array with: (MenuItem labeled: '&Spawn browser'))
		values: #(#spawnBrowser).
	interval := 1 to: (tools size min: 9).
	groupItems := interval collect: 
					[:i | 
					| item |
					item := MenuItem labeled: (self 
										menuNameFor: '&' , i printString , ' ' , (tools at: i) printString).
					(tools at: i) == currentBuffer value 
						ifTrue: [item beOn]
						ifFalse: [item beOff].
					item].
	groupValues := interval collect: 
					[:i | 
                                        
					[currentBuffer value: (tools at: i).
					self changedBuffer]].
	tools size > 9 
		ifTrue: 
			[groupItems := groupItems copyWith: (MenuItem labeled: '&More buffers...').
			groupValues := groupValues copyWith: #selectBuffer].
	menu addItemGroup: groupItems values: groupValues.
	^menu
!

menu
	^[self menuBar]
!

menuBar
	| menu |
	menu := Menu new.
	menu
		addItem: ((MenuItem labeled: '&Buffers') submenu: [self bufferMenu]);
		addItem: ((MenuItem labeled: 'B&rowse') submenu: [self class browseMenu]);
		addItem: ((MenuItem labeled: '&Operations') submenu: [self operationsMenu]).
	navigator windowMenuItems 
		do: [:each | menu addItem: ((MenuItem labeled: each key) submenu: each value)].
	menu addItem: ((MenuItem labeled: 'Too&l') 
				submenu: [currentBuffer value menu value]).
	^menu
!

navigatorBufferMenu
	| menu interval groupItems groupValues obsoleteTools |
	menu := Menu new.
	menu addItemLabel: '&Create window' value: #newWindow.
	obsoleteTools := tools reject: [:each | each builder notNil and: [each builder window isOpen]].
	obsoleteTools do: [:each | each release].
	tools removeAll: obsoleteTools.
	interval := 1 to: (tools size min: 9).
	groupItems := interval collect: [:i | MenuItem labeled: ('&<1p> <2p>' expandMacrosWith: i with: (tools at: i))].
	groupValues := interval collect: [:i | [(tools at: i) bringWindowToTop]].
	tools size > 9
		ifTrue: 
			[groupItems := groupItems copyWith: (MenuItem labeled: '&More buffers...').
			groupValues := groupValues copyWith: #navigatorSelectBuffer].
	menu addItemGroup: groupItems values: groupValues.
	^menu
!

navigatorMenuBar
	^(Menu new)
		addItem: ((MenuItem labeled: '&Buffers') submenu: [self navigatorBufferMenu]);
		addItem: ((MenuItem labeled: 'B&rowse') submenu: [self class browseMenu]);
		addItem: ((MenuItem labeled: '&Operations') submenu: [self operationsMenu]);
		addItem: ((MenuItem labeled: 'Ca&tegory') submenu: navigator categoryMenu);
		addItem: ((MenuItem labeled: '&Class') submenu: navigator classMenu);
		addItem: ((MenuItem labeled: '&Protocol') submenu: navigator protocolMenu);
		addItem: ((MenuItem labeled: '&Selector') submenu: navigator selectorMenu);
		yourself
!

operationsMenu
	| manager item menu undoCountMenuItem |
	manager := RefactoryChangeManager instance.
	menu := Menu new.
	item := MenuItem labeled: (manager hasUndoableOperations 
						ifTrue: ['&Undo ' , manager undoChange name]
						ifFalse: ['&Undo']).
	menu addItem: item
		value: 
			[self changeRequest 
				ifTrue: 
					[manager undoOperation.
					navigator updateCategoryList]].
	item := MenuItem labeled: (manager hasRedoableOperations 
						ifTrue: ['&Redo ' , manager redoChange name]
						ifFalse: ['&Redo']).
	menu addItem: item
		value: 
			[self changeRequest 
				ifTrue: 
					[manager redoOperation.
					navigator updateCategoryList]].
	manager hasUndoableOperations ifFalse: [(menu menuItemAt: 1) disable].
	manager hasRedoableOperations ifFalse: [(menu menuItemAt: 2) disable].
	undoCountMenuItem := (MenuItem labeled: 'Set Undo &Count')
				value: [self setUndoCount];
				yourself.
	menu addItemGroup: (Array with: undoCountMenuItem).
	^menu
! !

!RefactoringBrowser methodsFor:'private'!

bufferChangeRequest
	currentBuffer value state: navigator getState.
	^true
!

changedBuffer
	| buffer |
	buffer := currentBuffer value.
	buffer isNil ifTrue: [^self].
	tools do: [:each | each lock].
	buffer unlock.
	buffer resetBuilder.
	self installSubcanvasIn: #codeTool using: buffer.
	buffer tool updateDisplay
!

findPoolAssociationFor: aSymbol 
	| pools poolName |
	pools := OrderedCollection new.
	Smalltalk associationsDo: 
			[:assoc | 
			((assoc value isKindOf: Dictionary) 
				and: [assoc value includesKey: aSymbol]) ifTrue: [pools add: assoc key]].
	pools isEmpty 
		ifTrue: 
			[self warn: ('No variables named, <1s>, were found' expandMacrosWith: aSymbol).
			^nil].
	poolName := pools size = 1 
				ifTrue: [pools first]
				ifFalse: 
					[self 
						choose: 'The variable is defined in multiple pools.<n>Which reference do you want?' 
								expandMacros
						fromList: pools
						values: pools
						lines: 5
						cancel: [^nil]].
	^(Smalltalk at: poolName) associationAt: aSymbol
!

maxLabelLength
	^40
!

prompt: promptString initially: initialString 
	^Dialog request: ('<1s><n>the accept or CR' expandMacrosWith: promptString)
		initialAnswer: initialString
		for: self interfaceWindow
!

promptForReferencePathBlock
	| source block |
	source := self request: 'Find what?'
				initialAnswer: '[:each | each == 10000]'.
	source isEmpty ifTrue: [^nil].
	block := self class compilerClass evaluate: source.
	(block respondsTo: #value:) 
		ifFalse: 
			[self warn: 'Source did not evaluate to a block'.
			^nil].
	^block
!

reInstallInterface
"	| spec window |
	window := builder window.
	self resetBuilder.
	window component release.
	currentBuffer value on: navigator.
	builder := UIBuilder new.
	builder setWindow: window.
	builder source: self.
	spec := self class interfaceSpecFor: #windowSpec.
	self preBuildWith: builder.
	builder add: spec.
	self postBuildWith: builder.
	builder doFinalHookup.
	self postOpenWith: builder.
	^builder"
! !

!RefactoringBrowser methodsFor:'testing'!

isHorizontal
	^horizontal
! !

!RefactoringBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/RefactoringBrowser.st,v 1.10 2003-09-23 10:47:22 cg Exp $'
! !

RefactoringBrowser initialize!
