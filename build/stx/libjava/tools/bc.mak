# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libjava_tools.
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
TOP=..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libjava_tools
MODULE_PATH=libjava\tools
RESFILES=stx_libjava_toolsWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libcomp -I$(INCLUDE_TOP)\stx\libjava -I$(INCLUDE_TOP)\stx\libtool -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\goodies\refactoryBrowser\parser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd .. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libtool & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "




java_clean:
	ant -f java\build.xml clean

clean:: java_clean


java_compile:
	ant -f java\build.xml compile

ALL:: java_compile





test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)JavaAbstractSourceHighlighter.$(O) JavaAbstractSourceHighlighter.$(C) JavaAbstractSourceHighlighter.$(H): JavaAbstractSourceHighlighter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaCodeBundleEditor.$(O) JavaCodeBundleEditor.$(C) JavaCodeBundleEditor.$(H): JavaCodeBundleEditor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)JavaCodeLibraryEditor.$(O) JavaCodeLibraryEditor.$(C) JavaCodeLibraryEditor.$(H): JavaCodeLibraryEditor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)JavaCodeLibraryValidationWarning.$(O) JavaCodeLibraryValidationWarning.$(C) JavaCodeLibraryValidationWarning.$(H): JavaCodeLibraryValidationWarning.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\UserNotification.$(H) $(INCLUDE_TOP)\stx\libbasic\Warning.$(H) $(STCHDR)
$(OUTDIR)JavaCompiler.$(O) JavaCompiler.$(C) JavaCompiler.$(H): JavaCompiler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaLintAnnotation.$(O) JavaLintAnnotation.$(C) JavaLintAnnotation.$(H): JavaLintAnnotation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaLintHighlighter.$(O) JavaLintHighlighter.$(C) JavaLintHighlighter.$(H): JavaLintHighlighter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaLintPopupWindow.$(O) JavaLintPopupWindow.$(C) JavaLintPopupWindow.$(H): JavaLintPopupWindow.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)JavaLintService.$(O) JavaLintService.$(C) JavaLintService.$(H): JavaLintService.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__BackgroundSourceProcessingService.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__CodeViewService.$(H) $(STCHDR)
$(OUTDIR)JavaListInspectorView.$(O) JavaListInspectorView.$(C) JavaListInspectorView.$(H): JavaListInspectorView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\InspectorView.$(H) $(INCLUDE_TOP)\stx\libtool\OrderedCollectionInspectorView.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)JavaMapInspectorView.$(O) JavaMapInspectorView.$(C) JavaMapInspectorView.$(H): JavaMapInspectorView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\DictionaryInspectorView.$(H) $(INCLUDE_TOP)\stx\libtool\InspectorView.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)JavaScannerBase.$(O) JavaScannerBase.$(C) JavaScannerBase.$(H): JavaScannerBase.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaSetInspectorView.$(O) JavaSetInspectorView.$(C) JavaSetInspectorView.$(H): JavaSetInspectorView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\InspectorView.$(H) $(INCLUDE_TOP)\stx\libtool\SetInspectorView.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)JavaSettingsApplication.$(O) JavaSettingsApplication.$(C) JavaSettingsApplication.$(H): JavaSettingsApplication.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\AbstractSettingsApplication.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)JavaSourceDocument.$(O) JavaSourceDocument.$(C) JavaSourceDocument.$(H): JavaSourceDocument.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaSourceRef.$(O) JavaSourceRef.$(C) JavaSourceRef.$(H): JavaSourceRef.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaToolbox.$(O) JavaToolbox.$(C) JavaToolbox.$(H): JavaToolbox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__Toolbox.$(H) $(STCHDR)
$(OUTDIR)stx_libjava_tools.$(O) stx_libjava_tools.$(C) stx_libjava_tools.$(H): stx_libjava_tools.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)JavaAbstractLexicalHighlighter.$(O) JavaAbstractLexicalHighlighter.$(C) JavaAbstractLexicalHighlighter.$(H): JavaAbstractLexicalHighlighter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libjava\tools\JavaAbstractSourceHighlighter.$(H) $(STCHDR)
$(OUTDIR)JavaScanner.$(O) JavaScanner.$(C) JavaScanner.$(H): JavaScanner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libjava\tools\JavaScannerBase.$(H) $(STCHDR)
$(OUTDIR)JavaSyntaxHighlighter.$(O) JavaSyntaxHighlighter.$(C) JavaSyntaxHighlighter.$(H): JavaSyntaxHighlighter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libjava\tools\JavaAbstractSourceHighlighter.$(H) $(STCHDR)
$(OUTDIR)GroovyScanner.$(O) GroovyScanner.$(C) GroovyScanner.$(H): GroovyScanner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libjava\tools\JavaScanner.$(H) $(INCLUDE_TOP)\stx\libjava\tools\JavaScannerBase.$(H) $(STCHDR)
$(OUTDIR)JavaLexicalHighlighter.$(O) JavaLexicalHighlighter.$(C) JavaLexicalHighlighter.$(H): JavaLexicalHighlighter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libjava\tools\JavaAbstractLexicalHighlighter.$(H) $(INCLUDE_TOP)\stx\libjava\tools\JavaAbstractSourceHighlighter.$(H) $(INCLUDE_TOP)\stx\libjava\tools\JavaScanner.$(H) $(INCLUDE_TOP)\stx\libjava\tools\JavaScannerBase.$(H) $(STCHDR)
$(OUTDIR)GroovySourceHighlighter.$(O) GroovySourceHighlighter.$(C) GroovySourceHighlighter.$(H): GroovySourceHighlighter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libjava\tools\GroovyScanner.$(H) $(INCLUDE_TOP)\stx\libjava\tools\JavaScanner.$(H) $(INCLUDE_TOP)\stx\libjava\tools\JavaScannerBase.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\ConfigurableFeatures.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libjava\JavaCodeLibrary.$(H) $(INCLUDE_TOP)\stx\libjava\JavaCodeLibraryOrBundle.$(H) $(INCLUDE_TOP)\stx\libjava\JavaObject.$(H) $(INCLUDE_TOP)\stx\libtool\SystemBrowser.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__NewSystemBrowser.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_libjava_tools.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
