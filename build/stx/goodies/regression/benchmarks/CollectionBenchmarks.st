"{ Package: 'stx:goodies/regression/benchmarks' }"

Object subclass:#CollectionBenchmarks
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'benchmarks-Collections'
!


!CollectionBenchmarks class methodsFor:'standalone run'!

main
    "to run from the commandline, type
	stx -I --load CollectionBenchmarks.st --run CollectionBenchmarks
    "
    self collectionTimings
! !

!CollectionBenchmarks class methodsFor:'sorted collections'!

collectionTimings
    |N randomNumbers|

    N := 100000.
    randomNumbers := (1 to:N) collect:[:i | Random nextInteger].
    ObjectMemory garbageCollect.

    #(SortedCollection AATree BinaryTree) do:[:className |
	|class doBench coll t seq|

	class := Smalltalk classNamed:className.

	doBench := [:class |
		|coll t|

		t := Time millisecondsToRun:[
		    coll := class new.
		    randomNumbers do:[:each | coll add:each]
		].
		Transcript show:'Time to insert random '; show:N; show:' individually into ',class name,': '; show:t; showCR:'ms'.
		coll
	    ].

	ObjectMemory garbageCollect.
	doBench value:class.
	ObjectMemory garbageCollect.

	doBench := [:class |
		|coll t|

		t := Time millisecondsToRun:[
		    coll := class new.
		    coll addAll:randomNumbers
		].
		Transcript show:'Time to insert random '; show:N; show:' en-bloque into ',class name,': '; show:t; showCR:'ms'.
		coll
	    ].

	ObjectMemory garbageCollect.
	doBench value:class.
	ObjectMemory garbageCollect.

	doBench := [:class |
		|coll t|

		t := Time millisecondsToRun:[
		    coll := class new.
		    (1 to:N) do:[:each | coll add:each].
		].
		Transcript show:'Time to insert in order '; show:N; show:' individually into ',class name,': '; show:t; showCR:'ms'.
		coll
	    ].

	ObjectMemory garbageCollect.
	doBench value:class.
	ObjectMemory garbageCollect.

	doBench := [:class |
		|coll t|

		t := Time millisecondsToRun:[
		    coll := class new.
		    coll addAll:(1 to:N).
		].
		Transcript show:'Time to insert in order '; show:N; show:' en-bloque into ',class name,': '; show:t; showCR:'ms'.
		coll
	    ].

	ObjectMemory garbageCollect.
	doBench value:class.
	ObjectMemory garbageCollect.

	doBench := [:class |
		|coll t|

		t := Time millisecondsToRun:[
		    coll := class new.
		    (N downTo:1) do:[:each | coll add:each].
		].
		Transcript show:'Time to insert in reverse order '; show:N; show:' individually into ',class name,': '; show:t; showCR:'ms'.
		coll
	    ].

	ObjectMemory garbageCollect.
	doBench value:class.
	ObjectMemory garbageCollect.

	doBench := [:class |
		|coll t|

		t := Time millisecondsToRun:[
		    coll := class new.
		    coll addAll:(N downTo:1).
		].
		Transcript show:'Time to insert in reverse order '; show:N; show:' en-bloque into ',class name,': '; show:t; showCR:'ms'.
		coll
	    ].

	ObjectMemory garbageCollect.
	doBench value:class.
	ObjectMemory garbageCollect.




	coll := class new.
	coll addAll:randomNumbers.

	t := Time millisecondsToRun:[
	    coll removeAll:randomNumbers.
	].
	Transcript show:'Time to remove in random order '; show:N; show:' from ',class name,': '; show:t; showCR:'ms'.
	self assert:(coll isEmpty).
	ObjectMemory garbageCollect.


	coll := class new.
	coll addAll:randomNumbers.
	seq := randomNumbers copy sort.

	t := Time millisecondsToRun:[
	    coll removeAll:seq.
	].
	Transcript show:'Time to remove in order '; show:N; show:' from ',class name,': '; show:t; showCR:'ms'.
	self assert:(coll isEmpty).
	ObjectMemory garbageCollect.

	coll := class new.
	coll addAll:randomNumbers.
	seq := randomNumbers copy sort reverse.

	t := Time millisecondsToRun:[
	    coll removeAll:seq.
	].
	Transcript show:'Time to remove in reverse order '; show:N; show:' from ',class name,': '; show:t; showCR:'ms'.
	self assert:(coll isEmpty).
	ObjectMemory garbageCollect.

	Transcript cr.
    ].
