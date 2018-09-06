"{ Package: 'stx:goodies/petitparser/parsers/smalltalk' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_petitparser_parsers_smalltalk
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser_parsers_smalltalk class methodsFor:'accessing - monticello'!

monticelloLastMergedVersionInfo
    "The last merged version is: "

    ^ '
    Name: PetitSmalltalk-JanKurs.78
    Author: JanKurs
    Time: 14-11-2014, 05:05:07.765 PM
    UUID: 3d68330d-44d5-46c3-9705-97f627b3edbc              
    Repository: http://smalltalkhub.com/mc/Moose/PetitParser/main
    '

    "Created: / 03-10-2014 / 02:27:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-11-2014 / 10:46:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloName
    "Return name of the package for Monticello. This is used when package is exported"

    ^ 'PetitSmalltalk'

    "Created: / 03-10-2014 / 01:47:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-10-2014 / 09:14:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser_parsers_smalltalk class methodsFor:'accessing - tests'!

testSuite
    "generate and return a testSuite containing all of my test-classes"

    Smalltalk loadPackage: 'stx:goodies/petitparser/parsers/smalltalk'.
    ^ 'stx:goodies/petitparser/parsers/smalltalk' asPackageId projectDefinitionClass testSuite

    "Modified: / 07-10-2014 / 09:16:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser_parsers_smalltalk class methodsFor:'description'!

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
        #'stx:goodies/petitparser'    "PPCompositeParser - superclass of PPSmalltalkGrammar"
        #'stx:goodies/refactoryBrowser/parser'    "RBProgramNode - extended"
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_petitparser_parsers_smalltalk"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     We do not need these packages as a prerequisite for loading or compiling.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes."

    ^ #(
        #'stx:libcomp'    "Scanner - referenced by PPSmalltalkGrammar class>>allowUnderscoreAssignment"
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

!stx_goodies_petitparser_parsers_smalltalk class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        PPSmalltalkGrammar
        PPSmalltalkToken
        PPSmalltalkTokenParser
        PPSmalltalkWhitespaceParser
        #'stx_goodies_petitparser_parsers_smalltalk'
        PPSmalltalkParser
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        PPParser smalltalkToken
        RBProgramNode addComments:
        RBValueToken inputValue
    )
! !

!stx_goodies_petitparser_parsers_smalltalk class methodsFor:'description - project information'!

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

!stx_goodies_petitparser_parsers_smalltalk class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

