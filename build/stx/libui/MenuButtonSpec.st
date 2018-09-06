"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"



"{ Package: 'stx:libui' }"

PopUpListSpec subclass:#MenuButtonSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!MenuButtonSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


! !

!MenuButtonSpec methodsFor:'building'!

viewClass
    "return the corresponding view class of the spec"

    ^ PopUpList

    "Created: / 18.6.1998 / 23:18:26 / cg"
! !

!MenuButtonSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/MenuButtonSpec.st,v 1.15 2003-10-09 15:16:17 cg Exp $'
! !
