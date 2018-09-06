# $Header: /cvs/stx/stx/goodies/magritte/bc.mak,v 1.6 2014-09-23 20:23:35 vrany Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_magritte.
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

LIBNAME=libstx_goodies_magritte
RESFILES=magritte.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic
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
	pushd ..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)Magritte__MAAdaptiveModel.$(O) Magritte__MAAdaptiveModel.$(H): Magritte__MAAdaptiveModel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MACompatibility.$(O) Magritte__MACompatibility.$(H): Magritte__MACompatibility.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADescriptionBuilder.$(O) Magritte__MADescriptionBuilder.$(H): Magritte__MADescriptionBuilder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAError.$(O) Magritte__MAError.$(H): Magritte__MAError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAFileModel.$(O) Magritte__MAFileModel.$(H): Magritte__MAFileModel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAObject.$(O) Magritte__MAObject.$(H): Magritte__MAObject.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAProxyObject.$(O) Magritte__MAProxyObject.$(H): Magritte__MAProxyObject.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MASortBlock.$(O) Magritte__MASortBlock.$(H): Magritte__MASortBlock.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATableModel.$(O) Magritte__MATableModel.$(H): Magritte__MATableModel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAValueHolder.$(O) Magritte__MAValueHolder.$(H): Magritte__MAValueHolder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAVisitor.$(O) Magritte__MAVisitor.$(H): Magritte__MAVisitor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_magritte.$(O) stx_goodies_magritte.$(H): stx_goodies_magritte.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAAccessor.$(O) Magritte__MAAccessor.$(H): Magritte__MAAccessor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MACondition.$(O) Magritte__MACondition.$(H): Magritte__MACondition.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADescription.$(O) Magritte__MADescription.$(H): Magritte__MADescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADescriptionHolder.$(O) Magritte__MADescriptionHolder.$(H): Magritte__MADescriptionHolder.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAValueHolder.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADynamicObject.$(O) Magritte__MADynamicObject.$(H): Magritte__MADynamicObject.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAProxyObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAExternalFileModel.$(O) Magritte__MAExternalFileModel.$(H): Magritte__MAExternalFileModel.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAFileModel.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAGraphVisitor.$(O) Magritte__MAGraphVisitor.$(H): Magritte__MAGraphVisitor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAMemento.$(O) Magritte__MAMemento.$(H): Magritte__MAMemento.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAMemoryFileModel.$(O) Magritte__MAMemoryFileModel.$(H): Magritte__MAMemoryFileModel.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAFileModel.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MANamedBuilder.$(O) Magritte__MANamedBuilder.$(H): Magritte__MANamedBuilder.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescriptionBuilder.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAPropertyError.$(O) Magritte__MAPropertyError.$(H): Magritte__MAPropertyError.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAReadError.$(O) Magritte__MAReadError.$(H): Magritte__MAReadError.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAStreamingVisitor.$(O) Magritte__MAStreamingVisitor.$(H): Magritte__MAStreamingVisitor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAValidationError.$(O) Magritte__MAValidationError.$(H): Magritte__MAValidationError.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAWriteError.$(O) Magritte__MAWriteError.$(H): Magritte__MAWriteError.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MACachedMemento.$(O) Magritte__MACachedMemento.$(H): Magritte__MACachedMemento.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMemento.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAConditionError.$(O) Magritte__MAConditionError.$(H): Magritte__MAConditionError.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAError.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAValidationError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAConflictError.$(O) Magritte__MAConflictError.$(H): Magritte__MAConflictError.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAError.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAValidationError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAConjunctiveCondition.$(O) Magritte__MAConjunctiveCondition.$(H): Magritte__MAConjunctiveCondition.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MACondition.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAContainer.$(O) Magritte__MAContainer.$(H): Magritte__MAContainer.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADelegatorAccessor.$(O) Magritte__MADelegatorAccessor.$(H): Magritte__MADelegatorAccessor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAAccessor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADictionaryAccessor.$(O) Magritte__MADictionaryAccessor.$(H): Magritte__MADictionaryAccessor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAAccessor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAElementDescription.$(O) Magritte__MAElementDescription.$(H): Magritte__MAElementDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAIdentityAccessor.$(O) Magritte__MAIdentityAccessor.$(H): Magritte__MAIdentityAccessor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAAccessor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAKindError.$(O) Magritte__MAKindError.$(H): Magritte__MAKindError.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAError.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAValidationError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAMultipleErrors.$(O) Magritte__MAMultipleErrors.$(H): Magritte__MAMultipleErrors.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAError.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAValidationError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MANegationCondition.$(O) Magritte__MANegationCondition.$(H): Magritte__MANegationCondition.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MACondition.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MANullAccessor.$(O) Magritte__MANullAccessor.$(H): Magritte__MANullAccessor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAAccessor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAPluggableAccessor.$(O) Magritte__MAPluggableAccessor.$(H): Magritte__MAPluggableAccessor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAAccessor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAPluggableCondition.$(O) Magritte__MAPluggableCondition.$(H): Magritte__MAPluggableCondition.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MACondition.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MARangeError.$(O) Magritte__MARangeError.$(H): Magritte__MARangeError.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAError.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAValidationError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAReader.$(O) Magritte__MAReader.$(H): Magritte__MAReader.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAStreamingVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MARequiredError.$(O) Magritte__MARequiredError.$(H): Magritte__MARequiredError.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAError.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAValidationError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MASelectorAccessor.$(O) Magritte__MASelectorAccessor.$(H): Magritte__MASelectorAccessor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAAccessor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAStraitMemento.$(O) Magritte__MAStraitMemento.$(H): Magritte__MAStraitMemento.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMemento.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAValidatorVisitor.$(O) Magritte__MAValidatorVisitor.$(H): Magritte__MAValidatorVisitor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAGraphVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAVariableAccessor.$(O) Magritte__MAVariableAccessor.$(H): Magritte__MAVariableAccessor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAAccessor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAWriter.$(O) Magritte__MAWriter.$(H): Magritte__MAWriter.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAStreamingVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MABooleanDescription.$(O) Magritte__MABooleanDescription.$(H): Magritte__MABooleanDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAChainAccessor.$(O) Magritte__MAChainAccessor.$(H): Magritte__MAChainAccessor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAAccessor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADelegatorAccessor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MACheckedMemento.$(O) Magritte__MACheckedMemento.$(H): Magritte__MACheckedMemento.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MACachedMemento.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMemento.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAClassDescription.$(O) Magritte__MAClassDescription.$(H): Magritte__MAClassDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAColorDescription.$(O) Magritte__MAColorDescription.$(H): Magritte__MAColorDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAFileDescription.$(O) Magritte__MAFileDescription.$(H): Magritte__MAFileDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAMagnitudeDescription.$(O) Magritte__MAMagnitudeDescription.$(H): Magritte__MAMagnitudeDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAPriorityContainer.$(O) Magritte__MAPriorityContainer.$(H): Magritte__MAPriorityContainer.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAContainer.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAReferenceDescription.$(O) Magritte__MAReferenceDescription.$(H): Magritte__MAReferenceDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAStringDescription.$(O) Magritte__MAStringDescription.$(H): Magritte__MAStringDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAStringReader.$(O) Magritte__MAStringReader.$(H): Magritte__MAStringReader.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReader.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAStreamingVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAStringWriter.$(O) Magritte__MAStringWriter.$(H): Magritte__MAStringWriter.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAStreamingVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAWriter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADateDescription.$(O) Magritte__MADateDescription.$(H): Magritte__MADateDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMagnitudeDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADurationDescription.$(O) Magritte__MADurationDescription.$(H): Magritte__MADurationDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMagnitudeDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAMemoDescription.$(O) Magritte__MAMemoDescription.$(H): Magritte__MAMemoDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAStringDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MANumberDescription.$(O) Magritte__MANumberDescription.$(H): Magritte__MANumberDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMagnitudeDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAOptionDescription.$(O) Magritte__MAOptionDescription.$(H): Magritte__MAOptionDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReferenceDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAPasswordDescription.$(O) Magritte__MAPasswordDescription.$(H): Magritte__MAPasswordDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAStringDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MARelationDescription.$(O) Magritte__MARelationDescription.$(H): Magritte__MARelationDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReferenceDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MASymbolDescription.$(O) Magritte__MASymbolDescription.$(H): Magritte__MASymbolDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAStringDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATableDescription.$(O) Magritte__MATableDescription.$(H): Magritte__MATableDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReferenceDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATimeDescription.$(O) Magritte__MATimeDescription.$(H): Magritte__MATimeDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMagnitudeDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATimeStampDescription.$(O) Magritte__MATimeStampDescription.$(H): Magritte__MATimeStampDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMagnitudeDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATokenDescription.$(O) Magritte__MATokenDescription.$(H): Magritte__MATokenDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReferenceDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAMultipleOptionDescription.$(O) Magritte__MAMultipleOptionDescription.$(H): Magritte__MAMultipleOptionDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAOptionDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReferenceDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MASingleOptionDescription.$(O) Magritte__MASingleOptionDescription.$(H): Magritte__MASingleOptionDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAOptionDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReferenceDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAToManyRelationDescription.$(O) Magritte__MAToManyRelationDescription.$(H): Magritte__MAToManyRelationDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReferenceDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MARelationDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAToOneRelationDescription.$(O) Magritte__MAToOneRelationDescription.$(H): Magritte__MAToOneRelationDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReferenceDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MARelationDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAToManyScalarRelationDescription.$(O) Magritte__MAToManyScalarRelationDescription.$(H): Magritte__MAToManyScalarRelationDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReferenceDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MARelationDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAToManyRelationDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\ArithmeticValue.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\Block.$(H) $(INCLUDE_TOP)\stx\libbasic\BlockContext.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Class.$(H) $(INCLUDE_TOP)\stx\libbasic\ClassDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\Context.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\Integer.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Number.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\Symbol.$(H) $(INCLUDE_TOP)\stx\libbasic\UndefinedObject.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
