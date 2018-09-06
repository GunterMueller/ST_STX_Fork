"{ Encoding: utf8 }"

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

Magnitude subclass:#Date
	instanceVariableNames:'dateEncoding'
	classVariableNames:'DayNames MonthNames DayAbbrevs MonthAbbrevs DefaultFormats
		ShortFormats LongFormats EnvironmentChange'
	poolDictionaries:''
	category:'Magnitude-Time'
!

!Date class methodsFor:'documentation'!

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
    Instances of Date represent dates as year, month and day encoded in the 
    (private & hidden) instance dateEncoding. The value found there is 
    year*100*100 + month*100 + day 
    This makes magnitude-like comparison of dates easy, and the main components
    d,m,y are easily reconstructed (assuming, that this is the stuff most used).
    Do not depend on the internal representation - 
    it is private and not guaranteed for future versions.

    The old representation used days since 1st Jan. 1901 internally - 
    with the new implementation, it is possible to reasonably represent almost 
    any Date.  
    (which insurance companies will like,  
     since they can now represent even very old people's birthday :-)

    Notice: 
        no correction for pre-Gregorian dates (< 1583) is done.
        For dates before 1582 (when calendars were changed from Julian to Grgorian),
        the so called 'proleptic gregorian calendar' is used. 
        This assumes leap years to continue in the past as if a gregorian calendar was used. 
        Thus, 0000 is considered a leap year.

    The printed representation of dates is controlled by resource definitions -
    thus national variants are already supported (see file 'resources/Date.rs').

    Compatibility notice:
        due to historic reasons, there are some methods found twice
        with different names in this class. The old ST/X methods will vanish 
        over time, but kept for a while to support existing applications 
        (the info on how these methods should be named  
         came somewhat late from the testers...).

        Please do not use methods marked as obsolete.

    Most useful methods:

        Date today
        (Date today) addDays:
        (Date today) subtractDays:

    [author:]
        Claus Gittinger

    [see also:]
        Time AbstractTime
        Filename
        OperatingSystem
"
! !

!Date class methodsFor:'initialization'!

initDefaultNames
    "read the language specific names."

    |enDayNames enDayAbbrevs enMonthNames enMonthAbbrevs|

    DayNames := Dictionary new.
    DayAbbrevs := Dictionary new.
    MonthNames := Dictionary new.
    MonthAbbrevs := Dictionary new.
    DefaultFormats := Dictionary new.
    LongFormats := Dictionary new.
    ShortFormats := Dictionary new.

    enDayNames := #('monday'
                    'tuesday'
                    'wednesday'
                    'thursday'
                    'friday'
                    'saturday'
                    'sunday').

    enDayAbbrevs := #('mon' 
                      'tue' 
                      'wed'
                      'thu' 
                      'fri' 
                      'sat' 
                      'sun').

    enMonthNames := #('january'
                      'february'
                      'march'
                      'april'
                      'may'
                      'june'
                      'july'
                      'august'
                      'september'
                      'october'
                      'november'
                      'december').

    enMonthAbbrevs := #('jan'
                        'feb'
                        'mar'
                        'apr'
                        'may'
                        'jun'
                        'jul'
                        'aug'
                        'sep'
                        'oct'
                        'nov'
                        'dec').

    DayNames at:#'en' put:enDayNames.
    DayAbbrevs at:#'en' put:enDayAbbrevs.
    MonthNames at:#'en' put:enMonthNames.
    MonthAbbrevs at:#'en' put:enMonthAbbrevs.

    DefaultFormats at:#'en' put:('%d-%m-%y').
    ShortFormats at:#'en' put:('%d-%m-%y').
    LongFormats at:#'en' put:('%(dayName), %d-%m-%y').

    "/ take the "master" language here, for the caching
    EnvironmentChange := (Smalltalk language asSymbol ~~ #'en').

    "
     Date initDefaultNames
    "
!

initNames
    "read the language specific names."

    |lang|

    DayNames isNil ifTrue:[
        self initDefaultNames.
    ].

    lang := Smalltalk language asSymbol.
    lang ~~ #'en' ifTrue:[
        self initNamesForLanguage: lang.
    ].

    EnvironmentChange := false

    "
     Date initNames
    "
!

initNamesForLanguage:language
    "read the language specific names."

    |resources lang 
     enDayNames enDayAbbrevs enMonthNames enMonthAbbrevs monthAbbrevKeys
     enDefaultFormat enLongFormat enShortFormat may|

    DayNames isNil ifTrue:[
        self initDefaultNames.
    ].

    lang := language asSymbol.
    lang ~~ #'en' ifTrue:[
	ResourcePack notNil ifTrue:[ "/ guard for tinytalk (no libview)
            resources := ResourcePack forPackage:'stx:libbasic' resourceFileName:(language,'.rs') cached:false.
	].
        resources notNil ifTrue:[
            enDayNames := DayNames at:#'en'.
            enDayAbbrevs := DayAbbrevs at:#'en'.
            enMonthNames := MonthNames at:#'en'.
            enMonthAbbrevs := MonthAbbrevs at:#'en'.
            monthAbbrevKeys := enMonthAbbrevs copy.
            monthAbbrevKeys at:5 put:'MAY_ABBREV'.

            enDefaultFormat := DefaultFormats at:#'en'.
            enShortFormat := ShortFormats at:#'en'.
            enLongFormat := LongFormats at:#'en'.

            DefaultFormats at:lang put:(resources at:'DATEFORMAT' default:enDefaultFormat).
            ShortFormats at:lang put:(resources at:'SHORTDATEFORMAT' default:enShortFormat).
            LongFormats at:lang put:(resources at:'LONGDATEFORMAT' default:enLongFormat).

            DayNames at:lang put:(resources array:enDayNames).
            DayAbbrevs at:lang put:(resources array:enDayAbbrevs).
            MonthNames at:lang put:(resources array:enMonthNames).
            MonthAbbrevs at:lang put:(resources array:monthAbbrevKeys).
            "/ may needs special care (same key for long and short name)
            may := resources string:'MAY_ABBREV' default:nil.
            may isNil ifTrue:[
                may := resources string:'may'.
            ].
            (MonthAbbrevs at:lang) at:5 put:may.
        ].
    ].

    "
     Date initNamesForLanguage:#de.
     Date initNamesForLanguage:#fr.
     Date initNamesForLanguage:#es.
    "

    "Modified (format): / 28-09-2011 / 15:56:41 / cg"
!

initialize
    DayNames isNil ifTrue:[
        self initDefaultNames.
    ].

    Smalltalk addDependent:self.
    Smalltalk language ~= 'en' ifTrue:[
        EnvironmentChange := true
    ]
! !

!Date class methodsFor:'instance creation'!

fromDays:dayCount
    "return a new Date, given the day-number starting with 0 at 1.Jan 1901;
     (i.e. 'Date fromDays:0' returns 1st Jan. 1901).
     Date asDays is the reverse operation.
     Notice, that this is not able to represent dates before 1901!!.
     Added for GNU/ST-80 compatibility"

    |year rest d yearIncrement yearAsDays|

    "approx. year"
    year := (dayCount // 366) + 1901.
    yearAsDays := (self yearAsDays:year).

    dayCount < 0 ifTrue:[
        rest := dayCount negated - yearAsDays + 1. "+1 for ST-80 compatibility"
        yearIncrement := -1.
    ] ifFalse:[
        rest := dayCount - yearAsDays + 1. "+1 for ST-80 compatibility"
        yearIncrement := 1.
    ].
    rest > 365 ifTrue:[
        [d := self daysInYear:year. rest > d] whileTrue:[
            "adjust"
            year := year + yearIncrement.
            rest := rest - d.
        ].
    ].

    ^ self newDay:rest year:year

    "
     Date fromDays:0     -> 1 jan 1901
     Date fromDays:365   -> 1 jan 1902
     Date fromDays:730   -> 1 jan 1903
     Date fromDays:1095  -> 1 jan 1904
     Date fromDays:1460  ->31 dec 1904 since 1904 was a leap year
    "

    "Modified: 1.7.1996 / 14:24:25 / cg"
!

fromDaysFrom0:dayCount
    "return a new Date, given the day-number starting with 0 at 1.Jan 0;
     (i.e. 'Date fromDaysSince0:0' returns 1st Jan. 0).
     Date asDaysSince0 is the reverse operation.
     Notice, that this is a private interface.
     Also notice: does not care for Gregorian/Julisn calendar change"

    |year rest d yearIncrement yearAsDaysFrom0|

    "approx. year"
    year := (dayCount // 366).
    yearAsDaysFrom0 := (self yearAsDaysFrom0:year).

    dayCount < 0 ifTrue:[
        rest := dayCount negated - yearAsDaysFrom0 + 1. "+1 for ST-80 compatibility"
        yearIncrement := -1.
    ] ifFalse:[
        rest := dayCount - yearAsDaysFrom0 + 1. "+1 for ST-80 compatibility"
        yearIncrement := 1.
    ].
    rest > 365 ifTrue:[
        [d := self daysInYear:year. rest > d] whileTrue:[
            "adjust"
            year := year + yearIncrement.
            rest := rest - d.
        ].
    ].

    ^ self newDay:rest year:year

    "
     Date fromDaysFrom0:0     -> 1 jan 0
     Date fromDaysFrom0:366   -> 1 jan 1
    "
!

newDay:dayInYear year:year
    "return a new Date, given the year and the day-in-year (starting at 1).
     See also: Date today / Time now / Timestamp now.
     ST-80 compatibility"

    |monthAndDay|

    ((dayInYear between:1 and:365) 
     or:[dayInYear == 366 and:[self leapYear:year]]) ifFalse:[
        "
         this error is triggered, when you try to create a
         day from an invalid day-in-year; 
         for example, 366 in a non-leap year.
         I don't know, if ST-80 wraps to the next year(s) in this case.
        "
        ^ self conversionErrorSignal raiseErrorString:' - Date: invalid day in year'.
    ].
    monthAndDay := self monthAndDayFromDayInYear:dayInYear forYear:year.
    ^ self basicNew year:year month:(monthAndDay at:1) day:(monthAndDay at:2)  

    "
     Date newDay:150 year:1994
     Date newDay:1 year:1994
     Date newDay:1 year:1901
     Date newDay:1 year:1902
     Date newDay:365 year:1992
     Date newDay:366 year:1992
     Date newDay:365 year:1994
     Date newDay:366 year:1994
     Date newDay:0 year:1994

     Date newDay:271 year:2008
     Date newDay:270 year:2008
     Date newDay:271 year:2007
    "

    "Modified: 1.7.1996 / 14:22:24 / cg"
!

newDayInWeek:dayInWeek week:week year:yearArg
    "return a new Date, given the year, the week (1..) and the day in week (1..7).
     See http://en.wikipedia.org/wiki/ISO_week_date"

    |weekDayOfJan4 dayInYear year|

    year := yearArg.
    weekDayOfJan4 := (self year:year month:1 day:4) dayInWeek.
    dayInYear := (week * 7) + dayInWeek - (weekDayOfJan4 + 3).
    dayInYear < 1 ifTrue:[
        dayInYear := dayInYear + (self daysInYear:year-1).
        year := year - 1.
    ].
    dayInYear > (self daysInYear:year) ifTrue:[
        dayInYear := dayInYear - (self daysInYear:year).
        year := year + 1.
    ].
    ^ self newDay:dayInYear year:year.

    "
     Date newDayInWeek:6 week:39 year:2008     
     Date newDayInWeek:1 week:40 year:2014     
     Date newDayInWeek:1 week:44 year:2014     
    "
!

readFrom:aStringOrStream format:aSqueakFormatArrayOrFormatString
    "return a new Date, reading a printed representation from aStream.
     aSqueakFormatArrayOrFormatString may either be a squeak formatArray
         1   day position (1, 2 or 3)
         2   month position (1..3)
         3   year position (1..3)
     or a formatString (see printing instance protocol)."

    ^ self 
        readFrom:aStringOrStream
        format:aSqueakFormatArrayOrFormatString 
        onError:[ self conversionErrorSignal raiseWith:aStringOrStream errorString:' - invalid Date' ]

    "
     Date readFrom:'19:11:1999' format:#( 1 2 3 )
     Date readFrom:'19-nov-1999' format:#( 1 2 3 )
     Date readFrom:'19:11:1999' format:#( 2 1 3 )  -> exception: wrong month
     Date readFrom:'5:12:1999' format:#( 2 1 3 )  
     Date readFrom:'may-12-1999' format:#( 2 1 3 )  
     Date readFrom:'1999 may 12' format:#( 3 2 1 )  
     Date readFrom:'12/31/2001' format:#( 2 1 3 ) 
     Date readFrom:' 31.08.2001' format:#( 1 2 3 )    
     Date readFrom:' 31.dec.2001' format:#( 1 2 3 )    
     Date readFrom:' 31.Dec.2001' format:#( 1 2 3 )    
     Date readFrom:' 31.dez.2001' format:#( 1 2 3 )    

     Date readFrom:'31/12/01' format:'%d %m %y' onError:'fail'       
     Date readFrom:'12/01' format:'%m %y' onError:'fail'       
     Date readFrom:'01' format:'%y' onError:'fail'        
     Date readFrom:'30.01' format:'%d %m' onError:'fail'       
    "

    "Created: 16.11.1995 / 22:50:17 / cg"
    "Modified: 8.10.1996 / 19:25:39 / cg"
!

readFrom:aStringOrStream format:aFormatStringOrSqueakFormatArray language:languageOrNil onError:exceptionBlock
    "return a new Date, reading a printed representation from aStream.
     aFormatStringOrSqueakFormatArray may either be a squeak formatArray
         1   day position (1, 2 or 3)
         2   month position (1..3)
         3   year position (1..3)
     or a formatString (see printing instance protocol).
     For now %d, %m, %monthName, %shortMonthName, %y, %Y, %y1900, %y2000, %y1950 and %y1980 are supported in the formatString.
     y1900 converts 2-digit year YY into 19YY, 
     y2000 into 20YY.
     y1950, y1980 and Y are special; 
     if the year is below 50/80/70, it is converted to 20YY, otherwise to 19YY. 
     The formatString can have any of these characters '-.:,;/' as separator.
     The format may be preceeded by a single numeric length (as in %2d) to specify how many
     characters to read.
     The formatString can also use a space as separator (for  ex. '%d %m %y') and any separator will be allowed.
     However, when a character separator is defined, only that separator will be expected.
     TODO: make this a general feature of all DateAndTime classes.
    "

    |str|

    str := aStringOrStream readStream.

    [
        |day month year dayOfYear monthAndDay|

        aFormatStringOrSqueakFormatArray isArray ifTrue:[
            |arg|

            arg := Array new:3.

            1 to:3 do:[:i|
                |v|

                [str peek isLetterOrDigit] whileFalse:[str next].

                v := (str peek isDigit) ifTrue:[Integer readFrom:str]
                                       ifFalse:[str nextAlphaNumericWord].
                arg at:i put:v
            ].
            year := arg at:(aFormatStringOrSqueakFormatArray at:3).
            day := arg at:(aFormatStringOrSqueakFormatArray at:1).
            month := arg at:(aFormatStringOrSqueakFormatArray at:2).
        ] ifFalse:[
            |formatStream fc c sel somePartAssoc len lStr|

            formatStream := aFormatStringOrSqueakFormatArray readStream.
            
            [formatStream atEnd] whileFalse:[
                fc := formatStream next.
                fc == $% ifTrue:[
                    sel := ''.
                    len := nil.
                    (fc := formatStream peekOrNil) notNil ifTrue:[
                        fc isDigit ifTrue:[
                            len := fc digitValue.
                            formatStream next.
                        ]
                    ].    

                    (fc := formatStream peekOrNil) notNil ifTrue:[
                        fc == $( ifTrue:[
                            formatStream next.
                            sel := formatStream upTo:$)
                        ] ifFalse:[
                            sel := sel , (formatStream throughAnyForWhich:[:ch | ch isLetter])
                        ]
                    ].
                    len notNil ifTrue:[
                        lStr := str next:len.
                        somePartAssoc := self readDatePartFrom:lStr readStream format:sel language:languageOrNil.
                    ] ifFalse:[    
                        somePartAssoc := self readDatePartFrom:str format:sel language:languageOrNil.
                    ].
                    somePartAssoc key == #day ifTrue:[
                        day := somePartAssoc value.
                    ] ifFalse:[somePartAssoc key == #month ifTrue:[
                        month := somePartAssoc value.
                    ] ifFalse:[somePartAssoc key == #year ifTrue:[
                        year := somePartAssoc value.
                    ] ifFalse:[somePartAssoc key == #dayOfYear ifTrue:[
                        dayOfYear := somePartAssoc value.
                    ] ifFalse:[
                        self conversionErrorSignal raiseWith:aStringOrStream errorString:' - unexpected date part'
                    ]]]].
                ] ifFalse:[
                    fc == Character space ifTrue:[
                        "/ Skip most possible separator characters 
                        "/ (if not enough, should check for isNationalAlphaNumeric instead)
                        [(c := str peek) isSeparator 
                         or:[ '-.:,;/\|?<>[]{}()#@!!$&^+=~*_"`' includes:c]] whileTrue:[str next].    
                    ] ifFalse:[
                        str skipSeparators.
                        str next ~= fc ifTrue:[^ exceptionBlock value].
                        str skipSeparators.
                    ]
                ]
            ].
        ].

        dayOfYear notNil ifTrue:[
            monthAndDay := self monthAndDayFromDayInYear:dayOfYear forYear:year.
            month := (monthAndDay at:1).
            day := (monthAndDay at:2).  
        ].
        
        day isNil ifTrue:[ day := 1 ].
        month isNil ifTrue:[ month := 1 ].
        year isNil ifTrue:[ year := self today year ].

        (year between:0 and:99) ifTrue:[
            year := UserPreferences current twoDigitDateHandler value:year.
        ].
        ^ self  year:year month:month day:day.
    ] on:Error do:[:ex| ^ exceptionBlock value].

    "
     Date readFrom:'31 December 1992' printFormat:#(1 2 3) onError:'fail' 
     Date readFrom:'19:11:1999' printFormat:#(1 2 3) onError:'fail'  
     Date readFrom:'December, 5 1992' printFormat:#(1 2 3) onError:'fail' 
     Date readFrom:'3-jan-95' printFormat:#(1 2 3) onError:'fail'          
     Date readFrom:'12/31/1992' printFormat:#(1 2 3) onError:'fail'       
     Date readFrom:'15.4.1992' printFormat:#(1 2 3) onError:'wrong date'  -> german
     Date readFrom:'10.4.1992' printFormat:#(1 2 3) onError:'fail'        -> german
     Date readFrom:'10.4.1992' printFormat:#(1 2 3) onError:['wrong date']
     Date readFrom:'32.4.1992' printFormat:#(1 2 3) onError:['wrong date']
     Date readFrom:'fooBar' printFormat:#(1 2 3) onError:['wrong date']
     Date readFrom:'10.4' printFormat:#(1 2 3) onError:['wrong date']
     Date readFrom:'10041999' printFormat:#(1 2 3) onError:['wrong date']  

     Date readFrom:'31/12/92' printFormat:#(1 2 3) onError:'fail'       
     Date readFrom:'31/12/01' printFormat:#(1 2 3) onError:'fail'       

     Date readFrom:'31/12/01' printFormat:'%d %m %y' onError:'fail'       
     Date readFrom:'12/01' printFormat:'%m %y' onError:'fail'       
     Date readFrom:'01' printFormat:'%y' onError:'fail'       
     Date readFrom:'30.01' printFormat:'%d %m' onError:'fail'     
     Date readFrom:'300180' printFormat:'%2d%2m%2y' onError:'fail' 
     
     Date readFrom:'300170' printFormat:'%2d%2m%2y' onError:'fail'      - gives 2070 as year
     Date readFrom:'300170' printFormat:'%2d%2m%2Y' onError:'fail'      - gives 1970 as year
     Date readFrom:'300169' printFormat:'%2d%2m%2y' onError:'fail'      - gives 2069 as year
     Date readFrom:'300169' printFormat:'%2d%2m%2Y' onError:'fail'      - gives 2069 as year

     Date readFrom:'300170' printFormat:'%2d%2m%2(y1950)' onError:'fail'  - gives 1970 as year   
     Date readFrom:'300170' printFormat:'%2d%2m%2(y1980)' onError:'fail'  - gives 2070 as year   
     Date readFrom:'300181' printFormat:'%2d%2m%2(y1980)' onError:'fail'  - gives 1981 as year   

     Date readFrom:'2015103' printFormat:'%4y%3(dayOfYear)' onError:'fail'   

     Date readFrom:'3-3-1995' printFormat:'%d %m %y' language: #de onError:'fail'          
     Date readFrom:'3-März-1995' printFormat:'%d %monthName %y' language: #de onError:'fail'          
     Date readFrom:'3-mär-1995' printFormat:'%d %shortMonthName %y' language: #de onError:'fail'   
     Date readFrom:'3/mär/1995' printFormat:'%d %shortMonthName %y' language: #de onError:'fail'  
     Date readFrom:'3/mär/1995' printFormat:'%d-%shortMonthName-%y' language: #de onError:'fail'          
     Date readFrom:'3-dez-1995' printFormat:'%d %shortMonthName %y' language: #de onError:'fail'          
     Date readFrom:'3-Dez-1995' printFormat:'%d %shortMonthName %y' language: #de onError:'fail'          
     Date readFrom:'3-Dezember-1995' printFormat:'%d %monthName %y' language: #de onError:'fail'          

    "

    "Created: 16.11.1995 / 22:50:17 / cg"
    "Modified: 8.10.1996 / 19:25:39 / cg"
