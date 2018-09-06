/* $Id: xmesa2.c,v 1.1 1998-10-05 22:34:55 cg Exp $ */

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
 * $Log: xmesa2.c,v $
 * Revision 1.1  1998-10-05 22:34:55  cg
 * *** empty log message ***
 *
 * Revision 3.7  1998/07/26 16:28:09  brianp
 * tuned 8R8G8B ximage span writing functions
 *
 * Revision 3.6  1998/06/13 15:25:52  brianp
 * added some prototype code - commented out
 *
 * Revision 3.5  1998/03/28 03:59:12  brianp
 * added CONST macro to fix IRIX compilation problems
 *
 * Revision 3.4  1998/03/28 02:03:36  brianp
 * fixed G++ warnings
 *
 * Revision 3.3  1998/03/10 02:07:33  brianp
 * added HPCR dithering for color buffer clearing (jle@star.be)
 *
 * Revision 3.2  1998/03/05 02:49:21  brianp
 * renamed xmesa_setup_DD_pointers() to xmesa_update_state()
 *
 * Revision 3.1  1998/01/31 23:58:34  brianp
 * updated all buffer clear functions to match new Driver.Clear function
 *
 * Revision 3.0  1998/01/31 21:08:31  brianp
 * initial rev
 *
 */


/*
 * Mesa/X11 interface, part 2.
 *
 * This file contains the implementations of all the device driver functions.
 */



#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <X11/Xlib.h>
#include "GL/xmesa.h"
#include "context.h"
#include "macros.h"
#include "types.h"
#include "xmesaP.h"




/*
 * The following functions are used to trap XGetImage() calls which
 * generate BadMatch errors if the drawable isn't mapped.
 */

static int caught_xgetimage_error = 0;
static int (*old_xerror_handler)( Display *dpy, XErrorEvent *ev );
static unsigned long xgetimage_serial;

/*
 * This is the error handler which will be called if XGetImage fails.
 */
static int xgetimage_error_handler( Display *dpy, XErrorEvent *ev )
{
   if (ev->serial==xgetimage_serial && ev->error_code==BadMatch) {
      /* caught the expected error */
      caught_xgetimage_error = 0;
   }
   else {
      /* call the original X error handler, if any.  otherwise ignore */
      if (old_xerror_handler) {
         (*old_xerror_handler)( dpy, ev );
      }
   }
   return 0;
}


/*
 * Call this right before XGetImage to setup error trap.
 */
static void catch_xgetimage_errors( Display *dpy )
{
   xgetimage_serial = NextRequest( dpy );
   old_xerror_handler = XSetErrorHandler( xgetimage_error_handler );
   caught_xgetimage_error = 0;
}


/*
 * Call this right after XGetImage to check if an error occured.
 */
static int check_xgetimage_errors( void )
{
   /* restore old handler */
   (void) XSetErrorHandler( old_xerror_handler );
   /* return 0=no error, 1=error caught */
   return caught_xgetimage_error;
}


/*
 * Read a pixel from an X drawable.
 */
static unsigned long read_pixel( Display *dpy, Drawable d, int x, int y )
{
   XImage *pixel;
   unsigned long p;
   int error;
   catch_xgetimage_errors( dpy );
   pixel = XGetImage( dpy, d, x, y, 1, 1, AllPlanes, ZPixmap );
   error = check_xgetimage_errors();
   if (pixel && !error) {
      p = XGetPixel( pixel, 0, 0 );
   }
   else {
      p = 0;
   }
   if (pixel) {
      XDestroyImage( pixel );
   }
   return p;
}




/*
 * Return the size (width,height of the current color buffer.
 * This function should be called by the glViewport function because
 * glViewport is often called when the window gets resized.  We need to
 * update some X/Mesa stuff when that happens.
 * Output:  width - width of buffer in pixels.
 *          height - height of buffer in pixels.
 */
static void get_buffer_size( GLcontext *ctx, GLuint *width, GLuint *height )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Window root;
   int winx, winy;
   unsigned int winwidth, winheight;
   unsigned int bw, d;

   XGetGeometry( xmesa->display, xmesa->xm_buffer->frontbuffer, &root,
		 &winx, &winy, &winwidth, &winheight, &bw, &d );

   *width = winwidth;
   *height = winheight;

   if (   winwidth!=xmesa->xm_buffer->width
       || winheight!=xmesa->xm_buffer->height) {
      xmesa->xm_buffer->width = winwidth;
      xmesa->xm_buffer->height = winheight;
      xmesa_alloc_back_buffer( xmesa->xm_buffer );
   }

   /* Needed by FLIP macro */
   xmesa->xm_buffer->bottom = (int) winheight - 1;

   if (xmesa->xm_buffer->backimage) {
      /* Needed by PIXELADDR1 macro */
      xmesa->xm_buffer->ximage_width1
                  = xmesa->xm_buffer->backimage->bytes_per_line;
      xmesa->xm_buffer->ximage_origin1
                  = (GLubyte *) xmesa->xm_buffer->backimage->data
                    + xmesa->xm_buffer->ximage_width1 * (winheight-1);

      /* Needed by PIXELADDR2 macro */
      xmesa->xm_buffer->ximage_width2
                  = xmesa->xm_buffer->backimage->bytes_per_line / 2;
      xmesa->xm_buffer->ximage_origin2
                  = (GLushort *) xmesa->xm_buffer->backimage->data
                    + xmesa->xm_buffer->ximage_width2 * (winheight-1);

      /* Needed by PIXELADDR4 macro */
      xmesa->xm_buffer->ximage_width4 = xmesa->xm_buffer->backimage->width;
      xmesa->xm_buffer->ximage_origin4
                  = (GLuint *) xmesa->xm_buffer->backimage->data
                    + xmesa->xm_buffer->ximage_width4 * (winheight-1);
   }
}


static void finish( GLcontext *ctx )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   if (xmesa) {
      XSync( xmesa->display, False );
   }
}


static void flush( GLcontext *ctx )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   if (xmesa) {
      XFlush( xmesa->display );
   }
}



static GLboolean set_buffer( GLcontext *ctx, GLenum mode )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   if (mode==GL_FRONT) {
      /* read/write front buffer */
      xmesa->xm_buffer->buffer = xmesa->xm_buffer->frontbuffer;
      ctx->NewState |= NEW_RASTER_OPS;
      gl_update_state(ctx);
      return GL_TRUE;
   }
   else if (mode==GL_BACK && xmesa->xm_buffer->db_state) {
      /* read/write back buffer */
      if (xmesa->xm_buffer->backpixmap) {
         xmesa->xm_buffer->buffer = xmesa->xm_buffer->backpixmap;
      }
      else if (xmesa->xm_buffer->backimage) {
         xmesa->xm_buffer->buffer = None;
      }
      else {
         /* just in case there wasn't enough memory for back buffer */
         xmesa->xm_buffer->buffer = xmesa->xm_buffer->frontbuffer;
      }
      ctx->NewState |= NEW_RASTER_OPS;
      gl_update_state(ctx);
      return GL_TRUE;
   }
   else {
      return GL_FALSE;
   }
}



static void clear_index( GLcontext *ctx, GLuint index )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   xmesa->clearpixel = (unsigned long) index;
   XSetForeground( xmesa->display, xmesa->xm_buffer->cleargc,
                   (unsigned long) index );
}


static void clear_color( GLcontext *ctx,
                         GLubyte r, GLubyte g, GLubyte b, GLubyte a )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   xmesa->clearcolor[0] = r;
   xmesa->clearcolor[1] = g;
   xmesa->clearcolor[2] = b;
   xmesa->clearcolor[3] = a;
   xmesa->clearpixel = xmesa_color_to_pixel( xmesa, r, g, b, a );
   XSetForeground( xmesa->display, xmesa->xm_buffer->cleargc,
                   xmesa->clearpixel );
}


static void clear_color_HPCR_ximage( GLcontext *ctx,
                         GLubyte r, GLubyte g, GLubyte b, GLubyte a )
{
   int i;
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   xmesa->clearcolor[0] = r;
   xmesa->clearcolor[1] = g;
   xmesa->clearcolor[2] = b;
   xmesa->clearcolor[3] = a;

   if (0x0==r && 0x0==g && 0x0==b)
   {
	 /* black is black */
         MEMSET( xmesa->xm_visual->hpcr_clear_ximage_pattern, 0x0 ,
		 sizeof(xmesa->xm_visual->hpcr_clear_ximage_pattern));
   }
   else {
   /* build clear pattern */
   for (i=0; i<16; i++) {
	xmesa->xm_visual->hpcr_clear_ximage_pattern[0][i]    =
		DITHER_HPCR(i, 0, r, g, b);
	xmesa->xm_visual->hpcr_clear_ximage_pattern[1][i]    =
		DITHER_HPCR(i, 1, r, g, b);
   }
   }
}


static void clear_color_HPCR_pixmap( GLcontext *ctx,
                         GLubyte r, GLubyte g, GLubyte b, GLubyte a )
{
   int i;
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   xmesa->clearcolor[0] = r;
   xmesa->clearcolor[1] = g;
   xmesa->clearcolor[2] = b;
   xmesa->clearcolor[3] = a;

 
   if (0x0==r && 0x0==g && 0x0==b)
   {
   /* black is black */
   for (i=0; i<16; i++)
   {
	XPutPixel(xmesa->xm_visual->hpcr_clear_ximage, i, 0, 0);
	XPutPixel(xmesa->xm_visual->hpcr_clear_ximage, i, 1, 0);
   }
   }
   else {
   for (i=0; i<16; i++)
   {
	XPutPixel(xmesa->xm_visual->hpcr_clear_ximage, i, 0, DITHER_HPCR(i, 0, r, g, b));
	XPutPixel(xmesa->xm_visual->hpcr_clear_ximage, i, 1, DITHER_HPCR(i, 1, r, g, b));
   }
   }
   /* change tile pixmap content */
   XPutImage(xmesa->display, 
	     xmesa->xm_visual->hpcr_clear_pixmap, 
	     xmesa->xm_buffer->cleargc, 
	     xmesa->xm_visual->hpcr_clear_ximage, 0, 0, 0, 0, 16, 2);
}

/* Set current color index */
static void set_index( GLcontext *ctx, GLuint index )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   unsigned long p = (unsigned long) index;
   xmesa->pixel = p;
   XSetForeground( xmesa->display, xmesa->xm_buffer->gc1, p );
}


/* Set current drawing color */
static void set_color( GLcontext *ctx,
                       GLubyte r, GLubyte g, GLubyte b, GLubyte a )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   xmesa->red   = r;
   xmesa->green = g;
   xmesa->blue  = b;
   xmesa->alpha = a;
   xmesa->pixel = xmesa_color_to_pixel( xmesa, r, g, b, a );;
   XSetForeground( xmesa->display, xmesa->xm_buffer->gc1, xmesa->pixel );
}



/* Set index mask ala glIndexMask */
static GLboolean index_mask( GLcontext *ctx, GLuint mask )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   if (xmesa->xm_buffer->buffer==XIMAGE) {
      return GL_FALSE;
   }
   else {
      unsigned long m;
      if (mask==0xffffffff) {
         m = AllPlanes;
      }
      else {
         m = (unsigned long) mask;
      }
      XSetPlaneMask( xmesa->display, xmesa->xm_buffer->gc1, m );
      XSetPlaneMask( xmesa->display, xmesa->xm_buffer->gc2, m );
      XSetPlaneMask( xmesa->display, xmesa->xm_buffer->cleargc, m );
      return GL_TRUE;
   }
}


/* Implements glColorMask() */
static GLboolean color_mask( GLcontext *ctx,
                             GLboolean rmask, GLboolean gmask,
                             GLboolean bmask, GLboolean amask )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
#if defined(__cplusplus) || defined(c_plusplus)
   int xclass = xmesa->xm_visual->visinfo->c_class;
#else
   int xclass = xmesa->xm_visual->visinfo->class;
#endif
   (void) amask;

   if (xmesa->xm_buffer->buffer!=XIMAGE
       && (xclass==TrueColor || xclass==DirectColor)) {
      unsigned long m;
      if (rmask && gmask && bmask) {
         m = AllPlanes;
      }
      else {
         m = 0;
         if (rmask)   m |= xmesa->xm_visual->visinfo->red_mask;
         if (gmask)   m |= xmesa->xm_visual->visinfo->green_mask;
         if (bmask)   m |= xmesa->xm_visual->visinfo->blue_mask;
      }
      XSetPlaneMask( xmesa->display, xmesa->xm_buffer->gc1, m );
      XSetPlaneMask( xmesa->display, xmesa->xm_buffer->gc2, m );
      XSetPlaneMask( xmesa->display, xmesa->xm_buffer->cleargc, m );
      return GL_TRUE;
   }
   else {
      return GL_FALSE;
   }
}


