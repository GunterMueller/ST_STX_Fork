"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libview2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libview2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
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
    Package Documentation

    This library contains additional graphics-interfacing components and infrastructure.
    This includes support classes for the applicationModel framework, and readers/writers
    for various bitmap image file formats (PNG, GIF, TIFF, etc.)

    As with libview, this does not contain widget classes or applications/tools.
"
! !

!stx_libview2 class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
	#'stx:goodies/webServer'    "HTTPServer - referenced by ApplicationModel>>initializeWebServiceDevice "
	#'exept:httpPortal'    "HTTPPortalService - referenced by ApplicationModel class>>startAsWebService:onPort: "
	#'stx:libwidg'    "Label - referenced by ActiveHelpView>>contents: "
	#'stx:libwidg2'    "LabelAndIcon - referenced by MenuItem>>labelImage: "
	#'stx:libtool'    "AboutBox - referenced by ToolApplicationModel>>xxopenAboutThisApplication "
	#'stx:libtool2'    "ImageEditor - referenced by ResourceSpecEditor>>doEditImage "
	#'stx:libcompat'    "TextAttributes - referenced by WindowBuilder>>resolveFont: "
	#'stx:libhtml'    "HTMLDocumentView - referenced by ApplicationModel>>openDocumentationFile: "
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "ArrayedCollection - extended"
        #'stx:libbasic2'    "PrinterStream - superclass of WinPrinterStream"
        #'stx:libview'    "Color - superclass of ColorValue"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     We do not need these packages as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes."

    ^ #(
        #'stx:libui'    "ComponentSpec - referenced by UIBuilder>>add:"
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

!stx_libview2 class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBVIEW2_BASE
LIB_BASE=$(LIBVIEW2_BASE)
'
!

additionalDefinitions_bc_dot_mak
    ^ '
# LIBJPEG_DIR=$(TOP)\support\libjpeg-6a
LIBJPEG_DIR=$(TOP)\support\libjpeg-9

!!if defined(USEMINGW32) || defined(USEMINGW64)
!! if defined(USEMINGW32)
LIBJPEG_TARGET = i686-pc-mingw32
!! else
LIBJPEG_TARGET = x86_64-w64-mingw32
!! endif
LIBJPEG=$(LIBJPEG_DIR)\$(LIBJPEG_TARGET)\.libs\libjpeg.a
CLOCAL_INCL=-I"$(LIBJPEG_DIR)" -I"$(LIBJPEG_DIR)\$(LIBJPEG_TARGET)"
!!else
LIBJPEG=$(LIBJPEG_DIR)\$(OBJDIR)\libjpeg.lib
CLOCAL_INCL=-I"$(LIBJPEG_DIR)"
!!endif


'

    "Created: / 22-08-2006 / 23:58:05 / cg"
    "Modified: / 23-01-2017 / 12:09:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalDefinitions_make_dot_proto
    ^ '
# LIBJPEG_DIR=$(TOP)/support/libjpeg-6a
LIBJPEG_DIR=$(TOP)/support/libjpeg-9

# Following is a hack for Smalltalk/X jv-branch 6.x.x builds
# that DO NOT use GNU target triplets as BUILD_TARGET.
# So, normalize here:
ifeq ($(BUILD_TARGET), linux-i386)
LIBJPEG_TARGET = i686-pc-linux-gnu
else
ifeq ($(BUILD_TARGET), linux-x86_64)
LIBJPEG_TARGET = x86_64-pc-linux-gnu
else
LIBJPEG_TARGET = $(BUILD_TARGET)
endif
endif
LIBJPEG=$(LIBJPEG_DIR)/$(LIBJPEG_TARGET)/.libs/libjpeg.a

'

    "Created: / 24-09-2017 / 19:57:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalLinkLibraries_bc_dot_mak
    ^ '$(LIBJPEG)'
!

additionalLinkLibraries_make_dot_proto
    ^ '$(LIBJPEG)'

    "Modified: / 24-09-2017 / 19:57:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRules_bc_dot_mak
    ^ '
!!if defined(USEMINGW32) || defined(USEMINGW64)
$(LIBJPEG): $(LIBJPEG_DIR)/$(LIBJPEG_TARGET)/config.status
    pushd $(LIBJPEG_DIR)\$(LIBJPEG_TARGET) & set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & make

$(LIBJPEG_DIR)/$(LIBJPEG_TARGET)/config.status:
    -md $(LIBJPEG_DIR)\$(LIBJPEG_TARGET)
    pushd $(LIBJPEG_DIR)\$(LIBJPEG_TARGET) & set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & bash ../configure --build=$(LIBJPEG_TARGET)

clobber::
    -rd /S /Q $(LIBJPEG_DIR)\$(LIBJPEG_TARGET)

clean::
    -pushd $(LIBJPEG_DIR) & set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & IF EXIST makefile (make clean)

$(OUTDIR)JPEGReader.$(O):: $(LIBJPEG_DIR)\$(LIBJPEG_TARGET)\jconfig.h
$(LIBJPEG_DIR)\$(LIBJPEG_TARGET)\jconfig.h: $(LIBJPEG)

!!else
$(LIBJPEG):
    cd $(LIBJPEG_DIR)
    $(MAKE_BAT)
    cd ..\..\libview2
