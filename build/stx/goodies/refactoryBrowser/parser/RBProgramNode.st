"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RBProgramNode
	instanceVariableNames:'parent auxInfo lineNumber properties'
	classVariableNames:'FormatterClass CascadeListCharacter IgnoreInMatchCharacter
		ListCharacter LiteralCharacter RecurseIntoCharacter
		StatementCharacter'
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

Object subclass:#AuxInfo
	instanceVariableNames:'commentsBefore commentsAfter typeInfo properties'
	classVariableNames:''
	poolDictionaries:''
	privateIn:RBProgramNode
!

RBProgramNode comment:'BRProgramNode is an abstract class that represents an abstract syntax tree node in a Smalltalk program.

Subclasses must implement the following messages:
        accessing
                start
                stop
        visitor
                acceptVisitor:

The #start and #stop methods are used to find the source that corresponds to this node. "source copyFrom: self start to: self stop" should return the source for this node.

The #acceptVisitor: method is used by BRProgramNodeVisitors (the visitor pattern). This will also require updating all the BRProgramNodeVisitors so that they know of the new node.

Subclasses might also want to redefine match:inContext: and copyInContext: to do parse tree searching and replacing.

Subclasses that contain other nodes should override equalTo:withMapping: to compare nodes while ignoring renaming temporary variables, and children that returns a collection of our children nodes.

Instance Variables:
        comments        <Collection of: Interval>       the intervals in the source that have comments for this node
        parent  <BRProgramNode> the node we''re contained in

'
!


!RBProgramNode class methodsFor:'initialization'!

