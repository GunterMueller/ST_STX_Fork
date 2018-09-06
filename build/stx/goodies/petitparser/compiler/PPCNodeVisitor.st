"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCNodeVisitor
	instanceVariableNames:'openSet closeSet cache'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!


!PPCNodeVisitor class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!PPCNodeVisitor methodsFor:'hooks'!

afterAccept: node retval: retval
    "nothing to do"
    ^ retval
!

beforeAccept: node
    "nothing to do"
!

closedDetected: node
    ^ #closed
!

openDetected: node
    ^ #open
! !

!PPCNodeVisitor methodsFor:'initialization'!

initialize
    super initialize.
    openSet := IdentitySet new.
    closeSet := IdentitySet new.	
    cache := IdentityDictionary new.
! !

!PPCNodeVisitor methodsFor:'traversing'!

close: node
    self assert: (self isOpen: node) description: 'should be opened first!!'.
    openSet size > 500 ifTrue: [ self error: 'This seems to be a bit too much, isnt it?' ].
        
    openSet remove: node.
    closeSet add: node
!

isClosed: child
    ^ closeSet includes: child
!

isOpen: child
    ^ openSet includes: child
!

open: node
    self assert: (self isOpen: node) not description: 'already opened!!'.
    openSet size > 100 ifTrue: [ self error: 'This seems to be a bit too much, isnt it?' ].
    openSet add: node
!

visit: node
    | retval |
    (self isOpen: node) ifTrue: [ 
        ^ self openDetected: node
    ].

    (self isCached: node) ifTrue: [ 
        ^ self cachedDetected: node.
    ].

    (self isClosed: node) ifTrue: [ 
        self closedDetected: node
    ].

    self open: node.
    self beforeAccept: node.
    retval := node accept: self.
    retval := self afterAccept: node retval: retval.
    self close: node.
    self cache: node value: retval.	
    
    ^ retval
!

visitChildren: node
    node children do: [ :child | 
        self visit: child
    ]
! !

!PPCNodeVisitor methodsFor:'traversing - caching'!

cache: node value: retval
    self assert: (cache includesKey: node) not.
    cache at: node put: retval
!

cachedDetected: node
    ^ self cachedValue: node
!

cachedValue: node
    ^ cache at: node
!

isCached: node
    ^ cache includesKey: node
! !

!PPCNodeVisitor methodsFor:'visiting'!

visitActionNode: node
    ^ self visitNode: node
!

visitAndNode: node
    ^ self visitNode: node
!

visitAnyNode: node
    ^ self visitNode: node
!

visitCharSetPredicateNode: node
    ^ self visitNode: node
!

visitCharacterNode: node
    ^ self visitNode: node
!

visitChoiceNode: node
    ^ self visitNode: node
!

visitDeterministicChoiceNode: node
    ^ self visitNode: node
!

visitEndOfFileNode: node
    ^ self visitNode: node
!

visitEndOfInputNode: node
    ^ self visitNode: node
!

visitForwardNode: node
    ^ self visitNode: node
!

visitLiteralNode: node
    "default implementation"
    ^ self visitNode: node.
!

visitMappedActionNode: node
    ^ self visitActionNode: node

    "Created: / 02-06-2015 / 17:28:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitMessagePredicateNode: node
    ^ self visitNode: node
!

visitNilNode: node
    ^ self visitNode: node
!

visitNode: node
    self visitChildren: node.
    ^ node
!

visitNotCharSetPredicateNode: node
    ^ self visitNode: node
!

visitNotCharacterNode: node
    ^ self visitNode: node
!

visitNotLiteralNode: node
    ^ self visitNode: node
!

visitNotMessagePredicateNode: node
    ^ self visitNode: node
!

visitNotNode: node
    ^ self visitNode: node
!

visitOptionalNode: node
    ^ self visitNode: node
!

visitPluggableNode: node
    ^ self visitNode: node
!

visitPlusNode: node
    ^ self visitNode: node
!

visitPredicateNode: node
    ^ self visitNode: node
!

visitRecognizingSequenceNode: node
    ^ self visitNode: node
!

visitSequenceNode: node
    ^ self visitNode: node
!

visitStarAnyNode: node
    ^ self visitNode: node
!

visitStarCharSetPredicateNode: node
    ^ self visitNode: node
!

visitStarMessagePredicateNode: node
    ^ self visitNode: node
!

visitStarNode: node
    ^ self visitNode: node
!

visitSymbolActionNode: node
    ^ self visitNode: node
!

visitTokenActionNode: node
    ^ self visitNode: node
!

visitTokenChoiceNode: node
    ^ self visitNode: node
!

visitTokenConsumeNode: node
    ^ self visitNode: node
!

visitTokenNode: node
    ^ self visitNode: node
!

visitTokenStarMessagePredicateNode: node
    ^ self visitNode: node
!

visitTokenStarSeparatorNode: node
    ^ self visitNode: node
!

visitTokenWhitespaceNode: node
    ^ self visitNode: node
!

visitTokenizingParserNode: node
    ^ self visitNode: node
!

visitTrimNode: node
    ^ self visitNode: node
!

visitTrimmingTokenCharacterNode: node
    ^ self visitNode: node
!

visitTrimmingTokenNode: node
    ^ self visitNode: node
!

visitUnknownNode: node
    ^ self visitNode: node
! !

!PPCNodeVisitor class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

