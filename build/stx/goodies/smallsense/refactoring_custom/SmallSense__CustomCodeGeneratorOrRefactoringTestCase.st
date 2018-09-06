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

"{ NameSpace: SmallSense }"

Smalltalk::TestCase subclass:#CustomCodeGeneratorOrRefactoringTestCase
	instanceVariableNames:'context model refactoryBuilder generatorOrRefactoring classes
		changeManager userPreferences mock formatter dialog'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomCodeGeneratorOrRefactoringTestCase class methodsFor:'documentation'!

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
! !

!CustomCodeGeneratorOrRefactoringTestCase methodsFor:'accessing'!

generatorOrRefactoring
    "Should return an instance of CustomCodeGenerator or CustomRefactoring subclass"

    ^ self subclassResponsibility

    "Created: / 27-05-2014 / 19:16:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 23-08-2014 / 11:38:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTestCase methodsFor:'asserting'!

assertClassExists: aClassName

    self assert: (Smalltalk classNamed: aClassName asString) isNil not

    "Created: / 15-06-2014 / 16:42:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

assertClassMethodSource: aSourceCode atSelector: aSelector
    "Assert that source code is same at given selector for first generated class"

    | className class |

    className := classes first name.
    class := Smalltalk classNamed: className.

    ^ self assertClassMethodSource: aSourceCode atSelector: aSelector forClass: class

    "Created: / 11-07-2014 / 20:11:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 08-10-2014 / 18:58:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

assertClassMethodSource: expectedSource atSelector: aSelector forClass: aClass
    "Assert that source code is same at given selector for given class"

    | actualSource |

    actualSource := aClass theMetaclass sourceCodeAt: aSelector asSymbol.

    ^ self assertSource: expectedSource sameAs: actualSource

    "Created: / 11-07-2014 / 20:09:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

assertClassNotExists: aClassName

    self assert: (Smalltalk classNamed: aClassName asString) isNil

    "Created: / 15-06-2014 / 16:42:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

assertMethodCount: aNumber inClass: aClass
    | realClass |

    realClass := Smalltalk at: (aClass theNonMetaclass name asSymbol).

    self assert: aNumber = (realClass methodDictionary size).

    "Created: / 26-09-2014 / 10:48:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

assertMethodSource: aSourceCode atSelector: aSelector
    "Assert that source code is same at given selector for first generated class"

    | className class |

    className := classes first name.
    class := Smalltalk at: className.

    ^ self assertMethodSource: aSourceCode atSelector: aSelector forClass: class

    "Created: / 27-05-2014 / 20:06:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 00:15:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

assertMethodSource: expectedSource atSelector: aSelector forClass: aClass
    "Assert that source code is same at given selector for given class"

    | actualSource |

    actualSource := aClass sourceCodeAt: aSelector asSymbol.

    ^ self assertSource: expectedSource sameAs: actualSource

    "Created: / 27-05-2014 / 20:08:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

assertSource: expectedSource sameAs: actualSource

    self assert: (Change isSource: expectedSource sameSourceAs: actualSource)

    "Created: / 25-05-2014 / 22:18:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-07-2014 / 11:31:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTestCase methodsFor:'code generation helpers'!

createClass
    "Returns new class change with some name"

    | class |

    class := model createClass
        name: #DummyClassForGeneratorTestCase;
        compile;
        yourself.

    classes add: class.

    ^ class

    "Created: / 29-05-2014 / 23:22:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 09-10-2014 / 10:34:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTestCase methodsFor:'context templates'!

classWithInstanceVariable
    | class |

    class := self createClass.
    class instanceVariableNames: (Array with: 'instanceVariable'); compile.

    context selectedClasses: (Array with: class).

    ^ class

    "Created: / 29-05-2014 / 00:33:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 30-11-2014 / 19:17:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

classWithThreeInstanceVariables
    | class |

    class := self createClass.
    class instanceVariableNames: (Array with: 'instanceVariable_01' with: 'instanceVariable_02' with: 'instanceVariable_03'); compile.

    context selectedClasses: (Array with: class).
    context selectedVariables: (class instanceVariableNames).

    ^ class

    "Created: / 13-07-2014 / 21:56:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 30-11-2014 / 19:18:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

