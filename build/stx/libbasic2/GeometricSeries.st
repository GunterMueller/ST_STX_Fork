"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

ReadOnlySequenceableCollection subclass:#GeometricSeries
	instanceVariableNames:'start stop factor'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!GeometricSeries class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
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
    Much like intervals (which have a constant difference between elements), 
    these have a constant factor between them.
    GeometricSeries represent a collection (or range) of values specified by
    a startValue, an endValue and a *factor*. 
    Like with intervals, the elements are computed, not stored.
    For example, the GeometricSeries (1 to:100 byFactor:2) contains the elements 
    (1 2 4 8 16 32 64).

    examples:

        (1 to:100 byFactor:2) do:[:i | Transcript showCR:i]
        (1 to:100 byFactor:1.1) do:[:i | Transcript showCR:i]
        (1 to:100 byFactor:2) asArray  
        (1 to:128 byFactor:2) asArray  
        (128 to:2 byFactor:(1/2)) asArray  

        (1 to:128 byFactor:2) sum
        (1 to:128 byFactor:2) asArray sum    
        
    [author:]
        Claus Gittinger
"
! !

!GeometricSeries class methodsFor:'instance creation'!

from:start to:stop byFactor:factor
    "return a new geometric series with elements from start
     to stop by a factor"

    ^ self new setFrom:start to:stop byFactor:factor


! !

!GeometricSeries methodsFor:'enumerating'!

do:aBlock
    "evaluate the argument, aBlock for every element in the receiver. 
     Redefined since SeqColl accesses the receiver with at:, 
     which is slow for intervals."

    |aValue iter|

    aValue := start.
    (aValue isLimitedPrecisionReal or:[factor isLimitedPrecisionReal]) ifFalse:[
        factor < 1 ifTrue:[
            [stop <= aValue] whileTrue:[
                aBlock value:aValue.
                aValue := aValue * factor
            ]
        ] ifFalse:[
            [stop >= aValue] whileTrue:[
                aBlock value:aValue.
                aValue := aValue * factor
            ]
        ]
    ] ifTrue:[
        "/ the code below avoids rounding errors
        "/ to accumulate if floats are enumerated.
        iter := 1.
        factor < 1 ifTrue:[
            [stop <= aValue] whileTrue:[
                aBlock value:aValue.
                aValue := start + (factor raisedTo:iter).
                iter := iter + 1.
            ]
        ] ifFalse:[
            [stop >= aValue] whileTrue:[
                aBlock value:aValue.
                aValue := start + (factor raisedTo:iter).
                iter := iter + 1.
            ]
        ]
    ]

    "
     (1 to:128 byFactor:2) do:[:v | Transcript showCR:v]
     (16 to:1 byFactor:(1/2)) do:[:v | Transcript showCR:v]
     (1.0 to:128.0 byFactor:2) do:[:v | Transcript showCR:v]

     (GeometricSeries from:1 to:128 byFactor:2) do:[:v | Transcript showCR:v]
    "
!

size
    |cnt|

    cnt := 0.
    self do:[:each | cnt := cnt + 1].
    ^ cnt

    "Created: / 31.10.2001 / 15:06:31 / cg"
! !

!GeometricSeries methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation to aStream"

    start printOn:aStream.
    aStream nextPutAll:' to:'.
    stop printOn:aStream.
    aStream nextPutAll:' byFactor:'.
    factor printOn:aStream.

!

storeOn:aStream
    "store a representation which can reconstruct the receiver to aStream"

    aStream nextPut:$(.
    self printOn:aStream.
    aStream nextPut:$).


! !

!GeometricSeries methodsFor:'private'!

setFrom:startVal to:stopVal byFactor:factorVal
    "set start, stop and factor components"

    start := startVal.
    stop := stopVal.
    factor := factorVal


!

species
    "return the type of collection to be returned by collect, select etc."

    ^ OrderedCollection

! !

!GeometricSeries class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

