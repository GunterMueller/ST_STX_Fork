"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

TestCase subclass:#OracleTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Testcases'
!

!OracleTests class methodsFor:'documentation'!

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
     documentation to be added.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!OracleTests methodsFor:'helpers'!

connectTestUserOn:aSession

    aSession connectWithUsername:'scott' password:'tiger' dbname:'xpt.nil.ssw.de'.
!

createTable

    |session statement|

    session := OCI8Session new.
    [

	self connectTestUserOn:session.

	statement := session newStatementFor:'create table test_table(id number, fl float, name varchar2(100), bytes raw(200))'.
	statement executeOn:session.
    ] ensure:[
	session disconnect.
    ].

    "
	self debug:#testCreateTable
    "
! !

!OracleTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!OracleTests methodsFor:'tests'!

testConnect

    |session|

    session := OCI8Session new.

    self connectTestUserOn:session.

    self assert:session isConnected description:'Connect status'.

    session disconnect.

    self assert:session isConnected not description:'Disonnect status'.

    "
	self debug:#testConnect
    "
!

testCreateAndDropTable

    |session statement|

    session := OCI8Session new.
    [

	self connectTestUserOn:session.

	statement := session newStatementFor:'create table dummy_table(id number, fl float, name varchar2(100), bytes raw(200))'.
	statement executeOn:session.
	statement := session newStatementFor:'drop table dummy_table'.
	statement executeOn:session.
    ] ensure:[
	session disconnect.
    ].

    "
	self debug:#testCreateAndDropTable
    "
!

