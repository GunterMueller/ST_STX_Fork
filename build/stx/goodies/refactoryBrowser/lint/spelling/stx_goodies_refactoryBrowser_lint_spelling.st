"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

LibraryDefinition subclass:#stx_goodies_refactoryBrowser_lint_spelling
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_refactoryBrowser_lint_spelling class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

preRequisites
    "list all required packages.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies and looking for
     global variable accesses. (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method.
     If you have explicit preqrequisites, define them in the #includedInPreRequisites method."

    ^ #(
        #'stx:goodies/refactoryBrowser/browser'    "MultiEnvironment - referenced by RBMethodProtocolsSpellingRule>>resultClass "
        #'stx:goodies/refactoryBrowser/lint'    "RBBlockLintRule - superclass of RBSpellingRule "
        #'stx:goodies/refactoryBrowser/parser'    "ParseTreeSearcher - referenced by RBLiteralValuesSpellingRule>>initialize "
        #'stx:libbasic'    "ProjectDefinition - superclass of stx_goodies_refactoryBrowser_lint_spelling "
        #'stx:libbasic2'    "Base64Coder - referenced by RBInternalSpellChecker>>initialize "
    )
! !

!stx_goodies_refactoryBrowser_lint_spelling class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        RBSpellChecker
        RBSpellingRule
        #'stx_goodies_refactoryBrowser_lint_spelling'
        RBArgumentVariableNamesSpellingRule
        RBClassCategoriesSpellingRule
        RBClassCommentsSpellingRule
        RBClassNamesSpellingRule
        RBClassVariableNamesSpellingRule
        RBInstanceVariableNamesSpellingRule
        RBInternalSpellChecker
        RBLiteralValuesSpellingRule
        RBMacSpellChecker
        RBMethodCommentsSpellingRule
        RBMethodProtocolsSpellingRule
        RBMethodSelectorsSpellingRule
        RBPoolVariableNamesSpellingRule
        RBTemporaryVariableNamesSpellingRule
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_goodies_refactoryBrowser_lint_spelling class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2011\nCopyright eXept Software AG 1998-2011'
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_refactoryBrowser_lint_spelling class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/stx_goodies_refactoryBrowser_lint_spelling.st,v 1.2 2013-03-06 18:35:13 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/stx_goodies_refactoryBrowser_lint_spelling.st,v 1.2 2013-03-06 18:35:13 stefan Exp $'
! !

