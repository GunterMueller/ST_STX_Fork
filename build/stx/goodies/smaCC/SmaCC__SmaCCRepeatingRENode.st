"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCRegularExpressionNode subclass:#SmaCCRepeatingRENode
	instanceVariableNames:'node minimumMatches maximumMatches'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Scanner Generator'
!

SmaCCRepeatingRENode comment:'SmaCCRepeatingRENode represents a repeating node in a regular expression.

Instance Variables:
	maximumMatches	<Integer>	the minimum number of matches required
	minimumMatches	<Integer>	the maximum number of matches allowed. An infinite amount of matches is represented by (SmaCCRepeatingRENode finiteInfinity).
	node	<SmaCCRegularExpressionNode>	what we need to match'
!


!SmaCCRepeatingRENode class methodsFor:'instance creation'!

component: aScannerNode 
	^self component: aScannerNode minimum: 0
!

component: aScannerNode minimum: anInteger 
	^self 
		component: aScannerNode
		minimum: anInteger
		maximum: self finiteInfinity
!

component: aScannerNode minimum: minInteger maximum: maxInteger 
	^(self new)
		component: aScannerNode
			minimum: minInteger
			maximum: maxInteger;
		yourself
! !

!SmaCCRepeatingRENode class methodsFor:'constants'!

finiteInfinity
	"The number that we consider to be 'infinite'"

	^2147483648
! !

!SmaCCRepeatingRENode methodsFor:'accessing'!

possibleMatchesSize
	^node possibleMatchesSize * (maximumMatches - minimumMatches + 1)
! !

!SmaCCRepeatingRENode methodsFor:'initialize-release'!

component: aScannerNode minimum: minInteger maximum: maxInteger 
	node := aScannerNode.
	minimumMatches := minInteger.
	maximumMatches := maxInteger
! !

!SmaCCRepeatingRENode methodsFor:'printing'!

printOn: aStream 
	node printOn: aStream.
	maximumMatches = (1 bitShift: 31) 
		ifTrue: 
			[minimumMatches = 0 ifTrue: [^aStream nextPut: $*].
			minimumMatches = 1 ifTrue: [^aStream nextPut: $+].
			^aStream
				nextPut: ${;
				nextPutAll: minimumMatches printString;
				nextPutAll: ',}'].
	aStream
		nextPut: ${;
		nextPutAll: minimumMatches printString;
		nextPut: $,;
		nextPutAll: maximumMatches printString;
		nextPut: $}
! !

!SmaCCRepeatingRENode methodsFor:'private'!

asNFAStartingWith: startNode 
	| endNode start |
	endNode := SmaCCNode new.
	endNode action: action.
	start := startNode.
	minimumMatches timesRepeat: [start := node asNFAStartingWith: start].
	start addEdgeTo: endNode.
	maximumMatches < self class finiteInfinity 
		ifTrue: 
			[maximumMatches - minimumMatches timesRepeat: 
					[start := node asNFAStartingWith: start.
					start addEdgeTo: endNode]]
		ifFalse: [(node asNFAStartingWith: start) addEdgeTo: start].
	^endNode
!

possibleMatchesDo: aBlock on: aStream 
	self 
		possibleMatchesDo: aBlock
		on: aStream
		startingAt: 1
!

possibleMatchesDo: aBlock on: aStream startingAt: anInteger 
	(anInteger between: minimumMatches and: maximumMatches) 
		ifTrue: [aBlock value].
	anInteger = maximumMatches 
		ifTrue: [node possibleMatchesDo: aBlock on: aStream]
		ifFalse: 
			[node possibleMatchesDo: 
					[self 
						possibleMatchesDo: aBlock
						on: aStream
						startingAt: anInteger + 1]
				on: aStream]
! !

!SmaCCRepeatingRENode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCRepeatingRENode.st,v 1.1 2006-02-09 21:14:14 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
