"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Timestamp subclass:#DateAndTime
	instanceVariableNames:'offset'
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Time'
!

!DateAndTime class methodsFor:'documentation'!

documentation
"
    basically, this is an alias for Timestamp for compatibility with other Smalltalks.
    Do not use unless portability is absolutely required (actually, most other smalltalks
    do have a Timestamp class as well)
"
! !

!DateAndTime class methodsFor:'instance creation'!

year: year month: month day: day hour: hour minute: minute second: second offset:timeDuration
    ^ (self year: year month: month day: day hour: hour minute: minute second: second)
        offset:timeDuration
! !

!DateAndTime methodsFor:'accessing'!

monthIndex
    ^ self asDate monthIndex
!

offset
    ^ offset
!

offset:something
    offset := something.
! !

!DateAndTime methodsFor:'converting'!

asUTC
    ^ offset isZero
        ifTrue:[ self ]
        ifFalse:[ self utcOffset:0 ]
!

utcOffset:anOffset
   "answer a DateTime equivalent to the receiver but offset from UTC by offset"

    ^ self class new 
        osTime:osTime;
        offset:(anOffset asDuration - self offset)  
! !

!DateAndTime class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/DateAndTime.st,v 1.3 2015-10-28 09:20:44 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/DateAndTime.st,v 1.3 2015-10-28 09:20:44 stefan Exp $'
! !

