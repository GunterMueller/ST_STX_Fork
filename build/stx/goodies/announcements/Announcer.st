"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/announcements' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Announcer
	instanceVariableNames:'registry announcementBaseClass'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements'
!


!Announcer class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!Announcer methodsFor:'accessing'!

announcementBaseClass
	"This is the base class of the classhierarchy which can be used as announcements in this announcer."

	^announcementBaseClass 
!

announcementBaseClass: aClass
	"Set the base class of the classhierarchy which can be used as announcements in this announcer. Changing it while having registered subscriptions is very dangerous."

	(aClass ~= announcementBaseClass
		and: [ registry isEmpty not ])
			ifTrue: [
				Warning signal: 'Changing the base class of the announcement hierarchy may hang the image!!'].
	announcementBaseClass := aClass
!

subscriptionRegistry

	^registry
! !

!Announcer methodsFor:'announcements'!

announce: anObject
    "Deliver anObject to the registered subscribers. 
     anObject should respond to #asAnnouncement and return with an instance of announcementBaseClass. 
     The return value is the announcement which can be modified by the subscribers."

    | announcement actualClass |
    
    announcement := anObject asAnnouncement.
    actualClass := announcement class.
    registry subscriptionsFor: actualClass announce: announcement.
    [ actualClass notNil and:[actualClass ~~ announcementBaseClass] ] whileTrue: [
        actualClass := actualClass superclass.
        registry subscriptionsFor: actualClass announce: announcement. 
    ].
    ^announcement

    "Modified: / 15-08-2018 / 22:08:40 / Claus Gittinger"
!

mayAnnounce: anAnnouncementClass
	"Decide if this announcer may announce an instance of anAnnanAnnouncementClass."

	^anAnnouncementClass == announcementBaseClass or: 
		[ anAnnouncementClass inheritsFrom: announcementBaseClass ]
! !

!Announcer methodsFor:'initialization'!

initialize

	registry := SubscriptionRegistry new.
	announcementBaseClass := Announcement
! !

!Announcer methodsFor:'subscriptions'!

on: anAnnouncementClassOrCollection do: aBlock
	"For compatibiliy with Announcements package."
	
	^self 
		when: anAnnouncementClassOrCollection
		do: aBlock
!

on: anAnnouncementClassOrCollection send: aSelector to: anObject
	"For compatibiliy with Announcements package."
	
	^self
		when: anAnnouncementClassOrCollection 
		send: aSelector
		to: anObject
!

unsubscribe: anObject

        | subscriptions |
        subscriptions := registry subscriptionsOf: anObject.
"/        subscriptions isEmpty ifTrue: [
"/                self error: 'No subscriptions for ', anObject asString 
"/        ].
        registry removeSubscriptions: subscriptions.

    "Modified (comment): / 10-06-2014 / 22:16:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unsubscribe: anObject from: anAnnouncementClassOrCollection

        | subscriptions |
        subscriptions := registry
                subscriptionsOf: anObject
                for: anAnnouncementClassOrCollection.
        subscriptions isEmpty ifTrue: [
                self error: anObject asString, ' has no subscriptions on ', anAnnouncementClassOrCollection asString].
        registry removeSubscriptions: subscriptions.

    "Modified: / 11-06-2014 / 18:28:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

when: anAnnouncementClassOrCollection do: aBlock 

	^self 
		when: anAnnouncementClassOrCollection
		do: aBlock
		for: aBlock.
!

when: anAnnouncementClassOrCollection do: aBlock for: anObject

        | subscribe subscriptions |

        subscribe := 
            [ :each |  
                | subscription |
                (self mayAnnounce: each) 
                        ifFalse: [
                                self error: self asString, ' may not announce ', each asString ].
                subscription := registry subscriptionClass
                        newWithAction: aBlock
                        announcer: self
                        announcementClass: each
                        subscriber: anObject.
                subscriptions add: subscription.
                registry register: subscription 
            ].

        subscriptions := SubscriptionCollection new.

        anAnnouncementClassOrCollection isBridgeProxy ifTrue:[
            subscribe value:anAnnouncementClassOrCollection
        ] ifFalse:[    
            anAnnouncementClassOrCollection do: subscribe.
        ].
        ^subscriptions

    "Modified: / 03-06-2014 / 11:46:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 02:35:56 / Claus Gittinger"
!

when: anAnnouncementClassOrCollection send: aSelector to: anObject
        | subscriptions subscribe |

        (anAnnouncementClassOrCollection isBridgeProxy not
        and:[ anAnnouncementClassOrCollection isSymbol ]) ifTrue: [
                ^super when: anAnnouncementClassOrCollection send: aSelector to: anObject 
        ].

        subscribe :=
            [:each |
                | subscription |
                (self mayAnnounce: each) ifFalse: [ 
                    self error: self asString, ' may not announce ', each asString 
                ].
                subscription := registry subscriptionClass
                        newWithSelector: aSelector
                        announcer: self
                        announcementClass: each
                        subscriber: anObject.
                subscriptions add: subscription.
                registry register: subscription.
            ].
            
        subscriptions := SubscriptionCollection new.
        anAnnouncementClassOrCollection isBridgeProxy ifTrue:[
            subscribe value:anAnnouncementClassOrCollection
        ] ifFalse:[    
            anAnnouncementClassOrCollection do: subscribe.
        ].
        ^subscriptions

    "Modified: / 03-06-2014 / 11:46:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-08-2018 / 21:36:12 / Claus Gittinger"
! !

!Announcer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/Announcer.st,v 1.9 2018-08-16 01:34:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/Announcer.st,v 1.9 2018-08-16 01:34:54 cg Exp $'
! !

