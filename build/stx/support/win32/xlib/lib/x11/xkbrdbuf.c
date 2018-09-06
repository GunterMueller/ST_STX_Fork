/* $XConsortium: XKBRdBuf.c,v 1.2 94/04/02 14:31:36 erik Exp $ */
/************************************************************
Copyright (c) 1993 by Silicon Graphics Computer Systems, Inc.

Permission to use, copy, modify, and distribute this
software and its documentation for any purpose and without
fee is hereby granted, provided that the above copyright
notice appear in all copies and that both that copyright
notice and this permission notice appear in supporting
documentation, and that the name of Silicon Graphics not be 
used in advertising or publicity pertaining to distribution 
of the software without specific prior written permission.
Silicon Graphics makes no representation about the suitability 
of this software for any purpose. It is provided "as is"
without any express or implied warranty.

SILICON GRAPHICS DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS 
SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY 
AND FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL SILICON
GRAPHICS BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL 
DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, 
DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE 
OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION  WITH
THE USE OR PERFORMANCE OF THIS SOFTWARE.

********************************************************/

#include <stdio.h>
#define NEED_REPLIES
#define NEED_EVENTS
#include "Xlibint.h"
#include <X11/extensions/XKBproto.h>
#include "XKBlibint.h"

/***====================================================================***/

int 
_XkbInitReadBuffer(dpy,buf,size)
    Display		*dpy;
    XkbReadBufferPtr	 buf;
    int			 size;
{
    if ((dpy!=NULL) && (buf!=NULL) && (size>0)) {
	buf->error=  0;
	buf->size=   size;
	buf->start= buf->data= Xmalloc(size);
	if (buf->start) {
	    _XRead(dpy, buf->start, size);
	    return 1;
	}
    }
    return 0;
}

#define	_XkbReadBufferDataLeft(b)	(((b)->size)-((b)->data-(b)->start))

int
_XkbSkipReadBufferData(from,size)
    XkbReadBufferPtr	 from;
    int			 size;
{
    if (size==0)
	return 1;
    if ((from==NULL)||(from->error)||(size<1)||
					(_XkbReadBufferDataLeft(from)<size))
	return 0;
    from->data+= size;
    return 1;
}

int
_XkbCopyFromReadBuffer(from,to,size)
    XkbReadBufferPtr	 from;
    char		*to;
    int			 size;
{
    if (size==0)
	return 1;
    if ((from==NULL)||(from->error)||(to==NULL)||(size<1)||
					(_XkbReadBufferDataLeft(from)<size))
	return 0;
    memcpy(to,from->data,size);
    from->data+= size;
    return 1;
}

#ifdef LONG64
int
_XkbCopyData32(wire,to,num_words)
    int *		wire;
    long *		to;
    int			num_words;
{
    while (num_words-->0) {
	*to++= *wire++;
    }
    return 1;
}
#endif
#ifdef WORD64
int
_XkbCopyData32(from,lp,num_words)
    int *		from;
    long *		lp;
    int			num_words;
{
long *lpack;
long mask32 = 0x00000000ffffffff;
long maskw, i, bits;

    lpack = (long *)from;
    bits = 32;

    for (i=0;i<num_words;i++) {
	maskw = mask32 << bits;
	*lp++ = (*lpack & maskw) >> bits;
	bits = bits ^ 32;
	if (bits)
	    lpack++;
    }
    return 1;
}
#endif

#if defined(LONG64) || defined(WORD64)
int
_XkbReadBufferCopy32(from,to,num_words)
    XkbReadBufferPtr	from;
    long *		to;
    int			num_words;
{
    if ((unsigned)(num_words*4)>_XkbReadBufferDataLeft(from))
	return 0;
    _XkbCopyData32((int *)from->data,to,num_words);
    from->data+= (4*num_words);
    return True;
}
#endif

char *
_XkbPeekAtReadBuffer(from,size)
    XkbReadBufferPtr	 from;
    int			 size;
{
    if ((from==NULL)||(from->error)||(size<1)||
					(_XkbReadBufferDataLeft(from)<size))
	return 0;
    return from->data;
}

char *
_XkbGetReadBufferPtr(from,size)
    XkbReadBufferPtr	 from;
    int			 size;
{
char	*ptr;
    if ((from==NULL)||(from->error)||(size<1)||
					(_XkbReadBufferDataLeft(from)<size))
	return 0;
    ptr= from->data;
    from->data+= size;
    return ptr;
}


int
_XkbFreeReadBuffer(buf)
    XkbReadBufferPtr	buf;
{
    if ((buf!=NULL) && (buf->start!=NULL)) {
	int left;
	left= _XkbReadBufferDataLeft(buf);
	if (buf->start!=NULL)
	    Xfree(buf->start);
	buf->size= 0;
	buf->start= buf->data= NULL;
	return left;
    }
    return 0;
}

