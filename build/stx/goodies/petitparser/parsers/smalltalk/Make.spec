# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_parsers_smalltalk.
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
MODULE_DIR=goodies/petitparser/parsers/smalltalk
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
	PPSmalltalkGrammar \
	PPSmalltalkToken \
	PPSmalltalkTokenParser \
	PPSmalltalkWhitespaceParser \
	stx_goodies_petitparser_parsers_smalltalk \
	PPSmalltalkParser \




COMMON_OBJS= \
    $(OUTDIR_SLASH)PPSmalltalkGrammar.$(O) \
    $(OUTDIR_SLASH)PPSmalltalkToken.$(O) \
    $(OUTDIR_SLASH)PPSmalltalkTokenParser.$(O) \
    $(OUTDIR_SLASH)PPSmalltalkWhitespaceParser.$(O) \
    $(OUTDIR_SLASH)stx_goodies_petitparser_parsers_smalltalk.$(O) \
    $(OUTDIR_SLASH)PPSmalltalkParser.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



