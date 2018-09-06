"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PEGFsaGeneratorTest
	instanceVariableNames:'result node fsa generator interpreter'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-FSA'
!


!PEGFsaGeneratorTest methodsFor:'as yet unclassified'!

assert: anFsa fail: input
    | stream |
    stream := input asPetitStream.

    result := interpreter interpret: anFsa on: stream.

    self assert: result isEmpty.
    ^ result
!

assert: interpret parse: input 
    ^ self assert: interpret parse: input end: input size
!

assert: anFsa parse: input end: end
    | stream |
    stream := input asPetitStream.

    result := interpreter interpret: anFsa on: stream.

    self assert: result isEmpty not.
    self assert: (result values anySatisfy: [ :pos | pos = end ]) description: 'wrong position'.
    
    ^ result
!

fsaFrom: aNode
    ^ (aNode accept: generator)
        determinize;
        minimize;
        yourself
!

setUp
    super setUp.
    generator := PEGFsaGenerator new.
    interpreter := PEGFsaInterpret new.	
! !

!PEGFsaGeneratorTest methodsFor:'basic'!

testAnyNode
    node := PPCAnyNode new
        yourself.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'a'.
    self assert: fsa parse: 'b'.
    self assert: fsa parse: String cr.
    self assert: fsa parse: String tab.
!

testCharSetPredicateNode
    node := PPCCharSetPredicateNode new 
        predicate: (PPCharSetPredicate on: [ :e | e = $a ]);
        yourself.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'a' end: 1.
    self assert: fsa parse: 'ab' end: 1.
    self assert: fsa fail: 'b'.
!

testCharSetPredicateNode2
    node := PPCCharSetPredicateNode new 
        predicate: (PPCharSetPredicate on: [ :e | e isDigit ]);
        yourself.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: '1' end: 1.
    self assert: fsa parse: '0' end: 1.
    self assert: fsa parse: '5' end: 1.
    self assert: fsa fail: 'a'.
!

testCharacterNode
    node := PPCCharacterNode new
        character: $a;
        yourself.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'a' end: 1.
    self assert: fsa parse: 'ab' end: 1.
    self assert: fsa fail: 'b'.
!

testChoiceNode
    | literal1 literal2 |
    literal1 := PPCLiteralNode new
        literal: 'foo';
        yourself.
    literal2 := PPCLiteralNode new
        literal: 'bar';
        yourself.
    
    node := PPCChoiceNode new
        children: { literal1 . literal2 };
        yourself.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'foo'.
    self assert: fsa parse: 'bar'.	
self assert: fsa fail: 'fof'.		
!

testEndOfFileNode
    node := PPCEndOfFileNode new
        yourself.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: '' end: 1.
    self assert: fsa fail: 'a'.	
!

testLiteralNode
    node := PPCLiteralNode new
        literal: 'foo';
        yourself.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'foo' end: 3.
    self assert: fsa parse: 'foobar' end: 3.
    self assert: fsa fail: 'fox'.
    self assert: fsa fail: 'bar'.
!

testLiteralNode2
    node := PPCLiteralNode new
        literal: '';
        yourself.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: ''.
!

testNotNode
    | literal  |
    literal := PPCLiteralNode new
        literal: 'foo';
        yourself.

    node := PPCNotNode new
        child: literal;
        yourself.
    
    fsa := self fsaFrom: node.

    self assert: fsa parse: 'fo' end: 0.	
    self assert: fsa parse: 'z' end: 0.	
    self assert: fsa parse: 'foO' end: 0.	
    self assert: fsa parse: 'bar' end: 0.	
    self assert: fsa parse: ''.
    self assert: fsa fail: 'foo'.
!

testPlusNode
    | literal |
    literal := PPCLiteralNode new
        literal: 'foo';
        yourself.
    
    node := PPCPlusNode new
        child: literal;
        yourself.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa fail: ''.
    self assert: fsa parse: 'foo'.	
    self assert: fsa parse: 'foofoofoo'.		
