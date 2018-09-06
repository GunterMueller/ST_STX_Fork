"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCI8Statement subclass:#OCI8StatementWithVariables
	instanceVariableNames:'arrayBind bindDescriptors'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Statements'
!

!OCI8StatementWithVariables class methodsFor:'documentation'!

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
    This is an abstract class defining common properties of SQL-Statements
    with bind variables.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!OCI8StatementWithVariables methodsFor:'accessing'!

arrayBind
"
returns true if the statement does an array insert (multiple values for one bind variable),
false if not.

<return: aBoolean|nil>
"

    ^ arrayBind
!

arrayBind:aBoolean
"
set to true if the statement does an array insert (multiple values for one bind variable),
false if not.

<return: self>
"
    arrayBind := aBoolean.
!

bindDescriptors
    "return a dictionary with descriptors describing the bind variables in the receivers text
     (see OCI8BindDescriptor)"

    ^ bindDescriptors
! !

!OCI8StatementWithVariables methodsFor:'accessing variables'!

at:variableName put:value
    "set the bind variable varaibleName to value"

    |desc|

    desc := bindDescriptors at:variableName ifAbsent:nil.
    desc isNil ifTrue:[
	SQLError raiseErrorString:'non-existing variable name'.
    ].
    desc buffer at:1 put:value.
! !

!OCI8StatementWithVariables methodsFor:'binding'!

computeBindDescriptors
    "compute the bind descriptors for this statement (valid after preparing)"

    bindDescriptors := handle getBindInfoWithErrorHandle:self errorHandle
!

doBind:valueArray
    "perform the binding of all bind variables"

    |errorHandle nColumns nRows buffers rowIndex maxSizes columnTypes|

    nRows := valueArray size.
    nRows == 0 ifTrue:[
	^ self.
    ].
    nColumns := bindDescriptors size.
    buffers := Array new:nColumns.
    maxSizes := Array new:nColumns.
    columnTypes := Array new:nColumns.

    "find out about column sizes and column types"
    valueArray do:[:eachRow|
	eachRow keysAndValuesDo:[:columnIndex :eachValue|
	    |sz maxSize|

	    eachValue notNil ifTrue:[
		(columnTypes at:columnIndex) isNil ifTrue:[
		    columnTypes at:columnIndex put:eachValue class.
		].

		sz := eachValue size.
		sz ~~ 0 ifTrue:[
		    maxSize := maxSizes at:columnIndex.
		    (maxSize isNil or:[maxSize < sz]) ifTrue:[
			maxSizes at:columnIndex put:sz
		    ].
		].
	    ].
	].
    ].

    "allocate buffers"
    errorHandle := self errorHandle.
    bindDescriptors do:[:eachBindDescriptor| |buffer position|
	position := eachBindDescriptor position.
	buffer := self parameterBufferFor:(columnTypes at:position)
		       elements:nRows
		       withSize:(maxSizes at:position).
	buffers at:position put:buffer.
	eachBindDescriptor buffer:buffer.
	eachBindDescriptor bindTo:handle errorHandle:errorHandle.
    ].

    rowIndex := 1.
    valueArray do:[:eachRow|
	eachRow with:buffers do:[:eachValue :eachBuffer|
	    eachBuffer at:rowIndex put:eachValue.
	].
	rowIndex := rowIndex + 1.
    ].
! !

!OCI8StatementWithVariables methodsFor:'binding new'!

bindVariable:positionOrName as:aSmalltalkClass size:sizeOrNil
    ^ self
	bindVariable:positionOrName
	buffer:(self parameterBufferFor:aSmalltalkClass size:sizeOrNil)
	size:sizeOrNil
!

bindVariable:positionOrName buffer:aParameterBuffer size:sizeOrNil
    "add a type specific buffer for a bind name"

    |desc old|

    desc := bindDescriptors at:positionOrName ifAbsent:nil.
    desc isNil ifTrue:[
	^ SQLError raiseErrorString:' - non-existant bind variable ', positionOrName.
    ].
    old := desc buffer.
    old notNil ifTrue:[
	old release.
    ].
    desc buffer:aParameterBuffer
