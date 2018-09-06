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

AbstractTime subclass:#Time
	instanceVariableNames:'timeEncoding'
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Time'
!

!Time class methodsFor:'documentation'!

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
    Instances of time represent a particular time-of-day.
    Since they only store hours, minutes and seconds within a day,
    they cannot be used to compare times across midnight
    (i.e. they should not be used as timeStamps).

    Use instances of Timestamp (and read the comment there) to do this.

    Time now returns the time in the local timezone.
    Use Time utcNow to get the time in the UTC zone.

    Note: time was changed recently to keep the number of milliseconds since midnight.
          However, all existing instance creators so far only create time instances with 0-millis.
          I.e. Time now still returns a time with second precision.

          It is not done currently, to remain backward compatible, as users may get confused
          to see t1 > t2 although they print the same (as long as the printed representation does not
          include the milli seconds).
          On the other side: a change of the default printformat is not done now, 
          as it may affect many existing applications.

          Any application which needs the millisecond precision time should call the new
            Time nowWithMilliseconds.

    Examples:
        |t|

        t := Time now.
        Transcript showCR:t.


        |t1 t2|

        t1 := Time now.
        (Delay forSeconds:10) wait.
        t2 := Time now.
        t2 - t1

    [author:]
        Claus Gittinger

    [see also:]
        Date Timestamp AbstractTime OperatingSystem
        Filename
"
! !

!Time class methodsFor:'instance creation'!

fromString: aString
    ^ self readFrom: (ReadStream on: aString).

    "Modified (format): / 20-08-2011 / 16:46:39 / cg"
!

hour:h minute:m
    "compatibility"

    ^ self hours:h minutes:m seconds:0

    "
     Time hour:2 minute:33
    "
!

hour:h minute:m second:s
    "compatibility"

    ^ self hours:h minutes:m seconds:s

    "
     Time hour:2 minute:33 second:0
    "
!

hour:h minutes:m seconds:s
    "return an instance of Time representing the given time.
     See also Time now / Date today / Timestamp now.
     Obsolete: please use #hours:minutes:seconds:"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #hours:minutes:seconds:'.

    ^ self hours:h minutes:m seconds:s

    "
     Time hours:2 minutes:33 seconds:0
     Time hours:0 minutes:0 seconds:0
     Time hours:24 minutes:0 seconds:0
     Time hours23 minutes:59 seconds:59
    "

    "Modified: 19.4.1996 / 15:32:40 / cg"
!

hours:h minutes:m seconds:s
    "return an instance of Time representing the given time.
     See also Time now / Date today / Timestamp now."

    ^ self basicNew setHours:h minutes:m seconds:s

    "
     Time hours:2 minutes:33 seconds:0
     Time hours:0 minutes:0 seconds:0
     Time hours:24 minutes:0 seconds:0
     Time hours:23 minutes:59 seconds:59
    "

    "Modified: 19.4.1996 / 15:32:40 / cg"
!

hours:h minutes:m seconds:s milliseconds:ms
    "return an instance of Time representing the given time.
     See also Time now / Date today / Timestamp now."

    ^ self basicNew setHours:h minutes:m seconds:s milliseconds:ms

    "
     Time hours:2 minutes:33 seconds:0
     Time hours:0 minutes:0 seconds:0
     Time hours:24 minutes:0 seconds:0
     Time hours:23 minutes:59 seconds:59
    "

    "Modified: 19.4.1996 / 15:32:40 / cg"
!

midnight
    "Answer a new instance at midnight."

    ^ self fromSeconds: 0

    "
     Time midnight
    "
!

noon
    "Answer a new instance at noon."

    ^ self fromSeconds: 43200 "12*60*60"

    "
     Time noon
    "
!

