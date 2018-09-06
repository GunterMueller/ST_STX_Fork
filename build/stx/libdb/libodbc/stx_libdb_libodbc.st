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
"{ Package: 'stx:libdb/libodbc' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libdb_libodbc
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libdb_libodbc class methodsFor:'documentation'!

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

    This library contains ODBC-Database interface classes.
    These allow for almost any dataBase (for which an ODBC driver exists)
    to be accessed.

    [author:]
        cg

    [primary maintainer:]
        cg, sv
"
! !

!stx_libdb_libodbc class methodsFor:'description'!

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
        #'stx:libbasic'    "ShortFloat - extended "
        #'stx:libbasic2'    "UUID - extended "
        #'stx:libdb'    "SQL::SQLError - superclass of SQL::ODBCConnectionError "
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
! !

!stx_libdb_libodbc class methodsFor:'description - compilation'!

additionalDefinitions_bc_dot_mak
    "allows for additional definitions/rules to be added to the make.proto file."

    ^ '
LIB_BASE_LD_ARG=-b:$(LIBODBC_BASE)
!!if defined(USEMINGW32) || defined(USEMINGW64)
ODBC_LD_ARG=-lodbc32
!!else
ODBC_LD_ARG=odbc32.lib
!!endif

'
!

additionalDefinitions_make_dot_proto
    "allows for additional definitions/rules to be added to the make.proto file."

    ^ '
#
# choose only one driver or driver manager:
# driver managers:
# must be set in architecture specific configuration, not here.
# WHICH_ODBC=   unixodbc
# WHICH_ODBC=   iodbc

# drivers (not really recommended):
# WHICH_ODBC=   myodbc3
# WHICH_ODBC=   myodbc
# WHICH_ODBC=   psqlodbc
# WHICH_ODBC=   libodbctxt
# WHICH_ODBC=   adabas
# WHICH_ODBC=   sybase
# WHICH_ODBC=   osxodbc

#
# defs for using ADABAS
#
ADABAS_HOME=/ADABAS-ENTRY
#ADABAS_HOME=/usr/local/adabas

ADABAS_INCLUDE_DIR=$(ADABAS_HOME)/incl
LIBADABAS_LIBS=-lsqlptc -lsqlrte
LIBADABAS_ODBC=$(ADABAS_HOME)/lib/odbclib.a
ADABAS_PRELINK_STATIC="-L$(ADABAS_HOME)/lib $(LIBADABAS_ODBC) $(LIBADABAS_LIBS)"
ADABAS_DYNAMIC_LIBS=

#
# defs for using SYBASE
#
SYBASE_HOME=/opt/SYBSsa50
SYBASE_INCLUDE_DIR=$(SYBASE_HOME)/include
SYBASE_ODBC=$(SYBASE_HOME)/lib/saodbc.so
SYBASE_LIB=-ldblib
SYBASE_DB_DEFINE=-DSYBASE
SYBASE_PRELINK_STATIC=
SYBASE_DYNAMIC_LIBS="-L$(SYBASE_HOME)/lib $(SYBASE_ODBC) $(SYBASE_LIB)"

#
# defs for using iODBC unix ODBC driver manager
#
IODBC_HOME=/usr/local
IODBC_INCLUDE_DIR=$(IODBC_HOME)/include
IODBC_DB_DEFINE=-DIODBC
IODBC_DYNAMIC_LIBS="-L$(IODBC_HOME)/lib -liodbc -liodbcinst"

#
# defs for using the unixODBC package
#
UNIXODBC_HOME=/usr/local
UNIXODBC_INCLUDE_DIR=$(UNIXODBC_HOME)/include
UNIXODBC_DB_DEFINE=-DUNIXODBC
UNIXODBC_PRELINK_STATIC=
UNIXODBC_DYNAMIC_LIBS="-L$(UNIXODBC_HOME)/lib -lodbc -lodbcinst -lpthread"
# UNIXODBC_EXTRA_TARGETS=libSTXpthread.so

#
# defs for using libodbctxt from unixODBC package
# (for debugging only)
#
LIBODBCTXT_HOME=/usr/local
LIBODBCTXT_INCLUDE_DIR=$(LIBODBCTXT_HOME)/include
LIBODBCTXT_DB_DEFINE=-DLIBODBCTXT
LIBODBCTXT_PRELINK_STATIC=
LIBODBCTXT_DYNAMIC_LIBS="-L$(LIBODBCTXT_HOME)/lib -lodbctxt"

