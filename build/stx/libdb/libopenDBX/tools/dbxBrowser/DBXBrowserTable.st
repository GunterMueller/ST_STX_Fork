"{ Package: 'stx:libdb/libopenDBX/tools/dbxBrowser' }"

Object subclass:#DBXBrowserTable
	instanceVariableNames:'table connection'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXBrowser-Model'
!


!DBXBrowserTable class methodsFor:'instance creation'!

forTable: aTable onConnection: aConnection
	^self new
		table: aTable;
		connection: aConnection;
		yourself
! !

!DBXBrowserTable methodsFor:'accessing'!

children
	"Nothing"
	^#()
!

columns
	^table columns
!

connection
	^ connection
!

connection: aConnection
	connection := aConnection
!

foreignKeys
	^table foreignKeys
!

kindName
	^'Table'
!

table: aTable
	table := aTable
! !

!DBXBrowserTable methodsFor:'glamourBrowsers'!

actions
	| browser |
	^{
		(GLMGenericAction action: [:each | 
			browser := GLMTabulator new.
			browser title: 'Inspect Table'.
			browser row: #one.
			browser transmit to: #one; andShow: [ :a | a custom: each selection glamourPresentation ].
			browser openOn: each selection.
		] title: 'Inspect').
	}
!

glamourPresentation
	| browser |
	browser := GLMTabulator new.
	browser row: #tables.
	browser transmit
		to: #tables;
		andShow: [ :a | 
			a table
				title: ('Columns for {1}' format: { table name });
				column: 'Column name' evaluated: #name;
				column: 'Null' evaluated:[ :column | column nullable asString ];
				column: 'Type' evaluated:[ :column | column typeName asString ];
				column: 'Length' evaluated:[ :column | column length asString ];
				column: 'Primary Key' evaluated:[ :column | column isPrimaryKey asString ];
				display: self columns;
				yourself.
			a table
				title: ('Foreign Keys for {1}' format: { table name });
				column: 'Foreign Key name' evaluated: #name;
				column: 'Foreign Table' evaluated:#foreignTableName;
				column: 'From Columns' evaluated: [ :fk | ', ' join: (fk sourceColumns collect: #asString) ];
				column: 'To Columns' evaluated: [ :fk | ', ' join: (fk destinyColumns collect: #asString) ];
				display: self foreignKeys;
				yourself.
	].
	 ^browser startOn: 'something'
!

icon
	^FamFamFamSilkIcons new databaseTable16x16 asMorph
! !

!DBXBrowserTable methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: table name
! !

!DBXBrowserTable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowserTable.st,v 1.2 2013-04-15 13:46:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowserTable.st,v 1.2 2013-04-15 13:46:18 cg Exp $'
! !

