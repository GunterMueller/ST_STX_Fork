# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_libodbc.
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
MODULE_DIR=libdb/libodbc
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
	SQL::ODBCColumnDescription \
	SQL::ODBCCursor \
	SQL::ODBCEnvironment \
	SQL::ODBCError \
	SQL::ODBCHandle \
	SQL::ODBCKeyDescription \
	SQL::ODBCSession \
	SQL::ODBCStatement \
	SQL::ODBCTableDescription \
	stx_libdb_libodbc \
	SQL::ODBCConnectionError \
	SQL::ODBCSchemaColumnDescription \




COMMON_OBJS= \
    $(OUTDIR_SLASH)SQL__ODBCColumnDescription.$(O) \
    $(OUTDIR_SLASH)SQL__ODBCCursor.$(O) \
    $(OUTDIR_SLASH)SQL__ODBCEnvironment.$(O) \
    $(OUTDIR_SLASH)SQL__ODBCError.$(O) \
    $(OUTDIR_SLASH)SQL__ODBCHandle.$(O) \
    $(OUTDIR_SLASH)SQL__ODBCKeyDescription.$(O) \
    $(OUTDIR_SLASH)SQL__ODBCSession.$(O) \
    $(OUTDIR_SLASH)SQL__ODBCStatement.$(O) \
    $(OUTDIR_SLASH)SQL__ODBCTableDescription.$(O) \
    $(OUTDIR_SLASH)stx_libdb_libodbc.$(O) \
    $(OUTDIR_SLASH)SQL__ODBCConnectionError.$(O) \
    $(OUTDIR_SLASH)SQL__ODBCSchemaColumnDescription.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



