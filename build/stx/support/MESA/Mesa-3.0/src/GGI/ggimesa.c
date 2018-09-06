/* GGI-Driver for MESA
 * 
 * Copyright (C) 1997-1998  Uwe Maurer  -  uwe_maurer@t-online.de 
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

#ifdef GGI

#include "ggimesa.h"

#undef VIS
#undef FLIP
#define VIS (GGIMesa->ggi_vis)
#define FLIP(y) (GGIMesa->flip_y-(y))

GGIMesaContext GGIMesa = NULL;    /* the current context */

ggi_extid gl_ggi_extid;

int gl_ggi_init=GL_FALSE;
int gl_ggi_debug=GL_FALSE;

static void gl_ggiUpdateState(GLcontext *ctx);
static int gl_ggi_change(ggi_visual_t vis,int whatchanged);

void gl_ggiPrint(char *format,...)
{
	va_list args;
	va_start(args,format);
	fprintf(stderr,"ggimesa: ");
	vfprintf(stderr,format,args);
	va_end(args);
}

void gl_ggiDEBUG(char *format,...)
{
	va_list args;
	if (gl_ggi_debug)
	{
		va_start(args,format);
		fprintf(stderr,"ggimesa: ");
		vfprintf(stderr,format,args);
		va_end(args);
	}
}

static void gl_ggiGetSize( GLcontext *ctx, GLuint *width, GLuint *height )
{
	*width = GGIMesa->width; 
	*height = GGIMesa->height; 
}

static void gl_ggiSetIndex( GLcontext *ctx, GLuint ci)
{
	ggiSetGCForeground(VIS,ci);
	GGICTX->color=(ggi_pixel)ci;
}

static void gl_ggiSetClearIndex( GLcontext *ctx, GLuint ci)
{
	ggiSetGCForeground(VIS,ci);
	GGICTX->clearcolor=(ggi_pixel)ci;
}

static void gl_ggiSetColor( GLcontext *ctx,
                       GLubyte red, GLubyte green,
                       GLubyte blue, GLubyte alpha )
{
	ggi_color rgb;
	ggi_pixel col;
	rgb.r= (uint16)red   << SHIFT;
	rgb.g= (uint16)green << SHIFT;
	rgb.b= (uint16)blue  << SHIFT;
	col = ggiMapColor(VIS,&rgb);
	ggiSetGCForeground(VIS,col);
	GGICTX->color=col;
}

static void gl_ggiSetClearColor( GLcontext *ctx,
                       GLubyte red, GLubyte green,
                       GLubyte blue, GLubyte alpha )
{
	ggi_color rgb;
	ggi_pixel col;
	rgb.r=(uint16)red   << SHIFT;
	rgb.g=(uint16)green << SHIFT;
	rgb.b=(uint16)blue  << SHIFT;
	col=ggiMapColor(VIS,&rgb);
	ggiSetGCForeground(VIS,col);
	GGICTX->clearcolor=col;
}

static GLbitfield gl_ggiClear( GLcontext *ctx,GLbitfield mask,
			GLboolean all,
			GLint x, GLint y, GLint width, GLint height )
{

	if (mask & GL_COLOR_BUFFER_BIT) 
	{
		ggiSetGCForeground(VIS,GGICTX->clearcolor);

		if (all)
		{
			ggiDrawBox(VIS,0,GGIMesa->origin.y,
				GGIMesa->width, GGIMesa->height);
		}
		else
		{
			ggiDrawBox(VIS,x,FLIP(y),width,height);
		}

		ggiSetGCForeground(VIS,GGICTX->color);
	}
	return mask & (~GL_COLOR_BUFFER_BIT);
}

static GLboolean gl_ggiSetBuffer( GLcontext *ctx,
                             GLenum mode )
{
	int y;
/*
	if (mode==GL_FRONT) 
		gl_ggiPrint("GL_FRONT\n"); 
	else 
		gl_ggiPrint("GL_BACK\n");
*/
	if (mode==GL_FRONT)
	{
		 y = (GGICTX->origin.y) ? 0 : GGICTX->height;
	}
	else	
	{
		 y=GGICTX->origin.y;
	}

	GGICTX->flip_y = y + GGICTX->height - 1; 

	return GL_TRUE;
}

