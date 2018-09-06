/* -*- mode: C; tab-width:8;  -*-

             fxsetup.c - 3Dfx VooDoo rendering mode setup functions
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

static void fxTexValidate(GLcontext *ctx, struct gl_texture_object *tObj)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  tfxTexInfo *ti=(tfxTexInfo *)tObj->DriverData;
  GLint minl,maxl;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxTexValidate(...) Start\n");
#endif

  if(ti->validated) {
#if defined(DEBUG_FXMESA)
    fprintf(stderr,"fxmesa: fxTexValidate(...) End (validated=GL_TRUE)\n");
#endif
    return;
  }

  minl=ti->minLevel=tObj->BaseLevel;
  maxl=ti->maxLevel=MIN2(tObj->MaxLevel,tObj->Image[0]->MaxLog2);

  fxTexGetInfo(tObj->Image[minl]->Width,tObj->Image[minl]->Height,
	       &(ti->info.largeLod),&(ti->info.aspectRatio),
	       &(ti->sScale),&(ti->tScale),
	       NULL,NULL);

  if((tObj->MinFilter!=GL_NEAREST) && (tObj->MinFilter!=GL_LINEAR))
    fxTexGetInfo(tObj->Image[maxl]->Width,tObj->Image[maxl]->Height,
		 &(ti->info.smallLod),NULL,
		 NULL,NULL,
		 NULL,NULL);
  else
    ti->info.smallLod=ti->info.largeLod;

  fxTexGetFormat(tObj->Image[minl]->Format,&(ti->info.format),&(ti->baseLevelInternalFormat));

  ti->validated=GL_TRUE;

  ti->info.data=NULL;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxTexValidate(...) End\n");
#endif
}

GLuint fxGetTexSetConfiguration(GLcontext *ctx,
				struct gl_texture_object *tObj0,
				struct gl_texture_object *tObj1)
{
  GLuint unitsmode=0;
  GLuint envmode=0;
  GLuint ifmt=0;

  if((ctx->Light.ShadeModel==GL_SMOOTH) ||
     (ctx->Point.SmoothFlag) ||
     (ctx->Line.SmoothFlag) ||
     (ctx->Polygon.SmoothFlag))
    unitsmode|=FX_UM_ALPHA_ITERATED;
  else
    unitsmode|=FX_UM_ALPHA_CONSTANT;

  if(ctx->Light.ShadeModel==GL_SMOOTH)
    unitsmode|=FX_UM_COLOR_ITERATED;
  else
    unitsmode|=FX_UM_COLOR_CONSTANT;

  if(tObj0) {
    tfxTexInfo *ti0=(tfxTexInfo *)tObj0->DriverData;

    switch(ti0->baseLevelInternalFormat) {
    case GL_ALPHA:
      ifmt|=FX_UM_E0_ALPHA;
      break;
    case GL_LUMINANCE:
      ifmt|=FX_UM_E0_LUMINANCE;
      break;
    case GL_LUMINANCE_ALPHA:
      ifmt|=FX_UM_E0_LUMINANCE_ALPHA;
      break;
    case GL_INTENSITY:
      ifmt|=FX_UM_E0_INTENSITY;
      break;
    case GL_RGB:
      ifmt|=FX_UM_E0_RGB;
      break;
    case GL_RGBA:
      ifmt|=FX_UM_E0_RGBA;
      break;
    }

    switch(ctx->Texture.Set[0].EnvMode) {
    case GL_DECAL:
      envmode|=FX_UM_E0_DECAL;
      break;
    case GL_MODULATE:
      envmode|=FX_UM_E0_MODULATE;
      break;
    case GL_REPLACE:
      envmode|=FX_UM_E0_REPLACE;
      break;
    case GL_BLEND:
      envmode|=FX_UM_E0_BLEND;
      break;
    default:
      /* do nothing */
      break;
    }
  }

  if(tObj1) {
    tfxTexInfo *ti1=(tfxTexInfo *)tObj1->DriverData;

    switch(ti1->baseLevelInternalFormat) {
    case GL_ALPHA:
      ifmt|=FX_UM_E1_ALPHA;
      break;
    case GL_LUMINANCE:
      ifmt|=FX_UM_E1_LUMINANCE;
    break;
    case GL_LUMINANCE_ALPHA:
      ifmt|=FX_UM_E1_LUMINANCE_ALPHA;
      break;
    case GL_INTENSITY:
      ifmt|=FX_UM_E1_INTENSITY;
      break;
    case GL_RGB:
      ifmt|=FX_UM_E1_RGB;
      break;
    case GL_RGBA:
      ifmt|=FX_UM_E1_RGBA;
      break;
    default:
      /* do nothing */
      break;
    }

    switch(ctx->Texture.Set[1].EnvMode) {
    case GL_DECAL:
      envmode|=FX_UM_E1_DECAL;
      break;
    case GL_MODULATE:
      envmode|=FX_UM_E1_MODULATE;
      break;
    case GL_REPLACE:
      envmode|=FX_UM_E1_REPLACE;
      break;
    case GL_BLEND:
      envmode|=FX_UM_E1_BLEND;
      break;
    default:
      /* do nothing */
      break;
    }
  }

  unitsmode|=(ifmt | envmode);

  return unitsmode;
}

