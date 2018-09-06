"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libbasic2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libbasic2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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

    This library contains additional basic (nonGUI) classes.

    These are less fundamental as in libbasic and not required by many stand alone applications.
    Beside additional container classes, this includes URL support, Zip support,
    PTY, serial line, sockets and IP addresses, and other less frequently needed things.

    Most real world applications will include this, but it is possible to create
    small standAlone apps which do not need it.

    [author:]
        cg

    [primary maintainer:]
        cg
"
! !

!stx_libbasic2 class methodsFor:'description'!

excludedFromPreRequisites
    ^ #(
	#'exept:libcrypt'    "Rc4Cipher - referenced by RandomGenerator class>>new "
	#'stx:goodies/communication'    "FTPClient - referenced by FtpURI>>writeStreamDo:create:atomic: "
	#'stx:libtool'    "FileBrowser - referenced by Archiver::ArchiverOutputParser>>parseLine:forItemClass: "
	#'stx:libview2'    "MIMETypes - referenced by Archiver::ArchiverOutputParser>>parseLine:forItemClass: "
	#'stx:libwidg'    "DialogBox - referenced by Archiver::CompressedFile>>compressFile:to: "
	#'stx:libhtml'    "HTMLParser - referenced by HTMLUtilities class>>plainTextOfHTML: "
	#'stx:goodies/webServer/htmlTree'    "HTML::TreeBuilder - referenced by HTMLPrinterStream>>initialize"
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
        #'stx:libbasic'    "AbstractNumberVector - superclass of HalfFloatArray"
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

!stx_libbasic2 class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBBASIC2_BASE
LIB_BASE=$(LIBBASIC2_BASE)
'
!

additionalDefinitions_bc_dot_mak
    "allows for additional definitions/rules to be added to the bc.mak file.
     Subclasses may redefine this."

    ^'
!!ifdef USEBC
WINSOCK_LIB=ws2_32.lib
!!else
WINSOCK_LIB=
!!endif
'

    "Created: / 12-05-2015 / 19:01:29 / jv"
!

additionalLinkLibraries_bc_dot_mak
    ^ '$(ZLIB_DIR)\$(ZLIB) $(BZ2LIB) $(WINSOCK_LIB)'

    "Modified: / 12-05-2015 / 19:00:25 / jv"
!

additionalLinkLibraries_make_dot_proto
    ^ '$(ZLIB_LD_ARG) $(BZ2LIB_LD_ARG)'
!

additionalRules_bc_dot_mak
    ^ '
$(ZLIB):
        cd $(ZLIB_DIR)
        $(MAKE_BAT)
        cd ..\..\libbasic2

$(BZ2LIB):
        cd $(BZ2LIB_DIR)
        $(MAKE_BAT) 
        cd ..\..\libbasic2
'

    "Modified: / 12-05-2015 / 18:53:34 / jv"
!

additionalRules_make_dot_proto
    ^ '
zlib:
	cd $(ZLIB_DIR); $(MAKE) $(MAKE_ZLIB_ARG)

bz2lib:
	cd $(BZ2LIB_DIR); $(MAKE) $(MAKE_BZ2LIB_ARG) libbz2.a
'
!

additionalTargets_bc_dot_mak
    ^ '$(ZLIB) $(BZ2LIB)'
!

additionalTargets_make_dot_proto
    ^ 'bz2lib zlib'

    "Created: / 05-09-2006 / 16:05:12 / cg"
!

localIncludes
    ^ '-I$(ZLIB_DIR) -I$(BZ2LIB_DIR)'

    "Created: / 06-09-2006 / 18:18:15 / cg"
!

