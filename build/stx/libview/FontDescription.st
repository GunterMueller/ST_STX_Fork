"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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

Object subclass:#FontDescription
	instanceVariableNames:'family face style size encoding manufacturer name flags masks
		sizeUnit pixelSize weight slant'
	classVariableNames:'AntialiasedFlag BoldnessMask
		CharacterEncodingToCharacterSetMapping CharacterSetToFontMapping
		DecorativeFlag DefaultEncoding FixedFlag GenericFlag GenericFonts
		IsTrueTypeFlag ItalicFlag OutlineFlag OverlappingCharactersFlag
		ScalableFlag SerifFlag ShadowFlag StrikeoutFlag UnderlineFlag'
	poolDictionaries:''
	category:'Graphics-Support'
!

!FontDescription class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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
    FontDescription is just a place-holder for scanned font names.

    [Instance variables:]
        family          <String>        the font's family ('courier', 'helvetica' etc)
        face            <String>        the font's face ('bold', 'medium' etc)
        style           <String>        the font's style ('roman', 'italic', 'oblique')
        size            <String>        the font's size (by default, in points, not in pixels; but see sizeUnit) 
        encoding        <Symbol>        the font's encoding (usually #iso8859-1)

        manufacturer    <nil|String|Array>
                                        the font's origin - if known
        name            <nil|String|Array>
                                        the platform specific name

        flags           <SmallInteger>  holds serif/italic etc. as flag bits
        masks           <SmallInteger>  currently dummy; to allow ST-80 compatible subclassing
        pixelSize       <SmallInteger>  currently dummy; to allow ST-80 compatible subclassing
        sizeUnit        <Symbol>        #px or #pt; defines what size is measuring
        weight          <SmallInteger>  for real fonts, which support it
        slant           <SmallInteger>  for real fonts, which support it

    [class variables:]
        BoldnessMask                    currently dummy; to allow ST-80 compatible subclassing
        FixedFlag                       currently dummy; to allow ST-80 compatible subclassing
        ItalicFlag                      currently dummy; to allow ST-80 compatible subclassing
        OutlineFlag                     currently dummy; to allow ST-80 compatible subclassing
        SerifFlag                       currently dummy; to allow ST-80 compatible subclassing
        ShadowFlag                      currently dummy; to allow ST-80 compatible subclassing
        StrikeoutFlag                   currently dummy; to allow ST-80 compatible subclassing
        UnderlineFlag                   currently dummy; to allow ST-80 compatible subclassing

    [author:]
        Claus Gittinger

    [see also:]
        Font
        FontPanel
        GraphicsContext
        ( introduction to view programming :html: programming/viewintro.html#FONTS )
"
! !

!FontDescription class methodsFor:'initialization'!

initialize
    "initialize class variables"

    BoldnessMask              := 2r000000000000111.      "/ allows for 8 boldnesses to be encoded
    FixedFlag                 := 2r000000000001000.
    ItalicFlag                := 2r000000000010000.
    OutlineFlag               := 2r000000000100000.
    SerifFlag                 := 2r000000001000000.
    ShadowFlag                := 2r000000010000000.
    StrikeoutFlag             := 2r000000100000000.
    UnderlineFlag             := 2r000001000000000.
    GenericFlag               := 2r000010000000000.      "/ This is a pseudo font
    OverlappingCharactersFlag := 2r000100000000000.      "/ special for windows
    AntialiasedFlag           := 2r001000000000000.      "/ added for Xft
    ScalableFlag              := 2r010000000000000.      "/ added for Xft
    DecorativeFlag            := 2r100000000000000.      "/ added for Xft

    self initializeGenericFonts.
    self initializeCharacterEncodingToCharacterSetMapping.
    self initializeCharacterSetToFontMapping.

    "Modified: / 08-11-2010 / 13:12:08 / cg"
!

initializeCharacterEncodingToCharacterSetMapping
    "character encoding"

    CharacterEncodingToCharacterSetMapping isNil ifTrue:[
        CharacterEncodingToCharacterSetMapping := Dictionary withKeysAndValues:#(
            utf7        unicode
            #'utf-7'    unicode
            utf8        unicode
            #'utf-8'    unicode
            #utf16be    unicode
            #utf16le    unicode
        ).
    ].
!

initializeCharacterSetToFontMapping
    "character sets"

    CharacterSetToFontMapping isNil ifTrue:[
        CharacterSetToFontMapping := Dictionary withKeysAndValues: #(
            unicode        'iso10646-1'

            'koi8-r'       'iso8859-5'

            'iso2022-jp'   'jis*0208*'
            'x-iso2022-jp' 'jis*0208*'
            'x-euc-jp'     'jis*0208*'
            'x-shift-jis'  'jis*0208*'
            'x-sjis'       'jis*0208*'
            'x-jis7'       'jis*0208*'
            'jis7'         'jis*0208*'
            'euc'          'jis*0208*'
            'euc-jp'       'jis*0208*'
            'sjis'         'jis*0208*'

            'big5'         'big5*'

            'gb2312'       'gb*'
            'hz-gb-2312'   'gb*'
            'x-gbk'        'gb*'

            'iso2022-kr'   'ksc*'
            'x-euc-kr'     'ksc*'
        ).
    ].
!

