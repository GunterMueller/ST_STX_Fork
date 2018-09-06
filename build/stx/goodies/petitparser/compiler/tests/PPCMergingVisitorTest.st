"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCMergingVisitorTest
	instanceVariableNames:'node result visitor node1 node2'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Visitors'
!


!PPCMergingVisitorTest methodsFor:'as yet unclassified'!

nilNode
    ^ PPCNilNode new
!

setUp
    visitor := PPCMergingVisitor new
!

testNilNode
    node1 := self nilNode.
    node2 := self nilNode.
    
    node := PPCSequenceNode new
        children: { node1 . node2 }.
        
    self assert: (node children first == node children second) not.
    node := visitor visit: node.
    self assert: (node children first == node children second).
!

testNilNode2
    node1 := self nilNode
        name: #foo;
        yourself.
    node2 := self nilNode
        name: #bar;
        yourself.
    
    node := PPCSequenceNode new
        children: { node1 . node2 }.
        
    self assert: (node children first == node children second) not.
    node := visitor visit: node.
    self assert: (node children first == node children second) not.
! !

!PPCMergingVisitorTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

