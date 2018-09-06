"
 This class is not covered by or part of the ST/X licence.


 COPYRIGHT.
 The above file is a Manchester Goodie protected by copyright.
 These conditions are imposed on the whole Goodie, and on any significant
 part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).
 Further information on the copyright conditions may be obtained by
 sending electronic mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: copyright
 or by writing to The Smalltalk Goodies Library Manager, Dept of
 Computer Science, The University, Manchester M13 9PL, UK

 (C) Copyright 1993 University of Manchester
 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help 
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

SequenceableCollection subclass:#RunArray
	instanceVariableNames:'contentsArray'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

RunArray comment:'This implements an ordered collection which uses runs to minimise the amount
 of data that it holds. Basically it should be used if you know that an ordered
 collections is giong to contain a lot of runs of eactly the same data. Implemented
 to allow simultation playback, since the ordered collctions which that generates
 are so big that the complier falls over, though most of it is extremely repetetive.
 This should be totally abstracted. The user should not be a ble to see the difference
 between an ordered collection and a ComrpessedOrderedCollection.  This has a
 lot in common with RunArray, and the two should probably share implementation.
 but I could not do some of the things I wanted with the RunArray code, so this
 is all done on its own.
	Some of this could be made faster by adding a cache of the start and finish
 indices of each run, but since I envisage that most additions etc. will be to
 and from the end those are not included. In addition I have implemented the
 bare essentials of this for what I need it for - i.e. add to the end and take
 off the beginning.'
!

!RunArray class methodsFor:'documentation'!

copyright
"
 This class is not covered by or part of the ST/X licence.


 COPYRIGHT.
 The above file is a Manchester Goodie protected by copyright.
 These conditions are imposed on the whole Goodie, and on any significant
 part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).
 Further information on the copyright conditions may be obtained by
 sending electronic mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: copyright
 or by writing to The Smalltalk Goodies Library Manager, Dept of
 Computer Science, The University, Manchester M13 9PL, UK

 (C) Copyright 1993 University of Manchester
 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help 
"


!

