"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

"{ NameSpace: Smalltalk }"

RefactoringTest subclass:#InlineAllMethodTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!InlineAllMethodTest methodsFor:'tests'!

testInlineMethodWithMultipleSendersInMethod
        | refactoring |
        refactoring := InlineAllSelfSendersRefactoring sendersOf: #caller2
                                in: RefactoryTestDataApp.
        self executeRefactoring: refactoring.
        self 
                assert: ((refactoring model classNamed: #RefactoryTestDataApp) 
                                parseTreeFor: #inlineLast) = (RBParser 
                                                        parseMethod: 'inlineLast
        5 = 3 ifTrue: [^self caller] ifFalse: [^(1 to: 10) inject: 1 into: [:sum :each | sum * (self foo: each)]] ').
        self 
                assert: ((refactoring model classNamed: #RefactoryTestDataApp) 
                                parseTreeFor: #multipleCalls) = (RBParser 
                                                        parseMethod: 'multipleCalls
        (1 to: 10) inject: 1 into: [:sum :each | sum * (self foo: each)].
        (1 to: 10) inject: 1 into: [:sum1 :each1 | sum1 * (self foo: each1)]')

    "Modified: / 05-02-2017 / 01:15:26 / cg"
!

testRecursiveMethod
        | class |
        model := RBNamespace new.
        class := model classNamed: self class name.
        class
                compile: 'foo ^self foo' classified: #(#accessing);
                compile: 'bar ^self foo' classified: #(#accessing).
        self executeRefactoring: (InlineAllSelfSendersRefactoring 
                                model: model
                                sendersOf: #foo
                                in: class).
        self assert: (class parseTreeFor: #foo) 
                                = (RBParser parseMethod: 'foo ^self foo').
        self assert: (class parseTreeFor: #bar) 
                                = (RBParser parseMethod: 'bar ^self foo')

    "Modified: / 05-02-2017 / 01:15:07 / cg"
! !

!InlineAllMethodTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

