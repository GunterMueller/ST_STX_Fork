"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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

XWorkstation subclass:#GLXWorkstation
	instanceVariableNames:'activeWindow hasStereoExtension glOK'
	classVariableNames:'ForceGL'
	poolDictionaries:''
	category:'Interface-Graphics'
!

!GLXWorkstation primitiveDefinitions!
%{
#include "stxOSDefs.h"


#ifdef String
# undef String
#endif
#define String GLX_String

#ifdef Object
# undef Object
#endif
#define Object GLX_Object

#undef True
#undef False

#ifdef Time
# undef Time
#endif
#define Time X_Time


#ifdef __VMS__
# include "vms_Xnames.h"
#endif

#ifdef __arm__
// # define _POSIX_C_SOURCE
#endif

#ifndef _STDIO_H_INCLUDED_
# include <stdio.h>
# define _STDIO_H_INCLUDED_
#endif

#ifdef __arm__
# ifndef _SYS_TYPES_H_INCLUDED_
#  include <sys/types.h>
#  define _SYS_TYPES_H_INCLUDED_
# endif
# ifndef _SYS_SIGNAL_H_INCLUDED_
#  include <sys/signal.h>
#  define _SYS_SIGNAL_H_INCLUDED_
# endif

#endif

#ifdef __osx__
# include <sys/signal.h>
# define DYNAMICALLY_LOADABLE
#endif

#ifdef __linux__
# include <signal.h>
#endif

#include "GL/gl.h"
#include "GL/glx.h"

#define OPENGLCONTEXT GLXContext
#define GLXMAKECURRENT(dpy, draw, con)        glXMakeCurrent(dpy, draw, con)


/*
 * XSGIStereo extension - if available
 */
#ifdef XSGIStereo
# include <X11/extensions/SGIStereo.h>
#endif

typedef enum {
    GLXcolorIndexSingleBuffer,
    GLXcolorIndexDoubleBuffer,
    GLXrgbSingleBuffer,
    GLXrgbDoubleBuffer
} GLXWindowType;

# define ENTERGLX     __BEGIN_PROTECT_REGISTERS__
# define LEAVEGLX     __END_PROTECT_REGISTERS__

/*
 * stupid again - from now on, we need ST/Xs String again
 */
#undef String
#ifdef __DEF_String
# define String __DEF_String
#endif
#undef Object
#ifdef __DEF_Object
# define Object __DEF_Object
#endif

/*
 * mhmh - openGL has its separate gl-context,
 * which is distinct (?) from the windowID.
 * We dont want to add another instvar to View - do we ?
 */
#ifndef MAX_OPENGL_VIEWS
# define MAX_OPENGL_VIEWS      50
#endif

struct windowIDToGLContextMapping {
	Window          win;
	OPENGLCONTEXT   con;
};

static struct windowIDToGLContextMapping windowIDToGLContextMapping[MAX_OPENGL_VIEWS];

static OPENGLCONTEXT
__glxWindowIdToGLContext(xId)
	Window xId;
{
	int i;

	for (i=0; i<MAX_OPENGL_VIEWS; i++) {
	    if (windowIDToGLContextMapping[i].win == xId) {
		return windowIDToGLContextMapping[i].con;
	    }
	}
	return (OPENGLCONTEXT) 0;
}

/*
 * set the GLXWindow for followup drawing
 */
#define SETWIN(aGLXWindowId)                            \
    {                                                   \
	OPENGLCONTEXT context;                          \
							\
	if (_INST(activeWindow) != aGLXWindowId) {      \
	    if (! ISCONNECTED ) {                       \
		RETURN (false);                         \
	    }                                           \
	    if (! __isExternalAddress(aGLXWindowId)) {  \
		RETURN (false);                         \
	    }                                           \
	    context = (OPENGLCONTEXT) __glxWindowIdToGLContext(_WindowVal(aGLXWindowId));       \
	    if (! context) {                            \
		RETURN (false);                         \
	    }                                           \
	    GLXMAKECURRENT(myDpy, _WindowVal(aGLXWindowId), context ); \
	    _INST(activeWindow) = aGLXWindowId;         \
	    __STORE(self, aGLXWindowId);                \
	} else {                                        \
	    if (aGLXWindowId == nil) {                  \
		RETURN (false);                         \
	    }                                           \
	}                                               \
    }




#define Boolean        int
#define TRUE           1
#define FALSE          0
#define Coord          float
#define Icoord         int
#define Scoord         int
#define Colorindex     int
#define Linestyle      int
#define Offset         int
#define Angle          int
#define Screencoord    int

/*
 * some defines - tired of typing ...
 * most of these macros/functions extract values from smalltalk objects or
 * put/pack them into corresponding c variables.
 *
 */
#define myDpy              (Display *)(__MKCP(_INST(displayId)))
#define ISCONNECTED        (_INST(displayId) != nil)
#define _WindowVal(o)      (Window)(__MKCP(o))

#define __MKBOOLEAN(b)     ((b==FALSE) ? false : true)
#define _booleanVal(b)     ((b==false) ? (Boolean)FALSE : (Boolean)TRUE)
#define _coordVal(c)       ((__isFloat(c)) ? (Coord)(_floatVal(c))  : (Coord)(__intVal(c)))
#define _icoordVal(c)      ((Icoord)(__intVal(c)))
#define _scoordVal(c)      ((Scoord)(__intVal(c)))
#define _screencoordVal(c) ((Screencoord)(__intVal(c)))
#define _colorindexVal(c)  ((Colorindex)(__intVal(c)))
#define _linestyleVal(l)   ((Linestyle)(__intVal(l)))
#define _shortVal(l)       ((short)(__intVal(l)))
#define _longVal(l)        ((long)(__intVal(l)))
#define _deviceVal(l)      ((Device)(__intVal(l)))
#define _tagVal(l)         ((Tag)(__intVal(l)))
#define _objectVal(l)      ((GLX_Object)(__intVal(l)))
#define _offsetVal(l)      ((Offset)(__intVal(l)))
#define _rgbVal(l)         ((RGBvalue)(__intVal(l)))
#define _angleVal(c)       ((Angle)(__intVal(c)))

/*
 * check for and fetch a boolean from ST-arg into C-dst
 * ST-object must be true or false. Return from method if invalid.
 */
#define _BOOLEAN_(arg, dst)             \
    if (arg==true)                      \
	dst = (Boolean)TRUE;            \
    else if (arg==false)                \
	dst = (Boolean)FALSE;           \
    else { RETURN(false); }

/*
 * check for and fetch a coord from ST-arg into C-dst
 * ST-object must be Float, SmallInteger or Fraction.
 * Return from method if invalid.
 */
#define _COORD_(arg, dst)               \
    if (__isFloat(arg))                 \
	dst = (Coord)(_floatVal(arg));  \
    else if (__isSmallInteger(arg))     \
	dst = (Coord)(__intVal(arg));    \
    else if (__isFraction(arg)          \
	  && __isSmallInteger(_FractionInstPtr(arg)->f_numerator)       \
	  && __isSmallInteger(_FractionInstPtr(arg)->f_denominator)) {  \
	float n, d;                                                     \
									\
	n = (float)(__intVal(_FractionInstPtr(arg)->f_numerator));       \
	d = (float)(__intVal(_FractionInstPtr(arg)->f_denominator));     \
	dst = (Coord)(n / d);                                           \
    } else { RETURN(false); }

/*
 * check for and fetch an icoord from ST-arg into C-dst
 * ST-object must be SmallInteger. Return from method if invalid.
 */
#define _ICOORD_(arg, dst)              \
    if (__isSmallInteger(arg))          \
      dst = (Icoord)(__intVal(arg));     \
    else { RETURN(false); }

/*
 * check for and fetch an scoord from ST-arg into C-dst
 * ST-object must be SmallInteger. Return from method if invalid.
 */
#define _SCOORD_(arg, dst)              \
    if (__isSmallInteger(arg))          \
      dst = (Scoord)(__intVal(arg));     \
    else { RETURN(false); }

#define _SCREENCOORD_(arg, dst)          \
    if (__isSmallInteger(arg))           \
      dst = (Screencoord)(__intVal(arg)); \
    else { RETURN(false); }

#define _COLORINDEX_(arg, dst)           \
    if (__isSmallInteger(arg))           \
      dst = (Colorindex)(__intVal(arg));  \
    else { RETURN(false); }

#define _ANGLE_(arg, dst)               \
    if (__isSmallInteger(arg))          \
	dst = (Angle)(__intVal(arg));    \
    else { RETURN(false); }

#define _FLOAT_(arg, dst)               \
    if (__isFloat(arg))                 \
	dst = (float)(_floatVal(arg));  \
    else if (__isSmallInteger(arg))     \
	dst = (float)(__intVal(arg));    \
    else if (__isFraction(arg)          \
	  && __isSmallInteger(_FractionInstPtr(arg)->f_numerator)       \
	  && __isSmallInteger(_FractionInstPtr(arg)->f_denominator)) {  \
	float n, d;                                                     \
									\
	n = (float)(__intVal(_FractionInstPtr(arg)->f_numerator));       \
	d = (float)(__intVal(_FractionInstPtr(arg)->f_denominator));     \
	dst = (float)(n / d);                                           \
    } else { RETURN(false); }

#define _INT_(arg, dst)                 \
    if (__isSmallInteger(arg))          \
	dst = (int)(__intVal(arg));      \
    else { RETURN(false); }

#define _indexedArea(object)            \
    (((char *) (_InstPtr(object)))      \
	+ OHDR_SIZE                     \
	+ (__intVal(_ClassInstPtr(__qClass(object))->c_ninstvars)) * sizeof(OBJ))
%}
! !

!GLXWorkstation primitiveVariables!
%{
/*
 * remembered info from private error handler
 */
static char lastErrorMsg[128] = "";
static unsigned INT lastRequestCode = 0;
static unsigned INT lastMinorCode = 0;
static unsigned INT lastResource = 0;

%}
! !

