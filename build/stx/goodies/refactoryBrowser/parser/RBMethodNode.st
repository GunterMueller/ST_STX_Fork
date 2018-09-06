"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBProgramNode subclass:#RBMethodNode
	instanceVariableNames:'selector selectorParts body source arguments tags replacements
		nodeReplacements pragmas'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBMethodNode comment:'BRMethodNode is the AST that represents a Smalltalk method.

Instance Variables:
	arguments	<SequenceableCollection of: BRVariableNode>	the arguments to the method
	body	<BRSequenceNode>	the body/statements of the method
	selector	<Symbol | nil>	the method name (cached)
	selectorParts	<SequenceableCollection of: BRValueToken>	the tokens for the selector keywords
	source	<String>	the source we compiled
	tag	<Interval | nil>	the source location of any resource/primitive tags

'
!


!RBMethodNode class methodsFor:'instance creation'!

selector: aSymbol arguments: variableNodes body: aSequenceNode 
	^(self new)
		arguments: variableNodes;
		selector: aSymbol;
		body: aSequenceNode;
		yourself
!

selector: aSymbol body: aSequenceNode 
	^self 
		selector: aSymbol
		arguments: #()
		body: aSequenceNode
!

selectorParts: tokenCollection arguments: variableNodes 
	^((tokenCollection detect: [:each | each isPatternVariable] ifNone: [nil]) 
		notNil ifTrue: [RBPatternMethodNode] ifFalse: [RBMethodNode]) 
		new selectorParts: tokenCollection arguments: variableNodes
! !

!RBMethodNode methodsFor:'accessing'!

addNode: aNode 
	^body addNode: aNode
!

addReturn
	body addReturn
!

addSelfReturn
	^body addSelfReturn
!

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
    ^ self argumentNames "allArgumentVariables" , (super allVariablesOnScope)

    "Created: / 15-10-2006 / 14:05:08 / cg"
!

argumentNames
        ^ arguments collect: [:each | each name]
!

arguments
	^arguments
!

arguments: variableNodes 
	arguments := variableNodes.
	arguments do: [:each | each parent: self]
!

blockScope
        ^nil

    "Created: / 01-05-2016 / 15:53:43 / cg"
!

body
	^body
!

body: stmtsNode 
	body := stmtsNode.
	body parent: self
!

children
    body isNil ifTrue:[ ^ arguments ].
    ^ arguments copyWith: body
!

methodScope
        ^self

    "Created: / 01-05-2016 / 15:54:18 / cg"
!

newSource
    "return a (horribly formatted) new source"

    replacements isNil ifTrue:[ ^ self formattedCode].
    ^ [self reformatSource] on: Error do:[:ex | ex return:self formattedCode].
!

pragmas
    ^ pragmas ? #()

    "Created: / 07-10-2014 / 23:26:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pragmas: aCollection
    pragmas := aCollection.
    pragmas do: [ :each | each parent: self ]

    "Created: / 07-10-2014 / 23:26:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primitiveSources
	^self tags 
		collect: [:each | self source copyFrom: each first to: each last]
!

renameSelector: newSelector andArguments: varNodeCollection 
        | oldSelectorParts oldArguments |
        oldSelectorParts := selectorParts.
        oldArguments := arguments.
        self
                arguments: varNodeCollection;
                selector: newSelector.
        self changeSourceSelectors: oldSelectorParts arguments: oldArguments
!

selector
	^selector isNil
		ifTrue: [selector := self buildSelector]
		ifFalse: [selector]
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
	selector := aSelector
!

source
	^source
!

source: anObject
	source := anObject
!

start
	^1
!

stop
	^source size
!

