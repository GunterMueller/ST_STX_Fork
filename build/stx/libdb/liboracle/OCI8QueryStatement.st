"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCI8StatementWithVariables subclass:#OCI8QueryStatement
	instanceVariableNames:'columnDescriptors fetchingFinished pieceSize prefetchedRows'
	classVariableNames:'PrefetchRowCount'
	poolDictionaries:''
	category:'DataBase-Oracle-Statements'
!

!OCI8QueryStatement class methodsFor:'documentation'!

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
    All query statements are represented by this class.
    To execute a data manipulation statement call:
	OCI8Session>>executeStatement:from:
	OCI8Session>>executeStatement:from:into:
	OCI8Session>>executeStatement:from:into:numberOfRows:
	OCI8Session>>executeStatement:into:
	OCI8Session>>executeStatement:into:numberOfRows:

    When an query statement is executed an fetch will be done automatically. The number
    of rows to be returned can be set. If this is done the rest of the rows can be fetched later.
    For example:
    session executeStatement:selectStatement into:resultStream numberOfRows:5.
    session fetchDataForStatement:selectStatement into:resultStream numberOfRows:10.
    Only the number of rows available will be fetched. No error signal is raised if
    the numbers in numberOfRows:anInteger is higher than the number of rows returned.

    [author:]
	Pierre Schwarz

    [see also:]
	OCI8Statement
	OCI8DDStatement
	OCI8DMStatement

    [instance variables:]
	columnDescriptors  <OrderedCollection>
	    if a statement is executed the column descriptors (which have a description of the
	    selected columns) are available here.

	defined <Boolean>
	    is true if the statement define variables are generated and setup. False if not.

	fetchingFinished <Boolean>
	    is true if the statements fetch operation is finished. Prevents that any other
	    oci fetch operation could be call if the flag is true. Because that would raise an
	    oci error.

	ociDefineVariables <OrderedCollection>
	    the define variables for each column are hold here.

	pieceSize <Integer>
	    holds how many bytes should be fetched for a piecewise operation. If the statement
	    includes a long or long raw column, the rows are fetched pieces wise.
	    The number of bytes to be fetched by each server round trip has an important impact
	    onto the performace of statement execution. A higher number reduces the necessary
	    server roundtrips. The default is 30000 bytes rows per roundtrip.

	prefetchedRows <Integer>
	    holds how many rows should be prefetched for the statement by the oci lib.
	    The number of prefetched rows has an important impact onto the performace
	    of statement execution. A higher number reduces the necessary server roundtrips.
	    The default is 100 rows per roundtrip.

    [class variables:]
	    none
"
! !

!OCI8QueryStatement class methodsFor:'initialization'!

initialize
    "initialize the class variables"


    "This is the default number of rows, that should be prefetched
     into the internal OCI buffers on queries.
     This number can be changed for a single select statement"

    PrefetchRowCount := 100.

    "
	self initialize
    "
! !

!OCI8QueryStatement class methodsFor:'examples'!

example_createTable
"
create the table querytest for the examples of this class and insert some values.

					[exBegin]
    |session dropTableStatement createTableStatement insertStatement data|

    session := OCI8Session default.
    dropTableStatement := session newStatementFor:'drop table querytest'.
    createTableStatement := session newStatementFor:'create table querytest (id number, name varchar2(100))'.
    insertStatement := session newStatementFor:'insert into querytest values(:id, :name)'.
    insertStatement integerBindVariable:#id.
    insertStatement stringBindVariable:#name.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    OCIErrorSignal handle:[:ex |
    ] do:[
	    session executeStatement:dropTableStatement.
    ].
    OCIErrorSignal handle:[:ex |
    ] do:[
	    session executeStatement:createTableStatement.
    ].

    data := OrderedCollection new.
    1 to: 10000 do:[:i | data add:(Array with:i with:('number ',i printString))].
    session executeStatement:insertStatement from:data.

    session disconnect.
					[exEnd]
"


!

example_selectStatement1
"
read from the test table an inspect the column descriptor of the statement
(they hold the description of the column you read), the number of rows and
the content received. All rows are fetched

					[exBegin]
    |session selectStatement resultStream|

    session := OCI8Session default.
    selectStatement := session newStatementFor:'select * from querytest'.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    resultStream := WriteStream on:Array new.
    session executeStatement:selectStatement into:resultStream.
    selectStatement columnDescriptors inspect.
    selectStatement processedRows inspect.
    resultStream contents inspect.

    session disconnect.
					[exEnd]
"


!

