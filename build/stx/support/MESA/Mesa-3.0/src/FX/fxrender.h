/* -*- mode: C; tab-width:8;  -*-

             fxrender.h - 3Dfx VooDoo RenderVB driver function support
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

/************************************************************************/
/************************ RenderVB function *****************************/
/************************************************************************/

static GLboolean FXRENDERVB_NAME (GLcontext *ctx, GLboolean allDone)
{
  fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
  struct vertex_buffer *VB=ctx->VB;
  GLuint vlist[VB_SIZE];
  GLenum prim=ctx->Primitive;

  /* Check if the cull front face mode is changed */

  if((ctx->Polygon.FrontFace!=fxMesa->currentFrontFace) &&
     ctx->Polygon.CullFlag){
    switch(ctx->Polygon.CullFaceMode) {
    case GL_BACK:
      if(ctx->Polygon.FrontFace==GL_CCW)
	grCullMode(GR_CULL_NEGATIVE);
      else
	grCullMode(GR_CULL_POSITIVE);
      break;
    case GL_FRONT:
      if(ctx->Polygon.FrontFace==GL_CCW)
	grCullMode(GR_CULL_POSITIVE);
      else
	grCullMode(GR_CULL_NEGATIVE);
      break;
    case GL_FRONT_AND_BACK:
      grCullMode(GR_CULL_DISABLE);
      (*ctx->Driver.UpdateState)(ctx);
      return GL_FALSE;
    default:
      /* do nothing */
      break;
    }

    fxMesa->currentFrontFace=ctx->Polygon.FrontFace;
  }

  /* A small optimization for GLQuake */

  if(prim==GL_POLYGON) {
    if(VB->Count==3)
      prim=GL_TRIANGLES;
    else if(VB->Count==4)
      prim=GL_QUADS;
  }

  switch (prim) {
  case GL_POINTS:
    (*ctx->Driver.PointsFunc)(ctx,0,VB->Count-1);
    break;

  case GL_LINES:
    if(VB->ClipOrMask) {
      GLuint i;
      GrVertex *gWin=fxMesa->gWin;

      for(i=1;i<VB->Count;i+=2,gWin+=2) {
	RVB_COLOR(i);

	if (VB->ClipMask[i-1] | VB->ClipMask[i]) {
	  fxRenderClippedLine(ctx,i-1,i);
	} else
	  grDrawLine(&gWin[0],&gWin[1]);

	ctx->StippleCounter = 0;
      }
    } else {
      GLuint i;
      GrVertex *gWin=fxMesa->gWin;

      for(i=1;i<VB->Count;i+=2,gWin+=2) {
	RVB_COLOR(i);
	grDrawLine(&gWin[0],&gWin[1]);

	ctx->StippleCounter=0;
      }
    }
    break;

  case GL_LINE_STRIP:
    if(VB->ClipOrMask) {
      GLuint i;
      GrVertex *gWin=fxMesa->gWin;

      for(i=1;i<VB->Count;i++,gWin++) {
	RVB_COLOR(i);

	if(VB->ClipMask[i-1] | VB->ClipMask[i])
	  fxRenderClippedLine(ctx,i-1,i);
	else
	  grDrawLine(&gWin[0],&gWin[1]);
      }
    } else {
      /* no clipping needed */
      GLuint i;
      GrVertex *gWin=fxMesa->gWin;
      
      for(i=1;i<VB->Count;i++,gWin++) {
	RVB_COLOR(i);
	grDrawLine(&gWin[0],&gWin[1]);
      }   
    }
    break;

  case GL_LINE_LOOP:
    {
      GLuint i;
      GrVertex *gWin;

      if(VB->Start==0) {
	i=1;  /* start at 0th vertex */
	gWin=fxMesa->gWin;
      } else {
	i=2;  /* skip first vertex, we're saving it until glEnd */
	gWin=&fxMesa->gWin[1];
      }

      while(i<VB->Count) {
	RVB_COLOR(i);
	
	if(VB->ClipMask[i-1] | VB->ClipMask[i])
	  fxRenderClippedLine(ctx,i-1,i);
	else
	  grDrawLine(&gWin[0],&gWin[1]);

	i++;
	gWin++;
      }
    }
  break;

  case GL_TRIANGLES:
    if(VB->ClipOrMask) {
      GLuint i;
      GrVertex *gWin=fxMesa->gWin;

      for(i=2;i<VB->Count;i+=3,gWin+=3) {
	if(VB->ClipMask[i-2] | VB->ClipMask[i-1] | VB->ClipMask[i]) {
	  vlist[0]=i-2;
	  vlist[1]=i-1;
	  vlist[2]=i-0;
	  RVB_COLOR(i);
	  fxRenderClippedPolygon(ctx,3,vlist);
	} else {
	  RVB_COLOR(i);
	  grDrawTriangle(&gWin[0],&gWin[1],&gWin[2]);
	}
      }
    } else {
      GLuint i;
      GrVertex *gWin=fxMesa->gWin;

      for(i=2;i<VB->Count;i+=3,gWin+=3) {
	RVB_COLOR(i);
	grDrawTriangle(&gWin[0],&gWin[1],&gWin[2]);
      }
    }
    break;

  case GL_TRIANGLE_STRIP:
    if (VB->ClipOrMask) {
      GLuint i;
      GrVertex *gWin=fxMesa->gWin;

      for(i=2;i<VB->Count;i++,gWin++) {
	RVB_COLOR(i);
	
	if(VB->ClipMask[i-2] | VB->ClipMask[i-1] | VB->ClipMask[i]) {
	  if(i&1) {
	    /* reverse vertex order */
	    vlist[0]=i-1;
	    vlist[1]=i-2;
	    vlist[2]=i-0;
	    fxRenderClippedPolygon(ctx,3,vlist);
	  } else {
	    vlist[0]=i-2;
	    vlist[1]=i-1;
	    vlist[2]=i-0;
	    fxRenderClippedPolygon(ctx,3,vlist);
	  }
	} else {
	  if(i&1)
	    grDrawTriangle(&gWin[2],&gWin[1],&gWin[0]);
	  else
	    grDrawTriangle(&gWin[0],&gWin[1],&gWin[2]);
	}
      }
    } else {
      GLuint i;
      GrVertex *gWin=fxMesa->gWin;
      	
      for(i=2;i<VB->Count;i++,gWin++) {
	RVB_COLOR(i);

	if(i&1)
	  grDrawTriangle(&gWin[2],&gWin[1],&gWin[0]);
	else
	  grDrawTriangle(&gWin[0],&gWin[1],&gWin[2]);
      }
    }
    break;

  case GL_TRIANGLE_FAN:
    if (VB->ClipOrMask) {
      GLuint i;
      GrVertex *gWin,*gstart;

      gstart=fxMesa->gWin;
      gWin=&fxMesa->gWin[1];

      for(i=2;i<VB->Count;i++,gWin++) {
	RVB_COLOR(i);

	if (VB->ClipMask[0] | VB->ClipMask[i-1] | VB->ClipMask[i]) {
	  vlist[0]=0;
	  vlist[1]=i-1;
	  vlist[2]=i;
	  fxRenderClippedPolygon(ctx,3,vlist);
	} else
	  grDrawTriangle(gstart,&gWin[0],&gWin[1]);
      }
    } else {
      /* no clipping needed */
      GLuint i;
      GrVertex *gWin,*gstart;

      gstart=fxMesa->gWin;
      gWin=&fxMesa->gWin[1];

      for(i=2;i<VB->Count;i++,gWin++) {
	RVB_COLOR(i);
	grDrawTriangle(gstart,&gWin[0],&gWin[1]);
      }
    }
    break;

  case GL_QUADS:
    if (VB->ClipOrMask) {
      GLuint i;
      GrVertex *gWin=fxMesa->gWin;

      for (i=3;i<VB->Count;i+=4,gWin+=4) {
	RVB_COLOR(i);

	if(VB->ClipMask[i-3] | VB->ClipMask[i-2]
	   | VB->ClipMask[i-1] | VB->ClipMask[i]) {
	  vlist[0]=i-3;
	  vlist[1]=i-2;
	  vlist[2]=i-1;
	  vlist[3]=i-0;
	  fxRenderClippedPolygon(ctx,4,vlist);
	} else {
	  grDrawTriangle(&gWin[0],&gWin[1],&gWin[3]);
	  grDrawTriangle(&gWin[1],&gWin[2],&gWin[3]);
	}
      }
    } else {
      /* no vertices were clipped */
      GLuint i;
      GrVertex *gWin=fxMesa->gWin;

      for(i=3;i<VB->Count;i+=4,gWin+=4) {
	RVB_COLOR(i);
	grDrawTriangle(&gWin[0],&gWin[1],&gWin[3]);
	grDrawTriangle(&gWin[1],&gWin[2],&gWin[3]);
      }
    }
    break;

  case GL_QUAD_STRIP:
    if (VB->ClipOrMask) {
      GLuint i;
      GrVertex *gWin=fxMesa->gWin;

      for(i=3;i<VB->Count;i+=2,gWin+=2) {
	RVB_COLOR(i);

	if(VB->ClipMask[i-2] | VB->ClipMask[i-3]
	   | VB->ClipMask[i-1] | VB->ClipMask[i]) {
	  vlist[0]=i-1;
	  vlist[1]=i-3;
	  vlist[2]=i-2;
	  vlist[3]=i-0;
	  fxRenderClippedPolygon(ctx,4,vlist);
	} else {
	  grDrawTriangle(&gWin[0],&gWin[1],&gWin[2]);
	  grDrawTriangle(&gWin[1],&gWin[3],&gWin[2]);
	}
      }
    } else {
      /* no clipping needed */
      GLuint i;
      GrVertex *gWin=fxMesa->gWin;
      
      for(i=3;i<VB->Count;i+=2,gWin+=2) {
	RVB_COLOR(i);
	grDrawTriangle(&gWin[0],&gWin[1],&gWin[2]);
	grDrawTriangle(&gWin[1],&gWin[3],&gWin[2]);
      }
    }
    break;

  case GL_POLYGON:
    if (VB->Count>2) {
      if (VB->ClipAndMask & CLIP_ALL_BITS) {
	/* all points clipped by common plane, draw nothing */
	break;
      }

      RVB_COLOR(0);

      if(VB->ClipOrMask) {
	GLuint i;

	for(i=0;i<VB->Count;i++)
	  vlist[i]=i;

	fxRenderClippedPolygon(ctx,VB->Count,vlist);
      } else {
	fxMesaContext fxMesa=(fxMesaContext)ctx->DriverCtx;
	GrVertex *gWin=fxMesa->gWin;
	GLint i;

	for (i=2;i<VB->Count;i++)
	  grDrawTriangle(&gWin[0],&gWin[i-1],&gWin[i]);
      }
    }
    break;

  default:
    /* should never get here */
    gl_problem(ctx,"invalid mode in gl_render_vb");
  }

  gl_reset_vb(ctx,allDone);

  return GL_TRUE;
}
