"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Refactoring subclass:#MoveObjectRefactoring
	instanceVariableNames:'object targetScope originalScope referencesTo fromReferences'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!

!MoveObjectRefactoring class methodsFor:'documentation'!

documetation
"
    move an object (class, namespace) from it's current scope to another.

    There are basically two parts to this refactoring, aside from the actual move. 
    When the object is moved, we must look at all references to it and determine what changes need 
    to be made to them. We call these 'to' references. 
    We also have to consider everything that the object itself references, 
    and consider whether they need to be adjusted to accomodate the new home of the object. 
    We call these 'from' references.

    An additional term that shows up in this work is the term 'outer referencing variable'. 
    This is basically what we used to call 'globals'. It is a reference to any namespace, class, or share. 
    Or other words, any thing that is above the scope of an instance variable.

    UNFINISHED
"
! !

!MoveObjectRefactoring class methodsFor:'instance creation'!

model: aRBNameSpace moveObjectNamed: anObjectName to: aTargetScopeName
    ^(self new)
        model: aRBNameSpace;
        move: anObjectName to: aTargetScopeName;
        yourself
!

moveObjectNamed: anObjectName to: aTargetScopeName
    ^(self new)
        move: anObjectName to: aTargetScopeName;
        yourself
! !

!MoveObjectRefactoring methodsFor:'initialization-release'!

move: anObjectName to: aTargetScopeName
    "AnObjectName and aTargetScopeName should be results of absoluteName, not fullName."

    object := self model fullItemNamed: anObjectName.
    originalScope := object environment.
    targetScope := self model fullItemNamed: aTargetScopeName
! !

!MoveObjectRefactoring methodsFor:'preconditions'!

preconditions
    ^(RBCondition
        withBlock: [object isClassObject not or: [object isMeta not]]
        errorString:
            (#x1sIsInvalidObjectName << #browser >> '<1s> is not a valid object name'
                expandMacrosWith: object name))
        &
            (RBCondition
                withBlock: [targetScope isClassObject not]
                errorString:
                    (#x1sIsInvalidTargetScope << #browser >> '<1s> is not a valid move target'
                        expandMacrosWith: targetScope name))
! !

!MoveObjectRefactoring methodsFor:'printing'!

printOn: aStream 
    aStream nextPutAll: 'Move object'
!

storeOn: aStream
    aStream
        nextPutAll:
            ('(<1s> moveObjectNamed: <2p> to: <3p>)'
                expandMacrosWith: self class name "/ unambiguousName
                with: object name
                with: targetScope name)
! !

!MoveObjectRefactoring methodsFor:'rewriter-references-from'!

initReferenceFromRewriter: aParseTreeRewriter toAdjustBindingReferencesIn: anRBMethod
    
    aParseTreeRewriter
        replace: '`#literal'
        withValueFrom:
            [:node | 
            RBLiteralNode
                value:
                    (originalScope realNameSpace
                        fullyQualifiedReferenceOf: node value path last) makeUnambiguous]
        when:
            [:node | 
            node value isBindingReference
                and:
                    [node value path size = 1
                        and: [(anRBMethod modelClass canReference: node value path last) not]]]
!

initReferenceFromRewriter: aParseTreeRewriter toExpandSimpleNamesIn: anRBMethod
    
    aParseTreeRewriter
        replace: '`var'
        withValueFrom:
            [:node | 
            RBVariableNode
                named:
                    (originalScope realNameSpace fullyQualifiedReferenceOf: node name)
                        makeUnambiguous asString]
        when:
            [:node | 
            node isLocalVariable not
                and:
                    [(node name includes: $.) not
                        and:
                            [(node name asString =  object name asString) not
                                and:
                                    [(anRBMethod modelClass definesInstanceVariable: node name) not
                                        and: [(anRBMethod modelClass canReference: node name) not]]]]]
!

initReferenceFromRewriter: aParseTreeRewriter toReducedDottedNamesIn: anRBMethod
    
    aParseTreeRewriter
        replace: '`var'
        withValueFrom:
            [:node | RBVariableNode named: (node name tokensBasedOn: $.) last]
        when:
            [:node | 
            (node name includes: $.)
                and:
                    [| item |
                    (item := anRBMethod referencedItem: node name) notNil
                        and:
                            [item = (anRBMethod referencedItem: (node name tokensBasedOn: $.) last)]]]
!

initReferenceFromRewriterForRelativeNames: aParseTreeRewriter
    
    aParseTreeRewriter
        replace: '`var'
        withValueFrom:
            [:node | 
            | newBinding |
            newBinding := BindingReference
                path:
                    originalScope realItem fullyQualifiedReference path
                        , ((node name tokensBasedOn: $.) allButFirst: 1).   "Strip off redundant Smalltalk"
            (newBinding path size > 2
                and: [newBinding path first asString = 'Smalltalk'])
                ifTrue:
                    [newBinding := BindingReference path: (newBinding path allButFirst: 1)].
            RBVariableNode named: newBinding asString]
        when: [:node | (node name first: 2) = '_.']
!

