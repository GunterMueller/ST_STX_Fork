# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser.
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
MODULE_DIR=goodies/petitparser
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
	PPCharSetPredicate \
	PPContext \
	PPContextMemento \
	PPFailure \
	PPMemento \
	PPParser \
	PPStream \
	PPToken \
	stx_goodies_petitparser \
	PPDelegateParser \
	PPEndOfFileParser \
	PPEndOfLineParser \
	PPEpsilonParser \
	PPFailingParser \
	PPListParser \
	PPLiteralParser \
	PPPluggableParser \
	PPPredicateParser \
	PPStartOfLine \
	PPStartOfLineParser \
	PPStartOfLogicalLineParser \
	PPStartOfWordParser \
	PPUnresolvedParser \
	PPActionParser \
	PPAndParser \
	PPChoiceParser \
	PPCompositeParser \
	PPConditionalParser \
	PPEndOfInputParser \
	PPExpressionParser \
	PPFlattenParser \
	PPLiteralObjectParser \
	PPLiteralSequenceParser \
	PPMemoizedParser \
	PPNotParser \
	PPOptionalParser \
	PPPredicateObjectParser \
	PPPredicateSequenceParser \
	PPRepeatingParser \
	PPSequenceParser \
	PPTrimmingParser \
	PPLimitedChoiceParser \
	PPLimitedRepeatingParser \
	PPPossessiveRepeatingParser \
	PPTokenParser \
	PPWrappingParser \
	PPGreedyRepeatingParser \
	PPLazyRepeatingParser \




COMMON_OBJS= \
    $(OUTDIR_SLASH)PPCharSetPredicate.$(O) \
    $(OUTDIR_SLASH)PPContext.$(O) \
    $(OUTDIR_SLASH)PPContextMemento.$(O) \
    $(OUTDIR_SLASH)PPFailure.$(O) \
    $(OUTDIR_SLASH)PPMemento.$(O) \
    $(OUTDIR_SLASH)PPParser.$(O) \
    $(OUTDIR_SLASH)PPStream.$(O) \
    $(OUTDIR_SLASH)PPToken.$(O) \
    $(OUTDIR_SLASH)stx_goodies_petitparser.$(O) \
    $(OUTDIR_SLASH)PPDelegateParser.$(O) \
    $(OUTDIR_SLASH)PPEndOfFileParser.$(O) \
    $(OUTDIR_SLASH)PPEndOfLineParser.$(O) \
    $(OUTDIR_SLASH)PPEpsilonParser.$(O) \
    $(OUTDIR_SLASH)PPFailingParser.$(O) \
    $(OUTDIR_SLASH)PPListParser.$(O) \
    $(OUTDIR_SLASH)PPLiteralParser.$(O) \
    $(OUTDIR_SLASH)PPPluggableParser.$(O) \
    $(OUTDIR_SLASH)PPPredicateParser.$(O) \
    $(OUTDIR_SLASH)PPStartOfLine.$(O) \
    $(OUTDIR_SLASH)PPStartOfLineParser.$(O) \
    $(OUTDIR_SLASH)PPStartOfLogicalLineParser.$(O) \
    $(OUTDIR_SLASH)PPStartOfWordParser.$(O) \
    $(OUTDIR_SLASH)PPUnresolvedParser.$(O) \
    $(OUTDIR_SLASH)PPActionParser.$(O) \
    $(OUTDIR_SLASH)PPAndParser.$(O) \
    $(OUTDIR_SLASH)PPChoiceParser.$(O) \
    $(OUTDIR_SLASH)PPCompositeParser.$(O) \
    $(OUTDIR_SLASH)PPConditionalParser.$(O) \
    $(OUTDIR_SLASH)PPEndOfInputParser.$(O) \
    $(OUTDIR_SLASH)PPExpressionParser.$(O) \
    $(OUTDIR_SLASH)PPFlattenParser.$(O) \
    $(OUTDIR_SLASH)PPLiteralObjectParser.$(O) \
    $(OUTDIR_SLASH)PPLiteralSequenceParser.$(O) \
    $(OUTDIR_SLASH)PPMemoizedParser.$(O) \
    $(OUTDIR_SLASH)PPNotParser.$(O) \
    $(OUTDIR_SLASH)PPOptionalParser.$(O) \
    $(OUTDIR_SLASH)PPPredicateObjectParser.$(O) \
    $(OUTDIR_SLASH)PPPredicateSequenceParser.$(O) \
    $(OUTDIR_SLASH)PPRepeatingParser.$(O) \
    $(OUTDIR_SLASH)PPSequenceParser.$(O) \
    $(OUTDIR_SLASH)PPTrimmingParser.$(O) \
    $(OUTDIR_SLASH)PPLimitedChoiceParser.$(O) \
    $(OUTDIR_SLASH)PPLimitedRepeatingParser.$(O) \
    $(OUTDIR_SLASH)PPPossessiveRepeatingParser.$(O) \
    $(OUTDIR_SLASH)PPTokenParser.$(O) \
    $(OUTDIR_SLASH)PPWrappingParser.$(O) \
    $(OUTDIR_SLASH)PPGreedyRepeatingParser.$(O) \
    $(OUTDIR_SLASH)PPLazyRepeatingParser.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



