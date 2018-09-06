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

AbstractTime subclass:#Timestamp
	instanceVariableNames:'osTime'
	classVariableNames:'Epoch MaxOSTime MinOSTime TimeZoneInfo'
	poolDictionaries:''
	category:'Magnitude-Time'
!

Object subclass:#TimestampBuilderAbstract
	instanceVariableNames:'year month day hour minute second millisecond isUtcTime
		hasTimezone yearAlreadyRead utcOffset'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Timestamp
!

Timestamp::TimestampBuilderAbstract subclass:#TimestampISO8601Builder
	instanceVariableNames:'stream'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Timestamp
!

!Timestamp class methodsFor:'documentation'!

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
    This class represents time values in milliSeconds starting some time in the past.
    When printing and accessing values like #hour,
    the timestamp will be interpreted in the local timezone
    (as opposed to UtcTimestamp, which presents itself in UTC,
     and as opposed to TZTimestamp, which remembers the timezone in which it was created).

    The internal representation, osTime, will typically start with 1970-01-01 0:00,
    as used in the Unix operating system, but other systems may bias the time differently.
    Actually, the implementation does not depend or even know which time/date
    the OperatingSystem bases its time upon - it is simply keeping the value(s)
    as returned from the OS.
    For conversion, these values are given back to the OS, which will know
    how to convert these times. This has the advantage, that timestamps on files
    (such as last-access-time or last-modification-time) can be handled transparently -
    especially when performing comparisons.

    You should not interpret the osTime instance variable directly,
    instead (if at all), ask the OS to convert.

    The implementation of this class is not the same as in ST-80
    (which represents the time as seconds from Jan 1., 1901).

    This class should not be confused with Time (which only represents the
    time within one day). Time instances cannot be used to compare times across midnight;
    instances of Timestamp can.

    Notice: this class was once called AbsoluteTime. Einstein told us in 1905, that talking
    about a absolute time is not a good idea (at least in our universe). So the class
    has been renamed to Timestamp which makes us more compatible to other ST dialects (e.g. VW)
    AbsoluteTime is still kept as an alias for backward compatibility.

    Also Note:
        On UNIX, osTime can only hold dates between 1970-01-01T00:00:00Z and 2038-01-19T00:00:00Z
        However, timestamp instances can now hold negative osTime values (which are timestamps
        before 1.1.1970 and greater than 4294967295 (2^32-1) for timestamps after 2038-01-19.

        For dates before 1582 (when calendars were changed from Julian to Grgorian),
        the so called 'proleptic gregorian calendar' is used. This assumes leap years to continue in
        the past as if a gregorian calendar was used. Thus, 0000 is considered a leap year.

    [author:]
        Claus Gittinger

    [See also:]
        UtcTimestamp Time Date
        Delay ProcessorScheduler
"
! !

!Timestamp class methodsFor:'initialization'!

initialize
    MinOSTime := OperatingSystem epochStartOSTime.
    MaxOSTime := OperatingSystem epochEndOSTime.

    Epoch := UtcTimestamp basicNew setSeconds:0.

    "Modified: / 19-01-2017 / 17:01:59 / stefan"
! !

!Timestamp class methodsFor:'instance creation'!

UTCYear:y month:m day:d hour:h minute:min second:s millisecond:millis
    "return an instance of the receiver, given individual components,
     interpreted in the UTC timezone."

    ^ self basicNew
	    UTCyear:y month:m day:d hour:h minute:min second:s millisecond:millis

    "
     Timestamp UTCYear:1970 month:1 day:1 hour:0 minute:0 second:0 millisecond:0
     Timestamp UTCYear:1991 month:1 day:2 hour:12 minute:30 second:0 millisecond:0
     Timestamp UTCYear:1991 month:1 day:2 hour:12 minute:30 second:0 millisecond:100
     Timestamp UTCYear:1999 month:7 day:1 hour:1 minute:0 second:0 millisecond:0
     Timestamp UTCYear:2000 month:1 day:1 hour:1 minute:0 second:0 millisecond:0

     UtcTimestamp UTCYear:2000 month:1 day:1 hour:1 minute:0 second:0 millisecond:0
    "

    "Modified: / 1.7.1996 / 15:22:07 / cg"
    "Created: / 13.7.1999 / 12:34:37 / stefan"
    "Modified: / 13.7.1999 / 12:42:30 / stefan"
!

decodeFromLiteralArray:anArray
    "decode a Timestamp literalArray.

     anArray may be:
        #(Timestamp '200004182000.123')

     or the deprecated old format, that is not portable between different architectures.
     We parse this for backward compatibility (will be eventually removed).

        #(Timestamp #osTime: 12345678)
    "

    (anArray at:2) == #osTime: ifTrue:[
        ^ self new osTime:(anArray at:3).
    ].

    ^ self
        readGeneralizedFrom:(anArray at:2)
        onError:[ self conversionErrorSignal
                    raiseWith:anArray errorString:' - Timestamp literal array decoding' ]

    "
     Timestamp
        decodeFromLiteralArray:#(Timestamp '20050323175226.014')
     Timestamp
        decodeFromLiteralArray:#(Timestamp '20050323175226.014-01')
     Timestamp
        decodeFromLiteralArray:#(Timestamp '20050323175226.014Z')
    "
!

epoch
    "the epoch is based to 0 for 1970-01-01 00:00:00.
     However, we allow negative values to represent timestamps before that"

    ^ Epoch
!

fromDate:aDate
    "return an instance of the receiver, initialized from a time and a date
     object.
     See also `Timestamp now' and other protocol inherited
     from my superclass."

    ^ self
	year:aDate year
	month:aDate month
	day:aDate day
	hour:0
	minute:0
	second:0
	millisecond:0

    "
     Timestamp fromDate:(Date today) andTime:(Time now)
     Timestamp fromDate:(Date today plusDays:1) andTime:(Time now)
     Timestamp now
    "

    "Modified: / 8.9.1995 / 15:07:30 / claus"
    "Modified: / 19.4.1996 / 15:25:46 / cg"
    "Modified: / 13.7.1999 / 12:30:47 / stefan"
!

fromDate:aDate andTime:aTime
    "return an instance of the receiver, initialized from a time and a date
     object.
     See also `Timestamp now' and other protocol inherited
     from my superclass."

    ^ self
	year:aDate year
	month:aDate month
	day:aDate day
	hour:aTime hours
	minute:aTime minutes
	second:aTime seconds
	millisecond:aTime milliseconds

    "
     Timestamp fromDate:(Date today) andTime:(Time now)
     Timestamp fromDate:(Date today) andTime:(Time nowWithMilliseconds)

     Timestamp fromDate:(Date today plusDays:1) andTime:(Time now)
     Timestamp now
    "

    "Modified: / 8.9.1995 / 15:07:30 / claus"
    "Modified: / 19.4.1996 / 15:25:46 / cg"
    "Modified: / 13.7.1999 / 12:30:47 / stefan"
!

newDay:dayInYear year:year
    "return a new Timestamp, given the year and the day-in-year (starting at 1).
     Date protocol compatibility"

    ^ self fromDate:(Date newDay:dayInYear year:year)

    "
     Timestamp newDay:183 year:1996
     Timestamp newDay:1 year:1996
    "

    "Modified: 2.7.1996 / 09:39:30 / cg"
!

secondsSince1970:secs
    "set time from elapsed seconds since 1-1-1970, 00:00:00.
     This is the format used in the UNIX world"

    ^ self basicNew setSeconds:secs.

    "
     Timestamp secondsSince1970:0
     Timestamp secondsSince1970:3600
     Timestamp secondsSince1970:3600*24
     (Timestamp year:2010 month:7 day:1 hour:0 minute:0 second:0)
       =
     (Timestamp secondsSince1970:1277935200)
    "

    "Created: / 21-10-1996 / 17:48:30 / stefan"
    "Modified: / 13-07-1999 / 12:31:22 / stefan"
    "Modified: / 08-01-2011 / 16:06:28 / cg"
!

utcMillisecondsSince1970:secs
    "set time from elapsed milliseconds since the epoch 1-1-1970, 00:00:00."

    ^ self basicNew setMilliseconds:secs

    "Created: / 08-01-2011 / 16:09:32 / cg"
!

utcNow
    "return now as utc timestamp"

    ^ UtcTimestamp now

    "
     Timestamp now
     Timestamp utcNow
    "
!

utcSecondsSince1970:secs
    "set time from elapsed seconds since 1-1-1970, 00:00:00.
     This is the format used in the UNIX world"

    ^ self secondsSince1970:secs

"/    |divMod|
"/
"/    divMod := secs divMod:3600.
"/    ^ self year:1970 month:1 day:1 hour:(divMod at:1) minute:0 second:(divMod at:2) millisecond:0.

    "
     Timestamp secondsSince1970:0
     Timestamp secondsSince1970:3600
     Timestamp secondsSince1970:3600*24
    "

    "Modified: / 13-07-1999 / 12:31:22 / stefan"
    "Created: / 08-01-2011 / 16:05:09 / cg"
!

year:year month:month day:day  
    "return a new Timestamp, given the year, month and day (starting at 1).
     Date protocol compatibility"

    ^ self
        year:year
        month:month
        day:day
        hour:0
        minute:0
        second:0
        millisecond:0

    "
     Timestamp year:1996 month:1 day:1 
    "
!

year:y month:m day:d hour:h minute:min second:s
    "return an instance of the receiver, given individual components.
     See also `Timestamp now' and other protocol inherited
     from my superclass."

    ^ self year:y month:m day:d hour:h minute:min second:s millisecond:0

    "
     Timestamp year:1970 month:1 day:1 hour:1 minute:0 second:0
     Timestamp year:1991 month:1 day:2 hour:12 minute:30 second:0
     Timestamp year:1991 month:1 day:2 hour:12 minute:30 second:0 millisecond:100
     Timestamp year:2000 month:7 day:1 hour:1 minute:0 second:0
     Timestamp year:2080 month:7 day:1 hour:1 minute:0 second:0
    "

    "Modified: / 1.7.1996 / 15:22:07 / cg"
    "Created: / 13.7.1999 / 12:06:39 / stefan"
    "Modified: / 13.7.1999 / 12:27:47 / stefan"
!

year:y month:m day:d hour:h minute:min second:s millisecond:millis
    "return an instance of the receiver, given individual components.
     See also `Timestamp now' and other protocol inherited
     from my superclass."

    ^ self basicNew
	    year:y month:m day:d hour:h minute:min second:s millisecond:millis
    "
     Timestamp year:1970 month:1 day:1 hour:0 minute:0 second:0
     Timestamp year:1991 month:1 day:2 hour:12 minute:30 second:0
     Timestamp year:1991 month:1 day:2 hour:12 minute:30 second:0 millisecond:100
     Timestamp year:2000 month:7 day:1 hour:1 minute:0 second:0
     UtcTimestamp year:2000 month:7 day:1 hour:1 minute:0 second:0
    "

    "Modified: / 1.7.1996 / 15:22:07 / cg"
    "Created: / 13.7.1999 / 12:28:44 / stefan"
    "Modified: / 13.7.1999 / 12:37:57 / stefan"
! !

!Timestamp class methodsFor:'Compatibility-Squeak'!

current
    ^ self now
!

readFrom:aStringOrStream
    "Answer a new instance for the value given by aStringOrStream"

    ^ self
        readFrom:aStringOrStream
        onError:[ TimeConversionError raiseRequestWith:aStringOrStream errorString:' - timestamp']

    "
     self readFrom:'23-jun-2000 15:00'
     self fromString:'23-jun-2000 15:00'
     self readFrom:'23-jun-2000 '
    "

    "Modified (comment): / 20-08-2011 / 16:52:10 / cg"
!

year: year month: month day: day hour: hour minute: minute second: second millisecond: millisecond offset:timeDuration
    ^ (UtcTimestamp year: year month: month day: day hour: hour minute: minute second: second millisecond: millisecond)
        utcOffset:timeDuration

    "
     Timestamp year:2015 month:11 day:9 hour:12 minute:0 second:0 millisecond:0 offset:(2 hours)
    "
!

year: year month: month day: day hour: hour minute: minute second: second offset:timeDuration
    ^ (UtcTimestamp year: year month: month day: day hour: hour minute: minute second: second)
        utcOffset:timeDuration

    "
     Timestamp year:2015 month:11 day:9 hour:12 minute:0 second:0 offset:(2 hours)
    "
! !

!Timestamp class methodsFor:'format strings'!

defaultFormatString
    "a format string to present times in user interfaces.
     Do not use this to store/retrieve times (use ISO8601 for that).
     Although the string below looks like ISO8601, it does not include TZ information,
     so when read back, it will always be interpreted as a local timestamp."

    ^ '%(year)-%(month)-%(day) %h:%m:%s.%i'

    "Created: / 16-01-2011 / 11:23:36 / cg"
! !

!Timestamp class methodsFor:'obsolete'!

day:d month:m year:y hour:h minutes:min seconds:s
    <resource: #obsolete>
    "This is obsolete. User #year:month:day:hour:minute:second:"

    ^ self
	year:y month:m day:d hour:h
	minute:min second:s millisecond:0


    "Modified: / 1.7.1996 / 15:22:26 / cg"
    "Modified: / 13.7.1999 / 12:29:56 / stefan"
!

day:d month:m year:y hour:h minutes:min seconds:s milliseconds:millis
    <resource: #obsolete>
    "This is obsolete. User #year:month:day:hour:minute:second:millisecond:"

    ^ self year:y month:m day:d hour:h minute:min second:s millisecond:millis

    "
     Timestamp day:1 month:1 year:1970 hour:1 minute:0 second:0
     Timestamp day:2 month:1 year:1991 hour:12 minute:30 second:0
     Timestamp day:2 month:1 year:1991 hour:12 minute:30 second:0 millisecond:100
    "

    "Created: / 1.7.1996 / 14:46:09 / cg"
    "Modified: / 1.7.1996 / 15:22:07 / cg"
    "Modified: / 13.7.1999 / 12:30:26 / stefan"
!

newDay:day month:month year:year
    <resource: #obsolete>
    "return a new Timestamp, given the year, month and day (starting at 1).
     Date protocol compatibility"

    ^ self
	year:year
	month:month
	day:day
	hour:0
	minute:0
	second:0
	millisecond:0

    "
     Timestamp newDay:1 month:1 year:1996
    "
! !


!Timestamp class methodsFor:'private'!

basicReadFrom:aStream
    "return a new Timestamp, reading a printed representation from aStream.
     The string is interpreted as 24 hour format, as printed.

     Notice, that this is NOT the storeString format, which is iso8601
     This is more or less a heuristic attempt to read any reasonable format.
     If the input starts with an integer > 31,
     it is assumed to be a year and the rest is read in iso8601 format.

     KLUDGE:
        us and non-us format have different ordering of day and month;
        The format read here is (non-us) dd-mm-yyyy hh:mm:ss.iii
        or (us-format, for Travis) mm/dd/yyyy hh:mm:ss.iii.
     On error, raise an exception"

    |monthOrYear firstNumber secondNumber day month year hour min sec millis usFormat possibeMonthName ch utcOffsetOrNil count|

    count := 0.
    monthOrYear := aStream throughAnyForWhich:[:ch | count := count+1. ch isDigit and:[count <= 4]].
    firstNumber := Integer readFrom:monthOrYear onError:[TimeConversionError raiseErrorString:' - integer expected'].
    firstNumber > 31 ifTrue:[
        "/ assume iso8601 format;
        ^ self readIso8601FormatFrom:aStream yearAlreadyRead:firstNumber.
    ].
    aStream skipSeparators.

    "/ consider this a kludge
    usFormat := (aStream peek == $/ ).

    [(ch := aStream peekOrNil) notNil and:[ch isLetterOrDigit]] whileFalse:[aStream next].
    (ch notNil and:[ch isDigit]) ifTrue:[
        secondNumber := Integer readFrom:aStream onError:-1.

        usFormat ifTrue:[
            month := firstNumber.
            day := secondNumber.
        ] ifFalse:[
            month := secondNumber.
            day := firstNumber.
        ].
    ] ifFalse:[
        possibeMonthName := aStream throughAnyForWhich:[:ch | ch isLetter].
        month := Date indexOfMonth:possibeMonthName asLowercase.
        day := firstNumber.
    ].

    (day between:1 and:31) ifFalse:[ TimeConversionError raiseErrorString:' - bad day' ].
    (month between:1 and:12) ifFalse:[ TimeConversionError raiseErrorString:' - bad month' ].

    [(ch := aStream peekOrNil) notNil and:[ch isDigit not]] whileTrue:[aStream next].
    year := Integer readFrom:aStream onError:[ TimeConversionError raiseErrorString:' - bad year' ].

    aStream atEnd ifTrue:[
        hour := min := sec := millis := 0.
    ] ifFalse:[
        [(ch := aStream peekOrNil) notNil and:[ch isDigit not]] whileTrue:[aStream next].
        hour := Integer readFrom:aStream onError:-1.
        (hour between:0 and:24) ifFalse:[ TimeConversionError raiseErrorString:' - bad hour' ].

        [(ch := aStream peekOrNil) notNil and:[ch isDigit not]] whileTrue:[aStream next].
        min := Integer readFrom:aStream onError:-1.
        (min between:0 and:59) ifFalse:[ TimeConversionError raiseErrorString:' - bad minute' ].

        aStream atEnd ifTrue:[
            sec := millis := 0.
        ] ifFalse:[
            [(ch := aStream peekOrNil) notNil and:[ch isDigit not]] whileTrue:[aStream next].
            sec := Integer readFrom:aStream onError:-1.
            (sec between:0 and:59) ifFalse:[ TimeConversionError raiseErrorString:' - bad second' ].

            aStream peek == $. ifTrue:[
                aStream next.
                millis := Integer readFrom:aStream onError:0.
                millis >= 1000 ifTrue:[ TimeConversionError raiseErrorString:' - bad millisecond' ].
            ] ifFalse:[
                millis := 0.
            ].
            aStream atEnd ifFalse:[
                utcOffsetOrNil := self utcOffsetFrom:aStream
            ].
        ].
    ].

    "special check - only 24:00:00 is allowed;
     every time after that must wrap"
    hour == 24 ifTrue:[
        (min ~~ 0 or:[sec ~~ 0 or:[millis ~~ 0]]) ifTrue:[ TimeConversionError raiseErrorString:' - bad hour' ].
    ].
    utcOffsetOrNil notNil ifTrue:[
        utcOffsetOrNil = 0 ifTrue:[
            "/ utc timestamp
            ^ UtcTimestamp year:year month:month day:day hour:hour minute:min second:sec millisecond:millis
        ].
        ^ TZTimestamp new 
                UTCyear:year month:month day:day hour:hour minute:min second:sec millisecond:millis;
                utcOffset:utcOffsetOrNil;
                addSeconds:utcOffsetOrNil.
    ].
    "/ a local timestamp
    ^ self year:year month:month day:day hour:hour minute:min second:sec millisecond:millis.

    "some ad hoc formats:

     Timestamp basicReadFrom:'20-2-1995 13:11:06' readStream
     Timestamp basicReadFrom:'20-2-1995 13:11:06.' readStream
     Timestamp basicReadFrom:'20-feb-1995 13:11:06' readStream
     Timestamp basicReadFrom:'20-foo-1995 13:11:06' readStream
     (Timestamp basicReadFrom:'10-9-1995 13:11:06' readStream) month    - european
     (Timestamp basicReadFrom:'10/9/1995 13:11:06' readStream) month    - us
     Timestamp basicReadFrom:'20-2-1995 13:11' readStream
     Timestamp basicReadFrom:'20-2-1995 13:11:06.100' readStream
     Timestamp basicReadFrom:'20-2-1995 13:11:06.100 MESZ' readStream
     Timestamp basicReadFrom:'20-2-1995 13:11:06.100+0200' readStream
     Timestamp basicReadFrom:'32-2-1995 13:11:06.100' readStream
     Timestamp basicReadFrom:'32-foo-1995 13:11:06.100' readStream
     Timestamp basicReadFrom:'20-13-1995 13:11:06.100' readStream
     Timestamp basicReadFrom:'20-12-1995 25:11:06.100' readStream
     Timestamp basicReadFrom:'20-12-1995 23:61:06.100' readStream
     Timestamp basicReadFrom:'20-12-1995 23:10:66.100' readStream
     Timestamp basicReadFrom:'20-12-1995 23:10:00.1000' readStream
     Timestamp basicReadFrom:'20-2-1995 24:01:00.100' readStream
     Timestamp basicReadFrom:'20-2-1995 24:00:01.100' readStream
     Timestamp basicReadFrom:'foo' readStream

     any iso8601 format:.
     Timestamp basicReadFrom:(Timestamp now printString readStream)
     Timestamp basicReadFrom:'1995-10-20 24:00:00.000' readStream
     Timestamp basicReadFrom:'1995-10-20 12:10:00.000' readStream
     Timestamp basicReadFrom:'1995-10-20 12:10:00.000-0200' readStream

     UtcTimestamp basicReadFrom:'1995-10-20 12:10:00.000' readStream
    "
