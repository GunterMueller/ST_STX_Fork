"{ Package: 'stx:goodies/petitparser/gui' }"

LibraryDefinition subclass:#stx_goodies_petitparser_gui
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser_gui class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)"

    ^ #(
        #'stx:goodies/petitparser'    "PPAndParser - extended "
        #'stx:goodies/refactoryBrowser/refactoring'    "ExtractMethodRefactoring - superclass of PPExtractProdcutionRefactoring "
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_petitparser_gui "
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
        #'stx:goodies/refactoryBrowser/parser'    "ParseTreeRewriter - referenced by PPDefineProdcutionRefactoring>>sourceRewriter "
        #'stx:libbasic2'    "Text - referenced by PPParserDebuggerResult>>formattedText "
        #'stx:libview'    "Color - referenced by PPBrowserStream>>asPositionMorph "
        #'stx:libview3'    "Morph - referenced by PPParser>>newSpacerMorph "
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
    )
! !

!stx_goodies_petitparser_gui class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        GLMCompositePresentation
        PPAddParserRefactoring
        PPBrowserStream
        PPDefineProdcutionRefactoring
        PPDrabBrowser
        PPExtractProdcutionRefactoring
        PPParserDebuggerResult
        PPRefactoringUtils
        PPTextHighlighter
        RBRefactoring
        RBRemoveClassRefactoring
        #'stx_goodies_petitparser_gui'
        PPBrowser
        PPParserBrowser
        PPParserInspector
        PPRemoveParserRefactoring
        PPRemoveProdcutionRefactoring
        PPRenameProdcutionRefactoring
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
        PPAndParser displayDescription
        PPAndParser exampleOn:
        PPChoiceParser exampleOn:
        PPChoiceParser morphicShapeSeen:depth:
        PPDelegateParser displayDescription
        PPDelegateParser exampleOn:
        PPDelegateParser morphicShapeSeen:depth:
        PPEndOfInputParser displayDescription
        PPEpsilonParser displayName
        PPEpsilonParser morphicShapeSeen:depth:
        PPFailingParser displayColor
        PPFailingParser displayName
        PPLiteralParser displayName
        PPLiteralSequenceParser exampleOn:
        PPNotParser displayDescription
        PPNotParser exampleOn:
        PPParser backgroundForDepth:
        PPParser displayColor
        PPParser displayName
        PPParser example
        PPParser exampleOn:
        PPParser gtInspectorParserInspectorIn:
        PPParser morphicProduction
        PPParser morphicShapeDefault
        PPParser morphicShapeSeen:depth:
        PPParser morphicShapeSeen:depth:do:
        PPParser namedParsers
        PPParser namedParsersDo:
        PPParser namedParsersDo:seen:
        PPParser newColumnMorph
        PPParser newRowMorph
        PPParser newSpacerMorph
        PPParser viewAllNamedParsers
        PPParser viewAllNamedParsersOn:
        PPParser viewAllNamedParsersWithSelection:on:
        PPParser viewAllNamedParsersWithSelection:previewing:on:
        PPPluggableParser displayName
        PPPredicateParser displayName
        PPPredicateParser exampleOn:
        PPRepeatingParser displayDescription
        PPRepeatingParser exampleOn:
        PPSequenceParser exampleOn:
        PPSequenceParser morphicShapeSeen:depth:
        PPTrimmingParser exampleOn:
        PPUnresolvedParser displayColor
        Refactoring checkCompositeParser:
        Refactoring compositeParserClass
    )
! !

!stx_goodies_petitparser_gui class methodsFor:'description - project information'!

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

    ^ 'Copyright Claus Gittinger 1988-2014\nCopyright eXept Software AG 1998-2014'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_petitparser_gui class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/stx_goodies_petitparser_gui.st,v 1.1 2014-03-04 21:20:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/stx_goodies_petitparser_gui.st,v 1.1 2014-03-04 21:20:50 cg Exp $'
! !