tags
	^tags isNil ifTrue: [#()] ifFalse: [tags]
!

tags: aCollectionOfIntervals 
	tags := aCollectionOfIntervals
!

temporaries
    body isNil ifTrue:[^ #()].
    ^ body temporaries
! !

!RBMethodNode methodsFor:'comparing'!

= anObject 
        self == anObject ifTrue: [^true].
        self class = anObject class ifFalse: [^false].
        (self selector = anObject selector) ifFalse: [^false].
        (body = anObject body) ifFalse: [^false].
        1 to: arguments size
                do: [:i | (arguments at: i) = (anObject arguments at: i) ifFalse: [^false]].
        ^true
!

equalTo: anObject withMapping: aDictionary 
        "return true, if I am equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        (self selector = anObject selector 
                and: [body equalTo: anObject body withMapping: aDictionary]) 
                        ifFalse: [^false].

        1 to: arguments size do: [:i | 
            ((arguments at: i) 
                    equalTo: (anObject arguments at: i)
                    withMapping: aDictionary
            ) ifFalse: [
                ^false
            ].
            aDictionary removeKey: (arguments at: i) name
        ].
        ^self primitiveSources = anObject primitiveSources
!

equalTo: anObject withSelectorMapping: aDictionary 
        "return true, if I am equal to another node, with a given selector name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        (aDictionary at:self selector ifAbsentPut:[anObject selector]) = anObject selector ifFalse:[
            ^ false
        ].
        (body equalTo: anObject body withSelectorMapping: aDictionary) ifFalse: [^false].
        ^self primitiveSources = anObject primitiveSources
!

hash
        ^(self selector hash bitXor: body hash)
                bitXor: arguments hash
!

semanticallyEqualTo: anObject withMapping: aDictionary 
    "return true, if I am semantically equal to another node, with a given variable name mapping.
     Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

    ^ self semanticallyEqualTo: anObject withMapping: aDictionary ignoringSelector:false

    "Modified: / 05-02-2017 / 00:55:40 / cg"
!

semanticallyEqualTo: anObject withMapping: aDictionary ignoringSelector:ignoringSelector
    "return true, if I am semantically equal to another node, with a given variable name mapping.
     Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

    self class = anObject class ifFalse: [^false].
    ignoringSelector ifTrue:[
        (self selector argumentCount = anObject selector argumentCount) ifFalse: [^false].  
    ] ifFalse:[    
        (self selector = anObject selector) ifFalse: [^false].  
    ].
    
    (body semanticallyEqualTo: anObject body withMapping: aDictionary) ifFalse: [^false].

    arguments with:anObject arguments do:[:argHere :argThere | 
        (argHere 
                semanticallyEqualTo:argThere
                withMapping: aDictionary
        ) ifFalse: [
            ^false
        ].
    ].
    "/ order?
    arguments doWithIndex:[:argName1 :argIndex|
        |argName2|

        argName2 := aDictionary at:argName1 name ifAbsent:argName1.
        (anObject arguments findFirst:[:arg | arg name = argName2]) = argIndex ifFalse:[^ false].
    ].
    
    arguments do:[:argHere |
        |name|
        
        name := argHere name.
        ((aDictionary at:name ifAbsent:name) = name) ifTrue:[
            aDictionary removeKey:name
        ].    
    ].    
    ^ self primitiveSources = anObject primitiveSources

    "Created: / 05-02-2017 / 00:55:18 / cg"
    "Modified: / 05-02-2017 / 02:23:33 / cg"
! !

!RBMethodNode methodsFor:'copying'!

postCopy
        super postCopy.
        self body: body copy.
        self arguments: (arguments collect: [:each | each copy])

    "Modified: / 18-06-2015 / 20:36:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!RBMethodNode methodsFor:'enumeration'!

variableNodesDo:aBlock
    "evaluate a Block for all variable nodes"

    arguments do:[:each | 
        each isPatternNode ifFalse:[ aBlock value: each]
    ].
    body notNil ifTrue:[ body variableNodesDo:aBlock].

    "Modified: / 16-11-2016 / 18:55:31 / cg"
! !

!RBMethodNode methodsFor:'initialization & release'!

selectorParts: tokenCollection arguments: variableNodes 
	selectorParts := tokenCollection.
	self arguments: variableNodes
! !

!RBMethodNode methodsFor:'matching'!

copyInContext: aDictionary 
	^(self class new)
		selectorParts: (selectorParts collect: [:each | each removePositions]);
		arguments: (arguments collect: [:each | each copyInContext: aDictionary]);
		body: (body copyInContext: aDictionary);
		source: (aDictionary at: '-source-');
		yourself
!

match: aNode inContext: aDictionary 
	self class == aNode class ifFalse: [^false].
	aDictionary at: '-source-' put: aNode source.
	self selector == aNode selector ifFalse: [^false].
	^(self matchList: arguments
		against: aNode arguments
		inContext: aDictionary)
			and: [body match: aNode body inContext: aDictionary]
