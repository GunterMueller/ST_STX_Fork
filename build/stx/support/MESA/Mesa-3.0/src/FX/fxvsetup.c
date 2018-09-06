/* -*- mode: C; tab-width:8;  -*-

             fxvsetup.c - 3Dfx VooDoo vertices setup functions 
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

#define GOURAUD_ENABLED  0x01
#define TEXTURE0_ENABLED 0x02
#define FOG_ENABLED      0x04
#define ZBUFFER_ENABLED  0x08
#define TEXTURE1_ENABLED 0x10

#if defined(__WIN32__)

/************************************************************************/
/********* The Win32 Version of the asm GrVertex Setup code *************/
/************************************************************************/

#define RDTSC	__asm _emit 0x0f __asm _emit 0x31

#if 0
#define DATA_PROFILING char *format="Number of Cycles for the GrVertex setup: %u (%u number of GrVertex)\n"; unsigned long numcycl

#define START_PROFILING __asm { \
  RDTSC                         \							
  _asm mov numcycl,eax	        \
}

#define STOP_PROFILING __asm { \
  RDTSC		               \
  __asm mov ebx,vend	       \
  __asm sub ebx,vstart	       \
  __asm push ebx	       \
  __asm sub eax,numcycl	       \
  __asm push eax	       \
  __asm mov ecx,format	       \
  __asm push ecx	       \
  __asm call printf	       \
  __asm add esp,12             \
}
#else
#define DATA_PROFILING
#define START_PROFILING
#define STOP_PROFILING
#endif

#define NOSNAP(v) __asm {                       \
  __asm mov eax,dword ptr [edx]	                \
  __asm mov ebx,dword ptr [edx+4]               \
  __asm mov dword ptr [ecx]GrVertex.x,eax       \
  __asm mov dword ptr [ecx]GrVertex.y,ebx       \
}

#define SNAP(v) __asm {                         \
  /* Snap verticies */	                        \
  __asm fld dword ptr [edx]			\
  __asm fadd snapconst				\
  __asm fld dword ptr [edx+4]			\
  __asm fadd snapconst				\
  __asm fxch					\
  __asm fstp dword ptr [ecx]GrVertex.x		\
  __asm fstp dword ptr [ecx]GrVertex.y		\
}

#define GOURAUD(v) __asm {              \
  __asm mov ebx,vcol			\
  __asm mov eax,dword ptr [ebx]		\
  __asm add ebx,4			\
  __asm mov vcol,ebx			\
                                        \
  __asm mov byte ptr stmp1,al           \
  __asm fild stmp1		        \
  __asm mov byte ptr stmp1,ah           \
  __asm fild stmp1		        \
  __asm bswap eax                       \
  __asm mov byte ptr stmp1,ah           \
  __asm fild stmp1		        \
  __asm mov byte ptr stmp1,al           \
  __asm fild stmp1		        \
  __asm fstp dword ptr [ecx]GrVertex.a 		\
  __asm fstp dword ptr [ecx]GrVertex.b 		\
  __asm fstp dword ptr [ecx]GrVertex.g 		\
  __asm fstp dword ptr [ecx]GrVertex.r 		\
}

#define TEXTURE0_TMU0(v) __asm {        \
  __asm mov eax,vtex0		        \
  __asm fld sscale0			\
  __asm fmul dword ptr [eax]				\
  __asm fmul dword ptr [ecx]GrVertex.oow		\
  __asm fstp dword ptr [ecx]GrVertex.tmuvtx[0].sow	\
  __asm fld tscale0			\
  __asm fmul dword ptr [eax+4]	        \
  __asm add eax,16			\
  __asm fmul dword ptr [ecx]GrVertex.oow		\
  __asm fstp dword ptr [ecx]GrVertex.tmuvtx[0].tow	\
  __asm mov vtex0,eax		        \
}

/* I don't know why "[ecx]GrVertex.tmuvtx[1].s/tow" doesn't work */

