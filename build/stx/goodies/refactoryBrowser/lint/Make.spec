# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_lint.
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
MODULE_DIR=goodies/refactoryBrowser/lint
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to CC for inline C-code
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
STCLOCALOPTIMIZATIONS=+optspace3


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
	LintRuleIgnoreAnnotation \
	RBEnvironmentSearchAction \
	RBLintRule \
	RBReadBeforeWrittenTester \
	SmalllintChecker \
	SmalllintContext \
	stx_goodies_refactoryBrowser_lint \
	RBBasicLintRule \
	RBCompositeLintRule \
	RBEnvironmentStringSearchAction \
	RBEnvironmentStringSelectAction \
	RBEnvironmentVariableSearchAction \
	RBTransformationRule \
	RBAllAnyNoneSatisfyRule \
	RBAsNilIfEmptyRule \
	RBAssignmentInIfTrueRule \
	RBAtIfAbsentRule \
	RBBetweenAndRule \
	RBBlockLintRule \
	RBCascadedNextPutAllsRule \
	RBContainsToConformRule \
	RBCopyEliminationRule \
	RBCopyWithSizeToCopyXXXRule \
	RBDetectIfNoneRule \
	RBDetectIfNoneToIncludesRule \
	RBEmptyOrNilReplaceRule \
	RBEqualNilRule \
	RBFileOpenCloseToReadingFileRule \
	RBFindFirstToContainsRule \
	RBFixWrongPrecedenceRule \
	RBGuardClauseRule \
	RBIfNilIfNotNilReplaceRule \
	RBLintRuleSet \
	RBLoggingCodeReplaceRule \
	RBMinMaxRule \
	RBNilOrEmptyCollectionReplaceRule \
	RBNonPortableNonBlockValueSend \
	RBNotEliminationRule \
	RBNotNilAndNotEmptyReplaceRule \
	RBOldStyleMessagesRule \
	RBParseTreeLintRule \
	RBReplaceIfByIsNilNotNilRule \
	RBReturnFromHandlerBlocksRule \
	RBSTXSpecialCommentsRule \
	RBSelectCollectToSelectThenCollectRule \
	RBSelectToCountRule \
	RBShowWhileBlocksRule \
	RBSuperSendsRule \
	RBTempVarEliminationRule \
	RBTranslateLiteralsInDialogsReplaceRule \
	RBTranslateLiteralsInMenusReplaceRule \
	RBTranslateLiteralsInMenusRule \
	RBUnderscoreAssignmentRule \
	RBUnneededIfAfterBooleanAssignmentRule \
	RBUnneededIfNilAfterNilAssignmentRule \
	RBUnwindBlocksRule \
	RBUseBindWithRule \
	RBWrongOldStyleMessagesRule \
	RBAbstractClassRule \
	RBAddRemoveDependentsRule \
	RBApplicationModelChecksRule \
	RBAsOrderedCollectionNotNeededRule \
	RBAssignmentInBlockRule \
	RBAssignmentWithoutEffectRule \
	RBBadIdentityComparisonRule \
	RBBadMessageRule \
	RBBooleanPrecedenceRule \
	RBBuiltinRuleSet \
	RBClassInstVarNotInitializedRule \
	RBClassNameInSelectorRule \
	RBClassNotReferencedRule \
	RBClassVariableCapitalizationRule \
	RBCodeCruftLeftInMethodsRule \
	RBCodeDuplicationRule \
	RBCollectSelectNotUsedRule \
	RBCollectionCopyEmptyRule \
	RBCollectionMessagesToExternalObjectRule \
	RBCollectionPostCopyRule \
	RBCollectionProtocolRule \
	RBCollectionSearchProtocolRule \
	RBConsistencyCheck2Rule \
	RBConsistencyCheckRule \
	RBContainsNamespaceIdentifiersRule \
	RBContainsRule \
	RBContainsSmalltalkXEOLCommentRule \
	RBContainsSqueakArrayConstructorRule \
	RBContainsToIncludesRule \
	RBContainsVisualWorksBindingReferencesRule \
	RBDebuggingCodeLeftInMethodsRule \
	RBDefinesEqualNotHashRule \
	RBDefinesInitializeNotCalledRule \
	RBDetectBadCollectionUsesRule \
	RBDetectContainsRule \
	RBDoubleClassInitializationRule \
	RBDoubleTranslationsRule \
	RBEmptyExceptionHandlerRule \
	RBEmptyMethodWithoutCommentRule \
	RBEndTrueFalseRule \
	RBEqualNotUsedRule \
	RBEqualsTrueRule \
	RBEquivalentSuperclassMethodsRule \
	RBExcessiveArgumentsRule \
	RBExcessiveInheritanceRule \
	RBExcessiveMethodsRule \
	RBExcessiveVariablesRule \
	RBExeptOrganizationRule \
	RBExplicitClassCheckRule \
	RBExtraBlockRule \
	RBFileBlocksRule \
	RBFileStreamPossiblyNotClosedRule \
	RBFloatEqualityComparisonRule \
	RBFloatIdentityComparisonRule \
	RBGuardingClauseRule \
	RBIfTrueBlocksRule \
	RBIfTrueReturnsRule \
	RBImageSpecMethodWithBrokenImage \
	RBImageSpecMethodWithWrongKeyRule \
	RBImplementedNotSentRule \
	RBIncompatibleIdentifierInClassDefinitionRule \
	RBIncompatibleLocalIdentifierRule \
	RBIncompatibleSelectorRule \
	RBInconsistentMethodClassificationRule \
	RBInjectAllSatisfyAnySatisfyRule \
	RBInjectSubProductRule \
	RBInstVarInSubclassesRule \
	RBInstanceVariableCapitalizationRule \
	RBInvalidArgumentIdentifierRule \
	RBInvalidLocalIdentifierRule \
	RBJustSendsSuperRule \
	RBLawOfDemeterRule \
	RBLiteralArrayByteValuesRule \
	RBLiteralArrayCharactersRule \
	RBLiteralArrayContainsCommaRule \
	RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule \
	RBLongMethodsRule \
	RBMethodSourceContainsLinefeedsRule \
	RBMisplacedReturnInIfTrueIfFalseWithTempsRule \
	RBMissingSubclassResponsibilityRule \
	RBMissingSuperSendsRule \
	RBMissingTranslationInResourceFileRule \
	RBMissingTranslationsInMenusRule \
	RBMissingTranslationsRule \
	RBMissingYourselfRule \
	RBModifiesCollectionRule \
	RBMultipleDependenciesRule \
	RBNoClassCommentRule \
	RBNoMethodCommentRule \
	RBObfuscatedLazyInitializerRule \
	RBOnlyReadOrWrittenTemporaryRule \
	RBOnlyReadOrWrittenVariableRule \
	RBOverridesSpecialMessageRule \
	RBPlatformDependentUserInteractionRule \
	RBPrecedenceRule \
	RBQuestionableReturnFromEnsureBlocksRule \
	RBRefersToClassInPackageExcludedFromPrerequisitesRule \
	RBRefersToClassRule \
	RBRefersToConcreteOSClasses \
	RBRefersToPrivateClassRule \
	RBReturnInEnsureRule \
	RBReturnsBooleanAndOtherRule \
	RBReturnsIfTrueRule \
	RBRuleIgnoredRule \
	RBSearchingLiteralRule \
	RBSendsDeprecatedMethodToGlobalRule \
	RBSendsDifferentSuperRule \
	RBSendsUnknownMessageToGlobalRule \
	RBSentNotImplementedRule \
	RBSizeCheckRule \
	RBStringConcatenationRule \
	RBSubclassResponsibilityNotDefinedRule \
	RBSuperSendsNewRule \
	RBTempVarOverridesInstVarRule \
	RBTemporaryOnlyReadRule \
	RBTemporaryOnlyWrittenRule \
	RBTemporaryVariableCapitalizationRule \
	RBTempsReadBeforeWrittenRule \
	RBThreeElementPointRule \
	RBTimesRepeatInsteadOfToDoRule \
	RBToDoCollectRule \
	RBToDoFillRule \
	RBToDoRule \
	RBToDoWithIncrementRule \
	RBUnclassifiedMethodsRule \
	RBUncommonMessageSendRule \
	RBUnconditionalRecursionRule \
	RBUndeclaredReferenceRule \
	RBUnnecessaryAssignmentRule \
	RBUnnecessaryCollectionCopyRule \
	RBUnnecessaryCollectionSizeRule \
	RBUnoptimizedAndOrRule \
	RBUnoptimizedToDoRule \
	RBUnpackagedCodeRule \
	RBUnreferencedTempsRule \
	RBUnreferencedVariablesRule \
	RBUserDefinedRuleSet \
	RBUsesAddRule \
	RBUsesTrueRule \
	RBUtilityMethodsRule \
	RBVariableAssignedLiteralRule \
	RBVariableAssignedSameLiteralRule \
	RBVariableNotDefinedRule \
	RBVariableReferencedOnceRule \
	RBWhileTrueRule \
	RBYourselfNotUsedRule \




