"
 COPYRIGHT (c) 1997 by eXept Software AG
 COPYRIGHT (c) 2009 by eXept Software AG
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

Object subclass:#AbstractBorder
	instanceVariableNames:'width'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!AbstractBorder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
 COPYRIGHT (c) 2009 by eXept Software AG
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
    Extracted from Border.
    Common superclass for border-painters.
    This will replace the mixture of window-system supported borders and manually
    drawn 3D levels (which is ugly, but served me well for almost 20years now).

    [author:]
	Claus Gittinger
"
! !

!AbstractBorder class methodsFor:'instance creation'!

color:aColor
    "create a new instance of the receiver with a border of the given color."

    ^ self width:1 color:aColor
!

new
    "return an initialized instance"

    ^ self basicNew initialize.
!

width:borderWidth
    "create a new instance of the receiver with a border of the given width
     (and default color)."

    ^ self new width:borderWidth color:(Color black)

    "Modified: 10.2.1997 / 15:19:57 / cg"
!

width:borderWidth color:aColor
    "create a new instance of the receiver with a border of the given width
     and color."

    ^ self new width:borderWidth color:aColor

    "Modified: 10.2.1997 / 15:20:32 / cg"
! !

!AbstractBorder methodsFor:'accessing'!

color
    "get the color; nil if there is no single color"

    ^ nil
!

color:aColor
    "set the color"

    "/ self subclassResponsibility
!

level
    "get the 3D level"

    ^ 0
!

width
    "get the width"

    ^ width ? 1
!

width:aNumber
    "set the width"

    width := aNumber
!

width:aWidth color:aColor
     self width:aWidth.
     self color:aColor

    "Created: 10.2.1997 / 15:21:27 / cg"
! !

!AbstractBorder methodsFor:'displaying'!

displayOn:aGC forDisplayBox:aRectangle
    "display the borders represented by the receiver in the specified rectangle.
     The gc is restored after the draw."

    "/ self subclassResponsibility
! !

!AbstractBorder methodsFor:'initialization'!

initialize
    width := 1.
! !

!AbstractBorder methodsFor:'queries'!

allSidesEqual:aSmallInteger 
    "true if all four sides have the same border width;
     always true here - provided for compatibility"

    ^ true

    "Created: 10.2.1997 / 14:53:13 / cg"
!

bottomMargin
    "return the bottom inset.
     That is the number of pixels that an instance of me requires at the bottom,
     eg. the inset of the view's contents"

    ^ width
!

displayBoxFor:aRectangle
    "return a rectangle representing the overall display box of a component
     bordered by the receiver, which has bounds of aRectangle.
     That is, the argument outset by the receiver's borders."

    |insetRectangle|

    insetRectangle := aRectangle copy.
    insetRectangle left:(insetRectangle left - width).
    insetRectangle right:(insetRectangle right + width).
    insetRectangle top:(insetRectangle top - width).
    insetRectangle bottom:(insetRectangle bottom + width).
    ^ insetRectangle

    "Created: 10.2.1997 / 15:43:00 / cg"
!

insetDisplayBoxFor:aRectangle
    "return a rectangle representing the display box of a component
     bordered by the receiver in the outer bounds, aRectangle.
     That is, the argument inset by the receiver's borders."

    |insetRectangle|

    insetRectangle := aRectangle copy.
    insetRectangle left:(insetRectangle left + width).
    insetRectangle right:(insetRectangle right - width).
    insetRectangle top:(insetRectangle top + width).
    insetRectangle bottom:(insetRectangle bottom - width).
    ^ insetRectangle

    "Created: 10.2.1997 / 15:42:06 / cg"
!

leftMargin
    "return the left inset.
     That is the number of pixels that an instance of me requires at the left,
     eg. the inset of the view's contents"

    ^ width
!

rightMargin
    "return the right inset.
     That is the number of pixels that an instance of me requires at the right,
     eg. the inset of the view's contents"

    ^ width
!

topMargin
    "return the top inset.
     That is the number of pixels that an instance of me requires at the top,
     eg. the inset of the view's contents"

    ^ width
! !

!AbstractBorder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

