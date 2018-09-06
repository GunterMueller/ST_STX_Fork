"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_petitparser_compiler_tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser_compiler_tests class methodsFor:'accessing - monticello'!

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
    "Modified: / 24-08-2015 / 15:27:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloName
    "Return name of the package for Monticello. This is used when package is exported"

    ^ 'PetitCompiler-Tests'

    "Created: / 03-10-2014 / 01:47:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-10-2014 / 01:27:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
        #(HGChangesetId 'f6f68d32de73') #(MCVersionInfo name: 'PetitCompiler-Tests-JanKurs.116' id: '549e0927-358a-4a1b-8270-050ccfcb4217' date: '2015-08-24' time: '11:37:54.332' author: 'JanKurs' message: '- More tests for Scanner
- Scanner workflow tests (i.e. scan_XY, token_XY, consume_XY)...')

    )
! !

!stx_goodies_petitparser_compiler_tests class methodsFor:'description'!

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
        #'stx:goodies/petitparser/tests'    "PPAbstractParserTest - superclass of PPCCodeGeneratorTest"
        #'stx:goodies/sunit'    "TestAsserter - superclass of FooScannerTest"
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_petitparser_compiler_tests"
        #'stx:libcompat'
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
        #'stx:goodies/petitparser'    "PPCharSetPredicate - referenced by PEGFsaGeneratorTest>>testCharSetPredicateNode"
        #'stx:goodies/petitparser/compiler'    "FooScanner - referenced by FooScannerTest>>setUp"
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
     for those, redefine requiredPrerequisites."

    ^ #(
    )
! !

!stx_goodies_petitparser_compiler_tests class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        FooScannerTest
        PEGFsaChoiceDeterminizationTest
        PEGFsaDeterminizationTest
        PEGFsaGeneratorTest
        PEGFsaIntegrationTest
        PEGFsaInterpretTest
        PEGFsaMinimizationTest
        PEGFsaScannerIntegrationTest
        PEGFsaSequenceDeterminizationTest
        PEGFsaStateTest
        PEGFsaTest
        PEGFsaTransitionTest
        PPCASTUtilitiesTests
        PPCClassBuilderTest
        PPCCodeGeneratorTest
        PPCContextMementoTest
        PPCContextTest
        PPCCopyVisitorTest
        PPCDistinctScannerTest
        PPCGuardTest
        PPCIdGeneratorTest
        PPCInliningVisitorTest
        PPCLL1VisitorTest
        PPCLTokenizingOptimizationTest
        PPCMergingVisitorTest
        PPCMockCompiler
        PPCNodeFirstFollowNextTests
        PPCNodeTest
        PPCOptimizeChoicesTest
        PPCOverlappingTokensTest
        PPCRecognizerComponentDetectorTest
        PPCRecognizerComponentVisitorTest
        PPCScannerCodeGeneratorTest
        PPCSpecializingVisitorTest
        PPCTokenDetectorTest
        PPCTokenGuardTest
        PPCTokenizingCodeGeneratorTest
        PPCTokenizingTest
        PPCTokenizingVisitorTest
        PPCUnivarsalGuardTest
        PPCUniversalOptimizationTest
        PPCUniversalTest
        #'stx_goodies_petitparser_compiler_tests'
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
    )
! !

!stx_goodies_petitparser_compiler_tests class methodsFor:'description - project information'!

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

!stx_goodies_petitparser_compiler_tests class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

