"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIError subclass:#OCISuccessWithInfoSignal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Exceptions'
!

!OCISuccessWithInfoSignal class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !


!OCISuccessWithInfoSignal class methodsFor:'initialization'!

initialize

    NotifierString := 'OCI: operation succeeded with info'.


! !

!OCISuccessWithInfoSignal methodsFor:'queries'!

isSuccessWithInfo
"
test returns true, because instance is an OCISuccessWithInfoSignal

<return: Boolean>
"
    ^true
!

mayProceed

    ^ true
! !

!OCISuccessWithInfoSignal class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCISuccessWithInfoSignal.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !

OCISuccessWithInfoSignal initialize!
