"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCPassVisitor subclass:#PEGFsaGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaGenerator methodsFor:'accessing'!

name
    ^ self printString

    "Created: / 17-08-2015 / 13:13:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PEGFsaGenerator methodsFor:'hooks'!

afterAccept: node retval: retval
    retval checkSanity.
    ^ super afterAccept: node retval: retval
!

cache: node value: retval
    (self assert: (retval isKindOf: PEGFsa)).

    (cache includesKey: node) ifTrue: [
        self assert: (retval isIsomorphicTo: (cache at: node)).
    ].

    "I put copy of the FSA because FSA can be modified (e.g. concatenated to other FSA)"
    cache at: node put: retval copy.
!

openDetected: node
    "
        This should be called when there is a recursive definition of a token.
        The forward node caches the fsa stub with startState in order to reference it
    "
    ^ (self cachedValue: node)
! !

!PEGFsaGenerator methodsFor:'support'!

connect: fsa with: anotherFsa
    | finals |
    finals := fsa finalStates reject: [:s | s isFsaFailure ].

    self assert: (finals allSatisfy: [ :s | s priority = 0 ]).
    self assert: (finals allSatisfy: [:f | fsa states includes: f]).
    
    finals do: [ :final |
        | toAdopt |
        toAdopt := anotherFsa.
        toAdopt decreasePriority.
        final final: false.	

        fsa adopt: toAdopt.
        fsa addTransitionFrom: final to: toAdopt startState.
    ].
!

connectOverlapping: fsa with: anotherFsa
    | finals |
    finals := fsa finalStates reject: [:s | s isFsaFailure ].

    self assert: (finals allSatisfy: [ :s | s priority = 0 ]).
    self assert: (finals allSatisfy: [:f | fsa states includes: f]).
    
    finals do: [ :final |
        | toAdopt |
        toAdopt := anotherFsa copy.
        toAdopt decreasePriority.
        final final: false.	

        fsa adopt: toAdopt.
        fsa addTransitionFrom: final to: toAdopt startState.
    ].
!

sequenceOf: fsa and: anotherFsa
    | newFsa start   |

    newFsa := PEGFsa new.
    start := PEGFsaState new name: 'start'; yourself.
    newFsa addState: start.
    newFsa startState: start.
    newFsa adopt: fsa.
    newFsa addTransitionFrom: start to: fsa startState.

    (newFsa finalStates size == 1) ifTrue: [  
        self connect: newFsa with: anotherFsa.
    ] ifFalse: [ 
    (newFsa finalStates allSatisfy: [ :s | s transitions isEmpty ]) ifTrue: [  
        self connect: newFsa with: anotherFsa.
    ] ifFalse: [ 
        self connectOverlapping: newFsa with: anotherFsa.
    ]].
    
    newFsa determinize.
    ^ newFsa
! !

!PEGFsaGenerator methodsFor:'visiting'!

visitAnyNode: node
    | stop start fsa classification |
    start := PEGFsaState new.
    stop := PEGFsaState new.
    
    classification := Array new: 255 withAll: true.
    
    fsa := PEGFsa new
        addState: start;
        addState: stop;
        
        startState: start;
        finalState: stop;
        yourself.
    
    fsa addTransitionFrom: start to: stop onCharacterSet: (classification).
    
    ^ fsa
!

visitCharSetPredicateNode: node
    | stop start fsa |
    start := PEGFsaState new.
    stop := PEGFsaState new.
    
    fsa := PEGFsa new
        addState: start;
        addState: stop;
        
        startState: start;
        finalState: stop;
        yourself.
    
    fsa addTransitionFrom: start to: stop onCharacterSet: (node predicate classification).
        
    ^ fsa
!

visitCharacterNode: node
    | stop start |
    start := PEGFsaState new.
    stop := PEGFsaState new.
    stop name: node character storeString.
    
    ^ PEGFsa new
        addState: start;
        addState: stop;
        
        startState: start;
        finalState: stop;

        addTransitionFrom: start to: stop on: node character;
        yourself
!

visitChoiceNode: node
    | priority childrenFsa fsa start |
    childrenFsa := node children collect: [ :child | child accept: self ].
    self assert: (childrenFsa allSatisfy: [ :child | child isDeterministic  ]).

    fsa := PEGFsa new.
    start := PEGFsaState new.
    
    fsa addState: start.
    fsa startState: start.

    priority := 0.
    childrenFsa do: [ :childFsa |
        childFsa decreasePriorityBy: priority.
        fsa adopt: childFsa.
        fsa addTransitionFrom: start to: childFsa startState.
        priority := priority + 1.
        
        fsa determinizeChoice.
    ].

    ^ fsa
!

visitEndOfFileNode: node
    | stop start fsa transition |
    start := PEGFsaState new.
    stop := PEGFsaState new.
    stop name: 'EOF'.
    
    fsa := PEGFsa new
        addState: start;
        addState: stop;
        
        startState: start;
        finalState: stop;

        yourself.
        
    transition := PEGFsaEOFTransition new
        predicate: [ :cp | cp == 0 ];
        destination: stop;
        yourself.
        
    start addTransition: transition.
    ^ fsa
