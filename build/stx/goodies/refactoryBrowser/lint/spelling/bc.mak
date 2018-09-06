# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_lint_spelling.
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

LIBNAME=libstx_goodies_refactoryBrowser_lint_spelling
MODULE_PATH=goodies\refactoryBrowser\lint\spelling
RESFILES=stx_goodies_refactoryBrowser_lint_spellingWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\communication -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libcompat
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
	pushd ..\..\helpers & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\parser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\browser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd .. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)RBSpellChecker.$(O) RBSpellChecker.$(C) RBSpellChecker.$(H): RBSpellChecker.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBSpellingRule.$(O) RBSpellingRule.$(C) RBSpellingRule.$(H): RBSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_refactoryBrowser_lint_spelling.$(O) stx_goodies_refactoryBrowser_lint_spelling.$(C) stx_goodies_refactoryBrowser_lint_spelling.$(H): stx_goodies_refactoryBrowser_lint_spelling.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)RBArgumentVariableNamesSpellingRule.$(O) RBArgumentVariableNamesSpellingRule.$(C) RBArgumentVariableNamesSpellingRule.$(H): RBArgumentVariableNamesSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellingRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBClassCategoriesSpellingRule.$(O) RBClassCategoriesSpellingRule.$(C) RBClassCategoriesSpellingRule.$(H): RBClassCategoriesSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellingRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBClassCommentsSpellingRule.$(O) RBClassCommentsSpellingRule.$(C) RBClassCommentsSpellingRule.$(H): RBClassCommentsSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellingRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBClassNamesSpellingRule.$(O) RBClassNamesSpellingRule.$(C) RBClassNamesSpellingRule.$(H): RBClassNamesSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellingRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBClassVariableNamesSpellingRule.$(O) RBClassVariableNamesSpellingRule.$(C) RBClassVariableNamesSpellingRule.$(H): RBClassVariableNamesSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellingRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBInstanceVariableNamesSpellingRule.$(O) RBInstanceVariableNamesSpellingRule.$(C) RBInstanceVariableNamesSpellingRule.$(H): RBInstanceVariableNamesSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellingRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBInternalSpellChecker.$(O) RBInternalSpellChecker.$(C) RBInternalSpellChecker.$(H): RBInternalSpellChecker.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellChecker.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBLiteralValuesSpellingRule.$(O) RBLiteralValuesSpellingRule.$(C) RBLiteralValuesSpellingRule.$(H): RBLiteralValuesSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellingRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBMacSpellChecker.$(O) RBMacSpellChecker.$(C) RBMacSpellChecker.$(H): RBMacSpellChecker.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellChecker.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBMethodCommentsSpellingRule.$(O) RBMethodCommentsSpellingRule.$(C) RBMethodCommentsSpellingRule.$(H): RBMethodCommentsSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellingRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBMethodProtocolsSpellingRule.$(O) RBMethodProtocolsSpellingRule.$(C) RBMethodProtocolsSpellingRule.$(H): RBMethodProtocolsSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellingRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBMethodSelectorsSpellingRule.$(O) RBMethodSelectorsSpellingRule.$(C) RBMethodSelectorsSpellingRule.$(H): RBMethodSelectorsSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellingRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBPoolVariableNamesSpellingRule.$(O) RBPoolVariableNamesSpellingRule.$(C) RBPoolVariableNamesSpellingRule.$(H): RBPoolVariableNamesSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellingRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBTemporaryVariableNamesSpellingRule.$(O) RBTemporaryVariableNamesSpellingRule.$(C) RBTemporaryVariableNamesSpellingRule.$(H): RBTemporaryVariableNamesSpellingRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBasicLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBBlockLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\RBLintRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint\spelling\RBSpellingRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_refactoryBrowser_lint_spelling.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