example_selectStatement2
"
read from the test table an inspect the column descriptor of the statement
(that is the description of the tables you read), the number of rows read and
the content received. Only 5 rows are fetched via the implicit fetch at execution
time of the statement.

					[exBegin]
    |session selectStatement resultStream|

    session := OCI8Session default.
    selectStatement := session newStatementFor:'select * from querytest'.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    resultStream := WriteStream on:Array new.
    session executeStatement:selectStatement into:resultStream numberOfRows:5.
    selectStatement columnDescriptors inspect.
    selectStatement processedRows inspect.
    resultStream contents inspect.

    session disconnect.
					[exEnd]
"


!

example_selectStatement2b
"
read from the test table an inspect the column descriptor of the statement
(that is the description of the tables you read), the number of rows read and
the content received. Only 5 rows are fetched via the implicit fetch at execution
time of the statement. The other 10 rows are fetched with an extra call.

					[exBegin]
    |session selectStatement resultStream|

    session := OCI8Session default.
    selectStatement := session newStatementFor:'select * from querytest'.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    resultStream := WriteStream on:Array new.
    session executeStatement:selectStatement into:resultStream numberOfRows:5.
    session fetchDataForStatement:selectStatement into:resultStream numberOfRows:10.

    selectStatement columnDescriptors inspect.
    selectStatement processedRows inspect.
    resultStream contents inspect.

    session disconnect.
					[exEnd]
"
!

example_selectStatement2c
"
read from the test table an inspect the content in stream resultStream1 and resultStream2.
All rows are fetched via the implicit fetch at execution
time of the statement, because numberOfRows is nil. The rextra fetch will return
an empty stream.

					[exBegin]
    |session selectStatement resultStream1 resultStream2|

    session := OCI8Session default.
    selectStatement := session newStatementFor:'select * from querytest'.
    selectStatement prefetchedRows:1000.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    resultStream1 := WriteStream on:Array new.
    session executeStatement:selectStatement into:resultStream1 numberOfRows:nil.
    resultStream1 contents inspect.
    resultStream2 := WriteStream on:Array new.
    session fetchDataForStatement:selectStatement into:resultStream2 numberOfRows:100.
    resultStream2 contents inspect.

    session disconnect.
					[exEnd]
"
!

example_selectStatement3a
"
read from the test table the row with id = 10 and inspect the content received.
All variables in the statement must be bound via

    OCI8Statement>>byteBindVariable:       (for variables which hold bytes e.g. ByteArray)                 or
    OCI8Statement>>fixedPointBindVariable: (for variables which hold fixed point numbers e.g. FixedPoint)  or
    OCI8Statement>>floatBindVariable:      (for variables which hold float numbers e.g. Float)             or
    OCI8Statement>>integerBindVariable:    (for variables which hold integer numbers e.g. Integer)         or
    OCI8Statement>>stringBindVariable:     (for variables which hold strings e.g. String)

					[exBegin]
    |session selectStatement resultStream|

    session := OCI8Session default.
    selectStatement := session newStatementFor:'select * from querytest where id = :id'.
    selectStatement integerBindVariable:#id.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    resultStream := WriteStream on:Array new.
    session executeStatement:selectStatement from:#(10) into:resultStream.
    resultStream contents inspect.

    session disconnect.
					[exEnd]
"


!

example_selectStatement3b
"
read from the test table the rows with name like '1%9%' and inspect the content received.
All variables in the statement must be bound via

    OCI8Statement>>byteBindVariable:       (for variables which hold bytes e.g. ByteArray)                 or
    OCI8Statement>>fixedPointBindVariable: (for variables which hold fixed point numbers e.g. FixedPoint)  or
    OCI8Statement>>floatBindVariable:      (for variables which hold float numbers e.g. Float)             or
    OCI8Statement>>integerBindVariable:    (for variables which hold integer numbers e.g. Integer)         or
    OCI8Statement>>stringBindVariable:     (for variables which hold strings e.g. String)

					[exBegin]
    |session selectStatement resultStream|

    session := OCI8Session default.
    selectStatement := session newStatementFor:'select * from querytest where name like :name'.
    selectStatement stringBindVariable:#name.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    resultStream := WriteStream on:Array new.
    session executeStatement:selectStatement from:#('number 1%9%') into:resultStream.
    resultStream contents inspect.

    session disconnect.
					[exEnd]
"


!

