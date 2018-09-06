"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBValueNode subclass:#RBBlockNode
	instanceVariableNames:'left right colons body arguments bar firstLineNumber
		lastLineNumber'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBBlockNode comment:'BRBlockNode is an AST node that represents a block "[...]".

Instance Variables:
	arguments	<SequenceableCollection of: BRVariableNode>	the arguments for the block
	bar	<Integer | nil>	position of the | after the arguments
	body	<BRSequenceNode>	the code inside the block
	colons	<SequenceableCollection of: Integer>	positions of each : before each argument
	left	<Integer>	position of [
	right	<Integer>	position of ]

'
!


!RBBlockNode class methodsFor:'instance creation'!

arguments: argNodes body: sequenceNode 
	^(self new)
		arguments: argNodes;
		body: sequenceNode;
		yourself
!

body: sequenceNode 
	^self arguments: #() body: sequenceNode
! !

!RBBlockNode methodsFor:'accessing'!

allArgumentVariables
	^(self argumentNames asOrderedCollection)
		addAll: super allArgumentVariables;
		yourself
!

allDefinedVariables
	^(self argumentNames asOrderedCollection) addAll: super allDefinedVariables;
		yourself
!

allVariablesOnScope
        | vars |
        vars := super allVariablesOnScope asOrderedCollection.
        vars addAll: self argumentNames.
        ^vars
!

argumentCount
    ^ arguments size

    "Created: / 29-11-2011 / 11:13:30 / cg"
!

argumentNames
	^self arguments collect: [:each | each name]
!

arguments
	^arguments
!

arguments: argCollection 
	arguments := argCollection.
	arguments do: [:each | each parent: self]
!

bar
    "return the position of the bar, if any"

        ^bar
!

bar: barPosition
        bar := barPosition
!

blockScope
    ^ self.

    "Created: / 01-05-2016 / 15:53:22 / cg"
!

blockVariables
	| vars |
	vars := super blockVariables asOrderedCollection.
	vars addAll: self argumentNames.
	^vars
!

body
	^body
!

body: stmtsNode 
	body := stmtsNode.
	body parent: self
!

children
    |body|

    (body := self body) notNil ifTrue:[
        ^self arguments copyWith: body
    ].
    ^ self arguments
!

colons: anObject
	colons := anObject
!

firstLineNumber
    firstLineNumber notNil ifTrue:[^ firstLineNumber].

    lineNumber isNil ifTrue:[
        self breakPoint:#cg info:'lineNumber should always be non-nil'.
        lineNumber := 1.
    ].
    ^ lineNumber
!

firstLineNumber:something
    firstLineNumber := something.
!

lastLineNumber
    ^ lastLineNumber
!

lastLineNumber:something
    lastLineNumber := something.
!

left
	^left
!

left: anObject
	left := anObject
!

numArgs
    ^ arguments size

    "Created: / 29-11-2011 / 11:13:30 / cg"
!

precedence
	^0
!

right
	^right
!

right: anObject
	right := anObject
!

startWithoutParentheses
    left isNil ifTrue:[^ body startWithoutParentheses].
    ^left
!

stopWithoutParentheses
    right isNil ifTrue:[
        body notNil ifTrue:[^ body stop "right"].
        bar notNil ifTrue:[^ bar].
        arguments notEmptyOrNil ifTrue:[^ arguments last right].
    ].
    ^right
! !

!RBBlockNode methodsFor:'comparing'!

= anObject
        |myArgs otherArgs|

        self == anObject ifTrue: [^true].
        self class = anObject class ifFalse: [^false].
        self body = anObject body ifFalse: [^false].
        myArgs := self arguments.
        otherArgs := anObject arguments.
        myArgs size = otherArgs size ifFalse: [^false].
        1 to: myArgs size
                do: [:i | (myArgs at: i) = (otherArgs at: i) ifFalse: [^false]].
        ^true

    "Modified: / 29-11-2011 / 11:16:39 / cg"
!