/*
 * Set the pixel logic operation.  Return GL_TRUE if the device driver
 * can perform the operation, otherwise return GL_FALSE.  GL_COPY _must_
 * be operational, obviously.
 */
static GLboolean logicop( GLcontext *ctx, GLenum op )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   int func;
   if ((xmesa->xm_buffer->buffer==XIMAGE) && op!=GL_COPY) {
      /* X can't do logic ops in Ximages, except for GL_COPY */
      return GL_FALSE;
   }
   switch (op) {
      case GL_CLEAR:		func = GXclear;		break;
      case GL_SET:		func = GXset;		break;
      case GL_COPY:		func = GXcopy;		break;
      case GL_COPY_INVERTED:	func = GXcopyInverted;	break;
      case GL_NOOP:		func = GXnoop;		break;
      case GL_INVERT:		func = GXinvert;	break;
      case GL_AND:		func = GXand;		break;
      case GL_NAND:		func = GXnand;		break;
      case GL_OR:		func = GXor;		break;
      case GL_NOR:		func = GXnor;		break;
      case GL_XOR:		func = GXxor;		break;
      case GL_EQUIV:		func = GXequiv;		break;
      case GL_AND_REVERSE:	func = GXandReverse;	break;
      case GL_AND_INVERTED:	func = GXandInverted;	break;
      case GL_OR_REVERSE:	func = GXorReverse;	break;
      case GL_OR_INVERTED:	func = GXorInverted;	break;
      default:  return GL_FALSE;
   }
   XSetFunction( xmesa->display, xmesa->xm_buffer->gc1, func );
   XSetFunction( xmesa->display, xmesa->xm_buffer->gc2, func );
   return GL_TRUE;
}


/*
 * Enable/disable dithering
 */
static void dither( GLcontext *ctx, GLboolean enable )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   if (enable) {
      xmesa->pixelformat = xmesa->xm_visual->dithered_pf;
   }
   else {
      xmesa->pixelformat = xmesa->xm_visual->undithered_pf;
   }
}



/**********************************************************************/
/*** glClear implementations                                        ***/
/**********************************************************************/

static GLbitfield clear_pixmap( GLcontext *ctx, GLbitfield mask, GLboolean all,
                                GLint x, GLint y, GLint width, GLint height )
{
   if (mask & GL_COLOR_BUFFER_BIT) {
      const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
      if (all) {
         XFillRectangle( xmesa->display, xmesa->xm_buffer->buffer,
                         xmesa->xm_buffer->cleargc,
                         0, 0,
                         xmesa->xm_buffer->width+1,
                         xmesa->xm_buffer->height+1 );
      }
      else {
         XFillRectangle( xmesa->display, xmesa->xm_buffer->buffer,
                         xmesa->xm_buffer->cleargc,
                         x, xmesa->xm_buffer->height - y - height,
                         width, height );
      }
   }
   return mask & (~GL_COLOR_BUFFER_BIT);
}


static GLbitfield clear_8bit_ximage( GLcontext *ctx, GLbitfield mask,
                                     GLboolean all, GLint x, GLint y,
                                     GLint width, GLint height )
{
   if (mask & GL_COLOR_BUFFER_BIT) {
      const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
      if (all) {
         size_t n = xmesa->xm_buffer->backimage->bytes_per_line
                  * xmesa->xm_buffer->backimage->height;
         MEMSET( xmesa->xm_buffer->backimage->data, xmesa->clearpixel, n );
      }
      else {
         GLint i;
         for (i=0;i<height;i++) {
            GLubyte *ptr = PIXELADDR1( x, y+i );
            MEMSET( ptr, xmesa->clearpixel, width );
         }
      }
   }
   return mask & (~GL_COLOR_BUFFER_BIT);
}


static GLbitfield clear_HPCR_ximage( GLcontext *ctx, GLbitfield mask,
                                     GLboolean all, GLint x, GLint y,
                                     GLint width, GLint height )
{
   if (mask & GL_COLOR_BUFFER_BIT) {
      const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
      if (all) {
         GLint i, c16 = (xmesa->xm_buffer->backimage->bytes_per_line>>4)<<4;
	 GLubyte *ptr  = (GLubyte *)xmesa->xm_buffer->backimage->data;
	 for (i=0; i<xmesa->xm_buffer->backimage->height; i++) {
	    GLint j;
	    GLubyte *sptr = xmesa->xm_visual->hpcr_clear_ximage_pattern[0];
	    if (i&1) {
		sptr += 16;
	    }
	    for (j=0; j<c16; j+=16) {
		ptr[0] = sptr[0];
		ptr[1] = sptr[1];
		ptr[2] = sptr[2];
		ptr[3] = sptr[3];
		ptr[4] = sptr[4];
		ptr[5] = sptr[5];
		ptr[6] = sptr[6];
		ptr[7] = sptr[7];
		ptr[8] = sptr[8];
		ptr[9] = sptr[9];
		ptr[10] = sptr[10];
		ptr[11] = sptr[11];
		ptr[12] = sptr[12];
		ptr[13] = sptr[13];
		ptr[14] = sptr[14];
		ptr[15] = sptr[15];
		ptr += 16;
	    }
	    for (; j<xmesa->xm_buffer->backimage->bytes_per_line; j++) {
		*ptr = sptr[j&15];
		ptr++;
	    }
	 }
      }
      else {
         GLint i;
         for (i=y; i<y+height; i++) {
            GLubyte *ptr = PIXELADDR1( x, i );
	    int j;
	    GLubyte *sptr = xmesa->xm_visual->hpcr_clear_ximage_pattern[0];
	    if (i&1) {
		sptr += 16;
	    }
	    for (j=x; j<x+width; j++) {
		*ptr = sptr[j&15];
		ptr++;
	    }
         }
      }
   }
   return mask & (~GL_COLOR_BUFFER_BIT);
}


static GLbitfield clear_16bit_ximage( GLcontext *ctx, GLbitfield mask,
                                      GLboolean all, GLint x, GLint y,
                                      GLint width, GLint height )
{
   if (mask & GL_COLOR_BUFFER_BIT) {
      const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
      if (all) {
         register GLuint n;
         register GLushort *ptr2 =(GLushort *) xmesa->xm_buffer->backimage->data;
         register GLushort pixel = (GLushort) xmesa->clearpixel;
         if (xmesa->swapbytes) {
            pixel = ((pixel >> 8) & 0x00ff)
                  | ((pixel << 8) & 0xff00);
         }
         if ((pixel & 0xff) == (pixel >> 8)) {
            /* low and high bytes are equal so use memset() */
            n = xmesa->xm_buffer->backimage->bytes_per_line
                * xmesa->xm_buffer->height;
            MEMSET( ptr2, pixel & 0xff, n );
         }
         else {
            n = xmesa->xm_buffer->backimage->bytes_per_line / 2
                * xmesa->xm_buffer->height;
            do {
               *ptr2++ = pixel;
               n--;
            } while (n!=0);
         }
      }
      else {
         register int i, j;
         register GLushort pixel = (GLushort) xmesa->clearpixel;
         for (j=0;j<height;j++) {
            register GLushort *ptr2 = PIXELADDR2( x, y+j );
            for (i=0;i<width;i++) {
               *ptr2++ = pixel;
            }
         }
      }
   }
   return mask & (~GL_COLOR_BUFFER_BIT);
}


static GLbitfield clear_32bit_ximage( GLcontext *ctx, GLbitfield mask,
                                      GLboolean all, GLint x, GLint y,
                                      GLint width, GLint height )
{
   if (mask & GL_COLOR_BUFFER_BIT) {
      const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
      if (all) {
         register GLint n = xmesa->xm_buffer->width * xmesa->xm_buffer->height;
         register GLuint *ptr4 = (GLuint *) xmesa->xm_buffer->backimage->data;
         register GLuint pixel = (GLuint) xmesa->clearpixel;
         if (xmesa->swapbytes) {
            pixel = ((pixel >> 24) & 0x000000ff)
                  | ((pixel >> 8)  & 0x0000ff00)
                  | ((pixel << 8)  & 0x00ff0000)
                  | ((pixel << 24) & 0xff000000);
         }
         if (pixel==0) {
            MEMSET( ptr4, pixel, 4*n );
         }
         else {
            do {
               *ptr4++ = pixel;
               n--;
            } while (n!=0);
         }
      }
      else {
         register int i, j;
         register GLuint pixel = (GLuint) xmesa->clearpixel;
         for (j=0;j<height;j++) {
            register GLuint *ptr4 = PIXELADDR4( x, y+j );
            for (i=0;i<width;i++) {
               *ptr4++ = pixel;
            }
         }
      }
   }
   return mask & (~GL_COLOR_BUFFER_BIT);
}


static GLbitfield clear_nbit_ximage( GLcontext *ctx, GLbitfield mask,
                                     GLboolean all, GLint x, GLint y,
                                     GLint width, GLint height )
{
   if (mask & GL_COLOR_BUFFER_BIT) {
      const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
      XImage *img = xmesa->xm_buffer->backimage;
      if (all) {
         register int i, j;
         width = xmesa->xm_buffer->width;
         height = xmesa->xm_buffer->height;
         for (j=0;j<height;j++) {
            for (i=0;i<width;i++) {
               XPutPixel( img, i, j, xmesa->clearpixel );
            }
         }
      }
      else {
         /* TODO: optimize this */
         register int i, j;
         y = FLIP(y);
         for (j=0;j<height;j++) {
            for (i=0;i<width;i++) {
               XPutPixel( img, x+i, y-j, xmesa->clearpixel );
            }
         }
      }
   }
   return mask & (~GL_COLOR_BUFFER_BIT);
}




/*
 * The Mesa library needs to be able to draw pixels in a number of ways:
 *   1. RGB vs Color Index
 *   2. as horizontal spans (polygons, images) vs random locations (points,
 *      lines)
 *   3. different color per-pixel or same color for all pixels
 *
 * Furthermore, the X driver needs to support rendering to 3 possible
 * "buffers", usually one, but sometimes two at a time:
 *   1. The front buffer as an X window
 *   2. The back buffer as a Pixmap
 *   3. The back buffer as an XImage
 *
 * Finally, if the back buffer is an XImage, we can avoid using XPutPixel and
 * optimize common cases such as 24-bit and 8-bit modes.
 *
 * By multiplication, there's at least 48 possible combinations of the above.
 *
 * Below are implementations of the most commonly used combinations.  They are
 * accessed through function pointers which get initialized here and are used
 * directly from the Mesa library.  The 8 function pointers directly correspond
 * to the first 3 cases listed above.
 *
 *
 * The function naming convention is:
 *
 *   write_[span|pixels]_[mono]_[format]_[pixmap|ximage]
 *
 * New functions optimized for specific cases can be added without too much
 * trouble.  An example might be the 24-bit TrueColor mode 8A8R8G8B which is
 * found on IBM RS/6000 X servers.
 */




/**********************************************************************/
/*** Write COLOR SPAN functions                                     ***/
/**********************************************************************/


#define RGBA_SPAN_ARGS	const GLcontext *ctx,				\
			GLuint n, GLint x, GLint y,			\
			CONST GLubyte rgba[][4], const GLubyte mask[]

#define RGB_SPAN_ARGS	const GLcontext *ctx,				\
			GLuint n, GLint x, GLint y,			\
			CONST GLubyte rgb[][3], const GLubyte mask[]


/* NOTE: if mask==NULL, draw all pixels */


/*
 * Write a span of PF_TRUECOLOR pixels to a pixmap.
 */