#define TEXTURE0_TMU1(v) __asm {        \
  __asm mov eax,vtex0		        \
  __asm fld sscale0			\
  __asm fmul dword ptr [eax]				\
  __asm fmul dword ptr [ecx]GrVertex.oow		\
  __asm fstp dword ptr [ecx+48]	        \
  __asm fld tscale0			\
  __asm fmul dword ptr [eax+4]	        \
  __asm add eax,16			\
  __asm fmul dword ptr [ecx]GrVertex.oow		\
  __asm fstp dword ptr [ecx+52]	        \
  __asm mov vtex0,eax		        \
}

#define TEXTURE1_TMU1(v) __asm {        \
  __asm mov eax,vtex1		        \
  __asm fld sscale1			\
  __asm fmul dword ptr [eax]				\
  __asm fmul dword ptr [ecx]GrVertex.oow		\
  __asm fstp dword ptr [ecx+48]	        \
  __asm fld tscale1			\
  __asm fmul dword ptr [eax+4]	        \
  __asm add eax,16			\
  __asm fmul dword ptr [ecx]GrVertex.oow		\
  __asm fstp dword ptr [ecx+52]	        \
  __asm mov vtex1,eax		        \
}

#define TEXTURE1_TMU0(v) __asm {        \
  __asm mov eax,vtex1		        \
  __asm fld sscale1			\
  __asm fmul dword ptr [eax]				\
  __asm fmul dword ptr [ecx]GrVertex.oow		\
  __asm fstp dword ptr [ecx]GrVertex.tmuvtx[0].sow	\
  __asm fld tscale1			\
  __asm fmul dword ptr [eax+4]	        \
  __asm add eax,16			\
  __asm fmul dword ptr [ecx]GrVertex.oow		\
  __asm fstp dword ptr [ecx]GrVertex.tmuvtx[0].tow	\
  __asm mov vtex1,eax		        \
}

#define WBUFFER(v) __asm {      \
  __asm mov ebx,vclip		\
  __asm fld wscale		\
  __asm fdiv dword ptr [ebx]	\
  __asm add ebx,16		\
  __asm mov vclip,ebx		\
  __asm fstp dword ptr [ecx]GrVertex.oow	\
}

#define ZBUFFER(v) __asm {                      \
  __asm	mov eax,dword ptr [edx+8]		\
  __asm mov dword ptr [ecx]GrVertex.ooz,eax	\
}

#define NOP(v) 

#define FXSETUP(label, snap, gouraud, texture0, texture1, wdepth, zdepth) { \
  struct vertex_buffer *VB = ctx->VB;				\
  fxMesaContext fxMesa = (fxMesaContext)ctx->DriverCtx;		\
  GrVertex *GVB = &fxMesa->gWin[vstart];			\
  GrVertex *GVBlast = &fxMesa->gWin[vend];			\
  float wscale = fxMesa->wScale; 				\
  float sscale0;                                                \
  float tscale0;                                                \
  float sscale1;                                                \
  float tscale1;                                                \
  float snapconst=(float)(3L<<18);				\
  float *vwin=VB->Win[vstart];					\
  unsigned long stmp1=0;                                        \
  unsigned char *vcol=VB->Color[vstart];		        \
  float *vclip=&VB->Clip[vstart][3];			        \
  float *vtex0;                                                 \
  float *vtex1;                                                 \
  unsigned char *vclipmask=&VB->ClipMask[vstart];               \
  DATA_PROFILING;						\
								\
  if(ctx->Texture.Set[0].Current && ctx->Texture.Set[0].Current->DriverData) { \
    sscale0=((tfxTexInfo *)(ctx->Texture.Set[0].Current->DriverData))->sScale; \
    tscale0=((tfxTexInfo *)(ctx->Texture.Set[0].Current->DriverData))->tScale; \
    vtex0=VB->MultiTexCoord[ctx->Texture.Set[0].TexCoordSet][vstart];          \
  }                                                                         \
  if(ctx->Texture.Set[1].Current && ctx->Texture.Set[1].Current->DriverData) { \
    sscale1=((tfxTexInfo *)(ctx->Texture.Set[1].Current->DriverData))->sScale; \
    tscale1=((tfxTexInfo *)(ctx->Texture.Set[1].Current->DriverData))->tScale; \
    vtex1=VB->MultiTexCoord[ctx->Texture.Set[1].TexCoordSet][vstart];          \
  }                                                             \
								\
  __asm	{				\
    START_PROFILING			\
    /* eax: tmp */			\
    /* ebx: tmp */			\
    /* ecx: GVB */			\
    /* edx: vwin */			\
    __asm mov ecx,GVB			\
    __asm mov edx,vwin		        \
    			                \
    __asm align 16			\
    __asm l_##label :                   \
    __asm mov eax,vclipmask             \
    __asm mov bl,byte ptr [eax]         \
    __asm inc eax                       \
    __asm mov vclipmask,eax             \
    __asm test bl,bl                    \
    __asm je start_##label              \
                                        \
    __asm mov ebx,vcol                  \
    __asm mov eax,vtex0                 \
    __asm add ebx,4   		        \
    __asm add eax,16                    \
    __asm mov vcol,ebx                  \
    __asm mov vtex0,eax                 \
    __asm mov ebx,vtex1                 \
    __asm mov eax,vclip 	        \
    __asm add ebx,16                    \
    __asm add eax,16	                \
    __asm mov vtex1,ebx                 \
    __asm mov vclip,eax                 \
    __asm jmp end_##label               \
    __asm start_##label :               \
                                        \
    snap(GVB)				\
    gouraud(GVB)			\
    wdepth(GVB)			        \
    zdepth(GVB)			        \
    texture0(GVB)			\
    texture1(GVB)			\
    				        \
    __asm end_##label :                 \
    __asm add ecx,SIZE GrVertex	        \
    __asm add edx,12			\
    __asm cmp ecx,GVBlast	        \
    __asm jne l_##label                 \
   			                \
    STOP_PROFILING			\
  }                                     \
}


