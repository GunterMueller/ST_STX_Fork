"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

ChangeMethodNameRefactoring subclass:#RemoveParameterRefactoring
	instanceVariableNames:'parameterIndex argument'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RemoveParameterRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk removeParameter: aString in: aClass selector: aSelector 
	^(self new)
		model: aRBSmalltalk;
		removeParameter: aString
			in: aClass
			selector: aSelector;
		yourself
!

removeParameter: aString in: aClass selector: aSelector
	^self new removeParameter: aString in: aClass selector: aSelector
! !

!RemoveParameterRefactoring methodsFor:'initialize-release'!

removeParameter: aString in: aClass selector: aSelector 
	oldSelector := aSelector.
	class := self classObjectFor: aClass.
	argument := aString
! !

!RemoveParameterRefactoring methodsFor:'preconditions'!

myConditions
        | imps |
        imps := self model allImplementorsOf: oldSelector.
        self getNewSelector.
        ^imps inject: (RBCondition definesSelector: oldSelector in: class)
                into: 
                        [:cond :each | 
                        cond 
                                & (RBCondition withBlock: [(self hasReferencesToTemporaryIn: each) not]
                                                errorString: 'This argument is still referenced in at least one implementor!!!!')]
! !

!RemoveParameterRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' removeParameter: ''';
		nextPutAll: argument;
		nextPutAll: ''' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' selector: #';
		nextPutAll: oldSelector.
	aStream nextPut: $)
! !

!RemoveParameterRefactoring methodsFor:'private'!

computeNewSelector
	| keywords stream |
	oldSelector numArgs == 0 
		ifTrue: [self refactoringError: 'This method contains no arguments'].
	oldSelector isInfix 
		ifTrue: [self refactoringError: 'Cannot remove parameters of infix selectors'].
	keywords := oldSelector keywords asOrderedCollection.
	keywords size = 1 ifTrue: [^(keywords first copyWithout: $:) asSymbol].
	keywords removeAtIndex: parameterIndex.
	stream := WriteStream on: ''.
	keywords do: [:each | stream nextPutAll: each].
	^stream contents asSymbol
! !

!RemoveParameterRefactoring methodsFor:'transforming'!

getNewSelector
	| tree |
	(class directlyDefinesMethod: oldSelector)
		ifFalse: [self refactoringError: 'Method doesn''t exist'].
	tree := class parseTreeFor: oldSelector.
	tree isNil ifTrue: [self refactoringError: 'Cannot parse sources'].
	parameterIndex := tree argumentNames indexOf: argument ifAbsent: [self refactoringError: 'Select a parameter!!!!'].
	permutation := (1 to: oldSelector numArgs)
				copyWithout: parameterIndex.
	newSelector := self computeNewSelector
!

hasReferencesToTemporaryIn: each 
	| tree |
	tree := each parseTreeFor: oldSelector.
	tree isNil ifTrue: [self refactoringError: 'Cannot parse sources.'].
	^tree references: (tree argumentNames at: parameterIndex)
! !

!RemoveParameterRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RemoveParameterRefactoring.st,v 1.11 2009-09-21 20:04:20 cg Exp $'
! !
