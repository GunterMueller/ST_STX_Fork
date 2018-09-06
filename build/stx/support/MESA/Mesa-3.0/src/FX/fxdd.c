/* -*- mode: C; tab-width:8;  -*-

             fxdd.c - 3Dfx VooDoo Mesa device driver functions
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

/**********************************************************************/
/*****                 Miscellaneous functions                    *****/
/**********************************************************************/

/* Enalbe/Disable dithering */
void fxDDDither(GLcontext *ctx, GLboolean enable)
{
#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxDDDither()\n");
#endif

  if(enable)
    grDitherMode(GR_DITHER_4x4);
  else
    grDitherMode(GR_DITHER_DISABLE);
}


/* Return buffer size information */
void fxDDBufferSize(GLcontext *ctx, GLuint *width, GLuint *height)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxDDBufferSize(...) Start\n");
#endif

  *width=fxMesa->width;
  *height=fxMesa->height;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxDDBufferSize(...) End\n");
#endif
}


/* Set current drawing color */
static void fxDDSetColor(GLcontext *ctx, GLubyte red, GLubyte green,
			 GLubyte blue, GLubyte alpha )
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxDDSetColor(%d,%d,%d,%d)\n",red,green,blue,alpha);
#endif

  fxMesa->color=FXCOLOR(red,green,blue,alpha);
}


/* Implements glClearColor() */
static void fxDDClearColor(GLcontext *ctx, GLubyte red, GLubyte green,
			   GLubyte blue, GLubyte alpha )
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxDDClearColor(%d,%d,%d,%d)\n",red,green,blue,alpha);
#endif
 
  fxMesa->clearC=FXCOLOR(red,green,blue,255);
  fxMesa->clearA=alpha;
}


/* Clear the color and/or depth buffers */
static GLbitfield fxDDClear(GLcontext *ctx, GLbitfield mask, GLboolean all,
			    GLint x, GLint y, GLint width, GLint height )
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GLbitfield newmask;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxDDClear(%d,%d,%d,%d)\n",x,y,width,height);
#endif

  switch(mask & (GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT)) {
  case (GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT):
    /* clear color and depth buffer */

    grDepthMask(FXTRUE);
    grColorMask(FXTRUE,FXFALSE);

    if(ctx->RasterMask & FRONT_AND_BACK_BIT) {
      grRenderBuffer(GR_BUFFER_BACKBUFFER);
      grBufferClear(fxMesa->clearC, fxMesa->clearA,
		    (FxU16)(ctx->Depth.Clear*0xffff));
      grRenderBuffer(GR_BUFFER_FRONTBUFFER);

    }
    grBufferClear(fxMesa->clearC, fxMesa->clearA,
		  (FxU16)(ctx->Depth.Clear*0xffff));

    if(!ctx->Depth.Mask)
      grDepthMask(FXFALSE);
    if(ctx->Color.ColorMask)
      grColorMask(FXTRUE,FXFALSE);
    else
      grColorMask(FXFALSE,FXFALSE);

    newmask=mask & (~(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT));
    break;
  case (GL_COLOR_BUFFER_BIT):
    /* clear color buffer */
    grDepthMask(FXFALSE);
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);

    if(ctx->RasterMask & FRONT_AND_BACK_BIT) {
      grRenderBuffer(GR_BUFFER_BACKBUFFER);
      grBufferClear(fxMesa->clearC, fxMesa->clearA, 0);
      grRenderBuffer(GR_BUFFER_FRONTBUFFER);
	
    }
    grBufferClear(fxMesa->clearC, fxMesa->clearA, 0);

    if(ctx->Depth.Mask)
      grDepthMask(FXTRUE);
    if(ctx->Color.ColorMask)
      grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
    else
      grColorMask(FXFALSE,FXFALSE);

    newmask=mask & (~(GL_COLOR_BUFFER_BIT));
    break;
  case (GL_DEPTH_BUFFER_BIT):
    /* clear depth buffer */
    grDepthMask(FXTRUE);
    grColorMask(FXFALSE,FXFALSE);
    grBufferClear(fxMesa->clearC, fxMesa->clearA,
		  (FxU16)(ctx->Depth.Clear*0xffff));
    if(!ctx->Depth.Mask)
      grDepthMask(FXFALSE);
    if(ctx->Color.ColorMask)
      grColorMask(FXTRUE,FXFALSE);

    newmask=mask & (~(GL_DEPTH_BUFFER_BIT));
    break;
  default:
    newmask=mask;
    break;
  }
   
  return newmask;
}


