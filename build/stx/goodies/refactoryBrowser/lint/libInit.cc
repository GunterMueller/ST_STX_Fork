/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_lint.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_refactoryBrowser_lint_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_refactoryBrowser_lint_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _LintRuleIgnoreAnnotation_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBEnvironmentSearchAction_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBLintRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBReadBeforeWrittenTester_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SmalllintChecker_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SmalllintContext_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137refactoryBrowser_137lint_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBBasicLintRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBCompositeLintRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBEnvironmentStringSearchAction_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBEnvironmentStringSelectAction_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBEnvironmentVariableSearchAction_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBTransformationRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBAllAnyNoneSatisfyRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBAsNilIfEmptyRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBAssignmentInIfTrueRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBAtIfAbsentRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBBetweenAndRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBBlockLintRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBCascadedNextPutAllsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBContainsToConformRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBCopyEliminationRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBCopyWithSizeToCopyXXXRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBDetectIfNoneRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBDetectIfNoneToIncludesRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBEmptyOrNilReplaceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBEqualNilRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBFileOpenCloseToReadingFileRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBFindFirstToContainsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBFixWrongPrecedenceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBGuardClauseRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBIfNilIfNotNilReplaceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBLintRuleSet_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBLoggingCodeReplaceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMinMaxRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBNilOrEmptyCollectionReplaceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBNonPortableNonBlockValueSend_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBNotEliminationRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBNotNilAndNotEmptyReplaceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBOldStyleMessagesRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBParseTreeLintRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBReplaceIfByIsNilNotNilRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBReturnFromHandlerBlocksRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSTXSpecialCommentsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSelectCollectToSelectThenCollectRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSelectToCountRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBShowWhileBlocksRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSuperSendsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBTempVarEliminationRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBTranslateLiteralsInDialogsReplaceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBTranslateLiteralsInMenusReplaceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBTranslateLiteralsInMenusRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnderscoreAssignmentRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnneededIfAfterBooleanAssignmentRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnneededIfNilAfterNilAssignmentRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnwindBlocksRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUseBindWithRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBWrongOldStyleMessagesRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBAbstractClassRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBAddRemoveDependentsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBApplicationModelChecksRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBAsOrderedCollectionNotNeededRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBAssignmentInBlockRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBAssignmentWithoutEffectRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBBadIdentityComparisonRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBBadMessageRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBBooleanPrecedenceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBBuiltinRuleSet_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBClassInstVarNotInitializedRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBClassNameInSelectorRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBClassNotReferencedRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBClassVariableCapitalizationRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBCodeCruftLeftInMethodsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBCodeDuplicationRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBCollectSelectNotUsedRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBCollectionCopyEmptyRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBCollectionMessagesToExternalObjectRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBCollectionPostCopyRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBCollectionProtocolRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBCollectionSearchProtocolRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBConsistencyCheck2Rule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBConsistencyCheckRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBContainsNamespaceIdentifiersRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBContainsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBContainsSmalltalkXEOLCommentRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBContainsSqueakArrayConstructorRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBContainsToIncludesRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBContainsVisualWorksBindingReferencesRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBDebuggingCodeLeftInMethodsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBDefinesEqualNotHashRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBDefinesInitializeNotCalledRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBDetectBadCollectionUsesRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBDetectContainsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBDoubleClassInitializationRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBDoubleTranslationsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBEmptyExceptionHandlerRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBEmptyMethodWithoutCommentRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBEndTrueFalseRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBEqualNotUsedRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBEqualsTrueRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBEquivalentSuperclassMethodsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBExcessiveArgumentsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBExcessiveInheritanceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBExcessiveMethodsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBExcessiveVariablesRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBExeptOrganizationRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBExplicitClassCheckRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBExtraBlockRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBFileBlocksRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBFileStreamPossiblyNotClosedRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBFloatEqualityComparisonRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBFloatIdentityComparisonRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBGuardingClauseRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBIfTrueBlocksRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBIfTrueReturnsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBImageSpecMethodWithBrokenImage_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBImageSpecMethodWithWrongKeyRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBImplementedNotSentRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBIncompatibleIdentifierInClassDefinitionRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBIncompatibleLocalIdentifierRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBIncompatibleSelectorRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBInconsistentMethodClassificationRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBInjectAllSatisfyAnySatisfyRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBInjectSubProductRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBInstVarInSubclassesRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBInstanceVariableCapitalizationRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBInvalidArgumentIdentifierRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBInvalidLocalIdentifierRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBJustSendsSuperRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBLawOfDemeterRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBLiteralArrayByteValuesRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBLiteralArrayCharactersRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBLiteralArrayContainsCommaRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBLongMethodsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMethodSourceContainsLinefeedsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMisplacedReturnInIfTrueIfFalseWithTempsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMissingSubclassResponsibilityRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMissingSuperSendsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMissingTranslationInResourceFileRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMissingTranslationsInMenusRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMissingTranslationsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMissingYourselfRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBModifiesCollectionRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMultipleDependenciesRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBNoClassCommentRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBNoMethodCommentRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBObfuscatedLazyInitializerRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBOnlyReadOrWrittenTemporaryRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBOnlyReadOrWrittenVariableRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBOverridesSpecialMessageRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBPlatformDependentUserInteractionRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBPrecedenceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBQuestionableReturnFromEnsureBlocksRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBRefersToClassInPackageExcludedFromPrerequisitesRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBRefersToClassRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBRefersToConcreteOSClasses_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBRefersToPrivateClassRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBReturnInEnsureRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBReturnsBooleanAndOtherRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBReturnsIfTrueRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBRuleIgnoredRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSearchingLiteralRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSendsDeprecatedMethodToGlobalRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSendsDifferentSuperRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSendsUnknownMessageToGlobalRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSentNotImplementedRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSizeCheckRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBStringConcatenationRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSubclassResponsibilityNotDefinedRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSuperSendsNewRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBTempVarOverridesInstVarRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBTemporaryOnlyReadRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBTemporaryOnlyWrittenRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBTemporaryVariableCapitalizationRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBTempsReadBeforeWrittenRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBThreeElementPointRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBTimesRepeatInsteadOfToDoRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBToDoCollectRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBToDoFillRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBToDoRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBToDoWithIncrementRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnclassifiedMethodsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUncommonMessageSendRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnconditionalRecursionRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUndeclaredReferenceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnnecessaryAssignmentRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnnecessaryCollectionCopyRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnnecessaryCollectionSizeRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnoptimizedAndOrRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnoptimizedToDoRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnpackagedCodeRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnreferencedTempsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUnreferencedVariablesRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUserDefinedRuleSet_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUsesAddRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUsesTrueRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBUtilityMethodsRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBVariableAssignedLiteralRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBVariableAssignedSameLiteralRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBVariableNotDefinedRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBVariableReferencedOnceRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBWhileTrueRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBYourselfNotUsedRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);

