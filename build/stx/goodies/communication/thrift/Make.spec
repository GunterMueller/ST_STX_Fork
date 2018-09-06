# $Header: /cvs/stx/stx/goodies/communication/thrift/Make.spec,v 1.4 2013-03-21 10:34:11 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_thrift.
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
MODULE_DIR=goodies/communication/thrift
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
	TClient \
	TError \
	TField \
	TMessage \
	TConstants \
	TResult \
	TSizedObject \
	TStruct \
	TTransport \
	TType \
	stx_goodies_communication_thrift \
	TProtocol \
	TCallMessage \
	TList \
	TMap \
	TProtocolError \
	TTransportError \
	TSet \
	TTransportClosedError \
	TBinaryProtocol \
	TFramedTransport \




COMMON_OBJS= \
    $(OUTDIR_SLASH)TClient.$(O) \
    $(OUTDIR_SLASH)TError.$(O) \
    $(OUTDIR_SLASH)TField.$(O) \
    $(OUTDIR_SLASH)TMessage.$(O) \
    $(OUTDIR_SLASH)TConstants.$(O) \
    $(OUTDIR_SLASH)TResult.$(O) \
    $(OUTDIR_SLASH)TSizedObject.$(O) \
    $(OUTDIR_SLASH)TStruct.$(O) \
    $(OUTDIR_SLASH)TTransport.$(O) \
    $(OUTDIR_SLASH)TType.$(O) \
    $(OUTDIR_SLASH)stx_goodies_communication_thrift.$(O) \
    $(OUTDIR_SLASH)TProtocol.$(O) \
    $(OUTDIR_SLASH)TCallMessage.$(O) \
    $(OUTDIR_SLASH)TList.$(O) \
    $(OUTDIR_SLASH)TMap.$(O) \
    $(OUTDIR_SLASH)TProtocolError.$(O) \
    $(OUTDIR_SLASH)TTransportError.$(O) \
    $(OUTDIR_SLASH)TSet.$(O) \
    $(OUTDIR_SLASH)TTransportClosedError.$(O) \
    $(OUTDIR_SLASH)TBinaryProtocol.$(O) \
    $(OUTDIR_SLASH)TFramedTransport.$(O) \