readFrom:aStringOrStream format:formatString language:languageOrNil onError:exceptionalValue
    "return a new Time, reading a printed representation from aStream using a formatString.
     The formatString is similar to the one used when printing.
     On error, exceptionalValue is returned.
     If exceptionalValue is a one-arg block, an error message is passed as argument.
     Format:
        %h      hours, 00..23 (i.e. european)  0-padded to length 2
        %u      hours, 00..12 (i.e. us)        0-padded to length 2
        %m      minutes, 00..59                0-padded to length 2
        %s      seconds, 00..59                0-padded to length 2
        %i      milliseconds, 000..999         0-padded to length 3
        %f      fractional seconds             any length, but only milliseconds are read
        %a      am/pm

     an optional length after the % gives a field length;
        i.e. %2h%2m%2s parses '123557' as 12:35:37

     Please consider using a standard format, such as iso8601.
    "

    |hour minute second millisecond
     utcOffset inStream formatStream error fChar format itemHandler
     len s fraction fractionString|

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

        ( format = 'h' or:[ format = 'H' ]) ifTrue:[
            hour := Integer readFrom:input onError:[ error value:'invalid hour' ].

        ] ifFalse:[ ( format = 'u'  or:[ format = 'U']) ifTrue:[
            hour := Integer readFrom:input onError:[ error value:'invalid hour' ].

        ] ifFalse:[ ( format = 'm'  or:[ format = 'M' ]) ifTrue:[
            minute := Integer readFrom:input onError:[ error value:'invalid minute' ].

        ] ifFalse:[ ( format = 's'  or:[ format = 'S' ]) ifTrue:[
            second := Integer readFrom:input onError:[ error value:'invalid second' ].

        ] ifFalse:[ ( format = 'i'  or:[ format = 'I' ]) ifTrue:[
            millisecond := Integer readFrom:input onError:[ error value:'invalid millsecond' ].

        ] ifFalse:[ ( format = 'f'  or:[ format = 'F' ]) ifTrue:[
            fractionString := input upToMatching:[:ch | ch isDigit not].
            fraction := FixedPoint readFrom:'0.',fractionString.
            millisecond := (fraction * 1000) truncated.
        ] ifFalse:[ ( format = 'tz' ) ifTrue:[
            utcOffset := Timestamp utcOffsetFrom:input.
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
        ]]]]]]]]
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

    ^ (self 
        hours:(hour ? 0) minutes:(minute ? 0) seconds:(second ? 0) milliseconds:millisecond) 
            + utcOffset

    "
     Time readFrom:'13:11:06' format:'%h:%m:%s' language:nil onError:[self halt]
     Time readFrom:'131106' format:'%2h%2m%2s' language:nil onError:[self halt]
     Time readFrom:'7:30pm EST' format:'%u:%m%a %tz' language:#en onError:[self halt]
     Time readFrom:'7:30pm UTC' format:'%u:%m%a %tz' language:#en onError:[self halt]
     
     Time readFrom:'13:11:06.111' format:'%h:%m:%s.%i' language:nil onError:[self halt]
     Time readFrom:'13:11:06.1' format:'%h:%m:%s.%f' language:nil onError:[self halt]
     Time readFrom:'13:11:06.01' format:'%h:%m:%s.%f' language:nil onError:[self halt]
     Time readFrom:'13:11:06.001' format:'%h:%m:%s.%f' language:nil onError:[self halt]
     Time readFrom:'13:11:06.1234567' format:'%h:%m:%s.%f' language:nil onError:[self halt]
    "
!

