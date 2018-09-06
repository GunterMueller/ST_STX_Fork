"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCNodeFirstFollowNextTests
	instanceVariableNames:'tree first node followSet compiler'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Nodes'
!

PPCNodeFirstFollowNextTests class instanceVariableNames:'first'

"
 The following class instance variables are inherited by this class:

	TestCase - lastOutcomes
	TestAsserter - 
	Object - 
"
!


!PPCNodeFirstFollowNextTests methodsFor:'setup'!

setUp
    compiler := PPCCompiler new.
    compiler context options generate:false.

    "Modified: / 07-09-2015 / 11:38:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCNodeFirstFollowNextTests methodsFor:'support'!

assert: set anyMatchesType: whatever
    self assert: (set anySatisfy: [:e | e isKindOf: whatever ])
!

assert: set anySatisfy: whateverBlock
    self assert: (set anySatisfy: [:e |  [whateverBlock value: e]  on: Error do: [ false ] ])
!

assert: set noneMatchesType: whatever
    self assert: (set noneSatisfy: [:e | e isKindOf: whatever ])
!

assert: set noneSatisfy: whateverBlock
    self assert: (set noneSatisfy: [:e |  [whateverBlock value: e]  on: Error do: [ false ] ])
!

assert: set size: anInteger
    self assert: (set size = anInteger )
!

first: aNode 
    ^ aNode firstSet
!

first: aNode suchThat: aBlock
    ^ (aNode firstSetsSuchThat: aBlock) at: aNode
!

followOf: name in: rootNode
    node := (rootNode allNodes select: [ :n | n name = name ] )anyOne.
    ^ rootNode followSets at: node
!

followOf: name in: rootNode suchThat: aBlock
    node := (rootNode allNodes select: [ :n | n name = name ] )anyOne.
    ^ (rootNode followSetsSuchThat: aBlock) at: node
!

followOfNodeIn: rootNode
    ^ self followOf: 'node' in: rootNode
!

treeFrom: parser
    ^ compiler compile: parser

    "Modified: / 07-09-2015 / 10:08:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCNodeFirstFollowNextTests methodsFor:'testing - first'!

testFirst1
    tree := self treeFrom: nil asParser / 'a' asParser.
    
    self assert: (self first: tree) anyMatchesType: PPCNilNode.
    self assert: (self first: tree) anyMatchesType: PPCAbstractLiteralNode.
!

testFirst2
    tree := self treeFrom: 'a' asParser optional, 'b' asParser.
    
    self assert: (self first: tree) anySatisfy: [ :e | e literal = 'a' ].
    self assert: (self first: tree) anySatisfy: [ :e | e literal = 'b' ].
!

testFirst3
    tree := ('a' asParser optional, 'b' asParser asParser optional), 'c' asParser.
    
    self assert: (self first: tree) anySatisfy: [ :e | e literal = 'a' ].
    self assert: (self first: tree) anySatisfy: [ :e | e literal = 'b' ].
    self assert: (self first: tree) anySatisfy: [ :e | e literal = 'c' ].
!

testFirstChoice1
    tree := self treeFrom: nil asParser / '' asParser.
    
    self assert: (self first: tree) anySatisfy: [:e | e literal = ''].
    self assert: (self first: tree) anyMatchesType: PPCNilNode.
!

testFirstChoice2
    tree := self treeFrom: 'a' asParser / nil asParser / 'b' asParser.
    
    first := (self first: tree).
    
    self assert: first anySatisfy: [:e | e literal =  'a'].
    self assert: first anySatisfy: [:e | e literal = 'b'].
    self assert: first anyMatchesType: PPCNilNode.
!

testFirstComplex1
    tree := self treeFrom: ('a' asParser / nil asParser), 'c' asParser.
    
    first := (self first: tree).
    
    self assert: first size: 2.
    self assert: first anySatisfy: [:e | e literal = 'a'].
    self assert: first anySatisfy: [:e | e literal = 'c'].
    self assert: first noneMatchesType: PPCNilNode.
!

testFirstComplex2
    tree := self treeFrom: ('a' asParser / nil asParser / 'b' asParser), 'c' asParser.
    
    
    first := (self first: tree).
    
    self assert: first size: 3.
    self assert: first anySatisfy: [:e | e literal = 'a'].
    self assert: first anySatisfy: [:e | e literal = 'b'].
    self assert: first anySatisfy: [:e | e literal = 'c'].
