"{ Package: 'stx:goodies/demos/jh/math/fractalApplication' }"

ApplicationDefinition subclass:#stx_goodies_demos_jh_math_fractalApplication
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_demos_jh_math_fractalApplication class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

isGUIApplication
    "return true, if this is a GUI application.
     (these need more libraries and use a different startup procedure)"

    ^ true
!

preRequisites
    "list all required packages.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies and looking for
     global variable accesses. (the browser has a menu function for that)
     Howevery, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPrerequisites method."

    ^ #(
        #'stx:libbasic'    "ApplicationDefinition - superclass of stx_goodies_demos_jh_math_fractalApplication "
        #'stx:libbasic2'    "Random - referenced by Demos::MandelbrotSet>>initColors "
        #'stx:libcomp'
        #'stx:libhtml'    "HTMLDocumentView - referenced by Demos::SuperFormulaApplication>>openDocumentation "
        #'stx:libui'
        #'stx:libview'    "View - superclass of Demos::FractalView "
        #'stx:libview2'    "ApplicationModel - superclass of Demos::FractalApplication "
        #'stx:libwidg'
        #'stx:libwidg2'
    )
!

subProjects
    "list packages which are known as subprojects.
     This method is generated automatically; however, when generating automatically,
     packages are only added - never removed, unless listed in #excludedFromSubProjects."

    ^ #(
)
! !

!stx_goodies_demos_jh_math_fractalApplication class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'Demos::FractalApplication'
        #'Demos::FractalView'
        #'Demos::MandelbrotSet'
        #'Demos::SuperFormula'
        #'Demos::SuperFormulaApplication'
        #'stx_goodies_demos_jh_math_fractalApplication'
        #'Demos::JuliaSet'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_goodies_demos_jh_math_fractalApplication class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Jan Hussaarts'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Demo'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Jan Hussaarts'
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X Demos'
! !

!stx_goodies_demos_jh_math_fractalApplication class methodsFor:'description - startup'!

startupClassName
    "the name of the class which starts the show in its <startupSelector> method.
     Usually, the name of a subclass of StandAloneStartup."

    self error:'undefined startupClass' mayProceed:true.
    ^ '<name of class here>'
!

startupSelector
    "the message that is sent to the startupClass to start the show"

    ^ #'start'        
! !

!stx_goodies_demos_jh_math_fractalApplication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/demos/jh/math/fractalApplication/stx_goodies_demos_jh_math_fractalApplication.st,v 1.1 2012-10-02 11:44:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/demos/jh/math/fractalApplication/stx_goodies_demos_jh_math_fractalApplication.st,v 1.1 2012-10-02 11:44:42 cg Exp $'
! !