equalTo: anObject withMapping: aDictionary 
        "return true, if I am equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        |myArgs otherArgs numArgs|

        self class = anObject class ifFalse: [^false].
        myArgs := self arguments.
        otherArgs := anObject arguments.
        (numArgs := myArgs size) = otherArgs size ifFalse: [^false].
        1 to: numArgs
                do: 
                        [:i | 
                        ((myArgs at: i) equalTo: (otherArgs at: i)
                                withMapping: aDictionary) ifFalse: [^false]].
        (self body equalTo: anObject body withMapping: aDictionary)
                ifFalse: [^false].
        myArgs do: [:each | aDictionary removeKey: each name ifAbsent:[] ].
        ^true

    "Modified: / 29-11-2011 / 11:16:10 / cg"
!

equalTo: anObject withSelectorMapping: aDictionary 
        "return true, if I am equal to another node, with a given selector name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        |myArgs otherArgs numArgs|

        self class = anObject class ifFalse: [^false].
        myArgs := self arguments.
        otherArgs := anObject arguments.
        (numArgs := myArgs size) = otherArgs size ifFalse: [^false].
        1 to: numArgs do:[:i | 
            ((myArgs at: i) = (otherArgs at: i)) ifFalse: [^false]].
        (self body equalTo: anObject body withSelectorMapping: aDictionary)
                ifFalse: [^false].
        ^true

    "Modified: / 29-11-2011 / 11:16:10 / cg"
!

hash
	^self arguments hash bitXor: self body hash
!

semanticallyEqualTo: anObject withMapping: aDictionary 
    "return true, if I am semantically equal to another node, with a given variable name mapping.
     Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

    |myArgs otherArgs numArgs|

    self class = anObject class ifFalse: [^false].
    myArgs := self arguments.
    otherArgs := anObject arguments.
    (numArgs := myArgs size) = otherArgs size ifFalse: [^false].
    myArgs with: otherArgs do: [:myArgI :otherArgI | 
            (myArgI semanticallyEqualTo: otherArgI withMapping: aDictionary) ifFalse: [^false]
    ].
    (self body semanticallyEqualTo: anObject body withMapping: aDictionary)
            ifFalse: [^false].
    myArgs do: [:each | aDictionary removeKey: each name ifAbsent:[] ].
    ^true

    "Modified: / 29-11-2011 / 11:16:10 / cg"
! !

!RBBlockNode methodsFor:'copying'!

postCopy
        super postCopy.
        self arguments: (arguments collect: [:each | each copy]).
        self body: body copy

    "Modified: / 18-06-2015 / 20:38:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBBlockNode methodsFor:'enumeration'!

variableNodesDo:aBlock
    "evaluate a Block for all variable nodes"

    arguments do:[:each | 
        each isPatternNode ifFalse:[ aBlock value: each]
    ].
    body notNil ifTrue:[ body variableNodesDo: aBlock].

    "Modified (format): / 16-11-2016 / 18:55:00 / cg"
! !

!RBBlockNode methodsFor:'matching'!

copyInContext: aDictionary 
	^(self class new)
		arguments: (self copyList: arguments inContext: aDictionary);
		body: (body copyInContext: aDictionary);
		yourself
!

match: aNode inContext: aDictionary 
    aNode class == self class ifFalse: [^false].

    (self matchList: arguments against: aNode arguments inContext: aDictionary) ifFalse: [^false].  
    ^ body match: aNode body inContext: aDictionary

    "Modified (format): / 19-11-2016 / 15:55:28 / cg"
! !

!RBBlockNode methodsFor:'replacing'!

replaceNode: aNode withNode: anotherNode 
	body == aNode ifTrue: [self body: anotherNode].
	self arguments: (arguments 
				collect: [:each | each == aNode ifTrue: [anotherNode] ifFalse: [each]])
! !

!RBBlockNode methodsFor:'testing'!

defines: aName 
	^(arguments detect: [:each | each name = aName] ifNone: [nil]) notNil
!

directlyUses: aNode 
	^false
!

hasArguments
    ^ arguments notEmpty
!

hasStatements
        ^body hasStatements
!

isBlock
	^true
!

isImmediate
	^true
!

isLast: aNode 
	^body isLast: aNode
!

references: aVariableName 
	^body references: aVariableName
!

uses: aNode 
	aNode = body ifFalse: [^false].
	^parent isMessage
		ifTrue: [(#(#ifTrue:ifFalse: #ifTrue: #ifFalse: #ifFalse:ifTrue:) includes: parent selector) not or: [parent isUsed]]
		ifFalse: [self isUsed]
! !

!RBBlockNode methodsFor:'visitor'!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptBlockNode: self
! !

!RBBlockNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

