"{ Package: 'stx:goodies/announcements/tests' }"

TestCase subclass:#SubscriptionCollectionTest
	instanceVariableNames:'announcer'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements-Tests'
!


!SubscriptionCollectionTest methodsFor:'running'!

setUp
	announcer := Announcer new
	
! !

!SubscriptionCollectionTest methodsFor:'tests'!

testAll
	| calls calls2 misses intercepted intercepted2 |
	calls := 0.
	calls2 := 0.
	misses := 0.
	intercepted := false.
	intercepted2 := false.
	announcer when: Announcement do: [calls := calls + 1].
	announcer when: TestAnnouncement1 do: [calls2 := calls2 + 1].	
	announcer announce: Announcement.
	self assert: calls = 1.
	self assert: calls2 = 0.	
	announcer announce: TestAnnouncement1 .
	self assert: calls = 2.
	self assert: calls2 = 1.
	announcer subscriptionRegistry allSubscriptions suspendWhile: [
			(announcer subscriptionRegistry subscriptionsFor: TestAnnouncement1) interceptWith: [
				intercepted := true.
			] while: [
				(announcer subscriptionRegistry subscriptionsFor: Announcement) interceptWith: [
					intercepted2 := true.
				] while: [
					announcer announce: Announcement .
					self assert: intercepted not.
					self assert: intercepted2.
					intercepted2 := false.
					self assert: calls = 2.
					self assert: calls2 = 1.
					announcer announce: TestAnnouncement1.
					self assert: intercepted.
					self assert: intercepted2.
					intercepted := false.					
					intercepted2 := false.
					self assert: calls = 2.
					self assert: calls2 = 1.
					announcer subscriptionRegistry allSubscriptions interceptWith: [ :announcement :anAnnouncer :subscription |
						subscription deliver: announcement  from: anAnnouncer.
					] while: [
						announcer announce: TestAnnouncement1.
						self assert: intercepted.
						self assert: intercepted2.
						self assert: calls = 3.
						self assert: calls2 = 2.
						intercepted := false.					
						intercepted2 := false.
						announcer announce: Announcement.
						self assert: intercepted not.
						self assert: intercepted2.
						self assert: calls = 4.
						self assert: calls2 = 2.
						intercepted2 := false.
						announcer announce: TestAnnouncement2 .
						self assert: intercepted not.
						self assert: intercepted2.
						self assert: calls = 5.
						self assert: calls2 = 2.
						intercepted2 := false.
					].
					announcer announce: TestAnnouncement1.
					self assert: intercepted.
					self assert: intercepted2.
					intercepted := false.					
					intercepted2 := false.
					self assert: calls = 5.
					self assert: calls2 = 2.
					announcer announce: TestAnnouncement2.
					self assert: intercepted not.
					self assert: intercepted2.
					intercepted2 := false.
					self assert: calls = 5.
					self assert: calls2 = 2.				
				].
				(announcer subscriptionRegistry subscriptionsFor: Announcement) suspendWhile: [
					announcer announce: TestAnnouncement1.
					self assert: intercepted.
					self assert: intercepted2 not.
					intercepted := false.
					self assert: calls = 5.
					self assert: calls2 = 2.						
					self assert: misses = 0.
				] ifAnyMissed: [misses := misses + 1].
				self assert: misses = 1.
			].
			self assert: misses = 1.		
	] ifAnyMissed: [misses := misses + 1].
	self assert: misses = 2.

	
!

testIterceptWithWhile
	| calls intercepted |
	calls := 0.
	intercepted := false.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce: Announcement.
	self assert: calls = 1.
	announcer subscriptionRegistry allSubscriptions 
		interceptWith: [intercepted := true]
		while: [announcer announce: Announcement].
	self assert: calls = 1.
 	self assert: intercepted = true.
	announcer announce: Announcement.
	self assert: calls = 2.
	intercepted := false.
	announcer subscriptionRegistry allSubscriptions 
		interceptWith: [intercepted := true] while: [calls := calls + 1].
	self assert: calls = 3.
	self assert: intercepted = false
