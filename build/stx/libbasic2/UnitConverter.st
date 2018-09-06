"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1996 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#UnitConverter
	instanceVariableNames:''
	classVariableNames:'Conversions Scaling Aliases Constants'
	poolDictionaries:''
	category:'Magnitude-General'
!

!UnitConverter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 eXept Software AG
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
    In order to collect various unit conversions into one central
    manageable (and especially: browsable) place, all previously
    spread knowledge about metric (and other) conversions has been
    brought into this class.

    This class is purely functional, abstract and has no instances;
    all queries are via class protocol.
    Choosing the Magnitudes category as its home is arbitrary.

    The supported units are setup in the classes initialize method;
    supported are:
        meter - inch - feet - foot - yard
        meter2 - acre - 'german-ar' 'german-hektar' are
        liter - gallon - barrel - floz
        celsius - fahrenheit
    and many others.

    The converter does a recursive search for a conversion;
    thus, if there is a conversion from #inch to #millimeter and another 
    from #millimeter to #kilometer, conversion from #inch to #kilometer
    is found automatically.

    No Warranty:
        The numbers and conversion factors were obtained from the Unix
        units command. Please check before using it - there might be
        typos or wrong conversions in the setup code.


    Notice:
        This class is *much* older than the younger and more object oriented
        Measurements package. Other than solving similar problems, these two packages
        are not related.


    [author:]
        Claus Gittinger

    see also:
        examples
        /usr/share/lib/unittab (if present on your system)
        Measurement Unit
"
!