static void write_span_TRUECOLOR_pixmap( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            unsigned long p;
            PACK_TRUECOLOR( p, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
            XSetForeground( dpy, gc, p );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      /* draw all pixels */
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      for (i=0;i<n;i++) {
         unsigned long p;
         PACK_TRUECOLOR( p, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
         XPutPixel( rowimg, i, 0, p );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_TRUECOLOR pixels to a pixmap.
 */
static void write_span_rgb_TRUECOLOR_pixmap( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            unsigned long p;
            PACK_TRUECOLOR( p, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
            XSetForeground( dpy, gc, p );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      /* draw all pixels */
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      for (i=0;i<n;i++) {
         unsigned long p;
         PACK_TRUECOLOR( p, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
         XPutPixel( rowimg, i, 0, p );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_TRUEDITHER pixels to a pixmap.
 */
static void write_span_TRUEDITHER_pixmap( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            unsigned long p;
            PACK_TRUEDITHER(p, x, y, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP]);
            XSetForeground( dpy, gc, p );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      for (i=0;i<n;i++) {
         unsigned long p;
         PACK_TRUEDITHER(p, x+i, y, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP]);
         XPutPixel( rowimg, i, 0, p );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_TRUEDITHER pixels to a pixmap (no alpha).
 */
static void write_span_rgb_TRUEDITHER_pixmap( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            unsigned long p;
            PACK_TRUEDITHER(p, x, y, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]);
            XSetForeground( dpy, gc, p );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      for (i=0;i<n;i++) {
         unsigned long p;
         PACK_TRUEDITHER(p, x+i, y, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]);
         XPutPixel( rowimg, i, 0, p );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}



/*
 * Write a span of PF_8A8B8G8R pixels to a pixmap.
 */
static void write_span_8A8B8G8R_pixmap( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc,
                         PACK_8A8B8G8R(rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP], rgba[i][ACOMP]) );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      /* draw all pixels */
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      register GLuint *ptr4 = (GLuint *) rowimg->data;
      for (i=0;i<n;i++) {
         *ptr4++ = PACK_8A8B8G8R( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP], rgba[i][ACOMP] );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_8A8B8G8R pixels to a pixmap (no alpha).
 */
static void write_span_rgb_8A8B8G8R_pixmap( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc,
                   PACK_8B8G8R(rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]) );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      /* draw all pixels */
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      register GLuint *ptr4 = (GLuint *) rowimg->data;
      for (i=0;i<n;i++) {
         *ptr4++ = PACK_8B8G8R(rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]);
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_8R8G8B pixels to a pixmap.
 */
static void write_span_8R8G8B_pixmap( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc, PACK_8R8G8B( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ));
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      /* draw all pixels */
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      register GLuint *ptr4 = (GLuint *) rowimg->data;
      for (i=0;i<n;i++) {
         *ptr4++ = PACK_8R8G8B( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_8R8G8B pixels to a pixmap (no alpha).
 */
static void write_span_rgb_8R8G8B_pixmap( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc, PACK_8R8G8B( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] ));
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      /* draw all pixels */
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      register GLuint *ptr4 = (GLuint *) rowimg->data;
      for (i=0;i<n;i++) {
         *ptr4++ = PACK_8R8G8B( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_5R6G5B pixels to a pixmap.
 */
static void write_span_5R6G5B_pixmap( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc, PACK_5R6G5B( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ));
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      /* draw all pixels */
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      register GLushort *ptr2 = (GLushort *) rowimg->data;
      for (i=0;i<n;i++) {
         ptr2[i] = PACK_5R6G5B( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_5R6G5B pixels to a pixmap (no alpha).
 */
static void write_span_rgb_5R6G5B_pixmap( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc, PACK_5R6G5B( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] ));
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      /* draw all pixels */
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      register GLushort *ptr2 = (GLushort *) rowimg->data;
      for (i=0;i<n;i++) {
         ptr2[i] = PACK_5R6G5B( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_DITHER pixels to a pixmap.
 */
static void write_span_DITHER_pixmap( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   XDITHER_SETUP(y);
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc, XDITHER(x, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP]) );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      /* draw all pixels */
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      for (i=0;i<n;i++) {
         XPutPixel( rowimg, i, 0, XDITHER(x+i, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP]) );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_DITHER pixels to a pixmap (no alpha).
 */
static void write_span_rgb_DITHER_pixmap( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   XDITHER_SETUP(y);
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc, XDITHER(x, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]) );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      /* draw all pixels */
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      for (i=0;i<n;i++) {
         XPutPixel( rowimg, i, 0, XDITHER(x+i, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]) );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_1BIT pixels to a pixmap.
 */
static void write_span_1BIT_pixmap( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   SETUP_1BIT;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc,
                            DITHER_1BIT( x, y, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      /* draw all pixels */
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      for (i=0;i<n;i++) {
         XPutPixel( rowimg, i, 0,
                    DITHER_1BIT( x+i, y, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_1BIT pixels to a pixmap (no alpha).
 */
static void write_span_rgb_1BIT_pixmap( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   SETUP_1BIT;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc,
              DITHER_1BIT(x, y, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]) );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      /* draw all pixels */
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      for (i=0;i<n;i++) {
         XPutPixel( rowimg, i, 0,
          DITHER_1BIT(x+i, y, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]) );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_HPCR pixels to a pixmap.
 */
static void write_span_HPCR_pixmap( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc,
                            DITHER_HPCR( x, y, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      register GLubyte *ptr = (GLubyte *) xmesa->xm_buffer->rowimage->data;
      for (i=0;i<n;i++) {
         ptr[i] = DITHER_HPCR( (x+i), y, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_HPCR pixels to a pixmap (no alpha).
 */
static void write_span_rgb_HPCR_pixmap( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc,
              DITHER_HPCR(x, y, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]) );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      register GLubyte *ptr = (GLubyte *) xmesa->xm_buffer->rowimage->data;
      for (i=0;i<n;i++) {
         ptr[i] = DITHER_HPCR( (x+i), y, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_LOOKUP pixels to a pixmap.
 */
static void write_span_LOOKUP_pixmap( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   LOOKUP_SETUP;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc, LOOKUP( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      for (i=0;i<n;i++) {
         XPutPixel( rowimg, i, 0, LOOKUP(rgba[i][RCOMP],rgba[i][GCOMP],rgba[i][BCOMP]) );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_LOOKUP pixels to a pixmap (no alpha).
 */
static void write_span_rgb_LOOKUP_pixmap( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   LOOKUP_SETUP;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc, LOOKUP( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] ) );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      for (i=0;i<n;i++) {
         XPutPixel( rowimg, i, 0, LOOKUP(rgb[i][RCOMP],rgb[i][GCOMP],rgb[i][BCOMP]) );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}



/*
 * Write a span of PF_GRAYSCALE pixels to a pixmap.
 */
static void write_span_GRAYSCALE_pixmap( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc, GRAY_RGB( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      for (i=0;i<n;i++) {
         XPutPixel( rowimg, i, 0, GRAY_RGB(rgba[i][RCOMP],rgba[i][GCOMP],rgba[i][BCOMP]) );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_GRAYSCALE pixels to a pixmap (no alpha).
 */
static void write_span_rgb_GRAYSCALE_pixmap( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP( y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XSetForeground( dpy, gc, GRAY_RGB( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] ) );
            XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
         }
      }
   }
   else {
      XImage *rowimg = xmesa->xm_buffer->rowimage;
      for (i=0;i<n;i++) {
         XPutPixel( rowimg, i, 0, GRAY_RGB(rgb[i][RCOMP],rgb[i][GCOMP],rgb[i][BCOMP]) );
      }
      XPutImage( dpy, buffer, gc, rowimg, 0, 0, x, y, n, 1 );
   }
}


/*
 * Write a span of PF_TRUECOLOR pixels to an XImage.
 */
static void write_span_TRUECOLOR_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   y = FLIP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            unsigned long p;
            PACK_TRUECOLOR( p, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
            XPutPixel( img, x, y, p );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         unsigned long p;
         PACK_TRUECOLOR( p, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
         XPutPixel( img, x, y, p );
      }
   }
}


/*
 * Write a span of PF_TRUECOLOR pixels to an XImage (no alpha).
 */
static void write_span_rgb_TRUECOLOR_ximage( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   y = FLIP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            unsigned long p;
            PACK_TRUECOLOR( p, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
            XPutPixel( img, x, y, p );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         unsigned long p;
         PACK_TRUECOLOR( p, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
         XPutPixel( img, x, y, p );
      }
   }
}


/*
 * Write a span of PF_TRUEDITHER pixels to an XImage.
 */
static void write_span_TRUEDITHER_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   y = FLIP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            unsigned long p;
            PACK_TRUEDITHER(p, x, y, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP]);
            XPutPixel( img, x, y, p );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         unsigned long p;
         PACK_TRUEDITHER(p, x, y, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP]);
         XPutPixel( img, x, y, p );
      }
   }
}


/*
 * Write a span of PF_TRUEDITHER pixels to an XImage (no alpha).
 */
static void write_span_rgb_TRUEDITHER_ximage( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   y = FLIP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            unsigned long p;
            PACK_TRUEDITHER(p, x, y, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]);
            XPutPixel( img, x, y, p );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         unsigned long p;
         PACK_TRUEDITHER(p, x, y, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]);
         XPutPixel( img, x, y, p );
      }
   }
}


/*
 * Write a span of PF_8A8B8G8R-format pixels to an ximage.
 */
static void write_span_8A8B8G8R_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLuint *ptr = PIXELADDR4( x, y );
   if (mask) {
      for (i=0;i<n;i++) {
         if (mask[i]) {
            ptr[i] = PACK_8A8B8G8R( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP], rgba[i][ACOMP] );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++) {
         ptr[i] = PACK_8A8B8G8R( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP], rgba[i][ACOMP] );
      }
   }
}


/*
 * Write a span of PF_8A8B8G8R-format pixels to an ximage (no alpha).
 */
static void write_span_rgb_8A8B8G8R_ximage( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLuint *ptr = PIXELADDR4( x, y );
   if (mask) {
      for (i=0;i<n;i++) {
         if (mask[i]) {
            ptr[i] = PACK_8A8B8G8R( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP], 255 );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++) {
         ptr[i] = PACK_8A8B8G8R( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP], 255 );
      }
   }
}


/*
 * Write a span of PF_8R8G8B-format pixels to an ximage.
 */
static void write_span_8R8G8B_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = (GLubyte *) PIXELADDR4( x, y );
   if (mask) {
      for (i=0;i<n;i++) {
         if (mask[i]) {
            *ptr++ = rgba[i][BCOMP];
            *ptr++ = rgba[i][GCOMP];
            *ptr++ = rgba[i][RCOMP];
            ptr++;
         }
         else {
            ptr += 4;
         }
      }
   }
   else {
      for (i=0;i<n;i++) {
         *ptr++ = rgba[i][BCOMP];
         *ptr++ = rgba[i][GCOMP];
         *ptr++ = rgba[i][RCOMP];
         ptr++;
      }
   }
}


/*
 * Write a span of PF_8R8G8B-format pixels to an ximage (no alpha).
 */
static void write_span_rgb_8R8G8B_ximage( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = (GLubyte *) PIXELADDR4( x, y );
   if (mask) {
      for (i=0;i<n;i++) {
         if (mask[i]) {
            *ptr++ = rgb[i][BCOMP];
            *ptr++ = rgb[i][GCOMP];
            *ptr++ = rgb[i][RCOMP];
            ptr++;
         }
         else {
            ptr += 4;
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++) {
         *ptr++ = rgb[i][BCOMP];
         *ptr++ = rgb[i][GCOMP];
         *ptr++ = rgb[i][RCOMP];
         ptr++;
      }
   }
}


/*
 * Write a span of PF_5R6G5B-format pixels to an ximage.
 */
static void write_span_5R6G5B_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLushort *ptr = PIXELADDR2( x, y );
   if (mask) {
      for (i=0;i<n;i++) {
         if (mask[i]) {
            ptr[i] = PACK_5R6G5B( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++) {
         ptr[i] = PACK_5R6G5B( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
   }
}


/*
 * Write a span of PF_5R6G5B-format pixels to an ximage (no alpha).
 */
static void write_span_rgb_5R6G5B_ximage( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLushort *ptr = PIXELADDR2( x, y );
   if (mask) {
      for (i=0;i<n;i++) {
         if (mask[i]) {
            ptr[i] = PACK_5R6G5B( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++) {
         ptr[i] = PACK_5R6G5B( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
      }
   }
}


/*
 * Write a span of PF_DITHER pixels to an XImage.
 */
static void write_span_DITHER_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   int yy = FLIP(y);
   XDITHER_SETUP(yy);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XPutPixel( img, x, yy, XDITHER( x, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         XPutPixel( img, x, yy, XDITHER( x, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
      }
   }
}


/*
 * Write a span of PF_DITHER pixels to an XImage (no alpha).
 */
static void write_span_rgb_DITHER_ximage( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   int yy = FLIP(y);
   XDITHER_SETUP(yy);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XPutPixel( img, x, yy, XDITHER( x, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] ) );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         XPutPixel( img, x, yy, XDITHER( x, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] ) );
      }
   }
}



/*
 * Write a span of 8-bit PF_DITHER pixels to an XImage.
 */
static void write_span_DITHER8_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = PIXELADDR1( x, y );
   XDITHER_SETUP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            ptr[i] = XDITHER( x, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
         }
      }
   }
   else {
      for (i=0;i<n;i++,x++) {
         ptr[i] = XDITHER( x, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
   }
}


static void write_span_rgb_DITHER8_ximage( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = PIXELADDR1( x, y );
   XDITHER_SETUP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            ptr[i] = XDITHER( x, rgb[i][0], rgb[i][1], rgb[i][2] );
         }
      }
   }
   else {
      const GLubyte *data = (GLubyte *) rgb;
      for (i=0;i<n;i++,x++) {
         /*ptr[i] = XDITHER( x, rgb[i][0], rgb[i][1], rgb[i][2] );*/
         ptr[i] = XDITHER( x, data[i+i+i], data[i+i+i+1], data[i+i+i+2] );
      }
   }
}



/*
 * Write a span of PF_1BIT pixels to an XImage.
 */
static void write_span_1BIT_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   SETUP_1BIT;
   y = FLIP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XPutPixel(img, x, y, DITHER_1BIT(x, y, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP]));
         }
      }
   }
   else {
      for (i=0;i<n;i++,x++) {
         XPutPixel( img, x, y, DITHER_1BIT(x, y, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP]) );
      }
   }
}