#else /******************************************************************/


#if defined(__linux__) && defined(__i386__)


/************************************************************************/
/*********** The Linux Version of the asm GrVertex Setup code ***********/
/************************************************************************/


#define NOSNAP(v) "      \
  movl (%%edx),%%eax;    \
  movl 4(%%edx),%%ebx;   \
  movl %%eax,(%%ecx);    \
  movl %%ebx,4(%%ecx);"

#define SNAP(v) "               \
  flds (%%edx);	        	\
  fadds %0;			\
  flds 4(%%edx);		\
  fadds %0;			\
  fxch;				\
  fstps (%%ecx);	        \
  fstps 4(%%ecx);" 

#define GOURAUD(v) "            \
  movl %2,%%ebx;                \
  movl (%%ebx),%%eax;		\
  addl $4,%%ebx;  		\
  movl %%ebx,%2;                \
                                \
  movb %%al,%4;	                \
  fild %4;		        \
  movb %%ah,%4;	                \
  fild %4;		        \
  bswap %%eax;		        \
  movb %%ah,%4;	                \
  fild %4;		        \
  movb %%al,%4;	                \
  fild %4;		        \
  fstps 28(%%ecx);		\
  fstps 20(%%ecx);		\
  fstps 16(%%ecx);		\
  fstps 12(%%ecx);"

#define TEXTURE0_TMU0(v) "      \
  movl %0,%%eax;	        \
  flds %1;			\
  fmuls (%%eax);		\
  fmuls 32(%%ecx);		\
  fstps 36(%%ecx);       	\
  flds %2;			\
  fmuls 4(%%eax);	        \
  addl $16,%%eax;		\
  fmuls 32(%%ecx);		\
  fstps 40(%%ecx);       	\
  mov %%eax,%0;"

#define TEXTURE0_TMU1(v) "      \
  movl %0,%%eax;	        \
  flds %1;			\
  fmuls (%%eax);		\
  fmuls 32(%%ecx);		\
  fstps 48(%%ecx);       	\
  flds %2;			\
  fmuls 4(%%eax);	        \
  addl $16,%%eax;		\
  fmuls 32(%%ecx);		\
  fstps 52(%%ecx);       	\
  mov %%eax,%0;"

#define TEXTURE1_TMU1(v) "      \
  movl %3,%%eax;	        \
  flds %4;			\
  fmuls (%%eax);		\
  fmuls 32(%%ecx);		\
  fstps 48(%%ecx);       	\
  flds %5;			\
  fmuls 4(%%eax);	        \
  addl $16,%%eax;		\
  fmuls 32(%%ecx);		\
  fstps 52(%%ecx);       	\
  mov %%eax,%3;"

