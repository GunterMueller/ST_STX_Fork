"
 COPYRIGHT (c) 2006 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libdb' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libdb
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libdb class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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

    This library contains database framework classes (DB-independent).

    This framework is required by concrete dataBase frameworks,
    especially by the ODBC and Oracle libraries.

    [author:]
        cg

    [primary maintainer:]
        cg, sv
"
! !

!stx_libdb class methodsFor:'description'!

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
    )
!

subProjects
    "list all other projects to be built"

    ^ #(
	#'stx:libdb/libodbc'
	#'stx:libdb/libsqlite'
	#'stx:libdb/nosql'
    )
! !

!stx_libdb class methodsFor:'description - compilation'!

additionalDefinitions_nt_dot_mak
    ^ '
# see stdHeader_nt for LIBDB_BASE
LIB_BASE_LD_ARG=-b:$(LIBDB_BASE)
'

    "Created: / 30-08-2006 / 15:13:49 / cg"
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libdb class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
	"<className> or (<className> attributes...) in load order"
	#'SQL::Connection'
	#'SQL::Cursor'
	#'SQL::Database'
	#'SQL::DatabaseColumnDescription'
	#'SQL::DatabaseHandle'
	#'SQL::DatabaseKeyDescription'
	#'SQL::DatabaseReturnValue'
	#'SQL::DatabaseRowObject'
	#'SQL::DatabaseTableDescription'
	#'SQL::SQLError'
	#'SQL::SQLNotification'
	#'SQL::Statement'
	#'SQL::Transaction'
	#'stx_libdb'
	#'SQL::DatabaseSession'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_libdb class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:23 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Database Framework'

    "Modified: / 30-08-2006 / 15:00:30 / cg"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1999\nCopyright eXept Software AG 2011'

    "Modified: / 18-11-2016 / 12:18:20 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libdb class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/stx_libdb.st,v 1.31 2017-11-25 12:35:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/stx_libdb.st,v 1.31 2017-11-25 12:35:25 cg Exp $'
! !

