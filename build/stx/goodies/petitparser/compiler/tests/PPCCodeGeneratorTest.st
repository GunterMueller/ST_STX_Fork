"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPCCodeGeneratorTest
	instanceVariableNames:'visitor node result parser context compiler options'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Visitors'
!


!PPCCodeGeneratorTest methodsFor:'generating'!

compileTree: root
    parser := compiler compile: root.
    
! !

!PPCCodeGeneratorTest methodsFor:'running'!

context	
    ^ context := PPCProfilingContext new
!

setUp
    options := (PPCCompilationOptions new)
            tokenize:false;
            profile:true;
            yourself.
    compiler := PPCCompiler new passes:{
                    PPCCacheFirstFollowPass.
                    PPCCheckingVisitor.
                    PPCUniversalCodeGenerator
                }.
    compiler options:options.

    "Modified: / 07-09-2015 / 10:22:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    | class |

    class := (Smalltalk at: #PPGeneratedParser ifAbsent: [nil]).
    class notNil ifTrue:[ 
        class removeFromSystem
    ].
! !

!PPCCodeGeneratorTest methodsFor:'testing'!

assert: whatever parse: input
    result := super assert: whatever parse: input.
!

testActionNode
    node := PPCActionNode new
        block: [ :res | res collect: [:each | each asUppercase ]];
        child: #letter asParser plus asCompilerTree;
        yourself.
    
    self compileTree: node.
                    
    self assert: parser parse: 'foo' to: { $F . $O . $O}.
    self assert: parser parse: 'bar' to: { $B . $A . $R}.
    self assert: parser fail: ''.
!

testActionNode2
    node := PPCPlusNode new
                child:  
                    (PPCActionNode new
                        block: [ :res | res asUppercase ];
                        child: #letter asParser asCompilerTree;
                        yourself);
                yourself.
    
    self compileTree: node.
                    
    self assert: parser parse: 'foo' to: { $F . $O . $O}.
    self assert: parser parse: 'bar' to: { $B . $A . $R}.
    self assert: parser fail: ''.

    "Created: / 15-06-2015 / 13:57:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testActionNode3
    node := ((#letter asParser , #letter asParser) 
            ==> [:nodes | String with:(nodes first) with:(nodes second) ]) asCompilerTree.
    node child markForInline.

    self compileTree:node.

    self assert:parser parse:'ab' to:'ab'.
    self assert:parser parse:'cz' to:'cz'.
    self assert:parser fail:''.

    "Created: / 16-06-2015 / 06:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testActionNode4
    node := ((#letter asParser , #letter asParser) 
            ==> [:nodes | String with:(nodes first) with:(nodes second) ]) asCompilerTree.
    node child markForInline.

    self compileTree:node.

    self assert:parser fail:'a'.

    "Created: / 16-06-2015 / 06:53:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testActionNode5
    node := ((#letter asParser , #letter asParser optional) 
            ==> [:nodes | String with:(nodes first) with:((nodes second) isNil ifTrue:[$?] ifFalse:[nodes second]) ]) asCompilerTree.
    node child markForInline.

    self compileTree:node.

    self assert:parser parse:'cz' to:'cz'.
    self assert:parser parse:'c' to:'c?'.

    "Created: / 16-06-2015 / 06:53:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testActionNode6
    node := ((#letter asParser , #letter asParser) 
            ==> [:nodes | String withAll:nodes ]) asCompilerTree.
    node child markForInline.

    self compileTree:node.

    self assert:parser parse:'ab' to:'ab'.
    self assert:parser parse:'cz' to:'cz'.
    self assert:parser fail:''.

    "Created: / 16-06-2015 / 07:22:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testActionNode7
    node := ((#letter asParser , #letter asParser) 
            ==> [:nodes | self createStringFromCharacters: nodes ]) asCompilerTree.
    node child markForInline.

    self compileTree:node.

    self assert:parser parse:'ab' to:'ab'.
    self assert:parser parse:'cz' to:'cz'.
    self assert:parser fail:''.

    "Created: / 27-07-2015 / 15:48:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testAnyNode
    node := PPCForwardNode new
        child: PPCAnyNode new;
        yourself.
    self compileTree: node.
        
    self assert: parser class methodDictionary size = 2.
        
    self assert: parser parse: 'a' to: $a.
    self assert: parser parse: '_' to: $_.
    self assert: parser parse: Character cr asString to: Character cr.

    "Modified: / 23-04-2015 / 12:43:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testAnyNode2
    node := PPCForwardNode new
        child: (PPCAnyNode new markForInline; yourself);
        yourself.

    self compileTree: node.
        
    self assert: parser class methodDictionary size = 1.
        
    self assert: parser parse: 'a' to: $a.
    self assert: parser parse: '_' to: $_.
    self assert: parser parse: Character cr asString to: Character cr.

    "Modified: / 23-04-2015 / 12:43:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCharSetPredicateNode
    | charNode |
    charNode := PPCCharSetPredicateNode new 
        predicate: (PPCharSetPredicate on: [ :e | e = $a ]);
        yourself.
    node := PPCForwardNode new
        child: charNode;
        yourself.
    
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 2.
    
    self assert: parser parse: 'a'  to: $a.
    self assert: parser fail: 'b'.
!

testCharSetPredicateNode2
    | charNode |
    charNode := PPCCharSetPredicateNode new 
        predicate: (PPCharSetPredicate on: [ :e | e = $a ]);
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: charNode;
        yourself.
        
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.

    self assert: parser parse: 'a'  to: $a.
    self assert: context invocationCount = 1.

    self assert: parser fail: 'b'.
!

testCharacterNode
    | charNode |
    charNode := PPCCharacterNode new 
        character: $a; yourself.
    node := PPCForwardNode new
        child: charNode; yourself.
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 2.
    self assert: parser parse: 'a'  to: $a.
    self assert: parser fail: 'b'.
!

testCharacterNode2
    node := (PPCCharacterNode new character: $#; yourself).
    self compileTree: node.

    self assert: parser parse: '#'
!

testCharacterNode3
    node := PPCCharacterNode new character: Character lf; yourself.
    self compileTree: node.

    self assert: parser parse: String lf.
!

testCharacterNode4
    | charNode |
    charNode := PPCCharacterNode new 
        character: $a; 
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: charNode; yourself.
    
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: 'a'  to: $a.
    self assert: parser fail: 'b'.
!

testCharacterNode5
    | charNode |
    charNode := PPCCharacterNode new 
        character: $'; 
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: charNode; yourself.
    
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: ''''  to: $'.
    self assert: parser fail: 'a'.
!

testCharacterNode6
    | charNode |
    charNode := PPCCharacterNode new 
        character: $"; 
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: charNode; yourself.
    
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: '"'  to: $".
    self assert: parser fail: 'a'.
!

testChoiceNode
    node := PPCChoiceNode new
        children: { #digit asParser asCompilerNode. #letter asParser asCompilerNode };
        yourself.
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 3.
    
    self assert: parser parse: '1' to: $1.
    self assert: parser parse: 'a' to: $a.
    self assert: parser fail: '_'.
!

testChoiceNode2
    | digitNode letterNode |
    digitNode := PPCMessagePredicateNode new
        message: #isDigit;
        markForInline;
        yourself.

    letterNode := PPCMessagePredicateNode new
        message: #isLetter;
        markForInline;
        yourself.


    node := PPCChoiceNode new
        children: { digitNode . letterNode };
        yourself.
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    
    self assert: parser parse: '1' to: $1.
    self assert: parser parse: 'a' to: $a.
    self assert: parser fail: '_'.
!

testEndOfInputNode
    | letterNode  |
    letterNode := PPCMessagePredicateNode new
        message: #isLetter;
        yourself.
    node := PPCEndOfInputNode new
        child: letterNode;
        yourself.
    
    self compileTree: node.

    self assert: parser class methodDictionary size = 2.
        
    self assert: parser parse: 'a' to: $a.
    self assert: parser fail: 'bc' end: 1.
    self assert: parser fail: ''.
!

testForwardNode
    | letterNode forwardNode |
    letterNode := PPCMessagePredicateNode new
        message: #isLetter;
        yourself.
    forwardNode := PPCForwardNode new
        child: letterNode;
        yourself.
    node := PPCForwardNode new
        child: forwardNode;
        yourself.
    
    self compileTree: node.

    self assert: parser class methodDictionary size = 3.
        
    self assert: parser parse: 'a' to: $a.
    self assert: parser parse: 'bc' to: $b end: 1.
    self assert: parser fail: ''.
!

testForwardNode2
    | letterNode forwardNode |
    letterNode := PPCMessagePredicateNode new
        message: #isLetter;
        markForInline;
        yourself.

    forwardNode := PPCForwardNode new
        child: letterNode;
        yourself.
    node := PPCForwardNode new
        child: forwardNode;
        yourself.

    
    self compileTree: node.

    self assert: parser class methodDictionary size = 2.
        
    self assert: parser parse: 'a' to: $a.
    self assert: parser parse: 'bc' to: $b end: 1.
    self assert: parser fail: ''.
!

testForwardNode3
    | letterNode forwardNode |
    letterNode := PPCMessagePredicateNode new
        message: #isLetter;
        yourself.
    forwardNode := PPCForwardNode new
        child: letterNode;
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: forwardNode;
        yourself.

    
    self compileTree: node.

    self assert: parser class methodDictionary size = 2.
        
    self assert: parser parse: 'a' to: $a.
    self assert: parser parse: 'bc' to: $b end: 1.
    self assert: parser fail: ''.
!

testForwardNode4
    | letterNode forwardNode |
    letterNode := PPCMessagePredicateNode new
        message: #isLetter;
        markForInline;
        yourself.

    forwardNode := PPCForwardNode new
        child: letterNode;
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: forwardNode;
        yourself.

    
    self compileTree: node.
        
    self assert: parser class methodDictionary size = 1.
    
    self assert: parser parse: 'a' to: $a.
    self assert: parser parse: 'bc' to: $b end: 1.
    self assert: parser fail: ''.
!

testInlinePluggableNode
   "Sadly, on Smalltalk/X blocks cannot be inlined because
				 the VM does not provide enough information to map
				 it back to source code. Very bad indeed!!"          
				((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[
						self skipIf: true description: 'Blocks cannot be inlined due to a lack of proper VM support'.
				].

				node := PPCSequenceNode new
								children: { 
												PPCPluggableNode new block: [ :ctx | ctx next ]; markForInline; yourself. 
												$a asParser asCompilerNode }.
				
				self compileTree: node.
				
				self assert: parser class methodDictionary size = 2.
				self assert: parser parse: 'ba' to: #($b $a).
!

testLiteralNode
    node := PPCLiteralNode new
        literal: 'foo';
        yourself.
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: (parser class methodDictionary includesKey: #lit).
    self assert: parser parse: 'foo'  to: 'foo'.
    self assert: parser parse: 'foobar'  to: 'foo' end: 3.
    self assert: parser fail: 'boo'.
!

testLiteralNode2
    node := PPCLiteralNode new
        literal: '''''';
        yourself.
    self compileTree: node.
    
    self assert: parser parse: ''''''  to: ''''''.
!

testLiteralNode3
    | literalNode |
    literalNode := PPCLiteralNode new
        literal: 'foo';
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: literalNode;
        yourself.
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: 'foo'  to: 'foo'.
    self assert: parser parse: 'foobar'  to: 'foo' end: 3.
    self assert: parser fail: 'boo'.
!

testMappedActionNode1
    node := ((#letter asParser , #letter asParser) 
            map:[:a :b | String with:a with:b ]) asCompilerTree.

    self compileTree:node.

    self assert:parser parse:'ab' to:'ab'.
    self assert:parser parse:'cz' to:'cz'.
    self assert:parser fail:''.
    self assert:parser fail:'a'.

    "Created: / 02-06-2015 / 17:04:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2015 / 22:44:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 15-06-2015 / 14:08:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testMappedActionNode2
    node := ((#letter asParser , #letter asParser) 
            map:[:a :b | String with:a with:b ]) asCompilerTree.
    node child markForInline.

    self compileTree:node.

    self assert:parser parse:'ab' to:'ab'.
    self assert:parser parse:'cz' to:'cz'.
    self assert:parser fail:''.
    self assert:parser fail:'a'.

    "Created: / 04-06-2015 / 23:13:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 15-06-2015 / 14:08:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testMappedActionNode3
    node := PPCPlusNode new
                child:  
                    (PPCMappedActionNode new
                        block: [ :l | l asUppercase ];
                        child: #letter asParser asCompilerTree;
                        yourself);
                yourself.           

    self compileTree:node.

    self assert:parser parse:'abc' to:#($A $B $C).

    "Created: / 15-06-2015 / 18:27:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testMessagePredicate
    | messageNode |
    messageNode := PPCMessagePredicateNode new
        message: #isDigit;
        yourself.
    node := PPCForwardNode new
        child: messageNode;
        yourself.
    
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 2.
    self assert: parser parse: '1' to: $1 end: 1.
    self assert: context invocationCount = 2.
        
    self assert: parser fail: 'a'.
    self assert: parser fail: ''.
!

testMessagePredicate2
    | messageNode |
    messageNode := PPCMessagePredicateNode new
        message: #isDigit;
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: messageNode;
        yourself.
        
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: '1' to: $1 end: 1.
    self assert: context invocationCount = 1.
        
    self assert: parser fail: 'a'.
    self assert: parser fail: ''.
!

testNilNode
    | nilNode |
    nilNode := PPCNilNode new.
    node := PPCForwardNode new child: nilNode; yourself.
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 2.
    self assert: parser parse: 'a' to: nil end: 0.
    self assert: parser parse: '' to: nil end: 0.
!

testNilNode2
    | nilNode |
    nilNode := PPCNilNode new markForInline; yourself.
    node := PPCForwardNode new child: nilNode; yourself.
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: 'a' to: nil end: 0.
    self assert: parser parse: '' to: nil end: 0.
!

testNotCharSetPredicateNode
    | charNode |
    charNode := PPCNotCharSetPredicateNode new
        predicate: (PPCharSetPredicate on: [ :e | e = $a ]);
        yourself.
    node := PPCForwardNode new
        child: charNode; yourself.
        
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 2.
    self assert: parser parse: 'b' to: nil end: 0.
    self assert: context invocationCount = 2.
        
    self assert: parser fail: 'a'.
    self assert: parser parse: '' to: nil end: 0.
!

testNotCharSetPredicateNode2
    | charNode |
    charNode := PPCNotCharSetPredicateNode new
        predicate: (PPCharSetPredicate on: [ :e | e = $a ]);
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: charNode; yourself.

    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: 'b' to: nil end: 0.
    self assert: context invocationCount = 1.
        
    self assert: parser fail: 'a'.
    self assert: parser parse: '' to: nil end: 0.
!

testNotCharacterNode
    node := PPCNotCharacterNode new
        character: $:
        yourself.
    
    self compileTree: node.
    
    self assert: parser parse: 'a' to: nil end: 0.
    self assert: parser fail: ':'.
    self assert: parser parse: '' to: nil end: 0.
!

testNotLiteralNode
    | literalNode |
    literalNode := PPCNotLiteralNode new
        literal: 'foo';
        yourself.
    node := PPCForwardNode new
        child: literalNode; yourself.

    self compileTree: node.
    
    self assert: parser class methodDictionary size = 2.
    self assert: parser parse: 'bar' to: nil end: 0.
    self assert: context invocationCount = 2.
        
    self assert: parser fail: 'foo'.
    self assert: parser parse: '' to: nil end: 0.
!

testNotLiteralNode2
    | literalNode |
    literalNode := PPCNotLiteralNode new
        literal: 'foo';
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: literalNode; yourself.

    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: 'bar' to: nil end: 0.
    self assert: context invocationCount = 1.
        
    self assert: parser fail: 'foo'.
    self assert: parser parse: '' to: nil end: 0.
!

testNotMessagePredicateNode
    | messageNode |
    messageNode := PPCNotMessagePredicateNode new
        message: #isDigit;
        yourself.
    node := PPCForwardNode new
        child: messageNode;
        yourself.
                
        
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 2.
    self assert: parser parse: 'a' to: nil end: 0.
    self assert: context invocationCount = 2.
        
    self assert: parser fail: '1'.
    self assert: parser parse: '' to: nil end: 0.
!

testNotMessagePredicateNode2
    | messageNode |
    messageNode := PPCNotMessagePredicateNode new
        message: #isDigit;
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: messageNode;
        yourself.		
        
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: 'a' to: nil end: 0.
    self assert: context invocationCount = 1.
        
    self assert: parser fail: '1'.
    self assert: parser parse: '' to: nil end: 0.
!

testNotNode
    node := PPCNotNode new
        child: #digit asParser asCompilerNode;
        yourself.
    
    self compileTree: node.
    
    self assert: parser parse: 'a' to: nil end: 0.
    self assert: parser fail: '1'.
    self assert: parser parse: '' to: nil end: 0.
!

testOptionalNode
    node := PPCOptionalNode new
        child: ($a asParser asCompilerNode);
        yourself.
    self compileTree: node.
    
    self assert: parser parse: 'b' to: nil end: 0.
    self assert: parser parse: 'a' to: $a.
    self assert: parser parse: '' to: nil end: 0.
!

testPluggableNode
    node := PPCPluggableNode new
        block: [:ctx | ctx next ];
        yourself.
    self compileTree: node.
        
    self assert: parser parse: 'foo' to: $f end: 1.
    self assert: parser parse: 'bar' to: $b end: 1.
    self assert: parser parse: '' to: nil.
!

testPlusNode
    node := PPCPlusNode new
        child: ($a asParser asCompilerNode);
        yourself.
    
    self compileTree: node.


    self assert: parser class methodDictionary size = 2.	
    self assert: parser parse: 'aaa' to: #($a $a $a) end: 3.
    self assert: parser parse: 'ab' to: #( $a ) end: 1.
    self assert: parser fail: 'b'.
!

testPlusNode2
    node := PPCPlusNode new
        child: (#letter asParser asCompilerNode markForInline);
        yourself.
    
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.	
    self assert: parser parse: 'abc' to: #($a $b $c) end: 3.
    self assert: parser parse: 'ab1' to: #( $a $b ) end: 2.
    self assert: parser fail: '1'.
!

testPredicateNode
    | predicateNode |
    predicateNode := PPCPredicateNode new
        predicate: (PPCharSetPredicate on: [ :e | e isDigit ]);
        yourself.
    node := PPCForwardNode new
        child: predicateNode;
        yourself.
    self compileTree: node.	
    
    self assert: parser class methodDictionary size = 2.
    self assert: parser parse: '1' to: $1 end: 1.
    self assert: context invocationCount = 2.
        
    self assert: parser fail: 'a'.
    self assert: parser fail: ''.
!

testPredicateNode2
    |  predicateNode |
    predicateNode := PPCPredicateNode new
        predicate: (PPCharSetPredicate on: [ :e | e isDigit ]);
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: predicateNode;
        yourself.

    self compileTree: node.	
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: '1' to: $1 end: 1.
    self assert: context invocationCount = 1.
        
    self assert: parser fail: 'a'.
    self assert: parser fail: ''.
!

testRecognizingSequenceNode
    | letterNode |
    letterNode := PPCMessagePredicateNode new
        message: #isLetter;
        yourself.	
    
    node := PPCRecognizingSequenceNode new
        children: { letterNode };
        yourself.
    
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 2.
    self assert: parser parse: 'a'.
    self assert: parser fail: '1'.
!

testRecognizingSequenceNode2
    | letterNode |
    letterNode := PPCMessagePredicateNode new
        message: #isLetter;
        markForInline;
        yourself.	
    
    node := PPCRecognizingSequenceNode new
        children: { letterNode };
        yourself.
    
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: 'a'.
    self assert: parser fail: '1'.
!

testSequenceNode
    node := PPCSequenceNode new
        children: { $a asParser asCompilerNode . 
                        $b asParser asCompilerNode . 
                        $c asParser asCompilerNode  };
        yourself.
    self compileTree: node.
    
    self assert: parser parse: 'abc' to: #($a $b $c) end: 3.
    self assert: parser parse: 'abcd' to: #( $a $b $c ) end: 3.
    self assert: parser fail: 'ab'.
!

testSequenceOptInlined1
    | a b bOpt |

    a := $a asParser asCompilerNode.
    b := $b asParser asCompilerNode.
    bOpt := PPCOptionalNode new
                child:  b ;
                markForInline;
                yourself.
    node := PPCSequenceNode new
        children: { a . bOpt };
        yourself.
    self compileTree: node.
    
    self assert: parser parse: 'ab' to: #($a $b ) end: 2.
    self assert: parser parse: 'a' to: #( $a nil ) end: 1.

    "Created: / 22-05-2015 / 11:47:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSequenceOptInlined2
    | a b bOpt |

    a := $a asParser asCompilerNode.
    a markForInline.
    b := $b asParser asCompilerNode.
    b markForInline.
    bOpt := PPCOptionalNode new
                child:  b ;
                markForInline;
                yourself.
    node := PPCSequenceNode new
        children: { a . bOpt };
        yourself.
    self compileTree: node.
    
    self assert: parser parse: 'ab' to: #($a $b ) end: 2.
    self assert: parser parse: 'a' to: #( $a nil ) end: 1.

    "Created: / 22-05-2015 / 11:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testStarAnyNode
    compiler removePass: PPCCacheFirstFollowPass.
    node := PPCStarAnyNode new 
        child: PPCNilNode new; 
        yourself.
    self compileTree: node.
    
    self assert: parser parse: 'abc' to: #($a $b $c).
    self assert: parser parse: 'a' to: #($a).
    self assert: parser parse: '' to: #().

    "Modified: / 04-09-2015 / 14:47:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testStarCharSetPredicateNode
    compiler removePass: PPCCacheFirstFollowPass.
    node := PPCStarCharSetPredicateNode new
        predicate: (PPCharSetPredicate on: [:e | e = $a ]);
        child: PPCSentinelNode new;
        yourself.
    
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: 'aaa1' to: #( $a $a $a) end: 3.
    self assert: context invocationCount = 1.
    self assert: parser parse: 'bba' to: #() end: 0.
    self assert: context invocationCount = 1.

    "Modified: / 04-09-2015 / 14:47:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testStarMessagePredicateNode
    compiler removePass: PPCCacheFirstFollowPass.
    node := PPCStarMessagePredicateNode new
        message: #isLetter;
        child: PPCSentinelNode new;
        yourself.
    
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    self assert: parser parse: 'abc1' to: #( $a $b $c) end: 3.
    self assert: context invocationCount = 1.
    
    self assert: parser parse: '123a' to: #() end: 0.
    self assert: context invocationCount = 1.

    "Modified: / 04-09-2015 / 14:48:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testStarNode
    node := PPCStarNode new
        child: ($a asParser asCompilerNode);
        yourself.
    
    self compileTree: node.
    
    self assert: parser parse: 'aaa' to: #($a $a $a) end: 3.
    self assert: parser parse: 'ab' to: #( $a ) end: 1.
    self assert: parser parse: 'b' to: #() end: 0.
    
    self assert: parser parse: ''.
    self assert: result isArray.
!

testStarNode2
    node := PPCStarNode new
        child: ('aa' asParser asCompilerNode);
        yourself.
    
    self compileTree: node.
    
    self assert: parser parse: 'aaaa' to: #('aa' 'aa') end: 4.
    self assert: parser parse: 'aab' to: #( 'aa' ) end: 2.
    self assert: parser parse: 'a' to: #() end: 0.
!

testSymbolActionNode
    node := PPCSymbolActionNode new
        block: #second;
        child: #letter asParser plus asCompilerTree;
        yourself.
    
    self compileTree: node.
        
    self assert: parser parse: 'foo' to: $o.
    self assert: parser parse: 'bar' to: $a.
    self assert: parser fail: ''.
!

testTokenNode
    node := PPCTokenNode new
        child: #letter asParser plus asCompilerTree;
        tokenClass: PPToken;
        yourself.
    
    self compileTree: node.
    
    self assert: parser parse: 'abc'.
    self assert: result class = PPToken.
    self assert: result inputValue = 'abc'.

    self assert: parser fail: '1a'.
!

testTokenStarMessagePredicateNode
    
    node := PPCTokenStarMessagePredicateNode new 
        message: #isLetter; 
        child: PPCSentinelNode new; 
        yourself.
    compiler removePass: PPCCacheFirstFollowPass.
    options guards: false.      
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    
    self assert: parser parse: 'foo' to: parser.
    self assert: context invocationCount = 1.
    self assert: context lwRememberCount  = 0.
    self assert: context lwRestoreCount  = 0.
    self assert: context rememberCount = 0.
    
    self assert: parser parse: 'foo123' to: parser end: 3.

    "Modified: / 04-09-2015 / 14:48:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTokenStarSeparatorNode
    
    | starNode |
    starNode := PPCTokenStarSeparatorNode new 
        message: #isSeparator; 
        child: PPCSentinelNode new; 
        yourself.
    node := PPCForwardNode new
        child: starNode;
        yourself.
    compiler removePass: PPCCacheFirstFollowPass.
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 2.
    
    self assert: parser parse: '   a' to: parser end: 3.
    self assert: context invocationCount = 2.

    "Modified: / 04-09-2015 / 14:48:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTokenStarSeparatorNode2
    
    | starNode |
    starNode := PPCTokenStarSeparatorNode new 
        message: #isSeparator; 
        child: PPCSentinelNode new; 
        markForInline;
        yourself.
    node := PPCForwardNode new
        child: starNode;
        yourself.       
    compiler removePass: PPCCacheFirstFollowPass.
    self compileTree: node.
    
    self assert: parser class methodDictionary size = 1.
    
    self assert: parser parse: '   a' to: context end: 3.
    self assert: context invocationCount = 1.

    "Modified: / 04-09-2015 / 14:48:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTrimNode
    node := PPCTrimNode new
        child: #letter asParser asCompilerNode;
        yourself.
    
    self compileTree: node.
    
    self assert: parser parse: ' a '.
    self assert: parser fail: ' 1 '.
!

testTrimmingTokenNode
    node := PPCTrimmingTokenNode new
        child: #letter asParser plus asCompilerTree;
        tokenClass: PPToken;
        whitespace: #space asParser star asCompilerTree;
        yourself.
    
    self compileTree: node.
    
    self assert: parser parse: 'abc'.
    self assert: result class = PPToken.
    self assert: result inputValue = 'abc'.

    self assert: parser parse: ' abc '.
    self assert: result class = PPToken.
    self assert: result inputValue = 'abc'.


    self assert: parser fail: '1a'.
!

testUnknownNode
    node := PPCUnknownNode new
        parser: [:ctx | ctx next ] asParser;
        yourself.
    self compileTree: node.
        
    self assert: parser parse: 'foo' to: $f end: 1.
    self assert: parser parse: 'bar' to: $b end: 1.
    self assert: parser parse: '' to: nil.
! !

!PPCCodeGeneratorTest methodsFor:'utilities'!

createStringFromCharacters: characters
    ^ String withAll: characters

    "Created: / 27-07-2015 / 15:47:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCodeGeneratorTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

