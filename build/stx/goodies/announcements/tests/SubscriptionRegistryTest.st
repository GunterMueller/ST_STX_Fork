"{ Package: 'stx:goodies/announcements/tests' }"

TestCase subclass:#SubscriptionRegistryTest
	instanceVariableNames:'registry'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements-Tests'
!


!SubscriptionRegistryTest methodsFor:'running'!

setUp
	registry := SubscriptionRegistry new
! !

!SubscriptionRegistryTest methodsFor:'tests'!

testAllSubscriptions
	| subscriptions |
	subscriptions := {
		StrongSubscription new
			announcer: Object new;
			announcementClass: TestAnnouncement1;
			subscriber: Object new;
			action: [:a :b| true].
		StrongSubscription new
			announcer: Object new;
			announcementClass: TestAnnouncement2;
			subscriber: Object new;
			action: [:a :b| true].
		StrongSubscription new
			announcer: Object new;
			announcementClass: TestAnnouncement2;
			subscriber: Object new;
			action: [:a :b| true].
		}.
	registry register: subscriptions first.
	registry register: subscriptions second.
	registry register: subscriptions third.
	self assert: (registry allSubscriptions  ) asSet = subscriptions asSet.
!

testRegisterBasic

	| subscription announcer announcementClass subscriber action |
	subscription := StrongSubscription new.
	announcer := Object new.
	announcementClass := Announcement .
	subscriber := Object new.
	action := [true].
	subscription := StrongSubscription 
		newWithAction: action
		announcer: announcer
		announcementClass: announcementClass 
		subscriber: subscriber.
	registry register: subscription.
	self assert: (registry subscriptionsFor: announcementClass) asArray = { subscription }.
	self assert: (registry subscriptionsOf: subscriber) asArray = { subscription }
!

testRegisterCollections

	| subscriptions |
	subscriptions := {
		StrongSubscription new
			announcer: Object new;
			announcementClass: TestAnnouncement1;
			subscriber: Object new;
			action: [:a :b| true].
		StrongSubscription new
			announcer: Object new;
			announcementClass: TestAnnouncement2;
			subscriber: Object new;
			action: [:a :b| true].
		}.
	registry register: subscriptions first.
	registry register: subscriptions second.
	self assert: (registry subscriptionsFor: TestAnnouncement1 ) asArray = {subscriptions first.}.
	self assert: (registry subscriptionsFor: TestAnnouncement2 ) asArray = {subscriptions second.}.
	self assert: (registry subscriptionsFor: Announcement ) asSet = Set new
!

testRegisterCollections2
	| subscription |
	subscription :=
		StrongSubscription new
			announcer: Object new;
			announcementClass: Announcement;
			subscriber: Object new;
			action: [:a :b| true].
	registry register: subscription.
	self assert: (registry subscriptionsFor: TestAnnouncement1) asSet = #() asSet
			
!

