"{ Package: 'stx:goodies/monticello/test' }"

LibraryDefinition subclass:#stx_goodies_monticello_test
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_monticello_test class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

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
        #'stx:goodies/sunit'    "TestAsserter - superclass of MCAncestryTest "
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_monticello_test "
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
        #'stx:goodies/monticello'    "MCCacheRepository - referenced by MCWorkingCopyTest>>clearPackageCache "
        #'stx:libbasic2'    "UUID - referenced by MCTestCase>>mockVersionInfo: "
        #'stx:libcomp'    "Parser - referenced by MCStWriterTest>>assertChunkIsWellFormed: "
        #'stx:libcompat'    "MczInstaller - referenced by MCInitializationTest>>testWorkingCopy "
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

!stx_goodies_monticello_test class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        MCDependencySorterTest
        MCSnapshotResource
        MCSortingTest
        MCTestCase
        #'stx_goodies_monticello_test'
        MCAncestryTest
        MCChangeNotificationTest
        MCClassDefinitionTest
        MCFileInTest
        MCInitializationTest
        MCMczInstallerTest
        MCMergingTest
        MCMethodDefinitionTest
        MCOrganizationTest
        MCPackageTest
        MCPatchTest
        MCRepositoryTest
        MCScannerTest
        MCSerializationTest
        MCSnapshotBrowserTest
        MCSnapshotTest
        MCStReaderTest
        MCStWriterTest
        MCVersionTest
        MCWorkingCopyTest
        MCDictionaryRepositoryTest
        MCDirectoryRepositoryTest
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_goodies_monticello_test class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2010\nCopyright eXept Software AG 1998-2010'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_monticello_test class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/stx_goodies_monticello_test.st,v 1.3 2013-05-29 00:04:51 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/stx_goodies_monticello_test.st,v 1.3 2013-05-29 00:04:51 vrany Exp $'
! !

