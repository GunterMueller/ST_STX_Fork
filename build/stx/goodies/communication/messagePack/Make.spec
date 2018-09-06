# $Header: /cvs/stx/stx/goodies/communication/messagePack/Make.spec,v 1.4 2018-05-08 15:37:17 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_messagePack.
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
MODULE_DIR=goodies/communication/messagePack
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
	MpConstants \
	MpConstantsPool \
	MpDecoder \
	MpError \
	MpExtValue \
	MpMemoryWriteStream \
	MpMessagePack \
	MpPortableUtil \
	MpSettings \
	MpTypeMapper \
	stx_goodies_communication_messagePack \
	MpDecodeTypeMapper \
	MpEncodeTypeMapper \
	MpEncoder \
	MpFixextValue \
	MpSqPortableUtil \
	MpSTXEncodeTypeMapper \
	MpSqEncodeTypeMapper \




COMMON_OBJS= \
    $(OUTDIR)MpConstants.$(O) \
    $(OUTDIR)MpConstantsPool.$(O) \
    $(OUTDIR)MpDecoder.$(O) \
    $(OUTDIR)MpError.$(O) \
    $(OUTDIR)MpExtValue.$(O) \
    $(OUTDIR)MpMemoryWriteStream.$(O) \
    $(OUTDIR)MpMessagePack.$(O) \
    $(OUTDIR)MpPortableUtil.$(O) \
    $(OUTDIR)MpSettings.$(O) \
    $(OUTDIR)MpTypeMapper.$(O) \
    $(OUTDIR)stx_goodies_communication_messagePack.$(O) \
    $(OUTDIR)MpDecodeTypeMapper.$(O) \
    $(OUTDIR)MpEncodeTypeMapper.$(O) \
    $(OUTDIR)MpEncoder.$(O) \
    $(OUTDIR)MpFixextValue.$(O) \
    $(OUTDIR)MpSqPortableUtil.$(O) \
    $(OUTDIR)MpSTXEncodeTypeMapper.$(O) \
    $(OUTDIR)MpSqEncodeTypeMapper.$(O) \
    $(OUTDIR)extensions.$(O) \



