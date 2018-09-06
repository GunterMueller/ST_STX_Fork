"{ Package: 'stx:goodies/announcements' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_announcements
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_announcements class methodsFor:'documentation'!

documentation
"
    Package documentation:

    Enhanced change and event framework. 
"
! !

!stx_goodies_announcements class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:libbasic'    "SequenceableCollection - superclass of SubscriptionCollection "
    )
!

referencedPreRequisites
    "list all packages containing classes referenced by the packages's members.
     This list can be maintained manually or (better) generated and
     updated by looking for global variable accesses
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
    )
! !

!stx_goodies_announcements class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        Announcement
        AnnouncementClassCollection
        Announcer
        Subscription
        SubscriptionCollection
        SubscriptionRegistry
        #'stx_goodies_announcements'
        StrongSubscription
        WeakBlockSubscription
        WeakSubscription
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are pairwise elements, consisting of class-name and selector."

    ^ #(
        Object announce:
        Object mayAnnounce:
        Object subscriptionRegistryOrNil
    )
! !

!stx_goodies_announcements class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2013\nCopyright eXept Software AG 2013'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_announcements class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/stx_goodies_announcements.st,v 1.5 2016-12-28 09:22:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/stx_goodies_announcements.st,v 1.5 2016-12-28 09:22:27 cg Exp $'
! !