!

visitForwardNode: node
    | fsa childFsa startState startStubState |

    fsa	 := PEGFsa new.
    startStubState := PEGFsaUncopiableState new.
    startState := PEGFsaState new.

    fsa addState: startStubState.
    fsa startState: startStubState.


    "  cache the incomplete fsa in order to allow for
        recursive back references... 
    "	
    self cache: node value: fsa.

    childFsa := self visit: node child.
    
    cache removeKey: node.
    
    fsa adopt: childFsa.
    fsa replace: startStubState with: startState.


    fsa addTransitionFrom: startState to: childFsa startState.
    fsa startState: startState.

    fsa name: self name.
    ^ fsa
!

visitLiteralNode: node
    | states fsa |

    states := OrderedCollection new.
    (node literal size + 1) timesRepeat: [
        states add: PEGFsaState new
    ].

    fsa := PEGFsa new.
    states do: [ :state | fsa addState: state ].	
    fsa	 startState: states first;
         finalState: states last;
         yourself.
        
    (1 to: (states size - 1)) do: [ :index |
        fsa addTransitionFrom: (states at: index)
         	 to: (states at: index + 1)
             on: (node literal at: index).
        "set the name"
        (states at: (index + 1)) name: (node literal at: index). 
    ].

    fsa name: node literal.
    ^ fsa
!

visitMessagePredicateNode: node
    ^ self visitPredicateNode: node
!

visitNilNode: node
    "not much to do here..."
    | startState |
    startState  := PEGFsaState new.
    
    ^ PEGFsa new
        addState: startState;
        startState: startState;
        finalState: startState;
        yourself
!

visitNode: node
    self error: 'node not supported'
!

visitNotCharacterNode: node
    self assert: (node child isKindOf: PPCCharacterNode).
    
    ^ self visitNotNode: node
!

visitNotNode: node
    | fsa finalState |
    fsa := node child accept: self.
    finalState := PEGFsaState new
        name: '!!', fsa name asString;
        yourself.
    
    fsa finalStates do: [ :fs |
        fs failure: true.
    ].
    
    fsa finalState: fsa startState.
    
    ^ fsa
!

visitOptionalNode: node
    | fsa   |

    fsa := node child accept: self.
    fsa finalState: fsa startState.

    ^ fsa
!

visitPlusNode: node
    | fsa |

"	finalState := PEGFsaState new."
    fsa := node child accept: self.
"	fsa addState: finalState."
    
    fsa finalStates do: [ :state |
        fsa addTransitionFrom: state to: (fsa startState).
"		fsa addTransitionFrom: state to: finalState priority: fsa minPriority."
"		state hasPriority ifFalse: [ state priority: 0 ].
        state final: false.
"	].

"	fsa finalState: finalState.	"
    
    ^ fsa
!

visitPredicateNode: node
    | stop start fsa classification |
    start := PEGFsaState new.
    stop := PEGFsaState new.
    
    classification := (1 to: 255) collect: [:codePoint | node predicate value: (Character codePoint: codePoint) ].
    
    fsa := PEGFsa new
        addState: start;
        addState: stop;
        
        startState: start;
        finalState: stop;
        yourself.
    
    fsa addTransitionFrom: start to: stop onCharacterSet: (classification).
    
    ^ fsa
!

visitSequenceNode: node
    | fsa childrenFsa previousFsa  |
    childrenFsa := node children collect: [ :child | self visit: child ].
    self assert: (childrenFsa allSatisfy: [ :child | child isDeterministic  ]).

    previousFsa := childrenFsa first.
    childrenFsa allButFirst do: [ :nextFsa | 
        fsa := self sequenceOf: previousFsa and: nextFsa.
        previousFsa := fsa.
    ].
    
    ^ fsa
!

visitStarNode: node
    | fsa  |

"	finalState := PEGFsaState new.
"	fsa := node child accept: self.
"	fsa addState: finalState.
"	
    fsa finalStates do: [ :state |
        fsa addTransitionFrom: state to: (fsa startState).
"		state hasPriority ifFalse: [ state priority: 0 ].
        state final: false.
"	].

"	fsa addTransitionFrom: fsa startState to: finalState priority: -1."	
    fsa finalState: fsa startState.

    ^ fsa
!

visitTokenNode: node
    ^ self visit: node child
!

visitTokenWhitespaceNode: node
    ^ self visit: node child
!

visitTrimmingTokenCharacterNode: node
    "I do not care about trimming (so far), it should be handled by TokenCodeGenerator"
    ^ self visit: node child
!

visitTrimmingTokenNode: node
    "I do not care about trimming (so far), it should be handled by TokenCodeGenerator"
    ^ self visit: node child
!

visitUnknownNode: node
    |  state fsa  |
    
    state := PEGFsaParserState new.
    state name: 'Unknown Parser'.
    state parser: node parser.
    
    fsa := PEGFsa new
        addState: state;
        
        startState: state;
        finalState: state;

        yourself.
        
    ^ fsa
! !

