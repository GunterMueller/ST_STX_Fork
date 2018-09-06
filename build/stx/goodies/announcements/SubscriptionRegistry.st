"{ Package: 'stx:goodies/announcements' }"

Object subclass:#SubscriptionRegistry
	instanceVariableNames:'subscriptionsByAnnouncementClasses subscriptionClass'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements'
!


!SubscriptionRegistry class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!SubscriptionRegistry methodsFor:'accessing'!

allSubscriptions

	| result |
	result := SubscriptionCollection new.
	subscriptionsByAnnouncementClasses valuesDo: [ :each |
		result addAll: each ].
	^result
!

allSubscriptionsDo: aBlock

	subscriptionsByAnnouncementClasses valuesDo: [ :each |
		each do: aBlock ]
!

subscriptionClass
	"This is the default subscription class. All new subscriptions are created with this class."
	
	^subscriptionClass
!

subscriptionClass: aClass
	"Set the default subscription class. All new subscriptions are created with this class.
	 aClass should be AXStrongSubscription or AXWeakSubscription."
	
	subscriptionClass := aClass
!

subscriptionsFor: anAnnouncementClassOrCollection

	| result |
	result := SubscriptionCollection new.
	anAnnouncementClassOrCollection do: [:each |
		subscriptionsByAnnouncementClasses 
			at: each 
			ifPresent: [ :subscriptionCollection |
				result addAll: subscriptionCollection ] ].
	^result
!

subscriptionsOf: anObject

	| result |
	result := SubscriptionCollection new.
	self allSubscriptionsDo: [ :each | 
		each subscriber == anObject ifTrue: [ 
			result add: each ] ].
	^result
!

subscriptionsOf: anObject for: anAnnouncementClassOrCollection

	^(self subscriptionsFor: anAnnouncementClassOrCollection) 
		select: [:each | 
			each subscriber == anObject ]
! !

!SubscriptionRegistry methodsFor:'initialization'!

initialize

	subscriptionsByAnnouncementClasses := IdentityDictionary new.
	subscriptionClass := StrongSubscription	
! !

!SubscriptionRegistry methodsFor:'private'!

subscriptionsFor: anAnnouncementClass announce: anAnnouncement

	subscriptionsByAnnouncementClasses
		at: anAnnouncementClass
		ifPresent: [ :subscriptionCollection |
			subscriptionCollection value: anAnnouncement ]
! !

!SubscriptionRegistry methodsFor:'subscribing'!

register: aSubscription

	(subscriptionsByAnnouncementClasses 
		at: aSubscription announcementClass
		ifAbsentPut: [ SubscriptionCollection new ]) 
		add: aSubscription.
!

removeSubscription: aSubscription
        "Removes a subscription from the registry."
        
        | subscriptionCollection |
        subscriptionCollection := subscriptionsByAnnouncementClasses at: aSubscription announcementClass.
        subscriptionCollection remove: aSubscription ifAbsent: nil.
        subscriptionCollection isEmpty ifTrue: [
                subscriptionsByAnnouncementClasses 
                        removeKey: aSubscription announcementClass
                        ifAbsent: nil ]

    "Modified: / 11-06-2014 / 18:27:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeSubscriptions: aCollection

	aCollection do: [:each | self removeSubscription: each ]
! !

!SubscriptionRegistry methodsFor:'testing'!

isEmpty

	^subscriptionsByAnnouncementClasses isEmpty.
! !

!SubscriptionRegistry class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/SubscriptionRegistry.st,v 1.3 2014-06-11 17:29:06 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/SubscriptionRegistry.st,v 1.3 2014-06-11 17:29:06 vrany Exp $'
! !