! !

!RBMethodNode methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: self formattedCode
! !

!RBMethodNode methodsFor:'private'!

buildSelector
	| selectorStream |
	selectorStream := WriteStream on: (String new: 50).
	selectorParts do: [:each | selectorStream nextPutAll: each value].
	^selectorStream contents asSymbol
!

changeSourceSelectors: oldSelectorParts arguments: oldArguments
        "If this is the same number of arguments, we try a one to one replacement of selector parts and arguments. If this is not the case try to rewrite the signature as a whole, what unfortunately drops the comments within the signature."

        [ (oldSelectorParts size = selectorParts size and: [ oldArguments size = arguments size ])
                ifTrue: [
                        oldSelectorParts with: selectorParts do: [ :old :new | 
                                self addReplacement: (RBStringReplacement 
                                        replaceFrom: old start
                                        to: old stop
                                        with: new value) ].
                        oldArguments with: arguments do: [ :old :new | 
                                self addReplacement: (RBStringReplacement 
                                        replaceFrom: old start
                                        to: old stop
                                        with: new name) ] ]
                ifFalse: [
                        self addReplacement: (RBStringReplacement
                                replaceFrom: oldSelectorParts first start
                                to: (oldArguments notEmpty
                                        ifTrue: [ oldArguments last stop ]
                                        ifFalse: [ oldSelectorParts last stop ])
                                with: (String streamContents: [ :stream |
                                        selectorParts keysAndValuesDo: [ :index :part |
                                                index = 1 ifFalse: [ stream space ].
                                                stream nextPutAll: part value.
                                                index <= arguments size
                                                        ifTrue: [ stream space; nextPutAll: (arguments at: index) name ] ] ])) ] ]
                on: Error
                do: [ :ex | ex return ]
!

reformatSource
        | stream newSource newTree |
        stream := WriteStream on: (String new: source size + 100).
        stream
                nextPutAll: (source
                        copyFrom: (replacements
                                inject: 1
                                into: [ :sum :each | 
                                        stream
                                                nextPutAll: (source copyFrom: sum to: each startPosition - 1);
                                                nextPutAll: (each string).
                                        each stopPosition + 1 ])
                        to: source size).
        newSource := stream contents.
        newTree := RBParser 
                parseMethod: newSource 
                onError: [ :msg :pos | ^ self formattedCode ].
        self = newTree
                ifFalse: [ ^ self formattedCode ].
        ^ newSource
!

selectorParts
	^selectorParts
!

selectorParts: tokenCollection 
	selectorParts := tokenCollection
! !

!RBMethodNode methodsFor:'replacing'!

replaceNode: aNode withNode: anotherNode 
	aNode == body ifTrue: [self body: anotherNode].
	self arguments: (arguments 
				collect: [:each | each == aNode ifTrue: [anotherNode] ifFalse: [each]])
! !

!RBMethodNode methodsFor:'testing'!

defines: aName 
	^(arguments detect: [:each | each name = aName] ifNone: [nil]) notNil
!

isLast: aNode 
	^body isLast: aNode
!

isMethod
	^true
!

isPrimitive
        RBParser isSmalltalkX ifTrue:[
            (body notNil and:[body statements contains:[:node | node isSTXPrimitiveCCode]]) ifTrue:[
                ^ true
            ].
        ].
        ^tags notNil and: 
                        [tags isEmpty not and: 
                                        [(self primitiveSources detect: [:each | '*primitive*' match: each]
                                                ifNone: [nil]) notNil]]
!

lastIsReturn
	^body lastIsReturn
!

references: aVariableName 
	^body references: aVariableName
!

uses: aNode 
	^body == aNode and: [aNode lastIsReturn]
! !

!RBMethodNode methodsFor:'visitor'!

acceptCommentsAfterVisitor:aVisitor
    aVisitor formatMethodCommentsAfter:(self commentsAfter) for:self
!

acceptCommentsBeforeVisitor:aVisitor
    aVisitor formatMethodCommentsBefore:(self commentsBefore) for:self
!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptMethodNode: self
! !

!RBMethodNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

