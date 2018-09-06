# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_libcairo.
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

LIBNAME=libstx_goodies_libcairo
MODULE_PATH=goodies\libcairo
RESFILES=stx_goodies_libcairoWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg
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







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)Cairo__Antialias.$(O) Cairo__Antialias.$(C) Cairo__Antialias.$(H): Cairo__Antialias.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__CError.$(O) Cairo__CError.$(C) Cairo__CError.$(H): Cairo__CError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__CPrimitives.$(O) Cairo__CPrimitives.$(C) Cairo__CPrimitives.$(H): Cairo__CPrimitives.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__CStructure.$(O) Cairo__CStructure.$(C) Cairo__CStructure.$(H): Cairo__CStructure.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)Cairo__ClockView.$(O) Cairo__ClockView.$(C) Cairo__ClockView.$(H): Cairo__ClockView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)Cairo__Content.$(O) Cairo__Content.$(C) Cairo__Content.$(H): Cairo__Content.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__Device.$(O) Cairo__Device.$(C) Cairo__Device.$(H): Cairo__Device.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__DeviceType.$(O) Cairo__DeviceType.$(C) Cairo__DeviceType.$(H): Cairo__DeviceType.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__Extend.$(O) Cairo__Extend.$(C) Cairo__Extend.$(H): Cairo__Extend.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__FillRule.$(O) Cairo__FillRule.$(C) Cairo__FillRule.$(H): Cairo__FillRule.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__Filter.$(O) Cairo__Filter.$(C) Cairo__Filter.$(H): Cairo__Filter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__FontSlant.$(O) Cairo__FontSlant.$(C) Cairo__FontSlant.$(H): Cairo__FontSlant.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__FontType.$(O) Cairo__FontType.$(C) Cairo__FontType.$(H): Cairo__FontType.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__FontWeight.$(O) Cairo__FontWeight.$(C) Cairo__FontWeight.$(H): Cairo__FontWeight.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__Format.$(O) Cairo__Format.$(C) Cairo__Format.$(H): Cairo__Format.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__HintMetrics.$(O) Cairo__HintMetrics.$(C) Cairo__HintMetrics.$(H): Cairo__HintMetrics.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__HintStyle.$(O) Cairo__HintStyle.$(C) Cairo__HintStyle.$(H): Cairo__HintStyle.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__LineCap.$(O) Cairo__LineCap.$(C) Cairo__LineCap.$(H): Cairo__LineCap.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__LineJoin.$(O) Cairo__LineJoin.$(C) Cairo__LineJoin.$(H): Cairo__LineJoin.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__Operator.$(O) Cairo__Operator.$(C) Cairo__Operator.$(H): Cairo__Operator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__Path.$(O) Cairo__Path.$(C) Cairo__Path.$(H): Cairo__Path.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)Cairo__PathData.$(O) Cairo__PathData.$(C) Cairo__PathData.$(H): Cairo__PathData.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)Cairo__PathDataType.$(O) Cairo__PathDataType.$(C) Cairo__PathDataType.$(H): Cairo__PathDataType.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__PatternType.$(O) Cairo__PatternType.$(C) Cairo__PatternType.$(H): Cairo__PatternType.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__PdfVersion.$(O) Cairo__PdfVersion.$(C) Cairo__PdfVersion.$(H): Cairo__PdfVersion.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__RectangleInt.$(O) Cairo__RectangleInt.$(C) Cairo__RectangleInt.$(H): Cairo__RectangleInt.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__RectangleList.$(O) Cairo__RectangleList.$(C) Cairo__RectangleList.$(H): Cairo__RectangleList.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)Cairo__Region.$(O) Cairo__Region.$(C) Cairo__Region.$(H): Cairo__Region.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__RegionOverlap.$(O) Cairo__RegionOverlap.$(C) Cairo__RegionOverlap.$(H): Cairo__RegionOverlap.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__Status.$(O) Cairo__Status.$(C) Cairo__Status.$(H): Cairo__Status.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__SubpixelOrder.$(O) Cairo__SubpixelOrder.$(C) Cairo__SubpixelOrder.$(H): Cairo__SubpixelOrder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__SurfaceObserverMode.$(O) Cairo__SurfaceObserverMode.$(C) Cairo__SurfaceObserverMode.$(H): Cairo__SurfaceObserverMode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__SurfaceType.$(O) Cairo__SurfaceType.$(C) Cairo__SurfaceType.$(H): Cairo__SurfaceType.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__TextCluster.$(O) Cairo__TextCluster.$(C) Cairo__TextCluster.$(H): Cairo__TextCluster.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__TextClusterFlags.$(O) Cairo__TextClusterFlags.$(C) Cairo__TextClusterFlags.$(H): Cairo__TextClusterFlags.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cairo__TextExampleView.$(O) Cairo__TextExampleView.$(C) Cairo__TextExampleView.$(H): Cairo__TextExampleView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)Cairo__UserDataKey.$(O) Cairo__UserDataKey.$(C) Cairo__UserDataKey.$(H): Cairo__UserDataKey.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)CairoGraphicsContextHandle.$(O) CairoGraphicsContextHandle.$(C) CairoGraphicsContextHandle.$(H): CairoGraphicsContextHandle.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceHandle.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_libcairo.$(O) stx_goodies_libcairo.$(C) stx_goodies_libcairo.$(H): stx_goodies_libcairo.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)Cairo__CObject.$(O) Cairo__CObject.$(C) Cairo__CObject.$(H): Cairo__CObject.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Status.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__FontExtents.$(O) Cairo__FontExtents.$(C) Cairo__FontExtents.$(H): Cairo__FontExtents.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)Cairo__Glyph.$(O) Cairo__Glyph.$(C) Cairo__Glyph.$(H): Cairo__Glyph.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)Cairo__Matrix.$(O) Cairo__Matrix.$(C) Cairo__Matrix.$(H): Cairo__Matrix.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)Cairo__Rectangle.$(O) Cairo__Rectangle.$(C) Cairo__Rectangle.$(H): Cairo__Rectangle.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)Cairo__TextExtents.$(O) Cairo__TextExtents.$(C) Cairo__TextExtents.$(H): Cairo__TextExtents.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)CairoGraphicsContext.$(O) CairoGraphicsContext.$(C) CairoGraphicsContext.$(H): CairoGraphicsContext.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Antialias.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Extend.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__FontSlant.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__FontWeight.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Format.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Status.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(STCHDR)
$(OUTDIR)CairoScaledFont.$(O) CairoScaledFont.$(C) CairoScaledFont.$(H): CairoScaledFont.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__FontSlant.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__FontWeight.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Format.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\FontDescription.$(H) $(STCHDR)
$(OUTDIR)Cairo__FontFace.$(O) Cairo__FontFace.$(C) Cairo__FontFace.$(H): Cairo__FontFace.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__FontOptions.$(O) Cairo__FontOptions.$(C) Cairo__FontOptions.$(H): Cairo__FontOptions.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__GraphicsContext.$(O) Cairo__GraphicsContext.$(C) Cairo__GraphicsContext.$(H): Cairo__GraphicsContext.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__Pattern.$(O) Cairo__Pattern.$(C) Cairo__Pattern.$(H): Cairo__Pattern.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__PatternType.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__ScaledFont.$(O) Cairo__ScaledFont.$(C) Cairo__ScaledFont.$(H): Cairo__ScaledFont.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__Surface.$(O) Cairo__Surface.$(C) Cairo__Surface.$(H): Cairo__Surface.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Format.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__SurfaceType.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__PatternGradient.$(O) Cairo__PatternGradient.$(C) Cairo__PatternGradient.$(H): Cairo__PatternGradient.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Pattern.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Status.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__PatternSolid.$(O) Cairo__PatternSolid.$(C) Cairo__PatternSolid.$(H): Cairo__PatternSolid.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__PatternSurface.$(O) Cairo__PatternSurface.$(C) Cairo__PatternSurface.$(H): Cairo__PatternSurface.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__SurfaceImage.$(O) Cairo__SurfaceImage.$(C) Cairo__SurfaceImage.$(H): Cairo__SurfaceImage.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Surface.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__SurfacePDF.$(O) Cairo__SurfacePDF.$(C) Cairo__SurfacePDF.$(H): Cairo__SurfacePDF.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Surface.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__SurfaceWin32.$(O) Cairo__SurfaceWin32.$(C) Cairo__SurfaceWin32.$(H): Cairo__SurfaceWin32.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Format.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Surface.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__SurfaceType.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__SurfaceXlib.$(O) Cairo__SurfaceXlib.$(C) Cairo__SurfaceXlib.$(H): Cairo__SurfaceXlib.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Format.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Surface.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__SurfaceType.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__PatternGradientLinear.$(O) Cairo__PatternGradientLinear.$(C) Cairo__PatternGradientLinear.$(H): Cairo__PatternGradientLinear.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Pattern.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__PatternGradient.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__PatternGradientRadial.$(O) Cairo__PatternGradientRadial.$(C) Cairo__PatternGradientRadial.$(H): Cairo__PatternGradientRadial.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__CObject.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__Pattern.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__PatternGradient.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Depth1Image.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsDevice.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_libcairo.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
