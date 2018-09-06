"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ScaledDecimalTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Numbers'
!


!ScaledDecimalTest methodsFor:'helpers'!

literal_helper1
    ^ 1.40s2.

    "Created: / 09-08-2011 / 21:11:13 / cg"
! !

!ScaledDecimalTest methodsFor:'temporary'!

literal_helper2
    ^ 1.40s2.
! !

!ScaledDecimalTest methodsFor:'tests'!

test01_ParserDefaultIsToSupportFixedPointLiterals
    "the old setting was to disallow by default;
     it is now on, by default"

    self assert:(ParserFlags allowFixedPointLiterals).

    "Created: / 09-08-2011 / 21:23:56 / cg"
!

test02_AsNumber
	"Ensure no loss of precision"

	| sd |
	sd := '1.40s2' asNumber.
	self assert: (ScaledDecimal ? FixedPoint) == sd class.
	self assert: sd scale == 2.

	Smalltalk isSmalltalkX ifTrue:[
	    self assert: '1.40' = sd printString.
	    self assert: '1.40s2' = sd storeString.
	] ifFalse:[
	    self assert: '1.40s2' = sd printString.
	]

    "Created: / 09-08-2011 / 21:25:31 / cg"
!

test03_AsNumberNegatedWithoutDecimalPoint

	| sd |
	sd := '-123s0' asNumber.
	self assert: (ScaledDecimal ? FixedPoint) == sd class.
	self assert: sd scale == 0.

	Smalltalk isSmalltalkX ifTrue:[
	    self assert: '-123' = sd printString.
	    self assert: '-123s0' = sd storeString.
	] ifFalse:[
	    self assert: '-123s0' = sd printString.
	]

    "Created: / 09-08-2011 / 21:25:43 / cg"
!

test04_AsNumberNegatedWithoutDecimalPoint2

	| sd |
	sd := '-123s2' asNumber.
	self assert: (ScaledDecimal ? FixedPoint) == sd class.
	self assert: sd scale == 2.

	Smalltalk isSmalltalkX ifTrue:[
	    self assert: '-123.00' = sd printString.
	    self assert: '-123.00s2' = sd storeString.
	] ifFalse:[
	    self assert: '-123.00s2' = sd printString.
	]

    "Created: / 09-08-2011 / 21:25:54 / cg"
!

test05_AsNumberWithExtendedScale

	| sd |
	sd := '123s2' asNumber.
	self assert: (ScaledDecimal ? FixedPoint) == sd class.
	self assert: sd scale == 2.

	Smalltalk isSmalltalkX ifTrue:[
	    self assert: '123.00' = sd printString.
	    self assert: '123.00s2' = sd storeString.
	] ifFalse:[
	    self assert: '123.00s2' = sd printString.
	]

    "Created: / 09-08-2011 / 21:25:59 / cg"
!

test06_AsNumberWithRadix
	| sd oldSetting |

	Smalltalk isSmalltalkX ifTrue:[
	    oldSetting := ParserFlags allowFixedPointLiterals.
	    ParserFlags allowFixedPointLiterals:true.
	    [
		sd := Number readSmalltalkSyntaxFrom:'10r-22.2s5'.
	    ] ensure:[
		ParserFlags allowFixedPointLiterals:oldSetting.
	    ]
	] ifFalse:[
	    sd := '10r-22.2s5' asNumber.
	].

	self assert: (ScaledDecimal ? FixedPoint) == sd class.
	self assert: sd scale == 5.

	Smalltalk isSmalltalkX ifTrue:[
	    self assert: '-22.20000' = sd printString.
	    self assert: '-22.20000s5' = sd storeString.
	] ifFalse:[
	    self assert: '-22.20000s5' = sd printString.
	]

    "Created: / 09-08-2011 / 21:26:05 / cg"
!

test07_AsNumberWithSuperfluousDecimalPoint

	| sd |
	sd := '123.s2' asNumber.
	self assert: (ScaledDecimal ? FixedPoint) == sd class.
	self assert: sd scale == 2.

	Smalltalk isSmalltalkX ifTrue:[
	    self assert: '123.00' = sd printString.
	    self assert: '123.00s2' = sd storeString.
	] ifFalse:[
	    self assert: '123.00s2' = sd printString.
	]

    "Created: / 09-08-2011 / 21:26:20 / cg"
!

test08_AsNumberWithoutDecimalPoint

	| sd |
	sd := '123s0' asNumber.
	self assert: (ScaledDecimal ? FixedPoint) == sd class.
	self assert: sd scale == 0.

	Smalltalk isSmalltalkX ifTrue:[
	    self assert: '123' = sd printString.
	    self assert: '123s0' = sd storeString.
	] ifFalse:[
	    self assert: '123s0' = sd printString.
	]

    "Created: / 09-08-2011 / 21:26:25 / cg"
!

test09_AsNumberWithoutDecimalPoint2

	| sd |
	sd := '123s2' asNumber.
	self assert: (ScaledDecimal ? FixedPoint) == sd class.
	self assert: sd scale == 2.

	Smalltalk isSmalltalkX ifTrue:[
	    self assert: '123.00' = sd printString.
	    self assert: '123.00s2' = sd storeString.
	] ifFalse:[
	    self assert: '123.00s2' = sd printString.
	]

    "Created: / 09-08-2011 / 21:26:30 / cg"