!

readIso8601FormatFrom:aStringOrStream yearAlreadyRead:yearOrNil
    "common helper for read methods.
     Return a new Timestamp, reading an iso8601 representation from aStream.

     If the time ends with a 'Z' it is the UTC (or zulu) time,
     otherwise it is local time.

     Missing month/day values are replaced with 1; i.e. 1999T24:00
     is the same as 1999-01-01T24:00:00.
     Missing minute, second and ms values are replaced with 0;
     i.e. 1999T12 is the same as 1999-01-01T12:00:00.000.
     Partial hours, minutes, seconds are allowed at the end,
     decimal separators are both $. and $, .
     Of course, a 24 hour clock is used.
     On error, raise an exception.
     Please use this format for all external representations - it's the standard."

    "/ changed to use the new reader
    ^ TimestampISO8601Builder
	read:aStringOrStream withClass:self
	yearAlreadyReadAs:yearOrNil

"/    |str day month dayInWeek week year hour min sec tmpDay millis fraction isUtcTime peekChar ch|
"/
"/    str := aStringOrStream readStream.
"/
"/    month := day := 1.
"/    hour := millis := 0.
"/    isUtcTime := false.
"/
"/    yearOrNil notNil ifTrue:[
"/        year := yearOrNil
"/    ] ifFalse:[
"/        year := Integer readFrom:str onError:nil.
"/        year isNil ifTrue:[ TimeConversionError raiseErrorString:' - bad year' ]
"/    ].
"/
"/    str skipSeparators.
"/    (((ch := str peek) == $-) or:[ch == $W]) ifTrue:[
"/        (ch == $-) ifTrue:[ str next ].
"/        str peek == $W ifTrue:[
"/            str next.
"/
"/            "/ week follows
"/            week := Integer readFrom:str onError:-1.
"/            (week between:1 and:53) ifFalse:[ TimeConversionError raiseErrorString:' - bad week' ].
"/
"/            str skipSeparators.
"/            str peek == $- ifTrue:[
"/                str next.
"/                "/ day follows.
"/                dayInWeek := Integer readFrom:str onError:-1.
"/                (dayInWeek between:1 and:7) ifFalse:[ TimeConversionError raiseErrorString:' - bad day in week' ].
"/            ] ifFalse:[
"/                dayInWeek := 1.
"/            ].
"/            tmpDay := Date newDayInWeek:dayInWeek week:week year:year.
"/            day := tmpDay day.
"/            month := tmpDay month.
"/            year := tmpDay year.
"/        ] ifFalse:[
"/            "/ month follows.
"/            month := Integer readFrom:str onError:-1.
"/            (month between:1 and:12) ifFalse:[ TimeConversionError raiseErrorString:' - bad month' ].
"/
"/            str skipSeparators.
"/            str peek == $- ifTrue:[
"/                str next.
"/                "/ day follows.
"/                day := Integer readFrom:str onError:-1.
"/                (day between:1 and:31) ifFalse:[ TimeConversionError raiseErrorString:' - bad day' ].
"/            ].
"/        ].
"/    ].
"/
"/    str skipSeparators.
"/    str atEnd ifFalse:[
"/        "time follows"
"/
"/        str peek == $T ifTrue:[
"/            "we treat the T as optional here"
"/            str next.
"/            str skipSeparators.
"/        ].
"/        hour := Integer readFrom:str onError:-1.
"/        (hour between:0 and:24) ifFalse:[ TimeConversionError raiseErrorString:' - bad hour' ].
"/        str skipSeparators.
"/        str peekOrNil == $: ifTrue:[
"/            str next.
"/            "/ minutes follow.
"/            min := Integer readFrom:str onError:-1.
"/            (min between:0 and:59) ifFalse:[ TimeConversionError raiseErrorString:' - bad minute' ].
"/            str skipSeparators.
"/            str peekOrNil == $: ifTrue:[
"/                str next.
"/                "/ seconds follow.
"/                sec := Integer readFrom:str onError:-1.
"/                (sec between:0 and:59) ifFalse:[ TimeConversionError raiseErrorString:' - bad seconds' ].
"/                str skipSeparators.
"/            ].
"/        ].
"/
"/        peekChar := str peekOrNil.
"/        (peekChar == $. or:[peekChar == $,]) ifTrue:[
"/            str next.
"/            "/ decimals follow.
"/            fraction := Number readMantissaFrom:str radix:10.
"/            min isNil ifTrue:[
"/                min := 60 * fraction.
"/                fraction := min fractionPart.
"/                min := min truncated.
"/            ].
"/            (sec isNil and:[fraction ~= 0])ifTrue:[
"/                sec := 60 * fraction.
"/                fraction := sec fractionPart.
"/                sec := sec truncated.
"/            ].
"/            fraction ~= 0 ifTrue:[
"/                millis := (1000 * fraction) rounded.  "/ mhmh - should it be truncated ?
"/            ].
"/        ].
"/
"/        peekChar := str peekOrNil.
"/        peekChar notNil ifTrue:[
"/            peekChar == $Z ifTrue:[
"/                str next.
"/                isUtcTime := true.
"/            ] ifFalse:[
"/                ((peekChar == $+) or:[peekChar == $- ]) ifTrue:[
"/                    str next.
"/                    self halt.
"/                    isUtcTime := true.
"/                ]
"/            ]
"/        ].
"/    ].
"/
"/    min isNil ifTrue:[min := 0].
"/    sec isNil ifTrue:[sec := 0].
"/
"/    "special check - only 24:00:00 is allowed;
"/     every time after that must wrap"
"/    hour == 24 ifTrue:[
"/        (min ~~ 0 or:[sec ~~ 0 or:[millis ~~ 0]]) ifTrue:[ TimeConversionError raiseErrorString:' - bad hour' ].
"/    ].
"/
"/    isUtcTime ifTrue:[
"/        ^ self
"/            UTCYear:year month:month day:day
"/            hour:hour minute:min second:sec millisecond:millis.
"/    ] ifFalse:[
"/        ^ self
"/            year:year month:month day:day
"/            hour:hour minute:min second:sec millisecond:millis.
"/    ]

    "
     Timestamp readIso8601FormatFrom:'1995-02-20T13:11:06.123'
     Timestamp readIso8601FormatFrom:'1995-02-20T13:11:06'
     Timestamp readIso8601FormatFrom:'1995-02T13:11:06'
     Timestamp readIso8601FormatFrom:'1995T13:11:06'
     Timestamp readIso8601FormatFrom:'1995T13:11'
     Timestamp readIso8601FormatFrom:'1995T13:11.5'
     Timestamp readIso8601FormatFrom:'1995T13:11,5'
     Timestamp readIso8601FormatFrom:'1995T13'
     Timestamp readIso8601FormatFrom:'1995T13.25'
     Timestamp readIso8601FormatFrom:'1995T13.333333'
     Timestamp readIso8601FormatFrom:'1995'

     Timestamp readIso8601FormatFrom:'2014W40'   -> 29.sep.2014
     Timestamp readIso8601FormatFrom:'2014W44-4' -> 30.oct.2014
     Timestamp readIso8601FormatFrom:'2014W1'    -> 30.dec.2013      !!!!!! (this week starts in the previous year)
     Timestamp readIso8601FormatFrom:'2014W1-1'  -> same 30.dec.2013 !!!!!! (this week starts in the previous year)
     Timestamp readIso8601FormatFrom:'2014W1-2'  -> 31.dec.2013      !!!!!! (this week starts in the previous year)
     Timestamp readIso8601FormatFrom:'2014W1-3'  -> 1.jan.2014       !!!!!! (this week starts in the previous year)

     Timestamp readIso8601FormatFrom:'1995-02-20 13:11:06'
     Timestamp readIso8601FormatFrom:'1995-02-20 13:11:06Z'

     Timestamp readIso8601FormatFrom:'1995-02-20 13:11'
     Timestamp readIso8601FormatFrom:'1995-02-20 13'

   24 is allowed with ISO, and is 00:00 of the next day:
     Timestamp readIso8601FormatFrom:'1995-02-20 24:00:00'
    "
!

readIso8601FormatFrom:aStringOrStream yearAlreadyRead:yearOrNil onError:exceptionValue
    "common helper for read methods."

    |retVal|

    ConversionError handle:[:ex |
	retVal := exceptionValue value
    ] do:[
	retVal := self readIso8601FormatFrom:aStringOrStream yearAlreadyRead:yearOrNil
    ].
    ^ retVal
! !

!Timestamp class methodsFor:'reading'!

readFrom:aStringOrStream format:formatString language:languageOrNil onError:exceptionalValue
    "return a new Timestamp, reading a printed representation from aStream using a formatString.
     The formatString is similar to the one used when printing.
     On error, exceptionalValue is returned.
     If exceptionalValue is a one-arg block, an error message is passed as argument.
     Format:
        %h      hours, 00..23 (i.e. european)  0-padded to length 2
        %u      hours, 00..12 (i.e. us)        0-padded to length 2
        %m      minutes, 00..59                0-padded to length 2
        %s      seconds, 00..59                0-padded to length 2
        %i      milliseconds, 000..999         0-padded to length 3
        %f      fractional seconds             any length, but only milliseconds kept
        %a      am/pm

        %d             - day
        %D             - day
        %(day)         - day
        %(dayOfYear)   - 1..365/366

        %(month)       - month

        %(monthName)   - monthName

        %(year)        - year, full 4 digits
        %Y             - year, last 2 digits only,
                         0..71 map to 2000..2071;
                         72..99 map to 1972..1999;
        %Y1900          - year, last 2 digits only, map to 1900..1999
        %Y2000          - year, last 2 digits only, map to 2000..2099
        %Y1950          - year, last 2 digits only, map to 1950..2049
        %Y1980          - year, last 2 digits only, map to 1980..2079

     an optional length after the % gives a field length;
        i.e. %2h%2m%2s parses '123557' as 12:35:37
        and '%4(year)%2(month)%2(day)' parses '20060620' as 2006-06-20 00:00:00

     Please consider using a standard format, such as iso8601.
    "

    |day month year dayOfYear monthAndDay
     hour minute second millisecond
     utcOffset inStream formatStream error fChar format itemHandler
     len now s fractionString fraction|

    error := [:msg |
                exceptionalValue isBlock ifTrue:[
                    ^ exceptionalValue valueWithOptionalArgument:'format error'
                ] ifFalse:[
                    ^ exceptionalValue value
                ].
             ].

    itemHandler := [:format |
        |input|
        
        input := len isNil ifTrue:[ inStream ] ifFalse:[ inStream next: len ].

        ( #('d' 'D' 'day' ) includes:format ) ifTrue:[
            day := Integer readFrom:input onError:[ error value:'invalid day' ].

        ] ifFalse:[ ( format = 'month' ) ifTrue:[
            month := Integer readFrom:input onError:[ error value:'invalid month' ].

        ] ifFalse:[ ( format = 'year' or:[ format = 'y' ]) ifTrue:[
            year := Integer readFrom:input onError:[ error value:'invalid year' ].

        ] ifFalse:[ ( format = 'Y' ) ifTrue:[
            year := Integer readFrom:input onError:[ error value:'invalid year' ].
            (year between:0 and: 99) ifFalse:[ error value:'invalid year' ].
            (year < 70) ifTrue:[
                year := year + 2000
            ] ifFalse:[
                year := year + 1900
            ]

        ] ifFalse:[ (format = 'monthName') ifTrue:[
            s := input nextMatching:[:c | c isLetter] thenMatching:[:c | c isLetter].
            month := Date indexOfMonth:s asLowercase language:languageOrNil

        ] ifFalse:[ (format = 'dayOfYear') ifTrue:[
            dayOfYear := Integer readFrom:input onError:[ error value:'invalid day of year' ].

        ] ifFalse:[ ( format sameAs: 'Y1900' ) ifTrue:[
            year := Integer readFrom:input onError:[ error value:'invalid year' ].
            (year between:0 and: 99) ifFalse:[ error value:'invalid year' ].
            year := year + 1900

        ] ifFalse:[ ( format sameAs:  'Y1950' ) ifTrue:[
            year := Integer readFrom:input onError:[ error value:'invalid year' ].
            (year between:0 and: 99) ifFalse:[ error value:'invalid year' ].
            (year between:0 and: 49) ifTrue:[ 
                year := year + 2000
            ] ifFalse:[    
                year := year + 1900
            ]  

        ] ifFalse:[ ( format sameAs:  'Y1980' ) ifTrue:[
            year := Integer readFrom:input onError:[ error value:'invalid year' ].
            (year between:0 and: 99) ifFalse:[ error value:'invalid year' ].
            (year between:0 and: 79) ifTrue:[ 
                year := year + 2000
            ] ifFalse:[    
                year := year + 1900
            ]  

        ] ifFalse:[ ( format sameAs:  'Y2000' ) ifTrue:[
            year := Integer readFrom:input onError:[ error value:'invalid year' ].
            (year between:0 and: 99) ifFalse:[ error value:'invalid year' ].
            year := year + 2000

        ] ifFalse:[ ( format = 'h' or:[ format = 'H' ]) ifTrue:[
            hour := Integer readFrom:input onError:[ error value:'invalid hour' ].

        ] ifFalse:[ ( format = 'u'  or:[ format = 'U']) ifTrue:[
            hour := Integer readFrom:input onError:[ error value:'invalid hour' ].

        ] ifFalse:[ ( format = 'm'  or:[ format = 'M' ]) ifTrue:[
            minute := Integer readFrom:input onError:[ error value:'invalid minute' ].

        ] ifFalse:[ ( format = 's'  or:[ format = 'S' ]) ifTrue:[
            second := Integer readFrom:input onError:[ error value:'invalid second' ].

        ] ifFalse:[ ( format = 'i'  or:[ format = 'I' ]) ifTrue:[
            millisecond := Integer readFrom:input onError:[ error value:'invalid month' ].

        ] ifFalse:[ ( format = 'f'  or:[ format = 'F' ]) ifTrue:[
            fractionString := input upToMatching:[:ch | ch isDigit not].
            fraction := FixedPoint readFrom:'0.',fractionString.
            millisecond := (fraction * 1000) truncated.

        ] ifFalse:[ ( format = 'tz' ) ifTrue:[
            utcOffset := self utcOffsetFrom:input.
            utcOffset isNil ifTrue:[ error value:'invalid timezone' ]
        ] ifFalse:[ ( format = 'a' ) ifTrue:[
            s := (input next:2) asLowercase.
            s = 'am' ifTrue:[
                (hour between:0 and:12) ifFalse:[ error value:'invalid hour' ]
            ] ifFalse:[
                s = 'pm' ifTrue:[
                    (hour between:1 and:12) ifFalse:[ error value:'invalid hour' ].
                    hour := hour + 12.
                ] ifFalse:[
                    error value:'invalid am/pm'
                ]
            ]

        ] ifFalse:[
            error value:'unhandled format:',format
        ]]]]]]]]]]]]]]]]]]
    ].

    hour := 0.
    minute := 0.
    second := 0.
    millisecond := 0.
    utcOffset := 0.

    inStream := aStringOrStream readStream.
    formatStream := formatString readStream.

    [formatStream atEnd] whileFalse:[
        fChar := formatStream next.
        fChar = Character space ifTrue:[
            inStream peek isSeparator ifFalse:[ error value: 'format error; space expcected' ].
            inStream skipSeparators.
        ] ifFalse:[
            fChar == $% ifTrue:[
                len := nil.
                (formatStream peek isDigit) ifTrue:[
                    len := Integer readFrom:formatStream onError:[ error value: 'format error; invalid length' ]
                ].
                (formatStream peek == $() ifTrue:[
                    formatStream next.
                    format := formatStream upTo:$).
                ] ifFalse:[
                    (formatStream peek == ${) ifTrue:[
                        formatStream next.
                        format := formatStream upTo:$}.
                    ] ifFalse:[
                        (formatStream peek isLetter) ifTrue:[
                            format := formatStream nextAlphaNumericWord.
                        ] ifFalse:[
                            error value:'unhandled format:',formatStream peek
                        ]
                    ]
                ].
                itemHandler value:format.
            ] ifFalse:[
                inStream peek = fChar ifFalse:[^ error value: 'format error; ',fChar,' expcected'].
                inStream next.
            ]
        ].
    ].

    year isNil ifTrue:[
        year := (now := Timestamp now) year
    ].
    
    dayOfYear notNil ifTrue:[
        monthAndDay := Date monthAndDayFromDayInYear:dayOfYear forYear:year.
        month := (monthAndDay at:1).
        day := (monthAndDay at:2).  
    ].
    
    ^ (self 
        year:year month:month day:day 
        hour:(hour ? 0) minute:(minute ? 0) second:(second ? 0) millisecond:millisecond) 
            + utcOffset

    "
     Timestamp readFrom:'20-2-1995 13:11:06' format:'%day-%month-%year %h:%m:%s' language:nil onError:[self halt]
     Timestamp readFrom:'20021995131106' format:'%2d%2month%4y%2h%2m%2s' language:nil onError:[self halt]
     Timestamp readFrom:'200295131106' format:'%2d%2month%2y%2h%2m%2s' language:nil onError:[self halt]
     Timestamp readFrom:'200260131106' format:'%2d%2month%2(y1900)%2h%2m%2s' language:nil onError:[self halt]
     Timestamp readFrom:'200260131106' format:'%2d%2month%2(y2000)%2h%2m%2s' language:nil onError:[self halt]
     Timestamp readFrom:'200260131106' format:'%2d%2month%2(y1950)%2h%2m%2s' language:nil onError:[self halt]
     Timestamp readFrom:'200260131106' format:'%2d%2month%2(y1980)%2h%2m%2s' language:nil onError:[self halt]
     Timestamp readFrom:'March 7 2009 7:30pm EST' format:'%monthName %day %year %u:%m%a %tz' language:#en onError:[self halt]
     Timestamp readFrom:'March 7 2009 7:30pm UTC' format:'%monthName %day %year %u:%m%a %tz' language:#en onError:[self halt]
     Timestamp readFrom:'2015103' format:'%4y%3dayOfYear' onError:[self halt]

     Timestamp readFrom:'20-2-1995 13:11:06.999' format:'%day-%month-%year %h:%m:%s.%i' language:nil onError:[self halt]
     Timestamp readFrom:'20-2-1995 13:11:06.100' format:'%day-%month-%year %h:%m:%s.%i' language:nil onError:[self halt]
     Timestamp readFrom:'20-2-1995 13:11:06.010' format:'%day-%month-%year %h:%m:%s.%i' language:nil onError:[self halt]

     Timestamp readFrom:'20-2-1995 13:11:06.1' format:'%day-%month-%year %h:%m:%s.%f' language:nil onError:[self halt]
     Timestamp readFrom:'20-2-1995 13:11:06.01' format:'%day-%month-%year %h:%m:%s.%f' language:nil onError:[self halt]
     Timestamp readFrom:'20-2-1995 13:11:06.001' format:'%day-%month-%year %h:%m:%s.%f' language:nil onError:[self halt]
     Timestamp readFrom:'20-2-1995 13:11:06.12345' format:'%day-%month-%year %h:%m:%s.%f' language:nil onError:[self halt]
    "
