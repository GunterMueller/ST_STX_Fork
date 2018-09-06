/* $XConsortium: XKBCtrls.c,v 1.1 94/04/01 18:41:19 erik Exp $ */
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


static xkbSetControlsReq *
_XkbGetSetControlsReq(dpy,xkbi,deviceSpec)
    Display *		dpy;
    XkbInfoPtr		xkbi;
    unsigned int	deviceSpec;
{
xkbSetControlsReq *req;

    GetReq(kbSetControls,req);
    bzero(req,SIZEOF(xkbSetControlsReq));
    req->reqType = xkbi->codes->major_opcode;
    req->length = (SIZEOF(xkbSetControlsReq)>>2);
    req->xkbReqType = X_kbSetControls;
    req->deviceSpec = deviceSpec;
    return req;
}

Status XkbSetAutoRepeatRate(dpy, deviceSpec, timeout, interval)
    Display *dpy;
    unsigned int deviceSpec;
    unsigned int timeout;
    unsigned int interval;
{
    register xkbSetControlsReq *req;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    req= _XkbGetSetControlsReq(dpy,dpy->xkb_info,deviceSpec);
    req->changeControls = XkbRepeatKeysMask;
    req->repeatDelay = timeout;
    req->repeatInterval = interval;
    UnlockDisplay(dpy);
    SyncHandle();
    return 1;
}

Bool XkbGetAutoRepeatRate(dpy, deviceSpec, timeoutp, intervalp)
    Display *dpy;
    unsigned int deviceSpec;
    unsigned int *timeoutp;
    unsigned int *intervalp;
{
    register xkbGetControlsReq *req;
    xkbGetControlsReply rep;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbGetControls, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbGetControls;
    req->deviceSpec = deviceSpec;
    if (!_XReply(dpy, (xReply *)&rep, 
		(SIZEOF(xkbGetControlsReply)-SIZEOF(xReply))>>2, xFalse)) {
	UnlockDisplay(dpy);
	SyncHandle();
	return False;
    }
    UnlockDisplay(dpy);
    SyncHandle();
    *timeoutp = rep.repeatDelay;
    *intervalp = rep.repeatInterval;
    return True;
}

Status
XkbSetServerInternalMods(dpy,deviceSpec,affect,values)
    Display *dpy;
    unsigned deviceSpec;
    unsigned affect;
    unsigned values;
{
    register xkbSetControlsReq *req;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    req= _XkbGetSetControlsReq(dpy,dpy->xkb_info,deviceSpec);
    req->affectInternalRealMods = affect;
    req->internalRealMods = values;
    req->affectInternalVirtualMods= 0;
    req->internalVirtualMods= 0;
    req->changeControls = XkbInternalModsMask;
    UnlockDisplay(dpy);
    SyncHandle();
    return 1;
}

Status
XkbSetIgnoreLockMods(dpy,deviceSpec,affect,values)
    Display *dpy;
    unsigned int deviceSpec;
    unsigned int affect;
    unsigned int values;
{
    register xkbSetControlsReq *req;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    req= _XkbGetSetControlsReq(dpy,dpy->xkb_info,deviceSpec);
    req->affectIgnoreLockRealMods= affect;
    req->ignoreLockRealMods = values;
    req->affectIgnoreLockVirtualMods= 0;
    req->ignoreLockVirtualMods= 0;
    req->changeControls = XkbIgnoreLockModsMask;
    UnlockDisplay(dpy);
    SyncHandle();
    return 1;
}

