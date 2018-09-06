"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPCIdGeneratorTest
	instanceVariableNames:'node id idGen node1 node2 codeGen id1 id2 compiler'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Core'
!

!PPCIdGeneratorTest methodsFor:'tests - ids'!

testId1
    node := PPCNode new
        name: 'foo'.
    idGen := PPCIdGenerator new.
    
    id := idGen idFor: node.
    
    self assert: idGen ids size = 1.
    self assert: id = 'foo'.
!

testId2
    node1 := PPCNode new
        name: 'foo'.
    
    node2 := PPCNode new
        name: 'foo'.
    codeGen := PPCCodeGen new.

    id1 := codeGen idFor: node1.
    self assert: codeGen ids size = 1.
    self assert: id1 = 'foo'.
    
    id2 := codeGen idFor: node2.
    self assert: codeGen ids size = 2.
    self assert: id2 = 'foo_2'.	
            
    self assert: (id1 = id2) not.
!

testId3
    node1 := PPCNode new
        name: 'foo'.
    
    node2 := node1.
    codeGen := PPCCodeGen new.
        
    id1 := codeGen idFor: node1.
    self assert: codeGen ids size = 1.
    self assert: id1 = 'foo'.
    
    id2 := codeGen idFor: node2.
    self assert: codeGen ids size = 1.
    self assert: id2 = 'foo'.	
            
    self assert: (id1 == id2).
!

testId4
    node1 := PPCNode new
        name: 'foo+='.
    
    node2 := PPCNode new
        name: 'foo+='.
    codeGen := PPCCodeGen new.
        
    id1 := codeGen idFor: node1.
    self assert: codeGen ids size = 1.
    self assert: id1 = 'foo'.
    
    id2 := codeGen idFor: node2.
    self assert: codeGen ids size = 2.
    self assert: id2 = 'foo_2'.	
            
    self assert: (id1 = id2) not.
!

testId5
    node1 := PPCNode new
        name: 'foo_bar'.
    
    codeGen := PPCCodeGen new.
        
    id1 := codeGen idFor: node1.
    self assert: codeGen ids size = 1.
    self assert: id1 = 'foo_bar'.
!

testId6
    node1 := PPCNode new
        name: '$''nextToken'.

    node2 := PPCNode new
        name: '$"nextToken'.
    
    codeGen := PPCCodeGen new.
        
    id1 := codeGen idFor: node1.
    self assert: codeGen ids size = 1.
    self assert: id1 = 'nextToken'.
    
    id2 := codeGen idFor: node2.
    self assert: codeGen ids size = 2.
    self assert: id2 = 'nextToken_2'.
! !

