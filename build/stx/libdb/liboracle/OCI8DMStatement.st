"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCI8StatementWithVariables subclass:#OCI8DMStatement
	instanceVariableNames:'commitOnSuccess returningVariables'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Statements'
!

!OCI8DMStatement class methodsFor:'documentation'!

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
    Data manipulation statements can be used via this class. The default behaviour
    is that a statement must be commited explicit (includes a logoff which does an commit).
    Its possible to set a statement to commit on success with OCI8DMStatement>>setCommitOnSuccess.
    To execute a data manipulation statement call:
	OCI8Session>>executeStatement:
	OCI8Session>>executeStatement:from:
	OCI8Session>>executeStatement:from:into:
	OCI8Session>>executeStatement:into:

    [author:]
	Pierre Schwarz

    [see also:]
	OCI8Statement
	OCI8DDStatement
	OCI8QueryStatement

    [instance variables:]
	commitOnSuccess <Boolean>
	    If true a statement is commited after successful execution. If false
	    an explicit commit or logoff (which does an commit) must be done.
	    Default this boolean is false.

	returningVariables <OrderedCollection>
	    Holds instances of OCI8ReturnValueBindVariable. Used to get the values from a
	    returning clause in a statement.

    [class variables:]
	none
"
! !

!OCI8DMStatement class methodsFor:'examples'!

examples_InsertValues1a
"
insert three rows into table inserttest.

								[exBegin]
    |session truncateStatement insertStatement|

    session := OCI8Session default.
    truncateStatement := session newStatementFor:'truncate table inserttest'.
    insertStatement := session newStatementFor:'insert into inserttest(id, name) values (9, ''number 9'')'.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    session executeStatement:truncateStatement.
    session executeStatement:insertStatement.

    session disconnect.

								 [exEnd]
"
!

examples_InsertValues1b
"
insert three rows into table inserttest.

								[exBegin]
    |session truncateStatement insertStatement|

    session := OCI8Session default.
    truncateStatement := session newStatementFor:'truncate table inserttest'.
    insertStatement := session newStatementFor:'insert into inserttest(id, name) values (:id, :name)'.
    insertStatement stringBindVariable:#name.
    insertStatement integerBindVariable:#id.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    session executeStatement:truncateStatement.
    session executeStatement:insertStatement from:#(100 'number 100').
    session executeStatement:insertStatement from:#(20000 'number 20000').
    session executeStatement:insertStatement from:#(3000000 'number 3000000').

    session disconnect.

								 [exEnd]
"
!

examples_InsertValues1c
"
insert three rows into table inserttest.

								[exBegin]
    |session truncateStatement insertStatement|

    session := OCI8Session default.
    truncateStatement := session newStatementFor:'truncate table inserttest'.
    insertStatement := session newStatementFor:'insert into inserttest(id, name) values (:id, :name)'.
    insertStatement stringBindVariable:#name.
    insertStatement integerBindVariable:#id.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    session executeStatement:truncateStatement.
    session executeStatement:insertStatement from:#(#(100 'number 100')).
    session executeStatement:insertStatement from:#(#(20000 'number 20000')).
    session executeStatement:insertStatement from:#(#(3000000 'number 3000000')).

    session disconnect.

								 [exEnd]
"
!

