# $Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/bc.mak,v 1.20 2014-04-02 10:50:20 vrany Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_browser.
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

LIBNAME=libstx_goodies_refactoryBrowser_browser
RESFILES=browser.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libview2
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
	pushd ..\helpers & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)BrowserDialog.$(O) BrowserDialog.$(H): BrowserDialog.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)BrowserEnvironmentWrapper.$(O) BrowserEnvironmentWrapper.$(H): BrowserEnvironmentWrapper.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)LimitedEnvironment.$(O) LimitedEnvironment.$(H): LimitedEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoryTyper.$(O) RefactoryTyper.$(H): RefactoryTyper.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_refactoryBrowser_browser.$(O) stx_goodies_refactoryBrowser_browser.$(H): stx_goodies_refactoryBrowser_browser.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)AndEnvironment.$(O) AndEnvironment.$(H): AndEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\BrowserEnvironmentWrapper.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CategoryEnvironment.$(O) CategoryEnvironment.$(H): CategoryEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\BrowserEnvironmentWrapper.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ClassEnvironment.$(O) ClassEnvironment.$(H): ClassEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\BrowserEnvironmentWrapper.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)EmptyEnvironment.$(O) EmptyEnvironment.$(H): EmptyEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\BrowserEnvironmentWrapper.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MethodNameDialog.$(O) MethodNameDialog.$(H): MethodNameDialog.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\BrowserDialog.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)NamespaceEnvironment.$(O) NamespaceEnvironment.$(H): NamespaceEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\BrowserEnvironmentWrapper.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)NotEnvironment.$(O) NotEnvironment.$(H): NotEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\BrowserEnvironmentWrapper.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PackageEnvironment.$(O) PackageEnvironment.$(H): PackageEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\BrowserEnvironmentWrapper.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ProtocolEnvironment.$(O) ProtocolEnvironment.$(H): ProtocolEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\BrowserEnvironmentWrapper.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RestrictedEnvironment.$(O) RestrictedEnvironment.$(H): RestrictedEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\LimitedEnvironment.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SelectorEnvironment.$(O) SelectorEnvironment.$(H): SelectorEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\BrowserEnvironmentWrapper.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)VariableEnvironment.$(O) VariableEnvironment.$(H): VariableEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\BrowserEnvironmentWrapper.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MultiEnvironment.$(O) MultiEnvironment.$(H): MultiEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\LimitedEnvironment.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\RestrictedEnvironment.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ParseTreeEnvironment.$(O) ParseTreeEnvironment.$(H): ParseTreeEnvironment.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\LimitedEnvironment.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser\RestrictedEnvironment.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\BrowserEnvironment.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
