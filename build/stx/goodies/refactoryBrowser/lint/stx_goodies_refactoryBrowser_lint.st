"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

 Permission is hereby granted, free of charge, to any
 person obtaining a copy of this software and associated
 documentation files (the 'Software'), to deal in the
 Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute,
 sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so,
 subject to the following conditions:

 The above copyright notice and this permission notice shall
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_refactoryBrowser_lint
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_refactoryBrowser_lint class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

 Permission is hereby granted, free of charge, to any
 person obtaining a copy of this software and associated
 documentation files (the 'Software'), to deal in the
 Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute,
 sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so,
 subject to the following conditions:

 The above copyright notice and this permission notice shall
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
!

documentation
"
    Package documentation:

    Various lint checks and transformations,
    based originally on Squeak/Pharo code,
    with many enhancements and additional rules for ST/X.
"
! !

!stx_goodies_refactoryBrowser_lint class methodsFor:'description'!

excludedFromPreRequisites
    "obsolete; temporarily, this is still called for, but will eventually vanish.
    
     List packages which are to be explicitely excluded from the automatic constructed
     prerequisites lists (both). 
     If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #(
        #'stx:goodies/refactoryBrowser/browser'    "BrowserEnvironmentWrapper - extended"
        #'stx:goodies/refactoryBrowser/helpers'    "BrowserEnvironment - extended"
        #'stx:goodies/refactoryBrowser/parser'    "RBProgramNodeVisitor - superclass of RBUnreferencedTempsRule::VariableSearcher"
        #'stx:libbasic'    "Annotation - extended"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #(
        #'stx:goodies/refactoryBrowser/changes'    "AddMethodChange - referenced by RBContainsSmalltalkXEOLCommentRule>>changes"
        #'stx:goodies/sunit'    "TestCase - referenced by RBClassNotReferencedRule>>checkClass:"
        #'stx:libbasic2'    "HTMLUtilities - referenced by RBMissingTranslationInResourceFileRule>>rationale"
        #'stx:libbasic3'    "AbstractSourceCodeManager - referenced by RBNoMethodCommentRule>>checkMethod:"
        #'stx:libcompat'    "Preferences - referenced by RBSendsUnknownMessageToGlobalRule>>initialize"
        #'stx:libtool'    "SystemBrowser - referenced by RBApplicationModelChecksRule>>checkClass:"
        #'stx:libview'    "Color - referenced by RBBuiltinRuleSet>>displayString"
        #'stx:libview2'    "ApplicationModel - referenced by RBApplicationModelChecksRule>>checkClass:"
        #'stx:libwidg'    "TextCollector - referenced by RBSendsUnknownMessageToGlobalRule>>initialize"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites."

    ^ #( #'stx:goodies/refactoryBrowser/lint/spelling' )
! !

