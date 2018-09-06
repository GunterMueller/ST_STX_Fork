"{ Package: 'stx:goodies/announcements' }"!

!Object methodsFor:'announcements'!

announce: anAnnouncementOrClass 
    "Broadcast an announcement. The argument can be an Announcement instance
    or a (sub)class. When the argument is a class, a new instance is created
    automatically for broadcast. Answer the announcement."

    | announcement registry |

    announcement := anAnnouncementOrClass asAnnouncement.
    (self mayAnnounce: announcement class) ifFalse: [
        self errorBadAnnouncementClass: announcement class
    ].
    (registry := self subscriptionRegistryOrNil) notNil ifTrue:[
        registry deliver: announcement from: self
    ].
    ^announcement
! !

!Object methodsFor:'announcements'!

mayAnnounce: anAnnouncementClass
    "Subclasses can reimplement this method to restrict the announcements
     the instances are allowed to broadcast. 
     The method Announcement class>>descendsFromAny: is a useful utility for checking
     whether a class is equal to or a subclass of one of the classes in a collection."

    ^true
! !

!Object methodsFor:'announcements'!

subscriptionRegistryOrNil
    "This object does not implement subscription storage.
    Subclasses that do must reimplement it to answer the
    registry or nil if the registry does not exist at the moment."

    ^nil
! !

!stx_goodies_announcements class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/extensions.st,v 1.2 2015-03-25 14:30:54 cg Exp $'
! !
