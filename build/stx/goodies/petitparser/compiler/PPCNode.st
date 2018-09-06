"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCNode
	instanceVariableNames:'contextFree name properties'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCNode class methodsFor:'as yet unclassified'!

new
    ^ self basicNew initialize
! !

!PPCNode methodsFor:'PetitParser mimicry'!

allParsersDo: aBlock
    "I need to mimic PetitParser protocol in order to get transformed from PPParser to PPCNode"
    ^ self allNodesDo: aBlock
!

allParsersDo: aBlock seen: aSet
    "I need to mimic PetitParser protocol in order to get transformed from PPParser to PPCNode"
    ^ self allNodesDo: aBlock seen: aSet
! !

!PPCNode methodsFor:'accessing'!

children
    ^ #()
!

defaultName
    ^ 'node' 
!

firstFollowCache
    ^ self propertyAt: #firstFollowCache ifAbsentPut: [ IdentityDictionary new ]
!

firstFollowCache: value
    self propertyAt: #firstFollowCache put: value
!

markForGuard
    "Marks receiver for guards, i.e., it's guard code
     should be part of the generated code"
    self propertyAt: #guard put: true
!

markForInline
    "Marks receiver for inlining, i.e., it's parsing code
     should be inlined into parent's code"
    self propertyAt: #inlined put: true

    "Created: / 23-04-2015 / 15:39:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ name
!

name: anObject
"	(anObject asString beginsWith: 'symbolLiteral') ifTrue: [ self halt. ]."
    name := anObject
!

nameOrEmptyString
    ^ self hasName ifTrue: [ self name ] ifFalse: [ '' ]
!

parser
    ^ self propertyAt: #parser ifAbsent: [ nil ]
!

parser: value
    self propertyAt: #parser put: value
!

prefix
    ^ nil
!

suffix
    ^ self isMarkedForInline ifTrue: [ 'inlined' ] ifFalse: [ nil ]
!

unmarkForGuard
    "Forbids compiling of guards, if guards would be available"
    self propertyAt: #guard put: false

    "Created: / 23-04-2015 / 15:39:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unmarkForInline
    "Forbids inlining of receiver's parsing code"
    self propertyAt: #inlined put: false

    "Created: / 23-04-2015 / 15:39:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCNode methodsFor:'accessing-fsa'!

fsa
    ^ self propertyAt: #fsa
!

fsa: aPEGFsa
    self propertyAt: #fsa put: aPEGFsa
!

hasFsa
    ^ self hasProperty: #fsa
!

hasNextFsa
    ^ self hasProperty: #nextFsa
!

nextFsa
    ^ self propertyAt: #nextFsa
!

nextFsa: aPEGFsa
    self propertyAt: #nextFsa put: aPEGFsa
! !

!PPCNode methodsFor:'accessing-properties'!

hasProperty: aKey
    "Test if the property aKey is present."
    
    ^ properties notNil and: [ properties includesKey: aKey ]
!

properties
    ^ properties
!

properties: aDictionary
    properties := aDictionary 
!

propertyAt: aKey 
    ^ self propertyAt: aKey  ifAbsent: [ nil ]
!

propertyAt: aKey ifAbsent: aBlock
    "Answer the property value associated with aKey or, if aKey isn't found, answer the result of evaluating aBlock."
    
    ^ properties isNil
        ifTrue: [ aBlock value ]
        ifFalse: [ properties at: aKey ifAbsent: aBlock ]
!

propertyAt: aKey ifAbsentPut: aBlock
    "Answer the property associated with aKey or, if aKey isn't found store the result of evaluating aBlock as new value."
    
    ^ self propertyAt: aKey ifAbsent: [ self propertyAt: aKey put: aBlock value ]
!

propertyAt: aKey put: anObject
    "Set the property at aKey to be anObject. If aKey is not found, create a new entry for aKey and set is value to anObject. Answer anObject."

    ^ (properties ifNil: [ properties := Dictionary new: 1 ])
        at: aKey put: anObject
! !

!PPCNode methodsFor:'analysis'!

