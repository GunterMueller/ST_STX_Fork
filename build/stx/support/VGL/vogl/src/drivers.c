#include <stdio.h>
#include "vogl.h"
#include "vodevice.h"

extern char     *getenv();

#ifdef MULTI_X
VDevice   *__current_vdevice__ = __vdevices__;
#else
struct vdev     vdevice;
#endif

/*
 * stdout is not a constant ...
 */
static FILE     *fp = NULL;

static int      allocated = 0;

void            gexit();

/* device-independent function routines */

/*
 * voutput
 *
 *      redirect output - only for postscript, hpgl (this is not a feature)
 */
void
voutput(path)
	char    *path;
{
	char    buf[128];

	if ((fp = fopen(path, "w")) == (FILE *)NULL) {
		sprintf(buf, "voutput: couldn't open %s", path);
		verror(buf);
	}
}

/*
 * _voutfile
 *
 *      return a pointer to the current output file - designed for internal
 * use only.
 */
FILE *
_voutfile()
{
	if (fp == NULL) {
	    fp = stdout;
	}
	return(fp);
}

/*
 * verror
 *
 *      print an error on the graphics device, and then exit. Only called
 * for fatal errors. We assume that stderr is always there.
 *
 */
void
verror(str)
	char    *str;
{
#ifndef MULTI_X
	if (vdevice.initialised) {
		gexit();
	}
#endif

	if (vdevice.errorFlag) return;

#ifdef MULTI_X
	fprintf(stderr, "VGL: current device = %x\n", &vdevice);
#endif

	fprintf(stderr, "VGL: %s\n", str);
	fflush(stderr);
	vdevice.errorFlag = 1;
	vdevice.initialised = 0;
	fprintf(stderr, "VGL: ********* errorFlag set - suppress any further drawOps\n");

#ifndef MULTI_X
	exit(1);
#endif
}

void
vwarning(str, a1, a2)
	char *str;
{
	fprintf(stderr, "VGL: current device = %x\n", &vdevice);
	fprintf(stderr, "VGL: %s\n", str, a1, a2);
	fflush(stderr);
}

/*
 * gexit
 *
 *      exit the vogl/vogle system
 *
 */
void
gexit()
{
	/*
	 * kludge - error pulled down initialised, to suppress
	 * any draws. Here, it must be raised again.
	 */
	if (!vdevice.initialised) {
	    if (vdevice.errorFlag) {
		vdevice.initialised = 1;
	    }
	}

	if (!vdevice.initialised) {
		verror("gexit: vogl not initialised");
		return;
	}

#ifdef MULTI_X
	if (! (vdevice.dev.Vexit)) {
	    verror("gexit: init error");
	    return;
	}
#endif
	(*vdevice.dev.Vexit)();

	vdevice.devname = (char *)NULL;
	vdevice.initialised = 0;
	vdevice.errorFlag = 0;
	fp = stdout;
}

/*
 * getdev
 *
 *      get the appropriate device table structure
 */
