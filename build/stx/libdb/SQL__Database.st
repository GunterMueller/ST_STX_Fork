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

Object subclass:#Database
	instanceVariableNames:''
	classVariableNames:'Registry'
	poolDictionaries:''
	category:'DataBase-SQL-Framework'
!

!Database class methodsFor:'documentation'!

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

!Database class methodsFor:'connection'!

newConnectionForUri:uriString 
    "get a connection for a given uri"

    ^ self 
        newConnectionForUri:uriString
        user:nil
        password:nil

    "
     Database newConnectionForUri:'stdb:odbc://localhost/test'
    "
!

newConnectionForUri:uriString user:userString password:passwordString 
    "get a connection for a given uri"

    |handler|

    self ~~ Database ifTrue:[
        ^ self subclassResponsibility
    ].
    handler := self findHandlerForUri:uriString.
    ^ handler 
        newConnectionForUri:uriString
        user:userString
        password:passwordString

    "
     Database newConnectionForUri:'stdb:odbc://localhost/test' user:'scott' password:'tiger'
     Database newConnectionForUri:'stdb:oracle://localhost/test'  user:'scott' password:'tiger'
    "
! !

!Database class methodsFor:'private'!

findHandlerForUri:uriString
    "find a database handler for a given uri string.
     Search through our registry and return the handler registered with the
     longest prefix. Raise an error, if no handler is found."

    |maxLen handler|

    maxLen := 0.

    Registry keysAndValuesDo:[:k :v|
        (k size > maxLen and:[uriString startsWith:k]) ifTrue:[
            maxLen := k size.
            handler := v.
        ]
    ].

    handler isNil ifTrue:[
        self error:'no SQL Handler'.
    ].

    ^ Smalltalk classNamed:handler

    "
     Database findHandlerForUri:'stdb:oracle://test'
     Database findHandlerForUri:'stdb:odbc://test'  
    "
! !

!Database class methodsFor:'registration'!

initialize

    Registry := Dictionary new.

    "
     self initialize
    "
!

registerForUriPrefix:aString
    "register a class with a given URI-Prefix, so the corresponding Database Interface
     can be selecten when parsing URIs"

    Registry at:aString put:self name
! !

!Database class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/SQL__Database.st,v 1.9 2009-10-07 08:02:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/SQL__Database.st,v 1.9 2009-10-07 08:02:46 cg Exp $'
! !

Database initialize!
