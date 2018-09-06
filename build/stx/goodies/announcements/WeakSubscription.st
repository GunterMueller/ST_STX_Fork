"{ Package: 'stx:goodies/announcements' }"

StrongSubscription subclass:#WeakSubscription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements'
!


!WeakSubscription class methodsFor:'instance creation'!

newWithAction: aBlock announcer: anAnnouncer announcementClass: anAnnouncementClass subscriber: anObject

	| subscription |
	subscription := aBlock == anObject
		ifTrue: [
			WeakBlockSubscription
				newForAnnouncer: anAnnouncer
				announcementClass: anAnnouncementClass
				subscriber: anObject ]
		ifFalse: [
			super
				newWithAction: aBlock
				announcer: anAnnouncer
				announcementClass: anAnnouncementClass
				subscriber: anObject  ].
	anObject
		toFinalizeSend: #removeSubscription:
		to: anAnnouncer subscriptionRegistry
		with: subscription.
	^subscription
!

newWithSelector: aSelector announcer: anAnnouncer announcementClass: anAnnouncementClass subscriber: anObject

	| subscription block |
	block := self blockFor: (WeakArray with: anObject) withSelector: aSelector.
	subscription := self new
		action: block;
		announcer: anAnnouncer;
		announcementClass: anAnnouncementClass;
		subscriber: anObject;
		selector: aSelector;
		yourself.
	anObject
		toFinalizeSend: #removeSubscription:
		to: anAnnouncer subscriptionRegistry
		with: subscription.
	^subscription
! !

!WeakSubscription class methodsFor:'private'!

blockFor: anObject withSelector: aSelector 
        | args |
        args := aSelector numArgs.
        args = 0 ifTrue: [
                ^[ |o| (o := anObject at: 1) notNil ifTrue: [ o perform: aSelector ] ifFalse:[nil] ]].
        args = 1 ifTrue: [
                ^[ :anAnnouncement | |o|
                        (o := anObject at: 1) notNil ifTrue: [
                                o perform: aSelector with: anAnnouncement ] ifFalse:[nil] ]].
        args = 2 ifTrue: [
                ^[ :anAnnouncement :anAnnouncer | |o| 
                        (o := anObject at: 1) notNil ifTrue: [
                                o 
                                        perform: aSelector
                                        with: anAnnouncement
                                        with: anAnnouncer ] ifFalse:[nil] ]].
        self error: 'Couldn''t create block'
! !

!WeakSubscription methodsFor:'accessing'!

subscriber

	^subscriber at: 1
!

subscriber: anObject

	subscriber := WeakArray with: anObject
! !

!WeakSubscription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/WeakSubscription.st,v 1.2 2013-04-15 14:24:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/WeakSubscription.st,v 1.2 2013-04-15 14:24:48 cg Exp $'
! !