!stx_goodies_refactoryBrowser_lint class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        LintRuleIgnoreAnnotation
        RBEnvironmentSearchAction
        RBLintRule
        RBReadBeforeWrittenTester
        SmalllintChecker
        SmalllintContext
        #'stx_goodies_refactoryBrowser_lint'
        RBBasicLintRule
        RBCompositeLintRule
        RBEnvironmentStringSearchAction
        RBEnvironmentStringSelectAction
        RBEnvironmentVariableSearchAction
        RBTransformationRule
        RBAllAnyNoneSatisfyRule
        RBAsNilIfEmptyRule
        RBAssignmentInIfTrueRule
        RBAtIfAbsentRule
        RBBetweenAndRule
        RBBlockLintRule
        RBCascadedNextPutAllsRule
        RBContainsToConformRule
        RBCopyEliminationRule
        RBCopyWithSizeToCopyXXXRule
        RBDetectIfNoneRule
        RBDetectIfNoneToIncludesRule
        RBEmptyOrNilReplaceRule
        RBEqualNilRule
        RBFileOpenCloseToReadingFileRule
        RBFindFirstToContainsRule
        RBFixWrongPrecedenceRule
        RBGuardClauseRule
        RBIfNilIfNotNilReplaceRule
        RBLintRuleSet
        RBLoggingCodeReplaceRule
        RBMinMaxRule
        RBNilOrEmptyCollectionReplaceRule
        RBNonPortableNonBlockValueSend
        RBNotEliminationRule
        RBNotNilAndNotEmptyReplaceRule
        RBOldStyleMessagesRule
        RBParseTreeLintRule
        RBReplaceIfByIsNilNotNilRule
        RBReturnFromHandlerBlocksRule
        RBSTXSpecialCommentsRule
        RBSelectCollectToSelectThenCollectRule
        RBSelectToCountRule
        RBShowWhileBlocksRule
        RBSuperSendsRule
        RBTempVarEliminationRule
        RBTranslateLiteralsInDialogsReplaceRule
        RBTranslateLiteralsInMenusReplaceRule
        RBTranslateLiteralsInMenusRule
        RBUnderscoreAssignmentRule
        RBUnneededIfAfterBooleanAssignmentRule
        RBUnneededIfNilAfterNilAssignmentRule
        RBUnwindBlocksRule
        RBUseBindWithRule
        RBWrongOldStyleMessagesRule
        RBAbstractClassRule
        RBAddRemoveDependentsRule
        RBApplicationModelChecksRule
        RBAsOrderedCollectionNotNeededRule
        RBAssignmentInBlockRule
        RBAssignmentWithoutEffectRule
        RBBadIdentityComparisonRule
        RBBadMessageRule
        RBBooleanPrecedenceRule
        RBBuiltinRuleSet
        RBClassInstVarNotInitializedRule
        RBClassNameInSelectorRule
        RBClassNotReferencedRule
        RBClassVariableCapitalizationRule
        RBCodeCruftLeftInMethodsRule
        RBCodeDuplicationRule
        RBCollectSelectNotUsedRule
        RBCollectionCopyEmptyRule
        RBCollectionMessagesToExternalObjectRule
        RBCollectionPostCopyRule
        RBCollectionProtocolRule
        RBCollectionSearchProtocolRule
        RBConsistencyCheck2Rule
        RBConsistencyCheckRule
        RBContainsNamespaceIdentifiersRule
        RBContainsRule
        RBContainsSmalltalkXEOLCommentRule
        RBContainsSqueakArrayConstructorRule
        RBContainsToIncludesRule
        RBContainsVisualWorksBindingReferencesRule
        RBDebuggingCodeLeftInMethodsRule
        RBDefinesEqualNotHashRule
        RBDefinesInitializeNotCalledRule
        RBDetectBadCollectionUsesRule
        RBDetectContainsRule
        RBDoubleClassInitializationRule
        RBDoubleTranslationsRule
        RBEmptyExceptionHandlerRule
        RBEmptyMethodWithoutCommentRule
        RBEndTrueFalseRule
        RBEqualNotUsedRule
        RBEqualsTrueRule
        RBEquivalentSuperclassMethodsRule
        RBExcessiveArgumentsRule
        RBExcessiveInheritanceRule
        RBExcessiveMethodsRule
        RBExcessiveVariablesRule
        RBExeptOrganizationRule
        RBExplicitClassCheckRule
        RBExtraBlockRule
        RBFileBlocksRule
        RBFileStreamPossiblyNotClosedRule
        RBFloatEqualityComparisonRule
        RBFloatIdentityComparisonRule
        RBGuardingClauseRule
        RBIfTrueBlocksRule
        RBIfTrueReturnsRule
        RBImageSpecMethodWithBrokenImage
        RBImageSpecMethodWithWrongKeyRule
        RBImplementedNotSentRule
        RBIncompatibleIdentifierInClassDefinitionRule
        RBIncompatibleLocalIdentifierRule
        RBIncompatibleSelectorRule
        RBInconsistentMethodClassificationRule
        RBInjectAllSatisfyAnySatisfyRule
        RBInjectSubProductRule
        RBInstVarInSubclassesRule
        RBInstanceVariableCapitalizationRule
        RBInvalidArgumentIdentifierRule
        RBInvalidLocalIdentifierRule
        RBJustSendsSuperRule
        RBLawOfDemeterRule
        RBLiteralArrayByteValuesRule
        RBLiteralArrayCharactersRule
        RBLiteralArrayContainsCommaRule
        RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule
        RBLongMethodsRule
        RBMethodSourceContainsLinefeedsRule
        RBMisplacedReturnInIfTrueIfFalseWithTempsRule
        RBMissingSubclassResponsibilityRule
        RBMissingSuperSendsRule
        RBMissingTranslationInResourceFileRule
        RBMissingTranslationsInMenusRule
        RBMissingTranslationsRule
        RBMissingYourselfRule
        RBModifiesCollectionRule
        RBMultipleDependenciesRule
        RBNoClassCommentRule
        RBNoMethodCommentRule
        RBObfuscatedLazyInitializerRule
        RBOnlyReadOrWrittenTemporaryRule
        RBOnlyReadOrWrittenVariableRule
        RBOverridesSpecialMessageRule
        RBPlatformDependentUserInteractionRule
        RBPrecedenceRule
        RBQuestionableReturnFromEnsureBlocksRule
        RBRefersToClassInPackageExcludedFromPrerequisitesRule
        RBRefersToClassRule
        RBRefersToConcreteOSClasses
        RBRefersToPrivateClassRule
        RBReturnInEnsureRule
        RBReturnsBooleanAndOtherRule
        RBReturnsIfTrueRule
        RBRuleIgnoredRule
        RBSearchingLiteralRule
        RBSendsDeprecatedMethodToGlobalRule
        RBSendsDifferentSuperRule
        RBSendsUnknownMessageToGlobalRule
        RBSentNotImplementedRule
        RBSizeCheckRule
        RBStringConcatenationRule
        RBSubclassResponsibilityNotDefinedRule
        RBSuperSendsNewRule
        RBTempVarOverridesInstVarRule
        RBTemporaryOnlyReadRule
        RBTemporaryOnlyWrittenRule
        RBTemporaryVariableCapitalizationRule
        RBTempsReadBeforeWrittenRule
        RBThreeElementPointRule
        RBTimesRepeatInsteadOfToDoRule
        RBToDoCollectRule
        RBToDoFillRule
        RBToDoRule
        RBToDoWithIncrementRule
        RBUnclassifiedMethodsRule
        RBUncommonMessageSendRule
        RBUnconditionalRecursionRule
        RBUndeclaredReferenceRule
        RBUnnecessaryAssignmentRule
        RBUnnecessaryCollectionCopyRule
        RBUnnecessaryCollectionSizeRule
        RBUnoptimizedAndOrRule
        RBUnoptimizedToDoRule
        RBUnpackagedCodeRule
        RBUnreferencedTempsRule
        RBUnreferencedVariablesRule
        RBUserDefinedRuleSet
        RBUsesAddRule
        RBUsesTrueRule
        RBUtilityMethodsRule
        RBVariableAssignedLiteralRule
        RBVariableAssignedSameLiteralRule
        RBVariableNotDefinedRule
        RBVariableReferencedOnceRule
        RBWhileTrueRule
        RBYourselfNotUsedRule
        (Smalllint autoload)
        (RBDuplicatedCodeRule autoload)
        (RBAssignmentInConditionRule autoload)
        (RBDuplicatedAstRule autoload)
        (RBDuplicatedBytesRule autoload)
        (RBDuplicatedCodeRule autoload)
        (RBDuplicatedTokenRule autoload)
        (RBDuplicatedAstRule autoload)
        (RBDuplicatedBytesRule autoload)
        (RBDuplicatedTokenRule autoload)
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        BrowserEnvironment includesMethod:
        BrowserEnvironment methodsInto:
        RestrictedEnvironment classesInto:
        RestrictedEnvironment methodsInto:
        SelectorEnvironment classesInto:
        SelectorEnvironment methodsInto:
        VariableEnvironment classesInto:
        VariableEnvironment methodsInto:
        'Annotation class' ignore:rationale:
        'Annotation class' ignore:rationale:author:
        'Annotation class' ignoreLintRule:rationale:author:
        'Annotation class' lint:rationale:author:
        UserPreferences smallLintRulesetDefault
        UserPreferences smallLintRulesetDefault:
        UserPreferences smallLintRulesets
        UserPreferences smallLintRulesets:
        UserPreferences smallLintRulesetsUserDefined:
        UserPreferences smallLintRulesetsUserDefined
    )
! !

!stx_goodies_refactoryBrowser_lint class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Refactoring Inc. / eXept Software AG'

    "Modified: / 18-11-2016 / 11:53:06 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Refactoring Lint'

    "Modified: / 07-11-2006 / 11:39:11 / cg"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Refactoring Inc.\nCopyright Claus Gittinger\nCopyright Claus Gittinger\nCopyright eXept Software AG 2006'

    "Modified: / 18-11-2016 / 12:15:24 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_refactoryBrowser_lint class methodsFor:'description - svn'!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'Nicht versioniertes Verzeichnis'"$"
! !

!stx_goodies_refactoryBrowser_lint class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

