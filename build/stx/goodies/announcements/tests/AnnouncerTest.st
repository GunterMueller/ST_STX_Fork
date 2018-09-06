"{ Package: 'stx:goodies/announcements/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#AnnouncerTest
	instanceVariableNames:'announcer'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements-Tests'
!


!AnnouncerTest methodsFor:'oldtests'!

testSubcription
	| runs |
	runs := 0.
	announcer := Announcer new.		
	announcer when: TestAnnouncement1
		do: 
			[:ann | 
			ann x: 1.
			runs := runs + 1].
	self assert: (announcer announce: TestAnnouncement1) x = 1.
	self assert: runs = 1.
	announcer when: TestAnnouncement1
		do: 
			[:ann | 
			ann x: 2.
			runs := runs + 1].
	self 
		assert: (#(1 2 ) includes: (announcer announce: TestAnnouncement1) x).
	self assert: runs = 3.
	self assert: (announcer announce: Announcement) class = Announcement.
	self assert: runs = 3
!

testSubcription1
	| x |
	x := 0.
	announcer := Announcer new.	
	announcer when: Announcement do: [:ann |x := x + 1].
	self assert: (announcer announce: TestAnnouncement1 new) class = TestAnnouncement1.
	self assert: (announcer announce: TestAnnouncement2 new) class = TestAnnouncement2.
	self assert: (x = 2).
!

testSubcription2
	| x |
	x := 0.
	announcer := Announcer new.	
	announcer when: {TestAnnouncement1. Announcement} do: [:ann |x := x + 1].
	self assert: (announcer announce: TestAnnouncement1 new) class = TestAnnouncement1.
	self assert: (x = 2).
	self assert: (announcer announce: TestAnnouncement2 new) class = TestAnnouncement2.
	self assert: (x = 3).
	self assert: (announcer announce: Announcement new) class = Announcement .
	self assert: (x = 4).
!

testSubcriptionCollection
	| x |
	x := 0.
	announcer := Announcer new.	
	announcer when: {TestAnnouncement1. TestAnnouncement2 } do: [ :ann | ann x: 1. x := x + 1].
	self assert: (announcer announce: TestAnnouncement1 new) x = 1.
	self assert: (announcer announce: TestAnnouncement2 new) x = 1.
	self assert: x = 2.
!

testSubcriptionWhenSendTo
        | subscriber |
        announcer := Announcer new.             
        subscriber := TestSubscriber new.
        announcer when: TestAnnouncement1, Announcement send: #run to: subscriber.
        announcer announce: TestAnnouncement1.
        self assert: subscriber runs = 2.
        announcer announce: TestAnnouncement2.
        self assert: subscriber runs = 3.
        
        announcer when: TestAnnouncement2 send: #storeAnnouncement: to: subscriber.
        announcer announce: TestAnnouncement2.
        self assert: subscriber runs = 5.
        self assert: 
                ((subscriber announcements collect: [:each | each class]) asOrderedCollection sortBy: [ :a :b | a name < b name ]) =
                ({ UndefinedObject. UndefinedObject. UndefinedObject. UndefinedObject. TestAnnouncement2 } asOrderedCollection sortBy: [ :a :b | a name < b name]).
        
        announcer when: TestAnnouncement1 send: #storeAnnouncement:andAnnouncer: to: subscriber.
        announcer announce: TestAnnouncement1.
        self assert: subscriber runs = 8.
        self assert:
                (((subscriber announcements copyFrom: 6 to: 8) collect: [:each | each class]) asOrderedCollection sortBy: [:a :b | a name < b name]) =
                ({ UndefinedObject. UndefinedObject. TestAnnouncement1 } asOrderedCollection sortBy: [ :a :b | a name < b name]).
        self assert:
                (subscriber announcers select: [:each | each isNil not]) asArray = {announcer}.

        announcer announce: TestAnnouncement2 .
        self assert: subscriber runs = 10.
        self assert:
                (subscriber announcers copyFrom: 9 to: 10) asArray = {nil. nil}.
        self assert: (((subscriber announcements copyFrom: 9 to: 10) collect: [:each | each class]) asOrderedCollection sortBy: [:a :b | a name < b name]) =
                ({UndefinedObject. TestAnnouncement2} asOrderedCollection sortBy: [:a :b | a name < b name]).
!

testUnsubscribe
        | subscriber |
        announcer := Announcer new. 

        false ifTrue:[
            self should: [announcer unsubscribe: Object new] raise: Error.
            self should: [announcer unsubscribe: Object new from: Announcement] raise: Error.
        ].
        
        subscriber := Object new.
        
        announcer when: Announcement, TestAnnouncement1 do: [] for: subscriber.
        self assert: (announcer subscriptionRegistry subscriptionsOf: subscriber)  size = 2.
        announcer unsubscribe: subscriber.
        self assert: (announcer subscriptionRegistry subscriptionsOf: subscriber) isEmpty.
        
        announcer when: Announcement, TestAnnouncement2 do: [] for: subscriber.
        self assert: (announcer subscriptionRegistry subscriptionsOf: subscriber)  size = 2.
        announcer unsubscribe: subscriber from: Announcement.
        self assert: (announcer subscriptionRegistry subscriptionsOf: subscriber) size = 1.
        self assert: (announcer subscriptionRegistry subscriptionsOf: subscriber for: Announcement) isEmpty.
        self assert: (announcer subscriptionRegistry subscriptionsOf: subscriber for: TestAnnouncement2 ) size = 1.
! !

!AnnouncerTest methodsFor:'tests'!

testAnnounce
	"Subclasses of AXAnnouncement should be able to be announced, other classes shouldn't.
	Announcement objects (instances of AXAnnouncement or any of it's subclasses') should be able to be announced, others shouldn't
	#announce: should return the created announcement.
	#announce: should deliver an announcement to all the subscriptions that are subscribed for the class of the announcement or it's superclasses, that are subclasses of AXAnnouncement."
	| runs result |
	announcer := Announcer new.
	Announcement, TestAnnouncement1, TestAnnouncement2 do: [ :each | 
		result := announcer announce: each.
		self assert: result class == each.
		result := announcer announce: each new.
		self assert: result class == each].
	{ Object. ProtoObject. Array } do: [ :each | 
		self should: [ announcer announce: each ] raise: Error.
		self should: [ announcer announce: each basicNew ] raise: Error].
	
	runs := 0.
	announcer when: Announcement do: [ :anAnnouncement | 
		self assert: (anAnnouncement isKindOf: Announcement).
		runs := runs + 1].
	announcer when: TestAnnouncement1 do: [ :anAnnouncement | 
		self assert: anAnnouncement class == TestAnnouncement1.
		anAnnouncement x: 42.
		runs := runs + 1 ].
	self assert: announcer subscriptionRegistry allSubscriptions size = 2.
	
	result := announcer announce: TestAnnouncement1.
	self assert: result class == TestAnnouncement1.
	self assert: result x = 42.
	self assert: runs = 2.
	runs := 0.
	result := announcer announce: Announcement.
	self assert: result class == Announcement.
	self assert: runs = 1.
	
	
!

testInitialize
	announcer := Announcer new.
	self assert: announcer subscriptionRegistry isNil not

	
!

testMayAnnounce
	announcer := Announcer new.
	Announcement, TestAnnouncement1, TestAnnouncement2 do: [ :each |
		self assert: (announcer mayAnnounce: each) ].
	{ Object. ProtoObject. Array } do: [ :each |
		self assert: (announcer mayAnnounce: each) not ]
	
!

testMultipleSubscriptions
	| newSubscriptions |
	announcer := Announcer new.
	newSubscriptions := announcer when: TestAnnouncement1, TestAnnouncement2 do:
		[].
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 2.
	
	self assert: announcer subscriptionRegistry allSubscriptions size = 2.
	self assert: (announcer subscriptionRegistry allSubscriptions collect: 
		[ :each | each announcementClass ]) asSet = { TestAnnouncement1. TestAnnouncement2} asSet.
	announcer := Announcer new.
	newSubscriptions := announcer when: Announcement, TestAnnouncement1, 
		TestAnnouncement2 do: [] for: [].
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 3.
	self assert: announcer subscriptionRegistry allSubscriptions size = 3.
	
	announcer := Announcer new.
	newSubscriptions := announcer when: Announcement, Announcement send: #yourself to: [].
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 2.
	self assert: announcer subscriptionRegistry allSubscriptions size = 2.
	
	announcer := Announcer new.
	newSubscriptions := announcer when: {Announcement. Announcement} send: #yourself to: [].
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 2.
	self assert: announcer subscriptionRegistry allSubscriptions size = 2.
	
	announcer := Announcer new.
	newSubscriptions := announcer when: {Announcement} send: #yourself to: [].
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 1.
	self assert: announcer subscriptionRegistry allSubscriptions size = 1.
		
	
!

testOnDo
	| results subscriptions newSubscriptions |
	announcer := Announcer new.
	results := OrderedCollection new.
	newSubscriptions := announcer on: Announcement do: [ results add: 0 ].
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 1.
	announcer announce: Announcement.
	self assert: results size = 1.
	self assert: results first = 0.
	newSubscriptions := announcer on: Announcement do: [ :anAnnouncement | 
		self assert: anAnnouncement class == Announcement.
		results add: 1].
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 1.
	announcer announce: Announcement.
	self assert: (results asSet = #(0 1) asSet).
	self assert: results size = 3.
	self assert: (results count: [ :each | each = 0]) = 2.
	self assert: (results count: [ :each | each = 1]) = 1.	
	newSubscriptions := announcer on: Announcement do: [ :anAnnouncement :anAnnouncer |
		self assert: anAnnouncement class == Announcement.
		self assert: anAnnouncer == announcer.
		results add: 2].
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 1.
	announcer announce: Announcement.
	self assert: (results asSet = #(0 1 2) asSet).
	self assert: results size = 6.
	self assert: (results count: [ :each | each = 0]) = 3.
	self assert: (results count: [ :each | each = 1]) = 2.	
	self assert: (results count: [ :each | each = 2]) = 1.			
	subscriptions := announcer subscriptionRegistry allSubscriptions.
	self assert: subscriptions size = 3.
	self assert: (subscriptions allSatisfy: [ :each |
		(each action == each subscriber) and: [ each action isBlock ] ]).
	self assert: (subscriptions collect: [ :each | each action numArgs]) asSet = #(0 1 2) asSet
!

testOnSendTo
        | result blocks newSubscriptions |
        announcer := Announcer new.
        result := OrderedCollection new.
        blocks := {
                [result add: 0 ].
                [ :first | result add: first ].
                [ :first :second | result add: first; add: second ].
                [ :first :second :third | result add: first; add: second ]}.
        newSubscriptions := announcer on: Announcement send: #value to: blocks first.
        self assert: newSubscriptions class == SubscriptionCollection.
        self assert: newSubscriptions size = 1.
        announcer announce: Announcement.
        self assert: result asArray = #(0).
        newSubscriptions := announcer on: Announcement send: #value: to: blocks second.
        self assert: newSubscriptions class == SubscriptionCollection.
        self assert: newSubscriptions size = 1.
        announcer announce: Announcement.
        self assert: result size = 3.
        self assert: (result select: [ :each | each = 0 ]) size = 2.
        self assert: (result select: [ :each | each class == Announcement ]) size = 1.
        newSubscriptions := announcer on: Announcement send: #value:value: to: blocks third.    
        self assert: newSubscriptions class == SubscriptionCollection.
        self assert: newSubscriptions size = 1.
        announcer announce: Announcement.
        self assert: result size = 7.
        self assert: (result select: [ :each | each = 0 ]) size = 3.
        self assert: (result select: [ :each | each class == Announcement ]) size = 3.
        self assert: (result includes: announcer).
        self should:
                [ announcer on: Announcement send: #value:value:value: to: blocks fourth ]
                raise: Error
!

testSubscriptionRegistry
	announcer := Announcer new.
	self assert: announcer subscriptionRegistry class == SubscriptionRegistry.
	
!

testWhenDo
	| results subscriptions newSubscriptions |
	announcer := Announcer new.
	results := OrderedCollection new.
	newSubscriptions := announcer when: Announcement do: [ results add: 0 ].
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 1.
	announcer announce: Announcement.
	self assert: results size = 1.
	self assert: results first = 0.
	newSubscriptions := announcer when: Announcement do: [ :anAnnouncement | 
		self assert: anAnnouncement class == Announcement.
		results add: 1].
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 1.
	announcer announce: Announcement.
	self assert: (results asSet = #(0 1) asSet).
	self assert: results size = 3.
	self assert: (results count: [ :each | each = 0]) = 2.
	self assert: (results count: [ :each | each = 1]) = 1.	
	newSubscriptions := announcer when: Announcement do: [ :anAnnouncement :anAnnouncer |
		self assert: anAnnouncement class == Announcement.
		self assert: anAnnouncer == announcer.
		results add: 2].
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 1.
	announcer announce: Announcement.
	self assert: (results asSet = #(0 1 2) asSet).
	self assert: results size = 6.
	self assert: (results count: [ :each | each = 0]) = 3.
	self assert: (results count: [ :each | each = 1]) = 2.	
	self assert: (results count: [ :each | each = 2]) = 1.			
	subscriptions := announcer subscriptionRegistry allSubscriptions.
	self assert: subscriptions size = 3.
	self assert: (subscriptions allSatisfy: [ :each |
		(each action == each subscriber) and: [ each action isBlock ] ]).
	self assert: (subscriptions collect: [ :each | each action numArgs]) asSet = #(0 1 2) asSet
!

testWhenDoFor
	| results subscriptions subscriber1 subscriber2 newSubscriptions |
	announcer := Announcer new.
	results := OrderedCollection new.
	subscriber1 := Object new.
	subscriber2 := Object new.
	newSubscriptions := announcer when: Announcement do: [ results add: 0 ] for: subscriber1.
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 1.
	announcer announce: Announcement.
	self assert: results size = 1.
	self assert: results first = 0.
	newSubscriptions := announcer when: Announcement do: [ :anAnnouncement | 
		self assert: anAnnouncement class == Announcement.
		results add: 1] for: subscriber2.
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 1.
	announcer announce: Announcement.
	self assert: (results asSet = #(0 1) asSet).
	self assert: results size = 3.
	self assert: (results count: [ :each | each = 0]) = 2.
	self assert: (results count: [ :each | each = 1]) = 1.	
	newSubscriptions := announcer when: Announcement do: [ :anAnnouncement :anAnnouncer |
		self assert: anAnnouncement class == Announcement.
		self assert: anAnnouncer == announcer.
		results add: 2] for: subscriber1.
	self assert: newSubscriptions class == SubscriptionCollection.
	self assert: newSubscriptions size = 1.
	announcer announce: Announcement.
	self assert: (results asSet = #(0 1 2) asSet).
	self assert: results size = 6.
	self assert: (results count: [ :each | each = 0]) = 3.
	self assert: (results count: [ :each | each = 1]) = 2.	
	self assert: (results count: [ :each | each = 2]) = 1.			
	subscriptions := announcer subscriptionRegistry allSubscriptions.
	self assert: subscriptions size = 3.
	self assert: (subscriptions select: [ :each | each subscriber == subscriber1 ]) size = 2.
	self assert: (subscriptions select: [ :each | each subscriber == subscriber1 ] thenCollect:
		[ :each | each action numArgs]) asSet = #(0 2) asSet.
	self assert: (subscriptions select: [ :each | each subscriber == subscriber2 ]) size = 1.
	self assert: (subscriptions select: [ :each | each subscriber == subscriber2 ] thenCollect:
		[ :each | each action numArgs]) asSet = #(1) asSet.
	self assert: (subscriptions collect: [ :each | each action numArgs]) asSet = #(0 1 2) asSet
!

testWhenSendTo
        | result blocks newSubscriptions |
        announcer := Announcer new.
        result := OrderedCollection new.
        blocks := {
                [result add: 0 ].
                [ :first | result add: first ].
                [ :first :second | result add: first; add: second ].
                [ :first :second :third | result add: first; add: second ]}.
        newSubscriptions := announcer when: Announcement send: #value to: blocks first.
        self assert: newSubscriptions class == SubscriptionCollection.
        self assert: newSubscriptions size = 1.
        announcer announce: Announcement.
        self assert: result asArray = #(0).
        newSubscriptions := announcer when: Announcement send: #value: to: blocks second.
        self assert: newSubscriptions class == SubscriptionCollection.
        self assert: newSubscriptions size = 1.
        announcer announce: Announcement.
        self assert: result size = 3.
        self assert: (result select: [ :each | each = 0 ]) size = 2.
        self assert: (result select: [ :each | each class == Announcement ]) size = 1.
        newSubscriptions := announcer when: Announcement send: #value:value: to: blocks third.  
        self assert: newSubscriptions class == SubscriptionCollection.
        self assert: newSubscriptions size = 1.
        announcer announce: Announcement.
        self assert: result size = 7.
        self assert: (result select: [ :each | each = 0 ]) size = 3.
        self assert: (result select: [ :each | each class == Announcement ]) size = 3.
        self assert: (result includes: announcer).
        self 
                should: [ announcer when: Announcement send: #value:value:value: to: blocks fourth ]
                raise: Error
! !

!AnnouncerTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/AnnouncerTest.st,v 1.3 2017-01-01 15:22:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/AnnouncerTest.st,v 1.3 2017-01-01 15:22:44 cg Exp $'
! !

