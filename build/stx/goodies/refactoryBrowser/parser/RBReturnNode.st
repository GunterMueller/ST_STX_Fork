"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBStatementNode subclass:#RBReturnNode
	instanceVariableNames:'return value'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBReturnNode comment:'BRReturnNode is an AST node that represents a return expression.

Instance Variables:
	return	<Integer>	the position of the ^ character
	value	<BRValueNode>	the value that is being returned

'
!


!RBReturnNode class methodsFor:'instance creation'!

return: returnInteger value: aValueNode 
	^self new return: returnInteger value: aValueNode
!

value: aNode
	^self return: nil value: aNode
! !

!RBReturnNode methodsFor:'accessing'!

children
	^Array with: value
!

return
    ^ return
!

return:anInteger
    return := anInteger.
!

start
	^return
!

stop
	^value stop
!

stopWithoutParentheses
        ^value stopWithoutParentheses
!

value
	^value
!

value: valueNode 
	value := valueNode.
	value parent: self
! !

!RBReturnNode methodsFor:'comparing'!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^self value = anObject value
!

equalTo: anObject withMapping: aDictionary 
        "return true, if I am equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        ^self value equalTo: anObject value withMapping: aDictionary
!

equalTo: anObject withSelectorMapping: aDictionary 
        "return true, if I am equal to another node, with a given selector name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        ^self value equalTo: anObject value withSelectorMapping: aDictionary
!

hash
	^self value hash
!

semanticallyEqualTo: anObject withMapping: aDictionary 
        "return true, if I am semantically equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        ^self value semanticallyEqualTo: anObject value withMapping: aDictionary
! !

!RBReturnNode methodsFor:'copying'!

postCopy
        super postCopy.
        self value: value copy

    "Modified: / 18-06-2015 / 20:38:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBReturnNode methodsFor:'enumeration'!

allReturnNodesDo:aBlock
    "evaluate a Block for all return nodes"

    value allReturnNodesDo: aBlock.
    aBlock value:self.
!

variableNodesDo:aBlock
    "evaluate a Block for all variable nodes"

    value variableNodesDo: aBlock
! !

!RBReturnNode methodsFor:'initialization & release'!

return: returnInteger value: aValueNode 
	return := returnInteger.
	self value: aValueNode
! !

!RBReturnNode methodsFor:'matching'!

copyInContext: aDictionary 
	^(self class new) value: (value copyInContext: aDictionary); yourself
!

match: aNode inContext: aDictionary 
	aNode class == self class ifFalse: [^false].
	^value match: aNode value inContext: aDictionary
! !

!RBReturnNode methodsFor:'queries'!

lastLineNumber
    ^ value lastLineNumber
! !

!RBReturnNode methodsFor:'replacing'!

replaceNode: aNode withNode: anotherNode 
	value == aNode ifTrue: [self value: anotherNode]
! !

!RBReturnNode methodsFor:'testing'!

containsReturn
	^true
!

isReturn
	^true
! !

!RBReturnNode methodsFor:'visitor'!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptReturnNode: self
! !

!RBReturnNode class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