!

readFrom:aStringOrStream onError:exceptionBlock
    "return a new Timestamp, reading a printed representation from aStream.
     The string is interpreted as 24 hour format, as printed.
     Notice, that this is not the storeString format and
     is different from the format expected by readFrom:.
     The format read here is either dd-mm-yyyy hh:mm:ss.iii
     or iso8601 (if the first integer is >31).

     Please consider using a standard format, such as iso8601."

    |stream newTime|

    stream := aStringOrStream readStream.

    Error handle:[:ex |
	newTime := super readFrom:stream onError:exceptionBlock
    ] do:[
	newTime := self basicReadFrom:stream.
    ].
    ^ newTime

    "
     Timestamp readFrom:'20-2-1995 13:11:06'
     Timestamp readFrom:'20-2-1995 13:11'
     Timestamp readFrom:'20-2-2001 13:11'
     Timestamp readFrom:'20-2-1995 13:11:06.100'
     Timestamp readFrom:'32-2-1995 13:11:06.100' onError:'wrong'
     Timestamp readFrom:'32-foo-1995 13:11:06.100' onError:'wrong'
     Timestamp readFrom:'20-2-1995 24:01:00.100' onError:'wrong'
     Timestamp readFrom:'20-2-1995 24:00:01.100' onError:'wrong'
     Timestamp readFrom:'2002-08-02 24:00:01.100' onError:'wrong'
     Timestamp readFrom:'foo' onError:'wrong'
     Timestamp readFrom:(Timestamp now storeString) onError:'wrong'
    "

    "Modified: / 8.10.1996 / 19:25:59 / cg"
    "Modified: / 13.7.1999 / 12:31:14 / stefan"
!

readGeneralizedFrom:aStringOrStream
    "return a new Timestamp, reading a printed representation from aStream.
     The format read here is either
        yyyymmddHHMMSS.iii+uuuu, which is the ASN1 GeneralizedTime format.
     or:
        yyyy-mm-dd HH:MM:SS.iii +uuuu.
     The string is interpreted as 24 hour format, as printed.

     This format is used for BER specification of the ASN.1 GeneralizedTime as defined in X.208 Sec. 33,
     so read this before changing anything here.

     New applications should consider using a standard format, such as iso8601.

     Notice, that this is not the storeString format and
     is different from the format expected by readFrom:.
    "

    ^ self
        readGeneralizedFrom:aStringOrStream
        short:false
        onError:[
            self conversionErrorSignal raiseWith:aStringOrStream errorString:' - Timestamp GeneralizedTime format error'
        ].

    "Created: / 22-08-2006 / 16:05:55 / cg"
!

readGeneralizedFrom:aStringOrStream onError:exceptionBlock
    "return a new Timestamp, reading a printed representation from aStream.
     The format read here is either
	yyyymmddHHMMSS.iii+uuuu, which is the ASN1 GeneralizedTime format.
     or:
	yyyy-mm-dd HH:MM:SS.iii +uuuu.
     The string is interpreted as 24 hour format, as printed.

     This format is used for BER specification of the ASN.1 GeneralizedTime as defined in X.208 Sec. 33,
     so read this before changing anything here.

     New applications should consider using a standard format, such as iso8601.

     Notice, that this is not the storeString format and
     is different from the format expected by readFrom:.
    "

    ^ self readGeneralizedFrom:aStringOrStream short:false onError:exceptionBlock

    "
     |s|
     s := '' writeStream.
     Timestamp now printGeneralizedOn:s.
     Timestamp readGeneralizedFrom:s contents onError:[]

 Daylight saving time:

     Timestamp readGeneralizedFrom:'20000718120000Z' onError:[]
     Timestamp readGeneralizedFrom:'20000718120000+0200' onError:[]
     Timestamp readGeneralizedFrom:'20000718120000+0300' onError:[]

 No daylight saving time:

     Timestamp readGeneralizedFrom:'20000202120000Z' onError:[]
     Timestamp readGeneralizedFrom:'20000202120000+0100' onError:[]
     Timestamp readGeneralizedFrom:'20000202120000+0200' onError:[]

     Timestamp readGeneralizedFrom:'19950220131106' onError:[]
     Timestamp readGeneralizedFrom:'199502201311' onError:[]
     Timestamp readGeneralizedFrom:'19950220131106.100' onError:[]
     Timestamp readGeneralizedFrom:'19950232131106.100' onError:'wrong'
     Timestamp readGeneralizedFrom:'19950fo2131106.100' onError:'wrong'
     Timestamp readGeneralizedFrom:'foo' onError:'wrong'

     Timestamp readGeneralizedFrom:'2000-02-02 12:00:00' onError:[]
     Timestamp readGeneralizedFrom:'2000-02-02 12:00:00.100' onError:[]
     Timestamp readGeneralizedFrom:'2000-02-02 12:00:00.100 +0100' onError:[]
     Timestamp readGeneralizedFrom:'2000-02-02 12:00:00 -0100' onError:[]
     Timestamp readGeneralizedFrom:'2000-02-02 12:00:00 +0000' onError:[]
    "

    "Modified: / 13-07-1999 / 12:31:14 / stefan"
    "Modified: / 22-08-2006 / 12:30:11 / cg"
!

readGeneralizedFrom:aStringOrStream short:shortFormat onError:exceptionBlock
    "return a new Timestamp, reading a printed representation from aStream.
     The long format read here is either
            yyyymmddHHMMSS.iii+uuuu, which is the ASN1 GeneralizedTime format.
        or:
            yyyy-mm-dd HH:MM:SS.iii +uuuu.
     The (not recommended) short forms are:
            yymmddHHMMSS.iii+uuuu, which is the ASN1 GeneralizedTime format.
        or:
            yy-mm-dd HH:MM:SS.iii +uuuu.
     The string is interpreted as 24 hour format, as printed.

     This format is used for BER specification of the ASN.1 GeneralizedTime and
     UTCTime as defined in X.208 Sec. 33, so read this before changing anything here.
     The short form is no longer recommended.

     New applications should consider using a standard format, such as iso8601.

     Notice, that this is not the storeString format and
     is different from the format expected by readFrom:.
    "


    ^ [
        |newTime str day month year hour min sec millis c|

        sec := millis := 0.
        str := aStringOrStream readStream.

        shortFormat ifTrue:[
            year := Integer readFrom:(str next:2).
            year < 50 ifTrue:[
                year := year + 2000.
            ] ifFalse:[
                year := year + 1900.
            ].
        ] ifFalse:[
            year := Integer readFrom:(str next:4).
        ].
        str peek == $- ifTrue:[ str next].
        month := Integer readFrom:(str next:2).
        (month between:1 and:12) ifFalse:[^ exceptionBlock value].
        str peek == $- ifTrue:[ str next].
        day := Integer readFrom:(str next:2).
        (day between:1 and:31) ifFalse:[^ exceptionBlock value].

        str skipSeparators.
        hour:= Integer readFrom:(str next:2).
        (hour between:0 and:24) ifFalse:[^ exceptionBlock value].
        str peek == $: ifTrue:[ str next].
        min:= Integer readFrom:(str next:2).
        (min between:0 and:59) ifFalse:[^ exceptionBlock value].
        str atEnd ifFalse:[
            str peek == $: ifTrue:[ str next].
            sec := Integer readFrom:(str next:2).
            (sec between:0 and:59) ifFalse:[^ exceptionBlock value].
            str atEnd ifFalse:[
                str peek == $. ifTrue:[
                    str next.
                    millis := Integer readFrom:str.
                ].
                str skipSeparators.
            ].
        ].

        str atEnd ifTrue:[
            "/ this is local time
            newTime := self year:year month:month day:day
                            hour:hour minute:min second:sec millisecond:millis.
        ] ifFalse:[
            c := str next.
            c ~~ $Z ifTrue:[
                |tzh tzmin|
                tzh := Integer readFrom:(str next:2).
                tzmin := Integer readFrom:(str next:2).
                c == $+ ifTrue:[
                    "the timezone is ahead of UTC or EAST from Greenwich: subtract hours and minutes"
                    hour := hour - tzh.
                    min := min - tzmin.
                ] ifFalse:[
                    c == $- ifTrue:[
                        "the timezone is behind of UTC or WEST from Greenwich: add hours and minutes"
                        hour := hour + tzh.
                        min := min + tzmin.
                    ] ifFalse:exceptionBlock
                ].
            ].
            "this is UTC time"
            newTime := self UTCYear:year month:month day:day
                              hour:hour minute:min second:sec millisecond:millis.
        ].
        newTime
    ] on:Error do:exceptionBlock.

    "
     |s|
     s := '' writeStream.
     Timestamp now printGeneralizedOn:s.
     Timestamp readGeneralizedFrom:s contents onError:[]

     Timestamp readGeneralizedFrom:'20080718120000+0300' short:false onError:[]
     Timestamp readGeneralizedFrom:'080718120000+0300' short:true onError:[]
     Timestamp readGeneralizedFrom:'990718120000+0300' short:true onError:[]

 Daylight saving time:

     Timestamp readGeneralizedFrom:'20000718120000Z' onError:[]
     Timestamp readGeneralizedFrom:'20000718120000+0200' onError:[]
     Timestamp readGeneralizedFrom:'20000718120000+0300' onError:[]

 No daylight saving time:

     Timestamp readGeneralizedFrom:'20000202120000Z' onError:[]
     Timestamp readGeneralizedFrom:'20000202120000+0100' onError:[]
     Timestamp readGeneralizedFrom:'20000202120000+0200' onError:[]

     Timestamp readGeneralizedFrom:'19950220131106' onError:[]
     Timestamp readGeneralizedFrom:'199502201311' onError:[]
     Timestamp readGeneralizedFrom:'19950220131106.100' onError:[]
     Timestamp readGeneralizedFrom:'19950232131106.100' onError:'wrong'
     Timestamp readGeneralizedFrom:'19950fo2131106.100' onError:'wrong'
     Timestamp readGeneralizedFrom:'foo' onError:'wrong'

     Timestamp readGeneralizedFrom:'2000-02-02 12:00:00' onError:[]
     Timestamp readGeneralizedFrom:'2000-02-02 12:00:00.100' onError:[]
     Timestamp readGeneralizedFrom:'2000-02-02 12:00:00.100 +0100' onError:[]
     Timestamp readGeneralizedFrom:'2000-02-02 12:00:00 -0100' onError:[]
     Timestamp readGeneralizedFrom:'2000-02-02 12:00:00 +0000' onError:[]
    "

    "Modified: / 13-07-1999 / 12:31:14 / stefan"
    "Modified: / 22-08-2006 / 12:30:11 / cg"
!

readISO8601From:aStringOrStream
    "Please use this format for all external representations - it's the standard."

    "using the new reader"

    ^ TimestampISO8601Builder read:aStringOrStream withClass:self

    "Created: / 16-06-2005 / 16:13:36 / masca"
!

readISO8601From:aStringOrStream onError:exceptionValue
    "Please use this format for all external representations - it's the standard."

    "using the new reader"

    |retVal|

    ConversionError handle:[:ex |
	retVal := exceptionValue value
    ] do:[
	retVal := TimestampISO8601Builder read:aStringOrStream withClass:self
    ].
    ^ retVal
!

readIso8601FormatFrom:aStringOrStream
    "return a new Timestamp, reading an iso8601 UTC representation from aStream.
     Missing month/day values are replaced with 1; i.e. 1999T24:00
     is the same as 1999-01-01T24:00:00.
     Missing minute, second and ms values are replaced with 0;
     i.e. 1999T12 is the same as 1999-01-01T12:00:00.000.
     Of course, a 24 hour clock is used.
     On error, raise an exception.

     Please use this format for all external representations - it's the standard."

    "changed to use the new reader"

    ^ TimestampISO8601Builder read:aStringOrStream withClass:self
"/    ^ self
"/        readIso8601FormatFrom:aStringOrStream yearAlreadyRead:nil

    "
     Timestamp readIso8601FormatFrom:'20141106T123843.299Z'
     Timestamp readIso8601FormatFrom:'20141106T123843.299'

     Timestamp readIso8601FormatFrom:'1995-02-20T13:11:06'
     Timestamp readIso8601FormatFrom:'1995-02T13:11:06'
     Timestamp readIso8601FormatFrom:'1995T13:11:06'
     Timestamp readIso8601FormatFrom:'1995T13:11'
     Timestamp readIso8601FormatFrom:'1995T13'
     Timestamp readIso8601FormatFrom:'1995'

     Timestamp readIso8601FormatFrom:'1995-02-20 13:11:06'
     Timestamp readIso8601FormatFrom:'1995-02-20 13:11'
     Timestamp readIso8601FormatFrom:'1995-02-20 13'

     Timestamp readIso8601FormatFrom:'20141106T122831.894Z'

   24 is allowed with ISO, and is 00:00 of the next day:
     Timestamp readIso8601FormatFrom:'1995-02-20 24:00:00'

    "
!

