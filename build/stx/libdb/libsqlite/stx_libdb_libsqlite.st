"
 COPYRIGHT (c) 2010 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libdb/libsqlite' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libdb_libsqlite
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libdb_libsqlite class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Package documentation:

    This library provides a native interface to SQLite file based data bases.

    This is a very lightweight database, 
    and used for example by Firefox to store settings and configuration data.

    It is also useful for applications as a very lightweight, easy to setup
    and maintain, and easy to use data base.

    No special installation or administration is required for its use.
    Also, it is a native interface, not requiring any additional setup 
    (i.e. it is not using any ODBC layer, but directly calls sqLite C-functions).

    Notice, that it is of course also possible, to access an sqlite database via the
    ODBC layer (given that the required ODBC-drivers are installed and configured).
    Although being slower than the native interface, this has the advantage of being easier to
    reconfigure later. For example, if the database has to be moved to another host 
    or even to another kind of database (oracle or mysql).

    [author:]
        cg

    [primary maintainer:]
        cg, sv
"
! !

!stx_libdb_libsqlite class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
	#'stx:goodies/sunit'    "TestCase - superclass of SQLiteTests "
    )

    "Modified: / 22-11-2011 / 14:43:26 / cg"
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
        #'stx:libbasic'    "ExternalStructure - superclass of SqliteResultBuffer "
        #'stx:libbasic2'    "ExternalLong - superclass of SqliteErrorHolder "
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
        #'stx:libdb'    "SQL::Cursor - referenced by SQLiteCursor class>>checkAPI "
    )
! !

!stx_libdb_libsqlite class methodsFor:'description - compilation'!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libdb_libsqlite class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        SQLiteConnection
        (SQLiteTests autoload)
        SqliteError
        SqliteErrorHolder
        SqliteResultCodes
        SqliteLibrary
        SqliteReference
        SqliteResult
        SqliteResultBuffer
        #'stx_libdb_libsqlite'
        SQLiteCursor
        SQLiteStatement
        SQLiteColumnDescription
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_libdb_libsqlite class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:17 / cg"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X sqlite DB Interface'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 2010\nCopyright eXept Software AG 2010'

    "Modified: / 18-11-2016 / 12:18:24 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libdb_libsqlite class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/stx_libdb_libsqlite.st,v 1.21 2017-11-25 12:35:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/stx_libdb_libsqlite.st,v 1.21 2017-11-25 12:35:22 cg Exp $'
! !

