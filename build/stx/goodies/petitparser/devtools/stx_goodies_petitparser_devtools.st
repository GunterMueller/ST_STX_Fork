"{ Package: 'stx:goodies/petitparser/devtools' }"

LibraryDefinition subclass:#stx_goodies_petitparser_devtools
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser_devtools class methodsFor:'description'!

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
     Howevery, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPrerequisites method."

    ^ #(
        #'jv:dart/compiler'    "Dart::Parser - referenced by PPCompositeParserGenerator>>generate "
        #'stx:goodies/petitparser'    "PPParser - superclass of PPDebuggingParser "
        #'stx:goodies/xml/vw'    "XML::XMLParser - referenced by XBGFParser>>parse: "
        #'stx:libbasic'    "Object - superclass of PPDebuggingParser "
        #'stx:libbasic3'    "ChangeSet - referenced by PPCompositeParserGenerator>>generate "
    )
! !

!stx_goodies_petitparser_devtools class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        PPDebugger
        PPDebuggingParser
        #'stx_goodies_petitparser_devtools'
        XBGFParser
        (PPCompositeParserGenerator autoload)
        (PPParserVisitor autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
        PPActionParser acceptVisitor:
        PPAndParser acceptVisitor:
        PPArithmeticParser acceptVisitor:
        PPChoiceParser acceptVisitor:
        PPCompositeParser acceptVisitor:
        PPDelegateParser acceptVisitor:
        PPEndOfInputParser acceptVisitor:
        PPEpsilonParser acceptVisitor:
        PPExpressionParser acceptVisitor:
        PPFailingParser acceptVisitor:
        PPFlattenParser acceptVisitor:
        PPLambdaParser acceptVisitor:
        PPListParser acceptVisitor:
        PPLiteralObjectParser acceptVisitor:
        PPLiteralParser acceptVisitor:
        PPLiteralSequenceParser acceptVisitor:
        PPMemoizedParser acceptVisitor:
        PPNotParser acceptVisitor:
        PPOptionalParser acceptVisitor:
        PPParser acceptVisitor:
        PPPluggableParser acceptVisitor:
        PPPredicateObjectParser acceptVisitor:
        PPPredicateParser acceptVisitor:
        PPPredicateSequenceParser acceptVisitor:
        PPRepeatingParser acceptVisitor:
        PPSequenceParser acceptVisitor:
        PPTokenParser acceptVisitor:
        PPTrimmingParser acceptVisitor:
        PPUnresolvedParser acceptVisitor:
        PPWrappingParser acceptVisitor:
    )
! !

!stx_goodies_petitparser_devtools class methodsFor:'description - project information'!

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

    ^ 'Copyright Claus Gittinger 1988-2012\nCopyright eXept Software AG 1998-2012'
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

!stx_goodies_petitparser_devtools class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/stx_goodies_petitparser_devtools.st,v 1.4 2013-01-10 13:26:48 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/stx_goodies_petitparser_devtools.st,v 1.4 2013-01-10 13:26:48 vrany Exp $'
! !
