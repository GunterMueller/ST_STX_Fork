"{ Package: 'stx:goodies/announcements/tests' }"

TestCase subclass:#SubscriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements-Tests'
!


!SubscriptionTest methodsFor:'tests'!

testActionValue
	| anAnn anAnnouncer subscription |
	subscription := StrongSubscription new.
	subscription action: [true].
	self assert: (subscription value: Announcement new) = true.

	subscription := StrongSubscription new.	
	subscription action: [:ann | ann].
	anAnn := Announcement new.
	self assert: (subscription value: anAnn) = anAnn.
	
	subscription := StrongSubscription new.
	subscription action: [ :ann :announcer | {  ann. announcer} ].
	anAnnouncer := Object new.
	subscription announcer: anAnnouncer.
	self assert: (subscription value: anAnn) = { anAnn. anAnnouncer}.

	subscription action: [ :a :b :c | {  a. b. c} ].
	self should: [ subscription value: anAnn ]	raise: Error
!

testAnnouncementClass

	| subscription |
	subscription := Subscription new.
	subscription announcementClass: Announcement.
	self assert: subscription announcementClass = Announcement.
!

testBlockForWithSelector
	"Obsolete"
	| object result announcer |
	announcer := Announcer new.
	object := 'The best test.'.
	result := announcer subscriptionRegistry subscriptionClass blockFor: object withSelector: #size.
	self assert: result isBlock.
	self assert: result numArgs = 0.
	self assert: result value = object size.
	result := announcer subscriptionRegistry subscriptionClass blockFor: object withSelector: #findString:.
	self assert: (result value: 'est') = (object findString: 'est').
	self assert: result isBlock.
	self assert: result numArgs = 1.
	result := announcer subscriptionRegistry subscriptionClass blockFor: object withSelector: #findString:startingAt:.
	self assert: result isBlock.
	self assert: result numArgs = 2.
	self assert: (result value: 'est' value: 8) = (object findString: 'est' startingAt: 8).
	
	
! !

!SubscriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/SubscriptionTest.st,v 1.1 2013-04-15 14:18:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/SubscriptionTest.st,v 1.1 2013-04-15 14:18:03 cg Exp $'
! !

