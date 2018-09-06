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
"{ Package: 'stx:libdb/libodbc' }"

"{ NameSpace: SQL }"

DatabaseColumnDescription subclass:#ODBCColumnDescription
	instanceVariableNames:'sqlTypeNr sqlType cType preferWideChar details'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-ODBC'
!

!ODBCColumnDescription class methodsFor:'documentation'!

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

!ODBCColumnDescription class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!ODBCColumnDescription methodsFor:'accessing'!

cType
    "return (for now ?) a database specific c-type descriptor;
     typically, this is a symbol.
     This interface is not stable."

    ^ cType
!

description
    ^ self comment
!

description:something
    self comment:something.
!

details
    ^ details
!

details:something
    details := something.
!

index
    ^ index
!

preferWideChar
    ^ preferWideChar ? false
!

preferWideChar:something
    preferWideChar := something.
!

setSqlTypeNr:something
    sqlTypeNr := something.
!

sqlType
    "return (for now ?) a database specific sql-type descriptor;
     typically, this is a symbol.
     This interface is not stable."

    ^ sqlType
!

sqlType:something
    sqlType := something.
    preferWideChar ~~ true ifTrue:[
        preferWideChar := #(SQL_WCHAR SQL_WVARCHAR SQL_WLONGVARCHAR 
                        SQL_UNICODE SQL_UNICODE_VARCHAR 
                        SQL_UNICODE_LONGVARCHAR SQL_UNICODE_CHAR) includes:something.
    ].
!

sqlTypeNr
    ^ sqlTypeNr
!

sqlTypeNr:something
    sqlTypeNr := something.
    self sqlType:(ODBCHandle sqlTypeSymbolFromSqlTypeNumber:sqlTypeNr).
! !

!ODBCColumnDescription methodsFor:'binding'!

