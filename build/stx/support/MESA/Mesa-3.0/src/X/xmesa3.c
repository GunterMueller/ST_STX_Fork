/* $Id: xmesa3.c,v 1.1 1998-10-05 22:35:00 cg Exp $ */

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
 * $Log: xmesa3.c,v $
 * Revision 1.1  1998-10-05 22:35:00  cg
 * *** empty log message ***
 *
 * Revision 3.2  1998/07/26 16:46:56  brianp
 * disabled use of X stippled lines
 *
 * Revision 3.1  1998/07/17 03:38:37  brianp
 * added struct timespec declaration to silence a compiler warning
 *
 * Revision 3.0  1998/01/31 21:08:31  brianp
 * initial rev
 *
 */


/*
 * Mesa/X11 interface, part 3.
 *
 * This file contains "accelerated" point, line, and triangle functions.
 * It should be fairly easy to write new special-purpose point, line or
 * triangle functions and hook them into this module.
 */


struct timespec;  /* this silences a compiler warning on several systems */

#include <sys/time.h>
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <X11/Xlib.h>
#include "depth.h"
#include "macros.h"
#include "vb.h"
#include "types.h"
#include "xmesaP.h"




/**********************************************************************/
/***                    Point rendering                             ***/
/**********************************************************************/


/*
 * Render an array of points into a pixmap, any pixel format.
 */
static void draw_points_ANY_pixmap( GLcontext *ctx, GLuint first, GLuint last )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   struct vertex_buffer *VB = ctx->VB;
   register GLuint i;

   if (VB->MonoColor) {
      /* all same color */
      XPoint p[VB_SIZE];
      int n = 0;
      for (i=first;i<=last;i++) {
         if (VB->ClipMask[i]==0) {
            p[n].x =       (GLint) VB->Win[i][0];
            p[n].y = FLIP( (GLint) VB->Win[i][1] );
            n++;
         }
      }
      XDrawPoints( dpy, buffer, xmesa->xm_buffer->gc1, p, n, CoordModeOrigin );
   }
   else {
      /* all different colors */
      if (xmesa->xm_visual->gl_visual->RGBAflag) {
         /* RGB mode */
         for (i=first;i<=last;i++) {
            if (VB->ClipMask[i]==0) {
               register int x, y;
               unsigned long pixel = xmesa_color_to_pixel( xmesa,
                                                VB->Color[i][0],
                                                VB->Color[i][1],
                                                VB->Color[i][2],
                                                VB->Color[i][3] );
               XSetForeground( dpy, gc, pixel );
               x =       (GLint) VB->Win[i][0];
               y = FLIP( (GLint) VB->Win[i][1] );
               XDrawPoint( dpy, buffer, gc, x, y);
            }
         }
      }
      else {
         /* Color index mode */
         for (i=first;i<=last;i++) {
            if (VB->ClipMask[i]==0) {
               register int x, y;
               XSetForeground( dpy, gc, VB->Index[i] );
               x =       (GLint) VB->Win[i][0];
               y = FLIP( (GLint) VB->Win[i][1] );
               XDrawPoint( dpy, buffer, gc, x, y);
            }
         }
      }
   }
}



/*
 * Analyze context state to see if we can provide a fast points drawing
 * function, like those in points.c.  Otherwise, return NULL.
 */
points_func xmesa_get_points_func( GLcontext *ctx )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;

   if (ctx->Point.Size==1.0F && !ctx->Point.SmoothFlag && ctx->RasterMask==0
       && !ctx->Texture.Enabled) {
      if (xmesa->xm_buffer->buffer==XIMAGE) {
         return NULL; /*draw_points_ximage;*/
      }
      else {
         return draw_points_ANY_pixmap;
      }
   }
   else {
      return NULL;
   }
}



/**********************************************************************/
/***                      Line rendering                            ***/
/**********************************************************************/

/*
 * Render a line into a pixmap, any pixel format.
 */