/************************************************************************/
/************************* Rendering Mode SetUp *************************/
/************************************************************************/

/************************* Single Texture Set ***************************/

static void fxSetupSingleTMU(fxMesaContext fxMesa, struct gl_texture_object *tObj)
{
  tfxTexInfo *ti=(tfxTexInfo *)tObj->DriverData;

  if(!ti->tmi.isInTM) {
    if(ti->LODblend)
	fxTMMoveInTM(fxMesa,tObj,FX_TMU_SPLIT);
    else {
      if(fxMesa->haveTwoTMUs) {
	if(fxMesa->freeTexMem[FX_TMU0]>grTexTextureMemRequired(GR_MIPMAPLEVELMASK_BOTH,&(ti->info)))
	  fxTMMoveInTM(fxMesa,tObj,FX_TMU0);
	else
	  fxTMMoveInTM(fxMesa,tObj,FX_TMU1);
      } else
	fxTMMoveInTM(fxMesa,tObj,FX_TMU0);
    }
  }

  if(ti->LODblend) {
    if((ti->info.format==GR_TEXFMT_P_8) && (!fxMesa->haveGlobalPaletteTexture)) {
#if defined(DEBUG_FXMESA)
      fprintf(stderr,"fxmesa: uploading texture palette\n");
#endif
      grTexDownloadTable(GR_TMU0,GR_TEXTABLE_PALETTE,&(ti->palette));
      grTexDownloadTable(GR_TMU1,GR_TEXTABLE_PALETTE,&(ti->palette));
    }

    grTexClampMode(GR_TMU0,ti->sClamp,ti->tClamp);
    grTexClampMode(GR_TMU1,ti->sClamp,ti->tClamp);
    grTexFilterMode(GR_TMU0,ti->minFilt,ti->maxFilt);
    grTexFilterMode(GR_TMU1,ti->minFilt,ti->maxFilt);
    grTexMipMapMode(GR_TMU0,ti->mmMode,ti->LODblend);
    grTexMipMapMode(GR_TMU1,ti->mmMode,ti->LODblend);

    grTexSource(GR_TMU0,ti->tmi.tm[FX_TMU0]->startAddress,
		GR_MIPMAPLEVELMASK_ODD,&(ti->info));
    grTexSource(GR_TMU1,ti->tmi.tm[FX_TMU1]->startAddress,
		GR_MIPMAPLEVELMASK_EVEN,&(ti->info));
  } else {
    if((ti->info.format==GR_TEXFMT_P_8) && (!fxMesa->haveGlobalPaletteTexture)) {
#if defined(DEBUG_FXMESA)
      fprintf(stderr,"fxmesa: uploading texture palette\n");
#endif
      grTexDownloadTable(ti->tmi.whichTMU,GR_TEXTABLE_PALETTE,&(ti->palette));
    }

    grTexClampMode(ti->tmi.whichTMU,ti->sClamp,ti->tClamp);
    grTexFilterMode(ti->tmi.whichTMU,ti->minFilt,ti->maxFilt);
    grTexMipMapMode(ti->tmi.whichTMU,ti->mmMode,ti->LODblend);

    grTexSource(ti->tmi.whichTMU,ti->tmi.tm[ti->tmi.whichTMU]->startAddress,
		GR_MIPMAPLEVELMASK_BOTH,&(ti->info));
  }
}

static void fxSelectSingleTMUSrc(fxMesaContext fxMesa, GLint tmu, FxBool LODblend)
{
#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxSelectSingleTMUSrc(%d,%d)\n",tmu,LODblend);
#endif

  if(LODblend) {
    grTexCombine(GR_TMU0,
		 GR_COMBINE_FUNCTION_BLEND,
		 GR_COMBINE_FACTOR_ONE_MINUS_LOD_FRACTION,
		 GR_COMBINE_FUNCTION_BLEND,
		 GR_COMBINE_FACTOR_ONE_MINUS_LOD_FRACTION,
		 FXFALSE,FXFALSE);

    grTexCombine(GR_TMU1,
		 GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		 GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		 FXFALSE,FXFALSE);

    fxMesa->tmuSrc=FX_TMU_SPLIT;
  } else {
    if(tmu==FX_TMU0) {
      grTexCombine(GR_TMU0,
		   GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		   GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		 FXFALSE,FXFALSE);
      
      fxMesa->tmuSrc=FX_TMU0;
    } else {
      grTexCombine(GR_TMU1,
		   GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		   GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		   FXFALSE,FXFALSE);
    
      /* GR_COMBINE_FUNCTION_SCALE_OTHER doesn't work ?!? */
    
      grTexCombine(GR_TMU0,
		   GR_COMBINE_FUNCTION_BLEND,GR_COMBINE_FACTOR_ONE,
		   GR_COMBINE_FUNCTION_BLEND,GR_COMBINE_FACTOR_ONE,
		   FXFALSE,FXFALSE);
    
      fxMesa->tmuSrc=FX_TMU1;
    }
  }
}

