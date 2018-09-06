"{ Package: 'stx:goodies/petitparser/analyzer' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_petitparser_analyzer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser_analyzer class methodsFor:'accessing - monticello'!

monticelloLastMergedVersionInfo
    "The last merged version is: "

    ^ '
    Name: PetitAnalyzer-DiegoLont.46
    Author: DiegoLont
    Time: 02-09-2013, 12:37:58 PM
    UUID: 89f155fa-89b4-4bb7-b76e-0f8485be4a56
    Repository: http://smalltalkhub.com/mc/Moose/PetitParser/main
    '

    "Created: / 03-10-2014 / 02:40:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloName
    "Return name of the package for Monticello. This is used when package is exported"

    ^ 'PetitAnalyzer'

    "Created: / 03-10-2014 / 01:48:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser_analyzer class methodsFor:'accessing - tests'!

testSuite
    "generate and return a testSuite containing all of my test-classes"

    Smalltalk loadPackage: 'stx:goodies/petitparser/analyzer/tests'.
    ^ 'stx:goodies/petitparser/analyzer/tests' asPackageId projectDefinitionClass testSuite

! !

!stx_goodies_petitparser_analyzer class methodsFor:'description'!

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
        #'stx:goodies/petitparser'    "PPActionParser - extended"
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_petitparser_analyzer"
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

!stx_goodies_petitparser_analyzer class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        PPPattern
        PPProcessor
        PPRule
        PPSentinel
        #'stx_goodies_petitparser_analyzer'
        PPListPattern
        PPReplaceRule
        PPRewriter
        PPSearchRule
        PPSearcher
        PPBlockReplaceRule
        PPParserReplaceRule
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        PPActionParser match:inContext:seen:
        PPDelegateParser replace:with:
        PPEpsilonParser isNullable
        PPFailingParser match:inContext:seen:
        PPLimitedRepeatingParser replace:with:
        PPListParser copyInContext:seen:
        PPListParser replace:with:
        PPLiteralParser match:inContext:seen:
        PPOptionalParser isNullable
        PPParser allNamedParsers
        PPParser allNamedParsersDo:
        PPParser copyInContext:
        PPParser copyInContext:seen:
        PPParser cycleSet
        PPParser cycleSet:
        PPParser cycleSet:firstSets:into:
        PPParser firstSet
        PPParser firstSets:into:
        PPParser followSet
        PPParser followSets
        PPParser followSets:firstSets:into:
        PPParser innerChildren
        PPParser innerChildrenDo:
        PPParser innerChildrenDo:seen:
        PPParser isNullable
        PPParser isTerminal
        PPParser match:inContext:
        PPParser match:inContext:seen:
        PPParser matchList:against:inContext:seen:
        PPParser matchList:index:against:index:inContext:seen:
        PPParser namedChildren
        PPParser namedChildrenDo:
        PPParser namedChildrenDo:seen:
        PPParser replace:with:
        PPParser transform:
        PPPluggableParser match:inContext:seen:
        PPPredicateParser match:inContext:seen:
        PPPredicateSequenceParser match:inContext:seen:
        PPRepeatingParser isNullable
        PPRepeatingParser match:inContext:seen:
        PPSequenceParser cycleSet:
        PPSequenceParser firstSets:into:
        PPSequenceParser followSets:firstSets:into:
        PPTokenParser match:inContext:seen:
        PPNotParser firstSets:into:
        PPNotParser isFirstSetTerminal
        PPParser firstSets
        PPParser isFirstSetTerminal
        PPRepeatingParser followSets:firstSets:into:
    )
! !

!stx_goodies_petitparser_analyzer class methodsFor:'description - project information'!

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

!stx_goodies_petitparser_analyzer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/stx_goodies_petitparser_analyzer.st,v 1.6 2014-03-04 20:29:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/stx_goodies_petitparser_analyzer.st,v 1.6 2014-03-04 20:29:43 cg Exp $'
!

version_HG
    ^ '$Changeset: <not expanded> $'
!

version_MC
    ^ '$PetitAnalyzer-lr.41 608069e1-dadc-4435-abd6-995adf7519e2 2013-03-16T21:52:20 lr$'
! !