#define TEXTURE1_TMU0(v) "      \
  movl %3,%%eax;	        \
  flds %4;			\
  fmuls (%%eax);		\
  fmuls 32(%%ecx);		\
  fstps 36(%%ecx);       	\
  flds %5;			\
  fmuls 4(%%eax);	        \
  addl $16,%%eax;		\
  fmuls 32(%%ecx);		\
  fstps 40(%%ecx);       	\
  mov %%eax,%3;"

#define WBUFFER(v) "            \
  movl %3,%%ebx;		\
  flds %5;		        \
  fdivs (%%ebx);                \
  addl $16,%%ebx;		\
  movl %%ebx,%3;		\
  fstps 32(%%ecx);"

#define ZBUFFER(v) "            \
  movl 8(%%edx),%%eax;		\
  movl %%eax,24(%%ecx);"

#define NOP(v) ""

#define SETUP_ASMLOOP(c)               \
  __asm__ volatile (c                  \
  : /* not correctly filled */         \
  : "m" (GVB), "m" (GVBlast), "m" (vwin), "i" (sizeof(GrVertex)) \
  : "eax", "ebx", "ecx", "edx", "cc", "memory")

#define SETUP_ASM(c)                   \
  __asm__ volatile (c                  \
  : /* not correctly filled */         \
  : "m" (snapconst), "m" (vwin),       \
    "m" (vcol), "m" (vclip), "m" (stmp1),       \
    "m" (wscale)                       \
  : "eax", "ebx", "ecx", "edx", "cc", "memory")

#define SETUP_ASMTEX(c)                \
  __asm__ volatile (c                  \
  : /* not correctly filled */         \
  : "m" (vtex0), "m" (sscale0), "m" (tscale0),  \
    "m" (vtex1), "m" (sscale1), "m" (tscale1)   \
  : "eax", "ebx", "ecx", "edx", "cc", "memory")

#define SETUP_ASMCLIPTEST(c)           \
  __asm__ volatile (c                  \
  : /* not correctly filled */         \
  : "m" (vclipmask), "m" (vcol),       \
    "m" (vtex0), "m" (vtex1),          \
    "m" (vclip)                        \
  : "eax", "ebx", "ecx", "edx", "cc", "memory")

