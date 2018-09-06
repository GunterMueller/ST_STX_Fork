"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBValueNode subclass:#RBArrayNode
	instanceVariableNames:'leftBrace rightBrace statements periods'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

!RBArrayNode class methodsFor:'documentation'!

documentation
"
    I represent a squeak constructed array { expr1. expr2. ... exprN }
"
! !

!RBArrayNode class methodsFor:'instance creation'!

leftBrace: leftBrace  rightBrace: rightBrace  statements: statements
	^self new leftBrace: leftBrace  rightBrace: rightBrace  statements: statements
! !

!RBArrayNode methodsFor:'accessing'!

addNode:aRBMessageNode
    statements isNil ifTrue:[ 
        statements := OrderedCollection with: aRBMessageNode.
    ] ifFalse:[ 
        statements add: aRBMessageNode
    ].

    "Created: / 07-10-2014 / 23:37:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

children
	^statements
!

left: leftBrace0
    self leftBrace: leftBrace0

    "Created: / 07-10-2014 / 23:33:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leftBrace: leftBrace0
        leftBrace := leftBrace0.
!

periods
    ^ periods ? #()

    "Modified: / 07-10-2014 / 23:36:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

periods: periods0
    periods := periods0

    "Modified: / 07-10-2014 / 23:36:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

precedence
	^0
!

right: rightBrace0
    self rightBrace: rightBrace0

    "Created: / 07-10-2014 / 23:33:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rightBrace: rightBrace0
        rightBrace := rightBrace0.
!

start
	^leftBrace
!

startWithoutParentheses
    statements isEmptyOrNil ifTrue:[^ leftBrace + 1].
    ^ statements first startWithoutParentheses
!

statements
    ^statements ? #()

    "Modified: / 07-10-2014 / 23:35:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statements:statements0 
    statements := statements0.
    statements do:[:statement | 
        statement parent:self
    ]

    "Modified: / 18-06-2015 / 21:07:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stop
	^rightBrace
!

stopWithoutParentheses
    statements isEmptyOrNil ifTrue:[^ rightBrace - 1].
    ^ statements last stopWithoutParentheses
! !

!RBArrayNode methodsFor:'comparing'!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^statements = anObject statements.
!

hash

	^statements hash.
! !

!RBArrayNode methodsFor:'copying'!

postCopy
        self statements: (statements collect: [ :statement | statement copy ])

    "Modified: / 18-06-2015 / 20:38:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBArrayNode methodsFor:'initialization'!

leftBrace: leftBrace0  rightBrace: rightBrace0  statements: statements0
	leftBrace _ leftBrace0.
	rightBrace _ rightBrace0.
	statements _ statements0.
! !

!RBArrayNode methodsFor:'matching'!

match: aNode inContext: aDictionary 
    aNode class == self class ifFalse: [^ false].
    ^ (self matchList: statements
                against: aNode statements
                inContext: aDictionary).

"/    1 to: statements size do: [:i | 
"/        ((statements at: i) match: (aNode statements at: i) inContext: aDictionary)
"/        ifFalse: [^ false]
"/    ].
"/    ^ true

    "Created: / 14-07-2011 / 17:00:58 / cg"
! !

!RBArrayNode methodsFor:'replacing'!

replaceNode: oldNode  withNode: newNode
	statements _ statements collect: [ :statement |
		statement == oldNode 
			ifTrue: [ newNode ]
			ifFalse: [ statement ] ]
! !

!RBArrayNode methodsFor:'testing'!

isArray
    "/ This is bad...
    ^ true

    "Created: / 07-10-2014 / 23:35:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSqueakArray
    ^ true
!

lastIsReturn
	statements isEmpty ifTrue:[ ^false ].
	^statements last lastIsReturn
! !

!RBArrayNode methodsFor:'visitor'!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor acceptArrayNode: self
! !

!RBArrayNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

