"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCRewritingVisitor subclass:#PPCMergingVisitor
	instanceVariableNames:'nodeSet'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!

!PPCMergingVisitor methodsFor:'as yet unclassified'!

equivalentNode: node
    ^  nodeSet detect: [ :e | e = node ]
!

hasEquivalentNode: node
    ^ nodeSet includes: node
!

initialize
    super initialize.
    
    nodeSet := Set new
!

store: node
    self assert: (self hasEquivalentNode: node) not.
    nodeSet add: node
!

visitNode: node
    super visitNode: node.
    
    (self hasEquivalentNode: node) ifTrue: [
        self change.
        ^ self equivalentNode: node
    ] ifFalse: [  
        self store: node
    ].

    ^ node
! !