bindingsBufferForStatement:statement
    |eachBindBuffer sqlTypeSymbol|

    sqlTypeSymbol := self sqlType.

    ((sqlTypeSymbol == #'SQL_CHAR' 
      or:[sqlTypeSymbol = #'SQL_VARCHAR' or:[sqlTypeSymbol = #'SQL_LONGVARCHAR']])
     and:[self preferWideChar]) ifTrue:[
        sqlTypeSymbol := #'SQL_WCHAR'.
    ].

    eachBindBuffer := ODBCStatement::BindingsBuffer
                        bufferForColumnDescriptor:self.

    eachBindBuffer
        setupForValues:#();
        allocateBuffer:1;
        sqlBindColForStatement:statement handle:statement getHandle.

    ^ eachBindBuffer
! !

!ODBCColumnDescription methodsFor:'converting'!

decodeStringAsBoolean:value
    (value = 'true' or:[value = '1' or:[value = 'y' or:[value = 'Y' or:[value = 'YES']]]]) ifTrue:[
        ^ true.
    ].
    (value = '' or:[value = 'false' or:[value = '0' or:[value = 'n' or:[value = 'N' or:[value = 'NO']]]]]) ifTrue:[
        ^ false.
    ].
    ^ ConversionError raiseRequestWith:value errorString:' - ODBC Boolean conversion'.
! !

!ODBCColumnDescription methodsFor:'fetching'!

sqlGetDataForStatement:statement
    "returns a value - not a returnCode"

    |handle retVal valueHolder value 
     finalType dayOrNil month year hourOrNil minute second nanosecond|

    handle := statement getHandle.

    valueHolder := Array new:11.
    retVal := handle 
                sqlGetData:index 
                sqlTypeNr:sqlTypeNr 
                buffer:nil
                preferWideChar:preferWideChar
                into:valueHolder.

    "this is a noo-op if ret is success"
    retVal performErrorHandlingFor:handle statement:statement.

    value := valueHolder at:1.
    value isNil ifTrue:[
        ^ nil.
    ].
    cType := valueHolder at:3.

    (cType == #'SQL_C_CHAR' or:[cType == #'SQL_C_WCHAR']) ifTrue:[
        stType notNil ifTrue:[
            stType == Boolean ifTrue:[
                ^ self decodeStringAsBoolean:value.
            ].
            finalType := stType.
        ] ifFalse:[sqlType == #'SQL_NUMBER' ifTrue:[
            finalType := Number.
        ] ifFalse:[(sqlType == #'SQL_BIGINT' or:[sqlType == #'SQL_INTEGER']) ifTrue:[
            finalType := Integer.
        ]]].
        finalType notNil ifTrue:[
            ^ finalType readFrom:value onError:[ConversionError raiseRequestWith:value].
        ].

        sqlType == #'SQL_DECIMAL' ifTrue:[
            "convert to integer if possible - Oracle returns decimal for integer columns"
            scale == 0 ifTrue:[
                ^ Integer readFrom:value onError:[ConversionError raiseRequestWith:value].
            ] ifFalse:[
                ^ (FixedPoint readFrom:value onError:[ConversionError raiseRequestWith:value]) scale:scale.
            ]
        ].
        (valueHolder at:11 "hasMoreData") ifTrue:[
            "this happens only with some odbc drivers, which do not tell the actual data size.
             See: https://msdn.microsoft.com/en-us/library/jj219209.aspx"
            |valueStream buffer|
        
            valueStream := WriteStream with:value.
            buffer := value species new:4096.
            [
                retVal := handle 
                            sqlGetData:index 
                            sqlTypeNr:sqlTypeNr 
                            buffer:buffer 
                            preferWideChar:preferWideChar
                            into:valueHolder.

                "this is a noo-op if ret is success"
                retVal performErrorHandlingFor:handle statement:statement.

                valueStream nextPutAll:buffer startingAt:1 to:(valueHolder at:2 "valueSize").
            ] doWhile:[valueHolder at:11 "hasMoreData"].
        ].
        characterEncoder notNil ifTrue:[
            ^ characterEncoder decodeString:value.
        ].
        ^ value
    ].

    cType == #'SQL_C_BINARY' ifTrue:[
        stType notNil ifTrue:[
            ^ stType fromBytes:value.
        ].
        ^ value.
    ].

    cType == #'SQL_C_GUID' ifTrue:[
        ^ (stType ? UUID) fromBytes:value.
    ].

    (cType == #'SQL_C_DATE' or:[cType == #'SQL_C_TIME' or:[cType == #'SQL_C_TIMESTAMP']]) ifTrue:[
        dayOrNil := valueHolder at:4.
        month := valueHolder at:5.
        year := valueHolder at:6.
        hourOrNil := valueHolder at:7.
        minute := valueHolder at:8.
        second := valueHolder at:9.
        nanosecond := valueHolder at:10.

        cType == #'SQL_C_DATE' ifTrue:[
            dayOrNil isNil ifTrue:[^ nil].
            ^ (stType ? Date) newDay:dayOrNil month:month year:year
        ].
        cType == #'SQL_C_TIME' ifTrue:[
            hourOrNil isNil ifTrue:[^ nil].
            ^ (stType ? Time) hours:hourOrNil minutes:minute seconds:second
        ].
        cType == #'SQL_C_TIMESTAMP' ifTrue:[
            dayOrNil isNil ifTrue:[^ nil].
            ^ (stType ? Timestamp) 
                year:year month:month day:dayOrNil
                hour:hourOrNil minute:minute second:second millisecond:(nanosecond // 1000000).
        ].
    ].
    stType == Boolean ifTrue:[
        ^ value ~~ 0.
    ].

    ^ value
! !

!ODBCColumnDescription methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    preferWideChar := false.

    "/ super initialize.   -- commented since inherited method does nothing
! !

!ODBCColumnDescription methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:(self class name).
    aStream nextPutAll:'(index='.
    index printOn:aStream.
    aStream nextPutAll:' name='.
    name printOn:aStream.
    aStream nextPutAll:' type='.
    sqlType printOn:aStream.
    aStream nextPut:$).
! !

!ODBCColumnDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCColumnDescription.st,v 1.21 2016-03-01 20:35:51 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCColumnDescription.st,v 1.21 2016-03-01 20:35:51 stefan Exp $'
! !

