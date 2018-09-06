"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

MethodRefactoring subclass:#InlineAllSelfSendersRefactoring
	instanceVariableNames:'selector numberReplaced numberNotReplaced'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!

!InlineAllSelfSendersRefactoring class methodsFor:'documentation'!

documentation
"
    This refactoring inlines all self sends of a method. 
    If, after the inlining, there are no references to the method, it is removed.

    Instance Variables:
        numberNotReplaced   <Number>   Number of sends not inlined.
        numberReplaced      <Number>   Number of send inlined.
        selector            <Symbol>   Selector of method to inline.
"
! !

!InlineAllSelfSendersRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk sendersOf: aSelector in: aClass 
	^(self new)
		model: aRBSmalltalk;
		sendersOf: aSelector in: aClass;
		yourself
!

sendersOf: aSelector in: aClass 
	^self new sendersOf: aSelector in: aClass
! !

!InlineAllSelfSendersRefactoring methodsFor:'accessing'!

messagesNotReplaced
	^numberNotReplaced
! !

!InlineAllSelfSendersRefactoring methodsFor:'initialize-release'!

sendersOf: aSelector in: aClass 
	class := self classObjectFor: aClass.
	selector := aSelector.
	numberReplaced := numberNotReplaced := 0
! !

!InlineAllSelfSendersRefactoring methodsFor:'preconditions'!

preconditions
	^RBCondition canUnderstand: selector in: class
! !

!InlineAllSelfSendersRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' sendersOf: #';
		nextPutAll: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)
! !

!InlineAllSelfSendersRefactoring methodsFor:'transforming'!

checkInlinedMethods
	numberReplaced = 0 
		ifTrue: [self refactoringError: 'Could not inline any senders']
!

inlineMessagesInClass: aClass andSelector: aSelector 
        | messagesToInline previousCountOfMessages |
        previousCountOfMessages := 4294967295.  "Some really large number > # of initial self sends."
        
        [   |tree|

            tree := aClass parseTreeFor: aSelector.
            messagesToInline := tree isNil ifTrue:[0]
                                ifFalse:[ self numberOfSelfSendsIn: tree ].
            messagesToInline > 0 and: [previousCountOfMessages > messagesToInline]
        ] whileTrue: 
            [| node |
            previousCountOfMessages := messagesToInline.
            node := self selfSendIn: (aClass parseTreeFor: aSelector).
            self onError: 
                            [self performComponentRefactoring: (InlineMethodRefactoring 
                                                    model: self model
                                                    inline: node sourceInterval
                                                    inMethod: aSelector
                                                    forClass: aClass).
                            numberReplaced := numberReplaced + 1]
                    do: []].
        numberNotReplaced := numberNotReplaced + messagesToInline
!

inlineSelfSends
	class withAllSubclasses do: 
			[:each | 
			| selectors |
			selectors := each selectors.
			selectors remove: selector ifAbsent: [].
			selectors do: [:sel | self inlineMessagesInClass: each andSelector: sel]]
!

messagePattern
	^'self ' , (self buildSelectorString: selector)
!

numberOfSelfSendsIn: aParseTree 
	| search |
	search := ParseTreeSearcher new.
	search matches: self messagePattern do: [:aNode :answer | answer + 1].
	^search executeTree: aParseTree initialAnswer: 0
!

removeMethod
	self onError: 
			[self performComponentRefactoring: (RemoveMethodRefactoring 
						model: self model
						removeMethods: (Array with: selector)
						from: class)]
		do: []
!

selfSendIn: aTree 
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: self messagePattern do: [:aNode :answer | ^aNode].
	^searcher executeTree: aTree initialAnswer: nil
!

transform
	self
		inlineSelfSends;
		removeMethod;
		checkInlinedMethods
! !

!InlineAllSelfSendersRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/InlineAllSendersRefactoring.st,v 1.12 2009-09-22 10:19:21 cg Exp $'
! !
