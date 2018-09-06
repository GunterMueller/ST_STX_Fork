"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

MethodRefactoring subclass:#PushDownMethodRefactoring
	instanceVariableNames:'selectors'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!PushDownMethodRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk pushDown: selectorCollection from: aClass 
	^(self new)
		model: aRBSmalltalk;
		pushDown: selectorCollection from: aClass;
		yourself
!

pushDown: selectorCollection from: aClass 
	^self new pushDown: selectorCollection from: aClass
! !

!PushDownMethodRefactoring methodsFor:'initialize-release'!

pushDown: selectorCollection from: aClass 
	class := self classObjectFor: aClass.
	selectors := selectorCollection
! !

!PushDownMethodRefactoring methodsFor:'performing'!

pushDown: aSelector using: builder 
	| code protocol |
	code := class sourceCodeAt: aSelector.
	protocol := class whichCategoryIncludesSelector: aSelector.
	class subclasses do: 
			[:each | 
			(each includesSelector: aSelector) ifFalse: 
					[builder compile: code
						in: each
						classified: protocol]]
! !

!PushDownMethodRefactoring methodsFor:'preconditions'!

preconditions
        | condition |
        condition := selectors inject: RBCondition empty
                                into: 
                                        [:cond :each | 
                                        cond & (RBCondition definesSelector: each in: class) 
                                                & (RBCondition subclassesOf: class referToSelector: each) not].
        ^condition & (RBCondition isAbstractClass: class)
! !

!PushDownMethodRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' pushDown: '.
	selectors asArray storeOn: aStream.
	aStream nextPutAll: ' from: '.
	class storeOn: aStream.
	aStream nextPut: $)
! !

!PushDownMethodRefactoring methodsFor:'transforming'!

pushDown: aSelector 
	| code protocols refactoring |
	code := class sourceCodeFor: aSelector.
	protocols := class protocolsFor: aSelector.
	refactoring := ExpandReferencedPoolsRefactoring 
				model: self model
				forMethod: (class parseTreeFor: aSelector)
				fromClass: class
				toClasses: class subclasses.
	self performComponentRefactoring: refactoring.
	class subclasses do: 
			[:each | 
			(each directlyDefinesMethod: aSelector) 
				ifFalse: [each compile: code classified: protocols]]
!

transform
	selectors do: [:each | self pushDown: each].
	selectors do: [:each | class removeMethod: each]
! !

!PushDownMethodRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/PushDownMethodRefactoring.st,v 1.10 2004-06-18 08:15:04 ca Exp $'
! !
