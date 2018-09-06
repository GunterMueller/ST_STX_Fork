# $Header: /cvs/stx/stx/goodies/communication/webdriver/bc.mak,v 1.3 2018-06-21 16:52:05 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_webdriver.
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

LIBNAME=libstx_goodies_communication_webdriver
MODULE_PATH=goodies\communication\webdriver
RESFILES=stx_goodies_communication_webdriverWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\webdriver -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libview
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
$(OUTDIR)WDException.$(O) WDException.$(C) WDException.$(H): WDException.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDHttpResponse.$(O) WDHttpResponse.$(C) WDHttpResponse.$(H): WDHttpResponse.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDServerObject.$(O) WDServerObject.$(C) WDServerObject.$(H): WDServerObject.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDSmalltalkPlatform.$(O) WDSmalltalkPlatform.$(C) WDSmalltalkPlatform.$(H): WDSmalltalkPlatform.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDWebDriver.$(O) WDWebDriver.$(C) WDWebDriver.$(H): WDWebDriver.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_communication_webdriver.$(O) stx_goodies_communication_webdriver.$(C) stx_goodies_communication_webdriver.$(H): stx_goodies_communication_webdriver.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)WDCapabilities.$(O) WDCapabilities.$(C) WDCapabilities.$(H): WDCapabilities.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDServerObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDChromeDriver.$(O) WDChromeDriver.$(C) WDChromeDriver.$(H): WDChromeDriver.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDWebDriver.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDCookie.$(O) WDCookie.$(C) WDCookie.$(H): WDCookie.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDServerObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDDriverNotAvailableException.$(O) WDDriverNotAvailableException.$(C) WDDriverNotAvailableException.$(H): WDDriverNotAvailableException.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDException.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDNoSuchElementException.$(O) WDNoSuchElementException.$(C) WDNoSuchElementException.$(H): WDNoSuchElementException.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDException.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDPharoPlatform.$(O) WDPharoPlatform.$(C) WDPharoPlatform.$(H): WDPharoPlatform.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDSmalltalkPlatform.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDServerBuild.$(O) WDServerBuild.$(C) WDServerBuild.$(H): WDServerBuild.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDServerObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDServerPlatform.$(O) WDServerPlatform.$(C) WDServerPlatform.$(H): WDServerPlatform.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDServerObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDServerStatus.$(O) WDServerStatus.$(C) WDServerStatus.$(H): WDServerStatus.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDServerObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDSession.$(O) WDSession.$(C) WDSession.$(H): WDSession.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDServerObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDSmalltalkXPlatform.$(O) WDSmalltalkXPlatform.$(C) WDSmalltalkXPlatform.$(H): WDSmalltalkXPlatform.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDSmalltalkPlatform.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDStaleElementReferenceException.$(O) WDStaleElementReferenceException.$(C) WDStaleElementReferenceException.$(H): WDStaleElementReferenceException.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDException.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDStatusNotAvailableException.$(O) WDStatusNotAvailableException.$(C) WDStatusNotAvailableException.$(H): WDStatusNotAvailableException.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDException.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDUnsupportedCommandException.$(O) WDUnsupportedCommandException.$(C) WDUnsupportedCommandException.$(H): WDUnsupportedCommandException.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDException.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WDDesiredCapabilities.$(O) WDDesiredCapabilities.$(C) WDDesiredCapabilities.$(H): WDDesiredCapabilities.st $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDCapabilities.$(H) $(INCLUDE_TOP)\stx\goodies\communication\webdriver\WDServerObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
