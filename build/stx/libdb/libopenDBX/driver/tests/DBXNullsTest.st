"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXNullsTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXNullsTest methodsFor:'running'!

runDMLSetUpScript: aConnection 
	aConnection execute: 'INSERT INTO student (id, name_surname, nullable_field) VALUES (88, ''Mariano Squeak'', null) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, nullable_field) VALUES (89, ''Mariano Squeak'', ''riptobe'' ) '.
! !

!DBXNullsTest methodsFor:'tests'!

testReadTableWithNull
" test reading of a null value in first line."

	| conn stmt resultSet coll rows |
	conn := self doConnectAndOpen.
	[resultSet  := conn execute: 'SELECT id, nullable_field FROM student'.
	coll := OrderedCollection new.
	rows := resultSet rows.
	rows  do: [ :r | coll add: r values ].
	self assert: (((coll at: 2) at: 2) isString).
	] ensure: [ conn disconnect ].
! !

!DBXNullsTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXNullsTest.st,v 1.2 2013-04-15 13:18:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXNullsTest.st,v 1.2 2013-04-15 13:18:05 cg Exp $'
! !