$(OUTDIR)JPEGReader.$(O):: $(LIBJPEG_DIR)\jconfig.h
$(LIBJPEG_DIR)\jconfig.h: $(LIBJPEG)
!!endif


'

    "Created: / 22-08-2006 / 23:58:29 / cg"
    "Modified: / 24-09-2017 / 20:01:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRules_make_dot_proto
    ^ '
$(LIBJPEG): $(LIBJPEG_DIR)/$(LIBJPEG_TARGET)/config.status
        $(MAKE) -C $(LIBJPEG_DIR)/$(LIBJPEG_TARGET)

$(LIBJPEG_DIR)/$(LIBJPEG_TARGET)/config.status:
        mkdir -p $(LIBJPEG_DIR)/$(LIBJPEG_TARGET)
        cd $(LIBJPEG_DIR)/$(LIBJPEG_TARGET) && CC="$(CC) $(CCCONFOPT)" ../configure --build=$(LIBJPEG_TARGET)

clobber::
        rm -rf $(LIBJPEG_DIR)/$(LIBJPEG_TARGET)

clean::
        if [ -f $(LIBJPEG_DIR)/$(LIBJPEG_TARGET)/Makefile ]; then make -C $(LIBJPEG_DIR)/$(LIBJPEG_TARGET) clean; fi

'

    "Created: / 22-08-2006 / 23:58:51 / cg"
    "Modified: / 24-09-2017 / 20:35:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_bc_dot_mak
    "additional targets to be added to the nt.mak file."

    ^ '$(LIBJPEG)'

    "Created: / 23-08-2006 / 00:01:19 / cg"
!

additionalTargets_make_dot_proto
    "additional targets to be added to the make.proto file."

    ^ '$(LIBJPEG)'

    "Created: / 22-08-2006 / 23:54:37 / cg"
    "Modified: / 24-09-2017 / 20:01:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

localIncludes
    ^ '-I$(LIBJPEG_DIR)/$(LIBJPEG_TARGET) -I$(LIBJPEG_DIR)'
!

stcOptimizationOptions
    ^ '+optinline'

    "Created: / 23-08-2006 / 11:27:11 / cg"
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libview2 class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        ActiveHelpView
        ApplicationSubView
        ApplicationWindow
        ColorValue
        DisplayObject
        DragAndDropManager
        DragHandler
        DrawAdaptor
        DropContext
        DropObject
        DropSource
        DropTarget
        EventListener
        ExternalTopView
        GIFReader
        Icon
        ImageFrame
        ImageSequence
        InputView
        JPEGReader
        KeyboardProcessor
        Layout
        MIMETypeIconLibrary
        MIMETypes
        MacOSXIconReader
        MenuItem
        Model
        MultiImage
        PNGReader
        PopUpBanner
        PrintConverter
        PrinterContext
        PropertyListDictionary
        ResourceRetriever
        StandardSystemController
        TIFFReader
        TransparentBox
        VisualRegion
        (WinPrinterStream win32)
        WindowBuilder
        WindowsIconReader
        XBMReader
        XPMReader
        #'stx_libview2'
        ActiveHelp
        ApplicationModel
        LayoutOrigin
        Menu
        Plug
        PluggableEventListener
        ScreenLock
        UIBuilder
        ValueModel
        VisualComponent
        (WinPrinterContext win32)
        AlignmentOrigin
        ApplicationWithFileHistory
        BlockValue
        FlyByHelp
        IndirectValue
        LayoutFrame
        PluggableAdaptor
        ProtocolAdaptor
        SimpleDialog
        ToolApplicationModel
        ValueHolder
        VisualPart
        AspectAdaptor
        BooleanBlockValue
        BooleanValueHolder
        BufferedValueHolder
        DictionaryAdaptor
        RangeAdaptor
        ResourceSpecEditor
        TriggerValue
        TypeConverter
        ValueHolderWithRememberedPreviousValue
        ValueHolderWithWeakDependents
        AspectAdaptorWithDefault
        (Wrapper autoload)
        (TranslatingWrapper autoload)
        (LayoutWrapper autoload)
        (BoundedWrapper autoload)
        (AVIReader autoload)
        (ApplicationController autoload)
        (BlitImageReader autoload)
        (BorderedWrapper autoload)
        (CompositePart autoload)
        (CompositeTransform autoload)
        (ConvertedValue autoload)
        (DependentPart autoload)
        (FLIReader autoload)
        (FaceReader autoload)
        (GeometricWrapper autoload)
        (StrokingOrFillingWrapper autoload)
        (FillingWrapper autoload)
        (HersheyFont autoload)
        (Insets autoload)
        (IrisRGBReader autoload)
        (MatrixTransform2x3 autoload)
        (PBMReader autoload)
        (PCXReader autoload)
        (PICTReader autoload)
        (PluggableView autoload)
        (RIFFReader autoload)
        (ST80FormReader autoload)
        (StrokingWrapper autoload)
        (SunRasterReader autoload)
        (TargaReader autoload)
        (ViewForwardingController autoload)
        (XWDReader autoload)
    )

    "Modified: / 23-01-2017 / 12:12:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        CharacterArray asMimeType
    )
! !

!stx_libview2 class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:47:52 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Additional Graphic Interfacing'
!

legalCopyright
    "Return copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:19:10 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libview2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

