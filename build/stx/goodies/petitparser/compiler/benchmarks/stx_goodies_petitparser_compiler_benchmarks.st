"{ Package: 'stx:goodies/petitparser/compiler/benchmarks' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_petitparser_compiler_benchmarks
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser_compiler_benchmarks class methodsFor:'accessing - monticello'!

monticelloLastMergedVersionInfo
    "The last merged version is: "

    ^ '
    Name: PetitCompiler-Benchmarks-JanKurs.20150510144201
    Author: JanKurs
    Time: 10-05-2015, 05:04:54.561 PM
    UUID: d8e764fd-016b-46e2-9fc1-17c38c18f0e5    
    Repository: http://smalltalkhub.com/mc/JanKurs/PetitParser/main
    '

    "Created: / 03-10-2014 / 02:27:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-05-2015 / 01:19:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloName
    "Return name of the package for Monticello. This is used when package is exported"

    ^ 'PetitCompiler-Benchmarks'

    "Created: / 03-10-2014 / 01:47:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-11-2014 / 00:08:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
        #(HGChangesetId 'f6f68d32de73') #(MCVersionInfo name: 'PetitCompiler-Benchmarks-JanKurs.19' id: '1c342fdb-8ddd-4104-9c47-a8f589c51694' date: '2015-08-24' time: '11:48:47.045' author: 'JanKurs' message: '### Cleanup
- shadow variables removed')

    )
! !

!stx_goodies_petitparser_compiler_benchmarks class methodsFor:'description'!

excludedFromPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     prerequisites list. If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(

    )

    "Modified: / 16-05-2015 / 19:19:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:goodies/petitparser'    "PPCompositeParser - superclass of PPCLRPParser_johanfabry_39"
        #'stx:goodies/petitparser/parsers/smalltalk'    "PPSmalltalkGrammar - superclass of PPCSmalltalkNoopParser"
        #'stx:libbasic'    "Autoload - superclass of PPCSmalltalkNoopParserTests"
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
        #'jv:calipel/s'    "BenchmarkInstance - referenced by PPCBenchmark class>>run:"
        #'stx:goodies/petitparser/compiler'    "PPCCompiler - referenced by PPCBenchmark>>benchmarkSmalltalkParserCompiled"
        #'stx:goodies/petitparser/compiler/tests/extras'    "PPCLRPErrorNode - referenced by PPCLRPParser_johanfabry_39>>errorNode"
        #'stx:goodies/petitparser/parsers/java'    "PPJavaSyntax - referenced by PPCBenchmark>>benchmarkJavaSyntax"
        #'stx:goodies/refactoryBrowser/parser'    "RBArrayNode - referenced by PPCSmalltalkNoopParser>>buildArray:"
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

!stx_goodies_petitparser_compiler_benchmarks class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        PPCBenchmark
        #'PPCLRPParser_johanfabry_39'
        PPCSmalltalkNoopParser
        #'stx_goodies_petitparser_compiler_benchmarks'
        (PPCSmalltalkNoopParserTests autoload)
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
    )
! !

!stx_goodies_petitparser_compiler_benchmarks class methodsFor:'description - project information'!

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

!stx_goodies_petitparser_compiler_benchmarks class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

