"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBProgramNode subclass:#RBSequenceNode
	instanceVariableNames:'leftBar rightBar statements periods temporaries
		commentsAfterRightBar'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBSequenceNode comment:'BRSequenceNode is an AST node that represents a sequence of statements. Both BRBlockNodes and BRMethodNodes contain these.

Instance Variables:
	leftBar <Integer | nil> the position of the left | in the temporaries definition
	periods <SequenceableCollection of: Integer>    the positions of all the periods that separate the statements
	rightBar        <Integer | nil> the position of the right | in the temporaries definition
	statements      <SequenceableCollection of: BRStatementNode>    the statement nodes
	temporaries     <SequenceableCollection of: BRVariableNode>     the temporaries defined

'
!


!RBSequenceNode class methodsFor:'instance creation'!

leftBar: leftInteger temporaries: variableNodes rightBar: rightInteger 
	^self new
		leftBar: leftInteger
		temporaries: variableNodes
		rightBar: rightInteger
!

new
    "return an initialized instance"

    ^ self basicNew initialize.
!

statements: statementNodes 
	^self temporaries: #() statements: statementNodes
!

temporaries: variableNodes statements: statementNodes 
	^(self new)
		temporaries: variableNodes;
		statements: statementNodes;
		yourself
! !

!RBSequenceNode methodsFor:'accessing'!

addNode: aNode 
	aNode parent: self.
	(statements isEmpty not and: [statements last isReturn])
		ifTrue: [self error: 'Cannot add statement after return node'].
	statements := statements asOrderedCollection add: aNode; yourself
!

addReturn
	| node |
	statements isEmpty ifTrue: [^nil].
	statements last isReturn ifTrue: [^statements last].
	node := RBReturnNode value: statements last.
	statements at: statements size put: node.
	node parent: self.
	^node
!

allDefinedVariables
	^(self temporaryNames asOrderedCollection) addAll: super allDefinedVariables;
		yourself
!

allTemporaryVariables
	^(self temporaryNames asOrderedCollection)
		addAll: super allTemporaryVariables;
		yourself
!

allVariablesOnScope
        ^(super allVariablesOnScope asOrderedCollection) addAll: self temporaryNames;
                yourself
!

children
    |coll temps stats|

    coll := OrderedCollection new.
    (temps := self temporaries) notEmptyOrNil ifTrue:[
        coll addAll:temps
    ].
    (stats := self statements) notEmptyOrNil ifTrue:[
        coll addAll:stats
    ].
    ^ coll
!

commentsAfterRightBar
    ^ commentsAfterRightBar
!

commentsAfterRightBar:something
    something notEmptyOrNil ifTrue:[
        commentsAfterRightBar notEmptyOrNil ifTrue:[
            self halt:'oops - multiple comments'
        ].
        commentsAfterRightBar := something.
    ]
!

leftBar
    ^ leftBar
!

periods
        ^ periods

    "Created: / 05-09-2011 / 23:15:50 / cg"
!

periods: anObject
	periods := anObject
!

removeTemporaryNamed: aName 
	temporaries := temporaries reject: [:each | each name = aName]
!

rightBar
    ^ rightBar
!

start
        ^leftBar isNil 
                ifTrue: [statements isEmptyOrNil ifTrue: [1] ifFalse: [statements first start]]
                ifFalse: [leftBar]
!

statements
	^statements
!

statements: stmtCollection 
	statements := stmtCollection.
	statements do: [:each | each parent: self]
!

stop
        ^(periods isEmptyOrNil
                ifTrue: [0]
                ifFalse: [periods last])
                max: (statements isEmptyOrNil
                                ifTrue: [0]
                                ifFalse: [statements last stop])
!

temporaries
	^temporaries
!

temporaries: tempCollection 
	temporaries := tempCollection.
	temporaries do: [:each | each parent: self]
!

temporaryNames
	^temporaries collect: [:each | each name]
!

temporaryVariables
	^(super temporaryVariables asOrderedCollection) addAll: self temporaryNames;
		yourself
!

whichNodeIsContainedBy: anInterval 
	| node |
	node := super whichNodeIsContainedBy: anInterval.
	node == self 
		ifTrue: 
			[(temporaries isEmpty and: [statements size == 1]) 
				ifTrue: [^statements first]].
	^node
! !

!RBSequenceNode methodsFor:'adding nodes'!

addNode: aNode before: anotherNode 
	| index |
	index := self indexOfNode: anotherNode.
	index = 0 ifTrue: [^self addNode: aNode].
	statements := (statements asOrderedCollection)
				add: aNode beforeIndex: index;
				yourself.
	aNode parent: self
