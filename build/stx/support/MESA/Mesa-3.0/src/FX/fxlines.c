/* -*- mode: C; tab-width:8;  -*-

             fxlines.c - 3Dfx VooDoo line functions 
*/

/*
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
 *
 * See the file fxapi.c for more informations about authors
 *
 */

#if defined(FX)

#include "fxdrv.h"

/************************************************************************/
/************************* Lines functions ******************************/
/************************************************************************/

#define GOURAUD(v) { \
  fxMesa->gWin[(v)].r=(float) VB->Color[(v)][0]; \
  fxMesa->gWin[(v)].g=(float) VB->Color[(v)][1]; \
  fxMesa->gWin[(v)].b=(float) VB->Color[(v)][2]; \
  fxMesa->gWin[(v)].a=(float) VB->Color[(v)][3]; \
}

static void fxLineSmooth(GLcontext *ctx, GLuint v1, GLuint v2, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

  grDrawLine(&fxMesa->gWin[v1],&fxMesa->gWin[v2]);
}

static void fxLineSmoothTwoSide(GLcontext *ctx, GLuint v1, GLuint v2, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;

  GOURAUD(v1); 
  GOURAUD(v2); 

  grDrawLine(&fxMesa->gWin[v1],&fxMesa->gWin[v2]);
}

static void fxLineFlat(GLcontext *ctx, GLuint v1, GLuint v2, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GLubyte *Color=ctx->VB->Color[pv];

  grConstantColorValue(FXCOLOR(Color[0], Color[1], Color[2], Color[3]));

  grDrawLine(&fxMesa->gWin[v1],&fxMesa->gWin[v2]);
}

/************************************************************************/

static void fxLineSmoothFrontBack(GLcontext *ctx, GLuint v1,
				  GLuint v2, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  grDepthMask(FXFALSE);
  grRenderBuffer(GR_BUFFER_BACKBUFFER);
  grDrawLine(&fxMesa->gWin[v1],&fxMesa->gWin[v2]);

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  if(ctx->Depth.Mask)
    grDepthMask(FXTRUE);
  grRenderBuffer(GR_BUFFER_FRONTBUFFER);
  grDrawLine(&fxMesa->gWin[v1],&fxMesa->gWin[v2]);
}

static void fxLineSmoothTwoSideFrontBack(GLcontext *ctx, GLuint v1,
					 GLuint v2, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;

  GOURAUD(v1); 
  GOURAUD(v2); 

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  grDepthMask(FXFALSE);
  grRenderBuffer(GR_BUFFER_BACKBUFFER);
  grDrawLine(&fxMesa->gWin[v1],&fxMesa->gWin[v2]);

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  if(ctx->Depth.Mask)
    grDepthMask(FXTRUE);
  grRenderBuffer(GR_BUFFER_FRONTBUFFER);
  grDrawLine(&fxMesa->gWin[v1],&fxMesa->gWin[v2]);
}

static void fxLineFlatFrontBack(GLcontext *ctx, GLuint v1,
				GLuint v2, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GLubyte *Color=ctx->VB->Color[pv];

  grConstantColorValue(FXCOLOR(Color[0], Color[1], Color[2], Color[3]));

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  grDepthMask(FXFALSE);
  grRenderBuffer(GR_BUFFER_BACKBUFFER);
  grDrawLine(&fxMesa->gWin[v1],&fxMesa->gWin[v2]);

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  if(ctx->Depth.Mask)
    grDepthMask(FXTRUE);
  grRenderBuffer(GR_BUFFER_FRONTBUFFER);
  grDrawLine(&fxMesa->gWin[v1],&fxMesa->gWin[v2]);
}

/************************************************************************/

static void fxAALineSmooth(GLcontext *ctx, GLuint v1, GLuint v2, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

  grAADrawLine(&fxMesa->gWin[v1],&fxMesa->gWin[v2]);
}

static void fxAALineSmoothTwoSide(GLcontext *ctx, GLuint v1, GLuint v2, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;

  GOURAUD(v1); 
  GOURAUD(v2); 

  grAADrawLine(&fxMesa->gWin[v1],&fxMesa->gWin[v2]);
}

static void fxAALineFlat(GLcontext *ctx, GLuint v1, GLuint v2, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GLubyte *Color=ctx->VB->Color[pv];

  grConstantColorValue(FXCOLOR(Color[0],Color[1],
			       Color[2],Color[3]));

  fxMesa->gWin[v1].a=fxMesa->gWin[v2].a=(float)Color[3];

  grAADrawLine(&fxMesa->gWin[v1],&fxMesa->gWin[v2]);
}

/************************************************************************/

line_func fxDDChooseLineFunction(GLcontext *ctx)
{
  if((ctx->Line.Width!=1.0f) ||
     (ctx->Line.StippleFlag))
    return NULL;

  if(ctx->Line.SmoothFlag) {
    if(ctx->Light.ShadeModel==GL_SMOOTH) {
      if(ctx->Light.Model.TwoSide)
	return fxAALineSmoothTwoSide;

      return fxAALineSmooth;
    }

    return fxAALineFlat;
  }

  if(ctx->RasterMask & FRONT_AND_BACK_BIT) {
    if(ctx->Light.ShadeModel==GL_SMOOTH) {
      if(ctx->Light.Model.TwoSide)
	return fxLineSmoothTwoSideFrontBack;

      return fxLineSmoothFrontBack;
    }

    return fxLineFlatFrontBack;
  }

  if(ctx->Light.ShadeModel==GL_SMOOTH) {
    if(ctx->Light.Model.TwoSide)
      return fxLineSmoothTwoSide;

    return fxLineSmooth;
  }

  return fxLineFlat;
}


#else


/*
 * Need this to provide at least one external definition.
 */

int gl_fx_dummy_function_lines(void)
{
  return 0;
}

#endif  /* FX */