static void
getdev(device)
	char    *device;
{
#ifdef MULTI_X
	_X11_devcpy();
	return;
#endif
#ifdef SUN
	if (strncmp(device, "sun", 3) == 0)
		_SUN_devcpy();
	else
#endif
#ifdef X11
	if (strncmp(device, "X11", 3) == 0)
		_X11_devcpy();
	else
#endif
#ifdef DECX11
	if (strncmp(device, "decX11", 6) == 0)
		_DECX11_devcpy();
	else
#endif
#ifdef NeXT
	if (strncmp(device, "NeXT", 4) == 0)
		_NeXT_devcpy();
	else
#endif
#ifdef POSTSCRIPT
	if (strncmp(device, "postscript", 10) == 0) {
		_PS_devcpy();
	} else
	if (strncmp(device, "ppostscript", 11) == 0) {
		_PSP_devcpy();
	} else
#endif
#ifdef HPGL
	if (strncmp(device, "hpgla1", 6) == 0)
		_HPGL_A1_devcpy();
	else if (strncmp(device, "hpgla3", 6) == 0)
		_HPGL_A3_devcpy();
	else if (strncmp(device, "hpgla4", 6) == 0)
		_HPGL_A4_devcpy();
	else if (strncmp(device, "hpgla2", 6) == 0 || strncmp(device, "hpgl", 4) == 0)
		_HPGL_A2_devcpy();
	else
#endif
#ifdef DXY
	if (strncmp(device, "dxy", 3) == 0)
		_DXY_devcpy();
	else
#endif
#ifdef TEK
	if (strncmp(device, "tek", 3) == 0)
		_TEK_devcpy();
	else
#endif
#ifdef HERCULES
	if (strncmp(device, "hercules", 8) == 0)
		_hgc_devcpy();
	else
#endif
#ifdef CGA
	if (strncmp(device, "cga", 3) == 0)
		_cga_devcpy();
	else
#endif
#ifdef EGA
	if (strncmp(device, "ega", 3) == 0)
		_ega_devcpy();
	else
#endif
#ifdef VGA
	if (strncmp(device, "vga", 3) == 0)
		_vga_devcpy();
	else
#endif
#ifdef SIGMA
	if (strncmp(device, "sigma", 5) == 0)
		_sigma_devcpy();
	else
#endif
	{
		if (*device == 0)
			fprintf(stderr, "vogl: expected the enviroment variable VDEVICE to be set to the desired device.\n");
		else
			fprintf(stderr, "vogl: %s is an invalid device type\n", device);
		fprintf(stderr, "The devices compiled into this library are:\n");
#ifdef SUN
		fprintf(stderr, "sun\n");
#endif
#ifdef X11
		fprintf(stderr, "X11\n");
#endif
#ifdef DECX11
		fprintf(stderr, "decX11\n");
#endif
#ifdef NeXT
		fprintf(stderr, "NeXT\n");
#endif
#ifdef POSTSCRIPT
		fprintf(stderr, "postscript\n");
		fprintf(stderr, "ppostscript\n");
#endif
#ifdef HPGL
		fprintf(stderr, "hpgla1\n");
		fprintf(stderr, "hpgla2 (or hpgl)\n");
		fprintf(stderr, "hpgla3\n");
		fprintf(stderr, "hpgla4\n");
#endif
#ifdef DXY
		fprintf(stderr, "dxy\n");
#endif
#ifdef TEK
		fprintf(stderr, "tek\n");
#endif
#ifdef HERCULES
		fprintf(stderr, "hercules\n");
#endif
#ifdef CGA
		fprintf(stderr, "cga\n");
#endif
#ifdef EGA
		fprintf(stderr, "ega\n");
#endif
#ifdef VGA
		fprintf(stderr, "vga\n");
#endif
#ifdef SIGMA
		fprintf(stderr, "sigma\n");
#endif
		exit(1);
	}
}

/*
 * vinit
 *
 *      Just set the device name. ginit and winopen are basically
 * the same as the VOGLE the vinit function.
 *
 */
void
vinit(device)
	char    *device;
{
	vdevice.devname = device;
}

/*
 * winopen
 *
 *      use the more modern winopen call (this really calls ginit),
 * we use the title if we can
 */
long
winopen(title)
	char    *title;
{
	vdevice.wintitle = title;

	ginit();

	return(1L);
}

/*
 * ginit
 *
 *      by default we check the environment variable, if nothing
 * is set we use the value passed to us by the vinit call.
 */
