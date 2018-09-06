"{ Package: 'stx:libjava/startup' }"

ApplicationDefinition subclass:#stx_libjava_startup
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libjava_startup class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

isGUIApplication
    "return true, if this is a GUI application.
     (these need more libraries and use a different startup procedure)"

    ^ false
!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)"

    ^ #(
        #'stx:libbasic'    "ApplicationDefinition - superclass of stx_libjava_startup "
    )
!

referencedPreRequisites
    "list all packages containing classes referenced by the packages's members.
     This list can be maintained manually or (better) generated and
     updated by looking for global variable accesses
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:libjava'    "Java - referenced by JavaStartup class>>main: "
    )
!

subProjects
    "list packages which are known as subprojects.
     This method is generated automatically; however, when generating automatically,
     packages are only added - never removed, unless listed in #excludedFromSubProjects."

    ^ #(
)
! !

!stx_libjava_startup class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        JavaStartup
        #'stx_libjava_startup'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_libjava_startup class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'SWING Research Group & eXept Software AG'

    "Modified: / 07-04-2011 / 20:22:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Java Launcher'

    "Modified: / 07-04-2011 / 20:23:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright 2010-2011 Jan Vrany, Jan Kurs, Marcel Hlopko\nCopyright 1988-2011Claus Gittinger \nCopyright 1998-2011 eXept Software AG'

    "Modified: / 07-04-2011 / 20:24:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X JVM'

    "Modified: / 07-04-2011 / 20:24:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_startup class methodsFor:'description - startup'!

startupClassName
    "the name of the class which starts the show in its <startupSelector> method.
     Usually, the name of a subclass of StandAloneStartup."

    ^ 'JavaStartup'

    "Modified: / 07-04-2011 / 20:24:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startupSelector
    "the message that is sent to the startupClass to start the show"

    ^ #'start'        
! !

!stx_libjava_startup class methodsFor:'description - svn'!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'nil'"$"
! !

!stx_libjava_startup class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/startup/stx_libjava_startup.st,v 1.6 2015-03-20 13:29:45 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: stx_libjava_startup.st,v 1.6 2015-03-20 13:29:45 vrany Exp $'
! !

