# $Header: /cvs/stx/stx/goodies/petitparser/devtools/bc.mak,v 1.5 2013-05-28 10:32:04 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_devtools.
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

LIBNAME=libstx_goodies_petitparser_devtools
RESFILES=devtools.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\xml\vw -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic3 -I$(INCLUDE_TOP)\jv\dart\compiler -I$(INCLUDE_TOP)\stx\goodies\petitparser
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all prerequisite packages for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libdb\libodbc & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\jv\dart\compiler & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libdb & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libdb\libsqlite & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd .. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\xml\vw & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\librun & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "






test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)PPDebugger.$(O) PPDebugger.$(H): PPDebugger.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPDebuggingParser.$(O) PPDebuggingParser.$(H): PPDebuggingParser.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XBGFParser.$(O) XBGFParser.$(H): XBGFParser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_petitparser_devtools.$(O) stx_goodies_petitparser_devtools.$(H): stx_goodies_petitparser_devtools.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPActionParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPAndParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPArithmeticParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPCompositeParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPChoiceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPListParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPEndOfInputParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPEpsilonParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPExpressionParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPFailingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPFlattenParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPLambdaParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPLiteralObjectParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPLiteralParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPLiteralSequenceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPMemoizedParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPNotParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPOptionalParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPluggableParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPredicateObjectParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPredicateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPredicateSequenceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPRepeatingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPSequenceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPTokenParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPTrimmingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPUnresolvedParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPWrappingParser.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
