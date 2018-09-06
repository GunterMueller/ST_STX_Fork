# $Header: /cvs/stx/stx/goodies/communication/messagePack/bc.mak,v 1.3 2018-05-08 15:37:20 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_messagePack.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Notice, that the name bc.mak is historical (from times, when only borland c was supported).
# This file contains make rules for the win32 platform using either borland-bcc or visual-c.
# It shares common definitions with the unix-make in Make.spec.
# The bc.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
# Historic Note:
#  this used to contain only rules to make with borland
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_communication_messagePack
MODULE_PATH=goodies\communication\messagePack
RESFILES=stx_goodies_communication_messagePackWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)MpConstants.$(O) MpConstants.$(C) MpConstants.$(H): MpConstants.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpConstantsPool.$(O) MpConstantsPool.$(C) MpConstantsPool.$(H): MpConstantsPool.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)MpDecoder.$(O) MpDecoder.$(C) MpDecoder.$(H): MpDecoder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpError.$(O) MpError.$(C) MpError.$(H): MpError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpExtValue.$(O) MpExtValue.$(C) MpExtValue.$(H): MpExtValue.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpMemoryWriteStream.$(O) MpMemoryWriteStream.$(C) MpMemoryWriteStream.$(H): MpMemoryWriteStream.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpMessagePack.$(O) MpMessagePack.$(C) MpMessagePack.$(H): MpMessagePack.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpPortableUtil.$(O) MpPortableUtil.$(C) MpPortableUtil.$(H): MpPortableUtil.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpSettings.$(O) MpSettings.$(C) MpSettings.$(H): MpSettings.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpTypeMapper.$(O) MpTypeMapper.$(C) MpTypeMapper.$(H): MpTypeMapper.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_communication_messagePack.$(O) stx_goodies_communication_messagePack.$(C) stx_goodies_communication_messagePack.$(H): stx_goodies_communication_messagePack.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)MpDecodeTypeMapper.$(O) MpDecodeTypeMapper.$(C) MpDecodeTypeMapper.$(H): MpDecodeTypeMapper.st $(INCLUDE_TOP)\stx\goodies\communication\messagePack\MpConstantsPool.$(H) $(INCLUDE_TOP)\stx\goodies\communication\messagePack\MpTypeMapper.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpEncodeTypeMapper.$(O) MpEncodeTypeMapper.$(C) MpEncodeTypeMapper.$(H): MpEncodeTypeMapper.st $(INCLUDE_TOP)\stx\goodies\communication\messagePack\MpTypeMapper.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpEncoder.$(O) MpEncoder.$(C) MpEncoder.$(H): MpEncoder.st $(INCLUDE_TOP)\stx\goodies\communication\messagePack\MpConstantsPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpFixextValue.$(O) MpFixextValue.$(C) MpFixextValue.$(H): MpFixextValue.st $(INCLUDE_TOP)\stx\goodies\communication\messagePack\MpExtValue.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpSqPortableUtil.$(O) MpSqPortableUtil.$(C) MpSqPortableUtil.$(H): MpSqPortableUtil.st $(INCLUDE_TOP)\stx\goodies\communication\messagePack\MpPortableUtil.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpSTXEncodeTypeMapper.$(O) MpSTXEncodeTypeMapper.$(C) MpSTXEncodeTypeMapper.$(H): MpSTXEncodeTypeMapper.st $(INCLUDE_TOP)\stx\goodies\communication\messagePack\MpEncodeTypeMapper.$(H) $(INCLUDE_TOP)\stx\goodies\communication\messagePack\MpTypeMapper.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MpSqEncodeTypeMapper.$(O) MpSqEncodeTypeMapper.$(C) MpSqEncodeTypeMapper.$(H): MpSqEncodeTypeMapper.st $(INCLUDE_TOP)\stx\goodies\communication\messagePack\MpEncodeTypeMapper.$(H) $(INCLUDE_TOP)\stx\goodies\communication\messagePack\MpTypeMapper.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
