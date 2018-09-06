"
 COPYRIGHT (c) 2016 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

HaltInterrupt subclass:#ObsoleteMethodCallWarning
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Control'
!

!ObsoleteMethodCallWarning class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by eXept Software AG
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
    Raised when an obsolete method is called.
    Thus used to do a halt; now this separate exception is raised to make it
    easier to separately handle this.
    Still a kind of programmed debug-breakpoint.

    [author:]
        Claus Gittinger
"
! !

!ObsoleteMethodCallWarning class methodsFor:'initialization'!

initialize
    NotifierString := 'Obsolete method called'.

    "
     self initialize.
    "
! !

!ObsoleteMethodCallWarning class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ObsoleteMethodCallWarning initialize!
