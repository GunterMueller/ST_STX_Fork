"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPCUnivarsalGuardTest
	instanceVariableNames:'parser result context node compiler id node2 id2 id1 node1 node3
		options'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Core-Universal'
!


!PPCUnivarsalGuardTest methodsFor:'as yet unclassified'!

assert: p parse: whatever
    ^ result := super assert: p parse: whatever.
!

context	
    ^ context := PPCProfilingContext new
!

setUp
    options := (PPCCompilationOptions new)
            profile:true;
            tokenize:false;
            yourself.
    compiler := PPCCompiler new.
    compiler context options:options

    "Modified: / 07-09-2015 / 10:22:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    | parserClass |

    parserClass := (Smalltalk at: #PPGeneratedParser ifAbsent: [nil]).
    parserClass notNil ifTrue:[ 
        parserClass removeFromSystem
    ].
! !

!PPCUnivarsalGuardTest methodsFor:'tests - guard'!

testChoiceGuard
    parser := compiler compile: ('foo' asParser trimmingToken / 'bar' asParser trimmingToken 
                    / $d asParser trimmingToken plus).
    
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.     
    self assert: (context invocations anySatisfy: [ :e | e beginsWith: 'token' ]).

    self assert: parser parse: 'bar'.
    self assert: result inputValue = 'bar'.     

    self assert: parser parse: ' foo'.
    self assert: result inputValue = 'foo'.     

    self assert: parser parse: '  d'.
    self assert: result first inputValue = 'd'.         

    self assert: parser fail: ''.
    self assert: (context invocations noneSatisfy: [ :e | e beginsWith: 'predicate' ]).
    self assert: (context invocations noneSatisfy: [ :e | e beginsWith: 'token' ]).

    self assert: parser fail: 'zorg'.           
    self assert: (context invocations noneSatisfy: [ :e | e beginsWith: 'token' ]).

    "Modified: / 07-09-2015 / 12:39:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testEmptyChoiceGuard
    parser := compiler compile: ('foo' asParser trimmingToken / 'bar' asParser trimmingToken 
                    / $d asParser trimmingToken star).
    
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.     

    self assert: parser parse: 'bar'.
    self assert: result inputValue = 'bar'.     

    self assert: parser parse: ' foo'.
    self assert: result inputValue = 'foo'.     

    self assert: parser parse: '  d'.
    self assert: result first inputValue = 'd'.         

    self assert: parser parse: ''.

    self assert: parser parse: 'zorg' end: 0.

    "Modified: / 07-09-2015 / 12:39:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testGuardSmalltlakToken
    parser := compiler compile: (#letter asParser , #word asParser star) smalltalkToken.

    self assert: parser parse: 'bar'.
    self assert: (context invocations anySatisfy: [ :e | e beginsWith: 'seq' ]).
    
    self assert: parser fail: '123'.
    self assert: (context invocations noneSatisfy: [ :e | e beginsWith: 'seq' ]).

    "Modified (format): / 07-09-2015 / 12:39:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSequenceGuard
    parser := compiler compile: ((#any asParser , #any asParser) wrapped , (#any asParser , #any asParser)).

    self assert: parser parse: 'fooo' to: #(#($f $o) #($o $o)).         
    self assert: parser parse: 'fo oo' to: #(#($f $o) #($  $o)) end: 4.         
    self assert: parser fail: 'fo'.

    "Modified: / 07-09-2015 / 12:39:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTrimmerGuard
    parser := compiler compile: ($a asParser trim , $b asParser).
    
    self assert: parser parse: 'ab'.
    self assert: parser parse: ' ab'.
! !

!PPCUnivarsalGuardTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