initializeGenericFonts
    "generic fonts, that do not exist as a device font and are
     replaced by a real font"

    GenericFonts isNil ifTrue:[
        GenericFonts := OrderedCollection new.
        GenericFonts add:((self family:#serif face:nil style:nil size:0 sizeUnit:#pt encoding:nil) isGenericFont:true).
        GenericFonts add:((self family:#'sans-serif' face:nil style:nil size:0 sizeUnit:#pt encoding:nil) isGenericFont:true).
        GenericFonts add:((self family:#monospace face:nil style:nil size:0 sizeUnit:#pt encoding:nil) isGenericFont:true).
    ].
! !

!FontDescription class methodsFor:'instance creation'!

family:familyString
    "returns a font for given family and default (12pt) size 
     with default encoding.
     The new fonts face defaults `medium', its style to `roman'.
     The returned font is not associated to a specific device"

    ^ self 
        family:familyString
        face:(self defaultFace) 
        style:(self defaultStyle) 
        size:(self defaultSize) 
        sizeUnit:#pt
        encoding:(self defaultEncoding)

    "
     Font family:'helvetica'
     Font family:'courier'
    "

    "Modified: 30.4.1996 / 17:20:44 / cg"
!

family:familyString face:faceString size:sizeNum
    "returns a font for given family and size with default encoding.
     The new fonts style defaults to `roman'.
     The returned font is not associated to a specific device"

    ^ self 
        family:familyString
        face:faceString 
        style:(self defaultStyle)
        size:sizeNum
        sizeUnit:#pt
        encoding:(self defaultEncoding)

    "
     Font family:'helvetica' face:'medium' size:10
     Font family:'helvetica' face:'bold' size:10
     Font family:'courier'   face:'bold' size:10
    "

    "Modified: 30.4.1996 / 17:21:07 / cg"
!

family:familyString face:faceString style:styleString size:sizeNum
    "returns a font for given family, face, style and size with default encoding. 
     The returned font is not associated to a specific device"

    ^ self 
        family:familyString
        face:faceString
        style:styleString
        size:sizeNum
        sizeUnit:#pt
        encoding:(self defaultEncoding)

    "
     Font family:'helvetica' face:'medium' style:'roman'  size:10
     Font family:'helvetica' face:'medium' style:'italic' size:10
     Font family:'helvetica' face:'bold'   style:'roman'  size:10
     Font family:'courier'   face:'bold'   style:'italic' size:10
    "
!

family:familyString face:faceString style:styleString size:sizeNum encoding:encoding
    "returns a font for given family, face, style, size and the specified encoding. 
     The returned font is not associated to a specific device"

    ^ self 
          family:familyString 
          face:faceString 
          style:styleString 
          size:sizeNum
          sizeUnit:#pt
          encoding:encoding

    "Modified: 20.4.1996 / 23:19:04 / cg"
!

family:familyString face:faceString style:styleString size:size sizeUnit:sizeUnit encoding:encoding
    "returns a font for given family, face, style, size and the specified encoding. 
     The returned font is not associated to a specific device"

    ^ self new
          family:familyString 
          face:faceString 
          style:styleString 
          size:size
          sizeUnit:sizeUnit
          encoding:encoding

    "Modified: 20.4.1996 / 23:19:04 / cg"
!

family:familyString pixelSize:sizeNum
    "returns a font for given family and pixelSize with default encoding.
     The new fonts face defaults to `medium', its style to `roman'.
     Notice: the returned font will typically only be usable on a screen, 
     and will not scale as to the devices resolution.
     Use #family:size: for resolution-independent sizing."

    ^ self 
        family:familyString
        face:(self defaultFace)
        style:(self defaultStyle)
        size:sizeNum
        sizeUnit:#px
        encoding:(self defaultEncoding)

    "
     (Font family:'helvetica' size:10) onDevice:Screen current
     (Font family:'helvetica' pixelSize:10) onDevice:Screen current
    "
!

family:familyString size:sizeNum
    "returns a font for given family and size with default encoding.
     The new fonts face defaults to `medium', its style to `roman'.
     The returned font is not associated to a specific device"

    ^ self 
        family:familyString
        face:(self defaultFace)
        style:(self defaultStyle)
        size:sizeNum
        sizeUnit:#pt
        encoding:(self defaultEncoding)

    "
     Font family:'helvetica' size:10
     Font family:'courier' size:10
    "

    "Modified: 30.4.1996 / 17:21:40 / cg"
!

family:familyString size:sizeNum encoding:encoding
    "returns a font for given family and size with default encoding.
     The new fonts face defaults to `medium', its style to `roman'.
     The returned font is not associated to a specific device"

    ^ self 
        family:familyString
        face:(self defaultFace)
        style:(self defaultStyle)
        size:sizeNum
        sizeUnit:#pt
        encoding:encoding

    "
     Font family:'helvetica' size:10 encoding:#'iso8859-1'
     Font family:'courier' size:10 encoding:#'iso8859-1'
    "

    "Modified: 30.4.1996 / 17:21:40 / cg"
!

family:familyString style:aStyle size:sizeNum
    "returns a font for given family and size with default encoding.
     The new fonts face defaults to `medium', its style to `roman'.
     The returned font is not associated to a specific device"

    ^ self 
        family:familyString
        face:(self defaultFace)
        style:aStyle 
        size:sizeNum
        sizeUnit:#pt
        encoding:(self defaultEncoding)

    "
     Font family:'helvetica' style:#roman size:48
     Font family:'courier' style:#roman size:10
    "

    "Modified: 30.4.1996 / 17:21:40 / cg"
    "Created: 8.10.1996 / 18:33:55 / cg"
!

name:aFontName
    "returns a font with the given explicit name.
     WARNING:
       You shuld not use explicit naming, since font names vary
       with operatingSystems, devices and architecture.

     This interface is provided for special purposes only.
     On X, the name given should be according the X fontname conventions;
     i.e. something like: '-*-times-bold-r-normal-*-*-240-*-*-*-*-iso8859-1'.

     On other devices, font naming may be completely different."

    ^ self 
        family:aFontName 
        face:nil
        style:nil
        size:nil 
        sizeUnit:#px
        encoding:nil

    "
     Font name:'-*-times-bold-r-normal-*-*-240-*-*-*-*-iso8859-1'
     Font name:'6x10'
     Font name:'k14'
     ((Font name:'k14') on:Display) encoding
    "

    "Modified: 30.4.1996 / 17:23:09 / cg"
! !

!FontDescription class methodsFor:'accessing'!

defaultEncoding:encodingSymbol
    DefaultEncoding := encodingSymbol
!

genericFonts
    ^ GenericFonts
! !

!FontDescription class methodsFor:'defaults'!

defaultEncoding
    ^ DefaultEncoding ? #'iso10646-1'.
"/    ^ #'iso8859-1'

    "Modified: / 20-03-2012 / 23:48:24 / cg"
!

defaultFace
    ^ #medium
!

defaultSize
    ^ 12
!

defaultStyle
    ^ #roman 
! !

!FontDescription class methodsFor:'queries'!

characterSetForCharacterEncoding:encodingName
    "return the font-encoding for a character encoding"

    ^ CharacterEncodingToCharacterSetMapping at:encodingName ifAbsent:encodingName

    "
     FontDescription characterSetForCharacterEncoding:'utf8'     
     FontDescription characterSetForCharacterEncoding:'koi8-r'     
     FontDescription characterSetForCharacterEncoding:'unicode'     
    "
!

fontNamePatternForCharset:aCharSetName
    "return the font-encoding for an iso-charset"

    ^ CharacterSetToFontMapping at:aCharSetName ifAbsent:nil

    "
     FontDescription fontNamePatternForCharset:'iso2022-jp'       
     FontDescription fontNamePatternForCharset:'euc-jp'     
    "
!

preferredFontEncodingFor:fileEncoding
    "given a file encoding, return a corresponding match pattern for a preferred fontEncoding"

    |ce fe|

    ce := FontDescription characterSetForCharacterEncoding:fileEncoding.
    ce isNil ifTrue:[
        ce := fileEncoding.
    ].

    fe := FontDescription fontNamePatternForCharset:ce.
    fe notNil ifTrue:[^ fe].
    ^ ce ? self defaultEncoding.
! !

!FontDescription methodsFor:'Compatibility-ST80'!

boldness:aNumber
    "added for ST-80 compatibility; actually ignored currently"

    |val|

    flags isNil ifTrue:[
        flags := masks := 0
    ].

    "/ scale from 0..1 to 0..BoldnessMask
    val := (aNumber max:0.0) min:1.0.
    val := (BoldnessMask * val) rounded.

    flags := flags bitOr:val.
    masks := masks bitOr:BoldnessMask

    "Created: 25.1.1997 / 03:20:05 / cg"
    "Modified: 25.1.1997 / 03:20:47 / cg"
!

color:aColor
    "added for ST-80 compatibility; actually ignored currently"

    "Created: 25.1.1997 / 03:21:28 / cg"
!

encodings:aCollectionOfEncodings
    "added for ST-80 compatibility; actually ignored currently"

    "Created: 20.6.1997 / 09:52:46 / cg"
!

fixedWidth:aBoolean
    "added for ST-80 compatibility; actually ignored currently"

    flags isNil ifTrue:[
        flags := masks := 0
    ].
    aBoolean ifTrue:[
        flags := flags bitOr:FixedFlag.
        masks := masks bitOr:FixedFlag
    ] ifFalse:[
        flags := flags bitClear:FixedFlag.
        masks := masks bitClear:FixedFlag.
    ].

    "Created: 25.1.1997 / 03:14:06 / cg"
    "Modified: 25.1.1997 / 03:21:03 / cg"
!

italic:aBoolean
    "added for ST-80 compatibility; actually ignored currently"

    flags isNil ifTrue:[
        flags := masks := 0
    ].
    aBoolean ifTrue:[
        flags := flags bitOr:ItalicFlag.
        masks := masks bitOr:ItalicFlag
    ] ifFalse:[
        flags := flags bitClear:ItalicFlag.
        masks := masks bitClear:ItalicFlag.
    ].

    "Created: 25.1.1997 / 03:15:37 / cg"
    "Modified: 25.1.1997 / 03:20:55 / cg"
!

outline:aBoolean
    "added for ST-80 compatibility; actually ignored currently"

    flags isNil ifTrue:[
        flags := masks := 0
    ].
    aBoolean ifTrue:[
        flags := flags bitOr:OutlineFlag.
        masks := masks bitOr:OutlineFlag
    ] ifFalse:[
        flags := flags bitClear:OutlineFlag.
        masks := masks bitClear:OutlineFlag.
    ].

    "Modified: 25.1.1997 / 03:20:55 / cg"
    "Created: 20.6.1997 / 09:50:06 / cg"
!

pixelSize
    ^ pixelSize 
!

pixelSize:aNumber
    "if specified, the size is ignored, and a pixel-sized font is chosen."

    pixelSize := aNumber.
    sizeUnit := #px.
!

serif:aBoolean
    "added for ST-80 compatibility; actually ignored currently"

    flags isNil ifTrue:[
        flags := masks := 0
    ].
    aBoolean ifTrue:[
        flags := flags bitOr:SerifFlag.
        masks := masks bitOr:SerifFlag
    ] ifFalse:[
        flags := flags bitClear:SerifFlag.
        masks := masks bitClear:SerifFlag.
    ].

    "Created: 25.1.1997 / 03:15:17 / cg"
    "Modified: 25.1.1997 / 03:20:59 / cg"
!

setPixelSize:aNumber
    pixelSize := aNumber.
!

setSize:aNumber
    size := aNumber ? 0.
!

setSizeUnit:aSymbol
    sizeUnit := aSymbol.
!

shadow:aBoolean
    "added for ST-80 compatibility; actually ignored currently"

    flags isNil ifTrue:[
        flags := masks := 0
    ].
    aBoolean ifTrue:[
        flags := flags bitOr:ShadowFlag.
        masks := masks bitOr:ShadowFlag
    ] ifFalse:[
        flags := flags bitClear:ShadowFlag.
        masks := masks bitClear:ShadowFlag.
    ].

    "Modified: 25.1.1997 / 03:20:55 / cg"
    "Created: 20.6.1997 / 09:51:03 / cg"
!

strikeout:aBoolean
    "added for ST-80 compatibility; actually ignored currently"

    flags isNil ifTrue:[
        flags := masks := 0
    ].
    aBoolean ifTrue:[
        flags := flags bitOr:StrikeoutFlag.
        masks := masks bitOr:StrikeoutFlag
    ] ifFalse:[
        flags := flags bitClear:StrikeoutFlag.
        masks := masks bitClear:StrikeoutFlag.
    ].

    "Modified: 25.1.1997 / 03:20:55 / cg"
    "Created: 20.6.1997 / 09:51:36 / cg"
!

underline:aBoolean
    "added for ST-80 compatibility; actually ignored currently"

    flags isNil ifTrue:[
        flags := masks := 0
    ].
    aBoolean ifTrue:[
        flags := flags bitOr:UnderlineFlag.
        masks := masks bitOr:UnderlineFlag
    ] ifFalse:[
        flags := flags bitClear:UnderlineFlag.
        masks := masks bitClear:UnderlineFlag.
    ].

    "Modified: 25.1.1997 / 03:20:55 / cg"
    "Created: 20.6.1997 / 09:51:18 / cg"
! !

!FontDescription methodsFor:'accessing'!

device
    "return the device I am on"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #graphicsDevice'.
    ^ self graphicsDevice
!

encoding
    "return the font's encoding, as a symbol
     such as #'iso8859', #'jis0208.1983' or #ascii.
     If the encoding is not known, return nil; 
     You should assume ascii/iso8859-encoding then."

    ^ encoding

    "Modified: 20.4.1996 / 23:14:36 / cg"
!

face
    "return the face, a string"

    ^ face
!

face:aString
    "set the face, a string such as 'bold'"

    self assert:(self fontId isNil). "/ cannot change an instantiated font
    weight := nil.      "/ weight is the numeric equivalent to face
    face := aString

    "Created: 25.1.1997 / 03:12:12 / cg"
!

family
    "return the family, a string"

    ^ family
!

family:aString
    "set the family, a string"

    self assert:(self fontId isNil). "/ cannot change an instantiated font
    family := aString

    "Created: 25.1.1997 / 03:12:12 / cg"
!

family:familyString face:faceString style:styleString size:sizeNum encoding:encodingString
    <resource: #obsolete>
    "set the instance values"

    self 
        family:familyString 
        face:faceString 
        style:styleString 
        size:sizeNum 
        sizeUnit:#pt
        encoding:encodingString
!

family:familyString face:faceString style:styleString size:sizeArg sizeUnit:sizeUnitArg encoding:encodingString
    "set the instance values"

    self assert:(self fontId isNil). "/ cannot change an instantiated font

    family := familyString asSymbol.
    faceString notEmptyOrNil ifTrue:[
        face := faceString asSymbol.
    ].
    styleString notEmptyOrNil ifTrue:[
        style := styleString asSymbol.
    ].
    sizeUnit := sizeUnitArg.
    sizeUnit == #px ifTrue:[
        pixelSize := sizeArg.
    ] ifFalse:[
        sizeUnit isNil ifTrue:[
            sizeUnit := #pt.
        ].
        size := sizeArg ? 0.
    ].
    encodingString notEmptyOrNil ifTrue:[
        encoding := encodingString asSymbol.
    ]

    "Modified: 20.4.1996 / 23:19:25 / cg"
!

file:aNumber
    "set the file"

    self assert:(self fontId isNil). "/ cannot change an instantiated font
"/    file := aNumber
!

flags
    ^ flags
!

flags:anInteger
    flags := anInteger.
!

fontFormat:aString
    "set the fontFormat"

    self assert:(self fontId isNil). "/ cannot change an instantiated font
"/    fontFormat := aString
!

fontId
    "return the device-dependent font-id"

    ^ nil


!

fontVersion:aNumber
    "set the fontVersion"

    self assert:(self fontId isNil). "/ cannot change an instantiated font
"/    fontVersion := aNumber
!

foundry
    "return the manufacturer/foundry"

    ^ manufacturer

    "Created: 25.1.1997 / 03:12:43 / cg"
!

foundry:aString
    "set the value of the manufacturer/foundry"

    manufacturer := aString.

    "Created: 25.1.1997 / 03:12:43 / cg"
!

graphicsDevice
    "return the device I am on"

    ^ nil
!

hasOverlappingCharacters:aBoolean 
    "set whether this has overlapping chars (for windows cleartype drawing only)"
    
    flags := (flags ? 0) changeMask:OverlappingCharactersFlag to:aBoolean

    "Created: / 08-11-2010 / 13:16:23 / cg"
!

isAntialiasedFont:aBoolean 
    "set whether this is an antialiased font (currently for XftFonts only)"
    
    flags := (flags ? 0) changeMask:AntialiasedFlag to:aBoolean
!

isDecorativeFont:aBoolean 
    "set whether this is a decorative font (currently for XftFonts only)"
    
    flags := (flags ? 0) changeMask:DecorativeFlag to:aBoolean
!

isGenericFont:aBoolean 
    "set whether this is a pseudo font"
    
    flags := (flags ? 0) changeMask:GenericFlag to:aBoolean

    "Modified: / 08-11-2010 / 12:58:03 / cg"
    "Modified (comment): / 27-07-2013 / 15:39:50 / cg"
!

isOutlineFont:aBoolean 
    "set whether this is an outline font (currently for XftFonts only)"
    
    flags := (flags ? 0) changeMask:OutlineFlag to:aBoolean
!

isScalableFont:aBoolean 
    "set whether this is a scalable font (currently for XftFonts only)"
    
    flags := (flags ? 0) changeMask:ScalableFlag to:aBoolean
!

manufacturer
    "return the manufacturer/foundry"

    ^ manufacturer

    "Created: 25.1.1997 / 03:12:43 / cg"
!

manufacturer:aString
    "set the value of the manufacturer/foundry"

    manufacturer := aString.

    "Created: 25.1.1997 / 03:12:43 / cg"
!

masks
    ^ masks
!

masks:something
    masks := something.
!

name
    "the name (typically filename) if known"

    ^ name
!

name:aString
    name := aString.
!

sizeUnit
    "currently returns one of #pt or #px (internal use only)"

    ^ sizeUnit
!

slant
    "get the slant"

    ^ 0 "/ slant 
!

slant:aNumber
    "set the slant"

    self assert:(self fontId isNil). "/ cannot change an instantiated font
"/    slant := aNumber
!

spacing
    "get the spacing"

    ^ 100 "/ spacing 
!

spacing:aNumber
    "set the spacing"

    self assert:(self fontId isNil). "/ cannot change an instantiated font
"/    spacing := aNumber
!

style
    "return the style, a string"

    ^ style
!

style:aString
    "set the style"

    self assert:(self fontId isNil). "/ cannot change an instantiated font
    style := aString
!

weight:aNumber
    "set the weight"

    self assert:(self fontId isNil). "/ cannot change an instantiated font
    weight := aNumber
!

width:aNumber
    "set the width"

    self assert:(self fontId isNil). "/ cannot change an instantiated font
"/    width := aNumber
! !

!FontDescription methodsFor:'comparing'!

= aFont
    "two fonts are considered equal, if the font-name components are;
     independent of the device, the font is on"

    (aFont species ~~ self species) ifTrue:[^ false].
    (size ~~ aFont size) ifTrue:[^ false].  
    (family ~= aFont family) ifTrue:[^ false].  
    (face ~= aFont face) ifTrue:[^ false].  
    (style ~= aFont style) ifTrue:[^ false].  
    (encoding ~~ aFont encoding) ifTrue:[^ false].  
    (sizeUnit ~~ aFont sizeUnit) ifTrue:[^ false].
    sizeUnit == #px ifTrue:[
        (pixelSize ~~ aFont pixelSize) ifTrue:[^ false].  
    ] ifFalse:[
        (size ~~ aFont size) ifTrue:[^ false].  
    ].
    ^ true

    "Modified: / 20-05-2014 / 11:18:31 / gg"
!

hash
    "return a number for hashing - req'd since = is redefined."

    ^ ( (family hash bitAnd:16r1FFFFFFF)
      + (face hash bitAnd:16r1FFFFFFF)
      + (style hash bitAnd:16r1FFFFFFF)
      + (size ? 0) asInteger) bitAnd:16r3FFFFFFF

    "Created: / 19.6.1998 / 04:19:06 / cg"
    "Modified: / 20.6.1998 / 17:04:00 / cg"
!

sameDeviceFontAs:aFont
    aFont species ~~ self species ifTrue:[^ false].

    ^ self sameFamily: aFont family 
                 face: aFont face
                style: aFont style 
                 size: aFont size 
                 unit: aFont sizeUnit 
            pixelSize: aFont pixelSize
             encoding: aFont encoding

    "Modified: / 29-02-2016 / 08:30:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
 
!    

sameFamily: otherFamily face: otherFace style: otherStyle size: otherSize unit: otherSizeUnit pixelSize: otherPixelSize encoding: otherEncoding
    (family = otherFamily) ifFalse:[ ^ false ].
    (face = otherFace) ifFalse:[ ^ false ].
    ((style = otherStyle) 
      or:[ (style = 'italic' and:[otherStyle = 'oblique'])
      or:[ style = 'oblique' and:[otherStyle = 'italic']]]) ifFalse:[ ^ false ].

    (encoding isNil or:[encoding = otherEncoding]) ifFalse:[ ^ false ].
    (sizeUnit ? #pt) = otherSizeUnit ifFalse:[ ^ false ].
    (sizeUnit ? #pt) == #pt ifTrue:[
        (size ~= otherSize) ifTrue:[ ^ false ].
    ] ifFalse:[
        (pixelSize ~= otherPixelSize) ifTrue:[ ^ false ].
    ].
    ^ true

    "Created: / 29-02-2016 / 08:28:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FontDescription methodsFor:'converting'!

asBold
    "return the bold font corresponding to the receiver"

    ^ self asFace:#bold
!

asEncoding:anotherEncoding
    |newFont|

    family isNil ifTrue:[
        "CompoundFonts do not have a family"
        ^ self
    ].
    newFont := self class 
        family:family 
        face:face 
        style:style 
        size:(sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size]) 
        sizeUnit:sizeUnit
        encoding:anotherEncoding.

    newFont isGenericFont:self isGenericFont.

    ^ newFont onDevice:self graphicsDevice.
    "Modified: / 27-09-2006 / 13:08:11 / cg"
!

asFace:anotherFace
    "return the bold font corresponding to the receiver"

    |newFont|

    family isNil ifTrue:[
        "CompoundFonts do not have a family"
        ^ self
    ].
    newFont := self class 
                    family:family 
                    face:anotherFace 
                    style:style 
                    size:(sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size]) 
                    sizeUnit:sizeUnit
                    encoding:encoding.
    newFont isGenericFont:self isGenericFont.

    ^ newFont onDevice:self graphicsDevice.
!

asFamily:anotherFamily
    "return another font corresponding to the receiver face, style and size but
     with another family"

    family isNil ifTrue:[
        "CompoundFonts do not have a family"
        ^ self
    ].
    ^ (self class 
        family:anotherFamily 
        face:face 
        style:style 
        size:(sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size]) 
        sizeUnit:sizeUnit
        encoding:encoding) onDevice:self graphicsDevice.
!

asFontDescription
    ^ self
!

asFontWithPixelSize:anotherSize
    "return another font corresponding to the receiver's family, face and style but
     with another pixel size"

    |newFont|

    family isNil ifTrue:[
        "CompoundFonts do not have a family"
        ^ self
    ].
    newFont := self class 
        family:family 
        face:face 
        style:style 
        size:anotherSize 
        sizeUnit:#px
        encoding:encoding.

    newFont isGenericFont:self isGenericFont.

    ^ newFont onDevice:self graphicsDevice.
!

asItalic
    "return the italic font corresponding to the receiver"

    ^ self asStyle:#oblique
!

asPixelSize:anotherSize
    "return another font corresponding to the receiver's family, face and style but
     with another pixel size"

    |newFont|

    family isNil ifTrue:[
        "CompoundFonts do not have a family"
        ^ self
    ].
    newFont := self class 
        family:family 
        face:face 
        style:style 
        size:anotherSize 
        sizeUnit:#px
        encoding:encoding.

    newFont isGenericFont:self isGenericFont.
    ^ newFont onDevice:self graphicsDevice.
!

asSize:anotherSize
    "return another font corresponding to the receiver's family, face and style but
     with another size"

    |newFont|

    family isNil ifTrue:[
        "CompoundFonts do not have a family"
        ^ self
    ].
    newFont := self class 
        family:family 
        face:face 
        style:style 
        size:anotherSize 
        sizeUnit:#pt
        encoding:encoding.

    newFont isGenericFont:self isGenericFont.
    ^ newFont onDevice:self graphicsDevice.
!

asStyle:anotherStyle
    |newFont|

    family isNil ifTrue:[
        "CompoundFonts do not have a family"
        ^ self
    ].
    newFont := self class 
        family:family 
        face:face 
        style:anotherStyle 
        size:(sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size]) 
        sizeUnit:sizeUnit
        encoding:encoding.

    newFont isGenericFont:self isGenericFont.

    ^ newFont onDevice:self graphicsDevice.
    "Modified: / 27-09-2006 / 13:08:11 / cg"
!

fromLiteralArrayEncoding:literalEncoding
    "read my contents from a aLiteralEncodedArray.
     Must match to what is generated in #literalArrayEncoding"

    family := literalEncoding at:2.
    face   := literalEncoding at:3.
    style  := literalEncoding at:4.
    size   := literalEncoding at:5.
    "/ the following kludge is for backward compatibility 
    "/ do not cleanup !!
    literalEncoding size > 5 ifTrue:[
        literalEncoding size > 6 ifTrue:[
            sizeUnit := literalEncoding at:7.
            literalEncoding size > 7 ifTrue:[
                pixelSize := literalEncoding at:8.
            ].
        ].
        encoding := literalEncoding at:6.
    ] ifFalse:[
        encoding := self class defaultEncoding.
    ].
!

literalArrayEncoding
    "return myself encoded as a literal array.
     Must match to what is expected in #fromLiteralArrayEncoding:"

    |myName|

    myName := self class name.
    "/ see comment in #fromLiteralArrayEncoding
    "/ do not cleanup !!
    (pixelSize isNil
    and:[ encoding == #'iso8859-1' ]) ifTrue:[
        ^ Array
            with:myName
            with:family
            with:face
            with:style
            with:size
    ].
    (pixelSize isNil and:[self sizeUnit == #pt]) ifTrue:[
        ^ Array
            with:myName
            with:family
            with:face
            with:style
            with:size
            with:encoding
    ].
    ^ Array
        with:myName
        with:family
        with:face
        with:style
        with:size
        with:encoding
        with:sizeUnit
        with:pixelSize
!

on:aDevice
    "given the receiver, return a device Font"

    "/ send out a warning: #on: is typically used to create views
    "/ operating on a model.
    "/ Please use #onDevice: to avoid confusion.

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #onDevice:'.
    ^ self onDevice:aDevice.
!

onDevice:aDevice
    "given the receiver, return a device Font"

    |newFont|

    aDevice isNil ifTrue:[^ self].
    newFont := Font
        family:family 
        face:face 
        style:style 
        size:(sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size]) 
        sizeUnit:sizeUnit 
        encoding:encoding.
    newFont flags:flags.
    ^ newFont onDevice:aDevice.

   "Created: 28.3.1997 / 16:09:30 / cg"
!

scaled:factor 
    "return another font corresponding to the receiver's family, face and style but
     with another pixel size"
    
    |newFont|

    family isNil ifTrue:[
        "CompoundFonts do not have a family"
        ^ self
    ].
    newFont := self class 
            family:family
            face:face
            style:style
            size:(size * factor) rounded
            sizeUnit:sizeUnit
            encoding:encoding.
    newFont isGenericFont:self isGenericFont.
    ^ newFont onDevice:self graphicsDevice.
!

size:anotherSize
    <resource: #obsolete>
 
    "return a font corresponding to the receiver, but with different size."

    self obsoleteMethodWarning:'use #asSize:'.

    ^ self class 
        family:family 
        face:face 
        style:style 
        size:anotherSize 
        sizeUnit:#pt
        encoding:encoding
! !

!FontDescription methodsFor:'displaying'!

displayOpaqueString:aString from:index1 to:index2 x:x y:y in:aGC
    "display a partial string at some position in aGC.
     - display part of a string, drawing both fore- and background pixels"

    self displayString:aString from:index1 to:index2 x:x y:y in:aGC opaque:true
!

displayOpaqueString:aString x:x y:y in:aGC
    "display a string at some position in aGC."

    self displayOpaqueString:aString from:1 to:aString size x:x y:y in:aGC
!

displayString:aString from:index1 to:index2 x:x y:y in:aGC
    "display a partial string at some position in aGC."

    self displayString:aString from:index1 to:index2 x:x y:y in:aGC opaque:false
!

displayString:aString from:index1 to:index2 x:x y:y in:aGC opaque:opaque
    "display a partial string at some position in aGC."

    self subclassResponsibility
!

displayString:aString from:index1 to:index2 x:x0 y:y0 in:aGC opaque:opaque maxWidth:maxWidth
    "redefined for subclasses that do not implement maxWidth"

    self displayString:aString from:index1 to:index2 x:x0 y:y0 in:aGC opaque:opaque
!

displayString:aString x:x y:y in:aGC
    "display a string at some position in aGC."

    self displayString:aString from:1 to:aString size x:x y:y in:aGC

! !

!FontDescription methodsFor:'errors'!

errorNoDevice
    "a query was made for device-specific info"

    "
     this happens, when you ask a font for its height or width,
     ascent or any other dimension which depends on the device on
     which the font is rendered, AND the receiver font is not (yet)
     associated to a device.
     You should always use 
        font := font on:someDevice
     to get a device font, before asking for device specifics.
    "
    self error:'query device independent font for device specific info'

    "Modified: / 27.1.2000 / 16:55:05 / stefan"
! !

!FontDescription methodsFor:'getting a device font'!

onDevice:aDevice ifAbsent:exceptionBlock 
    "create a new Font representing the same font as
     myself on aDevice. This does NOT try to look for existing
     or replacement fonts (i.e. can be used to get physical fonts)."

    |prefs|

    prefs := UserPreferences current.
    ^ self
        onDevice:aDevice 
        xFontsOnly:(prefs useXFontsOnly) 
        xftFontsOnly:(prefs useXftFontsOnly) 
        ifAbsent:exceptionBlock 
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

    |newFont id xftFont|

    (aDevice supportsXftFonts) ifTrue:[
        xFontsOnly ifTrue:[
            xftFont := (XftFontDescription for:self) onDevice:aDevice ifAbsent:[nil].
            xftFont notNil ifTrue:[^ xftFont].
            xftFontsOnly useXftFontsOnly ifTrue:[^ nil].
        ].    
    ].    

    "ask that device for the font"
    id := aDevice 
            getFontWithFamily:family 
            face:face 
            style:style 
            size:(sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size])  
            sizeUnit:sizeUnit  
            encoding:encoding.
    id isNil ifTrue:[
        "oops did not work - (device has no such font)"

        ^ exceptionBlock value
    ].

    newFont := (Font basicNew) 
                        setFamily:family 
                        face:face
                        style:style
                        size:(sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size])  
                        sizeUnit:sizeUnit  
                        encoding:encoding
                        device:aDevice.
    newFont setFontId:id.
    newFont getFontInfos.
    aDevice registerFont:newFont.
    ^ newFont
