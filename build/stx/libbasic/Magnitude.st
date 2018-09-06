"
 COPYRIGHT (c) 1988 by Claus Gittinger
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

Object subclass:#Magnitude
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-General'
!

!Magnitude class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
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
    This is an abstract class definining common methods for
    Objects which can be compared by a kind of less-than relation.

    [author:]
        Claus Gittinger
"
! !

!Magnitude class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned for Magnitude here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == Magnitude
! !

!Magnitude methodsFor:'Compatibility-Squeak'!

min:aMin max:aMax 
    "similar to clampBetween:and:"

    ^ (self min: aMin) max: aMax

    "Created: / 06-06-2007 / 11:00:22 / cg"
! !

!Magnitude methodsFor:'comparing'!

< aMagnitude
    "Compare the receiver with the argument and return true if the
     receiver is less than the argument. Otherwise return false."

    ^ self subclassResponsibility
!

<= aMagnitude
    "return true, if the argument is greater or equal than the receiver"

    ^ (aMagnitude < self) not
!

= aMagnitude
    "Compare the receiver with the argument and return true if the
     receiver is equal to the argument. Otherwise return false."

    ^ self subclassResponsibility
!

> aMagnitude
    "return true, if the argument is less than the receiver"

    ^ aMagnitude < self
!

>= aMagnitude
    "return true, if the argument is less or equal than the receiver"

    ^ (self < aMagnitude) not
!

clampBetween:min and:max
    "return the receiver if its between min .. max,
     or min if its less than min, or max of its greater than max.
     This is only a lazy-typers helper for: ((something min:max) max:min)"

    (max < self) ifTrue:[^ max].
    (self < min) ifTrue:[^ min].
    ^ self

    "
     1 clampBetween:2 and:5  
     3 clampBetween:2 and:5  
     6 clampBetween:2 and:5  
    "

    "Modified: 19.4.1996 / 14:58:12 / cg"
!

compare:arg ifLess:lessBlock ifEqual:equalBlock ifGreater:greaterBlock
    "three-way compare - thanks to Self for this idea.
     Can be redefined in subclasses to do it with a single comparison if
     comparison is expensive."

    self < arg ifTrue:[
	^ lessBlock value
    ].
    self = arg ifTrue:[
	^ equalBlock value
    ].
    ^ greaterBlock value
!

compareWith:arg
    "Compare the receiver with the argument and return 1 if the receiver is
     greater, 0 if equal and -1 if less than the argument."

    self < arg ifTrue:[
        ^ -1
    ].
    self = arg ifTrue:[
        ^ 0
    ].
    ^ 1

    "
     100 compareWith: 101
    "
!

hash
    "instances, for which #= answers true must answer the same hash"

    ^ self subclassResponsibility
!

max:aMagnitude
    "return the receiver or the argument, whichever has greater magnitude"

    (aMagnitude < self) ifTrue:[^ self].
    ^ aMagnitude

    "
     1 max: 2
     1 max: 2.0
     2.0 max: 1.0
     2.0 max: 2
    "
!

min:aMagnitude
    "return the receiver or the argument, whichever has lesser magnitude"

    (self < aMagnitude) ifTrue:[^ self].
    ^ aMagnitude

    "
     1 min: 2
     1 min: 2.0
     2.0 min: 1.0
     2.0 min: 2
    "
! !

!Magnitude methodsFor:'iteration'!

downTo:stop by:step do:aBlock
    "For each element of the interval from the receiver down to the argument stop,
     decrementing by step, evaluate aBlock, passing the number as argument."

    ^ self to:stop by:step negated do:aBlock

    "
     10 downTo:1 by:2 do:[:i | Transcript showCR:i].
    "
!

downTo:stop do:aBlock
    "For each element of the interval from the receiver down to the argument stop,
     evaluate aBlock, passing the number as argument."

    ^ self to:stop by:-1 do:aBlock

    "
     10 downTo:1 do:[:i | Transcript showCR:i].
     $d downTo:$a do:[:i | Transcript showCR:i].
    "
!

to:stop by:incr do:aBlock
    "For each element of the interval from the receiver up to the argument stop, incrementing
     by step, evaluate aBlock passing the element as argument.

     Not all Magnitudes do implement #negative and #+ however, 
     so should this method go to ArithmethicValue?

     Only use #<, to speed up things (for subclasses only defining #<)"

    |tmp|

    tmp := self.
"using #negative would be more portable, but stc does only inline #< but not #negative (yet)"
"/    incr negative ifTrue:[
    incr < 0 ifTrue:[
        [tmp < stop] whileFalse:[
            aBlock value:tmp.
            tmp := tmp+incr
        ]
    ] ifFalse:[
        [stop < tmp] whileFalse:[
            aBlock value:tmp.
            tmp := tmp+incr
        ]
    ]

    "
     1 to:10 do:[:i | Transcript showCR:i].
     1 to:10 by:2 do:[:i | Transcript showCR:i].
     $a to:$z by:2 do:[:i | Transcript showCR:i].
     10 to:1 by:-1 do:[:i | Transcript showCR:i].
    "
