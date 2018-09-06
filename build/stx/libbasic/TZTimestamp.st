"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2014 by eXept Software AG
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

Timestamp subclass:#TZTimestamp
	instanceVariableNames:'utcOffset'
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Time'
!

!TZTimestamp class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by eXept Software AG
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
    This class represents time values in milliSeconds starting some time in the past,
    which were created in another (explicit) timezone.
    Internally, they keep the milliseconds based on UTC time (just like the other timestamps),
    so the time values can be compared easily.
    However, when printed, the original timezone information is taken into account.

    Also Note:
        On UNIX, osTime can only hold dates between 1970-01-01T00:00:00Z and 2038-01-19T00:00:00Z
        However, timestamp instances can hold negative osTime values (which are timestamps
        before 1.1.1970 and greater than 4294967295 (2^32-1) for timestamps after 2038-01-19.

    [example:]
      the current time as local time:
        Transcript showCR:Timestamp now

      the current time as utc time:       
        Transcript showCR:UtcTimestamp now.
      same:
        Transcript showCR:Timestamp now asUtcTimestamp.

      the current time in NewYork:         
        Transcript showCR:( Timestamp now asTZTimestamp:(Timestamp utcOffsetFrom:'EST') ) 
      same
        Transcript showCR:( Timestamp now asTZTimestampInZone:'EST' )
      same
        Transcript showCR:( Timestamp now asTZTimestamp:(5*3600) ) 

      what is the current time in Berlin:
        Transcript showCR:( Timestamp now asTZTimestampInZone:'MEZ' ) 
      and the date:
        Transcript showCR:( Timestamp now asTZTimestampInZone:'MEZ' ) asDate
      and the date in Tokio:
        Transcript showCR:( Timestamp now asTZTimestampInZone:'JST' ) asDate
      and the date in Hawai:
        Transcript showCR:( Timestamp now asTZTimestampInZone:'HAST' ) asDate

    [author:]
        Claus Gittinger

    [See also:]
        Timestamp UtcTimestamp Time Date
"
! !

!TZTimestamp class methodsFor:'instance creation'!

fromDate:aDate andTime:aTime utcOffset:utcOffsetSeconds
    "return an instance of the receiver, initialized from a time and a date
     object.
     See also `Timestamp now' and other protocol inherited
     from my superclass."

    ^ (self
        UTCYear:aDate year
        month:aDate month
        day:aDate day
        hour:aTime hours
        minute:aTime minutes
        second:aTime seconds + utcOffsetSeconds
        millisecond:aTime milliseconds)
            utcOffset:utcOffsetSeconds

    "
     Timestamp fromDate:(Date today) andTime:(Time now)
     Timestamp fromDate:(Date today) andTime:(Time nowWithMilliseconds)

     Timestamp fromDate:(Date today plusDays:1) andTime:(Time now)
     Timestamp now
    "
! !

!TZTimestamp methodsFor:'accessing'!

isLocalTimestamp
    ^ false
!

timeInfo
    "fake it. Convert to utc, ask OS for the info, then convert back.
     This is returns wrong info for weekday and we have to compensate again.
     Also, it (currently) only works for timestamps after the epoch"

    |ti|

    "/ utcOffset negative: east of GMT
    ti := OperatingSystem computeUTCTimeAndDateFrom:(osTime - ((utcOffset ? 0) * 1000)).
    ti utcOffset:(utcOffset ? 0).
    ^ ti
!

utcOffset
    "return the difference between UTC (Greenwich Mean Time) and the local time in seconds.
     If daylight saving time applies to ourself, take that into account.

     Add utcOffset to convert from local time to UTC time.
     Subtract utcOffset to convert from UTC time to local time.

     If utcOffset is negative, the local timezone is east of Greenwich.
     If utcOffset is positive, the local timezone is west of Greenwich."

    ^ utcOffset ? 0
!

utcOffset:seconds
    "set the difference between UTC (Greenwich Mean Time) and the local time in seconds.
     If daylight saving time applies to ourself, take that into account.

     Add utcOffset to convert from local time to UTC time.
     Subtract utcOffset to convert from UTC time to local time.

     If utcOffset is negative, the local timezone is east of Greenwich.
     If utcOffset is positive, the local timezone is west of Greenwich."

    utcOffset := seconds asInteger.

    "Modified: / 20-11-2014 / 13:05:48 / sr"
! !

!TZTimestamp methodsFor:'converting'!

asLocalTimestamp
    "return a local timestamp, representing the same time as the receiver"

    ^ Timestamp fromOSTime:osTime.
!

asTZTimestamp:utcOffsetArg
    "return a timestamp in a given timezone, representing the same time as the receiver"

    utcOffset = utcOffsetArg ifTrue:[
        ^ self.
    ].
    ^ super asTZTimestamp:utcOffsetArg

    "what is the time now in NewYork?
     Timestamp now asTZTimestamp:(Timestamp utcOffsetFrom:'EST') 

     what is the time now in Stuttgart?
     Timestamp now asTZTimestamp:(Timestamp utcOffsetFrom:'MEZ')  
    "
! !

!TZTimestamp methodsFor:'private'!

speciesNew
    ^ self species basicNew 
        utcOffset:(utcOffset ? 0);
        yourself
!

storeStringClass
    ^ Timestamp
! !

!TZTimestamp class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/TZTimestamp.st,v 1.12 2015-06-06 12:42:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/TZTimestamp.st,v 1.12 2015-06-06 12:42:27 cg Exp $'
! !

