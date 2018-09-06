"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

Object subclass:#Layout
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry'
!

!Layout class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    This is an abstract superclass for geometry controlling objects.
    While old smalltalks used relative origin/extent/corner and absolute
    origin/corner/extents, these mechanisms are now being removed from the
    view itself into geometry controlling objects, which are given a superviews
    size and are to return a components size upon request.
    This allows more flexible geometry management, since any algorithm can
    be implemented (if the existing ones are not sufficient, add you own subclass
    and install it as layout-object in your view).

    Notice: 
        this class was implemented using protocol information
        from alpha testers - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Gittinger

    [see also:]
        View
        LayoutOrigin LayoutFrame AlignmentOrigin
"
! !

!Layout class methodsFor:'instance creation'!

new
    "return a new initialized instance"

    ^ self basicNew initialize

    "Modified: 27.4.1996 / 14:47:08 / cg"
! !

!Layout methodsFor:'converting'!

asLayout
    "return the receiver"

    ^ self

    "Created: 29.5.1996 / 15:12:13 / cg"
! !

!Layout methodsFor:'initialization'!

initialize
    "setup the instance - to be redefined by concrete subclasses"

    ^ self subclassResponsibility

    "Modified: 27.4.1996 / 14:46:56 / cg"
! !

!Layout methodsFor:'queries'!

isAlignmentOrigin
    "return true, if this is an alignmentOrigin"

    ^ false

!

isLayout
    "return true, if the receiver is a layout object. 
     Always return true here."

    ^ true

    "Modified: 27.4.1996 / 14:45:27 / cg"
!

isLayoutFrame
    "return true, if this is a layoutFrame"

    ^ false

!

isLayoutOrigin
    "return true, if this is a layoutOrigin"

    ^ false

!

rectangleRelativeTo:superRectangle preferred:prefRectHolder
    "compute the rectangle represented by the receiver,
     given the superViews rectangle and the view's preferredExtent.
     Must be implemented by concrete subclasses."

    ^ self subclassResponsibility

    "Modified: / 27.5.1998 / 10:19:21 / cg"
! !

!Layout class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

