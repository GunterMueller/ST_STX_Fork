"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
 COPYRIGHT (c) 2015-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libview
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libview class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
 COPYRIGHT (c) 2015-2017 Jan Vrany
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

    This library contains low level interfaces to the underlying graphic system
    and representations of windows, fonts, colors, bitmaps etc.

    It does not contain medium level widget classes or applications/tools,
    but instead provides a device- and operating system independent layer on top of which
    GUI frameworks can be built.

    It currently supports X11 and Windows-API.
    Native OSX support may be an option if there is sufficient demand for it
    (i.e. someone is willing to pay for its development).
"
! !

!stx_libview class methodsFor:'accessing - hg - settings'!

hgEnsureCopyrightMethod
    "If true, then #copyright method is automatically compiled in each class
     (but iff project definition defines it)

     Default is true (compile such method) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to not compile them
     to keep changes against CVS minimal"

    ^false

    "Created: / 09-10-2013 / 15:39:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgEnsureVersion_HGMethod
    "If true, then #version_HG method is automatically compiled in each class.

     Default is true (compile such method) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to not compile them
     to keep changes against CVS minimal.

     If false, version_HG is compiled only in classes that has been modified
     and commited.

     Note that Mercurial can live without them
     just fine"

    ^false

    "Created: / 09-10-2013 / 15:39:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgRemoveContainesForDeletedClasses
    "If true, then containers for removed classes are __AUTOMATICALLY__ removed from the
     repositoru. If false, obsolete containes are kept.

     Default is true (remove obsolete containers) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to return false to avoid deletions
     of obsolete files. Usefull when branching off an old CVS repo with loads of mess."

    ^false

    "Created: / 09-10-2013 / 15:39:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libview class methodsFor:'description'!

excludedFromPreRequisites
    ^ #(
        #'stx:libcompat'    "OrderedDither - referenced by Image>>convertToPalette:renderedBy: "
        #'stx:libtool'    "GenericToolbarIconLibrary - referenced by SimpleView class>>readStyleSheet "
        #'stx:libtool2'    "ImageEditor - referenced by Image>>edit "
        #'stx:libui'    "ViewSpec - referenced by SimpleView>>specClass "
        #'stx:libview2'    "TIFFReader - referenced by Image>>saveOn: "
        #'stx:libwidg'    "Button - referenced by ModalBox>>initialize "
        #'stx:libwidg2'    "ImageView - referenced by Form>>show "
        #'stx:goodies/communication'    "HTTPInterface - referenced by ImageReader class>>fromURL:"
    )

    "Modified: / 31-01-2017 / 13:35:51 / stefan"
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
        #'stx:libbasic'    "AllocationFailure - superclass of GraphicsDevice::GraphicResourceAllocationFailure"
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
        #'stx:libbasic2'    "UUID - referenced by DisplayRootView>>uuid"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine #referencedPrerequisites or #mandatoryPreRequisites."

    ^ #(
    )
! !

!stx_libview class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBVIEW_BASE
LIB_BASE=$(LIBVIEW_BASE)
'
!

additionalDefinitions_bc_dot_mak
    ^ '
!!ifdef USEBC
X11_LIBS=..\libbc\X11OMF.lib ..\libbc\XextOMF.lib
!!else
!! ifdef USEVC
# X11_LIBS=..\libvc\X11.lib ..\libvc\Xext.lib
!! else
!! endif
!!endif
'

    "Modified: / 27-09-2011 / 18:25:27 / cg"
!

additionalDefinitions_make_dot_proto
    "allows for additional definitions/rules to be added to the make.proto file."

    ^ '
OPENGL_DEFS=-DOPENGL
OPENGL_CFLAGS=$(shell pkg-config --cflags gl)
OPENGL_LIBS=$(shell pkg-config --libs gl)
'

    "Created: / 14-09-2017 / 00:19:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-09-2017 / 08:39:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRules_bc_dot_mak
    ^ '#

