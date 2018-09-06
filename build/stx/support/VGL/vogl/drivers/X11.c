/*
 * VOGL/VOGLE driver for X11.
 * 
 * Define VOGLE if this driver is really for the VOGLE Libarary.
 *
 */
/* #define VOGLE 1 */

#include <stdio.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

#ifdef __VMS__
# include "vms_Xnames.h"
#endif

#ifndef MULTI_X
# define        CMAPSIZE        256
#endif

#define NUM_STD_COLORS	8

#ifdef VOGLE

#include "vogle.h"
static  char    *me = "vogle";
#define LARGEFONT       "-adobe-courier-medium-r-normal--24-240-75-75-m-150-iso8859-1"
#define SMALLFONT       "-adobe-courier-medium-r-normal--10-100-75-75-m-60-iso8859-1"

#else

#include "vogl.h"
static  char    *me = "vogl";
#define LARGEFONT       "9x15bold"
#define SMALLFONT       "6x13bold"

#endif

#define MIN(x,y)        ((x) < (y) ? (x) : (y))
#define MAX(x,y)        ((x) > (y) ? (x) : (y))
#define EV_MASK         KeyPressMask|ButtonReleaseMask|ExposureMask|ButtonPressMask

#ifdef MULTI_X

# define winder         vdevice.v_winder
# define display        vdevice.v_display
# define screen         vdevice.v_screen
# define visualClass	vdevice.v_visualClass
# define carray         vdevice.v_carray
# define carrayFlags    vdevice.v_carrayFlags
# define colormap       vdevice.v_colormap

# define theDrawable    vdevice.v_theDrawable
# define theGC          vdevice.v_theGC
# define bbuf           vdevice.v_bbuf
# define back_used      vdevice.v_back_used
# define font_id        vdevice.v_font_id
# define event          vdevice.v_event
# define colour         vdevice.v_colour
# define h              vdevice.v_h
# define w              vdevice.v_w
# define smallf         vdevice.v_smallf
# define largef         vdevice.v_largef

VDevice   __vdevices__[NUM_VDEVICES] = {0};

#else

static  Window          winder;
static  Display         *display;
static  int             screen;
static  int		visualClass;
static  long   		carray[CMAPSIZE];
static  char		carrayFlags[CMAPSIZE];
static  Colormap        colormap;

static  Drawable        theDrawable;
static  GC              theGC;
static  Pixmap          bbuf;           /* Back buffer pixmap */
static  int             back_used = 0;  /* Have we backbuffered ? */

static  XFontStruct     *font_id = (XFontStruct *)NULL;
XEvent                  event;

static  unsigned long   colour;
static  unsigned int    h, w;
static  char            *smallf, *largef;
#endif

void X11_color(int);

#ifndef SKIP_STATIC_FOREWARD_DECL
static int __X11_mapcolor(int i, int r, int g, int b, int forceShared);
#endif

#ifndef MULTI_X
/*
 * X11_init
 *
 *      initialises X11 display.
 */
