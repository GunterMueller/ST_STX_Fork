"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2011 by eXept Software AG
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

Timestamp subclass:#UtcTimestamp
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Time'
!

!UtcTimestamp class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    This is a Timestamp, that represents itself as UTC.
    Internally it stores exactly the same value as Timestamp, 
    so the following expression is always true:

        someTimestamp asUtcTimestamp = someTimestamp asLocalTimestamp

    But when printing, accessing hour, minute, ... and converting to Date and Time,
    it returns the values represented in the UTC zone instead of the local timezone.
    Be aware that this may lead to interesting results; for example when converting a timestamp
    to a date, you may get a different date from an UTCTimestamp and a local timestamp.

    [author:]
        Stefan Vogel (stefan@zwerg.nil.exept.de)

    [instance variables:]

    [class variables:]

    [see also:]
        Time Date

"
! !

!UtcTimestamp methodsFor:'accessing'!

timeInfo
    ^ self utcTimeInfo
!

timeZoneName
    ^ 'UTC'
!

utcOffset
    "I am an UTC timestamp, so there is no offset"
    
    ^ 0
!

utcOffsetWithoutDst
    ^ 0
! !

!UtcTimestamp methodsFor:'converting'!

asLocalTimestamp
    "represent myself as a timestamp in the local timezone"

    ^ Timestamp fromOSTime:osTime
!

asUtcTimestamp
    "I am an UtcTimestamp"

    ^ self
! !

!UtcTimestamp methodsFor:'initialization'!

setOSTimeFromYear:y month:m day:d hour:h minute:min second:s millisecond:millis 
    "private: ask the operating system to compute the internal osTime (based on the epoch),
     given y,m,d and h,m,s in utc time"

   self setOSTimeFromUTCYear:y month:m day:d hour:h minute:min second:s millisecond:millis

    "
     UtcTimestamp now            
     Timestamp now              
     Timestamp now asTZTimestamp             
     Timestamp now asUtcTimestamp  
    "

    "Modified (comment): / 13-10-2011 / 22:05:41 / cg"
! !

!UtcTimestamp methodsFor:'private'!

storeStringClass
    ^ Timestamp
! !

!UtcTimestamp methodsFor:'testing'!

isLocalTimestamp
    "return true, if I am a local timestamp"

    ^ false
!

isUtcTimestamp
    "return true, if I am a utc timestamp"

    ^ true
! !

!UtcTimestamp methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitUtcTimestamp:with: to aVisitor."

    ^ aVisitor visitUtcTimestamp:self with:aParameter
! !

!UtcTimestamp class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/UtcTimestamp.st,v 1.16 2015-06-06 12:42:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/UtcTimestamp.st,v 1.16 2015-06-06 12:42:18 cg Exp $'
! !

