# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_refactoring.
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


# see stdHeader_bc for LIB_RB_REFACTORING_BASE
LIB_BASE=$(LIB_RB_REFACTORING_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_refactoryBrowser_refactoring
MODULE_PATH=goodies\refactoryBrowser\refactoring
RESFILES=stx_goodies_refactoryBrowser_refactoringWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libcomp -I$(INCLUDE_TOP)\stx\libview
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







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)AbstractCondition.$(O) AbstractCondition.$(C) AbstractCondition.$(H): AbstractCondition.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBParseTreeRule.$(O) RBParseTreeRule.$(C) RBParseTreeRule.$(H): RBParseTreeRule.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBReplaceStringInOriginalSource.$(O) RBReplaceStringInOriginalSource.$(C) RBReplaceStringInOriginalSource.$(H): RBReplaceStringInOriginalSource.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBReplaceTokenStringInOriginalSource.$(O) RBReplaceTokenStringInOriginalSource.$(C) RBReplaceTokenStringInOriginalSource.$(H): RBReplaceTokenStringInOriginalSource.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Refactoring.$(O) Refactoring.$(C) Refactoring.$(H): Refactoring.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoringError.$(O) RefactoringError.$(C) RefactoringError.$(H): RefactoringError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoringManager.$(O) RefactoringManager.$(C) RefactoringManager.$(H): RefactoringManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoringWarning.$(O) RefactoringWarning.$(C) RefactoringWarning.$(H): RefactoringWarning.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\UserNotification.$(H) $(INCLUDE_TOP)\stx\libbasic\Warning.$(H) $(STCHDR)
$(OUTDIR)RefactoryBuilder.$(O) RefactoryBuilder.$(C) RefactoryBuilder.$(H): RefactoryBuilder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_refactoryBrowser_refactoring.$(O) stx_goodies_refactoryBrowser_refactoring.$(C) stx_goodies_refactoryBrowser_refactoring.$(H): stx_goodies_refactoryBrowser_refactoring.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)AbstractVariablesRefactoring.$(O) AbstractVariablesRefactoring.$(C) AbstractVariablesRefactoring.$(H): AbstractVariablesRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ClassRefactoring.$(O) ClassRefactoring.$(C) ClassRefactoring.$(H): ClassRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ExpandReferencedPoolsRefactoring.$(O) ExpandReferencedPoolsRefactoring.$(C) ExpandReferencedPoolsRefactoring.$(H): ExpandReferencedPoolsRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MethodRefactoring.$(O) MethodRefactoring.$(C) MethodRefactoring.$(H): MethodRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AlternativeCondition.$(O) AlternativeCondition.$(C) AlternativeCondition.$(H): AlternativeCondition.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\AbstractCondition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Condition.$(O) Condition.$(C) Condition.$(H): Condition.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\AbstractCondition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ConjunctiveCondition.$(O) ConjunctiveCondition.$(C) ConjunctiveCondition.$(H): ConjunctiveCondition.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\AbstractCondition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)NegationCondition.$(O) NegationCondition.$(C) NegationCondition.$(H): NegationCondition.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\AbstractCondition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBReplaceRule.$(O) RBReplaceRule.$(C) RBReplaceRule.$(H): RBReplaceRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RBParseTreeRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBSearchRule.$(O) RBSearchRule.$(C) RBSearchRule.$(H): RBSearchRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RBParseTreeRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveClassRefactoring.$(O) RemoveClassRefactoring.$(C) RemoveClassRefactoring.$(H): RemoveClassRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SplitClassRefactoring.$(O) SplitClassRefactoring.$(C) SplitClassRefactoring.$(H): SplitClassRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)VariableRefactoring.$(O) VariableRefactoring.$(C) VariableRefactoring.$(H): VariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AbstractClassVariableRefactoring.$(O) AbstractClassVariableRefactoring.$(C) AbstractClassVariableRefactoring.$(H): AbstractClassVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AbstractInstanceVariableRefactoring.$(O) AbstractInstanceVariableRefactoring.$(C) AbstractInstanceVariableRefactoring.$(H): AbstractInstanceVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddClassRefactoring.$(O) AddClassRefactoring.$(C) AddClassRefactoring.$(H): AddClassRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\ClassRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddClassVariableRefactoring.$(O) AddClassVariableRefactoring.$(C) AddClassVariableRefactoring.$(H): AddClassVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddInstanceVariableRefactoring.$(O) AddInstanceVariableRefactoring.$(C) AddInstanceVariableRefactoring.$(H): AddInstanceVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddMethodRefactoring.$(O) AddMethodRefactoring.$(C) AddMethodRefactoring.$(H): AddMethodRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ChangeMethodNameRefactoring.$(O) ChangeMethodNameRefactoring.$(C) ChangeMethodNameRefactoring.$(H): ChangeMethodNameRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ChildrenToSiblingsRefactoring.$(O) ChildrenToSiblingsRefactoring.$(C) ChildrenToSiblingsRefactoring.$(H): ChildrenToSiblingsRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\ClassRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CreateAccessorsForVariableRefactoring.$(O) CreateAccessorsForVariableRefactoring.$(C) CreateAccessorsForVariableRefactoring.$(H): CreateAccessorsForVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ExtractMethodRefactoring.$(O) ExtractMethodRefactoring.$(C) ExtractMethodRefactoring.$(H): ExtractMethodRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ExtractMethodToComponentRefactoring.$(O) ExtractMethodToComponentRefactoring.$(C) ExtractMethodToComponentRefactoring.$(H): ExtractMethodToComponentRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ExtractToTemporaryRefactoring.$(O) ExtractToTemporaryRefactoring.$(C) ExtractToTemporaryRefactoring.$(H): ExtractToTemporaryRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InlineAllSendersRefactoring.$(O) InlineAllSendersRefactoring.$(C) InlineAllSendersRefactoring.$(H): InlineAllSendersRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InlineMethodRefactoring.$(O) InlineMethodRefactoring.$(C) InlineMethodRefactoring.$(H): InlineMethodRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InlineTemporaryRefactoring.$(O) InlineTemporaryRefactoring.$(C) InlineTemporaryRefactoring.$(H): InlineTemporaryRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MoveMethodRefactoring.$(O) MoveMethodRefactoring.$(C) MoveMethodRefactoring.$(H): MoveMethodRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MoveVariableDefinitionRefactoring.$(O) MoveVariableDefinitionRefactoring.$(C) MoveVariableDefinitionRefactoring.$(H): MoveVariableDefinitionRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ProtectInstanceVariableRefactoring.$(O) ProtectInstanceVariableRefactoring.$(C) ProtectInstanceVariableRefactoring.$(H): ProtectInstanceVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PullUpClassVariableRefactoring.$(O) PullUpClassVariableRefactoring.$(C) PullUpClassVariableRefactoring.$(H): PullUpClassVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PushDownClassVariableRefactoring.$(O) PushDownClassVariableRefactoring.$(C) PushDownClassVariableRefactoring.$(H): PushDownClassVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PushDownMethodRefactoring.$(O) PushDownMethodRefactoring.$(C) PushDownMethodRefactoring.$(H): PushDownMethodRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PushUpMethodRefactoring.$(O) PushUpMethodRefactoring.$(C) PushUpMethodRefactoring.$(H): PushUpMethodRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBBlockReplaceRule.$(O) RBBlockReplaceRule.$(C) RBBlockReplaceRule.$(H): RBBlockReplaceRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RBParseTreeRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RBReplaceRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBStringReplaceRule.$(O) RBStringReplaceRule.$(C) RBStringReplaceRule.$(H): RBStringReplaceRule.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RBParseTreeRule.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RBReplaceRule.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveClassVariableRefactoring.$(O) RemoveClassVariableRefactoring.$(C) RemoveClassVariableRefactoring.$(H): RemoveClassVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveInstanceVariableRefactoring.$(O) RemoveInstanceVariableRefactoring.$(C) RemoveInstanceVariableRefactoring.$(H): RemoveInstanceVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveMethodRefactoring.$(O) RemoveMethodRefactoring.$(C) RemoveMethodRefactoring.$(H): RemoveMethodRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameClassRefactoring.$(O) RenameClassRefactoring.$(C) RenameClassRefactoring.$(H): RenameClassRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\ClassRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameClassVariableRefactoring.$(O) RenameClassVariableRefactoring.$(C) RenameClassVariableRefactoring.$(H): RenameClassVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameTempRefactoring.$(O) RenameTempRefactoring.$(C) RenameTempRefactoring.$(H): RenameTempRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameVariableRefactoring.$(O) RenameVariableRefactoring.$(C) RenameVariableRefactoring.$(H): RenameVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RestoringVariableRefactoring.$(O) RestoringVariableRefactoring.$(C) RestoringVariableRefactoring.$(H): RestoringVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TempToInstVarRefactoring.$(O) TempToInstVarRefactoring.$(C) TempToInstVarRefactoring.$(H): TempToInstVarRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ValueHolderRefactoring.$(O) ValueHolderRefactoring.$(C) ValueHolderRefactoring.$(H): ValueHolderRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddParameterRefactoring.$(O) AddParameterRefactoring.$(C) AddParameterRefactoring.$(H): AddParameterRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\ChangeMethodNameRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InlineMethodFromComponentRefactoring.$(O) InlineMethodFromComponentRefactoring.$(C) InlineMethodFromComponentRefactoring.$(H): InlineMethodFromComponentRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\InlineMethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PullUpInstanceVariableRefactoring.$(O) PullUpInstanceVariableRefactoring.$(C) PullUpInstanceVariableRefactoring.$(H): PullUpInstanceVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RestoringVariableRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PushDownInstanceVariableRefactoring.$(O) PushDownInstanceVariableRefactoring.$(C) PushDownInstanceVariableRefactoring.$(H): PushDownInstanceVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RestoringVariableRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveParameterRefactoring.$(O) RemoveParameterRefactoring.$(C) RemoveParameterRefactoring.$(H): RemoveParameterRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\ChangeMethodNameRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameInstanceVariableRefactoring.$(O) RenameInstanceVariableRefactoring.$(C) RenameInstanceVariableRefactoring.$(H): RenameInstanceVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RestoringVariableRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameMethodRefactoring.$(O) RenameMethodRefactoring.$(C) RenameMethodRefactoring.$(H): RenameMethodRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\ChangeMethodNameRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InlineParameterRefactoring.$(O) InlineParameterRefactoring.$(C) InlineParameterRefactoring.$(H): InlineParameterRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\ChangeMethodNameRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RemoveParameterRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameToInstanceVariableRefactoring.$(O) RenameToInstanceVariableRefactoring.$(C) RenameToInstanceVariableRefactoring.$(H): RenameToInstanceVariableRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RenameInstanceVariableRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RestoringVariableRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\VariableRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