example_selectStatement3c
"
read from the test table the rows with id like '%9%' and name like '1%9%' and inspect the content received.
All variables in the statement must be bound via

    OCI8Statement>>byteBindVariable:       (for variables which hold bytes e.g. ByteArray)                 or
    OCI8Statement>>fixedPointBindVariable: (for variables which hold fixed point numbers e.g. FixedPoint)  or
    OCI8Statement>>floatBindVariable:      (for variables which hold float numbers e.g. Float)             or
    OCI8Statement>>integerBindVariable:    (for variables which hold integer numbers e.g. Integer)         or
    OCI8Statement>>stringBindVariable:     (for variables which hold strings e.g. String)

					[exBegin]
    |session selectStatement resultStream|

    session := OCI8Session default.
    selectStatement := session newStatementFor:'select id from querytest where id like :id and name like :name'.
    selectStatement stringBindVariable:#name.
    selectStatement integerBindVariable:#id.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    resultStream := WriteStream on:Array new.
    session executeStatement:selectStatement from:#('%9%' 'number 1%9%') into:resultStream.
    resultStream contents inspect.

    session disconnect.
					[exEnd]
"


!

example_selectStatement3d
"
first read from the test table the rows with id like '%9%' and name like '1%9%'.
Second append to the same result stream the rows with id like '%8%' and name like '1%8%'
Inspect the content received.
All variables in the statement must be bound via

    OCI8Statement>>byteBindVariable:       (for variables which hold bytes e.g. ByteArray)                 or
    OCI8Statement>>fixedPointBindVariable: (for variables which hold fixed point numbers e.g. FixedPoint)  or
    OCI8Statement>>floatBindVariable:      (for variables which hold float numbers e.g. Float)             or
    OCI8Statement>>integerBindVariable:    (for variables which hold integer numbers e.g. Integer)         or
    OCI8Statement>>stringBindVariable:     (for variables which hold strings e.g. String)

					[exBegin]
    |session selectStatement resultStream|

    session := OCI8Session default.
    selectStatement := session newStatementFor:'select id from querytest where id like :id and name like :name'.
    selectStatement stringBindVariable:#name.
    selectStatement integerBindVariable:#id.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    resultStream := WriteStream on:Array new.
    session executeStatement:selectStatement from:#('%9%' 'number 1%9%') into:resultStream numberOfRows:50.
    session executeStatement:selectStatement from:#('%8%' 'number 1%8%') into:resultStream numberOfRows:50.
    resultStream contents inspect.

    session disconnect.
					[exEnd]
"


!

example_selectStatement4
"
read all rows from the test table. Show the content received in a separte thread.
All variables in the statement must be bound via

    OCI8Statement>>byteBindVariable:       (for variables which hold bytes e.g. ByteArray)                 or
    OCI8Statement>>fixedPointBindVariable: (for variables which hold fixed point numbers e.g. FixedPoint)  or
    OCI8Statement>>floatBindVariable:      (for variables which hold float numbers e.g. Float)             or
    OCI8Statement>>integerBindVariable:    (for variables which hold integer numbers e.g. Integer)         or
    OCI8Statement>>stringBindVariable:     (for variables which hold strings e.g. String)

					[exBegin]
    |session selectStatement resultStream resultSet p|

    session := OCI8Session default.
    selectStatement := session newStatementFor:'select * from querytest'.

    resultSet := CollectingSharedQueueStream new.
    p := [
	|result|

	[result := resultSet next.
	result notNil]
	whileTrue:[
	    Transcript showCR:result.
	]
    ] fork.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    [
	session executeStatement:selectStatement into:resultSet.
    ] on:GenericException do:[:ex|
	ex printOn:Transcript.
	p terminate.
    ].
    resultSet close.

    session disconnect.
					[exEnd]
"
! !

!OCI8QueryStatement methodsFor:'accessing'!

columnDescriptors
    "return the column descriptors describing the selected columns

     <return: Collection>"

    ^ columnDescriptors
!

pieceSize
"
returns how many bytes should be fetched for a piecewise operation. If the statement
includes a long or long raw column, the rows are fetched pieces wise.
The number of bytes to be fetched by each server round trip has an important impact
onto the performace of statement execution. A higher number reduces the necessary
server roundtrips. The default is 30000 bytes rows per roundtrip.

<return: Integer>
"
    pieceSize isNil ifTrue:[
	pieceSize := 30000.
    ].
    ^ pieceSize
!

pieceSize:anInteger
"
sets how many bytes should be fetched for each piecewise operation,
if the receiver is a piecewise fetch. The receiver is a piecewice operation if
one of the define variables is a dynamic variable.

<return: Integer>
"

    pieceSize := anInteger.
!

prefetchedRows
    "return the number of prefetchetched rows"

    prefetchedRows isNil ifTrue:[
	prefetchedRows := PrefetchRowCount.
    ].
    ^ prefetchedRows
!