examples
"
    ever wanted to know, how many floz's are there in a european
    Coce bottle ?
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:1 from:#liter to:#floz)
                                                                [exEnd]

                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:43.5 from:#oz to:#gram)
                                                                [exEnd]

    or, how many square-meters an acre is:
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:1 from:#acre to:#'meter^2')
                                                                [exEnd]


    or europeans might want to know, what those
    fahrenheit numbers mean in an US weather report ;-):
                                                                [exBegin]
        Transcript showCR:(
            (UnitConverter convert:80 from:#fahrenheit to:#celsius)
                asFixedPoint:1)
                                                                [exEnd]


    how fast do I drive ? :-)
                                                                [exBegin]
        Transcript showCR:(
                UnitConverter convert:200 from:#'km/hr' to:#'mile/hr')
                                                                [exEnd]
    how fast does Chris drive ? :-)
                                                                [exBegin]
        Transcript showCR:(
                UnitConverter convert:65 from:#'mile/hr' to:#'km/hr')
                                                                [exEnd]


    calories or joule ?
                                                                [exBegin]
        Transcript showCR:(
                UnitConverter convert:0.18 from:#'kilocalorie' to:#'kilojoule')
                                                                [exEnd]
                                                                [exBegin]
        Transcript showCR:(
                UnitConverter convert:2000 from:#'kilocalorie' to:#'kilojoule')
                                                                [exEnd]


    distances:
        
                                                                [exBegin]
        Transcript showCR:(
            UnitConverter convert:1 from:#'lightsecond' to:#'kilometer') 
                                                                [exEnd]
    that's the same:
                                                                [exBegin]
        Transcript showCR:(
            UnitConverter convert:1 from:#'lightspeed*s' to:#'kilometer') 
                                                                [exEnd]
    a days travel ...
                                                                [exBegin]
        Transcript showCR:(
            UnitConverter convert:1 from:#'lightspeed*dy' to:#'kilometer') 
                                                                [exEnd]
    a year travel ...
                                                                [exBegin]
        Transcript showCR:(
            UnitConverter convert:1 from:#'lightyear' to:#'kilometer') 
                                                                [exEnd]

    wonna race on the autobahn ?
                                                                [exBegin]
        Transcript showCR:(
            UnitConverter convert:200 from:#'km/h' to:#'mph') 
                                                                [exEnd]
                                                                [exBegin]
        Transcript showCR:(
            UnitConverter convert:13 from:#'m/s' to:#'km/h') 
                                                                [exEnd]


    real estate buyers might want to know, how many acres
    a german ar is:
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:1 from:#'german-ar' to:#acre)
                                                                [exEnd]
    - or how many square-feet are there in your living room:
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:100 from:#'meter^2' to:#'foot^2')   
                                                                [exEnd]
    - or how about:
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:3600 from:#'ft*ft' to:#'m*,')   
                                                                [exEnd]


    how many tea spoons are there in a cubic meter ?
    (roughly, since a teaspoon is not a standard unit)
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:1 from:#'meter^3' to:#teaspoon)
                                                                [exEnd]
    how wide is a US page in inches:
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:1 from:#'letterW' to:#inch)   
                                                                [exEnd]
    - in millimeter:
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:1 from:#'letterW' to:#mm)   
                                                                [exEnd]


    the height of a US page in inches:
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:1 from:#'letterH' to:#inch)   
                                                                [exEnd]
    - in millimeter:
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:1 from:#'letterH' to:#mm)   
                                                                [exEnd]


    the same for european A4 standard page:
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:1 from:#'a4H' to:#mm)   
                                                                [exEnd]
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:1 from:#'a4H' to:#inch)   
                                                                [exEnd]

    the mass of a proton:
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:1 from:#'proton' to:#eV)    
                                                                [exEnd]
    the energy of a single proton in the LHC (as of 2010)
                                                                [exBegin]
        Transcript showCR:
            (UnitConverter convert:7 from:#'TeV' to:#joule)   
                                                                [exEnd]
"
! !

!UnitConverter class methodsFor:'initialization'!

initializeConversions
    "initialize common conversions"

    self initializeScaleFactors.

    Conversions := IdentityDictionary new.
    Aliases := IdentityDictionary new.
    Constants := IdentityDictionary new.

    "/ ---------- velocity -------------

    Constants at:#lightspeed   put:#(2.997925E8   #'m/s').
    Constants at:#soundspeed   put:#(343          #'m/s').  "/ 20degC - AIR


    "/ -------------- length -------------

    Aliases at:#km       put:#kilometer.
    Aliases at:#m        put:#meter.
    Aliases at:#dm       put:#decimeter.
    Aliases at:#cm       put:#centimeter.
    Aliases at:#mm       put:#millimeter.
    Aliases at:#micron   put:#micrometer.
    Aliases at:#nm       put:#nanometer.
    Aliases at:#angstrom put:#decinanometer.

    "/ US
    self addConversion:12       from:#foot to:#inch.
    self addConversion:3        from:#yard to:#foot.
    self addConversion:5280     from:#mile to:#foot.
    self addConversion:0.001    from:#inch to:#mil.

    Aliases at:#feet  put:#foot.
    Aliases at:#ft    put:#foot.
    Aliases at:#yd    put:#yard.
    Aliases at:#mi    put:#mile.
    Aliases at:#mph   put:#'mile/hr'.

    "/ inch to millimeter
    self addConversion:(25.4/1000) from:#inch to:#meter.

    "/ nautic
    self addConversion:1852        from:#'nautical-mile' to:#meter.

    Aliases at:#lightsecond put:#'lightspeed*s'.
    Aliases at:#lightyear   put:#'lightspeed*yr'.

    self addConversion:((Constants at:#lightspeed) at:1) from:#'lightspeed*s' to:#'meter'.

    "/ ---------- time -------------

    self addConversion:60           from:#min to:#s.
    self addConversion:60           from:#hr  to:#min.
    self addConversion:24           from:#dy  to:#hr.
    self addConversion:365.24219879 from:#yr  to:#dy.

    Aliases at:#h   put:#'hr'.
    Aliases at:#d   put:#'dy'.

    "/ ---------- printing -------------
    self initializePrintValues.

    "/ ---------------- area -------------------

    "/ US
    self addConversion:4840        from:#acre  to:#'yard^2'.

    self addConversion:100         from:#are      to:#'meter^2'.
    self addConversion:100         from:#hectare  to:#are.

    "/ german area - add your countries, and return to me ...
    Aliases at:#'german-ar'      put:#are.
    Aliases at:#'german-hektar'  put:#hectare.


    "/ ---------------- liquid ---------------- 

    self addConversion:231      from:#gallon to:#'inch^3'.
    self addConversion:(1/4)    from:#quart to:#gallon.  "/ well - at least here,
                                                         "/ that's also 1/4th of a good wine ;-)
    self addConversion:(1/2)    from:#pint to:#quart.
    self addConversion:(1/16)   from:#floz to:#pint.
    self addConversion:(1/8)    from:#fldr to:#floz.

    self addConversion:42       from:#barrel to:#gallon.
    self addConversion:35.23907 from:#bushel to:#liter.

    Aliases at:#cc    put:#'cm^3'.
    Aliases at:#liter put:#kilocc.
    Aliases at:#ml    put:#milliliter.
    Aliases at:#gal   put:#gallon.
    Aliases at:#qt    put:#quart.

    "/ well, a pint of beer is not always:
    self addConversion:277.420 from:#'british-gallon'  to:#'inch^3'.
    self addConversion:(1/4)   from:#'british-quart'   to:#'british-gallon'.
    self addConversion:(1/2)   from:#'british-pint'    to:#'british-quart'.
    self addConversion:(1/16)  from:#'british-floz'    to:#'british-pint'.

    "/ ---------------- mass ---------------- 

    self addConversion:28.35     from:#ounce to:#gram.
    self addConversion:453.59237 from:#lb    to:#gram.
    self addConversion:205       from:#carat to:#milligram.

    self addConversion:0.938272013 from:#proton to:#GeV.
    self addConversion:0.510998910 from:#electron to:#MeV.
    self addConversion:0.939565346 from:#neutron to:#GeV.

    Aliases at:#oz put:#ounce.
    Aliases at:#lbs put:#lb.

    Aliases at:#gm put:#gram.
    Aliases at:#kg put:#kilogram.

    "/ ---------------- energy ---------------- 

    Aliases at:#cal     put:#calorie.
    Aliases at:#nt      put:#newton.
    Aliases at:#joule   put:#'nt*m'.
    Aliases at:#J       put:#'joule'.
    Aliases at:#N       put:#'newton'.
    Aliases at:#eV      put:#'electronvolt'.
    Aliases at:#MeV     put:#'megaeV'.
    Aliases at:#GeV     put:#'gigaeV'.
    Aliases at:#TeV     put:#'teraeV'.

    Aliases at:#watt    put:#'J/s'.

    self addConversion:4.1868 from:#calorie  to:#joule.
    self addConversion:1.60217653E-19 from:#electronvolt  to:#joule.


    "/ ---------------- cooking ---------------- 

    self addConversion:4      from:#tablespoon   to:#fldr.
    self addConversion:(4/3)  from:#teaspoon     to:#fldr.


    "/ ---------------- temperature ---------------- 

    self addConversion:[:d | d * 1.8 + 32] from:#celsius    to:#fahrenheit.
    self addConversion:[:f | (f - 32) / 1.8] from:#fahrenheit to:#celsius.

    "/ ---------------- nature ---------------- 
    Constants at:#planckLength   put:#(1.616e-35   #'m').
    Constants at:#planckMass     put:#(2.176-8     #'Kg').
    Constants at:#planckTime     put:#(5.391e-44   #'s').
    
    "
     Conversions := nil.
     UnitConverter initializeConversions
    "

    "Created: / 22.7.1997 / 13:56:40 / cg"
    "Modified: / 10.10.2001 / 14:39:04 / cg"
!

initializePrintValues
    "/ inch to (roughly) a typesetter point
    self addConversion:(1/72)      from:#point to:#inch.

    "/ point to twips; 20 twips (as in Rich-Text-Format) make a point
    self addConversion:(1/20)      from:#twip  to:#point.

    "/ US paper
    self addConversion:11          from:#'letter-page-height' to:#inch.
    self addConversion:8.5         from:#'letter-page-width'  to:#inch.
    self addConversion:8.5         from:#'letter-landscape-page-height'  to:#inch.
    self addConversion:11          from:#'letter-landscape-page-width' to:#inch.

    self addConversion:14          from:#'legal-page-height' to:#inch.
    self addConversion:8.5         from:#'legal-page-width'  to:#inch.
    self addConversion:8.5         from:#'legal-landscape-page-height'  to:#inch.
    self addConversion:14          from:#'legal-landscape-page-width' to:#inch.

    self addConversion:11          from:#'ledger-page-height' to:#inch.
    self addConversion:17          from:#'ledger-page-width'  to:#inch.
    self addConversion:17          from:#'ledger-landscape-page-height'  to:#inch.
    self addConversion:11          from:#'ledger-landscape-page-width' to:#inch.

    "/ European paper
    self addConversion:840         from:#'a1-page-height' to:#millimeter.
    self addConversion:592         from:#'a1-page-width'  to:#millimeter.
    self addConversion:592         from:#'a1-landscape-page-height' to:#millimeter.
    self addConversion:840         from:#'a1-landscape-page-width'  to:#millimeter.

    self addConversion:592         from:#'a2-page-height' to:#millimeter.
    self addConversion:420         from:#'a2-page-width'  to:#millimeter.
    self addConversion:420         from:#'a2-landscape-page-height' to:#millimeter.
    self addConversion:592         from:#'a2-landscape-page-width'  to:#millimeter.

    self addConversion:420         from:#'a3-page-height' to:#millimeter.
    self addConversion:296         from:#'a3-page-width'  to:#millimeter.
    self addConversion:296         from:#'a3-landscape-page-height' to:#millimeter.
    self addConversion:420         from:#'a3-landscape-page-width'  to:#millimeter.

    self addConversion:296         from:#'a4-page-height' to:#millimeter.
    self addConversion:210         from:#'a4-page-width'  to:#millimeter.
    self addConversion:210         from:#'a4-landscape-page-height' to:#millimeter.
    self addConversion:296         from:#'a4-landscape-page-width'  to:#millimeter.

    self addConversion:210         from:#'a5-page-height' to:#millimeter.
    self addConversion:148         from:#'a5-page-width'  to:#millimeter.
    self addConversion:148         from:#'a5-landscape-page-height' to:#millimeter.
    self addConversion:210         from:#'a5-landscape-page-width'  to:#millimeter.

    self addConversion:148         from:#'a6-page-height' to:#millimeter.
    self addConversion:105         from:#'a6-page-width'  to:#millimeter.
    self addConversion:105         from:#'a6-landscape-page-height' to:#millimeter.
    self addConversion:148         from:#'a6-landscape-page-width'  to:#millimeter.

    self addConversion:257         from:#'b5-page-height' to:#millimeter.
    self addConversion:182         from:#'b5-page-width'  to:#millimeter.
    self addConversion:182         from:#'b5-landscape-page-height' to:#millimeter.
    self addConversion:257         from:#'b5-landscape-page-width'  to:#millimeter.


    Aliases at:#letterW    put:#'letter-page-width'.
    Aliases at:#letterH    put:#'letter-page-height'.
    Aliases at:#legalW     put:#'legal-page-width'.
    Aliases at:#legalH     put:#'legal-page-height'.
    Aliases at:#ledgerW    put:#'ledger-page-width'.
    Aliases at:#ledgerH    put:#'ledger-page-height'.
    Aliases at:#a1W        put:#'a1-page-width'.
    Aliases at:#a1H        put:#'a1-page-height'.
    Aliases at:#a2W        put:#'a2-page-width'.
    Aliases at:#a2H        put:#'a2-page-height'.
    Aliases at:#a3W        put:#'a3-page-width'.
    Aliases at:#a3H        put:#'a3-page-height'.
    Aliases at:#a4W        put:#'a4-page-width'.
    Aliases at:#a4H        put:#'a4-page-height'.
    Aliases at:#a5W        put:#'a5-page-width'.
    Aliases at:#a5H        put:#'a5-page-height'.
    Aliases at:#a6W        put:#'a6-page-width'.
    Aliases at:#a6H        put:#'a6-page-height'.
    Aliases at:#b5W        put:#'b5-page-width'.
    Aliases at:#b5H        put:#'b5-page-height'.

    Aliases at:#letterlW   put:#'letter-landscape-page-width'.
    Aliases at:#letterlH   put:#'letter-landscape-page-height'.
    Aliases at:#legallW    put:#'legal-landscape-page-width'.
    Aliases at:#legallH    put:#'legal-landscape-page-height'.
    Aliases at:#ledgerlW   put:#'ledger-landscape-page-width'.
    Aliases at:#ledgerlH   put:#'ledger-landscape-page-height'.
    Aliases at:#a1lW       put:#'a1-landscape-page-width'.
    Aliases at:#a1lH       put:#'a1-landscape-page-height'.
    Aliases at:#a2lW       put:#'a2-landscape-page-width'.
    Aliases at:#a2lH       put:#'a2-landscape-page-height'.
    Aliases at:#a3lW       put:#'a3-landscape-page-width'.
    Aliases at:#a3lH       put:#'a3-landscape-page-height'.
    Aliases at:#a4lW       put:#'a4-landscape-page-width'.
    Aliases at:#a4lH       put:#'a4-landscape-page-height'.
    Aliases at:#a5lW       put:#'a5-landscape-page-width'.
    Aliases at:#a5lH       put:#'a5-landscape-page-height'.
    Aliases at:#a6lW       put:#'a6-landscape-page-width'.
    Aliases at:#a6lH       put:#'a6-landscape-page-height'.
    Aliases at:#b5lW       put:#'b5-landscape-page-width'.
    Aliases at:#b5lH       put:#'b5-landscape-page-height'.
!

initializeScaleFactors
    Scaling := IdentityDictionary new.

    Scaling at:#yotta put:1000000000000000000000000.    "/ 10^24
    Scaling at:#zetta put:1000000000000000000000.       "/ 10^21
    Scaling at:#exa   put:1000000000000000000.          "/ 10^18
    Scaling at:#peta  put:1000000000000000.             "/ 10^15
    Scaling at:#tera  put:1000000000000.                "/ 10^12
    Scaling at:#giga  put:1000000000.                   "/ 10^9
    Scaling at:#mega  put:1000000.                      "/ 10^6
    Scaling at:#myria put:10000.
    Scaling at:#kilo  put:1000.                         "/ 10^3
    Scaling at:#hecto put:100.                          "/ 10^2
    Scaling at:#deca  put:10.                           "/ 10^1
    Scaling at:#deka  put:10.                           "/ 10^1
    Scaling at:#deci  put:(1/10).                       "/ 10^-1
    Scaling at:#centi put:(1/100).
    Scaling at:#milli put:(1/1000).                     "/ 10^-3
    Scaling at:#micro put:(1/1000000).                  "/ 10^-6
    Scaling at:#nano  put:(1/1000000000).               "/ 10^-9
    Scaling at:#pico  put:(1/1000000000000).            "/ 10^-12
    Scaling at:#femto put:(1/1000000000000000).         "/ 10^-15
    Scaling at:#atto  put:(1/1000000000000000000).      "/ 10^-18
    Scaling at:#zepto put:(1/1000000000000000000000).   "/ 10^-21
    Scaling at:#yocto put:(1/1000000000000000000000000)."/ 10^-24
! !

!UnitConverter class methodsFor:'accessing'!

scalings
    "return the set of known scaling prefixes"

    ^ Scaling keys

    "
     UnitConverter scalings
    "

    "Created: 6.8.1997 / 16:53:19 / cg"
    "Modified: 6.8.1997 / 16:58:11 / cg"
!

units
    "return the set of known units"

    |setOfUnits|

    setOfUnits := IdentitySet new.
    Conversions keysAndValuesDo:[:srcUnit :conversionInfo |
	setOfUnits add:srcUnit.
	conversionInfo keysDo:[:targetUnit |
	    setOfUnits add:targetUnit
	]
    ].
    ^ setOfUnits

    "
     UnitConverter units
    "

    "Created: 6.8.1997 / 16:57:08 / cg"
    "Modified: 6.8.1997 / 16:57:47 / cg"
! !

!UnitConverter class methodsFor:'conversions'!

convert:howMany from:sourceUnit to:destUnit
    "given a value in sourceUnit (symbolic), try to convert it
     to destUnit (symbolic); return nil, if the conversion is
     unknown."

    |u conversions alias rslt sU dU const val unit 
     i suNumerator suDenominator duNumerator duDenominator uN uD
     sF1 sF2 dF1 dF2
     s d|

"/ Transcript showCR:('try ' , sourceUnit , '->' , destUnit).

    Conversions isNil ifTrue:[
        self initializeConversions
    ].

    "/ somehow, recursion must end ...
    sourceUnit == destUnit ifTrue:[
        ^ howMany
    ].

    sourceUnit isSymbol ifFalse:[
        s := sourceUnit withoutSeparators.
        sU := s asSymbolIfInterned.
        sU notNil ifTrue:[
            ^ self convert:howMany from:sU to:destUnit
        ].
        (s startsWith:$() ifTrue:[
            (s endsWith:$)) ifTrue:[
                s := s copyFrom:2 to:(s size - 1).
                ^ self convert:howMany from:s to:destUnit
            ]
        ].
    ].
    destUnit isSymbol ifFalse:[
        d := destUnit withoutSeparators.
        dU := d asSymbolIfInterned.
        dU notNil ifTrue:[
            ^ self convert:howMany from:sourceUnit to:dU
        ].
        (d startsWith:$() ifTrue:[
            (d endsWith:$)) ifTrue:[
                d := d copyFrom:2 to:(d size - 1).
                ^ self convert:howMany from:sourceUnit to:d
            ]
        ].
    ].

    "/ first, get rid of scalers ...

    u := self unscaled:sourceUnit.
    u notNil ifTrue:[
        ^ self convert:(howMany*(u value)) from:(u key) to:destUnit
    ].

    u := self unscaled:destUnit.
    u notNil ifTrue:[
        ^ self convert:(howMany/(u value)) from:sourceUnit to:(u key)
    ].

    "/ and of aliases ...

    alias := Aliases at:sourceUnit ifAbsent:nil.
    alias notNil ifTrue:[
        ^ self convert:howMany from:alias to:destUnit
    ].
    alias := Aliases at:destUnit ifAbsent:nil.
    alias notNil ifTrue:[
        ^ self convert:howMany from:sourceUnit to:alias
    ].

    "/ any constants ?

    (Constants includesKey:sourceUnit) ifTrue:[
        const := Constants at:sourceUnit.
        val := const at:1.
        unit := const at:2.
        ^ self convert:(howMany*val) from:unit to:destUnit
    ].

    "/ compounds (^ , / or *) are very naively parsed
    "/ need a full expression parser (tree) for full power.
    "/ I leave that as an excercise to you ...


    "/ working with squares or cubics ?

    ((sourceUnit endsWith:'^2') and:[destUnit endsWith:'^2']) ifTrue:[
        sU := (sourceUnit copyButLast:2) asSymbolIfInterned.
        dU := (destUnit copyButLast:2) asSymbolIfInterned.
        (sU notNil and:[dU notNil]) ifTrue:[
            ^ (self convert:(howMany sqrt) from:sU to:dU) squared
        ].
        ^ self noConversionFrom:sourceUnit to:destUnit.
    ].
    ((sourceUnit endsWith:'^3') and:[destUnit endsWith:'^3']) ifTrue:[
        sU := (sourceUnit copyButLast:2) asSymbolIfInterned.
        dU := (destUnit copyButLast:2) asSymbolIfInterned.
        (sU notNil and:[dU notNil]) ifTrue:[
            ^ (self convert:(howMany raisedTo:(1/3)) from:sU to:dU) raisedTo:3
        ].
        ^ self noConversionFrom:sourceUnit to:destUnit.
    ].

    "/ working with fractions ?

    ((sourceUnit includes:$/) and:[destUnit includes:$/]) ifTrue:[
        "/ look for a constant conversion factor
        i := sourceUnit indexOf:$/.
        suNumerator := sourceUnit copyTo:(i - 1).
        suDenominator := sourceUnit copyFrom:(i + 1).
        i := destUnit indexOf:$/.
        duNumerator := destUnit copyTo:(i - 1).
        duDenominator := destUnit copyFrom:(i + 1).

        uN := self convert:howMany from:suNumerator to:duNumerator.
        uN notNil ifTrue:[
            uD := self convert:1 from:suDenominator to:duDenominator.
            uD notNil ifTrue:[
                ^ uN / uD
            ]
        ].
    ].

    "/ working with products ?

    ((sourceUnit includes:$*) and:[destUnit includes:$*]) ifTrue:[
        i := sourceUnit indexOf:$*.
        sF1 := sourceUnit copyTo:(i - 1).
        sF2 := sourceUnit copyFrom:(i + 1).
        i := destUnit indexOf:$*.
        dF1 := destUnit copyTo:(i - 1).
        dF2 := destUnit copyFrom:(i + 1).

        u := self convert:howMany from:sF1 to:dF1.
        u notNil ifTrue:[
            u := self convert:u from:sF2 to:dF2.
            u notNil ifTrue:[
                ^ u
            ]
        ].
    ].

    "/ the real work comes here ...

    "/ is there a direct conversion in the dataBase ?

    rslt := self convertDirect:howMany from:sourceUnit to:destUnit.
    rslt notNil ifTrue:[^ rslt].

    "/ try inverse conversion ...

    rslt := self convertDirect:1 from:destUnit to:sourceUnit.
    rslt notNil ifTrue:[ ^ howMany / rslt].

    "/ here's the deep recursion ...


    "/ try indirect conversion from source

    conversions := Conversions at:sourceUnit ifAbsent:nil.
    conversions notNil ifTrue:[
        conversions keysAndValuesDo:[:intermediateUnit :factor1 |
            |factor2|

            factor2 := self convert:factor1 from:intermediateUnit to:destUnit.
            factor2 notNil ifTrue:[^ factor2 * howMany].
        ].
    ].

    "/ try indirect conversion from dest

    conversions := Conversions at:destUnit ifAbsent:nil.
    conversions notNil ifTrue:[
        conversions keysAndValuesDo:[:intermediateUnit :factor1 |
            |factor2|

            factor2 := self convert:(factor1) from:intermediateUnit to:sourceUnit.
            factor2 notNil ifTrue:[^ howMany / factor2].
        ].
    ].

    "/ if working with a product, try each component

    (sourceUnit includes:$*) ifTrue:[
        i := sourceUnit indexOf:$*.
        sF1 := sourceUnit copyTo:(i - 1).
        sF2 := sourceUnit copyFrom:(i + 1).

        "/ see what we have ...

        self units do:[:aUnit |
            |pref iUnit factor2 rslt|

            pref := sF1 , '*'.
            (aUnit startsWith:pref) ifTrue:[
                "/ ok; want a/b -> x
                "/ found a/c -> any
                "/ what about c->b ?

                iUnit := aUnit copyFrom:pref size + 1.
                factor2 := self convert:1 from:sF2 to:iUnit.
                factor2 notNil ifTrue:[
                    "/ good ...
                    rslt := self convert:(factor2 * howMany)
                                    from:aUnit to:destUnit.
                    rslt notNil ifTrue:[^ rslt].
                ]
            ]
        ].
    ].

    ^ self noConversionFrom:sourceUnit to:destUnit.

    "direct - how many meters are there in two inches:
     UnitConverter convert:2 from:#inch to:#meter     
     UnitConverter convert:37 from:#degrees to:#fahrenheit     

     reverse - how many inches are there in one meter
     UnitConverter convert:1 from:#meter to:#inch   

     with alias:
     UnitConverter convert:1 from:#inch to:#m    
     UnitConverter convert:1 from:#inch to:#mm          
     UnitConverter convert:1 from:#inch to:#millimeter   
     UnitConverter convert:1 from:#inch to:#nanometer 
     UnitConverter convert:1 from:#mm to:#km  
     UnitConverter convert:1 from:#km to:#foot   

     indirect:
     UnitConverter convert:1 from:#mm   to:#twip  
     UnitConverter convert:1 from:#inch to:#twip  
     UnitConverter convert:1 from:'letterH' to:#point  
     UnitConverter convert:1 from:'letterlH' to:#point  

     UnitConverter convert:5 from:#barrel to:#liter  
     UnitConverter convert:10 from:#kilogram to:#carat  

     UnitConverter convert:1 from:#liter to:#floz  
    "

    "Created: 31.5.1996 / 16:23:38 / cg"
    "Modified: 6.8.1997 / 18:10:22 / cg"
!

fileSizeBinaryStringFor:nBytes
    "return a useful string for a size-in-bytes in programmer's notation; 
     Scales by Ki (*1024), Mi (*1024*1024) or Gi (*1024*1024*1024) or even Ti
     as required and useful.
     Provided here since this is so common...
     Notice: the scale is 1024
     the 1024 scale has been standardized in 1998 by IEC to MiB, GiB, etc.
     See https://en.wikipedia.org/wiki/Mebibyte"

    ^ self 
        unitStringFor:nBytes 
        scale:1024
        rounded:true
        unitStrings:#('Byte' 'KiB' 'MiB' 'GiB' 'TiB' 'PiB' 'EiB' 'ZiB' 'YiB')           

"/ the one below was written to save divisions.
"/ It seems to be not worth the effort...

"/    |unitString n|
"/
"/    nBytes isNil ifTrue:[
"/        ^ '-'
"/    ].
"/
"/    nBytes < (1000 * 1024 * 1024 * 1024) ifTrue:[
"/        nBytes < (1000 * 1024 * 1024) ifTrue:[
"/            nBytes < (1000 * 1024) ifTrue:[
"/                nBytes < 1000 ifTrue:[
"/                    n := nBytes.
"/                    unitString := '   '.
"/                ] ifFalse:[
"/                    n := (nBytes / 1024) asFixedPoint:1.
"/                    unitString := ' K'
"/                ]
"/            ] ifFalse:[
"/                n := (nBytes / (1024 * 1024)) asFixedPoint:1.
"/                unitString := ' M'
"/            ].
"/        ] ifFalse:[
"/            n := (nBytes / 1024 / (1024 * 1024)) asFixedPoint:1.
"/            unitString := ' G'
"/        ]
"/    ] ifFalse:[
"/        nBytes >= (1000 * 1024 * 1024 * 1024 * 1024) ifTrue:[
"/            nBytes >= (1000 * 1024 * 1024 * 1024 * 1024 * 1024) ifTrue:[
"/                n := (nBytes / (1024 * 1024) / (1024 * 1024) / (1024 * 1024)) asFixedPoint:1.
"/                unitString := ' E'
"/            ] ifFalse:[
"/                n := (nBytes / (1024 * 1024) / (1024 * 1024) / 1024) asFixedPoint:1.
"/                unitString := ' P'
"/            ]
"/        ] ifFalse:[
"/            n := (nBytes / (1024 * 1024) / (1024 * 1024)) asFixedPoint:1.
"/            unitString := ' T'
"/        ].
"/    ].
"/
"/"/    n truncated = n ifTrue:[
"/"/        n := n truncated
"/"/    ].
"/    ^ n printString , unitString.

    "
     self fileSizeStringFor:nil          
     self fileSizeStringFor:10          
     self fileSizeStringFor:100            
     self fileSizeStringFor:1000            
     self fileSizeStringFor:8192            
     self fileSizeStringFor:10000          
     self fileSizeStringFor:100000          
     self fileSizeStringFor:1000000        
     self fileSizeStringFor:10000000       
     self fileSizeStringFor:100000000      
     self fileSizeStringFor:1000000000      
     self fileSizeStringFor:10000000000      
     self fileSizeStringFor:100000000000      
     self fileSizeStringFor:1000000000000      
     self fileSizeStringFor:10000000000000      
     self fileSizeStringFor:10000000000000000      
     self fileSizeStringFor:100000000000000000000      
     self fileSizeStringFor:1000000000000000000000      
    "

    "Modified: / 17-12-2013 / 16:55:17 / cg"
    "Modified (comment): / 18-12-2014 / 09:54:33 / sr"
!

fileSizeFromString:fileSizeString
    "given a fileSize string (i.e. a number followed by optional kB, MB, GB etc. or KiB, MiB, GiB,...).
     Notice that in 1998, IEC standardized the scales to 1000 for k,M,G,... and 1024 for Ki, Mi, Gi, etc.
     See https://en.wikipedia.org/wiki/Mebibyte.
     Provided here since this is so common..."

    |numericValue s scaleChar factor scale|

    fileSizeString isEmpty ifTrue:[
        ^ 0
    ].

    scale := 1.
    s := fileSizeString readStream.
    numericValue := Number readFrom:s onError:[0].
    s skipSeparators.
    s atEnd ifFalse:[
        scaleChar := s next asLowercase.
        factor := 1000.
        s peek == $i ifTrue:[
            factor := 1024
        ].
        scaleChar == $k ifTrue:[
            scale := factor
        ] ifFalse:[
            scaleChar == $m ifTrue:[
                scale := factor * factor
            ] ifFalse:[
                scaleChar == $g ifTrue:[
                    scale := factor * factor * factor
                ] ifFalse:[
                    scaleChar == $t ifTrue:[
                        scale := factor * factor * factor * factor
                    ] ifFalse:[
                        scaleChar == $p ifTrue:[
                            scale := factor * factor * factor * factor * factor
                        ] ifFalse:[
                            scaleChar == $e ifTrue:[
                                scale := factor * factor * factor * factor * factor * factor
                            ] ifFalse:[
                                scaleChar == $z ifTrue:[
                                    scale := factor * factor * factor * factor * factor * factor * factor
                                ] ifFalse:[
                                    scaleChar == $y ifTrue:[
                                        scale := factor * factor * factor * factor * factor * factor * factor * factor
                                    ]
                                ] 
                            ]
                        ]
                    ]
                ]
            ]
        ].
    ].
    ^ (numericValue*scale) asInteger

    "
     self fileSizeFromString:'1234'          
     self fileSizeFromString:'10 k'            
     self fileSizeFromString:'10 kB'            
     self fileSizeFromString:'10 KiB'            
     self fileSizeFromString:'0.6 k'            
     self fileSizeFromString:'1.8 M'            
     self fileSizeFromString:'1.8 MB'            
     self fileSizeFromString:'1.8 MiB'            
     self fileSizeFromString:'0.5 G'            
     self fileSizeFromString:'0.5 T'            
     self fileSizeFromString:'0.5 P'            
     self fileSizeFromString:'0.5 E'            
    "

    "Modified (comment): / 17-12-2013 / 16:56:56 / cg"
!

fileSizeSIStringFor:nBytes
    "return a useful string for a size-in-bytes in SI standard notation; 
     Scales by K (*1000), M (*1000*1000) or G (*1000*1000*1000) or even T
     as required and useful.
     Provided here since this is so common...
     Notice: the scale is 1000
     the 1000 scale has been standardized in 1998 by IEC to MB, GB, etc.
     See https://en.wikipedia.org/wiki/Mebibyte"

    ^ self 
        unitStringFor:nBytes 
        scale:1000 
        rounded:true
        unitStrings:#('Byte' 'KB' 'MB' 'GB' 'TB' 'PB' 'EB' 'ZB' 'YB')           

"/    |unitString n|
"/
"/    nBytes isNil ifTrue:[
"/        ^ '-'
"/    ].
"/
"/    nBytes < (1000 * 1024 * 1024 * 1024) ifTrue:[
"/        nBytes < (1000 * 1024 * 1024) ifTrue:[
"/            nBytes < (1000 * 1024) ifTrue:[
"/                nBytes < 1000 ifTrue:[
"/                    n := nBytes.
"/                    unitString := '   '.
"/                ] ifFalse:[
"/                    n := (nBytes / 1024) asFixedPoint:1.
"/                    unitString := ' K'
"/                ]
"/            ] ifFalse:[
"/                n := (nBytes / (1024 * 1024)) asFixedPoint:1.
"/                unitString := ' M'
"/            ].
"/        ] ifFalse:[
"/            n := (nBytes / 1024 / (1024 * 1024)) asFixedPoint:1.
"/            unitString := ' G'
"/        ]
"/    ] ifFalse:[
"/        nBytes >= (1000 * 1024 * 1024 * 1024 * 1024) ifTrue:[
"/            nBytes >= (1000 * 1024 * 1024 * 1024 * 1024 * 1024) ifTrue:[
"/                n := (nBytes / (1024 * 1024) / (1024 * 1024) / (1024 * 1024)) asFixedPoint:1.
"/                unitString := ' E'
"/            ] ifFalse:[
"/                n := (nBytes / (1024 * 1024) / (1024 * 1024) / 1024) asFixedPoint:1.
"/                unitString := ' P'
"/            ]
"/        ] ifFalse:[
"/            n := (nBytes / (1024 * 1024) / (1024 * 1024)) asFixedPoint:1.
"/            unitString := ' T'
"/        ].
"/    ].
"/
"/"/    n truncated = n ifTrue:[
"/"/        n := n truncated
"/"/    ].
"/    ^ n printString , unitString.

    "
     self fileSizeStringFor:nil          
     self fileSizeStringFor:10          
     self fileSizeStringFor:100            
     self fileSizeStringFor:1000            
     self fileSizeStringFor:8192            
     self fileSizeStringFor:10000          
     self fileSizeStringFor:100000          
     self fileSizeStringFor:1000000        
     self fileSizeStringFor:10000000       
     self fileSizeStringFor:100000000      
     self fileSizeStringFor:1000000000      
     self fileSizeStringFor:10000000000      
     self fileSizeStringFor:100000000000      
     self fileSizeStringFor:1000000000000      
     self fileSizeStringFor:10000000000000      
     self fileSizeStringFor:10000000000000000      
     self fileSizeStringFor:100000000000000000000      
     self fileSizeStringFor:1000000000000000000000      
    "

    "Modified: / 17-12-2013 / 16:55:17 / cg"
    "Modified (comment): / 18-12-2014 / 09:54:33 / sr"
!

fileSizeStringFor:nBytes
    "return a useful string for a size-in-bytes.
     Scales either by 1000 or 1024, depending on the user preferences.
     See https://en.wikipedia.org/wiki/Mebibyte"

    ^ self 
        unitStringFor:nBytes 
        scale:(UserPreferences current unitForFileSize) 
        rounded:true
        unitStrings:(UserPreferences current unitStringsForFileSize)           

"/    |unitString n|
"/
"/    nBytes isNil ifTrue:[
"/        ^ '-'
"/    ].
"/
"/    nBytes < (1000 * 1024 * 1024 * 1024) ifTrue:[
"/        nBytes < (1000 * 1024 * 1024) ifTrue:[
"/            nBytes < (1000 * 1024) ifTrue:[
"/                nBytes < 1000 ifTrue:[
"/                    n := nBytes.
"/                    unitString := '   '.
"/                ] ifFalse:[
"/                    n := (nBytes / 1024) asFixedPoint:1.
"/                    unitString := ' K'
"/                ]
"/            ] ifFalse:[
"/                n := (nBytes / (1024 * 1024)) asFixedPoint:1.
"/                unitString := ' M'
"/            ].
"/        ] ifFalse:[
"/            n := (nBytes / 1024 / (1024 * 1024)) asFixedPoint:1.
"/            unitString := ' G'
"/        ]
"/    ] ifFalse:[
"/        nBytes >= (1000 * 1024 * 1024 * 1024 * 1024) ifTrue:[
"/            nBytes >= (1000 * 1024 * 1024 * 1024 * 1024 * 1024) ifTrue:[
"/                n := (nBytes / (1024 * 1024) / (1024 * 1024) / (1024 * 1024)) asFixedPoint:1.
"/                unitString := ' E'
"/            ] ifFalse:[
"/                n := (nBytes / (1024 * 1024) / (1024 * 1024) / 1024) asFixedPoint:1.
"/                unitString := ' P'
"/            ]
"/        ] ifFalse:[
"/            n := (nBytes / (1024 * 1024) / (1024 * 1024)) asFixedPoint:1.
"/            unitString := ' T'
"/        ].
"/    ].
"/
"/"/    n truncated = n ifTrue:[
"/"/        n := n truncated
"/"/    ].
"/    ^ n printString , unitString.

    "
     self fileSizeStringFor:nil          
     self fileSizeStringFor:10          
     self fileSizeStringFor:100            
     self fileSizeStringFor:1000            
     self fileSizeStringFor:8192            
     self fileSizeStringFor:10000          
     self fileSizeStringFor:100000          
     self fileSizeStringFor:1000000        
     self fileSizeStringFor:10000000       
     self fileSizeStringFor:100000000      
     self fileSizeStringFor:1000000000      
     self fileSizeStringFor:10000000000      
     self fileSizeStringFor:100000000000      
     self fileSizeStringFor:1000000000000      
     self fileSizeStringFor:10000000000000      
     self fileSizeStringFor:10000000000000000      
     self fileSizeStringFor:100000000000000000000      
     self fileSizeStringFor:1000000000000000000000      
    "

    "Modified: / 17-12-2013 / 16:55:17 / cg"
    "Modified (comment): / 18-12-2014 / 09:54:33 / sr"
!

frequencyFromString:frequencyString
    "given a frequency string (i.e. a number followed by optional kHz, Mhz or Hhz as required.
     Provided here since this is so common..."

    |numericValue s scaleChar scale rest|

    frequencyString isEmpty ifTrue:[
        ^ 0
    ].

    scale := 1.
    s := frequencyString readStream.
    numericValue := Number readFrom:s onError:[0].
    s skipSeparators.
    s atEnd ifFalse:[
        scaleChar := s next asLowercase.
        scaleChar == $/ ifTrue:[
            rest := s upToSeparator asLowercase.
            (rest = 'm' or:[rest = 'min']) ifTrue:[
                scale := 1/60
            ] ifFalse:[
                (rest = 'h' or:[rest = 'hr' or:[rest = 'hour']]) ifTrue:[
                    scale := 1/60/60
                ] ifFalse:[
                    (rest = 'd' or:[rest = 'dy' or:[rest = 'day']]) ifTrue:[
                        scale := 1/60/60/24 
                    ].
                ].
            ].
        ] ifFalse:[
            scaleChar == $k ifTrue:[
                scale := 1000
            ] ifFalse:[
                scaleChar == $m ifTrue:[
                    scale := 1000 * 1000
                ] ifFalse:[
                    scaleChar == $g ifTrue:[
                        scale := 1000 * 1000 * 1000
                    ] ifFalse:[
                        scaleChar == $t ifTrue:[
                            scale := 1000 * 1000 * 1000 * 1000
                        ]
                    ]
                ]
            ].
        ]
    ].
    ^ (numericValue*scale)

    "
     self frequencyFromString:'1234'          
     self frequencyFromString:'10 kHz'            
     self frequencyFromString:'0.6 k'            
     self frequencyFromString:'1.8 Mhz'            
     self frequencyFromString:'0.5 Ghz'            
     self frequencyFromString:'0.5 Thz'            
     self frequencyFromString:'1000/s'            
     self frequencyFromString:'10/s'            
     self frequencyFromString:'10/min'            
     self frequencyFromString:'10/hr'            
    "
!

frequencyStringFor:hertz
    "return a useful string for a frequency; 
     Scales by K (*1000), M (*1000*1000) or G (*1000*1000*1000) or even T
     as required and useful.
     Provided here since this is so common..."

    ^ self 
        unitStringFor:hertz 
        scale:1000 
        rounded:false
        unitStrings:#('Hz' 'Khz' 'Mhz' 'Ghz' 'Thz' 'Phz' 'Ehz')           

    "
     self frequencyStringFor:0.1          
     self frequencyStringFor:10          
     self frequencyStringFor:100            
     self frequencyStringFor:1000            
     self frequencyStringFor:8192            
     self frequencyStringFor:10000          
     self frequencyStringFor:100000          
     self frequencyStringFor:1000000        
     self frequencyStringFor:10000000       
     self frequencyStringFor:100000000      
     self frequencyStringFor:1000000000      
     self frequencyStringFor:10000000000      
     self frequencyStringFor:100000000000      
     self frequencyStringFor:1000000000000      
     self frequencyStringFor:10000000000000      
    "
!

inchToMillimeter:inches
    "convert inches to mm. Made this an extra method, since its so common."

    ^ inches * 25.4

    "Created: 31.5.1996 / 13:37:31 / cg"
    "Modified: 31.5.1996 / 18:08:14 / cg"
!

millimeterToInch:mm
    "convert mm to inches. Made this an extra method, since its so common."

    ^ mm / 25.4

    "Created: 31.5.1996 / 13:37:48 / cg"
    "Modified: 31.5.1996 / 18:08:20 / cg"
!

unitStringFor:nBytes scale:k rounded:rounded unitStrings:unitStrings
    "common helper for SI (1000-based) and binary (1024-based) human readable string generators.
     Notice that both forms are often encountered and useful.
     If rounded is true, round to nearest integer"

    |n kN idx val unitString|

    nBytes isNil ifTrue:[
        ^ '-'
    ].

    idx := 1.
    n := nBytes.
    kN := 1.
    [ (idx < unitStrings size) and:[  nBytes >= (kN * k) ] ] whileTrue:[
        idx := idx + 1.
        kN := kN * k.
    ].

    val := nBytes / kN.
    unitString := ' ',(unitStrings at:idx).

    ((rounded and:[val > 20]) or:[val isInteger]) ifTrue:[
        ^ (val rounded) printString , unitString
    ].
    ^ (val asFixedPoint:1) printString , unitString

    "
     self fileSizeStringFor:nil          
     self fileSizeStringFor:10          
     self fileSizeStringFor:100            
     self fileSizeStringFor:900            
     self fileSizeStringFor:1100            
     self fileSizeStringFor:1400            
     self fileSizeStringFor:1499            
     self fileSizeStringFor:1500            

     self fileSizeStringFor:1000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )           
     self fileSizeStringFor:8192 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )           
     self fileSizeStringFor:10000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )          
     self fileSizeStringFor:100000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )          
     self fileSizeStringFor:1000000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )        
     self fileSizeStringFor:10000000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )       
     self fileSizeStringFor:100000000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )      
     self fileSizeStringFor:1000000000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )      
     self fileSizeStringFor:10000000000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )      
     self fileSizeStringFor:100000000000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )      
     self fileSizeStringFor:1000000000000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )      
     self fileSizeStringFor:10000000000000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )      
     self fileSizeStringFor:10000000000000000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )      
     self fileSizeStringFor:100000000000000000000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )      
     self fileSizeStringFor:1000000000000000000000 scale:1000 unitStrings:#('' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' )      

     self fileSizeStringFor:8192 scale:1024 unitStrings:#('' 'KiB' 'MiB' 'GiB' 'TiB' 'PiB' 'EiB' )           
     self fileSizeStringFor:81920000 scale:1024 unitStrings:#('' 'KiB' 'MiB' 'GiB' 'TiB' 'PiB' 'EiB' )           
    "

    "Modified: / 17-12-2013 / 16:55:17 / cg"
    "Modified (comment): / 18-12-2014 / 09:54:33 / sr"
