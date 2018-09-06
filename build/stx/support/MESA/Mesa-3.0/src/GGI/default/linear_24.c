/* GGI-Driver for MESA
 * 
 * Copyright (C) 1997  Uwe Maurer
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
 * ---------------------------------------------------------------------
 * This code was derived from the following source of information:
 *
 * svgamesa.c and ddsample.c by Brian Paul
 * 
 */

#include "ggimesa.h"


#define FB_TYPE	uint8

/**********************************************************************/
/*****            Write spans of pixels                           *****/
/**********************************************************************/


void GGIwrite_rgba_span(const GLcontext *ctx,
                          GLuint n, GLint x, GLint y,
                          const GLubyte rgba[][4],
                          const GLubyte mask[])
{
	FB_TYPE *fb=LFB(FB_TYPE,x,FLIP(y));

	if (mask)
	{
		while (n--) {
			if (*mask++) {
				fb[0]=rgba[0][RCOMP];
				fb[1]=rgba[0][GCOMP];
				fb[2]=rgba[0][BCOMP];
			}
			fb+=3;
			rgba++;
		}
	}
	else
	{
		while (n--) {
			*fb++=rgba[0][RCOMP];
			*fb++=rgba[0][GCOMP];
			*fb++=rgba[0][BCOMP];
			rgba++;
		}
	}
}

void GGIwrite_rgb_span( const GLcontext *ctx,
                          GLuint n, GLint x, GLint y,
                          const GLubyte rgba[][3],
                          const GLubyte mask[] )
{
	FB_TYPE *fb=LFB(FB_TYPE,x,FLIP(y));
	if (mask)
	{
		while (n--) {
			if (*mask++) {
				fb[0]=rgba[0][RCOMP];
				fb[1]=rgba[0][GCOMP];
				fb[2]=rgba[0][BCOMP];
			}
			fb+=3;
			rgba++;
		}
	}
	else
	{
		while (n--) {
			*fb++=rgba[0][RCOMP];
			*fb++=rgba[0][GCOMP];
			*fb++=rgba[0][BCOMP];
			rgba++;
		}
	}
}


void GGIwrite_mono_span( const GLcontext *ctx,
                              GLuint n, GLint x, GLint y,
                              const GLubyte mask[])
{
	FB_TYPE *fb;
	uint32 color;

	if (mask)
	{
		fb=LFB(FB_TYPE,x,FLIP(y));
		color=(uint32) GGICTX->color;

		while (n--) 
		{
			if (*mask++) 
			{
				fb[0]=((uint8 *)&color)[0]; 
				fb[1]=((uint8 *)&color)[1]; 
				fb[2]=((uint8 *)&color)[2]; 
			}
			fb+=3;
		}
	}
	else
	{
		ggiDrawHLine(VIS,x,FLIP(y),n);
	}
}


/**********************************************************************/
/*****                 Read spans of pixels                       *****/
/**********************************************************************/


void GGIread_rgba_span(const GLcontext *ctx,
                         GLuint n, GLint x, GLint y,
                         GLubyte rgba[][4])
{
	FB_TYPE *fb=LFB(FB_TYPE,x,FLIP(y));

	while (n--)
	{
		rgba[0][RCOMP] = (GLubyte) *fb++;  
		rgba[0][GCOMP] = (GLubyte) *fb++;  
		rgba[0][BCOMP] = (GLubyte) *fb++;  
		rgba[0][ACOMP] =0;
		rgba++;
	}
}

/**********************************************************************/
/*****                  Write arrays of pixels                    *****/
/**********************************************************************/

void GGIwrite_mono_pixels(const GLcontext *ctx,
                                GLuint n,
                                const GLint x[], const GLint y[],
                                const GLubyte mask[] )
{
	FB_TYPE *fb=LFB(FB_TYPE,0,0);
	FB_TYPE *fb2;
	FB_TYPE color=(FB_TYPE) GGICTX->color;

	while (n--) {
		if (*mask++)
		{
			fb2=(fb + *x + FLIP(*y)*GGICTX->width);
			fb2[0]=((uint8 *)&color)[0];
			fb2[1]=((uint8 *)&color)[1];
			fb2[2]=((uint8 *)&color)[2];
		}
		x++;
		y++;
	}
}

void GGIwrite_rgba_pixels(const GLcontext *ctx,
                            GLuint n, const GLint x[], const GLint y[],
                            const GLubyte rgba[][4],
                            const GLubyte mask[] )
{
	FB_TYPE *fb=LFB(FB_TYPE,0,0);
	FB_TYPE *fb2;

	while (n--) {
		if (*mask++) {
			fb2=(fb+ *x + FLIP(*y)*GGICTX->width);
			fb2[0]=rgba[0][RCOMP];
			fb2[1]=rgba[0][GCOMP];
			fb2[2]=rgba[0][BCOMP];
		}
		x++;y++;
		rgba++;
	}
}


/**********************************************************************/
/*****                   Read arrays of pixels                    *****/
/**********************************************************************/

void GGIread_rgba_pixels(const GLcontext *ctx,
                           GLuint n, const GLint x[], const GLint y[],
                           GLubyte rgba[][4],
                           const GLubyte mask[] )
{
	FB_TYPE *fb=LFB(FB_TYPE,0,0);
	FB_TYPE *fb2;

	while (n--)
	{
		if (*mask++)
		{
			fb2=(fb+ *x + FLIP(*y)*GGICTX->width);
			rgba[0][RCOMP] = *fb2++;
			rgba[0][GCOMP] = *fb2++;
			rgba[0][BCOMP] = *fb2++;
			rgba[0][ACOMP] = 0;
		}	
		x++; y++;
		rgba++;
	}
}

int GGIsetup_driver(GGIMesaContext ggictx,struct ggi_mesa_info *info)
{
	GLcontext *ctx=ggictx->gl_ctx;

	ctx->Driver.WriteRGBASpan	= GGIwrite_rgba_span;
	ctx->Driver.WriteRGBSpan	= GGIwrite_rgb_span;
	ctx->Driver.WriteMonoRGBASpan	= GGIwrite_mono_span;
	ctx->Driver.WriteRGBAPixels	= GGIwrite_rgba_pixels;
	ctx->Driver.WriteMonoRGBAPixels = GGIwrite_mono_pixels;

	ctx->Driver.WriteMonoCISpan   = GGIwrite_mono_span;
	ctx->Driver.WriteMonoCIPixels = GGIwrite_mono_pixels;

	ctx->Driver.ReadRGBASpan = GGIread_rgba_span;
	ctx->Driver.ReadRGBAPixels = GGIread_rgba_pixels;

	info->red_bits=8;
	info->green_bits=8;
	info->blue_bits=8;

	return 0;
}

int GGIdlinit(ggi_visual_t vis,const char *version)
{	
	VIS_OPMESA(vis)->setup_driver=GGIsetup_driver;

	return 0;
}

int GGIdlcleanup(ggi_visual_t vis)
{
	return 0;
}