documentation
"
    This implements an array which uses runs to minimise the amount
    of data that it physically holds. 
    A run consists of a count/object pair, which (when the collection
    is accessed), is treated as if the object was contained count-times 
    in the runArray.

    Basically it can be used if you know that your collection is 
    going to contain a lot of runs of exactly the same data. 

    RunArrays are used by the Text class to keep character attributes
    (which we expect to remain constant for longer character ranges).

    [notice:]
        there is ONLY a space saving if there are really runs 
        (i.e. multiple elements which compare same).
        The break-even is when runs have an average size of 2 elements,
        if average runs are shorter, other collections (i.e. Array or
        OrderedCollection) are more compact.

        Also note that indexed access (i.e. #at: / #at:put:) may be
        very inefficient (as opposed to enumeration, which is reasonably
        fast).
        The reason is that for indexed access the runs have to be walked.
        When storing into a runArray, runs may have to be splitted or merged,
        depending on where the store is done (within a run).
        This may lead to a resize operation.
        You have been warned.

    [instance variables:]
        contentsArray    <Array>         contains the runs, consisting of
                                         alternating length/value entries.

    [implementation note:]
        structure-wise, it would have been more intuitive, to keep
        instances of Run objects (as done in CompressedOrderedCollection)
        instead of alternating length/values in the `runs' collection.
        However, doing this means that lots of additional memory is required,
        since for every run, another object (consisting of 12bytes header)
        would be needed.
        Here, we choose the more space efficient way - after all, space saving
        is the only reason this class was built for.

    [author:]
        Claus Gittinger

    [see also:]
        Array OrderedCollection CompressedOrderedCollection
"
!

examples
"
  this eats up a lot of memory ...
  ... but its relatively fast:
                                                                        [exBegin]
    |coll|

    coll := OrderedCollection new.
    Transcript showCR:(    
        Time millisecondsToRun:[
            100000 timesRepeat:[coll add:'hello'].
            100000 timesRepeat:[coll add:'world'].
        ]
    ).
    coll inspect.
                                                                        [exEnd]


  this is very space efficient ...
  ... (and even slightly faster):
                                                                        [exBegin]
    |coll|

    coll := RunArray new.
    Transcript showCR:(    
        Time millisecondsToRun:[
            100000 timesRepeat:[coll add:'hello'].
            100000 timesRepeat:[coll add:'world'].
        ]
    ).
    coll inspect.
                                                                        [exEnd]


  this is very space efficient ...
  ... AND much faster:
                                                                        [exBegin]
    |coll|

    coll := RunArray new.
    Transcript showCR:(    
        Time millisecondsToRun:[
            coll add:'hello' withOccurrences:100000.
            coll add:'world' withOccurrences:100000.
        ]
    ).
    coll inspect.
                                                                        [exEnd]


  single-element runs;
  this is very space INEFFICIENT (requires twice as much) ...
  ... and MUCH slower:
                                                                        [exBegin]
    |coll|

    coll := RunArray new.
    Transcript showCR:(    
        Time millisecondsToRun:[
            1 to:1000 do:[:i | coll add:i].
        ]
    ).
                                                                        [exEnd]
  compare to:
                                                                        [exBegin]
    |coll|

    coll := OrderedCollection new.
    Transcript showCR:(    
        Time millisecondsToRun:[
            1 to:1000 do:[:i | coll add:i].
        ]
    ).
                                                                        [exEnd]

"
! !

!RunArray class methodsFor:'instance creation'!

from:aSequencableCollection
    "return a new runArray, containing the elements from aSequencableCollection"

    ^ self basicNew setElementsFrom:aSequencableCollection

    "
     RunArray from:#(1 2 3 3 3 4 5 5 6 6 6 6 6 6)
    "

    "Created: / 7.4.1998 / 09:12:45 / cg"
    "Modified: / 7.4.1998 / 09:15:53 / cg"
!

new:count
    "return a new runArray, containing count elements - all nil"

    ^ self basicNew setElement:nil occurrences:count

    "Modified: / 30.10.1997 / 14:36:05 / cg"
!

new:count withAll:anObject
    "create a new runArray with count elements, all being anObject"

    ^ self basicNew setElement:anObject occurrences:count

    "
     RunArray new:100 withAll:#hello
    "

    "Modified: / 30.10.1997 / 14:36:38 / cg"
!

runs:runs values:values
    "return a new runArray, containing elements defined by pairs from
     runs and values"

    ^ self basicNew setRuns:runs setValues:values

    "
     RunArray runs:#(2 3 4) values:#($a $b $c)
    "
! !

!RunArray methodsFor:'Compatibility-ST80'!

runs
    contentsArray isNil ifTrue:[ ^ #() ].
    ^ contentsArray pairWiseCollect:[:n :v | n ]

    "
     |c|

     c := RunArray new.
     c add:1 withOccurrences:1000.
     c add:2 withOccurrences:1000.
     c runs.
    "
!

values
    contentsArray isNil ifTrue:[ ^ #() ].
    ^ contentsArray pairWiseCollect:[:n :v | v ]

    "
     |c|

     c := RunArray new.
     c add:1 withOccurrences:1000.
     c add:2 withOccurrences:1000.
     c values.    
    "
! !

!RunArray methodsFor:'accessing'!

at:index 
    "Answer the element at index. 
     at: is used by a knowledgeable client to access an existing element 
     This is a pretty dumb thing to do to a runArray and it is 
     not at all efficient (think of that as a discouragement)."

    |position "{ Class: SmallInteger }"
     nRuns    "{ Class: SmallInteger }"|

    (index > 0) ifTrue:[
        position := 1.
        nRuns := contentsArray size.
        1 to:nRuns by:2 do:[:runIndex |
            |runLen|

            runLen := contentsArray at:runIndex.
            index >= position ifTrue:[
                index < (position + runLen) ifTrue:[
                    ^ contentsArray at:(runIndex + 1)
                ].
            ].
            position := position + runLen
        ]
    ].
    ^ self subscriptBoundsError:index

    "
     |c|

     c := RunArray new.
     c add:1; add:1; add:1; add:2; add:2; add:3; add:3; add:4; add:5.
     c at:1. 
     c at:2. 
     c at:3. 
     c at:4.  
     c at:5. 
     c at:6. 
     c at:7. 
     c at:8.  
     c at:9.  
     c at:10.  
    "

    "Modified: 18.5.1996 / 14:54:52 / cg"
!

at:index put:anObject 
    "Put anObject at element index anInteger.      
     at:put: can not be used to append, front or back, to a runArray.      
     It is used by a knowledgeable client to replace an element. 
     This is a pretty dumb thing to do to a runArray and it is 
     very inefficient, since we have to check if runs are to be merged or
     splitted."

    |runSz runIndex runOffset len l1 l2 prevIdx nextIdx
     val newRuns prevLen prevVal nextLen nextVal idx|

    runSz := contentsArray size.

    runIndex := nil.
    (index > 0) ifTrue:[
        runOffset := 1.
        idx := 1.
        [runIndex isNil and:[idx < runSz]] whileTrue:[
            len := contentsArray at:idx.
            nextIdx := runOffset + len.
            index >= runOffset ifTrue:[
                index < nextIdx ifTrue:[
                    runIndex := idx.
                    nextIdx := runOffset. "/ don't advance
                ].
            ].
            runOffset := nextIdx.
            idx := idx + 2.
        ]
    ].
    runIndex isNil ifTrue:[
        ^ self subscriptBoundsError:index
    ].

    val := contentsArray at:(runIndex + 1).

    "/ easiest: value there is the same ...

    val = anObject ifTrue:[
        ^ anObject
    ].

    "/ if the length is 1, this is an island ...
    "/ ... which is either easy, or requires a merge.

    len := contentsArray at:runIndex.
    len = 1 ifTrue:[
        "/ check if it can be merged into the next or previous run

        runIndex > 1 ifTrue:[
            prevIdx := runIndex - 2.
            prevVal := contentsArray at:(prevIdx + 1).
            prevVal = anObject ifTrue:[
                "/ can merge it into previous

                prevLen := contentsArray at:prevIdx.

                "/ check if merge into next is also possible (filling an island)
                
                runIndex < (runSz - 1) ifTrue:[
                    nextIdx := runIndex + 2.
                    nextVal := contentsArray at:(nextIdx + 1).
                    nextVal = anObject ifTrue:[
                        "/ can merge with both.
                        
                        nextLen := contentsArray at:nextIdx.

                        contentsArray at:prevIdx put:prevLen+nextLen+1.
                        runSz := (runSz - 4).
                        newRuns := Array new:runSz.
                        newRuns replaceFrom:1 to:(prevIdx + 1) with:contentsArray startingAt:1.
                        newRuns replaceFrom:runIndex to:runSz with:contentsArray startingAt:nextIdx+2.
                        contentsArray := newRuns.
                        ^ anObject
                    ]
                ].

                contentsArray at:prevIdx put:prevLen+1.

                runSz := (runSz - 2).
                newRuns := Array new:runSz.
                newRuns replaceFrom:1 to:(runIndex - 1) with:contentsArray startingAt:1.
                newRuns replaceFrom:runIndex to:runSz with:contentsArray startingAt:runIndex+2.
                contentsArray := newRuns.

                ^ anObject
            ].
        ].

        "/ check if merge into next is possible

        runIndex < (runSz-1) ifTrue:[
            nextIdx := runIndex + 2.
            nextVal := contentsArray at:nextIdx+1.
            nextVal = anObject ifTrue:[
                nextLen := contentsArray at:nextIdx.
                contentsArray at:nextIdx put:nextLen + 1.

                runSz := (runSz - 2).
                newRuns := Array new:runSz.
                newRuns replaceFrom:1 to:(runIndex - 1) with:contentsArray startingAt:1.
                newRuns replaceFrom:runIndex to:runSz with:contentsArray startingAt:nextIdx.
                contentsArray := newRuns.
                ^ anObject
            ].
        ].

        "/ no merge; island remains

        contentsArray at:(runIndex+1) put:anObject.
        ^ anObject
    ].

    runOffset == index ifTrue:[
        "/ at the beginning of that run ...

        "/ check if its better added to the previous run ...

        runIndex > 1 ifTrue:[
            prevIdx := runIndex - 2.
            prevVal := contentsArray at:prevIdx+1.
            prevVal = anObject ifTrue:[
                prevLen := contentsArray at:prevIdx.
                contentsArray at:prevIdx put:prevLen + 1.
                contentsArray at:runIndex put:len - 1.
                ^ anObject.
            ].
        ].

        "/ must cut off 1 & insert a new run before ..

        contentsArray at:runIndex put:len - 1.

        runSz := (runSz + 2).
        newRuns := Array new:runSz.
        newRuns replaceFrom:1 to:(runIndex - 1) with:contentsArray startingAt:1.
        newRuns replaceFrom:runIndex+2 to:runSz with:contentsArray startingAt:runIndex.
        contentsArray := newRuns.

        contentsArray at:runIndex   put:1.
        contentsArray at:runIndex+1 put:anObject.
        ^ anObject
    ].

    (runOffset + len - 1) == index ifTrue:[
        "/ at the end ...

        "/ check if its better added to the next run ...

        runIndex < (runSz-1) ifTrue:[
            nextIdx := runIndex + 2.
            nextVal := contentsArray at:nextIdx+1.
            nextVal = anObject ifTrue:[
                nextLen := contentsArray at:nextIdx.
                contentsArray at:nextIdx put:nextLen + 1.
                contentsArray at:runIndex put:len - 1.
                ^ anObject.
            ].
        ].

        "/ must cut off 1 & insert a new run after ..

        contentsArray at:runIndex put:len - 1.

        runSz := (runSz + 2).
        newRuns := Array new:runSz.
        newRuns replaceFrom:1 to:(runIndex + 1) with:contentsArray startingAt:1.
        newRuns replaceFrom:runIndex+4 to:runSz with:contentsArray startingAt:runIndex+2.
        contentsArray := newRuns.

        contentsArray at:runIndex+2 put:1.
        contentsArray at:runIndex+2+1 put:anObject.
        ^ anObject
    ].

    "/ hardest - split run into two, insert new run in-between

    runSz := (runSz + 4).
    newRuns := Array new:runSz.

    runIndex > 1 ifTrue:[
        newRuns replaceFrom:1 to:runIndex-1 with:contentsArray.
    ].
    newRuns replaceFrom:runIndex+6 to:runSz with:contentsArray startingAt:runIndex+2.

    l2 := len - (index - runOffset).
    l1 := len - l2.
    l2 := l2 - 1.

    newRuns at:runIndex   put:l1.
    newRuns at:runIndex+1 put:val.

    newRuns at:runIndex+4 put:l2.
    newRuns at:runIndex+5 put:val.

    "/ insert
    newRuns at:runIndex+2 put:1.
    newRuns at:runIndex+3 put:anObject.

    contentsArray := newRuns.
    ^ anObject

    "
     |c|

     Transcript cr.

     c := RunArray new.
     c add:1; add:1; add:1; add:2; add:2; add:3; add:3; add:4; add:5; yourself.
     Transcript showCR:c.   

     c at:1 put:$a.
     Transcript showCR:c.   
     c.

     c at:3 put:$a.
     Transcript showCR:c.   
     c.

     c at:4 put:$a.   
     Transcript showCR:c.   
     c.

     c at:5 put:$a.   
     Transcript showCR:c.   
     c.

     c at:2 put:$0.   
     Transcript showCR:c.   
     c.

     c at:2 put:$a.   
     Transcript showCR:c.   
     c.

     Transcript showCR:c.   
    "

    "Modified: / 30.10.1997 / 14:38:45 / cg"
!

atAllPut:anObject 
    "replace all elements of the collection by the argument, anObject.
     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    contentsArray := Array with:(self size) with:anObject

    "
     |c|

     c := RunArray new:20.
     c atAllPut:1.
     Transcript showCR:c.   
    "
! !

!RunArray methodsFor:'adding & removing'!

add:newObject
    "add newObject at the end.
     Returns the object (sigh)"

    ^ self add:newObject withOccurrences:1.

    "
     |c|

     c := RunArray new.
     c add:1; add:1; add:1; add:2; add:2; add:3; add:3; add:4; add:5; yourself.
    "

    "Modified: 10.5.1996 / 17:01:20 / cg"
!

add:newObject withOccurrences:n
    "add newObject n times at the end; returns the object (sigh)"

    |lastIdx runSz newRuns|

    contentsArray notNil ifTrue:[
        "/ check for merge

        runSz := contentsArray size.

        (contentsArray at:runSz) = newObject ifTrue:[
            lastIdx := runSz - 1.
            contentsArray at:lastIdx put:(contentsArray at:lastIdx) + n.
            ^ newObject
        ].

        newRuns := Array new:(runSz + 2).
        newRuns replaceFrom:1 to:runSz with:contentsArray.
        newRuns at:runSz+1 put:n.
        newRuns at:runSz+2 put:newObject.
        contentsArray := newRuns.
    ] ifFalse:[
        contentsArray := Array with:n with:newObject.
    ].
    ^ newObject

    "
     |c|

     c := RunArray new.
     c add:1 withOccurrences:1000; yourself.
     c add:1 withOccurrences:500; yourself.
     c add:2 withOccurrences:1000; yourself.
    "

    "Modified: 11.5.1996 / 13:34:37 / cg"
! !

!RunArray methodsFor:'comparing'!

= aCollection
    "return true, if the argument contains the same elements as the receiver.
     Optimized, especially for the common case, that collection is another runArray"

    |otherContents idx1 idx2 runCount1 runValue1 runCount2 runValue2|

    aCollection class ~~ self class ifTrue:[
        idx1 := 1.
        aCollection isSequenceable ifTrue:[
            self do:[:element |
                idx1 > aCollection size ifTrue:[^ false].
                element = (aCollection at:idx1) ifFalse:[^ false].
                idx1 := idx1+1.
            ].
            ^ idx1 > aCollection size.
        ].

        runCount1 := 0.
        aCollection do:[:element |
            runCount1 == 0 ifTrue:[
                idx1 >= contentsArray size ifTrue:[^ false].

                runCount1 := contentsArray at:idx1.
                runValue1 := contentsArray at:idx1+1.
                idx1 := idx1+2.
            ].
            runValue1 = element ifFalse:[^ false].
            runCount1 := runCount1 - 1.
        ].
        runCount1 ~~ 0 ifTrue:[^ false].
        ^ idx1 >= contentsArray size.
    ].

    otherContents := aCollection getContentsArray.
    otherContents = contentsArray ifTrue:[^ true].

    idx1 := idx2 := 1.
    runCount1 := runCount2 := 0.

    [
        runCount1 == 0 ifTrue:[
            idx1 >= contentsArray size ifTrue:[
                idx2+1 <= otherContents size ifTrue:[^ false].
                ^ runCount2 == 0.
            ].
            runCount1 := contentsArray at:idx1.
            runValue1 := contentsArray at:idx1+1.
            idx1 := idx1+2.
        ].        
        runCount2 == 0 ifTrue:[
            idx2 >= otherContents size ifTrue:[
                ^ false
            ].
            runCount2 := otherContents at:idx2.
            runValue2 := otherContents at:idx2+1.
            idx2 := idx2+2.
        ].        

        runValue1 = runValue2 ifFalse:[^ false].
        runCount1 > runCount2 ifTrue:[
            runCount1 := runCount1 - runCount2.
            runCount2 := 0.
        ] ifFalse:[
            runCount2 := runCount2 - runCount1.
            runCount1 := 0.
        ].
    ] loop.

    "
     'hello' asText sameStringAndEmphasisAs: 'hello' asText
     'hello' asText sameStringAndEmphasisAs: 'hello' asText allBold
     'hello' asText allBold sameStringAndEmphasisAs: 'hello' asText allBold
     'hello1' asText allBold sameStringAndEmphasisAs: 'hello' asText allBold  
     'hello' asText allBold sameStringAndEmphasisAs: 'hello1' asText allBold  
     ('hello' asText allBold , ' ') sameStringAndEmphasisAs: 'hello ' asText allBold  
     ('hello ' asText allBold) sameStringAndEmphasisAs: ('hello' asText allBold , ' ')  
     ('hello' asText allBold , ' ') sameStringAndEmphasisAs: ('hello' asText allBold , ' ')  
     'hello' asRunArray = 'hello' asRunArray 
     'hello1' asRunArray = 'hello' asRunArray 
     'hello' asRunArray = 'hello1' asRunArray 
     'hello' asRunArray = 'hello' asArray      
     'hello1' asRunArray = 'hello' asArray     
     'hello' asRunArray = 'hello1' asArray     
    "
! !

!RunArray methodsFor:'converting'!

asArray
    "return a new array, containing the receiver's elements."

    |newCollection dstIndex|

    contentsArray isNil ifTrue:[^ #()].

    newCollection := Array new:(self size).
    dstIndex := 1.
    contentsArray pairWiseDo:[:len :value |
        newCollection from:dstIndex to:(dstIndex + len - 1) put:value.
        dstIndex := dstIndex + len.
    ].
    ^ newCollection

    "
     |r|

     r := RunArray withAll:#(1 2 3 3 3 3 4 4 4 5 6 7 7 7 7 7 7 7).
     Transcript showCR:r.
     Transcript showCR:r asArray.
     Transcript showCR:r asRunArray.
    "
!

asOrderedCollection
    "return a new orderedCollection, containing the receiver's elements."

    |newCollection|

    contentsArray isNil ifTrue:[^ OrderedCollection new].

    newCollection := OrderedCollection new:(self size).
    contentsArray pairWiseDo:[:len :value |
        newCollection add:value withOccurrences:len
    ].
    ^ newCollection

    "
     |r|

     r := RunArray withAll:#(1 2 3 3 3 3 4 4 4 5 6 7 7 7 7 7 7 7).
     Transcript showCR:r.
     Transcript showCR:r asOrderedCollection
    "

    "Modified: 11.5.1996 / 13:34:59 / cg"
!

asRunArray
    "return the receiver itself"

    ^ self

    "Modified: / 7.4.1998 / 09:50:29 / cg"
! !

!RunArray methodsFor:'copying'!

copyFrom:start to:stop
    "return a new collection, containing the elements from start to stop"

    |runStart runNext newRuns idx copying|

    (contentsArray notNil 
    and:[stop >= start]) ifTrue:[
        newRuns := self species new.
        runStart := 1.
        idx := start.
        copying := false.
        contentsArray pairWiseDo:[:len :val | 
            runNext := runStart + len.
        
            copying ifFalse:[
                idx >= runStart ifTrue:[
                    copying := true
                ]
            ].
            copying ifTrue:[
                idx < runNext ifTrue:[
                    "/ found the first run

                    stop < runNext ifTrue:[
                        newRuns add:val withOccurrences:(stop-idx+1).
                        ^ newRuns
                    ].

                    newRuns add:val withOccurrences:(runNext-idx).
                    idx := runNext.
                ].
            ].
            runStart := runNext.
        ]
    ].

    ^ super copyFrom:start to:stop  "/ for the error report

    "
     |r|
     r := RunArray withAll:#(1 2 3 3 3 3 4 4 4 5 6 7 7 7 7 7 7 7).
     r copyFrom:1 to:10  

     |r|
     r := RunArray withAll:#(1 2 3 3 3 3 3 3 4 5 6 7 7 7 7 7 7 7).
     r copyFrom:4 to:10       

     |r|
     r := RunArray withAll:#(1 2 3 3 3 3 3 3 4 5 6 7 7 7 7 7 7 7).
     r copyFrom:1 to:20      
    "

    "Modified: 18.5.1996 / 19:28:47 / cg"
!

postCopy
    contentsArray := contentsArray copy.
! !

!RunArray methodsFor:'enumerating'!

conform:aBlock 
    "return true, if every element conforms to some condition.
     I.e. return false, if aBlock returns false for any element;
     true otherwise. Returns true for empty receivers."

    "/ redefined to not check individual elements, but runs
    contentsArray notNil ifTrue:[
        contentsArray pairWiseDo:[:len :val | 
            (aBlock value:val) ifFalse:[^ false].
        ]
    ].
    ^ true
!

contains:aBlock 
    "Return true, if aBlock returns true for any of the receiver's elements"

    contentsArray notNil ifTrue:[
        contentsArray pairWiseDo:[:len :val | 
            (aBlock value:val) ifTrue:[^ true].
        ].
    ].    
    ^ false
!

do:aBlock 
    "Evaluate aBlock with each of the receiver's elements as the 
    argument. "

    contentsArray notNil ifTrue:[
        contentsArray pairWiseDo:[:len :val | 
            len timesRepeat:[aBlock value:val]
        ]
    ]

    "Modified: / 30.10.1997 / 15:53:37 / cg"
!

runsDo:aBlock 
    "Evaluate aBlock with each of the receiver's runs, 
     passing length and value as arguments."

    contentsArray notNil ifTrue:[
        contentsArray pairWiseDo:aBlock
    ]

    "Modified: 11.5.1996 / 13:35:03 / cg"
    "Created: 12.5.1996 / 11:06:51 / cg"
!

withStartStopAndValueDo:aThreeArgBlock
    "Evaluate aBlock with each of the receiver's runs, passing
     start, end and attributes as arguments."

    |idx|

    contentsArray notNil ifTrue:[
        idx := 1.
        contentsArray pairWiseDo:[:count :emp |
            aThreeArgBlock value:idx value:(idx+count-1) value:emp     
        ]
    ]
! !


!RunArray methodsFor:'printing & storing'!

displayOn:aGCOrStream 
    "Append to aStream an expression which, if evaluated, will generate   
    an object similar to the receiver."

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifTrue:[
        aGCOrStream nextPutAll: '(RunArray new'.
        contentsArray notNil ifTrue:[
            contentsArray pairWiseDo:[:len :val | 
                aGCOrStream nextPutAll: ' add:'. val displayOn:aGCOrStream. 
                len == 1 ifFalse:[
                    aGCOrStream nextPutAll:' withOccurrences:'. len printOn:aGCOrStream.
                ].
                aGCOrStream nextPutAll:';'
            ].
            aGCOrStream nextPutAll:' yourself'
        ].
        aGCOrStream nextPutAll:')'.
        ^ self.
    ].
    ^ self displayOn:aGCOrStream x:0 y:0.

    "
     (RunArray new 
        add:1; 
        add:1; 
        add:2; 
        add:3; 
        add:4 withOccurrences:100; 
        add:5; 
        yourself) displayString 

     RunArray new displayString 
    "
!

storeOn:aStream 
    "Append to aStream an expression which, if evaluated, will generate   
    an object similar to the receiver."

    aStream nextPutAll: '(RunArray new'.
    contentsArray notNil ifTrue:[
        contentsArray pairWiseDo:[:len :val | 
            aStream nextPutAll: ' add:'. val storeOn:aStream. 
            len == 1 ifFalse:[
                aStream nextPutAll:' withOccurrences:'. len printOn:aStream.
            ].
            aStream nextPutAll:';'
        ].
        aStream nextPutAll:' yourself'
    ].
    aStream nextPutAll:')'

    "
     (RunArray new 
        add:1; 
        add:1; 
        add:2; 
        add:3; 
        add:4 withOccurrences:100; 
        add:5; 
        yourself) storeString 

     RunArray new storeString 
    "

    "Modified: 11.5.1996 / 14:28:38 / cg"
! !

!RunArray methodsFor:'private'!

find:oldObject 
    "If I contain oldObject return its index, otherwise create an error   
     notifier. It will answer with the position of the very first element of  
     that value.
     OBSOLETE: this is a leftover from earlier times; use #indexOf:ifAbsent:"

    <resource:#obsolete>

    |idx|

    self obsoleteMethodWarning:'use #indexOf:ifAbsent:'.
    idx := self indexOf:oldObject ifAbsent:0.
    idx ~~ 0 ifTrue:[^ idx].
    ^ self errorValueNotFound:oldObject

    "
     |c|

     c := RunArray new.
     c add:1; add:1; add:1; add:2; add:2; add:3; add:3; add:4; add:5.
     c find:2.

     c find:99
    "

    "Modified: / 30.10.1997 / 15:51:38 / cg"
!

find:oldObject ifAbsent:exceptionBlock 
    "If I contain oldObject return its index, otherwise execute the 
     exception block. It will answer with the position of the very first 
     element of that value.
     OBSOLETE: this is a leftover from earlier times; use #indexOf:ifAbsent:"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #indexOf:'.
    ^ self indexOf:oldObject ifAbsent:exceptionBlock

    "Modified: / 30.10.1997 / 15:49:54 / cg"
!

getContentsArray
    ^ contentsArray
!

runIndexAndStartIndexForIndex:anIndex
    "given a logical index, find the index of that run and the logical index
     of the first item in that run."

    |position nRuns "{ Class: SmallInteger }"|

    position := 1.
    nRuns := contentsArray size.
    1 to:nRuns by:2 do:[:runIndex | 
        |runLen runLast|

        runLen := contentsArray at:runIndex.
        anIndex >= position ifTrue:[
            runLast := position + runLen - 1.
            anIndex <= runLast ifTrue:[
                ^ Array with:runIndex with:position 
            ].
        ].
        position := position + runLen
    ].

    ^ #(0 0)

    "Created: 10.5.1996 / 17:12:28 / cg"
    "Modified: 11.5.1996 / 13:35:21 / cg"
!

setElement:newObject occurrences:n
    "private instance setup"

    contentsArray := Array with:n with:newObject.

    "Created: 11.5.1996 / 14:05:58 / cg"
!

setElementsFrom:aCollection
    "set my elements from aCollection"

    |nRuns last runLen first dIdx|

    aCollection size == 0 ifTrue:[^ self].

    "/ to avoid the reallocations when using
    "/ multiple #add:withOccurrences: calls, 
    "/ generate the runs collction as an orderedCollection
    "/ and convert to an array at the end.

    nRuns := 0.
    first := true.
    aCollection do:[:element |
        first ifTrue:[
            nRuns := nRuns + 1.
            last := element.
            first := false.
        ] ifFalse:[
            element ~~ last ifTrue:[
                nRuns := nRuns + 1.
                last := element.
            ]
        ]
    ].

    "/ now, we know how many runs there are ...
    contentsArray := Array new:(nRuns*2).

    nRuns := 0.
    runLen := 0.
    dIdx := 1.
    aCollection do:[:element |
        runLen == 0 ifTrue:[
            last := element.
            runLen := 1.
        ] ifFalse:[
            element == last ifTrue:[
                runLen := runLen + 1.
            ] ifFalse:[
                contentsArray at:dIdx   put:runLen.
                contentsArray at:dIdx+1 put:last.
                dIdx := dIdx + 2.
                runLen := 1.
                last := element.
            ]
        ]
    ].
    runLen ~~ 0 ifTrue:[
        contentsArray at:dIdx   put:runLen.
        contentsArray at:dIdx+1 put:last.
    ].

    "
     RunArray from:#(1 2 3 3 3 4 5 5 6 6 6 6 6 6)
    "

    "Modified: / 7.4.1998 / 09:33:57 / cg"
!

setElementsFromRuns:runs values:values
    <resource:#obsolete>
    self obsoleteMethodWarning:'use #setRuns:setValues: for VW compatibility'.
    self setRuns:runs setValues:values
!

setRuns:runs setValues:values
    |idx|

    contentsArray := Array new:(runs size * 2).
    idx := 1.
    runs with:values do:[:length :value |
        contentsArray at:idx put:length.
        contentsArray at:idx+1 put:value.
        idx := idx + 2.
    ].
! !

!RunArray methodsFor:'private-growing'!

grow:howBig
    "grow or shrink the receiver to contain howBig elements.
     If growing, new slots will be filled (logically) with nil."

    |sz info runIndex runOffset runSz newRuns|

    sz := self size.

    howBig == sz ifTrue:[^ self].

    howBig == 0 ifTrue:[
        contentsArray := nil.
        ^ self.
    ].

    contentsArray isNil ifTrue:[
        contentsArray := Array with:howBig with:nil.
        ^ self
    ].

    runSz := contentsArray size.

    howBig > sz ifTrue:[
        newRuns := Array new:(runSz + 2).
        newRuns replaceFrom:1 to:runSz with:contentsArray startingAt:1.
        newRuns at:(runSz+1) put:(howBig - sz).
        contentsArray := newRuns.
        ^ self
    ].

    "/ shrinking; possibly cut of a run

    info := self runIndexAndStartIndexForIndex:howBig.
    runIndex := info at:1.
    runOffset := info at:2.

    howBig == (runOffset - 1) ifTrue:[
        "/ we are lucky - new size is up-to previous run

        contentsArray := contentsArray copyFrom:1 to:runIndex-1.
    ] ifFalse:[
        contentsArray := contentsArray copyFrom:1 to:(runIndex+1).
        contentsArray at:runIndex put:(howBig - runOffset + 1)
    ].

    "
     |c|

     c := RunArray new.
     c addAll:#(1 2 3 4 4 4 4 5 5 5 1 2 3); yourself.

     c grow:50; yourself.

     c grow:7; yourself.

     c grow:6; yourself.

     c grow:0; yourself.
    "

    "Modified: 11.5.1996 / 13:34:53 / cg"
! !

!RunArray methodsFor:'queries'!

size
    "Answer how many elements the receiver contains.
     This is not the number of runs (but the simulated number of elements)."

    |n     "{ Class: SmallInteger }"
     runSz "{ Class: SmallInteger }"|

    n := 0.
    runSz := contentsArray size.
    1 to:runSz by:2 do:[:i |
        n := n + (contentsArray at:i)
    ].
    ^ n

    "Modified: 11.5.1996 / 13:34:27 / cg"
! !

!RunArray methodsFor:'searching'!

findFirst:aBlock ifNone:exceptionalValue
    "find the index of the first element, for which evaluation of the argument, aBlock
     returns true; return its index or 0 if none detected.
     Notice, that not all elements are processed here 
     (the block is only evaluated for each runs first element)."

    |idx|

    idx := 1.
    contentsArray notNil ifTrue:[
        contentsArray pairWiseDo:[:len :val | 
            (aBlock value:val) ifTrue:[^ idx].
            idx := idx + len.
        ]
    ].
    ^ exceptionalValue value

    "
     (RunArray new 
        add:1 withOccurrences:100;
        add:2 withOccurrences:100;
        add:3 withOccurrences:100;
        add:4 withOccurrences:100;
        yourself) findFirst:[:el | el == 3] 
    "

    "Modified: 14.5.1996 / 15:54:45 / cg"
!

identityIndexOf:anElement startingAt:start
    "search for identical anElement, return the index or 0 if not found.
     Redefined to prevent a loop over individual accesses via #at:,
     which would be very inefficient."

    |idx "{ Class: SmallInteger }" |

    contentsArray notNil ifTrue:[

        idx := 1.
        contentsArray pairWiseDo:[:len :val |
            |nextRunIdx "{ Class: SmallInteger }"|

            nextRunIdx := idx + len.
            nextRunIdx > start ifTrue:[
                (anElement == val) ifTrue:[
                    ^ idx max:start
                ]
            ].
            idx := nextRunIdx.
        ].
    ].
    ^ 0

    "Modified: / 14.5.1996 / 15:54:45 / cg"
    "Created: / 30.10.1997 / 15:33:18 / cg"
!

indexOf:anElement startingAt:start
    "search for equal anElement, return the index or 0 if not found.
     Redefined to prevent a loop over individual accesses via #at:,
     which would be very inefficient."

    |idx "{ Class: SmallInteger }" |

    contentsArray notNil ifTrue:[

        idx := 1.
        contentsArray pairWiseDo:[:len :val |
            |nextRunIdx "{ Class: SmallInteger }"|

            nextRunIdx := idx + len.
            nextRunIdx > start ifTrue:[
                (anElement = val) ifTrue:[
                    ^ idx max:start
                ]
            ].
            idx := nextRunIdx.
        ].
    ].
    ^ 0

    "
     |r|
     r := RunArray new. 
     r add:1 withOccurrences:100.
     r add:2 withOccurrences:100.
     r add:3 withOccurrences:100.
     r add:4 withOccurrences:100.
     r indexOf:2 startingAt:50.  
     r indexOf:2 startingAt:100.  
     r indexOf:2 startingAt:101.  
     r indexOf:2 startingAt:150.  
     r indexOf:2 startingAt:200.  
     r indexOf:2 startingAt:201.   
     r indexOf:2 startingAt:202.   
    "

    "Modified: / 30.10.1997 / 15:33:29 / cg"
! !

!RunArray methodsFor:'testing'!

includes:anElement
    "return true, if the receiver includes an element which is equal
     to the argument, anElement; false otherwise.
     Redefined to prevent the inherited loop over individual accesses via #at:,
     which would be very inefficient."

    contentsArray notNil ifTrue:[
        contentsArray pairWiseDo:[:len :val |
            (anElement = val) ifTrue:[
                ^ true
            ].
        ].
    ].
    ^ false

    "Modified: / 14.5.1996 / 15:54:45 / cg"
    "Created: / 30.10.1997 / 15:38:02 / cg"
!

includesIdentical:anElement
    "return true, if the receiver includes the argument, anElement; false otherwise.
     Redefined to prevent the inherited loop over individual accesses via #at:,
     which would be very inefficient."

    contentsArray notNil ifTrue:[
        contentsArray pairWiseDo:[:len :val |
            (anElement == val) ifTrue:[
                ^ true
            ].
        ].
    ].
    ^ false

    "Created: / 30.10.1997 / 15:38:30 / cg"
!

isEmpty
    "Am I empty or not. Returns a boolean"

    ^ contentsArray size == 0

    "Modified: 11.5.1996 / 13:35:17 / cg"
! !

!RunArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

