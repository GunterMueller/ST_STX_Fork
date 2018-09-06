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

ControllerWithMenu subclass:#ApplicationController
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Framework'
!

!ApplicationController class methodsFor:'documentation'!

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
    Since many ST-80 classes are subclasses of ApplicationController, 
    this class is provided here to allow easier porting of ST-80 code.
    It does not (currently) provide any functionality; therefore, manual
    changes have to be made to get those applications to run under ST/X.
    (but at least, this enables you to fileIn that code)

    Instance variables:
"
! !

!ApplicationController methodsFor:'closing'!

close
    "close the application"

    self view destroy
! !

!ApplicationController class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/ApplicationController.st,v 1.6 1995-11-11 16:04:12 cg Exp $'
! !

