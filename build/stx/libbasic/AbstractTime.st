"
 COPYRIGHT (c) 1995 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
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

Magnitude subclass:#AbstractTime
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Time'
!

!AbstractTime class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
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
    This is an abstract class providing common protocol for Time (time in day)
    and Timestamp (time plus day).
    There are no instances of this class in the system.
    It is meant as a home for methods common to time handling classes.

    [author:]
        Claus Gittinger

    [See also:]
        Time Date Timestamp
        Delay ProcessorScheduler
"
!

iso8601FormatDocumentation
"
  Abstract

    This document defines a profile of ISO 8601, the International Standard for the representation of dates and times. ISO
    8601 describes a large number of date/time formats. To reduce the scope for error and the complexity of software, it is
    useful to restrict the supported formats to a small number. This profile defines a few date/time formats, likely to satisfy
    most requirements. 


  Formats

    Different standards may need different levels of granularity in the date and time, so this profile defines six levels.
    Standards that reference this profile should specify one or more of these granularities. If a given standard allows more
    than one granularity, it should specify the meaning of the dates and times with reduced precision, for example, the result
    of comparing two dates with different precisions.

    The formats are as follows. Exactly the components shown here must be present, with exactly this punctuation. Note
    that the 'T' appears literally in the string, to indicate the beginning of the time element, as specified in ISO 8601. 

       Year:
          YYYY (eg 1997)
       Year and month:
          YYYY-MM (eg 1997-07)
       Complete date:
          YYYY-MM-DD (eg 1997-07-16)
       Complete date plus hours and minutes:
          YYYY-MM-DDThh:mmTZD (eg 1997-07-16T19:20+01:00)
       Complete date plus hours, minutes and seconds:
          YYYY-MM-DDThh:mm:ssTZD (eg 1997-07-16T19:20:30+01:00)
       Complete date plus hours, minutes, seconds and a decimal fraction of a
    second
          YYYY-MM-DDThh:mm:ss.sTZD (eg 1997-07-16T19:20:30.45+01:00)

    where:

         YYYY = four-digit year
         MM   = two-digit month (01=January, etc.)
         DD   = two-digit day of month (01 through 31)
         hh   = two digits of hour (00 through 23) (am/pm NOT allowed)
         mm   = two digits of minute (00 through 59)
         ss   = two digits of second (00 through 59)
         s    = one or more digits representing a decimal fraction of a second
         TZD  = time zone designator (Z or +hh:mm or -hh:mm)

    This profile does not specify how many digits may be used to represent the decimal fraction of a second. An adopting
    standard that permits fractions of a second must specify both the minimum number of digits (a number greater than or
    equal to one) and the maximum number of digits (the maximum may be stated to be 'unlimited').

    This profile defines two ways of handling time zone offsets:

       1.Times are expressed in UTC (Coordinated Universal Time), with a special UTC designator ('Z'). 
       2.Times are expressed in local time, together with a time zone offset in hours and minutes. A time zone offset of
         '+hh:mm' indicates that the date/time uses a local time zone which is 'hh' hours and 'mm' minutes ahead of
         UTC. A time zone offset of '-hh:mm' indicates that the date/time uses a local time zone which is 'hh' hours and
         'mm' minutes behind UTC. 

    A standard referencing this profile should permit one or both of these ways of handling time zone offsets.

  The ISO8601 printString are generated with:

       Year:
          YYYY (eg 1997)
                Date today printStringFormat:'%(year)'
                Timestamp now printStringFormat:'%(year)'  

       Year and month:
          YYYY-MM (eg 1997-07)
                Date today printStringFormat:'%(year)-%(month)'  
                Timestamp now printStringFormat:'%(year)-%(month)'  

       Complete date:
          YYYY-MM-DD (eg 1997-07-16)
                Date today printStringFormat:'%(year)-%(month)-%(day)'    
                Timestamp now printStringFormat:'%(year)-%(month)-%(day)'  

       Complete date plus hours and minutes:
          YYYY-MM-DDThh:mmTZD (eg 1997-07-16T19:20+01:00)
                Timestamp now printStringFormat:'%(year)-%(month)-%(day)T%h:%m%(TZD)'  

       Complete date plus hours, minutes and seconds:
          YYYY-MM-DDThh:mm:ssTZD (eg 1997-07-16T19:20:30+01:00)
                Timestamp now printStringFormat:'%(year)-%(month)-%(day)T%h:%m:%s%(TZD)'  

       Complete date plus hours, minutes, seconds and a decimal fraction of a second
          YYYY-MM-DDThh:mm:ss.sTZD (eg 1997-07-16T19:20:30.45+01:00)
                Timestamp now printStringFormat:'%(year)-%(month)-%(day)T%h:%m:%s.%(milli2)%(TZD)'  
"
!

