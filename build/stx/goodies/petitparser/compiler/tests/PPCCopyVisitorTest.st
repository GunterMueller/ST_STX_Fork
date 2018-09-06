"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCCopyVisitorTest
	instanceVariableNames:'node result visitor'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Visitors'
!


!PPCCopyVisitorTest methodsFor:'as yet unclassified'!

assert: object equal: anotherObject
    self assert: object = anotherObject 
!

assert: object identical: anotherObject
    self assert: (object == anotherObject)
!

assert: object notIdentical: anotherObject
    self assert: (object == anotherObject) not
!

setUp
    visitor := PPCCopyVisitor new
!

testCopy1
    node := PPCNilNode new.
    result := visitor visit: node.
    
    self assert: node equal: result.
    self assert: node notIdentical: result
!

testCopy2
    | nilNode |
    nilNode := PPCNilNode new.
    node := PPCForwardNode new
        child: nilNode;
        yourself.
    
    result := visitor visit: node.
    
    self assert: result notIdentical: node.
    self assert: result equal: node.	
    self assert: result child notIdentical: node child.
    self assert: result child equal: node child.		

    self assert: node child identical: nilNode.
!

testCopyCycle
    |  forwardNode |
    forwardNode := PPCForwardNode new
        child: nil;
        yourself.
    node := PPCForwardNode new
        child: forwardNode;
        yourself.
    forwardNode child: node.
    
    result := visitor visit: node.
    
    self assert: (result == node) not.
    self assert: (result = node).	
    self assert: (result child == node child) not.
    self assert: (result child = node child).	
        
    self assert: node child == forwardNode.
    self assert: forwardNode child == node.	
!

testCopyProperties
    node := PPCNilNode new.
    node propertyAt: #foo put: #bar.
    self assert: (node propertyAt: #foo) = #bar.
    
    
    result := visitor visit: node.
    self assert: node equal: result.
    self assert: (node propertyAt: #foo) = #bar.
    self assert: (result propertyAt: #foo) = #bar.
    
    result propertyAt: #bar put: #foo.
    self assert: (node propertyAt: #bar) isNil.
    self assert: (result propertyAt: #bar) = #foo.
    
! !

!PPCCopyVisitorTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

