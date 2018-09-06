/* -*- mode: C; tab-width:8;  -*-

             fxdrv.h - 3Dfx VooDoo driver types
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

#ifndef FXDRV_H
#define FXDRV_H

/* #define DEBUG_FXMESA 1 */

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <assert.h>

#if defined(__linux__)
#include <signal.h>
#endif

#include "context.h"
#include "macros.h"
#include "matrix.h"
#include "texture.h"
#include "types.h"
#include "vb.h"
#include "xform.h"
#include "clip.h"
#include "vbrender.h"

#include "GL/fxmesa.h"

#if defined(FX) && defined(__WIN32__)
#include <windows.h>
#pragma warning (disable:4273)
#else
#define APIENTRY
#define CALLBACK
#define WINGDIAPI extern
#endif

#define FXCOLOR(r,g,b,a) (      \
  ( ((unsigned int)(a))<<24 ) | \
  ( ((unsigned int)(b))<<16 ) | \
  ( ((unsigned int)(g))<<8 )  | \
  ((unsigned int)r) )

#define FX_NUM_TMU 2

#define FX_TMU0      GR_TMU0
#define FX_TMU1      GR_TMU1
#define FX_TMU_SPLIT 98
#define FX_TMU_BOTH  99
#define FX_TMU_NONE  100

/* Used for fxMesa->lastUnitsMode */

#define FX_UM_NONE                  0x00000000

#define FX_UM_E0_REPLACE            0x00000001
#define FX_UM_E0_MODULATE           0x00000002
#define FX_UM_E0_DECAL              0x00000004
#define FX_UM_E0_BLEND              0x00000008

#define FX_UM_E1_REPLACE            0x00000010
#define FX_UM_E1_MODULATE           0x00000020
#define FX_UM_E1_DECAL              0x00000040
#define FX_UM_E1_BLEND              0x00000080

#define FX_UM_E_ENVMODE             0x000000ff

#define FX_UM_E0_ALPHA              0x00000100
#define FX_UM_E0_LUMINANCE          0x00000200
#define FX_UM_E0_LUMINANCE_ALPHA    0x00000400
#define FX_UM_E0_INTENSITY          0x00000800
#define FX_UM_E0_RGB                0x00001000
#define FX_UM_E0_RGBA               0x00002000

#define FX_UM_E1_ALPHA              0x00004000
#define FX_UM_E1_LUMINANCE          0x00008000
#define FX_UM_E1_LUMINANCE_ALPHA    0x00010000
#define FX_UM_E1_INTENSITY          0x00020000
#define FX_UM_E1_RGB                0x00040000
#define FX_UM_E1_RGBA               0x00080000

#define FX_UM_E_IFMT                0x000fff00

#define FX_UM_COLOR_ITERATED        0x00100000
#define FX_UM_COLOR_CONSTANT        0x00200000
#define FX_UM_ALPHA_ITERATED        0x00400000
#define FX_UM_ALPHA_CONSTANT        0x00800000

typedef GLboolean (*tfxRenderVBFunc)(GLcontext *, GLboolean);

typedef struct tfxTMFreeListNode {
  struct tfxTMFreeListNode *next;
  FxU32 startAddress, endAddress;
} tfxTMFreeNode;

typedef struct tfxTMAllocListNode {
  struct tfxTMAllocListNode *next;
  FxU32 startAddress, endAddress;
  struct gl_texture_object *tObj;
} tfxTMAllocNode;

typedef struct {
  GLsizei width, height;
  GLint glideFormat;

  unsigned short *data;
  GLboolean translated, used;
} tfxMipMapLevel;

typedef struct {
  GLuint lastTimeUsed;

  FxU32 whichTMU;

  tfxTMAllocNode *tm[FX_NUM_TMU];

  tfxMipMapLevel mipmapLevel[MAX_TEXTURE_LEVELS];
  GLboolean isInTM;
} tfxTMInfo;

typedef struct {
  tfxTMInfo tmi;

  GLint minLevel, maxLevel;
  GLint baseLevelInternalFormat;

  GrTexInfo info;

  GrTextureFilterMode_t minFilt;
  GrTextureFilterMode_t maxFilt;
  FxBool LODblend;

  GrTextureClampMode_t sClamp;
  GrTextureClampMode_t tClamp;

  GrMipMapMode_t mmMode;

  GLfloat sScale, tScale;

  GuTexPalette palette;

  GLboolean fixedPalette;
  GLboolean validated;
} tfxTexInfo;

typedef struct {
  GLuint swapBuffer;
  GLuint reqTexUpload;
  GLuint texUpload;
  GLuint memTexUpload;
} tfxStats;

