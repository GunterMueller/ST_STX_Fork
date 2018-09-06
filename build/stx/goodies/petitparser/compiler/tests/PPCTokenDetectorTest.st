"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCTokenDetectorTest
	instanceVariableNames:'node result visitor'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Visitors'
!


!PPCTokenDetectorTest methodsFor:'as yet unclassified'!

assert: object type: class
    self assert: object class == class
!

setUp
    visitor := PPCTokenDetector new.
!

testNestedTrimmingTokenJava
    |  trueToken falseToken booleanLiteral literal abc notBoolean id idSeq javaToken resultId resultBooleanLiteral resultIdBooleanLiteral |
    "
     This USE case is based on JavaToken
    
     javaToken := id / literal
     id := (not booleanLiteral, 'abc') token
     literal := booleanLiteral
     booleanLiteral := 'true' token / 'false' token
    "
    trueToken := 'true' asParser token asCompilerTree.
    falseToken := 'false' asParser token asCompilerTree.
    abc := 'abc' asParser asCompilerTree.
    
    booleanLiteral := PPCChoiceNode new
        children: { trueToken . falseToken }; yourself.

    literal := PPCForwardNode new
        name: #literal;
        child: booleanLiteral; yourself.
    notBoolean := PPCNotNode new
        child: booleanLiteral; yourself.
    idSeq := PPCSequenceNode new
        children: { notBoolean . abc }; yourself.
    id := PPCTokenNode new
        child: idSeq; yourself.
    javaToken := PPCChoiceNode new
        children: { id . literal }; yourself.
        
    result := visitor visit: javaToken.	
    resultId := result firstChild.
    resultBooleanLiteral := result secondChild child.	
    resultIdBooleanLiteral := resultId child firstChild  child.	
        
        
        
    self assert: result type: PPCChoiceNode.
    self assert: resultId type: PPCTokenNode.
    self assert: resultBooleanLiteral type: PPCChoiceNode.
    
    self assert: resultIdBooleanLiteral firstChild type: PPCLiteralNode.
    self assert: resultIdBooleanLiteral secondChild type: PPCLiteralNode.
    
    self assert: resultBooleanLiteral firstChild type: PPCTokenNode.
    self assert: resultBooleanLiteral secondChild type: PPCTokenNode.
    
    
!

testToken
    | characterNode token |
    characterNode := PPCCharacterNode new.
    token := PPCTokenNode new 
        child: characterNode;
        tokenClass: #foo;
        yourself.
    node := PPCForwardNode new
        child: token;
        yourself.	
        
    result := visitor visit: node.
    
    self assert: result type: PPCForwardNode.
    self assert: result child type: PPCTokenNode.
    self assert: result child child = characterNode.
!

testToken2
    | characterNode  inToken forwardNode |
    characterNode := PPCCharacterNode new.
    forwardNode := PPCForwardNode new
        child: characterNode;
        yourself.	
    inToken := PPCTokenNode new 
        child: forwardNode;
        tokenClass: #foo;
        name: 'inToken';
        yourself.
    node := PPCTokenNode new
        child: inToken	;
        tokenClass: #bar;
        name: 'token';
        yourself.
        
    result := visitor visit: node.
    
    self assert: result type: PPCTokenNode.
    self assert: result child type: PPCForwardNode.
    self assert: result child name = 'inToken'.
    self assert: result child child = characterNode.
!

testToken3
    | characterNode  inToken forwardNode |
    characterNode := PPCCharacterNode new.
    forwardNode := PPCForwardNode new
        child: characterNode;
        name: 'forward';
        yourself.	
    inToken := PPCTokenNode new 
        child: forwardNode;
        tokenClass: #foo;
        name: 'inToken';
        yourself.
    node := PPCTokenNode new
        child: inToken	;
        tokenClass: #bar;
        name: 'token';
        yourself.
        
    result := visitor visit: node.
    
    self assert: result type: PPCTokenNode.
    self assert: result child type: PPCForwardNode.
    self assert: result child name = 'inToken'.
    self assert: result child child type: PPCForwardNode.
    self assert: result child child name = 'forward'.
    
!

testTrimToken1
    | literalNode tokenNode |
    literalNode := PPCLiteralNode new
        literal: 'foo'.
    tokenNode := PPCTokenNode new
        child: literalNode; 
        tokenClass: #foo;
        yourself.
    node := PPCTrimNode new 
        child: tokenNode;
        yourself.

    result := visitor visit: node.
    
    self assert: result type: PPCTrimmingTokenNode.
    self assert: result whitespace type: PPCStarNode.
    self assert: result tokenClass = #foo.
    
    self assert: result child type: PPCLiteralNode.
    self assert: result child literal = 'foo'.
!

testTrimmingToken
    | seq characterNode ws token |
    characterNode := PPCCharacterNode new.
    token := PPCTokenNode new 
        child: characterNode;
        tokenClass: #foo;
        yourself.
    ws := PPCSentinelNode new.
    
    seq := PPCSequenceNode new
        children: { ws . token . ws };
        yourself.
    node := PPCActionNode new
        child: seq;
        propertyAt: #trimmingToken put: true;
        yourself.
        
    result := visitor visit: node.
    
    self assert: result type: PPCTrimmingTokenNode.
    self assert: result child type: PPCCharacterNode.
    self assert: result child = characterNode.
    self assert: result whitespace type: PPCSentinelNode.
!

testTrimmingToken2
    | seq characterNode ws token tokenIn |
    characterNode := PPCCharacterNode new.
    tokenIn := PPCTokenNode new 
        child: characterNode;
        tokenClass: #foo;
        yourself.
    token := PPCTokenNode new
        child: tokenIn;
        tokenClass: #bar;
        yourself.
    ws := PPCSentinelNode new.
    
    seq := PPCSequenceNode new
        children: { ws . token . ws };
        yourself.
    node := PPCActionNode new
        child: seq;
        propertyAt: #trimmingToken put: true;
        yourself.
        
    result := visitor visit: node.
    
    self assert: result type: PPCTrimmingTokenNode.
    self assert: result child type: PPCCharacterNode.
    self assert: result child = characterNode.
    self assert: result whitespace type: PPCSentinelNode.
! !

!PPCTokenDetectorTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

