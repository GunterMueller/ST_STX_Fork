"{ Package: 'stx:goodies/petitparser/islands' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_petitparser_islands
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser_islands class methodsFor:'accessing - monticello'!

monticelloLastMergedVersionInfo
    "The last merged version is: "

    ^ '
    Name: PetitIslands-JanKurs.10
    Author: JanKurs
    Time: 06-10-2014, 11:50:57 AM
    UUID: 19560ad2-4899-43d5-8c69-cf7274ad4f04  
    Repository: http://smalltalkhub.com/mc/Moose/PetitParser/main
    '

    "Created: / 03-10-2014 / 02:27:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2014 / 00:24:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloName
    "Return name of the package for Monticello. This is used when package is exported"

    ^ 'PetitIslands'

    "Created: / 03-10-2014 / 01:47:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2014 / 00:24:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser_islands class methodsFor:'accessing - tests'!

testSuite
    "generate and return a testSuite containing all of my test-classes"

    Smalltalk loadPackage: 'stx:goodies/petitparser/islands/tests'.
    ^ 'stx:goodies/petitparser/islands/tests' asPackageId projectDefinitionClass testSuite

    "Modified: / 08-10-2014 / 00:26:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser_islands class methodsFor:'description'!

excludedFromPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     prerequisites list. If empty, everything that is found along the inheritance of any of
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
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:goodies/petitparser'    "PPChoiceParser - extended"
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_petitparser_islands"
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
        #'stx:goodies/petitparser/analyzer'    "PPSentinel - referenced by PPParser>>nextSets"
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

!stx_goodies_petitparser_islands class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        (JavaParser autoload)
        PPInputEnds
        PPIsland
        PPNonEmptyParser
        PPWater
        (XmlFeedParser autoload)
        #'stx_goodies_petitparser_islands'
        PPMemoizingIsland
        (RobustXmlFeedParser autoload)
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        PPChoiceParser acceptsEpsilonOpenSet:
        PPContext waterPosition
        PPContext waterPosition:
        PPDelegateParser acceptsEpsilon
        PPDelegateParser acceptsEpsilonOpenSet:
        PPEpsilonParser acceptsEpsilon
        PPListParser acceptsEpsilon
        PPLiteralParser acceptsEpsilon
        PPOptionalParser acceptsEpsilon
        PPOptionalParser acceptsEpsilonOpenSet:
        PPParser acceptsEpsilon
        PPParser acceptsEpsilonOpenSet:
        PPParser island
        PPParser island:
        PPParser nextSets
        PPParser nextSets:into:
        PPPredicateParser acceptsEpsilon
        PPRepeatingParser nextSets:into:
        PPSequenceParser acceptsEpsilonOpenSet:
        PPSequenceParser nextSets:into:
    )
! !

!stx_goodies_petitparser_islands class methodsFor:'description - project information'!

companyName
    "Returns a company string which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info"

    ^ 'eXept Software AG'
!

description
    "Returns a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Returns a copyright string which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info"

    ^ 'Copyright Claus Gittinger 1988-2014\nCopyright eXept Software AG 1998-2014'
!

productName
    "Returns a product name which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info.
     This method is usually redefined in a concrete application definition"

    ^ 'Smalltalk/X'
! !

!stx_goodies_petitparser_islands class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