!

parameterBufferFor:aSmalltalkClass elements:nElements withSize:maxElementLen

"/    aSmalltalkClass acceptVisitor:(OCI8BufferAllocator new bufferSize:sizeOrNil)
    aSmalltalkClass == String ifTrue:[
	^ OCIStringBuffer elements:nElements withSize:maxElementLen
    ].
    aSmalltalkClass == SmallInteger ifTrue:[
	^ OCINumberBuffer elements:nElements withSize:nil
    ].
    aSmalltalkClass == Timestamp ifTrue:[
	^ OCIDateBuffer elements:nElements withSize:nil
    ].
    aSmalltalkClass == ByteArray ifTrue:[
	^ OCIRawBuffer elements:nElements withSize:maxElementLen
    ].
    aSmalltalkClass == OCI8Handle::OCI8RowIdDescriptor ifTrue:[
	^ OCIRowIdDescriptorBuffer elements:nElements withSize:nil.
    ].
    (aSmalltalkClass isSubclassOf:String) ifTrue:[
	^ OCIStringBuffer elements:nElements withSize:maxElementLen
    ].
    (aSmalltalkClass isSubclassOf:Number) ifTrue:[
	^ OCINumberBuffer elements:nElements withSize:nil
    ].
    (aSmalltalkClass isSubclassOf:Boolean) ifTrue:[
	^ OCIBooleanBuffer elements:nElements withSize:nil
    ].
    (aSmalltalkClass isSubclassOf:AbstractTime) ifTrue:[
	^ OCIDateBuffer elements:nElements withSize:nil
    ].
    (aSmalltalkClass isSubclassOf:UninterpretedBytes) ifTrue:[
	^ OCIRawBuffer elements:nElements withSize:maxElementLen
    ].

    ^ SQLError raiseErrorString:'unknown data type'
! !

!OCI8StatementWithVariables methodsFor:'declaring bind variables'!

booleanBindVariable:aStringOrSymbol
    "declare a bind variable as Boolean"

    self addBindName:aStringOrSymbol buffer:(OCIBooleanBuffer new)
!

byteBindVariable:aStringOrSymbol
    "declare a bind variable as bytes (ByteArray)"

    self addBindName:aStringOrSymbol buffer:(OCIRawBuffer new)
!

dateBindVariable:aStringOrSymbol
    "declare a bind variable as date"

    self addBindName:aStringOrSymbol buffer:(OCIDateBuffer new)
!

integerBindVariable:aStringOrSymbol
    "declare a bind variable as integer"

    self addBindName:aStringOrSymbol buffer:(OCINumberBuffer new)
!

stringBindVariable:aStringOrSymbol
    "declare a bind variable as string"

    self addBindName:aStringOrSymbol buffer:(OCIStringBuffer new)
! !

!OCI8StatementWithVariables methodsFor:'initialization'!

initializeHandle:statementHandle textBuffer:aStatementTextBuffer
    "this is called after an instance has been created.
     Initialize my basic state"

    super initializeHandle:statementHandle textBuffer:aStatementTextBuffer.
    self computeBindDescriptors.
! !

!OCI8StatementWithVariables methodsFor:'private'!

addBindName:aStringOrSymbol buffer:anOCIDataBuffer
    "add a type specific buffer for a bind name"

    |desc old|

    desc := bindDescriptors at:aStringOrSymbol ifAbsent:nil.
    desc isNil ifTrue:[
	^ SQLError raiseErrorString:' - non-existant bind variable ', aStringOrSymbol.
    ].
    old := desc buffer.
    desc notNil ifTrue:[
	desc release.
    ].
    desc buffer:anOCIDataBuffer
! !

!OCI8StatementWithVariables class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8StatementWithVariables.st,v 1.7 2016-10-13 00:15:08 cg Exp $'
! !
