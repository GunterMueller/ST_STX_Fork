"
 COPYRIGHT (c) 1989 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

ReadOnlySequenceableCollection subclass:#Interval
	instanceVariableNames:'start stop step'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!Interval class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Intervals represent a collection (or range) of numeric values specified by
    a startValue, an endValue and a step. 
    The interesting thing is that the elements are computed, not stored.
    However, protocol-wise, intervals behave like any other (read-only) sequenceable collection.

    For example, the interval (1 to:5) containes the elements (1 2 3 4 5) and
    (1 to:6 by:2) contains (1 3 5).

    The step may be negative, to count backward:
    (5 to:1 by:-1) contains (5 4 3 2 1), and (6 to:1 by:-2) contains (6 4 2).


    examples:

        (1 to:10) do:[:i | Transcript showCR:i]

      notice, that this is semantically equivalent to:

        1 to:10 do:[:i | Transcript showCR:i]

      however, the second is preferred, since loops using to:do: are
      much faster and do not create temporary garbage objects. 
      Therefore, Intervals are generally NOT used for this kind of loops.

        (1 to:10) asArray  

        (1 to:10 by:2) asOrderedCollection  

    [author:]
        Claus Gittinger
"
! !

!Interval class methodsFor:'instance creation'!

from:start to:stop
    "return a new interval with elements from start to stop by 1"

    ^ self new setFrom:start to:stop by:1
!

from:start to:stop by:step
    "return a new interval with elements from start to stop by step"

    ^ self new setFrom:start to:stop by:step
! !

!Interval class methodsFor:'converting'!

decodeFromLiteralArray:anArray
    "create & return a new instance from information encoded in anArray.
     Re-redefined, since the implementation in SequencableCollection creates instances with an initial
     size, which is not allowed for intervals."

    ^ self new fromLiteralArrayEncoding:anArray.
! !

!Interval methodsFor:'accessing'!

at:index
    "return (i.e. compute) the index'th element"

    (index between:1 and:self size) ifTrue:[
        ^ start + (step * (index - 1))
    ].
    ^ self subscriptBoundsError:index
!

first
    "return the first element of the collection"

    (((step < 0) and:[start < stop])
    or:[(step > 0) and:[stop < start]]) ifTrue:[
        ^ self emptyCollectionError
    ].
    ^ start
!

increment 
    "alias for #step; for ST-80 compatibility"

    ^ step
!

last
    "return the last element of the collection"

    (((step < 0) and:[start < stop])
    or:[(step > 0) and:[stop < start]]) ifTrue:[
        ^ self emptyCollectionError
    ].
    ^ stop
!

start
    "return the first number of the range"

    ^ start
!

start:aNumber
    "set the first number of the range"

    start := aNumber
!

step
    "return the step increment of the range.
     OBSOLETE: 
        Please use #increment for ST-80 compatibility."

    ^ step
!

step:aNumber
    "set the step increment of the range"

    step := aNumber
!

stop
    "return the end number of the range"

    ^ stop
!

stop:aNumber
    "set the end number of the range"

    stop := aNumber
! !

!Interval methodsFor:'bulk operations'!

sum
    "sum up all elements."

    "/              n*(n+1)
    "/ sum(1..n) is -------
    "/                 2
    
    start < stop ifTrue:[
        step == 1 ifTrue:[
            start == 1 ifTrue:[
                ^ (stop * (stop + 1) / 2)
            ].
            ^ (stop * (stop + 1) / 2) - ((start-1) * (start ) / 2)
        ]
    ].
    "/ could add more optimizations here, but who needs them?

    ^ super sum

    "
     (1 to:10) sum         
     (1 to:10) asArray sum 

     (2 to:10) sum           
     (2 to:10) asArray sum   

     (5 to:10) sum    
     (5 to:10) asArray sum     
    "
! !

!Interval methodsFor:'comparing'!

= anInterval
    anInterval class == self class ifTrue:[
        ^ start = anInterval start
        and:[ stop = anInterval stop
        and:[ step = anInterval step]]
    ].
    ^ super = anInterval
!

hash
    ^ super hash "/ do not redefine: must generate same hash as SeqColl.
! !

!Interval methodsFor:'converting'!

asInterval
    ^ self.
!