!

readFrom:aStringOrStream format:aSqueakFormatArrayOrFormatString onError:exceptionBlock
    "return a new Date, reading a printed representation from aStream.
     aSqueakFormatArrayOrFormatString may either be a squeak formatArray
         1   day position (1, 2 or 3)
         2   month position (1..3)
         3   year position (1..3)
     or a formatString (see printing instance protocol).
     All of the %-formats as in the printString are supported here.
     (i.e. %d, %m and %y, %shortMonthName and %monthName)
     In addition, %Y, %y1900, %y2000, %y1950 and %y1980 are supported:
     y1900 converts 2-digit year YY into 19YY, y2000 into 20YY.
     y1950, y1980 and Y are special; if the year is below 50/80/70, it is converted to 20YY, otherwise to 19YY. 
     TODO: make this a general feature of all DateAndTime classes.
    "

    ^ self
        readFrom:aStringOrStream 
        format:aSqueakFormatArrayOrFormatString 
        language:nil 
        onError:exceptionBlock

    "
     Date readFrom:'31 December 1992' format:#(1 2 3) onError:'fail' 
     Date readFrom:'19:11:1999' format:#(1 2 3) onError:'fail'  
     Date readFrom:'December, 5 1992' format:#(1 2 3) onError:'fail' 
     Date readFrom:'3-jan-95' format:#(1 2 3) onError:'fail'          
     Date readFrom:'12/31/1992' format:#(1 2 3) onError:'fail'       
     Date readFrom:'15.4.1992' format:#(1 2 3) onError:'wrong date'  -> german
     Date readFrom:'10.4.1992' format:#(1 2 3) onError:'fail'        -> german
     Date readFrom:'10.4.1992' format:#(1 2 3) onError:['wrong date']
     Date readFrom:'32.4.1992' format:#(1 2 3) onError:['wrong date']
     Date readFrom:'fooBar' format:#(1 2 3) onError:['wrong date']
     Date readFrom:'10.4' format:#(1 2 3) onError:['wrong date']
     Date readFrom:'10041999' format:#(1 2 3) onError:['wrong date']  

     Date readFrom:'31/12/92' format:#(1 2 3) onError:'fail'       
     Date readFrom:'31/12/01' format:#(1 2 3) onError:'fail'       

     Date readFrom:'31/12/01' format:'%d %m %y' onError:'fail'       
     Date readFrom:'12/01' format:'%m %y' onError:'fail'       
     Date readFrom:'01' format:'%y' onError:'fail'       
     Date readFrom:'30.01' format:'%d %m' onError:'fail'       
     Date readFrom:'311201' format:'%2d%2m%2y' onError:'fail'       
    "

    "Created: 16.11.1995 / 22:50:17 / cg"
    "Modified: 8.10.1996 / 19:25:39 / cg"
!

readFrom:aStringOrStream onError:exceptionBlock
    "return a new Date, reading a printed representation from aStream.
     Notice, that this is not the storeString format and 
     is different from the format expected by readFrom:.
     
     BUG:
       For Smalltalk compatibility, this method handles american format (i.e. month/day/year),
       the common format with letter month in the middle (10 December 2007)
       and ISO format (yyyy-mm-dd) - as long as yyyy is > 12.

       It does NOT handle the german/french and other dd-mm-yyyy formats.
       use readFrom:printFormat:onError: for this."

    ^ [
        |str items first second month day year|
        str := aStringOrStream readStream.

        items := #(1 2 3) collect:[:idx|
            [str peek isLetterOrDigit] whileFalse:[str next].
            (str peek isDigit) ifTrue:[
                Integer readFrom:str
            ] ifFalse:[
                str nextAlphaNumericWord
            ].
        ].

        first := items at:1.
        second := items at:2.

        (first isInteger and:[second isInteger and:[first > 12]]) ifTrue:[
            "ISO Date: yyyy-mm-dd"
            year := first.
            month := second.
            day := items at:3.
        ] ifFalse:[
            second isInteger ifTrue:[
                "must be an american date mm/dd/yy"
                month := first.
                day := second.
            ] ifFalse:[
                "3 Dec 2007"
                day := first.
                month := second.
            ].
            year := items at:3.
        ].
        (year between:0 and:99) ifTrue:[
            year := UserPreferences current twoDigitDateHandler value:year.
        ].
        self  year:year month:month day:day.
    ] on:Error do:exceptionBlock.

    "
     Date readFromString:'31 December 1992'  
     Date readFrom:'19:11:1999'  
     Date readFrom:'2007-12-31' onError:'wrong date'.  
     Date readFromString:'December, 5 1992'  
     Date readFromString:'12/31/1992'        
     Date readFromString:'3-jan-95'           
     Date readFromString:'3-jan-01'           
     Date readFromString:'12/31/01'        
     Date readFromString:'15.4.1992'         -> german; leads to an error
     Date readFromString:'10.4.1992'         -> german; leads to a wrong date
     Date readFromString:'10.4.1992' onError:['wrong date']
     Date readFromString:'32.4.1992' onError:['wrong date']
     Date readFromString:'fooBar' onError:['wrong date']
     Date readFromString:'10.4' onError:['wrong date']
     Date readFromString:'10041999' onError:['wrong date']  
    "

    "Created: 16.11.1995 / 22:50:17 / cg"
    "Modified: 8.10.1996 / 19:25:39 / cg"
!

today
    "return a date, representing today.
     See also: Time now / Timestamp now."

    ^ self fromOSTime:(OperatingSystem getOSTime)

    "
     Date today
    "

    "Modified: 1.7.1996 / 15:20:16 / cg"
!

tomorrow
    "return a date, representing tomorrow.
     See also: Time now / Timestamp now."

    ^ self today addDays:1

    "
     Date tomorrow 
     Date tomorrow dayInWeek
    "
!

utcToday
    "return a date, representing today in UTC.
     That is, the current date in London without any daylight saving adjustments.
     See also: Time now / Timestamp now."

    ^ self new fromUtcOSTime:(OperatingSystem getOSTime)

    "
     Date today
     Date utcToday
    "

    "Modified: 1.7.1996 / 15:20:16 / cg"
!

year:year month:month day:day
    "return a new Date, given the day, month and year.
     For your convenience, month may be either an integer 
     or the month's name as a string. 

     WARNING: semantics changed: 0..99 is no longer treated as 1900..1999,
              but as 0..99 now.
              Any such adjustments must be made by the caller of this method now
              (see those, for example readFrom:onError:)"

    |monthIndex ok|

    (year < 100 and:[year > 0]) ifTrue:[
        'Date [warning]: year in [0..99] no longer converted to [1900..1999]' infoPrintCR.
    ].
    year class ~= SmallInteger ifTrue:[
        "we support a lot of future, but LargeInteger years fail in #isLeapYear"
        self conversionErrorSignal raiseWith:year errorString:' - invalid year in Date (way too large)'.
    ].    
    month isInteger ifTrue:[
        monthIndex := month
    ] ifFalse:[
        monthIndex := self indexOfMonth:month
    ].
    (monthIndex == 2 and:[day == 29]) ifTrue:[
        ok := self leapYear:year
    ] ifFalse:[
        ok := day <= (self daysInMonth:month forYear:year)
    ].
    ((day > 0) and:[ok]) ifTrue:[
        ^ self basicNew year:year month:monthIndex day:day.
    ].

    "this error is triggered if you try to create a date from an
     invalid year/month/day combination;
     Such as 29-feb-year, where year is no leap year
    "
    self conversionErrorSignal raiseErrorString:' - invalid date'.

    "
     Date year:1993  month:'may' day:8
     Date year:1993  month:5     day:8
     Date year:2004 month:'feb' day:29
     Date year:2003 month:'feb' day:29
     Date year:5 month:'feb' day:28   
     Date year:95 month:'feb' day:28  
    "
!

yesterday
    "return a date, representing yesterday.
     See also: Time now / Timestamp now."

    ^ self today subtractDays:1

    "
     Date yesterday 
     Date yesterday dayInWeek
    "
! !

!Date class methodsFor:'Compatibility-Dolphin'!

newDay:day monthIndex:month year:year
    "Dolphin compatibility - same as newDay:month:year"

    ^ self year:year month:month day:day 

    "
     Date newDay:8 monthIndex:5 year:1993
    "

    "Modified: 19.4.1996 / 15:28:15 / cg"
! !

!Date class methodsFor:'Compatibility-ST80'!

newDay:day monthNumber:monthIndex year:year
    "ST80 compatibility"

    ^ self year:year month:monthIndex day:day
! !

!Date class methodsFor:'Compatibility-Squeak'!

current
    "return the current date"

    ^ self today

    "
     Date current
    "
!

fromSeconds:seconds
    "Answer an instance of me which is 'seconds' seconds after January 1, 1901."

    | secondsInDay |

    secondsInDay := 24 * 60 * 60.
    ^self fromDays: seconds // secondsInDay

    "
     Date fromSeconds:0
     Date fromSeconds:(24 * 60 * 60 * 365)
    "
!

readMMDDYYYYFrom:aStringOrStream onError:exceptionBlock
    "return a new Date, reading a printed representation from aStream.
     Notice, that this is not the storeString format and 
     is different from the format expected by readFrom:"

    ^ [
        |str monthString month dayString day year yearString|

        str := aStringOrStream readStream.
        monthString := str next:2.
        dayString := str next:2.
        yearString := str next:4.

        year := Integer readFrom:yearString.
        month := Integer readFrom:monthString.
        day := Integer readFrom:dayString.

        self  year:year month:month day:day.
    ] on:Error do:exceptionBlock

    "
     Date readMMDDYYYYFrom:'10041999' onError:['wrong date']  
     Date readMMDDYYYYFrom:'100419' onError:['wrong date']  

     Date readMMDDYYYYFrom:'10040001' onError:['wrong date']  
    "

    "Created: 16.11.1995 / 22:50:17 / cg"
    "Modified: 8.10.1996 / 19:25:39 / cg"
!

readYYYYMMDDFrom:aStringOrStream onError:exceptionBlock
    "return a new Date, reading a printed representation from aStream.
     Notice, that this is not the storeString format and 
     is different from the format expected by readFrom:"

    ^ [
        |str monthString month dayString day yearString year|

        str := aStringOrStream readStream.
        yearString := str next:4.
        monthString := str next:2.
        dayString := str next:2.

        day := Integer readFrom:dayString.
        month := Integer readFrom:monthString.
        year := Integer readFrom:yearString.

        self  year:year month:month day:day
    ] on:Error do:exceptionBlock

    "
     Date readYYYYMMDDFrom:'19991004' onError:['wrong date']  
     Date readYYYYMMDDFrom:'911004' onError:['wrong date']  
    "