initialize
    CascadeListCharacter := $;.
    ListCharacter := $@.
    LiteralCharacter := $#.
    RecurseIntoCharacter := $`.
    StatementCharacter := $..
    IgnoreInMatchCharacter := $?.
! !

!RBProgramNode class methodsFor:'accessing'!

formatterClass
        ^FormatterClass isNil ifTrue: [RBFormatter] ifFalse: [FormatterClass]
!

formatterClass: aClass 
        FormatterClass := aClass
!

optimizedSelectors
        ^#(#== #ifTrue: #ifTrue:ifFalse: #ifFalse: #ifFalse:ifTrue: #whileTrue: #whileTrue #whileFalse: #whileFalse #to:do: #yourself #and: #or:)
! !

!RBProgramNode methodsFor:'accessing'!

asReturn
        "Change the current node to a return node."

        parent isNil ifTrue: [self error: 'Cannot change to a return without a parent node.'].
        parent isSequence ifFalse: [self error: 'Parent node must be a sequence node.'].
        (parent isLast: self)
                ifFalse: [self error: 'Return node must be last.'].
        ^parent addReturn
!

blockScope
    parent isNil ifTrue:[^ nil].
    ^ parent blockScope

    "Created: / 01-05-2016 / 15:53:30 / cg"
!

children
        ^#()
!

comments
        ^ self commentsAfter
!

comments: aCollection
        ^ self commentsAfter:aCollection
!

commentsAfter
    auxInfo isNil ifTrue:[^ #() ].
    ^ auxInfo commentsAfter ? #()
!

commentsAfter: aCollectionOfComments
    |commentsAfter|

    aCollectionOfComments isEmptyOrNil ifTrue:[^ self].
    
    auxInfo isNil ifTrue:[
        auxInfo := AuxInfo new.
    ].    
    commentsAfter := auxInfo commentsAfter.
    commentsAfter notEmptyOrNil ifTrue:[
        commentsAfter := aCollectionOfComments copy , commentsAfter.
        commentsAfter sort:[:a :b | a start < b start].
    ] ifFalse:[
        commentsAfter := aCollectionOfComments
    ].
    auxInfo commentsAfter:commentsAfter
!

commentsBefore
    auxInfo isNil ifTrue:[^ #() ].
    ^ auxInfo commentsBefore ? #()
!

commentsBefore: aCollectionOfComments
    |commentsBefore|
    
    aCollectionOfComments isEmptyOrNil ifTrue:[^ self].

    auxInfo isNil ifTrue:[
        auxInfo := AuxInfo new.
    ].    
    commentsBefore := auxInfo commentsBefore.
    commentsBefore notEmptyOrNil ifTrue:[
        self breakPoint:#cg "/ 'oops - loosing comments before'.
    ].
    commentsBefore := aCollectionOfComments.
    auxInfo commentsBefore:commentsBefore
!

endPosition
    ^ self stop

    "Created: / 15-10-2014 / 09:34:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formattedCode
        ^self formatterClass new format: self
!

formatterClass
    ^ self propertyAt: #formatterClass ifAbsent:[ self class formatterClass ]

    "Modified: / 21-08-2015 / 22:13:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineNumber
"/    lineNumber isNil ifTrue:[
"/        self breakPoint:#cg info:'shouldn't this always be non-nil?'
"/    ].
    ^ lineNumber

    "Modified: / 06-03-2012 / 11:23:47 / cg"
!

lineNumber:anInteger
    lineNumber := anInteger.

    "Modified (format): / 06-03-2012 / 11:13:19 / cg"
!

methodScope
    parent isNil ifTrue:[^ nil].
    ^ parent methodScope

    "Created: / 01-05-2016 / 15:54:32 / cg"
!

newSource
    ^ self formattedCode
!

originalCode
        ^ (self source copyFrom:self start to:self stop) 
!

originalFormattedCode
    "same as formattedCode, but does not rewrite '_' to ':='"

    ^ self formatterClass new 
        rewriteOldAssignments:false;
        format: self
!

parent
        ^parent
!

parent: anObject
        parent := anObject
!

parents
        parent isNil 
            ifTrue:[ ^ OrderedCollection with:self ]
            ifFalse:[
                ^ parent parents addLast:self; yourself]
!

precedence
        ^6
!

removeCommentsAfter
    "occasionally someone wants to move comments from one node to another;
     this is a helper to clear the comments in the old node.
     (see senders of why this is done)"
     
    auxInfo isNil ifTrue:[^ self].
    auxInfo commentsAfter:nil
!

source
        ^parent notNil ifTrue: [parent source] ifFalse: [nil]
!

sourceInterval
    |start stop|

    start := self start.
    stop := self stop.
    start > stop ifTrue:[^ 1 to: 0].
    ^ start to: stop
!

start
        self subclassResponsibility
!

startPosition
    ^ self start

    "Created: / 30-01-2017 / 12:56:53 / stefan"
!

startWithoutParentheses
    ^ self start
!

stop
        self subclassResponsibility
!

stopPosition
    ^ self stop
!

topNode
    |nd parentOfNode|

    nd := self.
    [ (parentOfNode := nd parent) notNil ] whileTrue:[
        nd := parentOfNode.
    ].
    ^ nd
!

typeInfo
    "this is a hook for the type inferer;
     it may attach additional info to a node with this"
     
    auxInfo isNil ifTrue:[^ #() ].
    ^ auxInfo typeInfo
!

typeInfo:someArbitraryThingy
    "this is a hook for the type inferer;
     it may attach additional info to a node with this"
     
    auxInfo isNil ifTrue:[
        auxInfo := AuxInfo new.
    ].    
    auxInfo typeInfo:someArbitraryThingy
! !

!RBProgramNode methodsFor:'accessing-properties'!

hasProperty: aKey
    "Test if the property aKey is present."
    
    ^ properties notNil and: [ properties includesKey: aKey ]

    "Created: / 20-08-2015 / 18:25:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

objectAttributes
    ^ properties

    "Created: / 20-08-2015 / 18:32:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: aKey
    "Answer the property value associated with aKey."
    
    ^ self propertyAt: aKey ifAbsent: [ self error: 'Property not found' ]

    "Created: / 20-08-2015 / 18:23:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: aKey ifAbsent: aBlock
    "Answer the property value associated with aKey or, if aKey 
     isn't found, answer the result of evaluating aBlock."
    
    ^ properties isNil
        ifTrue: [ aBlock value ]
        ifFalse: [ properties at: aKey ifAbsent: aBlock ]

    "Created: / 20-08-2015 / 18:23:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: aKey ifAbsentPut: aBlock
    "Answer the property associated with aKey or, if aKey isn't found 
     store the result of evaluating aBlock as new value."
    
    ^ self propertyAt: aKey ifAbsent: [ self propertyAt: aKey put: aBlock value ]

    "Created: / 20-08-2015 / 18:24:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: aKey put: anObject
    "Set the property at aKey to be anObject. If aKey is not found, create a new entry 
     for aKey and set is value to anObject. Answer anObject."

    ^ (properties ifNil: [ properties := RBSmallDictionary new: 1 ])
            at: aKey put: anObject

    "Created: / 20-08-2015 / 18:24:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeProperty: aKey
    "Remove the property with aKey. Answer the property or raise 
     an error if aKey isn't found."
    
    ^ self removeProperty: aKey ifAbsent: [ self error: 'Property not found' ].

    "Created: / 20-08-2015 / 18:30:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeProperty: aKey ifAbsent: aBlock
    "Remove the property with aKey. Answer the value or, if aKey isn't found, answer the result of evaluating aBlock."
    
    | answer |
    properties isNil ifTrue: [ ^ aBlock value ].
    answer := properties removeKey: aKey ifAbsent: aBlock.
    properties isEmpty ifTrue: [ properties := nil ].
    ^ answer

    "Created: / 20-08-2015 / 18:30:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBProgramNode methodsFor:'comparing'!

equalTo: aNode exceptForVariables: variableNameCollection 
        | dictionary |
        dictionary := Dictionary new.
        (self equalTo: aNode withMapping: dictionary) ifFalse: [^false].
        dictionary keysAndValuesDo: 
                        [:key :value | 
                        (key = value or: [variableNameCollection includes: key]) ifFalse: [^false]].
        ^true
!

equalTo: aNode withMapping: aDictionary 
        "return true, if I am equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        ^self = aNode
!

equalTo: aNode withSelectorMapping: aDictionary 
        "return true, if I am equal to another node, with a given selector name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        ^self = aNode
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

    ^ self equalTo: aNode withMapping: aDictionary    
! !

!RBProgramNode methodsFor:'copying'!

copy
        "This is redefined for IBM Smalltalk which doesn't have postCopy."

        ^self shallowCopy postCopy
!

copyCommentsFrom: aNode 
        "Add all comments from aNode to us. If we already have the comment, then don't add it."

        | newComments |

        newComments := OrderedCollection new.
        aNode nodesDo: [:each | newComments addAll: each comments].
        self nodesDo:[:each | each comments do: [:comment | newComments remove: comment ifAbsent: []]].
        newComments isEmpty ifTrue: [^self].
        newComments := newComments asSortedCollection: [:a :b | a first < b first].
        self comments: newComments
!

postCopy
! !

!RBProgramNode methodsFor:'enumeration'!

allAssignmentNodesDo:aBlock
    self isPatternNode ifFalse:[
        self children do: [:each | each allAssignmentNodesDo:aBlock].
    ].

    "Created: / 01-05-2016 / 09:57:31 / cg"
    "Modified: / 16-11-2016 / 18:38:56 / cg"
!

allBlockNodesDo:aBlock
    self isPatternNode ifFalse:[
        self children do: [:each | each allBlockNodesDo:aBlock].
    ]

    "Modified: / 16-11-2016 / 18:39:10 / cg"
!

allLiteralNodesDo:aBlock
    self isPatternNode ifFalse:[
        self children do: [:each | each allLiteralNodesDo:aBlock].
    ]

    "Modified: / 16-11-2016 / 18:39:18 / cg"
!

allMessageNodesDo:aBlock
    self isPatternNode ifFalse:[
        self children do: [:each | each allMessageNodesDo:aBlock].
    ]

    "Modified: / 16-11-2016 / 18:39:29 / cg"
!

allNonPatternMessageNodesDo:aBlock
    self isPatternNode ifFalse:[
        self children do: [:each | each allNonPatternMessageNodesDo:aBlock].
    ].

    "Created: / 16-11-2016 / 18:18:43 / cg"
!

allReturnNodesDo:aBlock
    self isPatternNode ifFalse:[
        self children do: [:each | each allReturnNodesDo:aBlock].
    ]

    "Modified: / 16-11-2016 / 18:39:38 / cg"
!

collect: aBlock 
        "Hacked to fit collection protocols"

        ^aBlock value: self
!

detectParentForWhich: aBlock
    |p|

    p := parent.
    [ p notNil and:[(aBlock value:p) not]] whileTrue:[ p := p parent].
    ^ p
!

do: aBlock 
        "Hacked to fit collection protocols"

        aBlock value: self
!

size
        "Hacked to fit collection protocols"

        ^1
!

variableNodesDo:aBlock
    "evaluate a Block for all variable nodes"

    ^ self
! !

!RBProgramNode methodsFor:'inspecting'!

inspectorExtraAttributes
    | extras |
    extras := super inspectorExtraAttributes.
    properties notNil ifTrue:[ 
        properties keysAndValuesDo:[:name :value |
            extras at: '-' , name put: value
        ].
    ].
    ^ extras

    "Created: / 26-10-2015 / 11:37:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBProgramNode methodsFor:'iteration'!

nodesDo: aBlock 
        aBlock value: self.
        self children do: [:each | each nodesDo: aBlock]
! !

!RBProgramNode methodsFor:'matching'!

copyInContext: aDictionary
        ^self copy
!

copyList: matchNodes inContext: aDictionary 
        | newNodes |
        newNodes := OrderedCollection new.
        matchNodes do: 
                        [:each | 
                        | object |
                        object := each copyInContext: aDictionary.
                        newNodes addAll: object].
        ^newNodes
!

match: aNode inContext: aDictionary 
        ^self = aNode
!

matchList: matchNodes against: programNodes inContext: aDictionary 
        ^self
                matchList: matchNodes
                index: 1
                against: programNodes
                index: 1
                inContext: aDictionary
!

matchList: matchNodes index: matchIndex against: programNodes index: programIndex inContext: aDictionary 
        | node currentIndex currentDictionary nodes |
        matchNodes size < matchIndex ifTrue: [^programNodes size < programIndex].
        node := matchNodes at: matchIndex.
        node isList 
                ifTrue: 
                        [currentIndex := programIndex - 1.
                        
                        [currentDictionary := aDictionary copy.
                        programNodes size < currentIndex or: 
                                        [nodes := programNodes copyFrom: programIndex to: currentIndex.
                                        (currentDictionary at: node ifAbsentPut: [nodes]) = nodes and: 
                                                        [(self 
                                                                matchList: matchNodes
                                                                index: matchIndex + 1
                                                                against: programNodes
                                                                index: currentIndex + 1
                                                                inContext: currentDictionary) 
                                                                        ifTrue: 
                                                                                [currentDictionary keysAndValuesDo: [:key :value | aDictionary at: key put: value].
                                                                                ^true].
                                                        false]]] 
                                        whileFalse: [currentIndex := currentIndex + 1].
                        ^false].
        programNodes size < programIndex ifTrue: [^false].
        (node match: (programNodes at: programIndex) inContext: aDictionary) 
                ifFalse: [^false].
        ^self 
                matchList: matchNodes
                index: matchIndex + 1
                against: programNodes
                index: programIndex + 1
                inContext: aDictionary
! !

!RBProgramNode methodsFor:'meta variable-accessing'!

cascadeListCharacter
        ^$;
!

ignoreInMatchCharacter
        ^$?
!

listCharacter
        ^$@
!

literalCharacter
        ^$#
!

recurseIntoCharacter
        ^$`
