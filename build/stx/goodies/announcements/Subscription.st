"{ Package: 'stx:goodies/announcements' }"

Object subclass:#Subscription
	instanceVariableNames:'announcer announcementClass subscriber interceptors selector'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements'
!


!Subscription methodsFor:'accessing'!

action

	self subclassResponsibility 
!

action: aValuable

	self subclassResponsibility 
!

announcementClass

	^announcementClass
!

announcementClass: aClass

	announcementClass := aClass.
!

announcer

	^announcer
!

announcer: anAnnouncer

	announcer := anAnnouncer 
!

selector

	^selector
!

selector: aSelector

	selector := aSelector
!

subscriber

	self subclassResponsibility
!

subscriber: anObject

	self subclassResponsibility
! !

!Subscription methodsFor:'delivery'!

deliver: anAnnouncement from: anAnnouncer

	self subclassResponsibility
!

value: anAnnouncement 

	self subclassResponsibility
! !

!Subscription methodsFor:'interceptors'!

addInterceptor: aBlock 

	aBlock numArgs > 3 
		ifTrue: [ self error: 'The interceptor block should have 0, 1, 2 or 3 arguments!!' ].
	interceptors ifNil: [ interceptors := OrderedCollection new ].
	interceptors add: aBlock
!

removeInterceptor

        interceptors removeLast.
        interceptors isEmpty ifTrue: [ interceptors := nil ]

    "Modified: / 11-06-2014 / 18:27:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Subscription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/Subscription.st,v 1.2 2014-06-11 17:29:12 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/Subscription.st,v 1.2 2014-06-11 17:29:12 vrany Exp $'
! !