/*
 * Write a span of PF_1BIT pixels to an XImage (no alpha).
 */
static void write_span_rgb_1BIT_ximage( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   SETUP_1BIT;
   y = FLIP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XPutPixel(img, x, y, DITHER_1BIT(x, y, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]));
         }
      }
   }
   else {
      for (i=0;i<n;i++,x++) {
         XPutPixel( img, x, y, DITHER_1BIT(x, y, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP]) );
      }
   }
}


/*
 * Write a span of PF_HPCR pixels to an XImage.
 */
static void write_span_HPCR_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = PIXELADDR1( x, y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            ptr[i] = DITHER_HPCR( x, y, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         ptr[i] = DITHER_HPCR( x, y, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
   }
}


/*
 * Write a span of PF_HPCR pixels to an XImage (no alpha).
 */
static void write_span_rgb_HPCR_ximage( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = PIXELADDR1( x, y );
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            ptr[i] = DITHER_HPCR( x, y, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         ptr[i] = DITHER_HPCR( x, y, rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
      }
   }
}


/*
 * Write a span of PF_LOOKUP pixels to an XImage.
 */
static void write_span_LOOKUP_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   LOOKUP_SETUP;
   y = FLIP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XPutPixel( img, x, y, LOOKUP( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         XPutPixel( img, x, y, LOOKUP( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
      }
   }
}


/*
 * Write a span of PF_LOOKUP pixels to an XImage (no alpha).
 */
static void write_span_rgb_LOOKUP_ximage( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   LOOKUP_SETUP;
   y = FLIP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XPutPixel( img, x, y, LOOKUP( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] ) );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         XPutPixel( img, x, y, LOOKUP( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] ) );
      }
   }
}


/*
 * Write a span of 8-bit PF_LOOKUP pixels to an XImage.
 */
static void write_span_LOOKUP8_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = PIXELADDR1( x, y );
   LOOKUP_SETUP;
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            ptr[i] = LOOKUP( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         ptr[i] = LOOKUP( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
   }
}


static void write_rgb_LOOKUP8_ximage( const GLcontext *ctx,
                                      GLuint n, GLint x, GLint y,
                                      CONST GLubyte rgb[][3],
                                      const GLubyte mask[] )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = PIXELADDR1( x, y );
   LOOKUP_SETUP;
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            ptr[i] = LOOKUP( rgb[i][0], rgb[i][1], rgb[i][2] );
         }
      }
   }
   else {
      /* draw all pixels */
      const GLubyte *data = (GLubyte *) rgb;
      for (i=0;i<n;i++,x++) {
         /*ptr[i] = LOOKUP( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );*/
         ptr[i] = LOOKUP( data[i+i+i], data[i+i+i+1], data[i+i+i+2] );
      }
   }
}


/*
 * Write a span of PF_GRAYSCALE pixels to an XImage.
 */
static void write_span_GRAYSCALE_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   y = FLIP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XPutPixel( img, x, y, GRAY_RGB( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         XPutPixel( img, x, y, GRAY_RGB( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
      }
   }
}


/*
 * Write a span of PF_GRAYSCALE pixels to an XImage (no alpha).
 */
static void write_span_rgb_GRAYSCALE_ximage( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   y = FLIP(y);
   if (mask) {
      for (i=0;i<n;i++,x++) {
         if (mask[i]) {
            XPutPixel( img, x, y, GRAY_RGB( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] ) );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++,x++) {
         XPutPixel( img, x, y, GRAY_RGB( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] ) );
      }
   }
}


/*
 * Write a span of 8-bit PF_GRAYSCALE pixels to an XImage.
 */
static void write_span_GRAYSCALE8_ximage( RGBA_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = PIXELADDR1( x, y );
   if (mask) {
      for (i=0;i<n;i++) {
         if (mask[i]) {
            ptr[i] = GRAY_RGB( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++) {
         ptr[i] = GRAY_RGB( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
   }
}


/*
 * Write a span of 8-bit PF_GRAYSCALE pixels to an XImage (no alpha).
 */
static void write_span_rgb_GRAYSCALE8_ximage( RGB_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = PIXELADDR1( x, y );
   if (mask) {
      for (i=0;i<n;i++) {
         if (mask[i]) {
            ptr[i] = GRAY_RGB( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
         }
      }
   }
   else {
      /* draw all pixels */
      for (i=0;i<n;i++) {
         ptr[i] = GRAY_RGB( rgb[i][RCOMP], rgb[i][GCOMP], rgb[i][BCOMP] );
      }
   }
}




/**********************************************************************/
/*** Write COLOR PIXEL functions                                    ***/
/**********************************************************************/


#define RGBA_PIXEL_ARGS   const GLcontext *ctx,				\
			  GLuint n, const GLint x[], const GLint y[],	\
			  CONST GLubyte rgba[][4], const GLubyte mask[]


/*
 * Write an array of PF_TRUECOLOR pixels to a pixmap.
 */
static void write_pixels_TRUECOLOR_pixmap( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         unsigned long p;
         PACK_TRUECOLOR( p, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
	 XSetForeground( dpy, gc, p );
	 XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_TRUEDITHER pixels to a pixmap.
 */
static void write_pixels_TRUEDITHER_pixmap( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         unsigned long p;
         PACK_TRUEDITHER(p, x[i], y[i], rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP]);
         XSetForeground( dpy, gc, p );
         XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_8A8B8G8R pixels to a pixmap.
 */
static void write_pixels_8A8B8G8R_pixmap( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XSetForeground( dpy, gc,
                         PACK_8A8B8G8R( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP], rgba[i][ACOMP] ));
	 XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_8R8G8B pixels to a pixmap.
 */
static void write_pixels_8R8G8B_pixmap( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XSetForeground( dpy, gc, PACK_8R8G8B( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
	 XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_5R6G5B pixels to a pixmap.
 */
static void write_pixels_5R6G5B_pixmap( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XSetForeground( dpy, gc, PACK_5R6G5B( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
	 XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_DITHER pixels to a pixmap.
 */
static void write_pixels_DITHER_pixmap( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   DITHER_SETUP;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XSetForeground( dpy, gc,
                         DITHER(x[i], y[i], rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP]) );
	 XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_1BIT pixels to a pixmap.
 */
static void write_pixels_1BIT_pixmap( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   SETUP_1BIT;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XSetForeground( dpy, gc,
                         DITHER_1BIT( x[i], y[i], rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ));
	 XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_HPCR pixels to a pixmap.
 */
static void write_pixels_HPCR_pixmap( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         XSetForeground( dpy, gc,
                         DITHER_HPCR( x[i], y[i], rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ));
         XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_LOOKUP pixels to a pixmap.
 */
static void write_pixels_LOOKUP_pixmap( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   LOOKUP_SETUP;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         XSetForeground( dpy, gc, LOOKUP( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
         XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_GRAYSCALE pixels to a pixmap.
 */
static void write_pixels_GRAYSCALE_pixmap( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         XSetForeground( dpy, gc, GRAY_RGB( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
         XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_TRUECOLOR pixels to an ximage.
 */
static void write_pixels_TRUECOLOR_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         unsigned long p;
         PACK_TRUECOLOR( p, rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
	 XPutPixel( img, x[i], FLIP(y[i]), p );
      }
   }
}


/*
 * Write an array of PF_TRUEDITHER pixels to an XImage.
 */
static void write_pixels_TRUEDITHER_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         unsigned long p;
         PACK_TRUEDITHER(p, x[i], FLIP(y[i]), rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP]);
	 XPutPixel( img, x[i], FLIP(y[i]), p );
      }
   }
}


/*
 * Write an array of PF_8A8B8G8R pixels to an ximage.
 */
static void write_pixels_8A8B8G8R_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 GLuint *ptr = PIXELADDR4( x[i], y[i] );
         *ptr = PACK_8A8B8G8R( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP], rgba[i][ACOMP] );
      }
   }
}


/*
 * Write an array of PF_8R8G8B pixels to an ximage.
 */
static void write_pixels_8R8G8B_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 GLuint *ptr = PIXELADDR4( x[i], y[i] );
         *ptr = PACK_8R8G8B( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
   }
}


/*
 * Write an array of PF_5R6G5B pixels to an ximage.
 */
static void write_pixels_5R6G5B_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 GLushort *ptr = PIXELADDR2( x[i], y[i] );
         *ptr = PACK_5R6G5B( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
   }
}


/*
 * Write an array of PF_DITHER pixels to an XImage.
 */
static void write_pixels_DITHER_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   DITHER_SETUP;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XPutPixel( img, x[i], FLIP(y[i]),
                    DITHER( x[i], y[i], rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
      }
   }
}


/*
 * Write an array of 8-bit PF_DITHER pixels to an XImage.
 */
static void write_pixels_DITHER8_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   DITHER_SETUP;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 GLubyte *ptr = PIXELADDR1(x[i],y[i]);
	 *ptr = DITHER( x[i], y[i], rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
   }
}


/*
 * Write an array of PF_1BIT pixels to an XImage.
 */
static void write_pixels_1BIT_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   SETUP_1BIT;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XPutPixel( img, x[i], FLIP(y[i]),
                    DITHER_1BIT( x[i], y[i], rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ));
      }
   }
}


/*
 * Write an array of PF_HPCR pixels to an XImage.
 */
static void write_pixels_HPCR_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         GLubyte *ptr = PIXELADDR1(x[i],y[i]);
         *ptr = DITHER_HPCR( x[i], y[i], rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
   }
}


/*
 * Write an array of PF_LOOKUP pixels to an XImage.
 */
static void write_pixels_LOOKUP_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   LOOKUP_SETUP;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XPutPixel( img, x[i], FLIP(y[i]), LOOKUP(rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP]) );
      }
   }
}


/*
 * Write an array of 8-bit PF_LOOKUP pixels to an XImage.
 */
static void write_pixels_LOOKUP8_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   LOOKUP_SETUP;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 GLubyte *ptr = PIXELADDR1(x[i],y[i]);
	 *ptr = LOOKUP( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
   }
}


/*
 * Write an array of PF_GRAYSCALE pixels to an XImage.
 */
static void write_pixels_GRAYSCALE_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XPutPixel( img, x[i], FLIP(y[i]),
                    GRAY_RGB( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] ) );
      }
   }
}


/*
 * Write an array of 8-bit PF_GRAYSCALE pixels to an XImage.
 */
static void write_pixels_GRAYSCALE8_ximage( RGBA_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 GLubyte *ptr = PIXELADDR1( x[i], y[i] );
	 *ptr = GRAY_RGB( rgba[i][RCOMP], rgba[i][GCOMP], rgba[i][BCOMP] );
      }
   }
}




/**********************************************************************/
/*** Write MONO COLOR SPAN functions                                ***/
/**********************************************************************/

#define MONO_SPAN_ARGS	const GLcontext *ctx,	\
		 	GLuint n, GLint x, GLint y, const GLubyte mask[]


/*
 * Write a span of identical pixels to a pixmap.  The pixel value is
 * the one set by DD.color() or DD.index().
 */
static void write_span_mono_pixmap( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc1;
   register GLuint i;
   register GLboolean write_all;
   y = FLIP( y );
   write_all = GL_TRUE;
   for (i=0;i<n;i++) {
      if (!mask[i]) {
	 write_all = GL_FALSE;
	 break;
      }
   }
   if (write_all) {
      XFillRectangle( dpy, buffer, gc, (int) x, (int) y, n, 1 );
   }
   else {
      for (i=0;i<n;i++,x++) {
	 if (mask[i]) {
	    XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
	 }
      }
   }
}


/*
 * Write a span of PF_TRUEDITHER pixels to a pixmap.  The pixel value is
 * the one set by DD.color() or DD.index().
 */
static void write_span_mono_TRUEDITHER_pixmap( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   register GLubyte r, g, b;
   int yy = FLIP( y );
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   for (i=0;i<n;i++,x++) {
      if (mask[i]) {
         unsigned long p;
         PACK_TRUEDITHER(p, x, yy, r, g, b);
         XSetForeground( dpy, gc, p );
         XDrawPoint( dpy, buffer, gc, (int) x, (int) yy );
      }
   }
}