static void fxSetupTextureSingleTMU(GLcontext *ctx, GLuint textureset)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GrCombineLocal_t localc,locala;
  GLuint unitsmode;
  GLint ifmt;
  tfxTexInfo *ti;
  struct gl_texture_object *tObj=ctx->Texture.Set[textureset].Current2D;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxSetupTextureSingleTMU(...) Start\n");
#endif

  ti=(tfxTexInfo *)tObj->DriverData;

  fxTexValidate(ctx,tObj);

  fxSetupSingleTMU(fxMesa,tObj);

  if(fxMesa->tmuSrc!=ti->tmi.whichTMU)
    fxSelectSingleTMUSrc(fxMesa,ti->tmi.whichTMU,ti->LODblend);

  if(textureset==0)
    unitsmode=fxGetTexSetConfiguration(ctx,tObj,NULL);
  else
    unitsmode=fxGetTexSetConfiguration(ctx,NULL,tObj);

  if(fxMesa->lastUnitsMode==unitsmode)
    return;

  fxMesa->lastUnitsMode=unitsmode;

  grHints(GR_HINT_STWHINT,0);

  ifmt=ti->baseLevelInternalFormat;

  if(unitsmode & FX_UM_ALPHA_ITERATED)
    locala=GR_COMBINE_LOCAL_ITERATED;
  else
    locala=GR_COMBINE_LOCAL_CONSTANT;

  if(unitsmode & FX_UM_COLOR_ITERATED)
    localc=GR_COMBINE_LOCAL_ITERATED;
  else
    localc=GR_COMBINE_LOCAL_CONSTANT;

  switch(ctx->Texture.Set[textureset].EnvMode) {
  case GL_DECAL:
    grAlphaCombine(GR_COMBINE_FUNCTION_LOCAL,
		   GR_COMBINE_FACTOR_NONE,
		   locala,
		   GR_COMBINE_OTHER_NONE,
		   FXFALSE);

    grColorCombine(GR_COMBINE_FUNCTION_BLEND,
		   GR_COMBINE_FACTOR_TEXTURE_ALPHA,
		   localc,
		   GR_COMBINE_OTHER_TEXTURE,
		   FXFALSE);
    break;
  case GL_MODULATE:
    grAlphaCombine(GR_COMBINE_FUNCTION_SCALE_OTHER,
		   GR_COMBINE_FACTOR_LOCAL,
		   locala,
		   GR_COMBINE_OTHER_TEXTURE,
		   FXFALSE);

    if(ifmt==GL_ALPHA)
      grColorCombine(GR_COMBINE_FUNCTION_LOCAL,
		     GR_COMBINE_FACTOR_NONE,
		     localc,
		     GR_COMBINE_OTHER_NONE,
		     FXFALSE);
    else
      grColorCombine(GR_COMBINE_FUNCTION_SCALE_OTHER,
		     GR_COMBINE_FACTOR_LOCAL,
		     localc,
		     GR_COMBINE_OTHER_TEXTURE,
		     FXFALSE);
    break;
  case GL_BLEND:
#ifndef FX_SILENT
    fprintf(stderr,"fx Driver: GL_BLEND not yet supported\n");
#endif
    /* TO DO (I think that the Voodoo Graphics isn't able to support GL_BLEND) */
    break;
  case GL_REPLACE:
    if((ifmt==GL_RGB) || (ifmt==GL_LUMINANCE))
      grAlphaCombine(GR_COMBINE_FUNCTION_LOCAL,
		     GR_COMBINE_FACTOR_NONE,
		     locala,
		     GR_COMBINE_OTHER_NONE,
		     FXFALSE);
    else
      grAlphaCombine(GR_COMBINE_FUNCTION_SCALE_OTHER,
		     GR_COMBINE_FACTOR_ONE,
		     locala,
		     GR_COMBINE_OTHER_TEXTURE,
		     FXFALSE);
    
    if(ifmt==GL_ALPHA)
      grColorCombine(GR_COMBINE_FUNCTION_LOCAL,
		     GR_COMBINE_FACTOR_NONE,
		     localc,
		     GR_COMBINE_OTHER_NONE,
		     FXFALSE);
    else
      grColorCombine(GR_COMBINE_FUNCTION_SCALE_OTHER,
		     GR_COMBINE_FACTOR_ONE,
		     localc,
		     GR_COMBINE_OTHER_TEXTURE,
		     FXFALSE);
    break;
  default:
#ifndef FX_SILENT
    fprintf(stderr,"fx Driver: %x Texture.EnvMode not yet supported\n",ctx->Texture.Set[textureset].EnvMode);
#endif
    break;
  }

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxSetupTextureSingleTMU(...) End\n");
#endif
}

/************************* Double Texture Set ***************************/

void fxSetupDoubleTMU(fxMesaContext fxMesa, struct gl_texture_object *tObj0,
		      struct gl_texture_object *tObj1)
{
#define T0_NOT_IN_TMU  0x01
#define T1_NOT_IN_TMU  0x02
#define T0_IN_TMU0     0x04
#define T1_IN_TMU0     0x08
#define T0_IN_TMU1     0x10
#define T1_IN_TMU1     0x20

