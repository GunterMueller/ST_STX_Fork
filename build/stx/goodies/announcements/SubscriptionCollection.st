"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/announcements' }"

"{ NameSpace: Smalltalk }"

OrderedCollection subclass:#SubscriptionCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements'
!


!SubscriptionCollection methodsFor:'intercept-suspend'!

interceptWith: aBlock while: anotherBlock
	"Evaluate aBlock instead of the action for each of these subscriptions while anotherBlock is being evaluated."
	
	self do: [ :each | each addInterceptor: aBlock	].
	anotherBlock value.
	self do: [ :each | each removeInterceptor	]
!

suspendWhile: aBlock
	"Suspend all the subscriptions in this collection while aBlock is being evaluated."
	
	self interceptWith: [] while: aBlock
!

suspendWhile: aBlock ifAnyMissed: anotherBlock
	"Suspend all the subscriptions in this collection while aBlock is being evaluated. If any would have been active, evaluate anotherBlock."

	| anyMissed |
	anyMissed := false.
	self 
		interceptWith: [ anyMissed := true ]
		while: aBlock.
	anyMissed ifTrue: [	anotherBlock value 	]

	
! !

!SubscriptionCollection methodsFor:'private'!

make: aSubscriptionClass
	"Create and register a new subscription of aSubscriptionClass for all the subscriptions in this collection while removing the old subscriptions from the registry."
	
	^self collect: [ :each | 
		| registry subscription |
		registry := each announcer subscriptionRegistry.
		registry removeSubscription: each.
 		subscription := each selector
			ifNil: [ aSubscriptionClass 
				newWithAction: each action
				announcer: each announcer
				announcementClass: each announcementClass
				subscriber: each subscriber ]
			ifNotNil: [ aSubscriptionClass
				newWithSelector: each selector
				announcer: each announcer
				announcementClass: each announcementClass
				subscriber: each subscriber ].
		registry register: subscription.
		subscription ]
!

value: anAnnouncement

        self do: [ :each | each value: anAnnouncement]
! !

!SubscriptionCollection methodsFor:'weak-strong'!

makeStrong
	"Create and register a new strong subscription for all the subscriptions in this collection, while removing the old subscriptions from the registry."
	
	^self make: StrongSubscription
!

makeWeak
	"Create and register a new weak subscription for all the subscriptions in this collection, while removing the old subscriptions from the registry."
	
	^self make: WeakSubscription
! !

!SubscriptionCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/SubscriptionCollection.st,v 1.2 2015-03-25 14:29:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/SubscriptionCollection.st,v 1.2 2015-03-25 14:29:04 cg Exp $'
! !

