# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_refactoring.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=stx
MODULE_DIR=goodies/refactoryBrowser/refactoring
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to to CC for inline C-code
#  -Ixxx       : include path passed to CC for inline C-code
#  +optspace   : optimized for space
#  +optspace2  : optimized more for space
#  +optspace3  : optimized even more for space
#  +optinline  : generate inline code for some ST constructs
#  +inlineNew  : additionally inline new
#  +inlineMath : additionally inline some floatPnt math stuff
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCLOCALOPTIMIZATIONS=+optinline +inlineNew
# STCLOCALOPTIMIZATIONS=+optspace3
STCLOCALOPTIMIZATIONS=+optspace3 -inlinenot


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	RBAbstractCondition \
	RBParseTreeRule \
	RBReplaceStringInOriginalSource \
	RBReplaceTokenStringInOriginalSource \
	Refactoring \
	RefactoringError \
	RefactoringManager \
	RefactoringWarning \
	RefactoryBuilder \
	stx_goodies_refactoryBrowser_refactoring \
	AbstractVariablesRefactoring \
	ClassRefactoring \
	ExpandReferencedPoolsRefactoring \
	MethodRefactoring \
	RBAlternativeCondition \
	RBCondition \
	RBConjunctiveCondition \
	RBNegationCondition \
	RBReplaceRule \
	RBSearchRule \
	RemoveClassRefactoring \
	SplitClassRefactoring \
	VariableRefactoring \
	AbstractClassVariableRefactoring \
	AbstractInstanceVariableRefactoring \
	AddClassRefactoring \
	AddClassVariableRefactoring \
	AddInstanceVariableRefactoring \
	AddMethodRefactoring \
	ChangeMethodNameRefactoring \
	ChildrenToSiblingsRefactoring \
	CreateAccessorsForVariableRefactoring \
	ExtractMethodRefactoring \
	ExtractMethodToComponentRefactoring \
	ExtractToTemporaryRefactoring \
	InlineAllSelfSendersRefactoring \
	InlineMethodRefactoring \
	InlineTemporaryRefactoring \
	MoveMethodRefactoring \
	MoveVariableDefinitionRefactoring \
	ProtectInstanceVariableRefactoring \
	PullUpClassVariableRefactoring \
	PushDownClassVariableRefactoring \
	PushDownMethodRefactoring \
	PushUpMethodRefactoring \
	RBBlockReplaceRule \
	RBStringReplaceRule \
	RemoveClassVariableRefactoring \
	RemoveInstanceVariableRefactoring \
	RemoveMethodRefactoring \
	RenameClassRefactoring \
	RenameClassVariableRefactoring \
	RenameTemporaryRefactoring \
	RenameVariableRefactoring \
	RestoringVariableRefactoring \
	TemporaryToInstanceVariableRefactoring \
	ValueHolderRefactoring \
	AddParameterRefactoring \
	InlineMethodFromComponentRefactoring \
	PullUpInstanceVariableRefactoring \
	PushDownInstanceVariableRefactoring \
	RemoveParameterRefactoring \
	RenameInstanceVariableRefactoring \
	RenameMethodRefactoring \
	InlineParameterRefactoring \
	RenameToInstanceVariableRefactoring \




