"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense/refactoring_custom' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_smallsense_refactoring_custom
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_smallsense_refactoring_custom class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
!

documentation
"
    Package documentation:

    API for custom code generation and refactoring.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>
"
! !

!stx_goodies_smallsense_refactoring_custom class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:goodies/refactoryBrowser/changes'    "AddClassChange - extended"
        #'stx:goodies/refactoryBrowser/helpers'    "RBAbstractClass - extended"
        #'stx:goodies/refactoryBrowser/parser'    "ParseTreeRewriter - superclass of SmallSense::CustomParseTreeRewriter"
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_smallsense_refactoring_custom"
        #'stx:libtool'    "CodeGenerator - superclass of SmallSense::CustomSourceCodeGenerator"
        #'stx:libview2'    "ApplicationModel - extended"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     We do not need these packages as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes."

    ^ #(
        #'stx:goodies/sunit'    "TestCase - referenced by SmallSense::CustomTestCaseCodeGenerator class>>availableInContext:"
        #'stx:libcomp'    "Parser - referenced by RBMethod>>newSource"
        #'stx:libjava'    "JavaLanguage - referenced by SmallSense::CustomJavaSimpleSetterMethodsCodeGenerator class>>availableForProgrammingLanguages"
        #'stx:libjava/tools'    "JavaCompiler - referenced by SmallSense::CustomJavaSimpleSetterMethodsCodeGenerator>>buildInContext:"
        #'stx:libjavascript'    "STXJavaScriptLanguage - referenced by SmallSense::CustomJavaScriptSimpleSetterMethodsCodeGenerator class>>availableForProgrammingLanguages"
        #'stx:libview'    "WindowGroup - referenced by SmallSense::CustomCodeGeneratorOrRefactoring>>executeInContextWithWaitCursor:"
        #'stx:libwidg'    "DialogBox - referenced by SmallSense::CustomUserDialog>>initialize"
        #'stx:libwidg2'    "CheckBox - referenced by SmallSense::CustomDialog>>addCheckBoxOn:labeled:"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
    )

    "Modified: / 19-02-2015 / 06:04:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_smallsense_refactoring_custom class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'SmallSense::CustomChangeManager'
        #'SmallSense::CustomClassQuery'
        #'SmallSense::CustomCodeGeneratorOrRefactoring'
        #'SmallSense::CustomContext'
        #'SmallSense::CustomDialog'
        #'SmallSense::CustomManager'
        #'SmallSense::CustomMenuBuilder'
        #'SmallSense::CustomMock'
        #'SmallSense::CustomNamespace'
        #'SmallSense::CustomParseTreeRewriter'
        #'SmallSense::CustomPerspective'
        #'SmallSense::CustomRefactoryBuilder'
        #'SmallSense::CustomSourceCodeFormatter'
        #'SmallSense::CustomSourceCodeGenerator'
        #'SmallSense::CustomSourceCodeSelection'
        #'SmallSense::CustomTestCaseHelper'
        #'stx_goodies_smallsense_refactoring_custom'
        #'SmallSense::CustomBrowserChangeManager'
        #'SmallSense::CustomBrowserContext'
        #'SmallSense::CustomCodeGenerator'
        #'SmallSense::CustomLocalChangeManager'
        #'SmallSense::CustomNoneSourceCodeFormatter'
        #'SmallSense::CustomRBLocalSourceCodeFormatter'
        #'SmallSense::CustomRefactoring'
        #'SmallSense::CustomSilentDialog'
        #'SmallSense::CustomSubContext'
        #'SmallSense::CustomUserDialog'
        #'SmallSense::CustomAccessMethodsCodeGenerator'
        #'SmallSense::CustomCodeSelectionRefactoring'
        #'SmallSense::CustomInspectorTabCodeGenerator'
        #'SmallSense::CustomIsAbstractCodeGenerator'
        #'SmallSense::CustomJavaSimpleSetterMethodsCodeGenerator'
        #'SmallSense::CustomNewClassGenerator'
        #'SmallSense::CustomReplaceIfNilWithIfTrueRefactoring'
        #'SmallSense::CustomSubclassResponsibilityCodeGenerator'
        #'SmallSense::CustomTestCaseCodeGenerator'
        #'SmallSense::CustomTestCaseMethodCodeGenerator'
        #'SmallSense::CustomTestCaseSetUpCodeGenerator'
        #'SmallSense::CustomTestCaseTearDownCodeGenerator'
        #'SmallSense::CustomUpdateTestCaseCategoryRefactoring'
        #'SmallSense::CustomVisitorCodeGenerator'
        #'SmallSense::CustomChangeNotificationAccessMethodsCodeGenerator'
        #'SmallSense::CustomChangeNotificationSetterMethodsCodeGenerator'
        #'SmallSense::CustomCodeGeneratorClassGenerator'
        #'SmallSense::CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator'
        #'SmallSense::CustomCodeSelectionToResourceTranslation'
        #'SmallSense::CustomDefaultGetterMethodsCodeGenerator'
        #'SmallSense::CustomLazyInitializationAccessMethodsCodeGenerator'
        #'SmallSense::CustomLazyInitializationGetterMethodsCodeGenerator'
        #'SmallSense::CustomMultiSetterMethodsCodeGenerator'
        #'SmallSense::CustomPrintCodeSelectionRefactoring'
        #'SmallSense::CustomRefactoringClassGenerator'
        #'SmallSense::CustomSimpleAccessMethodsCodeGenerator'
        #'SmallSense::CustomSimpleGetterMethodsCodeGenerator'
        #'SmallSense::CustomSimpleSetterMethodsCodeGenerator'
        #'SmallSense::CustomUITestCaseCodeGenerator'
        #'SmallSense::CustomUITestCaseSetUpCodeGenerator'
        #'SmallSense::CustomValueHolderAccessMethodsCodeGenerator'
        #'SmallSense::CustomValueHolderGetterMethodsCodeGenerator'
        #'SmallSense::CustomValueHolderWithChangeNotificationAccessMethodsCodeGenerator'
        #'SmallSense::CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator'
        #'SmallSense::CustomValueHolderWithChangeNotificationSetterMethodsCodeGenerator'
        #'SmallSense::CustomVisitorCodeGeneratorAcceptVisitor'
        #'SmallSense::CustomJavaScriptSimpleSetterMethodsCodeGenerator'
        (#'SmallSense::CustomAccessMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomAddClassChangeTests' autoload)
        (#'SmallSense::CustomAddMethodChangeTests' autoload)
        (#'SmallSense::CustomBrowserContextTests' autoload)
        (#'SmallSense::CustomBrowserEnvironmentTests' autoload)
        (#'SmallSense::CustomChangeNotificationAccessMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomChangeNotificationSetterMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomClassQueryTests' autoload)
        (#'SmallSense::CustomCodeGeneratorClassGeneratorTests' autoload)
        (#'SmallSense::CustomCodeGeneratorOrRefactoringTestCase' autoload)
        (#'SmallSense::CustomCodeGeneratorOrRefactoringTests' autoload)
        (#'SmallSense::CustomCodeGeneratorTests' autoload)
        (#'SmallSense::CustomCodeGeneratorUserPreferencesTests' autoload)
        (#'SmallSense::CustomCodeSelectionToResourceTranslationTests' autoload)
        (#'SmallSense::CustomContextTests' autoload)
        (#'SmallSense::CustomDefaultGetterMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomIsAbstractCodeGeneratorTests' autoload)
        (#'SmallSense::CustomJavaScriptSimpleSetterMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomLazyInitializationAccessMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomLazyInitializationGetterMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomLocalChangeManagerTests' autoload)
        (#'SmallSense::CustomManagerTests' autoload)
        (#'SmallSense::CustomMenuBuilderTests' autoload)
        (#'SmallSense::CustomMockTests' autoload)
        (#'SmallSense::CustomMultiSetterMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomNamespaceTests' autoload)
        (#'SmallSense::CustomNewClassGeneratorTests' autoload)
        (#'SmallSense::CustomNewSystemBrowserTests' autoload)
        (#'SmallSense::CustomNoneSourceCodeFormatterTests' autoload)
        (#'SmallSense::CustomParseTreeRewriterTests' autoload)
        (#'SmallSense::CustomPerspectiveTests' autoload)
        (#'SmallSense::CustomRBAbstractClassTests' autoload)
        (#'SmallSense::CustomRBClassTests' autoload)
        (#'SmallSense::CustomRBLocalSourceCodeFormatterTests' autoload)
        (#'SmallSense::CustomRBMetaclassTests' autoload)
        (#'SmallSense::CustomRBMethodTests' autoload)
        (#'SmallSense::CustomRefactoringClassGeneratorTests' autoload)
        (#'SmallSense::CustomRefactoryBuilderTests' autoload)
        (#'SmallSense::CustomRefactoryClassChangeTests' autoload)
        (#'SmallSense::CustomReplaceIfNilWithIfTrueRefactoringTests' autoload)
        (#'SmallSense::CustomSimpleAccessMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomSimpleGetterMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomSimpleSetterMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomSourceCodeGeneratorTests' autoload)
        (#'SmallSense::CustomSourceCodeSelectionTests' autoload)
        (#'SmallSense::CustomSubContextTests' autoload)
        (#'SmallSense::CustomSubclassResponsibilityCodeGeneratorTests' autoload)
        (#'SmallSense::CustomTestCaseCodeGeneratorTests' autoload)
        (#'SmallSense::CustomTestCaseHelperTests' autoload)
        (#'SmallSense::CustomTestCaseMethodCodeGeneratorTests' autoload)
        (#'SmallSense::CustomTestCaseSetUpCodeGeneratorTests' autoload)
        (#'SmallSense::CustomTestCaseTearDownCodeGeneratorTests' autoload)
        (#'SmallSense::CustomUpdateTestCaseCategoryRefactoringTests' autoload)
        (#'SmallSense::CustomValueHolderAccessMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomValueHolderGetterMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomValueHolderWithChangeNotificationAccessMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomValueHolderWithChangeNotificationGetterMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomValueHolderWithChangeNotificationSetterMethodsCodeGeneratorTests' autoload)
        (#'SmallSense::CustomVisitorCodeGeneratorAcceptVisitorTests' autoload)
        (#'SmallSense::CustomVisitorCodeGeneratorTests' autoload)
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        #'Tools::NewSystemBrowser' selectorMenuExtensionCustomRefactorings:
        #'Tools::NewSystemBrowser' classMenuExtensionCustomGenerators:
        #'Tools::NewSystemBrowser' codeViewMenuExtensionCustomRefactorings:
        #'Tools::NewSystemBrowser' selectorMenuExtensionCustomGenerators:
        #'Tools::NewSystemBrowser' variablesMenuExtensionCustomGenerators:
        RBAbstractClass allClassVarNames
        RBAbstractClass allSuperclassesDo:
        RBAbstractClass instVarNames
        RBAbstractClass methodDictionary
        RBAbstractClass nameWithoutPrefix
        RBAbstractClass superclassName:
        RBAbstractClass theMetaclass
        RBAbstractClass theNonMetaclass
        RBAbstractClass withAllSuperclassesDo:
        RBClass compile
        RBClass theNonMetaClass
        RBMetaclass theMetaClass
        RBMetaclass theMetaclass
        RBAbstractClass instVarNames:
        RBMethod sends:or:
        RBMethod category:
        RBMethod class:
        RBMethod compile
        RBMethod methodArgNames
        RBMethod methodDefinitionTemplate
        RBMethod model
        RBMethod model:
        RBMethod protocol
        RBMethod protocol:
        RBMethod replace:with:
        RBMethod sourceCodeGenerator
        RBMethod sourceCodeGenerator:
        AddClassChange package
        AddClassChange package:
        AddMethodChange package:
        RBAbstractClass compileMethod:
        RBAbstractClass package
        RBAbstractClass package:
        RBMethod newSource
        RBMethod package:
        RBAbstractClass inheritsFrom:
        RBAbstractClass isSubclassOf:
        RBAbstractClass instAndClassMethodsDo:
        RBAbstractClass methodsDo:
        RefactoryChange model
        RefactoryChange model:
        #'Tools::NewSystemBrowser' classMenuExtensionCustomRefactorings:
        AddClassChange argumensBySelectorPartsFromMessage:
        AddClassChange privateInClassName
        AddClassChange privateInClassName:
        RBAbstractClass compilerClass
        RBAbstractClass isLoaded
        RBAbstractClass privateClassesAt:
        RBAbstractClass realSharedPoolNames
        RBAbstractClass topNameSpace
        RBMetaclass owningClass
        RBMetaclass owningClass:
        RBMethod mclass
        RBAbstractClass owningClass
        RBAbstractClass owningClass:
        RBAbstractClass owningClassOrYourself
        RBAbstractClass topOwningClass
        RBMetaclass topOwningClass
        RBAbstractClass isAbstract:
        RBAbstractClass programmingLanguage
        RBMethod programmingLanguage
        #'Tools::NewSystemBrowser' classMenuExtensionNavigateToTestCase:
        #'Tools::NewSystemBrowser' customMenuBuilder
        RBAbstractClass sourceCodeAt:
    )
! !

!stx_goodies_smallsense_refactoring_custom class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'My Company'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Class Library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Jakub Nesveda 2013-2015 & Jan Vrany 2013-now'

    "Modified: / 05-05-2015 / 23:56:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'ProductName'
! !

!stx_goodies_smallsense_refactoring_custom class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