! !

!FontDescription methodsFor:'printing & storing'!

printOn:aStream
    "append a user-friendly representation of the receiver to aStream"

    aStream nextPutAll:self userFriendlyName
!

userFriendlyName
    "return a user-friendly printed representation of the receiver"

    |nm|

    nm := family ? 'nil font family'.
    face notNil ifTrue:[
        nm := nm , '-', face.
    ].
    style notNil ifTrue:[
        nm := nm , '-', style.
    ].
    sizeUnit == #px ifTrue:[
        (pixelSize notNil and:[pixelSize ~~ 0]) ifTrue:[
            nm := nm , '-', pixelSize printString,'px'.
        ].
    ] ifFalse:[
        (size notNil and:[size ~~ 0]) ifTrue:[
            nm := nm , '-', size printString,'pt'.
        ].
    ].
    encoding notNil ifTrue:[
        nm := nm , '(', encoding , ')'.
    ].
    ^ nm

    "
     View defaultFont userFriendlyName
     Button defaultFont userFriendlyName
    "

    "Modified: 20.4.1996 / 23:25:36 / cg"
    "Created: 19.4.1997 / 18:09:25 / cg"
! !

!FontDescription methodsFor:'private'!

installInDeviceForGCId:aGCId
    "install the font for aGCId.
     This is a No-op. Subclasses may redefine this."

    ^ self.