!GLXWorkstation primitiveFunctions!
%{

#ifdef DYNAMICALLY_LOADABLE
/*
 * catch X-errors and forward as errorInterrupt:#DisplayError,
 * (which itself invokes my handler and optionally raises an exception)
 * the implementation below is somewhat wrong: it will
 * report all errors for Display, even though there could be
 * more than one display connection. (being fixed, new errorInterrupt mechanism
 * allows passing an additional argument, which is the displayID ...)
 *
 * this duplicates the functionality as found in XWorkstation;
 * the reason is to allow dynamic loading systems to load this module
 * before XWorkstation (which was not possible otherwise, due to unresolved
 * external references while loading this one)
 */
static int
__XErrorHandler__(Display *dpy, XErrorEvent *event)
    ;
{
    XGetErrorText(dpy, event->error_code, lastErrorMsg, 80);
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

    if (@global(ErrorPrinting) == true) {
	console_fprintf(stderr, "GLXWORKSTAT: x-error caught maj=%d (0x%x) min=%d (0x%x) resource=%x\n",
			event->request_code, event->request_code,
			event->minor_code, event->minor_code, event->resourceid);
	console_fprintf(stderr, "GLXWORKSTAT: x-error message is [%d] '%s'\n", event->error_code, lastErrorMsg);
    }

    __errorInterruptWithIDAndParameter__(@symbol(DisplayError), __MKOBJ(dpy));
    return 0;
}
#else
extern int __XErrorHandler__(Display *dpy, XErrorEvent *event);
#endif

/*
 * begin moved from GLXsupport.c
 */

/*
 * This provides a helper function "GLXCreateWindow", which does
 * all the necessary magic to create an X window suitable for GL drawing
 * to take place within. See the definition of GLXCreateWindow for a
 * description of how to call it.
 *
 * claus: I really had no time to look into all this,
 * this file has been just copied from a 4Dgifts demo ..
 * (will need more than a day to show more ...)
 */
#if !defined(OPENGL)

# include        <X11/Xlib.h>
# include        <X11/Xutil.h>
# ifndef VGL
#  include        <gl/glws.h>
# endif
# ifndef _SIGNAL_H_INCLUDED_
#  include        <signal.h>
# endif
# include        <setjmp.h>
# include        "stcIntern.h"

/*
 * glxhelper.h:
 *
 *   List of drawing modes supported by GLXCreateWindow (in glxhelper.c).
 * More than this are possible with mixed model, but this is just an
 * example.  You can either expand this list (and the corresponding code in
 * GLXCreateWindow) or call the mixed model calls yourself, using
 * GLXCreateWindow as an example.
 */

static char *
typeToName[] = {
    "color index single buffer",
    "color index double buffer",
    "rgb single buffer",
    "rgb double buffer",
};

#endif /* GLX || VGL */

#if defined(GLX) && !defined(VGL)
/*
 * Dorky little helper function used to build up a GLXconfig array.
 */

static void
set_entry (GLXconfig* ptr, int b, int m, int a)
{
    ptr->buffer = b;
    ptr->mode = m;
    ptr->arg = a;
}
#endif /* GLX & not VGL */

static stx_jmp_buf errorReturn;

static void
glAbort() {
    stx_longjmp(errorReturn, 1);
}

/*
 * GLXCreateWindow(dpy, parent, x, y, w, h, boderWidth, type)
 *
 * Return value is the X window id of the newly created window.
 *
 * Arguments are:
 *      dpy             The X "Display*" returned by XOpenDisplay
 *      parent          The parent of the newly created window,
 *                      a typical value for this is
 *                      RootWindow(dpy, DefaultScreen(dpy))
 *      x,y             The location of the window to be created,
 *                      y coordinate is measured from the top down.
 *      w,h             size of the new window
 *      borderWidth     the X border size for this window, should probably
 *                      be zero.
 *      type            the GLXWindowType (see glxhelper.h) desribing the
 *                      typer of GL drawing to be done in this window
 */
Window
__GLXCreateWindow(dpy, parent, x, y, w, h, borderWidth, type)
    Display* dpy;
    Window parent;
    GLXWindowType type;
{
#if !defined(OPENGL)
# ifndef VGL
    GLXconfig params[50];
    GLXconfig* next;
    GLXconfig* retconfig;
    Colormap cmap = DefaultColormap(dpy, DefaultScreen(dpy));
# endif
#endif
    Visual visual;
    XVisualInfo *vis;
    XVisualInfo template;
    XColor white;
    XSetWindowAttributes cwa;
    XWindowAttributes   pwa;
    int scr, i, nret;
    Window win;
#ifdef HAS_SIGACTION
    struct sigaction oldSigSegv, newSigSegv;
#else
    void *oldSigSegv;
#endif

#if !defined(OPENGL)
    __catchExit(1);
#endif

    if (stx_setjmp(errorReturn)) {
	console_fprintf(stderr, "hard error in GL - return\n");
#ifdef SIGSEGV
# ifdef HAS_SIGACTION
	sigaction(SIGSEGV, &oldSigSegv, 0);
# else
	signal(SIGSEGV, oldSigSegv);
# endif
#endif

#if !defined(OPENGL)
	__catchExit(0);
#endif
	return 0;
    }
    __CONT__

    if (w <= 0) {
	console_fprintf(stderr, "GL: bad width: %d\n", w);
	w = 1;
    }
    if (h <= 0) {
	console_fprintf(stderr, "GL: bad height: %d\n", h);
	h = 1;
    }

#if !defined(OPENGL)
# ifdef VGL
    /*
     * I know what VGL supports; its somewhat unclean to hard code it here
     */
    switch (type) {
      case GLXcolorIndexSingleBuffer:
      case GLXcolorIndexDoubleBuffer:
	break;

      case GLXrgbSingleBuffer:
      case GLXrgbDoubleBuffer:
	console_fprintf(stderr, "Sorry, VGL can't support %s type of windows\n", typeToName[type]);
	__catchExit(0);
	return 0;
    }

    scr = DefaultScreen(dpy);
    visual.visualid = CopyFromParent;
    cwa.border_pixel = 0;  /* Even if we don't use it, it must be something */
    win = XCreateWindow(dpy, parent, x, y, w, h,
			     borderWidth, DisplayPlanes(dpy, scr),
			     InputOutput, &visual,
			     CWBorderPixel, &cwa);

    /*
     * on some, seg-violations occur in the GL, if too many
     * views are created ... just to make certain, we catch those
     * in GL too.
     */
#  ifdef SIGSEGV
#   ifdef HAS_SIGACTION
    sigaction(SIGSEGV, (struct sigaction *)0, &oldSigSegv);
    newSigSegv = oldSigSegv;
    newSigSegv.sa_handler = glAbort;
    sigaction(SIGSEGV, &newSigSegv, (struct sigaction *)0);
#   else
    oldSigSegv = signal(SIGSEGV, glAbort);
#   endif
#  endif

    i = GLXlink(dpy, win);

#  ifdef SIGSEGV
#   ifdef HAS_SIGACTION
    sigaction(SIGSEGV, &oldSigSegv, (struct sigaction *)0);
#   else
    signal(SIGSEGV, oldSigSegv);
#   endif
#  endif

    if (i < 0) {
	console_fprintf(stderr, "GLXlink returned %d\n", i);
	__catchExit(0);
	return 0;
    }

# else /* not VGL */

    /*
     * This builds an array in "params" that describes for GLXgetconfig(3G)
     * the type of GL drawing that will be done.
     */
    next = params;
    switch (type) {
      case GLXcolorIndexSingleBuffer:
	set_entry(next++, GLX_NORMAL, GLX_RGB, FALSE);
	set_entry(next++, GLX_NORMAL, GLX_DOUBLE, FALSE);
	break;
      case GLXcolorIndexDoubleBuffer:
	set_entry(next++, GLX_NORMAL, GLX_RGB, FALSE);
	set_entry(next++, GLX_NORMAL, GLX_DOUBLE, TRUE);
	break;
      case GLXrgbSingleBuffer:
	set_entry(next++, GLX_NORMAL, GLX_RGB, TRUE);
	set_entry(next++, GLX_NORMAL, GLX_DOUBLE, FALSE);
	break;
      case GLXrgbDoubleBuffer:
	set_entry(next++, GLX_NORMAL, GLX_RGB, TRUE);
	set_entry(next++, GLX_NORMAL, GLX_DOUBLE, TRUE);
	break;
    }
    set_entry(next, 0, 0, 0); /* The input to GLXgetconfig is null terminated */

    /*
     * Get configuration data for a window based on above parameters
     * First we have to find out which screen the parent window is on,
     * then we can call GXLgetconfig()
     */
    XGetWindowAttributes(dpy, parent, &pwa);
    retconfig = GLXgetconfig(dpy, XScreenNumberOfScreen(pwa.screen), params);
    if (retconfig == 0) {
	console_fprintf(stderr, "Sorry, can't support %s type of windows\n", typeToName[type]);
	__catchExit(0);
	return 0;
    }

    /*
     * Scan through config info, pulling info needed to create a window
     * that supports the rendering mode.
     */
    for (next = retconfig; next->buffer; next++) {
	unsigned long buffer = next->buffer;
	unsigned long mode = next->mode;
	unsigned long value = next->arg;
	switch (mode) {
	  case GLX_COLORMAP:
	    if (buffer == GLX_NORMAL) {
		cmap = value;
	    }
	    break;
	  case GLX_VISUAL:
	    if (buffer == GLX_NORMAL) {
		template.visualid = value;
		template.screen = DefaultScreen(dpy);
		vis = XGetVisualInfo(dpy, VisualScreenMask|VisualIDMask,
					  &template, &nret);
	    }
	    break;
	}
    }

    /*
     * Create the window
     */
    cwa.colormap = cmap;
    cwa.border_pixel = 0;  /* Even if we don't use it, it must be something */
    win = XCreateWindow(dpy, parent, x, y, w, h,
			     borderWidth, vis->depth, InputOutput, vis->visual,
			     CWColormap|CWBorderPixel, &cwa);

    /*
     * Rescan configuration info and find window slot that getconfig
     * provided.  Fill it in with the window we just created.
     */
    for (next = retconfig; next->buffer; next++) {
	if ((next->buffer == GLX_NORMAL) && (next->mode == GLX_WINDOW)) {
	    next->arg = win;
	    break;
	}
    }

    /*
     * Now "retconfig" contains all the information the GL needs to
     * configure the window and its own internal state.
     */
    /*
     * on iris, seg-violations occur in the GL, if too many
     * views are created ...
     */
#  ifdef SIGSEGV
#   ifdef HAS_SIGACTION
    sigaction(SIGSEGV, (struct sigaction *)0, &oldSigSegv);
    newSigSegv = oldSigSegv;
    newSigSegv.sa_handler = glAbort;
    sigaction(SIGSEGV, &newSigSegv, (struct sigaction *)0);
#   else
    oldSigSegv = signal(SIGSEGV, glAbort);
#   endif
#  endif

    i = GLXlink(dpy, retconfig);

#  ifdef SIGSEGV
#   ifdef HAS_SIGACTION
    sigaction(SIGSEGV, &oldSigSegv, (struct sigaction *)0);
#   else
    signal(SIGSEGV, oldSigSegv);
#   endif
#  endif

    if (i < 0) {
	console_fprintf(stderr, "GLXlink returned %d\n", i);
	__catchExit(0);
	return 0;
    }

    /*
     * The GL sets its own X error handlers, which exits - this is not what we want
     */
    XSetErrorHandler(__XErrorHandler__);
# endif /* not VGL */
    __catchExit(0);

#else /* OPENGL | MESA */

    scr = DefaultScreen(dpy);
    visual.visualid = CopyFromParent;
    cwa.border_pixel = 0;  /* Even if we don't use it, it must be something */
    win = XCreateWindow(dpy, parent, x, y, w, h,
			     borderWidth, DisplayPlanes(dpy, scr),
			     InputOutput, &visual,
			     CWBorderPixel, &cwa);

    vis = XGetVisualInfo(dpy, VisualScreenMask|VisualIDMask, &visual, &nret);
    console_fprintf(stderr, "vis is %x\n", vis);
#endif /* GLX || VGL */

    return win;
}

__GLXUnlinkWindow(dpy, win)
    Display* dpy;
    Window win;
{
    /*
     * only needed for VGL - GLX does it automatically
     */
#ifdef VGL
    GLXunlink(dpy, win);
#endif
}

/*
 * helper for rotation - calls rot()
 */
OBJ
__glx_doRotate(angle, axis)
    OBJ angle;
    char axis;
{
    float f_angle;

    if (__isFloat(angle)) {
	f_angle = (float)(_floatVal(angle));
	if (f_angle != 0.0) {
#ifdef OPENGL
#else
	    rot(f_angle, axis);
#endif
	}
	return (true);
    }
    if (__isFraction(angle)
     && __isSmallInteger(_FractionInstPtr(angle)->f_numerator)
     && __isSmallInteger(_FractionInstPtr(angle)->f_denominator)) {
	float n, d;

	n = (float)(__intVal(_FractionInstPtr(angle)->f_numerator));
	d = (float)(__intVal(_FractionInstPtr(angle)->f_denominator));
	f_angle = n / d;
	if (f_angle != 0.0) {
#ifdef OPENGL
#else
	    rot(f_angle, axis);
#endif
	}
	return (true);
    }
    if (__isSmallInteger(angle)) {
	f_angle = (float)(__intVal(angle));
	if (f_angle != 0.0) {
#ifdef OPENGL
#else
	    rot(f_angle, axis);
#endif
	}
	return (true);
    }
    return false;
}

/*
 * fetch integers from an st-array (elements must be smallIntegers)
 */
long *
__glx_getLongsFromInto(obj, vec, count)
   OBJ obj;
   long *vec;
{
    OBJ cls, o;
    int nByte, i, ninstVars, nInstBytes;
    char *pElem;

    if (! _isNonNilObject(obj)) return (long *)NULL;
    cls = __qClass(obj);
    ninstVars = __intVal(_ClassInstPtr(cls)->c_ninstvars);
    nInstBytes = OHDR_SIZE + ninstVars * sizeof(OBJ);
    nByte = __qSize(obj) - nInstBytes;
    pElem = (char *)(_InstPtr(obj)) + nInstBytes;
    if (nByte < (count * sizeof(OBJ))) return (long *)NULL;
    for (i=0; i<count; i++) {
	o = *(OBJ *)pElem;
	if (! __isSmallInteger(o)) return (long *)NULL;
	vec[i] = (long)__intVal(o);
	pElem += sizeof(OBJ);
    }
    return vec;
}

/*
 * fetch shorts from an st-array (elements must be smallIntegers)
 */
short *
__glx_getShortsFromInto(obj, vec, count)
   OBJ obj;
   short *vec;
{
    OBJ cls, o;
    int nByte, i, ninstVars, nInstBytes;
    char *pElem;

    if (! _isNonNilObject(obj)) return (short *)NULL;
    cls = __qClass(obj);
    ninstVars = __intVal(_ClassInstPtr(cls)->c_ninstvars);
    nInstBytes = OHDR_SIZE + ninstVars * sizeof(OBJ);
    nByte = __qSize(obj) - nInstBytes;
    pElem = (char *)(_InstPtr(obj)) + nInstBytes;
    if (nByte < (count * sizeof(OBJ))) return (short *)NULL;
    for (i=0; i<count; i++) {
	o = *(OBJ *)pElem;
	if (! __isSmallInteger(o)) return (short *)NULL;
	vec[i] = (short)__intVal(o);
	pElem += sizeof(OBJ);
    }
    return vec;
}

/*
 * fetch floats from an st-object into a c-float array
 * which may be a floatArray, doubleArray or array-of-something,
 * where something may be a float, fraction or smallInteger,
 */
float *
__glx_getFloatsFromInto(obj, vec, count)
   OBJ obj;
   float *vec;
{
    OBJ cls;
    int nByte;
    OBJ o;
    int i, ninstVars, nInstBytes;
    char *pElem;

    if (! _isNonNilObject(obj)) return (float *)0;

    cls = __qClass(obj);
    ninstVars = __intVal(_ClassInstPtr(cls)->c_ninstvars);
    nInstBytes = OHDR_SIZE + ninstVars * sizeof(OBJ);
    nByte = __qSize(obj) - nInstBytes;
    pElem = (char *)(_InstPtr(obj)) + nInstBytes;

    switch (__intVal(_ClassInstPtr(cls)->c_flags) & ARRAYMASK) {
      case FLOATARRAY:
	/*
	 * best speed for float array
	 * - the data is already as we want it
	 */
	if (nByte < (count * sizeof(float))) return (float *)0;
	return (float *)pElem;

      case DOUBLEARRAY:
	/*
	 * for double array, have to copy-and-cast
	 */
	if (nByte < (count * sizeof(double))) return (float *)0;
	for (i=0; i<count; i++) {
	    vec[i] = *((double *)pElem);
	    pElem += sizeof(double);
	}
	return vec;

      case POINTERARRAY:
	/*
	 * for other array, have to fetch, check and store
	 * the elements can be floats, smallintegers or fractions
	 */
	if (nByte < (count * sizeof(OBJ))) return (float *)0;
	/* get elements one-by-one */
	for (i=0; i<count; i++) {
	    o = *(OBJ *)pElem;
	    if (__isFloat(o)) {
		vec[i] = _floatVal(o);
	    } else if (__isSmallInteger(o)) {
		vec[i] = (float)(__intVal(o));
	    } else if (__isFraction(o)
		    && __isSmallInteger(_FractionInstPtr(o)->f_numerator)
		    && __isSmallInteger(_FractionInstPtr(o)->f_denominator)) {
		float n, d;

		n = (float)(__intVal(_FractionInstPtr(o)->f_numerator));
		d = (float)(__intVal(_FractionInstPtr(o)->f_denominator));
		vec[i] = n / d;
	    } else
		return 0;
	    pElem += sizeof(OBJ);
	}
	return vec;
    }
    return (float *)0;
}

/*
 * fetch doubles from an st-object into a c-double array
 * which may be a floatArray, doubleArray or array-of-something,
 * where something may be a float, fraction or smallInteger,
 */
double *
__glx_getDoublesFromInto(obj, vec, count)
   OBJ obj;
   double *vec;
{
    OBJ cls, o;
    int nByte, i, ninstVars, nInstBytes;
    char *pElem;

    if (! _isNonNilObject(obj)) return (double *)0;
    cls = __qClass(obj);
    ninstVars = __intVal(_ClassInstPtr(cls)->c_ninstvars);
    nInstBytes = OHDR_SIZE + ninstVars * sizeof(OBJ);
    nByte = __qSize(obj) - nInstBytes;
    pElem = (char *)(_InstPtr(obj)) + nInstBytes;

    switch (__intVal(_ClassInstPtr(cls)->c_flags) & ARRAYMASK) {
      case DOUBLEARRAY:
	/* best speed for double array - the data is already as we want it */
	if (nByte < (count * sizeof(double))) return (double *)0;
	return (double *)pElem;

      case FLOATARRAY:
	if (nByte < (count * sizeof(float))) return (double *)0;
	for (i=0; i<count; i++) {
	    vec[i] = *((float *)pElem);
	    pElem += sizeof(float);
	}
	return vec;

      case POINTERARRAY:
	if (nByte < (count * sizeof(OBJ))) return (double *)0;
	/* get elements one-by-one */
	for (i=0; i<count; i++) {
	    o = *(OBJ *)pElem;
	    if (__isFloat(o))
		vec[i] = _floatVal(o);
	    else if (__isSmallInteger(o))
		vec[i] = (double)(__intVal(o));
	    else if (__isFraction(o)
		     && __isSmallInteger(_FractionInstPtr(o)->f_numerator)
		     && __isSmallInteger(_FractionInstPtr(o)->f_denominator)) {
		double n, d;

		n = (double)(__intVal(_FractionInstPtr(o)->f_numerator));
		d = (double)(__intVal(_FractionInstPtr(o)->f_denominator));
		vec[i] = n / d;

	    } else
		return 0;
	    pElem += sizeof(OBJ);
	}
	return vec;
    }
    return (double *)0;
}

/*
 * move from a c-float array into an st-object,
 * the st-object MUST be either a float- or double array
 */
__glx_putFloatsFromInto(vec, obj, count)
   OBJ obj;
   float *vec;
{
    OBJ cls;
    int nByte;
    OBJ o;
    int i, ninstVars, nInstBytes;
    char *pElem;

    if (! _isNonNilObject(obj)) return 0;

    cls = __qClass(obj);
    ninstVars = __intVal(_ClassInstPtr(cls)->c_ninstvars);
    nInstBytes = OHDR_SIZE + ninstVars * sizeof(OBJ);
    nByte = __qSize(obj) - nInstBytes;
    pElem = (char *)(_InstPtr(obj)) + nInstBytes;

    switch (__intVal(_ClassInstPtr(cls)->c_flags) & ARRAYMASK) {
      case FLOATARRAY:
	if (nByte < (count * sizeof(float))) return 0;
	for (i=0; i<count; i++) {
	    *(float *)pElem = vec[i];
	    pElem += sizeof(float);
	}
	return 1;

      case DOUBLEARRAY:
	if (nByte < (count * sizeof(float))) return 0;
	for (i=0; i<count; i++) {
	    *(double *)pElem = vec[i];
	    pElem += sizeof(double);
	}
	return 1;
    }
    /* not implemented for others */

    return 0;
}

#ifndef OPENGL

Matrix *
__glx_getFloatsFromMatrixInto(obj, mp)
    OBJ obj;
    Matrix *mp;
{
    OBJ cls;
    int nByte;
    OBJ o;
    int ninstVars, nInstBytes;
    char *pElem;
    int x = 0;
    int i,j;

    if (! _isNonNilObject(obj)) return (Matrix *)0;

    cls = __qClass(obj);
    ninstVars = __intVal(_ClassInstPtr(cls)->c_ninstvars);
    nInstBytes = OHDR_SIZE + ninstVars * sizeof(OBJ);
    nByte = __qSize(obj) - nInstBytes;
    pElem = (char *)(_InstPtr(obj)) + nInstBytes;

    switch (__intVal(_ClassInstPtr(cls)->c_flags) & ARRAYMASK) {
	case FLOATARRAY:
	    /*
	     * very easy for FLOATARRAY objects - no copying needed
	     */
	    if (nByte < (16 * sizeof(float))) return (Matrix *)0;
	    return (Matrix *) _FloatArrayInstPtr(obj)->f_element;

	case DOUBLEARRAY:
	    /*
	     * for DOUBLEARRAY objects copy and cast
	     */
	    if (nByte < (16 * sizeof(double))) return (Matrix *)0;
	    for (i=0; i<4; i++) {
		for (j=0; j<4; j++) {
		    (*mp)[i][j] = _DoubleArrayInstPtr(obj)->d_element[x];
		    x++;
		}
	    }
	    return mp;

	case POINTERARRAY:
	    if (nByte < (16 * sizeof(OBJ))) return (Matrix *)0;
	    /*
	     * get elements one-by-one
	     */
	    for (i=0; i<4; i++) {
		for (j=0; j<4; j++) {
		    o = _ArrayInstPtr(obj)->a_element[x];
		    if (__isFloat(o)) {
			(*mp)[i][j] = _floatVal(o);
		    } else if (__isSmallInteger(o)) {
			(*mp)[i][j] = (double)__intVal(o);
		    } else if (__isFraction(o)
			&& __isSmallInteger(_FractionInstPtr(o)->f_numerator)
			&& __isSmallInteger(_FractionInstPtr(o)->f_denominator)) {
			double n, d;

			n = (double)(__intVal(_FractionInstPtr(o)->f_numerator));
			d = (double)(__intVal(_FractionInstPtr(o)->f_denominator));
			(*mp)[i][j] = n / d;
		    } else
			return (Matrix *)0;
		    x++;
		}
	    }
	    return mp;
    }
    return (Matrix *)0;
}

#endif

float*
__glx_getFloatsFromFloatArrayInto(obj, fp)
    OBJ obj;
    float *fp;
{
    OBJ cls;
    int ninstVars;

    if (! _isNonNilObject(obj)) return (float *)0;
    cls = __qClass(obj);
    if (cls == @global(FloatArray))
	return _FloatArrayInstPtr(obj)->f_element;

    if ((__intVal(_ClassInstPtr(cls)->c_flags) & ARRAYMASK) == FLOATARRAY) {
	ninstVars = __intVal(_ClassInstPtr(cls)->c_ninstvars);
	return (float *) &(_InstPtr(obj)->i_instvars[ninstVars]);
    }

    /*
     * need more here (i.e. convert from array-of-floats)
     */
    return (float *)0;
}

%}
! !

!GLXWorkstation class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    this class was originally written as a demo on how an interface to
    a c graphics library could be implemented. In the mean time, it has become
    quite complete ...

    It provides an interface to either a real GL (on SGI workstations)
    or a simulated VGL (i.e. GL-light; low nicotine).
    The GL simulation is derived from the PD vogl library, with slight
    modifictions to support multiple GL views.

    Most of the hard work was done by Jeff (thanks indeed) ...


    Some notes:

    I do not really know what most of these functions do - for more
    detail, see the GL man pages (on SGI) or the doc provided with VGL.

    The interface offered here provides a very very low level (i.e one-to-one)
    interface to GL functions. More high-level stuff is required, to make
    3D drawing be more object-oriented.
    (see a bit of this in 'clients/IRIS-specials')

    Some functions are duplicated, Jeff and I developed those in parallel -
    for now, both will remain - finally they will be merged and duplicates removed ...
    (examples are makeobj and makeObject).

    Also, in a hurry to implement all those methods, many do no or only
    limited argument checking - make certain, that you pass the correct
    arguments.

    There might be some confusion in the v3[sifd] functions: basically they
    all do the same, and could be mapped onto one st-method (such as vertex3).
    However, the C-functions expect different argument types - I don't know if
    one or another of these functions suffers from any performance penalties.
    Therefore, I leave the direct 1-to-1 mapping; GL experts might know more
    about this (I use v3f in all of my code).

    written june 93 by claus
    VGL stuff dec 93
    many many additions jan 94 by Jeff McAffer <jeff@is.s.u-tokyo.ac.jp>

    Since this is a demo (consider it a free add-on goody) there is
    *** NO WARRANTY ** for this.

    Notice: this should be rewritten to use the openGL library functions
    (actually, to not loose the VGL interface, another OpenGLWorkstation
     class should be written)

    [author:]
        Claus Gittinger
        Jeff McAffer
"
! !

!GLXWorkstation class methodsFor:'error handling'!

errorStringOfLastError
%{
#ifdef DYNAMICALLY_LOADABLE
    RETURN ( __MKSTRING(lastErrorMsg) );
#endif
%}.

    ^ super errorStringOfLastError.
!

minorCodeOfLastError
%{  /* NOCONTEXT */
#ifdef DYNAMICALLY_LOADABLE
    RETURN ( __MKSMALLINT(lastMinorCode) );
#endif
%}.

    ^ super minorCodeOfLastError.
!

requestCodeOfLastError
%{  /* NOCONTEXT */
#ifdef DYNAMICALLY_LOADABLE
    RETURN ( __MKSMALLINT(lastRequestCode) );
#endif
%}.

    ^ super requestCodeOfLastError.
!

resourceIdOfLastError
%{  /* NOCONTEXT */
#ifdef DYNAMICALLY_LOADABLE
    if (lastResource != 0) {
       RETURN ( __MKEXTERNALADDRESS(lastResource) );
    }
    RETURN ( nil );
#endif
%}.

    ^ super resourceIdOfLastError.
! !

!GLXWorkstation class methodsFor:'misc'!

forceGL:aBoolean
    ForceGL := aBoolean.
    AllScreens notNil ifTrue:[
	AllScreens do:[:screen | screen initializeScreenProperties]
    ].
! !

!GLXWorkstation methodsFor:'arcs and circles'!

glxArcX:x y:y radius:radius startang:startang endang:endang in: aGLXWindowId
    "draw an arc at a given location.
     The x/y/radius args may be floats, fractions or smallIntegers.
     startang and endang must be smallIntegers (10th of a degree)."

%{  /* NOCONTEXT */
    Coord c_x, c_y, c_radius;
    Angle a_startang, a_endang;

    _COORD_(x, c_x)
    _COORD_(y, c_y)
    _COORD_(radius, c_radius)
    _ANGLE_(startang, a_startang)
    _ANGLE_(endang, a_endang)

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    arc(c_x, c_y, c_radius, a_startang, a_endang);
#endif
%}

    "Modified: 19.3.1996 / 18:43:52 / cg"
!

glxArcfX:x y:y radius:radius startang:startang endang:endang in: aGLXWindowId
    "draw a filled arc.
     The x/y/radius args may be floats, fractions or smallIntegers.
     startang and endang must be smallIntegers (10th of a degree)."

%{  /* NOCONTEXT */
    Coord c_x, c_y, c_radius;
    Angle a_startang, a_endang;

    _COORD_(x, c_x)
    _COORD_(y, c_y)
    _COORD_(radius, c_radius)
    _ANGLE_(startang, a_startang)
    _ANGLE_(endang, a_endang)

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    arcf(c_x, c_y, c_radius, a_startang, a_endang);
#endif
%}
!

glxArcfiX: x y: y radius: radius startang: startang endang: endang in: aGLXWindowId
    "draw a filled arc.
     All arguments must be smallIntegers."

%{  /* NOCONTEXT */
    Icoord c_x, c_y, c_radius;
    Angle a_startang, a_endang;

    _ICOORD_(x, c_x)
    _ICOORD_(y, c_y)
    _ICOORD_(radius, c_radius)
    _ANGLE_(startang, a_startang);
    _ANGLE_(endang, a_endang)

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    arcfi(c_x, c_y, c_radius, a_startang, a_endang);
#endif
%}
!

glxArcfsX: x y: y radius: radius startang: startang endang: endang in: aGLXWindowId
    "draw a filled arc.
     All arguments must be (16bit) smallIntegers."

%{  /* NOCONTEXT */
    Scoord c_x, c_y, c_radius;
    Angle a_startang, a_endang;

    _SCOORD_(x, c_x)
    _SCOORD_(y, c_y)
    _SCOORD_(radius, c_radius)
    _ANGLE_(startang, a_startang)
    _ANGLE_(endang, a_endang)

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    arcfs(c_x, c_y, c_radius, a_startang, a_endang);
#endif
%}
!

glxArciX:x y:y radius:radius startang:startang endang:endang in: aGLXWindowId
    "draw an (unfilled) arc.
     All arguments must be smallIntegers."

