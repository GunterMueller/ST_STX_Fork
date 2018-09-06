"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libcompat
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libcompat class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    Package documentation

    This library contains compatibility classes,
    which are useful when loading code from other Smalltalk dialects.

    Some of the classes found here are simply empty, but mimic the class hierarchy of
    corresponding frameworks in Squeak, VisualWorks, Dolphin or VisualAge Smalltalk dialects.
    
    They usually only allow for an initial fileIn of such imported classes 
    (by giving them a superclass to be loaded).
    Importing then usually involves further rewrite and debugging - 
    especially if the imported code is UI related. 
    Non-UI code (model classes) often works out-of-the-box.

    [author:]
        cg

    [primary maintainer:]
        cg
"
! !

!stx_libcompat class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'stx:goodies/monticello'    "PackageOrganizer - referenced by PackageInfo>>register "
        #'stx:libcomp'    "Parser - referenced by VAST::Application class>>initializeAfterLoad "
        #'stx:libtool'    "Tools::ClassCategoryList - referenced by SystemOrganization class>>addCategory: "
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
        #'stx:libbasic'    "AbstractTime - extended"
        #'stx:libbasic2'    "PluggableDictionary - superclass of Dolphin::PluggableLookupTable"
        #'stx:libbasic3'    "ChangeSet - extended"
        #'stx:libview'    "Color - extended"
        #'stx:libview2'    "ApplicationModel - superclass of Dolphin::Shell"
        #'stx:libwidg'    "Button - superclass of LabeledBooleanView"
        #'stx:libwidg2'    "Slider - superclass of FractionalWidgetView"
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

!stx_libcompat class methodsFor:'description - actions'!

postLoadAction
    "invoked after loading a project"

    super postLoadAction.
    Smalltalk at:#Duration ifAbsentPut:TimeDuration.
! !

!stx_libcompat class methodsFor:'description - compilation'!

additionalDefinitions_nt_dot_mak
    ^ '