prefetchedRows:anInteger
    "set the number of prefetched rows. This many rows are buffered by the OCI lib
     when fetching.
     The number of prefetched rows has an important impact onto the performace
     of statement execution. A higher number reduces the necassary server roundtrips"

    prefetchedRows := anInteger.
! !

!OCI8QueryStatement methodsFor:'defining'!

doDefine
    "perform the defining of all define variables"

    |errorHandle|

    errorHandle := self errorHandle.

    columnDescriptors do:[:eachColumnDescriptor|
	eachColumnDescriptor bindTo:handle errorHandle:errorHandle.
    ].
! !

!OCI8QueryStatement methodsFor:'execution'!

describeOn:session
    "execute the query statement, but don't fetch any data"

    handle executeOn:session serviceHandle mode:#'OCI_DESCRIBE_ONLY'
	   iterator:0 rowOffset:0
	   errorHandle:self errorHandle.

    "after the execution the columnDescriptors are available"
    self computeColumnDescriptors.
    ^ columnDescriptors
!

executeOn:session
    "execute the query statement"

"/    self setPrefetchRowCount.
"/    self doBind.

    "execute statement, raise signal if no data is available"

    handle executeOn:session serviceHandle mode:#'OCI_DEFAULT'
	   iterator:0 rowOffset:0
	   errorHandle:self errorHandle.

    "after the execution the columnDescriptors are available"
    self computeColumnDescriptors.
    self doDefine.

    ^ OCICursor new statement:self.
!

executeWith:variables on:session
    "execute the query statement.
     Bind bind variables to variables"

    self doBind:variables.

    "execute statement, raise signal if no data is available"

    handle executeOn:session serviceHandle mode:#'OCI_DEFAULT'
	   iterator:0 rowOffset:0
	   errorHandle:self errorHandle.

    "after the execution the columnDescriptors are available"
    self computeColumnDescriptors.
    self doDefine.

    ^ OCICursor new statement:self.
! !

!OCI8QueryStatement methodsFor:'fetching'!

next
    "fetch the next row"

    handle fetchNumberOfRows:1 errorHandle:self errorHandle.
! !

!OCI8QueryStatement methodsFor:'obsolete execution'!

executeFrom:anInsertStreamOrCollection into:aReturningStream
"
executes a query statement. The values from the stream/collection will be copied to the
variables in the statement text. All result of the statement will be insert into the stream aReturningStream.

<return: self>
"
    self executeFrom:anInsertStreamOrCollection into:aReturningStream numberOfRows:nil
!

executeFrom:anInsertStreamOrCollection into:aReturningStream numberOfRows:aRowIntegerOrNil
"
executes a query statement. The values from the stream/collection will be copied to the
variables in the statement text.
Into the stream aReturningStream the result of the statements will be insert.
If a  aRowIntegerOrNil is nil all results of the statement will be insert into the stream aReturningStream,
if not aRowIntegerOrNil number of results of the statement will be insert into the stream aReturningStream.

<return: self>
"
    |dataAvailable content|

    "check for correct type of anInsertStreamOrCollection"
    anInsertStreamOrCollection isStream ifTrue:[
	content := anInsertStreamOrCollection contents.
    ] ifFalse:[
	anInsertStreamOrCollection isCollection ifTrue:[
	    content := anInsertStreamOrCollection.
	] ifFalse:[
	    SQLError raiseErrorString:' - wrong type for ''from'' in value of statement. Must be a stream or collection.'.
	].
    ].
    "bind variable"
    self doBindingFor:content.
    self setPrefetchRowCount.
    "execute statement"
    dataAvailable := self basicExecute.
    "fetch data"
    dataAvailable ifTrue:[
	self setDefineVariablesAndColumnDescriptors.
	"number of processedRows is set as a side effect"
	self fetchDataInto:aReturningStream numberOfRows:aRowIntegerOrNil.
    ] ifFalse:[
	self processedRows:0
    ].
!

executeInto:aReturningStream
"
executes a query statement with no variables in the statement text.
All results of the statement will be insert into the stream aReturningStream.

<return: self>
"
    self executeFrom:#() into:aReturningStream
!

executeInto:aReturningStream numberOfRows:aRowIntegerOrNil
"
executes a query statement with no variables in the statement text.
Into the stream aReturningStream the result of the statements will be insert.
If a  aRowIntegerOrNil is nil all results of the statement will be insert into the stream aReturningStream,
if not aRowIntegerOrNil number of results of the statement will be insert into the stream aReturningStream.

<return: self>
"
    self executeFrom:#() into:aReturningStream numberOfRows:aRowIntegerOrNil
!