!

test10_ConvertFromFloat

	| aFloat sd f2 diff |
	aFloat := 11/13 asFloat.
	sd := aFloat asScaledDecimal: 2.
	self assert: 2 == sd scale.
	Smalltalk isSmalltalkX ifTrue:[
	    self assert: '0.85' = sd printString.
	] ifFalse:[
	    self assert: '0.84s2' = sd printString.
	].
	f2 := sd asFloat.
	diff := f2 - aFloat.
	self assert: diff < 1.0e-9. "actually, f = f2, but this is not a requirement"

    "Created: / 09-08-2011 / 21:26:38 / cg"
!

test11_ConvertFromFraction

	| sd |
	sd := (13 / 11) asScaledDecimal: 6.
	self assert: (ScaledDecimal ? FixedPoint) == sd class.
	Smalltalk isSmalltalkX ifTrue:[
	    self assert: ('1.181818' = sd printString).
	] ifFalse:[
	    self assert: ('1.181818s6' = sd printString).
	].
	self assert: 6 == sd scale

    "Created: / 09-08-2011 / 21:26:43 / cg"
!

test12_ConvertFromInteger
	"Converting an Integer to a ScaledDecimal yields a ScaledDecimal with
	scale 0, regardless of the scale specified in the #asScaledDecimal: message."

	| sd |

	Smalltalk isSmalltalkX ifTrue:[
	    "/ I think this behavior is wrong.
	    ^ self.
	].

	sd := 13 asScaledDecimal: 6.
	self assert: 0 = sd scale.
	self assert: ('13s0' = sd printString).
	sd := -13 asScaledDecimal: 6.
	self assert: 0 = sd scale.
	self assert: ('-13s0' = sd printString).
	sd := 130000000013 asScaledDecimal: 6.
	self assert: 0 = sd scale.
	self assert: ('130000000013s0' = sd printString).
	sd := -130000000013 asScaledDecimal: 6.
	self assert: 0 = sd scale.
	self assert: ('-130000000013s0' = sd printString)

    "Created: / 09-08-2011 / 21:26:46 / cg"
!

test13_Literal1
    "s2 is not a message to be sent to a float"

    self
	shouldnt:[ self literal_helper1 ]
	raise:MessageNotUnderstood

    "Created: / 09-08-2011 / 21:26:55 / cg"
!

test14_Literal2
	| sd |

	sd := 1.40s2.
	self assert: (ScaledDecimal ? FixedPoint) == sd class.
	self assert: sd scale == 2.
	Smalltalk isSmalltalkX ifTrue:[
	    self assert: '1.40' = sd printString.
	    self assert: '1.40s2' = sd storeString.
	] ifFalse:[
	    self assert: '1.40s2' = sd printString.
	].

    "Created: / 09-08-2011 / 21:27:01 / cg"
!

test15_LiteralInSTC
    |value|

    Class withoutUpdatingChangesDo:[
	self class
	    compile:
'literal_helper2
    ^ 1.40s2.
'
	    classified:'temporary'.

	Compiler stcCompileMethod:(self class compiledMethodAt:#literal_helper2).
    ].

    self
	shouldnt:[ self literal_helper2 ]
	raise:MessageNotUnderstood.

    value := self literal_helper2.
    self assert:( value isFixedPoint ).
    self assert:( (value * 10) = 14 ).
    self assert:( value asFloat = 1.4 ).

    "Created: / 09-08-2011 / 21:27:07 / cg"
!

test16_PrintString
	"The printed representation of a ScaledDecimal is truncated, not rounded.
	Not sure if this is right, so this test describes the current Squeak implementation.
	If someone knows a reason that rounding would be preferable, then update
	this test."

	| sd |

	sd := (13 / 11) asScaledDecimal: 6.
	Smalltalk isSmalltalkX ifTrue:[
	    self assert: ('1.181818' = sd printString).
	] ifFalse:[
	    self assert: ('1.181818s6' = sd printString).
	].

	sd := (13 / 11) asScaledDecimal: 5.
	Smalltalk isSmalltalkX ifTrue:[
	    self assert: ('1.18182' = sd printString).
	] ifFalse:[
	    self deny: ('1.18182s5' = sd printString).
	].

	sd := (13 / 11) asScaledDecimal: 5.
	Smalltalk isSmalltalkX ifTrue:[
	    self deny: ('1.18181' = sd printString).
	] ifFalse:[
	    self assert: ('1.18181s5' = sd printString).
	].

    "Created: / 09-08-2011 / 21:27:49 / cg"
!

test17_StoreAndRead
    |check|

    check := [:originalNum |
	|s readNum|

	s := originalNum storeString.
	readNum := Number readFrom:s.
	self assert:readNum = originalNum.
    ].

    check value:((FixedPoint fromString:'0.66666666')                   ).
    check value:((FixedPoint fromString:'0.66666666') withScale:2       ).

    check value:((FixedPoint fromString:'1.5')                          ).
    check value:((FixedPoint fromString:'1.5') withScale:2              ).
    check value:((FixedPoint fromString:'1.5') withScale:1              ).
    check value:((FixedPoint fromString:'1.5') withScale:0              ).

    "Created: / 09-08-2011 / 21:27:53 / cg"
! !

!ScaledDecimalTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

