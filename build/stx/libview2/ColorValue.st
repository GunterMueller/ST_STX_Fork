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

Color subclass:#ColorValue
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!ColorValue class methodsFor:'documentation'!

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
    ColorValue is provided for ST-80 compatibility.
    read the section on compatibility issues in the Color class's documentation.

    [author:]
        Claus Gittinger
"
! !

!ColorValue class methodsFor:'instance creation'!

brightness:grey
    "return a grey color.
     The grey value is given in 0..1 instead of percent"

    ^ self scaledGray:(grey * MaxValue) rounded

    "
     ColorValue brightness:0.5
    "

    "Modified: 28.5.1996 / 20:53:52 / cg"
!

doesNotUnderstand:aMessage
    "catch other instance creation messages"

    |clr|

    (clr := self name:aMessage selector asString) notNil ifTrue:[
	^ clr
    ].
    ^ super doesNotUnderstand:aMessage

    "
     ColorValue royalBlue
     ColorValue funnyGreen
    "
!

hue:hue saturation:sat brightness:light 
    "return a color.
     The hue, saturation and brightness values are given in 0..1 instead of 
     degrees / percent"

    ^ self hue:hue*360 light:light*100 saturation:sat*100 

    "
     ColorValue hue:0 saturation:1 brightness:0.5 
    "
!

red:r green:g blue:b
    "return a color from red, green and blue values.
     The arguments, r, g and b must be in the range (0..1)"

    ^ super 
        scaledRed:(r * MaxValue) rounded
        scaledGreen:(g * MaxValue) rounded
        scaledBlue:(b * MaxValue) rounded

    "
     ColorValue red:0 green:1 blue:0
     ColorValue red:0 green:0.5 blue:0 
    "
!

scaledRed:r scaledGreen:g scaledBlue:b
    "return a color from scaled red, green and blue values.
     This rescales from ST80 scale-values (0..1FFF) to whatever our
     internal scale value is."

    ^ super 
        scaledRed:(r * MaxValue / 16r1FFF) rounded
        scaledGreen:(g * MaxValue / 16r1FFF) rounded
        scaledBlue:(b * MaxValue / 16r1FFF) rounded

    "
     ColorValue scaledRed:0 scaledGreen:16r0FFF scaledBlue:0
    "
! !

!ColorValue methodsFor:'accessing'!

blue
    "return the blue component in 0..1"

    ^ blue / MaxValue
!

green
    "return the green component in 0..1"

    ^ green / MaxValue
!

light
    "return the hue component in 0..1"

    ^ super light / 100.0

    "
     Color yellow light
     ColorValue yellow light
    "

    "Created: 11.6.1996 / 17:17:39 / cg"
!

red
    "return the red component in 0..1"

    ^ red / MaxValue
!

saturation
    "return the saturation component in 0..1"

    ^ super saturation / 100.0

    "
     Color yellow saturation     
     ColorValue yellow saturation  
    "

    "Created: 11.6.1996 / 17:17:57 / cg"
! !

!ColorValue methodsFor:'converting'!

fromLiteralArrayEncoding:encoding
    "read my values from an encoding.
     The encoding is supposed to be of the form: 
        (#ColorValue scaledRed scaledGreen scaledBlue)
     This is the reverse operation to #literalArrayEncoding."

    |clr|

    encoding size == 2 ifTrue:[
        clr := self class name:(encoding at:2).
        red := clr scaledRed.
        green := clr scaledGreen.
        blue := clr scaledBlue.
    ] ifFalse:[
"/        (encoding at:2) isSymbol ifTrue:[
"/            clr := ColorValue perform:(encoding at:2) withArguments:(encoding at:3).
"/            red := clr scaledRed.
"/            green := clr scaledGreen.
"/            blue := clr scaledBlue.
"/        ] ifFalse:[
            red := (encoding at:2).
            green := (encoding at:3).
            blue := (encoding at:4).
"/        ]
    ]

    "
      ColorValue new fromLiteralArrayEncoding:#(#Color 7700 7700 7700)
    "

    "Created: 22.1.1997 / 04:18:50 / cg"
    "Modified: 6.3.1997 / 15:45:01 / cg"
!

literalArrayEncoding
    "encode myself as an array, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray.
     The encoding is: 
        (#ColorValue scaledRed scaledGreen scaledBlue)
    "

    ^ Array
        with:self class name
        with:(self scaledRed)
        with:(self scaledGreen)
        with:(self scaledBlue)

    "
      ColorValue new fromLiteralArrayEncoding:#(#Color 50 25 25)
      (ColorValue red:0.5 green:0.25 blue:1.0) literalArrayEncoding 
    "

    "Modified: 22.1.1997 / 04:17:59 / cg"
! !

!ColorValue class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

