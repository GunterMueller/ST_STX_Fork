"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

Cursor subclass:#OCICursor
	instanceVariableNames:'statement rowSize buffersByName buffersByIndex objectClass'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Statements'
!


!OCICursor class methodsFor:'documentation'!

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

!OCICursor methodsFor:'accessing'!

buffersByIndex
    ^ buffersByIndex
!

buffersByIndex:something
    buffersByIndex := something.
!

buffersByName
    ^ buffersByName
!

buffersByName:something
    buffersByName := something.
!

statement
    ^ statement
!

statement:something
    statement := something.
    rowSize := statement columnDescriptors size.
! !

!OCICursor methodsFor:'accessing columns'!

at:columnNameString
    "return the value of the current row/column named columnNameString"

    buffersByName isNil ifTrue:[
	self setUpBuffersByName
    ].

    ^ (buffersByName at:columnNameString) at:1
!

atIndex:columnIndex
    "return the value in the current row/column number columnIndex (1-based)"

    buffersByName isNil ifTrue:[
	self setUpBuffersByIndex
    ].

    ^ (buffersByIndex at:columnIndex) at:1
!

columnNames
    "answer an array containing the column names of the query"

    ^ statement columnDescriptors collect:[:eachDescriptor| eachDescriptor name]
!

fetchInto:anObject
    "fetch the data from the current row into an object"

    buffersByName isNil ifTrue:[
	self setUpBuffersByName
    ].
    buffersByName keysAndValuesDo:[:eachName :eachBuffer |
	anObject perform:(eachName , ':') asSymbol with:(eachBuffer at:1).
    ].
!

rowAsArray
    "answer the current row as array"

    buffersByIndex isNil ifTrue:[
	self setUpBuffersByIndex
    ].
    ^ buffersByIndex collect:[:eachBuffer | eachBuffer at:1 ]
!

rowAsDictionary
    "answer the current row as a Dictionary
     (columnName->columnValue)"

    |newDictionary|

    buffersByName isNil ifTrue:[
	self setUpBuffersByName
    ].
    newDictionary := Dictionary new:rowSize.
    buffersByName
	keysAndValuesDo:[:eachName :eachBuffer | newDictionary at:eachName put:(eachBuffer at:1) ].
    ^ newDictionary
!

rowAsObject
    "answer the current row as an object which understands getter methods as per column"

    |names inst session|

    buffersByName isNil ifTrue:[
	self setUpBuffersByName
    ].
    session := statement session.

    objectClass isNil ifTrue:[

	objectClass := session cachedRowObjectClasses at:names ifAbsentPut:[
	    |cls itsSuperClass|

	    itsSuperClass := DatabaseRowObject.

	    cls := ClassDescription basicNew.
	    cls
		setSuperclass:itsSuperClass
		methodDictionary:(MethodDictionary new:names size)
		instSize:0
		flags:(ClassDescription flagBehavior).

	    cls instSize:buffersByName size + (itsSuperClass instSize).
	    cls setInstanceVariableString:names.
	    names do:[:eachInstVarName |
		|m|

		m := Compiler
			    compile:(eachInstVarName , ' ^ ',eachInstVarName)
			    forClass:cls
			    install:false.

		"/ cg: can use primAddSelector (which does not flush caches),
		"/ because this is a new class, which has never been instanciated
		"/ (therefore, no caches refer to this class yet).
		cls
		    primAddSelector:eachInstVarName asSymbol
		    withMethod:m.

		m := Compiler
			    compile:(eachInstVarName, ':anObject', ' ',eachInstVarName, ':= anObject')
			    forClass:cls
			    install:false.
		cls
		    primAddSelector:(eachInstVarName,':') asSymbol
		    withMethod:m.
	    ].
	    cls
	].
    ].
    inst := (Array new:objectClass superclass instSize) , buffersByName.
    inst changeClassTo:objectClass.
    ^ inst
!

rowId
    "answer the rowId of the current row"

    ^ statement rowId
! !

!OCICursor methodsFor:'positioning'!

next
    "advance the cursor to the next row"

    statement isNil ifTrue:[
	SQLError raiseErrorString:' - stale cursor'
    ].
    statement next
! !

!OCICursor methodsFor:'private'!

setUpBuffersByIndex

    |columnDescriptors|

    columnDescriptors := statement columnDescriptors.

    buffersByIndex := columnDescriptors collect:[:eachDescriptor| eachDescriptor buffer].
!

setUpBuffersByName

    |columnDescriptors|

    columnDescriptors := statement columnDescriptors.

    buffersByName := Dictionary new:rowSize.
    columnDescriptors do:[:eachDescriptor|
	buffersByName at:eachDescriptor name put:eachDescriptor buffer
    ].
! !

!OCICursor methodsFor:'queries'!

rowSize
    "return the number of columns in each row"

    ^ rowSize
! !

!OCICursor methodsFor:'releasing'!

cancel
    "cancel the cursor, no further access is possible"

    statement cancel.
    statement := nil.
! !

!OCICursor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCICursor.st,v 1.7 2010-10-11 12:00:05 cg Exp $'
! !
