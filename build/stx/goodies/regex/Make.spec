# $Header: /cvs/stx/stx/goodies/regex/Make.spec,v 1.13 2013-03-01 19:00:29 stefan Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_regex.
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
MODULE_DIR=goodies/regex
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
STCLOCALOPTIMIZATIONS=+optinline +optinline2


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
	Regex::RxCharSetParser \
	Regex::RxMatchOptimizer \
	Regex::RxMatcher \
	Regex::RxParser \
	Regex::RxmLink \
	Regex::RxmBranch \
	Regex::RxmMarker \
	Regex::RxmPredicate \
	Regex::RxmSpecial \
	Regex::RxmSubstring \
	Regex::RxmTerminator \
	Regex::RxsNode \
	Regex::RxsCharClass \
	Regex::RxsCharSet \
	Regex::RxsCharacter \
	Regex::RxsContextCondition \
	Regex::RxsEpsilon \
	Regex::RxsMessagePredicate \
	Regex::RxsBranch \
	Regex::RxsPiece \
	Regex::RxsPredicate \
	Regex::RxsRange \
	Regex::RxsRegex \
	Regex::RxsSpecial \
	stx_goodies_regex \
	Regex::RxmRepetition \




COMMON_OBJS= \
    $(OUTDIR_SLASH)RxCharSetParser.$(O) \
    $(OUTDIR_SLASH)RxMatchOptimizer.$(O) \
    $(OUTDIR_SLASH)RxMatcher.$(O) \
    $(OUTDIR_SLASH)RxParser.$(O) \
    $(OUTDIR_SLASH)RxmLink.$(O) \
    $(OUTDIR_SLASH)RxmBranch.$(O) \
    $(OUTDIR_SLASH)RxmMarker.$(O) \
    $(OUTDIR_SLASH)RxmPredicate.$(O) \
    $(OUTDIR_SLASH)RxmSpecial.$(O) \
    $(OUTDIR_SLASH)RxmSubstring.$(O) \
    $(OUTDIR_SLASH)RxmTerminator.$(O) \
    $(OUTDIR_SLASH)RxsNode.$(O) \
    $(OUTDIR_SLASH)RxsCharClass.$(O) \
    $(OUTDIR_SLASH)RxsCharSet.$(O) \
    $(OUTDIR_SLASH)RxsCharacter.$(O) \
    $(OUTDIR_SLASH)RxsContextCondition.$(O) \
    $(OUTDIR_SLASH)RxsEpsilon.$(O) \
    $(OUTDIR_SLASH)RxsMessagePredicate.$(O) \
    $(OUTDIR_SLASH)RxsBranch.$(O) \
    $(OUTDIR_SLASH)RxsPiece.$(O) \
    $(OUTDIR_SLASH)RxsPredicate.$(O) \
    $(OUTDIR_SLASH)RxsRange.$(O) \
    $(OUTDIR_SLASH)RxsRegex.$(O) \
    $(OUTDIR_SLASH)RxsSpecial.$(O) \
    $(OUTDIR_SLASH)stx_goodies_regex.$(O) \
    $(OUTDIR_SLASH)Regex__RxmRepetition.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



