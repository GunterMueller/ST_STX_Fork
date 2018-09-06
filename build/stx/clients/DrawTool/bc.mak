# $Header: /cvs/stx/stx/clients/DrawTool/bc.mak,v 1.8 2013-04-26 07:39:19 stefan Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_clients_DrawTool.
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
TOP=..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_clients_DrawTool
RESFILES=DrawTool.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg -I$(INCLUDE_TOP)\stx\libview
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "






clean::
	del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)DrawObject.$(O) DrawObject.$(H): DrawObject.st $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawTool.$(O) DrawTool.$(H): DrawTool.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawView.$(O) DrawView.$(H): DrawView.st $(INCLUDE_TOP)\stx\libwidg\ObjectView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PatternMenu.$(O) PatternMenu.$(H): PatternMenu.st $(INCLUDE_TOP)\stx\libwidg\MenuView.$(H) $(INCLUDE_TOP)\stx\libwidg\SelectionInListView.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_clients_DrawTool.$(O) stx_clients_DrawTool.$(H): stx_clients_DrawTool.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawEllipse.$(O) DrawEllipse.$(H): DrawEllipse.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawGroup.$(O) DrawGroup.$(H): DrawGroup.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawLine.$(O) DrawLine.$(H): DrawLine.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawPolygon.$(O) DrawPolygon.$(H): DrawPolygon.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawRectangle.$(O) DrawRectangle.$(H): DrawRectangle.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawText.$(O) DrawText.$(H): DrawText.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)LineMenu.$(O) LineMenu.$(H): LineMenu.st $(INCLUDE_TOP)\stx\clients\DrawTool\PatternMenu.$(H) $(INCLUDE_TOP)\stx\libwidg\MenuView.$(H) $(INCLUDE_TOP)\stx\libwidg\SelectionInListView.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RectangularDrawObject.$(O) RectangularDrawObject.$(H): RectangularDrawObject.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawArrow.$(O) DrawArrow.$(H): DrawArrow.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawLine.$(H) $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawCircle.$(O) DrawCircle.$(H): DrawCircle.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawEllipse.$(H) $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawCurve.$(O) DrawCurve.$(H): DrawCurve.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawPolygon.$(H) $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawHLine.$(O) DrawHLine.$(H): DrawHLine.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawLine.$(H) $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawImage.$(O) DrawImage.$(H): DrawImage.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawRectangle.$(H) $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawRectangle3D.$(O) DrawRectangle3D.$(H): DrawRectangle3D.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawRectangle.$(H) $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawRoundRectangle.$(O) DrawRoundRectangle.$(H): DrawRoundRectangle.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawRectangle.$(H) $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawSpline.$(O) DrawSpline.$(H): DrawSpline.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawPolygon.$(H) $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawVLine.$(O) DrawVLine.$(H): DrawVLine.st $(INCLUDE_TOP)\stx\clients\DrawTool\DrawLine.$(H) $(INCLUDE_TOP)\stx\clients\DrawTool\DrawObject.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
