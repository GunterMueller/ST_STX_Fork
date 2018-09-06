/* $XConsortium: XKBUse.c,v 1.5 94/04/08 02:57:29 erik Exp $ */
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

#ifdef X_NOT_STDC_ENV
extern char *getenv();
#endif

static Bool	_XkbIgnoreExtension = False;

void
XkbNoteMapChanges(old,new,wanted)
    XkbMapChangesRec	*old;
    XkbMapNotifyEvent	*new;
    unsigned int	 wanted;
{
    int first,oldLast,newLast;
    wanted&= new->changed;

    if (wanted&XkbKeyTypesMask) {
	if (old->changed&XkbKeyTypesMask) {
	    first = old->first_type;
	    oldLast = old->first_type+old->num_types-1;
	    newLast = new->first_type+new->num_types-1;

	    if (new->first_type<first)
		first = new->first_type;
	    if (oldLast>newLast)
		newLast= oldLast;
	    old->first_type = first;
	    old->num_types = newLast-first+1;
	}
	else {
	    old->first_type= new->first_type;
	    old->num_types = new->num_types;
	}
    }
    if (wanted&XkbKeySymsMask) {
	if (old->changed&XkbKeySymsMask) {
	    first = old->first_key_sym;
	    oldLast = old->first_key_sym+old->num_key_syms-1;
	    newLast = new->first_key_sym+new->num_key_syms-1;

	    if (new->first_key_sym<first)
		first = new->first_key_sym;
	    if (oldLast>newLast)
		newLast= oldLast;
	    old->first_key_sym = first;
	    old->num_key_syms = newLast-first+1;
	}
	else {
	    old->first_key_sym = new->first_key_sym;
	    old->num_key_syms = new->num_key_syms;
	}
    }
    if (wanted&XkbKeyActionsMask) {
	if (old->changed&XkbKeyActionsMask) {
	    first = old->first_key_act;
	    oldLast = old->first_key_act+old->num_key_acts-1;
	    newLast = new->first_key_act+new->num_key_acts-1;

	    if (new->first_key_act<first)
		first = new->first_key_act;
	    if (oldLast>newLast)
		newLast= oldLast;
	    old->first_key_act = first;
	    old->num_key_acts = newLast-first+1;
	}
	else {
	    old->first_key_act = new->first_key_act;
	    old->num_key_acts = new->num_key_acts;
	}
    }
    if (wanted&XkbKeyBehaviorsMask) {
	if (old->changed&XkbKeyBehaviorsMask) {
	    first = old->first_key_behavior;
	    oldLast = old->first_key_behavior+old->num_key_behaviors-1;
	    newLast = new->first_key_behavior+new->num_key_behaviors-1;

	    if (new->first_key_behavior<first)
		first = new->first_key_behavior;
	    if (oldLast>newLast)
		newLast= oldLast;
	    old->first_key_behavior = first;
	    old->num_key_behaviors = newLast-first+1;
	}
	else {
	    old->first_key_behavior = new->first_key_behavior;
	    old->num_key_behaviors = new->num_key_behaviors;
	}
    }
    if (wanted&XkbVirtualModsMask) {
	old->vmods|= new->vmods;
    }
    if (wanted&XkbExplicitComponentsMask) {
	if (old->changed&XkbExplicitComponentsMask) {
	    first = old->first_key_explicit;
	    oldLast = old->first_key_explicit+old->num_key_explicit-1;
	    newLast = new->first_key_explicit+new->num_key_explicit-1;

	    if (new->first_key_explicit<first)
		first = new->first_key_explicit;
	    if (oldLast>newLast)
		newLast= oldLast;
	    old->first_key_explicit = first;
	    old->num_key_explicit = newLast-first+1;
	}
	else {
	    old->first_key_explicit = new->first_key_explicit;
	    old->num_key_explicit = new->num_key_explicit;
	}
    }
    old->changed|= wanted;
    return;
}

