# $Header: /cvs/stx/stx/goodies/communication/thrift/bc.mak,v 1.4 2013-03-21 10:34:23 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_thrift.
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

LIBNAME=libstx_goodies_communication_thrift
RESFILES=thrift.$(RES)



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


# build all packages containing referenced classes for this package
# they are nor needed to compile the package
references:





clean::
	del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)TClient.$(O) TClient.$(H): TClient.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TConstants.$(O) TConstants.$(H): TConstants.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TError.$(O) TError.$(H): TError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TField.$(O) TField.$(H): TField.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TMessage.$(O) TMessage.$(H): TMessage.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TResult.$(O) TResult.$(H): TResult.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TSizedObject.$(O) TSizedObject.$(H): TSizedObject.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TStruct.$(O) TStruct.$(H): TStruct.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TTransport.$(O) TTransport.$(H): TTransport.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TType.$(O) TType.$(H): TType.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_communication_thrift.$(O) stx_goodies_communication_thrift.$(H): stx_goodies_communication_thrift.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TCallMessage.$(O) TCallMessage.$(H): TCallMessage.st $(INCLUDE_TOP)\stx\goodies\communication\thrift\TMessage.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TFramedTransport.$(O) TFramedTransport.$(H): TFramedTransport.st $(INCLUDE_TOP)\stx\goodies\communication\thrift\TTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TList.$(O) TList.$(H): TList.st $(INCLUDE_TOP)\stx\goodies\communication\thrift\TSizedObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TMap.$(O) TMap.$(H): TMap.st $(INCLUDE_TOP)\stx\goodies\communication\thrift\TSizedObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TProtocol.$(O) TProtocol.$(H): TProtocol.st $(INCLUDE_TOP)\stx\goodies\communication\thrift\TConstants.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TProtocolError.$(O) TProtocolError.$(H): TProtocolError.st $(INCLUDE_TOP)\stx\goodies\communication\thrift\TError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TTransportError.$(O) TTransportError.$(H): TTransportError.st $(INCLUDE_TOP)\stx\goodies\communication\thrift\TError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TBinaryProtocol.$(O) TBinaryProtocol.$(H): TBinaryProtocol.st $(INCLUDE_TOP)\stx\goodies\communication\thrift\TConstants.$(H) $(INCLUDE_TOP)\stx\goodies\communication\thrift\TProtocol.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TSet.$(O) TSet.$(H): TSet.st $(INCLUDE_TOP)\stx\goodies\communication\thrift\TList.$(H) $(INCLUDE_TOP)\stx\goodies\communication\thrift\TSizedObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TTransportClosedError.$(O) TTransportClosedError.$(H): TTransportClosedError.st $(INCLUDE_TOP)\stx\goodies\communication\thrift\TTransportError.$(H) $(INCLUDE_TOP)\stx\goodies\communication\thrift\TError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
