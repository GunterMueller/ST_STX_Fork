"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIError subclass:#OCIContinueSignal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Exceptions'
!


!OCIContinueSignal class methodsFor:'documentation'!

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

!OCIContinueSignal class methodsFor:'initialization'!

initialize

    NotifierString := 'OCI: continue'.
! !

!OCIContinueSignal class methodsFor:'queries'!

errorSymbol

    ^ #'OCI_NEED_DATA'
! !

!OCIContinueSignal class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCIContinueSignal.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !

OCIContinueSignal initialize!
