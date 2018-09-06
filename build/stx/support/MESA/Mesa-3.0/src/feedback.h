/* $Id: feedback.h,v 1.1 1998-10-05 22:31:49 cg Exp $ */

/*
 * Mesa 3-D graphics library
 * Version:  3.0
 * Copyright (C) 1995-1998  Brian Paul
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
 */


/*
 * $Log: feedback.h,v $
 * Revision 1.1  1998-10-05 22:31:49  cg
 * *** empty log message ***
 *
 * Revision 3.0  1998/01/31 20:52:30  brianp
 * initial rev
 *
 */


#ifndef FEEDBACK_H
#define FEEDBACK_H


#include "types.h"


#define FEEDBACK_TOKEN( CTX, T )				\
	if (CTX->Feedback.Count < CTX->Feedback.BufferSize) {	\
	   CTX->Feedback.Buffer[CTX->Feedback.Count] = (T);	\
	}							\
	CTX->Feedback.Count++;


extern void gl_feedback_vertex( GLcontext *ctx,
                                GLfloat x, GLfloat y, GLfloat z, GLfloat w,
                                const GLfloat color[4], GLfloat index,
                                const GLfloat texcoord[4] );


extern void gl_update_hitflag( GLcontext *ctx, GLfloat z );


extern void gl_PassThrough( GLcontext *ctx, GLfloat token );

extern void gl_FeedbackBuffer( GLcontext *ctx, GLsizei size,
                               GLenum type, GLfloat *buffer );

extern void gl_SelectBuffer( GLcontext *ctx, GLsizei size, GLuint *buffer );

extern void gl_InitNames( GLcontext *ctx );

extern void gl_LoadName( GLcontext *ctx, GLuint name );

extern void gl_PushName( GLcontext *ctx, GLuint name );

extern void gl_PopName( GLcontext *ctx );

extern GLint gl_RenderMode( GLcontext *ctx, GLenum mode );



#endif

