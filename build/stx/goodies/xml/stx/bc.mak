# $Header: /cvs/stx/stx/goodies/xml/stx/bc.mak,v 1.28 2018-05-03 23:40:12 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_xml_stx.
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


# see stdHeader_bc for LIBXMLSTX_BASE
LIB_BASE=$(LIBXMLSTX_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_xml_stx
MODULE_PATH=goodies\xml\stx
RESFILES=stx_goodies_xml_stxWINrc.$(RES)



LOCALINCLUDES=-I..\vw -I$(INCLUDE_TOP)\stx\goodies\xml\vw -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2
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
	pushd ..\vw & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)XML__FastSAXDriver.$(O) XML__FastSAXDriver.$(C) XML__FastSAXDriver.$(H): XML__FastSAXDriver.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLChangedInstanceLayoutException.$(O) XMLChangedInstanceLayoutException.$(C) XMLChangedInstanceLayoutException.$(H): XMLChangedInstanceLayoutException.st $(INCLUDE_TOP)\stx\goodies\xml\vw\InvalidSignal.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\XMLSignal.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLCoder.$(O) XMLCoder.$(C) XMLCoder.$(H): XMLCoder.st $(INCLUDE_TOP)\stx\libbasic\AspectVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ObjectCoder.$(H) $(INCLUDE_TOP)\stx\libbasic\Visitor.$(H) $(STCHDR)
$(OUTDIR)XMLStandardDecoder.$(O) XMLStandardDecoder.$(C) XMLStandardDecoder.$(H): XMLStandardDecoder.st $(INCLUDE_TOP)\stx\goodies\xml\vw\SAXDriver.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_xml_stx.$(O) stx_goodies_xml_stx.$(C) stx_goodies_xml_stx.$(H): stx_goodies_xml_stx.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)XMLStandardCoder.$(O) XMLStandardCoder.$(C) XMLStandardCoder.$(H): XMLStandardCoder.st $(INCLUDE_TOP)\stx\goodies\xml\stx\XMLCoder.$(H) $(INCLUDE_TOP)\stx\libbasic\AspectVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ObjectCoder.$(H) $(INCLUDE_TOP)\stx\libbasic\Visitor.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