static const char * gl_ggiRendererString(void)
{
	return "GGI";
}

static void gl_ggiFlush(GLcontext *ctx)
{
	ggiFlush(VIS);
}

static void gl_ggiSetupPointers( GLcontext *ctx )
{
   /* Initialize all the pointers in the DD struct.  Do this whenever */
   /* a new context is made current or we change buffers via set_buffer! */

	ctx->Driver.RendererString = gl_ggiRendererString;
	ctx->Driver.UpdateState = gl_ggiUpdateState;

	ctx->Driver.ClearIndex = gl_ggiSetClearIndex; 
	ctx->Driver.ClearColor = gl_ggiSetClearColor;
	ctx->Driver.Clear = gl_ggiClear;
	ctx->Driver.Index = gl_ggiSetIndex;
	ctx->Driver.Color = gl_ggiSetColor;
	ctx->Driver.SetBuffer = gl_ggiSetBuffer;
	ctx->Driver.GetBufferSize = gl_ggiGetSize;
	ctx->Driver.Finish = gl_ggiFlush;
	ctx->Driver.Flush = gl_ggiFlush;

}

static int gl_ggiInitInfo(GGIMesaContext ctx,struct ggi_mesa_info *info)
{
	int virty,visy,err;

	if (info->db_flag)
	{
		virty = ggiGetInfo(ctx->ggi_vis)->mode->virt.y;
		visy =  ggiGetInfo(ctx->ggi_vis)->mode->visible.y;

		if (virty < 2 * visy)
		{
			gl_ggiPrint(" visible y %i, virtual y %i\n",visy,virty);
			gl_ggiPrint("ggiInitInfo: no doublebuffer possible!\n");
			return -1;
		}
	}

	info->depth_bits=DEPTH_BITS;
	info->stencil_bits=STENCIL_BITS;
	info->accum_bits=ACCUM_BITS;

	if (info->rgb_flag)
	{		
		info->rgb_flag=GL_TRUE;
		info->alpha_flag=GL_FALSE;
		info->index_bits=0;

		info->red_bits=8;
		info->green_bits=8;
		info->blue_bits=8;

		info->alpha_bits=0;
	}
	else
	{
		info->alpha_flag=GL_FALSE;

		info->index_bits=ggiGetInfo(ctx->ggi_vis)->fb.bpc;
		info->red_bits=info->green_bits=info->blue_bits=
				info->alpha_bits=0;
	}

	return 0;
}

GGIMesaContext GGIMesaCreateContext(void)
{
	GGIMesaContext ctx;
	char *s;

	s=getenv("GGIMESA_DEBUG");
	gl_ggi_debug=(s && atoi(s));
	gl_ggiDEBUG("GGIMesaCreateContext:\n");

	if (gl_ggiInit()<0) 		/* register extensions*/
	{
		return NULL;
	}

	ctx = (GGIMesaContext) calloc(1,sizeof(struct ggi_mesa_context));
	if (!ctx) return NULL;
	ctx->gl_vis=(GLvisual *)calloc(1,sizeof(GLvisual));
	if (!ctx->gl_vis) return NULL;

	ctx->viewport_init=GL_FALSE;	
	ctx->gl_vis->DBflag=GL_FALSE;

	ctx->gl_ctx = gl_create_context(ctx->gl_vis,NULL,(void *)ctx,GL_TRUE);
	if (!ctx->gl_ctx) return NULL;
	
	gl_ggiDEBUG("GGIMesaCreateContext: done.\n");
	return ctx;
}

