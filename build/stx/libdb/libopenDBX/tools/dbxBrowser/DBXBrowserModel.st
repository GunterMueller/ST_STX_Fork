"{ Package: 'stx:libdb/libopenDBX/tools/dbxBrowser' }"

Object subclass:#DBXBrowserModel
	instanceVariableNames:'announcer query selectedItem'
	classVariableNames:'SavedConnections UniqueAnnouncer'
	poolDictionaries:''
	category:'DataBase-DBXBrowser-Model'
!


!DBXBrowserModel class methodsFor:'as yet unclassified'!

savedConnections 
	SavedConnections ifNil:  [self savedConnections: Set new] .
	^ SavedConnections.
!

savedConnections: connections
	SavedConnections := connections .
!

uniqueAnnouncer
	^UniqueAnnouncer ifNil: [ UniqueAnnouncer := Announcer new ]
! !

!DBXBrowserModel methodsFor:'accessing'!

connections
	^self class savedConnections do: [ :conn | conn announcer: self]; yourself
!

query
	^query ifNil: [ '' ]
!

query: aQueryString
	query := aQueryString.
!

selectedItem
	^selectedItem ifNil: [ self ]
! !

!DBXBrowserModel methodsFor:'event-handling'!

announce: something
	announcer announce: something
!

announcer: anAnnouncer
	announcer := anAnnouncer
!

onCreateConnection
	| browser |
	browser := GLMTabulator new.
	browser row: #one.
	browser transmit to: #one; andShow:[ :a |
		a magritte
			title: 'Connection';
			description: [:x | x description ];
			onAnswer: [:answer| answer ifNotNil: [self saveConnection: answer. browser close. ] ]
			].
	browser openOn: (DBXBrowserConnection new announcer: self; yourself).
!

removeConnection: aConnection
	self connections remove: aConnection.
	self announce: DBXConnectionRemoved.
!

saveConnection: aConnection
	self connections add: aConnection.
	self announce: DBXConnectionAdded.
! !

!DBXBrowserModel methodsFor:'glamourBrowsers'!

glamourPresentation
	^GLMStacker new
! !

!DBXBrowserModel methodsFor:'initialize-release'!

initialize
	super initialize.
	announcer := self class uniqueAnnouncer.
! !

!DBXBrowserModel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowserModel.st,v 1.2 2013-04-15 13:46:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowserModel.st,v 1.2 2013-04-15 13:46:15 cg Exp $'
! !