#
# defs for using MYSQL myODBC driver
#
MYODBC_HOME=/usr/local
MYODBC_INCLUDE_DIR=$(MYODBC_HOME)/mysql
MYODBC_DB_DEFINE=-DMYODBC
MYODBC_PRELINK_STATIC=
MYODBC_DYNAMIC_LIBS="-L$(MYODBC_HOME)/lib -lmyodbc"

MYODBC3_PRELINK_STATIC=
MYODBC3_DYNAMIC_LIBS="-L$(MYODBC_HOME)/lib -lmyodbc3"

#
# defs for using PostgresSQL psqlODBC driver
#
PSQLODBC_HOME=/usr/local
PSQLODBC_INCLUDE_DIR=$(PSQLODBC_HOME)/include
PSQLODBC_ODBC=$(PSQLODBC_HOME)/lib/libpsqlodbc.so
PSQLODBC_DB_DEFINE=-DPSQLODBC
PSQLODBC_PRELINK_STATIC=
PSQLODBC_DYNAMIC_LIBS="-L$(PSQLODBC_HOME)/lib -lpsqlodbc"

# defs for using the mac osx ODBC package
#
OSXODBC_HOME=/usr/lib
OSXODBC_INCLUDE_DIR=$(OSXODBC_HOME)/include
OSXODBC_DB_DEFINE=-DOSXODBC
OSXODBC_PRELINK_STATIC=
OSXODBC_DYNAMIC_LIBS="-L$(OSXODBC_HOME) -lodbc -lpthread"
OSXODBC_EXTRA_TARGETS=

#
# future: add defs for other DB´s here ...
#

LOCALDEFS=$(DB_DEFINE) $(DB_INCLUDE) $(DB_LOCAL_INCLUDE_OPT)
LOCAL_SHARED_LIBS=$(DB_DYNAMIC_LIBS)
'

    "Created: / 30-08-2006 / 15:07:54 / cg"
!

additionalLinkLibraries_bc_dot_mak
    ^ '$(ODBC_LD_ARG)'
!

additionalRules_make_dot_proto
    "allows for additional definitions/rules to be added to the Make.proto file."

    ^ '
myodbc:
	@$(MAKE) classLibRule \
		DB_DEFINE=-DMYODBC \
		DB_INCLUDE=-I$(MYODBC_INCLUDE_DIR) \
		DB_LOCAL_INCLUDE_OPT= \
		DB_PRELINK_STATIC=$(MYODBC_PRELINK_STATIC) \
		DB_DYNAMIC_LIBS=$(MYODBC_DYNAMIC_LIBS)

myodbc3:
	@$(MAKE) classLibRule \
		DB_DEFINE=-DMYODBC \
		DB_INCLUDE=-I$(MYODBC_INCLUDE_DIR) \
		DB_LOCAL_INCLUDE_OPT= \
		DB_PRELINK_STATIC=$(MYODBC3_PRELINK_STATIC) \
		DB_DYNAMIC_LIBS=$(MYODBC3_DYNAMIC_LIBS)

psqlodbc:
	@$(MAKE) classLibRule \
		DB_DEFINE=-DPSQLODBC \
		DB_INCLUDE=-I$(PSQLODBC_INCLUDE_DIR) \
		DB_LOCAL_INCLUDE_OPT= \
		DB_PRELINK_STATIC=$(PSQLODBC_PRELINK_STATIC) \
		DB_DYNAMIC_LIBS=$(PSQLODBC_DYNAMIC_LIBS)

iodbc:
	@$(MAKE) classLibRule \
		DB_DEFINE=-DIODBC \
		DB_INCLUDE=-I$(IODBC_INCLUDE_DIR) \
		DB_LOCAL_INCLUDE_OPT= \
		DB_PRELINK_STATIC=$(IODBC_PRELINK_STATIC) \
		DB_DYNAMIC_LIBS=$(IODBC_DYNAMIC_LIBS)