X11_init()
{
	int             i;
	int             x, y, prefx, prefy, prefxs, prefys;
	unsigned int    bw, depth, mask;
	Window          rootw, childw;
	char            *av[2], name[128], *geom;
	Display         *dpy;

	XSetWindowAttributes    theWindowAttributes;
	XWindowAttributes       retWindowAttributes;
	XSizeHints              theSizeHints;
	unsigned long           theWindowMask;
	XWMHints                theWMHints;
	Visual *visual;

	av[0] = me;
	av[1] = (char *)NULL;

	if ((display = XOpenDisplay((char *)NULL)) == (Display *)NULL) {
		fprintf(stderr,"VGL: %s: X11_init: can't connect to X server\n", me);
		exit(1);
	}
	dpy = display;

	winder = DefaultRootWindow(dpy);
	screen = DefaultScreen(dpy);
	colormap = DefaultColormap(dpy, screen);
	depth = vdevice.depth = DefaultDepth(dpy, screen);
	visual = DefaultVisualOfScreen(DefaultScreenOfDisplay(dpy));
	vdevice.visualClass = visual->class;

        for (i = 0; i < CMAPSIZE; i++) {
                carray[i] = -1;
                carrayFlags[i] = 0;
        }

	/*
	 * Set our standard colors...
	 */
	if (vdevice.depth == 1) {
		/*
		 * Black and white - anything that's not black is white.
		 */
		carray[0] = BlackPixel(dpy, screen);
		carrayFlags[0] = 0;
		for (i = 1; i < CMAPSIZE; i++) {
			carray[i] = WhitePixel(dpy, screen);
			carrayFlags[i] = 0;
		}
	} else {
		/*
		 * Color, try to get our colors close to what's in the
		 * default colormap.
		 */
		__X11_mapcolor(0, 0, 0, 0, 1);
		__X11_mapcolor(1, 255, 0, 0, 1);
		__X11_mapcolor(2, 0, 255, 0, 1);
		__X11_mapcolor(3, 255, 255, 0, 1);
		__X11_mapcolor(4, 0, 0, 255, 1);
		__X11_mapcolor(5, 255, 0, 255, 1);
		__X11_mapcolor(6, 0, 255, 255, 1);
		__X11_mapcolor(7, 255, 255, 255, 1);
	}

	getprefposandsize(&prefx, &prefy, &prefxs, &prefys);

	/*
	 * NEED TO USE XGRABPOINTER here???
	 */
	XQueryPointer(dpy, winder, &rootw, &childw, &x, &y, &x, &y, &mask);

	if (childw == None)
		childw = rootw;

/*
	if (!XGetWindowAttributes(dpy, childw, &retWindowAttributes)) {
		fprintf(stderr,"Can't get window attributes.");
		exit(1);
	}

	x = retWindowAttributes.x;
	y = retWindowAttributes.y;
	w = retWindowAttributes.width;
	h = retWindowAttributes.height;
	bw = retWindowAttributes.border_width;
	depth = vdevice.depth = retWindowAttributes.depth;

	XTranslateCoordinates(dpy,
			childw, retWindowAttributes.root,
			0, 0,
			&x, &y,
			&rootw
	);
*/

	XGetGeometry(dpy, childw, &rootw, &x, &y, &w, &h, &bw, &depth);

	vdevice.depth = depth;

	theWindowAttributes.backing_store = WhenMapped;
	theWindowAttributes.save_under = True;
	theWindowAttributes.border_pixel = carray[1];


	/*
	 * See if there is something in the .Xdefaults file regarding
	 * VOGL/VOGLE.
	 */

	if ((smallf = XGetDefault(dpy, me, "smallfont")) == (char *)NULL)
		smallf = SMALLFONT;

	if ((largef = XGetDefault(dpy, me, "largefont")) == (char *)NULL)
		largef = LARGEFONT;

	geom = XGetDefault(dpy, me, "Geometry");

	if (geom != (char *)NULL) {
		mask = XParseGeometry(geom, &x, &y, &w, &h);

		if (mask & XValue)
			theSizeHints.flags |= USPosition;

		if (mask & YValue)
			theSizeHints.flags |= USPosition;

		if (mask & WidthValue)
			theSizeHints.flags |= USSize;

		if (mask & HeightValue)
			theSizeHints.flags |= USSize;

		if (mask & XNegative)
			 x = DisplayWidth(dpy, screen) - 2*bw - w + x;

		if (mask & YNegative)
			y = DisplayHeight(dpy, screen) - 2*bw - h + y;

	} else
		theSizeHints.flags = PPosition | PSize;

	if (prefx > -1) {
		x = prefx;
		y = prefy;
	}

	if (prefxs > -1) {
		w = prefxs;
		h = prefys;
	}

	if (bw == 0)
		bw = 4;

	x -= bw;
	y -= bw;

	if (x <= 0)
		x = 0;

	if (y <= 0)
		y = 0;

	w -= 4 * bw;
	h -= 4 * bw;

	theWindowMask = CWBorderPixel|CWBackingStore;

	winder = XCreateWindow(dpy,
				winder,
				x, y,
				w, h,
				bw,
				(int)depth,
				InputOutput,
				CopyFromParent,
				theWindowMask,
				&theWindowAttributes
			);

 
	theSizeHints.x = x;
	theSizeHints.y = y;
	theSizeHints.width = w;
	theSizeHints.height = h;

#ifndef VOGLE
	if (vdevice.wintitle)
		strcpy(name, vdevice.wintitle);
	else
		sprintf(name, "%s %d (win id 0x%x)", me, getpid(), winder);
#else
	sprintf(name, "%s %d (win id 0x%x)", me, getpid(), winder);
#endif

	XSetStandardProperties(dpy,
		winder,
		name,
		name,
		None,
		av,
		1,
		&theSizeHints
	);

	theWMHints.initial_state = NormalState;
	theWMHints.input = True;
	theWMHints.flags = StateHint | InputHint;
	XSetWMHints(dpy, winder, &theWMHints);

	XSelectInput(dpy, winder, EV_MASK);

	theDrawable = (Drawable)winder;

	/*
	 * Create Graphics Context and Drawable
	 */
	theGC = XDefaultGC(dpy, screen);
	theDrawable = (Drawable)winder;
	X11_color(0);

	XMapRaised(dpy, winder);
	XFlush(dpy);

	/*
	 * Wait for Exposure event.
	 */
	do {
		XNextEvent(dpy, &event);
	} while (event.type != Expose && event.type != MapNotify);

	/*
	 * Set the input Focus to us.

	if (prefx == -1 && prefxs == -1)
		XSetInputFocus(dpy, winder, RevertToParent, CurrentTime);
	 */

	/*
	 *  Let VOGL/VOGLE know about the window size.
	 *  (We may have been resized..... )
	 */
	if (!XGetWindowAttributes(dpy, winder, &retWindowAttributes)) {
		fprintf(stderr,"VGL: Can't get window attributes.");
		exit(1);
	}

	x = retWindowAttributes.x;
	y = retWindowAttributes.y;
	w = retWindowAttributes.width;
	h = retWindowAttributes.height;

	XTranslateCoordinates(dpy,
			winder, retWindowAttributes.root,
			0, 0,
			&x, &y,
			&rootw
	);

#ifdef ORIGINAL
	vdevice.sizeX = vdevice.sizeY = MIN(h, w);
	vdevice.sizeSx = w;
	vdevice.sizeSy = h;
#else
	vdevice.sizeX = vdevice.sizeY = MIN(h, w) - 1;
	vdevice.sizeSx = w - 1;
	vdevice.sizeSy = h - 1;
#endif

	if (back_used) {
		back_used = 0;
		X11_backbuf();
	}

	return(1);
}

