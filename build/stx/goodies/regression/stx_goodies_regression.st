"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_regression
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_regression class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!stx_goodies_regression class methodsFor:'accessing - tests'!

testCaseNamesWithoutNamespace
    ^#(
    'CharacterTests'
     "/ 'SunitXMLOutputTest'
    'ProjectDefinitionTests'
    'CoverageInstrumentationTest'
    'AssociationTests'
    'BinaryIOTests'
    'BinaryTreeTester'
    "/ 'BlockTest'
    'CollectionTests'
    'CompilerTest'
    'ComplexTest'
    "/ 'STCCompilerTests'
    "/ 'DebuggerTest'
    "/ 'DeepCopyTests'
    'DelayTest'
    'DictionaryTest'
    'EnumerationTests'
    'ExceptionTest'
    "/ 'ExternalInterfaceTests'
    "/ 'FileOpenTest'
    'FileStreamTest'
    'FloatTest'
    'FractionTest'
    "/ 'GCTest'
    "/ 'GraphicDrawingTest'
    "/ 'HTMLParserTests'
    "/ 'ImageReaderTest'
    'IntegerTest'
    'JavaScriptTests'
    "/ 'MeasurementValueTests'
    "/ 'MemoryTest'
    'NumberTest'
    'ParserTest'
    'ScaledDecimalTest'
    "/ 'SemaphoreTest'
    "/ 'SharedQueueTest'
    'SmallIntegerTest'
    "/ 'SortTests'
    'StringTests'
    'StreamTests'
    'TimeAndDateTest'
    'TimeDurationTest'
    "/ 'URLTest'
    "/ 'XMLCoderTests'
    "/ 'ZipArchiveTests'
    'ClassBuilderTests'
    'CompilerTests2'
    'ChangeSetTests'
    'FilenameTests'
    'ProjectDefinitionTests'
    'ClassDescriptionTests'
    'SnapshotRestartTests'
    'MakefileTests'
    'TSTreeTests'
    'TSMultiTreeTests'
    'VMCrashTests'
    'ProcessTest'
    'PipeStreamTest'
    'JITTest'
    'BehaviorLookupObjectTests'
    'SelectorNamespacesTests'
    'Win32OperatingSystemTest'
    'PTYTest'
    'RecursionLockTests'
    )

    "Modified: / 18-11-2014 / 11:54:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSuite

    | suite |

    suite := TestSuite named: self package.
    self testCaseNamesWithoutNamespace do:[:className |
	|fullName|

	fullName := ('RegressionTests::',className).
	('Loading ',className,'...') infoPrintCR.
	Smalltalk fileInClass:fullName package:self package.
	(Smalltalk classNamed:fullName) isNil ifTrue:[
	    ('**** Ouch - missing class: "',fullName,'"') infoPrintCR.
	] ifFalse:[
	    suite addTest:(Smalltalk classNamed:fullName) suite.
	].
    ].

    ^suite

    "Created: / 03-08-2011 / 09:19:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_regression class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
	#'exept:libcrypt'    "loaded lazily by CryptTests - SHA256Stream - referenced by RegressionTests::CryptTests>>test06_sha256 "
	#'stx:goodies'    "no project def - CharacterEncoderCodeGenerator - referenced by RegressionTests::CharacterTests>>test01CaseTesting "
    )

    "Modified: / 03-03-2014 / 12:00:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
        #'stx:goodies/sunit'    "TestAsserter - superclass of RegressionTests::SnapshotRestartTests::ToRunOnFreshAndRestartedSnapshotTests"
        #'stx:libbasic'    "Exception - superclass of RegressionTests::ExceptionTest::MyResumableTestError"
        #'stx:libview'    "DisplaySurface - superclass of RegressionTests::WrongMethodCalledTest::GraphicTestView"
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
        #'stx:goodies/communication'    "HTTPInterface - referenced by RegressionTests::HTTPServerTests>>test02_simpleResponses"
        #'stx:goodies/xml/stx'    "XMLStandardCoder - referenced by RegressionTests::XMLCoderTests>>encodeAndDecode:"
        #'stx:goodies/xml/vw'    "XML::Attribute - referenced by RegressionTests::MemoryTest>>test1"
        #'stx:libbasic2'    "ActorStream - referenced by RegressionTests::OperatingSystemTest>>testActorStream"
        #'stx:libbasic3'    "AbstractSourceCodeManager - referenced by RegressionTests::ChangeSetTests>>test_ClassSourceWriter_01"
        #'stx:libboss'    "BinaryIOManager - referenced by RegressionTests::BinaryIOTests>>testBehavior"
        #'stx:libcomp'    "InstrumentationContext - referenced by RegressionTests::CoverageInstrumentationTest>>test_01_instrumentation"
        #'stx:libhtml'    "HTMLDocumentView - referenced by RegressionTests::TestDialogs1>>openDocumentation"
        #'stx:libjava'    "Java - referenced by RegressionTests::VMCrashTests>>iter_java_initialize"
        #'stx:libjavascript'    "JavaScriptCompiler - referenced by RegressionTests::JavaScriptTests>>execute:for:arguments:"
        #'stx:libtool'    "DebugView - referenced by RegressionTests::DebuggerTest>>testBlockVars_01"
        #'stx:libview2'    "ApplicationModel - superclass of RegressionTests::LabelResizingTest"
        #'stx:libwidg'    "Button - referenced by RegressionTests::UTF8TestClass>>someJapaneseButton"
        #'stx:libwidg2'    "HierarchicalItem - referenced by RegressionTests::BinaryIOTests>>testSaveReadBOS"
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

