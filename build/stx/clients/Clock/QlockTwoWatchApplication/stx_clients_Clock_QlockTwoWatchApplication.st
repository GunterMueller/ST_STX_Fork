"{ Package: 'stx:clients/Clock/QlockTwoWatchApplication' }"

"{ NameSpace: Smalltalk }"

ApplicationDefinition subclass:#stx_clients_Clock_QlockTwoWatchApplication
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_clients_Clock_QlockTwoWatchApplication class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

makeConsoleApplication
    ^ true

    "Created: / 05-12-2011 / 03:39:29 / cg"
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "ApplicationDefinition - superclass of stx_clients_Clock_QlockTwoWatchApplication"
        #'stx:libview'    "DeviceGraphicsContext - superclass of QlockTwoWatch"
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
        #'stx:libview2'    "Icon - referenced by QlockTwoWatch class>>aluminum2BG"
    )
!

subProjects
    "list packages which are known as subprojects.
     This method is generated automatically; however, when generating automatically,
     packages are only added - never removed, unless listed in #excludedFromSubProjects."

    ^ #(
)
! !

!stx_clients_Clock_QlockTwoWatchApplication class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        QlockTwoWatch
        QlockTwoWatchStartup
        #'stx_clients_Clock_QlockTwoWatchApplication'
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
    )
! !

!stx_clients_Clock_QlockTwoWatchApplication class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

applicationName
    ^ 'qlocktwo'

    "Created: / 20-12-2011 / 19:39:17 / cg"
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG / Claus Gittinger'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Sample clock written in Smalltalk/X'

    "Modified: / 04-12-2011 / 19:41:33 / cg"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 2011'

    "Modified: / 04-12-2011 / 19:41:52 / cg"
!

productInstallDirBaseName
    "installDir which will appear in <app>.nsi."

    ^ 'qlockTwoDemo'

    "Created: / 21-12-2011 / 16:35:34 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'QLOCKTWO'

    "Modified: / 20-12-2011 / 19:20:02 / cg"
! !

!stx_clients_Clock_QlockTwoWatchApplication class methodsFor:'description - startup'!

startupClassName
    "the class that starts the show in its startupSelector method"

    ^ 'QlockTwoWatchStartup'
! !

!stx_clients_Clock_QlockTwoWatchApplication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Clock/QlockTwoWatchApplication/stx_clients_Clock_QlockTwoWatchApplication.st,v 1.17 2016-04-04 20:31:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Clock/QlockTwoWatchApplication/stx_clients_Clock_QlockTwoWatchApplication.st,v 1.17 2016-04-04 20:31:55 cg Exp $'
! !