/*
 * X11_exit
 *
 *      cleans up before returning the window to normal.
 */
X11_exit()
{
	Display *dpy = display;

	if (!dpy) return;

	if (back_used) { 
		XFreePixmap(dpy, bbuf);
		bbuf = 0;
		back_used = 0;
	}

	XDestroyWindow(dpy, winder);

	XSync(dpy, 0);

	XCloseDisplay(dpy);

	return(1);
}
#else /* MULTI_X */

static int calledTheFirstTime = 1;

typedef enum {
    GLXcolorIndexSingleBuffer,
    GLXcolorIndexDoubleBuffer,
    GLXrgbSingleBuffer,
    GLXrgbDoubleBuffer
} GLXWindowType;

Window 
GLXlink(dpy, gWin)
    Display *dpy;
    Window gWin;
{
	int             i;
	int             x, y, prefx, prefy, prefxs, prefys;
	unsigned int    bw, depth, mask;
	Window          rootw, childw;
	Visual 		*vis;
	char            *av[2], name[128], *geom;
	VDevice         *prevDevice;

	XSetWindowAttributes    theWindowAttributes;
	XWindowAttributes       retWindowAttributes;
	XSizeHints              theSizeHints;
	unsigned long           theWindowMask;
	XWMHints                theWMHints;

	if (calledTheFirstTime) {
	    calledTheFirstTime = 0;

	    for (i=0; i<NUM_VDEVICES; i++) {
		__vdevices__[i].v_display = (Display *)0;
	    }
	}

	/* get a new vdevice */

	for (i=0; i<NUM_VDEVICES; i++) {
	    if (__vdevices__[i].v_display == (Display *)0)
		break;
	}
	if (i == NUM_VDEVICES) {
	    fprintf(stderr, "VGL: no more than %d gl windows are supported\n", NUM_VDEVICES);
	    return 0;
	}
	prevDevice = __current_vdevice__;
	__current_vdevice__ = &(__vdevices__[i]);
/*
	fprintf(stderr, "entered %x/%x as:%d\n", dpy, gWin, i);
*/

	display = dpy;

	winder = gWin;
	screen = DefaultScreen(dpy);
	colormap = DefaultColormap(dpy, screen);
	depth = vdevice.depth = DefaultDepth(dpy, screen);
	vis = DefaultVisualOfScreen(DefaultScreenOfDisplay(dpy));
	vdevice.v_visualClass = vis->class;
	back_used = 0;

        for (i = 0; i < CMAPSIZE; i++) {
                carray[i] = -1;
                carrayFlags[i] = 0;
        }

	/*
	 * Set our standard colors...
	 */
	if (vdevice.depth == 1) {
		/*
		 * Black and white - anything that's not black is white.
		 */
		carray[0] = BlackPixel(dpy, screen);
		carrayFlags[i] = 0;
		for (i = 1; i < CMAPSIZE; i++) {
			carray[i] = WhitePixel(dpy, screen);
			carrayFlags[i] = 0;
		}
	} else {
		/*
		 * Color, try to get our colors close to what's in the
		 * default colormap.
		 */
		__X11_mapcolor(0, 0, 0, 0, 1);
		__X11_mapcolor(1, 255, 0, 0, 1);
		__X11_mapcolor(2, 0, 255, 0, 1);
		__X11_mapcolor(3, 255, 255, 0, 1);
		__X11_mapcolor(4, 0, 0, 255, 1);
		__X11_mapcolor(5, 255, 0, 255, 1);
		__X11_mapcolor(6, 0, 255, 255, 1);
		__X11_mapcolor(7, 255, 255, 255, 1);
	}

	/*
	 * NEED TO USE XGRABPOINTER here???
	 */
	XQueryPointer(dpy, winder, &rootw, &childw, &x, &y, &x, &y, &mask);

	if (childw == None)
		childw = rootw;

	XGetGeometry(dpy, childw, &rootw, &x, &y, &w, &h, &bw, &depth);

	vdevice.depth = depth;

	theWindowAttributes.backing_store = WhenMapped;
	theWindowAttributes.save_under = True;
	theWindowAttributes.border_pixel = carray[1];


	/*
	 * See if there is something in the .Xdefaults file regarding
	 * VOGL/VOGLE.
	 */

	if ((smallf = XGetDefault(dpy, me, "smallfont")) == (char *)NULL)
		smallf = SMALLFONT;

	if ((largef = XGetDefault(dpy, me, "largefont")) == (char *)NULL)
		largef = LARGEFONT;

	theDrawable = (Drawable)winder;

	/*
	 * Create Graphics Context and Drawable
	 */
	theGC = XDefaultGC(dpy, screen);
	theDrawable = (Drawable)winder;
	X11_color(0);

	/*
	 *  Let VOGL/VOGLE know about the window size.
	 *  (We may have been resized..... )
	 */
	if (!XGetWindowAttributes(dpy, winder, &retWindowAttributes)) {
	    __current_vdevice__ = prevDevice;
	    return 0;
	}

	x = retWindowAttributes.x;
	y = retWindowAttributes.y;
	w = retWindowAttributes.width;
	h = retWindowAttributes.height;

	XTranslateCoordinates(dpy,
			winder, retWindowAttributes.root,
			0, 0,
			&x, &y,
			&rootw
	);

#ifdef ORIGINAL
	vdevice.sizeX = vdevice.sizeY = MIN(h, w);
	vdevice.sizeSx = w;
	vdevice.sizeSy = h;
#else
	vdevice.sizeX = vdevice.sizeY = MIN(h, w) - 1;
	vdevice.sizeSx = w - 1;
	vdevice.sizeSy = h - 1;
#endif

	if (back_used) {
		back_used = 0;
		X11_backbuf();
	}

	vinit();
	ginit();

/*
	__current_vdevice__ = prevDevice;
*/

	return(1);
}