printFormatDocumentation
"
     bindings:
        %h      hours, 00..23 (i.e. european)  0-padded to length 2
        %u      hours, 00..12 (i.e. us)        0-padded to length 2
        %m      minutes, 00..59                0-padded to length 2
        %s      seconds, 00..59                0-padded to length 2
        %i      milliseconds, 000..999         0-padded to length 3
        %a      am/pm

     Timestamp only:
        %(day)   day, 00..31                    0-padded to length 2
        %(month) month, 00..12                  0-padded to length 2
        %(year)  year, 4 digits                 0-padded to length 4

     special:
        %H      24-hours - unpadded
        %U      12-hours - unpadded
        %M      minutes - unpadded
        %S      seconds - unpadded
        %I      milliseconds, unpadded
        %A      AM/PM   - uppercase

        %t      seconds within hour  (unpadded)
        %T      seconds from midNight  (unpadded)

        %(TZD)  timeZone delta of the receiver from UTC in the format +/-hh:mm

        %(milli1) milliseconds, truncated to 1/10th of a second 0..9
        %(milli2) milliseconds, truncated to 1/100th of a second 00..99 0-padded to length 2
        %(milli3) milliseconds, same as %i for convenience

     Timestamp only:
        %(Day)         - day - unpadded
        %(Month)       - month - unpadded
        %(yearOrTime)  - year or time 5 digits    as in unix-ls:
                                                  year if it is not the current year;
                                                  time otherwise
        %(weekDay)      - day in week (1->monday, 2->tuesday, ... ,7->sunday)

        %(dayName)      - full day name
        %(DayName)      - full day name, first character uppercase
        %(DAYNAME)      - full day name, all uppercase

        %(monthName)    - full month name
        %(MonthName)    - full month name, first character uppercase
        %(MONTHNAME)    - full month name, all uppercase

        %(shortDayName) - short (abbreviated) day name
        %(ShortDayName) - short (abbreviated) day name, first character uppercase
        %(SHORTDAYNAME) - short (abbreviated) day name, all uppercase

        %(shortMonthName) - short (abbreviated) month name
        %(ShortMonthName) - short (abbreviated) month name, first character uppercase
        %(SHORTMONTHNAME) - short (abbreviated) month name, all uppercase

        %(nth)          - counting day-in-month (1->'st'; 2->'nd'; 3->'rd'; 4...->'th')
        %(weekDayNth)   - counting day-in-week (1->'st'; 2->'nd'; 3->'rd'; 4...->'th')
        %(weekNth)      - counting week-in-year (1->'st'; 2->'nd'; 3->'rd'; 4...->'th')

        %(yearRoman)    - year, in roman letters
        %(monthRoman)   - month, in roman letters


     The ISO8601 printString are documented in iso8601FormatDocumentation:
"
! !

!AbstractTime class methodsFor:'instance creation'!

dateAndTimeNow
    "return an array filled with the current date and time.
     As these provide no timezone info, this should be only used for user interface purposes.
     See also: Date today / Time now / Timestamp now."

    ^ Array with:(Date today) with:(Time now)

    "
     Time dateAndTimeNow       
     Date dateAndTimeNow       
    "

    "Modified: 19.4.1996 / 15:23:37 / cg"
!

epoch
    "answer the time when we start counting"

    ^ self new setSeconds:0

    "
     Timestamp epoch
     Time epoch     
    "
!

now
    "return an instance of myself representing this moment with at least second precision.
     Timestamps will redefine this to always return millisecond precision."

    ^ self basicNew fromOSTime:(OperatingSystem getOSTime)

    "
     Timestamp now   
     Time now   
    "

    "Modified: 1.7.1996 / 15:20:10 / cg"
!

nowWithMilliseconds
    "return an instance of myself representing this moment with millisecond precision."

    ^ self basicNew fromOSTimeWithMilliseconds:(OperatingSystem getOSTime)

    "
     Timestamp now   
     Time now
     Time nowWithMilliseconds
    "

    "Modified: 1.7.1996 / 15:20:10 / cg"
!

utcNow
    "return an instance of myself representing this momentin the UTC timezone."

    ^ self subclassResponsibility

    "
     Timestamp utcNow   
     Timestamp utcNow

     Time now   
     Time utcNow   
    "

    "Modified: 1.7.1996 / 15:20:10 / cg"
! !

!AbstractTime class methodsFor:'Compatibility-Squeak'!

dateAndTimeFromSeconds:secondCount
    "set date and time from seconds since 1901-01-01 00:00 UTC"

    |timestamp|

"   
    secondsBetween1901and1970 := 
        (Timestamp epoch asDate subtractDate:(Date day:1 month:1 year:1901))
        *  (24 * 60 * 60)
"

    "stc cannot make large integers"
    timestamp := Timestamp fromSeconds:secondCount - 2177452800.
    ^ Array
        with: (timestamp asDate)
        with: (timestamp asTime)

    "
     Timestamp dateAndTimeFromSeconds: (Time primSecondsClock) 
     Time dateAndTimeFromSeconds: (Time totalSeconds) 
     Date dateAndTimeFromSeconds: (Time totalSeconds)
    "
!

milliseconds:msTime1 since:msTime2
    "return the number of milliseconds between two
     millisecond time values, compensating for roll-over.
     The same as millisecondsBetween:and: for Squeak compatibility."

    ^ OperatingSystem millisecondTimeDeltaBetween:msTime1 and:msTime2
!

millisecondsSince: lastTime
        "Answer the elapsed time since last recorded in milliseconds.
        Compensate for rollover."

        ^self milliseconds: self millisecondClockValue since: lastTime
!

primSecondsClock
    "returns the number of seconds since 1.1.1901 UTC"

    ^ Timestamp now utcSecondsSince1901

    "
     Timestamp primSecondsClock
    "
! !

!AbstractTime class methodsFor:'Compatibility-VW'!

totalSeconds
    "returns the number of seconds since 1.1.1901 UTC"

    ^ Timestamp now utcSecondsSince1901
! !

!AbstractTime class methodsFor:'error handling'!

conversionErrorSignal
    "return the signal used for conversion error handling"

    ^ TimeConversionError
! !

!AbstractTime class methodsFor:'format strings'!

defaultFormatString
    ^ '%h:%m:%s'
! !


!AbstractTime class methodsFor:'private-instance creation'!

fromOSTime:osTime
    "return a time, representing the time given by the operatingSystem time.
     Not meant for public use."

    ^ self basicNew fromOSTime:osTime.

    "Modified: 1.7.1996 / 15:09:54 / cg"
!

fromSeconds:seconds
    "return an instance that is constructed from seconds.
     This method is only allowed for second values as returned by
     getSeconds, possibly adding/subtracting to that.
     Never depend on any specific interpretation of the seconds,
     since it depends on how the OperatingSystem counts time
     (some start at 1900, others with 1970 ...)"

   ^ self basicNew setSeconds:seconds

    "
     Time fromSeconds:0             should return midnight
     Timestamp fromSeconds:0     on UNIX: returns 1st. Jan 1970
                                    on others: don't know
     (Timestamp day:1 month:1 year:1970 hour:1 minutes:0 seconds:0)
        getSeconds                  on UNIX: returns 0
                                    on others: don't know
    "

    "Modified: 1.7.1996 / 13:39:30 / cg"