%{  /* NOCONTEXT */
    Icoord c_x, c_y, c_radius;
    Angle a_startang, a_endang;

    _ICOORD_(x, c_x)
    _ICOORD_(y, c_y)
    _ICOORD_(radius, c_radius)
    _ANGLE_(startang, a_startang)
    _ANGLE_(endang, a_endang)

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    arci(c_x, c_y, c_radius, a_startang, a_endang);
#endif
%}
!

glxArcsX:x y:y radius:radius startang:startang endang:endang in: aGLXWindowId
    "draw an (unfilled) arc.
     All arguments must be (16bit) smallIntegers."

%{  /* NOCONTEXT */
    Scoord c_x, c_y, c_radius;
    Angle a_startang, a_endang;

    _SCOORD_(x, c_x)
    _SCOORD_(y, c_y)
    _SCOORD_(radius, c_radius)
    _ANGLE_(startang, a_startang)
    _ANGLE_(endang, a_endang)

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    arcs(c_x, c_y, c_radius, a_startang, a_endang);
#endif
%}
!

glxCircX:x y:y radius: radius in: aGLXWindowId
    "draw a circle.
     x/y/radius may be floats, fractions or smallIntegers."

%{  /* NOCONTEXT */
    Coord c_x, c_y, c_radius;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    _COORD_ (radius, c_radius)

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    circ(c_x, c_y, c_radius);
#endif
%}
!

glxCircfX: x y: y radius: radius in: aGLXWindowId
    "draw a filled circle.
     x/y/radius may be floats, fractions or smallIntegers."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
    {
	Coord c_x, c_y, c_radius;

	_COORD_ (x, c_x)
	_COORD_ (y, c_y)
	_COORD_ (radius, c_radius)

#ifdef OPENGL
#else
	circf(c_x, c_y, c_radius);
#endif
    }
%}
!

glxCircfiX: x y: y radius: radius in: aGLXWindowId
    "draw a filled circle.
     x/y/radius must be smallIntegers."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
    {
	Icoord c_x, c_y, c_radius;

	_ICOORD_ (x, c_x)
	_ICOORD_ (y, c_y)
	_ICOORD_ (radius, c_radius)

#ifdef OPENGL
#else
	circfi(c_x, c_y, c_radius);
#endif
    }
%}
!

glxCircfsX: x y: y radius: radius in: aGLXWindowId
    "draw a filled circle.
     x/y/radius must be (16bit) smallIntegers."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
    {
	Scoord c_x, c_y, c_radius;

	_SCOORD_ (x, c_x)
	_SCOORD_ (y, c_y)
	_SCOORD_ (radius, c_radius)

#ifdef OPENGL
#else
	circfs(c_x, c_y, c_radius);
#endif
    }
%}
!

glxCirciX: x y: y radius: radius in: aGLXWindowId
    "draw a circle (unfilled).
     x/y/radius must be smallIntegers."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
    {
	Icoord c_x, c_y, c_radius;

	_ICOORD_ (x, c_x)
	_ICOORD_ (y, c_y)
	_ICOORD_ (radius, c_radius)

#ifdef OPENGL
#else
	circi(c_x, c_y, c_radius);
#endif
    }
%}
!

glxCircsX: x y: y radius: radius in: aGLXWindowId
    "draw a circle (unfilled)
     x/y/radius must be (16bit) smallIntegers."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
    {
	Scoord c_x, c_y, c_radius;

	_SCOORD_ (x, c_x)
	_SCOORD_ (y, c_y)
	_SCOORD_ (radius, c_radius)

#ifdef OPENGL
#else
	circs(c_x, c_y, c_radius);
#endif
    }
%}
! !

!GLXWorkstation methodsFor:'attribute stack'!

glxPopattributesIn: aGLXWindowId
    "pop (and forget) the top entry on the attribute stack"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifndef OPENGL
    popattributes();
#endif
%}

    "Modified: 19.3.1996 / 18:42:53 / cg"
!

glxPushattributesIn: aGLXWindowId
    "save the current attributes on the attribute stack"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifndef OPENGL
    pushattributes();
#endif
%}

    "Modified: 19.3.1996 / 18:43:04 / cg"
! !

!GLXWorkstation methodsFor:'character position'!

glxCmov2X: x y: y in: aGLXWindowId
    "change the character position to a 2D point, as passed in x/y.
     The arguments may be floats, fractions or smallIntegers."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
    {
	Coord c_x, c_y;

	_COORD_ (x, c_x)
	_COORD_ (y, c_y)

#ifdef OPENGL
#else
	cmov2(c_x, c_y);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:17:38 / cg"
!

glxCmov2iX: x y: y in: aGLXWindowId
    "change the character position to a 2D point, as passed in x/y.
     The arguments must be smallIntegers."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
    {
	Icoord c_x, c_y;

	_ICOORD_ (x, c_x)
	_ICOORD_ (y, c_y)

#ifdef OPENGL
#else
	cmov2i(c_x, c_y);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:17:43 / cg"
!

glxCmov2sX: x y: y in: aGLXWindowId
    "change the character position to a 2D point, as passed in x/y.
     The arguments must be (16bit) smallIntegers."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
     {
	 Scoord c_x, c_y;

	 _SCOORD_ (x, c_x)
	 _SCOORD_ (y, c_y)

#ifdef OPENGL
#else
	 cmov2s(c_x, c_y);
#endif
     }
%}

    "Modified: 22.3.1996 / 18:17:47 / cg"
!

glxCmovX: x y: y z: z in: aGLXWindowId
    "change the character position to a 3D point, as passed in x/y/z.
     The arguments may be floats, fractions or smallIntegers."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
     {
	Coord c_x, c_y, c_z;

	_COORD_ (x, c_x)
	_COORD_ (y, c_y)
	_COORD_ (z, c_z)

#ifdef OPENGL
#else
	cmov(c_x, c_y, c_z);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:17:22 / cg"
!

glxCmoviX: x y: y z: z in: aGLXWindowId
    "change the character position to a 3D point, as passed in x/y/z.
     The arguments must be smallIntegers."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
    {
	Icoord c_x, c_y, c_z;

	_ICOORD_ (x, c_x)
	_ICOORD_ (y, c_y)
	_ICOORD_ (z, c_z)

#ifdef OPENGL
#else
	cmovi(c_x, c_y, c_z);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:17:55 / cg"
!

glxCmovsX: x y: y z: z in: aGLXWindowId
    "change the character position to a 3D point, as passed in x/y/z.
     The arguments must be (16bit) smallIntegers."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
    {
	Scoord c_x, c_y, c_z;

	_SCOORD_ (x, c_x)
	_SCOORD_ (y, c_y)
	_SCOORD_ (z, c_z)

#ifdef OPENGL
#else
	cmovs(c_x, c_y, c_z);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:17:59 / cg"
!

glxGetcposIn: aGLXWindowId
    "Return the current character position as a point with integer coordinates"

    | x y |
%{
    short s_x, s_y;

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
# ifdef GLX
    getcpos(&s_x, &s_y);
    x = __MKSMALLINT(s_x);
    y = __MKSMALLINT(s_y);
# endif
#endif
%}.
    ^x @ y
! !

!GLXWorkstation methodsFor:'clearing'!

glxClearIn:aGLXWindowId
    "clear to current color"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    clear();
#endif
%}
!

glxCzclearCval:cval zval:zval in:aGLXWindowId
    "clear to a color (cval) and clear z buffer to zval simultaniously"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
# ifdef GLX
    czclear((ulong)__intVal(cval), __intVal(zval));
# endif
#endif
%}
!

glxZClearIn:aGLXWindowId
    "clear z buffer"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
# ifdef GLX
    zclear();
# endif
#endif
%}
! !

!GLXWorkstation methodsFor:'color'!

glxColor:index in:aGLXWindowId
    "set the drawing color;
     for non gouraud shading, we don't care if the argument is integer or float;
     otherwise, better results are expected with float values."

%{  /* NOCONTEXT */

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    if (__isSmallInteger(index)) {
        color((Colorindex)(__intVal(index)));
        RETURN (self);
    }
    if (__isFloat(index)) {
        colorf((float)(_floatVal(index)));
        RETURN (self);
    }
#endif
%}
!

glxColorRed:r green:g blue:b alpha:a in:aGLXWindowId
    "set the drawing color, including alpha value.
     The args must be integer values within 0..255"

%{  /* NOCONTEXT */
    short s_r, s_g, s_b, s_a;

    _INT_(r, s_r);
    _INT_(g, s_g);
    _INT_(b, s_b);
    _INT_(a, s_a);
    SETWIN(aGLXWindowId)
#ifdef GLX
    cpack((((((s_a<<8) | s_b) << 8) | s_g) << 8) | s_r);
#endif
%}
!

glxColorRed:r green:g blue:b in:aGLXWindowId
    "set the drawing color.
     The args must be integer values in 0..255"

%{  /* NOCONTEXT */
    short s_r, s_g, s_b;

    _INT_(r, s_r);
    _INT_(g, s_g);
    _INT_(b, s_b);
    SETWIN(aGLXWindowId)
#ifdef GLX
    RGBcolor(s_r, s_g, s_b);
#endif
%}
!

glxLrgbrangeRmin: rmin gmin: gmin bmin: bmin rmax: rmax gmax: gmax bmax: bmax
    znear: znear zfar: zfar in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    lRGBrange(_shortVal(rmin), _shortVal(gmin), _shortVal(bmin),
	_shortVal(rmax), _shortVal(gmax), _shortVal(bmax),
	_longVal(znear), _longVal(zfar));
#endif
%}
!

glxMapcolorI: i red: red green: green blue: blue in: aGLXWindowId
    "change a color in the color lookup table (i.e. in COLOR_INDEX mode).
     The arguments must be smallIntegers."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    mapcolor(_colorindexVal(i), _shortVal(red), _shortVal(green), _shortVal(blue));
#endif
%}
!

glxTextcolor:tcolor in: aGLXWindowId
    "change the color used for text drawing"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    textcolor(_colorindexVal(tcolor));
#endif
%}
! !

!GLXWorkstation methodsFor:'curves'!

glxCurvebasis: basid in: aGLXWindowId
    "sets the basis type of curves"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    curvebasis(_shortVal(basid));
#endif
%}

    "Modified: 19.3.1996 / 18:47:09 / cg"
!

glxCurveit: iterationcount in: aGLXWindowId
    "Iterates the top matrix on the stack as a forward difference
     matrix, drawing as it goes along."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    curveit(_shortVal(iterationcount));
#endif
%}

    "Modified: 19.3.1996 / 18:48:57 / cg"
!

glxCurveprecision: nsegments in: aGLXWindowId
    "sets the number of line segments that make up a curve segment"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    curveprecision(_shortVal(nsegments));
#endif
%}

    "Modified: 19.3.1996 / 18:47:43 / cg"
! !

!GLXWorkstation methodsFor:'double buffering'!

glxBackBufferIn:aGLXWindowId
    "switch to back buffer drawing - turning frontbuffer drawing off"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
# ifdef GLX
    frontbuffer(FALSE);
# endif
    backbuffer(TRUE);
#endif
%}
!

glxBackbuffer:b in: aGLXWindowId
    "turn backBuffer drawing on/off.
     Notice: VGL is not able to draw into both buffers at the same time ...
	     ... enabling the backbuffer automatically disables frontbuffer drawing
	     and vice versa. This seems not to be the case with a true GL."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    backbuffer(_booleanVal(b));
#endif
%}

    "Modified: 19.3.1996 / 18:45:05 / cg"
!

glxDoubleBufferIn:aGLXWindowId
    "set double buffer mode"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    doublebuffer();
#endif
%}
!

glxFrontBufferIn:aGLXWindowId
    "switch to front buffer drawing - turning backbuffer drawing off"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
# ifdef GLX
    backbuffer(FALSE);
# endif
    frontbuffer(TRUE);
#endif
%}
!

glxFrontbuffer:b in: aGLXWindowId
    "turn on/off frontbuffer drawing.
     Notice: VGL is not able to draw into both buffers at the same time ...
	     ... enabling the backbuffer automatically disables frontbuffer drawing
	     and vice versa. This seems not to be the case with a true GL."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    frontbuffer(_booleanVal(b));
#endif
%}

    "Modified: 19.3.1996 / 18:45:31 / cg"
!

glxSingleBufferIn: aGLXWindowId
    "set single buffer mode"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    singlebuffer();
#endif
%}
!

glxSwapBuffersIn:aGLXWindowId
    "swap the back and front buffers.

     To animate things smoothly, draw into the backBuffer while the frontBuffer is
     displayed and swap them for every frame."

%{  /* UNLIMITEDSTACK */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    swapbuffers();
#endif
%}

    "Modified: 19.3.1996 / 18:45:47 / cg"
! !

!GLXWorkstation methodsFor:'flat drawing'!

glxBeginClosedLineIn:aGLXWindowId
    "start a closed line"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    bgnclosedline();
#endif
%}
!

glxBeginLineIn:aGLXWindowId
    "start a line group"

%{  /* NOCONTEXT STACK:32000 */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    bgnline();
#endif
%}
!

glxBeginPointIn:aGLXWindowId
    "start a point-group"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    bgnpoint();
#endif
%}
!

glxBeginPolygonIn:aGLXWindowId
    "start a polygon"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    bgnpolygon();
#endif
%}
!

glxBeginQuadrilateralStripIn:aGLXWindowId
    "start a quadrilateral strip"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    bgnqstrip();
#endif
%}
!

glxBeginTriangleMeshIn:aGLXWindowId
    "start a triangle mesh"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    bgntmesh();
#endif
%}
!

glxEndClosedLineIn:aGLXWindowId
    "end a closed line"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    endclosedline();
#endif
%}
!

glxEndLineIn:aGLXWindowId
    "end a line group"

%{  /* NOCONTEXT STACK:32000 */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    endline();
#endif
%}
!

glxEndPointIn:aGLXWindowId
    "end a point group"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    endpoint();
#endif
%}
!

glxEndPolygonIn:aGLXWindowId
    "end a polygon"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    endpolygon();
#endif
%}
!

glxEndQuadrilateralStripIn:aGLXWindowId
    "end a quadrilateral strip"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    endqstrip();
#endif
%}
!

glxEndTriangleMeshIn:aGLXWindowId
    "end a triangle mesh"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    endtmesh();
#endif
%}
! !

!GLXWorkstation methodsFor:'graphics position'!

glxMove2:v in: aGLXWindowId
    "change the graphics position to a 2D point, as passed in vector v"

%{  /* NOCONTEXT */
    float vec[2], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 2))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    move2((Coord)(c_v[0]), (Coord)(c_v[1]));
    RETURN (true);
#endif
%}

    "Modified: 22.3.1996 / 18:15:23 / cg"
!

glxMove2X: x y: y in: aGLXWindowId
    "change the graphics position to a 2D point, as passed in x/y"

