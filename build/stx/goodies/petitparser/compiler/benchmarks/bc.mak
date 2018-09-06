# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_compiler_benchmarks.
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
TOP=..\..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_petitparser_compiler_benchmarks
MODULE_PATH=goodies\petitparser\compiler\benchmarks
RESFILES=benchmarks.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\jv\calipel\s -I$(INCLUDE_TOP)\stx\goodies\petitparser -I$(INCLUDE_TOP)\stx\goodies\petitparser\compiler -I$(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras -I$(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java -I$(INCLUDE_TOP)\stx\goodies\petitparser\parsers\smalltalk -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\refactoryBrowser\parser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\.. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\parsers\smalltalk & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)PPCBenchmark.$(O) PPCBenchmark.$(H): PPCBenchmark.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPParser_johanfabry_39.$(O) PPCLRPParser_johanfabry_39.$(H): PPCLRPParser_johanfabry_39.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPCompositeParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCSmalltalkNoopParser.$(O) PPCSmalltalkNoopParser.$(H): PPCSmalltalkNoopParser.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPCompositeParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\smalltalk\PPSmalltalkGrammar.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_petitparser_compiler_benchmarks.$(O) stx_goodies_petitparser_compiler_benchmarks.$(H): stx_goodies_petitparser_compiler_benchmarks.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_petitparser_compiler_benchmarks.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