!

statementCharacter
        ^$.
! !

!RBProgramNode methodsFor:'printing'!

printOn: aStream 
        aStream nextPutAll: self class name;
                nextPut: $(;
                nextPutAll: self formattedCode;
                nextPut: $)
! !

!RBProgramNode methodsFor:'querying'!

allAssignmentNodes
    | assignmentNodes |
    assignmentNodes := OrderedCollection new.
    self children do: [:each | assignmentNodes addAll: each allAssignmentNodes].
    ^assignmentNodes
!

allMessageNodes
    | messageNodes |
    messageNodes := OrderedCollection new.
    self children do: [:each | messageNodes addAll: each allMessageNodes].
    ^messageNodes

    "Modified: / 12-10-2006 / 21:26:32 / cg"
!

bestNodeFor: anInterval 
        | selectedChildren |
        (self intersectsInterval: anInterval) ifFalse: [^nil].
        (self containedBy: anInterval) ifTrue: [^self].
        selectedChildren := self children 
                                select: [:each | each intersectsInterval: anInterval].
        ^selectedChildren size >= 1 
                ifTrue: [selectedChildren first bestNodeFor: anInterval]
                ifFalse: [self]
!

firstLineNumber
    lineNumber isNil ifTrue:[
        self breakPoint:#cg info:'lineNumber should always be non-nil'.
        lineNumber := 1.
    ].
    ^ lineNumber