  tfxTexInfo *ti0=(tfxTexInfo *)tObj0->DriverData;
  tfxTexInfo *ti1=(tfxTexInfo *)tObj1->DriverData;
  GLuint tstate=0;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxSetupDoubleTMU(...)\n");
#endif

  if(ti0->tmi.isInTM) {
    if(ti0->tmi.whichTMU==FX_TMU0)
      tstate|=T0_IN_TMU0;
    else if(ti0->tmi.whichTMU==FX_TMU1)
      tstate|=T0_IN_TMU1;
    else {
      fxTMMoveOutTM(fxMesa,tObj0);
      tstate|=T0_NOT_IN_TMU;
    }
  } else
    tstate|=T0_NOT_IN_TMU;

  if(ti1->tmi.isInTM) {
    if(ti1->tmi.whichTMU==FX_TMU0)
      tstate|=T1_IN_TMU0;
    else if(ti1->tmi.whichTMU==FX_TMU1)
      tstate|=T1_IN_TMU1;
    else {
      fxTMMoveOutTM(fxMesa,tObj1);
      tstate|=T1_NOT_IN_TMU;
    }
  } else
    tstate|=T1_NOT_IN_TMU;

  ti0->tmi.lastTimeUsed=fxMesa->texBindNumber;
  ti1->tmi.lastTimeUsed=fxMesa->texBindNumber;

  /* Move texture maps in TMUs */ 

  switch(tstate) {
  case (T0_IN_TMU0 | T1_IN_TMU0):
    fxTMMoveOutTM(fxMesa,tObj1);

    fxTMMoveInTM(fxMesa,tObj1,FX_TMU1);
    break;

  case (T0_IN_TMU1 | T1_IN_TMU1):
    fxTMMoveOutTM(fxMesa,tObj0);

    fxTMMoveInTM(fxMesa,tObj0,FX_TMU0);
    break;

  case (T0_NOT_IN_TMU | T1_NOT_IN_TMU):
    fxTMMoveInTM(fxMesa,tObj0,FX_TMU0);
    fxTMMoveInTM(fxMesa,tObj1,FX_TMU1);
    break;

    /*** T0/T1 ***/

  case (T0_NOT_IN_TMU | T1_IN_TMU0):
    fxTMMoveInTM(fxMesa,tObj0,FX_TMU1);
    break;

  case (T0_NOT_IN_TMU | T1_IN_TMU1):
    fxTMMoveInTM(fxMesa,tObj0,FX_TMU0);
    break;

  case (T0_IN_TMU0 | T1_NOT_IN_TMU):
    fxTMMoveInTM(fxMesa,tObj1,FX_TMU1);
    break;

  case (T0_IN_TMU1 | T1_NOT_IN_TMU):
    fxTMMoveInTM(fxMesa,tObj1,FX_TMU0);
    break;

    /*** Best Case ***/

  case (T0_IN_TMU1 | T1_IN_TMU0):
  case (T0_IN_TMU0 | T1_IN_TMU1):
    break;

  default:
    fprintf(stderr,"fx Driver: internal error in fxSetupDoubleTMU()\n");
    fxCloseHardware();
    exit(-1);
    break;
  }

  if(!fxMesa->haveGlobalPaletteTexture) {
    if(ti0->info.format==GR_TEXFMT_P_8) {
#if defined(DEBUG_FXMESA)
      fprintf(stderr,"fxmesa: uploading texture palette TMU0\n");
#endif
      grTexDownloadTable(ti0->tmi.whichTMU,GR_TEXTABLE_PALETTE,&(ti0->palette));
    }

    if(ti1->info.format==GR_TEXFMT_P_8) {
#if defined(DEBUG_FXMESA)
      fprintf(stderr,"fxmesa: uploading texture palette TMU1\n");
#endif
      grTexDownloadTable(ti1->tmi.whichTMU,GR_TEXTABLE_PALETTE,&(ti1->palette));
    }
  }

  grTexClampMode(ti0->tmi.whichTMU,ti0->sClamp,ti0->tClamp);
  grTexFilterMode(ti0->tmi.whichTMU,ti0->minFilt,ti0->maxFilt);
  grTexMipMapMode(ti0->tmi.whichTMU,ti0->mmMode,FXFALSE);
  grTexSource(ti0->tmi.whichTMU,ti0->tmi.tm[ti0->tmi.whichTMU]->startAddress,
	      GR_MIPMAPLEVELMASK_BOTH,&(ti0->info));

  grTexClampMode(ti1->tmi.whichTMU,ti1->sClamp,ti1->tClamp);
  grTexFilterMode(ti1->tmi.whichTMU,ti1->minFilt,ti1->maxFilt);
  grTexMipMapMode(ti1->tmi.whichTMU,ti1->mmMode,FXFALSE);
  grTexSource(ti1->tmi.whichTMU,ti1->tmi.tm[ti1->tmi.whichTMU]->startAddress,
	      GR_MIPMAPLEVELMASK_BOTH,&(ti1->info));

#undef T0_NOT_IN_TMU
#undef T1_NOT_IN_TMU
#undef T0_IN_TMU0
#undef T1_IN_TMU0
#undef T0_IN_TMU1
#undef T1_IN_TMU1
}

