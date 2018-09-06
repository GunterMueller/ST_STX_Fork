"{ Package: 'stx:clients/Demos/foxCalcApplication' }"

"{ NameSpace: Smalltalk }"

ApplicationDefinition subclass:#stx_clients_Demos_foxCalcApplication
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_clients_Demos_foxCalcApplication class methodsFor:'description'!

excludedFromPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     prerequisites list. If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
!

isConsoleApplication
    "/ ^ true.
    ^ false
!

isGUIApplication
    ^ true
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "ApplicationDefinition - superclass of stx_clients_Demos_foxCalcApplication"
        #'stx:libview2'    "ApplicationModel - superclass of CodingExamples_GUI::GUIDemoFoxCalculatorClone"
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
        #'stx:libview'    "Depth1Image - referenced by CodingExamples_GUI::GUIDemoFoxCalculatorClone class>>questIcon"
    )
!

subProjects
    ^ #(
)
! !

!stx_clients_Demos_foxCalcApplication class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'CodingExamples_GUI::GUIDemoFoxCalculatorClone'
        #'stx_clients_Demos_foxCalcApplication'
        (#'CodingExamples_GUI::FoxCalcCloneStartup' autoload)
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
    )
! !

!stx_clients_Demos_foxCalcApplication class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

applicationName
    ^ 'stxFoxClone'
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'ST/X FoxCalc Clone Demo'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 2008'
!

productInstallDir
    "App Specific default path"

    ^ '$PROGRAMFILES\','exept\stxFoxClone'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X Demo Calculator'
! !

!stx_clients_Demos_foxCalcApplication class methodsFor:'description - startup'!

startupClassName
    ^ 'CodingExamples_GUI::FoxCalcCloneStartup'
!

startupSelector
    ^ #'start'        
! !

!stx_clients_Demos_foxCalcApplication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/foxCalcApplication/stx_clients_Demos_foxCalcApplication.st,v 1.20 2016-03-27 12:30:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/foxCalcApplication/stx_clients_Demos_foxCalcApplication.st,v 1.20 2016-03-27 12:30:19 cg Exp $'
! !

