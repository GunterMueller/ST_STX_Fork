"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

Model subclass:#OMTClassModel
	instanceVariableNames:'class instVarNames methods classMenuHolder instVarMenuHolder
		methodMenuHolder navigator'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-OMT-Diagram'
!

OMTClassModel comment:'OMTClassModel is the model for the OMTClassView.

Instance Variables:
	class   <Behavior>      the class we''re for
	classMenuHolder <ValueHolder on: Menu>  the menu for the class
	instVarMenuHolder       <ValueHolder on: Menu>  the menu for the inst var list
	instVarNames    <SelectionInList on: String>    the list of inst var names
	methodMenuHolder        <ValueHolder on: Menu>  the menu for the methods
	methods <SelectionInList on: Symbol>    the list of selectors
	navigator       <Navigator>     the navigator we''re associated with'
!


!OMTClassModel class methodsFor:'resources'!

classMenu
	"UIMenuEditor new openOnClass: self andSelector: #classMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem
				#label: 'references...' )
			#(#MenuItem
				#label: 'rename as...' )
			#(#MenuItem
				#label: 'remove...' ) ) #(1 2 ) #(#classRefs #renameClass #removeClass ) ) decodeAsLiteralArray
!

instVarMenu
	"MenuEditor new openOnClass: self andSelector: #instVarMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 'references...' 
				#value: #instVarRefs ) 
			#(#MenuItem 
				#rawLabel: 'add...' 
				#value: #addInstVar ) 
			#(#MenuItem 
				#rawLabel: 'rename as...' 
				#value: #renameInstVar ) 
			#(#MenuItem 
				#rawLabel: 'remove...' 
				#value: #removeInstVar ) 
			#(#MenuItem 
				#rawLabel: 'abstract' 
				#value: #abstractInstVar ) ) #(1 3 1 ) nil ) decodeAsLiteralArray
!

menu
	"UIMenuEditor new openOnClass: self andSelector: #menu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem
				#label: 'senders...' )
			#(#MenuItem
				#label: 'implementors...' )
			#(#MenuItem
				#label: 'rename as...' )
			#(#MenuItem
				#label: 'remove...' ) ) #(2 2 ) #(#senders #implementors #renameMethod #removeMethod ) ) decodeAsLiteralArray
!

methodMenu
	"UIMenuEditor new openOnClass: self andSelector: #methodMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#label: 'senders' ) 
			#(#MenuItem 
				#label: 'implementors...' ) 
			#(#MenuItem 
				#label: 'rename as...' ) 
			#(#MenuItem 
				#label: 'remove...' ) ) #(2 2 ) #(#senders #implementors #renameMethod #removeMethod ) ) decodeAsLiteralArray
!

noInstVarMenu
	"UIMenuEditor new openOnClass: self andSelector: #noInstVarMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem
				#label: 'add...' ) ) #(1 ) #(#addInstVar ) ) decodeAsLiteralArray
! !

!OMTClassModel methodsFor:'accessing'!

environment
	^navigator environment
!

instVarListHolder
	^instVarNames
!

methodListHolder
	^methods
!

name
	^class name
!

navigator
	^navigator
! !

!OMTClassModel methodsFor:'actions-class'!

classRefs
	self navigator browseReferencesTo: (Smalltalk associationAt: self nonMetaClass name ifAbsent: [^self])
!

removeClass
	self navigator removeClassesSafe: (Array with: self nonMetaClass)
!

renameClass
	self navigator renameClass: self nonMetaClass
! !

!OMTClassModel methodsFor:'actions-instVars'!

abstractInstVar
	self navigator abstractInstVar: instVarNames selection in: class
!

addInstVar
	self navigator addInstVarIn: class.
	self updateInstVars
!

convertInstVarToValueHolder
	self navigator valueHolderForInstVar: instVarNames selection in: class
!

instVarRefs
	| instVarName |
	instVarName := instVarNames selection.
	self navigator browseInstVarRefsTo: instVarName in: class
!

removeInstVar
	self navigator removeInstVar: instVarNames selection fromClass: class.
	self updateInstVars
!

renameInstVar
	self navigator renameInstVar: instVarNames selection in: class.
	self updateInstVars
! !

!OMTClassModel methodsFor:'actions-methods'!

implementors
	self navigator browseImplementorsOf: methods selection
!

removeMethod
	self navigator removeMethodsSafe: (Array with: methods selection) from: class.
	self updateMethods
!

renameMethod
	self navigator renameMethod: methods selection in: class.
	self updateMethods
!

senders
	self navigator browseReferencesTo: methods selection
! !

!OMTClassModel methodsFor:'change'!

changedInstVar
	instVarMenuHolder value: (instVarNames selection isNil
			ifTrue: [self class noInstVarMenu]
			ifFalse: [self class instVarMenu])
!

changedMethod
	methodMenuHolder value: (methods selection isNil
			ifTrue: [nil]
			ifFalse: [self class methodMenu])
!

updateInstVars
	| oldName |
	oldName := instVarNames selection.
	instVarNames list: (List withAll: class instVarNames asSortedCollection).
	instVarNames selection: oldName
!

updateMethods
	| oldSelector |
	oldSelector := methods selection.
	methods list: (List withAll: (self environment selectorsForClass: class) asSortedCollection).
	methods selection: oldSelector
! !

!OMTClassModel methodsFor:'initialize-release'!

on: aClass in: aNavigator
	navigator := aNavigator.
	class := aClass.
	instVarNames := SelectionInList new.
	methods := SelectionInList new.
	self updateInstVars.
	self updateMethods.
	instVarNames selectionIndexHolder onChangeSend: #changedInstVar to: self.
	methods selectionIndexHolder onChangeSend: #changedMethod to: self
! !

!OMTClassModel methodsFor:'menu'!

classMenuHolder
	classMenuHolder isNil ifTrue: [classMenuHolder := self class classMenu asValue].
	^classMenuHolder
!

instVarMenuHolder
	instVarMenuHolder isNil
		ifTrue:
			[instVarMenuHolder := nil asValue.
			self changedInstVar].
	^instVarMenuHolder
!

methodMenuHolder
	methodMenuHolder isNil
		ifTrue:
			[methodMenuHolder := nil asValue.
			self changedMethod].
	^methodMenuHolder
! !

!OMTClassModel methodsFor:'private-class functions'!

nonMetaClass
	^class isMeta
		ifTrue: [class soleInstance]
		ifFalse: [class]
! !

!OMTClassModel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/OMTClassModel.st,v 1.7 2003-09-23 10:46:22 cg Exp $'
! !
