"{ Encoding: utf8 }"

"
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

Object subclass:#AbstractBackground
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!AbstractBackground class methodsFor:'documentation'!

copyright
"
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
    This will replace the viewBackground color.
    Instances of me (and subclasses) can be set as a widget's
    viewBackground, and will get 
        fillRectangleX:x y:y width:w height:h in:aView
    messages whenever the widget wants to redraw (parts of) its background.

    See the example in GradientBackground.

    [author:]
        Claus Gittinger

    [see also:]
        GradientBackground
"
!

examples
"
    |v|

    v := View new.
    v viewBackground:(SolidBackground new color:Color red).
    v open.
"
! !

!AbstractBackground methodsFor:'drawing'!

fillRectangleX:x y:y width:w height:h in:aView
    self subclassResponsibility

    "Created: / 23-01-2011 / 01:59:29 / cg"
! !

!AbstractBackground methodsFor:'ignored conversion'!

asFormOn:aDevice
    self subclassResponsibility

    "Created: / 23-01-2011 / 01:45:35 / cg"
    "Modified: / 03-02-2011 / 19:55:49 / cg"
!

onDevice:aDevice
    self subclassResponsibility

    "Created: / 23-01-2011 / 01:46:11 / cg"
    "Modified: / 03-02-2011 / 19:55:40 / cg"
! !

!AbstractBackground methodsFor:'testing'!

isViewBackground
    ^ true
!

needsFullRedrawOnChangeOfHeight
    ^ false
!

needsFullRedrawOnChangeOfWidth
    ^ false
! !

!AbstractBackground class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