! !

!FontDescription methodsFor:'queries'!

bold
    "return true, if the receiver is a bold font -
     Added for st-80 compatibility."

    "/ Currently, this implementation is a dirty hack and will be changed soon.

    ^ face = 'bold'

    "Modified: 11.4.1997 / 21:31:25 / cg"
!

boldness
    "return the boldness of the characters in this font 0 .. 1 -
     Added for st-80 compatibility"

    "/ Currently, this implementation is a dirty hack and will be changed soon.

    face = 'roman' ifTrue:[^ 0.5].
    face = 'normal' ifTrue:[^ 0.5].
    face = 'bold' ifTrue:[^ 0.75].
    face = 'light' ifTrue:[^ 0.25].
    ^ 0.5

    "Modified: 11.4.1997 / 21:31:31 / cg"
!

color
    "return the default color in which this font is to be rendered.
     Added for st-80 compatibility.
     For now always black."

    ^ Color black

    "Created: 25.1.1997 / 02:59:15 / cg"
    "Modified: 25.1.1997 / 03:02:14 / cg"
!

existsOn:aDevice
    "return true, if the receiver is available on aDevice;
     false otherwise. This is a kludge method; its better to
     ask a device for its available fonts and use this info ...
     Notice, that if you simply use a font by name, the system
     will automatically take a replacement font."

    ^ ((Font
        family:family 
        face:face 
        style:style 
        size:(sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size]) 
        sizeUnit:sizeUnit
        encoding:encoding) onDevice:aDevice ifAbsent:nil) notNil