void GGIMesaDestroyContext( GGIMesaContext ctx )
{
	if (ctx) 
	{
		gl_destroy_visual(ctx->gl_vis);
		gl_destroy_context(ctx->gl_ctx);
		gl_destroy_framebuffer(ctx->gl_buffer);
		if (ctx==GGIMesa) 
			GGIMesa = NULL;
		if (ctx->ggi_vis) ggiExtensionDetach(ctx->ggi_vis,gl_ggi_extid);
		ggiExtensionUnregister(gl_ggi_extid);
		free(ctx);
	}
}

int GGIMesaSetVisual( GGIMesaContext ctx,ggi_visual_t vis,
			GLboolean rgb_flag,GLboolean db_flag)
{
	struct ggi_mesa_info info;
	int err;
	uint16 r,g,b;
	ggi_color pal[256];
	int i;
	void *func;

	gl_ggiDEBUG("GGIMesaSetVisual:\n");

	if (!ctx) return -1;
	if (!vis) return -1;

	if (ctx->ggi_vis) ggiExtensionDetach(ctx->ggi_vis,gl_ggi_extid);

	ctx->ggi_vis=vis;

	err=ggiExtensionAttach(vis,gl_ggi_extid);
	if (err<0) return -1;
	if (err==0) gl_ggi_change(vis,GGI_CHG_APILIST);
	
	if (ctx->gl_vis)
		gl_destroy_visual(ctx->gl_vis);

	if (ctx->gl_buffer)
		gl_destroy_framebuffer(ctx->gl_buffer);	

	info.rgb_flag = rgb_flag;
	info.db_flag  = db_flag;

	err=gl_ggiInitInfo(ctx,&info);
	if (err) return -1;

	gl_ggiSetupPointers(ctx->gl_ctx);

	func=(void*)VIS_OPMESA(ctx->ggi_vis)->setup_driver;

	if (!func) 
	{
		gl_ggiPrint("setup_driver==NULL !\n");
		gl_ggiPrint("Please check your config files!\n");
		return -1;
	}

	err=VIS_OPMESA(ctx->ggi_vis)->setup_driver(ctx,&info);
	if (err) return -1;

	ctx->gl_vis = gl_create_visual( info.rgb_flag,
	                                info.alpha_flag,
	                                info.db_flag,
					GL_FALSE,
        	                        info.depth_bits, 
                	                info.stencil_bits,
                        	        info.accum_bits,
                                	info.index_bits,
	                               	info.red_bits, info.green_bits,
        	                        info.blue_bits, info.alpha_bits);
	if (!ctx->gl_vis) {
		gl_ggiPrint("Can't create gl_visual!!!\n");
		return -1;
	}

	ctx->gl_buffer = gl_create_framebuffer(ctx->gl_vis);

	if (!ctx->gl_buffer) {
		gl_ggiPrint("Can't create gl_buffer!!!\n");
		return -1;
	}

	ctx->width = ggiGetInfo(ctx->ggi_vis)->mode->visible.x;
	ctx->height = ggiGetInfo(ctx->ggi_vis)->mode->visible.y;
	ctx->stride = ggiGetInfo(ctx->ggi_vis)->mode->virt.x;
	ctx->origin.x=0;
	ctx->origin.y=(info.db_flag) ? ctx->height : 0; 
	ctx->flip_y=ctx->origin.y+ctx->height-1; 

	ctx->color = 0;

	ctx->lfb=ggiGetInfo(ctx->ggi_vis)->fb.linear; /*FIXME: direct buffer*/

	ctx->gl_ctx->Visual=ctx->gl_vis;
	ctx->gl_ctx->Pixel.ReadBuffer= 
	ctx->gl_ctx->Color.DrawBuffer= (db_flag) ? GL_BACK : GL_FRONT;

	if (GGIMesa==ctx)
		gl_make_current(ctx->gl_ctx, ctx->gl_buffer);

	if (rgb_flag && ggiGetInfo(ctx->ggi_vis)->mode->graphtype==GT_8BIT)
	{

		for (i=r=0;r<8;r++)
			for (g=0;g<8;g++)
				for (b=0;b<4;b++,i++)
				{
					pal[i].r=r<<(GGI_COLOR_PRECISION-3);	
					pal[i].g=g<<(GGI_COLOR_PRECISION-3);	
					pal[i].b=b<<(GGI_COLOR_PRECISION-2);	
				}
		ggiSetPaletteVec(ctx->ggi_vis,0,256,pal);	
	}

	gl_ggiDEBUG("GGIMesaSetVisual: done.\n");
	return 0;
}

