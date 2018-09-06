/* $XConsortium: XKB.c,v 1.13 94/04/02 15:53:28 rws Exp $ */
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


Bool 
XkbQueryExtension(dpy,opcodeReturn,eventBaseReturn,errorBaseReturn,majorReturn,minorReturn)
    Display *dpy;
    int *opcodeReturn;
    int *eventBaseReturn;
    int *errorBaseReturn;
    int *majorReturn;
    int *minorReturn;
{
    if (!XkbUseExtension(dpy))
	return False;
    if (opcodeReturn)
	*opcodeReturn = dpy->xkb_info->codes->major_opcode;
    if (eventBaseReturn)
	*eventBaseReturn = dpy->xkb_info->codes->first_event;
    if (errorBaseReturn)
	*errorBaseReturn = dpy->xkb_info->codes->first_error;
    if (majorReturn)
	*majorReturn = dpy->xkb_info->srv_major;
    if (minorReturn)
	*minorReturn = dpy->xkb_info->srv_minor;
    return True;
}

Status XkbLibraryVersion(libMajorRtrn,libMinorRtrn)
    int *libMajorRtrn;
    int *libMinorRtrn;
{
int supported;

    if (*libMajorRtrn != XkbMajorVersion)
	supported = False;
#if XkbMajorVersion==0
    else if (*libMinorRtrn != XkbMinorVersion)
	supported = False;
#endif
    else supported = True;

    *libMajorRtrn = XkbMajorVersion;
    *libMinorRtrn = XkbMinorVersion;
    return supported;
}

Bool
XkbDeviceBell(dpy,window,deviceID,bellClass,bellID,percent,name)
    Display *dpy;
    Window window;
    int deviceID;
    int bellClass;
    int bellID;
    int percent;
    Atom name;
{
    register xkbBellReq *req;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbBell,req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbBell;
    req->deviceSpec = deviceID;
    req->window = window;
    req->bellClass = bellClass;
    req->bellID = bellID;
    req->percent = percent;
    req->override = False;
    req->name = name;
    UnlockDisplay(dpy);
    SyncHandle();
    return True;
}

Bool
XkbForceDeviceBell(dpy,deviceID,bellClass,bellID,percent)
    Display *dpy;
    int	deviceID;
    int	bellClass;
    int	bellID;
    int	percent;
{
    register xkbBellReq *req;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbBell,req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbBell;
    req->deviceSpec = deviceID;
    req->window = None;
    req->bellClass = bellClass;
    req->bellID = bellID;
    req->percent = percent;
    req->override = True;
    req->name = None;
    UnlockDisplay(dpy);
    SyncHandle();
    return True;
}

Bool
XkbBell(dpy,window,percent,name)
    Display *dpy;
    Window   window;
    int percent;
    Atom name;
{
    /* class 0 = KbdFeedbackClass (X Input Extension) */
    return XkbDeviceBell(dpy,window,XkbUseCoreKbd,0,0,percent,name);
}

Bool
XkbForceBell(dpy,percent)
    Display *dpy;
    int      percent;
{
    return XkbForceDeviceBell(dpy,XkbUseCoreKbd,0,0,percent);
}