%{  /* NOCONTEXT */
    {
	Coord c_x, c_y;

	_COORD_ (x, c_x)
	_COORD_ (y, c_y)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	move2(c_x, c_y);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:15:02 / cg"
!

glxMove2iX: x y: y in: aGLXWindowId
    "change the graphics position to a 2D point, as passed in x/y.
     The arguments must be smallIntegers."

%{  /* NOCONTEXT */
    {
	Icoord c_x, c_y;

	_ICOORD_ (x, c_x)
	_ICOORD_ (y, c_y)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	move2i(c_x, c_y);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:15:08 / cg"
!

glxMove2sX: x y: y in: aGLXWindowId
    "change the graphics position to a 2D point, as passed in x/y.
     The arguments must be smallIntegers."

%{  /* NOCONTEXT */
    {
	Scoord c_x, c_y;

	_SCOORD_ (x, c_x)
	_SCOORD_ (y, c_y)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	move2s(c_x, c_y);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:15:13 / cg"
!

glxMove:v in: aGLXWindowId
    "change the graphics position to a 3D point, as passed in vector v"

%{  /* NOCONTEXT */
    {
	float vec[3], *c_v;

	if (! (c_v = __glx_getFloatsFromInto(v, vec, 3))) RETURN(false);
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	move((Coord)(c_v[0]), (Coord)(c_v[1]), (Coord)(c_v[2]));
#endif
    }
%}

    "Modified: 22.3.1996 / 18:14:29 / cg"
!

glxMoveX: x y: y z: z in: aGLXWindowId
    "change the graphics position to a 3D point, as passed in x/y/z"

%{  /* NOCONTEXT */
    {
	Coord c_x, c_y, c_z;

	_COORD_ (x, c_x)
	_COORD_ (y, c_y)
	_COORD_ (z, c_z)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	move(c_x, c_y, c_z);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:14:38 / cg"
!

glxMoveiX: x y: y z: z in: aGLXWindowId
    "change the graphics position to a 3D point, as passed in x/y/z.
     The arguments must be smallIntegers."

%{  /* NOCONTEXT */
    {
	Icoord c_x, c_y, c_z;

	_ICOORD_ (x, c_x)
	_ICOORD_ (y, c_y)
	_ICOORD_ (z, c_z)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	movei(c_x, c_y, c_z);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:14:44 / cg"
!

glxMovesX: x y: y z: z in: aGLXWindowId
    "change the graphics position to a 3D point, as passed in x/y/z.
     The arguments must be smallIntegers."

%{  /* NOCONTEXT */
    {
	Scoord c_x, c_y, c_z;

	_SCOORD_ (x, c_x)
	_SCOORD_ (y, c_y)
	_SCOORD_ (z, c_z)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	moves(c_x, c_y, c_z);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:14:48 / cg"
!

glxRmv2:v in: aGLXWindowId
    "change the graphics position to a 2D point,
     the relative distance is passed in vector v"

%{  /* NOCONTEXT */
    {
	float vec[2], *c_v;

	if (! (c_v = __glx_getFloatsFromInto(v, vec, 2))) RETURN(false);
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rmv2((Coord)(c_v[0]), (Coord)(c_v[1]));
#endif
    }
%}

    "Modified: 22.3.1996 / 18:15:57 / cg"
!

glxRmv2X: x y: y in: aGLXWindowId
    "change the graphics position to a 2D point,
     the relative distance is passed in x/y"

%{  /* NOCONTEXT */
    {
	Coord c_x, c_y;

	_COORD_ (x, c_x)
	_COORD_ (y, c_y)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rmv2(c_x, c_y);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:16:42 / cg"
!

glxRmv2iX: x y: y in: aGLXWindowId
    "change the graphics position to a 2D point,
     the relative distance is passed in x/y.
     The arguments must be smallIntegers."

%{  /* NOCONTEXT */
    {
	Icoord c_x, c_y;

	_ICOORD_ (x, c_x)
	_ICOORD_ (y, c_y)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rmv2i(c_x, c_y);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:16:39 / cg"
!

glxRmv2sX: x y: y in: aGLXWindowId
    "change the graphics position to a 2D point,
     the relative distance is passed in x/y.
     The arguments must be smallIntegers."

%{  /* NOCONTEXT */
    {
	Scoord c_x, c_y;

	_SCOORD_ (x, c_x)
	_SCOORD_ (y, c_y)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rmv2s(c_x, c_y);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:16:33 / cg"
!

glxRmv:v in: aGLXWindowId
    "change the graphics position to a 3D point,
     the relative distance is passed in vector v"

%{  /* NOCONTEXT */
    {
	float vec[3], *c_v;

	if (! (c_v = __glx_getFloatsFromInto(v, vec, 3))) RETURN(false);
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rmv((Coord)(c_v[0]), (Coord)(c_v[1]), (Coord)(c_v[2]));
#endif
    }
%}

    "Modified: 22.3.1996 / 18:16:08 / cg"
!

glxRmvX: x y: y z: z in: aGLXWindowId
    "change the graphics position to a 3D point,
     the relative distance is passed in x/y/z"

%{  /* NOCONTEXT */
    {
	Coord c_x, c_y, c_z;

	_COORD_ (x, c_x)
	_COORD_ (y, c_y)
	_COORD_ (z, c_z)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rmv(c_x, c_y, c_z);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:16:16 / cg"
!

glxRmviX: x y: y z: z in: aGLXWindowId
    "change the graphics position to a 3D point,
     the relative distance is passed in x/y/z.
     The arguments must be smallIntegers."

%{  /* NOCONTEXT */
    {
	Icoord c_x, c_y, c_z;

	_ICOORD_ (x, c_x)
	_ICOORD_ (y, c_y)
	_ICOORD_ (z, c_z)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rmvi(c_x, c_y, c_z);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:16:21 / cg"
!

glxRmvsX: x y: y z: z in: aGLXWindowId
    "change the graphics position to a 3D point,
     the relative distance is passed in x/y/z.
     The arguments must be smallIntegers."

%{  /* NOCONTEXT */
    {
	Scoord c_x, c_y, c_z;

	_SCOORD_ (x, c_x)
	_SCOORD_ (y, c_y)
	_SCOORD_ (z, c_z)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rmvs(c_x, c_y, c_z);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:16:25 / cg"
! !

!GLXWorkstation methodsFor:'initialization'!

initializeFor:aDisplayName
    (super initializeFor:aDisplayName) isNil ifTrue:[^ nil].
%{
    if (_INST(displayId) != nil) {
	XSetErrorHandler(__XErrorHandler__);
    }
%}
!

initializeScreenProperties
    super initializeScreenProperties.

    "/ GL has a 'bug' (or feature ?)
    "/ which makes it exit (instead of giving an error return)
    "/ if a gl view is opened on a non-gl capable remote display.
    "/ we certainly do not want this here.
    "/ Since I cannot tell in advance if the remote display is gl capable,
    "/ and its too late once we know its not, we simply disallow any remote gl.
    "/ Sorry. (I guess, there are some query functions for that available, but I
    "/ have no documentation).
    "/ Late note: setting the ForceGL classVar overrides above behavior.
    "/ it may be set from a startupScript with: 'GLXWorkstation forceGL:true'
    "/ however: be careful: only set it to true, if you are certain that remoteGL works

    (self isTrueGL and:[ForceGL ~~ true]) ifTrue:[
	glOK := (displayName = ':0') or:[displayName = ':0.0'].
    ] ifFalse:[
	glOK := true.
    ].

%{
    Display *dpy = myDpy;
    int dummy;

    if (ISCONNECTED) {
	_INST(hasStereoExtension) = false;

#if defined(XSGIStereo) && defined(GLX)
	if (_INST(glOK) == true) {
	    if (XQueryExtension(dpy, "SGIFullScreenStereo", &dummy, &dummy, &dummy))
		_INST(hasStereoExtension) = true;
	}
#endif
    }
%}
! !

!GLXWorkstation methodsFor:'lines'!

glxDeflinestyleN: n ls: ls in: aGLXWindowId
    "define a line style"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    deflinestyle(_shortVal(n), _linestyleVal(ls));
#endif
%}
!

glxDraw2:v in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 2D position, passed in vector v."

%{  /* NOCONTEXT */
    float vec[2], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 2))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    draw2((Coord)(c_v[0]), (Coord)(c_v[1]));
#endif
%}

    "Modified: 22.3.1996 / 18:03:29 / cg"
!

glxDraw2X: x y: y in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 2D position, passed in x/y."

%{  /* NOCONTEXT */
    {
	Coord c_x, c_y;

	_COORD_ (x, c_x)
	_COORD_ (y, c_y)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	draw2(c_x, c_y);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:03:50 / cg"
!

glxDraw2iX: x y: y in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 2D position, passed in x/y."

%{  /* NOCONTEXT */
    {
	Icoord c_x, c_y;

	_ICOORD_ (x, c_x)
	_ICOORD_ (y, c_y)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	draw2i(c_x, c_y);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:04:07 / cg"
!

glxDraw2sX: x y: y in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 2D position, passed in x/y."

%{  /* NOCONTEXT */
    {
	Scoord c_x, c_y;

	_SCOORD_ (x, c_x)
	_SCOORD_ (y, c_y)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	draw2s(c_x, c_y);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:04:19 / cg"
!

glxDraw:v in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 3D position, passed in vector v."

%{  /* NOCONTEXT */
    float vec[3], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    draw((Coord)(c_v[0]), (Coord)(c_v[1]), (Coord)(c_v[2]));
#endif
%}

    "Modified: 22.3.1996 / 18:04:34 / cg"
!

glxDrawX: x y: y z: z in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 3D position, passed in x/y/z.
     The arguments may be floats, fractions or smallIntegers"

%{  /* NOCONTEXT */
    {
	Coord c_x, c_y, c_z;

	_COORD_ (x, c_x)
	_COORD_ (y, c_y)
	_COORD_ (z, c_z)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	draw(c_x, c_y, c_z);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:04:46 / cg"
!

glxDrawiX: x y: y z: z in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 3D position, passed in x/y/z.
     The arguments must be smallIntegers."

%{  /* NOCONTEXT */
    {
	Icoord c_x, c_y, c_z;

	_ICOORD_ (x, c_x)
	_ICOORD_ (y, c_y)
	_ICOORD_ (z, c_z)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	drawi(c_x, c_y, c_z);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:04:54 / cg"
!

glxDrawsX: x y: y z: z in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 3D position, passed in x/y/z.
     The arguments must be (16bit) smallIntegers."

%{  /* NOCONTEXT */
    {
	Scoord c_x, c_y, c_z;

	_SCOORD_ (x, c_x)
	_SCOORD_ (y, c_y)
	_SCOORD_ (z, c_z)
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	draws(c_x, c_y, c_z);
#endif
    }
%}

    "Modified: 22.3.1996 / 18:05:01 / cg"
!

glxLinewidth: n in: aGLXWindowId
    "set the linewidth"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    linewidth(_shortVal(n));
#endif
%}
!

glxLinewidthf: n in: aGLXWindowId
    "set the linewidth"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    linewidthf(_floatVal(n));
#endif
    RETURN (true);
%}
!

glxRdr2:v in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 2D position, passing the relative distance in the vector v."

%{  /* NOCONTEXT */
    float vec[2], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 2))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rdr2((Coord)(c_v[0]), (Coord)(c_v[1]));
#endif
%}

    "Modified: 22.3.1996 / 18:05:54 / cg"
!

glxRdr2X: x y: y in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 2D position, passing the relative distance in x/y."

%{  /* NOCONTEXT */
    Coord c_x, c_y;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rdr2(c_x, c_y);
#endif
%}

    "Modified: 22.3.1996 / 18:06:20 / cg"
!

glxRdr2iX: x y: y in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 2D position, passing the relative distance in x/y."

%{  /* NOCONTEXT */
    Icoord c_x, c_y;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rdr2i(c_x, c_y);
#endif
%}

    "Modified: 22.3.1996 / 18:06:28 / cg"
!

glxRdr2sX: x y: y in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 2D position, passing the relative distance in x/y."

%{  /* NOCONTEXT */
    Scoord c_x, c_y;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rdr2s(c_x, c_y);
#endif
%}

    "Modified: 22.3.1996 / 18:06:34 / cg"
!

glxRdr:v in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 3D position, passing the relative distance in the vector v."

%{  /* NOCONTEXT */
    float vec[3], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rdr((Coord)(c_v[0]), (Coord)(c_v[1]), (Coord)(c_v[2]));
#endif
%}

    "Modified: 22.3.1996 / 18:06:07 / cg"
!

glxRdrX: x y: y z: z in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 3D position, passing the relative distance in x/y/z."

%{  /* NOCONTEXT */
    Coord c_x, c_y, c_z;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    _COORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rdr(c_x, c_y, c_z);
#endif
%}

    "Modified: 22.3.1996 / 18:06:44 / cg"
!

glxRdriX: x y: y z: z in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 3D position, passing the relative distance in x/y/z."

%{  /* NOCONTEXT */
    Icoord c_x, c_y, c_z;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    _ICOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rdri(c_x, c_y, c_z);
#endif
%}

    "Modified: 22.3.1996 / 18:06:51 / cg"
!

glxRdrsX: x y: y z: z in: aGLXWindowId
    "draw a line from the current graphics position
     to a new 3D position, passing the relative distance in x/y/z."

%{  /* NOCONTEXT */
    Scoord c_x, c_y, c_z;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    _SCOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rdrs(c_x, c_y, c_z);
#endif
%}

    "Modified: 22.3.1996 / 18:06:55 / cg"
!

glxSetlinestyle: index in: aGLXWindowId
    "set the linestyle"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    setlinestyle(_shortVal(index));
#endif
%}
! !

!GLXWorkstation methodsFor:'materials & lights'!

glxLmbind:target index:index in:aGLXWindowId
    "select a material, light or lighting model.
     target must be a symbol from: #material, #backMaterial,
     #light0-light7 or #lightModel."

%{  /* NOCONTEXT */
#ifdef GLX
    short defType;
    short i_index;

    if (target == @symbol(material))
	defType = MATERIAL;
    else if (target == @symbol(backMaterial))
	defType = BACKMATERIAL;
    else if (target == @symbol(light0))
	defType = LIGHT0;
    else if (target == @symbol(light1))
	defType = LIGHT1;
    else if (target == @symbol(light2))
	defType = LIGHT2;
    else if (target == @symbol(light3))
	defType = LIGHT3;
    else if (target == @symbol(light4))
	defType = LIGHT4;
    else if (target == @symbol(light5))
	defType = LIGHT5;
    else if (target == @symbol(light6))
	defType = LIGHT6;
    else if (target == @symbol(light7))
	defType = LIGHT7;
    else if (target == @symbol(lightModel))
	defType = LMODEL;
    else {
	RETURN (nil);
    }

    _INT_ (index, i_index);
    SETWIN(aGLXWindowId)
    lmbind(defType, i_index);
#endif
%}
!

glxLmdef:what index:index np:np props:props in:aGLXWindowId
    "define a material, light source or lighting model;
     what must be one of #material, #light or #lightModel.
     props must be a FloatArray or a subclass of FloatArray"

%{  /* NOCONTEXT */
#ifdef GLX
    short defType;
    short i_index, i_np;
    float *fp;
    OBJ cls;
    int ninstVars, nInstBytes;

    if (what == @symbol(material))
	defType = DEFMATERIAL;
    else if (what == @symbol(light))
	defType = DEFLIGHT;
    else if (what == @symbol(lightModel))
	defType = DEFLMODEL;
    else {
	RETURN (nil);
    }

    _INT_ (index, i_index);
    _INT_ (np, i_np);

    if (! _isNonNilObject(props)) fp = NULL;
    else {
	cls = __qClass(props);
	if (cls == @global(FloatArray))
	    fp = _FloatArrayInstPtr(props)->f_element;
	else {
	    if ((__intVal(_ClassInstPtr(cls)->c_flags) & ARRAYMASK) == FLOATARRAY) {
		ninstVars = __intVal(_ClassInstPtr(cls)->c_ninstvars);
		fp = (float *) &(_InstPtr(props)->i_instvars[ninstVars]);
	    } else {
		RETURN (nil);
	    }
	}
    }
    SETWIN(aGLXWindowId)
    lmdef(defType, i_index, i_np, fp);
#endif
%}
!

glxTevbind:target index:index in:aGLXWindowId
    "bind a texture environment; target must be 0
     or the symbol #env0."

%{  /* NOCONTEXT */
#ifdef GLX
    long t;

    if (__isSmallInteger(target)) {
	t = __intVal(target);
    } else {
	if (target == @symbol(env0)) {
	    t = TV_ENV0;
	} else {
	    RETURN (nil);
	}
    }
    SETWIN(aGLXWindowId)
    tevbind(t, __intVal(index));
#endif
%}
!

glxTevdef:index np:np props:props in:aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    const float *fp;
    float fbuff[30];

    SETWIN(aGLXWindowId)
    fp = __glx_getFloatsFromFloatArrayInto(props, fbuff);
    tevdef(__intVal(index), __intVal(np), fp);
#endif
%}
!

glxTexDef2d:index nc:nc width:w height:h bits:image np:np props:props in:aGLXWindowId
    "define a 2D texture. index is the 'name' of the texture;
     nc is the number of components (1-4) per pixel;
     w/h define the size of the texture; bits is a byteArray containing the
     long-word aligned pixel data; np is the number of props found in
     the floatArray props. Props must be delimited by a 0.0 entry."

%{  /* NOCONTEXT */
#ifdef GLX
    unsigned char *cp;
    const float *fp;
    OBJ cls;
    float fbuff[30];

    if (__isByteArrayLike(image)) {
	cp = _ByteArrayInstPtr(image)->ba_element;
	fp = __glx_getFloatsFromFloatArrayInto(props, fbuff);

	SETWIN(aGLXWindowId)
	texdef2d(__intVal(index), __intVal(nc), __intVal(w), __intVal(h),
		 (const unsigned long *)cp, __intVal(np), fp);
    }
#endif
%}
!

glxTexDef3d:index nc:nc width:w height:h depth:d bits:image np:np props:props in:aGLXWindowId
    "define a 3D texture. index is the 'name' of the texture;
     nc is the number of components (1-4) per pixel;
     w/h/d define the size of the texture; bits is a byteArray containing the
     long-word aligned pixel data; np is the number of props found in
     the floatArray props. Props must be delimited by a 0.0 entry."

%{  /* NOCONTEXT */
#ifdef GLX
    unsigned char *cp;
    const float *fp;
    OBJ cls;
    float fbuff[30];

    if (__isByteArrayLike(image)) {
	cp = _ByteArrayInstPtr(image)->ba_element;
	fp = __glx_getFloatsFromFloatArrayInto(props, fbuff);

	SETWIN(aGLXWindowId)
	texdef3d(__intVal(index), __intVal(nc), __intVal(w), __intVal(h),
		 __intVal(d),
		 (const unsigned long *)cp, __intVal(np), fp);
    }
#endif
%}
!

glxTexbind:target index:index in:aGLXWindowId
    "bind a texture; target must be an integer or one
     of the symbols #texture0, #textureDetail or #textureIdle."

%{  /* NOCONTEXT */
#ifdef GLX
    long t;

    if (__isSmallInteger(target)) {
	t = __intVal(target);
    } else {
	if (target == @symbol(texture0)) {
	    t = TX_TEXTURE_0;
	} else if (target == @symbol(textureDetail)) {
	    t = TX_TEXTURE_DETAIL;
	} else if (target == @symbol(textureIdle)) {
	    t = TX_TEXTURE_IDLE;
	} else {
	    RETURN (nil);
	}
    }
    SETWIN(aGLXWindowId)
    texbind(t, __intVal(index));
#endif
%}
! !

!GLXWorkstation methodsFor:'matrix stack'!

glxGetMatrix:arrayOf16Floats in:aGLXWindowId
    "argument must be an array (a matrix) of 16 floats. The current matrix
     will be stored into that."

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    Matrix matrix;

    SETWIN(aGLXWindowId)
    getmatrix(matrix);
    if (! __glx_putFloatsFromInto(matrix, arrayOf16Floats, 16)) RETURN(false);
#endif
%}
!

glxLoadMatrix:arrayOf16Floats in:aGLXWindowId
    "argument must be an array(a matrix) of 16 floats. The current matrix
     will be loaded from that."

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    Matrix matrix;
    Matrix *m;

    if (! (m = __glx_getFloatsFromMatrixInto(arrayOf16Floats, matrix))) RETURN (false);
    SETWIN(aGLXWindowId)
    loadmatrix(*m);
#endif
%}
!

glxMultMatrix:arrayOf16Floats in:aGLXWindowId
    "argument must be an array(a matrix) of 16 floats containing a
     matrix to multiply into the current matrix."

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    Matrix matrix;
    Matrix *m;

    if (! (m = __glx_getFloatsFromMatrixInto(arrayOf16Floats, matrix))) RETURN (false);
    SETWIN(aGLXWindowId)
    multmatrix(*m);
#endif
%}
!

glxPopmatrixIn:aGLXWindowId
    "pop transformation stack"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    popmatrix();
#endif
%}
!

glxPushmatrixIn:aGLXWindowId
    "push down transformation stack"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pushmatrix();
#endif
%}
! !

!GLXWorkstation methodsFor:'misc'!

glxGconfigIn:aGLXWindowId
    "must be sent after RGBmode, doubleBuffer etc. to have these
     changes really take effect. See GLX manual.
     (Actually, it seems to be not allowed - I don't really know)"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    gconfig();
#endif
%}
!

glxMmode:aSymbol in:aGLXWindowId
    "set matrix mode: #single, #viewing, #projection or #texture"

%{  /* NOCONTEXT */
#ifdef GLX
    if (aSymbol == @symbol(single)) {
	mmode(MSINGLE);
	RETURN (true);
    }
    if (aSymbol == @symbol(viewing)) {
	mmode(MVIEWING);
	RETURN (true);
    }
    if (aSymbol == @symbol(projection)) {
	mmode(MPROJECTION);
	RETURN (true);
    }
    if (aSymbol == @symbol(texture)) {
	mmode(MTEXTURE);
	RETURN (true);
    }
#endif
%}
.
    ^ false
!

glxNmode:aSymbol in:aGLXWindowId
    "set normalize mode: #auto, #normalize"

%{  /* NOCONTEXT */
#ifdef GLX
    if (aSymbol == @symbol(auto)) {
	nmode(NAUTO);
	RETURN (true);
    }
    if (aSymbol == @symbol(normalize)) {
	nmode(NNORMALIZE);
	RETURN (true);
    }
#endif
%}
.
    ^ false
!

glxRGBmodeIn:aGLXWindowId
    "set true color mode (no colormap)"

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RGBmode();
    RETURN (true);
#endif
%}
.
    ^ false
! !

!GLXWorkstation methodsFor:'objects'!

glxCallObject:obj in:aGLXWindowId
    "perform the commands of an object (macro)."

%{  /* NOCONTEXT STACK:32000 */
#ifdef OPENGL
#else
    if (__isSmallInteger(obj)) {
	SETWIN(aGLXWindowId)
	callobj(_objectVal(obj));
	RETURN (true);
    }
#endif
%}.
    ^ false
!

glxCloseObjectIn:aGLXWindowId
    "end object defnition"

%{  /* NOCONTEXT STACK:32000 */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    closeobj();
    RETURN (true);
#endif
%}
!

glxDeleteObject:obj in:aGLXWindowId

%{  /* NOCONTEXT STACK:32000 */
#ifdef OPENGL
#else
    if (__isSmallInteger(obj)) {
	SETWIN(aGLXWindowId)
	delobj(_objectVal(obj));
	RETURN (true);
    }
#endif
%}
!

glxGenObjectIn:aGLXWindowId
    "return a new (free & unused) object id for use
     with makeObj"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(genobj()));
#endif
%}
!

glxGetopenobjIn:aGLXWindowId
    "return the currently open objects id; -1 if none is open"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getopenobj()));
#endif
%}
!

glxIsobj:obj in:aGLXWindowId
    "return true, if obj is a valid object id"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    SETWIN(aGLXWindowId)
    RETURN (__MKBOOLEAN(isobj(_objectVal(obj))));
#endif
%}
!

glxMakeObject:id in:aGLXWindowId
    "start object definition -
     another name conflict"

%{  /* NOCONTEXT STACK:32000 */
#ifdef OPENGL
#else
    if (__isSmallInteger(id)) {
	SETWIN(aGLXWindowId)
	makeobj(_objectVal(id));
	RETURN (true);
    }
#endif
%}.
    ^ false
! !

!GLXWorkstation methodsFor:'patches & surfaces'!

glxBeginCurveIn:aGLXWindowId
    "start a NURBS curve def - in real GL only"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    bgncurve();
#endif
%}
!

glxBeginSurfaceIn:aGLXWindowId
    "start a NURBS surface def - in real GL only"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    bgnsurface();
#endif
%}
!

glxDefBasis:id mat:aMatrix in:aGLXWindowId
    "define the basis matrix for a patch or curve"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    Matrix matrix;
    Matrix *m;

    if (! (m = __glx_getFloatsFromMatrixInto(aMatrix, matrix))) RETURN (false);
    if (__isSmallInteger(id)) {
	SETWIN(aGLXWindowId)
	defbasis((short)(__intVal(id)), *m);
    }
#endif
%}

    "Modified: 19.3.1996 / 18:52:56 / cg"
!

glxEndCurveIn:aGLXWindowId
    "end a NURBS curve def - in real GL only"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    endcurve();
#endif
%}
!

glxEndSurfaceIn:aGLXWindowId
    "end a NURBS surface def - in real GL only"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    endsurface();
#endif
%}
!

glxNurbsSurfaceUKnotCount: uKnotCount uKnot: uKnot
    vKnotCount: vKnotCount vKnot: vKnot
    uOffset: uOffset vOffset: vOffset
    ctlArray: ctlArray
    uOrder: uOrder vOrder: vOrder
    type: type in: aGLXWindowId

    | ctlPoints i |
    ctlPoints := DoubleArray new: ctlArray size * (ctlArray first size).
    i := 1.
    ctlArray do: [:point |
	point do: [:coord |
	    ctlPoints at: i put: coord.
	    i := i + 1]].

%{  /* NOCONTEXT */
#ifdef GLX
    char *uKnotElements, *vKnotElements, *ctlElements;
    OBJ cls;
    int ninstVars, nInstBytes;

    SETWIN(aGLXWindowId)
    cls = __qClass(ctlPoints);
    ninstVars = __intVal(_ClassInstPtr(cls)->c_ninstvars);
    nInstBytes = OHDR_SIZE + ninstVars * sizeof(OBJ);

    ctlElements = (char *)(_InstPtr(ctlPoints)) + nInstBytes;
    uKnotElements = (char *)(_InstPtr(uKnot)) + nInstBytes;
    vKnotElements = (char *)(_InstPtr(vKnot)) + nInstBytes;

    nurbssurface (
	__intVal(uKnotCount), (double *)uKnotElements,
	__intVal(vKnotCount), (double *)vKnotElements,
	__intVal(uOffset), __intVal(vOffset),
	(double *)ctlElements,
	__intVal(uOrder), __intVal(vOrder), __intVal(type));
    RETURN(true);
#endif
%}.
    ^ false
!

glxPatchBasisU:u v:v in:aGLXWindowId
    "set the two basis matrices for a patch"

%{  /* NOCONTEXT */
    if (__bothSmallInteger(u, v)) {
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	patchbasis((long)__intVal(u), (long)__intVal(v));
#endif
    }
%}

    "Modified: 19.3.1996 / 18:53:18 / cg"
!

glxPatchCurvesU:u v:v in:aGLXWindowId
    "set the number of curves to be drawn in each direction on a patch"

%{  /* NOCONTEXT */
    if (__bothSmallInteger(u, v)) {
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	patchcurves((long)__intVal(u), (long)__intVal(v));
#endif
    }
%}

    "Modified: 19.3.1996 / 18:53:34 / cg"
!

glxPatchPrecisionU:u v:v in:aGLXWindowId
    "set the patch precision"

%{  /* NOCONTEXT */
    if (__bothSmallInteger(u, v)) {
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	patchprecision((long)__intVal(u), (long)__intVal(v));
#endif
    }
%}
!

glxPatchX:arrayOf16XFloats y:arrayOf16YFloats z:arrayOf16ZFloats in:aGLXWindowId
    "Draws a bicubic patch.
     arguments must be arrays of 16 floats containing the patch"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    Matrix matrixX, matrixY, matrixZ;
    Matrix *mX, *mY, *mZ;

    if (! (mX = __glx_getFloatsFromMatrixInto(arrayOf16XFloats, matrixX)))
	RETURN (nil);
    if (! (mY = __glx_getFloatsFromMatrixInto(arrayOf16YFloats, matrixY)))
	RETURN (nil);
    if (! (mZ = __glx_getFloatsFromMatrixInto(arrayOf16ZFloats, matrixZ)))
	RETURN (nil);
    SETWIN(aGLXWindowId)
    patch(*mX, *mY, *mZ);
#endif
%}

    "Modified: 19.3.1996 / 18:54:02 / cg"
!

glxRpatchX:arrayOf16XFloats y:arrayOf16YFloats z:arrayOf16ZFloats w:arrayOf16WFloats in:aGLXWindowId
    "Draws a rational bicubic patch.
     arguments must be arrays of 16 floats containing the patch"

%{  /* NOCONTEXT */
#ifdef OPENGL
#else
    Matrix matrixX, matrixY, matrixZ, matrixW;
    Matrix *mX, *mY, *mZ, *mW;

    if (! (mX = __glx_getFloatsFromMatrixInto(arrayOf16XFloats, matrixX)))
	RETURN (nil);
    if (! (mY = __glx_getFloatsFromMatrixInto(arrayOf16YFloats, matrixY)))
	RETURN (nil);
    if (! (mZ = __glx_getFloatsFromMatrixInto(arrayOf16ZFloats, matrixZ)))
	RETURN (nil);
    if (! (mW = __glx_getFloatsFromMatrixInto(arrayOf16WFloats, matrixW)))
	RETURN (nil);
    SETWIN(aGLXWindowId)
    rpatch(*mX, *mY, *mZ, *mW);
#endif
%}

    "Modified: 19.3.1996 / 18:54:02 / cg"
    "Created: 19.3.1996 / 18:56:34 / cg"
! !

!GLXWorkstation methodsFor:'pixel copy'!

glxRectcopyX1: x1 y1: y1 x2: x2 y2: y2 newx: newx newy: newy in: aGLXWindowId
    "copy a rectangular area in the view.
     For now, this is only supported with a true GL.
     readsource specifies which plane/buffer is affected by this operation."

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    rectcopy(_screencoordVal(x1), _screencoordVal(y1),
	     _screencoordVal(x2), _screencoordVal(y2),
	     _screencoordVal(newx), _screencoordVal(newy));
#endif
%}
! !

!GLXWorkstation methodsFor:'pixel reading'!

glxReadpixelsTo:dest in:aGLXWindowId
    "read pixels from the view.
     Dest must be an array and gets pixel values assigned,
     reading n pixels starting at the current x/y coordinate (pixel coordinates).
     For now, pixel-reading is only supported with a true GL.
     Caveat: the number of pixels is limited to 256.
     In double buffer mode, the backBuffer is read."

    |n|

    n := dest size.
    n > 256 ifTrue:[^ 0].

%{  /* STACK:1024 */
#ifdef GLX
    Colorindex buffer[256];
    int i, nRead;

    if (__isArray(dest)) {
	SETWIN(aGLXWindowId)
	nRead = readpixels(__intVal(n), buffer);
	for (i=0; i<nRead;i++) {
	    __ArrayInstPtr(dest)->a_element[i] = __MKSMALLINT(buffer[i]);
	}
	RETURN (__MKSMALLINT(nRead));
    }
#endif
%}.
    ^ 0

    "Modified: 22.3.1996 / 18:08:00 / cg"
!

glxReadsource: src in: aGLXWindowId
    "specify what is read with folowing readPixels requests.
     For now, pixel-reading is only supported with a true GL"

%{  /* NOCONTEXT */
#ifdef GLX
    OBJ s = src;
    int what;

    SETWIN(aGLXWindowId)
    if (s == @symbol(auto)) {
	what = SRC_AUTO;
    } else if (s == @symbol(front)) {
	what = SRC_FRONT;
    } else if (s == @symbol(back)) {
	what = SRC_BACK;
    } else if (s == @symbol(zBuffer)) {
	what = SRC_ZBUFFER;
    } else if (s == @symbol(frameGrabber)) {
	what = SRC_FRAMEGRABBER;
    } else if (s == @symbol(over)) {
	what = SRC_OVER;
    } else if (s == @symbol(under)) {
	what = SRC_UNDER;
    } else if (s == @symbol(popUp)) {
	what = SRC_PUP;
    } else {
	what = _longVal(src);
    }

    readsource(what);
#endif
%}
!

glxRectreadX1:x1 y1:y1 x2:x2 y2:y2 h:viewHeight to:dest in:aGLXWindowId
    "read pixels from a rectanglular area.
     Dest must be an array and gets pixel values assigned,
     reading n*m pixels.
     For now, pixel-reading is only supported with a true GL.
     Caveat: the number of pixels is limited to 256.
     In double buffer mode, the backBuffer is read."

    |n idx sy1 sy2|

    "/ GLX's y coordinates go bottom to top ...

    sy1 := viewHeight - y1.
    sy2 := viewHeight - y2.

    n := (x2 - x1 + 1) * (y2 - y1 + 1).
    n > 256 ifTrue:[^ 0].
    dest size < n ifTrue:[^ 0].

%{  /* STACK:1024 */
#ifdef GLX
    Colorindex buffer[256];
    int i, nRead;

    if (__isArray(dest)
     && __isSmallInteger(x1) && __isSmallInteger(x2)
     && __isSmallInteger(sy1) && __isSmallInteger(sy2)
    ) {
	SETWIN(aGLXWindowId)
	nRead = rectread(__intVal(x1), __intVal(sy1),
			  __intVal(x2), __intVal(sy2),
			  buffer);
	for (i=0; i<nRead;i++) {
	    __ArrayInstPtr(dest)->a_element[i] = __MKSMALLINT(buffer[i]);
	}
	RETURN (__MKSMALLINT(nRead));
    }
#endif
%}.
    "/
    "/ ok, this is not a GL - use XWorkstations pixel read method
    "/ and convert
    "/
    idx := 1.
    y1 to:y2 do:[:y |
	x1 to:x2 do:[:x |
	    |pix|

	    pix := self vglGetPixelX:x y:y in:aGLXWindowId.
	    dest at:idx put:pix
	]
    ].
    ^ n

    "Modified: 22.3.1996 / 18:08:00 / cg"

!

glxXColorToGLColor:pixel
    "only for VOGL: given a pixel as read from the view,
     return the corresponding GL color"

%{    /* NOCONTEXT */
#ifdef VGL
    if (__isSmallInteger(pixel)) {
	RETURN (__MKSMALLINT(X11_invColor(__intVal(pixel))));
    }
#endif
%}.
    ^ pixel
!

vglGetPixelX:x y:y in:aGLXWindowId
    "special for VGL"

%{
#ifdef VGL
    if (__bothSmallInteger(x, y)) {
	SETWIN(aGLXWindowId)
	RETURN (__MKSMALLINT(X11_getPixel(__intVal(x), __intVal(y))));
    }
#endif
%}.
    ^ 0

    "Modified: 22.3.1996 / 18:08:00 / cg"
! !

!GLXWorkstation methodsFor:'points'!

glxPnt2X: x y: y in: aGLXWindowId
    "plot a point in x, y, 0."

%{  /* NOCONTEXT */
    Coord c_x, c_y;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pnt2(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:35:55 / cg"
!

glxPnt2iX: x y: y in: aGLXWindowId
    "plot a point in x, y, 0."

%{  /* NOCONTEXT */
    Icoord c_x, c_y;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pnt2i(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:35:59 / cg"
!

glxPnt2sX: x y: y in: aGLXWindowId
    "plot a point in x, y, 0."

%{  /* NOCONTEXT */
    Scoord c_x, c_y;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pnt2s(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:36:03 / cg"
!

glxPntX: x y: y z: z in: aGLXWindowId
    "plot a point in x, y, z."

%{  /* NOCONTEXT */
    Coord c_x, c_y, c_z;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    _COORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pnt(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:36:08 / cg"
!

glxPntiX: x y: y z: z in: aGLXWindowId
    "plot a point in x, y, z."

%{  /* NOCONTEXT */
    Icoord c_x, c_y, c_z;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    _ICOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pnti(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:36:14 / cg"
!

glxPntsX: x y: y z: z in: aGLXWindowId
    "plot a point in x, y, z."

%{  /* NOCONTEXT */
    Scoord c_x, c_y, c_z;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    _SCOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pnts(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:36:17 / cg"
!

glxPntsize: n in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    pntsize(_shortVal(n));
#endif
%}
!

glxPntsizef: n in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    pntsizef(_floatVal(n));
#endif
%}
! !

!GLXWorkstation methodsFor:'polygons'!

glxBackface: b in: aGLXWindowId
    "enable/disable culling of backfacing polygons (suppress its drawing).
     A polygon is backfacing if it's orientation in *screen* coords is clockwise"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    backface(_booleanVal(b));
#endif
%}

    "Modified: 19.3.1996 / 18:26:50 / cg"
!

glxConcave: b in: aGLXWindowId
    "signal wether or not polygons are concave"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    concave(_booleanVal(b));
#endif
%}
!

glxFrontface: b in: aGLXWindowId
    "enable/disable culling of frontfacing polygons (suppress its drawing).
     A polygon is frontfacing if it's orientation in *screen* coords is
     anti-clockwise"


%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    frontface(_booleanVal(b));
#endif
%}
!

glxPdr2X: x y: y in: aGLXWindowId
    "add another vertex to the polygon"

%{  /* NOCONTEXT */
    Coord c_x, c_y;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pdr2(c_x, c_y);
#endif
%}
!

glxPdr2iX: x y: y in: aGLXWindowId
    "add another vertex to the polygon"

%{  /* NOCONTEXT */
    Icoord c_x, c_y;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pdr2i(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:33:28 / cg"
!

glxPdr2sX: x y: y in: aGLXWindowId
    "add another vertex to the polygon"

%{  /* NOCONTEXT */
    Scoord c_x, c_y;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pdr2s(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:34:03 / cg"
!

glxPdrX: x y: y z: z in: aGLXWindowId
    "add another vertex to the polygon"

%{  /* NOCONTEXT */
    Coord c_x, c_y, c_z;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    _COORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pdr(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:34:06 / cg"
!

glxPdriX: x y: y z: z in: aGLXWindowId
    "add another vertex to the polygon"

%{  /* NOCONTEXT */
    Icoord c_x, c_y, c_z;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    _ICOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pdri(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:34:11 / cg"
!

glxPdrsX: x y: y z: z in: aGLXWindowId
    "add another vertex to the polygon"

%{  /* NOCONTEXT */
    Scoord c_x, c_y, c_z;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    _SCOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pdrs(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:34:14 / cg"
!

glxPmv2X: x y: y in: aGLXWindowId
    "set the start position of a polygon"

%{  /* NOCONTEXT */
    Coord c_x, c_y;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pmv2(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:32:45 / cg"
!

glxPmv2iX: x y: y in: aGLXWindowId
    "set the start position of a polygon"

%{  /* NOCONTEXT */
    Icoord c_x, c_y;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pmv2i(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:32:42 / cg"
!

glxPmv2sX: x y: y in: aGLXWindowId
    "set the start position of a polygon"

%{  /* NOCONTEXT */
    Scoord c_x, c_y;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pmv2s(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:32:38 / cg"
!

glxPmvX: x y: y z: z in: aGLXWindowId
    "set the start position of a polygon"

%{  /* NOCONTEXT */
    Coord c_x, c_y, c_z;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    _COORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pmv(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:31:52 / cg"
!

glxPmviX: x y: y z: z in: aGLXWindowId
    "set the start position of a polygon"

%{  /* NOCONTEXT */
    Icoord c_x, c_y, c_z;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    _ICOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pmvi(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:31:59 / cg"
!

glxPmvsX: x y: y z: z in: aGLXWindowId
    "set the start position of a polygon"

%{  /* NOCONTEXT */
    Scoord c_x, c_y, c_z;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    _SCOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pmvs(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:32:03 / cg"
!

glxPolymode: mode in: aGLXWindowId
    "Sets the polygon filling mode - only filled (1) or outlined (0)
     are supported"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    polymode(_longVal(mode));
#endif
%}

    "Modified: 19.3.1996 / 18:29:32 / cg"
!

glxRpdr2X: x y: y in: aGLXWindowId
    "add another relative vertex to the polygon"

%{  /* NOCONTEXT */
    Coord c_x, c_y;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rpdr2(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:34:31 / cg"
!

glxRpdr2iX: x y: y in: aGLXWindowId
    "add another relative vertex to the polygon"

%{  /* NOCONTEXT */
    Icoord c_x, c_y;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rpdr2i(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:34:36 / cg"
!

glxRpdr2sX: x y: y in: aGLXWindowId
    "add another relative vertex to the polygon"

%{  /* NOCONTEXT */
    Scoord c_x, c_y;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rpdr2s(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:34:40 / cg"
!

glxRpdrX: x y: y z: z in: aGLXWindowId
    "add another relative vertex to the polygon"

%{  /* NOCONTEXT */
    Coord c_x, c_y, c_z;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    _COORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rpdr(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:34:48 / cg"
!

glxRpdriX: x y: y z: z in: aGLXWindowId
    "add another relative vertex to the polygon"

%{  /* NOCONTEXT */
    Icoord c_x, c_y, c_z;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    _ICOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rpdri(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:34:51 / cg"
!

glxRpdrsX: x y: y z: z in: aGLXWindowId
    "add another relative vertex to the polygon"

%{  /* NOCONTEXT */
    Scoord c_x, c_y, c_z;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    _SCOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rpdrs(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:34:55 / cg"
!

glxRpmv2X: x y: y in: aGLXWindowId
    "set the start position of a polygon"

%{  /* NOCONTEXT */
    Coord c_x, c_y;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rpmv2(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:37:15 / cg"
!

glxRpmv2iX: x y: y in: aGLXWindowId
    "set the start position of a polygon"

%{  /* NOCONTEXT */
    Icoord c_x, c_y;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rpmv2i(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:37:20 / cg"
!

glxRpmv2sX: x y: y in: aGLXWindowId
    "set the relative start position of a polygon"

%{  /* NOCONTEXT */
    Scoord c_x, c_y;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rpmv2s(c_x, c_y);
#endif
%}

    "Modified: 19.3.1996 / 18:38:06 / cg"
!

glxRpmvX: x y: y z: z in: aGLXWindowId
    "set the relative start position of a polygon"

%{  /* NOCONTEXT */
    Coord c_x, c_y, c_z;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    _COORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rpmv(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:38:03 / cg"
!

glxRpmviX: x y: y z: z in: aGLXWindowId
    "set the relative start position of a polygon"

%{  /* NOCONTEXT */
    Icoord c_x, c_y, c_z;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    _ICOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rpmvi(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:37:53 / cg"
!

glxRpmvsX: x y: y z: z in: aGLXWindowId
    "set the relative start position of a polygon"

%{  /* NOCONTEXT */
    Scoord c_x, c_y, c_z;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    _SCOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rpmvs(c_x, c_y, c_z);
#endif
%}

    "Modified: 19.3.1996 / 18:37:58 / cg"
! !

!GLXWorkstation methodsFor:'queries'!

glVersion
    "return a string describing the GL version.
     For informative use only; portable applications do not depend
     on the returned string."

%{  /* NOCONTEXT */
#ifdef VGL
    RETURN (__MKSTRING("vogl"));
#else
# ifdef GLX
    char buffer[128];

    if (_INST(glOK) == true) {
	gversion(buffer);
	RETURN (__MKSTRING(buffer));
    }
    RETURN (nil);
# else
    RETURN (nil);
# endif
#endif
%}

    "
     Display glVersion
    "
!

glxGetplanesIn: aGLXWindowId
    "Returns the number if bit planes available on the device."

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    RETURN (__MKSMALLINT(getplanes()));
#endif
%}.
    ^ 0

    "Modified: 19.3.1996 / 18:50:44 / cg"
!

hasStereoExtension
    "return true, if this workstation supports stereo GL drawing.
     Both the server must support it, and the feature must have been
     enabled in the smalltalk system, for true to be returned."

    ^ hasStereoExtension

    "
     Display hasStereoExtension
    "
!

isOpenGL
    "return true, if this is an openGL (as opposed to a GL)"

%{  /* NOCONTEXT */
#ifdef OPENGL
    RETURN ( true );
#else
    RETURN ( false );
#endif
%}
!

isTrueGL
    "return true, if this is a true GL (as opposed to a simulated VOGL).
     Returns false for all openGL systems."

%{  /* NOCONTEXT */
#ifdef VGL
    RETURN ( false );
#else
# ifdef GLX
    RETURN ( true );
# endif
#endif
%}.
    ^ false
!

maxZValue
    "return the max. Z value (only valid if z-buffer is supported)"
%{
#ifndef OPENGL
# ifdef GD_ZMAX
    long zMax;

    if (_INST(glOK) == true) {
	zMax = getgdesc(GD_ZMAX);

	if ((zMax >= _MIN_INT) && (zMax <= _MAX_INT)) {
	    RETURN ( __MKSMALLINT(zMax) );
	}
	RETURN ( __MKLARGEINT(zMax) );
    }
# endif
#endif
%}.
    ^ nil
!

supportsDoubleBuffer
    "return true, if this gl workstation supports double buffering.
     For portable applications, always combine this with a query
     if the display supports GL drawing at all."

%{  /* NOCONTEXT */

#ifndef OPENGL
# ifdef VGL
    RETURN (true);
# else
#  ifdef GD_BITS_NORM_DBL_RED
    if (getgdesc(GD_BITS_NORM_DBL_RED) != 0) {
	RETURN ( _INST(glOK) );
    }
#  endif
# endif
#endif
%}.
    ^ false

    "
     Display supportsDoubleBuffer
    "
!

supportsGLDrawing
    "return true, if this device supports 3D GL drawing."

    ^ glOK

    "
     Display supportsGLDrawing
    "
!

supportsLight
    "return true, if this gl workstation supports light sources
     (i.e. if its a real GL).
     For portable applications, always combine this with a query
     if the display supports GL drawing at all."

%{  /* NOCONTEXT */
#ifdef GLX
    RETURN ( _INST(glOK) );
#endif
%}.
    ^ false

    "
     Display supportsLight
    "
!

supportsRGB
    "return true, if this gl workstation supports rgb
     (in addition to indexed) colors. Actually, we return true
     for a real GL engine, false for the simulator here.
     For portable applications, always combine this with a query
     if the display supports GL drawing at all."

%{  /* NOCONTEXT */
#ifdef GLX
    RETURN ( _INST(glOK) );
#endif
%}.
    ^ false

    "
     Display supportsRGB
    "
!

supportsTextures
    "return true, if this gl workstation supports texture mapping
     (i.e. if its a real GL).
     For portable applications, always combine this with a query
     if the display supports GL drawing at all."

%{  /* NOCONTEXT */
#ifndef OPENGL
# ifdef GD_TEXTURE
    if (getgdesc(GD_TEXTURE) != 0) {
	RETURN ( _INST(glOK) );
    }
# endif
#endif
%}.
    ^ false

    "
     Display supportsTextures
    "
!

supportsZBuffer
    "return true, if this gl workstation has z buffer support.
     For portable applications, always combine this with a query
     if the display supports GL drawing at all."

%{  /* NOCONTEXT */

#ifndef OPENGL
# ifdef GD_BITS_NORM_ZBUFFER
    if (getgdesc(GD_BITS_NORM_ZBUFFER) != 0) {
	RETURN ( _INST(glOK) );
    }
# endif
#endif
%}.
    ^ false

    "
     Display supportsZBuffer
    "
! !

!GLXWorkstation methodsFor:'rectangles'!

glxRectX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rect(_coordVal(x1), _coordVal(y1), _coordVal(x2), _coordVal(y2));
#endif
%}
!

glxRectfX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rectf(_coordVal(x1), _coordVal(y1), _coordVal(x2), _coordVal(y2));
#endif
%}
!

glxRectfiX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rectfi(_icoordVal(x1), _icoordVal(y1), _icoordVal(x2), _icoordVal(y2));
#endif
%}
!

glxRectfsX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rectfs(_scoordVal(x1), _scoordVal(y1), _scoordVal(x2), _scoordVal(y2));
#endif
%}
!

glxRectiX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    recti(_icoordVal(x1), _icoordVal(y1), _icoordVal(x2), _icoordVal(y2));
#endif
%}
!

glxRectsX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rects(_scoordVal(x1), _scoordVal(y1), _scoordVal(x2), _scoordVal(y2));
#endif
%}
! !

!GLXWorkstation methodsFor:'spheres'!

glxSphDraw:arrayOf4Floats in:aGLXWindowId
    "argument must be an array(a matrix) of 4 floats containing the
     sphere - in real GL only"

%{  /* NOCONTEXT */
#ifdef GLX
    float vec[4], *v;

    if (! (v = __glx_getFloatsFromInto(arrayOf4Floats, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
    sphdraw(v);
#endif
%}
!

glxSphDrawX:x y:y z:z radius:r in:aGLXWindowId
    "arguments must be convertable to floats - in real GL only"

%{  /* NOCONTEXT */
#ifdef GLX
    float vec[4];

    _FLOAT_(x, vec[0])
    _FLOAT_(y, vec[1])
    _FLOAT_(z, vec[2])
    _FLOAT_(r, vec[3])
    SETWIN(aGLXWindowId)
    sphdraw(vec);
#endif
%}
!

glxSphfreeIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    sphfree();
#endif
%}
!

glxSphgnpolysIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(sphgnpolys()));
#endif
%}
!

glxSphmode: attribute value: value in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    sphmode(__intVal(attribute), __intVal(value));
#endif
%}
!

glxSphobj: objid in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    sphobj(_objectVal(objid));
#endif
%}
!

glxSphrotmatrix: mat in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    Matrix matrix, *m;

    if (! (m = __glx_getFloatsFromMatrixInto(mat, &matrix))) RETURN (false);
    SETWIN(aGLXWindowId)
    sphrotmatrix(*m);
#endif
%}
! !

!GLXWorkstation methodsFor:'stereo extension'!

glxLeftbuffer: bool in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    leftbuffer(_booleanVal(bool));
#endif
%}
!

glxMonobufferIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    monobuffer();
#endif
%}
!

glxRightbuffer: bool in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    rightbuffer(_booleanVal(bool));
#endif
%}
!

stereoExtensionBuffer:aBufferSymbol for:aWindowId
    "set the current stereo buffer; the argument may be one of:
	#left        -> STEREO_BUFFER_LEFT
	#right       -> STEREO_BUFFER_RIGHT
    "

%{  /* NOCONTEXT */
#if defined(XSGIStereo) && defined(GLX)
    Status status;
    int buffer;
    Window win;

    if (ISCONNECTED
     && __isExternalAddress(aWindowId)) {
	win = _WindowVal(aWindowId);
	if (aBufferSymbol == @symbol(left)) {
	    buffer = STEREO_BUFFER_LEFT;
	} else {
	    if (aBufferSymbol == @symbol(right)) {
		buffer = STEREO_BUFFER_RIGHT;
	    } else {
		goto bad;
	    }
	}
	status = XSGISetStereoBuffer(myDpy, win, buffer);
	RETURN ( status ? true : false);
    }
  bad: ;
#endif
%}.
    self primitiveFailed

    "
     |t v|

     t := StandardSystemView new.
     t extent:300@300.
     v := GLXView origin:0.0@0.0 corner:1.0@1.0 in:t.
     t openAndWait.

     v device stereoExtensionBuffer:#left for:(v id).
     (Delay forSeconds:10) wait.
     v device stereoExtensionBuffer:#right for:(v id).
    "
!

stereoExtensionMode:aModeSymbol height:h offset:o for:aWindowId
    "set the current stereo mode; the argument may be one of:
	nil/false #off -> turn it off
	#bottom        -> STEREO_BOTTOM
	#top           -> STEREO_TOP
    "

%{  /* NOCONTEXT */
#if defined(XSGIStereo) && defined(GLX)
    Status status;
    int mode;
    unsigned short us_h, us_o;
    Window win;

    if (ISCONNECTED
     && __bothSmallInteger(h, o)
     && __isExternalAddress(aWindowId)) {
	win = _WindowVal(aWindowId);
	if ((aModeSymbol == nil)
	 || (aModeSymbol == false)
	 || (aModeSymbol == @symbol(off))) {
	    mode = STEREO_OFF;
	} else {
	    if (aModeSymbol == @symbol(bottom)) {
		mode = STEREO_BOTTOM;
	    } else {
		if (aModeSymbol == @symbol(top)) {
		    mode = STEREO_TOP;
		} else {
		    goto bad;
		}
	    }
	}
	us_h = __intVal(h);
	us_o = __intVal(o);
	status = XSGISetStereoMode(myDpy, win, us_h, us_o, mode);
	RETURN ( status ? true : false);
    }
  bad: ;
#endif
%}.
    self primitiveFailed

    "
     Display stereoExtensionMode:#top height:492 offset:532 for:(Display rootWindowId).
     (Delay forSeconds:10) wait.
     Display stereoExtensionMode:#off height:0 offset:0 for:(Display rootWindowId).
    "
!

stereoExtensionModeIn:aWindowId
    "return the current stereo mode for some window"

%{  /* NOCONTEXT */
#if defined(XSGIStereo) && defined(GLX)
    int mode;
    Window win;

    if (ISCONNECTED && __isExternalAddress(aWindowId)) {
	win = _WindowVal(aWindowId);
	mode = XSGIQueryStereoMode(myDpy, win);
	switch (mode) {
	    case STEREO_OFF:
		RETURN ( @symbol(off) );
	    case STEREO_BOTTOM:
		RETURN ( @symbol(bottom) );
	    case STEREO_TOP:
		RETURN ( @symbol(top) );
	}
	RETURN ( @symbol(unsupported) );
    }
#endif
%}.
    self primitiveFailed

    "
     |v|

     v := StandardSystemView new.
     v extent:300@300.
     v openAndWait.
     v device stereoExtensionModeIn:(v id)

     Display stereoExtensionModeIn:Display rootWindowId
    "
!

stereoExtensionVersion
    "return the stereo extensions version as an array consisting of
     major and minor numbers."

%{  /* NOCONTEXT */
#if defined(XSGIStereo) && defined(GLX)
    Status status;
    Display *dpy = myDpy;
    int major, minor;

    if (ISCONNECTED) {
	status = XSGIStereoQueryVersion(myDpy, &major, &minor);
	if (status == True) {
	    RETURN ( __ARRAY_WITH2(__MKSMALLINT(major), __MKSMALLINT(minor)));
	}
    }
#endif
%}.
    self primitiveFailed

    "
     Display stereoExtensionVersion
    "
! !

!GLXWorkstation methodsFor:'texture data transfer'!

glxT2d: v in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    double vec[2], *c_v;

    if (! (c_v = __glx_getDoublesFromInto(v, vec, 2))) RETURN(false);
    SETWIN(aGLXWindowId)
    t2d(c_v);
#endif
%}
!

glxT2f: v in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    float vec[2], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 2))) RETURN(false);
    SETWIN(aGLXWindowId)
    t2f(c_v);
#endif
%}
!

glxT2i: v in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    long vec[2], *c_v;

    if (! (c_v = __glx_getLongsFromInto(v, vec, 2))) RETURN(false);
    SETWIN(aGLXWindowId)
    t2i(c_v);
#endif
%}
!

glxT2s: v in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    short vec[2], *c_v;

    if (! (c_v = __glx_getShortsFromInto(v, vec, 2))) RETURN(false);
    SETWIN(aGLXWindowId)
    t2s(c_v);
#endif
%}
!

glxT3d:v in:aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    double vec[3], *c_v;

    if (! (c_v = __glx_getDoublesFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
    t3d(c_v);
#endif
%}
!

glxT3f:v in:aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    float vec[3], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
    t3f(c_v);
#endif
%}
!

glxT3i:v in:aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    long vec[3], *c_v;

    if (! (c_v = __glx_getLongsFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
    t3i(c_v);
#endif
%}
!

glxT3s:v in:aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    short vec[3], *c_v;

    if (! (c_v = __glx_getShortsFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
    t3s(c_v);
#endif
%}
!

glxT4d: v in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    double vec[4], *c_v;

    if (! (c_v = __glx_getDoublesFromInto(v, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
    t4d(c_v);
#endif
%}
!

glxT4f: v in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    float vec[4], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
    t4f(c_v);
#endif
%}
!

glxT4i: v in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    long vec[4], *c_v;

    if (! (c_v = __glx_getLongsFromInto(v, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
    t4i(c_v);
#endif
%}
!

glxT4s: v in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    short vec[4], *c_v;

    if (! (c_v = __glx_getShortsFromInto(v, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
    t4s(c_v);
#endif
%}
! !

!GLXWorkstation methodsFor:'transformations'!

glxRotate:angle axis:axis in:aGLXWindowId
    "rotate the current matrix around the axis given by the axis arg,
     which must be one of the symbols: #x, #y or #z.
     The angle is in degrees."

%{  /* NOCONTEXT */

    char c_axis;

    if (axis == @symbol(x))
	c_axis = 'x';
    else if (axis == @symbol(y))
	c_axis = 'y';
    else if (axis == @symbol(z))
	c_axis = 'z';
    else {
	RETURN (false);
    }

    SETWIN(aGLXWindowId)
    RETURN ( __glx_doRotate(angle, c_axis) );
%}
!

glxRotate:arrayOf3Floats in:aGLXWindowId
    "rotate current matrix, given a 3-element vector (or more).
     The elements of the array are degrees."

%{  /* NOCONTEXT */

    float vec[3], *v;

    if (! (v = __glx_getFloatsFromInto(arrayOf3Floats, vec, 3))) RETURN(false);

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rot(v[0], 'x');
    rot(v[1], 'y');
    rot(v[2], 'z');
#endif
%}
!

glxRotateI:angle axis:axis in:aGLXWindowId
    "rotate the current matrix around the axis given by the axis arg,
     which must be one of the symbols: #x, #y or #z.
     The angle is an integer specifying tenths of a degree."

%{  /* NOCONTEXT */

    char c_axis;

    if (axis == @symbol(x))
	c_axis = 'x';
    else if (axis == @symbol(y))
	c_axis = 'y';
    else if (axis == @symbol(z))
	c_axis = 'z';
    else {
	RETURN (false);
    }

    if (__isSmallInteger(angle)) {
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rotate(__intVal(angle), c_axis);
#endif
    }
%}
!

glxRotateIX:angle in:aGLXWindowId
    "rotate the current matrix on x axis.
     The angle is an integer specifying tenths of a degree."

%{  /* NOCONTEXT */

    if (__isSmallInteger(angle)) {
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rotate(__intVal(angle), 'x');
#endif
    }
%}
!

glxRotateIX:xAngle y:yAngle z:zAngle in:aGLXWindowId
    "rotate the current matrix on all axes, given individual x, y and z values.
     The values are smallIntegers specifying tenths of a degree."

%{  /* NOCONTEXT */

    if (__bothSmallInteger(xAngle, yAngle)
     && __isSmallInteger(zAngle)) {
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rotate(__intVal(xAngle), 'x');
	rotate(__intVal(yAngle), 'y');
	rotate(__intVal(zAngle), 'z');
#endif
    }
%}
!

glxRotateIY:angle in:aGLXWindowId
    "rotate the current matrix on x axis.
     The angle is an integer specifying tenths of a degree."

%{  /* NOCONTEXT */

    if (__isSmallInteger(angle)) {
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rotate(__intVal(angle), 'y');
#endif
    }
%}
!

glxRotateIZ:angle in:aGLXWindowId
    "rotate the current matrix on x axis.
     The angle is an integer specifying tenths of a degree."

%{  /* NOCONTEXT */

    if (__isSmallInteger(angle)) {
	SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
	rotate(__intVal(angle), 'z');
#endif
    }
%}
!

glxRotateX:angle in:aGLXWindowId
    "rotate the current matrix on x axis.
     The angle is in degrees."

%{  /* NOCONTEXT */

    SETWIN(aGLXWindowId)
    RETURN (__glx_doRotate(angle, 'x'));
%}
!

glxRotateX:xAngle y:yAngle z:zAngle in:aGLXWindowId
    "rotate the current matrix on all axes, given individual x, y and z values.
     The values are in degrees"

%{  /* NOCONTEXT */

    SETWIN(aGLXWindowId)
    if ( __glx_doRotate(xAngle, 'x') == true) {
	if ( __glx_doRotate(yAngle, 'y') == true) {
	    RETURN (__glx_doRotate(zAngle, 'z'));
	}
    }
%}
!

glxRotateY:angle in:aGLXWindowId
    "rotate the current matrix on y axis.
     The angle is in degrees."

%{  /* NOCONTEXT */

    SETWIN(aGLXWindowId)
    RETURN (__glx_doRotate(angle, 'y'));
%}
!

glxRotateZ:angle in:aGLXWindowId
    "rotate the current matrix on z axis.
     The angle is in degrees."

%{  /* NOCONTEXT */

    SETWIN(aGLXWindowId)
    RETURN (__glx_doRotate(angle, 'z'));
%}
!

glxScale:arrayOf3Floats in:aGLXWindowId
    "scale current matrix, given a 3-element vector"

%{  /* NOCONTEXT */

    float vec[3], *v;

    if (! (v = __glx_getFloatsFromInto(arrayOf3Floats, vec, 3))) RETURN(false);

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    scale(v[0], v[1], v[2]);
#endif
%}
!

glxScaleX:x in:aGLXWindowId
    "scale in x direction"

%{  /* NOCONTEXT */

    float f_x;

    _FLOAT_ (x, f_x)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    scale(f_x, (float)0, (float)0);
#endif
%}
!

glxScaleX:x y:y z:z in:aGLXWindowId
    "scale & mirror current matrix, given individual x, y and z values"

%{  /* NOCONTEXT */

    float f_x, f_y, f_z;

    _FLOAT_ (x, f_x)
    _FLOAT_ (y, f_y)
    _FLOAT_ (z, f_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    scale(f_x, f_y, f_z);
#endif
%}
!

glxScaleY:y in:aGLXWindowId
    "scale in y direction"

%{  /* NOCONTEXT */

    float f_y;

    _FLOAT_ (y, f_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    scale((float)0, f_y, (float)0);
#endif
%}
!

glxScaleZ:z in:aGLXWindowId
    "scale in z direction"

%{  /* NOCONTEXT */

    float f_z;

    _FLOAT_ (z, f_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    scale((float)0, (float)0, f_z);
#endif
%}
!

glxTranslate:arrayOf3Floats in:aGLXWindowId
    "translate current matrix, given a 3-element vector"

%{  /* NOCONTEXT */

    float vec[3], *v;

    if (! (v = __glx_getFloatsFromInto(arrayOf3Floats, vec, 3))) RETURN(false);

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    translate((Coord)(v[0]), (Coord)(v[1]), (Coord)(v[2]));
#endif
%}
!

glxTranslateX:x in:aGLXWindowId
    "translate current matrix on X axis"

%{  /* NOCONTEXT */

    Coord c_x;

    _COORD_ (x, c_x)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    translate(c_x, (Coord)0, (Coord)0);
#endif
%}
!

glxTranslateX:x y:y z:z in:aGLXWindowId
    "translate current matrix, given individual x, y and z values"

%{  /* NOCONTEXT */

    Coord c_x, c_y, c_z;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    _COORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    translate(c_x, c_y, c_z);
#endif
%}
!

glxTranslateY:y in:aGLXWindowId
    "translate current matrix on Y axis"

%{  /* NOCONTEXT */

    Coord c_y;

    _COORD_ (y, c_y)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    translate((Coord)0, c_y, (Coord)0);
#endif
%}
!

glxTranslateZ:z in:aGLXWindowId
    "translate current matrix on Z axis"

%{  /* NOCONTEXT */

    Coord c_z;

    _COORD_ (z, c_z)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    translate((Coord)0, (Coord)0, c_z);
#endif
%}
! !

!GLXWorkstation methodsFor:'unspecified rest'!

glxAcbufOp:op value:value in:aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    acbuf(__intVal(op), _floatVal(value));
#endif
%}
!

glxAcsizePlanes: planes in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    acsize(__intVal(planes));
#endif
%}
!

glxAfunctionRef: ref func: func in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    afunction(__intVal(ref), __intVal(func));
#endif
%}
!

glxBbox2Xmin: xmin ymin: ymin x1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
    Screencoord c_xmin, c_ymin;
    Coord c_x1, c_y1, c_x2, c_y2;

    _SCREENCOORD_ (xmin, c_xmin)
    _SCREENCOORD_ (ymin, c_ymin)
    _COORD_ (x1, c_x1)
    _COORD_ (y1, c_y1)
    _COORD_ (x2, c_x2)
    _COORD_ (y2, c_y2)
    SETWIN(aGLXWindowId)
#ifdef GLX
    bbox2(c_xmin, c_ymin, c_x1, c_y1, c_x2, c_y2);
#endif
%}
!

glxBbox2iXmin: xmin ymin: ymin x1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
    Screencoord c_xmin, c_ymin;
    Icoord c_x1, c_y1, c_x2, c_y2;

    _SCREENCOORD_ (xmin, c_xmin)
    _SCREENCOORD_ (ymin, c_ymin)
    _ICOORD_ (x1, c_x1)
    _ICOORD_ (y1, c_y1)
    _ICOORD_ (x2, c_x2)
    _ICOORD_ (y2, c_y2)
    SETWIN(aGLXWindowId)
#ifdef GLX
    bbox2i(c_xmin, c_ymin, c_x1, c_y1, c_x2, c_y2);
#endif
%}
!

glxBbox2sXmin: xmin ymin: ymin x1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
    Screencoord c_xmin, c_ymin;
    Scoord c_x1, c_y1, c_x2, c_y2;

    _SCREENCOORD_ (xmin, c_xmin)
    _SCREENCOORD_ (ymin, c_ymin)
    _SCOORD_ (x1, c_x1)
    _SCOORD_ (y1, c_y1)
    _SCOORD_ (x2, c_x2)
    _SCOORD_ (y2, c_y2)
    SETWIN(aGLXWindowId)
#ifdef GLX
    bbox2s(c_xmin, c_ymin, c_x1, c_y1, c_x2, c_y2);
#endif
%}
!

glxBeginTrimIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    bgntrim();
#endif
%}
!

glxBlankscreen: b in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    blankscreen(_booleanVal(b));
#endif
%}
!

glxBlanktime: count in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    blanktime(__intVal(count));
#endif
%}
!

glxBlendcolorRed: red green: green blue: blue alpha: alpha in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef FULL_GLX
    blendcolor(_floatVal(red), _floatVal(green), _floatVal(blue), _floatVal(alpha));
#endif
%}
!

glxBlendfunctionSfactr: sfactr dfactr: dfactr in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    blendfunction(__intVal(sfactr), __intVal(dfactr));
#endif
%}
!

glxBlinkRate: rate i: i red: red green: green blue: blue in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    blink(_shortVal(rate), _colorindexVal(i),
	  _shortVal(red), _shortVal(green), _shortVal(blue));
#endif
%}
!

glxBlkqreadData: data n: n in: aGLXWindowId

%{  /* NOCONTEXT */
    int rslt = -1;

    SETWIN(aGLXWindowId)
#ifdef GLX
    rslt = blkqread((short *)_indexedArea(data), __intVal(n));
#endif
    RETURN (__MKSMALLINT(rslt));
%}
!

glxC3f: v in: aGLXWindowId

%{  /* NOCONTEXT */
    float vec[3], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef GLX
    c3f(c_v);
#endif
%}
!

glxC3i: v in: aGLXWindowId

%{  /* NOCONTEXT */
    long vec[3], *c_v;

    if (! (c_v = __glx_getLongsFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef GLX
    c3i(c_v);
#endif
%}
!

glxC3s: v in: aGLXWindowId

%{  /* NOCONTEXT */
    short vec[3], *c_v;

    if (! (c_v = __glx_getShortsFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef GLX
    c3s(c_v);
#endif
%}
!

glxC4f: v in: aGLXWindowId

%{  /* NOCONTEXT */
    float vec[4], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef GLX
    c4f(c_v);
#endif
%}
!

glxC4i: v in: aGLXWindowId

%{  /* NOCONTEXT */
    long vec[4], *c_v;

    if (! (c_v = __glx_getLongsFromInto(v, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef GLX
    c4i(c_v);
#endif
%}
!

glxC4s: v in: aGLXWindowId

%{  /* NOCONTEXT */
    short vec[4], *c_v;

    if (! (c_v = __glx_getShortsFromInto(v, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef GLX
    c4s(c_v);
#endif
%}
!

glxClearhitcodeIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    clearhitcode();
#endif
%}
!

glxClipplaneIndex: index mode: mode params: params in: aGLXWindowId

%{  /* NOCONTEXT */
    float vec[4], *v;

    if (! (v = __glx_getFloatsFromInto(params, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef GLX
    clipplane(__intVal(index), __intVal(mode), v);
#endif
%}
!

glxCmodeIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    cmode();
#endif
%}
!

glxColorfIndex: index in: aGLXWindowId

    ^self glxColor: index in: aGLXWindowId
!

glxCuroriginN: n xorigin: xorigin yorigin: yorigin in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    curorigin(_shortVal(n), _shortVal(xorigin), _shortVal(yorigin));
#endif
%}
!

glxCursoffIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    cursoff();
#endif
%}
!

glxCursonIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    curson();
#endif
%}
!

glxCurstype: type in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    curstype(__intVal(type));
#endif
%}
!

glxCyclemapDuration: duration map: map nxtmap: nxtmap in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    cyclemap(_shortVal(duration), _shortVal(map), _shortVal(nxtmap));
#endif
%}
!

glxDefpatternN: n size: size mask: mask in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    defpattern(_shortVal(n), _shortVal(size), (unsigned short *)_indexedArea(mask));
#endif
%}
!

glxDeltag: t in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    deltag(_tagVal(t));
#endif
%}
!

glxDepthcueMode: mode in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    depthcue(_booleanVal(mode));
#endif
%}
!

glxDitherMode: mode in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    dither(_longVal(mode));
#endif
%}
!

glxDopup: pup in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    dopup(_longVal(pup));
#endif
%}
!

glxDrawmode: mode in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    drawmode(_longVal(mode));
#endif
%}
!

glxEditobj: obj in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    editobj(_objectVal(obj));
#endif
%}
!

glxEndTrimIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    endtrim();
#endif
%}
!

glxEndfullscrnIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    endfullscrn();
#endif
%}
!

glxEndpupmodeIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    endpupmode();
#endif
%}
!

glxFinishIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    finish();
#endif
%}
!

glxFont: fntnum in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    font(_shortVal(fntnum));
#endif
%}
!

glxForegroundIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    foreground();
#endif
%}
!

glxFreepup: pup in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    freepup(_longVal(pup));
#endif
%}
!

glxFudgeXfudge: xfudge yfudge: yfudge in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    fudge(_longVal(xfudge), _longVal(yfudge));
#endif
%}
!

glxFullscrnIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    fullscrn();
#endif
%}
!

glxGbeginIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef GLX
    gbegin();
#endif
%}
!

glxGentagIn: aGLXWindowId

%{  /* NOCONTEXT */
    int rslt = -1;

#ifdef GLX
    SETWIN(aGLXWindowId)
    rslt = gentag();
#endif
    RETURN (__MKSMALLINT(rslt));
%}
!

glxGetbackfaceIn: aGLXWindowId

%{  /* NOCONTEXT */
    int rslt = -1;

#ifdef GLX
    SETWIN(aGLXWindowId)
    rslt = getbackface();
#endif
    RETURN (__MKSMALLINT(rslt));
%}
!

glxGetbufferIn: aGLXWindowId

%{  /* NOCONTEXT */
    int rslt = -1;

#ifdef GLX
    SETWIN(aGLXWindowId)
    rslt = getbuffer();
#endif
    RETURN (__MKSMALLINT(rslt));
%}
!

glxGetbutton: num in: aGLXWindowId

%{  /* NOCONTEXT */
    int rslt = -1;

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rslt = getbutton(_deviceVal(num));
#endif
    RETURN (__MKSMALLINT(rslt));
%}
!

glxGetcmmodeIn: aGLXWindowId

%{  /* NOCONTEXT */
    int rslt = 0;

    SETWIN(aGLXWindowId)
#ifdef GLX
    rslt = getcmmode();
#endif
    RETURN (__MKBOOLEAN(rslt));
%}
!

glxGetcolorIn: aGLXWindowId
    "return the current drawing color"

%{  /* NOCONTEXT */
    int rslt = -1;

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rslt = getcolor();
#endif
    RETURN (__MKSMALLINT(rslt));
%}
!

glxGetdcmIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKBOOLEAN(getdcm()));
#endif
%}
.
    ^ false
!

glxGetdescenderIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getdescender()));
#endif
%}
.
    ^ false
!

glxGetdisplaymodeIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getdisplaymode()));
#endif
%}
.
    ^ false
!

glxGetdrawmodeIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getdrawmode()));
#endif
%}
.
    ^ false
!

glxGetfontIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getfont()));
#endif
%}
.
    ^ false
!

glxGetgconfigBuffer: buffer in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getgconfig(_longVal(buffer))));
#endif
%}
.
    ^ false
!

glxGetgdescInquiry: inquiry in: aGLXWindowId

%{  /* NOCONTEXT */
    int rslt = 0;

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rslt = getgdesc(_longVal(inquiry));
#endif
    RETURN (__MKSMALLINT(rslt));
%}
!

glxGetheightIn: aGLXWindowId

%{  /* NOCONTEXT */
    int rslt = 0;

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rslt = getheight();
#endif
    RETURN (__MKSMALLINT(rslt));
%}
!

glxGethitcodeIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(gethitcode()));
#endif
%}
.
    ^ false
!

glxGetlsbackupIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKBOOLEAN(getlsbackup()));
#endif
%}
.
    ^ false
!

glxGetlsrepeatIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getlsrepeat()));
#endif
%}
.
    ^ false
