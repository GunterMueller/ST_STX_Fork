"
 COPYRIGHT (c) 2012 by eXept Software AG
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

Notification subclass:#SQLNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-Framework'
!

!SQLNotification class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by eXept Software AG
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
    This Notification is raised when a SQL primitive returns
    a SUCCESS_WITH_INFO return code.

    The description is set to the info message.

    [author:]
        Stefan Vogel

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SQLNotification class methodsFor:'initialization'!

initialize
    NotifierString := 'SQL Notification:'
! !

!SQLNotification class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/SQL__SQLNotification.st,v 1.1 2012-07-23 09:09:57 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/SQL__SQLNotification.st,v 1.1 2012-07-23 09:09:57 stefan Exp $'
! !

SQLNotification initialize!
