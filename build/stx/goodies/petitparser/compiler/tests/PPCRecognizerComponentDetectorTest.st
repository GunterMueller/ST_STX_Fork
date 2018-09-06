"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCRecognizerComponentDetectorTest
	instanceVariableNames:'node result visitor'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Visitors'
!

!PPCRecognizerComponentDetectorTest methodsFor:'as yet unclassified'!

assert: object type: class
    self assert: object class == class
!

setUp
    visitor := PPCRecognizerComponentDetector new.
!

testActionNode
    | seq characterNode1 characterNode2 tokenNode |
    characterNode1 := PPCCharacterNode new.
    characterNode2 := PPCCharacterNode new.
    
    seq := PPCSequenceNode new
        children: { characterNode1 . characterNode1 };
        yourself.
    tokenNode := PPCTokenNode new
        child: seq;
        yourself.
        
    node := PPCActionNode new
        child: tokenNode;
        yourself.
    
        
    result := visitor visit: node.
    
    self assert: result type: PPCActionNode.
    self assert: result child type: PPCTokenNode.	
    self assert: result child child type: PPCRecognizingSequenceNode.	

    self assert: result == node.
    self assert: (result child child firstChild == characterNode1) not.
    self assert: (result child child firstChild = characterNode1).
    self assert: (result child child secondChild == characterNode1) not.
    self assert: (result child child secondChild = characterNode1).
    
!

testNestedTrimmingToken
    | characterNode token ws  trimmingToken |
    characterNode := PPCCharacterNode new.
    token := PPCTokenNode new 
        child: characterNode;
        tokenClass: #foo;
        yourself.
    ws := PPCSentinelNode new.
    trimmingToken := PPCTrimmingTokenNode new
        child: token;
        whitespace: ws;
        propertyAt: #trimmingToken put: true;
        yourself.

    node := PPCSequenceNode new
        children: { characterNode . trimmingToken  };
        yourself.
    
    result := visitor visit: node.
    
    self assert: result type: PPCSequenceNode.
    self assert: result firstChild == characterNode.
    
    self assert: result secondChild type: PPCTrimmingTokenNode.	
    self assert: result secondChild child = characterNode.	
    self assert: (result secondChild child == characterNode) not.		
!

testNestedTrimmingToken2
    | characterNode token1 ws   seqWithToken trimmingToken1 token2 |
    characterNode := PPCCharacterNode new.
    ws := PPCSentinelNode new.

    token1 := PPCTokenNode new 
        child: characterNode;
        tokenClass: #foo;
        yourself.
    trimmingToken1 := PPCTrimmingTokenNode  new
        child: token1;
        whitespace: ws;
        propertyAt: #trimmingToken put: true;
        yourself.
    
    seqWithToken := PPCSequenceNode new
        children: { characterNode . trimmingToken1  };
        yourself.
    
    token2 := PPCTokenNode new 
        child: seqWithToken;
        tokenClass: #bar;
        yourself.
    node := PPCTrimmingTokenNode new
        child: token2;
        whitespace: ws;
        propertyAt: #trimmingToken put: true;
        yourself.
    result := visitor visit: node.
    
    self assert: result type: PPCTrimmingTokenNode .
    self assert: result child type: PPCRecognizingSequenceNode.
!

testNodeCopy
    | nilNode forwardNode |
    nilNode := PPCNilNode new.
    forwardNode := PPCForwardNode new
        child: nilNode;
        yourself.
    node := PPCTokenNode new
        child: forwardNode;
        yourself.
    
    result := visitor visit: node.
    
    self assert: (result == node).
    self assert: result child = forwardNode.
    self assert: (result child == forwardNode) not.
    self assert: (result child child = nilNode).
    self assert: (result child child == nilNode) not.
!

testRecognizingSequence1
    | seq characterNode1 characterNode2 |
    characterNode1 := PPCCharacterNode new.
    characterNode2 := PPCCharacterNode new.
    
    seq := PPCSequenceNode new
        children: { characterNode1 . characterNode1 };
        yourself.
    node := PPCTokenNode new
        child: seq;
        yourself.
    
        
    result := visitor visit: node.
    
    self assert: result type: PPCTokenNode.
    self assert: result child type: PPCRecognizingSequenceNode.	

    self assert: result == node.
    self assert: (result child firstChild == characterNode1) not.
    self assert: (result child firstChild = characterNode1).
    self assert: (result child secondChild == characterNode1) not.
    self assert: (result child secondChild = characterNode1).
    
! !

