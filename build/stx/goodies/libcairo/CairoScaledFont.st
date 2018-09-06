"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Smalltalk }"

FontDescription subclass:#CairoScaledFont
	instanceVariableNames:'device scaledFont extents'
	classVariableNames:'Lobby'
	poolDictionaries:'Cairo::FontSlant Cairo::FontWeight Cairo::Format'
	category:'Cairo-Compatibility'
!


!CairoScaledFont class methodsFor:'instance creation'!

fromFontDescription: aFontDescription 
    ^ self fromFontDescription: aFontDescription  onDevice: Screen current

    "
    CairoScaledFont fromFontDescription: CodeView defaultFont.
    "

    "Created: / 17-02-2016 / 20:51:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromFontDescription: aFontDescription onDevice: aHostGraphicsDevice
    | font |

    aFontDescription class == self ifTrue:[ 
        ^ aFontDescription onDevice: aHostGraphicsDevice
    ].
    aHostGraphicsDevice deviceFonts do:[:registeredFont |
        ((registeredFont class == self) and:[registeredFont sameDeviceFontAs:aFontDescription]) ifTrue:[
            ^ registeredFont
        ].
    ].     
    font := self new.
    1 to: FontDescription instSize do:[:i | 
        font instVarAt: i put: (aFontDescription instVarAt: i)
    ].
    font setDevice: aHostGraphicsDevice scaledFont: (Cairo::ScaledFont fromFontDescription: font).  
    ^ font

    "Created: / 17-02-2016 / 20:51:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-02-2016 / 20:58:23 / jv"
    "Modified: / 29-02-2016 / 18:18:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoScaledFont methodsFor:'accessing'!

scaledFont
    ^ scaledFont

    "Created: / 17-02-2016 / 20:47:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoScaledFont methodsFor:'converting'!

onDevice: aDevice
    device == aDevice ifTrue:[ ^ self ].
    aDevice deviceFonts do:[:font |
        ((font class == self class) and:[self sameDeviceFontAs:font]) ifTrue:[
            ^ font
        ].
    ].   
    ^ self copy setDevice: aDevice scaledFont: (Cairo::ScaledFont fromFontDescription: self).

    "Created: / 16-02-2016 / 13:22:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-02-2016 / 14:44:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoScaledFont methodsFor:'displaying'!

displayString:aString from:index1 to:index2 x:x y:y in:aGC opaque:opaque
    "display a partial string at some position in aGC."
    | cr |

    cr := aGC cairo.
    self displayString:aString from:index1 to:index2 x:x y:y cr:cr fg: aGC paint bg: aGC backgroundPaint opaque:opaque.
    cr release.

    "Modified: / 24-02-2016 / 17:16:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoScaledFont methodsFor:'displaying-private'!

displayString:stringArg from:index1 to:index2 x:x y:y cr:cr fg: fg bg: bg opaque:opaque
    "Display a partial string at some position in Cairo contect `cr` using `fg` color. 
     If `opaque` is true, then draw text background using `bg` color."

    | string |

    (index1 == 1 and:[ index2 == stringArg size ]) ifTrue:[ 
        string := stringArg
    ] ifFalse:[ 
        string := stringArg copyFrom: index1 to: index2
    ].

    cr save.
    [ 
        | textents |

        textents := cr textExtents: string.
        cr rectangleX: x + textents xBearing ceiling y: y - self ascent ceiling  width: textents xAdvance ceiling height: self height ceiling.
        cr lineWidth: 0.

        opaque ifTrue:[ 
            cr source: bg.
            cr fill.
        ] ifFalse:[
            "/ I'm not sure why this is required but if not done,
            "/ selected text is not rendered correcrtly...
            cr stroke.
        ].
        cr source: fg.
        cr moveToX: x y: y.
        cr font: scaledFont.
        cr showText: string.
    ] ensure:[ 
        cr restore.
    ]

    "Created: / 24-02-2016 / 17:03:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoScaledFont methodsFor:'initialization'!

setDevice: aHostGraphicsDevice scaledFont: aScaledFont
    self assert: device isNil.
    self assert: scaledFont isNil.

    device := aHostGraphicsDevice.
    scaledFont := aScaledFont.
    device registerFont: self.

    "Created: / 17-02-2016 / 20:46:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-02-2016 / 17:59:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoScaledFont methodsFor:'queries-dimensions'!

ascent
    "return the ascent - the number of pixels above the baseLine."

    extents isNil ifTrue:[ extents := scaledFont extents ].    
    ^ extents ascent ceiling

    "Created: / 09-01-2015 / 15:33:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2016 / 21:53:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

descent
    "return the descent - the number of pixels below the baseLine."

    extents isNil ifTrue:[ extents := scaledFont extents ].
    ^ extents descent ceiling

    "Created: / 09-01-2015 / 15:33:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2016 / 21:54:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

height
    "return the height - the number of pixels above plus below the baseLine."

    extents isNil ifTrue:[ extents := scaledFont extents ].
    ^ extents height ceiling

    "Created: / 09-01-2015 / 15:33:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2016 / 21:54:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFixedWidth
    "return true, if this is a fixed pitch font (i.e. all characters
     are of the same width)"

    ^ false

    "Created: / 09-01-2015 / 15:35:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

maxAscent
    "return the fonts maximum-ascent (i.e. the maximum of all characters);
     That is the number of units (usually pixels) above the baseline."

    ^ self ascent

    "Created: / 09-01-2015 / 15:34:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

maxDescent
    "return the fonts maximum-descent (i.e. the maximum of all characters);
     That is the number of units (usually pixels) below the baseline."

    ^ self descent

    "Created: / 09-01-2015 / 15:34:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

maxWidth
    "return the fonts maximum-width character (i.e. the maximum of all characters);
     That is a number of units (usually pixels)."

    extents isNil ifTrue:[ extents := scaledFont extents ].
    ^ extents maxXAdvance ceiling

    "Created: / 09-01-2015 / 15:35:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2016 / 21:54:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

widthOf:aString from:start to:stop
    "return the width of a sub string"

    | str |

    (start == 1 and: [ stop == aString size ]) ifTrue:[ 
        str := aString
    ] ifFalse:[ 
        str := aString copyFrom: start to: stop.
    ].
    ^ (scaledFont textExtents: str) xAdvance ceiling

    "Created: / 09-01-2015 / 15:28:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2016 / 21:54:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoScaledFont class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

