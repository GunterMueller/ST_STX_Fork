"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RBProgramNodeVisitor
	instanceVariableNames:'pluggableNodeAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!

RBProgramNodeVisitor comment:'BRProgramNodeVisitor is an abstract visitor for the BRProgramNodes.

'
!

!RBProgramNodeVisitor class methodsFor:'documentation'!

documentation
"
    BRProgramNodeVisitor is an abstract visitor for the BRProgramNodes.

    cg: I have made it half-concrete, by allowing for a node-action to be
    set. This allows for very lightweight use in search for something applications.
"
! !

!RBProgramNodeVisitor class methodsFor:'instance creation'!

new
        ^self basicNew initialize
! !

!RBProgramNodeVisitor methodsFor:'accessing'!

pluggableNodeAction:something
    pluggableNodeAction := something.
! !

!RBProgramNodeVisitor methodsFor:'copying'!

copy
	"Here since IBM doesn't do postCopy's"

	^self shallowCopy postCopy
!

postCopy
! !

!RBProgramNodeVisitor methodsFor:'initialize-release'!

initialize
! !

!RBProgramNodeVisitor methodsFor:'visiting'!

visitArgument: each 
	"Here to allow subclasses to detect arguments or temporaries."

	^self visitNode: each
!

visitArguments: aNodeCollection 
	^aNodeCollection do: [:each | self visitArgument: each]
!

visitNode: aNode 
	^aNode acceptVisitor: self
! !

!RBProgramNodeVisitor methodsFor:'visitor-double dispatching'!

acceptArrayNode: anArrayNode
    "that's a squeak constructed array"

    self passByNode:anArrayNode.
    anArrayNode statements do: [:each | self visitNode: each]
!

acceptAssignmentNode: anAssignmentNode 
    self passByNode:anAssignmentNode.
    self visitNode: anAssignmentNode variable.
    self visitNode: anAssignmentNode value
!

acceptBlockNode: aBlockNode 
    self passByNode:aBlockNode.
    self visitArguments: aBlockNode arguments.
    self visitNode: aBlockNode body
!

acceptCascadeNode: aCascadeNode 
    self passByNode:aCascadeNode.
    aCascadeNode messages do: [:each | self visitNode: each]
!

acceptLiteralNode: aLiteralNode
    self passByNode:aLiteralNode.
!

acceptMessageNode: aMessageNode 
    self passByNode:aMessageNode.
    (aMessageNode isCascaded not or: [aMessageNode isFirstCascaded]) 
            ifTrue: [self visitNode: aMessageNode receiver].
    aMessageNode arguments do: [:each | self visitNode: each]
!

acceptMethodNode: aMethodNode 
    self passByNode:aMethodNode.
    aMethodNode pragmas do:[:pragma | self visitNode: pragma ].
    self visitArguments: aMethodNode arguments.
    self visitNode: aMethodNode body

    "Modified: / 22-09-2015 / 18:00:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

acceptOptimizedNode: anOptimizedNode 
    self passByNode:anOptimizedNode.
    self visitNode: anOptimizedNode body
!

acceptPragmaNode: aPragmaNode
    self passByNode:aPragmaNode.

    "Created: / 07-10-2014 / 23:43:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

acceptReturnNode: aReturnNode 
    self passByNode:aReturnNode.
    self visitNode: aReturnNode value
!

acceptSTXPrimitiveCCodeNode: aPrimitiveCCodeNode
    self passByNode:aPrimitiveCCodeNode.
!

acceptSTXPrimitiveValueCCodeNode: aPrimitiveValueCCodeNode
    self passByNode:aPrimitiveValueCCodeNode.
!

acceptSequenceNode: aSequenceNode 
    self passByNode:aSequenceNode.
    self visitArguments: aSequenceNode temporaries.
    aSequenceNode statements do: [:each | self visitNode: each]
!

acceptVariableNode: aVariableNode
    self passByNode:aVariableNode.
!

passByNode: aNode
    "called when we passed by some node, aNode.
     Can be redefined in a subclass to track any visited node
     (without a need to redefine all of the accept***Node methods) in a subclass"

    pluggableNodeAction notNil ifTrue:[
        pluggableNodeAction value:aNode
    ].
! !

!RBProgramNodeVisitor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

