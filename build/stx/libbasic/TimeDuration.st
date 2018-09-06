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

Time subclass:#TimeDuration
	instanceVariableNames:''
	classVariableNames:'DefaultFormatForPrinting TimeDurationZero'
	poolDictionaries:''
	category:'Magnitude-Time'
!

!TimeDuration class methodsFor:'documentation'!

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
    Represents a timestap difference.

    DefaultFormatForPrinting    if non-nil, allows for the variable printFormat to be overwritten
"
! !

!TimeDuration class methodsFor:'instance creation'!

days:d 
    "return a new TimeDuration representing a duration of d days."

    d == 0 ifTrue:[^ TimeDurationZero].
    ^ self hours:(d*24) minutes:0

    "
     TimeDuration days:1  
    "
!

days:d hours:h minutes:m seconds:s 
    "return a new TimeDuration representing a duration of d days, h hours, m minutes and s seconds.
     See also Time now / Date today / Timestamp now."

    ^ self basicNew 
        setHours:(d*24)+h minutes:m seconds:s milliseconds:0

    "
     TimeDuration days:1  hours:2 minutes:33 seconds:0   
     TimeDuration days:4 hours:100 minutes:33 seconds:0   
    "
!

fromHours:hoursInterval
    "return a new TimeDuration representing a duration of n hours."

    ^ self new setSeconds:(hoursInterval * (60*60))

    "
     TimeDuration fromHours:8  
    "
!

fromMilliseconds:n
    "return a new TimeDuration representing a duration of n milliseconds."
    "redefined to disable wrapping at 24hours."

    ^ self new setMilliseconds:n

    "
     TimeDuration fromMilliseconds:500  
     500 milliseconds  
    "

    "Created: / 18-07-2007 / 13:56:25 / cg"
!

fromMinutes:minutesInterval
    "return a new TimeDuration representing a duration of n minutes."

    ^ self new setSeconds:(minutesInterval * 60)

    "
     TimeDuration fromMinutes:120  
    "
!

fromSeconds:secondsInterval
    "return a new TimeDuration representing a duration of n seconds."
    "redefined to disable wrapping at 24hours."

    ^ self new setSeconds:secondsInterval

    "
     TimeDuration fromSeconds:3600  
    "
!

hours:h
    "return a new TimeDuration representing a duration of h hours.
     See also Time now / Date today / Timestamp now."

    h == 0 ifTrue:[^ TimeDurationZero].
    ^ self basicNew setHours:h minutes:0 seconds:0 milliseconds:0

    "
     TimeDuration hours:2 
     TimeDuration hours:100  
    "

    "Created: / 14-07-2007 / 18:15:51 / cg"
!

hours:h minutes:m
    "return a new TimeDuration representing a duration of h hours and m minutes.
     See also Time now / Date today / Timestamp now."

    ^ self basicNew setHours:h minutes:m seconds:0 milliseconds:0

    "
     TimeDuration hours:2 minutes:33 
     TimeDuration hours:100 minutes:33  
    "
!

hours:h minutes:m seconds:s millis:millis
    <resource: #obsolete>
    "return a new TimeDuration representing a duration of h hours, m minutes, s seconds and millis milliseconds.
     See also Time now / Date today / Timestamp now."

    self obsoleteMethodWarning:'use hours:minutes:seconds:milliseconds:'.
    ^ self hours:h minutes:m seconds:s milliseconds:millis

    "
     TimeDuration hours:2 minutes:33 seconds:0 milliseconds:123  
     TimeDuration hours:100 minutes:33 seconds:0 milliseconds:123  
    "
!

hours:h minutes:m seconds:s milliseconds:millis
    "return a new TimeDuration representing a duration of h hours, m minutes, s seconds and millis milliseconds.
     See also Time now / Date today / Timestamp now."

    ^ self basicNew 
        setHours:h minutes:m seconds:s milliseconds:millis

    "
     TimeDuration hours:2 minutes:33 seconds:0 milliseconds:123  
     TimeDuration hours:100 minutes:33 seconds:0 milliseconds:123  
    "
!

microseconds:microseconds
    "return a new TimeDuration representing a duration of microseconds microseconds.
     Currently we do not support this (we round to millis), but maybe later..."

    microseconds == 0 ifTrue:[^ TimeDurationZero].
    ^ self basicNew setMilliseconds:((microseconds / 1000) rounded).

    "
     TimeDuration microseconds:2499 
     TimeDuration microseconds:2500 
     TimeDuration microseconds:12345678900 
    "
!

milliseconds:m
    "return a new TimeDuration representing a duration of m millis.
     See also Time now / Date today / Timestamp now."

    m == 0 ifTrue:[^ TimeDurationZero].
    ^ self basicNew setMilliseconds:m

    "
     TimeDuration milliseconds:2 
    "
!

minutes:m
    "return a new TimeDuration representing a duration of m minutes.
     See also Time now / Date today / Timestamp now."

    m == 0 ifTrue:[^ TimeDurationZero].
    ^ self basicNew setHours:0 minutes:m seconds:0 milliseconds:0

    "
     TimeDuration minutes:2 
    "

    "Created: / 06-08-2007 / 15:32:42 / cg"
!

