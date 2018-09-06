"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCJavaTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Java'
!

!PPCJavaTests methodsFor:'as yet unclassified'!

javaWsNode
    ^ PPCUnknownNode new
        parser: PPJavaWhitespaceParser new;
        yourself
!

testJavaWS
    | node1 node2 node visitor |
    node1 := self javaWsNode.
    node2 := self javaWsNode.
    
    node := PPCSequenceNode new
        children: { node1 . node2 }.

    visitor := PPCMergingVisitor new.
        
    self assert: (node children first == node children second) not.
    node := visitor visit: node.
    self assert: (node children first == node children second).
! !

