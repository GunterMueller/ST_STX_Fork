"{ Package: 'stx:libdb/libopenDBX/tools/dbxBrowser' }"

Object subclass:#DBXBrowserConnection
	instanceVariableNames:'announcer connection dbxPlatform dbxSettings name schemas
		querySemaphore schemasCache'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXBrowser-Model'
!


!DBXBrowserConnection class methodsFor:'as yet unclassified'!

descriptionBackend
	^MASingleOptionDescription new 
		label: 'Backend'; 
		accessor: #dbxPlatform; 
		required: true;
		beSorted;
		beExtensible;
		priority: 5;
		options: (DBXBackend allBackends)
		yourself 
!

descriptionConnectionName
	^MAStringDescription new label: 'Name'; accessor: #name; priority: 1; yourself 
!

descriptionDatabase
	^MAStringDescription new label: 'Database'; accessor: #database; priority: 4; yourself 
!

descriptionHost
	^MAStringDescription new label: 'Host'; accessor: #host; priority: 6; yourself 
!

descriptionPassword
	^MAPasswordDescription new label: 'Password'; accessor: #password; priority: 3; yourself 
!

descriptionPort
	^MANumberDescription new label: 'Port'; accessor: #port; priority: 7;yourself 
!

descriptionUsername
	^MAStringDescription new label: 'Username'; accessor: #username; priority: 2; yourself 
! !

!DBXBrowserConnection methodsFor:'accessing'!

children
	^self state childrenForConnectionModel: self.
!

connection
	^self
!

database
	^self dbxSettings database
!

database: aDatabase
	self dbxSettings database: aDatabase
!

dbxConnection
	^connection ifNil: [ connection := self createConnection ]
!

dbxPlatform
	^dbxPlatform
!

dbxPlatform: aPlatform
	dbxPlatform := aPlatform
!

dbxSettings
	^dbxSettings
!

host
	^self dbxSettings host
!

host: aHost
	self dbxSettings host: aHost
!

invalidateCache
	schemasCache := nil.
	self announce: DBXConnectionStatusChanged.
!

kindName
	^'Connection'
!

name
	^name
!

name: aName
	name := aName
!

password
	^self dbxSettings userPassword
!

password: aPassword
	self dbxSettings userPassword: aPassword
!

port
        "/ ^self dbxSettings port ifNotNil: [ :port | port asInteger].
        |p|

        p := self dbxSettings port.
        p notNil ifTrue:[ ^ p asInteger] ifFalse:[ ^ nil].
!

port: aPort
	self dbxSettings port: aPort asString
!

state
	^(connection notNil and: [ self dbxConnection isOpen ])
		ifTrue:  [ DBXBrowserOpenedConnection new ] 
		ifFalse: [ DBXBrowserClosedConnection   new ]
	
!

username
	^self dbxSettings userName
!

username: aUsername
	self dbxSettings userName: aUsername
! !

!DBXBrowserConnection methodsFor:'announcements'!

announce: anAnnouncement
	announcer announce: anAnnouncement
!

announcer: anAnnouncer
	announcer := anAnnouncer
! !

!DBXBrowserConnection methodsFor:'dbxHandling'!

close 
	self dbxConnection disconnect.
	self announce: DBXConnectionStatusChanged.
!

commit
	self dbxConnection commit
!

createConnection
	^DBXConnection platform: self dbxPlatform settings: self dbxSettings
!

execute: aQuery
	| result table |
	self withConnectionDo: [ :aConnection |
		^[
			result := aConnection execute: aQuery.
			result isResult
				ifTrue: [ GLMStacker new ]
				ifFalse: [
					table := GLMTablePresentation new.
					table display: [ result rows ].
					result columnDescriptions withIndexDo: [ :cd :index | 
						table column: cd name evaluated: [:row | (row rawValueAt: index) asString ].
					].
					table
				]
		  ]on: DBXError do: [ :error | GLMTextPresentation new display: error messageText ]
		]
!

fetchSchemas
	^schemasCache ifNil: [ 
		schemasCache := self withConnectionDo: [ :aConnection | aConnection schemas collect: [ :aSchema | DBXBrowserSchema 
															forSchema: aSchema onConnection: self ] ]
													]
!

fetchTablesForSchema: aSchema
	^self withConnectionDo: [ :aConnection | (aConnection tablesDescriptionForSchema: aSchema name)
		collect: [ :aTable | DBXBrowserTable forTable: aTable onConnection: self ] ]
!

open
	[
		connection := self createConnection.
		self dbxConnection connectAndOpen.
	] on: Error do: [ :ex | self close. ex pass ].
	self announce: DBXConnectionStatusChanged.
!

rollback
	self dbxConnection rollback
!

startTransaction
	self dbxConnection startTransaction
!

withConnectionDo: anAction
	^querySemaphore critical: [ anAction value: self dbxConnection ]
! !

!DBXBrowserConnection methodsFor:'glamourBrowser'!

actions
	| browser |
	^ self state actions, {
		(GLMGenericAction action: [:each | 
			browser := GLMTabulator new.
			browser title: 'Edit Connection'.
			browser row: #one.
			browser transmit to: #one; andShow: [ :a | a custom: each selection glamourPresentation ].
			browser openOn: each selection.
		] title: 'Edit') icon: FamFamFamSilkIcons new databaseEdit16x16.
		(GLMGenericAction action: [:each | each entity removeConnection: each selection] title: 'Remove Connection') icon: FamFamFamSilkIcons new databaseDelete16x16.
	}.
!

displayActionsOn: presentation
	presentation act: [ self open ] entitled: 'Open'.
	presentation act: [ self delete ] entitled: 'Delete'.
!

displayString
	^self name ifNil: [ self settingsDescriptionString ]
!

glamourPresentation
	^GLMMagrittePresentation new
			title: 'Edit Connection';
			description: [:x | 
				x description.
				] 
!

icon
	^self state icon
!

settingsDescriptionString
	^self dbxSettings database printString, 
		'(',  self dbxSettings userName printString, '@', 
			self dbxSettings host printString, ':', self dbxSettings port printString, ')'.
! !

!DBXBrowserConnection methodsFor:'initialize-release'!

initialize
	super initialize .
	dbxSettings := DBXConnectionSettings new.
	querySemaphore := Semaphore forMutualExclusion.
! !

!DBXBrowserConnection methodsFor:'testing'!

isOpen
	^self dbxConnection isOpen
! !

!DBXBrowserConnection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowserConnection.st,v 1.3 2013-04-15 13:53:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowserConnection.st,v 1.3 2013-04-15 13:53:36 cg Exp $'
! !

