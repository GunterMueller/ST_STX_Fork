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
"{ Package: 'stx:libdb/libsqlite' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SQLiteColumnDescription
	instanceVariableNames:'index name typeId'
	classVariableNames:''
	poolDictionaries:'SqliteResultCodes'
	category:'DataBase-SQLite'
!

!SQLiteColumnDescription class methodsFor:'documentation'!

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

!SQLiteColumnDescription class methodsFor:'instance creation'!

name: name index: index type: typeId
    "Returns new descriptor with given name, index and
     type. typeId must be a valid SQLITE type id
     (SQLITE_INTEGER, SQLITE_FLOAT. ...)"

    ^self new setName:name index: index type:typeId

    "Created: / 14-05-2012 / 14:51:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteColumnDescription methodsFor:'accessing'!

columnNumber
    "return the columns index (1..)"

    ^ index
!

columnSize
    "return the columns size (in bytes)"

    ^ nil "/Not valid for SQLite

    "Modified: / 14-05-2012 / 14:53:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

comment
    ^ nil "/No comments in SQLite

    "Modified: / 14-05-2012 / 14:53:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

index
    "return the columns index."

    ^ index
!

lenght
    <resource: #obsolete>
    self obsoleteMethodWarning:'Bad spelling. Use #length'.
    ^ self length

    "Modified: / 14-05-2012 / 14:53:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-05-2017 / 22:05:43 / mawalch"
!

length
    "return the columns size (in bytes)"

    ^ self columnSize

    "Created: / 24-05-2017 / 22:05:23 / mawalch"
!

name
    "return the columns name."

    ^ name
!

nullable
    "return true if column admits NULL;  false otherwise"

    ^ true

    "Modified: / 14-05-2012 / 14:54:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scale
    ^ nil "/Not valid for SQLite

    "Modified: / 14-05-2012 / 14:54:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setName: nm index: idx type: tId

    index := idx.
    name := nm.
    typeId := tId

    "Modified: / 14-05-2012 / 15:04:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stType
    "return the Smalltalk class which will be used to hold data
     from the column, or nil if unknown."

    ^ self type

    "Modified: / 14-05-2012 / 14:54:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    "return the Smalltalk class which will be used to hold data
     from the column, or nil if unknown."

    typeId == SQLITE_INTEGER ifTrue:[
        ^Integer
    ] ifFalse:[
    typeId == SQLITE_FLOAT ifTrue:[
        ^Float
    ] ifFalse:[
    typeId == SQLITE_TEXT ifTrue:[
        ^String
    ] ifFalse:[
    typeId == SQLITE_NULL ifTrue:[
        self breakPoint: #jv. "/when this could happen?
        ^UndefinedObject
    ] ifFalse:[
    typeId == SQLITE_BLOB ifTrue:[
        self error: 'Not (yet) supported. Need to read docs'.
        ^ByteArray
    ]]]]].

    self error: 'Unssuported column type'.
    ^nil

    "Modified: / 14-05-2012 / 15:04:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteColumnDescription methodsFor:'accessing-private'!

typeId
    ^ typeId
! !

!SQLiteColumnDescription methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:(self class name).
    aStream nextPutAll:'('.
    aStream nextPutAll:'index='.
    index printOn:aStream.
    aStream nextPutAll:' name='.
    name printOn:aStream.
    aStream nextPutAll:' type='.
    typeId printOn:aStream.
    aStream nextPutAll:')'.

    "Modified: / 14-05-2012 / 15:09:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteColumnDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SQLiteColumnDescription.st,v 1.3 2017-05-24 20:29:48 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SQLiteColumnDescription.st,v 1.3 2017-05-24 20:29:48 mawalch Exp $'
! !

