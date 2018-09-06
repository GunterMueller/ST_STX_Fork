"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCNodeTest
	instanceVariableNames:'node compiler'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Nodes'
!


!PPCNodeTest methodsFor:'as yet unclassified'!

testAllNodesDo1
    | node1 node2 parser allChildren |
    node1 := #letter asParser asCompilerNode.
    node2 := #letter asParser asCompilerNode.
    parser := PPChoiceParser new
        setParsers: { node1 . node2 };
        yourself. 
        
    node := PPCUnknownNode new
        parser: parser;
        yourself.

    self assert: node parser children first == node1.
    self assert: node parser children second == node2.	

    allChildren := OrderedCollection new.
    node allNodesDo: [ :e |
        allChildren add: e.
    ].
    self assert: allChildren size = 3.
    
!

testCopy
    | newNode |
    node := PPCDelegateNode new
        child: #foo;
        yourself.
    newNode := node copy.
    self assert: (node = newNode).
    self assert: (node hash = newNode hash).
    
    newNode child: #bar.
    self assert: (node = newNode) not.
!

testCopy2
    |  newNode |
    node := PPCSequenceNode new
        children: { #foo . #bar }
        yourself.
    newNode := node copy.

    self assert: (node = newNode).
    self assert: (node hash = newNode hash).
    
    node children at: 1 put: #zorg.
    self assert: (node = newNode) not.
!

testCopy3
    | newNode |
    node := PPCMessagePredicateNode new
        predicate: #block;
        message: #message;
        yourself.
        
    newNode := node copy.
    
    self assert: (node == newNode) not.
    self assert: (node = newNode).
    self assert: node hash = newNode hash.
!

testCopy4
    | node1 node2 |
    node1 := #letter asParser asCompilerNode.
    node2 := #letter asParser asCompilerNode.
    
    self assert: (node == node2) not.
    self assert: (node1 = node2).
    self assert: node1 hash = node2 hash.
!

testCopy5
    | node1 newNode |
    node1 := #letter asParser asCompilerNode.

    node := PPCUnknownNode new
        parser: node1;
        yourself.

    self assert: node parser == node1.
    newNode := node copy.
    self assert: (newNode parser == node1) not.	
    self assert: newNode parser = node1.	
!

testEquals
    self assert: (PPCNode new = PPCNode new).
!

testEquals2
    | n1 n2 n3 |
    n1 := PPCDelegateNode new
        child: #foo;
        yourself.
    n2 := PPCDelegateNode new
        child: #bar;
        yourself.
    n3 := PPCDelegateNode new
        child: #foo;
        yourself.
        
    self assert: (n1 = n3).
    self assert: (n1 = n2) not.
!

testReplaceNode
    | literalNode anotherLiteralNode |
    literalNode := PPCLiteralNode new
        literal: 'foo';
        yourself.
        
    anotherLiteralNode := PPCLiteralNode new
        literal: 'bar';
        yourself.
        
    node := PPCForwardNode new
        child: literalNode;
        yourself.
    
    self assert: node child == literalNode.
    node replace: literalNode with: anotherLiteralNode.
    self assert: node child == anotherLiteralNode.
    self assert: (node child == literalNode) not.
! !

!PPCNodeTest methodsFor:'test support'!

assert: object type: class
    self assert: object class == class
!

setUp
    compiler := PPCCompiler new.
    compiler context options generate:false.

    "Modified: / 07-09-2015 / 11:38:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

treeFrom: parser
    ^ compiler compile: parser

    "Modified: / 07-09-2015 / 10:06:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCNodeTest methodsFor:'tests - converting'!

testConvertBlock
    | parser tree |
    parser := [ :ctx | [ctx atEnd] whileFalse ] asParser.
    tree := parser asCompilerTree.
    
    self assert: tree type: PPCPluggableNode.
        ((Smalltalk respondsTo: #isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifFalse:[  
    self assert: tree block asString = '[ :ctx | [ ctx atEnd ] whileFalse ]'.
        ]

    "Modified: / 05-05-2015 / 16:24:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testConvertChoice
    | parser tree |
    parser := 'foo' asParser / $b asParser.
    tree := parser asCompilerTree.
    
    self assert: tree type: PPCChoiceNode.
    self assert: tree children size = 2.
    self assert: tree children first type: PPCLiteralNode.
    self assert: tree children second type: PPCCharacterNode.
!

testConvertNil
    | parser tree |
    parser := nil asParser.
    tree := parser asCompilerTree.
    
    self assert: tree type: PPCNilNode.
!

testConvertSequence
    | parser tree |
    parser := 'foo' asParser, $b asParser.
    tree := parser asCompilerTree.
    
    self assert: tree type: PPCSequenceNode.
    self assert: tree children size = 2.
    self assert: tree children first type: PPCLiteralNode.
    self assert: tree children second type: PPCCharacterNode.
!

testConvertToken
    | parser tree |
    parser := 'foo' asParser token.
    tree := parser asCompilerTree.
    
    self assert: tree type: PPCTokenNode.
    self assert: tree child type: PPCLiteralNode.

    parser := ('foo' asParser, $b asParser) token.
    tree := parser asCompilerTree.
    
    self assert: tree type: PPCTokenNode.
    self assert: tree child type: PPCSequenceNode.
    
    parser := $d asParser token star.
    tree := parser asCompilerTree.
    
    self assert: tree type: PPCStarNode.
    self assert: tree child type: PPCTokenNode.
    self assert: tree child child type: PPCCharacterNode.
!

testConvertTrimmingToken
    | parser tree |
    parser := 'foo' asParser trimmingToken.
    tree := self treeFrom: parser.
    
    self assert: tree type: PPCTrimmingTokenNode.
    self assert: tree child type: PPCLiteralNode.
    self assert: tree child isMarkedForInline.
    self assert: (tree whitespace allNodes allSatisfy: [ :n | n isKindOf: PPCNode ]).
!

testConvertTrimmingToken2
    | parser tree |
    parser := ('foo' asParser, $b asParser) trimmingToken.
    tree := self treeFrom: parser.
    
    self assert: tree type: PPCTrimmingTokenNode.
    self assert: tree child type: PPCRecognizingSequenceNode.
    self assert: tree whitespace type: PPCTokenStarSeparatorNode.
    self assert: tree whitespace isMarkedForInline.
!

testConvertTrimmingToken3
    | parser tree |
    
    parser := 'foo' asParser trimmingToken star.
    tree := self treeFrom: parser.
    
    self assert: tree type: PPCStarNode.
    self assert: tree child type: PPCTrimmingTokenNode.
    self assert: tree child child type: PPCLiteralNode.	
    self assert: tree child child isMarkedForInline.
!

testConvertTrimmingToken4
    | parser tree |
    
    parser := $d asParser trimmingToken star.
    tree := self treeFrom: parser.
    
    self assert: tree type: PPCStarNode.
    self assert: tree child type: PPCTrimmingCharacterTokenNode.
    self assert: tree child isMarkedForInline not.
! !

!PPCNodeTest methodsFor:'tests - epsilon'!

testActionAcceptsEpsilon
    | tree |
    tree := ('foo' asParser token optional ==> [ :e | e ]) asCompilerTree.
    self assert: tree acceptsEpsilon.
!

testChoiceAcceptsEpsilon
    | tree |
    tree := ($a asParser / $b asParser star) asCompilerTree.
    self assert: tree acceptsEpsilon.
!

testLiteralAcceptsEpsilon
    | tree |
    tree := 'foo' asParser asCompilerTree.
    self assert: tree acceptsEpsilon not.
    
    tree := '' asParser asCompilerTree.
    self assert: tree acceptsEpsilon.
!

testPlusAcceptsEpsilon
    | tree |
    tree := ($b asParser plus) asCompilerTree.
    self assert: tree acceptsEpsilon not.
    
    tree := #letter asParser plus asCompilerTree.
    self assert: tree acceptsEpsilon not.
!

testSequenceAcceptsEpsilon
    | tree parser |
    parser := 'foo' asParser token optional, 'bar' asParser token star, ($a asParser / $b asParser star).
    tree := parser asCompilerTree.
    self assert: tree acceptsEpsilon.
!

testStarAcceptsEpsilon
    | tree |
    tree := $b asParser star asCompilerTree.
    self assert: tree acceptsEpsilon.
!

testTokenAcceptsEpsilon
    | tree |
    tree := ($a asParser / $b asParser plus) token asCompilerTree.
    self assert: tree acceptsEpsilon not.
    
    tree := ($a asParser / $b asParser star) token asCompilerTree.
    self assert: tree acceptsEpsilon.
!

testTrimNode
    | tree |
    tree := $a asParser trim asCompilerTree.
    self assert: tree type: PPCTrimNode.
    self assert: tree child type: PPCCharacterNode.
    self assert: tree trimmer type: PPCStarNode.
! !

!PPCNodeTest methodsFor:'tests - recognized sentences'!

assert: array anySatisfy: block
    self assert: (array anySatisfy: block)
!

testOverlapCharacterNode
    |  node1 node2 |
    node1 := $a asParser asCompilerTree.
    node2 := $b asParser asCompilerTree.
            
    self assert: (node1 overlapsWith: node2) not.
!

testOverlapCharacterNode2
    |  node1 node2 |
    node1 := $a asParser asCompilerTree.
    node2 := $a asParser asCompilerTree.
            
    self assert: (node1 overlapsWith: node2).
!

testOverlapNode1
    |  node1 node2 |
    node1 := $a asParser asCompilerTree.
    node2 := $a asParser asCompilerTree.
            
    self assert: (node1 overlapsWith: node2).
!

testOverlapNode2
    |  node1 node2 |
    node1 := $a asParser asCompilerTree.
    node2 := 'a' asParser asCompilerTree.
            
    self assert: (node1 overlapsWith: node2).
!

testOverlapNode3
    |  node1 node2 |
    node1 := ($a asParser / $b asParser) asCompilerTree.
    node2 := ('c' asParser / 'd' asParser) asCompilerTree.
            
    self assert: (node1 overlapsWith: node2) not.
!

testOverlapNode4
    |  node1 node2 |
    node1 := ($a asParser / $b asParser) asCompilerTree.
    node2 := ('c' asParser / #any asParser) asCompilerTree.
            
    self assert: (node1 overlapsWith: node2).
!

testOverlapNode5
    |  node1 node2 |
    node1 := ($a asParser, $b asParser) asCompilerTree.
    node2 := ('ab' asParser) asCompilerTree.
            
    self assert: (node1 overlapsWith: node2).
!

testOverlapNode6
    |  node1 node2 |
    node1 := ($a asParser, $b asParser, $c asParser) asCompilerTree.
    node2 := ('ab' asParser) asCompilerTree.
            
    self flag: 'Not sure about this test...'.
    self assert: (node1 overlapsWith: node2) not.
!

testOverlapNode7
    |  node1 node2 |
    node1 := ($a asParser) asCompilerTree.
    node2 := (#digit asParser) asCompilerTree.
            
    self assert: (node1 overlapsWith: node2) not.
!

testOverlapNode8
    |  node1 node2 |
    node1 := ($a asParser) asCompilerTree.
    node2 := (#digit asParser plus) asCompilerTree.
            
    self assert: (node1 overlapsWith: node2) not.
!

testOverlapNode9
    |  node1 node2 |
    node1 := ($a asParser) asCompilerTree.
    node2 := (#letter asParser plus) asCompilerTree.
            
    self assert: (node1 overlapsWith: node2).
!

testOverlapTokenNode
    |  node1 node2 |
    node1 := $a asParser token asCompilerTree.
    node2 := $b asParser token asCompilerTree.
            
    self assert: (node1 overlapsWith: node2) not.
!

testOverlapTokenNode2
    |  node1 node2 |
    node1 := $a asParser token asCompilerTree.
    node2 := $a asParser token asCompilerTree.
            
    self assert: (node1 overlapsWith: node2).
!

testOverlapTrimmingTokenNode
    |  node1 node2 |
    node1 := $a asParser token trim asCompilerTree.
    node2 := $b asParser token trim asCompilerTree.
            
    self assert: (node1 overlapsWith: node2) not.
!

testOverlapTrimmingTokenNode1
    |  node1 node2 |
    node1 := PPCTrimmingTokenNode new
        child: (PPCCharacterNode new character: $a; yourself);
        yourself.
    node2 := PPCTrimmingTokenNode new
        child: (PPCCharacterNode new character: $b; yourself);
        yourself.
            
    self assert: (node1 overlapsWith: node2) not.
!

testOverlapTrimmingTokenNode2
    |  node1 node2 |
    node1 := PPCTrimmingTokenNode new
        child: (PPCCharacterNode new character: $a; yourself);
        yourself.
    node2 := PPCTrimmingTokenNode new
        child: (PPCCharacterNode new character: $a; yourself);
        yourself.
            
    self assert: (node1 overlapsWith: node2).
!

testRSCharacterNode
    | sentences |
    node := PPCCharacterNode new 
        character: $f;
        yourself.
        
    self assert: node hasFiniteLanguage.

    sentences := node recognizedSentences.
    self assert: sentences size = 1.
    self assert: sentences anyOne = 'f'.
!

testRSChoiceNode
    | sentences |
    node := ('a' asParser / 'b' asParser) asCompilerTree.
        
    self assert: node hasFiniteLanguage.
        
    sentences := node recognizedSentences.
    self assert: sentences size = 2.
    self assert: sentences anySatisfy: [ :e | e = 'a' ].
    self assert: sentences anySatisfy: [ :e | e = 'b' ].	
!

testRSChoiceNode2
    | sentences |
    node := ('a' asParser / 'a' asParser) asCompilerTree.
        
    self assert: node hasFiniteLanguage.
        
    sentences := node recognizedSentences.
    self assert: sentences size = 1.
    self assert: sentences anySatisfy: [ :e | e = 'a' ].
!

testRSLiteralNode
    | sentences |
    node := PPCLiteralNode new 
        literal: 'foo';
        yourself.
    self assert: node hasFiniteLanguage.
        
    sentences := node recognizedSentences.
    self assert: sentences size = 1.
    self assert: sentences anyOne = 'foo'.
!

testRSPredicateNode
    | sentences |
    node := PPCPredicateNode new 
        predicate: (PPCharSetPredicate on: [:e | e isDigit]);
        yourself.
        
    self assert: node hasFiniteLanguage.
        
    sentences := node recognizedSentences.
    self assert: sentences size = 10.
    self assert: sentences anySatisfy: [ :e | e = '0' ].
!

testRSSequenceNode
    | sentences |
    node := ('a' asParser, 'b' asParser) asCompilerTree.
        
    self assert: node hasFiniteLanguage.
        
    sentences := node recognizedSentences.
    self assert: sentences size = 1.
    self assert: sentences anySatisfy: [ :e | e = 'ab' ].
!

testRSSequenceNode2
    | sentences |
    node := ('a' asParser, ('b' asParser / 'c' asParser)) asCompilerTree.
        
    self assert: node hasFiniteLanguage.
        
    sentences := node recognizedSentences.
    self assert: sentences size = 2.
    self assert: sentences anySatisfy: [ :e | e = 'ab' ].
    self assert: sentences anySatisfy: [ :e | e = 'ac' ].	
!

testRSSequenceNode3
    | sentences |
    node := (#digit asParser, #digit asParser) asCompilerTree.
        
    self assert: node hasFiniteLanguage.
        
    sentences := node recognizedSentences.
    self assert: sentences size = 100.
    self assert: sentences anySatisfy: [ :e | e = '00' ].
    self assert: sentences anySatisfy: [ :e | e = '99' ].	
    self assert: sentences anySatisfy: [ :e | e = '38' ].
    
! !

!PPCNodeTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

