"
COPYRIGHT (c) 1989 by Claus Gittinger
COPYRIGHT (c) 2015 Claus Gittinger
COPYRIGHT (c) 2015-2018 Jan Vrany
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

DeviceWorkstation subclass:#XWorkstation
	instanceVariableNames:'hasShapeExtension hasShmExtension hasDPSExtension
		hasMbufExtension hasXVideoExtension hasSaveUnder hasPEXExtension
		hasImageExtension hasInputExtension hasXineramaExtension
		hasRenderExtension hasXftLibrary ignoreBackingStore blackpixel
		whitepixel atoms protocolsAtom deleteWindowAtom saveYourselfAtom
		quitAppAtom primaryAtom clipboardAtom stringAtom wmStateAtom
		motifWMHintsAtom listOfXFonts buttonsPressed eventRootX
		eventRootY displayName eventTrace dispatchingExpose rgbVisual
		rgbaVisual virtualRootId rootId altModifierMask metaModifierMask
		lastEventTime rawMonitorBounds monitorBounds lastButtonPressTime
		deviceIOTimeoutErrorSignal activateOnClick rawKeySymTranslation
		selectionOwner clipboardSelectionTime primarySelectionTime
		selectionFetchers selectionHandlers preWaitAction xlibTimeout
		xlibTimeoutForWindowCreation hasConnectionBroken uniqueDeviceID
		stxDeviceAtom uuidAtom primaryBuffer windowGroupWindow
		maxOperationsUntilFlush operationsUntilFlush lastError hostname
		wmClientLeaderAtom wmClientMachineAtom wmClassName wmClassClass
		pid netWmPidAtom'
	classVariableNames:'RawKeySymTranslation ConservativeSync MaxStringLength
		DefaultXLibTimeout DefaultXLibTimeoutForWindowCreation
		ErrorDBCache'
	poolDictionaries:''
	category:'Interface-Graphics'
!

Object subclass:#SelectionFetcher
	instanceVariableNames:'sema message display drawableID selectionID propertyID targetID
		buffer done incremental'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XWorkstation
!

SimpleView subclass:#WindowGroupWindow
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XWorkstation
!

DeviceGraphicsContext subclass:#X11GraphicsContext
	instanceVariableNames:'depth xftDrawId'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XWorkstation
!

!XWorkstation primitiveDefinitions!
%{
#define SUPPORT_MOTIF_WM_HINTS

#ifdef LINUX
# ifndef __arm__
#  define SHM 
# endif
#endif

#define COUNT_RESOURCES
#ifdef COUNT_RESOURCES

static int __cnt_color = 0;
static int __cnt_bitmap = 0;
static int __cnt_view = 0;
static int __cnt_gc = 0;
static int __cnt_cursor = 0;
static int __cnt_font = 0;

#endif

/*
 * x does a typedef Time - I need Object Time ...
 */
#undef Time
#define Time XTime

/*
 * x does a #define True / False
 * we are lucky - the ST/X True/False are not needed
 */
#undef True
#undef False

#ifdef memset
# undef memset
#endif


#include <stdio.h>

#if defined(__osx__)
# include <malloc/malloc.h>
extern void *malloc();
#else
# ifndef FREEBSD
#  include <malloc.h>
# endif
#endif
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>

/*
 * To get XKeysymToUnicode(), not provided by Xlib...
 */
#include "xkeysymtounicode.h"


#define XK_MISCELLANY
#include <X11/keysymdef.h>

#include <X11/cursorfont.h>

#ifdef LINUX
# include <sys/socket.h>
#endif

extern OBJ __GLOBAL_GET_BY_NAME(char *);

# define __HANDLE_VAL(type, externalAddress) \
	((type)__externalAddressVal(externalAddress))

# define __HANDLE_NEW(ptr, __cls)                    \
	({                                           \
	    OBJ handle = __MKEXTERNALADDRESS(ptr);   \
	    OBJ clsObj = __GLOBAL_GET_BY_NAME(__cls);\
	    __InstPtr(handle)->o_class = clsObj;     \
	    __STORE(handle, clsObj);                 \
	    handle;                                  \
	})

/*
 * this define suppresses XAllocColor/XFreeColor on
 * TrueColor systems - I am not certain, if this is
 * always legal to do (it works with XFree servers).
 */
#define QUICK_TRUE_COLORS

/*
 * shape support works; enabled by -DSHAPE in makefile
 * see RoundClock and RoundGlobe examples
 */
#ifdef SHAPE
# include <X11/extensions/shape.h>
#endif

/*
 * shared memory extension access is currently not supported
 * (only query is implemented)
 */
#ifdef SHM
# include <X11/extensions/XShm.h>
#endif

/*
 * multiBuffer extension access is currently not supported
 * (only query is implemented)
 */
#ifdef MBUF
# include <X11/extensions/multibuf.h>
#endif

/*
 * XVideo extension access is currently not supported
 * (only query is implemented)
 */
#ifdef XVIDEO
# include <X11/extensions/Xv.h>
#endif

/*
 * PEX extension - if available
 */
#ifdef PEX5
# include <PEX5/PEX.h>
#endif

/*
 * XImage extension - if available
 */
#ifdef XIE
# include <X11/extensions/XIE.h>
#endif

/*
 * multiscreen extension - if available
 */
#ifdef XINERAMA
# include <X11/extensions/Xinerama.h>
#endif

/*
 * XCURSOR extension - if available
 */
#ifdef XCURSOR
# include <X11/Xcursor/Xcursor.h>
#endif

/*
 * xft library (based on RENDER extension) - if available
 */
#ifdef XFT
# include <X11/Xft/Xft.h>
# include <X11/extensions/Xrender.h>
# include <X11/extensions/render.h>

# define XFT_FONT(x)            __HANDLE_VAL(XftFont*, x)
# define XFT_FONT_HANDLE_NEW(x) __HANDLE_NEW(x, "XftFontDescription::XftFontHandle")

# define XFT_DRAW(x)            __HANDLE_VAL(XftDraw*, x)
# define XFT_DRAW_HANDLE_NEW(x) __HANDLE_NEW(x, "XftFontDescription::XftDrawHandle")
#endif // XFT

/*
 * when I have more time to check it out, I will support display-PS
 */
#ifdef DPS
# ifdef sgi
#  include <X11/extensions/XDPS.h>
#  include <X11/extensions/XDPSlib.h>
#  include <X11/extensions/dpsXclient.h>
# else
#  include <DPS/XDPS.h>
#  include <DPS/XDPSlib.h>
#  include <DPS/dpsXclient.h>
# endif
#endif

#if defined(someMachine)
/*
 * if nformats cannot be found in the Display structure ...
 */
# define NO_PRIVATE_DISPLAY_ACCESS
#endif

#if defined(IRIX5) || defined(__VMS) || (XlibSpecificationRelease == 6)
  /*
   * accessing private data in Display ... sorry
   */
# define DISPLAYACCESS(d) ((_XPrivDisplay)d)
#else
# define DISPLAYACCESS(d) d
#endif

# define DISPLAY(x)    __HANDLE_VAL(Display*, x)
# define SCREEN(x)     ((int)(__intVal(x)))
# define DRAWABLE(x)   __HANDLE_VAL(Drawable, x)
# define GC(x)         __HANDLE_VAL(GC, x)
# define VISUAL(x)     __HANDLE_VAL(Visual*, x)
# define COLORMAP(x)   __HANDLE_VAL(Colormap, x)


/*
 * some defines - tired of typing ...
 */
#define __DisplayVal(o)      (Display *)(__externalAddressVal(o))
#define __DrawableVal(o)     (Drawable)(__externalAddressVal(o))
#define __WindowVal(o)       (Window)(__externalAddressVal(o))
#define __PixmapVal(o)       (Pixmap)(__externalAddressVal(o))
#define __GCVal(o)           (GC)(__externalAddressVal(o))
#define __CursorVal(o)       (Cursor)(__externalAddressVal(o))
#define __FontVal(o)         (XFontStruct *)(__externalAddressVal(o))
#define __DPSContextVal(o)   (DPSContext)(__externalAddressVal(o))

#define __MKATOMOBJ(a)       __MKSMALLINT(a)   /* add STORE macro if ever changed */
#define __AtomVal(o)         __intVal(o)
#define __isAtomID(o)        __isSmallInteger(o)

#define myDpy                __DisplayVal(__INST(displayId))
#define ISCONNECTED          ((__INST(displayId) != nil) && (__INST(hasConnectionBroken) != nil))

#ifdef __VMS__
# include "vms_Xnames.h"
#endif

void __XTimeoutErrorHandler();
int __XErrorHandler__();
int __XIOErrorHandler__();

/*
 * these two macros should be placed around X-lib calls,
 * which may block due to a broken connection.
 * They setup/remove a VM-timeout which raises an exception
 * after xlibTimeout seconds.
 * This exception will shutDown the connection.
 * Q: is this a good idea for the local display ?
 */
#define __ENTER_XLIB(whichTimeout)   \
    { \
	__blockingPrimitiveTimoutHandler__ = (voidFUNC)__XTimeoutErrorHandler; \
	__blockingPrimitiveTimeoutArg__ = self; \
	__blockingPrimitiveTimeout__ = whichTimeout; \
    } {

#define LEAVE_XLIB()   \
    { \
	__blockingPrimitiveTimoutHandler__ = (voidFUNC)0; \
	__blockingPrimitiveTimeoutArg__ = nil; \
	__blockingPrimitiveTimeout__ = 0; \
    } }

#define ENTER_XLIB()   __ENTER_XLIB(__intVal(__INST(xlibTimeout)) * 1000)
#define ENTER_XLIB2()  __ENTER_XLIB(__intVal(__INST(xlibTimeoutForWindowCreation)) * 1000)

#ifdef SUPPORT_MOTIF_WM_HINTS
# ifdef SOME_MACHINE
#  include <anIncludeFileWhichDefinesTheStuffBelow>
# endif

# ifndef MWM_HINTS_FUNCTIONS
#  define MWM_HINTS_FUNCTIONS       (1L << 0)
#  define MWM_HINTS_DECORATIONS     (1L << 1)
#  define MWM_HINTS_INPUT_MODE      (1L << 2)
#  define MWM_HINTS_STATUS          (1L << 3)

#  define MWM_FUNC_ALL              (1L << 0)
#  define MWM_FUNC_RESIZE           (1L << 1)
#  define MWM_FUNC_MOVE             (1L << 2)
#  define MWM_FUNC_MINIMIZE         (1L << 3)
#  define MWM_FUNC_MAXIMIZE         (1L << 4)
#  define MWM_FUNC_CLOSE            (1L << 5)

#  define MWM_INPUT_MODELESS                      0
#  define MWM_INPUT_PRIMARY_APPLICATION_MODAL     1
#  define MWM_INPUT_SYSTEM_MODAL                  2
#  define MWM_INPUT_FULL_APPLICATION_MODAL        3

#  define MWM_DECOR_NONE            0
#  define MWM_DECOR_ALL             (1L << 0)
#  define MWM_DECOR_BORDER          (1L << 1)
#  define MWM_DECOR_RESIZEH         (1L << 2)
#  define MWM_DECOR_TITLE           (1L << 3)
#  define MWM_DECOR_MENU            (1L << 4)
#  define MWM_DECOR_MINIMIZE        (1L << 5)
#  define MWM_DECOR_MAXIMIZE        (1L << 6)
# endif
#endif /* SUPPORT_MOTIF_WM_HINTS */

/*
 * openlook hints are not supported yet
 * - noone needs them anymore ;-(
 */
#ifdef SUPPORT_OPENLOOCK_WM_HINTS
# ifdef SOME_MACHINE
#  include <anIncludeFileWhichDefinesTheStuffBelow>
# endif

# ifndef OL_DECOR_CLOSE
#  define OL_DECOR_CLOSE            (1L << 0)
#  define OL_DECOR_RESIZEH          (1L << 1)
#  define OL_DECOR_HEADER           (1L << 2)
#  define OL_DECOR_ICON_NAME        (1L << 3)
#  define OL_DECOR_ALL              (OL_DECOR_CLOSE | OL_DECOR_RESIZEH | OL_DECOR_HEADER | OL_DECOR_ICON_NAME)
#  define OL_ANY_HINTS              (1L << 7)
# endif
#endif /* SUPPORT_OPENLOOCK_WM_HINTS */

%}
! !

!XWorkstation primitiveVariables!
%{
/*
 * remembered info from private error handler
 */
static char lastErrorMsg[128] = "";
static unsigned INT lastRequestCode = 0;
static unsigned INT lastMinorCode = 0;
static unsigned INT lastResource = 0;

static int __debug__ = 0;

#define DPRINTF(x)      if (__debug__) { console_printf x; }


/* Some libraries, notably Cairo uses MIT-SHM extension 
 * that sends back ShmCompletion event. Such event needs
 * to be silently ignored. 
 * However, since it comes from an extension, the event type
 * must be queried. To avoid a query each time we get it, 
 * cache the value in a variable. 
 */
#ifdef SHM
static int ShmCompletionType = -1;
#endif


%}
! !

!XWorkstation primitiveFunctions!
%{

/*
 * some systems need a dummy reference to force the linker
 * to include that stuff. Should be #ifdef'd ...
 */
#ifndef ELF
# ifdef __GNUC__
VOLATILE
# endif
static void
dummyToForceLoading() {
	XCreateSimpleWindow(0, 0, 0, 0, 0, 0, 0, 0, 0);
	XCloseDisplay(0);
	XCreateImage(0, 0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0);
	XSetWindowColormap(0, 0, 0);
	XQueryColors(0,0,0,0);
# ifdef SHM
	XShmAttach(0, 0);
	XShmCreateImage(0, 0, 0, 0, 0, 0, 0 ,0);
	XShmDetach(0, 0);
	XShmPutImage(0, 0, 0, 0 , 0,0,0,0,0,0,0);
	shmctl(0,0,0);
	fgetc(0);
# endif  // SHM
}
#endif // !ELF

static char* requestNames[] = {
    "X_CreateWindow",               // 0
    "X_ChangeWindowAttributes",
    "X_GetWindowAttributes",
    "X_DestroyWindow",
    "X_DestroySubwindows",          // 4
    "X_ChangeSaveSet",              // 5
    "X_ReparentWindow",
    "X_MapWindow",
    "X_MapSubwindows",
    "X_UnmapWindow",
    "X_UnmapSubwindows",            // 10
    "X_ConfigureWindow",
    "X_CirculateWindow",
    "X_GetGeometry",
    "X_QueryTree",
    "X_InternAtom",
    "X_GetAtomName",
    "X_ChangeProperty",
    "X_DeleteProperty",
    "X_GetProperty",
    "X_ListProperties",
    "X_SetSelectionOwner",
    "X_GetSelectionOwner",
    "X_ConvertSelection",
    "X_SendEvent",
    "X_GrabPointer",
    "X_UngrabPointer",
    "X_GrabButton",
    "X_UngrabButton",
    "X_ChangeActivePointerGrab",
    "X_GrabKeyboard",
    "X_UngrabKeyboard",
    "X_GrabKey",
    "X_UngrabKey",
    "X_AllowEvents",
    "X_GrabServer",
    "X_UngrabServer",
    "X_QueryPointer",
    "X_GetMotionEvents",
    "X_TranslateCoords",
    "X_WarpPointer",
    "X_SetInputFocus",
    "X_GetInputFocus",
    "X_QueryKeymap",
    "X_OpenFont",
    "X_CloseFont",
    "X_QueryFont",
    "X_QueryTextExtents",
    "X_ListFonts",
    "X_ListFontsWithInfo",
    "X_SetFontPath",
    "X_GetFontPath",
    "X_CreatePixma",
    "X_FreePixmap",
    "X_CreateGC",
    "X_ChangeGC",
    "X_CopyGC",
    "X_SetDashes",
    "X_SetClipRectangles",
    "X_FreeGC",
    "X_ClearArea",
    "X_CopyArea",
    "X_CopyPlane",
    "X_PolyPoint",
    "X_PolyLine",
    "X_PolySegment",
    "X_PolyRectangle",
    "X_PolyArc",
    "X_FillPoly",
    "X_PolyFillRectangle",
    "X_PolyFillArc",
    "X_PutImage",
    "X_GetImage",
    "X_PolyText8",
    "X_PolyText16",
    "X_ImageText8",
    "X_ImageText16",
    "X_CreateColormap",
    "X_FreeColormap",
    "X_CopyColormapAndFree",
    "X_InstallColormap",
    "X_UninstallColormap",
    "X_ListInstalledColormaps",
    "X_AllocColor",
    "X_AllocNamedColor",
    "X_AllocColorCells",
    "X_AllocColorPlanes",
    "X_FreeColors",
    "X_StoreColors",
    "X_StoreNamedColor",
    "X_QueryColors",
    "X_LookupColor",
    "X_CreateCursor",
    "X_CreateGlyphCursor",
    "X_FreeCursor",
    "X_RecolorCursor",
    "X_QueryBestSize",
    "X_QueryExtension",
    "X_ListExtensions",
    "X_ChangeKeyboardMapping",
    "X_GetKeyboardMapping",
    "X_ChangeKeyboardControl",
    "X_GetKeyboardControl",
    "X_Bell",
    "X_ChangePointerControl",
    "X_GetPointerControl",
    "X_SetScreenSaver",
    "X_GetScreenSaver",
    "X_ChangeHosts",
    "X_ListHosts",
    "X_SetAccessControl",
    "X_SetCloseDownMode",
    "X_KillClient",
    "X_RotateProperties",
    "X_ForceScreenSaver",
    "X_SetPointerMapping",
    "X_GetPointerMapping",
    "X_SetModifierMapping",
    "X_GetModifierMapping",
};

#if !defined(__INCREMENTAL_COMPILE__)
// __myInstPtr has been redefined/overwritten by private classes - restore
#undef __myInstPtr
#define __myInstPtr(obj) ((struct __XWorkstation_struct *)(obj))

/*
 * catch X-errors and forward as errorInterrupt:#DisplayError,
 * (which itself invokes my handler and optionally raises an exceptionSignal)
 * the implementation below is somewhat wrong: it will
 * report all errors for Display, even though there could be
 * more than one display connection. (being fixed, new errorInterrupt mechanism
 * allows passing an additional argument, which is the displayID ...)
 */
int
__XErrorHandler__(Display *dpy, XErrorEvent *event)
{
    XGetErrorText(dpy, event->error_code, lastErrorMsg, 127);
    lastErrorMsg[127] = '\0';

    if (lastErrorMsg[0] == '\0') {
	sprintf(lastErrorMsg, "code: %d", event->error_code);
    }
    lastRequestCode = event->request_code;
    lastMinorCode = event->minor_code;
    lastResource = event->resourceid;
    if ((event->error_code == BadWindow) && (lastRequestCode == 4) && (lastMinorCode == 0)) {
	/*
	 * this is a BadWindow error for X_DestroyWindow.
	 * ignore it here, since it results from the GC freeing windows
	 * in non bottom-up window order.
	 */
	return 0;
    }

    if (@global(DeviceWorkstation:ErrorPrinting) == true) {
	char *requestName = "?";

	if (event->request_code < (sizeof(requestNames)/sizeof(char *))) {
	    requestName = requestNames[event->request_code];
	}
	console_fprintf(stderr, "XWorkstation [error]: x-error caught maj=%d (0x%x) \"%s\", min=%d (0x%x), resource=%"_lx_"\n",
			event->request_code, event->request_code, requestName,
			event->minor_code, event->minor_code, (INT)(event->resourceid));
	console_fprintf(stderr, "XWorkstation [error]: x-error message is [%d] '%s'\n",
			event->error_code, lastErrorMsg);
    }
#if 0
    // cg: should no longer be needed - librun no longer sends an errorInterrupt while running on C-stack
#ifdef XFT
    if ((strncmp(lastErrorMsg, "RenderBadPicture", 16) == 0)) {
	/*
	 * this is a RenderBadPicture error from XFT drawing.
	 * ignore it for now, as this is due to an incomplete implementation
	 */
	console_fprintf(stderr, "XWorkstation [info]: x-error ignored\n");
	return 0;
    }
#endif
#endif
    __errorInterruptWithIDAndParameter__(@symbol(DisplayError), __MKEXTERNALADDRESS(dpy));
    return 0;
}

/*
 * much like the above, but for IO Errors;
 * forwarded as errorInterrupt:#DisplayIOError,
 * In single display apps, handling those here does not
 * really make sense (except, for a controlled cleanup).
 * However, in multiDisplay apps, a single broken
 * connection should not affect the other users.
 */
int
__XIOErrorHandler__(Display *dpy)
{
    if (@global(DeviceWorkstation:ErrorPrinting) == true) {
	console_fprintf(stderr, "XWorkstation [error]: I/O error\n");
    }
    __immediateErrorInterruptWithIDAndParameter__(@symbol(DisplayIOError),
						  __MKEXTERNALADDRESS(dpy));

#if 0
    /*
     * don't do this.
     * This error is called asynchronously, and the wrong process may be terminated
     */


    /*
     * if we return from the error interrupt ...
     */
    __internalError("unhandled display I/O error");
    __terminateProcess(0);      /* soft terminate */
    __terminateProcess(1);      /* hard terminate */
    /* never reached */
#endif

    return 0;
}

/*
 * timeout error in case of Xlib request timeout.
 * forwarded as errorInterrupt:#DisplayIOTimeoutError,
 * This is generated synthetically by the VM if the
 * timeoutHandler has been set.
 */
void
__XTimeoutErrorHandler(OBJ displayDeviceInst)
{
    if ((displayDeviceInst == @global(MainDisplay))
	|| (displayDeviceInst == @global(DeviceWorkstation:DefaultScreen))) {
	console_fprintf(stderr, "XWorkstation [error]: keep display connection for master display after X11 timeout (no shutdown)\n");
	return;
    }
    if (@global(DeviceWorkstation:ErrorPrinting) == true) {
	console_fprintf(stderr, "XWorkstation [error]: X11 request timeout dpy=%"_lx_"\n", (INT)displayDeviceInst);
    }
    __OINST(displayDeviceInst, hasConnectionBroken) = true;

    __PROTECT__(displayDeviceInst);
    __immediateErrorInterruptWithIDAndParameter__(@symbol(DisplayIOTimeoutError), displayDeviceInst);
    __UNPROTECT__(displayDeviceInst);

    /*
     * if we return from the error interrupt ...
     */
    if (__OINST(displayDeviceInst, displayId) != nil) {
	__internalError("unhandled X11 display timeout error");

	/*
	 * the current process failed to do an X11 request.
	 * Terminate it!
	 */
	__terminateProcess(0);      /* soft terminate */
	__terminateProcess(1);      /* hard terminate */
    }
}
#endif // __INCREMENTAL_COMPILE__

%}
! !

!XWorkstation class methodsFor:'documentation'!

copyright
"
COPYRIGHT (c) 1989 by Claus Gittinger
COPYRIGHT (c) 2015 Claus Gittinger
COPYRIGHT (c) 2015-2018 Jan Vrany
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
    this class provides the interface to X11. It redefines all required methods
    from DeviceWorkstation.
    Notice, that in Smalltalk/X you are not technically limited to one display;
    in theory (and in our practice), you can create Views on many displays
    simultaneously. However, the default setup is for one display only.
    To support multiple displays, you will have to start another event dispatcher
    process for the other display(s) and create the other views with a slightly
    different protocol (ApplicationModel openOnDevice:) or by temporarily answering
    the other device to the currentScreen query.
    Therefore, 'normal' applications do not have to care for all of this, as the currentScreen
    query is answered by the launcher when opening its applications.

    Timeouts:
	sometimes, X-connections are lost and, as the Xlib is blocking and synchronous by
	default, this would lead to a locked ST/X system.
	Therefore, this class defines a timeOut, whenever doing an Xlib call.
	The default for this timeout is 30seconds.
	This may be a problem with windowmanagers which show a rubber-band rectangle
	when creating windows.
	If the user does not specify the rectangle within 30 seconds, the device assumes
	a timeout and closes the connection.
	As a (kludgy) workaround, a second timeout value is used for window-creation.
	This secondary timeout value defaults to 60*5 seconds (5 minutes).

    See more documentation in my superclass, DeviceWorkstation.

    [author:]
	Claus Gittinger
"
! !

!XWorkstation class methodsFor:'initialization'!

initialize
    "/ ConservativeSync is required for some Xlib implementation,
    "/ where eventPending returns wrong if we do not flush the buffer.
    "/ (especially Win32 & Xlib)
    ConservativeSync := OperatingSystem isMSWINDOWSlike.

    "/ some XServers crash, when given too long strings in XDrawString/XDrawInageString.
    "/ the following is an adjustable soft-limit.
    MaxStringLength := 4096.

    "/ shutdown the X-connection, when no response is received after that many seconds.
    DefaultXLibTimeout := 30.
    DefaultXLibTimeoutForWindowCreation := 5*60.

    RawKeySymTranslation isNil ifTrue:[
	"/ the following table maps X-keyevents to ST/X
	"/ device independend events.
	"/ It is NOT meant as a keyboardMap replacement.

	RawKeySymTranslation := Dictionary new:6.
	RawKeySymTranslation
	    at:#'Delete_line' put:#DeleteLine;
	    at:#'Delete_word' put:#DeleteWord;
	    at:#Down put:#CursorDown;
	    at:#Up put:#CursorUp;
	    at:#Left put:#CursorLeft;
	    at:#Right put:#CursorRight.
    ]

    "Modified: / 27.4.1999 / 17:21:30 / cg"
! !

!XWorkstation class methodsFor:'accessing'!

graphicsContextClass
    "Return a graphics context class to use for this device.
     Default is to use DeviceGraphicsContext"
    ^ graphicsContextClass ? XGraphicsContext

    "Created: / 25-02-2016 / 07:26:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XWorkstation class methodsFor:'accessing-display capabilities'!

hasXCursorLibrary
%{
#ifdef XCURSOR
    RETURN(true);
#else
    RETURN(false);
#endif
%}
    "
     Display hasXCursorLibrary
    "
!

hasXftLibrary
%{
#ifdef XFT
    RETURN(true);
#else
    RETURN(false);
#endif
%}
    "
     Display hasXftLibrary
    "
! !

!XWorkstation class methodsFor:'error handling'!

debug:aBoolean
%{  /* NOCONTEXT */

    __debug__ = (aBoolean == true) ? 1 : 0;
%}
!

debugResources
%{
#ifdef COUNT_RESOURCES
    console_fprintf(stderr, "colors:%d bitmaps:%d views:%d gc:%d cursors:%d fonts:%d\n",
	    __cnt_color, __cnt_bitmap,
	    __cnt_view, __cnt_gc, __cnt_cursor, __cnt_font);
#endif
%}

    "
     XWorkstation debugResources
    "
!

errorStringOfLastError
%{
    RETURN ( __MKSTRING(lastErrorMsg) );
%}
!

getConnectionTimeOut
    "returns the default connectionTimeOut (seconds)"

    ^ DefaultXLibTimeout
!

getConnectionTimeOutForWindowCreation
    "returns the default connectionTimeOut (seconds)"

    ^ DefaultXLibTimeoutForWindowCreation
!

lastErrorString
    "return the last X-error string -
     when buffering is on, this may be
     an error for a long-ago operation"

    |string s match line requestCode|

    string := self errorStringOfLastError.
    requestCode := self requestCodeOfLastError.

    "
     X specific: search the requestCode in '/usr/lib/X11/XErrorDB',
     and append the name of the corresponding X-request
    "
    match := 'XRequest.' , requestCode printString.
    ErrorDBCache isNil ifTrue:[
	ErrorDBCache := IdentityDictionary new.
    ].

    "if there is no XErrorDB or no entry, the line for the requestCode is cached as nil"
    line := ErrorDBCache at:requestCode ifAbsentPut:[
	    |errorLine|

	    s := '/usr/share/X11/XErrorDB' asFilename readStreamOrNil.
	    s notNil ifTrue:[
		errorLine := s peekForLineStartingWith:match.
		errorLine notNil ifTrue:[
		    errorLine := errorLine copyFrom:(errorLine indexOf:$:)+1.
		].
		s close.
	    ].
	    errorLine
	].

    line isNil ifTrue:[
	line := match
    ].
    ^ string , ' in ' , line.

    "
	Screen lastErrorString
    "
!

minorCodeOfLastError
%{  /* NOCONTEXT */

    RETURN ( __MKSMALLINT(lastMinorCode) );
%}
!

requestCodeOfLastError
%{  /* NOCONTEXT */

    RETURN ( __MKSMALLINT(lastRequestCode) );
%}
!

resourceIdOfLastError
%{  /* NOCONTEXT */

      if (lastResource != 0) {
	 RETURN ( __MKEXTERNALADDRESS(lastResource) );
      }
%}.

     ^ nil


     "
	 Screen resourceIdOfLastError
     "
!

setConnectionTimeOut:seconds
    "set the default connection timeout (seconds)"

    DefaultXLibTimeout := seconds
!

setConnectionTimeOutForWindowCreation:seconds
    "set the default connection timeout (seconds)"

    DefaultXLibTimeoutForWindowCreation := seconds
! !

!XWorkstation class methodsFor:'queries'!

isX11Platform
    ^ true
!

platformName
    "ST-80 compatibility.
     Return a string describing the display systems platform.
     XWorkstation always returns #X11."

    ^ #X11  "I don't know what ST-80 returns for X ..."

    "Modified: 26.5.1996 / 15:32:46 / cg"
! !

!XWorkstation methodsFor:'Signal constants'!

deviceIOTimeoutErrorSignal
    "return the per-device signal, which is raised when a timeout
     IO error (i.e. broken connection) occurs."

    ^ deviceIOTimeoutErrorSignal
! !

!XWorkstation methodsFor:'accessing'!

displayId
    ^ displayId

    "Created: / 20-12-2013 / 11:02:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayIdOrErrorIfBroken
    (hasConnectionBroken or:[displayId isNil]) ifTrue:[
	self primitiveFailedOrClosedConnection.
	^ nil.
    ].
    ^ displayId
!

displayIdOrNilIfBroken
    hasConnectionBroken ifTrue:[
	^ nil.
    ].
    ^ displayId
!

maxOperationsUntilFlush
    ^ maxOperationsUntilFlush
!

maxOperationsUntilFlush:anIntegerOrNil
    "if not nil, after anInteger number of draw operations
     a flush is performed.

     This is to work around a drawing problem which occurs on
     Ubuntu 12.04 64bit running on a VMware player (2013-11)."

    maxOperationsUntilFlush := anIntegerOrNil.
!

screen
    ^ screen

    "Created: / 20-12-2013 / 11:02:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XWorkstation methodsFor:'accessing & queries'!

activateOnClick:aBoolean
    "set/clear the activateOnClick behavior.
     If on, a click into a window raises and activates
     the (top) window.
     Windows users typically enable this;
     in contrast, those used to the X-Window system typically prefer
     it disabled.
     Returns the previous setting."

    |prev|

    prev := activateOnClick ? false.
    aBoolean notNil ifTrue:[
	activateOnClick := aBoolean.
    ].
    ^ prev

    "
     Display class activateOnClick:true
     Display class activateOnClick:false
    "
!

anyButtonMotionMask
    "return the state-mask for any button in motion events' state-field.
     This is the devices mask."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(Button1MotionMask | Button2MotionMask | Button3MotionMask));
%}.
    ^ nil
!

blackpixel
    "return the colornumber of black"

    ^ blackpixel
!

button1MotionMask
    "return the state-mask for button1 in motion events' state-field.
     For backward compatibility."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(Button1MotionMask));
%}

    "
     Display button1MotionMask
    "
!

button2MotionMask
    "return the state-mask for button2 in motion events' state-field
     For backward compatibility."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(Button2MotionMask));
%}
!

button3MotionMask
    "return the state-mask for button3 in motion events' state-field
     For backward compatibility."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(Button3MotionMask));
%}
!

buttonMotionMask:aButton
    "return the state-mask for button1 in motion events state-field.
     This is the devices mask."

%{  /* NOCONTEXT */
    if (aButton == __MKSMALLINT(1)) {
	RETURN (__MKSMALLINT(Button1MotionMask));
    }
    if (aButton == __MKSMALLINT(2)) {
	RETURN (__MKSMALLINT(Button2MotionMask));
    }
    if (aButton == __MKSMALLINT(3)) {
	RETURN (__MKSMALLINT(Button3MotionMask));
    }
%}.
    ^ nil
!

controlMask
    "return the state-mask for the CTRL modified in motion events' state-field."

    "/ obsolete
    ^ self ctrlModifierMask


!

displayFileDescriptor
    "return the displays fileNumber - for select"

%{  /* NOCONTEXT */
#ifndef __win32__
    if (ISCONNECTED) {
	RETURN ( __MKSMALLINT(ConnectionNumber(myDpy)) );
    }
#endif
    RETURN (nil);
%}
!

displayName
    "return the X-connections display name.
     This is (currently) nil for the default display,
     something like foo:0 for any other remote display.
     Future versions may return non-nil strings for the default display as well."

    ^ displayName
!

displayName: something

    displayName := something
!

protocolVersion
    "return the X-servers protocol version - should normally not be of
     any interest"

%{  /* NOCONTEXT */
    if (ISCONNECTED) {
	RETURN ( __MKSMALLINT(XProtocolVersion(myDpy)) );
    }
    RETURN (nil);
%}

    "
     Display protocolVersion
    "
!

serverVendor
    "return the X-server vendor string - this should normally not be of
     any interest, but can be for special cases
     (to avoid bugs in certain implementations)"
%{
    if (ISCONNECTED) {
	RETURN ( __MKSTRING(XServerVendor(myDpy)) );
    }
    RETURN (nil);
%}

    "
     Display serverVendor
     Display platformName
    "
!

shiftMask
    "return the state-mask for the SHIFT modified in motion events' state-field."

    "/ obsolete
    ^ self shiftModifierMask
!

translatePoint:aPoint from:windowId1 to:windowId2
    "given a point in window1, return the coordinate in window2.
     This expects a device coordinate (relative to the first views origin)
     in aPoint and returns a device coordinate relative to the 2nd views origin.
     - use to xlate points from a window to rootwindow"

    <context: #return>

    |x1 y1 x2 y2 rootWindowId|

    x1 := x2 := aPoint x truncated.
    y1 := y2 := aPoint y truncated.
    rootWindowId := self rootWindowId.

%{
    int xpos, ypos;
    Window w1, w2, child_ret;
    int screen = __intVal(__INST(screen));

    if (ISCONNECTED
     && __isExternalAddress(windowId1)
     && __isExternalAddress(windowId2)
     && __bothSmallInteger(x1, y1)) {
	Display *dpy = myDpy;
	Window rootWin;

	w1 = __WindowVal(windowId1);
	w2 = __WindowVal(windowId2);

	rootWin = RootWindow(dpy, screen);
	if (w1 == rootWin) {
	    w1 = (Window)__externalAddressVal(rootWindowId);
	}
	if (w2 == rootWin) {
	    w2 = (Window)__externalAddressVal(rootWindowId);
	}

	ENTER_XLIB();
	XTranslateCoordinates(dpy, w1, w2,
			      __intVal(x1), __intVal(y1),
			      &xpos, &ypos, &child_ret);
	LEAVE_XLIB();

	x2 = __MKSMALLINT(xpos);
	y2 = __MKSMALLINT(ypos);
    }
%}.

    ^ (x2 @ y2)
!

vendorRelease
    "return the X-servers vendor release - should normally not be of
     any interest, but can be for special cases.
     (to avoid bugs in certain implementations)"

%{  /* NOCONTEXT */
    if (ISCONNECTED) {
	RETURN ( __MKSMALLINT(XVendorRelease(myDpy)) );
    }
    RETURN (nil);
%}

    "
     Display vendorRelease
    "
!

viewIdFromPoint:aPoint in:windowId
    "given a point in rootWindow, return the viewId of the subview of windowId
     hit by this coordinate. Return nil if no view was hit.
     The returned id may be the id of a non ST view.
     - used to find the window to drop objects after a cross-view drag."

    <context: #return>

%{
    int screen = __intVal(__INST(screen));
    OBJ xp, yp;
    int xpos, ypos;
    Window child_ret;

    if (ISCONNECTED
     && __isExternalAddress(windowId)
     && __isPoint(aPoint)) {
	Display *dpy = myDpy;

	xp = _point_X(aPoint);
	yp = _point_Y(aPoint);
	if (__bothSmallInteger(xp, yp)) {

	    ENTER_XLIB();
	    XTranslateCoordinates(dpy,
				  RootWindow(dpy, screen),
				  __WindowVal(windowId),
				  __intVal(xp), __intVal(yp),
				  &xpos, &ypos, &child_ret);
	    LEAVE_XLIB();

	    if (child_ret) {
		RETURN ( __MKEXTERNALADDRESS(child_ret) );
	    }
	    RETURN ( nil );
	}
    }
%}.
    windowId notNil ifTrue:[
	aPoint isPoint ifTrue:[
	    ^ self viewIdFromPoint:aPoint asPoint truncated in:windowId
	]
    ].

    ^ nil

    "
      Display viewIdFromPoint:100@100 in:Display realRootWindowId
    "
!

virtualExtent
    "return the virtual extent of the display (in pixels).
     On most systems, this is the same as the physical width;
     except, if a window manager with a virtual desktop like olvwm
     (simulating a bigger screen) is running."

%{
    if (ISCONNECTED
     && (__INST(rootId) != __INST(virtualRootId))
     && __isExternalAddress(__INST(virtualRootId))) {
	Window vRootWin;
	Window root;
	int x, y;
	unsigned int width, height;
	unsigned int dummy;
	int ret;

	vRootWin = __WindowVal(__INST(virtualRootId));
	ENTER_XLIB();
	ret = XGetGeometry(myDpy, vRootWin, &root, &x, &y, &width, &height,
					  &dummy, &dummy);
	LEAVE_XLIB();
	if (ret) {
	    RETURN ( __MKPOINT_INT(width, height) );
	}
    }
%}.
    ^ width @ height
   "
     Display virtualExtent
     Display extent
   "
!

whitepixel
    "return the colornumber of white"

    ^ whitepixel
!

xlibTimeout
    ^ xlibTimeout
!

xlibTimeout:seconds
    xlibTimeout := seconds
!

xlibTimeoutForWindowCreation
    ^ xlibTimeoutForWindowCreation
!

xlibTimeoutForWindowCreation:seconds
    xlibTimeoutForWindowCreation := seconds
! !

!XWorkstation methodsFor:'accessing-display capabilities'!

extentOfResizeHandle
    "if the window system needs any area for a window resize handle (such as on MACOS-X),
     this area's extent is returned here. It is assumed, that this handle is located at the lower-right
     of the window.
     0@0 is returned for systems which locate the resize handles outside the client area.
     This may be used by the UI painter or programmatically to reserve some client area.
     This method must be redefined for displays which need it (i.e. X11 on osx)"

    OperatingSystem getOSType == #osx ifTrue:[
	"/ should check for local display here - sigh, osx's Xserver does not give
	"/ us a hint through the server vendor...
	^ 16@16
    ].
    ^ 0@0
!

hasCursorExtension
    "return true, if this workstation supports the X cursor extension.
     This extension allows for deep cursors (depth > 1)"

    ^ self hasExtension:'CURSOR'

    "
     Display hasCursorExtension
    "
!

hasDPS
    "return true, if this workstation supports display postscript.
     Both the server must support it, and the feature must have been
     enabled in the smalltalk system, for true to be returned."

    ^ hasDPSExtension

    "
     Display hasDPS
    "
!

hasExtension:extensionString
    "query for an X extension. The argument, extensionString
     should be the name of the extension (i.e. 'SHAPE', 'XInputExtension' etc).
     Return true, if that extension is available in the server.
     (which does not imply, that there is support in smalltalk for it."

    <context: #return>
%{
    int dummy;
    OBJ rslt = false;

    if (ISCONNECTED
     && __isStringLike(extensionString)) {
	ENTER_XLIB();
	if (XQueryExtension(myDpy, __stringVal(extensionString), &dummy, &dummy, &dummy)) {
	    rslt = true;
	}
	LEAVE_XLIB();
    }
    RETURN (rslt);
%}

    "
     Display hasExtension:'XVideo'
     Display hasExtension:'Input'
     Display hasExtension:'GLX'
     Display hasExtension:'X3D-PEX'
     Display hasExtension:'XInputExtension'
     Display hasExtension:'SHAPE'
     Display hasExtension:'MIT-SHM'
     Display hasExtension:'SGIFullScreenStereo'
    "
!

hasImageExtension
    "return true, if this workstation supports the X image extension.
     Both the server must support it, and the feature must have been
     enabled in the smalltalk system, for true to be returned."

    ^ hasImageExtension

    "
     Display hasImageExtension
    "
!

hasInputExtension
    "return true, if this workstation supports the X input extension.
     Both the server must support it, and the feature must have been
     enabled in the smalltalk system, for true to be returned."

    ^ hasInputExtension

    "
     Display hasInputExtension
    "
!

hasMultibuffer
    "return true, if this workstation supports the multibuffer extension.
     Both the server must support it, and the feature must have been
     enabled in the smalltalk system, for true to be returned."

    ^ hasMbufExtension

    "
     Display hasMultibuffer
    "
!

hasPEX
    "return true, if this workstation supports PEX 3D graphics.
     Both the server must support it, and the feature must have been
     enabled in the smalltalk system, for true to be returned."

    ^ hasPEXExtension

    "
     Display hasPEX
    "
!

hasRenderExtension
    "return true, if this workstation supports the X render extension."

    ^ self hasExtension:'RENDER'

    "
     Display hasRenderExtension
    "
!

hasShm
    "return true, if this workstation supports the shared pixmap extension.
     Both the server must support it, and the feature must have been
     enabled in the smalltalk system, for true to be returned."

    ^ hasShmExtension

    "
     Display hasShm
    "
!

hasXVideo
    "return true, if this workstation supports the XVideo extension.
     Both the server must support it, and the feature must have been
     enabled in the smalltalk system, for true to be returned."

    ^ hasXVideoExtension

    "
     Display hasXVideo
    "
!

iconSizes
    "Get the preferred/supported icon sizes. These are set by the window manager.
     We return nil (if not set) or an OrderedCollection of iconSize specs."

    <context: #return>

    |xIconSizes count ret|

    count := 0.
%{
    int screen = __intVal(__INST(screen));
    XIconSize *sizeList;
    int cnt;

    if (ISCONNECTED) {
	Display *dpy = myDpy;
	int status;

	ENTER_XLIB();
	status = XGetIconSizes(dpy, RootWindow(dpy, screen), &sizeList, &cnt);
	LEAVE_XLIB();
	if (status > 0) {
	   xIconSizes = __MKEXTERNALBYTES(sizeList);
	   count = __MKSMALLINT(cnt);
	}
    }
%}.
    count == 0 ifTrue:[^ nil].

    ret := Array new:count.
    1 to:count do:[ :i |
	|minWidth minHeight maxWidth maxHeight widthStep heightStep d|

%{
	XIconSize *slp = &((XIconSize *)__externalAddressVal(xIconSizes))[__intVal(i)-1];
	minWidth = __MKSMALLINT(slp->min_width);
	minHeight = __MKSMALLINT(slp->min_height);
	maxWidth = __MKSMALLINT(slp->max_width);
	maxHeight = __MKSMALLINT(slp->max_height);
	widthStep = __MKSMALLINT(slp->width_inc);
	heightStep = __MKSMALLINT(slp->height_inc);
%}.
	d := IdentityDictionary new:6.
	d at:#minWidth put:minWidth.
	d at:#maxWidth put:maxWidth.
	d at:#widthStep put:widthStep.
	d at:#minHeight put:minHeight.
	d at:#maxHeight put:maxHeight.
	d at:#heightStep put:heightStep.

	ret at:i put:d.
    ].

    xIconSizes free.
    ^ ret

    "
     Display iconSizes
    "
!

ignoreBackingStore:aBoolean
    "if the argument is true, the view's backingStore setting will be ignored, and
     no backing store used - this can be used on servers where backing store is
     very slow or is broken (can be put into display-rc-file)"

    ignoreBackingStore := aBoolean
!

monitorBounds
    "ask the X server via the Xinerama extension about the available minitors.
     The first monitor returned is the primary monitor"

    |numberOfMonitors resultArray bounds|

%{
#ifdef XINERAMA
    if (ISCONNECTED && __INST(hasXineramaExtension) == true) {
	Display *dpy = myDpy;
	XineramaScreenInfo *screenInfo;
	int numDisplays;
	OBJ *cResultArray;
	int i, ci;

	screenInfo = XineramaQueryScreens (dpy, &numDisplays);
	if (screenInfo == 0) {
	    goto out;
	}

	numberOfMonitors = __mkSmallInteger(numDisplays);
	resultArray = __ARRAY_NEW_INT(numDisplays * 5);
	cResultArray = __ArrayInstPtr(resultArray)->a_element;

	for (i=0, ci=0; i < numDisplays; i++, ci+=5) {
	    cResultArray[ci] = __mkSmallInteger(screenInfo[i].screen_number);
	    cResultArray[ci+1] = __mkSmallInteger(screenInfo[i].x_org);
	    cResultArray[ci+2] = __mkSmallInteger(screenInfo[i].y_org);
	    cResultArray[ci+3] = __mkSmallInteger(screenInfo[i].width);
	    cResultArray[ci+4] = __mkSmallInteger(screenInfo[i].height);
	}

	XFree(screenInfo);
    }
#endif
out:;
%}.
    numberOfMonitors isNil ifTrue:[
	"no xinerama - the display is the only monitor"
	^ Array with:self bounds.
    ].
    rawMonitorBounds = resultArray ifTrue:[
	^ monitorBounds.
    ].

    bounds := Array new:numberOfMonitors.
    1 to:numberOfMonitors do:[:idx|
	|rect baseIdx|
	baseIdx := (idx-1) * 5.
	rect := Rectangle
		    left:(resultArray at:baseIdx+2)
		    top:(resultArray at:baseIdx+3)
		    width:(resultArray at:baseIdx+4)
		    height:(resultArray at:baseIdx+5).
	bounds at:idx put:rect.
    ].

    rawMonitorBounds := resultArray.
    monitorBounds := bounds.

    "since the monitor configuration changed,
     we have to update the monitor settings"

    self initializeScreenBounds.

    ^ bounds

    "
     Display monitorBounds
    "
!

monitorBoundsAt:aPoint
    |bounds|

    bounds := self monitorBounds.
    ^ bounds
	detect:[:eachRectangle| eachRectangle containsPoint:aPoint]
	ifNone:[super monitorBoundsAt:aPoint].

    "
     Screen current monitorBoundsAt:(0@0)
     Screen current monitorBoundsAt:(1500@0)
     Screen current monitorBoundsAt:(3000@0)
     Screen current monitorBoundsAt:(9000@0)
     Screen current monitorBoundsAt:(Display pointFromUser)
    "
!

numberOfMonitors
    ^ self monitorBounds size

    "
	Display numberOfMonitors
    "
!

pointIsVisible:aPoint
    "is the point visible?"

    |bounds|

    bounds := self monitorBounds.
    ^ bounds contains:[:eachRectangle| eachRectangle containsPoint:aPoint].

    "
     Screen current pointIsVisible:(0@0)
     Screen current pointIsVisible:(1500@0)
     Screen current pointIsVisible:(9000@0)
     Screen current pointIsVisible:(Display pointFromUser)
    "
!

pointsAreOnSameMonitor:point1 and:point2
    "are the two points on the same (multi-screen) monitors?"

    ^ (self monitorBoundsAt:point1) = (self monitorBoundsAt:point2)
!

preferredIconSize
    "return the displays preferred size for icons.
     Redefined to return a special value on SGI servers."

    self serverVendor = 'Silicon Graphics' ifTrue:[
	^ 86@68
    ].
    ^ super preferredIconSize

    "Created: 10.6.1996 / 21:06:48 / cg"
!

scrollsAsynchronous
    "return true, if this display asynchronously sends expose events after a
     scroll operation. False otherwise. Asynchronous expose events are an X
     speciality, which affects a few methods outside of the display class (sorry)"

    ^ true
!

smallestMonitorHeight
    "returns the usable height of the smallest monitor in a mult-monito setup"

    |minH|

    minH := self usableHeight.
    self monitorBounds do:[:eachBounds |
	minH := minH min: eachBounds height.
    ].
    ^ minH

    "
	Display smallestMonitorHeight
    "
!

supportedClipboards
    "answer a collection of symbols with the supported clipboards.
     X11 additionaly supports a buffer containing the currently selected text
     (in xterm) - the PRIMARY selection"

    ^ #(clipboard selection)
!

supportedImageFormats
    "return an array with supported image formats;
     each array entry is an attribute dictionary, consisting of
     depth, bitsPerPixel and padding values."

    |nFormats "{ Class: SmallInteger }"
     formatArray|
%{
    Display *dpy;

    if (! ISCONNECTED) {
	RETURN (nil);
    }

    dpy = myDpy;
#ifdef NO_PRIVATE_DISPLAY_ACCESS
    nFormats = __MKSMALLINT(1);
#else
    nFormats = __MKSMALLINT(DISPLAYACCESS(dpy)->nformats);
#endif
%}.
    formatArray := Array new:nFormats.
    1 to:nFormats do:[:index |
	|info bitsPerPixelInfo depthInfo paddingInfo i|

	i := index.
%{
	ScreenFormat *format;
	Display *dpy = myDpy;

#ifdef NO_PRIVATE_DISPLAY_ACCESS
	depthInfo = __MKSMALLINT(1);
	bitsPerPixelInfo = __MKSMALLINT(1);
	paddingInfo = __MKSMALLINT(8);
#else
	format = DISPLAYACCESS(dpy)->pixmap_format;
	format += (__intVal(i)-1);
	bitsPerPixelInfo = __MKSMALLINT(format->bits_per_pixel);
	depthInfo = __MKSMALLINT(format->depth);
	paddingInfo = __MKSMALLINT(format->scanline_pad);
#endif
%}.
	info := IdentityDictionary new.
	info at:#depth put:depthInfo.
	info at:#bitsPerPixel put:bitsPerPixelInfo.
	info at:#padding put:paddingInfo.
	formatArray at:index put:info.
    ].
    ^ formatArray

    "
     Display supportedImageFormats
    "
!

supportsAnyViewBackgroundPixmaps
    "return true, if the device allows pixmaps as viewBackground."

    ^ true

    "Created: / 4.5.1999 / 18:41:07 / cg"
!

supportsArbitraryShapedViews
    "return true, if this workstation supports arbitrary shaped windows.
     Both the server must support it (the shape-extension),
     and the feature must have been enabled in the smalltalk system,
     for true to be returned."

    ^ hasShapeExtension

    "
     Display supportsArbitraryShapedViews
    "
!

supportsIconViews
    "return true, if this device supports views as icons.
     These can be drawn into like any other regular view, and therefore be easily animated.
     Only Xservers (currently) support this."

    ^ true

    "
     Display supportsIconViews
    "

    "Modified: 10.6.1996 / 20:11:48 / cg"
    "Created: 10.6.1996 / 21:08:18 / cg"
!

supportsMaskedDrawingWith:aForm
    "return true, if the device allows the given form pixmap
     to be used as paint color.
     True returned here - X has no trouble with any mask."

    ^ true

    "Created: / 4.5.1999 / 12:16:43 / cg"
!

supportsMaskedDrawingWithOffset:aForm
    "return true, if the device allows the given form pixmap
     to be used as paint color with a mask offset.
     True returned here - X has no trouble with any mask."

    "/ XQuartz seems to have a bug here...
    ^ OperatingSystem isOSXlike not.
    "/ ^ true.
!

supportsScreenReading
    "return true, if the device allows reading the screen pixels
     True returned here - X can do it"

    "XQuartz seems to have a bug here...
     ...but only on XQuartz servers.
     Blame: I cannot ask via server vendor, if its a Quartz display, because
     it does not return a valid server vendor string"
    OperatingSystem isOSXlike ifTrue:[
        ^ false
    ].

    "
    XWayland also does not support XGetImage() and the XWayland's vendor string
    is just 'The X.Org Foundation', sigh.

    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/190
    "
    ((OperatingSystem getEnvironment:'WAYLAND_DISPLAY') notNil 
        or:[  (OperatingSystem getEnvironment:'XDG_SESSION_TYPE') = 'wayland']) ifTrue:[ ^ false].

    ^ true

    "
     Display serverVendor
     Display supportsScreenReading
    "

    "Modified: / 04-01-2018 / 21:00:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

supportsUTF8WindowLabels
    "answer true, if window labels are to be utf-8 encoded"

    ^ false
!

supportsVariableHeightFonts
    "are fonts with variable height supported?"

    ^ false
!

supportsViewBackgroundPixmap:aForm
    "return true, if the device allows the given pixmap as viewBackground.
     True returned here - X supports any size.
     Other device types (windows) may restrict this to certain sizes."

    ^ true

    "Created: / 4.5.1999 / 18:40:42 / cg"
    "Modified: / 4.5.1999 / 18:44:25 / cg"
!

supportsViewGravity
    "return true, if this device supports gravity attributes.
     We do not depend on it being implemented, but some resizing operations
     are faster, if they are."

    ^ true
!

supportsXCursor
    "return true, if the XCursor extension (deep cursors ) are supported
     on this display.
     Both Smalltalk has to be compiled to support it (as client),
     and the display we are connected to must support it,
     to return true here."

     ^ self class hasXCursorLibrary
	and:[self hasCursorExtension]

    "
     Display supportsXCursor
     Display hasCursorExtension
     Display class hasXCursorLibrary
    "
!

supportsXftFonts
    "return true, if XftFonts (nice looking truetype fonts)
     are supported on this display.
     Both Smalltalk has to be compiled to support it (as client),
     and the display we are connected to must support it,
     to return true here."

     ^ XftFontDescription notNil and:[hasXftLibrary].

    "
     Display supportsXftFonts
     Display hasRenderExtension
     Display class hasXftLibrary
    "
!

supportsXftFontsInBitmaps
    "return true, if XftFonts (nice looking truetype fonts)
     are supported when drawing into bitmaps on this display.
     Currently, this does not work, so xft drawing must be disabled when
     rendering into bitmaps"

     ^ false.
     "/ ^ self supportsXftFonts

    "
     Display supportsXftFontsInBitmaps
     Display hasRenderExtension
     Display class hasXftLibrary
    "
!

suppressShadowViews
    "return true, if this device wants to suppress shadow views
     (i.e. shadows under popups and modalBoxes).
     Some (slow) devices may want to return true here.
     Also, with XQuartz, it does not work, because we cannot readout the screen..."

    OperatingSystem isOSXlike ifTrue:[
	^ true
    ].
    ^ super suppressShadowViews
!

usableHeightAt:aPoint
    "returns the usable height of the display (in pixels) at a given point
     Normally, the same as height, but may be smaller, in
     case some menu space is taken up by the window manager (windows).
     On multi-display systems with different sized screens, this should care for
     which display is at the given x-position"

    |h|

    h := (self monitorBoundsAt:aPoint) height.
    OperatingSystem isOSXlike ifTrue:[
	"/ take away some space for the icon-panel at the bottom.
	^ h - 50
    ].
    ^ h

    "
     Screen current usableHeightAt:(0@0)
     Screen current usableHeightAt:(1500@0)
     Screen current usableHeightAt:(3000@0)
     Screen current usableHeightAt:(9000@0)
     Screen current usableHeightAt:(Display pointFromUser)
    "
! !

!XWorkstation methodsFor:'bitmap/window creation'!

createBitmapFromArray:anArray width:w height:h
    "create a monochrome, depth1 bitmap from a given (byte-)array.
     The rows are aligned to a multiple of 8"

    |bitmapId|

    bitmapId := self primCreateBitmapFromArray:anArray width:w height:h.
    bitmapId isNil ifTrue:[
	self primitiveFailedOrClosedConnection
    ].
    ^ bitmapId
!

createBitmapFromFile:aString for:aForm
    <context: #return>

    |id w h|

%{
    int screen = __intVal(__INST(screen));

    if (ISCONNECTED
     && __isStringLike(aString)) {
	Display *dpy = myDpy;
	char *filename;
	int status;
	Pixmap newBitmap;
	unsigned b_width, b_height;
	int b_x_hot, b_y_hot;

	filename = (char *) __stringVal(aString);


	ENTER_XLIB();
	status = XReadBitmapFile(dpy, RootWindow(dpy, screen),
				 filename, &b_width, &b_height, &newBitmap,
				 &b_x_hot, &b_y_hot);
	LEAVE_XLIB();


	if ((status == BitmapSuccess)  && newBitmap) {
#ifdef COUNT_RESOURCES
	    __cnt_bitmap++;
#endif
	    w = __MKSMALLINT(b_width);
	    h = __MKSMALLINT(b_height);
	    id = __MKEXTERNALADDRESS(newBitmap);
	}
    }
%}.
    id notNil ifTrue:[
	aForm setWidth:w height:h
    ].
    ^ id
!

createBitmapWidth:w height:h
    "allocate a bitmap on the Xserver, the contents is undefined
     (i.e. random). Return a bitmap id or nil"

    <context: #return>

%{
    int screen = __intVal(__INST(screen));
    Pixmap newBitmap;

    if (__bothSmallInteger(w, h) && ISCONNECTED) {
	Display *dpy = myDpy;


	ENTER_XLIB();
	newBitmap = XCreatePixmap(dpy, RootWindow(dpy, screen),
				       __intVal(w), __intVal(h), 1);
	LEAVE_XLIB();
#ifdef COUNT_RESOURCES
	if (newBitmap)
	    __cnt_bitmap++;
#endif

	RETURN ( (newBitmap != (Pixmap)0) ? __MKEXTERNALADDRESS(newBitmap) : nil );
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ nil
!

createPixmapWidth:w height:h depth:d
    "allocate a pixmap on the Xserver, the contents is undefined
     (i.e. random). Return a bitmap id or nil"

    <context: #return>
%{

    int screen = __intVal(__INST(screen));
    Pixmap newBitmap;

    if (__bothSmallInteger(w, h) && ISCONNECTED) {
	Display *dpy = myDpy;


	ENTER_XLIB();
	newBitmap = XCreatePixmap(dpy, RootWindow(dpy, screen),
				       __intVal(w), __intVal(h), __intVal(d));
	LEAVE_XLIB();
#ifdef COUNT_RESOURCES
	if (newBitmap)
	    __cnt_bitmap++;
#endif

	RETURN ( (newBitmap != (Pixmap)0) ? __MKEXTERNALADDRESS(newBitmap) : nil );
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ nil
!

createWindowFor:aView type:typeSymbol
		 origin:origin
		 extent:extent
		 minExtent:minExt
		 maxExtent:maxExt
		 borderWidth:bWidth
		 subViewOf:wsuperView
		 style:wStyle
		 inputOnly:winputOnly
		 label:wlabel
		 owner:wowner
		 icon:wicon iconMask:wiconMask
		 iconView:wiconView

    <context: #return>

    |xpos ypos wwidth wheight minWidth minHeight maxWidth maxHeight
     bColorId wsuperViewId windowId isTopWindow
     weventMask bitGravity viewGravity vBgColor
     vBgForm deepForm preferredVisual preferredDepth
     wiconId wiconMaskId wiconViewId windowGroupWindowId|

    self isOpen ifFalse:[
	self primitiveFailedOrClosedConnection.
	^ nil
    ].

    origin notNil ifTrue:[
	xpos := origin x.
	ypos := origin y.
    ] ifFalse:[
	xpos := ypos := 0.
    ].
    extent notNil ifTrue:[
	wwidth := extent x.
	wheight := extent y.
    ] ifFalse:[
	wwidth := wheight := 100.
    ].
    minExt notNil ifTrue:[
	minWidth := minExt x.
	minHeight := minExt y
    ].
    maxExt notNil ifTrue:[
	maxWidth := maxExt x.
	maxHeight := maxExt y
    ].

    wsuperView notNil ifTrue:[
	wsuperViewId := wsuperView id
    ] ifFalse:[
	isTopWindow := true.
	aView class ~~ WindowGroupWindow ifTrue:[
	    windowGroupWindow isNil ifTrue:[
		self getWindowGroupWindow.
	    ].
	    windowGroupWindowId := windowGroupWindow id.
	].
	wicon notNil ifTrue:[
	    wiconId := wicon id.
	    wiconMask notNil ifTrue:[
		wiconMaskId := wiconMask id
	    ]
	].
	wiconView notNil ifTrue:[
	    wiconViewId := wiconView id
	].
    ].

    weventMask := aView eventMask.

    preferredVisual := aView preferredVisual.
    preferredDepth := aView preferredDepth.


%{  /* STACK:64000 */ /* used to be 16000 - but VMS seems to need a lot */
    Display *dpy = myDpy;
    int screen = __intVal(__INST(screen));
    Visual visual;
    XGCValues xgcv;
    XSetWindowAttributes xswa;
    XSizeHints sizehints;
    XClassHint classhint;
    int bw, bd, bg;
    Window newWindow, parentWindow, windowGroupWindow;
    XFontStruct *f;
    Pixmap backPixmap = (Pixmap)0;
    int flags = 0, depth, ioClass;
    Atom WmDeleteWindowAtom, WmSaveYourselfAtom, WmProtocolsAtom;
    Atom WmQuitAppAtom, MotifWMHintsAtom;
    Atom WmClientLeaderAtom;
    Atom WmClientMachineAtom;
    Atom NetWmPidAtom;
    Atom STXDeviceAtom, UUIDAtom;
    Atom atoms[3];
    int atomCount = 0;

    sizehints.flags = 0;
    sizehints.width = 100;
    sizehints.height = 100;
    sizehints.x = 0;
    sizehints.y = 0;

    if (__bothSmallInteger(wwidth, wheight)) {
	sizehints.flags |= PSize;
	sizehints.width = __intVal(wwidth);
	sizehints.height = __intVal(wheight);
    }
    if (__bothSmallInteger(xpos, ypos)) {
	sizehints.flags |= PPosition;
	sizehints.x = __intVal(xpos);
	sizehints.y = __intVal(ypos);
    }
    if (__bothSmallInteger(minWidth, minHeight)) {
	sizehints.flags |= PMinSize;
	sizehints.min_width = __intVal(minWidth);
	sizehints.min_height = __intVal(minHeight);
    }
    if (__bothSmallInteger(maxWidth, maxHeight)) {
	sizehints.flags |= PMaxSize;
	sizehints.max_width = __intVal(maxWidth);
	sizehints.max_height = __intVal(maxHeight);
    }

    bg = WhitePixel(dpy, screen);

    if (__isSmallInteger(bWidth)) {
	bw = __intVal(bWidth);
    } else {
	bw = 0;
    }

    bd = BlackPixel(dpy, screen);

    if (__isExternalAddress(wsuperViewId)) {
	parentWindow = __WindowVal(wsuperViewId);
    } else {
	parentWindow = RootWindow(dpy, screen);
    }

    if (wStyle == @symbol(popUp))
	xswa.override_redirect = 1;
    else
	xswa.override_redirect = 0;

    if (winputOnly == true)
	ioClass = InputOnly;
    else
	ioClass = InputOutput;

    if (__isSmallInteger(weventMask)) {
	xswa.event_mask = __intVal(weventMask);
    } else {
	xswa.event_mask = 0;
    }

    if (ioClass == InputOnly) {
	bw = 0;
	depth = 0;
	flags |= CWEventMask;
    } else {
	depth = DefaultDepth(dpy,screen);
	flags |= CWEventMask | CWBorderPixel | CWOverrideRedirect;

	if (backPixmap != (Pixmap)0) {
	    xswa.background_pixmap = backPixmap;
	    flags |= CWBackPixmap;
	} else {
	    xswa.background_pixel = bg;
	    flags |= CWBackPixel;
	}
	xswa.border_pixel = bd;
    }

    visual.visualid = CopyFromParent;
    if (__isSmallInteger(preferredDepth)) {
	depth = __intVal(preferredDepth);
    }


    if (preferredVisual != nil) {
	XVisualInfo vi;
	int cls;

	if (preferredVisual == @symbol(StaticGray))
	    cls = StaticGray;
	else if (preferredVisual == @symbol(GrayScale))
	    cls = GrayScale;
	else if (preferredVisual == @symbol(StaticColor))
	    cls = StaticColor;
	else if (preferredVisual == @symbol(PseudoColor))
	    cls = PseudoColor;
	else if (preferredVisual == @symbol(TrueColor))
	    cls = TrueColor;
	else if (preferredVisual == @symbol(DirectColor))
	    cls = DirectColor;
	else
	    cls = PseudoColor;

	ENTER_XLIB();
	if (XMatchVisualInfo(dpy, screen, depth, cls, &vi)) {
	    visual.visualid = vi.visualid;
/*
	    console_fprintf(stderr, "visualId=%x\n", vi.visualid);
*/
	}
	LEAVE_XLIB();
    }

    ENTER_XLIB2();
    newWindow = XCreateWindow(dpy, parentWindow,
			   sizehints.x, sizehints.y,
			   sizehints.width, sizehints.height,
			   bw, depth, ioClass, &visual,
			   flags, &xswa);
    LEAVE_XLIB();


    if (! newWindow) {
	RETURN ( nil );
    }

#ifdef COUNT_RESOURCES
    __cnt_view++;
#endif

    if (__isExternalAddress(windowGroupWindowId)) {
	windowGroupWindow = __WindowVal(windowGroupWindowId);	
    } else {
 	windowGroupWindow = newWindow;
    }

    /*
     * define its icon and name
     * (only makes sense for topWindows)
     */
    if (isTopWindow == true) {
	XWMHints wmhints;

	wmhints.flags = 0;

	if (__isExternalAddress(wiconId)) {
	    wmhints.icon_pixmap = __PixmapVal(wiconId);
	    wmhints.flags = IconPixmapHint;
	    if (__isExternalAddress(wiconMaskId)) {
		wmhints.icon_mask = __PixmapVal(wiconMaskId);
		wmhints.flags |= IconMaskHint;
	    }
	}

	
	wmhints.window_group = windowGroupWindow;
	wmhints.flags |= WindowGroupHint;
	

	if (__isExternalAddress(wiconViewId)) {
	    wmhints.flags |= IconWindowHint;
	    wmhints.icon_window = __WindowVal(wiconViewId);
	};

/*
	wmhints.flags |= InputHint;
	wmhints.input = True;
*/
	ENTER_XLIB();
	XSetWMHints(dpy, newWindow, &wmhints);
	XSetWMNormalHints(dpy, newWindow, &sizehints);
	LEAVE_XLIB();

	/*
	 * get atoms first (if not already known)
	 */
	if (__INST(protocolsAtom) == nil) {
	    ENTER_XLIB();
	    WmProtocolsAtom = XInternAtom(dpy, "WM_PROTOCOLS", False);
	    __INST(protocolsAtom) = __MKATOMOBJ(WmProtocolsAtom);
#ifdef USE_SAVEYOURSELF_ATOM
	    WmSaveYourselfAtom = XInternAtom(dpy, "WM_SAVE_YOURSELF", False);
	    __INST(saveYourselfAtom) = __MKATOMOBJ(WmSaveYourselfAtom);
#endif
#ifdef USE_QUIT_APP_ATOM
	    WmQuitAppAtom = XInternAtom(dpy, "_WM_QUIT_APP", False);
	    __INST(quitAppAtom) = __MKATOMOBJ(WmQuitAppAtom);
#endif
	    WmDeleteWindowAtom = XInternAtom(dpy, "WM_DELETE_WINDOW", False);
	    __INST(deleteWindowAtom) = __MKATOMOBJ(WmDeleteWindowAtom);

	    WmClientLeaderAtom = XInternAtom(dpy, "WM_CLIENT_LEADER", False);
	    __INST(wmClientLeaderAtom) = __MKATOMOBJ(WmClientLeaderAtom);

	    WmClientMachineAtom = XInternAtom(dpy, "WM_CLIENT_MACHINE", False);
	    __INST(wmClientMachineAtom) = __MKATOMOBJ(WmClientMachineAtom);

	    NetWmPidAtom = XInternAtom(dpy, "_NET_WM_PID", False);
	    __INST(netWmPidAtom) = __MKATOMOBJ(NetWmPidAtom);

	    UUIDAtom = XInternAtom(dpy, "UUID", False);
	    __INST(uuidAtom) = __MKATOMOBJ(UUIDAtom);
	    STXDeviceAtom = XInternAtom(dpy, "STX_DEVICE_ID", False);
	    __INST(stxDeviceAtom) = __MKATOMOBJ(STXDeviceAtom);

	    LEAVE_XLIB();
	} else {
#ifdef USE_QUIT_APP_ATOM
	    WmQuitAppAtom = __AtomVal(__INST(quitAppAtom));
#else
	    WmQuitAppAtom = 0;
#endif
	    WmProtocolsAtom = __AtomVal(__INST(protocolsAtom));
	    WmDeleteWindowAtom = __AtomVal(__INST(deleteWindowAtom));
#ifdef USE_SAVEYOURSELF_ATOM
	    WmSaveYourselfAtom = __AtomVal(__INST(saveYourselfAtom));
#else
	    WmSaveYourselfAtom = 0;
#endif
	    WmClientLeaderAtom = __AtomVal(__INST(wmClientLeaderAtom));
	    WmClientMachineAtom = __AtomVal(__INST(wmClientMachineAtom));
	    NetWmPidAtom = __AtomVal(__INST(netWmPidAtom));

	    UUIDAtom = __AtomVal(__INST(uuidAtom));;
	    STXDeviceAtom = __AtomVal(__INST(stxDeviceAtom));;
	}

	/*
	 * tell window manager to not kill us but send an event instead
	 */
	atoms[0] = WmDeleteWindowAtom; atomCount++;
#ifdef USE_SAVEYOURSELF_ATOM
	atoms[atomCount] = WmSaveYourselfAtom; atomCount++;
#endif
#ifdef USE_QUIT_APP_ATOM
	atoms[atomCount] = WmQuitAppAtom; atomCount++;
#endif
	ENTER_XLIB();
	XChangeProperty(dpy, newWindow, WmProtocolsAtom, XA_ATOM,
			32, PropModeReplace, (unsigned char *)atoms, atomCount);
	LEAVE_XLIB();

	/*
	 * an optional unique id (to mark stx-windows)
	 */
	if (__isBytes(__INST(uniqueDeviceID))) {
	    int numUUIDBytes = __byteArraySize(__INST(uniqueDeviceID));
	    unsigned char uuidBytes[32];

	    if (numUUIDBytes <= sizeof(uuidBytes)) {
		Atom uuidAtom;

		bcopy(__byteArrayVal(__INST(uniqueDeviceID)), uuidBytes, numUUIDBytes);

		ENTER_XLIB();
		XChangeProperty (dpy, newWindow, STXDeviceAtom, XA_ATOM, 8, PropModeReplace,
				 uuidBytes, numUUIDBytes );
		LEAVE_XLIB();
	    }
	}

	ENTER_XLIB();
	/* 
	 * Defined by ICCCM (https://tronche.com/gui/x/icccm/sec-5.html)
	 * Section 5.1. Client Support for Session Management,         
         */
	XChangeProperty (dpy, newWindow, WmClientLeaderAtom, XA_WINDOW, 32, 
	                 PropModeReplace, (unsigned char *)&windowGroupWindow, 1);
	/* 
	 * Section 4.1.2.9. WM_CLIENT_MACHINE Property
         */
        if (__isStringLike(__INST(hostname))) {
	XChangeProperty (dpy, newWindow, WmClientMachineAtom, XA_STRING, 8, 
	                 PropModeReplace, __stringVal(__INST(hostname)), __stringSize(__INST(hostname)));
	}
	/* 
	 * Section 4.1.2.5. WM_CLASS Property
	 */
	classhint.res_class = classhint.res_name = 0;

	if (__isStringLike(__INST(wmClassClass))) {
	    classhint.res_class = (char *) __stringVal(__INST(wmClassClass));
	}

	if (__isStringLike(__INST(wmClassName))) {
	    classhint.res_name = (char *) __stringVal(__INST(wmClassName));
	}	
	XSetClassHint(myDpy, newWindow, &classhint);
        /*
	 * Defined by EWMH, http://standards.freedesktop.org/wm-spec/1.3
	 * Section Application Window Properties
	 */
	if (__isInteger(__INST(pid))) {
	int pid = __intVal(__INST(pid));
	XChangeProperty (dpy, newWindow, NetWmPidAtom, XA_CARDINAL, 32, 
	                 PropModeReplace, (unsigned char *)&pid, 1);
	}	
	LEAVE_XLIB();

#ifdef SUPPORT_MOTIF_WM_HINTS
	/*
	 * less decoration
	 */
	if ((wStyle == @symbol(undecorated))
	 || (wStyle == @symbol(dialog2))
	 || (wStyle == @symbol(notitle))
	) {
	    if (__INST(motifWMHintsAtom) == nil) {
		ENTER_XLIB();
		MotifWMHintsAtom = XInternAtom(dpy, "_MOTIF_WM_HINTS", False);
		__INST(motifWMHintsAtom) = __MKATOMOBJ(MotifWMHintsAtom);
		LEAVE_XLIB();
	    } else {
		MotifWMHintsAtom = __AtomVal(__INST(motifWMHintsAtom));
	    }

	    {
		struct hints {
		    unsigned long flags;
		    unsigned long functions;
		    unsigned long decorations;
		    long input_mode;
		    unsigned long status;
		} mvm_hints;

		if (wStyle == @symbol(undecorated)) {
		    mvm_hints.decorations = MWM_DECOR_NONE;
		}
		if (wStyle == @symbol(dialog2)) {
		    mvm_hints.decorations = MWM_DECOR_BORDER
					    | MWM_DECOR_RESIZEH
					    | MWM_DECOR_TITLE
					    /* | MWM_DECOR_MENU */
					    /* | MWM_DECOR_MINIMIZE */
					    /* | MWM_DECOR_MAXIMIZE */
					    ;
		}
		if (wStyle == @symbol(notitle)) {
		    mvm_hints.decorations = MWM_DECOR_BORDER
					    /* | MWM_DECOR_RESIZEH  */
					    /* | MWM_DECOR_TITLE    */
					    /* | MWM_DECOR_MENU     */
					    /* | MWM_DECOR_MINIMIZE */
					    /* | MWM_DECOR_MAXIMIZE */
					    ;
		}
		mvm_hints.flags =  MWM_HINTS_DECORATIONS;
		ENTER_XLIB();
		XChangeProperty (dpy, newWindow, MotifWMHintsAtom,
				     MotifWMHintsAtom, 32, PropModeReplace,
				     (unsigned char*)&mvm_hints, 5 );
		LEAVE_XLIB();
	    }
	}
#endif /* SUPPORT_MOTIF_WM_HINTS */
    }

    windowId = __MKEXTERNALADDRESS(newWindow);
%}.

    "/ Set EWMH `_NET_WM_WINDOW_TYPE` property on created window
    "/ depending on desired `wStyle`. 
    "/
    "/ Note, that `wStyle` value is some Smalltalk/X abstraction 
    "/ of window types across all supported platforms (modeled,
    "/ presumably, after Winsows) so there;s no 1:1 match. The code
    "/ code below tries to do it's best. 
    "/ 
    "/ See Extended Window Manager Hints 1.3
    "/     http://standards.freedesktop.org/wm-spec/1.3/
    "/    
    "/     XWorkstation >> setWindowType:in:
    "/
    (wStyle == #dialog or:[wStyle == #dialog2]) ifTrue:[
    	self setWindowType: #'_NET_WM_WINDOW_TYPE_DIALOG' in: windowId.
    ] ifFalse:[
    (wStyle == #toolWindow) ifTrue:[
    	self setWindowType: #'_NET_WM_WINDOW_TYPE_UTILITY' in: windowId.
    ]].

"/    (wStyle ~= nil and:[wStyle ~= #normal]) ifTrue:[
"/        self setWindowType:wStyle in:windowId.
"/    ].

    (wsuperView isNil "this is a topwindow"
     and:[wlabel notEmptyOrNil]) ifTrue:[
	self
	    setIconName:wlabel in:windowId;
	    setWindowName:wlabel in:windowId.
    ].

    self addKnownView:aView withId:windowId.
    ^ windowId

    "Modified: / 09-01-2013 / 10:43:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

destroyGC:aGCId

    <context: #return>
%{
    /*
     * ignore closed connection
     */
    if (! ISCONNECTED) {
	RETURN ( self );
    }

    if (__isExternalAddress(aGCId)) {
	GC gc = __GCVal(aGCId);

	if (gc) {
	    __ExternalAddressInstPtr(aGCId)->e_address = NULL;

	    ENTER_XLIB();
	    XFreeGC(myDpy, gc);
	    LEAVE_XLIB();
#ifdef COUNT_RESOURCES
	    __cnt_gc--;
#endif
            RETURN ( self );
	}	
    }
%}.
    self primitiveFailed: 'Trying to destroy GC twice'
!

destroyPixmap:aDrawableId

    <context: #return>
%{
    /*
     * ignore closed connection
     */
    if (! ISCONNECTED) {
	RETURN ( self );
    }

    if (__isExternalAddress(aDrawableId)) {
	Pixmap pix = __PixmapVal(aDrawableId);

	if (pix) {

	    ENTER_XLIB();
	    XFreePixmap(myDpy, pix);
	    LEAVE_XLIB();
#ifdef COUNT_RESOURCES
	    __cnt_bitmap--;
#endif

	}
	RETURN ( self );
    }
%}.
    self primitiveFailed
!

destroyView:aViewOrNil withId:aWindowId
    XftFontDescription notNil ifTrue:[
	XftFontDescription aboutToDestroyViewWithDevice:self id:aWindowId.
    ].
    self primDestroyViewWithId:aWindowId.
    self removeKnownView:aViewOrNil withId:aWindowId.
!

dpsContextFor:aDrawableId and:aGCId

    <context: #return>

%{
#ifdef XXDPS
    int screen = __intVal(__INST(screen));
    DPSContext dps;
    int height;

    if (__isExternalAddress(aDrawableId)
     && __isExternalAddress(aGCId)
     && ISCONNECTED) {

	ENTER_XLIB();
	dps = XDPSCreateContext(myDpy, __DrawableVal(aDrawableId),
				       __GCVal(aGCId),
				       0, height, 0, colormap, NULL, 0,
				       XDPSDefaultTextBackstop,
				       XDPSDefaultErrorProc,
				       NULL);
	LEAVE_XLIB();

	RETURN ( dps ? __MKEXTERNALADDRESS(dps) : nil );
    }
#endif
%}.
    self primitiveFailedOrClosedConnection.
    ^ nil
!

gcFor:aDrawableId

    <context: #return>
%{
    int screen = __intVal(__INST(screen));
    GC gc;

    if (__isExternalAddress(aDrawableId) && ISCONNECTED) {

	ENTER_XLIB();
	gc = XCreateGC(myDpy, __DrawableVal(aDrawableId), 0L, (XGCValues *)0);
	LEAVE_XLIB();

#ifdef COUNT_RESOURCES
	if (gc)
	    __cnt_gc++;
#endif

	RETURN ( gc ? __MKEXTERNALADDRESS(gc) : nil );
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ nil
!

gcForBitmap:aDrawableId
    "with X, this is the same as a normal gc"

    ^ self gcFor:aDrawableId
!

primCreateBitmapFromArray:anArray width:w height:h
    <context: #return>

%{  /* UNLIMITEDSTACK */

    Display *dpy;
    int screen = __intVal(__INST(screen));
    Pixmap newBitmap;
    unsigned int b_width, b_height;
    REGISTER unsigned char *cp;
    REGISTER unsigned char *pBits;
    unsigned char *b_bits, *allocatedBits;
    int index, row;
    REGISTER int col;
    unsigned bits;
    static char reverseBitTable[256];
    static int firstCall = 1;
    int nBytes;
    unsigned char fastBits[10000];
    OBJ num, *op;
    int bytesPerRow;

    if (! ISCONNECTED) {
	RETURN (nil);
    }

    dpy = myDpy;
    if (firstCall) {
	for (index=0; index < 256; index++) {
	    int t = 0;

	    if (index & 128) t |=   1;
	    if (index &  64) t |=   2;
	    if (index &  32) t |=   4;
	    if (index &  16) t |=   8;
	    if (index &   8) t |=  16;
	    if (index &   4) t |=  32;
	    if (index &   2) t |=  64;
	    if (index &   1) t |= 128;

	    reverseBitTable[index] = t;
	}
	firstCall = 0;
    }

    if (__bothSmallInteger(w, h) && _isNonNilObject(anArray)) {
	newBitmap = (Pixmap)0;
	b_width = __intVal(w);
	b_height = __intVal(h);
	bytesPerRow = (b_width + 7) / 8;
	nBytes = b_height * bytesPerRow;
	if (nBytes < sizeof(fastBits)) {
	    cp = b_bits = fastBits;
	    allocatedBits = 0;
	} else {
	    cp = b_bits = allocatedBits = (unsigned char *) malloc(nBytes);
	    if (! cp) goto fail;
	}

	if (__isArrayLike(anArray)) {
	    index = 1;
	    op = &(__ArrayInstPtr(anArray)->a_element[index - 1]);
	    for (row = b_height; row; row--) {
		for (col = bytesPerRow; col; col--) {
		    num = *op++;
		    if (__isSmallInteger(num)) {
			bits = __intVal(num);
		    } else {
			bits = __longIntVal(num);
			if (bits == 0) {
			    goto fail;
			}
		    }
		    *cp++ = reverseBitTable[bits & 0xFF];
		}
	    }
	} else {
	    if (__isByteArrayLike(anArray)) {
		pBits = __ByteArrayInstPtr(anArray)->ba_element;
		for (col = b_height*bytesPerRow; col; col--) {
		    *cp++ = reverseBitTable[*pBits++];
		}
	    } else {
		goto fail;
	    }
	}


	ENTER_XLIB();
	newBitmap = XCreateBitmapFromData(dpy, RootWindow(dpy, screen),
					       (char *)b_bits,
					       b_width, b_height);
	LEAVE_XLIB();
#ifdef COUNT_RESOURCES
	if (newBitmap)
	    __cnt_bitmap++;
#endif


fail: ;
	if (allocatedBits)
	    free(allocatedBits);
	RETURN ( newBitmap ? __MKEXTERNALADDRESS(newBitmap) : nil );
    }
%}.
    ^ nil
!

primCreateWindowType:t origin:o extent:e minExtent:minE maxExtent:maxE borderWidth:bw superViewId:sv style:st inputOnly:i label:l ownerId:oId iconId:ic iconMaskId:im iconViewId:iv
    "for rel5 only"

    ^ self primitiveFailedOrClosedConnection

!

primDestroyViewWithId:aWindowId
    <context: #return>
%{
    if (! ISCONNECTED) {
	RETURN ( self );
    }

    if (__isExternalAddress(aWindowId)) {
	Window win = __WindowVal(aWindowId);

	if (win) {

	    ENTER_XLIB();
	    XDestroyWindow(myDpy, win);
	    LEAVE_XLIB();
#ifdef COUNT_RESOURCES
	    __cnt_view--;
#endif

	}
    }
%}
! !

!XWorkstation methodsFor:'clipboard'!

getPrimaryBuffer
    "Returns the contents of PRIMARY selection buffer"

    ^ primaryBuffer

    "Created: / 27-03-2012 / 14:51:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primaryBufferAsString
    "return my current selection as a string"

    ^ self class bufferAsString:self getPrimaryBuffer.
!

setPrimaryBuffer:aString
    "Sets the contents of PRIMARY selection."

    primaryBuffer := aString.

    "Created: / 27-03-2012 / 14:41:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setPrimaryText:aString ownerView:aView
    "Set the PRIMARY selection - both the local one, and tell the display
     that we have changed it (i.e. place it into the PRIMARY)."

    |s viewID|

    self setPrimaryBuffer:aString.

    s := aString ? ''.
    s isString ifFalse:[
	s := s asStringWithCRsFrom:1 to:(s size) compressTabs:false withCR:false
    ].

    viewID := aView id.
    viewID notNil ifTrue:[ "/ if the view is not already closed
	"/ for now - should add support to pass emphasis information too
	s := s string.
	self setPrimaryText:s owner:viewID.
    ]

    "Created: / 27-03-2012 / 14:46:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XWorkstation methodsFor:'color stuff'!

colorCell
    "allocate a color cell - return the color index (i.e. colorID).
     This method will return nil for StaticGrey, StaticGrey and TrueColor displays."

    <context: #return>
%{

    int screen = __intVal(__INST(screen));
    XColor color;
    unsigned long dummy;
    Status ok;

    if (ISCONNECTED) {
	Display *dpy = myDpy;


	ENTER_XLIB();
	ok = XAllocColorCells(dpy, DefaultColormap(dpy, screen), (Bool)0,
				   &dummy, 0, &color.pixel, 1);
	LEAVE_XLIB();

	if (ok) {
#ifdef COUNT_RESOURCES
	    __cnt_color++;
#endif
	    RETURN ( __MKSMALLINT(color.pixel) );
	}
    }
%}.
    ^ nil
!

colorNamed:aString
    "allocate a color with color name - return the color index (i.e. colorID).
     On trueColor displays, nothing is actually allocated,
     and the returned colorID is formed by simply packing the RGB values.
     Don't use this method, colornames are mostly X specific."

    <context: #return>
%{

    char *colorname;
    XColor scolor, ecolor;
    int screen = __intVal(__INST(screen));
    int id;
    Status ok;

    if (ISCONNECTED
     && __isStringLike(aString)) {
	Display *dpy = myDpy;

	colorname = (char *) __stringVal(aString);


	ENTER_XLIB();
	ok = XParseColor(dpy, DefaultColormap(dpy, screen), colorname, &ecolor);
	LEAVE_XLIB();
	if (ok) {
#ifdef QUICK_TRUE_COLORS
	    if (__INST(visualType) == @symbol(TrueColor)) {
		id = ((ecolor.red >> (16 - __intVal(__INST(bitsRed)))) << __intVal(__INST(redShift))) & __intVal(__INST(redMask));
		id += ((ecolor.green >> (16 - __intVal(__INST(bitsGreen)))) << __intVal(__INST(greenShift))) & __intVal(__INST(greenMask));
		id += ((ecolor.blue >> (16 - __intVal(__INST(bitsBlue)))) << __intVal(__INST(blueShift))) & __intVal(__INST(blueMask));
		RETURN ( __MKSMALLINT(id) );
	    }
#endif
	    ENTER_XLIB();
	    ok = XAllocColor(dpy, DefaultColormap(dpy, screen), &ecolor);
	    LEAVE_XLIB();
	}

	if (! ok) {
	    RETURN ( nil );
	}
#ifdef COUNT_RESOURCES
	__cnt_color++;
#endif
	RETURN ( __MKSMALLINT(ecolor.pixel) );
    }
%}.
    ^ super colorNamed:aString
!

colorScaledRed:r scaledGreen:g scaledBlue:b
    "allocate a color with rgb values (0..16rFFFF)
     - return the color index (i.e. colorID).
     On trueColor displays, nothing is actually allocated,
     and the returned colorID is formed by simply packing the RGB values."

    <context: #return>
%{
    Display *dpy;
    XColor ecolor;
    int screen = __intVal(__INST(screen));
    Status ok;
    int id;

    if (__bothSmallInteger(r, g)
     && __isSmallInteger(b)
     && ISCONNECTED) {
	ecolor.red = __intVal(r);
	ecolor.green= __intVal(g);
	ecolor.blue = __intVal(b);
#ifdef QUICK_TRUE_COLORS
	if (__INST(visualType) == @symbol(TrueColor)) {
	    id = ((ecolor.red >> (16 - __intVal(__INST(bitsRed)))) << __intVal(__INST(redShift))) & __intVal(__INST(redMask));
	    id += ((ecolor.green >> (16 - __intVal(__INST(bitsGreen)))) << __intVal(__INST(greenShift))) & __intVal(__INST(greenMask));
	    id += ((ecolor.blue >> (16 - __intVal(__INST(bitsBlue)))) << __intVal(__INST(blueShift))) & __intVal(__INST(blueMask));
	    RETURN ( __MKSMALLINT(id) );
	}
#endif
	dpy = myDpy;

	ENTER_XLIB();
	ok = XAllocColor(dpy, DefaultColormap(dpy, screen), &ecolor);
	LEAVE_XLIB();

	if (! ok) {
	    RETURN ( nil );
	}
#ifdef COUNT_RESOURCES
	__cnt_color++;
#endif
	RETURN ( __MKSMALLINT(ecolor.pixel) );
    }
%}.
    ^ super colorScaledRed:r scaledGreen:g scaledBlue:b
!

deviceColorValueToPercent:aDeviceValue
    "given a color-component value in percent (0..65k), return the corresponding
     x-component value (0..100)"

    ^ (100.0 * aDeviceValue / 16rFFFF)

    "
     Display deviceColorValueToPercent:0
     Display deviceColorValueToPercent:16r8000
     Display deviceColorValueToPercent:16rFFFF
    "
!

freeColor:colorIndex
    "free a display color when its no longer needed"

    <context: #return>
%{

    Display *dpy;
    unsigned long color;
    int screen = __intVal(__INST(screen));

#ifdef QUICK_TRUE_COLORS
    if (__INST(visualType) == @symbol(TrueColor)) {
	/* no need to do anything on TrueColor displays ... */
	RETURN (self);
    }
#endif

    /*
     * ignore closed connection
     */
    if (! ISCONNECTED) {
	RETURN (self);
    }

    if (__isSmallInteger(colorIndex)) {
	dpy = myDpy;
	color = (long) __intVal(colorIndex);

	ENTER_XLIB();
	XFreeColors(dpy, DefaultColormap(dpy, screen), &color, 1, 0L);
	LEAVE_XLIB();
#ifdef COUNT_RESOURCES
	__cnt_color--;
#endif

	RETURN ( self );
    }
%}.
    self primitiveFailed
!

getScaledRGBFrom:index
    "get rgb components (0 .. 16rFFFF) of color in map at:index,
     and return a 3-element array containing them"

    <context: #return>
%{
    int screen = __intVal(__INST(screen));
    XColor color;
    int sr, sg, sb;
    int bits, scale, shift;

    if (ISCONNECTED
     && __isSmallInteger(index)) {
	Display *dpy = myDpy;

	color.pixel = __intVal(index);

	ENTER_XLIB();
	XQueryColor(dpy, DefaultColormap(dpy, screen), &color);
	LEAVE_XLIB();


	/*
	 * have to compensate for an error in X ?, which does not scale
	 * colors correctly if lesser than 16bits are valid in a color,
	 * (for example, color white on a 4bitsPerRGB server will Return
	 * (16rF000 16rF000 16rF000) instead of (16rFFFF 16rFFFF 16rFFFF)
	 */
	bits = __intVal(__INST(bitsPerRGB));
	scale = (1<<bits) - 1;
	shift = 16 - bits;

	sr = ((double)(color.red>>shift) / scale) * 0xFFFF;
	sg = ((double)(color.green>>shift) / scale) * 0xFFFF;
	sb = ((double)(color.blue>>shift) / scale) * 0xFFFF;
	RETURN ( __ARRAY_WITH3(__MKSMALLINT(sr), __MKSMALLINT(sg), __MKSMALLINT(sb)));
    }
%}.
    ^ super getScaledRGBFrom:index
!

getScaledRGBFromName:colorName
    "get rgb components (0..16rFFFF) of color named colorName,
     and return a 3-element array containing them"

%{
    int screen = __intVal(__INST(screen));
    XColor color;
    double dr, dg, db;
    int sr, sg, sb;
    int bits, scale, shift;

    if (ISCONNECTED
     && __isStringLike(colorName)) {
	Display *dpy = myDpy;


	if (XParseColor(dpy, DefaultColormap(dpy, screen),
			     (char *) __stringVal(colorName), &color)) {
	    /*
	     * have to compensate for an error in X ?, which does not scale
	     * colors correctly if lesser than 16bits are valid in a color,
	     * (for example, color white on a 4bitsPerRGB server will Return
	     * (16rF000 16rF000 16rF000) instead of (16rFFFF 16rFFFF 16rFFFF)
	     */
	    bits = __intVal(__INST(bitsPerRGB));
	    scale = (1<<bits) - 1;
	    shift = 16 - bits;

	    /* do assignment to doubles (no cast) - avoid alignment problems in HPPA */
	    dr = color.red>>shift;
	    dg = color.green>>shift;
	    db = color.blue>>shift;

	    sr = (dr / scale) * 0xFFFF;
	    sg = (dg / scale) * 0xFFFF;
	    sb = (db / scale) * 0xFFFF;
	    RETURN ( __ARRAY_WITH3(__MKSMALLINT(sr), __MKSMALLINT(sg), __MKSMALLINT(sb)));
	}

    }
%}.
    ^ super getScaledRGBFromName:colorName

    "
	Screen current getScaledRGBFromName:'red'
	Screen current getScaledRGBFromName:'orange'
    "
!

listOfAvailableColors
    "return a list of all available colornames.
     This should not be used, since colornames are very
     display-specific (here X-specific)."

    |aStream list line index colorName|

    aStream := '/usr/lib/X11/rgb.txt' asFilename readStreamOrNil.
    aStream isNil ifTrue:[^ nil].
    list := OrderedCollection new.
    [aStream atEnd] whileFalse:[
	line := aStream nextLine.
	line notNil ifTrue:[
	    "skip the r/g/b numbers"
	    index := 1.
	    [(line at:index) isSeparator] whileTrue:[index := index + 1].
	    [(line at:index) isDigit] whileTrue:[index := index + 1].
	    [(line at:index) isSeparator] whileTrue:[index := index + 1].
	    [(line at:index) isDigit] whileTrue:[index := index + 1].
	    [(line at:index) isSeparator] whileTrue:[index := index + 1].
	    [(line at:index) isDigit] whileTrue:[index := index + 1].
	    [(line at:index) isSeparator] whileTrue:[index := index + 1].
	    colorName := line copyFrom:index.
	    ((colorName occurrencesOf:(Character space)) == 0) ifTrue:[
		list add:colorName
	    ]
	]
    ].
    aStream close.
    ^ list sort

    "
     Screen current listOfAvailableColors
    "

    "Modified: 11.9.1996 / 15:26:28 / stefan"
!

percentToDeviceColorValue:aPercentage
    "given a color-component value in percent (0..100), return the corresponding
     x-component value (0..65k) as an integer"


%{  /* NOCONTEXT */

    if (__isSmallInteger(aPercentage)) {
	RETURN ( __MKSMALLINT(0xFFFF * __intVal(aPercentage) / 100) );
    }
    if (__isFloat(aPercentage)) {
	RETURN ( __MKSMALLINT(0xFFFF * (int)(__floatVal(aPercentage)) / 100) );
    }
%}.
    ^ (16rFFFF * aPercentage / 100) rounded
!

setColor:index scaledRed:sred scaledGreen:sgreen scaledBlue:sblue
    "change color in map at:index to rgb (0..16rFFFF).
     This method is a noop for StaticGrey, StaticGrey and TrueColor displays."

    <context: #return>
%{

    char *colorname;
    XColor color;
    int screen = __intVal(__INST(screen));
    int r, g, b;
    int ok = 1;

    if (__isSmallInteger(sred))
	r = __intVal(sred);
    else ok = 0;

    if (__isSmallInteger(sgreen))
	g = __intVal(sgreen);
    else ok = 0;

    if (__isSmallInteger(sblue))
	b = __intVal(sblue);
    else ok = 0;

    if (ISCONNECTED
     && __isSmallInteger(index) && ok) {
	Display *dpy = myDpy;

	color.pixel = __intVal(index);
	color.red = r;
	color.green = g;
	color.blue = b;
	color.flags = DoRed | DoGreen | DoBlue;


	ENTER_XLIB();
	XStoreColor(dpy, DefaultColormap(dpy, screen), &color);
	LEAVE_XLIB();

	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
! !

!XWorkstation methodsFor:'cursor stuff'!

builtInCursorShapes
    "return a collection of standard cursor names.
     Those are built into the XServer and need not be created as
     user cursors.
     (actually, there are more than those below ...)"

    "/ if you add something here, also add to #shapeNumberFromCursor ...

    ^ #(
	#upLeftArrow            "/ XC_top_left_arrow
	#upRightHand            "/ XC_hand1
	#upDownArrow            "/ XC_sb_v_double_arrow
	#leftRightArrow         "/ XC_sb_h_double_arrow
	#upLimitArrow           "/ XC_top_side
	#downLimitArrow         "/ XC_bottom_side
	#leftLimitArrow         "/ XC_left_side
	#rightLimitArrow        "/ XC_right_side
	#text                   "/ XC_xterm
	#upRightArrow           "/ XC_draft_large
	#leftHand               "/ XC_hand2
	#questionMark           "/ XC_question_arrow
	#cross                  "/ XC_X_cursor
	#wait                   "/ XC_watch
	#crossHair              "/ XC_tcross
	#origin                 "/ XC_ul_angle
	#topLeft                "/ XC_ul_angle
	#corner                 "/ XC_lr_angle
	#bottomRight            "/ XC_lr_angle
	#topRight               "/ XC_ur_angle
	#bottomLeft             "/ XC_ll_angle
	#square                 "/ XC_dotbox
	#fourWay                "/ XC_fleur
	#crossCursor            "/ XC_X_cursor
      )

    "Created: 8.4.1997 / 10:12:30 / cg"
    "Modified: 8.4.1997 / 10:31:46 / cg"
!

colorCursor:aCursorId foreground:fgColor background:bgColor
    "change a cursors colors"

    <context: #return>

    |fgR fgG fgB bgR bgG bgB|

    fgR := fgColor scaledRed.
    fgG := fgColor scaledGreen.
    fgB := fgColor scaledBlue.
    bgR := bgColor scaledRed.
    bgG := bgColor scaledGreen.
    bgB := bgColor scaledBlue.
%{
    XColor fgcolor, bgcolor;

    if (ISCONNECTED
     && __isExternalAddress(aCursorId)
     && __bothSmallInteger(fgG, fgB)
     && __bothSmallInteger(bgR, bgG)
     && __bothSmallInteger(bgB, fgR)) {

	fgcolor.red = __intVal(fgR);
	fgcolor.green= __intVal(fgG);
	fgcolor.blue = __intVal(fgB);
	bgcolor.red = __intVal(bgR);
	bgcolor.green= __intVal(bgG);
	bgcolor.blue = __intVal(bgB);

	ENTER_XLIB();
	XRecolorCursor(myDpy, __CursorVal(aCursorId), &fgcolor, &bgcolor);
	LEAVE_XLIB();

	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

createCursorShape:aShape
    "create a cursor given a shape-symbol. This only works
     for a few standard cursors, and returns nil if no such cursor exists.
     Senders must always care for a fallBack, in case of a nil return."

    |shapeNumber|

    shapeNumber := self shapeNumberFromSymbol:aShape.
    shapeNumber isNil ifTrue:[^ nil].
    ^ self primCreateCursorShapeNumber:shapeNumber
!

createCursorSourceForm:sourceForm maskForm:maskForm hotX:hx hotY:hy width:w height:h
    "create a cursor given 2 bitmaps (source, mask) and a hotspot"

    ^ self
	primCreateCursorSourceFormId:sourceForm id
	maskFormId:maskForm id
	hotX:hx hotY:hy
	width:w height:h
!

destroyCursor:aCursorId
    "release a cursor - frees any device resources"

    <context: #return>
%{
    /*
     * ignore closed connection
     */
    if (! ISCONNECTED) {
	RETURN ( self );
    }

    if (__isExternalAddress(aCursorId)) {
	Cursor curs = __CursorVal(aCursorId);

	if (curs) {

	    ENTER_XLIB();
	    XFreeCursor(myDpy, curs);
	    LEAVE_XLIB();
#ifdef COUNT_RESOURCES
	    __cnt_cursor--;
#endif
	}
	RETURN ( self );
    }
%}.
    self primitiveFailed
!

needDeviceFormsForCursor
    ^ true
!

primCreateCursorShapeNumber:aShapeNumber
    "create a cursor given a shape-number."

    <context: #return>
%{
    Cursor newCursor;

    if (ISCONNECTED
     && __isSmallInteger(aShapeNumber)) {

	ENTER_XLIB();
	newCursor = XCreateFontCursor(myDpy, __intVal(aShapeNumber));
	LEAVE_XLIB();
#ifdef COUNT_RESOURCES
	if (newCursor)
	    __cnt_cursor++;
#endif

	if (newCursor != (Cursor)0) {
	    RETURN (__MKEXTERNALADDRESS(newCursor));
	}
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ nil
!

primCreateCursorSourceFormId:sourceId maskFormId:maskId hotX:hx hotY:hy width:w height:h
    "create a cursor given 2 bitmaps (source, mask) and a hotspot"

    <context: #return>
%{
    Cursor newCursor;
    XColor fgColor, bgColor;

    if (ISCONNECTED
     && __isExternalAddress(sourceId)
     && __isExternalAddress(maskId)
     && __bothSmallInteger(hx, hy)) {
	fgColor.red = 0;        /* fg is black */
	fgColor.green = 0;
	fgColor.blue = 0;
	bgColor.red = 0xFFFF;   /* bg is white */
	bgColor.green = 0xFFFF;
	bgColor.blue = 0xFFFF;


	ENTER_XLIB();
	newCursor = XCreatePixmapCursor(myDpy,
				__PixmapVal(sourceId),
				__PixmapVal(maskId),
				&fgColor, &bgColor, __intVal(hx), __intVal(hy));
	LEAVE_XLIB();
#ifdef COUNT_RESOURCES
	if (newCursor)
	    __cnt_cursor++;
#endif

	if (newCursor != (Cursor)0) {
	    RETURN (__MKEXTERNALADDRESS(newCursor));
	}
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ nil
!

shapeNumberFromSymbol:shape
    "given a shape-symbol, return the corresponding cursor-number,
     or nil if no such standard cursor exists."

    "/this is pure X-knowlegde - but you may easily add more
    "/ if you add something here, also add to #builtInCursorShapes ...

%{  /* NOCONTEXT */
    if (shape == @symbol(upLeftArrow)) RETURN ( __MKSMALLINT(XC_top_left_arrow) );
    if (shape == @symbol(upRightHand)) RETURN (  __MKSMALLINT(XC_hand1) );
    if (shape == @symbol(upDownArrow)) RETURN (  __MKSMALLINT(XC_sb_v_double_arrow) );
    if (shape == @symbol(leftRightArrow)) RETURN (  __MKSMALLINT(XC_sb_h_double_arrow) );
    if (shape == @symbol(upLimitArrow)) RETURN (  __MKSMALLINT(XC_top_side) );
    if (shape == @symbol(downLimitArrow)) RETURN (  __MKSMALLINT(XC_bottom_side) );
    if (shape == @symbol(leftLimitArrow)) RETURN (  __MKSMALLINT(XC_left_side) );
    if (shape == @symbol(rightLimitArrow)) RETURN (  __MKSMALLINT(XC_right_side) );
    if (shape == @symbol(text)) RETURN (  __MKSMALLINT(XC_xterm) );
    if (shape == @symbol(upRightArrow)) RETURN (  __MKSMALLINT(XC_draft_large) );
    if (shape == @symbol(leftHand)) RETURN (  __MKSMALLINT(XC_hand2) );
    if (shape == @symbol(questionMark)) RETURN (  __MKSMALLINT(XC_question_arrow) );
    if (shape == @symbol(cross)) RETURN (  __MKSMALLINT(XC_X_cursor) );
    if (shape == @symbol(wait)) RETURN (  __MKSMALLINT(XC_watch) );
    if (shape == @symbol(crossHair)) RETURN (  __MKSMALLINT(XC_tcross) );
    if ((shape == @symbol(origin)) || (shape == @symbol(topLeft))) RETURN (  __MKSMALLINT(XC_ul_angle) );
    if ((shape == @symbol(corner)) || (shape == @symbol(bottomRight))) RETURN ( __MKSMALLINT(XC_lr_angle) );
    if (shape == @symbol(topRight)) RETURN (  __MKSMALLINT(XC_ur_angle) );
    if (shape == @symbol(bottomLeft)) RETURN (  __MKSMALLINT(XC_ll_angle) );
    if (shape == @symbol(square)) RETURN (  __MKSMALLINT(XC_dotbox) );
    if (shape == @symbol(fourWay)) RETURN (  __MKSMALLINT(XC_fleur) );
    if (shape == @symbol(crossCursor)) RETURN (  __MKSMALLINT(XC_X_cursor) );
%}.
"/    Logger info:'invalid cursorShape: %1' with:shape.
    ^  nil
! !

!XWorkstation methodsFor:'drag & drop'!

dndDrop:dropObjects inWindowID:destinationId position:destinationPoint rootPosition:rootPoint
    "drop something in some alien view, using the DND protocol.
     Returns false, if the drop could not be performed."

    |msgType dropColl dropCollSize anyFile anyDir anyText anyOther
     dropType dropTypeCode strings sz idx val|

    (msgType := self atomIDOf:#DndProtocol) notNil ifTrue:[

	"/ DND can drop files, file, dir, links, dirLink and text
	"/ check for this.

	dropObjects isCollection ifFalse:[
	    dropColl := Array with:dropObjects
	] ifTrue:[
	    dropColl := dropObjects
	].
	anyFile := anyDir := anyText := anyOther := false.
	dropColl do:[:aDropObject |
	    aDropObject isFileObject ifTrue:[
		aDropObject theObject isDirectory ifTrue:[
		    anyDir := true
		] ifFalse:[
		    anyFile := true
		]
	    ] ifFalse:[
		aDropObject isTextObject ifTrue:[
		    anyText := true
		] ifFalse:[
		    anyOther := true
		]
	    ]
	].

	anyOther ifTrue:[
	    "/ DND does not support this ...
	    Logger info:'DND can only drop files or text'.
	    ^ false
	].
	anyText ifTrue:[
	    (anyFile or:[anyDir]) ifTrue:[
		"/ DND does not support mixed types
		Logger info:'DND cannot drop both files and text'.
		^ false
	    ]
	].

	dropCollSize := dropColl size.
	anyFile ifTrue:[
	    dropType := #DndFiles.
	    dropCollSize == 1 ifTrue:[
		dropType := #DndFile
	    ]
	] ifFalse:[
	    anyDir ifTrue:[
		dropType := #DndFiles.
		dropCollSize == 1 ifTrue:[
		    dropType := #DndDir
		]
	    ] ifFalse:[
		anyText ifTrue:[
		    dropCollSize == 1 ifTrue:[
			dropType := #DndText
		    ] ifFalse:[
			"/ can only drop a single text object
			Logger info:'DND can only drop a single text'.
			^ false
		    ]
		] ifFalse:[
		    "/ mhmh ...
		    Logger info:'DND cannot drop this'.
		    ^ false
		]
	    ]
	].

	dropTypeCode := self dndDropTypes indexOf:dropType.
	dropTypeCode == 0 ifTrue:[
	    Logger info:'DND cannot drop this'.
	    ^ false
	].
	dropTypeCode := dropTypeCode - 1.


	"/ place the selection inTo the DndSelection property
	"/ of the rootView ...
	"/ ... need a single string, with 0-terminated parts.

	strings := OrderedCollection new.
	sz := 0.
	dropColl do:[:anObject |
	    |s o|

	    o := anObject theObject.
	    anObject isFileObject ifTrue:[
		o := o pathName
	    ].
	    s := o asString.
	    strings add:s.
	    sz := sz + (s size) + 1.
	].
	val := String new:sz.
	idx := 1.
	strings do:[:aString |
	    |sz|

	    sz := aString size.
	    val replaceFrom:idx to:(idx + sz - 1) with:aString startingAt:1.
	    idx := idx + sz.
	    val at:idx put:(Character value:0).
	    idx := idx + 1
	].

	self
	    setProperty:(self atomIDOf:#DndSelection)
	    type:(self atomIDOf:#STRING)
	    value:val
	    for:rootId.

	^ self
	    sendClientEvent:msgType
	    format:32
	    to:destinationId
	    propagate:true
	    eventMask:nil
	    window:destinationId
	    data1:dropTypeCode
	    data2:0
	    data3:destinationId
	    data4:nil
	    data5:nil.
    ].

    ^ false

    "Created: 6.4.1997 / 13:39:37 / cg"
    "Modified: 6.4.1997 / 14:30:43 / cg"
!

dndDropTypes
    "return the dropTypes as supported by DND"

    ^ #(
	    DndUnknown      "/ 0
	    DndRawData      "/ 1
	    DndFile         "/ 2
	    DndFiles        "/ 3
	    DndText         "/ 4
	    DndDir          "/ 5
	    DndLink         "/ 6
	    DndExe          "/ 7
       )

    "Created: 6.4.1997 / 12:57:56 / cg"
    "Modified: 6.4.1997 / 13:38:52 / cg"
!

drop:aCollectionOfDropObjects inWindowID:destinationId position:destinationPoint rootPosition:rootPoint
    "drop something in some alien view.
     Returns false, if the drop could not be performed."

    "/
    "/ see, if the display supports the DND protocol ...
    "/
    (self atomIDOf:#DndProtocol) notNil ifTrue:[
	^ self
	    dndDrop:aCollectionOfDropObjects
	    inWindowID:destinationId
	    position:destinationPoint
	    rootPosition:rootPoint
    ].

    "/ add more drag&drop protocols here.

    ^ false

    "Modified: 11.4.1997 / 12:44:50 / cg"
! !

!XWorkstation methodsFor:'drawing'!

clearRectangleX:x y:y width:width height:height in:aDrawableId with:aGCId
    "clear (fill with background) a rectangle. If any coordinate is not integer, an error is triggered."

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    int w, h;

    if (ISCONNECTED
     && __isExternalAddress(aDrawableId)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height)) {
	w = __intVal(width);
	h = __intVal(height);
	/*
	 * need this check here: some servers simply dump core with bad args
	 */
	if ((w >= 0) && (h >= 0)) {
	    ENTER_XLIB();
	    XClearArea(myDpy,
			   __DrawableVal(aDrawableId),
			   __intVal(x), __intVal(y), w, h, 0);
	    LEAVE_XLIB();
	}
	RETURN ( self );
    }
%}.
    "badGC, badDrawable or coordinates not integer"
    self primitiveFailedOrClosedConnection
!

copyFromId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
    "do a bit-blt; copy bits from the rectangle defined by
     srcX/srcY and w/h from the sourceId drawable to the rectangle
     below dstX/dstY in the destId drawable. Trigger an error if any
     argument is not integer."

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    GC gc;
    Drawable source, dest;

    if (ISCONNECTED
     && __isExternalAddress(dstGCId)
     && __isExternalAddress(sourceId)
     && __isExternalAddress(destId)
     && __bothSmallInteger(w, h)
     && __bothSmallInteger(srcX, srcY)
     && __bothSmallInteger(dstX, dstY)) {
	int _sX, _sY, _w, _h, _dX, _dY;

	_sX = __intVal(srcX);
	_sY = __intVal(srcY);
	_w = __intVal(w);
	_h = __intVal(h);
	_dX = __intVal(dstX);
	_dY = __intVal(dstY);

	gc = __GCVal(dstGCId);
	source = __DrawableVal(sourceId);
	dest =   __DrawableVal(destId);
	ENTER_XLIB();
	XCopyArea(myDpy, source, dest, gc, _sX, _sY, _w, _h, _dX, _dY);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    "badGC, bad sourceDrawableId or destDrawableID
     or any non integer coordinate"

    self primitiveFailedOrClosedConnection
!

copyFromPixmapId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
    "do a bit-blt from a pix- or bitmap; copy bits from the rectangle defined by
     srcX/srcY and w/h from the sourceId drawable to the rectangle
     below dstX/dstY in the destId drawable. Trigger an error if any
     argument is not integer.
     This is basically the same as copyFromId:..., but does not generate expose events."

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    GC gc;
    Drawable source, dest;

    if (ISCONNECTED
     && __isExternalAddress(dstGCId)
     && __isExternalAddress(sourceId)
     && __isExternalAddress(destId)
     && __bothSmallInteger(w, h)
     && __bothSmallInteger(srcX, srcY)
     && __bothSmallInteger(dstX, dstY)) {
	Display *dpy = myDpy;

	gc = __GCVal(dstGCId);
	source = __DrawableVal(sourceId);
	dest =   __DrawableVal(destId);
	ENTER_XLIB();
	XSetGraphicsExposures(dpy, gc, 0);
	XCopyArea(dpy, source, dest, gc,
				__intVal(srcX), __intVal(srcY),
				__intVal(w), __intVal(h),
				__intVal(dstX), __intVal(dstY));
	XSetGraphicsExposures(dpy, gc, 1);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    "badGC, bad sourceDrawableId or destDrawableID
     or any non integer coordinate"

    self primitiveFailedOrClosedConnection
!

copyPlaneFromId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
    "do a bit-blt, but only copy the low-bit plane;
     copy bits from the rectangle defined by
     srcX/srcY and w/h from the sourceId drawable to the rectangle
     below dstX/dstY in the destId drawable. Trigger an error if any
     argument is not integer."

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    GC gc;
    Drawable source, dest;

    if (ISCONNECTED
     && __isExternalAddress(dstGCId)
     && __isExternalAddress(sourceId)
     && __isExternalAddress(destId)
     && __bothSmallInteger(w, h)
     && __bothSmallInteger(srcX, srcY)
     && __bothSmallInteger(dstX, dstY)) {
	gc = __GCVal(dstGCId);
	source = __DrawableVal(sourceId);
	dest =   __DrawableVal(destId);
	ENTER_XLIB();
	XCopyPlane(myDpy, source, dest, gc,
				 __intVal(srcX), __intVal(srcY),
				 __intVal(w), __intVal(h),
				 __intVal(dstX), __intVal(dstY), 1);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    "badGC, bad sourceDrawableId or destDrawableID
     or any non integer coordinate"

    self primitiveFailedOrClosedConnection
!

copyPlaneFromPixmapId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
    "do a bit-blt from a pix- or bitmap, but only copy the low-bit plane;
     copy bits from the rectangle defined by
     srcX/srcY and w/h from the sourceId drawable to the rectangle
     below dstX/dstY in the destId drawable. Trigger an error if any
     argument is not integer.
     This is the same as copyPlaneFromId:..., but does not generate graphics exposes"

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    GC gc;
    Drawable source, dest;

    if (ISCONNECTED
     && __isExternalAddress(dstGCId)
     && __isExternalAddress(sourceId)
     && __isExternalAddress(destId)
     && __bothSmallInteger(w, h)
     && __bothSmallInteger(srcX, srcY)
     && __bothSmallInteger(dstX, dstY)) {
	Display *dpy = myDpy;

	gc = __GCVal(dstGCId);
	source = __DrawableVal(sourceId);
	dest =   __DrawableVal(destId);
	ENTER_XLIB();
	XSetGraphicsExposures(dpy, gc, 0);
	XCopyPlane(dpy, source, dest, gc,
				 __intVal(srcX), __intVal(srcY),
				 __intVal(w), __intVal(h),
				 __intVal(dstX), __intVal(dstY), 1);
	XSetGraphicsExposures(dpy, gc, 1);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    "badGC, bad sourceDrawableId or destDrawableID
     or any non integer coordinate"

    self primitiveFailedOrClosedConnection
!

displayArcX:x y:y width:width height:height from:startAngle angle:angle in:aDrawableId with:aGCId
    "draw an arc. If any of x,y, w or h is not an integer, an error is triggered.
     The angles may be floats or integer - they are given in degrees."

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    GC gc;
    Window win;
    int w, h, angle1, angle2;
    double f;

    if (__isSmallInteger(startAngle))
	angle1 = __intVal(startAngle) * 64;
    else if (__isFloat(startAngle)) {
	f = __floatVal(startAngle);
	angle1 = f * 64;
    } else if (__isShortFloat(startAngle)) {
	f = __shortFloatVal(startAngle);
	angle1 = f * 64;
    } else goto bad;

    if (__isSmallInteger(angle))
	angle2 = __intVal(angle) * 64;
    else if (__isFloat(angle)) {
	f = __floatVal(angle);
	angle2 = f * 64;
    } else if (__isShortFloat(angle)) {
	f = __shortFloatVal(angle);
	angle2 = f * 64;
    } else goto bad;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height)) {
	win = __WindowVal(aDrawableId);
	gc = __GCVal(aGCId);
	w = __intVal(width);
	h = __intVal(height);
	/*
	 * need this check here: some servers simply dump core with bad args
	 */
	if ((w >= 0) && (h >= 0) && (angle1 >= 0) && (angle2 >= 0)) {
	    ENTER_XLIB();
	    XDrawArc(myDpy, win, gc, __intVal(x), __intVal(y),
				   w, h, angle1, angle2);
	    LEAVE_XLIB();
	}
	RETURN ( self );
    }
    bad: ;
%}.
    "badGC, badDrawable or coordinates not integer
     or angle(s) not integer or float."

    self primitiveFailedOrClosedConnection
!

displayLineFromX:x0 y:y0 toX:x1 y:y1 in:aDrawableId with:aGCId
    "draw a line. If the coordinates are not integers, an error is triggered."

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    GC gc;
    Window win;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId)
     && __bothSmallInteger(x0, y0)
     && __bothSmallInteger(x1, y1)) {
	Display *dpy = myDpy;
	int ix0, iy0, ix1, iy1;
	gc = __GCVal(aGCId);
	win = __WindowVal(aDrawableId);

	ix0 = __intVal(x0);
	iy0 = __intVal(y0);
	ix1 = __intVal(x1);
	iy1 = __intVal(y1);

	/* attention: coordinates in X are shorts and wrap; clamp here. */
	if (ix0 > 0x7FFF) ix0 = 0x7FFF;
	else if (ix0 < -0x8000) ix0 = -0x8000;
	if (iy0 > 0x7FFF) iy0 = 0x7FFF;
	else if (iy0 < -0x8000) iy0 = -0x8000;
	if (ix1 > 0x7FFF) ix1 = 0x7FFF;
	else if (ix1 < -0x8000) ix1 = -0x8000;
	if (iy1 > 0x7FFF) iy1 = 0x7FFF;
	else if (iy1 < -0x8000) iy1 = -0x8000;

	ENTER_XLIB();
	if ((ix0 == ix1) && (iy0 == iy1)) {
	    /* little bit shorter X-lib message (better with slow connections...) */
	    XDrawPoint(dpy, win, gc, ix0, iy0);
	} else {
	    XDrawLine(dpy, win, gc, ix0, iy0, ix1, iy1);
	}
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    "badGC, badDrawable or coordinates not integer"
    self primitiveFailedOrClosedConnection
!

displayLinesFromX:startX step:stepX yValues:yValues scaleY:scaleY transY:transY in:aDrawableId with:aGCId
    "draw a polygon starting at x; the y values derives from the collection yValues.
     The associated x is a multiple of step. Each y value will be scaled and translated
    "

    <context: #return>

    |noY|

    (noY := yValues size) < 2 ifTrue:[
	^ self
    ].

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{
    OBJ      yA, t;
    int      i, num;
    float    y, x, sY, tY, step;
    GC       gc;
    XPoint * points;
    XPoint   qPoints[200];
    int      mustFree = 0;

    Window win;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId) ) {
	gc = __GCVal(aGCId);
	win = __WindowVal(aDrawableId);

	if( __isSmallInteger(scaleY) )
	    sY = (float) __intVal( scaleY );
	else if (__isFloat(scaleY))
	    sY = __floatVal( scaleY );
	else if (__isShortFloat(scaleY))
	    sY = __shortFloatVal( scaleY );
	else {
	    t = __SSEND0(scaleY, @symbol(asFloat), 0);
	    if (! __isFloat(t)) goto fail;
	    sY = __floatVal( t );
	}

	if( __isSmallInteger(transY) )
	    tY = (float) __intVal( transY );
	else if (__isFloat(transY))
	    tY = __floatVal( transY );
	else if (__isShortFloat(transY))
	    tY = __shortFloatVal( transY );
	else {
	    t = __SSEND0(transY, @symbol(asFloat), 0);
	    if (! __isFloat(t)) goto fail;
	    tY = __floatVal( t );
	}

	if( __isSmallInteger(startX) )
	    x = (float) __intVal( startX );
	else if (__isFloat(startX))
	    x = __floatVal( startX );
	else if (__isShortFloat(startX))
	    x = __shortFloatVal( startX );
	else {
	    t = __SSEND0(startX, @symbol(asFloat), 0);
	    if (! __isFloat(t)) goto fail;
	    x = __floatVal( t );
	}

	if( __isSmallInteger(stepX) )
	    step = (float) __intVal( stepX );
	else if (__isFloat(stepX))
	    step = __floatVal( stepX );
	else if (__isShortFloat(stepX))
	    step = __shortFloatVal( stepX );
	else {
	    t = __SSEND0(stepX, @symbol(asFloat), 0);
	    if (! __isFloat(t)) goto fail;
	    step = __floatVal( t );
	}

	num = __intVal( noY );
	if( num > 200 ) {
	    if( ! (points = (XPoint *) malloc ( sizeof(XPoint) * num )) )
		goto fail;
	    mustFree = 1;
	} else {
	    points = qPoints;
	}
	for( i = 0; i < num; ++i ) {
	    int px, py;

	    yA  = __AT_(yValues, __MKSMALLINT(i+1) );

	    if( __isFloat(yA) )
		y = __floatVal( yA );
	    else if( __isSmallInteger(yA) )
		y = (float) __intVal( yA );
	    else if( __isShortFloat( yA) )
		y = __shortFloatVal( yA );
	    else {
		t = __SSEND0(yA, @symbol(asFloat), 0);
		if (! __isFloat(t)) goto fail;
		y = __floatVal( t );
	    }

	    px = (int) (x + 0.5);
	    py = (int) ((y * sY) + tY + 0.5);

	    /* attention: coordinates in X are shorts and wrap; clamp here. */
	    if (px > 0x7FFF) px = 0x7FFF;
	    else if (px < -0x8000) px = -0x8000;
	    if (py > 0x7FFF) py = 0x7FFF;
	    else if (py < -0x8000) py = -0x8000;

	    points[i].x = px;
	    points[i].y = py;
	    x = x + step;
	}

	ENTER_XLIB();
	XDrawLines(myDpy, win, gc, points, num, CoordModeOrigin);
	LEAVE_XLIB();

	if( mustFree ) {
	    free( points );
	}
	RETURN ( self );
    }

fail:
    if( mustFree )
	free( points );
%}.
    ^ super displayLinesFromX:startX step:stepX yValues:yValues scaleY:scaleY transY:transY in:aDrawableId with:aGCId

    "Modified: / 13.6.1998 / 13:51:39 / cg"
!

displayPointX:x y:y in:aDrawableId with:aGCId
    "draw a point. If x/y are not integers, an error is triggered."

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    GC gc;
    Window win;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId)
     && __bothSmallInteger(x, y)) {
	int px, py;

	gc = __GCVal(aGCId);
	win = __WindowVal(aDrawableId);
	px = __intVal(x);
	py = __intVal(y);
	if (px > 0x7FFF) px = 0x7FFF;
	else if (px < -0x8000) px = -0x8000;
	if (py > 0x7FFF) py = 0x7FFF;
	else if (py < -0x8000) py = -0x8000;
	ENTER_XLIB();
	XDrawPoint(myDpy, win, gc, px, py);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    "badGC, badDrawable or x/y not integer"
    self primitiveFailedOrClosedConnection
!

displayPolygon:aPolygon in:aDrawableId with:aGCId
    "draw a polygon, the argument aPolygon is a Collection of individual points, which
     define the polygon.
     If any coordinate is not integer, an error is triggered."

    <context: #return>

    |numberOfPoints newPoints|

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
    numberOfPoints := aPolygon size.
%{
    GC gc;
    Window win;
    OBJ point, x, y;
    int i, num;
    XPoint *points;
    XPoint qPoints[100];
    int mustFree = 0;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId)
     && __isSmallInteger(numberOfPoints)) {
	gc = __GCVal(aGCId);
	win = __WindowVal(aDrawableId);
	num = __intVal(numberOfPoints);
	/*
	 * avoid a (slow) malloc, if the number of points is small
	 */
	if (num > 100) {
	    points = (XPoint *)malloc(sizeof(XPoint) * num);
	    if (! points) goto fail;
	    mustFree = 1;
	} else
	    points = qPoints;

	for (i=0; i<num; i++) {
	    int px, py;

	    point = __AT_(aPolygon, __MKSMALLINT(i+1));
	    if (! __isPoint(point)) goto fail;
	    x = _point_X(point);
	    y = _point_Y(point);
	    if (! __bothSmallInteger(x, y))
		goto fail;

	    px = __intVal(x);
	    py = __intVal(y);

	    /* attention: coordinates in X are shorts and wrap; clamp here. */
	    if (px > 0x7FFF) px = 0x7FFF;
	    else if (px < -0x8000) px = -0x8000;
	    if (py > 0x7FFF) py = 0x7FFF;
	    else if (py < -0x8000) py = -0x8000;

	    points[i].x = px;
	    points[i].y = py;
	}

	ENTER_XLIB();
	XDrawLines(myDpy, win, gc, points, num, CoordModeOrigin);
	LEAVE_XLIB();

	if (mustFree)
	    free(points);
	RETURN ( self );
    }
fail: ;
    if (mustFree)
	free(points);
%}.
    "badGC, badDrawable or coordinates not integer"
    self primitiveFailedOrClosedConnection
!

displayRectangleX:x y:y width:width height:height in:aDrawableId with:aGCId
    "draw a rectangle. If the coordinates are not integers, an error is triggered."

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    GC gc;
    Window win;
    int w, h;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height)) {
	int px, py;

	gc = __GCVal(aGCId);
	win = __WindowVal(aDrawableId);
	w = __intVal(width);
	h = __intVal(height);

	/*
	 * need this check here: some servers simply dump core with bad args
	 */
	if ((w >= 0) && (h >= 0)) {
	    px = __intVal(x);
	    py = __intVal(y);

	    /* attention: coordinates in X are shorts and wrap; clamp here. */
	    if (px > 0x7FFF) px = 0x7FFF;
	    else if (px < -0x8000) px = -0x8000;
	    if (py > 0x7FFF) py = 0x7FFF;
	    else if (py < -0x8000) py = -0x8000;

	    ENTER_XLIB();
	    XDrawRectangle(myDpy, win, gc, px, py, w, h);
	    LEAVE_XLIB();
	}
	RETURN ( self );
    }
%}.
    "badGC, badDrawable or coordinates not integer"
    self primitiveFailedOrClosedConnection
!

displayString:aString from:index1 to:index2 x:x y:y in:aDrawableId with:aGCId opaque:opaque
    "draw a sub-string - if opaque is false, draw foreground only; otherwise, draw both
     foreground and background characters.
     If the coordinates are not integers, an error is triggered."

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    GC gc;
    Window win;
    char *cp;
    int  i1, i2, l, n;
#   define NLOCALBUFFER 200
    XChar2b xlatebuffer[NLOCALBUFFER];
    int nInstBytes;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId)
     && __isNonNilObject(aString)
     && __bothSmallInteger(index1, index2)
     && __bothSmallInteger(x, y)) {
	int lMax = __intVal(@global(MaxStringLength));
	Display *dpy = myDpy;
	gc = __GCVal(aGCId);
	win = __WindowVal(aDrawableId);

	i1 = __intVal(index1) - 1;
	if (i1 >= 0) {
	    OBJ cls;

	    i2 = __intVal(index2) - 1;
	    if (i2 < i1) {
		RETURN (self);
	    }
	    cp = (char *) __stringVal(aString);
	    l = i2 - i1 + 1;

	    if (__isStringLike(aString)) {
		n = __stringSize(aString);
		if (i2 < n) {
		    cp += i1;
		    if (l > lMax) l = lMax;
		    ENTER_XLIB();
		    if (opaque == true)
			XDrawImageString(dpy, win, gc, __intVal(x), __intVal(y), cp, l);
		    else
			XDrawString(dpy, win, gc, __intVal(x), __intVal(y), cp, l);
		    LEAVE_XLIB();
		    RETURN ( self );
		}
	    }

	    cls = __qClass(aString);
	    nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	    cp += nInstBytes;

	    if (__isBytes(aString)) {
		n = __byteArraySize(aString) - nInstBytes - 1;

		if (i2 < n) {
		    cp += i1;
		    if (l > lMax) l = lMax;
		    ENTER_XLIB();
		    if (opaque == true)
			XDrawImageString(dpy, win, gc, __intVal(x), __intVal(y), cp, l);
		    else
			XDrawString(dpy, win, gc, __intVal(x), __intVal(y), cp, l);
		    LEAVE_XLIB();
		    RETURN ( self );
		}
	    }

	    /* TWOBYTESTRINGS */
	    if (__isWords(aString)) {
		n = (__byteArraySize(aString) - nInstBytes) / 2;
		if (i2 < n) {
		    union {
			char b[2];
			unsigned short s;
		    } u;
		    int i;
		    XChar2b *cp2 = (XChar2b *)0;
		    int mustFree = 0;

		    cp += (i1 * 2);
		    if (l > lMax) l = lMax;

#if defined(MSBFIRST) || defined(__MSBFIRST)
		    /*
		     * chars already in correct order
		     */
#else
# if ! (defined(LSBFIRST) || defined(__LSBFIRST))
		    /*
		     * ST/X TwoByteStrings store the asciiValue in native byteOrder;
		     * X expects them MSB first
		     * convert as required
		     */
		    u.s = 0x1234;
		    if (u.b[0] != 0x12)
# endif
		    {
			if (l <= NLOCALBUFFER) {
			    cp2 = xlatebuffer;
			} else {
			    cp2 = (XChar2b *)(malloc(l * 2));
			    mustFree = 1;
			}
			for (i=0; i<l; i++) {
			    cp2[i].byte1 = (((XChar2b *)cp)[i]).byte2;
			    cp2[i].byte2 = (((XChar2b *)cp)[i]).byte1;
			}
			cp = (char *) cp2;
		    }
#endif
		    ENTER_XLIB();
		    if (opaque == true)
			XDrawImageString16(dpy, win, gc, __intVal(x), __intVal(y), (XChar2b *)cp, l);
		    else
			XDrawString16(dpy, win, gc, __intVal(x), __intVal(y), (XChar2b *)cp, l);
		    LEAVE_XLIB();

		    if (mustFree) {
			free(cp2);
		    }

		    RETURN ( self );
		}
	    }

	    /* FOURBYTESTRINGS */
	    if (__isLongs(aString)) {
		n = (__byteArraySize(aString) - nInstBytes) / 4;
		if (i2 < n) {
		    union {
			char b[2];
			unsigned short s;
		    } u;
		    int i;
		    XChar2b *cp2 = (XChar2b *)0;
		    int32 *ip;
		    int mustFree = 0;

		    cp += (i1 * 4);
		    if (l > lMax) l = lMax;

		    /*
		     * all codePoints <= 16rFFFF are draw; above 16bit range are drawn as 16rFFFF.
		     */
		    if (l <= NLOCALBUFFER) {
			cp2 = xlatebuffer;
		    } else {
			cp2 = (XChar2b *)(malloc(l * 2));
			mustFree = 1;
		    }
		    for (i=0; i<l; i++) {
			int32 codePoint = ((int32 *)cp)[i];

			if (codePoint > 0xFFFF) {
			    codePoint = 0xFFFF;
			}
			cp2[i].byte1 = (codePoint >> 8) & 0xFF;
			cp2[i].byte2 = codePoint & 0xFF;
		    }
		    cp = (char *) cp2;

		    ENTER_XLIB();
		    if (opaque == true)
			XDrawImageString16(dpy, win, gc, __intVal(x), __intVal(y), (XChar2b *)cp, l);
		    else
			XDrawString16(dpy, win, gc, __intVal(x), __intVal(y), (XChar2b *)cp, l);
		    LEAVE_XLIB();

		    if (mustFree) {
			free(cp2);
		    }

		    RETURN ( self );
		}
	    }
	}
    }
#undef NLOCALBUFFER
%}.
    (aString isString and:[aString bitsPerCharacter > 16]) ifTrue:[
	self displayString:(TwoByteString new:aString size withAll:16rFFFF asCharacter)
	     from:index1 to:index2 x:x y:y in:aDrawableId with:aGCId opaque:opaque.
	^ self.
    ].

    "x/y not integer, badGC or drawable, or not a string"
    self primitiveFailedOrClosedConnection
!

displayString:aString x:x y:y in:aDrawableId with:aGCId opaque:opaque
    "draw a string - if opaque is false, draw foreground only; otherwise, draw both
     foreground and background characters.
     If the coordinates are not integers, an error is triggered."

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    GC gc;
    Window win;
    char *cp;
    int n;
    OBJ cls;
#   define NLOCALBUFFER 200
    XChar2b xlatebuffer[NLOCALBUFFER];
    int nInstBytes;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId)
     && __isNonNilObject(aString)
     && __bothSmallInteger(x, y)) {
	int lMax = __intVal(@global(MaxStringLength));
	Display *dpy = myDpy;
	gc = __GCVal(aGCId);
	win = __WindowVal(aDrawableId);

	cp = (char *) __stringVal(aString);

	if (__isStringLike(aString)) {
	    n = __stringSize(aString);
	    if (n > lMax) n = lMax;
	    ENTER_XLIB();
	    if (opaque == true)
		XDrawImageString(dpy, win, gc, __intVal(x), __intVal(y), cp, n);
	    else
		XDrawString(dpy, win, gc, __intVal(x), __intVal(y), cp, n);
	    LEAVE_XLIB();
	    RETURN ( self );
	}

	cls = __qClass(aString);
	nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	cp += nInstBytes;

	if (__isBytes(aString)) {
	    n = __byteArraySize(aString) - nInstBytes - 1;

	    if (n > lMax) n = lMax;
	    ENTER_XLIB();
	    if (opaque == true)
		XDrawImageString(dpy, win, gc, __intVal(x), __intVal(y), cp, n);
	    else
		XDrawString(dpy, win, gc, __intVal(x), __intVal(y), cp, n);
	    LEAVE_XLIB();
	    RETURN ( self );
	}

	/* TWOBYTESTRINGS */
	if (__isWords(aString)) {
	    union {
		char b[2];
		unsigned short s;
	    } u;
	    int i;
	    XChar2b *cp2;
	    int mustFree = 0;

	    n = (__byteArraySize(aString) - nInstBytes) / 2;
	    if (n > lMax) n = lMax;

#if defined(MSBFIRST) || defined(__MSBFIRST)
	    /*
	     * chars already in correct order
	     */
#else
# if ! (defined(LSBFIRST) || defined(__LSBFIRST))
	    /*
	     * ST/X TwoByteStrings store the asciiValue in native byteOrder;
	     * X expects them MSB first
	     * convert as required
	     */
	    u.s = 0x1234;
	    if (u.b[0] != 0x12)
# endif
	    {
		if (n <= NLOCALBUFFER) {
		    cp2 = xlatebuffer;
		} else {
		    cp2 = (XChar2b *)(malloc(n * 2));
		    mustFree = 1;
		}

		for (i=0; i<n; i++) {
		    cp2[i].byte1 = (((XChar2b *)cp)[i]).byte2;
		    cp2[i].byte2 = (((XChar2b *)cp)[i]).byte1;
		}
		cp = (char *) cp2;
	    }
#endif
	    ENTER_XLIB();
	    if (opaque == true)
		XDrawImageString16(dpy, win, gc, __intVal(x), __intVal(y), (XChar2b *)cp, n);
	    else
		XDrawString16(dpy, win, gc, __intVal(x), __intVal(y), (XChar2b *)cp, n);
	    LEAVE_XLIB();

	    if (mustFree) {
		free(cp2);
	    }

	    RETURN ( self );
	}
    }
#undef NLOCALBUFFER
%}.
    ^ super displayString:aString x:x y:y in:aDrawableId with:aGCId opaque:opaque
!

drawBits:givenBits bitsPerPixel:bitsPerPixel depth:imageDepth padding:givenPadding
	width:imageWidth height:imageHeight
	x:srcx y:srcy
	into:aDrawableId
	x:dstx y:dsty
	width:w height:h
	with:aGCId

    "draw a bitImage which has depth id, width iw and height ih into
     the drawable. draw a region of w/h pixels from srcx/srcy to dstx/dsty.
     Individual source pixels have bitsPerPixel bits, allowing to draw
     depth and pixel-units to be different.
     It has to be checked elsewhere, that the server can do it with the given
     depth - otherwise, primitive failure will be signalled.
     Also it is assumed, that the colormap is setup correctly and the
     colors are allocated - otherwise the colors may be wrong."

    |fmt padding bits wantedPadding|

    padding := givenPadding.
    bits := givenBits.

    "/ the XF86_VGA16 server seems to report an error when we pass it an
    "/ 8-bit padded image. (it wants it 32bit padded).
    "/ as a workaround, repad it here (although, the server and/or Xlib should
    "/ care for that.

    ((imageDepth == 4) and:[depth == 4]) ifTrue:[
	fmt := self supportedImageFormatForDepth:4.
	fmt isNil ifTrue:[
	    self primitiveFailed. "/ cannot represent this image
	    ^ nil
	].
	wantedPadding := fmt at:#padding.
	wantedPadding > givenPadding ifTrue:[
	    bits := self
			    repadBits:givenBits
			    width:imageWidth
			    height:imageHeight
			    depth:imageDepth
			    from:givenPadding
			    to:wantedPadding.
	    padding := wantedPadding.
	]
    ].


    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
    "
     sorry; I had to separate it into 2 methods, since XPutImage needs
     an unlimited stack, and thus cannot send primitiveFailed
    "
    (self
	primDrawBits:bits
	bitsPerPixel:bitsPerPixel
	depth:imageDepth
	msb:true
	padding:padding
	width:imageWidth height:imageHeight
	x:srcx y:srcy
	into:aDrawableId
	x:dstx y:dsty
	width:w height:h
	with:aGCId)
    ifFalse:[
	"
	 also happens, if a segmentation violation occurs in the
	 XPutImage ...
	"
	self primitiveFailedOrClosedConnection
    ].
!

fillArcX:x y:y width:width height:height from:startAngle angle:angle
	       in:aDrawableId with:aGCId
    "fill an arc. If any coordinate is not integer, an error is triggered.
     The angles may be floats or integer - they are given in degrees."

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    GC gc;
    Window win;
    int w, h, angle1, angle2;
    double f;

    if (__isSmallInteger(startAngle))
	angle1 = __intVal(startAngle) * 64;
    else if (__isFloat(startAngle)) {
	f = __floatVal(startAngle);
	angle1 = f * 64;
    } else if (__isShortFloat(startAngle)) {
	f = __shortFloatVal(startAngle);
	angle1 = f * 64;
    } else goto bad;

    if (__isSmallInteger(angle))
	angle2 = __intVal(angle) * 64;
    else if (__isFloat(angle)) {
	f = __floatVal(angle);
	angle2 = f * 64;
    } else if (__isShortFloat(angle)) {
	f = __shortFloatVal(angle);
	angle2 = f * 64;
    } else goto bad;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height)) {
	gc = __GCVal(aGCId);
	win = __WindowVal(aDrawableId);
	w = __intVal(width);
	h = __intVal(height);
	/*
	 * need this check here: some servers simply dump core with bad args
	 */
	if ((w >= 0) && (h >= 0) && (angle1 >= 0) && (angle2 >= 0)) {
	    ENTER_XLIB();
	    XFillArc(myDpy, win, gc, __intVal(x), __intVal(y),
				   w, h, angle1, angle2);
	    LEAVE_XLIB();
	}
	RETURN ( self );
    }
    bad: ;
%}.
    "badGC, badDrawable or coordinates not integer
     or non float angle(s)"

    self primitiveFailedOrClosedConnection
!

fillPolygon:aPolygon in:aDrawableId with:aGCId
    "fill a polygon given by its points.
     If any coordinate is not integer, an error is triggered."

    <context: #return>

    |numberOfPoints|

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
    numberOfPoints := aPolygon size.
%{
    GC gc;
    Window win;
    OBJ point, x, y;
    int i, num;
    XPoint *points;
    XPoint qPoints[100];
    int mustFree = 0;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId)
     && __isSmallInteger(numberOfPoints)) {
	gc = __GCVal(aGCId);
	win = __WindowVal(aDrawableId);
	num = __intVal(numberOfPoints);
	if (num < 3) {
	    RETURN ( self );
	}
	/*
	 * avoid (slow) malloc, if not many points
	 */
	if (num > 100) {
	    points = (XPoint *) malloc(sizeof(XPoint) * num);
	    if (! points) goto fail;
	    mustFree = 1;
	} else
	    points = qPoints;
	for (i=0; i<num; i++) {
	    point = __AT_(aPolygon, __MKSMALLINT(i+1));
	    if (! __isPoint(point)) goto fail;
	    x = _point_X(point);
	    y = _point_Y(point);
	    if (! __bothSmallInteger(x, y))
		goto fail;
	    points[i].x = __intVal(x);
	    points[i].y = __intVal(y);
	}
	ENTER_XLIB();
	XFillPolygon(myDpy, win, gc, points, num, Complex, CoordModeOrigin);
	LEAVE_XLIB();
	if (mustFree)
	    free(points);
	RETURN ( self );

fail: ;
	if (mustFree)
	    free(points);
    }
%}.
    "badGC, badDrawable or coordinates not integer"
    self primitiveFailedOrClosedConnection
!

fillRectangleX:x y:y width:width height:height in:aDrawableId with:aGCId
    "fill a rectangle. If any coordinate is not integer, an error is triggered."

    <context: #return>

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
%{

    int w, h;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height)) {
	w = __intVal(width);
	h = __intVal(height);
	/*
	 * need this check here: some servers simply dump core with bad args
	 */
	if ((w >= 0) && (h >= 0)) {
	    ENTER_XLIB();
	    XFillRectangle(myDpy,
			   __DrawableVal(aDrawableId), __GCVal(aGCId),
			   __intVal(x), __intVal(y), w, h);
	    LEAVE_XLIB();
	}
	RETURN ( self );
    }
%}.
    "badGC, badDrawable or coordinates not integer"
    self primitiveFailedOrClosedConnection
!

primDrawBits:imageBits bitsPerPixel:bitsPerPixel depth:imageDepth msb:msb masks:maskArray padding:bitPadding
			     extent:imageExtent sourceOrigin:srcOrg
			       into:aDrawableId
		  destinationOrigin:dstOrg extent:dstExtent
			       with:aGCId

    <context: #return>

    |imageWidth imageHeight rm gm bm srcx srcy dstx dsty w h|

    imageWidth := imageExtent x.
    imageHeight := imageExtent y.
    rm := maskArray at:1.
    gm := maskArray at:2.
    bm := maskArray at:3.
    srcx := srcOrg x.
    srcy := srcOrg y.
    dstx := dstOrg x.
    dsty := dstOrg y.
    w := dstExtent x.
    h := dstExtent y.

    "since XPutImage may allocate huge amount of stack space
     (some implementations use alloca), this must run with unlimited stack."

%{  /* UNLIMITEDSTACK */

    /*
     * need unlimited stack, since some Xlibs do a huge alloca in
     * XPutImage
     */
    GC gc;
    Window win;
    XImage image;
    int imgWdth;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId)
     && __bothSmallInteger(srcx, srcy)
     && __bothSmallInteger(dstx, dsty)
     && __bothSmallInteger(w, h)
     && __bothSmallInteger(imageWidth, imageHeight)
     && __bothSmallInteger(imageDepth, bitsPerPixel)
     && __isSmallInteger(bitPadding)
     && __bothSmallInteger(rm, gm)
     && __isSmallInteger(bm)
     && __isByteArrayLike(imageBits)) {
	Display *dpy = myDpy;
	int pad = __intVal(bitPadding);

	gc = __GCVal(aGCId);
	win = __WindowVal(aDrawableId);
	if (! gc || !win)
	    goto fail;
#ifdef ARGDEBUG
	console_printf("args ok\n");
#endif
	image.data = (char *)__ByteArrayInstPtr(imageBits)->ba_element;
	image.width = imgWdth = __intVal(imageWidth);
	image.height = __intVal(imageHeight);
	image.xoffset = 0;
	image.format = ZPixmap;
	image.byte_order = (msb == true) ? MSBFirst : LSBFirst;
	image.bitmap_unit = 8;
	image.bitmap_bit_order = MSBFirst;
	image.bitmap_pad = pad;
	image.depth = __intVal(imageDepth);
	image.bits_per_pixel = __intVal(bitsPerPixel);
	image.red_mask = __intVal(rm);
	image.green_mask = __intVal(gm);
	image.blue_mask = __intVal(bm);

	image.bytes_per_line = ((((imgWdth * image.bits_per_pixel) + (pad-1)) / pad) * pad) / 8;

	switch (image.bits_per_pixel) {
	    case 1:
	    case 2:
	    case 4:
	    case 8:
	    case 16:
	    case 24:
	    case 32:
		break;

	    default:
#ifdef ARGDEBUG
		console_printf("bits_per_pixel=%d\n",image.bits_per_pixel);
#endif
		goto fail;
	}

	/* ENTER_XLIB(); */
	XPutImage(dpy, win, gc, &image, __intVal(srcx), __intVal(srcy),
					__intVal(dstx), __intVal(dsty),
					__intVal(w), __intVal(h));
	/* LEAVE_XLIB(); */

	RETURN ( true );
    }
#ifdef ARGDEBUG
    if (!! __isExternalAddress(aGCId)) console_printf("GC\n");
    if (!! __isExternalAddress(aDrawableId)) console_printf("aDrawableId\n");
    if (!! __isSmallInteger(srcx)) console_printf("srcx\n");
    if (!! __isSmallInteger(srcy)) console_printf("srcy\n");
    if (!! __isSmallInteger(dstx)) console_printf("dstx\n");
    if (!! __isSmallInteger(dsty)) console_printf("dsty\n");
    if (!! __isSmallInteger(w)) console_printf("w\n");
    if (!! __isSmallInteger(h)) console_printf("h\n");
    if (!! __isSmallInteger(imageWidth)) console_printf("imageWidth\n");
    if (!! __isSmallInteger(imageHeight)) console_printf("imageHeight\n");
    if (!! __isSmallInteger(imageDepth)) console_printf("imageDepth\n");
    if (!! __isSmallInteger(bitsPerPixel)) console_printf("bitsPerPixel\n");
    if (!! __isByteArrayLike(imageBits)) console_printf("imageBits\n");
#endif

fail: ;
%}
.
    ^ false
!

primDrawBits:imageBits bitsPerPixel:bitsPerPixel depth:imageDepth msb:msb padding:bitPadding
			      width:imageWidth height:imageHeight
				  x:srcx y:srcy
			       into:aDrawableId
				  x:dstx y:dsty
			      width:w height:h
			       with:aGCId

    <context: #return>

    "since XPutImage may allocate huge amount of stack space
     (some implementations use alloca), this must run with unlimited stack."

%{  /* UNLIMITEDSTACK */

    /*
     * need unlimited stack, since some Xlibs do a huge alloca in
     * XPutImage
     */
    GC gc;
    Window win;
    XImage image;
    int imgWdth;

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __isExternalAddress(aDrawableId)
     && __bothSmallInteger(srcx, srcy)
     && __bothSmallInteger(dstx, dsty)
     && __bothSmallInteger(w, h)
     && __bothSmallInteger(imageWidth, imageHeight)
     && __bothSmallInteger(imageDepth, bitsPerPixel)
     && __isSmallInteger(bitPadding)
     && __isByteArrayLike(imageBits)) {
	Display *dpy = myDpy;
	int pad = __intVal(bitPadding);

	gc = __GCVal(aGCId);
	win = __WindowVal(aDrawableId);
	if (! gc || !win)
	    goto fail;
#ifdef ARGDEBUG
	console_printf("args ok\n");
#endif
	image.data = (char *)__ByteArrayInstPtr(imageBits)->ba_element;
	image.width = imgWdth = __intVal(imageWidth);
	image.height = __intVal(imageHeight);
	image.xoffset = 0;
	image.format = ZPixmap;
	image.byte_order = (msb == true) ? MSBFirst : LSBFirst;
	image.bitmap_unit = 8;
	image.bitmap_bit_order = MSBFirst;
	image.bitmap_pad = pad;
	image.depth = __intVal(imageDepth);
	image.bits_per_pixel = __intVal(bitsPerPixel);

	/*
	image.bytes_per_line = ((((imgWdth * image.depth) + (pad-1)) / pad) * pad) / 8;
	*/
	image.bytes_per_line = ((((imgWdth * image.bits_per_pixel) + (pad-1)) / pad) * pad) / 8;

	switch (image.bits_per_pixel) {
	    case 1:
	    case 2:
	    case 4:
	    case 8:
	    case 16:
	    case 24:
	    case 32:
		break;

	    default:
#ifdef ARGDEBUG
		console_printf("bits_per_pixel=%d\n",image.bits_per_pixel);
#endif
		goto fail;
	}

	image.red_mask = 0xFFFF;
	image.green_mask = 0xFFFF;
	image.blue_mask = 0xFFFF;

	/* ENTER_XLIB(); */
	XPutImage(dpy, win, gc, &image, __intVal(srcx), __intVal(srcy),
					__intVal(dstx), __intVal(dsty),
					__intVal(w), __intVal(h));
	/* LEAVE_XLIB(); */

	RETURN ( true );
    }
#ifdef ARGDEBUG
    if (!! __isExternalAddress(aGCId)) console_printf("GC\n");
    if (!! __isExternalAddress(aDrawableId)) console_printf("aDrawableId\n");
    if (!! __isSmallInteger(srcx)) console_printf("srcx\n");
    if (!! __isSmallInteger(srcy)) console_printf("srcy\n");
    if (!! __isSmallInteger(dstx)) console_printf("dstx\n");
    if (!! __isSmallInteger(dsty)) console_printf("dsty\n");
    if (!! __isSmallInteger(w)) console_printf("w\n");
    if (!! __isSmallInteger(h)) console_printf("h\n");
    if (!! __isSmallInteger(imageWidth)) console_printf("imageWidth\n");
    if (!! __isSmallInteger(imageHeight)) console_printf("imageHeight\n");
    if (!! __isSmallInteger(imageDepth)) console_printf("imageDepth\n");
    if (!! __isSmallInteger(bitsPerPixel)) console_printf("bitsPerPixel\n");
    if (!! __isByteArrayLike(imageBits)) console_printf("imageBits\n");
#endif

fail: ;
%}
.
    ^ false
! !

!XWorkstation methodsFor:'event forwarding'!

buttonMotion:view state:state x:x y:y rootX:rX rootY:rY time:time
    "forward a buttonMotion event for some view"

    lastEventTime := time.
    self buttonMotion:state x:x y:y view:view
!

buttonPress:view button:button state:state x:x y:y rootX:rX rootY:rY time:time
    "forward a buttonPress event for some view"

    |logicalButton|

    lastEventTime := time.
    altDown := state bitTest:altModifierMask.
    metaDown := state bitTest:metaModifierMask.
    shiftDown := state bitTest:(self shiftModifierMask).
    ctrlDown := state bitTest:(self ctrlModifierMask).

    eventRootX := rX.
    eventRootY := rY.

    "/ physical to logical button translation
    logicalButton := buttonTranslation at:button ifAbsent:button.

    "/ special for mouse-wheel implementation
    (logicalButton == #wheelFwd or:[logicalButton == #wheelBwd]) ifTrue:[
      self mouseWheelMotion:state x:x y:y amount:(logicalButton == #wheelFwd ifTrue:[10] ifFalse:[-10]) deltaTime:10 view:view.
      ^ self.
    ].

    logicalButton isInteger ifTrue:[
	buttonsPressed := buttonsPressed bitOr:(1 bitShift:logicalButton-1).
    ].

    (multiClickTimeDelta notNil and:[lastButtonPressTime notNil]) ifTrue:[
	time < (lastButtonPressTime + multiClickTimeDelta) ifTrue:[
	    lastButtonPressTime := time.
	    self buttonMultiPress:logicalButton x:x y:y view:view.
	    ^ self.
	].
    ].
    lastButtonPressTime := time.

    view isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    logicalButton == 1 ifTrue:[
	activateOnClick == true ifTrue:[
	    "/ don't raise above an active popup view.
	    (activeKeyboardGrab isNil and:[activePointerGrab isNil]) ifTrue:[
		view topView raise.
	    ]
	].
    ].
    super buttonPress:logicalButton x:x y:y view:view
!

buttonRelease:view button:button state:state x:x y:y rootX:rX rootY:rY time:time
    "forward a buttonPress event for some view"

    |logicalButton|

    lastEventTime := time.
    altDown := state bitTest:altModifierMask.
    metaDown := state bitTest:metaModifierMask.
    shiftDown := state bitTest:(self shiftModifierMask).
    ctrlDown := state bitTest:(self ctrlModifierMask).

    eventRootX := rX.
    eventRootY := rY.

    "/ physical to logical button translation
    logicalButton := buttonTranslation at:button ifAbsent:button.

    "/ special for HPs mouse-wheel implementation
    (logicalButton == #wheelFwd or:[logicalButton == #wheelBwd]) ifTrue:[
      ^ self
    ].

    logicalButton isInteger ifTrue:[
	buttonsPressed := buttonsPressed bitClear:(1 bitShift:logicalButton-1).
    ].
    self buttonRelease:logicalButton x:x y:y view:view
!

clientMessage:targetView type:typeAtom format:format data:data
    |sensor|

    targetView isNil ifTrue:[
	"targetView is gone? Anyway, cannot do anything with this event..."
	^ self.
    ].

    "DND drag&drop protocol"
    (format == 32 and:[typeAtom == (self atomIDOf:#DndProtocol)]) ifTrue:[
	self dndMessage:nil data:data view:targetView.
	^ self.
    ].

    sensor := targetView sensor.
    "not posted, if there is no sensor ..."
    sensor notNil ifTrue:[
	sensor clientMessage:typeAtom format:format eventData:data view:targetView
    ].

    "Created: 4.4.1997 / 17:49:26 / cg"
!

configure:view relativeTo:anotherViewId x:x y:y width:w height:h borderWidth:borderWidth above:aboveViewId overrideRedirect:overrideBool
    "forward a size-change event for some view"

"/    anotherViewId notNil ifTrue:[
"/        |parentViewOrSelf|
"/        parentViewOrSelf := self viewFromId:anotherViewId.
"/        parentViewOrSelf notNil ifTrue:[
"/        ].
"/     ].
    self configureX:x y:y width:w height:h view:view.
    aboveViewId notNil ifTrue:[
	|aboveView|
	aboveView := self viewFromId:aboveViewId.
	aboveView notNil ifTrue:[
	    "view is now on the top of the window stack"
	    self coveredBy:view view:aboveView.
	].
     ].
!

createWindow:view x:x y:y width:w height:h

    view isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    view sensor createWindow:view x:x y:y width:w height:h

    "Created: / 30-05-2011 / 16:05:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-05-2011 / 19:00:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dndMessage:event data:data view:targetView
    "handle a drag&drop protocol message"

    |sensor property dropType dropValue names i1 i2 propertyType|

    dropType := data doubleWordAt:1.

    "/ see def's in DragAndDropTypes.h
    dropType := (self dndDropTypes) at:dropType+1 ifAbsent:#DndNotDnd.

    property := self
	getProperty:(self atomIDOf:#DndSelection)
	from:rootId
	delete:false.

    propertyType := property key.
    dropValue := property value.

    "/ preconvert into a collection
    "/ of fileNames, string or byteArray
    "/ Notice: we do not yet convert into dropObjects
    "/ here, to allow arbitrary data to be handled by
    "/ redefined dropMessage methods in applications.
    "/ Conversion is done for some well known types
    "/ in the default dropMessage handling of SimpleView.

    dropType == #DndFiles ifTrue:[
	"/ actually, a list of fileNames
	propertyType ~~ stringAtom ifTrue:[
	    Logger info:'expected a string propertyValue in drop'.
	    ^ self
	].

	names := OrderedCollection new.
	i1 := 1.
	[i1 ~~ 0] whileTrue:[
	    i2 := dropValue indexOf:(Character value:0) startingAt:i1.
	    i2 ~~ 0 ifTrue:[
		names add:(dropValue copyFrom:i1 to:(i2-1)).
		i1 := i2 + 1.
	    ] ifFalse:[
		i1 := i2
	    ].
	].
	dropValue := names.
	dropValue := dropValue collect:[:nm | nm asFilename].
	dropType := #files.
    ] ifFalse:[ (dropType == #DndFile) ifTrue:[
	propertyType ~~ stringAtom ifTrue:[
	    Logger info:'expected a string propertyValue in drop'.
	    ^ self
	].
	dropValue := dropValue asFilename.
	dropType := #file.
    ] ifFalse:[ (dropType == #DndDir) ifTrue:[
	propertyType ~~ stringAtom ifTrue:[
	    Logger info:'expected a string propertyValue in drop'.
	    ^ self
	].
	dropValue := dropValue asFilename.
	dropType := #directory.
    ] ifFalse:[ (dropType == #DndText) ifTrue:[
	propertyType ~~ stringAtom ifTrue:[
	    Logger info:'expected a string propertyValue in drop'.
	    ^ self
	].
	dropType := #text.
    ] ifFalse:[ (dropType == #DndExe) ifTrue:[
	propertyType ~~ stringAtom ifTrue:[
	    Logger info:'expected a string propertyValue in drop'.
	    ^ self
	].
	dropType := #executable.
    ] ifFalse:[ (dropType == #DndLink) ifTrue:[
	propertyType ~~ stringAtom ifTrue:[
	    Logger info:'expected a string propertyValue in drop'.
	    ^ self
	].
	dropType := #link.
    ] ifFalse:[ (dropType == #DndRawData) ifTrue:[
	dropType := #rawData.
    ] ifFalse:[
	Logger info:'unsupported dropType: %1 data: %2 ' with:dropType with:dropValue.
	dropType := #unknown.
    ]]]]]]].

    sensor := targetView sensor.
    "not posted, if there is no sensor ..."
    sensor notNil ifTrue:[
	sensor dropMessage:dropType data:dropValue view:targetView position:nil handle:nil
    ].

    "Created: 4.4.1997 / 17:59:37 / cg"
!

expose:view x:x y:y width:w height:h count:count
    "forward an expose event for some view"

    self exposeX:x y:y width:w height:h view:view.
!

focusIn:view mode:mode detail:detail
    "a view got the keyboard focus"

    mode ~~ 1 "NotifyGrab" ifTrue:[
	"mode NotifyGrab is set for pseudo-focus-changes, when a view grabs the keyboard"
	self focusInView:view
    ].
!

focusOut:view mode:mode detail:detail
    "a view lost the keyboard focus"

    mode ~~ 1 "NotifyGrab" ifTrue:[
	"mode NotifyGrab is set for pseudo-focus-changes, when a view grabs the keyboard"
	self focusOutView:view
    ].
!

graphicsExpose:view x:x y:y width:w height:h count:count
    "forward a graphics-expose event for some view"

    self graphicsExposeX:x y:y width:w height:h final:(count==0) view:view
!

keyPress:view key:key code:keyCode state:state x:x y:y rootX:rX rootY:rY time:time
    "forward a key-press event for some view"

    |commonKey|

    lastEventTime := time.
    altDown := state bitTest:altModifierMask.
    metaDown := state bitTest:metaModifierMask.
    shiftDown := state bitTest:(self shiftModifierMask).
    ctrlDown := state bitTest:(self ctrlModifierMask).
    key isNil ifTrue:[
	"/ happens sometimes on some systems
	"/ (alt-graph on sun has no keysym)
	^ self
    ].
    eventRootX := rX.
    eventRootY := rY.

    "very low-level mapping of X11 event symbols to common ST/X event symbols"
    commonKey := rawKeySymTranslation at:key ifAbsent:key.

    self keyPress:commonKey x:x y:y view:view.
!

keyRelease:view key:key code:keyCode state:state x:x y:y rootX:rX rootY:rY time:time
    "forward a key-release event for some view"

    |commonKey|

    lastEventTime := time.
    altDown := state bitTest:altModifierMask.
    metaDown := state bitTest:metaModifierMask.
    shiftDown := state bitTest:(self shiftModifierMask).
    ctrlDown := state bitTest:(self ctrlModifierMask).

    key isNil ifTrue:[
	"/ happens sometimes on some systems
	"/ (alt-graph on sun has no keysym)
	^ self
    ].
    eventRootX := rX.
    eventRootY := rY.

    "very low-level mapping of X11 event symbols to common ST/X event symbols"
    commonKey := rawKeySymTranslation at:key ifAbsent:key.

    self keyRelease:commonKey x:x y:y view:view.
!

mappingNotify:view request:what event:eB
    "One of Keyboard-, Modifier- or PointerMap has changed, probably by xmodmap.
     Tell xlib about the fact."

    (what == #mappingKeyboard or:[what == #mappingModifier]) ifTrue:[
	self refreshKeyboardMapping:eB.
	"Maybe some of our modifiers have been changed"
	self initializeModifierMappings.
    ].

!

pointerEnter:view x:x y:y rootX:rX rootY:rY state:state mode:mode detail:detail time:time
    "forward a pointer enter event for some view"

    lastEventTime := time.
    altDown := state bitTest:altModifierMask.
    metaDown := state bitTest:metaModifierMask.
    shiftDown := state bitTest:(self shiftModifierMask).
    ctrlDown := state bitTest:(self ctrlModifierMask).

    eventRootX := rX.
    eventRootY := rY.
    self pointerEnter:state x:x y:y view:view
!

pointerLeave:view x:x y:y rootX:rX rootY:rY state:state mode:mode detail:detail time:time
    "forward a pointer leave event for some view"

    lastEventTime := time.
    altDown := state bitTest:altModifierMask.
    metaDown := state bitTest:metaModifierMask.
    shiftDown := state bitTest:(self shiftModifierMask).
    ctrlDown := state bitTest:(self ctrlModifierMask).

    eventRootX := rX.
    eventRootY := rY.
    self pointerLeave:state view:view
!

propertyChange:aView property:propertyId state:aSymbol time:time
    "sent when an X property changes.
     This is a very X-specific mechanism."

    |selectionFetcher|

    lastEventTime := time.
    aView isNil ifTrue:[
	"event arrived, after aView has been destroyed"
	^ self
    ].

"/    'propertyChange ' infoPrint. (self atomName:propertyId) print. ': ' print. aSymbol printCR.
"/    aView propertyChange:atom state:aSymbol.

    "JV@2011-01-06: Forward this event to views, they may
     be interested (for now, only XEmbedSiteView is)"

    aView sensor propertyChange:aView property:propertyId state:aSymbol time:time.

    aSymbol ~~ #newValue ifTrue:[
	"I am not interested in delete notifications"
	^ self.
    ].
    selectionFetcher := self findSelectionFetcher:aView id.
    selectionFetcher notNil ifTrue:[
	selectionFetcher message:thisContext message.
    ].

    "Modified: / 01-06-2011 / 13:40:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionClear:aView selection:selectionID time:time
    "sent when another X-client has created a selection.
     This is a very X-specific mechanism."

    |selectionFetcher|

    lastEventTime := time.

    selectionHandlers notNil ifTrue:[
	selectionHandlers do:[:eachHandler |
	    eachHandler selectionClear:selectionID
	]
    ].

    aView isNil ifTrue:[
	"event arrived, after aView has been destroyed"
	^ self
    ].
    selectionFetcher := self findSelectionFetcher:aView id.
    selectionFetcher notNil ifTrue:[
	selectionFetcher message:thisContext message.
    ].
!

selectionNotify:aView selection:selectionID target:targetID property:propertyID requestor:requestorID time:time
    "This event is sent by the selection owner as a response to our request for a selection.
     This is a very X-specific mechanism."

    |selectionFetcher|

"/    Transcript show:'seletionNotify selID:'.
"/    Transcript show:selectionID; show:' ('; show:(self atomName:selectionID); show:') '.
"/    Transcript show:' targetID:'.
"/    Transcript show:targetID; show:' ('; show:(self atomName:targetID); show:') '.
"/    Transcript show:' propertyID:'.
"/    Transcript show:propertyID; show:' ('; show:(self atomName:propertyID); show:') '.
"/    Transcript showCR:''.
"/    Transcript endEntry.

    lastEventTime := time.

    aView isNil ifTrue:[
	"event arrived, after aView has been destroyed"
	^ self
    ].
    selectionFetcher := self findSelectionFetcher:aView id.
    selectionFetcher notNil ifTrue:[
	selectionFetcher message:thisContext message.
    ].
!

selectionRequest:aView requestor:requestorID selection:selectionID target:targetID property:propertyID time:time
    "sent by some other X-client to ask for the selection.
     This is a very X-specific mechanism."

    |selection property bufferGetSelector responseTargetID selectionTime|

"/'Selection: ' print. (self atomName:selectionID) printCR. ' TargetId: ' print. (self atomName:targetID) printCR.
"/' Property: ' print. (self atomName:propertyID) printCR. ' Requestor: ' print. requestorID printCR.

    lastEventTime := time.

    "JV@2012-03-27: Support both PRIMARY and CLIPBOARD selections"
    selectionID == primaryAtom ifTrue:[
	bufferGetSelector := #getPrimaryBuffer.
	selectionTime := primarySelectionTime.
    ] ifFalse:[
	bufferGetSelector := #getCopyBuffer.
	selectionTime := clipboardSelectionTime.
    ].

    (targetID == (self atomIDOf:#TIMESTAMP)) ifTrue:[
	"the other view wants to know when we acquired ownership of the selection"
	responseTargetID := self atomIDOf:#INTEGER.
	selection := selectionTime.
    ] ifFalse:[(targetID == (self atomIDOf:#TARGETS)) ifTrue:[
	"the other view wants to know which targets we support"
	responseTargetID := self atomIDOf:#ATOM.
	selection := self supportedTargetAtoms.
    ] ifFalse:[
	selection := self selectionBuffer:bufferGetSelector as:targetID.
	responseTargetID := selection key.
	selection := selection value.
    ]].

"/'Send selection: ' print. selection printCR.

    property := propertyID.

    selection isNil ifTrue:[
	"sending property None tells the client,
	 that I could not convert"
"/        ('XWorkstation: unsupported selection target ', (self atomName:targetID)) errorPrintCR.
	property := nil.
	responseTargetID := targetID.
    ] ifFalse:[
	property == 0 ifTrue:[
	    "Support old (obsolete) clients requesting a None property.
	     Set the propertyID to the targetID"
	    property := responseTargetID.
	].
	self setProperty:property
	     type:responseTargetID
	     value:selection
	     for:requestorID.
    ].

    self sendNotifySelection:selectionID
	 property:property
	 target:responseTargetID
	 time:time
	 to:requestorID.

    "Modified: / 27-03-2012 / 15:22:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visibilityNotify:aView state:how

    aView notNil ifTrue:[
	aView visibilityChange:how
    ]
! !

!XWorkstation methodsFor:'event forwarding-ignored events'!

circulateNotify:aView place:aSymbol
    "sent, when the stacking order changes.
     ignored for now."

!

circulateRequest:aView place:aSymbol
    "sent, when the stacking order is about to change.
     ignored for now."
!

colorMapNotify:aView state:aBoolean
    "sent, when another colormap is installed.
     This is a very X-specific mechanism."

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    "/ not yet implemented
    "/ aView colorMapChange
!

configureRequest:view x:x y:y width:w height:h above:above detail:detail
    "ignored for now"

    "/ view configureRequest
!

gravityNotify:aView x:x y:y
    "ignored for now"

    "/ aView gravityNotify
!

keymapNotify:aView
    "ignore for now"

!

mapRequest:aView
    "ignored for now"

    "/ aView mapRequest
!

reparentedView:aView parentId:parentId x:x y:y
    "ignored for now"

    "/ aView reparented
!

resizeRequest:aView width:width height:height
    "ignored for now"

    "/ aView resizeRequest

!

shmCompletion: aView
    "ignored for now"


! !

!XWorkstation methodsFor:'event handling'!

defaultEventMask
    "return a mask to enable some events by default."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT( ExposureMask | StructureNotifyMask |
			 KeyPressMask | KeyReleaseMask |
			 PointerMotionMask |
			 EnterWindowMask | LeaveWindowMask |
			 ButtonPressMask | ButtonMotionMask | ButtonReleaseMask |
			 PropertyChangeMask ));
%}
!

dispatchEvent:evArray
    "a raw event array as coming from the low level C code is converted
     to a message send here.
     Also, the windowID from the event array is mapped to a view object."

    |viewId view evType arguments|

    viewId := evArray at:1.
    viewId notNil ifTrue:[
	viewId = lastId ifTrue:[
	    view := lastView
	] ifFalse:[
	    view := self viewFromId:viewId
	].
    ].

    evType := evArray at:3.

    (self respondsTo:evType) ifTrue:[
	arguments := evArray copyFrom:3 to:(3 + evType numArgs - 1).
	arguments at:1 put:view.

	self perform:evType withArguments:arguments.
	^ true.
    ].

    '********** unhandled event:' errorPrintCR.
    evType errorPrintCR. (evArray at:2) errorPrintCR.
    '********** see dispatchEvent' errorPrintCR.
    ^ false
!

dispatchEventFor:aViewIdOrNil withMask:eventMask
    "central event handling method:
     get next event and send appropriate message to the sensor or view.
     If the argument aViewIdOrNil is nil, events for any view are processed,
     otherwise only events for the view with given id are processed.
     If the argument aMask is nonNil, only events for this eventMask are
     handled.
     WARNING: this may block to wait for an event - you better check for a
	      pending event before calling this."

    |eventArray|

    eventArray := Array new:13.

    (self getEventFor:aViewIdOrNil withMask:eventMask into:eventArray) ifTrue:[
	AbortOperationRequest handle:[:ex |
	    ex return
	] do:[
	    self dispatchEvent:eventArray.
	]
    ].

    "Modified: 19.8.1997 / 17:10:42 / cg"
!

dispatchExposeEventFor:aViewIdOrNil
    "get next expose event and send appropriate message to the sensor or view.
     If the argument aViewIdOrNil is nil, events for any view are processed,
     otherwise only events for the view with given id are processed.
     WARNING: this may block to wait for an event - you better check for a
	      pending event before calling this."

    self dispatchEventFor:aViewIdOrNil withMask:(self eventMaskFor:#expose)

    "Modified: 19.8.1997 / 17:10:26 / cg"
!

dispatchLoop
    preWaitAction := [self flush].
    Processor addPreWaitAction:preWaitAction.
    [
	super dispatchLoop
    ] ensure:[
	Processor removePreWaitAction:preWaitAction.
	preWaitAction := nil.
    ].
!

dispatchPendingEvents
    "central event handling method for modal operation.
     (i.e. this is now only used in the modal debugger)
     Dispatch any pending events; return when no more are pending.
     This code is somewhat special, since X has a concept of graphic
     expose events (which are sent after a bitblt). After such a bitblt,
     we only handle exposes until the graphicsExpose arrives.
     Other systems may not need such a kludge"

    "interested in exposes only ?"

    |eventArray|

    dispatchingExpose notNil ifTrue:[
	[self exposeEventPendingFor:dispatchingExpose withSync:false] whileTrue:[
	    self dispatchExposeEventFor:dispatchingExpose
	].
	^ self
    ].

    [self eventPendingWithSync:false] whileTrue:[
	eventArray isNil ifTrue:[
	    eventArray := Array new:13.
	].
	(self getEventFor:nil withMask:nil into:eventArray) ifTrue:[
	    AbortOperationRequest handle:[:ex |
		ex return
	    ] do:[
		self dispatchEvent:eventArray.
		"/ multi-screen config: give others a chance
		"/ (needed because we run at high (non-timesliced) prio)
		Processor yield.
	    ]
	].
    ]

    "Modified: 19.8.1997 / 17:11:18 / cg"
!

disposeEventsWithMask:aMask for:aWindowIdOrNil
    "dispose (throw away) specific events. If aWindowId is nil,
     events matching the mask are thrown away regardless of which
     view they are for. Otherwise, only matching events for that
     view are flushed."

    <context: #return>
%{ /* UNLIMITEDSTACK */

    XEvent ev;
    Window win;

    if (ISCONNECTED
     && __isSmallInteger(aMask)) {
	Display *dpy = myDpy;

	ENTER_XLIB();
	if (__isExternalAddress(aWindowIdOrNil)) {
	    win = __WindowVal(aWindowIdOrNil);
	    while (XCheckWindowEvent(dpy, win, __intVal(aMask), &ev))
		;;
	} else {
	    while (XCheckMaskEvent(dpy, __intVal(aMask), &ev))
		;;
	}
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

eventMaskFor:anEventSymbol
    "return the eventMask bit-constant corresponding to an event symbol"

%{  /* NOCONTEXT */

    int m = 0;

    if (anEventSymbol == @symbol(keyPress)) m = KeyPressMask;
    else if (anEventSymbol == @symbol(keyRelease)) m = KeyReleaseMask;
    else if (anEventSymbol == @symbol(buttonPress)) m = ButtonPressMask;
    else if (anEventSymbol == @symbol(buttonRelease)) m = ButtonReleaseMask;
    else if (anEventSymbol == @symbol(buttonMotion)) m = ButtonMotionMask;
    else if (anEventSymbol == @symbol(pointerMotion)) m = PointerMotionMask;
    else if (anEventSymbol == @symbol(expose)) m = ExposureMask;
    else if (anEventSymbol == @symbol(focusChange)) m = FocusChangeMask;
    else if (anEventSymbol == @symbol(enter)) m = EnterWindowMask;
    else if (anEventSymbol == @symbol(leave)) m = LeaveWindowMask;
    else if (anEventSymbol == @symbol(keymapState)) m = KeymapStateMask;
    else if (anEventSymbol == @symbol(visibilityChange)) m = VisibilityChangeMask;
    else if (anEventSymbol == @symbol(structureNotify)) m = StructureNotifyMask;
    else if (anEventSymbol == @symbol(resizeRedirect)) m = ResizeRedirectMask;
    else if (anEventSymbol == @symbol(propertyChange)) m = PropertyChangeMask;
    else if (anEventSymbol == @symbol(colormapChange)) m = ColormapChangeMask;
    else if (anEventSymbol == @symbol(substructureNotify)) m = SubstructureNotifyMask;
    else if (anEventSymbol == @symbol(substructureRedirect)) m = SubstructureRedirectMask;
    RETURN (__MKSMALLINT(m));
%}
!

eventPending
    "return true, if any event is pending.
     This looks for both the internal queue and the display connection."

    "/ ConservativeSync is required for some Xlib implementation,
    "/ where eventPending returns wrong if we do not flush the buffer.
    "/ (especially Win32 & Xlib)

    dispatchingExpose notNil ifTrue:[
	^ self exposeEventPendingFor:dispatchingExpose withSync:ConservativeSync
    ].
    ^ self eventPendingWithSync:ConservativeSync

    "Modified: / 28.4.1999 / 11:08:12 / cg"
!

eventPending:anEventSymbol for:aWindowIdOrNil
    "return true, if a specific event is pending"

    ^ self eventsPending:(self eventMaskFor:anEventSymbol) for:aWindowIdOrNil withSync:false
!

eventPending:anEventMask for:aWindowIdOrNil withSync:doSync
    "return true, if any of the masked events is pending"

    <context: #return>
%{  /* UNLIMITEDSTACK */

    XEvent ev;
    Window win;
    int thereIsOne;
    OBJ rslt = false;

    if (ISCONNECTED && __isSmallInteger(anEventMask)) {
	Display *dpy = myDpy;

	ENTER_XLIB();
	if (doSync == true) {
	    XSync(dpy, 0);      /* make certain everything is flushed */
	}
	if (__isExternalAddress(aWindowIdOrNil)) {
	    win = __WindowVal(aWindowIdOrNil);
	    thereIsOne = XCheckWindowEvent(dpy, win, __intVal(anEventMask), &ev);
	} else {
	    thereIsOne = XCheckMaskEvent(dpy, __intVal(anEventMask), &ev);
	}
	if (thereIsOne) {
	    XPutBackEvent(dpy, &ev);
	    rslt = true;
	}
	LEAVE_XLIB();
    }
    RETURN ( rslt );
%}
!

eventPendingWithSync:doSync
    "return true, if any event is pending.
     If doSync is true, do a sync output buffer (i.e. send all to the display and wait until its processed)
     before checking."

    <context: #return>
%{  /* UNLIMITEDSTACK */
    OBJ rslt = false;

    if (ISCONNECTED) {
	Display *dpy = myDpy;

	if (XEventsQueued(dpy, QueuedAlready)) {
	    RETURN (true);
	}

	ENTER_XLIB();
	if (doSync == true) {
	    XSync(dpy, 0);      /* make certain everything is flushed */
	}
	if (XEventsQueued(dpy, QueuedAfterFlush)) {
	    rslt = true;
	}
	LEAVE_XLIB();
    }
    RETURN ( rslt );
%}
!

eventQueued
    "return true, if any event is queued"

    dispatchingExpose notNil ifTrue:[
	^ self exposeEventPendingFor:dispatchingExpose withSync:false
    ].
    ^ self eventQueuedAlready

    "Created: 12.12.1995 / 21:43:00 / stefan"
!

eventQueuedAlready
    "return true, if any event is queued internally.
     (i.e. in X's internal event queue, which is both filled by explicit
      nextEvent calls AND whenever drawing is done and events are pending on
      the display connection)."

%{  /* UNLIMITEDSTACK */
    if (ISCONNECTED) {
	if (XEventsQueued(myDpy, QueuedAlready)) {
	    RETURN(true);
	}
    }
    RETURN ( false );
%}
!

exposeEventPendingFor:aWindowIdOrNil withSync:doSync
    "return true, if any expose event is pending for a specific view,
     or any view (if the arg is nil).
     This is an X specific, only required after a scroll operation."

    <context: #return>

%{  /* UNLIMITEDSTACK */

    XEvent ev;
    Window win;
    int thereIsOne;
    OBJ rslt = false;

    if (ISCONNECTED) {
	Display *dpy = myDpy;

	ENTER_XLIB();
	if (doSync == true) {
	    XSync(dpy, 0);      /* make certain everything is flushed */
	}
	if (__isExternalAddress(aWindowIdOrNil)) {
	    win = __WindowVal(aWindowIdOrNil);
	    thereIsOne = XCheckWindowEvent(dpy, win, ExposureMask, &ev);
	} else {
	    thereIsOne = XCheckMaskEvent(dpy, ExposureMask, &ev);
	}
	if (thereIsOne) {
	    XPutBackEvent(dpy, &ev);
	    rslt = true;
	}
	LEAVE_XLIB();
    }
    RETURN ( rslt );
%}
!

getEventFor:aViewIdOrNil withMask:eventMask into:anEventArray
    "read next event if there is one and put event's data into anEventArray.
     If aViewIdOrNil is nil, events for any view are fetched;
     otherwise only events for that specific view will be fetched.
     Returns true, if there was an event, false otherwise.
     This method may block - so you better check for pending events
     before calling for it.

     The event fields are placed into anEventArray (must be at least size 13):
     the fields are:
	1:      windowID
	2:      eventType-ID
	3:      eventTypeSymbol

	4..     args

     Sorry I had to split dispatch into this fetch method and a separate
     handler method to allow UNLIMITEDSTACK here.
     (some Xlibs do a big alloca there which cannot be done in
      #dispatchEvent:, since it dispatches out into ST-methods).
    "

%{  /* UNLIMITEDSTACK */

    Display *dpy;
    Window win, wWanted;
    int evMask, returnValue;
    XEvent ev;
    OBJ eB;
    KeySym keySym = NoSymbol;
    unsigned char buffer[64];
    int i, nchars, codepoint; 
    char *keySymString;
    OBJ arg, sym, t, windowID;

    if (! ISCONNECTED) {
	RETURN (false);
    }

    dpy = myDpy;

    ev.type = 0;

    if (__isSmallInteger(eventMask)) {
	evMask = __intVal(eventMask);
    } else {
	evMask = ~0;
    }

    if (__isExternalAddress(aViewIdOrNil)) {
	wWanted = __WindowVal(aViewIdOrNil);
	returnValue = XCheckWindowEvent(dpy, wWanted, evMask, &ev);
    } else {
	if (evMask == ~0) {
	    XNextEvent(dpy, &ev);
	    returnValue = 1;
	} else {
	    returnValue = XCheckMaskEvent(dpy, evMask, &ev);
	}
    }
    if (!returnValue) {
	/* there is no event */
	RETURN (false);
    }

    if (anEventArray == nil) {
	/* sender is not interested in the event */
	RETURN(true);
    }

    if (!__isArray(anEventArray)) {
	console_fprintf(stderr, "XWorkstation: bad argument [%d]\n", __LINE__);
	RETURN (false);
    }
    if (__arraySize(anEventArray) < 11) {
	console_fprintf(stderr, "XWorkstation: bad argument [%d]\n", __LINE__);
	RETURN (false);
    }

#   define ANYBUTTON   (Button1MotionMask | Button2MotionMask | Button3MotionMask)

#   define ae ((XAnyEvent *)&ev)
#   define ee ((XExposeEvent *)&ev)
#   define ke ((XKeyPressedEvent *)&ev)
#   define be ((XButtonPressedEvent *)&ev)
#   define ce ((XConfigureEvent *)&ev)
#   define cr ((XConfigureRequestEvent *)&ev)
#   define me ((XMotionEvent *)&ev)
#   define ele ((XCrossingEvent *)&ev)
#   define de ((XDestroyWindowEvent *)&ev)
#   define ve ((XVisibilityEvent *)&ev)
#   define fe ((XFocusChangeEvent *)&ev)
#   define cre ((XCreateWindowEvent *)&ev)
#   define mape ((XMappingEvent *)&ev)
#   define gre ((XGravityEvent *)&ev)
#   define rr ((XResizeRequestEvent *)&ev)
#   define rpe ((XReparentEvent *)&ev)
#   define cie ((XCirculateEvent *)&ev)
#   define pe ((XPropertyEvent *)&ev)
#   define sce ((XSelectionClearEvent *)&ev)
#   define cme ((XColormapEvent *)&ev)

    if (((t = __INST(lastId)) != nil)
	 && __isExternalAddress(t)
	 && (__WindowVal(t) == ae->window)) {
	windowID = t;
    } else {
	windowID = __MKEXTERNALADDRESS(ae->window);
    }

    __ArrayInstPtr(anEventArray)->a_element[0] = windowID; __STORE(anEventArray, windowID);
    __ArrayInstPtr(anEventArray)->a_element[1] = __MKSMALLINT(ev.type);

    switch (ev.type) {
	case KeyRelease:
	    sym = @symbol(keyRelease:key:code:state:x:y:rootX:rootY:time:);
	    goto keyPressAndRelease;

	case KeyPress:
	    sym = @symbol(keyPress:key:code:state:x:y:rootX:rootY:time:);
	    /* FALL INTO */

	keyPressAndRelease:
	    arg = nil;
	    XLookupString(ke, (char *)buffer, sizeof(buffer), &keySym, NULL);
	    codepoint = XKeysymToUnicode(keySym);	    
	    if ( codepoint ) {
	    	arg = __MKUCHARACTER( codepoint );
	    } else {
		keySymString = XKeysymToString(keySym);
		if (keySymString) {		    
		    arg = __MKSYMBOL(keySymString, 0);
		}
	    }	   

#ifdef IGNORE_UNKNOWN_KEYCODES
	    if (arg == nil) {
		/* happens sometimes (alt-graph on sun has no keysym) */
		RETURN (false);
	    }
#endif
	    __ArrayInstPtr(anEventArray)->a_element[2] = sym;

	    __ArrayInstPtr(anEventArray)->a_element[3] = arg; __STORE(anEventArray, arg);
	    t = __MKUINT(ke->keycode); __ArrayInstPtr(anEventArray)->a_element[4] = t; __STORE(anEventArray, t);
	    __ArrayInstPtr(anEventArray)->a_element[5] = __mkSmallInteger(ke->state);
	    __ArrayInstPtr(anEventArray)->a_element[6] = __mkSmallInteger(ke->x);
	    __ArrayInstPtr(anEventArray)->a_element[7] = __mkSmallInteger(ke->y);
	    __ArrayInstPtr(anEventArray)->a_element[8] = __mkSmallInteger(ke->x_root);
	    __ArrayInstPtr(anEventArray)->a_element[9] = __mkSmallInteger(ke->y_root);
	    t = __MKUINT(ke->time); __ArrayInstPtr(anEventArray)->a_element[10] = t; __STORE(anEventArray, t);
	    break;

	case ButtonPress:
	    sym = @symbol(buttonPress:button:state:x:y:rootX:rootY:time:);
	    goto buttonPressAndRelease;

	case ButtonRelease:
	    sym = @symbol(buttonRelease:button:state:x:y:rootX:rootY:time:);
	    /* fall into */

	buttonPressAndRelease:
	    __ArrayInstPtr(anEventArray)->a_element[2] = sym;
	    __ArrayInstPtr(anEventArray)->a_element[3] = __mkSmallInteger(be->button);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __mkSmallInteger(ke->state);
	    __ArrayInstPtr(anEventArray)->a_element[5] = __mkSmallInteger(be->x);
	    __ArrayInstPtr(anEventArray)->a_element[6] = __mkSmallInteger(be->y);
	    __ArrayInstPtr(anEventArray)->a_element[7] = __mkSmallInteger(be->x_root);
	    __ArrayInstPtr(anEventArray)->a_element[8] = __mkSmallInteger(be->y_root);
	    t = __MKUINT(be->time); __ArrayInstPtr(anEventArray)->a_element[9] = t; __STORE(anEventArray, t);
	    break;

	case MotionNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(buttonMotion:state:x:y:rootX:rootY:time:);

	    __ArrayInstPtr(anEventArray)->a_element[3] = __mkSmallInteger(me->state);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __mkSmallInteger(me->x);
	    __ArrayInstPtr(anEventArray)->a_element[5] = __mkSmallInteger(me->y);
	    __ArrayInstPtr(anEventArray)->a_element[6] = __mkSmallInteger(me->x_root);
	    __ArrayInstPtr(anEventArray)->a_element[7] = __mkSmallInteger(me->y_root);
	    t = __MKUINT(me->time); __ArrayInstPtr(anEventArray)->a_element[8] = t; __STORE(anEventArray, t);
	    break;

	case FocusIn:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(focusIn:mode:detail:);
	    goto focusInOut;

	case FocusOut:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(focusOut:mode:detail:);
	    /* fall into */

	focusInOut:
	    __ArrayInstPtr(anEventArray)->a_element[3] = __mkSmallInteger(fe->mode);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __mkSmallInteger(fe->detail);
	    break;

	case EnterNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(pointerEnter:x:y:rootX:rootY:state:mode:detail:time:);
	    goto enterLeave;

	case LeaveNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(pointerLeave:x:y:rootX:rootY:state:mode:detail:time:);
	    /* fall into */

	enterLeave:
	    __ArrayInstPtr(anEventArray)->a_element[3] = __mkSmallInteger(ele->x);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __mkSmallInteger(ele->y);
	    __ArrayInstPtr(anEventArray)->a_element[5] = __mkSmallInteger(ele->x_root);
	    __ArrayInstPtr(anEventArray)->a_element[6] = __mkSmallInteger(ele->y_root);
	    __ArrayInstPtr(anEventArray)->a_element[7] = __mkSmallInteger(ele->state);
	    __ArrayInstPtr(anEventArray)->a_element[8] = __mkSmallInteger(ele->mode);
	    __ArrayInstPtr(anEventArray)->a_element[9] = __mkSmallInteger(ele->detail);
	    t = __MKUINT(ele->time); __ArrayInstPtr(anEventArray)->a_element[10] = t; __STORE(anEventArray, t);
	    break;

	case Expose:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(expose:x:y:width:height:count:);
	    goto expose;

	case GraphicsExpose:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(graphicsExpose:x:y:width:height:count:);
	    /* fall into */

	expose:
	    __ArrayInstPtr(anEventArray)->a_element[3] = __mkSmallInteger(ee->x);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __mkSmallInteger(ee->y);
	    __ArrayInstPtr(anEventArray)->a_element[5] = __mkSmallInteger(ee->width);
	    __ArrayInstPtr(anEventArray)->a_element[6] = __mkSmallInteger(ee->height);
	    __ArrayInstPtr(anEventArray)->a_element[7] = __mkSmallInteger(ee->count);
	    break;

	case NoExpose:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(noExposeView:);
	    break;

	case VisibilityNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(visibilityNotify:state:);
	    switch (ve->state) {
		case VisibilityUnobscured:
		    __ArrayInstPtr(anEventArray)->a_element[3] = @symbol(unobscured);
		    break;
		case VisibilityPartiallyObscured:
		    __ArrayInstPtr(anEventArray)->a_element[3] = @symbol(partiallyObscured);
		    break;
		case VisibilityFullyObscured:
		    __ArrayInstPtr(anEventArray)->a_element[3] = @symbol(fullyObscured);
		    break;
		default:
		    __ArrayInstPtr(anEventArray)->a_element[3] = __MKSMALLINT(ve->state);
		    break;
	    }
	    break;

	case CreateNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(createWindow:x:y:width:height:);
	    __ArrayInstPtr(anEventArray)->a_element[3] = __mkSmallInteger(cre->x);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __mkSmallInteger(cre->y);
	    __ArrayInstPtr(anEventArray)->a_element[5] = __mkSmallInteger(cre->width);
	    __ArrayInstPtr(anEventArray)->a_element[6] = __mkSmallInteger(cre->height);
	    break;

	case DestroyNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(destroyedView:);
	    break;

	case UnmapNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(unmappedView:);
	    break;

	case MapNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(mappedView:);
	    break;

	case ConfigureNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(configure:relativeTo:x:y:width:height:borderWidth:above:overrideRedirect:);
	    __ArrayInstPtr(anEventArray)->a_element[3] = nil;
	    __ArrayInstPtr(anEventArray)->a_element[4] = __mkSmallInteger(ce->x);
	    __ArrayInstPtr(anEventArray)->a_element[5] = __mkSmallInteger(ce->y);
	    __ArrayInstPtr(anEventArray)->a_element[6] = __mkSmallInteger(ce->width);
	    __ArrayInstPtr(anEventArray)->a_element[7] = __mkSmallInteger(ce->height);
	    __ArrayInstPtr(anEventArray)->a_element[8] = __mkSmallInteger(ce->border_width);
	   __ArrayInstPtr(anEventArray)->a_element[9] = nil;
	    __ArrayInstPtr(anEventArray)->a_element[10] = ce->override_redirect ? true : false;
	    if (ce->event != None) {
		t = __MKEXTERNALADDRESS(ce->event); __ArrayInstPtr(anEventArray)->a_element[3] = t; __STORE(anEventArray, t);
	    }
	    if (ce->above != None) {
		t = __MKEXTERNALADDRESS(ce->above); __ArrayInstPtr(anEventArray)->a_element[9] = t; __STORE(anEventArray, t);
	    }
	    break;

	case GravityNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(gravityNotify:x:y:);
	    __ArrayInstPtr(anEventArray)->a_element[3] = __mkSmallInteger(gre->x);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __mkSmallInteger(gre->y);
	    break;

	case ResizeRequest:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(resizeRequest:width:height:);
	    __ArrayInstPtr(anEventArray)->a_element[3] = __mkSmallInteger(rr->width);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __mkSmallInteger(rr->height);
	    break;

	case ConfigureRequest:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(configureRequest:x:y:width:height:above:detail:);
	    __ArrayInstPtr(anEventArray)->a_element[3] = __mkSmallInteger(cr->x);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __mkSmallInteger(cr->y);
	    __ArrayInstPtr(anEventArray)->a_element[5] = __mkSmallInteger(cr->width);
	    __ArrayInstPtr(anEventArray)->a_element[6] = __mkSmallInteger(cr->height);
	    __ArrayInstPtr(anEventArray)->a_element[7] = nil;
	    if (cr->above != None) {
		t = __MKEXTERNALADDRESS(cr->above); __ArrayInstPtr(anEventArray)->a_element[7] = t; __STORE(anEventArray, t);
	    }
	    switch (cr->detail) {
		case Above:
		    __ArrayInstPtr(anEventArray)->a_element[8] = @symbol(above);
		    break;
		case Below:
		    __ArrayInstPtr(anEventArray)->a_element[8] = @symbol(below);
		    break;
		case TopIf:
		    __ArrayInstPtr(anEventArray)->a_element[8] = @symbol(topIf);
		    break;
		case BottomIf:
		    __ArrayInstPtr(anEventArray)->a_element[8] = @symbol(bottomIf);
		    break;
		case Opposite:
		    __ArrayInstPtr(anEventArray)->a_element[8] = @symbol(opposite);
		    break;
		default:
		    __ArrayInstPtr(anEventArray)->a_element[8] = __MKSMALLINT(cr->detail);
		    break;
	    }
	    break;

	case CirculateNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(circulateNotify:place:);
	    goto circulate;

	case CirculateRequest:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(circulateRequest:place:);
	    /* fall into */
	circulate:
	    switch (cie->place) {
		case PlaceOnTop:
		    __ArrayInstPtr(anEventArray)->a_element[3] = @symbol(placeOnTop);
		    break;
		case PlaceOnBottom:
		    __ArrayInstPtr(anEventArray)->a_element[3] = @symbol(placeOnBottom);
		    break;
		default:
		    __ArrayInstPtr(anEventArray)->a_element[3] = __MKSMALLINT(cie->place);
		    break;
	    }
	    break;

	case PropertyNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(propertyChange:property:state:time:);
	    __ArrayInstPtr(anEventArray)->a_element[3] = __MKATOMOBJ(pe->atom);
	    switch (pe->state) {
		case PropertyNewValue:
		    __ArrayInstPtr(anEventArray)->a_element[4] = @symbol(newValue);
		    break;
		case PropertyDelete:
		    __ArrayInstPtr(anEventArray)->a_element[4] = @symbol(deleted);
		    break;
		default:
		    __ArrayInstPtr(anEventArray)->a_element[4] = __MKSMALLINT(pe->state);
		    break;
	    }
	    t = __MKUINT(pe->time); __ArrayInstPtr(anEventArray)->a_element[5] = t; __STORE(anEventArray, t);
	    break;

	case SelectionClear:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(selectionClear:selection:time:);
	    __ArrayInstPtr(anEventArray)->a_element[3] = __MKATOMOBJ(sce->selection);
	    t = __MKUINT(sce->time); __ArrayInstPtr(anEventArray)->a_element[4] = t; __STORE(anEventArray, t);
	    break;

	case SelectionRequest:
	    /*
	     * someone wants the selection
	     */
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(selectionRequest:requestor:selection:target:property:time:);
	    t = __MKEXTERNALADDRESS(ev.xselectionrequest.requestor); __ArrayInstPtr(anEventArray)->a_element[3] = t; __STORE(anEventArray, t);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __MKATOMOBJ(ev.xselectionrequest.selection);
	    __ArrayInstPtr(anEventArray)->a_element[5] = __MKATOMOBJ(ev.xselectionrequest.target);
	    __ArrayInstPtr(anEventArray)->a_element[6] = __MKATOMOBJ(ev.xselectionrequest.property);
	    t = __MKUINT(ev.xselectionrequest.time); __ArrayInstPtr(anEventArray)->a_element[7] = t; __STORE(anEventArray, t);
	    break;

	case SelectionNotify:
	    /*
	     * returned selection value (answer from SelectionRequest)
	     */
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(selectionNotify:selection:target:property:requestor:time:);
	    __ArrayInstPtr(anEventArray)->a_element[3] = __MKATOMOBJ(ev.xselection.selection);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __MKATOMOBJ(ev.xselection.target);
	    __ArrayInstPtr(anEventArray)->a_element[5] = __MKATOMOBJ(ev.xselection.property);
	    t = __MKEXTERNALADDRESS(ev.xselection.requestor); __ArrayInstPtr(anEventArray)->a_element[6] = t; __STORE(anEventArray, t);
	    t = __MKUINT(ev.xselection.time); __ArrayInstPtr(anEventArray)->a_element[7] = t; __STORE(anEventArray, t);
	    break;

	case ColormapNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(colormapNotify:state:);
	    __ArrayInstPtr(anEventArray)->a_element[3] = cme->state == ColormapInstalled ? true : false;
	    break;

	case ClientMessage:
	    if (ev.xclient.message_type == (int) __AtomVal(__INST(protocolsAtom))) {
		if ((ev.xclient.data.l[0] == (int) __AtomVal(__INST(quitAppAtom)))
		 || (ev.xclient.data.l[0] == (int) __AtomVal(__INST(deleteWindowAtom)))) {
		    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(terminateView:);
		    break;
		}
		if (ev.xclient.data.l[0] == (int) __AtomVal(__INST(saveYourselfAtom))) {
		    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(saveAndTerminateView:);
		    break;
		}
	    }
	    /*
	     * any other client message
	     */
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(clientMessage:type:format:data:);
	    __ArrayInstPtr(anEventArray)->a_element[3] = __MKATOMOBJ(ev.xclient.message_type);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __MKSMALLINT(ev.xclient.format);
	    t = __MKBYTEARRAY(&ev.xclient.data, sizeof(ev.xclient.data)); __ArrayInstPtr(anEventArray)->a_element[5] = t; __STORE(anEventArray, t);
	    break;

	case MappingNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(mappingNotify:request:event:);
	    switch(mape->request) {
		case MappingModifier:
		    arg = @symbol(mappingModifier);
		    break;
		case MappingKeyboard:
		    arg = @symbol(mappingKeyboard);
		    break;
		case MappingPointer:
		    arg = @symbol(mappingPointer);
		    break;
		default:
		    arg = __MKSMALLINT(mape->request);
		    break;
	    }
	    __ArrayInstPtr(anEventArray)->a_element[3] = arg;
	    t = __MKBYTEARRAY(&ev, sizeof(*mape)); __ArrayInstPtr(anEventArray)->a_element[4] = t;
	    __STORE(anEventArray, t);
	    break;

	case KeymapNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(keymapNotify:);
	    break;

	case MapRequest:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(mapRequest:);
	    break;

	case ReparentNotify:
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(reparentedView:parentId:x:y:);
	    t = __MKEXTERNALADDRESS(rpe->parent);
	    __ArrayInstPtr(anEventArray)->a_element[3] = t; __STORE(anEventArray, t);
	    __ArrayInstPtr(anEventArray)->a_element[4] = __mkSmallInteger(rpe->x);
	    __ArrayInstPtr(anEventArray)->a_element[5] = __mkSmallInteger(rpe->y);
	    break;	   

	default:
#ifdef SHM
	    if (ev.type == ShmCompletionType) {
	        __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(shmCompletion:);
	        break;
	    }
#endif
	    __ArrayInstPtr(anEventArray)->a_element[2] = @symbol(unknownX11Event);
	    break;
    }
#undef ae
#undef ee
#undef ke
#undef be
#undef ce
#undef cr
#undef cre
#undef cle
#undef gre
#undef me
#undef ewe
#undef ele
#undef lwe
#undef de
#undef mape
#undef ve
#undef fe
#undef rr
#undef rpe
#undef pe
#undef cie
#undef sce
#undef cme

%}.

    ^ true
!

handleAllEvents
    "from now on, handle any kind of event"

    dispatchingExpose := nil
!

handleExposeOnlyFor:aView
    "from now on, handle expose events only"

    dispatchingExpose := aView id
!

registerHotKeyForWindow:aDrawableId withId:anId modifiers:aModifier virtualKeyCode:aVirtualKeyCode
    "Defines a system-wide hot key."
    <resource: #todo>

    "no-op until implemented"

    ^ false.
!

setEventMask:aMask in:aWindowId
    "tell X that we are only interested in events from aMask, which
     is the bitwise or of the eventMask bits (see 'eventMaskFor:')"

    <context: #return>
%{

    int mask;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)
     && __isSmallInteger(aMask)) {
	mask = __intVal(aMask);

#ifdef OLD
	/* these may not be disabled */
	mask |= ExposureMask | StructureNotifyMask |
		KeyPressMask | KeyReleaseMask |
		EnterWindowMask | LeaveWindowMask |
		ButtonPressMask | ButtonMotionMask | ButtonReleaseMask;
#endif

	ENTER_XLIB();
	XSelectInput(myDpy, __WindowVal(aWindowId), mask);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

startDispatch
    "redefined to clear dispatchingExpose, which is a special X feature"

    (dispatchProcess notNil and:[dispatchProcess isDead not]) ifTrue:[^ self].
    dispatchingExpose := nil.
    super startDispatch.
!

unregisterHotKeyForWindow:aDrawableId withId:anId
    "Release a system-wide hot key."
    <resource: #todo>

    "no-op until implemented. Since we never registered anything, the unregister succeeds"

    ^ true.
!

viewIsRelevantInCheckForEndOfDispatch:aView
    aView == windowGroupWindow ifTrue:[^ false].
    ^ super viewIsRelevantInCheckForEndOfDispatch:aView
! !

!XWorkstation methodsFor:'event handling-old dispatch'!

buttonPress:button x:x y:y view:aView
    "forward a button-press event for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    button == 1 ifTrue:[
	activateOnClick == true ifTrue:[
	    "/ don't raise above an active popup view.
	    (activeKeyboardGrab isNil and:[activePointerGrab isNil]) ifTrue:[
		aView topView raise.
"/            ] ifFalse:[
"/                activeKeyboardGrab printCR.
"/                activePointerGrab printCR.
	    ]
	].
    ].
    super buttonPress:button x:x y:y view:aView
! !

!XWorkstation methodsFor:'event sending'!

sendClientEvent:msgType format:msgFormat to:targetWindowID propagate:propagate eventMask:eventMask window:windowID data1:d1 data2:d2 data3:d3 data4:d4 data5:d5
    "send a ClientMessage to some other (possibly: non-ST/X) view.
     The client message gets message_type and msgFormat as specified by
     the arguments. The additional data arguments specify up to
     5 longWords of user data; each may be an integer or nil.
     It is passed transparently in the events data field.
     See XProtocol specification for more details."

    "/ Event.xclient.type              = ClientMessage;
    "/ Event.xclient.display           = dpy;
    "/ Event.xclient.message_type      = msgType;
    "/ Event.xclient.format            = msgFormat;
    "/ Event.xclient.window            = windowID;
    "/ Event.xclient.data.l[0]         = d1
    "/ Event.xclient.data.l[1]         = d2
    "/ Event.xclient.data.l[2]         = d3
    "/ Event.xclient.data.l[3]         = d4
    "/ Event.xclient.data.l[4]         = d5
    "/
    "/ XSendEvent(dpy, targetWindowID, propagate, eventMask, &Event);

    <context: #return>
%{
    int type;
    int state;
    int __eventMask;

    if (ISCONNECTED
     && __isInteger(msgType)
     && __isInteger(msgFormat)
     && (eventMask == nil || __isInteger(eventMask))
     && (__isExternalAddress(windowID) || __isInteger(windowID))
     && (__isExternalAddress(targetWindowID) || __isInteger(targetWindowID))) {
	Display *dpy = myDpy;
	XEvent ev;
	Status result;
	Window targetWindow;

	if (__isInteger(d1)) {
	    ev.xclient.data.l[0] = __longIntVal(d1);
	} else {
	    if (__isExternalAddress(d1)) {
		ev.xclient.data.l[0] = (INT)__externalAddressVal(d1);
	    } else {
		ev.xclient.data.l[0] = 0;
	    }
	}
	if (__isInteger(d2)) {
	    ev.xclient.data.l[1] = __longIntVal(d2);
	} else {
	    if (__isExternalAddress(d2)) {
		ev.xclient.data.l[1] = (INT)__externalAddressVal(d2);
	    } else {
		ev.xclient.data.l[1] = 0;
	    }
	}
	if (__isInteger(d3)) {
	    ev.xclient.data.l[2] = __longIntVal(d3);
	} else {
	    if (__isExternalAddress(d3)) {
		ev.xclient.data.l[2] = (INT)__externalAddressVal(d3);
	    } else {
		ev.xclient.data.l[2] = 0;
	    }
	}
	if (__isInteger(d4)) {
	    ev.xclient.data.l[3] = __longIntVal(d4);
	} else {
	    if (__isExternalAddress(d4)) {
		ev.xclient.data.l[3] = (INT)__externalAddressVal(d4);
	    } else {
		ev.xclient.data.l[3] = 0;
	    }
	}
	if (__isInteger(d5)) {
	    ev.xclient.data.l[4] = __longIntVal(d5);
	} else {
	    if (__isExternalAddress(d5)) {
		ev.xclient.data.l[4] = (INT)__externalAddressVal(d5);
	    } else {
		ev.xclient.data.l[4] = 0;
	    }
	}

	if (__isExternalAddress(windowID)) {
	    ev.xclient.window = __WindowVal(windowID);
	} else {
	    ev.xclient.window = (Window)__longIntVal(windowID);
	}

	if (__isExternalAddress(targetWindowID)) {
	    targetWindow = __WindowVal(targetWindowID);
	} else {
	    targetWindow = (Window)__longIntVal(targetWindowID);
	}

	ev.xclient.type              = ClientMessage;
	ev.xclient.display           = dpy;
	ev.xclient.message_type      = __longIntVal(msgType);
	ev.xclient.format            = __longIntVal(msgFormat);

	if (eventMask == nil) {
	    __eventMask = NoEventMask;
	} else {
	    __eventMask = __longIntVal(eventMask);
	}

	ENTER_XLIB();
	result = XSendEvent(dpy, targetWindow, (propagate == true ? True : False), __eventMask , &ev);
	LEAVE_XLIB();

	if ((result == BadValue) || (result == BadWindow)) {
	    DPRINTF(("bad status in sendClientEvent\n"));
	    RETURN ( false )
	}
	RETURN (true)
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ false
!

sendKeyOrButtonEvent:typeSymbol x:xPos y:yPos keyOrButton:keySymCodeOrButtonNr state:stateMask toViewId:targetId
    "send a keyPress/Release or buttonPress/Release event to some (possibly alien) view.
     TypeSymbol must be one of: #keyPress, #keyRelease, #buttonPress , #buttonRelease.
     For buttonEvents, the keySymCodeOrButtonNr must be the buttons number (1, 2 ...);
     for key events, it can be either a symbol (as listed in X's keySyms)
     or a numeric keysym code. If state is nil, the modifier bits (shift & control)
     are computed from the keyboardMap - if non-nil, these are passed as modifierbits.
     The non-nil case is the lowlevel entry, where state must include any shift/ctrl information
     (not very user friendly)"

    <context: #return>
%{
    int type;
    int state;

    if (__isSmallInteger(stateMask)) {
	state = __intVal(stateMask);
    } else {
	state = 0;
    }

    if (ISCONNECTED
     && __isSmallInteger(xPos) && __isSmallInteger(yPos)
     && (__isSmallInteger(keySymCodeOrButtonNr) || __isStringLike(keySymCodeOrButtonNr))
     && (__isExternalAddress(targetId) || __isInteger(targetId))) {
	Display *dpy = myDpy;

	XEvent ev;
	Window target;
	Status result;
	KeySym keySym, *syms;
	int screen = __intVal(__INST(screen));
	int nSyms;

	if ((typeSymbol == @symbol(keyPress))
	 || (typeSymbol == @symbol(keyRelease))) {
	    if (__isStringLike(keySymCodeOrButtonNr)) {
		keySym = XStringToKeysym(__stringVal(keySymCodeOrButtonNr));
	    } else {
		if (__isCharacter(keySymCodeOrButtonNr)) {
		    char s[2];
		    s[0] = __intVal(__characterVal(keySymCodeOrButtonNr));
		    s[1] = '\0';
		    keySym = XStringToKeysym(s);
		} else {
		    if (__isSmallInteger(keySymCodeOrButtonNr)) {
			keySym = (KeySym) __intVal(keySymCodeOrButtonNr);
		    } else {
			goto notOk;
		    }
		}
	    }
	    ev.xkey.keycode = XKeysymToKeycode(dpy, keySym);

	    if (stateMask == nil) {
		/*
		 * get the modifier from the keySym
		 */
		nSyms = 0;
		syms = XGetKeyboardMapping(dpy, ev.xkey.keycode, 1, &nSyms);
		if (syms) {
		    int i;

		    for (i=0; i<nSyms; i++) {
			if (syms[i] == keySym) {
#ifdef MODIFIERDEBUG
			    console_printf("modifier-index is %d\n", i);
#endif
			    if (i) state = (1 << (i-1));
			    break;
			}
		    }
		    XFree(syms);
		}
	    }
	} else {
	    if ((typeSymbol == @symbol(buttonPress))
	     || (typeSymbol == @symbol(buttonRelease))) {
		if (__isSmallInteger(keySymCodeOrButtonNr)) {
		    ev.xbutton.button = __intVal(keySymCodeOrButtonNr);
		} else {
		    ev.xbutton.button = 1;
		}
	    } else {
		DPRINTF(("invalid sendEvent typeSymbol\n"));
		RETURN (false);
	    }
	}

	if (typeSymbol == @symbol(keyPress))
	    ev.xany.type = KeyPress;
	else if (typeSymbol == @symbol(keyRelease))
	    ev.xany.type = KeyRelease;
	else if (typeSymbol == @symbol(buttonPress))
	    ev.xany.type = ButtonPress;
	else if (typeSymbol == @symbol(buttonRelease))
	    ev.xany.type = ButtonRelease;

	if (__isExternalAddress(targetId)) {
	    target = __WindowVal(targetId);
	} else {
	    target = (Window) __longIntVal(targetId);
	}
	ev.xkey.window = target;
	ev.xkey.same_screen = 1;
	ev.xkey.subwindow = 0;
	ev.xkey.root = RootWindow(dpy, screen);
	ev.xkey.x = __intVal(xPos);
	ev.xkey.y = __intVal(yPos);
	ev.xkey.state = state;
	ev.xkey.time = CurrentTime;

	ENTER_XLIB();
	result = XSendEvent(dpy, target, False, 0 , &ev);
	LEAVE_XLIB();
	if ((result == BadValue) || (result == BadWindow)) {
	    DPRINTF(("bad status\n"));
	    RETURN ( false )
	}
	RETURN (true)
    }
  notOk: ;
%}.
    self primitiveFailedOrClosedConnection.
    ^ false

    "<<END
     |v|

     v := EditTextView extent:200@100.
     v contents:'Hello world'.
     v openAndWait.
     v selectFromCharacterPosition:1 to:5.

     "/ CTRL-c
     v device
	 sendKeyOrButtonEvent:#keyPress
	 x:10 y:10
	 keyOrButton:#'Control'
	 state:(v device ctrlModifierMask)
	 toViewId: v id.

     v device
	 sendKeyOrButtonEvent:#keyPress
	 x:10 y:10
	 keyOrButton:'c'
	 state:(v device ctrlModifierMask)
	 toViewId: v id.

     v device
	 sendKeyOrButtonEvent:#keyRelease
	 x:10 y:10
	 keyOrButton:'c'
	 state:(v device ctrlModifierMask)
	 toViewId: v id.

     v device
	 sendKeyOrButtonEvent:#keyRelease
	 x:10 y:10
	 keyOrButton:#'Control'
	 state:0
	 toViewId: v id.

     "/ CTRL-v

     v device
	 sendKeyOrButtonEvent:#keyPress
	 x:10 y:10
	 keyOrButton:#'Control'
	 state:(v device ctrlModifierMask)
	 toViewId: v id.

     v device
	 sendKeyOrButtonEvent:#keyPress
	 x:10 y:10
	 keyOrButton:'v'
	 state:(v device ctrlModifierMask)
	 toViewId: v id.

     v device
	 sendKeyOrButtonEvent:#keyRelease
	 x:10 y:10
	 keyOrButton:'v'
	 state:(v device ctrlModifierMask)
	 toViewId: v id.

     v device
	 sendKeyOrButtonEvent:#keyRelease
	 x:10 y:10
	 keyOrButton:#'Control'
	 state:0
	 toViewId: v id.
END"
! !

!XWorkstation methodsFor:'font stuff'!

createFontFor:aFontName
    "a basic method for X-font allocation; this method allows
     any font to be acquired (even those not conforming to
     standard naming conventions, such as cursor, fixed or k14)"

    <context: #return>

%{  /* STACK: 100000 */
    /*** UNLIMITEDSTACK */

    XFontStruct *newFont;

    if (ISCONNECTED
     && __isStringLike(aFontName)) {

	ENTER_XLIB();
	newFont = XLoadQueryFont(myDpy, (char *)__stringVal(aFontName));
	LEAVE_XLIB();
#ifdef COUNT_RESOURCES
	if (newFont)
	    __cnt_font++;
#endif

	RETURN ( newFont ? __MKEXTERNALADDRESS(newFont) : nil );
    }
%}.
    "/ --- disabled due to UNLIMITEDSTACK -- self primitiveFailedOrClosedConnection.
    ^ nil
!

decomposeXFontName:aString into:aBlock
    "extract family, face, style and size from an
     X-font name
     1 2     3      4    5     6         7 8      9    10   11   12 13 14       15
      -brand-family-face-style-moreStyle- -height-size-resX-resY-??-??-registry-encoding;
     evaluate aBlock with these"

    |family face style moreStyle fheight size
     resX resY registry encoding coding fields|

    aString isNil ifTrue:[^ false].
    fields := aString asCollectionOfSubstringsSeparatedBy:$-.
    fields size == 3 ifTrue:[
	"take care of old font names: family-style-size"
	family := fields at:1.
	style := fields at:2.
	size := Number readFromString:(fields at:3) onError:[^ false].
    ] ifFalse:[fields size == 2 ifTrue:[
	"take care of old font names: family-size"
	family := fields at:1.
	size := Number readFromString:(fields at:2) onError:[^ false].
    ] ifFalse:[fields size >= 15 ifTrue:[
	family := fields at:3.
	face := fields at:4.
	style := fields at:5.
	style = 'o' ifTrue:[
	    style := 'oblique'
	] ifFalse:[style = 'i' ifTrue:[
	     style := 'italic'
	] ifFalse:[style = 'r' ifTrue:[
	     style := 'roman'
	]]].
	moreStyle := fields at:6.
	(moreStyle ~= 'normal' and:[moreStyle size > 1]) ifTrue:[
	    style := style, '-', moreStyle.
	].
	fheight := fields at:8.
	size := (Number readFromString:(fields at:9) onError:[^ false]) / 10.
	resX := fields at:10.
	resY := fields at:11.
	registry := fields at:14.
	encoding := fields at:15.
	coding := registry , '-' , encoding.
    ] ifFalse:[
	^ false
    ]]].
    aBlock value:family value:face value:style value:size value:coding.
    ^ true
!

encodingOf:aFontId
    "the font's encoding - if the font does not provide that info,
     return nil (and assume #ascii, which is a subset of #iso8859-1)."

    |props reg enc coll|

    props := self fontPropertiesOf:aFontId.
    reg := props at:#'CHARSET_REGISTRY' ifAbsent:nil.
    enc := props at:#'CHARSET_ENCODING' ifAbsent:nil.
    coll := props at:#'CHARSET_COLLECTIONS' ifAbsent:nil.

    reg notNil ifTrue:[ reg := self atomName:reg].
    enc notNil ifTrue:[ enc := self atomName:enc].
    coll notNil ifTrue:[ coll := self atomName:coll].

    ^ self extractEncodingFromRegistry:reg encoding:enc charSetCollections:coll

     "
       Screen current encodingOf:(Screen current getDefaultFontWithEncoding:#'iso10646-1')
     "
!

extentsOf:aString from:index1 to:index2 inFont:aFontId into:anArray

    <context: #return>

%{  /* UNLIMITEDSTACK */

    XFontStruct *f;
    char *cp;
    int len, n, i1, i2, l;
#   define NLOCALBUFFER 200
    XChar2b xlatebuffer[NLOCALBUFFER];
    int nInstBytes;
    int directionReturn, fontAscentReturn, fontDescentReturn;
    XCharStruct overAllReturn;
    OBJ *resultArray;

    if (ISCONNECTED
	 && __bothSmallInteger(index1, index2)
	 && __isExternalAddress(aFontId)
	 && __isNonNilObject(aString)) {
	int lMax = __intVal(@global(MaxStringLength));
	f = __FontVal(aFontId);
	if (! f) goto fail;

	if (__isArray(anArray) && __arraySize(anArray) > 0) {
	    resultArray = __arrayVal(anArray);
	} else {
	    resultArray = 0;
	}

	i1 = __intVal(index1) - 1;

	if (i1 >= 0) {
	    OBJ cls;

	    i2 = __intVal(index2) - 1;
	    if (i2 < i1) {
		RETURN ( __MKSMALLINT(0) );
	    }

	    cp = (char *) __stringVal(aString);
	    l = i2 - i1 + 1;

	    if (__isStringLike(aString)) {
		n = __stringSize(aString);
		if (i2 >= n) goto fail;
		cp += i1;
		len = XTextExtents(f, cp, l,
					&directionReturn, &fontAscentReturn, &fontDescentReturn,
					&overAllReturn);
	    } else {
		cls = __qClass(aString);
		nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
		cp += nInstBytes;
		n = __byteArraySize(aString) - nInstBytes;

		if (__isBytes(aString)) {
		    if (i2 >= n) goto fail;

		    cp += i1;
		    len = XTextExtents(f, cp, l,
					    &directionReturn, &fontAscentReturn, &fontDescentReturn,
					    &overAllReturn);
		} else  if (__isWords(aString)) { /* TWOBYTESTRINGS */
		    union {
			char b[2];
			unsigned short s;
		    } u;
		    int i;
		    XChar2b *cp2 = (XChar2b *)0;
		    int mustFree = 0;

		    n = n / 2;
		    if (i2 >= n) goto fail;

		    cp += (i1 * 2);
		    if (l > lMax) l = lMax;

		    /*
		     * ST/X TwoByteStrings store the asciiValue in native byteOrder;
		     * X expects them MSB first
		     * convert as required
		     */

		    u.s = 0x1234;
		    if (u.b[0] != 0x12) {
			if (l <= NLOCALBUFFER) {
			    cp2 = xlatebuffer;
			} else {
			    cp2 = (XChar2b *)(malloc(l * 2));
			    mustFree = 1;
			}
			for (i=0; i<l; i++) {
			    cp2[i].byte1 = (((XChar2b *)cp)[i]).byte2;
			    cp2[i].byte2 = (((XChar2b *)cp)[i]).byte1;
			}
			cp = (char *) cp2;
		    }

		    len = XTextExtents16(f, (XChar2b *)cp, l,
					    &directionReturn, &fontAscentReturn, &fontDescentReturn,
					    &overAllReturn);

		    if (mustFree) {
			free(cp2);
		    }
		} else if (__isLongs(aString)) { /* FOURBYTESTRINGS */
		    union {
			char b[2];
			unsigned short s;
		    } u;
		    int i;
		    XChar2b *cp2 = (XChar2b *)0;
		    int mustFree = 0;

		    n = n / 4;
		    if (i2 >= n) goto fail;

		    cp += (i1 * 4);
		    if (l > lMax) l = lMax;

		    /*
		     * For now: X does not support 32bit characters without the new 32Unicode extensions.
		     * For now, treat chars above 0xFFFF as 0xFFFF (should we use default-char ?).
		     */
		    if (l <= NLOCALBUFFER) {
			cp2 = xlatebuffer;
		    } else {
			cp2 = (XChar2b *)(malloc(l * 2));
			mustFree = 1;
		    }
		    for (i=0; i<l; i++) {
			int codePoint;

			codePoint = ((unsigned int32 *)cp)[i];
			if (codePoint > 0xFFFF) {
			    codePoint = 0xFFFF;
			}
			cp2[i].byte1 = codePoint & 0xFF;
			cp2[i].byte2 = (codePoint >> 8) & 0xFF;;
		    }
		    cp = (char *) cp2;

		    len = XTextExtents16(f, (XChar2b *)cp, l,
					    &directionReturn, &fontAscentReturn, &fontDescentReturn,
					    &overAllReturn);
		    if (mustFree) {
			free(cp2);
		    }
		} else
		    goto fail;      /*unknown string class */
	    }
	    if (resultArray) {
		switch (__arraySize(anArray)) {
		default:
		case 8:
		    resultArray[7] = __MKSMALLINT(directionReturn);
		case 7:
		    resultArray[6] = __MKSMALLINT(fontDescentReturn);
		case 6:
		    resultArray[5] = __MKSMALLINT(fontAscentReturn);
		case 5:
		    resultArray[4] = __MKSMALLINT(overAllReturn.descent);
		case 4:
		    resultArray[3] = __MKSMALLINT(overAllReturn.ascent);
		case 3:
		    resultArray[2] = __MKSMALLINT(overAllReturn.width);
		case 2:
		    resultArray[1] = __MKSMALLINT(overAllReturn.rbearing);
		case 1:
		    resultArray[0] = __MKSMALLINT(overAllReturn.lbearing);
		case 0:
		    break;
		}
	    }
	    RETURN ( __MKSMALLINT(overAllReturn.width) );
	}
    }
#undef NLOCALBUFFER
fail: ;
%}.
    self primitiveFailedOrClosedConnection.
    ^ 0

    "
      |result|
      result := Array new:8.
      Screen current
	extentsOf:'hello World' from:1 to:11
	inFont:(Screen current  getFontWithFoundry:'*'
		    family:'courier new'
		    weight:'medium'
		    slant:'r'
		    spacing:nil
		    pixelSize:nil
		    size:10
		    encoding:#'iso10646-1'
	    )
	into:result.

      result
    "
!

extractEncodingFromRegistry:registry encoding:encoding charSetCollections:charSetCollections
    "given registry and encoding as returned by X11,
     generate a single symbol naming the ST/X encoding.
     I.e. from registry='ISO8859' and encoding='1', generate #'iso8859-1'.
     This is pure magic ..."

    |enc charSets|

    (registry size ~~ 0) ifTrue:[
	enc := registry asLowercase.
	encoding size ~~ 0 ifTrue:[
	   enc := enc, '-', encoding asLowercase.
	].
	enc := enc asSymbol.
    ] ifFalse:[
	(encoding size ~~ 0) ifTrue:[
	    enc := encoding asLowercase asSymbol
	] ifFalse:[
	    charSets := charSetCollections.
	    (charSets notEmptyOrNil) ifTrue:[
		charSets := charSets asUppercase asCollectionOfWords.
		(charSets includes:'ISO8859-1') ifTrue:[
		    enc := #'iso8859-1'
		] ifFalse:[
		    (charSets includes:'ISO8859') ifTrue:[
			enc := #iso8859
		    ] ifFalse:[
			(charSets includes:'ASCII') ifTrue:[
			    enc := #ascii
			] ifFalse:[
			    (charSets includes:'ADOBE-STANDARD') ifTrue:[
				enc := #iso8859
			    ]
			]
		    ]
		]
	    ]
	]
    ].
    ^  enc

    "Created: 17.4.1996 / 14:57:06 / cg"
    "Modified: 17.4.1996 / 17:22:35 / cg"
!

flushListOfAvailableFonts
    "flush the cached list of all available fonts on this display.
     Required if new fonts have been added on the display server."

    listOfXFonts := nil.
    XftFontDescription notNil ifTrue:[
	XftFontDescription flushListOfAvailableFonts.
    ].

    "
     Display flushListOfAvailableFonts.
     Display listOfAvailableFonts
    "

    "Modified: 27.9.1995 / 10:54:47 / stefan"
    "Created: 20.2.1996 / 22:55:52 / cg"
!

fontDescriptionFromXFontName:aFontNameString
    "extract family, face, style and size from an
     X-font name
     1 2     3      4    5     6         7 8      9    10   11   12 13 14       15
      -brand-family-face-style-moreStyle- -pxlSize-size-resX-resY-??-??-registry-encoding;
     evaluate aBlock with these"

    |family face style moreStyle size
     resX resY registry encoding coding fields|

    aFontNameString isNil ifTrue:[^ nil].

    Error handle:[:ex |
	family := nil.
    ] do:[
	fields := aFontNameString asCollectionOfSubstringsSeparatedBy:$-.
	fields size == 3 ifTrue:[
	    "take care of old font names: family-style-size"
	    family := fields at:1.
	    style := fields at:2.
	    size := Number readFromString:(fields at:3).
	] ifFalse:[
	    fields size == 2 ifTrue:[
		"take care of old font names: family-size"
		family := fields at:1.
		size := Number readFromString:(fields at:2).
	    ] ifFalse:[
		fields size >= 15 ifTrue:[
		    family := fields at:3.
		    face := fields at:4.
		    style := fields at:5.
		    style = 'o' ifTrue:[
			style := 'oblique'
		    ] ifFalse:[style = 'i' ifTrue:[
			 style := 'italic'
		    ] ifFalse:[style = 'r' ifTrue:[
			 style := 'roman'
		    ]]].
		    moreStyle := fields at:6.
		    (moreStyle ~= 'normal' and:[moreStyle size > 1]) ifTrue:[
			style := style, '-', moreStyle.
		    ].
"/                    pxlSize := (Integer readFromString:(fields at:8)).
		    size := (Number readFromString:(fields at:9)) / 10.
		    resX := fields at:10.
		    resY := fields at:11.
		    registry := fields at:14.
		    encoding := fields at:15.
		    coding := registry , '-' , encoding.
		] ifFalse:[
		    "/ very old name (such as cursor, 5x7 etc)
		]
	    ]
	].
    ].

    family notNil ifTrue:[
       ^ FontDescription family:family face:face style:style size:size sizeUnit:#pt encoding:coding.
    ].
    ^ FontDescription name:aFontNameString

    "
     Screen current fontDescriptionFromXFontName:'-arabic-newspaper-medium-r-normal--32-246-100-100-p-137-iso10646-1'
    "
!

fontMetricsOf:fontId
    "return a fonts metrics info object"

    <context: #return>

    |info avgAscent avgDescent minCode maxCode dir
     maxAscent maxDescent minWidth maxWidth avgWidth|

%{  /* UNLIMITEDSTACK */
    XFontStruct *f;
    int len;

    if (ISCONNECTED) {
	if (__isExternalAddress(fontId)) {
	    f = __FontVal(fontId);
	    if (f) {
		minCode = __MKUINT((f->min_byte1<<8) + f->min_char_or_byte2);
		maxCode = __MKUINT((f->max_byte1<<8) + f->max_char_or_byte2);

		if (f->direction == FontLeftToRight) {
		    dir = @symbol(LeftToRight);
		} else if (f->direction == FontRightToLeft) {
		    dir = @symbol(RightToLeft);
		}
		avgAscent = __MKSMALLINT(f->ascent);
		avgDescent = __MKSMALLINT(f->descent);
		maxAscent = __MKSMALLINT(f->max_bounds.ascent);
		maxDescent = __MKSMALLINT(f->max_bounds.descent);
		minWidth = __MKSMALLINT(f->min_bounds.width);
		maxWidth = __MKSMALLINT(f->max_bounds.width);

		ENTER_XLIB();
		len = XTextWidth(f, "n", 1);
		LEAVE_XLIB();

		avgWidth = __MKSMALLINT( len );
	    }
	}
    }
%}.
    avgAscent == nil ifTrue:[
	self primitiveFailedOrClosedConnection.
	^ nil
    ].

    "DingBats font returns 0 for maxAscent/maxDescent"
    maxAscent := maxAscent max:avgAscent.
    maxDescent := maxDescent max:avgDescent.

    info := DeviceWorkstation::DeviceFontMetrics new.
    info
      ascent:avgAscent
      descent:avgDescent
      maxAscent:maxAscent
      maxDescent:maxDescent
      minWidth:minWidth
      maxWidth:maxWidth
      avgWidth:avgWidth
      minCode:minCode
      maxCode:maxCode
      direction:dir.
    ^ info

    "
     Screen current fontMetricsOf:(View defaultFont onDevice:Screen current) fontId
     CharacterSetView openOn:(View defaultFont onDevice:Screen current)

     Screen current fontMetricsOf:(MenuView defaultFont onDevice:Screen current) fontId
     CharacterSetView openOn:(MenuView defaultFont onDevice:Screen current)
    "
!

fontProperties:propertyNames of:aFontId
    "Answer an array with selected property values of a font.
     This is X11-Specific.
     PropertyNames is an array with property names (symbols or strings).
     Nonexistent properties are returned as nil"

    |props|

    props := self fontPropertiesOf:aFontId.
    ^ propertyNames collect:[:propName | props at:propName ifAbsent:nil].

    "
     Screen current
	fontProperties:#(#'PIXEL_SIZE' #'POINT_SIZE' RESOLUTION notExistent)
	of:(Screen current getDefaultFontWithEncoding:#'iso10646-1')
    "
!

fontPropertiesOf:aFontId
    "Answer an array with all the properties of a font.
     This is X11-Specific.
     Odd indices contain the property name (atom)
     Even indices contain the property value (atom)

     Answer nil, if there are no properties"

    |propsArray result|

%{
    XFontStruct *f;
    XFontProp *prop;
    int n, i;
    OBJ x;

    if (__isExternalAddress(aFontId)) {
	f = __FontVal(aFontId);
	if (f && (prop = f->properties) != 0) {
	    n = f->n_properties;
	    propsArray = __ARRAY_NEW_INT(n*2);
	    for (i = 0; n; n--, prop++) {
		x = __MKUINT(prop->name); __ArrayInstPtr(propsArray)->a_element[i++] = x; __STORE(propsArray, x);
		x = __MKUINT(prop->card32); __ArrayInstPtr(propsArray)->a_element[i++] = x; __STORE(propsArray, x);
	    }
	}
    }
%}.
    result := Dictionary new.
    propsArray notNil ifTrue:[
	propsArray pairWiseDo:[:n :v | result at:(self atomName:n) put:v].
    ].
    ^ result

    "
     Screen current fontPropertiesOf:(Screen current getDefaultFontWithEncoding:#'iso10646-1')
     Dictionary withKeysAndValues:(Screen current fontPropertiesOf:(Screen current getDefaultFontWithEncoding:#'iso10646-1'))

     |d|
     d := Dictionary new.
     (Screen current fontPropertiesOf:(Screen current getDefaultFontWithEncoding:#'iso10646-1')) keysAndValuesDo:[:name :value|
	  d at:name put:((Screen current atomName:value) ? value)
     ].
     d
    "
!

fontResolutionOf:fontId
    "return the resolution (as dpiX @ dpiY) of the font - this is usually the displays resolution,
     but due to errors in some XServer installations, some use 75dpi fonts on higher
     resolution displays and vice/versa."

    |props res resX resY|

    props := self fontProperties:#(#'RESOLUTION_X' #'RESOLUTION_Y' RESOLUTION) of:fontId.
    resX := props at:1.
    resY := props at:2.
    (resX notNil and:[resY notNil]) ifTrue:[
	^ resX @ resY
    ].
    res := props at:3.
    res notNil ifTrue:[
	^ res @ res
    ].
    ^ self resolution

    "
      Screen current fontResolutionOf:(Screen current getDefaultFontWithEncoding:#'iso10646-1')
    "
!

fullFontNameOf:aFontId
    "the font's fullName - this is very device specific and should only be
     used for user feed-back (for example: in the fontPanel).
     If the display/font does not provide that info, return nil."

    |props fullName|

    props := self fontPropertiesOf:aFontId.
    #('FONT' 'FONT_NAME' 'FULL_NAME' 'FULLNAME' ) do:[:try |
	|fullNameID|

	fullNameID := props at:try ifAbsent:nil.
	fullNameID notNil ifTrue:[
	    fullName := self atomName:fullNameID.
	    fullName notEmptyOrNil ifTrue:[
		^ fullName
	    ].
	]
    ].

    ^ nil.

    "
     Screen current fullFontNameOf:(Screen current getDefaultFontWithEncoding:#'iso10646-1')
    "
!

getAvailableFontsMatching:pattern
    "return an Array filled with font names matching aPattern"

    <context: #return>

%{  /* UNLIMITEDSTACK */

    int nnames = 30000;
    int available = nnames + 1;
    char **fonts;
    OBJ arr, str;
    int i;

    if (ISCONNECTED) {
	if (__isStringLike(pattern)) {
	    for (;;) {
		ENTER_XLIB();
		fonts = XListFonts(myDpy, __stringVal(pattern), nnames, &available);
		LEAVE_XLIB();
		if (fonts == 0) RETURN(nil);
		if (available < nnames) break;
		XFreeFontNames(fonts);
		nnames = available * 2;
	    }

	    /*
	     * now, that we know the number of font names,
	     * create the array ...
	     */
	    arr = __ARRAY_NEW_INT(available);
	    if (arr != nil) {
		/*
		 * ... and fill it
		 */
		for (i=0; i<available; i++) {
		    __PROTECT__(arr);
		    str = __MKSTRING(fonts[i]);
		    __UNPROTECT__(arr);
		    __ArrayInstPtr(arr)->a_element[i] = str; __STORE(arr, str);
		}
	    }
	    XFreeFontNames(fonts);
	    RETURN (arr);
	}
    }
%}.
    ^ nil

    "
      Screen current getAvailableFontsMatching:'*'
    "
!

getDefaultFontWithEncoding:encoding
    "return a default font id - used when class Font cannot
     find anything usable"

    |id|

    id := self createFontFor:'-misc-fixed-*-*-*-*-*-*-*-*-*-*-', encoding.
    id isNil ifTrue:[
	id := self createFontFor:'fixed'
    ].
    ^ id.

     "
       Screen current getDefaultFontWithEncoding:#'iso10646-1'
     "
!

getFontWithFamily:familyString face:faceString
	    style:styleArgString size:sizeArgOrNil sizeUnit:sizeUnit encoding:encoding

    "try to get the specified font, if not available, try next smaller
     font. Access to X-fonts by name is possible, by passing the X font name
     as family and the other parameters as nil. For example, the cursor font
     can be acquired that way."

    |styleString theName theId xlatedStyle
     id spacing encodingMatch idx roundedSize pixelSize pointSize|

    styleString := styleArgString.

    sizeArgOrNil notNil ifTrue:[
	roundedSize := sizeArgOrNil rounded asInteger.
	sizeUnit == #px ifTrue:[
	    pixelSize := roundedSize.
	] ifFalse:[
	    pointSize := roundedSize.
	].
    ].

    "special: if face is nil, allow access to X-fonts"
    faceString isNil ifTrue:[
	roundedSize notNil ifTrue:[
	    theName := familyString , '-' , roundedSize printString
	] ifFalse:[
	    theName := familyString
	].
	theName notNil ifTrue:[
	    theId := self createFontFor:theName.
	].
	theId isNil ifTrue:[
	    theId := self getDefaultFontWithEncoding:encoding
	].
	^ theId
    ].

    "/ spacing other than 'normal' is contained as last component
    "/ in style

    (styleString notNil
     and:[(styleString endsWith:'-narrow')
	  or:[styleString endsWith:'-semicondensed']]) ifTrue:[
	|i|
	i := styleString lastIndexOf:$-.
	spacing := styleString copyFrom:(i+1).
	styleString := styleString copyTo:(i-1).
    ] ifFalse:[
	spacing := 'normal'.
    ].

    xlatedStyle := styleString.
    xlatedStyle notNil ifTrue:[
	xlatedStyle := xlatedStyle first asString
    ].

    encoding isNil ifTrue:[
	encodingMatch := '*-*'.
    ] ifFalse:[
	idx := encoding indexOf:$-.
	idx ~~ 0 ifTrue:[
	    encodingMatch := encoding
	] ifFalse:[
	    encodingMatch := encoding , '-*'.
	].
    ].

    id := self
	    getFontWithFoundry:'*'
	    family:familyString asLowercase
	    weight:faceString
	    slant:xlatedStyle
	    spacing:spacing
	    pixelSize:pixelSize
	    size:pointSize
	    encoding:encodingMatch.

    id isNil ifTrue:[
	(encodingMatch notNil and:[encodingMatch ~= '*']) ifTrue:[
	    "/ too stupid: registries come in both cases
	    "/ and X does not ignore case
	    "/
	    id := self
		    getFontWithFoundry:'*'
		    family:familyString asLowercase
		    weight:faceString
		    slant:xlatedStyle
		    spacing:spacing
		    pixelSize:nil
		    size:roundedSize
		    encoding:encodingMatch asUppercase.
	    id isNil ifTrue:[
		id := self
			getFontWithFoundry:'*'
			family:familyString asLowercase
			weight:faceString
			slant:xlatedStyle
			spacing:spacing
			pixelSize:nil
			size:roundedSize
			encoding:encodingMatch asLowercase.
	    ]
	]
    ].
    ^ id

    "Modified: 4.7.1996 / 11:38:47 / stefan"
    "Modified: 10.4.1997 / 19:20:06 / cg"
!

getFontWithFoundry:foundry family:family weight:weight
	      slant:slant spacing:spc pixelSize:pSize size:size
	      encoding:encoding

    "get the specified font, if not available, return nil.
     Individual attributes can be left empty (i.e. '') or nil to match any.

     foundry: 'adobe', 'misc', 'dec', 'schumacher' ... usually '*'
     family:  'helvetica' 'courier' 'times' ...
     weight:  'bold' 'medium' 'demi' ...
     slant:   'r(oman)' 'i(talic)' 'o(blique)'
     spacing: 'narrow' 'normal' semicondensed' ... usually '*'
     pixelSize: 16,18 ... usually left empty
     size:      size in point (1/72th of an inch)
     encoding:  iso8859-*, iso8859-1, iso10646-1 ... '*'
    "

    |theName sizeMatch
     foundryMatch familyMatch weightMatch slantMatch spcMatch
     pSizeMatch encodingMatch|

    "this works only on 'Release >= 3' - X-servers"
    "name is:
	-foundry-family    -weight -slant-
	 sony    helvetica bold     r
	 adobe   courier   medium   i
	 msic    fixed              o
	 ...     ...
    "

    size isNil ifTrue:[
	sizeMatch := '*'
    ] ifFalse:[
	sizeMatch := size printString , '0'
    ].
    foundry isNil ifTrue:[
	foundryMatch := '*'
    ] ifFalse:[
	foundryMatch := foundry
    ].
    family isNil ifTrue:[
	familyMatch := '*'
    ] ifFalse:[
	familyMatch := family
    ].
    weight isNil ifTrue:[
	weightMatch := '*'
    ] ifFalse:[
	weightMatch := weight
    ].
    slant isNil ifTrue:[
	slantMatch := '*'
    ] ifFalse:[
	slantMatch := slant
    ].
    spc isNil ifTrue:[
	spcMatch := '*'
    ] ifFalse:[
	spcMatch := spc
    ].
    pSize isNil ifTrue:[
	pSizeMatch := '*'
    ] ifFalse:[
	pSizeMatch := pSize printString
    ].
    encoding isNil ifTrue:[
	encodingMatch := '*'
    ] ifFalse:[
	encodingMatch := encoding
    ].

    theName := ('-' , foundryMatch,
		'-' , familyMatch,
		'-' , weightMatch ,
		'-' , slantMatch ,
		'-' , spcMatch ,
		'-*' ,
		'-' , pSizeMatch ,
		'-' , sizeMatch ,
		'-*-*-*-*' ,
		'-' , encodingMatch).

"/  Transcript showCR:theName; endEntry.

    ^ self createFontFor:theName.


    "
     Display
	getFontWithFoundry:'*'
	family:'courier'
	weight:'medium'
	slant:'r'
	spacing:nil
	pixelSize:nil
	size:13
	encoding:#'iso8859-1'.

     Display
	getFontWithFoundry:'*'
	family:'courier'
	weight:'medium'
	slant:'r'
	spacing:nil
	pixelSize:nil
	size:13
	encoding:#'iso10646-1'
    "

    "Modified: 10.4.1997 / 19:15:44 / cg"
!

heightOf:aString from:index1 to:index2 inFont:aFontId
    |resultArray|

    resultArray := Array new:5.
    self extentsOf:aString from:index1 to:index2 inFont:aFontId into:resultArray.
    ^ (resultArray at:4) + (resultArray at:5).

    "
      Screen current
	heightOf:'hello world' from:1 to:10
	inFont:(Screen current  getFontWithFoundry:'*'
		    family:'courier new'
		    weight:'medium'
		    slant:'r'
		    spacing:nil
		    pixelSize:nil
		    size:13
		    encoding:#'iso10646-1'
	    ).

      Screen current
	heightOf:'hello World ggg' from:1 to:15
	inFont:(Screen current getDefaultFontWithEncoding:#'iso10646-1')
    "
!

listOfAvailableFonts
    "return a list with all available fonts on this display.
     Since this takes some time, keep the result of the query for the
     next time. The elements of the returned collection are instances of
     FontDescription."

    |names listOfXftFonts|

    listOfXFonts isNil ifTrue:[
	names := self getAvailableFontsMatching:'*'.
	names isNil ifTrue:[
	    "no names returned ..."
	    ^ nil
	].
	listOfXFonts := names collect:[:aName | self fontDescriptionFromXFontName:aName].
	listOfXFonts := FontDescription genericFonts, listOfXFonts.
    ].

    self supportsXftFonts ifTrue:[
	UserPreferences current useXFontsOnly ifFalse:[
	    listOfXftFonts := XftFontDescription listOfAvailableFonts.

	    UserPreferences current useXftFontsOnly ifTrue:[
		^ listOfXftFonts
	    ].
	    ^ listOfXftFonts , listOfXFonts.
	].
    ].
    ^ listOfXFonts

    "
     Display flushListOfAvailableFonts.
     Display listOfAvailableFonts.

     Display getAvailableFontsMatching:'*'.
     Display getAvailableFontsMatching:'fixed'.
     Display fontsInFamily:'fixed' filtering:nil.
    "

    "Modified: 27.9.1995 / 10:54:47 / stefan"
    "Modified: 17.4.1996 / 15:27:57 / cg"
!

pixelSizesInFamily:aFamilyName face:aFaceName style:aStyleName filtering:filter
    "return a set of all available font sizes in aFamily/aFace/aStyle
     on this display.
     Redefined to handle X's special case of 0-size (which stands for any)"

    |sizes|

    sizes := super pixelSizesInFamily:aFamilyName face:aFaceName style:aStyleName filtering:filter.
    (sizes notNil and:[sizes isEmpty or:[sizes includes:0]]) ifTrue:[
	"special: in X11R5 and above, size 0 means:
	 there are scaled versions in all sizes available"

	^ #(4 5 6 7 8 9 10 11 12 14 16 18 20 22 24 28 32 48 64 72 96 144 192 288)
    ].
    ^ sizes

    "
     Display pixelSizesInFamily:'courier' face:'bold' style:'roman' filtering:nil
    "

    "Created: 27.2.1996 / 01:38:15 / cg"
!

releaseFont:aFontId

    <context: #return>
%{
    XFontStruct *f;

    /*
     * ignore closed connection
     */
    if (! ISCONNECTED) {
	RETURN ( self );
    }

    if (__isExternalAddress(aFontId)) {
	f = __FontVal(aFontId);
	if (f) {

	    ENTER_XLIB();
	    XFreeFont(myDpy, f);
	    LEAVE_XLIB();
#ifdef COUNT_RESOURCES
	    __cnt_font--;
#endif
	}
	RETURN ( self );
    }
%}.
    self primitiveFailed
!

sizesInFamily:aFamilyName face:aFaceName style:aStyleName filtering:filter
    "return a set of all available font sizes in aFamily/aFace/aStyle
     on this display.
     Redefined to handle X's special case of 0-size (which stands for any)"

    |sizes|

    sizes := super sizesInFamily:aFamilyName face:aFaceName style:aStyleName filtering:filter.
    (sizes notNil and:[sizes includes:0]) ifTrue:[
	"special: in X11R5 and above, size 0 means:
	 there are scaled versions in all sizes available"

	^ #(4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 20 22 24 28 32 48 64 72 96 144 192 288)
    ].
    ^ sizes

    "
     Display sizesInFamily:'courier' face:'bold' style:'roman' filtering:nil
    "

    "Created: 27.2.1996 / 01:38:15 / cg"
!

widthOf:aString from:index1 to:index2 inFont:aFontId

    <context: #return>

%{  /* UNLIMITEDSTACK */

    XFontStruct *f;
    char *cp;
    int len, n, i1, i2, l;
#   define NLOCALBUFFER 200
    XChar2b xlatebuffer[NLOCALBUFFER];
    int nInstBytes;
    int directionReturn, fontAscentReturn, fontDescentReturn;
    XCharStruct overAllReturn;

    if (ISCONNECTED) {
	if (__bothSmallInteger(index1, index2)
	 && __isExternalAddress(aFontId)
	 && __isNonNilObject(aString)) {
	    int lMax = __intVal(@global(MaxStringLength));
	    f = __FontVal(aFontId);
	    if (! f) goto fail;

	    i1 = __intVal(index1) - 1;

	    if (i1 >= 0) {
		OBJ cls;

		i2 = __intVal(index2) - 1;
		if (i2 < i1) {
		    RETURN ( __MKSMALLINT(0) );
		}

		cp = (char *) __stringVal(aString);
		l = i2 - i1 + 1;

		if (__isStringLike(aString)) {
		    n = __stringSize(aString);
		    if (i2 < n) {
			cp += i1;

#if 1
			len = XTextExtents(f, cp, l,
						&directionReturn, &fontAscentReturn, &fontDescentReturn,
						&overAllReturn);
			//console_printf("lBear:%d rBear:%d width:%d\n", overAllReturn.lbearing, overAllReturn.rbearing, overAllReturn.width);
			RETURN ( __MKSMALLINT(overAllReturn.width) );
#else
			ENTER_XLIB();
			len = XTextWidth(f, cp, l);
			LEAVE_XLIB();
			RETURN ( __MKSMALLINT(len) );
#endif
		    }
		}

		cls = __qClass(aString);
		nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
		cp += nInstBytes;

		if (__isBytes(aString)) {
		    n = __byteArraySize(aString) - nInstBytes;
		    if (i2 < n) {
			cp += i1;

#if 1
			len = XTextExtents(f, cp, l,
						&directionReturn, &fontAscentReturn, &fontDescentReturn,
						&overAllReturn);
			RETURN ( __MKSMALLINT(overAllReturn.width) );
#else
			ENTER_XLIB();
			len = XTextWidth(f, cp, l);
			LEAVE_XLIB();
			RETURN ( __MKSMALLINT(len) );
#endif
		    }
		}

		/* TWOBYTESTRINGS */
		if (__isWords(aString)) {
		    n = (__byteArraySize(aString) - nInstBytes) / 2;

		    if (i2 < n) {
			union {
			    char b[2];
			    unsigned short s;
			} u;
			int i;
			XChar2b *cp2 = (XChar2b *)0;
			int mustFree = 0;

			cp += (i1 * 2);
			if (l > lMax) l = lMax;

			/*
			 * ST/X TwoByteStrings store the asciiValue in native byteOrder;
			 * X expects them MSB first
			 * convert as required
			 */

			u.s = 0x1234;
			if (u.b[0] != 0x12) {
			    if (l <= NLOCALBUFFER) {
				cp2 = xlatebuffer;
			    } else {
				cp2 = (XChar2b *)(malloc(l * 2));
				mustFree = 1;
			    }
			    for (i=0; i<l; i++) {
				cp2[i].byte1 = (((XChar2b *)cp)[i]).byte2;
				cp2[i].byte2 = (((XChar2b *)cp)[i]).byte1;
			    }
			    cp = (char *) cp2;
			}

#if 1
			len = XTextExtents16(f, (XChar2b *)cp, l,
						&directionReturn, &fontAscentReturn, &fontDescentReturn,
						&overAllReturn);
			len = overAllReturn.width;
#else
			ENTER_XLIB();
			len = XTextWidth16(f, (XChar2b *)cp, l);
			LEAVE_XLIB();
#endif

			if (mustFree) {
			    free(cp2);
			}

			RETURN ( __MKSMALLINT(len) );
		    }
		}
		/* FOURBYTESTRINGS */
		if (__isLongs(aString)) {
		    int i;
		    XChar2b *cp2;
		    int mustFree = 0;

		    n = (__byteArraySize(aString) - nInstBytes) / 4;
		    if (i2 < n) {
			union {
			    char b[2];
			    unsigned short s;
			} u;
			int i;
			XChar2b *cp2 = (XChar2b *)0;
			int mustFree = 0;

			cp += (i1 * 4);
			if (l > lMax) l = lMax;

			/*
			 * For now: X does not support 32bit characters without the new 32Unicode extensions.
			 * For now, treat chars above 0xFFFF as 0xFFFF (should we use default-char ?).
			 */
			if (l <= NLOCALBUFFER) {
			    cp2 = xlatebuffer;
			} else {
			    cp2 = (XChar2b *)(malloc(l * 2));
			    mustFree = 1;
			}
			for (i=0; i<l; i++) {
			    int codePoint;

			    codePoint = ((unsigned int32 *)cp)[i];
			    if (codePoint > 0xFFFF) {
				codePoint = 0xFFFF;
			    }
			    cp2[i].byte1 = codePoint & 0xFF;
			    cp2[i].byte2 = (codePoint >> 8) & 0xFF;;
			}
			cp = (char *) cp2;

#if 1
			len = XTextExtents16(f, (XChar2b *)cp, l,
						&directionReturn, &fontAscentReturn, &fontDescentReturn,
						&overAllReturn);
			len = overAllReturn.width;
#else
			ENTER_XLIB();
			len = XTextWidth16(f, (XChar2b *)cp, l);
			LEAVE_XLIB();
#endif

			if (mustFree) {
			    free(cp2);
			}

			RETURN ( __MKSMALLINT(len) );
		    }
		}
	    }
	}
    }
#undef NLOCALBUFFER
fail: ;
%}.
    self primitiveFailedOrClosedConnection.
    ^ 0
! !

!XWorkstation methodsFor:'grabbing'!

allowEvents:mode
    <context: #return>
%{

    int _mode, ok = 1;

    if (mode == @symbol(asyncPointer))
	_mode = AsyncPointer;
    else if (mode == @symbol(syncPointer))
	_mode = SyncPointer;
    else if (mode == @symbol(asyncKeyboard))
	_mode = AsyncKeyboard;
    else if (mode == @symbol(syncKeyboard))
	_mode = SyncKeyboard;
    else if (mode == @symbol(syncBoth))
	_mode = SyncBoth;
    else if (mode == @symbol(asyncBoth))
	_mode = AsyncBoth;
    else if (mode == @symbol(replayPointer))
	_mode = ReplayPointer;
    else if (mode == @symbol(replayKeyboard))
	_mode = ReplayKeyboard;
    else
	ok = 0;

    if (ok
     && ISCONNECTED) {
	ENTER_XLIB();
	XAllowEvents(myDpy, _mode, CurrentTime);
	LEAVE_XLIB();

	RETURN (self);
    }
%}.
    self primitiveFailedOrClosedConnection
!

grabKeyboardIn:aWindowId
    "grab the keyboard"

    <context: #return>
%{
    int result, ok;

    if (ISCONNECTED) {
	if (__isExternalAddress(aWindowId)) {

	    ENTER_XLIB();
	    result = XGrabKeyboard(myDpy,
				   __WindowVal(aWindowId),
				   True /* False */,
				   GrabModeAsync,
				   GrabModeAsync,
				   CurrentTime);
	    LEAVE_XLIB();

	    ok = 0;
	    switch(result) {
		case AlreadyGrabbed:
		    if (@global(ErrorPrinting) == true) {
			console_fprintf(stderr, "XWorkstation [warning]: grab keyboard: AlreadyGrabbed\n");
		    }
		    break;
		case GrabNotViewable:
		    if (@global(ErrorPrinting) == true) {
			console_fprintf(stderr, "XWorkstation [warning]: grab keyboard: GrabNotViewable\n");
		    }
		    break;
		case GrabInvalidTime:
		    if (@global(ErrorPrinting) == true) {
			console_fprintf(stderr, "XWorkstation [warning]: grab keyboard: InvalidTime\n");
		    }
		    break;
		case GrabFrozen:
		    if (@global(ErrorPrinting) == true) {
			console_fprintf(stderr, "XWorkstation [warning]: grab keyboard: Frozen\n");
		    }
		    break;
		default:
		    ok = 1;
		    break;
	    }
	    if (! ok) {
		ENTER_XLIB();
		XUngrabKeyboard(myDpy, CurrentTime);
		LEAVE_XLIB();
		RETURN (false);
	    }

	    RETURN ( true );
	}
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ false
!

grabPointerIn:aWindowId withCursor:aCursorId eventMask:eventMask pointerMode:pMode keyboardMode:kMode confineTo:confineId
    "grap the pointer - return true if ok"

    <context: #return>
%{

    int result, ok, evMask;
    Window confineWin;
    Cursor curs;
    int pointer_mode, keyboard_mode;

    if (ISCONNECTED) {
	if (__isExternalAddress(aWindowId)) {
	    if (__isExternalAddress(confineId))
		confineWin = __WindowVal(confineId);
	    else
		confineWin = (Window) None;

	    if (__isExternalAddress(aCursorId))
		curs = __CursorVal(aCursorId);
	    else
		curs = (Cursor) None;

	    if (pMode == @symbol(sync))
		pointer_mode = GrabModeSync;
	    else
		pointer_mode = GrabModeAsync;

	    if (kMode == @symbol(sync))
		keyboard_mode = GrabModeSync;
	    else
		keyboard_mode = GrabModeAsync;

	    if (__isSmallInteger(eventMask))
		evMask = __intVal(eventMask);
	    else
		evMask = ButtonPressMask | ButtonMotionMask | PointerMotionMask | ButtonReleaseMask;


/*
	    ENTER_XLIB();
*/
	    result = XGrabPointer(myDpy,
				  __WindowVal(aWindowId),
				  False,
				  evMask,
				  pointer_mode, keyboard_mode,
				  confineWin,
				  curs,
				  CurrentTime);
/*
	    LEAVE_XLIB();
*/


	    ok = 0;
	    switch (result) {
		case AlreadyGrabbed:
		    if (@global(ErrorPrinting) == true) {
			console_fprintf(stderr, "XWorkstation [warning]: grab pointer: AlreadyGrabbed\n");
		    }
		    break;
		case GrabNotViewable:
		    if (@global(ErrorPrinting) == true) {
			console_fprintf(stderr, "XWorkstation [warning]: grab pointer: GrabNotViewable\n");
		    }
		    break;
		case GrabInvalidTime:
		    if (@global(ErrorPrinting) == true) {
			console_fprintf(stderr, "XWorkstation [warning]: grab pointer: InvalidTime\n");
		    }
		    break;
		case GrabFrozen:
		    if (@global(ErrorPrinting) == true) {
			console_fprintf(stderr, "XWorkstation [warning]: grab pointer: Frozen\n");
		    }
		    break;
		default:
		    ok = 1;
		    break;
	    }

	    if (! ok) {
/*
		ENTER_XLIB();
*/
		XUngrabPointer(myDpy, CurrentTime);
/*
		LEAVE_XLIB();
*/
		RETURN (false);
	    }
	    RETURN ( true );
	}
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ false
!

grabPointerIn:aWindowId withCursor:aCursorId pointerMode:pMode keyboardMode:kMode confineTo:confineId
    "grap the pointer - return true if ok"

    ^ self
	grabPointerIn:aWindowId
	withCursor:aCursorId
	eventMask:nil
	pointerMode:pMode
	keyboardMode:kMode
	confineTo:confineId

    "Modified: / 28.7.1998 / 02:47:51 / cg"
!

primUngrabKeyboard
    "release the keyboard"

    <context: #return>
%{

    if (ISCONNECTED) {
	Display *dpy = myDpy;

	ENTER_XLIB();
	XUngrabKeyboard(dpy, CurrentTime);
	XSync(dpy, 0);
	LEAVE_XLIB();

    }
%}.
!

primUngrabPointer
    "release the pointer"

    <context: #return>
%{

    if (ISCONNECTED) {
	Display *dpy = myDpy;

	ENTER_XLIB();
	XUngrabPointer(dpy, CurrentTime);
	XSync(dpy, 0);
	LEAVE_XLIB();

    }
%}.
!

ungrabKeyboard
    "release the keyboard"

    activeKeyboardGrab notNil ifTrue:[
	activeKeyboardGrab := nil.
	self primUngrabKeyboard.
    ]
!

ungrabPointer
    "release the pointer"

    activePointerGrab notNil ifTrue:[
	activePointerGrab := nil.
	self primUngrabPointer.
    ]
! !

!XWorkstation methodsFor:'grabbing-keys'!

grabKey:keySymCodeOrChar modifier:modifierMaskOrNil grabModeKeyboard:modeKbd grabModePointer:modePtr window:aWindowIdOrNil
    "internal basic entry to grab a single key either for an individual window
     or the whole screen (if aWindowIdOrNil is nil).
     The keySymCodeOrChar argument may be a keySym (name of a key) or an integer (the keySymCode)
     or a character.
     The modifierMaskOrNil is as mask as returned by altModifierMask, ctrlModifierMask, etc.
     if nil, the key is grabbed with AnyModifier.
     ModeKbd and modePtr are symbols GrabModeAsync or GrabModeSync.

     After that, this key-event will no longer be sent to the window/screen.

     Use with care: the only useful application is to define a special hotKey
     to start/stop event recorders without a need for a click or focus change.
     Once grabbed, those key events will be exclusively reported to me.

     Use GrabModeSync with big care - you can easily lock up your Xserver,
     and have to kill ST/X or force an ungrab from a remote login if you have.
    "

%{
    int modifierMask = AnyModifier;
    KeySym keySym, *syms;

    if (__isStringLike(keySymCodeOrChar)) {
	keySym = XStringToKeysym(__stringVal(keySymCodeOrChar));
    } else {
	if (__isCharacter(keySymCodeOrChar)) {
	    char s[2];

	    s[0] = __intVal(__characterVal(keySymCodeOrChar));
	    s[1] = '\0';
	    keySym = XStringToKeysym(s);
	} else {
	    if (__isSmallInteger(keySymCodeOrChar)) {
		keySym = (KeySym) __intVal(keySymCodeOrChar);
	    } else {
		goto notOK;
	    }
	}
    }

    if (modifierMaskOrNil != nil) {
	if (__isSmallInteger(modifierMaskOrNil)) {
	    modifierMask = __intVal(modifierMaskOrNil);
	} else {
	    goto notOK;
	}
    }

    if (ISCONNECTED) {
	Display *dpy;
	Window window;
	int keyCode;
	int result;
	int mKbd, mPtr;

	mKbd = modeKbd == @symbol(GrabModeAsync) ? GrabModeAsync :GrabModeSync;
	mPtr = modePtr == @symbol(GrabModeAsync) ? GrabModeAsync :GrabModeSync;

	dpy = myDpy;
	keyCode = XKeysymToKeycode(dpy, keySym);
	if (__isExternalAddress(aWindowIdOrNil)) {
	    window = __WindowVal(aWindowIdOrNil);
	} else {
	    int screen;

	    screen = DefaultScreen(dpy);
	    window = RootWindow(dpy, screen);
	}
	ENTER_XLIB();

	result = XGrabKey (dpy,
	    keyCode, modifierMask, window,
	    False, mKbd, mPtr );

	XSync(dpy, True);
	XFlush(dpy);

	LEAVE_XLIB();

	if (result != Success) {
	    if (result == BadAccess) {
		__INST(lastError) = @symbol(badAccess);
	    } else {
		__INST(lastError) = @symbol(other);
	    }
	    RETURN (false);
	}
	RETURN (true);
    }
  notOK: ;
%}.
    self primitiveFailedOrClosedConnection
!

grabKey:keySymCodeOrChar modifier:modifierMaskOrNil window:aWindowIdOrNil
    "grab a single key either for an individual window
     or the whole screen (if aWindowIdOrNil is nil).
     The keySymCodeOrChar argument may be a keySym (name of a key) or an integer (the keySymCode)
     or a character.
     The modifierMaskOrNil is as mask as returned by altModifierMask, ctrlModifierMask, etc.
     if nil, the key is grabbed with AnyModifier.
     Only the key is passed to myself - no permanent grab is installed.
     (GrabModeAsync)"

    ^ self
	grabKey:keySymCodeOrChar
	modifier:modifierMaskOrNil
	grabModeKeyboard:#GrabModeAsync
	grabModePointer:#GrabModeAsync
	window:aWindowIdOrNil
!

ungrabKey:keySymCodeOrChar modifier:modifierMaskOrNil window:aWindowIdOrNil
    "ungrab a single key as previously grabbed via grabKey:
     Read the comment there."

%{
    int modifierMask = AnyModifier;
    KeySym keySym, *syms;

    if (__isStringLike(keySymCodeOrChar)) {
	keySym = XStringToKeysym(__stringVal(keySymCodeOrChar));
    } else {
	if (__isCharacter(keySymCodeOrChar)) {
	    char s[2];

	    s[0] = __intVal(__characterVal(keySymCodeOrChar));
	    s[1] = '\0';
	    keySym = XStringToKeysym(s);
	} else {
	    if (__isSmallInteger(keySymCodeOrChar)) {
		keySym = (KeySym) __intVal(keySymCodeOrChar);
	    } else {
		goto notOK;
	    }
	}
    }

    if (modifierMaskOrNil != nil) {
	if (__isSmallInteger(modifierMaskOrNil)) {
	    modifierMask = __intVal(modifierMaskOrNil);
	} else {
	    goto notOK;
	}
    }

    if (ISCONNECTED) {
	Display *dpy;
	Window window;
	int keyCode;
	int result;

	dpy = myDpy;
	if (__isExternalAddress(aWindowIdOrNil)) {
	    window = __WindowVal(aWindowIdOrNil);
	} else {
	    int screen;

	    screen = DefaultScreen(dpy);
	    window = RootWindow(dpy, screen);
	}
	keyCode = XKeysymToKeycode(dpy, keySym);

	ENTER_XLIB();

	result = XUngrabKey (dpy, keyCode, modifierMask, window);

	XSync(dpy, True);
	XFlush(dpy);

	LEAVE_XLIB();

	if (result != Success) {
	    if (result == BadAccess) {
		__INST(lastError) = @symbol(badAccess);
	    } else {
		__INST(lastError) = @symbol(other);
	    }
	    RETURN (false);
	}
	RETURN (true);
    }
  notOK: ;
%}.
    self primitiveFailedOrClosedConnection
! !

!XWorkstation methodsFor:'graphic context stuff'!

noClipIn:aDrawableId gc:aGCId
    "disable clipping rectangle"

    <context: #return>
%{

    XGCValues gcv;
    GC gc;

    if (ISCONNECTED) {
	if (__isExternalAddress(aGCId)) {
	    gc = __GCVal(aGCId);
	    gcv.clip_mask = None;
	    ENTER_XLIB();
	    XChangeGC(myDpy, gc, GCClipMask, &gcv);
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
%}.
    self primitiveFailedOrClosedConnection
!

setBackground:bgColorIndex in:aGCId
    "set background color to be drawn with"

    <context: #return>
%{

    if (ISCONNECTED) {
	if (__isExternalAddress(aGCId)
	 && __isSmallInteger(bgColorIndex)) {
	    ENTER_XLIB();
	    XSetBackground(myDpy, __GCVal(aGCId), __intVal(bgColorIndex));
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
%}.
    self primitiveFailedOrClosedConnection
!

setBitmapMask:aBitmapId in:aGCId
    "set or clear the drawing mask - a bitmap mask using current fg/bg"

    <context: #return>
%{

    GC gc;
    Pixmap bitmap;

    if (ISCONNECTED) {
	Display *dpy = myDpy;

	if (__isExternalAddress(aGCId)) {
	    gc = __GCVal(aGCId);
	    if (__isExternalAddress(aBitmapId)) {
		bitmap = __PixmapVal(aBitmapId);
		ENTER_XLIB();
		XSetStipple(dpy, gc, bitmap);
		XSetFillStyle(dpy, gc, FillOpaqueStippled);
		LEAVE_XLIB();
		RETURN ( self );
	    }
	    if (aBitmapId == nil) {
		ENTER_XLIB();
		XSetFillStyle(dpy, gc, FillSolid);
		LEAVE_XLIB();
		RETURN ( self );
	    }
	}
    }
%}.
    self primitiveFailedOrClosedConnection
!

setClipByChildren:aBool in:aDrawableId gc:aGCId
    "enable/disable drawing into child views"

    <context: #return>
%{

    XGCValues gcv;
    GC gc;

    if (ISCONNECTED) {
	if (__isExternalAddress(aGCId)) {
	    gc = __GCVal(aGCId);
	    if (aBool == true)
		gcv.subwindow_mode = ClipByChildren;
	    else
		gcv.subwindow_mode = IncludeInferiors;

	    ENTER_XLIB();
	    XChangeGC(myDpy, gc, GCSubwindowMode, &gcv);
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
%}.
    self primitiveFailedOrClosedConnection
!

setClipX:clipX y:clipY width:clipWidth height:clipHeight in:drawableId gc:aGCId
    "clip to a rectangle"

    <context: #return>
%{

    XRectangle r;

    if (ISCONNECTED) {
	if (__isExternalAddress(aGCId)
	 && __bothSmallInteger(clipX, clipY)
	 && __bothSmallInteger(clipWidth, clipHeight)) {
	    r.x = __intVal(clipX);
	    r.y = __intVal(clipY);
	    r.width = __intVal(clipWidth);
	    r.height = __intVal(clipHeight);
	    ENTER_XLIB();
	    XSetClipRectangles(myDpy, __GCVal(aGCId), 0, 0, &r, 1, Unsorted);
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
%}.
    self primitiveFailedOrClosedConnection
!

setDashes:dashList dashOffset:offset in:aGCId
    "set line attributes"

    <context: #return>
%{

    if (ISCONNECTED) {
	if (__isExternalAddress(aGCId)
	 && __isSmallInteger(offset)
	 && __isByteArrayLike(dashList)) {
	    ENTER_XLIB();
	    XSetDashes(myDpy, __GCVal(aGCId),
		       __intVal(offset),
		       __ByteArrayInstPtr(dashList)->ba_element,
		       __byteArraySize(dashList));
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
bad: ;
%}.
    "
     either aGCId is invalid,
     and/or dashList is not a byteArray
     and/or offset is not a smallInteger
    "
    self primitiveFailedOrClosedConnection
!

setFont:aFontId in:aGCId
    "set font to be drawn in"

    <context: #return>
%{

    XFontStruct *f;

    if (ISCONNECTED) {
	if (__isExternalAddress(aFontId)
	 && __isExternalAddress(aGCId)) {
	    f = (XFontStruct *) __FontVal(aFontId);
	    ENTER_XLIB();
	    XSetFont(myDpy, __GCVal(aGCId), f->fid);
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
%}.
    "
     aGCId and/or aFontId are invalid
    "
    self primitiveFailedOrClosedConnection
!

setForeground:fgColorIndex background:bgColorIndex in:aGCId
    "set foreground and background colors to be drawn with"

    <context: #return>
%{

    GC gc;

    if (ISCONNECTED) {
	Display *dpy = myDpy;
	if (__bothSmallInteger(fgColorIndex, bgColorIndex)
	 && __isExternalAddress(aGCId)) {
	    gc = __GCVal(aGCId);

	    ENTER_XLIB();
	    XSetForeground(dpy, gc, __intVal(fgColorIndex));
	    XSetBackground(dpy, gc, __intVal(bgColorIndex));
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
%}.
    self primitiveFailedOrClosedConnection
!

setForeground:fgColorIndex in:aGCId
    "set foreground color to be drawn with"

    <context: #return>
%{

    if (ISCONNECTED) {
	if (__isExternalAddress(aGCId)
	 && __isSmallInteger(fgColorIndex)) {
	    ENTER_XLIB();
	    XSetForeground(myDpy, __GCVal(aGCId), __intVal(fgColorIndex));
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
%}.
    self primitiveFailedOrClosedConnection
!

setFunction:aFunctionSymbol in:aGCId
    "set alu function to be drawn with"

    <context: #return>
%{
    int fun = -1;

    if (ISCONNECTED) {
	if (__isExternalAddress(aGCId)) {
	    GC gc = __GCVal(aGCId);
	    if (aFunctionSymbol == @symbol(copy)) fun = GXcopy;
	    else if (aFunctionSymbol == @symbol(copyInverted)) fun = GXcopyInverted;
	    else if (aFunctionSymbol == @symbol(xor)) fun = GXxor;
	    else if (aFunctionSymbol == @symbol(and)) fun = GXand;
	    else if (aFunctionSymbol == @symbol(andReverse)) fun = GXandReverse;
	    else if (aFunctionSymbol == @symbol(andInverted)) fun = GXandInverted;
	    else if (aFunctionSymbol == @symbol(or)) fun = GXor;
	    else if (aFunctionSymbol == @symbol(orReverse)) fun = GXorReverse;
	    else if (aFunctionSymbol == @symbol(orInverted)) fun = GXorInverted;
	    else if (aFunctionSymbol == @symbol(invert)) fun = GXinvert;
	    else if (aFunctionSymbol == @symbol(clear)) fun = GXclear;
	    else if (aFunctionSymbol == @symbol(set)) fun = GXset;
	    else if (aFunctionSymbol == @symbol(noop)) fun = GXnoop;
	    else if (aFunctionSymbol == @symbol(equiv)) fun = GXequiv;
	    else if (aFunctionSymbol == @symbol(nand)) fun = GXnand;
	    if (fun != -1) {
		ENTER_XLIB();
		XSetFunction(myDpy, gc, fun);
		LEAVE_XLIB();
		RETURN ( self );
	    }
	}
    }
%}.
    "
     either aGCId is not an integer, or an invalid symbol
     was passed ... valid functions are #copy, #copyInverted, #xor, #and, #andReverse,
     #andInverted, #or, #orReverse, #orInverted. See Xlib documentation for more details.
    "
    self primitiveFailedOrClosedConnection
!

setGraphicsExposures:aBoolean in:aGCId
    "set or clear the graphics exposures flag"

    <context: #return>
%{

    if (ISCONNECTED) {
	if (__isExternalAddress(aGCId)) {
	    ENTER_XLIB();
	    XSetGraphicsExposures(myDpy, __GCVal(aGCId), (aBoolean==true)?1:0);
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
%}.
    self primitiveFailedOrClosedConnection
!

setLineWidth:aNumber style:lineStyle cap:capStyle join:joinStyle in:aGCId
    "set line attributes;
     lineStyle must be one of #solid, #dashed or #doubleDashed;
     capStyle one of: #notLast, #butt, #round or #projecting;
     joinStyle one of: #miter, #bevel or #round."

    <context: #return>
%{

    int x_style, x_cap, x_join;
    static char dotList[2] = { 1,1 };
    static char dashList[2]  = { 4,4 };
    static char dashDotList[4]    = { 4,1 , 1,1 };
    static char dashDotDotList[6] = { 4,1 , 1,1 , 1,1 };
    char *x_dashes = 0;
    int x_nDash;

    if (ISCONNECTED) {
	if (__isExternalAddress(aGCId)
	 && __isSmallInteger(aNumber)) {
	    Display *dpy = myDpy;

	    if (lineStyle == @symbol(solid)) {
		x_dashes = (char *)0;
		x_style = LineSolid;
	    } else if (lineStyle == @symbol(dashed)) {
		x_dashes = dashList;
		x_nDash = sizeof(dashList);
		x_style = LineOnOffDash;
	    } else if (lineStyle == @symbol(doubleDashed)) {
		x_dashes = dashList;
		x_nDash = sizeof(dashList);
		x_style = LineDoubleDash;
	    } else if (lineStyle == @symbol(dotted)) {
		x_dashes = dotList;
		x_nDash = sizeof(dotList);
		x_style = LineOnOffDash;
	    } else if (lineStyle == @symbol(dashDot)) {
		x_dashes = dashDotList;
		x_nDash = sizeof(dashDotList);
		x_style = LineOnOffDash;
	    } else if (lineStyle == @symbol(dashDotDot)) {
		x_dashes = dashDotDotList;
		x_nDash = sizeof(dashDotDotList);
		x_style = LineOnOffDash;
	    } else goto bad;

	    if (capStyle == @symbol(notLast)) x_cap = CapNotLast;
	    else if (capStyle == @symbol(butt)) x_cap = CapButt;
	    else if (capStyle == @symbol(round)) x_cap  = CapRound;
	    else if (capStyle == @symbol(projecting)) x_cap  = CapProjecting;
	    else goto bad;

	    if (joinStyle == @symbol(miter)) x_join = JoinMiter;
	    else if (joinStyle == @symbol(bevel)) x_join = JoinBevel;
	    else if (joinStyle == @symbol(round)) x_join  = JoinRound;
	    else goto bad;

	    ENTER_XLIB();
	    if (x_dashes) {
		XSetDashes(dpy, __GCVal(aGCId), 0, x_dashes, x_nDash);
	    }
	    XSetLineAttributes(dpy,
			       __GCVal(aGCId), __intVal(aNumber),
			       x_style, x_cap, x_join);
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
bad: ;
%}.
    "
     either aGCId is invalid,
     and/or lineWidth is not a smallInteger,
     and/or lineStyle is none of #solid, #dashed, #doubleDashed
     and/or capStyle is none of #notLast, #butt, #round, #projecting
     and/or joinStyle is none of #miter, #bevel, #round
    "
    self primitiveFailedOrClosedConnection
!

setMaskOriginX:orgX y:orgY in:aGCid
    "set the mask origin"

    <context: #return>
%{

    if (ISCONNECTED) {
	if (__bothSmallInteger(orgX, orgY) && __isExternalAddress(aGCid)) {
	    ENTER_XLIB();
	    XSetTSOrigin(myDpy, __GCVal(aGCid), __intVal(orgX), __intVal(orgY));
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
%}.
    self primitiveFailedOrClosedConnection
!

setPixmapMask:aPixmapId in:aGCId
    "set or clear the drawing mask - a pixmap mask providing full color"

    <context: #return>
%{

    GC gc;
    Pixmap pixmap;

    if (ISCONNECTED) {
	Display *dpy = myDpy;

	if (__isExternalAddress(aGCId)) {
	    gc = __GCVal(aGCId);
	    if (__isExternalAddress(aPixmapId)) {
		pixmap = __PixmapVal(aPixmapId);
		ENTER_XLIB();
		XSetTile(dpy, gc, pixmap);
		XSetFillStyle(dpy, gc, FillTiled);
		LEAVE_XLIB();
		RETURN ( self );
	    }
	    if (aPixmapId == nil) {
		ENTER_XLIB();
		XSetFillStyle(dpy, gc, FillSolid);
		LEAVE_XLIB();
		RETURN ( self );
	    }
	}
    }
%}.
    self primitiveFailedOrClosedConnection
!

setPlaneMask:bits in:aGCId
    "set foreground color to be drawn with"

    <context: #return>
%{
    if (ISCONNECTED) {
	if (__isExternalAddress(aGCId)
	 && __isSmallInteger(bits)) {
	    unsigned long mask = __intVal(bits);
	    if (__intVal(bits) == -1) {
		mask = AllPlanes;
	    }
	    ENTER_XLIB();
	    XSetPlaneMask(myDpy, __GCVal(aGCId), mask);
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
%}.
    self primitiveFailedOrClosedConnection
! !

!XWorkstation methodsFor:'initialization & release'!

closeConnection
    "close down the connection to the X-server"

    <context: #return>

"/ 'closing' errorPrintCR.
"/ thisContext fullPrintAll.

%{ /* UNLIMITEDSTACK */   /* calls XSync()! */
    if (ISCONNECTED) {
	Display *dpy = myDpy;


	__INST(displayId) = nil;
	ENTER_XLIB();
	XCloseDisplay(dpy);
	LEAVE_XLIB();
    }
%}
!

emergencyCloseConnection
    "low level close of the displays connection (without sending any buffered
     requests to the display). Only used in case of emergency (brokenConnection)"

%{
    if (ISCONNECTED) {
	Display *dpy = myDpy;

	__INST(displayId) = nil;
	close(ConnectionNumber(dpy));
    }
%}
!

eventBufferSize
%{
    RETURN ( __MKSMALLINT(sizeof(XEvent) + 100) );
%}
!

getWindowGroupWindow
    "Creates a fake WindowGroup view. This window is used
     in XWMHints & _NET_WM_LEADER properties to define
     application window group"

    windowGroupWindow isNil ifTrue:[
	windowGroupWindow := WindowGroupWindow new create.
    ].
    ^ windowGroupWindow
!

initializeDefaultValues
    activateOnClick := false.
    maxOperationsUntilFlush := nil.

    super initializeDefaultValues.

    "JV@2012: On X11, mouse buttons are: left=1, middle=2, right=3
    Even on 2-button mouse (button 2 is simply not reported).
    Here the middle button is mapped to button #paste (which in EditTextView
    pastes the PRIMARY selection). 128 is here to make clear that this
    is somewhat special value.

    This remapping kludge is here to have all the widget's code backward/windows
    compatible while still having X11's middle button behavior.

    Also note that buttonTranslation is overwritten in display.rc,
    the code is here just for a case display.rc is not read/available
    and for documentation (symbol references does not search .rc files).
    "

    buttonTranslation := buttonTranslation copy.
    buttonTranslation at: 2 put: #paste.

    "
    Cache hostname in order to set WM_CLIENT_MACHINE 
    (defined by ICCCM, Section 4.1.2.9)
    "
    hostname := OperatingSystem getHostName.

    "
    Create (and cache) class and name for WM_CLASS property. 
    (defined by ICCCM, Section 4.1.2.5. WM_CLASS Property)
    "
    wmClassName := OperatingSystem getEnvironment: 'RESOURCE_NAME'.
    wmClassName isNil ifTrue:[
	wmClassName := Smalltalk commandName.
	"/ strip of any directory names
	wmClassName := wmClassName copyFrom: (wmClassName lastIndexOf: Filename separator) + 1.
    ].
    (wmClassName = 'stx' or:[wmClassName = 'stx-bin']) ifTrue:[
    	wmClassName  := 'smalltalkx'.
	wmClassClass := 'SmalltalkX'.
    ] ifFalse:[
	wmClassClass := wmClassName asUppercaseFirst.
    ].
    "
    Cache pid in order to set _NET_WM_PID properu
    (defined by EWMH, Section Application Window Properties
    "
    pid := OperatingSystem getProcessId.

    "Modified (comment): / 17-04-2012 / 21:18:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeDeviceSignals
    super initializeDeviceSignals.

    deviceIOTimeoutErrorSignal := deviceIOErrorSignal newSignal.
    deviceIOTimeoutErrorSignal nameClass:self message:#deviceIOTimeoutErrorSignal.

    ObjectMemory registerErrorInterruptHandler:self class forID:#DisplayError.
    ObjectMemory registerErrorInterruptHandler:self class forID:#DisplayIOError.
    ObjectMemory registerErrorInterruptHandler:self class forID:#DisplayIOTimeoutError.
!

initializeFor:aDisplayName
    "initialize the receiver for a connection to an X-Server;
     the argument, aDisplayName may be nil (for the default server from
     DISPLAY-variable or command line argument) or the name of the server
     as hostname:number"

    displayId notNil ifTrue:[
	"/ already connected - you bad guy try to trick me manually ?
	^ self
    ].

    displayId := self openConnectionTo:aDisplayName.
    displayId isNil ifTrue:[
	"/ could not connect.
	DeviceOpenErrorSignal raiseWith:aDisplayName.
	^ nil
    ].

    xlibTimeout := xlibTimeout ? DefaultXLibTimeout.
    xlibTimeoutForWindowCreation := xlibTimeoutForWindowCreation ? DefaultXLibTimeoutForWindowCreation.
    hasConnectionBroken := false.

    dispatching := false.
    dispatchingExpose := false.
    isSlow := false.
    shiftDown := false.
    ctrlDown := false.
    metaDown := false.
    altDown := false.
    motionEventCompression := true.
    buttonsPressed := 0.
    displayName := aDisplayName.

    listOfXFonts := nil.

    atoms := nil.

    "These values are initialized by primitive code in #createWindowFor:..."
    protocolsAtom := nil.
    deleteWindowAtom := nil.
    saveYourselfAtom := nil.
    quitAppAtom := nil.

    self initializeDeviceResourceTables.
    self initializeScreenProperties.

    self initializeDefaultValues.
    self initializeSpecialFlags.
    self initializeKeyboardMap.
    self initializeDeviceSignals.

    Screen default isNil ifTrue:[
	"not initialized yet?"
	self initializeViewStyle.
    ].
!

initializeModifierMappings
    "initialize keyboard modifiers.
     We assume that mod1 are the META modifiers and mod2 are the ALT modifiers,
     but if any of them contains the Num_Lock key, it is disregarded."

    |map|

    super initializeModifierMappings.

    rawKeySymTranslation := RawKeySymTranslation.

    map := self modifierMapping.
    map isNil ifTrue:[
	"/
	"/ mhmh - a crippled Xlib which does not provide modifier mappings
	"/ setup some reasonable default. If that is not sufficient,
	"/ you have to change things from your display.rc file.
	"/
	altModifierMask := self modifier1Mask.
	metaModifierMask := self modifier2Mask.
    ] ifFalse:[
	| mod symbolFromKeyCode nonNilOnes |

	altModifierMask := 0.
	metaModifierMask := 0.

	symbolFromKeyCode := [:key | self symbolFromKeycode:key].
	nonNilOnes := [:str | str notNil].

	mod := map at:1.
	mod notNil ifTrue:[
	    shiftModifiers := mod collect:symbolFromKeyCode thenSelect:nonNilOnes.
	].
	mod := map at:3.
	mod notNil ifTrue:[
	    ctrlModifiers  := mod collect:symbolFromKeyCode thenSelect:nonNilOnes.
	].
	mod := map at:4.
	mod notNil ifTrue:[
	    mod := mod collect:symbolFromKeyCode thenSelect:nonNilOnes.
	    (mod includes:#'Num_Lock') ifFalse:[
		metaModifiers := mod.
		metaModifierMask := 1 bitShift:(4-1).
	    ].
	].
	mod := map at:5.
	mod notNil ifTrue:[
	    mod := mod collect:symbolFromKeyCode thenSelect:nonNilOnes.
	    (mod includes:#'Num_Lock') ifFalse:[
		altModifiers   := mod.
		altModifierMask := 1 bitShift:(5-1).
	    ].
	]
    ].

    "
     Display initializeModifierMappings
    "

    "Modified: 1.12.1995 / 23:44:40 / stefan"
!

initializeScreenBounds
    self isXineramaActive ifTrue:[
	|rect|

	self monitorBounds do:[:eachRect|
	    rect isNil ifTrue:[
		rect := eachRect.
	    ] ifFalse:[
		rect := rect merge:eachRect.
	    ]
	].
	width := rect width.
	height := rect height.

	"propagate possible size changes to our rottView"
	rootView notNil ifTrue:[
	    rootView initialize.
	].
    ] ifFalse:[
	width := self queryWidth.
	height := self queryHeight.
    ].
    widthMM := self queryWidthMM.
    heightMM := self queryHeightMM.

    "
      Display initializeScreenBounds
    "
!

initializeScreenProperties
    |masks|

    super initializeScreenProperties.

    hasShapeExtension := self hasExtension:#SHAPE.
    hasShmExtension := self hasExtension:#'MIT-SHM'.
    hasDPSExtension := self hasExtension:#DPS.
    hasXVideoExtension := self hasExtension:#XVideo.
    hasMbufExtension := self hasExtension:#'Multi-Buffering'.
    hasPEXExtension := self hasExtension:#'X3D-PEX'.
    hasImageExtension := self hasExtension:#XIE.
    hasInputExtension := self hasExtension:#XInputExtension.
    hasXineramaExtension := self hasExtension:#XINERAMA.
    hasRenderExtension := self hasExtension:#RENDER.
    hasXftLibrary := hasRenderExtension and:[self class hasXftLibrary].

    primaryAtom := self atomIDOf:#PRIMARY.
    stringAtom := self atomIDOf:#STRING.
    clipboardAtom := self atomIDOf:#CLIPBOARD.

    altModifierMask := self modifier2Mask.
    metaModifierMask := self modifier1Mask.

    screen := self queryDefaultScreen.

    self initializeScreenBounds.

    depth := self queryDepth.
    ncells := self queryCells.
    blackpixel := self queryBlackPixel.
    whitepixel := self queryWhitePixel.

    monitorType := #unknown.
    visualType := self queryDefaultVisualType.

    hasColors := hasGreyscales := true.
    (visualType == #StaticGray
     or:[ visualType == #GrayScale]) ifTrue:[
	hasColors := false.
	monitorType := #monochrome.
    ].

    ncells == 2 ifTrue:[
	hasColors := hasGreyscales := false.
    ].

    masks := self queryRGBMasks.
    redMask := masks at:1.
    greenMask := masks at:2.
    blueMask := masks at:3.
    bitsPerRGB := masks at:4.

    visualType == #TrueColor ifTrue:[
	redShift := redMask lowBit - 1.
	greenShift := greenMask lowBit - 1.
	blueShift := blueMask lowBit - 1.

	bitsRed := redMask highBit - redMask lowBit + 1.
	bitsGreen := greenMask highBit - greenMask lowBit + 1.
	bitsBlue := blueMask highBit - blueMask lowBit + 1.
    ].

%{

    Display *dpy;
    int scr;
    Visual *visual;
    XVisualInfo viproto;
    XVisualInfo *vip;                   /* returned info */
    int maxRGBDepth, maxRGBADepth;
    int rgbRedMask, rgbGreenMask, rgbBlueMask;
    int rgbaRedMask, rgbaGreenMask, rgbaBlueMask, rgbaAlphaMask;
    int rgbVisualID, rgbaVisualID;
    int nvi, i;
    char *type, *nm;
    int dummy;

    if (ISCONNECTED) {
	dpy = myDpy;

	/*
	 * look for RGB visual with the highest depth
	 */
	nvi = 0;
	viproto.screen = scr;
	vip = XGetVisualInfo (dpy, VisualScreenMask, &viproto, &nvi);
	maxRGBDepth = maxRGBADepth = 0;
	for (i = 0; i < nvi; i++) {
	    int thisDepth = vip[i].depth;

	    switch (vip[i].class) {
		case TrueColor:
		    if (thisDepth > maxRGBDepth) {
			if (thisDepth <= 24) {
			    maxRGBDepth = thisDepth;
			    rgbRedMask = vip[i].red_mask;
			    rgbGreenMask = vip[i].green_mask;
			    rgbBlueMask = vip[i].blue_mask;
			    rgbVisualID = vip[i].visualid;
			} else {
			    if (thisDepth > maxRGBADepth) {
				// printf("found rgba visual!\n");
				maxRGBADepth = thisDepth;
				rgbaRedMask = vip[i].red_mask;
				rgbaGreenMask = vip[i].green_mask;
				rgbaBlueMask = vip[i].blue_mask;
				rgbaVisualID = vip[i].visualid;
			    }
			}
		    }
		    break;
	    }
	}
	if (vip) XFree ((char *) vip);

	if (maxRGBDepth) {
	    __INST(rgbVisual) = __MKEXTERNALADDRESS(rgbVisualID); __STORESELF(rgbVisual);
	}
	if (maxRGBADepth) {
	    __INST(rgbaVisual) = __MKEXTERNALADDRESS(rgbaVisualID); __STORESELF(rgbaVisual);
	    if (!maxRGBDepth) {
		__INST(rgbVisual) = __INST(rgbaVisual); __STORESELF(rgbVisual);
	    }
	}

    }
#ifdef SHM
    if (__INST(hasShmExtension) == true) {
        ShmCompletionType = XShmGetEventBase(dpy) + ShmCompletion;
    }
#endif    

%}.
!

initializeSpecialFlags
    "perform additional special server implementation flags"

    "/
    "/ assume we have it ... (should check)
    "/
    hasSaveUnder := true.
    ignoreBackingStore := false.

    (self serverVendor = 'X11/NeWS') ifTrue:[
	"/
	"/ this is a kludge around a bug in the X11/NeWS server,
	"/ which does not correctly handle saveUnder
	"/
	hasSaveUnder := false.
    ].
!

initializeUniqueID
    uniqueDeviceID isNil ifTrue:[
	uniqueDeviceID := UUID genUUID.
    ]
!

invalidateConnection
    super invalidateConnection.

    "the new display may support a different set of fonts"
    self flushListOfAvailableFonts
!

openConnectionTo:dpyName
    "open a connection to some display;
     return the displayId if ok, nil of not ok"

%{ /* STACK:100000 */    /* XOpenDisplay() calls gethostbyname() */
    Display *dpy;
    int i;
    char *nm;

    if (__isStringLike(dpyName))
	nm = (char *) __stringVal(dpyName);
    else {
	nm = NULL;
    }
    dpy = XOpenDisplay(nm);

    if (dpy) {
	static int firstCall = 1;
	OBJ dpyID;

	dpyID = __MKEXTERNALADDRESS(dpy);

	if (firstCall) {
	    firstCall = 0;
	    XSetErrorHandler(__XErrorHandler__);
	    XSetIOErrorHandler(__XIOErrorHandler__);
	}
	RETURN (dpyID);
    }
%}.
    ^ nil
!

queryBlackPixel
%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	Display *dpy;
	int scr;

	dpy = myDpy;
	scr = DefaultScreen(dpy);
	RETURN ( __MKSMALLINT(BlackPixel(dpy, scr)));
    }
%}.
    ^ nil

    "
     Display queryBlackPixel
    "
!

queryCells
%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	Display *dpy;
	int scr;

	dpy = myDpy;
	scr = DefaultScreen(dpy);
	RETURN ( __MKSMALLINT(DisplayCells(dpy, scr)));
    }
%}.
    ^ nil

    "
     Display queryCells
    "
!

queryDefaultScreen
%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	Display *dpy;

	dpy = myDpy;
	RETURN ( __MKSMALLINT(DefaultScreen(dpy)));
    }
%}.
    ^ nil

    "
     Display queryDefaultScreen
    "
!

queryDefaultVisual
%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	Display *dpy;
	Visual *visual;

	dpy = myDpy;
	visual = DefaultVisualOfScreen(DefaultScreenOfDisplay(dpy));
	RETURN ( __MKEXTERNALADDRESS( visual ) );
    }
%}.
    ^ nil

    "
     Display queryDefaultVisual
    "

    "Created: / 22-09-2014 / 10:05:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

queryDefaultVisualType
%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	Display *dpy;
	Visual *visual;

	dpy = myDpy;
	visual = DefaultVisualOfScreen(DefaultScreenOfDisplay(dpy));
	switch (visual->class) {
	    case StaticGray:
		RETURN ( @symbol(StaticGray) );
	    case GrayScale:
		RETURN ( @symbol(GrayScale) );
	    case StaticColor:
		RETURN ( @symbol(StaticColor) );
	    case PseudoColor:
		RETURN ( @symbol(PseudoColor) );
	    case TrueColor:
		RETURN ( @symbol(TrueColor) );
	    case DirectColor:
		RETURN ( @symbol(DirectColor) );
	}
    }
%}.
    ^ nil

    "
     Display queryDefaultVisualType
    "
!

queryDepth
%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	Display *dpy;
	int scr;

	dpy = myDpy;
	scr = DefaultScreen(dpy);
	RETURN ( __MKSMALLINT(DisplayPlanes(dpy, scr)));
    }
%}.
    ^ nil

    "
     Display queryDepth
    "
!

queryHeight
%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	Display *dpy;
	int scr;

	dpy = myDpy;
	scr = DefaultScreen(dpy);
	RETURN ( __MKSMALLINT(DisplayHeight(dpy, scr)));
    }
%}.
    ^ nil

    "
     Display queryHeight
    "
!

queryHeightMM
%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	Display *dpy;
	int scr;

	dpy = myDpy;
	scr = DefaultScreen(dpy);
	RETURN ( __MKSMALLINT(DisplayHeightMM(dpy, scr)));
    }
%}.
    ^ nil

    "
     Display queryHeightMM
    "
!

queryRGBMasks
%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	Display *dpy;
	Visual *visual;
	OBJ redMask, greenMask, blueMask, bprgb;

	dpy = myDpy;
	visual = DefaultVisualOfScreen(DefaultScreenOfDisplay(dpy));
	redMask   = __MKSMALLINT(visual->red_mask);
	greenMask = __MKSMALLINT(visual->green_mask);
	blueMask  = __MKSMALLINT(visual->blue_mask);
	bprgb  = __MKSMALLINT(visual->bits_per_rgb);
	RETURN ( __ARRAY_WITH4(redMask, greenMask, blueMask, bprgb) );
    }
%}.
    ^ nil

    "
     Display queryRGBMasks
    "
!

queryWhitePixel
%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	Display *dpy;
	int scr;

	dpy = myDpy;
	scr = DefaultScreen(dpy);
	RETURN ( __MKSMALLINT(WhitePixel(dpy, scr)));
    }
%}.
    ^ nil

    "
     Display queryWhitePixel
    "
!

queryWidth
%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	Display *dpy;
	int scr;

	dpy = myDpy;
	scr = DefaultScreen(dpy);
	RETURN ( __MKSMALLINT(DisplayWidth(dpy, scr)));
    }
%}.
    ^ nil

    "
     Display queryWidth
    "
!

queryWidthMM
%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	Display *dpy;
	int scr;

	dpy = myDpy;
	scr = DefaultScreen(dpy);
	RETURN ( __MKSMALLINT(DisplayWidthMM(dpy, scr)));
    }
%}.
    ^ nil

    "
     Display queryWidthMM
    "
!

reinitialize
    preWaitAction notNil ifTrue:[
	Processor removePreWaitAction:preWaitAction.
	preWaitAction := nil.
    ].
    virtualRootId := rootId := nil.
    selectionFetchers := nil.
    dispatchingExpose := nil
!

releaseDeviceResources
    preWaitAction notNil ifTrue:[
	Processor removePreWaitAction:preWaitAction.
	preWaitAction := nil.
    ].
    selectionFetchers := nil.
    super releaseDeviceResources.
! !

!XWorkstation methodsFor:'keyboard mapping'!

altModifierMask
    "return the mask (in motionEvents) for the alt-key modifier.
     Notice: ST/X may use the left ALT key as CMD/Meta key,
     therefore return a variable here, which can be changed during startup."

    ^ altModifierMask

    "Created: 23.3.1996 / 12:43:22 / cg"
    "Modified: 23.3.1996 / 12:44:56 / cg"
!

altModifierMask:aSmallInteger
    "define which key takes the role of an alt-key.
     By default, this is X's modifier1, which is the ALT key on
     most keyboards. However, there may be exceptions to this,
     and the setting can be changed with:
	Display altModifierMask:(Display modifier2Mask)
     Setting the mask to 0 disables the ALT key (in ST/X) altogether.
    "

    altModifierMask := aSmallInteger
!

ctrlModifierMask
    "return the Xlib mask bit for the control modifier key"

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(ControlMask));
%}
!

metaModifierMask
    "return the mask (in motionEvents) for the meta-key modifier.
     Notice: ST/X may use the left ALT key as CMD/Meta key,
     therefore return a variable here, which can be changed during startup."

    ^ metaModifierMask

    "Created: 23.3.1996 / 12:43:39 / cg"
    "Modified: 23.3.1996 / 12:45:09 / cg"
!

metaModifierMask:aSmallInteger
    "define which key takes the role of a meta key.
     By default, this is X's modifier2, which is the 2nd ALT key on
     most keyboards (if present at all).
     However, there may be exceptions to this, and the setting can
     be changed with:
	Display metaModifierMask:(Display modifier1Mask)
     Setting the mask to 0 disables the META key (in ST/X) altogether.
     As reported, some Xservers place the Meta-key onto NumLock,
     and having NumLock enabled makes ST/X think, that meta is pressed
     all the time. On those, you should disable the meta key by setting
     the mask to 0.
    "

    metaModifierMask := aSmallInteger
!

modifier1Mask
    "return the Xlib mask bit for the 1st modifier key.
     See comment in altModifierMask: / metaModifierMask: for what
     this could be used."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(Mod1Mask));
%}
!

modifier2Mask
    "return the Xlib mask bit for the 2nd modifier key.
     See comment in altModifierMask: / metaModifierMask: for what
     this could be used."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(Mod2Mask));
%}
!

modifier3Mask
    "return the Xlib mask bit for the 3rd modifier key.
     See comment in altModifierMask: / metaModifierMask: for what
     this could be used."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(Mod3Mask));
%}
!

modifier4Mask
    "return the Xlib mask bit for the 4th modifier key.
     See comment in altModifierMask: / metaModifierMask: for what
     this could be used."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(Mod4Mask));
%}
!

modifier5Mask
    "return the Xlib mask bit for the 5th modifier key.
     See comment in altModifierMask: / metaModifierMask: for what
     this could be used."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(Mod5Mask));
%}
!

modifierMapping
    "Get the Modifier Mapping.
     We return an array of arrays of keycodes"

    |modifierKeyMap maxKeyPerMod ret nextKey|

    modifierKeyMap := self rawModifierMapping.
    modifierKeyMap isEmptyOrNil ifTrue:[^ nil].
    maxKeyPerMod := modifierKeyMap size // 8.

    ret := Array new:8.
    nextKey := 1.
    1 to:8 do:[ :i |
	(modifierKeyMap at:nextKey) ~= 0 ifTrue:[
	    |mod|

	    mod := OrderedCollection new:maxKeyPerMod.
	    modifierKeyMap from:nextKey to:(nextKey+maxKeyPerMod-1) do:[ :key |
		key ~= 0 ifTrue:[
		    mod add:key
		].
	    ].
	    ret at:i put:mod asArray.
	].
	nextKey := nextKey+maxKeyPerMod.
    ].

    ^ ret

    "
     Display modifierMapping
    "

    "
     |mapping|

     mapping := Display modifierMapping.
     ^ mapping collect:[:eachRow |
			     eachRow notNil ifTrue:[
				 eachRow collect:[ :key | Display stringFromKeycode:key ].
			     ] ifFalse:[
				 nil
			     ]
		       ].
    "
!

rawKeySymTranslation
    "Get the raw keyboard mapping (maps some special X-keySyms to STX-internal names
     and can also be used to untranslate a stupid x-mapping (as on hpux)."

    ^ rawKeySymTranslation


    "
     Display rawKeySymTranslation
    "
!

rawModifierMapping
    "Get the raw Modifier Mapping."

    |modifierKeyMap|

%{
    XModifierKeymap *modmap;

    if (ISCONNECTED) {
	Display *dpy = myDpy;

	if ((modmap = XGetModifierMapping(dpy)) != 0) {
	   modifierKeyMap = __BYTEARRAY_UNINITIALIZED_NEW_INT(modmap->max_keypermod * 8);
	   if (modifierKeyMap != nil) {
		memcpy((char *)__ByteArrayInstPtr(modifierKeyMap)->ba_element,
		       (char *)modmap->modifiermap, modmap->max_keypermod * 8);
	   }
	   XFreeModifiermap(modmap);
	}
    }
%}.
    ^ modifierKeyMap

    "
	Display rawModifierMapping
    "
!

shiftModifierMask
    "return the Xlib mask bit for the shift modifier key"

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(ShiftMask));
%}
!

superModifierMask
    "return the Xlib mask bit for the super modifier key"

    ^ self modifier4Mask
!

symbolFromKeycode:code
    "Get a KeySymbol (a smalltalk symbol) from the keycode."

    |str|

%{
    KeySym keysym;
    char *keystring;

    if (ISCONNECTED && __isSmallInteger(code)) {
	Display *dpy = myDpy;

// Our Windows Xlib does not support Xkb as of 2013-01
//        if ((keysym = XkbKeycodeToKeysym(dpy, __intVal(code), 0, 0)) != NoSymbol
	if ((keysym = XKeycodeToKeysym(dpy, __intVal(code), 0)) != NoSymbol
	    && (keystring = XKeysymToString(keysym)) != 0)
	    str = __MKSYMBOL(keystring, 0);
    }
%}.
    ^ str

    "
	Display symbolFromKeycode:50
    "
! !

!XWorkstation methodsFor:'misc'!

beep
    "output an audible beep or bell"

    UserPreferences current beepEnabled ifTrue:[
	self beep:0 volume:50
    ]

    "
     Screen current beep
    "

    "Modified: / 3.12.1999 / 17:13:59 / ps"
!

beep:aSymbolOrInteger volume:volumeInPercent
    "output an audible beep. aSymbolOrInteger determines the sound, but is ignored here
     (kept for comaptibilty with WinWorkstation)."

    <context: #return>
%{
    int volume;

    if (__isSmallInteger(volumeInPercent)
     && ISCONNECTED) {
	/* stupid: X wants -100 .. 100 and calls this percent */
	volume = __intVal(volumeInPercent) * 2 - 100;
	if (volume < -100) volume = -100;
	else if (volume > 100) volume = 100;

	ENTER_XLIB();
	XBell(myDpy, volume);
	LEAVE_XLIB();
    }
%}
!

buffered
    "buffer drawing - do not send it immediately to the display.
     This is the default anyway.
     See #unBuffered for additional info."

    <context: #return>
%{
    if (ISCONNECTED) {
	ENTER_XLIB();
	XSynchronize(myDpy, 0);
	LEAVE_XLIB();
    }
%}
    "
     Display buffered
    "
!

flush
    "send all buffered drawing to the display.
     This may be required to make certain, that all previous operations
     are really sent to the display before continuing. For example,
     after a cursor-change with a followup long computation.
     (otherwise, the cursor change request may still be in the output buffer)
     See also #sync, which even waits until the request has been processed."

    <context: #return>
%{
    if (ISCONNECTED) {
	ENTER_XLIB();
	XFlush(myDpy);
	LEAVE_XLIB();
    }
%}.

    operationsUntilFlush := maxOperationsUntilFlush.
!

flushDpsContext:aDPSContext
    <context: #return>
%{
#ifdef DPS
    if (ISCONNECTED
	&& __isExternalAddress(aDPSContext)) {
	ENTER_XLIB();
	DPSFlushContext(__DPSContextVal(aDPSContext));
	LEAVE_XLIB();

	RETURN ( self );
    }
#endif
%}.
    self primitiveFailedOrClosedConnection
!

flushIfAppropriate
    "flush the device, if necessary"

    operationsUntilFlush notNil ifTrue:[
	operationsUntilFlush <= 0 ifTrue:[
	    self flush.
	    ^ true.
	] ifFalse:[
	    operationsUntilFlush := operationsUntilFlush - 1.
	].
    ].
    ^ false.
!

primSync
    "send all buffered drawing to the display AND wait until the display
     has finished drawing it.
     This is almost never needed, except if you are about to read previously
     drawn pixels back from the display screen, or you want to wait for a beep
     to be finished. See also #flush."

    <context: #return>
%{

    if (ISCONNECTED) {

	ENTER_XLIB();
	XSync(myDpy, 0);
	LEAVE_XLIB();

    }
%}.
    operationsUntilFlush := maxOperationsUntilFlush.
!

refreshKeyboardMapping:eB
    <context: #return>
%{
    XMappingEvent *ev;

    if (ISCONNECTED && __isByteArrayLike(eB)) {
	ev = (XMappingEvent *)(__ByteArrayInstPtr(eB)->ba_element);
	ENTER_XLIB();
	XRefreshKeyboardMapping(ev);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

roundTripTime
    "answer the round trip time in milliSeconds.
     May be used to detect slow X11 connections"

    self sync.
    ^ Timestamp millisecondsToRun:[ self primSync ].

    "
     Screen current roundTripTime
    "
!

setInputFocusTo:aWindowId
    "set the focus to the view as defined by aWindowId.
     When released, return the focus to the root window"

"/    self setInputFocusTo:aWindowId revertTo:#parent
    self setInputFocusTo:aWindowId revertTo:#root
!

setInputFocusTo:aWindowId revertTo:revertSymbol
    "set the focus to the view as defined by aWindowId.
     Passing nil set the focus to no window and lets the display discard all
     input until a new focus is set.
     RevertSymbol specifies what should happen if the view becomes invisible;
     passing one of #parent, #root or nil specifies that the focus should be
     given to the parent view, the root view or no view."

    <context: #return>
%{
    int arg;
    Window focusWindow;

    if (ISCONNECTED) {
	if (__isExternalAddress(aWindowId)) {
	    focusWindow = __WindowVal(aWindowId);
	} else if (aWindowId == nil) {
	    focusWindow = None;
	} else
	    goto err;
	if (revertSymbol == @symbol(parent))
	    arg = RevertToParent;
	else if (revertSymbol == @symbol(root))
	    arg = RevertToPointerRoot;
	else
	    arg = RevertToNone;


	ENTER_XLIB();
	XSetInputFocus(myDpy, focusWindow, arg, CurrentTime);
	LEAVE_XLIB();

	RETURN ( self );
    }
err:;
%}.
    self primitiveFailedOrClosedConnection
!

sync
    "send all buffered drawing to the display AND wait until the display
     has finished drawing it.
     This is almost never needed, except if you are about to read previously
     drawn pixels back from the display screen, or you want to wait for a beep
     to be finished. See also #flush."

    self primSync.
    self dispatchPendingEvents.
!

unBuffered
    "make all drawing be sent immediately to the display.
     This makes all graphics synchronous and turns off any buffering
     (i.e. each individual draw-request is sent immediately without
      packing multiple requests into a larger message buffer).
     Be prepared, that this slows down graphics considerably.
     However, it allows display errors to be handled immediately and
     may be useful if you get Xdisplay errors and want to find the request
     which was responsible for it. See also #buffered."

    <context: #return>
%{

    if (ISCONNECTED) {

	ENTER_XLIB();
	XSynchronize(myDpy, 1);
	LEAVE_XLIB();

    }
%}
    "
     Display unBuffered
    "
! !

!XWorkstation methodsFor:'pointer stuff'!

anyButtonStateMask
    "return an integer for masking out any button from a
     buttonStates value."

    "/ should use ``Display buttonXMotionMask bitOr:....''

    ^ 256 + 512 + 1024

    "Modified: 23.3.1996 / 12:41:33 / cg"
    "Created: 23.3.1996 / 12:46:35 / cg"
!

buttonStates
    "return an integer representing the state of the pointer buttons;
     a one-bit in positions 0.. represent a pressed button.
     See the button1Mask/button2Mask/button3Mask,
     shiftMask/controlMask and modifierMask methods for the meaning of the bits."

    <context: #return>
%{
    Window w;
    int screen = __intVal(__INST(screen));
    Window rootRet, childRet;
    int rootX, rootY, winX, winY;
    unsigned int mask;

    if (ISCONNECTED) {
	Display *dpy = myDpy;

	w = RootWindow(dpy, screen);
	if (w) {

	    ENTER_XLIB();
	    XQueryPointer(dpy, w, &rootRet, &childRet,
				 &rootX, &rootY,
				 &winX, &winY,
				 &mask);
	    LEAVE_XLIB();

	    RETURN (__MKSMALLINT(mask));
	}
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ nil

    "
     Display buttonStates
    "

    "is the control-key pressed ?

     Display buttonStates bitTest:(Display controlMask)
    "

    "is the alt/meta-key pressed ?

     Display buttonStates bitTest:(Display altModifierMask)
     Display buttonStates bitTest:(Display metaModifierMask)
    "
!

leftButtonStateMask
    "return an integer for masking out the left button from a
     buttonStates value"

    "/ should use ``Display button1MotionMask''

    ^ 256

    "Modified: 23.3.1996 / 12:41:33 / cg"
!

middleButtonStateMask
    "return an integer for masking out the middle button from a
     buttonStates value"

    "/ should use ``Display button2MotionMask''

    ^ 512

    "Modified: 23.3.1996 / 12:41:43 / cg"
!

pointerPosition
    "return the current pointer position in (virtual) root-window coordinates"

    <context: #return>

    |xpos ypos rootWindowId|

    rootWindowId := self rootWindowId.

%{
    int screen = __intVal(__INST(screen));
    Window rootRet, childRet;
    int rootX, rootY, winX, winY;
    unsigned int mask;

    if (ISCONNECTED && rootWindowId != nil) {
	Display *dpy = myDpy;
	Window w = (Window)__externalAddressVal(rootWindowId);

	ENTER_XLIB();
	XQueryPointer(dpy, w, &rootRet, &childRet,
			      &rootX, &rootY,
			      &winX, &winY,
			      &mask);
	LEAVE_XLIB();
	xpos = __MKSMALLINT(rootX);
	ypos = __MKSMALLINT(rootY);

    }
%}.
    xpos isNil ifTrue:[
	self primitiveFailedOrClosedConnection.
	^ nil
    ].
    ^ xpos @ ypos
!

rightButtonStateMask
    "return an integer for masking out the right button from a
     buttonStates value"

    "/ should use ``Display button3MotionMask''

    ^ 1024

    "Modified: 23.3.1996 / 12:41:52 / cg"
!

rootPositionOfLastEvent
    "return the position in root-window coordinates
     of the last button, key or pointer event"

    ^ eventRootX @ eventRootY
!

setPointerPosition:newPosition in:aWindowId
    "change the pointer position to a new position relative to the
     given windows origin (which may be the rootWindow).
     Be careful with this - its usually not very ergonomically
     to change the mousePointer position.
     This interface is provided for special applications (presentation
     playback) and should not be used in normal applications."

    <context: #return>

    |xpos ypos|

    xpos := newPosition x.
    ypos := newPosition y.

%{
    if (ISCONNECTED
     && __isExternalAddress(aWindowId)
     && __bothSmallInteger(xpos, ypos)) {
	Display *dpy = myDpy;
	Window w = __WindowVal(aWindowId);

	ENTER_XLIB();
	XWarpPointer(dpy,
		     None,  /* src window */
		     w,  /* dst window */
		     0,  /* src_x */
		     0,  /* src_y */
		     0,  /* src_w */
		     0,  /* src_h */
		     __intVal(xpos),  /* dst_x */
		     __intVal(ypos)   /* dst_y */
		    );
	LEAVE_XLIB();
    }
%}.
    ^ self

    "
     Display setPointerPosition:1000@1000
    "
! !

!XWorkstation methodsFor:'private'!

addSelectionHandler:someone
    "register someone to be notified when the selection changes"

    selectionHandlers isNil ifTrue:[
	selectionHandlers := IdentitySet new.
    ].
    selectionHandlers add:someone
!

findSelectionFetcher:aDrawableId
    "find the SelectionFetcher that receives selection events for aDrawableId.
     Answer nil, if there is none"

    selectionFetchers isNil ifTrue:[
	^ nil.
    ].

    ^ selectionFetchers at:aDrawableId ifAbsent:[].
!

registerSelectionFetcher:aSelectionFetcher
    "register a SelectionFetcher that receives selection events for aDrawableId"

    selectionFetchers isNil ifTrue:[
	selectionFetchers := Dictionary new.
    ].

    selectionFetchers at:aSelectionFetcher drawableID put:aSelectionFetcher.
!

removeSelectionHandler:someone
    "no longer tell someone about selection changes"

    selectionHandlers notNil ifTrue:[
	selectionHandlers remove:someone ifAbsent:nil.
	selectionHandlers := selectionHandlers asNilIfEmpty
    ].
!

unregisterSelectionFetcher:aSelectionFetcher
    "unregister a SelectionFetcher that received selection events for aDrawableId"

    selectionFetchers removeKey:aSelectionFetcher drawableID.
! !

!XWorkstation methodsFor:'properties'!

deleteProperty:propertyID for:aWindowID
    "delete a property in the XServer"

    <context: #return>

%{
    if (ISCONNECTED && __isAtomID(propertyID)) {
	Display *dpy = myDpy;
	Atom prop;
	Window window;

	prop = __AtomVal(propertyID);

	if (__isExternalAddress(aWindowID)) {
	    window = __WindowVal(aWindowID);
	} else if (aWindowID == nil) {
	    window = DefaultRootWindow(dpy);
	} else if (__isInteger(aWindowID)) {
	    window = (Window)__unsignedLongIntVal(aWindowID);
	} else {
	    goto fail;
	}

	ENTER_XLIB();
	XDeleteProperty(dpy, window, prop);
	LEAVE_XLIB();
	RETURN(true);
    }
fail:;
%}.
    self primitiveFailedOrClosedConnection.
!

getProperty:propertySymbolOrAtomID from:aWindowOrWindowIDOrNil delete:doDelete
    "get a property as an association propertyType->propertyValue"

    <context: #return>

    |val typeID propertyID windowID|

    propertySymbolOrAtomID isString ifTrue:[
	propertyID := self atomIDOf:propertySymbolOrAtomID create:false.
	propertyID isNil ifTrue:[^ nil].
    ] ifFalse:[
	propertyID := propertySymbolOrAtomID.
    ].
    aWindowOrWindowIDOrNil isView ifTrue:[
	windowID := aWindowOrWindowIDOrNil id.
    ] ifFalse:[
	windowID := aWindowOrWindowIDOrNil.
    ].

%{
    Window window;
    Atom property;
    char *cp, *cp2;
    Atom actual_type;
    int actual_format;
    unsigned long nitems, bytes_after, nread;
    unsigned char *data;
    int ok = 1;
#   define PROP_SIZE    2048

    if (ISCONNECTED) {
	Display *dpy = myDpy;

	if (__isAtomID(propertyID)) {
	    property = __AtomVal(propertyID);

	    if (__isExternalAddress(windowID)) {
		window = __WindowVal(windowID);
	    } else if (windowID == nil) {
		window = DefaultRootWindow(dpy);
	    } else
		goto fail;

	    nread = 0;
	    cp = 0;
#ifdef PROPERTY_DEBUG
	    console_fprintf(stderr, "getProperty %x\n", property);
#endif

	    do {
		int retVal;

		ENTER_XLIB();
		retVal = XGetWindowProperty(dpy, window, property, nread/4, PROP_SIZE,
					    doDelete == true,
					    AnyPropertyType, &actual_type, &actual_format,
					    &nitems, &bytes_after, (unsigned char **)&data);
		LEAVE_XLIB();
		if (retVal != Success) {
#ifdef PROPERTY_DEBUG
		    console_fprintf(stderr, "- no success\n");
#endif
		    ok = 0;
		    break;
		}
#ifdef PROPERTY_DEBUG
		console_fprintf(stderr, "- type:%x\n", actual_type);
#endif
		nitems *= (actual_format / 8);
		typeID = __MKATOMOBJ(actual_type);
		if (! cp) {
		    cp = cp2 = (char *)malloc(nitems+bytes_after);
		} else {
		    cp2 = cp + nread;
		}
		if (! cp) {
		    XFree(data);
		    goto fail;
		}

		nread += nitems;
		bcopy(data, cp2, nitems);
		XFree(data);
#ifdef PROPERTY_DEBUG
		console_fprintf(stderr, "- <nitems:%d bytes_after:%d>\n", nitems, bytes_after);
#endif
	    } while (bytes_after > 0);

	    if (ok) {
		switch (actual_format) {
		case 32:
		    val = __stArrayFromCUIntArray((unsigned int*)cp, nread/4);
		    break;
		case 16:
		    val = __stArrayFromCUShortArray((unsigned short*)cp, nread/2);
		    break;
		case 8:
		default:
		    if (actual_type == XA_STRING) {
			val = __MKSTRING_L(cp, nread);
		    } else {
			val = __MKBYTEARRAY(cp, nread);
		    }
		    break;
		}
	    }
	    if (cp)
		free(cp);
	}
    }
fail: ;
%}.
    (typeID isNil or:[typeID == 0]) ifTrue:[
	"typeID == 0 (None): The property does not exist in the specified window"
	^ nil
    ].
    ^ typeID->val

    "
     Display
	getProperty:#'_NET_WM_ICON_GEOMETRY'
	from:nil
	delete:false
    "
!

propertiesOf:aWindowOrWindowIDOrNil
    "return a collection of all properties' atomIDs of a window.
     Returns the rootWindows props for a nil window argument."

    <context: #return>

    |windowID atoms|

    aWindowOrWindowIDOrNil isView ifTrue:[
	windowID := aWindowOrWindowIDOrNil id.
    ] ifFalse:[
	windowID := aWindowOrWindowIDOrNil.
    ].

%{
    Window window;
    Atom *atomListPtr;
    int i;

    if (ISCONNECTED) {
	Display *dpy = myDpy;
	int numProps = 0;

	if (__isExternalAddress(windowID)) {
	    window = __WindowVal(windowID);
	} else if (windowID == nil) {
	    window = DefaultRootWindow(dpy);
	} else if (__isInteger(windowID)) {
	    window = (Window)__unsignedLongIntVal(windowID);
	} else {
	    goto fail;
	}

	ENTER_XLIB();
	atomListPtr = XListProperties(dpy, window, &numProps);
	LEAVE_XLIB();

	if (atomListPtr == NULL) {
	    RETURN (nil);
	}

	atoms = __ARRAY_NEW_INT(numProps);

	if (atoms == nil) {
	    goto fail;
	}

	for (i=0; i<numProps; i++) {
	    OBJ atm;

	    atm = __MKATOMOBJ(atomListPtr[i]);
	    __ArrayInstPtr(atoms)->a_element[i] = atm; __STORE(atoms, atm);
	}
	XFree(atomListPtr);
	RETURN (atoms);
    }
fail: ;
%}.
    ^ self primitiveFailed

    "
     Display propertiesOf:nil
     Display propertiesOf:Transcript view id
    "
    "
     (Display propertiesOf:nil) do:[:atm |
	|v prop|

	Transcript show:((Display atomName:atm) printStringLeftPaddedTo:5).
	Transcript show:': '.
	prop := Display getProperty:atm from:nil delete:false.
	Transcript showCR:prop value.
     ]
    "
!

setIcon:anIcon for:aWindowID
    |iconAtom typeAtom buffer iWidth iHeight|

    iconAtom := self atomIDOf:#'_NET_WM_ICON' create:false.
    iconAtom isNil ifTrue:[
	"/Hmm, no such property, not running under EWMH compliant WM?
	^ self
    ].
    typeAtom := self atomIDOf:#'CARDINAL' create:false.
    typeAtom isNil ifTrue:[
	"/Hmm, no such property, not running under EWMH compliant WM?
	^ self
    ].
    iWidth  := anIcon width.
    iHeight := anIcon height.
    buffer := IntegerArray new:(iWidth*iHeight+2).
    buffer at:1 put:iWidth.
    buffer at:2 put:iHeight.

    self setProperty:iconAtom type:typeAtom value:buffer for:aWindowID

    "
	Display setIcon:0 for:0
    "
!

setProperty:propertyID type:typeID value:anObject for:aWindowID
    "set a property in the XServer"

    <context: #return>

    |retval|

    retval := false.

%{  /* UNLIMITEDSTACK */
    if (ISCONNECTED && __isAtomID(propertyID) && __isAtomID(typeID)) {
	Display *dpy = myDpy;
	Atom prop, type;
	Window window;

	prop = __AtomVal(propertyID);
	type = __AtomVal(typeID);

	if (__isExternalAddress(aWindowID)) {
	    window = __WindowVal(aWindowID);
	} else if (aWindowID == nil) {
	    window = DefaultRootWindow(dpy);
	} else if (__isInteger(aWindowID)) {
	    window = (Window)__unsignedLongIntVal(aWindowID);
	} else {
	    RETURN(false);
	}

	retval = true;

	ENTER_XLIB();
	if (__isInteger(anObject)) {
	    unsigned INT value = __longIntVal(anObject);
	    XChangeProperty(dpy, window, prop, type, 32,
			    PropModeReplace,
			    (unsigned char *)&value, 1);
	} else if (__isByteArrayLike(anObject)) {
	    XChangeProperty(dpy, window, prop, type, 8,
			    PropModeReplace,
			    __byteArrayVal(anObject),
			    __byteArraySize(anObject));
	} else if (__isWords(anObject)) {
	    /* wordArray-like (16bit-string) object */
	    XChangeProperty(dpy, window, prop, type, 16,
			    PropModeReplace,
			    __stringVal(anObject),
			    __wordArraySize(anObject));
	} else if (__isIntegerArray(anObject)) {
	    /* array of atoms */
	    XChangeProperty(dpy, window, prop, type, 32,
			    PropModeReplace,
			    (char *)__integerArrayVal(anObject),
			    __integerArraySize(anObject));
	} else if (__isStringLike(anObject)) {
	    XChangeProperty(dpy, window, prop, type, 8,
			    PropModeReplace,
			    __stringVal(anObject),
			    __stringSize(anObject));
	} else {
	    retval = false;
	}
	LEAVE_XLIB();

	DPRINTF(("changeProp win=%"_lx_" prop=%"_lx_" type=%"_lx_"\n", (INT)window, (INT)prop, (INT)type));
    }
%}.
    ^ retval
! !

!XWorkstation methodsFor:'queries'!

defaultExtentForTopViews
    "redefined, to define the default extent for the default monitor"
    |extent|

    "the standard monitor is the first entry in monitorBounds"
    extent := self monitorBounds first extent.

    self isPDA ifTrue:[
	^ extent - (16 @ 20)
    ].
    ^ extent * 2 // 3
!

isOpen
    "answer true, if device can be used"

    ^ displayId notNil and:[hasConnectionBroken not].
!

isXineramaActive
%{  /* NOCONTEXT */

#ifdef XINERAMA
    if (ISCONNECTED) {
	Display *dpy;
	dpy = myDpy;

	if (XineramaIsActive(dpy)) {
	    RETURN ( true );
	}
    }
#endif
%}.
    ^ false

    "
     Display isXineramaActive
    "
! !

!XWorkstation methodsFor:'resources'!

atomIDOf:aStringOrSymbol
    "return an X11 atoms ID.
     This is highly X specific and only for local use (with selections).
     The default is to create the atom, if it does not exist, in order to
     speed up future lookups"

    ^ self atomIDOf:aStringOrSymbol create:true

    "
     Display atomIDOf:#'FACE_NAME'
     Display atomIDOf:#'FULL_NAME'
     Display atomIDOf:#DndProtocol
     Display atomIDOf:#DndSelection
    "

    "Modified: 4.4.1997 / 13:38:48 / cg"
!

atomIDOf:aStringOrSymbol create:create
    "return an Atoms ID given its name.
     If it already exists, return its ID.
     If not and the create argument is true, it is created.
     Otherwise, nil is returned.
     This is highly X specific and only for local use (with selections)."

    |atomSymbol atom|

    atomSymbol := aStringOrSymbol asSymbol.
    (atoms notNil and:[(atom := atoms at:atomSymbol ifAbsent:[nil]) notNil]) ifTrue:[
	^ atom.
    ].

    atom := self primAtomIDOf:atomSymbol create:create.
    atom notNil ifTrue:[
	atoms isNil ifTrue:[
	    atoms := IdentityDictionary new.
	].
	atoms at:atomSymbol put:atom.
    ].

    ^ atom

    "
     Display atomIDOf:#'VT_SELECTION' create:false
     Display atomIDOf:#CLIPBOARD create:false
     Display atomIDOf:'STRING' create:false
     Display atomIDOf:'PRIMARY' create:false
     Display atomIDOf:'blabla' create:false
    "
!

atomName:anAtomID
    "given an AtomID, return its name.
     This is highly X specific and only for local use (with selections)."

    <context: #return>

%{
    OBJ str;
    char *name;

    if (ISCONNECTED && __isAtomID(anAtomID)) {
	ENTER_XLIB();
	name = XGetAtomName(myDpy, __AtomVal(anAtomID));
	LEAVE_XLIB();
	if (name == 0) {
	    RETURN (nil);
	}
	str = __MKSTRING(name);
	XFree(name);
	RETURN ( str );
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ nil

    "
     Display atomName:1    'PRIMARY'
     Display atomName:130  '_DEC_DEVICE_FONTNAMES'
     Display atomName:132  'FONTNAME_REGISTRY'
     Display atomName:135 'FOUNDRY'
     Display atomName:150  'CHARSET_REGISTRY'
     Display atomName:151  'ISO8859'
     Display atomName:152 'CHARSET_ENCODING'
     Display atomName:154
    "
!

getResource:name class:cls
    "access the displays resource database for a default value
     of name in a resource class.
     This is highly X specific and  currently not used.

     Notice:
	we do not plan to use X's resources for ST/X's defaults,
	styles or resources. This would make porting of applications
	to different platforms much more difficult (Windows has no resource
	database). If you stay within ST/X's resource files, these can be
	easily transported to other platforms.

     This method is provided for special applications which want to access
     existing X resources and are not planned to be ever ported to other
     platforms."

%{
    char *rslt;

    if (ISCONNECTED
     && __isStringLike(name)
     && __isStringLike(cls)) {

	rslt = XGetDefault(myDpy, (char *) __stringVal(cls),
				  (char *) __stringVal(name));

	RETURN (rslt ? __MKSTRING(rslt) : nil );
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ nil.

    "if your ~/.Xdefaults contains an entry such as:
	OpenWindows.Beep:       notices
     the following returns 'notices'.

	 Display getResource:'Beep' class:'OpenWindows'

     if your ~/.Xdefaults contains an entry such as:
	*.beNiceToColormap:       false
     the following return 'false'.

	 Display getResource:'beNiceToColormap' class:'any'
	 Display getResource:'beNiceToColormap' class:''
    "
!

primAtomIDOf:aStringOrSymbol create:create
    "return an Atoms ID; if create is true, create it if not already present.
     This is highly X specific and only for local use (with selections)."

    <context: #return>

%{
    Atom prop;

    if (ISCONNECTED
     && __isStringLike(aStringOrSymbol)) {

	ENTER_XLIB();
	prop = XInternAtom(myDpy, __stringVal(aStringOrSymbol),
				  (create == true) ? False : True);
	LEAVE_XLIB();
	if (prop == None) {
	    RETURN (nil);
	}
	RETURN ( __MKATOMOBJ(prop) );
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ nil

    "
     Display primAtomIDOf:'VT_SELECTION' create:false
     Display primAtomIDOf:'CUT_BUFFER0' create:false
     Display primAtomIDOf:'STRING' create:false
     Display primAtomIDOf:'PRIMARY' create:false
    "
! !

!XWorkstation methodsFor:'retrieving pixels'!

getBitsFromId:aDrawableId x:srcx y:srcy width:w height:h into:imageBits
    "get bits from a drawable into the imageBits. The storage for the bits
     must be big enough for the data to fit. If ok, returns an array with some
     info and the bits in imageBits. The info contains the depth, bitOrder and
     number of bytes per scanline. The number of bytes per scanline is not known
     in advance, since the X-server is free to return whatever it thinks is a good padding."

    |rawInfo info|

    ((w <= 0) or:[h <= 0]) ifTrue:[
	self primitiveFailed.
	^ nil
    ].

    rawInfo := Array new:8.
		  "1 -> bit order"
		  "2 -> depth"
		  "3 -> bytes_per_line"
		  "4 -> byte_order"
		  "5 -> format"
		  "6 -> bitmap_unit"
		  "7 -> bitmap_pad"
		  "8 -> bits_per_pixel"

    "/ had to extract the getPixel call into a separate method, to specify
    "/ unlimitedStack (some implementations use alloca and require huge amounts
    "/ of temporary stack space

    (self primGetBitsFrom:aDrawableId x:srcx y:srcy width:w height:h into:imageBits infoInto:rawInfo) ifTrue:[
	info := IdentityDictionary new.
	info at:#bitOrder put:(rawInfo at:1).
	info at:#depth put:(rawInfo at:2).
	info at:#bytesPerLine put:(rawInfo at:3).
	info at:#byteOrder put:(rawInfo at:4).
	info at:#format put:(rawInfo at:5).
	info at:#bitmapUnit put:(rawInfo at:6).
	info at:#bitmapPad put:(rawInfo at:7).
	info at:#bitsPerPixel put:(rawInfo at:8).
	^ info
    ].
    "
     some error occurred - either args are not smallintegers, imageBits is not a ByteArray
     or is too small to hold the bits
    "
    self primitiveFailedOrClosedConnection.
    ^ nil
!

getPixelX:x y:y from:aDrawableId with:dummyGCId
    "return the pixel value at x/y; coordinates start at 0/0 for the upper left.
     Nil is returned for invalid coordinates or if any other problem arises."

    <context: #return>

%{  /* UNLIMITEDSTACK */

    Window win;
    XImage *img;
    int ret;
    int xpos, ypos;

    if (ISCONNECTED
     && __isExternalAddress(aDrawableId) && __bothSmallInteger(x, y)) {
	win = __WindowVal(aDrawableId);
	xpos = __intVal(x);
	ypos = __intVal(y);
	if ((xpos < 0) || (ypos < 0)) {
	    RETURN ( __MKSMALLINT(0) );
	}
	ENTER_XLIB();
	img = XGetImage(myDpy, win, xpos, ypos, 1, 1, (unsigned)~0, ZPixmap);
	LEAVE_XLIB();
	if (img != 0) {
	    ret = XGetPixel(img, 0, 0);
	    XDestroyImage(img);
	    RETURN (  __MKSMALLINT(ret) );
	}
    }
%}.
    ^ nil
!

primGetBitsFrom:aDrawableId x:srcx y:srcy width:w height:h into:imageBits infoInto:info
    "since XGetImage may allocate huge amount of stack space
     (some implementations use alloca), this must run with unlimited stack."

    <context: #return>

%{  /* UNLIMITEDSTACK */

    Window win;
    XImage *image = (XImage *)0;
    int pad, bytes_per_line, numBytes;

    if (ISCONNECTED
     && __isExternalAddress(aDrawableId)
     && __bothSmallInteger(srcx, srcy)
     && __bothSmallInteger(w, h)
     && __isArray(info)
     && __isByteArray(imageBits)) {
	Display *dpy = myDpy;

	win = __WindowVal(aDrawableId);
	ENTER_XLIB();
	image = XGetImage(dpy, win, __intVal(srcx), __intVal(srcy),
				    __intVal(w), __intVal(h),
				    (unsigned)AllPlanes, ZPixmap);
	LEAVE_XLIB();

	if (! image) {
	    RETURN ( false );
	}

	pad = image->bitmap_pad;
#ifdef SUPERDEBUG
	console_printf("pad:%d depth:%d\n", image->bitmap_pad, image->depth);
#endif
	switch (image->depth) {
	    case 1:
	    case 2:
	    case 4:
	    case 8:
	    case 16:
	    case 24:
	    case 32:
		numBytes = image->bytes_per_line * image->height;
		break;

	    default:
		/* unsupported depth ? */
		console_fprintf(stderr, "possibly unsupported depth:%d in primGetBits\n", image->depth);
		numBytes = image->bytes_per_line * image->height;
		break;
	}

#ifdef SUPERDEBUG
	console_printf("bytes need:%d bytes given:%d\n", numBytes, __byteArraySize(imageBits));
#endif

	if (numBytes > __byteArraySize(imageBits)) {
	    /* imageBits too small */
	    console_fprintf(stderr, "Workstation [warning]: byteArray too small in primGetBits\n");
	    console_fprintf(stderr, "  bytes need:%d given:%d\n", numBytes, (int)__byteArraySize(imageBits));
	    console_fprintf(stderr, "  pad:%d depth:%d imgBytesPerLine:%d\n",
				image->bitmap_pad, image->depth, image->bytes_per_line);
	    goto fail;
	}
	if (image->bitmap_bit_order == MSBFirst)
	    __ArrayInstPtr(info)->a_element[0] = @symbol(msbFirst);
	else
	    __ArrayInstPtr(info)->a_element[0] = @symbol(lsbFirst);
	__ArrayInstPtr(info)->a_element[1] = __MKSMALLINT(image->depth);
	__ArrayInstPtr(info)->a_element[2] = __MKSMALLINT(image->bytes_per_line);
	if (image->byte_order == MSBFirst)
	    __ArrayInstPtr(info)->a_element[3] = @symbol(msbFirst);
	else
	    __ArrayInstPtr(info)->a_element[3] = @symbol(lsbFirst);
	if (image->format == XYBitmap)
	    __ArrayInstPtr(info)->a_element[4] = @symbol(XYBitmap);
	else if (image->format == XYPixmap)
	    __ArrayInstPtr(info)->a_element[4] = @symbol(XYPixmap);
	else if (image->format == ZPixmap)
	    __ArrayInstPtr(info)->a_element[4] = @symbol(ZPixmap);

	__ArrayInstPtr(info)->a_element[5] = __MKSMALLINT(image->bitmap_unit);
	__ArrayInstPtr(info)->a_element[6] = __MKSMALLINT(image->bitmap_pad);
	__ArrayInstPtr(info)->a_element[7] = __MKSMALLINT(image->bits_per_pixel);
	bcopy(image->data, __ByteArrayInstPtr(imageBits)->ba_element, numBytes);
	XDestroyImage(image);
	RETURN ( true );
    }
fail:
    if (image) {
	XDestroyImage(image);
    }
%}.
    ^ false
! !

!XWorkstation methodsFor:'selection fetching'!

getClipboardObjectFor:drawableId
    "get the object selection.
     Returns nil, if no selection is available.

     Smalltalk puts ST_OBJECT only into the CLIPBOARD"

    |selectionOwnerWindowId selection|

    selectionOwnerWindowId := self getSelectionOwnerOf:clipboardAtom.
    selectionOwnerWindowId isNil ifTrue:[
	"no selection. There is the possibilty that one of our (modal)
	 views has been closed. Get the selection from the copyBuffer"
	^ copyBuffer.
    ].
    selectionOwnerWindowId = selectionOwner ifTrue:[
	"I still hold the selection, so return my locally buffered data"
	^ copyBuffer
    ].

    drawableId notNil ifTrue:[
	"sorry, cannot fetch a selection, if there is no drawableId.
	 Should I borrow a drawableId from another window?"

	selection := SelectionFetcher
	    requestSelection:clipboardAtom
	    type:(self atomIDOf:#'ST_OBJECT')
	    onDevice:self for:drawableId.

	"/ should not happen
false ifTrue:[
	"/ cg: disabled the code below: I don't want any string here (when asking for an object)
	selection isEmptyOrNil ifTrue:[
	    selection := SelectionFetcher
		requestSelection:clipboardAtom
		type:(self atomIDOf:#'UTF8_STRING')
		onDevice:self for:drawableId.

	    selection isNil ifTrue:[
		selection := SelectionFetcher
		    requestSelection:clipboardAtom
		    type:(self atomIDOf:#STRING)
		    onDevice:self for:drawableId.
	    ].
	].
].
    ].
    selection isEmptyOrNil ifTrue:[ ^ copyBuffer ].

    ^ selection.

    "
       Display getClipboardObjectFor:Transcript id
    "
!

getClipboardText:selectionBufferSymbol for:drawableId
    "get the text selection.
     Returns nil, if no selection is available"

    |selectionId selectionOwnerWindowId selection|

    selectionBufferSymbol == #selection ifTrue:[
	selectionId := primaryAtom.
    ] ifFalse:[
	selectionId := clipboardAtom.
    ].

    selectionOwnerWindowId := self getSelectionOwnerOf:selectionId.
    selectionOwnerWindowId isNil ifTrue:[
	"no selection. There is the possibilty that one of our (modal)
	 views has been closed. Get the selection from the copyBuffer"
	^ self copyBufferAsString.
    ].

    selectionOwnerWindowId = selectionOwner ifTrue:[
	"I still hold the selection, so return my locally buffered data"
	"JV@2012-04-02: Added support for PRIMARY/SELECTION buffers."
	^ selectionId == primaryAtom ifTrue:[
	    self primaryBufferAsString
	] ifFalse:[
	    self copyBufferAsString.
	]
    ].

    drawableId notNil ifTrue:[
	"sorry, cannot fetch a selection, if there is no drawableId.
	 Should I borrow a drawableId from another window?"

	selection := SelectionFetcher
	    requestSelection:selectionId
	    type:(self atomIDOf:#'UTF8_STRING')
	    onDevice:self for:drawableId.

	selection isNil ifTrue:[
	    selection := SelectionFetcher
		requestSelection:selectionId
		type:(self atomIDOf:#STRING)
		onDevice:self for:drawableId.
	].
    ].

    ^ selection

     "
       Display getTextSelection:#clipboard for:Transcript id
       Display getTextSelection:#selection for:Transcript id
     "

    "Modified: / 02-04-2012 / 10:34:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XWorkstation methodsFor:'selection sending'!

selectionBuffer:bufferGetSelector as:aTargetAtomID
    "convert the current selection to the format defined by aTargetAtom.
     Answer an association with the type of converted selection (an atomID)
     and the converted selection"

    |buffer bufferAsString|

    buffer := self perform:bufferGetSelector.

    (aTargetAtomID == (self atomIDOf:#'ST_OBJECT')) ifTrue:[
	"/ 'st-object' printCR.
	"send the selection in binaryStore format"
	"require libboss to be loaded"
	(Smalltalk isClassLibraryLoaded:'libstx_libboss') ifFalse:[
	    Logger error:'cannot use binary store for copy buffer (libboss missing)'.
	    ^ nil -> nil.
	].

	[
	    ^ aTargetAtomID -> (buffer binaryStoreBytes).
	] on:Error do:[:ex|
	    Logger info:'error on binary store of copy buffer: %1' with: ex description.
	    ^ nil -> nil.
	].
    ].

    bufferAsString := self class bufferAsString:buffer.

    (aTargetAtomID == (self atomIDOf:#STRING)
     or:[aTargetAtomID == (self atomIDOf:#'text/plain')]
    ) ifTrue:[
	"/ 'string' printCR.
	"the other view wants the selection as string"
	^ aTargetAtomID -> (bufferAsString asSingleByteStringReplaceInvalidWith:$#).
    ].

    (aTargetAtomID == (self atomIDOf:#UTF8_STRING)
     or:[aTargetAtomID == (self atomIDOf:#'text/plain;codeset=utf-8')]
    ) ifTrue:[
	"/ 'utf string' printCR.
	"the other view wants the selection as utf8 string"
	^ aTargetAtomID -> (bufferAsString utf8Encoded).
    ].

    aTargetAtomID == (self atomIDOf:#LENGTH) ifTrue:[
	"the other one wants to know the size of our selection.
	 LENGTH is deprecated, since we do not know how the selection is
	 going to be converted. The client must not rely on the length returned"

	^ (self atomIDOf:#INTEGER) -> (bufferAsString size).
    ].

    "we do not support the requestet target type"
    ^ nil -> nil.

    "Modified: / 23-08-2006 / 15:56:08 / cg"
!

setClipboardObject:anObject owner:aWindowId
    "set the object selection, and make aWindowId be the owner.
     This can be used by other Smalltalk(X) applications only.
     We set only the CLIPBOARD selection"

    clipboardSelectionTime := lastEventTime.
    self setSelectionOwner:aWindowId of:clipboardAtom time:clipboardSelectionTime
!

setClipboardText:aString owner:aWindowId
    "set the text selection, and make aWindowId be the owner.
     This can be used by any other X application.

     We set both the PRIMARY and CLIPBOARD, so that you can paste
     into xterm."

    clipboardSelectionTime := primarySelectionTime := lastEventTime.

    self setSelectionOwner:aWindowId of:clipboardAtom time:clipboardSelectionTime.
    self setSelectionOwner:aWindowId of:primaryAtom time:primarySelectionTime.

    "Modified: / 17.6.1998 / 19:48:54 / cg"
!

setPrimaryText:aString owner:aWindowId
    "set the PRIMARY selection, and make aWindowId be the owner.
     This can be used by any other X application when middle-click
     pasting. X Window specific."

    primarySelectionTime := lastEventTime.

    self setSelectionOwner:aWindowId of:primaryAtom time:primarySelectionTime.

    "Created: / 27-03-2012 / 14:16:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

supportedTargetAtoms
    "answer an integer array containing the list of supported targets
     i.e. supported clipboard formats"

    "Note: some sender code assumes that ST_OBJECT is first"
    ^ #(ST_OBJECT STRING UTF8_STRING TIMESTAMP TARGETS LENGTH
      #'text/plain' #'text/plain;codeset=utf-8'
    ) collect:[:eachTargetSymbol|
	    self atomIDOf:eachTargetSymbol
	] as:IntegerArray.
! !

!XWorkstation methodsFor:'selections-basic'!

getSelectionOwnerOf:selectionAtomSymbolOrID
    "get the owner of a selection, aDrawableID.
     Answer nil, if there is no owner"

    <context:#return>

    |selectionAtomID|

    selectionAtomSymbolOrID isString ifTrue:[
	selectionAtomID := self atomIDOf:selectionAtomSymbolOrID create:false.
    ] ifFalse:[
	selectionAtomID := selectionAtomSymbolOrID.
    ].

%{
    Window window;

    if (__isAtomID(selectionAtomID) && ISCONNECTED) {
	Display *dpy = myDpy;

	ENTER_XLIB();
	window = XGetSelectionOwner(dpy, __AtomVal(selectionAtomID));
	LEAVE_XLIB();
	RETURN ((window == None) ? nil : __MKEXTERNALADDRESS(window));
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ nil
!

requestSelection:selectionID type:typeID for:aWindowId intoProperty:propertyID
    "ask the server to send us the selection - the view with id aWindowID
     will later receive a SelectionNotify event for it (once the Xserver replies
     with the selections value)."

    <context:#return>

    |anIntegerTimestamp|

    anIntegerTimestamp := lastEventTime.

%{

    if (ISCONNECTED
     && __isAtomID(typeID)
     && __isAtomID(propertyID)
     && __isAtomID(selectionID)) {
	Display *dpy = myDpy;
	Window w;
	Time time;

	if (__isExternalAddress(aWindowId)) {
	    w = __WindowVal(aWindowId);
	} else if (aWindowId == nil) {
	    w = (Window)0;
	} else
	    goto err;

	if (anIntegerTimestamp == nil) {
	    /*
	     * the ICCCM convention says: you should set the time to the time when
	     * the selection was requested and not to CurrentTime
	     */
	    time = CurrentTime;
	} else if (__isInteger(anIntegerTimestamp)) {
	    time = __unsignedLongIntVal(anIntegerTimestamp);
	} else
	    goto err;

	ENTER_XLIB();
	XConvertSelection(dpy, __AtomVal(selectionID), __AtomVal(typeID),
			       __AtomVal(propertyID), w, time);
	LEAVE_XLIB();

	RETURN (true);
err:;
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ false

    "
     Display
	requestSelection:(Display atomIDOf:'PRIMARY')
	property:(Display atomIDOf:'VT_SELECTION')
	type:(Display atomIDOf:'STRING')
	for:Transcript id
    "
    "
     Display
	requestSelection:(Display atomIDOf:'PRIMARY')
	property:(Display atomIDOf:'VT_SELECTION')
	type:(Display atomIDOf:'C_STRING')
	for:Transcript id
    "
!

sendNotifySelection:selectionID property:propertyID target:targetID time:aTime to:requestorID
    "send a selectionNotify back from a SelectionRequest.
     PropertyID should be the same as requested  or nil, if the selection
     could not be converted.
     TargetId should be the same as requested.
     Time should be the time when the selection has been acquired"

    <context: #return>
%{
    if (ISCONNECTED
	&& (__isAtomID(propertyID) || propertyID == nil)
	&& __isAtomID(targetID) && __isAtomID(selectionID)) {
	Display *dpy = myDpy;
	XEvent ev;
	Window requestor;
	Status result;

	if (__isExternalAddress(requestorID)) {
	    requestor = __WindowVal(requestorID);
	} else if (__isSmallInteger(requestorID)) {
	    requestor = (Window)__smallIntegerVal(requestorID);
	} else if (requestorID == nil) {
	    requestor = DefaultRootWindow(dpy);
	} else {
	    requestor = (Window)__unsignedLongIntVal(requestorID);
	}

	ev.xselection.type = SelectionNotify;
	ev.xselection.display = dpy;
	ev.xselection.selection = __AtomVal(selectionID);
	ev.xselection.target = __AtomVal(targetID);
	ev.xselection.requestor = requestor;

	if (__isExternalAddress(aTime)) {
	    ev.xselection.time = (INT)(__externalAddressVal(aTime));
	} else if (__isSmallInteger(aTime)) {
	    ev.xselection.time = __smallIntegerVal(aTime);
	} else if (aTime == nil) {
	    ev.xselection.time = CurrentTime;
	} else {
	    ev.xselection.time = (INT)__unsignedLongIntVal(aTime);
	}
#if 0
	console_printf("ev.xselection.selection: %x\n", ev.xselection.selection);
	console_printf("ev.xselection.target: %x\n", ev.xselection.target);
	console_printf("ev.xselection.requestor: %x\n", ev.xselection.requestor);
	console_printf("ev.xselection.time: %x\n", ev.xselection.time);
	console_printf("requestor: %x\n", requestor);
#endif

	/* send nil property if selection cannot be converted */
	if (propertyID == nil)
	    ev.xselection.property = None;
	else
	    ev.xselection.property = __AtomVal(propertyID);


	DPRINTF(("sending SelectionNotify sel=%"_lx_" prop=%"_lx_" target=%"_lx_" requestor=%"_lx_" to %"_lx_"\n",
		(INT)ev.xselection.selection,
		(INT)ev.xselection.property,
		(INT)ev.xselection.target,
		(INT)ev.xselection.requestor,
		(INT)requestor));

	ENTER_XLIB();
	result = XSendEvent(dpy, requestor, False, 0 , &ev);
	LEAVE_XLIB();

	if ((result == BadValue) || (result == BadWindow)) {
	    DPRINTF(("bad status\n"));
	    RETURN (false);
	}
	ENTER_XLIB();
	XFlush(dpy);
	LEAVE_XLIB();
	RETURN (true)
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ false

    "Modified: / 17.6.1998 / 20:23:20 / cg"
!

setSelectionOwner:aWindowId of:selectionAtomSymbolOrID time:anIntegerTimestamp
    "set the owner of a selection; return false if failed"

    <context: #return>

    |selectionAtomID|

    "store the current owner of the selection.
     If we still own the selection on paste,
     we can avoid the X11 overhead"

    selectionOwner := aWindowId.

    selectionAtomSymbolOrID isString ifTrue:[
	selectionAtomID := self atomIDOf:selectionAtomSymbolOrID create:false.
    ] ifFalse:[
	selectionAtomID := selectionAtomSymbolOrID.
    ].

%{
    Window win;

    if (__isExternalAddress(aWindowId)
     && __isAtomID(selectionAtomID)
     && ISCONNECTED) {
	Display *dpy = myDpy;
	Time time;

	win = __WindowVal(aWindowId);

	if (anIntegerTimestamp == nil) {
	    /*
	     * the ICCCM convention says: you should set the time to the time when
	     * the selection was acquired and not to CurrentTime
	     */
	    time = CurrentTime;
	} else if (__isInteger(anIntegerTimestamp)) {
	    time = __unsignedLongIntVal(anIntegerTimestamp);
	} else
	    goto err;

	DPRINTF(("setOwner prop=%"_lx_" win=%"_lx_"\n", (INT)__AtomVal(selectionAtomID), (INT)win));
	ENTER_XLIB();
	XSetSelectionOwner(dpy, __AtomVal(selectionAtomID), win, time);
	RETURN (self);
	LEAVE_XLIB();
    }
err:;
%}.
    self primitiveFailedOrClosedConnection.
! !

!XWorkstation methodsFor:'window queries'!

allChildIdsOf:aWindowId
    "return all children-ids of the given window.
     Allows for all windows to be enumerated, if we start at the root."

    |childIDs allChildIDs|

    allChildIDs := OrderedCollection new.
    childIDs := self childIdsOf:aWindowId.
    childIDs notNil ifTrue:[
	allChildIDs addAll:childIDs.
	childIDs do:[:eachChildId |
	    allChildIDs addAll:(self allChildIdsOf:eachChildId).
	].
    ].
    ^ allChildIDs

    "
     Display allChildIdsOf:(Display rootWindowId)
    "

    "
     |deviceIDAtom uuidAtom|

     deviceIDAtom := (Display atomIDOf:#'STX_DEVICE_ID').
     uuidAtom     := (Display atomIDOf:#'UUID').
     (Display allChildIdsOf:(Display rootWindowId))
	select:[:id |
	    |uuid|

	    Display
		getProperty:deviceIDAtom
		from:id
		delete:false
		into:[:type :value |
		    type == uuidAtom ifTrue:[
			uuid := UUID fromBytes:value.
		    ].
		].
	    uuid notNil.
	]
    "
!

childIdsOf:aWindowId
    "return all children-ids of the given window. Allows for all windows to be
     enumerated, if we start at the root."

    |childIdArray|
%{
    OBJ id;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	Display *dpy = myDpy;
	Window win = __WindowVal(aWindowId);
	Window rootReturn, parentReturn;
	Window* children = (Window *)0;
	unsigned int numChildren;
	int i;
	int rslt;

	ENTER_XLIB();
	rslt = XQueryTree(dpy, win,
		       &rootReturn, &parentReturn,
		       &children, &numChildren);
	LEAVE_XLIB();
	if (rslt) {
	    childIdArray = __ARRAY_NEW_INT(numChildren);
	    if (childIdArray != nil) {
		for (i=0; i < numChildren; i++) {
		    if (children[i]) {
			OBJ childId;

			childId = __MKEXTERNALADDRESS(children[i]);
			__ArrayInstPtr(childIdArray)->a_element[i] = childId;
			__STORE(childIdArray, childId);
		    }
		}
		if (children) XFree(children);
	    }
	    RETURN (childIdArray);
	}
    }
%}.
    ^ nil.

    "
      Display childIdsOf:(Display rootWindowId)
    "
!

realRootWindowId
    "return the id of the real root window.
     This may not be the window you see as background,
     since some window managers install a virtual root window on top
     of it. Except for very special cases, use #rootWindowId, which takes
     care of any virtual root."

%{
    int screen = __intVal(__INST(screen));
    Window root;
    OBJ id;

    if (__INST(rootId) != nil) {
	RETURN (__INST(rootId));
    }

    if (ISCONNECTED) {
	root = RootWindow(myDpy, screen);
	if (! root) {
	    id = nil;
	} else {
	    id = __MKEXTERNALADDRESS(root); __INST(rootId) = id; __STORE(self, id);
	}
	RETURN (id);
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ nil

    "
      Display rootWindowId
      Display realRootWindowId
    "
!

rootWindowId
    "return the id of the root window.
     This is the window you see as background,
     however, it may or may not be the real physical root window,
     since some window managers install a virtual root window on top
     of the real one. If this is the case, that views id is returned here."

%{
    int screen = __intVal(__INST(screen));
    Window rootWin, vRootWin = 0;
    OBJ id;

    if (__INST(virtualRootId) != nil) {
	RETURN (__INST(virtualRootId));
    }

    if (ISCONNECTED) {
	Display *dpy = myDpy;

	rootWin = RootWindow(dpy, screen);
#ifndef IRIS

	/*
	 * on IRIS, this creates a badwindow error - why ?
	 * children contains a funny window (000034)
	 */

	/*
	 * care for virtual root windows (tvtwm & friends)
	 */
	{
	    Atom vRootAtom, kwinAtom;
	    int i;
	    Window rootReturn, parentReturn;
	    Window* children = (Window *)0;
	    unsigned int numChildren;
	    int ignoreVRoot = 0;

	    /*
	     * Take care of KDE 2.1.
	     * they define _SWM_ROOT but this is not the parent of
	     * the application windows.
	     * Instead it is used for background painting
	     */

	    kwinAtom = XInternAtom(dpy, "KWIN_RUNNING", True);
	    if (kwinAtom != None) {
		Atom actual_type;
		int actual_format;
		unsigned long nitems, bytesafter;
		unsigned char *retVal = 0;

		ignoreVRoot = XGetWindowProperty(dpy, rootWin, kwinAtom,
				       0L, 1L, False, kwinAtom,
				       &actual_type, &actual_format,
				       &nitems, &bytesafter, &retVal) == Success
			      && actual_type != 0;
		if (retVal)
		    XFree(retVal);
	    }

	    if (!ignoreVRoot) {
		vRootAtom = XInternAtom(dpy, "__SWM_VROOT", True);
		if (vRootAtom != None) {
		    if (XQueryTree(dpy, rootWin,
				       &rootReturn, &parentReturn,
				       &children, &numChildren)) {
			for (i=0; i < numChildren; i++) {
			    Atom actual_type;
			    int actual_format;
			    unsigned long nitems, bytesafter;
			    Window* newRoot = (Window*) 0;

			    if (children[i]) {
				if (XGetWindowProperty(dpy, children[i], vRootAtom,
						       0L, 1L, False, XA_WINDOW,
						       &actual_type, &actual_format,
						       &nitems, &bytesafter,
						       (unsigned char**) &newRoot
						      ) == Success && newRoot) {
				    vRootWin = *newRoot;
				    XFree(newRoot); /* XXX */
				    break;
				}
			    }
			}
			if (children) XFree(children);
		    }
		}
	     }
	}
#endif
    }

    if (! vRootWin) {
	vRootWin = rootWin;
	if (! vRootWin) {
	    RETURN ( nil );
	}
    }
    id = __MKEXTERNALADDRESS(rootWin); __INST(rootId) = id; __STORE(self, id);
    id = __MKEXTERNALADDRESS(vRootWin); __INST(virtualRootId) = id; __STORE(self, id);
    RETURN ( id );
%}

    "
      Display rootWindowId
    "
! !

!XWorkstation methodsFor:'window stuff'!

clearRectangleX:x y:y width:width height:height in:aWindowId
    "clear a rectangular area to viewbackground"

    <context: #return>
%{

    int w, h;

    if (ISCONNECTED) {
	if (__isExternalAddress(aWindowId)
	 && __bothSmallInteger(x, y)
	 && __bothSmallInteger(width, height)) {
	    w = __intVal(width);
	    h = __intVal(height);
	    /*
	     * need this check here: some servers simply dump core with bad args
	     */
	    if ((w >= 0) && (h >= 0)) {
		ENTER_XLIB();
		XClearArea(myDpy, __WindowVal(aWindowId), __intVal(x), __intVal(y), w, h, 0);
		LEAVE_XLIB();
	    }
	    RETURN ( self );
	}
    }
%}.
    self primitiveFailedOrClosedConnection.
!

clearWindow:aWindowId
    "clear a window to viewbackground"

    <context: #return>
%{

    if (ISCONNECTED) {
	if (__isExternalAddress(aWindowId)) {
	    ENTER_XLIB();
	    XClearWindow(myDpy, __WindowVal(aWindowId));
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
%}.
    self primitiveFailedOrClosedConnection
!

configureWindow:aWindowId sibling:siblingId stackMode:modeSymbol
    "configure stacking operation of aWindowId w.r.t siblingId"

    <context: #return>
%{

    XWindowChanges chg;
    int mask = CWSibling | CWStackMode;

    if (ISCONNECTED) {
	if (__isExternalAddress(aWindowId)
	 && __isExternalAddress(siblingId)) {
	    if (modeSymbol == @symbol(above)) {
		chg.stack_mode = Above;
	    } else if (modeSymbol == @symbol(below)) {
		chg.stack_mode = Below;
	    } else if (modeSymbol == @symbol(topIf)) {
		chg.stack_mode = TopIf;
	    } else if (modeSymbol == @symbol(bottomIf)) {
		chg.stack_mode = BottomIf;
	    } else if (modeSymbol == @symbol(opposite)) {
		chg.stack_mode = Opposite;
	    } else {
		mask = CWSibling;
	    }

	    chg.sibling = __WindowVal(siblingId);
	    ENTER_XLIB();
	    XConfigureWindow(myDpy, __WindowVal(aWindowId),
				    mask, &chg);
	    LEAVE_XLIB();
	    RETURN ( self );
	}
    }
bad: ;
%}.
    self primitiveFailedOrClosedConnection
!

getGeometryOf:aWindowId
    "get a windows geometry.
     NOTICE: X-WindowManagers usually do wrap client topViews into their own
     decoration views (top label, resize boundaries etc.).
     Thus, the numbers returned here for topViews are the physical (real) dimensions
     relative to such a wrapper.
     In contrast, the values found in the views instance variables are virtual dimensions
     (i.e. ST/X makes this decoration view transparent to the program."

    <context: #return>

    |x y width height depth borderWidth info|

%{
    int x_ret, y_ret;
    unsigned int width_ret, height_ret,
		 border_width_ret, depth_ret;
    Window root_ret;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	ENTER_XLIB();
	XGetGeometry(myDpy, __WindowVal(aWindowId),
		     &root_ret,
		     &x_ret, &y_ret,
		     &width_ret, &height_ret, &border_width_ret,
		     &depth_ret);
	LEAVE_XLIB();

	x = __MKSMALLINT(x_ret);
	y = __MKSMALLINT(y_ret);
	width = __MKSMALLINT(width_ret);
	height = __MKSMALLINT(height_ret);
	depth = __MKSMALLINT(depth_ret);
	borderWidth = __MKSMALLINT(border_width_ret);
    }
%}.
    borderWidth isNil ifTrue:[
	self primitiveFailedOrClosedConnection.
	^ nil
    ].
    info := Dictionary new.
    info at:#origin put:(x @ y).
    info at:#extent put:(width @ height).
    info at:#depth  put:depth.
    info at:#borderWidth put:borderWidth.
    ^ info

    "
     Transcript topView device
	getGeometryOf:(Transcript id)
    "
    "
     Transcript topView device
	getGeometryOf:(Transcript topView id)
    "
    "
     Display
	getGeometryOf:(Display viewIdFromUser)
    "
    "
     |d|

     d := Transcript topView device.
     d getGeometryOf:(d parentWindowIdOf:Transcript topView id)
    "
!

isValidWindowId:aWindowId
    "return true, if the given window ID is (still) valid.
     Especially useful, if the passed windowID is
     an alien (external) windows id."

    |ret|

%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	char *name = NULL;
	Status ok;
	Window root, parent, *children = NULL;
	unsigned int nChildren;

/*        ENTER_XLIB(); */
	ok = XQueryTree(myDpy, __WindowVal(aWindowId),
			&root, &parent, &children, &nChildren);
	if (children) {
	    XFree(children);
	}
/*        LEAVE_XLIB();   */
	if (ok) {
	    RETURN (true);
	}
	RETURN (false);
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ false

    "
     |v aWindowId ok|

     v := StandardSystemView new.
     v label:'hello'.
     v openAndWait.
     aWindowId := v id.
     ok := Display isValidWindowId:aWindowId.
     Transcript showCR:'ok is: ' , ok printString.
     Delay waitForSeconds:1.
     v destroy.
     ok := Display isValidWindowId:aWindowId.
     Transcript showCR:'ok is: ' , ok printString.
    "
!

lowerWindow:aWindowId
    "bring a window to back"

    <context: #return>
%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	ENTER_XLIB();
	XLowerWindow(myDpy, __WindowVal(aWindowId));
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

mapView:aView id:aWindowId iconified:aBoolean atX:xPos y:yPos
	      width:w height:h minExtent:minExt maxExtent:maxExt

    <context: #return>

    "make a window visible - either as icon or as a real view
     in addition, allow change of extend, position, minExtend and maxExtent.
     Needed for restart, to allow recreating a view as iconified,
     and to collaps/expand windows."

    |wicon wiconId iconMaskId wiconView wiconViewId wlabel minW minH maxW maxH|

    aBoolean ifTrue:[
	wicon := aView icon.
	wicon notNil ifTrue:[
	    wiconId := wicon id.
	    wicon mask notNil ifTrue:[
		iconMaskId := wicon mask id.
	    ].
	].
	wiconView := aView iconView.
	wiconView notNil ifTrue:[
	    wiconViewId := wiconView id
	].
	wlabel := aView label.
    ].
    minExt notNil ifTrue:[
	minW := minExt x.
	minH := minExt y.
    ].
    maxExt notNil ifTrue:[
	maxW := maxExt x.
	maxH := maxExt y.
    ].
%{

    XWMHints wmhints;
    XSizeHints szhints;
    Window win;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	Display *dpy = myDpy;

	win = __WindowVal(aWindowId);

	szhints.flags = 0;
	if (__bothSmallInteger(xPos, yPos)) {
	    szhints.x = __intVal(xPos);
	    szhints.y = __intVal(yPos);
	    szhints.flags |= USPosition;
	}
	if (__bothSmallInteger(w, h)) {
	    szhints.width = __intVal(w);
	    szhints.height = __intVal(h);
	    szhints.flags |= USSize;
	}
	if (__bothSmallInteger(minW, minH)) {
	    szhints.flags |= PMinSize;
	    szhints.min_width = __intVal(minW);
	    szhints.min_height = __intVal(minH);
	}
	if (__bothSmallInteger(maxW, maxH)) {
	    szhints.flags |= PMaxSize;
	    szhints.max_width = __intVal(maxW);
	    szhints.max_height = __intVal(maxH);
	}

	if (aBoolean == true) {
	    char *windowName = "";
	    Pixmap iconBitmap = (Pixmap)0;
	    Pixmap iconMask = (Pixmap)0;
	    Window iconWindow = (Window)0;

	    if (__isExternalAddress(wiconId))
		iconBitmap = __PixmapVal(wiconId);

	    if (__isExternalAddress(iconMaskId)) {
		iconMask = __PixmapVal(iconMaskId);
	    }

	    if (__isExternalAddress(wiconViewId))
		iconWindow = __WindowVal(wiconViewId);

	    if (__isStringLike(wlabel))
		windowName = (char *) __stringVal(wlabel);

	    if (iconBitmap || windowName) {
		ENTER_XLIB();
		XSetStandardProperties(dpy, win,
					windowName, windowName,
					iconBitmap,
					0, 0, &szhints);
		LEAVE_XLIB();
	    }

	    wmhints.flags = 0;
	    if (iconBitmap) {
		wmhints.flags |= IconPixmapHint;
		wmhints.icon_pixmap = iconBitmap;
	    }
	    if (iconMask) {
		wmhints.flags |= IconMaskHint;
		wmhints.icon_mask = iconMask;
	    }
	    if (iconWindow) {
		wmhints.flags |= IconWindowHint;
		wmhints.icon_window = iconWindow;
	    }

	    wmhints.initial_state = IconicState;
	    wmhints.flags |= StateHint;
	    ENTER_XLIB();
	    XSetWMHints(dpy, win, &wmhints);
	    LEAVE_XLIB();
	}

	if (szhints.flags) {
	    ENTER_XLIB();
	    XSetNormalHints(dpy, win, &szhints);
	    LEAVE_XLIB();
	}

	ENTER_XLIB();
	XMapWindow(dpy, win);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

mapWindow:aWindowId
    "make a window visible"

    <context: #return>
%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	ENTER_XLIB();
	XMapWindow(myDpy, __WindowVal(aWindowId));
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

moveResizeWindow:aWindowId x:x y:y width:w height:h
    "move and resize a window"

    <context: #return>
%{

    int newWidth, newHeight;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)
     && __bothSmallInteger(w, h)
     && __bothSmallInteger(x, y)) {
	newWidth = __intVal(w);
	newHeight = __intVal(h);
	if (newWidth < 1) newWidth = 1;
	if (newHeight < 1) newHeight = 1;
	ENTER_XLIB();
	XMoveResizeWindow(myDpy, __WindowVal(aWindowId),
			      __intVal(x), __intVal(y),
			      newWidth, newHeight);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

moveWindow:aWindowId x:x y:y
    "move a window"

    <context: #return>
%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId) && __bothSmallInteger(x, y)) {
	ENTER_XLIB();
	XMoveWindow(myDpy, __WindowVal(aWindowId), __intVal(x), __intVal(y));
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

parentWindowIdOf:aWindowId
    "return a windows parent-window id.
     Useful with getGeometryOf:, to compute information about the decoration."

%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	Status ok;
	Window root, parent, *children = NULL;
	unsigned int nChildren;

/*        ENTER_XLIB(); */
	ok = XQueryTree(myDpy, __WindowVal(aWindowId),
			&root, &parent, &children, &nChildren);
	if (children) {
	    XFree(children);
	}
/*        LEAVE_XLIB();   */
	if (! ok) {
	    RETURN ( nil );
	}
	RETURN ( __MKEXTERNALADDRESS(parent) );
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ false

    "
     |id|

     id := Transcript device parentWindowIdOf:(Transcript id).
     self assert: ( Transcript container id = id ).
    "
!

raiseWindow:aWindowId
    "bring a window to front"

    <context: #return>
%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	ENTER_XLIB();
	XRaiseWindow(myDpy, __WindowVal(aWindowId));
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

reparentWindow:windowId to:newParentWindowId
    "change a windows parent (an optional interface)"

    <context: #return>
%{
    if (ISCONNECTED
     && __isExternalAddress(windowId)
     && __isExternalAddress(newParentWindowId)) {
	Display *dpy = myDpy;
	Window _child, _newParent;
	int i;

	_child = __WindowVal(windowId);
	_newParent = __WindowVal(newParentWindowId);
	ENTER_XLIB();

#if 0
	XWithdrawWindow (dpy, _child, DefaultScreen(dpy));
	XSync (dpy, 0);
#endif
	/*
	 * Code 'stolen' from xswallow source ...
	 * ... mhmh - what is this loop for ?
	 */
	for (i=0; i<5; i++) {
	    XReparentWindow (dpy, _child, _newParent, 0, 0);
	    XSync (dpy, 0);
	}
#if 0
	XMapWindow (dpy, _child);
	XSync (dpy, 0);
#endif
	LEAVE_XLIB();
	RETURN ( true );
    }
%}.
    self primitiveFailedOrClosedConnection
!

resizeWindow:aWindowId width:w height:h
    "resize a window"

    <context: #return>
%{

    int newWidth, newHeight;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId) && __bothSmallInteger(w, h)) {
	newWidth = __intVal(w);
	newHeight = __intVal(h);
	if (newWidth < 1) newWidth = 1;
	if (newHeight < 1) newHeight = 1;
	ENTER_XLIB();
	XResizeWindow(myDpy, __WindowVal(aWindowId), newWidth, newHeight);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setBackingStore:how in:aWindowId
    "turn on/off backing-store for a window"

    <context: #return>
%{

    XSetWindowAttributes wa;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	if (__INST(ignoreBackingStore) != true) {
	    if (how == @symbol(always)) wa.backing_store = Always;
	    else if (how == @symbol(whenMapped)) wa.backing_store = WhenMapped;
	    else if (how == true) wa.backing_store = Always;
	    else wa.backing_store = 0;

	    ENTER_XLIB();
	    XChangeWindowAttributes(myDpy, __WindowVal(aWindowId), CWBackingStore, &wa);
	    LEAVE_XLIB();

	}
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setBitGravity:how in:aWindowId
    "set bit gravity for a window"

    <context: #return>
%{

    XSetWindowAttributes wa;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	if (how == @symbol(NorthWest)) {
	    wa.bit_gravity = NorthWestGravity;
	} else if (how == @symbol(NorthEast)) {
	    wa.bit_gravity = NorthEastGravity;
	} else if (how == @symbol(SouthWest)) {
	    wa.bit_gravity = SouthWestGravity;
	} else if (how == @symbol(SouthEast)) {
	    wa.bit_gravity = SouthEastGravity;
	} else if (how == @symbol(Center)) {
	    wa.bit_gravity = CenterGravity;
	} else if (how == @symbol(North)) {
	    wa.bit_gravity = NorthGravity;
	} else if (how == @symbol(South)) {
	    wa.bit_gravity = SouthGravity;
	} else if (how == @symbol(West)) {
	    wa.bit_gravity = WestGravity;
	} else if (how == @symbol(East)) {
	    wa.bit_gravity = EastGravity;
	} else {
	    wa.bit_gravity = NorthWestGravity;
	}


	ENTER_XLIB();
	XChangeWindowAttributes(myDpy, __WindowVal(aWindowId), CWBitGravity, &wa);
	LEAVE_XLIB();

	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setCursor:aCursorId in:aWindowId
    "define a windows cursor"

    <context: #return>
%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)
     && __isExternalAddress(aCursorId)) {
	Display *dpy = myDpy;
	Window w = __WindowVal(aWindowId);
	Cursor c = __CursorVal(aCursorId);

	if (w && c) {
	    ENTER_XLIB();
	    XDefineCursor(dpy, w, c);
	    LEAVE_XLIB();
	}
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setForegroundWindow:aWindowId
    "bring a window to front.
     Send a specific message to the WindowManager"

    |activeWindowAtom|

"/    self raiseWindow:aWindowId.

    activeWindowAtom := self atomIDOf:#'_NET_ACTIVE_WINDOW' create:false.
    activeWindowAtom notNil ifTrue:[
	self
	    sendClientEvent:activeWindowAtom
	    format:32
	    to:(self rootWindowId)
	    propagate:false
	    eventMask:((self eventMaskFor:#substructureNotify) bitOr:(self eventMaskFor:#substructureRedirect))
	    window:aWindowId
	    data1:2                 "activate request from pager. This is a trick: kwm ignores requests from applications (1)"
	    data2:nil
	    data3:nil
	    data4:nil
	    data5:nil.
    ].

    "
      Transcript topView setForegroundWindow
    "
!

setIconName:aString in:aWindowId
    "define a windows iconname"

    <context: #return>

    |utf8StringAtom utf8String simpleString|

    utf8StringAtom := self atomIDOf:#UTF8_STRING create:true.

    utf8String := aString utf8Encoded.
    aString isWideString ifTrue:[
	"/ X does not like 2-byte labels ...
	simpleString := aString asSingleByteStringReplaceInvalidWith:$?
    ] ifFalse:[
	simpleString := aString.
    ].

%{
    XTextProperty titleProperty;

    if (ISCONNECTED
     && __isStringLike(utf8String)
     && __isStringLike(simpleString)
     && __isExternalAddress(aWindowId)) {

	titleProperty.value =  __stringVal(utf8String);
	titleProperty.encoding = __smallIntegerVal(utf8StringAtom);
	titleProperty.format = 8;
	titleProperty.nitems = __stringSize(utf8String);

	ENTER_XLIB();
	XSetIconName(myDpy, __WindowVal(aWindowId), (char *) __stringVal(simpleString));
	/* alternative settings for UTF8-Strings */
	XSetWMIconName(myDpy, __WindowVal(aWindowId), &titleProperty);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setSaveUnder:yesOrNo in:aWindowId
    "turn on/off save-under for a window"

    <context: #return>
%{

    XSetWindowAttributes wa;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	if (__INST(hasSaveUnder) == true) {
	    wa.save_under = (yesOrNo == true) ? 1 : 0;
	    ENTER_XLIB();
	    XChangeWindowAttributes(myDpy, __WindowVal(aWindowId), CWSaveUnder, &wa);
	    LEAVE_XLIB();
	}
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setTransient:aWindowId for:aMainWindowId
    "set aWindowId to be a transient of aMainWindow"

    <context: #return>
%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	Window w;

	if ((aMainWindowId == nil) || (aMainWindowId == __MKSMALLINT(0))) {
	    w = (Window) 0;
	} else {
	    if (__isExternalAddress(aMainWindowId)) {
		w = __WindowVal(aMainWindowId);
	    } else {
		goto getOutOfHere;
	    }
	}
	ENTER_XLIB();
	XSetTransientForHint(myDpy, __WindowVal(aWindowId), w);
	LEAVE_XLIB();
	RETURN ( self );
    }
 getOutOfHere: ;
%}.
    self primitiveFailedOrClosedConnection
!

setWindowBackground:aColorIndex in:aWindowId
    "set the windows background color. This is the color with which
     the view is filled whenever exposed. Do not confuse this with
     the background drawing color, which is used with opaque drawing."

    <context: #return>
%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)
     && __isSmallInteger(aColorIndex)) {
	ENTER_XLIB();
	XSetWindowBackground(myDpy, __WindowVal(aWindowId), __intVal(aColorIndex));
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setWindowBackgroundPixmap:aPixmapId in:aWindowId
    "set the windows background pattern to be a form.
     This is the pattern with which the view is filled whenever exposed.
     Do not confuse this with the background drawing color, which is used
     with opaque drawing."

    <context: #return>
%{  /* STACK: 64000 */

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)
     && __isExternalAddress(aPixmapId)) {
	ENTER_XLIB();
	XSetWindowBackgroundPixmap(myDpy, __WindowVal(aWindowId), __PixmapVal(aPixmapId));
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setWindowBorderColor:aColorIndex in:aWindowId
    "set the windows border color"

    <context: #return>
%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)
     && __isSmallInteger(aColorIndex)) {
	ENTER_XLIB();
	XSetWindowBorder(myDpy, __WindowVal(aWindowId), __intVal(aColorIndex));
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setWindowBorderPixmap:aPixmapId in:aWindowId
    "set the windows border pattern"

    <context: #return>
%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)
     && __isExternalAddress(aPixmapId)) {
	ENTER_XLIB();
	XSetWindowBorderPixmap(myDpy, __WindowVal(aWindowId), __PixmapVal(aPixmapId));
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setWindowBorderShape:aPixmapId in:aWindowId
    "set the windows border shape"

    <context: #return>

    hasShapeExtension ifFalse:[^ self].

%{

#ifdef SHAPE
    Pixmap shapeBitmap;

    if (__isExternalAddress(aPixmapId))
	shapeBitmap = __PixmapVal(aPixmapId);
    else
	shapeBitmap = (Pixmap)0;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	ENTER_XLIB();
	XShapeCombineMask(myDpy, __WindowVal(aWindowId), ShapeBounding,
			  0, 0, shapeBitmap, ShapeSet);
	LEAVE_XLIB();
	RETURN ( self );
    }
#endif
%}.
    self primitiveFailedOrClosedConnection
!

setWindowBorderWidth:aNumber in:aWindowId
    "set the windows border width"

    <context: #return>
%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)
     && __isSmallInteger(aNumber)) {
	ENTER_XLIB();
	XSetWindowBorderWidth(myDpy, __WindowVal(aWindowId), __intVal(aNumber));
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setWindowClass:wClass name:wName in:aWindowId
    "define class and name of a window.
     This may be used by the window manager to
     select client specific resources."

    <context: #return>
%{
    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	XClassHint classhint;

	classhint.res_class = classhint.res_name = 0;

	if (__isStringLike(wClass)) {
	    classhint.res_class = (char *) __stringVal(wClass);
	} else if (wClass != nil)
	    goto error;

	if (__isStringLike(wName)) {
	    classhint.res_name = (char *) __stringVal(wName);
	} else if (wName != nil)
	    goto error;

	ENTER_XLIB();
	XSetClassHint(myDpy, __WindowVal(aWindowId), &classhint);
	LEAVE_XLIB();
	RETURN ( self );
error:;
    }
%}.
    self primitiveFailedOrClosedConnection
!

setWindowGravity:how in:aWindowId
    "set window gravity for a window"

    <context: #return>
%{

    XSetWindowAttributes wa;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	if (how == @symbol(NorthWest)) {
	    wa.win_gravity = NorthWestGravity;
	} else if (how == @symbol(NorthEast)) {
	    wa.win_gravity = NorthEastGravity;
	} else if (how == @symbol(SouthWest)) {
	    wa.win_gravity = SouthWestGravity;
	} else if (how == @symbol(SouthEast)) {
	    wa.win_gravity = SouthEastGravity;
	} else if (how == @symbol(Center)) {
	    wa.win_gravity = CenterGravity;
	} else if (how == @symbol(North)) {
	    wa.win_gravity = NorthGravity;
	} else if (how == @symbol(South)) {
	    wa.win_gravity = SouthGravity;
	} else if (how == @symbol(West)) {
	    wa.win_gravity = WestGravity;
	} else if (how == @symbol(East)) {
	    wa.win_gravity = EastGravity;
	} else {
	    wa.win_gravity = NorthWestGravity;
	}


	ENTER_XLIB();
	XChangeWindowAttributes(myDpy, __WindowVal(aWindowId), CWWinGravity, &wa);
	LEAVE_XLIB();

	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setWindowIcon:aForm in:aWindowId
    "define a bitmap to be used as icon"

    <context: #return>

    |iconId|

    aForm notNil ifTrue:[
	iconId := aForm id
    ].
%{
    if (ISCONNECTED
     && __isExternalAddress(iconId)
     && __isExternalAddress(aWindowId)) {
	XWMHints hints;

	hints.icon_pixmap = __PixmapVal(iconId);
	hints.flags = IconPixmapHint;
	ENTER_XLIB();
	XSetWMHints(myDpy, __WindowVal(aWindowId), &hints);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setWindowIcon:aForm mask:aMaskForm in:aWindowId
    "define a windows icon and (optional) iconMask."

    <context: #return>

    |iconId maskId|

    aForm notNil ifTrue:[
	iconId := aForm id
    ].
    aMaskForm notNil ifTrue:[
	maskId := aMaskForm id.
    ].
%{
    if (ISCONNECTED
     && __isExternalAddress(iconId)
     && __isExternalAddress(aWindowId)) {
	XWMHints hints;

	hints.icon_pixmap = __PixmapVal(iconId);
	hints.flags = IconPixmapHint;
	if ((maskId != nil)
	 && __isExternalAddress(maskId)) {
	    hints.icon_mask = __PixmapVal(maskId);
	    hints.flags |= IconMaskHint;
	}
	ENTER_XLIB();
	XSetWMHints(myDpy, __WindowVal(aWindowId), &hints);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection

!

setWindowIconWindow:aView in:aWindowId
    "define a window to be used as icon"

    <context: #return>

    |iconWindowId|

    aView notNil ifTrue:[
	iconWindowId := aView id
    ].
%{
    if (ISCONNECTED
     && __isExternalAddress(iconWindowId)
     && __isExternalAddress(aWindowId)) {
	XWMHints wmhints;

	wmhints.icon_window = __WindowVal(iconWindowId);
	wmhints.flags = IconWindowHint;
	ENTER_XLIB();
	XSetWMHints(myDpy, __WindowVal(aWindowId), &wmhints);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setWindowMinExtentX:minW y:minH maxExtentX:maxW y:maxH in:aWindowId
    "set a windows minimum & max extents.
     nil arguments are ignored."

    <context: #return>
%{
    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	Display *dpy = myDpy;
	XSizeHints szhints;
	Window win;

	win = __WindowVal(aWindowId);

	szhints.flags = 0;
	if (__bothSmallInteger(minW, minH)) {
	    szhints.flags |= PMinSize;
	    szhints.min_width = __intVal(minW);
	    szhints.min_height = __intVal(minH);
	}
	if (__bothSmallInteger(maxW, maxH)) {
	    szhints.flags |= PMaxSize;
	    szhints.max_width = __intVal(maxW);
	    szhints.max_height = __intVal(maxH);
	}

	if (szhints.flags) {
	    ENTER_XLIB();
	    XSetNormalHints(dpy, win, &szhints);
	    LEAVE_XLIB();
	}
    }
%}.
!

setWindowName:aString in:aWindowId
    "define a windows name"

    <context: #return>

    |utf8StringAtom utf8String simpleString|

    utf8StringAtom := self atomIDOf:#UTF8_STRING create:true.

    utf8String := aString utf8Encoded.
    aString isWideString ifTrue:[
	"/ X does not like 2-byte labels ...
	simpleString := aString asSingleByteStringReplaceInvalidWith:$?
    ] ifFalse:[
	simpleString := aString.
    ].

%{

    XTextProperty titleProperty;

    if (ISCONNECTED
     && __isStringLike(utf8String)
     && __isStringLike(simpleString)
     && __isExternalAddress(aWindowId)) {

	titleProperty.value =  __stringVal(utf8String);
	titleProperty.encoding = __smallIntegerVal(utf8StringAtom);
	titleProperty.format = 8;
	titleProperty.nitems = __stringSize(utf8String);

	ENTER_XLIB();
	XStoreName(myDpy, __WindowVal(aWindowId), (char *) __stringVal(simpleString));
	/* alternative settings for UTF8-Strings */
	XSetWMName(myDpy, __WindowVal(aWindowId), &titleProperty);
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailedOrClosedConnection
!

setWindowPid:anIntegerOrNil in:aWindowId
    "Sets the _NET_WM_PID property for the window.
     This may be used by the window manager to group windows.
     If anIntegerOrNil is nil, then PID of currently running
     Smalltalk is used"

    | propertyID typeId pid |

    propertyID := self atomIDOf: '_NET_WM_PID' create: false.
    propertyID isNil ifTrue:[ ^ self ].
    pid := anIntegerOrNil isNil ifTrue:[OperatingSystem getProcessId] ifFalse:[anIntegerOrNil].
    typeId := self atomIDOf:#'CARDINAL' create:false.

    self setProperty:propertyID type:typeId value:pid for:aWindowId

    "Created: / 04-01-2013 / 16:03:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setWindowShape:aPixmapId in:aWindowId
    "set the windows shape.
     Returns false, if the display does not support the
     X shape extension."

    <context: #return>

    hasShapeExtension ifFalse:[^ self].

%{

#ifdef SHAPE
    Pixmap shapeBitmap;

    if (__isExternalAddress(aPixmapId))
	shapeBitmap = __PixmapVal(aPixmapId);
    else
	shapeBitmap = (Pixmap)0;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	ENTER_XLIB();
	XShapeCombineMask(myDpy, __WindowVal(aWindowId), ShapeClip,
			  0, 0,
			  shapeBitmap, ShapeSet);
	LEAVE_XLIB();
	RETURN ( self );
    }
#endif
%}.
    self primitiveFailedOrClosedConnection
!

setWindowState:aSymbol in:aWindowId
    "tell the window type to the window manager.
     Send a specific message to the WindowManager"

    |netWmWindowStateAtom stateAtom|

    netWmWindowStateAtom := self atomIDOf:#'_NET_WM_WINDOW_STATE' create:false.
    stateAtom := self atomIDOf:aSymbol create:false.

    (netWmWindowStateAtom notNil and:[stateAtom notNil]) ifTrue:[
	self
	    sendClientEvent:netWmWindowStateAtom
	    format:32
	    to:(self rootWindowId)
	    propagate:true
	    eventMask:((self eventMaskFor:#substructureNotify) bitOr:(self eventMaskFor:#substructureRedirect))
	    window:aWindowId
	    data1:(self atomIDOf:#'_NET_WM_STATE_ADD' create:false)
	    data2:stateAtom
	    data3:nil
	    data4:1
	    data5:nil.
    ] ifFalse:[self halt.].

    "
      |v|

      v := TopView new create.
      Display setWindowState:#'_NET_WM_WINDOW_STATE_STICKY' in:v id.
      v open.
    "
!

setWindowType:aSymbol in:aWindowId
    "Tell the window type to the window manager.
     See Extended Window Manager Hints 1.3,
     chapter 'Application Window Properties'
     http://standards.freedesktop.org/wm-spec/1.3/

    JV@2012-05-15: There was some code prior 2012-05-15,
    but that code does not work anymore and I wonder if it
    ever worked correctly. I changed it to be
    EWMH compatible, as this improve UX on modern Linxu
    machines.

    It also helps to fix super-annoying problem with window autoraiser
    on X11 in a proper way - window manager should manage top-level
    window stacking, that's why it is called a 'window manager' :-)

    "

    | nameAtom typeAtom valueAtom |

    self assert:(#(_NET_WM_WINDOW_TYPE_DESKTOP
		  _NET_WM_WINDOW_TYPE_DOCK
		  _NET_WM_WINDOW_TYPE_TOOLBAR
		  _NET_WM_WINDOW_TYPE_MENU
		  _NET_WM_WINDOW_TYPE_UTILITY
		  _NET_WM_WINDOW_TYPE_SPLASH
		  _NET_WM_WINDOW_TYPE_DIALOG
		  _NET_WM_WINDOW_TYPE_NORMAL) includes: aSymbol).

    nameAtom := self atomIDOf:#'_NET_WM_WINDOW_TYPE' create:false.
    nameAtom isNil ifTrue:[
	"/Hmm, no such property, not running under EWMH compliant WM?
	self breakPoint: #jv.
	^self
    ].
    "/ Hmm, hmm, no access to XA_ATOM, XA_INTEGER and so on...
    typeAtom := self atomIDOf:#'ATOM' create:false.
    typeAtom isNil ifTrue:[
	self error:'Oops, no ATOM atom'.
    ].
    valueAtom := self atomIDOf: aSymbol create:false.
    valueAtom isNil ifTrue:[
	"/Hmm, no such property, not running under EWMH compliant WM?
	self breakPoint: #jv.
	^self
    ].

    self setProperty: nameAtom type: typeAtom value: valueAtom for: aWindowId.


"/   Original code that does not work (if ever worked)
"/
"/    |netWmWindowTypeAtom typeAtom|
"/
"/    netWmWindowTypeAtom := self atomIDOf:#'_NET_WM_WINDOW_TYPE' create:false.
"/    typeAtom := self atomIDOf:aSymbol create:false.
"/
"/    (netWmWindowTypeAtom notNil and:[typeAtom notNil]) ifTrue:[
"/        self
"/            sendClientEvent:netWmWindowTypeAtom
"/            format:32
"/            to:(self rootWindowId)
"/            propagate:true
"/            eventMask:((self eventMaskFor:#substructureNotify) bitOr:(self eventMaskFor:#substructureRedirect))
"/            window:aWindowId
"/            data1:typeAtom
"/            data2:nil
"/            data3:nil
"/            data4:nil
"/            data5:nil.
"/    ].

    "
      |v|

      v := TopView new create.
      Display setWindowType:#'_NET_WM_WINDOW_TYPE_DOCK' in:v id.
      v open.

      |v|

      v := TopView new create.
      Display setWindowType:#'_NET_WM_WINDOW_TYPE_UTILITY' in:v id.
      v open.
    "

    "Modified (comment): / 15-05-2012 / 10:49:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unmapWindow:aWindowId
    "make a window invisible"

    <context: #return>
%{
    /*
     * ignore closed connection
     */
    if (! ISCONNECTED) {
	RETURN ( self );
    }

    if (__isExternalAddress(aWindowId)) {
	ENTER_XLIB();
	XUnmapWindow(myDpy, __WindowVal(aWindowId));
	LEAVE_XLIB();
	RETURN ( self );
    }
%}.
    self primitiveFailed
!

windowIsIconified:aWindowId
    "return true, if some window is iconified.
     The passed windowID may be an alien windows id."

    <context: #return>
%{

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	Atom JunkAtom;
	int JunkInt;
	unsigned long WinState,JunkLong;
	unsigned char *Property;
	Atom WM_STATE_Atom;

	if (__INST(wmStateAtom) != nil) {
	    WM_STATE_Atom = __AtomVal(__INST(wmStateAtom));

	    ENTER_XLIB();
	    XGetWindowProperty(myDpy, __WindowVal(aWindowId),
			       WM_STATE_Atom,
			       0L, 2L, False, AnyPropertyType,
			       &JunkAtom,&JunkInt,&WinState,&JunkLong,
			       &Property);
	    LEAVE_XLIB();
	    WinState=(unsigned long)(*((long*)Property));
	    if (WinState==3) {
		RETURN (true);
	    }
	}
	RETURN (false);
    }
%}.
    self primitiveFailedOrClosedConnection.
    ^ false "/ or true or what ?
! !

!XWorkstation::SelectionFetcher class methodsFor:'documentation'!

documentation
"
    This class is responsible for fetching the clipboard.
    The X11 clipboard is implemented via asynchonous messages.

    For each fetch operation an instance of this class is created.
    The asynchronous messages are queued and executed in the
    process that requests the clipboard.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!XWorkstation::SelectionFetcher class methodsFor:'selections'!

requestSelection:selectionId type:aTargetId onDevice:aDisplay for:aDrawableId
    ^ self new requestSelection:selectionId type:aTargetId onDevice:aDisplay for:aDrawableId
! !

!XWorkstation::SelectionFetcher methodsFor:'accessing'!

drawableID
    ^ drawableID
!

getSelection
    "convert the data in buffer to a selection"

    |selection|

    buffer isNil ifTrue:[
	^ nil.
    ].

    targetID == (display atomIDOf:#STRING) ifTrue:[
	display clipboardEncoding notNil ifTrue:[
	    selection := buffer decodeFrom:display clipboardEncoding
	].
	selection := buffer.
    ] ifFalse:[targetID == (display atomIDOf:#'UTF8_STRING') ifTrue:[
"/ Transcript show:'UTF8: '; showCR:buffer storeString.
	selection := buffer utf8Decoded.
    ] ifFalse:[targetID == (display atomIDOf:#TEXT) ifTrue:[
"/ Transcript show:'TEXT: '; showCR:buffer storeString.
	selection := buffer asString
    ] ifFalse:[targetID == (display atomIDOf:#'COMPOUND_TEXT') ifTrue:[
"/ Transcript show:'COMPOUND_TEXT: '; showCR:buffer storeString.
	selection := buffer asString
    ]]]].

    selection notNil ifTrue:[
	(selection endsWith:Character cr) ifTrue:[
	    selection := selection asStringCollection copyWith:''
	].
	^ selection.
    ].

    targetID == (display atomIDOf:#'TARGETS') ifTrue:[
	^ buffer
    ].
    targetID == (display atomIDOf:#'ST_OBJECT') ifTrue:[
	"require libboss to be loaded"
	(Smalltalk isClassLibraryLoaded:'libstx_libboss') ifFalse:[
	    'SelectionFetch: cannot decode object (libboss library missing)' errorPrintCR.
	    ^ nil
	].
	^ (Object
	    readBinaryFrom:(ReadStream on:buffer)
	    onError:[:ex |
		('SelectionFetch: error while decoding binary object: ',ex description) errorPrintCR.
		nil
	    ])
    ].

    'XWorkstation: unimplemented property targetID: ' infoPrint. (display atomName:targetID) infoPrint.
    ' buffer:' infoPrint. buffer infoPrintCR.
    ^ nil

    "Modified: / 23-08-2006 / 15:56:04 / cg"
! !

!XWorkstation::SelectionFetcher methodsFor:'event handling'!

message:aMessage
    "got an asynchronous event from the display.
     Save and wake up waiters"

    aMessage selector == #propertyChange:property:state:time: ifTrue:[
	(aMessage arguments at:2) ~~ propertyID ifTrue:[
	    "I am only interested in changes of the property used to
	     store the selection"
	    ^ self.
	].
	message notNil ifTrue:[
	    "this should not happen - bad selection holder?"
	    'XWorkstation(error): message overflow: ' errorPrint. display errorPrintCR.
	    ^ self.
	].
    ].

    "we get a propertyChange before the selectionNotify.
     Since the propertyChange will be ignored anyway (because we are not in incremental mod,
     a selectionNotify message may overwrite a propertyChange message"

    message := aMessage.
    sema signal.
!

propertyChange:aView property:aPropertyId state:stateSymbol time:time
    "this is a forwarded propretyChange event from XWorkstation"

    |property propertyValue|

    incremental ifFalse:[
	"ignore property changes until we are in incremental mode"
	^ self.
    ].

    property := display getProperty:propertyID from:drawableID delete:true.
    propertyValue := property value.

    propertyValue size == 0 ifTrue:[
	"property with size 0 signals end of transfer"
	done := true.
    ] ifFalse:[
	buffer isNil ifTrue:[
	    targetID := property key.
	    buffer := propertyValue.
	] ifFalse:[
	    targetID ~= property key ifTrue:[
		'XWorkstation(warning): targetID change in incremental select: ' errorPrint. display errorPrintCR.
	    ].
	    buffer := buffer, propertyValue.
	].
    ].
!

selectionClear:aView selection:selectionId time:time
    "sent when another X-client has created a selection.
     This is a very X-specific mechanism."
!

selectionNotify:aView selection:aSelectionID target:aTargetID property:aPropertyID requestor:requestorID time:time
    "this is a forwarded selectionNotify event from XWorkstation"

    |property propertyKey atomName|

    aSelectionID ~~ selectionID ifTrue:[
	"ignore notification that is not for our selection"
	^ self.
    ].

    aPropertyID == 0 ifTrue:[
	"the selection owner could not convert the selection to our target type"
	done := true.
	^ self.
    ].

    property := display getProperty:aPropertyID from:drawableID delete:true.
    property isNil ifTrue:[
	"the property does not exist in the specified window"
	done := true.
	^ self
    ].

    propertyKey := property key.
    propertyKey == aTargetID ifTrue:[
	"good, the property is consistent with our request.
	 The whole selection is in the property"
	buffer := property value.
	done := true.
    ] ifFalse:[propertyKey == (display atomIDOf:#INCR) ifTrue:[
	"this is an incremental transfer. Wait for property change"
	incremental := true.
    ] ifFalse:[
	atomName := (display atomName:propertyKey) ? propertyKey.
	'XWorkstation(error): unexpected targetID (' errorPrint.
	atomName errorPrint.
	') in selectionNotify: ' errorPrint.
	display errorPrintCR.
	done := true.
    ]].
! !

!XWorkstation::SelectionFetcher methodsFor:'selection actions'!

requestSelection:aSelectionId type:aTargetId onDevice:aDisplay for:aDrawableId
    "request the selection of type targetId.
     Wait for next asynchronous message and process it,
     until done"

    display := aDisplay.
    drawableID := aDrawableId.
    selectionID := aSelectionId.
    propertyID := display atomIDOf:#'VT_SELECTION'.
    targetID := aTargetId.
    sema := Semaphore new name:'X11SelectionFetcher'.
    done := false.
    incremental := false.

    [
	|timeout|

	display registerSelectionFetcher:self.

	display
	    requestSelection:aSelectionId
	    type:aTargetId
	    for:drawableID
	    intoProperty:propertyID.

	timeout := display xlibTimeout.
	[
	    |currentMessage|

	    (sema waitWithTimeout:timeout) isNil ifTrue:[
		"the selection owner didn't respond within reasonable time"
		'XWorkstation(error): selection owner does not respond:' infoPrint. display infoPrintCR.
		^ nil.
	    ].
	    currentMessage := message.
	    message := nil.
	    currentMessage notNil ifTrue:[currentMessage sendTo:self].
	] doUntil:[done].
    ] ensure:[
	display unregisterSelectionFetcher:self.
    ].

    ^ self getSelection
! !

!XWorkstation::SelectionFetcher methodsFor:'testing'!

matchesDrawableId:aDrawableId
    "return true, if this SelectionFetcher fetches for aDrawableId"

    ^ drawableID = aDrawableId
! !

!XWorkstation::WindowGroupWindow class methodsFor:'documentation'!

documentation
"
    A special window to serve as window group id. This window
    is newer mapped. This window is used
    in XWMHints, _NET_WM_LEADER and WM_CLIENT_LEADER properties 
    to define application window group

    [author:]
	Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
	Inter-Client Communication Conventions Manual [http://tronche.com/gui/x/icccm/]


"
! !

!XWorkstation::WindowGroupWindow methodsFor:'testing'!

isICCCWindowGroupWindow
    ^ true
! !

!XWorkstation::X11GraphicsContext methodsFor:'accessing'!

depth
    ^ depth
!

xftDrawId
    ^ xftDrawId
! !

!XWorkstation::X11GraphicsContext methodsFor:'destroying'!

destroy
    xftDrawId notNil ifTrue:[
	self destroyXftDrawId.
    ].
    super destroy.
!

destroyXftDrawId
    |id|

    id := xftDrawId.
    xftDrawId := nil.
%{
#ifdef XFT
    if (__isExternalAddress(id)) {
	XftDraw *address = (XftDraw *)__externalAddressVal(id);
	if (address) {
	    XftDrawDestroy(address);
	    __externalAddressVal(id) = 0;
	}
    }
#endif
%}.
! !

!XWorkstation::X11GraphicsContext methodsFor:'displaying'!

displayDeviceString:aString from:index1 to:index2 x:x y:y opaque:opaque
    "draw a sub-string - if opaque is false, draw foreground only; otherwise, draw both
     foreground and background characters.
     If the coordinates are not integers, an error is triggered."

    <context: #return>

    |displayId|

    font isXftFont ifTrue:[
	self displayDeviceXftString:aString from:index1 to:index2 x:x y:y opaque:opaque.
	^ self.
    ].

    device flushIfAppropriate.
    displayId := device displayIdOrErrorIfBroken.

%{
    GC gc;
    Window win;
    char *cp;
    int  i1, i2, l, n;
#   define NLOCALBUFFER 200
    XChar2b xlatebuffer[NLOCALBUFFER];
    int nInstBytes;

    if (__isExternalAddress(displayId)
     && __isExternalAddress(__INST(gcId))
     && __isExternalAddress(__INST(drawableId))
     && __isNonNilObject(aString)
     && __bothSmallInteger(index1, index2)
     && __bothSmallInteger(x, y)) {
	int lMax = __intVal(@global(XWorkstation:MaxStringLength));
	Display *dpy = __DisplayVal(displayId);
	gc = __GCVal(__INST(gcId));
	win = __WindowVal(__INST(drawableId));

	i1 = __intVal(index1) - 1;
	if (i1 >= 0) {
	    OBJ cls;

	    i2 = __intVal(index2) - 1;
	    if (i2 < i1) {
		RETURN (self);
	    }
	    cp = (char *) __stringVal(aString);
	    l = i2 - i1 + 1;

	    if (__isStringLike(aString)) {
		n = __stringSize(aString);
		if (i2 < n) {
		    cp += i1;
		    if (l > lMax) l = lMax;
		    __ENTER_XLIB(1000 * __intVal(@global(XWorkstation:DefaultXLibTimeout)));
		    if (opaque == true)
			XDrawImageString(dpy, win, gc, __intVal(x), __intVal(y), cp, l);
		    else
			XDrawString(dpy, win, gc, __intVal(x), __intVal(y), cp, l);
		    LEAVE_XLIB();
		    RETURN ( self );
		}
	    }

	    cls = __qClass(aString);
	    nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	    cp += nInstBytes;

	    if (__isBytes(aString)) {
		n = __byteArraySize(aString) - nInstBytes - 1;

		if (i2 < n) {
		    cp += i1;
		    if (l > lMax) l = lMax;
		    __ENTER_XLIB(1000 * __intVal(@global(XWorkstation:DefaultXLibTimeout)));
		    if (opaque == true)
			XDrawImageString(dpy, win, gc, __intVal(x), __intVal(y), cp, l);
		    else
			XDrawString(dpy, win, gc, __intVal(x), __intVal(y), cp, l);
		    LEAVE_XLIB();
		    RETURN ( self );
		}
	    }

	    /* TWOBYTESTRINGS */
	    if (__isWords(aString)) {
		n = (__byteArraySize(aString) - nInstBytes) / 2;
		if (i2 < n) {
		    union {
			char b[2];
			unsigned short s;
		    } u;
		    int i;
		    XChar2b *cp2 = (XChar2b *)0;
		    int mustFree = 0;

		    cp += (i1 * 2);
		    if (l > lMax) l = lMax;

#if defined(MSBFIRST) || defined(__MSBFIRST)
		    /*
		     * chars already in correct order
		     */
#else
# if ! (defined(LSBFIRST) || defined(__LSBFIRST))
		    /*
		     * ST/X TwoByteStrings store the asciiValue in native byteOrder;
		     * X expects them MSB first
		     * convert as required
		     */
		    u.s = 0x1234;
		    if (u.b[0] != 0x12)
# endif  // ! (defined(LSBFIRST) || defined(__LSBFIRST))
		    {
			if (l <= NLOCALBUFFER) {
			    cp2 = xlatebuffer;
			} else {
			    cp2 = (XChar2b *)(malloc(l * 2));
			    mustFree = 1;
			}
			for (i=0; i<l; i++) {
			    cp2[i].byte1 = (((XChar2b *)cp)[i]).byte2;
			    cp2[i].byte2 = (((XChar2b *)cp)[i]).byte1;
			}
			cp = (char *) cp2;
		    }
#endif  // ! (defined(MSBFIRST) || defined(__MSBFIRST))
		    __ENTER_XLIB(1000 * __intVal(@global(XWorkstation:DefaultXLibTimeout)));
		    if (opaque == true)
			XDrawImageString16(dpy, win, gc, __intVal(x), __intVal(y), (XChar2b *)cp, l);
		    else
			XDrawString16(dpy, win, gc, __intVal(x), __intVal(y), (XChar2b *)cp, l);
		    LEAVE_XLIB();

		    if (mustFree) {
			free(cp2);
		    }

		    RETURN ( self );
		}
	    }

	    /* FOURBYTESTRINGS */
	    if (__isLongs(aString)) {
		n = (__byteArraySize(aString) - nInstBytes) / 4;
		if (i2 < n) {
		    union {
			char b[2];
			unsigned short s;
		    } u;
		    int i;
		    XChar2b *cp2 = (XChar2b *)0;
		    int32 *ip;
		    int mustFree = 0;

		    cp += (i1 * 4);
		    if (l > lMax) l = lMax;

		    /*
		     * all codePoints <= 16rFFFF are draw; above 16bit range are drawn as 16rFFFF.
		     */
		    if (l <= NLOCALBUFFER) {
			cp2 = xlatebuffer;
		    } else {
			cp2 = (XChar2b *)(malloc(l * 2));
			mustFree = 1;
		    }
		    for (i=0; i<l; i++) {
			int32 codePoint = ((int32 *)cp)[i];

			if (codePoint > 0xFFFF) {
			    codePoint = 0xFFFF;
			}
			cp2[i].byte1 = (codePoint >> 8) & 0xFF;
			cp2[i].byte2 = codePoint & 0xFF;
		    }

		    __ENTER_XLIB(1000 * __intVal(@global(XWorkstation:DefaultXLibTimeout)));
		    if (opaque == true)
			XDrawImageString16(dpy, win, gc, __intVal(x), __intVal(y), (XChar2b *)cp2, l);
		    else
			XDrawString16(dpy, win, gc, __intVal(x), __intVal(y), (XChar2b *)cp2, l);
		    LEAVE_XLIB();

		    if (mustFree) {
			free(cp2);
		    }

		    RETURN ( self );
		}
	    }
	}
    }
#undef NLOCALBUFFER
%}.

    "x/y not integer, badGC or drawable, or not a string"
    device primitiveFailedOrClosedConnection
!

displayDeviceXftString:aString from:index1 to:index2Arg x:drawX y:drawY opaque:opaque
    "draw a sub-string - if opaque is false, draw foreground only; otherwise, draw both
     foreground and background characters.
     If the coordinates are not integers, an error is triggered."

    <context: #return>

    |index2 bytesPerCharacter
     clipX clipY clipW clipH
     fgR fgG fgB fgA fgPixel bgR bgG bgB bgA bgPixel
     displayId screen error stringLen
     newXftDrawId pixmapDepth fontId|

"/    device flushIfAppropriate.
    displayId := device displayIdOrErrorIfBroken.

    "limit the string len, otherwise bad output is generated"
    stringLen := index2Arg - index1 + 1.
    stringLen > 1000 "8000" ifTrue:[
	index2 := index1 + 1000 "8000" - 1.
    ]  ifFalse:[
	stringLen <= 0 ifTrue:[^ self].
	index2 := index2Arg.
    ].
    bytesPerCharacter := aString bytesPerCharacter.

    clipRect notNil ifTrue:[
	clipX := clipRect left.
	clipY := clipRect top.
	clipW := clipRect width.
	clipH := clipRect height.
"/clipW > 32767 ifTrue:['clipW > 32767: ' errorPrint. clipW errorPrintCR. clipW := 32767].
"/(clipX > 16384 or:[clipX < -16384]) ifTrue:['clipX > 16384: ' errorPrint. clipX errorPrintCR.].
	"/ YES YES YES: this MUST be transformed!!
	"/ (see htmlView) fix the notebook, please.
    ].

    fgR := paint scaledRed.
    fgR notNil ifTrue:[
	fgG := paint scaledGreen.
	fgB := paint scaledBlue.
	fgA := paint scaledAlpha.
    ] ifFalse:[
	"/ when drawing into a pixmap...
	fgPixel := paint colorId.
	fgPixel == 0 ifTrue:[
	    fgR := fgG := fgB := 0.
	] ifFalse:[
	    fgR := fgG := fgB := 16rFFFF.
	].
	fgA := 16rFFFF.
    ].

    opaque ifTrue:[
	bgPaint isColor ifTrue:[
	    bgR := bgPaint scaledRed.
	    bgR notNil ifTrue:[
		bgG := bgPaint scaledGreen.
		bgB := bgPaint scaledBlue.
		bgA := bgPaint scaledAlpha.
	    ] ifFalse:[
		"/ when drawing into a pixmap...
		bgPixel := bgPaint colorId.
		bgPixel == 0 ifTrue:[
		    bgR := bgG := bgB := 0.
		] ifFalse:[
		    bgR := bgG := bgB := 16rFFFF.
		].
		bgA := 16rFFFF.
	    ].
	] ifFalse:[
	    "images as background are not yet implemented"
	    "/ #todo: fill background rectangle
	    bgR := bgG := bgB := bgA := 16rFFFF.
	].
    ].

    screen := device screen.
    self isPixmap ifTrue:[
	pixmapDepth := depth.
    ].
    fontId := font getXftFontId.

%{ /* STACK: 64000 */
#ifdef XFT
    XftColor color;
    XGlyphInfo extents;
    XRectangle clipRX;
    char *string;
    int len;
    int __bytesPerCharacter;
    XftDraw *__xftDrawId;
    XftFont *__xftFont;

    if (!(__bothSmallInteger(drawX, drawY)
	  && __bothSmallInteger(index1, index2)
	  && __isSmallInteger(bytesPerCharacter)
	  && (__isSmallInteger(fgPixel) || (__bothSmallInteger(fgR, fgG) && __bothSmallInteger(fgB, fgA)))
	  && (opaque == false || __isSmallInteger(bgPixel) || (__bothSmallInteger(bgR, bgG) && __bothSmallInteger(bgB, bgA)))
	  && __isNonNilObject(aString)
	  && __isExternalAddress(displayId)
	  && __isExternalAddressLike(fontId)
    )) {
	error = @symbol(badArgument);
	goto out;
    }

    __xftFont = XFT_FONT(fontId);
    __bytesPerCharacter = __intVal(bytesPerCharacter);

    if (__INST(xftDrawId) != nil) {
	__xftDrawId = __externalAddressVal(__INST(xftDrawId));
    } else {
	if (pixmapDepth != nil) {
	    int __pixmapDepth = __intVal(pixmapDepth);

	    if (__pixmapDepth == 1) {
		__xftDrawId = XftDrawCreateBitmap(DISPLAY(displayId), DRAWABLE(__INST(drawableId)));
	    } else {
		__xftDrawId = XftDrawCreateAlpha(DISPLAY(displayId), DRAWABLE(__INST(drawableId)), __pixmapDepth);
	    }
	} else {
	    __xftDrawId = XftDrawCreate(DISPLAY(displayId),
					   DRAWABLE(__INST(drawableId)),
					   DefaultVisual(DISPLAY(displayId), SCREEN(screen)),
					   DefaultColormap(DISPLAY(displayId), SCREEN(screen)));
	}
	__INST(xftDrawId) = newXftDrawId = XFT_DRAW_HANDLE_NEW(__xftDrawId);
	__STORE(self, newXftDrawId);
    }

    string = __stringVal(aString) + ((__intVal(index1) - 1 ) * __bytesPerCharacter);
    len = __intVal(index2) - __intVal(index1) + 1;

    if (clipX != nil) {
	clipRX.x = __intVal(clipX);
	clipRX.y = __intVal(clipY);
	clipRX.width = __intVal(clipW);
	clipRX.height = __intVal(clipH);
	XftDrawSetClipRectangles(__xftDrawId, 0, 0, &clipRX, 1);
    } else {
	XftDrawSetClip(__xftDrawId, 0);
    }

    if (opaque == true) {
	if (bgPixel != nil) {
	    color.pixel = (unsigned long)__intVal(bgPixel);
	}
	color.color.red = __intVal(bgR);
	color.color.green = __intVal(bgG);
	color.color.blue = __intVal(bgB);
	color.color.alpha = __intVal(bgA);

	switch (__bytesPerCharacter) {
	case 1:
	    XftTextExtents8(DISPLAY(displayId), __xftFont, (FcChar8*)string, len, &extents);
	    break;
	case 2:
	    XftTextExtents16(DISPLAY(displayId), __xftFont, (FcChar16*)string, len, &extents);
	    break;
	case 4:
	    XftTextExtents32(DISPLAY(displayId), __xftFont, (FcChar32*)string, len, &extents);
	    break;
	}
if (extents.width < 0) printf("width: %d  < 0\n", extents.width);

	XftDrawRect(__xftDrawId, &color, __intVal(drawX) - extents.x, __intVal(drawY) - __xftFont->ascent, extents.width, __xftFont->height);
    }
    if (__isSmallInteger(fgPixel)) {
	color.pixel = (unsigned long)__intVal(fgPixel);
    }
    color.color.red = __intVal(fgR);
    color.color.green = __intVal(fgG);
    color.color.blue = __intVal(fgB);
    color.color.alpha = __intVal(fgA);

    switch (__bytesPerCharacter) {
    case 1:
	XftDrawString8(__xftDrawId, &color,__xftFont,
			__intVal(drawX),
			__intVal(drawY),
			(FcChar8*)string,
			len);
	break;

    case 2:
	XftDrawString16(__xftDrawId, &color, __xftFont,
			__intVal(drawX),
			__intVal(drawY),
			(FcChar16*)string,
			len);
	break;

    case 4:
	XftDrawString32(__xftDrawId, &color, __xftFont,
			__intVal(drawX),
			__intVal(drawY),
			(FcChar32*)string,
			len);
	break;

    default:
	error = @symbol(invalidStringSize);
	goto out;
    }

out:;
#endif
%}.
    error notNil ifTrue:[
	self primitiveFailed: error.
    ].
! !

!XWorkstation::X11GraphicsContext methodsFor:'drawing'!

XXclearDeviceRectangleX:x y:y width:width height:height
    device clearRectangleX:x y:y width:width height:height in:drawableId with:gcId
!

XXclearRectangleX:x y:y width:w height:h
    "draw a filled rectangle; apply transformation if nonNil"

    |pX pY nW nH pO pC|

    gcId isNil ifTrue:[
	self initGC
    ].
    transformation notNil ifTrue:[
	pO := transformation transformPoint:x@y.
	pC := transformation transformPoint:(x+w-1)@(y+h-1).
	pX := pO x.
	pY := pO y.
	nW := pC x - pX + 1.
	nH := pC y - pY + 1.

	nW < 0 ifTrue:[
	      nW := nW abs.
	      pX := pX - nW.
	].
	nH < 0 ifTrue:[
	      nH := nH abs.
	      pY := pY - nH.
	].
    ] ifFalse:[
	pX := x.
	pY := y.
	nW := w.
	nH := h.
    ].
    pX := pX rounded.
    pY := pY rounded.
    nW := nW rounded.
    nH := nH rounded.

    device
	clearRectangleX:pX
		     y:pY
		 width:nW
		height:nH
		    in:drawableId with:gcId
! !

!XWorkstation::X11GraphicsContext methodsFor:'view creation'!

createBitmapFromArray:data width:width height:height
    depth := 1.
    super createBitmapFromArray:data width:width height:height
!

createPixmapWidth:w height:h depth:d
    depth := d.
    super createPixmapWidth:w height:h depth:d
! !

!XWorkstation class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


XWorkstation initialize!