readIso8601FormatFrom:aStringOrStream onError:exceptionValue
    "return a new Timestamp, reading an iso8601 UTC representation from aStream.
     Missing month/day values are replaced with 1; i.e. 1999T24:00
     is the same as 1999-01-01T24:00:00.
     Missing minute, second and ms values are replaced with 0;
     i.e. 1999T12 is the same as 1999-01-01T12:00:00.000.
     Of course, a 24 hour clock is used.
     On error, raise an exception.

     Please use this format for all external representations - it's the standard."

    "/ changed to use the new reader
    |retVal|

    ConversionError handle:[:ex |
	retVal := exceptionValue value
    ] do:[
	retVal := TimestampISO8601Builder read:aStringOrStream withClass:self
    ].
    ^ retVal

"/    ^ self
"/        readIso8601FormatFrom:aStringOrStream
"/        yearAlreadyRead:nil
"/        onError:exceptionValue
!

readRFC1123FormatFrom:rfc1123String onError:exceptionBlock
    "please use this only for http-requests.
     All other programs should use iso8601, which is the standard for times and dates.

     All HTTP/1.0 date/time stamps must be represented in Universal Time (UT),
     also known as Greenwich Mean Time (GMT), without exception.
     This is indicated in the first two formats by the inclusion of
     'GMT' as the three-letter abbreviation for time zone,
     and should be assumed when reading the asctime format.

     HTTP-date      = rfc1123-date | rfc850-date | asctime-date

     rfc1123-date   = wkday ',' SP date1 SP time SP 'GMT'
     rfc850-date    = weekday ',' SP date2 SP time SP 'GMT'
     asctime-date   = wkday SP date3 SP time SP 4DIGIT

     date1          = 2DIGIT SP month SP 4DIGIT
                      ; day month year (e.g., 02 Jun 1982)
     date2          = 2DIGIT '-' month '-' 2DIGIT
                      ; day-month-year (e.g., 02-Jun-82)
     date3          = month SP ( 2DIGIT | ( SP 1DIGIT ))
                      ; month day (e.g., Jun  2)

     time           = 2DIGIT ':' 2DIGIT ':' 2DIGIT
                      ; 00:00:00 - 23:59:59

     wkday          = 'Mon' | 'Tue' | 'Wed'
                    | 'Thu' | 'Fri' | 'Sat' | 'Sun'

     weekday        = 'Monday' | 'Tuesday' | 'Wednesday'
                    | 'Thursday' | 'Friday' | 'Saturday' | 'Sunday'

     month          = 'Jan' | 'Feb' | 'Mar' | 'Apr'
                    | 'May' | 'Jun' | 'Jul' | 'Aug'
                    | 'Sep' | 'Oct' | 'Nov' | 'Dec'

     Mon, 17 Aug 2009 11:11:15 GMT

     however, occasionally, someone presents us with non-UTC strings which include a timezone;
     thus, this also supports:
         Mon, 17 Aug 2009 11:11:15 +xxxx
         Mon, 17 Aug 2009 11:11:15 -xxxx
     and:
         Mon, 17 Aug 2009 11:11:15 PST
    "

    |parts indexModifier utcOffsetString utcOffset day year time monthName month|

    rfc1123String isEmptyOrNil ifTrue:[^ exceptionBlock value].

    parts := rfc1123String asCollectionOfSubstringsSeparatedBy:Character space.
    parts size == 6 ifTrue:[
        indexModifier := 0.
    ] ifFalse:[
        parts size == 5 ifTrue:[
            indexModifier := -1.
        ] ifFalse:[
            ^ exceptionBlock value
        ].
    ].

    day := Integer readFrom:(parts at:2 + indexModifier) onError:[^ exceptionBlock].
    year := Integer readFrom:(parts at:4 + indexModifier) onError:[^ exceptionBlock].
    time := Time readFrom:(parts at:5 + indexModifier) onError:[^ exceptionBlock].
    monthName := parts at:3 + indexModifier.

    month := Date indexOfMonth:monthName language:#en.
    month = 0 ifTrue:[^ exceptionBlock value].

    utcOffsetString := parts at:6 + indexModifier ifAbsent:nil.
    utcOffset := self utcOffsetFrom:utcOffsetString.

    (utcOffset isNil or:[utcOffset = 0]) ifTrue:[
        ^ UtcTimestamp year:year month:month day:day hour:time hour minute:time minute second:time second millisecond:0.
    ].
    ^ TZTimestamp new 
            setOSTimeFromUTCYear:year month:month day:day hour:time hour minute:time minute second:time second millisecond:0;
            utcOffset:utcOffset;
            addSeconds:utcOffset.

    "
     self readRFC1123FormatFrom:'Mon, 17 Aug 2009 11:11:15 GMT' onError:nil
     self readRFC1123FormatFrom:'Mon, 17 Aug 2009 11:11:15 UTC' onError:nil
     self readRFC1123FormatFrom:'Mon, 17 Aug 2009 11:11:15 PST' onError:nil
     self readRFC1123FormatFrom:'Mon, 17 Aug 2009 11:11:15 PDT' onError:nil
     self readRFC1123FormatFrom:'Mon, 17 Aug 2009 11:11:15 +0100' onError:nil
     self readRFC1123FormatFrom:'17 Aug 2009 11:11:15 +0100' onError:nil
    "

    "Modified: / 05-10-2010 / 16:05:32 / cg"
!

timezoneInfo
    "return a table containing timezone information.
     This may or may not be correct by the time you read this.
     It is recommended to add explicit information in the form of +hh:mm to a printed
     representation, instead of using names.

     As this is searched for when reverse converting from utcOffset to TZName"

    "/ the table below can be customized via a setter,
    "/ if an application knows better 
    "/ (reading a system timeZone table, or limiting the table to military/non-military names only, for example)
    
    TimeZoneInfo notNil ifTrue:[^ TimeZoneInfo].
    
    "/ table is name, utcOffset(minutes), DST-flag, startDay, endDay
    ^ #(
            'Z'     0   false          "/ zulu
            'UTC'   0   false    
            'GMT'   0   false    

            "/ US
            'HAST' -600 false          "/ hawai standard
            'AKST' -540 false          "/ alaska standard
            'YST'  -540 false          "/ yukon standard
            'PST'  -480 false          "/ pacific standard
            'PT'   -480 false          "/ pacific standard
            'MST'  -420 false          "/ mountain standard
            'CST'  -360 false          "/ central standard
            'EST'  -300 false          "/ eastern standard
            'AST'  -240 false          "/ atlantic standard

            'NST'  -210 false          "/ new foundland standard
            'PMST' -180 false          "/ pierre & miquelon
            'WGT'  -180 false          "/ west greenland
            'EGT'  -60  false          "/ east greenland

            "/ europe
            'CET'   60  false          "/ central european
            'EET'   120 false          "/ east european
            'WET'   0   false          "/ west european
            "/ conflict with india!!
            "/ 'IST'   1               "/ irish standard time
            "/ 'IST'   1               "/ israel standard time
            'AZOT'   -60 false         "/ azores standard

            'MSK'   240 false          "/ moscow european
            'MSD'   240 false
            'BT'    240 false          "/ baghdad

            "/ pacific
            'NZST'  720 false          "/ new zealand standard
            'FJT'   720 false          "/ fiji

            "/ south america
            'ART'   -180 false         "/ argentina
            'BOT'   -240 false         "/ bolivia
            'BRT'   -180 false         "/ brasilia
            'CLT'   -240 false         "/ chile
            'ECT'   -300 false         "/ equador
            'PET'   -300 false         "/ peru
            'PYT'   -240 false         "/ paraguay
            'UYT'   -180 false         "/ uruguay
            'VET'   -270 false         "/ venezuela standard
            'VST'   -270 false         "/ venezuela standard

            "/ africa
            'CAT'   120 false          "/ central africa
            'EAT'   180 false          "/ east africa
            'SAST'  120 false          "/ south africa standard
            'WAT'   60 false           "/ west africa
            'WT'    0 false            "/ west sahara standard

            'AST'   180 false          "/ arabia
            'IRT'   210 false          "/ iran time
            'AFT'   270 false          "/ afghanistan time

            'HKT'   480 false          "/ hongkong
            'IST'   330 false          "/ india standard
            'ICT'   420 false          "/ indochina
            'CNST'  480 false          "/ china standard
            'JST'   540 false          "/ japan standard
            'KST'   540 false          "/ korea standard
            'SGT'   480 false          "/ singapore
            'MYT'   480 false          "/ malaysia
            'AWST'  480 false          "/ australian west standard
            'ACWST' 525 false          "/ australian central western standard
            'ACST'  570 false          "/ australian central standard
            'AEST'  600 false          "/ australian east standard
            'NFT'   690 false          "/ norfolk island, australia

            'CHAST' 765 false          "/ chatham island standard
            'WST'   780 false          "/ west samoa - yes that's 13!!
            'TOT'   780 false          "/ tonga - yes that's 13!!
            'TKT'   780 false          "/ tokelau - yes that's 13!!
            'LINT'  840 false          "/ line islands - yes that's 14!!

            "/ misc
            'IDLW' -720 false          "/ international date line west
            'IDLE'  720 false          "/ international date line east

            'MEZ'   60  false           "/ mittel europäische Zeit /  central european (german)
            'MESZ'  120 true            "/ central european summer (german)
            'WESZ'  60  true            "/ west european summer (german)

            'WEZ'   0   false           "/ west european (german)

            'HADT'  -540 true           "/ hawaii summer
            'ADT'   -180 true
            'AKDT'  -540 true         "/ alaska summer
            'YDT'   -480 true         "/ yukon summer
            'PDT'   -420 true         "/ pacific daylight saving
            'MDT'   -360 true         "/ mountain daylight saving
            'CDT'   -300 true         "/ central daylight saving
            'EDT'   -240 true         "/ eastern daylight saving
            'CLST'  -180 true         "/ chile summer
            'NDT'   -150 true
            'PMDT'  -120 true
            'BRST'  -120 true         "/ brasilia summer
            'WGST'  -120 true         "/ west greenland summer
            'EGST'   0 true           "/ east greenland summer
            'AZOST'  0 true           "/ azores summer
            'EEST'   180 true
            'CEST'   120 true
            'WAST'   120 true         "/ west africa summer
            "/ 'WST'   60 true        "/ west sahara summer - conflict with west samoa
            'WEST'  60 true
            'BST'   60 true           "/ british summer time
            'IRST'  270 true          "/ iran summer time
            'AWDT'  540 true          "/ australian west daylight saving
            'ACDT'  630 true          "/ australian central daylight saving
            'AEDT'  660 true          "/ australian east daylight saving
            'CHADT' 825 true          "/ chatham island daylight saving
            'FJST'  780 true          "/ fiji summer
            'NZDT'  780 true          "/ new zealand summer

            "/ military
            'A'     60  false          "/ alpha
            'B'     120 false          "/ bravo
            'C'     180 false          "/ charlie
            'D'     240 false          "/ delta
            'E'     300 false          "/ echo
            'F'     360 false          "/ foxtrot
            'G'     420 false          "/ golf
            'H'     480 false          "/ hotel
            'I'     540 false          "/ also called india - how misleading
            'K'     600 false          "/ kilo
            'L'     660 false          "/ lima - but not there
            'M'     720 false          "/ mike
            'N'     -60  false         "/ november (but also in other months)
            'O'     -120 false         "/ oscar
            'P'     -180 false         "/ papa (not mama)
            'Q'     -240 false         "/ quebec - really?
            'R'     -300 false         "/ romeo and juliet
            'S'     -360 false         "/ sierra
            'T'     -420 false         "/ tango (& not rumba)
            'U'     -480 false         "/ uniform
            'V'     -540 false         "/ victor
            'W'     -600 false         "/ whiskey (scotch?)
            'X'     -660 false         "/ xray
            'Y'     -720 false         "/ yankee

        ).
!

utcOffsetFrom:aStringOrStream
    "return the utcOffset (in seconds) for a given time-zone name.
     Returns nil for invalid formats, 0 if no timezone offset is present.

     Notice: this returns the negated value of what is read from a printed representation,
     which means that the sign is the same as what the utcOffset instance variable
     in timeStamp and OperatingSystem-timeInfo will be.

     If utcOffset is negative, the local timezone is east of Greenwich.
     If utcOffset is positive, the local timezone is west of Greenwich.

     UtcOffset is what you have to ADD to correct the printed time to GMT.
     I.e. for Germany, you'll get -3600 (+01h), for NewYork, you'll get +18000 (-05h)"

    |ch offset stream|

    stream := aStringOrStream readStream.
    stream skipSeparators.

    ch := stream peekOrNil.
    ch isNil ifTrue:[^ 0].

    ch isLetter ifTrue:[
        |table tzName i minuteOffset|
        
        table := self timezoneInfo.
        tzName := stream upToElementForWhich:[:ch | ch isLetter not].

        i := table indexOf:tzName.
        i == 0 ifTrue:[
            ^ nil
        ].
        minuteOffset := (table at:i+1).
        offset := minuteOffset * 60
    ] ifFalse:[
        |sign|

        sign := 1.
        ch == $- ifTrue:[
            sign := -1.
            stream next.
        ] ifFalse:[ch == $+ ifTrue:[
            stream next.
        ] ifFalse:[
            stream skipSeparators
        ]].
        stream peekOrNil isDigit ifFalse:[^ nil].

        offset := ((stream next:2) asNumber * 60 * 60).
        ch := stream peekOrNil.
        ch notNil ifTrue:[
            ch == $: ifTrue:[ stream next ].
            offset := offset + ((stream next:2) asNumber * 60).
        ].
        offset := offset * sign
    ].

    "/ return what would be an utcOffset (not what is at the end of an iso string)
    ^ offset negated

    "
     self utcOffsetFrom:'UTC'
     self utcOffsetFrom:'PST'
     self utcOffsetFrom:'EST'
     self utcOffsetFrom:'CET'
     self utcOffsetFrom:'+0130'
     self utcOffsetFrom:'+01:30'
     self utcOffsetFrom:'+1:30'
     self utcOffsetFrom:'+01'
    "
!

utcOffsetFromString:aString
    <resource: #obsolete>
    "return the utcOffset (in seconds) for a given time-zone name.
     Returns nil for invalid formats"

    ^ self utcOffsetFrom:aString

    "
     self utcOffsetFromString:'UTC'
     self utcOffsetFromString:'+01'
    "
! !


!Timestamp methodsFor:'accessing'!

day
    "return the day-in-month of the receiver (1..31).
     For compatibility, use instances of Date for this."

    ^ self asDate day.

    "
     Timestamp now day
    "

    "Modified: 1.7.1996 / 15:23:02 / cg"
!

dayInWeek
    "return the week-day of the receiver - 1 for monday, 7 for sunday.
     for pre-gregorian dates, it simply goes on assuming the current leapYear rules
     WARNING: different from ANSIs dayOfWeek (which returns 1 for sunday, ... 7 for saturday)."

    ^ self asDate dayInWeek

    "
     Timestamp now dayInWeek
    "

    "Modified: 2.7.1996 / 09:20:32 / cg"
    "Created: 2.7.1996 / 09:35:48 / cg"
!

dayInYear
    "return the year-day of the receiver - 1 for Jan, 1st."

    ^ self asDate dayInYear

    "
     Timestamp now dayInYear
     (Timestamp newDay:184 year:1996) dayInYear
    "

    "Modified: 2.7.1996 / 10:21:02 / cg"
!

dayOfMonth
    "Answer the day of the month represented by me.
     Same as day; for ST-80 compatibility."

    ^ self asDate dayOfMonth

    "
     Timestamp now dayOfMonth
     (Timestamp newDay:184 year:1996) dayOfMonth
    "

    "Created: / 20-01-2011 / 12:26:54 / cg"
!

dayOfWeek
    "return the week-day of the receiver - 1 is sunday, 7 for saturday.
     WARNING: different from dayInWeek (which returns 1 for monday, ... 7 for sunday).
    "

    ^ self asDate dayOfWeek

    "
     Timestamp now dayOfWeek
    "
!

dayOfWeekName
    "return the week-day of the receiver as a string.
     The returned string depends on the language setting.
     Expect things like 'monday', 'tuesday' ..."

    ^ self asDate dayOfWeekName

    "
     Timestamp now dayOfWeekName
     (Timestamp newDay:184 year:1996) dayOfWeekName
    "

    "Created: / 20-01-2011 / 12:28:46 / cg"
!