static void flat_pixmap_line( GLcontext *ctx,
                              GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   struct vertex_buffer *VB = ctx->VB;
   register int x0, y0, x1, y1;
   GC gc;
   if (VB->MonoColor) {
      gc = xmesa->xm_buffer->gc1;  /* use current color */
   }
   else {
      unsigned long pixel;
      if (xmesa->xm_visual->gl_visual->RGBAflag) {
         pixel = xmesa_color_to_pixel( xmesa,
                                       VB->Color[pv][0], VB->Color[pv][1],
                                       VB->Color[pv][2], VB->Color[pv][3] );
      }
      else {
         pixel = VB->Index[pv];
      }
      gc = xmesa->xm_buffer->gc2;
      XSetForeground( xmesa->display, gc, pixel );
   }
   x0 =       (GLint) VB->Win[vert0][0];
   y0 = FLIP( (GLint) VB->Win[vert0][1] );
   x1 =       (GLint) VB->Win[vert1][0];
   y1 = FLIP( (GLint) VB->Win[vert1][1] );
   XDrawLine( xmesa->display, xmesa->xm_buffer->buffer, gc, x0, y0, x1, y1 );
}



/*
 * Draw a flat-shaded, PF_TRUECOLOR line into an XImage.
 */
static void flat_TRUECOLOR_line( GLcontext *ctx,
                                 GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   XImage *img = xmesa->xm_buffer->backimage;
   unsigned long pixel;
   PACK_TRUECOLOR( pixel, color[0], color[1], color[2] );

#define INTERP_XY 1
#define CLIP_HACK 1
#define PLOT(X,Y) XPutPixel( img, X, FLIP(Y), pixel );

#include "linetemp.h"
}



/*
 * Draw a flat-shaded, PF_8A8B8G8R line into an XImage.
 */
static void flat_8A8B8G8R_line( GLcontext *ctx,
                                GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   GLuint pixel = PACK_8B8G8R( color[0], color[1], color[2] );

#define PIXEL_TYPE GLuint
#define BYTES_PER_ROW (xmesa->xm_buffer->backimage->bytes_per_line)
#define PIXEL_ADDRESS(X,Y) PIXELADDR4(X,Y)
#define CLIP_HACK 1
#define PLOT(X,Y) *pixelPtr = pixel;

#include "linetemp.h"
}


/*
 * Draw a flat-shaded, PF_8R8G8B line into an XImage.
 */
static void flat_8R8G8B_line( GLcontext *ctx,
                              GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   GLuint pixel = PACK_8R8G8B( color[0], color[1], color[2] );

#define PIXEL_TYPE GLuint
#define BYTES_PER_ROW (xmesa->xm_buffer->backimage->bytes_per_line)
#define PIXEL_ADDRESS(X,Y) PIXELADDR4(X,Y)
#define CLIP_HACK 1
#define PLOT(X,Y) *pixelPtr = pixel;

#include "linetemp.h"
}


/*
 * Draw a flat-shaded, PF_5R6G5B line into an XImage.
 */
static void flat_5R6G5B_line( GLcontext *ctx,
                              GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   GLushort pixel = PACK_5R6G5B( color[0], color[1], color[2] );

#define PIXEL_TYPE GLushort
#define BYTES_PER_ROW (xmesa->xm_buffer->backimage->bytes_per_line)
#define PIXEL_ADDRESS(X,Y) PIXELADDR2(X,Y)
#define CLIP_HACK 1
#define PLOT(X,Y) *pixelPtr = pixel;

#include "linetemp.h"
}



/*
 * Draw a flat-shaded, PF_DITHER 8-bit line into an XImage.
 */
static void flat_DITHER8_line( GLcontext *ctx,
                               GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   GLint r = color[0], g = color[1], b = color[2];
   DITHER_SETUP;

#define INTERP_XY 1
#define PIXEL_TYPE GLubyte
#define BYTES_PER_ROW (xmesa->xm_buffer->backimage->bytes_per_line)
#define PIXEL_ADDRESS(X,Y) PIXELADDR1(X,Y)
#define CLIP_HACK 1
#define PLOT(X,Y) *pixelPtr = DITHER(X,Y,r,g,b);

#include "linetemp.h"
}