!

glxGetlstyleIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getlstyle()));
#endif
%}
.
    ^ false
!

glxGetlwidthIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getlwidth()));
#endif
%}
.
    ^ false
!

glxGetmapIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getmap()));
#endif
%}
.
    ^ false
!

glxGetmmodeIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getmmode()));
#endif
%}
.
    ^ false
!

glxGetmonitorIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getmonitor()));
#endif
%}
.
    ^ false
!

glxGetmultisampleIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKBOOLEAN(getmultisample()));
#endif
%}
.
    ^ false
!

glxGetothermonitorIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getothermonitor()));
#endif
%}
.
    ^ false
!

glxGetpatternIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getpattern()));
#endif
%}
.
    ^ false
!

glxGetresetlsIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKBOOLEAN(getresetls()));
#endif
%}
.
    ^ false
!

glxGetshadeIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getshade()));
#endif
%}
.
    ^ false
!

glxGetsmIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getsm()));
#endif
%}
.
    ^ false
!

glxGetvaluator: dev in: aGLXWindowId

%{  /* NOCONTEXT */
#ifndef OPENGL
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getvaluator(_deviceVal(dev))));
#endif
%}
.
    ^ false
!

glxGetvideo: reg in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getvideo(_longVal(reg))));
#endif
%}
.
    ^ false
