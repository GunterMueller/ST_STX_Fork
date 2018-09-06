/* -*- mode: C; tab-width:8;  -*-

             fxquads.c - 3Dfx VooDoo quad functions 
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
/************************* Quads functions ******************************/
/************************************************************************/

#define GOURAUD(v) { \
  fxMesa->gWin[(v)].r=(float) VB->Color[(v)][0]; \
  fxMesa->gWin[(v)].g=(float) VB->Color[(v)][1]; \
  fxMesa->gWin[(v)].b=(float) VB->Color[(v)][2]; \
  fxMesa->gWin[(v)].a=(float) VB->Color[(v)][3]; \
}

/************************************************************************/

static void fxQuadSmooth(GLcontext *ctx, GLuint v1, GLuint v2,
			 GLuint v3, GLuint v4, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GrVertex *grv2,*grv4;

  grv2=&fxMesa->gWin[v2];
  grv4=&fxMesa->gWin[v4];

  grDrawTriangle(&fxMesa->gWin[v1], grv2, grv4);
  grDrawTriangle(grv2, &fxMesa->gWin[v3], grv4);
}

static void fxQuadSmoothTwoSide(GLcontext *ctx, GLuint v1, GLuint v2,
				GLuint v3, GLuint v4, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;
  GrVertex *grv2,*grv4;

  GOURAUD(v1); 
  GOURAUD(v2); 
  GOURAUD(v3); 
  GOURAUD(v4); 

  grv2=&fxMesa->gWin[v2];
  grv4=&fxMesa->gWin[v4];

  grDrawTriangle(&fxMesa->gWin[v1], grv2, grv4);
  grDrawTriangle(grv2, &fxMesa->gWin[v3], grv4);
}

static void fxQuadFlat(GLcontext *ctx, GLuint v1, GLuint v2,
		       GLuint v3,GLuint v4, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GLubyte *Color=ctx->VB->Color[pv];
  GrVertex *grv2,*grv4;

  grConstantColorValue(FXCOLOR(Color[0], Color[1], Color[2], Color[3]));

  grv2=&fxMesa->gWin[v2];
  grv4=&fxMesa->gWin[v4];

  grDrawTriangle(&fxMesa->gWin[v1], grv2, grv4);
  grDrawTriangle(grv2, &fxMesa->gWin[v3], grv4);
}

/************************************************************************/

static void fxQuadSmoothFrontBack(GLcontext *ctx, GLuint v1, GLuint v2,
				  GLuint v3, GLuint v4, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GrVertex *grv2,*grv4;

  grv2=&fxMesa->gWin[v2];
  grv4=&fxMesa->gWin[v4];

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  grDepthMask(FXFALSE);
  grRenderBuffer(GR_BUFFER_BACKBUFFER);
  grDrawTriangle(&fxMesa->gWin[v1], grv2, grv4);
  grDrawTriangle(grv2, &fxMesa->gWin[v3], grv4);

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  if(ctx->Depth.Mask)
    grDepthMask(FXTRUE);
  grRenderBuffer(GR_BUFFER_FRONTBUFFER);
  grDrawTriangle(&fxMesa->gWin[v1], grv2, grv4);
  grDrawTriangle(grv2, &fxMesa->gWin[v3], grv4);
}

static void fxQuadSmoothTwoSideFrontBack(GLcontext *ctx, GLuint v1, GLuint v2,
					 GLuint v3, GLuint v4, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;
  GrVertex *grv2,*grv4;

  GOURAUD(v1); 
  GOURAUD(v2); 
  GOURAUD(v3); 
  GOURAUD(v4); 

  grv2=&fxMesa->gWin[v2];
  grv4=&fxMesa->gWin[v4];

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  grDepthMask(FXFALSE);
  grRenderBuffer(GR_BUFFER_BACKBUFFER);
  grDrawTriangle(&fxMesa->gWin[v1], grv2, grv4);
  grDrawTriangle(grv2, &fxMesa->gWin[v3], grv4);

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  if(ctx->Depth.Mask)
    grDepthMask(FXTRUE);
  grRenderBuffer(GR_BUFFER_FRONTBUFFER);
  grDrawTriangle(&fxMesa->gWin[v1], grv2, grv4);
  grDrawTriangle(grv2, &fxMesa->gWin[v3], grv4);
}

