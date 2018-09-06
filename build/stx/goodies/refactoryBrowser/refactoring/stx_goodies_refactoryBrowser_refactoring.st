"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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
"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_refactoryBrowser_refactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_refactoryBrowser_refactoring class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

    This library contains classes representing individual refactoring operations.
    Refactorings are higher level, and usually more complex changes done to the system,
    often involving multiple smaller changes done to multiple methods or classes.
    Refactorings support undo and redo, and are created and executed via the browser's menu functions.
"
! !

!stx_goodies_refactoryBrowser_refactoring class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'stx:libtool'    "SystemBrowser - referenced by RemoveClassVariableRefactoring>>preconditions "
        #'stx:goodies/refactoryBrowser/browser'    "MethodNameDialog - referenced by Refactoring class>>initializeRefactoringOptions "
    )
!

includedInPreRequisites
    "list all packages which should be also be treated as preRequisite,
     even if not found by the automatic scan. See #preRequisites for more."

    ^ #(
        #'stx:libcompat'    "sends removeClassNamed: from libcompat"
    )
!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:libbasic'    "Warning - superclass of RefactoringWarning "
    )
!

referencedPreRequisites
    "list all packages containing classes referenced by the packages's members.
     This list can be maintained manually or (better) generated and
     updated by looking for global variable accesses
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:goodies/refactoryBrowser/changes'    "MethodRefactoryChange - referenced by RefactoryBuilder>>compile:in:classified: "
        #'stx:goodies/refactoryBrowser/helpers'    "RBNamespace - referenced by Refactoring>>model "
        #'stx:goodies/refactoryBrowser/lint'    "RBReadBeforeWrittenTester - referenced by ExtractMethodRefactoring>>checkAssignments: "
        #'stx:goodies/refactoryBrowser/parser'    "ParseTreeSearcher - referenced by InlineTemporaryRefactoring>>hasOnlyOneAssignment "
        #'stx:libcomp'    "Parser - referenced by Refactoring>>execute "
        #'stx:libview'    "Cursor - referenced by Refactoring>>allImplementorsOf: "
    )
! !

!stx_goodies_refactoryBrowser_refactoring class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIB_RB_REFACTORING_BASE
LIB_BASE=$(LIB_RB_REFACTORING_BASE)
'
!

stcOptimizationOptions
    "do not inline the not operation here - it is overwritten"

    ^ '+optspace3 -inlinenot'

    "Created: / 23-08-2006 / 01:27:22 / cg"
! !

!stx_goodies_refactoryBrowser_refactoring class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        RBAbstractCondition
        RBParseTreeRule
        RBReplaceStringInOriginalSource
        RBReplaceTokenStringInOriginalSource
        Refactoring
        RefactoringError
        RefactoringManager
        RefactoringWarning
        RefactoryBuilder
        #'stx_goodies_refactoryBrowser_refactoring'
        AbstractVariablesRefactoring
        ClassRefactoring
        ExpandReferencedPoolsRefactoring
        MethodRefactoring
        RBAlternativeCondition
        RBCondition
        RBConjunctiveCondition
        RBNegationCondition
        RBReplaceRule
        RBSearchRule
        RemoveClassRefactoring
        SplitClassRefactoring
        VariableRefactoring
        AbstractClassVariableRefactoring
        AbstractInstanceVariableRefactoring
        AddClassRefactoring
        AddClassVariableRefactoring
        AddInstanceVariableRefactoring
        AddMethodRefactoring
        ChangeMethodNameRefactoring
        ChildrenToSiblingsRefactoring
        CreateAccessorsForVariableRefactoring
        ExtractMethodRefactoring
        ExtractMethodToComponentRefactoring
        ExtractToTemporaryRefactoring
        InlineAllSelfSendersRefactoring
        InlineMethodRefactoring
        InlineTemporaryRefactoring
        MoveMethodRefactoring
        MoveVariableDefinitionRefactoring
        ProtectInstanceVariableRefactoring
        PullUpClassVariableRefactoring
        PushDownClassVariableRefactoring
        PushDownMethodRefactoring
        PushUpMethodRefactoring
        RBBlockReplaceRule
        RBStringReplaceRule
        RemoveClassVariableRefactoring
        RemoveInstanceVariableRefactoring
        RemoveMethodRefactoring
        RenameClassRefactoring
        RenameClassVariableRefactoring
        RenameTemporaryRefactoring
        RenameVariableRefactoring
        RestoringVariableRefactoring
        TemporaryToInstanceVariableRefactoring
        ValueHolderRefactoring
        AddParameterRefactoring
        InlineMethodFromComponentRefactoring
        PullUpInstanceVariableRefactoring
        PushDownInstanceVariableRefactoring
        RemoveParameterRefactoring
        RenameInstanceVariableRefactoring
        RenameMethodRefactoring
        InlineParameterRefactoring
        RenameToInstanceVariableRefactoring
        (CompositeRefactoring autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_goodies_refactoryBrowser_refactoring class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Refactoring Inc. / eXept Software AG'

    "Modified: / 18-11-2016 / 11:53:22 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Refactorings'

    "Modified: / 14-09-2006 / 10:56:40 / cg"
!

legalCopyright
    "Return copyright string which will appear in <lib>.rc"

    ^ 'Copyright Refactoring Inc.\nCopyright Claus Gittinger\nCopyright eXept Software AG 2011'

    "Modified: / 18-11-2016 / 12:15:32 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_refactoryBrowser_refactoring class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

