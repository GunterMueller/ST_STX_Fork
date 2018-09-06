"
 COPYRIGHT (c) 1997 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

PluggableAdaptor subclass:#TypeConverter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!TypeConverter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 eXept Software AG
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
    a typeConverter can be used as an editFields model
    (remember, that an editField expects a string in its model),
    to convert the fields string value to some object and vice versa.
    Its main use is when building interfaces with inputFields,
    where the datum to be entered is a non-string and you
    want to have the entered value be converted automatically.
    (and vice versa, to convert the datum to a string).

    No real new functionality is added here - all is inherited
    from PluggableAdapter; however, some specialized instance creation
    methods are added here.

    Notice: 
        this class was implemented using protocol information
        from alpha testers - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Gittinger
"


!

examples 
"
    convert a number to a string:
                                                                        [exBegin]
        |v t i|

        v := 1 asValue.

        t := HorizontalPanelView new.
        t extent:200@50.
        t horizontalLayout:#fitSpace.

        i := EditField in:t.
        i model:(TypeConverter onNumberValue:v).
        t open.

        (Delay forSeconds:3) wait.
        v value:2.
                                                                        [exEnd]
    convert a number to a string with range:
                                                                        [exBegin]
        |v t i|

        v := 1 asValue.

        t := HorizontalPanelView new.
        t extent:200@50.
        t horizontalLayout:#fitSpace.

        i := EditField in:t.
        i model:(TypeConverter onNumberValue:v minValue:0 maxValue:100).
        t open.

        (Delay forSeconds:3) wait.
        v value:2.
                                                                        [exEnd]
    convert a date to a string:
                                                                        [exBegin]
        |d v|

        v := nil asValue.

        d := DialogBox new.
        d addInputFieldOn:(TypeConverter onDateValue:v).
        d addOkButton.
        d open.
        d accepted ifTrue:[
            Transcript showCR:v value
        ]
                                                                        [exEnd]
    convert with thousands:
                                                                        [exBegin]
        |d v|

        v := 1234567 asValue.

        d := DialogBox new.
        d addInputFieldOn:((TypeConverter on:v) integerWithThousandsSeparator:$').
        d addOkButton.
        d open.
        d accepted ifTrue:[
            Transcript showCR:v value
        ]
                                                                        [exEnd]
    convert with scale character:
                                                                        [exBegin]
        |d v|

        v := 1234567 asValue.

        d := DialogBox new.
        d addInputFieldOn:((TypeConverter on:v) numberWithOptionalScale).
        d addOkButton.
        d open.
        d accepted ifTrue:[
            Transcript showCR:v value
        ]
                                                                        [exEnd]
    convert with scale character and thousands separator:
                                                                        [exBegin]
        |d v scaleDict|

        scaleDict := Dictionary new.
        scaleDict at:$t put:1000.
        scaleDict at:$k put:1000.
        scaleDict at:$m put:1000000.

        v := 1234567 asValue.

        d := DialogBox new.
        d addInputFieldOn:((TypeConverter on:v) 
                            numberWithOptionalScales:scaleDict 
                            andThousandsSeparator:$').
        d addOkButton.
        d open.
        d accepted ifTrue:[
            Transcript showCR:v value
        ]
                                                                        [exEnd]
"
! !

!TypeConverter class methodsFor:'instance creation'!

onDateValue:aValueHolder
    "create and return a typeConverter, which retrieves
     a date via #value, and converts
     a date-string to a date via #value:.
     Useful as an editFields model, which operates on some
     date value (or aspectAdaptor, which adapts to a numeric slot)"

    ^ (self on:aValueHolder) dateToText

    "Modified: 21.2.1997 / 18:46:11 / cg"
    "Created: 4.3.1997 / 12:30:49 / cg"
!

onNumberValue:aValueHolder
    "create and return a typeConverter, which retrieves
     a values string representation via #value, and converts
     a number-string to a value via #value:.
     Useful as an editFields model, which operates on some
     numeric value (or aspectAdaptor, which adapts to a numeric slot)"

    ^ (self on:aValueHolder) numberToText

    "Modified: 21.2.1997 / 18:46:11 / cg"
!

onNumberValue:aValueHolder format:formatString
    "create and return a typeConverter, which retrieves
     a values string representation via #value, and converts
     a number-string to a value via #value:.
     Useful as an editFields model, which operates on some
     numeric value (or aspectAdaptor, which adapts to a numeric slot)"

    ^ (self on:aValueHolder) numberToTextFormattedBy:formatString

    "Created: 4.3.1997 / 11:51:25 / cg"
    "Modified: 4.3.1997 / 11:51:41 / cg"
!

onNumberValue:aValueHolder leftPaddedTo:aSize with:aCharacter
    "create and return a typeConverter, which retrieves
     a values string representation via #value, and converts
     a number-string to a value via #value:.
     Useful as an editFields model, which operates on some
     numeric value (or aspectAdaptor, which adapts to a numeric slot)"

    ^ (self on:aValueHolder) numberToTextLeftPaddedTo:aSize with:aCharacter

"
  |m|
  m := 5 asValue.
  ((EditField model:(TypeConverter onNumberValue:m leftPaddedTo:2 with:$-)) width:100) openAt:(200@200).
  m inspect.
"
!

onNumberValue:aValueHolder minValue:min maxValue:max
    "create and return a typeConverter, which retrieves
     a values string representation via #value, and converts
     a number-string to a value via #value:.
     Useful as an editFields model, which operates on some
     numeric value (or aspectAdaptor, which adapts to a numeric slot)"

    ^ (self on:aValueHolder) numberToTextMinValue:min maxValue:max

    "Created: 4.3.1997 / 11:51:25 / cg"
    "Modified: 4.3.1997 / 11:51:41 / cg"
!

onNumberValue:aValueHolder postDecimalDigits:numPostDecimalDigits
    "create and return a typeConverter, which retrieves
     a values string representation via #value, and converts
     a number-string to a value via #value:.
     Useful as an editFields model, which operates on some
     numeric value (or aspectAdaptor, which adapts to a numeric slot)"

    ^ (self on:aValueHolder) numberToText:numPostDecimalDigits

    "Modified: / 21.2.1997 / 18:46:11 / cg"
    "Created: / 5.12.1997 / 02:55:18 / cg"
!

onSymbolValue:aValueHolder
    "create and return a typeConverter, which retrieves
     a symbol-values string representation via #value, and converts
     a string to a symbol via #value:.
     Useful as an editFields model, which operates on some
     numeric value (or aspectAdaptor, which adapts to a numeric slot)"

    ^ (self on:aValueHolder) symbolOrNil

    "Modified: 21.2.1997 / 18:46:11 / cg"
!

onTimeValue:aValueHolder
    "create and return a typeConverter, which retrieves
     a time via #value, and converts
     a time-string to a time via #value:.
     Useful as an editFields model, which operates on some
     date value (or aspectAdaptor, which adapts to a numeric slot)"

    ^ (self on:aValueHolder) timeToText

    "Modified: 21.2.1997 / 18:46:11 / cg"
    "Created: 4.3.1997 / 11:52:10 / cg"
! !

!TypeConverter class methodsFor:'queries'!

possiblePrintConverterTypes
    "presented in the typeConverter UI-builder menu"

    ^ #( 
        #string
        #password
        #number
        #numberInRange
        #numberOrNil
        #numberInRangeOrNil
        #numberOrPointOrNil
        #numberOrStringOrSymbolOrNil
        #numberOrSymbolOrNil
        #numberWithOptionalScale
        #integer
        #integerInRange
        #integerWithThousandsSeparator
        #integerCStyle
        #fileSize
        #frequency
        #hexadecimal
        #hexIntegerInRange
        #symbolOrNil
        #symbolOrBooleanOrNil
        #symbolOrNumberOrNil
        #smalltalkObject
        #smalltalkPoint
        #literal
        #date
        #dateOrNil
        #dateDDMMYYYY
        #dateMMDDYYYY
        #time12H
        #time24H
        #time
        #timeOrNil
        #timestamp
        #timestampOrNil 
        #timeDuration
        #timeDurationOrNil 
    ).

    "Created: / 25-09-2010 / 11:27:58 / cg"
! !

!TypeConverter methodsFor:'accessing'!

subject
    "return the subject to be converted"

    ^ model
!

value:newValue
    "convert and change"

    self setValue:newValue

    "Created: 21.2.1997 / 18:45:39 / cg"
! !

!TypeConverter methodsFor:'input testing'!

setNumberValue: value inModel: model fromInput: string
    "for invalid numbers, the model is set to nil. 
     By this, the dependents are forced to update their contents
     (that is: a bad input string will lead to a cleared input field here)."

    |lastInputChar needChange|

    string notEmpty ifTrue:[
        1 to: string size - 1 do: [:i| (string at: i) isLetter ifTrue: [needChange := true]].
        lastInputChar := string at: string size.
        (lastInputChar isDigit not and: [lastInputChar isPrintable and: [
        (string size > 1               or: [lastInputChar ~~ $-])  and: [
        (string occurrencesOf: $.) > 1 or: [lastInputChar ~~ $.]]]]) ifTrue: [needChange := true].
    ].

    needChange == true ifTrue:[
        value notNil ifTrue:[
            model setValue:nil
        ] ifFalse:[
            model value isNil ifTrue:[
                model changed:#value.
                ^ self
            ]
        ].
    ].
    model value:value
! !

!TypeConverter methodsFor:'standard converters-date & time'!

convertOldVWDateFormatSpecifierToNewSTXFormat:oldFormatSpec
    "private helper to convert an old (VW) format-Array
     of the form:
        'mm/dd/yyyy'      (VW-backward compatibility)
     into:
        '%m %d %y'        (new ST/X format)
    "

    |in out c nDigits|

    oldFormatSpec isArray ifTrue:[^ oldFormatSpec].

    out := '' writeStream.
    in := oldFormatSpec readStream.
    [in atEnd] whileFalse:[
        c := in next.
        nDigits := 1.
        c == $m ifTrue:[
            [in peek == $m] whileTrue:[ nDigits := nDigits + 1. in next ].
            nDigits == 1 ifTrue:[
                out nextPutAll:'%M'.    "/ unpadded
            ] ifFalse:[
                out nextPutAll:'%m'.
            ].
        ] ifFalse:[
            c == $d ifTrue:[
                [in peek == $d] whileTrue:[ nDigits := nDigits + 1. in next ].
                nDigits == 1 ifTrue:[
                    out nextPutAll:'%D'.    "/ unpadded
                ] ifFalse:[
                    out nextPutAll:'%d'.
                ].
            ] ifFalse:[
                c == $y ifTrue:[
                    [in peek == $y] whileTrue:[ nDigits := nDigits + 1. in next ].
                    nDigits == 2 ifTrue:[
                        out nextPutAll:'%Y'.    "/ 2 digits only
                    ] ifFalse:[
                        out nextPutAll:'%y'.
                    ].
                ] ifFalse:[
                    out nextPut:c.
                ].
            ].
        ].
    ].
    ^ out contents.
!

date
    "setup the converter to convert from a string to a date
     and vice versa. Nil is converted to todays date-string,
     likewise, an empty string is converted back to todays date."

    ^ self dateWithFormat:nil orDefault:Date today
!

dateDDMMYYYY
    "setup the converter to convert from a string to a date formatted by printFormat
     DD-MM-YYYY; see also Date>>printFormat:
     This is a backward compatibility method for very old code to print european-style dates.
     Please use dateWithFormat: which is much more flexible."

    self dateToTextFormattedBy: #(1 2 3 $- 1 1 true)

    "
     |vh|

     vh := Date today asValue.
     TypeConverter new
        dateDDMMYYYY
            model:vh;
            value.    
     vh value       
    "
    "
     |vh|

     vh := Date today asValue.
     TypeConverter new
        dateDDMMYYYY
            model:vh;
            value:'12-01-2008'.    
     vh value       
    "
!

dateMMDDYYYY
    "setup the converter to convert from a string to a date formatted by printFormat
     MM/DD/YYYY; see also Date>>printFormat:
     This is a backward compatibility method for very old code to print us-style dates.
     Please use dateWithFormat: which is much more flexible."

    self dateToTextFormattedBy: #(2 1 3 $/ 1 1 true)

    "
     |vh|

     vh := Date today asValue.
     TypeConverter new
        dateMMDDYYYY
            model:vh;
            value.    
     vh value       
    "
    "
     |vh|

     vh := Date today asValue.
     TypeConverter new
        dateMMDDYYYY
            model:vh;
            value:'01/12/2008'.    
     vh value       
    "
!

dateOrNil
    "setup the converter to convert from a string to a date
     and vice versa. Invalid dates are converted to nil; likewise,
     a nil date is converted to an empty string."

    ^ self dateWithFormat:nil orDefault:nil
!

dateOrNilWithFormat:aFormatString
    "setup the converter to convert from a string to a date
     and vice versa. Invalid dates are converted to nil; likewise,
     a nil date is converted to an empty string.
     The format string must have one of the forms:
        'mm/dd/yyyy'      (for VW-backward compatibility)
     or:
        '%m %d %y'
    "

    ^ self dateWithFormat:aFormatString orDefault:nil
!

dateToText
    "setup the converter to convert from a string to a date
     and vice versa. Nil is converted to todays date-string,
     likewise, an empty string is converted back to todays date."

    ^ self dateWithFormat:nil orDefault:Date today
!

dateToTextFormattedBy: printFormat
    "setup the converter to convert from a string to a date formatted by printFormat
     and vice versa. Nil is converted to todays date-string,
     likewise, an empty string is converted back to todays date.
     Uses the old, obsolete ST80 printFormat (see Date printFormat:)"

    ^ self dateWithFormat:printFormat orDefault:Date today
!

dateWithFormat:aFormatString
    "setup the converter to convert from a string to a date
     and vice versa. Invalid dates are converted to nil; likewise,
     a nil date is converted to an empty string.
     The format string must have one of the forms:
        'mm/dd/yyyy'      (for VW-backward compatibility)
     or:
        '%m %d %y'

     see Date addPrintBindingsTo:language: for a format description.
    "

    ^ self dateWithFormat:aFormatString orDefault:Date today language:nil

    "
     |vh|

     vh := Date today asValue.
     (TypeConverter new
        dateWithFormat:'%m%d%y')
            model:vh;
            value.    
     vh value       
    "

    "Modified: / 16-01-2011 / 11:20:20 / cg"
!

dateWithFormat:aFormatString orDefault:defaultValue
    "setup the converter to convert from a string to a date and vice versa. 
     Invalid dates are converted to nil; 
     likewise, a nil date is converted to an empty string.
     The format string must have one of the forms:
        'mm/dd/yyyy'      (for VW-backward compatibility)
     or:
        '%m %d %y'

     see Date addPrintBindingsTo:language: for a format description.
    "

    ^ self dateWithFormat:aFormatString orDefault:defaultValue language:nil

    "Modified: / 16-01-2011 / 11:19:47 / cg"
!

dateWithFormat:aFormatString orDefault:defaultValue language:lang
    "setup the converter to convert from a string to a date and vice versa. 
     Invalid dates are converted to nil; 
     likewise, a nil date is converted to an empty string.
     The format string must have one of the forms:
        'mm/dd/yyyy'      (for VW-backward compatibility)
     or:
        '%m %d %y'

     see Date addPrintBindingsTo:language: for a format description.
    "

    |stxFormat|

    aFormatString notNil ifTrue:[
        (aFormatString includes:$%) ifTrue:[
            "/ a new (ST/X) formatString
            stxFormat := aFormatString
        ] ifFalse:[
            "/ an old (VW) formatString
            stxFormat := self convertOldVWDateFormatSpecifierToNewSTXFormat:aFormatString
        ].
    ].

    self
        getBlock:[:model |
                |date|

                (date := model value) isNil ifTrue:[
                    date := defaultValue
                ].
                date isNil ifTrue:[
                    ''
                ] ifFalse:[
                    date isString ifTrue:[
                        date 
                    ] ifFalse:[
                        stxFormat isNil ifTrue:[
                            date printStringFormat:(date class defaultFormatString) language:lang
                        ] ifFalse:[
                            date printStringFormat:stxFormat language:lang
                        ].
                    ].
                ]]

        putBlock:
                [:model :string |

                |value|

                string isEmptyOrNil ifTrue:[
                    value := defaultValue
                ] ifFalse:[
                    stxFormat isNil ifTrue:[
                        value := Date readFrom:string onError:defaultValue
                    ] ifFalse:[
                        value := Date readFrom:string printFormat:stxFormat onError:defaultValue
                    ]
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Created: / 16-01-2011 / 11:17:46 / cg"
!

monthAndYear
    "setup the converter to convert from a string to a date
     and vice versa. Invalid dates are converted to nil; likewise,
     a nil date is converted to an empty string.
     see Date addPrintBindingsTo:language: for a format description.
    "

    ^ self dateWithFormat:'%y-%m'

    "
     |vh|

     vh := Date today asValue.
     (TypeConverter new monthAndYear)
            model:vh;
            value.    
     vh value       
    "
!

time
     ^ self time24H
!

time12H
    "setup the converter to convert from a string to a time formatted by 12 hours
     and vice versa."

    self timeToTextFormattedBy: #printString12HourFormat


!

time24H
    "setup the converter to convert from a string to a time formatted by 24 hours
     and vice versa."

    self timeToTextFormattedBy: #printString24HourFormat


!

timeDuration
    "setup the converter to convert from a string to a timeduration and vice versa."

    ^ self timeOfClass:TimeDuration withFormat:nil orDefault:(0 seconds) language:nil

    "Created: / 25-09-2010 / 11:24:57 / cg"
    "Modified: / 16-01-2011 / 11:21:54 / cg"
!

timeDurationOrNil
    "setup the converter to convert from a string to a timeDuration and vice versa."

    self objectOrNilOfType:TimeDuration

    "Created: / 25-09-2010 / 11:25:24 / cg"
!

timeOfClass:timeClass withFormat:aFormatString orDefault:defaultValue
    "setup the converter to convert from a string to a time and vice versa. 
     TimeClass is the class that should be used (e.g. Time or Timestamp). 
     Invalid times are converted to defaultValue; likewise,
     a nil time is converted to an empty string."

    ^ self timeOfClass:timeClass withFormat:aFormatString orDefault:defaultValue language:nil

    "Modified: / 16-01-2011 / 11:21:34 / cg"
!

timeOfClass:timeClass withFormat:aFormatString orDefault:defaultValue language:langOrNil
    "setup the converter to convert from a string to a time
     and vice versa. TimeClass is the class that should be used (e.g. Time or Timestamp). 
     Invalid times are converted to defaultValue; likewise,
     a nil time is converted to an empty string."

    self
        getBlock:[:model |
                |time fmt|

                (time := model value) isNil ifTrue:[
                    time := defaultValue
                ].
                time isNil ifTrue:[
                    ''
                ] ifFalse:[
                    time isString ifTrue:[
                        time "/ not strictly ok, bit we don't want to get a DNU...
                    ] ifFalse:[
                        (fmt := aFormatString) isNil ifTrue:[
                            timeClass = TimeDuration ifTrue:[
                                time isInteger ifTrue:[
                                    "backward compatibility - show integer time as seconds"
                                    time := time seconds.
                                ].
                                fmt := time formatForPrinting.
                            ] ifFalse:[
                                fmt := timeClass defaultFormatString
                            ].
                        ].
                        time printStringFormat:fmt language:langOrNil
                    ]
                ]]

        putBlock:
                [:model :string |

                |value|

                string isEmptyOrNil ifTrue:[
                    value := defaultValue
                ] ifFalse:[
"/                    aFormatString isNil ifTrue:[
                        value := timeClass readFrom:string onError:defaultValue
"/                    ] ifFalse:[
"/                        value := timeClass readFrom:string printFormat:aFormatString onError:defaultValue
"/                    ]
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Created: / 16-01-2011 / 11:21:07 / cg"
!

timeOrNil
    "setup the converter to convert from a string to a time and vice versa."

    self objectOrNilOfType:Time

    "Created: / 04-03-1997 / 11:52:47 / cg"
    "Modified: / 12-01-2008 / 19:06:21 / cg"
!

timeStampOrNil
    <resource: #obsolete>
    "setup the converter to convert from a string to a timeStamp and vice versa."

    self timestampOrNil
!

timeToText
    "setup the converter to convert from a string to a time
     and vice versa."

    self timeToTextFormattedBy: #printString
!

timeToTextFormattedBy: format
    "setup the converter to convert from a string to a time formatted by format
     and vice versa."

    self
        getBlock:[:model |
                |time|

                (time := model value) isNil ifTrue:[
                    Time now perform: format
                ] ifFalse:[
                    time perform: format
                ]]

        putBlock:
                [:model :string |

                |value|

                string isEmptyOrNil ifTrue:[
                    value := Time now
                ] ifFalse:[              
                    value := Time readFrom:string onError:[Time now]
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Modified: 21.2.1997 / 18:59:06 / cg"
    "Created: 4.3.1997 / 11:52:47 / cg"
!

timestamp
    "setup the converter to convert from a string to a timestamp and vice versa."

    ^ self timeOfClass:Timestamp withFormat:nil orDefault:Timestamp now
!

timestampOrNil
    "setup the converter to convert from a string to a timestamp and vice versa."

    self objectOrNilOfType:Timestamp

    "Modified: / 12-01-2008 / 19:06:06 / cg"
!

year
    "setup the converter to convert from a string to a date
     and vice versa. Invalid dates are converted to nil; likewise,
     a nil date is converted to an empty string.
     see Date addPrintBindingsTo:language: for a format description.
    "

    ^ self dateWithFormat:'%y'

    "
     |vh|

     vh := Date today asValue.
     (TypeConverter new year)
            model:vh;
            value.    
     vh value       
    "
! !

!TypeConverter methodsFor:'standard converters-misc'!

arrayLiteralOrStringOrSymbolOrNil
    "setup the converter to convert from a string to either a literal
     Array, a String or a symbol and vice versa. 
     Invalid strings (i.e. empty) are converted to nil;
     nil values are converted to an empty string.
     This is a very special converter (for the GUI builder) 
     - probably not belonging to here"

    self
        getBlock:[:model |
                |symbolValue|

                (symbolValue := model value) isNil ifTrue:[
                    ''
                ] ifFalse:[
                    symbolValue storeString
                ]]

        putBlock:
                [:model :string |

                |value s|

                string isEmptyOrNil ifTrue:[
                    value := nil
                ] ifFalse:[
                    s := string withoutSeparators.
                    (s startsWith:'#(') ifTrue:[
                        value := Array readFrom:s onError:nil
                    ] ifFalse:[
                        (s startsWith:'''') ifTrue:[
                            value := String readFrom:s onError:nil
                        ] ifFalse:[
                            (s startsWith:'#') ifTrue:[
                                s := s copyFrom:2
                            ].
                            value := s asSymbol
                        ]
                    ]
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Modified: / 26.10.1997 / 13:50:32 / cg"
    "Created: / 26.10.1997 / 14:01:02 / cg"
!

arrayLiteralOrSymbolOrNil
    "setup the converter to convert from a string to either a literal
     Array or a symbol and vice versa. 
     Invalid strings (i.e. empty) are converted to nil;
     nil values are converted to an empty string.
     This is a very special converter (for the GUI builder) 
     - probably not belonging to here"

    self
        getBlock:[:model |
                |symbolValue|

                (symbolValue := model value) isNil ifTrue:[
                    ''
                ] ifFalse:[
                    symbolValue isArray ifTrue:[
                        symbolValue storeString
                    ] ifFalse:[
                        '#' , symbolValue asString
                    ]
                ]]

        putBlock:
                [:model :string |

                |value s|

                string isEmptyOrNil ifTrue:[
                    value := nil
                ] ifFalse:[
                    s := string withoutSeparators.
                    (s startsWith:'#(') ifTrue:[
                        value := Array readFrom:s onError:nil
                    ] ifFalse:[
                        (s startsWith:'#') ifTrue:[
                            s := s copyFrom:2
                        ].
                        value := s asSymbol
                    ]
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Modified: / 26.10.1997 / 13:50:32 / cg"
    "Created: / 26.10.1997 / 14:01:02 / cg"
!

fileSize
    "setup the converter to convert from a fileSize string to a number
     and vice versa.
     A fileSize can have a scale of 1000 (k or kB), 1024 (ki or kiB),
     1000*1000 (m or mB), 1024*1024 (mi or miB), 1000*1000*1000 (g or gB), 1024*1024*1024 (gi or giB)."

    self
        getBlock:[:model |
                |numericValue|

                (numericValue := model value) isNumber ifFalse:[
                    ''
                ] ifTrue:[  
                    UnitConverter fileSizeStringFor:numericValue
                ]]

        putBlock:
                [:model :string |
                    model value:(UnitConverter fileSizeFromString:string)]

        updateBlock: [:m :a :p | true]
!

frequency
    "setup the converter to convert from a frequency string to a number
     and vice versa.
     A frequency can have a scale of 1000 (k or kHz),
     1000*1000 (m or MHz), 1000*1000*1000 (g or GHz)."

    self
        getBlock:[:model |
                |numericValue|

                (numericValue := model value) isNumber ifFalse:[
                    ''
                ] ifTrue:[  
                    UnitConverter frequencyStringFor:numericValue
                ]]

        putBlock:
                [:model :string |

                model value:(UnitConverter frequencyFromString:string)]

        updateBlock: [:m :a :p | true]
!

literal
    "setup the converter to convert from a string to a literal
     and vice versa. Invalid symbols (i.e. empty) are converted to nil;
     nil values are converted to an empty string.
     true, false, Numbers are parsed"

    self
        getBlock:[:model |
                |val s|

                val := model value.
                (val isLiteral and:[val notNil]) ifTrue:[
                    val isSymbol ifTrue:[
                        "print 'special' symbols as symbols i.e. as #'symbol'"
                        (s := val storeString) second == $' ifTrue:[
                            s
                        ] ifFalse:[
                            val printString
                        ]
                    ] ifFalse:[
                        val storeString
                    ].
                ] ifFalse:[
                    ''.
                ]]

        putBlock:
                [:model :string |

                |value s|

                string size == 0 ifTrue:[
                    value := nil
                ] ifFalse:[
                    s := string withoutSeparators.
                    "be careful, #readFrom:onError: returns nil for an undefined identifier"
                    s = 'true' ifTrue:[
                        value := true.
                    ] ifFalse:[s = 'false' ifTrue:[
                        value := false.
                    ] ifFalse:[s = 'nil' ifTrue:[
                        value := nil.
                    ] ifFalse:[s first isLetter ifTrue:[
                        value := s asSymbol.
                    ] ifFalse:[
                        value := Object readFrom:s onError:[
                            s asSymbol
                        ].
                    ]]]].
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Created: / 21.2.1997 / 18:58:38 / cg"
    "Modified: / 26.5.1998 / 15:06:06 / cg"
!

objectOrNilOfType:timeOrDateClass
    "common code for timeOrNil, dateOrNil and timeStampOrNil"

    self
        getBlock:[:model |
                |timeOrDate|

                (timeOrDate := model value) isNil ifTrue:[
                    ''
                ] ifFalse:[
                    timeOrDate printString
                ]]

        putBlock:
                [:model :string |

                |value|

                string isEmptyOrNil ifTrue:[
                    value := nil
                ] ifFalse:[
                    value := timeOrDateClass readFrom:string onError:nil
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Created: / 12-01-2008 / 19:05:18 / cg"
!

smalltalkObject
    "setup the converter to convert from a string to any smalltalk object
     and vice versa. The string used is the objects storeString.
     Invalid strings (i.e. empty) are converted to nil.
     This is a very special converter (for the GUI builder) 
     - probably not belonging to here"

    ^ self smalltalkObjectWithClass:Object
!

smalltalkObjectOrNil
    "setup the converter to convert from a string to any smalltalk object
     and vice versa. The string used is the objects storeString.
     Invalid strings (i.e. empty) are converted to nil.
     This is a very special converter (for the GUI builder) 
     - probably not belonging to here"

    ^ self smalltalkObjectOrNilWithClass:Object
!

smalltalkObjectOrNilWithClass:classOfObject
    "setup the converter to convert from a string to a smalltalk object
     and vice versa. The string used is the objects storeString.
     Invalid strings (i.e. empty) are converted to nil.
     This is a very special converter (for the GUI builder) 
     - probably not belonging to here"

    self
        getBlock:[:model | |v s|
                    v := model value.
                    v isNil ifTrue:[
                        s := 'nil'
                    ] ifFalse:[
                        s := v storeString.
                        (v isString or:[v isNumber]) ifFalse:[
                            s := s , ' "' , v class name , '" '
                        ]
                    ].
                    s
                ]
                
        putBlock:
                [:model :string |

                   |value|

                    string size > 0 ifTrue:[
                        value := classOfObject readFrom:string onError:nil.
                        value := value ? string.
                    ].
                    model value:value
                ]

        updateBlock: [:m :a :p | true]

    "Created: / 29-10-1997 / 15:50:16 / cg"
    "Modified: / 05-09-2006 / 17:57:53 / cg"
!

smalltalkObjectWithClass:classOfObject
    "setup the converter to convert from a string to a smalltalk object
     and vice versa. The string used is the objects storeString.
     Invalid strings (i.e. empty) are converted to nil.
     This is a very special converter (for the GUI builder) 
     - probably not belonging to here"

    self
        getBlock:[:model | |v s|
                    v := model value.
                    v isNil ifTrue:[
                        s := ''
                    ] ifFalse:[
                        s := v storeString.
                        (v isString or:[v isNumber]) ifFalse:[
                            s := s , ' "' , v class name , '" '
                        ]
                    ].
                    s
                 ]

        putBlock:
                [:model :string |

                    |value|

                    string size > 0 ifTrue:[
                        value := classOfObject readFrom:string onError:nil.
                        model value:value ? string
                    ] ifFalse:[
                         model value:value
                    ]
                ]

        updateBlock: [:m :a :p | true]

    "Created: / 29-10-1997 / 15:50:16 / cg"
    "Modified: / 05-09-2006 / 17:57:37 / cg"
!

smalltalkPoint
    "setup the converter to convert from a string to a point object
     and vice versa. The string used is the points storeString.
     Invalid strings (i.e. empty) are converted to nil.
     This is a very special converter (for the GUI builder) 
     - probably not belonging to here"

    ^ self smalltalkObjectWithClass:Point
!

symbolOrBooleanOrNil
    "setup the converter to convert from a string to a symbol or boolean
     and vice versa. Invalid symbols (i.e. empty) are converted to nil;
     nil values are converted to an empty string.
     In addition, the strings true/false convert to/from booleans."

    self
        getBlock:[:model |
                |symbolValue|

                ((symbolValue := model value) isSymbol 
                or:[symbolValue isBoolean]) 
                ifFalse:[
                    ''
                ] ifTrue:[
                    (symbolValue == #true or:[symbolValue == #false]) ifTrue:[
                        symbolValue storeString  "/ to show the symbolness
                    ] ifFalse:[
                        symbolValue printString. "/ storeString
                    ]
                ]]

        putBlock:
                [:model :string |

                |value s|

                string size == 0 ifTrue:[
                    value := nil
                ] ifFalse:[
                    s := string withoutSeparators.
                    (s startsWith:'#') ifTrue:[
                        s := s copyFrom:2.
                        (s startsWith:$') ifTrue:[
                            s := s copyFrom:2 to:(s size - 1)
                        ].
                        value := s asSymbol
                    ] ifFalse:[
                        (#('true' 'false') includes:s) ifTrue:[
                            value := Object readFromString:s.
                        ] ifFalse:[
                            value := s asSymbol
                        ]
                    ].
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Created: / 21-02-1997 / 18:58:38 / cg"
    "Modified (comment): / 20-03-2012 / 21:25:48 / cg"
!

symbolOrNil
    "setup the converter to convert from a string to a symbol
     and vice versa. Invalid symbols (i.e. empty) are converted to nil;
     nil values are converted to an empty string."

    self
        getBlock:[:model |
                |symbolValue|

                (symbolValue := model value) isSymbol ifFalse:[
                    ''
                ] ifTrue:[
                    symbolValue printString. "/ storeString
                ]]

        putBlock:
                [:model :string |

                |value s|

                string size == 0 ifTrue:[
                    value := nil
                ] ifFalse:[
                    s := string withoutSeparators.
                    (s startsWith:'#') ifTrue:[
                        s := s copyFrom:2.
                        (s startsWith:$') ifTrue:[
                            s := s copyFrom:2 to:(s size - 1)
                        ]
                    ].
                    value := s asSymbol
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Created: / 21.2.1997 / 18:58:38 / cg"
    "Modified: / 26.5.1998 / 15:06:06 / cg"
!

symbolOrNumberOrNil
    "setup the converter to convert from a string to a symbol or number
     and vice versa. Invalid symbols (i.e. empty) are converted to nil;
     nil values are converted to an empty string."

    self
        getBlock:[:model |
                |symbolValue|

                ((symbolValue := model value) isSymbol 
                or:[symbolValue isNumber]) 
                ifFalse:[
                    ''
                ] ifTrue:[
                    symbolValue storeString.
                ]]

        putBlock:
                [:model :string |

                |value s|

                string size == 0 ifTrue:[
                    value := nil
                ] ifFalse:[
                    s := string withoutSeparators.
                    (s startsWith:'#') ifTrue:[
                        s := s copyFrom:2.
                        (s startsWith:$') ifTrue:[
                            s := s copyFrom:2 to:(s size - 1)
                        ].
                        value := s asSymbol
                    ] ifFalse:[
                        value := Number readFromString:s onError:[s asSymbol].
                    ].
                ].
                model value:value]

        updateBlock: [:m :a :p | true]
! !

!TypeConverter methodsFor:'standard converters-numbers'!

hexadecimal
    "setup the converter to convert from a hexadecimal string to a number
     and vice versa."

    self
        getBlock:[:model |
                |hexValue|

                (hexValue := model value) isNumber ifFalse:[
                    ''
                ] ifTrue:[  
                    hexValue hexPrintString
                ]]

        putBlock:
                [:model :string |

                |value|

                string isEmptyOrNil ifTrue:[
                    value := 0
                ] ifFalse:[     
                    value := Integer readFrom: string radix:16 onError:[0]
                ].
                model value:value]

        updateBlock: [:m :a :p | true]
!

integer
    "setup the converter to convert from a string to an integer
     and vice versa. Invalid integers are converted to nil."

    self integerToText
!

integerCStyle
    "setup the converter to convert from a string to an integer
     and vice versa. Supports CStyle 0x/0b and 0 prefixes
     Invalid integers are converted to nil."

    self integerToTextCStyle 
!

integerOrNil
    "setup the converter to convert from a string to an integer
     and vice versa. Invalid numbers are converted to nil."

    self objectOrNilOfType:Integer

    "Modified: / 12-01-2008 / 19:08:42 / cg"
    "Created: / 22-01-2012 / 11:28:24 / cg"
!

integerToHexTextMinValue:minVal maxValue:maxVal format:formatStringOrNil
    "setup the converter to convert from a string to a number
     and vice versa, but clamping the number into the range."

    ^ self integerToTextMinValue:minVal maxValue:maxVal radix:16 format:formatStringOrNil
!

integerToText
    "setup the converter to convert from a string to a integer
     and vice versa."

    self
        getBlock:[:model |
                |numericValue|

                (numericValue := model value) isInteger ifFalse:[
                    ''
                ] ifTrue:[
                    numericValue printString
                ]]

        putBlock:
                [:model :string |

                |value|

                string isEmptyOrNil ifTrue:[
                    value := 0
                ] ifFalse:[
                    value := Integer readFromString: string onError:[0]
                ].
                model value:value]

        updateBlock: [:m :a :p | true]
!

integerToTextCStyle
    "setup the converter to convert from a string to a integer
     and vice versa. SUpports C-style integers in the form 0x, 0b 0
     and also Smalltalk radix integers"

    self
        getBlock:[:model |
                |numericValue|

                (numericValue := model value) isInteger ifFalse:[
                    ''
                ] ifTrue:[
                    numericValue printString
                ]]

        putBlock:
                [:model :string |

                |value|

                string isEmptyOrNil ifTrue:[
                    value := 0
                ] ifFalse:[
                    (string startsWith:'0x') ifTrue:[
                            value := Integer readFromString: (string copyFrom:3) radix:16 onError:[0]
                    ] ifFalse:[    
                        (string startsWith:'0b') ifTrue:[
                            value := Integer readFromString: (string copyFrom:3) radix:2 onError:[0]
                        ] ifFalse:[    
                            (string startsWith:'0') ifTrue:[
                                value := Integer readFromString: string radix:8 onError:[0]
                            ] ifFalse:[
                                value := Integer readFromString: string onError:[0]
                            ]
                        ]
                    ]    
                ].
                model value:value]

        updateBlock: [:m :a :p | true]
!

integerToTextMinValue:minVal maxValue:maxVal format:formatStringOrNil
    "setup the converter to convert from a string to a number
     and vice versa, but clamping the number into the range."

    ^ self integerToTextMinValue:minVal maxValue:maxVal radix:10 format:formatStringOrNil
!

integerToTextMinValue:minVal maxValue:maxVal radix:radix format:formatStringOrNil
    "setup the converter to convert from a string to a number
     and vice versa, but clamping the number into the range."

    self
        getBlock:[:model |
                |numericValue|

                (numericValue := model value) isNil ifTrue:[
                    ''
                ] ifFalse:[
                    numericValue isString ifTrue:[
                        numericValue    
                    ] ifFalse:[
                        formatStringOrNil isNil ifTrue:[    
                            radix = 10 ifTrue:[
                                numericValue printString
                            ] ifFalse:[
                                numericValue printStringRadix:radix
                            ]
                        ] ifFalse:[
                            numericValue printfPrintString:formatStringOrNil
                        ]
                    ]
                ]]

        putBlock:
                [:model :string |

                |value c|

                string isEmptyOrNil ifTrue:[
                    value := 0
                ] ifFalse:[
                    value := Integer readFromString:string radix:radix onError:[0]. 
                ].               
                minVal notNil ifTrue:[
                    (value < minVal and: [string notEmpty]) ifTrue: [model setValue:nil].
                    value := value max:minVal.
                ].
                maxVal notNil ifTrue:[
                    (value > maxVal and: [string notEmpty]) ifTrue: [model setValue:nil].
                    value := value min:maxVal.
                ].
                self setNumberValue: value inModel: model fromInput: string.
                ]

        updateBlock: [:m :a :p | true]

    "Modified: 21.2.1997 / 18:59:44 / cg"
!

integerWithThousandsSeparator    
    ^ self numberWithThousandsSeparator
!

integerWithThousandsSeparator:sep
    "setup the converter to convert from a string to a number with thousands separator
     and vice versa."

    ^ self numberWithThousandsSeparator:sep
!

number
    "setup the converter to convert from a string to a number
     and vice versa. Invalid numbers are converted to nil."

    self numberToText

    "Created: 4.4.1997 / 12:46:14 / cg"
!

numberOrNil
    "setup the converter to convert from a string to a number
     and vice versa. Invalid numbers are converted to nil."

    self objectOrNilOfType:Number

    "Modified: / 12-01-2008 / 19:08:42 / cg"
!

numberOrNilToTextMinValue:minVal maxValue:maxVal
    "setup the converter to convert from a string to a number or nil
     and vice versa, but clamping the number into the range."

    self numberOrNilToTextMinValue:minVal maxValue:maxVal format:nil
!

numberOrNilToTextMinValue:minVal maxValue:maxVal format:formatStringOrNil
    "setup the converter to convert from a string to a number or nil
     and vice versa, but clamping the number into the range."

    self
        getBlock:[:model |
                |numericValue|

                (numericValue := model value) isNil ifTrue:[
                    ''
                ] ifFalse:[
                    formatStringOrNil isNil ifTrue:[    
                        numericValue printString
                    ] ifFalse:[
                        numericValue printfPrintString:formatStringOrNil
                    ]
                ]]

        putBlock:
                [:model :string |

                |value c|

                (string isEmptyOrNil or:[string isBlank]) ifTrue:[
                    value := nil
                ] ifFalse:[
                    value := Number readFromString:string onError:[nil]. 
                    value isNil ifTrue:[
                        
                    ] ifFalse:[
                        minVal notNil ifTrue:[
                            (value < minVal and: [string notEmpty]) ifTrue: [model setValue:nil].
                            value := value max:minVal.
                        ].
                        maxVal notNil ifTrue:[
                            (value > maxVal and: [string notEmpty]) ifTrue: [model setValue:nil].
                            value := value min:maxVal.
                        ].
                    ].
                ].
                self setNumberValue: value inModel: model fromInput: string.
                ]

        updateBlock: [:m :a :p | true]

    "Modified: 21.2.1997 / 18:59:44 / cg"
!

numberOrPointOrNil
    "setup the converter to convert from a string to a number or point
     and vice versa. Invalid numbers/points are converted to nil."

    self
        getBlock:[:model |
                |value|

                (value := model value) isNil ifTrue:[
                    ''
                ] ifFalse:[
                    value printString
                ]]

        putBlock:
                [:model :string |

                |value|

                string size > 0 ifTrue:[
                    value := Point readFrom:string onError:[
                        Number readFrom:string onError:nil
                    ]
                ]. 
                model value:value]

        updateBlock: [:m :a :p | true]

    "Created: / 5.2.2000 / 01:26:48 / cg"
!

numberOrStringOrSymbolOrNil
    "setup the converter to convert from a string to either a numeric literal
     or a symbol and vice versa. 
     Invalid strings (i.e. empty) are converted to nil;
     nil values are converted to an empty string.
     This is a very special converter (for the GUI builder) 
     - probably not belonging to here"

    self
        getBlock:[:model |
                |litValue|

                (litValue := model value) isNil ifTrue:[
                    ''
                ] ifFalse:[
                    litValue storeString
                ]]

        putBlock:
                [:model :string |

                |value s|

                string isEmptyOrNil ifTrue:[
                    value := nil
                ] ifFalse:[
                    value := Number readFrom:string onError:nil.
                    value isNil ifTrue:[
                        s := string withoutSeparators.
                        (s startsWith:'''') ifTrue:[
                            value := String readFrom:s readStream onError:nil
                        ] ifFalse:[
                            (s startsWith:'#') ifTrue:[
                                s := s copyFrom:2.
                                (s startsWith:$') ifTrue:[
                                    s := s copyFrom:2 to:(s size - 1)
                                ].
                            ].
                            value := s asSymbol
                        ]
                    ]
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Modified: / 26.10.1997 / 13:50:32 / cg"
    "Created: / 29.10.1997 / 15:49:26 / cg"
!

numberOrSymbolOrNil
    "setup the converter to convert from a string to either a numeric literal
     or a symbol and vice versa. 
     Invalid strings (i.e. empty) are converted to nil;
     nil values are converted to an empty string.
     This is a very special converter (for the GUI builder) 
     - probably not belonging to here"

    self
        getBlock:[:model |
                |litValue|

                (litValue := model value) isNil ifTrue:[
                    ''
                ] ifFalse:[
                    litValue storeString
                ]]

        putBlock:
                [:model :string |

                |value s|

                string isEmptyOrNil ifTrue:[
                    value := nil
                ] ifFalse:[
                    value := Number readFrom:string onError:nil.
                    value isNil ifTrue:[
                        s := string withoutSeparators.
                        (s startsWith:'#') ifTrue:[
                            s := s copyFrom:2.
                            (s startsWith:$') ifTrue:[
                                s := s copyFrom:2 to:(s size - 1)
                            ].
                        ].
                        value := s asSymbol
                    ]
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Modified: / 26.10.1997 / 13:50:32 / cg"
    "Created: / 29.10.1997 / 15:49:26 / cg"
!

numberToText
    "setup the converter to convert from a string to a number
     and vice versa."

    self
        getBlock:[:model |
                |numericValue|

                (numericValue := model value) isNumber ifFalse:[
                    ''
                ] ifTrue:[
                    numericValue printString
                ]]

        putBlock:
                [:model :string |

                |value|

                string isEmptyOrNil ifTrue:[
                    value := 0
                ] ifFalse:[
                    value := Number readFromString: string onError:[0]
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Created: / 21.2.1997 / 18:57:05 / cg"
    "Modified: / 29.10.1997 / 15:49:21 / cg"
!

numberToText:numberOfPostDecimals
    "setup the converter to convert from a string to a number
     and vice versa."

    self
        getBlock:[:model |
                |numericValue|

                (numericValue := model value) isNumber ifFalse:[
                    ''
                ] ifTrue:[
                    (numericValue asFixedPoint:numberOfPostDecimals) printString
                ]]

        putBlock:
                [:model :string |

                |value|

                string isEmptyOrNil ifTrue:[
                    value := 0
                ] ifFalse:[     
                    value := Number readFromString:string onError:[0]
                ].
                self setNumberValue: value inModel: model fromInput: string.
                ]

        updateBlock: [:m :a :p | true]

    "Created: / 5.12.1997 / 02:54:13 / cg"
    "Modified: / 5.12.1997 / 18:21:04 / cg"
!

numberToTextFormattedBy:formatString
    "setup the converter to convert from a string to a number
     and vice versa, using formatString.
     The formatString is currently ignored when numbers are converted
     from a string."

    self
        getBlock:[:model |
                |numericValue|

                (numericValue := model value) isNil ifTrue:[
                    ''
                ] ifFalse:[
                    PrintConverter print:numericValue formattedBy:formatString
                ]]

        putBlock:
                [:model :string |

                |value|

                string isEmptyOrNil ifTrue:[
                    value := 0
                ] ifFalse:[          
                    value := Number readFromString: string onError:[0]. "asNumberFromFormatString:formatString"
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Modified: 21.2.1997 / 18:59:44 / cg"
!

numberToTextLeftPaddedTo:aSize with:aCharacter
    "setup the converter to convert from a string to a number
     and vice versa, using formatString.
     The formatString is currently ignored when numbers are converted
     from a string."

    self
        getBlock:[:model |
                |numericValue|

                (numericValue := model value) isNil ifTrue:[
                    ''
                ] ifFalse:[
                    numericValue printStringLeftPaddedTo:aSize with:aCharacter
                ]]

        putBlock:
                [:model :string |

                |value|

                string isEmptyOrNil ifTrue:[
                    value := 0
                ] ifFalse:[          
                    value := Number readFromString: string onError:[0]. "asNumberFromFormatString:formatString"
                ].
                model value:value]

        updateBlock: [:m :a :p | true]

    "Modified: 21.2.1997 / 18:59:44 / cg"
!

numberToTextMinValue:minVal maxValue:maxVal
    "setup the converter to convert from a string to a number
     and vice versa, but clamping the number into the range."

    self numberToTextMinValue:minVal maxValue:maxVal format:nil
!

numberToTextMinValue:minVal maxValue:maxVal format:formatStringOrNil
    "setup the converter to convert from a string to a number
     and vice versa, but clamping the number into the range."

    self
        getBlock:[:model |
                |numericValue|

                (numericValue := model value) isNil ifTrue:[
                    ''
                ] ifFalse:[
                    formatStringOrNil isNil ifTrue:[    
                        numericValue printString
                    ] ifFalse:[
                        numericValue printfPrintString:formatStringOrNil
                    ]
                ]]

        putBlock:
                [:model :string |

                |value c|

                string isEmptyOrNil ifTrue:[
                    value := 0
                ] ifFalse:[
                    value := Number readFromString: string onError:[0]. 
                ].               
                minVal notNil ifTrue:[
                    (value < minVal and: [string notEmpty]) ifTrue: [model setValue:nil].
                    value := value max:minVal.
                ].
                maxVal notNil ifTrue:[
                    (value > maxVal and: [string notEmpty]) ifTrue: [model setValue:nil].
                    value := value min:maxVal.
                ].
                self setNumberValue: value inModel: model fromInput: string.
                ]

        updateBlock: [:m :a :p | true]

    "Modified: 21.2.1997 / 18:59:44 / cg"
!

numberWithOptionalScale
    "setup the converter to convert from a string to a number
     and vice versa. Invalid numbers are converted to nil.
     The number may be followed by one of m (for million) or
     k (for thousand). E.g.: '1m2k55' "

    |scaleDict|

    scaleDict := Dictionary withKeysAndValues:#(
            $g 1000000000
            $m 1000000
            $k    1000
            $t    1000
        ).
    self numberWithOptionalScales:scaleDict
!

numberWithOptionalScales:scaleDict
    "setup the converter to convert from a string to a number or nil
     and vice versa; allow for scale characters (such as k for thousand).

     E.g. '1m2k55' "

    self
        getBlock:[:model |
                    |numericValue|

                    numericValue := model value.
                    numericValue isEmptyOrNil ifTrue:[
                        ''
                    ] ifFalse:[
                        numericValue printString
                    ]
                ]

        putBlock:
                [:model :string |

                    |value c stream scaleChar scale partValue|

                    (string isEmptyOrNil or:[string isBlank]) ifTrue:[
                        value := nil
                    ] ifFalse:[
                        value := 0.
                        stream := string readStream.
                        [
                            partValue := Number readFrom:stream onError:[nil]. 
                            partValue notNil ifTrue:[
                                stream skipSeparators.
                                scaleChar := stream nextOrNil.
                                scale := scaleDict at:scaleChar ifAbsent:1.
                                value := value + (partValue * scale).
                            ].
                        ] doWhile:[partValue notNil].
                    ].
                    self setNumberValue: value inModel: model fromInput: string.
                ]

        updateBlock: [:m :a :p | true]
!

numberWithOptionalScales:scaleDict andThousandsSeparator:sep
    "setup the converter to convert from a string to a number with thousands separator
     and vice versa. Allow for scale characters (such as k for thousand) "

    self
        getBlock:[:model |
                    |numericValue|

                    (numericValue := model value) isNumber ifFalse:[
                        ''
                    ] ifTrue:[
                        String streamContents:[:s | numericValue printOn:s thousandsSeparator:sep].
                    ]
                ]

        putBlock:
                [:model :string |

                    |value c stream scaleChar scale s2|

                    string isEmptyOrNil ifTrue:[
                        value := 0
                    ] ifFalse:[
                        s2 := string reject:[:ch | ch = sep].    
                        stream := s2 readStream.
                        value := Number readFrom:stream onError:[nil]. 
                        value notNil ifTrue:[
                            stream skipSeparators.
                            scaleChar := stream peek.
                            scale := scaleDict at:scaleChar ifAbsent:1.
                            value := value * scale.
                        ].
                    ].
                    "/ model value:value
                    self setNumberValue: value inModel: model fromInput: string.
                ]

        updateBlock: [:m :a :p | true]
!

numberWithThousandsSeparator    
    "/ ^ self numberWithThousandsSeparator:$'
    ^ self numberWithThousandsSeparator:(UserPreferences current thousandsSeparatorCharacter)
!

numberWithThousandsSeparator:sep
    "setup the converter to convert from a string to a number with thousands separator
     and vice versa."

    self
        getBlock:[:model |
                |numericValue|

                (numericValue := model value) isNumber ifFalse:[
                    ''
                ] ifTrue:[
                    String streamContents:[:s | numericValue printOn:s thousandsSeparator:sep].
                ]]

        putBlock:
                [:model :string |

                |value s2|

                string isEmptyOrNil ifTrue:[
                    value := 0
                ] ifFalse:[
                    s2 := string reject:[:ch | ch = sep].    
                    value := Number readFromString:s2 onError:[0]
                ].
                model value:value]

        updateBlock: [:m :a :p | true]
! !

!TypeConverter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

