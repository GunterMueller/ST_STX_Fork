"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

Object subclass:#PrintConverter
	instanceVariableNames:'valueToStringBlock stringToValueBlock type'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support'
!

!PrintConverter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    printConverters can be used with labels and editFields to convert 
    an object to/from some printed representation.
    
    Conversion is done via two blocks, which can be set at instance
    creation time - either as custom blocks or as one of the
    standard conversions. 

    There are a number of standard setups for common conversions; 
    if none of them fits your needs, 
    create a custom converter by defining its two conversion blocks.

    Notice: this class was implemented using protocol information
    from alpha testers - it may not be complete or compatible to
    the corresponding ST-80 class. If you encounter any incompatibilities,
    please forward a note to the ST/X team.

    [author:]
        Claus Gittinger
"
!

examples 
"
  stupid examples:
    convert date <-> string:
                                                                        [exBegin]
      |conv|

      conv := (PrintConverter new)
                  toPrint:[:date | date printString]
                  toRead:[:string | Date readFromString:string].
      (conv printStringFor:(Date today)) inspect.
      (conv readValueFrom:(Date today printString)) inspect
                                                                        [exEnd]


    convert number <-> string:
                                                                        [exBegin]
      |conv|

      conv := (PrintConverter new) initForNumber.
      (conv printStringFor:12345) inspect.
      (conv readValueFrom:'12345') inspect
                                                                        [exEnd]


    convert boolean <-> string:
                                                                        [exBegin]
      |conv|

      conv := (PrintConverter new) initForYesNo.
      (conv printStringFor:true).  
      (conv printStringFor:false).    
      (conv readValueFrom:'yes').  
      (conv readValueFrom:'no').  
      'if language is #de:'.
      (conv readValueFrom:'ja').    
      (conv readValueFrom:'nein')  
                                                                        [exEnd]

  concrete examples: 
    convert in an inputField:
                                                                        [exBegin]
      |dialog field|

      dialog := Dialog new.
      dialog addTextLabel:'a number (and only numbers):'.
      dialog addVerticalSpace.
      field := dialog addInputFieldOn:(0 asValue).
      field converter:(PrintConverter new initForNumber).
      field immediateAccept:true.
      dialog addOkButton.
      dialog open.
      dialog accepted ifTrue:[
          Transcript showCR:field editValue
      ]
                                                                        [exEnd]

    convert a models value for a label:
                                                                        [exBegin]
      |top v1 v2 l1 l2|

      v1 := 0 asValue.
      v2 := Date today asValue.

      top := StandardSystemView new.
      top extent:200@200.

      l1 := Label origin:0.0@0.0 corner:1.0@0.5 in:top.
      l1 converter:(PrintConverter new initForInteger).
      l1 model:v1; labelMessage:#value; aspect:#value.
      l1 level:-1; inset:10.

      l2 := Label origin:0.0@0.5 corner:1.0@1.0 in:top.
      l2 converter:(PrintConverter new initForDate).
      l2 model:v2; labelMessage:#value; aspect:#value.
      l2 level:-1; inset:10.

      top open.

      'now, change the values ...'.
      [
        1 to:50 do:[:i|
            v1 value:(v1 value + 1).
            v2 value:(v2 value addDays:1).
            (Delay forSeconds:0.5) wait
        ]
      ] fork
                                                                        [exEnd]

    convert a models value for a label with limited precision
    float conversion:
                                                                        [exBegin]
      |top v l1 l2|

      v := 0.0 asValue.

      top := StandardSystemView new.
      top extent:200@200.

      l1 := Label origin:0.0@0.0 corner:1.0@0.5 in:top.
      l1 converter:(PrintConverter new initForFloat).
      l1 model:v; labelMessage:#value; aspect:#value.
      l1 level:-1; inset:10.

      l2 := Label origin:0.0@0.5 corner:1.0@1.0 in:top.
      l2 converter:(PrintConverter new initForFloatWithPrecision:2).
      l2 model:v; labelMessage:#value; aspect:#value.
      l2 level:-1; inset:10.

      top open.

      'now, change the values ...'.
      [
        1 to:100 do:[:i|
            v value:(v value + 0.005).
            (Delay forSeconds:0.5) wait
        ]
      ] fork
                                                                        [exEnd]

    a custom converter, converting a number to either 'odd'
    or 'even' strings (we only need a one-way converter for labels):
                                                                        [exBegin]
      |top v l1 l2|

      v := 0 asValue.

      top := StandardSystemView new.
      top extent:200@200.

      l1 := Label origin:0.0@0.0 corner:1.0@0.5 in:top.
      l1 converter:(PrintConverter new initForInteger).
      l1 model:v; labelMessage:#value; aspect:#value.
      l1 level:-1; inset:10.

      l2 := Label origin:0.0@0.5 corner:1.0@1.0 in:top.
      l2 converter:(PrintConverter 
                      new 
                          toPrint:[:num | num even ifTrue:['even'] 
                                                   ifFalse:['odd']]
                          toRead:[:string | ]).
      l2 model:v; labelMessage:#value; aspect:#value.
      l2 level:-1; inset:10.

      top open.

      'now, change the values ...'.
      [
        1 to:100 do:[:i|
            v value:(v value + 1).
            (Delay forSeconds:0.5) wait
        ]
      ] fork
                                                                        [exEnd]

    see more examples in the EditField examples.
