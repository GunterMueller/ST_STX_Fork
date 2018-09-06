"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

MethodRefactoring subclass:#AddMethodRefactoring
	instanceVariableNames:'protocols'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!AddMethodRefactoring class methodsFor:'instance creation'!

addMethod: aString toClass: aClass inProtocols: protocolList 
	^self new addMethod: aString
		toClass: aClass
		inProtocols: protocolList
!

model: aRBSmalltalk addMethod: aString toClass: aClass inProtocols: protocolList 
	^(self new)
		model: aRBSmalltalk;
		addMethod: aString
			toClass: aClass
			inProtocols: protocolList;
		yourself
! !

!AddMethodRefactoring methodsFor:'initialize-release'!

addMethod: aString toClass: aClass inProtocols: protocolList 
	class := self classObjectFor: aClass.
	source := aString.
	protocols := protocolList
! !

!AddMethodRefactoring methodsFor:'preconditions'!

preconditions
        | selector method |
        method := RBParser parseMethod: source
                                onError: 
                                        [:string :position | 
                                        ^RBCondition 
                                                withBlock: [self refactoringError: 'The sources could not be parsed']].
        selector := method selector.
        selector isNil ifTrue: [self refactoringError: 'Invalid source.'].
        ^(RBCondition canUnderstand: selector in: class) not
! !

!AddMethodRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' addMethod: ''';
		nextPutAll: source;
		nextPutAll: ''' toClass: '.
	class storeOn: aStream.
	aStream nextPutAll: ' inProtocols: '.
	protocols storeOn: aStream.
	aStream nextPut: $)
! !

!AddMethodRefactoring methodsFor:'transforming'!

transform
	class compile: source classified: protocols
! !

!AddMethodRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/AddMethodRefactoring.st,v 1.14 2004-06-18 08:15:33 ca Exp $'
! !