/*  Set the buffer used in double buffering */
static GLboolean fxDDSetBuffer(GLcontext *ctx, GLenum mode )
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxDDSetBuffer(%x)\n",mode);
#endif

  if(fxMesa->haveDoubleBuffer) {
    if((mode==GL_FRONT) || (mode==GL_FRONT_AND_BACK))
      fxMesa->currentFB=GR_BUFFER_FRONTBUFFER;
    else if(mode==GL_BACK)
      fxMesa->currentFB=GR_BUFFER_BACKBUFFER;
    else
      return GL_FALSE;
  } else {
    if(mode==GL_FRONT)
      fxMesa->currentFB=GR_BUFFER_FRONTBUFFER;
    else
      return GL_FALSE;
  }

  grRenderBuffer(fxMesa->currentFB);

  return GL_TRUE;
}


static GLboolean fxDDDrawBitMap(GLcontext *ctx, GLint px, GLint py,
				GLsizei width, GLsizei height,
				const struct gl_pixelstore_attrib *unpack,
				const GLubyte *bitmap)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  FxU16 *p;
  GrLfbInfo_t info;
  const GLubyte *pb;
  int x,y;
  GLint r,g,b,a,scrwidth,scrheight,stride;
  FxU16 color;

  /* TODO: with a little work, these bitmap unpacking parameter restrictions
   * could be removed.
   */
  if((unpack->Alignment!=1) ||
     (unpack->RowLength!=0) ||
     (unpack->SkipPixels!=0) ||
     (unpack->SkipRows!=0) ||
     (unpack->SwapBytes) ||
     (unpack->LsbFirst))
     return GL_FALSE;

#define ISCLIPPED(rx) ( ((rx)<0) || ((rx)>=scrwidth) )
#define DRAWBIT(i) {	   \
  if(!ISCLIPPED(x+px))	   \
    if( (*pb) & (1<<(i)) ) \
      (*p)=color;	   \
  p++;                     \
  x++;			   \
  if(x>=width) {           \
    pb++;                  \
    break;                 \
  }                        \
}

  scrwidth=fxMesa->width;
  scrheight=fxMesa->height;

  if((px>=scrwidth) || (px+width<=0) || (py>=scrheight) || (py+height<=0))
    return GL_TRUE;

  pb=bitmap;

  if(py<0) {
    pb+=(height*(-py)) >> (3+1);
    height+=py;
    py=0;
  }

  if(py+height>=scrheight)
    height-=(py+height)-scrheight;

  info.size=sizeof(info);
  if(!grLfbLock(GR_LFB_WRITE_ONLY,
		fxMesa->currentFB,
		GR_LFBWRITEMODE_565,
		GR_ORIGIN_UPPER_LEFT,
		FXFALSE,
		&info)) {
#ifndef FX_SILENT
    fprintf(stderr,"fx Driver: error locking the linear frame buffer\n");
#endif
    return GL_TRUE;
  }

  r=(GLint)(ctx->Current.RasterColor[0]*255.0f);
  g=(GLint)(ctx->Current.RasterColor[1]*255.0f);
  b=(GLint)(ctx->Current.RasterColor[2]*255.0f);
  a=(GLint)(ctx->Current.RasterColor[3]*255.0f);
  color=(FxU16)
    ( ((FxU16)0xf8 & b) <<(11-3))  |
    ( ((FxU16)0xfc & g) <<(5-3+1)) |
    ( ((FxU16)0xf8 & r) >> 3);

  stride=info.strideInBytes>>1;

  /* This code is a bit slow... */

  for(y=0;y<height;y++) {
    p=((FxU16 *)info.lfbPtr)+px+((scrheight-(y+py))*stride);

    for(x=0;;) {
      DRAWBIT(7);	DRAWBIT(6);	DRAWBIT(5);	DRAWBIT(4);
      DRAWBIT(3);	DRAWBIT(2);	DRAWBIT(1);	DRAWBIT(0);
      pb++;
    }
  }

  grLfbUnlock(GR_LFB_WRITE_ONLY,fxMesa->currentFB);