! !

!AbstractTime class methodsFor:'queries'!

isAbstract
    ^ self == AbstractTime
!

microsecondClockValue
    "return microseconds seconds of now"

    ^ OperatingSystem getMicrosecondTime

    "
     Time microsecondClockValue
    "

    "
     |t1 t2 overhead|

     t1 := Time microsecondClockValue.
     t2 := Time microsecondClockValue.
     overhead := t2 - t1.  

     t1 := Time microsecondClockValue.
     100 factorial.
     t2 := Time microsecondClockValue.
     t2 - t1 - overhead        
    "
!

millisecondClockValue
    "return the millisecond clock - since this one overruns
     regularly, use the value only for short timing deltas.
     Also remember that it wraps when comparing these values."

    ^ OperatingSystem getMillisecondTime.

    "
     Time millisecondClockValue 
    "
!

secondClock
    "return seconds of now - for GNU-ST compatibility"

    ^ OperatingSystem getOSTime // 1000

    "
     AbstractTime secondClock    
    "

    "Modified: 1.7.1996 / 15:20:14 / cg"
! !

!AbstractTime class methodsFor:'reading'!

readFrom:aStringOrStream format:formatString
    "see format description in readFrom:format:language:onError:"

    ^ self 
        readFrom:aStringOrStream format:formatString language:nil 
        onError:[
            self conversionErrorSignal raiseErrorString:' - Timestamp format error'
        ].
!

readFrom:aStringOrStream format:formatString language:languageString onError:exceptionalValue
    ^ self subclassResponsibility
!

readFrom:aStringOrStream format:formatString onError:exceptionalValue
    "see format description in readFrom:format:language:onError:"

    ^ self readFrom:aStringOrStream format:formatString language:nil onError:exceptionalValue
! !

!AbstractTime class methodsFor:'timing evaluations'!

microsecondsToRun:aBlock
    "evaluate the argument, aBlock; return the number of microseconds it took"

    |startTime endTime|

    startTime := OperatingSystem getMicrosecondTime.
    aBlock value.
    endTime := OperatingSystem getMicrosecondTime.
    ^ endTime - startTime

    "
     Time microsecondsToRun:[1000 factorial]  
    "

    "Modified (comment): / 01-07-2014 / 15:57:13 / az"
!

millisecondsToRun:aBlock
    "evaluate the argument, aBlock; return the number of milliseconds it took"

    |startTime endTime|

    startTime := OperatingSystem getMillisecondTime.
    aBlock value.
    endTime := OperatingSystem getMillisecondTime.
    ^ self milliseconds:endTime since:startTime

    "
     Time millisecondsToRun:[1000 factorial]  
    "

    "Modified: 17.6.1996 / 16:57:37 / cg"
!

secondsToRun:aBlock
    "evaluate the argument, aBlock; return the number of seconds it took"

    |startTime endTime|

    startTime := self secondClock.
    aBlock value.
    endTime := self secondClock.
    ^ endTime - startTime

    "
     Time secondsToRun:[1000 factorial]  
    "
! !

!AbstractTime methodsFor:'Compatibility-ANSI'!

hour12
    "return the hour (1..12)."

    ^ self hours - 1 \\ 12 + 1.

    "
     Time now hour12   
     Time now hour24   
     (Time hours:0 minutes:0 seconds:0) hour24   
     (Time hours:0 minutes:0 seconds:0) hour12   
     (Time hours:1 minutes:0 seconds:0) hour24   
     (Time hours:1 minutes:0 seconds:0) hour12   
     (Time hours:12 minutes:0 seconds:0) hour24 
     (Time hours:12 minutes:0 seconds:0) hour12   
     (Time hours:13 minutes:0 seconds:0) hour24 
     (Time hours:13 minutes:0 seconds:0) hour12   
     (Time hours:23 minutes:0 seconds:0) hour24 
     (Time hours:23 minutes:0 seconds:0) hour12   
     (Time hours:24 minutes:0 seconds:0) hour24 
     (Time hours:24 minutes:0 seconds:0) hour12   
    "
!

hour24
    "return the hour (0..23)."

    ^ self hours

    "
     Time now hour12   
     Time now hour24   
     (Time hours:0 minutes:0 seconds:0) hour24 
     (Time hours:0 minutes:0 seconds:0) hour12 
     (Time hours:1 minutes:0 seconds:0) hour24 
     (Time hours:1 minutes:0 seconds:0) hour12 
     (Time hours:12 minutes:0 seconds:0) hour24 
     (Time hours:12 minutes:0 seconds:0) hour12 
     (Time hours:13 minutes:0 seconds:0) hour24 
     (Time hours:13 minutes:0 seconds:0) hour12 
     (Time hours:23 minutes:0 seconds:0) hour24 
     (Time hours:23 minutes:0 seconds:0) hour12 
     (Time hours:24 minutes:0 seconds:0) hour24 
     (Time hours:24 minutes:0 seconds:0) hour12 
    "
!

meridianAbbreviation
    "am/pm"

    self hours // 12 == 0 ifTrue:[
        ^ 'am'.
    ] ifFalse:[
        (self hours == 12 and:[self minutes == 0 and:[self seconds == 0]]) ifTrue:[
            ^ 'noon'
        ].
        ^ 'pm'.
    ].

    "
     Time now meridianAbbreviation   
     (Time hours:0 minutes:0 seconds:0) meridianAbbreviation  
     (Time hours:11 minutes:59 seconds:59) meridianAbbreviation  
     (Time hours:12 minutes:0 seconds:0) meridianAbbreviation    
     (Time hours:12 minutes:0 seconds:1) meridianAbbreviation  
    "
! !

!AbstractTime methodsFor:'abstract'!