testRemoveSubscriptions
	| subscriptions subscriber |
	subscriber := TestSubscriber new.
	subscriptions := {
		StrongSubscription new
			announcer: Object new;
			announcementClass: TestAnnouncement1;
			subscriber: subscriber;
			action: [:a :b| true].
		StrongSubscription new
			announcer: Object new;
			announcementClass: TestAnnouncement1;
			subscriber: subscriber;
			action: [:a :b| true].
		StrongSubscription new
			announcer: Object new;
			announcementClass: TestAnnouncement2;
			subscriber: subscriber;
			action: [:a :b| true].
		StrongSubscription new
			announcer: Object new;
			announcementClass: TestAnnouncement2 ;
			subscriber: subscriber;
			action: [:a :b| true].
		}.
	subscriptions do: [:each |
		registry register: each.
	].
	self assert: (registry subscriptionsOf: subscriber) size = 4.
	self assert: (registry subscriptionsOf: subscriber for: TestAnnouncement1) size = 2.
	self assert: (registry subscriptionsOf: subscriber for: TestAnnouncement2) size = 2.
	self assert: (registry subscriptionsOf: subscriber for: Announcement) size = 0.
	self assert: ((registry subscriptionsOf: subscriber) includes: subscriptions first).			
	self assert: ((registry subscriptionsOf: subscriber) includes: subscriptions second).			
	self assert: ((registry subscriptionsOf: subscriber) includes: subscriptions third).			
	self assert: ((registry subscriptionsOf: subscriber) includes: subscriptions fourth).			
	registry removeSubscriptions: {subscriptions first}.
	self assert: (registry subscriptionsOf: subscriber) size = 3.
	self assert: (registry subscriptionsOf: subscriber for: TestAnnouncement1) size = 1.
	self assert: (registry subscriptionsOf: subscriber for: TestAnnouncement2) size = 2.
	self assert: ((registry subscriptionsOf: subscriber) includes: subscriptions second).			
	self assert: ((registry subscriptionsOf: subscriber) includes: subscriptions third).			
	self assert: ((registry subscriptionsOf: subscriber) includes: subscriptions fourth).			
	registry removeSubscriptions: {subscriptions third}.
	self assert: (registry subscriptionsOf: subscriber) size = 2.
	self assert: (registry subscriptionsOf: subscriber for: TestAnnouncement1) size = 1.
	self assert: (registry subscriptionsOf: subscriber for: TestAnnouncement2) size = 1.
	self assert: ((registry subscriptionsOf: subscriber) includes: subscriptions second).			
	self assert: ((registry subscriptionsOf: subscriber) includes: subscriptions fourth).			
	registry removeSubscriptions: {subscriptions fourth}.
	self assert: (registry subscriptionsOf: subscriber) size = 1.
	self assert: (registry subscriptionsOf: subscriber for: TestAnnouncement1) size = 1.
	self assert: ((registry subscriptionsOf: subscriber) includes: subscriptions second).			
	registry removeSubscriptions: {subscriptions second}.
	"Implementation specific parts!!!!!!!!"
	self assert: (registry instVarNamed: #subscriptionsByAnnouncementClasses) size = 0.

	"Doesn't work :(
	subscriber := subscriber hash.
	Smalltalk garbageCollect.
	self assert: (TestSubscriber allInstances noneSatisfy: [:each | each hash = subscriber])."

!

testSubscriptionsOfFor
	| subscriptions subscriber |
	subscriber := Object new.
	subscriptions := {
		StrongSubscription new
			announcer: Object new;
			announcementClass: TestAnnouncement1;
			subscriber: subscriber;
			action: [:a :b| true].
		StrongSubscription new
			announcer: Object new;
			announcementClass: TestAnnouncement2;
			subscriber: subscriber;
			action: [:a :b| true].
		StrongSubscription new
			announcer: Object new;
			announcementClass: TestAnnouncement2;
			subscriber: Object new;
			action: [:a :b| true].
		StrongSubscription new
			announcer: Object new;
			announcementClass: Announcement ;
			subscriber: subscriber;
			action: [:a :b| true].
		}.
	registry register: subscriptions first.
	registry register: subscriptions second.
	registry register: subscriptions third.
	self assert: (registry subscriptionsOf: subscriber for: TestAnnouncement1 ) asArray = {subscriptions first.}.
	self assert: (registry subscriptionsOf: subscriber for: TestAnnouncement2 ) asArray = {subscriptions second.}.
	self assert: (registry subscriptionsOf: subscriber for: Announcement  ) asArray = {}.
	self assert: (registry subscriptionsOf: subscriber for: {TestAnnouncement1. TestAnnouncement2.} ) asSet = {subscriptions first. subscriptions second} asSet.
	self assert: (registry subscriptionsOf: Object new for: TestAnnouncement1 ) asArray = {}.
	self assert: (registry subscriptionsOf: Object new for: {TestAnnouncement1. TestAnnouncement2.} ) asArray = {}.
	
	registry register: subscriptions fourth.
	self assert: (registry subscriptionsOf: subscriber for: TestAnnouncement1 ) asArray = {subscriptions first.}.
! !

!SubscriptionRegistryTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/SubscriptionRegistryTest.st,v 1.1 2013-04-15 14:17:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/SubscriptionRegistryTest.st,v 1.1 2013-04-15 14:17:47 cg Exp $'
! !