!

fullName
    ^ nil

    "Created: 23.2.1996 / 00:45:45 / cg"
!

hasOverlappingCharacters
    "answer true, if this is a windows font where characters overlap"
    
    ^ flags notNil and:[ flags bitTest:OverlappingCharactersFlag ].

    "Created: / 08-11-2010 / 13:16:51 / cg"
!

italic
    "return true if this is an italic font -
     Added for st-80 compatibility"

    "/ Currently, this implementation is a dirty hack and will be changed soon.

    style = 'italic' ifTrue:[^ true].
    style = 'oblique' ifTrue:[^ true].
    ^ false

    "Modified: 11.4.1997 / 21:31:42 / cg"
!

serif
    "return true, if this font has serifs.
     Added for st-80 compatibility"

    "/ Currently, this implementation is a dirty hack and will be changed soon.

    family = 'Times' ifTrue:[^ true].
    family = 'times' ifTrue:[^ true].
    ^ false.

    "Modified: 11.4.1997 / 21:31:51 / cg"
!

size
    "return the size, a number"

    ^ size
!

species
    ^ Font
!

underline
    "return true if this is an underlined font -
     Added for st-80 compatibility
     (always false here)"

    ^ false

    "Created: 25.1.1997 / 02:58:30 / cg"
    "Modified: 25.1.1997 / 03:01:12 / cg"
