"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCRewritingVisitor subclass:#PPCLL1Visitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!

!PPCLL1Visitor methodsFor:'as yet unclassified'!

isDeterministicChoice: node
    | firsts |
    firsts := OrderedCollection new.
    node children do: [ :child |
        (self startsWithToken: child) ifFalse: [ ^ false ].
        firsts addAll: child firstSetWithTokens.
    ].
    (firsts asIdentitySet size = firsts size) ifFalse: [ ^ false ].

    firsts do:[:e1 |
        firsts do:[:e2 |     
            e1 == e2 ifFalse: [
                (e1 overlapsWith: e2) ifTrue: [ ^ false ] ].
        ].
    ].
    ^ true

    "Modified: / 10-05-2015 / 07:27:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startsWithToken: node
    | firstSet terminal total |
    total := 0.
    firstSet := node firstSetWithTokens.
        
    terminal := (firstSet detect: [ :e | e isTerminal ] ifNone: [ nil ]).
    terminal isNil ifFalse: [ ^ false ].
        
    ^ true
!

visitChoiceNode: node
    super visitChoiceNode: node.
    (self isDeterministicChoice: node) ifTrue: [ 
        self change.
        ^ PPCDeterministicChoiceNode new
            children: node children;
            name: node name;
            firstFollowCache: node firstFollowCache;
            yourself
    ].

    ^ node
! !