!stx_goodies_regression class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'stx_goodies_regression'
        (#'RegressionTests::VMSpawningTestCase' autoload)
        (#'RegressionTests::AssociationTests' autoload)
        (#'RegressionTests::BecomeTests' autoload)
        (#'RegressionTests::BehaviorLookupObjectTests' autoload)
        (#'RegressionTests::BinaryIOTests' autoload)
        (#'RegressionTests::BinaryTreeTester' autoload)
        (#'RegressionTests::BlockTest' autoload)
        (#'RegressionTests::BreakpointTests' autoload)
        (#'RegressionTests::CECollectionExtensionTest' autoload)
        (#'RegressionTests::CESequenceableCollectionExtensionTest' autoload)
        (#'RegressionTests::CEStringExtensionTest' autoload)
        (#'RegressionTests::CachedValueTest' autoload)
        (#'RegressionTests::CharacterEncoderTests' autoload)
        (#'RegressionTests::CharacterSetTests' autoload)
        (#'RegressionTests::CharacterTests' autoload)
        (#'RegressionTests::ClassAndMethodCompilingTestCase' autoload)
        (#'RegressionTests::ClassDescriptionTests' autoload)
        (#'RegressionTests::ClassWithoutVersionMethod' autoload)
        (#'RegressionTests::CollectionTests' autoload)
        (#'RegressionTests::CompilerTest' autoload)
        (#'RegressionTests::CompilerTests2' autoload)
        (#'RegressionTests::CompilerTests2ExternalBytes' autoload)
        (#'RegressionTests::ComplexTest' autoload)
        (#'RegressionTests::CompressionStreamTest' autoload)
        (#'RegressionTests::ContextTest2' autoload)
        (#'RegressionTests::CoverageInstrumentationTest' autoload)
        (#'RegressionTests::CryptTests' autoload)
        (#'RegressionTests::DebuggerTest' autoload)
        (#'RegressionTests::DeepCopyTests' autoload)
        (#'RegressionTests::DelayTest' autoload)
        (#'RegressionTests::DictionaryTest' autoload)
        (#'RegressionTests::DoubleMetaphoneStringComparatorTest' autoload)
        (#'RegressionTests::EnumerationTests' autoload)
        (#'RegressionTests::ExceptionTest' autoload)
        (#'RegressionTests::ExternalInterfaceTests' autoload)
        (#'RegressionTests::ExternalStreamTest' autoload)
        (#'RegressionTests::FileOpenTest' autoload)
        (#'RegressionTests::FileStreamTest' autoload)
        (#'RegressionTests::FilenameTests' autoload)
        (#'RegressionTests::FloatTest' autoload)
        (#'RegressionTests::FractionTest' autoload)
        (#'RegressionTests::GCTest' autoload)
        (#'RegressionTests::GraphicDrawingTest' autoload)
        (#'RegressionTests::HTMLParserTests' autoload)
        (#'RegressionTests::HTTPServerTests' autoload)
        (#'RegressionTests::ImageReaderTest' autoload)
        (#'RegressionTests::IntegerTest' autoload)
        (#'RegressionTests::JITTest' autoload)
        (#'RegressionTests::JavaScriptTests' autoload)
        (#'RegressionTests::KoelnerPhoneticCodeStringComparatorTest' autoload)
        (#'RegressionTests::LabelResizingTest' autoload)
        (#'RegressionTests::LargeFloatTest' autoload)
        (#'RegressionTests::LinkedListTest' autoload)
        (#'RegressionTests::LiteralsInMethodTests' autoload)
        (#'RegressionTests::LoggedStreamTests' autoload)
        (#'RegressionTests::MakefileTests' autoload)
        (#'RegressionTests::ManyProcessesTest' autoload)
        (#'RegressionTests::MeasurementValueTests' autoload)
        (#'RegressionTests::MemoryTest' autoload)
        (#'RegressionTests::MetaNumbersTest' autoload)
        (#'RegressionTests::MiracodeStringComparatorTest' autoload)
        (#'RegressionTests::MySQLSoundexStringComparatorTest' autoload)
        (#'RegressionTests::NumberTest' autoload)
        (#'RegressionTests::OS_OLE_Tests' autoload)
        (#'RegressionTests::OperatingSystemTest' autoload)
        (#'RegressionTests::OperationInQueueTests' autoload)
        (#'RegressionTests::PTYTest' autoload)
        (#'RegressionTests::ParserTests' autoload)
        (#'RegressionTests::PipeStreamTest' autoload)
        (#'RegressionTests::PowerSetTests' autoload)
        (#'RegressionTests::ProcessTest' autoload)
        (#'RegressionTests::ProjectDefinitionTests' autoload)
        (#'RegressionTests::QueueTest' autoload)
        (#'RegressionTests::QuickTestRunner' autoload)
        (#'RegressionTests::STCCompilerTests' autoload)
        (#'RegressionTests::ScaledDecimalTest' autoload)
        (#'RegressionTests::SegmentedOrderedCollectionTests' autoload)
        (#'RegressionTests::SelectorNamespacesTests' autoload)
        (#'RegressionTests::SemaphoreTest' autoload)
        (#'RegressionTests::ServerSocketTest' autoload)
        (#'RegressionTests::SharedQueueTest' autoload)
        (#'RegressionTests::SmallIntegerTest' autoload)
        (#'RegressionTests::SocketTests' autoload)
        (#'RegressionTests::SortTests' autoload)
        (#'RegressionTests::SoundexStringComparatorTest' autoload)
        (#'RegressionTests::StackFrameTest' autoload)
        (#'RegressionTests::StreamTests' autoload)
        (#'RegressionTests::StringTests' autoload)
        (#'RegressionTests::SunitXMLOutputTest' autoload)
        (#'RegressionTests::TSTreeTests' autoload)
        (#'RegressionTests::TestDialogs1' autoload)
        (#'RegressionTests::TimeAndDateTest' autoload)
        (#'RegressionTests::TimeDurationTest' autoload)
        (#'RegressionTests::TypedArrayTests' autoload)
        (#'RegressionTests::URLTest' autoload)
        (#'RegressionTests::UTF8TestClass' autoload)
        (#'RegressionTests::UninterpretedBytesTest' autoload)
        (#'RegressionTests::WeakCollectionTest' autoload)
        (#'RegressionTests::Win32OLETests' autoload)
        (#'RegressionTests::Win32OperatingSystemTest' autoload)
        (#'RegressionTests::WritingToTranscriptOrStdoutTest' autoload)
        (#'RegressionTests::WrongMethodCalledTest' autoload)
        (#'RegressionTests::XMLCoderTests' autoload)
        (#'RegressionTests::ZipArchiveTests' autoload)
        (#'RegressionTests::ChangeSetTests' autoload)
        (#'RegressionTests::ClassBuilderTests' autoload)
        (#'RegressionTests::SnapshotRestartTests' autoload)
        (#'RegressionTests::TSMultiTreeTests' autoload)
        (#'RegressionTests::VMCrashTestCase' autoload)
        (#'RegressionTests::VMCrashTests' autoload)
        (#'RegressionTests::ProcessSpawningTestCase' autoload)
        (#'RegressionTests::RecursionLockTests' autoload)
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

!stx_goodies_regression class methodsFor:'description - project information'!

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

    ^ 'Class Library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright eXept Software AG 1998-2016, Jan Vrany 2016'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'eXept addOns'
! !

!stx_goodies_regression class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

