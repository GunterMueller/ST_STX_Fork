/* $XConsortium: XKBlibint.h,v 1.6 94/04/01 18:44:18 erik Exp $ */
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

#ifndef _XKBLIBINT_H_
#define	_XKBLIBINT_H_

#include <X11/XKBlib.h>

#define	XkbMapPending	(1<<0)

typedef int	(*XkbKSToMBFunc)(
#if NeedFunctionPrototypes
	XPointer	/* priv */,
	KeySym		/* sym */,
	char *		/* buf */,
	int		/* len */,
	Status *	/* status */
#endif
);

typedef KeySym	(*XkbMBToKSFunc)(
#if NeedFunctionPrototypes
	XPointer	/* priv */,
	char *		/* buf */,
	int		/* len */,
	Status *	/* status */
#endif
);

typedef KeySym	(*XkbToUpperFunc)(
#if NeedFunctionPrototypes
	KeySym		/* sym */
#endif
);

typedef struct _XkbConverters {
	XkbKSToMBFunc	 KSToMB;
	XPointer	 KSToMBPriv;
	XkbMBToKSFunc	 MBToKS;
	XPointer	 MBToKSPriv;
	XkbToUpperFunc	 KSToUpper;
} XkbConverters;

typedef struct _XkbInfoRec {
	unsigned	 flags;
	XExtCodes	 *codes;
	int		 srv_major;
	int		 srv_minor;
	unsigned	 selected_events;
	XkbDescRec	*desc;
	XkbMapChangesRec changes;

	char		*modmap;
	char		*charset;
	XkbConverters	 cvt;
} XkbInfoRec, *XkbInfoPtr;

	/*
	 * mask of the events that the "invisible" XKB support in Xlib needs
	 */
#define XKB_XLIB_MAP_MASK (XkbFullClientInfoMask)

	/*
	 * Handy helper macros 
	 */
#define	XKB_INSURE_SIZE(f,t,nNum,oNum)	{\
	if ((f)==NULL)	\
	     (f)=(t *)Xmalloc(sizeof(t)*(nNum));\
	else if ((nNum)<(oNum))\
	     (f)=(t *)Xrealloc((f),sizeof(t)*(nNum));\
	}

typedef struct _XkbReadBuffer {
	int	 error;
	int	 size;
	char	*start;
	char	*data;
} XkbReadBufferRec,*XkbReadBufferPtr;

_XFUNCPROTOBEGIN

extern	int _XkbInitReadBuffer(
#if NeedFunctionPrototypes
    Display *		/* dpy */,
    XkbReadBufferPtr	/* buf */,
    int			/* size */
#endif
);

extern int _XkbSkipReadBufferData(
#if NeedFunctionPrototypes
    XkbReadBufferPtr	/* from */,
    int			/* size */
#endif
);

extern int _XkbCopyFromReadBuffer(
#if NeedFunctionPrototypes
    XkbReadBufferPtr	/* from */,
    char *		/* to */,
    int			/* size */
#endif
);


#if defined(WORD64) || defined(LONG64)
extern	int _XkbCopyData32(
#if NeedFunctionPrototypes
    int *		/* from */,
    long *		/* lp */,
    int			/* num_words */
#endif
);

extern int _XkbReadBufferCopy32(
#if NeedFunctionPrototypes
    XkbReadBufferPtr	/* from */,
    long *		/* to */,
    int			/* size */
#endif
);
#else
#define	_XkbCopyData32(f,t,s)	    memcpy((char *)(t),(char *)(f),(s)*4)
#define	_XkbReadBufferCopy32(f,t,s) _XkbCopyFromReadBuffer(f,(char *)t,(s)*4)
#endif

extern char *_XkbPeekAtReadBuffer(
#if NeedFunctionPrototypes
    XkbReadBufferPtr	/* from */,
    int			/*  size */
#endif
);

extern char *_XkbGetReadBufferPtr(
#if NeedFunctionPrototypes
    XkbReadBufferPtr	/* from */,
    int			/* size */
#endif
);

extern int _XkbFreeReadBuffer(
#if NeedFunctionPrototypes
    XkbReadBufferPtr	/* buf */
#endif
);

extern char	*_XkbGetCharset(
#if NeedFunctionPrototypes
	char *		/* locale */
#endif
);
extern int	 _XkbGetConverters(
#if NeedFunctionPrototypes
	char *		/* charset */,
	XkbConverters *	/* cvt_rtrn */
#endif
);

extern Status _XkbRefreshMapping(
#if NeedFunctionPrototypes
	Display *			/* display */,
	XkbDescRec *			/* xkb */,
	XkbChangesRec *			/* ev */
#endif
);

_XFUNCPROTOEND

#endif /* _XKBLIBINT_H_ */