..\libbc\X11OMF.lib: ..\support\win32\borland\X11OMF.lib
        copy ..\support\win32\borland\X11OMF.lib ..\libbc

..\libbc\XextOMF.lib: ..\support\win32\borland\XextOMF.lib
        copy ..\support\win32\borland\XextOMF.lib ..\libbc

..\libvc\X11.lib: ..\support\win32\msc\X11.lib
        copy ..\support\win32\msc\X11.lib ..\libvc

..\libvc\Xext.lib: ..\support\win32\msc\Xext.lib
        copy ..\support\win32\msc\Xext.lib ..\libvc

'

    "Modified: / 27-09-2011 / 18:10:19 / cg"
!

additionalSharedLinkLibraries_make_dot_proto
    "allows for additional shared libraries to be added to the make.proto file."

    ^ '-L$(X_LIB_DIR) $(OPENGL_LIBS) $(LIB_XEXT) $(LIB_XINERAMA) $(LIB_XFT) $(LIB_X) $(LIBRUN_LINK_LIB) '

    "Created: / 06-09-2017 / 09:55:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2017 / 22:21:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

localDefines_unix
    ^ '$(XINCLUDE) $(XDEFS) $(OPENGL_DEFS)'

    "Modified: / 14-09-2017 / 08:37:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

localIncludes
    ^ '$(OPTIONAL_SUPPORT_XLIB_INCLUDE)'

    "Modified: / 14-09-2017 / 08:38:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

localIncludes_unix
    "allow for the specification of additional include directories"

    ^ super localIncludes_unix , ' $(OPENGL_CFLAGS)'

    "Created: / 14-09-2017 / 00:21:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stcOptimizationOptions
    ^ '+optinline +optinline2'
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libview class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        AbstractBackground
        AbstractBorder
        Color
        Colormap
        Controller
        Cursor
        DeviceHandle
        DisplayTransform
        Event
        (FcConstants unix)
        FontDescription
        GraphicsContext
        GraphicsDevice
        GraphicsMedium
        Image
        ImageReader
        KeyboardForwarder
        KeyboardMap
        ResourcePack
        WindowGroup
        WindowSensor
        #'stx_libview'
        BeveledBorder
        BitmapFont
        Border
        ColorPalette
        CompoundFont
        Depth16Image
        Depth1Image
        Depth24Image
        Depth2Image
        Depth32Image
        Depth48Image
        Depth4Image
        Depth64Image
        Depth8Image
        DeviceGraphicsContext
        DisplaySurface
        (FcPattern unix)
        Font
        Form
        GradientBackground
        HostGraphicsDevice
        ImageBackground
        MacButtonBorder
        NoBackground
        ScaleTransform
        SimpleBorder
        SolidBackground
        SynchronousWindowSensor
        ViewStyle
        WindowEvent
        (XftFontDescription unix)
        DeviceWorkstation
        DisplayRootView
        FixedPalette
        ImageMask
        MacFlatButtonBorder
        MappedPalette
        RoundedBorder
        SimpleView
        WidgetEvent
        WindowingTransformation
        XGraphicsContext
        FixedPaletteWithAlpha
        MonoMappedPalette
        ShadowView
        View
        (XEmbedContainerView unix)
        (XWorkstation unix)
        (GLXWorkstation unix)
        TopView
        PopUpView
        StandardSystemView
        ModalBox
        (RoundButtonBorder autoload)
        (TranslucentColor autoload)
        (AlphaMask autoload)
        (MDIChildView autoload)
        (ControllerWithMenu autoload)
        (GraphicsAttributes autoload)
        (NeXTWorkstation autoload)
        (WinWorkstation win32)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        'ConfigurableFeatures class' hasFontConfig
        Object isColormap
        Object isKeyboardMap
        'ConfigurableFeatures class' hasXFT
    )
! !

!stx_libview class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:47:54 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Low Level Graphic Interfacing'

    "Modified: / 14-09-2006 / 10:54:54 / cg"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:19:05 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libview class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'

!

version_HG
    ^ '$Changeset: <not expanded> $'

! !

