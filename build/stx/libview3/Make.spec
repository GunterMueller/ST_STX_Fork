# $Header: /cvs/stx/stx/libview3/Make.spec,v 1.10 2013-03-01 13:26:08 stefan Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libview3.
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
MODULE_DIR=libview3
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
	DisplayObjectComponentSpec \
	Morph \
	stx_libview3 \
	ArcMorph \
	ArcMorphSpec \
	LineSegmentMorph \
	LineSegmentMorphSpec \
	RectangleMorph \
	RectangleMorphSpec \
	SketchMorph \
	SketchMorphSpec \




COMMON_OBJS= \
    $(OUTDIR_SLASH)DisplayObjectComponentSpec.$(O) \
    $(OUTDIR_SLASH)Morph.$(O) \
    $(OUTDIR_SLASH)stx_libview3.$(O) \
    $(OUTDIR_SLASH)ArcMorph.$(O) \
    $(OUTDIR_SLASH)ArcMorphSpec.$(O) \
    $(OUTDIR_SLASH)LineSegmentMorph.$(O) \
    $(OUTDIR_SLASH)LineSegmentMorphSpec.$(O) \
    $(OUTDIR_SLASH)RectangleMorph.$(O) \
    $(OUTDIR_SLASH)RectangleMorphSpec.$(O) \
    $(OUTDIR_SLASH)SketchMorph.$(O) \
    $(OUTDIR_SLASH)SketchMorphSpec.$(O) \