!

documentation
"
    Time to insert random 100000 individually into SortedCollection: 6037ms
    Time to insert random 100000 en-bloque into SortedCollection: 172ms
    Time to insert in order 100000 individually into SortedCollection: 31ms
    Time to insert in order 100000 en-bloque into SortedCollection: 125ms
    Time to insert in reverse order 100000 individually into SortedCollection: 93ms
    Time to insert in reverse order 100000 en-bloque into SortedCollection: 125ms
    Time to remove in random order 100000 from SortedCollection: 6380ms
    Time to remove in order 100000 from SortedCollection: 109ms
    Time to remove in reverse order 100000 from SortedCollection: 125ms

    Time to insert random 100000 individually into AATree: 281ms
    Time to insert random 100000 en-bloque into AATree: 265ms
    Time to insert in order 100000 individually into AATree: 281ms
    Time to insert in order 100000 en-bloque into AATree: 328ms
    Time to insert in reverse order 100000 individually into AATree: 203ms
    Time to insert in reverse order 100000 en-bloque into AATree: 218ms
    Time to remove in random order 100000 from AATree: 452ms
    Time to remove in order 100000 from AATree: 312ms
    Time to remove in reverse order 100000 from AATree: 499ms

    Time to insert random 100000 individually into BinaryTree: 156ms
    Time to insert random 100000 en-bloque into BinaryTree: 156ms
    Time to insert in order 100000 individually into BinaryTree: 195921ms
    Time to insert in order 100000 en-bloque into BinaryTree: 205266ms
    Time to insert in reverse order 100000 individually into BinaryTree: 202271ms
    Time to insert in reverse order 100000 en-bloque into BinaryTree: 197684ms
    Time to remove in random order 100000 from BinaryTree: 234ms
    Time to remove in order 100000 from BinaryTree: 78ms
    Time to remove in reverse order 100000 from BinaryTree: 78ms

  on a 2010 powerbook (2.1Ghz 86_64)
    Time to insert random 100000 individually into SortedCollection: 1390ms
    Time to insert random 100000 en-bloque into SortedCollection: 50ms
    Time to insert in order 100000 individually into SortedCollection: 20ms
    Time to insert in order 100000 en-bloque into SortedCollection: 20ms
    Time to insert in reverse order 100000 individually into SortedCollection: 40ms
    Time to insert in reverse order 100000 en-bloque into SortedCollection: 40ms
    Time to remove in random order 100000 from SortedCollection: 1370ms
    Time to remove in order 100000 from SortedCollection: 40ms
    Time to remove in reverse order 100000 from SortedCollection: 40ms

    Time to insert random 100000 individually into AATree: 170ms
    Time to insert random 100000 en-bloque into AATree: 170ms
    Time to insert in order 100000 individually into AATree: 170ms
    Time to insert in order 100000 en-bloque into AATree: 150ms
    Time to insert in reverse order 100000 individually into AATree: 130ms
    Time to insert in reverse order 100000 en-bloque into AATree: 120ms
    Time to remove in random order 100000 from AATree: 310ms
    Time to remove in order 100000 from AATree: 200ms
    Time to remove in reverse order 100000 from AATree: 260ms

    Time to insert random 100000 individually into BinaryTree: 110ms
    Time to insert random 100000 en-bloque into BinaryTree: 100ms
    Time to insert in order 100000 individually into BinaryTree: 77260ms
    Time to insert in order 100000 en-bloque into BinaryTree: 78420ms
    Time to insert in reverse order 100000 individually into BinaryTree: 78830ms
    Time to insert in reverse order 100000 en-bloque into BinaryTree: 79020ms
    Time to remove in random order 100000 from BinaryTree: 160ms
    Time to remove in order 100000 from BinaryTree: 50ms
    Time to remove in reverse order 100000 from BinaryTree: 40ms
"
!

test_Btree
    |coll sc randomNumbers|

    randomNumbers := (1 to:1000) collect:[:i |Random nextInteger].

    sc := SortedCollection new.
    sc addAll:randomNumbers.

    coll := BinaryTree new.
    coll addAll:randomNumbers.

    randomNumbers do:[:each |
"/        Transcript showCR:'-----------'.
"/        Transcript showCR:(coll instVarNamed:'treeRoot').
"/        Transcript showCR:each.
	coll remove:each.
	sc remove:each.
	self assert:(sc asOrderedCollection = coll asOrderedCollection).
    ].
! !

!CollectionBenchmarks class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
