"{ Package: 'stx:goodies/announcements' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Announcement
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements'
!


!Announcement class methodsFor:'adding'!

, anAnnouncementClass

	^AnnouncementClassCollection 
		with: self 
		with: anAnnouncementClass
! !

!Announcement class methodsFor:'converting'!

asAnnouncement

	^self new
! !

!Announcement class methodsFor:'enumerating'!

do: aBlock
	"Act as a collection."
	
	aBlock value: self
! !

!Announcement class methodsFor:'misc ui support'!

iconInBrowserSymbol
    <resource: #programImage>

    ^ #announcementClassIcon
! !

!Announcement class methodsFor:'testing'!

includes: aClass
	"Act as a collection."
	
	^self = aClass
! !

!Announcement methodsFor:'converting'!

asAnnouncement

	^self
! !

!Announcement class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/Announcement.st,v 1.4 2015-03-26 10:20:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/Announcement.st,v 1.4 2015-03-26 10:20:15 cg Exp $'
! !

