"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCRegularExpressionNode subclass:#SmaCCOrRENode
	instanceVariableNames:'nodes'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Scanner Generator'
!

SmaCCOrRENode comment:'SmaCCOrRENode is a SmaCCRegularExpressionNode that represents an alternative.

Instance Variables:
	nodes	<Collection of: SmaCCRegularExpressionNode>	our possible choices'
!


!SmaCCOrRENode class methodsFor:'instance creation'!

nodes: aCollection 
	^(self new)
		nodes: aCollection;
		yourself
! !

!SmaCCOrRENode methodsFor:'accessing'!

possibleMatchesSize
	^nodes inject: 0 into: [:sum :each | sum + each possibleMatchesSize]
!

| aScannerNode 
	self action = aScannerNode action ifFalse: [^super | aScannerNode].
	nodes add: aScannerNode.
	^self
! !

!SmaCCOrRENode methodsFor:'copying'!

postCopy
	super postCopy.
	nodes := nodes copy
! !

!SmaCCOrRENode methodsFor:'initialize-release'!

nodes: aCollection 
	nodes := aCollection
! !

!SmaCCOrRENode methodsFor:'printing'!

printOn: aStream 
	aStream nextPut: $(.
	nodes do: [:each | each printOn: aStream]
		separatedBy: [aStream nextPutAll: ' | '].
	aStream nextPut: $)
! !

!SmaCCOrRENode methodsFor:'private'!

asNFAStartingWith: startNode 
	| endNode |
	endNode := SmaCCNode new.
	endNode action: action.
	nodes do: 
			[:each | 
			| componentStart |
			componentStart := SmaCCNode new.
			startNode addEdgeTo: componentStart.
			(each asNFAStartingWith: componentStart) addEdgeTo: endNode].
	^endNode
!

possibleMatchesDo: aBlock on: aStream 
	nodes do: 
			[:each | 
			| pos |
			pos := aStream position.
			each possibleMatchesDo: aBlock on: aStream.
			aStream position: pos]
! !

!SmaCCOrRENode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCOrRENode.st,v 1.1 2006-02-09 21:16:22 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
