"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCClassDefinitionTest
	instanceVariableNames:'previousChangeSet'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCClassDefinitionTest class methodsFor:'as yet unclassified'!

classAComment
	^ 'This is a mock class. The Monticello tests manipulated it to simulate a developer modifying code in the image.'
!

classACommentStamp
	^  'cwp 8/10/2003 16:43'
!

restoreClassAComment
	Smalltalk 
		at: #MCMockClassA 
		ifPresent: [:a | a classComment: self classAComment stamp: self classACommentStamp]
! !

!MCClassDefinitionTest methodsFor:'as yet unclassified'!

classAComment
	^ self class classAComment
!

creationMessage
	^ MessageSend
		receiver: MCClassDefinition
		selector: #name:superclassName:category:instVarNames:classVarNames:poolDictionaryNames:classInstVarNames:type:comment:commentStamp:
!

tearDown
	Smalltalk at: 'MCMockClassC' ifPresent: [:c | c removeFromSystem]
!

testCannotLoad
        | d |

        Smalltalk removeClassNamed:'MCMockClassC'.
        self deny: (Smalltalk hasClassNamed: 'MCMockClassC').       "/ should not be there initially

        d _  self mockClass: 'MCMockClassC' super: 'NotAnObject'.
        self should: [d load] raise: Error.
        self deny: (Smalltalk hasClassNamed: 'MCMockClassC').
!

testComparison
	| d1 d2 d3 d4 |
	d1 _ self mockClass: 'A' super: 'X'.
	d2 _ self mockClass: 'A' super: 'Y'.
	d3 _ self mockClass: 'B' super: 'X'.
	d4 _ self mockClass: 'B' super: 'X'.
	
	self assert: (d1 isRevisionOf: d2).
	self deny: (d1 isSameRevisionAs: d2).

	self assert: (d3 isRevisionOf: d4).
	self assert: (d3 isSameRevisionAs: d4).
	
	self deny: (d1 isRevisionOf: d3).
	self deny: (d4 isRevisionOf: d2).
!

testCreation
        | d |
        d _  self mockClassA asClassDefinition.
        self assert: d className = #MCMockClassA.
        self assert: d superclassName = #MCMock.
        self assert: d type = #normal.
        self assert: d category = self mockCategoryName.
        self assert: d instVarNames asArray = #('ivar').
        self assert: d classVarNames asArray = #('CVar').
        self assert: d classInstVarNames asArray = #().
        self assert: d comment isString.
        self assert: d comment = self classAComment.
        Smalltalk isSmalltalkX ifTrue:[
            self assert: d commentStamp = d defaultCommentStamp
        ] ifFalse:[
            self assert: d commentStamp = self mockClassA organization commentStamp
        ].
!

testDefinitionString
        | d |
        d _ self mockClassA asClassDefinition.
        Smalltalk isSmalltalkX ifTrue:[
            "/ not true, due to package comment...
            "/ self assert: d definitionString = self mockClassA definition.
        ] ifFalse:[
            self assert: d definitionString = self mockClassA definition.
        ].
!

testEquals
	| a b |
	a _ self mockClass: 'ClassA' super: 'SuperA'.
	b _ self mockClass: 'ClassA' super: 'SuperA'.
	self assert: a = b
!

testEqualsSensitivity
	| message a b defA args defB |
	message _ self creationMessage.
	a _ #(ClassA SuperA CategoryA #(iVarA) #(CVarA) #(PoolA) #(ciVarA)
			typeA 'A comment' 'A').
	b _ #(ClassB SuperB CategoryB #(iVarB) #(CVarB) #(PoolB) #(ciVarB)
			typeB 'B comment' 'B').
	
	defA _ message valueWithArguments: a.
	1 to: 8 do: [:index |
				args _ a copy.
				args at: index put: (b at: index).
				defB _ message valueWithArguments: args.
				self deny: defA = defB.]
!

testKindOfSubclass
        | classes d |
        Smalltalk isSmalltalkX ifTrue:[
            classes _ {self mockClassA. String. Method. Context. WeakArray. Float}.
        ] ifFalse:[
            classes _ {self mockClassA. String. MethodContext. WeakArray. Float}.
        ].
        classes do: [:c |
                d _  c asClassDefinition.
                self assert: d kindOfSubclass = c kindOfSubclass.
        ].
!

testLoadAndUnload
        | d c |
        d _  self mockClass: 'MCMockClassC' super: 'Object'.
        d load.
        self assert: (Smalltalk hasClassNamed: 'MCMockClassC').
        c _ (Smalltalk classNamed: 'MCMockClassC').
        self assert: (c isKindOf: Class).
        self assert: c superclass = Object.
        self assert: c instVarNames isEmpty.
        self assert: c classVarNames isEmpty.
        self assert: c sharedPools isEmpty.
        self assert: c category = self mockCategoryName.
        Smalltalk isSmalltalkX ifTrue:[
            self assert: c comment = (self commentForClass: 'MCMockClassC').
        ] ifFalse:[
            self assert: c organization classComment = (self commentForClass: 'MCMockClassC').
            self assert: c organization commentStamp = (self commentStampForClass: 'MCMockClassC').
        ].
        d unload.
        self deny: (Smalltalk hasClassNamed: 'MCMockClassC').
! !

!MCClassDefinitionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCClassDefinitionTest.st,v 1.4 2013-05-29 00:00:16 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCClassDefinitionTest.st,v 1.4 2013-05-29 00:00:16 vrany Exp $'
! !

