"{ Package: 'stx:goodies/libdbase' }"

LibraryDefinition subclass:#stx_goodies_libdbase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_libdbase class methodsFor:'description - compilation'!

additionalDefinitions_make_dot_proto
    ^ '
# original db
DB_VERSION=db-1.6
#DB_VERSION=db-1.85.4
DBASE_VERSION_ID=DB1_x

# a somewhat fixed version of db
#DB_VERSION=db-vs
#DBASE_VERSION_ID=DB1_x
#MAKEFILE_DB=Makefile

# does not work (yet)
#DB_VERSION=db-3.3.11
#DBASE_VERSION_ID=DB3_x

DB_TOP=$(TOP)/support/db/$(DB_VERSION)
'

    "Created: / 22-08-2006 / 23:50:57 / cg"
!

additionalLinkLibraries_make_dot_proto
    ^ '$(DB_TOP)/PORT/libdb.a'
!

additionalRules_make_dot_proto
    ^ '
libdb:
        -(cd $(DB_TOP)/PORT; $(MAKE) -f $(MAKEFILE_DB) CC="$(CC)" OPT="$(OPT)" CCCONFOPT="$(CCCONFOPT)" )
'
!

additionalTargets_make_dot_proto
    ^ 'libdb'

    "Created: / 05-09-2006 / 16:05:12 / cg"
!

localIncludes
    ^ '-DDBASE -D$(DBASE_VERSION_ID) -I$(DB_TOP)/PORT/include -I$(DB_TOP)/include -I$(DB_TOP)/PORT'
! !

!stx_goodies_libdbase class methodsFor:'description - contents'!

classNamesAndAttributes
    ^ #(
	"/ <className> or (<className> attributes...)
	'DBFile'
	'PersistencyManager'
	('PersistencyManagerTest' #autoload)
	'stx_goodies_libdbase'
    )
!

extensionMethodNames
    ^ #(
    )
! !

!stx_goodies_libdbase class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2006\nCopyright eXept Software AG 1998-2006'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_libdbase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/libdbase/stx_goodies_libdbase.st,v 1.5 2013-04-22 14:29:37 vrany Exp $'
! !

