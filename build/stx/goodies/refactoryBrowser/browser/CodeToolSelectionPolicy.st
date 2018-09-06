"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

Object subclass:#CodeToolSelectionPolicy
	instanceVariableNames:'name codeModel'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Browser'
!


!CodeToolSelectionPolicy class methodsFor:'instance creation'!

named: aString 
	^(self new)
		named: aString;
		yourself
! !

!CodeToolSelectionPolicy methodsFor:'accessing'!

name
	^name
!

toolClass
	| class protocol selector category |
	class := codeModel selectedClass.
	class isNil 
		ifTrue: 
			[category := codeModel category.
			^category isNil 
				ifTrue: [self nothingSelectedCodeToolClass]
				ifFalse: [self codeToolClassForCategory: category]].
	protocol := codeModel protocol.
	protocol isNil ifTrue: [^self codeToolClassForClass: class].
	selector := codeModel selector.
	^selector isNil 
		ifTrue: [self codeToolClassForProtocol: protocol andClass: class]
		ifFalse: [self codeToolClassForSelector: selector andClass: class]
! !

!CodeToolSelectionPolicy methodsFor:'accessing-classes'!

codeToolClassForCategory: aSymbol 
	^CodeTool
!

codeToolClassForClass: aBehavior 
	^CodeTool
!

codeToolClassForProtocol: aSymbol andClass: aBehavior 
	^CodeTool
!

codeToolClassForSelector: aSymbol andClass: aBehavior 
	^CodeTool
!

nothingSelectedCodeToolClass
	^CodeTool
! !

!CodeToolSelectionPolicy methodsFor:'comparing'!

= aCodeToolSelectionPolicy 
	self class = aCodeToolSelectionPolicy class ifFalse: [^false].
	^self name = aCodeToolSelectionPolicy name
!

hash
	^self name hash
! !

!CodeToolSelectionPolicy methodsFor:'initialize-release'!

for: aCodeModel 
	codeModel := aCodeModel
!

named: aString 
	name := aString
! !

!CodeToolSelectionPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/CodeToolSelectionPolicy.st,v 1.2 2003-09-23 10:43:45 cg Exp $'
! !
