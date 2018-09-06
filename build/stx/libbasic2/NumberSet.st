"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

SequenceableCollection subclass:#NumberSet
	instanceVariableNames:'intervals'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered'
!

!NumberSet class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    NumberSets are sets holding positive integers.

    This class has been written especially to represent number-ranges as found in .newsrc-files,
    and it supports reading/writing of that format (for example: '0-62,69,82,84,86,88,91').
    It is space optimized for sparse sets of numbers, containing a mix of single numbers
    and chunks of sequential sub ranges. 
    When adding elements, holes between 2 subranges
    are detected, and merged into single subranges.
    It may need some care to be used in other situations.

    The implementation uses an array of intervals or individual numbers.

    Reading and writing is in .newsrc-format.

    [author:]
        Claus Gittinger (spring '92)

    [see also:]
        NewsHandler
        Interval Set
"
! !

!NumberSet class methodsFor:'instance creation'!

with:aNumberOrInterval
    "return a new numberSet containing a single number
     or the numbers from an interval"

    ^ self new setFirst:aNumberOrInterval

    "
     NumberSet with:69
     NumberSet with:(1 to:50)
    "

    "Modified: 9.5.1996 / 17:25:18 / cg"
! !

!NumberSet class methodsFor:'input from a stream'!

readFrom:aStringOrStream
    "read a NumberSet (in .newsrc format) from aStream.
     return an empty NumberSet if nothing can be read (or wrong format)"

    ^ self new readFrom:aStringOrStream

    "
     NumberSet readFrom:(ReadStream on:'0-62,69,82,84,86,88,91').
    "

    "
     |ns s string|

     ns := NumberSet new.
     ns add:1.
     ns add:2.
     ns add:3.
     ns add:5.
     s := '' writeStream.
     ns printOn:s.
     string := s contents.

     NumberSet readFrom:string.     
    "

    "Modified: 9.5.1996 / 18:45:37 / cg"
! !

!NumberSet methodsFor:'accessing'!

lastOfFirstInterval
    "return the last element of the first interval.
     Return nil if the receiver is empty."

    |element|

    intervals isNil ifTrue:[^ nil].

    element := intervals at:1.
    (element isNumber) ifFalse:[^ element stop].
    ^ element

    "Modified: 9.5.1996 / 17:31:37 / cg"
! !

!NumberSet methodsFor:'adding & removing'!

add:aNumber
    "add the argument, aNumber to the NumberSet"

    |index endIndex searching element nextElement newIntervals|

    intervals isNil ifTrue:[
        intervals := OrderedCollection with:aNumber.
        ^ self
    ].

    "/ search for an interval to expand (on the fly watch out if already there)

    index := 1.
    endIndex := intervals size.
    searching := true.
    [searching] whileTrue:[
        element := intervals at:index.
        (element isNumber) ifTrue:[
            "make a number to an interval"
            (element = (aNumber - 1)) ifTrue:[ 
                intervals at:index put:(element to:aNumber).
                self tryMerge:index.
                ^ self
            ].
            (element = (aNumber + 1)) ifTrue:[ 
                intervals at:index put:(aNumber to:element).
                self tryMerge:(index - 1).
                ^ self
            ]. 
            "already in set"
            (element = aNumber) ifTrue:[^ self].
            "not in - stop search"
            (element > aNumber) ifTrue:[searching := false]
        ] ifFalse:[
            "expand interval"
            (element start = (aNumber + 1)) ifTrue:[ 
                element start:aNumber.
                self tryMerge:(index - 1).
                ^ self
            ]. 
            (element stop = (aNumber - 1)) ifTrue:[ 
                element stop:aNumber.
                self tryMerge:index.
                ^ self
            ].
            "already in set"
            ((element start <= aNumber) and:[
             (element stop >= aNumber)]) ifTrue:[^ self].
            "not in - stop search"
            (element start > aNumber) ifTrue:[searching := false]
        ].
        searching ifTrue:[
            index := index + 1.
            (index > endIndex) ifTrue:[searching := false]
        ]
    ].

    "/ append at end
    (index > endIndex) ifTrue:[
        intervals add:aNumber.
        ^ self
    ].

    "/ insert before index

    intervals add:aNumber beforeIndex:index.

    "Modified: 9.5.1996 / 17:31:05 / cg"
!

remove:aNumber ifAbsent:aBlock
    "remove the argument, aNumber from the NumberSet"

    |index endIndex element newIntervals|

    (intervals isNil or:[intervals size == 0]) ifTrue:[
        ^ aBlock value
    ].

    index := 1.
    endIndex := intervals size.
    [true] whileTrue:[
        element := intervals at:index.
        (element isNumber) ifTrue:[
            (element = aNumber) ifTrue:[
                (intervals size == 1) ifTrue:[
                    intervals := nil
                ] ifFalse:[
                    intervals removeIndex:index
                ].
                ^ self
            ].
            "not in - stop search"
            (element > aNumber) ifTrue:[^ aBlock value]
        ] ifFalse:[
            "can remove from interval ?"
            (element start = aNumber) ifTrue:[ 
                element start:(aNumber + 1).
                (element start = element stop) ifTrue:[
                    intervals at:index put:(element start)
                ].
                ^ self
            ]. 
            (element stop = aNumber) ifTrue:[ 
                element stop:(aNumber - 1).
                (element start = element stop) ifTrue:[
                    intervals at:index put:(element start)
                ].
                ^ self
            ].
            (element start > aNumber) ifTrue:[^ aBlock value].
            ((element start <= aNumber) and:[
             (element stop >= aNumber)]) ifTrue:[
                "must make it two intervals"
                newIntervals := OrderedCollection new:(endIndex + 1).
                newIntervals replaceFrom:1 to:(index - 1) with:intervals.
                newIntervals replaceFrom:(index + 2) to:(endIndex + 1)
                                    with:intervals startingAt:(index + 1).
                (element start = (aNumber - 1)) ifTrue:[
                    newIntervals at:index put:element start
                ] ifFalse:[
                    newIntervals at:index put:(element start to:(aNumber - 1))
                ].
                ((aNumber + 1) = element stop) ifTrue:[
                    newIntervals at:(index + 1) put:(aNumber + 1)
                ] ifFalse:[
                    newIntervals at:(index + 1) put:((aNumber + 1) to:element stop)
                ].
                intervals := newIntervals.
                ^ self
            ]
        ].
        index := index + 1.
        (index > endIndex) ifTrue:[^ aBlock value]
    ]

    "Modified: 9.5.1996 / 17:30:52 / cg"
! !

!NumberSet methodsFor:'enumerating'!

do:aBlock
    "evaluate the argument, aBlock for each element in the numberSet"

    intervals isNil ifTrue:[^ self].
    intervals do:[:element |
        (element isNumber) ifTrue:[
            aBlock value:element
        ] ifFalse:[
            element do:aBlock
        ] 
    ]

    "Modified: 9.5.1996 / 17:30:19 / cg"
! !

!NumberSet methodsFor:'printing'!

displayString
    "return a nice string"

    |first s|

    intervals size == 0 ifTrue:[^ 'NumberSet()'].

    s := 'NumberSet('.
    first := true.
    intervals do:[:element |
        first ifTrue:[
            first := false
        ] ifFalse:[
            s := s , ','
        ]. 
        (element isNumber) ifTrue:[
            s := s , (element printString)
        ] ifFalse:[
            s := s , (element start printString).
            s := s , '-'.
            s := s , (element stop printString)
        ] 
    ].
    s := s , ')'.
    ^ s

    "Modified: 9.5.1996 / 17:30:14 / cg"
!

printOn:aStream
    "output the NumberSet (in .newsrc format) on aStream"

    |first|

    intervals isNil ifTrue:[^ self].

    first := true.
    intervals do:[:element |
        first ifTrue:[
            first := false
        ] ifFalse:[
            aStream nextPut:$,
        ]. 
        (element isNumber) ifTrue:[
            aStream nextPutAll:(element printString)
        ] ifFalse:[
            aStream nextPutAll:(element start printString).
            aStream nextPut:$-.
            aStream nextPutAll:(element stop printString)
        ] 
    ]

    "Modified: 9.5.1996 / 17:30:10 / cg"
! !

!NumberSet methodsFor:'private'!

readFrom:aStringOrStream
    "read my value from aStream (in .newsrc format)"

    |s nextChar arr start stop done|

    s := aStringOrStream readStream.

    s skipSeparators.
    s atEnd ifTrue:[^ nil].

    intervals := OrderedCollection new.

    done := false.
    [done] whileFalse:[
        s atEnd ifTrue:[
            done := true
        ] ifFalse:[
            start := Number readFrom:s.
            start isNil ifTrue:[
                done := true
            ] ifFalse:[
                s skipSeparators.
                s atEnd ifTrue:[
                    intervals add:start. 
                    done := true
                ] ifFalse:[
                    nextChar := s peek.
                    (nextChar == $-) ifTrue:[
                        s next.
                        stop := Number readFrom:s.
                        intervals add:(start to:stop)
                    ] ifFalse:[
                        intervals add:start
                    ].
                    s skipSeparators.
                    s atEnd ifTrue:[
                        done := true
                    ] ifFalse:[
                        nextChar := s peek.
                        (nextChar == $,) ifFalse:[
                             done := true
                        ] ifTrue:[
                             s next
                        ]
                    ]
                ]
            ]
        ]
    ].
    (intervals size == 0) ifTrue:[
        intervals := nil
    ]

    "
     NumberSet new readFrom:(ReadStream on:'0-62,69,82,84,86,88,91')
     NumberSet new readFrom:'0-62,69,82,84,86,88,91'
    "

    "Modified: 9.5.1996 / 18:46:26 / cg"
!

tryMerge:index
    "try to make element at index and index + 1 be one element"

    |element first last first2 last2 nextElement|

    (index > 0) ifTrue:[
        (index < (intervals size)) ifTrue:[
            element := intervals at:index.
            (element isNumber) ifFalse:[
                first := element start.
                last := element stop
            ] ifTrue:[
                first := element.
                last := element
            ].
    
            nextElement := intervals at:(index + 1).
            (nextElement isNumber) ifFalse:[
                first2 := nextElement start.
                last2 := nextElement stop
            ] ifTrue:[
                first2 := nextElement.
                last2 := nextElement
            ].
    
            (last >= (first2 - 1)) ifTrue:[
                intervals at:index put:(first to:last2).
                intervals removeIndex:(index + 1)
            ]
        ]
    ]

    "Modified: 9.5.1996 / 17:29:50 / cg"
! !

!NumberSet methodsFor:'private accessing'!

setFirst:aNumberOrInterval 
    "set the first element"

    intervals := OrderedCollection with:aNumberOrInterval

    "Modified: 9.5.1996 / 17:26:26 / cg"
! !

!NumberSet methodsFor:'queries'!

first
    "answer the first i.e. lowest number in the set.
     If the receiver is empty, return nil."

    |element|

    intervals isNil ifTrue:[^ nil].

    element := intervals at:1.
    (element isNumber) ifTrue:[
        ^ element
    ].
    ^ element start

    "Modified: 9.5.1996 / 17:29:14 / cg"
!

includes:aNumber
    "answer true, if aNumber is in the set"

    |endIndex index middle delta element start stop|

    intervals isNil ifTrue:[^ false].

    index := 1.
    endIndex := intervals size.

    "/ use a binary search, to limit search

    middle := (endIndex + index) // 2.
    [(middle > (index + 1)) and:[middle < (endIndex - 1)]] whileTrue:[
        element := intervals at:middle.
        (element isNumber) ifFalse:[
            (element stop <= aNumber) ifTrue:[
                index := middle
            ] ifFalse:[
                (element start >= aNumber) ifTrue:[
                    endIndex := middle
                ] ifFalse:[
                    (element includes:aNumber) ifTrue:[^ true]
                ]
            ]
        ] ifTrue:[
            (element <= aNumber) ifTrue:[
                (element == aNumber) ifTrue:[^ true].
                index := middle
            ] ifFalse:[
                endIndex := middle
            ]
        ].
        middle := (endIndex + index) // 2
    ].

    [index <= endIndex] whileTrue:[
        element := intervals at:index.
        (element isNumber) ifFalse:[
            (element start > aNumber) ifTrue:[ ^ false].
            (element stop >= aNumber) ifTrue:[ ^ true]
        ] ifTrue:[
            (element > aNumber) ifTrue:[ ^ false].
            (element = aNumber) ifTrue:[ ^ true]
        ].
        index := index + 1
    ]. 

    ^ false

    "Modified: 9.5.1996 / 17:29:05 / cg"
!

last
    "answer the last i.e. highest number in the set.
     If the receiver is empty, return nil."

    |element|

    intervals isNil ifTrue:[^ nil].

    element := intervals last.
    (element isNumber) ifTrue:[
        ^ element
    ].
    ^ element stop

    "Modified: 9.5.1996 / 17:29:10 / cg"
!

size
    "return the number of elements in the Set"

    |tally|

    intervals isNil ifTrue:[^ 0].
    tally := 0.

    intervals do:[:element |
        (element isNumber) ifTrue:[
            tally := tally + 1
        ] ifFalse:[
            tally := tally + element size
        ] 
    ].
    ^ tally

    "Modified: 9.5.1996 / 17:29:20 / cg"
! !

!NumberSet class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

