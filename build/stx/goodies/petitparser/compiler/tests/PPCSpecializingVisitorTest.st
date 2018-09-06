"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCSpecializingVisitorTest
	instanceVariableNames:'node result visitor'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Visitors'
!


!PPCSpecializingVisitorTest methodsFor:'as yet unclassified'!

asNode: aPPParser
    ^ aPPParser asCompilerTree
!

assert: object type: class
    self assert: object class == class
!

setUp
    visitor := PPCSpecializingVisitor new.
!

testAnyPredicate
    node := self asNode: #any asParser.
    result := visitor visit: node.
    
    self assert: result type: PPCAnyNode.
!

testForward1
    | literalNode  |
    literalNode := PPCLiteralNode new
        literal: 'foo'.
    node := PPCForwardNode new 
        child: literalNode;
        yourself.

    result := visitor visit: node.
    
    self assert: result type: PPCLiteralNode.
    self assert: result = literalNode.
!

testForward2
    | literalNode  |
    literalNode := PPCLiteralNode new
        literal: 'foo'.
    node := PPCForwardNode new 
        name: 'foo';
        child: literalNode;
        yourself.

    result := visitor visit: node.
    
    self assert: result type: PPCLiteralNode.
    self assert: result = literalNode.
    self assert: result name = 'foo'.
!

testForward3
    | literalNode  |
    literalNode := PPCLiteralNode new
        name: 'foo';
        literal: 'foo'.
    node := PPCForwardNode new 
        name: 'foo';
        child: literalNode;
        yourself.

    result := visitor visit: node.
    
    self assert: result type: PPCLiteralNode.
    self assert: result = literalNode.
    self assert: result name = 'foo'.
!

testForward4
    | literalNode  |
    literalNode := PPCLiteralNode new
        name: 'bar';
        literal: 'foo'.
    node := PPCForwardNode new 
        name: 'foo';
        child: literalNode;
        yourself.

    result := visitor visit: node.
    
    self assert: result type: PPCForwardNode.
    self assert: result = node.
    self assert: result name = 'foo'.
!

testForward5
    | literalNode  |
    literalNode := PPCLiteralNode new
        name: 'foo';
        literal: 'foo'.
    node := PPCForwardNode new 
        child: literalNode;
        yourself.

    result := visitor visit: node.
    
    self assert: result type: PPCLiteralNode.
    self assert: result = literalNode.
    self assert: result name = 'foo'.
!

testIdentity
    | token star1 star2 |
    token := $a asParser token.
    star1 :=  token star.
    star2 := token star.
    node := self asNode: star1, star2.
    result := visitor visit: node.
    
    self assert: result type: PPCSequenceNode.
    self assert: result children first type: PPCStarNode.
    self assert: result children second type: PPCStarNode.	
!

testNoOptimization
    node := self asNode: 'foo' asParser.
    self assert: node type: PPCLiteralNode.

    result := visitor visit: node.
    self assert: result type: PPCLiteralNode.
!

testNotCharSet
    node := self asNode: #hex asParser not.
    result := visitor visit: node.
    
    self assert: result type: PPCNotCharSetPredicateNode.
!

testNotCharacter
    node := self asNode: $: asParser not.
    result := visitor visit: node.
    
    self assert: result type: PPCNotCharacterNode.
    self assert: result character = $:.
!

testNotLiteral
    node := self asNode: 'foo' asParser not.
    result := visitor visit: node.
    
    self assert: result type: PPCNotLiteralNode.
    self assert: result literal = 'foo'.
!

testNotMessagePredicate
    node := self asNode: #letter asParser not.
    result := visitor visit: node.
    
    self assert: result type: PPCNotMessagePredicateNode.
!

testPredicateNode01
    node := self asNode: #letter asParser.
    result := visitor visit: node.
    
    self assert: result type: PPCMessagePredicateNode.
    self assert: result message = #isLetter.
!

testPredicateNode02
    node := self asNode: #digit asParser.
    result := visitor visit: node.
    
    self assert: result type: PPCMessagePredicateNode.
    self assert: result message = #isDigit.
!

testPredicateNode03
    node := self asNode: #space asParser.
    result := visitor visit: node.
    
    self assert: result type: PPCMessagePredicateNode.
    self assert: result message = #isSeparator.
!

testPredicateNode04
    node := self asNode: #word asParser.
    result := visitor visit: node.
    
    self assert: result type: PPCMessagePredicateNode.
    self assert: result message = #isAlphaNumeric.
!

testPredicateNode05
    node := self asNode: #hex asParser.
    result := visitor visit: node.
    
    self assert: result type: PPCCharSetPredicateNode.
!

testStarNode1
    node := self asNode: #letter asParser star.
    result := visitor visit: node.
    
    self assert: result type: PPCStarMessagePredicateNode.
    self assert: result message = #isLetter.
!

testStarNode2
    node := self asNode: #any asParser star.
    result := visitor visit: node.
    
    self assert: result type: PPCStarAnyNode.
!

testStarNode3
    node := self asNode: #hex asParser star.
    result := visitor visit: node.
    
    self assert: result type: PPCStarCharSetPredicateNode.
!

testStarNode4
    node := self asNode: #letter asParser not star.
    result := visitor visit: node.
    
    self assert: result type: PPCStarNode.
    self assert: result child type: PPCNotMessagePredicateNode.
!

testStarNode5
    | star |
    star := $a asParser not star.
    node := self asNode: star, star.
    result := visitor visit: node.
    
    self assert: result type: PPCSequenceNode.
    self assert: result children first type: PPCStarNode.
    self assert: result children second type: PPCStarNode.	
!

testTrimNode1
    | literalNode  |
    literalNode := PPCLiteralNode new
        literal: 'foo'.
    node := PPCTrimNode new 
        child: literalNode;
        yourself.

    result := visitor visit: node.
    
    self assert: result type: PPCTrimNode.
    self assert: result trimmer type: PPCStarMessagePredicateNode.
    self assert: result trimmer message = #isSeparator.
    
    self assert: result child type: PPCLiteralNode.
    self assert: result child literal = 'foo'.
! !

!PPCSpecializingVisitorTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