classWithTwoInstanceVariables
    | class |

    class := self createClass.
    class instanceVariableNames: (Array with: 'instanceVariable_01' with: 'instanceVariable_02'); compile.

    context selectedClasses: (Array with: class).
    context selectedVariables: (class instanceVariableNames).

    ^ class

    "Created: / 13-07-2014 / 21:45:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 30-11-2014 / 19:18:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTestCase methodsFor:'executing'!

createContext: contextTemplateName
    "Creates context by given template name
    (produces more readable code than just method call)"

    self perform: contextTemplateName asSymbol

    "Created: / 27-07-2014 / 12:27:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

executeGeneratorInContext: contextTemplateName
    "Executes generator in context created by given name"

    self perform: contextTemplateName asSymbol.
    generatorOrRefactoring executeInContext: context

    "Created: / 27-05-2014 / 20:03:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-05-2014 / 23:38:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTestCase methodsFor:'initialization & release'!

defaultUserPreferences

    userPreferences
        generateComments: true;
        generateCommentsForAspectMethods: true;
        generateCommentsForGetters: true;
        generateCommentsForSetters: true

    "Created: / 09-06-2014 / 22:36:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

setUp
    Screen current isNil ifTrue:[
        Smalltalk openDisplay.
        Screen current isNil ifTrue:[
            self assert: false description: 'Tests need display connection'.
        ]
    ].

    classes := OrderedCollection new.
    mock := CustomMock new.
    dialog := CustomSilentDialog new.

    context := CustomSubContext new.

    changeManager := CustomLocalChangeManager new.
    self setUpBuilders.

    userPreferences := UserPreferences new.
    self defaultUserPreferences.
    generatorOrRefactoring := self generatorOrRefactoring.

    self setUpTestFormatter.

    generatorOrRefactoring notNil ifTrue: [
        self setUpGeneratorOrRefactoring: generatorOrRefactoring
    ].

    "Created: / 27-05-2014 / 19:16:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 14:39:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

setUpBuilders

    model := CustomNamespace new.
    model changeManager: changeManager.

    refactoryBuilder := CustomRefactoryBuilder new.
    refactoryBuilder changeManager: changeManager.
    refactoryBuilder model: model.

    "Created: / 23-08-2014 / 15:57:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 19-10-2014 / 19:49:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

setUpGeneratorOrRefactoring: aGeneratorOrRefactoring

    aGeneratorOrRefactoring 
        formatter: formatter;
        model: model;
        refactoryBuilder: refactoryBuilder;
        changeManager: changeManager;
        userPreferences: userPreferences;
        dialog: dialog

    "Created: / 23-08-2014 / 15:59:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 14-10-2014 / 11:03:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

setUpTestFormatter

    formatter := CustomRBLocalSourceCodeFormatter new.
    formatter
        tabIndent: 4;
        spaceAroundTemporaries: false;
        emptyLineAfterTemporaries: true;
        emptyLineAfterMethodComment: true;
        spaceAfterReturnToken: true;
        spaceAfterKeywordSelector: false;
        spaceAfterBlockStart: true;
        spaceBeforeBlockEnd: true;
        cStyleBlocks: true;
        blockArgumentsOnNewLine: false;
        maxLengthForSingleLineBlocks: 4;
        periodAfterLastStatementPolicy: #keep.
    "
    EmptyLineBeforeFinalMethodComment := true.
    SpaceAroundLiteralArrayElements := true.
    STXStyleMethodComments := true.
    "
    model formatter: formatter.
    refactoryBuilder formatter: formatter

    "Created: / 28-08-2014 / 23:29:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 31-08-2014 / 17:23:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown

    changeManager undoChanges.
    mock unmockAll

    "Created: / 27-05-2014 / 19:26:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 19-10-2014 / 14:56:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTestCase methodsFor:'running'!

runCase
    "Run the case and do not add any mess into the changes file (st.chg)."

    Class withoutUpdatingChangesDo: [ 
        super runCase
    ]

    "Created: / 30-11-2014 / 17:02:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTestCase class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

