"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015-2016 Jan Vrany

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

"{ NameSpace: SmallSense }"

Object subclass:#CustomCodeGeneratorOrRefactoring
	instanceVariableNames:'compositeChangeCollector compositeChangeNesting userPreferences
		confirmChanges dialog changeManager model refactoryBuilder
		formatter resources'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

!CustomCodeGeneratorOrRefactoring class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015-2016 Jan Vrany

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
! !

!CustomCodeGeneratorOrRefactoring class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
!

subGeneratorOrRefactoringOf:aCodeGeneratorOrRefactoring
    "Returns and initializes new instance of code generator or refactoring
    to be used inside another code generator or refactoring."
    | nestingCount |

    nestingCount := aCodeGeneratorOrRefactoring compositeChangeNesting.
    nestingCount isNil ifTrue:[ nestingCount := 0 ].

    ^ self new
        model:aCodeGeneratorOrRefactoring model;
        refactoryBuilder:aCodeGeneratorOrRefactoring refactoryBuilder;
        userPreferences:aCodeGeneratorOrRefactoring userPreferences;
        dialog:aCodeGeneratorOrRefactoring dialog;
        changeManager:aCodeGeneratorOrRefactoring changeManager;
        compositeChangeCollector:aCodeGeneratorOrRefactoring compositeChangeCollector;
        compositeChangeNesting:(1 + nestingCount);
        yourself

    "Created: / 19-04-2014 / 10:15:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 13-10-2014 / 20:32:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring class methodsFor:'accessing-presentation'!

description
    "Returns more detailed description of the receiver"

    ^ self subclassResponsibility

    "Created: / 01-12-2013 / 00:18:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #()

    "Created: / 01-12-2013 / 00:21:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 05-08-2014 / 13:23:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."

    ^ self subclassResponsibility

    "Created: / 01-12-2013 / 00:18:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring class methodsFor:'enumerating'!

generatorsAndRefactoringsDo: aOneArgBlock
    "Evaluates a block through all generator or refactoring classes (actually all my subclasses)."

    self allSubclassesDo: aOneArgBlock

    "Created: / 28-12-2014 / 11:44:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring class methodsFor:'executing'!

executeInContext: aCustomContext
    ^ self new executeInContext: aCustomContext

    "Created: / 26-01-2014 / 13:42:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executeInContextWithWaitCursor: aCustomContext
    ^ self new executeInContextWithWaitCursor: aCustomContext

    "Created: / 10-08-2014 / 09:34:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring class methodsFor:'private'!