! !

!UnitConverter class methodsFor:'missing conversion'!

noConversionFrom:sourceUnit to:destUnit
    Transcript showCR:'no conversion ' , sourceUnit printString , ' -> ' , destUnit printString.
    ^ nil

    "Created: 29.3.1997 / 17:56:03 / cg"
! !

!UnitConverter class methodsFor:'private'!

addConversion:factor from:sourceMetric to:destMetric
    "add a conversion"

    |conversion|

    conversion := Conversions at:sourceMetric ifAbsent:nil.
    conversion isNil ifTrue:[
	conversion := IdentityDictionary new.
	Conversions at:sourceMetric put:conversion
    ].
    conversion at:destMetric put:factor.
    ^ conversion

    "Created: 31.5.1996 / 13:51:25 / cg"
    "Modified: 29.3.1997 / 17:19:31 / cg"
!

convertDirect:howMany from:sourceMetric to:destMetric
    "given a value in sourceMetric (symbolic), try to convert it
     to destMetric (symbolic); 
     Only direct conversions are tried; return nil, if the conversion is unknown."

    |conversion factor|

    Conversions isNil ifTrue:[
	self initializeConversions
    ].

    conversion := Conversions at:sourceMetric ifAbsent:nil.
    conversion isNil ifTrue:[^ nil].

    factor := conversion at:destMetric ifAbsent:nil.
    factor isNil ifTrue:[^ nil].

    factor isNumber ifTrue:[
	^ howMany * factor
    ].
    ^ factor value:howMany

    "
     UnitConverter convertDirect:1 from:#inch to:#meter 
     UnitConverter convertDirect:1 from:#inch to:#millimeter 
     UnitConverter convertDirect:1 from:#degrees to:#fahrenheit 
    "

    "Created: 31.5.1996 / 13:54:33 / cg"
    "Modified: 22.7.1997 / 13:57:52 / cg"
!

unscaled:what
    "given a unit, return the base and a factor as assoc,
     or nil if not found"

    Conversions isNil ifTrue:[
        self initializeConversions
    ].

    Scaling keysAndValuesDo:[:name :factor |
        |rest|

        (what startsWith:name) ifTrue:[
            rest := what withoutPrefix:name.
            rest := rest asSymbolIfInterned.
            rest notNil ifTrue:[
                ^ rest -> factor.
            ]        
        ].
    ].
    ^ nil

    "
     UnitConverter unscaled:#millimeter
     UnitConverter unscaled:#nanometer 
     UnitConverter unscaled:#kilometer   
     UnitConverter unscaled:#fuzzymeter   
    "

    "Modified: 22.7.1997 / 13:57:46 / cg"
! !

!UnitConverter class methodsFor:'queries'!

isUtilityClass
    ^ self == UnitConverter
! !

!UnitConverter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