#define FXSETUP(label, snap, gouraud, texture0, texture1, wdepth, zdepth) {    \
  struct vertex_buffer *VB = ctx->VB;				\
  fxMesaContext fxMesa = (fxMesaContext)ctx->DriverCtx;		\
  GrVertex *GVB = &fxMesa->gWin[vstart];			\
  GrVertex *GVBlast = &fxMesa->gWin[vend];			\
  float wscale = fxMesa->wScale; 				\
  float sscale0;                                                \
  float tscale0;                                                \
  float sscale1;                                                \
  float tscale1;                                                \
  float snapconst=(float)(3L<<18);				\
  float *vwin=VB->Win[vstart];					\
  unsigned long stmp1=0;					\
  unsigned char *vcol=VB->Color[vstart];		        \
  float *vclip=&VB->Clip[vstart][3];			        \
  float *vtex0;                                                 \
  float *vtex1;                                                 \
  unsigned char *vclipmask=&VB->ClipMask[vstart];               \
                                                                \
  if(ctx->Texture.Set[0].Current && ctx->Texture.Set[0].Current->DriverData) { \
    sscale0=((tfxTexInfo *)(ctx->Texture.Set[0].Current->DriverData))->sScale; \
    tscale0=((tfxTexInfo *)(ctx->Texture.Set[0].Current->DriverData))->tScale; \
    vtex0=VB->MultiTexCoord[ctx->Texture.Set[0].TexCoordSet][vstart];          \
  }                                                                            \
  if(ctx->Texture.Set[1].Current && ctx->Texture.Set[1].Current->DriverData) { \
    sscale1=((tfxTexInfo *)(ctx->Texture.Set[1].Current->DriverData))->sScale; \
    tscale1=((tfxTexInfo *)(ctx->Texture.Set[1].Current->DriverData))->tScale; \
    vtex1=VB->MultiTexCoord[ctx->Texture.Set[1].TexCoordSet][vstart];          \
  }                                                             \
  								\
  /* eax: tmp */		      \
  /* ebx: tmp */		      \
  /* ecx: GVB */		      \
  /* edx: vwin */		      \
  SETUP_ASMLOOP("                     \
    movl %0,%%ecx;		      \
    movl %2,%%edx;		      \
                                      \
    .align 4,0x90;		      \
    "#label"1:;");	              \
                                      \
  SETUP_ASMCLIPTEST("                 \
    movl %0,%%eax;                    \
    movb (%%eax),%%bl;                \
    inc %%eax;                        \
    movl %%eax,%0;                    \
    testb %%bl,%%bl;                  \
    je "#label"start;                 \
                                      \
    movl %1,%%ebx;                    \
    movl %2,%%eax;	              \
    addl $4,%%ebx;  		      \
    addl $16,%%eax;		      \
    movl %%ebx,%1;                    \
    movl %%eax,%2;                    \
    movl %3,%%ebx;	              \
    movl %4,%%eax;	              \
    addl $16,%%ebx;                   \
    addl $16,%%eax;		      \
    movl %%ebx,%3;	              \
    movl %%eax,%4;	              \
    jmp "#label"end;                  \
    "#label"start:;");                \
                                      \
  SETUP_ASM(snap(GVB));		      \
  SETUP_ASM(gouraud(GVB));	      \
  SETUP_ASM(wdepth(GVB));	      \
  SETUP_ASM(zdepth(GVB));	      \
  SETUP_ASMTEX(texture0(GVB));	      \
  SETUP_ASMTEX(texture1(GVB));	      \
                                      \
  SETUP_ASMLOOP("                     \
    "#label"end:;                     \
    addl %3,%%ecx;                    \
    addl $12,%%edx;                   \
    cmpl %1,%%ecx;                    \
    jne "#label"1;                    \
  ");                                 \
}


#else /******************************************************************/


/************************************************************************/
/********* The generic Version of the asm GrVertex Setup code ***********/
/************************************************************************/

#define NOSNAP(v) { \
  (v)->x=VB->Win[i][0];	         \
  (v)->y=VB->Win[i][1];	         \
}

#define SNAP(v) { \
  /* trunc (x,y) to multiple of 1/16 */		        \
  (v)->x=((int)(VB->Win[i][0]*16.0f))*(1.0f/16.0f);	\
  (v)->y=((int)(VB->Win[i][1]*16.0f))*(1.0f/16.0f);	\
}


#define GOURAUD(v) { \
  (v)->r=(float) (VB->Color[i][0]); \
  (v)->g=(float) (VB->Color[i][1]); \
  (v)->b=(float) (VB->Color[i][2]); \
  (v)->a=(float) (VB->Color[i][3]); \
}

#define TEXTURE0_TMU0(v)  { \
  (v)->tmuvtx[0].sow=sscale0*VBtcoord0[i][0]*(v)->oow; \
  (v)->tmuvtx[0].tow=tscale0*VBtcoord0[i][1]*(v)->oow; \
}

#define TEXTURE0_TMU1(v)  { \
  (v)->tmuvtx[1].sow=sscale0*VBtcoord0[i][0]*(v)->oow; \
  (v)->tmuvtx[1].tow=tscale0*VBtcoord0[i][1]*(v)->oow; \
}

#define TEXTURE1_TMU1(v)  { \
  (v)->tmuvtx[1].sow=sscale1*VBtcoord1[i][0]*(v)->oow; \
  (v)->tmuvtx[1].tow=tscale1*VBtcoord1[i][1]*(v)->oow; \
}

#define TEXTURE1_TMU0(v)  { \
  (v)->tmuvtx[0].sow=sscale1*VBtcoord1[i][0]*(v)->oow; \
  (v)->tmuvtx[0].tow=tscale1*VBtcoord1[i][1]*(v)->oow; \
}

#define WBUFFER(v) { (v)->oow=wscale/VB->Clip[i][3]; }

#define ZBUFFER(v) { (v)->ooz=VB->Win[i][2]; }

#define NOP(v) 