/*
 * Write a span of PF_DITHER pixels to a pixmap.  The pixel value is
 * the one set by DD.color() or DD.index().
 */
static void write_span_mono_DITHER_pixmap( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   register GLubyte r, g, b;
   int yy = FLIP( y );
   XDITHER_SETUP(yy);
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   for (i=0;i<n;i++,x++) {
      if (mask[i]) {
         XSetForeground( dpy, gc, XDITHER( x, r, g, b ) );
         XDrawPoint( dpy, buffer, gc, (int) x, (int) yy );
      }
   }
}


/*
 * Write a span of PF_1BIT pixels to a pixmap.  The pixel value is
 * the one set by DD.color() or DD.index().
 */
static void write_span_mono_1BIT_pixmap( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   register GLubyte r, g, b;
   SETUP_1BIT;
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   y = FLIP( y );
   for (i=0;i<n;i++,x++) {
      if (mask[i]) {
         XSetForeground( dpy, gc, DITHER_1BIT( x, y, r, g, b ) );
         XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
      }
   }
}


/*
 * Write a span of identical pixels to an XImage.  The pixel value is
 * the one set by DD.color() or DD.index().
 */
static void write_span_mono_ximage( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   register unsigned long p = xmesa->pixel;
   y = FLIP( y );
   for (i=0;i<n;i++,x++) {
      if (mask[i]) {
	 XPutPixel( img, x, y, p );
      }
   }
}


/*
 * Write a span of identical PF_TRUEDITHER pixels to an XImage.  The pixel
 * value is the one set by DD.color().
 */
static void write_span_mono_TRUEDITHER_ximage( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   GLuint i;
   GLint r = xmesa->red;
   GLint g = xmesa->green;
   GLint b = xmesa->blue;
   y = FLIP( y );
   for (i=0;i<n;i++) {
      if (mask[i]) {
         unsigned long p;
         PACK_TRUEDITHER( p, x+i, y, r, g, b);
	 XPutPixel( img, x+i, y, p );
      }
   }
}


/*
 * Write a span of identical 8A8B8G8R pixels to an XImage.  The pixel
 * value is the one set by DD.color().
 */
static void write_span_mono_8A8B8G8R_ximage( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLuint i, p, *ptr;
   p = (GLuint) xmesa->pixel;
   ptr = PIXELADDR4( x, y );
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 ptr[i] = p;
      }
   }
}


/*
 * Write a span of identical 8R8G8B pixels to an XImage.  The pixel
 * value is the one set by DD.color().
 */
static void write_span_mono_8R8G8B_ximage( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLuint i, p, *ptr;
   p = (GLuint) xmesa->pixel;
   ptr = PIXELADDR4( x, y );
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 ptr[i] = p;
      }
   }
}


/*
 * Write a span of identical DITHER pixels to an XImage.  The pixel
 * value is the one set by DD.color().
 */
static void write_span_mono_DITHER_ximage( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   register GLubyte r, g, b;
   int yy = FLIP(y);
   XDITHER_SETUP(yy);
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   for (i=0;i<n;i++,x++) {
      if (mask[i]) {
	 XPutPixel( img, x, yy, XDITHER( x, r, g, b ) );
      }
   }
}


/*
 * Write a span of identical 8-bit DITHER pixels to an XImage.  The pixel
 * value is the one set by DD.color().
 */
static void write_span_mono_DITHER8_ximage( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = PIXELADDR1(x,y);
   register GLubyte r, g, b;
   XDITHER_SETUP(y);
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   for (i=0;i<n;i++,x++) {
      if (mask[i]) {
	 ptr[i] = XDITHER( x, r, g, b );
      }
   }
}


/*
 * Write a span of identical 8-bit LOOKUP pixels to an XImage.  The pixel
 * value is the one set by DD.color().
 */
static void write_span_mono_LOOKUP8_ximage( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = PIXELADDR1(x,y);
   register GLubyte pixel = xmesa->pixel;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 ptr[i] = pixel;
      }
   }
}


/*
 * Write a span of identical PF_1BIT pixels to an XImage.  The pixel
 * value is the one set by DD.color().
 */
static void write_span_mono_1BIT_ximage( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   register GLubyte r, g, b;
   SETUP_1BIT;
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   y = FLIP(y);
   for (i=0;i<n;i++,x++) {
      if (mask[i]) {
	 XPutPixel( img, x, y, DITHER_1BIT( x, y, r, g, b ) );
      }
   }
}


/*
 * Write a span of identical HPCR pixels to an XImage.  The pixel
 * value is the one set by DD.color().
 */
static void write_span_mono_HPCR_ximage( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte *ptr = PIXELADDR1(x,y);
   register GLubyte r, g, b;
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   for (i=0;i<n;i++,x++) {
      if (mask[i]) {
         ptr[i] = DITHER_HPCR( x, y, r, g, b );
      }
   }
}



/*
 * Write a span of identical 8-bit GRAYSCALE pixels to an XImage.  The pixel
 * value is the one set by DD.color().
 */
static void write_span_mono_GRAYSCALE8_ximage( MONO_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLuint i;
   unsigned long p = xmesa->pixel;
   GLubyte *ptr = PIXELADDR1(x,y);
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 ptr[i] = p;
      }
   }
}



/**********************************************************************/
/*** Write MONO COLOR PIXELS functions                              ***/
/**********************************************************************/

#define MONO_PIXEL_ARGS	const GLcontext *ctx,				\
			GLuint n, const GLint x[], const GLint y[],	\
			const GLubyte mask[]

/*
 * Write an array of identical pixels to a pixmap.  The pixel value is
 * the one set by DD.color() or DD.index.
 */
static void write_pixels_mono_pixmap( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc1;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_TRUEDITHER pixels to a pixmap.  The pixel value is
 * the one set by DD.color() or DD.index.
 */
static void write_pixels_mono_TRUEDITHER_pixmap( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   register GLubyte r, g, b;
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         unsigned long p;
         PACK_TRUEDITHER(p, x[i], y[i], r, g, b);
         XSetForeground( dpy, gc, p );
	 XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_DITHER pixels to a pixmap.  The pixel value is
 * the one set by DD.color() or DD.index.
 */
static void write_pixels_mono_DITHER_pixmap( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   register GLubyte r, g, b;
   DITHER_SETUP;
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         XSetForeground( dpy, gc, DITHER( x[i], y[i], r, g, b ) );
	 XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of PF_1BIT pixels to a pixmap.  The pixel value is
 * the one set by DD.color() or DD.index.
 */
static void write_pixels_mono_1BIT_pixmap( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   register GLubyte r, g, b;
   SETUP_1BIT;
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         XSetForeground( dpy, gc, DITHER_1BIT( x[i], y[i], r, g, b ) );
	 XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of identical pixels to an XImage.  The pixel value is
 * the one set by DD.color() or DD.index.
 */
static void write_pixels_mono_ximage( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   register unsigned long p = xmesa->pixel;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XPutPixel( img, x[i], FLIP(y[i]), p );
      }
   }
}


/*
 * Write an array of identical TRUEDITHER pixels to an XImage.
 * The pixel value is the one set by DD.color() or DD.index.
 */
static void write_pixels_mono_TRUEDITHER_ximage( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   int r = xmesa->red;
   int g = xmesa->green;
   int b = xmesa->blue;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         unsigned long p;
         PACK_TRUEDITHER(p, x[i], FLIP(y[i]), r, g, b);
	 XPutPixel( img, x[i], FLIP(y[i]), p );
      }
   }
}



/*
 * Write an array of identical 8A8B8G8R pixels to an XImage.  The pixel value
 * is the one set by DD.color().
 */
static void write_pixels_mono_8A8B8G8R_ximage( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLuint p = (GLuint) xmesa->pixel;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 GLuint *ptr = PIXELADDR4( x[i], y[i] );
	 *ptr = p;
      }
   }
}


/*
 * Write an array of identical 8R8G8B pixels to an XImage.  The pixel value
 * is the one set by DD.color().
 */
static void write_pixels_mono_8R8G8B_ximage( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLuint p = (GLuint) xmesa->pixel;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 GLuint *ptr = PIXELADDR4( x[i], y[i] );
	 *ptr = p;
      }
   }
}


/*
 * Write an array of identical PF_DITHER pixels to an XImage.  The pixel
 * value is the one set by DD.color().
 */
static void write_pixels_mono_DITHER_ximage( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   register GLubyte r, g, b;
   DITHER_SETUP;
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XPutPixel( img, x[i], FLIP(y[i]), DITHER( x[i], y[i], r, g, b ) );
      }
   }
}


/*
 * Write an array of identical 8-bit PF_DITHER pixels to an XImage.  The
 * pixel value is the one set by DD.color().
 */
static void write_pixels_mono_DITHER8_ximage( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte r, g, b;
   DITHER_SETUP;
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 GLubyte *ptr = PIXELADDR1(x[i],y[i]);
	 *ptr = DITHER( x[i], y[i], r, g, b );
      }
   }
}


/*
 * Write an array of identical 8-bit PF_LOOKUP pixels to an XImage.  The
 * pixel value is the one set by DD.color().
 */
static void write_pixels_mono_LOOKUP8_ximage( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte pixel = xmesa->pixel;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 GLubyte *ptr = PIXELADDR1(x[i],y[i]);
	 *ptr = pixel;
      }
   }
}



/*
 * Write an array of identical PF_1BIT pixels to an XImage.  The pixel
 * value is the one set by DD.color().
 */
static void write_pixels_mono_1BIT_ximage( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   register GLubyte r, g, b;
   SETUP_1BIT;
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XPutPixel( img, x[i], FLIP(y[i]), DITHER_1BIT( x[i], y[i], r, g, b ));
      }
   }
}


/*
 * Write an array of identical PF_HPCR pixels to an XImage.  The
 * pixel value is the one set by DD.color().
 */
static void write_pixels_mono_HPCR_ximage( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register GLubyte r, g, b;
   r = xmesa->red;
   g = xmesa->green;
   b = xmesa->blue;
   for (i=0;i<n;i++) {
      if (mask[i]) {
         GLubyte *ptr = PIXELADDR1(x[i],y[i]);
         *ptr = DITHER_HPCR( x[i], y[i], r, g, b );
      }
   }
}


/*
 * Write an array of identical 8-bit PF_GRAYSCALE pixels to an XImage.  The
 * pixel value is the one set by DD.color().
 */
static void write_pixels_mono_GRAYSCALE8_ximage( MONO_PIXEL_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   register unsigned long p = xmesa->pixel;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 GLubyte *ptr = PIXELADDR1(x[i],y[i]);
	 *ptr = p;
      }
   }
}




/**********************************************************************/
/*** Write INDEX SPAN functions                                     ***/
/**********************************************************************/

#define INDEX_SPAN_ARGS	const GLcontext *ctx,				\
			GLuint n, GLint x, GLint y, const GLuint index[], \
			const GLubyte mask[]

#define INDEX8_SPAN_ARGS const GLcontext *ctx,				\
			 GLuint n, GLint x, GLint y, const GLubyte index[], \
			 const GLubyte mask[]


/*
 * Write a span of CI pixels to a Pixmap.
 */
static void write_span_index_pixmap( INDEX_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP(y);
   for (i=0;i<n;i++,x++) {
      if (mask[i]) {
	 XSetForeground( dpy, gc, (unsigned long) index[i] );
	 XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
      }
   }
}


/*
 * Write a span of 8-bit CI pixels to a Pixmap.
 */
static void write_span_index8_pixmap( INDEX8_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   y = FLIP(y);
   for (i=0;i<n;i++,x++) {
      if (mask[i]) {
	 XSetForeground( dpy, gc, (unsigned long) index[i] );
	 XDrawPoint( dpy, buffer, gc, (int) x, (int) y );
      }
   }
}


/*
 * Write a span of CI pixels to an XImage.
 */
static void write_span_index_ximage( INDEX_SPAN_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   y = FLIP(y);
   for (i=0;i<n;i++,x++) {
      if (mask[i]) {
	 XPutPixel( img, x, y, (unsigned long) index[i] );
      }
   }
}


/*
 * Write a span of 8-bit CI pixels to a non 8-bit XImage.
 */
static void write_span_index8_ximage( const GLcontext *ctx, GLuint n,
                                      GLint x, GLint y, const GLubyte index[],
                                      const GLubyte mask[] )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   if (mask) {
      GLuint i;
      for (i=0;i<n;i++) {
         if (mask[i]) {
            XPutPixel(xmesa->xm_buffer->backimage, x+i, y, index[i]);
         }
      }
   }
   else {
      GLuint i;
      for (i=0;i<n;i++) {
         XPutPixel(xmesa->xm_buffer->backimage, x+i, y, index[i]);
      }
   }
}

