"{ Package: 'stx:goodies/announcements' }"

Subscription subclass:#WeakBlockSubscription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements'
!


!WeakBlockSubscription class methodsFor:'instance creation'!

newForAnnouncer: anAnnouncer announcementClass: anAnnouncementClass subscriber: anObject

	^self new
		announcer: anAnnouncer;
		announcementClass: anAnnouncementClass;
		subscriber: anObject;
		yourself
! !

!WeakBlockSubscription methodsFor:'accessing'!

action

	^subscriber at: 1
!

action: aValuable

	^self shouldNotImplement 
!

subscriber

	^subscriber at: 1
!

subscriber: anObject

	subscriber := WeakArray with: anObject.
! !

!WeakBlockSubscription methodsFor:'delivery'!

deliver: anAnnouncement from: anAnnouncer
        |action|

        (action := (subscriber at: 1)) notNil ifTrue: [
                ^ action cull: anAnnouncement cull: anAnnouncer 
        ].
        ^ nil
!

value: anAnnouncement

        interceptors isNil ifTrue: [
                |action|

                (action := subscriber at: 1) notNil ifTrue: [ 
                        ^ action cull: anAnnouncement cull: announcer 
                ].
                ^ nil
        ].
        interceptors do: [ :each |
                each cull: anAnnouncement cull: announcer cull: self ]

    "Modified: / 17-09-2014 / 23:57:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WeakBlockSubscription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/WeakBlockSubscription.st,v 1.4 2014-09-18 08:33:57 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/WeakBlockSubscription.st,v 1.4 2014-09-18 08:33:57 vrany Exp $'
! !

