"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserTextTool subclass:#BrowserCodeTool
	instanceVariableNames:'modified messageMenu temporaryMenu noMenu instanceVariableMenu
		classVariableMenu valueNodeMenu assignmentMenu globalVariableMenu'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Code Tools'
!

BrowserCodeTool comment:'BrowserCodeTool is the CodeTool that modifies methods.

Instance Variables:
	modified        <Boolean>       has the been changed since we initially displayed it?'
!


!BrowserCodeTool class methodsFor:'parcel load/unload/save'!

preUnloadActionFor: aParcel 
	BrowserCodeTool allInstances do: [:each | ChangeSet removeDependent: each]
! !

!BrowserCodeTool class methodsFor:'resources'!

assignmentMenu
	"UIMenuEditor new openOnClass: self andSelector: #assignmentMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 'inline temporary' 
				#value: #inlineTemporary ) ) #(1 ) nil ) decodeAsLiteralArray
!

classVariableMenu
	"UIMenuEditor new openOnClass: self andSelector: #classVariableMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 're&ferences...' 
				#value: #browseClassVarRefs ) 
			#(#MenuItem 
				#rawLabel: 're&name class variable...' 
				#value: #renameClassVar ) 
			#(#MenuItem 
				#rawLabel: 'push &up' 
				#value: #pushUpClassVar ) 
			#(#MenuItem 
				#rawLabel: 'create accessors' 
				#value: #createClassVarAccessors ) 
			#(#MenuItem 
				#rawLabel: 'abstract' 
				#value: #abstractClassVar ) ) #(1 1 1 2 ) nil ) decodeAsLiteralArray
!

globalVariableMenu
	"MenuEditor new openOnClass: self andSelector: #globalVariableMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 'navigate to' 
				#value: #navigateToClass ) 
			#(#MenuItem 
				#rawLabel: 'open browser on...' 
				#value: #openBrowserForClass ) 
			#(#MenuItem 
				#rawLabel: 'browse references...' 
				#value: #browseReferencesToGlobal ) ) #(2 1 ) nil ) decodeAsLiteralArray
!

instanceVariableMenu
	"MenuEditor new openOnClass: self andSelector: #instanceVariableMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 're&ferences...' 
				#value: #browseInstVarRefs ) 
			#(#MenuItem 
				#rawLabel: '&readers...' 
				#value: #browseInstVarReaders ) 
			#(#MenuItem 
				#rawLabel: '&writers...' 
				#value: #browseInstVarWriters ) 
			#(#MenuItem 
				#rawLabel: 're&name instance variable...' 
				#value: #renameInstVar ) 
			#(#MenuItem 
				#rawLabel: 'push &up' 
				#value: #pushUpInstVar ) 
			#(#MenuItem 
				#rawLabel: 'create accessors' 
				#value: #createInstVarAccessors ) 
			#(#MenuItem 
				#rawLabel: 'abstract' 
				#value: #abstractInstVar ) 
			#(#MenuItem 
				#rawLabel: 'protect/concrete' 
				#value: #protectInstVar ) ) #(3 1 1 3 ) nil ) decodeAsLiteralArray
!

menu
	"MenuEditor new openOnClass: self andSelector: #menu"

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
				#rawLabel: 'f&ormat' 
				#value: #format ) 
			#(#MenuItem 
				#rawLabel: 'e&xplain' 
				#value: 
				#explain:from: ) 
			#(#MenuItem 
				#rawLabel: '&extract method...' 
				#value: #extractMethod ) 
			#(#MenuItem 
				#rawLabel: 'extract to component...' 
				#value: #extractToComponent ) ) #(2 1 3 3 2 2 2 ) nil ) decodeAsLiteralArray
!

messageMenu
	"UIMenuEditor new openOnClass: self andSelector: #messageMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: '&senders...' 
				#value: #browseSenders ) 
			#(#MenuItem 
				#rawLabel: 'implementors...' 
				#value: #browseImplementors ) 
			#(#MenuItem 
				#rawLabel: 'inline message' 
				#value: #inlineMethod ) 
			#(#MenuItem 
				#rawLabel: '&extract to temporary...' 
				#value: #extractToTemp ) ) #(2 2 ) nil ) decodeAsLiteralArray