fetchDataInto:aReturningStream numberOfRows:aRowIntegerOrNil
"
fetched data for the receiver. Into the stream aReturningStream the result of the receiver will be insert.
If a  aRowIntegerOrNil is nil all results of the receiver will be insert into the stream aReturningStream,
if not aRowIntegerOrNil number of results of the receiver will be insert into the stream aReturningStream.

<return: self>
"
    |finished dynamicDefineVariable numerOfRows serviceHandle errorHandle defineVariables|

    "if number of rows to fetch is 0 - return"
    ((aRowIntegerOrNil notNil and:[aRowIntegerOrNil = 0]) or:[self fetchingFinished]) ifTrue:[^self].

    defineVariables := self ociDefineVariables asArray. "convert to array, so that a later #collect: generates arrays"
    dynamicDefineVariable := self getDynamicVariable.
    serviceHandle := self serviceHandle.
    errorHandle:= self errorHandle.
    numerOfRows := 0.
    finished := false.
    self setFetching.
    [
	OCINoDataSignal handle:[:ex |
	    finished := true.
	    self fetchingFinished:true.
	] do:[
	    dynamicDefineVariable notNil ifTrue:[
		"if one of the define variables of the receiver is a dynamic variable,"
		"then the data must be fetched by a piecewise operation."
		dynamicDefineVariable dataBuffer:(self ociLib ociStatementPiecewiseFetch:self
									serviceOCIHandle:serviceHandle
									       pieceSize:dynamicDefineVariable pieceSize
									    numberOfRows:1
									  errorOCIHandle:errorHandle).
	    ] ifFalse:[
		"normal fetch"
		self handle fetchNumberOfRows:1 errorHandle:errorHandle.
	    ].
	    "fill result collection if the fetch wasnt aborted"
	    (self isAborted or:[self shouldAbort]) ifTrue:[
		self setAborted.
		finished := true.
	    ] ifFalse:[
		aReturningStream nextPut:(defineVariables collect:[:eachVar | eachVar getValue]).
		numerOfRows := numerOfRows + 1.
		"set finished to true if the number of already fetched rows"
		"is  higer than the number to fetch. If maxminum number is specified"
		"fetch all available rows."
		(aRowIntegerOrNil isNil or:[numerOfRows < aRowIntegerOrNil]) ifFalse:[
		    finished := true.
		]
	    ].
	].
    ] doWhile:[finished not].

    "compute how many rows are processed by the statement"
    self computeProcessedRows.
    self setFetched.
! !

!OCI8QueryStatement methodsFor:'private accessing'!

computeColumnDescriptors
    "compute the column descriptors for the affected columns of the statement"

    |descriptors parameterCount errorHandle|

    errorHandle := self errorHandle.
    parameterCount := handle getAttribute:#'OCI_ATTR_PARAM_COUNT'
			      errorHandle:errorHandle.

    descriptors := Array new:parameterCount.

    1 to:parameterCount do:[:position|
	|parameterHandle descriptor|

	parameterHandle := handle getParameter:position errorHandle:errorHandle.
	descriptor := parameterHandle as:OCI8SelectDescriptor withErrorHandle:errorHandle.
	parameterHandle release.
	descriptor position:position.
	descriptors at:position put:descriptor.
    ].
    columnDescriptors := descriptors.
! !

!OCI8QueryStatement methodsFor:'queries'!

rowId
    "answer the rowId of the current row"

    |rowIdDescriptor|

    rowIdDescriptor := handle environmentHandle newHandleWithType:#OCI8RowIdDescriptor.
     ^ handle getAttribute:#'OCI_ATTR_ROWID' into:rowIdDescriptor errorHandle:self errorHandle
! !

!OCI8QueryStatement methodsFor:'releasing'!

cancel
    "cancel the current cursor (the current query)"

    handle fetchNumberOfRows:0 errorHandle:self errorHandle.
! !

!OCI8QueryStatement methodsFor:'setting'!

setPrefetchRowCount
    "set the numer of rows prefetched for the receiver.
     The number of prefetched rows has an important impact on the performace
     of statement execution. A higher number reduces the necessary server roundtrips.

     <return: self>"

    self handle
	setAttribute:#'OCI_ATTR_PREFETCH_ROWS'
	value:self prefetchedRows
	errorHandle:self errorHandle
! !

!OCI8QueryStatement methodsFor:'testing'!

isDefined
"
returns true if the receivers define variables are generated and setup
if not false

<return: Boolean>
"
    ^self defined

!

isQueryStatement
    "return true if the statement is a query statement"

    ^ true
! !

!OCI8QueryStatement class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8QueryStatement.st,v 1.7 2010-10-11 12:00:05 cg Exp $'
! !

OCI8QueryStatement initialize!
