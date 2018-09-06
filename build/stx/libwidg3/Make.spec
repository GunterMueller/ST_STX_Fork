# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libwidg3.
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
MODULE_DIR=libwidg3
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
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard -warnUnused

COMMON_CLASSES= \
	AbstractChart \
	ActionWaitBox \
	AnimatedLabel \
	BarChart3DWidget \
	BarChartWidget \
	BarChartWidgetSpec \
	ChartDescription \
	ChartDescriptionSpec \
	ClockView \
	ColorBulletIndicator \
	DigitalClockView \
	DigitalLedDisplay \
	MeterClackCounter \
	MeterClackCounterSpec \
	MeterWidget \
	MeterWidgetSpec \
	PieChartWidget \
	PieChartWidgetSpec \
	RoundProgressIndicator \
	SimpleFunctionGraphView \
	VUMeter \
	stx_libwidg3 \
	BarChart \
	ChartKey \
	PieChart \




COMMON_OBJS= \
    $(OUTDIR_SLASH)AbstractChart.$(O) \
    $(OUTDIR_SLASH)ActionWaitBox.$(O) \
    $(OUTDIR_SLASH)AnimatedLabel.$(O) \
    $(OUTDIR_SLASH)BarChart3DWidget.$(O) \
    $(OUTDIR_SLASH)BarChartWidget.$(O) \
    $(OUTDIR_SLASH)BarChartWidgetSpec.$(O) \
    $(OUTDIR_SLASH)ChartDescription.$(O) \
    $(OUTDIR_SLASH)ChartDescriptionSpec.$(O) \
    $(OUTDIR_SLASH)ClockView.$(O) \
    $(OUTDIR_SLASH)ColorBulletIndicator.$(O) \
    $(OUTDIR_SLASH)DigitalClockView.$(O) \
    $(OUTDIR_SLASH)DigitalLedDisplay.$(O) \
    $(OUTDIR_SLASH)MeterClackCounter.$(O) \
    $(OUTDIR_SLASH)MeterClackCounterSpec.$(O) \
    $(OUTDIR_SLASH)MeterWidget.$(O) \
    $(OUTDIR_SLASH)MeterWidgetSpec.$(O) \
    $(OUTDIR_SLASH)PieChartWidget.$(O) \
    $(OUTDIR_SLASH)PieChartWidgetSpec.$(O) \
    $(OUTDIR_SLASH)RoundProgressIndicator.$(O) \
    $(OUTDIR_SLASH)SimpleFunctionGraphView.$(O) \
    $(OUTDIR_SLASH)VUMeter.$(O) \
    $(OUTDIR_SLASH)stx_libwidg3.$(O) \
    $(OUTDIR_SLASH)BarChart.$(O) \
    $(OUTDIR_SLASH)ChartKey.$(O) \
    $(OUTDIR_SLASH)PieChart.$(O) \



