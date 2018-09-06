"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCRecognizerComponentVisitorTest
	instanceVariableNames:'node result visitor'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Visitors'
!


!PPCRecognizerComponentVisitorTest methodsFor:'as yet unclassified'!

asNode: aPPParser
    self error: 'deprecated'.
    ^ aPPParser asCompilerTree
!

assert: object type: class
    self assert: object class == class
!

setUp
    visitor := PPCRecognizerComponentVisitor new.
!

testAction
    | letterNode |
    letterNode := PPCMessagePredicateNode new
        message: #isLetter;
        yourself.
    
    node := PPCActionNode new
        block: [ :nodes | #foo ];
        child: letterNode;
        yourself.
        
    result := visitor visit: node.
    self assert: result type: PPCMessagePredicateNode.
    self assert: result = letterNode.
!

testAction2
    | letterNode actionNode |
    
    letterNode := PPCMessagePredicateNode new
        predicate: #isLetter;
        yourself.
        
    actionNode := PPCActionNode new
        block:  #boo;
        child: letterNode;
        yourself.
    
    node := PPCTokenNode new
        child: actionNode;
        yourself.
    
    result := visitor visit: node.
    
    self assert: result type: PPCMessagePredicateNode.
    self assert: result = letterNode.
!

testAction3
    | letterNode actionNode |
    
    letterNode := PPCMessagePredicateNode new
        predicate: #isLetter;
        yourself.
        
    actionNode := PPCActionNode new
        block: #foo;
        child: letterNode;
        yourself.
    
    node := PPCActionNode new
        block: #foo;
        child: actionNode;
        yourself.
    
    result := visitor visit: node.
    
    self assert: result type: PPCMessagePredicateNode.
    self assert: result = letterNode.
!

testNotAction
    | literalNode actionNode |
    literalNode := PPCLiteralNode new
        literal: 'foo';
        yourself.
    
    actionNode := PPCActionNode new
        block: #foo;
        child: literalNode;
        yourself.
    
    node := PPCNotNode new
        child: actionNode;
        yourself.
        
    result := visitor visit: node.
    
    self assert: result type: PPCNotNode.
    self assert: result child type: PPCLiteralNode.
!

testNotAction2
    | literalNode actionNode seqNode |
    literalNode := PPCLiteralNode new
        literal: 'foo';
        yourself.
    
    seqNode := PPCSequenceNode new
        children: { literalNode . literalNode  };
        yourself.
    
    actionNode := PPCActionNode new
        block: #foo;
        child: seqNode;
        yourself.
    
    node := PPCNotNode new
        child: actionNode;
        yourself.
        
    result := visitor visit: node.
    
    self assert: result type: PPCNotNode.
    
    self assert: result child type: PPCRecognizingSequenceNode.
    self assert: result child firstChild type: PPCLiteralNode.
    self assert: result child secondChild type: PPCLiteralNode.	
!

testNotAction3
    | literalNode actionNode seqNode |
    literalNode := PPCLiteralNode new
        literal: 'foo';
        yourself.
    
    seqNode := PPCSequenceNode new
        children: { literalNode . literalNode  };
        yourself.
    
    actionNode := PPCSymbolActionNode new
        symbol: #second;
        child: seqNode;
        yourself.
    
    node := PPCNotNode new
        child: actionNode;
        yourself.
        
    result := visitor visit: node.
    
    self assert: result type: PPCNotNode.
    
    self assert: result child type: PPCRecognizingSequenceNode.
    self assert: result child firstChild type: PPCLiteralNode.
    self assert: result child secondChild type: PPCLiteralNode.		
!

testRecognizingSequence1
    | letterNode1 letterNode2 |
    letterNode1 := PPCCharacterNode new character: $a.
    letterNode2 := PPCCharacterNode new character: $b.
    
    node := PPCSequenceNode new
        children: { letterNode1 . letterNode2 };
        yourself.
    result := visitor visit: node.
    
    self assert: result type: PPCRecognizingSequenceNode.
    self assert: result firstChild = letterNode1.
    self assert: result secondChild = letterNode2.
!

testStarMessagePredicate
    | starNode |
    starNode := PPCStarMessagePredicateNode new
        message: #isLetter;
        child: PPCSentinelNode instance;
        yourself.
    
    node := PPCTokenNode new
        child: starNode;
        yourself.
    
    result := visitor visit: node.
    
    self assert: result type: PPCTokenStarMessagePredicateNode.
!

testStarMessagePredicate2
    | starNode |
    starNode := PPCStarMessagePredicateNode new
        message: #isSeparator;
        child: PPCSentinelNode instance;
        yourself.
    
    node := PPCTokenNode new
        child: starNode;
        yourself.
    
    result := visitor visit: node.
    
    self assert: result type: PPCTokenStarSeparatorNode.
!

testToken
    | letterNode |
    letterNode := PPCMessagePredicateNode new
        message: #isLetter;
        yourself.
    
    node := PPCTokenNode new
        child: letterNode;
        yourself.
        
    result := visitor visit: node.
    self assert: result type: PPCMessagePredicateNode.
    self assert: result = letterNode.
!

testTrimmingToken
    | letterNode tokenNode whitespaceNode |
    letterNode := PPCMessagePredicateNode new
        message: #isLetter;
        yourself.
    
    tokenNode := PPCTokenNode new
        child: letterNode;
        yourself.
    
    whitespaceNode := PPCActionNode new
        block: #foo;
        child: letterNode;	
            yourself.
        
    node := PPCTrimmingTokenNode new
        child: tokenNode;
        whitespace: whitespaceNode;
        yourself.
        
    result := visitor visit: node.
    self assert: result type: PPCTrimmingTokenNode.
    self assert: result child type: PPCMessagePredicateNode.
    self assert: result child = letterNode.
    self assert: result whitespace type: PPCMessagePredicateNode.
    self assert: result whitespace = letterNode.
! !

!PPCRecognizerComponentVisitorTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