/*
 * Draw a flat-shaded, PF_LOOKUP 8-bit line into an XImage.
 */
static void flat_LOOKUP8_line( GLcontext *ctx,
                               GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   GLubyte pixel;
   LOOKUP_SETUP;
   pixel = LOOKUP( color[0], color[1], color[2] );

#define PIXEL_TYPE GLubyte
#define BYTES_PER_ROW (xmesa->xm_buffer->backimage->bytes_per_line)
#define PIXEL_ADDRESS(X,Y) PIXELADDR1(X,Y)
#define CLIP_HACK 1
#define PLOT(X,Y) *pixelPtr = pixel;

#include "linetemp.h"
}


/*
 * Draw a flat-shaded, PF_HPCR line into an XImage.
 */
static void flat_HPCR_line( GLcontext *ctx,
                            GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   GLint r = color[0], g = color[1], b = color[2];

#define INTERP_XY 1
#define PIXEL_TYPE GLubyte
#define BYTES_PER_ROW (xmesa->xm_buffer->backimage->bytes_per_line)
#define PIXEL_ADDRESS(X,Y) PIXELADDR1(X,Y)
#define CLIP_HACK 1
#define PLOT(X,Y) *pixelPtr = DITHER_HPCR(X,Y,r,g,b);

#include "linetemp.h"
}



/*
 * Draw a flat-shaded, Z-less, PF_TRUECOLOR line into an XImage.
 */
static void flat_TRUECOLOR_z_line( GLcontext *ctx,
                                   GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   XImage *img = xmesa->xm_buffer->backimage;
   unsigned long pixel;
   PACK_TRUECOLOR( pixel, color[0], color[1], color[2] );

#define INTERP_XY 1
#define INTERP_Z 1
#define CLIP_HACK 1
#define PLOT(X,Y)				\
	if (Z < *zPtr) {			\
	   *zPtr = Z;				\
           XPutPixel( img, X, FLIP(Y), pixel );	\
	}

#include "linetemp.h"
}


/*
 * Draw a flat-shaded, Z-less, PF_8A8B8G8R line into an XImage.
 */
static void flat_8A8B8G8R_z_line( GLcontext *ctx,
                                  GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   GLuint pixel = PACK_8B8G8R( color[0], color[1], color[2] );

#define INTERP_Z 1
#define PIXEL_TYPE GLuint
#define BYTES_PER_ROW (xmesa->xm_buffer->backimage->bytes_per_line)
#define PIXEL_ADDRESS(X,Y) PIXELADDR4(X,Y)
#define CLIP_HACK 1
#define PLOT(X,Y)		\
	if (Z < *zPtr) {	\
	   *zPtr = Z;		\
	   *pixelPtr = pixel;	\
	}

#include "linetemp.h"
}


/*
 * Draw a flat-shaded, Z-less, PF_8R8G8B line into an XImage.
 */
static void flat_8R8G8B_z_line( GLcontext *ctx,
                                GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   GLuint pixel = PACK_8R8G8B( color[0], color[1], color[2] );

#define INTERP_Z 1
#define PIXEL_TYPE GLuint
#define BYTES_PER_ROW (xmesa->xm_buffer->backimage->bytes_per_line)
#define PIXEL_ADDRESS(X,Y) PIXELADDR4(X,Y)
#define CLIP_HACK 1
#define PLOT(X,Y)		\
	if (Z < *zPtr) {	\
	   *zPtr = Z;		\
	   *pixelPtr = pixel;	\
	}

#include "linetemp.h"
}


/*
 * Draw a flat-shaded, Z-less, PF_5R6G5B line into an XImage.
 */
static void flat_5R6G5B_z_line( GLcontext *ctx,
                                GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   GLushort pixel = PACK_5R6G5B( color[0], color[1], color[2] );

#define INTERP_Z 1
#define PIXEL_TYPE GLushort
#define BYTES_PER_ROW (xmesa->xm_buffer->backimage->bytes_per_line)
#define PIXEL_ADDRESS(X,Y) PIXELADDR2(X,Y)
#define CLIP_HACK 1
#define PLOT(X,Y)		\
	if (Z < *zPtr) {	\
	   *zPtr = Z;		\
	   *pixelPtr = pixel;	\
	}
#include "linetemp.h"
}


