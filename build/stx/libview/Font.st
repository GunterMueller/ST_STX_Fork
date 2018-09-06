"
 COPYRIGHT (c) 1992 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

FontDescription subclass:#Font
	instanceVariableNames:'device fontId replacementFont ascent descent width isFixedWidth
		minWidth maxWidth maxAscent maxDescent minCode maxCode direction'
	classVariableNames:'Replacements'
	poolDictionaries:''
	category:'Graphics-Support'
!

Object subclass:#DeviceFontHandle
	instanceVariableNames:'device fontId'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Font
!

!Font class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    Font represents fonts in a device independent manner; after being
    created using 'Font family:family face:face style:style size:size',
    the returned font is not associated to a specific device.
    (therefore, those fonts can be used to draw on any GC)

    To get a device font, any font can be sent the message
    'aFont onDevice:aDevice' which returns an instance of Font which is
    associated to a device (it returns the receiver, if that is already
    associated to that device).

    For proper operation, each graphics operation working with fonts
    must get a device font before doing the draw.
    Most draw methods in DeviceDrawable do that automatically for you,
    before doing the draw; so you do not have to care.

    However, some operations require explicit conversion to a device font
    before being allowed. For example, a query for a font's height (in device
    units) can only be done if the font being asked is associated to
    a device (which should be clear, since a 'courier-roman-12' font may
    have a different number of pixels on a 75dpi vs. a 120dpi display. And
    a totally different number of device units on a 600dpi laser printer.
    Thus, to query a font for its height (or ascent, or descent, or width),
    use something like:

        myFont := Font family:'courier' ... size:12.
            ...

        'want to know its height on the Display'

        h := (myFont on:Display) height.

        'want to know its height on a printer'

        h := (myFont on:aPrinter) height.

    there are alternative shortcuts for these operations:

        h := myFont heightOn:Display.
        h := myFont heightOn:Printer.

        or:

        a := myFont ascentOn:Display.

    Keep in mind, that each device is free to think in whatever units it
    likes - a display may return units of pixels, a postscript printer may
    think in (fractions of) inches, a dot matrix printer may think in dots.
    Also, notice that currently only graphic displays are really supported;
    printer devices are being developed and may or may not be in the current
    system.

    If a font cannot be represented on a device, a replacement
    font is chosen and kept in the replacementFont instance variable.
    This is done to preserve the original font information, in case the image
    is restarted later on another display which has that font available.


    [Instance variables:]

      family          <String>        the font's family ('courier', 'helvetica' etc)
      face            <String>        the font's face ('bold', 'medium' etc)
      style           <String>        the font's style ('roman', 'italic', 'oblique')
      size            <String>        the font's size (not in pixels)
      encoding        <Symbol>        the font's encoding (usually #iso8859)

      device          <Object>        the device the font is associated to, or nil
      fontId          <Object>        the id of the font on that device, or nil
      replacement     <Font>          the replacement font or nil

      ascent          <Integer>       the font's ascent in device units on device
      descent         <Integer>       the font's descent in device units on device
      width           <Integer>       the character width in device units on device
                                      (for variable fonts, its the width of a space)
      isFixedWidth    <Boolean>       true if font is a fixed width font
      minWidth        <Integer>       width of the smallest-width character in
                                      in device units on device
      maxWidth        <Integer>       width of the largest-width character in
                                      in device units on device

    [class variables:]

      Replacements    <Dictionary>    replacement fonts

    [see also:]
        DeviceWorkstation
        DeviceDrawable GraphicsContext
        Cursor Color
        ( introduction to view programming :html: programming/viewintro.html#FONTS )

    [author:]
        Claus Gittinger
"
!

examples
"
    standard fonts:

        Font family:'courier' size:12

        Font 
             family:'helvetica' 
             face:'roman' 
             style:'bold' 
             size:16

        Font 
             family:'helvetica' 
             pixelSize:20


    special (non-portable displayType specific) fonts (typically: old X11 fonts):

        Font name:'6x10'

        Font name:'k14'


    setting the font of a button:
                                                                        [exBegin]
        |b|

        b := Button new.
        b label:'hello'.
        b font:(Font family:'helvetica' 
                     face:'medium' 
                     style:'roman' 
                     size:16).
        b open
                                                                        [exEnd]

    asking a font about a strings size in pixels, 
    if it was used on some device:

        aFont widthOf:'hello' on:Display


    asking about the ascent, if used on some device:

        aFont ascentOn:Display


    if the font has been associated to a device, the following are 
    a bit faster:

        |aFont|

        ...

        aFont := aFont onDevice:aDevice.
        ...
        aFont widthOf:'hello'
        ...
        aFont ascent
        ...
"
! !

!Font class methodsFor:'initialization'!

initialize
    "initialize the font tracking array"

    Replacements isNil ifTrue:[
        Replacements := Dictionary new.

        Replacements 
            at:'serif'                  put:#('times' 'times new roman' 'palatino' 'bookman');
            at:'sans-serif'             put:#('arial' 'lucida' 'helvetica');
            at:'monospace'              put:#('courier new' 'courier' 'andale mono' 'lucidatypewriter' 'fixed').

        Replacements 
            at:'clean'                  put:#('courier new' 'courier');
            at:'fixed'                  put:#('courier new' 'courier');
            at:'new century schoolbook' put:#('times' 'times new roman');
            at:'arial'                  put:#('helvetica' 'lucida');
            at:'lucida'                 put:#('arial' 'helvetica');
            at:'lucidabright'           put:#('arial' 'helvetica');
            at:'lucidatypewriter'       put:#('courier' 'courier new');
            at:'courier'                put:#('courier new');
            at:'courier new'            put:#('courier');
            at:'charter'                put:#('times' 'times new roman');
            at:'times new roman'        put:#('times');
            at:'times'                  put:#('times new roman');
            at:'terminal'               put:#('courier' 'courier new');
            at:'helvetica'              put:#('arial' 'lucida').
    ].
! !

!Font class methodsFor:'instance creation'!

family:familyString face:faceString style:styleString size:sizeArgOrNil sizeUnit:sizeUnitArg encoding:encodingSym
    "returns a font for given family, face, style, size and encoding. 
     The returned font is not associated to a specific device."

    |family newFont|

    (familyString at:1) isUppercase ifTrue:[
        family := familyString asLowercase
    ] ifFalse:[
        family := familyString
    ].

    newFont := self basicNew 
                    setFamily:familyString
                    face:faceString
                    style:styleString
                    size:sizeArgOrNil
                    sizeUnit:sizeUnitArg
                    encoding:encodingSym
                    device:nil.

"/    "look if this font is already known on the default device (the most common case)"
"/ don't do this!!
"/ is incompatible with Xft fonts. If reenabled, check printing in document viewer with XFT fonts enabled.
"/
"/    Display notNil ifTrue:[
"/        Display deviceFonts do:[:aFont |
"/            (newFont sameDeviceFontAs:aFont) ifTrue:[
"/                "/ self assert:(aFont encoding = newFont encoding).
"/                ^ aFont
"/            ]
"/        ]
"/    ].

    ^ newFont

    "Modified: / 26.9.1999 / 13:49:45 / cg"
! !

!Font methodsFor:'accessing'!

device
    "return the device I am on.
     Obsolete - use #graphicsDevice"

    <resource:#obsolete>
    self obsoleteMethodWarning:'use #graphicsDevice (2013-07-25)'.
    ^ device
!

fontId
    "return the device-dependent font-id"

    replacementFont notNil ifTrue:[
        ^ replacementFont fontId
    ].
    ^ fontId
!

graphicsDevice
    "same as #device, for ST-80 compatibility naming.
     Return the device I am associated with."

    ^ device

    "Created: 28.5.1996 / 18:39:53 / cg"
! !


!Font methodsFor:'converting'!

asFontDescription
    ^ FontDescription 
        family:family
        face:face
        style:style
        size:size
        sizeUnit:(sizeUnit ? #pt)
        encoding:encoding
! !

!Font methodsFor:'copying'!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    ^ self
! !

!Font methodsFor:'displaying'!

displayString:aString from:index1 to:index2 x:x y:y in:aGC opaque:opaque
    "this is only called for fonts which have a nil fontId,
     and therefore use the replacementFont. Should never be called
     for non-replacement fonts."

    |prevFont|

    prevFont := aGC font.
    replacementFont isNil ifTrue:[
        fontId notNil ifTrue:[
            aGC basicFont:self.
            aGC displayString:aString from:index1 to:index2 x:x y:y opaque:opaque.
        ] ifFalse:[
            'Font: [warning]: no replacementFont. should not happen' errorPrintCR.
        ].
    ] ifFalse:[
        aGC basicFont:replacementFont.
        aGC displayString:aString from:index1 to:index2 x:x y:y opaque:opaque.
    ].
    aGC basicFont:prevFont.

    "Modified: 10.1.1997 / 17:51:17 / cg"
!

displayString:aString from:index1 to:index2 x:x y:y in:aGC opaque:opaque maxWidth:maxWindowWidth
    "this is only called for fonts which have a nil fontId,
     and therefore use the replacementFont. Should never be called
     for non-replacement fonts."

    |prevFont|

    prevFont := aGC font.
    replacementFont isNil ifTrue:[
        fontId notNil ifTrue:[
            aGC basicFont:self.
            aGC displayString:aString from:index1 to:index2 x:x y:y opaque:opaque maxWidth:maxWindowWidth.
        ] ifFalse:[
            'Font: [warning]: no replacementFont. should not happen' errorPrintCR.
        ].
    ] ifFalse:[
        aGC basicFont:replacementFont.
        aGC displayString:aString from:index1 to:index2 x:x y:y opaque:opaque maxWidth:maxWindowWidth.
    ].
    aGC basicFont:prevFont.

    "Modified: 10.1.1997 / 17:51:17 / cg"
! !

!Font methodsFor:'getting a device font'!

onDevice:aDevice
    "create a new Font representing the same font as
     myself on aDevice; if one already exists, return the one."

    |newFont rep|

    "if I am already assigned to that device ..."
    (device == aDevice) ifTrue:[^ self].

    (aDevice isNil and:[device notNil]) ifTrue:[
        ^ self
    ].

    aDevice deviceFonts do:[:aFont |
        (self sameDeviceFontAs:aFont) ifTrue:[
            ^ aFont
        ].
    ].

    newFont := self onDevice:aDevice ifAbsent:nil.
    newFont isNil ifTrue:[
        "oops did not work - (device has no such font)"
        aDevice isOpen ifFalse:[
            "/ the display device is not connected
            "/ (or has a broken connection).
            aDevice class drawingOnClosedDeviceSignal raiseRequestWith:aDevice.
            ^ self.
        ].

        "/ look for a replacement font
        rep := self replacementFontOnDevice:aDevice.
        device isNil ifTrue:[
            device := aDevice.
            replacementFont := rep.
            newFont := self.
        ] ifFalse:[
            newFont := self class basicNew.
            newFont
                setFamily:family 
                face:face 
                style:style 
                size:(sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size]) 
                sizeUnit:sizeUnit 
                encoding:encoding 
                device:aDevice;
                isGenericFont:self isGenericFont;
                setReplacementFont:rep.
        ].
        aDevice registerFont:newFont.
    ].

    ^ newFont

    "
     (Font family:'fooXXXXXX' size:17) onDevice:Screen current
    "

    "Modified: 14.4.1997 / 18:22:31 / cg"
!

onDevice:aDevice xFontsOnly:xFontsOnly xftFontsOnly:xftFontsOnly ifAbsent:exceptionBlock 
    "create a new Font representing the same font as myself on aDevice. 
     The xFontsOnly/xftFontsOnly are only relevant for XWindow devices;
     xFontsOnly will suppress xft fonts, whereas xftFontsOnly will suppress x fonts
     (the first is useful if ST/X has a slow remote X connection for display,
      on which xft fonts are very slow. Yes, this is actually a reasonable setup
      in use at one of our customers)
     This does NOT try to look for existing
     or replacement fonts (i.e. can be used to get physical fonts)."

    |id xftFont|

    "receiver was not associated - do it now"
    device isNil ifTrue:[
        aDevice supportsXftFonts ifTrue:[
            xFontsOnly ifFalse:[
                xftFont := (XftFontDescription for:self) onDevice:aDevice ifAbsent:[nil].
                xftFont notNil ifTrue:[^ xftFont].
                xftFontsOnly ifTrue:[^ nil].
            ].    
        ].    
        
        "ask that device for the font"
        id := aDevice 
                getFontWithFamily:family 
                face:face 
                style:style 
                size:(sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size])  
                sizeUnit:sizeUnit  
                encoding:encoding ? '*'.
        id isNil ifTrue:[
            "oops did not work - (device has no such font)"

            ^ exceptionBlock value
        ].

        device := aDevice.
        fontId := id.

        self getFontInfos.
        aDevice registerFont:self.
        ^ self
    ].

    "receiver was already associated to another device - need a new font"
    ^ super 
        onDevice:aDevice 
        xFontsOnly:xFontsOnly xftFontsOnly:xftFontsOnly 
        ifAbsent:exceptionBlock

    "Modified: / 24-11-2016 / 16:53:36 / cg"
!

replacementFontOnDevice:aDevice
    "return a replacement font for the receiver - this is needed, if
     an image is restored on another type of display, or one which has
     a different set of fonts."

    |id f trySize alternatives alternateFamilyName useEncoding|

    "try font with smaller size - 
     but do not try this on scaled fonts (they have size == 0)"

    useEncoding := encoding ? #'iso10646-1'.
    alternateFamilyName := family.
    self isGenericFont ifFalse:[
        trySize := (sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size]) ? 0.
        [id isNil and:[trySize := trySize - 1. trySize > 4]] whileTrue:[
            id := aDevice 
                    getFontWithFamily:family
                    face:face
                    style:style 
                    size:trySize  
                    sizeUnit:sizeUnit  
                    encoding:useEncoding.
        ].
    ].

    id notNil ifTrue:[
        ('Font [info]: use alternative size ', trySize printString, ' for ' , (self userFriendlyName)) infoPrintCR.
    ] ifFalse:[
        alternatives := Replacements at:family asLowercase ifAbsent:nil.
        alternatives notNil ifTrue:[
            alternatives detect:[:eachAlternateFamilyName|
                trySize := (sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size]) ? 0.
                [
                    id := aDevice 
                            getFontWithFamily:eachAlternateFamilyName
                            face:face
                            style:style 
                            size:trySize  
                            sizeUnit:sizeUnit  
                            encoding:useEncoding.
                ] doWhile:[id isNil and:[trySize := trySize - 1. trySize > 4. false]].
                alternateFamilyName := eachAlternateFamilyName.
                id notNil.
            ] ifNone:[].
        ].
        id notNil ifTrue:[
            ('Font [info]: use alternative: ', alternateFamilyName , ' for: ' , (self userFriendlyName)) infoPrintCR.
        ] ifFalse:[
            useEncoding = #'iso10646-1' ifTrue:[
                "/ try latin1 (for osx-X11)
                id := aDevice 
                        getFontWithFamily:family
                        face:face
                        style:style 
                        size:(sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size ? 0])  
                        sizeUnit:sizeUnit  
                        encoding:#'iso8859-1'.
                id notNil ifTrue:[
                    ('Font [info]: use latin1 encoding for: ' , (self userFriendlyName)) infoPrintCR.
                ].
            ].
            id isNil ifTrue:[
                id := aDevice getDefaultFontWithEncoding:useEncoding.
                ('Font [info]: use default for ' , (self userFriendlyName)) infoPrintCR.
            ].
        ].
        id isNil ifTrue:[
            "oops did not work - this is a serious an error"
            self error:'cannot get default font' mayProceed:true.
            ^ nil
        ].
    ].

    "/ if there already is a device font for that replacement, return that one
    "/ to avoid allocating multiple replacements for the same font
    aDevice deviceFonts do:[:eachDeviceFont |
        (self sameDeviceFontAs:eachDeviceFont) ifTrue:[
            ^ eachDeviceFont
        ]
    ].

    f := self class basicNew.
    f 
        setFamily:alternateFamilyName face:face style:style size:trySize sizeUnit:sizeUnit encoding:useEncoding device:aDevice;
        setDevice:aDevice fontId:id;
        getFontInfos.

    aDevice registerFont:f.
    ^ f

    "Modified: 10.1.1997 / 15:40:21 / cg"