struct tfxMesaContext {
  GrVertex gWin[VB_SIZE];

  GuTexPalette glbPalette;

  GLcontext *glCtx;              /* the core Mesa context */
  GLvisual *glVis;               /* describes the color buffer */
  GLframebuffer *glBuffer;       /* the ancillary buffers */

  GLint board;                   /* the board used for this context */
  GLint width, height;           /* size of color buffer */

  GrBuffer_t currentFB;

  GLenum currentFrontFace;

  GrColor_t color;
  GrColor_t clearC;
  GrAlpha_t clearA;

  /* Texture Memory Manager Data */

  GLuint texBindNumber;
  GLint tmuSrc;
  GLuint lastUnitsMode;
  GLuint freeTexMem[FX_NUM_TMU];
  tfxTMFreeNode *tmFree[FX_NUM_TMU];
  tfxTMAllocNode *tmAlloc[FX_NUM_TMU];

  GLfloat wScale;

  GLenum fogTableMode;
  GLfloat fogDensity;
  GrFog_t fogTable[64];

  /* Acc. functions */

  points_func PointsFunc;
  line_func LineFunc;
  triangle_func TriangleFunc;
  quad_func QuadFunc;
  tfxRenderVBFunc RenderVB;

  tfxStats stats;

  GrState state;

  /* Options */

  GLboolean verbose;
  GLboolean haveTwoTMUs;
  GLboolean haveAlphaBuffer;
  GLboolean haveDoubleBuffer;
  GLboolean haveGlobalPaletteTexture;
  GLint swapInterval;
  GLint maxPendingSwapBuffers;
};

typedef void (*tfxSetupFunc)(GLcontext *, GLuint, GLuint);

extern GrHwConfiguration glbHWConfig;
extern int glbCurrentBoard;

extern void fxSetupFXUnits(GLcontext *);
extern void fxSetupDDPointers(GLcontext *);
extern void fxDDSetNearFar(GLcontext *, GLfloat, GLfloat);

extern tfxSetupFunc fxDDChooseSetupFunction(GLcontext *);

extern points_func fxDDChoosePointsFunction(GLcontext *);
extern line_func fxDDChooseLineFunction(GLcontext *);
extern triangle_func fxDDChooseTriangleFunction(GLcontext *);
extern quad_func fxDDChooseQuadFunction(GLcontext *);
extern tfxRenderVBFunc fxDDChooseRenderVBFunction(GLcontext *);

extern void fxUpdateDDSpanPointers(GLcontext *);
extern void fxSetupDDSpanPointers(GLcontext *);

extern void fxDDBufferSize(GLcontext *, GLuint *, GLuint *);

extern void fxDDTexEnv(GLcontext *, GLenum, const GLfloat *);
extern void fxDDTexImg(GLcontext *, GLenum, struct gl_texture_object *,
		       GLint, GLint, const struct gl_texture_image *);
extern void fxDDTexParam(GLcontext *, GLenum, struct gl_texture_object *,
			 GLenum, const GLfloat *);
extern void fxDDTexBind(GLcontext *, GLenum, struct gl_texture_object *);
extern void fxDDTexDel(GLcontext *, struct gl_texture_object *);
extern void fxDDTexPalette(GLcontext *, struct gl_texture_object *);
extern void fxDDTexuseGlbPalette(GLcontext *, GLboolean);
extern void fxDDTexSubImg(GLcontext *, GLenum, struct gl_texture_object *, GLint,
			  GLint, GLint, GLint, GLint, GLint, const struct gl_texture_image *);
extern void fxDDTexUseGlbPalette(GLcontext *, GLboolean);

extern void fxTMInit(fxMesaContext);
extern void fxTMClose(fxMesaContext);
extern void fxTMMoveInTM(fxMesaContext, struct gl_texture_object *, GLint);
extern void fxTMMoveOutTM(fxMesaContext, struct gl_texture_object *);
extern void fxTMFreeTexture(fxMesaContext, struct gl_texture_object *);
extern void fxTMReloadMipMapLevel(fxMesaContext, struct gl_texture_object *, GLint);
extern void fxTMReloadSubMipMapLevel(fxMesaContext, struct gl_texture_object *,
				     GLint, GLint, GLint);

extern void fxTexGetFormat(GLenum, GrTextureFormat_t *, GLint *);
extern int fxTexGetInfo(int, int, GrLOD_t *, GrAspectRatio_t *, float *, float *, int *, int *);

extern void fxSetupTexture(GLcontext *);
extern void fxSetupFog(GLcontext *);

#endif