/*
 * Write a span of 8-bit CI pixels to an 8-bit XImage.
 */
static void write_span_index8_ximage8( const GLcontext *ctx, GLuint n,
                                      GLint x, GLint y, const GLubyte index[],
                                      const GLubyte mask[] )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLubyte *dst = PIXELADDR1(x,y);
   if (mask) {
      GLuint i;
      for (i=0;i<n;i++) {
         if (mask[i]) {
            dst[i] = index[i];
         }
      }
   }
   else {
      MEMCPY( dst, index, n );
   }
}



/**********************************************************************/
/*** Write INDEX PIXELS functions                                   ***/
/**********************************************************************/

#define INDEX_PIXELS_ARGS	const GLcontext *ctx,			\
				GLuint n, const GLint x[], const GLint y[], \
				const GLuint index[], const GLubyte mask[]


/*
 * Write an array of CI pixels to a Pixmap.
 */
static void write_pixels_index_pixmap( INDEX_PIXELS_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   GC gc = xmesa->xm_buffer->gc2;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XSetForeground( dpy, gc, (unsigned long) index[i] );
	 XDrawPoint( dpy, buffer, gc, (int) x[i], (int) FLIP(y[i]) );
      }
   }
}


/*
 * Write an array of CI pixels to an XImage.
 */
static void write_pixels_index_ximage( INDEX_PIXELS_ARGS )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   XImage *img = xmesa->xm_buffer->backimage;
   register GLuint i;
   for (i=0;i<n;i++) {
      if (mask[i]) {
	 XPutPixel( img, x[i], FLIP(y[i]), (unsigned long) index[i] );
      }
   }
}




/**********************************************************************/
/*****                      Pixel reading                         *****/
/**********************************************************************/



/*
 * Read a horizontal span of color-index pixels.
 */
static void read_index_span( const GLcontext *ctx,
			     GLuint n, GLint x, GLint y, GLuint index[] )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   GLuint i;

   y = FLIP(y);

   if (xmesa->xm_buffer->buffer) {
      XImage *span;
      int error;
      catch_xgetimage_errors( xmesa->display );
      span = XGetImage( xmesa->display, xmesa->xm_buffer->buffer,
		        x, y, n, 1, AllPlanes, ZPixmap );
      error = check_xgetimage_errors();
      if (span && !error) {
	 for (i=0;i<n;i++) {
	    index[i] = (GLuint) XGetPixel( span, i, 0 );
	 }
      }
      else {
	 /* return 0 pixels */
	 for (i=0;i<n;i++) {
	    index[i] = 0;
	 }
      }
      if (span) {
	 XDestroyImage( span );
      }
   }
   else if (xmesa->xm_buffer->backimage) {
      XImage *img = xmesa->xm_buffer->backimage;
      for (i=0;i<n;i++,x++) {
	 index[i] = (GLuint) XGetPixel( img, x, y );
      }
   }
}



/*
 * Read a horizontal span of color pixels.
 */
static void read_color_span( const GLcontext *ctx,
			     GLuint n, GLint x, GLint y,
                             GLubyte rgba[][4] )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;

   if (xmesa->xm_buffer->buffer) {
      XImage *span;
      int error;
      catch_xgetimage_errors( xmesa->display );
      span = XGetImage( xmesa->display, xmesa->xm_buffer->buffer,
		        x, FLIP(y), n, 1, AllPlanes, ZPixmap );
      error = check_xgetimage_errors();
      if (span && !error) {
	 switch (xmesa->pixelformat) {
	    case PF_TRUECOLOR:
	    case PF_TRUEDITHER:
            case PF_5R6G5B:
               {
                  unsigned long rMask = xmesa->xm_visual->visinfo->red_mask;
                  unsigned long gMask = xmesa->xm_visual->visinfo->green_mask;
                  unsigned long bMask = xmesa->xm_visual->visinfo->blue_mask;
                  GLubyte *pixelToR = xmesa->xm_visual->PixelToR;
                  GLubyte *pixelToG = xmesa->xm_visual->PixelToG;
                  GLubyte *pixelToB = xmesa->xm_visual->PixelToB;
                  GLint rShift = xmesa->xm_visual->rshift;
                  GLint gShift = xmesa->xm_visual->gshift;
                  GLint bShift = xmesa->xm_visual->bshift;
                  for (i=0;i<n;i++) {
                     unsigned long p = XGetPixel( span, i, 0 );
                     rgba[i][RCOMP] = pixelToR[(p & rMask) >> rShift];
                     rgba[i][GCOMP] = pixelToG[(p & gMask) >> gShift];
                     rgba[i][BCOMP] = pixelToB[(p & bMask) >> bShift];
                     rgba[i][ACOMP] = 255;
                  }
               }
	       break;
	    case PF_8A8B8G8R:
               {
                  GLuint *ptr4 = (GLuint *) span->data;
                  for (i=0;i<n;i++) {
                     GLuint p4 = *ptr4++;
                     rgba[i][RCOMP] = (GLubyte) ( p4        & 0xff);
                     rgba[i][GCOMP] = (GLubyte) ((p4 >> 8)  & 0xff);
                     rgba[i][BCOMP] = (GLubyte) ((p4 >> 16) & 0xff);
                     rgba[i][ACOMP] = (GLubyte) ((p4 >> 24) & 0xff);
                  }
	       }
	       break;
            case PF_8R8G8B:
               {
                  GLuint *ptr4 = (GLuint *) span->data;
                  for (i=0;i<n;i++) {
                     GLuint p4 = *ptr4++;
                     rgba[i][RCOMP] = (GLubyte) ((p4 >> 16) & 0xff);
                     rgba[i][GCOMP] = (GLubyte) ((p4 >> 8)  & 0xff);
                     rgba[i][BCOMP] = (GLubyte) ( p4        & 0xff);
                     rgba[i][ACOMP] = 255;
                  }
	       }
	       break;
            case PF_HPCR:
               {
                  GLubyte *ptr1 = (GLubyte *) span->data;
                  for (i=0;i<n;i++) {
                     GLubyte p = *ptr1++;
                     rgba[i][RCOMP] =  p & 0xE0;
                     rgba[i][GCOMP] = (p & 0x1C) << 3;
                     rgba[i][BCOMP] = (p & 0x03) << 6;
                     rgba[i][ACOMP] = 255;
                  }
               }
               break;
	    case PF_DITHER:
	    case PF_LOOKUP:
	    case PF_GRAYSCALE:
               {
                  GLubyte *rTable = xmesa->xm_buffer->pixel_to_r;
                  GLubyte *gTable = xmesa->xm_buffer->pixel_to_g;
                  GLubyte *bTable = xmesa->xm_buffer->pixel_to_b;
                  if (xmesa->xm_visual->visinfo->depth==8) {
                     GLubyte *ptr1 = (GLubyte *) span->data;
                     for (i=0;i<n;i++) {
                        unsigned long p = *ptr1++;
                        rgba[i][RCOMP] = rTable[p];
                        rgba[i][GCOMP] = gTable[p];
                        rgba[i][BCOMP] = bTable[p];
                        rgba[i][ACOMP] = 255;
                     }
                  }
                  else {
                     for (i=0;i<n;i++) {
                        unsigned long p = XGetPixel( span, i, 0 );
                        rgba[i][RCOMP] = rTable[p];
                        rgba[i][GCOMP] = gTable[p];
                        rgba[i][BCOMP] = bTable[p];
                        rgba[i][ACOMP] = 255;
                     }
                  }
               }
	       break;
	    case PF_1BIT:
               {
                  int bitFlip = xmesa->xm_visual->bitFlip;
                  for (i=0;i<n;i++) {
                     unsigned long p = XGetPixel( span, i, 0 ) ^ bitFlip;
                     rgba[i][RCOMP] = (GLubyte) (p * 255);
                     rgba[i][GCOMP] = (GLubyte) (p * 255);
                     rgba[i][BCOMP] = (GLubyte) (p * 255);
                     rgba[i][ACOMP] = 255;
                  }
               }
	       break;
	    default:
	       gl_problem(NULL,"Problem in DD.read_color_span (1)");
               return;
	 }
      }
      else {
	 /* return black pixels */
	 for (i=0;i<n;i++) {
	    rgba[i][RCOMP] = rgba[i][GCOMP] = rgba[i][BCOMP] = rgba[i][ACOMP] = 0;
	 }
      }
      if (span) {
	 XDestroyImage( span );
      }
   }
   else if (xmesa->xm_buffer->backimage) {
      switch (xmesa->pixelformat) {
         case PF_TRUECOLOR:
         case PF_TRUEDITHER:
         case PF_5R6G5B:
            {
               unsigned long rMask = xmesa->xm_visual->visinfo->red_mask;
               unsigned long gMask = xmesa->xm_visual->visinfo->green_mask;
               unsigned long bMask = xmesa->xm_visual->visinfo->blue_mask;
               GLubyte *pixelToR = xmesa->xm_visual->PixelToR;
               GLubyte *pixelToG = xmesa->xm_visual->PixelToG;
               GLubyte *pixelToB = xmesa->xm_visual->PixelToB;
               GLint rShift = xmesa->xm_visual->rshift;
               GLint gShift = xmesa->xm_visual->gshift;
               GLint bShift = xmesa->xm_visual->bshift;
               XImage *img = xmesa->xm_buffer->backimage;
               y = FLIP(y);
               for (i=0;i<n;i++) {
                  unsigned long p = XGetPixel( img, x+i, y );
                  rgba[i][RCOMP] = pixelToR[(p & rMask) >> rShift];
                  rgba[i][GCOMP] = pixelToG[(p & gMask) >> gShift];
                  rgba[i][BCOMP] = pixelToB[(p & bMask) >> bShift];
                  rgba[i][ACOMP] = 255;
               }
            }
            break;
	 case PF_8A8B8G8R:
            {
               GLuint *ptr4 = PIXELADDR4( x, y );
               for (i=0;i<n;i++) {
                  GLuint p4 = *ptr4++;
                  rgba[i][RCOMP] = (GLubyte) ( p4        & 0xff);
                  rgba[i][GCOMP] = (GLubyte) ((p4 >> 8)  & 0xff);
                  rgba[i][BCOMP] = (GLubyte) ((p4 >> 16) & 0xff);
                  rgba[i][ACOMP] = (GLint)   ((p4 >> 24) & 0xff);
               }
            }
	    break;
	 case PF_8R8G8B:
            {
               GLuint *ptr4 = PIXELADDR4( x, y );
               for (i=0;i<n;i++) {
                  GLuint p4 = *ptr4++;
                  rgba[i][RCOMP] = (GLubyte) ((p4 >> 16) & 0xff);
                  rgba[i][GCOMP] = (GLubyte) ((p4 >> 8)  & 0xff);
                  rgba[i][BCOMP] = (GLubyte) ( p4        & 0xff);
                  rgba[i][ACOMP] = 255;
               }
            }
	    break;
         case PF_HPCR:
            {
               GLubyte *ptr1 = PIXELADDR1( x, y );
               for (i=0;i<n;i++) {
                  GLubyte p = *ptr1++;
                  rgba[i][RCOMP] =  p & 0xE0;
                  rgba[i][GCOMP] = (p & 0x1C) << 3;
                  rgba[i][BCOMP] = (p & 0x03) << 6;
                  rgba[i][ACOMP] = 255;
               }
            }
            break;
	 case PF_DITHER:
	 case PF_LOOKUP:
	 case PF_GRAYSCALE:
            {
               GLubyte *rTable = xmesa->xm_buffer->pixel_to_r;
               GLubyte *gTable = xmesa->xm_buffer->pixel_to_g;
               GLubyte *bTable = xmesa->xm_buffer->pixel_to_b;
               if (xmesa->xm_visual->visinfo->depth==8) {
                  GLubyte *ptr1 = PIXELADDR1(x,y);
                  for (i=0;i<n;i++) {
                     unsigned long p = *ptr1++;
                     rgba[i][RCOMP] = rTable[p];
                     rgba[i][GCOMP] = gTable[p];
                     rgba[i][BCOMP] = bTable[p];
                     rgba[i][ACOMP] = 255;
                  }
               }
               else {
                  XImage *img = xmesa->xm_buffer->backimage;
                  y = FLIP(y);
                  for (i=0;i<n;i++,x++) {
                     unsigned long p = XGetPixel( img, x, y );
                     rgba[i][RCOMP] = rTable[p];
                     rgba[i][GCOMP] = gTable[p];
                     rgba[i][BCOMP] = bTable[p];
                     rgba[i][ACOMP] = 255;
                  }
               }
            }
	    break;
	 case PF_1BIT:
            {
               XImage *img = xmesa->xm_buffer->backimage;
               int bitFlip = xmesa->xm_visual->bitFlip;
               y = FLIP(y);
               for (i=0;i<n;i++,x++) {
                  unsigned long p = XGetPixel( img, x, y ) ^ bitFlip;
                  rgba[i][RCOMP] = (GLubyte) (p * 255);
                  rgba[i][GCOMP] = (GLubyte) (p * 255);
                  rgba[i][BCOMP] = (GLubyte) (p * 255);
                  rgba[i][ACOMP] = 255;
               }
	    }
	    break;
	 default:
	    gl_problem(NULL,"Problem in DD.read_color_span (2)");
            return;
      }
   }
}