!

testIterceptWithWhile2
	| calls intercepted intercepted2 |
	calls := 0.
	intercepted := false.
	intercepted2 := false.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce: Announcement.
	self assert: calls = 1.
	announcer subscriptionRegistry allSubscriptions 
		interceptWith: [intercepted := true]
		while: [
			announcer subscriptionRegistry allSubscriptions 
				interceptWith: [intercepted2 := true]
				while: [
					announcer announce: Announcement.
					self assert: intercepted.					
					self assert: intercepted2.
					intercepted := false.
					intercepted2 := false.
				].
		].
	self assert: calls = 1.
	announcer announce: Announcement.
	self assert: calls = 2.
	self assert: intercepted not.					
	self assert: intercepted2 not.
!

testIterceptWithWhile3
	| calls intercepted|
	calls := 0.
	intercepted := false.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce: Announcement.
	self assert: calls = 1.
	announcer subscriptionRegistry allSubscriptions 
		interceptWith: [ :announcement |
			self assert: announcement class = Announcement. 
			intercepted := true]
		while: [announcer announce: Announcement. self assert: intercepted. intercepted := false.].
	self assert: calls = 1.
	announcer announce: Announcement.
	self assert: calls = 2.
	self assert: intercepted not
!

testIterceptWithWhile4
	| calls intercepted|
	calls := 0.
	intercepted := false.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce: Announcement.
	self assert: calls = 1.
	announcer subscriptionRegistry allSubscriptions 
		interceptWith: [ :announcement :anAnnouncer |
			self assert: announcement class = Announcement. 
			self assert: anAnnouncer  = announcer.
			intercepted := true]
		while: [announcer announce: Announcement. self assert: intercepted. intercepted := false.].
	self assert: calls = 1.
	announcer announce: Announcement.
	self assert: calls = 2.
	self assert: intercepted not
!

testIterceptWithWhile5
	| calls intercepted|
	calls := 0.
	intercepted := false.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce: Announcement.
	self assert: calls = 1.
	announcer subscriptionRegistry allSubscriptions 
		interceptWith: [ :announcement :anAnnouncer :subscription |
			self assert: announcement class = Announcement. 
			self assert: anAnnouncer  = announcer.
			self assert: announcer  subscriptionRegistry allSubscriptions first = subscription.
			intercepted := true]
		while: [announcer announce: Announcement. self assert: intercepted. intercepted := false.].
	self assert: calls = 1.
	announcer announce: Announcement.
	self assert: calls = 2.
	self assert: intercepted not
!

testIterceptWithWhile6
	| calls intercepted|
	calls := 0.
	intercepted := false.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce: Announcement.
	self assert: calls = 1.
	self should: [announcer subscriptionRegistry allSubscriptions 
		interceptWith: [ :announcement :anAnnouncer :subscription :badParameter|
			intercepted := true]
		while: [announcer announce: Announcement. self assert: intercepted. intercepted := false.]] raise: Error.
	self assert: calls = 1.
	announcer announce: Announcement.
	self assert: calls = 2.
	self assert: intercepted not
!

testIterceptWithWhileDeliverFrom
	| calls intercepted|
	calls := 0.
	intercepted := false.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce: Announcement.
	self assert: calls = 1.
	announcer subscriptionRegistry allSubscriptions 
		interceptWith: [ :announcement :anAnnouncer :subscription |
			subscription deliver: announcement  from: anAnnouncer.
			intercepted := true]
		while: [announcer announce: Announcement. self assert: intercepted. intercepted := false.].
	self assert: calls = 2.
	announcer announce: Announcement.
	self assert: calls = 3.
	self assert: intercepted not
!

testIterceptWithWhileDeliverFrom1
	| calls |
	calls := 0.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce: Announcement.
	self assert: calls = 1.
	announcer subscriptionRegistry allSubscriptions 
		interceptWith: [ :announcement :anAnnouncer :subscription | subscription deliver: announcement  from: anAnnouncer]
		while: [announcer announce: Announcement.].
	self assert: calls = 2.
	announcer announce: Announcement.
	self assert: calls = 3.

