"
COPYRIGHT (c) 1996 by Claus Gittinger
COPYRIGHT (c) 2017-2018 Patrik Svestka
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

DeviceWorkstation subclass:#WinWorkstation
	instanceVariableNames:'blackpixel whitepixel listOfFonts rootWin rootDC buttonsPressed
		eventTrace eventBuffer lastClipboardSequenceNumber'
	classVariableNames:'BeepDuration NativeDialogs NativeFileDialogs NativeWidgets
		NativeWidgetClassTable StandardColorValues IgnoreSysColorChanges
		IgnoreFontChanges SystemColorValues CanEndSession
		VerboseNativeDialogs'
	poolDictionaries:''
	category:'Interface-Graphics'
!

Object subclass:#AlphaBlendParameters
	instanceVariableNames:'sourceAlpha padding redMask greenMask blueMask'
	classVariableNames:''
	poolDictionaries:''
	privateIn:WinWorkstation
!

ByteArray variableByteSubclass:#CopyDataStructStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WinWorkstation
!

Object subclass:#MonitorInfo
	instanceVariableNames:'screenX screenY screenW screenH workX workY workW workH isPrimary
		name'
	classVariableNames:''
	poolDictionaries:''
	privateIn:WinWorkstation
!

DeviceHandle subclass:#PrinterDeviceContextHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WinWorkstation
!

!WinWorkstation primitiveDefinitions!
%{
#define TRACE_ALL_EVENTS      /* */

#define COUNT_RESOURCES       /* */
#define COUNT_BMP_RESOURCES   /* */
#define DEBUG_DELETEOBJECT    /* */
#define DEBUG_DC_REUSE        /* */
#define xxDEBUG_COLORIZE_WM_PAINT_RECTS1
#define xxDEBUG_COLORIZE_WM_PAINT_RECTS2
#define LOCK_DEBUG
#define xxSTARTUP_DISPATCHTHREAD_DEBUG

#define ADJUSTWINDOW
#define ALWAYSTRUECOLOR
#define WIN32THREADS

/* #define DEBUGMASK            /* */
#define SET_FOCUS_IN_WINTHREAD
#define SET_CURSOR_IN_WINTHREAD
#define DELAY_ENTER_LEAVE_WHILE_IN_SIZE_MOVE /* */
#define xxBEEP_IN_WINTHREAD    /* */
#define xxKEEP_STD_CURSORS     /* not useful - those are allocated only once, in any case */
#define xxHANDLE_VIEWGRAVITY   /* not yet working */
#define HANDLE_DEVICE_EVENTS
#define COMPRESS_WINDOWPOSCHANGED

#define USE_DRAW_MUTEX
#define GDIFLUSH_WHEN_CHANGING_CLIP       /* workaround a redraw problem (with dell?) */
#define LATE_GENERATE_EXPOSE              /* get update region from stx thread */
#define xxNO_CLEAR_FOR_WM_PAINT           /* do not fill exposed areas with bgColor */
#define xxLATE_CLEAR_FOR_WM_PAINT         /* fill exposed areas with bgColor in ST/X thread (instead of in event-thread) */
					  /* seems to be needed to avoid DC conflicts */

#if 0 /* DOES NOT WORK */
# define CACHE_LAST_PEN                  /* remember last pen in gcData */
# define CACHE_LAST_BRUSH                /* remember last brush in gcData */
# define CACHE_LAST_WM_PAINT_BRUSH       /* remember last viewBackground brush */
# define CACHE_LAST_WM_PAINT_DC          /* remember last viewBackground paints dc */
# define CACHE_LAST_TMP_FONT             /* */
#endif

#define CACHE_PEN
#define CACHE_BRUSH
#define CACHE_LAST_DC                   /* remember last DC in gcData */

#ifdef CACHE_PEN
# define xNUM_PEN_CACHED       16        /* that many solid pens are globally remembered */
# define NUM_PEN_CACHED       64        /* that many solid pens are globally remembered */
#else
# define NUM_PEN_CACHED       0
#endif

#ifdef CACHE_BRUSH
# define xNUM_BRUSH_CACHED     16         /* that many brushes are globally remembered */
# define NUM_BRUSH_CACHED     64         /* that many brushes are globally remembered */
#else
# define NUM_BRUSH_CACHED     0
#endif

#if defined(NO_CLEAR_FOR_WM_PAINT)
# define WM_PAINT_CLEAR_EARLY       0
# define WM_PAINT_CLEAR_LATE        0
#else
# if defined(LATE_CLEAR_FOR_WM_PAINT)
#  define WM_PAINT_CLEAR_EARLY       0
#  define WM_PAINT_CLEAR_LATE        1
# else
#  define WM_PAINT_CLEAR_EARLY       1
#  define WM_PAINT_CLEAR_LATE        0
# endif
#endif

#undef INT
#define INT WIN_INT
#undef Array
#define Array WIN_Array
#undef Number
#define Number WIN_Number
#undef Method
#define Method WIN_Method
#undef Point
#define Point WIN_Point
#undef Rectangle
/* #define Rectangle WIN_Rectangle */
#undef True
#define True WIN_True
#undef False
#define False WIN_False
#undef Block
#define Block WIN_Block
#undef Context
#define Context WIN_Context
#undef Date
#define Date WIN_Date
#undef Time
#define Time WIN_Time
#undef Delay
#define Delay WIN_Delay
#undef Signal
#define Signal WIN_Signal
#undef Set
#define Set WIN_Set
#undef Process
#define Process WIN_Process
#undef Processor
#define Processor WIN_Processor
#undef Message
#define Message WIN_Message
#undef String
#define String WIN_String
#undef Character
#define Character WIN_Character

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <assert.h>
/* #include <malloc.h> */
/* #include <math.h> */
/* #include <string.h> */

/*#include <stdarg.h>   */

#ifdef __BORLANDC__
# define NOATOM
# define NOGDICAPMASKS
# define NOMETAFILE
# define NOMINMAX
# define NOOPENFILE
# define NOSOUND
# define NOWH
# define NOCOMM
# define NOKANJI
# define NOCRYPT
# define NOMCX
# define WIN32_LEAN_AND_MEAN
# ifndef _WIN32_WINNT
#  define _WIN32_WINNT 0x0500    /* need this to get certain defines from winuser.h (WM_NCXBUTTONDOWN) */
# endif
# include <windows.h>
# include <shellapi.h>
# ifdef HANDLE_DEVICE_EVENTS
#  include <dbt.h>
# endif
# include <sys\timeb.h>
# include <dir.h>

#else

# define _USERENTRY /**/
# define NOATOM
# define NOGDICAPMASKS
# define NOMETAFILE
# define NOMINMAX
# define NOOPENFILE
# define NOSOUND
# define NOWH
# define NOCOMM
# define NOKANJI
# define NOCRYPT
# define NOMCX
# define WIN32_LEAN_AND_MEAN
# ifndef _WIN32_WINNT
#  define _WIN32_WINNT 0x0500    /* need this to get certain defines from winuser.h (WM_NCXBUTTONDOWN) */
#  undef WINVER
#  define WINVER 0x0501    /* need this to get AW_XXX defines from winuser.h */
# endif


# include <windows.h>
# ifdef HANDLE_DEVICE_EVENTS
#  include <dbt.h>
# endif
# include <shellapi.h>
# include <sys\timeb.h>
#endif

#ifndef MAXPATH
# define MAXPATH 2048   // not defined in MS Visual C 8
#endif

#include <commdlg.h>

#include <process.h>

#ifdef __DEF_Array
# undef Array
# define Array __DEF_Array
#endif
#ifdef __DEF_Number
# undef Number
# define Number __DEF_Number
#endif
#ifdef __DEF_Method
# undef Method
# define Method __DEF_Method
#endif
#ifdef __DEF_Point
# undef Point
# define Point __DEF_Point
#endif
#ifdef __DEF_Rectangle
# undef Rectangle
# define Rectangle __DEF_Rectangle
#else
# undef Rectangle
#endif
#ifdef __DEF_Block
# undef Block
# define Block __DEF_Block
#endif
#ifdef __DEF_Context
# undef Context
# define Context __DEF_Context
#endif
#ifdef __DEF_Date
# undef Date
# define Date __DEF_Date
#endif
#ifdef __DEF_Time
# undef Time
# define Time __DEF_Time
#endif
# ifdef __DEF_Set
#  undef Set
#  define Set __DEF_Set
# endif
# ifdef __DEF_Signal
#  undef Signal
#  define Signal __DEF_Signal
# endif
# ifdef __DEF_Delay
#  undef Delay
#  define Delay __DEF_Delay
# endif
# ifdef __DEF_Process
#  undef Process
#  define Process __DEF_Process
# endif
# ifdef __DEF_Processor
#  undef Processor
#  define Processor __DEF_Processor
# endif
# ifdef __DEF_Message
#  undef Message
#  define Message __DEF_Message
# endif
# ifdef __DEF_String
#  undef String
#  define String __DEF_String
# endif
# ifdef __DEF_Character
#  undef Character
#  define Character __DEF_Character
# endif

#if 0 /* does not work, anyway */
#ifndef WM_UNICHAR
# define WM_UNICHAR                              0x0109
#endif
#ifndef UNICODE_NOCHAR
# define UNICODE_NOCHAR                          0xFFFF
#endif
#endif

#undef INT
#define INT STX_INT
#undef UINT
#define UINT STX_UINT

/*
 * some defines - tired of typing ...
 */
#define _HANDLEVal(o)        (HANDLE)(__MKCP(o))
#define _HBITMAPVAL(o)       (HBITMAP)(__MKCP(o))
#define _HWNDVal(o)          (HWND)(__MKCP(o))
#define _HDCVal(o)           (HDC)(__MKCP(o))
#define _HPALETTEVal(o)      (HPALETTE)(__MKCP(o))
#define _HCURSORVal(o)       (HCURSOR)(__MKCP(o))
#define _HGDIOBJVal(o)       (HGDIOBJ)(__MKCP(o))
#define _LOGPALETTEVal(o)    (LOGPALETTE *)(__MKCP(o))
#define _COLORREFVal(o)      (COLORREF)(__MKCP(o))

#define _GCDATA(o)           ((struct gcData *)(__MKCP(o)))

#define WIDECHAR unsigned short

#ifdef LATER
  /* for multi-WIN display support, we need this as an instance var (as below)
   * however, there are many more places, where a single static datum is
   * used currently - therefore don't care for this - at least now.
   */
# define __rootDC             (HDC)(__MKCP(__INST(rootDC)))
#endif

#define ISCONNECTED         1

struct gcData {
    union {
	HDC         __hDC;
	struct gcData *__nextFree;
    } u;
    HWND        hWnd;
    HBITMAP     hBitmap;
    HBITMAP     save_hBitmap;
    HBITMAP     hMask;
    short       clipX;
    short       clipY;
    short       clipW;
    short       clipH;
    char        clipping;
    char        clipByChildren;
    char        bkMode;
    char        bitmapColorBitCount;
    short       maskOrgX;
    short       maskOrgY;
    short       lineWidth;
    short       fontAscent;
    int         lStyle;   /* is lineStyle | joinStyle | capStyle */
    int         rop2;
    int         bitbltrop2;
    COLORREF    fgColor;
    COLORREF    bgColor;
    HFONT       hFont;
    HFONT       save_hFont;
    HPEN        hPen;
    HPEN        save_hPen;
    HBRUSH      hBrush;
    HBRUSH      save_hBrush;
    char        doNotCacheOrRelease;
    char        reserve1;
    char        reserve2;
    char        reserve3;
    char        reserve4;
    int         reserve5;
};
#define _hDC u.__hDC

/*
 * some synthetic values
 */
/*****************************************************************
 * EVENT DEFINITIONS
 *****************************************************************/

/* Input Event Masks. Used as event-mask window attribute and as arguments
   to Grab requests.  Not to be confused with event names.  */

#define NoEventMask                     0L
#define KeyPressMask                    (1L<<0)
#define KeyReleaseMask                  (1L<<1)
#define ButtonPressMask                 (1L<<2)
#define ButtonReleaseMask               (1L<<3)
#define EnterWindowMask                 (1L<<4)
#define LeaveWindowMask                 (1L<<5)
#define PointerMotionMask               (1L<<6)
#define PointerMotionHintMask           (1L<<7)
#define Button1MotionMask               (1L<<8)
#define Button2MotionMask               (1L<<9)
#define Button3MotionMask               (1L<<10)
#if 0
# define Button4MotionMask               (1L<<11)
# define Button5MotionMask               (1L<<12)
#endif
#define ButtonMotionMask                (1L<<13)
#define KeymapStateMask                 (1L<<14)
#define ExposureMask                    (1L<<15)
#define VisibilityChangeMask            (1L<<16)
#define StructureNotifyMask             (1L<<17)
#define ResizeRedirectMask              (1L<<18)
#define SubstructureNotifyMask          (1L<<19)
#define SubstructureRedirectMask        (1L<<20)
#define FocusChangeMask                 (1L<<21)
#define PropertyChangeMask              (1L<<22)
#define ColormapChangeMask              (1L<<23)
#define OwnerGrabButtonMask             (1L<<24)

/* Event names.  Used in "type" field in XEvent structures.  Not to be
confused with event masks above.  They start from 2 because 0 and 1
are reserved in the protocol for errors and replies. */

#define KeyPress                2
#define KeyRelease              3
#define ButtonPress             4
#define ButtonRelease           5
#define MotionNotify            6
#define EnterNotify             7
#define LeaveNotify             8
#define FocusIn                 9
#define FocusOut                10
#define KeymapNotify            11
#define Expose                  12
#define GraphicsExpose          13
#define NoExpose                14
#define VisibilityNotify        15
#define CreateNotify            16
#define DestroyNotify           17
#define UnmapNotify             18
#define MapNotify               19
#define MapRequest              20
#define ReparentNotify          21
#define ConfigureNotify         22
#define ConfigureRequest        23
#define GravityNotify           24
#define ResizeRequest           25
#define CirculateNotify         26
#define CirculateRequest        27
#define PropertyNotify          28
#define SelectionClear          29
#define SelectionRequest        30
#define SelectionNotify         31
#define ColormapNotify          32
#define ClientMessage           33
#define MappingNotify           34
#define LASTEvent               35      /* must be bigger than any event # */

/* Key masks. Used as modifiers to GrabButton and GrabKey, results of QueryPointer,
   state in various key-, mouse-, and button-related events. */

/* modifier names.  Used to build a SetModifierMapping request or
   to read a GetModifierMapping request.  These correspond to the
   masks defined above. */
#define ShiftMapIndex           0
#define LockMapIndex            1
#define ControlMapIndex         2
#define Mod1MapIndex            3
#define Mod2MapIndex            4
#define Mod3MapIndex            5
#define Mod4MapIndex            6
#define Mod5MapIndex            7

#define ShiftMask               (1<<ShiftMapIndex)
#define LockMask                (1<<LockMapIndex)
#define ControlMask             (1<<ControlMapIndex)
#define Mod1Mask                (1<<Mod1MapIndex)
#define Mod2Mask                (1<<Mod2MapIndex)
#define Mod3Mask                (1<<Mod3MapIndex)
#define Mod4Mask                (1<<Mod4MapIndex)
#define Mod5Mask                (1<<Mod5MapIndex)


/* button masks.  Used in same manner as Key masks above. Not to be confused
   with button names below. */

#define Button1Mask            Button1MotionMask
#define Button2Mask            Button2MotionMask
#define Button3Mask            Button3MotionMask
#if 0
# define Button4Mask            Button4MotionMask
# define Button5Mask            Button5MotionMask
#endif
#define AnyButtonMask           (Button1Mask|Button2Mask|Button3Mask)

#if 0
# define AnyModifier             (1<<15)  /* used in GrabButton, GrabKey */
#endif

/* button names. Used as arguments to GrabButton and as detail in ButtonPress
   and ButtonRelease events.  Not to be confused with button masks above.
   Note that 0 is already defined above as "AnyButton".  */

#define Button1                 1
#define Button2                 2
#define Button3                 3
#if 0
# define Button4                 4
# define Button5                 5
#endif

#define CAPTURE_NONE     0
#define CAPTURE_IMPLICIT 7
#define CAPTURE_EXPLICIT 8

#define BK_UNDEF         0
#define BK_TRANSPARENT   1
#define BK_OPAQUE        2

#define GRAVITY_NONE        0
#define GRAVITY_S           1
#define GRAVITY_SW          2
#define GRAVITY_SE          3
#define GRAVITY_N           4
#define GRAVITY_NW          5
#define GRAVITY_NE          6
#define GRAVITY_E           7
#define GRAVITY_W           8

#if 0
# define ControlMask            8
# define ShiftMask              16
#endif
#define LeftAltMask            Mod1Mask
#define RightAltMask           Mod2Mask
#define TRANSLATED_KEY         Mod5Mask

#define WIN32PADDING 32

/*
 * synthetic events
 */
#define __WM_MOUSEENTER        0x10001
#define __WM_MOUSELEAVE        0x10002
#define __WM_GEXPOSE           0x10003
#define __WM_NOGEXPOSE         0x10004
#define __WM_ICONIFIED         0x10005
#define __WM_PAINT             0x10006

static int AltMask = RightAltMask;
static int MetaMask = LeftAltMask;

#define WhitePixel     RGB(0xFF, 0xFF, 0xFF)
#define BlackPixel     RGB(0, 0, 0)

/* #undef DEBUG /* */

#ifdef DEBUG
# define PRINTF(x)              { console_printf x;}
# define CPRINTF(x)             { if (__debug__ % 1) console_printf x;}
# define RESPRINTF(x)           /*{ if (__debug__) console_printf x;}*/
# define RES1PRINTF(x)          /*{ if (__debug__) console_printf x;}*/
# define RES_BMP_PRINTF(x)      /*{ if (__debug__) console_printf x;}*/
# define TH_DPRINTF(x)          /*{ if (__debug__) console_printf x;}*/
# define DPRINTF(x)             { if (__debug__) console_printf x;}
# define NDPRINTF(x)            { if (__debugNative__) console_printf x;}
# define NDPRINTF2(x)           { if (__debugNative__ > 1) console_printf x;}
# define DDPRINTF(x)            { if (__debug__ & 2) console_printf x;}
# define DDDPRINTF(x)           { if (__debug__ & 4) console_printf x;}
# define DDDDPRINTF(x)          { if (__debug__ & 16) console_printf x;}
# define BMDPRINTF(x)           { if (__debug__ & 2) console_printf x;}
# define EVENT_PRINTF(x)        { if (__debug__ & 8) console_printf x;}
# define EVENT_PRINTF2(x)       { if (__debug__ & 4) console_printf x;}
# define EVENT_PRINTF3(x)       /* */
# define DPRINTFIF(flag, x)                 { if (flag) console_printf x;}
# define EVENT_PRINTFIF(flag, x)            { if (flag && __debug__) console_printf x;}
# define UNHANDLED_EVENT_PRINTF(x)          { if (__debug__) { console_printf("unhandled: "); console_printf x; } }
# define UNHANDLED_EVENT_PRINTFIF(flag, x)  { if (flag && __debug__) { console_printf("unhandled: "); console_printf x; } }
#else
# define PRINTF(x)              /* */
# define CPRINTF(x)             /* */
# define RES_BMP_PRINTF(x)      /* */
# define RESPRINTF(x)           /* */
# define RES1PRINTF(x)          /* */
# define TH_DPRINTF(x)          /* */
# define DPRINTF(x)             /* */
# define NDPRINTF(x)            /* */
# define NDPRINTF2(x)           /* */
# define DDPRINTF(x)            /* */
# define DDDPRINTF(x)           /* */
# define DDDDPRINTF(x)          /* */
# define BMDPRINTF(x)           /* */
# define EVENT_PRINTF(x)        /* */
# define EVENT_PRINTF2(x)       /* */
# define EVENT_PRINTF3(x)       /* */
# define DPRINTFIF(flag, x)             /* */
# define EVENT_PRINTFIF(flag, x)        /* */
# define UNHANDLED_EVENT_PRINTF(x)      /* */
# define UNHANDLED_EVENT_PRINTFIF(flag, x)    /* */
#endif

extern void __internalError(char *);

/* # define EVENT_PRINTF(x)        { printf x;} */

#define INFOFPRINTF(__x__)                 \
    if (@global(InfoPrinting) == true) { \
	console_fprintf __x__;           \
    }

#define DEBUGFPRINTF(__x__)                 \
    if (@global(InfoPrinting) == true) { \
	console_fprintf __x__;           \
    }

#define BR_SOLID       0
#define BR_PATTERN     1

#define LINE_SOLID     0
#define LINE_DASH      1
#define LINE_DDASH     2

#ifdef KEEP_STD_CURSORS
# define _C_ARROW       1
# define _C_CROSS       2
# define _C_IBEAM       3
# define _C_ICON        4
# define _C_NO          5
# define _C_SIZE        6
# define _C_SIZEALL     7
# define _C_SIZENESW    8
# define _C_SIZENS      9
# define _C_SIZENWSE    10
# define _C_UPARROW     11
# define _C_WAIT        12

 static HCURSOR H_C_ARROW = (HCURSOR)0;
 static HCURSOR H_C_CROSS = (HCURSOR)0;
 static HCURSOR H_C_IBEAM = (HCURSOR)0;
 static HCURSOR H_C_ICON = (HCURSOR)0;
 static HCURSOR H_C_NO = (HCURSOR)0;
 static HCURSOR H_C_SIZE = (HCURSOR)0;
 static HCURSOR H_C_SIZEALL = (HCURSOR)0;
 static HCURSOR H_C_SIZENESW = (HCURSOR)0;
 static HCURSOR H_C_SIZENS = (HCURSOR)0;
 static HCURSOR H_C_SIZENWSE = (HCURSOR)0;
 static HCURSOR H_C_UPARROW = (HCURSOR)0;
 static HCURSOR H_C_WAIT = (HCURSOR)0;
 static HCURSOR H_C_APPSTARTING = (HCURSOR)0;
#endif /* KEEP_STD_CURSORS */

#ifdef EXIT_WITH_3_CTRL_Cs
static int ctrl_c_count = 0;            /* CTRL-C count */
#endif
#ifdef RELEASE_CAPTURE_WITH_3_ESCAPEs
static int escape_count = 0;            /* ESCAPE count */
#endif

static int evRootX, evRootY;
static int multiClickCount = 0;
static UINT lastMSGTime;
static UINT lastMouseWheelTime = 0;
static int lastClickX, lastClickY;
static int lastMotionX = -9999, lastMotionY = -9999;
static HWND lastMotionWnd = 0;
static int deltaDoubleClickX = -999;
static int deltaDoubleClickY = -999;
static UINT nextMultiClickTime;
static OBJ lastButton = 0;
static int inSizeMove = 0;
static int inSize = 0;
static int inMove = 0;
static HWND needDelayedMouseLeaveWindow = 0;
static HWND needDelayedMouseEnterWindow = 0;
static int delayedMouseEnterX, delayedMouseEnterY;
static int destroyWin;
static HDC   __tmpDC;
#ifdef CACHE_LAST_TMP_FONT
static HFONT __tmpDC_hfont = 0, __tmpDC_prev_hfont = 0;
#endif
static int __logPixelSY;

static int __isWinXP = 0;
static int __isWin2k = 0;
static int __isWinVista = 0;

#ifdef CACHE_LAST_DC
static struct gcData *lastGcData = 0;
static int            lastGcOwnerThreadID = 0;
static HWND           lastGcHWIN;
static HBITMAP        lastGcHBITMAP;
#endif

#ifndef __rootDC
 static HDC __rootDC;
#endif

#ifdef CACHE_PEN
static struct __penCache {
    HPEN            pen;
    unsigned int    clr;
} __penCache[NUM_PEN_CACHED];
#endif

#ifdef CACHE_BRUSH
static struct __brushCache {
    HBRUSH          brush;
    unsigned int    clr;
} __brushCache[NUM_BRUSH_CACHED];
#endif

/*
 * globally cached - never released
 */
static HPEN __blackPen = 0;
static HPEN __whitePen = 0;
static HPEN __nullPen = 0;
static HBRUSH __blackBrush = 0;
static HBRUSH __whiteBrush = 0;

static HPEN __bgPen = 0;
static int __bgPenColor = 0;

#define WM_THREAD_CREATEWINDOW     (WM_USER + 0x101)
#define WM_THREAD_DESTROYWINDOW    (WM_USER + 0x102)
#define WM_THREAD_SETFOCUS         (WM_USER + 0x103)
#define WM_THREAD_SETCAPTURE       (WM_USER + 0x104)
#define WM_THREAD_SETCURSOR        (WM_USER + 0x105)
#define WM_THREAD_BEEP             (WM_USER + 0x106)
#define WM_THREAD_REGISTERHOTKEY   (WM_USER + 0x107)
#define WM_THREAD_UNREGISTERHOTKEY (WM_USER + 0x108)

#define WM_TRAY_MESSAGE          (WM_USER + 0x200)

#define hasEventQueued() (eventQueueHead != NULL)
#define EVENT_THREAD_STACKSIZE  (4096*10)

typedef int (*intf)(int);

/*
 * keep the windows cursor and others local in the HWND struct.
 */
#define LI_TOPWIN       0x0001
#define LI_INPUTWIN     0x0002
#define LI_NATIVEWIN    0x0004

typedef struct {
	HCURSOR         hCursor;
	HBRUSH          viewBgBrush;  /* if that is nil, it has a solid bg color */
	COLORREF        viewBgColor;
	int             eventMask;
	short           flag;         /* LI_ - flags bits */
	short           minWidth;
	short           maxWidth;
	short           minHeight;
	short           maxHeight;
	short           currentMonitorWidth;
	short           currentMonitorHeight;
	short           bw;
	unsigned char   iconified;
	unsigned char   viewGravity;
	unsigned char   unmapping;
#if 0
	short           bgOffsX;      /* bg-pattern offset */
	short           bgOffsY;      /* bg-pattern offset */
#endif
	short           mouseX;       /* last mouseX */
	short           mouseY;       /* last mouseY */
	COLORREF        bdColor;
} localWindowInfo;
typedef localWindowInfo *plocalWindowInfo;

typedef struct createWindowInfo {
	localWindowInfo *localWindowInfo;  /* in param */
	HANDLE          newWinHandle;      /* out param */
	wchar_t         *windowName;       /* in params */
	wchar_t         *className;
	int             winStyleBits;
	int             winStyleBitsEx;
	HANDLE          parentHandle;
	int             x;
	int             y;
	int             dx;
	int             dy;
	HANDLE          hCreateEvent;
	short           infoWasRead;
	unsigned short  sequenceNr;
	unsigned        errCode;
} createWindowInfo;

#define INVALIDATED_CWI 0xFFFF             /* seqNr for invalidated CWI */

static createWindowInfo *pendingCREATEWINDOWInfo = 0;
static unsigned short pendingSequenceNr = INVALIDATED_CWI;

#define N_WINDOW_PRIVATE (sizeof(plocalWindowInfo))

#ifdef _WIN64

# define GWL_LOCALINFO  GWLP_USERDATA

# define SETLOCALWINDOWINFOPTR(__hWnd__,__ptr__) \
	SetWindowLongPtr(__hWnd__, GWL_LOCALINFO , (LONG_PTR)__ptr__)

# define GETLOCALWINDOWINFOPTR(__hWnd__) \
	((localWindowInfo *)GetWindowLongPtr(__hWnd__, GWL_LOCALINFO))

#else

# define GWL_LOCALINFO  GWL_USERDATA

# define SETLOCALWINDOWINFOPTR(__hWnd__,__ptr__) \
	SetWindowLong(__hWnd__, GWL_LOCALINFO , (DWORD)__ptr__)

# define GETLOCALWINDOWINFOPTR(__hWnd__) \
	((localWindowInfo *)GetWindowLong(__hWnd__, GWL_LOCALINFO))

#endif

#define SetWindow_Cursor(__hWnd__, __hCurs__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->hCursor = __hCurs__) : 0)

#define GetWindow_Cursor(__hWnd__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? GETLOCALWINDOWINFOPTR(__hWnd__)->hCursor : 0)

#define SetWindow_viewBgColor(__hWnd__, __viewBgColor__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->viewBgColor = __viewBgColor__) : 0)

#define GetWindow_viewBgColor(__hWnd__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? GETLOCALWINDOWINFOPTR(__hWnd__)->viewBgColor : 0)

#define SetWindow_bdColor(__hWnd__, __bdColor__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->bdColor = __bdColor__) : 0)

#define GetWindow_bdColor(__hWnd__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? GETLOCALWINDOWINFOPTR(__hWnd__)->bdColor : 0)

#define SetWindow_iconified(__hWnd__, __iconified__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->iconified = __iconified__) : 0)

#define GetWindow_iconified(__hWnd__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? GETLOCALWINDOWINFOPTR(__hWnd__)->iconified : 0)

#define SetWindow_unmapping(__hWnd__, __unmapping__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->unmapping = __unmapping__) : 0)

#define GetWindow_unmapping(__hWnd__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? GETLOCALWINDOWINFOPTR(__hWnd__)->unmapping : 0)

#define SetWindow_mouseX(__hWnd__, __mouseX__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->mouseX = __mouseX__) : 0)

#define GetWindow_mouseX(__hWnd__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? GETLOCALWINDOWINFOPTR(__hWnd__)->mouseX : 0)

#define SetWindow_mouseY(__hWnd__, __mouseY__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->mouseY = __mouseY__) : 0)

#define GetWindow_mouseY(__hWnd__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? GETLOCALWINDOWINFOPTR(__hWnd__)->mouseY : 0)

#define SetWindow_mouseXY(__hWnd__, __mouseX__, __mouseY__) \
	{ SetWindow_mouseX(__hWnd__, __mouseX__); SetWindow_mouseY(__hWnd__, __mouseY__); }

#define SetWindow_viewBgBrush(__hWnd__, __viewBgBrush__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->viewBgBrush = __viewBgBrush__) : (HBRUSH)0)

#define GetWindow_viewBgBrush(__hWnd__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? GETLOCALWINDOWINFOPTR(__hWnd__)->viewBgBrush : (HBRUSH)0)

#define SetWindow_bw(__hWnd__, __bw__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->bw = __bw__) : 0)

#define GetWindow_bw(__hWnd__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? GETLOCALWINDOWINFOPTR(__hWnd__)->bw : 0)

#define GetWindow_paintInfoPtr(__hWnd__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? &(GETLOCALWINDOWINFOPTR(__hWnd__)->paintInfo) : 0)

#define SetWindow_flag(__hWnd__, __flag__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->flag = __flag__) : 0)

#define GetWindow_flag(__hWnd__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? GETLOCALWINDOWINFOPTR(__hWnd__)->flag : 0)

#define GetWindow_eventMask(__hWnd__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->eventMask) : 0)

#define SetWindow_currentMonitorWidth(__hWnd__, __width__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->currentMonitorWidth = __width__) : 0)

#define SetWindow_currentMonitorHeight(__hWnd__, __height__) \
	(GETLOCALWINDOWINFOPTR(__hWnd__) ? (GETLOCALWINDOWINFOPTR(__hWnd__)->currentMonitorHeight = __height__) : 0)


struct queuedEvent {
	struct queuedEvent     *ev_next;
	int                     count;
	int                     ev_flag;
	HWND                    ev_hWnd;
	UINT                    ev_message;
	UINT                    ev_wParam;
	INT                     ev_arg1;
	INT                     ev_arg2;
	INT                     ev_arg3;
	INT                     ev_arg4;
	UINT                    ev_time;
};

#define ev_x    ev_arg1
#define ev_y    ev_arg2
#define ev_w    ev_arg3
#define ev_h    ev_arg4

#define ev_keyCode   ev_wParam
#define ev_scanCode  ev_arg3
#define ev_modifiers ev_arg4

#define EV_CHUNK_CNT    10000
#define xxEV_CHUNK_CNT    1000
#define EV_CHUNK_SZ     (EV_CHUNK_CNT*sizeof(struct queuedEvent))

#define BITBLT_COPY             SRCCOPY
#define BITBLT_COPYINVERTED     NOTSRCCOPY
#define BITBLT_XOR              SRCINVERT
#define BITBLT_AND              SRCAND
#define BITBLT_OR               SRCPAINT

typedef struct registerHotKeyInfo {
	HANDLE       hwnd;          /* in param */
	int          hotKeyId;      /* in param */
	unsigned int modifier;      /* in param */
	unsigned int virtualKey;    /* in params */
} registerHotKeyInfo;

/* PS_JOIN_MASK is missing from the mingw32 headers */
#ifndef PS_JOIN_MASK
# define PS_JOIN_MASK (PS_JOIN_BEVEL|PS_JOIN_MITER|PS_JOIN_ROUND)
#endif

%}
! !

!WinWorkstation primitiveVariables!
%{

static int firstInstance = 1;
static char *app_name = "ST/X";
static char *app_nameRoot = "ST/X:Root";
static char *app_namePopup = "ST/X:Popup";
static char *app_nameDialog = "ST/X:Dialog";
static wchar_t wapp_name[] = { 'S','T','/','X',0 };
static wchar_t wapp_nameRoot[] = { 'S','T','/','X',':','R','o','o','t',0 };
static wchar_t wapp_namePopup[] = { 'S','T','/','X',':','P','o','p','u','p',0 };
static wchar_t wapp_nameDialog[] = { 'S','T','/','X',':','D','i','a','l','o','g',0 };
static int __debug__ = 0;

static int __debug_WM_ALL__ = 0;
static int __debug_WM_MOUSEENTER__ = 0;
static int __debug_WM_MOUSELEAVE__ = 0;
static int __debug_WM_MOUSEMOVE__ = 0;
static int __debug_WM_MOUSEACTIVATE__ = 0;
static int __debug_WM_CHAR__ = 0;
static int __debug_WM_KEYUP__ = 0;
static int __debug_WM_KEYDOWN__ = 0;
static int __debug_WM_BUTTONUP__ = 0;
static int __debug_WM_BUTTONDOWN__ = 0;
static int __debug_WM_PAINT__ = 0;
static int __debug_WM_MOVING__ = 0;
static int __debug_WM_ERASEBKGND__ = 0;
static int __debug_WM_SETTEXT__ = 0;
static int __debug_WM_CTLCOLORSCROLLBAR__ = 0;
static int __debug_WM_GETICON__ = 0;
static int __debug_WM_EXPOSE__ = 0;
static int __debug_WM_SIZE__ = 0;
static int __debug_WM_WINDOWPOSCHANGING__ = 0;
static int __debug_WM_COPYDATA__ = 0;
static int __debug_WM_DROPFILES__ = 0;
static int __debug_WM_SHOWWINDOW__ = 0;
static int __debug_WM_SETCURSOR__ = 0;
static int __debug_WM_FOCUS__ = 0;

static int __debugNative__ = 0;
static int __depth;
static int __realDepth;
static HWND __rootWin = NULL;
static HWND __rootWinSpezial = NULL;
#if 0
static HDESK __rootDesk;
#endif

static int __activateOnClick = 1;
static int __focusFollowsMouse = 0;
static int __eatingMouseEvents = 0;
static int __ignoreButtonPressOnActivate = 0;
static int __rightButtonIsLowerWindow = 1;
static int __shiftedLeftButtonIsLowerWindow = 1;
static int __currentCapture = CAPTURE_NONE;

static HANDLE __currentPointerView = (HANDLE)0;

/* MessageDispatchThread */

#ifndef WIN32THREADS
static HANDLE _masterThread = NULL;
#endif
static DWORD _masterThreadId = 0;
static DWORD _dispatchThreadId = 0;
static DWORD _dispatchThreadId2 = 0;
#ifdef LOCK_DEBUG
static int lockCountEvents = 0;
#endif
static HANDLE hEventsMutex = NULL;
static char *hEventsMutexOwner = NULL;

#ifdef USE_PAINT_MUTEX
static HANDLE hPaintMutex = NULL;
# define AQUIRE_PAINT_MUTEX    { WaitForSingleObject(hPaintMutex, 100L); }
# define RELEASE_PAINT_MUTEX   { ReleaseMutex(hPaintMutex);              }
#else
# define AQUIRE_PAINT_MUTEX    { /* nothing */ }
# define RELEASE_PAINT_MUTEX   { /* nothing */ }
#endif

#ifdef USE_DRAW_MUTEX
static HANDLE hDrawMutex = NULL;
# define AQUIRE_DRAW_MUTEX     { WaitForSingleObject(hDrawMutex, 100L);  }
# define RELEASE_DRAW_MUTEX    { ReleaseMutex(hDrawMutex);  }
#else
# define AQUIRE_DRAW_MUTEX     { /* nothing */ }
# define RELEASE_DRAW_MUTEX    { /* nothing */ }
#endif

static HANDLE hCreateEvent = NULL;
static HANDLE hNeverTriggered = NULL;
static HANDLE hInputEvent = NULL;
static HANDLE hDispatchThreadRunningEvent = NULL;

#ifdef COUNT_RESOURCES
 static int __cnt_gcData;
 static int __cnt_createWindows;
 static int __cnt_cur;
 static int __cnt_font;
#endif
#ifdef COUNT_BMP_RESOURCES
 static int __cnt_bitmap;
#endif

static struct queuedEvent *eventFreeList  = (struct queuedEvent *) 0;
static struct queuedEvent *eventQueueHead = (struct queuedEvent *) 0;
static struct queuedEvent *eventQueueTail = (struct queuedEvent *) 0;
static int eventsendcount = 0;
static int eventempfcount = 0;

/*
 * up to NUM_FREE_GC gc's are kept in a local list
 * (away from free/malloc)
 */
#define xNUM_FREE_GC     50
#define NUM_FREE_GC     150
static struct gcData *gcDataFreeList = (struct gcData *)0;
static int gcDataNumFree = 0;

/*
 * remember the last background-paint brush
 * will be reused by next bg-paint, if it needs
 * the same color. Otherwise, the next bg-erase
 * will destroy this brush.
 */
#ifdef CACHE_LAST_WM_PAINT_BRUSH
 static HBRUSH last_wm_paint_brush = (HBRUSH) 0;
 static int    last_wm_paint_brush_clr = (HWND) 0;
#endif
#ifdef CACHE_LAST_WM_PAINT_DC
 static HWND last_wm_paint_win = 0;
 static HDC  last_wm_paint_dc = 0;
#endif

#ifdef COMPRESS_WINDOWPOSCHANGED
 static HWND lastPos_win = 0;
 static int lastPos_w;
 static int lastPos_h;
 static int lastPos_x;
 static int lastPos_y;
#endif

%}
! !

!WinWorkstation primitiveFunctions!
%{

extern HANDLE __getHInstance();

static void __debugEvent__() {}

#ifdef DEBUGMASK
static void
printMask(int mask) {
	if (mask & KeyPressMask)        console_printf("KeyPressMask\n");
	if (mask & KeyReleaseMask)      console_printf("KeyReleaseMask\n");
	if (mask & ButtonPressMask)     console_printf("ButtonPressMask\n");
	if (mask & ButtonReleaseMask)   console_printf("ButtonReleaseMask\n");
	if (mask & ButtonMotionMask)    console_printf("ButtonMotionMask\n");
	if (mask & PointerMotionMask)   console_printf("PointerMotionMask\n");
	if (mask & ExposureMask)        console_printf("ExposureMask\n");
	if (mask & FocusChangeMask)     console_printf("FocusChangeMask\n");
	if (mask & EnterWindowMask)     console_printf("EnterWindowMask\n");
	if (mask & LeaveWindowMask)     console_printf("LeaveWindowMask\n");
	if (mask & KeymapStateMask)     console_printf("KeymapStateMask\n");
	if (mask & VisibilityChangeMask)console_printf("VisibilityChangeMask\n");
	if (mask & StructureNotifyMask) console_printf("StructureNotifyMask\n");
	if (mask & ResizeRedirectMask)  console_printf("ResizeRedirectMask\n");
	if (mask & PropertyChangeMask)  console_printf("PropertyChangeMask\n");
	if (mask & ColormapChangeMask)  console_printf("ColormapChangeMask\n");
}
#endif

static int
st2RGB(int color, struct gcData *gcData)
{
	if (gcData && gcData->bitmapColorBitCount == 1) {
	    return (color ? WhitePixel : BlackPixel);
	}
#ifdef ALWAYSTRUECOLOR
	return (color & 0xffffff);
#else
	if (__depth < 15) {
	    return 0;
	} else {
	    if ((__depth == 16) || (__depth == 15)) {
		int ib = (color & 0x1f) << 3;
		int ig = ((color >> 5) & 0x3f) << 2;
		int ir = ((color >> 11) & 0x1f) << 3;
		ir |= 7;
		ig |= 3;
		ib |= 7;
		return RGB(ir,ig,ib);
	    }
	    return (color & 0xffffff);
	}
#endif
}

static int
RGB2st(int r, int g, int b)
{
	int ir,ig,ib,id;

#ifdef ALWAYSTRUECOLOR
	ir = (r >> 8) & 0xff;
	ig = (g >> 8) & 0xff;
	ib = (b >> 8) & 0xff;

	id = RGB( ir, ig, ib);
#else
	if (__depth < 15) {
	    id = 0;
	} else {
	    if ((__depth == 16) || (__depth == 15)) {
		ir = (r >> 11) & 0x1f;
		ig = (g >> 10) & 0x3f;
		ib = (b >> 11) & 0x1f;

		id = ( ir << 11 ) | ( ig << 5 ) | ib;
	    } else {
		ir = (r >> 8) & 0xff;
		ig = (g >> 8) & 0xff;
		ib = (b >> 8) & 0xff;

		id = RGB( ir, ig, ib);
	    }
	}
#endif
	return id;
}

#if 0
/*
 * return a windows top-window
 */
static HWND
GetTopParent(HWND hwnd)
{
	HWND lastParent = hWnd;
	HWND nextParent;

	while (nextParent = GetParent(lastParent)) {
	    lastParent = nextParent;
	}
	return lastParent;
}
#endif

#ifdef DEBUG_DELETEOBJECT

static int
_DeleteObject(HANDLE o, int lineNr)
{
    int r = DeleteObject(o);

    if (r == 0)
	console_fprintf(stderr, "WinWorkstation [warning]: ERROR in DeleteObject %x [%d]\n", o, lineNr);
    return r;
}

#else
# define _DeleteObject(o,lnr)  DeleteObject(o)
#endif

static void
_DeleteFont(HFONT f, int lineNr)
{
#ifdef CACHE_LAST_TMP_FONT
    if (f == __tmpDC_hfont) {
	SelectObject(__tmpDC, __tmpDC_prev_hfont);
	__tmpDC_hfont = NULL;
    }
#endif
    _DeleteObject(f, lineNr);
}

static int
_DeleteBrush(HBRUSH br, int lineNr)
{
    if ((br != __whiteBrush) && (br != __blackBrush)) {
	int r = DeleteObject(br);

	if (r == 0)
	    console_fprintf(stderr, "WinWorkstation [warning]: ERROR in DeleteBrush %x [%d]\n", br, lineNr);
	return r;
    }
    return 1;
}

static int
_DeletePen(HPEN p, int lineNr)
{
    if ((p != __whitePen) && (p != __blackPen)) {
	int r = DeleteObject(p);

	if (r == 0)
	    console_fprintf(stderr, "WinWorkstation [warning]: ERROR in DeletePen %x [%d]\n", p, lineNr);
	return r;
    }
    return 1;
}

#ifdef CACHE_PEN

static int
_DeletePenIfNotInCache(HPEN p, int lineNr)
{
    int i, r;

    if ((p == __whitePen) || (p == __blackPen)) {
	return 1; /* not deleted, but OK */
    }
    for (i=0; i<NUM_PEN_CACHED;i++) {
	if (__penCache[i].pen == p) {
	    return 1; /* not deleted, but OK */
	}
    }
    r = DeleteObject(p);

    if (r == 0)
	console_fprintf(stderr, "WinWorkstation [warning]: ERROR in DeletePen2 %x [%d]\n", p, lineNr);
    return r;
}

#else
# define _DeletePenIfNotInCache(p, lineNr)   _DeletePen(p, lineNr)
#endif /* CACHE_PEN */

#ifdef CACHE_BRUSH

static int
_DeleteBrushIfNotInCache(HBRUSH br, int lineNr)
{
    int i, r;

    for (i=0; i<NUM_BRUSH_CACHED;i++) {
	if (__brushCache[i].brush == br) {
	    return 1; /* not deleted, but OK */
	}
    }
    if ((br == __whiteBrush) || (br == __blackBrush)) {
	return 1; /* not deleted, but OK */
    }
    r = DeleteObject(br);

    if (r == 0)
	console_fprintf(stderr, "WinWorkstation [warning]: ERROR in DeleteBrush2 %x [%d]\n", br, lineNr);
    return r;
}

#else
# define _DeleteBrushIfNotInCache(br, lineNr)   _DeleteBrush(br, lineNr)
#endif /* CACHE_BRUSH */

static struct gcData *
newGcData(void)
{
    struct gcData *gcData;

    if (gcDataFreeList) {
	gcData = gcDataFreeList;
	gcDataFreeList = gcData->u.__nextFree;
	gcDataNumFree--;
    } else {
	gcData = (struct gcData *) malloc(sizeof(struct gcData));
	if (! gcData) {
	    console_fprintf(stderr, "WinWorkstat [warning]: failed to allocate gcData\n");
	    return 0;
	}
    }

    memset(gcData, 0, sizeof(struct gcData));
    gcData->fgColor = 0xffffff;
    /* gcData->bgColor = 0; - not needed - memset does it */
    gcData->clipping = FALSE;
    gcData->clipByChildren = TRUE;
    gcData->bitbltrop2 = BITBLT_COPY;
    gcData->lineWidth = 1;
    gcData->lStyle = PS_SOLID | PS_JOIN_MITER | PS_ENDCAP_FLAT;
    /* gcData->brushOrgX = gcData->brushOrgY = 0; - not needed - memset does it */
    /* gcData->hPen = 0; - not needed - memset does it */
    /* gcData->hBrush = 0; - not needed - memset does it */
    return gcData;
}

static void
freeGcData(struct gcData *gcData)
{
    if (gcDataNumFree < NUM_FREE_GC) {
	gcData->u.__nextFree = gcDataFreeList;
	gcDataFreeList = gcData;
	gcDataNumFree++;
    } else {
	free(gcData);
    }
}

#ifdef CACHE_LAST_DC
# define FLUSH_CACHED_DC(__gcData__) \
    if (lastGcData == __gcData__) {  \
	_releaseDC(lastGcData);      \
    }
#else
# define FLUSH_CACHED_DC(x)     /* */
#endif

#ifdef CACHE_LAST_PEN
# define FLUSH_CACHED_PEN(__gcData__) \
    if (__gcData__->hPen) {           \
	if (__gcData__->save_hPen) {  \
	    SelectObject(__gcData__->_hDC, __gcData__->save_hPen); \
	    __gcData__->save_hPen = 0;   \
	} \
	_DeletePenIfNotInCache(__gcData__->hPen, __LINE__); \
	__gcData__->hPen = 0; \
    }
#else
# define FLUSH_CACHED_PEN(x)    /* */
#endif

#ifdef CACHE_LAST_BRUSH
# define FLUSH_CACHED_BRUSH(__gcData__) \
    if (__gcData__->hBrush) {           \
	if (__gcData__->save_hBrush) {  \
	    SelectObject(__gcData__->_hDC, __gcData__->save_hBrush); \
	    __gcData__->save_hBrush = 0;   \
	} \
	_DeleteBrushIfNotInCache(__gcData__->hBrush, __LINE__); \
	__gcData__->hBrush = 0; \
    }
#else
# define FLUSH_CACHED_BRUSH(x)    /* */
#endif

static void
_releaseDC(struct gcData *gcData)
{
    HDC hDC = gcData->_hDC;

    if (gcData->doNotCacheOrRelease ) {
	return;
    }

    if (gcData->save_hPen) {
	SelectObject(hDC, gcData->save_hPen);
	gcData->save_hPen = 0;
    }
    if (gcData->save_hBrush) {
	SelectObject(hDC, gcData->save_hBrush);
	gcData->save_hBrush = 0;
    }
    if (gcData->save_hFont) {
	SelectObject(hDC, gcData->save_hFont);
	gcData->save_hFont = 0;
    }

    if (gcData->hWnd) {
	if (hDC) {
	    ReleaseDC(gcData->hWnd, hDC);
#ifdef CACHE_LAST_WM_PAINT_DC
	    if (hDC == last_wm_paint_dc) {
		last_wm_paint_dc = last_wm_paint_win = 0;
# ifdef DEBUG_DC_REUSE
		console_fprintf(stderr, "WinWorkstation [info]: Oops - releasing bg_paint-dc\n");
# endif
	    }
#endif
	}
    } else if (gcData->hBitmap) {
	SelectObject(hDC, gcData->save_hBitmap);
	DeleteDC(hDC);
    }
    gcData->_hDC = 0;

#ifdef CACHE_LAST_DC
    if (lastGcData == gcData) {
	lastGcData = 0;
    }
#endif
#ifdef CACHE_LAST_PEN
    if (gcData->hPen) {
	_DeletePenIfNotInCache(gcData->hPen, __LINE__);
	gcData->hPen = 0;
    }
#endif
#ifdef CACHE_LAST_BRUSH
    if (gcData->hBrush) {
	_DeleteBrushIfNotInCache(gcData->hBrush, __LINE__);
	gcData->hBrush = 0;
    }
#endif
}

static HDC
_getDC(struct gcData *gcData)
{
    HDC hDC;
    int currThreadId;

    if (gcData->doNotCacheOrRelease ) {
	return gcData->_hDC;
    }

#ifdef CACHE_LAST_DC
    currThreadId = GetCurrentThreadId();

    if (lastGcData) {
	if ((lastGcData == gcData)
	 && (lastGcHWIN == gcData->hWnd)
	 && (lastGcHBITMAP == gcData->hBitmap)
	 && (lastGcOwnerThreadID == currThreadId)
	 && gcData->_hDC
	) {
# ifdef CACHE_LAST_WM_PAINT_DC /* DDD */
	    if (last_wm_paint_dc == gcData->_hDC) {
#  ifdef DEBUG_DC_REUSE
		console_fprintf(stderr, "WinWorkstation [info]: Oops wm_paint_dc reuse [%d]\n", __LINE__);
#  endif
		last_wm_paint_dc = last_wm_paint_win = 0;
	    }
# endif
	    return gcData->_hDC;
	}

	_releaseDC(lastGcData);
	lastGcData = 0;
    }
#endif

    hDC = 0;
    if (gcData->hWnd != 0) {
	if (gcData->hWnd == __rootWin) {
	    hDC = gcData->_hDC = GetDCEx(gcData->hWnd, 0, DCX_WINDOW);
	} else if (gcData->clipByChildren) {
	    //gcData->_hDC = GetDCEx(gcData->hWnd, 0, DCX_CLIPCHILDREN);
	    hDC = gcData->_hDC = GetDC(gcData->hWnd);
	} else  {
	    hDC = gcData->_hDC = GetDCEx(gcData->hWnd, 0, DCX_PARENTCLIP);
	}
    } else if (gcData->hBitmap) {
	hDC = gcData->_hDC = CreateCompatibleDC(__tmpDC);
	gcData->save_hBitmap = SelectObject(gcData->_hDC,gcData->hBitmap);
    }
    gcData->bkMode = BK_UNDEF;

    if (hDC) {
	SetTextColor(hDC, gcData->fgColor);
	SetBkColor(hDC, gcData->bgColor);

	if (gcData->rop2)
	    SetROP2(hDC, gcData->rop2);

	if (gcData->clipping) {
	    HRGN region = CreateRectRgn( gcData->clipX, gcData->clipY,
					 gcData->clipX + gcData->clipW,
					 gcData->clipY + gcData->clipH);
	    if (region == NULL ) {
		console_fprintf(stderr, "WinWorkstat [warning]: clipping region creation failed\n");
	    } else {
		if (SelectClipRgn(hDC, region) == ERROR ) {
		    DPRINTF(("WinWorkstat [warning]: select clipping region failed\n" ));
		}
		_DeleteObject(region, __LINE__);
	    }
	} else {
	    SelectClipRgn(hDC, NULL);
	}

	if (gcData->hFont) {
	    HFONT prevFont;

	    prevFont = SelectObject(hDC, gcData->hFont);
	    if (! gcData->save_hFont) {
		gcData->save_hFont = prevFont;
	    }
	}
    }

#ifdef CACHE_LAST_DC
    lastGcData = gcData;
    lastGcOwnerThreadID = currThreadId;
    lastGcHWIN = gcData->hWnd;
    lastGcHBITMAP = gcData->hBitmap;

    gcData->_hDC = hDC;

# ifdef CACHE_LAST_WM_PAINT_DC /* DDD */
    if (last_wm_paint_dc == hDC) {
#  ifdef DEBUG_DC_REUSE
	console_fprintf(stderr, "WinWorkstation [info]: Oops wm_paint_dc reuse [%d]\n", __LINE__);
#  endif
	last_wm_paint_dc = last_wm_paint_win = 0;
    }
# endif
#endif

    return hDC;
}

static HBRUSH
GcDataGetBrush(HDC hDC, struct gcData *gcData)
{
    HBRUSH hBrush = 0;
    HBRUSH prevBrush;

#ifdef CACHE_LAST_BRUSH
    if (hBrush = gcData->hBrush) {
	if (! gcData->save_hBrush) {
	    gcData->save_hBrush = SelectObject(gcData->_hDC, hBrush);
	}
	return hBrush;
    }
#endif
    if (gcData->hMask) {
	hBrush = CreatePatternBrush(gcData->hMask);
	SetBrushOrgEx(hDC, gcData->maskOrgX, gcData->maskOrgY, 0);
	RESPRINTF(("CreatePatternBrush %x\n",gcData->hMask));
    } else {
	if (gcData->fgColor == BlackPixel) {
	    hBrush = __blackBrush;
	} else if (gcData->fgColor == WhitePixel) {
	    hBrush = __whiteBrush;
	} else {
#ifdef CACHE_BRUSH
	    {
		int i;

		for (i=0; i<NUM_BRUSH_CACHED; i++) {
		    if (__brushCache[i].clr == gcData->fgColor) {
			hBrush = __brushCache[i].brush;
			/*
			 * move it up in the cache
			 */
			if (i > 0) {
			    HBRUSH t = __brushCache[i-1].brush;
			    int c = __brushCache[i-1].clr;

			    __brushCache[i-1].brush = hBrush;
			    __brushCache[i-1].clr = gcData->fgColor;
			    __brushCache[i].brush = t;
			    __brushCache[i].clr = c;
			}
# ifdef CACHE_LAST_BRUSH
			prevBrush = SelectObject(gcData->_hDC, hBrush);
			if (! gcData->save_hBrush) {
			    gcData->save_hBrush = prevBrush;
			}
			gcData->hBrush = hBrush;
# endif
			return hBrush;
		    }
		}
	    }
#endif /* BRUSH_CACHE */
	    hBrush = CreateSolidBrush(gcData->fgColor);
	    RESPRINTF(("CreateSolidBrush %x\n",gcData->fgColor));
	}
    }
    gcData->hBrush = hBrush;

    prevBrush = SelectObject(gcData->_hDC, hBrush);
    if (! gcData->save_hBrush) {
	gcData->save_hBrush = prevBrush;
    }
    return hBrush;
}

#ifdef CACHE_LAST_BRUSH
# define GcDataReleaseBrush(hDC, gcData)  /* nothing*/
#else
static void
GcDataReleaseBrush(HDC hDC, struct gcData *gcData)
{
    HBRUSH hBrush = gcData->hBrush;

    if (gcData->save_hBrush) {
	SelectObject(hDC, gcData->save_hBrush);
	gcData->save_hBrush = NULL;
    }
    _DeleteBrushIfNotInCache(hBrush, __LINE__);
    gcData->hBrush = 0;
}
#endif

static HPEN
GcDataGetPen(HDC hDC, struct gcData *gcData)
{
    HPEN hPen = 0;
    HPEN prevPen;
    LOGBRUSH Brush;
    int lw;

#ifdef CACHE_LAST_PEN
    if (hPen = gcData->hPen) {
	if (! gcData->save_hPen) {
	    gcData->save_hPen = SelectObject(gcData->_hDC, hPen);
	}
	return hPen;
    }
#endif

    if (((gcData->lStyle & PS_STYLE_MASK) == PS_SOLID)
     && (gcData->hMask == 0)
     && (gcData->lineWidth <= 1)) {
	if (gcData->fgColor == BlackPixel) {
	    gcData->hPen = hPen = __blackPen;
	    prevPen = SelectObject(hDC, hPen);
	    if (! gcData->save_hPen) {
		gcData->save_hPen = prevPen;
	    }
	    return hPen;
	}
	if (gcData->fgColor == WhitePixel) {
	    gcData->hPen = hPen = __whitePen;
	    prevPen = SelectObject(hDC, hPen);
	    if (! gcData->save_hPen) {
		gcData->save_hPen = prevPen;
	    }
	    return hPen;
	}

#ifdef CACHE_PEN
	{
	    int i;

	    for (i=0; i<NUM_PEN_CACHED; i++) {
		if (__penCache[i].clr == gcData->fgColor) {
		    hPen = __penCache[i].pen;
		    /*
		     * move it up in the cache
		     */
		    if (i > 0) {
			HPEN t = __penCache[i-1].pen;
			int c = __penCache[i-1].clr;

			__penCache[i-1].pen = hPen;
			__penCache[i-1].clr = gcData->fgColor;
			__penCache[i].pen = t;
			__penCache[i].clr = c;
		    }

		    gcData->hPen = hPen;
		    prevPen = SelectObject(hDC, hPen);
		    if (! gcData->save_hPen) {
			gcData->save_hPen = prevPen;
		    }
		    return hPen;
		}
	    }
	}
#endif /* PEN_CACHE */
    }

    hPen = (HPEN) 0;
    lw = gcData->lineWidth;
    if (lw == 0) {
	lw = 1;
    }

    /*
     * NT supports masked drawing with any lineStyle,
     * and also non-solid lines with any lineWidth.
     */
    if (gcData->hMask) {
	Brush.lbStyle = BS_PATTERN;
	Brush.lbHatch = (ULONG_PTR)(gcData->hMask);
	Brush.lbColor = gcData->fgColor;
    } else {
	Brush.lbStyle = BS_SOLID;
	Brush.lbHatch = (ULONG_PTR)0;
	Brush.lbColor = gcData->fgColor;

	hPen = (HPEN) 0;

#if USE_OLD_CREATE_PEN
	hPen = CreatePen((gcData->lStyle & PS_STYLE_MASK), lw, gcData->fgColor);

	RESPRINTF(("CreatePen %x %d(%d) %x %x\n",
		    gcData->lStyle,
		    lw, gcData->lineWidth,
		    gcData->fgColor, gcData->hMask));
#endif

	SetBkMode(hDC, TRANSPARENT);
	gcData->bkMode = BK_TRANSPARENT;

	if (! hPen) {
	    hPen = ExtCreatePen(PS_GEOMETRIC | gcData->lStyle,
			    lw, /* gcData->lineWidth, */
			    &Brush,
			    0, 0);

	    RESPRINTF(("ExtCreatePen1 %x %d(%d) %x %x\n",
			gcData->lStyle,
			lw, gcData->lineWidth,
			gcData->fgColor, gcData->hMask));

	    if (gcData->hMask) {
		SetBrushOrgEx(hDC, gcData->maskOrgX, gcData->maskOrgY, 0);
	    }
	}
    }

    gcData->hPen = hPen;
    prevPen = SelectObject(hDC, hPen);
    if (! gcData->save_hPen) {
	gcData->save_hPen = prevPen;
    }

#ifdef CACHE_PEN
    /*
     * remember in penCache
     */
    if (((gcData->lStyle & PS_STYLE_MASK) == PS_SOLID)
     && (gcData->hMask == 0)
     && (gcData->lineWidth <= 1)) {
	int i;

	/*
	 * search for an empty slot
	 */
	for (i=0; i<NUM_PEN_CACHED; i++) {
	    if (__penCache[i].pen == 0) {
		__penCache[i].clr = gcData->fgColor;
		__penCache[i].pen = hPen;
		break;
	    }
	}
	if (i == NUM_PEN_CACHED) {
	    /*
	     * replace last in penCache
	     */
	    HPEN t = __penCache[NUM_PEN_CACHED - 1].pen;

	    __penCache[NUM_PEN_CACHED - 1].pen = hPen;
	    __penCache[NUM_PEN_CACHED - 1].clr = gcData->fgColor;
	    _DeletePen(t, __LINE__);
	}
    }
#endif

    return hPen;
}

#ifdef CACHE_LAST_PEN
# define GcDataReleasePen(HDC hDC, struct gcData *gcData)  /* nothing*/
#else
static void
GcDataReleasePen(HDC hDC, struct gcData *gcData)
{
    HPEN hPen;

    if (gcData->save_hPen) {
	SelectObject(hDC, gcData->save_hPen);
	gcData->save_hPen = NULL;
    }
    hPen = gcData->hPen;
    _DeletePenIfNotInCache(hPen, __LINE__);
    gcData->hPen = 0;
}
#endif /* CACHE_LAST_PEN */

/* atze */

static int
lockEvents(char *whoIsLocking)
{
    DWORD dwWaitResult = WaitForSingleObject(hEventsMutex, 5000L);

#ifdef LOCK_DEBUG
    lockCountEvents++;
    if (lockCountEvents != 1) {
	console_fprintf(stderr, "WinWorkstation [warning]: lockCountEvents (%d) != 1 in lock\n", lockCountEvents);
	lockCountEvents = 1;
    }
#endif

    switch (dwWaitResult) {
	case WAIT_OBJECT_0:
	    hEventsMutexOwner = whoIsLocking;
	    return (TRUE);

	case WAIT_ABANDONED:
	    console_fprintf(stderr, "WinWorkstation [warning]: lockEvent abandoned (was owned by %s)\n",
			(hEventsMutexOwner ? hEventsMutexOwner : "NONE"));
	    hEventsMutexOwner = whoIsLocking;
	    return (TRUE);

	case WAIT_TIMEOUT:
	    console_fprintf(stderr, "WinWorkstation [warning]: lockEvent timeout (owned by %s)\n",
			(hEventsMutexOwner ? hEventsMutexOwner : "NONE") );
	    break;

	default:
	    {
		unsigned errCode = GetLastError();

		console_fprintf(stderr, "WinWorkstation [error]: lockEvent error (owned by %s) rslt=0x%x err=0x%x\n",
			    (hEventsMutexOwner ? hEventsMutexOwner : "NONE"),
			    dwWaitResult, errCode );
	    }
	    break;
    }
    return (FALSE);
}

static int
unlockEvents(void) {
#ifdef LOCK_DEBUG
    lockCountEvents--;
    if (lockCountEvents != 0) {
	console_fprintf(stderr, "WinWorkstation [warning]: lockCountEvents (%d) != 0 in unlock\n", lockCountEvents);
	lockCountEvents = 0;
    }
#endif
    if (! ReleaseMutex(hEventsMutex)) {
       console_fprintf(stderr, "WinWorkstation [error]: unlockEvent error\n");
       return (FALSE);
    }
    hEventsMutexOwner = NULL;

    return (TRUE);
}


static int
initEventqueue(void) {
    struct queuedEvent *bulk;
    int i;

    bulk = (struct queuedEvent *) malloc(EV_CHUNK_SZ);
    if (bulk == 0) {
	console_fprintf(stderr, "WinWorkstation [warning]: no memory for dispatchqueue\n");
	return 0;
    }
    for (i=1; i<EV_CHUNK_CNT; i++) {
	bulk[i-1].ev_next = &(bulk[i]);
    }
    bulk[EV_CHUNK_CNT-1].ev_next = (struct queuedEvent *)0;
    eventFreeList = bulk;

    return 1;
}

#define EV_NOTIME       0

#define enqEvent(a1, a2, a3, a4, a5, a6, a7, a8, a9) \
    __enqEvent(a1, a2, a3, a4, a5, a6, a7, a8, a9)

static void
__enqEvent(int flag, HWND hWnd, UINT message, UINT wParam, INT arg1, INT arg2, INT arg3, INT arg4, UINT evTime)
{
    struct queuedEvent *ev = 0;
    int repeatCount = 0;

    /* get an event struct
    */
    while (! eventFreeList) {
	if (repeatCount++ >= 5) {
	    /* throw away sorry */
	    console_fprintf(stderr, "WinWorkstation [error]: event throw away (memory problem)\n");
	    return;
	}
	console_fprintf(stderr, "WinWorkstation [warning]: wait for event memory (%d)\n", repeatCount);
	WaitForSingleObject( hNeverTriggered, 100L );
    }
    if (! lockEvents("enqEvent")) {
	console_fprintf(stderr, "WinWorkstation [error]: event throw away (lock problem)\n");
	return;
    }

    ev = eventFreeList;

    if (! ev) {
	console_fprintf(stderr, "WinWorkstation [error]: event throw away (memory problem)\n");
	unlockEvents();
	return;
    }
    eventFreeList  = ev->ev_next;
    ev->ev_flag    = flag;
    ev->ev_hWnd    = hWnd;
    ev->ev_message = message;
    ev->ev_wParam  = wParam;
    ev->ev_arg1    = arg1;
    ev->ev_arg2    = arg2;
    ev->ev_arg3    = arg3;
    ev->ev_arg4    = arg4;
    ev->ev_time    = evTime /* lastMSGTime */;
    ev->count      = eventsendcount++;
    ev->ev_next    = (struct queuedEvent *) 0;

    if (eventQueueTail) {
	eventQueueTail->ev_next = ev;
    } else {
	eventQueueHead = ev;
    }
    eventQueueTail = ev;

    unlockEvents();

    if (eventQueueHead == ev) {
	SetEvent(hInputEvent);
    }

#if 0
    SetThreadPriority(_masterThread, THREAD_PRIORITY_HIGHEST);
#endif
}

static int
deqEvent(struct queuedEvent *ret_ev, HWND hWnd, int mask)
{
    struct queuedEvent * ev = NULL;
    char * freeArg2 = NULL;

    if (mask != ~0) {
	PRINTF(("deqEvent mask:%x\n",mask));
    }
    if (hWnd) {
	PRINTF(("deqEvent hWnd:%x\n",hWnd));
    }

  again:

    if (! eventQueueHead)
	return (0);

    if (! lockEvents("deqEvent")) {
	return (0);
    }

    TH_DPRINTF(("TDEQ\n"));
    ev = eventQueueHead;

    if (! ev) {
	unlockEvents();
	return (0);
    }
    eventQueueHead = ev->ev_next;

    if (! eventQueueHead) {
	eventQueueTail = (struct queuedEvent *) 0;
    }

    if (ev->count != -1) {
	static int anyGoodEventReceived = 1;

	if (eventempfcount != ev->count) {
	    if (anyGoodEventReceived) {
		console_fprintf(stderr, "WinWorkstation [warning]: lost event (eventcount error %d <-> %d)\n",
				 eventempfcount, ev->count);
	    }
	    eventempfcount = ev->count;
	    anyGoodEventReceived = 0;
	} else {
	    anyGoodEventReceived = 1;
	}
	eventempfcount++;
    }

    if (ev->ev_message == WM_DESTROY) {
	/*
	 * arg2 is the localInfoPtr
	 * (which is already cleared in the wind-structure)
	 * it must be freed by the stx-process ('cause it was malloc'd by it)
	 */
	if (ev->ev_arg2) {
	    freeArg2 = (char *) ev->ev_arg2;
	    ev->ev_arg2 = 0;
	}

#ifdef TOPWINDOWCLASS

FALSCH: nochmals in QUEUE -> (ev_arg2 != 0) arg2 freed !!!

	if (ev->ev_arg1) {
	    if (UnregisterClass((char*)ev->ev_arg1,(HANDLE) __getHInstance())) {
		/*console_printf("UnregisterClass %s ok.\n",(char*)ev->ev_arg1);*/

	    } else {
		/* noch einmal in die queue
		*/
		if (ev->ev_arg2++ < 100) {
		    ev->ev_next = (struct queuedEvent *)0;
		    ev->count   = eventsendcount++;

		    if (eventQueueTail) {
			eventQueueTail->ev_next = ev;
		    } else {
			eventQueueHead = ev;
		    }
		    eventQueueTail = ev;
		    unlockEvents();

		    if (freeArg2) {
			free (freeArg2);
			freeArg2 = NULL;
		    }

		    if (ev->ev_arg2 > 98) {
			console_fprintf(stderr, "WinWorkstation [info]: UnregisterClass %s failed. Wait 1 sec.\n",(char*)ev->ev_arg1);
			sleep(1);
		    } else {
			sleep(0);
		    }
		    goto again;
		}
		/* fail evtl. spter ndern und in st verzgert aufrufen
		*/
		console_fprintf(stderr, "WinWorkstation [info]: UnregisterClass %s failed.\n",(char*)ev->ev_arg1);
	    }
	    free((char*)ev->ev_arg1);
	    ev->ev_arg1 = 0;
	}
#endif
    }

    *ret_ev = *ev;

    ev->ev_next   = eventFreeList;
    eventFreeList = ev;
    unlockEvents();

    if (freeArg2) {
	free (freeArg2);
    }
    return (1);
}

static void
__clearRectangles(HWND hWnd, int numRects, RECT *pRect)
{
	HDC dc;
	HBRUSH br;
	int bgClr;
	int isPrivateBrush = 0;

# ifdef CACHE_LAST_WM_PAINT_DC
	AQUIRE_PAINT_MUTEX;

	if (last_wm_paint_dc && (last_wm_paint_win == hWnd)) {
	    dc = last_wm_paint_dc;
	} else {
	    if (last_wm_paint_dc) {
#  ifdef CACHE_LAST_DC
		if (lastGcData && (lastGcData->_hDC == last_wm_paint_dc)) {
#   ifdef DEBUG_DC_REUSE
		    console_fprintf(stderr, "WinWorkstation [info]: Oops - release lastGcData [%d]\n", __LINE__);
#   endif
		    _releaseDC(lastGcData);
		} else {
		    ReleaseDC(last_wm_paint_win, last_wm_paint_dc);
		}
#  else
		ReleaseDC(last_wm_paint_win, last_wm_paint_dc);
#  endif /* CACHE_LAST_DC */
	    }
	    dc = GetDC(hWnd);
	    last_wm_paint_dc = dc;
	    last_wm_paint_win = hWnd;
	}
# else
	dc = (HDC)GetDC(hWnd);
# endif /* CACHE_LAST_WM_PAINT_DC */

# ifdef CACHE_LAST_DC
	if (lastGcData && (lastGcData->_hDC == dc)) {
#  ifdef DEBUG_DC_REUSE
	    console_fprintf(stderr, "WinWorkstation [info]: Oops wm_paint_dc reuse [%d]\n", __LINE__);
#  endif
	    if ((lastGcData->rop2 != R2_COPYPEN)
	     || (lastGcData->bitbltrop2 != BITBLT_COPY)) {
		console_fprintf(stderr, "WinWorkstation [info]: Oops wm_paint_dc not in Copy mode\n");
	    }
	    lastGcData = 0;
	}
# endif

	br = GetWindow_viewBgBrush(hWnd);
	if (! br) {
	    bgClr = GetWindow_viewBgColor(hWnd);

# ifdef CACHE_LAST_WM_PAINT_BRUSH
	    if (last_wm_paint_brush
	     && (last_wm_paint_brush_clr == bgClr)) {
		br = last_wm_paint_brush;
	    } else {
		if (bgClr == WhitePixel) {
		    br = __whiteBrush;
		} else if (bgClr == BlackPixel) {
		    br = __blackBrush;
		} else {
		    if (last_wm_paint_brush) {
			_DeleteBrush(last_wm_paint_brush, __LINE__);
		    }
		    last_wm_paint_brush = br = CreateSolidBrush(bgClr);
		    last_wm_paint_brush_clr = bgClr;
		    isPrivateBrush = 1;
		}
	    }
# else
	    br = CreateSolidBrush(bgClr);
	    isPrivateBrush = 1;
# endif
	}

	if (! br) {
	    console_fprintf(stderr, "WinWorkstation [info]: no brush\n");
	}

	if (br) {
	    int i;

	    SelectClipRgn(dc, NULL);

	    for (i=0; i<numRects; i++) {
		/*
		 * always clear - even if not interested in exposes
		 */
		FillRect(dc, &(pRect[i]), br);
	    }
	}

# ifndef CACHE_LAST_WM_PAINT_BRUSH
	if (isPrivateBrush) {
	    _DeleteBrush(br, __LINE__);
	}
# endif

# ifndef CACHE_LAST_WM_PAINT_DC
	ReleaseDC(hWnd, dc);
# endif

# if defined(CACHE_LAST_WM_PAINT_DC)
	RELEASE_PAINT_MUTEX
# endif
}

static void
__clearWindow(HWND hWnd, int x, int y, int w, int h)
{
	RECT rect;

	rect.left = x;
	rect.top = y;
	rect.right = x + w;
	rect.bottom = y + h;
	__clearRectangles(hWnd, 1, &rect);
}


/*
 * generate expose events from hWnd's update region or the passedIn region.
 * return the number of events (>0), if any was generated.
 * 0, if no event was generated, -1 if none was generated with error.
 * if a region is passed in, it is not destroyed.
 */

static int
__generateExposes(HWND hWnd, HRGN hRgnInOrNull, int msgType, int doClear)
{
	RECT updRect;
	HRGN updRgn = 0;
	int numRects, ret, n, i;
	int wantExpose;
	RECT *pRect;
	union {
	    RGNDATA rgnData;
	    char    bytes[512];
	} data;

	wantExpose = 0;

	if( msgType >= 0 )
	    wantExpose = (GetWindow_eventMask(hWnd) & ExposureMask);

	if (hRgnInOrNull) {
	    updRgn = hRgnInOrNull;
	} else {
	    PAINTSTRUCT ps;

	    /*
	     * fetch the update region, even if ExposureMask is empty.
	     */
	    updRgn = CreateRectRgn(0, 0, 0, 0);
	    ret = GetUpdateRgn(hWnd, updRgn, FALSE);

#if 0
	    BeginPaint(hWnd, &ps);
	    /* store the rectangle required for image bit reversal */
	    /* updateRect = ps.rcPaint;   */
	    EndPaint(hWnd, &ps);
#endif
	    switch (ret) {
		case ERROR:
		    console_fprintf(stderr, "WinWorkstation [info]: errregion\n");
		    return -1;
		case NULLREGION:
		    DDDDPRINTF(("nullregion\n"));
		    _DeleteObject(updRgn, __LINE__);
		    return 0;
		case SIMPLEREGION:
		case COMPLEXREGION:
		    break;
	    }
	}
	n = GetRegionData(updRgn, sizeof(data), &(data.rgnData));

	/*
	 * the MS-doc states: n==1
	 * but this is not true
	 */
	if ((n >= sizeof(RGNDATA))
	 && (n <= sizeof(data))
	 && (data.rgnData.rdh.iType == RDH_RECTANGLES))  {
	    /* ok, got the region */
	    numRects = data.rgnData.rdh.nCount;
	    pRect = (RECT *)(data.rgnData.Buffer);
	    DDDDPRINTF(("region numRects=%d\n", numRects));
	} else {
	    /* a big region ... */
	    GetRgnBox(updRgn, &updRect);
	    numRects = 1;
	    pRect = &updRect;
	    DPRINTF(("very complex region (need:%d have:%d) bounds=%d,%d -> %d,%d\n",
		     n, sizeof(data),
		     updRect.left, updRect.top,
		     updRect.right, updRect.bottom));
	    if (((updRect.right - updRect.left) <= 0)
	     || ((updRect.bottom - updRect.top) <= 0)) {
		numRects = 0;
	    }
	}

	if (numRects) {
	    if (doClear) {
		__clearRectangles(hWnd, numRects, pRect);
	    }

#ifndef PRE_21_NOV
	for (i=0; i < numRects; i++) {
	    ValidateRect( hWnd, &pRect[i] );
	}
#endif

#ifdef DEBUG_COLORIZE_WM_PAINT_RECTS1
	    {
		HDC hDC;
		HBRUSH hBrush;

		hBrush = CreateSolidBrush(BlackPixel);
		hDC = GetWindowDC(hWnd);
		SelectClipRgn(hDC, NULL);
		for (i=0; i<numRects; i++) {
		    FillRect(hDC, &(pRect[i]), hBrush);
		}
		_DeleteBrush(hBrush, __LINE__);
		ReleaseDC(hWnd, hDC);
	    }
#endif

	    if (wantExpose) {
		for (i=0; i<numRects; i++) {
		    int final = 0;

		    if ((msgType == __WM_GEXPOSE)
		     && (i == (numRects - 1))) {
			final = 1;
		    }
		    enqEvent(ExposureMask, hWnd, msgType, final,
			     (pRect[i].left), (pRect[i].top),
			     (pRect[i].right - pRect[i].left),
			     (pRect[i].bottom - pRect[i].top),
			     EV_NOTIME);
		}
	    }
	}

	if (updRgn && (updRgn != hRgnInOrNull)) {
	    _DeleteObject(updRgn, __LINE__);
	}

	return numRects;
}

#ifdef THIS_DOES_NOT_AVOID_DOUBLE_REPAINTS

BOOL CALLBACK
recursiveExposeGenerator(HWND hChild, LPARAM param)
{
	__generateExposes(hChild, NULL, param, 0);
	return TRUE;
}

static void
__generateRecursiveExposes(HWND hWnd, int msgType)
{
	EnumChildWindows(hWnd, recursiveExposeGenerator, msgType);
}

#endif /* sigh */


static int
getModifiers(void)
{
    int modifiers = 0;

    if (GetKeyState(VK_SHIFT) & 0x8000)
	modifiers |= ShiftMask;
    if (GetKeyState(VK_CONTROL) & 0x8000)
	modifiers |= ControlMask;
#if 0
    if (GetKeyState(VK_RMENU) & 0x8000)
	modifiers |= RightAltMask;
    if (GetKeyState(VK_LMENU) & 0x8000)
	modifiers |= LeftAltMask;
#else
    if (GetKeyState(VK_MENU) & 0x8000)
	modifiers |= LeftAltMask;
#endif
    if (GetKeyState(VK_LBUTTON) & 0x8000)
	modifiers |= Button1Mask;
    if (GetKeyState(VK_MBUTTON) & 0x8000)
	modifiers |= Button2Mask;
    if (GetKeyState(VK_RBUTTON) & 0x8000)
	modifiers |= Button3Mask;

    if ((modifiers & AnyButtonMask) == 0) {
	__eatingMouseEvents = 0;
    }
    return modifiers;
}

#ifndef PRE_01_APR_04

/* test whether a button is pressed but we think no button was pressed;
   in this case 0 (false) is returned otherwise true
*/

# define MustHandleButtonEvent()\
    (((__currentCapture == CAPTURE_NONE)       \
     && (   (GetKeyState(VK_LBUTTON) & 0x8000) \
	 || (GetKeyState(VK_MBUTTON) & 0x8000) \
	 || (GetKeyState(VK_RBUTTON) & 0x8000) \
	)                                      \
    ) ? 0 : 1)

#else
# define MustHandleButtonEvent()   1
#endif


#ifdef HANDLE_VIEWGRAVITY

struct gravityCallBackInfo {
    HWND parent;
    int  currW, currH;
    int  newW, newH;
    int  parentWinX, parentWinY;
};

static BOOL CALLBACK
gravityEnumeratorCallBack(HWND hChild, struct gravityCallBackInfo *iP)
{
    localWindowInfo *lI;
    int gravity;

    if (lI = GETLOCALWINDOWINFOPTR(hChild)) {
	if ((gravity = lI->viewGravity) != GRAVITY_NONE) {
	    RECT oldChildRct, oldChildWinRct;
	    RECT newChildRct;
	    int deltaW, deltaH;
	    int anyChange = 0;

	    /*
	     * get its current bounds ...
	     */
	    GetClientRect(hChild, &oldChildRct);
	    deltaW = iP->newW - iP->currW;
	    deltaH = iP->newH - iP->currH;

	    GetWindowRect(hChild, &oldChildWinRct);
	    oldChildRct.left = oldChildWinRct.left - iP->parentWinX;
	    oldChildRct.top =  oldChildWinRct.top - iP->parentWinY;

	    newChildRct = oldChildRct;
	    switch (gravity) {
#if 0
		case GRAVITY_N:
		    console_fprintf(stderr, "WinWorkstation [info]: Child %x: North gravity\n", hChild);
		    /*
		     * shift to the bottom, for a constant
		     * distance from the bottom edge;
		     */
		    newChildRct.bottom += deltaH;
		    anyChange = 1;
		    break;

		case GRAVITY_W:
		    console_fprintf(stderr, "WinWorkstation [info]: Child %x: West gravity\n", hChild);
		    /*
		     * shift to the right, for a constant
		     * distance from the right edge;
		     */
		    newChildRct.right += deltaW;
		    anyChange = 1;
		    break;
#endif
		case GRAVITY_S:
		    console_fprintf(stderr, "WinWorkstation [info]: Child %x: South gravity\n", hChild);
		    /*
		     * shift to the bottom, for a constant
		     * distance from the bottom edge;
		     */
		    newChildRct.top += deltaH;
		    newChildRct.bottom  += deltaH;
		    anyChange = 1;
		    break;

		case GRAVITY_E:
		    console_fprintf(stderr, "WinWorkstation [info]: Child %x: East gravity\n", hChild);
		    /*
		     * shift to the right, for a constant
		     * distance from the right edge;
		     */
		    newChildRct.right += deltaW;
		    newChildRct.left  += deltaW;
		    anyChange = 1;
		    break;

		case GRAVITY_SE:
		    console_fprintf(stderr, "WinWorkstation [info]: Child %x: SouthEast gravity\n", hChild);
		    /*
		     * shift to the bottom-right, for a constant
		     * distance from the bottom-right edge;
		     */
		    newChildRct.right += deltaW;
		    newChildRct.left  += deltaW;
		    newChildRct.top += deltaH;
		    newChildRct.bottom  += deltaH;
		    anyChange = 1;
		    break;

		default:
		    DPRINTF(("Child %x: other gravity\n", hChild));
		    break;
	    }

	    if (anyChange) {
		if ((newChildRct.left < 0)
		 || (newChildRct.top < 0)
		 || (newChildRct.right >= iP->newW)
		 || (newChildRct.bottom >= iP->newH)) {
		    console_fprintf(stderr, "WinWorkstation [info]: dont move child to: %d/%d -> %d/%d\n",
				    newChildRct.left, newChildRct.top,
				    newChildRct.right, newChildRct.bottom);
		} else {
		    console_fprintf(stderr, "WinWorkstation [info]: move child from %d/%d->%d/%d to: %d/%d->%d/%d\n",
				    oldChildRct.left, oldChildRct.top,
				    oldChildRct.right, oldChildRct.bottom,
				    newChildRct.left, newChildRct.top,
				    newChildRct.right, newChildRct.bottom);

		    SetWindowPos(hChild, (HWND)0,
				 newChildRct.left, newChildRct.top,
				 0, 0,
				 /* SWP_NOSENDCHANGING | */
				 SWP_NOACTIVATE | SWP_NOSIZE | SWP_NOZORDER | SWP_NOOWNERZORDER);
		}
	    }
	}
    }
    return TRUE;
}
#endif /* HANDLE_VIEWGRAVITY */

static void
ch2wch(char *in, wchar_t *out, int nMax)
{
    unsigned char *cp = (unsigned char *)in;
    wchar_t *wcp = out;

    while ((nMax > 1) && cp && *cp) {
	*wcp++ = *cp++;
	nMax--;
    }
    *wcp = 0;
}

static int
winEventProcessing(
	HWND hWnd,         /* window handle                   */
	UINT message,      /* type of message                 */
	UINT wParam,       /* additional information          */
	INT lParam,        /* additional information          */
	int *pDefault
    ) {
    int curButton;
    int x, y, w, h;
    int isNative = 0;
    UINT evTime;

    /* kludge - info is in msg-struct,
     * but lost here. (slightly inexact ... but who cares)
     */
    evTime = lastMSGTime;
    lastMSGTime = 0;
    if (evTime == 0) {
	lastMSGTime = GetTickCount();
    }

/*
    EVENT_PRINTF(("winEvent hWin=0x%x message=0x%x wP=0x%x lP=0x%x\n",
			hWnd, message, wParam, lParam));
*/

    if (hWnd) {
	if (message != WM_MOUSEMOVE) {
	    lastMotionWnd = 0;
	}

	isNative = (GetWindow_flag(hWnd) & LI_NATIVEWIN);
	if (isNative) {
	    NDPRINTF(("event %d (0x%x) for nativeWindow\n", message, message));
	}
    }

    /*
     * messages which are enqueued to be handled by the view thread
     */
    switch (message) {
	case WM_THREAD_CREATEWINDOW:
	    EVENT_PRINTF(("*WM_THREAD_CREATEWINDOW\n"));

	    {
		createWindowInfo *cwi = (createWindowInfo *)(lParam);

		if ((cwi->sequenceNr == wParam)
		 && (cwi->sequenceNr != INVALIDATED_CWI)) {
		    cwi->sequenceNr = INVALIDATED_CWI;
		    cwi->infoWasRead = 1;
		    if (cwi->newWinHandle == NULL) {
			HANDLE ev;
			HANDLE hwnd;

			cwi->newWinHandle = hwnd = CreateWindowExW(
					    cwi->winStyleBitsEx,
					    cwi->className,
					    cwi->windowName,
					    cwi->winStyleBits,
					    cwi->x, cwi->y,
					    cwi->dx, cwi->dy,
					    cwi->parentHandle,
					    NULL,           /* menu */
					    (HANDLE) __getHInstance(),
					    cwi->localWindowInfo
					   );

			if (hwnd == NULL) {
			    cwi->errCode = GetLastError();
			    console_fprintf(stderr, "WinWorkstation [info]: CreateWindow failed: %d (0x%x) [%d]\n",
						cwi->errCode, cwi->errCode, __LINE__);
			} else {
			    SETLOCALWINDOWINFOPTR(hwnd, cwi->localWindowInfo);
#ifdef DEBUG /* PARANOIA */
			    if (GETLOCALWINDOWINFOPTR(hwnd) != cwi->localWindowInfo) {
			       console_fprintf(stderr, "lI-Error\n");
			    }
#endif
			    SetWindowPos(hWnd, HWND_TOP, 0, 0, 0, 0,
					/* SWP_NOOWNERZORDER |*/
					SWP_NOSENDCHANGING | SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE);
			}

			ev = cwi->hCreateEvent;
			if (ev) {
			    SetEvent(ev);
			}
		    }
		} else {
		    DPRINTF(("obsolete createWindow message %x ignored\n", cwi->sequenceNr));
		}
	    }
	    *pDefault = 0;
	    return 0;

	case WM_THREAD_DESTROYWINDOW:
	    {
		HBRUSH br;

		br = GetWindow_viewBgBrush(hWnd);
		if (br) {
		    SetWindow_viewBgBrush(hWnd, 0);
		    _DeleteBrushIfNotInCache(br, __LINE__);
		}
	    }

#ifdef CACHE_LAST_DC
	    if (lastGcData && (lastGcHWIN == hWnd)) {
		_releaseDC(lastGcData);
	    }
#endif
#ifdef CACHE_LAST_WM_PAINT_DC
	    if (last_wm_paint_dc && (last_wm_paint_win == hWnd)) {
		ReleaseDC(hWnd, last_wm_paint_dc);
		last_wm_paint_win = last_wm_paint_dc = 0;
	    }
#endif
	    if (! DestroyWindow(hWnd)) {
		DPRINTF(("DestroyWindow ERROR\n"));
	    } else {
#ifdef COUNT_RESOURCES
		__cnt_createWindows--;
		RESPRINTF(("DestroyWindow -> %d\n", __cnt_createWindows));
#endif
	    }
	    *pDefault = 0;
	    return 0;

	case WM_CREATE:
	    {
#ifdef SETLOCALINFO_IN_CREATE /* no longer */
		localWindowInfo *lI;

		CREATESTRUCT *lpcs = (LPCREATESTRUCT) lParam; // structure with creation data

		lI = lpcs->lpCreateParams;
		EVENT_PRINTF(("WM_CREATE lI=%x\n", lI));

		SETLOCALWINDOWINFOPTR(hWnd, lI);
# ifdef SUPERDEBUG
		if (GETLOCALWINDOWINFOPTR(hWnd) != lpcs->lpCreateParams) {
		    PRINTF(("SETLOCALWINDOWINFOPTR ERROR\n"));
		}
# endif /* SUPERDEBUG */
#endif

		*pDefault = 0;
#ifdef COUNT_RESOURCES
		__cnt_createWindows++;
		RESPRINTF(("CreateWindows %d\n",__cnt_createWindows));
#endif
	    }
	    break;

	case WM_CLOSE:
	    EVENT_PRINTF(("WM_CLOSE\n"));
	    if (! destroyWin) {
		// (flag, hWnd, message, wParam, arg1, arg2, arg3, arg4, evTime)
		enqEvent(0, hWnd, WM_CLOSE, wParam, 0, 0, 0, 0, EV_NOTIME);
	    } else {
		destroyWin = 0;
		{
		    HBRUSH br;

		    br = GetWindow_viewBgBrush(hWnd);
		    if (br) {
			SetWindow_viewBgBrush(hWnd, 0);
			_DeleteBrushIfNotInCache(br, __LINE__);
		    }
		}
#ifdef CACHE_LAST_DC
		if (lastGcData && (lastGcHWIN == hWnd)) {
		    _releaseDC(lastGcData);
		}
#endif
#ifdef CACHE_LAST_WM_PAINT_DC
		if (last_wm_paint_dc && (last_wm_paint_win == hWnd)) {
		    ReleaseDC(hWnd, last_wm_paint_dc);
		    last_wm_paint_win = last_wm_paint_dc = 0;
		}
#endif
		if (! DestroyWindow(hWnd)) {
		    DPRINTF(("DestroyWindow ERROR\n"));
		} else {
#ifdef COUNT_RESOURCES
		    __cnt_createWindows--;
		    RESPRINTF(("DestroyWindow -> %d\n", __cnt_createWindows));
#endif
		}
	    }
	    *pDefault = 0;
	    return 0;
	    break;

	case WM_DESTROY:
	    {
		char *nm = 0;
		localWindowInfo *lI;

		lI = GETLOCALWINDOWINFOPTR(hWnd);
		EVENT_PRINTF(("WM_DESTROY %x li=%x\n", hWnd, lI));

#ifdef TOPWINDOWCLASS
		if (lI) {
		    if (lI->flag & LI_TOPWIN) {
			nm = (char*) malloc(300);
			GetClassName(hWnd, nm, 300);
		    }
		    /* freeing now done in other thread */
		}
#endif
		SETLOCALWINDOWINFOPTR(hWnd, 0);

#ifdef FREE_LI_IN_STX_PROCESS
		enqEvent(0, hWnd, WM_DESTROY, wParam, (INT)nm, lI, 0, 0, EV_NOTIME);
#else
		if (lI) {
		    free(lI);
		}
		enqEvent(0, hWnd, WM_DESTROY, wParam, (INT)nm, 0, 0, 0, EV_NOTIME);
#endif
		*pDefault = 0;
		return 0;
	    }
	    break;

	case WM_GETMINMAXINFO:

#ifndef PRE_13_APR_04_POSCHANGED_IN_EXITSIZEMOVE
	    if (inMove) {
		*pDefault = 0;
		return 0;
	    }
#endif

	    {
		int minW, maxW;
		localWindowInfo *lI;
		LPMINMAXINFO lpmmi = (LPMINMAXINFO) lParam;

		EVENT_PRINTF2(("WM_GETMINMAXINFO handle=%x got min: %d/%d\n",
			    hWnd,
			    lpmmi->ptMinTrackSize.x,
			    lpmmi->ptMinTrackSize.y));

		lI = GETLOCALWINDOWINFOPTR(hWnd);
		if (lI && (lI->minWidth) && (lI->maxWidth)) {
		  lpmmi->ptMaxPosition.x = 0;
		  lpmmi->ptMaxPosition.y = 0;
		  lpmmi->ptMaxSize.x = lI->currentMonitorWidth;
		  lpmmi->ptMaxSize.y = lI->currentMonitorHeight;
/* Added Extra parentheses to avoid operator precedence problem */
#define MIN(a,b) (((a)<(b))?(a):(b))
		  lpmmi->ptMaxSize.x = MIN(GetSystemMetrics(SM_CXMAXIMIZED), lI->maxWidth);
		  lpmmi->ptMaxSize.y = MIN(GetSystemMetrics(SM_CYMAXIMIZED), lI->maxHeight);

		  lpmmi->ptMaxTrackSize.x = lI->maxWidth == 0 ? GetSystemMetrics(SM_CXMAXTRACK) : lI->maxWidth;
		  lpmmi->ptMaxTrackSize.y = lI->maxHeight == 0 ? GetSystemMetrics(SM_CYMAXTRACK) : lI->maxHeight;
		  lpmmi->ptMinTrackSize.x = lI->minWidth;
		  lpmmi->ptMinTrackSize.y = lI->minHeight;

		  EVENT_PRINTF3(("WM_GETMINMAXINFO handle=%x return min: %d/%d max: %d/%d\n",
				  hWnd,
				  lI->minWidth, lI->minHeight,
				  lI->maxWidth, lI->maxHeight));
		  *pDefault = 0;
		}
	    }
	    break;

	case WM_SETCURSOR:
	    {
		HCURSOR curs;
		int hitCode;

		hitCode = LOWORD(lParam);
		if (hitCode != HTCLIENT) {
		    /*
		     * not in client area ...
		     */
		    return 0;
		}
		DPRINTFIF(__debug_WM_SETCURSOR__ , ("WM_SETCURSOR\n"));
		curs = GetWindow_Cursor(hWnd);
		if (curs) {
		    SetCursor(curs);
		    *pDefault = 0;
		    return 1;
		}
	    }
	    return 0;

	case WM_WINDOWPOSCHANGED:

#ifndef PRE_13_APR_04_POSCHANGED_IN_EXITSIZEMOVE
	    if (inMove) {
		*pDefault = 0;
		return 0;
	    }
#endif
	    if (hWnd == __rootWinSpezial) {
		/* can this happen ? */
		*pDefault = 1;
		return 0;
	    }

	    if (! inMove && (__currentCapture == CAPTURE_NONE)) {
		POINT p;
		HWND hWndChild,hWndTemp;

		p.x = evRootX;
		p.y = evRootY;
		ScreenToClient(hWnd, &p);
		hWndChild = hWnd; //hWndChild = ChildWindowFromPoint(hWnd,p);
		do {
		    hWndTemp = hWndChild;
		    hWndChild = ChildWindowFromPointEx(hWndTemp,p,CWP_SKIPINVISIBLE|CWP_SKIPDISABLED|CWP_SKIPTRANSPARENT);
		} while ((hWndChild) && (hWndChild != hWndTemp));

		if (hWndChild /*&& (hWndChild != hWnd)*/) {
		    if (hWndChild != __currentPointerView) {
			int modifiers = getModifiers();

			if (__currentPointerView) {
			    if (inSizeMove) {
				if (needDelayedMouseLeaveWindow == NULL) {
				    needDelayedMouseLeaveWindow = __currentPointerView;
				}
			    } else {
				if (GetWindow_eventMask(__currentPointerView) & LeaveWindowMask) {
				    enqEvent(LeaveWindowMask, __currentPointerView, __WM_MOUSELEAVE, 0, -1, -1, 0, modifiers, EV_NOTIME);
				    SetWindow_mouseXY(__currentPointerView, -9999, -9999);
				}
			    }
			    __currentPointerView = 0;
			}
			if (inSizeMove) {
			    needDelayedMouseEnterWindow = hWndChild;
			    delayedMouseEnterX = evRootX;
			    delayedMouseEnterY = evRootY;
			} else {
			    if (GetWindow_eventMask(hWndChild) & EnterWindowMask) {
				enqEvent(EnterWindowMask, hWndChild, __WM_MOUSEENTER, 0, evRootX, evRootY, 0, modifiers, EV_NOTIME);
				SetWindow_mouseXY(hWndChild, evRootX, evRootY);
			    }
			    // SetFocus(hWndChild);
			}
			__currentPointerView = hWndChild;
		    }
		}
	    }

	    /*
	     * ignore child window messages ...
	     */
	    if (GetParent(hWnd) != NULL) {
		break;
	    }

	    {
		WINDOWPOS *wp = (WINDOWPOS *)lParam;
		RECT rct, dRect;
		int x, y, w, h;
		int dW, dH;

#if 0
		dRect.left = 0;
		dRect.top = 0;
		dRect.right = 100;
		dRect.bottom = 100;
		winStyleBits = GetWindowLong(hWnd, GWL_STYLE);
		winExStyleBits = GetWindowLong(hWnd, GWL_EXSTYLE);
		AdjustWindowRectEx(&dRect, winStyleBits, 0, winExStyleBits);
		dW = dRect.right - dRect.left;
		dH = dRect.bottom - dRect.top;
#endif
		GetClientRect(hWnd, &rct);

		x = rct.left;
		y = rct.top;
		w = rct.right - rct.left;
		h = rct.bottom - rct.top;

		if (__debug__) {
		    EVENT_PRINTF(("WM_WINDOWPOSCHANGED ["));

		    if (wp->flags & SWP_NOSIZE) {
			EVENT_PRINTF(("NOSIZE "));
		    }
		    if (wp->flags & SWP_NOMOVE) {
			EVENT_PRINTF(("NOMOVE "));
		    }
		    if (wp->flags & SWP_NOZORDER) {
			EVENT_PRINTF(("NOZORDER "));
		    }
		    if (wp->flags & SWP_NOREDRAW) {
			EVENT_PRINTF(("NOREDRAW "));
		    }
		    if (wp->flags & SWP_NOACTIVATE) {
			EVENT_PRINTF(("NOACTIVATE "));
		    }
		    if (wp->flags & SWP_FRAMECHANGED) {
			EVENT_PRINTF(("FRAMECHANGED "));
		    }
		    if (wp->flags & SWP_NOCOPYBITS) {
			EVENT_PRINTF(("NOCOPYBITS "));
		    }
		    if (wp->flags & SWP_NOOWNERZORDER) {
			EVENT_PRINTF(("NOOWNERZORDER "));
		    }
		    if (wp->flags & SWP_NOSENDCHANGING) {
			EVENT_PRINTF(("NOSENDCHANGING "));
		    }
		    if (wp->flags & SWP_DEFERERASE) {
			EVENT_PRINTF(("DEFERERASE "));
		    }
		    if (wp->flags & SWP_ASYNCWINDOWPOS) {
			EVENT_PRINTF(("ASYNCWINDOWPOS "));
		    }
		    if (wp->flags & SWP_HIDEWINDOW) {
			EVENT_PRINTF(("HIDEWINDOW "));
		    }
		    if (wp->flags & SWP_SHOWWINDOW) {
			EVENT_PRINTF(("SHOWWINDOW "));
		    }

		    EVENT_PRINTF(("] %d/%d %d/%d flags:%d (0x%x) ->",
				wp->x, wp->y, wp->cx, wp->cy, wp->flags, wp->flags));
		    EVENT_PRINTF(("  client rect now: %d/%d %d/%d\n",x, y, w, h));

		} /* __debug__ */
#ifdef THIS_IS_WRONG
		if (!(wp->flags & SWP_NOSIZE)) {
		    EVENT_PRINTF(("w,h: %d/%d vs. %d/%d\n", wp->cx, wp->cy, w, h));
		    w = wp->cx;
		    h = wp->cy;
		}
		if (!(wp->flags & SWP_NOMOVE)) {
		    EVENT_PRINTF(("x,y: %d/%d vs. %d/%d\n", wp->x, wp->y, x, y));
		    x = wp->x;
		    y = wp->y;
		}
#endif
		lastPos_win = 0;

		if ((w == 0) && (h == 0)) {
		    EVENT_PRINTF(("w,h = 0.\n"));
		    if (! GetWindow_iconified(hWnd)) {
			EVENT_PRINTF(("iconified.\n"));
			SetWindow_iconified(hWnd, 1);
			DPRINTF(("WM_WINDOWPOSCHANGED to iconified (flags:0x%x)\n", wp->flags));
			enqEvent(0, hWnd, __WM_ICONIFIED, 1, 0, 0, 0, 0, EV_NOTIME);
		    }
		} else {
		    if (GetWindow_iconified(hWnd)) {
			EVENT_PRINTF(("deiconified.\n"));
			SetWindow_iconified(hWnd, 0);
			DPRINTF(("WM_WINDOWPOSCHANGED to deiconified (flags:0x%x)\n", wp->flags));
			enqEvent(0, hWnd, __WM_ICONIFIED, 0, 0, 0, 0, 0, EV_NOTIME);
		    }
		    if (!(wp->flags & SWP_NOSIZE)
		     || !(wp->flags & SWP_NOMOVE)) {
			EVENT_PRINTF(("enq event %x: %d, %d, %d, %d\n", hWnd, x, y, w, h));
#ifdef COMPRESS_WINDOWPOSCHANGED
			/*
			 * remember the current
			 * window and size;
			 * This allows the backend to ignore
			 * intermediate events.
			 */
			lastPos_w = w;
			lastPos_h = h;
			lastPos_x = x;
			lastPos_y = y;
			lastPos_win = hWnd;
#endif
			enqEvent(0, hWnd, WM_WINDOWPOSCHANGED, 0, x, y, w, h, EV_NOTIME);
		    } else {
			EVENT_PRINTF(("no event due to SWP_NOSIZE/SWP_NOMOVE.\n"));
		    }
		}
	    }
	    *pDefault = 0;
	    return 0;

	case WM_ERASEBKGND:
	    DPRINTFIF(__debug_WM_ERASEBKGND__ , ("WM_ERASEBKGND\n"));
	    if (isNative) {
		NDPRINTF(("WM_ERASEBKGND for native - default handling\n"));
		return 0;
	    }

#ifndef PRE_21_NOV
	    *pDefault = 0;
	    return 0;
#else

	    if (GetWindow_flag(hWnd) & LI_INPUTWIN) {
		*pDefault = 0;
		return 0;
	    }
	    if (hWnd == __rootWinSpezial) {
		*pDefault = 0;
		return 0;
	    }

	    /* THIS_WORKS */
	    *pDefault = 0;
	    return 0;

#endif  /* ! PRE_21_NOV */

	case WM_PAINT:
	    DPRINTFIF(__debug_WM_PAINT__ , ("WM_PAINT ********************* "));

	    if (isNative) {
		NDPRINTF(("WM_PAINT for native - default handling\n"));
		return 0;
	    }

#ifndef PRE_21_NOV
	    {   int n;

		n = __generateExposes( hWnd, NULL, WM_PAINT, 0 );

		if( n <= 0 ) {
		    * pDefault = 1;
		    return 0;
		}
		* pDefault = 0;
		return n;
	    }
#else



	    if (GetWindow_flag(hWnd) & LI_INPUTWIN) {
		*pDefault = 0;
		return 0;
	    }

	    if (hWnd == __rootWinSpezial) {
# ifdef THIS_MAKES_GUI_PAINTER_START_SLOW
		*pDefault = 0;
# endif
		return 0;
	    }

	    {
		int retVal;

# ifdef LATE_GENERATE_EXPOSE
		enqEvent(0, hWnd, __WM_PAINT, 0, 0, 0, 0, 0, EV_NOTIME);
# else
		AQUIRE_DRAW_MUTEX
		retVal = __generateExposes(hWnd, NULL, WM_PAINT, WM_PAINT_CLEAR_EARLY);
		RELEASE_DRAW_MUTEX
# endif
		switch (retVal) {
		    case -1:  /* error */
			*pDefault = 0;
			break;
		    case 0:   /* nothing generated */
		    default:  /* generated events */
			break;
		}
# ifdef THIS_IS_BAD
		*pDefault = 0;
		return 1;
# endif
	    }
	    return 0;

#endif  /* ! PRE_21_NOV */

	case WM_SIZE:
	    DPRINTFIF(__debug_WM_SIZE__ , ("WM_SIZE\n"));

	    lastPos_win = 0;
	    /*
	     * ignore child window messages ...
	     */
	    if (GetParent(hWnd) != NULL) {
		*pDefault = 0;
		return 0;
	    }

	    switch (wParam) {
		case SIZE_MAXIMIZED:     /* default handling */
		case SIZE_MINIMIZED:     /* default handling */
		case SIZE_RESTORED:      /* default handling */
		    {
			RECT rct;
			int x, y, w, h;

			GetClientRect(hWnd, &rct);

			x = rct.left;
			y = rct.top;
			w = rct.right - rct.left;
			h = rct.bottom - rct.top;

			EVENT_PRINTF(("WM_MIN/MAX/RESTORED\n"));

			if ((w == 0) && (h == 0)) {
			    /*
			     * iconified ...
			     */
			    if (! GetWindow_iconified(hWnd)) {
				SetWindow_iconified(hWnd, 1);
				enqEvent(0, hWnd, __WM_ICONIFIED, 1, 0, 0, 0, 0, EV_NOTIME);
			    }
			} else {
			    if (GetWindow_iconified(hWnd)) {
				SetWindow_iconified(hWnd, 0);
				enqEvent(0, hWnd, __WM_ICONIFIED, 0, 0, 0, 0, 0, EV_NOTIME);
			    }
			    EVENT_PRINTF(("enq event2 %x: %d, %d, %d, %d\n", hWnd, x, y, w, h));
#ifdef COMPRESS_WINDOWPOSCHANGED
			    /*
			     * remember the current
			     * window and size;
			     * This allows the backend to ignore
			     * intermediate events.
			     */
			    lastPos_w = w;
			    lastPos_h = h;
			    lastPos_x = x;
			    lastPos_y = y;
			    lastPos_win = hWnd;
#endif
			    enqEvent(0, hWnd, WM_WINDOWPOSCHANGED, 0, x, y, w, h, EV_NOTIME);
			}
		   }
		   break;

		default:                 /* ignore */
		    *pDefault = 0;
		    return 0;
	    }
	    break;

	case WM_DROPFILES:
	    DPRINTFIF(__debug_WM_DROPFILES__ , ("WM_DROPFILES\n"));
	    enqEvent(0, hWnd, message, wParam, 0, 0, 0, 0, EV_NOTIME);
	    break;

	case WM_SHOWWINDOW:
	    DPRINTFIF(__debug_WM_SHOWWINDOW__ , ("WM_SHOWWINDOW h=%x\n", hWnd));
	    enqEvent(0, hWnd, message, wParam, 0, 0, 0, 0, EV_NOTIME);
	    if (isNative) {
		NDPRINTF(("WM_SHOWWINDOW for native - default handling\n"));
		return 0;
	    }
	    *pDefault = 0;
	    break;

	case WM_MOUSEACTIVATE :
	    DPRINTFIF(__debug_WM_MOUSEACTIVATE__ , ("WM_MOUSEACTIVATE h=%x parent=%x\n", hWnd, GetParent(hWnd)));

	    /*
	     * ignore child window messages ...
	     */
	    if (GetParent(hWnd)) {
		return 0;
	    }

	    *pDefault = 0;
	    if ((hWnd == __rootWinSpezial) || (hWnd == GetActiveWindow())) {
		DDPRINTF(("NOACTIVATE (root or already)\n"));
		return MA_NOACTIVATE;
	    }
	    if (LOWORD(lParam) != HTCLIENT) {
		DDPRINTF(("ACTIVATE (not client)\n"));
		return MA_ACTIVATE;
	    }
	    if (__activateOnClick) {
		if (__ignoreButtonPressOnActivate) {
		    DDPRINTF(("ACTIVATE_EAT\n"));
		    /*
		     * windows is sooo stupid:
		     * it will send me a MOTION soon after, with the
		     * to the click location, with the buttonState down.
		     * The app will interpret that as a pressed motion and
		     * do a selection (if in a textview).
		     * To prevent this, we set a flag here, that the following
		     * motion is to be suppressed.
		     * Until the mouse is released.
		     */
		    __eatingMouseEvents = 1;
		    return MA_ACTIVATEANDEAT;
		}
		DDPRINTF(("ACTIVATE\n"));
		return MA_ACTIVATE;
	    }
	    DDPRINTF(("NO_ACTIVATE\n"));
	    return MA_NOACTIVATE;

	case WM_NCHITTEST:
	    EVENT_PRINTF2(("WM_NCHITTEST\n"));
	    if (hWnd == __rootWinSpezial) {
		*pDefault = 0;
		return HTCLIENT;
	    }
	    break;

	case WM_NCACTIVATE:
	    EVENT_PRINTF(("WM_NCACTIVATE\n"));
	    break;

	case WM_ACTIVATE:
	    CPRINTF(("WM_ACTIVATE %s h=%x\n", LOWORD(wParam) ? "active" : "inactive", hWnd));

	    switch (LOWORD(wParam)) {
		case WA_INACTIVE:
		    EVENT_PRINTF2(("WM_ACTIVATE inactive h=%x\n", hWnd));
		    break;

		case WA_ACTIVE:
		    EVENT_PRINTF2(("WM_ACTIVATE active h=%x\n", hWnd));

#ifdef THIS_DOES_NOT_AVOID_DOUBLE_REPAINTS
		    __generateRecursiveExposes(hWnd, WM_PAINT);
#endif /* sigh */
		    break;

		case WA_CLICKACTIVE:
		    EVENT_PRINTF2(("++ WM_ACTIVATE clkactive h=%x\n", hWnd));
		    break;

		default:
		    EVENT_PRINTF2(("WM_ACTIVATE ? h=%x\n", hWnd));
		    break;
	    }

#ifndef PRE_25_NOV_03
	    if (__currentCapture == CAPTURE_NONE) {
		HWND  newHWnd = 0;
		POINT newPoint;

		if (LOWORD(wParam) != WA_INACTIVE) {
		    if (MustHandleButtonEvent()) {
			newPoint.x = evRootX;
			newPoint.y = evRootY;

			newHWnd = WindowFromPoint (newPoint);

			if (newHWnd) {
			    if ( (newHWnd == hWnd) || IsChild(hWnd, newHWnd) ) {
				ScreenToClient (newHWnd, & newPoint);

				if ((newPoint.x < 0) || (newPoint.y < 0)) {
				    newHWnd = 0;
				}
			    } else {
				newHWnd = 0;
			    }
			}
		    }
		}
		CPRINTF(( "Old Handle: %x New Handle: %x  x:%d y:%d\n", __currentPointerView, newHWnd, newPoint.x, newPoint.y));

		if (newHWnd != __currentPointerView) {
		    int modifiers = getModifiers();

		    if (__currentPointerView) {
			if (GetWindow_eventMask(__currentPointerView) & LeaveWindowMask) {
			    enqEvent(LeaveWindowMask, __currentPointerView, __WM_MOUSELEAVE, 0, -1, -1, 0, modifiers, EV_NOTIME);
			    SetWindow_mouseXY(__currentPointerView, -9999, -9999);
			}
		    }
		    __currentPointerView = newHWnd;

		    if (GetWindow_eventMask(__currentPointerView) & LeaveWindowMask) {
			enqEvent(EnterWindowMask, __currentPointerView, __WM_MOUSEENTER, 0, newPoint.x, newPoint.y, 0, modifiers, EV_NOTIME);
			SetWindow_mouseXY(__currentPointerView, newPoint.x, newPoint.y);
		    }
		}
	    }
#endif
	    enqEvent(0, hWnd, WM_ACTIVATE, wParam, 0, 0, 0, 0, EV_NOTIME);

	    if (isNative) {
		return 0;
	    }
	    break;

	case WM_HOTKEY:
	    // console_fprintf(stderr, "winEventProcessing [info]: receive hotkey %x\n",wParam);
	    DPRINTFIF(__debug_WM_KEYUP__ , ("WM_HOTKEY %x\n", wParam));
	    {
		enqEvent(0, hWnd, WM_HOTKEY, wParam, lParam, 0, 0, 0, evTime);
	    }
	    break;

	case WM_SYSCHAR:
	    EVENT_PRINTF2(("WM_SYSCHAR h=%x %x\n", hWnd, wParam));
	    goto commonChar;

#ifdef WM_UNICHAR
	/* does not work, anyway */
	case WM_UNICHAR:
	    DPRINTFIF(__debug_WM_CHAR__ , ("WM_UNICHAR h=%x %x\n", hWnd, wParam));
	    if (wParam == UNICODE_NOCHAR) {
		/* this is a query from windows to see if I am able to receive unicode... */
		*pDefault = 0;
		return 1;
	    }
	    goto commonChar;
#endif

	case WM_CHAR:
	    DPRINTFIF(__debug_WM_CHAR__ , ("WM_CHAR h=%x %x\n", hWnd, wParam));
#if 0
	    EVENT_PRINTF2(("WM_CHAR h=%x %x\n", hWnd, wParam));
#endif
	commonChar:
	    if (isNative) {
		NDPRINTF(("WM_CHAR for native - default handling\n"));
		return 0;
	    }

	    {
		HWND destWindow;
		int evMask;

		if (__focusFollowsMouse) {
		    destWindow = __currentPointerView;
		    if (destWindow == 0) {
			destWindow = hWnd;
		    }
		} else {
		    destWindow = hWnd;
		}

		evMask = GetWindow_eventMask(destWindow);
		if (evMask & (KeyPressMask | KeyReleaseMask)) {
		    POINT p;
		    int modifiers = getModifiers();

		    p.x = evRootX;
		    p.y = evRootY;
		    ScreenToClient(destWindow, &p);
		    x = p.x;
		    y = p.y;

		    DPRINTFIF(__debug_WM_CHAR__ , ("key:%x modifiers: %x\n", wParam, modifiers));
		    if (evMask & KeyPressMask)
			enqEvent(KeyPressMask, destWindow, WM_KEYDOWN, wParam, x, y, lParam, (modifiers | TRANSLATED_KEY), evTime);
		    if (evMask & KeyReleaseMask)
			enqEvent(KeyReleaseMask, destWindow, WM_KEYUP, wParam, x, y, lParam, (modifiers | TRANSLATED_KEY), evTime);
		}
	    }
	    *pDefault = 0;
	    return 0;


	case WM_KEYUP:
	    DPRINTFIF(__debug_WM_KEYUP__ , ("WM_KEYUP h=%x %x\n", hWnd, wParam));
	    goto commonKeyUp;

	case WM_SYSKEYUP:
	    DPRINTFIF(__debug_WM_KEYUP__ , ("WM_SYSKEYUP %x\n, wParam"));
	commonKeyUp:
	    if (isNative) {
		NDPRINTF(("WM_KEYUP/WM_SYSKEYUP for native - default handling\n"));
		return 0;
	    }
	    {
		HWND destWindow;

		if (__focusFollowsMouse) {
		    destWindow = __currentPointerView;
		    if (destWindow == 0) {
			destWindow = hWnd;
		    }
		} else {
		    destWindow = hWnd;
		}

		if (GetWindow_eventMask(destWindow) & KeyReleaseMask) {
		    POINT p;

		    p.x = evRootX;
		    p.y = evRootY;
		    ScreenToClient(destWindow, &p);
		    x = p.x;
		    y = p.y;

		    enqEvent(KeyReleaseMask, destWindow, message, wParam, x, y, lParam, getModifiers(), evTime);
		}
	    }
	    *pDefault = 0;
	    return 0;

	case WM_SYSKEYDOWN:
	    DPRINTFIF(__debug_WM_KEYDOWN__ , ("WM_SYSKEYDOWN %x\n, wParam"));
	    goto commonKey;

	case WM_KEYDOWN:
	    DPRINTFIF(__debug_WM_KEYDOWN__ , ("WM_KEYDOWN h=%x %x\n", hWnd, wParam));
	commonKey:
	    if (isNative) {
		NDPRINTF(("WM_KEYDOWN/WM_SYSKEYDOWN for native - default handling\n"));
		return 0;
	    }

#ifdef EXIT_WITH_3_CTRL_Cs
	    if ((msg.wParam == 'c')
	     && (GetKeyState(VK_CONTROL) & 0x8000)) {
		/* CTRL-C */
		if (ctrl_c_count++ > 3)  /* for debugging */
		    exit(1);
	    } else {
		if (msg.wParam != VK_CONTROL)
		    ctrl_c_count = 0;
	    }
#endif
#ifdef RELEASE_CAPTURE_WITH_3_ESCAPEs
	    if (msg.wParam == VK_ESCAPE)) {
		/* ESCAPE */
		if (escape_count++ > 3) {
		    __currentCapture = CAPTURE_NONE;
		    ReleaseCapture();
		    CPRINTF(("ReleaseCapture <ESC>\n"));
		}
	    } else {
		escape_count = 0;
	    }
#endif
	    /* FALL INTO */

	    {
		HWND destWindow;

		if (__focusFollowsMouse) {
		    destWindow = __currentPointerView;
		    if (destWindow == 0) {
			destWindow = hWnd;
		    }
		} else {
		    destWindow = hWnd;
		}

		if (GetWindow_eventMask(destWindow) & KeyPressMask) {
		    POINT p;

		    p.x = evRootX;
		    p.y = evRootY;
		    ScreenToClient(destWindow, &p);
		    x = p.x;
		    y = p.y;

		    enqEvent(KeyPressMask, destWindow, message, wParam, x, y, lParam, getModifiers(), evTime);
		}
	    }
	    *pDefault = 0;
	    return 0;

#ifdef WM_MOUSEWHEEL
	case WM_MOUSEWHEEL:
	    {
		HWND destWindow;

		if (__focusFollowsMouse) {
		    destWindow = __currentPointerView;
		    if (destWindow == 0) {
			destWindow = hWnd;
		    }
		} else {
		    destWindow = hWnd;
		}


		EVENT_PRINTF(("WM_MOUSEWHEEL h=%x wP=%x lP=%x\n", hWnd, wParam, lParam));
		if (GetWindow_eventMask(destWindow) & KeyPressMask) {
		    POINT p;
		    int delta;

		    p.x = evRootX;
		    p.y = evRootY;
		    ScreenToClient(destWindow, &p);
		    x = p.x;
		    y = p.y;
		    delta = evTime - lastMouseWheelTime;
		    if (evTime < lastMouseWheelTime) {
			delta = (0xFFFFFFFF - lastMouseWheelTime) + evTime;
		    }
		    enqEvent(0, destWindow, message, wParam, x, y, lParam, getModifiers(), delta);
		}
		lastMouseWheelTime = evTime;
	    }
	    *pDefault = 0;
	    return 0;
#endif

	case WM_MOUSEMOVE:
	    DPRINTFIF(__debug_WM_MOUSEMOVE__ , ("WM_MOUSEMOVE h=%x\n", hWnd));
	    if (isNative) {
		NDPRINTF(("WM_MOUSEMOVE for native - default handling\n"));
		return 0;
	    }

	    if (hWnd != __currentPointerView) {
		if (! MustHandleButtonEvent()) {
		    *pDefault = 0;
		    return 0;
		}
	    }

	    {
		short x, y;
		int modifiers = getModifiers();

		x = (int)(short)LOWORD(lParam);
		y = (int)(short)HIWORD(lParam);

		if (__currentCapture == CAPTURE_NONE) {
		    if (hWnd != __currentPointerView) {
			HWND prevPointerView;

			prevPointerView = __currentPointerView;
			if (prevPointerView) {
			    if (inSizeMove) {
				if (needDelayedMouseLeaveWindow == NULL) {
				    needDelayedMouseLeaveWindow = __currentPointerView;
				}
			    } else {
				if (GetWindow_eventMask(__currentPointerView) & LeaveWindowMask) {
				    enqEvent(LeaveWindowMask, __currentPointerView, __WM_MOUSELEAVE, 0, -1, -1, 0, modifiers, evTime);
				    SetWindow_mouseXY(__currentPointerView, -9999, -9999);
				}
			    }
			    __currentPointerView = 0;
			}

#if 0
			if (__activateOnClick) {
			    /*
			     * only send mouseEnter if the window belongs to the current
			     * active window
			     */
			    if (GetTopParent(prevPointerView) == GetTopParent(hWnd)) {
			    }
			}
#endif
			if (inSizeMove) {
			    needDelayedMouseEnterWindow = hWnd;
			    delayedMouseEnterX = x;
			    delayedMouseEnterY = y;
			} else {
			    if (GetWindow_eventMask(hWnd) & EnterWindowMask) {
				enqEvent(EnterWindowMask, hWnd, __WM_MOUSEENTER, 0, x, y, 0, modifiers, evTime);
				SetWindow_mouseXY(hWnd, x, y);
			    }
			}
			__currentPointerView = hWnd;
		    }
		    DPRINTFIF(__debug_WM_MOUSEMOVE__ , ("MouseMove %x\n", __currentPointerView));
		} else {
		    CPRINTF(("MouseMove Capture %x\n", __currentPointerView));
		}

		if ((GetWindow_eventMask(__currentPointerView) & PointerMotionMask)
		 || (modifiers & AnyButtonMask)) {
		    if (! __eatingMouseEvents) {
			if ((x == lastMotionX)
			 && (y == lastMotionY)
			 && (__currentPointerView == lastMotionWnd)) {
			    /* ignore */
			} else {
			    lastMotionX = x;
			    lastMotionY = y;
			    lastMotionWnd = __currentPointerView;

			    if ((GetWindow_mouseX(__currentPointerView) == x)
			     && (GetWindow_mouseY(__currentPointerView) == y)) {
			    } else {
				enqEvent(PointerMotionMask, __currentPointerView, WM_MOUSEMOVE, wParam, x, y, 0, modifiers, evTime);
				SetWindow_mouseXY(__currentPointerView, x, y);
			    }
			}
		    }
		}
	    }
	    *pDefault = 0;
	    return 0;

	case WM_LBUTTONUP:
	    DPRINTFIF(__debug_WM_BUTTONUP__ , ("WM_LBUTTONUP h=%x\n", hWnd));
	    curButton = Button1;
	    goto commonButtonUp;
	case WM_MBUTTONUP:
	    DPRINTFIF(__debug_WM_BUTTONUP__ , ("WM_MBUTTONUP h=%x\n", hWnd));
	    curButton = Button2;
	    goto commonButtonUp;
	case WM_RBUTTONUP:
	    DPRINTFIF(__debug_WM_BUTTONUP__ , ("WM_RBUTTONUP h=%x\n", hWnd));
	    curButton = Button3;
commonButtonUp:
	    if (isNative) {
		NDPRINTF(("WM_*BUTTONUP for native - default handling\n"));
		return 0;
	    }

#ifndef PRE_01_APR_04
	    if ((__currentPointerView != hWnd) && (__currentPointerView == (HANDLE)0)) {
		__currentPointerView = hWnd;

		if (GetWindow_eventMask(hWnd) & EnterWindowMask) {
		    POINT p;

		    p.x = evRootX;
		    p.y = evRootY;

		    ScreenToClient (hWnd, & p);

		    if ((p.x >= 0) && (p.y >= 0)) {
			enqEvent(EnterWindowMask, hWnd, __WM_MOUSEENTER, 0, p.x, p.y, 0, getModifiers(), EV_NOTIME);
			SetWindow_mouseXY(hWnd, p.x, p.y);
		    } else {
			__currentPointerView = (HANDLE) 0;
		    }
		}
	    }
#endif

	    if (__currentCapture == curButton /* CAPTURE_IMPLICIT*/) {
		__currentCapture = CAPTURE_NONE;
		ReleaseCapture();
		CPRINTF(("ReleaseCapture <BUTTONUP>\n"));
	    }
	    EVENT_PRINTF3(("WM_BUTTONUP h=%x pos=%d/%d\n",
			   hWnd, (int)(short)LOWORD(lParam), (int)(short)HIWORD(lParam)));


	    if (GetWindow_eventMask(hWnd) & ButtonReleaseMask) {
		if (__eatingMouseEvents) {
		    __eatingMouseEvents = 0;
		} else {
		    enqEvent(ButtonReleaseMask, hWnd,
			     message, wParam, (UINT)(short)LOWORD(lParam), (INT)(short)HIWORD(lParam),
			     wParam, getModifiers(), evTime);
		}
	    }
	    *pDefault = 0;
	    break;

	case WM_LBUTTONDBLCLK:
	    DPRINTFIF(__debug_WM_BUTTONDOWN__ , ("WM_LBUTTONDBLCLK h=%x\n", hWnd));
	    curButton = Button1;
	    goto commonButtonDown;
	case WM_MBUTTONDBLCLK:
	    DPRINTFIF(__debug_WM_BUTTONDOWN__ , ("WM_MBUTTONDBLCLK h=%x\n", hWnd));
	    curButton = Button2;
	    goto commonButtonDown;
	case WM_RBUTTONDBLCLK:
	    DPRINTFIF(__debug_WM_BUTTONDOWN__ , ("WM_RBUTTONDBLCLK h=%x\n", hWnd));
	    curButton = Button3;
#ifdef PRE_25_AUG_2010
	    if (isNative) {
		 NDPRINTF(("WM_*BUTTONDBLCLK for native - default handling\n"));
		 return 0;
	    }
	    goto commonButton;
#else
	    goto commonButtonDown;
#endif /* PRE_25_AUG_2010 */

	case WM_LBUTTONDOWN:
	    DPRINTFIF(__debug_WM_BUTTONDOWN__ , ("WM_LBUTTONDOWN h=%x\n", hWnd));
	    curButton = Button1;
	    goto commonButtonDown;
	case WM_MBUTTONDOWN:
	    DPRINTFIF(__debug_WM_BUTTONDOWN__ , ("WM_MBUTTONDOWN h=%x\n", hWnd));
	    curButton = Button2;
	    goto commonButtonDown;
	case WM_RBUTTONDOWN:
	    DPRINTFIF(__debug_WM_BUTTONDOWN__ , ("WM_RBUTTONDOWN h=%x\n", hWnd));
	    curButton = Button3;

	commonButtonDown:
	    if (isNative) {
		NDPRINTF(("WM_*BUTTONDOWN for native - default handling\n"));
		return 0;
	    }

	commonButtonWithCapture:
	    if (__currentCapture == CAPTURE_NONE) {
		__currentCapture = curButton /*CAPTURE_IMPLICIT*/;
		//SetFocus(hWnd);
		SetCapture(hWnd);
		CPRINTF(("SetCapture <BUTTONDOWN>%x\n",hWnd));
	    }
	    goto commonButton;

	commonButton:
	    EVENT_PRINTF3(("WM_BUTTONDOWN h=%x pos=%d/%d\n",
			   hWnd, LOWORD(lParam), HIWORD(lParam)));

	    if (GetWindow_eventMask(hWnd) & ButtonPressMask) {
		if (__eatingMouseEvents) {
		    __eatingMouseEvents = 0;
		} else {
		    enqEvent(ButtonPressMask, hWnd,
			     message, wParam, (UINT)(short)LOWORD(lParam), (INT)(short)HIWORD(lParam),
			     wParam, getModifiers(), evTime);
		}
	    }
	    *pDefault = 0;
	    break;

	case WM_CAPTURECHANGED:
	    DPRINTFIF(__debug_WM_FOCUS__ , ("WM_CAPTURECHANGED h=%x to %x\n", hWnd, lParam));
#if 0
	    if ((__currentCapture != CAPTURE_NONE) && (__currentCapture != CAPTURE_EXPLICIT))
	    {
	    }
#endif
	    break;

	case WM_KILLFOCUS:
	    DPRINTFIF(__debug_WM_FOCUS__ , ("WM_KILLFOCUS h=%x\n", hWnd));
	    // enqEvent(0, hWnd, WM_KILLFOCUS, wParam, 0, 0, 0, 0, EV_NOTIME);
	    if (isNative) {
		NDPRINTF(("WM_KILLFOCUS for native - default handling\n"));
		return 0;
	    }
	    *pDefault = 0;
	    break;

	case WM_SETFOCUS:
	    DPRINTFIF(__debug_WM_FOCUS__ , ("WM_SETFOCUS h=%x\n", hWnd));
#if 0
	    // enqEvent(0,hWnd, WM_SETFOCUS, wParam, 0, 0, 0, 0, EV_NOTIME);
	    {
		POINT p;
		HWND hWndChild,hWndTemp;

		p.x = evRootX;
		p.y = evRootY;
		ScreenToClient(hWnd, &p);
		hWndChild = hWnd; //hWndChild = ChildWindowFromPoint(hWnd,p);
		do {
		    hWndTemp = hWndChild;
		    hWndChild = ChildWindowFromPointEx(hWndTemp,p,CWP_SKIPINVISIBLE|CWP_SKIPDISABLED|CWP_SKIPTRANSPARENT);
		} while ((hWndChild) && (hWndChild != hWndTemp));

		/*console_printf("WM_ACTIVATE active h=%x p=%d.%d in %x\n", hWnd,p.x,p.y,hWndChild);*/
		if (hWndChild /*&& (hWndChild != hWnd)*/) {
		    if (hWndChild != __currentPointerView) {
			int modifiers = getModifiers();

			if (__currentPointerView) {
			    if (GetWindow_eventMask(__currentPointerView) & LeaveWindowMask)
				enqEvent(LeaveWindowMask, __currentPointerView, __WM_MOUSELEAVE, 0, -1, -1, 0, modifiers, EV_NOTIME);
				SetWindow_mouseXY(__currentPointerView, -9999, -9999);

			    __currentPointerView = 0;
			}
			if (GetWindow_eventMask(hWndChild) & EnterWindowMask) {
			    enqEvent(EnterWindowMask, hWndChild, __WM_MOUSEENTER, 0, evRootX, evRootY, 0, modifiers, EV_NOTIME);
			    SetWindow_mouseXY(hWndChild, evRootX, evRootY);
			}
			//SetFocus(hWndChild);
			__currentPointerView = hWndChild;
		    }
		}
	    }

	    if (isNative) {
		NDPRINTF(("WM_SETFOCUS for native - default handling\n"));
		return 0;
	    }
	    *pDefault = 0;
#endif
	    break;

	case WM_GETTEXT:
	    /*EVENT_PRINTF(("WM_GETTEXT %x\n", message));*/
	    break;

	case WM_GETTEXTLENGTH:
	    EVENT_PRINTF(("WM_GETTEXTLENGTH %x\n", message));
	    break;

	case WM_NCCREATE:
	    EVENT_PRINTF(("WM_NCCREATE %x\n", message));
	    break;

	case WM_NCMOUSEMOVE:
	    if (__currentCapture == CAPTURE_NONE) {
		if (__currentPointerView && (hWnd != __currentPointerView)) {
		    if (inSizeMove) {
			if (needDelayedMouseLeaveWindow == NULL) {
			    needDelayedMouseLeaveWindow = __currentPointerView;
			}
		    } else {
			if (GetWindow_eventMask(__currentPointerView) & LeaveWindowMask) {
			    enqEvent(LeaveWindowMask, __currentPointerView, __WM_MOUSELEAVE, 0, -1, -1, 0, getModifiers(), evTime);
			    SetWindow_mouseXY(__currentPointerView, -9999, -9999);
			}
		    }
		    __currentPointerView = 0;
		}
	    }
	    *pDefault = 0;
	    break;

	case WM_PARENTNOTIFY:
	    EVENT_PRINTF2(("WM_PARENTNOTIFY h=%x hChild=%x %d\n",
				hWnd, lParam, LOWORD(wParam)));
	    break;

	case WM_NCLBUTTONDOWN:
	    DPRINTFIF(__debug_WM_BUTTONDOWN__ , ("WM_NCLBUTTONDOWN\n"));
	    if (__shiftedLeftButtonIsLowerWindow) {
		/*
		 * with shift, this is a lower-operation
		 */
		if (GetKeyState(VK_SHIFT) & 0x8000) {
		    SetWindowPos(hWnd, HWND_BOTTOM, 0, 0, 0, 0,
				 SWP_NOSENDCHANGING |
				 SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE);
		    *pDefault = 0;
		}
	    }
	    break;

	case WM_NCLBUTTONUP:
	    DPRINTFIF(__debug_WM_BUTTONUP__ , ("WM_NCLBUTTONUP\n"));
	    break;

	case WM_NCRBUTTONDOWN:
	    DPRINTFIF(__debug_WM_BUTTONDOWN__ , ("WM_NCRBUTTONDOWN\n"));
	    if (__rightButtonIsLowerWindow) {
		/*
		 * this is a lower-operation
		 */
		SetWindowPos(hWnd, HWND_BOTTOM, 0, 0, 0, 0,
			     SWP_NOSENDCHANGING |
			     SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE);
		*pDefault = 0;
	    }
	    break;

	case WM_NCRBUTTONUP:
	    DPRINTFIF(__debug_WM_BUTTONUP__ , ("WM_NCRBUTTONUP\n"));
	    break;

	case WM_NCMBUTTONDOWN:
	    DPRINTFIF(__debug_WM_BUTTONDOWN__ , ("WM_NCMBUTTONDOWN\n"));
	    break;

	case WM_NCMBUTTONUP:
	    DPRINTFIF(__debug_WM_BUTTONUP__ , ("WM_NCMBUTTONUP\n"));
	    break;

	case WM_NCLBUTTONDBLCLK:
	    EVENT_PRINTF(("WM_NCLBUTTONDBLCLK\n"));
	    break;

	case WM_NCRBUTTONDBLCLK:
	    EVENT_PRINTF(("WM_NCRBUTTONDBLCLK\n"));
	    break;

	case WM_NCMBUTTONDBLCLK:
	    EVENT_PRINTF(("WM_NCMBUTTONDBLCLK\n"));
	    break;

	case WM_SETTEXT:
	    DPRINTFIF(__debug_WM_SETTEXT__ , ("WM_SETTEXT\n"));
	    break;

#ifdef WM_SYNCPAINT
	case WM_SYNCPAINT:
	    EVENT_PRINTF(("WM_SYNCPAINT\n"));
	    break;
#else
	case 0x88:
	    EVENT_PRINTF(("0x88 (undoc)\n"));
	    break;
#endif

	case WM_NCCALCSIZE:
	    EVENT_PRINTF(("WM_NCCALCSIZE\n"));
	    break;

	case WM_NCPAINT:
	    EVENT_PRINTF3(("WM_NCPAINT\n"));

#ifdef THIS_DOES_NOT_WORK
	    /* mhmh - something is drawn, but clipped wrong
	     * and with wrong colors ....
	     */

	    /*
	     * child windows only ...
	     */
	    if (GetParent(hWnd)) {
		int clr;

		clr = GetWindow_bdColor(hWnd);
		if (clr != BlackPixel) {
		    /*
		     * draw it here
		     */
		    HBRUSH br;
		    RECT rect, lineRect;
		    HDC hDC;

		    if (clr == WhitePixel) {
			br = __whiteBrush;
		    } else {
			br = CreateSolidBrush(clr);
		    }

		    GetWindowRect(hWnd, &rect);
		    hDC = GetWindowDC(hWnd);
		    SelectClipRgn(hDC, NULL);

		    lineRect.left = rect.left;
		    lineRect.right = rect.right;
		    lineRect.top = rect.top;
		    lineRect.bottom = rect.top + 1;
		    FillRect(hDC, &lineRect, br);

		    lineRect.bottom = rect.bottom - 1;
		    lineRect.bottom = rect.bottom;
		    FillRect(hDC, &lineRect, br);

		    lineRect.top = rect.top;
		    lineRect.bottom = rect.bottom;
		    lineRect.left = rect.left;
		    lineRect.right = rect.left + 1;
		    FillRect(hDC, &lineRect, br);

		    lineRect.left = rect.right - 1;
		    lineRect.right = rect.right;
		    FillRect(hDC, &lineRect, br);

		    _DeleteBrush(br, __LINE__);
		    ReleaseDC(hWnd, hDC);
		    *pDefault = 0;
		    return 0;
		}
	    }
#endif /* THIS_DOES_NOT_WORK */
	    break;

	case WM_SYSCOMMAND:
	    switch (wParam & ~0x000F) {
		case SC_CLOSE:
		    EVENT_PRINTF2(("WM_SYSCOMMAND SC_CLOSE\n"));
		    break;

		case SC_MOVE:
		    EVENT_PRINTF2(("WM_SYSCOMMAND SC_MOVE\n"));
		    break;

		case SC_RESTORE:
		    EVENT_PRINTF2(("WM_SYSCOMMAND SC_RESTORE\n"));
		    break;

		case SC_SIZE:
		    EVENT_PRINTF2(("WM_SYSCOMMAND SC_SIZE\n"));
		    break;

		default:
		    EVENT_PRINTF2(("WM_SYSCOMMAND %x\n", wParam));
		    break;
	    }
	    break;

	case WM_INITMENU:
	    EVENT_PRINTF(("WM_INITMENU\n"));
	    break;

	case WM_INITMENUPOPUP:
	    EVENT_PRINTF(("WM_INITMENUPOPUP\n"));
	    break;

	case WM_ENTERIDLE:
	    EVENT_PRINTF(("WM_ENTERIDLE\n"));
	    break;

	case WM_ENTERMENULOOP:
	    EVENT_PRINTF(("WM_ENTERMENULOOP\n"));
	    break;

	case WM_EXITMENULOOP:
	    EVENT_PRINTF(("WM_EXITMENULOOP\n"));
	    break;

	case WM_MENUSELECT:
	    EVENT_PRINTF(("WM_MENUSELECT\n"));
	    break;

	case WM_QUIT:
	    DPRINTF(("quit message hWnd=0x%x lP=0x%x wP=0x%x\n", hWnd, lParam, wParam));
	    enqEvent(0, 0, WM_QUIT, wParam, lParam, 0, 0, 0, EV_NOTIME);
	    break;

	case WM_NCDESTROY:
	    EVENT_PRINTF(("WM_NCDESTROY\n"));
	    break;

	case WM_QUERYNEWPALETTE:
	    EVENT_PRINTF(("WM_QUERYNEWPALETTE\n"));
	    break;

	case WM_PALETTECHANGED:
	    EVENT_PRINTF(("WM_PALETTECHANGED\n"));
	    break;

	case WM_ACTIVATEAPP:
	    EVENT_PRINTF2(("WM_ACTIVATEAPP %s\n", wParam ? "active" : "inactive"));
	    break;

	case WM_SYSDEADCHAR:
	    EVENT_PRINTF2(("WM_SYSDEADCHAR %x\n, wParam"));
	    break;

	case WM_DEADCHAR:
	    EVENT_PRINTF2(("WM_DEADCHAR %x\n, wParam"));
	    break;

	case WM_PAINTICON:
	    EVENT_PRINTF(("WM_PAINTICON\n"));
	    break;

	case WM_ICONERASEBKGND:
	    EVENT_PRINTF(("WM_ICONERASEBKGND\n"));
	    break;

	case WM_WINDOWPOSCHANGING:
	    DPRINTFIF(__debug_WM_WINDOWPOSCHANGING__ , ("WM_WINDOWPOSCHANGING\n"));

#ifdef HANDLE_VIEWGRAVITY
	    /*
	     * any child with a viewGravity ?
	     * (only care for topViews here;
	     *  child views do it on the smalltalk level ...)
	     */
	    if (GetParent(hWnd) == 0) {
		if (GetParent(hWnd) == 0) {
		    struct gravityCallBackInfo i;
		    RECT rct, dRect;
		    int dW, dH;
		    WINDOWPOS *wp = (WINDOWPOS *)lParam;
		    int winStyleBits, winExStyleBits;

		    if (! (wp->flags & SWP_NOSIZE)) {
			dRect.left = 0;
			dRect.top = 0;
			dRect.right = 100;
			dRect.bottom = 100;
			winStyleBits = GetWindowLong(hWnd, GWL_STYLE);
			winExStyleBits = GetWindowLong(hWnd, GWL_EXSTYLE);
			AdjustWindowRectEx(&dRect, winStyleBits, 0, winExStyleBits);
			dW = dRect.right - dRect.left;
			dH = dRect.bottom - dRect.top;

			GetClientRect(hWnd, &rct);

			i.parent = hWnd;

			i.currW = rct.right - rct.left;
			i.currH = rct.bottom - rct.top;

			/* wp gives us the new outer (frame) bounds */
			i.newW = wp->cx - (dW - 100);
			i.newH = wp->cy - (dH - 100);

			if ((i.currW != i.newW)
			 || (i.currH != i.newH)) {
			    DPRINTF((stderr, "about to sizeChange old: %d/%d new: %d/%d\n",
				    i.currW, i.currH, i.newW, i.newH));

			    GetWindowRect(hWnd, &rct);
			    i.parentWinX = rct.left - dRect.left;
			    i.parentWinY = rct.top - dRect.top;
			    EnumChildWindows(hWnd, gravityEnumeratorCallBack, (int)(&i));
			}
		    }
		}
	    }
#endif /* HANDLE_VIEWGRAVITY */

	    break;

	case WM_QUERYOPEN:
	    EVENT_PRINTF(("WM_QUERYOPEN\n"));
	    break;

	case WM_QUERYENDSESSION:
	    EVENT_PRINTF(("WM_QUERYENDSESSION\n"));
	    *pDefault = 0;
	    if (@global(CanEndSession) == false) {
		enqEvent(0, hWnd, WM_QUERYENDSESSION, wParam, 0, 0, 0, 0, EV_NOTIME);

		// TODO: enter new event loop
		// which is left when an endSessionConfirmation
		// arrives from smalltalk
		// (either positive or negative).
		// for now, do not allow leaving
		// windows as long as ST/X is open.

		return(0);
	    }
	    return(TRUE);  // allow leaving windows
	    break;

	case WM_ENDSESSION:
	    EVENT_PRINTF(("WM_ENDSESSION\n"));
	    enqEvent(0, hWnd, WM_ENDSESSION, wParam, 0, 0, 0, 0, EV_NOTIME);
	    break;

	case WM_DISPLAYCHANGE:
	    EVENT_PRINTF(("WM_DISPLAYCHANGE\n"));
	    enqEvent(0, hWnd, WM_DISPLAYCHANGE, wParam, 0, 0, 0, 0, EV_NOTIME);
	    break;

	case WM_FONTCHANGE:
	    EVENT_PRINTF(("WM_FONTCHANGE\n"));
	    enqEvent(0, hWnd, WM_FONTCHANGE, wParam, 0, 0, 0, 0, EV_NOTIME);
	    break;

	case WM_WININICHANGE:
	    EVENT_PRINTF(("WM_WININICHANGE\n"));
	    enqEvent(0, hWnd, WM_WININICHANGE, wParam, 0, 0, 0, 0, EV_NOTIME);
	    break;

	case WM_SYSCOLORCHANGE:
	    EVENT_PRINTF(("WM_SYSCOLORCHANGE\n"));
	    enqEvent(0, hWnd, WM_SYSCOLORCHANGE, wParam, 0, 0, 0, 0, EV_NOTIME);
	    break;

	case WM_MOVING:
	    DPRINTFIF(__debug_WM_MOVING__ , ("WM_MOVING\n"));
#ifdef DELAY_ENTER_LEAVE_WHILE_IN_SIZE_MOVE
	    inMove = 1;
#endif
	    break;

	case WM_SIZING:
	    EVENT_PRINTF(("WM_SIZING\n"));
#ifdef DELAY_ENTER_LEAVE_WHILE_IN_SIZE_MOVE
	    inSize = 1;
#endif
	    break;

	case WM_ENTERSIZEMOVE:
	    EVENT_PRINTF(("WM_ENTERSIZEMOVE\n"));
#ifdef DELAY_ENTER_LEAVE_WHILE_IN_SIZE_MOVE
	    inSizeMove = 1;
#endif
	    break;

	case WM_EXITSIZEMOVE:
	    EVENT_PRINTF(("WM_EXITSIZEMOVE\n"));

#ifndef PRE_13_APR_04_POSCHANGED_IN_EXITSIZEMOVE
	    if (inMove) {
		/* generate WM_WINDOWPOSCHANGED
		*/
		RECT rct;
		int x, y, w, h;

		GetClientRect(hWnd, &rct);

		x = rct.left;
		y = rct.top;
		w = rct.right - rct.left;
		h = rct.bottom - rct.top;

		if ((w == 0) && (h == 0)) {
		    if (! GetWindow_iconified(hWnd)) {
			SetWindow_iconified(hWnd, 1);
		    }
		    enqEvent(0, hWnd, __WM_ICONIFIED, 1, 0, 0, 0, 0, EV_NOTIME);
		} else {
		    if (GetWindow_iconified(hWnd)) {
			SetWindow_iconified(hWnd, 0);
			enqEvent(0, hWnd, __WM_ICONIFIED, 0, 0, 0, 0, 0, EV_NOTIME);
		    } else {
			enqEvent(0, hWnd, WM_WINDOWPOSCHANGED, 0, x, y, w, h, EV_NOTIME);
		    }
		}
	    }
#endif

	    inSizeMove = inMove = inSize = 0;

	    if (needDelayedMouseLeaveWindow || needDelayedMouseEnterWindow) {
		int modifiers = getModifiers();

		if (needDelayedMouseLeaveWindow) {
		    if (GetWindow_eventMask(needDelayedMouseLeaveWindow) & LeaveWindowMask) {
			enqEvent(LeaveWindowMask, needDelayedMouseLeaveWindow, __WM_MOUSELEAVE, 0, -1, -1, 0, modifiers, EV_NOTIME);
			SetWindow_mouseXY(needDelayedMouseLeaveWindow, -9999, -9999);
		    }
		    needDelayedMouseLeaveWindow = NULL;
		}
		if (needDelayedMouseEnterWindow) {
		    if (GetWindow_eventMask(needDelayedMouseEnterWindow) & EnterWindowMask) {
			enqEvent(EnterWindowMask, needDelayedMouseEnterWindow, __WM_MOUSEENTER, 0, delayedMouseEnterX, delayedMouseEnterY, 0, modifiers, EV_NOTIME);
			SetWindow_mouseXY(needDelayedMouseEnterWindow, delayedMouseEnterX, delayedMouseEnterY);
		    }
		    needDelayedMouseEnterWindow = NULL;
		}
	    }

	    break;

	case WM_MOVE:
	    EVENT_PRINTF(("WM_MOVE\n"));
	    break;

	case WM_POWER:
	    EVENT_PRINTF(("WM_POWER\n"));
	    enqEvent(0, hWnd, WM_POWER, wParam, 0, 0, 0, 0, EV_NOTIME);
	    break;

	/* native widget actions */
	case WM_COMMAND:
	    if (lParam) {
		NDPRINTF(("COMMAND for widget\n"));
		enqEvent(0, (HWND)(lParam), WM_COMMAND, wParam, lParam, 0, 0, 0, EV_NOTIME);
	    } else {
		NDPRINTF(("COMMAND for owner\n"));
		enqEvent(0, hWnd, WM_COMMAND, wParam, lParam, 0, 0, 0, EV_NOTIME);
	    }
	    break;

	/* tray action */
	case WM_TRAY_MESSAGE:
	    DPRINTF(("tray message hWnd=0x%x lP=0x%x wP=0x%x\n", hWnd, lParam, wParam));
	    enqEvent(0, hWnd, WM_TRAY_MESSAGE, wParam, lParam, 0, 0, 0, EV_NOTIME);
	    break;

	case WM_COPYDATA:
	    DPRINTFIF(__debug_WM_COPYDATA__ , ("WM_COPYDATA\n"));
	    {
		PCOPYDATASTRUCT pCDs = (PCOPYDATASTRUCT) lParam;
		int dwData = pCDs->dwData;
		int nBytes = pCDs->cbData;
		void *pData = pCDs->lpData;
		void *pCopiedData;

		DPRINTFIF(__debug_WM_COPYDATA__ , ("WM_COPYDATA %d %lx\n", nBytes, pData));

		/*
		 * because pData is only valid here, copy it out to a malloc'd
		 * area. This MUST be free'd by someone else !
		 */
		if (nBytes) {
		    pCopiedData = malloc(nBytes);
		    memcpy(pCopiedData, pData, nBytes);
		} else {
		    pCopiedData = NULL;
		}
		//     (flag, hWnd, message, wParam, arg1, arg2, arg3, arg4, evTime)
		enqEvent(0, hWnd, WM_COPYDATA, wParam, (INT)pCopiedData, nBytes, dwData, 0, EV_NOTIME);
	    }
	    *pDefault = 0;
	    break;

	case WM_HSCROLL:
	case WM_VSCROLL:
	    NDPRINTF(("VM_*SCROLL\n"));
	    enqEvent(0, hWnd, message, wParam, lParam, 0, 0, 0, EV_NOTIME);
	    break;

	case WM_DRAWITEM:
	    EVENT_PRINTF(("WM_DRAWITEM\n"));
#if 0
	    {
		DRAWITEMSTRUCT *pItemStruct;

		pItemStruct = (DRAWITEMSTRUCT *)lParam;
		enqEvent(0, pItemStruct->hwndItem, WM_DRAWITEM, wParam, 0, 0, 0, 0, EV_NOTIME);
	    }
#endif
	    break;

#ifdef TRACE_ALL_EVENTS
	case WM_CTLCOLORMSGBOX:
	    UNHANDLED_EVENT_PRINTF(("WM_CTLCOLORMSGBOX\n"));
	    break;
	case WM_CTLCOLOREDIT:
	    UNHANDLED_EVENT_PRINTF(("WM_CTLCOLOREDIT\n"));
	    break;
	case WM_CTLCOLORLISTBOX:
	    UNHANDLED_EVENT_PRINTF(("WM_CTLCOLORLISTBOX\n"));
	    break;
	case WM_CTLCOLORBTN:
	    UNHANDLED_EVENT_PRINTF(("WM_CTLCOLORBTN\n"));
	    break;
	case WM_CTLCOLORDLG:
	    UNHANDLED_EVENT_PRINTF(("WM_CTLCOLORDLG\n"));
	    break;
	case WM_CTLCOLORSTATIC:
	    UNHANDLED_EVENT_PRINTF(("WM_CTLCOLORSTATIC\n"));
	    break;
	case WM_CTLCOLORSCROLLBAR:
	    UNHANDLED_EVENT_PRINTFIF(__debug_WM_CTLCOLORSCROLLBAR__, ("WM_CTLCOLORSCROLLBAR\n"));
	    break;

	case WM_STYLECHANGING:
	    UNHANDLED_EVENT_PRINTF(("WM_STYLECHANGING\n"));
	    break;
	case WM_STYLECHANGED:
	    UNHANDLED_EVENT_PRINTF(("WM_STYLECHANGED\n"));
	    break;

	case WM_GETICON:
	    UNHANDLED_EVENT_PRINTFIF(__debug_WM_GETICON__, ("WM_GETICON\n"));
	    break;
	case WM_SETICON:
	    UNHANDLED_EVENT_PRINTF(("WM_SETICON\n"));
	    break;

	case WM_PRINT:
	    UNHANDLED_EVENT_PRINTF(("WM_PRINT(lParam=%d)\n", lParam));
	    break;
	case WM_PRINTCLIENT:
	    UNHANDLED_EVENT_PRINTF(("WM_PRINTCLIENT(lParam=%d)\n", lParam));
	    break;

	case WM_NULL:
	    UNHANDLED_EVENT_PRINTF(("WM_NULL\n"));
	    break;

	case WM_ENABLE:
	    UNHANDLED_EVENT_PRINTF(("WM_ENABLE\n"));
	    break;

	case WM_SETREDRAW:
	    UNHANDLED_EVENT_PRINTF(("WM_SETREDRAW\n"));
	    break;

	case WM_DEVMODECHANGE:
	    UNHANDLED_EVENT_PRINTF(("WM_DEVMODECHANGE\n"));
	    break;

	case WM_TIMECHANGE:
	    UNHANDLED_EVENT_PRINTF(("WM_TIMECHANGE\n"));
	    break;

	case WM_CANCELMODE:
	    UNHANDLED_EVENT_PRINTF(("WM_CANCELMODE\n"));
	    break;

	case WM_CHILDACTIVATE:
	    UNHANDLED_EVENT_PRINTF(("WM_CHILDACTIVATE\n"));
	    break;

	case WM_QUEUESYNC:
	    UNHANDLED_EVENT_PRINTF(("WM_QUEUESYNC\n"));
	    break;

	case WM_NEXTDLGCTL:
	    UNHANDLED_EVENT_PRINTF(("WM_NEXTDLGCTL\n"));
	    break;

	case WM_SPOOLERSTATUS:
	    UNHANDLED_EVENT_PRINTF(("WM_SPOOLERSTATUS\n"));
	    break;

	case WM_MEASUREITEM:
	    UNHANDLED_EVENT_PRINTF(("WM_MEASUREITEM\n"));
	    break;

	case WM_DELETEITEM:
	    UNHANDLED_EVENT_PRINTF(("WM_DELETEITEM\n"));
	    break;

	case WM_VKEYTOITEM:
	    UNHANDLED_EVENT_PRINTF(("WM_VKEYTOITEM\n"));
	    break;

	case WM_CHARTOITEM:
	    UNHANDLED_EVENT_PRINTF(("WM_CHARTOITEM\n"));
	    break;

	case WM_SETFONT:
	    UNHANDLED_EVENT_PRINTF(("WM_SETFONT\n"));
	    break;

	case WM_GETFONT:
	    UNHANDLED_EVENT_PRINTF(("WM_GETFONT\n"));
	    break;

	case WM_SETHOTKEY:
	    UNHANDLED_EVENT_PRINTF(("WM_SETHOTKEY\n"));
	    break;

	case WM_GETHOTKEY:
	    UNHANDLED_EVENT_PRINTF(("WM_GETHOTKEY\n"));
	    break;

	case WM_QUERYDRAGICON:
	    UNHANDLED_EVENT_PRINTF(("WM_QUERYDRAGICON\n"));
	    break;

	case WM_COMPAREITEM:
	    UNHANDLED_EVENT_PRINTF(("WM_COMPAREITEM\n"));
	    break;

	case WM_GETOBJECT:
	    UNHANDLED_EVENT_PRINTF(("WM_GETOBJECT\n"));
	    break;

	case WM_COMPACTING:
	    UNHANDLED_EVENT_PRINTF(("WM_COMPACTING\n"));
	    break;

	case WM_COMMNOTIFY:
	    UNHANDLED_EVENT_PRINTF(("WM_COMMNOTIFY\n"));
	    break;

	case WM_CANCELJOURNAL:
	    UNHANDLED_EVENT_PRINTF(("WM_CANCELJOURNAL\n"));
	    break;

	case WM_INPUTLANGCHANGEREQUEST:
	    UNHANDLED_EVENT_PRINTF(("WM_INPUTLANGCHANGEREQUEST\n"));
	    break;

	case WM_INPUTLANGCHANGE:
	    UNHANDLED_EVENT_PRINTF(("WM_INPUTLANGCHANGE\n"));
	    break;

	case WM_TCARD:
	    UNHANDLED_EVENT_PRINTF(("WM_TCARD\n"));
	    break;

	case WM_HELP:
	    UNHANDLED_EVENT_PRINTF(("WM_HELP\n"));
	    break;

	case WM_USERCHANGED:
	    UNHANDLED_EVENT_PRINTF(("WM_USERCHANGED\n"));
	    break;

	case WM_NOTIFY:
	    UNHANDLED_EVENT_PRINTF(("WM_NOTIFY\n"));
	    break;

	case WM_NOTIFYFORMAT:
	    UNHANDLED_EVENT_PRINTF(("WM_NOTIFYFORMAT\n"));
	    break;

	case WM_CONTEXTMENU:
	    UNHANDLED_EVENT_PRINTF(("WM_CONTEXTMENU\n"));
	    break;

	case WM_NCXBUTTONDOWN:
	    UNHANDLED_EVENT_PRINTF(("WM_NCXBUTTONDOWN\n"));
	    break;

	case WM_NCXBUTTONUP:
	    UNHANDLED_EVENT_PRINTF(("WM_NCXBUTTONUP\n"));
	    break;

	case WM_NCXBUTTONDBLCLK:
	    UNHANDLED_EVENT_PRINTF(("WM_NCXBUTTONDBLCLK\n"));
	    break;

	case WM_DEVICECHANGE:
	    UNHANDLED_EVENT_PRINTF(("WM_DEVICECHANGE\n"));
	    break;

	case DBT_DEVICEARRIVAL:
	    UNHANDLED_EVENT_PRINTF(("DBT_DEVICEARRIVAL\n"));
	    break;

	case DBT_DEVICEREMOVECOMPLETE:
	    UNHANDLED_EVENT_PRINTF(("DBT_DEVICEREMOVECOMPLETE\n"));
	    break;
#endif

	default:
	    EVENT_PRINTF(( "WinWorkstat [info] unhandled msg = %d 0x%x [%d]\n", message, message, __LINE__));
	    break;
    }
    return 0;
}


static void _USERENTRY
dispatchThread(void *arg)
{
    static int th_calls;
    RECT rect;
    MSG msg;
    localWindowInfo *lI;

    _dispatchThreadId2 = GetCurrentThreadId();
#ifdef STARTUP_DISPATCHTHREAD_DEBUG
    console_fprintf(stderr, "WinWorkstation [info]: dispatchThreadID2=%x\n", _dispatchThreadId2);
#endif
    TH_DPRINTF(("TS %d\n", th_calls++));
    PeekMessageW(&msg, NULL, 0, 0, PM_NOREMOVE);   /* must be */

#if 0
    if (AttachThreadInput(_masterThreadId, _dispatchThreadId2, TRUE) != TRUE) {
	console_fprintf(stderr, "WinWorkstation [warning]: AttachThreadInput failed\n");
    };
#endif
#ifndef WIN32THREADS
# if 0
    SetThreadPriority(_masterThread,THREAD_PRIORITY_HIGHEST);
    SetThreadPriority(GetCurrentThread(),THREAD_PRIORITY_ABOVE_NORMAL);
# endif
#endif

    GetWindowRect(GetDesktopWindow(), &rect);
    /* allocate localMemory for Window */
    lI = (localWindowInfo *)malloc(sizeof(localWindowInfo));
    if (lI) {
	memset(lI, 0, sizeof(*lI));
    }

    __rootWinSpezial = CreateWindowExW(WS_EX_TOOLWINDOW | WS_EX_TRANSPARENT,
				      wapp_nameRoot, wapp_nameRoot,
				      WS_POPUP | WS_DISABLED,
				      0, 0,
				      rect.right - rect.left, rect.bottom - rect.top,
				      0, 0, (HANDLE) __getHInstance(), lI);

    //ShowWindow(__rootWinSpezial,SW_SHOWNOACTIVATE);
    SetWindowPos(__rootWinSpezial, HWND_BOTTOM, 0, 0, 0, 0,
		 SWP_NOSENDCHANGING |
		 SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE);

#ifdef STARTUP_DISPATCHTHREAD_DEBUG
    console_fprintf(stderr, "WinWorkstation [info]: setting ThreadRunningEvent\n");
#endif
    SetEvent(hDispatchThreadRunningEvent);

    for (;;) {
	HANDLE dummy;

	TH_DPRINTF(("TG %d\n", th_calls++));

	/*
	 * if there is no current capture (pointer-grab),
	 * make certain that we do not get stuck in the GetMessage
	 * but instead poll the mouse in 200ms intervals.
	 * This is required to synthesize the MOUSELEAVE message,
	 */
// DPRINTF(("X1\n"));
	if (__currentPointerView && (__currentCapture == CAPTURE_NONE)) {
// DPRINTF(("X2\n"));
	    while (PeekMessageW(&msg, 0, 0, 0, PM_NOREMOVE) == 0) {
// DPRINTF(("PeekMessage -> 0\n"));
		/*
		 * wait for an event; timeout after 200 millis
		 */
		if (MsgWaitForMultipleObjects(0,&dummy,FALSE,200,QS_ALLINPUT) == WAIT_TIMEOUT) {
		    if (! inSizeMove) {
			/*
			 * timeout - see where mouse pointer is
			 * for synthetic leave events.
			 */
			POINT point;

			if (GetCursorPos(&point)) {
			    HWND hWnd = WindowFromPoint(point);

			    if (hWnd) {
				if (GetWindowThreadProcessId(hWnd,0) != GetCurrentThreadId()) {
				    if (inSizeMove) {
					if (needDelayedMouseLeaveWindow == NULL) {
					    needDelayedMouseLeaveWindow = __currentPointerView;
					}
				    } else {
					if (GetWindow_eventMask(__currentPointerView) & LeaveWindowMask) {
					    enqEvent(LeaveWindowMask, __currentPointerView, __WM_MOUSELEAVE, 0, -1, -1, 0, getModifiers(), EV_NOTIME);
					    SetWindow_mouseXY(__currentPointerView, -9999, -9999);
					}
				    }
				    __currentPointerView = 0;
				    break;
				}
			    }
			}
		    }
		}
	    }
	}

	GetMessageW(&msg, NULL, 0, 0);
// DPRINTF(("GetMessage -> %d\n", msg.message));
	TH_DPRINTF(("TD %d\n", th_calls++));
	destroyWin = 0;

	switch (msg.message) {
#if 0
	    case WM_THREAD_DESTROYWINDOW:
		destroyWin = TRUE;
		msg.message = WM_CLOSE;
		EVENT_PRINTF(("thread WM_THREAD_DESTROYWINDOW %x\n",msg.hwnd));
		break;
#endif

#ifdef SET_FOCUS_IN_WINTHREAD
	    case WM_THREAD_SETFOCUS:
		DPRINTFIF(__debug_WM_FOCUS__ , ("WM_THREAD_SETFOCUS h=%x\n", msg.wParam));
# ifdef xxWIN32THREADS
		if (msg.lParam) {
		    if (AttachThreadInput(_dispatchThreadId2,msg.lParam,TRUE) == FALSE)
			PRINTF(("SetFocus AttachThreadInput error %d\n", GetLastError()));
		}
# endif
		EVENT_PRINTF(("threadSetfocus %x\n",msg.wParam));
		if (SetFocus((HWND)msg.wParam) == 0) {
		    DDPRINTF(("SetFocus to %x failed.\n",msg.wParam));
		}
		continue;
#endif

#ifdef SET_CURSOR_IN_WINTHREAD
	    case WM_THREAD_SETCURSOR:
		if (msg.lParam) {
#if 1
		    SetCursor((HCURSOR)msg.lParam);
#else
		    /* this check is done by our sender */
		    {
			POINT p;
			GetCursorPos(&p);
			if (WindowFromPoint(p) == msg.hwnd) {
			    EVENT_PRINTF(("threadSetCursor %x\n",msg.lParam));
			    SetCursor((HCURSOR)msg.lParam);
			}
		    }
#endif
		}
		continue;
#endif

#ifdef BEEP_IN_WINTHREAD
	    case WM_THREAD_BEEP:
		MessageBeep( MB_ICONEXCLAMATION);
		continue;
#endif

	    case WM_THREAD_SETCAPTURE:
		if (msg.wParam) {
		    if (__currentPointerView) {
			if (inSizeMove) {
			    if (needDelayedMouseLeaveWindow == NULL) {
				needDelayedMouseLeaveWindow = __currentPointerView;
			    }
			} else {
			    if (GetWindow_eventMask(__currentPointerView) & LeaveWindowMask) {
				enqEvent(LeaveWindowMask, __currentPointerView, __WM_MOUSELEAVE, 0, -1, -1, 0, getModifiers(), EV_NOTIME);
				SetWindow_mouseXY(__currentPointerView, -9999, -9999);
			    }
			}
		    }

		    __currentPointerView = (HWND)msg.wParam;
		    __currentCapture = CAPTURE_EXPLICIT;
		    EVENT_PRINTF(("threadSetCapture %x\n",msg.wParam));
		    SetCapture(__currentPointerView);
		} else {
		    if (__currentPointerView  == __rootWinSpezial) {
			//ShowWindow(__rootWinSpezial, SW_HIDE);
			SetWindowPos(__rootWinSpezial, HWND_BOTTOM, 0, 0, 0, 0,
				     SWP_NOREDRAW | SWP_NOSENDCHANGING | SWP_NOCOPYBITS
				     | SWP_HIDEWINDOW | SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE
				   /*| SWP_NOZORDER | SWP_NOOWNERZORDER */);
		    }
		    __currentPointerView = 0;
		    __currentCapture = CAPTURE_NONE;
		    EVENT_PRINTF(("threadReleaseCapture\n"));
		    ReleaseCapture();
		}
		if (msg.lParam) {
		    DDDDPRINTF(("threadSetCursor %x\n",msg.lParam));
		    SetCursor((HCURSOR)msg.lParam);
		}
		continue;

	    case WM_THREAD_CREATEWINDOW:
		EVENT_PRINTF(("*WM_THREAD_CREATEWINDOW %d\n", th_calls));

		{
		    createWindowInfo *cwi = (createWindowInfo *)(msg.lParam);

		    if ((cwi->sequenceNr == msg.wParam)
		     && (cwi->sequenceNr != INVALIDATED_CWI)) {
			cwi->sequenceNr = INVALIDATED_CWI;
			cwi->infoWasRead = 1;
			if (cwi->newWinHandle == NULL) {
			    HANDLE ev;

			    cwi->newWinHandle = CreateWindowExW(
						cwi->winStyleBitsEx,
						cwi->className,
						cwi->windowName,
						cwi->winStyleBits,
						cwi->x, cwi->y,
						cwi->dx, cwi->dy,
						cwi->parentHandle,
						NULL,           /* menu */
						(HANDLE) __getHInstance(),
						cwi->localWindowInfo
					       );

			    if (cwi->newWinHandle == NULL) {
				cwi->errCode = GetLastError();
				console_fprintf(stderr, "WinWorkstation [info]: CreateWindow %s failed: %d (0x%x) [%d]\n",
						cwi->className, cwi->errCode, cwi->errCode, __LINE__);
			    } else {
				SETLOCALWINDOWINFOPTR(cwi->newWinHandle, cwi->localWindowInfo);
#ifdef DEBUG /* PARANOIA */
				if (GETLOCALWINDOWINFOPTR(cwi->newWinHandle) != cwi->localWindowInfo) {
				   console_fprintf(stderr, "lI-Error\n");
				}
#endif
			    }

			    ev = cwi->hCreateEvent;
			    if (ev) {
				SetEvent(ev);
			    }
			}
		    } else {
			DPRINTF(("obsolete createWindow message %x ignored\n", cwi->sequenceNr));
		    }
		}
		continue;

	    case WM_THREAD_REGISTERHOTKEY:
		EVENT_PRINTF(("*WM_THREAD_REGISTERHOTKEY\n"));

		{
		    registerHotKeyInfo *rhki = (registerHotKeyInfo *)(msg.lParam);
		    if (!RegisterHotKey(rhki->hwnd,rhki->hotKeyId,rhki->modifier,rhki->virtualKey)){
			console_fprintf(stderr, "WinWorkstation [error]: RegisterHotKey failed: err=%d\n", GetLastError() );
		    }
		}
		continue;

	    case WM_THREAD_UNREGISTERHOTKEY:
		EVENT_PRINTF(("*WM_THREAD_UNREGISTERHOTKEY\n"));

		{
		    registerHotKeyInfo *rhki = (registerHotKeyInfo *)(msg.lParam);
		    if (!UnregisterHotKey(rhki->hwnd,rhki->hotKeyId)){
			console_fprintf(stderr, "WinWorkstation [error]: UnegisterHotKey failed: err=%d\n", GetLastError() );
		    }
		}
		continue;

	    case WM_KEYDOWN:
		DPRINTFIF(__debug_WM_KEYDOWN__ , ("WM_KEYDOWN %x\n", msg.wParam));
		goto commonKey;

	    case WM_KEYUP:
		DPRINTFIF(__debug_WM_KEYUP__  , ("WM_KEYUP %x\n", msg.wParam));
		goto commonKey;

	    case WM_SYSKEYDOWN:
		DPRINTFIF(__debug_WM_KEYDOWN__ , ("WM_SYSKEYDOWN %x\n", msg.wParam));
		goto commonKey;

	    case WM_SYSKEYUP:
		DPRINTFIF(__debug_WM_KEYUP__ , ("WM_SYSKEYUP %x\n", msg.wParam));
		goto commonKey;

	    case WM_HOTKEY:
		// console_fprintf(stderr, "dispatchThread [info]: receive hotkey %x %x\n", msg.hwnd, msg.wParam);
		DPRINTFIF(__debug_WM_KEYUP__ , ("WM_HOTKEY %x\n", msg.wParam));
		break;

	    commonKey:
#if 1
		if (((msg.wParam >= '0') && (msg.wParam <= 'Z'))
		 || ((msg.wParam >= VK_MULTIPLY) && (msg.wParam <= VK_DIVIDE))
		 || (msg.wParam == VK_SPACE)
		 || (msg.wParam == VK_CAPITAL)
		 /* || (msg.wParam == VK_SHIFT) */
		 || (msg.wParam >= 0xB0))
#endif
		{
		    /*
		     * translate to a WM_CHAR message
		     */
		    if (TranslateMessage(&msg))
			continue;
		}
		break;

	    /* short cirquit some messages */
#if 0
# ifndef SUPPORT_NATIVE_WINDOWS
	    /*
	     * some can simply be ignored ...
	     */
	    case WM_ERASEBKGND:
		EVENT_PRINTF(("*WM_ERASEBKGND\n"));
		continue;
	    case WM_KILLFOCUS:
		EVENT_PRINTF(("*WM_KILLFOCUS\n"));
		continue;
# endif
#endif

#if 0
	    case WM_SIZE:
		EVENT_PRINTF(("*WM_SIZE\n"));
		continue;
#endif
	}

	/*
	 * common ...
	 */
	evRootX = msg.pt.x;
	evRootY = msg.pt.y;
#if 1
	{
	    POINT p;

	    if (GetCursorPos(&p)) {
		evRootX = p.x;
		evRootY = p.y;
	    }
	}
#endif
	lastMSGTime = msg.time;
	DispatchMessageW(&msg);   /* Dispatches message to window */
    }
}

LONG APIENTRY
MainWndProc(HWND hWnd, UINT message, UINT wParam, LONG lParam)
{
    int wantDefault = 1;
    int retVal;
    createWindowInfo *cwi;

    TH_DPRINTF(("TMW %d\n",message));
    EVENT_PRINTF3(("MainWndProc %d\n",message));
    /*
     * kludge while in sizeMove loop, which
     * is performed directly by DefWindowProc
     * even more of a kludge: to prevent the message in the PostThreadMessage-queue
     * from being processed twice, we use a sequenceNr, which is passed as wParam.
     */
    cwi = pendingCREATEWINDOWInfo;
    if (cwi) {
	int dummyWantDefault;
	int seqNr = pendingSequenceNr;

	pendingCREATEWINDOWInfo = 0;
	pendingSequenceNr = INVALIDATED_CWI;
	DPRINTF(("### THREAD_CREATEWINDOW\n"));
	winEventProcessing(0, WM_THREAD_CREATEWINDOW, seqNr, (INT)cwi, &dummyWantDefault);
    }

    retVal = winEventProcessing(hWnd, message, wParam, lParam, &wantDefault);
    if (wantDefault) {
	DDDPRINTF((">>DefWindowProc\n"));
	retVal = DefWindowProcW(hWnd, message, wParam, lParam);
	DDDPRINTF(("<<DefWindowProc\n"));
    }
    return retVal;
}

static int CALLBACK
EnumWindowsProc(HWND hwnd, LPARAM lParam)
{
	volatile OBJ *refToCollection;
	OBJ collection;
	OBJ wHandle;

	if (hwnd) {
	    refToCollection = (OBJ*) lParam;
	    __PROTECT__(*refToCollection);
	    wHandle = __MKEXTERNALADDRESS(hwnd);
	    __UNPROTECT__(*refToCollection);
	    collection = *refToCollection;
	    __SSEND1( collection, @symbol(add:), 0, wHandle );
	}
	return TRUE;
}

#ifdef USE_EnumFontFamiliesEx
# define LOGFONTTYPE  ENUMLOGFONTEX
#else
# define LOGFONTTYPE  LOGFONT
#endif

static int CALLBACK
EnumFPTypeFaceProc(
    const LOGFONTTYPE *lplf,   /* ptr to of logical-font data */
    const TEXTMETRIC  *lptm,   /* ptr to physical font data */
    DWORD dwType,              /* font type */
    LPARAM lpData              /* application supplied data */
) {
	OBJ t;
	volatile OBJ *refToList;
	OBJ  typeFaceList;
	char *faceNameString;

	if (lplf) {
	    refToList = (OBJ *) lpData;
	    __PROTECT__(*refToList);

#ifdef USE_EnumFontFamiliesEx
	    faceNameString = lplf->elfLogFont.lfFaceName;
#else
	    faceNameString = lplf->lfFaceName;
#endif
	    t = __MKSTRING( faceNameString );
	    __UNPROTECT__(*refToList);
	    typeFaceList = *refToList;
	    __SSEND1( typeFaceList, @symbol(add:), 0, t );
	}
	return 1;
}

/*
 * take a LOGFONT structure and extract relevant data into a smalltalk array.
 *
 * Returned value is:
 *      #(
 *          1   lfHeight
 *          2   lfWidth
 *          3   lfEscapement
 *          4   lfOrientation
 *          5   lfWeight (Integer)
 *          6   lfWeight (String)
 *          7   lfItalic
 *          8   lfUnderline
 *          9   lfStrikeOut
 *         10   lfCharSet (Integer)
 *         11   lfOutPrecision
 *         12   lfClipPrecision
 *         13   lfQuality
 *         14   lfPitchAndFamily
 *         15   face and style name (String i.e. "bold-roman")
 *         16   face name from windows
 *         17   character encoding lfCharSet (as String i.e. "ms_ansi", "ms_oem", "ms_cyrillic")
 *         18
 *         19
 *         20
 *       )
 * CAVEAT: returns an array to avoid knowlege-need about ST-Objects (FontDescripttion) here.
 */
OBJ
__charSetSymbolFor(int charSet)
{
    OBJ s;

    switch (charSet) {
	case ANSI_CHARSET:
	    s = @symbol('ms-ansi');
	    break;
	case DEFAULT_CHARSET:
	    s = @symbol('ms-default');
	    break;
	case SYMBOL_CHARSET:
	    s = @symbol('ms-symbol');
	    break;
	case SHIFTJIS_CHARSET:
	    s = @symbol('ms-shiftjis');
	    break;
	case GB2312_CHARSET:
	    s = @symbol('ms-gb2312');
	    break;
	case HANGEUL_CHARSET:
	    s = @symbol('ms-hangeul');
	    break;
# if defined(HANGUL_CHARSET) && (HANGUL_CHARSET != HANGEUL_CHARSET)
	case HANGUL_CHARSET:
	    s = @symbol('ms-hangul');
	    break;
# endif
	case CHINESEBIG5_CHARSET:
	    s = @symbol('ms-chinesebig5');
	    break;
	case OEM_CHARSET:
	    s = @symbol('ms-oem');
	    break;
# ifdef JOHAB_CHARSET
	case JOHAB_CHARSET:
	    s = @symbol('ms-johab');
	    break;
# endif
# ifdef HEBREW_CHARSET
	case HEBREW_CHARSET:
	    s = @symbol('ms-hebrew');
	    break;
# endif
# ifdef ARABIC_CHARSET
	case ARABIC_CHARSET:
	    s = @symbol('ms-arabic');
	    break;
# endif
# ifdef GREEK_CHARSET
	case GREEK_CHARSET:
	    s = @symbol('ms-greek');
	    break;
# endif
# ifdef TURKISH_CHARSET
	case TURKISH_CHARSET:
	    s = @symbol('ms-turkish');
	    break;
# endif
# ifdef RUSSIAN_CHARSET
	case RUSSIAN_CHARSET:
	    s = @symbol('ms-russian');
	    break;
# endif
# ifdef EASTEUROPE_CHARSET
	case EASTEUROPE_CHARSET:
	    s = @symbol('ms-easteurope');
	    break;
# endif
# ifdef BALTIC_CHARSET
	case BALTIC_CHARSET:
	    s = @symbol('ms-baltic');
	    break;
# endif
# ifdef VIETNAMESE_CHARSET
	case VIETNAMESE_CHARSET:
	    s = @symbol('ms-vietnamese');
	    break;
# endif
# ifdef THAI_CHARSET
	case THAI_CHARSET:
	    s = @symbol('ms-thai');
	    break;
# endif
# ifdef MAC_CHARSET
	case MAC_CHARSET:
	    s = @symbol('ms-mac');
	    break;
# endif
# ifdef UNICODE_CHARSET
	case UNICODE_CHARSET:
	    s = @symbol('ms-unicode');
	    break;
# endif
	default:
	    s = @symbol(unknown);
	    break;
    }
    return s;
}

OBJ
__extractLogicalFontParameters(LOGFONT *lplf)
{
	OBJ newArray, t;
	OBJ s;

	DPRINTF((" lfHeight          %d\n", lplf->lfHeight ));
	DPRINTF((" lfWidth           %d\n", lplf->lfWidth  ));
	DPRINTF((" lfEscapement      %d\n", lplf->lfEscapement  ));
	DPRINTF((" lfOrientation     %d\n", lplf->lfOrientation  ));
	DPRINTF((" lfWeight          %d\n", lplf->lfWeight  ));
	DPRINTF((" lfItalic          %d\n", lplf->lfItalic  ));
	DPRINTF((" lfUnderline       %d\n", lplf->lfUnderline  ));
	DPRINTF((" lfStrikeOut       %d\n", lplf->lfStrikeOut  ));
	DPRINTF((" lfCharSet         %d\n", lplf->lfCharSet  ));
	DPRINTF((" lfOutPrecision    %d\n", lplf->lfOutPrecision  ));
	DPRINTF((" lfClipPrecision   %d\n", lplf->lfClipPrecision  ));
	DPRINTF((" lfQuality         %d\n", lplf->lfQuality  ));
	DPRINTF((" lfPitchAndFamily  %d\n", lplf->lfPitchAndFamily  ));
	DPRINTF((" lfFaceName        %s\n\n", lplf->lfFaceName  ));

	newArray = __ARRAY_NEW_INT(20);

	__ArrayInstPtr(newArray)->a_element[0] = __MKSMALLINT(lplf->lfHeight);
	__ArrayInstPtr(newArray)->a_element[1] = __MKSMALLINT(lplf->lfWidth);
	__ArrayInstPtr(newArray)->a_element[2] = __MKSMALLINT(lplf->lfEscapement);
	__ArrayInstPtr(newArray)->a_element[3] = __MKSMALLINT(lplf->lfOrientation);
	__ArrayInstPtr(newArray)->a_element[4] = __MKSMALLINT(lplf->lfWeight);
	switch (lplf->lfWeight) {
	    case FW_HEAVY:
	    case FW_EXTRABOLD:
	    case FW_SEMIBOLD:
	    case FW_BOLD:
		s = @symbol(bold);
		break;
	    case FW_NORMAL:
#if 0
		s = @symbol(normal);
		break;
#endif
	    case FW_MEDIUM:
		s = @symbol(medium);
		break;
	    case FW_THIN:
	    case FW_EXTRALIGHT:
	    case FW_LIGHT:
		s = @symbol(demi);
		break;
	    default:
		s = @symbol(other);
		break;
	}
	__ArrayInstPtr(newArray)->a_element[5] = s; __STORE(newArray, s);
	__ArrayInstPtr(newArray)->a_element[6] = __MKSMALLINT(lplf->lfItalic);
	__ArrayInstPtr(newArray)->a_element[7] = __MKSMALLINT(lplf->lfUnderline);
	__ArrayInstPtr(newArray)->a_element[8] = __MKSMALLINT(lplf->lfStrikeOut);
	__ArrayInstPtr(newArray)->a_element[9] = __MKSMALLINT(lplf->lfCharSet);
	__ArrayInstPtr(newArray)->a_element[10] = __MKSMALLINT(lplf->lfOutPrecision);
	__ArrayInstPtr(newArray)->a_element[11] = __MKSMALLINT(lplf->lfClipPrecision);
	__ArrayInstPtr(newArray)->a_element[12] = __MKSMALLINT(lplf->lfQuality);
	__ArrayInstPtr(newArray)->a_element[13] = __MKSMALLINT(lplf->lfPitchAndFamily);
	/* ... */

	if( lplf->lfItalic == TRUE ) {
	    if( lplf->lfUnderline == TRUE ) {
		if( lplf->lfStrikeOut == TRUE ) {
		    s = @symbol('italic-underline-strikeOut');
		} else {
		    s = @symbol('italic-underline');
		}
	    } else {
		if( lplf->lfStrikeOut == TRUE ) {
		    s = @symbol('italic-strikeOut');
		} else {
		    s = @symbol('italic');
		}
	    }
	} else {
	    if( lplf->lfUnderline == TRUE ) {
		if( lplf->lfStrikeOut == TRUE ) {
		    s = @symbol('roman-underline-strikeOut');
		} else {
		    s = @symbol('roman-underline');
		}
	    } else {
		if( lplf->lfStrikeOut == TRUE ) {
		    s = @symbol('roman-strikeOut');
		} else {
		    s = @symbol('roman');
		}
	    }
	}
	__ArrayInstPtr(newArray)->a_element[14] = s; __STORE(newArray, s);

	__PROTECT__(newArray);
	t = __MKSTRING(lplf->lfFaceName);
	__UNPROTECT__(newArray);
	__ArrayInstPtr(newArray)->a_element[15] = t; __STORE(newArray, t);

	t = __charSetSymbolFor(lplf->lfCharSet);
	__ArrayInstPtr(newArray)->a_element[16] = t; __STORE(newArray, t);

	return newArray;
}


static int CALLBACK
EnumFontsProc(
    const LOGFONTTYPE *lplf,   // ptr to of logical-font data
    const TEXTMETRIC *lptm,    // ptr to physical font data
    DWORD dwType,              // font type
    LPARAM lpData              // application supplied data
) {
	volatile OBJ *refToList;
	OBJ list;
	OBJ infoArray;
	OBJ *fullName;

	DPRINTF(("EnumFontsProc\n"));

	if ( lplf ) {
	    refToList = (OBJ *) lpData;

	    __PROTECT__(*refToList);
#ifdef USE_EnumFontFamiliesEx
	    infoArray = __extractLogicalFontParameters(lplf->elfLogFont);
	    __PROTECT__(infoArray);
	    fullName = __MKSTRING(lplf->elfFullName);
	    __UNPROTECT__(infoArray);
	    __ArrayInstPtr(infoArray)->a_element[17] = fullName; __STORE(infoArray, fullName);
#else
	    infoArray = __extractLogicalFontParameters(lplf);
#endif

	    __UNPROTECT__(*refToList);

	    if ( dwType & TRUETYPE_FONTTYPE ) {
		/* change height to 0 to mark variable fonts */
		__ArrayInstPtr(infoArray)->a_element[0] = __MKSMALLINT(0);
	    }
	    list = *refToList;
	    __SSEND1(list, @symbol(add:), 0, infoArray);
	}
	return 1;
}

struct EnumDisplayMonitorsProcData {
    OBJ hArray;
    int index;
};

static int CALLBACK
EnumDisplayMonitorsProc(HMONITOR hMonitor, HDC hdcMonitor, LPRECT lprcMonitor, LPARAM lpData)
{
    struct EnumDisplayMonitorsProcData *procData = (struct EnumDisplayMonitorsProcData *)lpData;
    OBJ mHandle;

    __PROTECT__(procData->hArray);
    mHandle = __MKEXTERNALADDRESS(hMonitor);
    __UNPROTECT__(procData->hArray);

    __arrayVal(procData->hArray)[procData->index++] = mHandle;
    __STORE(procData->hArray, mHandle);
    return (1);
}

%}
! !

!WinWorkstation class methodsFor:'documentation'!

copyright
"
COPYRIGHT (c) 1996 by Claus Gittinger
COPYRIGHT (c) 2017-2018 Patrik Svestka
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
    See more documentation in my superclass, DeviceWorkstation.

    [author:]
	Claus Gittinger (initial port & final fixups)
	Manfred Dierolf (many, many changes & fixes, multithreading etc.)
"
! !

!WinWorkstation class methodsFor:'initialization'!

initialize
    "/ super initialize.
    self initializeStandardColorNames.

    NativeWidgets := NativeDialogs := NativeFileDialogs := false.
    BeepDuration := 200.        "milliseconds"
    ButtonTranslation := #(1 2 2).

    "/ SysColorChanges are reported *very* often when exceed is running,
    "/ but are also needed to update my view colors when the settings change.
    "/ I don't know what exceed is doing there ...
    "/ IgnoreSysColorChanges := true.
    IgnoreSysColorChanges := false.
    SystemColorValues := IdentityDictionary new.

    "/ translation table from ST/X windowType symbol (system-independent)
    "/ to Windows windowClass (windows-specific).

    NativeWidgetClassTable := IdentityDictionary
	withKeysAndValues:#(
		ScrollBar                 SCROLLBAR
		HorizontalScrollBar       SCROLLBAR
		VerticalScrollBar         SCROLLBAR
		CheckBox                  BUTTON
		RadioButton               BUTTON
		Button                    BUTTON
		DefaultButton             BUTTON
		OwnerDrawButton           BUTTON
		ComboBox                  COMBOBOX
		EditField                 EDIT
		ListBox                   LISTBOX
	).

    "Modified: / 24-08-2010 / 16:42:23 / sr"
!

initializeStandardColorNames
    "{ Pragma: +optSpace }"

    "setup standard color names (X-color names)"

    StandardColorValues := Dictionary
	withKeysAndValues:#(
	    'aliceblue'     (240 248 255)
	    'antiquewhite'  (250 235 215)
	    'AntiqueWhite1' (255 239 219)
	    'AntiqueWhite2' (238 223 204)
	    'AntiqueWhite3' (205 192 176)
	    'AntiqueWhite4' (139 131 120)
	    'aquamarine'    (127 255 212)
	    'aquamarine1'   (127 255 212)
	    'aquamarine2'   (118 238 198)
	    'aquamarine3'   (102 205 170)
	    'aquamarine4'   (69 139 116)
	    'azure'         (240 255 255)
	    'azure1'        (240 255 255)
	    'azure2'        (224 238 238)
	    'azure3'        (193 205 205)
	    'azure4'        (131 139 139)
	    'beige'         (245 245 220)
	    'bisque'        (255 228 196)
	    'bisque1'       (255 228 196)
	    'bisque2'       (238 213 183)
	    'bisque3'       (205 183 158)
	    'bisque4'       (139 125 107)
	    'black'         (0 0 0)
	    'blanchedalmond'        (255 235 205)
	    'blue'          (0 0 255)
	    'blueviolet'    (138 43 226)
	    'blue1'         (0 0 255)
	    'blue2'         (0 0 238)
	    'blue3'         (0 0 205)
	    'blue4'         (0 0 139)
	    'brown'         (165 42 42)
	    'brown1'        (255 64 64)
	    'brown2'        (238 59 59)
	    'brown3'        (205 51 51)
	    'brown4'        (139 35 35)
	    'burlywood'     (222 184 135)
	    'burlywood1'    (255 211 155)
	    'burlywood2'    (238 197 145)
	    'burlywood3'    (205 170 125)
	    'burlywood4'    (139 115 85)
	    'cadetblue'     (95 158 160)
	    'CadetBlue1'    (152 245 255)
	    'CadetBlue2'    (142 229 238)
	    'CadetBlue3'    (122 197 205)
	    'CadetBlue4'    (83 134 139)
	    'chartreuse'    (127 255 0)
	    'chartreuse1'   (127 255 0)
	    'chartreuse2'   (118 238 0)
	    'chartreuse3'   (102 205 0)
	    'chartreuse4'   (69 139 0)
	    'chocolate'     (210 105 30)
	    'chocolate1'    (255 127 36)
	    'chocolate2'    (238 118 33)
	    'chocolate3'    (205 102 29)
	    'chocolate4'    (139 69 19)
	    'coral'         (255 127 80)
	    'coral1'        (255 114 86)
	    'coral2'        (238 106 80)
	    'coral3'        (205 91 69)
	    'coral4'        (139 62 47)
	    'cornflowerblue'        (100 149 237)
	    'cornsilk'      (255 248 220)
	    'cornsilk1'     (255 248 220)
	    'cornsilk2'     (238 232 205)
	    'cornsilk3'     (205 200 177)
	    'cornsilk4'     (139 136 120)
	    'cyan'          (0 255 255)
	    'cyan1'         (0 255 255)
	    'cyan2'         (0 238 238)
	    'cyan3'         (0 205 205)
	    'cyan4'         (0 139 139)
	    'darkblue'      (0 0 139)
	    'darkcyan'      (0 139 139)
	    'darkgoldenrod' (184 134 11)
	    'darkgray'      (169 169 169)
	    'darkgreen'     (0 100 0)
	    'darkgrey'      (169 169 169)
	    'darkkhaki'     (189 183 107)
	    'darkmagenta'   (139 0 139)
	    'darkolivegreen'        (85 107 47)
	    'darkorange'    (255 140 0)
	    'darkorchid'    (153 50 204)
	    'darkred'       (139 0 0)
	    'darksalmon'    (233 150 122)
	    'darkseagreen'  (143 188 143)
	    'darkslateblue' (72 61 139)
	    'darkslategray' (47 79 79)
	    'darkslategrey' (47 79 79)
	    'darkturquoise' (0 206 209)
	    'darkviolet'    (148 0 211)
	    'DarkGoldenrod1'        (255 185 15)
	    'DarkGoldenrod2'        (238 173 14)
	    'DarkGoldenrod3'        (205 149 12)
	    'DarkGoldenrod4'        (139 101 8)
	    'DarkOliveGreen1'       (202 255 112)
	    'DarkOliveGreen2'       (188 238 104)
	    'DarkOliveGreen3'       (162 205 90)
	    'DarkOliveGreen4'       (110 139 61)
	    'DarkOrange1'   (255 127 0)
	    'DarkOrange2'   (238 118 0)
	    'DarkOrange3'   (205 102 0)
	    'DarkOrange4'   (139 69 0)
	    'DarkOrchid1'   (191 62 255)
	    'DarkOrchid2'   (178 58 238)
	    'DarkOrchid3'   (154 50 205)
	    'DarkOrchid4'   (104 34 139)
	    'DarkSeaGreen1' (193 255 193)
	    'DarkSeaGreen2' (180 238 180)
	    'DarkSeaGreen3' (155 205 155)
	    'DarkSeaGreen4' (105 139 105)
	    'DarkSlateGray1'        (151 255 255)
	    'DarkSlateGray2'        (141 238 238)
	    'DarkSlateGray3'        (121 205 205)
	    'DarkSlateGray4'        (82 139 139)
	    'deeppink'      (255 20 147)
	    'deepskyblue'   (0 191 255)
	    'DeepPink'      (255 20 147)
	    'DeepPink1'     (255 20 147)
	    'DeepPink2'     (238 18 137)
	    'DeepPink3'     (205 16 118)
	    'DeepPink4'     (139 10 80)
	    'DeepSkyBlue1'  (0 191 255)
	    'DeepSkyBlue2'  (0 178 238)
	    'DeepSkyBlue3'  (0 154 205)
	    'DeepSkyBlue4'  (0 104 139)
	    'dimgray'       (105 105 105)
	    'dimgrey'       (105 105 105)
	    'dodgerblue'    (30 144 255)
	    'DodgerBlue1'   (30 144 255)
	    'DodgerBlue2'   (28 134 238)
	    'DodgerBlue3'   (24 116 205)
	    'DodgerBlue4'   (16 78 139)
	    'firebrick'     (178 34 34)
	    'firebrick1'    (255 48 48)
	    'firebrick2'    (238 44 44)
	    'firebrick3'    (205 38 38)
	    'firebrick4'    (139 26 26)
	    'floralwhite'   (255 250 240)
	    'forestgreen'   (34 139 34)
	    'gainsboro'     (220 220 220)
	    'ghostwhite'    (248 248 255)
	    'gold'          (255 215 0)
	    'gold1'         (255 215 0)
	    'gold2'         (238 201 0)
	    'gold3'         (205 173 0)
	    'gold4'         (139 117 0)
	    'goldenrod'     (218 165 32)
	    'goldenrod1'    (255 193 37)
	    'goldenrod2'    (238 180 34)
	    'goldenrod3'    (205 155 29)
	    'goldenrod4'    (139 105 20)
	    'grey'          (192 192 192)
	    'grey0'         (0 0 0)
	    'grey1'         (3 3 3)
	    'grey10'        (26 26 26)
	    'grey100'       (255 255 255)
	    'grey11'        (28 28 28)
	    'grey12'        (31 31 31)
	    'grey13'        (33 33 33)
	    'grey14'        (36 36 36)
	    'grey15'        (38 38 38)
	    'grey16'        (41 41 41)
	    'grey17'        (43 43 43)
	    'grey18'        (46 46 46)
	    'grey19'        (48 48 48)
	    'grey2'         (5 5 5)
	    'grey20'        (51 51 51)
	    'grey21'        (54 54 54)
	    'grey22'        (56 56 56)
	    'grey23'        (59 59 59)
	    'grey24'        (61 61 61)
	    'grey25'        (64 64 64)
	    'grey26'        (66 66 66)
	    'grey27'        (69 69 69)
	    'grey28'        (71 71 71)
	    'grey29'        (74 74 74)
	    'grey3'         (8 8 8)
	    'grey30'        (77 77 77)
	    'grey31'        (79 79 79)
	    'grey32'        (82 82 82)
	    'grey33'        (84 84 84)
	    'grey34'        (87 87 87)
	    'grey35'        (89 89 89)
	    'grey36'        (92 92 92)
	    'grey37'        (94 94 94)
	    'grey38'        (97 97 97)
	    'grey39'        (99 99 99)
	    'grey4'         (10 10 10)
	    'grey40'        (102 102 102)
	    'grey41'        (105 105 105)
	    'grey42'        (107 107 107)
	    'grey43'        (110 110 110)
	    'grey44'        (112 112 112)
	    'grey45'        (115 115 115)
	    'grey46'        (117 117 117)
	    'grey47'        (120 120 120)
	    'grey48'        (122 122 122)
	    'grey49'        (125 125 125)
	    'grey5'         (13 13 13)
	    'grey50'        (127 127 127)
	    'grey51'        (130 130 130)
	    'grey52'        (133 133 133)
	    'grey53'        (135 135 135)
	    'grey54'        (138 138 138)
	    'grey55'        (140 140 140)
	    'grey56'        (143 143 143)
	    'grey57'        (145 145 145)
	    'grey58'        (148 148 148)
	    'grey59'        (150 150 150)
	    'grey6'         (15 15 15)
	    'grey60'        (153 153 153)
	    'grey61'        (156 156 156)
	    'grey62'        (158 158 158)
	    'grey63'        (161 161 161)
	    'grey64'        (163 163 163)
	    'grey65'        (166 166 166)
	    'grey66'        (168 168 168)
	    'grey67'        (171 171 171)
	    'grey68'        (173 173 173)
	    'grey69'        (176 176 176)
	    'grey7'         (18 18 18)
	    'grey70'        (179 179 179)
	    'grey71'        (181 181 181)
	    'grey72'        (184 184 184)
	    'grey73'        (186 186 186)
	    'grey74'        (189 189 189)
	    'grey75'        (191 191 191)
	    'grey76'        (194 194 194)
	    'grey77'        (196 196 196)
	    'grey78'        (199 199 199)
	    'grey79'        (201 201 201)
	    'grey8'         (20 20 20)
	    'grey80'        (204 204 204)
	    'grey81'        (207 207 207)
	    'grey82'        (209 209 209)
	    'grey83'        (212 212 212)
	    'grey84'        (214 214 214)
	    'grey85'        (217 217 217)
	    'grey86'        (219 219 219)
	    'grey87'        (222 222 222)
	    'grey88'        (224 224 224)
	    'grey89'        (227 227 227)
	    'grey9'         (23 23 23)
	    'grey90'        (229 229 229)
	    'grey91'        (232 232 232)
	    'grey92'        (235 235 235)
	    'grey93'        (237 237 237)
	    'grey94'        (240 240 240)
	    'grey95'        (242 242 242)
	    'grey96'        (245 245 245)
	    'grey97'        (247 247 247)
	    'grey98'        (250 250 250)
	    'grey99'        (252 252 252)
	    'gray'          (192 192 192)
	    'gray0'         (0 0 0)
	    'gray1'         (3 3 3)
	    'gray10'        (26 26 26)
	    'gray100'       (255 255 255)
	    'gray11'        (28 28 28)
	    'gray12'        (31 31 31)
	    'gray13'        (33 33 33)
	    'gray14'        (36 36 36)
	    'gray15'        (38 38 38)
	    'gray16'        (41 41 41)
	    'gray17'        (43 43 43)
	    'gray18'        (46 46 46)
	    'gray19'        (48 48 48)
	    'gray2'         (5 5 5)
	    'gray20'        (51 51 51)
	    'gray21'        (54 54 54)
	    'gray22'        (56 56 56)
	    'gray23'        (59 59 59)
	    'gray24'        (61 61 61)
	    'gray25'        (64 64 64)
	    'gray26'        (66 66 66)
	    'gray27'        (69 69 69)
	    'gray28'        (71 71 71)
	    'gray29'        (74 74 74)
	    'gray3'         (8 8 8)
	    'gray30'        (77 77 77)
	    'gray31'        (79 79 79)
	    'gray32'        (82 82 82)
	    'gray33'        (84 84 84)
	    'gray34'        (87 87 87)
	    'gray35'        (89 89 89)
	    'gray36'        (92 92 92)
	    'gray37'        (94 94 94)
	    'gray38'        (97 97 97)
	    'gray39'        (99 99 99)
	    'gray4'         (10 10 10)
	    'gray40'        (102 102 102)
	    'gray41'        (105 105 105)
	    'gray42'        (107 107 107)
	    'gray43'        (110 110 110)
	    'gray44'        (112 112 112)
	    'gray45'        (115 115 115)
	    'gray46'        (117 117 117)
	    'gray47'        (120 120 120)
	    'gray48'        (122 122 122)
	    'gray49'        (125 125 125)
	    'gray5'         (13 13 13)
	    'gray50'        (127 127 127)
	    'gray51'        (130 130 130)
	    'gray52'        (133 133 133)
	    'gray53'        (135 135 135)
	    'gray54'        (138 138 138)
	    'gray55'        (140 140 140)
	    'gray56'        (143 143 143)
	    'gray57'        (145 145 145)
	    'gray58'        (148 148 148)
	    'gray59'        (150 150 150)
	    'gray6'         (15 15 15)
	    'gray60'        (153 153 153)
	    'gray61'        (156 156 156)
	    'gray62'        (158 158 158)
	    'gray63'        (161 161 161)
	    'gray64'        (163 163 163)
	    'gray65'        (166 166 166)
	    'gray66'        (168 168 168)
	    'gray67'        (171 171 171)
	    'gray68'        (173 173 173)
	    'gray69'        (176 176 176)
	    'gray7'         (18 18 18)
	    'gray70'        (179 179 179)
	    'gray71'        (181 181 181)
	    'gray72'        (184 184 184)
	    'gray73'        (186 186 186)
	    'gray74'        (189 189 189)
	    'gray75'        (191 191 191)
	    'gray76'        (194 194 194)
	    'gray77'        (196 196 196)
	    'gray78'        (199 199 199)
	    'gray79'        (201 201 201)
	    'gray8'         (20 20 20)
	    'gray80'        (204 204 204)
	    'gray81'        (207 207 207)
	    'gray82'        (209 209 209)
	    'gray83'        (212 212 212)
	    'gray84'        (214 214 214)
	    'gray85'        (217 217 217)
	    'gray86'        (219 219 219)
	    'gray87'        (222 222 222)
	    'gray88'        (224 224 224)
	    'gray89'        (227 227 227)
	    'gray9'         (23 23 23)
	    'gray90'        (229 229 229)
	    'gray91'        (232 232 232)
	    'gray92'        (235 235 235)
	    'gray93'        (237 237 237)
	    'gray94'        (240 240 240)
	    'gray95'        (242 242 242)
	    'gray96'        (245 245 245)
	    'gray97'        (247 247 247)
	    'gray98'        (250 250 250)
	    'gray99'        (252 252 252)
	    'green'         (0 255 0)
	    'greenyellow'   (173 255 47)
	    'green1'        (0 255 0)
	    'green2'        (0 238 0)
	    'green3'        (0 205 0)
	    'green4'        (0 139 0)
	    'honeydew'      (240 255 240)
	    'honeydew1'     (240 255 240)
	    'honeydew2'     (224 238 224)
	    'honeydew3'     (193 205 193)
	    'honeydew4'     (131 139 131)
	    'hotpink'       (255 105 180)
	    'HotPink1'      (255 110 180)
	    'HotPink2'      (238 106 167)
	    'HotPink3'      (205 96 144)
	    'HotPink4'      (139 58 98)
	    'indianred'     (205 92 92)
	    'IndianRed1'    (255 106 106)
	    'IndianRed2'    (238 99 99)
	    'IndianRed3'    (205 85 85)
	    'IndianRed4'    (139 58 58)
	    'ivory'         (255 255 240)
	    'ivory1'        (255 255 240)
	    'ivory2'        (238 238 224)
	    'ivory3'        (205 205 193)
	    'ivory4'        (139 139 131)
	    'khaki'         (240 230 140)
	    'khaki1'        (255 246 143)
	    'khaki2'        (238 230 133)
	    'khaki3'        (205 198 115)
	    'khaki4'        (139 134 78)
	    'lavender'      (230 230 250)
	    'lavenderblush'         (255 240 245)
	    'LavenderBlush1'        (255 240 245)
	    'LavenderBlush2'        (238 224 229)
	    'LavenderBlush3'        (205 193 197)
	    'LavenderBlush4'        (139 131 134)
	    'lawngreen'     (124 252 0)
	    'lemonchiffon'  (255 250 205)
	    'LemonChiffon1'         (255 250 205)
	    'LemonChiffon2'         (238 233 191)
	    'LemonChiffon3'         (205 201 165)
	    'LemonChiffon4'         (139 137 112)
	    'lightblue'     (173 216 230)
	    'lightcoral'    (240 128 128)
	    'lightcyan'     (224 255 255)
	    'lightgoldenrod'        (238 221 130)
	    'lightgoldenrodyellow'  (250 250 210)
	    'lightgray'     (211 211 211)
	    'lightgreen'    (144 238 144)
	    'lightgrey'     (211 211 211)
	    'lightpink'     (255 182 193)
	    'lightsalmon'   (255 160 122)
	    'lightseagreen' (32 178 170)
	    'lightskyblue'  (135 206 250)
	    'lightslateblue'        (132 112 255)
	    'lightslategray'        (119 136 153)
	    'lightslategrey'        (119 136 153)
	    'lightsteelblue'        (176 196 222)
	    'lightyellow'   (255 255 224)
	    'LightBlue1'    (191 239 255)
	    'LightBlue2'    (178 223 238)
	    'LightBlue3'    (154 192 205)
	    'LightBlue4'    (104 131 139)
	    'LightCyan1'    (224 255 255)
	    'LightCyan2'    (209 238 238)
	    'LightCyan3'    (180 205 205)
	    'LightCyan4'    (122 139 139)
	    'LightGoldenrod1'       (255 236 139)
	    'LightGoldenrod2'       (238 220 130)
	    'LightGoldenrod3'       (205 190 112)
	    'LightGoldenrod4'       (139 129 76)
	    'LightPink1'    (255 174 185)
	    'LightPink2'    (238 162 173)
	    'LightPink3'    (205 140 149)
	    'LightPink4'    (139 95 101)
	    'LightSalmon1'  (255 160 122)
	    'LightSalmon2'  (238 149 114)
	    'LightSalmon3'  (205 129 98)
	    'LightSalmon4'  (139 87 66)
	    'LightSkyBlue1'         (176 226 255)
	    'LightSkyBlue2'         (164 211 238)
	    'LightSkyBlue3'         (141 182 205)
	    'LightSkyBlue4'         (96 123 139)
	    'LightSteelBlue1'       (202 225 255)
	    'LightSteelBlue2'       (188 210 238)
	    'LightSteelBlue3'       (162 181 205)
	    'LightSteelBlue4'       (110 123 139)
	    'LightYellow1'  (255 255 224)
	    'LightYellow2'  (238 238 209)
	    'LightYellow3'  (205 205 180)
	    'LightYellow4'  (139 139 122)
	    'limegreen'     (50 205 50)
	    'linen'         (250 240 230)
	    'magenta'       (255 0 255)
	    'magenta1'      (255 0 255)
	    'magenta2'      (238 0 238)
	    'magenta3'      (205 0 205)
	    'magenta4'      (139 0 139)
	    'maroon'        (176 48 96)
	    'maroon1'       (255 52 179)
	    'maroon2'       (238 48 167)
	    'maroon3'       (205 41 144)
	    'maroon4'       (139 28 98)
	    'mediumaquamarine'      (102 205 170)
	    'mediumblue'    (0 0 205)
	    'mediumorchid'  (186 85 211)
	    'mediumpurple'  (147 112 219)
	    'mediumseagreen'        (60 179 113)
	    'mediumslateblue'       (123 104 238)
	    'mediumspringgreen'     (0 250 154)
	    'mediumturquoise'       (72 209 204)
	    'mediumvioletred'       (199 21 133)
	    'MediumOrchid1'         (224 102 255)
	    'MediumOrchid2' (209 95 238)
	    'MediumOrchid3' (180 82 205)
	    'MediumOrchid4' (122 55 139)
	    'MediumPurple1' (171 130 255)
	    'MediumPurple2' (159 121 238)
	    'MediumPurple3' (137 104 205)
	    'MediumPurple4' (93 71 139)
	    'midnightblue'  (25 25 112)
	    'mintcream'     (245 255 250)
	    'mistyrose'     (255 228 225)
	    'MistyRose1'    (255 228 225)
	    'MistyRose2'    (238 213 210)
	    'MistyRose3'    (205 183 181)
	    'MistyRose4'    (139 125 123)
	    'moccasin'      (255 228 181)
	    'navajowhite'   (255 222 173)
	    'NavajoWhite1'  (255 222 173)
	    'NavajoWhite2'  (238 207 161)
	    'NavajoWhite3'  (205 179 139)
	    'NavajoWhite4'  (139 121 94)
	    'navy'          (0 0 128)
	    'navyblue'      (0 0 128)
	    'oldlace'       (253 245 230)
	    'olivedrab'     (107 142 35)
	    'OliveDrab1'    (192 255 62)
	    'OliveDrab2'    (179 238 58)
	    'OliveDrab3'    (154 205 50)
	    'OliveDrab4'    (105 139 34)
	    'orange'        (255 165 0)
	    'orange1'       (255 165 0)
	    'orange2'       (238 154 0)
	    'orange3'       (205 133 0)
	    'orange4'       (139 90 0)
	    'orangered'     (255 69 0)
	    'OrangeRed1'    (255 69 0)
	    'OrangeRed2'    (238 64 0)
	    'OrangeRed3'    (205 55 0)
	    'OrangeRed4'    (139 37 0)
	    'orchid'        (218 112 214)
	    'orchid1'       (255 131 250)
	    'orchid2'       (238 122 233)
	    'orchid3'       (205 105 201)
	    'orchid4'       (139 71 137)
	    'palegoldenrod' (238 232 170)
	    'palegreen'     (152 251 152)
	    'paleturquoise' (175 238 238)
	    'palevioletred' (219 112 147)
	    'PaleGreen1'    (154 255 154)
	    'PaleGreen2'    (144 238 144)
	    'PaleGreen3'    (124 205 124)
	    'PaleGreen4'    (84 139 84)
	    'PaleTurquoise1'        (187 255 255)
	    'PaleTurquoise2'        (174 238 238)
	    'PaleTurquoise3'        (150 205 205)
	    'PaleTurquoise4'        (102 139 139)
	    'PaleVioletRed1'        (255 130 171)
	    'PaleVioletRed2'        (238 121 159)
	    'PaleVioletRed3'        (205 104 137)
	    'PaleVioletRed4'        (139 71 93)
	    'papayawhip'    (255 239 213)
	    'peachpuff'     (255 218 185)
	    'PeachPuff1'    (255 218 185)
	    'PeachPuff2'    (238 203 173)
	    'PeachPuff3'    (205 175 149)
	    'PeachPuff4'    (139 119 101)
	    'peru'  (205 133 63)
	    'pink'  (255 192 203)
	    'pink1' (255 181 197)
	    'pink2' (238 169 184)
	    'pink3' (205 145 158)
	    'pink4' (139 99 108)
	    'plum'  (221 160 221)
	    'plum1' (255 187 255)
	    'plum2' (238 174 238)
	    'plum3' (205 150 205)
	    'plum4' (139 102 139)
	    'powderblue'    (176 224 230)
	    'purple'        (160 32 240)
	    'purple1'       (155 48 255)
	    'purple2'       (145 44 238)
	    'purple3'       (125 38 205)
	    'purple4'       (85 26 139)
	    'red'   (255 0 0)
	    'red1'  (255 0 0)
	    'red2'  (238 0 0)
	    'red3'  (205 0 0)
	    'red4'  (139 0 0)
	    'rosybrown'     (188 143 143)
	    'RosyBrown1'    (255 193 193)
	    'RosyBrown2'    (238 180 180)
	    'RosyBrown3'    (205 155 155)
	    'RosyBrown4'    (139 105 105)
	    'royalblue'     (65 105 225)
	    'RoyalBlue1'    (72 118 255)
	    'RoyalBlue2'    (67 110 238)
	    'RoyalBlue3'    (58 95 205)
	    'RoyalBlue4'    (39 64 139)
	    'saddlebrown'   (139 69 19)
	    'salmon'        (250 128 114)
	    'salmon1'       (255 140 105)
	    'salmon2'       (238 130 98)
	    'salmon3'       (205 112 84)
	    'salmon4'       (139 76 57)
	    'sandybrown'    (244 164 96)
	    'scoActiveBackground'   (255 206 137)
	    'scoActiveForeground'   (43 45 49)
	    'scoActiveTopShadow'    (254 222 255)
	    'scoAltBackground'      (172 186 204)
	    'scoBackground' (203 203 192)
	    'scoForeground' (11 0 113)
	    'scoHighlight'  (141 178 215)
	    'scoTopShadow'  (255 240 248)
	    'seagreen'      (46 139 87)
	    'SeaGreen1'     (84 255 159)
	    'SeaGreen2'     (78 238 148)
	    'SeaGreen3'     (67 205 128)
	    'SeaGreen4'     (46 139 87)
	    'seashell'      (255 245 238)
	    'seashell1'     (255 245 238)
	    'seashell2'     (238 229 222)
	    'seashell3'     (205 197 191)
	    'seashell4'     (139 134 130)
	    'sgi beet'      (142 56 142)
	    'sgi bright gray'       (197 193 170)
	    'sgi bright grey'       (197 193 170)
	    'sgi chartreuse'        (113 198 113)
	    'sgi dark gray' (85 85 85)
	    'sgi dark grey' (85 85 85)
	    'sgi gray 0'    (0 0 0)
	    'sgi gray 100'  (255 255 255)
	    'sgi gray 12'   (30 30 30)
	    'sgi gray 16'   (40 40 40)
	    'sgi gray 20'   (51 51 51)
	    'sgi gray 24'   (61 61 61)
	    'sgi gray 28'   (71 71 71)
	    'sgi gray 32'   (81 81 81)
	    'sgi gray 36'   (91 91 91)
	    'sgi gray 4'    (10 10 10)
	    'sgi gray 40'   (102 102 102)
	    'sgi gray 44'   (112 112 112)
	    'sgi gray 48'   (122 122 122)
	    'sgi gray 52'   (132 132 132)
	    'sgi gray 56'   (142 142 142)
	    'sgi gray 60'   (153 153 153)
	    'sgi gray 64'   (163 163 163)
	    'sgi gray 68'   (173 173 173)
	    'sgi gray 72'   (183 183 183)
	    'sgi gray 76'   (193 193 193)
	    'sgi gray 8'    (20 20 20)
	    'sgi gray 80'   (204 204 204)
	    'sgi gray 84'   (214 214 214)
	    'sgi gray 88'   (224 224 224)
	    'sgi gray 92'   (234 234 234)
	    'sgi gray 96'   (244 244 244)
	    'sgi grey 0'    (0 0 0)
	    'sgi grey 100'  (255 255 255)
	    'sgi grey 12'   (30 30 30)
	    'sgi grey 16'   (40 40 40)
	    'sgi grey 20'   (51 51 51)
	    'sgi grey 24'   (61 61 61)
	    'sgi grey 28'   (71 71 71)
	    'sgi grey 32'   (81 81 81)
	    'sgi grey 36'   (91 91 91)
	    'sgi grey 4'    (10 10 10)
	    'sgi grey 40'   (102 102 102)
	    'sgi grey 44'   (112 112 112)
	    'sgi grey 48'   (122 122 122)
	    'sgi grey 52'   (132 132 132)
	    'sgi grey 56'   (142 142 142)
	    'sgi grey 60'   (153 153 153)
	    'sgi grey 64'   (163 163 163)
	    'sgi grey 68'   (173 173 173)
	    'sgi grey 72'   (183 183 183)
	    'sgi grey 76'   (193 193 193)
	    'sgi grey 8'    (20 20 20)
	    'sgi grey 80'   (204 204 204)
	    'sgi grey 84'   (214 214 214)
	    'sgi grey 88'   (224 224 224)
	    'sgi grey 92'   (234 234 234)
	    'sgi grey 96'   (244 244 244)
	    'sgi light blue'        (125 158 192)
	    'sgi light gray'        (170 170 170)
	    'sgi light grey'        (170 170 170)
	    'sgi medium gray'       (132 132 132)
	    'sgi medium grey'       (132 132 132)
	    'sgi olive drab'        (142 142 56)
	    'sgi salmon'    (198 113 113)
	    'sgi slate blue'        (113 113 198)
	    'sgi teal'      (56 142 142)
	    'sgi very dark gray'    (40 40 40)
	    'sgi very dark grey'    (40 40 40)
	    'sgi very light gray'   (214 214 214)
	    'sgi very light grey'   (214 214 214)
	    'SGIBeet'       (142 56 142)
	    'SGIBrightGray' (197 193 170)
	    'SGIBrightGrey' (197 193 170)
	    'SGIChartreuse' (113 198 113)
	    'SGIDarkGray'   (85 85 85)
	    'SGIDarkGrey'   (85 85 85)
	    'SGIGray0'      (0 0 0)
	    'SGIGray100'    (255 255 255)
	    'SGIGray12'     (30 30 30)
	    'SGIGray16'     (40 40 40)
	    'SGIGray20'     (51 51 51)
	    'SGIGray24'     (61 61 61)
	    'SGIGray28'     (71 71 71)
	    'SGIGray32'     (81 81 81)
	    'SGIGray36'     (91 91 91)
	    'SGIGray4'      (10 10 10)
	    'SGIGray40'     (102 102 102)
	    'SGIGray44'     (112 112 112)
	    'SGIGray48'     (122 122 122)
	    'SGIGray52'     (132 132 132)
	    'SGIGray56'     (142 142 142)
	    'SGIGray60'     (153 153 153)
	    'SGIGray64'     (163 163 163)
	    'SGIGray68'     (173 173 173)
	    'SGIGray72'     (183 183 183)
	    'SGIGray76'     (193 193 193)
	    'SGIGray8'      (20 20 20)
	    'SGIGray80'     (204 204 204)
	    'SGIGray84'     (214 214 214)
	    'SGIGray88'     (224 224 224)
	    'SGIGray92'     (234 234 234)
	    'SGIGray96'     (244 244 244)
	    'SGIGrey0'      (0 0 0)
	    'SGIGrey100'    (255 255 255)
	    'SGIGrey12'     (30 30 30)
	    'SGIGrey16'     (40 40 40)
	    'SGIGrey20'     (51 51 51)
	    'SGIGrey24'     (61 61 61)
	    'SGIGrey28'     (71 71 71)
	    'SGIGrey32'     (81 81 81)
	    'SGIGrey36'     (91 91 91)
	    'SGIGrey4'      (10 10 10)
	    'SGIGrey40'     (102 102 102)
	    'SGIGrey44'     (112 112 112)
	    'SGIGrey48'     (122 122 122)
	    'SGIGrey52'     (132 132 132)
	    'SGIGrey56'     (142 142 142)
	    'SGIGrey60'     (153 153 153)
	    'SGIGrey64'     (163 163 163)
	    'SGIGrey68'     (173 173 173)
	    'SGIGrey72'     (183 183 183)
	    'SGIGrey76'     (193 193 193)
	    'SGIGrey8'      (20 20 20)
	    'SGIGrey80'     (204 204 204)
	    'SGIGrey84'     (214 214 214)
	    'SGIGrey88'     (224 224 224)
	    'SGIGrey92'     (234 234 234)
	    'SGIGrey96'     (244 244 244)
	    'SGILightBlue'  (125 158 192)
	    'SGILightGray'  (170 170 170)
	    'SGILightGrey'  (170 170 170)
	    'SGIMediumGray' (132 132 132)
	    'SGIMediumGrey' (132 132 132)
	    'SGIOliveDrab'  (142 142 56)
	    'SGISalmon'     (198 113 113)
	    'SGISlateBlue'  (113 113 198)
	    'SGITeal'       (56 142 142)
	    'SGIVeryDarkGray'       (40 40 40)
	    'SGIVeryDarkGrey'       (40 40 40)
	    'SGIVeryLightGray'      (214 214 214)
	    'SGIVeryLightGrey'      (214 214 214)
	    'sienna'        (160 82 45)
	    'sienna1'       (255 130 71)
	    'sienna2'       (238 121 66)
	    'sienna3'       (205 104 57)
	    'sienna4'       (139 71 38)
	    'skyblue'       (135 206 235)
	    'SkyBlue1'      (135 206 255)
	    'SkyBlue2'      (126 192 238)
	    'SkyBlue3'      (108 166 205)
	    'SkyBlue4'      (74 112 139)
	    'slategray'     (112 128 144)
	    'slategrey'     (112 128 144)
	    'slateblue'     (106 90 205)
	    'SlateBlue1'    (131 111 255)
	    'SlateBlue2'    (122 103 238)
	    'SlateBlue3'    (105 89 205)
	    'SlateBlue4'    (71 60 139)
	    'SlateGray1'    (198 226 255)
	    'SlateGray2'    (185 211 238)
	    'SlateGray3'    (159 182 205)
	    'SlateGray4'    (108 123 139)
	    'snow'          (255 250 250)
	    'snow1'         (255 250 250)
	    'snow2'         (238 233 233)
	    'snow3'         (205 201 201)
	    'snow4'         (139 137 137)
	    'springgreen'   (0 255 127)
	    'SpringGreen1'  (0 255 127)
	    'SpringGreen2'  (0 238 118)
	    'SpringGreen3'  (0 205 102)
	    'SpringGreen4'  (0 139 69)
	    'steelblue'     (70 130 180)
	    'SteelBlue1'    (99 184 255)
	    'SteelBlue2'    (92 172 238)
	    'SteelBlue3'    (79 148 205)
	    'SteelBlue4'    (54 100 139)
	    'tan'   (210 180 140)
	    'tan1'  (255 165 79)
	    'tan2'  (238 154 73)
	    'tan3'  (205 133 63)
	    'tan4'  (139 90 43)
	    'thistle'       (216 191 216)
	    'thistle1'      (255 225 255)
	    'thistle2'      (238 210 238)
	    'thistle3'      (205 181 205)
	    'thistle4'      (139 123 139)
	    'tomato'        (255 99 71)
	    'tomato1'       (255 99 71)
	    'tomato2'       (238 92 66)
	    'tomato3'       (205 79 57)
	    'tomato4'       (139 54 38)
	    'turquoise'     (64 224 208)
	    'turquoise1'    (0 245 255)
	    'turquoise2'    (0 229 238)
	    'turquoise3'    (0 197 205)
	    'turquoise4'    (0 134 139)
	    'violet'        (238 130 238)
	    'violetred'     (208 32 144)
	    'VioletRed1'    (255 62 150)
	    'VioletRed2'    (238 58 140)
	    'VioletRed3'    (205 50 120)
	    'VioletRed4'    (139 34 82)
	    'wheat'         (245 222 179)
	    'wheat1'        (255 231 186)
	    'wheat2'        (238 216 174)
	    'wheat3'        (205 186 150)
	    'wheat4'        (139 126 102)
	    'white'         (255 255 255)
	    'whitesmoke'    (245 245 245)
	    'yellow'        (255 255 0)
	    'yellowgreen'   (154 205 50)
	    'yellow1'       (255 255 0)
	    'yellow2'       (238 238 0)
	    'yellow3'       (205 205 0)
	    'yellow4'       (139 139 0)
	).

    "
     WinWorkstation initializeStandardColorNames
    "
! !

!WinWorkstation class methodsFor:'debugging'!

bitmapHandleCounts
    "for resource debugging only - will vanish"

%{  /* NOCONTEXT */
#ifdef COUNT_BMP_RESOURCES
    RETURN ( __MKSMALLINT(__cnt_bitmap));
#else
    RETURN (nil);
#endif
%}
!

cursorHandleCounts
    "for resource debugging only - will vanish"

%{  /* NOCONTEXT */
#ifdef COUNT_RESOURCES
    RETURN ( __MKSMALLINT(__cnt_cur));
#else
    RETURN (nil);
#endif
%}
!

debug
%{  /* NOCONTEXT */

    RETURN (__debug__ != 0 ? true : false);
%}
!

debug2
%{  /* NOCONTEXT */

    RETURN ((__debug__ & 2) != 0 ? true : false);
%}
!

debug2:aBoolean
    "enable more debug prints - this will vanish"

%{  /* NOCONTEXT */

    if (aBoolean == true) {
	__debug__ |= 2;
    } else {
	__debug__ &= ~2;
    }
%}
!

debug4:aBoolean
    "enable even more debug prints - this will vanish"

%{  /* NOCONTEXT */

    if (aBoolean == true) {
	__debug__ |= 4;
    } else {
	__debug__ &= ~4;
    }
%}
!

debug8:aBoolean
    "enable even more debug prints - this will vanish"

%{  /* NOCONTEXT */

    if (aBoolean == true) {
	__debug__ |= 8;
    } else {
	__debug__ &= ~8;
    }
%}
!

debug:aBoolean
    "enable/disable debug prints - this will vanish"

%{  /* NOCONTEXT */

    __debug__ = (aBoolean == true) ? 1 : 0;
%}
    "
     WinWorkstation debug:true
     WinWorkstation debug:false
    "
!

debug:aBoolean message:msg
    "enable/disable debugging of individual WM messages"

    msg = 'WM_ALL' ifTrue:[
%{
	__debug_WM_ALL__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_USER' ifTrue:[
%{
	__debug_WM_MOUSEENTER__ = (aBoolean == true);
	__debug_WM_MOUSELEAVE__ = (aBoolean == true);
	__debug_WM_MOUSEMOVE__ = (aBoolean == true);
	__debug_WM_MOUSEACTIVATE__ = (aBoolean == true);
	__debug_WM_BUTTONUP__ = (aBoolean == true);
	__debug_WM_BUTTONDOWN__ = (aBoolean == true);
	__debug_WM_KEYUP__ = (aBoolean == true);
	__debug_WM_KEYDOWN__ = (aBoolean == true);
	__debug_WM_CHAR__ = (aBoolean == true);
	RETURN (self);
%}
    ].

    msg = 'WM_MOUSEENTER' ifTrue:[
%{
	__debug_WM_MOUSEENTER__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_MOUSELEAVE' ifTrue:[
%{
	__debug_WM_MOUSELEAVE__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_MOUSEMOVE' ifTrue:[
%{
	__debug_WM_MOUSEMOVE__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_MOUSEACTIVATE' ifTrue:[
%{
	__debug_WM_MOUSEACTIVATE__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_BUTTONUP' ifTrue:[
%{
	__debug_WM_BUTTONUP__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_BUTTONDOWN' ifTrue:[
%{
	__debug_WM_BUTTONDOWN__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_KEYUP' ifTrue:[
%{
	__debug_WM_KEYUP__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_KEYDOWN' ifTrue:[
%{
	__debug_WM_KEYDOWN__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_CHAR' ifTrue:[
%{
	__debug_WM_CHAR__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_PAINT' ifTrue:[
%{
	__debug_WM_PAINT__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_MOVING' ifTrue:[
%{
	__debug_WM_MOVING__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_ERASEBKGND' ifTrue:[
%{
	__debug_WM_ERASEBKGND__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_SETTEXT' ifTrue:[
%{
	__debug_WM_SETTEXT__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_COPYDATA' ifTrue:[
%{
	__debug_WM_COPYDATA__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_DROPFILES' ifTrue:[
%{
	__debug_WM_DROPFILES__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_SHOWWINDOW' ifTrue:[
%{
	__debug_WM_SHOWWINDOW__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_SETCURSOR' ifTrue:[
%{
	__debug_WM_SETCURSOR__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    msg = 'WM_FOCUS' ifTrue:[
%{
	__debug_WM_FOCUS__ = (aBoolean == true);
	RETURN (self);
%}
    ].
    'unknown WM_x' infoPrintCR.

    "
     WinWorkstation debug:true

     WinWorkstation debug:false message:'WM_KEYUP'
     WinWorkstation debug:false message:'WM_KEYDOWN'
     WinWorkstation debug:false message:'WM_PAINT'
     WinWorkstation debug:false message:'WM_BUTTONDOWN'

     WinWorkstation debug:true message:'WM_KEYUP'
     WinWorkstation debug:true message:'WM_KEYDOWN'
     WinWorkstation debug:true message:'WM_CHAR'
     WinWorkstation debug:true message:'WM_COPYDATA'
    "
!

debugNative
%{  /* NOCONTEXT */

    RETURN (__debugNative__ == 0 ? false : true);
%}
    "
     WinWorkstation debugNative
    "
!

debugNative:aBoolean
%{  /* NOCONTEXT */

    __debugNative__ = (aBoolean == true);
%}
    "
     WinWorkstation debugNative:true
     WinWorkstation debugNative:false
    "
!

fontHandleCounts
    "for resource debugging only - will vanish"

%{  /* NOCONTEXT */
#ifdef COUNT_RESOURCES
    RETURN ( __MKSMALLINT(__cnt_font));
#else
    RETURN (nil);
#endif
%}
!

gcDataHandleCounts
    "for resource debugging only - will vanish"

%{  /* NOCONTEXT */
#ifdef COUNT_RESOURCES
    RETURN ( __MKSMALLINT(__cnt_gcData));
#else
    RETURN (nil);
#endif
%}
!

getGuiResources
    "For resource debugging only. Returns an array containing
     number of allocated / peak user / GDU objects. 

     NOTE: This method uses GetGuiResources() Windows API so it returns
     values of Windows counters as opposite to WinWorkstation internal
     counters (which are returned by #getHandleCounts family of methods)."

     | counts |

     counts := Array new: 4.
%{
/* Sigh, _PEAK constants seems not to be defined under MinGW / MinGW64. 
 * Define them here.
 */
#ifndef GR_GDIOBJECTS_PEAK
# define GR_GDIOBJECTS_PEAK 2
#endif
#ifndef GR_USEROBJECTS_PEAK
# define GR_USEROBJECTS_PEAK 4
#endif
     HANDLE proc = GetCurrentProcess();
     __ArrayInstPtr(counts)->a_element[0] = __MKSMALLINT(GetGuiResources(proc, GR_USEROBJECTS));
     __ArrayInstPtr(counts)->a_element[1] = __MKSMALLINT(GetGuiResources(proc, GR_USEROBJECTS_PEAK));
     __ArrayInstPtr(counts)->a_element[2] = __MKSMALLINT(GetGuiResources(proc, GR_GDIOBJECTS));
     __ArrayInstPtr(counts)->a_element[3] = __MKSMALLINT(GetGuiResources(proc, GR_GDIOBJECTS_PEAK)); 
%}.
     ^counts

!

printGuiResourceCounts
   "Show number of allocated user / GDI objects.

    NOTE: This method uses GetGuiResources() Windows API so it prints
    values of Windows counters as opposite to WinWorkstation internal
    counters (which are returned by #printHandleCounts)."

   | counts |

   counts := self getGuiResources.

    'GetGuiResources(): # User Objects    = ' errorPrint. counts first errorPrintCR.
    '                   Peak User Objects = ' errorPrint. counts second errorPrintCR.
    '                   # GDI Objects     = ' errorPrint. counts third errorPrintCR.
    '                   Peak GDI Objects  = ' errorPrint. counts fourth errorPrintCR.
!

printHandleCounts
   "show prim values"

    'WINWORKSTATION: # Windows = ' errorPrint. self windowHandleCounts errorPrintCR.
    '                # Bitmaps = ' errorPrint. self bitmapHandleCounts errorPrintCR.
    '                # Fonts   = ' errorPrint. self fontHandleCounts errorPrintCR.
    '                # GC Data = ' errorPrint. self gcDataHandleCounts errorPrintCR.
!

windowHandleCounts
    "for resource debugging only - will vanish"

%{  /* NOCONTEXT */
#ifdef COUNT_RESOURCES
    RETURN ( __MKSMALLINT(__cnt_createWindows));
#else
    RETURN (nil);
#endif
%}
! !

!WinWorkstation class methodsFor:'queries'!

isWindowsPlatform
    "return true, if this device is a windows screen"

    ^ true
!

platformName
    "ST-80 compatibility.
     Return a string describing the display systems platform.
     WinWorkstation always returns 'WIN32'."

    ^ 'WIN32'

    "Modified: 26.5.1996 / 15:32:46 / cg"
! !

!WinWorkstation methodsFor:'accessing & queries'!

activateOnClick:aBoolean
    "set/clear the activateOnClick behavior.
     If on, a click into a window raises and activates
     the window.
     Windows users typically enable this;
     users which are used to the X-Window system typically prefer
     it disabled.
     Returns the previous setting.
     The default is true."

%{  /* NOCONTEXT */
    OBJ rslt = __activateOnClick ? true : false;

    if (aBoolean == true) {
       __activateOnClick = 1;
    } else {
       if (aBoolean == false) {
	   __activateOnClick = 0;
       }
    }
    RETURN (rslt);
%}
    "
     Display activateOnClick:true
     Display activateOnClick:false
    "
!

anyButtonMotionMask
    "return the state-mask for any button in motion events' state-field.
     This is the devices mask."

%{  /* NOCONTEXT */
    RETURN ( __MKSMALLINT(Button1MotionMask | Button2MotionMask | Button3MotionMask));
%}
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
    "return the state-mask for the CTRL modified in motion events' state-field.
     Obsolete"

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(ControlMask));
%}
!

ctrlModifierMask
    "return the state-mask for the CTRL modified in motion events' state-field."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(ControlMask));
%}
!

defaultEventMask
    "return a mask to enable some events by default."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT( ExposureMask | StructureNotifyMask |
			 KeyPressMask | KeyReleaseMask |
			 EnterWindowMask | LeaveWindowMask |
			 ButtonPressMask | ButtonMotionMask | ButtonReleaseMask ));
%}
!

deviceContext
    ^ rootDC

    "Created: / 24-12-2010 / 10:44:40 / cg"
!

displayFileDescriptor
    "return the displays fileNumber for select, if any"

%{  /* NOCONTEXT */
   /* RETURN (nil);*/
   RETURN ( __MKEXTERNALADDRESS(hInputEvent));
%}
!

displayName
    "return the display-connections display name.
     For Windows, a name of window station is returned"
    | err |

%{
    if (__isExternalAddress(__INST(displayId))) {
        HANDLE station = (HANDLE)__externalAddressVal(__INST(displayId));
        char   stationName[256];
        DWORD  stationNameLen = 0;        

        stationName[255] = '\0';
        if ( GetUserObjectInformation ( station, UOI_NAME, stationName, 255, &stationNameLen)) {
            RETURN( __MKSTRING(stationName));
        }
    }
%}.
    self primitiveFailed: err
!

focusFollowsMouse:aBoolean
    "set/clear the focusFollowsMouse behavior.
     If on, the view under the mouse gets the keyboard input
     (however, within a windowGroup, ST/X can still forward the event
      the groups focusView...).
     Windows users typically disable this;
     users which are used to the X-Window system typically prefer
     it enabled.
     Returns the previous setting.
     The default is false."

%{  /* NOCONTEXT */
    OBJ rslt = __focusFollowsMouse ? true : false;

    if (aBoolean == true) {
       __focusFollowsMouse = 1;
    } else {
       if (aBoolean == false) {
	   __focusFollowsMouse = 0;
       }
    }
    RETURN (rslt);
%}
    "
     WinWorkstation focusFollowsMouse:true
     WinWorkstation focusFollowsMouse:false
    "
!

getSystemColor:aKey
    "retrieve a windows system color.
     The styleSheet/View classes may use this to setup default colors"

    ^ SystemColorValues at:aKey ifAbsentPut:[self primGetSystemColor:aKey].

    "
     Display getSystemColor:#COLOR_WINDOW
     Display getSystemColor:#COLOR_HIGHLIGHT
    "

    "Modified: / 30-10-2007 / 15:06:02 / cg"
!

getSystemMetrics:aNumberOrSymbol
    "get a system metrics value;
     the argument is a #define-like symbol as described in the windows API;
     However, to allow for future values to be retrieved, also allow an integer
     which must be the define-value."

%{  /* NOCONTEXT */
    int info = 0;
    int isBool = 0;
    int arg;

    if (__isSmallInteger(aNumberOrSymbol)) {
	arg = __intVal(aNumberOrSymbol);
    } else if ((aNumberOrSymbol == @symbol(swapButton)) || (aNumberOrSymbol == @symbol(SM_SWAPBUTTON))) {
	arg = SM_SWAPBUTTON;
	isBool = 1;
    } else if ((aNumberOrSymbol == @symbol(mousePresent)) || (aNumberOrSymbol == @symbol(SM_MOUSEPRESENT))) {
	arg = SM_MOUSEPRESENT;
	isBool = 1;
    } else if ((aNumberOrSymbol == @symbol(mouseButtons)) || (aNumberOrSymbol == @symbol(SM_CMOUSEBUTTONS))) {
	arg = SM_CMOUSEBUTTONS;
    } else if ((aNumberOrSymbol == @symbol(iconWidth)) || (aNumberOrSymbol == @symbol(SM_CXICON))) {
	arg = SM_CXICON;
    } else if ((aNumberOrSymbol == @symbol(iconHeight)) || (aNumberOrSymbol == @symbol(SM_CYICON))) {
	arg = SM_CYICON;
    } else if ((aNumberOrSymbol == @symbol(iconWidth)) || (aNumberOrSymbol == @symbol(SM_CXDOUBLECLK))) {
	arg = SM_CXDOUBLECLK;
    } else if ((aNumberOrSymbol == @symbol(iconHeight)) || (aNumberOrSymbol == @symbol(SM_CYDOUBLECLK))) {
	arg = SM_CYDOUBLECLK;
    } else if ((aNumberOrSymbol == @symbol(cursorWidth)) || (aNumberOrSymbol == @symbol(SM_CXCURSOR))) {
	arg = SM_CXCURSOR;
    } else if ((aNumberOrSymbol == @symbol(cursorHeight)) || (aNumberOrSymbol == @symbol(SM_CYCURSOR))) {
	arg = SM_CYCURSOR;
    } else if ((aNumberOrSymbol == @symbol(captionHeight)) || (aNumberOrSymbol == @symbol(SM_CYCAPTION))) {
	arg = SM_CYCAPTION;
    } else if ((aNumberOrSymbol == @symbol(resizeFrameWidth)) || (aNumberOrSymbol == @symbol(SM_CXFRAME))) {
	arg = SM_CXFRAME;
    } else if ((aNumberOrSymbol == @symbol(resizeFrameHeight)) || (aNumberOrSymbol == @symbol(SM_CYFRAME))) {
	arg = SM_CYFRAME;
    } else if ((aNumberOrSymbol == @symbol(borderFrameWidth)) || (aNumberOrSymbol == @symbol(SM_CXBORDER))) {
	arg = SM_CXBORDER;
    } else if ((aNumberOrSymbol == @symbol(borderFrameHeight)) || (aNumberOrSymbol == @symbol(SM_CYBORDER))) {
	arg = SM_CYBORDER;
    } else if (aNumberOrSymbol == @symbol(SM_CXDLGFRAME)) {
	arg = SM_CXDLGFRAME;
    } else if (aNumberOrSymbol == @symbol(SM_CYDLGFRAME)) {
	arg = SM_CYDLGFRAME;
    } else if ((aNumberOrSymbol == @symbol(fullScreenWindowWidth)) || (aNumberOrSymbol == @symbol(SM_CXFULLSCREEN))) {
	arg = SM_CXFULLSCREEN;
    } else if ((aNumberOrSymbol == @symbol(fullScreenWindowHeight)) || (aNumberOrSymbol == @symbol(SM_CYFULLSCREEN))) {
	arg = SM_CYFULLSCREEN;
    } else if ((aNumberOrSymbol == @symbol(screenWidth)) || (aNumberOrSymbol == @symbol(SM_CXSCREEN))) {
	arg = SM_CXSCREEN;
    } else if ((aNumberOrSymbol == @symbol(screenHeight)) || (aNumberOrSymbol == @symbol(SM_CYSCREEN))) {
	arg = SM_CYSCREEN;
    } else if ((aNumberOrSymbol == @symbol(minWindowWidth)) || (aNumberOrSymbol == @symbol(SM_CXMIN))) {
	arg = SM_CXMIN;
    } else if ((aNumberOrSymbol == @symbol(minWindowHeight)) || (aNumberOrSymbol == @symbol(SM_CYMIN))) {
	arg = SM_CYMIN;
    } else if ((aNumberOrSymbol == @symbol(vScrollbarWidth)) || (aNumberOrSymbol == @symbol(SM_CXVSCROLL))) {
	arg = SM_CXVSCROLL;
    } else if ((aNumberOrSymbol == @symbol(hScrollbarHeight)) || (aNumberOrSymbol == @symbol(SM_CYHSCROLL))) {
	arg = SM_CYHSCROLL;
    } else if ((aNumberOrSymbol == @symbol(vThumbHeight)) || (aNumberOrSymbol == @symbol(SM_CYVTHUMB))) {
	arg = SM_CYVTHUMB;
    } else if ((aNumberOrSymbol == @symbol(hThumbWidth)) || (aNumberOrSymbol == @symbol(SM_CXHTHUMB))) {
	arg = SM_CXHTHUMB;
    } else if ((aNumberOrSymbol == @symbol(SM_CXSIZE))) {
	arg = SM_CXSIZE;
    } else if ((aNumberOrSymbol == @symbol(SM_CYSIZE))) {
	arg = SM_CYSIZE;
    } else if ((aNumberOrSymbol == @symbol(SM_CYVSCROLL))) {
	arg = SM_CYVSCROLL;
    } else if ((aNumberOrSymbol == @symbol(SM_CXHSCROLL))) {
	arg = SM_CXHSCROLL;
    } else if ((aNumberOrSymbol == @symbol(SM_CXMINTRACK))) {
	arg = SM_CXMINTRACK;
    } else if ((aNumberOrSymbol == @symbol(SM_CYMINTRACK))) {
	arg = SM_CYMINTRACK;
    } else if ((aNumberOrSymbol == @symbol(SM_CXICONSPACING))) {
	arg = SM_CXICONSPACING;
    } else if ((aNumberOrSymbol == @symbol(SM_CYICONSPACING))) {
	arg = SM_CYICONSPACING;
    } else if ((aNumberOrSymbol == @symbol(SM_CYMENU))) {
	arg = SM_CYMENU;
    } else if ((aNumberOrSymbol == @symbol(SM_MENUDROPALIGNMENT))) {
	arg = SM_MENUDROPALIGNMENT;
    } else if ((aNumberOrSymbol == @symbol(SM_PENWINDOWS))) {
	arg = SM_PENWINDOWS;
    } else if ((aNumberOrSymbol == @symbol(SM_DBCSENABLED))) {
	arg = SM_DBCSENABLED;
    } else if ((aNumberOrSymbol == @symbol(SM_CXFIXEDFRAME))) {
	arg = SM_CXFIXEDFRAME;
    } else if ((aNumberOrSymbol == @symbol(SM_CYFIXEDFRAME))) {
	arg = SM_CYFIXEDFRAME;
    } else if ((aNumberOrSymbol == @symbol(SM_CXSIZEFRAME))) {
	arg = SM_CXSIZEFRAME;
    } else if ((aNumberOrSymbol == @symbol(SM_CYSIZEFRAME))) {
	arg = SM_CYSIZEFRAME;
    } else if ((aNumberOrSymbol == @symbol(SM_CYKANJIWINDOW))) {
	arg = SM_CYKANJIWINDOW;
    } else if ((aNumberOrSymbol == @symbol(SM_SECURE))) {
	arg = SM_SECURE;
    } else if ((aNumberOrSymbol == @symbol(SM_CXEDGE))) {
	arg = SM_CXEDGE;
    } else if ((aNumberOrSymbol == @symbol(SM_CYEDGE))) {
	arg = SM_CYEDGE;
    } else if ((aNumberOrSymbol == @symbol(SM_CXMINSPACING))) {
	arg = SM_CXMINSPACING;
    } else if ((aNumberOrSymbol == @symbol(SM_CYMINSPACING))) {
	arg = SM_CYMINSPACING;
    } else if ((aNumberOrSymbol == @symbol(SM_CXSMICON))) {
	arg = SM_CXSMICON;
    } else if ((aNumberOrSymbol == @symbol(SM_CYSMICON))) {
	arg = SM_CYSMICON;
    } else if ((aNumberOrSymbol == @symbol(SM_CYSMCAPTION))) {
	arg = SM_CYSMCAPTION;
    } else if ((aNumberOrSymbol == @symbol(SM_CXSMSIZE))) {
	arg = SM_CXSMSIZE;
    } else if ((aNumberOrSymbol == @symbol(SM_CYSMSIZE))) {
	arg = SM_CYSMSIZE;
    } else if ((aNumberOrSymbol == @symbol(SM_CXMENUSIZE))) {
	arg = SM_CXMENUSIZE;
    } else if ((aNumberOrSymbol == @symbol(SM_CYMENUSIZE))) {
	arg = SM_CYMENUSIZE;
    } else if ((aNumberOrSymbol == @symbol(SM_ARRANGE))) {
	arg = SM_ARRANGE;
    } else if ((aNumberOrSymbol == @symbol(SM_CXMINIMIZED))) {
	arg = SM_CXMINIMIZED;
    } else if ((aNumberOrSymbol == @symbol(SM_CYMINIMIZED))) {
	arg = SM_CYMINIMIZED;
    } else if ((aNumberOrSymbol == @symbol(SM_CXMAXTRACK))) {
	arg = SM_CXMAXTRACK;
    } else if ((aNumberOrSymbol == @symbol(SM_CYMAXTRACK))) {
	arg = SM_CYMAXTRACK;
    } else if ((aNumberOrSymbol == @symbol(SM_CXMAXIMIZED))) {
	arg = SM_CXMAXIMIZED;
    } else if ((aNumberOrSymbol == @symbol(SM_CYMAXIMIZED))) {
	arg = SM_CYMAXIMIZED;
    } else if ((aNumberOrSymbol == @symbol(SM_NETWORK))) {
	arg = SM_NETWORK;
    } else if ((aNumberOrSymbol == @symbol(SM_CXDRAG))) {
	arg = SM_CXDRAG;
    } else if ((aNumberOrSymbol == @symbol(SM_CYDRAG))) {
	arg = SM_CYDRAG;
    } else if ((aNumberOrSymbol == @symbol(SM_NETWORK))) {
	arg = SM_NETWORK;
    } else if ((aNumberOrSymbol == @symbol(SM_SHOWSOUNDS))) {
	arg = SM_SHOWSOUNDS;
    } else if ((aNumberOrSymbol == @symbol(SM_CXMENUCHECK))) {
	arg = SM_CXMENUCHECK;
    } else if ((aNumberOrSymbol == @symbol(SM_CYMENUCHECK))) {
	arg = SM_CYMENUCHECK;
    } else if ((aNumberOrSymbol == @symbol(SM_SLOWMACHINE))) {
	arg = SM_SLOWMACHINE;
    } else if ((aNumberOrSymbol == @symbol(SM_MIDEASTENABLED))) {
	arg = SM_MIDEASTENABLED;
    } else if ((aNumberOrSymbol == @symbol(SM_MOUSEWHEELPRESENT))) {
	arg = SM_MOUSEWHEELPRESENT;
    } else if ((aNumberOrSymbol == @symbol(SM_XVIRTUALSCREEN))) {
	arg = SM_XVIRTUALSCREEN;
    } else if ((aNumberOrSymbol == @symbol(SM_YVIRTUALSCREEN))) {
	arg = SM_YVIRTUALSCREEN;
    } else if ((aNumberOrSymbol == @symbol(SM_CXVIRTUALSCREEN))) {
	arg = SM_CXVIRTUALSCREEN;
    } else if ((aNumberOrSymbol == @symbol(SM_CYVIRTUALSCREEN))) {
	arg = SM_CYVIRTUALSCREEN;
    } else if ((aNumberOrSymbol == @symbol(SM_CMONITORS))) {
	arg = SM_CMONITORS;
    } else if ((aNumberOrSymbol == @symbol(SM_SAMEDISPLAYFORMAT))) {
	arg = SM_SAMEDISPLAYFORMAT;
#ifdef SM_IMMENABLED
    } else if ((aNumberOrSymbol == @symbol(SM_IMMENABLED))) {
	arg = SM_IMMENABLED;
#endif
    } else if ((aNumberOrSymbol == @symbol(SM_DEBUG))) {
	arg = SM_DEBUG;
#ifdef SM_REMOTESESSION
    } else if ((aNumberOrSymbol == @symbol(SM_REMOTESESSION))) {
	arg = SM_REMOTESESSION;
#endif
    } else {
	RETURN (nil);
    }
    info = GetSystemMetrics(arg);
    if (isBool) {
	RETURN (info ? true : false);
    }
    RETURN (__MKSMALLINT(info));
%}
    "
     Screen current getSystemMetrics:#SM_MOUSEWHEELPRESENT
     Screen current getSystemMetrics:#SM_ARRANGE
     Screen current getSystemMetrics:#SM_XVIRTUALSCREEN
     Screen current getSystemMetrics:#SM_CXVIRTUALSCREEN
     Screen current getSystemMetrics:#SM_CYVIRTUALSCREEN
     Screen current getSystemMetrics:#SM_CMONITORS
     Screen current getSystemMetrics:#SM_SAMEDISPLAYFORMAT
     Screen current getSystemMetrics:81
    "

    "Modified: / 08-09-2006 / 15:36:32 / cg"
!

getSystemParametersInfo:aNumberOrSymbol
    "get a system parameter value;
     the argument is a #define-like symbol as described in the windows API;
     However, to allow for future values to be retrieved, also allow an integer
     which must be the define-value."

    | info menuFontInfoArray statusFontInfoArray messageFontInfoArray
      menuFont statusFont messageFont |
%{
    int retVal = 0;
    int isBool = 0;
    int isString = 0;
    int isRect = 0;
    int isNonClientInfo = 0;
    int arg, param;
    void *pRslt;
    union {
	char buffer[1024];
	RECT rect;
	NONCLIENTMETRICS nc;
    } rslt;

    if (__isSmallInteger(aNumberOrSymbol)) {
	arg = __intVal(aNumberOrSymbol);
#ifdef SPI_GETDESKWALLPAPER
    } else if (aNumberOrSymbol == @symbol(SPI_GETDESKWALLPAPER)) {
	arg = SPI_GETDESKWALLPAPER;
	isString = 1;
#endif
#ifdef SPI_GETDROPSHADOW
    } else if (aNumberOrSymbol == @symbol(SPI_GETDROPSHADOW)) {
	arg = SPI_GETDROPSHADOW;
	isBool = 1;
#endif
#ifdef SPI_GETFLATMENU
    } else if (aNumberOrSymbol == @symbol(SPI_GETFLATMENU)) {
	arg = SPI_GETFLATMENU;
	isBool = 1;
#endif
#ifdef SPI_GETWHEELSCROLLLINES
    } else if (aNumberOrSymbol == @symbol(SPI_GETWHEELSCROLLLINES)) {
	arg = SPI_GETWHEELSCROLLLINES;
#endif
#ifdef SPI_GETHOTTRACKING
    } else if (aNumberOrSymbol == @symbol(SPI_GETHOTTRACKING)) {
	arg = SPI_GETHOTTRACKING;
	isBool = 1;
#endif
#ifdef SPI_GETTOOLTIPANIMATION
    } else if (aNumberOrSymbol == @symbol(SPI_GETTOOLTIPANIMATION)) {
	arg = SPI_GETTOOLTIPANIMATION;
	isBool = 1;
#endif
#ifdef SPI_GETWORKAREA
    } else if (aNumberOrSymbol == @symbol(SPI_GETWORKAREA)) {
	arg = SPI_GETWORKAREA;
	isRect = 1;
#endif
#ifdef SPI_GETNONCLIENTMETRICS
    } else if (aNumberOrSymbol == @symbol(SPI_GETNONCLIENTMETRICS)) {
	arg = SPI_GETNONCLIENTMETRICS;
	rslt.nc.cbSize = sizeof ( rslt.nc ) ;
	isNonClientInfo = 1;
#endif
    } else {
	RETURN (nil);
    }

    param = 0;
    pRslt = (void *)&rslt;
    if (isString) {
	param = sizeof(rslt);
    }
    retVal = SystemParametersInfo(arg, param, pRslt, 0);
    if (! retVal) {
	RETURN (nil);
    }

    if (isBool) {
	RETURN (info ? true : false);
    }
    if (isString) {
	RETURN (__MKSTRING(rslt.buffer));
    }
    if (isRect) {
	RETURN ( __SSEND4(__DEF_Rectangle, @symbol(left:top:right:bottom:), 0,
			__MKSMALLINT(rslt.rect.left),
			__MKSMALLINT(rslt.rect.top),
			__MKSMALLINT(rslt.rect.right),
			__MKSMALLINT(rslt.rect.bottom)) );
    }
    if (isNonClientInfo) {
	menuFontInfoArray = __extractLogicalFontParameters(&rslt.nc.lfMenuFont);
	statusFontInfoArray = __extractLogicalFontParameters(&rslt.nc.lfStatusFont);
	messageFontInfoArray = __extractLogicalFontParameters(&rslt.nc.lfMessageFont);
    }

   out: ;
%}.

    menuFontInfoArray notNil ifTrue:[
	menuFont := self fontDescriptionFromLogicalFontInfoArray:menuFontInfoArray.
	statusFont := self fontDescriptionFromLogicalFontInfoArray:statusFontInfoArray.
	messageFont := self fontDescriptionFromLogicalFontInfoArray:messageFontInfoArray.
	^ (Dictionary new)
	    at:#menuFont put:menuFont;
	    at:#statusFont put:statusFont;
	    at:#messageFont put:messageFont;
	    yourself.
    ].

    ^ nil

    "
     Screen current getSystemParametersInfo:#SPI_GETDESKWALLPAPER
     Screen current getSystemParametersInfo:#SPI_GETDROPSHADOW
     Screen current getSystemParametersInfo:#SPI_GETFLATMENU
     Screen current getSystemParametersInfo:#SPI_GETWHEELSCROLLLINES
     Screen current getSystemParametersInfo:#SPI_GETHOTTRACKING
     Screen current getSystemParametersInfo:#SPI_GETTOOLTIPANIMATION

     Screen current getSystemParametersInfo:#SPI_GETWORKAREA
     Screen current getSystemParametersInfo:#SPI_GETNONCLIENTMETRICS
    "
!

ignoreButtonPressOnActivate:aBoolean
    "set/clear the ignoreButtonPressOnActivate behavior.
     If on, the button-press which activated a window is ignored (eaten),
     and not passed to the window.
     If off, the window receives the buttonPress after the window is activated.
     The default is true, since it avoids unwanted selections due to window
     activation.
     Returns the previous setting."

%{  /* NOCONTEXT */
    OBJ rslt = __ignoreButtonPressOnActivate ? true : false;

    if (aBoolean == true) {
       __ignoreButtonPressOnActivate = 1;
    } else {
       if (aBoolean == false) {
	   __ignoreButtonPressOnActivate = 0;
       }
    }
    RETURN (rslt);
%}
    "
     WinWorkstation ignoreButtonPressOnActivate:true
     WinWorkstation ignoreButtonPressOnActivate:false
    "
!

monitorInfoFor:aMonitorId
    "given a monitor handle (as returned by monitorHandleForXXX), return its info"

    |screenL screenT screenR screenB screenW screenH
     workL workT workR workB workW workH
     isPrimary mName|
%{
    if (__isExternalAddress(aMonitorId)) {
	HMONITOR hMonitor = (HMONITOR)(_HWNDVal(aMonitorId));
	MONITORINFOEX info;

	info.cbSize = sizeof(MONITORINFOEX);
#if 0
	/* the following is only needed when we want
	 * to support very old NT/W95/W98 systems; we don't !
	 */
	static BOOL (__stdcall *P_GetMonitorInfo)(HMONITOR , MONITORINFOEX *);

	if (P_GetMonitorInfo == 0) {
	    HINSTANCE hUser = LoadLibrary("user32.dll");
	    // console_printf("hUser: %x\n", hUser);
	    if (hUser) {
		P_GetMonitorInfo = (BOOL (__stdcall *)(HMONITOR, MONITORINFOEX * ))
				    GetProcAddress(hUser, "GetMonitorInfo");
	    }
	}
	console_printf("P_GetMonitorInfo: %x\n", P_GetMonitorInfo);
	if ((*P_GetMonitorInfo)(hMonitor, &info))
#else
	if (GetMonitorInfo(hMonitor, (MONITORINFO *)(&info)))
#endif
	{
	    // console_printf("l %d\n", info.rcMonitor.left);
	    screenL = __MKSMALLINT(info.rcMonitor.left);
	    screenT = __MKSMALLINT(info.rcMonitor.top);
	    screenR = __MKSMALLINT(info.rcMonitor.right);
	    screenB = __MKSMALLINT(info.rcMonitor.bottom);
	    workL = __MKSMALLINT(info.rcWork.left);
	    workT = __MKSMALLINT(info.rcWork.top);
	    workR = __MKSMALLINT(info.rcWork.right);
	    workB = __MKSMALLINT(info.rcWork.bottom);
	    isPrimary = (info.dwFlags & MONITORINFOF_PRIMARY) ? true : false;
	    info.szDevice[31] = '\0';
	    mName = __MKSTRING(info.szDevice);
	}
    }
%}.
    screenL isNil ifTrue:[ ^ nil ].

    ^ MonitorInfo new
	screenX:screenL screenY:screenT
	screenWidth:(screenR-screenL) screenHeight:(screenB-screenT)
	workX:workL workY:workT
	workWidth:(workR-workL) workHeight:(workB-workT)
	isPrimary:isPrimary
	name:mName

    "
     Screen current monitorInfoFor:(Screen current monitorHandleForView:(Transcript topView id))
     Screen current monitorInfoFor:(Screen current monitorHandleForPoint:(0@0))
     Screen current monitorInfoFor:(Screen current monitorHandleForPoint:(Display pointFromUser))
    "
!

primGetSystemColor:aKey
    "retrieve a windows system color.
     The styleSheet/View classes may use this to setup default colors"

    |red green blue|

%{
    int p;
    int __bgr;

    if (aKey == @symbol(COLOR_WINDOW)) {
      p = COLOR_WINDOW;
    } else if (aKey == @symbol(COLOR_WINDOWTEXT)) {
      p = COLOR_WINDOWTEXT;
    } else if (aKey == @symbol(COLOR_MENU)) {
      p = COLOR_MENU;
    } else if (aKey == @symbol(COLOR_MENUTEXT)) {
      p = COLOR_MENUTEXT;
    } else if (aKey == @symbol(COLOR_BTNFACE)) {
      p = COLOR_BTNFACE;
    } else if (aKey == @symbol(COLOR_BTNSHADOW)) {
      p = COLOR_BTNSHADOW;
    } else if (aKey == @symbol(COLOR_BTNTEXT)) {
      p = COLOR_BTNTEXT;
    } else if (aKey == @symbol(COLOR_GRAYTEXT)) {
      p = COLOR_GRAYTEXT;
    } else if (aKey == @symbol(COLOR_HIGHLIGHT)) {
      p = COLOR_HIGHLIGHT;
    } else if (aKey == @symbol(COLOR_HIGHLIGHTTEXT)) {
      p = COLOR_HIGHLIGHTTEXT;
    } else if (aKey == @symbol(COLOR_MENU)) {
      p = COLOR_MENU;
    } else if (aKey == @symbol(COLOR_MENUTEXT)) {
      p = COLOR_MENUTEXT;
    } else if (aKey == @symbol(COLOR_SCROLLBAR)) {
      p = COLOR_SCROLLBAR;
#ifdef COLOR_SHADOW
    } else if (aKey == @symbol(COLOR_SHADOW)) {
      p = COLOR_SHADOW;
#endif
#ifdef COLOR_BACKGROUND
    } else if (aKey == @symbol(COLOR_BACKGROUND)) {
      p = COLOR_BACKGROUND;
#endif
#ifdef COLOR_ACTIVECAPTION
    } else if (aKey == @symbol(COLOR_ACTIVECAPTION)) {
      p = COLOR_ACTIVECAPTION;
#endif
#ifdef COLOR_INACTIVECAPTION
    } else if (aKey == @symbol(COLOR_INACTIVECAPTION)) {
      p = COLOR_INACTIVECAPTION;
#endif
#ifdef COLOR_WINDOWFRAME
    } else if (aKey == @symbol(COLOR_WINDOWFRAME)) {
      p = COLOR_WINDOWFRAME;
#endif
#ifdef COLOR_CAPTIONTEXT
    } else if (aKey == @symbol(COLOR_CAPTIONTEXT)) {
      p = COLOR_CAPTIONTEXT;
#endif
#ifdef COLOR_ACTIVEBORDER
    } else if (aKey == @symbol(COLOR_ACTIVEBORDER)) {
      p = COLOR_ACTIVEBORDER;
#endif
#ifdef COLOR_INACTIVEBORDER
    } else if (aKey == @symbol(COLOR_INACTIVEBORDER)) {
      p = COLOR_INACTIVEBORDER;
#endif
#ifdef COLOR_APPWORKSPACE
    } else if (aKey == @symbol(COLOR_APPWORKSPACE)) {
      p = COLOR_APPWORKSPACE;
#endif
#ifdef COLOR_INACTIVECAPTIONTEXT
    } else if (aKey == @symbol(COLOR_INACTIVECAPTIONTEXT)) {
      p = COLOR_INACTIVECAPTIONTEXT;
#endif
#ifdef COLOR_BTNHIGHLIGHT
    } else if (aKey == @symbol(COLOR_BTNHIGHLIGHT)) {
      p = COLOR_BTNHIGHLIGHT;
#endif
#ifdef COLOR_3DDKSHADOW
    } else if (aKey == @symbol(COLOR_3DDKSHADOW)) {
      p = COLOR_3DDKSHADOW;
#endif
#ifdef COLOR_3DLIGHT
    } else if (aKey == @symbol(COLOR_3DLIGHT)) {
      p = COLOR_3DLIGHT;
#endif
#ifdef COLOR_INFOTEXT
    } else if (aKey == @symbol(COLOR_INFOTEXT)) {
      p = COLOR_INFOTEXT;
#endif
#ifdef COLOR_INFOBK
    } else if (aKey == @symbol(COLOR_INFOBK)) {
      p = COLOR_INFOBK;
#endif
#ifdef COLOR_HOTLIGHT
    } else if (aKey == @symbol(COLOR_HOTLIGHT)) {
      p = COLOR_HOTLIGHT;
#endif
#ifdef COLOR_GRADIENTACTIVECAPTION
    } else if (aKey == @symbol(COLOR_GRADIENTACTIVECAPTION)) {
      p = COLOR_GRADIENTACTIVECAPTION;
#endif
#ifdef COLOR_GRADIENTINACTIVECAPTION
    } else if (aKey == @symbol(COLOR_GRADIENTINACTIVECAPTION)) {
      p = COLOR_GRADIENTINACTIVECAPTION;
#endif
#ifdef COLOR_DESKTOP
    } else if (aKey == @symbol(COLOR_DESKTOP)) {
      p = COLOR_DESKTOP;
#endif
#ifdef COLOR_3DFACE
    } else if (aKey == @symbol(COLOR_3DFACE)) {
      p = COLOR_3DFACE;
#endif
#ifdef COLOR_3DSHADOW
    } else if (aKey == @symbol(COLOR_3DSHADOW)) {
      p = COLOR_3DSHADOW;
#endif
#ifdef COLOR_3DHIGHLIGHT
    } else if (aKey == @symbol(COLOR_3DHIGHLIGHT)) {
      p = COLOR_3DHIGHLIGHT;
#endif
#ifdef COLOR_3DHILIGHT
    } else if (aKey == @symbol(COLOR_3DHILIGHT)) {
      p = COLOR_3DHILIGHT;
#endif
#ifdef COLOR_BTNHILIGHT
    } else if (aKey == @symbol(COLOR_BTNHILIGHT)) {
      p = COLOR_BTNHILIGHT;
#endif
    } else {
      goto getOutOfHere;
    }
    __bgr = GetSysColor(p);

    /* win uses BGR order */
    red = __MKSMALLINT(__bgr & 0xFF);
    green = __MKSMALLINT((__bgr >> 8) & 0xFF);
    blue = __MKSMALLINT((__bgr >> 16) & 0xFF);

getOutOfHere: ;
%}.
    red isNil ifTrue:[ ^ nil ].

    ^ Color
	redByte:red
	greenByte:green
	blueByte:blue

    "
     Display primGetSystemColor:#COLOR_WINDOW
     Display primGetSystemColor:#COLOR_HIGHLIGHT
    "

    "Modified: / 30-10-2007 / 15:06:02 / cg"
!

primViewIdFromPoint:aPoint in:windowId
    "given a point in rootWindow, return the viewId of the subview of windowId
     hit by this coordinate. Return nil if no view was hit.
     The returned id may be the id of a non ST view.
     - used to find the window to drop objects after a cross-view drag."

%{

    OBJ xp, yp;
    int xpos, ypos;
    HWND child_ret;

    if (ISCONNECTED
     && __isExternalAddress(windowId)
     && __isPoint(aPoint))
    {
	xp = _point_X(aPoint);
	yp = _point_Y(aPoint);
	if (__bothSmallInteger(xp, yp))
	{
	    POINT p;
	    HWND hWnd = _HWNDVal(windowId);
	    p.x = __intVal(xp);
	    p.y = __intVal(yp);
	    ScreenToClient(hWnd, &p);
	    child_ret = ChildWindowFromPointEx(hWnd,p,CWP_SKIPINVISIBLE|CWP_SKIPDISABLED|CWP_SKIPTRANSPARENT);
	    /*console_printf("ChildWindow From %x Point %d.%d = %x\n",hWnd,p.x,p.y,child_ret);*/
	    if ((child_ret) && (child_ret != hWnd))
	    {
		RETURN ( __MKEXTERNALADDRESS(child_ret) );
	    }
	    RETURN ( nil );
	}
    }
%}.
!

prim_getWindowRect:hWnd
    |l r t b|

%{
    if (__isExternalAddress(hWnd) || __isExternalBytesLike(hWnd)) {
	HANDLE _hwnd = __externalAddressVal(hWnd);
	RECT rect;

	if (GetWindowRect(_hwnd, &rect)) {
	    l = __MKSMALLINT(rect.left);
	    r = __MKSMALLINT(rect.right);
	    t = __MKSMALLINT(rect.top);
	    b = __MKSMALLINT(rect.bottom);
	}
    }
%}.
    l isNil ifTrue:[
	self primitiveFailed.
    ].
    ^ l@t corner:r@b
!

protocolVersion
    "return the displays protocol version.
     For Windows, a dummy number is returned"

    ^ '1'

    "
     Display protocolVersion
    "
!

rightButtonIsLowerWindow:aBoolean
    "set/clear the rightButtonIsLowerWindow behavior.
     If on, a right-button press in the window-title area lowers the
     window.
     The default is true, since a lower-window operation is very useful,
     and not provided by the standard windows applications.
     Returns the previous setting."

%{  /* NOCONTEXT */
    OBJ rslt = __rightButtonIsLowerWindow ? true : false;

    if (aBoolean == true) {
       __rightButtonIsLowerWindow = 1;
    } else {
       if (aBoolean == false) {
	   __rightButtonIsLowerWindow = 0;
       }
    }
    RETURN (rslt);
%}
    "
     Display rightButtonIsLowerWindow:true
     Display rightButtonIsLowerWindow:false
    "
!

serverVendor
    "return the server vendor string.
     For Windows, a dummy name is returned"

    ^ 'microsoft'

    "
     Display serverVendor
    "
!

shiftMask
    "return the state-mask for the SHIFT modified in motion events' state-field.
     Obsolete"

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(ShiftMask));
%}
!

shiftModifierMask
    "return the state-mask for the SHIFT modified in motion events' state-field."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(ShiftMask));
%}
!

shiftedLeftButtonIsLowerWindow:aBoolean
    "set/clear the shiftedLeftButtonIsLowerWindow behavior.
     If on, a shift-left-button press in the window-title area lowers the
     window.
     The default is true, since a lower-window operation is very useful,
     and not provided by the standard windows applications.
     Notice, this duplicates the rightButtonIsLowerWindow behavior,
     but is useful with single-button mice.
     Returns the previous setting."

%{  /* NOCONTEXT */
    OBJ rslt = __shiftedLeftButtonIsLowerWindow ? true : false;

    if (aBoolean == true) {
       __shiftedLeftButtonIsLowerWindow = 1;
    } else {
       if (aBoolean == false) {
	   __shiftedLeftButtonIsLowerWindow = 0;
       }
    }
    RETURN (rslt);
%}
    "
     Display shiftedLeftButtonIsLowerWindow:true
     Display shiftedLeftButtonIsLowerWindow:false
    "
!

supportedSystemColorKeys
    "return a collection of supported systemColor keys"

    ^#(
	COLOR_WINDOW
	COLOR_WINDOWTEXT
	COLOR_MENU
	COLOR_MENUTEXT
	COLOR_BTNFACE
	COLOR_BTNSHADOW
	COLOR_BTNTEXT
	COLOR_GRAYTEXT
	COLOR_HIGHLIGHT
	COLOR_HIGHLIGHTTEXT
	COLOR_MENU
	COLOR_MENUTEXT
	COLOR_SCROLLBAR
	COLOR_SHADOW
    )
!

translatePoint:aPoint from:windowId1 to:windowId2
    "given a point in window1, return the coordinate in window2.
     This expects a device coordinate (relative to the first views origin)
     in aPoint and returns a device coordinate relative to the 2nd views origin.
     - use to xlate points from a window to rootwindow"

    |x1 y1 x2 y2 ret|

    x1 := x2 := aPoint x truncated.
    y1 := y2 := aPoint y truncated.

%{
    HWND w1, w2;
    POINT point;

    if (__isExternalAddress(windowId1)
     && __isExternalAddress(windowId2)
     && __bothSmallInteger(x1, y1)) {
	w1 = _HWNDVal(windowId1);
	w2 = _HWNDVal(windowId2);
	point.x = __intVal(x1);
	point.y = __intVal(y1);
	CPRINTF(("TransPoint %x %d/%d ->", w1, point.x, point.y));
	if (ClientToScreen(w1, &point) == FALSE) {
	    RETURN (nil);
	}
	if (ScreenToClient(w2, &point) == FALSE) {
	    RETURN (nil);
	}
	CPRINTF((" %x %d/%d\n", w2, point.x, point.y));
	ret = __MKPOINT_INT(point.x, point.y);
    }
%}.
    ^ ret
!

vendorRelease
    "return the display-servers vendor release
     - should normally not be of any interest,
     but may be usefule for special cases.
     (to avoid bugs in certain implementations / releases)"

    ^ 1

    "
     Display vendorRelease
    "
!

viewIdFromPoint:aPoint in:windowId
    "given a point in rootWindow, return the viewId of the subview of windowId
     hit by this coordinate. Return nil if no view was hit.
     The returned id may be the id of a non ST view.
     - used to find the window to drop objects after a cross-view drag."

    windowId notNil ifTrue:[
	aPoint isPoint ifTrue:[
	    "/(aPoint x > 30000) ifTrue:[self halt.].
	    "/(aPoint y > 30000) ifTrue:[self halt.].
	    "/aPoint printString errorPrintCR.
	    ^ self primViewIdFromPoint:aPoint asPoint truncated in:windowId
	]
    ].

    ^ nil
!

whitepixel
    "return the colornumber of white"

    ^ whitepixel
! !

!WinWorkstation methodsFor:'accessing display capabilities'!

captionHeight
    "return the height in pixels of any caption (title-bar) in
     standard topWindows."

    ^ self getSystemMetrics:#SM_CYCAPTION

    "Modified: / 08-09-2006 / 15:39:24 / cg"
!

getDeviceCaps:hdc index:index
    <apicall: int "GetDeviceCaps" (handle int) module: "gdi32.dll" >

    "Created: / 24-12-2010 / 11:14:59 / cg"
!

iconSizes
    "Get the preferred/supported icon sizes."

    |d w h|

    w := self getSystemMetrics:#SM_CXICON.
    h := self getSystemMetrics:#SM_CYICON.

    d := IdentityDictionary new.
    d at:#minWidth put:w.
    d at:#maxWidth put:h.
    d at:#widthStep put:1.
    d at:#minHeight put:w.
    d at:#maxHeight put:h.
    d at:#heightStep put:1.

    ^ OrderedCollection with:d

    "
     Display iconSizes
    "

    "Modified: / 08-09-2006 / 15:40:18 / cg"
!

monitorBoundsAt:aPoint
    "answer the bounds of the monitor the point is contained in"

    |monitorHandle monitorInfo|

    self numberOfMonitors > 1 ifTrue:[
	"/ ******* MULTI SCREEN ******
	monitorHandle := self monitorHandleForPoint:aPoint.
	monitorHandle notNil ifTrue:[
	    monitorInfo := self monitorInfoFor:monitorHandle.
	    monitorInfo notNil ifTrue:[
		^ monitorInfo bounds
	    ].
	].
    ].
    ^ super monitorBoundsAt:aPoint

    "
     Display monitorBoundsAt:100@100
     Display monitorBoundsAt:2000@100
     Display monitorBoundsAt:-200@100
    "

    "Modified: / 22-10-2010 / 10:55:59 / cg"
!

numberOfMonitors
    ^ self getSystemMetrics:#SM_CMONITORS

    "
     Display numberOfMonitors
    "
!

pointIsVisible:aPoint
    "is the point visible?"

    ^ (self monitorHandleForPoint:aPoint) notNil
!

pointsAreOnSameMonitor:point1 and:point2
    "are the two points on the same (multi-screen) monitors?"

    ^ (self monitorHandleForPoint:point1) = (self monitorHandleForPoint:point2)
!

preferredIconSize
    "Get the preferrered icon size.
     Here, workaround windows (bug?) which returns 32@32
     although, 20@20 is much nicer"

    ^ 20@20

    "
     Display preferredIconSize
    "

    "Modified: / 28.9.1998 / 13:49:54 / cg"
!

scrollsAsynchronous
    "return true, if this display asynchronously sends expose events after a
     scroll operation. False otherwise. Asynchronous expose events are an X11
     speciality, which affects a few methods outside of the display class (sorry)
     However, the underlying WinWorkstation code simulates this behavior,
     so we return true here as well."

    ^ true.
!

smallestMonitorHeight
    "returns the usable height of the smallest monitor in a mult-monitor setup"

    |info minH|

    minH := self usableHeight.
    self monitorHandles do:[:eachHandle |
	info := self monitorInfoFor:eachHandle.
	info notNil ifTrue:[ minH := minH min: info workHeight ].
    ].
    ^ minH

    "
     Display smallestMonitorHeight
    "

    "Modified: / 22-10-2010 / 15:34:44 / cg"
!

supportedImageFormats
    "return an array with supported image formats; each array entry
     is another array, consisting of depth and bitsPerPixel values."

    |info|

    info := IdentityDictionary new.
    info at:#depth put:depth.
    info at:#bitsPerPixel put:depth.
    info at:#padding put:32.
    ^ Array with:info

    "
     Disply supportedImageFormats
    "

    "Modified: / 10.9.1998 / 23:14:05 / cg"
!

supportsDeepIcons
    "return true, if this device supports deepicons."

    ^ true
!

supportsIconMasks
    "return true, if this device supports masked icons.
     For now, return false since somehow icons are inverted
     if we use masks (and I dont know yet why)."

    ^ false

    "
     Display supportsIconMasks
    "

    "Modified: / 28.4.1999 / 19:59:17 / cg"
!

supportsIconViews
    "return true, if this device supports views as icons."

    ^ false "/ true

    "
     Display supportsIconViews
    "

    "Modified: 10.6.1996 / 20:11:48 / cg"
    "Created: 10.6.1996 / 21:08:18 / cg"
!

supportsMaskedDrawingWith:aForm
    "return true, if the device allows the given form pixmap
     to be used as paint color."

    ^ self supportsAnyViewBackgroundPixmaps

    "Created: / 4.5.1999 / 12:48:49 / cg"
    "Modified: / 4.5.1999 / 12:58:31 / cg"
!

supportsViewBackgroundPixmap:aForm
    "return true, if the device allows the given pixmap as
     viewBackground. If false is returned,
     drawing is done by (possibly) slower smalltalk code."

    ^ true
!

supportsWindowBorder:aNumber
    "return true, if this device supports bordered windows.
     Right now, some drawing stuff depends on (at least) a border of 1 pixel
     to be supported by the device.
     ST/X's views are being rewritten to draw the border manually in the
     future. (Windows only supports borders 1 and noBorder)"

    ^ (aNumber ? 0) <= 1

    "
     Display supportsWindowBorder:1
    "
!

usableExtent
    "return the usable extent of the display (in pixels).
     Normally, the same as extent, but may be smaller, in
     case some menu space is taken up by the window manager (windows),
     or bigger, in case of multi-screen systems"

    |wSingle hSingle w h dx dy|

    w := wSingle := self getSystemMetrics:#SM_CXFULLSCREEN.
    h := hSingle := self getSystemMetrics:#SM_CYFULLSCREEN.

    (self numberOfMonitors) > 1 ifTrue:[
	w := self getSystemMetrics:#SM_CXVIRTUALSCREEN.
	h := self getSystemMetrics:#SM_CYVIRTUALSCREEN.
	(w isNil or:[h isNil]) ifTrue:[
	    "/ not supported under win95 and win-nt4 - fallback to real extent
	    w := wSingle.
	    h := hSingle.
	] ifFalse:[
	    dx := (self getSystemMetrics:#SM_CXSCREEN) - wSingle.
	    dy := (self getSystemMetrics:#SM_CYSCREEN) - hSingle.
	    w := w - dx.
	    h := h - dy - 8.
	].
    ].
    ^ w @ h.

    "
     Display usableExtent
     Display getSystemMetrics:#SM_CYVIRTUALSCREEN
     Display getSystemMetrics:#SM_CYFULLSCREEN
     Display getSystemMetrics:#SM_CYSCREEN
     Display getSystemMetrics:#SM_CMONITORS
    "

    "Modified: / 08-09-2006 / 18:19:22 / cg"
!

usableHeightAt:aPoint
    "returns the usable height of the display (in pixels) at a given point
     Normally, the same as height, but may be smaller, in
     case some menu space is taken up by the window manager (windows).
     On multi-display systems with different sized screens, this should care for
     which display is at the given x-position"

    |info fullHeight usableHeight delta|

    true "(self numberOfMonitors) > 1" ifTrue:[
	"/ ******* MULTI SCREEN ******
	info := self monitorInfoFor:(self monitorHandleForPoint:aPoint).
	info notNil ifTrue:[
	    ^ info workHeight

	"/ only works with single screen..
"/            fullHeight := self getSystemMetrics:#SM_CYVIRTUALSCREEN.
"/            usableHeight := self getSystemMetrics:#SM_CYFULLSCREEN.  "/ without any start-menu bar
"/            delta := fullHeight - usableHeight.
"/            ^ info workHeight - delta
	].
    ].
    ^ self usableHeight

    "
     Display numberOfMonitors

     Display usableHeight

     Display usableHeightAt:100@100
     Display usableHeightAt:2000@100
     Display usableHeightAt:-200@100
    "

    "Modified (comment): / 27-10-2012 / 13:34:32 / cg"
! !

!WinWorkstation methodsFor:'bitmap/window creation'!

addMenuItemWithLabel:aString toWindowID:aWindowId
    "not yet"
%{
#ifdef NOT_YET_IMPLEMENTED
    if (__isExternalAddress(aWindowId)) {
	HWND hWin = _HWNDVal(aWindowId);
	HMENU hMenu;

	hMenu = GetMenu(hWin);
	if (hMenu) {

	}
    }
#endif
%}
!

createBitmapFromArray:anArray width:w height:h
    |bitmapId|

    bitmapId := self primCreateBitmapFromArray:anArray width:w height:h.

    bitmapId isNil ifTrue:[
	'WINWORKSTATION: cannot create bitmap' errorPrintCR.
    ].
    ^ bitmapId
!

createBitmapWidth:w height:h

%{
    HANDLE newBitmapHandle;
    int b_width, b_height;

    if (__bothSmallInteger(w, h)) {
	b_width = __intVal(w);
	b_height = __intVal(h);
	newBitmapHandle = CreateBitmap(b_width, b_height, 1, 1, NULL);

	if (newBitmapHandle) {
#ifdef COUNT_BMP_RESOURCES
	    __cnt_bitmap++;
	    RES_BMP_PRINTF(("CreateBitmap %x %d\n",newBitmapHandle, __cnt_bitmap));
#endif
	    RETURN ( __MKOBJ(newBitmapHandle));
	}
	DPRINTF(("empty bitmap handle = %x\n", newBitmapHandle));
    }
    RETURN (nil);
%}
!

createPixmapWidth:w height:h depth:d
    "allocate a pixmap on the Xserver, the contents is undefined
     (i.e. random). Return a bitmap id or nil"

%{
    HANDLE newBitmapHandle;

    /*console_printf("CreateBitmap Color\n");*/
    if (__bothSmallInteger(w, h) && __isSmallInteger(d) && ISCONNECTED) {
	if (__intVal(d) == 1) {
	    newBitmapHandle = CreateBitmap(__intVal(w), __intVal(h) , 1, 1, NULL);
	} else {
#if 0
	    if (__intVal(d) != __depth) {
		console_printf("invalid depth\n");
		RETURN (nil);
	    }
#endif
	    newBitmapHandle = CreateCompatibleBitmap(__rootDC, __intVal(w), __intVal(h) );
	}

	if (newBitmapHandle) {
#ifdef COUNT_BMP_RESOURCES
	    __cnt_bitmap++;
	    RES_BMP_PRINTF(("CreatePixmap %x %d\n",newBitmapHandle, __cnt_bitmap));
#endif
	    RETURN ( __MKOBJ(newBitmapHandle));
	}
	DPRINTF(("empty bitmap handle = %x\n", newBitmapHandle));
    }
    RETURN (nil);
%}
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
		 icon:wicon
		 iconMask:wiconMaskArg
		 iconView:wiconView


    |xpos ypos wwidth wheight minWidth minHeight maxWidth maxHeight
     wsuperViewId wiconId wiconMask invertedWiconMask wiconMaskId windowId
     weventMask wiconWidth wiconHeight windowType windowClass moreArgs|

    "/ bColorId wiconViewId bitGravity vBgColor vBgForm deepForm
    "/  preferredVisual preferredDepth  viewGravity wcursorId

    displayId isNil ifTrue:[
	self primitiveFailed.
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
	wwidth := 100.
	wheight := 40.
    ].
    minExt notNil ifTrue:[
	minWidth := minExt x.
	minHeight := minExt y
    ] ifFalse:[
	minWidth := 1.
	minHeight := 1.
    ].

    maxExt notNil ifTrue:[
	maxWidth := maxExt x.
	maxHeight := maxExt y
    ] ifFalse:[
	"/ this is not really a good idea
	"/ maxWidth := width.
	"/ maxHeight := height.
    ].

    wsuperView notNil ifTrue:[
	wsuperViewId := wsuperView id
    ].

    wicon notNil ifTrue:[
	wiconId := wicon id.
	wiconHeight := wicon height.
	wiconWidth  := wicon width.
	wiconMask := wiconMaskArg.
	wiconMask isNil ifTrue:[
	    wiconMask := wicon mask.
	].
	wiconMask notNil ifTrue:[
	    "/ WIN32's mask has zeros for opaque pixels
	    invertedWiconMask := wiconMask copy.
	    invertedWiconMask bits invert.
	    invertedWiconMask := invertedWiconMask onDevice:self.
	    wiconMaskId := invertedWiconMask id
	].
    ].
"/    wiconView notNil ifTrue:[
"/        wiconViewId := wiconView id
"/    ].
    weventMask := aView eventMask.

    NativeWidgets ifTrue:[
	windowType := aView nativeWindowType.
	windowType notNil ifTrue:[
	    "/ must be a symbol and is used
	    "/ as a key into the nativeClass translation map.

	    windowClass := NativeWidgetClassTable at:windowType ifAbsent:windowType.
	    self class debugNative ifTrue:[
		'WinWorkstation [info]: windowType: ' infoPrint. windowType infoPrint.
		' windowClass: ' infoPrint. windowClass infoPrintCR.
	    ].
	].
    ].
    aView isMDIClientView ifTrue:[
	windowClass := 'mdiclient'.
    ].

    windowClass notNil ifTrue:[
	aView beNativeWidget.
    ] ifFalse:[
	aView beNonNativeWidget.
    ].

    moreArgs := Array new:20.
    moreArgs at:1 put:xpos.
    moreArgs at:2 put:ypos.
    moreArgs at:3 put:wwidth.
    moreArgs at:4 put:wheight.
    moreArgs at:5 put:minWidth.
    moreArgs at:6 put:minHeight.
    moreArgs at:7 put:maxWidth.
    moreArgs at:8 put:maxHeight.
    moreArgs at:9 put:wsuperViewId.
    moreArgs at:10 put:nil. "/ wcursorId.
    moreArgs at:11 put:wiconId.
    moreArgs at:12 put:wiconMaskId.
    moreArgs at:13 put:wiconWidth.
    moreArgs at:14 put:wiconHeight.
    moreArgs at:15 put:windowType.
    moreArgs at:16 put:windowClass.
    moreArgs at:17 put:weventMask.
    moreArgs at:18 put:(aView className asString).

    [
      windowId := self
		  primCreateWindowFor:aView
		  type:typeSymbol
		  borderWidth:bWidth
		  subViewOf:wsuperView
		  style:wStyle
		  inputOnly:winputOnly
		  label:wlabel
		  owner:wowner
		  icon:wicon
		  iconMask:wiconMask
		  moreArgs:moreArgs.
      aView graphicsContext setId:windowId.
    ] valueUninterruptably.

    windowId notNil ifTrue:[
        self addKnownView:aView withId:windowId.
        (aView windowStyle == #toolWindow) ifTrue:[ 
            self raiseWindowToTopMost: aView id.  
        ].  
    ].
    ^ windowId

    "Modified: / 28-01-2012 / 10:20:30 / cg"
    "Modified: / 25-01-2018 / 10:19:46 / jv"
!

dcGetClipBoxForGC: gcId
	"Return clipping box for given device context (as  #(left top right bottom) ). "

	| error |
%{
    if (__isExternalAddress(gcId)) {	
        struct gcData *gc = _GCDATA(gcId);
        HDC hDC;
        RECT clipbox;
        OBJ arr;   
        if (! gc->_hDC) {
            hDC = _getDC(gc);            
            gc->_hDC = hDC;
        } else {
            hDC = gc->_hDC;
        }
        clipbox.left = -1;
        clipbox.top = -1;
        clipbox.right = -1;
        clipbox.bottom = -1;
        GetClipBox(hDC, &clipbox);
        arr = __ARRAY_NEW_INT(4);
        __ArrayInstPtr(arr)->a_element[0] = __MKSMALLINT(clipbox.left);
        __ArrayInstPtr(arr)->a_element[1] = __MKSMALLINT(clipbox.top);
        __ArrayInstPtr(arr)->a_element[2] = __MKSMALLINT(clipbox.right);
        __ArrayInstPtr(arr)->a_element[3] = __MKSMALLINT(clipbox.bottom);
        RETURN ( arr );

    }
    error = @symbol(BadArg1);
    err:;    
%}.
	^ self primitiveFailed: error
!

dcLockForGC:gcId
    "Locks and return a device context for given GC.
     Returned DeviceContext is associated with given GC and it's
     guaranteed not to be destroyed (by ReleaseDC()) until
     #dcUnlockForGC: is called. 

     NOTE: The DC __is__ destroyed, however, when the whole
     GC is destroyed."

     | error |
%{
    if (__isExternalAddress(gcId)) {
        struct gcData *gc = _GCDATA(gcId);
        HDC hDC;
        if (! gc->_hDC) {
            hDC = _getDC(gc);            
            gc->_hDC = hDC;
        } else {
            hDC = gc->_hDC;
        }
        gc->doNotCacheOrRelease = 1;
        RETURN ( __MKEXTERNALADDRESS ( hDC ) );
    }
    error = @symbol(BadArg1);
    err:;
%}.
    ^ self primitiveFailed: error
!

dcUnlockForGC:gcId
    "Unlocks and __destroy__ a device context for given GC previously
     locked by #dcLockForGC:. If the GC was not locked,
     calling this method is no-op."

     | error |
%{
    if (__isExternalAddress(gcId)) {
        struct gcData *gc = _GCDATA(gcId);                
        if (gc->hWnd) {
            gc->doNotCacheOrRelease = 0;
            if (gc->_hDC) {                        
                _releaseDC(gc);
            }                    
        }
        RETURN ( nil );
    }
    error = @symbol(BadArg1);
    err:;
%}.
    ^ self primitiveFailed: error
!

destroyGC:aGCId
%{
    if (__isExternalAddress(aGCId)) {
	struct gcData *gcData = _GCDATA(aGCId);

	if (gcData == NULL) {
	    console_fprintf(stderr, "WinWorkstation [warning]: trying to destroy GC twice\n");
	    RETURN(self);
	}

#ifdef COUNT_RESOURCES
	 __cnt_gcData--;
	RESPRINTF(("DestroyGcData %d\n",__cnt_gcData));
#endif

#ifdef CACHE_LAST_DC
	if (lastGcData == gcData) {
	    _releaseDC(gcData);
	}
#endif
	__ExternalAddressInstPtr(aGCId)->e_address = NULL;

	freeGcData(gcData);
    }
%}
!

destroyPixmap:aDrawableId

%{  /* NOCONTEXT */
    if (__isExternalAddress(aDrawableId) && ISCONNECTED) {
	HANDLE bitmapHandle = _HANDLEVal(aDrawableId);

	if (bitmapHandle) {
#ifdef COUNT_BMP_RESOURCES
	    __cnt_bitmap--;
	    RES_BMP_PRINTF(("DestroyPixmap %x %d\n", bitmapHandle, __cnt_bitmap));
#endif
	    _DeleteObject(bitmapHandle, __LINE__);
	}
    }
%}
!

destroyView:aView withId:aWindowId
    self primDestroyView:aView withId:aWindowId.
    self removeKnownView:aView withId:aWindowId
!

gcFor:aDrawableId

%{  /* NOCONTEXT */
    HWND hWnd;
    struct gcData *gcData;

    if (__isExternalAddress(aDrawableId)) {
	hWnd = _HWNDVal(aDrawableId);

	if (! hWnd) {
	    RETURN (nil);
	}

	gcData = newGcData();
	if (! gcData) {
	    RETURN (nil);
	}

#ifdef COUNT_RESOURCES
	__cnt_gcData++;
	RESPRINTF(("CreateGcData %d\n",__cnt_gcData));
#endif
	gcData->hWnd = hWnd;
	gcData->_hDC = 0;
	CPRINTF(("gcFor hDC=%x hWnd=%x\n",gcData->_hDC,gcData->hWnd));
	RETURN ( __MKOBJ(gcData) );
    }
    RETURN (nil);
%}
!

gcForBitmap:aDrawableId

%{  /* NOCONTEXT */

    if (__isExternalAddress(aDrawableId)) {  /* HBITMAP */
	struct gcData *gcData;
	BITMAP bitmap;
	HBITMAP hBitmap = _HBITMAPVAL(aDrawableId);
	HDC hDC;

	if (! hBitmap) {
	    RETURN (nil);
	}
	gcData = newGcData();
	if (! gcData) {
	    RETURN (nil);
	}

	if (GetObject(hBitmap, sizeof(bitmap), &bitmap)) {
	    DDDDPRINTF(("bitmap info:%d\n", bitmap.bmBitsPixel));
	} else {
	    DPRINTF(("noinfo returned for bitmap\n"));
	    /* mhmh - can this happen ? */
	    bitmap.bmBitsPixel = 1;
	}
	gcData->hBitmap = hBitmap;
	gcData->bitmapColorBitCount = bitmap.bmBitsPixel;

#ifdef COUNT_RESOURCES
	__cnt_gcData++;
	RESPRINTF(("CreateGcData %d\n", __cnt_gcData));
#endif
	RETURN ( __MKOBJ(gcData) );
    }
    RETURN (nil);
%}
!

gcForHDC: aDeviceContextHandle

%{  /* NOCONTEXT */
    HDC hDC;
    struct gcData *gcData;

    if (__isExternalAddressLike(aDeviceContextHandle)) {
	hDC = _HDCVal(aDeviceContextHandle);

	if (! hDC) {
	    RETURN (nil);
	}

	gcData = newGcData();
	if (! gcData) {
	    RETURN (nil);
	}

#ifdef COUNT_RESOURCES
	__cnt_gcData++;
	RESPRINTF(("CreateGcData %d\n",__cnt_gcData));
#endif
	gcData->_hDC = hDC;
	gcData->doNotCacheOrRelease = 1;
	CPRINTF(("gcFor hDC=%x hWnd=%x\n",gcData->_hDC,gcData->hWnd));
	RETURN ( __MKOBJ(gcData) );
    }
    RETURN (nil);
%}
!

primCreateBitmapFromArray:anArray width:w height:h
%{

    HBITMAP newBitmapHandle;
    int b_width, b_height, bytesPerRowST, bytesPerRowWN, padding;
    int row, col;
    unsigned char *cp, *bPits;
    unsigned char *b_bits = 0;
    int index;
    OBJ num;
    unsigned char *allocatedBits = 0;
    unsigned char fastBits[10000];

    if (__bothSmallInteger(w, h) && __isNonNilObject(anArray)) {
	b_width = __intVal(w);
	b_height = __intVal(h);
	bytesPerRowST = (b_width + 7) / 8;
	bytesPerRowWN = ((b_width + 15) / 16) * 2;
	padding = bytesPerRowWN - bytesPerRowST;

	if ((padding == 0) && (__isByteArrayLike(anArray))) {
	    b_bits = __ByteArrayInstPtr(anArray)->ba_element;
	    cp = 0;
	} else {
	    int nBytes = b_height * bytesPerRowWN;

	    if (nBytes < sizeof(fastBits)) {
		cp = b_bits = fastBits;
	    } else {
		cp = b_bits = allocatedBits = (unsigned char *) malloc(nBytes);
		if (! cp) goto fail;
	    }
	}
	if (cp) {
	    if (__qIsArrayLike(anArray)) {
		OBJ *op;

		index = 1;
		op = &(__ArrayInstPtr(anArray)->a_element[index - 1]);
		for (row = b_height; row; row--) {
		    for (col = bytesPerRowST; col; col--) {
			num = *op++;
			if (! __isSmallInteger(num))
			    goto fail;
			*cp++ = __intVal(num);
		    }
		    cp += padding;
		}
	    } else if (__qIsByteArrayLike(anArray)) {
		unsigned char *pBits;

		pBits = __ByteArrayInstPtr(anArray)->ba_element;
		for (row = b_height; row; row--) {
		    for (col = bytesPerRowST; col; col--) {
			*cp++ = ( *pBits++ /*^ 0xFF*/ );
		    }
		    cp += padding;
		}
	    } else {
		goto fail;
	    }
	}
	CPRINTF(("create bitmap ...\n"));

	newBitmapHandle = CreateBitmap(b_width, b_height, 1, 1, b_bits );

	if (newBitmapHandle ) {
#ifdef COUNT_BMP_RESOURCES
	    __cnt_bitmap++;
	    RES_BMP_PRINTF(("CreateBitmap %x %d\n",newBitmapHandle,__cnt_bitmap));
#endif
	    DDDDPRINTF(("returning bitmap %x ...\n", newBitmapHandle));
	    if (allocatedBits) {
		free(allocatedBits);
	    }
	    RETURN ( __MKEXTERNALADDRESS(newBitmapHandle));
	}
    }
fail: ;
    DDPRINTF(("create bitmap FAILED!!!\n"));
    if (allocatedBits) {
	CPRINTF(("freeing up bitmap bits ...\n"));
	free(allocatedBits);
    }
    CPRINTF(("returning nil ...\n"));
    RETURN ( nil );
%}
!

primCreateWindowFor:aView type:typeSymbol
	  borderWidth:bWidth subViewOf:wsuperView
	  style:wStyle inputOnly:winputOnly
	  label:wlabel owner:wowner
	  icon:wicon iconMask:wiconMask
	  moreArgs:moreArgs

%{  /* STACK: 16000 */

    WNDCLASSW wc;
    long bg, bd, bw;
    int winStyleBits, winEXStyleBits;
    int w, h, x, y;
    int min_width, min_height;
    int max_width, max_height;
    OBJ eventMask;
    RECT rec;
    HANDLE parentHandle;
    HWND newWindowHandle;
    OBJ xpos, ypos, wwidth, wheight;
    OBJ minWidth, minHeight, maxWidth, maxHeight;
    OBJ wsuperViewId, wcursorId, wiconId, wiconMaskId;
    OBJ wiconWidth, wiconHeight;
    OBJ windowType, windowClass, windowId;
    OBJ stClassName;
    int isTopWindow = 0, isNativeWindow = 0, isMDIChild = 0;
    localWindowInfo *lI;
    static createWindowInfo cwi;
    static int nextSequenceNr = 1;
    unsigned char* cp;
    HBITMAP        xBitMap, maskBitmap;
    HICON          xIcon = (HICON)0;
    ICONINFO       iconInfo;
    char *className;

#   define MAX_LABEL_SIZE       256
#   define MAX_CLASSNAME_SIZE   256
    static wchar_t classNameBufferw[MAX_CLASSNAME_SIZE];
    static wchar_t windowNameBufferw[MAX_LABEL_SIZE];
    unsigned char fastBits[10000];

    xpos = __ArrayInstPtr(moreArgs)->a_element[0];
    ypos = __ArrayInstPtr(moreArgs)->a_element[1];
    wwidth = __ArrayInstPtr(moreArgs)->a_element[2];
    wheight = __ArrayInstPtr(moreArgs)->a_element[3];
    minWidth = __ArrayInstPtr(moreArgs)->a_element[4];
    minHeight = __ArrayInstPtr(moreArgs)->a_element[5];
    maxWidth = __ArrayInstPtr(moreArgs)->a_element[6];
    maxHeight = __ArrayInstPtr(moreArgs)->a_element[7];
    wsuperViewId = __ArrayInstPtr(moreArgs)->a_element[8];
    wcursorId = __ArrayInstPtr(moreArgs)->a_element[9];
    wiconId = __ArrayInstPtr(moreArgs)->a_element[10];
    wiconMaskId = __ArrayInstPtr(moreArgs)->a_element[11];
    wiconWidth = __ArrayInstPtr(moreArgs)->a_element[12];
    wiconHeight = __ArrayInstPtr(moreArgs)->a_element[13];
    windowType = __ArrayInstPtr(moreArgs)->a_element[14];
    windowClass = __ArrayInstPtr(moreArgs)->a_element[15];
    eventMask = __ArrayInstPtr(moreArgs)->a_element[16];
    stClassName = __ArrayInstPtr(moreArgs)->a_element[17];
    bg = WhitePixel;
    bd = BlackPixel;

    /* get bitmap for icon */
    if ( __isExternalAddress(wiconId) ) {
	xBitMap = _HBITMAPVAL( wiconId );
	if ( xBitMap != 0 ) {
	    BITMAP bm;

	    if (GetObject(xBitMap, sizeof(bm), (LPSTR)&bm)) {
		int d = bm.bmPlanes * bm.bmBitsPixel;
		BYTE *ep;
		int height, width;
		int nBytes;
		unsigned char *allocatedBits = 0;
		int privateMask = 0;

		if ( __isExternalAddress(wiconMaskId) ) {
		    maskBitmap = _HBITMAPVAL( wiconMaskId );
		} else {
		    if (wiconMaskId != nil) {
			PRINTF(("WinWorkstat [warning]: wiconMaskId is not an external address\n"));
		    }
		    maskBitmap = 0;
		}

		/*
		 * if there is no mask, generate one
		 */
		if (maskBitmap == 0) {
		    DPRINTF(("Bitmap w:%d h:%d p:%d d:%d\n",bm.bmWidth,bm.bmHeight,bm.bmPlanes,bm.bmBitsPixel));
		    height = __intVal( wiconHeight );
		    width  = __intVal( wiconWidth  );
		    nBytes = ( width + 15 ) / 8;
		    nBytes = height * nBytes;
		    if (nBytes < sizeof(fastBits)) {
			ep = fastBits;
		    } else {
			ep = allocatedBits = (unsigned char *) malloc(nBytes);
		    }
		    if ( ep == 0 ) {
			PRINTF(( "WinWorkstat [warning]: malloc failed\n" ));
		    } else {
			memset(ep, 0, nBytes);
			maskBitmap = CreateBitmap(width, height, 1, 1, ep );
			if ( maskBitmap == NULL ) {
			    PRINTF(( "WinWorkstat [warning]: mask CREATION failed\n" ));
			} else {
			    privateMask = 1;
			}
		    }
		}
		if ( maskBitmap != NULL ) {
		    DPRINTF(( "BITMAP mask CREATED!!!\n" ));
		    iconInfo.fIcon = TRUE;
		    iconInfo.hbmMask  = maskBitmap;
		    iconInfo.hbmColor = xBitMap;
		    xIcon = CreateIconIndirect( &iconInfo );
		    if (privateMask) {
			_DeleteObject( maskBitmap, __LINE__ );
		    }
		} else {
		    PRINTF(( "WinWorkstat [warning]: no mask for icon !\n" ));
		}

		if (allocatedBits) {
		    free(allocatedBits);
		}
	    }
	} else {
	    DPRINTF(("WinWorkstat [warning]: xBitMap is zero \n" ));
	}
    } else {
	if (wiconId != nil) {
	    PRINTF(("WinWorkstat [warning]: wiconId is not an external address\n"));
	}
    }

    if (__bothSmallInteger(wwidth, wheight)) {
	w = __intVal(wwidth);
	h = __intVal(wheight);
    } else {
	w = h = 100;
    }

    if (__bothSmallInteger(xpos, ypos)) {
	x = __intVal(xpos);
	y = __intVal(ypos);
    } else {
	x = y = 0;
    }

    if (__bothSmallInteger(minWidth, minHeight)) {
	min_width = __intVal(minWidth);
	min_height = __intVal(minHeight);
    } else {
	DPRINTF(("WinWorkstat [warning]: minWidth/minHeight not integer\n"))
	min_width = min_height = 0;
    }

    if (__bothSmallInteger(maxWidth, maxHeight)) {
	max_width = __intVal(maxWidth);
	max_height = __intVal(maxHeight);
    } else {
	DPRINTF(("WinWorkstat [warning]: maxWidth/maxHeight not integer\n"))
	max_width = max_height = 10000;
    }

    winStyleBits = winEXStyleBits = 0;

    if (__isSmallInteger(bWidth)) {
	bw = __intVal(bWidth);
	if (bw) {
	    winStyleBits |= WS_BORDER;
	    bw = 1;
	}
    } else {
	bw = 0;
    }

    className = app_name;
    if (__isStringLike(windowClass)) {
	className = __stringVal(windowClass);
	NDPRINTF(("className: %s\n", className));

	if (__isInteger(wStyle)) {
	    isNativeWindow = 1;
	    winStyleBits |= __longIntVal(wStyle);
	    NDPRINTF(("winStyleBits: %x\n", winStyleBits));
	} else {
	    if (windowType != nil) {
		if (windowType == @symbol(RadioButton)) {
		    isNativeWindow = 1;
		    winStyleBits |= BS_RADIOBUTTON;
		    NDPRINTF(("class: %s - winStyleBits BS_RADIOBUTTON: %x\n", className, winStyleBits));
		} else if (windowType == @symbol(CheckBox)) {
		    isNativeWindow = 1;
		    winStyleBits |= BS_CHECKBOX;
		    NDPRINTF(("class: %s - winStyleBits BS_CHECKBOX: %x\n", className, winStyleBits));
		} else if (windowType == @symbol(HorizontalScrollBar)) {
		    isNativeWindow = 1;
		    winStyleBits |= SBS_HORZ;
		    NDPRINTF(("class: %s - winStyleBits SBS_HORZ: %x\n", className, winStyleBits));
		} else if (windowType == @symbol(VerticalScrollBar)) {
		    isNativeWindow = 1;
		    winStyleBits |= SBS_VERT;
		    NDPRINTF(("class: %s - winStyleBits SBS_VERT: %x\n", className, winStyleBits));
		} else if (windowType == @symbol(Button)) {
		    isNativeWindow = 1;
		    NDPRINTF(("class: %s\n", className));
		} else if (windowType == @symbol(OwnerDrawButton)) {
		    isNativeWindow = 1;
		    winStyleBits |= BS_OWNERDRAW;
		    NDPRINTF(("class: %s - winStyleBits BS_OWNERDRAW: %x\n", className, winStyleBits));
		}
	    }
	}
    }

    if (__isExternalAddress(wsuperViewId)) {
	/*
	 * a child window
	 */
	parentHandle = _HANDLEVal(wsuperViewId);
	if (wStyle == @symbol(mdiChild)) {
	    isMDIChild = 1;
	}
    } else {
	parentHandle = NULL;
	isTopWindow = 1;
    }

    if (!isTopWindow && !isMDIChild) {
	/*
	 * a child window
	 */
	winStyleBits |= WS_CHILD;
	if (winputOnly != true) {
	    winStyleBits |= (WS_CLIPSIBLINGS | WS_CLIPCHILDREN);
	    /*winStyleBits |= WS_CLIPCHILDREN;*/
	    DPRINTF(("parent handle=%x\n", parentHandle));
	} else {
	    winEXStyleBits |= WS_EX_TRANSPARENT;
	    DPRINTF(("inputview parent handle=%x\n", parentHandle));
	}
#if 0
	winEXStyleBits |= WS_EX_NOPARENTNOTIFY;
#endif
    } else {
	/*
	 * a top window (regular / popUp / dialog) or MDIChild
	 */
	if (isMDIChild) {
	    winEXStyleBits |= WS_EX_MDICHILD;
	}

	if (! isMDIChild)
	{
#ifdef TOPWINDOWCLASS
	    this could fail, since a pointer to local buf is passed
	    to the window-creation code (in the other thread ...)

	    static winCount = 1;
	    char buf[300];
	    char *stName;

# ifdef __BORLANDC__
	    struct timeb timebuffer;
	    ftime(&timebuffer);
# else
	    struct _timeb timebuffer;
	    _ftime(&timebuffer);
# endif

	    if (__isStringLike(stClassName)) {
		stName = __stringVal(stClassName);
	    } else {
		stName = app_name;
	    }
	    sprintf(buf, "S%d.%d%s", HIWORD(timebuffer.time), ++winCount, stName);
	    DPRINTF(("topview - registerClass:%s\n",buf));

	    wc.style = /* CS_HREDRAW | CS_VREDRAW | CS_OWNDC  |*/ CS_DBLCLKS;
	    wc.lpfnWndProc = (WNDPROC) MainWndProc;
	    wc.cbClsExtra = 0;
	    wc.cbWndExtra = N_WINDOW_PRIVATE;
	    wc.hInstance = (HANDLE) __getHInstance();
	    if (xIcon) {
		wc.hIcon   = xIcon;
		/* wc.hIconSm = wiconId; In 4.x there are large and small icons */
	    } else {
		wc.hIcon = NULL;        /* THIS MUST BE NULL TO DELETE ICONS */
	    }
	    wc.hCursor = 0 /* LoadCursor(NULL, IDC_ARROW) */;
	    wc.hbrBackground = 0; /*CreateSolidBrush (bg);*/

	    wc.lpszMenuName =  NULL;
	    wc.lpszClassName = buf;

	    if (!RegisterClass(&wc)) {
		PRINTF(("RegisterClass failed\n"));
		RETURN( nil );
	    }

	    className = buf;
#endif /* TOPWINDOWCLASS */
	}

	if (wStyle == @symbol(popUp)) {
	    winStyleBits |= WS_POPUP;
	    // winStyleBits |= WS_DISABLED;
	    winEXStyleBits |= WS_EX_TOOLWINDOW;
	    CPRINTF(("Create popUpWindow\n"));
#if 0
	    parentHandle = GetActiveWindow();
#endif
	} else if (wStyle == @symbol(popUpWithFrame)) {
	    winStyleBits |= WS_POPUP | WS_THICKFRAME /* | WS_CAPTION | DS_MODALFRAME | WS_SIZEBOX */ ;
	    // winStyleBits |= WS_DISABLED;
	    // winEXStyleBits |= WS_EX_TOOLWINDOW;
	    CPRINTF(("Create popUpWindow\n"));
#if 0
	    parentHandle = GetActiveWindow();
#endif

	} else if ((wStyle == @symbol(dialog)) || (wStyle == @symbol(toolDialog))) {
	    winStyleBits |= WS_OVERLAPPED | WS_CAPTION | DS_MODALFRAME | WS_SYSMENU | WS_SIZEBOX;
	    winStyleBits |= WS_POPUP;
	    winStyleBits |= DS_NOIDLEMSG;
	    //winEXStyleBits |= WS_EX_TOOLWINDOW;
	    if ((min_width || min_height)
	     && (min_width == max_width)
	     && (min_height == max_height)) {
		winStyleBits &= ~WS_THICKFRAME;
	    }
	    if (wStyle == @symbol(toolDialog)) {
		winEXStyleBits |= WS_EX_TOOLWINDOW;
	    }
	} else if (wStyle == @symbol(undecorated)) {
	    winStyleBits |= WS_OVERLAPPED;
	    winEXStyleBits |= WS_EX_WINDOWEDGE;
	} else if (wStyle == @symbol(undecoratedResizable)) {
	    winStyleBits |= WS_OVERLAPPED | WS_THICKFRAME;
	    winEXStyleBits |= WS_EX_WINDOWEDGE;
	} else if (isMDIChild) {
	    winStyleBits |= WS_OVERLAPPED | WS_CAPTION | DS_MODALFRAME | WS_SYSMENU | WS_SIZEBOX;
	    if ((min_width || min_height)
	     && (min_width == max_width)
	     && (min_height == max_height)) {
		winStyleBits &= ~WS_THICKFRAME;
	    }
	} else {
	    //winStyleBits |= WS_OVERLAPPEDWINDOW;
	    winStyleBits |= WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_SIZEBOX;
	    //winEXStyleBits |= WS_EX_CLIENTEDGE;
	    winEXStyleBits |= WS_EX_WINDOWEDGE;
	    //winEXStyleBits |= WS_EX_ACCEPTFILES;

	    if (wStyle == @symbol(toolWindow)) {
		winEXStyleBits |= WS_EX_TOOLWINDOW;
	    }
	}
	winStyleBits |= WS_CLIPCHILDREN;
    }

    rec.left = x;
    rec.top = y;
    rec.right = x + w;
    rec.bottom = y+ h;

    /* use static memory for the createwindowInfo;
     * this is required, since we cannot pass the address of a local struct,
     * due to the possibility of late eventProcessing (after the method is left)
     * when in a sizeMove-loop.
     * (in this case, the message remains in the evQ, but is processed
     *  early via the pending- mechanism)
     * in order to detect such an alrady processed message, a sequenceNumber
     * is passed with the message and also stored in the cwi.
     * If this sequence number differs, we got a late message.
     */

    /*
     * check if previous request has been properly processed ...
     */
    if (cwi.sequenceNr && (cwi.sequenceNr != INVALIDATED_CWI)) {
	console_fprintf(stderr, "WinWorkstation [info]: oops - unprocessed createWindow still pending\n");
	/* this prevents the event processor from interpreting this message */
	cwi.sequenceNr = nextSequenceNr;
    }

    cwi.winStyleBitsEx = WS_EX_LEFT | WS_EX_NOPARENTNOTIFY | winEXStyleBits;

#ifdef ADJUSTWINDOW
    AdjustWindowRectEx(&rec, winStyleBits, 0, cwi.winStyleBitsEx);
    w = rec.right - rec.left;
    h = rec.bottom - rec.top;
#endif

    DPRINTF(("create%s pos==%d/%d size=%d/%d bw:%d parent:%x class:'%s' style:%x exStyle:%x ...\n",
		((wStyle == @symbol(popUp)) ? " popUp" : ""),
		x, y, w, h,
		bw, parentHandle, className,
		winStyleBits, winEXStyleBits));

    /* allocate localMemory for Window */
    lI = (localWindowInfo *) malloc(sizeof(localWindowInfo));
    if (! lI) {
	console_fprintf(stderr, "WinWorkstation [error]: malloc failed in CreateWindow\n");
	RETURN ( nil );
    }

    memset(lI, 0, sizeof(localWindowInfo));
    lI->mouseX = lI->mouseY = -9999;

    if (isTopWindow) {
/****** MULTI SCREEN   CATZKERN *********
	if (rec.left < 0) {
	    rec.left = 0;
	    rec.right = w;
	}
	if (rec.top < 0) {
	    rec.top = 0;
	    rec.bottom = h;
	}
****** MULTI SCREEN   CATZKERN *********/

	lI->flag |= LI_TOPWIN;
    } else {
	if (bw) {
	    // adjust for border
	    rec.left++;
	    rec.top++;
	}
    }

    if (winputOnly == true) {
	lI->flag |= LI_INPUTWIN;
    }
    if (isNativeWindow) {
	NDPRINTF(("set native flag\n"));
	lI->flag |= LI_NATIVEWIN;
    }

    if (wStyle == @symbol(popUp)) {
	cwi.className = wapp_namePopup;
    } else {
	if (wStyle == @symbol(dialog)) {
	    cwi.className = wapp_nameDialog;
	} else {
	    ch2wch(className, classNameBufferw, MAX_CLASSNAME_SIZE);
	    cwi.className = classNameBufferw;
	}
    }

    cwi.winStyleBits = winStyleBits;
    cwi.parentHandle = parentHandle;
    cwi.x = rec.left;
    cwi.y = rec.top;
    cwi.dx = rec.right - rec.left;
    cwi.dy = rec.bottom - rec.top;

    if (isTopWindow | isMDIChild) {
	rec.left = 0;
	rec.top = 0;
	rec.right = min_width;
	rec.bottom = min_height;
#ifdef ADJUSTWINDOW
	AdjustWindowRectEx(&rec, winStyleBits, 0, cwi.winStyleBitsEx);
#endif
	lI->minWidth = rec.right - rec.left;
	lI->minHeight = rec.bottom - rec.top;

	rec.left = 0;
	rec.top = 0;
	rec.right = max_width;
	rec.bottom = max_height;
#ifdef ADJUSTWINDOW
	AdjustWindowRectEx(&rec, winStyleBits, 0, cwi.winStyleBitsEx);
#endif
	lI->maxWidth = rec.right - rec.left;
	lI->maxHeight = rec.bottom - rec.top;
    } else {
	lI->minWidth = lI->minHeight = 0;
	lI->maxWidth = lI->maxHeight = 9999;
    }

    lI->viewBgBrush = __whiteBrush;
    lI->viewBgColor = WhitePixel;
    lI->bdColor = BlackPixel;

    if (__isSmallInteger(eventMask))
	lI->eventMask = __intVal(eventMask);
    else
	lI->eventMask = ~0;
    DPRINTF(("eventMask is %x\n", lI->eventMask));
#ifdef DEBUGMASK1
    printMask(lI->eventMask);
#endif

    lI->bw = bw;

    cwi.newWinHandle = newWindowHandle = NULL;
    cwi.windowName = 0;

    if (isTopWindow | isMDIChild) {
	if (__isStringLike(wlabel)) {
	    ch2wch((char *)__stringVal(wlabel), windowNameBufferw, MAX_LABEL_SIZE);
	    cwi.windowName = windowNameBufferw;
	} else
	    if (__isUnicode16String(wlabel)) {
		int l = __unicode16StringSize(wlabel);

		if (l >= MAX_LABEL_SIZE) l = MAX_LABEL_SIZE-1;
		memmove(windowNameBufferw, __unicode16StringVal(wlabel), l*sizeof(wchar_t));
		windowNameBufferw[ l ] = 0;
		cwi.windowName = windowNameBufferw;
	    }
    }

    cwi.infoWasRead = 0;
    cwi.localWindowInfo = lI;
    cwi.sequenceNr = nextSequenceNr;
    nextSequenceNr = (nextSequenceNr + 1) & 0x7FFF;

#ifndef NEW_CREATE_EVENT
    cwi.hCreateEvent = hCreateEvent;
    ResetEvent(cwi.hCreateEvent);
#else
    /* creating a new event does not work - why ? */
    cwi.hCreateEvent = CreateEvent(
	NULL,        /* no security attributes */
	FALSE,
	FALSE,
	NULL);       /* name of mutex */

    if (cwi.hCreateEvent == NULL) {
	console_fprintf(stderr, "WinWorkstation [error]: oops - CreateEvent failed in CreateWindow: %d\n", GetLastError() );
	cwi.sequenceNr = INVALIDATED_CWI;
	free(lI);
	RETURN ( nil );
    }
#endif

    /*
     * kludge to allow for createWindow while in sizeMove processing loop
     */
    if (pendingCREATEWINDOWInfo) {
	console_fprintf(stderr, "WinWorkstation [error]: oops - pending create\n");
    }
    pendingCREATEWINDOWInfo = &cwi;
    pendingSequenceNr = cwi.sequenceNr;

    if (PostThreadMessage(_dispatchThreadId, WM_THREAD_CREATEWINDOW, (INT)(cwi.sequenceNr), (INT)(&cwi)) == FALSE) {
	console_fprintf(stderr, "WinWorkstation [error]: oops - PostThreadMessage(%x) failed in CreateWindow: err=%d\n",
					_dispatchThreadId, GetLastError() );
	free(lI);
	RETURN (nil);
    }

    if (cwi.newWinHandle != NULL) {
	cwi.sequenceNr = INVALIDATED_CWI;
	cwi.hCreateEvent = NULL;
	/* wow - that was quick ... */
    } else {
	DWORD dwWaitResult;

	/* wait for the window to be created ... */
	dwWaitResult = WaitForSingleObject(hCreateEvent, 5000L);

	/* no longer want to get informed ... */
	cwi.hCreateEvent = NULL;
	cwi.sequenceNr = INVALIDATED_CWI;

	switch (dwWaitResult) {
	    // The thread got mutex ownership.
	    case WAIT_OBJECT_0:
		break;

	    // Cannot get mutex ownership due to time-out.
	    case WAIT_TIMEOUT:
		DEBUGFPRINTF((stderr, "WinWorkstation [error]: oops - timeout in CreateWindow\n"));
		break;

	    // Got ownership of the abandoned mutex object.
	    default:
		DEBUGFPRINTF((stderr, "WinWorkstation [warning]: CreateEvent abandoned\n"));
		break;
	}

#ifdef NEW_CREATE_EVENT
	CloseHandle(cwi.hCreateEvent);
#endif
    }

    pendingCREATEWINDOWInfo = 0;
    newWindowHandle = cwi.newWinHandle;
    DPRINTF(("handle = %x\n", newWindowHandle));

    if (! newWindowHandle) {
	console_fprintf(stderr, "WinWorkstation [error]: CreateWindow failed: %d (0x%x) [%d]\n",
			cwi.errCode, cwi.errCode, __LINE__ );
	if (cwi.infoWasRead) {
	    free(lI);
	} else {
	    console_fprintf(stderr, "WinWorkstation [warning]: localInfo memory leak [%d]\n", __LINE__ );
	}
	RETURN ( nil );
    }

#ifdef CACHE_LAST_DC
    if (lastGcData && (lastGcHWIN == newWindowHandle)) {
	_releaseDC(lastGcData);
    }
#endif
#ifdef CACHE_LAST_WM_PAINT_DC
    if (last_wm_paint_dc && (last_wm_paint_win == newWindowHandle)) {
	ReleaseDC(newWindowHandle, last_wm_paint_dc);
	last_wm_paint_win = last_wm_paint_dc = 0;
    }
#endif

    windowId = __MKOBJ(newWindowHandle);
#if 1
    if (isTopWindow | isMDIChild) {
	/*
	 * mhmh - what is that raise for ?
	 */
	SetWindowPos(newWindowHandle, HWND_TOP, 0, 0, 0, 0,
		     SWP_NOSENDCHANGING |
		     /* SWP_NOACTIVATE | */ SWP_NOMOVE | SWP_NOSIZE);
    } else {
	SetWindowPos(newWindowHandle, HWND_TOP, 0, 0, 0, 0,
		     SWP_NOSENDCHANGING |
		     SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE);
    }
#endif
    if (isTopWindow | isMDIChild) {
	BringWindowToTop(newWindowHandle);
    }
    DragAcceptFiles(newWindowHandle, 1);

    if (isNativeWindow) {
	if (winStyleBits & (SBS_HORZ | SBS_VERT)) {
	    SetScrollRange(newWindowHandle, SB_CTL, 0, 100, 0);
	    SetScrollPos(newWindowHandle, SB_CTL, 0, 0);
	}
    }

#ifndef TOPWINDOWCLASS
    if (xIcon) {
	SendMessage(newWindowHandle, WM_SETICON, (WPARAM)ICON_SMALL, (LPARAM)xIcon);
	SendMessage(newWindowHandle, WM_SETICON, (WPARAM)ICON_BIG, (LPARAM)xIcon);
    }
#endif

    DPRINTF(("done - create h=%x\n", newWindowHandle));
    RETURN (windowId);
%}
!

primDestroyView:aView withId:aWindowId

%{  /* NOCONTEXT */
    HICON oldIcon;

    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);

	if (win && IsWindow(win)) {
#ifndef TOPWINDOWCLASS
# ifdef _WIN64
	    oldIcon = (HICON) GetClassLongPtr(win, GCLP_HICON);
	    SetClassLongPtr(win, GCLP_HICON, (INT)0);
# else
	    oldIcon = (HICON) GetClassLong(win, GCL_HICON);
	    SetClassLong(win, GCL_HICON, (DWORD)0);
# endif
	    /* It has to be checked whether this can be deleted!!!!! */
	    if ( oldIcon ) {
		if ( DestroyIcon( oldIcon )) {
		    DPRINTF(( "Old icon deleted\n" ));
		} else {
		    console_fprintf(stderr, "failed to destroy icon\n");
		}
	    }
#endif
	   /*console_printf("post WM_THREAD_DESTROYWINDOW\n");*/
	    PostMessage(win, WM_THREAD_DESTROYWINDOW, 0, 0);
	}
    }
%}
!

rootWindowId
    "return the id of the root window.
     This is the window you see as background,
     however, it may or may not be the real physical root window,
     since some window managers install a virtual root window on top
     of the real one. If this is the case, that views id is returned here."

    ^ rootWin
! !

!WinWorkstation methodsFor:'clipboard'!

getClipboardObjectFor:drawableId
    "answer an arbitrary object from the clipboard, or nil,
     if there is no data that we are able to handle (decode)"

    |currentSequenceNumber|

    currentSequenceNumber := self getClipboardSequenceNumber.
    lastClipboardSequenceNumber ~= currentSequenceNumber ifTrue:[
	"copyBuffer is invalid, fill it from the windows clipboard.
	 Even if we could not decode the windows clipboard,
	 we intentionally set the copyBuffer to nil to get a consistent
	 behavior."
	copyBuffer := self getClipboardData.
	lastClipboardSequenceNumber := currentSequenceNumber.
    ].
    ^ copyBuffer
!

getClipboardText:selectionBufferSymbol for:drawableId
     "get the contents of the clipboard and answer a String,
      or nil, if there is no data that we can handle (decode)."

    |currentSequenceNumber|

    currentSequenceNumber := self getClipboardSequenceNumber.
    lastClipboardSequenceNumber ~= currentSequenceNumber ifTrue:[
	"copyBuffer is invalid, fill it from the windows clipboard.
	 Even if we could not decode the windows clipboard,
	 we intentionally set the copyBuffer to nil to get a consistent
	 behavior."
	copyBuffer := self getClipboardData.
	lastClipboardSequenceNumber := currentSequenceNumber.
    ].
    ^ self copyBufferAsString

    "
     Screen current getClipboardText:#clipboard for:nil
    "

    "Modified: / 09-10-2007 / 12:42:08 / cg"
!

setClipboardObject:something owner:drawableId
    "store an arbitrary object into the clipboard.
     Since we currently support only text, any other object
     is stored only in our local copyBuffer and not made available
     to other applications."

    something isString ifTrue:[
	self setClipboardText:something owner:drawableId.
	^ self
    ].
    something isStringCollection ifTrue:[
	self setClipboardText:something asString owner:drawableId.
	^ self
    ].

    "copyBuffer is valid until the clipboard sequence number increases,
     because new data has been put into the clipboard"
    lastClipboardSequenceNumber := self getClipboardSequenceNumber.

    "Created: / 13.7.1999 / 13:30:37 / cg"
    "Modified: / 30.1.2000 / 11:59:41 / cg"
!

setClipboardText:something owner:drawableId
    "store some text into the clipboard"

    |result|

    result := self setClipboardData:something asString string.  "take care of StringCollections"

    "as long as the sequence number doesn't change, our copyBuffer is valid"
    lastClipboardSequenceNumber := self getClipboardSequenceNumber.
    ^ result.


    "Created: / 13.7.1999 / 13:36:43 / cg"
    "Modified: / 30.1.2000 / 12:12:57 / cg"
! !

!WinWorkstation methodsFor:'clipboard-private'!

getClipboardData
    "get the contents of the windows clipboard.
     Answer a string on success or nil otherwise.
     Caveat: for now, only Text and UnicodeText are supported"

    |data|

    (data := self getUnicodeClipboardData) notNil ifTrue:[^ data].
    (data := self getTextClipboardData) notNil ifTrue:[^ data].
    ^ nil

    "Modified: / 09-10-2007 / 12:47:02 / cg"
!

getClipboardDataBytes:format
    "get the contents of the windows clipboard as raw bytes.
     Answer an image on success or nil otherwise."

    |bytes|

%{
    HANDLE hData;
    unsigned char *src, *p;
    WIDECHAR *w_src, *w_p;
    int fmt;

    if (format == @symbol(CF_TIFF)) {
	fmt = CF_TIFF;
    } else if (format == @symbol(CF_BITMAP)) {
	fmt = CF_BITMAP;
    } else if (format == @symbol(CF_DIB)) {
	fmt = CF_DIB;
    } else
	goto badFormat;

    if (IsClipboardFormatAvailable(fmt)) {
	int len;

	if (OpenClipboard(NULL)) {
	    hData = GetClipboardData(fmt);
	    if (hData) {
		len = GlobalSize(hData);
		src = GlobalLock(hData);
		if (src) {
		    bytes = __MKBYTEARRAY(src, len);
		}
		GlobalUnlock(hData);
		CloseClipboard();
		DDPRINTF(("WinWorkstation [info]: clipBoard data size is <%d>\n", len));
		RETURN(bytes);
	    }
	}
    }
badFormat: ;
%}.
    ^ nil

    "
     Screen current getClipboardDataBytes:#CF_TIFF
     Screen current getClipboardDataBytes:#CF_BITMAP
     Screen current getClipboardDataBytes:#CF_DIB
    "

    "Created: / 09-10-2007 / 13:11:12 / cg"
    "Modified: / 09-10-2007 / 14:18:26 / cg"
!

getClipboardOwner
    "answer an handle telling us, who owns the clipboard."

%{
    HANDLE hWnd;

    hWnd = GetClipboardOwner();
    RETURN(__MKEXTERNALADDRESS(hWnd));
%}

   "
	Screen current getClipboardOwner
   "
!

getClipboardSequenceNumber
    "answer the sequence number of the clioboard.
     Each time, the keyboard is changed, the sequence number is incremented."

%{
    DWORD sequenceNumber;

    sequenceNumber = GetClipboardSequenceNumber();
    RETURN(__MKUINT(sequenceNumber));
%}

   "
	Screen current getClipboardSequenceNumber
   "
!

getImapeClipboardData
    "get the contents of the windows clipboard.
     Answer an image on success or nil otherwise."

    |data|

    (data := self getClipboardDataBytes:#CF_TIFF) notNil ifTrue:[
	"/ tiff image in data...
	^ "TIFFReader fromBytes:data" nil
    ].
    (data := self getClipboardDataBytes:#CF_DIB) notNil ifTrue:[
	"/ device independent bitmap image in data...
	^ "TIFFReader fromBytes:data" nil
    ].
    ^ nil

    "Created: / 09-10-2007 / 14:19:53 / cg"
!

getTextClipboardData
    "get the contents of the windows clipboard.
     Answer a string on success or nil otherwise.
     Caveat: for now, only Text is supported"

%{
    HANDLE hData;
    OBJ s;
    unsigned char *src, *p;
    WIDECHAR *w_src, *w_p;

    /* check for format CF_TEXT */
    if (IsClipboardFormatAvailable(CF_TEXT)) {
	int nRemain, len, realLen;

	if (OpenClipboard(NULL)) {
	    hData = GetClipboardData(CF_TEXT);
	    src = GlobalLock(hData);
	    len = src ? strlen(src) : 0;

	    /* see how much we really need (when CRLF is replaced by LF) */
	    for (realLen=nRemain=len, p=src; nRemain; ) {
		unsigned char ch;

		ch = *p++; nRemain--;
		if (ch == 0x0D) {
		    if (nRemain && (*p == 0x0A)) {
			p++; nRemain--;realLen--;
		    }
		}
	    }
	    s = __MKEMPTYSTRING(realLen);
	    if (s != nil) {
		for (p=__stringVal(s); len; ) {
		    unsigned char ch;

		    *p = ch = *src++;
		    len--;
		    if (len && (ch == 0x0D) && (*src == 0x0A)) {
			*p = 0x0A;
			src++;
			len--;
		    }
		    p++;
		}
	    }
	    GlobalUnlock(hData);
	    CloseClipboard();
	    DDPRINTF(("WinWorkstation [info]: clipBoard data is <%s>\n", (char *)hData));
	    RETURN(s);
	}
    }
%}.
    ^ nil

    "Created: / 09-10-2007 / 12:46:00 / cg"
!

getUnicodeClipboardData
    "get the contents of the windows clipboard.
     Answer a string on success or nil otherwise.
     Caveat: for now, only Text is supported"

%{
    HANDLE hData;
    OBJ s;
    unsigned char *src, *p;
    WIDECHAR *w_src, *w_p;

    /* Unicode */
    if (IsClipboardFormatAvailable(CF_UNICODETEXT)) {
	int nRemain, len, realLen;

	if (OpenClipboard(NULL)) {
	    int needUnicode = 0;

	    hData = GetClipboardData(CF_UNICODETEXT);
	    w_src = GlobalLock(hData);
	    len = w_src ? wcslen(w_src) : 0;
	    /*
	     * see how much we really need (when CRLF is replaced by LF)
	     * and if result is really Unicode ...
	     */
	    for (realLen=nRemain=len, w_p=w_src; nRemain; ) {
		WIDECHAR w_ch;

		w_ch = *w_p++; nRemain--;
		if ((unsigned) w_ch > 0xFF) {
		    needUnicode = 1;
		}
		if (w_ch == 0x0D) {
		    if (nRemain && (*w_p == 0x0A)) {
			w_p++; nRemain--;realLen--;
		    }
		}
	    }
	    if (! needUnicode) {
		s = __MKEMPTYSTRING(realLen);
		if (s != nil) {
		    for (p = __stringVal(s); len; ) {
			unsigned char ch;

			*p = ch = *w_src++;
			len--;
			if (len && (ch == 0x0D) && (*w_src == 0x0A)) {
			    *p = 0x0A;
			    w_src++;
			    len--;
			}
			p++;
		    }
		}
	    } else {
		s = __BYTEARRAY_NEW_INT(realLen * 2);
		if (s != nil) {
		    __objPtr(s)->o_class = @global(Unicode16String);
		    for (w_p = (WIDECHAR *)__stringVal(s); len; ) {
			WIDECHAR w_ch;

			*w_p = w_ch = *w_src++;
			len--;
			if (len && (w_ch == 0x0D) && (*w_src == 0x0A)) {
			    *w_p = 0x0A;
			    w_src++;
			    len--;
			}
			w_p++;
		    }
		}
	    }
	    GlobalUnlock(hData);
	    CloseClipboard();
	    RETURN(s);
	}
    }
%}.
    ^ nil

    "Created: / 09-10-2007 / 12:45:26 / cg"
!

setClipboardData:aString
    "Set the contents of the windows clipboard.
     Answer true, if the operation succeeded, false otherwise.
     Caveat: for now, only Text is supported."

%{
    HANDLE hData;

    if (__isStringLike(aString)) {
	char *s, *p, *src, *dst;
	int n, len, realLen;

	if (OpenClipboard(NULL)) {
	    s = __stringVal(aString);
	    /* must replace CR by CRLF */
	    len = realLen = __stringSize(aString);
	    for (src=s, n=len; n; n--) {
		if ((src[0] == 0x0A) && ((src == s) || (src[-1] != 0x0D))) {
		    realLen++;
		}
		src++;
	    }

	    hData = GlobalAlloc(GMEM_MOVEABLE | GMEM_DDESHARE, realLen+1);
	    if (hData) {
		char *t = GlobalLock(hData);

		if (t) {
		    for (src=s, dst=t, n=len; n;) {
			unsigned char ch;

			ch = src[0]; n--;
			if ((ch == 0x0A) && ((src == s) || (src[-1] != 0x0D))) {
			    *dst++ = 0x0D;
			    *dst++ = 0x0A;
			} else {
			    *dst++ = ch;
			}
			src++;
		    }
		    *dst = 0;

		    EmptyClipboard();
		    if (SetClipboardData(CF_TEXT, hData) != 0) {
			/* Note: After setting clipboard data,
			 * the memory block previously allocated belongs to
			 * the clipboard - not to the app.
			 */
			CloseClipboard();
			RETURN (true);
		    }
		    DPRINTF(("SetClipboardData error:%d\n", GetLastError()));
		    GlobalUnlock(hData);
		}
	    }
	    CloseClipboard();
	}
	RETURN(false);
    }

    /* Unicode */
    if (__isWords(aString)) {
	WIDECHAR *w_s, *w_p, *w_src, *w_dst;
	int n, len, realLen;

	if (OpenClipboard(NULL)) {
	    OBJ cls;
	    int nInstBytes;

	    cls = __qClass(aString);
	    nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	    w_s = (WIDECHAR *)(__stringVal(aString) + nInstBytes);

	    /* must replace CR by CRLF */
	    len = realLen = (__byteArraySize(aString) - nInstBytes) / 2;
	    for (w_src=w_s, n=len; n; n--) {
		if ((w_src[0] == 0x0A) && ((w_src == w_s) || (w_src[-1] != 0x0D))) {
		    realLen++;
		}
		w_src++;
	    }

	    hData = GlobalAlloc(GMEM_MOVEABLE | GMEM_DDESHARE, (realLen+1)*sizeof(WIDECHAR));
	    if (hData) {
		WIDECHAR *t = GlobalLock(hData);

		if (t) {
		    for (w_src=w_s, w_dst=t, n=len; n;) {
			WIDECHAR w_ch;

			w_ch = w_src[0]; n--;
			if ((w_ch == 0x0A) && ((w_src == w_s) || (w_src[-1] != 0x0D))) {
			    *w_dst++ = 0x0D;
			    *w_dst++ = 0x0A;
			} else {
			    *w_dst++ = w_ch;
			}
			w_src++;
		    }
		    *w_dst = 0;

		    EmptyClipboard();
		    if (SetClipboardData(CF_UNICODETEXT, hData) != 0) {
			/* Note: After setting clipboard data,
			 * the memory block previously allocated belongs to
			 * the clipboard - not to the app.
			 */
			CloseClipboard();
			RETURN (true);
		    }
		    DPRINTF(("SetClipboardData error:%d\n", GetLastError()));
		    GlobalUnlock(hData);
		}
	    }
	    CloseClipboard();
	}
	RETURN(false);
    }
%}.
    self primitiveFailed.
! !

!WinWorkstation methodsFor:'color stuff'!

colorRed:redVal green:greenVal blue:blueVal
    "allocate a color with rgb values (0..100) - return the color index (i.e. colorID).
     This method is obsoleted by #colorScaledRed:scaledGreen:scaledBlue:"

    |r g b|

    r := self percentToDeviceColorValue:redVal.
    g := self percentToDeviceColorValue:greenVal.
    b := self percentToDeviceColorValue:blueVal.
    ^ self colorScaledRed:r scaledGreen:g scaledBlue:b
!

colorScaledRed:r scaledGreen:g scaledBlue:b
    "allocate a color with rgb values (0..16rFFFF) - return the color index
     (i.e. colorID)"

%{  /* NOCONTEXT */
    int id, ir, ig, ib;

    if (__bothSmallInteger(r, g) && __isSmallInteger(b)) {
	id = RGB2st(__intVal(r),__intVal(g),__intVal(b));
	CPRINTF(("alloc color %d/%d/%d -> %x\n", ir, ig, ib, id));
	RETURN ( __MKSMALLINT(id) );
    }
%}.
    self primitiveFailed.
    ^ nil
!

freeColor:colorIndex
    "free a display color when its no longer needed.
     A dummy here, since RGB colors are never freed."

    "/ 'free color' printCR.
    ^ self
!

getRGBFrom:index into:aBlock
    "get rgb components (0..100) of color in map at:index,
     and evaluate the 3-arg block, aBlock with them"

    |val|

    self getScaledRGBFrom:index into:[:r :g :b |
	val := aBlock
		value:(r * 100.0 / 16rFFFF)
		value:(g * 100.0 / 16rFFFF)
		value:(b * 100.0 / 16rFFFF)
    ].
    "/ 'get RGB' printCR.
    ^ val
!

getRGBFromName:colorName into:aBlock
    "get rgb components (0..100) of color named colorName,
     and evaluate the 3-arg block, aBlock with them.
     Return nil for unknown color names."

    |val|

    self getScaledRGBFromName:colorName into:[:r :g :b |
	r isNil ifTrue:[^nil].
	val := aBlock
		value:(r * 100.0 / 16rFFFF)
		value:(g * 100.0 / 16rFFFF)
		value:(b * 100.0 / 16rFFFF)
    ].
    ^ val
!

getScaledRGBFrom:index into:aBlock
    "get rgb components (0 .. 16rFFFF) of color in map at:index,
     and evaluate the 3-arg block, aBlock with them"

    |r g b|
%{
    int id = __intVal(index);
    int iR, iG, iB;

    id = st2RGB(id,0);
    iR = id & 0xFF;
    iG = (id >> 8) & 0xFF;
    iB = (id >> 16) & 0xFF;
    iR = (iR << 8) | iR;
    iG = (iG << 8) | iG;
    iB = (iB << 8) | iB;

    r = __MKSMALLINT(iR);
    g = __MKSMALLINT(iG);
    b = __MKSMALLINT(iB);
    /*console_printf("get color %x -> %x/%x/%x\n",id, iR, iG, iB);*/
%}.
    ^ aBlock value:r value:g value:b
!

getScaledRGBFromName:colorName into:aBlock
    "get scaled rgb components (0..16rFFFF) of color named colorName,
     and evaluate the 3-arg block, aBlock with them.
     Return nil for unknown color names or invalid hex numbers."

    |triple r g b found cName|

    r := g := b := 0.
    found := false.
    (colorName startsWith:$#) ifTrue:[
	"/ color in r/g/b hex notation
	colorName size == 7 ifTrue:[
	    r := Integer readFrom:(colorName copyFrom:2 to:3) radix:16 onError:[nil].
	    g := Integer readFrom:(colorName copyFrom:4 to:5) radix:16 onError:[nil].
	    b := Integer readFrom:(colorName copyFrom:6 to:7) radix:16 onError:[nil].
	].
	(r isNil or:[g isNil or:[b isNil]]) ifTrue:[^ nil].
	found := true.
    ] ifFalse:[
	cName := colorName asString.
	triple := StandardColorValues at:cName ifAbsent:nil.
	triple isNil ifTrue:[
	    "/ try lowercase name
	    cName := cName asLowercase.
	    triple := StandardColorValues at:cName ifAbsent:nil.
	    triple isNil ifTrue:[
		"/ try lowercase without intermixed spaces
		cName := cName asCollectionOfWords asStringWith:nil.
		triple := StandardColorValues at:cName ifAbsent:nil.
	    ].
	].
	triple notNil ifTrue:[
	    r := triple at:1.
	    g := triple at:2.
	    b := triple at:3.
	    found := true.
	].
    ].
    found ifFalse:[
	"/ ('WinWorkstation: unknown color: ' , colorName) infoPrintCR.
	^ nil.
    ].

    ^ aBlock value:((r * 256) + r) value:((g * 256) + g) value:((b * 256) + b)

    "Modified (comment): / 14-11-2016 / 14:02:11 / cg"
!

listOfAvailableColors
    "return a list of all available colornames.
     This should not be used, since colornames are very
     display-specific (here X-specific)."

    |aStream list line index colorName|

    aStream := FileStream readonlyFileNamed:'/usr/lib/X11/rgb.txt'.
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
     WIN-component value (0..16rFFFF) as an integer"

%{  /* NOCONTEXT */

    if (__isSmallInteger(aPercentage)) {
	RETURN ( __MKSMALLINT(0xFFFF * __intVal(aPercentage) / 100) );
    }
    if (__isFloat(aPercentage)) {
	RETURN ( __MKSMALLINT(0xFFFF * (INT)(__floatVal(aPercentage)) / 100) );
    }
%}.
    ^ (16rFFFF * aPercentage / 100) rounded
!

setColor:index scaledRed:sred scaledGreen:sgreen scaledBlue:sblue
    "change a palette index.
     This is not yet supported in the Windows Device
     - we assume and depend upon transparent 24bit trueColor mode."

     'WinWorkstation [info]: #setColor:scaledRed:scaledGreen:scaledBlue: ignored' infoPrintCR.
     ^ self.

    "Created: 30.1.1998 / 09:27:48 / md"
    "Modified: 30.1.1998 / 09:30:22 / md"
! !

!WinWorkstation methodsFor:'cursor stuff'!

builtInCursorShapes
    "return a collection of standard cursor names.
     Those are built into Windows and need not be created as
     user cursors.
     (actually, there are more than those below ...)"

    "/ if you add something here, also add to #shapeNumberFromCursor ...

    ^ #(
	#upLeftArrow            "/ IDC_ARROW
	#upDownArrow            "/ IDC_SIZENS
	#leftRightArrow         "/ IDC_SIZEWE
	#text                   "/ IDC_IBEAM
	#wait                   "/ IDC_WAIT
	#execute                "/ IDC_APPSTARTING
	#crossHair              "/ IDC_CROSS
	#fourWay                "/ IDC_SIZEALL
	#upRightHand            "/ IDC_ARROW
	#noDrop                 "/ IDC_NO
	#stop                   "/ IDC_NO
       )

    "Modified: / 10.12.1999 / 15:16:26 / cg"
!

createCursorShape:aShape
    "create a cursor given a shape-symbol"

    |number|

    number := self shapeNumberFromSymbol:aShape.
    number isNil ifTrue:[^ nil].
    ^ self primCreateCursorShapeNr:number
!

createCursorSourceForm:sourceBytes maskForm:maskBytes hotX:hx hotY:hy width:w height:h
    "create a cursor given 2 bitmaps (source, mask) and a hotspot"

    |padding bpl bplPadded srcOffs dstOffs
     src mask srcPadded maskPadded cW cH nB nR cursor |

    cW := self getSystemMetrics:#SM_CXCURSOR.
    cH := self getSystemMetrics:#SM_CYCURSOR.

    "/ ('cursorWidth ',cW printString,'cursorHeight ',cH printString) infoPrintCR.
    src := sourceBytes.
    mask := maskBytes.
    padding := self cursorBitmapPadding.

    "/ repadding and/or resizing required ?
    bpl := sourceBytes size / h.
    bplPadded := (cW + padding - 1) // padding * 2.

    bpl ~~ bplPadded ifTrue:[
	 "/     'repad cursor bits' infoPrintCR.
	srcPadded := ByteArray new:(bplPadded * cH).
	nB := bpl min: bplPadded.
	nR := cH min: h.

	dstOffs := srcOffs := 1.
	1 to:nR do:[:row |
	    srcPadded
		replaceFrom:dstOffs
		to:(dstOffs+nB-1)
		with:src
		startingAt:srcOffs.
	    dstOffs := dstOffs + bplPadded.
	    srcOffs := srcOffs + bpl.
	].

	maskPadded := ByteArray new:(bplPadded * cH).
	dstOffs := srcOffs := 1.
	1 to:nR do:[:row |
	    maskPadded
		replaceFrom:dstOffs
		to:(dstOffs+nB-1)
		with:mask
		startingAt:srcOffs.
	    dstOffs := dstOffs + bplPadded.
	    srcOffs := srcOffs + bpl.
	].
	src := srcPadded.
	mask := maskPadded.

    ].

    src invert.
    1 to:src size do:[:index |
	src byteAt:index put:((src byteAt:index) bitAnd:(mask byteAt:index)).
    ].
    mask invert.
    cursor := self
	primCreateCursorSourceBits:src
	maskBits:mask
	hotX:hx hotY:hy
	width:cW height:cH.
    cursor notNil ifTrue:[^ cursor ].
    'WinWorkstation [warning]: could not create bitmap cursor' infoPrintCR.

    "Modified: / 08-09-2006 / 15:39:42 / cg"
!

cursorBitmapPadding
    ^ 16 "/ windows requires short-padded rows
!

destroyCursor:aCursorId
    "destroy a cursor"

%{  /* NOCONTEXT */

    if (ISCONNECTED) {
	if (__isExternalAddress(aCursorId)) {
	    HCURSOR curs = _HCURSORVal(aCursorId);

	    if (curs) {
#ifdef KEEP_STD_CURSORS
		if ((curs != H_C_ARROW)
		 && (curs != H_C_CROSS)
		 && (curs != H_C_IBEAM)
		 && (curs != H_C_ICON)
		 && (curs != H_C_NO)
		 && (curs != H_C_SIZE)
		 && (curs != H_C_SIZEALL)
		 && (curs != H_C_SIZENESW)
		 && (curs != H_C_SIZENS)
		 && (curs != H_C_SIZENWSE)
		 && (curs != H_C_UPARROW)
		 && (curs != H_C_APPSTARTING)
		 && (curs != H_C_WAIT))
#endif /* KEEP_STD_CURSORS */
		{
		    DestroyCursor(curs);
#ifdef COUNT_RESOURCES
		    __cnt_cur--;
		    RESPRINTF(("DestroyCursor %d\n",__cnt_cur));
#endif
		}
	    }
	    RETURN ( self );
	}
    }
%}
!

needDeviceFormsForCursor
    ^ false
!

primCreateCursorShapeNr:number
    " create a standard (shape) cursor"

%{  /* NOCONTEXT */
    HCURSOR newCursor;
    LPCTSTR cId;

    if (__isSmallInteger(number)) {
	cId = (LPCTSTR)(__intVal(number));
	newCursor = LoadCursor(NULL, cId);
	if (newCursor) {
#ifdef KEEP_STD_CURSORS
	    if (cId == IDC_ARROW)
		H_C_ARROW = newCursor;
	    else if (cId == IDC_CROSS)
		H_C_CROSS = newCursor;
	    else if (cId == IDC_IBEAM)
		H_C_IBEAM = newCursor;
	    else if (cId == IDC_ICON)
		H_C_ICON = newCursor;
	    else if (cId == IDC_NO)
		H_C_NO = newCursor;
	    else if (cId == IDC_SIZE)
		H_C_SIZE = newCursor;
	    else if (cId == IDC_SIZEALL)
		H_C_SIZEALL = newCursor;
	    else if (cId == IDC_SIZENESW)
		H_C_SIZENESW = newCursor;
	    else if (cId == IDC_SIZENS)
		H_C_SIZENS = newCursor;
	    else if (cId == IDC_SIZENWSE)
		H_C_SIZENWSE = newCursor;
	    else if (cId == IDC_UPARROW)
		H_C_UPARROW = newCursor;
	    else if (cId == IDC_WAIT)
		H_C_WAIT = newCursor;
	    else if (cId == IDC_APPSTARTING)
		H_C_APPSTARTING = newCursor;
#endif /* KEEP_STD_CURSORS */
	    RETURN ( __MKOBJ(newCursor) );
	}
    }
    RETURN (nil);
%}
!

primCreateCursorSourceBits:src maskBits:mask hotX:hx hotY:hy width:w height:h
    "create a cursor from given pixels"

%{
    HCURSOR newCursor;

    if (__isByteArray(src)
     && __isByteArray(mask)
     && __bothSmallInteger(hx, hy)
     && __bothSmallInteger(w, h)) {

	newCursor = CreateCursor((HANDLE) __getHInstance(),
				 __intVal(hx), __intVal(hy),
				 __intVal(w), __intVal(h),
				 __ByteArrayInstPtr(mask)->ba_element,
				 __ByteArrayInstPtr(src)->ba_element);
	if (newCursor) {
#ifdef COUNT_RESOURCES
	    __cnt_cur++;
	    RESPRINTF(("CreateCursor %d\n",__cnt_cur));
#endif
	    RETURN ( __MKOBJ(newCursor));
	}
    }
    RETURN (nil);
%}
!

shapeNumberFromSymbol:shape
    "given a shape-symbol, return the corresponding cursor-number,
     or nil if no such standard cursor exists."

    "this is pure Win-knowlegde - but you may easily add more"

%{  /* NOCONTEXT */
    if (shape == @symbol(upRightHand)) {
	RETURN ( __MKSMALLINT( (INT)IDC_HAND));
    }
    if (shape == @symbol(upLeftArrow)) {
	RETURN ( __MKSMALLINT( (INT)IDC_ARROW));
    }
    if (shape == @symbol(upDownArrow)) {
	RETURN ( __MKSMALLINT( (INT)IDC_SIZENS));
    }
    if (shape == @symbol(leftRightArrow)) {
	RETURN ( __MKSMALLINT( (INT)IDC_SIZEWE));
    }
    if (shape == @symbol(text)) {
	RETURN ( __MKSMALLINT( (INT)IDC_IBEAM));
    }
    if (shape == @symbol(wait)) {
	RETURN ( __MKSMALLINT( (INT)IDC_WAIT));
    }
    if (shape == @symbol(crossHair)) {
	RETURN ( __MKSMALLINT( (INT)IDC_CROSS));
    }
    if (shape == @symbol(fourWay)) {
	RETURN ( __MKSMALLINT( (INT)IDC_SIZEALL));
    }
    if (shape == @symbol(execute)) {
	RETURN ( __MKSMALLINT( (INT)IDC_APPSTARTING));
    }
    if (shape == @symbol(noDrop)) {
	RETURN ( __MKSMALLINT( (INT)IDC_NO));
    }
    if (shape == @symbol(stop)) {
	RETURN ( __MKSMALLINT( (INT)IDC_NO));
    }

    if (shape == @symbol(IDC_UPARROW)) {
	RETURN ( __MKSMALLINT( (INT)IDC_UPARROW));
    }

    if (shape == @symbol(IDC_SIZE)) {
	RETURN ( __MKSMALLINT( (INT)IDC_SIZE));
    }
    if (shape == @symbol(IDC_SIZENWSE)) {
	RETURN ( __MKSMALLINT( (INT)IDC_SIZENWSE));
    }
    if (shape == @symbol(IDC_SIZENESW)) {
	RETURN ( __MKSMALLINT( (INT)IDC_SIZENESW));
    }
    if (shape == @symbol(IDC_NO)) {
	RETURN ( __MKSMALLINT( (INT)IDC_NO));
    }
#ifdef IDC_HELP
    if (shape == @symbol(IDC_HELP)) {
	RETURN ( __MKSMALLINT( (INT)IDC_HELP));
    }
#endif
%}.
"/    ('WINWORKSTATION: invalid cursorShape:' , shape printString) infoPrintNL.
    ^  nil
! !

!WinWorkstation methodsFor:'drag & drop'!

dragFinish:dropHandle
    "free Win32 data (and remove the drop-file)"
%{
    if (__isExternalAddress(dropHandle)) {
	HDROP hDrop = (HDROP)__externalAddressVal(dropHandle);

	__externalAddressVal(dropHandle) = 0;
	if (hDrop) {
	    DragFinish(hDrop);
	}
    }
%}
! !

!WinWorkstation methodsFor:'drawing'!

copyFromId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId
		width:w height:h
    "do a bit-blt; copy bits from the rectangle defined by
     srcX/srcY and w/h from the sourceId drawable to the rectangle
     below dstX/dstY in the destId drawable. Trigger an error if any
     argument is not integer."

%{
    struct gcData *dstGcData = 0;
    struct gcData *srcGcData = 0;
    HDC srcDC = (HDC)0;
    HDC dstDC = (HDC)0;
    int     dstGcOwnerThreadID;
    HWND    dstGcHWIN;
    HBITMAP dstGcHBITMAP;

    if (! __isExternalAddress(srcGCId)
     || ! __isExternalAddress(dstGCId)) {
	goto fail;
    }
    srcGcData = _GCDATA(srcGCId);
    dstGcData = _GCDATA(dstGCId);

    if (__bothSmallInteger(w, h)
     && __bothSmallInteger(srcX, srcY)
     && __bothSmallInteger(dstX, dstY)
     && srcGcData
     && dstGcData) {
	int fun = BITBLT_COPY;
	int src_fg, src_bg, dst_fg, dst_bg;

	fun = dstGcData->bitbltrop2;
#if 0
	switch (fun) {
	  case BITBLT_COPY:
	    console_printf("BITBLT_COPY\n");
	    break;
	  case BITBLT_COPYINVERTED:
	    console_printf("BITBLT_COPYINVERTED\n");
	    break;
	  case BITBLT_XOR:
	    console_printf("BITBLT_XOR\n");
	    break;
	  case BITBLT_AND:
	    console_printf("BITBLT_AND\n");
	    break;
	  case BITBLT_OR:
	    console_printf("BITBLT_OR\n");
	    break;
	}
#endif

	/*
	 * a scroll operation ?
	 */
	if (srcGcData->hWnd
	 && ((srcGcData->hWnd == dstGcData->hWnd)
	 && (fun == BITBLT_COPY))) {
	    RECT rec, updRect;
	    RECT invRec;
	    HRGN updRgn = 0, dstRgn = 0, nUpdRgn = 0;
	    int _srcX = __intVal(srcX);
	    int _srcY = __intVal(srcY);
	    int _dstX = __intVal(dstX);
	    int _dstY = __intVal(dstY);
	    int _w = __intVal(w);
	    int _h = __intVal(h);
	    int noExpose = 0;
	    int _deltaX, _deltaY;

#ifdef CACHE_LAST_DC
	    if (lastGcData) {
		_releaseDC(lastGcData);
	    }
#endif

	    rec.left = _srcX;
	    rec.top  = _srcY;
	    rec.right = rec.left + _w;
	    rec.bottom = rec.top + _h;

	    _deltaX = _dstX - _srcX;
	    _deltaY = _dstY - _srcY;

	    DDPRINTF(("dst and src is HWND %x fun == BITBLT_COPY --> scroll %d/%d\n",
		    srcGcData->hWnd,
		    _deltaX,
		    _deltaY));

	    if ((_deltaX == 0) && (_deltaY == 0)) {
		noExpose = 1;
	    } else {
		updRgn = CreateRectRgn(0, 0, 0, 0);
		ScrollWindowEx(srcGcData->hWnd,
			    _deltaX,
			    _deltaY,
			    &rec,            /* area to scroll */
			    0,               /* clip region */
			    updRgn,
			    NULL, /* &invRec, */
			    0 /* SW_ERASE | SW_INVALIDATE */);

		/*
		 * we are not interested in the source-area;
		 * only care for exposed areas in the dst area.
		 */
		dstRgn = CreateRectRgn(_dstX, _dstY, _dstX+_w, _dstY+_h);
		nUpdRgn = CreateRectRgn(0, 0, 0, 0);
		switch (CombineRgn(nUpdRgn, updRgn, dstRgn, RGN_AND)) {
		    case ERROR:
			_DeleteObject(nUpdRgn, __LINE__);
			nUpdRgn = updRgn;
			noExpose = 1;
			break;
		    case NULLREGION:
			noExpose = 1;
			break;
		    default:
			if (__generateExposes(srcGcData->hWnd, nUpdRgn, __WM_GEXPOSE, 1) <= 0) {
			    noExpose = 1;
			}
			break;
		}
	    }
	    if (noExpose) {
		/*
		 * no exposes generated - must send a NOEXPOSE
		 */
		enqEvent(ExposureMask, srcGcData->hWnd, __WM_NOGEXPOSE, 0, 0, 0, 0, 0, EV_NOTIME);
	    }

	    if (dstRgn) {
		_DeleteObject(dstRgn, __LINE__);
	    }
	    if (nUpdRgn && (nUpdRgn != updRgn)) {
		_DeleteObject(nUpdRgn, __LINE__);
	    }
	    if (updRgn) {
		_DeleteObject(updRgn, __LINE__);
	    }
	    RETURN ( self );
	}

	fun = dstGcData->bitbltrop2;

	if (0 /* fun == BITBLT_COPY */) {
	    src_fg = dst_fg = 0xFFFFFF;
	    src_bg = dst_bg = 0x000000;
	} else {
	    src_fg = srcGcData->fgColor;
	    src_bg = srcGcData->bgColor;
	    dst_fg = dstGcData->fgColor;
	    dst_bg = dstGcData->bgColor;
	}

	/*
	 * a simple copy (like scroll, but in a bitmap) ?
	 */
	if ((srcGcData == dstGcData)
	 && (fun == BITBLT_COPY)) {
	    RECT rec, uprec;
	    int _srcX, _srcY;

	    rec.left = _srcX = __intVal(srcX);
	    rec.top = _srcY = __intVal(srcY);
	    rec.right = rec.left + __intVal(w);
	    rec.bottom = rec.top + __intVal(h);
	    srcDC = _getDC(srcGcData);
	    SetBkColor(srcDC, src_fg);
	    SetTextColor(srcDC, src_bg);

	    DDPRINTF(("dst and src is DC %x fun == BITBLT_COPY  --> scrolling %d %d\n",srcDC,__intVal(dstX) - __intVal(srcX),__intVal(dstY) - __intVal(srcY)));
	    ScrollDC(srcDC, __intVal(dstX)-_srcX,
			    __intVal(dstY)-_srcY,
			    &rec, 0, 0, &uprec);

	    SetBkColor(srcDC, srcGcData->bgColor);
	    SetTextColor(srcDC, srcGcData->fgColor);
#ifndef CACHE_LAST_DC
	    _releaseDC(srcGcData);
#endif
	    RETURN ( self );
	}

#ifdef xxCACHE_LAST_DC
/* mhmh - this should not be needed */
	if (lastGcData) {
	    _releaseDC(lastGcData);
	}
#endif

	if (dstGcData == srcGcData) {
	    srcDC = dstDC = _getDC(dstGcData);
	} else {
	    srcDC = _getDC(srcGcData);

	    /*
	     * kludge - pretent nothing is cached for a moment,
	     * to avoid release in getDC below ...
	     */
#ifdef CACHE_LAST_DC
	    dstGcOwnerThreadID = lastGcOwnerThreadID;
	    dstGcHWIN = lastGcHWIN;
	    dstGcHBITMAP = lastGcHBITMAP;
	    lastGcData = 0;
#endif

	    dstDC = _getDC(dstGcData);
	    SetBkColor(dstDC, dst_fg);
	    SetTextColor(dstDC, dst_bg);
	}

	SetBkColor(srcDC, src_fg);
	SetTextColor(srcDC, src_bg);

	CPRINTF(("bitblt src f:%x b:%x",GetTextColor(srcDC),GetBkColor(srcDC)));
	CPRINTF(("dst f:%x b:%x\n",GetTextColor(dstDC),GetBkColor(dstDC)));
	if (BitBlt(dstDC,
	     __intVal(dstX), __intVal(dstY),
	     __intVal(w), __intVal(h),
	     srcDC,
	     __intVal(srcX), __intVal(srcY),
	     fun)
	   == 0
	  ) {
	    console_fprintf(stderr, "WinWorkstation [info]: ERROR in BitBlt: %d\n", GetLastError());
	}

	if (dstGcData != srcGcData) {
	    SetBkColor(dstDC, dstGcData->bgColor);
	    SetTextColor(dstDC, dstGcData->fgColor);
	}
	SetBkColor(srcDC, srcGcData->bgColor);
	SetTextColor(srcDC, srcGcData->fgColor);

	if (srcGcData != dstGcData) {
	    _releaseDC(srcGcData);
	}

#ifdef CACHE_LAST_DC
	/*
	 * kludge again - restore last-DC cache
	 */
	lastGcData = dstGcData;
	lastGcOwnerThreadID = dstGcOwnerThreadID;
	lastGcHWIN = dstGcHWIN;
	lastGcHBITMAP = dstGcHBITMAP;
#else
	_releaseDC(dstGcData);
#endif
	RETURN ( self );
    }

 fail: ;
%}.
    self primitiveFailed.
    ^ nil
!

copyPlaneFromId:sourceId x:srcX y:srcY gc:srcDCId to:destId x:dstX y:dstY gc:dstDCId
		width:w height:h
    "do a bit-blt, but only copy the low-bit plane;
     copy bits from the rectangle defined by
     srcX/srcY and w/h from the sourceId drawable to the rectangle
     below dstX/dstY in the destId drawable. Trigger an error if any
     argument is not integer."

    ^ self
	copyFromId:sourceId
		 x:srcX y:srcY gc:srcDCId
		to:destId x:dstX y:dstY gc:dstDCId
	     width:w height:h
!

displayArcX:x y:y width:width height:height from:startAngle angle:angle in:ignoredDrawableId with:aGCId
    "draw an arc. If any of x,y, w or h is not an integer, an error is triggered.
     The angles may be floats or integer - they are given in degrees."

%{
    int __x, __y, w, h;
    float angle1, angle2;
    double f;

    if (__isSmallInteger(startAngle))
	angle1 = (float)(__intVal(startAngle));
    else if (__isFloat(startAngle)) {
	angle1 = (float) __floatVal(startAngle);
    } else if (__isShortFloat(startAngle)) {
	angle1 = __shortFloatVal(startAngle);
    } else goto bad;

    if (__isSmallInteger(angle))
	angle2 = (float)(__intVal(angle));
    else if (__isFloat(angle)) {
	angle2 = (float) __floatVal(angle);
    } else if (__isShortFloat(angle)) {
	angle2 = __shortFloatVal(angle);
    } else goto bad;

    if (angle2 <= 0) {
	RETURN (self);
    }

    if (__isExternalAddress(aGCId)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height))
     {
	struct gcData *gcData = _GCDATA(aGCId);
	HDC hDC;
	POINT p;

	w = __intVal(width);
	h = __intVal(height);
	__x = __intVal(x);
	__y = __intVal(y);

	hDC = _getDC(gcData);

	if (! GcDataGetPen(hDC, gcData)) {
	    DPRINTF(("displayArc: no pen\n"));
	} else {
	    double xB, yB, xE, yE, xR, yR;

	    xR = w / 2;
	    yR = h / 2;
	    if (angle2 - angle1 >= 360) {
		xB = xE = __x + xR + 0.5;
		yB = yE = __y /*+ yR + 0.5*/;
	    } else {
		double sin(), cos();
		float rad1, rad2;

		if (angle1 <= 180)
		  angle1 = 180 - angle1;
		else
		  angle1 = 360 + 180 - angle1;
		angle2 = angle1 - angle2;
		/* sigh - compute the intersections ... */
		rad1 = (angle1 * 3.14159265359) / 180.0;
		rad2 = (angle2 * 3.14159265359) / 180.0;
		xB = cos(rad1) * xR;
		yB = sin(rad1) * yR;
		xE = cos(rad2) * xR;
		yE = sin(rad2) * yR;
		xB = __x + xR - xB + 0.5;
		yB = __y + yR - yB + 0.5;
		xE = __x + xR - xE + 0.5;
		yE = __y + yR - yE + 0.5;
	    }
	    DPRINTF(("Arc x=%d y=%d w=%d h=%d xB=%d xE=%d yB=%d yE=%d a1=%f a2=%f\n",__x,__y,w,h,(int)xB,(int)xE,(int)yB,(int)yE,angle1,angle2));
	    Arc(hDC,
		__x, __y,
		__x + w, __y + h,
		(int)xB, (int)yB,
		(int)xE, (int)yE);

	    GcDataReleasePen(hDC, gcData);
	}
#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
	RETURN ( self );
    }
    bad: ;
%}.
    self primitiveFailed
!

displayLineFromX:x0 y:y0 toX:x1 y:y1 in:ignoredDrawableId with:aGCId
    "draw a line. If the coordinates are not integers, an error is triggered."

%{  /* NOCONTEXT */
    if (__isExternalAddress(aGCId)
     && __bothSmallInteger(x0, y0)
     && __bothSmallInteger(x1, y1)) {
	struct gcData *gcData = _GCDATA(aGCId);
	int __x1 = __intVal(x1), __y1 = __intVal(y1);
	HDC hDC = _getDC(gcData);

/*      DPRINTF(("displayLine: %d/%d -> %d/%d\n",
		    __intVal(x0), __intVal(y0),
		    __x1, __y1));
*/
	if (! GcDataGetPen(hDC, gcData)) {
	    DPRINTF(("displayLine: no pen\n"));
	} else {
	    MoveToEx(hDC, __intVal(x0), __intVal(y0), NULL);

	    LineTo(hDC, __x1, __y1);

	    /*
	     * end-point ...
	     */
	    LineTo(hDC, __x1+1, __y1);

	    GcDataReleasePen(hDC, gcData);
	}
#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
	RETURN ( self );
    }
%}
!

displayPointX:px y:py in:ignoredDrawableId with:aGCId
    "draw a point. If x/y are not integers, an error is triggered."

%{  /* NOCONTEXT */
    if (__isExternalAddress(aGCId)
     && __bothSmallInteger(px, py)) {
	struct gcData *gcData = _GCDATA(aGCId);
	HDC hDC;
	POINT p;
	int __x = __intVal(px), __y = __intVal(py);

#ifdef OLD
	int savedLStyle = gcData->lStyle;
	int savedLWidth = gcData->lineWidth;

	/*
	 * a point is a point - no matter what lineWidth we have set before
	 */
	if ((gcData->lStyle != PS_SOLID)
	 || (gcData->lineWidth > 1)) {
	    FLUSH_CACHED_DC(gcData);
	    gcData->lStyle = PS_SOLID;
	    gcData->lineWidth = 0;
	}

	hDC = _getDC(gcData);

	if (! GcDataGetPen(hDC,gcData)) {
	    DPRINTF(("displayPoint: no pen\n"));
	} else {
	    MoveToEx(hDC, __x, __y, NULL);
	    /*
	     * end-point ...
	     */
	    LineTo(hDC, __x+1, __y);

	    GcDataReleasePen(hDC, gcData);
	}

# ifndef CACHE_LAST_DC
	_releaseDC(gcData);
# endif
	if ((gcData->lStyle != savedLStyle)
	 || (gcData->lineWidth != savedLWidth)) {
	    FLUSH_CACHED_DC(gcData);
	    gcData->lStyle = savedLStyle;
	    gcData->lineWidth = savedLWidth;
	}
#else /* NEW */

	hDC = _getDC(gcData);
	SetPixelV(hDC, __x, __y, gcData->fgColor);
# ifndef CACHE_LAST_DC
	_releaseDC(gcData);
# endif

#endif /* NEW */
	RETURN ( self );
    }
%}
!

displayPolygon:aPolygon in:ignoredDrawableId with:aGCId
    "draw a polygon, the argument aPolygon is a Collection of individual points,
     which define the polygon.
     If any coordinate is not integer, an error is triggered."

    |numberOfPoints|

    numberOfPoints := aPolygon size.

%{
    OBJ point, px, py;
    int i, num;

    if (__isExternalAddress(aGCId)
     && __isSmallInteger(numberOfPoints)) {
	struct gcData *gcData = _GCDATA(aGCId);
	HDC hDC = 0;
	POINT p;

	num = __intVal(numberOfPoints);

	for (i=0; i<num; i++) {
	    point = __AT_(aPolygon, __MKSMALLINT(i+1));
	    if (! __isPoint(point)) goto fail;
	    px = _point_X(point);
	    py = _point_Y(point);
	    if (! __bothSmallInteger(px, py)) {
		goto fail;
	    }
	}

	hDC = _getDC(gcData);
	if (! GcDataGetPen(hDC,gcData)) {
	    DPRINTF(("displayPolygon: no pen\n"));
	} else {
	    for (i=0; i<num; i++) {
		point = __AT_(aPolygon, __MKSMALLINT(i+1));
		px = _point_X(point);
		py = _point_Y(point);
		p.x = __intVal(px);
		p.y = __intVal(py);
		if (i == 0) {
		    MoveToEx(hDC, p.x, p.y, NULL);
		} else {
		    if (i == (num-1)) {
			PolylineTo(hDC, &p, 1);
		    } else {
			LineTo(hDC, p.x, p.y);
#ifdef PRE_04_JUN_04
			/*
			 * end-point ...
			 */
			LineTo(hDC, p.x+1, p.y);
#endif
		    }
		}
	    }
	    GcDataReleasePen(hDC, gcData);
	}

#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
	RETURN ( self );
    }
fail: ;
%}
!

displayPolylines:aPolyline in:ignoredDrawableId with:aGCId
    "draw a polyline, the argument aPolyline is a collection of individual points,
     which define the lines (p1/p2 pairs); must be even in size.
     If any coordinate is not integer, an error is triggered."

    |numberOfPoints|

    numberOfPoints := aPolyline size.

%{
    OBJ point, px, py;
    int i, num;

    if (__isExternalAddress(aGCId)
     && __isSmallInteger(numberOfPoints)) {
	struct gcData *gcData = _GCDATA(aGCId);
	HDC hDC = 0;
	POINT p;

	num = __intVal(numberOfPoints);

	for (i=0; i<num; i++) {
	    point = __AT_(aPolyline, __MKSMALLINT(i+1));
	    if (! __isPoint(point)) goto fail;
	    px = _point_X(point);
	    py = _point_Y(point);
	    if (! __bothSmallInteger(px, py)) {
		goto fail;
	    }
	}

	hDC = _getDC(gcData);
	if (! GcDataGetPen(hDC,gcData)) {
	    DPRINTF(("displayPolygon: no pen\n"));
	} else {
	    for (i=0; i<num; i++) {
		point = __AT_(aPolyline, __MKSMALLINT(i+1));
		px = _point_X(point);
		py = _point_Y(point);
		p.x = __intVal(px);
		p.y = __intVal(py);
		if ((i & 1) == 0) {
		    MoveToEx(hDC, p.x, p.y, NULL);
		} else {
		    LineTo(hDC, p.x, p.y);
		    /*
		     * end-point ...
		     */
		    LineTo(hDC, p.x+1, p.y);
		}
	    }
	    GcDataReleasePen(hDC, gcData);
	}

#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
	RETURN ( self );
    }
fail: ;
%}
!

displayRectangleX:x y:y width:width height:height in:ignoredDrawableId with:aGCId
    "draw a rectangle. If the coordinates are not integers, an error is triggered."

%{  /* NOCONTEXT */
    int w, h;
    int xL, yT;
    if (__isExternalAddress(aGCId)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height)) {
	struct gcData *gcData = _GCDATA(aGCId);
	HDC hDC = _getDC(gcData);

	xL = __intVal(x);
	yT = __intVal(y);
	w = __intVal(width);
	h = __intVal(height);

	DDDDPRINTF(("displayRectangle: %d/%d -> %d/%d\n",
			xL, yT, w, h));

	if ((w >= 0) && (h >= 0)) {
	    if (! GcDataGetPen(hDC,gcData)) {
		DPRINTF(("displayRect: no pen\n"));
	    } else {
		MoveToEx(hDC, xL, yT, NULL);
#if 0
		LineTo(hDC, xL+w, yT);     // to top-right
		LineTo(hDC, xL+w, yT+h);   // to bot-right
		LineTo(hDC, xL, yT+h);     // to bot-left
		LineTo(hDC, xL, yT);       // back to top-left
#else
		LineTo(hDC, xL+w, yT);       // to top-right
		LineTo(hDC, xL+w, yT+h);     // to bot-right
		MoveToEx(hDC, xL, yT, NULL); // back to top-left
		LineTo(hDC, xL, yT+h);       // to bot-left

#ifndef PRE_31_JAN_03
		LineTo(hDC, xL+w+1, yT+h);   // move pen one pixel more
#else
		LineTo(hDC, xL+w, yT+h);     // to bot-right
#endif

#endif

		GcDataReleasePen(hDC, gcData);
	    }
	}
#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
	RETURN ( self );
    }
%}
!

displayString:aString from:index1 to:index2 x:x y:y in:ignoredDrawableId with:aGCId opaque:opaque
    "draw a sub-string - if opaque is false, draw foreground only; otherwise, draw both
     foreground and background characters.
     If the coordinates are not integers, an error is triggered."
%{  /* NOCONTEXT */
  /* NOTICE:
   * A change here was forced by (an undocumented) limited internal display buffer. 
   * A check is needed to draw against such internal limit; then draw it chunk-by-chunk.
   */

    unsigned char *cp;
    OBJ cls;
    SIZE size;
    TEXTMETRICW tmet;
    short maxDisplayBuffer;
    int i1, i2, n, l;
    int maxWidth, toDisplay;
    int nInstBytes;

    if (__isExternalAddress(aGCId)
     && __isNonNilObject(aString)
     && __bothSmallInteger(index1, index2)
     && __bothSmallInteger(x, y))
    {
	struct gcData *gcData;
	int pX, pY;
	HDC hDC;
	HFONT hOldFont;

	i1 = __intVal(index1) - 1;
	i2 = __intVal(index2) - 1;
	if ((i1 < 0) || (i2 < i1)) {
	    RETURN (self);
	}

	gcData = _GCDATA(aGCId);
	hDC = _getDC(gcData);
	pX = __intVal(x);
	pY = __intVal(y);
	pY -= gcData->fontAscent;

	if (opaque == true) {
	    if (gcData->bkMode != BK_OPAQUE) {
		SetBkMode(hDC, OPAQUE);
		gcData->bkMode = BK_OPAQUE;
	    }
	} else {
	    if (gcData->bkMode != BK_TRANSPARENT) {
		SetBkMode(hDC, TRANSPARENT);
		gcData->bkMode = BK_TRANSPARENT;
	    }
	}

  /* The Windows (as in 7 or newer) limits the string size for TextOut*.  There is apparently 
   * an undocumented limit to the overall raster size.  It changes according to the font size (width)!
   * The maximum value for the raster size is apparently 16384 (experimentally tested on Windows 7).
   */


  /* GetTextMetricsW gives all needed font metrics (has a fallback when fails)
   * - a maxWidth parameter takes in account the worst case scenario - user prints 
   * with the widest possible characters from the selected font.
   * - a overHang is a parameter which allows the font to grow outside the maxWidth size
   */

  if (GetTextMetricsW(hDC, &tmet)) {
      maxWidth = tmet.tmMaxCharWidth;
      // Dynamically calculate the maximum buffer size for the selected font and its size
      maxDisplayBuffer = 16384 / (maxWidth + tmet.tmOverhang);
  } else {
      /* A fallback when GetTextMetricsW fails.  Should not normally happen!
       * The works case scenario, experimentally tested from 1170 fonts, is Microsoft Uighur-build-italic-288
       * with maxWidth = 2179.  That would mean only 7 characters at the maxDisplayBuffer (16384 / 2179).
       * Such a buffer would be rediculously slow!. A compromise is needed (speed vs. functionality)
       * Taking an avgWidth from all 1170 with fonts size 96pt -> avgWidth = 152,
       * which should suffice 99.9% of time. The buffer would then be int(16384/152) = 107, which is reasonable.
       */
      maxDisplayBuffer = 107;
  }

#if 0
	/* leftover code from tries to make TextOut honor the gc-mode,
	 * until I googled, that TextOut does not (by purpose, or backward-bug compatibility)
	 */
	hOldFont = SelectObject(hDC, gcData->hFont);
	SetTextColor(hDC, gcData->fgColor);
	SetBkColor(hDC, gcData->bgColor);
#endif
#if 0
	GcDataGetPen(hDC, gcData);
#endif

	cls = __qClass(aString);
	cp = __stringVal(aString);
	l = i2 - i1 + 1;
	toDisplay = l;

	/* Set the current point to the reference point. */
	SetTextAlign(hDC, TA_UPDATECP);
	MoveToEx(hDC, pX, pY, NULL);

	if (__isStringLike(aString)) {
	    n = __stringSize(aString);
commonOutChars:
	    if (i2 < n) {
	        cp += i1;
	        do {
	            /* TA_UPDATECP used => pX, pY ignored */
	            if (! TextOutA(hDC, 0, 0, (char *)cp, MIN(toDisplay, maxDisplayBuffer))) { 
	                PRINTF(("WinWorkstation [warning]: TextOutA failed. [%d]\n", __LINE__));
	                PRINTF(("WinWorkstation [warning]: lastError=%d x:%d y:%d len:%d leftToShow=%d\n", GetLastError(), pX, pY, l, toDisplay));
	                goto error;
	            }
	            cp += maxDisplayBuffer;
	            toDisplay -= maxDisplayBuffer;
	        } while(toDisplay > 0);
	    }
	    goto ret;
	}

	nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	cp += nInstBytes;
	n = __byteArraySize(aString) - nInstBytes;

	if (__isBytes(aString)) {
	    goto commonOutChars;
	}

	/* Unicode */
	if (__isWords(aString)) {
	    n = n / 2;
	    WIDECHAR *w_cp = (WIDECHAR *)cp;
	    if (i2 < n){
	        w_cp += i1;
	        do {
	            /* TA_UPDATECP used => pX, pY ignored */
	            if (! TextOutW(hDC, 0, 0, w_cp, MIN(toDisplay, maxDisplayBuffer))) { 
	                PRINTF(("WinWorkstation [warning]: TextOutW failed. [%d]\n", __LINE__));
	                PRINTF(("WinWorkstation [warning]: lastError=%d x:%d y:%d len:%d leftToShow=%d\n", GetLastError(), pX, pY, l, toDisplay));
	                goto error;
	            }
	            w_cp += maxDisplayBuffer;
	            toDisplay -= maxDisplayBuffer;
	        } while (toDisplay > 0);
	    }
	    goto ret;
	}
ret:;
#if 0
	GcDataReleasePen(hDC, gcData);
#endif
#if 0
	SelectObject(hDC, hOldFont);
#endif
#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
    }
    RETURN (self);
error: ;;
%}.
    self textOutFailed.
!

drawBits:imageBits
    bitsPerPixel:bitsPerPixel
    depth:imageDepth padding:padd
    width:imageWidth height:imageHeight
    x:srcx y:srcy
    into:ignoredDrawableId
    x:dstx y:dsty
    width:w height:h
    with:aGCId

    "draw a bitImage which has depth imageDepth, width iw and height ih into
     the drawable. draw a region of w/h pixels from srcx/srcy to dstx/dsty.
     Individual source pixels have bitsPerPixel bits, allowing to draw
     depth and pixel-units to be different (in theory).
     It has to be checked elsewhere, that the server can do it with the given
     depth - otherwise, primitive failure will be signalled.
     Also it is assumed, that the colormap is setup correctly and the
     colors are allocated - otherwise the colors may be wrong."

    (self
	primDrawBits:imageBits
	bitsPerPixel:bitsPerPixel
	depth:imageDepth
	width:imageWidth height:imageHeight
	x:srcx y:srcy
	into:ignoredDrawableId
	x:dstx y:dsty
	width:w height:h
	with:aGCId
	parameters:(Array with:nil with:padd with:nil with:nil with:nil)
	"/ the params array is ONLY used, because there is a 15-argument limit in st/x !!
    ) ifFalse:[
	"
	 also happens, if a segmentation violation occurs in the
	 XPutImage ...
	"
	self primitiveFailed
    ].
!

drawBits:imageBits
    bitsPerPixel:bitsPerPixel
    depth:imageDepth
    width:imageWidth height:imageHeight
    x:srcx y:srcy
    into:ignoredDrawableId
    x:dstx y:dsty
    width:w height:h
    with:aGCId
    parameters:parameters

    "draw a bitImage which has depth id, width iw and height ih into
     the drawable. draw a region of w/h pixels from srcx/srcy to dstx/dsty.
     Individual source pixels have bitsPerPixel bits, allowing to draw
     depth and pixel-units to be different (in theory).
     It has to be checked elsewhere, that the server can do it with the given
     depth - otherwise, primitive failure will be signalled.
     Also it is assumed, that the colormap is setup correctly and the
     colors are allocated - otherwise the colors may be wrong."

    (self
	primDrawBits:imageBits
	bitsPerPixel:bitsPerPixel
	depth:imageDepth
	width:imageWidth height:imageHeight
	x:srcx y:srcy
	into:ignoredDrawableId
	x:dstx y:dsty
	width:w height:h
	with:aGCId
	parameters:parameters
	"/ the params array is ONLY used, because there is a 15-argument limit in st/x !!
    ) ifFalse:[
	"
	 also happens, if a segmentation violation occurs in the
	 XPutImage ...
	"
	self primitiveFailed
    ].
!

fillArcX:x y:y width:width height:height from:startAngle angle:angle
	       in:ignoredDrawableId with:aGCId
    "fill an arc. If any coordinate is not integer, an error is triggered.
     The angles may be floats or integer - they are given in degrees."

%{
    int __x, __y, w, h;
    float angle1, angle2;

    if (__isSmallInteger(startAngle))
	angle1 = (float)(__intVal(startAngle));
    else if (__isFloat(startAngle)) {
	angle1 = __floatVal(startAngle);
    } else if (__isShortFloat(startAngle)) {
	angle1 = __shortFloatVal(startAngle);
    } else goto bad;

    if (__isSmallInteger(angle))
	angle2 = (float)(__intVal(angle));
    else if (__isFloat(angle)) {
	angle2 = __floatVal(angle);
    } else if (__isShortFloat(angle)) {
	angle2 = __shortFloatVal(angle);
    } else goto bad;

    if (angle2 <= 0) {
	RETURN (self);
    }

    if (__isExternalAddress(aGCId)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height))
     {
	struct gcData *gcData = _GCDATA(aGCId);
	HDC hDC;
	HBRUSH hBrush;
	HPEN prevPen = 0;

	w = __intVal(width);
	h = __intVal(height);
	__x = __intVal(x);
	__y = __intVal(y);

	hDC = _getDC(gcData);

	hBrush = GcDataGetBrush(hDC, gcData);
	if (hBrush == 0) {
	    DPRINTF(("fillArc: no brush\n"));
	} else {
	    HPEN hPen = 0;

#if 0
	    hPen = GcDataGetPen(hDC, gcData);
	    if (hPen == 0) {
		DPRINTF(("fillArc: no pen\n"));
		goto failpen;
	    }
#else
	    prevPen = SelectObject(hDC, __nullPen);
	    w++;
	    h++;
#endif
	    {
		double xB, yB, xE, yE, xR, yR;

		xR = w / 2;
		yR = h / 2;
		if (angle2 - angle1 >= 360) {
		    xB = xE = __x + xR + 0.5;
		    yB = yE = __y /*+ yR + 0.5*/;
		} else {
		    double sin(), cos();
		    float rad1, rad2;

		    if (angle1 <= 180)
			angle1 = 180 - angle1;
		    else
			angle1 = 360 + 180 - angle1;
		    angle2 = angle1 - angle2;
		    /* sigh - compute the intersections ... */
		    rad1 = (angle1 * 3.14159265359) / 180.0;
		    rad2 = (angle2 * 3.14159265359) / 180.0;
		    xB = cos(rad1) * xR;
		    yB = sin(rad1) * yR;
		    xE = cos(rad2) * xR;
		    yE = sin(rad2) * yR;
		    xB = __x + xR - xB + 0.5;
		    yB = __y + yR - yB + 0.5;
		    xE = __x + xR - xE + 0.5;
		    yE = __y + yR - yE + 0.5;
		}
		DPRINTF(("fillArc x=%d y=%d w=%d h=%d xB=%d xE=%d yB=%d yE=%d a1=%f a2=%f\n",__x,__y,w,h,(int)xB,(int)xE,(int)yB,(int)yE,angle1,angle2));

		Pie(hDC,
		    __x, __y,
		    __x + w + 1, __y + h + 1,
		    (int)xB, (int)yB,
		    (int)xE, (int)yE);

		if (hPen) {
		    GcDataReleasePen(hDC, gcData);
		}
	    }
failpen:
#ifdef CACHE_LAST_CG
	    if (prevPen) SelectObject(hDC, prevPen);
#endif
	    GcDataReleaseBrush(hDC, gcData);
	}
#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
	RETURN ( self );
    }
    bad: ;
%}.
    self primitiveFailed
!

fillPolygon:aPolygon in:ignoredDrawableId with:aGCId
    "fill a polygon given by its points.
     If any coordinate is not integer, an error is triggered."

    |numberOfPoints|

    numberOfPoints := aPolygon size.
    self
	primFillPolygon:aPolygon n:numberOfPoints
	in:ignoredDrawableId with:aGCId
!

fillRectangleX:x y:y width:width height:height in:ignoredDrawableId with:aGCId
    "fill a rectangle. If any coordinate is not integer, an error is triggered."

%{  /* NOCONTEXT */

    int w, h;
    if (__isExternalAddress(aGCId)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height)) {
	w = __intVal(width);
	h = __intVal(height);

	if ((w >= 0) && (h >= 0)) {
	    struct gcData *gcData = _GCDATA(aGCId);
	    HDC hDC;
	    HBRUSH hBrush;
	    RECT rct;

	    hDC = _getDC(gcData);

	    hBrush = GcDataGetBrush(hDC, gcData);
	    if (! hBrush) {
		PRINTF(("fillRectangle: no brush\n"));
	    } else {
		rct.left = __intVal(x);
		rct.top  = __intVal(y);

#ifndef PRE_31_JAN_03
		rct.right  = rct.left + w;
		rct.bottom = rct.top  + h;
#else
		rct.right  = rct.left + w + 1;    /* definitiv ! */
		rct.bottom = rct.top  + h + 1;
#endif

		CPRINTF(("fillRectangle:%d.%d -> %d.%d\n",rct.left,rct.top,rct.right,rct.bottom));

		/*
		 * for solid draws (without function), can use FillRect,
		 * which is faster and does not need a pen.
		 */
		if ((gcData->rop2 == R2_COPYPEN)
		 && (gcData->bitbltrop2 == BITBLT_COPY)) {
		    AQUIRE_DRAW_MUTEX
		    FillRect(hDC, &rct, hBrush);
		    RELEASE_DRAW_MUTEX
		    GcDataReleaseBrush(hDC, gcData);
		} else {
		    HPEN prevPen;

		    prevPen = SelectObject(hDC, __nullPen);
/* sigh - conflict between ST/X's Rectangle and Win32's Rectangle */
# undef Rectangle

#ifndef PRE_31_JAN_03
		    Rectangle(hDC, rct.left, rct.top, rct.right +1, rct.bottom +1);
#else
		    Rectangle(hDC, rct.left, rct.top, rct.right, rct.bottom);
#endif

# define Rectangle __DEF_Rectangle
		    GcDataReleaseBrush(hDC, gcData);
#ifdef CACHE_LAST_DC
		    SelectObject(hDC, prevPen);
#endif
		}
	    }
#ifndef CACHE_LAST_DC
	    _releaseDC(gcData);
#endif
	}
	RETURN ( self );
    }
%}
!

primDrawBits:imageBits
	bitsPerPixel:bitsPerPixel depth:imageDepth
	width:imageWidth height:imageHeight
	x:srcx y:srcy
	into:ignoredDrawableId
	x:dstx y:dsty
	width:w height:h
	with:aGCId
	parameters:params

    |sourceAlphaOrNil padd redMask greenMask blueMask|

    "/ the params array is ONLY used, because there is a 15-argument limit in st/x
    sourceAlphaOrNil := params at:1.
    padd := params at:2.
    redMask := params at:3.
    greenMask := params at:4.
    blueMask := params at:5.
%{
    unsigned char fastBits[10000];
    unsigned char *b_bits = 0;
    unsigned char *allocatedBits = 0;
    struct gcData *gcData = 0;
    HDC hDC = (HDC)0;
    unsigned char *__imageBits = 0;
    int _sourceAlpha = 0;
    int _doAlphaBlend = 0;

    if (__isByteArray(imageBits)) {
	__imageBits = __ByteArrayInstPtr(imageBits)->ba_element;
    } else if (__isExternalBytesLike(imageBits)) {
	__imageBits = (unsigned char *)(__externalBytesAddress(imageBits));
    }

    if (ISCONNECTED
     && __isExternalAddress(aGCId)
     && __bothSmallInteger(srcx, srcy)
     && __bothSmallInteger(dstx, dsty)
     && __bothSmallInteger(w, h)
     && __bothSmallInteger(imageWidth, imageHeight)
     && __bothSmallInteger(imageDepth, bitsPerPixel)
     && __isSmallInteger(padd)
     && __imageBits)
     {
	struct
	{
	  BITMAPINFOHEADER bmiHeader;
	  DWORD r;
	  DWORD g;
	  DWORD b;
	  DWORD a;
	} bitmap;
	int _padd = __intVal(padd);

	gcData = _GCDATA(aGCId);
	if (! gcData )
	    goto fail;
	hDC = _getDC(gcData);
	DDDDPRINTF(("hDC = %x\n", hDC));

	if (_padd != WIN32PADDING) {
	    int row, col;
	    unsigned char *cp;
	    unsigned char *pBits;
	    int b_width, b_height, bytesPerRowST, bytesPerRowWIN, padding, nBytes;
	    int bi = __intVal(bitsPerPixel);

	    b_width = __intVal(imageWidth);
	    b_height = __intVal(imageHeight);
	    bytesPerRowST = (b_width * bi + (_padd-1)) / _padd;
	    bytesPerRowWIN = (b_width * bi + (WIN32PADDING-1)) / WIN32PADDING * (WIN32PADDING/8);
	    padding = bytesPerRowWIN - bytesPerRowST;
	    /* console_printf("padd %d bs %d bw %d p %d\n",_padd,bytesPerRowST,bytesPerRowWN,padding); */
	    if (padding) {
		nBytes = b_height * bytesPerRowWIN;
		if (nBytes < sizeof(fastBits)) {
		    cp = b_bits = fastBits;
		} else {
		    cp = b_bits = allocatedBits = (unsigned char *) malloc(nBytes);
		}
		if (cp) {
		    pBits = __imageBits;
		    for (row = b_height; row; row--) {
			for (col = bytesPerRowST; col; col--) {
			    *cp++ = *pBits++;
			}
			cp += padding;
		    }
		} else
		    goto fail;
	    }
	}

	if (b_bits == 0) {
	    b_bits = __imageBits;
	}

	bitmap.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
	bitmap.bmiHeader.biPlanes = 1;
	switch (__intVal(imageDepth)) {
	    case 16:
		/* notice the default r/g/b (STX order here) */
#if 1
		bitmap.bmiHeader.biCompression = BI_BITFIELDS;
		bitmap.r = redMask == nil ? 0xf800 : __intVal(redMask);
		bitmap.g = greenMask == nil ? 0x07e0 : __intVal(greenMask);
		bitmap.b = blueMask == nil ? 0x001f : __intVal(blueMask);
#endif
		break;

	    case 24:
		/* notice the default b/g/r (WIN32 order here) */
#if 0
		bitmap.bmiHeader.biCompression = BI_BITFIELDS;
		bitmap.r = redMask == nil ? 0xff0000 : __intVal(redMask);
		bitmap.g = greenMask == nil ? 0x00ff00 : __intVal(greenMask);
		bitmap.b = blueMask == nil ? 0x0000ff : __intVal(blueMask);
#endif
		bitmap.bmiHeader.biCompression = BI_RGB;
		break;

	    case 32:
		/* notice the default r/g/b (STX order here) */
		bitmap.bmiHeader.biCompression = BI_RGB;
#if 1
		bitmap.bmiHeader.biCompression = BI_BITFIELDS;
		bitmap.r = redMask == nil ? 0x0000ff : __intVal(redMask);
		bitmap.g = greenMask == nil ? 0x00ff00 : __intVal(greenMask);
		bitmap.b = blueMask == nil ? 0xff0000 : __intVal(blueMask);
		bitmap.a = 0xff000000;
#endif
		break;
	}

	if (sourceAlphaOrNil != nil) {
console_printf("sourceAlphaOrNil = %x\n", sourceAlphaOrNil);
	    _sourceAlpha = __intVal(sourceAlphaOrNil);
	    _doAlphaBlend = 1;
	}

	bitmap.bmiHeader.biSizeImage = 0;
	bitmap.bmiHeader.biXPelsPerMeter = 0;
	bitmap.bmiHeader.biYPelsPerMeter = 0;
	bitmap.bmiHeader.biClrUsed = 0;
	bitmap.bmiHeader.biClrImportant = 0;
	bitmap.bmiHeader.biWidth = __intVal(imageWidth);
	bitmap.bmiHeader.biHeight = -(__intVal(imageHeight));
	bitmap.bmiHeader.biBitCount = __intVal(bitsPerPixel);
	/*console_printf("drawBits depth:%d bitsPerPixel:%d IW%d W:%d H:%d\n",__intVal(imageDepth),bitmap.bmiHeader.biBitCount,bitmap.bmiHeader.biWidth,__intVal(w),bitmap.bmiHeader.biHeight);*/

	if (! _doAlphaBlend) {
	    SetDIBitsToDevice(hDC,
				__intVal(dstx), __intVal(dsty),
				__intVal(w), __intVal(h),
				__intVal(srcx), __intVal(srcy),
				0, __intVal(h),
				(void *)b_bits,
				(BITMAPINFO*)&bitmap,
				DIB_RGB_COLORS);
	} else {
	    HDC ahdc;
	    HBITMAP ahbitmap;
	    void *pvBits;
	    BLENDFUNCTION bf;
	    static BOOL (__stdcall *P_AlphaBlend)(HDC, int, int, int, int, HDC, int, int, int, int, BLENDFUNCTION );

	    if (P_AlphaBlend == 0) {
		/* as I dont have AlphaBlend in the inport32.lib (bcc sucks),
		 * fetch its address dynamically...
		 */
		HINSTANCE hWinGDI = LoadLibrary("msimg32.dll");
		if (hWinGDI) {
		    P_AlphaBlend = (BOOL (__stdcall *)(HDC, int, int, int, int, HDC, int, int, int, int, BLENDFUNCTION ))
					GetProcAddress(hWinGDI, "AlphaBlend");
		}
	    }
	    if (P_AlphaBlend != 0) {
console_printf("***********************************\n");
console_printf("_sourceAlpha = %d\n", _sourceAlpha);
		ahdc = CreateCompatibleDC(hDC);

		ahbitmap = CreateCompatibleBitmap(hDC, __intVal(imageWidth), __intVal(imageHeight));
		SelectObject(ahdc, ahbitmap);
		SetDIBitsToDevice(ahdc,
				0, 0,    /* dstx, dsty */
				__intVal(imageWidth), __intVal(imageHeight),
				__intVal(srcx), __intVal(srcy),
				0, __intVal(imageHeight),
				(void *)b_bits,
				(BITMAPINFO*)&bitmap,
				DIB_RGB_COLORS);

		bf.BlendOp = AC_SRC_OVER;
		bf.BlendFlags = 0;
		bf.SourceConstantAlpha = _sourceAlpha;
		bf.AlphaFormat = AC_SRC_ALPHA;
#if 1
		(*P_AlphaBlend) (hDC,
				__intVal(dstx), __intVal(dsty),
				__intVal(imageWidth), __intVal(imageHeight),
				ahdc,
				0, 0,     /* srcx, srcy */
				__intVal(imageWidth), __intVal(imageHeight),
				bf);
#else
		bf.SourceConstantAlpha = 255-_sourceAlpha;
		bf.AlphaFormat = 0;
		bf.BlendOp = 0;
		(*P_AlphaBlend) (ahdc,
				0, 0,     /* dstx, dsty */
				__intVal(imageWidth), __intVal(imageHeight),
				hDC,
				__intVal(dstx), __intVal(dsty),   /* srcx, srcy */
				__intVal(imageWidth), __intVal(imageHeight),
				bf);

		BitBlt (hDC,
				__intVal(dstx), __intVal(dsty),
				__intVal(imageWidth), __intVal(imageHeight),
				ahdc,
				0, 0,   /* srcx, srcy */
				SRCCOPY);
#endif
		DeleteObject(ahbitmap);
		DeleteDC(ahdc);
	    }
	}
	if (allocatedBits) {
	    free(allocatedBits);
	}
#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
	RETURN ( true );
    }

fail: ;
    PRINTF(("create temp bitmap FAILED!!!\n"));
    if (allocatedBits) {
	PRINTF(("freeing up temp bitmap bits ...\n"));
	free(allocatedBits);
    }
#ifndef CACHE_LAST_DC
    if (hDC) {
	_releaseDC(gcData);
    }
#endif
%}
.
    ^ false
!

primFillPolygon:aPolygon n:numberOfPoints in:ignoredDrawableId with:aGCId

%{
    OBJ point, px, py;
    int i, num;

    if (__isExternalAddress(aGCId)
     && __isSmallInteger(numberOfPoints)) {
	struct gcData *gcData = _GCDATA(aGCId);
	HDC hDC;
	POINT p;
	HBRUSH hBrush;

	num = __intVal(numberOfPoints);
	if (num < 3) {
	    RETURN ( self );
	}
	for (i=0; i<num; i++) {
	    point = __AT_(aPolygon, __MKSMALLINT(i+1));
	    if (! __isPoint(point)) goto fail;
	    px = _point_X(point);
	    py = _point_Y(point);
	    if (! __bothSmallInteger(px, py))
		goto fail;
	}

	hDC = _getDC(gcData);

	hBrush = GcDataGetBrush(hDC,gcData);
	if (hBrush == 0) {
	    DPRINTF(("fillPolygon: no brush\n"));
	} else {
	    HPEN prevPen;

	    prevPen = SelectObject(hDC, __nullPen);

	    BeginPath(hDC);

	    for (i=0; i<num; i++) {
		point = __AT_(aPolygon, __MKSMALLINT(i+1));
		px = _point_X(point);
		py = _point_Y(point);
		if (i == 0) {
		    MoveToEx(hDC, __intVal(px), __intVal(py), NULL);
		} else {
		    if (i == (num-1)) {
			p.x = __intVal(px);
			p.y = __intVal(py);
			PolylineTo(hDC, &p, 1);
		    } else {
			LineTo(hDC, __intVal(px), __intVal(py));
		    }
		}
	    }

	    EndPath(hDC);
	    FillPath(hDC);
	    GcDataReleaseBrush(hDC, gcData);
#ifdef CACHE_LAST_DC
	    SelectObject(hDC, prevPen);
#endif
	}
#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
	RETURN ( self );

fail: ;
    }
%}
! !

!WinWorkstation methodsFor:'event forwarding'!

activate:aBoolean view:aView
    "some view was activated/deactivated.
     For compatibility we send a focus-event to that topView"

    aBoolean ifFalse:[
	activeView := nil.
	self focusOutView:aView.
    ] ifTrue:[
	activeView := aView.
	self focusInView:aView.
    ].

    "Created: / 28.4.1999 / 14:51:51 / cg"
    "Modified: / 28.4.1999 / 15:07:09 / cg"
!

configureX:x y:y width:w height:h view:aView
    "forward a configure for some view"

    aView realized ifTrue:[
	super configureX:x y:y width:w height:h view:aView
    ]

    "Modified: / 08-09-2006 / 19:40:18 / cg"
!

copyDataEvent:parameter eventData:dataBytes view:aView
    "forward a copyData event for some view as a client message"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor
	copyDataEvent:parameter
	eventData:dataBytes
	view:aView
!

displayChange
    "the display metrics/settings have changed.
     This is a speciality of windows.
     TODO: Tell the viewStyle to update itself,
	   and tell all views to reinit their style.
     For now,this is ignored, except for updating my metrics."

    self initializeVariableScreenProperties.
!

dropFiles:files view:view position:dropPosition handle:dropHandle
    "called when files are dropped from windows.
     The dropHandle is required to free Win32 data (and to remove the drop-file)
     eventually"

"/    Transcript showCR:'Drop files:'.
"/    Transcript show:'  View:'; showCR:view.
"/    Transcript show:'  Position:'; showCR:dropPosition.
"/    Transcript showCR:'  Files:'.
"/    files do:[:f|
"/        Transcript showCR:('    ', f printString)
"/    ].
"/
    view isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    view sensor
	dropFiles:files view:view position:dropPosition handle:dropHandle
!

fontChange
    "the system fonts (users preferences) have changed.
     This is a speciality of windows.
     TODO: Tell the viewStyle to update itself,
	   and tell all views to reinit their style.
     For now,this is ignored."

    IgnoreFontChanges ~~ true ifTrue:[
"/        'WinWorkstation [info]: fontChange ignored for now.' infoPrintCR
    ]

    "Modified: / 19.5.1999 / 23:37:17 / cg"
!

mouseWheelMotion:buttonState x:x y:y amount:amount deltaTime:dTime view:aView
    "the mousewheel event as delivered by win32 has a bug:
     the view passed here is always the topView - not the view under the pointer.
     For compatibility with unix, we figure out the view here from the pointer position
     and pass that one down (used to be the focus view, but that is inconvenient)."

    |wg screenPoint targetView|

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].

    UserPreferences current mouseWheelFocusFollowsMouse ifTrue:[
	screenPoint := self translatePointToRoot:(x@y) fromView:aView.
	targetView := self viewFromPoint:screenPoint.
    ].

    (targetView isNil) ifTrue:[
	(wg := aView windowGroup) notNil ifTrue:[
	    targetView := wg focusView.
	].
    ].

    aView sensor
	mouseWheelMotion:buttonState x:x y:y amount:amount deltaTime:dTime
	view:(targetView ? aView)

    "Modified: / 21.5.1999 / 13:05:53 / cg"
!

nativeWidgetCommand:commandId view:aView
    "forward a command event for some view.
     (Button, CheckBox etc.)"

    |sensor|

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    sensor := aView sensor.
    sensor
	nativeWidgetCommand:#'win32nativeWMCommand:'
	arguments:(Array with:commandId)
	view:aView
!

queryEndSession
    "system is about to be shut down.
     This is a speciality of windows.
     TODO: Tell all views to close themself.
     For now, this is ignored."

    'WinWorkstation [info]: queryEndSession ignored for now.' infoPrintCR.
    ^ true
!

settingsChange
    "some system settings (users preferences) have changed.
     This is a speciality of windows.
     For now, only a few attributes are reinitialized."

    self initializeVariableSettingsProperties.
!

systemColorChange:aWindow
    "the system colors (users preferences) have changed.
     This is a speciality of windows.
     Tell the viewStyle to update itself,
     and tell all view to reinit its style.

     The argument, aWindow is not used."

    |anyChange|

    IgnoreSysColorChanges ifFalse:[
	"/ first check, if there was really a change of any color that
	"/ we are interested in
	"/ (when exceed is running, we get plenty of those messages ...)

	anyChange := false.
	SystemColorValues synchronized:[
	    SystemColorValues copy keysAndValuesDo:[:eachKey :eachOldColor|
		|newColor|

		newColor := self primGetSystemColor:eachKey.
		newColor ~= eachOldColor ifTrue:[
		    SystemColorValues at:eachKey put:newColor.
		    anyChange := true.
		].
	    ].
	    anyChange ifTrue:[
		SimpleView readStyleSheetAndUpdateAllStyleCaches.
		"/ TODO: this should go through the sensor ...
		"/ ...and be handled as an event by the views thread.
		self allViewsDo:[:eachView| eachView reinitStyle].
	    ].
	].
    ]

    "
	Display systemColorChange:nil
    "
!

trayAction:eventCode view:aView
    "forward a tray event for some view."

    |sensor message arg|

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].

    eventCode == 512 "WM_MOUSEMOVE" ifTrue:[
	"/ mouse motion
	message := #trayMouseMotion
    ].
    eventCode == 513 "WM_LBUTTONDOWN" ifTrue:[
	"/ left-button-press
	message := #trayButtonPress:.
	arg := 1.
    ].
    eventCode == 514 "WM_LBUTTONUP" ifTrue:[
	"/ left-button-release
	message := #trayButtonRelease:.
	arg := 1.
    ].
    eventCode == 515 "WM_LBUTTONDBLCLK" ifTrue:[
	"/ left-button-double-click
	message := #trayButtonDoubleClick:.
	arg := 1.
    ].
    eventCode == 516 "WM_RBUTTONDOWN" ifTrue:[
	"/ right-button-press
	message := #trayButtonPress:.
	arg := 3.
    ].
    eventCode == 517 "WM_RBUTTONUP" ifTrue:[
	"/ right-button-release
	message := #trayButtonRelease:.
	arg := 3.
    ].
    eventCode == 518 "WM_RBUTTONDBLCLK" ifTrue:[
	"/ left-button-double-click
	message := #trayButtonDoubleClick:.
	arg := 3.
    ].
    eventCode == 519 "WM_MBUTTONDOWN" ifTrue:[
	"/ middle-button-press
	message := #trayButtonPress:.
	arg := 2.
    ].
    eventCode == 520 "WM_MBUTTONUP" ifTrue:[
	"/ middle-button-release
	message := #trayButtonRelease:.
	arg := 2.
    ].
    eventCode == 521 "WM_MBUTTONDBLCLK" ifTrue:[
	"/ middle-button-double-click
	message := #trayButtonDoubleClick:.
	arg := 2.
    ].

    message isNil ifTrue:[
	Transcript showCR:eventCode.
	^ self.
    ].

    sensor := aView sensor.
    sensor
	trayAction:message
	arguments:(Array with:arg)
	view:aView

    "Created: / 31-10-2007 / 00:13:31 / cg"
    "Modified: / 05-11-2007 / 12:14:28 / cg"
! !

!WinWorkstation methodsFor:'event forwarding-native'!

win32NativeScroll:scrollCode position:newPos view:aScrollBar
    "native scrollbar widget event."

    aScrollBar isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].

    self class debugNative ifTrue:[
	'WinWorkstation [info]: native scroll event' infoPrint.
	    ' code=' infoPrint.
	    scrollCode infoPrint.
	    ' position=' infoPrint.
	    newPos infoPrintCR.
    ].

    aScrollBar sensor
	nativeWidgetCommand:#win32NativeScroll:position:
	arguments:(Array with:scrollCode with:newPos) view:aScrollBar
! !

!WinWorkstation methodsFor:'event handling'!

dispatchEventFor:aViewIdOrNil withMask:eventMask
    "central event handling method:
     get next event and send appropriate message to the sensor or view.
     If the argument aViewIdOrNil is nil, events for any view are processed,
     otherwise only events for the view with given id are processed.
     If the argument aMask is nonNil, only events for this eventMask are
     handled.
     WARNING: this may block to wait for an event - you better check for a
	      pending event before calling this."

    (self getEventFor:aViewIdOrNil withMask:eventMask) ifTrue:[
	AbortSignal handle:[:ex |
	    ex return
	] do:[
	    self dispatchLastEvent.
	]
    ].

    "Modified: 19.8.1997 / 17:10:42 / cg"
!

dispatchExposeEventFor:aViewIdOrNil
    "get next expose event and send appropriate message to the sensor or view.
     If the argument aViewIdOrNil is nil, events for any view are processed,
     otherwise only events for the view with given id are processed."

    self dispatchEventFor:aViewIdOrNil withMask:(self eventMaskFor:#expose)
!

dispatchLastEvent
    |theView symS arg butt sibling windowID siblingID propertyID selectionID targetID requestorID
     eventType hotkeyId|

%{  /* xxSTACK: 8000 */
    struct queuedEvent *ev = 0;
    struct queuedEvent _ev_buf;
    struct inlineCache *ipS;

    static struct inlineCache vid = _ILC1;
    static struct inlineCache conf = _ILC5;
    static struct inlineCache skp = _ILC4;
    static struct inlineCache skr = _ILC4;
    static struct inlineCache exp = _ILC5;
    static struct inlineCache gexpS = _ILC6;
    static struct inlineCache nexpS = _ILC1;
    static struct inlineCache clr = _ILC5;
    static struct inlineCache bp = _ILC4;
    static struct inlineCache br = _ILC4;
    static struct inlineCache bmp = _ILC4;
    static struct inlineCache bsp = _ILC4;
    static struct inlineCache mot = _ILC4;
    static struct inlineCache mwh = _ILC6;
    static struct inlineCache unmap = _ILC1;
    static struct inlineCache map = _ILC1;
    static struct inlineCache termS = _ILC1;
    static struct inlineCache destr = _ILC1;
    static struct inlineCache setCurs = _ILC1;
    static struct inlineCache focOut = _ILC1;
    static struct inlineCache focIn = _ILC1;
    static struct inlineCache act = _ILC2;
    static struct inlineCache pe = _ILC4;
    static struct inlineCache pl = _ILC2;
    static struct inlineCache vis = _ILC1;
    static struct inlineCache sysClrChg = _ILC1;
    static struct inlineCache fontChg = _ILC0;
    static struct inlineCache settingChg = _ILC0;
    static struct inlineCache qEndSess = _ILC0;
    static struct inlineCache power = _ILC0;
    static struct inlineCache quit = _ILC0;
    static struct inlineCache command = _ILC2;
    static struct inlineCache trayMessage = _ILC2;
    static struct inlineCache win32NativeScroll = _ILC3;
    static struct inlineCache win32DrawItem = _ILC2;
    static struct inlineCache copyData = _ILC3;
    static struct inlineCache dropFiles = _ILC4;
    static struct inlineCache hkp = _ILC3;

    int x, y, w, h;
    int keyCode, modifiers, isDoubleClick = 0;
    int isDown = 1;
    int state, dir;
    OBJ upDown;
    OBJ eB;
    char nameBuffer[100];
    HWND hWnd = 0;

    DDDPRINTF(("dispatchLast\n"));

    eB = __INST(eventBuffer);

    if (__isByteArray(eB)) {
	ev = (struct queuedEvent *)(__ByteArrayInstPtr(eB)->ba_element);
    } else {
	console_fprintf(stderr, "WinWorkstation [error]: no eventBuffer\n");
	RETURN (false);
    }
    if (ev) {
	_ev_buf = *ev;
	ev = &_ev_buf;
    }
    hWnd = ev->ev_hWnd;
    if (!(hWnd /*&& IsWindow(hWnd)*/)) {
	DPRINTF(("wrong hWnd in event in dispatchLastEvent\n"));
	RETURN (false);
    }
    {
	OBJ t;

	/*
	 * very often, its another event for the same view ...
	 * avoid creation & lookup then.
	 */
#if 1
	if ((t = __INST(lastId)) != nil) {
	    if (__isExternalAddress(t)) {
		if (_HWNDVal(t) == hWnd) {
		    theView = __INST(lastView);
		    if (__isNonNilObject(theView)) {
			if (__qClass(theView) == nil) {
			    theView = nil;
			}
		    }
		}
	    }
	}
#endif
	if (theView == nil) {
	    windowID = __MKOBJ(ev->ev_hWnd);
	    theView = (*vid.ilc_func)(self, @symbol(viewFromId:), nil, &vid, windowID);
	}
    }

    if (theView == nil) {
	DPRINTF(("nil view [hWnd=%x msg=0x%x] in dispatchEvent\n",
		 ev->ev_hWnd, ev->ev_message));

	RETURN (false);
    }

    switch (ev->ev_message) {
	    DPRINTFIF((__debug_WM_ALL__) , ("message=%d 0x%x wparam=%"_lx_" hwnd=%"_lx_" arg1=%"_lx_")\n",
			ev->ev_message, ev->ev_message, (INT)(ev->ev_wParam), (INT)(ev->ev_hWnd), (INT)(ev->ev_arg1)));
	    case WM_WINDOWPOSCHANGED:
		{
		    RECT rct;

		    x = ev->ev_x;
		    y = ev->ev_y;
		    w = ev->ev_w;
		    h = ev->ev_h;

		    DPRINTF((">>> WM_WINDOWPOSCHANGED -> configure %d/%d , %d/%d\n", x,y,w,h));

		    (*conf.ilc_func)(self,
				     @symbol(configureX:y:width:height:view:),
				     nil, &conf,
				     __MKSMALLINT(x),
				     __MKSMALLINT(y),
				     __MKSMALLINT(w),
				     __MKSMALLINT(h),
				     theView);
		}
		break;

	    case WM_DROPFILES:
		{
		    HDROP hDrop = (HDROP) ev->ev_wParam;
		    int   count = DragQueryFile( hDrop,0xffffffff,0,0 );

		    DPRINTFIF((__debug_WM_DROPFILES__ | __debug_WM_ALL__) , ("count=%d hDrop=%x\n", count, hDrop));
		    if (count > 0) {
			OBJ  dropHandle, files, position;
			char buf[MAXPATH];
			int  i;

			dropHandle = __MKOBJ(hDrop);
			__PROTECT__(dropHandle);
			files = __ARRAY_NEW_INT( count );
			__UNPROTECT__(dropHandle);

			for (i = 0;i < count;i++) {
			    OBJ s;

			    DragQueryFile(hDrop,i,buf,sizeof(buf));
			    __PROTECT__(dropHandle);
			    __PROTECT__(files);
			    s = __MKSTRING(buf);
			    __UNPROTECT__(files);
			    __UNPROTECT__(dropHandle);
			    __ArrayInstPtr(files)->a_element[i] = s; __STORE(files, s);
			}

			{
			    POINT pos;

			    DragQueryPoint(hDrop, &pos);

			    __PROTECT__(dropHandle);
			    __PROTECT__(files);
			    position = __MKPOINT_INT(pos.x, pos.y);
			    __UNPROTECT__(files);
			    __UNPROTECT__(dropHandle);
			}

			(*dropFiles.ilc_func)
			    ( self
			      , @symbol(dropFiles:view:position:handle:)
			      , nil, &dropFiles,
			      files, theView, position, dropHandle
			    );
		    }
		}
		break;

	    case WM_SHOWWINDOW:
		if (ev->ev_wParam == TRUE) {
		    DPRINTF((">>> WM_SHOWWINDOW -> mappedView:\n"));
		    arg = @symbol(unobscured);
		    (*vis.ilc_func)(theView,
				    @symbol(visibilityChange:),
				    nil, &vis, arg);
		    (*map.ilc_func)(self,
				    @symbol(mappedView:),
				    nil, &map, theView);
		} else {
		    DPRINTF((">>> WM_SHOWWINDOW -> unMappedView:\n"));
#if 0
		    arg = @symbol(fullyObscured);
		    (*vis.ilc_func)(theView,
				    @symbol(visibilityChange:),
				    nil, &vis, arg);
#endif
		    (*unmap.ilc_func)(self,
				      @symbol(unmappedView:),
				      nil, &unmap, theView);
		}
		break;

	    case __WM_ICONIFIED:
		if (ev->ev_wParam) {
		    DPRINTF((">>> __WM_ICONIFIED -> unMappedView:\n"));
#if 0
		    arg = @symbol(fullyObscured);
		    (*vis.ilc_func)(theView,
				    @symbol(visibilityChange:),
				    nil, &vis, arg);
#endif
		    (*unmap.ilc_func)(self,
				      @symbol(unmappedView:),
				      nil, &unmap, theView);
		} else {
		    DPRINTF((">>> __WM_DEICONIFIED -> mappedView:\n"));
		    arg = @symbol(unobscured);
		    (*vis.ilc_func)(theView,
				    @symbol(visibilityChange:),
				    nil, &vis, arg);
		    (*map.ilc_func)(self,
				    @symbol(mappedView:),
				    nil, &map, theView);
		}
		break;

	    case WM_CLOSE:
		DPRINTF((">>> WM_CLOSE -> terminateView:\n"));
		(*termS.ilc_func)(self,
				  @symbol(terminateView:),
				  nil, &termS, theView);
		break;

	    case WM_DESTROY:
		DPRINTF((">>> WM_DESTROY -> destroyedView\n"));
		(*destr.ilc_func)(self,
				  @symbol(destroyedView:),
				  nil, &destr, theView);
		break;

	    case WM_ACTIVATE:

		switch (LOWORD(ev->ev_wParam)) {
		    case WA_INACTIVE:
			DPRINTF((">>> WM_ACTIVATE inactive h=%x\n", ev->ev_hWnd));
			(*act.ilc_func)(self,
					@symbol(activate:view:),
					nil, &act,
					false, theView);
			break;

		    case WA_ACTIVE:
		    case WA_CLICKACTIVE:
			DPRINTF((">>> WM_ACTIVATE active h=%x\n", ev->ev_hWnd));
			(*act.ilc_func)(self,
					@symbol(activate:view:),
					nil, &act,
					true, theView);
			break;

		    default:
			break;
		}
		break;

	    case WM_MOUSEACTIVATE:
		if (__debug_WM_MOUSEACTIVATE__ | __debug_WM_ALL__) {
		    PRINTF((">>> WM_MOUSEACTIVATE h=%x -> focusInView:\n", ev->ev_hWnd));
		}

		(*focIn.ilc_func)(self,
				  @symbol(focusInView:),
				  nil, &focIn, theView);
		break;

	    case WM_SETFOCUS:
		DPRINTFIF(__debug_WM_FOCUS__ , (">>> WM_SETFOCUS h=%x -> focusInView:\n", ev->ev_hWnd));
		(*focIn.ilc_func)(self,
				  @symbol(focusInView:),
				  nil, &focIn, theView);
		break;

	    case WM_KILLFOCUS:
		DPRINTFIF(__debug_WM_FOCUS__ , (">>> WM_KILLFOCUS h=%x -> focusOutOfView\n", ev->ev_hWnd));
		(*focOut.ilc_func)(self,
				   @symbol(focusOutView:),
				   nil, &focOut, theView);
		break;

	    case __WM_GEXPOSE:
		x = ev->ev_x;
		y = ev->ev_y;
		w = ev->ev_w;
		h = ev->ev_h;
		DPRINTF((">>> __WM_GEXPOSE -> gExpose %d/%d -> %d/%d\n", x, y, w, h));
#if 0
		if (GetWindow_unmapping(hWnd)) {
		    console_fprintf(stderr, "oops - __WM_GEXPOSE for unmapping\n");
		}
#endif
		(*gexpS.ilc_func)(self,
				  @symbol(graphicsExposeX:y:width:height:final:view:),
				  nil, &gexpS,
				  __MKSMALLINT(x),
				  __MKSMALLINT(y),
				  __MKSMALLINT(w),
				  __MKSMALLINT(h),
				  ev->ev_wParam ? true : false,
				  theView);
		break;

	    case __WM_NOGEXPOSE:
		DPRINTFIF((__debug_WM_EXPOSE__ | __debug_WM_ALL__), (">>> __WM_NOGEXPOSE -> noExpose\n"));
#if 0
		if (GetWindow_unmapping(hWnd)) {
		    console_fprintf(stderr, "oops - __WM_NOGEXPOSE for unmapping\n");
		}
#endif
		 (*nexpS.ilc_func)(self,
				   @symbol(noExposeView:), nil, &nexpS,
				   theView);
		break;

# ifdef LATE_GENERATE_EXPOSE
	    case __WM_PAINT:
		{
		    PAINTSTRUCT ps;

		    AQUIRE_DRAW_MUTEX
		    __generateExposes(hWnd, NULL, WM_PAINT, 0);
		    RELEASE_DRAW_MUTEX

# if 0
		    BeginPaint(hWnd, &ps);
		    EndPaint(hWnd, &ps);
# endif
		}
		break;
# endif

	    case WM_PAINT:
		x = ev->ev_x;
		y = ev->ev_y;
		w = ev->ev_w;
		h = ev->ev_h;

#if 0
		if (GetWindow_unmapping(hWnd)) {
		    console_fprintf(stderr, "oops - WM_PAINT for unmapping\n");
		}
#endif

#ifndef PRE_21_NOV
		__clearWindow(hWnd, x, y, w, h);
#else
# if WM_PAINT_CLEAR_LATE
		__clearWindow(hWnd, x, y, w, h);
# endif

#endif

#ifdef DEBUG_COLORIZE_WM_PAINT_RECTS2
		{
		    HDC hDC;
		    HBRUSH hBrush;
		    RECT rect;

		    hBrush = CreateSolidBrush(BlackPixel);
		    hDC = GetWindowDC(hWnd);
		    SelectClipRgn(hDC, NULL);
		    rect.left = x;
		    rect.top = y;
		    rect.right = x+w;
		    rect.bottom = y+h;

		    FillRect(hDC, &rect, hBrush);
		    _DeleteBrush(hBrush, __LINE__);
		    ReleaseDC(hWnd, hDC);
		}
#endif
		if (__debug_WM_PAINT__ | __debug_WM_ALL__) {
		    PRINTF((">>> WM_PAINT -> expose %d/%d -> %d/%d\n", x, y, w, h));
		}
		(*exp.ilc_func)(self,
			 @symbol(exposeX:y:width:height:view:),
			 nil, &exp,
			 __MKSMALLINT(x),
			 __MKSMALLINT(y),
			 __MKSMALLINT(w),
			 __MKSMALLINT(h),
			 theView);
		break;

	    case WM_LBUTTONDBLCLK:
		isDoubleClick = 1;
		butt = __MKSMALLINT(Button1);
		goto commonButton;

	    case WM_LBUTTONUP:
		isDown = 0;
		butt = __MKSMALLINT(Button1);
		goto commonButton;

	    case WM_LBUTTONDOWN:
		butt = __MKSMALLINT(Button1);
		goto commonButton;

	    case WM_MBUTTONDBLCLK:
		isDoubleClick = 1;
		butt = __MKSMALLINT(Button2);
		goto commonButton;

	    case WM_MBUTTONUP:
		isDown = 0;
		butt = __MKSMALLINT(Button2);
		goto commonButton;

	    case WM_MBUTTONDOWN:
		butt = __MKSMALLINT(Button2);
		goto commonButton;

	    case WM_RBUTTONDBLCLK:
		isDoubleClick = 1;
		butt = __MKSMALLINT(Button3);
		goto commonButton;

	    case WM_RBUTTONUP:
		isDown = 0;
		butt = __MKSMALLINT(Button3);
		goto commonButton;

	    case WM_RBUTTONDOWN:
		butt = __MKSMALLINT(Button3);
		goto commonButton;

	    commonButton:
		x = ev->ev_x;
		y = ev->ev_y;
		modifiers = ev->ev_modifiers;

		if (__INST(buttonTranslation) != nil) {
		    butt = __AT_(__INST(buttonTranslation), butt);
		}
		arg = butt;

		__INST(altDown) = (modifiers & AltMask) ? true : false;
		__INST(metaDown) = (modifiers & MetaMask) ? true : false;
		__INST(shiftDown) = (modifiers & ShiftMask) ? true : false;
		__INST(ctrlDown) = (modifiers & ControlMask) ? true : false;

		if (deltaDoubleClickX == -999) {
		    deltaDoubleClickX = GetSystemMetrics(SM_CXDOUBLECLK);
		    deltaDoubleClickY = GetSystemMetrics(SM_CYDOUBLECLK);
		}

		if (isDoubleClick) {
		    multiClickCount = 2;
		    ipS = &bmp;
		    symS = @symbol(buttonMultiPress:x:y:view:);
		    nextMultiClickTime = ev->ev_time + __intVal(__INST(multiClickTimeDelta));
		} else {
		    if (isDown) {
			if (multiClickCount
			 && (ev->ev_time < nextMultiClickTime)
			 && (butt == lastButton)
			 && (x >= (lastClickX - (deltaDoubleClickX / 2)))
			 && (x <= (lastClickX + (deltaDoubleClickX / 2)))
			 && (y >= (lastClickY - (deltaDoubleClickY / 2)))
			 && (y <= (lastClickY + (deltaDoubleClickY / 2)))
			) {
			    ipS = &bmp;
			    symS = @symbol(buttonMultiPress:x:y:view:);
			} else {
			    ipS = &bp;
			    symS = @symbol(buttonPress:x:y:view:);
			    multiClickCount = 0;
			}
			multiClickCount = multiClickCount + 1;
			nextMultiClickTime = ev->ev_time + __intVal(__INST(multiClickTimeDelta));
		    } else {
			ipS = &br;
			symS = @symbol(buttonRelease:x:y:view:);
		    }
		}

		if (isDown || isDoubleClick) {
		    lastClickX = x;
		    lastClickY = y;
		    lastButton = butt;
		}

		if (__debug_WM_BUTTONUP__ | __debug_WM_BUTTONDOWN__ | __debug_WM_ALL__) {
		    if (__isSymbol(arg)) {
			PRINTF(("buttonPress/buttonRelease: %s %d/%d\n",
				    __stringVal(arg), x, y));
		    } else {
			PRINTF(("buttonPress/buttonRelease: %d %d/%d\n",
				    __intVal(arg), x, y));
		    }
		}

		(*(*ipS).ilc_func)(self, symS, nil, ipS,
				   arg,
				   __MKSMALLINT(x),
				   __MKSMALLINT(y),
				   theView);
		break;

	    case __WM_MOUSEENTER:
		x = ev->ev_x;
		y = ev->ev_y;
		state = ev->ev_modifiers;

		if (__debug_WM_MOUSEENTER__ | __debug_WM_ALL__) {
		    PRINTF((">>> WM_MOUSEENTER: %x %d/%d state:%x\n", ev->ev_hWnd, x, y, state));
		}
#if 0
		if (GetWindow_unmapping(hWnd)) {
		    console_fprintf(stderr, "oops - WM_MOUSEENTER for unmapping\n");
		}
#endif
		(*pe.ilc_func)(self, @symbol(pointerEnter:x:y:view:),
				    nil, &pe,
				    __MKSMALLINT(state),
				    __MKSMALLINT(x),
				    __MKSMALLINT(y),
				    theView);
		break;

	    case __WM_MOUSELEAVE:
		state = ev->ev_modifiers;
		if (__debug_WM_MOUSELEAVE__ | __debug_WM_ALL__) {
		    PRINTF((">>> WM_MOUSELEAVE: %x state:%x\n", ev->ev_hWnd, state));
		}
#if 0
		if (GetWindow_unmapping(hWnd)) {
		    console_fprintf(stderr, "oops - WM_MOUSELEAVE for unmapping\n");
		}
#endif
		(*pl.ilc_func)(self, @symbol(pointerLeave:view:),
				    nil, &pl,
				    __MKSMALLINT(state),
				    theView);
		break;

	    case WM_MOUSEMOVE:
		x = ev->ev_x;
		y = ev->ev_y;
		state = ev->ev_modifiers;
		if (__debug_WM_MOUSEMOVE__ | __debug_WM_ALL__) {
		    PRINTF((">>> WM_MOUSEMOVE: %d/%d %x\n", x, y, state));
		}
		(*mot.ilc_func)(self, @symbol(buttonMotion:x:y:view:),
				    nil, &mot,
				    __MKSMALLINT(state),
				    __MKSMALLINT(x),
				    __MKSMALLINT(y),
				    theView);
		break;

#ifdef WM_MOUSEWHEEL
	    case WM_MOUSEWHEEL:
		x = ev->ev_x;
		y = ev->ev_y;
		state = ev->ev_modifiers;
		dir = ev->ev_wParam;
		DPRINTF((">>> WM_MOUSEWHEEL: %d %x\n", dir, state));
		{
		    OBJ tim;

		    __PROTECT__(theView);
		    tim = __MKUINT(ev->ev_time);
		    __UNPROTECT__(theView);
		    (*mwh.ilc_func)(self, @symbol(mouseWheelMotion:x:y:amount:deltaTime:view:),
				    nil, &mwh,
				    __MKSMALLINT(state),
				    __MKSMALLINT(x),
				    __MKSMALLINT(y),
				    __MKSMALLINT(dir),
				    tim,
				    theView);
		}
		break;
#endif

	    case WM_CHAR:
		DPRINTFIF((__debug_WM_CHAR__ | __debug_WM_ALL__)  , ("WM_CHAR %x %d/%d\n", ev->ev_keyCode, ev->ev_x, ev->ev_y));
		DPRINTF((">>> WM_CHAR: %d/%d\n", x, y));
		symS = @symbol(keyPress:x:y:view:);
		ipS = &skp;
		upDown = true;
		goto keyPressAndRelease;

	    case WM_HOTKEY:
		{
		(*hkp.ilc_func)(self, @symbol(hotkeyWithId:key:view:),
				    nil, &hkp,
				    __MKSMALLINT(ev->ev_wParam),
				    __MKSMALLINT(ev->ev_arg1),
				    theView);
		}
		break;

	    case WM_SYSKEYUP:
	    case WM_KEYUP:
		DPRINTFIF((__debug_WM_KEYUP__ | __debug_WM_ALL__)  , (">>> WM_KEYUP / SYSKEYUP: %x %d/%d\n", ev->ev_keyCode, ev->ev_x, ev->ev_y));
		symS = @symbol(keyRelease:x:y:view:);
		ipS = &skr;
		upDown = false;
		goto keyPressAndRelease;

	    case WM_SYSKEYDOWN:
	    case WM_KEYDOWN:
		DPRINTFIF((__debug_WM_KEYUP__ | __debug_WM_ALL__)  , (">>> WM_KEYDOWN / SYSKEYDOWN: %x %d/%d\n", ev->ev_keyCode, ev->ev_x, ev->ev_y));
		symS = @symbol(keyPress:x:y:view:);
		ipS = &skp;
		upDown = true;
		/* FALL INTO */

	    keyPressAndRelease: ;

		x = ev->ev_x;
		y = ev->ev_y;

#ifdef NOTDEF
		{
		    BYTE vKeyState[256];
		    char buff[5];

		    GetKeyboardState(vKeyState);
		    ToAscii(ev->ev_keyCode, ev->ev_scanCode, vKeyState, &buff; 0);
		}
#endif

		keyCode = ev->ev_keyCode;
		modifiers = ev->ev_modifiers;

		if (modifiers & TRANSLATED_KEY) {
#if 1
		    if (modifiers & ControlMask) {
			if (keyCode < 0x20) {
			    keyCode = keyCode + 'a' - 1;
			    if (modifiers & ShiftMask) {
				keyCode = keyCode - 'a' + 'A';
			    }
			}
		    } else if (modifiers & (MetaMask | AltMask)) {
			if (! (modifiers & ShiftMask)) {
			    if ((keyCode >= 'A') && (keyCode <= 'Z')) {
				keyCode = keyCode - 'A' + 'a';
			    }
			}
		    }
#endif
		    arg = __MKSMALLINT(keyCode & 0xFFFF);
		} else {
		    switch (keyCode) {
			case VK_F1:
			    arg = @symbol(F1);
			    break;
			case VK_F2:
			    arg = @symbol(F2);
			    break;
			case VK_F3:
			    arg = @symbol(F3);
			    break;
			case VK_F4:
			    arg = @symbol(F4);
			    break;
			case VK_F5:
			    arg = @symbol(F5);
			    break;
			case VK_F6:
			    arg = @symbol(F6);
			    break;
			case VK_F7:
			    arg = @symbol(F7);
			    break;
			case VK_F8:
			    arg = @symbol(F8);
			    break;
			case VK_F9:
			    arg = @symbol(F9);
			    break;
			case VK_F10:
			    arg = @symbol(F10);
			    break;
			case VK_F11:
			    arg = @symbol(F11);
			    break;
			case VK_F12:
			    arg = @symbol(F12);
			    break;
			case VK_PRIOR:
			    arg = @symbol(Prior);
			    break;
			case VK_NEXT:
			    arg = @symbol(Next);
			    break;
			case VK_END:
			    arg = @symbol(End);
			    break;
			case VK_HOME:
			    arg = @symbol(Home);
			    break;
			case VK_LEFT:
			    arg = @symbol(CursorLeft);
			    break;
			case VK_RIGHT:
			    arg = @symbol(CursorRight);
			    break;
			case VK_UP:
			    arg = @symbol(CursorUp);
			    break;
			case VK_DOWN:
			    arg = @symbol(CursorDown);
			    break;
			case VK_MENU:  /*alt key with w95 ???*/
			    arg = @symbol(Menu);
			    break;
			case VK_LMENU:
			    arg = @symbol(Menu_L);
			    break;
			case VK_RMENU:
			    arg = @symbol(Menu_R);
			    break;
			case VK_PAUSE:
			    arg = @symbol(Pause);
			    break;
			case VK_HELP:
			    arg = @symbol(Help);
			    break;
			case VK_EXECUTE:
			    arg = @symbol(Execute);
			    break;
			case VK_CANCEL:
			    arg = @symbol(Cancel);
			    break;
			case VK_SELECT:
			    arg = @symbol(Select);
			    break;
			case VK_PRINT:
			    arg = @symbol(Print);
			    break;
			case VK_SNAPSHOT:
			    arg = @symbol(Snapshot);
			    break;
			case VK_INSERT:
			    arg = @symbol(Insert);
			    break;
			case VK_DELETE:
			    arg = @symbol(Delete);
			    break;
			case VK_BACK:
			    arg = @symbol(BackSpace);
			    break;
			case VK_LWIN:
			    arg = @symbol(Win_L);
			    break;
			case VK_RWIN:
			    arg = @symbol(Win_R);
			    break;
			case VK_APPS:
			    arg = @symbol(Appl);
			    break;
			case VK_NUMPAD0:
			    arg = __MKCHARACTER((int)'0');
			    break;
			case VK_NUMPAD1:
			    arg = __MKCHARACTER((int)'1');
			    break;
			case VK_NUMPAD2:
			    arg = __MKCHARACTER((int)'2');
			    break;
			case VK_NUMPAD3:
			    arg = __MKCHARACTER((int)'3');
			    break;
			case VK_NUMPAD4:
			    arg = __MKCHARACTER((int)'4');
			    break;
			case VK_NUMPAD5:
			    arg = __MKCHARACTER((int)'5');
			    break;
			case VK_NUMPAD6:
			    arg = __MKCHARACTER((int)'6');
			    break;
			case VK_NUMPAD7:
			    arg = __MKCHARACTER((int)'7');
			    break;
			case VK_NUMPAD8:
			    arg = __MKCHARACTER((int)'8');
			    break;
			case VK_NUMPAD9:
			    arg = __MKCHARACTER((int)'9');
			    break;
			case VK_LSHIFT:
			    arg = @symbol(Shift_L);
			    break;
			case VK_RSHIFT:
			    arg = @symbol(Shift_R);
			    break;
			case VK_LCONTROL:
			    arg = @symbol(Ctrl_L);
			    break;
			case VK_RCONTROL:
			    arg = @symbol(Ctrl_R);
			    break;
			case VK_CONTROL:
			    arg = @symbol(Ctrl);
			    break;
			case VK_SHIFT:
			    arg = @symbol(Shift);
			    break;
			case VK_TAB:
			    arg = @symbol(Tab);
			    break;
			case VK_ESCAPE:
			    arg = @symbol(Escape);
			    break;
			case VK_NUMLOCK:
			    arg = @symbol(NumLock);
			    break;
			case VK_SCROLL:
			    arg = @symbol(ScrollLock);
			    break;
			case VK_RETURN:
			    arg = @symbol(Return);
			    break;

			default:
#if 0
			    nameBuffer[0] = 0;
			    GetKeyNameText(ev->ev_scanCode, nameBuffer, sizeof(nameBuffer));
			    if (__debug_WM_KEYUP__ | __debug_WM_KEYDOWN__ | __debug_WM_CHAR__ | __debug_WM_ALL__) {
				PRINTF(("char is <%d>\n", keyCode));
			    }
#endif
			    arg = __MKSMALLINT(keyCode & 0xFFFF);
			    break;
		    }
		}
		__INST(altDown) = (modifiers & AltMask) ? true : false;
		__INST(metaDown) = (modifiers & MetaMask) ? true : false;
		__INST(shiftDown) = (modifiers & ShiftMask) ? true : false;
		__INST(ctrlDown) = (modifiers & ControlMask) ? true : false;

		if (__debug_WM_CHAR__ | __debug_WM_KEYUP__ | __debug_WM_KEYDOWN__ | __debug_WM_ALL__) {
		    PRINTF(("%s: code=%x mod=%x ", __stringVal(symS), keyCode, modifiers));
		    PRINTF((" alt=%d meta=%d ", __INST(altDown) == true , __INST(metaDown) == true));
		    PRINTF((" sh=%d ctrl=%d", __INST(shiftDown) == true , __INST(ctrlDown) == true));
		    PRINTF((" arg=%x\n", arg));
		}

		(*(*ipS).ilc_func)(self, symS, nil, ipS,
				   arg,
				   __MKSMALLINT(x),
				   __MKSMALLINT(y),
				   theView);
		break;

	   case WM_SYSCOLORCHANGE:
		DPRINTF((">>> WM_SYSCOLORCHANGE\n"));
		(*sysClrChg.ilc_func)(self, @symbol(systemColorChange:), nil, &sysClrChg, theView);
		break;

	   case WM_FONTCHANGE:
		DPRINTF((">>> WM_FONTCHANGE\n"));
		(*fontChg.ilc_func)(self, @symbol(fontChange), nil, &fontChg);
		break;

	   case WM_WININICHANGE:
		DPRINTF((">>> WM_WININICHANGE\n"));
		(*settingChg.ilc_func)(self, @symbol(settingsChange), nil, &settingChg);
		break;

	   case WM_DISPLAYCHANGE:
		DPRINTF((">>> WM_DISPLAYCHANGE\n"));
		(*fontChg.ilc_func)(self, @symbol(displayChange), nil, &fontChg);
		break;

	   case WM_QUERYENDSESSION:
		DPRINTF((">>> WM_QUERYENDSESSION\n"));
		(*qEndSess.ilc_func)(self, @symbol(queryEndSession), nil, &qEndSess);
		break;

#ifdef LATER
	   case WM_POWER:
		DPRINTF((">>> WM_POWER\n"));
		(*power.ilc_func)(self, @symbol(powerDown), nil, &power);
	       break;
#endif
	    /* native widget actions */
	    case WM_COMMAND:
		DPRINTF((">>> WM_COMMAND\n"));
		(*command.ilc_func)(self, @symbol(nativeWidgetCommand:view:), nil, &command,
				__MKSMALLINT(ev->ev_wParam), theView);
	       break;

	    /* tray action */
	    case WM_TRAY_MESSAGE:
		DPRINTF((">>> WM_TRAY_MESSAGE\n"));
		(*trayMessage.ilc_func)(self, @symbol(trayAction:view:), nil, &trayMessage,
				__MKSMALLINT(ev->ev_arg1), theView);
		break;

	    /* message from another process */
	    case WM_COPYDATA:
		DPRINTF((">>> WM_COPYDATA"));
		{
		    OBJ eventData;
		    void *data = (void *)(ev->ev_arg1);
		    DPRINTFIF((__debug_WM_COPYDATA__) , (">>> WM_COPYDATA %s (%d)\n", data, ev->ev_arg2));

		    if (data) {
			eventData = __MKBYTEARRAY(data, (int)ev->ev_arg2);
			free(data);     // see winEventProcessing()
		    } else {
			eventData = nil;
		    }
		    (*copyData.ilc_func)(self, @symbol(copyDataEvent:eventData:view:), nil, &copyData,
				__MKSMALLINT(ev->ev_wParam), eventData, theView);
		}
		break;

#ifdef LATER
	    case WM_QUIT:
		DPRINTF((">>> WM_QUIT_MESSAGE\n"));
		(*quit.ilc_func)(self, @symbol(quitCommand:), nil, &quit);
		break;
#endif
	    case WM_HSCROLL:
	    case WM_VSCROLL:
		{
		    int scrollCode = 0;
		    OBJ scrollCodeOrScrollCodeSymbol = nil, positionOrNil = nil;
		    int pos = 0;

		    scrollCode = LOWORD(ev->ev_wParam);
		    scrollCodeOrScrollCodeSymbol = __MKSMALLINT(scrollCode);
		    positionOrNil = nil;
		    switch (scrollCode) {
			case SB_BOTTOM:
			    scrollCodeOrScrollCodeSymbol = @symbol(SB_BOTTOM);
			    break;
			case SB_TOP:
			    scrollCodeOrScrollCodeSymbol = @symbol(SB_TOP);
			    break;
			case SB_ENDSCROLL:
			    scrollCodeOrScrollCodeSymbol = @symbol(SB_ENDSCROLL);
			    break;
			case SB_LINEDOWN:
			    if (ev->ev_message == WM_HSCROLL) {
				scrollCodeOrScrollCodeSymbol = @symbol(SB_LINERIGHT);
			    } else {
				scrollCodeOrScrollCodeSymbol = @symbol(SB_LINEDOWN);
			    }
			    break;
			case SB_LINEUP:
			    if (ev->ev_message == WM_HSCROLL) {
				scrollCodeOrScrollCodeSymbol = @symbol(SB_LINELEFT);
			    } else {
				scrollCodeOrScrollCodeSymbol = @symbol(SB_LINEUP);
			    }
			    break;
			case SB_PAGEDOWN:
			    if (ev->ev_message == WM_HSCROLL) {
				scrollCodeOrScrollCodeSymbol = @symbol(SB_PAGERIGHT);
			    } else {
				scrollCodeOrScrollCodeSymbol = @symbol(SB_PAGEDOWN);
			    }
			    break;
			case SB_PAGEUP:
			    if (ev->ev_message == WM_HSCROLL) {
				scrollCodeOrScrollCodeSymbol = @symbol(SB_PAGELEFT);
			    } else {
				scrollCodeOrScrollCodeSymbol = @symbol(SB_PAGEUP);
			    }
			    break;
			case SB_THUMBPOSITION:
			    if (ev->ev_message == WM_HSCROLL) {
				scrollCodeOrScrollCodeSymbol = @symbol(SB_THUMBPOSITIONHORIZONTAL);
			    } else {
				scrollCodeOrScrollCodeSymbol = @symbol(SB_THUMBPOSITIONVERTICAL);
			    }
			    pos = HIWORD(ev->ev_wParam);
			    positionOrNil = __MKSMALLINT(pos);
			    break;
			case SB_THUMBTRACK:
			    if (ev->ev_message == WM_HSCROLL) {
				scrollCodeOrScrollCodeSymbol = @symbol(SB_THUMBTRACKHORIZONTAL);
			    } else {
				scrollCodeOrScrollCodeSymbol = @symbol(SB_THUMBTRACKVERTICAL);
			    }
			    pos = HIWORD(ev->ev_wParam);
			    positionOrNil = __MKSMALLINT(pos);
			    break;
			default:
			    DPRINTF((">>> WM_SCROLL: unhandled scrollCode:%d %d\n", scrollCode));
			    break;
		    }
		    NDPRINTF((">>> WM_SCROLL: %d %d\n", scrollCode, pos));

		    (*win32NativeScroll.ilc_func)(self, @symbol(win32NativeScroll:position:view:),
					nil, &win32NativeScroll,
					scrollCodeOrScrollCodeSymbol,
					positionOrNil,
					theView);
		}
		break;

	    case WM_DRAWITEM:
		{
		    NDPRINTF((">>> WM_DRAWITEM: wParam: %x\n", ev->ev_wParam));
		    (*win32DrawItem.ilc_func)(self, @symbol(win32DrawItem:view:),
					nil, &win32DrawItem,
					__MKSMALLINT(ev->ev_wParam),
					theView);
		}
		break;

	    default:
		UNHANDLED_EVENT_PRINTF(("WinWorkstat [info]: >>> unhandled event: %x\n", ev->ev_message));
		break;
    }
%}.
    ^ true
!

dispatchPendingEvents
    "central event handling method for modal operation.
     (i.e. this is now only used in the modal debugger)
     Dispatch any pending events; return when no more are pending.
     This code is somewhat special, since X has a concept of graphic
     expose events (which are sent after a bitblt). After such a bitblt,
     we only handle exposes until the graphicsExpose arrives.
     Other systems may not need such a kludge"

    [self eventPendingWithSync:false] whileTrue:[
	(self getEventFor:nil withMask:nil) ifTrue:[
	    AbortOperationRequest handle:[:ex |
		ex return
	    ] do:[
		self dispatchLastEvent.
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

%{  /* NOCONTEXT */
   DPRINTF(("WinWorkstation: disposeEventsWithMask:for: not yet implemented.\n"));
   RETURN ( self );
%}
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
    RETURN (__MKSMALLINT(m));
%}
!

eventPending
    "return true, if any event is pending.
     This looks for both the internal queue and the display connection."

    ^ self eventPendingWithSync:false
!

eventPending:anEventSymbol for:aWindowIdOrNil
    "return true, if a specific event is pending"

    ^ self eventsPending:(self eventMaskFor:anEventSymbol) for:aWindowIdOrNil withSync:false
!

eventPendingWithSync:doSync
    "return true, if any event is pending.
     The doSync argument is ignored here - in windows, all drawing is synchronous."

    doSync notNil ifTrue:[self flush].

%{
    if (hasEventQueued()) {
	RETURN (true);
    }
%}.
    ^ false
!

eventQueued
    "return true, if any event is queued"

    ^ self eventQueuedAlready

    "Created: 12.12.1995 / 21:43:00 / stefan"
!

eventQueuedAlready
    "return true, if any event is queued internally.
     (i.e. in X's internal event queue, which is both filled by explicit
      nextEvent calls AND whenever drawing is done and events are pending on
      the display connection)."

%{  /* NOCONTEXT */

    DDDPRINTF(("peek q - "));
    if (hasEventQueued()) {
	DDDPRINTF(("true\n"));
	RETURN (true);
    }
    DDDPRINTF(("false\n"));
%}.
    ^ false
!

eventsPending:anEventMask for:aWindowIdOrNil withSync:doSync
    "return true, if any of the masked events is pending.
     The doSync argument is ignored here - in windows, all drawing is synchronous."

%{  /* NOCONTEXT */

    DDDPRINTF(("eventsPending mask %x - not implemented\n", __intVal(anEventMask)));
%}.
    ^ false
!

exposeEventPendingFor:aWindowIdOrNil withSync:doSync
    "return true, if any expose event is pending for a specific view,
     or any view (if the arg is nil).
     This is an X specific interface - not used on windows (scrolling is synchronous)"

    ^ false
!

getEventFor:aViewIdOrNil withMask:eventMask
    "read next event - put into local eventBuffer.
     If aViewIdOrNil is nil, events for any view are fetched;
     otherwise only events for that specific view will be fetched.
     Returns true, if there was an event, false otherwise."

%{  /* NOCONTEXT */
    HWND win, wWanted;
    int evMask;
    OBJ eB;
    struct queuedEvent *ev;
    struct queuedEvent *qev;

    eB = __INST(eventBuffer);
    if (! __isByteArray(eB)) {
	console_fprintf(stderr, "WinWorkstation [error]: no eventBuffer\n");
	/* RETURN (false); */
    } else {
	ev = (struct queuedEvent *)(__ByteArrayInstPtr(eB)->ba_element);
	ev->ev_message = 0;

	if (__isSmallInteger(eventMask)) {
	    evMask = __intVal(eventMask);
	} else {
	    evMask = ~0;
	}
	if (__isExternalAddress(aViewIdOrNil)) {
	    wWanted = _HWNDVal(aViewIdOrNil);
	} else{
	    wWanted = 0;
	}

	do { /* only to allow continue */
	    if (deqEvent(ev, wWanted, evMask)) {
#ifdef COMPRESS_WINDOWPOSCHANGED
		if ((ev->ev_hWnd == lastPos_win)
		 && (ev->ev_message == WM_WINDOWPOSCHANGED)
		 && ((ev->ev_x != lastPos_x)
		     || (ev->ev_y != lastPos_y)
		     || (ev->ev_w != lastPos_w)
		     || (ev->ev_h != lastPos_h))) {
		    /*
		     * ignore intermediate resize events
		     * (that event is an intermediate one, because the peek-values
		     *  have already been updated for another event)
		     */
		    EVENT_PRINTF(("ignored WINDOWPOSCHANGED (%d:%d / %d:%d / %d:%d / %d:%d\n",
				  ev->ev_x, lastPos_x,
				  ev->ev_y, lastPos_y,
				  ev->ev_w, lastPos_w,
				  ev->ev_h, lastPos_h ));
		    continue;
		}
#endif
		RETURN ( true );
	    }
	} while (0);
    }
%}.
    ^ false
!

handleAllEvents
    "from now on, handle any kind of event.
     Always with win32."

!

handleExposeOnlyFor:aView
    "from now on, handle expose events only.
     Never with win32."

!

registerHotKeyForWindow:aDrawableId withId:anId modifiers:aModifier virtualKeyCode:aVirtualKeyCode
    "Defines a system-wide hot key."

%{  /* NOCONTEXT */
    static registerHotKeyInfo rhki;
    HWND hWnd = NULL;

    if (__isExternalAddress(aDrawableId)) {
	hWnd = _HWNDVal(aDrawableId);

	if (! hWnd) {
	    RETURN (false);
	}
    } else {
	RETURN (false);
    }

    rhki.hwnd       = hWnd;
    rhki.hotKeyId   = __intVal(anId);
    rhki.modifier   = __intVal(aModifier);
    rhki.virtualKey = __intVal(aVirtualKeyCode);

    if (PostThreadMessage(_dispatchThreadId, WM_THREAD_REGISTERHOTKEY, 0, (INT)(&rhki)) == FALSE) {
	console_fprintf(stderr, "WinWorkstation [error]: oops - PostThreadMessage(%x) failed in registerHotKeyForWindow: err=%d\n",
					_dispatchThreadId, GetLastError() );
	RETURN (false);
    }
%}.
    ^ true
!

setEventMask:aMask in:aWindowId
    "tell the display, that we are only interested in events from aMask, which
     is the bitwise-or of the eventMask bits (see 'eventMaskFor:')"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aWindowId)
     && __isSmallInteger(aMask)) {
	HWND hWnd = _HWNDVal(aWindowId);
	int mask = __intVal(aMask);
	localWindowInfo *lI;

	lI = GETLOCALWINDOWINFOPTR(hWnd);
	if (lI) {
#ifdef DEBUGMASK
	    PRINTF(("new eventMask %x\n",mask));
	    printMask(mask);
#endif
	    lI->eventMask = mask;
	    RETURN ( self );
	}
    }
%}.
    self primitiveFailed
!

unregisterHotKeyForWindow:aDrawableId withId:anId
    "Defines a system-wide hot key."

%{  /* NOCONTEXT */
    static registerHotKeyInfo rhki;
    HWND hWnd = NULL;

    if (__isExternalAddress(aDrawableId)) {
	hWnd = _HWNDVal(aDrawableId);

	if (! hWnd) {
	    RETURN (false);
	}
    } else {
	RETURN (false);
    }

    rhki.hwnd       = hWnd;
    rhki.hotKeyId   = __intVal(anId);
    rhki.modifier   = 0;
    rhki.virtualKey = 0;

    if (PostThreadMessage(_dispatchThreadId, WM_THREAD_UNREGISTERHOTKEY, 0, (INT)(&rhki)) == FALSE) {
	console_fprintf(stderr, "WinWorkstation [error]: oops - PostThreadMessage(%x) failed in unregisterHotKeyForWindow: err=%d\n",
					_dispatchThreadId, GetLastError() );
	RETURN (false);
    }
%}.
    ^ true
! !

!WinWorkstation methodsFor:'event sending'!

sendKeyOrButtonEvent:typeSymbol x:xPos y:yPos keyOrButton:keySymCodeOrButtonNr state:stateMask toViewId:targetId
    "send a keyPress/Release or buttonPress/Release event to some (possibly alien) view.
     TypeSymbol must be one of: #keyPress, #keyRelease, #buttonPress , #buttonRelease.
     For buttonEvents, the keySymCodeOrButtonNr must be the buttons number (1, 2 ...);
     for key events, it can be either a symbol (as listen in X's keySyms)
     or a numeric keysym code. If state is nil, the modifier bits (shift & control)
     are computed from the keyboardMap - if non-nil, these are passed as modifierbits.
     The non-nil case is the lowlevel entry, where state must include any shift/ctrl information
     (not very user friendly)"

    super sendKeyOrButtonEvent:typeSymbol x:xPos y:yPos keyOrButton:keySymCodeOrButtonNr state:stateMask toViewId:targetId

    "Modified: / 06-05-2017 / 11:19:03 / jv"
! !

!WinWorkstation methodsFor:'font stuff'!

createFontFor:aFontName
    "a basic method for font allocation; this method allows
     any font to be aquired (even those not conforming to
     standard naming conventions, such as cursor, fixed or k14)"

%{
    HGDIOBJ hFont;
    char *fn;

    if (__isStringLike(aFontName)) {
	fn = __stringVal(aFontName);
	if ((strcmp(fn, "fixed") == 0) || (strcmp(fn, "ANSI_FIXED_FONT") == 0)) {
	    hFont = GetStockObject(ANSI_FIXED_FONT);
	} else if ((strcmp(fn, "variable") == 0) || (strcmp(fn, "ANSI_VAR_FONT") == 0)) {
	    hFont = GetStockObject(ANSI_VAR_FONT);
	} else if ((strcmp(fn, "system") == 0) || (strcmp(fn, "SYSTEM_FONT") == 0)) {
	    hFont = GetStockObject(SYSTEM_FONT);
	} else if ((strcmp(fn, "systemFixed") == 0) || (strcmp(fn, "SYSTEM_FIXED_FONT") == 0)) {
	    hFont = GetStockObject(SYSTEM_FIXED_FONT);
	} else if ((strcmp(fn, "deviceDefault") == 0) || (strcmp(fn, "DEVICE_DEFAULT_FONT") == 0)) {
	    hFont = GetStockObject(DEVICE_DEFAULT_FONT);
	} else {
	    hFont = GetStockObject(ANSI_FIXED_FONT);
	}
	if (hFont) {
	    DPRINTF(("createFontFor:%s -> %x\n", fn, hFont));
	    RETURN ( __MKOBJ(hFont) );
	}
    }
%}.
    ^ nil
!

encodingOf:fontId
    "return the encoding of the font"

    ^ (self fontMetricsOf:fontId) encoding
!

fontDescriptionFromLogicalFontInfoArray:anInfoArray
    |fntDescr family face style logicalSize pointSize encoding|

    family := anInfoArray at:16.
    face   := anInfoArray at:6.
    style  := anInfoArray at:15.
    logicalSize   := anInfoArray at:1.
    encoding := anInfoArray at:17.

    logicalSize := logicalSize abs.
    "/ convert from device to point size
    pointSize := (logicalSize / self getLogicalPixelSizeY * 72.0).

    fntDescr := FontDescription
		    family:family
		    face:face
		    style:style
		    size:pointSize
		    sizeUnit:#pt
		    encoding:encoding.
    fntDescr setPixelSize:logicalSize.
    ^ fntDescr.

    "Modified: / 09-11-2010 / 13:00:18 / cg"
!

fontMetricsOf:fontId
    "return a fonts metrics info object"

    |rawData info|

    rawData := Array new:15.
    (self primFontMetricsOf:fontId intoArray:rawData) isNil ifTrue:[
	self primitiveFailed.
	^ self
    ].

    info := DeviceWorkstation::DeviceFontMetrics new.
    info
      ascent:(rawData at:1)
      descent:(rawData at:2)
      maxAscent:(rawData at:3)
      maxDescent:(rawData at:4)
      minWidth:(rawData at:5)
      maxWidth:(rawData at:6)
      avgWidth:(rawData at:7)
      minCode:(rawData at:8)
      maxCode:16rFFFF "(rawData at:9)"
      direction:nil
      encoding:(rawData at:11)
      overHang:(rawData at:12).
    ^ info
!

fontsInFamily:aFamilyName face:aFaceName filtering:filter
    "return a set of all available fonts in aFamily/aFace on this display.
     On WinWorkStations there is currently Face
     But only these matching filter (if nonNil)."

    |allFonts fonts|

    allFonts := self listOfAvailableFonts.
    allFonts isNil ifTrue:[^ nil].

    fonts := Set new.
    allFonts do:[:fntDescr |
	(aFamilyName sameAs:(fntDescr family)) ifTrue:[
	    (filter isNil or:[filter value:fntDescr]) ifTrue:[
		fonts add:fntDescr
	    ]
	]
    ].
    ^ fonts
!

getAvailableFontsMatching:pattern
    "return an Array filled with font names matching aPattern"
    self shouldImplement.
    ^ nil
!

getDefaultFontWithEncoding:encoding
    "return a default font id - used when class Font cannot
     find anything usable"

     ^ self createFontFor:'fixed'
!

getFontWithFamily:familyString face:faceString
	    style:styleArgString size:sizeArg sizeUnit:sizeUnitArg
	    encoding:encoding

    "try to get the specified font, if not available, try the next smaller
     font."

    |styleString theName theId xlatedStyle id spacing pxSize ptSize encodingSym|

    styleString := styleArgString.
    encoding isEmptyOrNil ifTrue:[
	encodingSym := #'ms-default' "/ encoding.
    ] ifFalse:[
	encodingSym := encoding asLowercase asSymbol.
    ].

    "special: if face is nil, allow access to X-fonts"
    faceString isNil ifTrue:[
	sizeArg notNil ifTrue:[
	    theName := familyString , '-' , sizeArg printString
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
    styleString notNil ifTrue:[
	((styleString endsWith:'-narrow')
	 or:[styleString endsWith:'-semicondensed']) ifTrue:[
	    |i|
	    i := styleString lastIndexOf:$-.
	    spacing := styleString copyFrom:(i+1).
	    styleString := styleString copyTo:(i-1).
	] ifFalse:[
	    spacing := #normal.
	].
    ].

    xlatedStyle := styleString.
    xlatedStyle notNil ifTrue:[
	xlatedStyle := xlatedStyle first asString
    ].

    pxSize := sizeUnitArg == #px ifTrue:[sizeArg] ifFalse:[nil].
    ptSize := sizeUnitArg == #pt ifTrue:[sizeArg] ifFalse:[nil].

    id := self
	    getFontWithFoundry:#*
	    family:familyString asLowercase
	    weight:faceString
	    slant:styleString "/ xlatedStyle
	    spacing:spacing
	    pixelSize:pxSize
	    size:ptSize
	    registry:#*
	    encoding:encodingSym.

    id isNil ifTrue:[
	id := self
		getFontWithFoundry:#*
		family:familyString asLowercase
		weight:faceString asLowercase
		slant:styleString asLowercase
		spacing:spacing
		pixelSize:pxSize
		size:ptSize
		registry:#*
		encoding:encodingSym.
    ].
    ^ id

    "Modified: / 04-07-1996 / 11:38:47 / stefan"
    "Modified: / 04-08-2010 / 18:39:02 / cg"
!

getFontWithFoundry:foundry family:family weight:weight
	      slant:slant spacing:spc pixelSize:pixelSizeOrNil size:pointSize
	      registry:registry encoding:encodingArg

    "get the specified font, if not available, return nil.
     For now, this is a poor (incomplete) emulation of the X code ...
     Individual attributes can be left empty (i.e. '') or nil to match any.

     foundry:   'adobe', 'misc', 'dec', 'schumacher' ... usually '*'
     family:    'helvetica' 'courier' 'times' ...
     weight:    'bold' 'medium' 'demi' ...
     slant:     'r(oman)' 'i(talic)' 'o(blique)'
     spacing:   'narrow' 'normal' semicondensed' ... usually '*'
     pixelSize: 16,18 ... size in pixels; usually left nil
     size:      size in point (1/72th of an inch). Overwritten by pixelSize if that is not nil
     registry:  iso8859, sgi ... '*'
     encoding:  vendor specific encoding (usually '*')
    "

    "
     Windows-NT/95 allows the creation of a font with the following parameters

	nHeight
	nWidth
	nEscapement
	nOrientation
	fnWeight        FW_DONTCARE, FW_NORMAL, FW_MEDIUM, FW_BOLD, ...
	fdwItalic       TRUE or FALSE
	fdwUnderline    TRUE or FALSE
	fdwStrikeOut    TRUE or FALSE
	fdwCharSet      ANSI_CHARSET, UNICODE_, SYMBOL_, SHIFTJIS_,...
	fdwOutputPrecision      DEFAULT, STRING, CHAR, ...
	fdwClipPrecision        DEFAULT, CHAR, STROKE, MASK, ...
	fdwQuality      DEFAULT, DRAFT, or PROOF.
	fdwPitchAndFamily
		DEFAULT, FIXED or VARIABLE pitch
		DECORATIVE, DONTCASE, MODERN, ROMAN, SCRIPT, or SWISS.
	lpszFace
		Typeface Name

      These two above descriptions will be matched as follows:

	foundry   - ignored
	family    - mapped to type face name.
	weight    - mapped to fnWeight
	slant     - used for style
	spacing   - NOT USED INITIALLY
	pixelSize - NOT USED INITIALLY
	size      - mapped to nHeight
	registry  - NOT USED INITIALLY
	encoding  - mapped to fdwCharSet
     "

    |encoding logSize heightIsCellHeight|

    encoding := encodingArg asSymbol.

    pixelSizeOrNil notNil ifTrue:[
	logSize := pixelSizeOrNil.
	heightIsCellHeight := false.
    ] ifFalse:[
	logSize := (pointSize * (self getLogicalPixelSizeY) / 72.0) rounded.
	heightIsCellHeight := false.
    ].
%{
    HGDIOBJ hFont;
    int nHeight, nWidth, nEscapement, nOrientation;
    char* work;
    char* work2;
    DWORD fnWeight;
    DWORD fdwItalic;
    DWORD fdwUnderline;
    DWORD fdwStrikeOut;
    DWORD fdwCharSet;
    DWORD fdwOutputPrecision;
    DWORD fdwClipPrecision;
    DWORD fdwQuality;
    DWORD fdwPitchAndFamily;
    static char faceName[256];

/* INITIALIZE */
    strcpy( faceName, "NULL" );
    nHeight   = 0;
    nWidth   = 0;
    nEscapement = 0;
    nOrientation = 0;
    fnWeight = FW_NORMAL;
    fdwItalic = FALSE;
    fdwUnderline = FALSE;
    fdwStrikeOut = FALSE;
    fdwOutputPrecision = OUT_DEFAULT_PRECIS;
    fdwClipPrecision   = CLIP_DEFAULT_PRECIS;
    fdwQuality         = DEFAULT_QUALITY;
    fdwPitchAndFamily  = FF_DONTCARE;

    fdwCharSet   = ANSI_CHARSET;
    if ((encoding == @symbol('ms-ansi'))) {
	fdwCharSet   = ANSI_CHARSET;
    } else if (encoding == @symbol('ms-default')
	       || encoding == @symbol(*)) {
	fdwCharSet   = DEFAULT_CHARSET;
    } else if ((encoding == @symbol('ms-symbol'))
	    || (encoding == @symbol('misc-fontspecific'))) {
	fdwCharSet   = SYMBOL_CHARSET;
    } else if ((encoding == @symbol('ms-shiftjis'))
	    || (encoding == @symbol('jisx0208.1983-0'))){
	fdwCharSet   = SHIFTJIS_CHARSET;
    } else if ((encoding == @symbol('ms-gb2312'))
	    || (encoding == @symbol('gb2312.1980-0'))) {
	fdwCharSet   = GB2312_CHARSET;
    } else if ((encoding == @symbol('ms-hangeul'))
	    || (encoding == @symbol('ksc5601.1987-0'))) {
	fdwCharSet   = HANGEUL_CHARSET;
    } else if ((encoding == @symbol('ms-chinesebig5'))
	    || (encoding == @symbol('big5'))) {
	fdwCharSet   = CHINESEBIG5_CHARSET;
    } else if (encoding == @symbol('ms-oem')) {
	fdwCharSet   = OEM_CHARSET;
    } else if (encoding == @symbol('ms-johab')) {
	fdwCharSet   = JOHAB_CHARSET;
    } else if ((encoding == @symbol('ms-hebrew'))
	    || (encoding == @symbol('ms-cp1255'))) {
	fdwCharSet   = HEBREW_CHARSET;
    } else if ((encoding == @symbol('ms-arabic'))
	    || (encoding == @symbol('ms-cp1256'))) {
	fdwCharSet   = ARABIC_CHARSET;
    } else if ((encoding == @symbol('ms-greek'))
	    || (encoding == @symbol('ms-cp1253'))) {
	fdwCharSet   = GREEK_CHARSET;
    } else if ((encoding == @symbol('ms-turkish'))
	    || (encoding == @symbol('ms-cp1254'))) {
	fdwCharSet   = TURKISH_CHARSET;
    } else if ((encoding == @symbol('ms-russian'))
	    || (encoding == @symbol('ms-cp1251'))) {
	fdwCharSet   = RUSSIAN_CHARSET;
    } else if ((encoding == @symbol('ms-easteurope'))
	    || (encoding == @symbol('ms-cp1250'))) {
	fdwCharSet   = EASTEUROPE_CHARSET;
    } else if ((encoding == @symbol('ms-baltic'))
	    || (encoding == @symbol('ms-cp1257'))) {
	fdwCharSet   = BALTIC_CHARSET;
    } else if ((encoding == @symbol('ms-vietnamese'))) {
	fdwCharSet   = VIETNAMESE_CHARSET;
    } else if ((encoding == @symbol('ms-thai'))) {
	fdwCharSet   = THAI_CHARSET;
    } else if ((encoding == @symbol('ms-mac'))) {
	fdwCharSet   = MAC_CHARSET;
#ifdef UNICODE_CHARSET
    } else if ((encoding == @symbol('ms-unicode'))) {
	fdwCharSet   = UNICODE_CHARSET;
#endif
    }

    if ( __isStringLike( family ) ) {
	work = __stringVal( family );
	if (strcmp( work, "nil" ) != 0 ) {
	    strncpy( faceName, work, sizeof(faceName)-1 );
	}
    }

    /* Q: should we allow those ? (they make ST/X programs less portable to X */
    if( __isStringLike( weight ) ) {
	work = __stringVal( weight );
	if (strcmp( work, "bold" ) == 0 ) {
	    fnWeight = FW_BOLD;
	} else if (strcmp( work, "medium" ) == 0 ) {
	    fnWeight = FW_MEDIUM;
	} else if (strcmp( work, "normal" ) == 0 ) {
	    fnWeight = FW_NORMAL;
	} else if (strcmp( work, "light" ) == 0 ) {
	    fnWeight = FW_LIGHT;
	} else if (strcmp( work, "demi" ) == 0 ) {
	    fnWeight = FW_LIGHT;
	} else if (strcmp( work, "heavy" ) == 0 ) {
	    fnWeight = FW_HEAVY;
	} else if (strcmp( work, "extraBold" ) == 0 ) {
	    fnWeight = FW_EXTRABOLD;
	} else if (strcmp( work, "semiBold" ) == 0 ) {
	    fnWeight = FW_SEMIBOLD;
	} else if (strcmp( work, "thin" ) == 0 ) {
	    fnWeight = FW_THIN;
	} else if (strcmp( work, "extraLight" ) == 0 ) {
	    fnWeight = FW_EXTRALIGHT;
	}
    } else if (__isSmallInteger(weight)) {
	fnWeight = __intVal(weight);
    }

    if(__isSmallInteger( logSize )) {
	nHeight = __intVal( logSize );
    }

    if (__isStringLike(slant)) {
	work2 = __stringVal( slant );
	work  = __stringVal( slant );

	if (strncmp(work2, "italic", 6) == 0)  {
	    fdwItalic = TRUE;
	    if ( work2[6] == '-' )
		strncpy( work, &work2[7], ( strlen( work2) - 7) );
	} else {
	    if (strncmp(work2, "oblique", 7) == 0)  {
		fdwItalic = TRUE;
		if ( work2[7] == '-' )
		    strncpy( work, &work2[8], ( strlen( work2) - 8) );
	    }
	}
	if (strncmp( work, "underline", 9 ) == 0 ) {
	    fdwUnderline = TRUE;
	    if( work[10] == '-' )
		strncpy( work2, &work[11], ( strlen( work ) - 10 ) );
	}
	if (strncmp( work2, "strikeOut", 9 ) == 0 ) {
	    fdwStrikeOut = TRUE;
	}
    }

    DPRINTF(("CreateFont face:%s h=%d w=%d wght=%d\n",
		faceName, nHeight, nWidth, fnWeight));

    hFont = CreateFont(
			(
			    (heightIsCellHeight == true)  ?
				nHeight : -nHeight            /* positive:cell height; negative:character height */
			),
			nWidth,
			nEscapement,
			nOrientation,
			fnWeight,
			fdwItalic,
			fdwUnderline,
			fdwStrikeOut,
			fdwCharSet,
			fdwOutputPrecision,
			fdwClipPrecision,
			fdwQuality,
			fdwPitchAndFamily,
			faceName );

    if (hFont != NULL) {
	DPRINTF(("createFont: %x\n", hFont));
#ifdef COUNT_RESOURCES
	__cnt_font++;
	RES1PRINTF(("CreateFont %d\n", __cnt_font));
#endif
	RETURN ( __MKOBJ(hFont) );
    }

    DPRINTF(("***** ERROR createFontWithFoundry failed ERROR *****\n" ));
%}.
    ^ nil

    "
     Display getFontWithFoundry:'*'
			 family:'courier'
			 weight:'medium'
			  slant:'r'
			spacing:nil
		      pixelSize:nil
			   size:13
		       registry:'iso8859'
		       encoding:#*
    "

    "new NT Version: 20.2.1997 / 22:33:29 / dq"
!

getLogicalPixelSizeY
%{
    RETURN( __MKSMALLINT(__logPixelSY) );
%}
!

listOfAvailableFonts
    "return a list with all available fonts on this display.
     Since this takes a long time, keep the result of the query for the
     next time. The elements of the returned collection are instances of
     FontDescription."

    |list typeFaceList|

    listOfFonts notNil ifTrue:[^ listOfFonts].

    list := OrderedCollection new.
    typeFaceList := OrderedCollection new.

    [
      self primEnumFontTypesInto:typeFaceList.

      "/Transcript showCR:typeFaceList.

      typeFaceList do:[:typeFace |
	  self primEnumFontsIn:typeFace into:list.
      ].
    ] valueUninterruptably.

    "/ Transcript showCR:list.
    listOfFonts := OrderedCollection new.
    list do:[:anInfoArray |
	| fntDescr italicFontDescr |

	fntDescr := self fontDescriptionFromLogicalFontInfoArray:anInfoArray.
	listOfFonts add:fntDescr.

	"/ manually generate italic version (any font can be made italic here)
	(fntDescr style startsWith:'roman') ifTrue:[
	    italicFontDescr := FontDescription
			    family:fntDescr family
			    face:fntDescr face
			    style:('italic' , (fntDescr style copyFrom:'roman' size+1))
			    size:fntDescr size
			    encoding:fntDescr encoding.
	    listOfFonts add:italicFontDescr.
	].
    ].

    ^ listOfFonts

    "
     Display listOfAvailableFonts.
     Display getAvailableFontsMatching:'*'.
    "

    "Modified: 27.9.1995 / 10:54:47 / stefan"
    "Modified: 17.4.1996 / 15:27:57 / cg"
!

pixelSizesInFamily:aFamilyName face:aFaceName style:aStyleName filtering:filterBlock
    "return a set of all available font pixel sizes in aFamily/aFace/aStyle on this display.
     Redefined to handle the special case of 0-size (which stands for any)"

    |sizes|

    sizes := super pixelSizesInFamily:aFamilyName face:aFaceName style:aStyleName filtering:filterBlock.
    (sizes notNil and:[sizes includes:0]) ifTrue:[
	"special: size 0 means:
	 there are scaled versions in all sizes available"

	^ #(6 8 10 12 13 14 15 16 18 20 22 24 28 32 48 64)
    ].
    ^ sizes

    "
     Display pixelSizesInFamily:'courier' face:'bold' style:'roman'
    "

    "Created: 27.2.1996 / 01:38:15 / cg"
!

primEnumFontTypesInto:typeFaceList
%{
    if (__tmpDC) {
#ifdef USE_EnumFontFamiliesEx
	EnumFontFamiliesEx( __tmpDC, NULL, EnumFPTypeFaceProc, (INT)&typeFaceList);
#else
	EnumFontFamilies( __tmpDC, NULL, EnumFPTypeFaceProc, (INT)&typeFaceList);
#endif
    }
%}
!

primEnumFontsIn:typeFace into:fontList
%{
    char *cp;

    if (__isStringLike(typeFace)) {
	if (__tmpDC) {
#ifdef USE_EnumFontFamiliesEx
	    EnumFontFamiliesEx(__tmpDC, __stringVal(typeFace), EnumFontsProc, (INT)&fontList);
#else
	    EnumFontFamilies(__tmpDC, __stringVal(typeFace), EnumFontsProc, (INT)&fontList);
#endif
	}
    }
%}.
!

primFontMetricsOf:fontId intoArray:rawData
    "evaluate aBlock, passing a fonts metrics as arguments.
     fill passed array as:
      ascent     -> (data at:1)
      descent    -> (data at:2)
      maxAscent  -> (data at:3)
      maxDescent -> (data at:4)
      minWidth   -> (data at:5)
      maxWidth   -> (data at:6)
      avgWidth   -> (data at:7)
      minChar    -> (data at:8)
      maxChar    -> (data at:9)
      defaultChar-> (data at:10)
      charSet    -> (data at:11)
      overHang   -> (data at:12)
"

%{
    if (__isExternalAddress(fontId)
     && __isArray(rawData)
     && (__arraySize(rawData) >= 11)) {
	SIZE size;
	int avgWidth;
	HGDIOBJ hFont;
	HGDIOBJ prevFont;
	// TEXTMETRIC tmet;
	TEXTMETRICW tmet;
	OBJ t;

	hFont = _HGDIOBJVal(fontId);

	/*
	 * temporarily set this font in the tmpDC (root-) context
	 */
#ifdef CACHE_LAST_TMP_FONT
	if (__tmpDC_hfont != hFont) {
	    prevFont = SelectObject(__tmpDC, hFont);
	    if (__tmpDC_prev_hfont == NULL) {
		__tmpDC_prev_hfont = prevFont;
	    }
	    __tmpDC_hfont = hFont;
	}
#else
	prevFont = SelectObject(__tmpDC, hFont);
#endif
	GetTextMetricsW(__tmpDC, &tmet);
#if 0
	{
	    static char *s = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	    static int len;

	    if (len == 0) {
		len = strlen(s);
	    }
	    GetTextExtentPoint32(__tmpDC, s, len, &size);
	    avgWidth = (size.cx / (len / 2) + 1) / 2;
	}
#else
	avgWidth = tmet.tmAveCharWidth;
#endif

#ifndef CACHE_LAST_TMP_FONT
	SelectObject(__tmpDC, prevFont);
#endif

	__ArrayInstPtr(rawData)->a_element[0] = __MKSMALLINT(tmet.tmAscent);        /* ascent     -> (data at:1) */
	__ArrayInstPtr(rawData)->a_element[1] = __MKSMALLINT(tmet.tmDescent);       /* descent    -> (data at:2) */
	__ArrayInstPtr(rawData)->a_element[2] = __MKSMALLINT(tmet.tmAscent);        /* maxAscent  -> (data at:3) */
	__ArrayInstPtr(rawData)->a_element[3] = __MKSMALLINT(tmet.tmDescent);       /* maxDescent -> (data at:4) */
	__ArrayInstPtr(rawData)->a_element[4] = __MKSMALLINT(avgWidth);             /* minWidth   -> (data at:5) */
	__ArrayInstPtr(rawData)->a_element[5] = __MKSMALLINT(tmet.tmMaxCharWidth);  /* maxWidth   -> (data at:6) */
	__ArrayInstPtr(rawData)->a_element[6] = __MKSMALLINT(avgWidth);             /* avgWidth   -> (data at:7) */
	__ArrayInstPtr(rawData)->a_element[7] = __MKSMALLINT(tmet.tmFirstChar);     /* min        -> (data at:8) */
	__ArrayInstPtr(rawData)->a_element[8] = __MKSMALLINT(tmet.tmLastChar);      /* max        -> (data at:9) */
	__ArrayInstPtr(rawData)->a_element[9] = __MKSMALLINT(tmet.tmDefaultChar);   /* default    -> (data at:10) */
	t = __charSetSymbolFor(tmet.tmCharSet);
	__ArrayInstPtr(rawData)->a_element[10]= t; __STORE(rawData, t);             /* charSet    -> (data at:11) */
  __ArrayInstPtr(rawData)->a_element[11]= __MKSMALLINT(tmet.tmOverhang);      /* overHang   -> (data at:12) */

	DPRINTF(("textMetrics h=%x  avgAsc=%d avgDesc=%d minW=%d maxW=%d avgW=%d overHang=%d\n",
		    hFont, tmet.tmAscent, tmet.tmDescent, avgWidth, tmet.tmMaxCharWidth,
		    tmet.tmAveCharWidth, tmet.tmOverhang));
	RETURN (self);
    }
    RETURN (nil);
%}
!

releaseFont:aFontId

%{  /* NOCONTEXT */
    if (__isExternalAddress(aFontId)) {
	HGDIOBJ hFont = _HGDIOBJVal(aFontId);

	if (hFont) {
#ifdef COUNT_RESOURCES
	    __cnt_font--;
	   RES1PRINTF(("DestroyFont %d\n",__cnt_font));
#endif
	   DPRINTF(("ReleaseFont: %x\n", hFont));
	   _DeleteFont(hFont, __LINE__);
	}
    }
%}
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

	^ #(4 5 6 7 8 9 10 11 12 14 16 18 20 22 24 28 32 48 64)
    ].
    ^ sizes

    "
     Display sizesInFamily:'courier' face:'bold' style:'roman'
    "

    "Created: 27.2.1996 / 01:38:15 / cg"
!

widthOf:aString from:index1 to:index2 inFont:aFontId
    "leftover - bw compatibility"
    |w|

    w := self
	widthOf:aString from:index1 to:index2 inFont:aFontId
	in:nil with:nil.

    w isNil ifTrue:[
	"/ the primitive returns nil (sigh) for invalid argument
	w := self
	    widthOf:aString asString asUnicode16String from:index1 to:index2 inFont:aFontId
	    in:nil with:nil
    ].
    ^ w
!

widthOf:aString from:index1 to:index2 inFont:aFontId in:ignoredDrawableId with:aGCId
%{  /* NOCONTEXT */
    unsigned char *cp;
    int len, n, i1, i2, l;
    OBJ cls;
    int nInstBytes;

    if (__bothSmallInteger(index1, index2)
     && __isExternalAddress(aFontId)
     && __isNonNilObject(aString)) {
	HGDIOBJ hFont,prevFont;
	HDC hDC;
	SIZE tsize;

#define xxPRE_22_FEP_2007
#ifndef PRE_22_FEP_2007
#       define N_QUICK_CHARS    1024
	unsigned short quickWchars[N_QUICK_CHARS];
	unsigned short *wcharPtr;
	int mustFree = 0;
	int i;
#endif

	hFont = _HGDIOBJVal(aFontId);

	if (__isExternalAddress(aGCId)) {
	    struct gcData *gcData = _GCDATA(aGCId);
	    hDC = _getDC(gcData);
	    prevFont = SelectObject(hDC, hFont);
	} else {
	    hDC = __tmpDC;
#ifdef CACHE_LAST_TMP_FONT
	    if (__tmpDC_hfont != hFont) {
		prevFont = SelectObject(hDC, hFont);
		if (__tmpDC_prev_hfont == NULL) {
		    __tmpDC_prev_hfont = prevFont;
		}
		__tmpDC_hfont = hFont;
	    }
#else
	    prevFont = SelectObject(hDC, hFont);
#endif
	}

	i1 = __intVal(index1) - 1;
	cls = __qClass(aString);

	if (i1 >= 0) {
	    i2 = __intVal(index2) - 1;
	    if (i2 < i1) {
		RETURN ( __MKSMALLINT( 0 ) );
	    }

	    cp = (char *) _stringVal(aString);
	    l = i2 - i1 + 1;

	    if (__isStringLike(aString)) {
		n = _stringSize(aString);
    commonWidthChars:
		if (i2 < n) {
		    cp += i1;

#ifdef PRE_22_FEP_2007
		    GetTextExtentPoint32(hDC, cp, l, &tsize);
#else
		    if (l <= N_QUICK_CHARS) {
			wcharPtr = quickWchars;
			mustFree = 0;
		    } else {
			wcharPtr = malloc(sizeof(short)*l);
			if (! wcharPtr) RETURN (__MKSMALLINT(0));
			mustFree = 1;
		    }
		    for (i=0; i<l; i++) wcharPtr[i] = ((unsigned char *)cp)[i];
		    GetTextExtentPoint32W(hDC, wcharPtr, l, &tsize);
		    if (mustFree) free(wcharPtr);
#endif

#ifdef SUPERDEBUG
		    if (__debug__) {
			char buf[80];

			GetTextFace(hDC,80,buf);
			console_printf("font1 %x %s >%s< l=%d dx=%d\n",hFont,buf,cp,l,tsize.cx);
		    }
#endif
		    if (__isExternalAddress(aGCId)) {
			SelectObject(hDC, prevFont);
		    } else {
#ifndef CACHE_LAST_TMP_FONT
			SelectObject(hDC, prevFont);
#endif
		    }
		    RETURN ( __MKSMALLINT(tsize.cx) );
		}
		RETURN (__MKSMALLINT(0));
	    }

	    nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	    cp += nInstBytes;
	    n = __byteArraySize(aString) - nInstBytes;

	    if (__isBytes(aString)) {
		goto commonWidthChars;
	    }

	    /* Unicode */
	    if (__isWords(aString)) {
		n = n / 2;
		if (i2 < n) {
		    WIDECHAR *w_cp = (WIDECHAR *)cp;

		    w_cp += i1;

		    GetTextExtentPoint32W(hDC, w_cp, l, &tsize);
		    if (__isExternalAddress(aGCId)) {
			SelectObject(hDC, prevFont);
		    } else {
#ifndef CACHE_LAST_TMP_FONT
			SelectObject(hDC, prevFont);
#endif
		    }
		    RETURN ( __MKSMALLINT(tsize.cx) );
		}
		RETURN (__MKSMALLINT(0));
	    }
	}
    }
%}.
    ^ nil
! !

!WinWorkstation methodsFor:'grabbing'!

allowEvents:mode
!

grabKeyboardIn:aWindowId
    "grab the keyboard"
%{
#ifdef NOT_YET_IMPLEMENTED
    if (__isExternalAddress(aWindowId)) {
      HWND hWnd = _HWNDVal(aWindowId);

      CPRINTF(("grabKeyboard in %x\n",hWnd));
    }
#endif
%}
!

grabPointerIn:aWindowId withCursor:aCursorId pointerMode:pMode keyboardMode:kMode confineTo:confineId
    "grap the pointer - return true if ok"

%{
    if (__isExternalAddress(aWindowId)) {
	HWND hWnd = _HWNDVal(aWindowId);
	HCURSOR hCursor = 0;

	if (__currentCapture != CAPTURE_NONE) {
	    PostMessage(__currentPointerView, WM_THREAD_SETCAPTURE, 0, 0);
	    //ReleaseCapture();
	}
#if 1
	/*
	 * place a special, invisible view above the root
	 */
	if (hWnd == __rootWin) {
	    hWnd = __rootWinSpezial;
	    ShowWindow(hWnd, SW_SHOWNOACTIVATE);
	    //EnableWindow(hWnd,TRUE);
	    SetWindowPos(hWnd, HWND_TOP,
			 0, 0, 0, 0,
			 SWP_NOREDRAW | SWP_NOSENDCHANGING | SWP_NOCOPYBITS
			 | SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE);
	    CPRINTF(("setRootCapture %x\n",hWnd));
	}
#endif
	if (__isExternalAddress(aCursorId)) {
	    hCursor = _HCURSORVal(aCursorId);
	    CPRINTF(("grabPointerIn  SetCapture %x\n",hWnd));
	}
	PostMessage(hWnd, WM_THREAD_SETCAPTURE, (INT)hWnd, (INT)hCursor);
	RETURN (true);
    }
%}.
    ^ false
!

ungrabKeyboard
    "release the keyboard"

    activeKeyboardGrab := nil.
%{
#ifdef NOT_YET_IMPLEMENTED
    CPRINTF(("ungrabKeyboard\n"));
#endif
%}
!

ungrabPointer
    "release the pointer"

%{  /* NOCONTEXT */
    CPRINTF(("ungrabPointer 1\n"));
    PostThreadMessage(_dispatchThreadId, WM_THREAD_SETCAPTURE, 0, 0);
%}.
    activePointerGrab := nil
! !

!WinWorkstation methodsFor:'graphic context stuff'!

noClipIn:aWindowId gc:aGCId
    "disable clipping rectangle"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aWindowId)
     && __isExternalAddress(aGCId)) {
	struct gcData *gcData = _GCDATA(aGCId);

	if (gcData->clipping != FALSE) {
#ifdef GDIFLUSH_WHEN_CHANGING_CLIP
	    GdiFlush();
#endif
	    gcData->clipping = FALSE;
#ifdef CACHE_LAST_DC
	    if (lastGcData == gcData) {
		SelectClipRgn(gcData->_hDC, NULL);
	    }
#endif
	}
	RETURN (self);
    }
%}
!

setBackground:bgColorIndex in:aGCId
    "set background color to be drawn with"

%{  /* NOCONTEXT */

    if (__isSmallInteger(bgColorIndex)
	&& __isExternalAddress(aGCId)) {
	struct gcData *gcData = _GCDATA(aGCId);
	COLORREF bgColor;

	bgColor = (COLORREF)st2RGB(__intVal(bgColorIndex),gcData);
	if (bgColor != gcData->bgColor) {
	    gcData->bgColor = bgColor;
#ifdef CACHE_LAST_DC
	    if (lastGcData == gcData) {
		SetBkColor(gcData->_hDC, bgColor);
		/*
		 * no need to flush pen - it does not depend upon
		 * the bg color
		 */
	    }
#endif
	}

	CPRINTF(("setBackground: %x\n", bgColor));
	RETURN (self);
    }
%}.

    ^self primitiveFailed
!

setBitmapMask:aBitmapId in:aGCId
    "set or clear the drawing mask - a bitmap mask using current fg/bg"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aGCId)) {
	struct gcData *gcData = _GCDATA(aGCId);
	HBITMAP oldM;

	oldM = gcData->hMask;
	if (__isExternalAddress(aBitmapId))
	    gcData->hMask = _HBITMAPVAL(aBitmapId);
	else
	    gcData->hMask = 0;

	if (oldM != gcData->hMask) {
	    FLUSH_CACHED_DC(gcData);
	    CPRINTF(("masks set to %x\n",gcData->hMask));
	}
	RETURN (self);
    }
%}
!

setClipByChildren:aBool in:aWindowId gc:aGCId
    "enable/disable drawing into child views"

%{  /* NOCONTEXT */

    if (ISCONNECTED && __isExternalAddress(aGCId)) {
	struct gcData *gcData = _GCDATA(aGCId);

	if (gcData && gcData->hWnd) {
	    int newClip;

	   newClip = (aBool == true) ? TRUE : FALSE;
	    if (newClip != gcData->clipByChildren) {
#ifdef GDIFLUSH_WHEN_CHANGING_CLIP
		GdiFlush();
#endif
		/* set/clear clip by children */
		gcData->clipByChildren = newClip;
		FLUSH_CACHED_DC(gcData);
	    }
	} else {
	    DPRINTF(("clipping by child failed - invalid window\n" ));
	}
    }
%}.
    ^ self
!

setClipX:clipXArg y:clipYArg width:clipWidth height:clipHeight in:ignoredDrawableId gc:aGCId
    "clip to a rectangle"

"
      p--w---
      |     |
      h     |  the clipping rectangle
      |     |
      -------
	  where p = ( clipXArg, clipYArg ), w = clipWidth, h = clipHeight
"

%{  /* NOCONTEXT */

    if (  __isExternalAddress(aGCId)
       && __bothSmallInteger(clipXArg, clipYArg)
       && __bothSmallInteger(clipWidth, clipHeight) ) {
	struct gcData *gcData = _GCDATA(aGCId);
	int cX, cY, cW, cH;

	cX = __intVal(clipXArg);
	cY = __intVal(clipYArg);
	cW = __intVal(clipWidth);
	cH = __intVal(clipHeight);

	if ((gcData->clipping != TRUE)
	 || (cX != gcData->clipX)
	 || (cY != gcData->clipY)
	 || (cW != gcData->clipW)
	 || (cH != gcData->clipH)) {
	    gcData->clipping = TRUE;
	    gcData->clipX = cX;
	    gcData->clipY = cY;
	    gcData->clipW = cW;
	    gcData->clipH = cH;

#ifdef GDIFLUSH_WHEN_CHANGING_CLIP
	    GdiFlush();
#endif
#ifdef CACHE_LAST_DC
	    /*
	     * must update current cached DC
	     */
	    if (lastGcData == gcData) {
		HRGN region = CreateRectRgn(cX, cY, cX + cW, cY + cH);

		if (region == NULL ) {
		    console_fprintf(stderr, "WinWorkstat [warning]: clipping region creation failed\n");
		    FLUSH_CACHED_DC(gcData);
		} else {
		    if (SelectClipRgn(gcData->_hDC, region) == ERROR ) {
			console_fprintf(stderr, "WinWorkstat [warning]: select clipping region failed\n");
			FLUSH_CACHED_DC(gcData);
		    }
		    _DeleteObject(region, __LINE__);
		}
	    }
#endif
	}
	RETURN (self);
    }
%}
!

setDashes:dashList dashOffset:offset in:aGCId
    "set line attributes"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aGCId)) {
	PRINTF(("WinWorkstat [warning]: dashes not (yet) implemented\n"));
    }
%}
!

setFont:aFontId in:aGCId
    "set font to be drawn in"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aGCId)
     && __isExternalAddress(aFontId))
    {
	struct gcData *gcData = _GCDATA(aGCId);
	HGDIOBJ prevFont, hFont;
	// TEXTMETRIC tmet;
	TEXTMETRICW tmet;

	hFont = _HGDIOBJVal(aFontId);
	if (gcData->hFont != hFont) {
	    gcData->hFont = hFont;

#ifdef CACHE_LAST_TMP_FONT
	    if (__tmpDC_hfont != hFont) {
		prevFont = SelectObject(__tmpDC, hFont);
		if (__tmpDC_prev_hfont == NULL) {
		    __tmpDC_prev_hfont = prevFont;
		}
		__tmpDC_hfont = hFont;
	    }
#else
	    prevFont = SelectObject(__tmpDC, hFont);
#endif

	    GetTextMetricsW(__tmpDC, &tmet);
	    gcData->fontAscent = tmet.tmAscent;
#ifdef SUPERDEBUG
	    if (__debug__) {
		char buf[80];

		GetTextFace(__tmpDC, 80, buf);
		PRINTF(("setFont: %x %s\n", hFont, buf));
	    }
#endif
#ifndef CACHE_LAST_TMP_FONT
	    SelectObject(__tmpDC, prevFont);
#endif

#ifdef CACHE_LAST_DC
	    /*
	     * must update current cached DC
	     */
	    if (lastGcData == gcData) {
		prevFont = SelectObject(gcData->_hDC, hFont);
		if (! gcData->save_hFont) {
		    gcData->save_hFont = prevFont;
		}
	    }
#endif
	    RETURN ( self );
	}
    }
%}
!

setForeground:fgColorIndex background:bgColorIndex in:aGCId
    "set foreground and background colors to be drawn with"

%{  /* NOCONTEXT */

    if (__bothSmallInteger(fgColorIndex, bgColorIndex)
	&& __isExternalAddress(aGCId)) {
	struct gcData *gcData = _GCDATA(aGCId);
	COLORREF fg, bg, oldFg, oldBg;

	fg = (COLORREF)st2RGB(__intVal(fgColorIndex),gcData);
	bg = (COLORREF)st2RGB(__intVal(bgColorIndex),gcData);
	oldFg = gcData->fgColor;
	oldBg = gcData->bgColor;

	if ((fg != oldFg) || (bg != oldBg)) {
	    gcData->fgColor = fg;
	    gcData->bgColor = bg;

#ifdef CACHE_LAST_DC
	    /*
	     * must update or flush current cached DC
	     */
	    if (lastGcData == gcData) {
		/* Pen only depends upon fg-color */
		if (fg != oldFg) {
		    SetTextColor(gcData->_hDC, fg);
		    FLUSH_CACHED_PEN(gcData);
		}
		if (bg != oldBg) {
		    SetBkColor(gcData->_hDC, bg);
		}
		FLUSH_CACHED_BRUSH(gcData);
	    }
#endif
	    CPRINTF(("setForeground: %x background: %x\n", gcData->fgColor, gcData->bgColor));
	}
	RETURN (self);
    }
%}.
    ^self primitiveFailed
!

setForeground:fgColorIndex background:bgColorIndex mask:aBitmapId in:aGCId
    "set foreground and background colors to be drawn with using mask or
     solid (if aBitmapId is nil)"

%{  /* NOCONTEXT */

    if (__bothSmallInteger(fgColorIndex, bgColorIndex)
	&& __isExternalAddress(aGCId)) {
	struct gcData *gcData = _GCDATA(aGCId);
	COLORREF fg, bg, oldFg, oldBg;
	HBITMAP m, oldM;

	fg = (COLORREF)st2RGB(__intVal(fgColorIndex),gcData);
	bg = (COLORREF)st2RGB(__intVal(bgColorIndex),gcData);
	if (__isExternalAddress(aBitmapId))
	    m = _HBITMAPVAL(aBitmapId);
	else
	    m = 0;

	oldFg = gcData->fgColor;
	oldBg = gcData->bgColor;
	oldM = gcData->hMask;

	if ((oldFg != fg) || (oldBg != bg) || (oldM != m)) {
	    gcData->fgColor = fg;
	    gcData->bgColor = bg;
	    gcData->hMask = m;

#ifdef CACHE_LAST_DC
	    /*
	     * must update or flush current cached DC
	     */
	    if (lastGcData == gcData) {
		if (oldM == m) {
		    /*
		     * only fg/bg changed
		     */
		    /* Pen only depends upon fg-color */
		    if (fg != oldFg) {
			SetTextColor(gcData->_hDC, fg);
			FLUSH_CACHED_PEN(gcData);
		    }
		    if (bg != oldBg) {
			SetBkColor(gcData->_hDC, bg);
		    }
		    FLUSH_CACHED_BRUSH(gcData);
		} else {
		    _releaseDC(gcData);
		}
	    }
#endif
	    CPRINTF(("setForeground: %x background: %x mask: %x\n", gcData->fgColor, gcData->bgColor,gcData->hMask));
	}
	RETURN (self);
    }
%}.

    ^ self primitiveFailed
!

setForeground:fgColorIndex background:bgColorIndex mask:aBitmapId lineWidth:aLineWidth in:aGCId
    "set foreground and background colors to be drawn with using mask or
     solid (if aBitmapId is nil); also set lineWidth"

%{  /* NOCONTEXT */

    if (__bothSmallInteger(fgColorIndex, bgColorIndex)
	&& __isSmallInteger(aLineWidth)
	&& __isExternalAddress(aGCId)) {
	struct gcData *gcData = _GCDATA(aGCId);
	COLORREF fg, bg, oldFg, oldBg;
	HBITMAP m, oldM;
	int lw, oldLw;

	fg = (COLORREF)st2RGB(__intVal(fgColorIndex),gcData);
	bg = (COLORREF)st2RGB(__intVal(bgColorIndex),gcData);
	if (__isExternalAddress(aBitmapId))
	    m = _HBITMAPVAL(aBitmapId);
	else
	    m = 0;
	lw = __intVal(aLineWidth);

	oldFg = gcData->fgColor;
	oldBg = gcData->bgColor;
	oldLw = gcData->lineWidth;
	oldM = gcData->hMask;

	if ((oldFg != fg) || (oldBg != bg)
	 || (oldLw != lw) || (oldM != m)) {

	    gcData->fgColor = fg;
	    gcData->bgColor = bg;
	    gcData->lineWidth = lw;
	    gcData->hMask = m;

#ifdef CACHE_LAST_DC
	    /*
	     * must update or flush current cached DC
	     */
	    if (lastGcData == gcData) {
		if ((oldM == m) && (oldLw == lw)) {
		    /*
		     * only fg/bg changed
		     */
		    /* Pen only depends upon fg-color */
		    if (fg != oldFg) {
			SetTextColor(gcData->_hDC, fg);
			FLUSH_CACHED_PEN(gcData);
		    }
		    if (bg != oldBg) {
			SetBkColor(gcData->_hDC, bg);
		    }
		    FLUSH_CACHED_BRUSH(gcData);
		} else {
		    _releaseDC(gcData);
		}
	    }
#endif
	    CPRINTF(("setForeground: %x background: %x mask: %x linewidth: %d\n",
			gcData->fgColor, gcData->bgColor,
			gcData->hMask, gcData->lineWidth));
	}
	RETURN (self);
    }
%}.

    ^ self primitiveFailed
!

setForeground:fgColorIndex in:aGCId
    "set foreground color to be drawn with"

%{  /* NOCONTEXT */

    HDC hDC;

    if (__isSmallInteger(fgColorIndex)
	&& __isExternalAddress(aGCId)) {
	struct gcData *gcData = _GCDATA(aGCId);
	COLORREF fg;

	fg = (COLORREF)st2RGB(__intVal(fgColorIndex),gcData);
	if (fg != gcData->fgColor) {
	    gcData->fgColor = fg;

#ifdef CACHE_LAST_DC
	    /*
	     * must update or flush current cached DC
	     */
	    if (lastGcData == gcData) {
		/* Pen depends upon fg-color */
		SetTextColor(gcData->_hDC, fg);
		FLUSH_CACHED_PEN(gcData);
		FLUSH_CACHED_BRUSH(gcData);
	    }
#endif
	    CPRINTF(("setForeground: %x\n", gcData->fgColor));
	}
	RETURN (self);
    }
%}.

    ^ self primitiveFailed
!

setFunction:aFunctionSymbol in:aGCId
    "set alu function to be drawn with"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aGCId)) {
	struct gcData *gcData = _GCDATA(aGCId);
	int fun = -1;
	int bfun = -1;

	if (aFunctionSymbol == @symbol(copy)) {
	    fun = R2_COPYPEN;
	    bfun = BITBLT_COPY;
	} else if (aFunctionSymbol == @symbol(copyInverted)) {
	    fun = R2_NOTCOPYPEN;
	    bfun = BITBLT_COPYINVERTED;
	} else if (aFunctionSymbol == @symbol(xor)) {
	    fun = R2_XORPEN;
	    bfun = BITBLT_XOR;
	} else if (aFunctionSymbol == @symbol(and)) {
	    fun = R2_MASKPEN;
	    bfun = BITBLT_AND;
	} else if (aFunctionSymbol == @symbol(or)) {
	    fun = R2_MERGEPEN;
	    bfun = BITBLT_OR;
	}

	if (fun != -1) {
#if 0
	    console_printf("set func to");
	    switch (bfun) {
		case BITBLT_COPY:
		    console_printf("BITBLT_COPY\n");
		    break;
		case BITBLT_COPYINVERTED:
		    console_printf("BITBLT_COPYINVERTED\n");
		    break;
		case BITBLT_XOR:
		    console_printf("BITBLT_XOR\n");
		    break;
		case BITBLT_AND:
		    console_printf("BITBLT_AND\n");
		    break;
		case BITBLT_OR:
		    console_printf("BITBLT_OR\n");
		    break;
	    }
#endif
	} else {
	    INFOFPRINTF( (stderr, "WinWorkstat [warning]: unsuported Rasterfunction\n") );
	    fun = R2_COPYPEN;
	    bfun = BITBLT_COPY;
	}

	if ((fun != gcData->rop2)
	 || (bfun != gcData->bitbltrop2)) {
	    gcData->rop2 = fun;
	    gcData->bitbltrop2 = bfun;
#ifdef CACHE_LAST_DC
	    /*
	     * must update current cached DC
	     */
	    if (gcData == lastGcData) {
		SetROP2(gcData->_hDC, fun);
	    }
#endif
	}
    } else {
	INFOFPRINTF((stderr, "WinWorkstation [warning]: Rasterfunction no GC\n"));
    }
%}
!

setGraphicsExposures:aBoolean in:aGCId
    "set or clear the graphics exposures flag"

!

setLineWidth:aNumber style:lineStyle cap:capStyle join:joinStyle in:aGCId
    "set line attributes"

%{  /* NOCONTEXT */

    HDC hDC;

    if (__isExternalAddress(aGCId)
     && __isSmallInteger(aNumber)) {
	struct gcData *gcData = _GCDATA(aGCId);
	int style;

	gcData->lineWidth = __intVal(aNumber);
	if (lineStyle == @symbol(solid)) {
	    style = PS_SOLID;
	} else if (lineStyle == @symbol(dashed)) {
	    style= PS_DASH;
	} else if (lineStyle == @symbol(dotted)) {
	    style= PS_DOT;
	} else if (lineStyle == @symbol(dashDot)) {
	    style= PS_DASHDOT;
	} else if (lineStyle == @symbol(dashDotDot)) {
	    style= PS_DASHDOTDOT;
	} else
	    style= PS_SOLID;
	gcData->lStyle &= ~PS_STYLE_MASK;
	gcData->lStyle |= style;


	if (capStyle == @symbol(round)) {
	    style = PS_ENDCAP_ROUND;
	} else if (capStyle == @symbol(square)) {
	    style = PS_ENDCAP_SQUARE;
	} else if (capStyle == @symbol(flat)) {
	    style = PS_ENDCAP_FLAT;
	} else
	    style = PS_ENDCAP_FLAT;
	gcData->lStyle &= ~PS_ENDCAP_MASK;
	gcData->lStyle |= style;

	if (joinStyle == @symbol(bevel)) {
	    style = PS_JOIN_BEVEL;
	} else if (joinStyle == @symbol(miter)) {
	    style = PS_JOIN_MITER;
	} else if (joinStyle == @symbol(round)) {
	    style = PS_JOIN_ROUND;
	} else
	    style = PS_JOIN_MITER;
	gcData->lStyle &= ~PS_JOIN_MASK;
	gcData->lStyle |= style;

	FLUSH_CACHED_DC(gcData);
	RETURN (self);
    }
%}
!

setMaskOriginX:orgX y:orgY in:aGCId
    "set the mask origin"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aGCId)
     && __bothSmallInteger(orgX,orgY)) {
	struct gcData *gcData = _GCDATA(aGCId);
	int oX, oY;

	oX = __intVal(orgX);
	oY = __intVal(orgY);
	if ((oX != gcData->maskOrgX)
	 || (oY != gcData->maskOrgY)) {
	    gcData->maskOrgX = __intVal(orgX);
	    gcData->maskOrgY = __intVal(orgY);;
	    FLUSH_CACHED_DC(gcData);
	}
	RETURN (self);
    }
%}
!

setPixmapMask:aPixmapId in:aGCId
    "set or clear the drawing mask - a pixmap mask providing full color"

%{  /* NOCONTEXT */
    if (__isExternalAddress(aGCId)) {
	struct gcData *gcData = _GCDATA(aGCId);
	HBITMAP oldM;

	oldM = gcData->hMask;
	if (__isExternalAddress(aPixmapId))
	    gcData->hMask = _HBITMAPVAL(aPixmapId);
	else
	    gcData->hMask = 0;

	if (oldM != gcData->hMask) {
	    FLUSH_CACHED_DC(gcData);
	    DPRINTF(("PixmapMasks set to %x\n",gcData->hMask));
	}
	RETURN (self);
    }
%}
! !

!WinWorkstation methodsFor:'initialization & release'!

closeConnection
    "close down the connection to the display"

"/    Processor disableSemaphore:eventSema
!

initializeDefaultValues
    focusMode := #activeWindow.

"/    self activateOnClick:true.
"/    self ignoreButtonPressOnActivate:false.
"/    self rightButtonIsLowerWindow:true.
"/    self shiftedLeftButtonIsLowerWindow:true.

    buttonTranslation := ButtonTranslation.

    self initializeModifierMappings
!

initializeDevice
%{

    int scr;
    int maxRGBDepth;
    int rgbRedMask, rgbGreenMask, rgbBlueMask;
    int nvi, i;
    char *type, *nm;
    int dummy;
    int mask, shift, nBits;
    HDC _rootDC;
    OBJ id;

    if (firstInstance) {
	OSVERSIONINFO osvi;
	WNDCLASSW wc_stx;
	WNDCLASSW wc_root;
	WNDCLASSW wc_popup;
	WNDCLASSW wc_dialog;
	firstInstance = 0;
	DPRINTF(("first create - registerClass\n"));

	memset(&osvi, 0, sizeof(OSVERSIONINFO));
	osvi.dwOSVersionInfoSize = sizeof (OSVERSIONINFO);
	GetVersionEx (&osvi);

	switch (osvi.dwMajorVersion) {
	    default:
		// defaults to the newest version we know about
		INFOFPRINTF( (stderr, "WinWorkstat [info]: unknown/new display version %d:%d (assume post vista)\n", osvi.dwMajorVersion, osvi.dwMinorVersion) );
		// fall into
	    case 6:
		// vista, win7, win8
		__isWinXP = 1;
		__isWinVista = 1;
		break;

	    case 5:
		// 2k, xp and 2003
		switch (osvi.dwMinorVersion) {
		    default:
		    case 2:         // windows server 2003
		    case 1:         // windows xp
			__isWinXP = 1;
			break;
		    case 0:
			__isWin2k = 1;
		}
		break;

	    // no longer supported
	    case 4:   // nt4.0
	    case 3:   // nt3.51
	    case 2:
	    case 1:
	    case 0:
		INFOFPRINTF( (stderr, "WinWorkstat [error]: no longer supported display version %d:%d\n", osvi.dwMajorVersion, osvi.dwMinorVersion) );
		break;
	}

	/*
	 * register class: ST/X
	 */
	wc_stx.style = 0
		   /* | CS_OWNDC */
		   /* | CS_HREDRAW */
		   /* | CS_VREDRAW */
		  | CS_DBLCLKS;
	wc_stx.lpfnWndProc = (WNDPROC) MainWndProc;
	wc_stx.cbClsExtra = 0;
	wc_stx.cbWndExtra = N_WINDOW_PRIVATE;
	wc_stx.hInstance = (HANDLE) __getHInstance();
	wc_stx.hIcon = NULL;
	wc_stx.hCursor = 0;
	wc_stx.hbrBackground = 0;

	wc_stx.lpszMenuName =  NULL;
	wc_stx.lpszClassName = wapp_name;
	RegisterClassW( (&wc_stx) );

	/*
	 * register class: ST/X:Root
	 */
	wc_root.style = 0;
	wc_root.lpfnWndProc = (WNDPROC) MainWndProc;
	wc_root.cbClsExtra = 0;
	wc_root.cbWndExtra = N_WINDOW_PRIVATE;
	wc_root.hInstance = (HANDLE) __getHInstance();
	wc_root.hIcon = NULL;
	wc_root.hCursor = 0;
	wc_root.hbrBackground = GetStockObject(HOLLOW_BRUSH);

	wc_root.lpszMenuName =  NULL;
	wc_root.lpszClassName = wapp_nameRoot;
	RegisterClassW( (CONST WNDCLASSW *)(&wc_root) );

	/*
	 * register class: ST/X:Popup
	 */
	wc_popup.style = CS_SAVEBITS;
	if (__isWinXP) {
#ifndef CS_DROPSHADOW
# define CS_DROPSHADOW    0x020000
#endif
	    wc_popup.style |= CS_DROPSHADOW;
	}
	wc_popup.lpfnWndProc = (WNDPROC) MainWndProc;;
	wc_popup.cbClsExtra = 0;
	wc_popup.cbWndExtra = N_WINDOW_PRIVATE;
	wc_popup.hInstance = (HANDLE) __getHInstance();
	wc_popup.hIcon = NULL;
	wc_popup.hCursor = 0;
	wc_popup.hbrBackground = GetStockObject(HOLLOW_BRUSH);

	wc_popup.lpszMenuName =  NULL;
	wc_popup.lpszClassName = wapp_namePopup;
	RegisterClassW( (CONST WNDCLASSW *)(&wc_popup) );

	/*
	 * register class: ST/X:Dialog
	 */
	wc_dialog.style = CS_SAVEBITS;
	wc_dialog.lpfnWndProc = (WNDPROC) MainWndProc;;
	wc_dialog.cbClsExtra = 0;
	wc_dialog.cbWndExtra = N_WINDOW_PRIVATE;
	wc_dialog.hInstance = (HANDLE) __getHInstance();
	wc_dialog.hIcon = NULL;
	wc_dialog.hCursor = 0;
	wc_dialog.hbrBackground = GetStockObject(HOLLOW_BRUSH);

	wc_dialog.lpszMenuName =  NULL;
	wc_dialog.lpszClassName = wapp_nameDialog;
	RegisterClassW( (CONST WNDCLASSW *)(&wc_dialog) );

	/*
	 * generate my events
	 */
	hDispatchThreadRunningEvent = CreateEvent(
				NULL,            /* no security attributes */
				FALSE,
				FALSE,
				"DispatchThreadRunning"); /* name of event */

	if (hDispatchThreadRunningEvent == NULL) {
	    console_fprintf(stderr, "WinWorkstation [fatal]: CreateEvent-0 failed\n");
	    exit(1);
	}

	hNeverTriggered = CreateEvent(
				NULL,            /* no security attributes */
				FALSE,
				FALSE,
				"Never");

	if (hNeverTriggered == NULL) {
	    console_fprintf(stderr, "WinWorkstation [fatal]: CreateEvent-1 failed\n");
	    exit(1);
	}

	hCreateEvent = CreateEvent(
				NULL,            /* no security attributes */
				FALSE,
				FALSE,
				"CreateEvents"); /* name of event */

	if (hCreateEvent == NULL) {
	    console_fprintf(stderr, "WinWorkstation [fatal]: CreateEvent-2 failed\n");
	    exit(1);
	}

	hInputEvent = CreateEvent(
				NULL,            /* no security attributes */
				FALSE,
				FALSE,
				"InputEvents");  /* name of event */

	if (hInputEvent == NULL) {
	    console_fprintf(stderr, "WinWorkstation [fatal]: CreateEvent-3 failed\n");
	    exit(1);
	}

	if (hEventsMutex) {
	    console_fprintf(stderr, "WinWorkstation [fatal]: hEventsMutex already created\n");
	    exit(1);
	}
	hEventsMutex = CreateMutex(
				NULL,            /* no security attributes */
				FALSE,           /* initially not owned */
				"EventsMutex");  /* name of mutex */

	if (! hEventsMutex) {
	    console_fprintf(stderr, "WinWorkstation [fatal]: hEventsMutex failed\n");
	    exit(1);
	}
	DuplicateHandle(GetCurrentProcess(),
			hEventsMutex,
			GetCurrentProcess(),
			&hEventsMutex,
			DUPLICATE_SAME_ACCESS,
			FALSE,
			DUPLICATE_SAME_ACCESS);

#ifdef USE_PAINT_MUTEX
	hPaintMutex = CreateMutex(
				NULL,           /* no security attributes */
				FALSE,          /* initially not owned */
				"PaintMutex");  /* name of mutex */

	if (hPaintMutex == NULL) {
	    console_fprintf(stderr, "WinWorkstation [fatal]: CreateMutex(PaintMutex) failed\n");
	    exit(1);
	}
	DuplicateHandle(GetCurrentProcess(),
			hPaintMutex,
			GetCurrentProcess(),
			&hPaintMutex,
			DUPLICATE_SAME_ACCESS,
			FALSE,
			DUPLICATE_SAME_ACCESS);
#endif
#ifdef USE_DRAW_MUTEX
	hDrawMutex = CreateMutex(
				NULL,           /* no security attributes */
				FALSE,          /* initially not owned */
				"DrawMutex");   /* name of mutex */

	if (hDrawMutex == NULL) {
	    console_fprintf(stderr, "WinWorkstation [fatal]: CreateMutex(DrawMutex) failed\n");
	    exit(1);
	}
	DuplicateHandle(GetCurrentProcess(),
			hDrawMutex,
			GetCurrentProcess(),
			&hDrawMutex,
			DUPLICATE_SAME_ACCESS,
			FALSE,
			DUPLICATE_SAME_ACCESS);
#endif

	_masterThreadId = GetCurrentThreadId();
#ifndef WIN32THREADS
	DuplicateHandle(GetCurrentProcess(),
			GetCurrentThread(),
			GetCurrentProcess(),
			&_masterThread,
			DUPLICATE_SAME_ACCESS,
			FALSE,
			DUPLICATE_SAME_ACCESS);
#endif

	initEventqueue();

	/*
	 * start the event dispatcher thread and wait for it to
	 * be ready
	 */
	CreateThread((LPSECURITY_ATTRIBUTES)0,
		     EVENT_THREAD_STACKSIZE,
		     (LPTHREAD_START_ROUTINE)dispatchThread,
		     0, 0, &_dispatchThreadId);

#ifdef STARTUP_DISPATCHTHREAD_DEBUG
	console_fprintf(stderr, "WinWorkstation [info]: dispatchThreadId=%x\n", _dispatchThreadId);
#endif

	if (WaitForSingleObject(hDispatchThreadRunningEvent, 5000L) != WAIT_OBJECT_0) {
	    console_fprintf(stderr, "WinWorkstation [error]: oops - timeout waiting for eventThread to start\n");
	}
#ifdef STARTUP_DISPATCHTHREAD_DEBUG
	console_fprintf(stderr, "WinWorkstation [info]: got ThreadRunningEvent\n");
#endif
    }

#if 0
    __rootDesk = OpenDesktop ("Desktop0", 0, FALSE, GENERIC_ALL);
    if (!__rootDesk) {
	PRINTF(("OpenDesktop fail\n"));
	__rootDesk = CreateDesktop ("Desktop0", NULL, NULL, 0, DESKTOP_WRITEOBJECTS, NULL);
	if (!__rootDesk) {
	    PRINTF(("CreateDesktop fail\n"));
	}
    }
#endif

    __rootWin = GetDesktopWindow();
    __PROTECT__(self);
    id = __MKOBJ(__rootWin);
    __UNPROTECT__(self);
    __INST(rootWin) = id; __STORE(self, id);

    _rootDC = __rootDC = CreateDC("DISPLAY", NULL, NULL, NULL);

    __tmpDC = CreateCompatibleDC(_rootDC);

    __nullPen = GetStockObject(NULL_PEN);
    __blackPen = GetStockObject(BLACK_PEN);
    __whitePen = GetStockObject(WHITE_PEN);
    __blackBrush = GetStockObject(BLACK_BRUSH);
    __whiteBrush = GetStockObject(WHITE_BRUSH);

    __PROTECT__(self);
    id = __MKOBJ(_rootDC);
    __UNPROTECT__(self);
    __INST(rootDC) = id; __STORE(self, id);
%}.
!

initializeEventBuffer
    |sz|

%{
    sz = __MKSMALLINT(sizeof(struct queuedEvent) + 100);
%}.
    eventBuffer isNil ifTrue:[
	eventBuffer := ByteArray new:sz.
    ].
!

initializeFor:aDisplayName
    "initialize the receiver for a connection to the display;
     the argument, aDisplayName is ignored under Win32.
     (who knows - it may be used in the future to support multiple
      windows displays ...)"

    displayId notNil ifTrue:[
	"/ already connected - trying to trick me ?
	^ self
    ].

    displayId := self primInitializeFor:aDisplayName.
    displayId isNil ifTrue:[
	self class deviceOpenErrorSignal raiseWith:aDisplayName
    ].

    dispatching := false.
    isSlow := false.
    shiftDown := false.
    ctrlDown := false.
    metaDown := false.
    altDown := false.
    motionEventCompression := true.
    buttonsPressed := 0.

    self initializeScreenProperties.
    self initializeDevice.
    self initializeVariableScreenProperties.
    self initializeVariableSettingsProperties.
    self initializeDeviceResourceTables.

    self initializeDefaultValues.
    self initializeEventBuffer.
    self initializeSpecialFlags.
    self initializeKeyboardMap.
    "/ no need to read the stylesheet here - done later...
    "/ self initializeViewStyle.
!

initializeModifierMappings
    shiftModifiers := #(#'Shift_L' #'Shift_R' #'Shift').
    ctrlModifiers := #(#'Ctrl_L' #'Ctrl_R' #'Ctrl').
    metaModifiers := #(#'Alt_L' #'Alt' #'Menu').
    altModifiers := #(#'Alt_R').
!

initializeSpecialFlags
    "perform additional special server implementation flags"
!

initializeVariableScreenProperties
    "fetch properties which can be changed via the users display-settings.
     Invoked initially and as a result of the displayChange event."

%{
    int nvi, i, val, capabilities, planes, numcolors, numpens;
    RECT rect;

    GetWindowRect(__rootWin, &rect);
    __INST(width) = __MKSMALLINT(rect.right - rect.left);
    __INST(height) = __MKSMALLINT(rect.bottom - rect.top);
    DPRINTF(("screen is %d/%d\n", __intVal(__INST(width)), __intVal(__INST(height))));

    __realDepth = GetDeviceCaps(__rootDC, BITSPIXEL);

#ifdef ALWAYSTRUECOLOR
    __depth = 24;  /* its a hack */
#else
    __depth = __realDepth;
    if (__depth == 15)
	__depth = 16;
#endif

#if 0
    numcolors = GetDeviceCaps(__rootDC, NUMCOLORS);
    numpens = GetDeviceCaps(__rootDC, NUMPENS);
    planes = GetDeviceCaps(__rootDC, PLANES);

    DPRINTF(("screen has %d planes\n", planes));
    DPRINTF(("numcolors is %d\n", numcolors));
    DPRINTF(("numpens is %d\n", numpens));
#endif

    __INST(depth) = __MKSMALLINT(__depth);
    __INST(ncells) = __MKSMALLINT(1<<__depth);

    val = GetDeviceCaps(__rootDC, HORZSIZE);
    DPRINTF(("HORSIZE=%d\n",val));
    if (val > 0) {
	__INST(widthMM) = __MKSMALLINT(val);
    }
    val = GetDeviceCaps(__rootDC, VERTSIZE);
    DPRINTF(("VERTSIZE=%d\n",val));
    if (val > 0) {
	__INST(heightMM) = __MKSMALLINT(val);
    }
    __logPixelSY = GetDeviceCaps(__rootDC, LOGPIXELSY);
    capabilities = GetDeviceCaps(__rootDC, RASTERCAPS);

#ifdef LATER
    console_printf("device support:\n");
    if (capabilities & RC_BANDING)
	console_printf(" RC_BANDING");

    if (capabilities & RC_BITBLT)
	console_printf(" RC_BITBLT");

    if (capabilities & RC_BITMAP64)
	console_printf(" RC_BITMAP64");

    if (capabilities & RC_DI_BITMAP)
	console_printf(" RC_DI_BITMAP");

    if (capabilities & RC_DIBTODEV)
	console_printf(" RC_DIBTODEV");

    if (capabilities & RC_FLOODFILL)
	console_printf(" RC_FLOODFILL");

    if (capabilities & RC_PALETTE)
	console_printf(" RC_PALETTE");

    if (capabilities & RC_SCALING)
	console_printf(" RC_SCALING");

    if (capabilities & RC_STRETCHBLT)
	console_printf(" RC_STRETCHBLT");

    if (capabilities & RC_STRETCHDIB)
	console_printf(" RC_STRETCHDIB");

    console_printf("\n");
    console_printf("cursor size %d %d\n", GetSystemMetrics(SM_CXCURSOR), GetSystemMetrics(SM_CYCURSOR));
#endif

    __INST(whitepixel) = __MKSMALLINT(WhitePixel);
    __INST(blackpixel) = __MKSMALLINT(BlackPixel);

    __INST(monitorType) = @symbol(unknown);

#ifdef ALWAYSTRUECOLOR
    __INST(hasColors) = true;
    __INST(hasGreyscales) = true;
    __INST(visualType) = @symbol(TrueColor);
    __INST(redShift) = __MKSMALLINT(0);
    __INST(greenShift) = __MKSMALLINT(8);
    __INST(blueShift) = __MKSMALLINT(16);
    switch (__realDepth) {
	case 15:
	case 16:
	    __INST(bitsPerRGB) = __MKSMALLINT(5);
	    break;
	default:
	    __INST(bitsPerRGB) = __MKSMALLINT(8);
    }
    __INST(bitsRed) = __INST(bitsGreen) = __INST(bitsBlue) = __MKSMALLINT(8);
    __INST(redMask) = __MKSMALLINT(0xFF);
    __INST(greenMask) = __MKSMALLINT(0xFF00);
    __INST(blueMask) = __MKSMALLINT(0xFF0000);
#else
    if (! (capabilities & RC_PALETTE)) {
	DPRINTF(("no palette\n"));
	if (__depth == 1) {
	    __INST(hasColors) = false;
	    __INST(hasGreyscales) = false;
	    __INST(visualType) = @symbol(GrayScale);
	    __INST(monitorType) = @symbol(monochrome);
	} else {
	    __INST(hasColors) = true;
	    __INST(hasGreyscales) = true;
	    if ((__depth == 16) || (__depth == 15)) {
	      __INST(visualType) = @symbol(TrueColor);
	      __INST(blueShift) = __MKSMALLINT(0);
	      __INST(greenShift) = __MKSMALLINT(5);
	      __INST(redShift) = __MKSMALLINT(11);
	      __INST(bitsPerRGB) = __MKSMALLINT(5);
	      __INST(bitsRed) = __INST(bitsGreen) = __INST(bitsBlue) = __MKSMALLINT(5);
	      __INST(blueMask) = __MKSMALLINT(0x1f);
	      __INST(greenMask) = __MKSMALLINT(0x7e0);
	      __INST(redMask) = __MKSMALLINT(0xf800);
	    } else {
	      __INST(visualType) = @symbol(TrueColor);
	      __INST(redShift) = __MKSMALLINT(0);
	      __INST(greenShift) = __MKSMALLINT(8);
	      __INST(blueShift) = __MKSMALLINT(16);
	      __INST(bitsPerRGB) = __MKSMALLINT(8);
	      __INST(bitsRed) = __INST(bitsGreen) = __INST(bitsBlue) = __MKSMALLINT(8);
	      __INST(redMask) = __MKSMALLINT(0xFF);
	      __INST(greenMask) = __MKSMALLINT(0xFF00);
	      __INST(blueMask) = __MKSMALLINT(0xFF0000);
	    }
	}
    } else {
	val = GetDeviceCaps(__rootDC, SIZEPALETTE); /* First two entries are black and white. */
	// console_printf("SizeofPalette %d\n",val);
	__INST(ncells) = __MKSMALLINT(val);
	__INST(blackpixel) = __MKSMALLINT(0);
	__INST(whitepixel) = __MKSMALLINT(1);
	__INST(hasColors) = true;
	__INST(hasGreyscales) = true;
	// __INST(usingSystemPalette) = true;

	__INST(redShift) = __MKSMALLINT(0);
	__INST(greenShift) = __MKSMALLINT(2);
	__INST(blueShift) = __MKSMALLINT(4);
	__INST(bitsPerRGB) = __MKSMALLINT(2);
	__INST(bitsRed) = __INST(bitsGreen) = __INST(bitsBlue) = __MKSMALLINT(2);
	__INST(redMask) = __MKSMALLINT(0x3);
	__INST(greenMask) = __MKSMALLINT(0xc);
	__INST(blueMask) = __MKSMALLINT(0x30);
    }
#endif /* ! ALWAYSTRUECOLOR */
%}
!

initializeVariableSettingsProperties
    "fetch properties which can be changed via the user settings.
     Invoked initially and as a result of the settingsChange event."

%{
    UINT multiClickTime;

    multiClickTime = GetDoubleClickTime();
    DPRINTF(("multiClickTime = %d\n", multiClickTime));
    __INST(multiClickTimeDelta) = __MKSMALLINT(multiClickTime);
%}
!

primInitializeFor:stationNameOrNil
    "Initialize the receiver for a connection to given window station. 
     It the argument `stationNameOrNil` is nil, then it connects
     to process default window station. 

     Return an external address for window station handle or nil if
     requested window station is not an interactive one (i.e, one
     cannot initialize Win32Workstation on non-interactive window 
     station).

     See https://msdn.microsoft.com/en-us/library/windows/desktop/ms687096(v=vs.85).aspx
     "

     | errcode |

%{
    HWINSTA station;
    if (stationNameOrNil == nil) {
        station = GetProcessWindowStation();
        if (station == NULL) {
            errcode = __MKINT( GetLastError() );
            goto err;
        }
        /*
         * Check we're connected to "WinSta0" station, only this
         * one is interactive one.
         */
        char stationName[8];
        int  stationNameLen;
        if ( GetUserObjectInformation ( station, UOI_NAME, stationName, 9, &stationNameLen) ) {
            if (strncmp(stationName, "WinSta0", 8) == 0) {
                RETURN ( __MKEXTERNALADDRESS ( station ) );        
            }         
        }    
        RETURN ( nil );

    } else if (__isStringLike( stationNameOrNil)) {
        if (strncmp(__stringVal(stationNameOrNil), "WinSta0", 8) == 0) {
            /* 
             * We're explicitly asked to connect to "WinSta0" station. 
             * This could be hand for example when Smalltalk is running as
             * a service on non-interactive session and want to open 
             * a window to inform user. Maybe, maybe not. Anyway, do our best
             * here.
             */
            station = OpenWindowStation("WinSta0", TRUE, NULL);
            if (station == NULL) {
                errcode = __MKINT( GetLastError() );
                goto err;
            }
            if ( ! SetProcessWindowStation(station) ) {
                errcode = __MKINT( GetLastError() );
                goto err;            
            }
            RETURN ( __MKEXTERNALADDRESS ( station ) );        
        }
        RETURN ( nil );
    }
    err:;
%}.
    self primitiveFailed: errcode

!

reinitialize
    rootWin := rootDC := nil.
    super reinitialize.
! !

!WinWorkstation methodsFor:'keyboard mapping'!

altModifierMask
    "return the mask (in motionEvents) for the alt-key modifier.
     Notice: ST/X may use the left ALT key as CMD/Meta key,
     therefore return a variable here, which can be changed during startup."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(AltMask));
%}

    "Created: 23.3.1996 / 12:43:22 / cg"
    "Modified: 23.3.1996 / 12:44:56 / cg"
!

leftAltMask
    "return the mask bit for the left Alt modifier key.
     See comment in altModifierMask: / metaModifierMask: for what
     this could be used."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(LeftAltMask));
%}
!

metaModifierMask
    "return the mask (in motionEvents) for the meta-key modifier.
     Notice: ST/X may use the left ALT key as CMD/Meta key,
     therefore return a variable here, which can be changed during startup."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(MetaMask));
%}

    "Created: 23.3.1996 / 12:43:39 / cg"
    "Modified: 23.3.1996 / 12:45:09 / cg"
!

modifierMapping
    "Get the Modifier Mapping.
     We return an array of arrays of keycodes"

    ^ nil
!

rightAltMask
    "return the mask bit for the right Alt modifier key.
     See comment in altModifierMask: / metaModifierMask: for what
     this could be used."

%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(RightAltMask));
%}
!

stringFromKeycode:code
    "Get a KeySymbol (a smalltalk symbol) from the keycode."

    ^ ''

    "
	Display stringFromKeycode:28
    "
! !

!WinWorkstation methodsFor:'misc'!

beep
    "output an audible beep"

    self beep:#iconExclamation volume:100.

    "
      Display beep
    "
!

beep:aSymbolOrInteger volume:volumeInPercent
    "output an audible beep, aSymbolOrInteger define, which sound is used.
     Volume is ignored here (kept for compatibility with XWorkstation"

    UserPreferences current beepEnabled ifFalse:[^ self].

%{
    unsigned int type;

    if (__isSmallInteger(aSymbolOrInteger)) {
	type = __smallIntegerVal(aSymbolOrInteger);
    } else if (aSymbolOrInteger == @symbol(iconAsterisk)) {
	type = MB_ICONASTERISK;
    } else if (aSymbolOrInteger == @symbol(iconExclamation)) {
	type = MB_ICONEXCLAMATION;
    } else if (aSymbolOrInteger == @symbol(iconHand)) {
	type = MB_ICONHAND;
    } else if (aSymbolOrInteger == @symbol(iconQuestion)) {
	type = MB_ICONQUESTION;
    } else if (aSymbolOrInteger == @symbol(ok)) {
	type = MB_OK;
    } else {
	type = 0xffffffff;
    }

#ifdef BEEP_IN_WINTHREAD
    PostThreadMessage(_dispatchThreadId, WM_THREAD_BEEP, 0, 0);
#else
    MessageBeep(type);
#endif
%}

    "
      Display beep:#iconExclamation volume:100
      Display beep:#iconAsterisk volume:100
      Display beep:#iconQuestion volume:100
      Display beep:#iconHand volume:100
      Display beep:#ok volume:100
      Display beep:nil volume:100
      Display beep:0 volume:100
    "
!

canEndSession:aBoolean
    "if set to false, Windows is not allowed to finish this session.
     The default is true."

    CanEndSession := aBoolean.
!

flush
    "send all buffered drawing to the display.
     This may be required to make certain, that all previous operations
     are really sent to the display before continuing. For example,
     after a cursor-change with a followup long computation.
     (otherwise, the cursor change request may still be in the output buffer)
     See also #sync, which even waits until the request has been processed."

%{  /* NOCONTEXT */
     GdiFlush();
%}
!

monitorHandleForPoint:aPoint
    "given a point, return a handle to the monitor"

    |pX pY|

    pX := aPoint x.
    pY := aPoint y.
%{
    if (__bothSmallInteger(pX, pY)) {
	POINT p;
	HMONITOR hMonitor;
	p.x = __intVal(pX);
	p.y = __intVal(pY);
#if 0
	/* the following is only needed when we want
	 * to support very old NT/W95/W98 systems; we don't !
	 */
	static HMONITOR (__stdcall *P_MonitorFromPoint)(POINT, int);

	if (P_MonitorFromPoint == 0) {
	    HINSTANCE hUser = LoadLibrary("user32.dll");
	    // console_printf("hUser: %x\n", hUser);
	    if (hUser) {
		P_MonitorFromPoint = (HMONITOR (__stdcall *)(POINT, int ))
				    GetProcAddress(hUser, "MonitorFromPoint");
	    }
	}
	// console_printf("P_MonitorFromPoint: %x\n", P_MonitorFromPoint);

	hMonitor = (*P_MonitorFromPoint)(p, MONITOR_DEFAULTTONULL);
#else
	hMonitor = MonitorFromPoint(p, MONITOR_DEFAULTTONULL);
#endif
	if (hMonitor == 0) {
	    RETURN(nil);
	}
	RETURN ( __MKEXTERNALADDRESS(hMonitor) );
    }
%}
    "
     Screen current monitorHandleForPoint:(0@0)
     Screen current monitorHandleForPoint:(1500@0)
     Screen current monitorHandleForPoint:(3000@0)
     Screen current monitorHandleForPoint:(Display pointFromUser)
    "
!

monitorHandleForView:aWindowId
    "given a window ID, return a handle to the monitor"

%{
    if (__isExternalAddress(aWindowId)) {
	HWND hWnd = _HWNDVal(aWindowId);
	HMONITOR hMonitor;
#if 0
	/* the following is only needed when we want
	 * to support very old NT/W95/W98 systems; we don't !
	 */
	static HMONITOR (__stdcall *P_MonitorFromWindow)(HWND, int);

	if (P_MonitorFromWindow == 0) {
	    HINSTANCE hUser = LoadLibrary("user32.dll");
	    // console_printf("hUser: %x\n", hUser);
	    if (hUser) {
		P_MonitorFromWindow = (HMONITOR (__stdcall *)(HWND, int ))
				    GetProcAddress(hUser, "MonitorFromWindow");
	    }
	}
	// console_printf("P_MonitorFromWindow: %x\n", P_MonitorFromWindow);
	hMonitor = (*P_MonitorFromWindow)(hWnd, MONITOR_DEFAULTTONULL);
#else
	hMonitor = MonitorFromWindow(hWnd, MONITOR_DEFAULTTONULL);
#endif
	if (hMonitor == 0) {
	    RETURN(nil);
	}
	RETURN ( __MKEXTERNALADDRESS(hMonitor) );
    }
%}
    "
     Screen current monitorHandleForView:(Transcript topView id)
     Screen current monitorHandleForPoint:(0@0)
    "
!

monitorHandles
    "retrieve a list of monitor handles"

    |handleArray|

    handleArray := Array new:(self numberOfMonitors).
%{
    struct EnumDisplayMonitorsProcData data;

    data.hArray = handleArray;
    data.index = 0;
    EnumDisplayMonitors(NULL, NULL, EnumDisplayMonitorsProc, (INT)&data);
%}.
    ^ handleArray

    "
     Screen default monitorHandles
    "

    "Modified (comment): / 28-01-2012 / 10:26:55 / cg"
!

setInputFocusTo:aWindowId
    self setInputFocusTo:aWindowId revertTo:nil
!

setInputFocusTo:aWindowId revertTo:revertSymbol
    "set the focus to the view as defined by aWindowId.
     Passing nil set the focus to no window and lets the display discard all
     input until a new focus is set.
     RevertSymbol specifies what should happen if the view becomes invisible;
     passing one of #parent, #root or nil specifies that the focus should be
     given to the parent view, the root view or no view."

%{
    if (__isExternalAddress(aWindowId)) {
	HWND hWnd = _HWNDVal(aWindowId);
	int r = 0;

	if (revertSymbol == @symbol(parent)) {
	    r = 1;
	} else if (revertSymbol == @symbol(root)) {
	    r = 2;
	}
	if (hWnd) {
	    if (GetFocus() != hWnd) {
		DPRINTFIF(__debug_WM_FOCUS__ , ("setInputFocusTo %x revertTo %d\n",hWnd,r));
#ifdef SET_FOCUS_IN_WINTHREAD
		PostMessage(hWnd, WM_THREAD_SETFOCUS, (INT)hWnd, GetCurrentThreadId());
#else
		if (SetFocus(hWnd) == 0) {
		    PRINTF(("SetFocus to %x failed.\n",hWnd));
		}
#endif
	    } else {
		CPRINTF(("setInputFocusTo %x revertTo %d\n",hWnd,r));
	    }
	}
	RETURN ( self );
    }
%}
! !

!WinWorkstation methodsFor:'native dialogs'!

nativeConfirm:aString title:titleString flags:flags initialAnswer:trueOrFalse
     ^ self
	    nativeMessageBoxFor:nil
	    text:aString asString string
	    title:titleString
	    flags:flags
	    blocking:false

     "
      Screen current
	nativeConfirm:'please confirm'
	title:'Confirm'
	flags:#( APPLMODAL ICONQUESTION OKCANCEL)
	initialAnswer:true
     "
     "
      Screen current
	nativeConfirm:'Yes or No'
	title:'Confirm'
	flags:#( APPLMODAL ICONQUESTION YESNO)
	initialAnswer:true
     "

    "Modified: / 02-03-2007 / 15:37:57 / cg"
    "Modified: / 24-08-2010 / 16:17:29 / sr"
!

nativeConfirmOKCancel:aString title:titleString initialAnswer:trueOrFalse
     ^ (self
	    nativeConfirm:aString
	    title:titleString
	    flags:#( APPLMODAL ICONQUESTION OKCANCEL)
	    initialAnswer:trueOrFalse) == #IDOK

     "
      Screen current
	nativeConfirmOKCancel:'please confirm' title:'Confirm' initialAnswer:true
     "

    "Modified: / 02-03-2007 / 15:37:32 / cg"
!

nativeConfirmYesNo:aString title:titleString initialAnswer:trueOrFalse
     ^ (self
	    nativeConfirm:aString
	    title:titleString
	    flags:#( APPLMODAL ICONQUESTION YESNO)
	    initialAnswer:trueOrFalse) == #IDYES

     "
      Screen current
	nativeConfirmYesNo:'please confirm' title:'Confirm' initialAnswer:true
     "

    "Modified: / 02-03-2007 / 15:12:49 / cg"
!

nativeFileDialogFor:ownerId save:isSaveDialog title:titleOrNil inDirectory:dirPathOrNil
	     initialAnswer:initialOrNil
	     filter:filterArrayOrNil extension:extensionOrNil

    "start a native open-file dialog.
     If not cancelled, the selected fileName is returned; nil otherwise.
     Of course, this one looks like the
     Windows file dialog - no matter which viewStyle settings are active.
     Notice: if no ownerId is given, the dialog pops up at 0@0.
     filterArrayOrNil: if non nil, must be an array of 2-element arrays,
		       each element specifying filter commnet and filter
		       i.e. #( 'bitmap files (*.bmp)' '*.bmp' )
		       i.e. #( 'smalltalk files' '*.st' )

     EXPERIMENTAL & non-portable: use with caution"

    |flags|

    isSaveDialog ifTrue:[
	flags := #(
			#ENABLESIZING
			#HIDEREADONLY
			#EXPLORER
			#ENABLESIZING
			#OVERWRITEPROMPT
			#NOCHANGEDIR
		  )
    ] ifFalse:[
	flags := #(
			#ENABLESIZING
			#HIDEREADONLY
			#EXPLORER
			#ENABLESIZING
			#NOCHANGEDIR
		  )
    ].

    ^ self
	nativeFileDialogFor:ownerId
	save:isSaveDialog
	title:titleOrNil
	inDirectory:dirPathOrNil
	initialAnswer:initialOrNil
	flags:flags
	filter:filterArrayOrNil
	extension:extensionOrNil
	blocking:false

    "
     Display
	nativeFileDialogFor:nil save:false
	title:'Test OpenFile Dialog'
	inDirectory:nil
	initialAnswer:nil
	filter:nil
	extension:nil

     Display
	nativeFileDialogFor:nil save:true
	title:'Test SaveFile Dialog'
	inDirectory:nil
	initialAnswer:nil
	filter:nil
	extension:nil

     Display
	nativeFileDialogFor:nil save:true
	title:'Test SaveFile Dialog'
	inDirectory:nil
	initialAnswer:'newFile.bmp'
	filter:nil
	extension:'bmp'

     Display
	nativeFileDialogFor:nil save:false
	title:'Test OpenFile Dialog'
	inDirectory:nil
	initialAnswer:nil
	filter:#(
		    #( 'all files'       '*.*' )
		    #( 'smalltalk files' '*.st' )
		    #( 'change files'    '*.chg' )
		    #( 'image files'     '*.img' )
		)
	extension:nil
    "

    "Modified: / 26-10-2010 / 17:08:04 / cg"
!

nativeFileDialogFor:ownerId save:isSaveDialog title:titleOrNil inDirectory:dirPathOrNil
	     initialAnswer:initialOrNil flags:flagArray
	     filter:filterArrayOrNil extension:extensionOrNil
	     blocking:blocking

    "start a native open-file dialog.
     If not cancelled, the selected fileName is returned; nil otherwise.
     Of course, this one looks like the
     Windows file dialog - no matter which viewStyle settings are active.
     Notice: if no ownerId is given, the dialog pops up at 0@0.
     filterArrayOrNil: if non nil, must be an array of 2-element arrays,
		       each element specifying filter commnet and filter
		       i.e. #( 'bitmap files (*.bmp)' '*.bmp' )
		       i.e. #( 'smalltalk files' '*.st' )

     EXPERIMENTAL & non-portable: use with caution"

    |rslt errorCode fileName|

%{  /* STACK: 32000*/

#ifndef NO_NATIVE_DIALOGS
    OPENFILENAME ofn;
    HWND hWndOwner = NULL;
    char fileNameBuffer[256] = "\0";
    char filterBuffer[1024*4] = "\0";
    BOOL __rslt;
    jmp_buf exitJmpBuf;
    extern void __setAtExitLongJmp(jmp_buf);

    if (__isExternalAddress(ownerId)) {
	hWndOwner = _HWNDVal(ownerId);
    }

# ifdef OPENFILENAME_SIZE_VERSION_400
    ofn.lStructSize = OPENFILENAME_SIZE_VERSION_400; // sizeof(ofn);
# else
    ofn.lStructSize = sizeof(ofn);
# endif
    ofn.hwndOwner = hWndOwner;
    ofn.hInstance = NULL;

    if ((filterArrayOrNil != nil) && __isArrayLike(filterArrayOrNil)) {
	char *dst = filterBuffer;
	unsigned int idx;

	for (idx=0; idx<__arraySize(filterArrayOrNil); idx++) {
	    OBJ el = __ArrayInstPtr(filterArrayOrNil)->a_element[idx];
// console_printf("idx = %d\n", idx);
	    if (__isArrayLike(el) && (__arraySize(el) == 2)) {
		OBJ descr, filter;

		descr = __ArrayInstPtr(el)->a_element[0];
		filter = __ArrayInstPtr(el)->a_element[1];
		if (__isStringLike(descr) && __isStringLike(filter)) {
		    char *src = __stringVal(descr);

// console_printf("descr: %s filter: %s\n", __stringVal(descr), __stringVal(filter));

		    // append (incl 0-byte)
		    while (*src) {
			*dst++ = *src++;
		    }
		    *dst++ = '\0';

		    src = __stringVal(filter);
		    // append (incl 0-byte)
		    while (*src) {
			*dst++ = *src++;
		    }
		    *dst++ = '\0';
		}
	    }
	}
	*dst++ = '\0';
	*dst = '\0';
	ofn.lpstrFilter = filterBuffer;
	ofn.nFilterIndex = 1;
    } else {
	ofn.lpstrFilter = NULL;
	ofn.nFilterIndex = 0;
    }
    ofn.lpstrCustomFilter = NULL;
    ofn.nMaxCustFilter = 0;

    if (__isStringLike(initialOrNil)) {
	strcpy(fileNameBuffer, __stringVal(initialOrNil));
    }
    ofn.lpstrFile = fileNameBuffer;
    ofn.nMaxFile = sizeof(fileNameBuffer);

    ofn.lpstrFileTitle = NULL;
    ofn.nMaxFileTitle = 0;
    if (__isStringLike(dirPathOrNil)) {
	ofn.lpstrInitialDir = __stringVal(dirPathOrNil);
    } else {
	ofn.lpstrInitialDir = NULL;
    }

    if (__isStringLike(titleOrNil)) {
	ofn.lpstrTitle = __stringVal(titleOrNil);
    } else {
	ofn.lpstrTitle = "";
    }
    ofn.nFileOffset = 0;
    ofn.nFileExtension = 0;
    if (__isStringLike(extensionOrNil)) {
	ofn.lpstrDefExt = __stringVal(extensionOrNil);
    } else {
	ofn.lpstrDefExt = NULL;
    }

    ofn.lCustData = (INT)NULL;
    ofn.lpfnHook = NULL;
    ofn.lpTemplateName = NULL;

    ofn.Flags = 0;
    if (__isNonNilObject(flagArray) && __isArrayLike(flagArray)) {
	unsigned int i;

	for (i=0; i<__arraySize(flagArray); i++) {
	    OBJ flag = __ArrayInstPtr(flagArray)->a_element[i];
	    int flagVal = 0;

	    if (__isSmallInteger(flag)) {
		flagVal = __intVal(flag);
	    } else if (flag == @symbol(READONLY)) {
		flagVal = OFN_READONLY;
	    } else if (flag == @symbol(OVERWRITEPROMPT)) {
		flagVal = OFN_OVERWRITEPROMPT;
	    } else if (flag == @symbol(HIDEREADONLY)) {
		flagVal = OFN_HIDEREADONLY;
	    } else if (flag == @symbol(NOCHANGEDIR)) {
		flagVal = OFN_NOCHANGEDIR;
	    } else if (flag == @symbol(SHOWHELP)) {
		flagVal = OFN_SHOWHELP;
	    } else if (flag == @symbol(ENABLEHOOK)) {
		flagVal = OFN_ENABLEHOOK;
	    } else if (flag == @symbol(ENABLETEMPLATE)) {
		flagVal = OFN_ENABLETEMPLATE;
	    } else if (flag == @symbol(ENABLETEMPLATEHANDLE)) {
		flagVal = OFN_ENABLETEMPLATEHANDLE;
	    } else if (flag == @symbol(NOVALIDATE)) {
		flagVal = OFN_NOVALIDATE;
	    } else if (flag == @symbol(ALLOWMULTISELECT)) {
		flagVal = OFN_ALLOWMULTISELECT;
	    } else if (flag == @symbol(EXTENSIONDIFFERENT)) {
		flagVal = OFN_EXTENSIONDIFFERENT;
	    } else if (flag == @symbol(PATHMUSTEXIST)) {
		flagVal = OFN_PATHMUSTEXIST;
	    } else if (flag == @symbol(FILEMUSTEXIST)) {
		flagVal = OFN_FILEMUSTEXIST;
	    } else if (flag == @symbol(CREATEPROMPT)) {
		flagVal = OFN_CREATEPROMPT;
	    } else if (flag == @symbol(SHAREAWARE)) {
		flagVal = OFN_SHAREAWARE;
	    } else if (flag == @symbol(NOREADONLYRETURN)) {
		flagVal = OFN_NOREADONLYRETURN;
	    } else if (flag == @symbol(NOTESTFILECREATE)) {
		flagVal = OFN_NOTESTFILECREATE;
	    } else if (flag == @symbol(NONETWORKBUTTON)) {
		flagVal = OFN_NONETWORKBUTTON;
	    } else if (flag == @symbol(NOLONGNAMES)) {
		flagVal = OFN_NOLONGNAMES;
# ifdef OFN_EXPLORER
	    } else if (flag == @symbol(EXPLORER)) {
		flagVal = OFN_EXPLORER;
# endif
# ifdef OFN_NODEREFERENCELINKS
	    } else if (flag == @symbol(NODEREFERENCELINKS)) {
		flagVal = OFN_NODEREFERENCELINKS;
# endif
# ifdef OFN_LONGNAMES
	    } else if (flag == @symbol(LONGNAMES)) {
		flagVal = OFN_LONGNAMES;
# endif
# ifdef OFN_ENABLEINCLUDENOTIFY
	    } else if (flag == @symbol(ENABLEINCLUDENOTIFY)) {
		flagVal = OFN_ENABLEINCLUDENOTIFY;
# endif
# ifdef OFN_ENABLESIZING
	    } else if (flag == @symbol(ENABLESIZING)) {
		flagVal = OFN_ENABLESIZING;
# endif
	    }
	    ofn.Flags |= flagVal;
	}
    }

    if (isSaveDialog == true) {
	if (blocking == true) {
	    __rslt = GetSaveFileName(&ofn);
	} else {
	    do {
		__threadErrno = 0;
		__rslt = (BOOL)((INT) __STX_API_CALL1( "GetSaveFileName", (voidFUNC)GetSaveFileName, (void *)(&ofn)));
	    } while ((__rslt < 0) && (__threadErrno == EINTR));
	}
    } else {
	if (blocking == true) {
	    __rslt = GetOpenFileName(&ofn);
	} else {
	    do {
		__threadErrno = 0;
		__rslt = (BOOL)((INT) __STX_API_CALL1( "GetOpenFileName", (voidFUNC)GetOpenFileName, (void *)(&ofn)));
	    } while ((__rslt < 0) && (__threadErrno == EINTR));
	}
    }

    if ( @global(WinWorkstation:VerboseNativeDialogs) == true) {
	console_fprintf(stderr, "WinWorkstation [info]: after GetOpenFileName\n");
    }

    if (setjmp(exitJmpBuf)) {
	__setAtExitLongJmp(0);
	if ( @global(WinWorkstation:VerboseNativeDialogs) == true) {
	    console_fprintf(stderr, "WinWorkstation [warning]: exit longjmp\n");
	}
	rslt = false;
	errorCode = __MKSMALLINT(0);
	goto getOutOfHere;
    }
    __setAtExitLongJmp(exitJmpBuf);

    if (__rslt == TRUE) {
	rslt = true;
	fileName = __MKSTRING(fileNameBuffer);
    } else {
	rslt = false;
	errorCode = __MKSMALLINT(CommDlgExtendedError());
    }
    __setAtExitLongJmp(0);

#else
    errorCode = __MKSMALLINT(-1);
#endif /* NO_NATIVE_DIALOGS */
getOutOfHere: ;
%}.
    (errorCode notNil) ifTrue:[
	errorCode ~~ 0 ifTrue:[
	    self primitiveFailed.
	].
	^ nil
    ].

    ^ fileName

    "
     Display
	nativeFileDialogFor:nil save:false
	title:'Test OpenFile Dialog'
	inDirectory:nil
	initialAnswer:nil
	flags:#( ENABLESIZING HIDEREADONLY EXPLORER ENABLESIZING )
	filter:#(
		    #( 'all files'       '*.*' )
		    #( 'smalltalk files' '*.st' )
		    #( 'change files'    '*.chg' )
		    #( 'image files'     '*.img' )
		)
	extension:nil
	blocking:false
    "

    "
     Display
	nativeFileDialogFor:nil save:false
	title:'Test OpenFile Dialog'
	inDirectory:nil
	initialAnswer:nil
	flags:#( ENABLESIZING HIDEREADONLY EXPLORER ENABLESIZING )
	filter:#(
		    #( 'all files'       '*.*' )
		    #( 'smalltalk files' '*.st' )
		    #( 'change files'    '*.chg' )
		    #( 'image files'     '*.img' )
		)
	extension:nil
	blocking:true
    "
!

nativeGetDefaultPrinterDialog
    "start a native printer dialog.

     EXPERIMENTAL & non-portable: use with caution"

    |errorCode newDCHandle|

%{  /* STACK: 32000*/

#ifdef NO_NATIVE_DIALOGS
# define NO_NATIVE_PRINT_DIALOGS
#endif

#define NO_NATIVE_PRINT_DIALOGS

#ifndef NO_NATIVE_PRINT_DIALOGS
    PRINTDLG pdsetup;
    OBJ newGCHandle;

    memset(&pdsetup, 0, sizeof(pdsetup));
    pdsetup.lStructSize = sizeof(pdsetup);
    pdsetup.Flags = PD_RETURNDEFAULT | PD_RETURNDC;
    if (! PrintDlg(&pdsetup)) {
	RETURN (nil);
    }
    if ( pdsetup.hDC ) {
	newDCHandle = __MKOBJ( pdsetup.hDC );
    }
#else
    errorCode = __MKSMALLINT(-1);
#endif /* NO_NATIVE_PRINT_DIALOGS */
%}.
    (errorCode notNil) ifTrue:[
	self primitiveFailed.
	^ nil
    ].

    ^ newDCHandle

    "
     Display nativeGetDefaultPrinterDialog
    "
!

nativeGetPrinterDialogDefault:defaultBoolean
    "start a native printer dialog.

     EXPERIMENTAL & non-portable: use with caution"

    |errorCode newDCHandle|

%{  /* STACK: 32000*/

#ifdef NO_NATIVE_DIALOGS
# define NO_NATIVE_PRINT_DIALOGS
#endif

#define xxNO_NATIVE_PRINT_DIALOGS

#ifndef NO_NATIVE_PRINT_DIALOGS
    PRINTDLG pdsetup;
    OBJ newGCHandle;
    int answer;

    memset(&pdsetup, 0, sizeof(pdsetup));
    pdsetup.lStructSize = sizeof(pdsetup);
    pdsetup.Flags = PD_RETURNDC;
    if (defaultBoolean == true) {
	pdsetup.Flags |= PD_RETURNDEFAULT;
    }
# ifdef BLOCKING
    answer = PrintDlg(&pdsetup);
# else
    answer = __STX_API_CALL1( "PrintDlg",
					(voidFUNC)PrintDlg,
					(void *)&pdsetup );
# endif
    if (! answer) {
	RETURN (nil);
    }
    if ( pdsetup.hDC ) {
	newDCHandle = __MKOBJ( pdsetup.hDC );
    }
#else
    errorCode = __MKSMALLINT(-1);
#endif /* NO_NATIVE_PRINT_DIALOGS */
%}.
    (errorCode notNil) ifTrue:[
	self primitiveFailed.
	^ nil
    ].

    ^ newDCHandle

    "
     Display nativeGetPrinterDialogDefault:true
     Display nativeGetPrinterDialogDefault:false
    "
!

nativeInformationOK:aString title:titleString
     ^ self
	    nativeConfirm:aString
	    title:titleString
	    flags:#( APPLMODAL ICONINFORMATION OK)
	    initialAnswer:nil

     "
      Screen current
	nativeInformationOK:'Some Info' title:'Info'
     "

    "Modified: / 02-03-2007 / 15:37:40 / cg"
!

nativeMessageBoxFor:ownerId text:textOrNil title:titleOrNil flags:flagArray blocking:blocking
    "start a native message box dialog.

     EXPERIMENTAL & non-portable: use with caution"

    |errorCode answer|

%{  /* STACK: 32000*/

#ifndef NO_NATIVE_DIALOGS
    HWND hWndOwner = NULL;
    int boxFlags = 0;
    char *__title;
    char *__text;
    INT __answer;

    if (__isExternalAddress(ownerId)) {
	hWndOwner = _HWNDVal(ownerId);
    }
    if (__isStringLike(titleOrNil)) {
	__title = __stringVal(titleOrNil);
    } else {
	__title = "";
    }
    if (__isStringLike(textOrNil)) {
	__text = __stringVal(textOrNil);
    } else {
	__text = "";
    }

    if (__isNonNilObject(flagArray) && __isArrayLike(flagArray)) {
	unsigned int i;

	for (i=0; i<__arraySize(flagArray); i++) {
	    OBJ flag = __ArrayInstPtr(flagArray)->a_element[i];
	    int flagVal = 0;

	    if (__isSmallInteger(flag)) {
		flagVal = __intVal(flag);
	    } else if (flag == @symbol(ABORTRETRYIGNORE)) {
		flagVal = MB_ABORTRETRYIGNORE;
	    } else if (flag == @symbol(APPLMODAL)) {
		flagVal = MB_APPLMODAL;
	    } else if (flag == @symbol(DEFAULT_DESKTOP_ONLY)) {
		flagVal = MB_DEFAULT_DESKTOP_ONLY;
	    } else if (flag == @symbol(DEFBUTTON1)) {
		flagVal = MB_DEFBUTTON1;
	    } else if (flag == @symbol(DEFBUTTON2)) {
		flagVal = MB_DEFBUTTON2;
	    } else if (flag == @symbol(DEFBUTTON3)) {
		flagVal = MB_DEFBUTTON3;
	    } else if (flag == @symbol(ICONASTERISK)) {
		flagVal = MB_ICONASTERISK;
	    } else if (flag == @symbol(ICONHAND)) {
		flagVal = MB_ICONHAND;
	    } else if (flag == @symbol(ICONINFORMATION)) {
		flagVal = MB_ICONINFORMATION;
	    } else if (flag == @symbol(ICONQUESTION)) {
		flagVal = MB_ICONQUESTION;
	    } else if (flag == @symbol(ICONSTOP)) {
		flagVal = MB_ICONSTOP;
	    } else if (flag == @symbol(OK)) {
		flagVal = MB_OK;
	    } else if (flag == @symbol(OKCANCEL)) {
		flagVal = MB_OKCANCEL;
	    } else if (flag == @symbol(RETRYCANCEL)) {
		flagVal = MB_RETRYCANCEL;
	    } else if (flag == @symbol(SETFOREGROUND)) {
		flagVal = MB_SETFOREGROUND;
	    } else if (flag == @symbol(SYSTEMMODAL)) {
		flagVal = MB_SYSTEMMODAL;
	    } else if (flag == @symbol(TASKMODAL)) {
		flagVal = MB_TASKMODAL;
	    } else if (flag == @symbol(YESNO)) {
		flagVal = MB_YESNO;
	    } else if (flag == @symbol(YESNOCANCEL)) {
		flagVal = MB_YESNOCANCEL;
	    }
	    boxFlags |= flagVal;
	}
    }

    if (blocking == true) {
	__answer = MessageBox(hWndOwner,
			      __text,
			      __title,
			      boxFlags);
    } else {
	do {
	    __threadErrno = 0;
	    __answer = (INT) __STX_API_CALL4(
					"MessageBox",
					(voidFUNC)MessageBox,
					(void *)hWndOwner,
					(void *)__text,
					(void *)__title,
					(void *)((INT)boxFlags));
	} while ((__answer < 0) && (__threadErrno == EINTR));
    }

    switch (__answer) {
	case IDABORT:
	    answer = @symbol(IDABORT);
	    break;
	case IDCANCEL:
	    answer = @symbol(IDCANCEL);
	    break;
	case IDIGNORE:
	    answer = @symbol(IDIGNORE);
	    break;
	case IDNO:
	    answer = @symbol(IDNO);
	    break;
	case IDOK:
	    answer = @symbol(IDOK);
	    break;
	case IDRETRY:
	    answer = @symbol(IDRETRY);
	    break;
	case IDYES:
	    answer = @symbol(IDYES);
	    break;
	default:
	    answer = __MKSMALLINT(__answer);
	    break;
    }
#else
    errorCode = __MKSMALLINT(-1);
#endif /* NO_NATIVE_DIALOGS */
%}.
    (errorCode notNil) ifTrue:[
	self primitiveFailed.
	^ nil
    ].

    ^ answer

    "
     Display
	nativeMessageBoxFor:nil
	text:'Hello world'
	title:'Message'
	flags:#( OK APPLMODAL ICONSTOP )
	blocking:true

     Display
	nativeMessageBoxFor:nil
	text:'Hello world'
	title:'Message'
	flags:#( OK APPLMODAL ICONSTOP )
	blocking:false

     Display
	nativeMessageBoxFor:nil
	text:'Hello world'
	title:'Message'
	flags:#( ABORTRETRYIGNORE ICONSTOP )
	blocking:false
    "
!

nativeWarnOK:aString title:titleString
     ^ self
	    nativeConfirm:aString
	    title:titleString
	    flags:#( APPLMODAL ICONSTOP OK)
	    initialAnswer:nil

     "
      Screen current
	nativeWarnOK:'some warning' title:'Warning'
     "

    "Modified: / 02-03-2007 / 15:37:47 / cg"
! !

!WinWorkstation methodsFor:'native widget support'!

nativeDialogs
    ^ NativeDialogs ? false
!

nativeDialogs:aBoolean
    "enable / disable use of native dialogs.
     This is an experimental, unfinished, unsupported feature.
     For now, this only affects some file-, warning-, information and confirmation dialogs."

    NativeDialogs := aBoolean

    "
     Screen current nativeDialogs:true
     Screen current nativeDialogs:false
    "
!

nativeFileDialogs
    ^ NativeFileDialogs ? false

    "Created: / 24-08-2010 / 16:41:13 / sr"
!

nativeFileDialogs:aBoolean
    "enable / disable use of native file dialogs.
     This is an experimental, unfinished, unsupported feature.
     For now, this only affects some file dialogs."

    NativeFileDialogs := aBoolean

    "
     Screen current nativeFileDialogs:true
     Screen current nativeFileDialogs:false
    "

    "Created: / 24-08-2010 / 16:41:36 / sr"
!

nativeWidgets
    ^ NativeWidgets ? false
!

nativeWidgets:aBoolean
    "enable / disable use of native widgets.
     This is an experimental, unfinished, unsupported feature.
     For now, this only affects some widgets."

    NativeWidgets := aBoolean

    "
     Screen current nativeWidgets:true
     Screen current nativeWidgets:false
    "
!

supportsNativeDialogs
    ^ true

    "
     Screen current supportsNativeDialogs
    "
!

supportsNativeFileDialogs
    ^ true

    "
     Screen current supportsNativeFileDialogs
    "

    "Created: / 24-08-2010 / 16:28:42 / sr"
!

supportsNativeWidgets
    ^ true

    "
     Screen current supportsNativeWidgets
    "
! !

!WinWorkstation methodsFor:'pointer queries '!

anyButtonStateMask
    "return an integer for masking out any button from a
     buttonStates value."

    "/ should use ``Display buttonXMotionMask bitOr:....''

%{  /* NOCONTEXT */
    RETURN ( __MKSMALLINT(AnyButtonMask) );
%}

    "Modified: 23.3.1996 / 12:41:33 / cg"
    "Created: 23.3.1996 / 12:46:35 / cg"
!

buttonStates
    "return an integer representing the state of the pointer buttons;
     a one-bit in positions 0.. represent a pressed button.
     See the button1Mask/button2Mask/button3Mask,
     shiftMask/controlMask and modifierMask methods for the meaning of the bits."

%{  /* NOCONTEXT */
    int modifiers = 0;
    int b1m = Button1Mask;
    int b3m = Button3Mask;

    if (GetSystemMetrics(SM_SWAPBUTTON)) {
	b3m = Button1Mask;
	b1m = Button3Mask;
    }

    if (GetAsyncKeyState(VK_LBUTTON) & 0x8000)
	modifiers |= b1m;
    if (GetAsyncKeyState(VK_MBUTTON) & 0x8000)
	modifiers |= Button2Mask;
    if (GetAsyncKeyState(VK_RBUTTON) & 0x8000)
	modifiers |= b3m;

    RETURN (__MKSMALLINT(modifiers));
%}

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

%{  /* NOCONTEXT */
    RETURN ( __MKSMALLINT(Button1Mask) );
%}.

    "Modified: 23.3.1996 / 12:41:33 / cg"
!

middleButtonStateMask
    "return an integer for masking out the middle button from a
     buttonStates value"

    "/ should use ``Display button2MotionMask''

%{  /* NOCONTEXT */
    RETURN ( __MKSMALLINT(Button2Mask) );
%}.

    "Modified: 23.3.1996 / 12:41:43 / cg"
!

pointerPosition
    "return the current pointer position in root-window (i.e. screen) coordinates"

%{  /* NOCONTEXT */
    POINT p;

    if (! GetCursorPos(&p)) {
	p.x = 0;
	p.y = 0;
    }
    RETURN (__MKPOINT_INT(p.x, p.y));
%}
!

rightButtonStateMask
    "return an integer for masking out the right button from a
     buttonStates value"

    "/ should use ``Display button3MotionMask''

%{  /* NOCONTEXT */
    RETURN ( __MKSMALLINT(Button3Mask) );
%}.

    "Modified: 23.3.1996 / 12:41:52 / cg"
!

rootPositionOfLastEvent
    "return the position in root-window coordinates
     of the last button, key or pointer event"

%{  /* NOCONTEXT */
    RETURN (__MKPOINT_INT(evRootX, evRootY));
%}
!

setPointerPosition:newPosition
    "change the pointer position in root-window coordinates."

%{  /* NOCONTEXT */
    if (__isPoint(newPosition)) {
	OBJ xpos, ypos;

	xpos = __point_X(newPosition);
	ypos = __point_Y(newPosition);
	if (__bothSmallInteger(xpos, ypos)) {
	    SetCursorPos(__intVal(xpos), __intVal(ypos));
	}
    }
%}
!

setPointerPosition:newPosition in:aWindowId
    "change the pointer position to a new position relative to the
     given windows origin (which may be the rootWindow).
     Be careful with this - its usually not very ergonimically
     to change the mousePointer position.
     This interface is provided for special applications (presentation
     playback) and should not be used in normal applications."

"/    self setCursorPosition:(self translatePoint:newPosition from:aWindowId to:self rootView id).
! !

!WinWorkstation methodsFor:'private error handling'!

textOutFailed
    "mhmh - it seems the we should ignore this error - it sometimes happens when
     writing onto a window with a screen-saver just about to be activated...
     GetLastError is 5"

    "/ self error:'textOut failed'.
! !

!WinWorkstation methodsFor:'retrieving pixels'!

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

    rawInfo := Array new:11.
		  "1 -> bit order"
		  "2 -> depth"
		  "3 -> bytes_per_line"
		  "4 -> byte_order"
		  "5 -> format"
		  "6 -> bitmap_unit"
		  "7 -> bitmap_pad"
		  "8 -> bits_per_pixel"
		  "9 -> red_mask"
		  "10 -> green_mask"
		  "11 -> blue_mask"

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
	info at:#redMask put:(rawInfo at:9).
	info at:#greenMask put:(rawInfo at:10).
	info at:#blueMask put:(rawInfo at:11).
	^ info
    ].
    "
     some error occured - either args are not smallintegers, imageBits is not a ByteArray
     or is too small to hold the bits
    "
    ^ self primitiveFailed
!

getBitsFromPixmapId:aDrawableId x:srcx y:srcy width:w height:h into:imageBits
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

    rawInfo := Array new:11.
		  "1 -> bit order"
		  "2 -> depth"
		  "3 -> bytes_per_line"
		  "4 -> byte_order"
		  "5 -> format"
		  "6 -> bitmap_unit"
		  "7 -> bitmap_pad"
		  "8 -> bits_per_pixel"
		  "9 -> red_mask"
		  "10 -> green_mask"
		  "11 -> blue_mask"

    "/ had to extract the getPixel call into a separate method, to specify
    "/ unlimitedStack (some implementations use alloca and require huge amounts
    "/ of temporary stack space

    (self primGetBitsFromPixmap:aDrawableId x:srcx y:srcy width:w height:h into:imageBits infoInto:rawInfo) ifTrue:[
	info := IdentityDictionary new.
	info at:#bitOrder put:(rawInfo at:1).
	info at:#depth put:(rawInfo at:2).
	info at:#bytesPerLine put:(rawInfo at:3).
	info at:#byteOrder put:(rawInfo at:4).
	info at:#format put:(rawInfo at:5).
	info at:#bitmapUnit put:(rawInfo at:6).
	info at:#bitmapPad put:(rawInfo at:7).
	info at:#bitsPerPixel put:(rawInfo at:8).
	info at:#redMask put:(rawInfo at:9).
	info at:#greenMask put:(rawInfo at:10).
	info at:#blueMask put:(rawInfo at:11).
	^ info
    ].
    "
     some error occured - either args are not smallintegers, imageBits is not a ByteArray
     or is too small to hold the bits
    "
    ^ self primitiveFailed
!

getPixelX:px y:py from:ignoredDrawableId with:aGCId
    "return the pixel value at x/y; coordinates start at 0/0 for the upper left.
     Nil is returned for invalid coordinates or if any other problem arises."

%{  /* NOCONTEXT */
    if (__isExternalAddress(aGCId)
     && __bothSmallInteger(px, py)) {
	struct gcData *gcData = _GCDATA(aGCId);
	HDC hDC;
	int __x = __intVal(px), __y = __intVal(py);
	int pixel;

	hDC = _getDC(gcData);
	pixel = GetPixel(hDC, __x, __y);
#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
	/*
	 * for compatibility, returns the pixelValue
	 * from a monochrome bitmap
	 */
	if (gcData->hBitmap) {
	    if (gcData->bitmapColorBitCount == 1) {
		pixel = (pixel == 0) ? 0 : 1;
	    }
	}

	RETURN ( __MKSMALLINT(pixel & 0xFFFFFF) );
    }
%}.
    ^ nil
!

primGetBitsFrom:aDrawableId x:srcX y:srcY width:w height:h into:imageBits infoInto:info

%{
    int     height, width;
    unsigned int numBytes;
    int     bytesPerRow;
    HWND    hWnd;
    HBITMAP hBitmap = 0;
    HGDIOBJ hPrevious = 0;
    HDC     bDC = 0;
    struct {
	BITMAPINFOHEADER bmiHeader;
	DWORD r;
	DWORD g;
	DWORD b;
    } bitmap;

    if (! __isExternalAddress(aDrawableId)) {
	INFOFPRINTF((stderr, "WinWorkstation [warning]: externalAddress arg\n"));
	goto fail;
    }
    if (! __bothSmallInteger(srcX, srcY)) {
	INFOFPRINTF((stderr, "WinWorkstation [warning]: x,y args\n"));
	goto fail;
    }
    if (! __bothSmallInteger(w, h)) {
	INFOFPRINTF((stderr, "WinWorkstation [warning]: w,h args\n"));
	goto fail;
    }
    if (! __isArray(info)) {
	INFOFPRINTF((stderr, "WinWorkstation [warning]: info arg\n"));
	goto fail;
    }
    if (! __isByteArray(imageBits)) {
	INFOFPRINTF((stderr, "WinWorkstation [warning]: info arg\n"));
	goto fail;
    }

    {
	hWnd = _HWNDVal( aDrawableId );
	BMDPRINTF(("primGetBits %x\n",hWnd));
	if( hWnd != 0 ) {
	    HDC wDC;
	    HANDLE prevBitmap;
	    int widthRoundedUpToNextMultipleOf4 = ((width + 3 ) / 4) * 4;
	    int widthUsed;

	    bDC = CreateCompatibleDC(__rootDC);

	    BMDPRINTF(("primGetBits srcX %d srcY %d w %d h %d\n",__intVal(srcX),__intVal(srcY),__intVal(w),__intVal(h)));
	    height =  __intVal(h);
	    width  =  __intVal(w);

	    widthUsed = widthRoundedUpToNextMultipleOf4;
	    widthUsed = width;

	    BMDPRINTF(("width %d height %d\n",width,height));
	    hBitmap = CreateCompatibleBitmap(__rootDC, widthUsed, height);
	    if (!hBitmap) {
		INFOFPRINTF((stderr, "WinWorkstation [warning]: CreateCompatibleBitmap failed\n"));
		goto fail;
	    }
	    bitmap.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
	    bitmap.bmiHeader.biPlanes = 1;
#ifdef ALWAYSTRUECOLOR
	    bitmap.bmiHeader.biCompression = BI_RGB;
	    bytesPerRow = (((width*3) + 3 ) / 4) * 4;
#else
	    if (__depth == 24) {
		bitmap.bmiHeader.biCompression = BI_RGB;
		bytesPerRow = (((width*3) + 3 ) / 4) * 4;
	    } else if (__depth == 16) {
# if 0
		bitmap.bmiHeader.biCompression = BI_BITFIELDS;
		bitmap.b = 0x001f;
		bitmap.g = 0x07e0;
		bitmap.r = 0xf800;
		bytesPerRow = (((width*2) + 1 ) / 4) * 4;
# else
		bitmap.b = 0;
		bitmap.g = 0;
		bitmap.r = 0;
		bitmap.bmiHeader.biCompression = BI_RGB;
		bytesPerRow = (((width*3) + 3 ) / 4) * 4;
# endif
	    }
#endif /* ALWAYSTRUECOLOR */
	    bitmap.bmiHeader.biSizeImage = 0;
	    bitmap.bmiHeader.biXPelsPerMeter = 0;
	    bitmap.bmiHeader.biYPelsPerMeter = 0;
	    bitmap.bmiHeader.biClrUsed = 0;
	    bitmap.bmiHeader.biClrImportant = 0;
	    bitmap.bmiHeader.biBitCount = __depth;

	    bitmap.bmiHeader.biWidth = widthUsed;
	    bitmap.bmiHeader.biHeight = -height;

	    wDC = GetDC(hWnd);

	    hPrevious = SelectObject(bDC, hBitmap);
	    if (BitBlt(bDC,
		   0,0,
		   width,height,
		   wDC,
		   __intVal(srcX), __intVal(srcY),
		   SRCCOPY|CAPTUREBLT)
		 == 0
		)
	    {
		INFOFPRINTF((stderr, "WinWorkstation [warning]: in primGetBitsFrom: BitBlt\n"));
	    }

#ifdef CACHE_LAST_DC
	    if (lastGcData && (lastGcData->_hDC == wDC)) {
# ifdef DEBUG_DC_REUSE
		console_fprintf(stderr, "WinWorkstation [info]: Oops - dont release - cachedDC reuse\n", __LINE__);
# endif
	    } else
#endif
	    {
#ifdef CACHE_LAST_WM_PAINT_DC
		if (last_wm_paint_dc && (last_wm_paint_dc == wDC)) {
# ifdef DEBUG_DC_REUSE
		    console_fprintf(stderr, "WinWorkstation [info]: Oops - dont release - last_wm_paint_dc reuse\n", __LINE__);
# endif
		} else
#endif
		{
		    ReleaseDC(hWnd, wDC);
		}
	    }

	    if (GetDIBits(bDC,hBitmap,0,height,0,(struct tagBITMAPINFO *)&bitmap,DIB_RGB_COLORS) == 0)
	    {
		INFOFPRINTF((stderr, "WinWorkstation [warning]: noinfo returned in primGetBits\n"));
		goto fail;
	    }
	    BMDPRINTF(("bitmap info:%d %d %d %d\n",
			bitmap.bmiHeader.biWidth, bitmap.bmiHeader.biHeight,
			bitmap.bmiHeader.biBitCount, bitmap.bmiHeader.biSizeImage));
	    numBytes = bitmap.bmiHeader.biSizeImage;
	    if( numBytes != 0 ) {
		if (numBytes > __byteArraySize(imageBits)) {
		    /* imageBits too small */
		    INFOFPRINTF((stderr, "WinWorkstation [warning]: primGetBits - byteArray too small (is:%d need:%d; w:%d h:%d)\n",
				__byteArraySize(imageBits), numBytes,
				bitmap.bmiHeader.biWidth, -bitmap.bmiHeader.biHeight
			     ));
		    goto fail;
		}
		BMDPRINTF(("numBytes %d\n",numBytes));

		bitmap.bmiHeader.biHeight = -height;
		if (GetDIBits(bDC,hBitmap,0,height,__ByteArrayInstPtr(imageBits)->ba_element,(struct tagBITMAPINFO *)&bitmap,DIB_RGB_COLORS) == 0)
		{
		    INFOFPRINTF((stderr, "WinWorkstation [warning]: zero bits returned in primGetBits\n"));
		    goto fail;
		}

		/* swap red and blue (windows delivers BGR) */
		{
		    char *cp = __ByteArrayInstPtr(imageBits)->ba_element;
#ifdef PRE_18_FEB_05
		    int n = numBytes;
		    for ( ;n > 0; n -= 3, cp += 3) {
			  char b = cp[0];
			  cp[0] = cp[2];
			  cp[2] = b;
		    }
#else
		    int _h;
		    char *rowp = cp;

		    for (_h=height; _h>0; _h--) {
			int _w;
			char *pixel = rowp;

			for (_w=width; _w>0; _w--) {
			    char b;

			    b = pixel[0];
			    pixel[0] = pixel[2];
			    pixel[2] = b;
			    pixel += 3;
			};
			rowp += bytesPerRow;
		    };
#endif
		}
	    } else {
		INFOFPRINTF((stderr, "WinWorkstation [warning]: unacceptable bitmap in primGetBits\n"));
		goto fail;
	    }
	} else {
	    INFOFPRINTF((stderr, "WinWorkstation [warning]: unacceptable HWND in primGetBits\n"));
	    goto fail;
	}

	__ArrayInstPtr(info)->a_element[0] = @symbol(msbFirst);                                 // bitOrder
	__ArrayInstPtr(info)->a_element[1] = __MKSMALLINT(1);                                   // depth
	__ArrayInstPtr(info)->a_element[2] = __MKSMALLINT(bytesPerRow);                         // bytesPerLine
	__ArrayInstPtr(info)->a_element[3] = @symbol(msbFirst);                                 // byteOrder
	__ArrayInstPtr(info)->a_element[4] = @symbol(XYPixmap);                                 // format
	__ArrayInstPtr(info)->a_element[5] = __MKSMALLINT(0);                                   // bitmapUnit
	__ArrayInstPtr(info)->a_element[6] = __MKSMALLINT(WIN32PADDING);                        // bitmapPad
	__ArrayInstPtr(info)->a_element[7] = __MKSMALLINT(bitmap.bmiHeader.biBitCount);         // bitsPerPixel
	__ArrayInstPtr(info)->a_element[8] = __MKSMALLINT(0x0000FF);   // redMask
	__ArrayInstPtr(info)->a_element[9] = __MKSMALLINT(0x00FF00);   // greenMask
	__ArrayInstPtr(info)->a_element[10] = __MKSMALLINT(0xFF0000);  // blueMask
	if ((hPrevious != NULL) && (bDC != NULL))
	    SelectObject(bDC, hPrevious);
	if (bDC)
	    DeleteDC(bDC);
	if (hBitmap)
	    _DeleteObject(hBitmap, __LINE__);
	RETURN ( true );
    }
fail: ;
    if ((hPrevious != NULL) && (bDC != NULL))
	SelectObject(bDC, hPrevious);
    if (bDC)
	DeleteDC(bDC);
    if (hBitmap)
	_DeleteObject(hBitmap, __LINE__);
%}.
    ^ false
!

primGetBitsFromPixmap:aDrawableId x:srcX y:srcY width:w height:h into:imageBits infoInto:info

%{
    int            height, width;
    unsigned int   numBytes;
    unsigned char* ep = 0;
    HBITMAP        xBitmap;
    HBITMAP hBitmap = 0;
    HDC bDC = 0;
    HDC xDC = 0;
    struct
    {
	BITMAPINFOHEADER bmiHeader;
	DWORD rgb[2];
    } bitmap;
    BITMAP bitmapInfo;

    if (__isExternalAddress(aDrawableId)
     && __bothSmallInteger(srcX, srcY)
     && __bothSmallInteger(w, h)
     && __isArray(info)
     && __isByteArray(imageBits))
    {
	xBitmap = _HBITMAPVAL( aDrawableId );
	BMDPRINTF(("primGetBitsFromPixmap %x\n",xBitmap));
	if (xBitmap != 0) {
	    xDC = GetDC(0);
	    SelectObject(xDC, xBitmap);
	    GetObject(xBitmap,sizeof(bitmapInfo),&bitmapInfo);

	    bDC = CreateCompatibleDC(__rootDC);
	    BMDPRINTF(("srcX %d srcY %d w %d h %d\n",__intVal(srcX),__intVal(srcY),__intVal(w),__intVal(h)));
	    height =  __intVal(h);
	    width  =  __intVal(w);
	    BMDPRINTF(("width %d height %d\n",width,height));

	    hBitmap = CreateCompatibleBitmap(xDC, width, height);
	    if (!hBitmap)
		goto fail;

	    SelectObject(bDC,hBitmap);
	    if (BitBlt(bDC,
		   0,0,
		   width,height,
		   xDC,
		   __intVal(srcX), __intVal(srcY),
		   SRCCOPY)
		 == 0
		)
	    {
		 BMDPRINTF(("ERROR in primGetBitsFromPixmap: BitBlt\n"));
		 goto fail;
	    }
	    bitmap.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
	    bitmap.bmiHeader.biPlanes = 1;
#ifdef ALWAYSTRUECOLOR
	    bitmap.bmiHeader.biCompression = BI_RGB;
#else
	    if (__depth == 24) {
		/*bitmap.bmiHeader.biCompression = BI_BITFIELDS;
		bitmap.r = 0xff0000;
		bitmap.g = 0x00ff00;
		bitmap.b = 0x0000ff;*/
		bitmap.bmiHeader.biCompression = BI_RGB;
	    } else if (__depth == 16) {
		/*bitmap.bmiHeader.biCompression = BI_RGB;
		bitmap.bmiHeader.biCompression = BI_BITFIELDS;
		bitmap.b = 0x001f;
		bitmap.g = 0x07e0;
		bitmap.r = 0xf800;*/
		bitmap.bmiHeader.biCompression = BI_RGB;
	    } else {
		BMDPRINTF(("primGetBitsFromPixmap: unsupported depth\n"));
		got fail;
	    }
#endif /* ALWAYSTRUECOLOR */
	    bitmap.bmiHeader.biSizeImage = 0;
	    bitmap.bmiHeader.biXPelsPerMeter = 0;
	    bitmap.bmiHeader.biYPelsPerMeter = 0;
	    bitmap.bmiHeader.biClrUsed = 0;
	    bitmap.bmiHeader.biClrImportant = 0;

	    bitmap.bmiHeader.biWidth = width;
	    bitmap.bmiHeader.biHeight = -height;
	    bitmap.bmiHeader.biBitCount = bitmapInfo.bmBitsPixel;

	    if (GetDIBits(bDC,hBitmap,0,height,0,(struct tagBITMAPINFO *)&bitmap,DIB_RGB_COLORS) == 0)
	    {
		BMDPRINTF(("noinfo returned\n"));
		goto fail;
	    }
	    BMDPRINTF(("bitmap info:%d %d %d %d\n",bitmap.bmiHeader.biWidth,bitmap.bmiHeader.biHeight,bitmap.bmiHeader.biBitCount,bitmap.bmiHeader.biSizeImage));
	    numBytes = bitmap.bmiHeader.biSizeImage;
	    if ( numBytes != 0 ) {
		if (numBytes > __byteArraySize(imageBits)) {
		    /* imageBits too small */
		    BMDPRINTF(("provided byteArray too small\n"));
		    goto fail;
		}
		BMDPRINTF(("numBytes %d\n",numBytes));

		bitmap.bmiHeader.biHeight = -height;
		bitmap.bmiHeader.biBitCount = bitmapInfo.bmBitsPixel; /*__depth;*/
		bitmap.rgb[0] = 0;
		bitmap.rgb[1] = 0xffffff;
		if (GetDIBits(xDC,xBitmap,0,height,__ByteArrayInstPtr(imageBits)->ba_element,(struct tagBITMAPINFO *)&bitmap,DIB_RGB_COLORS) == 0)
		{
		    BMDPRINTF(("zero bits returned\n"));
		    goto fail;
		}

#if 0
		{
		    /* swap red and blue (windows delivers BGR) */
		    char *cp = __ByteArrayInstPtr(imageBits)->ba_element;
		    int n = numBytes;

		    for ( ;n > 0; n -= 3, cp += 3) {
			  char b = cp[0];
			  cp[0] = cp[2];
			  cp[2] = b;
		    }
		}
#endif
	    } else {
		BMDPRINTF(("unacceptable bitmap\n"));
		goto fail;
	    }
	} else {
	    BMDPRINTF(("unacceptable bitmap\n"));
	    goto fail;
	}
	__ArrayInstPtr(info)->a_element[0] = @symbol(msbFirst);
	__ArrayInstPtr(info)->a_element[1] = __MKSMALLINT(1);
	__ArrayInstPtr(info)->a_element[2] = __MKSMALLINT(numBytes/height);
	__ArrayInstPtr(info)->a_element[3] = @symbol(lsbFirst);
	__ArrayInstPtr(info)->a_element[4] = (bitmap.bmiHeader.biBitCount == 1) ? @symbol(ZPixmap) : @symbol(XYPixmap);
	__ArrayInstPtr(info)->a_element[5] = __MKSMALLINT(0);
	__ArrayInstPtr(info)->a_element[6] = __MKSMALLINT(WIN32PADDING);
	__ArrayInstPtr(info)->a_element[7] = __MKSMALLINT(bitmap.bmiHeader.biBitCount);
	__ArrayInstPtr(info)->a_element[8] = __MKSMALLINT(0xFF0000);   // redMask
	__ArrayInstPtr(info)->a_element[9] = __MKSMALLINT(0x00FF00);   // greenMask
	__ArrayInstPtr(info)->a_element[10] = __MKSMALLINT(0x0000FF);  // blueMask
	if (bDC)
	    DeleteDC(bDC);
	if (xDC)
	    ReleaseDC(0, xDC); //DeleteDC(xDC);
	if (hBitmap)
	    DeleteObject(hBitmap);
	RETURN ( true );
    }
fail:
    if (bDC)
	DeleteDC(bDC);
    if (xDC)
	ReleaseDC(0, xDC); //DeleteDC(xDC);
    if (hBitmap)
	DeleteObject(hBitmap);

%}.
    ^ false
! !

!WinWorkstation methodsFor:'style defaults'!

defaultStyleValueFor:aKey
    "return a default style value, given a key.
     These defaults are used if nothing is specified
     in the style sheet
     This allows for empty values in style sheets, and defaults
     being provided by the display (which makes sense with Windows,
     where the systemDefaults are used ..."

    |clr|

"/    aKey == #shadowColor ifTrue:[
"/        ^ Color black
"/    ].
"/    aKey == #lightColor ifTrue:[
"/        ^ Color white
"/    ].

    aKey == #viewBackgroundColor ifTrue:[
	clr := self getSystemColor:#COLOR_WINDOW.
    ].
    aKey == #textForegroundColor ifTrue:[
	clr := self getSystemColor:#COLOR_WINDOWTEXT
    ].


"/    aKey == #scrollerViewBackgroundColor ifTrue:[
"/        ^ Color white
"/    ].

"/    aKey == #textBackgroundColor ifTrue:[
"/        ^ Color white.
"/    ].

    clr notNil ifTrue:[^ clr].
    ^ super defaultStyleValueFor:aKey
! !

!WinWorkstation methodsFor:'tray access'!

addTrayIconFor:aView
	icon:wicon iconMask:wiconMaskArg
	toolTipMessage:toolTipMessageArg

    "add an icon to the tray for aView (which will receive tray-events in the future.
     The icon, mask and toolTopText are optional.
     Windows places a limit of 63 characters to the tooltip - so dont be to chatty here..."

    |windowId wiconId wiconMask invertedWiconMask wiconMaskId
     wiconWidth wiconHeight toolTipMessage|

    "/ the toolTop string cannot be longer than 64 characters including the NULL terminator
    toolTipMessageArg size > 63 ifTrue:[
	toolTipMessage := toolTipMessageArg copyTo:63
    ] ifFalse:[
	toolTipMessage := toolTipMessageArg.
    ].

    windowId := aView id.

    wicon notNil ifTrue:[
	wiconId := (wicon asFormOn:self) id.
	wiconHeight := wicon height.
	wiconWidth  := wicon width.
	wiconMask := wiconMaskArg.
	wiconMask isNil ifTrue:[
	    wiconMask := wicon mask.
	].
	wiconMask notNil ifTrue:[
	    "/ WIN32's mask has zeros for opaque pixels
	    invertedWiconMask := wiconMask copy.
	    invertedWiconMask bits invert.
	    invertedWiconMask := invertedWiconMask onDevice:self.
	    wiconMaskId := invertedWiconMask id
	].
    ].

%{  /* STACK: 20000 */
#ifndef WM_TRAY_MESSAGE
# define WM_TRAY_MESSAGE (WM_USER+0x200)
#endif
    HBITMAP        xBitMap, maskBitmap;
    HICON          xIcon = (HICON)0;
    ICONINFO       iconInfo;
    NOTIFYICONDATA nid;
    unsigned char fastBits[10000];

    /* get bitmap for icon */
    if ( __isExternalAddress(wiconId) ) {
	xBitMap = _HBITMAPVAL( wiconId );
	if ( xBitMap != 0 ) {
	    BITMAP bm;

	    if (GetObject(xBitMap, sizeof(bm), (LPSTR)&bm)) {
		int d = bm.bmPlanes * bm.bmBitsPixel;
		BYTE *ep;
		int height, width;
		int nBytes;
		unsigned char *allocatedBits = 0;
		int privateMask = 0;

		if ( __isExternalAddress(wiconMaskId) ) {
		    maskBitmap = _HBITMAPVAL( wiconMaskId );
		} else {
		    if (wiconMaskId != nil) {
			PRINTF(("WinWorkstat [warning]: wiconMaskId is not an external address\n"));
		    }
		    maskBitmap = 0;
		}

		/*
		 * if there is no mask, generate one
		 */
		if (maskBitmap == 0) {
		    DPRINTF(("Bitmap w:%d h:%d p:%d d:%d\n",bm.bmWidth,bm.bmHeight,bm.bmPlanes,bm.bmBitsPixel));
		    height = __intVal( wiconHeight );
		    width  = __intVal( wiconWidth  );
		    nBytes = ( width + 15 ) / 8;
		    nBytes = height * nBytes;
		    if (nBytes < sizeof(fastBits)) {
			ep = fastBits;
		    } else {
			ep = allocatedBits = (unsigned char *) malloc(nBytes);
		    }
		    if ( ep == 0 ) {
			PRINTF(( "WinWorkstat [warning]: malloc failed\n" ));
		    } else {
			memset(ep, 0, nBytes);
			maskBitmap = CreateBitmap(width, height, 1, 1, ep );
			if ( maskBitmap == NULL ) {
			    PRINTF(( "WinWorkstat [warning]: mask CREATION failed\n" ));
			} else {
			    privateMask = 1;
			}
		    }
		}
		if ( maskBitmap != NULL ) {
		    DPRINTF(( "BITMAP mask CREATED!!!\n" ));
		    iconInfo.fIcon = TRUE;
		    iconInfo.hbmMask  = maskBitmap;
		    iconInfo.hbmColor = xBitMap;
		    xIcon = CreateIconIndirect( &iconInfo );
		    if (privateMask) {
			DeleteObject( maskBitmap );
		    }
		} else {
		    PRINTF(( "WinWorkstat [warning]: no mask for icon !\n" ));
		}

		if (allocatedBits) {
		    free(allocatedBits);
		}
	    }
	} else {
	    DPRINTF(("WinWorkstat [warning]: xBitMap is zero \n" ));
	}
    } else {
	if (wiconId != nil) {
	    PRINTF(("WinWorkstat [warning]: wiconId is not an external address\n"));
	}
    }

    ZeroMemory(&nid, sizeof(NOTIFYICONDATA));
    nid.cbSize = sizeof(NOTIFYICONDATA);

    if (__isExternalAddress(windowId)) {
	HWND hwnd = _HWNDVal(windowId);

	if (hwnd && IsWindow(hwnd)) {
	    nid.hWnd = hwnd; //the hWnd and uID members allow the OS to uniquely identify your icon.
			     // One window (the hWnd) can have more than one icon, as long as they have unique uIDs.
	    nid.uFlags =
		NIF_ICON        //we're adding an icon
		| NIF_MESSAGE   //we want the tray to send a message to the window identified by hWnd when something happens to our icon (see uCallbackMesage member below).
		| NIF_TIP;      //our icon has a tooltip.

	    nid.uCallbackMessage = WM_TRAY_MESSAGE; //this message must be handled in hwnd's window procedure. more info below.
	    if (xIcon) {
		nid.hIcon   = xIcon;
		/* wc.hIconSm = wiconId; In 4.x there are large and small icons */
	    } else {
		nid.hIcon = NULL;        /* THIS MUST BE NULL TO DELETE ICONS */
	    }
	    if (__isStringLike(toolTipMessage)) {
		strcpy(nid.szTip, __stringVal(toolTipMessage));
	    }
	    Shell_NotifyIcon(NIM_ADD, &nid);
	}
    }
%}

    "
     |v icon|

     v := StandardSystemView new.
     v openAndWait.

     icon := Icon stxIcon.
     Screen current
	  addTrayIconFor:v
	  icon:icon iconMask:nil
	  toolTipMessage:'Hi There'
    "

    "Created: / 31-10-2007 / 01:51:49 / cg"
    "Modified: / 05-11-2007 / 12:18:54 / cg"
!

removeTrayIconFor:aView
    "remove the tray icon"

    |windowId wiconId wiconMask invertedWiconMask wiconMaskId
     wiconWidth wiconHeight|

    windowId := aView id.

%{  /* STACK: 20000 */
#ifndef WM_TRAY_MESSAGE
# define WM_TRAY_MESSAGE (WM_USER+0x200)
#endif
    NOTIFYICONDATA nid;

    ZeroMemory(&nid, sizeof(NOTIFYICONDATA));
    nid.cbSize = sizeof(NOTIFYICONDATA);

    if (__isExternalAddress(windowId)) {
	HWND hwnd = _HWNDVal(windowId);

	if (hwnd && IsWindow(hwnd)) {
	    nid.hWnd = hwnd;
	    Shell_NotifyIcon(NIM_DELETE, &nid);
	}
    }
%}

    "
     |v icon|

     v := StandardSystemView new.
     v openAndWait.

     icon := Icon stxIcon.
     Screen current
	  addTrayIconFor:v
	  icon:icon iconMask:nil
	  toolTipMessage:'Hi There'.

     Delay waitForSeconds:3.
     icon := Tools::NewSystemBrowser defaultIcon.
     Screen current
	  setTrayIconFor:v
	  icon:icon iconMask:nil.
     Delay waitForSeconds:3.
     Screen current
	    removeTrayIconFor:v.
    "

    "Created: / 05-11-2007 / 12:17:17 / cg"
!

setTrayIconFor:aView icon:wicon iconMask:wiconMaskArg
    "change the tray icon"

    |windowId wiconId wiconMask invertedWiconMask wiconMaskId
     wiconWidth wiconHeight|

    windowId := aView id.

    wicon notNil ifTrue:[
	wiconId := (wicon asFormOn:self) id.
	wiconHeight := wicon height.
	wiconWidth  := wicon width.
	wiconMask := wiconMaskArg.
	wiconMask isNil ifTrue:[
	    wiconMask := wicon mask.
	].
	wiconMask notNil ifTrue:[
	    "/ WIN32's mask has zeros for opaque pixels
	    invertedWiconMask := wiconMask copy.
	    invertedWiconMask bits invert.
	    invertedWiconMask := invertedWiconMask onDevice:self.
	    wiconMaskId := invertedWiconMask id
	].
    ].

%{  /* STACK: 20000 */
#ifndef WM_TRAY_MESSAGE
# define WM_TRAY_MESSAGE (WM_USER+0x200)
#endif
    HBITMAP        xBitMap, maskBitmap;
    HICON          xIcon = (HICON)0;
    ICONINFO       iconInfo;
    NOTIFYICONDATA nid;
    unsigned char fastBits[10000];

    /* get bitmap for icon */
    if ( __isExternalAddress(wiconId) ) {
	xBitMap = _HBITMAPVAL( wiconId );
	if ( xBitMap != 0 ) {
	    BITMAP bm;

	    if (GetObject(xBitMap, sizeof(bm), (LPSTR)&bm)) {
		int d = bm.bmPlanes * bm.bmBitsPixel;
		BYTE *ep;
		int height, width;
		int nBytes;
		unsigned char *allocatedBits = 0;
		int privateMask = 0;

		if ( __isExternalAddress(wiconMaskId) ) {
		    maskBitmap = _HBITMAPVAL( wiconMaskId );
		} else {
		    if (wiconMaskId != nil) {
			PRINTF(("WinWorkstat [warning]: wiconMaskId is not an external address\n"));
		    }
		    maskBitmap = 0;
		}

		/*
		 * if there is no mask, generate one
		 */
		if (maskBitmap == 0) {
		    DPRINTF(("Bitmap w:%d h:%d p:%d d:%d\n",bm.bmWidth,bm.bmHeight,bm.bmPlanes,bm.bmBitsPixel));
		    height = __intVal( wiconHeight );
		    width  = __intVal( wiconWidth  );
		    nBytes = ( width + 15 ) / 8;
		    nBytes = height * nBytes;
		    if (nBytes < sizeof(fastBits)) {
			ep = fastBits;
		    } else {
			ep = allocatedBits = (unsigned char *) malloc(nBytes);
		    }
		    if ( ep == 0 ) {
			PRINTF(( "WinWorkstat [warning]: malloc failed\n" ));
		    } else {
			memset(ep, 0, nBytes);
			maskBitmap = CreateBitmap(width, height, 1, 1, ep );
			if ( maskBitmap == NULL ) {
			    PRINTF(( "WinWorkstat [warning]: mask CREATION failed\n" ));
			} else {
			    privateMask = 1;
			}
		    }
		}
		if ( maskBitmap != NULL ) {
		    DPRINTF(( "BITMAP mask CREATED!!!\n" ));
		    iconInfo.fIcon = TRUE;
		    iconInfo.hbmMask  = maskBitmap;
		    iconInfo.hbmColor = xBitMap;
		    xIcon = CreateIconIndirect( &iconInfo );
		    if (privateMask) {
			DeleteObject( maskBitmap );
		    }
		} else {
		    PRINTF(( "WinWorkstat [warning]: no mask for icon !\n" ));
		}

		if (allocatedBits) {
		    free(allocatedBits);
		}
	    }
	} else {
	    DPRINTF(("WinWorkstat [warning]: xBitMap is zero \n" ));
	}
    } else {
	if (wiconId != nil) {
	    PRINTF(("WinWorkstat [warning]: wiconId is not an external address\n"));
	}
    }

    ZeroMemory(&nid, sizeof(NOTIFYICONDATA));
    nid.cbSize = sizeof(NOTIFYICONDATA);

    if (__isExternalAddress(windowId)) {
	HWND hwnd = _HWNDVal(windowId);

	if (hwnd && IsWindow(hwnd)) {
	    nid.hWnd = hwnd; //the hWnd and uID members allow the OS to uniquely identify your icon.
			     // One window (the hWnd) can have more than one icon, as long as they have unique uIDs.
	    nid.uFlags = NIF_ICON;      //our icon has a tooltip.

	    if (xIcon) {
		nid.hIcon   = xIcon;
		/* wc.hIconSm = wiconId; In 4.x there are large and small icons */
	    } else {
		nid.hIcon = NULL;        /* THIS MUST BE NULL TO DELETE ICONS */
	    }
	    Shell_NotifyIcon(NIM_MODIFY, &nid);
	}
    }
%}

    "
     |v icon|

     v := StandardSystemView new.
     v openAndWait.

     icon := Icon stxIcon.
     Screen current
	  addTrayIconFor:v
	  icon:icon iconMask:nil
	  toolTipMessage:'Hi There'.

     Delay waitForSeconds:3.
     icon := Tools::NewSystemBrowser defaultIcon.
     Screen current
	  setTrayIconFor:v
	  icon:icon iconMask:nil.

    "

    "Created: / 31-10-2007 / 11:41:33 / cg"
    "Modified: / 05-11-2007 / 12:19:12 / cg"
!

setTrayIconsToolTipMessageFor:aView to:toolTipMessageArg
    "Change the toolTopText.
     Windows seems to have a bug here, in that while being shown,
     a change of the toolTipText is not immediately visible
     (i.e. the new text will appear when the current toolTip view is hidden
     and reopened)
     Windows places a limit of 63 characters to the tooltip - so dont be to chatty here..."

    |windowId wiconId wiconMask invertedWiconMask wiconMaskId
     wiconWidth wiconHeight toolTipMessage|

    "/ the toolTop string cannot be longer than 64 characters including the NULL terminator
    toolTipMessageArg size > 63 ifTrue:[
	toolTipMessage := toolTipMessageArg copyTo:63
    ] ifFalse:[
	toolTipMessage := toolTipMessageArg.
    ].

    windowId := aView id.

%{  /* STACK: 20000 */
    NOTIFYICONDATA nid;

    ZeroMemory(&nid, sizeof(NOTIFYICONDATA));
    nid.cbSize = sizeof(NOTIFYICONDATA);

    if (__isExternalAddress(windowId)) {
	HWND hwnd = _HWNDVal(windowId);

	if (hwnd && IsWindow(hwnd)) {
	    nid.hWnd = hwnd; //the hWnd and uID members allow the OS to uniquely identify your icon.
			     // One window (the hWnd) can have more than one icon, as long as they have unique uIDs.
	    nid.uFlags = NIF_TIP;    //change the tooltip.
	    if (__isStringLike(toolTipMessage)) {
		strcpy(nid.szTip, __stringVal(toolTipMessage));
	    }
	    Shell_NotifyIcon(NIM_MODIFY, &nid);
	}
    }
%}

    "
     |v icon|

     v := StandardSystemView new.
     v openAndWait.

     icon := Icon stxIcon.
     Screen current
	  addTrayIconFor:v
	  icon:icon iconMask:nil
	  toolTipMessage:'Hi There'.
     1 to:5 do:[:i |
	 Delay waitForSeconds:2.
	 Screen current
	      setTrayIconsToolTipMessageFor:v
	      to:(i printString).
     ].
     v destroy.
    "

    "Created: / 31-10-2007 / 11:25:49 / cg"
    "Modified: / 05-11-2007 / 12:20:53 / cg"
! !

!WinWorkstation methodsFor:'window stuff'!

activateWindow1:aWindowId
    "make a window active (so that it gets the focus)"

%{  /* NOCONTEXT */
    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);

	if (win) {
	    CPRINTF(("activateWindow %x\n",win));
#if 0
	    ShowWindowAsync(win, SW_SHOW);
#else
	    ShowWindow(win, SW_SHOW);
#endif
	}
    }
%}
!

activateWindow2:aWindowId
    "make a window active (so that it gets the focus).
     Paranoid implementation."

%{  /* NOCONTEXT */
    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);

	if (win) {
	    DWORD activeThreadID, activeProcessID;
	    DWORD myThreadID;
	    HWND foregroundWindow = GetForegroundWindow();

	    if (foregroundWindow) {
		activeThreadID = GetWindowThreadProcessId(foregroundWindow, &activeProcessID);
		myThreadID = GetCurrentThreadId();
		AttachThreadInput(activeThreadID, myThreadID, TRUE);
	    }

	    // Do our stuff here ;-)
	    ShowWindow(win, SW_SHOW);
	    SetForegroundWindow(win);
	    SetFocus(win);

	    if (foregroundWindow) {
		AttachThreadInput(activeThreadID, myThreadID, FALSE);
	    }
	}
    }
%}
!

activateWindow:aWindowId
    "make a window active (so that it gets the focus)"

    "/ on some systems I seem to not get the window to be raised with focus.
    "/ we might try activate2 there.

    "/ self activateWindow1:aWindowId
    self activateWindow2:aWindowId.
!

animateWindow:aWindowId show:doShow animation:animationSymbolorNil time:timeInMillisOrNil
    "make a window visible/invisible with animation effect.
     CAVEAT:
	This does not work yet correctly, as we do not handle WM_PRINT messages correctly."

%{
    if (__isExternalAddress(aWindowId)) {
	HWND hWnd = _HWNDVal(aWindowId);

	if (hWnd) {
	    DWORD how = (doShow == true) ? AW_ACTIVATE : AW_HIDE;
	    DWORD time = 0;

	    CPRINTF(("mapWindowAnimated %x\n", hWnd));
	    if (animationSymbolorNil != nil) {
		if (__isSmallInteger(timeInMillisOrNil)) {
		    time = __intVal(timeInMillisOrNil);
		}
		if (animationSymbolorNil == @symbol(SLIDE)) {
		    how |= AW_SLIDE;
		} else if (animationSymbolorNil == @symbol(BLEND)) {
		    how |= AW_BLEND;
		} else if (animationSymbolorNil == @symbol(CENTER)) {
		    how |= AW_CENTER;
		} else if (animationSymbolorNil == @symbol(HOR_POSITIVE)) {
		    how |= AW_HOR_POSITIVE;
		} else if (animationSymbolorNil == @symbol(HOR_NEGATIVE)) {
		    how |= AW_HOR_NEGATIVE;
		} else if (animationSymbolorNil == @symbol(VER_POSITIVE)) {
		    how |= AW_VER_POSITIVE;
		} else if (animationSymbolorNil == @symbol(VER_NEGATIVE)) {
		    how |= AW_VER_NEGATIVE;
		}
	    }
	    AnimateWindow(hWnd, time, how);
	}
	RETURN ( self );
    }
%}
!

configureWindow:aWindowId sibling:siblingId stackMode:modeSymbol
    "configure stacking operation of aWindowId w.r.t siblingId"

!

dropFilesWindow:aWindowId accept:doAccept
    "window accept Files from Shell"

%{  /*  */

    if (__isExternalAddress(aWindowId)) {
	HWND hWnd = _HWNDVal(aWindowId);

	if (hWnd) {
	    if (doAccept == true)
	    DragAcceptFiles(hWnd, (doAccept == true) ? TRUE : FALSE);
	}
	RETURN ( self );
    }
%}
!

findWindow:lpClassName windowName:lpWindowName
    "If the function succeeds, the return value is a handle to the window that has the specified class name
     and window name. If the function fails, the return value is NULL."

    ((lpClassName notNil and:[lpClassName isWideString])
     or:[lpWindowName notNil and:[lpWindowName isWideString]]) ifTrue:[
	^ self
	    primFindWindowW:(lpClassName isNil
				    ifTrue:[nil]
				    ifFalse:[lpClassName asUnicode16StringZ])
	    windowName:(lpWindowName isNil
				    ifTrue:[nil]
				    ifFalse:[lpWindowName asUnicode16StringZ])
    ].
    ^ self primFindWindowA:lpClassName windowName:lpWindowName

    "
     |h|

     h := Screen current findWindow:'Shell_TrayWnd' windowName:''.
     Screen current prim_getWindowRect:h.

     Display findWindow:nil windowName:'ST/X Launcher'
    "
!

getParentWindowIdOfWindowId:aChildWindowId
%{  /* NOCONTEXT */

    if (__isExternalAddress(aChildWindowId)) {
	HWND wChild = _HWNDVal(aChildWindowId);
	HWND wParent;

	if (wChild) {
	    wParent = GetParent(wChild);
	    if (wParent) {
		RETURN ( __MKEXTERNALADDRESS(wParent) );
	    }
	}
    }
%}.
    ^ nil

    "
     |top v|

     top := View new.
     v := View in:top.
     top realize.

     self assert:(Display getParentWindowIdOfWindowId:(v id)) = top id.
    "
!

getThreadIdOfWindowId:windowId
%{  /* NOCONTEXT */

    if (__isExternalAddress(windowId)) {
	HWND hwnd = _HWNDVal(windowId);
	DWORD id;

	if (hwnd) {
	    id = GetWindowThreadProcessId(hwnd, &id);
	    RETURN ( __MKEXTERNALADDRESS(id) );
	}
    }
%}.
    ^ nil

    "
     |top|

     top := View new.
     top realize.

     self assert:(Display getThreadIdOfWindowId:(top id)) = OperatingSystem getProcessId.
    "
!

getWindowClassName:aWindowId
    "get a (possibly alien) window's class name"

    |buffer n|

    buffer := Unicode16String new:200.
    n := self primGetWindowClassW:aWindowId into:buffer size:200.
    n >= 0 ifTrue:[
	^ (buffer copyTo:n) asSingleByteStringIfPossible
    ].
    self primitiveFailed.

    "
     |h|

     h := Display findWindow:nil windowName:'ST/X Launcher'.
     Display getWindowClassName:h.
    "

    "
     |h|

     h := Display findWindow:nil windowName:'ST/XX Launcher'.
     Display getWindowText:h.
    "
!

getWindowIdFromThreadId:id
    |l|

    l := OrderedCollection new.
    self primEnumWindowsInto:l.
    l do:[:eachWindowId |
	(self getParentWindowIdOfWindowId:eachWindowId) isNil ifTrue:[
	    "/ a topView
	    (self getThreadIdOfWindowId:eachWindowId) = id ifTrue:[
		^ eachWindowId
	    ].
	]
    ].
    ^ nil

    "
     Display getWindowIdFromThreadId:(OperatingSystem getProcessId)
    "
!

getWindowRectangle:aWindowId
    "get a (possibly alien) window's screen rectangle"

    |bytes|

    (aWindowId isNil or:[aWindowId address == 0]) ifTrue:[^ self].

    bytes := ByteArray new:(ExternalBytes sizeofLong*4).
    self primGetWindowRect:aWindowId lpRect:bytes.
    ^ Rectangle
	left:(bytes longAt:1)
	top:(bytes longAt:5)
	right:(bytes longAt:9)
	bottom:(bytes longAt:13)

    "
     |handle|

     handle := Display findWindow: nil windowName: 'ST/X Launcher'.
     (handle isNil or:[handle address == 0]) ifTrue:[self halt.].
     Display getWindowRectangle:handle.
    "
!

getWindowText:aWindowId
    "get a (possibly alien) window's title text"

    |buffer n|

    buffer := Unicode16String new:200.
    n := self primGetWindowTextW:aWindowId into:buffer size:200.
    n >= 0 ifTrue:[
	^ (buffer copyTo:n) asSingleByteStringIfPossible
    ].
    self primitiveFailed.

    "
     |h|

     h := Display findWindow:nil windowName:'ST/X Launcher'.
     Display getWindowText:h.
    "

    "
     |h|

     h := Display findWindow:nil windowName:'ST/XX Launcher'.
     Display getWindowText:h.
    "
!

isValidWindowId:aWindowId
    "return true, if the given window ID is (still) valid.
     Especially useful, if the passed windowID is
     an alien (external) windows id."

%{  /* NOCONTEXT */
    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);
	DWORD threadID, processID = 0;

	if (! IsWindow(win)) {
	    RETURN (false);
	}
	threadID = GetWindowThreadProcessId(win, &processID);
	if ((threadID==0) || (processID==0)) {
	    RETURN (false);
	}
	RETURN (true);
    }
%}.
    self primitiveFailed.
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
     Delay waitForSeconds:0.5.
     ok := Display isValidWindowId:aWindowId.
     Transcript showCR:'ok is: ' , ok printString.
    "
!

lowerWindow:aWindowId
    "bring a window to back"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);

	if (win) {
	    CPRINTF(("lowerWindow %x\n",win));
	    SetWindowPos(win, HWND_BOTTOM, 0, 0, 0, 0,
			 SWP_NOSENDCHANGING |
			 SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE);
	}
	RETURN ( self );
    }
%}
!

mapView:aView id:aWindowId iconified:aBoolean atX:x y:y width:w height:h minExtent:minExt maxExtent:maxExt
    "make a window visible - either as icon or as a real view
     in addition, allow change of extend, position, minExtend and maxExtent.
     Needed for restart, to allow recreating a view as iconified,
     and to collaps/expand windows."

    |minW minH maxW maxH|

    minExt notNil ifTrue:[
	minW := minExt x.
	minH := minExt y.
    ].
    maxExt notNil ifTrue:[
	maxW := maxExt x.
	maxH := maxExt y.
    ].

%{
    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);

	if (win) {
	    int bw = 0;
	    int flag = 0;
	    int __left, __top, __width, __height;
	    int winStyleBits;
	    int winExStyleBits;
	    localWindowInfo *lI;

	    bw = GetWindow_bw(win);
	    winStyleBits = GetWindowLong(win, GWL_STYLE);
	    winExStyleBits = GetWindowLong(win, GWL_EXSTYLE);
	    lI = GETLOCALWINDOWINFOPTR(win);
	    if (! lI) {
		console_fprintf(stderr, "WinWorkstation [info]: oops - no localInfo in mapView\n");
		RETURN (self);
	    }

	    if (__bothSmallInteger(x, y)) {
		__left = __intVal(x) + bw;
		__top = __intVal(y) + bw;
	    } else {
		__left = __top = 0;
		flag |= SWP_NOMOVE;
	    }
	    if (__bothSmallInteger(w, h)) {
		__width = __intVal(w) - bw - bw;
		__height = __intVal(h) - bw - bw;
	    } else {
		__width = __height = 100;
		flag |= SWP_NOSIZE;
	    }

	    if (__bothSmallInteger(minW, minH)) {
		RECT rec;

		rec.left = 0;
		rec.top = 0;
		rec.right = __intVal(minW);
		rec.bottom = __intVal(minH);
#ifdef ADJUSTWINDOW
		AdjustWindowRectEx(&rec, winStyleBits, 0, winExStyleBits);
#endif
		lI->minWidth = rec.right - rec.left;
		lI->minHeight = rec.bottom - rec.top;
	    }
	    if (__bothSmallInteger(maxW, maxH)) {
		RECT rec;

		rec.left = 0;
		rec.top = 0;
		rec.right = __intVal(maxW);
		rec.bottom = __intVal(maxH);
#ifdef ADJUSTWINDOW
		AdjustWindowRectEx(&rec, winStyleBits, 0, winExStyleBits);
#endif
		lI->maxWidth = rec.right - rec.left;
		lI->maxHeight = rec.bottom - rec.top;
	    }

#ifdef ADJUSTWINDOW
	    if (flag != (SWP_NOMOVE | SWP_NOSIZE)) {
		RECT rec;
		int __left0, __top0, __width0, __height0;

		__left0   = __left;
		__top0    = __top;
		__width0  = __width;
		__height0 = __height;

		rec.left = __left;
		// rec.left = __left-2;
		rec.top = __top;
		// rec.top = __top-2;
		rec.right = rec.left + __width;
		rec.bottom = rec.top + __height;
		AdjustWindowRectEx(&rec, winStyleBits, 0, winExStyleBits);

		__left = rec.left;
		__top = rec.top;
		__width = rec.right - rec.left;
		__height = rec.bottom - rec.top;

		CPRINTF(("mapView %x %d/%d %d/%d -> %d/%d %d/%d\n",
			 win,
			 __left0, __top0, __width0, __height0,
			 __left, __top, __width, __height));
	    }
#else
	    CPRINTF(("mapView %x %d/%d %d/%d\n",
		     win,
		     __left, __top, __width, __height));
#endif

	    flag |= SWP_NOACTIVATE | SWP_NOSENDCHANGING | SWP_NOZORDER | SWP_NOOWNERZORDER;

	    if (aBoolean == true) {
		/* iconified */
//              SetWindowPos(win, (HWND)0,
//                           __left, __top, __width, __height,
//                           flag);
//                ShowWindow(win, SW_SHOWMINIMIZED);
		ShowWindowAsync(win, SW_SHOWMINNOACTIVE);
/*
		enqEvent(0, win, WM_SHOWWINDOW, FALSE, 0, 0, 0, 0, EV_NOTIME);
*/
	    } else {
		/* normal */
		SetWindowPos(win, (HWND)0,
			     __left, __top, __width, __height,
			     flag);
/*
		enqEvent(0, win, WM_SHOWWINDOW, TRUE, 0, 0, 0, 0, EV_NOTIME);
*/
		//ShowWindow(win, SW_RESTORE);
		// ShowWindowAsync(win, SW_RESTORE);
		ShowWindowAsync(win, SW_SHOWNOACTIVATE);
	    }
	}
	RETURN ( self );
    }
%}
!

mapWindow:aWindowId
    "make a window visible"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aWindowId)) {
	HWND hWnd = _HWNDVal(aWindowId);

	if (hWnd) {
	    CPRINTF(("mapWindow %x\n", hWnd));
	    if (GetParent(hWnd) == 0) {
		ShowWindowAsync(hWnd, SW_SHOWNOACTIVATE);
	    } else {
		ShowWindowAsync(hWnd, SW_SHOWNORMAL);
	    }
	}
	RETURN ( self );
    }
%}
!

mapWindow:aWindowId animation:animationSymbolorNil time:timeInMillisOrNil
    "make a window visible with some animation effect"

    self animateWindow:aWindowId show:true animation:animationSymbolorNil time:timeInMillisOrNil
!

moveResizeWindow:aWindowId x:x y:y width:w height:h
    "move and resize a window"

%{  /* NOCONTEXT */
    RECT rec;
    if (__isExternalAddress(aWindowId)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(w, h)) {
	HWND win = _HWNDVal(aWindowId);
	int bw = 0;

	if (win) {
	    bw = GetWindow_bw(win);

	    rec.left = __intVal(x) + bw;
	    rec.top = __intVal(y) + bw;
	    rec.right = rec.left + __intVal(w) - bw - bw;
	    rec.bottom = rec.top + __intVal(h) - bw - bw;
	    if (GetParent(win) == 0) {
#ifdef ADJUSTWINDOW
		AdjustWindowRectEx(&rec,GetWindowLong(win,GWL_STYLE),0,GetWindowLong(win,GWL_EXSTYLE));
#endif
	    }
	    CPRINTF(("moveresize %x x:%d y:%d w:%d h:%d -> x:%d y:%d w:%d h:%d\n",win,__intVal(x),__intVal(y),__intVal(w),__intVal(h),rec.left,rec.top,
			 rec.right - rec.left, rec.bottom - rec.top));
	    SetWindowPos(win, (HWND)0,
			 rec.left, rec.top,
			 rec.right - rec.left, rec.bottom - rec.top,
			 SWP_NOSENDCHANGING | SWP_NOACTIVATE | SWP_NOZORDER | SWP_NOOWNERZORDER);
	}
	RETURN ( self );
    }
%}
!

moveWindow:aWindowId x:x y:y
    "move a window"

%{  /* NOCONTEXT */
    RECT rec;

    if (__isExternalAddress(aWindowId)
     && __bothSmallInteger(x, y)) {
	HWND win = _HWNDVal(aWindowId);
	int bw = 0;

	if (win) {
	    bw = GetWindow_bw(win);

	    rec.left = __intVal(x) + bw;
	    rec.top = __intVal(y) + bw;
	    if (GetParent(win) == 0) {
		rec.right = rec.left + 10;  /* only needed to give adjust some valid numbers */
		rec.bottom = rec.top + 10;
#ifdef ADJUSTWINDOW
		AdjustWindowRectEx(&rec, GetWindowLong(win,GWL_STYLE), 0, GetWindowLong(win,GWL_EXSTYLE));
#endif
	    }
	    CPRINTF(("move %x x:%d y:%d -> x:%d y:%d\n", win,
			__intVal(x), __intVal(y), rec.left, rec.top));
	    SetWindowPos(win, (HWND)0,
			 rec.left, rec.top,
			 0, 0,
			 SWP_NOSENDCHANGING | SWP_NOACTIVATE | SWP_NOSIZE | SWP_NOZORDER | SWP_NOOWNERZORDER);
	}
	RETURN ( self );
    }
%}
!

primEnumChildWindowsOf:aWindowId into:handleList
%{
    if (__isExternalAddress(aWindowId)) {
	HWND hwParent = _HWNDVal(aWindowId);

	if ( EnumChildWindows( hwParent, EnumWindowsProc, (INT)&(handleList))) {
	    DPRINTF(("EnumChildWindows successful\n"));
	}
    }
%}
!

primEnumWindowsInto:handleList
%{
    if ( EnumWindows( EnumWindowsProc, (INT)&(handleList))) {
	DPRINTF(("EnumWindows successful\n"));
    }
%}
!

primEnumWindowsOf:threadId into:handleList
%{
    if (__isSmallInteger(threadId)) {
	if ( EnumThreadWindows( __intVal(threadId), EnumWindowsProc, (INT)&(handleList))) {
	    DPRINTF(("EnumThreadWindows successful\n"));
	}
    }
%}
!

primFindWindowA:lpClassName windowName:lpWindowName
    "If the function succeeds, the return value is a handle to the window that has the
     specified class name and window name. If the function fails, the return value is NULL."

    <apicall: handle "FindWindowA" (lpstr lpstr) module: "user32.dll" >

    "
     Display primFindWindowA: nil windowName: 'ST/X Launcher'
    "
!

primFindWindowW:lpClassName windowName:lpWindowName
    "If the function succeeds, the return value is a handle to the window that has the specified
     class name and window name. If the function fails, the return value is NULL."

    <apicall: handle "FindWindowW" (pointer pointer) module: "user32.dll" >

    "
     Display primFindWindowW: nil windowName: 'ST/X Launcher' asUnicode16String
    "
!

primGetWindowClassW:aWindowId into:buffer size:maxSize
    "get a window's class name"

    <apicall: int "GetClassNameW" (handle, pointer, int) module: "user32.dll" >
!

primGetWindowRect:aWindowId lpRect:lpRect
    "get a window's screen rectangle"

    <apicall: int "GetWindowRect" (handle, pointer) module: "user32.dll" >
!

primGetWindowTextW:aWindowId into:buffer size:maxSize
    "get a window's title text"

    <apicall: int "GetWindowTextW" (handle, pointer, int) module: "user32.dll" >
!

primSendMessage:aWindowId message:message wParam:wParam lParam:lParam
    "Sends the specified message to a (possibly alien) window.
     The SendMessage function calls the window procedure for the specified window and
     does not return until the target's window procedure has processed the message."

    <apicall: bool "SendMessageA" (handle uint pointer pointer) module: "user32.dll" >
!

primSetForegroundWindow: aWindowId

    "
    If the window was brought to the foreground, the return value is nonzero.
    If the window was not brought to the foreground, the return value is zero.
    "

    <apicall: bool "SetForegroundWindow" (handle) module: "user32.dll" >
!

primSetWindowIconId:wiconId maskId:wmaskId width:wiconWidth height:wiconHeight in:aWindowId
%{

    HBITMAP        xBitMap, maskBitmap;
    ICONINFO       iconInfo;
    int            height, width;
    HICON          xIcon = (HICON)0;
    unsigned char  fastBits[10000];

    DPRINTF(("primSetWindowIconId\n"));
    if (__isExternalAddress(aWindowId)
     && __isExternalAddress(wiconId)
     && __bothSmallInteger(wiconWidth, wiconHeight)) {
	HWND win = _HWNDVal(aWindowId);

	xBitMap = _HBITMAPVAL( wiconId );
	if ( xBitMap != 0 ) {
	    BITMAP bm;

	    if (GetObject(xBitMap, sizeof(bm), (LPSTR)&bm)) {
		BYTE *ep;
		int privateMask = 0;
		unsigned char  *allocatedBits = 0;

		DPRINTF(("Bitmap w:%d h:%d p:%d d:%d\n",bm.bmWidth,bm.bmHeight,bm.bmPlanes,bm.bmBitsPixel));
		height = __intVal( wiconHeight );
		width  = __intVal( wiconWidth  );

		if ( __isExternalAddress(wmaskId) ) {
		    maskBitmap = _HBITMAPVAL( wmaskId );
		} else {
		    if (wmaskId != nil) {
			PRINTF(("WinWorkstat [warning]: wmaskId is not an external address\n"));
		    }
		    maskBitmap = 0;
		}

		/*
		 * if there is no mask, generate one
		 */
		if (maskBitmap == 0) {
		    int nBytes;

		    nBytes = ( width + 31 ) / 8;
		    nBytes = height * nBytes;
		    if (nBytes < sizeof(fastBits)) {
			ep = fastBits;
		    } else {
			ep = allocatedBits = (unsigned char *) malloc(nBytes);
		    }
		    if ( ep == 0 ) {
			PRINTF(( "WinWorkstat [warning]: malloc failed\n" ));
		    } else {
			memset(ep, 0, nBytes);
			maskBitmap = CreateBitmap(width, height, 1, 1, ep );
			if ( maskBitmap == NULL ) {
			    PRINTF(( "WinWorkstat [warning]: mask CREATION failed\n" ));
			} else {
			    privateMask = 1;
			}
		    }
		}
		if ( maskBitmap != NULL ) {
		    DPRINTF(( "BITMAP mask CREATED!!!\n" ));
		    iconInfo.fIcon = TRUE;
		    iconInfo.hbmMask  =maskBitmap;
		    iconInfo.hbmColor = xBitMap;
		    xIcon = CreateIconIndirect( &iconInfo );
		    DPRINTF(( "ICON CREATED!!!\n" ));
		    if (privateMask) {
			_DeleteObject( maskBitmap, __LINE__ );
		    }
		} else {
		    PRINTF(( "WinWorkstat [warning]: no mask for icon !\n" ));
		}

		if (allocatedBits) {
		    free(allocatedBits);
		}
	    }
	} else {
	    DPRINTF(("WinWorkstat [warning]: xBitMap is zero \n" ));
	}

	if (xIcon) {
#ifndef TOPWINDOWCLASS
	    HICON oldIcon = (HICON)0;

# ifdef _WIN64
	    oldIcon = (HICON) GetClassLongPtr(win, GCLP_HICON);
	    SetClassLongPtr(win, GCLP_HICON, (INT)xIcon);
# else
	    oldIcon = (HICON) GetClassLong(win, GCL_HICON);
	    SetClassLong(win, GCL_HICON, (DWORD)xIcon);
# endif
/* It has to be checked whether this can be deleted!!!!! */
	    if ( oldIcon ) {
		if (DestroyIcon( oldIcon )) {
		    DPRINTF(( "Old icon deleted\n" ));
		} else {
		    console_fprintf(stderr, "failed to delete old icon\n");
		}
	    }
#else
	    SendMessage(win, WM_SETICON, (WPARAM)ICON_SMALL, (LPARAM)xIcon);
	    SendMessage(win, WM_SETICON, (WPARAM)ICON_BIG, (LPARAM)xIcon);
#endif
	}
	RETURN (self);
    }
%}
!

raiseWindow:aWindowId
    "bring a window to front - but there may be some windows marked as 'TOPMOST'
     that are still in front of our window (e.g. cmd.exe apparently marks itself
     as topmost, when it gets the focus)"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aWindowId)) {
	HWND hWnd = _HWNDVal(aWindowId);

	if (hWnd) {
	    CPRINTF(("raiseWindow %x\n",hWnd));
	    SetWindowPos(hWnd, HWND_TOP, 0, 0, 0, 0,
			 /* SWP_NOOWNERZORDER |*/
			SWP_NOSENDCHANGING | SWP_NOACTIVATE |
			SWP_NOMOVE | SWP_NOSIZE);
	}
    }
%}
!

raiseWindowToTop:aWindowId
    "bring a window to the very front - above all others (even above non-st/x windows).
     Q: is this a windows-specific thing ?"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aWindowId)) {
	HWND hWnd = _HWNDVal(aWindowId);

	if (hWnd) {
	    CPRINTF(("raiseWindow %x\n",hWnd));

	    SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, 0, 0,
			 /* SWP_NOOWNERZORDER |*/
			SWP_NOSENDCHANGING | SWP_NOACTIVATE |
			SWP_NOMOVE | SWP_NOSIZE);

	    SetWindowPos(hWnd, HWND_NOTOPMOST, 0, 0, 0, 0,
			 /* SWP_NOOWNERZORDER |*/
			SWP_NOSENDCHANGING | SWP_NOACTIVATE |
			SWP_NOMOVE | SWP_NOSIZE);

	    SetWindowPos(hWnd, HWND_TOP, 0, 0, 0, 0,
			/* SWP_NOOWNERZORDER | */
			/* SWP_NOSENDCHANGING | SWP_NOACTIVATE | */
			SWP_NOMOVE | SWP_NOSIZE);

	    SetWindowPos(hWnd, HWND_TOP, 0, 0, 0, 0,
			/* SWP_NOOWNERZORDER | */
			/* SWP_NOSENDCHANGING | SWP_NOACTIVATE | */
			SWP_NOMOVE | SWP_NOSIZE);
	}
    }
%}
!

raiseWindowToTopMost:aWindowId
    "bring a window to the very front - above all others (even above non-st/x windows).
     Q: is this a windows-specific thing ?"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aWindowId)) {
	HWND hWnd = _HWNDVal(aWindowId);

	if (hWnd) {
	    CPRINTF(("raiseWindow %x\n",hWnd));
	    SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
	}
    }
%}
!

reparentWindow:windowId to:newParentWindowId
    "change a windows parent (an optional interface)"

%{  /* NOCONTEXT */
    if (__isExternalAddress(windowId)
     && __isExternalAddress(newParentWindowId)) {
	HWND hWnd = _HWNDVal(windowId);
	HWND hWndNewParent = _HWNDVal(newParentWindowId);

	SetParent(hWnd, hWndNewParent);
	RETURN ( true );
    }
%}.
    self primitiveFailed
!

resizeWindow:aWindowId width:w height:h
    "resize a window"

%{  /* NOCONTEXT */
    RECT rec;

    if (__isExternalAddress(aWindowId)
     && __bothSmallInteger(w, h)) {
	HWND hWnd = _HWNDVal(aWindowId);
	int bw;

	if (hWnd) {
	    bw = GetWindow_bw(hWnd);

	    rec.left = 0;  /* only needed to have a valid origin in adjust */
	    rec.top = 0;   /* only needed to have a valid origin in adjust */
	    rec.right = __intVal(w) - bw - bw;
	    rec.bottom = __intVal(h) - bw - bw;
#ifdef ADJUSTWINDOW
	    AdjustWindowRectEx(&rec, GetWindowLong(hWnd, GWL_STYLE), 0, GetWindowLong(hWnd, GWL_EXSTYLE));
#endif
	    CPRINTF(("resize %x w:%d h:%d -> w:%d h:%d\n",hWnd,__intVal(w),__intVal(h),rec.right - rec.left, rec.bottom - rec.top));
	    SetWindowPos(hWnd, (HWND)0,
			 0, 0,
			 rec.right - rec.left, rec.bottom - rec.top,
			 SWP_NOSENDCHANGING | SWP_NOACTIVATE |
			 SWP_NOMOVE | SWP_NOZORDER | SWP_NOOWNERZORDER);
	}
	RETURN ( self );
    }
%}
!

sendButtonMessageType:messageType at:aPoint toWindowId:aWindowId
    "send a button message to a window by id (handle)"

    |wParam lParam result|

    (aWindowId isNil or:[aWindowId address == 0]) ifTrue:[^ self].

    wParam := 0.
    lParam := (aPoint x) + (aPoint y bitShift:16).
    result := self primSendMessage:aWindowId message:messageType wParam:wParam lParam:lParam.
    ^ result

    "
     |v b externalAddress handle|

     v := StandardSystemView new.
     b := Button in:v.
     b label:'ok'; origin:10@10 corner:100@30; action:[Transcript showCR:'ok'].
     v openAndWait.

     handle := b id.
     (handle isNil or:[handle address == 0]) ifTrue:[self halt.].
     externalAddress := handle asExternalAddress.
     Display sendButtonPress:1 at:1@1 toWindowId: externalAddress.
     Display sendButtonRelease:1 at:10@10 toWindowId: externalAddress.
    "
!

sendButtonPress:button at:aPoint toWindowId:aWindowId
    "send a button press message to a window by id (handle)"

    |messageType|

    self assert:(button between:1 and:3).
    messageType := #(   16r0201 "WM_LBUTTONDOWN"
			16r0207 "WM_MBUTTONDOWN"
			16r0204 "WM_RBUTTONDOWN"  ) at:button.

    self sendButtonMessageType:messageType at:aPoint toWindowId:aWindowId

    "
     |v b externalAddress handle|

     v := StandardSystemView new.
     b := Button in:v.
     b label:'ok'; origin:10@10 corner:100@30; action:[Transcript showCR:'ok'].
     v openAndWait.

     handle := b id.
     (handle isNil or:[handle address == 0]) ifTrue:[self halt.].
     externalAddress := handle asExternalAddress.
     Display sendButtonPress:1 at:1@1 toWindowId: externalAddress.
     Display sendButtonRelease:1 at:10@10 toWindowId: externalAddress.
    "
!

sendButtonRelease:button at:aPoint toWindowId:aWindowId
    "send a button release message to a window by id (handle)"

    |messageType|

    self assert:(button between:1 and:3).
    messageType := #(   16r0202 "WM_LBUTTONUP"
			16r0208 "WM_MBUTTONUP"
			16r0205 "WM_RBUTTONUP"  ) at:button.

    self sendButtonMessageType:messageType at:aPoint toWindowId:aWindowId

    "
     |v b externalAddress handle|

     v := StandardSystemView new.
     b := Button in:v.
     b label:'ok'; origin:10@10 corner:100@30; action:[Transcript showCR:'ok'].
     v openAndWait.

     handle := b id.
     (handle isNil or:[handle address == 0]) ifTrue:[self halt.].
     externalAddress := handle asExternalAddress.
     Display sendButtonPress:1 at:1@1 toWindowId: externalAddress.
     Display sendButtonRelease:1 at:10@10 toWindowId: externalAddress.
    "
!

sendCopyData: aByteArrayOrString toWindowId: aWindowId
    "send copy-paste data to a window by id (handle)"

    |externalBytes messageType lParam copyDataStruct|

    (aWindowId isNil or:[aWindowId address == 0]) ifTrue:[^ self].

    messageType := 74 "WM_COPYDATA".

    externalBytes := aByteArrayOrString asExternalBytesUnprotected.
    copyDataStruct := CopyDataStructStructure new.
    copyDataStruct
	cbData:externalBytes size;
	lpData:externalBytes address.
    lParam := copyDataStruct asExternalBytesUnprotected.
    ^ self primSendMessage:aWindowId message:messageType wParam:nil lParam:lParam.

    "
     |handle|
     handle := Display primFindWindowA: nil windowName: 'expecco'.
     (handle isNil or:[handle address == 0]) ifTrue:[self halt.].
     Display sendCopyData: 'openPath: bla' toWindowId: handle.
     Display setForegroundWindow: handle.
    "

    "
     |bytes handle|

     bytes := 'c:\pipo.net' asByteArray.
     handle := Display primFindWindowA: nil windowName: 'ST/X Launcher'.
     (handle isNil or:[handle address == 0]) ifTrue:[self halt.].
     Display setForegroundWindow: handle.
     Display sendCopyData: bytes toWindowId: handle.
    "
!

setBackingStore:how in:aWindowId
    "turn on/off backing-store for a window"

    "/ 'WinWorkstation [info]: setBackingStore:in: not yet implemented' infoPrintCR.
!

setBitGravity:how in:aWindowId
    "set bit gravity for a window"

    "/ 'WinWorkstation [info]: setBitGravity:in: not yet implemented' infoPrintCR.
!

setCursor:aCursorId in:aWindowId
    "define a cursor for a window"

%{  /* NOCONTEXT */

    HCURSOR newCursor;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)
     && __isExternalAddress(aCursorId)) {
	HWND win = _HWNDVal(aWindowId);
//        POINT p;
//        GUITHREADINFO info;

	SetWindow_Cursor(win, _HCURSORVal(aCursorId));

	/*
	 * The window's cursor has been set. When the mouse moves into
	 * the window, the new cursor will be shown when the WM_SETCURSOR event is handled.
	 * If the window contains the mouse pointer, or the window has captured the mousem
	 * no WM_SETCURSOR event is generated, so we have to set the cursor here.
	 */

// forget about the GetGUIThreadInfo stuff (although it works) - __currentPointerView is easier
//        info.cbSize = sizeof(info);
//        if (GetGUIThreadInfo(0, &info) == 0) {
//            info.hwndCapture = 0;               // set to defined value on failure
//        }
//        if (info.hwndCapture == win
//            || (GetCursorPos(&p), WindowFromPoint(p) == win)) {

	if (win == __currentPointerView) {
#if defined(SET_CURSOR_IN_WINTHREAD)
	    PostMessage(win, WM_THREAD_SETCURSOR, (WPARAM)0, (INT)_HCURSORVal(aCursorId));
#else
	    SetCursor(_HCURSORVal(aCursorId));
#endif
	}
    }
%}
!

setForegroundWindow2:aWindowId
    "make a window the foreground window"

%{  /* NOCONTEXT */
    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);

	if (win) {
	    ShowWindow(win, SW_SHOW);
	    SetForegroundWindow(win);
	    BringWindowToTop(win);
	}
	RETURN ( self );
    }
%}
!

setForegroundWindow:aWindowId
    "make a window the foreground window.
     Under Win 98/Me/XP/2000 the window is not raised/activated, if a window from
     a different process is currently active - in this case the title bar/icon is flashed.
     this also raises the priority of the sending thread slightly"

%{  /* NOCONTEXT */
    if (__isExternalAddress(aWindowId)) {
        HWND win = _HWNDVal(aWindowId);

        if (win) {
            SetForegroundWindow(win);            
        }
        RETURN ( self );
    }
%}
!

setIconName:aString in:aWindowId
    "define a windows iconname"

%{  /* NOCONTEXT */
#if 0
    if (__isExternalAddress(aWindowId)
     && (__isStringLike(aString))) {
	HWND win = _HWNDVal(aWindowId);

	SetWindowText(win, __stringVal(aString));
	RETURN (self);
    }
#endif
%}
!

setParentWindowIdOf:aChildWindowId to:newParentWindowId
%{  /* NOCONTEXT */

    if (__isExternalAddress(aChildWindowId)
     && __isExternalAddress(newParentWindowId)) {
	HWND wChild = _HWNDVal(aChildWindowId);
	HWND wNewParent = _HWNDVal(newParentWindowId);

	if (wChild && wNewParent) {
	    SetParent(wChild, wNewParent);
	}
    }
%}
!

setSaveUnder:yesOrNo in:aWindowId
    "turn on/off save-under for a window"

%{  /* NOCONTEXT */
    if (yesOrNo != false) {
	DPRINTF(("WinWorkstation [info]: setSaveUnder:in: not (yet) implemented\n"));
    }
%}.
!

setTransient:aWindowId for:aMainWindowId
    "set aWindowId to be a transient of aMainWindow.
     This will make the transient window to be iconified/deiconified
     together with the mainWindow.
     Typically, this is set for modal dialogs."

%{  /* NOCONTEXT */

#ifdef NOT_YET_SUPPORTED
    if (__isExternalAddress(aWindowId)) {
	HWND w;
	HWND cw = _HWNDVal(aWindowId);

	if ((aMainWindowId == nil) || (aMainWindowId == __MKSMALLINT(0))) {
	    w = (HWND) 0;
	} else {
	    if (__isExternalAddress(aMainWindowId)) {
		w = _HWNDVal(aMainWindowId);
	    } else {
		goto getOutOfHere;
	    }
	}
	CPRINTF(("setTransient:%x for:%x\n",cw,w));
	//SetParent(cw, w);
	RETURN ( self );
    }
 getOutOfHere: ;
#else
    RETURN (self);
#endif
%}.
    self primitiveFailed
!

setWindowBackground:aColorIndex in:aWindowId
    "set the windows background color. This is the color with which
     the view is filled whenever exposed. Do not confuse this with
     the background drawing color, which is used with opaque drawing."

%{  /* NOCONTEXT */

    if (__isExternalAddress(aWindowId)
     && (__isSmallInteger(aColorIndex))) {
	HWND hWnd = _HWNDVal(aWindowId);
	int clr;
	HBRUSH oldBrush;

	oldBrush = GetWindow_viewBgBrush(hWnd);
	if (oldBrush) {
	    SetWindow_viewBgBrush(hWnd, 0);
	    _DeleteBrushIfNotInCache(oldBrush, __LINE__);
	}
	clr = st2RGB(__intVal(aColorIndex), 0);
	SetWindow_viewBgColor(hWnd, clr);

	RETURN (self);
    }
%}
!

setWindowBackgroundPixmap:aPixmapId in:aWindowId
    "set the windows background pattern to be a form.
     This is the pattern with which the view is filled whenever exposed.
     Do not confuse this with the background drawing color, which is used
     with opaque drawing.
     NOTICE: due to the limitations of WIN95,
	     background pixmaps which are not 8x8 pixels in size,
	     are handled by smalltalk code in the WIN95 version."

%{
    if (__isExternalAddress(aWindowId)) {
	HWND hWnd = _HWNDVal(aWindowId);
	HBITMAP pixmap;
	HBRUSH oldBrush, newBrush;

	if (__isExternalAddress(aPixmapId))
	    pixmap = _HBITMAPVAL(aPixmapId);
	else
	    pixmap = 0;

	oldBrush = GetWindow_viewBgBrush(hWnd);
	if (oldBrush) {
	    SetWindow_viewBgBrush(hWnd, 0);
	    _DeleteBrushIfNotInCache(oldBrush, __LINE__);
	}
	if (pixmap) {
	    newBrush = CreatePatternBrush(pixmap);
	    SetWindow_viewBgBrush(hWnd, newBrush);
/*
 *            SetBrushOrgEx(hDC, gcData->maskOrgX, gcData->maskOrgY, 0);
 */
	}

	RETURN (self);
    }
%}.
!

setWindowBorderColor:aColorIndex in:aWindowId
    "set the windows border color.
     NOTICE: borders are not supported by the win32 version."

%{  /* NOCONTEXT */
    DPRINTF(("WinWorkstation [info]: setWindowBorderColor:in: not (yet) implemented\n"));

    if (__isExternalAddress(aWindowId)
     && __isSmallInteger(aColorIndex)) {
	HWND win = _HWNDVal(aWindowId);
	int clr;

	if (GetParent(win) != 0) {
	    clr = st2RGB(__intVal(aColorIndex), 0);
	    SetWindow_bdColor(win, clr);

	    {
		/*
		 * force a redraw - even if we do not support
		 * border colors ... (see UIPainter code)
		 */
		RECT rect;
		HRGN rgn;

		GetWindowRect(win, &rect);
		rgn = CreateRectRgn(rect.left, rect.top, rect.right, rect.bottom);
		DefWindowProcW(win, WM_NCPAINT, (WPARAM)rgn, 0);
		_DeleteObject(rgn, __LINE__);
	    }
	}
    }
%}.
!

setWindowBorderPixmap:aPixmapId in:aWindowId
    "set the windows border pattern.
     NOTICE: border pixmaps are not supported by the win32 version."

%{  /* NOCONTEXT */
    DPRINTF(("WinWorkstation [info]: setWindowBorderPixmap:in: not (yet) implemented\n"));
%}.
!

setWindowBorderWidth:aNumber in:aWindowId
    "set a window's border width.
     NOTICE: borderWidths other than 1 are not supported by the win32 version."

%{  /* NOCONTEXT */
    int bw = (aNumber == __MKSMALLINT(0)) ? 0 : 1;

    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);
	int gwl;

	gwl = GetWindowLong(win, GWL_STYLE);
	if (gwl & WS_CHILD) {
	    SetWindow_bw(win, bw);

	    if (bw) {
		gwl |= WS_BORDER;
	    } else {
		gwl &= ~WS_BORDER;
	    }
	    SetWindowLong(win, GWL_STYLE, gwl);

	    /*
	     * force a redraw - even if we do not support
	     * border colors ... (see UIPainter code)
	     */
#if 0
	    PostMessage(win, WM_NCPAINT, 0, 0);
#endif
	    {
		RECT rect;
		HRGN rgn;

		GetWindowRect(win, &rect);
		rgn = CreateRectRgn(rect.left, rect.top, rect.right, rect.bottom);
		DefWindowProcW(win, WM_NCPAINT, (WPARAM)rgn, 0);
		_DeleteObject(rgn, __LINE__);
	    }
	}
    }
%}.
!

setWindowClass:wClass name:wName in:aWindowId
    "define class and name of a window.
     This may be used by the window manager to
     select client specific resources."

%{  /* NOCONTEXT */
    DPRINTF(("WinWorkstation [info]: setWindowClass:name:in: not (yet) implemented\n"));
%}.
!

setWindowGravity:how in:aWindowId
    "set the window gravity - this makes the view to move
     automatically and can avoid redraws (if used properly)"

%{  /* NOCONTEXT */
    int gr = GRAVITY_NONE;

    if (__isExternalAddress(aWindowId)) {
	HWND hWnd = _HWNDVal(aWindowId);
	localWindowInfo *lI;

	if (how == @symbol(South)) {
	    gr = GRAVITY_S;
	} else if (how == @symbol(SouthWest)) {
	    gr = GRAVITY_SW;
	} else if (how == @symbol(SouthEast)) {
	    gr = GRAVITY_SE;
	} else if (how == @symbol(North)) {
	    gr = GRAVITY_N;
	} else if (how == @symbol(NorthWest)) {
	    gr = GRAVITY_NW;
	} else if (how == @symbol(NorthEast)) {
	    gr = GRAVITY_NE;
	} else if (how == @symbol(East)) {
	    gr = GRAVITY_E;
	} else if (how == @symbol(West)) {
	    gr = GRAVITY_W;
	}
	lI = GETLOCALWINDOWINFOPTR(hWnd);
	if (lI) {
	    lI->viewGravity = gr;
	}
    }
%}.
!

setWindowIcon:aForm mask:aMaskForm in:aWindowId
    "set a windows icon & iconMask"

    |wiconId wmaskId wiconHeight wiconWidth|

    aForm notNil ifTrue:[
	wiconId := aForm id.
	wiconHeight := aForm height.
	wiconWidth  := aForm width.
	aMaskForm notNil ifTrue:[
	    wmaskId := aMaskForm id
	].
	self
	    primSetWindowIconId:wiconId
	    maskId:wmaskId
	    width:wiconWidth
	    height:wiconHeight
	    in:aWindowId
    ].
!

setWindowIconWindow:aView in:aWindowId
    "define a window to be used as icon.
     This is not supported with Windows (is it possible at all ?)."

    'WinWorkstation [info]: setWindowIconWindow:in: not implemented' infoPrintCR.
!

setWindowMinExtent:minExt maxExtent:maxExt in:aWindowId
    "set a windows minimum & max extents.
     nil arguments are ignored."

    |minW minH maxW maxH|

    minExt notNil ifTrue:[
	minW := minExt x.
	minH := minExt y.
    ].
    maxExt notNil ifTrue:[
	maxW := maxExt x.
	maxH := maxExt y.
    ].
%{
    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);
	RECT rec;
	int winStyleBits;
	int winExStyleBits;
	localWindowInfo *lI;

	if (win) {
	    winStyleBits = GetWindowLong(win, GWL_STYLE);
	    winExStyleBits = GetWindowLong(win, GWL_EXSTYLE);
	    lI = GETLOCALWINDOWINFOPTR(win);
	    if (! lI) {
		console_fprintf(stderr, "WinWorkstation [info]: oops - no localInfo in setMinMaxExt\n");
		RETURN (self);
	    }

	    if (__bothSmallInteger(minW, minH)) {
		RECT rec;

		rec.left = 0;
		rec.top = 0;
		rec.right = __intVal(minW);
		rec.bottom = __intVal(minH);
#ifdef ADJUSTWINDOW
		AdjustWindowRectEx(&rec, winStyleBits, 0, winExStyleBits);
#endif
		lI->minWidth = rec.right - rec.left;
		lI->minHeight = rec.bottom - rec.top;
	    }
	    if (__bothSmallInteger(maxW, maxH)) {
		RECT rec;

		rec.left = 0;
		rec.top = 0;
		rec.right = __intVal(maxW);
		rec.bottom = __intVal(maxH);
#ifdef ADJUSTWINDOW
		AdjustWindowRectEx(&rec, winStyleBits, 0, winExStyleBits);
#endif
		lI->maxWidth = rec.right - rec.left;
		lI->maxHeight = rec.bottom - rec.top;
	    }
	}
    }
%}
!

setWindowName:aString in:aWindowId
    "define a windows name"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);
	wchar_t nameBuffer[ MAX_LABEL_SIZE ];

	if (__isStringLike(aString)) {
	    ch2wch((char *)__stringVal(aString), nameBuffer, MAX_LABEL_SIZE);
	    SetWindowTextW(win, nameBuffer);
	    RETURN (self);
	}
	if (__isUnicode16String(aString)) {
	    int l = __unicode16StringSize(aString);
	    if (l >= MAX_LABEL_SIZE) l = MAX_LABEL_SIZE-1;
	    memmove(nameBuffer, __unicode16StringVal(aString), l*sizeof(wchar_t));
	    nameBuffer[ l ] = 0;
	    SetWindowTextW(win, nameBuffer);
	    RETURN (self);
	}
    }
%}
    "
     (StandardSystemView new label:'') open
    "
!

setWindowShapeEllipticalX:x Y:y width:w height:h in:aWindowId
    "set the windows shape to an elliptical region"

%{
    if (__isExternalAddress(aWindowId)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(w, h)) {
	HWND win = _HWNDVal(aWindowId);
	int left = __intVal(x);
	int top = __intVal(y);
	int right = left + __intVal(w);
	int bottom = top + __intVal(h);
	HRGN rgn;
	HDC winDC;

	rgn = CreateEllipticRgn(left, top, right, bottom);
	if (rgn) {
	    winDC = GetDCEx(win, 0, DCX_WINDOW);
	    if (winDC) {
#ifdef GDIFLUSH_WHEN_CHANGING_CLIP
		GdiFlush();
#endif
		if (SelectClipRgn(winDC, rgn) == ERROR ) {
		    console_fprintf(stderr, "select clipping region failed\n");
		}
		ReleaseDC(win, winDC);
	    }
	    else
		console_fprintf(stderr, "getDC failed\n");

	    _DeleteObject(rgn, __LINE__);
	}
	else
	    console_fprintf(stderr, "region creation failed\n");
	RETURN ( self );
    }
%}.
    self primitiveFailed
!

topWindowIdsDo:aBlock
    |l|

    l := OrderedCollection new.
    self primEnumWindowsInto:l.
    l do:[:eachWindowId |
	(self getParentWindowIdOfWindowId:eachWindowId) isNil ifTrue:[
	    "/ a topView
	    aBlock value:eachWindowId
	]
    ].
    ^ nil

    "
     Display topWindowIdsDo:[:id |
	|nm|

	nm := String new:100.
	Transcript showCR:id.
	Display primGetWindowText:id into:nm size:nm size-1.
	Transcript showCR:nm.
     ].
    "

    "
     |w|
     Display topWindowIdsDo:[:id |
	|nm|

	nm := String new:100.
	Display primGetWindowText:id into:nm size:nm size-1.
	(nm includesString:'Mortal') ifTrue:[
	    w := id.
	]
     ].
     Display resizeWindow:w width:1024 height:1024
    "
!

unmapWindow:aWindowId
    "make a window invisible"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);

	if (win) {
	    CPRINTF(("unmapWindow %x\n",win));
	    SetWindow_unmapping(win, 1);
	    ShowWindowAsync(win, SW_HIDE);
	}
	RETURN ( self );
    }
%}
!

unmapWindow:aWindowId animation:animationSymbolorNil time:timeInMillisOrNil
    "make a window invisible with some animation effect."

    self animateWindow:aWindowId show:false animation:animationSymbolorNil time:timeInMillisOrNil
!

windowIsIconified:aWindowId
    "return true, if some window is iconified."

%{  /* NOCONTEXT */
    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);

	if (win) {
	    if (GetWindow_iconified(win)) {
		RETURN (true);
	    }
	}
    }
%}.
    ^ false
! !

!WinWorkstation methodsFor:'window stuff-native'!

enableScrollBar:howSymbol in:aWindowId
    "native scrollBar widget access"

%{
    if (__isExternalAddress(aWindowId)) {
	HWND win = _HWNDVal(aWindowId);
	int how;

	if (howSymbol == @symbol(ENABLE_BOTH)) {
	    how = ESB_ENABLE_BOTH;
	} else if (howSymbol == @symbol(DISABLE_LTUP)) {
	    how = ESB_DISABLE_LTUP;
	} else if (howSymbol == @symbol(DISABLE_RTDN)) {
	    how = ESB_DISABLE_RTDN;
	} else if (howSymbol == @symbol(DISABLE_BOTH)) {
	    how = ESB_DISABLE_BOTH;
	} else {
	    RETURN ( self );
	}
	NDPRINTF(("EnableScrollBar(%d)\n", how));
	EnableScrollBar(win, SB_CTL, how);
	RETURN ( self );
    }
%}.
    self primitiveFailed
!

setScrollBarPageSize:sz redraw:redraw in:aWindowId
    "native scrollBar widget access"

%{
    if (__isExternalAddress(aWindowId)
     && __isSmallInteger(sz)) {
	HWND win = _HWNDVal(aWindowId);
	SCROLLINFO info;

	info.cbSize = sizeof(SCROLLINFO);
	info.nPage = __intVal(sz);
	info.fMask = SIF_PAGE;
	NDPRINTF2(("SetScrollPage(%d)\n", __intVal(sz)));
	SetScrollInfo(win, SB_CTL, &info, redraw==true ? 1 : 0);
	RETURN ( self );
    }
%}.
    self primitiveFailed
!

setScrollPosition:newPosition redraw:redraw in:aWindowId
    "native scrollBar widget access"

%{
    if (__isExternalAddress(aWindowId)
     && __isSmallInteger(newPosition)) {
	HWND win = _HWNDVal(aWindowId);

	NDPRINTF2(("SetScrollPos(%d)\n", __intVal(newPosition)));
	SetScrollPos(win, SB_CTL, __intVal(newPosition), redraw==true ? 1 : 0);
	RETURN ( self );
    }
%}.
    self primitiveFailed
!

setScrollRange:min to:max redraw:redraw in:aWindowId
    "native scrollBar widget access"

%{
    if (__isExternalAddress(aWindowId)
     && __bothSmallInteger(min, max)) {
	HWND win = _HWNDVal(aWindowId);

	NDPRINTF2(("SetScrollRange(%d..%d)\n", __intVal(min), __intVal(max)));
	SetScrollRange(win, SB_CTL, __intVal(min), __intVal(max), redraw==true ? 1 : 0);
	RETURN ( self );
    }
%}.
    self primitiveFailed
! !

!WinWorkstation::AlphaBlendParameters methodsFor:'accessing'!

at:index
    ^ self instVarAt:index
!

blueMask
    ^ blueMask
!

blueMask:something
    blueMask := something.
!

greenMask
    ^ greenMask
!

greenMask:something
    greenMask := something.
!

padding
    ^ padding
!

padding:something
    padding := something.
!

redMask
    ^ redMask
!

redMask:something
    redMask := something.
!

sourceAlpha
    ^ sourceAlpha
!

sourceAlpha:something
    sourceAlpha := something.
! !

!WinWorkstation::CopyDataStructStructure class methodsFor:'accessing'!

sizeInBytes
    ExternalAddress pointerSize == 8 ifTrue:[
	^ 24.
    ].
    ^ 12
! !

!WinWorkstation::CopyDataStructStructure class methodsFor:'instance creation'!

new

    ^super new: self sizeInBytes
! !

!WinWorkstation::CopyDataStructStructure methodsFor:'accessing'!

cbData
    ExternalAddress pointerSize == 8 ifTrue:[
	^ self unsignedInt32At: 8 + 1.
    ].
    ^ self unsignedInt32At: 4 + 1.
!

cbData: cbData
    ExternalAddress pointerSize == 8 ifTrue:[
	self unsignedInt32At: 8 + 1  put: cbData.
    ] ifFalse:[
	self unsignedInt32At: 4 + 1  put: cbData.
    ].
!

dwData
    ExternalAddress pointerSize == 8 ifTrue:[
	^ self unsignedInt64At: 0 + 1.
    ].
    ^ self unsignedInt32At: 0 + 1.
!

dwData: dwData
    ExternalAddress pointerSize == 8 ifTrue:[
	self unsignedInt64At: 0 + 1 put:dwData.
    ] ifFalse:[
	self unsignedInt32At: 0 + 1 put:dwData.
    ].
!

lpData
    ExternalAddress pointerSize == 8 ifTrue:[
	^ self unsignedInt64At: 16 + 1.
    ].
    ^ self unsignedInt32At: 8 + 1.
!

lpData: lpData
    ExternalAddress pointerSize == 8 ifTrue:[
	self unsignedInt64At: 16 + 1  put: lpData.
    ] ifFalse:[
	self unsignedInt32At: 8 + 1  put: lpData.
    ].
! !

!WinWorkstation::MonitorInfo methodsFor:'accessing'!

bounds
     "return a rectangle representing the displays bounding box of the monitor"

"/ ******* MULTI SCREEN ******

    ^ Rectangle
	left:screenX
	top:screenY
	width:workW - 1
	height:workH - 1
!

isPrimary
    ^ isPrimary
!

name
    ^ name
!

screenHeight
    ^ screenH
!

screenWidth
    ^ screenW
!

screenX
    ^ screenX
!

screenX:screenXArg screenY:screenYArg screenWidth:screenWArg screenHeight:screenHArg
    workX:workXArg workY:workYArg workWidth:workWArg workHeight:workHArg
    isPrimary:isPrimaryArg name:nameArg

    screenX := screenXArg.
    screenY := screenYArg.
    screenW := screenWArg.
    screenH := screenHArg.
    workX := workXArg.
    workY := workYArg.
    workW := workWArg.
    workH := workHArg.
    isPrimary := isPrimaryArg.
    name := nameArg.
!

screenY
    ^ screenY
!

workHeight
    ^ workH
!

workWidth
    ^ workW
!

workX
    ^ workX
!

workY
    ^ workY
! !

!WinWorkstation::PrinterDeviceContextHandle class methodsFor:'documentation'!

documentation
"
    This is used as a finalization handle for printer contexts

    [see also:]
	DeviceHandle

    [author:]
	Claus Gittinger

"
! !

!WinWorkstation::PrinterDeviceContextHandle methodsFor:'finalization'!

finalize
    "the PrintingContext for which I am a handle has been collected - tell it to Windows"

    |id|

    (id := gcId) notNil ifTrue:[
	gcId := nil.
	device destroyPrinterDC:id.
    ]
! !

!WinWorkstation class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


WinWorkstation initialize!
