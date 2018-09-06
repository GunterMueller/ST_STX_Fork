"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#WeakCollectionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!


!WeakCollectionTest methodsFor:'helpers'!

fetchValueAtKey:k from:aWeakValueDict

    ^ aWeakValueDict at:k

    "
     self run:#testWeakValueDictionary3
    "
!

fetchValueAtKey:k from:aWeakValueDict ifAbsent:exArg

    ^ aWeakValueDict at:k ifAbsent:exArg

    "
     self run:#testWeakValueDictionary3
    "
! !

!WeakCollectionTest methodsFor:'tests'!

testWeakIdentityDictionary1
    |w o1 o2|

    w := WeakIdentityDictionary new.
    o1 := Object new.
    o2 := Object new.

    w at:o1 put:'o1'.
    w at:o2 put:'o2'.

    ObjectMemory garbageCollect.
    ObjectMemory finalize.

    self assert:(w size == 2).

    o1 := nil.

    ObjectMemory garbageCollect.
    ObjectMemory finalize.

    self assert:(w size == 1).

    o2 := nil.

    ObjectMemory garbageCollect.
    ObjectMemory finalize.

    self assert:(w size == 0).

    "
     self run:#testWeakIdentityDictionary1
    "
!

testWeakIdentityDictionary2
    |w o1 o2|

    w := WeakIdentityDictionary new.
    o1 := '1' copy.
    o2 := '2' copy.

    w at:o1 put:'o1'.
    w at:o2 put:'o2'.

    ObjectMemory garbageCollect.
    ObjectMemory finalize.

    self assert:(w size == 2).

    o1 := nil.

    ObjectMemory garbageCollect.
    ObjectMemory finalize.

    self assert:(w size == 1).

    o2 := nil.

    ObjectMemory garbageCollect.
    ObjectMemory finalize.

    self assert:(w size == 0).

    "
     self run:#testWeakIdentityDictionary1
    "
!

testWeakValueDictionary1
    |ww n|

    n := 10000.

    ww := WeakValueDictionary new.

    1 "100" timesRepeat:[
	(1 to:n) do:[:idx |
	    |k v|

	    k := 'k_' , idx printString , '_12345678901234567890'.
	    v := 'v_' , idx printString , '_12345678901234567890'.
	    ww at:k put:v.
	    k := v := nil.
	].

	ObjectMemory garbageCollect.

	1 to:n do:[:idx |
	    |k v|

	    k := 'k_' , idx printString , '_12345678901234567890'.
	    v := ww at:k ifAbsent:nil.
	    self assert:v isNil.
	].
    ].

    "
     self run:#testWeakValueDictionary1
    "
!

testWeakValueDictionary2
    |ww k v v1|

    ww := WeakValueDictionary new.

    ObjectMemory scavenge.

    k := 'k_12345678901234567890' copy.
    v := 'v_12345678901234567890' copy.
    ww at:k put:v.

    self assert: ( (ww at:k) == v ).
    ObjectMemory scavenge.
    self assert: ( (ww at:k) == v ).

    v1 := v copy.
    v := nil.

    "/ now the original v is not referenced any longer and should be garbage collected
    self assert: ( (ww at:k) ~~ v1 ).
    self assert: ( (ww at:k) = v1 ).

    "/ give background finalizer a chance to run.
    2 timesRepeat:[ ObjectMemory scavenge. Delay waitForSeconds:0.5 ].

"/    self assert: ( ww size = 0 ).
    self assert: ( (ww at:k ifAbsent:nil) isNil ).


    "
     self run:#testWeakValueDictionary2
    "
!

testWeakValueDictionary3
    |ww k v v2|

    ww := WeakValueDictionary new.

    ObjectMemory scavenge.

    k := 'k_12345678901234567890' copy.
    v := 'v_12345678901234567890' copy.
    ww at:k put:v.

    v2 := self fetchValueAtKey:k from:ww.
    self assert: ( v2 == v ).
    v2 := nil.

    v := v copy.
    2 timesRepeat:[ ObjectMemory scavenge. Delay waitForSeconds:0.5 ].
    v2 := self fetchValueAtKey:k from:ww ifAbsent:nil.
    self assert: ( v2 isNil ).
    v2 := nil.


    "
     self run:#testWeakValueDictionary3
    "
! !

!WeakCollectionTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