!

testSequenceNode
    | literal1 literal2 |
    literal1 := PPCLiteralNode new
        literal: 'foo';
        yourself.
    literal2 := PPCLiteralNode new
        literal: 'bar';
        yourself.
    
    node := PPCSequenceNode new
        children: { literal1 . literal2 };
        yourself.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'foobar'.
    self assert: fsa fail: 'foo'.	
    self assert: fsa fail: 'bar'.		
!

testSequenceNode2
    | literal1 literal2 literal3 |
    literal1 := PPCLiteralNode new
        literal: 'b';
        yourself.
    literal2 := PPCLiteralNode new
        literal: 'a';
        yourself.
    literal3 := PPCLiteralNode new
        literal: 'z';
        yourself.
    
    node := PPCSequenceNode new
        children: { literal1 . literal2 . literal3 };
        yourself.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'baz'.
    self assert: fsa fail: 'bar'.	
    self assert: fsa fail: 'faz'.		
    self assert: fsa fail: 'boz'.				
!

testSequenceNode3
    | literal1 literal2 literal3 choice |
    literal1 := PPCLiteralNode new
        literal: 'a';
        yourself.
    literal2 := PPCLiteralNode new
        literal: 'b';
        yourself.

    literal3 := PPCLiteralNode new
        literal: 'c';
        yourself.


    choice := PPCChoiceNode new
        children: { literal1 . literal2 };
        yourself.
    
    node := PPCSequenceNode new
        children: { choice . literal3 };
        yourself.
        
    fsa := self fsaFrom: node.
    

    self assert: fsa parse: 'ac'.
    self assert: fsa parse: 'bc'.
    self assert: fsa fail: 'a'.	
    self assert: fsa fail: 'b'.		
    self assert: fsa fail: 'c'.		
!

testStarNode
    | literal |
    literal := PPCLiteralNode new
        literal: 'foo';
        yourself.
    
    node := PPCStarNode new
        child: literal;
        yourself.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: ''.
    self assert: fsa parse: 'foo'.	
    self assert: fsa parse: 'foofoofoo'.		
! !

!PEGFsaGeneratorTest methodsFor:'complex'!

testAAAAnot_Astar
    | parser |
    parser := 'aaaa' asParser not, ($a asParser star).
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: ''.	
    self assert: fsa parse: 'a'.	
    self assert: fsa parse: 'aa'.	
    self assert: fsa parse: 'aaa'.

    self assert: fsa fail: 'aaaa'.
    self assert: fsa fail: 'aaaaa'.
    self assert: fsa fail: 'aaaaaa'.
    self assert: fsa fail: 'aaaaaaa'.
!

testAAAAorA_AA
    | parser |
    parser := ('aaaaa' asParser / 'a' asParser), 'aa' asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'aaaaaaa'.	
    self assert: fsa parse: 'aaa'.	
    self assert: fsa parse: 'aaaa' end: 3.

    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aa'.
    self assert: fsa fail: 'aaaaa'.
    self assert: fsa fail: 'aaaaaa'.
!

testAAAnot_Aplus
    | parser |
    parser := 'aaa' asParser not, $a asParser plus.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'a'.	
    self assert: fsa parse: 'aa'.	
    self assert: fsa fail: ''.
    self assert: fsa fail: 'aaa'.
    self assert: fsa fail: 'aaaa'.
    self assert: fsa fail: 'aaaaa'.
!

testAAAorA_A
    | parser |
    parser := ('aaa' asParser / 'a' asParser), 'a' asParser.
    node := parser asCompilerTree.

    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'aaaa'.	
    self assert: fsa parse: 'aa'.
    self assert: fsa fail: 'aaa'.
    self assert: fsa fail: 'a'.
!

testAAAorA_AA
    | parser |
    parser := ('aaa' asParser / 'a' asParser), 'aa' asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'aaaaa'.	
    self assert: fsa parse: 'aaaaaa' end: 5.	
    self assert: fsa parse: 'aaaaaaa' end: 5.	

    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aa'.
    self assert: fsa fail: 'aaa'.
    self assert: fsa fail: 'aaaa'.