! !

!FontDescription methodsFor:'queries-dimensions'!

ascent
    "return the ascent - the number of pixels above the baseLine."

    ^ self subclassResponsibility
!

ascentOn:aDevice
    "return the ascent - the number of pixels above the baseLine."

    ^ (self onDevice:aDevice) ascent
!

descent
    "return the descent - the number of pixels below the baseLine."

    ^ self subclassResponsibility
!

descentOn:aDevice
    "return the ascent - the number of pixels above the baseLine."

    ^ (self onDevice:aDevice) descent


!

height
    "return the height - the number of pixels above plus below the baseLine."

    ^ self subclassResponsibility
!

heightOf:aString
    "return the height of the given string.
     Here, assume the characters are of constant height"

    ^ self height
!

heightOf:aString on:aDevice
    "return the height of the given string on the given device."

    ^ (self onDevice:aDevice) heightOf:aString
!

heightOn:aDevice
    "return the height - the number of pixels above PLUS below the baseLine."

    ^ (self onDevice:aDevice) height
!

isFixedWidth
    "return true, if this is a fixed pitch font 
     (i.e. all characters are of the same width).
     Also called monospaced fonts"

    self subclassResponsibility
!

maxAscent
    "return the font's maximum-ascent (i.e. the maximum of all characters);
     That is the number of units (usually pixels) above the baseline."

    ^ self subclassResponsibility
