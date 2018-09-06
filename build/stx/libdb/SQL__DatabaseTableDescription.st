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

Object subclass:#DatabaseTableDescription
	instanceVariableNames:'name catalog schema type comment'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-Framework'
!

!DatabaseTableDescription class methodsFor:'documentation'!

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

!DatabaseTableDescription methodsFor:'accessing'!

catalog
    ^ catalog
!

comment
    ^ comment
!

name
    ^ name
!

name:nameArg catalog:catalogArg schema:schemaArg type:typeArg 
    "set instance variables (automatically generated)"

    name := nameArg.
    catalog := catalogArg.
    schema := schemaArg.
    type := typeArg.
!

name:nameArg catalog:catalogArg schema:schemaArg type:typeArg comment:commentArg
    "set instance variables (automatically generated)"

    name := nameArg.
    catalog := catalogArg.
    schema := schemaArg.
    type := typeArg.
    comment := commentArg.
!

schema
    ^ schema
!

type
    ^ type
! !

!DatabaseTableDescription methodsFor:'printing'!

printOn:aStream
    aStream
        nextPutAll:self className;
        nextPut:$(.

    catalog notEmptyOrNil ifTrue:[
        aStream 
            nextPutAll:catalog;
            nextPut:$:.
    ].
    name notEmptyOrNil ifTrue:[
        aStream 
            nextPutAll:name.
    ].
    type notEmptyOrNil ifTrue:[
        aStream
            nextPut:$[;
            nextPutAll:type;
            nextPut:$].
    ].
    aStream nextPut:$).
! !

!DatabaseTableDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/SQL__DatabaseTableDescription.st,v 1.6 2012-05-17 21:12:58 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/SQL__DatabaseTableDescription.st,v 1.6 2012-05-17 21:12:58 stefan Exp $'
! !