COMMON_OBJS= \
    $(OUTDIR)LintRuleIgnoreAnnotation.$(O) \
    $(OUTDIR)RBEnvironmentSearchAction.$(O) \
    $(OUTDIR)RBLintRule.$(O) \
    $(OUTDIR)RBReadBeforeWrittenTester.$(O) \
    $(OUTDIR)SmalllintChecker.$(O) \
    $(OUTDIR)SmalllintContext.$(O) \
    $(OUTDIR)stx_goodies_refactoryBrowser_lint.$(O) \
    $(OUTDIR)RBBasicLintRule.$(O) \
    $(OUTDIR)RBCompositeLintRule.$(O) \
    $(OUTDIR)RBEnvironmentStringSearchAction.$(O) \
    $(OUTDIR)RBEnvironmentStringSelectAction.$(O) \
    $(OUTDIR)RBEnvironmentVariableSearchAction.$(O) \
    $(OUTDIR)RBTransformationRule.$(O) \
    $(OUTDIR)RBAllAnyNoneSatisfyRule.$(O) \
    $(OUTDIR)RBAsNilIfEmptyRule.$(O) \
    $(OUTDIR)RBAssignmentInIfTrueRule.$(O) \
    $(OUTDIR)RBAtIfAbsentRule.$(O) \
    $(OUTDIR)RBBetweenAndRule.$(O) \
    $(OUTDIR)RBBlockLintRule.$(O) \
    $(OUTDIR)RBCascadedNextPutAllsRule.$(O) \
    $(OUTDIR)RBContainsToConformRule.$(O) \
    $(OUTDIR)RBCopyEliminationRule.$(O) \
    $(OUTDIR)RBCopyWithSizeToCopyXXXRule.$(O) \
    $(OUTDIR)RBDetectIfNoneRule.$(O) \
    $(OUTDIR)RBDetectIfNoneToIncludesRule.$(O) \
    $(OUTDIR)RBEmptyOrNilReplaceRule.$(O) \
    $(OUTDIR)RBEqualNilRule.$(O) \
    $(OUTDIR)RBFileOpenCloseToReadingFileRule.$(O) \
    $(OUTDIR)RBFindFirstToContainsRule.$(O) \
    $(OUTDIR)RBFixWrongPrecedenceRule.$(O) \
    $(OUTDIR)RBGuardClauseRule.$(O) \
    $(OUTDIR)RBIfNilIfNotNilReplaceRule.$(O) \
    $(OUTDIR)RBLintRuleSet.$(O) \
    $(OUTDIR)RBLoggingCodeReplaceRule.$(O) \
    $(OUTDIR)RBMinMaxRule.$(O) \
    $(OUTDIR)RBNilOrEmptyCollectionReplaceRule.$(O) \
    $(OUTDIR)RBNonPortableNonBlockValueSend.$(O) \
    $(OUTDIR)RBNotEliminationRule.$(O) \
    $(OUTDIR)RBNotNilAndNotEmptyReplaceRule.$(O) \
    $(OUTDIR)RBOldStyleMessagesRule.$(O) \
    $(OUTDIR)RBParseTreeLintRule.$(O) \
    $(OUTDIR)RBReplaceIfByIsNilNotNilRule.$(O) \
    $(OUTDIR)RBReturnFromHandlerBlocksRule.$(O) \
    $(OUTDIR)RBSTXSpecialCommentsRule.$(O) \
    $(OUTDIR)RBSelectCollectToSelectThenCollectRule.$(O) \
    $(OUTDIR)RBSelectToCountRule.$(O) \
    $(OUTDIR)RBShowWhileBlocksRule.$(O) \
    $(OUTDIR)RBSuperSendsRule.$(O) \
    $(OUTDIR)RBTempVarEliminationRule.$(O) \
    $(OUTDIR)RBTranslateLiteralsInDialogsReplaceRule.$(O) \
    $(OUTDIR)RBTranslateLiteralsInMenusReplaceRule.$(O) \
    $(OUTDIR)RBTranslateLiteralsInMenusRule.$(O) \
    $(OUTDIR)RBUnderscoreAssignmentRule.$(O) \
    $(OUTDIR)RBUnneededIfAfterBooleanAssignmentRule.$(O) \
    $(OUTDIR)RBUnneededIfNilAfterNilAssignmentRule.$(O) \
    $(OUTDIR)RBUnwindBlocksRule.$(O) \
    $(OUTDIR)RBUseBindWithRule.$(O) \
    $(OUTDIR)RBWrongOldStyleMessagesRule.$(O) \
    $(OUTDIR)RBAbstractClassRule.$(O) \
    $(OUTDIR)RBAddRemoveDependentsRule.$(O) \
    $(OUTDIR)RBApplicationModelChecksRule.$(O) \
    $(OUTDIR)RBAsOrderedCollectionNotNeededRule.$(O) \
    $(OUTDIR)RBAssignmentInBlockRule.$(O) \
    $(OUTDIR)RBAssignmentWithoutEffectRule.$(O) \
    $(OUTDIR)RBBadIdentityComparisonRule.$(O) \
    $(OUTDIR)RBBadMessageRule.$(O) \
    $(OUTDIR)RBBooleanPrecedenceRule.$(O) \
    $(OUTDIR)RBBuiltinRuleSet.$(O) \
    $(OUTDIR)RBClassInstVarNotInitializedRule.$(O) \
    $(OUTDIR)RBClassNameInSelectorRule.$(O) \
    $(OUTDIR)RBClassNotReferencedRule.$(O) \
    $(OUTDIR)RBClassVariableCapitalizationRule.$(O) \
    $(OUTDIR)RBCodeCruftLeftInMethodsRule.$(O) \
    $(OUTDIR)RBCodeDuplicationRule.$(O) \
    $(OUTDIR)RBCollectSelectNotUsedRule.$(O) \
    $(OUTDIR)RBCollectionCopyEmptyRule.$(O) \
    $(OUTDIR)RBCollectionMessagesToExternalObjectRule.$(O) \
    $(OUTDIR)RBCollectionPostCopyRule.$(O) \
    $(OUTDIR)RBCollectionProtocolRule.$(O) \
    $(OUTDIR)RBCollectionSearchProtocolRule.$(O) \
    $(OUTDIR)RBConsistencyCheck2Rule.$(O) \
    $(OUTDIR)RBConsistencyCheckRule.$(O) \
    $(OUTDIR)RBContainsNamespaceIdentifiersRule.$(O) \
    $(OUTDIR)RBContainsRule.$(O) \
    $(OUTDIR)RBContainsSmalltalkXEOLCommentRule.$(O) \
    $(OUTDIR)RBContainsSqueakArrayConstructorRule.$(O) \
    $(OUTDIR)RBContainsToIncludesRule.$(O) \
    $(OUTDIR)RBContainsVisualWorksBindingReferencesRule.$(O) \
    $(OUTDIR)RBDebuggingCodeLeftInMethodsRule.$(O) \
    $(OUTDIR)RBDefinesEqualNotHashRule.$(O) \
    $(OUTDIR)RBDefinesInitializeNotCalledRule.$(O) \
    $(OUTDIR)RBDetectBadCollectionUsesRule.$(O) \
    $(OUTDIR)RBDetectContainsRule.$(O) \
    $(OUTDIR)RBDoubleClassInitializationRule.$(O) \
    $(OUTDIR)RBDoubleTranslationsRule.$(O) \
    $(OUTDIR)RBEmptyExceptionHandlerRule.$(O) \
    $(OUTDIR)RBEmptyMethodWithoutCommentRule.$(O) \
    $(OUTDIR)RBEndTrueFalseRule.$(O) \
    $(OUTDIR)RBEqualNotUsedRule.$(O) \
    $(OUTDIR)RBEqualsTrueRule.$(O) \
    $(OUTDIR)RBEquivalentSuperclassMethodsRule.$(O) \
    $(OUTDIR)RBExcessiveArgumentsRule.$(O) \
    $(OUTDIR)RBExcessiveInheritanceRule.$(O) \
    $(OUTDIR)RBExcessiveMethodsRule.$(O) \
    $(OUTDIR)RBExcessiveVariablesRule.$(O) \
    $(OUTDIR)RBExeptOrganizationRule.$(O) \
    $(OUTDIR)RBExplicitClassCheckRule.$(O) \
    $(OUTDIR)RBExtraBlockRule.$(O) \
    $(OUTDIR)RBFileBlocksRule.$(O) \
    $(OUTDIR)RBFileStreamPossiblyNotClosedRule.$(O) \
    $(OUTDIR)RBFloatEqualityComparisonRule.$(O) \
    $(OUTDIR)RBFloatIdentityComparisonRule.$(O) \
    $(OUTDIR)RBGuardingClauseRule.$(O) \
    $(OUTDIR)RBIfTrueBlocksRule.$(O) \
    $(OUTDIR)RBIfTrueReturnsRule.$(O) \
    $(OUTDIR)RBImageSpecMethodWithBrokenImage.$(O) \
    $(OUTDIR)RBImageSpecMethodWithWrongKeyRule.$(O) \
    $(OUTDIR)RBImplementedNotSentRule.$(O) \
    $(OUTDIR)RBIncompatibleIdentifierInClassDefinitionRule.$(O) \
    $(OUTDIR)RBIncompatibleLocalIdentifierRule.$(O) \
    $(OUTDIR)RBIncompatibleSelectorRule.$(O) \
    $(OUTDIR)RBInconsistentMethodClassificationRule.$(O) \
    $(OUTDIR)RBInjectAllSatisfyAnySatisfyRule.$(O) \
    $(OUTDIR)RBInjectSubProductRule.$(O) \
    $(OUTDIR)RBInstVarInSubclassesRule.$(O) \
    $(OUTDIR)RBInstanceVariableCapitalizationRule.$(O) \
    $(OUTDIR)RBInvalidArgumentIdentifierRule.$(O) \
    $(OUTDIR)RBInvalidLocalIdentifierRule.$(O) \
    $(OUTDIR)RBJustSendsSuperRule.$(O) \
    $(OUTDIR)RBLawOfDemeterRule.$(O) \
    $(OUTDIR)RBLiteralArrayByteValuesRule.$(O) \
    $(OUTDIR)RBLiteralArrayCharactersRule.$(O) \
    $(OUTDIR)RBLiteralArrayContainsCommaRule.$(O) \
    $(OUTDIR)RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule.$(O) \
    $(OUTDIR)RBLongMethodsRule.$(O) \
    $(OUTDIR)RBMethodSourceContainsLinefeedsRule.$(O) \
    $(OUTDIR)RBMisplacedReturnInIfTrueIfFalseWithTempsRule.$(O) \
    $(OUTDIR)RBMissingSubclassResponsibilityRule.$(O) \
    $(OUTDIR)RBMissingSuperSendsRule.$(O) \
    $(OUTDIR)RBMissingTranslationInResourceFileRule.$(O) \
    $(OUTDIR)RBMissingTranslationsInMenusRule.$(O) \
    $(OUTDIR)RBMissingTranslationsRule.$(O) \
    $(OUTDIR)RBMissingYourselfRule.$(O) \
    $(OUTDIR)RBModifiesCollectionRule.$(O) \
    $(OUTDIR)RBMultipleDependenciesRule.$(O) \
    $(OUTDIR)RBNoClassCommentRule.$(O) \
    $(OUTDIR)RBNoMethodCommentRule.$(O) \
    $(OUTDIR)RBObfuscatedLazyInitializerRule.$(O) \
    $(OUTDIR)RBOnlyReadOrWrittenTemporaryRule.$(O) \
    $(OUTDIR)RBOnlyReadOrWrittenVariableRule.$(O) \
    $(OUTDIR)RBOverridesSpecialMessageRule.$(O) \
    $(OUTDIR)RBPlatformDependentUserInteractionRule.$(O) \
    $(OUTDIR)RBPrecedenceRule.$(O) \
    $(OUTDIR)RBQuestionableReturnFromEnsureBlocksRule.$(O) \
    $(OUTDIR)RBRefersToClassInPackageExcludedFromPrerequisitesRule.$(O) \
    $(OUTDIR)RBRefersToClassRule.$(O) \
    $(OUTDIR)RBRefersToConcreteOSClasses.$(O) \
    $(OUTDIR)RBRefersToPrivateClassRule.$(O) \
    $(OUTDIR)RBReturnInEnsureRule.$(O) \
    $(OUTDIR)RBReturnsBooleanAndOtherRule.$(O) \
    $(OUTDIR)RBReturnsIfTrueRule.$(O) \
    $(OUTDIR)RBRuleIgnoredRule.$(O) \
    $(OUTDIR)RBSearchingLiteralRule.$(O) \
    $(OUTDIR)RBSendsDeprecatedMethodToGlobalRule.$(O) \
    $(OUTDIR)RBSendsDifferentSuperRule.$(O) \
    $(OUTDIR)RBSendsUnknownMessageToGlobalRule.$(O) \
    $(OUTDIR)RBSentNotImplementedRule.$(O) \
    $(OUTDIR)RBSizeCheckRule.$(O) \
    $(OUTDIR)RBStringConcatenationRule.$(O) \
    $(OUTDIR)RBSubclassResponsibilityNotDefinedRule.$(O) \
    $(OUTDIR)RBSuperSendsNewRule.$(O) \
    $(OUTDIR)RBTempVarOverridesInstVarRule.$(O) \
    $(OUTDIR)RBTemporaryOnlyReadRule.$(O) \
    $(OUTDIR)RBTemporaryOnlyWrittenRule.$(O) \
    $(OUTDIR)RBTemporaryVariableCapitalizationRule.$(O) \
    $(OUTDIR)RBTempsReadBeforeWrittenRule.$(O) \
    $(OUTDIR)RBThreeElementPointRule.$(O) \
    $(OUTDIR)RBTimesRepeatInsteadOfToDoRule.$(O) \
    $(OUTDIR)RBToDoCollectRule.$(O) \
    $(OUTDIR)RBToDoFillRule.$(O) \
    $(OUTDIR)RBToDoRule.$(O) \
    $(OUTDIR)RBToDoWithIncrementRule.$(O) \
    $(OUTDIR)RBUnclassifiedMethodsRule.$(O) \
    $(OUTDIR)RBUncommonMessageSendRule.$(O) \
    $(OUTDIR)RBUnconditionalRecursionRule.$(O) \
    $(OUTDIR)RBUndeclaredReferenceRule.$(O) \
    $(OUTDIR)RBUnnecessaryAssignmentRule.$(O) \
    $(OUTDIR)RBUnnecessaryCollectionCopyRule.$(O) \
    $(OUTDIR)RBUnnecessaryCollectionSizeRule.$(O) \
    $(OUTDIR)RBUnoptimizedAndOrRule.$(O) \
    $(OUTDIR)RBUnoptimizedToDoRule.$(O) \
    $(OUTDIR)RBUnpackagedCodeRule.$(O) \
    $(OUTDIR)RBUnreferencedTempsRule.$(O) \
    $(OUTDIR)RBUnreferencedVariablesRule.$(O) \
    $(OUTDIR)RBUserDefinedRuleSet.$(O) \
    $(OUTDIR)RBUsesAddRule.$(O) \
    $(OUTDIR)RBUsesTrueRule.$(O) \
    $(OUTDIR)RBUtilityMethodsRule.$(O) \
    $(OUTDIR)RBVariableAssignedLiteralRule.$(O) \
    $(OUTDIR)RBVariableAssignedSameLiteralRule.$(O) \
    $(OUTDIR)RBVariableNotDefinedRule.$(O) \
    $(OUTDIR)RBVariableReferencedOnceRule.$(O) \
    $(OUTDIR)RBWhileTrueRule.$(O) \
    $(OUTDIR)RBYourselfNotUsedRule.$(O) \
    $(OUTDIR)extensions.$(O) \



