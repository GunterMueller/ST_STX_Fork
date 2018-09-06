"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

Object subclass:#OCI8ColumnDescriptor
	instanceVariableNames:'name scale precision nullValue type size'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Descriptors'
!

!OCI8ColumnDescriptor class methodsFor:'documentation'!

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
!

documentation
"
    Information on a table column is stored in this class.

    [author:]
	 Pierre Schwarz


    [instance variables:]
	name <String>
	    Name of the column

	scale <Integer>
	    When describing a number column the scale of the number is stored here

	precision <Integer>
	    When describing a number column the precision of the number is stored here

	nullValue <Boolean>
	    If the column can have null values true is stored here, otherwise false.

	type <Symbol>
	    Type of the column, possible values are:
		#'CHAR_TYPE'
		#'VARCHAR2_TYPE'
		#'ROWID_DESC_TYPE'
		#'LONG_TYPE'
		#'DATE_TYPE'
		#'NUMBER_TYPE'
		#'RAW_TYPE'
		#'LONG_RAW_TYPE'

	size <Integer>
	    Size of the column on the database. For column of type long, long_raw, the size is 0.

    [class variables:]
	none
"
! !

!OCI8ColumnDescriptor methodsFor:'accessing'!

name
"
returns the name of the table column

<return: String>
"
    ^ name
!

name:aString
"
sets the name of the table column

<return: self>
"

    name := aString.
!

nullValue
"
returns if the table column can be NULL or not.

<return: Boolean>
"

    ^ nullValue
!

nullValue:aBoolean
"
sets if the table column can be NULL or not.

<return: self>
"

    nullValue := aBoolean.
!

precision
"
returns the precision of the table column.

<return: Integer>
"

    ^ precision
!

precision:anInteger
"
sets the precision of the table column.

<return: self>
"

    precision := anInteger.
!

scale
"
returns the scale of the table column.

<return: Integer>
"

    ^ scale
!

scale:anInteger
"
sets the scale of the table column.

<return: self>
"

    scale := anInteger.
!

size
"
returns the size of the table column.

<return: Integer>
"

    ^ size
!

size:anInteger
"
sets the size of the table column.

<return: self>
"

    size := anInteger.
!

type
"
returns the type of the table column.

<return: Symbol>
"

    ^ type
!

type:aSymbol
"
sets the type of the table column

<return: self>
"

    type := aSymbol.
! !

!OCI8ColumnDescriptor methodsFor:'comparing'!

= aColumnDescriptor

    ^ name = aColumnDescriptor name
      and:[scale = aColumnDescriptor scale
      and:[precision = aColumnDescriptor precision
      and:[type = aColumnDescriptor type
      and:[size = aColumnDescriptor size
      and:[nullValue = aColumnDescriptor nullValue]]]]].
!

hash
    ^ name hash
! !

!OCI8ColumnDescriptor methodsFor:'generating'!

newConverter
"
returns of the type of the column a converter which handles the
receivment of the data and the conversion to the correct smalltalk type.

<return: OCI8StringConverter|OCI8LongConverter|OCI8FloatConverter|
	 OCI8IntegerConverter|OCI8FixedPointConverter|OCI8ByteArrayConverter>
"

    (#(#'CHAR_TYPE' #'VARCHAR2_TYPE' #'ROWID_DESC_TYPE') includes:type) ifTrue:[
	^ OCI8StringConverter new.
    ].

    (#'LONG_TYPE') == type ifTrue:[
	^ OCI8LongConverter new.
    ].

    (#'DATE_TYPE' == type) ifTrue:[
	^ OCI8DateConverter new.
    ].

    (#'NUMBER_TYPE' == type) ifTrue:[
	(scale= -127 and:[precision ~= 0]) ifTrue:[
	    "floats"
	    ^ OCI8FloatConverter new.
	].
	scale = 0 ifTrue:[
	    "integer"
	    ^ OCI8IntegerConverter new.
	].
	"all other number are converted to fixed points"
	^ OCI8FixedPointConverter new.
    ].

    (#(#'RAW_TYPE' #'LONG_RAW_TYPE') includes:type) ifTrue:[
	^ OCI8ByteArrayConverter new.
    ].
! !

!OCI8ColumnDescriptor methodsFor:'printing & storing'!

printOn:aStream

    aStream nextPutAll:self class name; nextPut:$(.
    name printOn:aStream.
    aStream nextPut:$)

! !

!OCI8ColumnDescriptor methodsFor:'testing'!

isPiecewiseType
"
checks if the type must be piecewised fetched.
Here only the long and long raw type must be fetched piecewise. The types raw and
varchar2 can also be fetched piecewise, but for performance issues we will fetch
them en block.

<return: Boolean>
"

    ^(self type == #'LONG_TYPE') or:[self type == #'LONG_RAW_TYPE']
! !

!OCI8ColumnDescriptor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8ColumnDescriptor.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !
