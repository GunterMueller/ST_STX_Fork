#ifdef PC	/* Stupid pox head crap */
char	*vallocate();
char	*malloc();
#endif

#ifdef __VMS__
# include "vms_Xnames.h"
# define MULTI_X
#endif

extern char *vallocate();
extern void *malloc();

extern char *__stx_malloc();
extern __stx_free();

#ifdef DEBUG_MALLOC
# undef malloc
# define malloc(n)	__stx_malloc(n)
# undef free
# define free(ptr)	__stx_free(ptr)
#endif

#ifdef MULTI_X
# include <X11/Xlib.h>
# define        CMAPSIZE        256
#endif

/*
 * VOGL is always defined if a header file is from the 
 * VOGL library. In cases where you do use some VOGL
 * initialisation routines like vinit, just put #ifdef VOGL...
 * around.
 */
#ifndef VOGL
#define	VOGL
#endif

#ifndef TRUE
#define	TRUE	1
#endif

#ifndef FALSE
#define	FALSE	0
#endif

/*
 * Misc defines...
 */
#define	FLAT	0
#define SMOOTH	1

#define GD_XPMAX 1
#define GD_YPMAX 2
#ifndef ORIGINAL
# define GD_ZMAX		3
# define GD_BITS_NORM_ZBUFFER	4
# define GD_TEXTURE		5
#endif

/*
 * standard colour indices
 */
#define	BLACK		0
#define	RED		1
#define	GREEN		2
#define	YELLOW		3
#define	BLUE		4
#define	MAGENTA		5
#define	CYAN		6
#define	WHITE		7

/*
 * when (if ever) we need the precision
 */
#ifdef DOUBLE
#define	float	double
#endif

/*
 * How to convert degrees to radians
 */
#define	PI	3.14159265358979
#define D2R	(PI / 180.0)

/*
 * miscellaneous typedefs and type defines
 */
typedef float	Vector[4];
typedef float	Matrix[4][4];
typedef float	Tensor[4][4][4];
typedef short	Angle;
typedef float	Coord;
typedef long	Icoord;
typedef short	Scoord;
typedef long	Object;
typedef short	Screencoord;
typedef long	Boolean;
typedef unsigned short  Linestyle;

typedef unsigned short	Device;

typedef unsigned short	Colorindex;


/*
 * when register variables get us into trouble
 */
#ifdef NOREGISTER
#define	register
#endif

/*
 * max number of vertices in a ploygon
 */
#define	MAXVERTS	128

/*
 * object definitions
 */
#ifdef ORIGINAL
# define MAXENTS		101		/* size of object table */
#else
# define MAXENTS		501		/* size of object table */
#endif
#define	MAXTOKS		100		/* num. of tokens alloced at once in
					   an object  */

/*
 * Polygon fill modes for "polymode"
 */
#define PYM_POINT	0
#define PYM_LINE	0
#define PYM_FILL	1
#define PYM_HOLLOW	1

/*
 * functions which can appear in objects
 */
#define	ARC		1
#define	CALLOBJ		3
#define	CIRCLE		5
#define	CLEAR		6
#define	COLOR		7
#define	DRAW		8
#define	DRAWSTR		10
#define	FONT		12
#define	LOADMATRIX	15
#define	MAPCOLOR	16
#define	MOVE		17
#define	MULTMATRIX	18
#define	POLY		19
#define	POPATTRIBUTES	22
#define	POPMATRIX	23
#define	POPVIEWPORT	24
#define	PUSHATTRIBUTES	25
#define	PUSHMATRIX	26
#define	PUSHVIEWPORT	27
#define	RCURVE		28
#define	RPATCH		29
#define	SECTOR		30
#define	VIEWPORT	33
#define	BACKBUFFER	34
#define	FRONTBUFFER	35
#define	SWAPBUFFERS	36
#define	BACKFACING	37
#define	TRANSLATE	38
#define	ROTATE		39
#define	SCALE		40

#define	ARCF		41
#define	CIRCF		42
#define	POLYF		43
#define	RECTF		44

#define	POLYMODE	45
#define	CMOV		46
#define	LINESTYLE	47
#define	LINEWIDTH	48

#define	VFLUSH		70

/*
 * States for bgn* and end* calls
 */
#define	NONE		0	/* Just set current spot */
#define	VPNT		1	/* Draw dots		 */
#define	VLINE		2	/* Draw lines		 */
#define	VCLINE		3	/* Draw closed lines	 */
#define	VPOLY		4	/* Draw a polygon 	 */
#define VTMESH		5       /* Draw a triangular mesh*/
#define VQSTRIP		6       /* Draw a quadralateral mesh*/

/*
 * data types for object tokens
 */
typedef union tk {
	int		i;
	float		f;
} Token;

typedef struct tls {
	int		count;
	Token		*toks;
	struct tls	*next;
} TokList;

/*
 * double buffering modes.
 */
#define	SINGLE		1

/*
 * attributes
 */
typedef struct {
	char    backface,
		mode;			/* Which mode are we in */
	int     color;
	float   fontheight;
	float   fontwidth;
	int	fontnum;
	Linestyle	ls;
	short		lw;	/* Linewidth */
} Attribute;

/*
 * viewport
 */
typedef struct vp {
	float	left;
	float	right;
	float	bottom;
	float	top;
} Viewport; 

/*
 * stacks
 */
typedef	struct	ms {	/* Matrix stack entries	*/
	Matrix		m;
	struct	ms	*back;
} Mstack;

typedef	struct	as {	/* Attribute stack entries */
	Attribute	a;
	struct	as	*back;
} Astack;

typedef	struct	vs {	/* Viewport stack entries */
	Viewport	v;
	struct	vs	*back;
} Vstack;

/*
 * vogle device structures
 */
typedef struct dev {
	char	*devname;		/* name of device */
	char	*large,			/* name of large font */
		*small;			/* name of small font */
	int	(*Vbackb)(),		/* Set drawing in back buffer */
		(*Vchar)(),		/* Draw a hardware character */
		(*Vcheckkey)(),		/* Ckeck if a key was hit */
		(*Vclear)(),		/* Clear the screen to current color */
		(*Vcolor)(),		/* Set current color */
		(*Vdraw)(),		/* Draw a line */
		(*Vexit)(),		/* Exit graphics */
		(*Vfill)(),		/* Fill a polygon */
		(*Vfont)(),		/* Set hardware font */
		(*Vfrontb)(),		/* Set drawing in front buffer */
		(*Vgetkey)(),		/* Wait for and get the next key hit */
		(*Vinit)(),		/* Initialise the device */
		(*Vlocator)(),		/* Get mouse/cross hair position */
		(*Vmapcolor)(),		/* Set color indicies */
#ifndef ORIGINAL
                (*Vsetls)(),            /* Set linestyle */
                (*Vsetlw)(),            /* Set linewidth */
#endif
		(*Vstring)(),		/* Draw a hardware string */
		(*Vswapb)(),		/* Swap front and back buffers */
		(*Vsync)();		/* Sync display */
} DevEntry;

typedef struct vdev {
	char		initialised,
			errorFlag,
			clipoff,
			inobject,
			inpolygon,
			fill,			/* polygon filling */
			cpVvalid,		/* is the current device position valid */
			sync,			/* Do we syncronise the display */
			inbackbuffer,		/* are we in the backbuffer */
			clipplanes;		/* active clipping planes */
	void		(*pmove)(),		/* Polygon moves */
			(*pdraw)();		/* Polygon draws */
	TokList		*tokens;		/* ptr to list of tokens for current object */
	Mstack		*transmat;		/* top of transformation stack */
	Astack		*attr;			/* top of attribute stack */
	Vstack		*viewport;		/* top of viewport stack */
	float		hheight, hwidth;	/* hardware character height, width */
	Vector		cpW,			/* current postion in world coords */
			cpWtrans,		/* current world coords transformed */
			upvector;		/* world up */
	int		depth,			/* # bit planes on screen */
			maxVx, minVx,
			maxVy, minVy,
			sizeX, sizeY, 		/* size of square on screen */
			sizeSx, sizeSy,		/* side in x, side in y (# pixels) */
			cpVx, cpVy;
	DevEntry	dev;
	float		savex,			/* Where we started for v*() */
			savey,
			savez;
	char		bgnmode;		/* What to do with v*() calls */
	char		save;			/* Do we save 1st v*() point */

	char		*wintitle;		/* window title */

	char		*devname;		/* pointer to device name */

	Matrix		tbasis, ubasis, *bases; /* Patch stuff */
	
	char		*enabled;		/* pointer to enabled devices mask */
	int		maxfontnum;

	char		alreadyread;		/* queue device stuff */
	char		kbdmode;		/* are we in keyboard mode */
	char		mouseevents;		/* are mouse events enabled */
	char		kbdevents;		/* are kbd events enabled */
	int		devno, data;

	int		concave;		/* concave polygons? */

#ifdef MULTI_X
        Window          v_winder;
        Display         *v_display;
        int             v_screen;
	int		v_visualClass;
        long            v_carray[CMAPSIZE];
        char            v_carrayFlags[CMAPSIZE];
        Colormap        v_colormap;
        Drawable        v_theDrawable;
        GC              v_theGC;
        Pixmap          v_bbuf;
        int             v_back_used;
        XFontStruct     *v_font_id;
        XEvent          v_event;

        unsigned long   v_colour;
        unsigned int    v_h, v_w;
        char            *v_smallf, *v_largef;

	float   	v_Vcx, v_Vcy, v_Vsx, v_Vsy;
	Matrix  	v_msave;
	TokList		*v_currentTokens;
	int		v_saveSync;
	Astack  	*v_asfree;
	Mstack  	*v_msfree;
	Vstack  	*v_vsfree;
	int		v_nCurveSegs;
	Matrix  	v_curveMatrix_e;
	int		v_current_obno;
	float   	v_c_x, 	v_c_y, 	v_c_z;
#endif

} VDevice;

#ifdef MULTI_X
# ifndef NUM_VDEVICES
#  define NUM_VDEVICES 32
# endif
  extern VDevice   __vdevices__[NUM_VDEVICES];
  extern VDevice   *__current_vdevice__;    	/* current device structure ptr */
  extern int      __nDeviceUsed__;
# define vdevice (*__current_vdevice__)
# define Vcx vdevice.v_Vcx
# define Vcy vdevice.v_Vcy
# define Vsx vdevice.v_Vsx
# define Vsy vdevice.v_Vsy
# define msave vdevice.v_msave
# define currentTokens vdevice.v_currentTokens
# define saveSync vdevice.v_saveSync
# define asfree	vdevice.v_asfree
# define msfree	vdevice.v_msfree
# define vsfree	vdevice.v_vsfree
# define nCurveSegs vdevice.v_nCurveSegs
# define curveMatrix_e vdevice.v_curveMatrix_e
# define current_obno vdevice.v_current_obno
# define c_x	vdevice.v_c_x
# define c_y	vdevice.v_c_y
# define c_z	vdevice.v_c_z
#else
  extern VDevice	vdevice;		/* device structure */
#endif

#define	V_X	0			/* x axis in cpW */
#define	V_Y	1			/* y axis in cpW */
#define	V_Z	2			/* z axis in cpW */
#define	V_W	3			/* w axis in cpW */

/*
 * function definitions
 */

/*
 * arc routines
 */
extern void	arcprecision();
extern void	circleprecision();
extern void	arc();
extern void	arcs();
extern void	arci();
extern void	arcf();
extern void	arcfs();
extern void	arcfi();
extern void	circ();
extern void	circs();
extern void	circi();
extern void	circf();
extern void	circfs();
extern void	circfi();

/*
 * attr routines
 */
extern void	popattributes();
extern void	pushattributes();

/*
 * curve routines
 */
extern void	curvebasis();
extern void	curveprecision();
extern void	rcrv();
extern void	crv();
extern void	crvn();
extern void	rcrvn();
extern void	curveit();

/*
 * draw routines
 */
extern void	draw();
extern void	draws();
extern void	drawi();
extern void	draw2();
extern void	draw2s();
extern void	draw2i();
extern void	rdr();
extern void	rdrs();
extern void	rdri();
extern void	rdr2();
extern void	rdr2s();
extern void	rdr2i();
extern void	bgnline();
extern void	endline();
extern void	bgnclosedline();
extern void	endclosedline();

/*
 * device routines
 */
extern void	qdevice();
extern void	unqdevice();
extern long	qread();
extern void	qreset();
extern long	qtest();
extern Boolean	isqueued();

extern void	gexit();
extern void	gconfig();
extern void	shademodel();
extern long	getgdesc();
extern long	winopen();
extern void	ginit();
extern void	gconfig();
extern long	getvaluator();
extern Boolean	getbutton();
extern void	clear();
extern void	colorf();
extern void	color();
extern void	mapcolor();
extern long	getplanes();

extern void	vinit();
extern void	voutput();
extern void	verror();
extern void	vnewdev();
extern char	*vgetdev();

/*
 * mapping routines
 */
extern int	WtoVx();
extern int	WtoVy();
extern void	VtoWxy();
extern void	CalcW2Vcoeffs();

/*
 * general matrix and vector routines
 */
extern void	mult4x4();
extern void	copymatrix();
extern void	identmatrix();
extern void	copytranspose();

extern void	multvector();
extern void	copyvector();
extern void	premultvector();

/*
 * matrix stack routines
 */
extern void	getmatrix();
extern void	popmatrix();
extern void	loadmatrix();
extern void	pushmatrix();
extern void	multmatrix();

/*
 * move routines
 */
extern void	move();
extern void	moves();
extern void	movei();
extern void	move2();
extern void	move2s();
extern void	move2i();
extern void	rmv();
extern void	rmvs();
extern void	rmvi();
extern void	rmv2();
extern void	rmv2s();
extern void	rmv2i();

/*
 * object routines
 */
extern Boolean	isobj();
extern long	genobj();
extern void	delobj();
extern void	makeobj();
extern void	callobj();
extern void	closeobj();
extern long	getopenobj();
extern Token	*newtokens();

/*
 * patch routines.
 */
extern void	defbasis();
extern void	patchbasis();
extern void	patchcurves();
extern void	patchprecision();
extern void	patch();
extern void	rpatch();

/*
 * point routines
 */
extern void	pnt();
extern void	pnts();
extern void	pnti();
extern void	pnt2();
extern void	pnt2s();
extern void	pnt2i();
extern void	bgnpoint();
extern void	endpoint();

/*
 * v routines
 */
extern void	v4f();
extern void	v3f();
extern void	v2f();
extern void	v4d();
extern void	v3d();
extern void	v2d();
extern void	v4i();
extern void	v3i();
extern void	v2i();
extern void	v4s();
extern void	v3s();
extern void	v2s();

/*
 * polygon routines.
 */
extern void	concave();
extern void	backface();
extern void	frontface();
extern void	polymode();
extern void	poly2();
extern void	poly2i();
extern void	poly2s();
extern void	polyi();
extern void	polys();
extern void	polf2();
extern void	polf2i();
extern void	polf2s();
extern void	polfi();
extern void	polfs();
extern void	poly();
extern void	polf();
extern void	pmv();
extern void	pmvi();
extern void	pmv2i();
extern void	pmvs();
extern void	pmv2s();
extern void	pmv2();
extern void	pdr();
extern void	rpdr();
extern void	rpdr2();
extern void	rpdri();
extern void	rpdr2i();
extern void	rpdrs();
extern void	rpdr2s();
extern void	rpmv();
extern void	rpmv2();
extern void	rpmvi();
extern void	rpmv2i();
extern void	rpmvs();
extern void	rpmv2s();
extern void	pdri();
extern void	pdr2i();
extern void	pdrs();
extern void	pdr2s();
extern void	pdr2();
extern void	pclos();
extern void	bgnpolygon();
extern void	endpolygon();

/*
 * rectangle routines
 */
extern void	rect();
extern void	recti();
extern void	rects();
extern void	rectf();
extern void	rectfi();
extern void	rectfs();

/*
 * tensor routines
 */
extern void multtensor();
extern void copytensor();
extern void premulttensor();
extern void copytensortrans();

/*
 * text routines
 */
extern void	font();
extern void	charstr();
extern void	cmov();
extern void	cmov2();
extern void	cmovi();
extern void	cmovs();
extern void	cmov2i();
extern void	cmov2s();
extern long	getwidth();
extern long	getheight();

/*
 * transformation routines
 */
extern void	scale();
extern void	translate();
extern void	rotate();
extern void	rot();

/*
 * window definition routines
 */
extern void	ortho();
extern void	ortho2();
extern void	lookat();
extern void	window();
extern void	polarview();
extern void	perspective();

/*
 * routines for manipulating the viewport
 */
extern void	viewport();
extern void	popviewport();
extern void	pushviewport();

/*
 * routines for retrieving the graphics position
 */
extern void	getgp();
extern void	getgpos();

/*
 * routines for handling the buffering
 */
extern void	backbuffer();
extern void	frontbuffer();
extern void	swapbuffers();
extern void	doublebuffer();

/*
 * routines for window sizing and positioning
 */
extern void	prefsize();
extern void	prefposition();

/*
 * Misc control routines
 */
extern void	vsetflush();
extern void	vflush();

#ifndef ORIGINAL
# ifdef MULTI_X
/*
 * claus:
 * added some as macros for a bit more speed ...
 */

# define WtoVx(p)					\
	(((p)[3] == 0.0)   				\
	    ? -1					\
	    : (int)((p)[0] * Vsx / (p)[3] + Vcx + 0.5))
		      
# define WtoVy(p)					\
	(((p)[3] == 0.0)   				\
	    ? -1					\
	    : (int)((p)[1] * Vsy / (p)[3] + Vcy + 0.5))

# endif /* MULTI_X */

# define move(x, y, z) 					\
    /*							\
     * inline move macro				\
     */							\
    {							\
        Token   *p;					\
							\
        if (!vdevice.initialised) {			\
            verror("move: vogl not initialised");	\
	} else {					\
            vdevice.cpW[V_X] = x;			\
            vdevice.cpW[V_Y] = y;			\
            vdevice.cpW[V_Z] = z;			\
							\
            vdevice.cpVvalid = 0;			\
							\
            if (vdevice.inobject) {			\
                p = newtokens(4);			\
							\
                p[0].i = MOVE;				\
                p[1].f = x;				\
                p[2].f = y;				\
                p[3].f = z;				\
            } else {					\
                if (vdevice.clipoff) {			\
                    multvector(vdevice.cpWtrans, vdevice.cpW, vdevice.transmat->m); \
                    vdevice.cpVx = WtoVx(vdevice.cpWtrans);	\
                    vdevice.cpVy = WtoVy(vdevice.cpWtrans);	\
		}					\
	    }						\
        }						\
    }

#endif