static void fxSetupTextureDoubleTMU(GLcontext *ctx)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GrCombineLocal_t localc,locala;
  tfxTexInfo *ti0,*ti1;
  struct gl_texture_object *tObj0=ctx->Texture.Set[0].Current2D;
  struct gl_texture_object *tObj1=ctx->Texture.Set[1].Current2D;
  GLuint envmode,ifmt,unitsmode;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxSetupTextureDoubleTMU(...) Start\n");
#endif

  ti0=(tfxTexInfo *)tObj0->DriverData;
  fxTexValidate(ctx,tObj0);

  ti1=(tfxTexInfo *)tObj1->DriverData;
  fxTexValidate(ctx,tObj1);

  fxSetupDoubleTMU(fxMesa,tObj0,tObj1);

  unitsmode=fxGetTexSetConfiguration(ctx,tObj0,tObj1);

  if(fxMesa->lastUnitsMode==unitsmode)
    return;

  fxMesa->lastUnitsMode=unitsmode;

  grHints(GR_HINT_STWHINT,GR_STWHINT_ST_DIFF_TMU1);

  envmode=unitsmode & FX_UM_E_ENVMODE;
  ifmt=unitsmode & FX_UM_E_IFMT;

  if(unitsmode & FX_UM_ALPHA_ITERATED)
    locala=GR_COMBINE_LOCAL_ITERATED;
  else
    locala=GR_COMBINE_LOCAL_CONSTANT;

  if(unitsmode & FX_UM_COLOR_ITERATED)
    localc=GR_COMBINE_LOCAL_ITERATED;
  else
    localc=GR_COMBINE_LOCAL_CONSTANT;

  fxMesa->tmuSrc=FX_TMU_BOTH;
  switch(envmode) {
  case (FX_UM_E0_MODULATE | FX_UM_E1_MODULATE):
    {
      GLboolean isalpha[FX_NUM_TMU];

      if(ti0->baseLevelInternalFormat==GL_ALPHA)
	isalpha[ti0->tmi.whichTMU]=GL_TRUE;
      else
	isalpha[ti0->tmi.whichTMU]=GL_FALSE;

      if(ti1->baseLevelInternalFormat==GL_ALPHA)
	isalpha[ti1->tmi.whichTMU]=GL_TRUE;
      else
	isalpha[ti1->tmi.whichTMU]=GL_FALSE;
	
      if(isalpha[FX_TMU1])
	grTexCombine(GR_TMU1,
		     GR_COMBINE_FUNCTION_ZERO,GR_COMBINE_FACTOR_NONE,
		     GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		     FXTRUE,FXFALSE);
      else
	grTexCombine(GR_TMU1,
		     GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		     GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		     FXFALSE,FXFALSE);
    
      if(isalpha[FX_TMU0])
	grTexCombine(GR_TMU0,
		     GR_COMBINE_FUNCTION_BLEND_OTHER,GR_COMBINE_FACTOR_ONE,
		     GR_COMBINE_FUNCTION_BLEND_OTHER,GR_COMBINE_FACTOR_LOCAL,
		     FXFALSE,FXFALSE);
      else
	grTexCombine(GR_TMU0,
		     GR_COMBINE_FUNCTION_BLEND_OTHER,GR_COMBINE_FACTOR_LOCAL,
		     GR_COMBINE_FUNCTION_BLEND_OTHER,GR_COMBINE_FACTOR_LOCAL,
		     FXFALSE,FXFALSE);

      grColorCombine(GR_COMBINE_FUNCTION_SCALE_OTHER,
		     GR_COMBINE_FACTOR_LOCAL,
		     localc,
		     GR_COMBINE_OTHER_TEXTURE,
		     FXFALSE);

      grAlphaCombine(GR_COMBINE_FUNCTION_SCALE_OTHER,
		     GR_COMBINE_FACTOR_LOCAL,
		     locala,
		     GR_COMBINE_OTHER_TEXTURE,
		     FXFALSE);
      break;
    }
  case (FX_UM_E0_REPLACE | FX_UM_E1_BLEND): /* Only for GLQuake */
    if(ti1->tmi.whichTMU==FX_TMU1) {
      grTexCombine(GR_TMU1,
		   GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		   GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		   FXTRUE,FXFALSE);
		  
      grTexCombine(GR_TMU0,
		   GR_COMBINE_FUNCTION_BLEND_OTHER,GR_COMBINE_FACTOR_LOCAL,
		   GR_COMBINE_FUNCTION_BLEND_OTHER,GR_COMBINE_FACTOR_LOCAL,
		   FXFALSE,FXFALSE);
    } else {
      grTexCombine(GR_TMU1,
		   GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		   GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		   FXFALSE,FXFALSE);
		  
      grTexCombine(GR_TMU0,
		   GR_COMBINE_FUNCTION_BLEND_OTHER,GR_COMBINE_FACTOR_ONE_MINUS_LOCAL,
		   GR_COMBINE_FUNCTION_BLEND_OTHER,GR_COMBINE_FACTOR_ONE_MINUS_LOCAL,
		   FXFALSE,FXFALSE);
    }
	  
    grAlphaCombine(GR_COMBINE_FUNCTION_LOCAL,
		   GR_COMBINE_FACTOR_NONE,
		   locala,
		   GR_COMBINE_OTHER_NONE,
		   FXFALSE);

    grColorCombine(GR_COMBINE_FUNCTION_SCALE_OTHER,
		   GR_COMBINE_FACTOR_ONE,
		   localc,
		   GR_COMBINE_OTHER_TEXTURE,
		   FXFALSE);
    break;
  case (FX_UM_E0_REPLACE | FX_UM_E1_MODULATE): /* Only for QuakeII */
    if(ti1->tmi.whichTMU==FX_TMU1) {
      grTexCombine(GR_TMU1,
		   GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		   GR_COMBINE_FUNCTION_ZERO,GR_COMBINE_FACTOR_NONE,
		   FXFALSE,FXTRUE);
		  
      grTexCombine(GR_TMU0,
		   GR_COMBINE_FUNCTION_BLEND_OTHER,GR_COMBINE_FACTOR_LOCAL,
		   GR_COMBINE_FUNCTION_BLEND_OTHER,GR_COMBINE_FACTOR_LOCAL,
		   FXFALSE,FXFALSE);

    } else {
      grTexCombine(GR_TMU1,
		   GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		   GR_COMBINE_FUNCTION_LOCAL,GR_COMBINE_FACTOR_NONE,
		   FXFALSE,FXFALSE);
		  
      grTexCombine(GR_TMU0,
		   GR_COMBINE_FUNCTION_BLEND_OTHER,GR_COMBINE_FACTOR_LOCAL,
		   GR_COMBINE_FUNCTION_BLEND_OTHER,GR_COMBINE_FACTOR_ONE,
		   FXFALSE,FXFALSE);
    }
	  
    if(ti0->baseLevelInternalFormat==GL_RGB)
      grAlphaCombine(GR_COMBINE_FUNCTION_LOCAL,
		     GR_COMBINE_FACTOR_NONE,
		     locala,
		     GR_COMBINE_OTHER_NONE,
		     FXFALSE);
    else
      grAlphaCombine(GR_COMBINE_FUNCTION_SCALE_OTHER,
		     GR_COMBINE_FACTOR_ONE,
		     locala,
		     GR_COMBINE_OTHER_NONE,
		     FXFALSE);


    grColorCombine(GR_COMBINE_FUNCTION_SCALE_OTHER,
		   GR_COMBINE_FACTOR_ONE,
		   localc,
		   GR_COMBINE_OTHER_TEXTURE,
		   FXFALSE);
    break;
  }

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxSetupTextureDoubleTMU(...) End\n");
#endif
}

