"{ Package: 'stx:libdb/nosql/couchDB' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libdb_nosql_couchDB
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libdb_nosql_couchDB class methodsFor:'description'!

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
        #'stx:libbasic'    "ProjectDefinition - superclass of stx_libdb_nosql_couchDB "
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
        #'stx:goodies/json'    "Json - referenced by CouchViewServer>>command: "
        #'stx:libbasic2'    "Socket - referenced by CouchViewServerListener>>listenLoop "
        #'stx:libcompat'    "RWBinaryOrTextStream - referenced by CouchDB>>fromJSON: "
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

!stx_libdb_nosql_couchDB class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        CouchDB
        CouchDBError
        CouchViewServer
        CouchViewServerError
        CouchViewServerFunction
        CouchViewServerListener
        #'stx_libdb_nosql_couchDB'
        CouchDBInvalidDatabaseNameError
        CouchDBInvalidDocumentError
        CouchDBOperationFailedError
        CouchViewServerCompilationError
        CouchViewServerFunctionError
        CouchViewServerReduceError
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
        Dictionary removeKeyIfValueNilOrEmptyString:
        Object asJsonString
    )
! !

!stx_libdb_nosql_couchDB class methodsFor:'description - project information'!

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

!stx_libdb_nosql_couchDB class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/stx_libdb_nosql_couchDB.st,v 1.3 2017-07-31 06:50:07 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/stx_libdb_nosql_couchDB.st,v 1.3 2017-07-31 06:50:07 mawalch Exp $'
! !