/*
 * Read an array of color index pixels.
 */
static void read_index_pixels( const GLcontext *ctx,
			       GLuint n, const GLint x[], const GLint y[],
                               GLuint indx[], const GLubyte mask[] )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   register GLuint i;
   if (xmesa->xm_buffer->buffer) {
      for (i=0;i<n;i++) {
         if (mask[i]) {
            indx[i] = (GLuint) read_pixel( xmesa->display,
                                           xmesa->xm_buffer->buffer,
                                           x[i], FLIP(y[i]) );
         }
      }
   }
   else if (xmesa->xm_buffer->backimage) {
      XImage *img = xmesa->xm_buffer->backimage;
      for (i=0;i<n;i++) {
         if (mask[i]) {
            indx[i] = (GLuint) XGetPixel( img, x[i], FLIP(y[i]) );
         }
      }
   }
}



static void read_color_pixels( const GLcontext *ctx,
			       GLuint n, const GLint x[], const GLint y[],
                               GLubyte rgba[][4], const GLubyte mask[] )
{
   const XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   Display *dpy = xmesa->xm_visual->display;
   Drawable buffer = xmesa->xm_buffer->buffer;
   register GLuint i;

   if (xmesa->xm_buffer->buffer) {
      switch (xmesa->pixelformat) {
	 case PF_TRUECOLOR:
         case PF_TRUEDITHER:
         case PF_5R6G5B:
            {
               unsigned long rMask = xmesa->xm_visual->visinfo->red_mask;
               unsigned long gMask = xmesa->xm_visual->visinfo->green_mask;
               unsigned long bMask = xmesa->xm_visual->visinfo->blue_mask;
               GLubyte *pixelToR = xmesa->xm_visual->PixelToR;
               GLubyte *pixelToG = xmesa->xm_visual->PixelToG;
               GLubyte *pixelToB = xmesa->xm_visual->PixelToB;
               GLint rShift = xmesa->xm_visual->rshift;
               GLint gShift = xmesa->xm_visual->gshift;
               GLint bShift = xmesa->xm_visual->bshift;
               for (i=0;i<n;i++) {
                  if (mask[i]) {
                     unsigned long p = read_pixel( dpy, buffer,
                                                   x[i], FLIP(y[i]) );
                     rgba[i][RCOMP] = pixelToR[(p & rMask) >> rShift];
                     rgba[i][GCOMP] = pixelToG[(p & gMask) >> gShift];
                     rgba[i][BCOMP] = pixelToB[(p & bMask) >> bShift];
                     rgba[i][ACOMP] = 255;
                  }
               }
            }
            break;
	 case PF_8A8B8G8R:
	    for (i=0;i<n;i++) {
               if (mask[i]) {
                  unsigned long p = read_pixel( dpy, buffer,
                                                x[i], FLIP(y[i]) );
                  rgba[i][RCOMP] = (GLubyte) ( p        & 0xff);
                  rgba[i][GCOMP] = (GLubyte) ((p >> 8)  & 0xff);
                  rgba[i][BCOMP] = (GLubyte) ((p >> 16) & 0xff);
                  rgba[i][ACOMP] = (GLubyte) ((p >> 24) & 0xff);
               }
	    }
	    break;
	 case PF_8R8G8B:
	    for (i=0;i<n;i++) {
               if (mask[i]) {
                  unsigned long p = read_pixel( dpy, buffer,
                                                x[i], FLIP(y[i]) );
                  rgba[i][RCOMP] = (GLubyte) ((p >> 16) & 0xff);
                  rgba[i][GCOMP] = (GLubyte) ((p >> 8)  & 0xff);
                  rgba[i][BCOMP] = (GLubyte) ( p        & 0xff);
                  rgba[i][ACOMP] = 255;
               }
	    }
	    break;
         case PF_HPCR:
            {
               for (i=0;i<n;i++) {
                  if (mask[i]) {
                     unsigned long p = read_pixel( dpy, buffer,
                                                   x[i], FLIP(y[i]) );
                     rgba[i][RCOMP] =  p & 0xE0;
                     rgba[i][GCOMP] = (p & 0x1C) << 3;
                     rgba[i][BCOMP] = (p & 0x03) << 6;
                     rgba[i][ACOMP] = 255;
                  }
               }
            }
            break;
	 case PF_DITHER:
	 case PF_LOOKUP:
	 case PF_GRAYSCALE:
            {
               GLubyte *rTable = xmesa->xm_buffer->pixel_to_r;
               GLubyte *gTable = xmesa->xm_buffer->pixel_to_g;
               GLubyte *bTable = xmesa->xm_buffer->pixel_to_b;
               for (i=0;i<n;i++) {
                  if (mask[i]) {
                     unsigned long p = read_pixel( dpy, buffer,
                                                   x[i], FLIP(y[i]) );
                     rgba[i][RCOMP] = rTable[p];
                     rgba[i][GCOMP] = gTable[p];
                     rgba[i][BCOMP] = bTable[p];
                     rgba[i][ACOMP] = 255;
                  }
               }
	    }
	    break;
	 case PF_1BIT:
            {
               int bitFlip = xmesa->xm_visual->bitFlip;
               for (i=0;i<n;i++) {
                  if (mask[i]) {
                     unsigned long p = read_pixel( dpy, buffer,
                                                   x[i], FLIP(y[i])) ^ bitFlip;
                     rgba[i][RCOMP] = (GLubyte) (p * 255);
                     rgba[i][GCOMP] = (GLubyte) (p * 255);
                     rgba[i][BCOMP] = (GLubyte) (p * 255);
                     rgba[i][ACOMP] = 255;
                  }
               }
	    }
	    break;
	 default:
	    gl_problem(NULL,"Problem in DD.read_color_pixels (1)");
            return;
      }
   }
   else if (xmesa->xm_buffer->backimage) {
      switch (xmesa->pixelformat) {
	 case PF_TRUECOLOR:
         case PF_TRUEDITHER:
         case PF_5R6G5B:
            {
               unsigned long rMask = xmesa->xm_visual->visinfo->red_mask;
               unsigned long gMask = xmesa->xm_visual->visinfo->green_mask;
               unsigned long bMask = xmesa->xm_visual->visinfo->blue_mask;
               GLubyte *pixelToR = xmesa->xm_visual->PixelToR;
               GLubyte *pixelToG = xmesa->xm_visual->PixelToG;
               GLubyte *pixelToB = xmesa->xm_visual->PixelToB;
               GLint rShift = xmesa->xm_visual->rshift;
               GLint gShift = xmesa->xm_visual->gshift;
               GLint bShift = xmesa->xm_visual->bshift;
               XImage *img = xmesa->xm_buffer->backimage;
               for (i=0;i<n;i++) {
                  if (mask[i]) {
                     unsigned long p = XGetPixel( img, x[i], FLIP(y[i]) );
                     rgba[i][RCOMP] = pixelToR[(p & rMask) >> rShift];
                     rgba[i][GCOMP] = pixelToG[(p & gMask) >> gShift];
                     rgba[i][BCOMP] = pixelToB[(p & bMask) >> bShift];
                     rgba[i][ACOMP] = 255;
                  }
               }
            }
            break;
	 case PF_8A8B8G8R:
	    for (i=0;i<n;i++) {
	       if (mask[i]) {
                  GLuint *ptr4 = PIXELADDR4( x[i], y[i] );
                  GLuint p4 = *ptr4;
                  rgba[i][RCOMP] = (GLubyte) ( p4        & 0xff);
                  rgba[i][GCOMP] = (GLubyte) ((p4 >> 8)  & 0xff);
                  rgba[i][BCOMP] = (GLubyte) ((p4 >> 16) & 0xff);
                  rgba[i][ACOMP] = (GLubyte) ((p4 >> 24) & 0xff);
               }
	    }
	    break;
	 case PF_8R8G8B:
	    for (i=0;i<n;i++) {
	       if (mask[i]) {
                  GLuint *ptr4 = PIXELADDR4( x[i], y[i] );
                  GLuint p4 = *ptr4;
                  rgba[i][RCOMP] = (GLubyte) ((p4 >> 16) & 0xff);
                  rgba[i][GCOMP] = (GLubyte) ((p4 >> 8)  & 0xff);
                  rgba[i][BCOMP] = (GLubyte) ( p4        & 0xff);
                  rgba[i][ACOMP] = 255;
               }
	    }
	    break;
         case PF_HPCR:
            for (i=0;i<n;i++) {
               if (mask[i]) {
                  GLubyte *ptr1 = PIXELADDR1( x[i], y[i] );
                  GLubyte p = *ptr1;
                  rgba[i][RCOMP] =  p & 0xE0;
                  rgba[i][GCOMP] = (p & 0x1C) << 3;
                  rgba[i][BCOMP] = (p & 0x03) << 6;
                  rgba[i][ACOMP] = 255;
               }
            }
            break;
	 case PF_DITHER:
	 case PF_LOOKUP:
	 case PF_GRAYSCALE:
            {
               GLubyte *rTable = xmesa->xm_buffer->pixel_to_r;
               GLubyte *gTable = xmesa->xm_buffer->pixel_to_g;
               GLubyte *bTable = xmesa->xm_buffer->pixel_to_b;
               XImage *img = xmesa->xm_buffer->backimage;
               for (i=0;i<n;i++) {
                  if (mask[i]) {
                     unsigned long p;
                     p = XGetPixel( img, x[i], FLIP(y[i]) );
                     rgba[i][RCOMP] = rTable[p];
                     rgba[i][GCOMP] = gTable[p];
                     rgba[i][BCOMP] = bTable[p];
                     rgba[i][ACOMP] = 255;
                  }
               }
	    }
	    break;
	 case PF_1BIT:
            {
               XImage *img = xmesa->xm_buffer->backimage;
               int bitFlip = xmesa->xm_visual->bitFlip;
               for (i=0;i<n;i++) {
                  if (mask[i]) {
                     unsigned long p;
                     p = XGetPixel( img, x[i], FLIP(y[i]) ) ^ bitFlip;
                     rgba[i][RCOMP] = (GLubyte) (p * 255);
                     rgba[i][GCOMP] = (GLubyte) (p * 255);
                     rgba[i][BCOMP] = (GLubyte) (p * 255);
                     rgba[i][ACOMP] = 255;
                  }
               }
	    }
	    break;
	 default:
	    gl_problem(NULL,"Problem in DD.read_color_pixels (1)");
            return;
      }
   }
}


static const char *renderer_string(void)
{
   return "X11";
}


#if 0
/* FUTURE:  reduce state change overhead */
static void begin( GLcontext *ctx, GLenum mode )
{
   switch (mode) {
      case GL_POINTS:
         if (!ctx->Driver.PointsFunc)
            ctx->Driver.PointsFunc = xmesa_get_points_func( ctx );
         return;
      case GL_LINES:
      case GL_LINE_STRIP:
      case GL_LINE_LOOP:
         if (!ctx->Driver.LineFunc)
            ctx->Driver.LineFunc = xmesa_get_line_func( ctx );
         return;
      case GL_QUADS:
      case GL_QUAD_STRIP:
      case GL_TRIANGLES:
      case GL_TRIANGLE_STRIP:
      case GL_TRIANGLE_FAN:
      case GL_POLYGON:
         if (!ctx->Driver.TriangleFunc)
            ctx->Driver.TriangleFunc = xmesa_get_triangle_func( ctx );
         if (ctx->Polygon.Unfilled) {
            if (!ctx->Driver.PointsFunc)
               ctx->Driver.PointsFunc = xmesa_get_points_func( ctx );
            if (!ctx->Driver.LineFunc)
               ctx->Driver.LineFunc = xmesa_get_line_func( ctx );
         }
         return;
      default:
         /* no-op */
         return;
   }
}
#endif


/*
 * Initialize all the DD.* function pointers depending on the color
 * buffer configuration.  This is mainly called by XMesaMakeCurrent.
 */
