# $Header: /cvs/stx/stx/libdb/Make.spec,v 1.20 2014-11-24 15:06:50 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb.
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
MODULE_DIR=libdb
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
	SQL::Connection \
	SQL::Cursor \
	SQL::Database \
	SQL::DatabaseColumnDescription \
	SQL::DatabaseHandle \
	SQL::DatabaseKeyDescription \
	SQL::DatabaseReturnValue \
	SQL::DatabaseRowObject \
	SQL::DatabaseTableDescription \
	SQL::SQLError \
	SQL::SQLNotification \
	SQL::Statement \
	SQL::Transaction \
	stx_libdb \
	SQL::DatabaseSession \




COMMON_OBJS= \
    $(OUTDIR_SLASH)SQL__Connection.$(O) \
    $(OUTDIR_SLASH)SQL__Cursor.$(O) \
    $(OUTDIR_SLASH)SQL__Database.$(O) \
    $(OUTDIR_SLASH)SQL__DatabaseColumnDescription.$(O) \
    $(OUTDIR_SLASH)SQL__DatabaseHandle.$(O) \
    $(OUTDIR_SLASH)SQL__DatabaseKeyDescription.$(O) \
    $(OUTDIR_SLASH)SQL__DatabaseReturnValue.$(O) \
    $(OUTDIR_SLASH)SQL__DatabaseRowObject.$(O) \
    $(OUTDIR_SLASH)SQL__DatabaseTableDescription.$(O) \
    $(OUTDIR_SLASH)SQL__SQLError.$(O) \
    $(OUTDIR_SLASH)SQL__SQLNotification.$(O) \
    $(OUTDIR_SLASH)SQL__Statement.$(O) \
    $(OUTDIR_SLASH)SQL__Transaction.$(O) \
    $(OUTDIR_SLASH)stx_libdb.$(O) \
    $(OUTDIR_SLASH)SQL__DatabaseSession.$(O) \