!

testFirstComplex3
    tree := self treeFrom: ('a' asParser / nil asParser / 'b' asParser), 'c' asParser not.
    
    first := (self first: tree).
    
    self assert: first anySatisfy: [:e | e literal = 'a'].
    self assert: first anySatisfy: [:e | e literal = 'b'].
    self assert: first anySatisfy: [:e | (e isKindOf: PPCNotNode) and: [e child literal = 'c']].
!

testFirstComplex4
    tree := self treeFrom: (('a' asParser / nil asParser / 'b' asParser), 'c' asParser not) wrapped.
    
    first := (self first: tree).
    
    self assert: first anySatisfy: [:e | e literal = 'a'].
    self assert: first anySatisfy: [:e | e literal = 'b'].
    self assert: first anySatisfy: [:e | (e isKindOf: PPCNotNode) and: [ e child literal = 'c' ]].
    self assert: first noneMatchesType: PPCNilNode.
!

testFirstNegate1
    compiler removePass: PPCSpecializingVisitor.
    tree := self treeFrom: ('a' asParser negate, 'b' asParser).
    
    first := self first: tree.

    self assert: first size: 1.
    self assert: first anyMatchesType: PPCNotNode.
    self assert: first anyOne child literal = 'a'.

    "Modified: / 04-09-2015 / 14:55:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testFirstNot
    tree := self treeFrom: ('a' asParser not star, 'b' asParser).
    
    first := self first: tree.
        
    self assert: first size: 2.
    self assert: first anyMatchesType: PPCNotNode.
    self assert: first anyMatchesType: PPCLiteralNode.
!