void xmesa_update_state( GLcontext *ctx )
{
   XMesaContext xmesa = (XMesaContext) ctx->DriverCtx;
   /*
    * Always the same:
    */
   ctx->Driver.RendererString = renderer_string;
   ctx->Driver.UpdateState = xmesa_update_state;
   ctx->Driver.GetBufferSize = get_buffer_size;
   ctx->Driver.Flush = flush;
   ctx->Driver.Finish = finish;

   ctx->Driver.SetBuffer = set_buffer;

   ctx->Driver.Index = set_index;
   ctx->Driver.Color = set_color;
   ctx->Driver.ClearIndex = clear_index;
   ctx->Driver.ClearColor = clear_color;
   ctx->Driver.IndexMask = index_mask;
   ctx->Driver.ColorMask = color_mask;
   ctx->Driver.LogicOp = logicop;
   ctx->Driver.Dither = dither;

   /**ctx->Driver.Begin = begin;**/

   if (!ctx->Driver.PointsFunc)
      ctx->Driver.PointsFunc = xmesa_get_points_func( ctx );
   if (!ctx->Driver.LineFunc)
      ctx->Driver.LineFunc = xmesa_get_line_func( ctx );
   if (!ctx->Driver.TriangleFunc)
      ctx->Driver.TriangleFunc = xmesa_get_triangle_func( ctx );

   /*
    * These drawing functions depend on color buffer config:
    */
   if (xmesa->xm_buffer->buffer!=XIMAGE) {
      /* Writing to window or back pixmap */
      ctx->Driver.Clear = clear_pixmap;
      switch (xmesa->pixelformat) {
	 case PF_INDEX:
	    ctx->Driver.WriteCI32Span     = write_span_index_pixmap;
	    ctx->Driver.WriteCI8Span      = write_span_index8_pixmap;
	    ctx->Driver.WriteMonoCISpan   = write_span_mono_pixmap;
	    ctx->Driver.WriteCI32Pixels   = write_pixels_index_pixmap;
	    ctx->Driver.WriteMonoCIPixels = write_pixels_mono_pixmap;
	    break;
	 case PF_TRUECOLOR:
	    ctx->Driver.WriteRGBASpan       = write_span_TRUECOLOR_pixmap;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_TRUECOLOR_pixmap;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_pixmap;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_TRUECOLOR_pixmap;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_pixmap;
	    break;
	 case PF_TRUEDITHER:
	    ctx->Driver.WriteRGBASpan       = write_span_TRUEDITHER_pixmap;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_TRUEDITHER_pixmap;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_TRUEDITHER_pixmap;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_TRUEDITHER_pixmap;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_TRUEDITHER_pixmap;
	    break;
	 case PF_8A8B8G8R:
	    ctx->Driver.WriteRGBASpan       = write_span_8A8B8G8R_pixmap;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_8A8B8G8R_pixmap;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_pixmap;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_8A8B8G8R_pixmap;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_pixmap;
	    break;
	 case PF_8R8G8B:
	    ctx->Driver.WriteRGBASpan       = write_span_8R8G8B_pixmap;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_8R8G8B_pixmap;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_pixmap;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_8R8G8B_pixmap;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_pixmap;
	    break;
	 case PF_5R6G5B:
	    ctx->Driver.WriteRGBASpan       = write_span_5R6G5B_pixmap;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_5R6G5B_pixmap;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_pixmap;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_5R6G5B_pixmap;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_pixmap;
	    break;
	 case PF_DITHER:
	    ctx->Driver.WriteRGBASpan       = write_span_DITHER_pixmap;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_DITHER_pixmap;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_DITHER_pixmap;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_DITHER_pixmap;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_DITHER_pixmap;
	    break;
	 case PF_1BIT:
	    ctx->Driver.WriteRGBASpan       = write_span_1BIT_pixmap;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_1BIT_pixmap;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_1BIT_pixmap;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_1BIT_pixmap;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_1BIT_pixmap;
	    break;
         case PF_HPCR:
            ctx->Driver.WriteRGBASpan       = write_span_HPCR_pixmap;
            ctx->Driver.WriteRGBSpan        = write_span_rgb_HPCR_pixmap;
            ctx->Driver.WriteMonoRGBASpan   = write_span_mono_pixmap;
            ctx->Driver.WriteRGBAPixels     = write_pixels_HPCR_pixmap;
            ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_pixmap;
	    if (xmesa->xm_visual->hpcr_clear_flag)
	    {
   		ctx->Driver.ClearColor = clear_color_HPCR_pixmap;
	    }
            break;
         case PF_LOOKUP:
            ctx->Driver.WriteRGBASpan       = write_span_LOOKUP_pixmap;
            ctx->Driver.WriteRGBSpan        = write_span_rgb_LOOKUP_pixmap;
            ctx->Driver.WriteMonoRGBASpan   = write_span_mono_pixmap;
            ctx->Driver.WriteRGBAPixels     = write_pixels_LOOKUP_pixmap;
            ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_pixmap;
            break;
         case PF_GRAYSCALE:
            ctx->Driver.WriteRGBASpan       = write_span_GRAYSCALE_pixmap;
            ctx->Driver.WriteRGBSpan        = write_span_rgb_GRAYSCALE_pixmap;
            ctx->Driver.WriteMonoRGBASpan   = write_span_mono_pixmap;
            ctx->Driver.WriteRGBAPixels     = write_pixels_GRAYSCALE_pixmap;
            ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_pixmap;
            break;
	 default:
	    gl_problem(NULL,"Bad pixel format in xmesa_update_state (1)");
            return;
      }
   }
   else if (xmesa->xm_buffer->buffer==XIMAGE) {
      /* Writing to back XImage */
      if (sizeof(GLushort)!=2 || sizeof(GLuint)!=4) {
         /* Do this on Crays */
         ctx->Driver.Clear = clear_nbit_ximage;
      }
      else {
         /* Do this on most machines */
         switch (xmesa->xm_buffer->backimage->bits_per_pixel) {
            case 8:
               ctx->Driver.Clear = clear_8bit_ximage;
               break;
            case 16:
               ctx->Driver.Clear = clear_16bit_ximage;
               break;
            case 32:
               ctx->Driver.Clear = clear_32bit_ximage;
               break;
            default:
               ctx->Driver.Clear = clear_nbit_ximage;
               break;
         }
      }
      switch (xmesa->pixelformat) {
	 case PF_INDEX:
	    ctx->Driver.WriteCI32Span     = write_span_index_ximage;
	    if (xmesa->xm_visual->visinfo->depth==8)
               ctx->Driver.WriteCI8Span   = write_span_index8_ximage8;
            else
               ctx->Driver.WriteCI8Span   = write_span_index8_ximage;
	    ctx->Driver.WriteMonoCISpan   = write_span_mono_ximage;
	    ctx->Driver.WriteCI32Pixels   = write_pixels_index_ximage;
	    ctx->Driver.WriteMonoCIPixels = write_pixels_mono_ximage;
	    break;
	 case PF_TRUECOLOR:
	    /* Generic RGB */
	    ctx->Driver.WriteRGBASpan       = write_span_TRUECOLOR_ximage;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_TRUECOLOR_ximage;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_ximage;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_TRUECOLOR_ximage;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_ximage;
	    break;
	 case PF_TRUEDITHER:
	    ctx->Driver.WriteRGBASpan       = write_span_TRUEDITHER_ximage;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_TRUEDITHER_ximage;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_TRUEDITHER_ximage;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_TRUEDITHER_ximage;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_TRUEDITHER_ximage;
	    break;
	 case PF_8A8B8G8R:
	    ctx->Driver.WriteRGBASpan       = write_span_8A8B8G8R_ximage;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_8A8B8G8R_ximage;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_8A8B8G8R_ximage;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_8A8B8G8R_ximage;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_8A8B8G8R_ximage;
	    break;
	 case PF_8R8G8B:
	    ctx->Driver.WriteRGBASpan       = write_span_8R8G8B_ximage;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_8R8G8B_ximage;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_8R8G8B_ximage;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_8R8G8B_ximage;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_8R8G8B_ximage;
	    break;
	 case PF_5R6G5B:
	    ctx->Driver.WriteRGBASpan       = write_span_5R6G5B_ximage;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_5R6G5B_ximage;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_ximage;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_5R6G5B_ximage;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_ximage;
	    break;
	 case PF_DITHER:
	    if (xmesa->xm_visual->visinfo->depth==8) {
	       ctx->Driver.WriteRGBASpan      = write_span_DITHER8_ximage;
	       ctx->Driver.WriteRGBSpan       = write_span_rgb_DITHER8_ximage;
	       ctx->Driver.WriteMonoRGBASpan  = write_span_mono_DITHER8_ximage;
	       ctx->Driver.WriteRGBAPixels    = write_pixels_DITHER8_ximage;
	       ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_DITHER8_ximage;
	    }
	    else {
	       ctx->Driver.WriteRGBASpan       = write_span_DITHER_ximage;
	       ctx->Driver.WriteRGBSpan        = write_span_rgb_DITHER_ximage;
	       ctx->Driver.WriteMonoRGBASpan   = write_span_mono_DITHER_ximage;
	       ctx->Driver.WriteRGBAPixels     = write_pixels_DITHER_ximage;
	       ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_DITHER_ximage;
	    }
	    break;
	 case PF_1BIT:
	    ctx->Driver.WriteRGBASpan       = write_span_1BIT_ximage;
	    ctx->Driver.WriteRGBSpan        = write_span_rgb_1BIT_ximage;
	    ctx->Driver.WriteMonoRGBASpan   = write_span_mono_1BIT_ximage;
	    ctx->Driver.WriteRGBAPixels     = write_pixels_1BIT_ximage;
	    ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_1BIT_ximage;
	    break;
         case PF_HPCR:
            ctx->Driver.WriteRGBASpan       = write_span_HPCR_ximage;
            ctx->Driver.WriteRGBSpan        = write_span_rgb_HPCR_ximage;
            ctx->Driver.WriteMonoRGBASpan   = write_span_mono_HPCR_ximage;
            ctx->Driver.WriteRGBAPixels     = write_pixels_HPCR_ximage;
            ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_HPCR_ximage;
	    if (xmesa->xm_visual->hpcr_clear_flag)
	    {
		ctx->Driver.Clear      = clear_HPCR_ximage;
   		ctx->Driver.ClearColor = clear_color_HPCR_ximage;
	    }
            break;
         case PF_LOOKUP:
	    if (xmesa->xm_visual->visinfo->depth==8) {
               ctx->Driver.WriteRGBASpan       = write_span_LOOKUP8_ximage;
               ctx->Driver.WriteRGBSpan        = write_rgb_LOOKUP8_ximage;
               ctx->Driver.WriteMonoRGBASpan   = write_span_mono_LOOKUP8_ximage;
               ctx->Driver.WriteRGBAPixels     = write_pixels_LOOKUP8_ximage;
               ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_LOOKUP8_ximage;
            }
            else {
               ctx->Driver.WriteRGBASpan       = write_span_LOOKUP_ximage;
               ctx->Driver.WriteRGBSpan        = write_span_rgb_LOOKUP_ximage;
               ctx->Driver.WriteMonoRGBASpan   = write_span_mono_ximage;
               ctx->Driver.WriteRGBAPixels     = write_pixels_LOOKUP_ximage;
               ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_ximage;
            }
            break;
         case PF_GRAYSCALE:
	    if (xmesa->xm_visual->visinfo->depth==8) {
	       ctx->Driver.WriteRGBASpan       = write_span_GRAYSCALE8_ximage;
	       ctx->Driver.WriteRGBSpan        = write_span_rgb_GRAYSCALE8_ximage;
	       ctx->Driver.WriteMonoRGBASpan   = write_span_mono_GRAYSCALE8_ximage;
	       ctx->Driver.WriteRGBAPixels     = write_pixels_GRAYSCALE8_ximage;
	       ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_GRAYSCALE8_ximage;
	    }
	    else {
	       ctx->Driver.WriteRGBASpan       = write_span_GRAYSCALE_ximage;
	       ctx->Driver.WriteRGBSpan        = write_span_rgb_GRAYSCALE_ximage;
	       ctx->Driver.WriteMonoRGBASpan   = write_span_mono_ximage;
	       ctx->Driver.WriteRGBAPixels     = write_pixels_GRAYSCALE_ximage;
	       ctx->Driver.WriteMonoRGBAPixels = write_pixels_mono_ximage;
	    }
	    break;
	 default:
	    gl_problem(NULL,"Bad pixel format in xmesa_update_state (2)");
            return;
      }
   }

   /* Pixel/span reading functions: */
   ctx->Driver.ReadCI32Span = read_index_span;
   ctx->Driver.ReadRGBASpan = read_color_span;
   ctx->Driver.ReadCI32Pixels = read_index_pixels;
   ctx->Driver.ReadRGBAPixels = read_color_pixels;
}
