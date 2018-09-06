"{ Package: 'stx:libdb/nosql/goods/squeak' }"

LibraryDefinition subclass:#stx_libdb_nosql_goods_squeak
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libdb_nosql_goods_squeak class methodsFor:'description'!

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
	#'stx:libdb/nosql/goods'    "KKVariableClassDescriptor - extended "
	#'stx:libdb/nosql/goods/tests'    "KKClassMapper - superclass of KKSqueakClassMapper "
	#'stx:libbasic'    "Magnitude - extended "
	#'stx:libview'    "Color - extended "
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
	#'stx:libbasic2'    "Socket - referenced by KKSqueakTCPSocketTransport>>initializeHost:port: "
	#'stx:libcompat'    "VW5PackageExporter - referenced by KKPackageExporter class>>exportVisualWorks "
    )
! !

!stx_libdb_nosql_goods_squeak class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
	"<className> or (<className> attributes...) in load order"
	#'stx_libdb_nosql_goods_squeak'
	KKPackageExporter
	KKSqueakClassMapper
	KKSqueakPlatform
	KKSqueakTCPSocketTransport
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
	Object #'='
	'Exception class' raiseSignal
	'Exception class' raiseSignal:
	Character goodsWriteTaggedOn:
	KKIdentitySet scanFor:
	KKMetaclassDescriptor objectFromStream:forDatabase:
	KKMetaclassDescriptor writeObject:onStream:forDatabase:
	Metaclass goodsDescriptor
	Timestamp goodsIsImmutable
	'Color class' goodsTransientFields
	'Object class' goodsVariableFieldDescriptor
    )
! !

!stx_libdb_nosql_goods_squeak class methodsFor:'description - project information'!

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

    ^ 'Copyright Claus Gittinger 1988-2013\nCopyright eXept Software AG 1998-2013'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libdb_nosql_goods_squeak class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/squeak/stx_libdb_nosql_goods_squeak.st,v 1.9 2013-03-28 11:32:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/squeak/stx_libdb_nosql_goods_squeak.st,v 1.9 2013-03-28 11:32:05 cg Exp $'
! !

