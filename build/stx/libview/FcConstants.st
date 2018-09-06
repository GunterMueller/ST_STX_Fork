"
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

SharedPool subclass:#FcConstants
	instanceVariableNames:''
	classVariableNames:'FC_FAMILY FC_STYLE FC_SLANT FC_WEIGHT FC_SIZE FC_ASPECT
		FC_PIXEL_SIZE FC_SPACING FC_FOUNDRY FC_ANTIALIAS FC_HINTING
		FC_HINT_STYLE FC_VERTICAL_LAYOUT FC_AUTOHINT FC_WIDTH FC_FILE
		FC_INDEX FC_FT_FACE FC_RASTERIZER FC_OUTLINE FC_SCALABLE FC_SCALE
		FC_DPI FC_RGBA FC_MINSPACE FC_SOURCE FC_CHARSET FC_LANG
		FC_FONTVERSION FC_FULLNAME FC_FAMILYLANG FC_STYLELANG
		FC_FULLNAMELANG FC_CAPABILITY FC_FONTFORMAT FC_EMBOLDEN
		FC_EMBEDDED_BITMAP FC_DECORATIVE FC_LCD_FILTER FC_NAMELANG
		FC_CHAR_WIDTH FC_CHAR_HEIGHT FC_MATRIX FC_WEIGHT_THIN
		FC_WEIGHT_EXTRALIGHT FC_WEIGHT_ULTRALIGHT FC_WEIGHT_LIGHT
		FC_WEIGHT_BOOK FC_WEIGHT_REGULAR FC_WEIGHT_NORMAL
		FC_WEIGHT_MEDIUM FC_WEIGHT_DEMIBOLD FC_WEIGHT_SEMIBOLD
		FC_WEIGHT_BOLD FC_WEIGHT_EXTRABOLD FC_WEIGHT_ULTRABOLD
		FC_WEIGHT_BLACK FC_WEIGHT_HEAVY FC_WEIGHT_EXTRABLACK
		FC_WEIGHT_ULTRABLACK FC_SLANT_ROMAN FC_SLANT_ITALIC
		FC_SLANT_OBLIQUE FC_WIDTH_ULTRACONDENSED FC_WIDTH_EXTRACONDENSED
		FC_WIDTH_CONDENSED FC_WIDTH_SEMICONDENSED FC_WIDTH_NORMAL
		FC_WIDTH_SEMIEXPANDED FC_WIDTH_EXPANDED FC_WIDTH_EXTRAEXPANDED
		FC_WIDTH_ULTRAEXPANDED FC_PROPORTIONAL FC_DUAL FC_MONO
		FC_CHARCELL FC_RGBA_UNKNOWN FC_RGBA_RGB FC_RGBA_BGR FC_RGBA_VRGB
		FC_RGBA_VBGR FC_RGBA_NONE FC_HINT_NONE FC_HINT_SLIGHT
		FC_HINT_MEDIUM FC_HINT_FULL FC_LCD_NONE FC_LCD_DEFAULT
		FC_LCD_LIGHT FC_LCD_LEGACY StXFace2FCWeightMap
		StXStyle2FCSlantMap'
	poolDictionaries:''
	category:'Graphics-Support-FontConfig'
!

!FcConstants class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!FcConstants class methodsFor:'class initialization'!

