"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_petitparser_compiler_tests_extras
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser_compiler_tests_extras class methodsFor:'accessing'!

additionalClassAttributesFor: aClass
    "Answers additional set of class attributes for given class
     Individual project definitions may override this method, but
     overriding method should always merge its attributes with result
     of 'super additionalClassAttributesFor: aClass'.

     Here, we add #autoload attributes to all test cases and
     test resources, as they are not neccessary for the package
     and should not be compiled (because of unwanted dependency
     on stx:goodies/sunit package)

     But not make them autoloaded when the package is separate
     test-package - by conventions such package should by named
     #'module:package/subpackage/tests'
    "
    (TestCase notNil and:[aClass inheritsFrom: TestCase]) ifTrue:[^#()].
    (TestResource notNil and:[aClass inheritsFrom: TestResource]) ifTrue:[^#()].


    ^ super additionalClassAttributesFor: aClass

    "Created: / 10-05-2015 / 14:17:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser_compiler_tests_extras class methodsFor:'accessing - monticello'!

monticelloLastMergedVersionInfo
    "The last merged version is: "

    ^ '
    Name: PetitCompiler-Tests-JanKurs.116
    Author: JanKurs
    Time: 24-08-2015, 11:37:54.332 AM
    UUID: 549e0927-358a-4a1b-8270-050ccfcb4217        
    Repository: http://smalltalkhub.com/mc/JanKurs/PetitParser/main

    '

    "Created: / 03-10-2014 / 02:27:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-08-2015 / 15:28:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloName
    "Return name of the package for Monticello. This is used when package is exported"

    ^ 'PetitCompiler-Extras-Tests'

    "Created: / 03-10-2014 / 01:47:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-05-2015 / 06:27:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloSplicemap
    "Return a splicemap for this package. This is used to forge a 
     'fake' ancestor when generating ancestry information out of 
     Mercurial (or anyt other) history. This should make merging 
     back into Squeak/Pharo a little easier as Monticello can (in theory)
     find a proper ancestor. 

     All this requires monticelloSplicemap being updated each time a code
     is merged from Monticello.

     The format of splicemap is a flat array of pairs 
     (commit id, MCVersionInfo to splice) as literal encoding.
    "

    ^ #(
        #(HGChangesetId 'f6f68d32de73') #(MCVersionInfo name: 'PetitCompiler-Extras-Tests-JanKurs.29' id: 'ea1dbb67-f884-4237-8f34-adb0677c0954' date: '2015-08-24' time: '11:36:52.503' author: 'JanKurs' message: '- Some more tests
- Better naming for PPSmalltalkParser')

    )
! !

!stx_goodies_petitparser_compiler_tests_extras class methodsFor:'description'!

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
        #'stx:goodies/petitparser'    "PPCompositeParser - superclass of PPCLRPParser"
        #'stx:goodies/petitparser/parsers/java'    "PPJavaLexiconTest - superclass of PPCompiledJavaSyntaxTest"
        #'stx:goodies/petitparser/parsers/smalltalk/tests'    "PPSmalltalkGrammarTests - superclass of PPCSmalltalkGrammarTests"
        #'stx:goodies/petitparser/tests'    "PPAbstractParserTest - superclass of PPCAbstractParserTest"
        #'stx:goodies/sunit'    "TestAsserter - superclass of PPCAbstractParserTest"
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_petitparser_compiler_tests_extras"
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
        #'stx:goodies/petitparser/compiler'    "PPCCompiler - referenced by PPCExpressionGrammarTest_Tokenized>>compiler"
        #'stx:goodies/petitparser/parsers/smalltalk'    "PPSmalltalkGrammar - referenced by PPCSmalltalkGrammarTests>>petitParserClass"
        #'stx:libbasic2'    "Random - referenced by PPCResources>>expressionOfSize:stream:"
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

!stx_goodies_petitparser_compiler_tests_extras class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        (PPCAbstractParserTest autoload)
        (PPCCompiledJavaVerificationTest autoload)
        (PPCCompositeParserTest autoload)
        (PPCJavaTests autoload)
        PPCLRPNode
        PPCLRPParser
        PPCLRPParserSmokeTest
        PPCLRPSourcesResource
        (PPCResources autoload)
        (PPCSetUpBeforeTearDownAfterResource autoload)
        (PPCSmalltalkGrammarTests autoload)
        (PPCSmalltalkParserTests autoload)
        (PPCSmalltalkTests autoload)
        (PPCompiledJavaResource autoload)
        (PPCompiledJavaSyntaxTest autoload)
        (PPExpressionGrammar autoload)
        (PPExpressionGrammarTest autoload)
        (PPLL1ExpressionGrammar autoload)
        (PPLL1ExpressionGrammarTest autoload)
        (#'stx_goodies_petitparser_compiler_tests_extras' autoload)
        (PPCExpressionGrammarTest autoload)
        (PPCExpressionGrammarVerificationTest autoload)
        (PPCLL1ExpressionGrammarTest autoload)
        PPCLRPAction
        PPCLRPCompiledParserSmokeTest
        PPCLRPContainedElement
        PPCLRPSpawn
        (#'PPCSmalltalkGrammarTests_Tokenized' autoload)
        (#'PPCSmalltalkGrammarTests_Universal' autoload)
        (PPCSmalltalkGrammarVerificationTest autoload)
        (#'PPCSmalltalkParserTests_Tokenized' autoload)
        (#'PPCSmalltalkParserTests_Universal' autoload)
        (PPCSmalltalkParserVerificationTest autoload)
        (#'PPCExpressionGrammarTest_Tokenized' autoload)
        (#'PPCExpressionGrammarTest_Universal' autoload)
        (#'PPCLL1ExpressionGrammarTest_Tokenized' autoload)
        (#'PPCLL1ExpressionGrammarTest_Universal' autoload)
        PPCLRPComment
        #'PPCLRPCompiledParserSmokeTest_Universal'
        PPCLRPErrorNode
        PPCLRPEvent
        PPCLRPMachine
        PPCLRPOnEntry
        PPCLRPOnExit
        PPCLRPRunning
        PPCLRPState
        PPCLRPTransition
        PPCLRPVariable
        (#'PPCSmalltalkGrammarVerificationTest_Tokenized' autoload)
        (#'PPCSmalltalkGrammarVerificationTest_Universal' autoload)
        (#'PPCSmalltalkParserVerificationTest_Tokenized' autoload)
        (#'PPCSmalltalkParserVerificationTest_Universal' autoload)
        (#'PPExpressionGrammarVerificationTest_Tokenized' autoload)
        (#'PPExpressionGrammarVerificationTest_Universal' autoload)
        PPCLRPEpsilonTransition
        PPCLRPTimeoutTransition
        PPCLRPWildcardTransition
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        PPJavaWhitespaceParser #'='
        PPJavaWhitespaceParser hash
    )
! !

!stx_goodies_petitparser_compiler_tests_extras class methodsFor:'description - project information'!

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

    ^ 'Copyright Claus Gittinger 1988-2015\nCopyright eXept Software AG 1998-2015'
!

productName
    "Returns a product name which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info.
     This method is usually redefined in a concrete application definition"

    ^ 'Smalltalk/X'
! !

!stx_goodies_petitparser_compiler_tests_extras class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