hours
    "return the hour of time (0..23)"

    ^ self subclassResponsibility

    "
     Timestamp now hours 
     Time now hours 
    "
!

milliseconds
    "return the milliseconds since the start of the second (0..999)"

    ^ self subclassResponsibility

    "
     Timestamp now milliseconds 
     Time now milliseconds 
    "
!

minutes
    "return the minutes since the start of the hour (0..59)"

    ^ self subclassResponsibility.

    "
     Timestamp now minutes 
     Time now minutes 
    "
!

seconds
    "return the seconds since the start of the minute (0..59)"

    ^ self subclassResponsibility

    "
     Timestamp now seconds. 
     Time now seconds 
    "
! !

!AbstractTime methodsFor:'accessing'!

hourInDay
    "return the hours (0..23)"

    ^ self hours

    "
     Timestamp now hourInDay 
     Time now hourInDay 
    "
!

minuteInDay
    "return the minutes (0..59)"

    ^ self minutes.

    "
     Timestamp now minuteInDay 
     Time now minuteInDay 
    "
!

secondInDay
    "return the seconds (0..59)"

    ^ self seconds

    "
     Timestamp now secondInDay 
     Time now seconds 
    "

    "Created: 22.10.1996 / 09:27:47 / stefan"
!

timeZoneDeltaInMinutes
    "answer the number of minutes between local time and utc time.
     Delta is positive if local time is ahead of utc, negative if behind utc."

    ^ 0
!

timeZoneName
    ^ 'UTC'
!

utcOffset
    ^ 0
! !

!AbstractTime methodsFor:'arithmetic'!

+ aNumberOrTimeDuration
    "Add aNumber numberOfSeconds or, if its a timeDuration, add its value"

    ^ aNumberOrTimeDuration sumFromTimestamp:self.

"/    ^ self speciesNew 
"/        setMilliseconds:(self getMilliseconds + (aNumberOrTimeDuration * 1000) asInteger)

    "
     Timestamp now to:(Timestamp now + 30) by:2 do:[:time|
        Transcript showCR:time.
     ].

     (Timestamp now + 20)  -  Timestamp now  
     (Timestamp now + 0.5)  -  Timestamp now  
     (Timestamp now + (TimeDuration fromString:'1m 10s'))  -  Timestamp now  
     (Timestamp now + (10 seconds))  -  Timestamp now  
    "
!

- aTimeOrNumberOfSeconds
    "return the delta in seconds between 2 times or subtract a number of seconds."

    ^ aTimeOrNumberOfSeconds differenceFromTimestamp:self.

    "
     Timestamp now - 3600.  
     Time now - 3600.   
     (Time now addSeconds:10) - Time now   
     (TimeDuration fromString:'1.5hr') - 3600.   
     (TimeDuration fromString:'1.5hr') - (TimeDuration fromString:'1hr')   

     |t1 t2|

     t1 := Timestamp now.
     Delay waitFor:10 seconds.
     t2 := Timestamp now.
     Transcript showCR:('seconds passed: ' , (t2 - t1) printString).
    "
!

addDays:numberOfDays
    "return a new instance of myself, numberOfDays afterwards."

    ^ self addSeconds:(numberOfDays * (60 * 60 * 24))

    "
     |t|

     t := Timestamp now.
     Transcript showCR:t.
     Transcript showCR:(t addDays:7)
    "
!

addHours:numberOfHours
    "return a new instance of myself, numberOfHours afterwards."

    ^ self addSeconds:(numberOfHours * (60 * 60))

    "
     |t|

     t := Timestamp now.
     Transcript showCR:t.
     Transcript showCR:(t addHours:12).
    "

    "
     |t|

     t := Time now.
     Transcript showCR:t.
     Transcript showCR:(t addHours:12).
    "
!

addMilliseconds:numberOfMilliSeconds
    "return a new instance of myself, numberOfMilliSeconds afterwards."

    ^ self speciesNew 
        setMilliseconds:(self getMilliseconds + numberOfMilliSeconds)

    "
     |t|

     t := Timestamp now.
     Transcript showCR:t.
     Transcript showCR:(t addMilliseconds:100).
    "

    "
     |t|

     t := Time now.
     Transcript showCR:t.
     Transcript showCR:(t addMilliseconds:1000).
    "
!

addMinutes:numberOfMinutes
    "return a new instance of myself, numberOfMinutes afterwards."

    ^ self addSeconds:(numberOfMinutes * 60)

    "
     |t|

     t := Timestamp now.
     Transcript showCR:t.
     Transcript showCR:(t addMinutes:60).
    "

    "
     |t|

     t := Time now.
     Transcript showCR:t.
     Transcript showCR:(t addMinutes:60).
    "
!

addSeconds:numberOfSeconds
    "return a new instance of myself, numberOfSeconds afterwards."

    ^ self speciesNew 
        setMilliseconds:(self getMilliseconds + (numberOfSeconds * 1000))

    "
     |t|

     t := Timestamp now.
     Transcript showCR:t.
     Transcript showCR:(t addSeconds:60).
    "

    "
     |t|

     t := Time now.
     Transcript showCR:t.
     Transcript showCR:(t addSeconds:60).
    "
!

addTime:timeAmount
    "return a new instance of myself, timeAmount seconds afterwards.
     Provided for ST-80 compatibility.
     WARNING:
        AddTime is a bad name - it does not add a time, but expects
        a numberOfSeconds as argument. 
        Use any of addSeconds/addHours etc. to make things clear"

    timeAmount isNumber ifFalse:[
        ^ self addSeconds:(timeAmount asSeconds).
    ].
    ^ self addSeconds:timeAmount
!

