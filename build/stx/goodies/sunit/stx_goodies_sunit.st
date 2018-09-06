"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_sunit
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_sunit class methodsFor:'documentation'!

documentation
"
    Package documentation:

    This library contains the sunit test framework,
    including an old (now obsolete) version of the test runner.
    There are now both an improved multi-pane testRunner application
    and also a testrunner integrated in the browser (shown whenever a testcase class
    is selected).
"
! !

!stx_goodies_sunit class methodsFor:'description'!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:libbasic'    "String - extended "
        #'stx:libview2'    "ApplicationModel - superclass of TestRunner "
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
        #'stx:libbasic2'    "SplittingWriteStream - referenced by TestResultStX>>performCase: "
        #'stx:libview'    "Color - referenced by TestRunner>>displayNormalColorInProgress "
    )
! !

!stx_goodies_sunit class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        (ExampleTestResource autoload)
        SUnitDelay
        SUnitNameResolver
        TestAsserter
        TestFailure
        TestResult
        TestResultReporter
        TestRunner
        TestSuite
        TestSuitesScripter
        #'stx_goodies_sunit'
        ResumableTestFailure
        TestCase
        TestCaseWithArguments
        TestResource
        (ExampleSetTest autoload)
        (ResumableTestFailureTestCase autoload)
        (SUnitTest autoload)
        (SimpleTestResource autoload)
        (SimpleTestResourceTestCase autoload)
        (FailingTestResourceTestCase autoload)
        (ManyTestResourceTestCase autoload)
        (SimpleTestResourceA autoload)
        (SimpleTestResourceA1 autoload)
        (SimpleTestResourceA2 autoload)
        (SimpleTestResourceB autoload)
        (SimpleTestResourceB1 autoload)
        (SimpleTestResourceCircular autoload)
        (SimpleTestResourceCircular1 autoload)
        (CircularTestResourceTestCase autoload)
        (TestSuitesHierarchyScriptTest autoload)
        (TestSuitesCompoundScriptTest autoload)
        (TestSuitesScriptTest autoload)   
        TestCaseOutcome
        TestResultStX
        TestResultForRunWithDebug
        (SUnitTests2 autoload)
        TestCoverageReporter
        MetricsReporter
        TestSkipped
    )

    "Modified: / 03-09-2016 / 09:05:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
        Block sunitEnsure:
        Block sunitOn:do:
        GenericException sunitAnnounce:toResult:
        GenericException sunitExitWith:
        Object sunitAddDependent:
        Object sunitChanged:
        Object sunitRemoveDependent:
        String sunitAsSymbol
        String sunitMatch:
        String sunitSubStrings
        Symbol sunitAsClass
        'GenericException class' sunitSignalWith:
        Behavior sunitSelectors
        Class sunitName
    )
! !

!stx_goodies_sunit class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Unit Testing'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger\nCopyright eXept Software AG 2007'

    "Modified: / 18-11-2016 / 12:16:48 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_sunit class methodsFor:'description - svn'!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'Nicht versioniertes Verzeichnis'"$"
! !

!stx_goodies_sunit class methodsFor:'documentation'!

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

