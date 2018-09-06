"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserNavigator subclass:#VariableNavigator
	instanceVariableNames:'variableClassList classVariableList selectorNavigator
		instanceVariableList instanceVariableMenuHolder
		classVariableMenuHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Navigator'
!


!VariableNavigator class methodsFor:'interface specs'!

verticalWindowSpec
	"UIPainter new openOnClass: self andSelector: #verticalWindowSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Navigator' 
			#min: #(#Point 40 20 ) 
			#bounds: #(#Rectangle 150 138 410 529 ) ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0 2 0 -2 1 -1 0.25 ) 
					#name: #variableClassList 
					#model: #variableClassList 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedVariableClass 
						#requestValueChangeSelector: #changeRequest ) 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0 1 0.25 -2 1 -1 0.375 ) 
					#name: #instanceVariableList 
					#model: #instanceVariableList 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedInstanceVariable 
						#requestValueChangeSelector: #changeRequest ) 
					#menu: #instanceVariableMenuHolder 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0 1 0.375 -2 1 -1 0.5 ) 
					#name: #classVariableList 
					#model: #classVariableList 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedClassVariable 
						#requestValueChangeSelector: #changeRequest ) 
					#menu: #classVariableMenuHolder 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#SubCanvasSpec 
					#layout: #(#LayoutFrame 0 0 0 0.5 0 1 0 1 ) 
					#name: #selectorNavigator 
					#flags: 0 
					#majorKey: #ClassSelectorNavigator 
					#minorKey: #verticalWindowSpec 
					#clientKey: #selectorNavigator ) ) ) )
!

windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Navigator' 
			#bounds: #(#Rectangle 139 193 727 344 ) ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0 2 0 -1 0.25 -2 1 ) 
					#name: #variableClassList 
					#model: #variableClassList 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedVariableClass 
						#requestValueChangeSelector: #changeRequest ) 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 1 0.25 2 0 -1 0.5 -1 0.5 ) 
					#name: #instanceVariableList 
					#model: #instanceVariableList 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedInstanceVariable 
						#requestValueChangeSelector: #changeRequest ) 
					#menu: #instanceVariableMenuHolder 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 1 0.25 1 0.5 -1 0.5 -2 1 ) 
					#name: #classVariableList 
					#model: #classVariableList 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedClassVariable 
						#requestValueChangeSelector: #changeRequest ) 
					#menu: #classVariableMenuHolder 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#SubCanvasSpec 
					#layout: #(#LayoutFrame 0 0.5 0 0 0 1 0 1 ) 
					#name: #selectorNavigator 
					#flags: 0 
					#majorKey: #ClassSelectorNavigator 
					#minorKey: #windowSpec 
					#clientKey: #selectorNavigator ) ) ) )
! !

!VariableNavigator class methodsFor:'resources'!

classVariableMenu
	"MenuEditor new openOnClass: self andSelector: #classVariableMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 'Remove' 
				#value: #removeClassVariable ) ) #(1 ) nil ) decodeAsLiteralArray
!

instanceVariableMenu
	"MenuEditor new openOnClass: self andSelector: #instanceVariableMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 'Pull up' 
				#value: #pullUpInstanceVariable ) 
			#(#MenuItem 
				#rawLabel: 'Remove' 
				#value: #removeInstanceVariable ) ) #(2 ) nil ) decodeAsLiteralArray
! !

!VariableNavigator methodsFor:'accessing'!

environment: anEnvironment 
	super environment: anEnvironment.
	self selectorNavigator environment: self environment
!

getState
	| state wrappedState |
	wrappedState := self selectorNavigator getState.
	state := self navigatorStateClass new.
	state
		categories: wrappedState categories;
		selectedClasses: wrappedState selectedClasses;
		protocols: wrappedState protocols;
		selectors: wrappedState selectors;
		variableClassName: self variableClassName;
		instanceVariable: self selectedInstanceVariable;
		classVariable: self selectedClassVariable.
	^state
!

navigatorStateClass
	^VariableNavigatorState
!

selectedClassVariable
	^self classVariableList selection
!

selectedInstanceVariable
	^self instanceVariableList selection
!

selectorNavigator
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^selectorNavigator isNil
		ifTrue:
			[selectorNavigator := ClassSelectorNavigator new]
		ifFalse:
			[selectorNavigator]
!

setState: aNavigatorState 
	self variableClassList selection: aNavigatorState variableClassName.
	self changedVariableClass.
	self instanceVariableList selection: aNavigatorState instanceVariable.
	self classVariableList selection: aNavigatorState classVariable.
	self selectedInstanceVariable notNil 
		ifTrue: [self changedInstanceVariable].
	self selectedClassVariable notNil ifTrue: [self changedClassVariable].
	^self selectorNavigator setState: aNavigatorState
!

variableClass
	| name |
	name := self variableClassName.
	^name notNil ifTrue: [self variableClassForName: name] ifFalse: [nil]
!

variableClassName
	^self variableClassList selection
! !

!VariableNavigator methodsFor:'aspects'!

classVariableList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^classVariableList isNil
		ifTrue:
			[classVariableList := SelectionInList new]
		ifFalse:
			[classVariableList]
!

instanceVariableList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^instanceVariableList isNil 
		ifTrue: [instanceVariableList := SelectionInList new]
		ifFalse: [instanceVariableList]
!

variableClassList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^variableClassList isNil
		ifTrue:
			[variableClassList := SelectionInList new]
		ifFalse:
			[variableClassList]
! !

!VariableNavigator methodsFor:'changing'!