examples_InsertValues2
"
insert three rows into table inserttest. Same result as example examples_InsertSingleValues1a/b.
But here an array insert is used.
								[exBegin]
    |session truncateStatement insertStatement|

    session := OCI8Session default.
    truncateStatement := session newStatementFor:'truncate table inserttest'.
    insertStatement := session newStatementFor:'insert into inserttest(id, name) values (:id, :name)'.
    insertStatement stringBindVariable:#name.
    insertStatement integerBindVariable:#id.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    session executeStatement:truncateStatement.
    session executeStatement:insertStatement from:(Array with:#(100 'number 100') with:#(20000 'number 20000') with:#(3000000 'number 3000000')).

    session disconnect.

								 [exEnd]
"
!

examples_InsertValues3
"
insert four rows into table inserttest. First insert one row, second do an array insert with three rows.

								[exBegin]
    |session truncateStatement insertStatement|

    session := OCI8Session default.
    truncateStatement := session newStatementFor:'truncate table inserttest'.
    insertStatement := session newStatementFor:'insert into inserttest(id, name) values (:id, :name)'.
    insertStatement stringBindVariable:#name.
    insertStatement integerBindVariable:#id.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    session executeStatement:truncateStatement.
    session executeStatement:insertStatement from:#(9999999999999999 'number 9999999999999999').
    session executeStatement:insertStatement from:(Array with:#(100 'number 100') with:#(20000 'number 20000') with:#(3000000 'number 3000000')).

    session disconnect.

								 [exEnd]
"
!

examples_InsertValues4
"
insert floats into column floats. First insert one row, second do an array insert with three rows.

								[exBegin]
    |session truncateStatement insertStatement|

    session := OCI8Session default.
    truncateStatement := session newStatementFor:'truncate table inserttest'.
    insertStatement := session newStatementFor:'insert into inserttest(floats) values (:f)'.
    insertStatement floatBindVariable:#f.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    session executeStatement:truncateStatement.
    session executeStatement:insertStatement from:#(9.99).
    session executeStatement:insertStatement from:(Array with:#(1234.789) with:#(20.0) with:#(-345678.12)).

    session disconnect.

								 [exEnd]
"
!

examples_InsertValues5
"
insert a picture into column binary. Read the picture and inspect it.

								[exBegin]
    |session truncateStatement insertStatement selectStatement pictureBinarys returnStream|

    session := OCI8Session default.
    pictureBinarys := '~/work/stx/goodies/bitmaps/gifImages/claus.gif' asFilename readStream binary contentsOfEntireFile.

    truncateStatement := session newStatementFor:'truncate table inserttest'.
    insertStatement := session newStatementFor:'insert into inserttest(binary) values (:picture)'.
    insertStatement byteBindVariable:#picture.
    selectStatement := session newStatementFor:'select binary from inserttest'.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    session executeStatement:truncateStatement.
    session executeStatement:insertStatement from:(Array with:pictureBinarys).
    returnStream := ReadWriteStream on:Array new.
    session executeStatement:selectStatement into:returnStream.

    pictureBinarys := returnStream contents first first.
    (GIFReader fromStream:pictureBinarys readStream) inspect.

    session disconnect.
								 [exEnd]
"
!

examples_InsertValues6
"
insert and update some rows.

								[exBegin]
    |session truncateStatement insertStatement selectStatement updateStatement|

    session := OCI8Session default.

    truncateStatement := session newStatementFor:'truncate table inserttest'.
    insertStatement := session newStatementFor:'insert into inserttest(id, name) values (:id, :name)'.
    insertStatement integerBindVariable:#id.
    insertStatement stringBindVariable:#name.
    updateStatement := session newStatementFor:'update inserttest set id = id + 1 where id = :id'.
    updateStatement integerBindVariable:#id.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    session executeStatement:truncateStatement.
    session executeStatement:insertStatement from:(Array with:#(100 'number 100') with:#(20000 'number 20000') with:#(3000000 'number 3000000')).
    session executeStatement:updateStatement from:#(20000).

    session disconnect.
								 [exEnd]
"
!

examples_InsertValues7a
"
insert some rows and return the insert values with an returning clause.

								[exBegin]
    |session truncateStatement insertStatement selectStatement returnStream|

    session := OCI8Session default.

    truncateStatement := session newStatementFor:'truncate table inserttest'.
    insertStatement := session newStatementFor:'insert into inserttest(id, name) values (1, ''1000'') returning id, name into :retId, :retName'.
    insertStatement integerReturnVariable:#retId.
    insertStatement stringReturnVariable:#retName.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    session executeStatement:truncateStatement.
    returnStream := ReadWriteStream on:Array new.
    session executeStatement:insertStatement into:returnStream.
    returnStream contents inspect.

    session disconnect.
								 [exEnd]
"
!

examples_InsertValues7b
"
insert some rows and return the insert values with an returning clause.

								[exBegin]
    |session truncateStatement insertStatement selectStatement returnStream|

    session := OCI8Session default.

    truncateStatement := session newStatementFor:'truncate table inserttest'.
    insertStatement := session newStatementFor:'insert into inserttest(id, name) values (:id, :name) returning id, name into :retId, :retName'.
    insertStatement integerBindVariable:#id.
    insertStatement stringBindVariable:#name.
    insertStatement integerReturnVariable:#retId.
    insertStatement stringReturnVariable:#retName.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    session executeStatement:truncateStatement.
    returnStream := ReadWriteStream on:Array new.
    session executeStatement:insertStatement from:(Array with:#(100 'number 100') with:#(20000 'number 20000') with:#(3000000 'number 3000000')) into:returnStream.
    returnStream contents inspect.

    session disconnect.
								 [exEnd]
"
!

examples_createTable
"
create the table inserttest for the examples of this class.
								[exBegin]
    |session dropTableStatement createTableStatement|

    session := OCI8Session default.
    dropTableStatement := session newStatementFor:'drop table inserttest'.
    createTableStatement := session newStatementFor:'create table inserttest (id number, floats float, name varchar2(100), binary long raw)'.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    OCIErrorSignal handle:[:ex |
    ] do:[
	session executeStatement:dropTableStatement.
    ].
    OCIErrorSignal handle:[:ex |
    ] do:[
	session executeStatement:createTableStatement.
    ].

    session disconnect.
								[exEnd]
"
! !

!OCI8DMStatement methodsFor:'accessing'!

commitOnSuccess
"
returns if the receiver is commited after successful execution.
The default behavior is no commit on success.

<return: Boolean>
"
    commitOnSuccess isNil ifTrue:[
	commitOnSuccess := false
    ].
    ^ commitOnSuccess
!

commitOnSuccess:aBoolean
    "sets if the receiver is commited after successful execution"

    commitOnSuccess := aBoolean.
!

executeMode
    "return the mode in which the statement is executed. In mode #'OCI_COMMIT_ON_SUCCESS'
     the receiver is commited after successful execution. In mode #'OCI_DEFAULT' an explicit
     commit or logoff (which does an commit) must be done.

     <return: Symbol>"

    commitOnSuccess == true ifTrue:[
	^ #'OCI_COMMIT_ON_SUCCESS'
    ] ifFalse:[
	^ #'OCI_DEFAULT'
    ]
!

returningVariables
"
returns a collection of OCI8ReturnValueBindVariable.
The collection is not empty if the statement has a returning clause.

<return: OrderedCollection>
"
    returningVariables isNil ifTrue:[
	returningVariables := OrderedCollection new
    ].
    ^returningVariables

!

setCommitOnSuccess
"
sets the receivers commit mode to commit on succes. Default behaviour is commit
over a explicit commit or logoff (which does an commit).

<return: self>
"

    self commitOnSuccess: true.
! !

!OCI8DMStatement methodsFor:'accessing variables'!

sortedReturningVariables
"
returns a collection with the returning variables where the
variables are sorted after their appearance in the statement text.
Must be used when building the returning stream because the variabels
mustn't be added in the correct order to the receivers returning collection.

<return: Collection of:OCI8ReturningVariable>
"
    |dict|

    dict := Dictionary new:returningVariables size.
    "build dictionary with index -> OCI8ReturnValueBindVariable"
    returningVariables do:[:eachVar |
	dict at:(self indexForBindName:eachVar name) put:eachVar
    ].
    "sort keys and get values via the sorted keys from the dictionary"
    ^ dict keys asArray sort collect:[:eachKey| dict at:eachKey].
! !

!OCI8DMStatement methodsFor:'binding'!

bindReturningVariables
"
setup each returning variable and bind it to the receiver

<return: self>
"
    returningVariables size > 0 ifTrue:[
	self binded not ifTrue:[
	    returningVariables := self sortedReturningVariables.
	].

	returningVariables do:[:var |
	    var setupForStatement:self.
	].
    ].
!

createBindVariablesFor:aCollection
"
creates bind variables for the collection aCollection. If more than one row must be insert
OCI8MultipleValueBindVariable are used, if not OCI8SingleValueBindVariable are used.
Possible cases of values in the collection aCollection:
    1. Single values: #(el_1 ... el_n)
    2. Single values: #(#(el_1 ... el_n))
    3. Array of values: #(#(el_1_1 ... el_n_1) #(el_1_m ... el_n_m))

<return: self>
"
    |bindVariableClass userBindDescriptor bindVar bindVarName element numberOfBindVars singleBind|

    "create bind variables only if collecton isnt empty"
    aCollection isEmpty ifTrue:[^self].

    "if it is an array bind, then more than one arrays/collections are"
    "in the collection aCollection and variables for array binds are used (OCI8MultipleValueBindVariable)."
    "Single values are insert via OCI8SingleValueBindVariable instances."
    ((element := aCollection first) isArray or:[element isOrderedCollection]) ifTrue:[
	"cases:"
	"#(#(el_1_1 ... el_n_1)) and #(#(el_1_1 ... el_n_1) #(el_1_m ... el_n_m))"
	aCollection size > 1 ifTrue:[
	    "case: #(#(el_1_1 ... el_n_1) #(el_1_m ... el_n_m))"
	    bindVariableClass := OCI8MultipleValueBindVariable.
	    numberOfBindVars := element size.
	    singleBind := false.
	] ifFalse:[
	    "case: #(#(el_1 ... el_n))"
	    bindVariableClass := OCI8SingleValueBindVariable.
	    numberOfBindVars := element size.
	    singleBind := true.
	].
    ] ifFalse:[
       "case: #(el_1 ... el_n)"
       bindVariableClass := OCI8SingleValueBindVariable.
       numberOfBindVars := aCollection size.
       singleBind := true.
    ].

    "we need to generate new bind variables, if the statement isnt binded or"
    "if the statement changes from single to array bind and vice versa."
    (self binded not or:[self arrayBind == singleBind]) ifFalse:[
	^self
    ].

    "remove all bind variables"
    self removeAllBindVariables.
    self arrayBind:singleBind not.
    "generate bind variables"
    1 to: numberOfBindVars do:[:index |
	bindVarName := self bindNameAtPosition:index.
	userBindDescriptor := self bindNameFor:bindVarName.
	userBindDescriptor isNil ifTrue:[
	    SQLError raiseErrorString:' - undefined bind variable for index ', index printString.
	].
	bindVar := bindVariableClass name:(userBindDescriptor key) converter:(userBindDescriptor value).
	self bindVariables add:bindVar.
    ].
!

doBindingFor:aCollection
"
creates bind variables out of the description parameters and bind it to the statement via an oci call.
Raise an error when the number of elements in the bind variable are different.

<return: self>
"
    "check if number of values in aCollection = number of bind variables"
    self checkIfCorrectNumberOfValuesInContent:aCollection.
    "compute descriptors"
    self computeBindDescriptors.
    "create bind variables out of the definition in bindDefinition"
    self createBindVariablesFor:aCollection.
    "set value of bind variables"
    self setValueOfBindVariablesFor:aCollection.
    "check if in every statements bindVariables have the same number of elements defined for checkin"
    self checkBindVariablesForSameSize.
    "set up each bind variable and bind it to the statement"
    self doBindingVariables.
    "each bind variable which represents a return value is bind in DATA_AT_EXEC_MODE"
    "the values are retrieved via a callback from the oci lib"
    self bindReturningVariables.

    self binded:true.
!

setValueOfBindVariablesFor:aCollection
"
sets values from the collection aCollection to the bind varaibles.
Possible cases of values in the collection:
    1. Single values: #(el_1 ... el_n)
    2. Single values: #(#(el_1 ... el_n))
No multiple values are allowed here.

<return: self>
"
    |bindVar element data|

    "if collection is empty nothing to do"
    aCollection isEmpty ifTrue:[^self].
    "get data from collection"
    ((element := aCollection first) isArray or:[element isOrderedCollection]) ifTrue:[
	"elements are arrays"
	data := aCollection
    ] ifFalse:[
	data := Array with:aCollection.
    ].
    "set values to bind variables"
    data do:[:eachArray |
	1 to: eachArray size do:[:index |
	    bindVar := self bindVariables at:index.
	    bindVar addValue:(eachArray at:index).
	]
    ].
! !

!OCI8DMStatement methodsFor:'computation'!

getReturningValuesInto:aReturningStream
"
copy all values from return variables
(they are in a returing clause of an data manipulation statement) into aReturningStream.

<return: self>
"

    returningVariables do:[:eachBindVar |
	aReturningStream nextPut:eachBindVar value
    ].
! !

!OCI8DMStatement methodsFor:'execution'!

executeWith:aCollection commitOnSuccess:commitOnSuccess on:aSession
    "execute a data manipulation statement.  The values from the stream/collection will be copied to the
     variables in the statement text. Then the statement is executed and values from a
     returning clause are coppied to the returning stream"

    "bind variables"
    self doBind:aCollection.

    "execute statement"
    self handle executeOn:aSession serviceHandle
		     mode:(commitOnSuccess ifTrue:[#'OCI_COMMIT_ON_SUCCESS']
					   ifFalse:[#'OCI_DEFAULT'])
		 iterator:aCollection size
		rowOffset:0
	      errorHandle:self errorHandle.

    "copy values from an returing clause into the returning stream"
"/    aReturningStream notNil ifTrue:[
"/        self getReturningValuesInto:aReturningStream.
"/    ].
"/    "compute how many rows are processed by the statement"
"/    self computeProcessedRows.
!

executeWith:aCollection on:aSession
    ^ self executeWith:aCollection commitOnSuccess:false on:aSession
! !

!OCI8DMStatement methodsFor:'generate return-variable'!

byteReturnVariable:aStringOrSymbol
"
adds a new return value variable with name
aStringOrSymbol in the statement text to the receiver.
Into the external buffer of the return variable the oci lib
will insert the return value. When accessing the value from
the return variable it is converted into a ByteArray.

<return: self>
"
    |bindVar|

    bindVar := OCI8ReturnValueBindVariable new.
    bindVar name:aStringOrSymbol asUppercase asSymbol.
    bindVar converter:OCI8ByteArrayConverter new.
    self returningVariables add:bindVar.
!

fixedPointReturnVariable:aStringOrSymbol
"
adds a new return value variable with name
aStringOrSymbol in the statement text to the receiver.
Into the external buffer of the return variable the oci lib
will insert the return value. When accessing the value from
the return variable it is converted into a FixedPoint.

<return: self>
"
    |bindVar|

    bindVar := OCI8ReturnValueBindVariable new.
    bindVar name:aStringOrSymbol asUppercase asSymbol.
    bindVar converter:OCI8FixedPointConverter new.
    self returningVariables add:bindVar.
!

floatReturnVariable:aStringOrSymbol
"
adds a new return value variable with name
aStringOrSymbol in the statement text to the receiver.
Into the external buffer of the return variable the oci lib
will insert the return value. When accessing the value from
the return variable it is converted into a Float.

<return: self>
"
    |bindVar|

    bindVar := OCI8ReturnValueBindVariable new.
    bindVar name:aStringOrSymbol asUppercase asSymbol.
    bindVar converter:OCI8FloatConverter new.
    self returningVariables add:bindVar.
!

integerReturnVariable:aStringOrSymbol
"
adds a new return value variable with name
aStringOrSymbol in the statement text to the receiver.
Into the external buffer of the return variable the oci lib
will insert the return value. When accessing the value from
the return variable it is converted into an Integer.

<return: self>
"
    |bindVar|

    bindVar := OCI8ReturnValueBindVariable new.
    bindVar name:aStringOrSymbol asUppercase asSymbol.
    bindVar converter:OCI8IntegerConverter new.
    self returningVariables add:bindVar.
!

stringReturnVariable:aStringOrSymbol
"
adds a new return value variable with name
aStringOrSymbol in the statement text to the receiver.
Into the external buffer of the return variable the oci lib
will insert the return value. When accessing the value from
the return variable it is converted into a String.

<return: self>
"
    |bindVar|

    bindVar := OCI8ReturnValueBindVariable new.
    bindVar name:aStringOrSymbol asUppercase asSymbol.
    bindVar converter:OCI8StringConverter new.
    self returningVariables add:bindVar.
! !

!OCI8DMStatement methodsFor:'obsolete execution'!

execute
"
executes a data manipulation statement without any variables in the statement text.

<return: self>
"
    "execute statement"
    self executeFrom:#() into:nil commitOnSuccess:false
!

executeAndCommitOnSuccess
"
executes a data manipulation statement without any variables in the statement text.

<return: self>
"
    "execute statement"
    self executeFrom:#() into:nil commitOnSuccess:true
!

executeFrom:anInsertStreamOrCollection

    self executeFrom:anInsertStreamOrCollection into:nil commitOnSuccess:false
!

executeFrom:anInsertStreamOrCollection into:aReturningStream

    ^ self executeFrom:anInsertStreamOrCollection into:aReturningStream commitOnSuccess:false
!

executeFrom:anInsertStreamOrCollection into:aReturningStream commitOnSuccess:commitOnSuccess
"
executes a data manipulation statement.  The values from the stream/collection will be copied to the
variables in the statement text. Then the statement is executed and values from a
returning clause are coppied to the returning stream.

<return: self>
"
    |content|

    "check for correct type of anInsertStreamOrCollection"
    anInsertStreamOrCollection isStream ifTrue:[
	content := anInsertStreamOrCollection contents.
    ] ifFalse:[
	anInsertStreamOrCollection isCollection ifTrue:[
	    content := anInsertStreamOrCollection.
	] ifFalse:[
	    SQLError raiseErrorString:' - wrong type for ''from'' in value of statement specified. Must be a stream or collection.'.
	].
    ].
    "bind variables"
    self doBindingFor:content.

    "execute statement"
    self handle executeOn:self serviceHandle
		     mode:(commitOnSuccess ifTrue:[#'OCI_COMMIT_ON_SUCCESS']
					   ifFalse:[#'OCI_DEFAULT'])
		 iterator:self iterator
		rowOffset:self rowOffset
	      errorHandle:self errorHandle.
    "copy values from an returing clause into the returning stream"

    aReturningStream notNil ifTrue:[
	self getReturningValuesInto:aReturningStream.
    ].
    "compute how many rows are processed by the statement"
    self computeProcessedRows.
!

executeInto:aReturningStream
"
executes a data manipulation statement. The statement is executed
and values from a returning clause are coppied to the returning stream.

<return: self>
"

    self executeFrom:#() into:aReturningStream commitOnSuccess:false.
! !

!OCI8DMStatement methodsFor:'subclass responsibility'!

iterator
"
returns the number of many times a statement must be executed.
A data manipulation statement must be executed at least once.
If bind variables exists the statement must be executed n times.
Where n is the number of rows which should be insert.

<return: Integer>
"

    self bindVariables notEmpty ifTrue:[
	^self bindVariables first numberOfElements
    ].
    ^1
! !

!OCI8DMStatement methodsFor:'testing'!

isDMLStatement
    "return true if the statement is a data manipulation statement"

    ^ true
! !

!OCI8DMStatement class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8DMStatement.st,v 1.5 2010-10-11 12:00:05 cg Exp $'
! !
