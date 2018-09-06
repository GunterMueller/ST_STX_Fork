# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: jv_vdb.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=jv
MODULE_DIR=vdb
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to CC for inline C-code
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
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	RR \
	RREvent \
	VDBAbstractApplication \
	VDBAbstractPresenter \
	VDBEvaluator \
	VDBIconLibrary \
	VDBInstructionBasicBlock \
	VDBSettingsApplication \
	VDBVirtualMemoryMap \
	VDBVirtualMemoryRegion \
	VDBWindowsDebuggerConsoleView \
	jv_vdb \
	RRExitEvent \
	RRStartEvent \
	VDBAbstractContainer \
	VDBAbstractListApplication \
	VDBAbstractUnixConsoleApplication \
	VDBBreakpointApplication \
	VDBBreakpointPresenter \
	VDBDebuggerApplication \
	VDBEventLogApplication \
	VDBFrameApplication \
	VDBFramePresenter \
	VDBInstructionPresenter \
	VDBInstructionsAndSourcePresenter \
	VDBMemoryApplication \
	VDBSourceApplication \
	VDBThreadGroupPresenter \
	VDBThreadPresenter \
	VDBVariableObjectPresenter \
	VDBWindowsDebuggerConsoleApplication \
	VDBAbstractTreeApplication \
	VDBBreakpointListApplication \
	VDBTabbingContainer \
	VDBUnixDebuggerConsoleApplication \
	VDBUnixInferiorConsoleApplication \
	VDBUnixReplayServerConsoleApplication \
	VDBInstructionListApplication \
	VDBStackApplication \
	VDBVariableObjectListApplication \




COMMON_OBJS= \
    $(OUTDIR)RR.$(O) \
    $(OUTDIR)RREvent.$(O) \
    $(OUTDIR)VDBAbstractApplication.$(O) \
    $(OUTDIR)VDBAbstractPresenter.$(O) \
    $(OUTDIR)VDBEvaluator.$(O) \
    $(OUTDIR)VDBIconLibrary.$(O) \
    $(OUTDIR)VDBInstructionBasicBlock.$(O) \
    $(OUTDIR)VDBSettingsApplication.$(O) \
    $(OUTDIR)VDBVirtualMemoryMap.$(O) \
    $(OUTDIR)VDBVirtualMemoryRegion.$(O) \
    $(OUTDIR)VDBWindowsDebuggerConsoleView.$(O) \
    $(OUTDIR)jv_vdb.$(O) \
    $(OUTDIR)RRExitEvent.$(O) \
    $(OUTDIR)RRStartEvent.$(O) \
    $(OUTDIR)VDBAbstractContainer.$(O) \
    $(OUTDIR)VDBAbstractListApplication.$(O) \
    $(OUTDIR)VDBAbstractUnixConsoleApplication.$(O) \
    $(OUTDIR)VDBBreakpointApplication.$(O) \
    $(OUTDIR)VDBBreakpointPresenter.$(O) \
    $(OUTDIR)VDBDebuggerApplication.$(O) \
    $(OUTDIR)VDBEventLogApplication.$(O) \
    $(OUTDIR)VDBFrameApplication.$(O) \
    $(OUTDIR)VDBFramePresenter.$(O) \
    $(OUTDIR)VDBInstructionPresenter.$(O) \
    $(OUTDIR)VDBInstructionsAndSourcePresenter.$(O) \
    $(OUTDIR)VDBMemoryApplication.$(O) \
    $(OUTDIR)VDBSourceApplication.$(O) \
    $(OUTDIR)VDBThreadGroupPresenter.$(O) \
    $(OUTDIR)VDBThreadPresenter.$(O) \
    $(OUTDIR)VDBVariableObjectPresenter.$(O) \
    $(OUTDIR)VDBWindowsDebuggerConsoleApplication.$(O) \
    $(OUTDIR)VDBAbstractTreeApplication.$(O) \
    $(OUTDIR)VDBBreakpointListApplication.$(O) \
    $(OUTDIR)VDBTabbingContainer.$(O) \
    $(OUTDIR)VDBUnixDebuggerConsoleApplication.$(O) \
    $(OUTDIR)VDBUnixInferiorConsoleApplication.$(O) \
    $(OUTDIR)VDBUnixReplayServerConsoleApplication.$(O) \
    $(OUTDIR)VDBInstructionListApplication.$(O) \
    $(OUTDIR)VDBStackApplication.$(O) \
    $(OUTDIR)VDBVariableObjectListApplication.$(O) \
    $(OUTDIR)extensions.$(O) \