hour
    "return the hour (0..23).
     ST-80 Timestamp compatibility (I'd prefer the name #hours, for Time compatibility)."

    ^ self hours

    "Created: 1.7.1996 / 15:14:50 / cg"
    "Modified: 1.7.1996 / 15:15:32 / cg"
!

hours
    "return the hours (0..23)"

    (osTime between:MinOSTime and:MaxOSTime) ifFalse:[
	^ self asTime hours.
    ].
    ^ self timeInfo hours

    "
     Timestamp now hours
    "

    "Modified: 2.7.1996 / 09:20:32 / cg"
!

millisecond
    "return the millisecond (0..999).
     ST-80 Timestamp compatibility (I'd prefer the name #milliseconds)."

    ^ self milliseconds

    "Created: 1.7.1996 / 15:14:50 / cg"
    "Modified: 1.7.1996 / 15:15:24 / cg"
!

milliseconds
    "return the milliseconds (0..999)"

    ^ osTime \\ 1000.
"/    ^ self timeInfo milliseconds

    "
     Timestamp now milliseconds
    "

    "Created: 1.7.1996 / 15:15:02 / cg"
    "Modified: 2.7.1996 / 09:21:41 / cg"
!

minute
    "return the minute (0..59).
     ST-80 Timestamp compatibility (I'd prefer the name #minutes, for Time compatibility)."

    ^ self minutes

    "Created: 1.7.1996 / 15:14:29 / cg"
    "Modified: 1.7.1996 / 15:15:37 / cg"
!

minutes
    "return the minutes (0..59)"

    (osTime between:MinOSTime and:MaxOSTime) ifFalse:[
	^ self asTime minutes.
    ].
    ^ self timeInfo minutes

    "
     Timestamp now minutes
    "

    "Modified: 2.7.1996 / 09:20:49 / cg"
!

month
    "return the month of the receiver (1..12).
     For compatibility, use instances of Date for this."

    (osTime between:MinOSTime and:MaxOSTime) ifFalse:[
	^ self asDate month.
    ].
    ^ self timeInfo month

    "
     Timestamp now month
    "

    "Modified: 1.7.1996 / 15:23:05 / cg"
!

monthIndex
    "return the month of the receiver (1..12).
     For compatibility"

    ^ self asDate monthIndex.

    "
     Timestamp now monthIndex
    "
!

osTime
    "get the internal representation of the time.
     Warning: do not depend on the value (unix vs. win32 - differences)"

    ^ osTime
!

osTime:aTime
    "set the internal representation of the time"

    osTime := aTime.
!

second
    "return the second (0..59).
     ST-80 Timestamp compatibility (I'd prefer the name #seconds, for Time compatibility)."

    ^ self seconds

    "Created: 1.7.1996 / 15:14:19 / cg"
    "Modified: 1.7.1996 / 15:15:49 / cg"
!

seconds
    "return the seconds (0..59)"

    (osTime between:MinOSTime and:MaxOSTime) ifFalse:[
	^ self asTime seconds.
    ].
    ^ self timeInfo seconds

    "
     Timestamp now seconds
    "

    "Modified: 2.7.1996 / 09:20:54 / cg"
!

timeZoneDeltaInMinutes
    "answer the number of minutes between local time and utc time.
     Delta is positive if local time is ahead of utc, negative if behind utc."

    ^ self utcOffset negated // 60

    "
     Timestamp now timeZoneDeltaInMinutes
     (Timestamp day:1 month:7 year:1995 hour:12 minutes:0 seconds:0) timeZoneDeltaInMinutes
    "

    "Modified: 20.12.1995 / 17:28:49 / stefan"
    "Modified: 1.7.1996 / 15:21:29 / cg"
!

timeZoneName
    "find the first zone which is in this range.
     This is a bit naive, but should be sufficient in most cases
     (for a correct result, we'd have to care for start-end dates of summer time
      of that particular year...)"

    |myUtcOffset iAmDST bestNonDST|

    myUtcOffset := self utcOffset negated.
    iAmDST := self timeInfo dst ? false.

    bestNonDST := nil.
    self class timezoneInfo inGroupsOf:3 do:[:name :offsetInMinutes :isDST|
        |thisUtcOffset|

        thisUtcOffset := offsetInMinutes * 60.
        thisUtcOffset = myUtcOffset ifTrue:[
            isDST == iAmDST ifTrue:[^ name ].
        ].    
        bestNonDST := name.
    ].
    bestNonDST notNil ifTrue:[^ bestNonDST].

    "/ nothing found - construct a standard offset string
    ^ ((self utcOffset > 0) ifTrue:['+'] ifFalse:['-'])
      , ((myUtcOffset abs // 60) printStringLeftPaddedTo:2 with:$0)
      , ((myUtcOffset abs \\ 60) printStringLeftPaddedTo:2 with:$0)

    "
     Timestamp now timeZoneName
     UtcTimestamp now timeZoneName

     (Timestamp now asTZTimestampInZone:'MEZ') timeZoneName - will find international name
     (Timestamp now asTZTimestampInZone:'EST') timeZoneName
     (Timestamp now asTZTimestampInZone:'IDLE') timeZoneName - sorry - will find 'NZST'
     (Timestamp now asTZTimestampInZone:'BRST') timeZoneName - sorry: will find military 'O'
     (Timestamp now asTZTimestampInZone:'MYT') timeZoneName - will find hongkong; same timezone
    "
!

utcOffset
    "return the difference between UTC (Greenwich Mean Time) and the local time in seconds.
     If daylight saving time applies to ourself, take that into account.

     Add utcOffset to convert from local time to UTC time.
     Subtract utcOffset to convert from UTC time to local time.

     If utcOffset is negative, the local timezone is east of Greenwich.
     If utcOffset is positive, the local timezone is west of Greenwich."

    (osTime between:MinOSTime and:MaxOSTime) ifFalse:[
	"/ fake an info which the OS cannot give me
	"/ we do not know about DST in the far future and in the long gone past.
	"/ Take the utcOffset without DST
	^ self utcOffsetWithoutDst.
    ].

    ^ (OperatingSystem computeTimeAndDateFrom:osTime) utcOffset

    "
     Timestamp now utcOffset
     (Timestamp year:1995 month:7 day:1 hour:12 minute:0 second:0) utcOffset
     (Timestamp year:1995 month:1 day:1 hour:12 minute:0 second:0) utcOffset
     (Timestamp year:1689 month:7 day:1 hour:12 minute:0 second:0) utcOffset
     (Timestamp year:4096 month:7 day:1 hour:12 minute:0 second:0) utcOffset
    "

    "Modified: 20.12.1995 / 17:28:49 / stefan"
    "Modified: 1.7.1996 / 15:21:29 / cg"
!

utcOffsetWithoutDst
    "return the difference between UTC (Greenwich Mean Time) and the local time in seconds.
     If daylight saving time applies to ourself, do not take that into account.

     Add utcOffset to convert from local time to UTC time.
     Subtract utcOffset to convert from UTC time to local time.

     If utcOffset is negative, the local timezone is east of Greenwich.
     If utcOffset is positive, the local timezone is west of Greenwich."

    |offset epochInfo|

    offset := 0.
    [
	"DST may be in winter in the southern hemisphere. If we are in DST, add some days"
	epochInfo := OperatingSystem timeInfoFromSeconds:offset milliseconds:0 localTime:true.
	offset := offset + (3600 * 24 * 90). "Add about 3 months"
    ] doWhile:[epochInfo dst and:[offset < (3600 * 24 * 365) "avoid endless loop"]].

    ^ epochInfo utcOffset

    "
     Timestamp now utcOffsetWithoutDst
    "
!

weekInYear
    "return the week number of the receiver - 1 for Jan, 1st."

    ^ Date weekInYearOf:self

    "
     (Timestamp newDay:1 year:2000) weekInYear
     (Timestamp newDay:2 year:2000) weekInYear
     (Timestamp newDay:3 year:2000) weekInYear
    "
!

weekday
    "return the week-day of the receiver as a string.
     The returned string depends on the current language setting.
     Expect things like 'monday', 'tuesday' ...
     For ST-80 compatibility"

    ^ self asDate weekday

    "
     Timestamp now weekday

     but maybe a different day there, in the south pacific:
     (Timestamp now asTZTimestampInZone:'LINT') weekday

     but maybe a different day there, in alaska:
     (Timestamp now asTZTimestampInZone:'AKST') weekday
    "
!

year
    "return the year of the receiver i.e. 1992.
     For compatibility, use instances of Date for this."

    (osTime between:MinOSTime and:MaxOSTime) ifFalse:[
	^ self asDate year.
    ].
    ^ self timeInfo year

    "
     Timestamp now year
    "

    "Modified: 1.7.1996 / 15:23:08 / cg"
! !

!Timestamp methodsFor:'arithmetic'!

ceilingSecond
    "return a timestamp which represents the next full second"

    |offs|

    offs := (self milliseconds / 1000) ceiling.
    ^ self class basicNew setSeconds:(self getSeconds + offs).

    "
     |t1 t2|

     t1 := Timestamp now.
     t2 := t1 ceilingSecond.
     self halt
    "

    "Created: / 08-01-2011 / 16:23:03 / cg"
!

floorSecond
    "return a timestamp truncated to the last full second"

    ^ self class basicNew setSeconds:(self getSeconds).

    "
     |t1 t2|

     t1 := Timestamp now.
     t2 := t1 floorSecond.
     self halt
    "

    "Created: / 08-01-2011 / 16:20:55 / cg"
!

millisecondDeltaFrom:aTimestamp
    "return the delta in milliseconds between 2 absolute times.
     The argument is supposed to be BEFORE the receiver,
	computes self - aTimestamp"

    ^ self getMilliseconds - (aTimestamp getMilliseconds)

    "
     |t1 t2|

     t1 := Timestamp now.
     Delay waitForSeconds:0.5.
     t2 := Timestamp now.
     t2 millisecondDeltaFrom:t1
    "

    "Modified: / 10-07-2010 / 09:37:18 / cg"
!

roundedToSecond
    "return a timestamp which represents the time rounded to the nearest full second"

    |offs|

    offs := (self milliseconds / 1000) rounded.
    ^ self class basicNew setSeconds:(self getSeconds + offs).

    "
     |t1 t2|

     t1 := Timestamp now.
     t2 := t1 roundedToSecond.
     self halt
    "

    "Created: / 08-01-2011 / 16:24:12 / cg"
!

secondDeltaFrom:aTimestamp
    "return the delta in seconds between 2 absolute times.
     The argument is supposed to be BEFORE the receiver,
	computes self - aTimestamp"

    ^ self getSeconds - (aTimestamp getSeconds)

    "
     |t1 t2|

     t1 := Timestamp now.
     Delay waitForSeconds:5.
     t2 := Timestamp now.
     t2 secondDeltaFrom:t1
    "

    "Modified: / 10-07-2010 / 09:37:24 / cg"
! !

!Timestamp methodsFor:'comparing'!

= aTimestamp
    "return true if the argument, aTime represents the same time.
     Notice: you can compare timestamps from different timezones for representing the
     same time, because they all store their milliseconds internally as utc time"

    aTimestamp isTimestamp ifFalse:[^ false].
    ^ (self getMilliseconds = aTimestamp getMilliseconds)

    "Modified: 3.7.1996 / 13:10:24 / cg"
!

hash
    "return an integer useful for hashing on times"

    ^ osTime // 1000

    "Modified: 3.7.1996 / 13:10:52 / cg"
! !

!Timestamp methodsFor:'converting'!

asDate
    "return a Date object from the receiver.
     The returned date will only represent the day - not the timeOfDay.
     Notice: if you convert a local timestamp, you will get the local date;
     otherwise if you convert an utcTimestamp, you'll get the utc date."

    (osTime between:MinOSTime and:MaxOSTime) ifFalse:[
	|milliDelta dayDelta|

	"/ we do not know about DST in the far future and in the long gone past.
	"/ Take the utcOffset without DST
	milliDelta := osTime - (1000 * self utcOffsetWithoutDst).
	dayDelta := milliDelta // (24 * 3600 * 1000).
	^ Epoch asDate addDays:dayDelta.
    ].
    ^ self timeInfo asDate

    "
     Timestamp now
     Timestamp now asDate
     (Timestamp now addTime:3600) asDate
     (Timestamp now addTime:3600) asTime
     Timestamp fromSeconds:(Timestamp now asSeconds + 3600)
     (Timestamp fromSeconds:(Timestamp now asSeconds + 3600)) asDate
    "
!

asLocalTimestamp
    "represent myself as a timestamp in the local timezone"

    ^ self

    "
     Timestamp now asUtcTimestamp
     Timestamp now asUtcTimestamp asLocalTimestamp
    "
!

asTZTimestamp
    "return a timestamp which represents the very same time,
     but will represent itself as a timestamp with the local utcOffset.
     Use this to make sure that a local timestamp can be read back in another timezone"

    ^ self asTZTimestamp:self utcOffset

    "see the different printStrings of:
	 Timestamp now
     and
	 Timestamp now asTZTimestamp
    "
!

asTZTimestamp:utcOffset
    "return a timestamp which represents the very same time,
     but will represent itself as a timestamp with the given utcOffset"

    ^ (TZTimestamp fromOSTime:osTime) utcOffset:utcOffset

    "what is the time now in NewYork?
     Timestamp now asTZTimestamp:(Timestamp utcOffsetFrom:'EST')
     Timestamp now asTZTimestampInZone:'EST'

     what is the time now in Stuttgart?
     Timestamp now asTZTimestamp:(Timestamp utcOffsetFrom:'MEZ')
     Timestamp now asTZTimestampInZone:'MEZ'
    "
!

asTZTimestampInZone:timeZoneName
    "return a timestamp which represents the very same time,
     but will represent itself as a timestamp in the given timezone.
     timeZoneName must be one of the standard names as listed in Timestamp >> timezoneInfo"

    |utcOffset|

    utcOffset := self class utcOffsetFrom:timeZoneName.
    utcOffset isNil ifTrue:[
        ^ TimeConversionError raiseRequestWith:self errorString:(' - Invalid/unknown timzone: %1' bindWith:timeZoneName)
    ].

    ^ self asTZTimestamp:utcOffset

    "what is the time now in NewYork?
       Timestamp now asTZTimestampInZone:'EST'

     what is the time now in Stuttgart?
       Timestamp now asTZTimestampInZone:'MEZ'

     an error os raised for any unknown/invalid timezone:
       Timestamp now asTZTimestampInZone:'BlaBla'
    "
!

asTime
    "return a Time object from the receiver.
     The returned time will only represent the timeOfDay - not the day,
     and does not include the milliseconds."

    |secondDelta|

    (osTime between:MinOSTime and:MaxOSTime) ifFalse:[
	secondDelta := osTime // 1000.
	"/ we do not know about DST in the far future and in the long gone past.
	"/ Take the utcOffset without DST
	secondDelta := (secondDelta - self utcOffsetWithoutDst) \\ (24*3600).
	^ Epoch asTime addSeconds:secondDelta.
    ].
    ^ self timeInfo asTime

    "
     Timestamp now
     Timestamp now asTime
     UtcTimestamp now asTime
     (Timestamp now addTime:3600) asTime
     (Timestamp year:2014 month:7 day:1 hour:12 minute:0 second:0) asTime
     (UtcTimestamp year:2014 month:7 day:1 hour:12 minute:0 second:0) asTime
    "
!

asTimeWithMilliseconds
    "return a Time object from the receiver.
     The returned time will only represent the timeOfDay - not the day,
     it will include the milliseconds."

    |milliSecondDelta|

    (osTime between:MinOSTime and:MaxOSTime) ifFalse:[
	milliSecondDelta := osTime - (self utcOffset * 1000).
	^ self class epoch asTime addMilliseconds:milliSecondDelta.
    ].
    ^ self timeInfo asTime

    "
     Timestamp now
     Timestamp now asTime
     UtcTimestamp now asTime
     (Timestamp now addTime:3600) asTime
     (Timestamp year:2014 month:7 day:1 hour:12 minute:0 second:0) asTime
     (UtcTimestamp year:2014 month:7 day:1 hour:12 minute:0 second:0) asTime
    "
!

asTimestamp
    "return an Timestamp object from the receiver - that's the receiver."

    ^ self
!

asUTC
    ^ self asUtcTimestamp

    "
     Timestamp now
     Timestamp now asUTC
    "
!

asUtcTimestamp
    "return a timestamp which represents the very same timestamp,
     but will represent itself as a timestamp in the UTC timezone"

    ^ UtcTimestamp fromOSTime:osTime

    "
     Timestamp now asUtcTimestamp
     Timestamp now asUtcTimestamp asLocalTimestamp
    "
!

literalArrayEncoding
    "encode myself as an array, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray.
     The encoding is:
        (#Timestamp YYYYMMDDhhmmss.iiiZ)
    "

    |s|

    s := WriteStream on:(String new:18).
    self printGeneralizedOn:s isLocal:false.

    ^ Array
        with:self class name
        with:s contents

    "
      Timestamp now literalArrayEncoding
        decodeAsLiteralArray
      UtcTimestamp now literalArrayEncoding
        decodeAsLiteralArray
    "
!

utcOffset:anOffset
   "answer a DateTime equivalent to the receiver but offset from UTC by offset"

    ^ TZTimestamp new 
        osTime:osTime;
        utcOffset:(anOffset asTimeDuration)  

    "
     Timestamp now  -- now as local time
     Timestamp now asTZTimestamp -- now in your local timezone
     Timestamp now asUtcTimestamp -- now in greenwich
     UtcTimestamp now -- now in greenwich
     Timestamp now utcOffset:(-2 hours)2015-11-09 17:29:35.803+02 -- now in East Europe
     Timestamp now utcOffset:(5 hours) -- now in Eastern time
     Timestamp now asTZTimestampInZone:'EST' -- now in Eastern time
    "
!

utcSecondsSince1901
    "return the number of seconds elapsed since Jan, 1st 1901"

"
    secondsBetween1901and1970 :=
	((Date day:1 month:1 year:1970) subtractDate:(Date day:1 month:1 year:1901))
	*  (24 * 60 * 60)
"

    ^ self utcSecondsSince1970 + 2177452800.

    "
     Timestamp now utcSecondsSince1901
    "
! !

!Timestamp methodsFor:'initialization'!

UTCyear:y month:m day:d hour:h minute:min second:s millisecond:millis
    "private: ask the operating system to compute the internal osTime (based on the epoch),
     given y,m,d and h,m,s in my time."

    self setOSTimeFromUTCYear:y month:m day:d hour:h minute:min second:s millisecond:millis
!

setOSTimeFromUTCYear:y month:m day:d hour:h minute:min second:s millisecond:millis
    "private: ask the operating system to compute the internal osTime (based on the epoch),
     given y,m,d and h,m,s in local time"

    Error handle:[:ex |
        "handler for timestamps before the epoch or after the OS representable time (2038 on current Unices).
         Then, an out-of-os-range osTime is generated here manually."

        |deltaDays|

        deltaDays := self class epoch asDate subtractDate:(Date year:y month:m day:d).
        "/ deltadays will be negative for dates before the epoch and positive if after.

        osTime := (h * 3600) + (min * 60) + s.
        osTime := osTime - (deltaDays * 24 * 3600).
        osTime := osTime * 1000.
        osTime := osTime + millis.
    ] do:[
        osTime := OperatingSystem
                computeOSTimeFromUTCYear:y month:m day:d
                hour:h minute:min second:s
                millisecond:millis
    ]
!

setOSTimeFromYear:y month:m day:d hour:h minute:min second:s millisecond:millis
    "private: ask the operating system to compute the internal osTime (based on the epoch),
     given y,m,d and h,m,s in local time. If the OS cannot do it, do it here."

    TimeConversionError handle:[:ex |
        "handler for timestamps before the epoch or after the OS representable time (2038 on current Unices).
         Then, an out-of-os-range osTime is generated here manually."

        |deltaDays|

        deltaDays := self class epoch asDate subtractDate:(Date year:y month:m day:d).
        "/ deltadays will be negative for dates before the epoch and positive if after.

        osTime := (h * 3600) + (min * 60) + s.
        osTime := osTime + self utcOffset.
        osTime := osTime - (deltaDays * 24 * 3600).
        osTime := osTime * 1000.
        osTime := osTime + millis.
    ] do:[
        osTime := OperatingSystem
                computeOSTimeFromYear:y month:m day:d
                hour:h minute:min second:s
                millisecond:millis
    ]
!

year:y month:m day:d hour:h minute:min second:s millisecond:millis
    "private: ask the operating system to compute the internal osTime (based on the epoch),
     given y,m,d and h,m,s in my time."

    self setOSTimeFromYear:y month:m day:d hour:h minute:min second:s millisecond:millis

    "
     self basicNew
         year:2016 month:4 day:16 hour:17 minute:21 second:13 millisecond:726
    "
! !


!Timestamp methodsFor:'printing & storing'!

addPrintBindingsTo:dict language:languageOrNil
    "private print support: add bindings for printing to aDictionary
     languageOrNil can only be #en or nil for the current language."

    |date|

    date := self asDate.
    date addPrintBindingsTo:dict language:languageOrNil.
    super addPrintBindingsTo:dict language:languageOrNil.

    date year == Date today year ifTrue:[
        dict at:#yearOrTime put:('%h:%m' expandPlaceholdersWith:dict).
    ].

    "
     |d|
     d := Dictionary new.
     Timestamp now addPrintBindingsTo:d language:nil.
     d inspect.
    "
    
    "used by:
        Timestamp now printStringFormat:'%y-%m-%d'
        Timestamp now printStringFormat:'%(dayOfYear)'
    "
!

printGeneralizedOn:aStream
    "append a representation of the receiver to aStream in a general format,
     top-down, without separators: 'yyyymmddHHMMSS.mmmZ'

     This format is used for the ASN.1 GeneralizedTime as defined in X.208 Sec. 33,
     so read this before changing the output format."

    ^ self printGeneralizedOn:aStream isLocal:false short:false.
!

printGeneralizedOn:aStream isLocal:isLocal
    "append a representation of the receiver to aStream in a general format,
     top-down, without separators: 'yyyymmddHHMMSS.mmm+0100'

     This format is used for the ASN.1 GeneralizedTime as defined in X.208 Sec. 33,
     so read this before changing the output format.

     If isLocal is true, represent as local time (Local 'yyyymmddHHMMSS.mmm+0100'), 
     otherwise as UTC time (UTC 'yyyymmddHHMMSS.mmmZ')."

    self printGeneralizedOn:aStream isLocal:isLocal short:false


    "Modified: / 1.7.1996 / 15:20:59 / cg"
    "Modified: / 17.1.2000 / 15:53:02 / stefan"
!

printGeneralizedOn:aStream isLocal:isLocal short:shortFormat
    "append a representation of the receiver to aStream in a general format,
     top-down, without separators;
        long format:  'yyyymmddHHMMSS.mmm+0100'
        short format: 'yymmddHHMMSS.mmm+0100'
     Using the short format is strictly discouraged!!

     This format is used for the ASN.1 GeneralizedTime and UTCTime
     as defined in X.208 Sec. 33, so read this before changing the output format.

     If isLocal is true, represent as local time (Local 'yyyymmddHHMMSS.mmm+0100'), 
     otherwise as UTC time (UTC 'yyyymmddHHMMSS.mmmZ')."

    |t off|

    isLocal ifTrue:[
        t := self timeInfo.
        off := t utcOffset.
    ] ifFalse:[
        t := self asUtcTimestamp timeInfo.
        off := 0.
    ].

    shortFormat ifTrue:[
        self assert:(t year between:1951 and:2049).
        (t year \\ 100) printOn:aStream leftPaddedTo:2 with:$0.
    ] ifFalse:[
        t year    printOn:aStream leftPaddedTo:4 with:$0.
    ].
    t month   printOn:aStream leftPaddedTo:2 with:$0.
    t day     printOn:aStream leftPaddedTo:2 with:$0.
    t hours   printOn:aStream leftPaddedTo:2 with:$0.
    t minutes printOn:aStream leftPaddedTo:2 with:$0.
    t seconds printOn:aStream leftPaddedTo:2 with:$0.
    aStream nextPut:$..
    t milliseconds printOn:aStream leftPaddedTo:3 with:$0.

    (self isUtcTimestamp or:[off == 0]) ifTrue:[
        aStream nextPut:$Z.
    ] ifFalse:[ |min|
        off < 0 ifTrue:[
            aStream nextPut:$+.
            off := off negated.
        ] ifFalse:[
            aStream nextPut:$-.
        ].
        min := off // 60.
        min // 60 printOn:aStream leftPaddedTo:2 with:$0.
        min \\ 60 printOn:aStream leftPaddedTo:2 with:$0.
    ].

    "
     Timestamp now printGeneralizedOn:Transcript. Transcript cr.
     Timestamp now printGeneralizedOn:Transcript isLocal:true. Transcript cr.
     (Timestamp fromSeconds:0) printGeneralizedOn:Transcript. Transcript cr.
     Time now printOn:Transcript. Transcript cr.
     Date today printOn:Transcript. Transcript cr.

     Timestamp now printGeneralizedOn:Transcript isLocal:false short:false. Transcript cr.
     Timestamp now printGeneralizedOn:Transcript isLocal:true short:false. Transcript cr.
     UtcTimestamp now printGeneralizedOn:Transcript isLocal:false short:false. Transcript cr.
     UtcTimestamp now printGeneralizedOn:Transcript isLocal:true short:false. Transcript cr.

     Date today asTimestamp printGeneralizedOn:Transcript. Transcript cr.
     Date today printOn:Transcript. Transcript cr.
    "

    "Modified: / 1.7.1996 / 15:20:59 / cg"
    "Modified: / 17.1.2000 / 15:53:02 / stefan"
!

printISO8601
    <resource: #obsolete>
    "print as UTC in a format like 2014-10-17T17:08:44Z"

    ^ self printStringIso8601

    "Created: / 16-06-2005 / 16:11:15 / masca"
!

printISO8601Compressed
    <resource: #obsolete>
    "return a printString as UTC in a format like 20141017T170939Z"

    ^ self printStringIso8601Compressed

    "
     Timestamp now printISO8601Compressed
    "

    "Created: / 16-06-2005 / 16:11:31 / masca"
!

printISO8601CompressedOn: aStream
    <resource: #obsolete>
    "print as UTC in a format like 20141017T170939Z on aStream"

    self printIso8601CompressedOn: aStream

    "Created: / 16-06-2005 / 16:11:50 / masca"
!

printISO8601On: aStream
    <resource: #obsolete>
    "print as UTC in a format like 2014-10-17T17:08:44Z on aStream"

    self printIso8601On: aStream

    "Created: / 16-06-2005 / 16:11:07 / masca"
!

printIso8601CompressedOn: aStream
    "print as UTC in a format like 20141017T170939Z on aStream"

    TimestampISO8601Builder printCompressed: self on: aStream

    "Created: / 16-06-2005 / 16:11:50 / masca"
!

printIso8601FormatOn:aStream
    "append the iso8601 representation of the receiver to aStream.
     This format looks like:
	1999-01-01T24:00:00
     or, for zero hr:min:sec,
	1999-01-01
     Of course, a 24 hour clock is used.

     Timezone information (eg. Z or +0100) is added, so the reader will read as local time."

    self printIso8601FormatOn:aStream timeSeparator:$T

    "
     Timestamp now printIso8601FormatOn:Transcript. Transcript cr.
     Timestamp readIso8601FormatFrom:(Timestamp now printStringIso8601Format).

     UtcTimestamp now printIso8601FormatOn:Transcript. Transcript cr.
     UtcTimestamp readIso8601FormatFrom:(UtcTimestamp now printStringIso8601Format).
    "
!

printIso8601FormatOn:aStream timeSeparator:sepChar
    "append the iso8601 representation of the receiver to aStream.
     This format looks like:
	1999-01-01T24:00:00
     or, for zero hr:min:sec,
	1999-01-01
     Of course, a 24 hour clock is used.

     Timezone information (eg. Z or +0100) is added, so the reader will read as local time."

    |asUTC asLocal|

    self isUtcTimestamp ifTrue:[
	asUTC := true. asLocal := false.
    ] ifFalse:[
	self isLocalTimestamp ifTrue:[
	    asUTC := false. asLocal := false.
	] ifFalse:[
	    asUTC := false. asLocal := false.
	]
    ].

    Timestamp::TimestampISO8601Builder
	print:self compact:false
	asLocal:asLocal asUTC:asUTC withMilliseconds:true
	timeSeparator:sepChar
	on:aStream

"/
"/    |format|
"/
"/    format := '%(year)-%(month)-%(day)T%h:%m:%s.%i'.
"/    self milliseconds = 0 ifTrue:[
"/        format := '%(year)-%(month)-%(day)T%h:%m:%s'.
"/        self seconds = 0 ifTrue:[
"/            format := '%(year)-%(month)-%(day)T%h:%m'.
"/            ((self hours = 0) and:[self minutes = 0]) ifTrue:[
"/                format := '%(year)-%(month)-%(day)'.
"/            ]
"/        ]
"/    ].
"/    self printOn:aStream format:format

    "
     Timestamp now printIso8601FormatOn:Transcript. Transcript cr.
     Timestamp readIso8601FormatFrom:(Timestamp now printStringIso8601Format).

     UtcTimestamp now printIso8601FormatOn:Transcript. Transcript cr.
     UtcTimestamp readIso8601FormatFrom:(UtcTimestamp now printStringIso8601Format).
    "
!

printIso8601On: aStream
    "print as UTC in a format like 2014-10-17T17:08:44Z on aStream"

    TimestampISO8601Builder print: self on: aStream

    "Created: / 16-06-2005 / 16:11:07 / masca"
!

printOn:aStream
    "append a user readable representation of the receiver to aStream.
     The format is compatible with readFromString:, but not with readFrom:."

    |asUTC asLocal|

    self isUtcTimestamp ifTrue:[
	asUTC := true. asLocal := false.
    ] ifFalse:[
	self isLocalTimestamp ifTrue:[
	    asUTC := false. asLocal := true.
	] ifFalse:[
	    asUTC := false. asLocal := false.
	]
    ].

    Timestamp::TimestampISO8601Builder
	print:self compact:false
	asLocal:asLocal asUTC:asUTC withMilliseconds:true
	timeSeparator:(Character space)
	on:aStream

"/    self printOn:aStream format:'%(year)-%(mon)-%(day) %h:%m:%s.%i'
"/    self printOn:aStream format:'%(Day)-%(mon)-%(year) %h:%m:%s.%i'
"/    self printOn:aStream format:'%(mon)/%(Day)/%(year) %h:%m:%s.%i'

    "
     |tHere tNewYork|

     Timestamp now printOn:Transcript. Transcript cr.
     Timestamp now asUtcTimestamp printOn:Transcript. Transcript cr.
     (Timestamp now asTZTimestamp:(Timestamp utcOffsetFrom:'EST')) printOn:Transcript. Transcript cr.

     tHere := Timestamp now.
     tNewYork := tHere asTZTimestamp:(Timestamp utcOffsetFrom:'EST').
     tHere printOn:Transcript. Transcript cr.
     tNewYork printOn:Transcript. Transcript cr.

     (Timestamp fromSeconds:0) printOn:Transcript. Transcript cr.
     Time now printOn:Transcript. Transcript cr.
     Date today printOn:Transcript. Transcript cr.

     Time now asTimestamp printOn:Transcript. Transcript cr.
     Timestamp now printOn:Transcript. Transcript cr.

     Date today asTimestamp printOn:Transcript. Transcript cr.
     Date today printOn:Transcript. Transcript cr.
    "

    "Modified: 1.7.1996 / 15:20:59 / cg"
!

printRFC1123FormatOn:aStream
    "append the RFC1123 representation of the receiver to aStream.
     This format is used in HTTP requests and looks like:
	'Fri, 04 Jul 2003 15:56:11 GMT'
     (always GMT and all names in english)"

"/       HTTP-date      = rfc1123-date | rfc850-date | asctime-date
"/
"/       rfc1123-date   = wkday "," SP date1 SP time SP "GMT"
"/       rfc850-date    = weekday "," SP date2 SP time SP "GMT"
"/       asctime-date   = wkday SP date3 SP time SP 4DIGIT
"/
"/       date1          = 2DIGIT SP month SP 4DIGIT
"/                        ; day month year (e.g., 02 Jun 1982)
"/       date2          = 2DIGIT "-" month "-" 2DIGIT
"/                        ; day-month-year (e.g., 02-Jun-82)
"/       date3          = month SP ( 2DIGIT | ( SP 1DIGIT ))
"/                        ; month day (e.g., Jun  2)
"/
"/       time           = 2DIGIT ":" 2DIGIT ":" 2DIGIT
"/                        ; 00:00:00 - 23:59:59
"/
"/       wkday          = "Mon" | "Tue" | "Wed"
"/                      | "Thu" | "Fri" | "Sat" | "Sun"
"/
"/       weekday        = "Monday" | "Tuesday" | "Wednesday"
"/                      | "Thursday" | "Friday" | "Saturday" | "Sunday"
"/
"/       month          = "Jan" | "Feb" | "Mar" | "Apr"
"/                      | "May" | "Jun" | "Jul" | "Aug"
"/                      | "Sep" | "Oct" | "Nov" | "Dec"

    |timeInfo|

    timeInfo := self asUtcTimestamp timeInfo.

    aStream nextPutAll:(#('Mon' 'Tue' 'Wed' 'Thu' 'Fri' 'Sat' 'Sun') at:timeInfo dayInWeek);
	    nextPutAll:', '.
    timeInfo day printOn:aStream leftPaddedTo:2 with:$0.
    aStream space.
    aStream nextPutAll:(#('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec') at:timeInfo month).

    "/ the following is too slow for heavy use
    "/    timeInfo printOn:aStream format:'%(ShortDayName), %(day) %(ShortMonthName) %y %h:%m:%s GMT' language:#en.

    aStream nextPut:Character space.
    timeInfo year printOn:aStream.
    aStream nextPut:Character space.
    timeInfo hours printOn:aStream leftPaddedTo:2 with:$0.
    aStream nextPut:$:.
    timeInfo minutes printOn:aStream leftPaddedTo:2 with:$0.
    aStream nextPut:$:.
    timeInfo seconds printOn:aStream leftPaddedTo:2 with:$0.
    aStream nextPutAll:' GMT'.

    "
     String streamContents:[:s| Timestamp now printRFC1123FormatOn:s]
    "
!

printStringIso8601
    "return a printString as UTC in a format like 2014-10-17T17:08:44Z"

    ^ TimestampISO8601Builder print: self

    "
     Timestamp now printStringIso8601
    "

    "Created: / 16-06-2005 / 16:11:15 / masca"
!

printStringIso8601Compressed
    "return a printString as UTC in a format like 20141017T170939Z"

    ^ TimestampISO8601Builder printCompressed: self

    "
     Timestamp now printStringIso8601Compressed
    "

    "Created: / 16-06-2005 / 16:11:31 / masca"
!

printStringIso8601Format
    "return the Iso8601 representation of the receiver with local timezon information.
     This format looks like:
	1999-01-01T24:00:00
     or, for zero hr:min:sec,
	1999-01-01
     Of course, a 24 hour clock is used."

    ^ String streamContents:[:s | self printIso8601FormatOn:s]

    "
     Timestamp now printStringIso8601Format
    "
!

printStringRFC1123Format
    "return the RFC1123 representation of the receiver.
     This format is used in HTTP requests and looks like:
	'Fri, 04 Jul 2003 15:56:11 GMT'
     (always GMT)"

    ^ String streamContents:[:s | self printRFC1123FormatOn:s]

    "
     Timestamp now printStringRFC1123Format
    "
!

storeOn:aStream
    "store the receiver in a format suitable for reconstruction of the
     receiver via readFrom:
     Use a OS/architecture independent format"

    aStream nextPut:$(;
	    nextPutAll:self storeStringClass name;
	    nextPutAll:' readIso8601FormatFrom:'''.
    self printIso8601FormatOn:aStream.
    aStream nextPutAll:''')'.

    "
     Timestamp now storeString

     Object readFrom:(Timestamp now storeString) readStream
     Timestamp readFrom:(Timestamp now storeString) readStream
    "
!

storeStringClass
    ^ self class
! !

!Timestamp methodsFor:'private'!

computeTimeInfo
    |d t info|

    "/ fake an info which the OS cannot give me
    d := self asDate.
    t := self asTime.
    info := OperatingSystem timeInfoClass new.
    info year:d year month:d month day:d day
	 hours:t hours minutes:t minutes seconds:t seconds milliseconds:self milliseconds
	 utcOffset:(self utcOffset) dst:false dayInYear:d dayInYear dayInWeek:d dayInWeek.
    ^ info

    "
	(Timestamp year:1592 month:7 day:1 hour:12 minute:0 second:0 millisecond:555) computeTimeInfo
	(Timestamp year:4096 month:7 day:1 hour:12 minute:0 second:0 millisecond:555) computeTimeInfo
    "
!

computeUtcTimeInfo
    |utcTimestamp d t info|

    "/ fake an info which the OS cannot give me
    utcTimestamp := self asUtcTimestamp.
    d := utcTimestamp asDate.
    t := utcTimestamp asTime.
    info := OperatingSystem timeInfoClass new.
    info year:d year month:d month day:d day
	 hours:t hours minutes:t minutes seconds:t seconds milliseconds:self milliseconds
	 utcOffset:0 dst:false dayInYear:d dayInYear dayInWeek:d dayInWeek.
    ^ info

    "
	(Timestamp year:1950 month:7 day:1 hour:12 minute:0 second:0) timeInfo
	(Timestamp year:1592 month:7 day:1 hour:12 minute:0 second:0) computeUtcTimeInfo
	(Timestamp year:4096 month:7 day:1 hour:12 minute:0 second:0) computeUtcTimeInfo
    "
!

fromOSTime:anUninterpretedOSTime
    "strictly private: set the milliseconds from an OS time (since the epoch).
     Notice: timestamps always have millisecond precision (in contrast to Time, where it is optional)"

    osTime := anUninterpretedOSTime

    "Created: 1.7.1996 / 14:33:21 / cg"
!

fromOSTimeWithMilliseconds:anUninterpretedOSTime
    "strictly private: set the milliseconds from an OS time (since the epoch)"

    osTime := anUninterpretedOSTime
!

getMilliseconds
    "strictly private: return the milliseconds (since the epoch) in utc"

    ^ osTime

    "Created: 1.7.1996 / 14:33:56 / cg"
!

getSeconds
    "strictly private: return the seconds (since the epoch) in utc"

    ^ osTime // 1000
!

setMilliseconds:millis
    "strictly private: set the milliseconds (since the epoch)"

    osTime := millis.

    "Modified: 20.12.1995 / 11:46:36 / stefan"
    "Created: 1.7.1996 / 14:34:24 / cg"
!

setSeconds:secs
    "strictly private: set the seconds (since whatever)"

    osTime := (secs * 1000).

    "Modified: 20.12.1995 / 11:46:36 / stefan"
    "Modified: 1.7.1996 / 14:34:10 / cg"
!

timeInfo
    (osTime between:MinOSTime and:MaxOSTime) ifFalse:[
	"/ fake an info which the OS cannot give me
	^ self computeTimeInfo
    ].

    ^ OperatingSystem computeTimeAndDateFrom:osTime

    "
	(Timestamp year:1950 month:7 day:1 hour:12 minute:0 second:0) timeInfo
	(UtcTimestamp year:1950 month:7 day:1 hour:12 minute:0 second:0) timeInfo
    "
!

utcSecondsSince1970
    "return the UTC seconds since 1970"

    ^ self getSeconds

    "
     Timestamp now utcSecondsSince1970
    "
!

utcTimeInfo
    (osTime between:MinOSTime and:MaxOSTime) ifFalse:[
	"/ fake an info which the OS cannot give me
	^ self computeUtcTimeInfo
    ].

    ^ OperatingSystem computeUTCTimeAndDateFrom:osTime

    "
	(Timestamp year:1950 month:7 day:1 hour:12 minute:0 second:0) timeInfo
	(Timestamp year:1950 month:7 day:1 hour:12 minute:0 second:0) utcTimeInfo
    "
! !



!Timestamp methodsFor:'testing'!

isLocalTimestamp
    "return true, if I am a local timestamp"

    ^ true
!

isTimestamp
    "return true, if I am a timestamp"

    ^ true
!

isUtcTimestamp
    "return true, if I am a utc timestamp"

    ^ false
! !

!Timestamp methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitTimestamp:with: to aVisitor."

    ^ aVisitor visitTimestamp:self with:aParameter
! !

!Timestamp::TimestampBuilderAbstract methodsFor:'error reporting'!

malformed:aString
    TimeConversionError raiseErrorString:(' - ', aString)

    "Created: / 15-06-2005 / 15:54:04 / masca"
! !

!Timestamp::TimestampBuilderAbstract methodsFor:'support'!

addHoursAndMinutes: arrayWithHoursAndMinutes
    "Add the given number of hours and minutes to the current timestamp state. If the time
    is to be subtracted, both numbers in the array must be negated. When the are not the same
    sign, the behavior may be strange. It's intended only for time zone corrections, where
    not more than 14 (in fact, 23) hours is added or subtracted (ie. date can be modified only
    one day forward or backward)."

    | hours minutes |

    hours := arrayWithHoursAndMinutes first.
    minutes := arrayWithHoursAndMinutes second.

    utcOffset := (((hours * 60) + minutes) * 60).

    minutes isZero ifFalse: [
        minute := minute + minutes.
        minute >= 60 ifTrue: [
            hours := hours + 1.
            minute := minute - 60.
        ].
        minute < 0 ifTrue: [
            hours := hours - 1.
            minute := minute + 60.
        ]
    ].

    "Hours may get zero by time zone specification or by minutes modifications above."
    hours isZero ifTrue: [^self].

    "Add or subtract the hour and make date corrections if necessary."
    hour := hour + hours.
    hour < 0 ifTrue: [
        "Oops, got to previous day, must adjust even the date."
        hour := 24 - ((hour negated) \\ 24).
        day := day - 1.
        day <= 0 ifTrue: [
            "Go to previous month..."
            month := month - 1.
            month <= 0 ifTrue: [year := year - 1. month := 12].
            day := self lastDayInMonth: month
        ]
    ].
    hour >= 24 ifTrue: [
        hour := hour \\ 24.
        day := day + 1.
        day > (self lastDayInMonth: month) ifTrue: [
            month := month + 1.
            month > 12 ifTrue: [year := year + 1. month := 1].
            day := 1
        ]
    ]

    "Created: / 15-06-2005 / 16:45:49 / masca"
    "Modified: / 16-06-2005 / 15:04:45 / masca"
!

dateFromDayNumber: dayInYear
    "Set month and day from an absolute number of the day in the year. 1.1. is day number one."

    |monthAndDay|

    (dayInYear between: 1 and: 365) ifFalse: [
	(dayInYear = 366 and:[self leapYear: year])
	    ifFalse: [self malformed: 'Bad day number: ' , dayInYear printString]
    ].

    monthAndDay := Date monthAndDayFromDayInYear:dayInYear forYear:year.
    month := monthAndDay at:1.
    day := monthAndDay at:2

    "Created: / 15-06-2005 / 11:27:35 / masca"
    "Modified: / 16-06-2005 / 12:31:37 / masca"
!

dateFromWeek: weekInteger andWeekday: dayInteger
    "Compute the month and day. Find the first day (weekday) in the year, maybe even
    adjust the year. Both week and day are 1-based, the first week in a year is the one
    with thursday (or the one containing 4.1.)."

    |tmpDate|

    "Check numbers. Year may be checked if it contains 53 weeks or 52 weeks only."
    (dayInteger between: 1 and: 7) ifFalse: [self malformed: 'Bad weekday number: ' , dayInteger printString].
    (weekInteger between: 1 and: 53) ifFalse: [self malformed: 'Bad week number: ' , weekInteger printString].

    tmpDate := Date newDayInWeek:dayInteger week:weekInteger year:year.
    day := tmpDate day.
    month := tmpDate month.
    year := tmpDate year.
!

isAllowedDay: anInteger
    "Answer whether the given day is allowed in the current month."

    ^anInteger between: 1 and: (self lastDayInMonth: month)

    "Created: / 15-06-2005 / 16:22:51 / masca"
!

lastDayInMonth: anInteger
    "Answer the number of the last day of the given month in the current year."

    ^ anInteger = 2
	ifTrue: [(self leapYear: year) ifTrue: [29] ifFalse: [28]]
	ifFalse: [#(31 28 31 30 31 30 31 31 30 31 30 31) at: month]

    "Created: / 15-06-2005 / 17:12:31 / masca"
!

leapYear: anInteger
    ^ Date leapYear:anInteger.
!

timestampWithClass:timestampClass
    "Answer the timestamp as it has been parsed."
    "Notes:
     - When reading, the time has either been adjusted to UTZ/zulu or explicit offset time,
       or is a local time stamp.
     Attention: an explicit utcOffset in the input string has already been added into the hh:mm values."

    (timestampClass == UtcTimestamp) ifTrue:[
	^ UtcTimestamp
	    UTCYear: year month: month day: day
	    hour: hour minute: minute second: second millisecond: millisecond
    ].
    (timestampClass == TZTimestamp) ifTrue:[
	"/ Attention: an explicit utcOffset in the input string has already been added into the hh:mm values."
	^ ((TZTimestamp
	    UTCYear: year month: month day: day
	    hour: hour minute: minute second: second millisecond: millisecond) utcOffset:utcOffset)
    ].

    (isUtcTime or:[hasTimezone and:[utcOffset == 0]]) ifTrue:[
	^ ((timestampClass == Timestamp) ifTrue:UtcTimestamp ifFalse:timestampClass)
	    UTCYear: year month: month day: day
	    hour: hour minute: minute second: second millisecond: millisecond
    ].
    hasTimezone ifTrue:[
	"/ Attention: an explicit utcOffset in the input string has already been added into the hh:mm values."
	^ (((timestampClass == Timestamp) ifTrue:TZTimestamp ifFalse:timestampClass)
	    UTCYear: year month: month day: day
	    hour: hour minute: minute second: second millisecond: millisecond) utcOffset:utcOffset
    ].
    "/ there was no timezone info, so make it a local timestamp again.
    ^ (timestampClass
	year: year month: month day: day
	hour: hour minute: minute second: second millisecond: millisecond)
!

yearAlreadyReadAs:yearArg
    "support for readers which may have already preread the year"

    year := yearArg.
    yearAlreadyRead := true.
! !

!Timestamp::TimestampISO8601Builder class methodsFor:'documentation'!

documentation
"
    TimestampISO8601Builder is designed to read any (almost) format of ISO 8601 encoded timestamp.
    Also, class methods can be used to print but the main reading job is done in instance protocol.
    It has been written because of insufficient abilities of Timestamp #readIso8601FormatFrom: method
    (which was now changed to call this as well).

    It produces timestamps, i.e. when the string (or stream) contains only a time, an error will result
    (it may also pass in some cases but with the time undestood as date). It survives incomplete dates,
    broken years, incomplete times and timezones. All times read with timezone difference are recomputed
    to UTC before the timestamp is created (even passing across new year boundary is handled correctly).
    Unknown offsets (usually local) are considered UTC - this may be wrong and more work is probably needed.
    All data is checked for validity (including leap years, leap seconds,...) during reading and as soon as
    possible.
    For an example of what the builder can read, see the examples method and ISO 8601 itself.

    [author:]
	Martin Dvorak (masca@volny.cz)

    [instance variables:]
	stream          A stream the builder operates on. Assigned on each call to instance method #read:,
			so the builder instance can be reused (by at most one thread).
	year            Current timestamp year. No default value, date must be present.
	month           Current timestamp month. May change during parsing. Defaults to 1.
	day             Current timestamp day. Defaults to 1.
	hour            Current timestamp hour. Defaults to 0.
	minute          Current timestamp minute. Defaults to 0.
	second          Current timestamp second. Defaults to 0.
	millisecond     Current timestamp millisecond. Defaults to 0.

    [see also:]
	Timestamp
"
!

examples
"
    See the unit tests in exept:regression >> RegressionTests::timeAndDateTest
    It covers the main features this builder has.

    Just to introduce some coding examples, try:
        Timestamp readISO8601From: (TimestampISO8601Builder print: Timestamp now)
        UtcTimestamp readISO8601From: (TimestampISO8601Builder print: UtcTimestamp now)
        Timestamp readISO8601From: (TimestampISO8601Builder print: UtcTimestamp now)
        Timestamp readISO8601From: (TimestampISO8601Builder print: TZTimestamp now)

    Timestamp readISO8601From:'fooBar' onError:[ Timestamp now ].
"
!

history
    "Created: / 16-06-2005 / 16:28:38 / masca"
! !

!Timestamp::TimestampISO8601Builder class methodsFor:'printing'!

print: aTimestamp
    "Returns the printString of the given timestamp in general ISO8601 format,
     such as '2014-11-06T11:48:09Z'.
     The time is printed as UTC time"

    | stream |

    stream := '' writeStream.
    self print: aTimestamp on: stream.
    ^ stream contents

    "
     self print:(Timestamp now)
    "

    "Created: / 15-06-2005 / 17:52:29 / masca"
!

print:aTimestamp asLocal:asLocal on:aStream
    "Print the given timestamp in general ISO8601 format,
     such as '2014-11-06T11:48:09Z'.
     The time is always printed as UTC time"

    self print:aTimestamp compact:false asLocal:asLocal asUTC:asLocal not withMilliseconds:true on:aStream

    "
     self print:(Timestamp now) on:Transcript
    "

    "Created: / 15-06-2005 / 17:56:51 / masca"
!

print:aTimestamp on:aStream
    "Print the given timestamp in general ISO8601 format,
     such as '2014-11-06T11:48:09Z'.
     The time is printed as UTC time"

    self print:aTimestamp compact:false asLocal:false asUTC:true withMilliseconds:true on:aStream

    "
     self print:(Timestamp now) on:Transcript
    "

    "Created: / 15-06-2005 / 17:56:51 / masca"
!

printAsLocalTime: aTimestamp on: aStream
    "Print the given timestamp in general ISO8601 format,
     such as '2014-11-06T11:48:09+01'.
     The time is printed as local time"

    self print:aTimestamp compact:false asLocal:true asUTC:false withMilliseconds:true on:aStream

    "
     self printAsLocalTime:(Timestamp now) on:Transcript
    "
!

printCompressed: aTimestamp
    "Return a printString in compressed format such as '20141106T114636Z'.
     (for example, for timestamp interchange with mobile devices).
     The time is printed as UTC time"

    | stream |

    stream := '' writeStream.
    self printCompressed: aTimestamp on: stream.
    ^ stream contents

    "
     self printCompressed:(Timestamp now)
    "

    "Created: / 15-06-2005 / 17:52:52 / masca"
!

printCompressed:aTimestamp asLocal:asLocal on: aStream
    "generates a compressed string representation, such as '20141106T114636Z'"

    self print:aTimestamp compact:true asLocal:asLocal asUTC:asLocal not withMilliseconds:true on:aStream

    "
     self printCompressed:(Timestamp now) on:Transcript
    "

    "Created: / 15-06-2005 / 17:54:17 / masca"
!

printCompressed: aTimestamp on: aStream
    "generates a compressed string representation, such as '20141106T114636Z'.
     The time is printed as UTC time"

    self print:aTimestamp compact:true asLocal:false asUTC:true withMilliseconds:true on:aStream

    "
     self printCompressed:(Timestamp now) on:Transcript
    "

    "Created: / 15-06-2005 / 17:54:17 / masca"
!

printCompressedAsLocalTime: aTimestamp on: aStream
    "generates a compressed string representation, such as '20141106T114636Z'.
     The time is printed as local time"

    self print:aTimestamp compact:true asLocal:true asUTC:false withMilliseconds:true on:aStream

    "
     self printCompressed:(Timestamp now) on:Transcript
    "

    "Created: / 15-06-2005 / 17:54:17 / masca"
!

printTimeZone:tzOffsetArg on: aStream
    "Print the timezone delta"

    |tzOffset tzHours tzMinutes|

    tzOffset := tzOffsetArg.
    tzOffset == 0 ifTrue:[
	aStream nextPutAll:'+00'.
    ] ifFalse:[
	tzOffset := tzOffset // 60.     "/ convert from seconds to minutes
	tzOffset < 0 ifTrue:[
	    tzOffset := tzOffset negated.
	    aStream nextPut:$+
	] ifFalse:[
	    aStream nextPut:$-.
	].

	tzHours := tzOffset // 60.
	tzMinutes := tzOffset \\ 60.
	(tzHours ~= 0 or:[tzMinutes ~= 0]) ifTrue:[
	    aStream
		nextPutAll:(tzHours printStringRadix: 10 size: 2 fill: $0).
	    tzMinutes ~= 0 ifTrue:[
		aStream
		    nextPut: $:;
		    nextPutAll: (tzMinutes printStringRadix: 10 size: 2 fill: $0).
	    ].
	].
    ].

    "
     self print:(Timestamp now) asLocal:true on:Transcript.
     Transcript cr.

     self print:(Timestamp now) asLocal:false on:Transcript.
     Transcript cr.

     self printCompressed:(Timestamp now) asLocal:true on:Transcript.
     Transcript cr.

     self printCompressed:(Timestamp now) asLocal:false on:Transcript.
     Transcript cr.
    "
! !

!Timestamp::TimestampISO8601Builder class methodsFor:'printing - basic'!

print: aTimestamp compact:compact asLocal:asLocal asUTC:asUTC withMilliseconds:withMillis on: aStream
    "Print the given timestamp in general ISO8601 format,
     such as '2014-11-06T11:48:09Z'.
	compact: if true, the compact format (without separating dashes and colons is generated)
	asLocal: if true, generates a localtime string (with the machine's current timezone setting)
	asUTC: if true, generates a utc string
	    if both are false:
		generate a string depending on the type of timestamp:
		    if local: generate a local timezone string
		    if utc: generate a utc string
		    otherwise it is a timestamp from another timezone (TZTimestamp), then print in its timezone
	withMilliseconds: if false, no milliseconds are generated"

    self
	print:aTimestamp
	compact:compact asLocal:asLocal asUTC:asUTC
	withMilliseconds:withMillis
	timeSeparator:$T
	on:aStream

    "
     self print:(Timestamp now) on:Transcript
     self printAsLocalTime:(Timestamp now) on:Transcript
     self printAsLocalTime:(Timestamp now asTZTimestamp:-7200) on:Transcript
    "
!

print:aTimestamp compact:compact asLocal:asLocal asUTC:asUTC withMilliseconds:withMillis timeSeparator:tSep on:aStream
    "Print the given timestamp in general ISO8601 format,
     such as '2014-11-06T11:48:09Z'.
        compact: if true, the compact format (without separating dashes and colons is generated)
        asLocal: if true, generates a localtime string (without any timezone info)
        asUTC: if true, generates a utc string
            if both are false:
                generate a string depending on the type of timestamp:
                    if local: generate a local timezone string
                    if utc: generate a utc string
                    otherwise it is a timestamp from another timezone (TZTimestamp), then print in its timezone
        withMilliseconds: if false, no milliseconds are generated"

    |timeInfo millis |

    asLocal ifTrue:[
        "/ force local
        timeInfo := aTimestamp asLocalTimestamp timeInfo.
    ] ifFalse:[
        asUTC ifTrue:[
            "/ force utc
            timeInfo := aTimestamp asUtcTimestamp timeInfo.
        ] ifFalse:[
            "/ in the timestamps own format
            timeInfo := aTimestamp timeInfo.
        ]
    ].

    timeInfo year printOn:aStream leftPaddedTo:4 with:$0.
    compact ifFalse:[ aStream nextPut: $- ].
    timeInfo month printOn:aStream leftPaddedTo:2 with:$0.
    compact ifFalse:[ aStream nextPut: $- ].
    timeInfo day printOn:aStream leftPaddedTo:2 with:$0.
    aStream nextPut:tSep.
    timeInfo hours printOn:aStream leftPaddedTo:2 with:$0.
    compact ifFalse:[ aStream nextPut: $:].
    timeInfo minutes printOn:aStream leftPaddedTo:2 with:$0.

    "always print the seconds, even if 0. 
     According to http://www.w3.org/TR/xmlschema11-2/#dateTime  this is mandatory"

    compact ifFalse:[ aStream nextPut: $:].
    timeInfo seconds printOn:aStream leftPaddedTo:2 with:$0.

    millis := withMillis ifTrue:[timeInfo milliseconds] ifFalse:[0].
    millis ~= 0 ifTrue:[
        aStream nextPut: $..
        millis printOn:aStream leftPaddedTo:3 with:$0.
    ].

    asUTC ifTrue:[
        aStream nextPut: $Z
    ] ifFalse:[
        asLocal ifFalse:[
            self printTimeZone:aTimestamp utcOffset on:aStream.
        ].
    ].

    "
     self print:(Timestamp now) on:Transcript
     self printAsLocalTime:(Timestamp now) on:Transcript
     self printAsLocalTime:(Timestamp now asTZTimestamp:-7200) on:Transcript
    "

    "Created: / 15-06-2005 / 17:56:51 / masca"
! !

!Timestamp::TimestampISO8601Builder class methodsFor:'public parsing'!

read: stringOrStream withClass:timestampClass
    ^ self new read:stringOrStream withClass:timestampClass

    "Created: / 15-06-2005 / 17:52:03 / masca"
!

read: stringOrStream withClass:timestampClass yearAlreadyReadAs:yearArg
    "support for readers which may have already preread the year"

    ^ self new
	yearAlreadyReadAs:yearArg;
	read:stringOrStream withClass:timestampClass

    "Created: / 15-06-2005 / 17:52:03 / masca"
! !

!Timestamp::TimestampISO8601Builder methodsFor:'private-reading'!

nextDigit
    | char |

    char := stream peekOrNil.
    char isNil ifTrue: [^-1].

    char isDigit ifTrue: [
	stream next.
	^ char codePoint - $0 codePoint
    ].
    ^ -1

    "Created: / 14-06-2005 / 11:48:52 / masca"
!

nextDigitOrError

    | digit |
    digit := self nextDigit.
    ^ digit < 0
	ifTrue: [self malformed: 'No digit found']
	ifFalse: [digit]

    "Created: / 15-06-2005 / 10:57:00 / masca"
    "Modified: / 15-06-2005 / 17:22:52 / masca"
!

nextDigits: anInteger

    | char number |
    number := 0.
    anInteger timesRepeat: [
	char := stream peekOrNil.
	char ifNil: [self malformed: 'Stream does not contain all ' , anInteger printString , ' digits'].
	char isDigit
	    ifTrue: [
		stream next.
		number := number * 10 + char codePoint - $0 codePoint]
	    ifFalse: [self malformed: 'Requested ' , anInteger printString , ' digits not found']
    ].
    ^ number

    "Created: / 14-06-2005 / 11:57:22 / masca"
    "Modified: / 15-06-2005 / 15:54:29 / masca"
! !

!Timestamp::TimestampISO8601Builder methodsFor:'public processing'!

read:stringOrStream withClass:timestampClass
    | peek |

    stream := stringOrStream readStream.

    month := day := 1.
    hour := minute := second := millisecond := 0.
    isUtcTime := hasTimezone := false.
    utcOffset := 0.

    yearAlreadyRead ~~ true ifTrue:[
        "Read the year. This will read and swallow up to four year digits."
        self readYear.
    ].

    "Check if date has been read, ie. T or space necountered. If yes, read the time.
    There is possible inconsistency - a dash may be read followed by T, which is not
    valid. But don't mind that, timestamps will be well-formatted in most cases."
    peek := stream peekOrNil.
    peek ifNil: [
        "End of stream, only year has been read."
        ^ self timestampWithClass:timestampClass].
    peek == $- ifTrue: [
        "Skip the dash after year, if present."
        stream next.
        peek := stream peekOrNil].
    peek := peek asUppercase.

    (peek == $T or: [peek == Character space])
        ifTrue: [
            "Got time signature. Skip the signature, read time and answer the timestamp."
            stream next.
            peek == Character space ifTrue:[stream skipSeparators].
            self readTime.
            self readTimezone.
            ^ self timestampWithClass:timestampClass
        ]
        ifFalse: [
            "Date not read completely yet, expecting month/day or week/day or day"
            peek == $W
                ifTrue: [
                    "Parse week number and (possibly) day number."
                    stream next.
                    self readWeekNumber]
                ifFalse: [
                    "Got digit, read month number followed by day or day number."
                    self readMonthOrDay]
        ].

    peek := stream peekOrNil.
    peek ifNil: [
        "End of stream, only year has been read."
        ^ self timestampWithClass:timestampClass].

    (peek asUppercase == $T or: [peek == Character space])
        ifTrue: [
            "Got time signature, expecting time follows. Otherwise only date was in the stream."
            stream next.
            peek == Character space ifTrue:[stream skipSeparators].
            self readTime.
            self readTimezone
        ].

    ^ self timestampWithClass:timestampClass

    "Created: / 14-06-2005 / 11:45:04 / masca"
    "Modified: / 16-06-2005 / 10:15:35 / masca"
! !

!Timestamp::TimestampISO8601Builder methodsFor:'reading'!

readFraction
    "Read an arbitrary number of digits representing a fraction."

    ^ Fraction readDecimalFractionFrom:stream onError:[self malformed: 'Missing digits after fraction separator'].
"/
"/    | anyDigit digit factor fraction |
"/
"/    factor := (1 / 10).
"/    fraction := 0.
"/    anyDigit := false.
"/
"/    [
"/        digit := self nextDigit.
"/        digit >= 0
"/    ] whileTrue: [
"/        anyDigit := true.
"/        fraction := digit * factor + fraction.
"/        factor := (factor / 10)
"/    ].
"/
"/    anyDigit ifFalse: [self malformed: 'Missing digits after fraction separator'].
"/    ^ fraction
"/
!

readMilliseconds
    "Read an arbitrary number of digits representing milliseconds. As the timestamp can
    hold only integer amounts of milliseconds, don't mind the rest of the digits."

    millisecond := (self readFraction * 1000) asInteger
"/    | digit factor |
"/
"/    factor := 100.
"/
"/    [
"/        digit := self nextDigit.
"/        digit >= 0
"/    ] whileTrue: [
"/        factor > 0 ifTrue: [
"/            "Factor still > 0, did not read all three digits of mantissa."
"/            millisecond := digit * factor + millisecond.
"/            factor := (factor / 10) integerPart
"/        ]
"/    ].
"/
"/    factor = 100 ifTrue: [self malformed: 'No digits after millisecond separator']

    "Created: / 15-06-2005 / 15:25:45 / masca"
!

readMonthOrDay
    "Read month number, optionally followed by day, or absolute day number (three digit)."

    | dayDigit1 dayDigit2 |
    month := self nextDigits: 2.

    stream peekOrNil = $-
	ifTrue: [
	    "Got dash. Day number must follow."
	    stream next.
	    day := self nextDigits: 2.
	    (self isAllowedDay: day) ifFalse: [self malformed: 'Bad day: ' , day printString].
	    ^self].

    dayDigit1 := self nextDigit.
    dayDigit1 < 0 ifTrue: [
	"No more digits than month, leave day unspecified."
	(month between: 1 and: 12) ifFalse: [self malformed: 'Bad month: ' , month printString].
	^self].

    dayDigit2 := self nextDigit.
    dayDigit2 < 0
	ifTrue: [
	    "Read only three digits, this is absolute day number in a year."
	    self dateFromDayNumber: month * 10 + dayDigit1]
	ifFalse: [
	    "Read four digits. So there's month and day."
	    (month between: 1 and: 12) ifFalse: [self malformed: 'Bad month: ' , month printString].
	    day := dayDigit1 * 10 + dayDigit2.
	    (self isAllowedDay: day) ifFalse: [self malformed: 'Bad day: ' , day printString]]

    "Created: / 15-06-2005 / 11:12:02 / masca"
    "Modified: / 16-06-2005 / 11:47:34 / masca"
!

readTime
    "Date read, don't mind it. Read only the time value."

    | peek f |

    hour := self nextDigits: 2.
    (hour between: 0 and: 24) ifFalse: [self malformed: 'Bad hour: ' , hour printString].

    peek := stream peekOrNil.
    peek isNil ifTrue: [^self].
    (peek == $:) ifTrue: [
        "/ read minutes
        stream next.
        minute := self nextDigits: 2.
    ] ifFalse: [
        peek isDigit ifTrue: [
            "/ read minutes
            minute := self nextDigits: 2.
        ] ifFalse:[
            (peek == $. or:[peek == $,]) ifTrue:[
                stream next.
                minute := self readFraction * 60.
            ] ifFalse:[
                ^ self.
            ].
        ]
    ].

    minute isInteger ifFalse:[
        f := minute.
        minute := f truncated.
        second := (f - minute) * 60.
        second isInteger ifFalse:[
            f := second.
            second := f truncated.
            millisecond := (f - second) * 1000.
            millisecond := millisecond rounded.
        ].
    ].
    (minute between: 0 and: 59) ifFalse: [self malformed: 'Bad minute: ' , minute printString].

    peek := stream peekOrNil.
    peek isNil ifTrue: [^self].
    (peek == $:) ifTrue: [
        "/ read seconds
        stream next.
        second := self nextDigits: 2.
    ] ifFalse: [
        peek isDigit ifTrue: [
            "/ read seconds
            second := self nextDigits: 2.
        ] ifFalse:[
            (peek == $. or:[peek == $,]) ifTrue:[
                stream next.
                second := self readFraction * 60.
            ] ifFalse:[
                ^ self.
            ].
        ]
    ].

    second isInteger ifFalse:[
        f := second.
        second := f truncated.
        millisecond := (f - second) * 1000.
        millisecond := millisecond rounded.
    ].
    (second between: 0 and: 59) ifFalse: [
        "Seconds are usually in this range, do a special check for leap seconds."
        second <= 61
            ifTrue: [
                "Leap seconds can occur only on midnight on 31.12. or 30.6. Don't check year
                as it's not deterministic."
                (minute = 59 and: [hour = 23 and: [(month = 12 and: [day = 31]) or: [month = 6 and: [day = 30]]]])
                    ifFalse: [self malformed: 'Bad leap second']]
            ifFalse: [self malformed: 'Bad second: ' , second printString]
    ].

    "Hour, minute and second read. Read appendices."
    ((peek := stream peekOrNil) == $. or:[peek == $,])
        ifTrue: [
            "Read dot. Skip it and read milliseconds."
            stream next.
            self readMilliseconds].

    hour = 24 ifTrue: [
        (minute = 0 and: [second = 0 and: [millisecond = 0]])
            ifTrue: [
                "On 24 hour, advance to the next day."
                "hour := 0.
                self addMinutes: 1440"]
            ifFalse: [self malformed: 'Bad 24 hour (minutes, seconds and millis not 0)']
    ]

    "Created: / 14-06-2005 / 17:27:00 / masca"
    "Modified: / 30-06-2005 / 11:34:38 / masca"
!

readTimezone
    "Read time zone information. There are three possibilities of what can occur.
    If there is nothing more to read, the offset is unknown - this is treated as
    Zulu time as this may not be true."

    | peek tzOffset |

    peek := stream peek.
    peek ifNil: [^self].
    peek := peek asUppercase.

    "If the time is in Zulu, don't modify the timestamp. This makes the machine
    run in Zulu time zone, maybe some corrections would be nice."
    peek == $Z ifTrue: [
        "Time read, skip Zulu signature and exit."
        isUtcTime := true.
        stream next.
        ^ self
    ].

    (peek == $+ or:[peek == $-]) ifTrue: [
        "Read a plus/minus, expect a negative/positive time zone difference."
        hasTimezone := true.
        stream next.
        tzOffset := self readTimezoneOffset.
        peek == $+ ifTrue:[
            tzOffset := tzOffset collect: [:e | e negated].
        ].    
        self addHoursAndMinutes: tzOffset.
        ^ self
    ].

    "This is local time"
    isUtcTime := false.
    hasTimezone := false.

    "Created: / 16-06-2005 / 09:54:21 / masca"
!

readTimezoneOffset
    "Read time zone offset as a number minutes. Generally, there should be hours only
    but as the format introduces minutes in offsets, we must accept them."

    | hours digit |

    "Read hours."
    hours := self nextDigits: 2.
    (hours between: 0 and: 12) ifFalse: [self malformed: 'Bad offset hour: ' , hours printString].

    stream peekOrNil = $:
	ifTrue: [
	    "Colon read, minutes must follow."
	    stream next.
	    digit := self nextDigits: 2.
	    (digit between: 0 and: 59) ifFalse: [self malformed: 'Bad offset minute: ' , digit printString].
	    ^Array with: hours with: digit].

    "Read next digit and check whether minutes follow. If not, return only with hours. If yes,
     check boundaries."
    digit := self nextDigit.
    digit < 0 ifTrue: [^Array with: hours with: 0].
    digit >= 6 ifTrue: [self malformed: 'Bad offset minute: ' , (digit * 10) printString].

    "Read the last digit of offset, it must be present."
    ^Array with: hours with: digit * 10 + self nextDigitOrError

    "Created: / 15-06-2005 / 15:35:41 / masca"
    "Modified: / 15-06-2005 / 17:45:58 / masca"
!

readWeekNumber

    | week dayInWeek digit |

    "Read week number. It is always two digits long."
    week := self nextDigits: 2.

    stream peekOrNil = $-
	ifTrue: [
	    "Got dash, day number must follow."
	    stream next.
	    digit := self nextDigit.
	    digit < 0 ifTrue: [self malformed: 'Bad weekday number'].
	    digit > 7 ifTrue: [self malformed: 'Bad weekday number'].
	    self dateFromWeek: week andWeekday: digit.
	    ^self].

    "Read day number that follows the week. If the number is not given, consider it monday."
    dayInWeek := self nextDigit.
    dayInWeek <= 0 ifTrue: [dayInWeek := 1].
    dayInWeek > 7 ifTrue: [self malformed: 'Bad weekday number'].

    self dateFromWeek: week andWeekday: dayInWeek

    "Created: / 14-06-2005 / 12:06:47 / masca"
    "Modified: / 15-06-2005 / 15:53:34 / masca"
!

readYear
    "Read YYYY or :Y (broken decade) from the stream. Also handles correctly YY- and YYY-."

    | read peek |
    stream peekOrNil = $:
        ifTrue: [
            "Broken two digit year > 1999 follows."
            stream next.
            year := self nextDigitOrError + 2000.
            ^self].

    "Expecting two-, three- or four-digit year"
    "Read the first two digits. They must be there."
    read := self nextDigits: 2.

    "Check if there's a dash, this can help us deciding whether the year ends."
    peek := stream peekOrNil.
    peek ifNil: [^self].

    ((peek == $-) or:[peek == $W])
        ifTrue: [
            "OK, got two digits. These are expected to be the year after 1970."
            year := read < 70
                ifTrue: [read + 2000]
                ifFalse: [read + 1900]
        ] ifFalse: [
            "Read the next digit for the case of three-digit year after 1900 (ie. year > 1999)."
             read := read * 10 + self nextDigitOrError.
             peek := stream peekOrNil.
             (peek isNil or: [peek == $-])
                ifTrue: [
                    "Read three digit year, return it."
                    year :=  read + 1900
                ] ifFalse: [
                    "Read the fourth digit of the year. These can be month digits but the
                    two-digit year format is deprecated anyway."
                    read := read * 10 + self nextDigitOrError.
                    year :=  read.
                ]
        ]

    "Created: / 14-06-2005 / 12:01:11 / masca"
    "Modified: / 15-06-2005 / 17:31:56 / masca"
! !

!Timestamp class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Timestamp initialize!
