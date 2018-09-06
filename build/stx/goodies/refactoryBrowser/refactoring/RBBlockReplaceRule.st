"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

RBReplaceRule subclass:#RBBlockReplaceRule
	instanceVariableNames:'replaceBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!


!RBBlockReplaceRule class methodsFor:'instance creation'!

searchFor: searchString replaceWith: replaceBlock 
	^self new searchFor: searchString replaceWith: replaceBlock
!

searchFor: searchString replaceWith: replaceBlock when: aBlock 
	^self new 
		searchFor: searchString
		replaceWith: replaceBlock
		when: aBlock
!

searchForMethod: searchString replaceWith: replaceBlock 
	^self new searchForMethod: searchString replaceWith: replaceBlock
!

searchForMethod: searchString replaceWith: replaceBlock when: aBlock 
	^self new 
		searchForMethod: searchString
		replaceWith: replaceBlock
		when: aBlock
!

searchForTree: searchString replaceWith: replaceBlock 
	^self new searchForTree: searchString replaceWith: replaceBlock
!

searchForTree: searchString replaceWith: replaceBlock when: aBlock 
	^self new 
		searchFor: searchString
		replaceWith: replaceBlock
		when: aBlock
! !

!RBBlockReplaceRule methodsFor:'initialize-release'!

initialize
	super initialize.
	replaceBlock := [:aNode | aNode]
!

searchFor: searchString replaceWith: aBlock 
	self searchString: searchString.
	replaceBlock := aBlock
!

searchFor: searchString replaceWith: replBlock when: verifyBlock 
	self searchFor: searchString replaceWith: replBlock.
	verificationBlock := verifyBlock
!

searchForMethod: searchString replaceWith: aBlock 
	self methodSearchString: searchString.
	replaceBlock := aBlock
!

searchForMethod: searchString replaceWith: replBlock when: verifyBlock 
	self searchForMethod: searchString replaceWith: replBlock.
	verificationBlock := verifyBlock
!

searchForTree: aBRProgramNode replaceWith: aBlock 
	searchTree := aBRProgramNode.
	replaceBlock := aBlock
!

searchForTree: aBRProgramNode replaceWith: replBlock when: verifyBlock 
	self searchForTree: aBRProgramNode replaceWith: replBlock.
	verificationBlock := verifyBlock
! !

!RBBlockReplaceRule methodsFor:'matching'!

foundMatchFor: aProgramNode 
	^replaceBlock value: aProgramNode
! !

!RBBlockReplaceRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RBBlockReplaceRule.st,v 1.5 2003-09-23 10:47:07 cg Exp $'
! !
