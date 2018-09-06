"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PEGFsaStateTest
	instanceVariableNames:'state t1 t2 t3 t4 anotherState'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-FSA'
!


!PEGFsaStateTest methodsFor:'as yet unclassified'!

setUp
    state := PEGFsaState new name: #state; retval: #state; yourself.
    anotherState := PEGFsaState new name: #anotherState; retval: #anotherState; yourself.

    t1 := PEGFsaCharacterTransition new.
    t2 := PEGFsaCharacterTransition new.
    t3 := PEGFsaCharacterTransition new.
    t4 := PEGFsaCharacterTransition new.
    
!

testCopy
    state addTransition: t1.
    anotherState := state copy.
    
    self assert: (state = anotherState).
    self assert: (state == anotherState) not.
    
    state retval: #foo.
    self assert: (state = anotherState) not.

    anotherState retval: #foo.
    self assert: (state = anotherState).
    
    state addTransition: t2.
    self assert: (state = anotherState) not.
    
    anotherState addTransition: t2.
    self assert: (state = anotherState).
    
!

testCopy2
    state addTransition: t1.
    anotherState := state copy.
    
    self assert: (state = anotherState).
    self assert: (state == anotherState) not.
    
    state addTransition: t2.
    self assert: (state = anotherState) not.
    
    anotherState addTransition: t2 copy.
    self assert: (state = anotherState).
    
!

testCopy3
    state addTransition: t1.
    anotherState := state copy.
    
    self assert: (state = anotherState).
    self assert: (state == anotherState) not.
    
    t1 addCharacter: $x.
    self assert: (state = anotherState) not.
    
    anotherState transitions anyOne addCharacter: $x.	
    self assert: (state = anotherState).
    
!

testCopy4
    anotherState := state copy.
    
    self assert: (state = anotherState).
    self assert: (state == anotherState) not.
    
    state priority: -1.
    self assert: (state = anotherState) not.

    anotherState priority: -1.
    self assert: (state = anotherState).
    
    anotherState final: true.
    self assert: (state = anotherState) not.

    state final: true.	
    self assert: (state = anotherState).
    
!

testCopy5
    
    
    state retval: #foo.
    state failure: true.
    state final: true.
    anotherState := state copy.

    self assert: (state = anotherState).
    self assert: (state == anotherState) not.

    anotherState retval: #bar.
    self assert: state retval == #foo.
    self assert: state isFsaFailure.
    self assert: anotherState retval == #bar.
    self assert: anotherState isFsaFailure.
    
!

testTransitionPairs
    state addTransition: t1.
    state addTransition: t2.
    state addTransition: t3.
    
    self assert: state transitions size = 3.
    self assert: state transitionPairs size = 3.
    self assert: (state transitionPairs includes: (PEGFsaPair with: t1 with: t2)).
    self assert: (state transitionPairs includes: (PEGFsaPair with: t1 with: t3)).
    self assert: (state transitionPairs includes: (PEGFsaPair with: t2 with: t3)).		
! !

!PEGFsaStateTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