testDescribeStatement

    |session statement cursor columnDescriptors prototypeDescriptors|

    session := OCI8Session new.
    [

	self connectTestUserOn:session.

	statement := session newStatementFor:'select * from emp order by empno'.
	cursor := statement executeOn:session.
    "/    statement describeOn:session.

	columnDescriptors  := statement columnDescriptors.
	self assert:(columnDescriptors size = 8).

	prototypeDescriptors := #(Array (#'SQL::OCI8ColumnDescriptor' #name: 'EMPNO' #scale: 0 #precision: 4 #nullValue: false #type: #'NUMBER_TYPE' #size: 22)
					(#'SQL::OCI8ColumnDescriptor' #name: 'ENAME' #scale: 0 #precision: 0 #nullValue: true #type: #'VARCHAR2_TYPE' #size: 10)
					(#'SQL::OCI8ColumnDescriptor' #name: 'JOB' #scale: 0 #precision: 0 #nullValue: true #type: #'VARCHAR2_TYPE' #size: 9)
					(#'SQL::OCI8ColumnDescriptor' #name: 'MGR' #scale: 0 #precision: 4 #nullValue: true #type: #'NUMBER_TYPE' #size: 22)
					(#'SQL::OCI8ColumnDescriptor' #name: 'HIREDATE' #scale: 0 #precision: 0 #nullValue: true #type: #'DATE_TYPE' #size: 7)
					(#'SQL::OCI8ColumnDescriptor' #name: 'SAL' #scale: 2 #precision: 7 #nullValue: true #type: #'NUMBER_TYPE' #size: 22)
					(#'SQL::OCI8ColumnDescriptor' #name: 'COMM' #scale: 2 #precision: 7 #nullValue: true #type: #'NUMBER_TYPE' #size: 22)
					(#'SQL::OCI8ColumnDescriptor' #name: 'DEPTNO' #scale: 0 #precision: 2 #nullValue: true #type: #'NUMBER_TYPE' #size: 22)
				  ) decodeAsLiteralArray.

	self assert:(columnDescriptors = prototypeDescriptors)
	     description:'Compare column descriptors'.
    ] ensure:[
	session disconnect.
    ].

    "
	self debug:#testDescribeStatement
    "
!

testDescribeTable

    |session columnDescriptors prototypeDescriptors|

    session := OCI8Session new.

    self connectTestUserOn:session.
    columnDescriptors := session describeTable:'emp'.
    self assert:(columnDescriptors size = 8).

    prototypeDescriptors := #(Array (#'SQL::OCI8ColumnDescriptor' #name: 'EMPNO' #scale: 0 #precision: 4 #nullValue: false #type: #'NUMBER_TYPE' #size: 22)
				    (#'SQL::OCI8ColumnDescriptor' #name: 'ENAME' #scale: 0 #precision: 0 #nullValue: true #type: #'VARCHAR2_TYPE' #size: 10)
				    (#'SQL::OCI8ColumnDescriptor' #name: 'JOB' #scale: 0 #precision: 0 #nullValue: true #type: #'VARCHAR2_TYPE' #size: 9)
				    (#'SQL::OCI8ColumnDescriptor' #name: 'MGR' #scale: 0 #precision: 4 #nullValue: true #type: #'NUMBER_TYPE' #size: 22)
				    (#'SQL::OCI8ColumnDescriptor' #name: 'HIREDATE' #scale: 0 #precision: 0 #nullValue: true #type: #'DATE_TYPE' #size: 7)
				    (#'SQL::OCI8ColumnDescriptor' #name: 'SAL' #scale: 2 #precision: 7 #nullValue: true #type: #'NUMBER_TYPE' #size: 22)
				    (#'SQL::OCI8ColumnDescriptor' #name: 'COMM' #scale: 2 #precision: 7 #nullValue: true #type: #'NUMBER_TYPE' #size: 22)
				    (#'SQL::OCI8ColumnDescriptor' #name: 'DEPTNO' #scale: 0 #precision: 2 #nullValue: true #type: #'NUMBER_TYPE' #size: 22)
			      ) decodeAsLiteralArray.

    self assert:(columnDescriptors = prototypeDescriptors) description:'Compare column descriptors'.

    session disconnect.

    "
	self debug:#testDescribeTable
    "
!

testInsert

    |session statement|

    session := OCI8Session new.
    [

	self connectTestUserOn:session.

	[
	    session execute:'drop table dummy_table'.
	] on:SQLError do:[:ex| "ignore"].

	session execute:'create table dummy_table(id number, fl float, name varchar2(100), bytes raw(200))'.
	statement := session newStatementFor:'insert into dummy_table(id, fl, name, bytes)
					      values (:id, :fl, :name, :bytes)'.

	statement executeWith:#(
				 (1 3.14 'Fritz' [1 2 3 4 5])
				 (2 2.71828 'Peter' [7 8 9])
				 (3 25 'Manuel' nil)
			       )
		  on:session.
	session commit.
    ] ensure:[
	session disconnect.
    ].

    "
	self debug:#testInsert
    "
!

testQueryStatement

    |session statement cursor|

    session := OCI8Session new.
    [

	self connectTestUserOn:session.

	statement := session newStatementFor:'select empno, ename, job, mgr, hiredate, sal, comm, deptno from emp order by empno'.
	cursor := statement executeOn:session.

	cursor next.

	self assert:(cursor atIndex:1) = (cursor at:#EMPNO).
	self assert:(cursor atIndex:2) = (cursor at:#ENAME).
	self assert:(cursor atIndex:3) = (cursor at:#JOB).
	self assert:(cursor atIndex:4) = (cursor at:#MGR).
	self assert:(cursor atIndex:5) = (cursor at:#HIREDATE).
	self assert:(cursor atIndex:6) = (cursor at:#SAL).
	self assert:(cursor atIndex:7) = (cursor at:#COMM).
	self assert:(cursor atIndex:8) = (cursor at:#DEPTNO).

	self assert:(cursor at:#EMPNO) = 7369.
	self assert:(cursor at:#ENAME) = 'SMITH'.
	self assert:(cursor at:#JOB) = 'CLERK'.
	self assert:(cursor at:#MGR) = 7902.
	self assert:(cursor at:#HIREDATE) = (Timestamp readFrom:'1980-12-17 00:00:00.000').
	self assert:(cursor at:#SAL) = 800.
	self assert:(cursor at:#COMM) isNil.
	self assert:(cursor at:#DEPTNO) = 20.

	cursor next.
	self halt.
    ] ensure:[
	session disconnect.
    ].

    "
	self debug:#testQueryStatement
    "
!

testRowId

    |session selectStatement updateStatement cursor name|

    session := OCI8Session new.
    [

	self connectTestUserOn:session.

	selectStatement := session newStatementFor:'select empno, ename, job, mgr, hiredate, sal, comm, deptno from emp where empno = 7934 for update'.
	updateStatement := session newStatementFor:'update emp set ename = :1 where rowid = :2'.
	cursor := selectStatement executeOn:session.
	cursor next.

	name := cursor at:#ENAME.
	name := name, '+'.

	updateStatement executeWith:(Array with:(Array with:name
						       with:cursor rowId))
			commitOnSuccess:true
			on:session.

	cursor := selectStatement executeOn:session.
	cursor next.
	self assert:(cursor at:#ENAME) = name.
    ] ensure:[
	session disconnect.
    ].

    "
	self debug:#testRowId
    "
! !

!OracleTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OracleTests.st,v 1.8 2016-10-13 00:15:08 cg Exp $'
! !
