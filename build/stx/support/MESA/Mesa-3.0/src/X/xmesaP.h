/* $Id: xmesaP.h,v 1.1 1998-10-05 22:35:03 cg Exp $ */

/*
 * Mesa 3-D graphics library
 * Version:  3.0
 * Copyright (C) 1995-1998  Brian Paul
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the Free
 * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */


/*
 * $Log: xmesaP.h,v $
 * Revision 1.1  1998-10-05 22:35:03  cg
 * *** empty log message ***
 *
 * Revision 3.3  1998/03/10 02:07:33  brianp
 * added HPCR dithering for color buffer clearing (jle@star.be)
 *
 * Revision 3.2  1998/03/10 01:25:41  brianp
 * updated for David's v0.23 fxMesa driver
 *
 * Revision 3.1  1998/03/05 02:49:21  brianp
 * renamed xmesa_setup_DD_pointers() to xmesa_update_state()
 *
 * Revision 3.0  1998/01/31 21:09:46  brianp
 * initial rev
 *
 */


#ifndef XMESAP_H
#define XMESAP_H


#ifdef SHM
#  include <X11/extensions/XShm.h>
#endif
#include "GL/xmesa.h"
#include "types.h"
#ifdef FX
#include "GL/fxmesa.h"
#include "../FX/fxdrv.h"
#endif


/*
 * Mesa wrapper for XVisualInfo
 */
struct xmesa_visual {
	GLvisual *gl_visual;	/* Device independent visual parameters */
	Display *display;	/* The X11 display */
	XVisualInfo *vishandle;	/* The pointer returned by glXChooseVisual */
	XVisualInfo *visinfo;	/* Private copy of vishandle's struct */

	GLint level;		/* 0=normal, 1=overlay, etc */

	GLboolean ximage_flag;	/* Use XImage for back buffer (not pixmap)? */

        GLuint dithered_pf;	/* Pixel format when dithering */
        GLuint undithered_pf;	/* Pixel format when not dithering */

        GLfloat RedGamma;	/* Gamma values, 1.0 is default */
        GLfloat GreenGamma;
        GLfloat BlueGamma;

        GLint rmult, gmult, bmult;	/* Range of color values */
        GLint index_bits;		/* Bits per pixel in CI mode */

	/* For PF_TRUECOLOR */
	GLint rshift, gshift, bshift;	/* Pixel color component shifts */
	GLubyte Kernel[16];		/* Dither kernel */
	unsigned long RtoPixel[512];	/* RGB to pixel conversion */
	unsigned long GtoPixel[512];
	unsigned long BtoPixel[512];
	GLubyte PixelToR[256];		/* Pixel to RGB conversion */
	GLubyte PixelToG[256];
	GLubyte PixelToB[256];

	/* For PF_HPCR */
	short     hpcr_rgbTbl[3][256];
	GLboolean hpcr_clear_flag;
	GLubyte   hpcr_clear_ximage_pattern[2][16];
	XImage *  hpcr_clear_ximage;
	Pixmap    hpcr_clear_pixmap;

	/* For PF_1BIT */
	int bitFlip;
};



/*
 * Mesa wrapper for core rendering context
 */
struct xmesa_context {
	GLcontext *gl_ctx;		/* the core library context */
        XMesaVisual xm_visual;		/* Describes the buffers */
	XMesaBuffer xm_buffer;		/* current framebuffer */

	Display *display;	/* == xm_visual->display */
        GLboolean swapbytes;	/* Host byte order != display byte order? */

	GLuint pixelformat;		/* Current pixel format */

        GLubyte red, green, blue, alpha;/* current drawing color */
	unsigned long pixel;		/* current drawing pixel value */

	GLubyte clearcolor[4];		/* current clearing color */
	unsigned long clearpixel;	/* current clearing pixel value */
};



/*
 * Mesa wrapper for X window or Pixmap
 */
struct xmesa_buffer {
   GLboolean wasCurrent;	/* was ever the current buffer? */
   GLframebuffer *gl_buffer;	/* depth, stencil, accum, etc buffers */
   XMesaVisual xm_visual;	/* the X/Mesa visual */

   Display *display;
   GLboolean pixmap_flag;	/* is the buffer a Pixmap? */
   Drawable frontbuffer;	/* either a window or pixmap */
   Pixmap backpixmap;		/* back buffer Pixmap */
   XImage *backimage;		/* back buffer XImage */

   Drawable buffer;		/* the current buffer, either equal to */
				/* frontbuffer, backpixmap or XIMAGE (None) */

   Colormap cmap;		/* the X colormap */

   GLint db_state;		/* 0 = single buffered */
				/* BACK_PIXMAP = use Pixmap for back buffer */
				/* BACK_XIMAGE = use XImage for back buffer */

   GLuint shm;			/* X Shared Memory extension status:	*/
				/*    0 = not available			*/
				/*    1 = XImage support available	*/
				/*    2 = Pixmap support available too	*/
#ifdef SHM
   XShmSegmentInfo shminfo;
#endif

   XImage *rowimage;		/* Used for optimized span writing */

   GLuint width, height;	/* size of buffer */

   GLint bottom;		/* used for FLIP macro below */
   GLubyte *ximage_origin1;	/* used for PIXELADDR1 macro */
   GLint ximage_width1;
   GLushort *ximage_origin2;	/* used for PIXELADDR2 macro */
   GLint ximage_width2;
   GLuint *ximage_origin4;	/* used for PIXELADDR4 macro */
   GLint ximage_width4;

   Pixmap stipple_pixmap;	/* For polygon stippling */
   GC stipple_gc;		/* For polygon stippling */

   GC gc1;			/* GC for infrequent color changes */
   GC gc2;			/* GC for frequent color changes */
   GC cleargc;			/* GC for clearing the color buffer */

   /* The following are here instead of in the XMesaVisual
    * because they depend on the window's colormap.
    */

   /* For PF_DITHER, PF_LOOKUP, PF_GRAYSCALE */
   unsigned long color_table[576];	/* RGB -> pixel value */

   /* For PF_DITHER, PF_LOOKUP, PF_GRAYSCALE */
   GLubyte pixel_to_r[65536];		/* pixel value -> red */
   GLubyte pixel_to_g[65536];		/* pixel value -> green */
   GLubyte pixel_to_b[65536];		/* pixel value -> blue */

   /* Used to do XAllocColor/XFreeColors accounting: */
   int num_alloced;
   unsigned long alloced_colors[256];

#ifdef FX
  GLboolean FXisHackUsable;	        /* Is 3Dfx Glide for rendering into X win possible ? */
  GLboolean FXwindowHack;	        /* Use 3Dfx Glide for rendering into X win ? */
  fxMesaContext FXctx;
#endif

   struct xmesa_buffer *Next;	/* Linked list pointer: */
};



/* Values for xmesa->dest: */
#define FRONT_PIXMAP	1
#define BACK_PIXMAP	2
#define BACK_XIMAGE	4


/* Values for xmesa->pixelformat: */
#define PF_INDEX	1	/* Color Index mode */
#define PF_TRUECOLOR	2	/* TrueColor or DirectColor, any depth */
#define PF_TRUEDITHER	3	/* TrueColor with dithering */
#define PF_8A8B8G8R	4	/* 32-bit TrueColor:  8-A, 8-B, 8-G, 8-R */
#define PF_8R8G8B	5	/* 32-bit TrueColor:  8-R, 8-G, 8-B bits */
#define PF_5R6G5B	6	/* 16-bit TrueColor:  5-R, 6-G, 5-B bits */
#define PF_DITHER	7	/* Color-mapped RGB with dither */
#define PF_LOOKUP	8	/* Color-mapped RGB without dither */
#define PF_HPCR		9	/* HP Color Recovery (ad@lms.be 30/08/95) */
#define PF_1BIT		10	/* monochrome dithering of RGB */
#define PF_GRAYSCALE	11	/* Grayscale or StaticGray */


/*
 * If pixelformat==PF_TRUECOLOR:
 */
#define PACK_TRUECOLOR( PIXEL, R, G, B )	\
   PIXEL = xmesa->xm_visual->RtoPixel[R]	\
         | xmesa->xm_visual->GtoPixel[G]	\
         | xmesa->xm_visual->BtoPixel[B];	\


/*
 * If pixelformat==PF_TRUEDITHER:
 */
#define PACK_TRUEDITHER( PIXEL, X, Y, R, G, B )			\
{								\
   int d = xmesa->xm_visual->Kernel[((X)&3) | (((Y)&3)<<2)];	\
   PIXEL = xmesa->xm_visual->RtoPixel[(R)+d]			\
         | xmesa->xm_visual->GtoPixel[(G)+d]			\
         | xmesa->xm_visual->BtoPixel[(B)+d];			\
}



/*
 * If pixelformat==PF_8A8B8G8R:
 */
#define PACK_8A8B8G8R( R, G, B, A )	\
	( ((A) << 24) | ((B) << 16) | ((G) << 8) | (R) )


/*
 * Like PACK_8A8B8G8R() but don't use alpha.  This is usually an acceptable
 * shortcut.
 */
#define PACK_8B8G8R( R, G, B )   ( ((B) << 16) | ((G) << 8) | (R) )



/*
 * If pixelformat==PF_8R8G8B:
 */
#define PACK_8R8G8B( R, G, B)	 ( ((R) << 16) | ((G) << 8) | (B) )


/*
 * If pixelformat==PF_5R6G5B:
 */
#define PACK_5R6G5B( R, G, B)	 ( (((R) & 0xf8) << 8) | (((G) & 0xfc) << 3) | ((B) >> 3) )



/*
 * If pixelformat==PF_DITHER:
 *
 * Improved 8-bit RGB dithering code contributed by Bob Mercier
 * (mercier@hollywood.cinenet.net).  Thanks Bob!
 */
#undef _R
#undef _G
#undef _B
#ifdef DITHER666
# define _R   6
# define _G   6
# define _B   6
# define _MIX(r,g,b)  (((r)*_G+(g))*_B+(b))
#else
# define _R	5
# define _G	9
# define _B	5
# define _MIX(r,g,b)	( ((g)<<6) | ((b)<<3) | (r) )
#endif
#define _DX	4
#define _DY	4
#define _D	(_DX*_DY)

/*#define _DITH(C,c,d)	(((unsigned)((_D*(C-1)+1)*c+d))/(_D*256))*/
#define _DITH(C,c,d)	(((unsigned)((_D*(C-1)+1)*c+d)) >> 12)

#define MAXC	256
static int kernel8[_DY*_DX] = {
    0 * MAXC,  8 * MAXC,  2 * MAXC, 10 * MAXC,
   12 * MAXC,  4 * MAXC, 14 * MAXC,  6 * MAXC,
    3 * MAXC, 11 * MAXC,  1 * MAXC,  9 * MAXC,
   15 * MAXC,  7 * MAXC, 13 * MAXC,  5 * MAXC,
};
/*static int __d;*/

/* Dither for random X,Y */
#define DITHER_SETUP						\
	int __d;						\
	unsigned long *ctable = xmesa->xm_buffer->color_table;

#define DITHER( X, Y, R, G, B )				\
	(__d = kernel8[(((Y)&3)<<2) | ((X)&3)],		\
	 ctable[_MIX(_DITH(_R, (R), __d),		\
		     _DITH(_G, (G), __d),		\
		     _DITH(_B, (B), __d))])

/* Dither for random X, fixed Y */
#define XDITHER_SETUP(Y)					\
	int __d;						\
	unsigned long *ctable = xmesa->xm_buffer->color_table;	\
	int *kernel = &kernel8[ ((Y)&3) << 2 ];

#define XDITHER( X, R, G, B )				\
	(__d = kernel[(X)&3],				\
	ctable[_MIX(_DITH(_R, (R), __d),		\
		    _DITH(_G, (G), __d),		\
		    _DITH(_B, (B), __d))])


/*
 * Dithering for flat-shaded triangles.  Precompute all 16 possible
 * pixel values given the triangle's RGB color.  Contributed by Martin Shenk.
 */
static GLushort DitherValues[16];   /* array of (up to) 16-bit pixel values */

#define FLAT_DITHER_SETUP( R, G, B )					\
	{								\
	   unsigned long *ctable = xmesa->xm_buffer->color_table;	\
	   int msdr = (_D*((_R)-1)+1) * (R);				\
	   int msdg = (_D*((_G)-1)+1) * (G);				\
	   int msdb = (_D*((_B)-1)+1) * (B);				\
	   int i;							\
	   for (i=0;i<16;i++) {						\
	      int k = kernel8[i];					\
	      int j = _MIX( (msdr+k)>>12, (msdg+k)>>12, (msdb+k)>>12 );	\
	      DitherValues[i] = ctable[j];				\
	   }								\
        }

#define FLAT_DITHER_ROW_SETUP(Y)					\
	GLushort *ditherRow = DitherValues + ( ((Y)&3) << 2);

#define FLAT_DITHER(X)  ditherRow[(X)&3]



/*
 * If pixelformat==PF_LOOKUP:
 */
#define _DITH0(C,c)	(((unsigned)((_D*(C-1)+1)*c)) >> 12)

#define LOOKUP_SETUP						\
	unsigned long *ctable = xmesa->xm_buffer->color_table

#define LOOKUP( R, G, B )			\
	ctable[_MIX(_DITH0(_R, (R)),		\
		    _DITH0(_G, (G)),		\
		    _DITH0(_B, (B)))]



/*
 * If pixelformat==PF_HPCR:
 *
 *      HP Color Recovery dithering               (ad@lms.be 30/08/95)
 *      HP has on it's 8-bit 700-series computers, a feature called
 *      'Color Recovery'.  This allows near 24-bit output (so they say).
 *      It is enabled by selecting the 8-bit  TrueColor  visual AND
 *      corresponding  colormap (see tkInitWindow) AND doing some special
 *      dither.
 */
static const short HPCR_DRGB[3][2][16] = {
{
    { 16, -4,  1,-11, 14, -6,  3, -9, 15, -5,  2,-10, 13, -7,  4, -8},
    {-15,  5,  0, 12,-13,  7, -2, 10,-14,  6, -1, 11,-12,  8, -3,  9} 
},
{
    {-11, 15, -7,  3, -8, 14, -4,  2,-10, 16, -6,  4, -9, 13, -5,  1},
    { 12,-14,  8, -2,  9,-13,  5, -1, 11,-15,  7, -3, 10,-12,  6,  0} 
},
{
    {  6,-18, 26,-14,  2,-22, 30,-10,  8,-16, 28,-12,  4,-20, 32, -8},
    { -4, 20,-24, 16,  0, 24,-28, 12, -6, 18,-26, 14, -2, 22,-30, 10} 
}
};

#define DITHER_HPCR( X, Y, R, G, B )					   \
  ( ((xmesa->xm_visual->hpcr_rgbTbl[0][R] + HPCR_DRGB[0][(Y)&1][(X)&15]) & 0xE0)     \
  |(((xmesa->xm_visual->hpcr_rgbTbl[1][G] + HPCR_DRGB[1][(Y)&1][(X)&15]) & 0xE0)>>3) \
  | ((xmesa->xm_visual->hpcr_rgbTbl[2][B] + HPCR_DRGB[2][(Y)&1][(X)&15])>>6)	   \
  )



/*
 * If pixelformat==PF_1BIT:
 */
static int const kernel1[16] = {
   0*47,  9*47,  4*47, 12*47,     /* 47 = (255*3)/16 */
   6*47,  2*47, 14*47,  8*47,
  10*47,  1*47,  5*47, 11*47,
   7*47, 13*47,  3*47, 15*47 };

#define SETUP_1BIT  int bitFlip = xmesa->xm_visual->bitFlip
#define DITHER_1BIT( X, Y, R, G, B )	\
	(( ((int)(R)+(int)(G)+(int)(B)) > kernel1[(((Y)&3) << 2) | ((X)&3)] ) ^ bitFlip)



/*
 * If pixelformat==PF_GRAYSCALE:
 */
#define GRAY_RGB( R, G, B )   xmesa->xm_buffer->color_table[(R) + (G) + (B)]



#define XIMAGE None


/*
 * Converts a GL window Y coord to an X window Y coord:
 */
#define FLIP(Y)  (xmesa->xm_buffer->bottom-(Y))


/*
 * Return the address of a 1, 2 or 4-byte pixel in the back XImage:
 * X==0 is left, Y==0 is bottom.
 */
#define PIXELADDR1( X, Y )  \
      ( xmesa->xm_buffer->ximage_origin1 - (Y) * xmesa->xm_buffer->ximage_width1 + (X) )

#define PIXELADDR2( X, Y )  \
      ( xmesa->xm_buffer->ximage_origin2 - (Y) * xmesa->xm_buffer->ximage_width2 + (X) )

#define PIXELADDR4( X, Y )  \
      ( xmesa->xm_buffer->ximage_origin4 - (Y) * xmesa->xm_buffer->ximage_width4 + (X) )



/*
 * External functions:
 */

extern unsigned long xmesa_color_to_pixel( XMesaContext xmesa,
		                  GLubyte r, GLubyte g, GLubyte b, GLubyte a );

extern void xmesa_alloc_back_buffer( XMesaBuffer b );

extern void xmesa_update_state( GLcontext *ctx );

extern points_func xmesa_get_points_func( GLcontext *ctx );

extern line_func xmesa_get_line_func( GLcontext *ctx );

extern triangle_func xmesa_get_triangle_func( GLcontext *ctx );



#endif
