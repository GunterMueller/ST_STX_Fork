"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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

VisualPart subclass:#CompositePart
	instanceVariableNames:'components preferredBounds'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!CompositePart class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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
    a dummy class - only existing to provide a compatible home
    for fileIn of ST-80 classes.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, from reading PD programs and 
        from the Hopkins/Horan book.
        - it may not be complete or compatible to the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Gittinger
"




! !

!CompositePart methodsFor:'accessing'!

components
    "return the components"

    ^ components

    "Created: 14.2.1997 / 17:57:23 / cg"
    "Modified: 14.2.1997 / 17:57:32 / cg"
! !

!CompositePart methodsFor:'adding-removing'!

add:aComponent
    components isNil ifTrue:[
        components := OrderedCollection new
    ].
    components add:aComponent.
    aComponent container:self.
    self changed:#sizeOfContents

    "Created: / 14.2.1997 / 17:57:59 / cg"
    "Modified: / 6.7.1998 / 18:50:40 / cg"
!

add:aComponent at:aPoint
    aComponent origin:aPoint.
    self add:aComponent

    "Created: / 14.2.1997 / 17:58:19 / cg"
    "Modified: / 6.7.1998 / 13:44:01 / cg"
! !

!CompositePart methodsFor:'displaying'!

displayOn:aGC
    "display the receiver on some graphicsContext. 
     The sender is repsonsible for restoring the GC's state
     (i.e. it may be left in any undefined state)"

    components notNil ifTrue:[
        components do:[:aComponent |
            aComponent displayOn:aGC
        ]
    ].

    "Created: / 6.7.1998 / 13:59:33 / cg"
    "Modified: / 6.7.1998 / 17:55:40 / cg"
! !

!CompositePart methodsFor:'view protocol mimicri'!

realizeAllSubViews
    "realize all my subviews - but not myself."

    components notNil ifTrue:[
        components do:[:component |
            component realize
        ]
    ].

    "Modified: / 5.9.1995 / 23:30:47 / claus"
    "Modified: / 13.1.1997 / 21:25:49 / cg"
    "Created: / 6.7.1998 / 18:37:39 / cg"
!

withAllSubViewsDo:aBlock
    aBlock value:self.
    components notNil ifTrue:[
        components do:[:aComponent |
            aComponent withAllSubViewsDo:aBlock
        ]
    ]
! !

!CompositePart class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/CompositePart.st,v 1.5 2003-08-18 12:13:47 cg Exp $'
! !

