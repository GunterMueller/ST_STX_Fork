"{ Package: 'stx:libdb/libopenDBX/tools/descriptions' }"

TestCase subclass:#DBXGlorpDescriptionTest
	instanceVariableNames:'application session connection'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTools-DescriptionsTests'
!


!DBXGlorpDescriptionTest class methodsFor:'as yet unclassified'!

resources
	^Array with: GlorpDatabaseLoginResource
! !

!DBXGlorpDescriptionTest methodsFor:'as yet unclassified'!

setUp
	| login system |
	super setUp.
	
	application := DBXApplication fromCategory: 'DBXTools-DescriptionsTests-Domain'.
	login := GlorpDatabaseLoginResource defaultLogin copy.
	system := DBXDescriptorSystem forApplication: application andPlatform: login database.
	session := system sessionForLogin: login.
	session accessor login.
	session createTables.
!

tearDown
	session dropTables.
	session logout.
!

testBidirectionalMapping
	| player pet pets players |

	"Setting up data"
	player := Dbxplayer new playerLevel: 10; playerName: 'Cacho'; yourself.
	pet := Dbxpet new petName: 'Belcha'; playerid: player; yourself.
	player pet: pet.
	
	session transact:[
"		session register: player."
		session register: pet.
	].

	session reset.
	
	pets:= session readManyOf: Dbxpet.
	players := (session readManyOf: Dbxplayer).
	
	self assert: players size = 1.
	self assert: pets size = 1.
	self assert: players first pet notNil.
	self assert: pets first playerid notNil.
	self assert: pets first playerid = players first.
	self assert: players first pet = pets first.
	



!

testToManyBidirectionalMapping
	| player pet pets players |

	"Setting up data"
	player := Dbxplayer new playerLevel: 10; playerName: 'Cacho'; yourself.
	pet := Dbxpet new petName: 'Belcha'; playerid: player; yourself.
	player pet: pet.
	
	session transact:[
"		session register: player."
		session register: pet.
	].

	session reset.
	
	pets:= session readManyOf: Dbxpet.
	players := (session readManyOf: Dbxplayer).
	
	self assert: players size = 1.
	self assert: pets size = 1.
	self assert: players first pet notNil.
	self assert: pets first playerid notNil.
	self assert: pets first playerid = players first.
	self assert: players first pet = pets first.
	



!

testToManySingleMapping
	| player pet pets players items |

	"Setting up data"
	player := Dbxplayer new  playerLevel: 10; playerName: 'Cacho'; yourself.
	player addItem: 'sword'.
	player addItem: 'potion'.
	
	session transact:[
		session register: player.
	].
	session reset.
	
	players := (session readManyOf: Dbxplayer).
	
	self assert: players size = 1.
	
	items := players first items.
	self assert: items size = 2.
	self assert: (items anySatisfy: [ :i | i itemName = 'sword' ]).
	self assert: (items anySatisfy: [ :i | i itemName = 'potion' ]).
	



!

testToOneBidirectionalMapping
	"TODO"



!

testToOneSingleMapping
	| player pet pets players archerClass |

	"Setting up data"
	player := Dbxplayer new playerLevel: 10; playerName: 'Cacho'; yourself.
	archerClass := Dbxclass new className: 'archer'; specialAbility: 'arrow'; powerBonus: 5; yourself.
	player playerClass: archerClass.
	
	session transact:[
		session register: player.
	].

	session reset.
	
	players := (session readManyOf: Dbxplayer).
	
	self assert: players size = 1.
	self assert: players first playerClass notNil.
	self assert: players first playerClass className = 'archer'.



! !

!DBXGlorpDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/DBXGlorpDescriptionTest.st,v 1.2 2013-04-15 13:35:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/DBXGlorpDescriptionTest.st,v 1.2 2013-04-15 13:35:02 cg Exp $'
! !