!

hasAssignmentNodes
    self allAssignmentNodesDo:[:each | ^ true].
    ^ false
!

hasBlockNodes
    self allBlockNodesDo:[:each | ^ true].
    ^ false
!

hasReturnNodes
    self allReturnNodesDo:[:each | ^ true].
    ^ false
!

lastLineNumber
"/ lineNumber isNil ifTrue:[self halt:'should always be non-nil'].
    ^ lineNumber
!

selfMessages
        | searcher |
        searcher := ParseTreeSearcher new.
        searcher matches: 'self `@msg: ``@args'
                do: 
                        [:aNode :answer | 
                        answer
                                add: aNode selector;
                                yourself].
        ^searcher executeTree: self initialAnswer: Set new
!

sentMessages
    | messages |
    messages := Set new.
    self children do: [:each | messages addAll: each sentMessages].
    ^messages

    "Modified: / 12-10-2006 / 21:26:32 / cg"
!

statementNode
        "Return your topmost node that is contained by a sequence node."

        (parent isNil or: [parent isSequence]) ifTrue: [^self].
        ^parent statementNode
!

superMessages
        | searcher |
        searcher := ParseTreeSearcher new.
        searcher matches: 'super `@msg: ``@args'
                do: 
                        [:aNode :answer | 
                        answer
                                add: aNode selector;
                                yourself].
        ^searcher executeTree: self initialAnswer: Set new
