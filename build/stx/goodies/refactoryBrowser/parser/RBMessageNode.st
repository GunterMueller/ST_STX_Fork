"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBValueNode subclass:#RBMessageNode
	instanceVariableNames:'receiver selector selectorParts arguments'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBMessageNode comment:'BRMessageNode is an AST node that represents a message send.

Instance Variables:
	arguments       <SequenceableCollection of: BRValueNode>        our argument nodes
	receiver        <BRValueNode>   the receiver''s node
	selector        <Symbol | nil>  the selector we''re sending (cached)
	selectorParts   <SequenceableCollection of: BRValueToken>       the tokens for each keyword

'
!


!RBMessageNode class methodsFor:'instance creation'!

receiver: aValueNode selector: aSymbol 
	^self 
		receiver: aValueNode
		selector: aSymbol
		arguments: #()
!

receiver: aValueNode selector: aSymbol arguments: valueNodes 
	^(self new)
		receiver: aValueNode;
		arguments: valueNodes;
		selector: aSymbol;
		yourself
!

receiver: aValueNode selectorParts: keywordTokens arguments: valueNodes 
	^((keywordTokens detect: [:each | each isPatternVariable] ifNone: [nil]) 
		notNil ifTrue: [RBPatternMessageNode] ifFalse: [RBMessageNode]) 
		new 
			receiver: aValueNode
			selectorParts: keywordTokens
			arguments: valueNodes
! !

!RBMessageNode methodsFor:'accessing'!

allMessageNodes
        ^(super allMessageNodes)
                add: self;
                yourself
!

arg1
    ^ self arguments first
!

arg1: aNode 
        arguments := arguments copy.
        arguments at:1 put:aNode.
        aNode parent: self
!