GLXwinset(dpy, win)
    Display *dpy;
    Window win;
{
	int i;

	for (i=0; i<NUM_VDEVICES; i++) {
/*
	    fprintf(stderr, "check %x/%x as:%d\n", __vdevices__[i].v_display, 
					  __vdevices__[i].v_winder, i);
*/
	    if ((__vdevices__[i].v_display == dpy) 
	     && (__vdevices__[i].v_winder == win)) {
		__current_vdevice__ = &(__vdevices__[i]);
		return 1;
	    }
	}
	return -1;
}

GLXunlink(dpy, win)
    Display *dpy;
    Window win;
{
	int i;
	VDevice         *prevDevice;

	prevDevice = __current_vdevice__;
	for (i=0; i<NUM_VDEVICES; i++) {
/*
	    fprintf(stderr, "check %x/%x as:%d\n", __vdevices__[i].v_display, 
					  __vdevices__[i].v_winder, i);
*/
	    if ((__vdevices__[i].v_display == dpy) 
	     && (__vdevices__[i].v_winder == win)) {
		__current_vdevice__ = &(__vdevices__[i]);
		vdeinit();
		__vdevices__[i].v_display = 0;
		__vdevices__[i].v_winder = 0;
	    }
	}
	__current_vdevice__ = prevDevice;
}

X11_exit() {}
X11_init() { return 1;}

#endif

/*
 * X11_draw
 *
 *      draws a line from the current graphics position to (x, y).
 *
 * Note: (0, 0) is defined as the top left of the window in X (easy
 * to forget).
 */
void
X11_draw(x, y)
	int     x, y;
{
	Display *dpy = display;
#ifndef ORIGINAL
	if (!dpy) return;
#endif
	XDrawLine(dpy,
		theDrawable,
		theGC,
		vdevice.cpVx, vdevice.sizeSy - vdevice.cpVy,
		x, vdevice.sizeSy - y
	);

	if (vdevice.sync)
		XSync(dpy, 0);
}

