# $Header: /cvs/stx/stx/libdb/libopenDBX/driver/Make.spec,v 1.1 2013-04-15 13:11:45 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_libopenDBX_driver.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=stx
MODULE_DIR=libdb/libopenDBX/driver
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to to CC for inline C-code
#  -Ixxx       : include path passed to CC for inline C-code
#  +optspace   : optimized for space
#  +optspace2  : optimized more for space
#  +optspace3  : optimized even more for space
#  +optinline  : generate inline code for some ST constructs
#  +inlineNew  : additionally inline new
#  +inlineMath : additionally inline some floatPnt math stuff
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCLOCALOPTIMIZATIONS=+optinline +inlineNew
# STCLOCALOPTIMIZATIONS=+optspace3
STCLOCALOPTIMIZATIONS=+optspace3


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	DBXAuthenticationMethod \
	DBXBackend \
	DBXBaseResult \
	DBXColumnDescription \
	DBXConnection \
	DBXConnectionSettings \
	DBXEncodingStrategy \
	DBXEncryptionValues \
	DBXError \
	DBXErrorSeverity \
	DBXLogger \
	DBXNotification \
	DBXQuerySettings \
	DBXQueryTimeout \
	DBXResultDescription \
	DBXResultSetDescription \
	DBXRow \
	DBXSpecialOptions \
	DBXTimeSpec \
	DBXTypeNotSupported \
	OpenDBX \
	OpenDBXDriverSmalltalkDialect \
	TextConverter \
	stx_libdb_libopenDBX_driver \
	DBXAutomaticEncoding \
	DBXFirebirdBackend \
	DBXMSSQLBackend \
	DBXMultiStatementResultSetIterator \
	DBXMySQLBackend \
	DBXNoEncoding \
	DBXNullTextConverter \
	DBXOdbcBackend \
	DBXOracleBackend \
	DBXPostgresBackend \
	DBXResult \
	DBXResultSet \
	DBXSqliteBackend \
	DBXStaticEncoding \
	OpenDBXDriverError \
	OpenDBXError \
	DBXFatalError \
	DBXMySQL4Backend \
	DBXRecoverableError \




COMMON_OBJS= \
    $(OUTDIR_SLASH)DBXAuthenticationMethod.$(O) \
    $(OUTDIR_SLASH)DBXBackend.$(O) \
    $(OUTDIR_SLASH)DBXBaseResult.$(O) \
    $(OUTDIR_SLASH)DBXColumnDescription.$(O) \
    $(OUTDIR_SLASH)DBXConnection.$(O) \
    $(OUTDIR_SLASH)DBXConnectionSettings.$(O) \
    $(OUTDIR_SLASH)DBXEncodingStrategy.$(O) \
    $(OUTDIR_SLASH)DBXEncryptionValues.$(O) \
    $(OUTDIR_SLASH)DBXError.$(O) \
    $(OUTDIR_SLASH)DBXErrorSeverity.$(O) \
    $(OUTDIR_SLASH)DBXLogger.$(O) \
    $(OUTDIR_SLASH)DBXNotification.$(O) \
    $(OUTDIR_SLASH)DBXQuerySettings.$(O) \
    $(OUTDIR_SLASH)DBXQueryTimeout.$(O) \
    $(OUTDIR_SLASH)DBXResultDescription.$(O) \
    $(OUTDIR_SLASH)DBXResultSetDescription.$(O) \
    $(OUTDIR_SLASH)DBXRow.$(O) \
    $(OUTDIR_SLASH)DBXSpecialOptions.$(O) \
    $(OUTDIR_SLASH)DBXTimeSpec.$(O) \
    $(OUTDIR_SLASH)DBXTypeNotSupported.$(O) \
    $(OUTDIR_SLASH)OpenDBX.$(O) \
    $(OUTDIR_SLASH)OpenDBXDriverSmalltalkDialect.$(O) \
    $(OUTDIR_SLASH)TextConverter.$(O) \
    $(OUTDIR_SLASH)stx_libdb_libopenDBX_driver.$(O) \
    $(OUTDIR_SLASH)DBXAutomaticEncoding.$(O) \
    $(OUTDIR_SLASH)DBXFirebirdBackend.$(O) \
    $(OUTDIR_SLASH)DBXMSSQLBackend.$(O) \
    $(OUTDIR_SLASH)DBXMultiStatementResultSetIterator.$(O) \
    $(OUTDIR_SLASH)DBXMySQLBackend.$(O) \
    $(OUTDIR_SLASH)DBXNoEncoding.$(O) \
    $(OUTDIR_SLASH)DBXNullTextConverter.$(O) \
    $(OUTDIR_SLASH)DBXOdbcBackend.$(O) \
    $(OUTDIR_SLASH)DBXOracleBackend.$(O) \
    $(OUTDIR_SLASH)DBXPostgresBackend.$(O) \
    $(OUTDIR_SLASH)DBXResult.$(O) \
    $(OUTDIR_SLASH)DBXResultSet.$(O) \
    $(OUTDIR_SLASH)DBXSqliteBackend.$(O) \
    $(OUTDIR_SLASH)DBXStaticEncoding.$(O) \
    $(OUTDIR_SLASH)OpenDBXDriverError.$(O) \
    $(OUTDIR_SLASH)OpenDBXError.$(O) \
    $(OUTDIR_SLASH)DBXFatalError.$(O) \
    $(OUTDIR_SLASH)DBXMySQL4Backend.$(O) \
    $(OUTDIR_SLASH)DBXRecoverableError.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



