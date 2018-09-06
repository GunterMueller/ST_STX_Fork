"{ Package: 'stx:goodies/announcements/tests' }"

TestCase subclass:#AnnouncementTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements-Tests'
!


!AnnouncementTest methodsFor:'tests'!

testAsAnnouncement
	| a |
	a := Announcement new.
	self assert: a = a asAnnouncement.
	self assert: Announcement asAnnouncement class = Announcement 
!

testDo
	| count |
	count := 0.
	Announcement do: [ :aClass | 
		self assert: aClass == Announcement.
		count := count + 1 ].
	self assert: count = 1

	
!

testIncludes
	self assert: (Announcement includes: Announcement).
	self assert: (Announcement includes: Object) not.
	self assert: (Announcement includes: TestAnnouncement1) not.		

	
	

	
! !

!AnnouncementTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/AnnouncementTest.st,v 1.1 2013-04-15 14:17:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/AnnouncementTest.st,v 1.1 2013-04-15 14:17:50 cg Exp $'
! !

