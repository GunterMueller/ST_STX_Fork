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

AbstractBackground subclass:#SolidBackground
	instanceVariableNames:'color'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!SolidBackground class methodsFor:'documentation'!

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

examples
"
    |v|

    v := View new.
    v viewBackground:(SolidBackground new color:Color red).
    v open.
"
! !

!SolidBackground methodsFor:'accessing'!

color
    ^ color
!

color:something
    color := something.
! !

!SolidBackground methodsFor:'drawing'!

fillRectangleX:x y:y width:w height:h in:aView
    aView paint:color.
    aView fillRectangleX:x y:y width:w height:h

    "Created: / 23-01-2011 / 01:59:29 / cg"
! !

!SolidBackground class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview/SolidBackground.st,v 1.4 2014-12-21 15:38:34 cg Exp $'
! !