extern void _stx_137goodies_137refactoryBrowser_137lint_extensions_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);

void _libstx_goodies_refactoryBrowser_lint_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_refactoryBrowser_lint__DFN", _libstx_goodies_refactoryBrowser_lint_InitDefinition, "stx:goodies/refactoryBrowser/lint");
    _stx_137goodies_137refactoryBrowser_137lint_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_refactoryBrowser_lint_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_refactoryBrowser_lint", _libstx_goodies_refactoryBrowser_lint_Init, "stx:goodies/refactoryBrowser/lint");
    _LintRuleIgnoreAnnotation_Init(pass,__pRT__,snd);
    _RBEnvironmentSearchAction_Init(pass,__pRT__,snd);
    _RBLintRule_Init(pass,__pRT__,snd);
    _RBReadBeforeWrittenTester_Init(pass,__pRT__,snd);
    _SmalllintChecker_Init(pass,__pRT__,snd);
    _SmalllintContext_Init(pass,__pRT__,snd);
    _stx_137goodies_137refactoryBrowser_137lint_Init(pass,__pRT__,snd);
    _RBBasicLintRule_Init(pass,__pRT__,snd);
    _RBCompositeLintRule_Init(pass,__pRT__,snd);
    _RBEnvironmentStringSearchAction_Init(pass,__pRT__,snd);
    _RBEnvironmentStringSelectAction_Init(pass,__pRT__,snd);
    _RBEnvironmentVariableSearchAction_Init(pass,__pRT__,snd);
    _RBTransformationRule_Init(pass,__pRT__,snd);
    _RBAllAnyNoneSatisfyRule_Init(pass,__pRT__,snd);
    _RBAsNilIfEmptyRule_Init(pass,__pRT__,snd);
    _RBAssignmentInIfTrueRule_Init(pass,__pRT__,snd);
    _RBAtIfAbsentRule_Init(pass,__pRT__,snd);
    _RBBetweenAndRule_Init(pass,__pRT__,snd);
    _RBBlockLintRule_Init(pass,__pRT__,snd);
    _RBCascadedNextPutAllsRule_Init(pass,__pRT__,snd);
    _RBContainsToConformRule_Init(pass,__pRT__,snd);
    _RBCopyEliminationRule_Init(pass,__pRT__,snd);
    _RBCopyWithSizeToCopyXXXRule_Init(pass,__pRT__,snd);
    _RBDetectIfNoneRule_Init(pass,__pRT__,snd);
    _RBDetectIfNoneToIncludesRule_Init(pass,__pRT__,snd);
    _RBEmptyOrNilReplaceRule_Init(pass,__pRT__,snd);
    _RBEqualNilRule_Init(pass,__pRT__,snd);
    _RBFileOpenCloseToReadingFileRule_Init(pass,__pRT__,snd);
    _RBFindFirstToContainsRule_Init(pass,__pRT__,snd);
    _RBFixWrongPrecedenceRule_Init(pass,__pRT__,snd);
    _RBGuardClauseRule_Init(pass,__pRT__,snd);
    _RBIfNilIfNotNilReplaceRule_Init(pass,__pRT__,snd);
    _RBLintRuleSet_Init(pass,__pRT__,snd);
    _RBLoggingCodeReplaceRule_Init(pass,__pRT__,snd);
    _RBMinMaxRule_Init(pass,__pRT__,snd);
    _RBNilOrEmptyCollectionReplaceRule_Init(pass,__pRT__,snd);
    _RBNonPortableNonBlockValueSend_Init(pass,__pRT__,snd);
    _RBNotEliminationRule_Init(pass,__pRT__,snd);
    _RBNotNilAndNotEmptyReplaceRule_Init(pass,__pRT__,snd);
    _RBOldStyleMessagesRule_Init(pass,__pRT__,snd);
    _RBParseTreeLintRule_Init(pass,__pRT__,snd);
    _RBReplaceIfByIsNilNotNilRule_Init(pass,__pRT__,snd);
    _RBReturnFromHandlerBlocksRule_Init(pass,__pRT__,snd);
    _RBSTXSpecialCommentsRule_Init(pass,__pRT__,snd);
    _RBSelectCollectToSelectThenCollectRule_Init(pass,__pRT__,snd);
    _RBSelectToCountRule_Init(pass,__pRT__,snd);
    _RBShowWhileBlocksRule_Init(pass,__pRT__,snd);
    _RBSuperSendsRule_Init(pass,__pRT__,snd);
    _RBTempVarEliminationRule_Init(pass,__pRT__,snd);
    _RBTranslateLiteralsInDialogsReplaceRule_Init(pass,__pRT__,snd);
    _RBTranslateLiteralsInMenusReplaceRule_Init(pass,__pRT__,snd);
    _RBTranslateLiteralsInMenusRule_Init(pass,__pRT__,snd);
    _RBUnderscoreAssignmentRule_Init(pass,__pRT__,snd);
    _RBUnneededIfAfterBooleanAssignmentRule_Init(pass,__pRT__,snd);
    _RBUnneededIfNilAfterNilAssignmentRule_Init(pass,__pRT__,snd);
    _RBUnwindBlocksRule_Init(pass,__pRT__,snd);
    _RBUseBindWithRule_Init(pass,__pRT__,snd);
    _RBWrongOldStyleMessagesRule_Init(pass,__pRT__,snd);
    _RBAbstractClassRule_Init(pass,__pRT__,snd);
    _RBAddRemoveDependentsRule_Init(pass,__pRT__,snd);
    _RBApplicationModelChecksRule_Init(pass,__pRT__,snd);
    _RBAsOrderedCollectionNotNeededRule_Init(pass,__pRT__,snd);
    _RBAssignmentInBlockRule_Init(pass,__pRT__,snd);
    _RBAssignmentWithoutEffectRule_Init(pass,__pRT__,snd);
    _RBBadIdentityComparisonRule_Init(pass,__pRT__,snd);
    _RBBadMessageRule_Init(pass,__pRT__,snd);
    _RBBooleanPrecedenceRule_Init(pass,__pRT__,snd);
    _RBBuiltinRuleSet_Init(pass,__pRT__,snd);
    _RBClassInstVarNotInitializedRule_Init(pass,__pRT__,snd);
    _RBClassNameInSelectorRule_Init(pass,__pRT__,snd);
    _RBClassNotReferencedRule_Init(pass,__pRT__,snd);
    _RBClassVariableCapitalizationRule_Init(pass,__pRT__,snd);
    _RBCodeCruftLeftInMethodsRule_Init(pass,__pRT__,snd);
    _RBCodeDuplicationRule_Init(pass,__pRT__,snd);
    _RBCollectSelectNotUsedRule_Init(pass,__pRT__,snd);
    _RBCollectionCopyEmptyRule_Init(pass,__pRT__,snd);
    _RBCollectionMessagesToExternalObjectRule_Init(pass,__pRT__,snd);
    _RBCollectionPostCopyRule_Init(pass,__pRT__,snd);
    _RBCollectionProtocolRule_Init(pass,__pRT__,snd);
    _RBCollectionSearchProtocolRule_Init(pass,__pRT__,snd);
    _RBConsistencyCheck2Rule_Init(pass,__pRT__,snd);
    _RBConsistencyCheckRule_Init(pass,__pRT__,snd);
    _RBContainsNamespaceIdentifiersRule_Init(pass,__pRT__,snd);
    _RBContainsRule_Init(pass,__pRT__,snd);
    _RBContainsSmalltalkXEOLCommentRule_Init(pass,__pRT__,snd);
    _RBContainsSqueakArrayConstructorRule_Init(pass,__pRT__,snd);
    _RBContainsToIncludesRule_Init(pass,__pRT__,snd);
    _RBContainsVisualWorksBindingReferencesRule_Init(pass,__pRT__,snd);
    _RBDebuggingCodeLeftInMethodsRule_Init(pass,__pRT__,snd);
    _RBDefinesEqualNotHashRule_Init(pass,__pRT__,snd);
    _RBDefinesInitializeNotCalledRule_Init(pass,__pRT__,snd);
    _RBDetectBadCollectionUsesRule_Init(pass,__pRT__,snd);
    _RBDetectContainsRule_Init(pass,__pRT__,snd);
    _RBDoubleClassInitializationRule_Init(pass,__pRT__,snd);
    _RBDoubleTranslationsRule_Init(pass,__pRT__,snd);
    _RBEmptyExceptionHandlerRule_Init(pass,__pRT__,snd);
    _RBEmptyMethodWithoutCommentRule_Init(pass,__pRT__,snd);
    _RBEndTrueFalseRule_Init(pass,__pRT__,snd);
    _RBEqualNotUsedRule_Init(pass,__pRT__,snd);
    _RBEqualsTrueRule_Init(pass,__pRT__,snd);
    _RBEquivalentSuperclassMethodsRule_Init(pass,__pRT__,snd);
    _RBExcessiveArgumentsRule_Init(pass,__pRT__,snd);
    _RBExcessiveInheritanceRule_Init(pass,__pRT__,snd);
    _RBExcessiveMethodsRule_Init(pass,__pRT__,snd);
    _RBExcessiveVariablesRule_Init(pass,__pRT__,snd);
    _RBExeptOrganizationRule_Init(pass,__pRT__,snd);
    _RBExplicitClassCheckRule_Init(pass,__pRT__,snd);
    _RBExtraBlockRule_Init(pass,__pRT__,snd);
    _RBFileBlocksRule_Init(pass,__pRT__,snd);
    _RBFileStreamPossiblyNotClosedRule_Init(pass,__pRT__,snd);
    _RBFloatEqualityComparisonRule_Init(pass,__pRT__,snd);
    _RBFloatIdentityComparisonRule_Init(pass,__pRT__,snd);
    _RBGuardingClauseRule_Init(pass,__pRT__,snd);
    _RBIfTrueBlocksRule_Init(pass,__pRT__,snd);
    _RBIfTrueReturnsRule_Init(pass,__pRT__,snd);
    _RBImageSpecMethodWithBrokenImage_Init(pass,__pRT__,snd);
    _RBImageSpecMethodWithWrongKeyRule_Init(pass,__pRT__,snd);
    _RBImplementedNotSentRule_Init(pass,__pRT__,snd);
    _RBIncompatibleIdentifierInClassDefinitionRule_Init(pass,__pRT__,snd);
    _RBIncompatibleLocalIdentifierRule_Init(pass,__pRT__,snd);
    _RBIncompatibleSelectorRule_Init(pass,__pRT__,snd);
    _RBInconsistentMethodClassificationRule_Init(pass,__pRT__,snd);
    _RBInjectAllSatisfyAnySatisfyRule_Init(pass,__pRT__,snd);
    _RBInjectSubProductRule_Init(pass,__pRT__,snd);
    _RBInstVarInSubclassesRule_Init(pass,__pRT__,snd);
    _RBInstanceVariableCapitalizationRule_Init(pass,__pRT__,snd);
    _RBInvalidArgumentIdentifierRule_Init(pass,__pRT__,snd);
    _RBInvalidLocalIdentifierRule_Init(pass,__pRT__,snd);
    _RBJustSendsSuperRule_Init(pass,__pRT__,snd);
    _RBLawOfDemeterRule_Init(pass,__pRT__,snd);
    _RBLiteralArrayByteValuesRule_Init(pass,__pRT__,snd);
    _RBLiteralArrayCharactersRule_Init(pass,__pRT__,snd);
    _RBLiteralArrayContainsCommaRule_Init(pass,__pRT__,snd);
    _RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule_Init(pass,__pRT__,snd);
    _RBLongMethodsRule_Init(pass,__pRT__,snd);
    _RBMethodSourceContainsLinefeedsRule_Init(pass,__pRT__,snd);
    _RBMisplacedReturnInIfTrueIfFalseWithTempsRule_Init(pass,__pRT__,snd);
    _RBMissingSubclassResponsibilityRule_Init(pass,__pRT__,snd);
    _RBMissingSuperSendsRule_Init(pass,__pRT__,snd);
    _RBMissingTranslationInResourceFileRule_Init(pass,__pRT__,snd);
    _RBMissingTranslationsInMenusRule_Init(pass,__pRT__,snd);
    _RBMissingTranslationsRule_Init(pass,__pRT__,snd);
    _RBMissingYourselfRule_Init(pass,__pRT__,snd);
    _RBModifiesCollectionRule_Init(pass,__pRT__,snd);
    _RBMultipleDependenciesRule_Init(pass,__pRT__,snd);
    _RBNoClassCommentRule_Init(pass,__pRT__,snd);
    _RBNoMethodCommentRule_Init(pass,__pRT__,snd);
    _RBObfuscatedLazyInitializerRule_Init(pass,__pRT__,snd);
    _RBOnlyReadOrWrittenTemporaryRule_Init(pass,__pRT__,snd);
    _RBOnlyReadOrWrittenVariableRule_Init(pass,__pRT__,snd);
    _RBOverridesSpecialMessageRule_Init(pass,__pRT__,snd);
    _RBPlatformDependentUserInteractionRule_Init(pass,__pRT__,snd);
    _RBPrecedenceRule_Init(pass,__pRT__,snd);
    _RBQuestionableReturnFromEnsureBlocksRule_Init(pass,__pRT__,snd);
    _RBRefersToClassInPackageExcludedFromPrerequisitesRule_Init(pass,__pRT__,snd);
    _RBRefersToClassRule_Init(pass,__pRT__,snd);
    _RBRefersToConcreteOSClasses_Init(pass,__pRT__,snd);
    _RBRefersToPrivateClassRule_Init(pass,__pRT__,snd);
    _RBReturnInEnsureRule_Init(pass,__pRT__,snd);
    _RBReturnsBooleanAndOtherRule_Init(pass,__pRT__,snd);
    _RBReturnsIfTrueRule_Init(pass,__pRT__,snd);
    _RBRuleIgnoredRule_Init(pass,__pRT__,snd);
    _RBSearchingLiteralRule_Init(pass,__pRT__,snd);
    _RBSendsDeprecatedMethodToGlobalRule_Init(pass,__pRT__,snd);
    _RBSendsDifferentSuperRule_Init(pass,__pRT__,snd);
    _RBSendsUnknownMessageToGlobalRule_Init(pass,__pRT__,snd);
    _RBSentNotImplementedRule_Init(pass,__pRT__,snd);
    _RBSizeCheckRule_Init(pass,__pRT__,snd);
    _RBStringConcatenationRule_Init(pass,__pRT__,snd);
    _RBSubclassResponsibilityNotDefinedRule_Init(pass,__pRT__,snd);
    _RBSuperSendsNewRule_Init(pass,__pRT__,snd);
    _RBTempVarOverridesInstVarRule_Init(pass,__pRT__,snd);
    _RBTemporaryOnlyReadRule_Init(pass,__pRT__,snd);
    _RBTemporaryOnlyWrittenRule_Init(pass,__pRT__,snd);
    _RBTemporaryVariableCapitalizationRule_Init(pass,__pRT__,snd);
    _RBTempsReadBeforeWrittenRule_Init(pass,__pRT__,snd);
    _RBThreeElementPointRule_Init(pass,__pRT__,snd);
    _RBTimesRepeatInsteadOfToDoRule_Init(pass,__pRT__,snd);
    _RBToDoCollectRule_Init(pass,__pRT__,snd);
    _RBToDoFillRule_Init(pass,__pRT__,snd);
    _RBToDoRule_Init(pass,__pRT__,snd);
    _RBToDoWithIncrementRule_Init(pass,__pRT__,snd);
    _RBUnclassifiedMethodsRule_Init(pass,__pRT__,snd);
    _RBUncommonMessageSendRule_Init(pass,__pRT__,snd);
    _RBUnconditionalRecursionRule_Init(pass,__pRT__,snd);
    _RBUndeclaredReferenceRule_Init(pass,__pRT__,snd);
    _RBUnnecessaryAssignmentRule_Init(pass,__pRT__,snd);
    _RBUnnecessaryCollectionCopyRule_Init(pass,__pRT__,snd);
    _RBUnnecessaryCollectionSizeRule_Init(pass,__pRT__,snd);
    _RBUnoptimizedAndOrRule_Init(pass,__pRT__,snd);
    _RBUnoptimizedToDoRule_Init(pass,__pRT__,snd);
    _RBUnpackagedCodeRule_Init(pass,__pRT__,snd);
    _RBUnreferencedTempsRule_Init(pass,__pRT__,snd);
    _RBUnreferencedVariablesRule_Init(pass,__pRT__,snd);
    _RBUserDefinedRuleSet_Init(pass,__pRT__,snd);
    _RBUsesAddRule_Init(pass,__pRT__,snd);
    _RBUsesTrueRule_Init(pass,__pRT__,snd);
    _RBUtilityMethodsRule_Init(pass,__pRT__,snd);
    _RBVariableAssignedLiteralRule_Init(pass,__pRT__,snd);
    _RBVariableAssignedSameLiteralRule_Init(pass,__pRT__,snd);
    _RBVariableNotDefinedRule_Init(pass,__pRT__,snd);
    _RBVariableReferencedOnceRule_Init(pass,__pRT__,snd);
    _RBWhileTrueRule_Init(pass,__pRT__,snd);
    _RBYourselfNotUsedRule_Init(pass,__pRT__,snd);

    _stx_137goodies_137refactoryBrowser_137lint_extensions_Init(pass,__pRT__,snd);
  __END_PACKAGE__();
}