readFrom:aStringOrStream onError:exceptionBlock
    "return a new Time, reading a printed representation from aStream.
     If no am/pm follows the time, the string is interpreted as
     either 24 hour format or being am."

    ^ [
        |str hour min sec peekC millis|

        str := aStringOrStream readStream.

        hour := Integer readFrom:str.
        (hour between:0 and:24) ifFalse:[^ exceptionBlock value].

        min := 0.
        sec := 0.
        millis := 0.

        str atEnd ifFalse:[
            peekC := str peek.
            (peekC == $:) ifTrue:[
                str next.
                min := Integer readFrom:str.
                (min between:0 and:59) ifFalse:[^ exceptionBlock value].

                (str peek == $:) ifTrue:[
                    str next.
                    sec := Integer readFrom:str.
                    (sec between:0 and:59) ifFalse:[^ exceptionBlock value].
                    (str peek == $.) ifTrue:[
                        str next.
                        millis := ((Fraction readDecimalFractionFrom:str onError:[^ exceptionBlock value]) * 1000) asInteger.
                    ].
                ].
                peekC := str peek.
            ].
            [peekC == Character space] whileTrue:[str next. peekC := str peek].
            (peekC == $p or:[peekC == $P]) ifTrue:[
                str next.
                (str peek == $m or:[str peek == $M]) ifTrue:[
                    str next
                ].
                (hour <= 0 or:[hour > 12]) ifTrue:[^ exceptionBlock value].

                "pm"
                hour ~~ 12 ifTrue:[
                    hour := hour + 12
                ].
                peekC := str peek
            ] ifFalse:[
                (peekC == $a or:[peekC == $A]) ifTrue:[
                    str next.
                    (str peek == $m or:[str peek == $M]) ifTrue:[
                        str next
                    ].
                    hour == 12 ifTrue:[
                        hour := 0.
                    ].
                    hour > 12 ifTrue:[^ exceptionBlock value].
                    peekC := str peek
                ] ifFalse:[
                    "/ cg: don't be too picky here - we do not care, what comes after the
                    "/ time string. (Needed to be able to read rfc822 strings where a timezone
                    "/ follows (-/+0700 GMT, for example)
"/                    peekC notNil ifTrue:[
"/                        peekC isSeparator ifFalse:[^ exceptionBlock value].
"/                    ]
                ].
            ]
        ].
        self basicNew setHours:hour minutes:min seconds:sec milliseconds:millis
    ] on:Error do:exceptionBlock.

    "
     Time readFrom:'0:00'
     Time readFrom:'2:00'
     Time readFrom:'12:00'
     Time readFrom:'14:00'
     Time readFrom:'23:00'
     Time readFrom:'24:00'
     Time readFrom:'2:30 am'
     Time readFrom:'2:30 pm'
     Time readFrom:'14'
     Time readFrom:'2 am'
     Time readFrom:'2 pm'
     Time readFrom:'12:05 pm'
     Time readFrom:'12:06 am'

     Time readFrom:'18:22:00'
     Time readFrom:'14:00:11'
     Time readFrom:'7:00:11'
     Time readFrom:'24:00:00'
     Time readFrom:'0:00:00'
     Time readFrom:'12:00:00'
     Time readFrom:'0:00:00'
     Time readFrom:'6:22:00 pm'
     Time readFrom:'2:00:11 pm'
     Time readFrom:'7:00:11 am'
     Time readFrom:'12:00:00 am'
     Time readFrom:'0:00:00 am'
     Time readFrom:'24:00:00 am'
     Time readFrom:'12:00:00 pm'
     Time readFrom:'0:00:00 pm' onError:'invalid'
     Time readFrom:'24:00:00 pm'

     Time readFrom:'13:00:00.5'
     Time readFrom:'13:00:00.123'
     Time readFrom:'1:00:00.123 pm'
    "

    "Modified: 8.10.1996 / 19:32:11 / cg"
!

utcNow
    "return an instance of myself representing this moment in UTC.
     That is, the current time in London without any daylight saving adjustments."

    ^ self basicNew fromUtcOSTime:(OperatingSystem getOSTime)

    "
     Timestamp now
     Timestamp utcNow

     Time now
     Time utcNow
    "

    "Modified: 1.7.1996 / 15:20:10 / cg"
! !

!Time class methodsFor:'format strings'!

defaultFormatString
    "a language specific format string to present times in user interfaces.
     Do not use this to store/retrieve times (use ISO8601 for that)"

    Smalltalk languageTerritory == #us ifTrue:[
        ^ self formatString12us
    ] ifFalse:[
        ^ self formatString24
    ]

    "Created: / 16-01-2011 / 11:23:36 / cg"
!

defaultFormatStringWithMilliseconds
    Smalltalk languageTerritory == #us ifTrue:[
        ^ self formatStringWithMilliseconds12us
    ] ifFalse:[
        ^ self formatStringWithMilliseconds24
    ]
!