!

maxCode
    "return the biggest UCS code in font.
     Dummy for now"

    ^ 16rFFFF
!

maxDescent
    "return the font's maximum-descent (i.e. the maximum of all characters);
     That is the number of units (usually pixels) below the baseline."

    ^ self subclassResponsibility
!

maxHeight
    "return the font's characters maximum height;
     That is the number of units (usually pixels)."

    ^ self maxAscent + self maxDescent
!

maxWidth
    "return the font's maximum-width character (i.e. the maximum of all characters);
     That is a number of units (usually pixels)."

    ^ self subclassResponsibility
!

minCode
    "return the smallest UCS code in font.
     Dummy for now"

    ^ 0
!

width
    "return the font's characters width;
     That is a number of units (usually pixels).
     For variable pitch fonts, the width of the space character is returned.
     For fixed fonts, this is the same as minWidth or maxWidth (or any character).
     The receiver must be associated to a device, for this query to be legal."

    ^ self widthOf:' '

    "Modified: 30.4.1996 / 16:43:45 / cg"
!

widthOf:aString
    "return the width of a string"

    ^ self widthOf:aString string from:1 to:aString size


!

widthOf:aString from:start to:stop
    "return the width of a sub string"

    ^ self subclassResponsibility


!

widthOf:aString from:start to:stop on:aDevice
    "return the width of a sub string.
     Here, assume that this fonts width is device independent."

    ^ (self onDevice:aDevice) widthOf:aString from:start to:stop