! !

!Font methodsFor:'instance release'!

executor
    "redefined to return a lightweight copy 
     - all we need is the device handle"

    ^ DeviceFontHandle basicNew setDevice:device fontId:fontId.

    "Modified: / 20.4.1996 / 23:23:04 / cg"
    "Modified: / 3.2.1999 / 16:13:10 / stefan"
! !

!Font methodsFor:'object persistency'!

elementDescriptorFor:aspect
    "support for persistency:
     answer the elements to be made persistent with an ObjectCoder"

    "binary storage encoding vector"

    ^ Array 
        with:(#family->self family) 
        with:(#face->self face) 
        with:(#style->self style) 
        with:(#size->self size)
        with:(#encoding->self encoding)
! !

!Font methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back.
     Redefined to print more about the font's name"

    face isNil ifTrue:[
        family isNil ifTrue:[
            aStream nextPutAll:('a replacement-Font').
            ^ self
        ].
        aStream nextPutAll:('a ' , family , '-Font').
        ^ self.
    ].
    aStream nextPutAll:('a ' , family , '-' , 
                               face , '-' , 
                               style printString , '-' , 
                               size printString , 
                               ' (' , encoding printString , ')' ,
                               '-Font')

    "Modified: 20.4.1996 / 23:25:11 / cg"
!

storeOn:aStream
    "append a character sequence to the argument, aStream from which the
     receiver can be reconstructed using readFrom:."

    aStream nextPutAll:'(Font family:'. family storeOn:aStream.
    aStream nextPutAll:' face:'.        face storeOn:aStream.
    aStream nextPutAll:' style:'.       style storeOn:aStream.
    aStream nextPutAll:' size:'.        size storeOn:aStream.
    aStream nextPutAll:' encoding:'.    encoding storeOn:aStream.
    aStream nextPut:$)

    "
     (Font family:'helvetica' size:10) storeString
    "
! !

!Font methodsFor:'private'!

getFontInfos
    "ask the device about all of my actual attributes"

    |info fetchedEncoding|

    replacementFont notNil ifTrue:[
        replacementFont getFontInfos.
        ^ self
    ].

    info := self getFontMetrics.

    minCode := info minCode.
    maxCode := info maxCode.
    direction := info direction.

    fetchedEncoding := info encoding.
    fetchedEncoding isNil ifTrue:[
        fetchedEncoding := device encodingOf:fontId.
    ].

    encoding notNil ifTrue:[
        (encoding ~= fetchedEncoding) ifTrue:[
            (( #( #'iso10646-1' #'ms-default' #'ms-ansi' #'ms-oem' ) includes:encoding)
            and:[ ( #( #'iso10646-1' #'ms-default' #'ms-ansi' #'ms-oem' ) includes:fetchedEncoding)]) ifFalse:[
                encoding ~= #* ifTrue:[
                    ('Font [warning]: encoding for "%1" should be %2; is %3 '
                        bindWith:self with: encoding with: fetchedEncoding) infoPrintCR.
                ].
            ].
        ].
    ] ifFalse:[
        encoding := fetchedEncoding.
    ].
    ascent := info ascent.
    descent := info descent.
    maxAscent := info maxAscent.
    maxDescent := info maxDescent.
    minWidth := info minWidth.
    maxWidth := info maxWidth.
    width := info averageWidth.

    width < minWidth ifTrue:[
        "/ some systems/fonts return a wrong value (0) as width of a space
        "/ - at least with X11 ...
        width := minWidth
    ].
    isFixedWidth := minWidth == maxWidth.

    "/ a temporary hack for the vista-cleartype font redraw problem
    false "isFixedWidth" ifFalse:[
        UserPreferences current workAroundRenderingBugOnVista ifTrue:[
            self hasOverlappingCharacters:true.
        ]
    ].
    "Modified: / 09-11-2010 / 12:58:56 / cg"
!

getFontMetrics
    "ask the device about all of my actual attributes"

    |metrics|

    replacementFont notNil ifTrue:[
        ^ replacementFont getFontMetrics
    ].

    metrics := device fontMetricsOf:fontId.

    "the MS TrueType unicode core fonts in Linux have way to large ascent
     and descent values, so the line spacing is too wide.
     Take them from the latin-1 equivalent"
    (device platformName == #X11
     and:[encoding = #'iso10646-1'
     and:[metrics ascent = metrics maxAscent 
     and:[metrics descent == metrics maxDescent]]]) ifTrue:[
        |latinFont latinMetrics|

        latinFont := self asEncoding:'iso8859-1'.
        latinFont notNil ifTrue:[
            latinMetrics := latinFont getFontMetrics.
            metrics ascent:latinMetrics ascent descent:latinMetrics descent.
        ].
    ].

    ^ metrics.

    "
         (View defaultFont onDevice:Screen current) getFontMetrics
     "
!

getFontResolution
    "ask the device about all of my actual attributes"

    |f|

    f := fontId.
    replacementFont notNil ifTrue:[
        f := replacementFont fontId.
    ].

    ^ device fontResolutionOf:f.
!

installInDeviceForGCId:aGCId
    "install the font for aGCId"

    (device isNil or:[fontId isNil]) ifTrue:[
        "this should not happen, since #onDevice tries replacement fonts"
        Logger error:'no device font for: %1' with:self.
        ^ nil.
    ].
    device setFont:fontId in:aGCId.
!

releaseFromDevice
    "I am no longer available on the device"

    device := nil.
    fontId := nil.
    replacementFont := nil

    "Modified: 20.4.1996 / 23:26:26 / cg"
!

restored
    "flush device handles when restored"

    device := nil.
    fontId := nil.
    replacementFont := nil

    "Modified: 20.4.1996 / 23:26:26 / cg"
!

setDevice:aDevice
    "set the device handle"

    device := aDevice

    "Modified: 20.4.1996 / 23:26:35 / cg"
!

setDevice:aDevice fontId:aFontId
    "set the device and font handles"

    device := aDevice.
    fontId := aFontId

    "Modified: 20.4.1996 / 23:26:43 / cg"
!

setFamily:familyString face:faceString style:styleString size:sizeNum encoding:encodingSym device:aDevice
    <resource: #obsolete>
    self obsoleteMethodWarning:'2013-07-25'.

    self 
        setFamily:familyString 
        face:faceString 
        style:styleString 
        size:sizeNum 
        sizeUnit:#pt
        encoding:encodingSym 
        device:aDevice
!

setFamily:familyString face:faceString style:styleString size:sizeArg sizeUnit:sizeUnitArg encoding:encodingSym device:aDevice
    "set my instance attributes"

    family := familyString.
    face := faceString.
    style := styleString.
    sizeUnit := (sizeUnitArg ? #pt).
    sizeUnit == #pt ifTrue:[ 
        size := sizeArg 
    ] ifFalse:[
        sizeUnit == #px ifTrue:[ 
            pixelSize := sizeArg 
        ] ifFalse:[
            self error:'invalid sizeUnit' mayProceed:true.
            size := 12.
            sizeUnit := #pt
        ].
    ].
    encoding := encodingSym.
    device := aDevice

    "Modified: 20.4.1996 / 23:26:56 / cg"
!

setFontId:aFontId
    "set my font handle"

    fontId := aFontId

    "Modified: 20.4.1996 / 23:27:05 / cg"
!

setReplacementFont:aFont
    "set my replacement font"

    replacementFont := aFont

    "Modified: 20.4.1996 / 23:27:16 / cg"
! !

!Font methodsFor:'queries-deviceFonts'!

fullName
    "return the full (device specific) name of the receiver.
     This is query only valid if the receiver is associated to a device"

    device isNil ifTrue:[
        ^ nil
    ].
    ^ device fullFontNameOf:fontId.

    "
     ((Font name:'6x10') on:Display) fullName  
    "

    "Modified: 30.4.1996 / 17:30:10 / cg"
!

isFixedWidth
    "return true, if all characters have same width (as in courier).
     The receiver must be associated to a device,
     for this query to be legal."

    device isNil ifTrue:[
	self errorNoDevice.
    ].
    replacementFont notNil ifTrue:[
	^ replacementFont isFixedWidth
    ].
    ^ isFixedWidth
!

maxWidth
    "return the width of the widest character;
     if the receiver is a fixed width font its the width of every character.
     The receiver must be associated to a device,
     for this query to be legal."

    device isNil ifTrue:[
	self errorNoDevice
    ].
    replacementFont notNil ifTrue:[
	^ replacementFont maxWidth
    ].
    ^ maxWidth
! !

!Font methodsFor:'queries-dimensions'!

ascent
    "return the font-ascent (i.e. the normal average of all characters);
     That is the number of units (usually pixels) above the baseline.
     The receiver must be associated to a device,
     for this query to be legal."

    device isNil ifTrue:[
	self errorNoDevice
    ].
    replacementFont notNil ifTrue:[
	^ replacementFont ascent
    ].
    ^ ascent
!

ascentOn:aDevice
    "return the font's ascent (average), if used on aDevice."

    replacementFont notNil ifTrue:[
        ^ replacementFont ascentOn:aDevice
    ].
    device == aDevice ifTrue:[
        ^ ascent
    ].
    ^ (self onDevice:aDevice) ascent

    "Created: / 30.4.1996 / 16:41:32 / cg"
    "Modified: / 10.9.1998 / 12:09:06 / cg"
!

descent
    "return the font-descent (i.e. the normal average of all characters);
     That is the number of units (usually pixels) below the baseline.
     The receiver must be associated to a device,
     for this query to be legal."

    device isNil ifTrue:[
	self errorNoDevice
    ].
    replacementFont notNil ifTrue:[
	^ replacementFont descent
    ].
    ^ descent
!

descentOn:aDevice
    "return the font's descent (average), if used on aDevice."

    replacementFont notNil ifTrue:[
        ^ replacementFont descentOn:aDevice
    ].
    device == aDevice ifTrue:[
        ^ descent
    ].
    ^ (self onDevice:aDevice) descent

    "Created: / 30.4.1996 / 16:41:43 / cg"
    "Modified: / 10.9.1998 / 12:09:30 / cg"
!

height
    "return the font's characters normal (average) height;
     That is the number of units (usually pixels) on the device.
     The receiver must be associated to a device,
     for this query to be legal."

    device isNil ifTrue:[
        self errorNoDevice.
    ].
    replacementFont notNil ifTrue:[
        ^ replacementFont height
    ].
    ^ descent + ascent.
!

heightOf:textOrString
    "return the height (device specific) of the argument;
     the argument must be a String.
     CAVEAT:
        currently only constant height fonts are supported."

    |sum|

    device isNil ifTrue:[
        self errorNoDevice.
        ^ 0
    ].
    replacementFont notNil ifTrue:[
        ^ replacementFont heightOf:textOrString
    ].
    device supportsVariableHeightFonts ifFalse:[
        ^ descent + ascent
    ].

    (textOrString isString) ifTrue:[
        ^ device heightOf:textOrString string inFont:fontId
    ].
    (textOrString isCharacter) ifTrue:[
        ^ device heightOf:textOrString asString inFont:fontId
    ].

    sum := 0.
    textOrString do:[:lineString |
        lineString isString ifTrue:[
            sum := sum + (device heightOf:lineString asString inFont:fontId).
        ]
    ].
    ^ sum

    "Created: 12.5.1996 / 11:05:00 / cg"
!

heightOf:aString on:aDevice
    "return the height of aString, if displayed on aDevice.
     The argument must be a string-like object."

    replacementFont notNil ifTrue:[
        ^ replacementFont heightOf:aString on:aDevice
    ].
    device == aDevice ifTrue:[
        ^ self heightOf:aString
    ].
    ^ (self onDevice:aDevice) heightOf:aString

    "Created: / 30.4.1996 / 17:14:18 / cg"
    "Modified: / 10.9.1998 / 12:09:47 / cg"
!

heightOn:aDevice
    "return the font's height (average), if used on aDevice."

    replacementFont notNil ifTrue:[
        ^ replacementFont heightOn:aDevice
    ].
    device == aDevice ifTrue:[
        ^ descent + ascent
    ].
    ^ (self onDevice:aDevice) height

    "Created: / 30.4.1996 / 16:41:59 / cg"
    "Modified: / 10.9.1998 / 12:08:18 / cg"
!

maxAscent
    "return the font's maximum-ascent (i.e. the maximum of all characters);
     That is the number of units (usually pixels) above the baseline.
     The receiver must be associated to a device,
     for this query to be legal."

    device isNil ifTrue:[
        self errorNoDevice
    ].
    replacementFont notNil ifTrue:[
        ^ replacementFont maxAscent
    ].
    ^ maxAscent
!

maxDescent
    "return the font-descent (i.e. the maximum of all characters);
     That is the number of units (usually pixels) below the baseline.
     The receiver must be associated to a device,
     for this query to be legal."

    device isNil ifTrue:[
	self errorNoDevice
    ].
    replacementFont notNil ifTrue:[
	^ replacementFont maxDescent
    ].
    ^ maxDescent
!

maxHeight
    "return the font's characters maximum height;
     That is the number of units (usually pixels) on the device.
     The receiver must be associated to a device,
     for this query to be legal."

    device isNil ifTrue:[
        self errorNoDevice.
    ].
    replacementFont notNil ifTrue:[
        ^ replacementFont maxHeight
    ].
    ^ maxDescent + maxAscent.
!

minWidth
    "return the width of the smallest character;
     if the receiver is a fixed width font its the width of every character.
     The receiver must be associated to a device,
     for this query to be legal."

    device isNil ifTrue:[
	self errorNoDevice
    ].
    replacementFont notNil ifTrue:[
	^ replacementFont minWidth
    ].
    ^ minWidth
!

width
    "return the font's characters width;
     That is the number of units (usually pixels) on the device.
     For variable pitch fonts, the width of the space character is returned.
     For fixed fonts, this is the same as minWidth or maxWidth (or any character).
     The receiver must be associated to a device, for this query to be legal."

    device isNil ifTrue:[
        self errorNoDevice.
    ].
    replacementFont notNil ifTrue:[
        ^ replacementFont width
    ].
    ^ width

    "Modified: 30.4.1996 / 16:43:45 / cg"
!

widthOf:textOrString
    "return the width (device specific) of the argument;
     the argument may be a Character, String or some Text;
     in the last case the width of the longest line in the text is returned.
     The receiver must be associated to a device,
     for this query to be legal."

    |this max string|

    device isNil ifTrue:[
        self errorNoDevice.
        ^ 0
    ].
    replacementFont notNil ifTrue:[
        ^ replacementFont widthOf:textOrString
    ].

    (textOrString isString) ifTrue:[
        string := textOrString string.
        isFixedWidth ifFalse:[
            ^ device widthOf:string inFont:fontId
        ].
        ^ width * string size
    ].
    (textOrString isCharacter) ifTrue:[
        isFixedWidth ifFalse:[
            ^ device widthOf:textOrString asString inFont:fontId
        ].
        ^ width
    ].

    max := 0.
    isFixedWidth ifFalse:[
        textOrString do:[:line |
            line notNil ifTrue:[
                this := device widthOf:line asString inFont:fontId.
                (this > max) ifTrue:[max := this]
            ]
        ].
        ^ max
    ].

    textOrString do:[:lineString |
        this := lineString size.
        (this > max) ifTrue:[max := this]
    ].
    ^ max * width

    "Modified: 22.10.1996 / 17:11:14 / cg"
!

widthOf:aString from:start to:stop
    "return the width of a substring.
     The receiver must be associated to a device,
     for this query to be legal."

    device isNil ifTrue:[
        self errorNoDevice.
        ^ 0
    ].
    replacementFont notNil ifTrue:[
        ^ replacementFont widthOf:aString from:start to:stop
    ].
    (stop < start) ifTrue:[^ 0].

    isFixedWidth ifFalse:[
        stop-start > 10000 ifTrue:[
            ^ (stop - start + 1) * width
        ].
        ^ device widthOf:aString from:start to:stop inFont:fontId
    ].
    ^ (stop - start + 1) * width
!

widthOf:aString from:startIndex to:endIndex on:aDevice
    "return the width of substring, if displayed on aDevice.
     The argument may be a Character, String or some Text;
     in the last case the width of the longest line in the text is returned."

    replacementFont notNil ifTrue:[
        ^ replacementFont widthOf:aString from:startIndex to:endIndex on:aDevice
    ].
    device == aDevice ifTrue:[
        ^ self widthOf:aString from:startIndex to:endIndex
    ].
    ^ (self onDevice:aDevice) widthOf:aString from:startIndex to:endIndex

    "Created: / 30.4.1996 / 17:15:20 / cg"
    "Modified: / 10.9.1998 / 12:10:11 / cg"
!

widthOf:aString on:aDevice
    "return the width of aString, if displayed on aDevice.
     The argument may be a Character, String or some Text;
     in the last case the width of the longest line in the text is returned."

    replacementFont notNil ifTrue:[
        ^ replacementFont widthOf:aString on:aDevice
    ].
    device == aDevice ifTrue:[
        ^ self widthOf:aString
    ].
    ^ (self onDevice:aDevice) widthOf:aString

    "Created: / 30.4.1996 / 17:14:18 / cg"
    "Modified: / 10.9.1998 / 12:10:26 / cg"
!

widthOn:aDevice
    "return the font's width, if used on aDevice.
     For variable pitch fonts, the width of the space character is returned.
     For fixed fonts, this is the same as minWidth or maxWidth (or any character)."

    replacementFont notNil ifTrue:[
        ^ replacementFont widthOn:aDevice
    ].
    device == aDevice ifTrue:[
        ^ self width
    ].
    ^ (self onDevice:aDevice) width

    "Created: / 30.4.1996 / 16:42:28 / cg"
    "Modified: / 10.9.1998 / 12:11:33 / cg"
! !

!Font methodsFor:'queries-misc'!

direction
    device isNil ifTrue:[
        self errorNoDevice
    ].
    replacementFont notNil ifTrue:[
        ^ replacementFont direction
    ].
    ^ direction
!

maxAscii
    "squeak compatibility"

    ^ self maxCode
!

maxCode
    device isNil ifTrue:[
        self errorNoDevice
    ].
    replacementFont notNil ifTrue:[
        ^ replacementFont maxCode
    ].
    ^ maxCode
!

minAscii
    "squeak compatibility"

    ^ self minCode
!

minCode 
    device isNil ifTrue:[
        self errorNoDevice
    ].
    replacementFont notNil ifTrue:[
        ^ replacementFont minCode
    ].
    ^ minCode
! !

!Font methodsFor:'st-80 queries'!

fixedWidth
    "return true, if this font is a fixed width font -
     for st-80 compatibility"

    ^ self isFixedWidth
!

pixelSize
    "return the height of the font in pixels -
     for st-80 compatibility"

    ^ pixelSize ? self height
! !

!Font methodsFor:'testing'!

isAlienFont
    "answer true, if this is an alien font which does not have a device representation"

    ^ false
! !

!Font::DeviceFontHandle class methodsFor:'documentation'!

documentation
"
    This is used as a finalization handle for fonts.

    [author:]
        Stefan Vogel (stefan@nilpferd)

    [see also:]
        Font

    [instance variables:]

    [class variables:]
"
! !

!Font::DeviceFontHandle methodsFor:'accessing'!

setDevice:aDevice fontId:anId
    "set the handles contents"

    device := aDevice.
    fontId := anId.

    "Created: / 3.2.1999 / 16:08:31 / stefan"
! !

!Font::DeviceFontHandle methodsFor:'finalization'!

finalize
    "some Font has been collected - tell it to the x-server"

    |id|

    (id := fontId) notNil ifTrue:[
        fontId := nil.
        device releaseFont:id.
    ]

    "Created: / 3.2.1999 / 16:09:25 / stefan"
! !

!Font class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Font initialize!