testFirstNot2
    compiler removePass: PPCSpecializingVisitor.
    tree := self treeFrom: (#letter asParser not star, #letter asParser).
    
    first := self first: tree.
        
    self assert: first size: 2.
    self assert: first anyMatchesType: PPCNotNode.
    self assert: first anyMatchesType: PPCPredicateNode.

    "Modified: / 04-09-2015 / 14:55:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testFirstNot4
    tree := self treeFrom: (#letter asParser negate plus, #letter asParser).
    
    first := self first: tree.
        
    self assert: first size: 1.
    self assert: (first anyOne predicate value: $a) not.
    self assert: (first anyOne predicate value: $1).
!

testFirstNot5
    tree := self treeFrom: (#letter asParser negate star, #letter asParser).
    
    first := self first: tree.
        
    self assert: first size: 2.
    self assert: first anySatisfy: [ :e |	(e predicate value: $a) not ].
    self assert: first anySatisfy: [ :e |	(e predicate value: $1) ].


    self assert: first anySatisfy: [ :e |	(e predicate value: $a) ].
    self assert: first anySatisfy: [ :e |	(e predicate value: $1) not ].
!

testFirstOptional
    tree := 'a' asParser optional asCompilerTree.
    
    first := (self first: tree).
    
    self assert: first anyMatchesType: PPCNilNode.
    self assert: first anyMatchesType: PPCLiteralNode.
!

testFirstOptional2
    tree := ('a' asParser optional, 'b' asParser) asCompilerTree.
    
    first := (self first: tree).
    
    self assert: first size: 2.
    self assert: first anySatisfy: [ :e | e literal = 'a' ].
    self assert: first anySatisfy: [ :e | e literal = 'b' ].
!

testFirstRepeat1
    tree := ('a' asParser / nil asParser) plus asCompilerTree.
    
    first := self first: tree.

    self assert: first anySatisfy: [:e | e literal = 'a' ].
    self assert: first anyMatchesType: PPCNilNode.	
!

testFirstRepeat2
    tree := ('a' asParser star, 'b' asParser) asCompilerTree.
    
    first := self first: tree.

    self assert: first anySatisfy: [:e | e literal = 'a' ].
    self assert: first anySatisfy: [:e | e literal = 'b' ].
!

testFirstRepeat3
    tree := ('a' asParser negate plus, 'b' asParser) asCompilerTree.
    
    first := self first: tree.

    self assert: first size: 1.
    self assert: first anyMatchesType: PPCNotNode.
!

testFirstRepeat4
    tree := ('a' asParser negate star, 'b' asParser) asCompilerTree.
    
    first := self first: tree.

    self assert: first size: 2.
    self assert: first anySatisfy: [:e | (e isKindOf: PPCNotNode) and: [e child literal = 'a']].
    self assert: first anySatisfy: [ :e | e literal = 'b' ]
!

testFirstSequence1
    tree := self treeFrom: 'a' asParser, 'b' asParser .
    
    first := self first: tree.
    
    self assert: first size: 1.
    self assert: first anySatisfy: [ :e | e literal = 'a' ].
!

testFirstSequence2
    tree := nil asParser, 'a' asParser, 'b' asParser .
    
    first := self first: tree.
    
    self assert: first size: 1.
    self assert: first anySatisfy: [ :e | e literal = 'a' ].
!

testFirstSequence3
    tree := self treeFrom: nil asParser, nil asParser.
    
    first := self first: tree.
    
    self assert: first size: 1.
    self assert: first anyMatchesType: PPCNilNode.
!

testFirstSequence4
    tree := self treeFrom: ((nil asParser / 'a' asParser) plus), 'b' asParser.
    
    first := self first: tree.
    
    self assert: first size: 2.
    self assert: first anySatisfy: [ :e | e literal = 'a' ].
    self assert: first anySatisfy: [ :e | e literal = 'b' ].
    self assert: first noneMatchesType: PPCNilNode.
!

testFirstSequence5
    tree := self treeFrom: ((nil asParser / 'a' asParser) star), 'b' asParser.
    
    first := self first: tree.
    
    self assert: first size: 2.
    self assert: first anySatisfy: [ :e | e literal = 'a' ].
    self assert: first anySatisfy: [ :e | e literal = 'b' ].
    self assert: first noneMatchesType: PPCNilNode.
!

testFirstSequence6
    compiler removePass: PPCSpecializingVisitor.
    tree := self treeFrom: #space asParser star, 'a' asParser.
    
    tree firstFollowCache: nil.
    self should: [ self first: tree. ] raise: Exception.

    "Modified: / 04-09-2015 / 14:55:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testFirstSequence7
    tree := self treeFrom: #space asParser star, 'a' asParser.
    
    first := self first: tree.
    
    self assert: first size: 2.
    self assert: first anySatisfy: [ :e | e literal = 'a' ].
    self assert: first anyMatchesType: PPCPredicateNode.
!

testFirstStarMessagePredicate
    tree := self treeFrom: #space asParser star.
    
    first := self first: tree.
    
    self assert: first size: 2.
    self assert: first anyMatchesType: PPCMessagePredicateNode.
    self assert: first anyMatchesType: PPCSentinelNode.
!

testFirstStarMessagePredicate2
    tree := self treeFrom: #space asParser star.
    
    first := self first: tree.
    
    self assert: first size: 2.
    self assert: first anyMatchesType: PPCMessagePredicateNode.
    self assert: first anyMatchesType: PPCSentinelNode.

    "Modified: / 04-09-2015 / 15:00:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testFirstTerminal
    tree := self treeFrom: 'a' asParser not.

    first := self first: tree.
    
    self assert: first size: 1.
    self assert: (self first: tree) anyMatchesType: PPCNotLiteralNode.

    "Modified: / 04-09-2015 / 15:00:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testFirstTerminal2
    tree := self treeFrom: 'a' asParser and.
    
    first := self first: tree.
    
    self assert: first size: 1.
    self assert: first anySatisfy: [: e | e literal = 'a' ]
!

testFirstTrim
    tree := self treeFrom: 'a' asParser trim.

    first := self first: tree.
    
    self assert: first size: 2.
    self assert: first anyMatchesType: PPCLiteralNode.
    self assert: first anyMatchesType: PPCMessagePredicateNode.
!

testFirstTrimmingToken
    tree := self treeFrom: 'a' asParser token trim.

    first := self first: tree.
    
    self assert: first size: 1.
    self assert: (self first: tree) anyMatchesType: PPCLiteralNode.
! !

!PPCNodeFirstFollowNextTests methodsFor:'testing - first production'!

testFirstProduction1
    tree := self treeFrom: ('a' asParser name: 'a'; yourself), 'b' asParser .
    
    first := tree firstSetWithProductions.
    
    self assert: first size: 1.
    self assert: first anySatisfy: [ :e | e literal = 'a' ].
!

testFirstProduction2
    tree := self treeFrom: ('a' asParser name: nil; yourself), 'b' asParser .
    
    first := tree firstSetWithProductions.
    
    self assert: first isEmpty.
!

testFirstProduction3
    | foo bar |
    foo := 'foo' asParser name: 'foo'; yourself.
    bar := 'bar' asParser.
    
    tree := self treeFrom: (foo, bar) / foo.
    
    first := tree firstSetWithProductions.
    
    self assert: first size = 1.
    self assert: first anyOne name = 'foo'.
! !

!PPCNodeFirstFollowNextTests methodsFor:'testing - first tokens'!

testFirstTokenStar
    | token  |
    token := '.' asParser token.
    
    tree := self treeFrom: token star.
    
    first := tree firstSetWithTokens.
    self assert: first size = 2.
    self assert: first anySatisfy: [ :e | e isTokenNode ].
    self assert: first anySatisfy: [ :e | e = PPCSentinelNode instance ].
! !

!PPCNodeFirstFollowNextTests methodsFor:'testing - follow'!

testFollowSet1
    node := 'a' asParser name: 'node'; yourself.
    tree := self treeFrom: (node star, 'b' asParser).
    
    followSet := self followOfNodeIn: tree.
    
    self assert: followSet size: 2.
    self assert: followSet anySatisfy: [:e | e literal = 'a'].
    self assert: followSet anySatisfy: [:e | e literal = 'b'].
!

testFollowSet10
    | a b c |
    
    a := 'a' asParser name: 'a'; yourself.
    b := 'b' asParser optional name: 'b'; yourself.
    c := 'c' asParser name: 'c'; yourself.
    
    
        
    tree := self treeFrom: a plus, b, c.

    followSet := self followOf: 'a' in: tree.

    self assert: followSet size: 3.
    self assert: followSet anySatisfy: [:e | e literal = 'a' ].	
    self assert: followSet anySatisfy: [:e | e literal =  'b' ].
    self assert: followSet anySatisfy: [:e | e literal = 'c' ].
!

testFollowSet2
    | follow |
    node := 'a' asParser name: 'node'; yourself.
    follow := 'b' asParser, 'c' asParser.
    
    tree := self treeFrom: (node, follow).

    followSet := self followOfNodeIn: tree.

    self assert: followSet size: 1.
    self assert: followSet anySatisfy: [:e | e literal = 'b'].
    self assert: followSet noneSatisfy: [:e | e literal = 'c'].	
!

testFollowSet3
    | follow |

    node := 'a' asParser name: 'node'; yourself.
    follow := ('b' asParser, 'c' asParser) / ('d' asParser).
    
    
    tree := self treeFrom: (node, follow).

    followSet := self followOfNodeIn: tree.

    self assert: followSet size: 2.
    self assert: followSet anySatisfy: [:e | e literal = 'b' ].
    self assert: followSet anySatisfy: [:e | e literal = 'd' ].
!

testFollowSet4
    | follow |

    node := 'a' asParser name: 'node'; yourself.
    follow := ('b' asParser, 'c' asParser).
    
    
    tree := self treeFrom: (node star, follow).

    followSet := self followOfNodeIn: tree.

    self assert: followSet anySatisfy: [:e | e literal = 'b' ].
    self assert: followSet anySatisfy: [:e | e literal = 'a' ].
!

testFollowSet5
    | follow1 follow2 |

    node := 'a' asParser name: 'node'; yourself.
    follow1 := ('b' asParser, 'c' asParser) / nil asParser.
    follow2 := 'd' asParser.
    
    
    tree := self treeFrom: (node, follow1, follow2).

    followSet := self followOfNodeIn: tree.

    self assert: followSet anySatisfy: [:e | e literal = 'b' ].
    self assert: followSet anySatisfy: [:e | e literal = 'd' ].
!

testFollowSet6
    | follow follow1 follow2 |

    node := 'a' asParser name: 'node'; yourself.
    follow1 := ('b' asParser, 'c' asParser) / nil asParser.
    follow2 := 'd' asParser.
    
    follow := (follow1, follow2).
    
    tree  := self treeFrom: (node, follow).

    followSet := self followOfNodeIn: tree.

    self assert: followSet anySatisfy: [:e | e literal = 'b' ].
    self assert: followSet anySatisfy: [:e | e literal = 'd' ].
!

testFollowSet7
    |  r1 r2 follow1 follow2 |

    node := 'a' asParser name: 'node'; yourself.
    follow1 := ('b' asParser, 'c' asParser) / nil asParser.
    follow2 := 'd' asParser / nil asParser .
    
    r1 := (node, follow1).
    r2 := (r1, follow2).
    
    tree  := self treeFrom: r2.

    followSet := self followOfNodeIn: tree.

    self assert: followSet anySatisfy: [:e | e literal = 'b' ].
    self assert: followSet anySatisfy: [:e | e literal = 'd' ].
!

testFollowSet8
    node := 'a' asParser name: 'node'; yourself.
    tree := self treeFrom: node.
    
    followSet := self followOfNodeIn: tree.

    self assert: followSet anyMatchesType: PPCNilNode.
!

testFollowSet9
    | a b c |
    
    a := 'a' asParser name: 'a'; yourself.
    b := 'b' asParser optional name: 'b'; yourself.
    c := 'c' asParser name: 'c'; yourself.
    
    
    tree := self treeFrom: a, b, c.
    followSet := self followOf: 'c' in: tree.
    self assert: followSet anyMatchesType: PPCNilNode.
    
    followSet := self followOf: 'b' in: tree.
    self assert: followSet anySatisfy: [:e | e literal = 'c' ].

    followSet := self followOf: 'a' in: tree.
    self assert: followSet anySatisfy: [:e | e literal = 'b' ].
    self assert: followSet anySatisfy: [:e | e literal = 'c' ].
!

testFollowSetChoice1
    | follow |

    node := 'a' asParser name: 'node'; yourself.
    follow := 'b' asParser / 'c' asParser .
    
    tree := self treeFrom: node, follow.

    followSet := self followOfNodeIn: tree.

    self assert: followSet size: 2.	
    self assert: followSet anySatisfy: [:e | e literal = 'b' ].
    self assert: followSet anySatisfy: [:e | e literal = 'c' ].
!

testFollowSetOptional1
    |  follow1 follow2 |

    node := 'a' asParser name: 'node'; yourself.
    follow1 := 'b' asParser optional.
    follow2 := 'c' asParser.
    
    tree := self treeFrom: node, follow1, follow2.

    followSet := self followOfNodeIn: tree.

    self assert: followSet size: 2.
    self assert: followSet anySatisfy: [:e | e literal = 'b'].
    self assert: followSet anySatisfy: [:e | e literal = 'c'].
!

testFollowSetRepeat1

    node := 'a' asParser name: 'node'; yourself.
    tree := self treeFrom: node plus.
    
    followSet := self followOfNodeIn: tree.
    
    self assert: followSet anySatisfy: [:e | e literal = 'a' ].
    self assert: followSet anyMatchesType: PPCNilNode
!

testFollowSetRepeat2

    node := 'a' asParser.
    tree := self treeFrom: (node plus name: 'node'; yourself).
    
    followSet := self followOfNodeIn: tree.
    
    self assert: followSet size: 1.
    self assert: followSet anyMatchesType: PPCNilNode
!

testFollowTrimmingToken
    | token1 token2 |
    compiler removePass: PPCSpecializingVisitor.
    token1 := #letter asParser plus trimmingToken name: 'token1'; yourself.
    token2 := #letter asParser plus trimmingToken name: 'token2'; yourself.
    
    
    tree := self treeFrom: token1, token2.
    followSet := self   followOf: 'token1' 
                            in: tree 
                            suchThat: [:e | e isFirstSetTerminal or: [e isKindOf: PPCTrimmingTokenNode ]].

    self assert: followSet size: 1.
    self assert: followSet anyMatchesType: PPCTrimmingTokenNode.

    "Modified: / 04-09-2015 / 14:55:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCNodeFirstFollowNextTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

