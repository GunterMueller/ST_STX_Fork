"{ Package: 'stx:goodies/communication/bitTorrent' }"

LibraryDefinition subclass:#stx_goodies_communication_bitTorrent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_communication_bitTorrent class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'stx:goodies/communication'    "HTTPInterface - referenced by BitTorrentTorrentFileContents class>>fromURL: "
    )

    "Modified: / 08-01-2011 / 13:24:41 / cg"
!

preRequisites
    "list all required packages.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies and looking for
     global variable accesses. (the browser has a menu function for that)
     Howevery, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPrerequisites method."

    ^ #(
        #'stx:goodies/communication'    "HTTPInterface - referenced by BitTorrentTorrentFileContents class>>fromURL: "
        #'stx:libbasic'    "Dictionary - superclass of BitTorrentTorrentFileRecord "
    )
! !

!stx_goodies_communication_bitTorrent class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        BitTorrentBDecoder
        BitTorrentBEncoder
        BitTorrentTorrentFileContents
        BitTorrentTorrentFileRecord
        BitTorrentTorrentInfoRecord
        #'stx_goodies_communication_bitTorrent'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_goodies_communication_bitTorrent class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

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

    ^ 'Copyright Claus Gittinger 1988-2011\nCopyright eXept Software AG 1998-2011'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_communication_bitTorrent class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/bitTorrent/stx_goodies_communication_bitTorrent.st,v 1.2 2011-01-08 12:25:01 cg Exp $'
! !
