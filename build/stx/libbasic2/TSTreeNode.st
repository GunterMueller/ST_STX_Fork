"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#TSTreeNode
	instanceVariableNames:'key value low high equal'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered-Trees-Private'
!

!TSTreeNode class methodsFor:'documentation'!

documentation
"
    [author:]
        Avi Bryant

    [license:]
        Dual licensed under both SqueakL and MIT. 
        This enables both base Squeak inclusion and 100% reuse.
"
! !

!TSTreeNode class methodsFor:'as yet unclassified'!

key: aCharacter
	^ self basicNew initializeWithKey: aCharacter
! !

!TSTreeNode methodsFor:'private'!

canBeCulled
        ^ self value isNil
            and: [low isNil
            and: [equal isNil
            and: [high isNil]]]
!

cullNode: aNode
	low == aNode ifTrue: [^ low _ nil].
	equal == aNode ifTrue: [^ equal _ nil].
	high == aNode ifTrue: [^ high _ nil]
!

do: aBlock
    self nodesDo: [:ea | 
        |t|

        (t := ea value) notNil ifTrue:[
            aBlock value:t
        ]
    ].
!

initializeWithKey: aCharacter
	key _ aCharacter
!

lookupString: aString startingAt: i
"inlined for performance"
"
        self
                lookupString: aString
                startingAt: i
                whenFound: [^ value]
                whenNil: [:c | ^ nil]
                recurseWith: [:node :j | ^ node lookupString: aString startingAt: j]"
        | char |
        char := aString at: i.
        char = key
                ifTrue:
                        [aString size = i
                                ifTrue: [^ value]
                                ifFalse: [^ equal notNil ifTrue: [equal lookupString: aString startingAt: i+1] ifFalse:[nil]]]
                ifFalse:
                        [char < key
                                ifTrue: [^ low notNil ifTrue: [low lookupString: aString startingAt: i] ifFalse:[nil]]
                                ifFalse: [^ high notNil ifTrue: [high lookupString: aString startingAt: i] ifFalse:[nil]]]

    "Modified: / 08-08-2010 / 15:18:03 / cg"
!

lookupString: aString startingAt: i insert: anObject
	self
		lookupString: aString
		startingAt: i
		whenFound: [self value: anObject]
		whenNil: [:c | self newNodeWithKey: c]
		recurseWith: [:node :j | node lookupString: aString startingAt: j insert: anObject]
!

lookupString: aString startingAt: i whenFound: foundBlock whenNil: nilBlock recurseWith: recurseBlock
	| char |
	char := aString at: i.
	char = key
		ifTrue:
			[aString size = i
				ifTrue: [foundBlock value]
				ifFalse: [equal ifNil: [equal := nilBlock value: (aString at: i+1)].
						 recurseBlock value: equal value: i+1]]
		ifFalse:
			[char < key
				ifTrue: [low ifNil: [low := nilBlock value: char].
						recurseBlock value: low value: i]
				ifFalse: [high ifNil: [high := nilBlock value: char].
						recurseBlock value: high value: i]]
!

matchesForPrefix: aString startingAt: i do: aBlock
        self
                lookupString: aString
                startingAt: i
                whenFound: [value notNil ifTrue: [aBlock value: value].  equal notNil ifTrue: [equal do: aBlock]]
                whenNil: [:c | ^ self]
                recurseWith: [:n :j | n matchesForPrefix: aString startingAt: j do: aBlock]

    "Modified: / 08-08-2010 / 15:18:44 / cg"
!

matchesForString: aString startingAt: i distance: d do: aBlock nodesDo: nodeBlock
        
        | char d2 |
        nodeBlock value: self.
        d < 0 ifTrue: [^ self].
        
        char := aString at: i.
        (d > 0 or: [char < key])
                ifTrue: [low notNil ifTrue: [low matchesForString: aString startingAt: i distance: d do: aBlock nodesDo: nodeBlock]].
                
        d2 := char = key ifTrue: [d] ifFalse: [d-1].
        (i + d2 = aString size and: [value notNil]) ifTrue: [aBlock value: value].
        equal ifNotNil: [equal matchesForString: aString startingAt: (i+1 min: aString size) distance: d2 do: aBlock nodesDo: nodeBlock].
        
        (d > 0 or: [char > key])
                ifTrue: [high notNil ifTrue: [high matchesForString: aString startingAt: i distance: d do: aBlock nodesDo: nodeBlock]]

    "Modified: / 08-08-2010 / 15:18:57 / cg"
!

newNodeWithKey: aCharacter
	^ self class key: aCharacter
!

nodesDo: aBlock
        aBlock value: self.
        low notNil ifTrue: [low nodesDo: aBlock].
        equal notNil ifTrue: [equal nodesDo: aBlock].
        high notNil ifTrue: [high nodesDo: aBlock]

    "Modified: / 08-08-2010 / 15:19:05 / cg"
!

removeString: aString startingAt: i
	| val |
	self
		lookupString: aString
		startingAt: i
		whenFound: [val _ self value. self value: nil]
		whenNil: [:c | ^ nil]
		recurseWith:
			[:node :j |
			val _ node removeString: aString startingAt: j.
			node canBeCulled ifTrue:
				[self cullNode: node]].
	^ val
!

value
	^ value
!

value: anObject
	value _ anObject
! !

!TSTreeNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