void
ginit()
{
	char    *dev;
	int     i;

#ifdef MULTI_X
	getdev("x");
#else
	if (vdevice.devname == (char *)NULL) {
		if ((dev = getenv("VDEVICE")) == (char *)NULL)
			getdev("");
		else
			getdev(dev);
	} else 
		getdev(vdevice.devname);

	if (vdevice.initialised) {
		gexit();
	}

	if (!allocated) 
#endif
	{
		allocated = 1;
#ifndef ORIGINAL
		deflinestyle(0, 0xffff);
#endif
		vdevice.transmat = (Mstack *)vallocate(sizeof(Mstack));
		vdevice.transmat->back = (Mstack *)NULL;
		vdevice.attr = (Astack *)vallocate(sizeof(Astack));
		vdevice.attr->back = (Astack *)NULL;
		vdevice.viewport = (Vstack *)vallocate(sizeof(Vstack));
		vdevice.viewport->back = (Vstack *)NULL;
		vdevice.bases = (Matrix *)vallocate(sizeof(Matrix) * 10);
		vdevice.enabled = (char *)vallocate(MAXDEVTABSIZE);
		vdevice.tokens = 0;
	}

	for (i = 0; i < MAXDEVTABSIZE; i++)
		vdevice.enabled[i] = 0;

	vdevice.alreadyread = vdevice.data = vdevice.devno = 0;
	vdevice.kbdmode = vdevice.mouseevents = vdevice.kbdevents = 0;
	vdevice.concave = 0;

	vdevice.clipoff = 0;
#ifdef MULTI_X
	vdevice.sync = 1;
	vdevice.v_asfree = NULL;
	vdevice.v_msfree = NULL;
	vdevice.v_vsfree = NULL;
	vdevice.v_nCurveSegs = 15;
	vdevice.v_current_obno = -1;
#endif
	vdevice.cpW[V_W] = 1.0;                 /* never changes */

	vdevice.maxfontnum = 2;

	vdevice.attr->a.lw = 1;
	vdevice.attr->a.fontnum = 0;
	vdevice.attr->a.mode = 0;
	vdevice.attr->a.backface = 0;

#ifdef MULTI_X
	if (! (vdevice.dev.Vinit)) {
	    verror("gexit: init error");
	    return;
	}
#endif
	if ((*vdevice.dev.Vinit)()) {
		vdevice.initialised = 1;
		vdevice.errorFlag = 0;

		vdevice.inobject = 0;
		vdevice.inpolygon = 0;

		viewport((Screencoord)0, (Screencoord)vdevice.sizeSx,
			(Screencoord)0, (Screencoord)vdevice.sizeSy);

		ortho2(0.0, (Coord)vdevice.sizeSx, 0.0, (Coord)vdevice.sizeSy);

/*
		identmatrix(vdevice.transmat->m);
		_mapmsave(vdevice.transmat->m);
*/

		move(0.0, 0.0, 0.0);

		font(0);        /* set up default font */

	} else {
		fprintf(stderr, "vogl: error while setting up device\n");
#ifdef MULTI_X
		vdevice.initialised = 0;
		vdevice.errorFlag = 0;
		return;
#else
		exit(1);
#endif
	}
	setlinestyle(0);

	vdevice.alreadyread = 0;
	vdevice.mouseevents = 0;
	vdevice.kbdevents = 0;
	vdevice.kbdmode = 0;
}

#ifdef MULTI_X
vdeinit() {
	int i;
	Mstack *m;
	Astack *a;
	Vstack *v;

	while (vdevice.transmat) {
	    m = vdevice.transmat;
	    vdevice.transmat = m->back;
	    m->back = NULL;
	    free(m);
	}
	while (vdevice.attr) {
	    a = vdevice.attr;
	    vdevice.attr = a->back;
	    a->back = NULL;
	    free(a);
	}
	while (vdevice.viewport) {
	    v = vdevice.viewport;
	    vdevice.viewport = v->back;
	    v->back = NULL;
	    free(v);
	}

	while (vdevice.v_msfree) {
	    m = vdevice.v_msfree;
	    vdevice.v_msfree = m->back;
	    m->back = NULL;
	    free(m);
	}
        while (vdevice.v_asfree) {
            a = vdevice.v_asfree;
            vdevice.v_asfree = a->back;
            a->back = NULL;
            free(a);
        }
        while (vdevice.v_vsfree) {
            v = vdevice.v_vsfree;
            vdevice.v_vsfree = v->back;
            v->back = NULL;
            free(v);
        }
	if (vdevice.bases) {
	    free(vdevice.bases);
	    vdevice.bases = 0;
	}
	if (vdevice.enabled) {
	    free(vdevice.enabled);
	    vdevice.enabled = 0;
	}

	for (i=0; i<CMAPSIZE; i++) {
	    long pixel = vdevice.v_carray[i];

	    if (vdevice.v_carrayFlags[i]) {
/*
fprintf(stderr, "freeing color/cell %d\n", pixel);
*/
		XFreeColors(vdevice.v_display, vdevice.v_colormap, &pixel, 1, 0L);
		vdevice.v_carrayFlags[i] = 0;
	    }
	}

	vdevice.initialised = 0;
	vdevice.errorFlag = 0;
}
#endif

/*
 * gconfig
 *
 *      thankfully a noop.
 */
void
gconfig()
{
}

/*
 * vnewdev
 *
 * reinitialize vogl to use a new device but don't change any
 * global attributes like the window and viewport settings.
 */
