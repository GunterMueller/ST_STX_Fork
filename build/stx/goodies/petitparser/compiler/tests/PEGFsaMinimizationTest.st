"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PEGFsaMinimizationTest
	instanceVariableNames:'fsa a b c d e state t1 anotherState t2 t3 t4'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-FSA'
!

!PEGFsaMinimizationTest methodsFor:'as yet unclassified'!

assert: s1 equals: s2
    self assert: (self minimizator state: s1 equals: s2).
!

assert: s1 notEquals: s2
    self assert: (self minimizator state: s1 equals: s2) not.
!

minimizator
    ^ PEGFsaMinimizator new
!

setUp
    a := PEGFsaState new name: #a; retval: #token; yourself.
    b := PEGFsaState new name: #b; retval: #token; yourself.
    c := PEGFsaState new name: #c; retval: #token; yourself.
    d := PEGFsaState new name: #d; retval: #token; yourself.
    e := PEGFsaState new name: #e; retval: #token; yourself.

    state := PEGFsaState new name: #state; retval: #state; yourself.
    anotherState := PEGFsaState new name: #anotherState; retval: #anotherState; yourself.

    t1 := PEGFsaCharacterTransition new.
    t2 := PEGFsaCharacterTransition new.
    t3 := PEGFsaCharacterTransition new.
    t4 := PEGFsaCharacterTransition new.

    fsa := PEGFsa new.
! !

!PEGFsaMinimizationTest methodsFor:'tests'!

testMinimize
    | merged |
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa startState: a.
    fsa finalState: d.
    
    fsa addTransitionFrom: a to: b on: $b.
    fsa addTransitionFrom: a to: c on: $c.

    fsa addTransitionFrom: b to: d on: $a.
    fsa addTransitionFrom: c to: d on: $a.
    b retval: nil.
    c retval: nil.
    
    fsa minimize.
        
    self assert: fsa states size = 3.
    self assert: a transitions size = 1.	
    
    merged := a transitions anyOne destination.
    self assert: merged transitions size = 1.
    self assert: merged transitions anyOne destination = d.
    self assert: (merged transitions anyOne accepts: $a).
!

testMinimze2
    |  merged |
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa addState: e.
    
    fsa startState: a.
    fsa finalState: e.

    "states c and d are equivalent"
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $c priority: -1.	
    fsa addTransitionFrom: b to: d on: $d priority: -2.	
    fsa addTransitionFrom: c to: e on: $e priority: -3.	
    fsa addTransitionFrom: d to: e on: $e priority: -4.	
    
    c retval: nil.
    d retval: nil.
    
    fsa minimize.
    
    self assert: fsa isDeterministic.	
    self assert: fsa states size = 4.
    
    self assert: b transitions size = 1.	
    
    merged := b destination.
    self assert: merged transitions size = 1.
    self assert: merged destination isFinal.
!

testMinimze3
    |  merged |
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    
    fsa startState: a.
    fsa finalState: b.
    fsa finalState: c.

    "states c and d are equivalent"
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: c on: $a.

    fsa addTransitionFrom: b to: b on: $b.
    fsa addTransitionFrom: c to: c on: $b.
    
    
    fsa minimize.
    
    self assert: fsa isDeterministic.	
    self assert: fsa states size = 2.
    
    merged := a destination.
    self assert: merged transitions size = 1.
    self assert: merged destination isFinal.
!

testMinimze4
    | merged |

    ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[  
        self skipIf: true description: 'JK, remove this once fixed'.
    ].   


    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa addState: e.
    
    fsa startState: a.
    fsa finalState: c.
    fsa finalState: e.

    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: d on: $a.

    fsa addTransitionFrom: b to: c on: $b.
    fsa addTransitionFrom: c to: b on: $b.
    
    fsa addTransitionFrom: d to: e on: $b.
    fsa addTransitionFrom: e to: d on: $b.
    
    fsa minimize.
    
    self assert: fsa isDeterministic.   
    self assert: fsa states size = 3.
    
    merged := a destination.
    self assert: merged transitions size = 1.
    self assert: merged destination isFinal.

    "Modified: / 08-09-2015 / 01:52:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testStateEquals
    state addTransition: t1.
    anotherState addTransition: t2.

    state retval: #baz.
    anotherState retval: #baz.
    
    t1 destination: #foo.
    t2 destination: #bar.
        
    self assert: state notEquals: anotherState
!

testStateEquals2
    state addTransition: t1.
    anotherState addTransition: t2.

    state retval: #baz.
    anotherState retval: #baz.
    
    t1 destination: #foo.
    t2 destination: #foo.
        
    self assert: state equals: anotherState.
!

testStateEquals3
    state addTransition: t1.
    anotherState addTransition: t2.

    state retval: #bar.
    anotherState retval: #baz.
    
    t1 destination: #foo.
    t2 destination: #foo.
        
    self assert: state notEquals: anotherState
!

testStateEquals4
    state addTransition: t1.
    anotherState addTransition: t2.

    state retval: #bar.
    anotherState retval: #bar.
    
    state priority: 0.
    anotherState priority: -1.
    
    t1 destination: #foo.
    t2 destination: #foo.
        
    self assert: state notEquals: anotherState
!

testStateEquals5
    state addTransition: t1.
    state addTransition: t2.
    anotherState addTransition: t2.
    anotherState addTransition: t3.

    state retval: #bar.
    anotherState retval: #bar.
    
    state priority: -1.
    anotherState priority: -1.
    
    t1 destination: #foobar.
    t2 destination: #foo.
    t3 destination: #foobar.
        
    self assert: state equals: anotherState
!

testStateEquals6
    state addTransition: t1.
    state addTransition: t2.
    anotherState addTransition: t1.

    state retval: #bar.
    anotherState retval: #bar.
    
    state priority: -1.
    anotherState priority: -1.
    
    t1 destination: #foo.
    t2 destination: #bar.
        
    self assert: state notEquals: anotherState
! !