fromLiteralArrayEncoding:encoding
    "read my values from an encoding.
     The encoding is supposed to be either of the form: 
        (#Interval start stop step)
     This is the reverse operation to #literalArrayEncoding."

    start := (encoding at:2).
    stop := (encoding at:3). 
    (encoding size > 3) ifTrue:[ 
        step := (encoding at:4).
    ] ifFalse:[
        step := 1.
    ]

    "
     Interval new fromLiteralArrayEncoding:((1 to:10) literalArrayEncoding)  
     Interval new fromLiteralArrayEncoding:((1 to:10 by:2) literalArrayEncoding) 
     Interval decodeFromLiteralArray:((1 to:10 by:2) literalArrayEncoding) 
    "
!

literalArrayEncoding
    "encode myself as an array literal, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray."

    ^ Array
        with:self class name
        with:start
        with:stop
        with:step

    "
     (1 to:10) literalArrayEncoding      
     (1 to:10 by:2) literalArrayEncoding
    "
! !

!Interval methodsFor:'converting-reindexed'!

from:startIndex
    "return a new collection representing the receiver's elements starting at startIndex."

    step == 1 ifTrue:[
        ^ start+startIndex-1 to:stop
    ].
    "could be more intelligent here"
    ^ super from:startIndex

    "
     (1 to:100) from:2  

     (1 to:20 by:2) from:2           
     (1 to:20 by:2) asArray from:2    
     ((1 to:20 by:2) from:2) asArray   
    "
!

to:endIndex
    "return a new collection representing the receiver's elements upTo and including endIndex."

    ^ start to:(endIndex min:stop) by:step

    "
     (1 to:100) to:50    
     (1 to:100 by:2) to:50    
    "
! !

!Interval methodsFor:'enumerating'!

collect:aBlock
    "evaluate the argument, aBlock for every element in the collection
     and return a collection of the results.
     Redefined since the inherited method (SeqColl) accesses the receiver via at:, 
     which is slow for intervals"

    |elementValue mySize newCollection|

    elementValue := start.
    newCollection := self species newWithSize:(mySize := self size).
    1 to: mySize do:[:i |
        newCollection at:i put:(aBlock value:elementValue).
        elementValue := elementValue + step.
    ].
    ^ newCollection    

    "
     (1 to:20 by:2) collect:[:i | i*i]              
    "

    "Modified: / 04-05-2012 / 13:03:56 / cg"
!

do:aBlock
    "evaluate the argument, aBlock for every element in the receiver-interval. 
     Redefined since SeqColl accesses the receiver with at:, which is slow for intervals."

    |aValue iter|

    aValue := start.
    aValue isInteger ifTrue:[
        step < 0 ifTrue:[
            [stop <= aValue] whileTrue:[
                aBlock value:aValue.
                aValue := aValue + step
            ]
        ] ifFalse:[
            [stop >= aValue] whileTrue:[
                aBlock value:aValue.
                aValue := aValue + step
            ]
        ]
    ] ifFalse:[
        "/ the code below avoids rounding errors
        "/ to accumulate if floats are enumerated.
        iter := 1.
        step < 0 ifTrue:[
            [stop <= aValue] whileTrue:[
                aBlock value:aValue.
                aValue := start + (iter * step).
                iter := iter + 1.
            ]
        ] ifFalse:[
            [stop >= aValue] whileTrue:[
                aBlock value:aValue.
                aValue := start + (iter * step).
                iter := iter + 1.
            ]
        ]
    ]

    "
     1e7 to:1e7+1 by:0.25 do:[:v | Transcript showCR:v]
     1.0 to:2.0 by:0.25 do:[:v | Transcript showCR:v]
     2.0 to:1.0 by:-0.25 do:[:v | Transcript showCR:v]
     $a to:$z do:[:v | Transcript showCR:v]
    "

    "Modified: / 22-10-2008 / 12:47:30 / cg"
!

reverseDo:aBlock
    "evaluate the argument, aBlock for every element in the receiver-interval in
     reverse order. 
     Redefined since SeqColl accesses the receiver with at:, which is slow for intervals."

    ^ self reversed do:aBlock

    "
     (1 to:10) do:[:el | Transcript showCR:el ].
     (1 to:10) reverseDo:[:el | Transcript showCR:el ].
    "

    "Modified: / 22-10-2008 / 12:49:28 / cg"
!

select:aBlock
    "evaluate the argument, aBlock for every element in the collection
     and return a collection of all elements for which the block return true. 
     Redefined since SeqColl accesses the receiver with at:, which is slow for intervals."

    |newColl|

    newColl := self species new:(self size).
    self do:[:each |
        (aBlock value:each) ifTrue:[newColl add:each]
    ].
    ^ newColl

    "
     (1 to:20) select:[:i | i even]
    "

    "Modified: / 22-10-2008 / 12:47:41 / cg"
! !


!Interval methodsFor:'printing & storing'!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifTrue:[
        self printOn:aGCOrStream.
        ^ self.
    ].
    ^ super displayOn:aGCOrStream

    "
     (1 to:10) 
     (1 to:10 by:2) 
    "
!

printOn:aStream
    "append a printed representation to aStream"

    start printOn:aStream.
    aStream nextPutAll:' to:'.
    stop printOn:aStream.
    step ~= 1 ifTrue:[
        aStream nextPutAll:' by:'.
        step printOn:aStream.
    ].

    "
     (1 to:10) printOn:Transcript
     (1 to:10 by:2) printOn:Transcript
     (1 to:10) printString
    "
!

storeOn:aStream
    "store a representation which can reconstruct the receiver to aStream"

    aStream nextPut:$(.
    self printOn:aStream.
    aStream nextPut:$).

    "
     (1 to:10) storeOn:Transcript
     (1 to:10 by:2) storeOn:Transcript
    "
! !

!Interval methodsFor:'private'!

setFrom:startInteger to:stopInteger by:stepInteger
    "set start, stop and step components"

    start := startInteger.
    stop := stopInteger.
    step := stepInteger
!

species
    "return the type of collection to be returned by collect, select etc."

    ^ OrderedCollection
! !

!Interval methodsFor:'queries'!

max
    "return the maximum value in the receiver collection,
     redefined, since this can be easily computed.
     Raises an error, if the receiver is empty."

    step == 1 ifTrue:[stop >= start ifTrue:[^ stop]].
    step < 0 ifTrue:[stop <= start ifTrue:[^ start]].
    ^ super max

    "
     (0 to:15) max           
     (0 to:15 by:2) max      
     (0 to:15 by:8) max      
     (15 to:0) max           -> error
     (15 to:0 by:4) max      -> error      
     (-1 to:-15 by:-1) max    
     (-1 to:-15 by:-4) max    
     (-1 to:15 by:-1) max    -> error  
    "
!

min
    "return the minimum value in the receiver collection,
     redefined, since this can be easily computed.
     Raises an error, if the receiver is empty."

    step == -1 ifTrue:[stop <= start ifTrue:[^ stop]].
    step > 0 ifTrue:[stop >= start ifTrue:[^ start]].
    ^ super min

    "
     (0 to:15) min           
     (0 to:15 by:2) min      
     (0 to:15 by:8) min      
     (15 to:0) min          -> error
     (15 to:0 by:4) min     -> error     
     (-1 to:-15 by:-1) min    
     (-1 to:-15 by:-4) min    
     (-1 to:15 by:-1) min   -> error   
    "
!

minMax
    "return the minimum and maximum values in the receiver collection
     as a two element array.
     Raises an error, if the receiver is empty."

    step == -1 ifTrue:[
        stop <= start ifTrue:[
            ^ Array with:stop with:start
        ]
    ].
    step == 1 ifTrue:[
        stop >= start ifTrue:[
            ^ Array with:start with:stop
        ]
    ].
    ^ super minMax

    "
     (0 to:15) minMax           
     (0 to:15 by:2) minMax      
     (0 to:15 by:8) minMax      
     (15 to:0) minMax          -> error
     (15 to:0 by:4) minMax     -> error     
     (-1 to:-15 by:-1) minMax    
     (-1 to:-15 by:-4) minMax    
     (-1 to:15 by:-1) minMax   -> error   
    "
!

size
    "return the number of elements in the collection"

    (step < 0) ifTrue:[
        (start < stop) ifTrue:[
            ^ 0
        ].
        ^ (start - stop) // step abs + 1
    ].
    (stop < start) ifTrue:[
        ^ 0
    ].
    ^ (stop - start) // step + 1
! !

!Interval methodsFor:'set operations'!

intersect:aCollection
    "return a new interval containing all elements of the receiver, 
     which are also contained in the argument collection"

    "/ could be much more intelligent here...
    aCollection class == Interval ifTrue:[
        aCollection step = step ifTrue:[
            step = 1 ifTrue:[
                (self includes:aCollection start) ifTrue:[
                    ^ (start max:(aCollection start)) to:(stop min:(aCollection stop))
                ].
                (self includes:aCollection stop) ifTrue:[
                    ^ (start max:(aCollection start)) to:(stop min:(aCollection stop))
                ]
            ]
        ].
    ].

    ^ super intersect:aCollection

    "
     (1 to:10) intersect:(4 to:20)      
     (1 to:10) intersect:(11 to:20)      
     (1 to:10) intersect:(10 to:20)      
     (4 to:20) intersect:(1 to:10)      
     (4 to:20) intersect:(1 to:10 by:2)      
    "
! !

!Interval methodsFor:'sorting & reordering'!

reversed
    "return a copy with elements in reverse order"

    "this can be tricky, if stepping from start does not reach stop exactly.
     So what is the reverse of: (2 to:5 by: 2) ?
     I think, that the correct semantic is to behave transparent to the type
     of collection and generate the same elements as another collection would.
     In other words, the same as (1 to:5 by: 2) asOrderedCollection reversed
     would. That means, we get: #(4 2).
     This also means, that (2 to:5 by: 2) reversed reversed does not return the
     original, but another interval which generates the same elements !! (2 to:4 by: 2)"

    |rest|

    step isInteger ifTrue:[
        rest := ((stop - step) rem: step).
        ^ (stop-rest) to:start by:step negated
    ].
    ^ super reversed


    "
     (1 to:4) reversed asOrderedCollection   
     (1 to:4) reversed reversed asOrderedCollection 
     (1 to:4) asOrderedCollection reversed    
     (1 to:4) asOrderedCollection reversed reversed 

     (2 to:5 by: 2) asOrderedCollection     
     (2 to:5 by: 2) asOrderedCollection reversed    
     (2 to:5 by: 2) asOrderedCollection reversed reversed  
     (2 to:5 by: 2) reversed asOrderedCollection         
     (2 to:5 by: 2) reversed reversed asOrderedCollection   

     (1 to:2 by: 0.3) asOrderedCollection        
     (1 to:2 by: 0.3) asOrderedCollection reversed  
     (1 to:2 by: 0.3) asOrderedCollection reversed reversed  
     (1 to:2 by: 0.3) reversed asOrderedCollection     
     (1 to:2 by: 0.3) reversed reversed asOrderedCollection     
    "
! !

!Interval methodsFor:'testing'!

includes:anElement
    "return true if anElement is in the interval (Numeric compare using =)"

    |rest|

    stop >= start ifTrue:[
        (anElement between:start and:stop) ifFalse:[^ false].
    ] ifFalse:[
        (anElement between:stop and:start) ifFalse:[^ false].
    ].
    rest := (anElement - start) rem:step.
    ^ rest = 0

    "
     (1 to:15) includes:0
     (1 to:15) includes:16
     (1 to:15) includes:1    
     (1 to:15) includes:15   
     (1 to:15) includes:5    
     (1 to:15) includes:14   
     (1 to:15) includes:4   
     (1 to:15) includes:4.0   
     (1 to:15) includes:4.4   

     (1 to:15 by:3) includes:0
     (1 to:15 by:3) includes:16
     (1 to:15 by:3) includes:1    
     (1 to:15 by:3) includes:15   
     (1 to:15 by:3) includes:5    
     (1 to:15 by:3) includes:4    
     (1 to:15 by:3) includes:13   
     (1 to:15 by:3) includes:14   
     (1 to:15 by:3) includes:4.0   
     (1 to:15 by:3) includes:4.4   

     (10 to:-10 by:-3) includes:11   
     (10 to:-10 by:-3) includes:10   
     (10 to:-10 by:-3) includes:9   
     (10 to:-10 by:-3) includes:8   
     (10 to:-10 by:-3) includes:7   
     (10 to:-10 by:-3) includes:4   
     (10 to:-10 by:-3) includes:0   
     (10 to:-10 by:-3) includes:-1   
     (10 to:-10 by:-3) includes:-2   
     (10 to:-10 by:-3) includes:-8     
     (10 to:-10 by:-3) includes:-9     
     (10 to:-10 by:-3) includes:-10    
     (10 to:-10 by:-3) includes:-11    
     (10 to:-10 by:-3) includes:-2.4   

     (-10 to:-20 by:-2) includes:-16   
     (-10 to:-20 by:-2) includes:-20   
     (-10 to:-20 by:-2) includes:-23   
     (-10 to:-20 by:-2) includes:-24   

    "
! !

!Interval methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitInterval:with: to aVisitor.
     this is special. Some encoders want to encode this as a sequenceable collection,
     some want to encode a less expensive representation"

    ^ aVisitor visitInterval:self with:aParameter
! !

!Interval class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

