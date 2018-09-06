"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libhtml' }"

Object subclass:#HTMLFontStyle
	instanceVariableNames:'boldCodeFont boldItalicCodeFont boldItalicNormalFont
		boldNormalFont codeFont fontSize h1Font h2Font h3Font h4Font
		h5Font h6Font italicCodeFont italicNormalFont normalFont
		normalSmallFont symbolFont'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLFontStyle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!HTMLFontStyle methodsFor:'accessing'!

boldCodeFont
    ^ boldCodeFont
!

boldCodeFont:something
    boldCodeFont := something.
!

boldItalicCodeFont
    ^ boldItalicCodeFont
!

boldItalicCodeFont:something
    boldItalicCodeFont := something.
!

boldItalicNormalFont
    ^ boldItalicNormalFont
!

boldItalicNormalFont:something
    boldItalicNormalFont := something.
!

boldNormalFont
    ^ boldNormalFont
!

boldNormalFont:something
    boldNormalFont := something.
!

codeFont
    ^ codeFont
!

codeFont:something
    codeFont := something.
!

fontSize
    ^ fontSize
!

fontSize:something
    fontSize := something.
!

h1Font
    ^ h1Font
!

h1Font:something
    h1Font := something.
!

h2Font
    ^ h2Font
!

h2Font:something
    h2Font := something.
!

h3Font
    ^ h3Font
!

h3Font:something
    h3Font := something.
!

h4Font
    ^ h4Font
!

h4Font:something
    h4Font := something.
!

h5Font
    ^ h5Font
!

h5Font:something
    h5Font := something.
!

h6Font
    ^ h6Font
!

h6Font:something
    h6Font := something.
!

italicCodeFont
    ^ italicCodeFont
!

italicCodeFont:something
    italicCodeFont := something.
!

italicNormalFont
    ^ italicNormalFont
!

italicNormalFont:something
    italicNormalFont := something.
!

normalFont
    ^ normalFont
!

normalFont:something
    normalFont := something.
!

normalSmallFont
    ^ normalSmallFont
!

normalSmallFont:something
    normalSmallFont := something.
!

symbolFont
    ^ symbolFont
!

symbolFont:something
    symbolFont := something.
! !

!HTMLFontStyle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLFontStyle.st,v 1.3 2003-09-22 18:20:46 cg Exp $'
! !
