"{ Package: 'stx:libdb/libopenDBX/tools/dbxBrowser' }"

Object subclass:#DBXBrowserSchema
	instanceVariableNames:'schema connection tablesCache'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXBrowser-Model'
!


!DBXBrowserSchema class methodsFor:'instance creation'!

forSchema: aDBXSchema onConnection: aDBXBrowserConnection
	^self new 
		schema: aDBXSchema;
		connection: aDBXBrowserConnection;
		yourself 
! !

!DBXBrowserSchema methodsFor:'accessing'!

children
	^self tables
!

connection
	^ connection
!

connection: aConnection
	connection := aConnection
!

invalidateCache
	tablesCache := nil.
	self connection announce: DBXConnectionStatusChanged.
!

kindName
	^'Schema'
!

schema: aDBXSchema
	schema := aDBXSchema.
!

tables
	^tablesCache ifNil: [ tablesCache := connection fetchTablesForSchema: self ]
! !

!DBXBrowserSchema methodsFor:'glamourBrowsers'!

actions
	| browser |
	^{
		GLMGenericAction action: [:each | 
			browser := GLMTabulator new.
			browser title: 'Inspect schema'.
			browser row: #one.
			browser transmit to: #one; andShow: [ :a | a custom: each selection glamourPresentation ].
			browser openOn: each selection.
		] title: 'Inspect'.
		(GLMGenericAction action: [:each | each selection invalidateCache] title: 'Refresh') icon: FamFamFamSilkIcons new arrowRefresh16x16.
	}
!

glamourPresentation
	^GLMTablePresentation new
		title: 'Tables';
		addColumn: (GLMTableColumn new title: 'Table name'; computation: #name);
		display: self tables;
		yourself
!

icon
	^FamFamFamSilkIcons new database16x16 asMorph
! !

!DBXBrowserSchema methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: schema name
! !

!DBXBrowserSchema class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowserSchema.st,v 1.2 2013-04-15 13:46:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowserSchema.st,v 1.2 2013-04-15 13:46:17 cg Exp $'
! !

