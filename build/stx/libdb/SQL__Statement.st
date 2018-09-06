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

Object subclass:#Statement
	instanceVariableNames:'handle'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-Framework'
!

!Statement class methodsFor:'documentation'!

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

!Statement methodsFor:'binding'!

bindVariable:positionOrName as:aSmalltalkClassOrSQLType
    ^ self bindVariable:positionOrName as:aSmalltalkClassOrSQLType size:nil
!

bindVariable:positionOrName as:aSmalltalkClassOrSQLCType size:sizeOrNil
    self subclassResponsibility.
! !

!Statement methodsFor:'compatibility-squeak'!

results
    ^ self execute
! !

!Statement class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/SQL__Statement.st,v 1.11 2012-05-16 15:11:31 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/SQL__Statement.st,v 1.11 2012-05-16 15:11:31 stefan Exp $'
! !