# see stdHeader_nt for LIBCOMPAT_BASE
LIB_BASE_LD_ARG=-b:$(LIBCOMPAT_BASE)
'
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libcompat class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        ActionButton
        ActionButtonView
        ActionMenu
        Alien
        Author
        BinaryStream
        BindingReference
        BorderDecorator
        CEnvironment
        CachedImage
        CharacterAttributes
        CharacterBlockScanner
        CodeController
        ColorForm
        ColorPreferencesCollection
        ComposedText
        ComposedTextView
        CompositeView
        CompositionScanner
        CoveragePalette
        CustomHelp
        DialogCompositeController
        DisplayScanner
        #'Dolphin::ClassCategoriesReader'
        #'Dolphin::DeafObject'
        #'Dolphin::Error'
        #'Dolphin::File'
        #'Dolphin::FileDialog'
        #'Dolphin::IXMLDOMDocument'
        #'Dolphin::IXMLDOMNamedNodeMap'
        #'Dolphin::ListPrompter'
        #'Dolphin::LookupTable'
        #'Dolphin::MessageBox'
        #'Dolphin::MethodCategoriesReader'
        #'Dolphin::Mutex'
        #'Dolphin::Notification'
        #'Dolphin::PluggableLookupTable'
        #'Dolphin::Prompter'
        #'Dolphin::SWEnvironment'
        #'Dolphin::SearchPolicy'
        #'Dolphin::SessionManager'
        #'Dolphin::SharedLookupTable'
        #'Dolphin::SharedSet'
        #'Dolphin::Shell'
        DragDropManager
        DragDropManagerTracker
        ErrorDiffusion
        ExternalReadStream
        ExternalWriteStream
        FileDirectory
        FractionalWidgetView
        GapString
        IOAccessor
        ISO8859L1String
        InputState
        InstructionClient
        InstructionStream
        LabeledBooleanView
        ListItemWrapper
        MczInstaller
        MemoryPolicy
        MenuBuilder
        MinimalShellInterface
        MockMedium
        MouseMenuController
        MultiSelectionSequenceView
        NameSpaceOrganizer
        NetNameResolver
        NonInteractiveCompilerErrorHandler
        OpaqueImage
        OrderedDither
        PackageInfo
        ParagraphEditor
        PassivityWrapper
        Pixmap
        PluggableListView
        PluggableTextView
        Polyline
        Preferences
        ProtocolClient
        ProvideAnswerNotification
        RWBinaryOrTextStream
        RasterOp
        #'ReadMe::ST80_ReadMe'
        ScannerTable
        ScheduledControllers
        ScrollValueHolder
        ScrollWrapper
        SelectionInListController
        SelectionMenu
        SelectionTracker
        SmartRefStream
        SourceCodeStream
        #'Squeak::ClassCommentReader'
        #'Squeak::TextAnchor'
        #'Squeak::TextColor'
        #'Squeak::TextEmphasis'
        #'Squeak::TextFontChange'
        #'Squeak::TextURL'
        StrikeFont
        StringCollationPolicy
        StringHolder
        SystemDictionary
        SystemOrganization
        SystemUtils
        SystemVersion
        SystemWindow
        TTFontDescription
        TextAttributes
        TextController
        TextLines
        TextList
        TextStyle
        TimeProfileBrowser
        TriggerButtonController
        TwoByteSymbol
        UILookPolicy
        UIManager
        UISettings
        UnixProcess
        Utilities
        #'V::ApplicationCoordinator'
        #'V::Dynalink32'
        #'V::File'
        #'V::GDIDLL'
        #'V::GraphPane'
        #'V::MainWindow'
        #'V::OLEControlSitePane'
        #'V::OLEStructure'
        #'V::ViewManager'
        #'VAST::CwDataInterchangeConverter'
        #'VAST::CwGlobalMemoryTransferMechanism'
        #'VAST::CwMainWindow'
        #'VAST::CwPrimitive'
        #'VAST::CwTransferMechanism'
        #'VAST::CwWidget'
        #'VAST::ExError'
        #'VAST::LookupTable'
        #'VAST::OSComposite'
        #'VAST::OSDialogBox'
        #'VAST::SubApplication'
        #'VAST::System'
        #'VAST::VastSignal'
        VW5PackageExporter
        WidgetWrapper
        Win32Shell
        #'stx_libcompat'
        DataStream
        #'Dolphin::FileOpenDialog'
        #'Dolphin::FileSaveDialog'
        #'Dolphin::SharedIdentitySet'
        LookPreferences
        MacLookPolicy
        #'V::DynalinkUnderTest'
        #'VAST::Application'
        Win3LookPolicy
        ReferenceStream
        #'VAST::Kernel'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        Behavior allSelectorsInProtocol:
        Behavior defaultNameStemForInstances
        Behavior kindOfSubclass
        Behavior setTraitComposition:
        ByteArray asByteString
        Character asUnicode
        Character charCode
        Character isSafeForHTTP
        CharacterArray asComposedText
        CharacterArray asOneByteString
        CharacterArray asQualifiedReference
        CharacterArray asUrl
        CharacterArray asWideString
        CharacterArray capitalized
        CharacterArray caseInsensitiveLessOrEqual:
        CharacterArray caseSensitiveLessOrEqual:
        CharacterArray charactersExactlyMatching:
        CharacterArray convertToEncoding:
        CharacterArray intervalFromStartLine:startColumn:toEndLine:endColumn:
        CharacterArray intervalOfLine:
        CharacterArray intervalOfLineCorrespondingToIndex:
        CharacterArray lineIndicesDo:
        CharacterArray lines
        CharacterArray openInWorkspaceWithTitle:
        CharacterArray translated
        CharacterArray unescapePercents
        CharacterArray unescapePercentsWithTextEncoding:
        CharacterArray withNoLineLongerThan:
        CharacterArray withSqueakLineEndings
        Class bindingOf:
        Class objectForDataStream:
        Class storeDataOn:
        Class ultimateSourceCodeAt:ifAbsent:
        ClassDescription categoriesFor:
        ClassDescription categoriesForClass
        ClassDescription commentStamp:prior:
        ClassDescription compile:classified:withStamp:
        ClassDescription compile:classified:withStamp:notifying:logSource:
        ClassDescription compileSilently:classified:
        ClassDescription variableByteSubclass:classVariableNames:poolDictionaries:category:
        ClassOrganizer commentStamp
        Collection collectAsSet:
        Collection deepFlatten
        Collection deepFlattenInto:
        Collection detect:ifOne:
        Collection detect:ifOne:ifNone:
        Collection do:displayingProgress:
        Collection equalsTo:
        Collection flatCollect:
        Collection flatCollect:as:
        Collection flatCollectAsSet:
        Collection flatten
        Collection groupedBy:
        Collection groupedBy:affect:
        Collection includesAllOf:
        Collection includesAnyOf:
        Collection intersection:
        Collection nilSafeGroupedBy:
        Collection selectAsSet:
        Collection sorted:
        Collection symmetricDifference:
        Color newTileMorphRepresentative
        GenericException signal:
        Integer #'&'
        Metaclass isTrait
        Method numTemps
        Method timeStamp
        Number asDuration
        Number newTileMorphRepresentative
        Number stringForReadout
        Object becomeForward:
        Object becomeForward:copyHash:
        Object caseError
        Object caseOf:
        Object caseOf:otherwise:
        Object comeFullyUpOnReload:
        Object deepFlattenInto:
        Object deprecated:
        Object explore
        Object implementedBySubclass
        Object inform:
        Object invalidMessage
        Object isInMemory
        Object objectForDataStream:
        Object oneWayBecome:
        Object perform:withEnoughArguments:
        Object readDataFrom:size:
        Object stbFixup:at:
        Object storeDataOn:
        Object stringForReadout
        Object stringRepresentation
        OrderedCollection overlappingPairsCollect:
        Process isTerminated
        Process queueInterrupt:
        ReadStream nextInto:
        SequenceableCollection asTraitComposition
        SequenceableCollection pairsDistanceFrom:
        SequenceableCollection pairsSimilarityWith:
        SequenceableCollection piecesCutWhere:do:
        SequenceableCollection runsFailing:
        SequenceableCollection runsSatisfying:
        SequenceableCollection runsSatisfying:do:
        SequenceableCollection shuffle
        SequenceableCollection shuffle:
        SequenceableCollection sliceFrom:
        SequenceableCollection sliceFrom:to:
        SequenceableCollection sliceTo:
        Set flatCollect:
        Socket bindTo:port:
        Socket localAddress
        Socket primSocketLocalPort:
        Socket receiveUDPDataInto:
        Socket sendUDPData:toHost:port:
        Socket setOption:value:
        Socket socketHandle
        Socket waitForData
        Socket waitForDataForMsecs:ifClosed:ifTimedOut:
        Socket waitForDataIfClosed:
        Stream nextInt32
        Stream nextInt32Put:
        Stream nextLittleEndianNumber:
        Stream nextLittleEndianNumber:put:
        Stream nextPutSqueakString:
        Stream nextSqueakString
        Stream nextSqueakStringOld
        Stream nextString
        Stream nextStringOld
        Stream nextStringPut:
        Stream nextWord
        String asByteString
        String asEnglishPlural
        String asGUID
        String deepFlattenInto:
        String piecesCutWhere:
        String piecesCutWhereCamelCase
        String removePrefix:
        String removeSuffix:
        String replaceSuffix:with:
        String withInternetLineEndings
        Time hour
        Time minute
        Time second
        ZipArchive contentsOf:
        ZipArchive testUTF8
        'ChangeSet class' uniqueNameLike:
        'Collection class' ofSize:
        'FileStream class' readonlyFileNamed:do:
        'GenericException class' signal:
        'ProjectDefinition class' definitionClassForMonticelloPackage:
        'ProjectDefinition class' definitionClassForMonticelloPackage:createIfAbsent:
        'Smalltalk class' allClassesAndTraitsDo:
        'Smalltalk class' allTraits
        'Smalltalk class' globals
        'Smalltalk class' logChange:
        'Smalltalk class' os
        'Smalltalk class' renameClassNamed:as:
        'Smalltalk class' unregisterExternalObject:
        'Smalltalk class' windowSystemName
        'Symbol class' allSymbols
        'Symbol class' tableSize
    )
! !

!stx_libcompat class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:26 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Compatibility'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:17:56 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libcompat class methodsFor:'description - svn'!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'exported'"$"
! !

!stx_libcompat class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/stx_libcompat.st,v 1.109 2018-08-26 19:44:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/stx_libcompat.st,v 1.109 2018-08-26 19:44:56 cg Exp $'
!

version_SVN
    ^ '$Id: stx_libcompat.st,v 1.109 2018-08-26 19:44:56 cg Exp $'
! !

