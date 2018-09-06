/* -*- mode: C; tab-width:8;  -*-

             fxtris.c - 3Dfx VooDoo triangle functions 
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
/*********************** Triangle functions *****************************/
/************************************************************************/

#define GOURAUD(v) { \
  fxMesa->gWin[(v)].r=(float) VB->Color[(v)][0]; \
  fxMesa->gWin[(v)].g=(float) VB->Color[(v)][1]; \
  fxMesa->gWin[(v)].b=(float) VB->Color[(v)][2]; \
  fxMesa->gWin[(v)].a=(float) VB->Color[(v)][3]; \
}

/************************************************************************/

static void fxTriangleSmooth(GLcontext *ctx, GLuint v1, GLuint v2, GLuint v3, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

  grDrawTriangle(&fxMesa->gWin[v1], &fxMesa->gWin[v2], &fxMesa->gWin[v3]);
}

static void fxTriangleSmoothTwoSide(GLcontext *ctx, GLuint v1, GLuint v2, GLuint v3, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;

  GOURAUD(v1); 
  GOURAUD(v2); 
  GOURAUD(v3); 

  grDrawTriangle(&fxMesa->gWin[v1], &fxMesa->gWin[v2], &fxMesa->gWin[v3]);
}

static void fxTriangleFlat(GLcontext *ctx, GLuint v1, GLuint v2, GLuint v3, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GLubyte *Color=ctx->VB->Color[pv];

  grConstantColorValue(FXCOLOR(Color[0], Color[1], Color[2], Color[3]));

  grDrawTriangle(&fxMesa->gWin[v1], &fxMesa->gWin[v2], &fxMesa->gWin[v3]);
}

/************************************************************************/

static void fxTriangleSmoothFrontBack(GLcontext *ctx, GLuint v1,
				      GLuint v2, GLuint v3, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  grDepthMask(FXFALSE);
  grRenderBuffer(GR_BUFFER_BACKBUFFER);
  grDrawTriangle(&fxMesa->gWin[v1], &fxMesa->gWin[v2], &fxMesa->gWin[v3]);

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  if(ctx->Depth.Mask)
    grDepthMask(FXTRUE);
  grRenderBuffer(GR_BUFFER_FRONTBUFFER);
  grDrawTriangle(&fxMesa->gWin[v1], &fxMesa->gWin[v2], &fxMesa->gWin[v3]);
}

static void fxTriangleSmoothTwoSideFrontBack(GLcontext *ctx, GLuint v1,
					     GLuint v2, GLuint v3, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;

  GOURAUD(v1); 
  GOURAUD(v2); 
  GOURAUD(v3); 

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  grDepthMask(FXFALSE);
  grRenderBuffer(GR_BUFFER_BACKBUFFER);
  grDrawTriangle(&fxMesa->gWin[v1], &fxMesa->gWin[v2], &fxMesa->gWin[v3]);

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  if(ctx->Depth.Mask)
    grDepthMask(FXTRUE);
  grRenderBuffer(GR_BUFFER_FRONTBUFFER);
  grDrawTriangle(&fxMesa->gWin[v1], &fxMesa->gWin[v2], &fxMesa->gWin[v3]);
}

static void fxTriangleFlatFrontBack(GLcontext *ctx, GLuint v1,
				    GLuint v2, GLuint v3, GLuint pv)
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
  grDrawTriangle(&fxMesa->gWin[v1], &fxMesa->gWin[v2], &fxMesa->gWin[v3]);

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  if(ctx->Depth.Mask)
    grDepthMask(FXTRUE);
  grRenderBuffer(GR_BUFFER_FRONTBUFFER);
  grDrawTriangle(&fxMesa->gWin[v1], &fxMesa->gWin[v2], &fxMesa->gWin[v3]);
}

/************************************************************************/

static void fxAATriangleSmooth(GLcontext *ctx, GLuint v1, GLuint v2, GLuint v3, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

  grAADrawTriangle(&fxMesa->gWin[v1],&fxMesa->gWin[v2],&fxMesa->gWin[v3],
		   FXTRUE,FXTRUE,FXTRUE);
}

static void fxAATriangleSmoothTwoSide(GLcontext *ctx, GLuint v1, GLuint v2, GLuint v3, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;

  GOURAUD(v1); 
  GOURAUD(v2); 
  GOURAUD(v3); 

  grAADrawTriangle(&fxMesa->gWin[v1],&fxMesa->gWin[v2],&fxMesa->gWin[v3],
		   FXTRUE,FXTRUE,FXTRUE);
}

static void fxAATriangleFlat(GLcontext *ctx, GLuint v1, GLuint v2, GLuint v3, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GLubyte *Color=ctx->VB->Color[pv];

  grConstantColorValue(FXCOLOR(Color[0],Color[1],
			       Color[2],Color[3]));

  fxMesa->gWin[v1].a=fxMesa->gWin[v2].a=fxMesa->gWin[v3].a=(float)Color[3];

  grAADrawTriangle(&fxMesa->gWin[v1],&fxMesa->gWin[v2],&fxMesa->gWin[v3],
		   FXTRUE,FXTRUE,FXTRUE);
}

/************************************************************************/

triangle_func fxDDChooseTriangleFunction(GLcontext *ctx)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
 
  if((ctx->Polygon.OffsetAny) || /* Not yet supported */
     (ctx->Polygon.StippleFlag))
    return NULL;

  if(ctx->Polygon.SmoothFlag) {
    if(ctx->Light.ShadeModel==GL_SMOOTH) {
      if(ctx->Light.Model.TwoSide)
	return fxAATriangleSmoothTwoSide;

      return fxAATriangleSmooth;
    }

    return fxAATriangleFlat;
  }

  if(ctx->RasterMask & FRONT_AND_BACK_BIT) {
    if(ctx->Light.ShadeModel==GL_SMOOTH) {
      if(ctx->Light.Model.TwoSide)
	return fxTriangleSmoothTwoSideFrontBack;
      
      return fxTriangleSmoothFrontBack;
    }

    return fxTriangleFlatFrontBack;
  }

  if(ctx->Light.ShadeModel==GL_SMOOTH) {
    if(ctx->Light.Model.TwoSide)
      return fxTriangleSmoothTwoSide;

    return fxTriangleSmooth;
  }

  return fxTriangleFlat;
}


#else


/*
 * Need this to provide at least one external definition.
 */

int gl_fx_dummy_function_tris(void)
{
  return 0;
}

#endif  /* FX */
