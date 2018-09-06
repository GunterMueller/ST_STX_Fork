"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ParseTreeRule
	instanceVariableNames:'searchTree owner'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Parser'
!


!ParseTreeRule class methodsFor:'instance creation'!

methodSearch: aString 
	^(self new)
		methodSearchString: aString;
		yourself
!

new
	^(super new)
		initialize;
		yourself
!

search: aString 
	^(self new)
		searchString: aString;
		yourself
! !

!ParseTreeRule methodsFor:'initialize-release'!

initialize
!

methodSearchString: aString 
        searchTree := RBParser parseRewriteMethod: aString
!

owner: aParseTreeSearcher
	owner := aParseTreeSearcher
!

searchString: aString 
        searchTree := RBParser parseRewriteExpression: aString
! !

!ParseTreeRule methodsFor:'matching'!

foundMatchFor: aProgramNode
	self subclassResponsibility
!

performOn: aProgramNode 
        self context removeAll.
        ^(searchTree match: aProgramNode inContext: self context) 
                ifTrue: 
                        [owner recusivelySearchInContext.
                        self foundMatchFor: aProgramNode]
                ifFalse: [nil]
! !

!ParseTreeRule methodsFor:'private'!

context
	^owner context
! !

!ParseTreeRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/ParseTreeRule.st,v 1.6 2003-09-23 22:14:52 cg Exp $'
! !