/*
 * Draw a flat-shaded, Z-less, PF_DITHER 8-bit line into an XImage.
 */
static void flat_DITHER8_z_line( GLcontext *ctx,
                                 GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   GLint r = color[0], g = color[1], b = color[2];
   DITHER_SETUP;

#define INTERP_XY 1
#define INTERP_Z 1
#define PIXEL_TYPE GLubyte
#define BYTES_PER_ROW (xmesa->xm_buffer->backimage->bytes_per_line)
#define PIXEL_ADDRESS(X,Y) PIXELADDR1(X,Y)
#define CLIP_HACK 1
#define PLOT(X,Y)				\
	if (Z < *zPtr) {			\
	   *zPtr = Z;				\
	   *pixelPtr = DITHER( X, Y, r, g, b);	\
	}
#include "linetemp.h"
}


/*
 * Draw a flat-shaded, Z-less, PF_LOOKUP 8-bit line into an XImage.
 */
static void flat_LOOKUP8_z_line( GLcontext *ctx,
                                 GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   GLubyte pixel;
   LOOKUP_SETUP;
   pixel = LOOKUP( color[0], color[1], color[2] );

#define INTERP_Z 1
#define PIXEL_TYPE GLubyte
#define BYTES_PER_ROW (xmesa->xm_buffer->backimage->bytes_per_line)
#define PIXEL_ADDRESS(X,Y) PIXELADDR1(X,Y)
#define CLIP_HACK 1
#define PLOT(X,Y)		\
	if (Z < *zPtr) {	\
	   *zPtr = Z;		\
	   *pixelPtr = pixel;	\
	}

#include "linetemp.h"
}


/*
 * Draw a flat-shaded, Z-less, PF_HPCR line into an XImage.
 */
static void flat_HPCR_z_line( GLcontext *ctx,
                              GLuint vert0, GLuint vert1, GLuint pv )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *color = ctx->VB->Color[pv];
   GLint r = color[0], g = color[1], b = color[2];

#define INTERP_XY 1
#define INTERP_Z 1
#define PIXEL_TYPE GLubyte
#define BYTES_PER_ROW (xmesa->xm_buffer->backimage->bytes_per_line)
#define PIXEL_ADDRESS(X,Y) PIXELADDR1(X,Y)
#define CLIP_HACK 1
#define PLOT(X,Y)					\
	if (Z < *zPtr) {				\
	   *zPtr = Z;					\
	   *pixelPtr = DITHER_HPCR( X, Y, r, g, b);	\
	}

#include "linetemp.h"
}


/*
 * Examine ctx->Line attributes and set xmesa->xm_buffer->gc1
 * and xmesa->xm_buffer->gc2 appropriately.
 */