initialize

    " Taken from fontconfig,h "
    FC_FAMILY               := 'family'.           "/* String */
    FC_STYLE                := 'style'.            "/* String */
    FC_SLANT                := 'slant'.            "/* Int */
    FC_WEIGHT               := 'weight'.           "/* Int */
    FC_SIZE                 := 'size'.             "/* Double */
    FC_ASPECT               := 'aspect'.           "/* Double */
    FC_PIXEL_SIZE           := 'pixelsize'.        "/* Double */
    FC_SPACING              := 'spacing'.          "/* Int */
    FC_FOUNDRY              := 'foundry'.          "/* String */
    FC_ANTIALIAS            := 'antialias'.        "/* Bool (depends) */
    FC_HINTING              := 'hinting'.          "/* Bool (true) */
    FC_HINT_STYLE           := 'hintstyle'.        "/* Int */
    FC_VERTICAL_LAYOUT      := 'verticallayout'.       "/* Bool (false) */
    FC_AUTOHINT             := 'autohint'.         "/* Bool (false) */
    FC_WIDTH                := 'width'.            "/* Int */
    FC_FILE                 := 'file'.             "/* String */
    FC_INDEX                := 'index'.            "/* Int */
    FC_FT_FACE              := 'ftface'.           "/* FT_Face */
    FC_RASTERIZER           := 'rasterizer'.       "/* String */
    FC_OUTLINE              := 'outline'.          "/* Bool */
    FC_SCALABLE             := 'scalable'.         "/* Bool */
    FC_SCALE                := 'scale'.            "/* double */
    FC_DPI                  := 'dpi'.              "/* double */
    FC_RGBA                 := 'rgba'.             "/* Int */
    FC_MINSPACE             := 'minspace'.         "/* Bool use minimum line spacing */
    FC_SOURCE               := 'source'.           "/* String (deprecated) */
    FC_CHARSET              := 'charset'.          "/* CharSet */
    FC_LANG                 := 'lang'.             "/* String RFC 3066 langs */
    FC_FONTVERSION          := 'fontversion'.      "/* Int from 'head'.table */
    FC_FULLNAME             := 'fullname'.         "/* String */
    FC_FAMILYLANG           := 'familylang'.       "/* String RFC 3066 langs */
    FC_STYLELANG            := 'stylelang'.        "/* String RFC 3066 langs */
    FC_FULLNAMELANG         := 'fullnamelang'.     "/* String RFC 3066 langs */
    FC_CAPABILITY           := 'capability'.   "/* String */
    FC_FONTFORMAT           := 'fontformat'.       "/* String */
    FC_EMBOLDEN             := 'embolden'.         "/* Bool - true if emboldening needed*/
    FC_EMBEDDED_BITMAP      := 'embeddedbitmap'."/* Bool - true to enable embedded bitmaps */
    FC_DECORATIVE           := 'decorative'.       "/* Bool - true if style is a decorative variant */
    FC_LCD_FILTER           := 'lcdfilter'.        "/* Int */
    FC_NAMELANG             := 'namelang'.         "/* String RFC 3866 langs */


    "Adjust outline rasterizer"
    FC_CHAR_WIDTH           := 'charwidth'."/* Int */
    FC_CHAR_HEIGHT          := 'charheight'."/* Int */
    FC_MATRIX               := 'matrix'.   "/* FcMatrix */

    FC_WEIGHT_THIN          := 0.
    FC_WEIGHT_EXTRALIGHT    := 40.
    FC_WEIGHT_ULTRALIGHT    := FC_WEIGHT_EXTRALIGHT.
    FC_WEIGHT_LIGHT         := 50.
    FC_WEIGHT_BOOK          := 75.
    FC_WEIGHT_REGULAR       := 80.
    FC_WEIGHT_NORMAL        := FC_WEIGHT_REGULAR.
    FC_WEIGHT_MEDIUM        := 100.
    FC_WEIGHT_DEMIBOLD      := 180.
    FC_WEIGHT_SEMIBOLD      := FC_WEIGHT_DEMIBOLD.
    FC_WEIGHT_BOLD          := 200.
    FC_WEIGHT_EXTRABOLD     := 205.
    FC_WEIGHT_ULTRABOLD     := FC_WEIGHT_EXTRABOLD.
    FC_WEIGHT_BLACK         := 210.
    FC_WEIGHT_HEAVY         := FC_WEIGHT_BLACK.
    FC_WEIGHT_EXTRABLACK    := 215.
    FC_WEIGHT_ULTRABLACK    := FC_WEIGHT_EXTRABLACK.

    FC_SLANT_ROMAN          := 0.
    FC_SLANT_ITALIC         := 100.
    FC_SLANT_OBLIQUE        := 110.

    FC_WIDTH_ULTRACONDENSED := 50.
    FC_WIDTH_EXTRACONDENSED := 63.
    FC_WIDTH_CONDENSED      := 75.
    FC_WIDTH_SEMICONDENSED  := 87.
    FC_WIDTH_NORMAL         := 100.
    FC_WIDTH_SEMIEXPANDED   := 113.
    FC_WIDTH_EXPANDED       := 125.
    FC_WIDTH_EXTRAEXPANDED  := 150.
    FC_WIDTH_ULTRAEXPANDED  := 200.

    FC_PROPORTIONAL         := 0.
    FC_DUAL                 := 90.
    FC_MONO                 := 100.
    FC_CHARCELL             := 110.

    "sub-pixel order"
    FC_RGBA_UNKNOWN         := 0.
    FC_RGBA_RGB             := 1.
    FC_RGBA_BGR             := 2.
    FC_RGBA_VRGB            := 3.
    FC_RGBA_VBGR            := 4.
    FC_RGBA_NONE            := 5.

    "hinting style"
    FC_HINT_NONE            := 0.
    FC_HINT_SLIGHT          := 1.
    FC_HINT_MEDIUM          := 2.
    FC_HINT_FULL            := 3.

    "LCD filter"
    FC_LCD_NONE             := 0.
    FC_LCD_DEFAULT          := 1.
    FC_LCD_LIGHT            := 2.
    FC_LCD_LEGACY           := 3.

    StXFace2FCWeightMap := Dictionary withKeysAndValues:{
        nil .         FC_WEIGHT_NORMAL .
        '' .          FC_WEIGHT_NORMAL .
        'thin'.       FC_WEIGHT_THIN.
        'extralight'. FC_WEIGHT_EXTRALIGHT.
        'ultralight'. FC_WEIGHT_ULTRALIGHT.
        'light'.      FC_WEIGHT_LIGHT.
        'book'.       FC_WEIGHT_BOOK.
        'regular'.    FC_WEIGHT_REGULAR.
        'normal'.     FC_WEIGHT_NORMAL.
        'medium'.     FC_WEIGHT_MEDIUM.
        'demibold'.   FC_WEIGHT_DEMIBOLD.
        'semibold'.   FC_WEIGHT_SEMIBOLD.
        'bold'.       FC_WEIGHT_BOLD.
        'extrabold'.  FC_WEIGHT_EXTRABOLD.
        'ultrabold'.  FC_WEIGHT_ULTRABOLD.
        'black'.      FC_WEIGHT_BLACK.
        'heavy'.      FC_WEIGHT_HEAVY.
        'extrablack'. FC_WEIGHT_EXTRABLACK.
        'ultrablack'. FC_WEIGHT_ULTRABLACK.
    }.
    StXStyle2FCSlantMap := Dictionary withKeysAndValues:{
        nil .       FC_SLANT_ROMAN .
        ''.         FC_SLANT_ROMAN .
        'roman'.    FC_SLANT_ROMAN.
        'italic'.   FC_SLANT_ITALIC.
        'oblique'.  FC_SLANT_OBLIQUE.
    }.

    "Created: / 17-02-2016 / 10:49:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-02-2016 / 07:45:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FcConstants class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


FcConstants initialize!