acceptsEpsilon
    "return true, if parser can accept epsilon without failure"
    ^ self subclassResponsibility
!

acceptsEpsilonOpenSet: set
    "private helper for acceptsEmpsilon that makes sure to avoid cycles (using open set)"
    self children isEmpty ifTrue: [ ^ self acceptsEpsilon ].
    
    self shouldBeImplemented .
!

allNodes
    | result |
    result := OrderedCollection new.
    self allParsersDo: [ :parser | result add: parser ].
    ^ result
!

allNodesDo: aBlock
    "Iterate over all the parse nodes of the receiver."

    self allNodesDo: aBlock seen: IdentitySet new
!

allNodesDo: aBlock seen: aSet
    "Iterate over all the parse nodes of the receiver, do not visit and follow the ones contained in aSet."

    (aSet includes: self) ifTrue: [ ^ self ].
    
    aSet add: self.
    aBlock value: self.
    self children do: [ :each | 
        each allNodesDo: aBlock seen: aSet 
    ]
!

check
    "nothing to do"
    ^ nil
!

checkTree
    | message |
    self allNodes do: [ :node | (message := node check) ifNotNil: [ self error: message ]  ].
!

firstCharSetCached
    ^ self propertyAt: #firstCharSet ifAbsentPut: [ self firstCharSet ].
!

hasFiniteLanguage
    ^ self recognizedSentences isEmpty not
!

isContextFree
    ^ contextFree ifNil: [ contextFree := self allNodes allSatisfy: [ :n | n isContextFreePrim  ] ]
!

isContextFreePrim
    ^ true
!

isFirstSetTerminal
    "Answer true if the receiver is a terminal or leaf parser, that means it does not delegate to any other parser."

    ^ self isTerminal
!

isNullable
    "Answer true if the receiver is a nullable parser, e.g. it can successfully parse nothing."
    
    ^ false
!

isTerminal
    "Answer true if the receiver is a terminal or leaf parser, that means it does not delegate to any other parser."

    ^ self children isEmpty
!

overlapsWith: anotherNode
    | finite infinite |
    "infinite - infinite"
    (self hasFiniteLanguage not and: [ anotherNode hasFiniteLanguage not ]) ifTrue: [ 
        ^ false
    ].
    
    "finite - finite"
    (self hasFiniteLanguage and: [ anotherNode hasFiniteLanguage ]) ifTrue: [ 
        | union cnt|
        cnt := self recognizedSentences size + anotherNode recognizedSentences size.
        
        union :=  Set new
                addAll: self recognizedSentences;
                addAll: anotherNode recognizedSentences;
                yourself.
        ^ (union size = cnt) not.
    ].

    self hasFiniteLanguage ifTrue: [ 
        finite := self.
        infinite := anotherNode.
    ] ifFalse: [ 
 		finite := anotherNode.
        infinite := self.	
    ].
        
    finite recognizedSentences do: [ :sentence |
        (infinite parser matches: sentence) ifTrue: [ ^ true ].
    ].
    ^ false
    
!

recognizedSentences
    ^ self propertyAt: #recognizedSentences ifAbsentPut: [ self recognizedSentencesPrim ].
!

recognizedSentencesPrim
    ^ #()
! !

!PPCNode methodsFor:'comparing'!

= anotherNode
    (self == anotherNode) ifTrue: [ ^ true ].
    (anotherNode class = self class) ifFalse: [ ^ false ].
    
    (anotherNode name = name) ifFalse: [ ^ false ].
    (anotherNode isMarkedForInline  = self isMarkedForInline) ifFalse: [ ^ false ].
    ^ anotherNode children = self children.
!

hash
    "TODO JK: IMO not a good hashing function bacause of children size, 
        but at least it is not recursive, which would be worse :)
    "
    ^ self class hash bitXor: (name hash bitXor: (self isMarkedForInline hash bitXor: (self children size hash)))
! !

!PPCNode methodsFor:'converting'!

asCompilerTree
    ^ self

    "Created: / 29-08-2015 / 07:43:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCNode methodsFor:'copying'!

