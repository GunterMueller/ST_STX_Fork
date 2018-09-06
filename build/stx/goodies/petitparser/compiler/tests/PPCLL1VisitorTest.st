"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCLL1VisitorTest
	instanceVariableNames:'node result visitor'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Visitors'
!


!PPCLL1VisitorTest methodsFor:'as yet unclassified'!

setUp
    visitor := PPCLL1Visitor new.
! !

!PPCLL1VisitorTest methodsFor:'testing'!

assert: object type: class
    self assert: object class == class
!

literalToken: literal
    | literalNode |
    literalNode := PPCLiteralNode new
        literal: literal;
        yourself.
        
    ^ PPCTokenNode new
        child: literalNode;
        yourself
!

testChoiceIsDeterministic
    |   tokenNode1 tokenNode2 literalNode1 literalNode2 |
    literalNode1 := PPCLiteralNode new
        literal: 'foo';
        yourself.	
    literalNode2 := PPCLiteralNode new
        literal: 'bar';
        yourself.	
    tokenNode1 := PPCTokenNode new
        child: literalNode1;
        yourself.
    tokenNode2 := PPCTokenNode new
        child: literalNode2;
        yourself.

    node := PPCChoiceNode new
        children: { tokenNode1 . literalNode1 };
        yourself.	
    self assert: (visitor isDeterministicChoice: node) not.	

    node := PPCChoiceNode new
        children: { tokenNode1 . tokenNode2  };
        yourself.	
    self assert: (visitor isDeterministicChoice: node).	
!

testChoiceIsDeterministic2
    | literalNode tokenNode |
    literalNode := PPCLiteralNode new
        literal: 'foo';
        yourself.	
    tokenNode := PPCTrimmingTokenNode new
        child: literalNode;
        whitespace: PPCSentinelNode new;
        yourself.

    node := PPCChoiceNode new
        children: { tokenNode . literalNode  };
        yourself.	
    self assert: (visitor isDeterministicChoice: node) not.	

    node := PPCChoiceNode new
        children: { tokenNode . tokenNode  };
        yourself.	
    self assert: (visitor isDeterministicChoice: node) not.	
!

testDeterministicChoice1
    | token1 token2 |
    token1 := self literalToken: 'foo'.
    token2 := self literalToken: 'bar'.
    
    node := PPCChoiceNode new
        children: { token1 . token2 }.
        
    result := visitor visit: node.
    
    self assert: result type: PPCDeterministicChoiceNode.
    self assert: result firstChild = token1.
    self assert: result secondChild = token2.
!

testStartsWithToken
    | literalNode tokenNode |
    literalNode := PPCLiteralNode new
        literal: 'foo';
        yourself.	
    tokenNode := PPCTokenNode new
        child: literalNode;
        yourself.

    self assert: (visitor startsWithToken: literalNode) not.
    self assert: (visitor startsWithToken: tokenNode).
    
!

testStartsWithToken2
    | literalNode tokenNode |
    literalNode := PPCLiteralNode new
        literal: 'foo';
        yourself.	
    tokenNode := PPCTokenNode new
        child: literalNode;
        yourself.
    
    self assert: (visitor startsWithToken: (PPCTrimNode new child: literalNode)) not.
    self assert: (visitor startsWithToken: (PPCTrimNode new child: tokenNode)) not.
    
!

testStartsWithToken3
    | literalNode tokenNode ws |
    literalNode := PPCLiteralNode new
        literal: 'foo';
        yourself.	
    tokenNode := PPCTokenNode new
        child: literalNode;
        yourself.
    ws := PPCStarNode new
        child: PPCSentinelNode new;
        yourself.
    
    self assert: (visitor startsWithToken: (PPCTrimmingTokenNode new child: literalNode; whitespace: ws; yourself)).
    self assert: (visitor startsWithToken: (PPCTrimmingTokenNode new child: tokenNode; whitespace: ws; yourself)).
    
! !

!PPCLL1VisitorTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

