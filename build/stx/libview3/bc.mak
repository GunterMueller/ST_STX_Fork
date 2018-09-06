# $Header: /cvs/stx/stx/libview3/bc.mak,v 1.13 2016-06-09 18:16:41 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libview3.
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
TOP=..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libview3
RESFILES=libview3.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libui -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libview
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all prerequisite packages for this package
prereq:
	pushd ..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "





clean::
	-del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)DisplayObjectComponentSpec.$(O) DisplayObjectComponentSpec.$(H): DisplayObjectComponentSpec.st $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Morph.$(O) Morph.$(H): Morph.st $(INCLUDE_TOP)\stx\libview2\VisualPart.$(H) $(INCLUDE_TOP)\stx\libview2\VisualComponent.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libview3.$(O) stx_libview3.$(H): stx_libview3.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ArcMorph.$(O) ArcMorph.$(H): ArcMorph.st $(INCLUDE_TOP)\stx\libview3\Morph.$(H) $(INCLUDE_TOP)\stx\libview2\VisualPart.$(H) $(INCLUDE_TOP)\stx\libview2\VisualComponent.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ArcMorphSpec.$(O) ArcMorphSpec.$(H): ArcMorphSpec.st $(INCLUDE_TOP)\stx\libview3\DisplayObjectComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)LineSegmentMorph.$(O) LineSegmentMorph.$(H): LineSegmentMorph.st $(INCLUDE_TOP)\stx\libview3\Morph.$(H) $(INCLUDE_TOP)\stx\libview2\VisualPart.$(H) $(INCLUDE_TOP)\stx\libview2\VisualComponent.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)LineSegmentMorphSpec.$(O) LineSegmentMorphSpec.$(H): LineSegmentMorphSpec.st $(INCLUDE_TOP)\stx\libview3\DisplayObjectComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RectangleMorph.$(O) RectangleMorph.$(H): RectangleMorph.st $(INCLUDE_TOP)\stx\libview3\Morph.$(H) $(INCLUDE_TOP)\stx\libview2\VisualPart.$(H) $(INCLUDE_TOP)\stx\libview2\VisualComponent.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RectangleMorphSpec.$(O) RectangleMorphSpec.$(H): RectangleMorphSpec.st $(INCLUDE_TOP)\stx\libview3\DisplayObjectComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SketchMorph.$(O) SketchMorph.$(H): SketchMorph.st $(INCLUDE_TOP)\stx\libview3\Morph.$(H) $(INCLUDE_TOP)\stx\libview2\VisualPart.$(H) $(INCLUDE_TOP)\stx\libview2\VisualComponent.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SketchMorphSpec.$(O) SketchMorphSpec.$(H): SketchMorphSpec.st $(INCLUDE_TOP)\stx\libview3\DisplayObjectComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
