# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_analyzer.
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

LIBNAME=libstx_goodies_petitparser_analyzer
MODULE_PATH=goodies\petitparser\analyzer
RESFILES=analyzer.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\petitparser -I$(INCLUDE_TOP)\stx\libbasic
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
$(OUTDIR)PPPattern.$(O) PPPattern.$(H): PPPattern.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPProcessor.$(O) PPProcessor.$(H): PPProcessor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPRule.$(O) PPRule.$(H): PPRule.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPSentinel.$(O) PPSentinel.$(H): PPSentinel.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPEpsilonParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_petitparser_analyzer.$(O) stx_goodies_petitparser_analyzer.$(H): stx_goodies_petitparser_analyzer.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)PPListPattern.$(O) PPListPattern.$(H): PPListPattern.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\analyzer\PPPattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPReplaceRule.$(O) PPReplaceRule.$(H): PPReplaceRule.st $(INCLUDE_TOP)\stx\goodies\petitparser\analyzer\PPRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPRewriter.$(O) PPRewriter.$(H): PPRewriter.st $(INCLUDE_TOP)\stx\goodies\petitparser\analyzer\PPProcessor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPSearchRule.$(O) PPSearchRule.$(H): PPSearchRule.st $(INCLUDE_TOP)\stx\goodies\petitparser\analyzer\PPRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPSearcher.$(O) PPSearcher.$(H): PPSearcher.st $(INCLUDE_TOP)\stx\goodies\petitparser\analyzer\PPProcessor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPBlockReplaceRule.$(O) PPBlockReplaceRule.$(H): PPBlockReplaceRule.st $(INCLUDE_TOP)\stx\goodies\petitparser\analyzer\PPReplaceRule.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\analyzer\PPRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPParserReplaceRule.$(O) PPParserReplaceRule.$(H): PPParserReplaceRule.st $(INCLUDE_TOP)\stx\goodies\petitparser\analyzer\PPReplaceRule.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\analyzer\PPRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPActionParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPEpsilonParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPFailingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPFlattenParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPLimitedRepeatingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPListParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPLiteralParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPNotParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPOptionalParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPluggableParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPredicateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPredicateSequenceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPRepeatingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPSequenceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPTokenParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_petitparser_analyzer.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