void
XkbNoteCoreMapChanges(old,new,wanted)
    XkbMapChangesRec	*old;
    XMappingEvent	*new;
    unsigned int	 wanted;
{
    int first,oldLast,newLast;


    if ((new->request==MappingKeyboard)&&(wanted&XkbKeySymsMask)) {
	if (old->changed&XkbKeySymsMask) {
	    first = old->first_key_sym;
	    oldLast = old->first_key_sym+old->num_key_syms-1;
	    newLast = new->first_keycode+new->count-1;

	    if (new->first_keycode<first)
		first = new->first_keycode;
	    if (oldLast>newLast)
		newLast= oldLast;
	    old->first_key_sym = first;
	    old->num_key_syms = newLast-first+1;
	}
	else {
	    old->changed|= XkbKeySymsMask;
	    old->first_key_sym = new->first_keycode;
	    old->num_key_syms = new->count;
	}
    }
    return;
}

static Bool
wire_to_event(dpy,re,event)
    Display *dpy;
    XEvent *re;
    xEvent *event;
{
    xkbEvent *xkbevent= (xkbEvent *)event;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    xkbi = dpy->xkb_info;
    if (((event->u.u.type&0x7f)-xkbi->codes->first_event)!=XkbEventCode)
	return False;

    switch (xkbevent->u.any.xkbType&0x7f) {
	case XkbStateNotify:
	    {
		xkbStateNotify *sn = (xkbStateNotify *)event;
		if ( xkbi->selected_events&XkbStateNotifyMask ) {
		    XkbStateNotifyEvent *sev=(XkbStateNotifyEvent *)re;
		    sev->type = XkbEventCode+xkbi->codes->first_event;
		    sev->xkb_type = XkbStateNotify;
		    sev->serial = _XSetLastRequestRead(dpy,
					(xGenericReply *)event);
		    sev->send_event = ((event->u.u.type & 0x80) != 0);
		    sev->display = dpy;
		    sev->time = sn->time; 
		    sev->device = sn->deviceID;
		    sev->keycode = sn->keycode;
		    sev->event_type = sn->eventType;
		    sev->req_major = sn->requestMajor;
		    sev->req_minor = sn->requestMinor;
		    sev->changed = sn->changed;
		    sev->group = sn->group;
		    sev->base_group = sn->baseGroup;
		    sev->latched_group = sn->latchedGroup;
		    sev->locked_group = sn->lockedGroup;
		    sev->mods = sn->mods;
		    sev->base_mods = sn->baseMods;
		    sev->latched_mods = sn->latchedMods;
		    sev->locked_mods = sn->lockedMods;
		    sev->compat_state = sn->compatState;
		    return True;
		}
	    }
	    break;
	case XkbMapNotify:
	    {
		xkbMapNotify *mn = (xkbMapNotify *)event;
		if (xkbi->selected_events&XkbMapNotifyMask) {
		    XkbMapNotifyEvent *mev;
		    mev =(XkbMapNotifyEvent *)re;
		    mev->type = XkbEventCode+xkbi->codes->first_event;
		    mev->xkb_type = XkbMapNotify;
		    mev->serial = _XSetLastRequestRead(dpy,
						(xGenericReply *)event);
		    mev->send_event = ((event->u.u.type&0x80)!=0);
		    mev->display = dpy;
		    mev->time = mn->time;
		    mev->device = mn->deviceID;
		    mev->changed =  mn->changed;
		    mev->first_type = mn->firstType;
		    mev->num_types = mn->nTypes;
		    mev->first_key_sym = mn->firstKeySym;
		    mev->num_key_syms = mn->nKeySyms;
		    mev->first_key_act = mn->firstKeyAction;
		    mev->num_key_acts = mn->nKeyActions;
		    mev->first_key_behavior = mn->firstKeyBehavior;
		    mev->num_key_behaviors = mn->nKeyBehaviors;
		    mev->vmods = mn->virtualMods;
		    mev->first_key_explicit = mn->firstKeyExplicit;
		    mev->num_key_explicit = mn->nKeyExplicit;
		    XkbNoteMapChanges(&xkbi->changes,mev,XKB_XLIB_MAP_MASK);
		    if (xkbi->changes.changed)
			xkbi->flags|= XkbMapPending;
		    return True;
		}
		else if (mn->nKeySyms>0) {
		    register XMappingEvent *ev = (XMappingEvent *)re;
		    ev->type = MappingNotify;
		    ev->serial = _XSetLastRequestRead(dpy,
						(xGenericReply *)event);
		    ev->send_event = ((event->u.u.type&0x80)!=0);
		    ev->display = dpy;
		    ev->window = 0;
		    ev->first_keycode = mn->firstKeySym;
		    ev->request = MappingKeyboard;
		    ev->count = mn->nKeySyms;
		    XkbNoteCoreMapChanges(&xkbi->changes,ev,XKB_XLIB_MAP_MASK);
		    if (xkbi->changes.changed)
			xkbi->flags|= XkbMapPending;
		    return True;
		}
	    }
	    break;
	case XkbControlsNotify:
	    {
		if (xkbi->selected_events&XkbControlsNotifyMask) {
		    xkbControlsNotify *cn =(xkbControlsNotify *)event;
		    XkbControlsNotifyEvent *cev;
		    cev =(XkbControlsNotifyEvent *)re;
		    cev->type = XkbEventCode+xkbi->codes->first_event;
		    cev->xkb_type = XkbControlsNotify;
		    cev->serial = _XSetLastRequestRead(dpy,
						(xGenericReply *)event);
		    cev->send_event = ((event->u.u.type&0x80)!=0);
		    cev->display = dpy;
		    cev->time = cn->time;
		    cev->device = cn->deviceID;
		    cev->changed_ctrls =  cn->changedControls;
		    cev->enabled_ctrls =  cn->enabledControls;
		    cev->enabled_ctrl_changes = cn->enabledControlChanges;
		    cev->keycode = cn->keycode;
		    cev->event_type = cn->eventType;
		    cev->req_major = cn->requestMajor;
		    cev->req_minor = cn->requestMinor;
		    return True;
		}
	    }
	    break;
	case XkbIndicatorMapNotify:
	    {
		if (xkbi->selected_events&XkbIndicatorMapNotifyMask) {
		    xkbIndicatorNotify *in =(xkbIndicatorNotify *)event;
		    XkbIndicatorNotifyEvent *iev;
		    iev =(XkbIndicatorNotifyEvent *)re;
		    iev->type = XkbEventCode+xkbi->codes->first_event;
		    iev->xkb_type = XkbIndicatorMapNotify;
		    iev->serial = _XSetLastRequestRead(dpy,
						(xGenericReply *)event);
		    iev->send_event = ((event->u.u.type&0x80)!=0);
		    iev->display = dpy;
		    iev->time = in->time;
		    iev->device = in->deviceID;
		    iev->state_changed =  in->stateChanged;
		    iev->state=  in->state;
		    iev->map_changed =  in->mapChanged;
		    return True;
		}
	    }
	    break;
	case XkbIndicatorStateNotify:
	    {
		if (xkbi->selected_events&XkbIndicatorStateNotifyMask) {
		    xkbIndicatorNotify *in =(xkbIndicatorNotify *)event;
		    XkbIndicatorNotifyEvent *iev;
		    iev =(XkbIndicatorNotifyEvent *)re;
		    iev->type = XkbEventCode+xkbi->codes->first_event;
		    iev->xkb_type = XkbIndicatorStateNotify;
		    iev->serial = _XSetLastRequestRead(dpy,
						(xGenericReply *)event);
		    iev->send_event = ((event->u.u.type&0x80)!=0);
		    iev->display = dpy;
		    iev->time = in->time;
		    iev->device = in->deviceID;
		    iev->state_changed =  in->stateChanged;
		    iev->state=  in->state;
		    iev->state_changed =  in->mapChanged;
		    return True;
		}
	    }
	    break;
	case XkbBellNotify:
	    {
		if (xkbi->selected_events&XkbBellNotifyMask) {
		    xkbBellNotify *bn =(xkbBellNotify *)event;
		    XkbBellNotifyEvent *bev;
		    bev =(XkbBellNotifyEvent *)re;
		    bev->type = XkbEventCode+xkbi->codes->first_event;
		    bev->xkb_type = XkbBellNotify;
		    bev->serial = _XSetLastRequestRead(dpy,
						(xGenericReply *)event);
		    bev->send_event = ((event->u.u.type&0x80)!=0);
		    bev->display = dpy;
		    bev->time = bn->time;
		    bev->device = bn->deviceID;
		    bev->percent = bn->percent;
		    bev->pitch = bn->percent;
		    bev->duration = bn->duration;
		    bev->bell_class = bn->bellClass;
		    bev->bell_id = bn->bellID;
		    bev->name = bn->name;
		    bev->window = bn->window;
		    return True;
		}
	    }
	    break;
	case XkbSlowKeyNotify:
	    {
		if (xkbi->selected_events&XkbSlowKeyNotifyMask) {
		    xkbSlowKeyNotify *skn =(xkbSlowKeyNotify *)event;
		    XkbSlowKeyNotifyEvent *skev;
		    skev =(XkbSlowKeyNotifyEvent *)re;
		    skev->type = XkbEventCode+xkbi->codes->first_event;
		    skev->xkb_type = XkbSlowKeyNotify;
		    skev->serial = _XSetLastRequestRead(dpy,
						(xGenericReply *)event);
		    skev->send_event = ((event->u.u.type&0x80)!=0);
		    skev->display = dpy;
		    skev->time = skn->time;
		    skev->device = skn->deviceID;
		    skev->slow_key_state = skn->slowKeyState;
		    skev->keycode = skn->keycode;
		    skev->delay = skn->delay;
		    return True;
		}
	    }
	    break;
	case XkbNamesNotify:
	    {
		if (xkbi->selected_events&XkbNamesNotifyMask) {
		    xkbNamesNotify *nn =(xkbNamesNotify *)event;
		    XkbNamesNotifyEvent *nev;
		    nev =(XkbNamesNotifyEvent *)re;
		    nev->type = XkbEventCode+xkbi->codes->first_event;
		    nev->xkb_type = XkbNamesNotify;
		    nev->serial = _XSetLastRequestRead(dpy,
						(xGenericReply *)event);
		    nev->send_event = ((event->u.u.type&0x80)!=0);
		    nev->display = dpy;
		    nev->time = nn->time;
		    nev->device = nn->deviceID;
		    nev->changed = nn->changed;
		    nev->first_type = nn->firstType;
		    nev->num_types = nn->nTypes;
		    nev->first_lvl = nn->firstLevelName;
		    nev->num_lvls = nn->nLevelNames;
		    nev->first_radio_group = nn->firstRadioGroup;
		    nev->num_radio_groups = nn->nRadioGroups;
		    nev->num_char_sets = nn->nCharSets;
		    nev->changed_mods = nn->changedMods;
		    nev->changed_vmods = nn->changedVirtualMods;
		    nev->changed_indicators = nn->changedIndicators;
		    return True;
		}
	    }
	    break;
	case XkbCompatMapNotify:
	    {
		if (xkbi->selected_events&XkbCompatMapNotifyMask) {
		    xkbCompatMapNotify *cmn =(xkbCompatMapNotify *)event;
		    XkbCompatMapNotifyEvent *cmev;
		    cmev =(XkbCompatMapNotifyEvent *)re;
		    cmev->type = XkbEventCode+xkbi->codes->first_event;
		    cmev->xkb_type = XkbCompatMapNotify;
		    cmev->serial = _XSetLastRequestRead(dpy,
						(xGenericReply *)event);
		    cmev->send_event = ((event->u.u.type&0x80)!=0);
		    cmev->display = dpy;
		    cmev->time = cmn->time;
		    cmev->device = cmn->deviceID;
		    cmev->changed_mods = cmn->changedMods;
		    cmev->changed_vmods = cmn->changedVirtualMods;
		    cmev->first_si = cmn->firstSI;
		    cmev->num_si = cmn->nSI;
		    cmev->num_total_si = cmn->nTotalSI;
		    return True;
		}
	    }
	    break;
	case XkbAlternateSymsNotify:
	    {
		if (xkbi->selected_events&XkbAlternateSymsNotifyMask) {
		    xkbAlternateSymsNotify *asn=(xkbAlternateSymsNotify *)event;
		    XkbAlternateSymsNotifyEvent *asev;
		    asev =(XkbAlternateSymsNotifyEvent *)re;
		    asev->type = XkbEventCode+xkbi->codes->first_event;
		    asev->xkb_type = XkbAlternateSymsNotify;
		    asev->serial = _XSetLastRequestRead(dpy,
						(xGenericReply *)event);
		    asev->send_event = ((event->u.u.type&0x80)!=0);
		    asev->display = dpy;
		    asev->time = asn->time;
		    asev->device = asn->deviceID;
		    asev->alt_syms_id = asn->altSymsID;
		    asev->first_key = asn->firstKey;
		    asev->num_keys = asn->nKeys;
		    return True;
		}
	    }
	    break;
	case XkbActionMessage:
	    {
		if (xkbi->selected_events&XkbActionMessageMask) {
		    xkbActionMessage *am= (xkbActionMessage *)event;
		    XkbActionMessageEvent *amev;
		    amev= (XkbActionMessageEvent *)am;
		    amev->type = XkbEventCode+xkbi->codes->first_event;
		    amev->xkb_type = XkbActionMessage;
		    amev->serial = _XSetLastRequestRead(dpy,
						(xGenericReply *)event);
		    amev->send_event = ((event->u.u.type&0x80)!=0);
		    amev->display = dpy;
		    amev->time = am->time;
		    amev->device = am->deviceID;
		    amev->keycode = am->keycode;
		    amev->press = am->press;
		    amev->key_event_follows = am->keyEventFollows;
		    memcpy(amev->message,am->message,XkbActionMessageLength);
		}
	    }
	    break;
	default:
	    fprintf(stderr,"Got unknown Xkb event (%d, base=%d)\n",re->type,
						xkbi->codes->first_event);
	    break;
    }
    return False;
}

