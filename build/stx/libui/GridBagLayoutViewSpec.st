"
 COPYRIGHT (c) 1998 by Andreas Vogel / eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libui' }"

PanelViewSpec subclass:#GridBagLayoutViewSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!GridBagLayoutViewSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by Andreas Vogel / eXept Software AG
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
    This is the specification class for the GridBagLayoutView.

    [see also:]
	GridBagLayoutView
	GridBagConstraints
	GridBagLayoutInfo

    [author:]
	Andreas Vogel
"
! !

!GridBagLayoutViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 

    super addBindingsTo:env for:anInstance channel:aChannel.

"/    env at:#horizontalLayoutList
"/       put:#(
"/                #left
"/                #leftSpace
"/                #fixLeft
"/                #fixLeftSpace
"/                #right
"/                #rightSpace
"/                #center
"/                #spread
"/                #spreadSpace
"/                #fit
"/                #fitSpace
"/                #leftFit 
"/                #leftSpaceFit
"/                #rightFit 
"/                #rightSpaceFit
"/
"/                #leftMax
"/                #leftSpaceMax
"/                #rightMax
"/                #rightSpaceMax
"/                #centerMax
"/                #spreadMax
"/                #spreadSpaceMax
"/        ) asValue.
"/
"/    env at:#verticalLayoutList
"/       put:#(
"/                #top
"/                #topSpace
"/                #center
"/                #bottom
"/                #bottomSpace
"/                #fit
"/                #fitSpace
"/                #topMax
"/                #topSpaceMax
"/                #bottomMax
"/                #bottomSpaceMax
"/                #centerMax
"/        ) asValue.

    "Created: / 22.1.1998 / 00:26:00 / av"
    "Modified: / 22.1.1998 / 00:49:40 / av"
! !

!GridBagLayoutViewSpec methodsFor:'building'!

buildViewWithLayoutFor:aBuilder in:aView
    |newView|

    newView := super buildViewWithLayoutFor:aBuilder in:aView.

    "/ Now, after all children exists, decode the GridBagLayoutConstraints and store the created object
    "/
    newView subViews do:[ :sv |
        |slot constraints|

        slot := #GridBagConstraints.
        constraints := sv objectAttributeAt:slot.
        constraints notNil ifTrue:[
            sv objectAttributeAt:slot put:(constraints decodeAsLiteralArray)
        ].
    ].

    ^ newView

    "Created: / 22.1.1998 / 22:04:35 / av"
    "Modified: / 25.1.1998 / 00:05:13 / av"
! !

!GridBagLayoutViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/GridBagLayoutViewSpec.st,v 1.5 2008-01-09 20:07:39 cg Exp $'
! !
