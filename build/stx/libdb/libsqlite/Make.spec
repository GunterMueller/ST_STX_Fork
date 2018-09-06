# $Header: /cvs/stx/stx/libdb/libsqlite/Make.spec,v 1.13 2014-11-24 14:31:13 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_libsqlite.
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
MODULE_DIR=libdb/libsqlite
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
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard -warnUnused

COMMON_CLASSES= \
	SQLiteConnection \
	SQLiteCursor \
	SQLiteStatement \
	SqliteError \
	SqliteErrorHolder \
	SqliteReference \
	SqliteResult \
	SqliteResultBuffer \
	SqliteResultCodes \
	stx_libdb_libsqlite \
	SQLiteColumnDescription \
	SqliteLibrary \




COMMON_OBJS= \
    $(OUTDIR_SLASH)SQLiteConnection.$(O) \
    $(OUTDIR_SLASH)SQLiteCursor.$(O) \
    $(OUTDIR_SLASH)SQLiteStatement.$(O) \
    $(OUTDIR_SLASH)SqliteError.$(O) \
    $(OUTDIR_SLASH)SqliteErrorHolder.$(O) \
    $(OUTDIR_SLASH)SqliteReference.$(O) \
    $(OUTDIR_SLASH)SqliteResult.$(O) \
    $(OUTDIR_SLASH)SqliteResultBuffer.$(O) \
    $(OUTDIR_SLASH)SqliteResultCodes.$(O) \
    $(OUTDIR_SLASH)stx_libdb_libsqlite.$(O) \
    $(OUTDIR_SLASH)SQLiteColumnDescription.$(O) \
    $(OUTDIR_SLASH)SqliteLibrary.$(O) \