deltaFrom:aTimeOrInteger
    "return the delta as a timeDuration between 2 timeStamps.
     The argument is supposed to be BEFORE the receiver,
        computes self - aTimestamp"

    ^ aTimeOrInteger differenceFromTimestamp:self

    "
        Time now deltaFrom:10 minutes.
        Time now deltaFrom:3600.
        Time now deltaFrom:3600 seconds.

        Timestamp now deltaFrom:10 minutes.
        Timestamp now deltaFrom:3600.
        Timestamp now deltaFrom:3600 seconds.
    "

    "
     |t1 t2|

     t1 := Timestamp now.
     Delay waitForSeconds:0.5.
     t2 := Timestamp now.
     t2 deltaFrom:t1   
    "

    "Created: / 04-10-2007 / 13:34:28 / cg"
    "Modified: / 10-07-2010 / 09:37:01 / cg"
!

roundTo:aTimeDuration
     ^ self class new setMilliseconds:(self getMilliseconds roundTo:aTimeDuration getMilliseconds)

    "
      (TimeDuration fromMilliseconds:25234) roundTo:2 seconds
      Time now roundTo:10 minutes
      Timestamp now roundTo:10 minutes
    "
!

subtractDays:numberOfDays
    "return a new instance of myself, numberOfDays before."

    ^ self subtractSeconds:(numberOfDays * (60 * 60 * 24))

    "
     |t|

     t := Timestamp now.
     Transcript showCR:t.
     Transcript showCR:(t subtractDays:50)
    "
!

subtractHours:numberOfHours
    "return a new instance of myself, numberOfHours before."

    ^ self subtractSeconds:(numberOfHours * (60 * 60))

    "
     |t|

     t := Timestamp now.
     Transcript showCR:t.
     Transcript showCR:(t subtractHours:12).
    "

    "
     |t|

     t := Time now.
     Transcript showCR:t.
     Transcript showCR:(t subtractHours:12).
    "
!

subtractMilliseconds:numberOfMilliSeconds
    "return a new instance of myself, numberOfMilliSeconds before."

    ^ self speciesNew 
        setMilliseconds:(self getMilliseconds - numberOfMilliSeconds)

    "
     |t|

     t := Timestamp now.
     Transcript showCR:t.
     Transcript showCR:(t subtractMilliseconds:100).
    "

    "
     |t|

     t := Time now.
     Transcript showCR:t.
     Transcript showCR:(t subtractMilliseconds:1000).
    "
!

subtractMinutes:numberOfMinutes
    "return a new instance of myself, numberOfMinutes before."

    ^ self subtractSeconds:(numberOfMinutes * 60)

    "
     |t|

     t := Timestamp now.
     Transcript showCR:t.
     Transcript showCR:(t subtractMinutes:60).
    "

    "
     |t|

     t := Time now.
     Transcript showCR:t.
     Transcript showCR:(t subtractMinutes:60).
    "
!

subtractSeconds:numberOfSeconds
    "return a new instance of myself, numberOfSeconds before."

    ^ self speciesNew 
        setMilliseconds:(self getMilliseconds - (numberOfSeconds * 1000))

    "
     |t|

     t := Timestamp now.
     Transcript showCR:t.
     Transcript showCR:(t subtractSeconds:60).
    "

    "
     |t|

     t := Time now.
     Transcript showCR:t.
     Transcript showCR:(t subtractSeconds:60).
    "
!

subtractTime:timeAmount
    "return a new instance of myself, timeAmount seconds before myself.
     Provided for ST-80 compatibility.
     WARNING:
        SubtractTime is a bad name - it does not add a time, but expects
        a numberOfSeconds as argument. 
        Use any of addSeconds/addHours etc. to make things clear"

    timeAmount isNumber ifFalse:[
        ^ self subtractSeconds:(timeAmount asSeconds).
    ].
    ^ self subtractSeconds:timeAmount

!

truncateTo:aTimeDuration
     ^ self class new setMilliseconds:(self getMilliseconds truncateTo:aTimeDuration getMilliseconds)

    "
      (TimeDuration fromMilliseconds:25234) truncateTo:2 seconds
      Time now truncateTo:10 minutes
      Timestamp now truncateTo:10 minutes
    "
! !

!AbstractTime methodsFor:'comparing'!

< aTime
    "return true if the receiver is before the argument"

    ^ self getMilliseconds < aTime getMilliseconds

    "Modified: 3.7.1996 / 13:10:17 / cg"
!

> aTime
    "return true if the receiver is after the argument"

    ^ self getMilliseconds > aTime getMilliseconds

    "Modified: 1.7.1996 / 15:24:38 / cg"
! !

!AbstractTime methodsFor:'converting'!

asAbsoluteTime
    "deprecated, use #asTimestamp"
    <resource:#obsolete>

    self obsoleteMethodWarning:'use #asTimestamp'.
    ^ self asTimestamp
!

asLocalTimestamp
    "represent myself as a timestamp in the local timezone"

    ^ self subclassResponsibility
!

asMilliseconds
    "return the number of milliseconds elapsed since midnight"

    ^ self getMilliseconds

    "
     Time now asMilliseconds
     Timestamp now asMilliseconds
     (TimeDuration days:1) asMilliseconds
     (TimeDuration hours:1) asMilliseconds
    "

    "Created: / 05-09-2011 / 10:40:15 / cg"
!

asSeconds
    "get the seconds since some point of time in the past.
     For Time instances, this is the number of seconds elapsed since midnight;
     For TimeDurations, that is the duration in seconds;
     For TimeStamps, that is the number of seconds since the epoch"

    ^ self getSeconds

    "
     Timestamp now asSeconds
     Time now asSeconds
     (TimeDuration days:1) asSeconds
    "
!

asTimestamp
    "represent myself as a Timestamp"

    ^ self subclassResponsibility
!

asUtcTimestamp
    "represent myself as a timestamp in the local timezone"

    ^ self subclassResponsibility
! !

!AbstractTime methodsFor:'double dispatching'!

