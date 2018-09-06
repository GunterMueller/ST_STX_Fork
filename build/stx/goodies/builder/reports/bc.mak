# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_builder_reports.
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

LIBNAME=libstx_goodies_builder_reports
MODULE_PATH=goodies\builder\reports
RESFILES=reports.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint -I$(INCLUDE_TOP)\stx\goodies\sunit -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libcomp
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
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)Builder__Report.$(O) Builder__Report.$(H): Builder__Report.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Builder__ReportFormat.$(O) Builder__ReportFormat.$(H): Builder__ReportFormat.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Builder__ReportRunner.$(O) Builder__ReportRunner.$(H): Builder__ReportRunner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\StandaloneStartup.$(H) $(STCHDR)
$(OUTDIR)Builder__ReportSourceInfo.$(O) Builder__ReportSourceInfo.$(H): Builder__ReportSourceInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_builder_reports.$(O) stx_goodies_builder_reports.$(H): stx_goodies_builder_reports.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)Builder__ChangeReport.$(O) Builder__ChangeReport.$(H): Builder__ChangeReport.st $(INCLUDE_TOP)\stx\goodies\builder\reports\Builder__Report.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Builder__CoverageReport.$(O) Builder__CoverageReport.$(H): Builder__CoverageReport.st $(INCLUDE_TOP)\stx\goodies\builder\reports\Builder__Report.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Builder__CoverageReportFormat.$(O) Builder__CoverageReportFormat.$(H): Builder__CoverageReportFormat.st $(INCLUDE_TOP)\stx\goodies\builder\reports\Builder__ReportFormat.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\Parser.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)Builder__LintReport.$(O) Builder__LintReport.$(H): Builder__LintReport.st $(INCLUDE_TOP)\stx\goodies\builder\reports\Builder__Report.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Builder__LintReportFormat.$(O) Builder__LintReportFormat.$(H): Builder__LintReportFormat.st $(INCLUDE_TOP)\stx\goodies\builder\reports\Builder__ReportFormat.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Builder__ReportClassSourceInfo.$(O) Builder__ReportClassSourceInfo.$(H): Builder__ReportClassSourceInfo.st $(INCLUDE_TOP)\stx\goodies\builder\reports\Builder__ReportSourceInfo.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Builder__ReportExtensionsSourceInfo.$(O) Builder__ReportExtensionsSourceInfo.$(H): Builder__ReportExtensionsSourceInfo.st $(INCLUDE_TOP)\stx\goodies\builder\reports\Builder__ReportSourceInfo.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Builder__TestReport.$(O) Builder__TestReport.$(H): Builder__TestReport.st $(INCLUDE_TOP)\stx\goodies\builder\reports\Builder__Report.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestResult.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Builder__TestReportFormat.$(O) Builder__TestReportFormat.$(H): Builder__TestReportFormat.st $(INCLUDE_TOP)\stx\goodies\builder\reports\Builder__ReportFormat.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_builder_reports.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