static void setup_x_line_options( GLcontext *ctx )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   int i, state, state0, new_state, len, offs;
   int tbit;
   char *dptr;
   int n_segments = 0;
   char dashes[20];
   int line_width, line_style;

   /*** Line Stipple ***/
   if (ctx->Line.StippleFlag) {
      const int pattern = ctx->Line.StipplePattern;

      dptr = dashes;
      state0 = state = ((pattern & 1) != 0);

      /* Decompose the pattern */
      for (i=1,tbit=2,len=1;i<16;++i,tbit=(tbit<<1))
	{
	  new_state = ((tbit & pattern) != 0);
	  if (state != new_state)
	    {
	      *dptr++ = ctx->Line.StippleFactor * len;
	      len = 1;
	      state = new_state;
	    }
	  else
	    ++len;
	}
      *dptr = ctx->Line.StippleFactor * len;
      n_segments = 1 + (dptr - dashes);

      /* ensure an even no. of segments, or X may toggle on/off for consecutive patterns */
      /* if (n_segments & 1)  dashes [n_segments++] = 0;  value of 0 not allowed in dash list */

      /* Handle case where line style starts OFF */
      if (state0 == 0)
        offs = dashes[0];
      else
        offs = 0;

#if 0
fprintf (stderr, "input pattern: 0x%04x, offset %d, %d segments:", pattern, offs, n_segments);
for (i = 0;  i < n_segments;  i++)
fprintf (stderr, " %d", dashes[i]);
fprintf (stderr, "\n");
#endif

      XSetDashes( xmesa->display, xmesa->xm_buffer->gc1, offs, dashes, n_segments );
      XSetDashes( xmesa->display, xmesa->xm_buffer->gc2, offs, dashes, n_segments );

      line_style = LineOnOffDash;
   }
   else {
      line_style = LineSolid;
   }

   /*** Line Width ***/
   line_width = (int) (ctx->Line.Width+0.5F);
   if (line_width < 2) {
      /* Use fast lines when possible */
      line_width = 0;
   }

   /*** Set GC attributes ***/
   XSetLineAttributes( xmesa->display, xmesa->xm_buffer->gc1,
                       line_width, line_style, CapButt, JoinBevel);
   XSetLineAttributes( xmesa->display, xmesa->xm_buffer->gc2,
                       line_width, line_style, CapButt, JoinBevel);
   XSetFillStyle( xmesa->display, xmesa->xm_buffer->gc1, FillSolid );
   XSetFillStyle( xmesa->display, xmesa->xm_buffer->gc2, FillSolid );
}



/*
 * Analyze context state to see if we can provide a fast line drawing
 * function, like those in lines.c.  Otherwise, return NULL.
 */
line_func xmesa_get_line_func( GLcontext *ctx )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   int depth = xmesa->xm_visual->visinfo->depth;

   if (ctx->Line.SmoothFlag)              return NULL;
   if (ctx->Texture.Enabled)              return NULL;
   if (ctx->Light.ShadeModel!=GL_FLAT)    return NULL;
   /* X line stippling doesn't match OpenGL stippling */
   if (ctx->Line.StippleFlag==GL_TRUE)    return NULL;

   if (xmesa->xm_buffer->buffer==XIMAGE
       && ctx->RasterMask==DEPTH_BIT
       && ctx->Depth.Func==GL_LESS
       && ctx->Depth.Mask==GL_TRUE
       && ctx->Line.Width==1.0F) {
      switch (xmesa->pixelformat) {
         case PF_TRUECOLOR:
            return flat_TRUECOLOR_z_line;
         case PF_8A8B8G8R:
            return flat_8A8B8G8R_z_line;
         case PF_8R8G8B:
            return flat_8R8G8B_z_line;
         case PF_5R6G5B:
            return flat_5R6G5B_z_line;
         case PF_DITHER:
            return (depth==8) ? flat_DITHER8_z_line : NULL;
         case PF_LOOKUP:
            return (depth==8) ? flat_LOOKUP8_z_line : NULL;
         case PF_HPCR:
            return flat_HPCR_z_line;
         default:
            return NULL;
      }
   }
   if (xmesa->xm_buffer->buffer==XIMAGE
       && ctx->RasterMask==0
       && ctx->Line.Width==1.0F) {
      switch (xmesa->pixelformat) {
         case PF_TRUECOLOR:
            return flat_TRUECOLOR_line;
         case PF_8A8B8G8R:
            return flat_8A8B8G8R_line;
         case PF_8R8G8B:
            return flat_8R8G8B_line;
         case PF_5R6G5B:
            return flat_5R6G5B_line;
         case PF_DITHER:
            return (depth==8) ? flat_DITHER8_line : NULL;
         case PF_LOOKUP:
            return (depth==8) ? flat_LOOKUP8_line : NULL;
         case PF_HPCR:
            return flat_HPCR_line;
	 default:
	    return NULL;
      }
   }
   if (xmesa->xm_buffer->buffer!=XIMAGE && ctx->RasterMask==0) {
      setup_x_line_options( ctx );
      return flat_pixmap_line;
   }
   return NULL;
}
