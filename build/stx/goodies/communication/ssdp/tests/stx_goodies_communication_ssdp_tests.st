"{ Package: 'stx:goodies/communication/ssdp/tests' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_communication_ssdp_tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_communication_ssdp_tests class methodsFor:'description'!

excludedFromPreRequisites
    "obsolete; temporarily, this is still called for, but will eventually vanish.
    
     List packages which are to be explicitely excluded from the automatic constructed
     prerequisites lists (both). 
     If empty, everything that is found along the inheritance of any of
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
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #(
        #'stx:goodies/sunit'    "TestAsserter - superclass of SSDPTests"
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_communication_ssdp_tests"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #(
        #'stx:goodies/communication/ssdp'    "SSDPClient - referenced by SSDPTests>>test02_simpleClient"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine #referencedPrerequisites or #mandatoryPreRequisites."

    ^ #(
    )
! !

!stx_goodies_communication_ssdp_tests class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        SSDPTests
        #'stx_goodies_communication_ssdp_tests'
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

!stx_goodies_communication_ssdp_tests class methodsFor:'description - project information'!

companyName
    "Returns a company string which will appear in <lib>.rc.
     Under win32, this is placed into the dll's file-info.
     Other systems may put it elsewhere, or ignore it."

    ^ 'Claus Gittinger & eXept Software AG'
!

description
    "Returns a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Returns a copyright string which will appear in <lib>.rc.
     Under win32, this is placed into the dll's file-info.
     Other systems may put it elsewhere, or ignore it."

    ^ 'Copyright Claus Gittinger 2018\nCopyright eXept Software AG 2018'
!

productName
    "Returns a product name which will appear in <lib>.rc.
     Under win32, this is placed into the dll's file-info.
     This method is usually redefined in a concrete application definition"

    ^ 'Smalltalk/X'
! !

!stx_goodies_communication_ssdp_tests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/tests/stx_goodies_communication_ssdp_tests.st,v 1.2 2018-05-14 20:30:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/tests/stx_goodies_communication_ssdp_tests.st,v 1.2 2018-05-14 20:30:42 cg Exp $'
! !

