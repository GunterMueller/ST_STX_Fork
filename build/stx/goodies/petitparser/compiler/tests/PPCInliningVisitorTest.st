"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCInliningVisitorTest
	instanceVariableNames:'node result visitor'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Visitors'
!


!PPCInliningVisitorTest methodsFor:'as yet unclassified'!

assert: object type: class
    self assert: object class == class
!

setUp
    visitor := PPCInliningVisitor new.
!

testCharacterNode
    node := PPCCharacterNode new
        character: $a;
        yourself.
    result := visitor visit: node.
    
    self assert: result type: PPCCharacterNode.
    self assert: result isMarkedForInline not.
    self assert: result character = $a.
!

testCharacterNode2
    | charNode |
    charNode := PPCCharacterNode new
        character: $a;
        yourself.
    node := PPCStarNode new
        child: charNode;
        yourself.
    result := visitor visit: node.
    
    self assert: result child type: PPCCharacterNode.
    self assert: result child isMarkedForInline.
    self assert: result child character = $a.
!

testLiteralNode
    | literalNode |
    literalNode := PPCLiteralNode new
        literal: 'foo';
        yourself.
    node := PPCOptionalNode new
        child: literalNode;
        yourself.

    result := visitor visit: node.
    
    self assert: result child type: PPCLiteralNode.
    self assert: result child isMarkedForInline.
    self assert: result child literal = 'foo'.
!

testNil
    node := PPCNilNode new.
    result := visitor visit: node.

    self assert: result type: PPCNilNode.
    self assert: result isMarkedForInline not.
!

testNil2
    node := PPCStarNode new
        child: PPCNilNode new;
        yourself.
    result := visitor visit: node.

    self assert: result type: PPCStarNode.
    self assert: result child type: PPCNilNode.
    self assert: result child isMarkedForInline.
!

testNotLiteralNode
    | notLiteralNode |

    notLiteralNode := PPCNotLiteralNode new
        literal: 'foo';
        yourself.

    node := PPCOptionalNode new
        child: notLiteralNode;
        yourself.

    result := visitor visit: node.
    
    self assert: result child type: PPCNotLiteralNode.
    self assert: result child isMarkedForInline.
    self assert: result child literal = 'foo'.
!

testPluggable
    | pluggableNode |
    pluggableNode := PPCPluggableNode new
        block: [:ctx | nil] asParser.
    node := PPCSequenceNode new
        children: { pluggableNode  };
        yourself.

    result := visitor visit: node.
        
    ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[  
        self skipIf: true description: 'skipped test, inlining of pluggable nodes not supported!!'.
    ].

    self assert: result children first type: PPCPluggableNode.
    self assert: result children first isMarkedForInline.

    "Modified: / 01-05-2015 / 14:22:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSequenceInline
    | charNode1 charNode2 |
    charNode1 := PPCCharacterNode new
        character: $a;
        yourself.
    charNode2 := PPCCharacterNode new
        character: $b;
        yourself.

    node := PPCSequenceNode new
        children: { charNode1 . charNode2 };
        yourself.
    result := visitor visit: node.
    
    self assert: result type: PPCSequenceNode .
    self assert: result children first type: PPCCharacterNode.
    self assert: result children second type: PPCCharacterNode.	
!

testTokenStarMessagePredicateNode
    | tokenNode |
    tokenNode := (PPCTokenStarMessagePredicateNode new)
        child: PPCSentinelNode new;
        yourself.
    node := PPCForwardNode new
        child: tokenNode;
        yourself.	
    result := visitor visit: node.
    
    self assert: result child type: PPCTokenStarMessagePredicateNode.
    self assert: result child isMarkedForInline.
!

testTokenStarSeparatorNode
    | tokenNode |
    tokenNode := (PPCTokenStarSeparatorNode new)
        name: #name;
        message: #message;
        child: PPCNilNode new;
        yourself.

    node := PPCForwardNode new
        child: tokenNode;
        yourself.	

        
    result := visitor visit: node.
    
    self assert: result child type: PPCTokenStarSeparatorNode.
    self assert: result child isMarkedForInline.
    self assert: result child child type: PPCNilNode.
! !

!PPCInliningVisitorTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