void
vnewdev(device)
	char    *device;
{
	if (!vdevice.initialised) {
		verror("vnewdev: vogl not initialised\n");
		return;
	}

	pushviewport(); 

#ifdef MULTI_X
	if (! (vdevice.dev.Vexit)) 
	    verror("gexit: init error");
#endif
	(*vdevice.dev.Vexit)();

	vdevice.initialised = 0;
	vdevice.errorFlag = 0;

	getdev(device);

#ifdef MULTI_X
	if (! (vdevice.dev.Vinit)) 
	    verror("gexit: init error");
#endif
	(*vdevice.dev.Vinit)();

	vdevice.initialised = 1;
	vdevice.errorFlag = 0;

	/*
	 * Need to update font for this device...
	 */
	font(vdevice.attr->a.fontnum);


	popviewport();
}

/*
 * vgetdev
 *
 *      Returns the name of the current vogl device 
 *      in the buffer buf. Also returns a pointer to
 *      the start of buf.
 */
char    *
vgetdev(buf)
	char    *buf;
{
	/*
	 * Note no exit if not initialized here - so that gexit
	 * can be called before printing the name.
	 */
	if (vdevice.dev.devname)
		strcpy(buf, vdevice.dev.devname);
	else
		strcpy(buf, "(no device)");

	return(&buf[0]);
}

/*
 * getvaluator
 *
 *      similar to the VOGLE locator only it returns either x (MOUSEX) or y (MOUSEY).
 */
long
getvaluator(dev)
	Device  dev;
{
	int     a, b, c;

	if (!vdevice.initialised) {
		verror("getvaluator: vogl not initialised");
		return -1;
	}

#ifdef MULTI_X
	if (! (vdevice.dev.Vlocator)) 
	    verror("gexit: init error");
#endif
	c = (*vdevice.dev.Vlocator)(&a, &b);

	if (c != -1) {
		if (dev == MOUSEX)
			return((long)a);
		else 
			return((long)b);
	}

	return(-1);
}

/*
 * getbutton
 *
 *      returns the up (or down) state of a button. 1 means down, 0 up,
 * -1 invalid.
 */
Boolean
getbutton(dev)
	Device  dev;
{
	int     a, b, c;

	if (dev < 256) {
#ifdef MULTI_X
		if (! (vdevice.dev.Vcheckkey)) 
		    verror("gexit: init error");
#endif
		c = (*vdevice.dev.Vcheckkey)();
		if (c >= 'a' && c <= 'z')
			c = c - 'a' + 'A';
		if (c == dev)
			return(1);
		return(0);
	} else if (dev < 261) {
		c = (*vdevice.dev.Vlocator)(&a, &b);
		if (c & 0x01 && dev == MOUSE3)
			return(1);
		if (c & 0x02 && dev == MOUSE2)
			return(1);
		if (c & 0x04 && dev == MOUSE1)
			return(1);
		return(0);
	}

	return(-1);
}

/*
 * clear
 *
 *      clears the screen to the current colour, excepting devices
 * like a laser printer where it flushes the page.
 *
 */
void
clear()
{
	Token   *tok;

	if (!vdevice.initialised) {
		verror("clear: vogl not initialised");
		return;
	}

	if (vdevice.inobject) {
		tok = newtokens(1);
		tok->i = CLEAR;

		return;
	}

#ifdef MULTI_X
	if (! (vdevice.dev.Vclear)) {
	    verror("gexit: init error");
	    return;
	}
#endif
	(*vdevice.dev.Vclear)();
}

/*
 * colorf
 *
 *      set the current colour to colour index given by
 * the rounded value of f.
 *
 */
void
colorf(f)
	float   f;
{
	color((int)(f + 0.5));
}

/*
 * color
 *
 *      set the current colour to colour index number i.
 *
 */
void
color(i)
	int     i;
{
	Token   *tok;

	if (!vdevice.initialised) {
		verror("color: vogl not initialised");
		return;
	}

	if (vdevice.inobject) {
		tok = newtokens(2);

		tok[0].i = COLOR;
		tok[1].i = i;
		return;
	}

	vdevice.attr->a.color = i;
#ifdef MULTI_X
	if (! (vdevice.dev.Vcolor))  {
	    verror("gexit: init error");
	    return;
	}
#endif
	(*vdevice.dev.Vcolor)(i);
}

