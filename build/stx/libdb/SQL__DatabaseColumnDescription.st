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

Object subclass:#DatabaseColumnDescription
	instanceVariableNames:'index name stType characterEncoder columnSize precision scale
		nullable comment'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-Framework'
!

!DatabaseColumnDescription class methodsFor:'documentation'!

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

!DatabaseColumnDescription methodsFor:'accessing'!

characterEncoder
    ^ characterEncoder
!

characterEncoder:something
    characterEncoder := something.
!

columnNumber
    "return the columns index (1..)"

    ^ index
!

columnNumber:columnNumberArg name:nameArg type:typeArg columnSize:columnSizeArg scale:scaleArg nullable:nullableArg 
    "set instance variables"

    index := columnNumberArg.
    name := nameArg.
    stType := typeArg.
    columnSize := columnSizeArg.
    scale := scaleArg.
    nullable := nullableArg.
!

columnSize
    "return the columns size (in bytes)"

    ^ columnSize
!

comment
    ^ comment
!

comment:something
    comment := something.
!

index
    "return the columns index."

    ^ index
!

lenght
    <resource: #obsolete>
    self obsoleteMethodWarning:'Bad spelling. Use #length'.
    ^ self length

    "Modified: / 24-05-2017 / 22:04:37 / mawalch"
!

length
    "return the columns size (in bytes)"

    ^ columnSize

    "Created: / 24-05-2017 / 22:03:35 / mawalch"
!

name
    "return the columns name."

    ^ name
!

nullable
    "return true if column admits NULL;  false otherwise"

    ^ nullable
!

scale
    ^ scale
!

stType
    "return the Smalltalk class which will be used to hold data
     from the column, or nil if unknown."

    ^ stType
!

stType:something
    stType := something.
!

type
    "return the Smalltalk class which will be used to hold data
     from the column, or nil if unknown."

    ^ stType
!

type:something
    stType := something.
! !

!DatabaseColumnDescription methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:(self class name).
    aStream nextPutAll:'('.
    aStream nextPutAll:'index='.
    index printOn:aStream.
    aStream nextPutAll:' name='.
    name printOn:aStream.
    aStream nextPutAll:' type='.
    stType printOn:aStream.
    aStream nextPutAll:')'.
! !

!DatabaseColumnDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/SQL__DatabaseColumnDescription.st,v 1.9 2017-05-24 20:29:47 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/SQL__DatabaseColumnDescription.st,v 1.9 2017-05-24 20:29:47 mawalch Exp $'
! !