unixodbc:   $(UNIXODBC_EXTRA_TARGETS)
	@$(MAKE) classLibRule \
		DB_DEFINE=-DUNIXODBC \
		DB_INCLUDE=-I$(UNIXODBC_INCLUDE_DIR) \
		DB_LOCAL_INCLUDE_OPT= \
		DB_PRELINK_STATIC=$(UNIXODBC_PRELINK_STATIC) \
		DB_DYNAMIC_LIBS=$(UNIXODBC_DYNAMIC_LIBS)

osxodbc:   $(OSXODBC_EXTRA_TARGETS)
	@$(MAKE) classLibRule \
		DB_DEFINE=-DOSXODBC \
		DB_INCLUDE=-I$(OSXODBC_INCLUDE_DIR) \
		DB_LOCAL_INCLUDE_OPT= \
		DB_PRELINK_STATIC=$(OSXODBC_PRELINK_STATIC) \
		DB_DYNAMIC_LIBS=$(OSXODBC_DYNAMIC_LIBS)

libodbctxt:
	@$(MAKE) classLibRule \
		DB_DEFINE=-DLIBODBCTXT \
		DB_INCLUDE=-I$(LIBODBCTXT_INCLUDE_DIR) \
		DB_LOCAL_INCLUDE_OPT= \
		DB_PRELINK_STATIC=$(LIBODBCTXT_PRELINK_STATIC) \
		DB_DYNAMIC_LIBS=$(LIBODBCTXT_DYNAMIC_LIBS)

adabas:
	@$(MAKE) classLibRule \
		DB_DEFINE=-DADABAS \
		DB_INCLUDE=-I$(ADABAS_INCLUDE_DIR) \
		DB_LOCAL_INCLUDE_OPT=-I./adabas \
		DB_PRELINK_STATIC=$(ADABAS_PRELINK_STATIC) \
		DB_DYNAMIC_LIBS=$(ADABAS_DYNAMIC_LIBS)

sybase:
	@$(MAKE) classLibRule \
		DB_DEFINE=-DSYBASE \
		DB_INCLUDE=-I$(SYBASE_INCLUDE_DIR) \
		DB_LOCAL_INCLUDE_OPT= \
		DB_PRELINK_STATIC=$(SYBASE_PRELINK_STATIC) \
		DB_DYNAMIC_LIBS=$(SYBASE_DYNAMIC_LIBS)
'

    "Created: / 30-08-2006 / 15:09:45 / cg"
!

primaryTarget_make_dot_proto
    "which target should we build in the Make.proto file"

    ^ '$(WHICH_ODBC)'
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libdb_libodbc class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'SQL::ODBCColumnDescription'
        #'SQL::ODBCCursor'
        #'SQL::ODBCEnvironment'
        #'SQL::ODBCError'
        #'SQL::ODBCHandle'
        #'SQL::ODBCKeyDescription'
        #'SQL::ODBCSession'
        #'SQL::ODBCStatement'
        #'SQL::ODBCTableDescription'
        #'stx_libdb_libodbc'
        #'SQL::ODBCConnectionError'
        #'SQL::ODBCSchemaColumnDescription'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are pairwise elements, consisting of class-name and selector."

    ^ #(
        'ByteArray class' odbcTypeSymbol
        'CharacterArray class' odbcTypeSymbol
        'Date class' odbcTypeSymbol
        'FixedPoint class' odbcTypeSymbol
        'Float class' odbcTypeSymbol
        'Integer class' odbcTypeSymbol
        'Number class' odbcTypeSymbol
        'Object class' odbcTypeSymbol
        'ShortFloat class' odbcTypeSymbol
        'Time class' odbcTypeSymbol
        'Timestamp class' odbcTypeSymbol
        'UUID class' odbcTypeSymbol
        'Unicode16String class' odbcTypeSymbol
        'Boolean class' odbcTypeSymbol
    )
! !

!stx_libdb_libodbc class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:20 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X ODBC DB Interface'

    "Modified: / 30-08-2006 / 15:10:18 / cg"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1999\nCopyright eXept Software AG 2011'

    "Modified: / 18-11-2016 / 12:18:13 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libdb_libodbc class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/stx_libdb_libodbc.st,v 1.34 2017-11-25 12:35:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/stx_libdb_libodbc.st,v 1.34 2017-11-25 12:35:14 cg Exp $'
! !

