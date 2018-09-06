"{ Package: 'stx:goodies/announcements/tests' }"

Object subclass:#TestSubscriber
	instanceVariableNames:'announcements announcers runs'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements-Tests'
!


!TestSubscriber class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!TestSubscriber methodsFor:'accessing'!

announcements
	^announcements 
!

announcers
	^announcers
!

runs
	^runs
! !

!TestSubscriber methodsFor:'as yet unclassified'!

storeAnnouncement: anAnnouncement
	runs := runs + 1.
	announcements add: anAnnouncement.
	announcers add: nil
!

storeAnnouncement: anAnnouncement andAnnouncer: anAnnouncer
	runs := runs + 1.
	announcements add: anAnnouncement.
	announcers add: anAnnouncer.
! !

!TestSubscriber methodsFor:'initialization'!

initialize
	runs := 0.
	announcements  := OrderedCollection new.
	announcers := OrderedCollection new.
! !

!TestSubscriber methodsFor:'running'!

run
	runs := runs + 1.
	announcements add: nil.
	announcers add: nil
! !

!TestSubscriber class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/TestSubscriber.st,v 1.2 2013-04-15 14:45:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/TestSubscriber.st,v 1.2 2013-04-15 14:45:09 cg Exp $'
! !