void
X11_pnt(x, y)
	int     x, y;
{
	Display *dpy = display;
#ifndef ORIGINAL
	if (!dpy) return;
#endif
	XDrawPoint(dpy,
		theDrawable,
		theGC,
		x, vdevice.sizeSy - y
	);

	if (vdevice.sync)
		XSync(dpy, 0);
}

/*
 * X11_getkey
 *
 *      grab a character from the keyboard - blocks until one is there.
 */
int
X11_getkey()
{
	char    c;

	do {
		XNextEvent(display, &event);
		if (event.type == KeyPress) {
			if (XLookupString((XKeyEvent *)&event, &c, 1, NULL, NULL) > 0)
				return((int)c);
			else
				return(0);
		}
	} while (event.type != KeyPress);
}

/*
 * X11_checkkey
 *
 *      Check if there has been a keyboard key pressed.
 *      and return it if there is.
 */
int
X11_checkkey()
{
	char    c;

	if (!XCheckWindowEvent(display, winder, KeyPressMask, &event))
		return(0);

	if (event.type == KeyPress)
		if (XLookupString((XKeyEvent *)&event, &c, 1, NULL, NULL) > 0)
			return((int)c);

	return(0);
}

/*
 * X11_locator
 *
 *      return the window location of the cursor, plus which mouse button,
 * if any, is been pressed.
 */
int
X11_locator(wx, wy)
	int     *wx, *wy;
{
	Window  rootw, childw;
	int     x, y, mask;

	XQueryPointer(display, winder, &rootw, &childw, &x, &y, wx, wy, &mask);

	*wy = (int)vdevice.sizeSy - *wy;

	return(mask >> 8);
}

#ifdef VOGLE
/*
 * X11_clear
 *
 * Clear the screen (or current buffer )to current colour
 */
void
X11_clear()
{
	Display *dpy = display;

#ifndef ORIGINAL
	if (!dpy) return;
#endif
	XSetBackground(dpy, theGC, colour);
	XFillRectangle(dpy,
		theDrawable,
		theGC,
		0,
		0,
		(unsigned int)vdevice.sizeSx + 1,
		(unsigned int)vdevice.sizeSy + 1
	);

	if (vdevice.sync)
		XFlush(dpy);
}

#else 

/*
 * X11_clear
 *
 * Clear the screen (or current buffer )to current colour
 */
void
X11_clear()
{
#ifdef ORIGINAL
	unsigned int    ww = vdevice.maxVx - vdevice.minVx;
	unsigned int    hh = vdevice.maxVy - vdevice.minVy;
#else
	unsigned int    ww = vdevice.maxVx - vdevice.minVx + 1;
	unsigned int    hh = vdevice.maxVy - vdevice.minVy + 1;
#endif

	Display *dpy = display;

#ifndef ORIGINAL
	if (!dpy) return;
#endif
	XSetBackground(dpy, theGC, colour);

	XFillRectangle(dpy,
		theDrawable,
		theGC,
		vdevice.minVx,
		vdevice.sizeSy - vdevice.maxVy, 
		ww, 
		hh
	);

	if (vdevice.sync)
		XFlush(dpy);
}
#endif

/*
 * X11_color
 *
 *      set the current drawing color index.
 */
void
X11_color(ind)
	int     ind;
{
	Display *dpy = display;

#ifndef ORIGINAL
	if (!dpy) return;
	if ((ind < 0) || (ind > CMAPSIZE)) {
	    vwarning("bad color index in color\n");
	    return;
	}
#endif
	colour = carray[ind];
	XSetForeground(dpy, theGC, colour);
}

#ifndef ORIGINAL

/*
 * retrieve a single pixel at x/y
 * somewhat stripped down ;-) version
 * of rectread ...
 */
int
X11_getPixel(x, y)
	int x, y;
{
	Display *dpy = display;
	XImage *img;
	int pix;
	int i;

	if (!dpy) return -1;

	img = XGetImage(dpy, theDrawable, x, y, 1, 1, (unsigned)~0, ZPixmap);
	pix = XGetPixel(img, 0, 0);
	XDestroyImage(img);

	for (i=0; i<CMAPSIZE; i++) {
	    if (carray[i] == pix) return i;
	}
	/*
	 * oops - not in my colorMap
	 */
	return -1;
}

/*
 * given an X-color, return the corresponding GLX color
 */
int
X11_invColor(ind)
	int ind;
{
	int i;

	for (i=0; i<CMAPSIZE; i++) {
	    if (carray[i] == ind) return i;
	}
	return -1;
}

#endif

/*
 * X11_mapcolor
 *
 *      change index i in the color map to the appropriate r, g, b, value.
 */