!

noMenu
	"MenuEditor new openOnClass: self andSelector: #noMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: '-empty-' 
				#enabled: false 
				#value: #yourself ) ) #(1 ) nil ) decodeAsLiteralArray
!

temporaryMenu
	"MenuEditor new openOnClass: self andSelector: #temporaryMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 'con&vert to instance variable' 
				#value: #createInstVar ) 
			#(#MenuItem 
				#rawLabel: '&remove parameter' 
				#value: #removeParameter ) 
			#(#MenuItem 
				#rawLabel: '&inline parameter' 
				#value: #inlineParameter ) 
			#(#MenuItem 
				#rawLabel: 're&name...' 
				#value: #renameTemporary ) 
			#(#MenuItem 
				#rawLabel: 'move to inner &scope' 
				#value: #bindTight ) ) #(5 ) nil ) decodeAsLiteralArray
!

valueNodeMenu
	"UIMenuEditor new openOnClass: self andSelector: #valueNodeMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: '&extract to temporary...' 
				#value: #extractToTemp ) ) #(1 ) nil ) decodeAsLiteralArray
! !

!BrowserCodeTool methodsFor:'accepting'!

accept: aText from: aController 
        self overwriteExistingMethod ifFalse: [^self].
        modified := nil.
        
        [| selector |
        selector := self selectedClass 
                                compile: aText
                                classified: self protocol
                                notifying: aController.
        RBParser isSmalltalkX ifTrue:[
            "/ st/x returns the method; VW returns the selector
            selector := selector who methodSelector
        ].
        selector notNil ifTrue: [codeModel setSelector: selector]] 
                        ensure: [modified := false]
!

explain: fullText from: aController 
        "Try to shed some light on what kind of entity the controller's
        current selection is.
        The selection must be a single token or construct.  Have the controller
        insert the answer after its selection."

        | reply targetClass |
        targetClass := self selectedClass.
        Smalltalk isSmalltalkX ifTrue:[
            reply := Explainer explain:aController selectionAsString in:self textController text forClass:targetClass.
            aController insertAndSelect: ' ' , reply at: aController selectionStopIndex
        ] ifFalse:[
            reply := (Explainer new class: targetClass
                                    selector: self selector
                                    instance: self nonMetaClass
                                    context: nil
                                    methodText: self textController text) explain: aController selection string
                                            for: self.
            aController insertAndSelect: ' ' , reply at: aController selectionStopIndex
        ].
!

explainSpecial: string
	^nil
!

format
        | selectedClass newText |
        selectedClass := self selectedClass.
        newText := (RBParser parseMethod: self textController text
                                onError: [:aString :position | ^self insertError: aString at: position]) 
                                        printString asText 
                                makeSelectorBoldIn: self selectedClass.
        newText isNil ifTrue: [^self].
        RBParser isSmalltalkX ifTrue:[
            UserPreferences current syntaxColoring ifTrue:[
                |highlighter|

                highlighter := selectedClass syntaxHighlighterClass.
                highlighter notNil ifTrue:[
                    newText := highlighter formatMethod:newText in:selectedClass.
                ]
            ].
        ] ifFalse:[
            newText := newText asText makeSelectorBoldIn: selectedClass.
        ].
        self textNoChange: newText

    "Modified: / 6.2.2000 / 14:47:50 / cg"
! !

!BrowserCodeTool methodsFor:'class variables'!

abstractClassVar
	| name |
	name := self selectedVariableName.
	name isNil ifTrue: [^self].
	self abstractClassVar: name
!

browseClassVarRefs
	| name association |
	name := self selectedVariableName.
	association := self navigator findAssociationForClassVariable: name.
	self navigator browseGlobalReferencesTo: association in: self nonMetaClass
!

createClassVarAccessors
	| name |
	name := self selectedVariableName.
	name isNil ifTrue: [^self].
	self createAccessorsForClassVar: name
!

pushUpClassVar
	| name |
	name := self selectedVariableName.
	name isNil ifTrue: [^self].
	self pushUpClassVar: name
!