!

widthOf:aString on:aDevice
    "return the width of a string"

    ^ (self onDevice:aDevice) widthOf:aString





!

widthOn:aDevice
    "return the width on some device; that is the width of the space character
     (which is the width of any character iff the font is a fixed pitch font)"

    ^ (self onDevice:aDevice) width
! !

!FontDescription methodsFor:'queries-encoding'!

isASCII
    "return true, if the receiver's encoding is
     compatible with ascii (i.e. its ascii or iso8859)"

    ^ (encoding == #iso8859) or:[encoding == #ascii]

    "Created: 24.2.1996 / 22:47:30 / cg"
    "Modified: 20.4.1996 / 23:20:01 / cg"
!

isISO8859
    "return true, if the receiver's encoding is
     compatible with iso8859 (i.e. iso8859)"

    ^ encoding == #iso8859

    "Created: 24.2.1996 / 22:47:12 / cg"
    "Modified: 20.4.1996 / 23:20:13 / cg"
!

isJIS
    "return true, if the receiver's encoding is
     compatible with jis (i.e. jisXXX)"

    ^ (encoding startsWith:'jis')

    "Created: 24.2.1996 / 22:47:47 / cg"
    "Modified: 20.4.1996 / 23:20:30 / cg"
! !

!FontDescription methodsFor:'testing'!

isAlienFont
    "answer true, if this is an alien font which does not have a device representation"

    ^ true
!

isAntialiasedFont
    "answer true, if this is an antialiased font (currently Xft only)"
    
    ^ (flags ? 0) bitTest:AntialiasedFlag
!

isDecorativeFont
    "answer true, if this is an decorative font (currently Xft only)"
    
    ^ (flags ? 0) bitTest:DecorativeFlag
!

isGenericFont
    "answer true, if this is a pseudo font"
    
    ^ (flags ? 0) bitTest:GenericFlag
!

isOutlineFont
    "answer true, if this is an outline font (currently Xft only)"

    ^ (flags ? 0) bitTest:OutlineFlag 
!

isScaledFont
    "answer true, if this is a scalable font"

    ^ (sizeUnit ~= #px and:[size = 0]) or:[flags notNil and:[flags bitTest:ScalableFlag]] 
!

isXftFont
    "return false here; to be redefined in subclass(es)"

    ^ false
! !

!FontDescription class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


FontDescription initialize!
