"{ Package: 'stx:goodies/petitparser/analyzer/tests' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_petitparser_analyzer_tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser_analyzer_tests class methodsFor:'accessing - monticello'!

monticelloLastMergedVersionInfo
    "The last merged version is: "

    ^ '
    Name: PetitAnalyzer-JanKurs.48
    Author: JanKurs
    Time: 30-10-2014, 12:53:26 PM
    UUID: 13464ded-5457-4b5b-ba2f-b4ab7dcec782 
    '

    "Created: / 03-10-2014 / 02:40:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-11-2014 / 09:00:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloName
    "Return name of the package for Monticello. This is used when package is exported"

    ^ 'PetitAnalyzerTests'

    "Created: / 03-10-2014 / 01:48:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-10-2014 / 21:37:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser_analyzer_tests class methodsFor:'description'!

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
        #'stx:goodies/petitparser/tests'    "PPAbstractParserTest - superclass of PPAnalyzerTest"
        #'stx:goodies/sunit'    "TestAsserter - superclass of PPAnalyzerTest"
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_petitparser_analyzer_tests"
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
        #'stx:goodies/petitparser'    "PPAndParser - referenced by PPAnalyzerTest>>testIsNullable"
        #'stx:goodies/petitparser/analyzer'    "PPListPattern - referenced by PPRewriterTest>>testDuplicationRemoval"
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

!stx_goodies_petitparser_analyzer_tests class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        PPAnalyzerTest
        PPRewriterTest
        PPSearcherTest
        #'stx_goodies_petitparser_analyzer_tests'
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
    )
! !

!stx_goodies_petitparser_analyzer_tests class methodsFor:'description - project information'!

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

!stx_goodies_petitparser_analyzer_tests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/tests/stx_goodies_petitparser_analyzer_tests.st,v 1.1 2014-03-04 20:26:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/tests/stx_goodies_petitparser_analyzer_tests.st,v 1.1 2014-03-04 20:26:59 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