differenceFromTimestamp:aTimestamp
    "/ the correct thing to do (and I will, in the future) is to
    "/ return a TimeDuration:
    "/
    ^ TimeDuration fromMilliseconds:(aTimestamp getMilliseconds - self getMilliseconds).

    "/ which is the same as: deltaFrom:aTimestamp
    "/
    "/ however, there might be old code around, which is not be prepared for
    "/ getting a non-number (the seconds). Therefore, for the meantime,
    "/ we return:

    "/ ^ aTimestamp getSeconds - self getSeconds
! !

!AbstractTime methodsFor:'printing & storing'!

addBasicPrintBindingsTo:aDictionary language:languageOrNil
    "private print support: add bindings for printing to aDictionary.
     languageOrNil can be #en, #fr, #de or nil for the current language.
     Here only basic bindings are added - no timezone am am/pm stuff,
     which doesn't make sense for TimeDuration.

     bindings:
        %h      hours, 00..23 (i.e. european)  0-padded to length 2
        %m      minutes, 00..59                0-padded to length 2
        %s      seconds, 00..59                0-padded to length 2
        %i      milliseconds, 000..999         0-padded to length 3

     Timestamp only:
        %(day)   day, 00..31                    0-padded to length 2
        %(month) month, 00..12                  0-padded to length 2
        %(year)  year, 4 digits                 0-padded to length 4

     special:
        %H      24-hours - unpadded
        %M      minutes - unpadded
        %S      seconds - unpadded
        %I      milliseconds, unpadded

        %t      seconds within hour  (unpadded)
        %T      seconds from midNight  (unpadded)

        %(milli1) milliseconds, truncated to 1/10th of a second 0..9
        %(milli2) milliseconds, truncated to 1/100th of a second 00..99 0-padded to length 2
        %(milli3) milliseconds, same as %i for convenience

     Timestamp only:
        %(Day)         - day - unpadded
        %(Month)       - month - unpadded
        %(yearOrTime)  - year or time 5 digits    as in unix-ls:
                                                  year if it is not the current year;
                                                  time otherwise
        %(weekDay)      - day in week (1->monday, 2->tuesday, ... ,7->sunday)

        %(dayName)      - full day name
        %(DayName)      - full day name, first character uppercase
        %(DAYNAME)      - full day name, all uppercase

        %(monthName)    - full month name
        %(MonthName)    - full month name, first character uppercase
        %(MONTHNAME)    - full month name, all uppercase

        %(shortDayName) - short (abbreviated) day name
        %(ShortDayName) - short (abbreviated) day name, first character uppercase
        %(SHORTDAYNAME) - short (abbreviated) day name, all uppercase

        %(shortMonthName) - short (abbreviated) month name
        %(ShortMonthName) - short (abbreviated) month name, first character uppercase
        %(SHORTMONTHNAME) - short (abbreviated) month name, all uppercase

        %(nth)          - counting day-in-month (1->'st'; 2->'nd'; 3->'rd'; 4...->'th')
        %(weekDayNth)   - counting day-in-week (1->'st'; 2->'nd'; 3->'rd'; 4...->'th')
        %(weekNth)      - counting week-in-year (1->'st'; 2->'nd'; 3->'rd'; 4...->'th')


     The ISO8601 printString are generated with:

       Year:
          YYYY (eg 1997)
                Date today printStringFormat:'%(year)'
                Timestamp now printStringFormat:'%(year)'

       Year and month:
          YYYY-MM (eg 1997-07)
                Date today printStringFormat:'%(year)-%(month)'
                Timestamp now printStringFormat:'%(year)-%(month)'

       Complete date:
          YYYY-MM-DD (eg 1997-07-16)
                Date today printStringFormat:'%(year)-%(month)-%(day)'
                Timestamp now printStringFormat:'%(year)-%(month)-%(day)'

       Complete date plus hours and minutes:
          YYYY-MM-DDThh:mmTZD (eg 1997-07-16T19:20+01:00)
                Timestamp now printStringFormat:'%(year)-%(month)-%(day)T%h:%m%(TZD)'

       Complete date plus hours, minutes and seconds:
          YYYY-MM-DDThh:mm:ssTZD (eg 1997-07-16T19:20:30+01:00)
                Timestamp now printStringFormat:'%(year)-%(month)-%(day)T%h:%m:%s%(TZD)'

       Complete date plus hours, minutes, seconds and a decimal fraction of a second
          YYYY-MM-DDThh:mm:ss.sTZD (eg 1997-07-16T19:20:30.45+01:00)
                Timestamp now printStringFormat:'%(year)-%(month)-%(day)T%h:%m:%s.%(milli2)%(TZD)'

    "

    |time hours minutes seconds millis s t|

    time := self asTime.
    hours := time hours.
    minutes := time minutes.
    seconds := time seconds.
    millis := self milliseconds.

    aDictionary at:$H put:(s := hours printString).
    aDictionary at:$h put:(s leftPaddedTo:2 with:$0).

    aDictionary at:$M put:(s := minutes printString).
    aDictionary at:$m put:(s leftPaddedTo:2 with:$0).

    aDictionary at:$S put:(s := seconds printString).
    aDictionary at:$s put:(s leftPaddedTo:2 with:$0).

    aDictionary at:$I put:(s := millis printString).
    aDictionary at:$i put:(t := s leftPaddedTo:3 with:$0).
    aDictionary at:#milli3 put:t.

    aDictionary at:#milli1 put:((millis // 100) printString).
    aDictionary at:#milli2 put:((millis // 10) printStringLeftPaddedTo:2 with:$0).

    aDictionary at:$t put:(seconds * minutes) printString.
    aDictionary at:$T put:(seconds * minutes * hours) printString.


    "
      |dict|
      dict := Dictionary new.
      Timestamp now addBasicPrintBindingsTo:dict language:#en.
      dict inspect
    "
!

addPrintBindingsTo:aDictionary
    <resource: #obsolete>

    self obsoleteMethodWarning:'use #addPrintBindingsTo:language:'.
    self addPrintBindingsTo:aDictionary language:nil
!

