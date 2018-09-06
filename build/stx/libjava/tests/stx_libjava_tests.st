"{ Package: 'stx:libjava/tests' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libjava_tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libjava_tests class methodsFor:'accessing - tests'!

excludedFromTestSuite  
    "List of testcases and/or tests excluded from testsuite.
     Entries maybe ClassName or #(ClassName testName)
    "
    ^ #(
        LookupTests
    )

    "Created: / 03-06-2011 / 17:04:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSuite

    | suite javaTestCases stTests |
    suite := super testSuite.
    stTests := suite tests.
    suite := TestSuite new.
    suite name: self package.
    JavaTestsLoader load.

    javaTestCases := OrderedCollection new.

    Java allClassesDo:
        [:jclass|
        (jclass binaryName ~~ #'stx/libjava/tests/JUnit3Tests'
            and:[jclass binaryName ~~  #'stx/libjava/tests/JUnit4Tests'
                and:[jclass isTestCaseLike]])
                    ifTrue:
                        [ | tc |
                        tc := jclass asTestCase.
                        tc isAbstract ifFalse:[javaTestCases add:tc ]]].

    javaTestCases do:
                [:each | 
                suite addTests:each buildSuite tests ].


    suite tests addAll: stTests.

    suite tests withIndexDo:
        [:t :i|
        Stdout nextPutAll: i printString; space; nextPutAll: t printString; cr].

    Java dumpConfigOn: Stdout.
    ^suite

    "
        stx_libjava testSuite

    "

    "Created: / 07-05-2011 / 19:58:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2011 / 17:23:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-02-2013 / 10:24:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_tests class methodsFor:'description'!

excludedFromPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     prerequisites list. If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
!

includedInPreRequisites
    "list packages which are to be implicitely included in the prerequisites list,
     even if not found by the automatic search.
     Redefine this, if classes from other packages are referred to via reflection
     or by constructing names dynamically (i.e. the search cannot find it)"

    ^ #(
        #'stx:libjava/libs' "/ For tests to compile
    )

    "Created: / 21-03-2016 / 00:27:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_libjava_tests"
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
        #'stx:goodies/sunit'    "TestSuite - referenced by stx_libjava_tests class>>testSuite"
        #'stx:libjava'    "Java - referenced by stx_libjava_tests class>>testSuite"
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

!stx_libjava_tests class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'stx_libjava_tests'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
    )
! !

!stx_libjava_tests class methodsFor:'description - java'!

javaBundle
    
    ^ JavaCodeBundle standardPackageBundleFor: self package
! !

!stx_libjava_tests class methodsFor:'description - project information'!

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

!stx_libjava_tests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