arguments
        arguments isNil ifTrue: [^ #()].
        ^ arguments
!

arguments: argCollection 
        (arguments := argCollection) notNil ifTrue:[
            arguments do: [:each | each parent: self]
        ].
!

children
        ^(OrderedCollection with: receiver) 
            addAll: (arguments ? #());
            yourself
!

leftMostReceiver
    ^ receiver leftMostReceiver
!

precedence
	^self isUnary ifTrue: [1] ifFalse: [self isKeyword ifTrue: [3] ifFalse: [2]]
!

receiver
	^receiver
!

receiver: aValueNode 
	receiver := aValueNode.
	receiver parent: self
!

selector
    selector := self selectorString asSymbolIfInternedOrSelf.
    ^selector 
!

selector: aSelector 
        | keywords numArgs |
        keywords := aSelector keywords.
        numArgs := aSelector numArgs.
        numArgs == arguments size 
                ifFalse: 
                        [self 
                                error: 'Attempting to assign selector with wrong number of arguments.'].
        selectorParts := numArgs == 0 
                                ifTrue: [Array with: (RBIdentifierToken value: keywords first start: nil)]
                                ifFalse: 
                                        [keywords first last == $: 
                                                ifTrue: [keywords collect: [:each | RBKeywordToken value: each start: nil]]
                                                ifFalse: [Array with: (RBBinarySelectorToken value: aSelector start: nil)]].
        "/ self assert:(selector isNil or:[selector partsIfSelector asArray = keywords]).
        selector := aSelector
!

selectorString
        ^selector isNil
                ifTrue: [selector := self buildSelectorString]
                ifFalse: [selector]
!

sentMessages
	^(super sentMessages)
		add: self selector;
		yourself
!

startWithoutParentheses
	^receiver start
!

stopWithoutParentheses
        ^arguments isEmptyOrNil 
                ifTrue: [selectorParts first stop]
                ifFalse: [arguments last stop]
! !

!RBMessageNode methodsFor:'comparing'!

= anObject 
        |a1 a2|

        self == anObject ifTrue: [^true].
        self class = anObject class ifFalse: [^false].
        (receiver = anObject receiver 
                and: [self selectorString = anObject selectorString]) ifFalse: [^false].
        1 to: arguments size
                do: [:i | 
                            a1 := (arguments at: i).
                            a2 := (anObject arguments at: i).
                            a1 = a2 ifFalse: [^false]].
        ^true
!

equalTo: anObject withMapping: aDictionary 
        "return true, if I am equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        ((receiver equalTo: anObject receiver withMapping: aDictionary)
                and: [self selector = anObject selector]) ifFalse: [^false].
        1 to: arguments size
                do: 
                        [:i | 
                        ((arguments at: i) equalTo: (anObject arguments at: i)
                                withMapping: aDictionary) ifFalse: [^false]].
        ^true
!

equalTo: anObject withSelectorMapping: aDictionary 
        "return true, if I am equal to another node, with a given selector name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        (receiver equalTo: anObject receiver withSelectorMapping: aDictionary) ifFalse: [^false].
        (aDictionary at:self selector ifAbsentPut:[anObject selector]) = anObject selector ifFalse:[
            ^ false
        ].
        arguments size = (anObject arguments size) ifFalse: [^false].  
        1 to: arguments size
                do: 
                        [:i | 
                        ((arguments at: i) equalTo: (anObject arguments at: i)
                                withSelectorMapping: aDictionary) ifFalse: [^false]].
        ^true
!

hash
        ^(receiver hash bitXor: self selector hash)
                bitXor: (arguments isEmpty ifTrue: [0] ifFalse: [arguments first hash])
!

semanticallyEqualTo: aNode withMapping: aDictionary 
    "return true, if I am semantically equal to another node, with a given variable name mapping.
     Semantical equalTo: is defined slightly less strict, than equalTo:.
     Both check the parsetree, ignoring formatting and comments.
     However, in some situations, semanticallyEqualTo: detects the same intention,
     (which is mostly heuristic and builtin knowledge).
     For example: 
        foo isNil ifTrue:e1 ifFalse:e2 
     is semantcallyEqualTo:
        foo notNil ifTrue:e2 ifFalse:e1
     and also to:
        foo isNil ifFalse:e2 ifTrue:e1 
     The fallback implemented here is to ask for the regular equality.
     Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

    |mySelector otherSelector|    
    
    self class = aNode class ifFalse: [^false].

    mySelector := self selectorString.
    otherSelector := aNode selectorString.
    
    (receiver semanticallyEqualTo: aNode receiver withMapping: aDictionary) ifFalse: [
        ^ false
    ].

    (((mySelector = #ifTrue:ifFalse:) and:[ otherSelector = #ifFalse:ifTrue:])
    or:[ ((mySelector = #ifFalse:ifTrue:) and:[ otherSelector = #ifTrue:ifFalse:]) ]) ifTrue:[
        ((arguments at: 1) semanticallyEqualTo:(aNode arguments at: 2)
                withMapping: aDictionary) ifFalse: [^false].
        ((arguments at: 2) semanticallyEqualTo:(aNode arguments at: 1)
                withMapping: aDictionary) ifFalse: [^false].
        ^ true.        
    ].

    (mySelector = otherSelector) ifFalse: [
        ^ false
    ].

    arguments with:aNode arguments do:[:myArgI :otherArgI | 
        (myArgI semanticallyEqualTo: otherArgI withMapping: aDictionary) ifFalse: [^false]
    ].
    ^true
! !

!RBMessageNode methodsFor:'copying'!

postCopy
        super postCopy.
        self receiver: receiver copy.
        self arguments: (arguments collect: [:each | each copy])

    "Modified: / 18-06-2015 / 20:33:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBMessageNode methodsFor:'enumeration'!

allMessageNodesDo:aBlock
    receiver allMessageNodesDo:aBlock.
    arguments do:[:eachArg |
        eachArg allMessageNodesDo:aBlock
    ].    
    aBlock value:self.
!

allNonPatternMessageNodesDo:aBlock
    self isPatternNode ifFalse:[
        receiver allNonPatternMessageNodesDo:aBlock.
        arguments do:[:eachArg |
            eachArg allNonPatternMessageNodesDo:aBlock
        ].    
        aBlock value:self.
    ].

    "Created: / 16-11-2016 / 18:19:22 / cg"
!

variableNodesDo:aBlock
    "evaluate a Block for all variable nodes"

    self isPatternNode ifFalse:[
        receiver variableNodesDo:aBlock.
        arguments do:[:each | each variableNodesDo:aBlock].
    ]

    "Modified: / 16-11-2016 / 18:44:36 / cg"
! !

!RBMessageNode methodsFor:'initialization & release'!

receiver: aValueNode selectorParts: keywordTokens arguments: valueNodes 
        self receiver: aValueNode.
        selectorParts := keywordTokens.
        valueNodes notNil ifTrue:[
            self arguments: valueNodes.
        ].
! !

!RBMessageNode methodsFor:'libtool3 support'!

highlightInCodeView: aCodeView

    ^aCodeView highlightMessageNode: self

    "Created: / 18-02-2008 / 17:51:11 / janfrog"
!

leftClickMenuInCodeView: aCodeView 
    ^ aCodeView leftClickMenuForMessageNode: self.

    "Created: / 18-02-2008 / 19:04:45 / janfrog"
!

middleClickMenuInCodeView: aCodeView 
    ^ aCodeView middleClickMenuForMessageNode: self.

    "Created: / 18-02-2008 / 19:04:58 / janfrog"
!

rightClickMenuInCodeView: aCodeView 
    ^ aCodeView rightClickMenuForMessageNode: self.

    "Created: / 18-02-2008 / 19:05:18 / janfrog"
! !

!RBMessageNode methodsFor:'matching'!

copyInContext: aDictionary 
	^(self class new) receiver: (receiver copyInContext: aDictionary);
		selectorParts: (selectorParts collect: [:each | each removePositions]);
		arguments: (arguments collect: [:each | each copyInContext: aDictionary]);
		yourself
!

match: aNode inContext: aDictionary 
    aNode class == self class ifFalse: [^false].
    self selectorString = aNode selectorString ifFalse: [^false].
    (receiver match: aNode receiver inContext: aDictionary) ifFalse: [^false].
    1 to: arguments size do: [:i | 
        ((arguments at: i) match: (aNode arguments at: i) inContext: aDictionary)
            ifFalse: [^false]
    ].
    ^ true

    "Modified (format): / 19-11-2016 / 16:01:23 / cg"
! !

!RBMessageNode methodsFor:'private'!

buildSelector
        "concatenate the selector parts, and intern as a symbol"

        ^ self buildSelectorString "/ asSymbol
!

buildSelectorString
        "concatenate the selector parts, but do not intern"

        | selectorStream |
        selectorStream := WriteStream on: (String new: 50).
        selectorParts do: [:each | selectorStream nextPutAll: each value].
        ^selectorStream contents
!

selectorParts
	^selectorParts
!

selectorParts: tokenCollection 
	selectorParts := tokenCollection
! !

!RBMessageNode methodsFor:'querying'!

bestNodeFor: anInterval 
	(self intersectsInterval: anInterval) ifFalse: [^nil].
	(self containedBy: anInterval) ifTrue: [^self].
	selectorParts do: 
			[:each | 
			((anInterval first between: each start and: each stop) 
				or: [each start between: anInterval first and: anInterval last]) 
					ifTrue: [^self]].
	self children do: 
			[:each | 
			| node |
			node := each bestNodeFor: anInterval.
			node notNil ifTrue: [^node]]
!

firstLineNumber
    ^ receiver firstLineNumber
!

lastLineNumber
    arguments notEmptyOrNil ifTrue:[
        ^ arguments last lastLineNumber
    ].
    ^ selectorParts last lineNumber.
"/    ^ lineNumber.
! !

!RBMessageNode methodsFor:'replacing'!

replaceNode: aNode withNode: anotherNode 
	"If we're inside a cascade node and are changing the receiver, change all the receivers"

	receiver == aNode 
		ifTrue: 
			[self receiver: anotherNode.
			(parent notNil and: [parent isCascade]) 
				ifTrue: [parent messages do: [:each | each receiver: anotherNode]]].
	self arguments: (arguments 
				collect: [:each | each == aNode ifTrue: [anotherNode] ifFalse: [each]])
! !

!RBMessageNode methodsFor:'testing'!

isBinary
	^(self isUnary or: [self isKeyword]) not
!

isCascaded
	^parent notNil and: [parent isCascade]
!

isFirstCascaded
	^self isCascaded and: [parent messages first == self]
!

isKeyword
	^selectorParts first value last == $:
!

isKeywordMessage
     ^ self isKeyword      
!

isMessage
	^true
!

isMessageWithSelector:aStringOrSymbol
        ^ self selectorString = aStringOrSymbol
!

isUnary
        ^arguments isEmptyOrNil
!

lastIsReturn
    ^ (#(#ifTrue:ifFalse: #ifFalse:ifTrue:) includes: self selectorString) 
        and:[arguments first isBlock 
        and:[arguments first body lastIsReturn
        and:[arguments last isBlock 
        and: [arguments last body lastIsReturn]]]]
! !

!RBMessageNode methodsFor:'visitor'!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptMessageNode: self
! !

!RBMessageNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