addPrintBindingsTo:aDictionary language:languageOrNil
    "private print support: add bindings for printing to aDictionary.
     languageOrNil can be #en, #fr, #de or nil for the current language.

     bindings:
        %h      hours, 00..23 (i.e. european)  0-padded to length 2
        %u      hours, 00..12 (i.e. us)        0-padded to length 2
        %m      minutes, 00..59                0-padded to length 2
        %s      seconds, 00..59                0-padded to length 2
        %i      milliseconds, 000..999         0-padded to length 3
        %a      am/pm

     Timestamp only:
        %(day)   day, 00..31                    0-padded to length 2
        %(month) month, 00..12                  0-padded to length 2
        %(year)  year, 4 digits                 0-padded to length 4

     special:
        %H      24-hours - unpadded
        %U      12-hours - unpadded
        %M      minutes - unpadded
        %S      seconds - unpadded
        %I      milliseconds, unpadded
        %A      AM/PM   - uppercase

        %t      seconds within hour  (unpadded)
        %T      seconds from midNight  (unpadded)

        %(TZD)  timeZone delta of the receiver from UTC in the format +/-hh:mm

        %(milli1) milliseconds, truncated to 1/10th of a second 0..9
        %(milli2) milliseconds, truncated to 1/100th of a second 00..99 0-padded to length 2
        %(milli3) milliseconds, same as %i for convenience

     Timestamp only:
        %(Day)         - day - unpadded
        %(Month)       - month - unpadded
        %(yearOrTime)  - year or time 5 digits    as in unix-ls:
                                                  year if it is not the current year;
                                                  time otherwise
        %(weekDay)      - day in week (1->monday, 2->tuesday, ... ,7->sunday)

        %(dayName)      - full day name
        %(DayName)      - full day name, first character uppercase
        %(DAYNAME)      - full day name, all uppercase

        %(monthName)    - full month name
        %(MonthName)    - full month name, first character uppercase
        %(MONTHNAME)    - full month name, all uppercase

        %(shortDayName) - short (abbreviated) day name
        %(ShortDayName) - short (abbreviated) day name, first character uppercase
        %(SHORTDAYNAME) - short (abbreviated) day name, all uppercase

        %(shortMonthName) - short (abbreviated) month name
        %(ShortMonthName) - short (abbreviated) month name, first character uppercase
        %(SHORTMONTHNAME) - short (abbreviated) month name, all uppercase

        %(nth)          - counting day-in-month (1->'st'; 2->'nd'; 3->'rd'; 4...->'th')
        %(weekDayNth)   - counting day-in-week (1->'st'; 2->'nd'; 3->'rd'; 4...->'th')
        %(weekNth)      - counting week-in-year (1->'st'; 2->'nd'; 3->'rd'; 4...->'th')

        %(yearRoman)    - year, in roman letters
        %(monthRoman)   - month, in roman letters


     The ISO8601 printString are generated with:

       Year:
          YYYY (eg 1997)
                Date today printStringFormat:'%(year)'
                Timestamp now printStringFormat:'%(year)'

       Year and month:
          YYYY-MM (eg 1997-07)
                Date today printStringFormat:'%(year)-%(month)'
                Timestamp now printStringFormat:'%(year)-%(month)'

       Complete date:
          YYYY-MM-DD (eg 1997-07-16)
                Date today printStringFormat:'%(year)-%(month)-%(day)'
                Timestamp now printStringFormat:'%(year)-%(month)-%(day)'

       Complete date plus hours and minutes:
          YYYY-MM-DDThh:mmTZD (eg 1997-07-16T19:20+01:00)
                Timestamp now printStringFormat:'%(year)-%(month)-%(day)T%h:%m%(TZD)'

       Complete date plus hours, minutes and seconds:
          YYYY-MM-DDThh:mm:ssTZD (eg 1997-07-16T19:20:30+01:00)
                Timestamp now printStringFormat:'%(year)-%(month)-%(day)T%h:%m:%s%(TZD)'

       Complete date plus hours, minutes, seconds and a decimal fraction of a second
          YYYY-MM-DDThh:mm:ss.sTZD (eg 1997-07-16T19:20:30.45+01:00)
                Timestamp now printStringFormat:'%(year)-%(month)-%(day)T%h:%m:%s.%(milli2)%(TZD)'

    "

    |usHours ampm s zone tzDelta|

    self addBasicPrintBindingsTo:aDictionary language:languageOrNil.
    zone := self timeZoneName.
    tzDelta := self timeZoneDeltaInMinutes.

    ampm := self meridianAbbreviation.
    usHours := self hour12 printString.
    aDictionary at:$U put:usHours.
    aDictionary at:$u put:(usHours leftPaddedTo:2 with:$0).


    aDictionary at:$a put:ampm.
    aDictionary at:$A put:ampm asUppercase.
    aDictionary at:$z put:zone.
    aDictionary at:$Z put:zone asUppercase.

    tzDelta == 0 ifTrue:[
        s := 'Z'.
    ] ifFalse:[
        s := tzDelta < 0 ifTrue:[ '-' ] ifFalse:[ '+' ].
        tzDelta := tzDelta abs.
        s := s  , ((tzDelta // 60) printStringLeftPaddedTo:2 with:$0),
            ':' , ((tzDelta \\ 60) printStringLeftPaddedTo:2 with:$0).
    ].
    aDictionary at:#TZD put:s


    "
      |dict|
      dict := Dictionary new.
      Timestamp now addPrintBindingsTo:dict language:#en.
      dict inspect
    "
!

printOn:aStream format:aFormatString
    "print using a format string;
     See #addPrintBindingsTo:language: for allowed format strings"

    self printOn:aStream format:aFormatString language:nil.

    "
     Timestamp now printOn:Transcript format:'%h:%m:%s'   . Transcript cr.      
     Time now printOn:Transcript format:'%h:%m:%s'   . Transcript cr.      
     Time now printOn:Transcript format:'%H:%m:%s'   . Transcript cr.      
     Time now printOn:Transcript format:'%u:%m:%s %a'. Transcript cr.   
     Time now printOn:Transcript format:'%h:%m'      . Transcript cr. 
     Time now printOn:Transcript format:'%H:%m %A'   . Transcript cr.
     Time now printOn:Transcript format:'minutes:%M seconds:%S'. Transcript cr.
    "

    "Modified: 22.2.1996 / 16:58:30 / cg"
!

printOn:aStream format:aFormatString language:languageString
    "print using a format string;
     See #addPrintBindingsTo:language: for allowed format strings"

    |dict|

    dict := IdentityDictionary new.
    self addPrintBindingsTo:dict language:languageString.

    aFormatString expandPlaceholdersWith:dict on:aStream

    "
     Timestamp now printOn:Transcript format:'%h:%m:%s'   . Transcript cr.      
     Time now printOn:Transcript format:'%h:%m:%s'   . Transcript cr.      
     Time now printOn:Transcript format:'%H:%m:%s'   . Transcript cr.      
     Time now printOn:Transcript format:'%u:%m:%s %a'. Transcript cr.   
     Time now printOn:Transcript format:'%h:%m'      . Transcript cr. 
     Time now printOn:Transcript format:'%H:%m %A'   . Transcript cr.
     Time now printOn:Transcript format:'minutes:%M seconds:%S'. Transcript cr.
    "

    "Modified: 22.2.1996 / 16:58:30 / cg"
!

printStringFormat:aFormatString
    "print using a format string.
     See #addPrintBindingsTo:language: for allowed format strings"

    ^ self printStringFormat:aFormatString language:nil.

    "
     Timestamp now printStringFormat:'%U:%m:%s %a'        
     Timestamp now printStringFormat:'%u:%m:%s %a'        
     Time now printStringFormat:'%U:%m:%s %a'   
     Time now printStringFormat:'%u:%m:%s %a'   

     Time now printStringFormat:'%h:%m:%s'      
     Time now printStringFormat:'%H:%m:%s'      
     Time now printStringFormat:'%H:%m:%s.%i'           
     Timestamp now printStringFormat:'%H:%m:%s.%i'   
     Timestamp now printStringFormat:'%H:%m:%s.%(milli1)'   
     Timestamp now printStringFormat:'%H:%m:%s.%(milli2)'     
     Timestamp now printStringFormat:'%(day)-%(month)-%(year) :%m:%s'       
     Timestamp now printStringFormat:'%(day)-%(monthName)-%(year) :%m:%s'       
     Time now printStringFormat:'%u:%m:%s %a'   
     Time now printStringFormat:'%h:%m'         
     Time now printStringFormat:'%h:%m'         
     Time now printStringFormat:'%H:%m %A'     
     Time now printStringFormat:'%m minutes after %U %a'     
     Time now printStringFormat:'%t seconds after %U %a'     
     Time now printStringFormat:'%T seconds from midNight'     
    "

    "Modified: 22.2.1996 / 16:58:30 / cg"
!

printStringFormat:aFormatString language:languageString
    "print using a format string.
     See #addPrintBindingsTo:language: for allowed format strings"

    |s|

    s := CharacterWriteStream on:(String new:20).
    self printOn:s format:aFormatString language:languageString.
    ^ s contents.

    "
     Timestamp now printStringFormat:'%U:%m:%s %a  
     Time now printStringFormat:'%U:%m:%s %a'   

     Time now printStringFormat:'%h:%m:%s'      
     Time now printStringFormat:'%H:%m:%s'      
     Time now printStringFormat:'%H:%m:%s.%i'           
     Timestamp now printStringFormat:'%H:%m:%s.%i'   
     Timestamp now printStringFormat:'%H:%m:%s.%(milli1)'   
     Timestamp now printStringFormat:'%H:%m:%s.%(milli2)'     
     Timestamp now printStringFormat:'%(day)-%(month)-%(year) :%m:%s'       
     Timestamp now printStringFormat:'%(day)-%(monthName)-%(year) :%m:%s' language:#en      
     Timestamp now printStringFormat:'%(day)-%(monthName)-%(year) :%m:%s' language:#de      
     Timestamp now printStringFormat:'%(day)-%(monthName)-%(year) :%m:%s' language:#fr      
     Time now printStringFormat:'%u:%m:%s %a'   
     Time now printStringFormat:'%h:%m'         
     Time now printStringFormat:'%h:%m'         
     Time now printStringFormat:'%H:%m %A'     
     Time now printStringFormat:'%m minutes after %U %a'     
     Time now printStringFormat:'%t seconds after %U %a'     
     Time now printStringFormat:'%T seconds from midNight'     
    "

    "Modified: 22.2.1996 / 16:58:30 / cg"
! !

!AbstractTime methodsFor:'private'!

fromOSTime:osTime
    "set my time, from operatingSystems time parts"

    ^ self subclassResponsibility

    "Modified: 1.7.1996 / 15:09:44 / cg"
!

getMilliseconds
    "get the milliseconds since some point of time in the past.
     Since I am abstract (not knowing how the time is actually
     represented), this must be done by a concrete class."

    ^ self subclassResponsibility

    "Created: 1.7.1996 / 14:16:49 / cg"
!

getSeconds
    "get the seconds since some point of time in the past.
     Since I am abstract (not knowing how the time is actually
     represented), this must be done by a concrete class."

    ^ self subclassResponsibility
!

setMilliseconds:millis
    "set the milliseconds since some point of time in the past.
     Since I am abstract (not knowing how the time is actually
     represented), this must be done by a concrete class."

    ^ self subclassResponsibility

    "Created: 1.7.1996 / 14:17:00 / cg"
!

setSeconds:secs
    "set the seconds since some point of time in the past.
     Since I am abstract (not knowing how the time is actually
     represented), this must be done by a concrete class."

    ^ self subclassResponsibility
!

speciesNew
    ^ self species basicNew
! !

!AbstractTime class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