! !


!Date class methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    ((something == #Language) or:[something == #LanguageTerritory]) ifTrue:[
        "just remember change for next access"
        EnvironmentChange := true
    ]

    "Created: 15.6.1996 / 15:19:25 / cg"
! !

!Date class methodsFor:'error handling'!

conversionErrorSignal
    "return the signal used for conversion error handling"

    ^ DateConversionError
! !

!Date class methodsFor:'general queries'!

abbreviatedDayNamesForLanguage:languageOrNilForDefault
    "return a collection of short month-names for a given language or the 
     current language if nil is given.
     The returned strings depend on the resource translation file to be present for the 
     given language (i.e. libbasic/resources(<lang>.rs).
     If not, english names are returned"

    |langDayAbbrevs lang|

    (DayAbbrevs isNil or:[EnvironmentChange]) ifTrue:[
        self initNames
    ].
    lang := languageOrNilForDefault notNil ifTrue:[languageOrNilForDefault] ifFalse:[Smalltalk language].
    langDayAbbrevs := DayAbbrevs at:lang ifAbsent:nil.

    "/ If language is not found, try to initialize it from the resources and try again
    langDayAbbrevs isNil ifTrue:[ 
        self initNamesForLanguage: lang.
        "/ If language initialization failed, take english dayAbbrevs
        langDayAbbrevs := DayAbbrevs at:lang ifAbsent:[DayAbbrevs at:#en.].
    ].
    ^ langDayAbbrevs

    "
     self abbreviatedDayNamesForLanguage:#en   
     self abbreviatedDayNamesForLanguage:#de   
     self abbreviatedDayNamesForLanguage:#fr   
     self abbreviatedDayNamesForLanguage:#es   
     self abbreviatedDayNamesForLanguage:#zulu 

     self abbreviatedDayNamesForLanguage:nil   
    "
!

abbreviatedMonthNamesForLanguage:languageOrNilForDefault
    "return a collection of short month-names for a given language or the 
     current language if nil is given.
     The returned strings depend on the resource translation file to be present for the 
     given language (i.e. libbasic/resources(<lang>.rs).
     If not, english names are returned"

    |langMonthAbbrevs lang|

    (MonthAbbrevs isNil or:[EnvironmentChange]) ifTrue:[
        self initNames
    ].
    lang := languageOrNilForDefault notNil ifTrue:[languageOrNilForDefault] ifFalse:[Smalltalk language].
    langMonthAbbrevs := MonthAbbrevs at:lang ifAbsent:nil.

    "/ If language is not found, try to initialize it from the resources and try again
    langMonthAbbrevs isNil ifTrue:[ 
        self initNamesForLanguage: lang.
        "/ If language initialization failed, take english monthAbbrevs
        langMonthAbbrevs := MonthAbbrevs at:lang ifAbsent:[MonthAbbrevs at:#en.].
    ].
    ^ langMonthAbbrevs

    "
     self abbreviatedMonthNamesForLanguage:#en
     self abbreviatedMonthNamesForLanguage:#de
     self abbreviatedMonthNamesForLanguage:#fr
     self abbreviatedMonthNamesForLanguage:#es
     self abbreviatedMonthNamesForLanguage:#zulu

     self abbreviatedMonthNamesForLanguage:nil
    "

    "Modified (format): / 18-07-2011 / 09:34:20 / cg"
!

abbreviatedNameOfDay:dayIndex
    "given a day index (1..7), 
     return the abbreviated name of the day 
     for the current language setting"

    ^ self abbreviatedNameOfDay:dayIndex language:nil

    "
     Date abbreviatedNameOfDay:4
    "
!

abbreviatedNameOfDay:dayIndex language:langOrNilForDefault
    "given a day index (1..7), 
     return the abbreviated name of the day.
     For nil, the current default language us used.
     For unknown languages, english is used." 

    ^ (self abbreviatedDayNamesForLanguage:langOrNilForDefault) at:dayIndex

    "
     Date abbreviatedNameOfDay:4 language:#en    
     Date abbreviatedNameOfDay:4 language:#de    
     Date abbreviatedNameOfDay:4 language:#zulu  
     Date abbreviatedNameOfDay:4 language:nil    
    "
!

abbreviatedNameOfMonth:monthIndex
    "given a month index (1..12), 
     return the abbreviated name of the month
     for the current language setting"


    ^ self abbreviatedNameOfMonth:monthIndex language:nil

    "
     Date abbreviatedNameOfMonth:11
     Date abbreviatedNameOfMonth:12
    "
!

abbreviatedNameOfMonth:monthIndex language:langOrNilForDefault
    "given a month index (1..12), 
     return the abbreviated name of the month.
     For nil, the current default language us used.
     For unknown languages, english is used." 

    ^ (self abbreviatedMonthNamesForLanguage:langOrNilForDefault) at:monthIndex

    "
     Date abbreviatedNameOfMonth:11 language:#en     
     Date abbreviatedNameOfMonth:12 language:#en     
     Date abbreviatedNameOfMonth:12 language:#de     
     Date abbreviatedNameOfMonth:12 language:#fr     
     Date abbreviatedNameOfMonth:12 language:#zulu   
     Date abbreviatedNameOfMonth:12 language:nil     
    "
!

dateAndTimeNow
    "return an array containing the date and time of now.
     As these provide no timezone info, this should be only used for user interface purposes."

    ^ Time dateAndTimeNow

    "
     Date dateAndTimeNow
    "
!

dayNamesForLanguage:languageOrNilForDefault
    "return a collection of day-names for a given language or the 
     current language if nil is given.
     The returned strings depend on the resource translation file to be present for the 
     given language (i.e. libbasic/resources(<lang>.rs).
     If not, english names are returned"

    |langDayNames lang|

    (DayNames isNil or:[EnvironmentChange]) ifTrue:[
        self initNames
    ].
    lang := languageOrNilForDefault notNil ifTrue:[languageOrNilForDefault] ifFalse:[Smalltalk language].
    langDayNames := DayNames at:lang ifAbsent:nil.

    "/ If language is not found, try to initialize it from the resources and try again
    langDayNames isNil ifTrue:[ 
        self initNamesForLanguage: lang.
        "/ If language initialization failed, take english dayNames
        langDayNames := DayNames at:lang ifAbsent:[DayNames at:#en].
    ].
    ^ langDayNames

    "
     self dayNamesForLanguage:#en
     self dayNamesForLanguage:#de
     self dayNamesForLanguage:#fr   
     self dayNamesForLanguage:#es   

     self dayNamesForLanguage:#zulu 
     self dayNamesForLanguage:nil   
    "

    "Modified (format): / 18-07-2011 / 09:34:08 / cg"
!

dayOfFirstWeekInYear:aYear
    "for a given year, return the day corresponding to that year's monday of week-01.
     The 1st week is the one, in which the first thursday is found;
     and the 1st day of that week is the preceeding monday 
     (that means: that the returned day might be a day of the previous year!!)"

    |day dayInWeekOf1stJan firstThursday firstDayInWeek|

    "/ find the first thursday ...
    day := self newDay:1 year:aYear.
    dayInWeekOf1stJan := day dayInWeek.
    dayInWeekOf1stJan > 4 ifTrue:[
        firstThursday := day addDays:(4 - dayInWeekOf1stJan + 7).
    ] ifFalse:[
        firstThursday := day addDays:(4 - dayInWeekOf1stJan).
    ].
    "/ back to the preceeding monday
    firstDayInWeek := firstThursday subtractDays:3.
    ^ firstDayInWeek

    "
     Date newDay:1 year:1900  
     Date dayOfFirstWeekInYear:1900  
     Date dayOfFirstWeekInYear:1998   
     Date dayOfFirstWeekInYear:1999    
     Date dayOfFirstWeekInYear:2000  
     Date dayOfFirstWeekInYear:2001   
    "
!

dayOfWeek:dayName
    "given the name of a day (either string or symbol),
     return the day-index (1 for monday; 7 for sunday).
     Return 0 for invalid day name"

    |d|

    d := self dayOfWeek:dayName language:nil.
    d == 0 ifTrue:[
        d := self dayOfWeek:dayName language:'en'.
    ].
    ^ d

    "
     Date dayOfWeek:'wednesday' 
     Date dayOfWeek:'Wednesday' 
     Date dayOfWeek:'Mittwoch' 
    "
!

dayOfWeek:dayName language:lang
    "given the name of a day (either string or symbol),
     return the day-index (1 for monday; 7 for sunday).
     Return 0 for invalid day name.
     For nil, Smalltalk language is used,
     for unknown languages, english is used." 

    |idx langDayNames|

    langDayNames := self dayNamesForLanguage:lang.

    idx := langDayNames indexOf:dayName.
    idx == 0 ifTrue:[
        idx := langDayNames indexOf:dayName asLowercase.
    ].
    ^ idx

    "
     Date dayOfWeek:'wednesday' language:'en'
     Date dayOfWeek:'Wednesday' language:'en'
    "
!

daysInMonth:month forYear:yearInteger
    "given the name of a month and a year, return the number 
     of days this month has (modified GNU).
     return 0 if the month name was invalid.
     For your convenience, month maybe an integer or name-string."

    |monthIndex "{ Class: SmallInteger }"|

    month isInteger ifTrue:[
	monthIndex := month
    ] ifFalse:[
	monthIndex := self indexOfMonth:month
    ].

    ^ self daysInMonthIndex:monthIndex forYear:yearInteger

    "
     Date daysInMonth:2 forYear:1980
     Date daysInMonth:2 forYear:1981
     Date daysInMonth:'feb' forYear:1981
    "
!

daysInYear:yearInteger
    "return the number of days in a year"

    (self leapYear:yearInteger) ifTrue:[^ 366].
    ^ 365

    "
     Date daysInYear:1900  
     Date daysInYear:1901 
     Date daysInYear:1904 
     Date daysInYear:1980 
     Date daysInYear:1981
    "
!

daysUntilMonth:month forYear:yearInteger
    "given the name of a month and a year, return the number 
     of days from 1st january to last of prev month of that year.
     Return 0 if the month name/index is invalid or is january.
     For your convenience, month maybe an integer or name-string."

    |monthIndex|

    month isInteger ifTrue:[
        monthIndex := month
    ] ifFalse:[
        monthIndex := self indexOfMonth:month
    ].

    ^ self daysUntilMonthIndex:monthIndex forYear:yearInteger

    "
     Date daysUntilMonth:'feb' forYear:1993
     Date daysUntilMonth:'jan' forYear:1993
    "
!

defaultFormatString
    "a language specific format string to present dates in user interfaces.
     Do not use this to store/retrieve dates (use ISO8601 for that)"

    (DefaultFormats isNil or:[EnvironmentChange]) ifTrue:[
        self initNames
    ].
    ^ DefaultFormats at:Smalltalk language ifAbsent:(DefaultFormats at:#en).

    "
     Date today printStringFormat:(Date defaultFormatString).
     Date today printStringFormat:(Date longFormatString).
     Date today printStringFormat:(Date shortFormatString).
    "
!

firstDayOfYear:inYear
    "return the weekDay-index of the 1st-january of the given year.
     1->monday, 2->tuesday, ... 7->sunday"

    | t d |

    ((inYear < 1) or:[ inYear > 9999]) ifTrue:[
        ^ 0.
    ].

    "/ normal Gregorian calendar: one extra day per four years 
    t := 4 + inYear + ((inYear + 3) // 4).

    inYear > 1800 ifTrue:[
        "/ Julian calendar: regular Gregorian less 3 days per 400
        t := t - ((inYear - 1701) // 100) + ((inYear - 1601) // 400).
    ].
    inYear > 1752 ifTrue:[
        "/ calendar changeover
        t := t + 3.
    ].
    d := t \\ 7.
    "/ convert from 0 (sunday) .. 6 (saturday)
    "/ to 1 (munday) .. 7 (sunday)
    d == 0 ifTrue:[^ 7].
    ^ d

    "
     self firstDayOfYear:2000           
     (Date newDay:1 year:2000) dayInWeek 
     self firstDayOfYear:1999      
     (Date newDay:1 year:1999) dayInWeek
     self firstDayOfYear:1998      
     (Date newDay:1 year:1998) dayInWeek    
     self firstDayOfYear:2001           
     (Date newDay:1 year:2001) dayInWeek    
     self firstDayOfYear:2002           
     (Date newDay:1 year:2002) dayInWeek    
     self firstDayOfYear:2006           
     (Date newDay:1 year:2006) dayInWeek    

     self firstDayOfYear:1800           
     (Date newDay:1 year:1800) dayInWeek    
    "
!

indexOfMonth:aMonthString
    "given the name of a month (either string or symbol),
     return the month-index (1 for jan; 12 for december).
     The given string may be a full or abbreviated name,
     case is ignored.
     Return 0 for invalid month name."

    |monthIndex|

    monthIndex := self indexOfMonth:aMonthString language:nil.
    "/ if not found, retry in english
    (monthIndex == 0 and:[ Smalltalk language ~= #en ])
    ifTrue:[
        monthIndex := self indexOfMonth:aMonthString language:#en.
    ].
    ^ monthIndex

    "
     Date indexOfMonth:'jan'
     Date indexOfMonth:'Jan'  
     Date indexOfMonth:'December'
     Date indexOfMonth:'Dezember' 
     Date indexOfMonth:'december' 
     Date indexOfMonth:'dezember' 
    "

    "Modified: / 08-10-2006 / 14:22:06 / cg"
!

indexOfMonth:aMonthString language:languageOrNil
    "given the name of a month (either string or symbol),
     return the month-index (1 for jan; 12 for december).
     The given string may be a full or abbreviated name,
     case is ignored.
     Return 0 for invalid month name.
     For nil, Smalltalk language (i.e. the current language setting) is used,
     for unknown languages, english is used." 

    |idx name langMonthNames langMonthAbbrevs|

    langMonthNames := self monthNamesForLanguage:languageOrNil.
    langMonthAbbrevs := self abbreviatedMonthNamesForLanguage:languageOrNil.

    name := aMonthString asLowercase.
    idx := langMonthAbbrevs indexOf:name.
    idx ~~ 0 ifTrue:[^ idx].
    idx := langMonthNames indexOf:name.
    idx ~~ 0 ifTrue:[^ idx].

    name at:1 put:(name at:1) asUppercase.
    idx := langMonthAbbrevs indexOf:name.
    idx ~~ 0 ifTrue:[^ idx].
    idx := langMonthNames indexOf:name.
    idx ~~ 0 ifTrue:[^ idx].

    ^ idx

    "
     Date indexOfMonth:'jan'      language:#en 
     Date indexOfMonth:'Jan'      language:#en 
     Date indexOfMonth:'December' language:#en 
    "

    "Modified: / 08-10-2006 / 14:20:17 / cg"
!

leapYear:yearInteger
    "return true, if yearInteger is a leap year.
     For years before 1583, the proleptic calendar is used 
     (i.e. assuming there was a gregorian calendar in effect)"

    |y "{ Class: SmallInteger }"|

    y := yearInteger.
    (y \\ 4 == 0) ifTrue:[
        (y \\ 100 ~~ 0) ifTrue:[^ true].
        (y \\ 400 == 0) ifTrue:[^ true]
    ].
    ^ false

    "
     Date leapYear:1992
     Date leapYear:1994
     Date leapYear:1900
     Date leapYear:2000

     Date leapYear:0
     Date leapYear:-1
     Date leapYear:-2
     Date leapYear:-3
     Date leapYear:-4
    "
!

longFormatString
    (LongFormats isNil or:[EnvironmentChange]) ifTrue:[
        self initNames
    ].
    ^ LongFormats at:Smalltalk language ifAbsent:(LongFormats at:#en).

    "
     Date today printStringFormat:(Date defaultFormatString). 
     Date today printStringFormat:(Date longFormatString).    
     Date today printStringFormat:(Date shortFormatString).   
    "
!

monthAndDayFromDayInYear:aDayInYear forYear:yearInteger
    "given a day-in-year (1..365) return an Array containing the
     month index and the day-in-month. Return nil if the argument is invalid."

    |restDays daysInMonth|

    restDays := aDayInYear.
    restDays < 1 ifTrue:[^ nil].

    1 to:12 do:[:m |
	daysInMonth := self daysInMonthIndex:m forYear:yearInteger.
	restDays <= daysInMonth ifTrue:[
	    ^ Array with:m with:restDays
	].
	restDays := restDays - daysInMonth 
    ].
    restDays > daysInMonth ifTrue:[^ nil].
    ^ Array with:12 with:restDays

    "
     Date monthAndDayFromDayInYear:66 forYear:1980
     Date monthAndDayFromDayInYear:66 forYear:1981
    "
!

monthNamesForLanguage:languageOrNilForDefault
    "return a collection of month-names for a given language or the 
     current language if nil is given.
     The returned strings depend on the resource translation file to be present for the 
     given language (i.e. libbasic/resources(<lang>.rs).
     If not, english names are returned"

    |langMonthNames lang|

    (MonthNames isNil or:[EnvironmentChange]) ifTrue:[
        self initNames
    ].
    lang := languageOrNilForDefault notNil ifTrue:[languageOrNilForDefault] ifFalse:[Smalltalk language].
    langMonthNames := MonthNames at:lang ifAbsent:nil.

    "/ If language is not found, try to initialize it from the resources and try again
    langMonthNames isNil ifTrue:[ 
        self initNamesForLanguage: lang.
        "/ If language initialization failed, take english monthNames
        langMonthNames := MonthNames at:lang ifAbsent:[MonthNames at:#en.].
    ].
    ^ langMonthNames

    "
     self monthNamesForLanguage:#en  
     self monthNamesForLanguage:#de  
     self monthNamesForLanguage:#fr   
     self monthNamesForLanguage:#es   

     self monthNamesForLanguage:#zulu 
     self monthNamesForLanguage:nil   
    "

    "Modified: / 18-07-2011 / 09:34:32 / cg"
!

nameOfDay:dayIndex
    "given a day index (1..7), return the name of the day" 

    ^ self nameOfDay:dayIndex language:nil

    "
     Date nameOfDay:1
     Date nameOfDay:4
    "
!

nameOfDay:dayIndex language:lang
    "given a day index (1..7), return the name of the day.
     For nil, Smalltalk language is used,
     for unknown languages, english is used." 

    ^ (self dayNamesForLanguage:lang) at:dayIndex

    "
     Date nameOfDay:4 language:#en
    "
!

nameOfMonth:monthIndex
    "given a month index (1..12), return the name of the month"

    ^ self nameOfMonth:monthIndex language:nil

    "
     Date nameOfMonth:11
     Date nameOfMonth:12
     Date nameOfMonth:4
    "
!

nameOfMonth:monthIndex language:lang
    "given a month index (1..12), return the name of the month.
     For nil, Smalltalk language is used,
     for unknown languages, english is used." 

    ^ (self monthNamesForLanguage:lang) at:monthIndex

    "
     Date nameOfMonth:11 language:#en
     Date nameOfMonth:12 language:#en
     Date nameOfMonth:4  language:#en
    "
!

shortFormatString
    (ShortFormats isNil or:[EnvironmentChange]) ifTrue:[
        self initNames
    ].
    ^ ShortFormats at:Smalltalk language ifAbsent:(ShortFormats at:#en).

    "
     Date today printStringFormat:(Date defaultFormatString).
     Date today printStringFormat:(Date longFormatString).
     Date today printStringFormat:(Date shortFormatString).
    "
!

weekInYearOf:aDateOrTimestamp
    "for a given date or timeStamp, return the week-number.
     The returned week number starts with 1 for the first week which has a thursday in it.
     (see DIN 1355-1/ISO 8601)
     The rule is:
        every monday (and only monday), a new week begins   
        the first week is the one which has at least 4 days of the new year in it
        
     Be prepared: this definition can lead to the 1st week starting in the old year!!"

    |date dayInYear numDays dayOfFirstWeekInYear dayOfFirstWeekInNextYear week|

    date := aDateOrTimestamp asDate.

    dayInYear := date dayInYear.
    dayOfFirstWeekInYear := self dayOfFirstWeekInYear:date year.

    numDays := date subtractDate:dayOfFirstWeekInYear.
    "/ careful with the first days - could be W52/W53 of the previous year ...
    numDays < 0 ifTrue:[
        "/ not in a week here ...
        "/ can be either 52 or 53, depending on the previous year.
        ^ self weekInYearOf:(self year:date year - 1  month:12 day:31) 
    ].

    "/ compute the week 
    week := numDays // 7 + 1.

    "/ careful with the last days - could be W01 of the next year ...
    week == 53 ifTrue:[
        dayOfFirstWeekInNextYear := self dayOfFirstWeekInYear:aDateOrTimestamp year + 1.
        date >= dayOfFirstWeekInNextYear ifTrue:[
            ^ 1
        ].
    ].
    ^ week

    "
     Timestamp now weekInYear    
     Date weekInYearOf:(Date newDay:31 month:12 year:1999)     was a friday; 
     Date weekInYearOf:(Timestamp newDay:1 year:2000)    was a saturday; therefore last week of 1999
     Date weekInYearOf:(Timestamp newDay:2 year:2000)    was a sunday; therefore last week of 1999
     Date weekInYearOf:(Timestamp newDay:3 year:2000)    was a monday -> W01
     Date weekInYearOf:(Timestamp newDay:4 year:2000)    was a tuesday -> W01
     Date weekInYearOf:(Timestamp newDay:5 year:2000)    was a wed    -> W01
     Date weekInYearOf:(Timestamp newDay:6 year:2000)    was a thursday -> W01
     Date weekInYearOf:(Timestamp newDay:7 year:2000)    was a fri    -> W01
     Date weekInYearOf:(Timestamp newDay:8 year:2000)    was a sat   -> W01
     Date weekInYearOf:(Timestamp newDay:9 year:2000)    was a sun   -> W01
     Date weekInYearOf:(Timestamp newDay:10 year:2000)   was a monday -> W02
     Date weekInYearOf:(Timestamp newDay:16 year:2000)   was a sunday -> W02
     Date weekInYearOf:(Timestamp newDay:17 year:2000)   was a monday -> W03
     Date weekInYearOf:(Date newDay:1 month:1 year:2001)     
     Date weekInYearOf:(Date newDay:2 month:1 year:2001)     
     Date weekInYearOf:(Date newDay:3 month:1 year:2001)     
     Date weekInYearOf:(Date newDay:24 month:12 year:2001)   -> W52
     Date weekInYearOf:(Date newDay:30 month:12 year:2001)   -> W52
     Date weekInYearOf:(Date newDay:31 month:12 year:2001)   -> W01
     Date weekInYearOf:(Date newDay:1 month:1 year:2002)    
     Date weekInYearOf:(Date newDay:2 month:1 year:2002)      
     Date weekInYearOf:(Date newDay:7 month:1 year:2002)      
     Date weekInYearOf:(Date newDay:26 month:9 year:2008) 
     Date weekInYearOf:(Date newDay:27 month:9 year:2008)
     Date weekInYearOf:(Date newDay:4 month:1 year:2008)

     Date weekInYearOf:(Date newDay:1 month:1 year:2010) 
     Date weekInYearOf:(Date newDay:2 month:1 year:2010) 
     Date weekInYearOf:(Date newDay:3 month:1 year:2010) 
     Date weekInYearOf:(Date newDay:4 month:1 year:2010) 
    "
!

yearAsDays: yearInteger
    "Returns the number of days since Jan 1, 1901. (GNU)
     to the first Jan of the year, yearInteger.
     For 1901 this is zero, for 1902 it's 365.
     Defined for years >= 1901"

    |y "{ Class: SmallInteger }"|

    y := yearInteger - 1900.
    y := y - 1.
    ^ (y * 365)
        + (y // 4)
        - (y // 100)
        + ((y + 300) // 400)

    "
     Date yearAsDays:5 
     Date yearAsDays:1900 
     Date yearAsDays:1901 
     Date yearAsDays:1902   
     Date yearAsDays:1903   
     Date yearAsDays:1904    
     Date yearAsDays:1905     
     Date yearAsDays:1994   
     (Date yearAsDays:2001) - (Date yearAsDays:2000)   
    "
!

yearAsDaysFrom0: yearInteger
    "Returns the number of days since Jan 1, 0 to Jan 1, yearInteger
     without caring for gregorian calendar change
     (i.e. as if there was a gregorian for all time).
     Also assuming that the leapYear rules were present in pre-gregorian times also.
     Used internally to compute date differences.

     In previous versions, dates were counted relative to 1.1.1901.
     This is no longer done; however, for backward compatibility, the old yearAsDays
     and Date fromDays is still supported.

     For years >= 1901 it must hold that:
        yearAsDaysFrom0(d1) - yearAsDaysFrom0(d2)
     is the same as
        yearAsDays(d1) - yearAsDays(d2)
    "

    |y "{ Class: SmallInteger }"|

    yearInteger == 0 ifTrue:[^ 0].
    y := yearInteger - 1.
    ^ 366             "/ 0 would have been a leap year
        + (y * 365)
        + (y // 4)    "/ every 4th year is a leap year
        - (y // 100)  "/ but not evey 100th
        + (y // 400)  "/ but evey 400th is

    "
     Date yearAsDaysFrom0:1900 
     Date yearAsDaysFrom0:1901 
     Date yearAsDaysFrom0:1902   
     Date yearAsDaysFrom0:1903   
     Date yearAsDaysFrom0:1904    
     Date yearAsDaysFrom0:1905     
     Date yearAsDaysFrom0:1994 

     (Date yearAsDays:2001) - (Date yearAsDays:2000)   
     (Date yearAsDaysFrom0:2001) - (Date yearAsDaysFrom0:2000)   

     (Date yearAsDays:2002) - (Date yearAsDays:2001)           
     (Date yearAsDaysFrom0:2002) - (Date yearAsDaysFrom0:2001)   

     Date yearAsDaysFrom0:-4     -1461  -- -4 was a leap year
     Date yearAsDaysFrom0:-3     -1095
     Date yearAsDaysFrom0:-2     -730
     Date yearAsDaysFrom0:-1     -365
     Date yearAsDaysFrom0:0      0
     Date yearAsDaysFrom0:1      366     -- 0 was a leap year
     Date yearAsDaysFrom0:2      731
     Date yearAsDaysFrom0:3      1096
     Date yearAsDaysFrom0:4      1461
     Date yearAsDaysFrom0:5      1827    -- 0 and 4 are leap years
    "
! !


!Date class methodsFor:'obsolete'!

day:day month:month year:year
    "return a new Date, given the day, month and year.
     Obsolete:
        use newDay:month:year: for ST-80 compatibility"

    <resource: #obsolete>

    "sr: #storeString has this format,
     you really want to remove this method somewhen???
     if yes, please change #storeString also to #newDay:"

    self obsoleteMethodWarning:'use #year:month:day: (2014-09)'.
    ^ self year:year month:month day:day

    "Modified (comment): / 16-07-2015 / 15:32:14 / sr"
!

day:dayInYear year:year
    "return a new Date, given the year and the day-in-year (starting at 1).
     Obsolete:
        use newDay:year: for ST-80 compatibility"

    <resource: #obsolete>

    self obsoleteMethodWarning:'use #newDay:year: (2014-09)'.
    ^ self newDay:dayInYear year:year
!

isLeapYear:yearInteger
    "Return true, if a year is a leap year.
     Obsolete:
         Please use the ST-80 compatible #leapYear for new programs, 
         since this method will vanish."
    <resource:#obsolete>

    self obsoleteMethodWarning:'use #leapYear: (2014-09)'.
    ^ self leapYear:yearInteger
!

newDay:day month:month year:year
    "backward compatibility"

    ^ self year:year month:month day:day
!

readFrom:aStringOrStream printFormat:aSqueakFormatArrayOrFormatString
    "OBSOLETE: kept for backward compatibility.
     return a new Date, reading a printed representation from aStream.
     aSqueakFormatArrayOrFormatString may either be a squeak formatArray
         1   day position (1, 2 or 3)
         2   month position (1..3)
         3   year position (1..3)
     or a formatString (see printing instance protocol)."

    ^ self 
        readFrom:aStringOrStream
        format:aSqueakFormatArrayOrFormatString 

    "
     Date readFrom:'19:11:1999' printFormat:#( 1 2 3 )
     Date readFrom:'19-nov-1999' printFormat:#( 1 2 3 )
     Date readFrom:'19:11:1999' printFormat:#( 2 1 3 )  -> exception: wrong month
     Date readFrom:'5:12:1999' printFormat:#( 2 1 3 )  
     Date readFrom:'may-12-1999' printFormat:#( 2 1 3 )  
     Date readFrom:'1999 may 12' printFormat:#( 3 2 1 )  
     Date readFrom:'12/31/2001' printFormat:#( 2 1 3 ) 
     Date readFrom:' 31.08.2001' printFormat:#( 1 2 3 )    
     Date readFrom:' 31.dec.2001' printFormat:#( 1 2 3 )    
     Date readFrom:' 31.Dec.2001' printFormat:#( 1 2 3 )    
     Date readFrom:' 31.dez.2001' printFormat:#( 1 2 3 )    

     Date readFrom:'31/12/01' printFormat:'%d %m %y' onError:'fail'       
     Date readFrom:'12/01' printFormat:'%m %y' onError:'fail'       
     Date readFrom:'01' printFormat:'%y' onError:'fail'        
     Date readFrom:'30.01' printFormat:'%d %m' onError:'fail'       
    "

    "Created: 16.11.1995 / 22:50:17 / cg"
    "Modified: 8.10.1996 / 19:25:39 / cg"
!

readFrom:aStringOrStream printFormat:aFormatStringOrSqueakFormatArray language:languageOrNil onError:exceptionBlock
    "OBSOLETE: kept for backward compatibility
     return a new Date, reading a printed representation from aStream.
     aFormatStringOrSqueakFormatArray may either be a squeak formatArray
         1   day position (1, 2 or 3)
         2   month position (1..3)
         3   year position (1..3)
     or a formatString (see printing instance protocol).
     For now %d, %m, %monthName, %shortMonthName, %y, %y1900, %y2000, %y1950 and %y1980 are supported in the formatString.
     y1900 converts 2-digit year YY into 19YY, y2000 into 20YY.
     y1950 and y1980 are special; if the year is below 50/80, it is converted to 20YY, otherwise to 19YY. 
     The formatString can have any of these characters '-.:,;/' as separator.
     The format may be preceeded by a single numeric length (as in %2d) to specify how many
     characters to read.
     The formatString can also use a space as separator (for  ex. '%d %m %y') and any separator will be allowed.
     However, when a character separator is defined, only that separator will be expected.
     TODO: make this a general feature of all DateAndTime classes.
    "

    ^ self readFrom:aStringOrStream format:aFormatStringOrSqueakFormatArray language:languageOrNil onError:exceptionBlock


    "
     Date readFrom:'31 December 1992' format:#(1 2 3) onError:'fail' 
     Date readFrom:'19:11:1999' format:#(1 2 3) onError:'fail'  
     Date readFrom:'December, 5 1992' format:#(1 2 3) onError:'fail' 
     Date readFrom:'3-jan-95' format:#(1 2 3) onError:'fail'          
     Date readFrom:'12/31/1992' format:#(1 2 3) onError:'fail'       
     Date readFrom:'15.4.1992' format:#(1 2 3) onError:'wrong date'  -> german
     Date readFrom:'10.4.1992' format:#(1 2 3) onError:'fail'        -> german
     Date readFrom:'10.4.1992' format:#(1 2 3) onError:['wrong date']
     Date readFrom:'32.4.1992' format:#(1 2 3) onError:['wrong date']
     Date readFrom:'fooBar' format:#(1 2 3) onError:['wrong date']
     Date readFrom:'10.4' format:#(1 2 3) onError:['wrong date']
     Date readFrom:'10041999' format:#(1 2 3) onError:['wrong date']  

     Date readFrom:'31/12/92' format:#(1 2 3) onError:'fail'       
     Date readFrom:'31/12/01' format:#(1 2 3) onError:'fail'       

     Date readFrom:'31/12/01' format:'%d %m %y' onError:'fail'       
     Date readFrom:'12/01' format:'%m %y' onError:'fail'       
     Date readFrom:'01' format:'%y' onError:'fail'       
     Date readFrom:'30.01' format:'%d %m' onError:'fail'     
     Date readFrom:'300180' format:'%2d%2m%2y' onError:'fail' 
     
     Date readFrom:'300170' format:'%2d%2m%2y' onError:'fail'      - gives 2070 as year
     Date readFrom:'300170' format:'%2d%2m%2(y1950)' onError:'fail'  - gives 1970 as year   
     Date readFrom:'300170' format:'%2d%2m%2(y1980)' onError:'fail'  - gives 2070 as year   
     Date readFrom:'300181' format:'%2d%2m%2(y1980)' onError:'fail'  - gives 1981 as year   

     Date readFrom:'3-3-1995' format:'%d %m %y' language: #de onError:'fail'          
     Date readFrom:'3-März-1995' format:'%d %monthName %y' language: #de onError:'fail'          
     Date readFrom:'3-mär-1995' format:'%d %shortMonthName %y' language: #de onError:'fail'   
     Date readFrom:'3/mär/1995' format:'%d %shortMonthName %y' language: #de onError:'fail'  
     Date readFrom:'3/mär/1995' format:'%d-%shortMonthName-%y' language: #de onError:'fail'          
     Date readFrom:'3-dez-1995' format:'%d %shortMonthName %y' language: #de onError:'fail'          
     Date readFrom:'3-Dez-1995' format:'%d %shortMonthName %y' language: #de onError:'fail'          
     Date readFrom:'3-Dezember-1995' format:'%d %monthName %y' language: #de onError:'fail'          
    "

    "Created: 16.11.1995 / 22:50:17 / cg"
    "Modified: 8.10.1996 / 19:25:39 / cg"
!

readFrom:aStringOrStream printFormat:aSqueakFormatArrayOrFormatString onError:exceptionBlock
    "return a new Date, reading a printed representation from aStream.
     aSqueakFormatArrayOrFormatString may either be a squeak formatArray
         1   day position (1, 2 or 3)
         2   month position (1..3)
         3   year position (1..3)
     or a formatString (see printing instance protocol).
     All of the %-formats as in the printString are supported here.
     (i.e. %d, %m and %y, %shortMonthName and %monthName)
     In addition, %y1900, %y2000, %y1950 and %y1980 are supported:
     y1900 converts 2-digit year YY into 19YY, y2000 into 20YY.
     y1950 and y1980 are special; if the year is below 50/80, it is converted to 20YY, otherwise to 19YY. 
     TODO: make this a general feature of all DateAndTime classes.
    "

    ^ self readFrom:aStringOrStream format:aSqueakFormatArrayOrFormatString onError:exceptionBlock

    "
     Date readFrom:'31 December 1992' format:#(1 2 3) onError:'fail' 
     Date readFrom:'19:11:1999' format:#(1 2 3) onError:'fail'  
     Date readFrom:'December, 5 1992' format:#(1 2 3) onError:'fail' 
     Date readFrom:'3-jan-95' format:#(1 2 3) onError:'fail'          
     Date readFrom:'12/31/1992' format:#(1 2 3) onError:'fail'       
     Date readFrom:'15.4.1992' format:#(1 2 3) onError:'wrong date'  -> german
     Date readFrom:'10.4.1992' format:#(1 2 3) onError:'fail'        -> german
     Date readFrom:'10.4.1992' format:#(1 2 3) onError:['wrong date']
     Date readFrom:'32.4.1992' format:#(1 2 3) onError:['wrong date']
     Date readFrom:'fooBar' format:#(1 2 3) onError:['wrong date']
     Date readFrom:'10.4' format:#(1 2 3) onError:['wrong date']
     Date readFrom:'10041999' format:#(1 2 3) onError:['wrong date']  

     Date readFrom:'31/12/92' format:#(1 2 3) onError:'fail'       
     Date readFrom:'31/12/01' format:#(1 2 3) onError:'fail'       

     Date readFrom:'31/12/01' format:'%d %m %y' onError:'fail'       
     Date readFrom:'12/01' format:'%m %y' onError:'fail'       
     Date readFrom:'01' format:'%y' onError:'fail'       
     Date readFrom:'30.01' format:'%d %m' onError:'fail'       
     Date readFrom:'311201' format:'%2d%2m%2y' onError:'fail'       
    "

    "Created: 16.11.1995 / 22:50:17 / cg"
    "Modified: 8.10.1996 / 19:25:39 / cg"
! !


!Date class methodsFor:'private'!

dayAbbrevsForLanguage:languageOrNilForDefault
    <resource: #obsolete>
    "return a collection of short day-names for a given language or the 
     current language if nil is given.
     The returned strings depend on the resource translation file to be present for the 
     given language (i.e. libbasic/resources(<lang>.rs).
     If not, english names are returned"

    ^ self abbreviatedDayNamesForLanguage:languageOrNilForDefault

    "
     self dayAbbrevsForLanguage:#en
     self dayAbbrevsForLanguage:#de
     self dayAbbrevsForLanguage:#fr
     self dayAbbrevsForLanguage:#es
     self dayAbbrevsForLanguage:nil
     self dayAbbrevsForLanguage:#zulu
    "

    "Modified (format): / 18-07-2011 / 09:34:14 / cg"
!

daysInMonthIndex: monthIndex forYear: yearInteger
    "return the number of days in month monthIndex of
     year yearInteger (modified GNU).
     Return 0 for invalid month index.
     This is the internal version of daysInMonth:forYear:"

    |days|

    (monthIndex between:1 and:12) ifFalse:[^ 0].

    days := #(31 28 31           "Jan Feb Mar"
	      30 31 30           "Apr May Jun"
	      31 31 30           "Jul Aug Sep"
	      31 30 31           "Oct Nov Dec"
	     ) at: monthIndex.

    (monthIndex == 2) ifTrue:[
	(self leapYear:yearInteger) ifTrue:[
	    ^ days + 1
	]
    ].
    ^ days

    "
     Date daysInMonthIndex:2 forYear:1994
     Date daysInMonthIndex:2 forYear:1980
     Date daysInMonthIndex:2 forYear:1981
    "
!

daysUntilMonthIndex: monthIndex forYear: yearInteger
    "return the number of days from 1st January up to month monthIndex of
     year yearInteger (modified GNU).
     Return 0 for invalid month index.
     This is the internal version of dayInMonth:forYear:"

    |days|

    "
       |sum|
       sum := 0.
       #(31 28 31          
         30 31 30          
         31 31 30          
         31 30 31          
        ) collect:[:each | |first| first:= sum. sum := sum + each. first]
                #(0 31 59 90 120 151 181 212 243 273 304 334)
    "

    (monthIndex between:1 and:12) ifFalse:[^ 0].

    days := #(0 31 59 90 120 151 181 212 243 273 304 334) at: monthIndex.

    (monthIndex > 2) ifTrue:[
        (self leapYear:yearInteger) ifTrue:[
            ^ days + 1
        ]
    ].
    ^ days

    "
     Date daysUntilMonthIndex:3 forYear:1994
     Date daysUntilMonthIndex:3 forYear:1980
     Date daysUntilMonthIndex:3 forYear:1981
    "
! !

!Date class methodsFor:'private-encoding/decoding'!

encodeYear:y month:m day:d
    "the internal encoding is strictly private, 
     and should not be used outside."

    "this encoding was chosen to be easily readable...
     and also sortable"
    ^ (((y * 100) + m) * 100) + d
!

readDatePartFrom:str format:fmt language:languageOrNil
    "read a single component (such as %shortName) from str"

    |dayName monthName day month year format string dayOfYear|

    format := fmt.
    string := str throughAnyForWhich:[:ch | ch isNationalAlphaNumeric].

    ((format sameAs:'dayName') or:[format sameAs:'shortDayName']) ifTrue:[
        "/ skipped, in case the format is 'monday, 23rd of may...' - not used for decoding
        dayName := string.
        ^ nil.
    ].
    ((format sameAs:'d') or:[format sameAs:'day']) ifTrue:[
        day := Integer readFrom:string.
        ^ #day -> day
    ].

    ((format sameAs:'m') or:[format sameAs:'month']) ifTrue:[
        month := Integer readFrom:string.      
        ^ #month -> month
    ].
    (format sameAs:'monthName') ifTrue:[
        monthName := string.
        month := (self monthNamesForLanguage:languageOrNil) findFirst:[:m | monthName sameAs:m].
"/        month == 0 ifTrue:[self error:'invalid month name'].
        ^ #month -> month
    ].
    (format sameAs:'shortMonthName') ifTrue:[
        monthName := string.
        month := (self abbreviatedMonthNamesForLanguage:languageOrNil) findFirst:[:m | monthName sameAs:m].
"/        month == 0 ifTrue:[self error:'invalid month name'].
        ^ #month -> month
    ].

    format = 'y1900' ifTrue:[
        year := Integer readFrom:string.
        year < 100 ifTrue:[
            ^ #year -> (year + 1900)
        ].
        ^ #year -> year
    ].
    
    format = 'y1950' ifTrue:[
        "shift YY into 1950..2049; for 2k support of old date strings" 
        year := Integer readFrom:string.
        year < 100 ifTrue:[
            year < 50 ifTrue:[
                ^ #year -> (year + 2000)
            ].
            ^ #year -> (year + 1900)
        ].
        ^ #year -> year
    ].

    format = 'y1980' ifTrue:[
        "shift YY into 1980..2079; for 2k support of old date strings" 
        year := Integer readFrom:string.
        year < 100 ifTrue:[
            year < 80 ifTrue:[
                ^ #year -> (year + 2000)
            ].
            ^ #year -> (year + 1900)
        ].
        ^ #year -> year
    ].

    (format = 'Y') ifTrue:[
        "shift YY into 1970..2069; for 2k support of old date strings" 
        year := Integer readFrom:string.
        year < 100 ifTrue:[
            year < 70 ifTrue:[
                ^ #year -> (year + 2000)
            ].
            ^ #year -> (year + 1900)
        ].
        ^ #year -> year
    ].
    
    ((format = 'y') or:[format sameAs:'year']) ifTrue:[
        year := Integer readFrom:string.
        year < 100 ifTrue:[
            ^ #year -> (year + 2000)
        ].
        ^ #year -> year
    ].
    
    (format sameAs:'dayOfYear') ifTrue:[
        dayOfYear := Integer readFrom:string.      
        ^ #dayOfYear -> dayOfYear
    ].

    self error:'unknown format specifier: ',format
! !

!Date class methodsFor:'private-instance creation'!

fromOSTime:osTime
    "return a date, representing the date given by the operatingSystem time.
     This somewhat clumsy implementation hides the OS's date representation
     (i.e. makes this class independent of what the OS starts its time values with).
     Don't use this method, the osTime representation is totally unportable."

    ^ self basicNew fromOSTime:osTime

    "
     Date fromOSTime:0              -> on UNIX: this should return 1st Jan 1970
                                       that's where Unix time starts
                                       On other systems, it may be something different.

     Date fromOSTime:(24*60*60*1000) -> on UNIX: the day after
    "
! !


!Date methodsFor:'Compatibility-ANSI'!

dayOfWeek
    "return the week-day of the receiver - 1 is sunday, 7 for saturday.
     WARNING: different from dayInWeek (which returns 1 for monday, ... 7 for sunday).  
    "

    |d|

    d := self dayInWeek.
    d == 7 ifTrue:[
        ^ 1
    ].
    ^ d + 1

    "
     Date today dayOfWeek
     Date today dayInWeek
    "
!

dayOfWeekAbbreviation
    "return the short week-day of the receiver as a string.
     The returned string depends on the language setting.
     Expect things like 'mon', 'tue' ..."

    ^ self abbreviatedDayName

    "
     Date today dayOfWeekAbbreviation
    "
!

dayOfWeekName
    "return the week-day of the receiver as a string.
     The returned string depends on the language setting.
     Expect things like 'monday', 'tuesday' ..."

    ^ self weekday

    "
     Date today dayOfWeekName
     Date today dayOfWeekAbbreviation 
    "
!

dayOfYear
    "return the day-nr within the year of the receiver - 1..365/366"

    ^ self dayInYear

    "
     Date today dayOfYear 
    "
!

monthAbbreviation
    "return the month of the receiver as a string.
     The returned string depends on the language setting.
     Expect things like 'jan', 'feb' ..."

    ^ self abbreviatedMonthName

    "
     Date today monthAbbreviation  
    "
! !

!Date methodsFor:'Compatibility-ST80'!

firstDayInMonth
    "Return the first day in the month of the receiver"

    ^ self subtractDays:(self dayOfMonth - 1)

    "
     Date today               
     Date today firstDayInMonth    
     Date today firstDayInMonth subtractDays:1   
     (Date today subtractDays:30) firstDayInMonth   
     (Date today subtractDays:122) firstDayInMonth   
     (Date today subtractDays:154) firstDayInMonth
    "
!

lastDayInMonth 
    "Return the last day in the month in which the receiver is."

    ^ self addDays:(self daysInMonth - self day).

    "
     Date today       
     Date today lastDayInMonth        
     Date today lastDayInMonth addDays:1  
    "
!

next:dayName 
    "Return the next date whose weekday name is dayName.
     Caveat; dayName is expected to be in the current language"

    |ti ni|

    ti := self weekdayIndex.
    ni := (self class dayOfWeek:dayName).
    ^ self addDays:(ni > ti ifTrue:[ ni-ti ] ifFalse:[ 7+ni-ti ])

    "
     Date today              
     Date today next:#Friday
     Date today next:#Sunday 
     Date today next:#Monday 
     Date today next:#Thursday
     Date today next:#WednesDay
    "
!

nextDayWithIndex:dayIndex 
    "Return the next date whose weekday name is dayName.
     dayIndex is Monday=1, ... , Sunday=7"

    |ti|

    self assert:(dayIndex between:1 and:7).
    ti := self weekdayIndex.
    ^ self addDays:(dayIndex > ti ifTrue:[ dayIndex-ti ] ifFalse:[ 7+dayIndex-ti ])

    "
     Date today              
     Date today nextDayWithIndex:5 - next Friday
     Date today nextDayWithIndex:7  
     Date today nextDayWithIndex:1  
     Date today nextDayWithIndex:4  
     Date today nextDayWithIndex:3  
    "
!

previous:dayName 
    "Return the previous date whose weekday name is dayName.
     Caveat; dayName is expected to be in the current language"

    ^ self previousDayWithIndex:(self class dayOfWeek:dayName).

    "
     Date today                    
     Date today previous:#Montag 
     Date today previous:#Monday 

     Date today previous:#Friday  
     Date today previous:#Sunday  
     Date today previous:#Monday  
     Date today previous:#Thursday  
     Date today previous:#WednesDay 
     Date today previous:#TuesDay  
    "
!

previousDayWithIndex:dayIndex
    "Return the previous date whose weekday name is dayIndex.
     dayIndex is Monday=1, ... , Sunday=7"

    |ti|

    self assert:(dayIndex between:1 and:7).
    ti := self weekdayIndex.
    ^ self subtractDays:(((ti - dayIndex - 1) \\ 7) + 1)

    "
     Date today                    
     Date today previousDayWithIndex:1 
     Date today previousDayWithIndex:5  
     Date today previousDayWithIndex:7  
     Date today previousDayWithIndex:4  
     Date today previousDayWithIndex:3 
     Date today previousDayWithIndex:2  
    "
!

printFormat:aFormatArray
    "Obsolete, backward ST-80 compatible formatted printing - see printStringFormat:
     Return a string containing a printed representation of the receiver.
     The formatArray argument consists of 6 or 7 integers which control
     the resulting string. The entries are:
     1   day position (1, 2 or 3)
     2   month position (1..3)
     3   year position (1..3)
     4   asciiValue of separator character or separator character
         or collection of 2 separator characters
     5   month format (1: numeric; 2: abbreviated name; 3: fullname
         4: abbreviated uppercase 5: full uppercase)
     6   year format (1 include century; 2 exclude century)
     7  (optional) true/false.
         if true, print numbers in 2-digit format
         (i.e. with leading zeros); 
         Taken as false, if ommited

     Day and monthnames are in the currently active language.

     This method supports more options than the ST-80 version; month formats 
     4 and 5, non-numeric separators and the optional 7th parameter are not 
     supported by ST-80. Be aware of this for compatibility reasons.

     Notice that not all formats can be scanned (correctly) by #readFrom:
     This is an ST-80 compatibility method - I would have choosen another
     (less cryptic) formatString ...
    "

    ^ self printFormat:aFormatArray forLanguage:nil

    "
     Date today printFormat:#(1 2 3 '' 1 2)          
     Date today printFormat:#(1 2 3 $- 1 2)          
     Date today printFormat:#(1 2 3 $. 1 2 true)     
     Date today printFormat:#(2 1 3 32 3 1)          
     Date today printFormat:#(2 1 3 #(' ' ', ') 3 1)  
     Date today printFormat:#(1 2 3 $- 2 1)          
     Date today printFormat:#(1 2 3 $- 4 1)          
    "
!

printFormat:aFormatArray forLanguage:languageOrNil
    "Obsolete, backward ST-80 compatible formatted printing - see printStringFormat:
     Return a string containing a printed representation of the receiver.
     The formatArray argument consists of 6 or 7 integers which control
     the resulting string. The entries are:
     1   day position (1, 2 or 3)
     2   month position (1..3)
     3   year position (1..3)
     4   asciiValue of separator character or separator character
         or collection of 2 separator characters
     5   month format (1: numeric; 2: abbreviated name; 3: fullname
         4: abbreviated uppercase 5: full uppercase)
     6   year format (1 include century; 2 exclude century)
     7  (optional) true/false.
         if true, print numbers in 2-digit format
         (i.e. with leading zeros); 
         Taken as false, if ommited

     Day and monthnames are in the currently active language.

     This method supports more options than the ST-80 version; month formats 
     4 and 5, non-numeric separators and the optional 7th parameter are not 
     supported by ST-80. Be aware of this for compatibility reasons.

     Notice that not all formats can be scanned (correctly) by #readFrom:
     This is an ST-80 compatibility method - I would have choosen another
     (less cryptic) formatString ...
    "

    |mf upperCase day month year components sep1 sep2 leadingZeros|

    aFormatArray size > 6 ifTrue:[
        leadingZeros := aFormatArray at:7
    ] ifFalse:[
        leadingZeros := false.
    ].

    components := Array new:3.
    day := self day.
    leadingZeros ifTrue:[
        day := day printStringLeftPaddedTo:2 with:$0 
    ] ifFalse:[
        day := day printString
    ].
    components at:(aFormatArray at:1) put:day.

    upperCase := false.
    mf := aFormatArray at:5.
    (mf between:4 and:5) ifTrue:[mf := mf - 2. upperCase := true].

    mf == 1 ifTrue:[
        month := self month.
        leadingZeros ifTrue:[
            month := month printStringLeftPaddedTo:2 with:$0 
        ] ifFalse:[
            month := month printString
        ]
    ] ifFalse:[
        mf == 2 ifTrue:[
            month := self abbreviatedMonthNameForLanguage:languageOrNil
        ] ifFalse:[
            month := self monthNameForLanguage:languageOrNil
        ]
    ].
    upperCase ifTrue:[month := month asUppercase].
    components at:(aFormatArray at:2) put:month.

    year := self year.
    (aFormatArray at:6) == 2 ifTrue:[
        year := year \\ 100.
        year := year printStringLeftPaddedTo:2 with:$0 
    ].
    year := year printString.
    components at:(aFormatArray at:3) put:year.

    sep1 := sep2 := (aFormatArray at:4).
    sep1 isString ifFalse:[
        sep1 isCollection ifTrue:[
            sep2 := (sep1 at:2).
            sep1 := (sep1 at:1).
        ] ifFalse:[
            sep1 := sep2 := sep1 asCharacter
        ]
    ].

    ^ (components at:1)
      , sep1 asString
      , (components at:2)
      , sep2 asString
      , (components at:3)

    "
     Date today printFormat:#(1 2 3 '' 1 2)         
     Date today printFormat:#(1 2 3 $- 1 2)         
     Date today printFormat:#(1 2 3 $. 1 2 true)     
     Date today printFormat:#(2 1 3 32 3 1)          
     Date today printFormat:#(2 1 3 #(' ' ', ') 3 1)  
     Date today printFormat:#(1 2 3 $- 2 1) forLanguage:#en           
     Date today printFormat:#(1 2 3 $- 4 1) forLanguage:#en          
    "
!

printFormat:aFormatArray forLanguage:languageOrNil on:aStream
    "Obsolete, backward ST-80 compatible formatted printing - see comment
     in printFormat:.
     Append a printed representation of the receiver to aStream.
     The argument, aFormatString controls the format, as described
     in the #printFormat: method.
     Notice that not all formats can be scanned (correctly) by #readFrom:"

    aStream nextPutAll:(self printFormat:aFormatArray forLanguage:languageOrNil)


    "european formats:

     Date today printFormat:#(1 2 3 $- 1 2) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $- 2 2) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $- 2 1) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $- 3 2) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $. 1 2) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $. 1 2 true) on:Transcript. Transcript cr.

     US formats:

     Date today printFormat:#(2 1 3 32 3 1) on:Transcript. Transcript cr.
     Date today printFormat:#(2 1 3 32 2 2) on:Transcript. Transcript cr.
     Date today printFormat:#(2 1 3 $/ 1 2) on:Transcript. Transcript cr.
     Date today printFormat:#(2 1 3 $- 2 1) on:Transcript. Transcript cr.
     Date today printFormat:#(2 1 3 #(' ' ', ') 2 1) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $- 2 1) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $- 4 1) on:Transcript. Transcript cr.
    "
!

printFormat:aFormatArray on:aStream
    "Obsolete, backward ST-80 compatible formatted printing - see comment
     in printFormat:.
     Append a printed representation of the receiver to aStream.
     The argument, aFormatString controls the format, as described
     in the #printFormat: method.
     Notice that not all formats can be scanned (correctly) by #readFrom:"

    aStream nextPutAll:(self printFormat:aFormatArray)


    "european formats:

     Date today printFormat:#(1 2 3 $- 1 2) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $- 2 2) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $- 2 1) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $- 3 2) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $. 1 2) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $. 1 2 true) on:Transcript. Transcript cr.

     US formats:

     Date today printFormat:#(2 1 3 32 3 1) on:Transcript. Transcript cr.
     Date today printFormat:#(2 1 3 32 2 2) on:Transcript. Transcript cr.
     Date today printFormat:#(2 1 3 $/ 1 2) on:Transcript. Transcript cr.
     Date today printFormat:#(2 1 3 $- 2 1) on:Transcript. Transcript cr.
     Date today printFormat:#(2 1 3 #(' ' ', ') 2 1) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $- 2 1) on:Transcript. Transcript cr.
     Date today printFormat:#(1 2 3 $- 4 1) on:Transcript. Transcript cr.
    "
!

shortPrintString
    "dummy - for now"

    ^ self printString

    "Created: 20.6.1997 / 17:16:48 / cg"
!

weekdayIndex
    "Return the day index; Monday=1, ... , Sunday=7"

    ^ (self asDays + 1) \\ 7 + 1  "1 January 1901 was a Tuesday"

    "
     Date today dayName
     Date today weekdayIndex      
    "
! !

!Date methodsFor:'Compatibility-Squeak'!

mmddyyyy
    "return a printed representation of the receiver in the
     form mmddyyyy.
     The receiver can be reconstructed with: 
        Date readMMDDYYYYFrom:aStringOrStream onError:[...]"

    ^ self printStringFormat:'%m%d%y'

"/    ^ (self month printStringLeftPaddedTo:2 with:$0)
"/       , (self day printStringLeftPaddedTo:2 with:$0) 
"/       , (self year printStringLeftPaddedTo:4 with:$0)

    "
     Date today mmddyyyy
    "
! !

!Date methodsFor:'accessing'!

abbreviatedDayName
    "return the short week-day-name of the receiver as a string.
     The returned string depends on the language setting.
     Expect things like 'mon', 'tue' ..."

    ^ self class abbreviatedNameOfDay:(self dayInWeek)

    "
     Date today abbreviatedDayName
     (Date newDay:15 month:4 year:1959) abbreviatedDayName
    "
!

abbreviatedDayNameForLanguage:lang
    "return the short week-day-name of the receiver as a string.
     The returned string depends on the resource translation file to be present for the 
     given language (i.e. libbasic/resources(<lang>.rs).
     If not, the english name is returned.
     Expect things like 'mon', 'tue' ..."

    ^ self class abbreviatedNameOfDay:(self dayInWeek) language:lang

    "
     Date today abbreviatedDayNameForLanguage:#en      
     Date today abbreviatedDayNameForLanguage:#de      
     Date today abbreviatedDayNameForLanguage:#zulu 

     (Date newDay:15 month:4 year:1959) abbreviatedDayName
    "
!

abbreviatedMonthName
    "return the short month name of the receiver as a string.
     The returned string depends on the language setting.
     Expect things like 'jan', 'feb' ..."

    ^ self class abbreviatedNameOfMonth:(self month)

    "
     Date today abbreviatedMonthName
     (Date newDay:15 month:4 year:1959) abbreviatedMonthName
    "
!

abbreviatedMonthNameForLanguage:lang
    "return the short month-name of the receiver as a string in a given language.
     The returned string depends on the resource translation file to be present for the 
     given language (i.e. libbasic/resources(<lang>.rs).
     If not, the english name is returned.
     Expect things like 'jan', 'feb' ..."

    ^ self class abbreviatedNameOfMonth:(self month) language:lang

    "
     Date today abbreviatedMonthNameForLanguage:#en 
     Date today abbreviatedMonthNameForLanguage:#de 
     Date today abbreviatedMonthNameForLanguage:#zulu 
    "
!

asDays
    "return the number of days elapsed since 01-Jan-1901
     and the receiver's day; starts with 0 for 1-1-1901.
     Date>>fromDays: is the reverse operation.
     Notice, that this is not able to represent dates before 1901!!.
     For GNU/ST-80 compatibility."

    |yr|

    yr := self year.
    ^ (self class yearAsDays:yr)
      + (self class daysUntilMonthIndex:self month forYear:yr)
      + self day
      - 1

    "
     (Date newDay: 5 month: 8 year: 1962) asDays  -> should be 22496
     (Date newDay: 1 month: 1 year: 1901) asDays  -> 0
     (Date newDay: 31 month: 12 year: 1900) asDays -> -1
     (Date newDay: 1 month: 1 year: 1800) asDays  -> -36889
     Date today asDays    
     Date fromDays:(Date today asDays + 7) 
    "
!

asDaysFrom0
    "return the number of days elapsed since 01-Jan-0
     and the receiver's day; starts with 0 for 1-1-0.
     Date>>fromDaysFrom0: is the reverse operation.
     Notice, that this is not able to represent dates before 0!!."

    |yr|

    yr := self year.
    ^ (self class yearAsDaysFrom0:yr)
      + (self class daysUntilMonthIndex:self month forYear:yr)
      + self day
      - 1

    "
     (Date newDay: 1 month: 1 year: 0) asDaysFrom0  -> should be 0
     (Date newDay: 1 month: 1 year: 1) asDaysFrom0  -> should be 366
     Date fromDaysFrom0:(Date today asDaysFrom0 + 7) 
    "
!

asSeconds
    "return the seconds between 1.jan.1901 and the same time in the receiver's 
     day. (i.e. midnight to midnight). The returned number may be negative for dates before 1901.
     This does not include any leapSeconds ... strictly speaking, this is incorrect.
     ST-80 compatibility."

    ^ 60*60*24 * self asDays

    "
     (Date newDay: 5 month: 8 year: 1962) asSeconds
     (Date newDay: 1 month: 1 year: 1901) asSeconds
     (Date newDay: 1 month: 1 year: 1700) asSeconds
     (Date today addDays:7) asSeconds - Date today asSeconds
    "

    "Modified: 1.7.1996 / 14:19:17 / cg"
!

day
    "return the day (1..31) of the receiver"

    ^ dateEncoding \\ 100

    "example:
     Date today day
    "
!

dayInWeek
    "return the week-day of the receiver - 1 for monday, 7 for sunday.
     WARNING: different from ANSIs dayOfWeek (which returns 1 for sunday, ... 7 for saturday).  
     WARNING: does not care for pre-gregorian dates 
        (i.e. do not use this for dates before 1583)
    "

    |wday|

    wday := self asDaysFrom0 \\ 7 - 1.
"/    wday := (1 "knowing, that 1st Jan 1901 was a tuesday"
"/            + self asDays) \\ 7 + 1.
    wday < 1 ifTrue:[
        wday := wday + 7
    ].
    ^ wday

    "
     Date today dayInWeek    
     Date tomorrow dayInWeek
     Date yesterday dayInWeek 
     (Date today subtractDays:2) dayInWeek   
     Date today weekday                      
     Date tomorrow weekday                   
     Date yesterday weekday                  
     (Date newDay:15 month:4 year:1959) dayInWeek 
     (Date newDay:1 month:1 year:1901) dayInWeek   
     (Date newDay:31 month:12 year:1900) dayInWeek 
     (Date newDay:31 month:12 year:1899) dayInWeek 
    "

    "Modified: / 1.2.1998 / 14:10:27 / cg"
!

dayInYear
    "return the day-nr within the year of the receiver - 1 .. 365/366"
    
    "
        |daysSoFar|
        daysSoFar := 0.
        #(0 31 28 31 30 31 30 31 31 30 31 30) collect:[:i| daysSoFar := daysSoFar + i]
    "

    |days month|

    month := self month.

    days := #(0 31 59 90 120 151 181 212 243 273 304 334) at:month.
    days := days + self day.
    (month > 2 and:[self class leapYear:self year]) ifTrue:[
        days := days + 1.
    ].

    ^ days

    "
     Date today dayInYear 
     (Date newDay:1 year:1999) dayInYear
     (Date newDay:1 year:2000) dayInYear
     (Date newDay:2 year:2000) dayInYear
     (Date newDay:59 year:2004) dayInYear
     (Date newDay:60 year:2004) dayInYear
     (Date newDay:61 year:2004) dayInYear
     (Date newDay:366 year:2004) dayInYear
     (Date newDay:59 year:2005) dayInYear
     (Date newDay:60 year:2005) dayInYear
     (Date newDay:365 year:2005) dayInYear
    "
!

dayOfMonth
    "Answer the day of the month represented by me.
     Same as day; for ST-80 compatibility."

    ^ self day

    "
     Date today dayOfMonth
    "
!

daysInMonth
    "return the number of days in the month of the receiver"

    ^ self class daysInMonth:(self month) forYear:(self year)

    "
     Date today daysInMonth
    "
!

daysInYear
    "return the number of days in the year of the receiver"

    ^ self class daysInYear:(self year)

    "
     Date today daysInYear
    "
!

daysLeftInMonth
    "return the number of days left in the month of the receiver"

    ^ self daysInMonth - self day

    "
     Date today daysLeftInMonth             
    "
!

daysLeftInYear
    "return the number of days left in the year of the receiver.
     Today is excluded from the count (i.e. in a non-leap-year,
     the first january will return 364)"

    ^ (self class daysInYear:(self year)) - self dayOfYear

    "
     Date today daysLeftInYear             
    "
!

isLeapYear
    "return true, if the receiver's year is a leap year"

    ^ self class leapYear:self year

    "
     Date today isLeapYear
     (Date newDay:1 month:1 year:1992) isLeapYear
    "
!

month
    "return the month (1..12) of the receiver"

    ^ (dateEncoding // 100) \\ 100

    "
     Date today month
    "
!

monthIndex
    "return the index of the month (e.g. Feb.=2).
     Same as month; for ST-80 compatibility."

    ^ self month  
!

monthName
    "return the month of the receiver as a string.
     The returned string depends on the language setting.
     Expect things like 'january', 'february' ..."

    ^ self class nameOfMonth:(self month)

    "
     Date today monthName
     (Date newDay:15 month:4 year:1959) monthName
    "
!

monthNameForLanguage:languageOrNil
    "return the month-name of the receiver as a string in a given language.
     The returned string depends on the resource translation file to be present for the 
     given language (i.e. libbasic/resources(<lang>.rs).
     If not, the english name is returned.
     Expect things like 'january', 'february' ..."

    ^ self class nameOfMonth:(self month) language:languageOrNil

    "
     Date today monthName                 

     Date today monthNameForLanguage:#en  
     Date today monthNameForLanguage:#de  
     Date today monthNameForLanguage:#zulu
    "
!

weekInYear
    "return the week number of the receiver - 1 for Jan, 1st.
     each week is Mon .. Sun (i.e. Sunday belongs to the previous week)"

    ^ self class weekInYearOf:self

    "
     Date today weekInYear    
     (Date newDay:1 year:2000) weekInYear   was a saturday
     (Date newDay:2 year:2000) weekInYear   was a sunday
     (Date newDay:3 year:2000) weekInYear   was a monday
     (Date newDay:4 year:2000) weekInYear   was a tuesday
     (Date newDay:5 year:2000) weekInYear   was a wed
     (Date newDay:6 year:2000) weekInYear   was a thursday
     (Date newDay:7 year:2000) weekInYear   was a fri
     (Date newDay:8 year:2000) weekInYear   was a sat
     (Date newDay:9 year:2000) weekInYear   was a sun
     (Date newDay:10 year:2000) weekInYear  was a monday
     (Date newDay:3 month:1 year:2001) weekInYear 
    "
!

weekday
    "return the week-day of the receiver as a string.
     The returned string depends on the current language setting.
     Expect things like 'monday', 'tuesday' ...
     For ST-80 compatibility"

    ^ self class nameOfDay:(self dayInWeek)

    "
     Date today weekday
     (Date newDay:15 month:4 year:1959) weekday
    "
!

weekdayForLanguage:lang
    "return the week-day-name of the receiver as a string in a given language.
     The returned string depends on the resource translation file to be present for the 
     given language (i.e. libbasic/resources(<lang>.rs).
     If not, the english name is returned.
     Expect things like 'monday', 'tuesday'..."

    ^ self class nameOfDay:(self dayInWeek) language:lang

    "
     Date today weekdayForLanguage:#de      -> Mittwoch
     Date today weekdayForLanguage:#en      -> wednesday
     Date today weekdayForLanguage:#zulu    -> wednesday       

     (Date newDay:15 month:4 year:1959) weekdayForLanguage:#de  
     (Date newDay:15 month:4 year:1959) weekdayForLanguage:#en  
     (Date newDay:15 month:4 year:1959) weekdayForLanguage:#zulu
    "
!

year
    "return the year of the receiver"

    ^ dateEncoding // (100*100)

    "
     Date today year
     Date today subtractDays:(1000 * 365)
     Date today addDays:(1000 * 365)
    "
!

year:year month:month day:day
    dateEncoding := self class encodeYear:year month:month day:day
! !

!Date methodsFor:'arithmetic'!

+ days
    "return a new date representing 'days' after the receiver.
     The argument should be some kind of integer.
     This is the same as #addDays."

    ^ self class fromDaysFrom0:(self asDaysFrom0 + days)

    "
     Date today + 7.

     Date today to:(Date today + 28) by:7 do:[:date|
        Transcript show:date weekday; show:', '; showCr:date
     ].
    "
!

- aDateOrNumberOfDays
    "return the delta in days (anInteger) between 2 dates or 
     subtract a number of days from a date returning a Date"

    aDateOrNumberOfDays class == self class ifTrue:[
        ^ self asDaysFrom0 - aDateOrNumberOfDays asDaysFrom0
    ].

    ^ self class fromDaysFrom0:(self asDaysFrom0 - aDateOrNumberOfDays asInteger)

    "
     Date today - Date yesterday  
     Date today - 3               
     Date today + 3               
    "
!

addDays:days
    "return a new date representing 'days' after the receiver.
     The argument should be some kind of integer.
     For ST-80 compatibility."

    ^ self class fromDaysFrom0:(self asDaysFrom0 + days)

    "
     Date today addDays:7
    "
!

addMonths:numberOfMonths
    "Return a new instance which added numberOfMonths to self months. 
     Keep the day of month if possible.
     If the month of the new instance has fewer days than self dayOfMonth set the day to the last
     day of the new instance's month.
     Does (probably) not work correct for resulting dates before calendar reform."

    |yearToAdd years monthsInYear tempDate newMonth newMonthAsDate|

    yearToAdd := 0.
    years := numberOfMonths // 12.
    monthsInYear := numberOfMonths \\ 12.
    tempDate := self addYears:years.  

    newMonth := tempDate month + monthsInYear.
    (newMonth between:1 and:12) ifFalse:[
        newMonth := newMonth \\ 12.
        yearToAdd := 1.
    ].

    newMonthAsDate := self class 
                        year:(tempDate year + yearToAdd)
                        month:newMonth 
                        day:1.

    ^ self class 
        year:(tempDate year + yearToAdd)
        month:newMonth 
        day:(newMonthAsDate daysInMonth min:tempDate day)

    "Created: / 23-08-2012 / 11:04:17 / sr"
    "Created: / 24-08-2012 / 12:14:52 / anwild"
!

addMonthsUsingEncoding:numberOfMonths
    "Return a new instance which added numberOfMonths to self months. 
     Keep the day of month if possible.
     If the month of the new instance has fewer days than self dayOfMonth,
     set the day to the last day of the new instance's month.                                                           
     Does (probably) not work correct for resulting dates before calendar reform."

    | newEncoding |

    newEncoding := dateEncoding 
                    + ((numberOfMonths + self month) // 12 * 10000)    "the new year"
                    + ((((numberOfMonths \\ 12) + self month) \\ 12) * 100)  "the new month"
                    - (self month * 100) "in the line above the new month is already completely calculated. So subtract the current month"
                    - self day  "in the line below the new day is already completely calculated. So subtract the current day"
                    + (self day min: self daysInMonth). "the new day considering the maximum number of days in the new month."
    ^ self class 
        year: newEncoding // 10000
        month: (newEncoding // 100 \\ 100) 
        day: newEncoding \\ 100. 

    "Created: / 24-08-2012 / 15:18:44 / anwild"
!

addYears:numberOfYears
    "Return a new instance which is the same date, but numberOfYears ahead of self. 
     Cares about leap years.
     I.e. goes from a leap year's 29.feb to a non-leap year's 28.feb."

    |newYear newDay newMonth|

    newYear := self year + numberOfYears.
    newDay := self day.
    newMonth := self month.

    "/ special care for the 29th of February in a leapYear
    (newDay = 29 and:[newMonth == 2]) ifTrue:[
        (self class leapYear:newYear) ifFalse: [
            newDay := 28.
        ].
    ].

    ^ self class 
        year:newYear
        month:newMonth 
        day:newDay 

    "Created: / 23-08-2012 / 11:05:04 / sr"
    "Created: / 24-08-2012 / 12:14:09 / anwild"
!

daysSince:aDate
    "return the number of days between the receiver and the argument,
     aDate, which should be some kind of date"

    ^ self asDaysFrom0 - aDate asDaysFrom0

    "
     Date today daysSince:(Date newDay:1 month:1 year:1901) 
    "
!

daysUntil:aDate
    "return the number of days between the receiver and the argument,
     aDate, which should be some kind of date"

    ^ aDate asDaysFrom0 - self asDaysFrom0

    "
     (Date newDay:24 month:12 year:1994) daysUntil:(Date day:1 month:1 year:1995)
     (Date newDay:1 month:2 year:1992) daysUntil:(Date day:1 month:3 year:1992)
     (Date newDay:1 month:2 year:1994) daysUntil:(Date day:1 month:3 year:1994)
    
     |delta|
     delta := Date today
                daysUntil:(Date newDay:25 month:12 year:Date today year).
     Transcript show:'still ';
                show:delta ;
                showCR:' days till xmas'
    "
!

firstDayInPreviousMonth:nMonths
    "Return the first day of a previous month (0=this month, 1=prev. month, etc.).
     CG: there are two such methods - which one is obsolete?"

    ^ self firstDayOfPreviousMonth:nMonths

    "
     (Date newDay:3 month:6 year:2009) firstDayInMonth     
     (Date newDay:3 month:6 year:2009) firstDayInPreviousMonth:0    
     (Date newDay:3 month:6 year:2009) firstDayInPreviousMonth:5    
     (Date newDay:3 month:6 year:2009) firstDayInPreviousMonth:6    
     (Date newDay:3 month:6 year:2009) firstDayInPreviousMonth:7    
     (Date newDay:3 month:6 year:2009) firstDayInPreviousMonth:17    
     (Date newDay:3 month:6 year:2009) firstDayInPreviousMonth:18    
    "
!

firstDayOfPreviousMonth:nMonths
    "Return the first day of a previous month (0=this month).
     CG: there are two such methods - which one is obsolete? (see firstDayInPreviousMonth:)"

    |month year monthNegated|

    month := self month.
    year := self year.
    month := month - nMonths.
    month < 1 ifTrue:[
        monthNegated := month negated.
        year := year - 1 - (monthNegated // 12).
        month := (12 - (monthNegated \\ 12)).
    ].

    ^ self class year:year month:month day:1.

    "
     (Date newDay:3 month:6 year:2009) firstDayInMonth     
     (Date newDay:3 month:6 year:2009) firstDayOfPreviousMonth:0  
     (Date newDay:3 month:6 year:2009) firstDayOfPreviousMonth:5    
     (Date newDay:3 month:6 year:2009) firstDayOfPreviousMonth:6    
     (Date newDay:3 month:6 year:2009) firstDayOfPreviousMonth:7    
     (Date newDay:3 month:6 year:2009) firstDayOfPreviousMonth:17    
     (Date newDay:3 month:6 year:2009) firstDayOfPreviousMonth:18  
    "
!

subtractDate:aDate
    "return the number of days between the receiver and aDate"

    ^ self asDaysFrom0 - aDate asDaysFrom0

    "
    (Date newDay:1 month:1 year:1995) subtractDate:(Date newDay:24 month:12 year:1994)
    (Date newDay:1 month:3 year:1992) subtractDate:(Date newDay:1 month:2 year:1992)
    (Date newDay:1 month:3 year:1994) subtractDate:(Date newDay:1 month:2 year:1994)
    "
!

subtractDays:days
    "return a new date representing 'days' before the receiver.
     The argument should be some kind of integer.
     For ST-80 compatibility"

    ^ self class fromDaysFrom0:(self asDaysFrom0 - days)

    "
     Date today subtractDays:7
    "
! !

!Date methodsFor:'comparing'!

< aDate
    "return true, if the date represented by the receiver
     is before the argument, aDate"

    "/ quick check, if it is another Date; then we can tune this operation,
    "/ by not having to compute the osTime
    (aDate isMemberOf:Date) ifTrue:[
        ^ dateEncoding < aDate dateEncoding
    ].

    "/ the argument must understand year, month and day to be
    "/ comparable, whatever it is
    ^ dateEncoding < (self class encodeYear:aDate year month:aDate month day:aDate day)

    "
        Date today < (Date day:24 month:12 year:2000)
        Date today < (Date day:24 month:12 year:1900)
        Date today < Timestamp now
        Date today-1 < Timestamp now
    "
!

= aDate
    "return true, if the date represented by the receiver
     is the same as the one represented by argument, aDate"

    "/ must have same class and same osTime
    (aDate isMemberOf:Date) ifFalse:[^ false].
    ^ dateEncoding = aDate dateEncoding

    "the argument must understand year, month and day to be
     comparable, whatever it is"

"
    ^ dateEncoding = (Date encodeYear:aDate year
                                month:aDate month
                                  day:aDate day)
"
    "Date today = ((Date today plusDays:7) minusDays:7)"
!

> aDate
    "return true, if the date represented by the receiver
     is after the argument, aDate"

    "/ quick check, if it is another Date; then we can tune this operation,
    "/ by not having to compute the osTime
    (aDate isMemberOf:Date) ifTrue:[
        ^ dateEncoding > aDate dateEncoding
    ].

    "/ the argument must understand year, month and day,
    "/ to be comparable, whatever it is
    ^ dateEncoding > (self class encodeYear:aDate year month:aDate month day:aDate day)

    "
      Date today > (Date newDay:24 month:12 year:2099)
      Date today > (Date newDay:24 month:12 year:1900)
      Date today > Timestamp now
      Date today+1 > Timestamp now
    "
!

hash
    "return an integer useful for hashing on dates"

    ^ dateEncoding
! !

!Date methodsFor:'converting'!

asDate
    "return the receiver"

    ^ self
!

asLocalTimestamp
    "return an TimeStamp instance, representing midnight of last night"

    ^ Timestamp 
        year:(self year) month:(self month) day:(self day)  
        hour:0 minute:0 second:0 millisecond:0

    "
     Date today asLocalTimestamp
    "
!

asTimestamp
    "return an TimeStamp instance, representing midnight of last night"

    ^ self asLocalTimestamp

    "
     Date today asTimestamp
    "
!

asUtcTimestamp
    "return an UtcTimestamp instance, representing midnight of last night"

    ^ UtcTimestamp 
        year:(self year) month:(self month) day:(self day)  
        hour:0 minute:0 second:0 millisecond:0

    "
     Date today asUtcTimestamp
    "
! !



!Date methodsFor:'obsolete'!

asAbsoluteTime
    "deprecated, use #asTimestamp"
    <resource:#obsolete>

    self obsoleteMethodWarning:'use #asTimestamp'.
    ^ self asTimestamp
!

dayCount
    "return the number of days since 1st. Jan. 1901;
     starting with 0 for this date.
     Date>>fromDays: is the reverse operation.
     Obsolete:
         please use asDays for ST-80 compatibility"
    <resource:#obsolete>

    ^ self asDays.
!

dayName
    "return the week-day of the receiver as a string.
     The returned string depends on the language setting.
     Expect things like 'monday', 'tuesday' ...
     Obsolete:
        use #weekday for ST-80 compatibility"
    <resource:#obsolete>

    ^ self weekday
!

leap
    "return true, if the receiver's year is a leap year"
    <resource: #obsolete>

    ^ self isLeapYear

    "
     Date today leap
     (Date newDay:1 month:1 year:1992) leap
    "
!

minusDays:days
    "return a new date representing 'days' before the receiver.
     The argument should be some kind of integer.
     Obsolete:
         Please don't use this method since it will vanish.
         Use #subtractDays: instead for ST-80 compatibility."

    <resource: #obsolete>

    self obsoleteMethodWarning:'use #substractDays:'.
    ^ self subtractDays:days
!

plusDays:days
    "return a new date representing 'days' after the receiver.
     The argument should be some kind of integer.
     Obsolete:
         Please don't use this method since it will vanish.
         Use #addDays: instead for ST-80 compatibility."

    <resource: #obsolete>

    self obsoleteMethodWarning:'use #addDays:'.
    ^ self addDays:days
! !


!Date methodsFor:'printing & storing'!

addPrintBindingsTo:aDictionary
    "see comment in addPrintBindingsTo:language:"
    
    self addPrintBindingsTo:aDictionary language:nil.
!

addPrintBindingsTo:aDictionary language:languageOrNil
    "private print support: add bindings for printing to aDictionary.
     languageOrNil can only be #en or nil for the current language setting (Smalltalk language).
     
     valid format items are:
        %d              - day, 01..31                    0-padded to length 2
        %m              - month, 01..12                  0-padded to length 2
        %w              - week in year, 00..53           0-padded to length 2
        %y              - year, full                     i.e. 1999, 2004

     special:
        %D              - day - unpadded
        %M              - month - unpadded
        %W              - week in year - unpadded
        %Y              - year, last 2 digits only i.e. 99, 04 (danger: year 2k bug)                     

        %Y1900          - year, last 2 digits of 19YY only i.e. 99, 04 (danger: year 2k bug)
                          raises an error, if the year is not in 1900..1999    
        %Y2000          - year, last 2 digits of 20YY only i.e. 01, 04 or 15
                          raises an error, if the year is not in 2000..2099    
        %Y1950          - year, last 2 digits of 19YY or 20YY only i.e. 01, 04 or 80
                          raises an error, if the year is not in 1950..2049    
        %Y1980          - year, last 2 digits of 19YY or 20YY only i.e. 01, 04 or 80
                          raises an error, if the year is not in 1980..2079    

        %(weekDay)      - day in week (1->monday, 2->tuesday, ... ,7->sunday)
        %(dayOfYear)    - day in year (1..365/366)

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
        %(monthRoman)   - month, in roman letters"                    

    |day ds dsPadded0 dsPaddedB month ms msPadded0 msPaddedB 
     year weekInYear monthName shortMonthName 
     dayInWeek dayOfWeek dayName dayOfYear shortDayName ws wsPadded0|

    day := self day.
    ds := day printString.
    dsPaddedB := day printStringLeftPaddedTo:2.
    dsPadded0 := day printStringLeftPaddedTo:2 with:$0.

    month := self month.
    ms := month printString.
    msPaddedB := month printStringLeftPaddedTo:2.
    msPadded0 := month printStringLeftPaddedTo:2 with:$0.

    year := self year.
    weekInYear := self weekInYear.
    ws := weekInYear printString.
    wsPadded0 := weekInYear printStringLeftPaddedTo:2 with:$0.

    dayInWeek := self dayInWeek.   "/ 1 .. 7
    dayOfWeek := self dayOfWeek.   "/ 0 .. 6
    dayOfYear := self dayOfYear.   "/ 0 .. 6

    monthName := self class nameOfMonth:(self month) language:languageOrNil.
    dayName := self class nameOfDay:dayInWeek language:languageOrNil.

    aDictionary at:#day put:dsPadded0.          "/ 0-padded
    aDictionary at:#daypadded put:dsPaddedB.    "/ Blank-padded
    aDictionary at:#dayPadded put:dsPaddedB.    "/ Blank-padded
    aDictionary at:#Day put:ds.                 "/ unpadded

    aDictionary at:#month put:msPadded0.        "/ 0-padded
    aDictionary at:#monthPadded put:msPaddedB.  "/ Blank-padded
    aDictionary at:#monthpadded put:msPaddedB.  "/ Blank-padded
    aDictionary at:#Month put:ms.               "/ unpadded
    aDictionary at:#mon put:msPadded0.          "/ 0-padded - for backward compatibility only
    aDictionary at:#Mon put:ms.                 "/ unpadded - for backward compatibility only

    aDictionary at:#year put:year.              "/ padded
    aDictionary at:#week put:wsPadded0.
    aDictionary at:#Week put:ws.

    year ~~ self class today year ifTrue:[
        aDictionary at:#yearOrTime put:(' ' , year printString).
    ].

    aDictionary at:$d put:dsPadded0.
    aDictionary at:$D put:ds.
    aDictionary at:$m put:msPadded0.
    aDictionary at:$M put:ms.
    aDictionary at:$y put:year.
    aDictionary at:$Y put:((year \\ 100) printStringLeftPaddedTo:2 with:$0).
    aDictionary at:#Y1950 put:[ 
                                (year between:1950 and:2049) ifFalse:[ 
                                    self error:'year cannot be represented'
                                ].
                                (year between:1950 and:1999) ifTrue:[
                                    (year - 1900) printStringLeftPaddedTo:2 with:$0
                                ] ifFalse:[    
                                    (year - 2000) printStringLeftPaddedTo:2 with:$0
                                ]
                            ].        
    aDictionary at:#Y1980 put:[ 
                                (year between:1980 and:2079) ifFalse:[ 
                                    self error:'year cannot be represented'
                                ].
                                (year between:1980 and:1999) ifTrue:[
                                    (year - 1900) printStringLeftPaddedTo:2 with:$0
                                ] ifFalse:[    
                                    (year - 2000) printStringLeftPaddedTo:2 with:$0
                                ]
                            ].        
    aDictionary at:$w put:wsPadded0.
    aDictionary at:$W put:ws.

    aDictionary at:#monthName put:monthName.
    aDictionary at:#monthname put:monthName asLowercase.
    aDictionary at:#MonthName put:monthName asUppercaseFirst.
    aDictionary at:#MONTHNAME put:monthName asUppercase.

    aDictionary at:#dayName put:dayName.
    aDictionary at:#dayname put:dayName asLowercase.
    aDictionary at:#DayName put:dayName asUppercaseFirst.
    aDictionary at:#DAYNAME put:dayName asUppercase.

    aDictionary at:#weekDay put:dayInWeek.
    aDictionary at:#weekday put:dayInWeek.
    aDictionary at:#weekDayUS put:dayOfWeek.
    aDictionary at:#dayOfYear put:dayOfYear.

    aDictionary at:#shortDayName put:(shortDayName := self class abbreviatedNameOfDay:(self dayInWeek) language:languageOrNil).
    aDictionary at:#shortdayname put:shortDayName asLowercase.
    aDictionary at:#ShortDayName put:shortDayName asUppercaseFirst.
    aDictionary at:#SHORTDAYNAME put:shortDayName asUppercase.

    aDictionary at:#shortMonthName put:(shortMonthName := self class abbreviatedNameOfMonth:(self month) language:languageOrNil).
    aDictionary at:#shortmonthname put:shortMonthName asLowercase.
    aDictionary at:#ShortMonthName put:shortMonthName asUppercaseFirst.
    aDictionary at:#SHORTMONTHNAME put:shortMonthName asUppercase.

    aDictionary at:#nth        put:(#('th' 'st' 'nd' 'rd' 'th' 'th' 'th' 'th' 'th' 'th') at:day \\ 10 + 1).
                                     "/ 0   1    2    3    4    5    6    7    8    9
    aDictionary at:#weekDayNth put:(#('th' 'st' 'nd' 'rd' 'th' 'th' 'th') at:(dayOfWeek-1) \\ 10 + 1). 
                                     "/ 0   1    2    3    4    5    6      
    aDictionary at:#weekDayUSNth put:(#('st' 'nd' 'rd' 'th' 'th' 'th' 'th') at:(dayOfWeek-1) \\ 10 + 1). 
                                     "/ 0   1    2    3    4    5    6      
    aDictionary at:#weekNth    put:(#('th' 'st' 'nd' 'rd' 'th' 'th' 'th' 'th' 'th' 'th') at:weekInYear \\ 10 + 1).
                                     "/ 0   1    2    3    4    5    6    7    8    9     
    aDictionary at:#yearRoman  put:[ year romanPrintString ].
    aDictionary at:#monthRoman  put:[ month romanPrintString ].
!

printOn:aStream
    "append a printed representation of the receiver to aStream"

    self printOn:aStream format:(self class defaultFormatString) language:nil.

    "
     Date today printOn:Transcript. Transcript cr.
    "

    "Modified: 27.8.1995 / 01:01:49 / claus"
!

printOn:aStream format:aFormatStringOrSqueakFormatArray
    "print using a format string;
     see #addPrintBindingsTo: for a list of valid format strings"

    self printOn:aStream format:aFormatStringOrSqueakFormatArray language:nil.

    "
     Date today printOn:Transcript format:'%y%m%d'                                      (iso format)
     Date today printOn:Transcript format:'%y-%m-%d'                                    (iso format)
     Date today printOn:Transcript format:'%y-W%w'                                      (iso format - working week)
     Date today printOn:Transcript format:'%d-%m-%y'                                    (european trivia format)
     Date today printOn:Transcript format:'%m/%d/%y'                                    (us trivia format)
     Date today printOn:Transcript format:'%D-%(monthName)-%y'                          (us trivia format)
     Date today printOn:Transcript format:'%D-%(MonthName)-%y'                          (us trivia format)
     Date today printOn:Transcript format:'%D-%(MONTHNAME)-%y'                          (us trivia format)
     Date today printOn:Transcript format:'%(DayName), %D%(nth) of %(MonthName), %y'   
     Date today printOn:Transcript format:'%(ShortDayName), %D-%(ShortMonthName)-%y'   
     Date today printOn:Transcript format:'%d%m%Y'                                      (millenium bug format - danger)
     Date today printOn:Transcript format:'%d%m%(Y1950)'                                (millenium bug partial workaround format - danger)
     Date today printOn:Transcript format:'%d%m%(Y1980)'                                (millenium bug partial workaround format - danger)
     Date today printOn:Transcript format:'Today is the %(weekDay) day of the week'     
     Date today printOn:Transcript format:'Today is %(year).%(monthRoman).%D'           (hungarian format)
     Date today printOn:Transcript format:'Today is %(D) %(monthRoman) %y'              (poland)
     Date today printOn:Transcript format:'Today is %(D)-%(monthRoman)-%y'              (romania)
     Date today printOn:Transcript format:'Today is %(D)/%(mon)-%Y'                     (sweden)
     Date today printOn:Transcript format:'Anno domini %(yearRoman)'
     Date today printOn:Transcript format:'%y年%(mon)月%d日'                               (select a font, which can display those chars)
     Date today printOn:Transcript format:'%(dayOfYear)'                                      
    "

    "short form (as in blogs like www.stackoverflow, www.superuser etc.)
     Date today printOn:Transcript format:'%(MonthName) %D ''%Y'     
     Timestamp now printOn:Transcript format:'%(MonthName) %D ''%Y at %h:%m'     
    "

    "Squeak format spec:
     String streamContents:[:s |
        Date today printOn:s format:#(1 2 3 $/ 1 2)
     ]    
    "
!

printOn:aStream format:aFormatStringOrSqueakFormatArray language:languageOrNil
    "print using a format string;
     languageOrNil can only be #en or nil for the current language.
     see #addPrintBindingsTo: for a list of valid format strings"

    |dict|

    aFormatStringOrSqueakFormatArray isArray ifTrue:[
        "backward compatibility: a squeak/st80 format array"
        self printFormat:aFormatStringOrSqueakFormatArray on:aStream.
        ^ self.
    ].

    dict := IdentityDictionary new.
    self addPrintBindingsTo:dict language:languageOrNil.

    aFormatStringOrSqueakFormatArray expandPlaceholdersWith:dict on:aStream


    "
     Date today 
        printOn:Transcript 
        format:'%y%m%d'                             
        language:#en                             
    "
!

printOn:aStream language:languageOrNil
    "append a printed representation of the receiver to aStream.
     The argument languageOrNil can only be #en or nil for the current language."

    |format langUsed|

    (DefaultFormats isNil or:[EnvironmentChange]) ifTrue:[
        self class initNames
    ].
    langUsed := languageOrNil notNil ifTrue:[languageOrNil] ifFalse:[Smalltalk language].    
    format := DefaultFormats at:langUsed ifAbsent:[DefaultFormats at:#en].
    self printOn:aStream format:format language:languageOrNil.

    "
     Date today printOn:Transcript language:#en
     Date today printOn:Transcript language:#de
    "

    "Modified: / 27-08-1995 / 01:01:49 / claus"
    "Modified: / 12-03-2004 / 19:23:54 / cg"
!

printStringFormat:aFormatStringOrArray
    "print using a format string;
     see #addPrintBindingsTo: for a list of valid format strings"

    ^ self printStringFormat:aFormatStringOrArray language:nil

    "
     Date today printStringFormat:'%y%m%d'                                      (iso format)
     Date today printStringFormat:'%y-%m-%d'                                    (iso format)
     Date today printStringFormat:'%y-W%w'                                      (iso format - working week)
     Date today printStringFormat:'%d-%m-%y'                                    (european trivia format)
     Date today printStringFormat:'%m/%d/%y'                                    (us trivia format)
     Date today printStringFormat:'%D-%(monthName)-%y'                          (us trivia format)
     Date today printStringFormat:'%D-%(MonthName)-%y'                          (us trivia format)
     Date today printStringFormat:'%D-%(MONTHNAME)-%y'                          (us trivia format)
     Date today printStringFormat:'%(DayName), %D%(nth) of %(MonthName), %y'   
     Date today printStringFormat:'%(ShortDayName), %D-%(ShortMonthName)-%y'   
     Date today printStringFormat:'%d%m%Y'                                      (millenium bug format - danger)
     Date today printStringFormat:'Today is day %(weekDay) of the week'              
     Date today printStringFormat:'Today is the %(weekDay)%(weekDayNth) day of the week'     
     Date today printStringFormat:'Today is the %(Day)%(nth) day of the month'           
    "
!

printStringFormat:aFormatStringOrArray language:languageOrNil
    "print using a format string;
     languageOrNil can only be #en or nil for the current language.
     see #addPrintBindingsTo: for a list of valid format strings"

    |s|

    s := CharacterWriteStream new:20.
    self printOn:s format:aFormatStringOrArray language:languageOrNil.
    ^ s contents.

    "
     Date today printStringFormat:'%y%m%d'                                      (iso format)
     Date today printStringFormat:'%y-%m-%d'                                    (iso format)
     Date today printStringFormat:'%y-W%w'                                      (iso format - working week)
     Date today printStringFormat:'%d-%m-%y'                                    (european trivia format)
     Date today printStringFormat:'%m/%d/%y'                                    (us trivia format)
     Date today printStringFormat:'%D-%(monthName)-%y'                          (us trivia format)
     Date today printStringFormat:'%D-%(MonthName)-%y'                          (us trivia format)
     Date today printStringFormat:'%D-%(MONTHNAME)-%y'                          (us trivia format)
     Date today printStringFormat:'%(DayName), %D%(nth) of %(MonthName), %y'   
     Date today printStringFormat:'%(ShortDayName), %D-%(ShortMonthName)-%y'   
     Date today printStringFormat:'%d%m%Y'                                      (millenium bug format - danger)
     Date today printStringFormat:'Today is day %(weekDay) of the week'              
     Date today printStringFormat:'Today is the %(weekDay)%(weekDayNth) day of the week'     
     Date today printStringFormat:'Today is the %(Day)%(nth) day of the month'           
    "
!

storeOn:aStream
    "append a representation to aStream, from which the receiver
     can be reconstructed"

    aStream nextPutAll:'('; nextPutAll:'Date newDay:'.
    self day printOn:aStream.
    aStream nextPutAll:' month:'.
    self month printOn:aStream.
    aStream nextPutAll:' year:'.
    self year printOn:aStream.
    aStream nextPutAll:')'

    "
     Date today storeOn:Transcript
     Date today storeString
    "
! !

!Date methodsFor:'private-accessing'!

dateEncoding
    "the internal encoding is stricktly private, 
     and should not be used outside."

    ^ dateEncoding
!

dateEncoding:anInteger
    "the internal encoding is stricktly private, 
     and should not be used outside."

    dateEncoding := anInteger
!

fromOSTime:osTime
    "set my dateEncoding as date in the local timezone from an OS time.
     This somewhat clumsy implementation hides the OS's date representation
     (i.e. makes this class independent of what the OS starts its time values with).
     Don't use this method, the osTime representation is totally unportable."

    |v|

    v := OperatingSystem computeTimeAndDateFrom:osTime.
    dateEncoding := self class encodeYear:v year month:v month day:v day

    "Modified: 1.7.1996 / 15:23:12 / cg"
!

fromUtcOSTime:osTime
    "set my dateEncoding as UTC date from an OS time.
     This somewhat clumsy implementation hides the OS's date representation
     (i.e. makes this class independent of what the OS starts its time values with).
     Don't use this method, the osTime representation is totally unportable."

    |v|

    v := OperatingSystem computeUTCTimeAndDateFrom:osTime.
    dateEncoding := self class encodeYear:v year month:v month day:v day

    "Modified: 1.7.1996 / 15:23:12 / cg"
!

getMilliseconds
    "compatibility with Timestamp for comparing"

    "
       ((Timestamp epoch addDays:365) asDate asDays - 365)      -> 25202
    "

    ^ 1000 * 60*60*24 * (self asDays - 25202)

    "
     Date today asTimestamp getMilliseconds
        -
     Date today getMilliseconds
    "
! !

!Date methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitDate:with: to aVisitor"

    ^ aVisitor visitDate:self with:aParameter
! !

!Date class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Date initialize!