#undef ISCLIPPED
#undef DRAWBIT

  return GL_TRUE;
}

static void fxDDFinish(GLcontext *ctx)
{
  grSstIdle();
}


static GLint fxDDGetParameteri(const GLcontext *ctx, GLint param)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

  switch(param) {
  case DD_MAX_TEXTURE_SIZE:
    return 256;
  case DD_MAX_TEXTURES:
    if(fxMesa->haveTwoTMUs)
      return 2;
    else
      return 1;
  case DD_HAVE_HARDWARE_FOG:
    return 1;
  case DD_MAX_TEXTURE_COORD_SETS:
    return MAX_TEX_COORD_SETS;
  default:
    fprintf(stderr,"fx Driver: internal error in fxDDGetParameteri(): %x\n",param);
    fxCloseHardware();
    exit(-1);
  }
}


void fxDDSetNearFar(GLcontext *ctx, GLfloat n, GLfloat f)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxDDSetNearFar(%f,%f)\n",n,f);
#endif

  if(fxMesa) {
    if(ctx->NewProjectionMatrix)
      gl_analyze_projection_matrix(ctx);

    if((ctx->ProjectionMatrixType==MATRIX_ORTHO || 
	ctx->ProjectionMatrixType==MATRIX_IDENTITY)
       && ctx->ModelViewMatrixType!=MATRIX_GENERAL
       && (ctx->VB->VertexSizeMask & VERTEX4_BIT)==0)
      fxMesa->wScale=1.0f;
    else
      fxMesa->wScale=fabs(f)/65535.0f;

    /*
     * We need to update fog table because it depends on w 
     * and w is adjusted to the maximum range.
     */

    fxSetupFog(ctx);
  }
}


static const char *fxDDRendererString(void)
{
  static char buf[MAX_NUM_SST][64];

  fxQueryHardware();

  if(glbHWConfig.SSTs[glbCurrentBoard].type==GR_SSTTYPE_VOODOO)
    sprintf(buf[glbCurrentBoard],"Glide v0.29 Voodoo_Graphics %d CARD/%d FB/%d TM/%d TMU/%s",
	    glbCurrentBoard,

	    (glbHWConfig.SSTs[glbCurrentBoard].sstBoard.VoodooConfig.sliDetect ?
	     (glbHWConfig.SSTs[glbCurrentBoard].sstBoard.VoodooConfig.fbRam*2) :
	     glbHWConfig.SSTs[glbCurrentBoard].sstBoard.VoodooConfig.fbRam),

	    glbHWConfig.SSTs[glbCurrentBoard].sstBoard.VoodooConfig.tmuConfig[GR_TMU0].tmuRam+
	    ((glbHWConfig.SSTs[glbCurrentBoard].sstBoard.VoodooConfig.nTexelfx>1) ?
	     glbHWConfig.SSTs[glbCurrentBoard].sstBoard.VoodooConfig.tmuConfig[GR_TMU1].tmuRam :
	     0),

	    glbHWConfig.SSTs[glbCurrentBoard].sstBoard.VoodooConfig.nTexelfx,

	    (glbHWConfig.SSTs[glbCurrentBoard].sstBoard.VoodooConfig.sliDetect ? "SLI" : "NOSLI")
	    );
  else {
    if(glbHWConfig.SSTs[glbCurrentBoard].type==GR_SSTTYPE_SST96)
      sprintf(buf[glbCurrentBoard],"Glide v0.29 Voodoo_Rush %d CARD/%d FB/%d TM/%d TMU/NOSLI",
	      glbCurrentBoard,

	      glbHWConfig.SSTs[glbCurrentBoard].sstBoard.SST96Config.fbRam,
	      
	      glbHWConfig.SSTs[glbCurrentBoard].sstBoard.SST96Config.tmuConfig.tmuRam,

	      glbHWConfig.SSTs[glbCurrentBoard].sstBoard.SST96Config.nTexelfx	      
	      );
    else
      strcpy(buf[glbCurrentBoard],"Glide v0.29 UNKNOWN");
  }

  return buf[glbCurrentBoard];
}


