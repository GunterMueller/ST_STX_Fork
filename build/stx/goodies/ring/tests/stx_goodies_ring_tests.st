"{ Package: 'stx:goodies/ring/tests' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_ring_tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_ring_tests class methodsFor:'description'!

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
        #'stx:goodies/sunit'    "TestAsserter - superclass of RGClassDefinitionTest"
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_ring_tests"
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
        #'stx:goodies/ring'    "RGClassDefinition - referenced by RGClassDefinitionTest>>testAddingMethods"
        #'stx:libbasic2'    "Text - referenced by RGClassDefinitionTest>>testWithPoolDictionaries"
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

!stx_goodies_ring_tests class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        RGClassDefinitionTest
        RGCommentDefinitionTest
        RGContainerTest
        RGGlobalDefinitionTest
        RGMetaclassDefinitionTest
        RGMetatraitDefinitionTest
        RGMethodDefinitionTest
        RGNamespaceTest
        RGPackageTest
        RGSliceTest
        RGTraitDefinitionTest
        RGVariableDefinitionTest
        #'stx_goodies_ring_tests'
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
    )
! !

!stx_goodies_ring_tests class methodsFor:'description - project information'!

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

    ^ 'Copyright Claus Gittinger 1988-2015\nCopyright eXept Software AG 2015'
!

productName
    "Returns a product name which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info.
     This method is usually redefined in a concrete application definition"

    ^ 'Smalltalk/X'
! !

!stx_goodies_ring_tests class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !
