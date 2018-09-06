"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBValueNode subclass:#RBAssignmentNode
	instanceVariableNames:'variable assignment value assignmentToken'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBAssignmentNode comment:'BRAssignmentNode is an AST node for assignment statements

Instance Variables:
	assignment	<Integer>	position of the :=
	value	<BRValueNode>	the value that we''re assigning
	variable	<BRVariableNode>	the variable being assigned

'
!


!RBAssignmentNode class methodsFor:'instance creation'!

variable: aVariableNode value: aValueNode 
	^self 
		variable: aVariableNode
		value: aValueNode
		position: nil
!

variable: aVariableNode value: aValueNode position: anInteger 
	^self new
		variable: aVariableNode
		value: aValueNode
		position: anInteger
! !

!RBAssignmentNode methodsFor:'accessing'!

allAssignmentNodes
        ^(super allAssignmentNodes)
                add: self;
                yourself
!

assignment
    ^ assignment
!

allAssignmentNodesDo:aBlock
    value allAssignmentNodesDo:aBlock. "/ assignments on the right side
    aBlock value:self

    "Created: / 01-05-2016 / 09:58:54 / cg"
!

assignmentOperator
    (assignmentToken notNil and:[assignmentToken isOldStyleAssignment]) ifTrue:[^ '_' ].
    ^ ':='

    "Modified: / 15-03-2016 / 14:24:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

assignmentToken
    ^ assignmentToken
!

assignmentToken:aToken
    assignmentToken := aToken.
!

children
	^Array with: value with: variable
!

precedence
	^5
!

startWithoutParentheses
	^variable start
!

stopWithoutParentheses
	^value stop
!

value
	^value
!

value: aValueNode 
	value := aValueNode.
	value parent: self
!

variable
	^variable
!

variable: varNode 
	variable := varNode.
	variable parent: self
! !

!RBAssignmentNode methodsFor:'comparing'!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^self variable = anObject variable and: [self value = anObject value]
!

equalTo: anObject withMapping: aDictionary
        "return true, if I am equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        ^(self variable equalTo: anObject variable withMapping: aDictionary)
                and: [self value equalTo: anObject value withMapping: aDictionary]
!

equalTo: anObject withSelectorMapping: aDictionary
        "return true, if I am equal to another node, with a given selector name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        (self variable = anObject variable) ifFalse: [^false].
        ^ self value equalTo: anObject value withSelectorMapping: aDictionary
!

hash
	^self variable hash bitXor: self value hash
!

semanticallyEqualTo: anObject withMapping: aDictionary
        "return true, if I am semantically equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        ^(self variable semanticallyEqualTo: anObject variable withMapping: aDictionary)
                and: [self value semanticallyEqualTo: anObject value withMapping: aDictionary]
! !

!RBAssignmentNode methodsFor:'copying'!

postCopy
    super postCopy.
    self variable: variable copy.
    self value: value copy

    "Modified: / 28-07-2015 / 06:24:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBAssignmentNode methodsFor:'enumeration'!

variableNodesDo:aBlock
    "evaluate a Block for all variable nodes"

    variable isPatternNode ifFalse:[ aBlock value:variable ].
    value variableNodesDo: aBlock

    "Modified: / 16-11-2016 / 18:53:44 / cg"
! !

!RBAssignmentNode methodsFor:'initialization & release'!

variable: aVariableNode value: aValueNode position: anInteger 
	self variable: aVariableNode.
	self value: aValueNode.
	assignment := anInteger
! !

!RBAssignmentNode methodsFor:'matching'!

copyInContext: aDictionary 
	^(self class new) variable: (variable copyInContext: aDictionary);
		value: (value copyInContext: aDictionary);
		yourself
!

match: aNode inContext: aDictionary 
    aNode class == self class ifFalse: [^false].
    (variable match: aNode variable inContext: aDictionary) ifFalse: [^false].
    ^ value match: aNode value inContext: aDictionary

    "Modified: / 19-11-2016 / 15:55:59 / cg"
! !

!RBAssignmentNode methodsFor:'querying'!

bestNodeFor: anInterval 
	(self intersectsInterval: anInterval) ifFalse: [^nil].
	(self containedBy: anInterval) ifTrue: [^self].
	assignment isNil ifTrue: [^super bestNodeFor: anInterval].
	((anInterval first between: assignment and: assignment + 1) 
		or: [assignment between: anInterval first and: anInterval last]) 
			ifTrue: [^self].
	self children do: 
			[:each | 
			| node |
			node := each bestNodeFor: anInterval.
			node notNil ifTrue: [^node]]
!

firstLineNumber
    ^ variable lineNumber
!

lastLineNumber
    ^ value lastLineNumber
! !

!RBAssignmentNode methodsFor:'replacing'!

replaceNode: aNode withNode: anotherNode 
	value == aNode ifTrue: [self value: anotherNode].
	variable == aNode ifTrue: [self variable: anotherNode]
! !

!RBAssignmentNode methodsFor:'testing'!

assigns: aVariableName 
	^variable name = aVariableName or: [value assigns: aVariableName]
!

directlyUses: aNode 
	^aNode = value ifTrue: [true] ifFalse: [self isDirectlyUsed]
!

isAssignment
	^true
!

reads: variableName
    ^value reads: variableName

    "Created: / 06-09-2012 / 17:17:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

uses: aNode 
	^aNode = value ifTrue: [true] ifFalse: [self isUsed]
! !

!RBAssignmentNode methodsFor:'visiting'!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptAssignmentNode: self
! !

!RBAssignmentNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