!

testIterceptWithWhileDeliverFrom2
	| calls |
	calls := 0.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce: Announcement.
	self assert: calls = 1.
	announcer subscriptionRegistry allSubscriptions 
		interceptWith: [ :announcement :anAnnouncer :subscription | subscription deliver: announcement  from: anAnnouncer]
		while: [
		announcer subscriptionRegistry allSubscriptions 
			interceptWith: [ :announcement :anAnnouncer :subscription | subscription deliver: announcement  from: anAnnouncer]
			while: [
			announcer announce: Announcement.]
		].
	self assert: calls = 3.
	announcer announce: Announcement.
	self assert: calls = 4.

!

testSuspendWhile
	| calls |
	calls := 0.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce:  Announcement.
	self assert: calls = 1.
	announcer subscriptionRegistry allSubscriptions suspendWhile: [announcer announce:  Announcement].
	self assert: calls = 1.
	announcer announce:  Announcement.
	self assert: calls = 2.
!

testSuspendWhile2
	| calls |
	calls := 0.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce:  Announcement.
	self assert: calls = 1.
	announcer subscriptionRegistry allSubscriptions suspendWhile: [
		announcer subscriptionRegistry allSubscriptions suspendWhile: [
			announcer announce:  Announcement
		].
		announcer announce:  Announcement
	].
	self assert: calls = 1.
	announcer announce:  Announcement.
	self assert: calls = 2.
!

testSuspendWhileIfAnyMissed
	| calls anyMissed |
	calls := 0.
	anyMissed := false.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce:  Announcement.
	self assert: calls = 1.
	announcer subscriptionRegistry allSubscriptions suspendWhile: [announcer announce:  Announcement] ifAnyMissed: [ anyMissed := true ].
	self assert: calls = 1.
	self assert: anyMissed = true.
	announcer announce:  Announcement.
	self assert: calls = 2.
	anyMissed := false.
	announcer subscriptionRegistry allSubscriptions suspendWhile: [calls := calls + 1] ifAnyMissed: [ anyMissed := true ].
	self assert: calls = 3.
	self assert: anyMissed = false.
	
	
!

testSuspendWhileIfAnyMissed2
	| calls misses |
	calls := 0.
	misses := 0.
	announcer when: Announcement do: [calls := calls + 1].
	announcer announce: Announcement.
	self assert: calls = 1.
	announcer subscriptionRegistry allSubscriptions suspendWhile: 
			[announcer subscriptionRegistry allSubscriptions 
				suspendWhile: [announcer announce: Announcement]
				ifAnyMissed: [misses := misses + 1]]
	ifAnyMissed: [misses := misses + 1].
	self assert: calls = 1.
	self assert: misses = 2.
	announcer announce: Announcement.
	self assert: calls = 2.
	announcer subscriptionRegistry allSubscriptions suspendWhile: [
		announcer subscriptionRegistry allSubscriptions 
				suspendWhile: [ calls := calls + 1]
				ifAnyMissed: [misses := misses + 1].
		announcer announce: Announcement				
	] ifAnyMissed: [misses := misses + 1].
	self assert: calls = 3.
	self assert: misses = 3.
	announcer subscriptionRegistry allSubscriptions suspendWhile: [
		announcer subscriptionRegistry allSubscriptions 
				suspendWhile: [ announcer announce: Announcement]
				ifAnyMissed: [misses := misses + 1].
		announcer announce: Announcement				
	] ifAnyMissed: [misses := misses + 1].
	self assert: misses = 5.

	
! !

!SubscriptionCollectionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/SubscriptionCollectionTest.st,v 1.1 2013-04-15 14:18:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/SubscriptionCollectionTest.st,v 1.1 2013-04-15 14:18:00 cg Exp $'
! !