postCopy
    super postCopy.
    properties := properties copy
! !

!PPCNode methodsFor:'first follow next'!

firstSet
    ^ self firstFollowCache  at: #firstSet ifAbsentPut: [
        self firstSets at: self
    ]
!

firstSet: set
    self firstFollowCache  at: #firstSet put: set
!

firstSetSuchThat: block
    ^ (self firstSetsSuchThat: block) at: self
!

firstSetWithProductions
    ^ self firstFollowCache  at: #firstSetWithProductions ifAbsentPut: [ 
        self firstSetSuchThat: [:e | e name isNil not ].
    ]
!

firstSetWithProductions: aSet
    ^ self firstFollowCache  at: #firstSetWithProductions put: aSet
!

firstSetWithTokens
    ^ self firstFollowCache  at: #firstSetWithTokens ifAbsentPut: [ 
        self firstSetSuchThat: [:e | e isTerminal or: [ e isTokenNode ] ].
    ]
!

firstSetWithTokens: aSet
    ^ self firstFollowCache  at: #firstSetWithTokens put: aSet
!

firstSets
    ^ self firstSetsSuchThat: [ :e | e isFirstSetTerminal ]
!

firstSets: aFirstDictionary into: aSet suchThat: aBlock
    "PRIVATE: Try to add additional elements to the first-set aSet of the receiver, use the incomplete aFirstDictionary."

    (aBlock value: self) ifFalse: [ 
        self children do: [ :node | aSet addAll: (aFirstDictionary at: node) ]
    ]
!

firstSetsSuchThat: block

    | firstSets |
    firstSets := IdentityDictionary new.
    self allNodesDo: [ :each |
        firstSets at: each put: ((block value: each)
            ifTrue: [ IdentitySet with: each ]
            ifFalse: [ IdentitySet new ]).
        each isNullable
            ifTrue: [ (firstSets at: each) add: PPCSentinelNode instance ] ].
        
        
    [	| changed tally |
        changed := false.
        firstSets keysAndValuesDo: [ :node :first |
            tally := first size.
            node firstSets: firstSets into: first suchThat: block.
            changed := changed or: [ tally ~= first size ] ].
        changed ] whileTrue.
    ^ firstSets
!

followSet
    ^ self firstFollowCache at: #followSet ifAbsent: [ 
        self error: 'no follow set cached' 
    ]
!

followSet: aSet
    ^ self firstFollowCache at: #followSet put: aSet
!

followSetIn: rootNode
    ^ rootNode followSets at: self
!

followSetWithTokens
    ^ self firstFollowCache  at: #followSetWithTokens ifAbsent: [ 
        self error: 'no follow with tokens cached' 
    ]
!

followSetWithTokens: aSet
    ^ self firstFollowCache  at: #followSetWithTokens put: aSet
!

followSets
    ^ self followSetsSuchThat: [ :e | e isFirstSetTerminal ]
!

followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet suchThat: aBlock
    "PRIVATE: Try to add additional elements to the follow-set aSet of the receiver, use the incomplete aFollowDictionary and the complete aFirstDictionary."
    
    self children do: [ :node | (aFollowDictionary at: node) addAll: aSet ]
!

followSetsSuchThat: aBlock
    "Answer a dictionary with all the parsers reachable from the receiver as key and their follow-set as value. The follow-set of a parser is the list of terminal parsers that can appear immediately to the right of that parser."
    
    | current previous continue firstSets followSets |
    current := previous := 0.
    firstSets := self firstSetsSuchThat: aBlock.
    followSets := IdentityDictionary new.
    self allNodesDo: [ :each | followSets at: each put: IdentitySet new ].
    (followSets at: self) add: PPCSentinelNode instance.
    [	followSets keysAndValuesDo: [ :node :follow |
            node 
                followSets: followSets
                firstSets: firstSets
                into: follow
                suchThat: aBlock ].
        current := followSets
            inject: 0
            into: [ :result :each | result + each size ].
        continue := previous < current.
        previous := current.
        continue ] whileTrue.
    ^ followSets
