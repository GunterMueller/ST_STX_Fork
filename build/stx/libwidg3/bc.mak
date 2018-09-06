# $Header: /cvs/stx/stx/libwidg3/bc.mak,v 1.51 2016-06-09 18:17:06 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libwidg3.
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


# see stdHeader_bc for LIBWIDG3_BASE
LIB_BASE=$(LIBWIDG3_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libwidg3
MODULE_PATH=libwidg3
RESFILES=libwidg3.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libui -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg -I$(INCLUDE_TOP)\stx\libwidg2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)

clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)AbstractChart.$(O) AbstractChart.$(H): AbstractChart.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ActionWaitBox.$(O) ActionWaitBox.$(H): ActionWaitBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(STCHDR)
$(OUTDIR)AnimatedLabel.$(O) AnimatedLabel.$(H): AnimatedLabel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Label.$(H) $(STCHDR)
$(OUTDIR)BarChart3DWidget.$(O) BarChart3DWidget.$(H): BarChart3DWidget.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libwidg\ObjectView.$(H) $(STCHDR)
$(OUTDIR)BarChartWidget.$(O) BarChartWidget.$(H): BarChartWidget.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)BarChartWidgetSpec.$(O) BarChartWidgetSpec.$(H): BarChartWidgetSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)ChartDescription.$(O) ChartDescription.$(H): ChartDescription.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)ChartDescriptionSpec.$(O) ChartDescriptionSpec.$(H): ChartDescriptionSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)ClockView.$(O) ClockView.$(H): ClockView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)ColorBulletIndicator.$(O) ColorBulletIndicator.$(H): ColorBulletIndicator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg2\ImageView.$(H) $(STCHDR)
$(OUTDIR)DigitalClockView.$(O) DigitalClockView.$(H): DigitalClockView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)DigitalLedDisplay.$(O) DigitalLedDisplay.$(H): DigitalLedDisplay.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)MeterClackCounter.$(O) MeterClackCounter.$(H): MeterClackCounter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)MeterClackCounterSpec.$(O) MeterClackCounterSpec.$(H): MeterClackCounterSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)MeterWidget.$(O) MeterWidget.$(H): MeterWidget.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)MeterWidgetSpec.$(O) MeterWidgetSpec.$(H): MeterWidgetSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)PieChartWidget.$(O) PieChartWidget.$(H): PieChartWidget.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)PieChartWidgetSpec.$(O) PieChartWidgetSpec.$(H): PieChartWidgetSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)RoundProgressIndicator.$(O) RoundProgressIndicator.$(H): RoundProgressIndicator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg2\ProgressIndicator.$(H) $(STCHDR)
$(OUTDIR)SimpleFunctionGraphView.$(O) SimpleFunctionGraphView.$(H): SimpleFunctionGraphView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)VUMeter.$(O) VUMeter.$(H): VUMeter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)stx_libwidg3.$(O) stx_libwidg3.$(H): stx_libwidg3.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)BarChart.$(O) BarChart.$(H): BarChart.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg3\AbstractChart.$(H) $(STCHDR)
$(OUTDIR)ChartKey.$(O) ChartKey.$(H): ChartKey.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg3\AbstractChart.$(H) $(STCHDR)
$(OUTDIR)PieChart.$(O) PieChart.$(H): PieChart.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg3\AbstractChart.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