static int
__X11_mapcolor(int i, int r, int g, int b, int forceShared)
{
	int     stat;
	XColor  tmp;
	unsigned long dummy;
	unsigned long pixel;
	int allocateShared = 1;

	Display *dpy = display;

#ifndef ORIGINAL
	if (!dpy) return -1;
#endif
	if (i >= CMAPSIZE) {
		vwarning("bad colorindex given to mapcolor\n");
		return(-1);
	}


	/*
	 * For Black and White.
	 * If the index is 0 and r,g,b != 0 then we are remapping black.
	 * If the index != 0 and r,g,b == 0 then we make it black.
	 */
	if (vdevice.depth == 1) {
		if (i == 0 && (r != 0 || g != 0 || b != 0)) {
			carray[i] = WhitePixel(dpy, screen);
		} else if (i != 0 && r == 0 && g == 0 && b == 0) {
			carray[i] = BlackPixel(dpy, screen);
		}
		carrayFlags[i] = 0;
	} else {
		tmp.red = (unsigned short)(r / 255.0 * 65535);
		tmp.green = (unsigned short)(g / 255.0 * 65535);
		tmp.blue = (unsigned short)(b / 255.0 * 65535);


		if (! forceShared) { 
		    /*
		     * for stanard colors, always allocate shared
		     */
		    if ((tmp.red == 0xFFFF) 
		     && (tmp.green == 0xFFFF)
		     && (tmp.blue == 0xFFFF)) {
			forceShared = 1;
		    } else {
			if ((tmp.red == 0)
		         && (tmp.green == 0)
		         && (tmp.blue == 0)) {
			    forceShared = 1;
			} else {
			    if ((tmp.red == 0xFFFF)
		             && (tmp.green == 0)
		             && (tmp.blue == 0)) {
			        forceShared = 1;
			    } else {
			        if ((tmp.red == 0)
		                 && (tmp.green == 0xFFFF)
		                 && (tmp.blue == 0)) {
			            forceShared = 1;
			        } else {
			            if ((tmp.red == 0)
		                     && (tmp.green == 0)
		                     && (tmp.blue == 0xFFFF)) {
			                forceShared = 1;
			            }
			        }
			    }
			}
		    }
		}
		
/*
fprintf(stderr, "VGL: vdev=%x r=%04x g=%04x b=%04x\n", 
			&vdevice, tmp.red, tmp.green, tmp.blue);
*/
		switch (visualClass) {
		    case StaticGray:
		    case StaticColor:
		    case TrueColor:
		    case DirectColor:
		    default:
			/* allocate a shared color */
			allocateShared = 1;
			break;

		    case PseudoColor:
		    case GrayScale:
			/* only use shared colors for the standard
			 * colors; others are unshared
			 * standard colors are white, black,
			 * red, green, blue, cyan, magenta
			 */
			allocateShared = forceShared;
			break;
		}

		if (allocateShared) {
		    tmp.flags = 0;
		    tmp.pixel = (unsigned long)i;
		    stat = XAllocColor(dpy, colormap, &tmp);
		    if (stat) {
/*
fprintf(stderr, "VGL: clr=%d pixel=%x\n", i, tmp.pixel);
*/
			if (carrayFlags[i]) {
			    /* there was a cell - free it */
			    XFreeColors(dpy, colormap, &pixel, 1, 0);
			}
			carray[i] = tmp.pixel;
			carrayFlags[i] = 0;
		    }
		} else {
		    if (carrayFlags[i] == 0) {
			stat = XAllocColorCells(dpy, colormap, 0, &dummy, 0, &pixel, 1);
		    } else {
			/* already allocated */
			stat = 1;
			pixel = carray[i];
		    }
		    if (stat) {
			tmp.pixel = pixel;
                        tmp.flags = DoRed | DoGreen | DoBlue;
			XStoreColor(dpy, colormap, &tmp);
/*
fprintf(stderr, "VGL: clr=%d pixel=%x\n", i, pixel);
*/
			carray[i] = pixel;
			carrayFlags[i] = 1;
		    }
		}

		if (stat == 0) {
			fprintf(stderr, "VGL: XAllocColor failed (status = %d)\n", stat);
#ifdef MULTI_X
			return -1;
#else
			exit(1);
#endif
		}
	}

	XFlush(dpy);
	return(0);
}
        
X11_mapcolor(i, r, g, b)
	int     i;
	int     r, g, b;
{
        return __X11_mapcolor(i, r, g, b, 0);
}

/*
 * X11_font
 *
 *   Set up a hardware font. Return 1 on success 0 otherwise.
 *
 */