Bool XkbGetControls(dpy, which, xkb)
    Display *dpy;
    unsigned long which;
    XkbDescRec	*xkb;
{
    register xkbGetControlsReq *req;
    xkbGetControlsReply rep;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    if ((!xkb) || (!which))
	return False;

    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbGetControls, req);
    if (!xkb->ctrls)  {
	xkb->ctrls = (XkbControlsRec *)Xmalloc(sizeof(XkbControlsRec));
	if (!xkb->ctrls) {
	    UnlockDisplay(dpy);
	    SyncHandle();
	    return False;
	} 
	bzero(xkb->ctrls,sizeof(XkbControlsRec));
    }
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbGetControls;
    req->deviceSpec = xkb->device_spec;
    if (!_XReply(dpy, (xReply *)&rep, 
		(SIZEOF(xkbGetControlsReply)-SIZEOF(xReply))>>2, xFalse)) {
	UnlockDisplay(dpy);
	SyncHandle();
	return False;
    }
    if (xkb->device_spec==XkbUseCoreKbd)
	xkb->device_spec= rep.deviceID;
    xkb->ctrls->enabled_ctrls = rep.enabledControls;
    if (which&XkbKeyboardGroupsMask) 
	xkb->ctrls->num_groups= rep.numGroups;
    if (which&XkbInternalModsMask) {
	xkb->ctrls->internal_mask = rep.internalMods;
	xkb->ctrls->internal_real_mods = rep.internalRealMods;
	xkb->ctrls->internal_vmods = rep.internalVirtualMods;
    }
    if (which&XkbIgnoreLockModsMask) {
	xkb->ctrls->ignore_lock_mask = rep.ignoreLockMods;
	xkb->ctrls->ignore_lock_real_mods = rep.ignoreLockRealMods;
	xkb->ctrls->ignore_lock_vmods = rep.ignoreLockVirtualMods;
    }
    if (which&XkbRepeatKeysMask) {
	xkb->ctrls->repeat_delay = rep.repeatDelay;
	xkb->ctrls->repeat_interval = rep.repeatInterval;
    }
    if (which&XkbSlowKeysMask)
	xkb->ctrls->slow_keys_delay = rep.slowKeysDelay;
    if (which&XkbBounceKeysMask)
	xkb->ctrls->debounce_delay = rep.debounceDelay;
    if (which&XkbMouseKeysMask) {
	xkb->ctrls->mouse_keys_dflt_btn = rep.mouseKeysDfltBtn;
	xkb->ctrls->mouse_keys_delay = rep.mouseKeysDelay;
	xkb->ctrls->mouse_keys_interval = rep.mouseKeysInterval;
    }
    if (which&XkbMouseKeysAccelMask) {
	xkb->ctrls->mouse_keys_time_to_max = rep.mouseKeysTimeToMax;
	xkb->ctrls->mouse_keys_max_speed = rep.mouseKeysMaxSpeed;
	xkb->ctrls->mouse_keys_curve = rep.mouseKeysCurve;
    }
    if (which&XkbAccessXTimeoutMask) {
	xkb->ctrls->accessx_timeout = rep.accessXTimeout;
	xkb->ctrls->accessx_timeout_mask = rep.accessXTimeoutMask;
    }
    UnlockDisplay(dpy);
    SyncHandle();
    return True;
}

Bool XkbSetControls(dpy, which, xkb)
    Display *dpy;
    unsigned long which;
    XkbDescRec	*xkb;
{
    register xkbSetControlsReq *req;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    if ((!xkb)||(!xkb->ctrls))
	return False;

    LockDisplay(dpy);
    req= _XkbGetSetControlsReq(dpy,dpy->xkb_info,xkb->device_spec);
    req->changeControls = which;
    if (which&XkbInternalModsMask) {
	req->affectInternalRealMods= ~0;
	req->internalRealMods= xkb->ctrls->internal_real_mods;
	req->affectInternalVirtualMods = ~0;
	req->internalVirtualMods= xkb->ctrls->internal_vmods;
    }
    if (which&XkbIgnoreLockModsMask) {
	req->affectIgnoreLockRealMods= ~0;
	req->ignoreLockRealMods= xkb->ctrls->ignore_lock_real_mods;
	req->affectIgnoreLockVirtualMods= ~0;
	req->ignoreLockVirtualMods= xkb->ctrls->ignore_lock_vmods;
    }
    if (which&XkbControlsEnabledMask) {
	req->affectEnabledControls= XkbAllControlsMask;
	req->enabledControls= xkb->ctrls->enabled_ctrls;
    }
    if (which&XkbRepeatKeysMask) {
	req->repeatDelay = xkb->ctrls->repeat_delay;
	req->repeatInterval = xkb->ctrls->repeat_interval;
    }
    if (which&XkbSlowKeysMask)
	 req->slowKeysDelay = xkb->ctrls->slow_keys_delay;
    if (which&XkbBounceKeysMask)
	 req->debounceDelay = xkb->ctrls->debounce_delay;
    if (which&XkbMouseKeysMask) {
	req->mouseKeysDfltBtn = xkb->ctrls->mouse_keys_dflt_btn;
	req->mouseKeysDelay = xkb->ctrls->mouse_keys_delay;
	req->mouseKeysInterval = xkb->ctrls->mouse_keys_interval;
	req->mouseKeysTimeToMax = xkb->ctrls->mouse_keys_time_to_max;
	req->mouseKeysCurve = xkb->ctrls->mouse_keys_curve;
    }
    if (which&XkbAccessXTimeoutMask) {
	 req->accessXTimeout = xkb->ctrls->accessx_timeout;
	 req->accessXTimeoutMask = xkb->ctrls->accessx_timeout_mask;
    }
    UnlockDisplay(dpy);
    SyncHandle();
    return 1;
}

