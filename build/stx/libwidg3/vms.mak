#
# DO NOT EDIT
# automatically generated from Make.proto
#
# $Header: /cvs/stx/stx/libwidg3/vms.mak,v 1.2 2016-01-15 19:56:16 cg Exp $
#
TOP=..
LIBNAME=libwidg3
STCOPT="+optspace2 -warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)WoodenBox.$(O) \
  $(OUTDIR)GraniteBox.$(O) \
  $(OUTDIR)WoodenMenu.$(O) \
  $(OUTDIR)ClockView.$(O) \
  $(OUTDIR)ProgressIndicator.$(O) \
  $(OUTDIR)AnimatedLabel.$(O) \
  $(OUTDIR)ActionWaitBox.$(O) \


theLib:: $(LIBNAME).olb
	write sys$output "making class objects ..."
	$(MAKE) objs
	$(MAKE) libinit
	write sys$output "classlibrary $(LIBNAME).olb made."

$(LIBNAME).olb:
	write sys$output "creating initial $(LIBNAME).olb ..."
	lib/cre $(LIBNAME).olb

objs:  $(OBJS1)



# BEGINMAKEDEPEND
$(OUTDIR)ActionWaitBox.$(O) ActionWaitBox.$(H): ActionWaitBox.st $(STCHDR)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)AnimatedLabel.$(O) AnimatedLabel.$(H): AnimatedLabel.st $(STCHDR)  ../include/Label.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)BarChartWidget.$(O) BarChartWidget.$(H): BarChartWidget.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)BarChartWidgetSpec.$(O) BarChartWidgetSpec.$(H): BarChartWidgetSpec.st $(STCHDR)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H)
$(OUTDIR)ChartDescription.$(O) ChartDescription.$(H): ChartDescription.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)ChartDescriptionSpec.$(O) ChartDescriptionSpec.$(H): ChartDescriptionSpec.st $(STCHDR)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H)
$(OUTDIR)ClockView.$(O) ClockView.$(H): ClockView.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)ColorBulletIndicator.$(O) ColorBulletIndicator.$(H): ColorBulletIndicator.st $(STCHDR)
$(OUTDIR)DigitalClockView.$(O) DigitalClockView.$(H): DigitalClockView.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)DigitalLedDisplay.$(O) DigitalLedDisplay.$(H): DigitalLedDisplay.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)GraniteBox.$(O) GraniteBox.$(H): GraniteBox.st $(STCHDR)  ../include/WoodenBox.$(H)  ../include/ObjectView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)MeterClackCounter.$(O) MeterClackCounter.$(H): MeterClackCounter.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)MeterClackCounterSpec.$(O) MeterClackCounterSpec.$(H): MeterClackCounterSpec.st $(STCHDR)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H)
$(OUTDIR)MeterWidget.$(O) MeterWidget.$(H): MeterWidget.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)MeterWidgetSpec.$(O) MeterWidgetSpec.$(H): MeterWidgetSpec.st $(STCHDR)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H)
$(OUTDIR)PieChartWidget.$(O) PieChartWidget.$(H): PieChartWidget.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)PieChartWidgetSpec.$(O) PieChartWidgetSpec.$(H): PieChartWidgetSpec.st $(STCHDR)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H)
$(OUTDIR)ProgressIndicator.$(O) ProgressIndicator.$(H): ProgressIndicator.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)RoundProgressIndicator.$(O) RoundProgressIndicator.$(H): RoundProgressIndicator.st $(STCHDR)  ../include/ProgressIndicator.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)SimpleFunctionGraphView.$(O) SimpleFunctionGraphView.$(H): SimpleFunctionGraphView.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)WoodenBox.$(O) WoodenBox.$(H): WoodenBox.st $(STCHDR)  ../include/ObjectView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
$(OUTDIR)WoodenMenu.$(O) WoodenMenu.$(H): WoodenMenu.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)
# ENDMAKEDEPEND
