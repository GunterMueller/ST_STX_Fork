"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCTokenizingVisitorTest
	instanceVariableNames:'node result visitor'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Visitors'
!

!PPCTokenizingVisitorTest methodsFor:'as yet unclassified'!

assert: object type: class
    self assert: object class == class
!

setUp
    visitor := PPCTokenizingVisitor new.
!

testTokenNode1
    | nilNode |
    nilNode := PPCCharacterNode new.
    node := PPCTokenNode new
        child: nilNode.
    result := visitor visit: node.
    
    self assert: result type: PPCTokenizingParserNode.
    self assert: result parser type: PPCTokenConsumeNode.
    self assert: result parser child = node.
    
    self assert: result tokens children size = 1.
    self assert: (result tokens children anySatisfy: [ :e | e =  node ]).
!

testTokenizingParserNode
    node := PPCNilNode new.
    result := visitor visit: node.
    
    self assert: result type: PPCTokenizingParserNode.
    self assert: result parser = node.
    self assert: result tokens children size = 0.
!

testTokenizingParserNode2
    | nilNode |
    nilNode := PPCCharacterNode new.
    node := PPCTokenNode new
        child: nilNode.
    result := visitor visit: node.
    
    self assert: result type: PPCTokenizingParserNode.
    self assert: result parser type: PPCTokenConsumeNode.
    self assert: result parser child = node.
    
    self assert: result tokens children size = 1.
    self assert: (result tokens children anySatisfy: [ :e | e =  node ]).
!

testTrimmingTokenNode1
    | nilNode tokenNode |
    nilNode := PPCNilNode new.
    tokenNode := PPCTokenNode new
        child: nilNode.
    node := PPCTrimmingTokenNode new
        child: tokenNode;
        whitespace: nilNode;
        yourself.		
    result := visitor visit: node.
    
    self assert: result type: PPCTokenizingParserNode.
    self assert: result parser type: PPCTokenConsumeNode.
    self assert: result parser child = node.
    
    self assert: result tokens children size = 1.
    self assert: (result tokens children anySatisfy: [ :e | e =  node ]).
! !