!

nextSetIn: rootNode
    ^ rootNode nextSets at: self
!

nextSets
        | nextSets |
    
    nextSets := IdentityDictionary new.
    self allNodesDo: [ :each | nextSets at: each put: IdentitySet new ].
    
    (nextSets at: self) add: PPCSentinelNode instance.
    
    [ 	| changed |
        changed := false.
    
        nextSets keysAndValuesDo: [:node :next |
            changed := (node 
                nextSets: nextSets
                into: next) or: [ changed ].
        ].
        changed ] whileTrue.
    
    ^ nextSets
!

nextSets: aNextDictionary into: aSet
    "return true/false, if something has changed or not...."
    | childSet change tally |
    
    change := false.
    
    self children do: [:each | 
        childSet := aNextDictionary at: each.
        tally := childSet size.
        childSet addAll: aSet.
        change := change or: [ tally ~= childSet size ].
    ].

    ^ change
    
! !

!PPCNode methodsFor:'gt'!

gtTreeViewIn: composite
    <gtInspectorPresentationOrder: 40>

    composite tree
            title: 'Tree';
            children: [:n | n children ];
            format: [:n| String streamContents: [:s | n printOn: s. n printHashOn: s] ];
            shouldExpandToLevel: 6
! !

!PPCNode methodsFor:'inspecting'!

inspector2TabTree
    <inspector2Tab>

    ^ (self newInspector2Tab)
        label:'Tree';
        priority:50;
        view: [
            | list view |

            list := PluggableHierarchicalList new.
            list childBlock: [ :parent | parent children ].
            list labelBlock: [ :child | child printString ].
            list root: self.
            view := ScrollableView for:HierarchicalListView.
            view useDefaultIcons: false.
            view list: list.
            view
        ];
        yourself

    "Modified: / 22-05-2015 / 17:05:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 18-06-2015 / 06:04:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCNode methodsFor:'printing'!

printHashOn: aStream
    aStream print: 'Hash:', self hash asString
!

printIdOn: aStream
    aStream print: 'ID:', self identityHash asString
!

printNameOn: aStream
    self name isNil
        ifFalse: [ aStream nextPutAll: self name. aStream nextPut: $-.  ].
        
    aStream print: self identityHash
!

printOn: aStream
    super printOn: aStream.
    aStream nextPut: $(.
    self printNameOn: aStream.
    self isMarkedForInline ifTrue:[ 
        aStream nextPutAll: ' INL'
    ].
    aStream nextPut: $)

    "Modified: / 22-05-2015 / 15:34:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCNode methodsFor:'testing'!

canHavePPCId
    ^ true
!

hasName
    ^ (name == nil) not
!

isMarkedForInline
    ^ self propertyAt: #inlined ifAbsent: [ false ].

    "Created: / 23-04-2015 / 15:40:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSequenceNode
    ^ false

    "Created: / 15-06-2015 / 18:29:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTokenNode
    ^ false
!

isTrimmingTokenNode
    ^ false
! !

!PPCNode methodsFor:'transformation'!

asCompilerNode
    ^ self
!

asFsa
    | visitor |
    visitor := PEGFsaGenerator new.
    ^ (visitor visit: self)
        name: self name;
        yourself
    
!

replace: node with: anotherNode
!

transform: aBlock
    "Answer a copy of all parsers reachable from the receiver transformed using aBlock."
    | mapping root |
    mapping := IdentityDictionary new.
    self allNodesDo: [ :each |
        mapping
            at: each
            put: (aBlock value: each copy) ].
    root := mapping at: self.
    [	| changed |
        changed := false.
        root allNodesDo: [ :each |
            each children do: [ :old |
                mapping at: old ifPresent: [ :new |
                    each replace: old with: new.
                    changed := true ] ] ].
        changed ] whileTrue.
    ^ root
! !

!PPCNode methodsFor:'visiting'!

accept: visitor
    visitor visitNode: self
! !

!PPCNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

