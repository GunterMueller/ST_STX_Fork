"{ Package: 'stx:libdb/nosql/sandstoneDb/tests' }"

LibraryDefinition subclass:#stx_libdb_nosql_sandstoneDb_tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libdb_nosql_sandstoneDb_tests class methodsFor:'description'!

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
	#'stx:libdb/nosql/sandstoneDb'    "SDActiveRecord - superclass of SDFooObject "
	#'stx:goodies/sunit'    "TestCase - superclass of SDFileStoreTests "
	#'stx:libbasic'    "Object - superclass of SDFileStoreTests "
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
	#'stx:libbasic2'    "UUID - referenced by SDFileStoreTests>>testStorageDir "
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

!stx_libdb_nosql_sandstoneDb_tests class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
	"<className> or (<className> attributes...) in load order"
	(SDActiveRecordTests autoload)
	SDFooObject
	SDPersonMock
	#'stx_libdb_nosql_sandstoneDb_tests'
	(SDFileStoreTests autoload)
	SDManMock
	(SDMemoryStoreTests autoload)
	SDWomanMock
	SDChildMock
	SDGrandChildMock
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_libdb_nosql_sandstoneDb_tests class methodsFor:'description - project information'!

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

!stx_libdb_nosql_sandstoneDb_tests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/tests/stx_libdb_nosql_sandstoneDb_tests.st,v 1.1 2013-04-17 23:46:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/tests/stx_libdb_nosql_sandstoneDb_tests.st,v 1.1 2013-04-17 23:46:33 cg Exp $'
! !

