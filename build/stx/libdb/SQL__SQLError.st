"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libdb' }"

"{ NameSpace: SQL }"

ProceedableError subclass:#SQLError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-Framework'
!

!SQLError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!SQLError class methodsFor:'initialization'!

initialize
    NotifierString := 'SQL: error'.
! !

!SQLError methodsFor:'accessing'!

errorCode
    ^ parameter
!

errorCode:something
    parameter := something.
! !

!SQLError methodsFor:'queries'!

isEndOfFileCommunication
    "
     return true if the error is an EndOfFileCommunication error
     false here, only redefined in OCIEndOfFileCommunicationSignal.

     <return: Boolean>
    "

    ^ false
!

isLogOnError
    "
     return true if the error is a LogOn error
     false here, only redefined in OCILogOnErrorSignal.

    <return: Boolean>
    "

    ^ false
!

isNoData
    "
     return true if the error is a NoDataSigna error
     false here, only redefined in OCINoDataSignal

    <return: Boolean>
    "

    ^ false
!

isSuccessWithInfo
    "
     return true if the error is a SuccessWithInfo signalization
     false here, only redefined in OCISuccessWithInfoSignal

    <return: Boolean>
    "

    ^ false
! !

!SQLError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/SQL__SQLError.st,v 1.7 2012-09-14 14:30:07 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/SQL__SQLError.st,v 1.7 2012-09-14 14:30:07 stefan Exp $'
! !

SQLError initialize!