!

glxGetwritemaskIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getwritemask()));
#endif
%}
.
    ^ false
!

glxGetwscrnIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(getwscrn()));
#endif
%}
.
    ^ false
!

glxGetzbufferIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKBOOLEAN(getzbuffer()));
#endif
%}
.
    ^ false
!

glxGexitIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    gexit();
#endif
%}
!

glxGflushIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    gflush();
#endif
%}
!

glxGinitIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    ginit();
#endif
%}
!

glxGlcompatMode: mode value: value in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    glcompat(_longVal(mode), _longVal(value));
#endif
%}
!

glxGresetIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    greset();
#endif
%}
!

glxGsyncIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    gsync();
#endif
%}
!

glxIconsizeX: x y: y in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    iconsize(_longVal(x), _longVal(y));
#endif
%}
!

glxImakebackgroundIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    imakebackground();
#endif
%}
!

glxInitnamesIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    initnames();
#endif
%}
!

glxIsqueued: dev in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKBOOLEAN(isqueued(_deviceVal(dev))));
#endif
%}
.
    ^ false
!

glxIstag: t in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKBOOLEAN(istag(_tagVal(t))));
#endif
%}
.
    ^ false
!

glxKeepaspectX: x y: y in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    keepaspect(_longVal(x), _longVal(y));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxLinesmoothMode: mode in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    linesmooth((ulong)__intVal(mode));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxLmcolorMode: mode in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    lmcolor(_longVal(mode));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxLoadname: name in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    loadname(_shortVal(name));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxLogicop: opcode in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    logicop(_longVal(opcode));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxLsbackup: b in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    lsbackup(_booleanVal(b));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxLsetdepthNear:znear far:zfar in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    lsetdepth(_longVal(znear), _longVal(zfar));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxLshaderangeLowin: lowin hiwin: hiwin znear: znear zfar: zfar in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    lshaderange(_colorindexVal(lowin), _colorindexVal(hiwin),
	_longVal(znear), _longVal(zfar));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxLsrepeatFactor: factor in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    lsrepeat(_longVal(factor));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxMaketag: t in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    maketag(_tagVal(t));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxMaxsizeX: x y: y in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    maxsize(_longVal(x), _longVal(y));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxMinsizeX: x y: y in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    minsize(_longVal(x), _longVal(y));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxMsalphaMode: mode in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    msalpha(_longVal(mode));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxMsmask: mask inverse: inverse in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    msmask(_floatVal(mask), _booleanVal(inverse));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxMspattern: pattern in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    mspattern(_longVal(pattern));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxMssizeSamples: samples zsize: zsize ssize: ssize in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    mssize(_longVal(samples), _longVal(zsize), _longVal(ssize));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxMswapbuffers: fbuf in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    mswapbuffers(_longVal(fbuf));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxMultimapIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    multimap();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxMultisample: bool in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    multisample(_booleanVal(bool));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxNewpupIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(newpup()));
