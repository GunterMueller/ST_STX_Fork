"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_builder_reports
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_builder_reports class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'stx:goodies/monticello'    "MCPatch - referenced by HDChangeReport>>changesFor: "
    )

    "Modified: / 08-03-2011 / 22:08:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)"

    ^ #(
        #'stx:goodies/sunit'    "TestAsserter - extended "
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_builder_reports "
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
        #'stx:goodies/refactoryBrowser/browser'    "PackageEnvironment - referenced by Builder::LintReport>>setupForPackages: "
        #'stx:goodies/refactoryBrowser/helpers'    "BrowserEnvironment - referenced by Builder::LintReport>>setupForClasses: "
        #'stx:goodies/refactoryBrowser/lint'    "RBBasicLintRule - referenced by Builder::LintReport>>setUp "
        #'stx:libcomp'    "InstrumentationContext - referenced by Builder::TestReport>>runReport "
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
    )
! !

!stx_goodies_builder_reports class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        (#'Builder::JUnitReportReader' autoload)
        #'Builder::Report'
        #'Builder::ReportFormat'
        #'Builder::ReportRunner'
        #'Builder::ReportSourceInfo'
        #'stx_goodies_builder_reports'
        #'Builder::ChangeReport'
        #'Builder::CoverageReport'
        #'Builder::CoverageReportFormat'
        #'Builder::LintReport'
        #'Builder::LintReportFormat'
        #'Builder::ReportClassSourceInfo'
        #'Builder::ReportExtensionsSourceInfo'
        #'Builder::TestReport'
        #'Builder::TestReportFormat'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
        TestCase nameForHDTestReport
        TestCase selectorForHDTestReport
        'TestCase class' isJUnitTestCaseProxy
        'TestCase class' isTestletTestCaseProxy
        TestCase timeout
    )
! !

!stx_goodies_builder_reports class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'SWING Research Group & eXept Software AG'

    "Modified: / 21-07-2011 / 10:05:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Report Runner for Jenkins CI Server'

    "Modified: / 21-07-2011 / 10:06:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Jan Vrany 2011\nCopyright eXept Software AG 2011'

    "Modified: / 21-07-2011 / 10:05:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'ReportRunner'

    "Modified: / 21-07-2011 / 10:06:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_builder_reports class methodsFor:'description - startup'!

startupClassName
    "the name of the class which starts the show in its <startupSelector> method.
     Usually, the name of a subclass of StandAloneStartup."


    ^ 'HDReportRunner'

    "Modified: / 21-07-2011 / 10:06:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startupSelector
    "the message that is sent to the startupClass to start the show"

    ^ #'start'        
! !

!stx_goodies_builder_reports class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
    "        

    ^ '$URL$'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'exported'"$"
! !

!stx_goodies_builder_reports class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