!

testAAAorA_Astar
    | parser |

    ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[  
        self skipIf: true description: 'JK, remove this once fixed'.
    ].   

    parser := (('aaa' asParser / 'a' asParser), 'a' asParser) star.
    node := parser asCompilerTree.

    fsa := self fsaFrom: node.
    
    self assert: fsa parse: ''.
    self assert: fsa parse: 'aa'.
    self assert: fsa parse: 'aaaa'.     
    self assert: fsa parse: 'aaaaaa'.   
    self assert: fsa parse: 'aaaaaaaa'.         

    "So far the FSA cannot handle loops with such as tokens as aaa/a, a"
    self flag: 'not working :('.
    self assert: fsa parse: 'aaaaaaa' end: 4.   

    self assert: fsa fail: 'aaa'.
    self assert: fsa fail: 'a'.

    "Modified: / 08-09-2015 / 01:52:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testAAAstar_AA
    | parser |
    parser := ('aaa' asParser) star, 'aa' asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'aa'.
    self assert: fsa parse: 'aaaaa'.	
    self assert: fsa parse: 'aaaaaaaa'.
    
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aaa'.
    self assert: fsa fail: 'aaaa'.
    self assert: fsa fail: 'aaaaaaa'.
!

testAAorA_A
    | parser |
    parser := ('aa' asParser / 'a' asParser), 'a' asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'aaa'.	
    self assert: fsa fail: 'aa'.
    self assert: fsa fail: 'a'.
!

testAAorA_AAorA
    | parser |
    parser := ('aa' asParser / 'a' asParser), ('aa' asParser / 'a' asParser).
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'aaaa'.	
    self assert: fsa parse: 'aaa'.	

    self assert: fsa fail: ''.
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aa'.
!

testAAorA_A_B
    | parser |
    parser := ('aa' asParser / 'a' asParser), 'a' asParser, 'b' asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'aaab'.	
    self assert: fsa fail: 'aab'.
!

testAAplusA
    | parser |
    parser := 'aa' asParser plus, $a asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.

    self assert: fsa parse: 'aaa'.	
    self assert: fsa parse: 'aaaaa'.	
    self assert: fsa parse: 'aaaaaaa'.	
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aa'.
    self assert: fsa fail: 'aaaa'.
!

testAAplusB
    | parser |
    parser := 'aa' asParser plus, $b asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'aab'.	
    self assert: fsa parse: 'aaaab'.	
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aa'.
    self assert: fsa fail: 'aaaa'.
    self assert: fsa fail: 'aaaac'.
!

testAB
    | parser |
    parser := $a asParser, $b asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'ab'.	
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'b'.
    self assert: fsa fail: 'ac'.
!

testA_Bnot
    | parser |
    parser := $a asParser, $b asParser not.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'a'.
    self assert: fsa parse: 'ac' end: 1.	
    self assert: fsa parse: 'aaa' end: 1.	
    self assert: fsa fail: 'ab'.
    self assert: fsa fail: 'b'.
!

testA_Boptional
    | parser |
    parser := $a asParser, $b asParser optional.
    node := parser asCompilerTree.
    
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'ab'.	
    self assert: fsa parse: 'ac' end: 1.	
    self assert: fsa parse: 'a'.
    self assert: fsa fail: 'b'.
!

testA_Boptionaloptional
    | parser |
    parser := ($a asParser, $b asParser optional) optional.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.

    self assert: fsa parse: ''.	
    self assert: fsa parse: 'a'.	
    self assert: fsa parse: 'ab'.	
    self assert: fsa parse: 'b' end: 0.
!

testA_BorC_D
    | parser |
    parser := $a asParser, ($b asParser / $c asParser), $d asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'abd'.	
    self assert: fsa parse: 'acd'.	
    self assert: fsa fail: 'abc'.
    self assert: fsa fail: 'add'.
    self assert: fsa fail: 'ad'.