#endif
%}
.
    ^ false
!

glxNewtag: newtg oldtg: oldtg offst: offst in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    newtag(_tagVal(newtg), _tagVal(oldtg), _offsetVal(offst));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxNoborderIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    noborder();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxNoise: v delta: delta in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    noise(_deviceVal(v), _shortVal(delta));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxNoportIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    noport();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxNurbscurveKnotCount: knotCount knotList: knotList
    offset: offset ctlArray: ctlArray
    order: order type: type in: aGLXWindowId

    | ctlPoints i |
    ctlPoints := DoubleArray new: ctlArray size * (ctlArray first size).
    i := 1.
    ctlArray do: [:point |
	point do: [:coord |
	    ctlPoints at: i put: coord.
	    i := i + 1]].

%{  /* NOCONTEXT */
#ifdef GLX
    char *knotElements, *ctlElements;
    OBJ cls;
    int ninstVars, nInstBytes;

    SETWIN(aGLXWindowId)
    cls = __qClass(ctlPoints);
    ninstVars = __intVal(_ClassInstPtr(cls)->c_ninstvars);
    nInstBytes = OHDR_SIZE + ninstVars * sizeof(OBJ);

    ctlElements = (char *)(_InstPtr(ctlPoints)) + nInstBytes;
    knotElements = (char *)(_InstPtr(knotList)) + nInstBytes;

    nurbscurve (
	_longVal(knotCount), (double *)knotElements,
	_longVal(offset), (double *)ctlElements,
	_longVal(order), _longVal(type));
    RETURN(true);
#endif
%}
.
    ^ false
!

glxObjdeleteTag1: tag1 tag2: tag2 in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    objdelete(_tagVal(tag1), _tagVal(tag2));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxObjinsert: t in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    objinsert(_tagVal(t));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxObjreplace: t in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    objreplace(_tagVal(t));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxOnemapIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    onemap();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxPagecolor: pcolor in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    pagecolor(_colorindexVal(pcolor));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxPassthroughToken: token in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    passthrough(_shortVal(token));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxPclosIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    pclos();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxPicksizeX: x y: y in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    picksize(_shortVal(x), _shortVal(y));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxPixmode: mode value: value in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    pixmode(_longVal(mode), _longVal(value));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxPntsmoothMode: mode in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    pntsmooth((ulong)__intVal(mode));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxPolysmoothMode: mode in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    polysmooth(_longVal(mode));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxPopnameIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    popname();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxPrefpositionX1: x1 x2: x2 y1: y1 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    prefposition(_longVal(x1), _longVal(x2), _longVal(y1), _longVal(y2));
#endif
    RETURN (true);
%}
!

glxPrefsizeX: x y: y in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    prefsize(_longVal(x), _longVal(y));
#endif
    RETURN (true);
%}
!

glxPupmodeIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    pupmode();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxPushname: name In: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    pushname(_shortVal(name));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxQdevice: dev in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    qdevice(_deviceVal(dev));
#endif
%}
!

glxQenterDev: dev val: val in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    qenter(_deviceVal(dev), _shortVal(val));
#endif
%}
!

glxQgetfdIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(qgetfd()));
#endif
%}
.
    ^ false
!

glxQreadIn: aGLXWindowId

    | dev data |
%{
    short c_data;

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    dev = __MKSMALLINT(qread(&c_data));
    data = __MKSMALLINT(c_data);
#endif
%}
.
    ^ Array with: dev with: data
!

glxQresetIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    qreset();
#endif
    RETURN (true);
%}
!

glxQtestIn: aGLXWindowId

%{  /* NOCONTEXT */
    int rslt = 0;

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    rslt = qtest();
#endif
    RETURN (__MKSMALLINT(rslt));
%}
!

glxRGBcursorIndex: index red: red green: green blue: blue
    redm: redm greenm: greenm bluem: bluem in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RGBcursor(_shortVal(index),
	_shortVal(red), _shortVal(green), _shortVal(blue),
	_shortVal(redm), _shortVal(greenm), _shortVal(bluem));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxRGBwritemaskRed: red green: green blue: blue in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RGBwritemask(_shortVal(red), _shortVal(green), _shortVal(blue));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxRectzoomX: xfactor y: yfactor in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    rectzoom(_floatVal(xfactor), _floatVal(yfactor));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxResetls: b in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    resetls(_booleanVal(b));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxRingbellIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    ringbell();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSboxX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    sbox(_coordVal(x1), _coordVal(y1), _coordVal(x2), _coordVal(y2));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSboxfX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    sboxf(_coordVal(x1), _coordVal(y1), _coordVal(x2), _coordVal(y2));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSboxfiX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    sboxfi(_icoordVal(x1), _icoordVal(y1), _icoordVal(x2), _icoordVal(y2));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSboxfsX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    sboxfs(_scoordVal(x1), _scoordVal(y1), _scoordVal(x2), _scoordVal(y2));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSboxiX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    sboxi(_icoordVal(x1), _icoordVal(y1), _icoordVal(x2), _icoordVal(y2));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSboxsX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    sboxs(_scoordVal(x1), _scoordVal(y1), _scoordVal(x2), _scoordVal(y2));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSclearSval: sval in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    sclear((ulong)__intVal(sval));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxScrbox: arg in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    scrbox(_longVal(arg));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxScreenspaceIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    screenspace();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxScrmaskLeft: left right: right bottom: bottom top: top in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    scrmask(_screencoordVal(left), _screencoordVal(right),
	_screencoordVal(bottom), _screencoordVal(top));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxScrnattach: gsnr in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    scrnattach(_longVal(gsnr));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxScrnselect: gsnr in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    scrnselect(_longVal(gsnr));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSetcursorIndex: index color: color wtn: wtn in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    setcursor(_shortVal(index), _colorindexVal(color), _colorindexVal(wtn));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSetdblightsMask: mask in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    setdblights((ulong)__intVal(mask));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSetdepthNear:znear far:zfar in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    setdepth(_screencoordVal(znear), _screencoordVal(zfar));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSetmap: mapnum in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    setmap(_shortVal(mapnum));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSetmonitor: mtype in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    setmonitor(_shortVal(mtype));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSetnurbsproperty: property value: value in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    setnurbsproperty(_longVal(property), _floatVal(value));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSetpattern: index in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    setpattern(_shortVal(index));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSetpup: pup entry: entry mode: mode in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    setpup(_longVal(pup), _longVal(entry), (ulong)__intVal(mode));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSetvaluator: v init: init vmin: vmin vmax: vmax in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    setvaluator(_deviceVal(v), _shortVal(init), _shortVal(vmin), _shortVal(vmax));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSetvideo: reg value: value in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    setvideo(_longVal(reg), _longVal(value));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxShademodel: model in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    shademodel(_longVal(model));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxShaderangeLowin: lowin hiwin: hiwin z1: z1 z2: z2 in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    shaderange(_colorindexVal(lowin), _colorindexVal(hiwin),
	_screencoordVal(z1), _screencoordVal(z2));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSmoothline: mode in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    smoothline(_longVal(mode));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxStencilEnable: enable ref: ref func: func mask: mask fail: fail
    pass: pass zpass: zpass in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    stencil(_longVal(enable), (ulong)__intVal(ref), _longVal(func),
	(ulong)__intVal(mask), _longVal(fail), _longVal(pass), _longVal(zpass));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxStensize: planes in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    stensize(_longVal(planes));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxStepunitX: x y: y in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    stepunit(_longVal(x), _longVal(y));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSubpixel: b in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    subpixel(_booleanVal(b));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSwapinterval: i in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    swapinterval(_shortVal(i));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSwaptmeshIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    swaptmesh();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSwinopen: parent in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    swinopen(_longVal(parent));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxSwritemask: mask in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    swritemask((ulong)__intVal(mask));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxTextinitIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    textinit();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxTextportLeft: left right: right bottom: bottom top: top in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    textport(_screencoordVal(left), _screencoordVal(right),
	_screencoordVal(bottom), _screencoordVal(top));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxTieB: b v1: v1 v2: v2 in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    tie(_deviceVal(b), _deviceVal(v1), _deviceVal(v2));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxTlutbind: target index: index in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    tlutbind(_longVal(target), _longVal(index));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxTpoffIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    tpoff();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxTponIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    tpon();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxUnqdevice: dev in: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    unqdevice(_deviceVal(dev));