"
! !

!PrintConverter class methodsFor:'instance creation'!

new
    ^ (super new) 
	toPrint:[:val | val]
	toRead:[:string | string]
! !

!PrintConverter class methodsFor:'utilities'!

print:aNumber formattedBy:formatString
    "take the digits of aNumbers printString, and squash them
     into formatString, where #-characters are replaced by
     successive characters from the printString.
     Warning: use with care - it does not check for decimal points etc.
              the printString of aNumber must have enough digits for all
              #-characters to be replaced.
              Therefore, precheck the numbers value and use appropriate format
              strings then.
     For number formatting, see also: printfPrintString: implementations."

    |pS fS out|

    pS := ReadStream on:aNumber printString.
    fS := ReadStream on:formatString.
    out := WriteStream on:(formatString species new:100).
    [fS atEnd] whileFalse:[
        |c|

        c := fS next.
        c == $# ifTrue:[
            c := pS next
        ].
        out nextPut:c
    ].
    ^ out contents

    "
     PrintConverter print:'123456789' formattedBy:'US$ ###,###.##' 

    fails for:
     PrintConverter print:'1234' formattedBy:'US$ ###,###.##' 

    invalid string for:
     PrintConverter print:'123456789' formattedBy:'US$ ###' 
    "
! !

!PrintConverter methodsFor:'accessing'!

type
    "return the type if its one of the standard converters,
     #number, #string etc. nil otherwise"

    ^ type
! !

!PrintConverter methodsFor:'converting'!

printStringFor:aValue
    "sent when an inputField wants a models value to be converted to a string
     for display"

    ^ valueToStringBlock value:aValue
!

readValueFrom:aString
    "sent when an inputField wants a string to be converted to a value 
     to be returned as its contents value"

    ^ stringToValueBlock value:aString
! !

!PrintConverter methodsFor:'initialization'!

initFor:aTypeSymbol
    "initialize to convert to/from objects as specified by aTypeSymbol,
     which may be one of #number, #string, #symbol, #date or #password ..."

    aTypeSymbol == #number ifTrue:[
        self initForNumber
    ].
    aTypeSymbol == #numberOrNil ifTrue:[
        self initForNumberOrNil
    ].
    aTypeSymbol == #integer ifTrue:[
        self initForInteger
    ].
    aTypeSymbol == #integerOrNil ifTrue:[
        self initForIntegerOrNil
    ].
    (aTypeSymbol == #string or:[aTypeSymbol == #password]) ifTrue:[
        self initForString
    ].
    aTypeSymbol == #date ifTrue:[
        self initForDate
    ].
    aTypeSymbol == #time ifTrue:[
        self initForTime
    ].
    aTypeSymbol == #timeOrNil ifTrue:[
        self initForTimeOrNil
    ].
    aTypeSymbol == #float ifTrue:[
        self initForFloat
    ].
    aTypeSymbol == #dateOrNil ifTrue:[
        self initForDateOrNil
    ].
    aTypeSymbol == #symbol ifTrue:[
        self initForSymbol
    ].

    type := aTypeSymbol

    "Modified: 6.9.1995 / 12:10:38 / claus"