/************************* No Texture ***************************/

static void fxSetupTextureNone(GLcontext *ctx)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GrCombineLocal_t localc,locala;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxSetupTextureNone(...)\n");
#endif

  if((ctx->Light.ShadeModel==GL_SMOOTH) ||
     (ctx->Point.SmoothFlag) ||
     (ctx->Line.SmoothFlag) ||
     (ctx->Polygon.SmoothFlag))
    locala=GR_COMBINE_LOCAL_ITERATED;
  else
    locala=GR_COMBINE_LOCAL_CONSTANT;
  
  if(ctx->Light.ShadeModel==GL_SMOOTH)
    localc=GR_COMBINE_LOCAL_ITERATED;
  else
    localc=GR_COMBINE_LOCAL_CONSTANT;
  
  grAlphaCombine(GR_COMBINE_FUNCTION_LOCAL,
		 GR_COMBINE_FACTOR_NONE,
		 locala,
		 GR_COMBINE_OTHER_NONE,
		 FXFALSE);

  grColorCombine(GR_COMBINE_FUNCTION_LOCAL,
		 GR_COMBINE_FACTOR_NONE,
		 localc,
		 GR_COMBINE_OTHER_NONE,
		 FXFALSE);

  fxMesa->lastUnitsMode=FX_UM_NONE;
}

/************************************************************************/
/************************** Texture Mode SetUp **************************/
/************************************************************************/

void fxSetupTexture(GLcontext *ctx)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  GLuint tex2Denabled;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxSetupTexture(...)\n");
#endif

  /* Texture Combine, Color Combine and Alpha Combine */

  tex2Denabled=0;
  if((ctx->Texture.Enabled & TEXTURE0_2D) &&
     !(ctx->Texture.Enabled & TEXTURE0_3D) &&
     (ctx->Texture.Set[0].Current2D->Complete))
    tex2Denabled|=TEXTURE0_2D;

  if(fxMesa->haveTwoTMUs &&
     (ctx->Texture.Enabled & TEXTURE1_2D) &&
     !(ctx->Texture.Enabled & TEXTURE1_3D) &&
     (ctx->Texture.Set[1].Current2D->Complete))
    tex2Denabled|=TEXTURE1_2D;
  
  switch(tex2Denabled) {
  case TEXTURE0_2D:
    fxSetupTextureSingleTMU(ctx,0);
    break;
  case TEXTURE1_2D:
    fxSetupTextureSingleTMU(ctx,1);
    break;
  case (TEXTURE0_2D|TEXTURE1_2D):
    fxSetupTextureDoubleTMU(ctx);
    break;
  default:
    fxSetupTextureNone(ctx);
    break;
  }
}

