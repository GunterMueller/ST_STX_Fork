"{ Package: 'stx:libdb/nosql/goods/tests' }"

LibraryDefinition subclass:#stx_libdb_nosql_goods_tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libdb_nosql_goods_tests class methodsFor:'description'!

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
	#'stx:libdb/nosql/sunit'    "TestAsserter - superclass of KKShapeChangeTest "
	#'stx:libbasic'    "Object - superclass of KKShapeChangeTest "
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
	#'stx:libdb/nosql/goods'    "KKManualWriteBarrier - referenced by KKDBTest>>preparePessimisticLocking "
    )
! !

!stx_libdb_nosql_goods_tests class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
	"<className> or (<className> attributes...) in load order"
	(KKAbstractDBTest autoload)
	(KKClassForShapeChangeTest autoload)
	(KKHolderForWBTest autoload)
	(KKManualWriteBarrierTest autoload)
	(KKObjectForWBTest autoload)
	#'stx_libdb_nosql_goods_tests'
	(KKDBTest autoload)
	(KKShapeChangeTest autoload)
	(KKSlowDBTest autoload)
	(KKThreadSafeDBTest autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_libdb_nosql_goods_tests class methodsFor:'description - project information'!

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

!stx_libdb_nosql_goods_tests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/stx_libdb_nosql_goods_tests.st,v 1.5 2013-03-28 11:32:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/stx_libdb_nosql_goods_tests.st,v 1.5 2013-03-28 11:32:05 cg Exp $'
! !

