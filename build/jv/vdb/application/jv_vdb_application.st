"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb/application' }"

"{ NameSpace: Smalltalk }"

ApplicationDefinition subclass:#jv_vdb_application
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!jv_vdb_application class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!jv_vdb_application class methodsFor:'description'!

applicationIconFileName
    "answer the base-name of the application icon (i.e. 'app' in <app>.ico).

     Subclasses MUST redefine this to either return the name of the icon file or
     nil, if they dont have one.
     We NO LONGER SUPPORT THE PREVIOUS APPNAME-DEFAULT,
     because users tend to forget to add the icon file and then get a failing build. "

    ^ 'vdb'.

    "Modified: / 21-09-2014 / 01:35:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

applicationName

    "/ On UNIX, make it `vdb.so` so `vdb` can be launcher script
    ^ 'vdb.do'

    "Created: / 21-09-2014 / 01:35:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 05-06-2017 / 21:08:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

excludedFromPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     prerequisites list. If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
!

isGUIApplication
    "return true, if this is a GUI application.
     (these need more libraries and use a different startup procedure)"

    ^ true
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
        #'stx:libbasic'    "ApplicationDefinition - superclass of jv_vdb_application"
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
        #'jv:libgdbs'    "GDBDebugger - referenced by VDBStartup class>>main:"
        #'jv:vdb'    "RR - referenced by VDBStartup class>>main:"
        #'stx:libbasic2'    "UUID - referenced by VDBStartup class>>applicationUUID"
        #'stx:libtool'    "DebugView - referenced by VDBStartup class>>main:"
    )
!

subProjects
    "list packages which are known as subprojects.
     This method is generated automatically; however, when generating automatically,
     packages are only added - never removed, unless listed in #excludedFromSubProjects."

    ^ #(
)
! !

!jv_vdb_application class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        VDBStartup
        #'jv_vdb_application'
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

!jv_vdb_application class methodsFor:'description - private'!

applicationNameConsole
    "only used for windows builds"

    ^ 'vdb.com'

    "Created: / 05-06-2017 / 21:09:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

applicationNameNoConsole
    "only used for windows builds"
    
    ^ 'vdb.exe'

    "Created: / 05-06-2017 / 21:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!jv_vdb_application class methodsFor:'description - project information'!

companyName
    "Returns a company string which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info"

    ^ 'Jan Vrany'

    "Modified: / 23-11-2017 / 22:33:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Returns a description string which will appear in nt.def / bc.def"

    ^ 'Visual / VM Debugger'

    "Modified: / 23-11-2017 / 22:43:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Returns a copyright string which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info"

    ^ 'Copyright (C) Jan Vrany 2015-now'

    "Modified (format): / 23-11-2017 / 22:36:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ 'vdb'

    "Modified: / 21-09-2014 / 01:34:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productName
    "Returns a product name which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info.
     This method is usually redefined in a concrete application definition"

    ^ self description

    "Modified: / 23-11-2017 / 22:36:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!jv_vdb_application class methodsFor:'description - startup'!

startupClassName
    "the name of the class which starts the show in its <startupSelector> method.
     Usually, the name of a subclass of StandAloneStartup."

    ^ VDBStartup

    "Modified: / 21-09-2014 / 01:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startupSelector
    "the message that is sent to the startupClass to start the show"

    ^ #'start'        
! !

!jv_vdb_application class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