readFrom:aStringOrStream defaultUnit:defaultUnitOrNilArg onError:exceptionBlock
    "return a new TimeDuration, reading a printed representation from aStream.
     The format is either:
        [n 'yr'] [n 'mon'] [n 'w'] [n 'd'] [n 'h'] [n 'm'] [n 's'] [n 'ms']
        where 
            yr -> year
            mon -> month
            w -> week
            d -> day
            h -> hour
            m -> minutes
            s -> seconds
            ms -> milliseconds
     or:
        h:m:s.ms

     The yr and mon specifiers stand for 365d and 30d respectively.
     If defaultUnitOrNil is non-nil, a plain number is treated as that;
     otherwise, a plain number raises an error.
     Individual components may be negative, as in '1h -10m', which gives 50m
     or the whole duration may be negative, as in '-(1h 10m)'
    "

    ^ [
        |seconds millis str val fraction uIdx unit unitChar1 negative defaultUnitOrNil|

        defaultUnitOrNil := defaultUnitOrNilArg.
        str := aStringOrStream readStream.
        seconds := 0.
        millis := 0.

        negative := false.
        str peek == $- ifTrue:[
            str next.
            str peek == $( ifTrue:[
                |t|
                str next.
                t := self readFrom:str defaultUnit:defaultUnitOrNil onError:[^ exceptionBlock value].
                str skipSeparators.
                str peek == $) ifTrue:[
                    str next.
                    ^ t negated.
                ].
                ^ exceptionBlock value.
            ].                
            negative := true.
        ].
        
        [
            |nextCh|

            val := Integer readFrom:str onError:nil.
            val isNil ifTrue:[^ exceptionBlock value].
            negative ifTrue:[ val := val negated. negative := false. ].
            str peek == $: ifTrue:[
                "/ hour:minutes format
                str next.
                seconds := val*3600.
                val := Integer readFrom:str onError:nil.
                val isNil ifTrue:[^ exceptionBlock value].
                seconds := seconds + (val*60).
                str peek == $: ifTrue:[
                    "/ hour:minutes:seconds format
                    str next.
                    val := Integer readFrom:str onError:nil.
                    val isNil ifTrue:[^ exceptionBlock value].
                    seconds := seconds + val.
                    str peek == $. ifTrue:[
                        "/ hour:minutes:seconds.millis format
                        str next.
                        val := Integer readFrom:str onError:nil.
                        val isNil ifTrue:[^ exceptionBlock value].
                        millis := val.
                    ]
                ].
                ^ self fromMilliseconds:(seconds*1000+millis) rounded asInteger.
            ].
            str peek == $. ifTrue:[
                str next.
                fraction := Number readMantissaFrom:str radix:10.
                val := val + fraction.
            ].
            str skipSeparators.
            str atEnd ifTrue:[
                defaultUnitOrNil isNil ifTrue:[
                    ^ exceptionBlock value
                ].
                "/ no unit given - assume defaultUnit
                unitChar1 := defaultUnitOrNil.
                "/ can be only used for one number
                defaultUnitOrNil := nil.
            ] ifFalse:[
                unitChar1 := str next.
            ].
            uIdx := #($y $w $d $h $m $s) indexOf:unitChar1.
            uIdx == 0 ifTrue:[^ exceptionBlock value].

            str atEnd ifFalse:[ 
                nextCh := str peek
            ].

            (unitChar1 == $m and:[nextCh == $s]) ifTrue:[
                millis := millis + val.
            ] ifFalse:[
                (unitChar1 == $m and:[nextCh == $o]) ifTrue:[
                    unit := 2592000 "24*60*60*30"     "mon"
                ] ifFalse:[
                    unit := #(
                              31536000 "24*60*60*365" "yr"
                              604800 "24*60*60*7"     "w"
                              86400  "24*60*60"       "d"
                              3600                    "h"
                              60                      "m"
                              1 ) at:uIdx.
                ].
                seconds := seconds + (unit * val).
            ].
            [str atEnd not and:[str peek isSeparator not and:[str peek ~~ $)]]] whileTrue:[ str next].
            str skipSeparators.
            "/ done when at the end or a $) is to be read
            str atEnd or:[aStringOrStream isString not and:[str peek == $)]]
        ] whileFalse.
        self fromMilliseconds:(seconds*1000+millis) rounded asInteger.
    ] on:Error do:[:ex |
        |t|

        "/ retry, using inherited readFrom (Object-storeString)
        t := Object readFrom:aStringOrStream onError:[^ exceptionBlock value].
        (t isKindOf:TimeDuration) ifFalse:[
            ^ exceptionBlock value
        ].
        t
    ]

    "
     TimeDuration readFrom:'2' defaultUnit:$h onError:nil -> 2h
     TimeDuration readFrom:'100' defaultUnit:$m onError:nil -> 1h 40m
     TimeDuration readFrom:'100' defaultUnit:$s onError:nil -> 1m 40s
     TimeDuration readFrom:'0200' defaultUnit:$h onError:nil -> 1w 1d 8h

     TimeDuration readFrom:'1h'      
     TimeDuration readFrom:'1h 35m'     
     TimeDuration readFrom:'25h'     
     TimeDuration readFrom:'3d'     
     TimeDuration readFrom:'1w'     
     TimeDuration readFrom:'120s'     
     TimeDuration readFrom:'1500ms'    
     TimeDuration readFrom:'3ms'     
     TimeDuration readFrom:'1yr 5d'     
     TimeDuration readFrom:'1mon'     
     TimeDuration readFrom:'05:10'     
     TimeDuration readFrom:'05:10:5'     
     TimeDuration readFrom:'05:10:5.150'  

     TimeDuration readFrom:'-1h'
     TimeDuration readFrom:'-1h 10m'
     TimeDuration readFrom:'1h -10m'
     TimeDuration readFrom:'-(1h 10m)' 

     TimeDuration readFrom:(TimeDuration new storeString)
    "

    "Modified: / 08-10-2007 / 16:41:48 / cg"
