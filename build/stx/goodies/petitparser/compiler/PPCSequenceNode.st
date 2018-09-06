"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCListNode subclass:#PPCSequenceNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCSequenceNode methodsFor:'accessing'!

defaultName
    ^ #seq
!

preferredChildrenVariableNames
    "Return an array of preferred variable names of variables where to store
     particular child's result value."

    | names |

    names := self propertyAt: #preferredChildrenVariableNames ifAbsent:[ nil ].
    names notNil ifTrue:[ ^ names ].
    names := OrderedCollection new.
    self children do:[:child |  
        | id |

        id := child name notNil ifTrue:[ child name ] ifFalse:[ 'c' ].
        (names includes: id) ifTrue:[ 
            | i |

            i := 1.
            [ names includes: (id , '_' , i printString) ] whileTrue:[ 
                i := i + 1.
            ].
            id := (id , '_' , i printString).
        ].
        names add: id.
    ].                
    self propertyAt: #preferredChildrenVariableNames put: names.
    ^ names

    "Created: / 04-06-2015 / 23:08:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

preferredChildrenVariableNames: aSequenceableCollection
    "Sets an array of preferred variable names"

    self propertyAt: #preferredChildrenVariableNames put: aSequenceableCollection

    "Created: / 04-06-2015 / 23:09:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

returnParsedObjectsAsCollection
    ^ self propertyAt: #returnParsedObjectsAsCollection ifAbsent:[ true ]

    "Created: / 04-06-2015 / 23:43:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

returnParsedObjectsAsCollection: aBoolean
    self propertyAt: #returnParsedObjectsAsCollection put: aBoolean

    "Created: / 04-06-2015 / 23:43:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSequenceNode methodsFor:'analysis'!

acceptsEpsilon
    ^ self acceptsEpsilonOpenSet: IdentitySet new.
!

acceptsEpsilonOpenSet: set
    set add: self.
    ^ self children allSatisfy: [:e | e acceptsEpsilonOpenSet: set ]
!

firstSetSuchThat: block into: aCollection openSet: aSet
    (aSet includes: self) ifTrue: [ ^ aCollection ].
    aSet add: self.
    
    (block value: self) ifTrue: [ aCollection add: self. ^ aCollection ].
    
    self children do: [ :child | 
        child firstSetSuchThat: block into: aCollection openSet: aSet.
        child acceptsEpsilon ifFalse: [ ^ aCollection ]
    ].
    ^ aCollection
!

firstSets: aFirstDictionary into: aSet suchThat: aBlock
    | nullable |
    
    "TODO JK: aBlock is ignored by now"
    children do: [ :node |
        nullable := false.
        (aFirstDictionary at: node) do: [ :each |
            each isNullable
                ifTrue: [ nullable := true ]
                ifFalse: [ aSet add: each ] ].
        nullable
            ifFalse: [ ^ self ] ].
    aSet add: PPCSentinelNode instance
!

recognizedSentencesPrim
    | retval |
    (self children anySatisfy: [ :child | child hasFiniteLanguage not ]) ifTrue: [ ^ #() ].
    
    retval := Set with: ''.
    
    self children do: [ : child |
        | set |
        set := Set new.

        child recognizedSentences do: [ :suffix |
            retval do: [ :prefix |
                set add: prefix, suffix.
         				]
        ].
        retval := set.
    ].
    ^ retval asArray
! !

!PPCSequenceNode methodsFor:'compiling'!

addGuard: compiler id: id
    |  guard firsts |
    (compiler guards not or: [(guard := PPCGuard on: self) makesSense not]) ifTrue: [ ^ self].

    firsts := (self firstSetSuchThat: [ :e | (e isKindOf: PPCTrimmingTokenNode) or: [ e isTerminal ] ]).

    
    (firsts allSatisfy: [ :e | e isKindOf: PPCTrimmingTokenNode ]) ifTrue: [  
        "If we start with trimming, we should invoke the whitespace parser"
        firsts anyOne compileWhitespace: compiler.
        
        compiler add: 'context atEnd ifTrue: [ ^ self error ].'.
        guard id: id, '_guard'.
        guard compileGuard: compiler.
        compiler addOnLine: 'ifFalse: [ ^ self error ].'
    ].

    (firsts allSatisfy: [ :e | e isTerminal ]) ifTrue: [  
        compiler add: 'context atEnd ifTrue: [ ^ self error ].'.
        guard id: id, '_guard'.
        guard compileGuard: compiler.
        compiler addOnLine: 'ifFalse: [ ^ self error ].'
    ].
! !

!PPCSequenceNode methodsFor:'first follow next'!

followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet suchThat: aBlock
    children keysAndValuesDo: [ :index :node |
        | follow first |
        follow := aFollowDictionary at: node.
        index = children size
            ifTrue: [ follow addAll: aSet ]
            ifFalse: [
                (self class withAll: (children 
                    copyFrom: index + 1 to: children size))
                        firstSets: aFirstDictionary
                        into: (first := IdentitySet new)
                        suchThat: aBlock.
                (first anySatisfy: [ :each | each isNullable ])
                    ifTrue: [ follow addAll: aSet ].
                follow addAll: (first 
                    reject: [ :each | each isNullable ]) ] ]
! !

!PPCSequenceNode methodsFor:'testing'!

isSequenceNode
    ^ true

    "Created: / 15-06-2015 / 18:29:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSequenceNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitSequenceNode: self
! !

!PPCSequenceNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

