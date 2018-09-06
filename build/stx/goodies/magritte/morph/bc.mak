# $Header: /cvs/stx/stx/goodies/magritte/morph/bc.mak,v 1.3 2013-05-28 10:31:48 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_magritte_morph.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains make rules for the win32 platform (using borland-bcc).
# It shares common definitions with the unix-make in Make.spec.
# The nt.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
#
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..

!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_magritte_morph
RESFILES=morph.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\goodies\magritte -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -H. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all prerequisite packages for this package
prereq:
	pushd ..\..\..\libbasic & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libcomp & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libui & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview3 & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd .. & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg2 & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libcompat & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\librun & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "




# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)Magritte__MADescriptionMorph.$(O) Magritte__MADescriptionMorph.$(H): Magritte__MADescriptionMorph.st $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_magritte_morph.$(O) stx_goodies_magritte_morph.$(H): stx_goodies_magritte_morph.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAContainerMorph.$(O) Magritte__MAContainerMorph.$(H): Magritte__MAContainerMorph.st $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MADescriptionMorph.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAElementMorph.$(O) Magritte__MAElementMorph.$(H): Magritte__MAElementMorph.st $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MADescriptionMorph.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MACheckboxMorph.$(O) Magritte__MACheckboxMorph.$(H): Magritte__MACheckboxMorph.st $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAElementMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MADescriptionMorph.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAFileMorph.$(O) Magritte__MAFileMorph.$(H): Magritte__MAFileMorph.st $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAElementMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MADescriptionMorph.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAListMorph.$(O) Magritte__MAListMorph.$(H): Magritte__MAListMorph.st $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAElementMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MADescriptionMorph.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAMemoMorph.$(O) Magritte__MAMemoMorph.$(H): Magritte__MAMemoMorph.st $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAElementMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MADescriptionMorph.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MASilentContainerMorph.$(O) Magritte__MASilentContainerMorph.$(H): Magritte__MASilentContainerMorph.st $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAContainerMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MADescriptionMorph.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAMultiSelectListMorph.$(O) Magritte__MAMultiSelectListMorph.$(H): Magritte__MAMultiSelectListMorph.st $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAListMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAElementMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MADescriptionMorph.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MASingleSelectListMorph.$(O) Magritte__MASingleSelectListMorph.$(H): Magritte__MASingleSelectListMorph.st $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAListMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAElementMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MADescriptionMorph.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATextMorph.$(O) Magritte__MATextMorph.$(H): Magritte__MATextMorph.st $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAMemoMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAElementMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MADescriptionMorph.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAPasswordMorph.$(O) Magritte__MAPasswordMorph.$(H): Magritte__MAPasswordMorph.st $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MATextMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAMemoMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MAElementMorph.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\morph\Magritte__MADescriptionMorph.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAContainer.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MABooleanDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAFileDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMemoDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAStringDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMultipleOptionDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAOptionDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReferenceDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAPasswordDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MASingleOptionDescription.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
