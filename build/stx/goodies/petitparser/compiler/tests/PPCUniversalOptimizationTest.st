"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCUniversalOptimizationTest
	instanceVariableNames:'compiler'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Core-Universal'
!

!PPCUniversalOptimizationTest methodsFor:'test support'!

assert: object type: class
    self assert: (object isKindOf: class)
!

optimize: aPPParser
    ^ compiler compile: aPPParser

    "Modified: / 07-09-2015 / 12:38:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setUp
    super setUp.
    compiler := PPCCompiler new.
    (compiler context options)
        generate:false;
        tokenize:false.

    "Modified: / 04-09-2015 / 16:21:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCUniversalOptimizationTest methodsFor:'tests'!

testAnyPredicate
    | tree |
    tree := self optimize: #any asParser.
    
    self assert: tree type: PPCAnyNode.
!

testCharSetPredicate
    | tree |
    tree := self optimize: (PPPredicateObjectParser on: [:each | each = $b or: [each = $c] ] message: #foo).

    self assert: tree type: PPCCharSetPredicateNode
!

testChoiceInlining
    | tree |
    tree := self optimize: $a asParser  / $b asParser.

    self assert: tree type: PPCChoiceNode.
    self assert: tree children first  type: PPCCharacterNode.
    self assert: tree children first isMarkedForInline.
    self assert: tree children second type: PPCCharacterNode.
    self assert: tree children first isMarkedForInline.
    
!

testForwarding
    | tree p1 p2 |
    p2 := $a asParser.
    p1 := p2 wrapped.
    p1 name: 'p1'.
    tree := self optimize: p1.

    self assert: tree type: PPCCharacterNode.
    self assert: tree name = 'p1'.
    
    p2 name: 'p2'.
    tree := self optimize: p1.
    self assert: tree type: PPCForwardNode.
    self assert: tree name = 'p1'.
    self assert: tree child name = 'p2'.
!

testInlineCharacter
    | tree |
    tree := self optimize: $a asParser plus.

    self assert: tree type: PPCPlusNode.
    self assert: tree child type: PPCCharacterNode.
    self assert: tree child isMarkedForInline.
    self assert: tree child character = $a.
!

testInlineCharacter2
    | tree |
    tree := self optimize: $a asParser star.

    self assert: tree type: PPCStarNode.
    self assert: tree child type: PPCCharacterNode.
    self assert: tree child isMarkedForInline.
    self assert: tree child character = $a.
!

testInlineCharacter3
    | tree |
    tree := self optimize: $a asParser, $b asParser.

    self assert: tree type: PPCSequenceNode.
    self assert: tree children first type: PPCCharacterNode.
    self assert: tree children first isMarkedForInline.
    self assert: tree children first character = $a.
    self assert: tree children second type: PPCCharacterNode.
    self assert: tree children second isMarkedForInline.
    self assert: tree children second character = $b.	
!

testInlineNil
    | tree |
    tree := self optimize: nil asParser star.

    self assert: tree type: PPCStarNode.
    self assert: tree child type: PPCNilNode.
    self assert: tree child isMarkedForInline.
!

testInlineNotLiteral
    | tree |
    tree := self optimize: 'foo' asParser not star.

    self assert: tree type: PPCStarNode.
    self assert: tree child type: PPCNotLiteralNode.
    self assert: tree child literal = 'foo'.
    self assert: tree child isMarkedForInline.
!

testInlineNotPredicate
    | tree |
    tree := self optimize: (#letter asParser not, (PPPredicateObjectParser on: [ :e | e = $a or: [  e = $b ]] message: #foo) not).

    self assert: tree type: PPCSequenceNode.
    self assert: tree children first type: PPCNotMessagePredicateNode.
    self assert: tree children first isMarkedForInline.
    self assert: tree children second type: PPCNotCharSetPredicateNode.
    self assert: tree children second isMarkedForInline.
    
!

testInlinePluggable
    | tree |
    tree := self optimize: [:ctx | nil] asParser star.

    ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) 
        ifTrue:[ self skipIf: true description: 'not supported in St/X' ].

    self assert: tree type: PPCStarNode.
    self assert: tree child type: PPCPluggableNode.
    self assert: tree child isMarkedForInline.

    "Modified: / 10-05-2015 / 07:30:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testInlinePredicate
    | tree |
    tree := self optimize: (#letter asParser, (PPPredicateObjectParser on: [ :e | e = $a or: [  e = $b ]] message: #foo)).

    self assert: tree type: PPCSequenceNode.
    self assert: tree children first type: PPCMessagePredicateNode.
    self assert: tree children first isMarkedForInline.
    self assert: tree children second type: PPCCharSetPredicateNode.
    self assert: tree children second isMarkedForInline.
    
!

testLetterPredicate
    | tree |
    tree := self optimize: #letter asParser.

    self assert: tree type: PPCMessagePredicateNode.
    self assert: tree message = #isLetter.
!

testNotAction
    | tree |
    tree := self optimize: (($f asParser, $o asParser) ==> #second) not.

    self assert: tree type: PPCNotNode.
    self assert: tree child type: PPCRecognizingSequenceNode.
!

testNotCharSetPredicate
    | tree |
    tree := self optimize: (PPPredicateObjectParser on: [:each | each = $b or: [each = $c] ] message: #foo) asParser not.

    self assert: tree type: PPCNotCharSetPredicateNode.
!

testNotLiteral
    | tree |
    tree := self optimize: 'foo' asParser not.

    self assert: tree type: PPCNotLiteralNode.
    self assert: tree literal = 'foo'.
!

testNotMessagePredicate
    | tree |
    tree := self optimize: #letter asParser not.

    self assert: tree type: PPCNotMessagePredicateNode.
!

testNotSequence
    | tree |
    tree := self optimize: ($f asParser, $o asParser) not.

    self assert: tree type: PPCNotNode.
    self assert: tree child type: PPCRecognizingSequenceNode.
!

testRecognizingSequence2
    | tree |
    tree := self optimize: ($a asParser, $b asParser) token.

    self assert: tree type: PPCTokenNode.
    self assert: tree child type: PPCRecognizingSequenceNode.
    
    tree := self optimize: ($a asParser, $b asParser) trimmingToken.

    self assert: tree type: PPCTrimmingTokenNode.
    self assert: tree child type: PPCRecognizingSequenceNode.
!

testStarAny
    | tree |
    tree := self optimize: #any asParser star.

    self assert: tree type: PPCStarAnyNode.
!

testStarCharSetPredicate
    | tree |
    tree := self optimize: (PPPredicateObjectParser on: [:each | each = $b or: [each = $c] ] message: #foo) star.

    self assert: tree type: PPCStarCharSetPredicateNode
!

testStarMessagePredicate
    | tree |
    tree := self optimize: #letter asParser star.

    self assert: tree type: PPCStarMessagePredicateNode.
!

testStarSeparator
    | tree |
    tree := self optimize: #space asParser star trimmingToken.

    self assert: tree type: PPCTrimmingTokenNode.
    self assert: tree child type: PPCTokenStarSeparatorNode.
!

testStarSeparator2
    | tree |
    tree := self optimize: (#space asParser star, 'whatever' asParser) trimmingToken.

    self assert: tree type: PPCTrimmingTokenNode.
    self assert: tree child type: PPCRecognizingSequenceNode.
    self assert: tree child children first type: PPCTokenStarSeparatorNode.
    self assert: tree child children first isMarkedForInline.
!

testSymbolAction
    | tree |
    tree := self optimize: (#letter asParser) ==> #second.

    self assert: tree type: PPCSymbolActionNode.

    tree := self optimize: (#letter asParser) ==> [:e | e second ].
    self assert: tree type: PPCActionNode.
!

testToken
    | tree |
    tree := self optimize: ((#letter asParser, #word asParser star) token).

    self assert: tree type: PPCTokenNode.
    self assert: tree child type: PPCRecognizingSequenceNode.
    self assert: tree child children size = 2.
    self assert: tree child children first type: PPCMessagePredicateNode.
    self assert: tree child children first isMarkedForInline.
    self assert: tree child children second type: PPCTokenStarMessagePredicateNode.	
    self assert: tree child children second isMarkedForInline.
    
!

testTrimmingToken
    | tree |
    tree := self optimize: ((#letter asParser, #word asParser star) trimmingToken).

    self assert: tree type: PPCTrimmingTokenNode.
    self assert: tree whitespace type: PPCTokenStarSeparatorNode.
    self assert: tree whitespace isMarkedForInline.
    
    self assert: tree child type: PPCRecognizingSequenceNode.
    self assert: tree child children size = 2.
    self assert: tree child children first type: PPCMessagePredicateNode.
    self assert: tree child children first isMarkedForInline.
    self assert: tree child children second type: PPCTokenStarMessagePredicateNode.	
    self assert: tree child children first isMarkedForInline.
!

testTrimmingToken2
    | parser tree |
    parser := 'foo' asParser trimmingToken.
    tree := self optimize: parser.
    
    self assert: tree type: PPCTrimmingTokenNode.
    self assert: tree child type: PPCLiteralNode.
    self assert: tree child isMarkedForInline.
    self assert: (tree whitespace allNodes allSatisfy: [ :n | n isKindOf: PPCNode ]).

    parser := ('foo' asParser, $b asParser) trimmingToken.
    tree := self optimize: parser.
    
    self assert: tree type: PPCTrimmingTokenNode.
    self assert: tree child type: PPCRecognizingSequenceNode.
    self assert: tree whitespace type: PPCTokenStarSeparatorNode.
    self assert: tree whitespace isMarkedForInline.
    
    parser := $d asParser trimmingToken star.
    tree := self optimize: parser.
    
    self assert: tree type: PPCStarNode.
    self assert: tree child type: PPCTrimmingTokenNode.
    self assert: tree child child type: PPCCharacterNode.
    self assert: tree child child isMarkedForInline.
!

testTrimmingToken3
    | parser tree |
    parser := ('foo' asParser trimmingToken name: 'foo'), ('bar' asParser trimmingToken name: 'bar').
    tree := self optimize: parser.
    
    self assert: tree type: PPCSequenceNode.
    self assert: tree children first type: PPCTrimmingTokenNode.
    self assert: tree children second type: PPCTrimmingTokenNode.
!

testTrimmingTokenNested
    | parser tree foo|
    foo := 'foo' asParser trimmingToken name: 'foo'.
    parser := (foo not, 'bar' asParser) trimmingToken name: 'token'.
    tree := self optimize: parser.
    
    self assert: tree type: PPCTrimmingTokenNode.
    self assert: tree children second type: PPCRecognizingSequenceNode.
    self assert: tree children second children first type: PPCNotLiteralNode.
    self assert: tree children second children first isMarkedForInline.
! !

