"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2009-2011 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libbasic
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libbasic class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2009-2011 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Package documentation:

    This library contains basic (nonGUI) classes.

    These are the fundamental classes which are required for any Smalltalk,
    whether scripting, non-GUI, repl, IDE or end user application.

    Things you find here are mostly classes as described in the ANSI standard.

    There are no GUI dependencies here
    (some conditional code deals with the non-presence of UI classes;
     for example, debugging, for which a non-UI version is provided here)

    Also no developer support classes are found here
    (i.e. Change/History support, compiler etc.).

    [author:]
        cg

    [primary maintainer:]
        cg
"
! !

!stx_libbasic class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'exept:ctypes'    "CType - referenced by ExternalLibraryFunction>>ffiTypeSymbolForType: "
        #'exept:expecco'    "Expecco::ExpeccoXMLDecoder - referenced by ClassDescription>>iconInBrowserForVariableNamed: "
        #'exept:libcrypt'    "HashRandom - referenced by HashStream class>>random "
        #'stx:goodies'    "LockedFileStream - referenced by ClassDescription>>changesStream "
        #'stx:goodies/simpleServices'    "STXScriptingServer - referenced by StandaloneStartup class>>handleScriptingOptionsFromArguments: "
        #'stx:goodies/sunit'    "TestRunner - referenced by UserPreferences>>testRunnerClass "
        #'stx:goodies/xml/stx'    "XMLCoder - referenced by ClassDescription>>fileOutXMLString:on: "
        #'stx:goodies/xml/vw'    "XML::XMLParser - referenced by PeekableStream>>fileInXMLNotifying:passChunk: "
        #'stx:libbasic2'    "List - referenced by Collection>>asList "
        #'stx:libbasic3'    "ClassOrganizer - referenced by ClassDescription>>organization "
        #'stx:libboss'    "BinaryObjectStorage - referenced by PeekableStream>>fileInBinary "
        #'stx:libcomp'    "Parser - referenced by CharacterArray>>isValidSmalltalkIdentifier "
        #'stx:libhtml'    "URL - referenced by CharacterArray>>asURL "
        #'stx:libtool'    "Tools::ToDoListBrowser - referenced by ClassBuilder>>checkInstvarRedefsWith:subclassOf:old:name: "
        #'stx:libview'    "Image - referenced by UserPreferences class>>saveSettings:in: "
        #'stx:libview2'    "ApplicationModel - referenced by ApplicationDefinition class>>startupClassName_code "
        #'stx:libwidg'    "Button - referenced by UserPreferences class>>saveSettings:in: "
        #'stx:libwidg2'    "ProgressNotification - referenced by UserNotification class>>notify:progress: "
        #'stx:libjava'    "Java - referenced by JavaPackage class>>doesNotUnderstand:"
        #'stx:libcompat'    "StringCollationPolicy - referenced by SequenceableCollection>>quickSort:"
    )
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

!stx_libbasic class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBBASIC_BASE
LIB_BASE=$(LIBBASIC_BASE)
'
!

additionalDefinitions_make_dot_proto
    ^ '
# for LINUX-32bit we need also librt.so, in order to resolve clock_gettime@GLIBC_2.2  (see linuxIntern.h)
# for LINUX-64bit we need also librt.so, in order to resolve clock_gettime@GLIBC_2.2.5  (see linuxIntern.h)
ifneq (,$(findstring LINUX,$(CFLAGS)))
LOCAL_SHARED_LIBS=-lrt
endif
'
!

localIncludes
    ^ '-I$(TOP)/librun $(FFI_INCLUDE)'

    "Created: / 06-09-2006 / 18:18:06 / cg"
!