!

testAoptional_Boptional
    | parser |
    parser := $a asParser optional, $b asParser optional.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    self assert: fsa parse: 'ab'.	
    self assert: fsa parse: 'ac' end: 1.	
    self assert: fsa parse: 'bc' end: 1.	
    self assert: fsa parse: 'a'.
    self assert: fsa parse: 'b'.
    self assert: fsa parse: 'c' end: 0.
    self assert: fsa parse: ''.
!

testAoptionalstar
    | parser |
    parser := 'a' asParser optional star.
    node := parser asCompilerTree.
        
    self should: [fsa := self fsaFrom: node] raise: Exception.
    
!

testAorAA
    | parser |
    parser := 'a' asParser / 'aa' asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'a'.	
    self assert: fsa parse: 'aa' end: 1.	
    self assert: fsa parse: 'aaaaaaa' end: 1.	
    self assert: fsa fail: ''.
    self assert: fsa fail: 'b'.
!

testAorAX_X
    | parser |
    parser := ('a' asParser / 'ax' asParser), $x asParser.
    node := parser asCompilerTree.
    
    fsa := self fsaFrom: node.

    self assert: fsa parse: 'ax'.	
    self assert: fsa parse: 'axx' end: 2.	
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'x'.
    self assert: fsa fail: ''.
!

testAorBC_X
    | parser |
    parser := ('a' asParser / 'bc' asParser), $x asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.

    self assert: fsa parse: 'ax'.	
    self assert: fsa parse: 'bcx' end: 3.	
    self assert: fsa fail: 'bx'.
    self assert: fsa fail: 'cx'.
    self assert: fsa fail: 'a'.	
    self assert: fsa fail: 'bc'.		
!

testAorB_Coptionaloptional
    | parser |
    parser := (($a asParser / $b asParser), $c asParser optional) optional.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.

    self assert: fsa parse: ''.	
    self assert: fsa parse: 'a'.	
    self assert: fsa parse: 'b'.	
    self assert: fsa parse: 'ac'.	
    self assert: fsa parse: 'bc'.	
    self assert: fsa parse: 'ad' end: 1.	
    self assert: fsa parse: 'bd' end: 1.	
    self assert: fsa parse: 'd' end: 0.	
    self assert: fsa parse: 'c' end: 0.
!

testAplusA
    | parser |
    parser := $a asParser plus, $a asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aa'.
    self assert: fsa fail: 'aaa'.
!

testAplusB
    | parser |
    parser := $a asParser plus, $b asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'ab'.	
    self assert: fsa parse: 'aaab'.	
    self assert: fsa parse: 'ab'.	

    self assert: fsa fail: 'b'.
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'ac'.
    self assert: fsa fail: 'aac'.
!

testAstarA
    | parser |
    parser := $a asParser star, $a asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aa'.
    self assert: fsa fail: 'aaa'.
!

testAstarB
    | parser |
    parser := $a asParser star, $b asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'b'.	
    self assert: fsa parse: 'ab'.	
    self assert: fsa parse: 'aaab'.	
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'ac'.
    self assert: fsa fail: 'aac'.
!

testAstar_Bplus
    | parser |
    parser := 'a' asParser star, 'b' asParser plus.
    node := parser asCompilerTree.
        
    
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'b'.
    self assert: fsa parse: 'bbbb'.
    self assert: fsa parse: 'aaaab'.

    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aaa'.
!

testCharSet
    | parser |
    parser := #letter asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'a'.	
    self assert: fsa parse: 'z'.	
    self assert: fsa parse: 'A'.	
    self assert: fsa parse: 'Z'.	
    self assert: fsa fail: '_'.
    self assert: fsa fail: '()'.
    self assert: fsa fail: ''.
!

testChoice
    | parser |
    parser := ($a asParser optional, $b asParser optional) / $a asParser.
    node := parser asCompilerTree.
    
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'ab'.	
    self assert: fsa parse: 'a' end: 1.	
    self assert: fsa parse: 'b' end: 1.	
    self assert: fsa parse: ''.
    self assert: fsa parse: 'c' end: 0.