#define FXSETUP(label, snap, gouraud, texture0, texture1, wdepth, zdepth) {    \
  register unsigned int i;					        \
  register struct vertex_buffer *VB = ctx->VB;			        \
  register GLfloat (*VBtcoord0)[4];                                     \
  register GLfloat (*VBtcoord1)[4];                                     \
  fxMesaContext fxMesa = (fxMesaContext)ctx->DriverCtx; 		\
  register GrVertex *GVB = &fxMesa->gWin[vstart];			\
  register float wscale = fxMesa->wScale; 			        \
  register float sscale0;                                               \
  register float tscale0;                                               \
  register float sscale1;                                               \
  register float tscale1;                                               \
								        \
  if(ctx->Texture.Set[0].Current && ctx->Texture.Set[0].Current->DriverData) { \
    sscale0=((tfxTexInfo *)(ctx->Texture.Set[0].Current->DriverData))->sScale; \
    tscale0=((tfxTexInfo *)(ctx->Texture.Set[0].Current->DriverData))->tScale; \
    VBtcoord0=VB->MultiTexCoord[ctx->Texture.Set[0].TexCoordSet];              \
  }                                                                            \
  if(ctx->Texture.Set[1].Current && ctx->Texture.Set[1].Current->DriverData) { \
    sscale1=((tfxTexInfo *)(ctx->Texture.Set[1].Current->DriverData))->sScale; \
    tscale1=((tfxTexInfo *)(ctx->Texture.Set[1].Current->DriverData))->tScale; \
    VBtcoord1=VB->MultiTexCoord[ctx->Texture.Set[1].TexCoordSet];              \
  }                                                           \
                                                              \
  for(i=vstart;i<vend;i++,GVB++) {                            \
    if(VB->ClipMask[i]==0) {                                  \
      snap(GVB);                                              \
      gouraud(GVB);                                           \
      wdepth(GVB);                                            \
      zdepth(GVB);                                            \
      texture0(GVB);                                          \
      texture1(GVB);                                          \
   }                                                          \
 }                                                            \
}


#endif /********************************************************/
#endif