! !

!RBProgramNode methodsFor:'replacing'!

removeDeadCode
        self children do: [:each | each removeDeadCode]
!

replaceNode: aNode withNode: anotherNode 
        self error: 'I don''t store other nodes'
!

replaceWith: aNode 
        parent isNil ifTrue: [self error: 'This node doesn''t have a parent'].
        parent replaceNode: self withNode: aNode
! !

!RBProgramNode methodsFor:'searching'!

whichNodeIntersects: anInterval 
        | selectedChildren nChildren |

        (self intersectsInterval: anInterval) ifFalse: [^nil].

        selectedChildren := self children
                                select: [:each | each intersectsInterval: anInterval].

        nChildren := selectedChildren size.
        nChildren == 0 ifTrue:[
            ^ self "/ I intersect
        ].
        nChildren == 1 ifTrue:[
            ^ selectedChildren first whichNodeIntersects: anInterval
        ].
"/ self halt:'should this happen ?'.
        ^ self "/ I intersect
!

whichNodeIsContainedBy: anInterval 
        | selectedChildren |
        (self intersectsInterval: anInterval) ifFalse: [^nil].
        (self containedBy: anInterval) ifTrue: [^self].
        selectedChildren := self children 
                                select: [:each | each intersectsInterval: anInterval].
        ^selectedChildren size == 1 
                ifTrue: [selectedChildren first whichNodeIsContainedBy: anInterval]
                ifFalse: [nil]
!

whoDefines: aName 
        ^(self defines: aName)
                ifTrue: [self]
                ifFalse: [parent notNil
                                ifTrue: [parent whoDefines: aName]
                                ifFalse: [nil]]
! !

!RBProgramNode methodsFor:'special queries'!

addAllCommentsTo:aCollection
    aCollection addAll:(self commentsBefore).
    aCollection addAll:(self commentsAfter).
    self children do:[:eachChild |
        eachChild addAllCommentsTo:aCollection.
    ].

    "Created: / 30-06-2011 / 12:32:17 / cg"
!

addReferencedVariablesTo:aCollection
    self children do: [:each | each addReferencedVariablesTo:aCollection].
!

addUsedLiteralsTo:aCollection
    "adds the values of all literals to aCollection"

    self children do: [:eachChild | eachChild addUsedLiteralsTo:aCollection].

    "Created: / 12-10-2006 / 21:24:46 / cg"
!

addUsedSymbolsTo:aCollection
    self children do: [:eachChild | eachChild addUsedSymbolsTo:aCollection].
!

