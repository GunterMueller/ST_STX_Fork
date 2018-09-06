"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

CodeToolSelectionPolicy subclass:#SourceSelectionPolicy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Browser'
!


!SourceSelectionPolicy methodsFor:'accessing-classes'!

codeToolClassForCategory: aSymbol 
	^ClassNavigatorTool
!

codeToolClassForClass: aBehavior 
	^ClassNavigatorTool
!

codeToolClassForProtocol: aSymbol andClass: aBehavior 
	^BrowserCodeTool
!

codeToolClassForSelector: aSymbol andClass: aBehavior 
	| method |
	^aBehavior isMeta 
		ifTrue: 
			[method := aBehavior compiledMethodAt: aSymbol.
			(#(#image #menu #canvas) includes: method resourceType) 
				ifTrue: [self defaultCanvasToolClass]
				ifFalse: [self defaultCodeToolClass]]
		ifFalse: [self defaultCodeToolClass]
!

defaultCanvasToolClass
	^ResourceTool
!

defaultCodeToolClass
	^BrowserCodeTool
!

nothingSelectedCodeToolClass
	^ClassNavigatorTool
! !

!SourceSelectionPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/SourceSelectionPolicy.st,v 1.2 2003-09-23 10:48:02 cg Exp $'
! !