#ifdef FX_V2
#define FXVSETUP_FUNC(fname, gouraud, texture0, texture1, wdepth, zdepth) \
static void fname (GLcontext *ctx, GLuint vstart, GLuint vend)        \
{                                                                     \
  FXSETUP(fname##_l1,NOSNAP,gouraud,texture0,texture1,wdepth,zdepth); \
}
#else
#define FXVSETUP_FUNC(fname, gouraud, texture0, texture1, wdepth, zdepth) \
static void fname (GLcontext *ctx, GLuint vstart, GLuint vend)        \
{                                                                     \
  if(ctx->Primitive==GL_POINTS) {                                     \
    FXSETUP(fname##_l1,NOSNAP,gouraud,texture0,texture1,wdepth,zdepth);   \
  } else {                                                            \
    FXSETUP(fname##_l2,SNAP,gouraud,texture0,texture1,wdepth,zdepth); \
  }                                                                   \
}
#endif

/********************************************************/
/************************T00T11**************************/
/********************************************************/

FXVSETUP_FUNC(fxSetup,NOP,NOP,NOP,NOP,NOP)
FXVSETUP_FUNC(fxSetupG,GOURAUD,NOP,NOP,NOP,NOP)
FXVSETUP_FUNC(fxSetupT00,NOP,TEXTURE0_TMU0,NOP,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupGT00,GOURAUD,TEXTURE0_TMU0,NOP,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupW,NOP,NOP,NOP,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupGW,GOURAUD,NOP,NOP,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupZ,NOP,NOP,NOP,NOP,ZBUFFER)
FXVSETUP_FUNC(fxSetupWZ,NOP,NOP,NOP,WBUFFER,ZBUFFER)
FXVSETUP_FUNC(fxSetupGZ,GOURAUD,NOP,NOP,NOP,ZBUFFER)
FXVSETUP_FUNC(fxSetupGWZ,GOURAUD,NOP,NOP,WBUFFER,ZBUFFER)
FXVSETUP_FUNC(fxSetupT00Z,NOP,TEXTURE0_TMU0,NOP,WBUFFER,ZBUFFER)
FXVSETUP_FUNC(fxSetupGT00Z,GOURAUD,TEXTURE0_TMU0,NOP,WBUFFER,ZBUFFER)

/*** FxSetup functions for Multi-texture ***/

FXVSETUP_FUNC(fxSetupT11,NOP,NOP,TEXTURE1_TMU1,NOP,NOP)
FXVSETUP_FUNC(fxSetupGT11,GOURAUD,NOP,TEXTURE1_TMU1,NOP,NOP)
FXVSETUP_FUNC(fxSetupT00T11,NOP,TEXTURE0_TMU0,TEXTURE1_TMU1,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupGT00T11,GOURAUD,TEXTURE0_TMU0,TEXTURE1_TMU1,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupWT11,NOP,NOP,TEXTURE1_TMU1,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupGWT11,GOURAUD,NOP,TEXTURE1_TMU1,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupZT11,NOP,NOP,TEXTURE1_TMU1,NOP,ZBUFFER)
FXVSETUP_FUNC(fxSetupWZT11,NOP,NOP,TEXTURE1_TMU1,WBUFFER,ZBUFFER)
FXVSETUP_FUNC(fxSetupGZT11,GOURAUD,NOP,TEXTURE1_TMU1,NOP,ZBUFFER)
FXVSETUP_FUNC(fxSetupGWZT11,GOURAUD,NOP,TEXTURE1_TMU1,WBUFFER,ZBUFFER)
FXVSETUP_FUNC(fxSetupT00ZT11,NOP,TEXTURE0_TMU0,TEXTURE1_TMU1,WBUFFER,ZBUFFER)
FXVSETUP_FUNC(fxSetupGT00ZT11,GOURAUD,TEXTURE0_TMU0,TEXTURE1_TMU1,WBUFFER,ZBUFFER)

/********************************************************/
/************************T01T10**************************/
/********************************************************/

FXVSETUP_FUNC(fxSetupT01,NOP,TEXTURE0_TMU1,NOP,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupGT01,GOURAUD,TEXTURE0_TMU1,NOP,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupT01Z,NOP,TEXTURE0_TMU1,NOP,WBUFFER,ZBUFFER)
FXVSETUP_FUNC(fxSetupGT01Z,GOURAUD,TEXTURE0_TMU1,NOP,WBUFFER,ZBUFFER)

/*** FxSetup functions for Multi-texture ***/

FXVSETUP_FUNC(fxSetupT10,NOP,NOP,TEXTURE1_TMU0,NOP,NOP)
FXVSETUP_FUNC(fxSetupGT10,GOURAUD,NOP,TEXTURE1_TMU0,NOP,NOP)
FXVSETUP_FUNC(fxSetupT01T10,NOP,TEXTURE0_TMU1,TEXTURE1_TMU0,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupGT01T10,GOURAUD,TEXTURE0_TMU1,TEXTURE1_TMU0,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupWT10,NOP,NOP,TEXTURE1_TMU0,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupGWT10,GOURAUD,NOP,TEXTURE1_TMU0,WBUFFER,NOP)
FXVSETUP_FUNC(fxSetupZT10,NOP,NOP,TEXTURE1_TMU0,NOP,ZBUFFER)
FXVSETUP_FUNC(fxSetupWZT10,NOP,NOP,TEXTURE1_TMU0,WBUFFER,ZBUFFER)
FXVSETUP_FUNC(fxSetupGZT10,GOURAUD,NOP,TEXTURE1_TMU0,NOP,ZBUFFER)
FXVSETUP_FUNC(fxSetupGWZT10,GOURAUD,NOP,TEXTURE1_TMU0,WBUFFER,ZBUFFER)
FXVSETUP_FUNC(fxSetupT01ZT10,NOP,TEXTURE0_TMU1,TEXTURE1_TMU0,WBUFFER,ZBUFFER)
FXVSETUP_FUNC(fxSetupGT01ZT10,GOURAUD,TEXTURE0_TMU1,TEXTURE1_TMU0,WBUFFER,ZBUFFER)

/********************************************************/

static tfxSetupFunc fxSetupFuncsT00T11[]={
  fxSetup,
  fxSetupG,
  fxSetupT00,
  fxSetupGT00,
  fxSetupW, /* 4 */
  fxSetupGW,
  fxSetupT00,
  fxSetupGT00,
  fxSetupZ, /* 8 */
  fxSetupGZ,
  fxSetupT00Z,
  fxSetupGT00Z,
  fxSetupWZ, /* 12 */
  fxSetupGWZ,
  fxSetupT00Z,
  fxSetupGT00Z,
  fxSetupT11, /* 16 */
  fxSetupGT11,
  fxSetupT00T11,
  fxSetupGT00T11,
  fxSetupWT11, /* 20 */
  fxSetupGWT11,
  fxSetupT00T11,
  fxSetupGT00T11,
  fxSetupZT11, /* 24 */
  fxSetupGZT11,
  fxSetupT00ZT11,
  fxSetupGT00ZT11,
  fxSetupWZT11, /* 28 */
  fxSetupGWZT11,
  fxSetupT00ZT11,
  fxSetupGT00ZT11
};

static tfxSetupFunc fxSetupFuncsT01T10[]={
  fxSetup,
  fxSetupG,
  fxSetupT01,
  fxSetupGT01,
  fxSetupW, /* 4 */
  fxSetupGW,
  fxSetupT01,
  fxSetupGT01,
  fxSetupZ, /* 8 */
  fxSetupGZ,
  fxSetupT01Z,
  fxSetupGT01Z,
  fxSetupWZ, /* 12 */
  fxSetupGWZ,
  fxSetupT01Z,
  fxSetupGT01Z,
  fxSetupT10, /* 16 */
  fxSetupGT10,
  fxSetupT01T10,
  fxSetupGT01T10,
  fxSetupWT10, /* 20 */
  fxSetupGWT10,
  fxSetupT01T10,
  fxSetupGT01T10,
  fxSetupZT10, /* 24 */
  fxSetupGZT10,
  fxSetupT01ZT10,
  fxSetupGT01ZT10,
  fxSetupWZT10, /* 28 */
  fxSetupGWZT10,
  fxSetupT01ZT10,
  fxSetupGT01ZT10
};

tfxSetupFunc fxDDChooseSetupFunction(GLcontext *ctx)
{
  tfxSetupFunc *fxSetupFuncs=fxSetupFuncsT00T11;
  unsigned int setupindex=0;

  if(ctx->Light.ShadeModel == GL_SMOOTH && !ctx->Light.Model.TwoSide)
    setupindex |= GOURAUD_ENABLED;

  if((ctx->Texture.Enabled & TEXTURE0_2D) &&
     !(ctx->Texture.Enabled & TEXTURE0_3D) &&
     (ctx->Texture.Set[0].Current2D->Complete))
    setupindex |= TEXTURE0_ENABLED;

  if((ctx->Texture.Enabled & TEXTURE1_2D) &&
     !(ctx->Texture.Enabled & TEXTURE1_3D) &&
     (ctx->Texture.Set[1].Current2D->Complete)) {
    setupindex |= TEXTURE1_ENABLED;

    if(!(setupindex & TEXTURE0_ENABLED))
      fxSetupFuncs=fxSetupFuncsT01T10;
    else {
      struct gl_texture_object *tObj=ctx->Texture.Set[0].Current2D;
      tfxTexInfo *ti=(tfxTexInfo *)tObj->DriverData;

      if(ti->tmi.whichTMU!=FX_TMU0)
	fxSetupFuncs=fxSetupFuncsT01T10;
    }
  }

  if(ctx->Fog.Enabled && (ctx->FogMode==FOG_FRAGMENT))
    setupindex |= FOG_ENABLED;

  if(ctx->Depth.Test)
    setupindex |= ZBUFFER_ENABLED;

#if defined(DEBUG_FXMESA)
    fprintf(stderr,"fxmesa: vertex setup function %d (%d,%d,%d)\n",
	    setupindex,setupindex & GOURAUD_ENABLED, setupindex & TEXTURE0_ENABLED, 
	    setupindex & TEXTURE1_ENABLED);
#endif

  return fxSetupFuncs[setupindex];
}

#else


/*
 * Need this to provide at least one external definition.
 */

int gl_fx_dummy_function_vsetup(void)
{
  return 0;
}

#endif  /* FX */
