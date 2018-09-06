# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_islands.
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

LIBNAME=libstx_goodies_petitparser_islands
MODULE_PATH=goodies\petitparser\islands
RESFILES=islands.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\petitparser -I$(INCLUDE_TOP)\stx\goodies\petitparser\analyzer -I$(INCLUDE_TOP)\stx\libbasic
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
	pushd .. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)PPInputEnds.$(O) PPInputEnds.$(H): PPInputEnds.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPIsland.$(O) PPIsland.$(H): PPIsland.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPNonEmptyParser.$(O) PPNonEmptyParser.$(H): PPNonEmptyParser.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPWater.$(O) PPWater.$(H): PPWater.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_petitparser_islands.$(O) stx_goodies_petitparser_islands.$(H): stx_goodies_petitparser_islands.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)PPMemoizingIsland.$(O) PPMemoizingIsland.$(H): PPMemoizingIsland.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\islands\PPIsland.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPChoiceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPContext.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPEpsilonParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPListParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPLiteralParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPOptionalParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPredicateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPRepeatingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPSequenceParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_petitparser_islands.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
