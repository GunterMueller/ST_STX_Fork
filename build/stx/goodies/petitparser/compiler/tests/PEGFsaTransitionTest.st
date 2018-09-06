"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PEGFsaTransitionTest
	instanceVariableNames:'t1 t2 result e1 e2'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-FSA'
!

!PEGFsaTransitionTest methodsFor:'as yet unclassified'!

setUp
    t1 := PEGFsaCharacterTransition new.
    t2 := PEGFsaCharacterTransition new.
    
    e1 := PEGFsaEpsilonTransition new.
    e2 := PEGFsaEpsilonTransition new.
! !

!PEGFsaTransitionTest methodsFor:'character'!

testCompare
    t1 addCharacter: $a.
    t1 addCharacter: $b.
    t2 addCharacter: $a.
    t2 addCharacter: $b.
    
    self assert: t1 = t2.
!

testComplement
    t1 addCharacter: $a.
    t1 addCharacter: $b.
    t2 addCharacter: $b.
    t2 addCharacter: $c.
    
    result := t1 complement: t2.
    
    self assert: (result at: $a codePoint).
    self assert: (result at: $b codePoint) not.
    self assert: (result at: $c codePoint) not.
!

testComplement2
    t1 addCharacter: $a.
    t1 addCharacter: $b.
    t2 addCharacter: $b.
    t2 addCharacter: $c.
    
    result := t2 complement: t1.
    
    self assert: (result at: $a codePoint) not.
    self assert: (result at: $b codePoint) not.
    self assert: (result at: $c codePoint).
!

testCopy
    t1 addCharacter: $a.
    t1 addCharacter: $b.
    
    t2 := t1 copy.
    
    
    self assert: t1 = t2.
    self assert: (t1 == t2) not.
    
    t2 destination: #foo.
    self assert: (t1 = t2) not.
        
    t1 destination: #foo.
    self assert: (t1 = t2).

    t1 addCharacter: $c.
    self assert: (t1 = t2) not.
    
    t2 addCharacter: $c.
    t1 priority: -1.
    self assert: (t1 = t2) not.	
    
    t2 priority: -1.
    self assert: (t1 = t2).
!

testDisjunction
    t1 addCharacter: $a.
    t1 addCharacter: $c.
    t2 addCharacter: $b.
    t2 addCharacter: $c.
    
    result := t1 disjunction: t2.
    
    self assert: (result at: $a codePoint).
    self assert: (result at: $b codePoint).
    self assert: (result at: $c codePoint) not.
!

testEpsilonIntersection
    result := e1 intersection: e2.
    
    self assert: (result isEpsilon)
!

testIntersection
    t1 addCharacter: $a.
    t1 addCharacter: $b.
    t2 addCharacter: $b.
    t2 addCharacter: $c.
    
    result := t1 intersection: t2.
    
    self assert: (result at: $b codePoint).
    self assert: (result at: $a codePoint) not.
    self assert: (result at: $c codePoint) not.
!

testIntersection2
    t1 addCharacter: $a.
    t2 addCharacter: $b.
    
    result := t1 intersection: t2.
    
    self assert: (result allSatisfy: [:e | e not ]).
    
!

testUnion
    t1 addCharacter: $a.
    t1 addCharacter: $b.
    t2 addCharacter: $b.
    t2 addCharacter: $c.
    
    result := t1 union: t2.
    
    self assert: (result at: $b codePoint).
    self assert: (result at: $a codePoint).
    self assert: (result at: $c codePoint).
    self assert: (result at: $d codePoint) not.
! !

!PEGFsaTransitionTest methodsFor:'tests - epsilon'!

testCompareEpsilon

    self assert: e1 = e2.
    
    e1 destination: #a.
    e2 destination: #b.
    
    self assert: (e1 = e2) not.
    
!

testCopyEpsilon
    
    e2 := e1 copy.
    
    
    self assert: e1 = e2.
    self assert: (e1 == e2) not.
    
    e2 destination: #foo.
    self assert: (e1 = e2) not.
        
    e1 destination: #foo.
    self assert: (e1 = e2).

    e1 priority: -1.
    self assert: (e1 = e2) not.	
    
    e2 priority: -1.
    self assert: (e1 = e2).
! !