renameClassVar
	| name |
	name := self selectedVariableName.
	name isNil ifTrue: [^self].
	self renameClassVar: name
! !

!BrowserCodeTool methodsFor:'global variables'!

browseReferencesToGlobal
	| name association |
	name := self selectedVariableName.
	name isNil ifTrue: [^self].
	association := Smalltalk associationAt: name asSymbol ifAbsent: [^self].
	self navigator browseGlobalReferencesTo: association
!

navigateToClass
	| name class |
	name := self selectedVariableName.
	name isNil ifTrue: [^self].
	class := Smalltalk at: name asSymbol ifAbsent: [^self].
	codeModel
		setSelector: nil;
		setClass: class
!

openBrowserForClass
	| name class |
	name := self selectedVariableName.
	name isNil ifTrue: [^self].
	class := Smalltalk at: name asSymbol ifAbsent: [^self].
	(RefactoringBrowser open navigator)
		selectClass: class;
		changed
! !

!BrowserCodeTool methodsFor:'initialize-release'!

initialize
	super initialize.
	ChangeSet addDependent: self.
	modified := false.
	self initializeMenus
!

initializeMenus
	| menuItem |
	temporaryMenu := self initializeMenu: self class temporaryMenu.
	instanceVariableMenu := self 
				initializeMenu: self class instanceVariableMenu.
	classVariableMenu := self initializeMenu: self class classVariableMenu.
	messageMenu := self initializeMenu: self class messageMenu.
	noMenu := self initializeMenu: self class noMenu.
	valueNodeMenu := self initializeMenu: self class valueNodeMenu.
	assignmentMenu := self initializeMenu: self class assignmentMenu.
	globalVariableMenu := self initializeMenu: self class globalVariableMenu.
	menuItem := MenuItem labeled: '&selection'.
	menuItem submenu: [self selectMenu].
	menu addItem: menuItem
!

release
	ChangeSet removeDependent: self.
	super release
! !

!BrowserCodeTool methodsFor:'instance variables'!

abstractInstVar
	| name |
	name := self selectedVariableName.
	name isNil ifTrue: [^self].
	self abstractInstVar: name
!

createInstVarAccessors
	| name |
	name := self selectedVariableName.
	name isNil ifTrue: [^self].
	self createAccessorsForInstVar: name
!

protectInstVar
	| name |
	name := self selectedVariableName.
	name isNil ifTrue: [^self].
	self protectInstVar: name
!

pushUpInstVar
	| name |
	name := self selectedVariableName.
	name isNil ifTrue: [^self].
	self pushUpInstVar: name
!

renameInstVar
	| name |
	name := self selectedVariableName.
	name isNil ifTrue: [^self].
	self renameInstVar: name
!

selectedVariableName
	| node |
	node := self findNode.
	^(node notNil and: [node isVariable]) ifTrue: [node name] ifFalse: [nil]
! !

!BrowserCodeTool methodsFor:'interface opening'!

postBuildWith: aBuilder 
	super postBuildWith: aBuilder.
	self updateTextWidget
! !

!BrowserCodeTool methodsFor:'menu'!

assignmentMenuFor: aParseTree 
	(self isEditing not 
		and: [(aParseTree whoDefines: aParseTree variable name) notNil]) 
			ifTrue: [self enableMenu: assignmentMenu]
			ifFalse: [self disableMenu: assignmentMenu].
	^assignmentMenu
!