formatString12us
    "return the format string used to format US times (and other areas)"

    ^ '%u:%m:%s %A'
!

formatString24
    "return the format string used to format non US times"

    ^ '%h:%m:%s'
!

formatStringWithMilliseconds12us
    "return the format string used to format US times (and other areas)"

    ^ '%u:%m:%s.%i %A'
!

formatStringWithMilliseconds24
    "return the format string used to format non US times"

    ^ '%h:%m:%s.%i'
! !

!Time methodsFor:'Compatibility-Backward'!

asMilliSeconds
    <resource: #obsolete>
    "return the number of milliseconds elapsed since midnight"

    ^ self asMilliseconds

    "
     Time now asMilliSeconds
     (TimeDuration days:1) asMilliSeconds
     (TimeDuration hours:1) asMilliSeconds
    "

    "Created: / 05-09-2011 / 10:40:15 / cg"
! !

!Time methodsFor:'Compatibility-Squeak'!

intervalString
    "Treat the time as a difference.
     Give it in hours and minutes with two digits of accuracy."

    |hours minutes seconds hh mm ss s|

    hours := self hours.
    minutes := self minutes.
    seconds := self seconds.

    hours = 0
	ifTrue: [hh := '']
	ifFalse: [
	    hh := hours printString, ' hour'.
	    hours > 1 ifTrue:[
		hh := hh , 's'
	    ]
	].
    minutes = 0
	ifTrue: [mm := '']
	ifFalse: [
	    mm := minutes printString, ' minute'.
	    minutes > 1 ifTrue:[
		mm := mm , 's'
	    ]
	].
    seconds = 0
	ifTrue: [ss := '']
	ifFalse: [
	    ss := seconds printString, ' second'.
	    seconds > 1 ifTrue:[
		ss := ss , 's'
	    ]
	].

    "/ do not show seconds, if hours are there
    hh size > 0 ifTrue: [ss := ''].

    s := hh.
    mm notEmpty ifTrue:[
	s notEmpty ifTrue:[
	    s := s , ' '
	].
	s := s , mm.
    ].
    ss notEmpty ifTrue:[
	s notEmpty ifTrue:[
	    s := s , ' '
	].
	s := s , ss
    ].
    ^ s

    "
     (Time fromSeconds:3600) intervalString
     (Time fromSeconds:3605) intervalString
     (Time fromSeconds:3700) intervalString
     (Time fromSeconds:5) intervalString
     (Time fromSeconds:65) intervalString
    "
!

print24:prnt24FormatBoolean on:aStream
    "print me either US or 24hr format on a stream"

    ^ self print24:prnt24FormatBoolean showSeconds:true on:aStream

    "
     Time now print24:true on:Transcript. Transcript cr.
     Time now print24:false on:Transcript. Transcript cr.
    "
!

print24:prnt24Format showSeconds:doSeconds on:aStream
    "print me either US or 24hr format, optionally with
     seconds on a stream"

    |format|

    prnt24Format ifTrue:[
	doSeconds ifTrue:[
	    format := '%h:%m:%s'
	] ifFalse:[
	    format := '%h:%m'
	].
    ] ifFalse:[
	"/ US format
	doSeconds ifTrue:[
	    format := '%u:%m:%s %a'
	] ifFalse:[
	    format := '%u:%m %a'
	].
    ].
    ^ self
	printOn:aStream
	format:format.

    "
     Time now print24:true showSeconds:true on:Transcript. Transcript cr.
     Time now print24:false showSeconds:true on:Transcript. Transcript cr.
     Time now print24:true showSeconds:false on:Transcript. Transcript cr.
     Time now print24:false showSeconds:false on:Transcript. Transcript cr.
    "
! !

!Time methodsFor:'accessing'!

hours
    "return the number of hours since midnight (i.e. 0..23)"

    ^ self getSeconds // 3600

    "
     Time now hours
    "
!

