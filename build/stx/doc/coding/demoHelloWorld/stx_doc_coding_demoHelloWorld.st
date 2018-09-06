"{ Package: 'stx:doc/coding/demoHelloWorld' }"

"{ NameSpace: Smalltalk }"

ApplicationDefinition subclass:#stx_doc_coding_demoHelloWorld
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_doc_coding_demoHelloWorld class methodsFor:'description'!

excludedFromPreRequisites
    "obsolete; temporarily, this is still called for, but will eventually vanish.
    
     List packages which are to be explicitely excluded from the automatic constructed
     prerequisites lists (both). 
     If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
!

isGUIApplication
    "return true, if this is a GUI application.
     (these need more libraries and use a different startup procedure)"

    ^ false
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "ApplicationDefinition - superclass of stx_doc_coding_demoFactorial"
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

subProjects
    "list packages which are known as subprojects.
     This method is generated automatically; however, when generating automatically,
     packages are only added - never removed, unless listed in #excludedFromSubProjects."

    ^ #(
)
! !

!stx_doc_coding_demoHelloWorld class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        HelloWorld
        #'stx_doc_coding_demoHelloWorld'
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

!stx_doc_coding_demoHelloWorld class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    " ^ self applicationName "
!

applicationName
    "Returns the name of the executable."
    
    ^ 'hello'
!

companyName
    "Returns a company string which will appear in <lib>.rc.
     Under win32, this is placed into the dll's file-info"

    ^ 'eXept Software AG'
!

description
    "Returns a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Hello World Demo Program'
!

legalCopyright
    "Returns a copyright string which will appear in <lib>.rc.
     Under win32, this is placed into the dll's file-info"

    ^ 'Copyright Claus Gittinger 2016'
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Returns a product name which will appear in <lib>.rc.
     Under win32, this is placed into the dll's file-info.
     This method is usually redefined in a concrete application definition"

    ^ 'Hello World in Smalltalk/X'
! !

!stx_doc_coding_demoHelloWorld class methodsFor:'description - startup'!

startupClassName
    "the class that starts the show in its startupSelector method"

    ^ 'HelloWorld'
!

startupSelector
    "the message that is sent to the startupClass to start the show"

    ^ #'start'        
! !

!stx_doc_coding_demoHelloWorld class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/demoHelloWorld/stx_doc_coding_demoHelloWorld.st,v 1.2 2016-10-11 00:09:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/doc/coding/demoHelloWorld/stx_doc_coding_demoHelloWorld.st,v 1.2 2016-10-11 00:09:48 cg Exp $'
! !