static const char *fxDDExtensionsString(GLcontext *ctx)
{
  static char *extensions="GL_EXT_blend_color GL_EXT_blend_minmax GL_EXT_blend_logic_op GL_EXT_blend_subtract GL_EXT_paletted_texture GL_EXT_point_parameters GL_EXT_polygon_offset GL_EXT_vertex_array GL_EXT_texture_object GL_EXT_texture3D GL_MESA_window_pos GL_MESA_resize_buffers GL_EXT_shared_texture_palette GL_EXT_rescale_normal GL_EXT_abgr GL_SGIS_texture_edge_clamp GL_SGIS_multitexture GL_EXT_multitexture 3DFX_set_global_palette GL_FXMESA_global_texture_lod_bias";

  return extensions;
}

/************************************************************************/
/************************************************************************/
/************************************************************************/

/* This is a no-op, since the z-buffer is in hardware */
static void fxAllocDepthBuffer(GLcontext *ctx)
{
#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxAllocDepthBuffer()\n");
#endif
}

/************************************************************************/
/************************************************************************/
/************************************************************************/

/* Check if the hardware supports the current context */
static GLboolean fxIsInHardware(GLcontext *ctx)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

  if((ctx->RasterMask & STENCIL_BIT) ||
     ((ctx->Color.BlendEnabled) && (ctx->Color.BlendEquation!=GL_FUNC_ADD_EXT)) ||
     ((ctx->Color.ColorLogicOpEnabled) && (ctx->Color.LogicOp!=GL_COPY)) ||
     (ctx->Light.Model.ColorControl==GL_SEPARATE_SPECULAR_COLOR) ||
     (!((ctx->Color.ColorMask[0]==ctx->Color.ColorMask[1]) &&
	(ctx->Color.ColorMask[1]==ctx->Color.ColorMask[2]) &&
	(ctx->Color.ColorMask[2]==ctx->Color.ColorMask[3])))
     )
    return GL_FALSE;

  /* Unsupported texture/multitexture cases */

  if(fxMesa->haveTwoTMUs) {
    if((ctx->Texture.Enabled & (TEXTURE0_3D | TEXTURE1_3D)) ||
       /* Not very well written ... */
       ((ctx->Texture.Enabled & (TEXTURE0_1D | TEXTURE1_1D)) && 
	((ctx->Texture.Enabled & (TEXTURE0_2D | TEXTURE1_2D))!=(TEXTURE0_2D | TEXTURE1_2D)))
       )
      return GL_FALSE;

    if((ctx->Texture.Enabled & TEXTURE0_2D) &&
       ctx->Texture.Set[0].Current2D->Complete &&
       (ctx->Texture.Set[0].EnvMode==GL_BLEND))
      return GL_FALSE;

    if((ctx->Texture.Enabled & TEXTURE1_2D) &&
       ctx->Texture.Set[1].Current2D->Complete &&
       (ctx->Texture.Set[1].EnvMode==GL_BLEND))
      return GL_FALSE;

    if((ctx->Texture.Enabled & (TEXTURE0_1D | TEXTURE0_2D | TEXTURE0_3D)) &&
       (ctx->Texture.Enabled & (TEXTURE1_1D | TEXTURE1_2D | TEXTURE1_3D)) &&
       ((ctx->Texture.Set[0].EnvMode!=GL_MODULATE) ||
	(ctx->Texture.Set[1].EnvMode!=GL_MODULATE)))
      return GL_FALSE;
  } else {
    if((ctx->Texture.Enabled & (TEXTURE1_1D | TEXTURE1_2D | TEXTURE1_3D)) ||
       /* Not very well written ... */
       ((ctx->Texture.Enabled & TEXTURE0_1D) && 
	(!(ctx->Texture.Enabled & TEXTURE0_2D)))
       )
      return GL_FALSE;

    
    if((ctx->Texture.Enabled & TEXTURE0_2D) &&
       ctx->Texture.Set[0].Current2D->Complete &&
       (ctx->Texture.Set[0].EnvMode==GL_BLEND))
      return GL_FALSE;
  }

  return GL_TRUE;
}