void GGIMesaMakeCurrent( GGIMesaContext ctx )
{
	if (!ctx->ggi_vis) return;
	GGIMesa = ctx;
	gl_make_current( ctx->gl_ctx, ctx->gl_buffer );
	
	if (!ctx->viewport_init)
	{
		gl_Viewport( ctx->gl_ctx, 0, 0, ctx->width, ctx->height );
		ctx->viewport_init=GL_TRUE;
	}
}

GGIMesaContext GGIMesaGetCurrentContext( void )
{
	return GGIMesa;
}

/*
 * Swap front/back buffers for current context if double buffered.
 */
void GGIMesaSwapBuffers( void )
{
	if (GGIMesa->gl_vis->DBflag) 
	{
		ggiSetOrigin(VIS,GGIMesa->origin.x,GGIMesa->origin.y);

		if (GGIMesa->origin.y) GGIMesa->origin.y=0;
		else GGIMesa->origin.y=GGIMesa->height;
		
		GGIMesa->flip_y=GGIMesa->origin.y+GGIMesa->height-1;  
	}
}

static void gl_ggiLoadLibrary(ggi_visual_t vis,char *driver,char *args)
{
	char str[1024];

	strncpy(str,driver,1000);
	strcat(str,"-mesa");

	if (ggiLoadLibrary(vis,str,args)) {
		gl_ggiDEBUG("vis %p: \"%s\" loaded!\n",vis,str);
	}
	else
	{
		if (strcmp(driver,"generic-stubs")==0)
		{
			gl_ggiPrint("%s not found!\n",str);
			gl_ggiPrint("Please check your config files.\n");
			ggiPanic("");
		}
	}
}

static int gl_ggi_change(ggi_visual_t vis,int whatchanged)
{
	char api[1024];
	char args[1024];
	int i;

	gl_ggiDEBUG("gl_ggi_change:\n");
	switch (whatchanged)
	{
		case GGI_CHG_APILIST:
		{
			gl_ggiDEBUG("\tGGI_CHG_APILIST:\n");
			for (i=0;ggiGetAPI(vis,i,api,args)==0;i++)
			{
				gl_ggiDEBUG("----> \"%s\" - \"%s\"\n",api,args);
				gl_ggiLoadLibrary(vis,api,args);
			}
			
		} break;
		default:
		gl_ggiPrint("gl_ggi_changed: unknown value %i\n",whatchanged);
		break;
	}
	gl_ggiDEBUG("gl_ggi_change: done.\n");
	return 0;
}

int gl_ggiInit()
{
	if (gl_ggi_init) return 0;


	gl_ggi_extid=ggiExtensionRegister("GGI-Mesa",sizeof(struct ggi_mesa_op),
				gl_ggi_change);
	if (gl_ggi_extid>=0) 
	{
		gl_ggiDEBUG("Registered extension %i\n",gl_ggi_extid);
		gl_ggi_init=GL_TRUE;
		return 0;
	}

	gl_ggiPrint("Can't register extension!\n");
	return -1;	
}

static void gl_ggiUpdateState(GLcontext *ctx)
{
	void *func;

	func=(void *)CTX_OPMESA(ctx)->update_state;

	if (!func) {
		gl_ggiPrint("update_state==NULL !\n");
		gl_ggiPrint("Please check your config files!\n");
		ggiPanic("");
	}

	CTX_OPMESA(ctx)->update_state(ctx);
}

#else
/*
 * Need this to provide at least one external definition when GGI is
 * not defined on the compiler command line.
 */

int gl_ggi_dummy_function(void)
{
	return 0;
}

#endif
