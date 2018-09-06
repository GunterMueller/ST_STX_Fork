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
"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_refactoryBrowser_browser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_refactoryBrowser_browser class methodsFor:'documentation'!

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

    The almost original refactoring browser GUI.

    Obsolete, as all refactoring operations are also supported by the regular
    ST/X system browser, but with a much nicer GUI.

    However, some other refactoring code requires classes from this package,
    especially the environments. 
    So it is included in ST/X, but all original UI classes are non-compiled (autoloaded),
    to save some space.
"
! !

!stx_goodies_refactoryBrowser_browser class methodsFor:'description'!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:goodies/refactoryBrowser/helpers'    "BrowserEnvironment - extended"
        #'stx:libbasic'    "Autoload - superclass of BrowserApplicationModel"
        #'stx:libview2'    "ApplicationModel - superclass of BrowserDialog"
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
        #'stx:goodies/refactoryBrowser/parser'    "ParseTreeSearcher - referenced by RefactoryTyper class>>typesFor:in:model:ignoredSelectors:"
        #'stx:libview'    "Depth1Image - referenced by BrowserDialog class>>downIcon"
        #'stx:libwidg'    "SelectionInList - referenced by MethodNameDialog>>argumentList"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites."

    ^ #(
    )
! !

!stx_goodies_refactoryBrowser_browser class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        BrowserDialog
        BrowserEnvironmentWrapper
        LimitedEnvironment
        RefactoryTyper
        #'stx_goodies_refactoryBrowser_browser'
        AndEnvironment
        CategoryEnvironment
        ClassEnvironment
        EmptyEnvironment
        MethodNameDialog
        NamespaceEnvironment
        NotEnvironment
        PackageEnvironment
        ProtocolEnvironment
        RestrictedEnvironment
        SelectorEnvironment
        VariableEnvironment
        MultiEnvironment
        ParseTreeEnvironment
        (BrowserApplicationModel autoload)
        (BrowserClassTool autoload)
        (BrowserCodeTool autoload)
        (CanvasViewer autoload)
        (CategoryDialog autoload)
        (ClassCommentTool autoload)
        (ClassNavigatorTool autoload)
        (ClassSelectionDialog autoload)
        (CodeModel autoload)
        (CodeModelLockPolicy autoload)
        (CodeToolSelectionPolicy autoload)
        (CompositeRefactoryChangeInspector autoload)
        (EnvironmentEditor autoload)
        (IconViewer autoload)
        (MenuViewer autoload)
        (MultiNavigator autoload)
        (NavigatorState autoload)
        (OMTClassController autoload)
        (OMTClassDiagram autoload)
        (OMTClassModel autoload)
        (OMTClassTool autoload)
        (OMTClassView autoload)
        (OrganizationEditor autoload)
        (RBMultiSelectionInList autoload)
        (RBMultiSelectionView autoload)
        (RefactoringBrowser autoload)
        (RefactoryBrowserPlatformSupport autoload)
        (RefactoryBuilderInspector autoload)
        (ReferenceFinder autoload)
        (ResourceTool autoload)
        (RewriteCodeTool autoload)
        (RewriteRuleEditor autoload)
        (SourceSelectionPolicy autoload)
        (StateLockPolicy autoload)
        (SystemNavigator autoload)
        (UnreferencedVariables autoload)
        (VariableNavigator autoload)
        (VariableNavigatorState autoload)
        (VariableTypeDialog autoload)
        (WindowLockPolicy autoload)
        (CodeTool autoload)
        (Navigator autoload)
        (BrowserNavigator autoload)
        (BrowserTextTool autoload)
        (MethodNameDialogForAddParameter autoload)
        (ClassSelectorNavigator autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        BrowserEnvironment forPackage:
        BrowserEnvironment forPackages:
        'BrowserEnvironment class' empty
    )
! !

!stx_goodies_refactoryBrowser_browser class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Refactoring Inc. / eXept Software AG'

    "Modified: / 18-11-2016 / 11:52:46 / cg"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Refactoring Browser'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Refactoring Inc.\nCopyright Claus Gittinger\nCopyright eXept Software AG'

    "Modified: / 18-11-2016 / 12:14:39 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_refactoryBrowser_browser class methodsFor:'description - svn'!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'exported'"$"
! !

!stx_goodies_refactoryBrowser_browser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