!

readFrom:aStringOrStream onError:exceptionBlock
    "return a new TimeDuration, reading a printed representation from aStream.
     The format is [n 'yr'] [n 'mon'] [n 'w'] [n 'd'] [n 'h'] [n 'm'] [n 's'] [n 'ms']
     where 
            yr -> year
            mon -> month
            w -> week
            d -> day
            h -> hour
            m -> minutes
            s -> seconds
            ms -> milliseconds
     The yr and mon specifiers stand for 365d and 30d respectively.
     If no unit is given (i.e. a plain number string is given), assume seconds.
    "

    ^ self readFrom:aStringOrStream defaultUnit:$s onError:exceptionBlock

    "
     TimeDuration readFrom:'100' onError:nil      
     TimeDuration readFrom:'100' defaultUnit:$m onError:nil 

     TimeDuration readFrom:'1h'      
     TimeDuration readFrom:'1h 35m'     
     TimeDuration readFrom:'25h'     
     TimeDuration readFrom:'3d'     
     TimeDuration readFrom:'1w'     
     TimeDuration readFrom:'120s'     
     TimeDuration readFrom:'1500ms    
     TimeDuration readFrom:'3ms'     
     TimeDuration readFrom:'1yr 5d'     
     TimeDuration readFrom:'1mon'     
    "

    "Modified: / 08-10-2007 / 16:41:48 / cg"
!

seconds:s
    "return a new TimeDuration representing a duration of s seconds.
     See also Time now / Date today / Timestamp now."

    s == 0 ifTrue:[^ TimeDurationZero].

    ^ self basicNew setMilliseconds:(s * 1000)

    "
     TimeDuration seconds:2 
    "

    "Created: / 06-08-2007 / 15:32:21 / cg"
!

weeks:w 
    "return a new TimeDuration representing a duration of w weeks."

    ^ self days:(w * 7)

    "
     TimeDuration weeks:1  
    "

    "Created: / 05-09-2011 / 11:18:27 / cg"
! !

!TimeDuration class methodsFor:'class initialization'!

initialize
    TimeDurationZero isNil ifTrue:[
        TimeDurationZero := self basicNew setHours:0 minutes:0 seconds:0 milliseconds:0.
    ]

    "Modified: / 10-05-2011 / 10:31:35 / cg"
! !

!TimeDuration class methodsFor:'constants'!

zero
    "return the neutral element for addition (0s)"

    ^ TimeDurationZero

    "Modified: 18.7.1996 / 12:26:12 / cg"
! !

!TimeDuration class methodsFor:'format strings'!

defaultFormatForPrinting
    ^  DefaultFormatForPrinting
!

defaultFormatForPrinting:aString
    DefaultFormatForPrinting := aString
!

formatString12us
    "return the format string used to format US times (and other areas)"

    ^ '%h:%m:%s.%i'
!

formatString24
    "return the format string used to format european times (and other areas)"

    ^ '%h:%m:%s.%i'
! !

!TimeDuration class methodsFor:'timing evaluation'!

toRun:aBlock
    "return the TimeDuration it takes to execute aBlock.                          
     A modern variant of Time millisecondsToRun: (which prints itself nicely)"

    ^ self microseconds:(Time microsecondsToRun:aBlock).

    "
     TimeDuration toRun:[ 20000 factorial ]     
     TimeDuration toRun:[ 2000 factorial ]     
     TimeDuration toRun:[ 900 factorial ]     
    "
! !

!TimeDuration methodsFor:'accessing'!

days
    "get the number of days"

    ^ self 
        possiblyNegatedValueFromTimeEncodingInto:[:t |
            t // 1000 // 3600 // 24
        ].    

    "
     (Duration days: 9 hours: 1 minutes: 2 seconds: 3) days
     (Duration days: -9 hours: -1 minutes: -2 seconds: -3) days
    "
!

