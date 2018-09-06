"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCRegularExpressionNode subclass:#SmaCCSequenceRENode
	instanceVariableNames:'nodes'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Scanner Generator'
!

SmaCCSequenceRENode comment:'SmaCCSequenceRENode represents a regular expression that is made up of several other regular expressions concatenated together.

Instance Variables:
	nodes	<Collection of: SmaCCRegularExpressionNode>	our children nodes in left-to-right order'
!


!SmaCCSequenceRENode class methodsFor:'instance creation'!

nodes: aCollection 
	^(self new)
		nodes: aCollection;
		yourself
! !

!SmaCCSequenceRENode methodsFor:'accessing'!

, aScannerNode 
	self action = aScannerNode action ifFalse: [^super , aScannerNode].
	nodes add: aScannerNode.
	^self
!

possibleMatchesSize
	^nodes inject: 1 into: [:sum :each | sum * each possibleMatchesSize]
! !

!SmaCCSequenceRENode methodsFor:'copying'!

postCopy
	super postCopy.
	nodes := nodes copy
! !

!SmaCCSequenceRENode methodsFor:'initialize-release'!

nodes: aCollection 
	nodes := aCollection
! !

!SmaCCSequenceRENode methodsFor:'printing'!

printOn: aStream 
	nodes do: [:each | each printOn: aStream] separatedBy: [aStream space]
! !

!SmaCCSequenceRENode methodsFor:'private'!

asNFAStartingWith: startNode 
	| endNode |
	endNode := SmaCCNode new.
	endNode action: action.
	(nodes inject: startNode into: [:sum :each | each asNFAStartingWith: sum]) 
		addEdgeTo: endNode.
	^endNode
!

possibleMatchesDo: aBlock on: aStream 
	self 
		possibleMatchesDo: aBlock
		on: aStream
		startingAt: 1
!

possibleMatchesDo: aBlock on: aStream startingAt: anInteger 
	| node |
	node := nodes at: anInteger.
	nodes size = anInteger 
		ifTrue: [node possibleMatchesDo: aBlock on: aStream]
		ifFalse: 
			[node possibleMatchesDo: 
					[self 
						possibleMatchesDo: aBlock
						on: aStream
						startingAt: anInteger + 1]
				on: aStream]
! !

!SmaCCSequenceRENode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCSequenceRENode.st,v 1.1 2006-02-09 21:14:56 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
