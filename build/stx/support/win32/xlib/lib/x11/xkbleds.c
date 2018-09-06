/* $XConsortium: XKBleds.c,v 1.1 94/04/01 18:42:43 erik Exp $ */
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

Status
XkbGetIndicatorState(dpy,deviceSpec,pStateRtrn)
    Display *		dpy;
    unsigned int	deviceSpec;
    unsigned int *	pStateRtrn;
{
    register xkbGetIndicatorStateReq *req;
    xkbGetIndicatorStateReply	rep;
    XkbInfoPtr xkbi;

    
    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbGetIndicatorState, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbGetIndicatorState;
    req->deviceSpec = deviceSpec;
    if (!_XReply(dpy, (xReply *)&rep, 0, xFalse)) {
	UnlockDisplay(dpy);
	SyncHandle();
	return False;
    }
    if (pStateRtrn)
	*pStateRtrn= rep.state;
    return True;
}

Status
XkbGetIndicatorMap(dpy,which,xkb)
    Display *dpy;
    unsigned long which;
    XkbDescRec *xkb;
{
    register xkbGetIndicatorMapReq	*req;
    XkbIndicatorRec	*leds;
    xkbGetIndicatorMapReply rep;
    XkbInfoPtr xkbi;
    XkbReadBufferRec buf;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    if ((!which)||(!xkb))
	return False;

    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbGetIndicatorMap, req);
    if (!xkb->indicators) {
	xkb->indicators = (XkbIndicatorRec *)Xmalloc(sizeof(XkbIndicatorRec));
	if (xkb->indicators)
	    bzero(xkb->indicators,sizeof(XkbIndicatorRec));
    }
    leds = xkb->indicators;
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbGetIndicatorMap;
    req->deviceSpec = xkb->device_spec;
    req->which = which;
    if (!_XReply(dpy, (xReply *)&rep, 0, xFalse)) {
	UnlockDisplay(dpy);
	SyncHandle();
	return False;
    }

    leds->num_phys_indicators = rep.nRealIndicators;
    if (rep.length>0) {
	register int left;
	if (!_XkbInitReadBuffer(dpy,&buf,rep.length*4)) {
	    UnlockDisplay(dpy);
	    SyncHandle();
	    return False;
	}

	if (rep.which) {
	    register int i,bit;
	    left= rep.which;
	    for (i=0,bit=1;(i<XkbNumIndicators)&&(left);i++,bit<<=1) {
		if (left&bit) {
		    xkbIndicatorMapWireDesc *wire;
		    wire= (xkbIndicatorMapWireDesc *)
			  _XkbGetReadBufferPtr(&buf,
					SIZEOF(xkbIndicatorMapWireDesc));
		    if (wire==NULL) {
			_XkbFreeReadBuffer(&buf);
			UnlockDisplay(dpy);
			SyncHandle();
			return True;
		    }
		    leds->maps[i].flags= wire->flags;
		    leds->maps[i].which_groups= wire->whichGroups;
		    leds->maps[i].groups= wire->groups;
		    leds->maps[i].which_mods= wire->whichMods;
		    leds->maps[i].mask= wire->mods;
		    leds->maps[i].real_mods= wire->realMods;
		    leds->maps[i].vmods= wire->virtualMods;
		    leds->maps[i].ctrls= wire->ctrls;
		    left&= ~bit;
		}
	    }
	}
	left= _XkbFreeReadBuffer(&buf);
	if (left>0) {
	    fprintf(stderr,"GetIndicatorMap! Extra data %d bytes\n",left);
	}
    }
    UnlockDisplay(dpy);
    SyncHandle();
    return True;
}

Status
XkbSetIndicatorMap(dpy,which,xkb)
    Display *dpy;
    unsigned long which;
    XkbDescRec *xkb;
{
    register xkbSetIndicatorMapReq	*req;
    register int i,bit;
    int nMaps;
    xkbIndicatorMapWireDesc *wire;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    if ((!xkb)||(!which)||(!xkb->indicators))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbSetIndicatorMap, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbSetIndicatorMap;
    req->deviceSpec = xkb->device_spec;
    req->which = which;
    for (i=nMaps=0,bit=1;i<32;i++,bit<<=1) {
	if (which&bit)
	    nMaps++;
    }
    req->length+= (nMaps*sizeof(XkbIndicatorMapRec))/4;
    BufAlloc(xkbIndicatorMapWireDesc *,wire,
				       (nMaps*SIZEOF(xkbIndicatorMapWireDesc)));
    for (i=0,bit=1;i<32;i++,bit<<=1) {
	if (which&bit) {
	    wire->flags= xkb->indicators->maps[i].flags;
	    wire->whichGroups= xkb->indicators->maps[i].which_groups;
	    wire->groups= xkb->indicators->maps[i].groups;
	    wire->whichMods= xkb->indicators->maps[i].which_mods;
	    wire->mods= xkb->indicators->maps[i].mask;
	    wire->virtualMods= xkb->indicators->maps[i].vmods;
	    wire->ctrls= xkb->indicators->maps[i].ctrls;
	    wire++;
	}
    }
    UnlockDisplay(dpy);
    SyncHandle();
    return True;
}