int
X11_font(fontfile)
	char    *fontfile;
{
	XGCValues       xgcvals;

	Display *dpy = display;

#ifndef ORIGINAL
	if (!dpy) return -1;
#endif
	if (font_id != (XFontStruct *)NULL)
		XFreeFont(dpy, font_id);

	if (strcmp(fontfile, "small") == 0) {
		if ((font_id = XLoadQueryFont(dpy, smallf)) == (XFontStruct *)NULL) {
			fprintf(stderr, "VGL: %s X11.c couldn't open small font '%s'\n", me, smallf);
			fprintf(stderr, "VGL: You'll have to redefine it....\n");
			return(0);
		} else
			fontfile = smallf;
                
	} else if (strcmp(fontfile, "large") == 0) {
		if ((font_id = XLoadQueryFont(dpy, largef)) == (XFontStruct *)NULL) {
			fprintf(stderr, "VGL: %s X11.c couldn't open large font '%s'\n", me, largef);
			fprintf(stderr, "VGL: You'll have to redefine it....\n");
			return(0);
		}
			fontfile = largef;
	} else {
		if ((font_id = XLoadQueryFont(dpy, fontfile)) == (XFontStruct *)NULL) {
			fprintf(stderr, "VGL: %s X11.c couldn't open fontfile '%s'\n", me, fontfile);
			return(0);
		}
	}

	vdevice.hheight = font_id->max_bounds.ascent + font_id->max_bounds.descent;
	vdevice.hwidth = font_id->max_bounds.width;

	xgcvals.font = XLoadFont(dpy, fontfile);
	XChangeGC(dpy, theGC, GCFont, &xgcvals);

	return(1);
}

/* 
 * X11_char
 *
 *       outputs one char - is more complicated for other devices
 */
void
X11_char(c)
	char    c;
{
	char    *s = " ";

	Display *dpy = display;

#ifndef ORIGINAL
	if (!dpy) return;
#endif
	s[0] = c;
	XDrawString(dpy, theDrawable, theGC, vdevice.cpVx, (int)(vdevice.sizeSy - vdevice.cpVy), s, 1);

	if (vdevice.sync)
		XFlush(dpy);
}

/*
 * X11_string
 *
 *      Display a string at the current drawing position.
 */
void
X11_string(s)
	char    s[];
{
	Display *dpy = display;

#ifndef ORIGINAL
	if (!dpy) return;
#endif
	XDrawString(dpy, theDrawable, theGC, vdevice.cpVx, (int)(vdevice.sizeSy - vdevice.cpVy), s, strlen(s));
	if (vdevice.sync)
		XFlush(dpy);
}

/*
 * X11_fill
 *
 *      fill a polygon
 */
void
X11_fill(n, x, y)
	int     n, x[], y[];
{
	char    buf[BUFSIZ];
	XPoint  plist[128];
	int     i;

	Display *dpy = display;

#ifndef ORIGINAL
	if (!dpy) return;
#endif
	if (n > 128) {
		sprintf(buf, "%s: more than 128 points in a polygon", me);
		verror(buf);
		return;
	}

	for (i = 0; i < n; i++) {
		plist[i].x = x[i];
		plist[i].y = vdevice.sizeSy - y[i];
	}

	XFillPolygon(dpy, theDrawable, theGC, plist, n, Nonconvex, CoordModeOrigin);

	vdevice.cpVx = x[n-1];
	vdevice.cpVy = y[n-1];

	if (vdevice.sync)
		XFlush(dpy);
}

/*
 * X11_backbuf
 *
 *      Set up double buffering by allocating the back buffer and
 *      setting drawing into it.
 */
int
X11_backbuf()
{
	Display *dpy = display;

#ifndef ORIGINAL
	if (!dpy) return -1;
#endif
	if (!back_used) {
		if (bbuf) {
		    /* should not happen */
		    XFreePixmap(dpy, bbuf);
		}

		bbuf = XCreatePixmap(dpy,
			(Drawable)winder,
			(unsigned int)vdevice.sizeSx + 1,
			(unsigned int)vdevice.sizeSy + 1,
			(unsigned int)vdevice.depth
		);
		/*
		 * claus: clear backbuffer
		 */
		XSetForeground(dpy, theGC, carray[0]);
		XFillRectangle(dpy,
			bbuf,
			theGC,
			0, 0, 
			(unsigned int)vdevice.sizeSx + 1, 
			(unsigned int)vdevice.sizeSy + 1
		);

		XSetForeground(dpy, theGC, colour);
	}

	theDrawable = (Drawable)bbuf;

	back_used = 1;

	return(1);
}

/*
 * X11_swapbuf
 *
 *      Swap the back and from buffers. (Really, just copy the
 *      back buffer to the screen).
 */