referenceFromObjectRewriter: anRBMethod
    
    | rewriter |
    rewriter := ParseTreeRewriter new.
    self initReferenceFromRewriter: rewriter toExpandSimpleNamesIn:
            anRBMethod "expand to dotted names if need be".
    self initReferenceFromRewriter: rewriter toReducedDottedNamesIn:
            anRBMethod "next is a rule that turns _. names into true references".
    self initReferenceFromRewriterForRelativeNames:
            rewriter "this is for reducing dotted names that don't need to be anymore".
    self initReferenceFromRewriter: rewriter toAdjustBindingReferencesIn:
            anRBMethod "This third condition is for doctoring up #{BindingReferences} that doen't have dots".
    ^rewriter
! !

!MoveObjectRefactoring methodsFor:'rewriter-references-to'!

initReferencesToRewriter: aParseTreeRewriter toAdjustDottedNamesIn: anRBMethod
    
    aParseTreeRewriter
        replace: '`var'
        withValueFrom:
            [:node | 
            | restOfPath originalPath newPath |
            originalPath := node name tokensBasedOn: $..
            restOfPath := originalPath
                allButFirst: (originalPath indexOf: object name asString).
            newPath := (object unambiguousName tokensBasedOn: $.) , restOfPath.
            (newPath size > 2 and: [newPath first asString = 'Smalltalk'])
                ifTrue: [newPath := newPath allButFirst: 1].
            RBVariableNode named: (newPath fold: [:a :b | a , '.' , b])]
        when:
            [:node | 
            (node name includes: $.)
                and:
                    [((node name tokensBasedOn: $.) includes: object name asString)
                        and:
                            [((self model fullItemNamed: node name)
                                ifNotNil: [:variable | anRBMethod canReferenceObject: variable]
                                ifNil: [false]) not or: [(node name first: 2) = '_.']]]]
!

initReferencesToRewriter: aParseTreeRewriter toExpandSimpleNamesIn: anRBMethod
    
    aParseTreeRewriter
        replace: '`var'
        withValueFrom: [:node | RBVariableNode named: object unambiguousName]
        when:
            [:node | 
            node name asString = object name asString
                and: [(anRBMethod canReferenceObject: object) not]]
!

initReferencesToRewriter: aParseTreeRewriter toReduceDottedNamesIn: anRBMethod
    
    aParseTreeRewriter
        replace: '`var'
        withValueFrom: [:node | RBVariableNode named: object name]
        when:
            [:node | 
            (node name includes: $.)
                and:
                    [(node name tokensBasedOn: $.) last = object name asString
                        and: [anRBMethod canReferenceObject: object]]]
!

initReferencesToRewriterToFixBindingReferencesIn: aParseTreeRewriter
    
    aParseTreeRewriter
        replace: '`#literal'
        withValueFrom:
            [:node | 
            RBLiteralNode
                value:
                    (targetScope realNameSpace fullyQualifiedReferenceOf: node value path last)
                        makeUnambiguous]
        when:
            [:node | 
            node value isBindingReference
                and: [node value refersToLiteral: object binding]]
!

referenceToObjectRewriter: anRBMethod
    
    | rewriter |
    rewriter := ParseTreeRewriter new.
    self initReferencesToRewriter: rewriter toExpandSimpleNamesIn: anRBMethod.
    self initReferencesToRewriter: rewriter toReduceDottedNamesIn: anRBMethod.
    self initReferencesToRewriter: rewriter toAdjustDottedNamesIn: anRBMethod.
    self initReferencesToRewriterToFixBindingReferencesIn: rewriter.
    ^rewriter
! !

!MoveObjectRefactoring methodsFor:'transforming'!

doLocalMove
    "Make the changes to the RB model. This does not change any actual classes yet, but makes the model look like we want it to. This allows the rewrites to see the soon to be view of the world."

    targetScope items
        at: object name
        put: object.
    object environment removedItems add: object name.
    object parent: targetScope
!

findReferencesFromObject
    fromReferences := Set new.
    object
        outerReferencingMethodsDo:
            [:selector :method | fromReferences add: method]
!

findReferencesToObject
    referencesTo := OrderedCollection new.
    self model
        allReferencesToObject: object
        do:
            [:method | method modelClass = object ifFalse: [referencesTo add: method]]
!

fixReferencesFromObject
    fromReferences
        do:
            [:method | 
            self
                convertMethod: method
                using: (self referenceFromObjectRewriter: method)]
!

fixReferencesToObject
    
    referencesTo
        do:
            [:method | 
            self
                convertMethod: method
                using: (self referenceToObjectRewriter: method)]
!

migrateObject
    self model changes
        addChange:
            (MigrateObjectChange
                move: object unambiguousName
                to: targetScope unambiguousName)
!

transform
    self findReferencesToObject.
    self findReferencesFromObject.
    self migrateObject.
    self doLocalMove.
    self fixReferencesToObject.
    self fixReferencesFromObject
! !

!MoveObjectRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/MoveObjectRefactoring.st,v 1.1 2009-09-21 21:28:55 cg Exp $'
! !
