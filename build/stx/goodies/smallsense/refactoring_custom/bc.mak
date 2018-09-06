# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_smallsense_refactoring_custom.
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

LIBNAME=libstx_goodies_smallsense_refactoring_custom
MODULE_PATH=goodies\smallsense\refactoring_custom
RESFILES=stx_goodies_smallsense_refactoring_customWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser -I$(INCLUDE_TOP)\stx\goodies\sunit -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libcomp -I$(INCLUDE_TOP)\stx\libjava -I$(INCLUDE_TOP)\stx\libjava\tools -I$(INCLUDE_TOP)\stx\libjavascript -I$(INCLUDE_TOP)\stx\libtool -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg -I$(INCLUDE_TOP)\stx\libwidg2
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
	pushd ..\..\refactoryBrowser\changes & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\refactoryBrowser\helpers & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\refactoryBrowser\parser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libtool & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)SmallSense__CustomChangeManager.$(O) SmallSense__CustomChangeManager.$(C) SmallSense__CustomChangeManager.$(H): SmallSense__CustomChangeManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomClassQuery.$(O) SmallSense__CustomClassQuery.$(C) SmallSense__CustomClassQuery.$(H): SmallSense__CustomClassQuery.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomCodeGeneratorOrRefactoring.$(O) SmallSense__CustomCodeGeneratorOrRefactoring.$(C) SmallSense__CustomCodeGeneratorOrRefactoring.$(H): SmallSense__CustomCodeGeneratorOrRefactoring.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomContext.$(O) SmallSense__CustomContext.$(C) SmallSense__CustomContext.$(H): SmallSense__CustomContext.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomDialog.$(O) SmallSense__CustomDialog.$(C) SmallSense__CustomDialog.$(H): SmallSense__CustomDialog.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomManager.$(O) SmallSense__CustomManager.$(C) SmallSense__CustomManager.$(H): SmallSense__CustomManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomMenuBuilder.$(O) SmallSense__CustomMenuBuilder.$(C) SmallSense__CustomMenuBuilder.$(H): SmallSense__CustomMenuBuilder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomMock.$(O) SmallSense__CustomMock.$(C) SmallSense__CustomMock.$(H): SmallSense__CustomMock.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomNamespace.$(O) SmallSense__CustomNamespace.$(C) SmallSense__CustomNamespace.$(H): SmallSense__CustomNamespace.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\RBNamespace.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomParseTreeRewriter.$(O) SmallSense__CustomParseTreeRewriter.$(C) SmallSense__CustomParseTreeRewriter.$(H): SmallSense__CustomParseTreeRewriter.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\ParseTreeRewriter.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\ParseTreeSearcher.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\ParseTreeSourceRewriter.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNodeVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomPerspective.$(O) SmallSense__CustomPerspective.$(C) SmallSense__CustomPerspective.$(H): SmallSense__CustomPerspective.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomRefactoryBuilder.$(O) SmallSense__CustomRefactoryBuilder.$(C) SmallSense__CustomRefactoryBuilder.$(H): SmallSense__CustomRefactoryBuilder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomSourceCodeFormatter.$(O) SmallSense__CustomSourceCodeFormatter.$(C) SmallSense__CustomSourceCodeFormatter.$(H): SmallSense__CustomSourceCodeFormatter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomSourceCodeGenerator.$(O) SmallSense__CustomSourceCodeGenerator.$(C) SmallSense__CustomSourceCodeGenerator.$(H): SmallSense__CustomSourceCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNodeVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\CodeGenerator.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomSourceCodeSelection.$(O) SmallSense__CustomSourceCodeSelection.$(C) SmallSense__CustomSourceCodeSelection.$(H): SmallSense__CustomSourceCodeSelection.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomTestCaseHelper.$(O) SmallSense__CustomTestCaseHelper.$(C) SmallSense__CustomTestCaseHelper.$(H): SmallSense__CustomTestCaseHelper.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_smallsense_refactoring_custom.$(O) stx_goodies_smallsense_refactoring_custom.$(C) stx_goodies_smallsense_refactoring_custom.$(H): stx_goodies_smallsense_refactoring_custom.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomBrowserChangeManager.$(O) SmallSense__CustomBrowserChangeManager.$(C) SmallSense__CustomBrowserChangeManager.$(H): SmallSense__CustomBrowserChangeManager.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomChangeManager.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomBrowserContext.$(O) SmallSense__CustomBrowserContext.$(C) SmallSense__CustomBrowserContext.$(H): SmallSense__CustomBrowserContext.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomContext.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomCodeGenerator.$(O) SmallSense__CustomCodeGenerator.$(C) SmallSense__CustomCodeGenerator.$(H): SmallSense__CustomCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomLocalChangeManager.$(O) SmallSense__CustomLocalChangeManager.$(C) SmallSense__CustomLocalChangeManager.$(H): SmallSense__CustomLocalChangeManager.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomChangeManager.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomNoneSourceCodeFormatter.$(O) SmallSense__CustomNoneSourceCodeFormatter.$(C) SmallSense__CustomNoneSourceCodeFormatter.$(H): SmallSense__CustomNoneSourceCodeFormatter.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomSourceCodeFormatter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomRBLocalSourceCodeFormatter.$(O) SmallSense__CustomRBLocalSourceCodeFormatter.$(C) SmallSense__CustomRBLocalSourceCodeFormatter.$(H): SmallSense__CustomRBLocalSourceCodeFormatter.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomSourceCodeFormatter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomRefactoring.$(O) SmallSense__CustomRefactoring.$(C) SmallSense__CustomRefactoring.$(H): SmallSense__CustomRefactoring.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomSilentDialog.$(O) SmallSense__CustomSilentDialog.$(C) SmallSense__CustomSilentDialog.$(H): SmallSense__CustomSilentDialog.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomDialog.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomSubContext.$(O) SmallSense__CustomSubContext.$(C) SmallSense__CustomSubContext.$(H): SmallSense__CustomSubContext.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomContext.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomUserDialog.$(O) SmallSense__CustomUserDialog.$(C) SmallSense__CustomUserDialog.$(H): SmallSense__CustomUserDialog.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomDialog.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomAccessMethodsCodeGenerator.$(O) SmallSense__CustomAccessMethodsCodeGenerator.$(C) SmallSense__CustomAccessMethodsCodeGenerator.$(H): SmallSense__CustomAccessMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomCodeSelectionRefactoring.$(O) SmallSense__CustomCodeSelectionRefactoring.$(C) SmallSense__CustomCodeSelectionRefactoring.$(H): SmallSense__CustomCodeSelectionRefactoring.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomInspectorTabCodeGenerator.$(O) SmallSense__CustomInspectorTabCodeGenerator.$(C) SmallSense__CustomInspectorTabCodeGenerator.$(H): SmallSense__CustomInspectorTabCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomIsAbstractCodeGenerator.$(O) SmallSense__CustomIsAbstractCodeGenerator.$(C) SmallSense__CustomIsAbstractCodeGenerator.$(H): SmallSense__CustomIsAbstractCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomJavaSimpleSetterMethodsCodeGenerator.$(O) SmallSense__CustomJavaSimpleSetterMethodsCodeGenerator.$(C) SmallSense__CustomJavaSimpleSetterMethodsCodeGenerator.$(H): SmallSense__CustomJavaSimpleSetterMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomNewClassGenerator.$(O) SmallSense__CustomNewClassGenerator.$(C) SmallSense__CustomNewClassGenerator.$(H): SmallSense__CustomNewClassGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomReplaceIfNilWithIfTrueRefactoring.$(O) SmallSense__CustomReplaceIfNilWithIfTrueRefactoring.$(C) SmallSense__CustomReplaceIfNilWithIfTrueRefactoring.$(H): SmallSense__CustomReplaceIfNilWithIfTrueRefactoring.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomSubclassResponsibilityCodeGenerator.$(O) SmallSense__CustomSubclassResponsibilityCodeGenerator.$(C) SmallSense__CustomSubclassResponsibilityCodeGenerator.$(H): SmallSense__CustomSubclassResponsibilityCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomTestCaseCodeGenerator.$(O) SmallSense__CustomTestCaseCodeGenerator.$(C) SmallSense__CustomTestCaseCodeGenerator.$(H): SmallSense__CustomTestCaseCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomTestCaseMethodCodeGenerator.$(O) SmallSense__CustomTestCaseMethodCodeGenerator.$(C) SmallSense__CustomTestCaseMethodCodeGenerator.$(H): SmallSense__CustomTestCaseMethodCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomTestCaseSetUpCodeGenerator.$(O) SmallSense__CustomTestCaseSetUpCodeGenerator.$(C) SmallSense__CustomTestCaseSetUpCodeGenerator.$(H): SmallSense__CustomTestCaseSetUpCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomTestCaseTearDownCodeGenerator.$(O) SmallSense__CustomTestCaseTearDownCodeGenerator.$(C) SmallSense__CustomTestCaseTearDownCodeGenerator.$(H): SmallSense__CustomTestCaseTearDownCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomUpdateTestCaseCategoryRefactoring.$(O) SmallSense__CustomUpdateTestCaseCategoryRefactoring.$(C) SmallSense__CustomUpdateTestCaseCategoryRefactoring.$(H): SmallSense__CustomUpdateTestCaseCategoryRefactoring.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomVisitorCodeGenerator.$(O) SmallSense__CustomVisitorCodeGenerator.$(C) SmallSense__CustomVisitorCodeGenerator.$(H): SmallSense__CustomVisitorCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomChangeNotificationAccessMethodsCodeGenerator.$(O) SmallSense__CustomChangeNotificationAccessMethodsCodeGenerator.$(C) SmallSense__CustomChangeNotificationAccessMethodsCodeGenerator.$(H): SmallSense__CustomChangeNotificationAccessMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomChangeNotificationSetterMethodsCodeGenerator.$(O) SmallSense__CustomChangeNotificationSetterMethodsCodeGenerator.$(C) SmallSense__CustomChangeNotificationSetterMethodsCodeGenerator.$(H): SmallSense__CustomChangeNotificationSetterMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomCodeGeneratorClassGenerator.$(O) SmallSense__CustomCodeGeneratorClassGenerator.$(C) SmallSense__CustomCodeGeneratorClassGenerator.$(H): SmallSense__CustomCodeGeneratorClassGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomNewClassGenerator.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator.$(O) SmallSense__CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator.$(C) SmallSense__CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator.$(H): SmallSense__CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomTestCaseCodeGenerator.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomCodeSelectionToResourceTranslation.$(O) SmallSense__CustomCodeSelectionToResourceTranslation.$(C) SmallSense__CustomCodeSelectionToResourceTranslation.$(H): SmallSense__CustomCodeSelectionToResourceTranslation.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeSelectionRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomDefaultGetterMethodsCodeGenerator.$(O) SmallSense__CustomDefaultGetterMethodsCodeGenerator.$(C) SmallSense__CustomDefaultGetterMethodsCodeGenerator.$(H): SmallSense__CustomDefaultGetterMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomLazyInitializationAccessMethodsCodeGenerator.$(O) SmallSense__CustomLazyInitializationAccessMethodsCodeGenerator.$(C) SmallSense__CustomLazyInitializationAccessMethodsCodeGenerator.$(H): SmallSense__CustomLazyInitializationAccessMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomLazyInitializationGetterMethodsCodeGenerator.$(O) SmallSense__CustomLazyInitializationGetterMethodsCodeGenerator.$(C) SmallSense__CustomLazyInitializationGetterMethodsCodeGenerator.$(H): SmallSense__CustomLazyInitializationGetterMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomMultiSetterMethodsCodeGenerator.$(O) SmallSense__CustomMultiSetterMethodsCodeGenerator.$(C) SmallSense__CustomMultiSetterMethodsCodeGenerator.$(H): SmallSense__CustomMultiSetterMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomPrintCodeSelectionRefactoring.$(O) SmallSense__CustomPrintCodeSelectionRefactoring.$(C) SmallSense__CustomPrintCodeSelectionRefactoring.$(H): SmallSense__CustomPrintCodeSelectionRefactoring.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeSelectionRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomRefactoringClassGenerator.$(O) SmallSense__CustomRefactoringClassGenerator.$(C) SmallSense__CustomRefactoringClassGenerator.$(H): SmallSense__CustomRefactoringClassGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomNewClassGenerator.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomSimpleAccessMethodsCodeGenerator.$(O) SmallSense__CustomSimpleAccessMethodsCodeGenerator.$(C) SmallSense__CustomSimpleAccessMethodsCodeGenerator.$(H): SmallSense__CustomSimpleAccessMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomSimpleGetterMethodsCodeGenerator.$(O) SmallSense__CustomSimpleGetterMethodsCodeGenerator.$(C) SmallSense__CustomSimpleGetterMethodsCodeGenerator.$(H): SmallSense__CustomSimpleGetterMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomSimpleSetterMethodsCodeGenerator.$(O) SmallSense__CustomSimpleSetterMethodsCodeGenerator.$(C) SmallSense__CustomSimpleSetterMethodsCodeGenerator.$(H): SmallSense__CustomSimpleSetterMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomUITestCaseCodeGenerator.$(O) SmallSense__CustomUITestCaseCodeGenerator.$(C) SmallSense__CustomUITestCaseCodeGenerator.$(H): SmallSense__CustomUITestCaseCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomTestCaseCodeGenerator.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomUITestCaseSetUpCodeGenerator.$(O) SmallSense__CustomUITestCaseSetUpCodeGenerator.$(C) SmallSense__CustomUITestCaseSetUpCodeGenerator.$(H): SmallSense__CustomUITestCaseSetUpCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomTestCaseSetUpCodeGenerator.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomValueHolderAccessMethodsCodeGenerator.$(O) SmallSense__CustomValueHolderAccessMethodsCodeGenerator.$(C) SmallSense__CustomValueHolderAccessMethodsCodeGenerator.$(H): SmallSense__CustomValueHolderAccessMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomValueHolderGetterMethodsCodeGenerator.$(O) SmallSense__CustomValueHolderGetterMethodsCodeGenerator.$(C) SmallSense__CustomValueHolderGetterMethodsCodeGenerator.$(H): SmallSense__CustomValueHolderGetterMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomValueHolderWithChangeNotificationAccessMethodsCodeGenerator.$(O) SmallSense__CustomValueHolderWithChangeNotificationAccessMethodsCodeGenerator.$(C) SmallSense__CustomValueHolderWithChangeNotificationAccessMethodsCodeGenerator.$(H): SmallSense__CustomValueHolderWithChangeNotificationAccessMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator.$(O) SmallSense__CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator.$(C) SmallSense__CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator.$(H): SmallSense__CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomValueHolderWithChangeNotificationSetterMethodsCodeGenerator.$(O) SmallSense__CustomValueHolderWithChangeNotificationSetterMethodsCodeGenerator.$(C) SmallSense__CustomValueHolderWithChangeNotificationSetterMethodsCodeGenerator.$(H): SmallSense__CustomValueHolderWithChangeNotificationSetterMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomVisitorCodeGeneratorAcceptVisitor.$(O) SmallSense__CustomVisitorCodeGeneratorAcceptVisitor.$(C) SmallSense__CustomVisitorCodeGeneratorAcceptVisitor.$(H): SmallSense__CustomVisitorCodeGeneratorAcceptVisitor.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomVisitorCodeGenerator.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmallSense__CustomJavaScriptSimpleSetterMethodsCodeGenerator.$(O) SmallSense__CustomJavaScriptSimpleSetterMethodsCodeGenerator.$(C) SmallSense__CustomJavaScriptSimpleSetterMethodsCodeGenerator.$(H): SmallSense__CustomJavaScriptSimpleSetterMethodsCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomAccessMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomCodeGeneratorOrRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\smallsense\refactoring_custom\SmallSense__CustomSimpleSetterMethodsCodeGenerator.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\AddClassChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\AddMethodChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\RBAbstractClass.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\RBClass.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\RBMetaclass.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\RBMethod.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\SystemBrowser.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__NewSystemBrowser.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_smallsense_refactoring_custom.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