#endif
%}
!

glxWmpack: pack in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    wmpack((ulong)__intVal(pack));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxWritemask: wtm in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    writemask(_colorindexVal(wtm));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxXfpt2X: x y: y in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    Coord c_x, c_y;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    SETWIN(aGLXWindowId)
    xfpt2(c_x, c_y);
    RETURN (true);
#endif
%}
.
    ^ false
!

glxXfpt2iX: x y: y in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    Icoord c_x, c_y;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
    xfpt2i(c_x, c_y);
    RETURN (true);
#endif
%}
.
    ^ false
!

glxXfpt2sX: x y: y in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    Scoord c_x, c_y;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    SETWIN(aGLXWindowId)
    xfpt2s(c_x, c_y);
    RETURN (true);
#endif
%}
.
    ^ false
!

glxXfpt4X: x y: y z: z w: w in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    Coord c_x, c_y, c_z, c_w;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    _COORD_ (z, c_z)
    _COORD_ (w, c_w)
    SETWIN(aGLXWindowId)
    xfpt4(c_x, c_y, c_z, c_w);
    RETURN (true);
#endif
%}
.
    ^ false
!

glxXfpt4iX: x y: y z: z w: w in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    Icoord c_x, c_y, c_z, c_w;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    _ICOORD_ (z, c_z)
    _ICOORD_ (w, c_w)
    SETWIN(aGLXWindowId)
    xfpt4i(c_x, c_y, c_z, c_w);
    RETURN (true);
#endif
%}
.
    ^ false
!

glxXfpt4sX: x y: y z: z w: w in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    Scoord c_x, c_y, c_z, c_w;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    _SCOORD_ (z, c_z)
    _SCOORD_ (w, c_w)
    SETWIN(aGLXWindowId)
    xfpt4s(c_x, c_y, c_z, c_w);
    RETURN (true);
#endif
%}
.
    ^ false
!

glxXfptX: x y: y z: z in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    Coord c_x, c_y, c_z;

    _COORD_ (x, c_x)
    _COORD_ (y, c_y)
    _COORD_ (z, c_z)
    SETWIN(aGLXWindowId)
    xfpt(c_x, c_y, c_z);
    RETURN (true);
#endif
%}
.
    ^ false
!

glxXfptiX: x y: y z: z in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    Icoord c_x, c_y, c_z;

    _ICOORD_ (x, c_x)
    _ICOORD_ (y, c_y)
    _ICOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
    xfpti(c_x, c_y, c_z);
    RETURN (true);
#endif
%}
.
    ^ false
!

glxXfptsX: x y: y z: z in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    Scoord c_x, c_y, c_z;

    _SCOORD_ (x, c_x)
    _SCOORD_ (y, c_y)
    _SCOORD_ (z, c_z)
    SETWIN(aGLXWindowId)
    xfpts(c_x, c_y, c_z);
    RETURN (true);
#endif
%}
.
    ^ false
! !

!GLXWorkstation methodsFor:'vertex data transfer'!

glxN3f:arrayOf3Floats in:aGLXWindowId
    "argument must be an array of 3 floats containing the
     current vertex normal - in real GL only"

%{  /* NOCONTEXT */
#ifdef GLX
    float vec[3], *v;

    if (! (v = __glx_getFloatsFromInto(arrayOf3Floats, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
    n3f(v);
    RETURN (true);
#endif
%}
.
    ^ false
!

glxV2d:v in:aGLXWindowId
    "pass a vertex; v must be a vector with 2 doubles; z is taken as 0"

%{  /* NOCONTEXT */
    double vec[2], *c_v;

    if (! (c_v = __glx_getDoublesFromInto(v, vec, 2))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v2d(c_v);
#endif
    RETURN (true);
%}
!

glxV2f:v in:aGLXWindowId
    "pass a vertex; v must be a vector with 2 floats; z is taken as 0"

%{  /* NOCONTEXT */
    float vec[2], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 2))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v2f(c_v);
#endif
    RETURN (true);
%}
!

glxV2fX:x y:y in:aGLXWindowId
    "pass a vertex from individual x and y values; z is taken as 0.0"

%{  /* NOCONTEXT */
    float vec[2];

    _FLOAT_(x, vec[0])
    _FLOAT_(y, vec[1])
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v2f(vec);
#endif
    RETURN (true);
%}
!

glxV2i:v in:aGLXWindowId
    "pass a vertex; v must be a vector with 2 longs; z is taken as 0"

%{  /* NOCONTEXT */
    long vec[2], *c_v;

    if (! (c_v = __glx_getLongsFromInto(v, vec, 2))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v2i(c_v);
#endif
    RETURN (true);
%}
!

glxV2s:v in:aGLXWindowId
    "pass a vertex; v must be a vector with 2 shorts; z is taken as 0"

%{  /* NOCONTEXT */
    short vec[2], *c_v;

    if (! (c_v = __glx_getShortsFromInto(v, vec, 2))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v2s(c_v);
#endif
    RETURN (true);
%}
!

glxV3d:v in:aGLXWindowId
    "pass a vertex; v must be a 3-element double-vector"

%{  /* NOCONTEXT */
    double vec[3], *c_v;

    if (! (c_v = __glx_getDoublesFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v3d(c_v);
#endif
    RETURN (true);
%}
.
    ^ false
!

glxV3f:v in:aGLXWindowId
    "pass a vertex; v must be a 3-element float-vector"

%{  /* NOCONTEXT */
    float vec[3], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v3f(c_v);
#endif
    RETURN (true);
%}
!

glxV3fX:x y:y z:z in: aGLXWindowId
    "pass a vector from individual x, y and z (float) values"

%{  /* NOCONTEXT */
    float vec[3];

    _FLOAT_(x, vec[0])
    _FLOAT_(y, vec[1])
    _FLOAT_(z, vec[2])
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v3f(vec);
#endif
    RETURN (true);
%}
!

glxV3i:v in:aGLXWindowId
    "pass a vertex; v must be a vector with 3 longs"

%{  /* NOCONTEXT */
    long vec[3], *c_v;

    if (! (c_v = __glx_getLongsFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v3i(c_v);
#endif
    RETURN (true);
%}
!

glxV3s:v in:aGLXWindowId
    "pass a vertex; v must be a vector with 3 shorts"

%{  /* NOCONTEXT */
    short vec[3], *c_v;

    if (! (c_v = __glx_getShortsFromInto(v, vec, 3))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v3s(c_v);
#endif
    RETURN (true);
%}
!

glxV4d:v in:aGLXWindowId
    "pass a vertex; v must be a 4-element double-vector,
     containing x, y, z and w"

%{  /* NOCONTEXT */
    double vec[4], *c_v;

    if (! (c_v = __glx_getDoublesFromInto(v, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v4d(c_v);
#endif
    RETURN (true);
%}
!

glxV4f:v in:aGLXWindowId
    "pass a vertex; v must be a 4-element float-vector,
     containing x, y, z and w"

%{  /* NOCONTEXT */
    float vec[4], *c_v;

    if (! (c_v = __glx_getFloatsFromInto(v, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v4f(c_v);
#endif
    RETURN (true);
%}
!

glxV4i:v in:aGLXWindowId
    "pass a vertex; v must be a 4-element int-vector,
     containing x, y, z and w"

%{  /* NOCONTEXT */
    long vec[4], *c_v;

    if (! (c_v = __glx_getLongsFromInto(v, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v4i(c_v);
#endif
    RETURN (true);
%}
!

glxV4s:v in:aGLXWindowId
    "pass a vertex; v must be a 4-element short-vector,
     containing x, y, z and w"

%{  /* NOCONTEXT */
    short vec[4], *c_v;

    if (! (c_v = __glx_getShortsFromInto(v, vec, 4))) RETURN(false);
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v4s(c_v);
#endif
    RETURN (true);
%}
!

glxVOriginIn:aGLXWindowId
    "pass a 0.0/0.0/0.0 vector.
     This is the same as v3f:#(0.0 0.0 0.0), but, since its so
     common, this somewhat faster method has been provided"

%{  /* NOCONTEXT */
    static float vec[3] = {0.0, 0.0, 0.0};

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v3f(vec);
#endif
    RETURN (true);
%}
!

glxVUnitXIn:aGLXWindowId
    "pass a 1.0/0.0/0.0 vector.
     This is the same as v3f:#(1.0 0.0 0.0), but, since its so
     common, this somewhat faster method has been provided"

%{  /* NOCONTEXT */
    static float vec[3] = {1.0, 0.0, 0.0};

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v3f(vec);
#endif
    RETURN (true);
%}
!

glxVUnitYIn:aGLXWindowId
    "pass a 0.0/1.0/0.0 vector.
     This is the same as v3f:#(0.0 1.0 0.0), but, since its so
     common, this somewhat faster method has been provided"

%{  /* NOCONTEXT */
    static float vec[3] = {0.0, 1.0, 0.0};

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v3f(vec);
#endif
    RETURN (true);
%}
!

glxVUnitZIn:aGLXWindowId
    "pass a 0.0/0.0/1.0 vector.
     This is the same as v3f:#(0.0 0.0 1.0), but, since its so
     common, this somewhat faster method has been provided"

%{  /* NOCONTEXT */
    static float vec[3] = {0.0, 0.0, 1.0};

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    v3f(vec);
#endif
    RETURN (true);
%}
! !

!GLXWorkstation methodsFor:'video and planes'!

glxOverlayPlanes: planes in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    overlay(_longVal(planes));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxStereobufferIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    stereobuffer();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxUnderlay: planes in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    underlay(_longVal(planes));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxVideocmd:cmd in:aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    videocmd(_longVal(cmd));
    RETURN (true);
#endif
%}
.
    ^ false
! !

!GLXWorkstation methodsFor:'viewing'!

glxLookatVx:vx vy:vy vz:vz px:px py:py pz:pz twist:twist in:aGLXWindowId
    "define viewing transformation"

%{  /* NOCONTEXT */

    Coord f_vx, f_vy, f_vz, f_px, f_py, f_pz;
    Angle a_twist;

    _COORD_ (vx, f_vx)
    _COORD_ (vy, f_vy)
    _COORD_ (vz, f_vz)
    _COORD_ (px, f_px)
    _COORD_ (py, f_py)
    _COORD_ (pz, f_pz)
    _ANGLE_ (twist, a_twist)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    lookat(f_vx, f_vy, f_vz, f_px, f_py, f_pz, a_twist);
#endif
%}
!

glxOrtho2Left: left right: right bottom: bottom top: top in: aGLXWindowId
    "define 2D orthogonal projection"

%{  /* NOCONTEXT */
    float f_left, f_right, f_top, f_bottom;

    SETWIN(aGLXWindowId)
    _FLOAT_(left, f_left)
    _FLOAT_(right, f_right)
    _FLOAT_(bottom, f_bottom)
    _FLOAT_(top, f_top)
#ifdef OPENGL
#else
    ortho2(f_left, f_right, f_bottom, f_top);
#endif
%}
!

glxOrthoLeft: left right: right bottom: bottom top: top near: znear far: zfar in: aGLXWindowId
    "define orthogonal projection"

%{  /* NOCONTEXT */
    float f_left, f_right, f_bottom, f_top,
	  f_near, f_far;

    _FLOAT_(left, f_left)
    _FLOAT_(right, f_right)
    _FLOAT_(bottom, f_bottom)
    _FLOAT_(top, f_top)
    _FLOAT_(znear, f_near)
    _FLOAT_(zfar, f_far)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    ortho(f_left, f_right, f_bottom, f_top, f_near, f_far);
#endif
%}
!

glxPerspectiveFovy:fovy aspect:aspect near:znear far:zfar in:aGLXWindowId
    "define perspective projection"

%{  /* NOCONTEXT */

    Angle a_fovy;
    Coord c_near, c_far;
    float f_aspect;

    _ANGLE_ (fovy, a_fovy)
    _FLOAT_ (aspect, f_aspect)
    _COORD_ (znear, c_near)
    _COORD_ (zfar, c_far)

    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    perspective(a_fovy, f_aspect, c_near, c_far);
#endif
%}
!

glxPolarviewDist: dist azim: azim inc: inc twist: twist in: aGLXWindowId

%{  /* NOCONTEXT */
    Coord c_dist;
    Angle a_azim, a_inc, a_twist;

    _COORD_(dist, c_dist)
    _ANGLE_(azim, a_azim)
    _ANGLE_(inc, a_inc)
    _ANGLE_(twist, a_twist)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    polarview(c_dist, a_azim, a_inc, a_twist);
#endif
%}
!

glxPopviewportIn: aGLXWindowId
    "pops the top viewport off the viewport stack"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    popviewport();
#endif
%}

    "Modified: 19.3.1996 / 18:58:24 / cg"
!

glxPushviewportIn: aGLXWindowId
    "pushes the current viewport on the viewport stack"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    pushviewport();
#endif
%}

    "Modified: 19.3.1996 / 18:58:02 / cg"
!

glxReshapeViewPortIn: aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    reshapeviewport();
#endif
%}
!

glxViewportLeft:left right:right bottom:bottom top:top in:aGLXWindowId

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    viewport(_screencoordVal(left), _screencoordVal(right),
	     _screencoordVal(bottom), _screencoordVal(top));
#endif
%}
!

glxWindowLeft: left right: right bottom: bottom top: top near: znear far: zfar in: aGLXWindowId
    "this one was added independently by JEFF - kept for his programs ..."

    self glxWindowLeft:left right:right top:top bottom:bottom near:znear far:zfar in:aGLXWindowId
!

glxWindowLeft:left right:right top:top bottom:bottom near:znear far:zfar in:aGLXWindowId
    "define perspective viewing pyramid"

%{  /* NOCONTEXT */
    Coord c_left, c_right, c_top, c_bot, c_near, c_far;

    _COORD_ (left, c_left)
    _COORD_ (right, c_right)
    _COORD_ (top, c_top)
    _COORD_ (bottom, c_bot)
    _COORD_ (znear, c_near)
    _COORD_ (zfar, c_far)
    SETWIN(aGLXWindowId)
#ifdef OPENGL
#else
    window(c_left, c_right, c_bot, c_top, c_near, c_far);
#endif
%}
! !

!GLXWorkstation methodsFor:'window control'!

glxResizedView:aGLXWindowId width:width height:height
    "pass down resize info to the GL - this adjusts the viewport.
     This only works with VGL or openGL"

%{  /* NOCONTEXT */
    SETWIN(aGLXWindowId)
#ifdef VGL
    X11_resized(__intVal(width), __intVal(height));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxWinclose:gwid in:aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    winclose(_longVal(gwid));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxWinconstraintsIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    winconstraints();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxWindepth: gwid in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(windepth(_longVal(gwid))));
#endif
%}
.
    ^ false
!

glxWingetIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    RETURN (__MKSMALLINT(winget()));
#endif
%}
.
    ^ false
!

glxWinmoveX: x y: y in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    winmove(_longVal(x), _longVal(y));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxWinpopIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    winpop();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxWinpositionX1: x1 y1: y1 x2: x2 y2: y2 in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    winposition(_longVal(x1), _longVal(y1), _longVal(x2), _longVal(y2));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxWinpushIn: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    winpush();
    RETURN (true);
#endif
%}
.
    ^ false
!

glxWinset: gwid in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    winset(_longVal(gwid));
    RETURN (true);
#endif
%}
.
    ^ false
! !

!GLXWorkstation methodsFor:'window creation'!

createGLXWindowFor:aView left:xpos top:ypos width:wwidth height:wheight type:glxType
    |ext wsuperView wsuperViewId windowId|

    glOK ifFalse:[^ nil].

    wsuperView := aView superView view.
    wsuperView notNil ifTrue:[
	wsuperViewId := wsuperView id
    ].

%{  /* CALLSSTACK: 20000 */
    Display *dpy = myDpy;
    int screen = __intVal(_INST(screen));
    Window newWindow, parentWindow;
    int t;

    if (__isSmallInteger(xpos) && __isSmallInteger(ypos)
     && __isSmallInteger(wwidth) && __isSmallInteger(wheight)) {
	if (__isExternalAddress(wsuperViewId)) {
	    parentWindow = _WindowVal(wsuperViewId);
	} else {
	    parentWindow = RootWindow(dpy, screen);
	}

	if (glxType == @symbol(colorIndexSingleBuffer))
	    t = GLXcolorIndexSingleBuffer;
	else if (glxType == @symbol(colorIndexDoubleBuffer))
	    t = GLXcolorIndexDoubleBuffer;
	else if (glxType == @symbol(rgbSingleBuffer))
	    t = GLXrgbSingleBuffer;
	else if (glxType == @symbol(rgbDoubleBuffer))
	    t = GLXrgbDoubleBuffer;
	else {
	    RETURN ( nil );
	}

	ENTERGLX;
	newWindow = __GLXCreateWindow(dpy, parentWindow,
				    __intVal(xpos), __intVal(ypos),
				    __intVal(wwidth), __intVal(wheight),
				    0, t);
	LEAVEGLX;

	if (! newWindow) {
	    RETURN ( nil );
	}

	windowId = __MKOBJ(newWindow);
    }
%}.
    windowId notNil ifTrue:[
	self addKnownView:aView withId:windowId.
    ].
    ^ windowId
!

unlinkGLXView:aGLXWindowId
    "remove X/GLX link"

%{  /* CALLSSTACK: 20000 */
    if (__isExternalAddress(aGLXWindowId)) {
	ENTERGLX;
	__GLXUnlinkWindow(myDpy, _WindowVal(aGLXWindowId));
	LEAVEGLX;
    }
%}
! !

!GLXWorkstation methodsFor:'zbuffer'!

glxZbsize: planes in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef FULL_GLX
    SETWIN(aGLXWindowId)
    zbsize(_longVal(planes));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxZbuffer:aBoolean in:aGLXWindowId
    "enable/disable z-buffer operation"

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    zbuffer(aBoolean == false ? FALSE : TRUE);
    RETURN (true);
#endif
%}
.
    ^ false
!

glxZdraw: b in: aGLXWindowId
    "enable/disable drawing into the z-buffer"

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    zdraw(_booleanVal(b));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxZfunction: func in: aGLXWindowId
    "set the z-buffer comparison function.
     func may be either the numeric value or a symbol (preferred)"

%{  /* NOCONTEXT */
#ifdef GLX
    long f;

    SETWIN(aGLXWindowId)
    if (func == @symbol(NEVER))
	f = ZF_NEVER;
    else if (func == @symbol(LESS))
	f = ZF_LESS;
    else if (func == @symbol(EQUAL))
	f = ZF_EQUAL;
    else if (func == @symbol(LEQUAL))
	f = ZF_LEQUAL;
    else if (func == @symbol(GREATER))
	f = ZF_GREATER;
    else if (func == @symbol(NOTEQUAL))
	f = ZF_NOTEQUAL;
    else if (func == @symbol(GEQUAL))
	f = ZF_GEQUAL;
    else if (func == @symbol(ALWAYS))
	f = ZF_ALWAYS;
    else
	f = _longVal(func);
    zfunction(f);
    RETURN (true);
#endif
%}
.
    ^ false
!

glxZsource: src in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    zsource(_longVal(src));
    RETURN (true);
#endif
%}
.
    ^ false
!

glxZwritemask: mask in: aGLXWindowId

%{  /* NOCONTEXT */
#ifdef GLX
    SETWIN(aGLXWindowId)
    zwritemask((ulong)__intVal(mask));
    RETURN (true);
#endif
%}
.
    ^ false
! !

!GLXWorkstation class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