changedClassVariable
	| newEnv selectedVariable |
	self instanceVariableList selection: nil.
	selectedVariable := self selectedClassVariable.
	newEnv := selectedVariable isNil 
				ifTrue: [self environment]
				ifFalse: 
					[self environment environmentForClassVariable: selectedVariable
						in: self variableClass].
	self selectEnvironment: newEnv.
	self updateMenus
!

changedInstanceVariable
	| newEnv selectedVariable |
	self classVariableList selection: nil.
	selectedVariable := self selectedInstanceVariable.
	newEnv := selectedVariable isNil 
				ifTrue: [self environment]
				ifFalse: 
					[self environment environmentForInstanceVariable: selectedVariable
						in: self variableClass].
	self selectEnvironment: newEnv.
	self updateMenus
!

changedVariableClass
	| class |
	class := self variableClass.
	class isNil 
		ifTrue: 
			[self instanceVariableList list: List new.
			self classVariableList list: List new.
			self selectEnvironment: self environment]
		ifFalse: 
			[self instanceVariableList 
				list: (self environment instanceVariablesFor: class) asSortedCollection 
						asList.
			self classVariableList 
				list: (self environment classVariablesFor: class) asSortedCollection asList.
			self selectEnvironment: SelectorEnvironment new].
	self updateMenus
!

selectEnvironment: newEnv 
	selectorNavigator
		environment: newEnv;
		updateCategoryList
! !

!VariableNavigator methodsFor:'initialize-release'!

initialize
	super initialize.
	self selectorNavigator addDependent: self.
	instanceVariableMenuHolder := self 
				initializeMenu: self class instanceVariableMenu.
	classVariableMenuHolder := self 
				initializeMenu: self class classVariableMenu
!

release
	super release.
	self selectorNavigator removeDependent: self
! !

!VariableNavigator methodsFor:'interface opening'!

postBuildWith: aBuilder 
	super postBuildWith: aBuilder.
	self updateCategoryList.
	self updateMenus
! !

!VariableNavigator methodsFor:'menus'!

classVariableMenuHolder
	^classVariableMenuHolder
!

doesClass: class defineInstanceVariable: instVar 
	^class allInstVarNames includes: instVar
!

instanceVariableMenuHolder
	^instanceVariableMenuHolder
!

updateClassVariableMenu
	| classVar |
	classVar := self selectedClassVariable.
	(classVar isNil or: [selectorNavigator environment isEmpty not]) 
		ifTrue: [self disableMenu: self classVariableMenuHolder]
		ifFalse: [self enableMenu: self classVariableMenuHolder]
!

updateInstanceVariableMenu
	| instVar class toEnable |
	class := self variableClass.
	instVar := self selectedInstanceVariable.
	class isNil | instVar isNil 
		ifTrue: [^self disableMenu: self instanceVariableMenuHolder].
	toEnable := OrderedCollection new.
	selectorNavigator environment isEmpty ifTrue: [toEnable add: 'Remove'].
	(self doesClass: class defineInstanceVariable: instVar) 
		ifFalse: [toEnable add: 'Pull up'].
	self disableMenu: self instanceVariableMenuHolder except: toEnable
!

updateMenus
	^self
		updateInstanceVariableMenu;
		updateClassVariableMenu
! !

!VariableNavigator methodsFor:'private'!

getSpec: verticalBoolean 
	^verticalBoolean 
		ifTrue: [self class verticalWindowSpec]
		ifFalse: [self class windowSpec]
!

updateCategoryList
	| selection |
	selection := self variableClassList selection.
	self variableClassList 
		list: self environment classNamesWithVariables asSortedCollection asList.
	self variableClassList selection: selection.
	self changedVariableClass.
	super updateCategoryList.
	self selectorNavigator updateCategoryList
!

variableClassForName: aSymbol 
	| class index |
	aSymbol isNil ifTrue: [^nil].
	(index := aSymbol indexOf: $ ) > 0 
		ifTrue: 
			[class := Smalltalk at: (aSymbol copyFrom: 1 to: index - 1) asSymbol
						ifAbsent: [nil].
			class isBehavior ifFalse: [^nil].
			^class class]
		ifFalse: 
			[class := Smalltalk at: aSymbol ifAbsent: [nil].
			class isBehavior ifFalse: [^nil].
			^class]
! !

!VariableNavigator methodsFor:'refactorings'!

pullUpInstanceVariable
	| class variable |
	class := self variableClass.
	variable := self selectedInstanceVariable.
	class isNil | variable isNil ifTrue: [^self].
	self handleError: 
			[(PullUpInstanceVariableRefactoring variable: variable class: class) 
				execute]
!

removeClassVariable
	| class variable |
	class := self variableClass.
	variable := self selectedClassVariable.
	class isNil | variable isNil ifTrue: [^self].
	self handleError: 
			[(RemoveClassVariableRefactoring variable: variable class: class) execute.
			self environment removeClass: class classVariable: variable.
			self updateCategoryList]
!

removeInstanceVariable
	| class variable |
	class := self variableClass.
	variable := self selectedInstanceVariable.
	class isNil | variable isNil ifTrue: [^self].
	self handleError: 
			[(RemoveInstanceVariableRefactoring variable: variable class: class) 
				execute.
			self environment removeClass: class instanceVariable: variable.
			self updateCategoryList]
! !

!VariableNavigator methodsFor:'updating'!

update: anAspectSymbol with: aParameter from: aSender 
	self changed: anAspectSymbol with: aParameter
! !

!VariableNavigator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/VariableNavigator.st,v 1.2 2003-09-23 10:47:31 cg Exp $'
! !
