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

Object subclass:#GraphicsAttributes
	instanceVariableNames:'paint font lineStyle lineWidth joinStyle capStyle maskOrigin'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!GraphicsAttributes class methodsFor:'documentation'!

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
    instances keep multiple graphics attributes as used in a graphicsContext.
    They can be used when multiple attributes are to be set.
    This class is (currently) not used by the system, but has been added
    to make porting of existing ST-80 applications easier.

    Instance variables:

	paint           <Color>         the paint to be used for drawing
	font            <Font>          the font to be used for drawing
	lineStyle       <Symbol>        the lineStyle (i.e. #solid, #dashed, #doubleDashed)
	lineWidth       <SmallInteger>  the lineWidth (device dependent, usually pixels)
	joinStyle       <Symbol>        the style in which lines (in polygons)
					are joined (i.e. #miter, #bevel, #round)
	capStyle        <Symbol>        the style in which the last point of a line is drawn
					(i.e. #notLast, #butt, #round, #projecting)
	maskOrigin      <Point>         the origin of the mask relative to
					the drawables origin

    CAVEAT: the maskOrigin is called phase in ST-80
"
! !

!GraphicsAttributes methodsFor:'accessing'!

capStyle
    "return the cap-style for line-drawing"

    ^ capStyle
!

capStyle:aStyleSymbol
    "set the cap-style for line-drawing;
     possible styles are: #notLast, #butt, #round, #projecting"

    capStyle := aStyleSymbol
!

font
    "return the drawing font"

    ^ font
!

font:aFont
    "set the drawing font"

    font := aFont
!

joinStyle
    "return the join-style for polygon-drawing"

    ^ joinStyle
!

joinStyle:aStyleSymbol
    "set the join-style of lines in polygon-drawing;
     possible styles are: #miter, #bevel, #round"

    joinStyle := aStyleSymbol
!

lineStyle
    "return the line-drawing-style"

    ^ lineStyle
!

lineStyle:aStyleSymbol
    "set the line-drawing-style;
     possible styles are: #solid, #dashed, #doubleDashed"

    lineStyle := aStyleSymbol
!

lineWidth
    "return the drawing linewidth"

    ^ lineWidth
!

lineWidth:aNumber
    "set the line drawing width in pixels"

    lineWidth := aNumber
!

maskOrigin:aPoint
    "set the origin within the mask (used to draw with patterns).
     This is an alias for ST-80's #phase"

    maskOrigin := aPoint
!

maskOriginX:x y:y
    "set the origin within the mask (used to draw with patterns)."

    ^ maskOrigin
!

paint
    "return the current paint drawing color"

    ^ paint
!

paint:aColor
    "set the drawing painting color"

    paint := aColor
!

phase
    "return the origin within the mask (used to draw with patterns).
     This is an alias for ST/X's #maskOrigin"

    ^ maskOrigin
!

phase:aPoint
    "set the origin within the mask (used to draw with patterns).
     This is an alias for ST/X's #maskOrigin:"

    maskOrigin := aPoint
! !

!GraphicsAttributes methodsFor:'installing'!

installOn:aGC
    paint notNil ifTrue:[aGC paint:paint].
    font notNil ifTrue:[aGC font:font].
    lineWidth notNil ifTrue:[aGC lineWidth:lineWidth].
    lineStyle notNil ifTrue:[aGC lineStyle:lineStyle].
    joinStyle notNil ifTrue:[aGC joinStyle:joinStyle].
    capStyle notNil ifTrue:[aGC capStyle:capStyle].
    maskOrigin notNil ifTrue:[aGC maskOrigin:capStyle].
! !

!GraphicsAttributes class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview/GraphicsAttributes.st,v 1.4 1995-11-11 15:51:01 cg Exp $'
! !

