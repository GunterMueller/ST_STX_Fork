/* -*- mode: C; tab-width:8;  -*-

             fxpoints.c - 3Dfx VooDoo point/line/triangle/quad functions 
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

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "fxdrv.h"

/************************************************************************/
/************************* Points functions *****************************/
/************************************************************************/

static void fxPointSmooth(GLcontext *ctx, GLuint first, GLuint last)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;
  GLuint i;

  if(ctx->VB->MonoColor) {
    if(!VB->ClipOrMask)
      for(i=first;i<=last;i++)
	grDrawPoint(&fxMesa->gWin[i]);
    else
      for(i=first;i<=last;i++)
	if(VB->ClipMask[i]==0)
	  grDrawPoint(&fxMesa->gWin[i]);
  } else {
    if(!VB->ClipOrMask)
      for(i=first;i<=last;i++)
	grDrawPoint(&fxMesa->gWin[i]);
    else
      for(i=first;i<=last;i++)
	if(VB->ClipMask[i]==0)
	  grDrawPoint(&fxMesa->gWin[i]);
  }
}


static void fxPointFlat(GLcontext *ctx, GLuint first, GLuint last)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;
  GLuint i;

  if(ctx->VB->MonoColor) {
    grConstantColorValue(fxMesa->color);

    if(!VB->ClipOrMask)
      for(i=first;i<=last;i++)
	grDrawPoint(&fxMesa->gWin[i]);
    else
      for(i=first;i<=last;i++)
	if(VB->ClipMask[i]==0)
	  grDrawPoint(&fxMesa->gWin[i]);
  } else {
    if(!VB->ClipOrMask) {
      for(i=first;i<=last;i++) {
	grConstantColorValue(FXCOLOR(VB->Color[i][0],VB->Color[i][1],
				     VB->Color[i][2],VB->Color[i][3]));
	grDrawPoint(&fxMesa->gWin[i]);
      }
    } else {
      for(i=first;i<=last;i++) {
	if(VB->ClipMask[i]==0) {
	  grConstantColorValue(FXCOLOR(VB->Color[i][0],VB->Color[i][1],
				       VB->Color[i][2],VB->Color[i][3]));
	  grDrawPoint(&fxMesa->gWin[i]);
	}
      }
    }
  }
}

/************************************************************************/

static void fxPointSmoothFrontBack(GLcontext *ctx, GLuint first, GLuint last)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  grDepthMask(FXFALSE);
  grRenderBuffer(GR_BUFFER_BACKBUFFER);
  fxPointSmooth(ctx,first,last);

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  if(ctx->Depth.Mask)
    grDepthMask(FXTRUE);
  grRenderBuffer(GR_BUFFER_FRONTBUFFER);
  fxPointSmooth(ctx,first,last);
}


static void fxPointFlatFrontBack(GLcontext *ctx, GLuint first, GLuint last)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  grDepthMask(FXFALSE);
  grRenderBuffer(GR_BUFFER_BACKBUFFER);
  fxPointFlat(ctx,first,last);

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
  if(ctx->Depth.Mask)
    grDepthMask(FXTRUE);
  grRenderBuffer(GR_BUFFER_FRONTBUFFER);
  fxPointFlat(ctx,first,last);
}

/************************************************************************/

static void fxAAPoint(GLcontext *ctx, GLuint first, GLuint last)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;
  GLuint i;

  if(ctx->Light.ShadeModel==GL_SMOOTH) {
    if(!VB->ClipOrMask)
      for(i=first;i<=last;i++)
	grAADrawPoint(&fxMesa->gWin[i]);
    else
      for(i=first;i<=last;i++)
	if(VB->ClipMask[i]==0)
	  grAADrawPoint(&fxMesa->gWin[i]);
  } else {
    if(!VB->ClipOrMask) {
      for(i=first;i<=last;i++) {
	grConstantColorValue(FXCOLOR(VB->Color[i][0],VB->Color[i][1],
				     VB->Color[i][2],VB->Color[i][3]));	

	fxMesa->gWin[i].a=(float)VB->Color[i][3];

	grAADrawPoint(&fxMesa->gWin[i]);
      }
    } else {
      for(i=first;i<=last;i++) {
	if(VB->ClipMask[i]==0) {
	  grConstantColorValue(FXCOLOR(VB->Color[i][0],VB->Color[i][1],
				       VB->Color[i][2],VB->Color[i][3]));

	  fxMesa->gWin[i].a=(float)VB->Color[i][3];

	  grAADrawPoint(&fxMesa->gWin[i]);
	}
      }
    }
  }
}

/************************************************************************/

points_func fxDDChoosePointsFunction(GLcontext *ctx)
{
  if((ctx->Point.Size!=1.0f) ||
     (!(ctx->Point.Params[0]==1.0 && 
	ctx->Point.Params[1]==0.0 && 
	ctx->Point.Params[2]==0.0))
     )
    return NULL;

  if(ctx->Point.SmoothFlag)
    return fxAAPoint;

  if(ctx->RasterMask & FRONT_AND_BACK_BIT) {
    if(ctx->Light.ShadeModel==GL_SMOOTH)
      return fxPointSmoothFrontBack;
    
    return fxPointFlatFrontBack;
  }

  if(ctx->Light.ShadeModel==GL_SMOOTH)
    return fxPointSmooth;

  return fxPointFlat;
}


#else


/*
 * Need this to provide at least one external definition.
 */

int gl_fx_dummy_function_points(void)
{
  return 0;
}

#endif  /* FX */