static void fxSetupBlend(GLcontext *ctx)
{
  if(ctx->Color.BlendEnabled) {
    GrAlphaBlendFnc_t sfact,dfact,asfact,adfact;

    /* From the Glide documentation:
       For alpha source and destination blend function factor
       parameters, Voodoo Graphics supports only
       GR_BLEND_ZERO and GR_BLEND_ONE.
       */

    switch(ctx->Color.BlendSrc) {
    case GL_ZERO:
      asfact=sfact=GR_BLEND_ZERO;
      break;
    case GL_ONE:
      asfact=sfact=GR_BLEND_ONE;
      break;
    case GL_DST_COLOR:
      sfact=GR_BLEND_DST_COLOR;
      asfact=GR_BLEND_ONE;
      break;
    case GL_ONE_MINUS_DST_COLOR:
      sfact=GR_BLEND_ONE_MINUS_DST_COLOR;
      asfact=GR_BLEND_ONE;
      break;
    case GL_SRC_ALPHA:
      sfact=GR_BLEND_SRC_ALPHA;
      asfact=GR_BLEND_ONE;
      break;
    case GL_ONE_MINUS_SRC_ALPHA:
      sfact=GR_BLEND_ONE_MINUS_SRC_ALPHA;
      asfact=GR_BLEND_ONE;
      break;
    case GL_DST_ALPHA:
      sfact=GR_BLEND_DST_ALPHA;
      asfact=GR_BLEND_ONE;
      break;
    case GL_ONE_MINUS_DST_ALPHA:
      sfact=GR_BLEND_ONE_MINUS_DST_ALPHA;
      asfact=GR_BLEND_ONE;
      break;
    case GL_SRC_ALPHA_SATURATE:
      sfact=GR_BLEND_ALPHA_SATURATE;
      asfact=GR_BLEND_ONE;
      break;
    case GL_SRC_COLOR:
    case GL_ONE_MINUS_SRC_COLOR:
      /* USELESS */
      asfact=sfact=GR_BLEND_ONE;
      break;
    default:
      asfact=sfact=GR_BLEND_ONE;
      break;
    }

    switch(ctx->Color.BlendDst) {
    case GL_ZERO:
      adfact=dfact=GR_BLEND_ZERO;
      break;
    case GL_ONE:
      adfact=dfact=GR_BLEND_ONE;
      break;
    case GL_SRC_COLOR:
      dfact=GR_BLEND_SRC_COLOR;
      adfact=GR_BLEND_ZERO;
      break;
    case GL_ONE_MINUS_SRC_COLOR:
      dfact=GR_BLEND_ONE_MINUS_SRC_COLOR;
      adfact=GR_BLEND_ZERO;
      break;
    case GL_SRC_ALPHA:
      dfact=GR_BLEND_SRC_ALPHA;
      adfact=GR_BLEND_ZERO;
      break;
    case GL_ONE_MINUS_SRC_ALPHA:
      dfact=GR_BLEND_ONE_MINUS_SRC_ALPHA;
      adfact=GR_BLEND_ZERO;
      break;
    case GL_DST_ALPHA:
      dfact=GR_BLEND_DST_ALPHA;
      adfact=GR_BLEND_ZERO;
      break;
    case GL_ONE_MINUS_DST_ALPHA:
      dfact=GR_BLEND_ONE_MINUS_DST_ALPHA;
      adfact=GR_BLEND_ZERO;
      break;
    case GL_SRC_ALPHA_SATURATE:
    case GL_DST_COLOR:
    case GL_ONE_MINUS_DST_COLOR:
      /* USELESS */
      adfact=dfact=GR_BLEND_ZERO;
      break;
    default:
      adfact=dfact=GR_BLEND_ZERO;
      break;
    }

    grAlphaBlendFunction(sfact,dfact,asfact,adfact);
  } else
    grAlphaBlendFunction(GR_BLEND_ONE,GR_BLEND_ZERO,GR_BLEND_ONE,GR_BLEND_ZERO);
}
  