long
getcolor()
{
	return((long)vdevice.attr->a.color);
}

/*
 * mapcolor
 *
 *      set the color of index i.
 */
void
mapcolor(i, r, g, b)
	Colorindex      i;
	short           r, g, b;
{
	Token   *tok;

	if (!vdevice.initialised) {
		verror("mapcolor: vogl not initialised");
		return;
	}

	if (vdevice.inobject) {
		tok = newtokens(5);

		tok[0].i = MAPCOLOR;
		tok[1].i = i;
		tok[2].i = r;
		tok[3].i = g;
		tok[4].i = b;

		return;
	}

#ifdef MULTI_X
	if (! (vdevice.dev.Vmapcolor)) {
	    verror("gexit: init error");
	    return;
	}
#endif
	(*vdevice.dev.Vmapcolor)(i, r, g, b);
}

/*
 * getplanes
 *
 *      Returns the number if bit planes on a device.
 */
long
getplanes()
{
	if (!vdevice.initialised) {
		verror("getdepth: vogl not initialised\n");
		return 0;
	}

	return((long)vdevice.depth);
}

#ifdef ORIGINAL
/*
 * reshapeviewport
 *              - does nothing
 */
void
reshapeviewport()
{
}
#else
/*
 * reshapeviewport
 *
 *      Simply sets the viewport to the size of the current window
 */
void
reshapeviewport()
{
	viewport((Screencoord)0, (Screencoord)vdevice.sizeSx,
		(Screencoord)0, (Screencoord)vdevice.sizeSy);
}
#endif

/*
 * winconstraints
 *              - does nothing
 */
void
winconstraints()
{
}

/*
 * keepaspect
 *              - does nothing
 */
void
keepaspect()
{
}

/*
 * shademodel
 *              - does nothing
 */
void
shademodel(model)
	long    model;
{
}

/*
 * getgdesc
 *
 *      Inquire about some stuff....
 */
long
getgdesc(inq)
	long    inq;
{       
	/*
	 * How can we know before the device is inited??
	 */

	switch (inq) {
	case GD_XPMAX:
		if (vdevice.initialised)
			return((long)vdevice.sizeSx);
		else
			return(500L);   /* A bullshit number */
	case GD_YPMAX:
		if (vdevice.initialised)
			return((long)vdevice.sizeSy);
		else
			return(500L);

#ifdef GD_BITS_NORM_ZBUFFER
	case GD_BITS_NORM_ZBUFFER:
	   	return 0; /* no z-buffer */
#endif
#ifdef GD_ZMAX
	case GD_ZMAX:
		return 0; /* no z-buffer */
#endif
#ifdef GD_TEXTURE
	case GD_TEXTURE:
		return 0; /* no textures */
#endif

	default:
		return(-1L);
	}
}

/*
 * foregound
 *              Dummy - does nothing.
 */
void
foreground()
{
}

/*
 * vsetflush
 *
 * Controls flushing of the display - we can get considerable
 * Speed up's under X11 using this...
 */
void
vsetflush(yn)
	int     yn;
{
	vdevice.sync = yn;
}

/*
 * vflush
 *
 * Explicitly call the device flushing routine...
 * This is enabled for object so that you can force an update
 * in the middle of an object, as objects have flushing off
 * while they are drawn anyway.
 */
void
vflush()
{
	Token   *tok;

	if (!vdevice.initialised) {
		verror("vflush: vogl not initialised");
		return;
	}

	if (vdevice.inobject) {
		tok = newtokens(1);
		tok->i = VFLUSH;

		return;
	}

#ifdef MULTI_X
	if (! (vdevice.dev.Vsync)) 
	    verror("gexit: init error");
#endif
	(*vdevice.dev.Vsync)();
}

#ifndef ORIGINAL
/* 
 * getorigin
 *
 *      Returns the origin of the window. This is a dummy.
 */
void
getorigin(x, y)
	long    *x, *y;
{
	*x = *y = 0;
}

/*
 * getsize
 *
 *      Returns the approximate size of the window (some window managers
 *      stuff around with your borders).
 */
void
getsize(x, y)
	long    *x, *y;
{
	*x = (long)vdevice.sizeSx + 1;
	*y = (long)vdevice.sizeSy + 1;
}
#endif
