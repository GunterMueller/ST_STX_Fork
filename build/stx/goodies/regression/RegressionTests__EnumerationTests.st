"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#EnumerationTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!


!EnumerationTests class methodsFor:'tests'!

testArrayKeysAndValuesDo
    "test GC while enumerating an array"

    |a|

    a := (1 to:100) asArray.

    10 timesRepeat:[
	a keysAndValuesDo:[:index :val |
	    ObjectMemory scavenge.
	    index printString.
	    ObjectMemory scavenge.
	    val printString.
	]
    ]

    "
     self testArrayKeysAndValuesDo
    "
! !

!EnumerationTests methodsFor:'tests'!

testArrayKeysAndValuesDo
    "test GC while enumerating an array"

    |a|

    a := (1 to:100) asArray.

    10 timesRepeat:[
	a keysAndValuesDo:[:index :val |
	    ObjectMemory scavenge.
	    index printString.
	    ObjectMemory scavenge.
	    val printString.
	]
    ]

    "
     self new testArrayKeysAndValuesDo
    "

    "Modified (comment): / 10-10-2011 / 13:48:48 / cg"
!

testWeakArrayKeysAndValuesDo
    "test GC while enumerating an array"

    |a w|

    a := WeakArray new:100.
    w := WeakArray new:100.
    1 to:a size do:[:i |
	|o|

	o := Object new.
	a at:i put:o.
	w at:i put:o.
    ].

    w keysAndValuesDo:[:index :val |
	self assert:(val class == Object).
    ].

    w keysAndValuesDo:[:index :val |
	index == 5 ifTrue:[
	    a at:7 put:nil.
	    ObjectMemory scavenge
	].
	index == 7 ifTrue:[
	    self assert:(val class == SmallInteger).
	]
    ]

    "
     self new testWeakArrayKeysAndValuesDo
    "

    "Created: / 10-10-2011 / 12:51:43 / cg"
! !

!EnumerationTests class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

