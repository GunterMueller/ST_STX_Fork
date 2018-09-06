"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_petitparser_tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser_tests class methodsFor:'accessing - monticello'!

monticelloLastMergedVersionInfo
    "The last merged version is: "

    ^ '
    Name: PetitTests-JanKurs.63
    Author: JanKurs
    Time: 30-10-2014, 12:54:37 PM
    UUID: 7afbeef7-eadf-4d65-bce5-7204e2727edb             
    Repository: http://smalltalkhub.com/mc/Moose/PetitParser/main
    '

    "Created: / 03-10-2014 / 02:28:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-11-2014 / 08:26:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloName
    "Return name of the package for Monticello. This is used when package is exported"

    ^ 'PetitTests'

    "Created: / 03-10-2014 / 01:48:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser_tests class methodsFor:'description'!

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
        #'stx:goodies/petitparser'    "PPCompositeParser - superclass of PPArithmeticParser"
        #'stx:goodies/sunit'    "TestAsserter - superclass of PPAbstractParserTest"
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_petitparser_tests"
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

stcOptimizationOptions
    "do not inline the not operation here - it is overwritten"

    ^ super stcOptimizationOptions , ' -inlinenot'

    "Created: / 13-04-2015 / 14:18:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
    )
! !

!stx_goodies_petitparser_tests class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        PPAbstractParserTest
        PPArithmeticParser
        PPContextMementoTest
        PPContextTest
        PPLambdaParser
        PPParserResource
        #'stx_goodies_petitparser_tests'
        PPComposedTest
        PPCompositeParserTest
        PPConditionalParserTest
        PPConditionalParserTests
        PPExtensionTest
        PPMappingTest
        PPObjectTest
        PPParserTest
        PPPredicateTest
        PPScriptingTest
        PPTokenTest
        PPArithmeticParserTest
        PPLambdaParserTest
        PPExpressionParserTest
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
    )
! !

!stx_goodies_petitparser_tests class methodsFor:'description - project information'!

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

!stx_goodies_petitparser_tests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/tests/stx_goodies_petitparser_tests.st,v 1.3 2014-03-04 20:32:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/tests/stx_goodies_petitparser_tests.st,v 1.3 2014-03-04 20:32:06 cg Exp $'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

