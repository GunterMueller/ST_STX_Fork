"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCRegularExpressionNode
	instanceVariableNames:'action position'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Scanner Generator'
!

SmaCCRegularExpressionNode comment:'SmaCCRegularExpressionNode represents a regular expression. The scanner is represented by a regular expression. These are the initial objects created in producing the scanner. From these nodes, we create a directed graph and then we compile the graph.

Subclasses must implement the following messages:
	accessing
		possibleMatchesSize
	private
		asNFAStartingWith:
		possibleMatchesDo:on:

Instance Variables:
	action	<SequenceableCollection>	the actions to be performed when we find a match
	position	<Integer>	the position of the RE in the scanner. If we have multiple matches, we prefer the ones listed first.'
!


!SmaCCRegularExpressionNode class methodsFor:'instance creation'!

new
	^(super new)
		initialize;
		yourself
! !

!SmaCCRegularExpressionNode methodsFor:'accessing'!

, aScannerNode 
	^SmaCCSequenceRENode nodes: (OrderedCollection with: self with: aScannerNode)
!

position
	^position
!

position: anInteger
	position := anInteger
!

possibleMatches
	| matches |
	matches := OrderedCollection new.
	self possibleMatchesDo: [:each | matches add: each].
	^matches
!

possibleMatchesDo: aBlock 
	| stream |
	stream := WriteStream on: String new.
	self possibleMatchesDo: [aBlock value: stream contents] on: stream
!

possibleMatchesSize
	^self subclassResponsibility
!

repeat
	^SmaCCRepeatingRENode component: self
!

repeatFor: minimum to: maximum 
	^SmaCCRepeatingRENode 
		component: self
		minimum: minimum
		maximum: maximum
!

repeatForAtLeast: minimum 
	^SmaCCRepeatingRENode component: self minimum: minimum
!

| aScannerNode 
	^SmaCCOrRENode nodes: (OrderedCollection with: self with: aScannerNode)
! !

!SmaCCRegularExpressionNode methodsFor:'converting'!

asDFA
	| startNode |
	startNode := SmaCCNode new.
	self asNFAStartingWith: startNode.
	^startNode asNFAWithoutEpsilonTransitions asDFA
! !

!SmaCCRegularExpressionNode methodsFor:'initialize-release'!

action
	^action
!

action: aString
	action := aString
!

initialize
! !

!SmaCCRegularExpressionNode methodsFor:'private'!

asNFAStartingWith: startNode 
	^self subclassResponsibility
!

possibleMatchesDo: aBlock on: aStream 
	self subclassResponsibility
! !

!SmaCCRegularExpressionNode methodsFor:'public'!

isKeywordLiteral
	self possibleMatchesSize < 50 ifFalse: [^false].
	self possibleMatchesDo: 
			[:each | 
			(each allSatisfy: [:char | char isAlphaNumeric or: [char == $_]]) 
				ifFalse: [^false]].
	^true
! !

!SmaCCRegularExpressionNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCRegularExpressionNode.st,v 1.1 2006-02-09 21:15:38 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
