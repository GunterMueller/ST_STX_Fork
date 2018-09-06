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

#ifndef _GGIMESA_H
#define _GGIMESA_H


#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "config.h"
#include "context.h"
#include "matrix.h"
#include "types.h"
#include "vb.h"
#include "macros.h"
#include "depth.h"

#undef ASSERT		/* ASSERT is redefined */

#define  _BUILDING_LIBGGI

#include "GL/ggimesa.h"
#include <ggi/libggi.h>
#include <ggi/libggi_ext.h>
#include <ggi/internal/libggi/internal.h>


struct ggi_mesa_info;

struct ggi_mesa_op {
	void (*update_state)(GLcontext *ctx);
	int (*setup_driver)(GGIMesaContext ctx,struct ggi_mesa_info *info);
};

struct ggi_mesa_context {
	GLcontext *gl_ctx;
	GLvisual *gl_vis;
	GLframebuffer *gl_buffer;

	ggi_visual_t ggi_vis; 
	ggi_coord origin;
	int flip_y;
	int width,height,stride;        /* Stride is in pixels */
	ggi_pixel color;		/*current color or index*/
	ggi_pixel clearcolor;
	void *lfb;			/*linear frame buffer*/
	int viewport_init;
};

struct ggi_mesa_info{
	GLboolean rgb_flag;
	GLboolean db_flag;
	GLboolean alpha_flag;
	GLint index_bits;
	GLint red_bits,green_bits,blue_bits,alpha_bits;
	GLint depth_bits,stencil_bits,accum_bits;
};

extern GGIMesaContext GGIMesa;    /* the current context */

extern ggi_extid gl_ggi_extid;	/* extension id */

#define SHIFT (GGI_COLOR_PRECISION - 8)


#define GGICTX ((GGIMesaContext)ctx->DriverCtx)
#define VIS (GGICTX->ggi_vis)
#define FLIP(y) (GGICTX->flip_y-(y))

#define LFB(type,x,y) ((type *)GGICTX->lfb + (x) + (y) * GGICTX->stride)

#define VIS_OPMESA(vis) \
	((struct ggi_mesa_op *)LIBGGI_EXT(vis,gl_ggi_extid))

#define CTX_OPMESA(ctx) \
((struct ggi_mesa_op *)LIBGGI_EXT(((GGIMesaContext)ctx->DriverCtx)->ggi_vis, \
	gl_ggi_extid))
	
#endif