allArgumentVariables
        | children |
        children := self children.
        children isEmpty ifTrue: [^#()].
        ^children 
                inject: OrderedCollection new
                into: 
                        [:vars :each |
                        each notNil ifTrue:[
                            vars
                                addAll: each allArgumentVariables.
                        ].
                        vars]
!

allComments
    |comments|

    comments := OrderedCollection new.
    self addAllCommentsTo:comments.
    ^ comments

    "Created: / 30-06-2011 / 12:32:43 / cg"
!

allDefinedVariables
        | children |
        children := self children.
        children isEmpty ifTrue: [^#()].
        ^children inject: OrderedCollection new
                into: 
                        [:vars :each | 
                        vars addAll: each allDefinedVariables;
                                yourself]
!

allTemporaryVariables
        | children |
        children := self children.
        children isEmpty ifTrue: [^#()].
        ^children inject: OrderedCollection new
                into: 
                        [:vars :each | 
                        vars
                                addAll: each allTemporaryVariables;
                                yourself]
!

allVariablesOnScope
        ^parent isNil
                ifTrue: [#()]
                ifFalse: [parent allVariablesOnScope]
!

blockVariables
        ^parent isNil
                ifTrue: [#()]
                ifFalse: [parent blockVariables]
!

referencedVariables
        | variables |
        variables := Set new.
        self addReferencedVariablesTo:variables.
        ^variables
!

temporaryVariables
        ^parent isNil
                ifTrue: [#()]
                ifFalse: [parent temporaryVariables]
!

usedLiterals
    "returns a set of the literal values (i.e. not the nodes)"
    
    | literals |

    literals := Set new.
    self addUsedLiteralsTo:literals.
    ^literals

    "Created: / 12-10-2006 / 21:24:34 / cg"
!

usedSymbols
    "returns a set of the symbols used (i.e. not the nodes)"

    | symbols |

    symbols := IdentitySet new.
    self addUsedSymbolsTo:symbols.
    ^symbols

    "Modified: / 12-10-2006 / 21:26:26 / cg"
! !

!RBProgramNode methodsFor:'stx:libtool support'!

highlightInCodeView: aCodeView

    aCodeView highlightClear

    "Created: / 18-02-2008 / 17:48:12 / janfrog"
!

leftClickMenuInCodeView: aCodeView 
    ^ nil

    "Created: / 18-02-2008 / 17:49:43 / janfrog"
!

middleClickMenuInCodeView: aCodeView 
    ^ nil

    "Created: / 18-02-2008 / 17:49:57 / janfrog"
!

rightClickMenuInCodeView: aCodeView 
    ^ nil

    "Created: / 18-02-2008 / 17:50:10 / janfrog"
! !

!RBProgramNode methodsFor:'testing'!

assigns: aVariableName 
        ^(self children detect: [:each | each assigns: aVariableName] ifNone: [nil]) 
                notNil
!

containedBy: anInterval 
        ^anInterval first <= self start and: [anInterval last >= self stop]
!

containsReturn
        ^(self children detect: [:each | each containsReturn] ifNone: [nil]) 
                notNil
!

defines: aName
        ^false
!

directlyUses: aNode
        ^true
!

evaluatedFirst: aNode 
        self children do: 
                        [:each | 
                        each == aNode ifTrue: [^true].
                        each isImmediate ifFalse: [^false]].
        ^false
!

intersectsInterval: anInterval 
        |myStart myStop ivStart ivStop|

        myStart := self start.
        myStop := self stop.
        ivStart := anInterval first.
        ivStop := anInterval last.
        (myStart notNil and:[ivStop < myStart]) ifTrue:[^ false].
        (myStop notNil and:[ivStart > myStop]) ifTrue:[^ false].
        ^ true
"/        ^(anInterval first between:myStart and:myStop) 
"/        or: [myStart between: anInterval first and: anInterval last]
!

isAssignment
        ^false
!

isBlock
        ^false
!

isCascade
        ^false
!

isChildOf:anotherNode
    |nd p|

    nd := self.
    [nd notNil] whileTrue:[
        p := nd parent.
        p == anotherNode ifTrue:[^ true].
        nd := p
    ].
    ^ false
!

isDirectlyUsed
        "This node is directly used as an argument, receiver, or part of an assignment."

        ^parent isNil
                ifTrue: [false]
                ifFalse: [parent directlyUses: self]
!

isEvaluatedFirst
        "Return true if we are the first thing evaluated in this statement."

        ^parent isNil or: [parent isSequence or: [parent evaluatedFirst: self]]
!

isGlobal
    "Return true if the variable node is for
     a global variable, false otherwise"

    ^false
!

isImmediate
        ^false
!

isInsidePatternNode
    |p|

    p := parent.
    [p notNil] whileTrue:[
        p isPatternNode ifTrue:[^ true].
        p := p parent.
    ].
    ^ false.

    "Created: / 16-11-2016 / 18:37:03 / cg"
!

isInstanceVariable
        ^false
!

isKeywordMessage
    ^ false
!

isLast: aNode 
        | children |
        children := self children.
        ^children isEmpty not and: [children last == aNode]
!

isLiteral
        ^false
!

isLiteralArray
    ^false

    "Created: / 28-12-2011 / 16:05:40 / cg"
!

isLiteralByteArray
    ^false

    "Created: / 28-12-2011 / 16:05:33 / cg"
!

isLiteralCharacter
    ^false

    "Created: / 28-12-2011 / 16:05:27 / cg"
!

isLiteralFloat
    ^false

    "Created: / 28-12-2011 / 16:05:40 / cg"
!

isLiteralInteger
    ^false

    "Created: / 28-12-2011 / 16:05:40 / cg"
!

isLiteralNode
        ^false
!

isLiteralNumber

    ^false

    "Created: / 31-10-2011 / 11:54:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isLiteralString

    ^false

    "Created: / 28-12-2011 / 16:05:27 / cg"
!

isLiteralSymbol

    ^false

    "Created: / 28-12-2011 / 16:05:27 / cg"
!

isMessage
        ^false
!

isMessageWithSelector:aStringOrSymbol
        ^false
!

isMethod
        ^false
!

isPragma
        ^ false

    "Created: / 03-11-2014 / 09:26:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isReturn
        ^false
!

isSTXPrimitiveCCode
        ^false
!

isSelf
    "true if I am the self-variable node"
    
    ^ false

    "Created: / 31-07-2011 / 01:00:41 / cg"
!

isSequence
        ^false
!

isSqueakArray
        ^false
!

isSuper
    ^ false
!

isTemporary
    "Return true if the variable node is for
     a temporary variable, false otherwise"

    ^false

    "Created: / 06-09-2012 / 16:47:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUsed
        "Answer true if this node could be used as part of another expression. For example, you could use the 
        result of this node as a receiver of a message, an argument, the right part of an assignment, or the 
        return value of a block. This differs from isDirectlyUsed in that it is conservative since it also includes 
        return values of blocks."

        ^parent isNil
                ifTrue: [false]
                ifFalse: [parent uses: self]
!

isValue
        ^false
!

isVariable
        ^false
!

isVariableNotInLeftHandSideOfAssignment
    "Returns true iff receiver is variable node but not
     in left-hand side of assignment"    
    ^false

    "Created: / 28-03-2012 / 17:14:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lastIsReturn
        ^self isReturn
!

reads: aVariableName 
        ^(self children detect: [:each | each reads: aVariableName]
                ifNone: [nil]) notNil

    "Created: / 06-09-2012 / 17:16:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

references: aVariableName 
        ^(self children detect: [:each | each references: aVariableName]
                ifNone: [nil]) notNil
!

uses: aNode
        ^true
! !

!RBProgramNode methodsFor:'testing-matching'!

canMatchMethod: aCompiledMethod
        |literalsInMethod optimizedSelectors|

        optimizedSelectors := self class optimizedSelectors.

        aCompiledMethod isMethod ifTrue:[
            "/ the original code below iterates over the literals for each tested;
            "/ the following does it faster
            literalsInMethod := aCompiledMethod literals.
            self sentMessages do:[:each | 
                ((optimizedSelectors includes: each) 
                or: [literalsInMethod includes: each]) ifFalse: [^false]
            ].
        ] ifFalse:[
            self sentMessages do:[:each | 
                ((optimizedSelectors includes: each) 
                or: [aCompiledMethod refersToLiteral: each]) ifFalse: [^false]
            ]
        ].
        ^true
!

isList
        ^false
!

isPatternNode
        ^false
!

recurseInto
        ^false
! !

!RBProgramNode methodsFor:'visitor'!

acceptCommentsAfterVisitor:aVisitor
    |comments|

    comments := self commentsAfter.
    comments notEmptyOrNil ifTrue:[
        aVisitor formatCommentsAfter:comments for:self
    ]
!

acceptCommentsBeforeVisitor:aVisitor
    |comments|

    comments := self commentsBefore.
    comments notEmptyOrNil ifTrue:[
        aVisitor formatCommentsBefore:comments for:self
    ]
!

acceptVisitor: aProgramNodeVisitor 
        self subclassResponsibility
! !

!RBProgramNode::AuxInfo methodsFor:'accessing'!

commentsAfter
    ^ commentsAfter
!

commentsAfter:something
    commentsAfter := something.
!

commentsBefore
    ^ commentsBefore
!

commentsBefore:something
    commentsBefore := something.
!

typeInfo
    ^ typeInfo
!

typeInfo:something
    typeInfo := something.
! !

!RBProgramNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


RBProgramNode initialize!