!

to:stop by:incr doWithBreak:aBlock
    "For each element of the interval from the receiver up to the argument stop, incrementing
     by step, evaluate aBlock passing the element as argument.
     Pass a break argument, to allow for premature exit of the loop."

    |tmp break|

    break := [^ self].
    tmp := self.
"using #negative would be more portable, but stc does only inline #< but not #negative (yet)"
"/    incr negative ifTrue:[
    incr < 0 ifTrue:[
        [tmp < stop] whileFalse:[
            aBlock value:tmp value:break.
            tmp := tmp+incr
        ]
    ] ifFalse:[
        [stop < tmp] whileFalse:[
            aBlock value:tmp value:break.
            tmp := tmp+incr
        ]
    ]


    "
     1 to:100 by:5 doWithBreak:[:index :break |
        Transcript showCR:index printString.
        index > 50 ifTrue:[
            break value
        ].
     ]
    "
!

to:stop by:incr doWithExit:aBlock
    "For each element of the interval from the receiver up to the argument stop, incrementing
     by step, evaluate aBlock passing the element as argument.
     Pass a break argument, to allow for premature exit of the loop."

    |tmp exit|

    exit := [:exitValue | ^ exitValue].
    tmp := self.
"using #negative would be more portable, but stc does only inline #< but not #negative (yet)"
"/    incr negative ifTrue:[
    incr < 0 ifTrue:[
        [tmp < stop] whileFalse:[
            aBlock value:tmp value:exit.
            tmp := tmp+incr
        ]
    ] ifFalse:[
        [stop < tmp] whileFalse:[
            aBlock value:tmp value:exit.
            tmp := tmp+incr
        ]
    ]

    "
     1 to:100 by:5 doWithExit:[:index :exit |
        Transcript showCR:index printString.
        index > 50 ifTrue:[
            exit value:nil
        ].
     ]
    "
!

to:stop count:aBlock
    "same as (self to:stop) count:aBlock"

    |cnt|

    cnt := 0.
    self to:stop do:[:i |
       (aBlock value:i) ifTrue:[ cnt := cnt + 1 ].
    ].
    ^ cnt

    "
     1 to:10 count:[:n | n even]
    "
!

to:stop do:aBlock
    "For each element of the interval from the receiver up to the argument stop,
     evaluate aBlock, passing the number as argument."

    |tmp|

    tmp := self.
    [stop < tmp] whileFalse:[
        aBlock value:tmp.
        tmp := tmp+1
    ]

    "
     1 to:10 do:[:i | Transcript showCR:i].
     1 to:10 by:2 do:[:i | Transcript showCR:i].
     10 to:1 by:-1 do:[:i | Transcript showCR:i].
    "
!

to:stop doWithBreak:aBlock
    "For each element of the interval from the receiver up to the argument stop,
     evaluate aBlock, passing the number as argument.
     Pass a break argument, to allow for premature exit of the loop."

    |tmp break|

    break := [^ self].
    tmp := self.
    [stop < tmp] whileFalse:[
        aBlock value:tmp value:break.
        tmp := tmp+1
    ]

    "
     1 to:10 doWithBreak:[:index :break |
        Transcript showCR:index printString.
        index > 5 ifTrue:[
            break value
        ].
     ]
    "
!

to:stop doWithExit:aBlock
    "For each element of the interval from the receiver up to the argument stop,
     evaluate aBlock, passing the number as argument.
     Passes an additional exit object, which can be used to leave
     the loop early, by sending it a #value: message.
     Returns nil or the value passed to the exit>>value: message.

     Notice, that this is different to a return statement in the block, 
     which returns from the enclosed method, NOT only from the block."

    |exit tmp|

    exit := [:exitValue | ^exitValue].
    tmp := self.
    [stop < tmp] whileFalse:[
        aBlock value:tmp value:exit.
        tmp := tmp+1
    ].
    ^ nil

    "
     1 to:10 doWithExit:[:index :exit |
        index == 5 ifTrue:[
            exit value:nil
        ].
        Transcript showCR:index.
     ].
    "
! !

!Magnitude methodsFor:'testing'!

between:min and:max
    "return true if the receiver greater than or equal to the argument min
     and less than or equal to the argument max"

    (self < min) ifTrue:[^ false].
    (max < self) ifTrue:[^ false].
    ^ true

    "
     1.2 between:1 and:2
     (3/2) between:1 and:2
     (3/2) between:0 and:1
    "
!

in:anInterval
    "return whether the receiver is within the interval bounds"

    (self < anInterval start) ifTrue:[^ false].
    (anInterval stop < self)  ifTrue:[^ false].
    ^ true

    "
     1.2 in:(1 to: 2)
     (3/2) in:(1 to: 2)
     (3/2) in:(0 to: 1)
    "
! !

!Magnitude class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