!

testChoice2
    | parser |
    parser := 'aaa' asParser / 'aa' asParser / 'a' asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'aaa'.	
    self assert: fsa parse: 'aa'.
    self assert: fsa parse: 'a'
!

testIdentity
    | parser quot |
    quot := $" asParser.
    parser := quot, $a asParser star, quot.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: '""'.
    self assert: fsa parse: '"a"'.
    self assert: fsa parse: '"aa"'.
    self assert: fsa parse: '"aaaaaaaa"'.
!

testKwPlus
    | parser |
    parser := (#word asParser plus, $: asParser) plus.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'foo:bar:baz:'.	
    self assert: fsa parse: 'foo:bar:baz' end: 8.	

    self assert: fsa fail: ''.
    self assert: fsa fail: 'foo'.
!

testNot
    | parser |
    parser := 'aaa' asParser not, $a asParser plus.
    node := parser asCompilerTree.
    
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'a'.	
    self assert: fsa parse: 'aa'.	
    self assert: fsa fail: 'aaa'.
    self assert: fsa fail: 'aaaa'.
    self assert: fsa fail: 'aaaaa'.
    self assert: fsa fail: ''.
!

testOptional
    | parser |
    parser := ($a asParser optional, $b asParser optional) / $a asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'ab'.	
    self assert: fsa parse: 'a' end: 1.	
    self assert: fsa parse: 'b' end: 1.	
    self assert: fsa parse: ''.
    self assert: fsa parse: 'c' end: 0.
!

testOptional2
    | parser |
    parser := ($a asParser, $b asParser optional) / 'ac' asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'ab'.	
    self assert: fsa parse: 'a'.	
    self assert: fsa fail: 'b'.	
    self assert: fsa parse: 'ac' end: 1.	
!

testPlus
    | parser |
    parser := ('aa' asParser) plus, ('a' asParser / 'aa' asParser).
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'aaa'.	
    self assert: fsa parse: 'aaaaa'.

    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aa'.
    self assert: fsa fail: 'aaaa'.
!

testPlus2
    | parser |
    parser := ('aaaaaa' asParser / 'a' asParser) plus.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'a'.	
    self assert: fsa parse: 'aa'.
    self assert: fsa parse: 'aaa'.
    self assert: fsa parse: 'aaaa'.
    self assert: fsa parse: 'aaaaa'.
    self assert: fsa parse: 'aaaaaa'.
    self assert: fsa parse: 'aaaaaaa'.

    self assert: fsa fail: ''.
!

testPlus3
    | parser |
    parser := ('aaaaaa' asParser / 'aa' asParser) plus.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'aa'.
    self assert: fsa parse: 'aaaa'.
    self assert: fsa parse: 'aaaaaa'.

    self assert: fsa fail: ''.
    self assert: fsa fail: 'a'.

    self assert: fsa parse: 'aaa' end: 2.
    self assert: fsa parse: 'aaaaa' end: 4.
    self assert: fsa parse: 'aaaaaaa' end: 6.
    
!

testPlus4
    | parser |
    parser := ('aaa' asParser / 'aa' asParser / 'a' asParser) plus.
    node := parser asCompilerTree.
        
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'a'.
    self assert: fsa parse: 'aa'.
    self assert: fsa parse: 'aaa'.
    self assert: fsa parse: 'aaaa'.
    self assert: fsa parse: 'aaaaa'.
    self assert: fsa parse: 'aaaaaa'.
!

testPlus5
    | parser |
    parser := ('aaa' asParser / 'aa' asParser / 'b' asParser) plus.
    node := parser asCompilerTree.
        
        
    fsa := self fsaFrom: node.


    self assert: fsa parse: 'b'.
    self assert: fsa parse: 'bb'.
    self assert: fsa parse: 'bbaaa'.
    self assert: fsa parse: 'bbaaabbaa'.
    
    self assert: fsa parse: 'aa'.
    self assert: fsa parse: 'aaa'.
    self assert: fsa parse: 'aaaaa'.
    self assert: fsa parse: 'aaaaaa'.
    self assert: fsa parse: 'aaaaaab'.
    
    self assert: fsa parse: 'bba' end: 2.
    self assert: fsa parse: 'aaaa' end: 3.
!

testSequence
    | parser |
    parser := ('aa' asParser plus), ('aa' asParser plus).
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aa'.
    self assert: fsa fail: 'aaa'.
    self assert: fsa fail: 'aaaa'.
    self assert: fsa fail: 'aaaaa'.
    self assert: fsa fail: 'aaaaaa'.
!

testSequence2
    | parser |
    parser := ('aa' asParser star), ('bb' asParser star).
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'aa'.
    self assert: fsa parse: 'aaaa'.
    self assert: fsa parse: 'aaaaaa'.
    self assert: fsa parse: 'aaaaaaaa'.

    self assert: fsa parse: 'a' end: 0.
    self assert: fsa parse: 'aaa' end: 2.
    self assert: fsa parse: 'aaaaa' end: 4.
    self assert: fsa parse: 'aaaaaaa' end: 6.
    self assert: fsa parse: 'aaaaaaaaa' end: 8.
!

testSequence3
    | parser |
    parser := 'a' asParser, 'b' asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: (fsa states noneSatisfy: [ :s | s isFsaFailure  ]).
!

testSequence4
    | parser |
    parser := 'a' asParser star, 'b' asParser.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: (fsa states noneSatisfy: [ :s | s isFsaFailure  ]).
!

testUnaryOrKw
    | parser unary kw |
    unary := #letter asParser plus, $: asParser not.
    kw := #letter asParser plus, $: asParser.
    parser := unary / kw.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'foo'.	
    self assert: fsa parse: 'foo:'.	

    self assert: fsa fail: '123'.
!

testUnaryOrKwPlus
    | parser unary kw |
    unary := #letter asParser plus, $: asParser not.
    kw := #letter asParser plus, $: asParser.
    parser := (unary / kw) plus.
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'foo'.	
    self assert: fsa parse: 'foo:'.	
    self assert: fsa parse: 'foo:bar:'.	
    self assert: fsa fail: '123'.
!

testUnaryOrMultiword
    | parser unary kw |
    unary := #letter asParser plus, $: asParser not.
    kw := #letter asParser plus, $: asParser.
    parser := unary / (kw plus).
    node := parser asCompilerTree.
        
    fsa := self fsaFrom: node.
    
    self assert: fsa parse: 'foo'.	
    self assert: fsa parse: 'foo:'.	
    self assert: fsa parse: 'foo:bar:'.	
    self assert: fsa fail: '123'.
! !

!PEGFsaGeneratorTest methodsFor:'recursive'!

testRecursive
    | parser |
    parser := PPDelegateParser new.
    
    parser setParser: ($a asParser, parser) / $b asParser.
    node := parser asCompilerTree.

    fsa :=	 self fsaFrom: node.

    self assert: fsa parse: 'b'.
    self assert: fsa parse: 'ab'.
    self assert: fsa parse: 'aaab'.
    self assert: fsa fail: 'aaa'.
    self assert: fsa fail: ''.	
    self assert: fsa fail: 'aac'.		
!

testRecursive2
    | parser |
    parser := PPDelegateParser new.
    
    parser setParser: (($a asParser / $b asParser), parser) / $c asParser.
    node := parser asCompilerTree.

    fsa :=	 self fsaFrom: node.

    self assert: fsa parse: 'c'.
    self assert: fsa parse: 'ac'.
    self assert: fsa parse: 'bc'.
    self assert: fsa parse: 'ababc'.
    self assert: fsa fail: 'aaab'.
    self assert: fsa fail: 'ab'.	
! !

!PEGFsaGeneratorTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