hours
    "get the number of hours.
     (notice: that is NOT the total number of hours,
     but the fractional part only. Use this only for printing"

    ^ self 
        possiblyNegatedValueFromTimeEncodingInto:[:t |
            (t // 1000 // 3600 \\ 24)
        ]
    "
     (Duration days: 9 hours: 1 minutes: 2 seconds: 3) hours
     (Duration days: -9 hours: -1 minutes: -2 seconds: -3) hours
    "
!

milliseconds
    "get the milliseconds part 
     (notice: that is NOT the total number of millis,
     but the fractional part only. Use this only for printing.
     asMilliseconds or getMilliseconds is probably what you want"

    ^ self 
        possiblyNegatedValueFromTimeEncodingInto:[:t |
            t \\ 1000
        ].    
    "
     (Duration milliseconds:10) milliseconds
     (Duration milliseconds:-10) milliseconds
    "

    "Modified: / 05-05-2010 / 14:22:04 / cg"
!

minutes
    "get the number of minutes.
     (notice: that is NOT the total number of minutes,
     but the fractional part only. Use this only for printing"

    ^ self 
        possiblyNegatedValueFromTimeEncodingInto:[:t |
            t // 1000 // 60 \\ 60
        ]
        
    "
     (Duration days: 9 hours: 1 minutes: 2 seconds: 3) minutes
     (Duration days: -9 hours: -1 minutes: -2 seconds: -3) minutes
    "
!

seconds
    "get the number of seconds.
     (notice: that is NOT the total number of seconds,
     but the fractional part only. Use this only for printing.
     asSeconds or getSeconds is probably what you want"

    ^ self 
        possiblyNegatedValueFromTimeEncodingInto:[:t |
            t // 1000 \\ 60
        ]
        
    "
     (Duration days: 9 hours: 1 minutes: 2 seconds: 3) seconds
     (Duration days: -9 hours: -1 minutes: -2 seconds: -3) seconds
    "
! !

!TimeDuration methodsFor:'arithmetic'!

* aNumber
    "return a new scaled timeDuration"

    aNumber isNumber ifTrue:[
        ^ self species basicNew 
            setMilliseconds:(self getMilliseconds * aNumber) asInteger
    ].
    ^ aNumber productFromTimeDuration:self
    
    "
     (TimeDuration fromString:'10s') * 5
     (TimeDuration fromString:'10s') * 10
     (TimeDuration fromString:'10s') * 100
     (TimeDuration fromString:'10s') * 1000
     (TimeDuration fromString:'-10s') * 1000
    "
!

+ aTimeDurationOrNumberOfSeconds
    "return a new timeDuration"

    aTimeDurationOrNumberOfSeconds isNumber ifTrue:[
        ^ self species basicNew 
            setMilliseconds:(self getMilliseconds + (aTimeDurationOrNumberOfSeconds * 1000) asInteger)
    ].
    ^ self species basicNew
        setMilliseconds:(self getMilliseconds + aTimeDurationOrNumberOfSeconds getMilliseconds)

    "
     (TimeDuration fromString:'1m') + (TimeDuration fromString:'10s') 
     1 minutes + 10 seconds
    "
!

/ aTimeDurationOrNumberOfSeconds
    "if the argument is a number, return a new timeDuration.
     Otherwise, return the quotient as a number."

    aTimeDurationOrNumberOfSeconds isNumber ifTrue:[
        ^ self species basicNew 
            setMilliseconds:(self getMilliseconds / aTimeDurationOrNumberOfSeconds) asInteger
    ].
    aTimeDurationOrNumberOfSeconds isTimeDuration ifTrue:[
        ^ (self getMilliseconds / aTimeDurationOrNumberOfSeconds getMilliseconds)
    ].
    ^ aTimeDurationOrNumberOfSeconds quotientFromTimeDuration:self
    
    "
     (TimeDuration fromString:'10s') / (TimeDuration fromString:'5s')
     (TimeDuration fromString:'10s') / 5
    "
!

abs
    timeEncoding >= 0 ifTrue:[
        ^ self. 
    ].
    ^ self class new timeEncoding:(timeEncoding negated)

    "
        (TimeDuration fromSeconds:20000) abs
        (TimeDuration fromSeconds:-20000) abs
    "
!

negated
    ^ self class new timeEncoding:(timeEncoding negated)
!

productFromFloat:aFloat
    "return a new timeDuration"

    ^ self productFromNumber:aFloat

    "
     5.1 * (TimeDuration fromString:'10s') 
    "
!

productFromFraction:aNumber
    "return a new timeDuration"

    ^ self productFromNumber:aNumber

    "
     (TimeDuration fromString:'10s') * 5
    "
!

productFromInteger:anInteger
    "return a new timeDuration"

    ^ self productFromNumber:anInteger

    "
     5 * (TimeDuration fromString:'10s') 
    "
!

productFromNumber:aNumber
    "return a new timeDuration"

    ^ self species basicNew 
        setMilliseconds:(self getMilliseconds * aNumber) asInteger

    "
     5.1 * (TimeDuration fromString:'10s') 
    "
! !

!TimeDuration methodsFor:'converting'!

asFixedPoint
    "answer the duration is seconds"

    ^ FixedPoint numerator:timeEncoding denominator:1000 scale:4 

    "
        (10 milliseconds)  asFixedPoint
    "
!

asFloat
    "answer the duration is seconds"

    ^ timeEncoding / 1000.0

    "
        (10 milliseconds)  asFloat
    "
!

asFraction
    "answer the duration is seconds"

    ^ timeEncoding / 1000

    "
        (10 milliseconds)  asFraction
    "
!

asInteger
    "answer the duration is seconds"

    ^ self getSeconds
!

asLongFloat
    "answer the duration is seconds"

    ^ timeEncoding / 1000 asLongFloat

    "
        (10 milliseconds)  asLongFloat
    "
!

asNumber
    "answer the duration is seconds.
     Better use the explicit getSeconds"

    ^ self getSeconds
!

asTime
    "return a Time object from the receiver."

    ^ Time hours:(self hours) minutes:(self minutes) seconds:(self seconds)
!

asTimeDuration
    "return a TimeDuration object from the receiver - that's the receiver."

    ^ self
! !

!TimeDuration methodsFor:'double dispatching'!

differenceFromTimestamp:aTimestamp
    "return the timestamp this timeDuration before aTimestamp"

    ^ aTimestamp subtractMilliseconds:(self getMilliseconds)
!

sumFromTimestamp:aTimestamp
    "return the timestamp this timeDuration after aTimestamp"

    ^ aTimestamp addMilliseconds:(self getMilliseconds)
! !

!TimeDuration methodsFor:'printing'!

addPrintBindingsTo:aDictionary language:languageOrNil
    "private print support: add bindings for printing to aDictionary.
     languageOrNil can only be #en or nil for the current language.

     Additional formats available here (for timeDuration) are:
        %(Hd)       hours in day (i.e. 0..23)
        %(hd)       hours in day padded to 2 chars (i.e. 00..23)

        %(yrR)      years rounded (i.e. for 730 days, we get 2 asFixedPoint:1 )
        %(monR)     month rounded (i.e. for 45 days, we get 1.5 asFixedPoint:1 )
        %(w)        weeks 
        %(wR)       weeks rounded (i.e. for 45 days, we get 6.xxx asFixedPoint:1 )
        %(dR)       days rounded (i.e. for 36 hours, we get 1.5 asFixedPoint:1 )
        %(dw)       days in week
        %(hR)       hours rounded (i.e. for 3h 30m, we get 3.5 asFixedPoint:1 )
        %(mR)       minutes rounded (i.e. for 2m 30s, we get 2.5 asFixedPoint:1 )
        %(sR)       seconds rounded to 1 postDecimal (i.e. for 2s 100ms, we get 2.1 asFixedPoint:1 )
    "

    |hoursInDay s yearsRounded monthsRounded weeksRounded daysRounded hoursRounded minutesRounded secondsRounded|

    self addBasicPrintBindingsTo:aDictionary language:languageOrNil.
    aDictionary at:$d put:self days.

    hoursInDay := self hours \\ 24.
    aDictionary at:#Hd put:(s := hoursInDay printString).
    aDictionary at:#hd put:(s leftPaddedTo:2 with:$0).

    aDictionary at:#dw put:(self days \\ 7).

    yearsRounded := (self hours / 24 / 365).
    yearsRounded isInteger ifFalse:[
        yearsRounded := yearsRounded asFixedPoint:1.
    ].
    aDictionary at:#yrR put:yearsRounded.

    monthsRounded := self days / 30.
    monthsRounded isInteger ifFalse:[
        monthsRounded := monthsRounded asFixedPoint:1.
        monthsRounded roundedToScale = monthsRounded asInteger ifTrue:[
            monthsRounded := monthsRounded truncated
        ].
    ].
    aDictionary at:#monR put:monthsRounded.

    aDictionary at:#w put:(self days // 7).
    weeksRounded := self days / 7.
    weeksRounded isInteger ifFalse:[
        weeksRounded := weeksRounded asFixedPoint:1.
        weeksRounded roundedToScale = weeksRounded asInteger ifTrue:[
            weeksRounded := weeksRounded truncated
        ].
    ].
    aDictionary at:#wR put:weeksRounded.

    daysRounded := (self hours / 24).
    daysRounded isInteger ifFalse:[
        daysRounded := daysRounded asFixedPoint:1.
        daysRounded roundedToScale = daysRounded asInteger ifTrue:[
            daysRounded := daysRounded truncated
        ].
    ].
    aDictionary at:#dR put:daysRounded.

    hoursRounded := self hours + (self minutes / 60).
    hoursRounded isInteger ifFalse:[
        hoursRounded := hoursRounded asFixedPoint:1.
        hoursRounded roundedToScale = hoursRounded asInteger ifTrue:[
            hoursRounded := hoursRounded truncated
        ].
    ].
    aDictionary at:#hR put:hoursRounded.

    minutesRounded := self minutes + (self seconds / 60).
    minutesRounded isInteger ifFalse:[
        minutesRounded := minutesRounded asFixedPoint:1.
        minutesRounded roundedToScale = minutesRounded asInteger ifTrue:[
            minutesRounded := minutesRounded truncated
        ].
    ].
    aDictionary at:#mR put:minutesRounded.

    secondsRounded := self seconds + (self milliseconds / 1000).
    secondsRounded isInteger ifFalse:[
        secondsRounded := secondsRounded asFixedPoint:1.
        secondsRounded roundedToScale = secondsRounded asInteger ifTrue:[
            secondsRounded := secondsRounded truncated
        ].
    ].
    aDictionary at:#sR put:secondsRounded.

    "Modified: / 22-02-2011 / 15:55:38 / cg"
!

formatForApproximatePrinting
    "Return a format which is suitable for a human - not meant to be read back.
     In contrast to the regular format, this one only gives a rounded approximation
     of the time duration as useful in information-dialogs or other user-hint-GUI elements.
     For example, in a timeDuration of more than 2hours, the user might not be interested in
     individual seconds or even milliseconds.
     The way this hidding/rounding is done is pure magic heuristics."

    |hours mins secs ms|

    hours := self hours.

    hours >= (24*356*2) ifTrue:[
        ^ '%(yrR)yr'. 
    ].
    hours >= (24*40) ifTrue:[
        ^ '%(monR)mon'. 
    ].
    hours >= 48 ifTrue:[
        ^ '%(dR)d'. 
    ].
    hours >= 24 ifTrue:[
        ^ '%dd %(Hd)h'. 
    ].
    hours >= 2 ifTrue:[
        ^ '%(hR)h'.
    ].
    hours >= 1 ifTrue:[
        ^ '%Hh %Mm'.
    ].

    "/ no hours
    mins := self minutes.
    mins >= 5 ifTrue:[
        ^ '%(mR)m'.
    ].
    mins >= 1 ifTrue:[
        ^ '%Mm %Ss'.
    ].

    "/ no mins
    secs := self seconds.
    secs >= 1 ifTrue:[
        secs >= 30 ifTrue:[
            ^ '%(S)s'.
        ].
        ^ '%(sR)s'.
    ].

    "/ no secs
    ms := self milliseconds.
    ms > 500 ifTrue:[
        ^ '%(sR)s'
    ].

    ^ self formatForPrinting

    "
     (TimeDuration hours:0 minutes:0 seconds:0 millis:12) printStringForApproximation       

     (TimeDuration hours:0 minutes:0 seconds:10 millis:123) printStringForApproximation        
     (TimeDuration hours:0 minutes:1 seconds:10 millis:123) printStringForApproximation        
     (TimeDuration hours:0 minutes:2 seconds:10 millis:123) printStringForApproximation        
     (TimeDuration hours:0 minutes:33 seconds:0 millis:123) printStringForApproximation        
     (TimeDuration hours:2 minutes:0 seconds:0 millis:123) printStringForApproximation         
     (TimeDuration hours:2 minutes:33 seconds:0 millis:123) printStringForApproximation        
     (TimeDuration hours:100 minutes:33 seconds:0 millis:123) printStringForApproximation      
     (TimeDuration hours:10000 minutes:33 seconds:0 millis:123) printStringForApproximation    
     (TimeDuration hours:1000000 minutes:33 seconds:0 millis:123) printStringForApproximation    

     (TimeDuration hours:2 minutes:33 seconds:0 millis:0) printStringForApproximation         
     (TimeDuration hours:2 minutes:0 seconds:0 millis:0) printStringForApproximation          
     (TimeDuration hours:24 minutes:0 seconds:0 millis:0) printStringForApproximation          
    "
!

formatForPrinting
    "Return the format for printing"

    DefaultFormatForPrinting notNil ifTrue:[
        ^ DefaultFormatForPrinting
    ].
    ^ self formatForPrinting:false

    "
     (TimeDuration readFrom:'10h 3s') formatForPrinting  
     (TimeDuration readFrom:'3s') formatForPrinting      
     (TimeDuration readFrom:'1d 2ms') formatForPrinting      
     (TimeDuration readFrom:'1 week') formatForPrinting      
    "
!

formatForShortPrinting
    "Return the short format for printing (without ms)"

    ^ self formatForPrinting:true
!

printAsApproximationOn:aStream
    "append a human readable printed representation of the receiver to aStream.
     The format is meant for a human and does not give all information;
     especially, useless detail is hidden.
     This means, that seconds are rounded or hidden, if the dT is more than a few minutes;
     minutes rounded into the hour or hidden, if its more than a few hours etc.
     The way this is done is pure magic heuristics - let me know, if you have a better algorithm."

    ^ self
        printOn:aStream 
        format:(self formatForApproximatePrinting).

    "
     (TimeDuration hours:0 minutes:0 seconds:0 milliseconds:123) printAsApproximationOn:Transcript
     (TimeDuration hours:0 minutes:0 seconds:10 milliseconds:123) printAsApproximationOn:Transcript
     (TimeDuration hours:0 minutes:33 seconds:0 milliseconds:123) printAsApproximationOn:Transcript
     (TimeDuration hours:2 minutes:0 seconds:0 milliseconds:123) printAsApproximationOn:Transcript
     (TimeDuration hours:2 minutes:33 seconds:0 milliseconds:123) printAsApproximationOn:Transcript
     (TimeDuration hours:100 minutes:33 seconds:0 milliseconds:123) printAsApproximationOn:Transcript
     (TimeDuration hours:10000 minutes:33 seconds:0 milliseconds:123) printAsApproximationOn:Transcript
     (TimeDuration hours:1000000 minutes:33 seconds:0 milliseconds:123) printAsApproximationOn:Transcript

     (TimeDuration hours:2 minutes:33 seconds:0) printAsApproximationOn:Transcript
     (TimeDuration hours:2 minutes:0 seconds:0) printAsApproximationOn:Transcript
     (TimeDuration hours:24 minutes:0 seconds:0) printAsApproximationOn:Transcript
    "

    "Modified: / 18-07-2007 / 14:06:17 / cg"
!

printOn:aStream
    "append a human readable printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    timeEncoding negative ifTrue:[
        aStream nextPutAll:'-('.
        (self class basicNew timeEncoding:timeEncoding negated) printOn:aStream.
        aStream nextPutAll:')'.
        ^  self
    ].
    ^ self
        printOn:aStream 
        format:(self formatForPrinting).

    "
     TimeDuration hours:0 minutes:0 seconds:0 millis:12       

     TimeDuration hours:0 minutes:0 seconds:0 millis:123       
     TimeDuration hours:0 minutes:0 seconds:10 millis:123       
     TimeDuration hours:0 minutes:33 seconds:0 millis:123       
     TimeDuration hours:2 minutes:0 seconds:0 millis:123       
     TimeDuration hours:2 minutes:33 seconds:0 millis:123       
     TimeDuration hours:100 minutes:33 seconds:0 millis:123    
     TimeDuration hours:10000 minutes:33 seconds:0 millis:123    
     TimeDuration hours:1000000 minutes:33 seconds:0 millis:123    

     TimeDuration hours:2 minutes:33 seconds:0 millis:0         
     TimeDuration hours:2 minutes:0 seconds:0 millis:0          
     TimeDuration hours:24 minutes:0 seconds:0 millis:0          

     (TimeDuration hours:0 minutes:0 seconds:0 millis:123) printStringFormat:'%h:%m:%s'       
     (TimeDuration hours:0 minutes:0 seconds:10 millis:123) printStringFormat:'%h:%m:%s'         
     (TimeDuration hours:0 minutes:33 seconds:0 millis:123) printStringFormat:'%h:%m:%s'         
     (TimeDuration hours:2 minutes:33 seconds:0 millis:123) printStringFormat:'%h:%m:%s'         
     (TimeDuration hours:100 minutes:33 seconds:0 millis:123) printStringFormat:'%h:%m:%s'      
     (TimeDuration hours:10000 minutes:33 seconds:0 millis:123) printStringFormat:'%h:%m:%s'      
     (TimeDuration hours:1000000 minutes:33 seconds:0 millis:123) printStringFormat:'%h:%m:%s'      
    "

    "Modified: / 18-07-2007 / 14:06:17 / cg"
!

printShortOn:aStream
    "append a human readable printed representation  
     of the receiver to aStream (without milliseconds)"

    ^ self
        printOn:aStream 
        format:(self formatForShortPrinting).

    "
     TimeDuration hours:0 minutes:0 seconds:0 millis:12       

     TimeDuration hours:0 minutes:0 seconds:0 millis:123       
     TimeDuration hours:0 minutes:0 seconds:10 millis:123       
     TimeDuration hours:0 minutes:33 seconds:0 millis:123       
     TimeDuration hours:2 minutes:0 seconds:0 millis:123       
     TimeDuration hours:2 minutes:33 seconds:0 millis:123       
     TimeDuration hours:100 minutes:33 seconds:0 millis:123    
     TimeDuration hours:10000 minutes:33 seconds:0 millis:123    
     TimeDuration hours:1000000 minutes:33 seconds:0 millis:123    

     TimeDuration hours:2 minutes:33 seconds:0 millis:0         
     TimeDuration hours:2 minutes:0 seconds:0 millis:0          
     TimeDuration hours:24 minutes:0 seconds:0 millis:0          

     (TimeDuration hours:0 minutes:0 seconds:0 millis:123) printStringFormat:'%h:%m:%s'       
     (TimeDuration hours:0 minutes:0 seconds:10 millis:123) printStringFormat:'%h:%m:%s'         
     (TimeDuration hours:0 minutes:33 seconds:0 millis:123) printStringFormat:'%h:%m:%s'         
     (TimeDuration hours:2 minutes:33 seconds:0 millis:123) printStringFormat:'%h:%m:%s'         
     (TimeDuration hours:100 minutes:33 seconds:0 millis:123) printStringFormat:'%h:%m:%s'      
     (TimeDuration hours:10000 minutes:33 seconds:0 millis:123) printStringFormat:'%h:%m:%s'      
     (TimeDuration hours:1000000 minutes:33 seconds:0 millis:123) printStringFormat:'%h:%m:%s'      
    "

    "Modified: / 18-07-2007 / 14:06:17 / cg"
!

printStringForApproximation
    "return a human readable printed representation of the receiver to aStream.
     The format is meant for a human and does not give all information;
     especially, useless detail is hidden.
     This means, that seconds are rounded or hidden, if the dT is more than a few minutes;
     minutes rounded into the hour or hidden, if its more than a few hours etc.
     The way this is done is pure magic heuristics - let me know, if you have a better algorithm."

    ^ self printStringFormat:(self formatForApproximatePrinting).

    "
     (TimeDuration hours:0 minutes:0 seconds:0 milliseconds:123) printStringForApproximation
     (TimeDuration hours:0 minutes:0 seconds:10 milliseconds:123) printStringForApproximation
     (TimeDuration hours:0 minutes:33 seconds:0 milliseconds:123) printStringForApproximation
     (TimeDuration hours:2 minutes:0 seconds:0 milliseconds:123) printStringForApproximation
     (TimeDuration hours:2 minutes:33 seconds:0 milliseconds:123) printStringForApproximation
     (TimeDuration hours:100 minutes:33 seconds:0 milliseconds:123) printStringForApproximation
     (TimeDuration hours:10000 minutes:33 seconds:0 milliseconds:123) printStringForApproximation
     (TimeDuration hours:1000000 minutes:33 seconds:0 milliseconds:123) printStringForApproximation

     (TimeDuration hours:2 minutes:33 seconds:0) printStringForApproximation
     (TimeDuration hours:2 minutes:0 seconds:0) printStringForApproximation
     (TimeDuration hours:24 minutes:0 seconds:0) printStringForApproximation
    "
! !

!TimeDuration methodsFor:'private'!

formatForPrinting:shortFlag
    "Return a format which is suitable for a human - not meant to be read back.
     If shortFlag is true, some millisecond-info is ommitted for longer times."

    |fmt days weeks hours mins secs overAllSeconds millis|

    days := self days.
    weeks := days // 7.
    hours := self hours.
    mins := self minutes.
    secs := self seconds.
    millis := self milliseconds.

    weeks > 0 ifTrue:[
        fmt := '%(w)w %(dw)d %(Hd)h %Mm'.
        secs = 0 ifTrue:[
            fmt := '%(w)w %(dw)d %(Hd)h %Mm'.
            mins = 0 ifTrue:[
                fmt := '%(w)w %(dw)d %(Hd)h'.
                (hours \\ 24) = 0 ifTrue:[
                    fmt := '%(w)w %(dw)d'.
                    (days \\ 7) = 0 ifTrue:[
                        fmt := '%(w)w'.
                    ].
                ].
            ].
        ].
    ] ifFalse:[days > 0 ifTrue:[
        fmt := '%dd %(Hd)h %Mm'.
        secs = 0 ifTrue:[
            fmt := '%dd %(Hd)h %Mm'.
            mins = 0 ifTrue:[
                fmt := '%dd %(Hd)h'.
                (hours \\ 24) = 0 ifTrue:[
                    fmt := '%dd'.
                ].
            ].
        ].
    ] ifFalse:[
        hours > 0 ifTrue:[
            fmt := '%Hh %Mm'.
            secs = 0 ifTrue:[
                fmt := '%Hh %Mm'.
                mins = 0 ifTrue:[
                    fmt := '%Hh'.
                ].
            ].
        ] ifFalse:[
            mins > 0 ifTrue:[
                fmt := '%Mm'.
                secs = 0 ifTrue:[
                    fmt := '%Mm'
                ].
            ] ifFalse:[
                fmt := ''
            ].
        ].
    ]].
    ((secs ~= 0) or:[millis ~= 0])ifTrue:[
        fmt size ~~ 0 ifTrue:[
            fmt := fmt , ' '
        ].
        (millis = 0) ifTrue:[
            fmt := fmt , '%Ss'
        ] ifFalse:[
            secs = 0 ifTrue:[
                fmt := fmt , '%Ims'
            ] ifFalse:[
                shortFlag ifFalse:[
                    "/ show millis
                    fmt := fmt , '%S.%is'
                ] ifTrue:[
                    "/ only show millis if the number of seconds is small
                    overAllSeconds := self asSeconds.
                    overAllSeconds > 2 ifTrue:[
                        overAllSeconds > 10 ifTrue:[
                            overAllSeconds > 300 ifTrue:[
                                fmt := fmt , '%Ss'
                            ] ifFalse:[
                                fmt := fmt , '%S.%(milli1)s'
                            ]
                        ] ifFalse:[
                            fmt := fmt , '%S.%(milli2)s'
                        ]
                    ] ifFalse:[
                        fmt := fmt , '%S.%is'
                    ]
                ]
            ]
        ].
    ] ifFalse:[
        fmt isEmpty ifTrue:[
            fmt := '%Ss'
        ].
    ].

    ^ fmt.

    "
     (TimeDuration hours:0 minutes:0 seconds:0 milliseconds:12) formatForPrinting       

     (TimeDuration hours:0 minutes:0 seconds:0 milliseconds:123) formatForPrinting       
     (TimeDuration hours:0 minutes:0 seconds:10 milliseconds:123) formatForPrinting       
     (TimeDuration hours:0 minutes:33 seconds:0 milliseconds:123) formatForPrinting       
     (TimeDuration hours:2 minutes:0 seconds:0 milliseconds:123) formatForPrinting       
     (TimeDuration hours:2 minutes:33 seconds:0 milliseconds:123) formatForPrinting       
     (TimeDuration hours:100 minutes:33 seconds:0 milliseconds:123) formatForPrinting    
     (TimeDuration hours:10000 minutes:33 seconds:0 milliseconds:123) formatForPrinting    
     (TimeDuration hours:1000000 minutes:33 seconds:0 milliseconds:123) formatForPrinting    

     (TimeDuration hours:0 minutes:38 seconds:22 milliseconds:123) formatForPrinting:true       

     (TimeDuration hours:2 minutes:33 seconds:0 milliseconds:0) formatForPrinting         
     (TimeDuration hours:2 minutes:0 seconds:0 milliseconds:0) formatForPrinting          
     (TimeDuration hours:24 minutes:0 seconds:0 milliseconds:0) formatForPrinting          

     (TimeDuration hours:0 minutes:0 seconds:0 milliseconds:123) printStringFormat:'%h:%m:%s'       
     (TimeDuration hours:0 minutes:0 seconds:10 milliseconds:123) printStringFormat:'%h:%m:%s'         
     (TimeDuration hours:0 minutes:33 seconds:0 milliseconds:123) printStringFormat:'%h:%m:%s'         
     (TimeDuration hours:2 minutes:33 seconds:0 milliseconds:123) printStringFormat:'%h:%m:%s'         
     (TimeDuration hours:100 minutes:33 seconds:0 milliseconds:123) printStringFormat:'%h:%m:%s'      
     (TimeDuration hours:10000 minutes:33 seconds:0 milliseconds:123) printStringFormat:'%h:%m:%s'      
     (TimeDuration hours:1000000 minutes:33 seconds:0 milliseconds:123) printStringFormat:'%h:%m:%s'      
    "

    "Modified: / 18-07-2007 / 14:06:17 / cg"
!

getMilliseconds
    "return the number of milliseconds"

    ^ timeEncoding

    "Modified: / 18-07-2007 / 13:44:33 / cg"
!

getSeconds
    "return the number of seconds"

    ^ timeEncoding // 1000

    "Modified: / 18-07-2007 / 13:44:37 / cg"
!

possiblyNegatedValueFromTimeEncodingInto:aBlock
    timeEncoding < 0 ifTrue:[
        ^ (aBlock value:(timeEncoding negated)) negated
    ].    
    ^ aBlock value:timeEncoding
!

setHours:h minutes:m seconds:s millis:millis
    <resource: #obsolete>
    "set my time given individual values"

    self obsoleteMethodWarning:'use setHours:minutes:seconds:milliseconds:'.
    self setHours:h minutes:m seconds:s milliseconds:millis.
!

setHours:h minutes:m seconds:s milliseconds:millis
    "set my time given individual values"

    self setMilliseconds:((h * 60 * 60 ) + (m * 60) + s) * 1000 + millis.
!

setMilliseconds:millis
    "set my duration given milliseconds.
     Notice that (in contrast to Time), there is no modulo operation here.
     Duration can be longer than a day"

    "/ self assert:(millis isInteger).
    timeEncoding := millis rounded

    "Modified: / 18-07-2007 / 13:44:16 / cg"
!

setSeconds:secs
    "set my timeduration given seconds.
     Notice that (in contrast to Time), there is no modulu operation here.
     Duration can be longer than a day"

    self setMilliseconds:(secs * 1000).

    "Modified: / 18-07-2007 / 13:44:24 / cg"
! !

!TimeDuration methodsFor:'testing'!

isTimeDuration
    ^ true
!

isZero
    ^ self = self class zero
!

negative
    ^ timeEncoding < 0
! !

!TimeDuration class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


TimeDuration initialize!
