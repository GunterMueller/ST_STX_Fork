"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

MethodRefactoring subclass:#ExtractMethodToComponentRefactoring
	instanceVariableNames:'selector extractionInterval extractedMethodSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!ExtractMethodToComponentRefactoring class methodsFor:'instance creation'!

extract: anInterval from: aSelector in: aClass 
	^self new
		extract: anInterval
		from: aSelector
		in: aClass
!

model: aRBSmalltalk extract: anInterval from: aSelector in: aClass 
	^(self new)
		model: aRBSmalltalk;
		extract: anInterval
			from: aSelector
			in: aClass;
		yourself
! !

!ExtractMethodToComponentRefactoring methodsFor:'initialize-release'!

extract: anInterval from: aSelector in: aClass 
	class := self classObjectFor: aClass.
	selector := aSelector.
	extractionInterval := anInterval
! !

!ExtractMethodToComponentRefactoring methodsFor:'preconditions'!

preconditions
	^RBCondition empty
! !

!ExtractMethodToComponentRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' extract: '.
	extractionInterval storeOn: aStream.
	aStream
		nextPutAll: ' from: #';
		nextPutAll: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)
! !

!ExtractMethodToComponentRefactoring methodsFor:'transforming'!

extractMethod
	| refactoring |
	refactoring := ExtractMethodRefactoring 
				model: self model
				extract: extractionInterval
				from: selector
				in: class.
	refactoring setOption: #methodName
		toUse: 
			[:ref :methodName | 
			extractedMethodSelector := ref 
						uniqueMethodNameFor: methodName arguments size.
			methodName
				selector: extractedMethodSelector;
				yourself].
	self performComponentRefactoring: refactoring
!

inlineForwarder
        | refactoring |
        refactoring := InlineAllSelfSendersRefactoring 
                                model: self model
                                sendersOf: extractedMethodSelector
                                in: class.
        refactoring setOption: #inlineExpression toUse: [:ref :string | true].
        self performComponentRefactoring: refactoring
!

moveMethod
	| variable refactoring |
	variable := self selectVariableToMoveMethodTo: extractedMethodSelector
				class: class.
	variable isNil ifTrue: [self refactoringError: 'Did not extract method'].
	refactoring := MoveMethodRefactoring 
				model: self model
				selector: extractedMethodSelector
				class: class
				variable: variable.
	self performComponentRefactoring: refactoring
!

transform
	self
		extractMethod;
		moveMethod;
		inlineForwarder
! !

!ExtractMethodToComponentRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/ExtractMethodToComponentRefactoring.st,v 1.4 2009-09-22 10:19:35 cg Exp $'
! !