COMMON_OBJS= \
    $(OUTDIR_SLASH)AbstractCondition.$(O) \
    $(OUTDIR_SLASH)RBParseTreeRule.$(O) \
    $(OUTDIR_SLASH)RBReplaceStringInOriginalSource.$(O) \
    $(OUTDIR_SLASH)RBReplaceTokenStringInOriginalSource.$(O) \
    $(OUTDIR_SLASH)Refactoring.$(O) \
    $(OUTDIR_SLASH)RefactoringError.$(O) \
    $(OUTDIR_SLASH)RefactoringManager.$(O) \
    $(OUTDIR_SLASH)RefactoringWarning.$(O) \
    $(OUTDIR_SLASH)RefactoryBuilder.$(O) \
    $(OUTDIR_SLASH)stx_goodies_refactoryBrowser_refactoring.$(O) \
    $(OUTDIR_SLASH)AbstractVariablesRefactoring.$(O) \
    $(OUTDIR_SLASH)ClassRefactoring.$(O) \
    $(OUTDIR_SLASH)ExpandReferencedPoolsRefactoring.$(O) \
    $(OUTDIR_SLASH)MethodRefactoring.$(O) \
    $(OUTDIR_SLASH)AlternativeCondition.$(O) \
    $(OUTDIR_SLASH)Condition.$(O) \
    $(OUTDIR_SLASH)ConjunctiveCondition.$(O) \
    $(OUTDIR_SLASH)NegationCondition.$(O) \
    $(OUTDIR_SLASH)RBReplaceRule.$(O) \
    $(OUTDIR_SLASH)RBSearchRule.$(O) \
    $(OUTDIR_SLASH)RemoveClassRefactoring.$(O) \
    $(OUTDIR_SLASH)SplitClassRefactoring.$(O) \
    $(OUTDIR_SLASH)VariableRefactoring.$(O) \
    $(OUTDIR_SLASH)AbstractClassVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)AbstractInstanceVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)AddClassRefactoring.$(O) \
    $(OUTDIR_SLASH)AddClassVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)AddInstanceVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)AddMethodRefactoring.$(O) \
    $(OUTDIR_SLASH)ChangeMethodNameRefactoring.$(O) \
    $(OUTDIR_SLASH)ChildrenToSiblingsRefactoring.$(O) \
    $(OUTDIR_SLASH)CreateAccessorsForVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)ExtractMethodRefactoring.$(O) \
    $(OUTDIR_SLASH)ExtractMethodToComponentRefactoring.$(O) \
    $(OUTDIR_SLASH)ExtractToTemporaryRefactoring.$(O) \
    $(OUTDIR_SLASH)InlineAllSendersRefactoring.$(O) \
    $(OUTDIR_SLASH)InlineMethodRefactoring.$(O) \
    $(OUTDIR_SLASH)InlineTemporaryRefactoring.$(O) \
    $(OUTDIR_SLASH)MoveMethodRefactoring.$(O) \
    $(OUTDIR_SLASH)MoveVariableDefinitionRefactoring.$(O) \
    $(OUTDIR_SLASH)ProtectInstanceVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)PullUpClassVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)PushDownClassVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)PushDownMethodRefactoring.$(O) \
    $(OUTDIR_SLASH)PushUpMethodRefactoring.$(O) \
    $(OUTDIR_SLASH)RBBlockReplaceRule.$(O) \
    $(OUTDIR_SLASH)RBStringReplaceRule.$(O) \
    $(OUTDIR_SLASH)RemoveClassVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)RemoveInstanceVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)RemoveMethodRefactoring.$(O) \
    $(OUTDIR_SLASH)RenameClassRefactoring.$(O) \
    $(OUTDIR_SLASH)RenameClassVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)RenameTempRefactoring.$(O) \
    $(OUTDIR_SLASH)RenameVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)RestoringVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)TempToInstVarRefactoring.$(O) \
    $(OUTDIR_SLASH)ValueHolderRefactoring.$(O) \
    $(OUTDIR_SLASH)AddParameterRefactoring.$(O) \
    $(OUTDIR_SLASH)InlineMethodFromComponentRefactoring.$(O) \
    $(OUTDIR_SLASH)PullUpInstanceVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)PushDownInstanceVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)RemoveParameterRefactoring.$(O) \
    $(OUTDIR_SLASH)RenameInstanceVariableRefactoring.$(O) \
    $(OUTDIR_SLASH)RenameMethodRefactoring.$(O) \
    $(OUTDIR_SLASH)InlineParameterRefactoring.$(O) \
    $(OUTDIR_SLASH)RenameToInstanceVariableRefactoring.$(O) \



