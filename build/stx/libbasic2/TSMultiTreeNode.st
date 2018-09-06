"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

TSTreeNode subclass:#TSMultiTreeNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered-Trees-Private'
!

Array variableSubclass:#ValueArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TSMultiTreeNode
!


!TSMultiTreeNode methodsFor:'private'!

do: aBlock
    self nodesDo: [:node | 
        node valuesDo: aBlock
    ].

    "Created: / 26-04-2014 / 11:54:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
                                ifTrue: [^ self values ]
                                ifFalse: [^ equal notNil ifTrue: [equal lookupString: aString startingAt: i+1] ifFalse:[nil]]]
                ifFalse:
                        [char < key
                                ifTrue: [^ low notNil ifTrue: [low lookupString: aString startingAt: i] ifFalse:[nil]]
                                ifFalse: [^ high notNil ifTrue: [high lookupString: aString startingAt: i] ifFalse:[nil]]]

    "Created: / 26-04-2014 / 11:50:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookupString: aString startingAt: i insert: anObject
        self
                lookupString: aString
                startingAt: i
                whenFound: [self valueAdd: anObject]
                whenNil: [:c | self newNodeWithKey: c]
                recurseWith: [:node :j | node lookupString: aString startingAt: j insert: anObject]

    "Created: / 26-04-2014 / 11:50:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchesForPrefix: aString startingAt: i do: aBlock
        self
                lookupString: aString
                startingAt: i
                whenFound: [self valuesDo: aBlock.  equal notNil ifTrue: [equal do: aBlock]]
                whenNil: [:c | ^ self]
                recurseWith: [:n :j | n matchesForPrefix: aString startingAt: j do: aBlock]

    "Created: / 26-04-2014 / 11:51:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchesForString: aString startingAt: i distance: d do: aBlock nodesDo: nodeBlock
        
        | char d2 |
        nodeBlock value: self.
        d < 0 ifTrue: [^ self].
        
        char := aString at: i.
        (d > 0 or: [char < key])
                ifTrue: [low notNil ifTrue: [low matchesForString: aString startingAt: i distance: d do: aBlock nodesDo: nodeBlock]].
                
        d2 := char = key ifTrue: [d] ifFalse: [d-1].
        (i + d2 = aString size) ifTrue: [self valuesDo: aBlock].
        equal ifNotNil: [equal matchesForString: aString startingAt: (i+1 min: aString size) distance: d2 do: aBlock nodesDo: nodeBlock].
        
        (d > 0 or: [char > key])
                ifTrue: [high notNil ifTrue: [high matchesForString: aString startingAt: i distance: d do: aBlock nodesDo: nodeBlock]]

    "Created: / 26-04-2014 / 11:51:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TSMultiTreeNode methodsFor:'private-values'!

valueAdd: anObject
    value isNil ifTrue:[ 
        value := anObject.
    ] ifFalse:[
        value class == ValueArray ifTrue:[ 
            (value includes: anObject) ifFalse:[
                value := value copyWith: anObject
            ].
        ] ifFalse:[ 
            value = anObject ifFalse:[
                value := ValueArray with: value with: anObject.
            ].
        ].
    ]

    "Created: / 26-04-2014 / 11:24:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

values
    value isNil ifTrue:[ ^ #() ].

    value class == ValueArray 
        ifTrue:[ ^ value ]
        ifFalse:[ ^ Array with: value ].

    "Created: / 26-04-2014 / 11:50:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

valuesDo: aBlock
    value isNil ifTrue:[ ^ self ].

    value class == ValueArray ifTrue:[ 
        value do: aBlock
    ] ifFalse:[
        aBlock value: value
    ].

    "Created: / 26-04-2014 / 11:51:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TSMultiTreeNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