static void fxQuadFlatFrontBack(GLcontext *ctx, GLuint v1, GLuint v2,
				GLuint v3,GLuint v4, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GLubyte *Color=ctx->VB->Color[pv];
  GrVertex *grv2,*grv4;

  grConstantColorValue(FXCOLOR(Color[0], Color[1], Color[2], Color[3]));

  grv2=&fxMesa->gWin[v2];
  grv4=&fxMesa->gWin[v4];

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  grDepthMask(FXFALSE);
  grRenderBuffer(GR_BUFFER_BACKBUFFER);
  grDrawTriangle(&fxMesa->gWin[v1], grv2, grv4);
  grDrawTriangle(grv2, &fxMesa->gWin[v3], grv4);

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  if(ctx->Depth.Mask)
    grDepthMask(FXTRUE);
  grRenderBuffer(GR_BUFFER_FRONTBUFFER);
  grDrawTriangle(&fxMesa->gWin[v1], grv2, grv4);
  grDrawTriangle(grv2, &fxMesa->gWin[v3], grv4);
}

/************************************************************************/

static void fxAAQuadSmooth(GLcontext *ctx, GLuint v1, GLuint v2, GLuint v3, GLuint v4, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GrVertex *grv2,*grv4;

  grv2=&fxMesa->gWin[v2];
  grv4=&fxMesa->gWin[v4];

  grAADrawTriangle(&fxMesa->gWin[v1],grv2,grv4,
		   FXTRUE,FXFALSE,FXFALSE);
  grAADrawTriangle(grv2,&fxMesa->gWin[v3],grv4,
		   FXTRUE,FXTRUE,FXFALSE);
}

static void fxAAQuadSmoothTwoSide(GLcontext *ctx, GLuint v1, GLuint v2, GLuint v3, GLuint v4, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;
  GrVertex *grv2,*grv4;

  GOURAUD(v1); 
  GOURAUD(v2); 
  GOURAUD(v3); 
  GOURAUD(v4); 

  grv2=&fxMesa->gWin[v2];
  grv4=&fxMesa->gWin[v4];

  grAADrawTriangle(&fxMesa->gWin[v1],grv2,grv4,
		   FXTRUE,FXFALSE,FXTRUE);
  grAADrawTriangle(grv2,&fxMesa->gWin[v3],grv4,
		   FXTRUE,FXTRUE,FXFALSE);
}

static void fxAAQuadFlat(GLcontext *ctx, GLuint v1, GLuint v2, GLuint v3,GLuint v4, GLuint pv)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GLubyte *Color=ctx->VB->Color[pv];
  GrVertex *grv2,*grv4;

  grConstantColorValue(FXCOLOR(Color[0],Color[1],
			       Color[2],Color[3]));

  fxMesa->gWin[v1].a=fxMesa->gWin[v2].a=fxMesa->gWin[v3].a=fxMesa->gWin[v4].a=(float)Color[3];

  grv2=&fxMesa->gWin[v2];
  grv4=&fxMesa->gWin[v4];

  grAADrawTriangle(&fxMesa->gWin[v1],grv2,grv4,
		   FXTRUE,FXFALSE,FXTRUE);
  grAADrawTriangle(grv2,&fxMesa->gWin[v3],grv4,
		   FXTRUE,FXTRUE,FXFALSE);
}

/************************************************************************/

quad_func fxDDChooseQuadFunction(GLcontext *ctx)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
 
  if((ctx->Polygon.OffsetAny) || /* Not yet supported */
     (ctx->Polygon.StippleFlag))
    return NULL;

  if(ctx->Polygon.SmoothFlag) {
    if(ctx->Light.ShadeModel==GL_SMOOTH) {
      if(ctx->Light.Model.TwoSide)
	return fxAAQuadSmoothTwoSide;

      return fxAAQuadSmooth;
    }

    return fxAAQuadFlat;
  }

  if(ctx->RasterMask & FRONT_AND_BACK_BIT) {
    if(ctx->Light.ShadeModel==GL_SMOOTH) {
      if(ctx->Light.Model.TwoSide)
	return fxQuadSmoothTwoSideFrontBack;

      return fxQuadSmoothFrontBack;
    }

    return fxQuadFlatFrontBack;
  }

  if(ctx->Light.ShadeModel==GL_SMOOTH) {
    if(ctx->Light.Model.TwoSide)
      return fxQuadSmoothTwoSide;

    return fxQuadSmooth;
  }

  return fxQuadFlat;
}


#else


/*
 * Need this to provide at least one external definition.
 */

int gl_fx_dummy_function_quads(void)
{
  return 0;
}

#endif  /* FX */
