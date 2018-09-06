"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserApplicationModel subclass:#CodeTool
	instanceVariableNames:'codeModel'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Code Tools'
!

CodeTool comment:'CodeTool is an abstact class represents the tools that can appear when a user has selected an item (e.g., a class) using the navigator. These tools are dynamically switched depending on current selection.

Instance Variables:
	codeModel       <CodeModel> contains the CodeModel that the CodeTool is in
'
!


!CodeTool class methodsFor:'instance creation'!

codeModel: aCodeModel 
	^self new codeModel: aCodeModel
!

on: aCodeModel 
	^self new codeModel: aCodeModel
! !

!CodeTool methodsFor:'accessing'!

categories
	^codeModel categories
!

category
	^codeModel category
!

className
	^codeModel className
!

classNames
	^codeModel classNames
!

environment
	^self navigator environment
!

isMeta
	^codeModel isMeta
!

menu
	"Return a menu that can be placed into a window. Menus that use symbol must be converted to use
	blocks since they will have a different model when they are placed into a window."

	^(Menu new) addItemLabel: '&update display' value: [self updateDisplay];
		yourself
!

methods
	^codeModel methods
!

navigator
	^codeModel navigator
!

nonMetaClass
	^codeModel nonMetaClass
!

nonMetaClasses
	^codeModel nonMetaClasses
!

protocol
	^codeModel protocol
!

protocols
	^codeModel protocols
!

saveState
	self subcanvases do: [:each | each saveState]
!

selectedClass
	^codeModel selectedClass
!

selectedClasses
	^codeModel selectedClasses
!

selector
	^codeModel selector
!

selectors
	^codeModel selectors
! !

!CodeTool methodsFor:'initialize-release'!

codeModel: aCodeModel 
	codeModel := aCodeModel
! !

!CodeTool methodsFor:'testing'!

isEditing
	"Return true if your contents have changed and haven't been accepted."

	^self subcanvases contains: [:each | each isEditing]
! !

!CodeTool methodsFor:'updating'!

updateContents
!

updateDisplay
	self subcanvases do: [:each | each updateDisplay]
! !

!CodeTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/CodeTool.st,v 1.7 2003-09-23 10:43:18 cg Exp $'
! !
