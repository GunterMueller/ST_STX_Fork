"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringBrowserTest subclass:#ExtraParsingAndFormattingTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!ExtraParsingAndFormattingTests class methodsFor:'testing'!

methodsNotToTest
   ^ #().
! !

!ExtraParsingAndFormattingTests methodsFor:'testing'!

methodsNotToTest
	^ self class methodsNotToTest.
!

testParsingAndFormattingEverything
       | source tree1 tree2|
	self needsWork. "commented to speed regression testing.  be sure to uncomment."

       XXXClasses isNil ifTrue:[
	   XXXClasses := Smalltalk allClasses copy.
       ].
       XXXClasses copy do: 
		[:class | 
		Transcript cr; show:class name.
		class selectors do: 
			[:sel | (self methodsNotToTest includes: class >> sel) ifFalse: 
				[ 
				tree2 _ RBParser parseMethod: (tree1 _ RBParser parseMethod: (source := class sourceCodeAt: sel)) formattedCode.
				self assert:tree1 = tree2]].
		XXXClasses remove:class ifAbsent:nil]
! !

!ExtraParsingAndFormattingTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/ExtraParsingAndFormattingTests.st,v 1.4 2003-10-06 14:39:33 cg Exp $'
! !