classVariableMenu
	self isEditing 
		ifTrue: 
			[self enableMenu: classVariableMenu except: #('rename class variable...')]
		ifFalse: [self enableMenu: classVariableMenu].
	^classVariableMenu
!

globalVariableMenuFor: anAssociation 
	anAssociation value isBehavior 
		ifTrue: [self enableMenu: globalVariableMenu]
		ifFalse: 
			[self disableMenu: globalVariableMenu except: #('browse references...')].
	^globalVariableMenu
!

instanceVariableMenu
	self isEditing 
		ifTrue: 
			[self enableMenu: instanceVariableMenu
				except: #('rename instance variable...')]
		ifFalse: [self enableMenu: instanceVariableMenu].
	^instanceVariableMenu
!

messageMenuFor: aNode 
	| disabled |
	disabled := OrderedCollection new.
	self isEditing 
		ifTrue: [disabled addAll: #('extract to temporary...' 'inline message')].
	aNode isUsed ifFalse: [disabled add: 'extract to temporary...'].
	self enableMenu: messageMenu except: disabled.
	^messageMenu
!

noMenu
	self disableMenu: noMenu.
	^noMenu
!

noSelectionItems
	^#('extract method...' 'explain' 'do it' 'print it' 'inspect it')
!

otherMenuItems
	^self isEditing | self selector isNil 
		ifTrue: [#('extract method...')]
		ifFalse: [#()]
!

selectMenu
	| node |
	node := self findNode.
	node isNil ifTrue: [^self noMenu].
	node isVariable ifTrue: [^self selectVariableMenuFor: node].
	node isMessage ifTrue: [^self messageMenuFor: node].
	node isAssignment ifTrue: [^self assignmentMenuFor: node].
	node isValue ifTrue: [^self valueNodeMenuFor: node].
	^self noMenu
!

selectVariableMenuFor:aNode
    |nodeName|

    nodeName := aNode name.
    (aNode whoDefines:nodeName) notNil ifTrue:[
        ^ self temporaryMenuFor:aNode
    ].
    (self selectedClass allInstVarNames includes:nodeName) ifTrue:[
        ^ self instanceVariableMenu
    ].
    (self nonMetaClass allClassVarNames 
        contains:[:each | each asString = nodeName ]) 
            ifTrue:[ ^ self classVariableMenu ].

    ^ (Smalltalk includesKey:nodeName asSymbol) 
        ifTrue:[ self globalVariableMenuFor:(Smalltalk associationAt:nodeName asSymbol) ]
        ifFalse:[ self noMenu ]
!

temporaryMenuFor: aNode 
	self isEditing 
		ifTrue: [self disableMenu: temporaryMenu]
		ifFalse: 
			[aNode parent isNil 
				ifTrue: [self enableMenu: temporaryMenu]
				ifFalse: 
					[aNode parent isMethod 
						ifTrue: 
							[self enableMenu: temporaryMenu
								except: #('convert to instance variable' 'move to inner scope')]
						ifFalse: [self enableMenu: temporaryMenu except: #('remove parameter' 'inline parameter')]]].
	^temporaryMenu
!

valueNodeMenuFor: aParseTree 
	(self isEditing not and: [aParseTree isUsed]) 
		ifTrue: [self enableMenu: valueNodeMenu]
		ifFalse: [self disableMenu: valueNodeMenu].
	^valueNodeMenu
! !

!BrowserCodeTool methodsFor:'messages'!

browseImplementors
	| node |
	node := self findNode.
	(node isNil or: [node isMessage not]) ifTrue: [^self].
	(BrowserEnvironment new implementorsOf: node selector) openEditor
!

browseSenders
        | node |
        node := self findNode.
        (node isNil or: [node isMessage not]) ifTrue: [^self].
        self showWaitCursorWhile:[
            (BrowserEnvironment new referencesTo: node selector) openEditor
        ]

    "Modified: / 6.2.2000 / 14:42:40 / cg"
!

inlineMethod
	| node |
	node := self findNode.
	(node isNil or: [node isMessage not]) 
		ifTrue: [^self warn: 'Could not find message send'].
	(node receiver isVariable 
		and: [#('self' 'super') includes: node receiver name]) 
			ifTrue: 
				[self performRefactoring: (InlineMethodRefactoring 
							inline: (self convertToSourceInterval: node sourceInterval)
							inMethod: self selector
							forClass: self selectedClass)]
			ifFalse: 
				[self performRefactoring: (InlineMethodFromComponentRefactoring 
							inline: (self convertToSourceInterval: node sourceInterval)
							inMethod: self selector
							forClass: self selectedClass)]
! !

!BrowserCodeTool methodsFor:'private'!

convertToSourceInterval: anInterval 
	"Convert the selected interval from our text widget, to the interval in the stored source code.
	For this widget, we don't need to do anything."

	^anInterval
!

findNode
	| tree node interval |
	interval := self selectedInterval.
	interval isEmpty ifTrue: [^nil].
	tree := RBParser parseMethod: self text
				onError: [:str :err | ^self parseSelection].
	node := tree whichNodeIsContainedBy: interval.
	node isNil ifTrue: [node := tree bestNodeFor: interval].
	^node
!

findNodeIn: tree forInterval: interval 
	| node |
	node := nil.
	tree nodesDo: 
			[:each | 
			(each intersectsInterval: interval) 
				ifTrue: 
					[(node isNil or: [node == each parent]) 
						ifTrue: [node := each]
						ifFalse: 
							[(node parent notNil 
								and: [node parent isCascade and: [each parent isCascade]]) ifFalse: [^nil]]]].
	^node
!

modifiedTextColor
	^ColorValue red
!

parseSelection
        ^RBParser parseExpression: self selectedText onError: [:str :pos | ^nil]
!

updateSelection
        | controller view searchStrings interval |
        controller := self textController.
        controller isNil ifTrue: [^self].
        view := controller view.
        interval := self environment selectionIntervalFor: self text.
        interval size > 0 
                ifTrue: [controller selectFrom: interval first to: interval last]
                ifFalse: 
                        [searchStrings := self environment searchStrings.
                        searchStrings isEmpty ifTrue: [^self].
                        view deselect.
                        (searchStrings contains: 
                                        [:each | 
                                        | searchString |
                                        searchString := each isSymbol ifTrue: [each keywords first] ifFalse: [each].
                                        controller find: searchString]) 
                                ifFalse: [^self]].
        view displaySelection: true.
        view selectAndScroll
!

updateTextWidget
        | widget prefs |
        builder isNil ifTrue: [^self].
        widget := builder componentAt: #textEditor.
        widget isNil ifTrue: [^self].
        Smalltalk isSmalltalkX ifTrue:[
            modified 
                = (widget foregroundColor = self modifiedTextColor) 
                        ifTrue: [^self].
            modified 
                                    ifTrue: [widget foregroundColor: self modifiedTextColor].
        ] ifFalse:[
            modified 
                = (widget lookPreferences foregroundColor = self modifiedTextColor) 
                        ifTrue: [^self].
            prefs := modified 
                                    ifTrue: [widget lookPreferences foregroundColor: self modifiedTextColor]
                                    ifFalse: [nil].
            widget lookPreferences: prefs

        ].
! !

!BrowserCodeTool methodsFor:'refactorings'!

extractMethod
	self updateRequest ifFalse: [^self].
	self performRefactoring: (ExtractMethodRefactoring 
				extract: (self convertToSourceInterval: self selectedInterval)
				from: self selector
				in: self selectedClass)
!

extractToComponent
	self updateRequest ifFalse: [^self].
	self performRefactoring: (ExtractMethodToComponentRefactoring 
				extract: (self convertToSourceInterval: self selectedInterval)
				from: self selector
				in: self selectedClass)
!

extractToTemp
	| newName node |
	self updateRequest ifFalse: [^self].
	node := self findNode.
	(node isNil or: [node isValue not]) 
		ifTrue: [^self warn: 'Could not find the node'].
	newName := self request: 'Enter name forTemporary:'.
	newName isEmpty ifTrue: [^self].
	self performRefactoring: (ExtractToTemporaryRefactoring 
				extract: (self convertToSourceInterval: node sourceInterval)
				to: newName
				from: self selector
				in: self selectedClass)
!

inlineTemporary
	| node |
	self updateRequest ifFalse: [^self].
	node := self findNode.
	(node isNil or: [node isAssignment not]) 
		ifTrue: [^self warn: 'Could not find the node'].
	self performRefactoring: (InlineTemporaryRefactoring 
				inline: (self convertToSourceInterval: node sourceInterval)
				from: self selector
				in: self selectedClass)
!

rewriteCode
	RewriteRuleEditor rewrite: self selectedText
! !

!BrowserCodeTool methodsFor:'temporary variables'!

bindTight
	self performRefactoring: (MoveVariableDefinitionRefactoring 
				bindTight: (self convertToSourceInterval: self selectedInterval)
				in: self selectedClass
				selector: self selector)
!

createInstVar
        self performRefactoring: (TemporaryToInstanceVariableRefactoring 
                                class: self selectedClass
                                selector: self selector
                                variable: self selectedText)
!

inlineParameter
	self handleError: 
			[| ref |
			ref := InlineParameterRefactoring 
						inlineParameter: self selectedText
						in: self selectedClass
						selector: self selector.
			ref execute.
			codeModel setSelector: ref newSelector]
!

removeParameter
	self handleError: 
			[| ref |
			ref := RemoveParameterRefactoring 
						removeParameter: self selectedText
						in: self selectedClass
						selector: self selector.
			ref execute.
			codeModel setSelector: ref newSelector]
!

renameTemporary
        | newName node refactoring |
        node := self findNode.
        (node isNil or: [node isVariable not]) 
                ifTrue: [^self warn: 'Could not find the node'].
        newName := self request: 'Enter new name:' initialAnswer: node name.
        newName isEmpty ifTrue: [^self].
        refactoring := (RenameTemporaryRefactoring 
                                renameTemporaryFrom: (self convertToSourceInterval: node sourceInterval)
                                to: newName
                                in: self selectedClass
                                selector: self selector).
        RBParser isSmalltalkX ifTrue:[
            "cg: must use the actual source - not the one in the method.
             to allow for refactoring to be made on the current source"
            refactoring source:self textController text asString string.
        ].
        self performRefactoring: refactoring

    "Modified: / 7.2.2000 / 12:33:28 / cg"
! !

!BrowserCodeTool methodsFor:'testing'!

overwriteExistingMethod
        | newSelector |
        newSelector := RBParser parseMethodPattern: self text.
        (newSelector notNil and: 
                        [newSelector ~= self selector 
                                and: [self selectedClass includesSelector: newSelector]]) 
                ifTrue: 
                        [(self confirm: ('<1s> is already defined in <2p>.<n>Overwrite?' 
                                                expandMacrosWith: newSelector
                                                with: self selectedClass)) 
                                ifFalse: [^false]].
        ^true
! !

!BrowserCodeTool methodsFor:'updating'!

update: anAspectSymbol with: aParameter from: aSender 
	(#(#removeSelector:class: #changeSelector:class: #addSelector:class:) includes: anAspectSymbol)
		ifTrue: 
			[modified isNil ifTrue: [^self]. "We're making the modification so don't update the display"
			(aParameter first = self selector and: [aParameter last = self selectedClass])
				ifTrue: 
					[modified := true.
					self updateTextWidget]]
		ifFalse: [super
				update: anAspectSymbol
				with: aParameter
				from: aSender]
!

updateContents
        | compiledMethod source |
        modified := false.
        self updateTextWidget.
        self selectedClass isNil ifTrue: [^self text: ''].
        self selector isNil ifTrue: [^self text: self selectedClass sourceCodeTemplate asText].
        compiledMethod := self selectedClass compiledMethodAt: self selector
                                ifAbsent: 
                                        [Dialog warn: 'Method has been removed'.
                                        ^self text: ''].

        RBParser isSmalltalkX ifTrue:[
            "/ can take some time, if fetching source from the repository;
            "/ therefore, show a wait cursor.
            self topApplication withCursor:Cursor read do:[
                source := self selectedClass sourceCodeForMethod: compiledMethod at: self selector.
                "/ also, add syntaxColoring, if enabled.
                UserPreferences current syntaxColoring ifTrue:[
                    |highlighter|

                    highlighter := self selectedClass syntaxHighlighterClass.
                    highlighter notNil ifTrue:[
                        self topApplication withCursor:Cursor execute do:[
                            source := highlighter formatMethod:source in:self selectedClass.
                        ]
                    ]
                ].
            ]
        ] ifFalse:[
            source := self selectedClass sourceCodeForMethod: compiledMethod at: self selector.
            source := source asText makeSelectorBoldIn: self selectedClass.
        ].
        self text:source.
        self updateSelection

    "Modified: / 5.2.2000 / 17:03:25 / cg"
! !

!BrowserCodeTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/BrowserCodeTool.st,v 1.19 2013-06-08 16:51:22 cg Exp $'
! !

