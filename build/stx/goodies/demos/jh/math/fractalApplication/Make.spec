# $Header: /cvs/stx/stx/goodies/demos/jh/math/fractalApplication/Make.spec,v 1.2 2013-01-30 11:19:44 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_demos_jh_math_fractalApplication.
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
MODULE_DIR=goodies/demos/jh/math/fractalApplication
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
	Demos::FractalApplication \
	Demos::FractalView \
	Demos::MandelbrotSet \
	Demos::SuperFormula \
	Demos::SuperFormulaApplication \
	stx_goodies_demos_jh_math_fractalApplication \
	Demos::JuliaSet \




COMMON_OBJS= \
    $(OUTDIR_SLASH)FractalApplication.$(O) \
    $(OUTDIR_SLASH)FractalView.$(O) \
    $(OUTDIR_SLASH)MandelbrotSet.$(O) \
    $(OUTDIR_SLASH)Demos__SuperFormula.$(O) \
    $(OUTDIR_SLASH)Demos__SuperFormulaApplication.$(O) \
    $(OUTDIR_SLASH)stx_goodies_demos_jh_math_fractalApplication.$(O) \
    $(OUTDIR_SLASH)JuliaSet.$(O) \