!

addNodeFirst: aNode 
	aNode parent: self.
	statements := (statements asOrderedCollection)
				addFirst: aNode;
				yourself
!

addNodes: aCollection 
	aCollection do: [:each | each parent: self].
	(statements isEmpty not and: [statements last isReturn]) 
		ifTrue: [self error: 'Cannot add statement after return node'].
	statements := (statements asOrderedCollection)
				addAll: aCollection;
				yourself
!

addNodes: aCollection before: anotherNode 
	aCollection do: [:each | self addNode: each before: anotherNode]
!

addNodesFirst: aCollection 
	aCollection do: [:each | each parent: self].
	statements := (statements asOrderedCollection)
				addAllFirst: aCollection;
				yourself
!

addSelfReturn
	| node |
	self lastIsReturn ifTrue: [^self].
	node := RBReturnNode value: (RBVariableNode named: 'self').
	self addNode: node
!

addTemporariesNamed: aCollection 
	aCollection do: [:each | self addTemporaryNamed: each]
!

addTemporaryNamed: aString 
	| variableNode |
	variableNode := RBVariableNode named: aString.
	variableNode parent: self.
	temporaries := temporaries copyWith: variableNode
! !

!RBSequenceNode methodsFor:'comparing'!

= anObject 
	"Can't send = to the temporaries and statements collection since they might change from arrays to OCs"

	|s1 s2|

	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	self temporaries size = anObject temporaries size ifFalse: [^false].
	1 to: self temporaries size
		do: 
			[:i | 
			(self temporaries at: i) = (anObject temporaries at: i) ifFalse: [^false]].
	self statements size = anObject statements size ifFalse: [^false].
	1 to: self statements size
		do: [:i | |same|
			  s1 := (self statements at: i).
			  s2 := (anObject statements at: i).
			  same := (s1 = s2).
			  same ifFalse: [^false]].
	^true
!

equalTo: anObject withMapping: aDictionary 
        "return true, if I am equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        self statements size == anObject statements size ifFalse: [^false].
        1 to: self statements size do: [:i | 
            ((self statements at: i) 
                    equalTo: (anObject statements at: i)
                    withMapping: aDictionary
            ) ifFalse: [
                ^false
            ]
        ].
        aDictionary values asSet size = aDictionary size ifFalse: [^false].     "Not a one-to-one mapping"
        self temporaries do: [:each | 
            aDictionary removeKey: each name ifAbsent: []
        ].
        ^true
!

equalTo: anObject withSelectorMapping: aDictionary 
        "return true, if I am equal to another node, with a given selector name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        self statements size == anObject statements size ifFalse: [^false].
        1 to: self statements size
                do: 
                        [:i | 
                        ((self statements at: i) equalTo: (anObject statements at: i)
                                withSelectorMapping: aDictionary) ifFalse: [^false]].
        aDictionary values asSet size = aDictionary size ifFalse: [^false].     "Not a one-to-one mapping"
        ^true
!

hash
	^self temporaries hash bitXor: (self statements isEmpty
			ifTrue: [0]
			ifFalse: [self statements first hash])
!

semanticallyEqualTo: anObject withMapping: aDictionary 
    "return true, if I am semantically equal to another node, with a given variable name mapping.
     Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

    |myStatements otherStatements|

    self class = anObject class ifFalse: [^false].
    myStatements := self statements.
    otherStatements := anObject statements.
    myStatements size == otherStatements size ifFalse: [^false].
    
    myStatements with:otherStatements do: [:eachMyStatement :eachOtherStatement | 
        (eachMyStatement semanticallyEqualTo: eachOtherStatement withMapping: aDictionary) ifFalse: [
            ^ false
        ]
    ].
    aDictionary values asSet size = aDictionary size ifFalse: [^false].     "Not a one-to-one mapping"
    self temporaries do: [:each | 
        aDictionary removeKey: each name ifAbsent: []
    ].
    ^true
! !

!RBSequenceNode methodsFor:'copying'!

postCopy
        super postCopy.
        self temporaries: (temporaries collect: [:each | each copy]).
        self statements: (statements collect: [:each | each copy])

    "Modified: / 18-06-2015 / 20:36:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBSequenceNode methodsFor:'enumeration'!