stcOptimizationOptions
    ^ '+optinline +optinline2'

    "Created: / 23-08-2006 / 11:06:17 / cg"
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libbasic class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        Autoload
        Object
        ProtoObject
        AbstractOperatingSystem
        AbstractSourceFileReader
        Annotation
        Behavior
        Boolean
        CharacterEncoder
        ClassBuilder
        ClassCategoryReader
        CmdLineOption
        CmdLineParser
        Collection
        ConfigurableFeatures
        Context
        Continuation
        Delay
        ExecutableFunction
        ExternalAddress
        ExternalLibrary
        Filename
        GenericException
        Geometric
        InlineObject
        InterestConverter
        Link
        Lookup
        Magnitude
        Message
        MiniDebugger
        MiniInspector
        NameSpace
        OSErrorHolder
        OSProcess
        ObjectMemory
        PackageId
        PolymorphicInlineCache
        ProcessorScheduler
        ProgrammingLanguage
        Project
        ProjectDefinition
        ReadEvalPrintLoop
        AbstractLock
        RecursionLock
        Semaphore
        SharedPool
        Signal
        Smalltalk
        StandaloneStartup
        Stream
        SystemChangeNotifier
        UndefinedObject
        UserMessage
        Visitor
        VoidObject
        AbstractTime
        ApplicationDefinition
        ArithmeticValue
        AspectVisitor
        AutoDeletedFilename
        Bag
        BlockContext
        BuiltinLookup
        Character
        #'CharacterEncoderImplementations::ISO10646_1'
        #'CharacterEncoderImplementations::SingleByteEncoder'
        #'CharacterEncoderImplementations::TwoByteEncoder'
        CompiledCode
        ControlInterrupt
        Date
        EventSemaphore
        Exception
        ExternalFunction
        False
        FolderForProjectsDefinition
        HashStream
        InlineObjectPrototype
        JavaPackage
        KeyedCollection
        LibraryDefinition
        LookupKey
        MessageSend
        MiniLogger
        NamespaceAwareLookup
        NoHandlerError
        Notification
        OSHandle
        PeekableStream
        Process
        QuerySignal
        Rectangle
        SequenceableCollection
        Set
        SmalltalkChunkFileSourceReader
        SmalltalkLanguage
        StandaloneStartupHeadless
        True
        UnixFilename
        WeakInterestConverter
        ArrayedCollection
        Association
        Block
        CascadingNotification
        #'CharacterEncoderImplementations::ASCII'
        #'CharacterEncoderImplementations::CP437'
        #'CharacterEncoderImplementations::EBCDIC'
        #'CharacterEncoderImplementations::ISO10646_to_UTF16BE'
        #'CharacterEncoderImplementations::ISO10646_to_UTF8'
        #'CharacterEncoderImplementations::ISO8859_1'
        #'CharacterEncoderImplementations::ISO8859_10'
        #'CharacterEncoderImplementations::ISO8859_11'
        #'CharacterEncoderImplementations::ISO8859_13'
        #'CharacterEncoderImplementations::ISO8859_14'
        #'CharacterEncoderImplementations::ISO8859_15'
        #'CharacterEncoderImplementations::ISO8859_16'
        #'CharacterEncoderImplementations::ISO8859_2'
        #'CharacterEncoderImplementations::ISO8859_3'
        #'CharacterEncoderImplementations::ISO8859_4'
        #'CharacterEncoderImplementations::ISO8859_5'
        #'CharacterEncoderImplementations::ISO8859_6'
        #'CharacterEncoderImplementations::ISO8859_7'
        #'CharacterEncoderImplementations::ISO8859_8'
        #'CharacterEncoderImplementations::KOI8_R'
        #'CharacterEncoderImplementations::MAC_Roman'
        #'CharacterEncoderImplementations::MS_Ansi'
        #'CharacterEncoderImplementations::MS_Arabic'
        #'CharacterEncoderImplementations::MS_Baltic'
        #'CharacterEncoderImplementations::MS_Cyrillic'
        #'CharacterEncoderImplementations::MS_EastEuropean'
        #'CharacterEncoderImplementations::MS_Greek'
        #'CharacterEncoderImplementations::MS_Hebrew'
        #'CharacterEncoderImplementations::MS_Symbol'
        #'CharacterEncoderImplementations::MS_Turkish'
        ClassDescription
        Complex
        ControlRequest
        Dictionary
        EncodedStream
        EndOfStreamNotification
        Error
        ExternalFunctionCallback
        ExternalLibraryFunction
        HaltInterrupt
        IdentitySet
        LinkedList
        MD5Stream
        Method
        MethodDictionary
        NaiveRomanNumberFormatNotification
        Number
        OSFileHandle
        ObjectCoder
        OrderedCollection
        OrderedSet
        Point
        PositionableStream
        ProceedingNotification
        Query
        ReadOnlySequenceableCollection
        RecursiveStoreError
        SHA1Stream
        Time
        TimeoutNotification
        Timestamp
        UnhandledAttributeInLiteralArrayErrorSignal
        UserConfirmation
        UserInterrupt
        UserNotification
        YesToAllConfirmation
        #'stx_libbasic'
        AbortAllOperationRequest
        AbortAllOperationWantedQuery
        AbstractSourceFileWriter
        ActivityNotification
        Array
        BitArray
        BreakPointInterrupt
        #'CharacterEncoderImplementations::ISO10646_to_UTF16LE'
        #'CharacterEncoderImplementations::ISO10646_to_UTF8_MAC'
        #'CharacterEncoderImplementations::ISO10646_to_XMLUTF8'
        #'CharacterEncoderImplementations::ISO8859_9'
        #'CharacterEncoderImplementations::KOI8_U'
        CheapBlock
        CmdLineOptionError
        Fraction
        GetOpt
        IdentityDictionary
        InlineObjectClassDescription
        Integer
        Interval
        IsDebuggingQuery
        LimitedPrecisionReal
        LoadInProgressQuery
        MeasurementValue
        MetaNumber
        Metaclass
        MethodWithBreakpoints
        ObsoleteMethodCallWarning
        OrderedDictionary
        OsError
        PluginSupport
        ProceedableError
        QueryWithoutDefault
        ReadStream
        RecursionError
        RecursiveExceptionError
        RestartProcessRequest
        SameForAllNotification
        SemaphoreSet
        SignalSet
        SnapshotError
        SortedCollection
        StringCollection
        TZTimestamp
        TerminateProcessRequest
        TimeDuration
        UninterpretedBytes
        (UnixFileDescriptorHandle unix)
        (UnixFileHandle unix)
        TTYAttributes
        TTYConstants
        (UnixOperatingSystem unix)
        UserInformation
        UtcTimestamp
        VMInternalError
        VarArgBlock
        Warning
        WeakArray
        WeakIdentitySet
        WeakValueDictionary
        WriteStream
        AbortOperationRequest
        AbstractNumberVector
        AllocationFailure
        AutoloadMetaclass
        BooleanArray
        ByteArray
        CharacterArray
        CharacterWriteStream
        Class
        ClassBuildWarning
        ClassLoadInProgressQuery
        ConversionError
        DeepCopyError
        ExceptionHandlerSet
        ExecutionError
        ExternalBytes
        FixedPoint
        Float
        ImmutableArray
        Infinity
        InvalidPatchError
        LargeInteger
        LongFloat
        OSSignalInterrupt
        (OSXOperatingSystem unix)
        OsIllegalOperation
        OsInaccessibleError
        OsInvalidArgumentsError
        OsNeedRetryError
        OsNoResourcesError
        OsNotification
        OsTransferFaultError
        PackageLoadError
        PackageLoadInProgressQuery
        PrivateMetaclass
        ProceedError
        ReadWriteStream
        ShortFloat
        SmallInteger
        SmalltalkChunkFileSourceWriter
        SomeNumber
        StreamError
        TimeoutError
        UserPreferences
        VarArgCheapBlock
        WeakIdentityDictionary
        WeakValueIdentityDictionary
        AmbiguousMessage
        ArgumentError
        ArithmeticError
        AssertionFailedError
        CharacterEncoderError
        ClassBuildError
        ContextError
        DateConversionError
        DoubleArray
        ElementBoundsError
        EndOfStreamError
        ExternalStream
        ExternalStructure
        FloatArray
        ImmutableByteArray
        IncompleteNextCountError
        InvalidCodeError
        InvalidModeError
        InvalidOperationError
        InvalidTypeError
        MallocFailure
        MessageNotUnderstood
        MethodNotAppropriateError
        NoModificationError
        NonBooleanReceiverError
        NotFoundError
        NumberConversionError
        OpenError
        PackageNotFoundError
        PositionError
        PositionOutOfBoundsError
        PrimitiveFailure
        ReadError
        Registry
        SignalError
        SignedByteArray
        StreamIOError
        StreamNotOpenError
        String
        SubclassResponsibilityError
        TimeConversionError
        TwoByteString
        UnboxedIntegerArray
        UnimplementedFunctionalityError
        UnprotectedExternalBytes
        WeakDependencyDictionary
        WriteError
        AbstractClassInstantiationError
        BadLiteralsError
        CachingRegistry
        CannotResumeError
        CannotReturnError
        DecodingError
        DomainError
        EncodingError
        FileDoesNotExistException
        FileStream
        HandleRegistry
        ImmutableString
        IndexNotFoundError
        IntegerArray
        InvalidByteCodeError
        InvalidInstructionError
        InvalidReadError
        InvalidWriteError
        KeyNotFoundError
        LongIntegerArray
        MissingClassInLiteralArrayErrorSignal
        NoByteCodeError
        NonPositionableExternalStream
        NumberFormatError
        PTYOpenError
        PackageNotCompatibleError
        RangeError
        SignedIntegerArray
        SignedLongIntegerArray
        SignedWordArray
        Symbol
        UnboundedExternalStream
        Unicode16String
        UnorderedNumbersError
        WordArray
        WrongNumberOfArgumentsError
        WrongProceedabilityError
        CharacterRangeError
        DirectoryStream
        ImaginaryResultError
        InvalidEncodingError
        NonIntegerIndexError
        OverflowError
        PipeStream
        RomanNumberFormatError
        SubscriptOutOfBoundsError
        UnderflowError
        ZeroDivide
        BadRomanNumberFormatError
        (PCFilename win32)
        (Win32Constants win32)
        (Win32Handle win32)
        (Win32FILEHandle win32)
        (Win32OperatingSystem win32)
        (OpenVMSFileHandle vms)
        (OpenVMSFilename vms)
        (OpenVMSOperatingSystem vms)
        (SqueakCommentReader autoload)
        (SimpleExternalLibraryFunction autoload)
        (QualifiedName autoload)
        (AbstractDesktop autoload)
        (#'CharacterEncoderImplementations::BIG5' autoload)
        (#'CharacterEncoderImplementations::CNS11643' autoload)
        (#'CharacterEncoderImplementations::GB2313_1980' autoload)
        (#'CharacterEncoderImplementations::HANGUL' autoload)
        (#'CharacterEncoderImplementations::ISO10646_to_JavaText' autoload)
        (#'CharacterEncoderImplementations::ISO10646_to_SGML' autoload)
        (#'CharacterEncoderImplementations::JIS0201' autoload)
        (#'CharacterEncoderImplementations::JIS0208' autoload)
        (#'CharacterEncoderImplementations::JIS0208_to_EUC' autoload)
        (#'CharacterEncoderImplementations::JIS0208_to_JIS7' autoload)
        (#'CharacterEncoderImplementations::JIS0208_to_SJIS' autoload)
        (#'CharacterEncoderImplementations::JIS0212' autoload)
        (#'CharacterEncoderImplementations::JOHAB' autoload)
        (#'CharacterEncoderImplementations::KOI7' autoload)
        (#'CharacterEncoderImplementations::KSC5601' autoload)
        (#'CharacterEncoderImplementations::MAC_Arabic' autoload)
        (#'CharacterEncoderImplementations::MAC_CentralEuropean' autoload)
        (#'CharacterEncoderImplementations::MAC_Croatian' autoload)
        (#'CharacterEncoderImplementations::MAC_Cyrillic' autoload)
        (#'CharacterEncoderImplementations::MAC_Dingbats' autoload)
        (#'CharacterEncoderImplementations::MAC_Farsi' autoload)
        (#'CharacterEncoderImplementations::MAC_Greek' autoload)
        (#'CharacterEncoderImplementations::MAC_Hebrew' autoload)
        (#'CharacterEncoderImplementations::MAC_Iceland' autoload)
        (#'CharacterEncoderImplementations::MAC_Japanese' autoload)
        (#'CharacterEncoderImplementations::MAC_Korean' autoload)
        (#'CharacterEncoderImplementations::MAC_Romanian' autoload)
        (#'CharacterEncoderImplementations::MAC_Symbol' autoload)
        (#'CharacterEncoderImplementations::MAC_Thai' autoload)
        (#'CharacterEncoderImplementations::MAC_Turkish' autoload)
        (#'CharacterEncoderImplementations::NEXT' autoload)
        (CmdLineParserTest autoload)
        (GNOMEDesktop autoload)
        (LargeFloat autoload)
        (MacFilename macos autoload)
        (MappedExternalBytes autoload)
        (NotANumber autoload)
        (SmalltalkDesktop autoload)
        (SystemNotification autoload)
        (TextCollectorStream autoload)
        (UnixDesktop autoload)
        (WindowsDesktop autoload)
        (XDGDesktop autoload)
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

!stx_libbasic class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:38 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Basic Classes'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 2013'

    "Modified: / 18-11-2016 / 12:17:34 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libbasic class methodsFor:'description - svn'!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'exported'"$"
! !

!stx_libbasic class methodsFor:'documentation'!

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
    ^ '$ Id: stx_libbasic.st 10648 2011-06-23 15:55:10Z vranyj1  $'
! !


