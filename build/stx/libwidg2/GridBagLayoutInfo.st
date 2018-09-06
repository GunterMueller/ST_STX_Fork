"
 COPYRIGHT (c) 1998 by Andreas Vogel
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


"{ Package: 'stx:libwidg2' }"

Object subclass:#GridBagLayoutInfo
	instanceVariableNames:'width height startX startY minWidth minHeight weightX weightY'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!GridBagLayoutInfo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by Andreas Vogel
 COPYRIGHT (c) 1998 by eXept Software AG
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
    This is a helper class for the GridBagLayoutView and not usable for general purposes.

    Instance variables:

	int     width, height          number of cells horizontally, vertically 
	int     startx, starty         starting point for layout 
	int     minWidth[]             largest minWidth in each column 
	int     minHeight[]            largest minHeight in each row 
	double  weightX[]              largest weight in each column 
	double  weightY[]              largest weight in each row 

    [see also:]
	GridBagLayoutView

    [author:]
	Andreas Vogel
"
! !

!GridBagLayoutInfo methodsFor:'accessing'!

height
    ^ height

    "Created: / 17.1.1998 / 14:32:39 / av"
!

height:something
    height := something.

    "Created: / 17.1.1998 / 14:32:39 / av"
!

minHeight
    ^ minHeight

    "Created: / 17.1.1998 / 14:32:39 / av"
!

minHeight:something
    minHeight := something.

    "Created: / 17.1.1998 / 14:32:39 / av"
!

minWidth
    ^ minWidth

    "Created: / 17.1.1998 / 14:32:39 / av"
!

minWidth:something
    minWidth := something.

    "Created: / 17.1.1998 / 14:32:39 / av"
!

startX
    ^ startX

    "Created: / 17.1.1998 / 14:32:39 / av"
!

startX:something
    startX := something.

    "Created: / 17.1.1998 / 14:32:39 / av"
!

startY
    ^ startY

    "Created: / 17.1.1998 / 14:32:39 / av"
!

startY:something
    startY := something.

    "Created: / 17.1.1998 / 14:32:39 / av"
!

weightX
    ^ weightX

    "Created: / 17.1.1998 / 14:32:39 / av"
!

weightX:something
    weightX := something.

    "Created: / 17.1.1998 / 14:32:39 / av"
!

weightY
    ^ weightY

    "Created: / 17.1.1998 / 14:32:39 / av"
!

weightY:something
    weightY := something.

    "Created: / 17.1.1998 / 14:32:39 / av"
!

width
    ^ width

    "Created: / 17.1.1998 / 14:32:39 / av"
!

width:something
    width := something.

    "Created: / 17.1.1998 / 14:32:39 / av"
! !

!GridBagLayoutInfo methodsFor:'initialization'!

initialize

    super initialize.

    minWidth  := IdentityDictionaryWithDefault newWithDefaultValue:0.
    minHeight := IdentityDictionaryWithDefault newWithDefaultValue:0.

    weightX   := IdentityDictionaryWithDefault newWithDefaultValue:0.0.
    weightY   := IdentityDictionaryWithDefault newWithDefaultValue:0.0.

    "Created: / 17.1.1998 / 14:32:30 / av"
    "Modified: / 20.1.1998 / 16:50:16 / av"
! !

!GridBagLayoutInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/GridBagLayoutInfo.st,v 1.3 2006-03-13 15:55:20 cg Exp $'
! !