variableNodesDo:aBlock
    "evaluate a Block for all variable nodes"

    temporaries notNil ifTrue:[ 
        temporaries do:[:each |
            each isPatternNode ifFalse:[ aBlock value:each ]
        ]
    ].
    statements notNil ifTrue:[ 
        statements do:[:each |
            each variableNodesDo:aBlock
        ]
    ].

    "Modified: / 16-11-2016 / 18:56:13 / cg"
! !

!RBSequenceNode methodsFor:'initialization & release'!

initialize
    super initialize.
    periods := statements := temporaries := #()

    "Created: / 07-10-2014 / 23:28:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leftBar: leftInteger temporaries: variableNodes rightBar: rightInteger 
	leftBar := leftInteger.
	self temporaries: variableNodes.
	rightBar := rightInteger
! !

!RBSequenceNode methodsFor:'matching'!

copyInContext: aDictionary 
	^(self class new)
		temporaries: (self copyList: temporaries inContext: aDictionary);
		statements: (self copyList: statements inContext: aDictionary);
		yourself
!

match: aNode inContext: aDictionary 
    self class == aNode class ifFalse: [^false].
    temporaries isEmpty ifFalse:[
        (self matchList: temporaries against: aNode temporaries inContext: aDictionary) 
            ifFalse: [^false].   
    ].
    ^ self matchList: statements
            against: aNode statements
            inContext: aDictionary

    "Modified: / 19-11-2016 / 15:58:47 / cg"
! !

!RBSequenceNode methodsFor:'private'!

indexOfNode: aNode 
	"Try to find the node by first looking for ==, and then for ="

	^(1 to: statements size) detect: [:each | (statements at: each) == aNode]
		ifNone: [statements indexOf: aNode]
! !

!RBSequenceNode methodsFor:'querying'!

bestNodeFor: anInterval 
	| node |
	node := super bestNodeFor: anInterval.
	node == self 
		ifTrue: 
			[(temporaries isEmpty and: [statements size == 1]) 
				ifTrue: [^statements first]].
	^node
! !

!RBSequenceNode methodsFor:'replacing'!

removeDeadCode
	(self isUsed ifTrue: [statements size - 1] ifFalse: [statements size]) 
		to: 1
		by: -1
		do: [:i | (statements at: i) isImmediate ifTrue: [statements removeAtIndex: i]].
	super removeDeadCode
!

removeNode: aNode
	self replaceNode: aNode withNodes: #()
!

replaceNode: aNode withNode: anotherNode 
	self statements: (statements 
				collect: [:each | each == aNode ifTrue: [anotherNode] ifFalse: [each]]).
	self temporaries: (temporaries 
				collect: [:each | each == aNode ifTrue: [anotherNode] ifFalse: [each]])
!

replaceNode: aNode withNodes: aCollection 
	| index newStatements |
	index := self indexOfNode: aNode.
	newStatements := OrderedCollection new: statements size + aCollection size.
	1 to: index - 1 do: [:i | newStatements add: (statements at: i)].
	newStatements addAll: aCollection.
	index + 1 to: statements size
		do: [:i | newStatements add: (statements at: i)].
	aCollection do: [:each | each parent: self].
	statements := newStatements
! !

!RBSequenceNode methodsFor:'testing'!

defines: aName 
	^(temporaries detect: [:each | each name = aName] ifNone: [nil]) notNil
!

directlyUses: aNode 
	^false
!

hasStatements
    ^ statements notEmpty 
!

isLast: aNode 
	| last |
	statements isEmpty ifTrue: [^false].
	last := statements last.
	^last == aNode or: [last isMessage and: [(#(#ifTrue:ifFalse: #ifFalse:ifTrue:) includes: last selector)
				and: [last arguments inject: false into: [:bool :each | bool or: [each isLast: aNode]]]]]
!

isSequence
	^true
!

lastHasPeriod
    ^ statements isEmpty not 
    and: [statements size == periods size]
!

lastIsReturn
	^statements isEmpty not and: [statements last lastIsReturn]
!

reads: aVariableName 
        ^((self statements ? #()) detect: [:each | each reads: aVariableName]
                ifNone: [nil]) notNil

    "Created: / 06-09-2012 / 17:19:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

references: aVariableName 
	^(statements detect: [:each | each references: aVariableName] ifNone: [nil]) 
		notNil
!

uses: aNode 
	statements isEmpty ifTrue: [^false].
	aNode == statements last ifFalse: [^false].
	^self isUsed
! !

!RBSequenceNode methodsFor:'visitor'!

acceptCommentsBeforeVisitor:aVisitor
    aVisitor formatSequenceCommentsBefore:(self commentsBefore) for:self
!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptSequenceNode: self
! !

!RBSequenceNode class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

