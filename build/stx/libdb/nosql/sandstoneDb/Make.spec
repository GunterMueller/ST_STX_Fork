# $Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/Make.spec,v 1.5 2013-04-17 23:18:47 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_sandstoneDb.
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
MODULE_DIR=libdb/nosql/sandstoneDb
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
	SDAbstractStore \
	SDActiveRecord \
	SDCheckPointer \
	SDConcurrentDictionary \
	SDError \
	SDRecordMarker \
	stx_libdb_nosql_sandstoneDb \
	SDCommitError \
	SDLoadError \
	SDCachedStore \
	SDFileStore \
	SDMemoryStore \
	SDSerializer \
	SDSmartRefStreamSerializer \
	SDFuelSerializer \
	SDBOSSSerializer \




COMMON_OBJS= \
    $(OUTDIR_SLASH)SDAbstractStore.$(O) \
    $(OUTDIR_SLASH)SDActiveRecord.$(O) \
    $(OUTDIR_SLASH)SDCheckPointer.$(O) \
    $(OUTDIR_SLASH)SDConcurrentDictionary.$(O) \
    $(OUTDIR_SLASH)SDError.$(O) \
    $(OUTDIR_SLASH)SDRecordMarker.$(O) \
    $(OUTDIR_SLASH)stx_libdb_nosql_sandstoneDb.$(O) \
    $(OUTDIR_SLASH)SDCommitError.$(O) \
    $(OUTDIR_SLASH)SDLoadError.$(O) \
    $(OUTDIR_SLASH)SDCachedStore.$(O) \
    $(OUTDIR_SLASH)SDFileStore.$(O) \
    $(OUTDIR_SLASH)SDMemoryStore.$(O) \
    $(OUTDIR_SLASH)SDSerializer.$(O) \
    $(OUTDIR_SLASH)SDSmartRefStreamSerializer.$(O) \
    $(OUTDIR_SLASH)SDFuelSerializer.$(O) \
    $(OUTDIR_SLASH)SDBOSSSerializer.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



