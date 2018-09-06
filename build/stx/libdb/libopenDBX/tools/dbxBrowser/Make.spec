# $Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/Make.spec,v 1.3 2013-04-15 14:26:58 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_libopenDBX_tools_dbxBrowser.
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
MODULE_DIR=libdb/libopenDBX/tools/dbxBrowser
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
	DBXBrowser \
	DBXBrowserClosedConnection \
	DBXBrowserConnection \
	DBXBrowserModel \
	DBXBrowserOpenedConnection \
	DBXBrowserSchema \
	DBXBrowserTable \
	DBXConnectionAdded \
	DBXConnectionRemoved \
	DBXConnectionStatusChanged \
	DBXTablesRefresh \
	stx_libdb_libopenDBX_tools_dbxBrowser \




COMMON_OBJS= \
    $(OUTDIR_SLASH)DBXBrowser.$(O) \
    $(OUTDIR_SLASH)DBXBrowserClosedConnection.$(O) \
    $(OUTDIR_SLASH)DBXBrowserConnection.$(O) \
    $(OUTDIR_SLASH)DBXBrowserModel.$(O) \
    $(OUTDIR_SLASH)DBXBrowserOpenedConnection.$(O) \
    $(OUTDIR_SLASH)DBXBrowserSchema.$(O) \
    $(OUTDIR_SLASH)DBXBrowserTable.$(O) \
    $(OUTDIR_SLASH)DBXConnectionAdded.$(O) \
    $(OUTDIR_SLASH)DBXConnectionRemoved.$(O) \
    $(OUTDIR_SLASH)DBXConnectionStatusChanged.$(O) \
    $(OUTDIR_SLASH)DBXTablesRefresh.$(O) \
    $(OUTDIR_SLASH)stx_libdb_libopenDBX_tools_dbxBrowser.$(O) \



