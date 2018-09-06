"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBStatementNode subclass:#RBValueNode
	instanceVariableNames:'parentheses'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBValueNode comment:'BRValueNode is an abstract class that represents a node that returns some value.

Instance Variables:
	parentheses	<SequenceableCollection of: Inteval>	the positions of the parethesis around this node. We need a collection of intervals for stupid code such as "((3 + 4))" that has multiple parethesis around the same expression.

'
!


!RBValueNode methodsFor:'accessing'!

addParenthesis: anInterval 
	parentheses isNil ifTrue: [parentheses := OrderedCollection new: 1].
	parentheses add: anInterval
!

leftMostReceiver
    ^ self
!

parentheses
	^parentheses isNil
		ifTrue: [#()]
		ifFalse: [parentheses]
!

start
        ^parentheses isNil 
                ifTrue: [self startWithoutParentheses]
                ifFalse: [parentheses last first]
!

startWithoutParentheses
	^self subclassResponsibility
!

stop
	^parentheses isNil
		ifTrue: [self stopWithoutParentheses]
		ifFalse: [parentheses last last]
!

stopWithoutParentheses
	^self subclassResponsibility
! !

!RBValueNode methodsFor:'testing'!

containedBy: anInterval 
	^anInterval first <= self startWithoutParentheses 
		and: [anInterval last >= self stopWithoutParentheses]
!

hasParentheses
        ^ parentheses notEmptyOrNil
!

isValue
	^true
! !

!RBValueNode class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