static void fxDDUpdateDDPointers(GLcontext *ctx)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxDDUpdateDDPointers(...)\n");
#endif

  if(fxIsInHardware(ctx)) {
    /* acc. functions */

    if(ctx->NewState==NEW_DRVSTATE0) {
      /* Only texture changed */
      fxSetupTexture(ctx);

      ctx->Driver.PointsFunc=fxMesa->PointsFunc;
      ctx->Driver.LineFunc=fxMesa->LineFunc;
      ctx->Driver.TriangleFunc=fxMesa->TriangleFunc;
      ctx->Driver.QuadFunc=fxMesa->QuadFunc;
      ctx->Driver.RenderVB=fxMesa->RenderVB;
    } else {
      fxSetupFXUnits(ctx);

      ctx->Driver.PointsFunc=fxMesa->PointsFunc=fxDDChoosePointsFunction(ctx);
      ctx->Driver.LineFunc=fxMesa->LineFunc=fxDDChooseLineFunction(ctx);
      ctx->Driver.TriangleFunc=fxMesa->TriangleFunc=fxDDChooseTriangleFunction(ctx);
      ctx->Driver.QuadFunc=fxMesa->QuadFunc=fxDDChooseQuadFunction(ctx);
      ctx->Driver.RenderVB=fxMesa->RenderVB=fxDDChooseRenderVBFunction(ctx);
    }

    ctx->Driver.RasterSetup=fxDDChooseSetupFunction(ctx);
  } else {
    ctx->Driver.PointsFunc=NULL;
    ctx->Driver.LineFunc=NULL;
    ctx->Driver.TriangleFunc=NULL;
    ctx->Driver.QuadFunc=NULL;
    ctx->Driver.RenderVB=NULL;
    ctx->Driver.RasterSetup=NULL;
  }

  ctx->Driver.AllocDepthBuffer=fxAllocDepthBuffer;

  fxUpdateDDSpanPointers(ctx);
}


void fxSetupDDPointers(GLcontext *ctx)
{
#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxSetupDDPointers()\n");
#endif

  ctx->Driver.UpdateState=fxDDUpdateDDPointers;
         
  ctx->Driver.RendererString=fxDDRendererString;
  ctx->Driver.ExtensionString=fxDDExtensionsString;

  ctx->Driver.Dither=fxDDDither;

  ctx->Driver.NearFar=fxDDSetNearFar;

  ctx->Driver.GetParameteri=fxDDGetParameteri;

  ctx->Driver.ClearIndex=NULL;
  ctx->Driver.ClearColor=fxDDClearColor;
  ctx->Driver.Clear=fxDDClear;

  ctx->Driver.Index=NULL;
  ctx->Driver.Color=fxDDSetColor;

  ctx->Driver.SetBuffer=fxDDSetBuffer;
  ctx->Driver.GetBufferSize=fxDDBufferSize;

  ctx->Driver.Bitmap=fxDDDrawBitMap;
  ctx->Driver.DrawPixels=NULL;

  ctx->Driver.Finish=fxDDFinish;
  ctx->Driver.Flush=NULL;

  ctx->Driver.TexEnv=fxDDTexEnv;
  ctx->Driver.TexImage=fxDDTexImg;
  ctx->Driver.TexSubImage=fxDDTexSubImg;
  ctx->Driver.TexParameter=fxDDTexParam;
  ctx->Driver.BindTexture=fxDDTexBind;
  ctx->Driver.DeleteTexture=fxDDTexDel;
  ctx->Driver.UpdateTexturePalette=fxDDTexPalette;
  ctx->Driver.UseGlobalTexturePalette=fxDDTexUseGlbPalette;

  ctx->Driver.RectFunc=NULL;

  fxSetupDDSpanPointers(ctx);

  fxDDUpdateDDPointers(ctx);
}


#else


/*
 * Need this to provide at least one external definition.
 */

int gl_fx_dummy_function_dd(void)
{
  return 0;
}

#endif  /* FX */