Bool
XkbIgnoreExtension(ignore)
    Bool ignore;
{
    _XkbIgnoreExtension = ignore;
    return True;
}

static void
_XkbFreeInfo(dpy)
    Display *dpy;
{
    XkbInfoPtr xkbi = dpy->xkb_info;
    if (xkbi) {
	if (xkbi->desc)
	    Xfree(xkbi->desc);
	if (xkbi->modmap)
	    Xfree(xkbi->modmap);
	Xfree(xkbi);
      }
}

Bool
XkbUseExtension(dpy)
    Display *dpy;
{
    xkbUseExtensionReply rep;
    register xkbUseExtensionReq *req;
    XExtCodes		*codes;
    int	ev_base;
    XkbInfoPtr xkbi;
#ifdef DEBUG
    static int debugMsg;
#endif
    static int been_here= 0;

    if ( dpy->xkb_info )
	return True;
    if (!been_here) {
#ifdef DEBUG
	debugMsg= (getenv("XKB_DEBUG")!=NULL);
#endif
	been_here= 1;
    }
    if ((dpy->flags&XlibDisplayNoXkb) || dpy->keysyms ||
	_XkbIgnoreExtension || getenv("XKB_DISABLE")) {
	LockDisplay(dpy);
	dpy->flags |= XlibDisplayNoXkb;
	UnlockDisplay(dpy);
#ifdef DEBUG
	if (debugMsg)
	    fprintf(stderr,"XKB extension disabled or missing\n");
#endif
	return False;
    }

    xkbi = (XkbInfoPtr)Xcalloc(1, sizeof(XkbInfoRec));
    if ( !xkbi )
	return False;

    if ( (codes=XInitExtension(dpy,XkbName))==NULL ) {
	LockDisplay(dpy);
	dpy->flags |= XlibDisplayNoXkb;
	UnlockDisplay(dpy);
	Xfree(xkbi);
#ifdef DEBUG
	if (debugMsg)
	    fprintf(stderr,"XKB extension not present\n");
#endif
	return False;
    }
    xkbi->codes = codes;
    LockDisplay(dpy);

    GetReq(kbUseExtension, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbUseExtension;
    req->wantedMajor = XkbMajorVersion;
    req->wantedMinor = XkbMinorVersion;
    if (!_XReply(dpy, (xReply *)&rep, 0, xFalse) || !rep.supported) {
#ifdef DEBUG
	if (debugMsg)
	    fprintf(stderr,
		"XKB version mismatch (want %d.%02d, got %d.%02d)\n", 
		XkbMajorVersion,XkbMinorVersion,
		rep.serverMajor, rep.serverMinor);
#endif
	/* could theoretically try for an older version here */
	dpy->flags |= XlibDisplayNoXkb;
	UnlockDisplay(dpy);
	SyncHandle();
	Xfree(xkbi);
	return False;
    }
    xkbi->srv_major= rep.serverMajor;
    xkbi->srv_minor= rep.serverMinor;
#ifdef DEBUG
    if (debugMsg)
	fprintf(stderr,"XKB (version %d.%02d/%d.%02d) OK!\n",
				XkbMajorVersion,XkbMinorVersion,
				rep.serverMajor,rep.serverMinor);
#endif
    dpy->xkb_info = xkbi;
    dpy->free_funcs->xkb = _XkbFreeInfo;
    ev_base = codes->first_event;
    UnlockDisplay(dpy);
    XESetWireToEvent(dpy,ev_base+XkbEventCode,wire_to_event);
    SyncHandle();
    return True;
}