!

initForDate
    "initialize to convert to/from a date 
     - if the string is empty or invalid, convert to the current date"

    valueToStringBlock := [:date | date printString].
    stringToValueBlock := [:string | Date readFromString:string onError:[Date today]]
!

initForDateOrNil
    "initialize to convert to/from a date 
     - if the string is empty or invalid, convert to nil"

    valueToStringBlock := [:date | date printString].
    stringToValueBlock := [:string | Date readFromString:string onError:nil]
!

initForFloat
    "initialize to convert to/from an float 
     - if the string is empty or invalid, convert to 0"

    valueToStringBlock := [:num | num asFloat printString].
    stringToValueBlock := [:string | Float readFromString:string onError:0]
!

initForFloatWithPrecision:nDigits
    "initialize to convert to/from an float with nDigits after the decimal point
     (truncating remaining digits).
     - if the string is empty or invalid, convert to 0"

    |conv|

    conv := '%.' , nDigits printString , 'f'.
    valueToStringBlock := [:num | num asFloat printfPrintString:conv].
    stringToValueBlock := [:string | Float readFromString:string onError:0]
!

initForInteger
    "initialize to convert to/from an integer 
     - if the string is empty or invalid, convert to 0"

    valueToStringBlock := [:num | num truncated printString].
    stringToValueBlock := [:string | Integer readFromString:string onError:0]
!

initForIntegerOrNil
    "initialize to convert to/from an integer 
     - if the string is empty or invalid, convert to nil"

    valueToStringBlock := [:num | 
	num isNil ifTrue:[''] 
		  ifFalse:[num printString]].
    stringToValueBlock := [:string | 
	Integer readFromString:string onError:nil]
!

initForNumber
    "initialize to convert to/from a number 
     - if the string is empty or invalid, convert to 0"

    valueToStringBlock := [:num | num printString].
    stringToValueBlock := [:string | Number readFromString:string onError:0]
!

initForNumberOrNil
    "initialize to convert to/from a number 
     - if the string is empty or invalid, convert to nil"

    valueToStringBlock := [:num | 
        num isNil ifTrue:[''] 
                  ifFalse:[num printString]].
    stringToValueBlock := [:string |
        |s|

        s := string.
        (s endsWith:'.') ifTrue:[
            s := s , '0'
        ].
        Number readFromString:s onError:nil
    ]




!

initForString
    "initialize for a string - this is trivial"

    valueToStringBlock := [:val | val isNil ifTrue:[''] ifFalse:[val]].
    stringToValueBlock := [:string | string]
!

initForTime
    "initialize to convert to/from a time 
     - if the string is empty or invalid, convert to the current time"

    valueToStringBlock := [:time | time printString].
    stringToValueBlock := [:string | Time readFromString:string onError:[Time now]]
!

initForTimeOrNil
    "initialize to convert to/from a time 
     - if the string is empty or invalid, convert to nil"

    valueToStringBlock := [:time | time printString].
    stringToValueBlock := [:string | Time readFromString:string onError:nil]
!

initForYesNo
    "initialize to convert a 'yes'/'no' string to/from a boolean
     The string is supposed to be in the current Language
     (i.e. if german, ja/nein has to be entered.
     Invalid entries are converted to false."

    valueToStringBlock := [:bool | bool ifTrue:[ApplicationModel classResources string:'yes']
                                        ifFalse:[ApplicationModel classResources string:'no']].
    stringToValueBlock := [:string | string = (ApplicationModel classResources string:'yes')]
!

toPrint:printBlock toRead:readBlock
    "initialize to convert using two custom blocks.
     printBlock is supposed to get the objects value as argument,
     and to return a string.
     readBlock is supposed to get a string as argument, and return
     the corresponding object."

    valueToStringBlock := printBlock.
    stringToValueBlock := readBlock.
! !

!PrintConverter class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

