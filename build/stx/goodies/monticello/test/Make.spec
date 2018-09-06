# $Header: /cvs/stx/stx/goodies/monticello/test/Make.spec,v 1.3 2013-05-29 00:03:01 vrany Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_monticello_test.
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
MODULE_DIR=goodies/monticello/test
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
	MCDependencySorterTest \
	MCSnapshotResource \
	MCSortingTest \
	MCTestCase \
	stx_goodies_monticello_test \
	MCAncestryTest \
	MCChangeNotificationTest \
	MCClassDefinitionTest \
	MCFileInTest \
	MCInitializationTest \
	MCMczInstallerTest \
	MCMergingTest \
	MCMethodDefinitionTest \
	MCOrganizationTest \
	MCPackageTest \
	MCPatchTest \
	MCRepositoryTest \
	MCScannerTest \
	MCSerializationTest \
	MCSnapshotBrowserTest \
	MCSnapshotTest \
	MCStReaderTest \
	MCStWriterTest \
	MCVersionTest \
	MCWorkingCopyTest \
	MCDictionaryRepositoryTest \
	MCDirectoryRepositoryTest \




COMMON_OBJS= \
    $(OUTDIR_SLASH)MCDependencySorterTest.$(O) \
    $(OUTDIR_SLASH)MCSnapshotResource.$(O) \
    $(OUTDIR_SLASH)MCSortingTest.$(O) \
    $(OUTDIR_SLASH)MCTestCase.$(O) \
    $(OUTDIR_SLASH)stx_goodies_monticello_test.$(O) \
    $(OUTDIR_SLASH)MCAncestryTest.$(O) \
    $(OUTDIR_SLASH)MCChangeNotificationTest.$(O) \
    $(OUTDIR_SLASH)MCClassDefinitionTest.$(O) \
    $(OUTDIR_SLASH)MCFileInTest.$(O) \
    $(OUTDIR_SLASH)MCInitializationTest.$(O) \
    $(OUTDIR_SLASH)MCMczInstallerTest.$(O) \
    $(OUTDIR_SLASH)MCMergingTest.$(O) \
    $(OUTDIR_SLASH)MCMethodDefinitionTest.$(O) \
    $(OUTDIR_SLASH)MCOrganizationTest.$(O) \
    $(OUTDIR_SLASH)MCPackageTest.$(O) \
    $(OUTDIR_SLASH)MCPatchTest.$(O) \
    $(OUTDIR_SLASH)MCRepositoryTest.$(O) \
    $(OUTDIR_SLASH)MCScannerTest.$(O) \
    $(OUTDIR_SLASH)MCSerializationTest.$(O) \
    $(OUTDIR_SLASH)MCSnapshotBrowserTest.$(O) \
    $(OUTDIR_SLASH)MCSnapshotTest.$(O) \
    $(OUTDIR_SLASH)MCStReaderTest.$(O) \
    $(OUTDIR_SLASH)MCStWriterTest.$(O) \
    $(OUTDIR_SLASH)MCVersionTest.$(O) \
    $(OUTDIR_SLASH)MCWorkingCopyTest.$(O) \
    $(OUTDIR_SLASH)MCDictionaryRepositoryTest.$(O) \
    $(OUTDIR_SLASH)MCDirectoryRepositoryTest.$(O) \



