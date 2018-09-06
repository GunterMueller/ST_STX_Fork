"{ Package: 'stx:goodies/announcements' }"

Subscription subclass:#StrongSubscription
	instanceVariableNames:'action'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements'
!


!StrongSubscription class methodsFor:'instance creation'!

newWithAction: aBlock announcer: anAnnouncer announcementClass: anAnnouncementClass subscriber: anObject 

	^self new 
		action: aBlock;
		announcer: anAnnouncer;
		announcementClass: anAnnouncementClass;
		subscriber: anObject;
		yourself
!

newWithSelector: aSelector announcer: anAnnouncer announcementClass: anAnnouncementClass subscriber: anObject

	| block |
	block := self blockFor: anObject withSelector: aSelector.
	^self new
		action: block;
		announcer: anAnnouncer;
		announcementClass: anAnnouncementClass;
		subscriber: anObject;
		selector: aSelector;
		yourself
! !

!StrongSubscription class methodsFor:'private'!

blockFor: anObject withSelector: aSelector

	| args |
	args := aSelector numArgs.
	args = 0 ifTrue: [ ^[ anObject perform: aSelector ] ].
	args = 1 ifTrue: [ ^[ :anAnnouncement | anObject perform: aSelector with: anAnnouncement ] ].
	args = 2 ifTrue: [ ^[ :anAnnouncement :anAnnouncer | anObject perform: aSelector with: anAnnouncement with: anAnnouncer ] ].
	self error: 'Couldn''t create block'.
! !

!StrongSubscription methodsFor:'accessing'!

action

	^action
!

action: aValuable

	action := aValuable.

!

subscriber

	^subscriber
!

subscriber: anObject

	subscriber := anObject
! !

!StrongSubscription methodsFor:'delivery'!

deliver: anAnnouncement from: anAnnouncer

	^action cull: anAnnouncement cull: anAnnouncer
!

value: anAnnouncement

        interceptors isNil ifTrue: [ ^action cull: anAnnouncement cull: announcer ].
        interceptors do: [ :each |
                each cull: anAnnouncement cull: announcer cull: self ]

    "Modified: / 17-09-2014 / 23:57:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StrongSubscription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/StrongSubscription.st,v 1.2 2014-09-18 08:35:09 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/StrongSubscription.st,v 1.2 2014-09-18 08:35:09 vrany Exp $'
! !