Bool
XkbSelectEvents(dpy,deviceSpec,affect,selectAll)
    Display *dpy;
    unsigned int deviceSpec;
    unsigned long int affect;
    unsigned long int selectAll;
{
    register xkbSelectEventsReq *req;
    union {
	BOOL	*b;
	CARD8	*c8;
	CARD16	*c16;
	CARD32	*c32;
    } to,start;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    xkbi->selected_events&= ~affect;
    xkbi->selected_events|= (affect&selectAll);
    GetReq(kbSelectEvents, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbSelectEvents;
    req->deviceSpec = deviceSpec;
    req->affectWhich = affect;
    req->clear = affect&(~selectAll);
    req->selectAll = affect&selectAll;
    if (affect&XkbMapNotifyMask) {
	req->affectMap= XkbAllMapComponentsMask;
	if (selectAll&XkbMapNotifyMask)
	     req->map= ~0;
	else req->map= 0;
    }
    UnlockDisplay(dpy);
    SyncHandle();
    return True;
}

Bool
XkbSelectEventDetails(dpy,deviceSpec,eventType,affect,details)
    Display *dpy;
    unsigned deviceSpec;
    unsigned eventType;
    unsigned long int affect;
    unsigned long int details;
{
    register xkbSelectEventsReq *req;
    XkbInfoPtr xkbi;
    int	     size;
    char     *out;
    union {
	CARD8	*c8;
	CARD16	*c16;
	CARD32	*c32;
    } u;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbSelectEvents, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbSelectEvents;
    req->deviceSpec = deviceSpec;
    req->clear= req->selectAll= 0;
    if (eventType==XkbMapNotify) {
	req->affectWhich = 0;
	req->selectAll = 0;
	req->clear = 0;
	req->affectMap = affect;
	req->map = details;
	req->affectWhich = XkbMapNotifyMask;
    }
    else {
	req->affectMap = req->map = 0;
	req->affectWhich= (1<<eventType);
	switch (eventType) {
	    case XkbStateNotify:
	    case XkbNamesNotify:
	    case XkbAlternateSymsNotify:
		size= 2;
		req->length+= 1;
		break;
	    case XkbControlsNotify:
	    case XkbIndicatorStateNotify:
	    case XkbIndicatorMapNotify:
		size= 4;
		req->length+= 2;
		break;
	    case XkbBellNotify:
	    case XkbActionMessage:
		if (affect)	affect= 1;  /* force "true" boolean values */
		if (details)	details= 1;
	    case XkbSlowKeyNotify:
	    case XkbCompatMapNotify:
		size= 1;
		req->length+= 1;
		break;
	}
	BufAlloc(char *,out,(((size*2)+(unsigned)3)/4)*4);
	u.c8= (CARD8 *)out;
	if (size==2) {
	    u.c16[0]= affect;
	    u.c16[1]= details;
	}
	else if (size==4) {
	    u.c32[0]= affect;
	    u.c32[1]= details;
	}
	else {
	    u.c8[0]= affect;
	    u.c8[1]= details;
	}
    }
    if (affect&details)	xkbi->selected_events|= (1<<eventType);
    else		xkbi->selected_events&= ~(1<<eventType);
    UnlockDisplay(dpy);
    SyncHandle();
    return True;
}

Status
XkbLockModifiers(dpy,deviceSpec,affect,values)
    Display *dpy;
    unsigned int deviceSpec;
    unsigned int affect;
    unsigned int values;
{
    register xkbLatchLockStateReq *req;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbLatchLockState, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbLatchLockState;
    req->deviceSpec = deviceSpec;
    req->affectModLocks= affect;
    req->modLocks = values;
    req->lockGroup = False;
    req->groupLock = 0;

    req->affectModLatches = req->modLatches = 0;
    req->latchGroup = False;
    req->groupLatch = 0;
    UnlockDisplay(dpy);
    SyncHandle();
    return 1;
}

Status
XkbLatchModifiers(dpy,deviceSpec,affect,values)
    Display *dpy;
    unsigned int deviceSpec;
    unsigned int affect;
    unsigned int values;
{
    register xkbLatchLockStateReq *req;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbLatchLockState, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbLatchLockState;
    req->deviceSpec = deviceSpec;

    req->affectModLatches= affect;
    req->modLatches = values;
    req->latchGroup = False;
    req->groupLatch = 0;

    req->affectModLocks = req->modLocks = 0;
    req->lockGroup = False;
    req->groupLock = 0;

    UnlockDisplay(dpy);
    SyncHandle();
    return 1;
}

Status
XkbVirtualModsToReal(xkb,virtual_mask,mask_rtrn)
    XkbDescPtr	xkb;
    unsigned	virtual_mask;
    unsigned *	mask_rtrn;
{
register int i,bit;
register unsigned mask;

    if (xkb==NULL)
	return False;
    if (virtual_mask==0) {
	*mask_rtrn= 0;
	return True;
    }
    if (xkb->server==NULL)
	return False;
    for (i=mask=0,bit=1;i<XkbNumVirtualMods;i++,bit<<=1) {
	if (virtual_mask&bit) {
	    if (xkb->server->vmods[i]!=XkbNoModifier)
		mask|= (1<<xkb->server->vmods[i]);
	}
    }
    *mask_rtrn= mask;
    return True;
}

static  XkbKTMapEntryRec map2Level[1]= { 
	{ True, ShiftMask, 0, ShiftMask, 0 }
};
#define	NL_VMOD_MASK	0
static  XkbKTMapEntryRec mapKeypad[2]= { 
	{ True,	ShiftMask, 0, ShiftMask,            0 },
	{ False,        0, 0,         0, NL_VMOD_MASK }
};

static	XkbKeyTypeRec	canonicalTypes[XkbNumRequiredTypes] = {
	{ 0,		0,		0, 
	  1,
	  XkbNoFreeKTMap|XkbNoFreeKTStruct, 
	  0,
	  NULL,		NULL,
	  None,		NULL
	},
	{ ShiftMask, 	ShiftMask, 	0, 
	  2,
	  XkbNoFreeKTMap|XkbNoFreeKTStruct,
	  1,
	  map2Level,	NULL,
	  None,		NULL
	},
	{ ShiftMask,	ShiftMask,	NL_VMOD_MASK,
	  2,
	  XkbNoFreeKTMap|XkbNoFreeKTStruct,
	  2,
	  mapKeypad,	NULL,
	  None,		NULL
	}
};

Status
XkbInitCanonicalKeyTypes(xkb,which,keypadVMod)
    XkbDescPtr		xkb;
    unsigned		which;
    int			keypadVMod;
{
XkbClientMapPtr	map;

    if ((!xkb)||(!XkbAllocClientMap(xkb,XkbKeyTypesMask,XkbNumRequiredTypes)))
	return False;
    map= xkb->map;
    if ((which&XkbAllRequiredTypes)==0)
	return True;
    if (which&XkbOneLevelMask) {
	int	shouldFree; 
	shouldFree= (!(map->types[XkbOneLevelIndex].free&XkbNoFreeKTStruct));
	map->types[XkbOneLevelIndex]= canonicalTypes[XkbOneLevelIndex];
	if (shouldFree)
	    map->types[XkbOneLevelIndex].free&= ~XkbNoFreeKTStruct;
    }
    if (which&XkbTwoLevelMask) {
	map->types[XkbTwoLevelIndex]= canonicalTypes[XkbTwoLevelIndex];
    }
    if (which&XkbKeypadMask) {
	XkbKeyTypePtr type= &map->types[XkbKeypadIndex];

	map->types[XkbKeypadIndex]= canonicalTypes[XkbKeypadIndex];
	if ((keypadVMod>=0)&&(keypadVMod<XkbNumVirtualMods)) {
	    type->vmods= (1<<keypadVMod);
	    type->map= (XkbKTMapEntryPtr)Xcalloc(2,sizeof(XkbKTMapEntryPtr));
	    if (type->map==NULL) {
		type->map_count= 0;
		return False;
	    }
	    type->map[0].active= True;
	    type->map[0].mask= ShiftMask;
	    type->map[0].vmods= 0;
	    type->map[0].real_mods= ShiftMask;
	    type->map[0].level= 1;
	    type->map[1].active= False;
	    type->map[1].mask= 0;
	    type->map[1].vmods= (1<<keypadVMod);
	    type->map[1].real_mods= 0;
	    type->map[1].level= 1;
	    type->free&= ~XkbNoFreeKTMap;
	}
    }
    return True;
}

Status
XkbSetDebuggingFlags(dpy,mask,flags,msg,rtrnFlags,disableLocks)
    Display *dpy;
    unsigned int mask;
    unsigned int flags;
    char *msg;
    unsigned int *rtrnFlags;
    Bool *disableLocks;
{
    register xkbSetDebuggingFlagsReq *req;
    xkbSetDebuggingFlagsReply rep;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbSetDebuggingFlags, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbSetDebuggingFlags;
    req->flags = flags;
    req->mask = mask;
    if (disableLocks)	req->disableLocks = *disableLocks;
    else 		req->disableLocks = XkbLeaveLocks;

    if (msg) {
	char *out;
	req->msgLength= strlen(msg)+1;
	req->length+= (req->msgLength+(unsigned)3)>>2;
	BufAlloc(char *,out,((req->msgLength+(unsigned)3)/4)*4);
	memcpy(out,msg,req->msgLength);
    }
    else req->msgLength= 0;
    if (!_XReply(dpy, (xReply *)&rep, 0, xFalse)) {
	UnlockDisplay(dpy);
	SyncHandle();
	return False;
    }
    if (rtrnFlags)
	*rtrnFlags= rep.currentFlags;
    if (disableLocks)
	*disableLocks= rep.disableLocks;
    UnlockDisplay(dpy);
    SyncHandle();
    return 1;
}

/***====================================================================***/

KeySym *
XkbEnlargeKeySyms(xkb,key,needed)
    XkbDescRec *xkb;
    int key;
    int needed;
{
register int i,nSyms,nKeySyms;
unsigned nOldSyms;
KeySym	*newSyms;

    if (needed==0) {
	xkb->map->key_sym_map[key].offset= 0;
	return xkb->map->syms;
    }
    nOldSyms= XkbKeyNumSyms(xkb,key);
    if (nOldSyms>=(unsigned)needed) {
	return XkbKeySymsPtr(xkb,key);
    }
    if (xkb->map->size_syms-xkb->map->num_syms>=(unsigned)needed) {
	int nOldSyms= XkbKeyNumSyms(xkb,key);

	if (nOldSyms>0) {
	    memcpy(&xkb->map->syms[xkb->map->num_syms],XkbKeySymsPtr(xkb,key),
						nOldSyms*sizeof(KeySym));
	}
	if ((needed-nOldSyms)>0) {
	    bzero(&xkb->map->syms[xkb->map->num_syms+XkbKeyNumSyms(xkb,key)],
					(needed-nOldSyms)*sizeof(KeySym));
	}
	xkb->map->key_sym_map[key].offset = xkb->map->num_syms;
	xkb->map->num_syms+= needed;
	return &xkb->map->syms[xkb->map->key_sym_map[key].offset];
    }
    xkb->map->size_syms+= 32;
    newSyms = (KeySym *)Xmalloc(xkb->map->size_syms*sizeof(KeySym));
    if (newSyms==NULL)
	return NULL;
    newSyms[0]= NoSymbol;
    nSyms = 1;
    for (i=xkb->min_key_code;i<=(int)xkb->max_key_code;i++) {
	nKeySyms= XkbKeyNumSyms(xkb,i);
	if (nKeySyms!=0)
	   memcpy(&newSyms[nSyms],XkbKeySymsPtr(xkb,i),nKeySyms*sizeof(KeySym));
	xkb->map->key_sym_map[i].offset = nSyms;
	if (i!=key)
	    nSyms+= nKeySyms;
	else {
	    int nExtra;
	    nExtra= needed-nKeySyms;
	    if (nExtra>0)
		bzero(&newSyms[nSyms+nKeySyms],nExtra*sizeof(KeySym));
	    nSyms+= needed;
	}
    }
    free(xkb->map->syms);
    xkb->map->syms = newSyms;
    xkb->map->num_syms = nSyms;
    return &xkb->map->syms[xkb->map->key_sym_map[key].offset];
}

XkbAction *
XkbEnlargeKeyActions(xkb,key,needed)
    XkbDescRec *xkb;
    int key;
    int needed;
{
register int i,nActs;
XkbAction *newActs;

    if ((xkb->server->key_acts[key]!=0)&&
				(XkbKeyNumSyms(xkb,key)>=(unsigned)needed)) {
	return XkbKeyActionsPtr(xkb,key);
    }
    if (xkb->server->size_acts-xkb->server->num_acts>=(unsigned)needed) {
	xkb->server->key_acts[key]= xkb->server->num_acts;
	xkb->server->num_acts+= needed;
	return &xkb->server->acts[xkb->server->key_acts[key]];
    }
    xkb->server->size_acts+= 8;
    newActs = (XkbAction *)Xmalloc(xkb->server->size_acts*sizeof(XkbAction));
    if (newActs==NULL)
	return NULL;
    newActs[0].type = XkbSA_NoAction;
    nActs = 1;
    for (i=xkb->min_key_code;i<=(int)xkb->max_key_code;i++) {
	int nKeyActs;

	nKeyActs= XkbKeyNumActions(xkb,i);
	if (xkb->server->key_acts[i]!=0) {
	    memcpy(&newActs[nActs],XkbKeyActionsPtr(xkb,i),
						nKeyActs*sizeof(XkbAction));
	}
	xkb->server->key_acts[i]= nActs;
	if (i!=key)
	    nActs+= nKeyActs;
	else {
	    int nExtra;
	    nExtra= needed-nKeyActs;
	    if (nExtra>0)
		bzero(&newActs[nActs+nKeyActs],nExtra*sizeof(XkbAction));
	    nActs+= needed;
	}
    }
    free(xkb->server->acts);
    xkb->server->acts = newActs;
    xkb->server->num_acts= nActs;
    return &xkb->server->acts[xkb->server->key_acts[key]];
}

Status
XkbChangeTypeOfKey(xkb,key,newType,pChanges)
    XkbDescRec		*xkb;
    unsigned	 	 key;
    unsigned	 	 newType;
    XkbMapChangesRec	*pChanges;
{
XkbKeyTypeRec	*pOldType,*pNewType;

    if ((!xkb) || (key<xkb->min_key_code) || (key>xkb->max_key_code) ||
	(!xkb->map)||(!xkb->map->types)||(newType>=xkb->map->num_types)) {
	return 0;
    }

    pOldType = XkbKeyKeyType(xkb,key);
    pNewType = &xkb->map->types[newType];
    if (newType==xkb->map->key_sym_map[key].kt_index) {
	return 1;
    }
    else if (pOldType->group_width==pNewType->group_width) {
	xkb->map->key_sym_map[key].kt_index= newType;
    }
    else if (pOldType->group_width>pNewType->group_width) {
	int g,l,nGroups;
	int oldWidth,newWidth;
	KeySym	*pSyms;

	xkb->map->key_sym_map[key].kt_index= newType;
	pSyms = XkbKeySymsPtr(xkb,key);
	oldWidth = pOldType->group_width;
	newWidth = pNewType->group_width;
	nGroups= XkbKeyNumGroups(xkb,key);
	for (g=1;g<nGroups;g++) {
	    for (l=0;l<newWidth;l++) {
		pSyms[g*newWidth+l]= pSyms[g*oldWidth+l];
	    }
	}
    }
    else {
	int g,l,nGroups;
	int oldWidth,newWidth;
	KeySym	*pSyms;

	xkb->map->key_sym_map[key].kt_index= newType;
	oldWidth = pOldType->group_width;
	newWidth = pNewType->group_width;
	nGroups= XkbKeyNumGroups(xkb,key);
	pSyms = XkbEnlargeKeySyms(xkb,key,newWidth*nGroups);
	for (g=nGroups-1;g>=0;g--) {
	    for (l=newWidth-1;l>=oldWidth;l--) {
		pSyms[g*newWidth+l]= NoSymbol;
	    }
	    for (l=oldWidth-1;l>=0;l--) {
		pSyms[g*newWidth+l]= pSyms[g*oldWidth+l];
	    }
	}
    }
    if (pChanges!=NULL) {
	if (pChanges->changed&XkbKeySymsMask) {
	    int first,last;
	    first= pChanges->first_key_sym;
	    last= pChanges->first_key_sym+pChanges->num_key_syms-1;
	    if (key<first)	first= key;
	    if (key>last)	last= key;
	    pChanges->first_key_sym = first;
	    pChanges->num_key_syms = (last-first)+1;
	}
	else {
	    pChanges->changed|= XkbKeySymsMask;
	    pChanges->first_key_sym= key;
	    pChanges->num_key_syms= 1;
	}
    }
    return 1;
}

Status
XkbChangeSymsForKey(xkb,key,count,syms,pChanges)
    XkbDescRec		*xkb;
    unsigned	 	 key;
    unsigned	 	 count;
    KeySym 		*syms;
    XkbMapChangesRec	*pChanges;
{
XkbKeyTypeRec	*pType;
KeySym *pSyms;
int nGroups,nSyms;

    if ((!xkb) || (key<xkb->min_key_code) || (key>xkb->max_key_code) ||
	(!xkb->map)||(!xkb->map->types)||(!xkb->map->key_sym_map) ||
	(count<1))
	return 0;

    pType = XkbKeyKeyType(xkb,key);
    nGroups = ((count+pType->group_width-1)/pType->group_width);
    if ((nGroups<1)||(nGroups>8))
	return 0;
    
    nSyms= nGroups*pType->group_width;
    pSyms= XkbEnlargeKeySyms(xkb,key,nSyms);
    if (!pSyms) 
	return 0;

    memcpy(pSyms,syms,count*sizeof(KeySym));
    while (count<nSyms) {
	pSyms[count++]= NoSymbol;
    }
    xkb->map->key_sym_map[key].group_info= 
		XkbSetNumGroups(xkb->map->key_sym_map[key].group_info,nGroups);

    if (pChanges!=NULL) {
	if (pChanges->changed&XkbKeySymsMask) {
	    int first,last;
	    first= pChanges->first_key_sym;
	    last= pChanges->first_key_sym+pChanges->num_key_syms-1;
	    if (key<first)	first= key;
	    if (key>last)	last= key;
	    pChanges->first_key_sym = first;
	    pChanges->num_key_syms = (last-first)+1;
	}
	else {
	    pChanges->changed|= XkbKeySymsMask;
	    pChanges->first_key_sym= key;
	    pChanges->num_key_syms= 1;
	}
    }
    return 1;
}

Bool
XkbComputeEffectiveMap(xkb,type,map_rtrn)
    XkbDescPtr		xkb;
    XkbKeyTypePtr	type;
    unsigned char *	map_rtrn;
{
register int 		i;
unsigned     		tmp;
XkbKTMapEntryPtr	entry;

    if ((!xkb)||(!type)||(!xkb->server))
	return False;

    if (type->vmods!=0) {
	if (!XkbVirtualModsToReal(xkb,type->vmods,&tmp))
	    return False;

	type->mask= tmp|type->real_mods;
	entry= type->map;
	for (i=0;i<type->map_count;i++,entry++) {
	    tmp= 0;
	    if (entry->vmods!=0) {
		if (!XkbVirtualModsToReal(xkb,entry->vmods,&tmp))
		    return False;
		if (tmp==0) {
		    entry->active= False;
		    continue;
		}
	    }
	    entry->active= True;
	    entry->mask= (entry->real_mods|tmp)&type->mask;
	}
    }
    else {
	type->mask= type->real_mods;
    }
    if (map_rtrn!=NULL) {
	bzero(map_rtrn,type->mask+1);
	for (i=0;i<type->map_count;i++) {
	    if (entry->active) {
		map_rtrn[type->map[i].mask]= type->map[i].level;
	    }
	}
    }
    return True;
}

Status
XkbGetState(dpy,deviceSpec,rtrn)
    Display *dpy;
    unsigned deviceSpec;
    XkbStateRec *rtrn;
{
    register xkbGetStateReq	*req;
    xkbGetStateReply rep;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbGetState, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbGetState;
    req->deviceSpec = deviceSpec;
    if (!_XReply(dpy, (xReply *)&rep, 0, xFalse)) {
	UnlockDisplay(dpy);
	SyncHandle();
	return False;
    }
    rtrn->mods= rep.mods;
    rtrn->base_mods= rep.baseMods;
    rtrn->latched_mods= rep.latchedMods;
    rtrn->locked_mods= rep.lockedMods;
    rtrn->group= rep.group;
    rtrn->base_group = rep.baseGroup;
    rtrn->latched_group= rep.latchedGroup;
    rtrn->locked_group = rep.lockedGroup;
    rtrn->compat_state= rep.compatState;
    UnlockDisplay(dpy);
    SyncHandle();
    return True;
}