X11_swapbuf()
{
	Display *dpy = display;

#ifndef ORIGINAL
	if (!dpy) return -1;
	XSetGraphicsExposures(dpy, theGC, 0);
#endif
	XCopyArea(dpy,
		theDrawable,
		winder,
		theGC,
		0, 0,
		(unsigned int)vdevice.sizeSx + 1,
		(unsigned int)vdevice.sizeSy + 1,
		0, 0
	);

#ifndef ORIGINAL
	XSetGraphicsExposures(dpy, theGC, 1);
#endif
	XSync(dpy, 0);  /* Not XFlush */
	return 1;
}

/*
 * X11_frontbuf
 *
 *      Make sure we draw to the screen.
 */
void
X11_frontbuf()
{
	theDrawable = (Drawable)winder;
}

/*
 * Syncronise the display with what we think has been sent to it...
 */
void
X11_sync()
{
#ifndef ORIGINAL
	if (!display) return;
#endif
	XSync(display, 0);
}

#ifndef ORIGINAL
/*
 * notification of a resize
 */
void
X11_resized(newWidth, newHeight) {
    Display *dpy = display;
    int oldWidth = vdevice.sizeSx;
    int oldHeight = vdevice.sizeSy;
    int usingBackBuffer = 0;

    if (!dpy) return;

    vdevice.sizeSx = newWidth;
    vdevice.sizeSy = newHeight;

    /*
     * if there is a backBuffer, check if it must be recreated
     */
    if ((newWidth > oldWidth)
     || (newHeight > oldHeight)) {
        
	if (back_used) {
	    usingBackBuffer = (theDrawable == (Drawable)bbuf);

	    if (bbuf) {
		XFreePixmap(dpy, bbuf);
	    }
	    bbuf = XCreatePixmap(dpy,
		    (Drawable)winder,
		    (unsigned int)vdevice.sizeSx + 1,
		    (unsigned int)vdevice.sizeSy + 1,
		    (unsigned int)vdevice.depth);
	    /*
	     * claus: clear backbuffer
	     */
	    XSetForeground(dpy, theGC, carray[0]);
	    XFillRectangle(dpy,
		    bbuf,
		    theGC,
		    0, 0, 
		    (unsigned int)vdevice.sizeSx + 1, 
		    (unsigned int)vdevice.sizeSy + 1);

	    XSetForeground(dpy, theGC, colour);

	    if (usingBackBuffer) {
		 theDrawable = (Drawable)bbuf;
	    }
	}
    }
    if (winder) {
	XResizeWindow(dpy, winder, newWidth, newHeight);
    }
}

#endif

/*
 * X11_setlw
 *
 *      Set the line width.
 */
X11_setlw(lw)
	int     lw;
{
	XGCValues vals;

	vals.line_width = lw;
	XChangeGC(display, theGC, GCLineWidth, &vals);
}

/*
 * X11_setls
 *
 *      Set the line style.
 */
void
X11_setls(lss)
	int     lss;
{
	unsigned ls = lss;
	char    dashes[16];
	int     i, n, a, b, offset;

	if (ls == 0xffff) {
		XSetLineAttributes(display, theGC, vdevice.attr->a.lw, LineSolid, CapButt, JoinMiter);
		return;
	}

	for (i = 0; i < 16; i++)
		dashes[i] = 0;

	for (i = 0; i < 16; i++)        /* Over 16 bits */
		if ((ls & (1 << i)))
			break;

	offset = i;

#define ON      1
#define OFF     0
                
	a = b = OFF;
	if (ls & (1 << 0))
		a = b = ON;

	n = 0;
	for (i = 0; i < 16; i++) {      /* Over 16 bits */
		if (ls & (1 << i))
			a = ON;
		else
			a = OFF;

		if (a != b) {
			b = a;
			n++;
		}
		dashes[n]++;
	}
	n++;

	XSetLineAttributes(display, theGC, vdevice.attr->a.lw, LineOnOffDash, CapButt, JoinMiter);
	XSetDashes(display, theGC, offset, dashes, n);
}

/*
 * the device entry
 */
static DevEntry X11dev = {
	"X11",
	"large",
	"small",
	X11_backbuf,
	X11_char,
	X11_checkkey,
	X11_clear,
	X11_color,
	X11_draw,
	X11_exit,
	X11_fill,
	X11_font,
	X11_frontbuf,
	X11_getkey,
	X11_init,
	X11_locator,
	X11_mapcolor,
#ifndef ORIGINAL
	X11_setls,
	X11_setlw,
#endif
	X11_string,
	X11_swapbuf,
	X11_sync
};

/*
 * _X11_devcpy
 *
 *      copy the X11 device into vdevice.dev.
 */
_X11_devcpy()
{
	vdevice.dev = X11dev;
}
