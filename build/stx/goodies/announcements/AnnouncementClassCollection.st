"{ Package: 'stx:goodies/announcements' }"

"{ NameSpace: Smalltalk }"

OrderedCollection subclass:#AnnouncementClassCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements'
!


!AnnouncementClassCollection class methodsFor:'misc ui support'!

iconInBrowserSymbol
    <resource: #programImage>

    ^ #announcementClassIcon
! !

!AnnouncementClassCollection methodsFor:'adding'!

, anAnnouncementClass

	^self 
		add: anAnnouncementClass; 
		yourself
!

handles:anAnnouncement
    ^ self anySatisfy:[:a | a handles:anAnnouncement]
! !

!AnnouncementClassCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/AnnouncementClassCollection.st,v 1.4 2015-03-26 10:20:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/AnnouncementClassCollection.st,v 1.4 2015-03-26 10:20:23 cg Exp $'
! !