milliseconds
    "get the milliseconds part
     (notice: that is NOT the total number of millis (since midnight),
     but the fractional part only. Use this only for printing.
     asMilliseconds or getMilliseconds is probably what you want"

    ^ timeEncoding \\ 1000
!

minutes
    "return the number of minutes within the hour (i.e. 0..59).
     (notice: that is NOT the total number of minutes (since midnight),
     but the fractional part only. Use this only for printing."

    ^ (self getSeconds \\ 3600) // 60

    "
     Time now minutes
    "
!

seconds
    "return the number of seconds within the minute (i.e. 0..59).
     (notice: that is NOT the total number of seconds (since midnight),
     but the fractional part only. Use this only for printing.
     asSeconds or getSeconds give you the nr of seconds since midnight"

    ^ self getSeconds \\ 60

    "
     Time now seconds
    "
!

timeZoneDeltaInMinutes
    "answer the number of minutes between local time and utc time.
     Delta is positive if local time is ahead of utc, negative if behind utc.

     Time is local time, so ask a local timestamp"

    ^ Timestamp now timeZoneDeltaInMinutes


    "
      Time now timeZoneDeltaInMinutes
    "
! !

!Time methodsFor:'comparing'!

< aTime
    "return true if the receiver is before the argument"

    |milliseconds|

    aTime class == self class ifTrue:[
        ^ timeEncoding < aTime timeEncoding
    ].
    aTime isNumber ifTrue:[
        "backward compatibility for old code, which expects (time1 - time2) to return seconds"    
        milliseconds := (aTime * 1000) asInteger.   "integer seconds"
    ] ifFalse:[
        milliseconds := aTime getMilliseconds.
    ].
    ^ self getMilliseconds < milliseconds

    "
        (Timestamp now + 10) - Timestamp now  < 10
        (Timestamp now + 10) - Timestamp now  < 11
    "
!

<= aTime
    "return true if the receiver is before the argument"

    |milliseconds|

    aTime class == self class ifTrue:[
        ^ timeEncoding <= aTime timeEncoding
    ].
    aTime isNumber ifTrue:[
        "backward compatibility for old code, which expects (time1 - time2) to return seconds"    
        milliseconds := (aTime * 1000) asInteger.   "integer seconds"
    ] ifFalse:[
        milliseconds := aTime getMilliseconds.
    ].
    ^ self getMilliseconds <= milliseconds

    "
        (Timestamp now + 10) - Timestamp now  <= 10
        (Timestamp now + 10) - Timestamp now  <= 11
        (Timestamp now + 10) - Timestamp now  <= 9
    "
!

= aTime
    "return true if the argument, aTime represents the same timeOfDay"

    |milliseconds|

    aTime class == self class ifTrue:[
        ^ timeEncoding = aTime timeEncoding
    ].
    aTime isNumber ifTrue:[
        "backward compatibility for old code, which expects (time1 - time2) to return seconds"    
        milliseconds := (aTime * 1000) asInteger.   "integer seconds"
    ] ifFalse:[
        aTime species == self species ifFalse:[^ false].
        milliseconds := aTime getMilliseconds.
    ].
    ^ self getMilliseconds = milliseconds

    "
        (Timestamp now + 10) - Timestamp now  = 10
        (Timestamp now + 10) - Timestamp now  = 9
    "
!

> aTime
    "return true if the receiver is before the argument"

    |milliseconds|

    aTime class == self class ifTrue:[
        ^ timeEncoding > aTime timeEncoding
    ].
    aTime isNumber ifTrue:[
        "backward compatibility for old code, which expects (time1 - time2) to return seconds"    
        milliseconds := (aTime * 1000) asInteger.   "integer seconds"
    ] ifFalse:[
        milliseconds := aTime getMilliseconds.
    ].
    ^ self getMilliseconds > milliseconds

    "
        (Timestamp now + 10) - Timestamp now  > 10
        (Timestamp now + 10) - Timestamp now  > 9
    "
!

hash
    "return an integer useful for hashing on times"

    ^ timeEncoding
! !

!Time methodsFor:'converting'!

asLocalTimestamp
    "return an Timestamp object from the receiver.
     So I am interpreted as a Time in the local timezone.
     The date components are taken from today."

    |todayTimestamp|

    todayTimestamp := Timestamp now.
    todayTimestamp year:todayTimestamp year month:todayTimestamp month day:todayTimestamp day
                   hour:(self hours) minute:(self minutes) second:(self seconds)
                   millisecond:(self milliseconds).

    ^ todayTimestamp.

    "
      Time now asLocalTimestamp
    "
!

asTime
    "return a Time object from the receiver - that's the receiver."

    ^ self
!

asTimeDuration
    "return an TimeDuration object from the receiver, taking the time since midnight."

    ^ TimeDuration
		   hours:(self hours) minutes:(self minutes) seconds:(self seconds)
		   milliseconds:(self milliseconds)
    "
     Time now asTimeDuration
    "
!

asTimestamp
    "return an Timestamp object from the receiver.
     The date components are taken from today."

    ^ self asLocalTimestamp

    "
      Time now asTimestamp
    "
!

asUtcTimestamp
    "return an UtcTimestamp object from the receiver.
     So I am interpreted as a Time in the UTC zone.
     The date components are taken from today."

    |todayTimestamp|

    todayTimestamp := Timestamp now.
    todayTimestamp year:todayTimestamp year month:todayTimestamp month day:todayTimestamp day
		   hour:(self hours) minute:(self minutes) second:(self seconds)
		   millisecond:(self milliseconds).

    ^ todayTimestamp asUtcTimestamp.

    "
     Time now asUtcTimestamp
    "
! !

!Time methodsFor:'printing & storing'!

print12HourFormatOn:aStream
    "append a human readable printed representation of the receiver to aStream.
     Format is hh:mm:ss am/pm (i.e. 12-hour american format)."

    ^ self
	printOn:aStream
	format:(self class formatString12us)

"/    |h m s ampm|
"/
"/    h := self hours.
"/
"/    "/ 0 -> 12 am
"/    "/ 12 -> 12 pm
"/
"/    h // 12 == 0 ifTrue:[
"/        ampm := ' am'.
"/    ] ifFalse:[
"/        ampm := ' pm'.
"/    ].
"/
"/    h == 0 ifFalse:[
"/        h := h - 1 \\ 12 + 1.
"/    ].
"/
"/    h printOn:aStream.
"/    aStream nextPut:$:.
"/    m := self minutes.
"/    (m < 10) ifTrue:[aStream nextPut:$0].
"/    m printOn:aStream.
"/    aStream nextPut:$:.
"/    s := self seconds.
"/    (s < 10) ifTrue:[aStream nextPut:$0].
"/    s printOn:aStream.
"/    aStream nextPutAll:ampm

    "
     Time now print12HourFormatOn:Transcript. Transcript cr
     (Time now subtractHours:12) print12HourFormatOn:Transcript. Transcript cr
     (Time hour:24 minutes:0 seconds:0) print12HourFormatOn:Transcript. Transcript cr
     (Time hour:12 minutes:0 seconds:0) print12HourFormatOn:Transcript. Transcript cr
     (Time hour:0 minutes:0 seconds:0) print12HourFormatOn:Transcript. Transcript cr
     0 to:24 do:[:h |
	 (Time hour:h minutes:0 seconds:0) print12HourFormatOn:Transcript. Transcript cr
     ]
    "
!

print24HourFormatOn:aStream
    "append a human readable printed representation of the receiver to aStream.
     Format is hh:mm:ss (i.e. 24-hour european format)."

    ^ self
	printOn:aStream
	format:(self class formatString24).

"/    |h m s|
"/
"/    h := self hours.
"/    (h < 10) ifTrue:[aStream nextPut:$0].
"/    h printOn:aStream.
"/    aStream nextPut:$:.
"/    m := self minutes.
"/    (m < 10) ifTrue:[aStream nextPut:$0].
"/    m printOn:aStream.
"/    aStream nextPut:$:.
"/    s := self seconds.
"/    (s < 10) ifTrue:[aStream nextPut:$0].
"/    s printOn:aStream

    "
     Time now print24HourFormatOn:Transcript. Transcript cr
    "
!

printOn:aStream
    "append a human readable printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back.

     Format is hh:mm:ss either in 12-hour or 24-hour format.
     depending on the setting of LanguageTerritory.
     I don't know what ST-80 does here (12-hour format ?)"

    |format|

    format := (self milliseconds = 0)
                    ifTrue:[self class defaultFormatString]
                    ifFalse:[self class defaultFormatStringWithMilliseconds].
    ^ self
        printOn:aStream
        format:format

    "
     Time now printOn:Transcript. Transcript cr
    "

    "Modified: / 16-01-2011 / 11:27:24 / cg"
!

printString12HourFormat
    "return a printed representation in 12 hour format"

    ^ self printStringFormat:(self class formatString12us)

    "
     Time now printString12HourFormat
    "
!

printString24HourFormat
    "return a printed representation in 24 hour format"

    ^ self printStringFormat:(self class formatString24)

    "
     Time now printString24HourFormat
    "

!

shortPrintString
    "dummy - for now"

    ^ self printString

    "Created: 20.6.1997 / 17:17:01 / cg"
! !

!Time methodsFor:'private'!

fromOSTime:osTime
    "set my time in the local timezone, given an osTime"

    |i|

    i := OperatingSystem computeTimeAndDateFrom:osTime.
    self setHours:(i hours) minutes:(i minutes) seconds:(i seconds)

    "Modified: 1.7.1996 / 15:21:06 / cg"
!

fromOSTimeWithMilliseconds:osTime
    "set my time in the local timezone, given an osTime"

    |i|

    i := OperatingSystem computeTimeAndDateFrom:osTime.
    self setHours:(i hours) minutes:(i minutes) seconds:(i seconds) milliseconds:(i milliseconds)
!

fromUtcOSTime:osTime
    "set my time in the local timezone, given an osTime"

    |i|

    i := OperatingSystem computeUTCTimeAndDateFrom:osTime.
    self setHours:(i hours) minutes:(i minutes) seconds:(i seconds)

    "Modified: 1.7.1996 / 15:21:06 / cg"
!

getMilliseconds
    "return the number of milliseconds since midnight"

    ^ timeEncoding
!

getSeconds
    "return the number of seconds since midnight"

    ^ timeEncoding // 1000
!

setHours:h minutes:m seconds:s
    "set my time given individual values"

    self setSeconds:(((h\\24) * 60 * 60 ) + (m * 60) + s).
!

setHours:h minutes:m seconds:s milliseconds:ms
    "set my time given individual values"

    self setMilliseconds:((((h\\24) * 60 * 60 ) + (m * 60) + s) * 1000) + ms.
!

setMilliseconds:millis
    "set my time given milliseconds since midnight.
     Notice the modulo operations here - there cannot be a time beyond 24hours
     (use TimeDuration, if you need that)."

    millis < 0 ifTrue:[
	timeEncoding := (24 * 3600 * 1000) - (millis negated \\ (24 * 3600 * 1000))
    ] ifFalse:[
	timeEncoding := millis
    ].
    timeEncoding >= (24 * 3600 * 1000) ifTrue:[
	timeEncoding := timeEncoding \\ (24 * 3600 * 1000).
    ]

    "
     Time basicNew setSeconds:0
     Time fromSeconds:3601
     Time now seconds
     Time now timeEncoding
     (Time now addDays:5) seconds
     (Time now addDays:5) timeEncoding
    "
!

setSeconds:secs
    "set my time given seconds since midnight.
     Notice the modulo operations here - there cannot be a time beyond 24hours
     (use TimeDuration, if you need that)."

    self setMilliseconds:secs * 1000

    "
     Time basicNew setSeconds:0
     Time fromSeconds:3601
     Time now seconds
     Time now timeEncoding
     (Time now addDays:5) seconds
     (Time now addDays:5) timeEncoding
    "
!

timeEncoding
    "the internal encoding is stricktly private,
     and should not be used outside."

    ^ timeEncoding
!

timeEncoding:encoding
    "the internal encoding is stricktly private,
     and should not be used outside."

    timeEncoding := encoding
! !

!Time class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

