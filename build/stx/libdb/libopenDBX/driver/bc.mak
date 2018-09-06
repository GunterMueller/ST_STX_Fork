# $Header: /cvs/stx/stx/libdb/libopenDBX/driver/bc.mak,v 1.1 2013-04-15 13:11:54 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_libopenDBX_driver.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Notice, that the name bc.mak is historical (from times, when only borland c was supported).
# This file contains make rules for the win32 platform using either borland-bcc or visual-c.
# It shares common definitions with the unix-make in Make.spec.
# The bc.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
# Historic Note:
#  this used to contain only rules to make with borland
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libdb_libopenDBX_driver
RESFILES=driver.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "






clean::
	del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)DBXAuthenticationMethod.$(O) DBXAuthenticationMethod.$(H): DBXAuthenticationMethod.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXBackend.$(O) DBXBackend.$(H): DBXBackend.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXBaseResult.$(O) DBXBaseResult.$(H): DBXBaseResult.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXColumnDescription.$(O) DBXColumnDescription.$(H): DBXColumnDescription.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXConnection.$(O) DBXConnection.$(H): DBXConnection.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXConnectionSettings.$(O) DBXConnectionSettings.$(H): DBXConnectionSettings.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXEncodingStrategy.$(O) DBXEncodingStrategy.$(H): DBXEncodingStrategy.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXEncryptionValues.$(O) DBXEncryptionValues.$(H): DBXEncryptionValues.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXError.$(O) DBXError.$(H): DBXError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXErrorSeverity.$(O) DBXErrorSeverity.$(H): DBXErrorSeverity.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXLogger.$(O) DBXLogger.$(H): DBXLogger.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXNotification.$(O) DBXNotification.$(H): DBXNotification.st $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXQuerySettings.$(O) DBXQuerySettings.$(H): DBXQuerySettings.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXQueryTimeout.$(O) DBXQueryTimeout.$(H): DBXQueryTimeout.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXResultDescription.$(O) DBXResultDescription.$(H): DBXResultDescription.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXResultSetDescription.$(O) DBXResultSetDescription.$(H): DBXResultSetDescription.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXRow.$(O) DBXRow.$(H): DBXRow.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXSpecialOptions.$(O) DBXSpecialOptions.$(H): DBXSpecialOptions.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXTimeSpec.$(O) DBXTimeSpec.$(H): DBXTimeSpec.st $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXTypeNotSupported.$(O) DBXTypeNotSupported.$(H): DBXTypeNotSupported.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OpenDBX.$(O) OpenDBX.$(H): OpenDBX.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OpenDBXDriverSmalltalkDialect.$(O) OpenDBXDriverSmalltalkDialect.$(H): OpenDBXDriverSmalltalkDialect.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TextConverter.$(O) TextConverter.$(H): TextConverter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_libopenDBX_driver.$(O) stx_libdb_libopenDBX_driver.$(H): stx_libdb_libopenDBX_driver.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXAutomaticEncoding.$(O) DBXAutomaticEncoding.$(H): DBXAutomaticEncoding.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXEncodingStrategy.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXFirebirdBackend.$(O) DBXFirebirdBackend.$(H): DBXFirebirdBackend.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXBackend.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXMSSQLBackend.$(O) DBXMSSQLBackend.$(H): DBXMSSQLBackend.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXBackend.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXMultiStatementResultSetIterator.$(O) DBXMultiStatementResultSetIterator.$(H): DBXMultiStatementResultSetIterator.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXBaseResult.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXMySQLBackend.$(O) DBXMySQLBackend.$(H): DBXMySQLBackend.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXBackend.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXNoEncoding.$(O) DBXNoEncoding.$(H): DBXNoEncoding.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXEncodingStrategy.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXNullTextConverter.$(O) DBXNullTextConverter.$(H): DBXNullTextConverter.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\TextConverter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXOdbcBackend.$(O) DBXOdbcBackend.$(H): DBXOdbcBackend.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXBackend.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXOracleBackend.$(O) DBXOracleBackend.$(H): DBXOracleBackend.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXBackend.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXPostgresBackend.$(O) DBXPostgresBackend.$(H): DBXPostgresBackend.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXBackend.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXResult.$(O) DBXResult.$(H): DBXResult.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXBaseResult.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXResultSet.$(O) DBXResultSet.$(H): DBXResultSet.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXBaseResult.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXSqliteBackend.$(O) DBXSqliteBackend.$(H): DBXSqliteBackend.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXBackend.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXStaticEncoding.$(O) DBXStaticEncoding.$(H): DBXStaticEncoding.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXEncodingStrategy.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OpenDBXDriverError.$(O) OpenDBXDriverError.$(H): OpenDBXDriverError.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OpenDBXError.$(O) OpenDBXError.$(H): OpenDBXError.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXFatalError.$(O) DBXFatalError.$(H): DBXFatalError.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\OpenDBXError.$(H) $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXMySQL4Backend.$(O) DBXMySQL4Backend.$(H): DBXMySQL4Backend.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXMySQLBackend.$(H) $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXBackend.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXRecoverableError.$(O) DBXRecoverableError.$(H): DBXRecoverableError.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\OpenDBXError.$(H) $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\DBXError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Date.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\False.$(H) $(INCLUDE_TOP)\stx\libbasic\Boolean.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Time.$(H) $(INCLUDE_TOP)\stx\libbasic\AbstractTime.$(H) $(INCLUDE_TOP)\stx\libbasic\Timestamp.$(H) $(INCLUDE_TOP)\stx\libbasic\True.$(H) $(INCLUDE_TOP)\stx\libbasic\UndefinedObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Number.$(H) $(INCLUDE_TOP)\stx\libbasic\ArithmeticValue.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
