"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBValueNode subclass:#RBOptimizedNode
	instanceVariableNames:'left right body'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBOptimizedNode comment:'BROptimizedNode is an AST node that represents IBM''s ##(...) expressions. These expressions are evaluated at compile time and directly inserted into the method.

Instance Variables:
	body	<BRSequenceNode>	the body of the expression
	left	<Integer>	position of the ##( characters
	right	<Integer>	position of )

'
!


!RBOptimizedNode class methodsFor:'instance creation'!

body: aSequenceNode 
	^self new body: aSequenceNode
!

left: leftInteger body: aSequenceNode right: rightInteger 
	^self new
		left: leftInteger
		body: aSequenceNode
		right: rightInteger
! !

!RBOptimizedNode methodsFor:'accessing'!

body
	^body
!

body: stmtsNode 
	body := stmtsNode.
	body parent: self
!

children
	^Array with: body
!

precedence
	^0
!

startWithoutParentheses
	^left
!

stopWithoutParentheses
	^right
! !

!RBOptimizedNode methodsFor:'comparing'!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^self body = anObject body
!

equalTo: anObject withMapping: aDictionary 
        "return true, if I am equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        ^self body equalTo: anObject body withMapping: aDictionary
!

equalTo: anObject withSelectorMapping: aDictionary 
        "return true, if I am equal to another node, with a given selector name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        ^self body equalTo: anObject body withSelectorMapping: aDictionary
!

hash
	^self body hash
!

semanticallyEqualTo: anObject withMapping: aDictionary 
        "return true, if I am semantically equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        ^self body semanticallyEqualTo: anObject body withMapping: aDictionary
! !

!RBOptimizedNode methodsFor:'enumeration'!

variableNodesDo:aBlock
    "evaluate a Block for all variable nodes"

    body variableNodesDo:aBlock.
! !

!RBOptimizedNode methodsFor:'initialize-release'!

left: leftInteger body: aSequenceNode right: rightInteger 
	left := leftInteger.
	self body: aSequenceNode.
	right := rightInteger
! !

!RBOptimizedNode methodsFor:'matching'!

copyInContext: aDictionary 
	^self class body: (body copyInContext: aDictionary)
!

match: aNode inContext: aDictionary 
	aNode class == self class ifFalse: [^false].
	^body match: aNode body inContext: aDictionary
! !

!RBOptimizedNode methodsFor:'replacing'!

replaceNode: aNode withNode: anotherNode 
	body == aNode ifTrue: [self body: anotherNode]
! !

!RBOptimizedNode methodsFor:'testing'!

isImmediate
	^true
! !

!RBOptimizedNode methodsFor:'visitor'!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptOptimizedNode: self
! !

!RBOptimizedNode class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

