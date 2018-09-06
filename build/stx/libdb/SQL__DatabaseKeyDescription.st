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

Object subclass:#DatabaseKeyDescription
	instanceVariableNames:'tableName columnName keyName keySeq stType comment'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-Framework'
!

!DatabaseKeyDescription class methodsFor:'documentation'!

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

!DatabaseKeyDescription methodsFor:'accessing'!

columnName
    ^ columnName
!

columnName:something
    columnName := something.
!

comment
    ^ comment
!

comment:something
    comment := something.
!

keyName
    ^ keyName
!

keyName:something
    keyName := something.
!

keySeq
    ^ keySeq
!

keySeq:something
    keySeq := something.
!

stType
    ^ stType
!

stType:something
    stType := something.
!

tableName
    ^ tableName
!

tableName:something
    tableName := something.
! !

!DatabaseKeyDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/SQL__DatabaseKeyDescription.st,v 1.4 2012-05-16 22:25:57 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/SQL__DatabaseKeyDescription.st,v 1.4 2012-05-16 22:25:57 stefan Exp $'
! !
