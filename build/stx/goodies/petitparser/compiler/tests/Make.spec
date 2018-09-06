# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_compiler_tests.
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
MODULE_DIR=goodies/petitparser/compiler/tests
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
STCLOCALOPTIMIZATIONS=+optspace3 -inlinenot


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
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	FooScannerTest \
	PEGFsaChoiceDeterminizationTest \
	PEGFsaDeterminizationTest \
	PEGFsaGeneratorTest \
	PEGFsaIntegrationTest \
	PEGFsaInterpretTest \
	PEGFsaMinimizationTest \
	PEGFsaScannerIntegrationTest \
	PEGFsaSequenceDeterminizationTest \
	PEGFsaStateTest \
	PEGFsaTest \
	PEGFsaTransitionTest \
	PPCASTUtilitiesTests \
	PPCClassBuilderTest \
	PPCCodeGeneratorTest \
	PPCContextMementoTest \
	PPCContextTest \
	PPCCopyVisitorTest \
	PPCDistinctScannerTest \
	PPCGuardTest \
	PPCIdGeneratorTest \
	PPCInliningVisitorTest \
	PPCLL1VisitorTest \
	PPCLTokenizingOptimizationTest \
	PPCMergingVisitorTest \
	PPCMockCompiler \
	PPCNodeFirstFollowNextTests \
	PPCNodeTest \
	PPCOptimizeChoicesTest \
	PPCOverlappingTokensTest \
	PPCRecognizerComponentDetectorTest \
	PPCRecognizerComponentVisitorTest \
	PPCScannerCodeGeneratorTest \
	PPCSpecializingVisitorTest \
	PPCTokenDetectorTest \
	PPCTokenGuardTest \
	PPCTokenizingCodeGeneratorTest \
	PPCTokenizingTest \
	PPCTokenizingVisitorTest \
	PPCUnivarsalGuardTest \
	PPCUniversalOptimizationTest \
	PPCUniversalTest \
	stx_goodies_petitparser_compiler_tests \




COMMON_OBJS= \
    $(OUTDIR_SLASH)FooScannerTest.$(O) \
    $(OUTDIR_SLASH)PEGFsaChoiceDeterminizationTest.$(O) \
    $(OUTDIR_SLASH)PEGFsaDeterminizationTest.$(O) \
    $(OUTDIR_SLASH)PEGFsaGeneratorTest.$(O) \
    $(OUTDIR_SLASH)PEGFsaIntegrationTest.$(O) \
    $(OUTDIR_SLASH)PEGFsaInterpretTest.$(O) \
    $(OUTDIR_SLASH)PEGFsaMinimizationTest.$(O) \
    $(OUTDIR_SLASH)PEGFsaScannerIntegrationTest.$(O) \
    $(OUTDIR_SLASH)PEGFsaSequenceDeterminizationTest.$(O) \
    $(OUTDIR_SLASH)PEGFsaStateTest.$(O) \
    $(OUTDIR_SLASH)PEGFsaTest.$(O) \
    $(OUTDIR_SLASH)PEGFsaTransitionTest.$(O) \
    $(OUTDIR_SLASH)PPCASTUtilitiesTests.$(O) \
    $(OUTDIR_SLASH)PPCClassBuilderTest.$(O) \
    $(OUTDIR_SLASH)PPCCodeGeneratorTest.$(O) \
    $(OUTDIR_SLASH)PPCContextMementoTest.$(O) \
    $(OUTDIR_SLASH)PPCContextTest.$(O) \
    $(OUTDIR_SLASH)PPCCopyVisitorTest.$(O) \
    $(OUTDIR_SLASH)PPCDistinctScannerTest.$(O) \
    $(OUTDIR_SLASH)PPCGuardTest.$(O) \
    $(OUTDIR_SLASH)PPCIdGeneratorTest.$(O) \
    $(OUTDIR_SLASH)PPCInliningVisitorTest.$(O) \
    $(OUTDIR_SLASH)PPCLL1VisitorTest.$(O) \
    $(OUTDIR_SLASH)PPCLTokenizingOptimizationTest.$(O) \
    $(OUTDIR_SLASH)PPCMergingVisitorTest.$(O) \
    $(OUTDIR_SLASH)PPCMockCompiler.$(O) \
    $(OUTDIR_SLASH)PPCNodeFirstFollowNextTests.$(O) \
    $(OUTDIR_SLASH)PPCNodeTest.$(O) \
    $(OUTDIR_SLASH)PPCOptimizeChoicesTest.$(O) \
    $(OUTDIR_SLASH)PPCOverlappingTokensTest.$(O) \
    $(OUTDIR_SLASH)PPCRecognizerComponentDetectorTest.$(O) \
    $(OUTDIR_SLASH)PPCRecognizerComponentVisitorTest.$(O) \
    $(OUTDIR_SLASH)PPCScannerCodeGeneratorTest.$(O) \
    $(OUTDIR_SLASH)PPCSpecializingVisitorTest.$(O) \
    $(OUTDIR_SLASH)PPCTokenDetectorTest.$(O) \
    $(OUTDIR_SLASH)PPCTokenGuardTest.$(O) \
    $(OUTDIR_SLASH)PPCTokenizingCodeGeneratorTest.$(O) \
    $(OUTDIR_SLASH)PPCTokenizingTest.$(O) \
    $(OUTDIR_SLASH)PPCTokenizingVisitorTest.$(O) \
    $(OUTDIR_SLASH)PPCUnivarsalGuardTest.$(O) \
    $(OUTDIR_SLASH)PPCUniversalOptimizationTest.$(O) \
    $(OUTDIR_SLASH)PPCUniversalTest.$(O) \
    $(OUTDIR_SLASH)stx_goodies_petitparser_compiler_tests.$(O) \