canUseRefactoringSupport
    "check if refactory browser stuff is avaliable"

    ^ (Smalltalk at: #'stx_goodies_refactoryBrowser_changes') notNil 
        and:[ (Smalltalk at: #'stx_goodies_refactoryBrowser_browser') notNil
        and:[ UserPreferences current useRefactoringSupport ] ]

    "Modified: / 13-02-2016 / 15:06:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring class methodsFor:'queries'!

availableForProgrammingLanguages
    "Returns list of programming language instances for which this generator / refactoring works.
    (SmalltalkLanguage instance, JavaLanguage instance, GroovyLanguage instance, etc.)

     See also availableForProgrammingLanguagesInContext:withPerspective:"

    "We are assuming here that majority will be written for Smalltalk."
    ^ {SmalltalkLanguage instance}

    "Created: / 22-12-2014 / 20:12:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

availableForProgrammingLanguagesInContext: aCustomContext
    "Returns true if generator / refactoring works for programming languages
     of codebase elements (classes, methods, etc.) in CustomContext instance.

     Called by the UI to figure out what generators / refactorings
     are available at given point. See class CustomMenuBuilder for details."

    | languages perspective |

    perspective := aCustomContext perspective.
    perspective isNil ifTrue: [
        "Rather no quess if perspective is missing"
        ^ true
    ].

    languages := self availableForProgrammingLanguages.

    perspective isCodeViewPerspective ifTrue: [
        ^ aCustomContext selectedCodes ? #() anySatisfy: [ :codeSelection |
            | method |

            method := codeSelection selectedMethod.

            method notNil and: [ languages includes: method programmingLanguage ]
        ].
    ].

    perspective isMethodPerspective ifTrue: [
        aCustomContext selectedMethods isEmptyOrNil ifTrue: [ ^ true ].  

        ^ aCustomContext selectedMethods anySatisfy: [ :method | 
            method notNil and: [ languages includes: method programmingLanguage ]
        ].
    ].

    (perspective isClassPerspective 
        or: [ perspective isInstanceVariablePerspective ] 
        or: [ perspective isProtocolPerspective ]) ifTrue: [

        aCustomContext selectedClasses isEmptyOrNil ifTrue: [ ^ true ].

        ^ aCustomContext selectedClasses anySatisfy: [ :class | 
            class notNil and: [ languages includes: class programmingLanguage ]
        ].
    ].

    "For other perspectives (package, class category, namespace) no guess"
    ^ true

    "Created: / 22-12-2014 / 20:34:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-12-2014 / 09:31:32 / root"
    "Modified: / 24-01-2015 / 18:24:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

availableInContext: aCustomContext
    "Returns true if the generator/refactoring is available in given
     context, false otherwise.

     Called by the UI to figure out what generators / refactorings
     are available at given point. See class CustomContext for details."

    ^ self subclassResponsibility

    "Created: / 01-12-2013 / 00:13:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

availableInPerspective:aCustomPerspective
    "Returns true if the generator/refactoring is available in given
     perspective, false otherwise.

     Called by the UI to figure out what generators / refactorings
     to show"

    ^ self subclassResponsibility

    "Created: / 26-01-2014 / 13:03:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring class methodsFor:'testing'!

isAbstract
    ^ self == CustomCodeGeneratorOrRefactoring

    "Created: / 26-01-2014 / 21:38:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCustomCodeGenerator
    ^ false
!

isCustomRefactoring
    ^ false
! !

!CustomCodeGeneratorOrRefactoring methodsFor:'accessing'!

changeManager

    ^ changeManager

    "Created: / 31-05-2014 / 13:29:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

changeManager: aChangeManager

    changeManager := aChangeManager

    "Created: / 31-05-2014 / 13:30:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

compositeChangeCollector

    ^ compositeChangeCollector

    "Created: / 19-04-2014 / 10:18:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

compositeChangeCollector: aCompositeChangeCollector

    compositeChangeCollector := aCompositeChangeCollector

    "Created: / 19-04-2014 / 10:18:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

compositeChangeNesting

    ^ compositeChangeNesting

    "Created: / 11-05-2014 / 14:01:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

compositeChangeNesting: aNumber

    compositeChangeNesting := aNumber

    "Created: / 11-05-2014 / 14:01:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

dialog

    ^ dialog

    "Created: / 11-05-2014 / 00:27:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

dialog: aDialog

    dialog := aDialog

    "Created: / 11-05-2014 / 00:27:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

formatter

    ^ formatter

    "Created: / 19-09-2014 / 22:18:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

formatter: aSourceCodeFormatter

    formatter := aSourceCodeFormatter

    "Created: / 19-09-2014 / 22:18:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

model
    ^model

    "Created: / 23-08-2014 / 00:13:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

model: aModel

    model := aModel

    "Created: / 23-08-2014 / 00:13:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 09-10-2014 / 10:17:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

refactoryBuilder

    ^ refactoryBuilder

    "Modified (format): / 23-08-2014 / 00:14:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

refactoryBuilder: aRefactoryBuilder

    refactoryBuilder := aRefactoryBuilder.

    "Modified (format): / 23-08-2014 / 00:14:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

sourceCodeGenerator

    ^ model sourceCodeGenerator

    "Created: / 19-09-2014 / 20:56:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 07-10-2014 / 22:47:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

userPreferences

    ^ userPreferences

    "Created: / 09-06-2014 / 21:49:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

userPreferences: aUserPreferences

    userPreferences := aUserPreferences

    "Created: / 09-06-2014 / 21:49:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring methodsFor:'bulk changes'!

executeCollectedChangesNamed:name
    "
    Same as CodeGeneratorTool >> executeCollectedChangesNamed:,
    but with custom RefactoryChangeManager and custom Dialog
    "

    compositeChangeCollector notNil ifTrue:[
        compositeChangeNesting := compositeChangeNesting - 1.
        compositeChangeNesting == 0 ifTrue:[
            compositeChangeCollector name:name.
            compositeChangeCollector changesSize == 0 ifTrue:[
                dialog information: (resources string: 'Nothing generated.').
            ] ifFalse:[
                changeManager performChange: compositeChangeCollector
            ].
            compositeChangeCollector := nil.
            self model changes: CompositeRefactoryChange new.
        ]
    ]

    "Created: / 31-05-2014 / 11:30:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 10:42:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 25-01-2015 / 14:31:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

startCollectChanges
    (self canUseRefactoringSupport) ifTrue:[
        compositeChangeCollector isNil ifTrue:[
            compositeChangeCollector := model changes.
            compositeChangeNesting := 0.
        ].
        compositeChangeNesting := compositeChangeNesting + 1.
    ]

    "Modified: / 16-11-2014 / 10:43:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring methodsFor:'code generation'!

addChange: aCodeChange

    aCodeChange notNil ifTrue: [
        compositeChangeCollector addChange: aCodeChange
    ]

    "Created: / 23-08-2014 / 15:40:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 17-09-2014 / 22:53:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring methodsFor:'compilation'!

compile:theCode forClass:aClass inCategory:cat
    "install some code for a class.
     If refactory browser stuff is avaliable the refactory tools are used to support undo"

    self
        compile:theCode forClass:aClass inCategory:cat
        skipIfSame:true
!

compile:theCode forClass:aClass inCategory:categoryOrNil skipIfSame:skipIfSame
    "Install some code for a class.
    If refactory browser stuff is avaliable the refactory tools are used to support undo
    (determined by aClass - can be RBClass/RBMetaclass instance or real class)"

    |compiler selector oldMethod isSame category|

    isSame := false.
    category := categoryOrNil ? (Compiler defaultMethodCategory).

    skipIfSame ifTrue:[
        compiler := aClass compilerClass new.
        compiler parseMethod:theCode in:aClass ignoreErrors:true ignoreWarnings:true.

        selector := compiler selector.
        selector notNil ifTrue:[
            oldMethod := aClass compiledMethodAt:selector.
            isSame := (oldMethod notNil and:[oldMethod source = theCode]).
            isSame ifTrue:[^ self ].
            oldMethod notNil ifTrue:[
                category := categoryOrNil ? (oldMethod category).
            ].
        ].
    ].

    aClass compile: theCode classified: category.

    "Modified: / 21-08-2006 / 18:39:06 / cg"
    "Modified (format): / 21-01-2012 / 10:40:59 / cg"
    "Modified (comment): / 08-02-2015 / 19:40:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring methodsFor:'executing'!

executeInContext: aCustomContext
    | context |

    context := aCustomContext copyWithModel: self model.

    self startCollectChanges.

    context isInteractiveContext ifTrue:[
        self configureInContext: context
    ].

    self validateInContext: context.
    self buildInContext: context.

    self executeCollectedChangesNamed: self class description.

    self updateInContext: context.

    "Created: / 19-03-2014 / 18:45:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-11-2014 / 21:07:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-08-2015 / 13:29:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executeInContextWithWaitCursor: aCustomContext
    "Much like executeInContext: but with loading cursor animation"

    | wg executor |

    wg := WindowGroup activeGroup.
    wg isNil ifTrue:[
        executor := [:whatToDo | whatToDo value ]
    ] ifFalse:[
        executor := [:whatToDo | wg withWaitCursorDo: [ whatToDo value ] ]
    ].

    executor value:[
        self executeInContext: aCustomContext
    ]

    "Created: / 07-08-2014 / 23:17:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

executeSubGeneratorOrRefactoringClasses:aSubGeneratorOrRefactoringClasses inContext:aCustomContext
    "For each code generator or refactoring class initializes an instance
    and executes it."

    aSubGeneratorOrRefactoringClasses do:[ :class | 
        (class subGeneratorOrRefactoringOf:self)
            executeInContext:aCustomContext
    ]

    "Created: / 08-07-2014 / 18:31:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 13-10-2014 / 20:25:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring methodsFor:'executing - private'!

buildInContext:aCustomContext
    "Should generate code or perform custom refactoring."

    ^ self subclassResponsibility

    "Created: / 16-09-2014 / 09:14:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 13-10-2014 / 17:21:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

configureInContext:aCustomContext
    "Perform neccessary configuration for given context, such as
     computing default values for parameters. This may interact with
     user by means of opening a dialog.

     This method is called only for interactive contexts. When using
     non interactively, a caller must do the configuration itself by means
     of accessors."

    "/ To be overridden by subclasses

    "Created: / 16-09-2014 / 07:24:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 16-09-2014 / 11:00:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateInContext: aContext
    "Update the context so it points to generated class/methods. To be overriden by subclasses."

    "Created: / 29-08-2015 / 13:29:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateInContext: aCustomContext

    "/ To be overridden by subclasses

    "Created: / 16-09-2014 / 09:45:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring methodsFor:'initialization'!

confirmChanges
    "if true, let user confirm complicated changes; if false, just do it"

    ^ confirmChanges ? true

    "Created: / 04-08-2011 / 17:31:45 / cg"
!

confirmChanges:aBoolean
    "if true, let user confirm complicated changes; if false, just do it"

    confirmChanges := aBoolean

    "Created: / 04-08-2011 / 17:26:47 / cg"
!

initialize

    userPreferences := UserPreferences current.
    "Translated dialogs have to be in part of browser, so use browser resources"
    resources := Tools::NewSystemBrowser classResources.

    self initializeFormatter;
        initializeChangeManager;
        initializeModel;
        initializeRefactoryBuilder;
        initializeDialog.

    "Created: / 17-03-2014 / 22:27:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 08-02-2015 / 20:17:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

initializeChangeManager
    changeManager := CustomBrowserChangeManager new.

    "Created: / 09-06-2014 / 22:56:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

initializeDialog
    dialog := CustomUserDialog new.

    "Created: / 09-06-2014 / 22:57:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

initializeFormatter
    formatter := CustomRBLocalSourceCodeFormatter new

    "Created: / 18-09-2014 / 23:12:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

initializeModel
    model := (CustomNamespace new)
            formatter:formatter;
            changeManager:changeManager;
            yourself

    "Created: / 09-06-2014 / 22:56:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 10:41:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

initializeRefactoryBuilder
    refactoryBuilder := (CustomRefactoryBuilder new)
            formatter:formatter;
            changeManager:changeManager;
            model:model;
            yourself

    "Created: / 23-08-2014 / 00:05:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 10:41:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoring methodsFor:'private'!

canUseRefactoringSupport
    "check if refactory browser stuff is avaliable"

     ^ self class canUseRefactoringSupport
! !

!CustomCodeGeneratorOrRefactoring methodsFor:'testing'!

isCustomCodeGenerator
    ^ false
!

isCustomRefactoring
    ^ false
! !

!CustomCodeGeneratorOrRefactoring class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