stcOptimizationOptions
    ^ '+optinline +optinline2 +inlinenew'

    "Modified: / 21-02-2011 / 14:13:24 / cg"
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libbasic2 class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        AVLTree
        AbstractBackgroundJob
        ActiveObject
        ActorStream
        Archiver
        AutoResizingOrderedCollection
        BIG5EncodedString
        BTree
        BaseNCoder
        Bezier
        BinaryTree
        BinaryTreeNode
        BoltLock
        CRC32Stream
        CacheDictionary
        CachedValue
        CharacterSet
        Circle
        CollectingReadStream
        CollectingSharedQueueStream
        CompressionStream
        Cons
        ConsStream
        Curve
        DirectoryContents
        DoubleLink
        EllipticalArc
        ExternalLong
        FileSorter
        FileText
        FilteringStream
        FourByteString
        Future
        GBEncodedString
        GeometricSeries
        HTMLUtilities
        HalfFloatArray
        HandlerCollection
        Heap
        IdentityBag
        IncrementNotification
        InterestConverterWithParameters
        InternalPipeStream
        Iterator
        JISEncodedString
        KSCEncodedString
        KeywordInContextIndexBuilder
        Lazy
        LazyArray
        LazyValue
        LineSegment
        List
        LoggingStream
        MacPlistBinaryDecoder
        MappedCollection
        MessageChannel
        Monitor
        MultiReadStream
        NameLookupError
        NumberSet
        OperationQueue
        PhoneticStringUtilities
        PluggableDictionary
        PluggableSet
        Polygon
        PowerSet
        PrinterStream
        PrintfScanf
        PriorityQueue
        Promise
        Queue
        Random
        RandomBlumBlumShub
        RandomKISS
        RandomKISS2
        RandomMT19937
        RandomParkMiller
        RandomRDRand
        RandomTT800
        ReindexedCollection
        RunArray
        SegmentedOrderedCollection
        SelectingReadStream
        SequenceWithSentinel
        SequenceableCollectionSorter
        SerialPort
        SharedCollection
        Singleton
        SmallBag
        Socket
        SocketAddress
        SocketAddressInfo
        SortedSet
        SoundStream
        Spline
        SplittingWriteStream
        Stack
        StringPattern
        StringUtilities
        TSTree
        TSTreeNode
        TerminalSession
        Text
        TextClassifier
        TextStream
        TreeSet
        Trie
        URI
        UUID
        UndoSupport
        UnitConverter
        UnixPTYStream
        ValueLink
        VirtualArray
        ZipArchiveConstants
        #'stx_libbasic2'
        AATree
        AATreeNode
        AppletalkSocketAddress
        Arrow
        ArrowedSpline
        AutoResizingOrderedCollectionWithDefault
        BZip2Stream
        BackgroundJob
        BackgroundPeriodicalJob
        BackgroundQueueProcessingJob
        Base32Coder
        Base64Coder
        BayesClassifier
        Bezier2Segment
        CacheDictionaryWithFactory
        DecNetSocketAddress
        EpsonFX1PrinterStream
        FilteringLineStream
        HPLjetIIPrinterStream
        HTMLPrinterStream
        HierarchicalURI
        HostAddressLookupError
        HostNameLookupError
        IPSocketAddress
        LazyCons
        LineNumberReadStream
        PostscriptPrinterStream
        RandomGenerator
        SharedQueue
        TSMultiTree
        TSMultiTreeNode
        TimedPromise
        UDSocketAddress
        Unicode32String
        ValueDoubleLink
        ZipArchive
        ZipStream
        FileURI
        FtpURI
        HttpURI
        IPv6SocketAddress
        SftpURI
        UnlimitedSharedQueue
        (DoubleLinkedList autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        CharacterArray asKoelnerPhoneticCode
        CharacterArray asSoundexCode
        CharacterArray printf:
        CharacterArray printf:on:
        CharacterArray printfWith:
        CharacterArray printfWith:with:
        CharacterArray printfWith:with:with:
        CharacterArray printfWith:with:with:with:
        CharacterArray #'printf_formatArgCount'
        CharacterArray #'printf_printArgFrom:to:withData:'
        CharacterArray #'printf_printOn:withData:'
        CharacterArray scanf:
        CharacterArray #'scanf_scanArgFrom:to:format:'
        CharacterArray sscanf:
        Float absDecimalPrintOn:digits:
        Float absPrintOn:digits:
        Float absScientificPrintOn:digits:
        Object addInterest:
        Object asDoubleLink
        Object expressInterestIn:for:sendBack:
        Object interests
        Object interestsFor:
        Object onChangeEvaluate:
        Object onChangeSend:to:
        Object removeActionsForEvent:
        Object removeActionsWithReceiver:
        Object removeAllActionsWithReceiver:
        Object removeInterest:
        Object retractInterestIn:for:
        Object retractInterests
        Object retractInterestsFor:
        Object retractInterestsForWhich:
        Object retractInterestsIn:
        Object trigger:
        Object trigger:with:
        Object triggerEvent:
        Object triggerEvent:with:
        Object triggerEvent:withArguments:
        Object when:send:to:
        Object when:send:to:with:
        Object when:sendTo:
        Stream collecting:
        Stream selecting:
    )
! !

!stx_libbasic2 class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:36 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Additional Basic Classes'

    "Modified: / 14-09-2006 / 10:57:15 / cg"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:17:38 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libbasic2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