static void fxSetupAlphaTest(GLcontext *ctx)
{
  if(ctx->Color.AlphaEnabled) {
    switch(ctx->Color.AlphaFunc) {
    case GL_NEVER:
      grAlphaTestFunction(GR_CMP_NEVER);
      break;
    case GL_LESS:
      grAlphaTestFunction(GR_CMP_LESS);
      break;
    case GL_EQUAL:
      grAlphaTestFunction(GR_CMP_EQUAL);
      break;
    case GL_LEQUAL:
      grAlphaTestFunction(GR_CMP_LEQUAL);
      break;
    case GL_GREATER:
      grAlphaTestFunction(GR_CMP_GREATER);
      break;
    case GL_NOTEQUAL:
      grAlphaTestFunction(GR_CMP_NOTEQUAL);
      break;
    case GL_GEQUAL:
      grAlphaTestFunction(GR_CMP_GEQUAL);
      break;
    case GL_ALWAYS:
      grAlphaTestFunction(GR_CMP_ALWAYS);
      break;
    default:
      break;
    }
    grAlphaTestReferenceValue(ctx->Color.AlphaRef);
  } else
    grAlphaTestFunction(GR_CMP_ALWAYS);
}
  
static void fxSetupDepthTest(GLcontext *ctx)
{
  if(ctx->Depth.Test) {
    switch(ctx->Depth.Func) {
    case GL_NEVER:
      grDepthBufferFunction(GR_CMP_NEVER);
      break;
    case GL_LESS:
      grDepthBufferFunction(GR_CMP_LESS);
      break;
    case GL_GEQUAL:
      grDepthBufferFunction(GR_CMP_GEQUAL);
      break;
    case GL_LEQUAL:
      grDepthBufferFunction(GR_CMP_LEQUAL);
      break;
    case GL_GREATER:
      grDepthBufferFunction(GR_CMP_GREATER);
      break;
    case GL_NOTEQUAL:
      grDepthBufferFunction(GR_CMP_NOTEQUAL);
      break;
    case GL_EQUAL:
      grDepthBufferFunction(GR_CMP_EQUAL);
      break;
    case GL_ALWAYS:
      grDepthBufferFunction(GR_CMP_ALWAYS);
      break;
    default:
      break;
    }

    if(ctx->Depth.Mask)
      grDepthMask(FXTRUE);
    else
      grDepthMask(FXFALSE);
  } else {
    grDepthBufferFunction(GR_CMP_ALWAYS);
    grDepthMask(FXFALSE);
  }
}

/************************************************************************/
/**************************** Fog Mode SetUp ****************************/
/************************************************************************/

void fxSetupFog(GLcontext *ctx)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

  if(ctx->Fog.Enabled && ctx->FogMode==FOG_FRAGMENT) {
    grFogMode(GR_FOG_WITH_TABLE);
    grFogColorValue(FXCOLOR((unsigned int)(255*ctx->Fog.Color[0]), 
                            (unsigned int)(255*ctx->Fog.Color[1]),
                            (unsigned int)(255*ctx->Fog.Color[2]), 
                            (unsigned int)(255*ctx->Fog.Color[3])));

    if((fxMesa->fogTableMode!=ctx->Fog.Mode) ||
       (fxMesa->fogDensity!=ctx->Fog.Density)) {
      float wscale=fxMesa->wScale;

      switch(ctx->Fog.Mode) {
      case GL_LINEAR:
        guFogGenerateLinear(fxMesa->fogTable,
                            ctx->Fog.Start/wscale,
                            ctx->Fog.End/wscale);
        break;
      case GL_EXP:
        guFogGenerateExp(fxMesa->fogTable,ctx->Fog.Density*wscale);
        break;
      case GL_EXP2:
        guFogGenerateExp2(fxMesa->fogTable,ctx->Fog.Density*wscale);
        break;
      default: /* That should never happen */
        break; 
      }
         
      fxMesa->fogTableMode=ctx->Fog.Mode;
      fxMesa->fogDensity=ctx->Fog.Density;
    }
      
    grFogTable(fxMesa->fogTable);
  } else
    grFogMode(GR_FOG_DISABLE);
}

static void fxSetupScissor(GLcontext *ctx)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

  if (ctx->Scissor.Enabled) {
    int ymin, ymax;

    ymin=ctx->Scissor.Y;
    ymax=ctx->Scissor.Y+ctx->Scissor.Height;

    if (ymin<0) ymin=0;

    if (ymax>fxMesa->height) ymax=fxMesa->height;

    grClipWindow(ctx->Scissor.X, 
 		 ymin,
 		 ctx->Scissor.X+ctx->Scissor.Width, 
 		 ymax);
  } else
    grClipWindow(0,0,fxMesa->width,fxMesa->height);
}

void fxSetupFXUnits(GLcontext *ctx)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;

#if defined(DEBUG_FXMESA)
  fprintf(stderr,"fxmesa: fxSetupFXUnits(...)\n");
#endif

  fxSetupTexture(ctx);
  fxSetupBlend(ctx);
  fxSetupAlphaTest(ctx);
  fxSetupDepthTest(ctx);
  fxSetupFog(ctx);
  fxSetupScissor(ctx);

  if(ctx->Color.ColorMask)
    grColorMask(FXTRUE,fxMesa->haveAlphaBuffer ? FXTRUE : FXFALSE);
  else
    grColorMask(FXFALSE,FXFALSE);
}


#else


/*
 * Need this to provide at least one external definition.
 */

int gl_fx_dummy_function_setup(void)
{
  return 0;
}

#endif  /* FX */
