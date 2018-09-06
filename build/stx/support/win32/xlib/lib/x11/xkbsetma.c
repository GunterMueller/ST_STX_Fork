/* $XConsortium: XKBSetMap.c,v 1.3 94/04/02 14:34:00 erik Exp $ */
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

static int
_XkbSizeKeyTypes(xkb,firstType,nTypes)
    XkbDescRec *xkb;
    unsigned firstType;
    unsigned nTypes;
{
    XkbKeyTypeRec 	*map;
    int			i,n,len;

    len= 0;
    map= &xkb->map->types[firstType];
    for (i=0;i<nTypes;i++,map++){
	len+= SIZEOF(xkbKeyTypeWireDesc);
	len+= map->map_count*SIZEOF(xkbKTSetMapEntryWireDesc);
	if (map->preserve)
	    len+= map->map_count*SIZEOF(xkbKTPreserveWireDesc);
    }
    return len;
}

static void
_XkbWriteKeyTypes(dpy,xkb,firstType,nTypes)
    Display	*dpy;
    XkbDescRec	*xkb;
    unsigned	 firstType;
    unsigned	 nTypes;
{
    char		*buf,*start;
    XkbKeyTypeRec 	*type;
    int			i,n,sz;
    xkbKeyTypeWireDesc	*desc;

    type= &xkb->map->types[firstType];
    for (i=0;i<nTypes;i++,type++) {
	sz= SIZEOF(xkbKeyTypeWireDesc);
	sz+= type->map_count*SIZEOF(xkbKTSetMapEntryWireDesc);
	if (type->preserve)
	    sz+= type->map_count*SIZEOF(xkbKTPreserveWireDesc);
	BufAlloc(xkbKeyTypeWireDesc *,desc,sz);
	desc->mask = type->mask;
	desc->realMods = type->real_mods;
	desc->virtualMods = type->vmods;
	desc->groupWidth = type->group_width;
	desc->nMapEntries = type->map_count;
	start= buf= (char *)&desc[1];
	if (desc->nMapEntries>0) {
	    xkbKTSetMapEntryWireDesc *wire;
	    wire= (xkbKTSetMapEntryWireDesc *)buf;
	    for (n=0;n<type->map_count;n++,wire++) {
		wire->level= type->map[n].level;
		wire->realMods= type->map[n].real_mods;
		wire->virtualMods= type->map[n].vmods;
	    }
	    buf= (char *)wire;
	    if (type->preserve) {
		xkbKTPreserveWireDesc *pwire;
		pwire= (xkbKTPreserveWireDesc *)buf;
		for (n=0;n<type->map_count;n++,pwire++) {
		    pwire->realMods= type->preserve[n].real_mods;
		    pwire->virtualMods= type->preserve[n].vmods;
		}
	    }
	}
    }
    return;
}

static int
_XkbSizeKeySyms(xkb,firstKey,nKeys,nSymsRtrn)
    XkbDescRec  *xkb;
    unsigned 	 firstKey;
    unsigned	 nKeys;
    CARD16	*nSymsRtrn;
{
    XkbSymMapRec	*symMap;
    XkbKeyTypeRec 	*type;
    int			i,len;
    unsigned		nSyms;

    len= nKeys*sizeof(XkbSymMapRec);
    symMap = &xkb->map->key_sym_map[firstKey];
    for (i=nSyms=0;i<nKeys;i++,symMap++) {
	type = &xkb->map->types[symMap->kt_index];
	nSyms+= XkbNumGroups(symMap->group_info)*type->group_width;
    }
    len+= nSyms*sizeof(KeySym);
    *nSymsRtrn = nSyms;
    return len;
}

static void
_XkbWriteKeySyms(dpy,xkb,firstKeySym,nKeySyms,totalSyms)
    Display *dpy;
    XkbDescRec *xkb;
    unsigned firstKeySym;
    unsigned nKeySyms;
    unsigned totalSyms;
{
register KeySym *pSym,*outSym;
XkbSymMapRec	*symMap;
XkbKeyTypeRec	*keyType;
xkbSymMapWireDesc *desc;
register int	i;

    i= (nKeySyms*SIZEOF(xkbSymMapWireDesc))+(totalSyms*sizeof(KeySym));
    BufAlloc(xkbSymMapWireDesc *,desc,i);
    symMap = &xkb->map->key_sym_map[firstKeySym];
    for (i=0;i<nKeySyms;i++,symMap++) {
	keyType = &xkb->map->types[symMap->kt_index];
	desc->ktIndex = symMap->kt_index;
	desc->groupInfo = symMap->group_info;
	desc->nSyms = XkbNumGroups(symMap->group_info)*keyType->group_width;
	outSym = (KeySym *)&desc[1];
	pSym = &xkb->map->syms[symMap->offset];
	memcpy(outSym,pSym,desc->nSyms*sizeof(KeySym));
	desc = (xkbSymMapWireDesc *)&outSym[desc->nSyms];
    }
    return;
}

static int
_XkbSizeKeyActions(xkb,firstKey,nKeys,nActsRtrn)
    XkbDescRec	*xkb;
    unsigned	 firstKey;
    unsigned	 nKeys;
    CARD16	*nActsRtrn;
{
    int			i,len,nActs;
    unsigned		nSyms;

    for (nActs=i=0;i<nKeys;i++) {
	if (xkb->server->key_acts[i+firstKey]!=0)
	    nActs+= XkbKeyNumActions(xkb,i+firstKey);
    }
    len= (((nKeys+3)/4)*4)+(nActs*sizeof(XkbAction));
    *nActsRtrn = nActs;
    return len;
}

static void
_XkbWriteKeyActions(dpy,xkb,firstKey,nKeys,totalActs)
    Display *dpy;
    XkbDescRec *xkb;
    unsigned firstKey;
    unsigned nKeys;
    unsigned totalActs;
{
    register int	 i;
    int	 		 n;
    CARD8		*numDesc;
    XkbAction		*actDesc;

    n = (((nKeys+3)/4)*4)+totalActs*sizeof(XkbAction);
    BufAlloc(CARD8 *,numDesc,n);
    for (i=0;i<nKeys;i++) {
	if (xkb->server->key_acts[i+firstKey]==0)
	     numDesc[i] = 0;
	else numDesc[i] = XkbKeyNumActions(xkb,(i+firstKey));
    }
    actDesc = (XkbAction *)&numDesc[(((nKeys)+3)/4)*4];
    for (i=0;i<nKeys;i++) {
	if (xkb->server->key_acts[i+firstKey]!=0) {
	    n = XkbKeyNumActions(xkb,(i+firstKey));
	    memcpy(actDesc,XkbKeyActionsPtr(xkb,(i+firstKey)),
                                                        n*sizeof(XkbAction));
	    actDesc+= n;
	}
    }
    return;
}

static int
_XkbSizeKeyBehaviors(xkb,req,pChanges)
    XkbDescPtr		xkb;
    xkbSetMapReq *	req;
    XkbMapChangesRec *	pChanges;
{
register int i,first,last,nFound;

    if ((req->present&XkbKeyBehaviorsMask)==0) {
	req->totalKeyBehaviors= 0;
	return 0;
    }
    else if (pChanges) {
	first= pChanges->first_key_behavior;
	last= first+pChanges->num_key_behaviors-1;
    }
    else {
	first= xkb->min_key_code;
	last= xkb->max_key_code;
    }

    for (i=first,nFound=0;i<=last;i++) {
	if (xkb->server->behaviors[i].type!=XkbKB_Default)
	    nFound++;
    }
    req->totalKeyBehaviors= nFound;
    return (nFound*SIZEOF(xkbBehaviorWireDesc));
}

static void
_XkbWriteKeyBehaviors(dpy,xkb,req,pChanges)
    Display *		dpy;
    XkbDescPtr		xkb;
    xkbSetMapReq *	req;
    XkbMapChangesRec *	pChanges;
{
register int i,first,last;
xkbBehaviorWireDesc *wire;

    if ((req->present&XkbKeyBehaviorsMask)==0)
	return;
    if (pChanges) {
	first= pChanges->first_key_behavior;
	last= first+pChanges->num_key_behaviors-1;
    }
    else {
	first= xkb->min_key_code;
	last= xkb->max_key_code;
    }
    i= req->totalKeyBehaviors*SIZEOF(xkbBehaviorWireDesc);
    BufAlloc(xkbBehaviorWireDesc *,wire,i);
    for (i=first;i<=last;i++) {
	if (xkb->server->behaviors[i].type!=XkbKB_Default) {
	    wire->key= i;
	    wire->type= xkb->server->behaviors[i].type;
	    wire->data= xkb->server->behaviors[i].data;
	    wire++;
	}
    }
    return;
}

static int
_XkbSizeVirtualMods(xkb,which)
    XkbDescPtr	xkb;
    unsigned	which;
{
register int i,bit,nMods;

   for (i=nMods=0,bit=1;i<XkbNumVirtualMods;i++,bit<<=1) {
	if (which&bit)
	    nMods++;
   }
   return ((nMods+(unsigned)3)/4)*4;
}

static void
_XkbWriteVirtualMods(dpy,xkb,which,size)
    Display *		dpy;
    XkbDescPtr		xkb;
    unsigned 		which;
    unsigned 		size;
{
    register int	 i,bit;
    CARD8		*vmods;

    BufAlloc(CARD8 *,vmods,size);
    for (i=0,bit=1;i<XkbNumVirtualMods;i++,bit<<=1) {
	if (which&bit)
	    *vmods++= xkb->server->vmods[i];
    }
    return;
}

static int
_XkbSizeKeyExplicit(xkb,req,pChanges)
    XkbDescPtr		xkb;
    xkbSetMapReq *	req;
    XkbMapChangesPtr 	pChanges;
{
register int i,first,last,nFound;

    if ((req->present&XkbExplicitComponentsMask)==0) {
	req->totalKeyExplicit= 0;
	return 0;
    }
    else if (pChanges) {
	first= pChanges->first_key_explicit;
	last= first+pChanges->num_key_explicit-1;
    }
    else {
	first= xkb->min_key_code;
	last= xkb->max_key_code;
    }

    for (i=first,nFound=0;i<=last;i++) {
	if (xkb->server->explicit[i]!=0)
	    nFound++;
    }
    req->totalKeyExplicit= nFound;
    return (((nFound*2)+3)/4)*4;
}

static void
_XkbWriteKeyExplicit(dpy,xkb,req,pChanges)
    Display *		dpy;
    XkbDescPtr		xkb;
    xkbSetMapReq *	req;
    XkbMapChangesPtr	pChanges;
{
register int	i,first,last;
CARD8 *		wire;

    if ((req->present&XkbExplicitComponentsMask)==0)
	return;
    else if (pChanges) {
	first= pChanges->first_key_explicit;
	last= first+pChanges->num_key_explicit-1;
    }
    else {
	first= xkb->min_key_code;
	last= xkb->max_key_code;
    }
    i= (((req->totalKeyExplicit*2)+3)/4)*4;
    BufAlloc(CARD8 *,wire,i);
    for (i=first;i<=last;i++) {
	if (xkb->server->explicit[i]!=0) {
	    wire[0]= i;
	    wire[1]= xkb->server->explicit[i];
	    wire+= 2;
	}
    }
    return;
}

static void
SendSetMap(dpy,xkb,req,pChanges)
    Display *		dpy;
    XkbDescPtr 		xkb;
    xkbSetMapReq *	req;
    XkbMapChangesRec *	pChanges;
{
xkbSetMapReq tmp;
int szMods;
CARD16 totalSyms,totalActs;

    req->length+= _XkbSizeKeyTypes(xkb,req->firstType,req->nTypes)/4;
    req->length+= _XkbSizeKeySyms(xkb,req->firstKeySym,req->nKeySyms,
						    	&totalSyms)/4;
    req->length+= _XkbSizeKeyActions(xkb,req->firstKeyAction,req->nKeyActions,
						    	&totalActs)/4;
    req->length+= _XkbSizeKeyBehaviors(xkb,req,pChanges)/4;
    szMods= _XkbSizeVirtualMods(xkb,req->virtualMods);
    req->length+= szMods/4;
    req->length+= _XkbSizeKeyExplicit(xkb,req,pChanges)/4;
    req->totalSyms= totalSyms;
    req->totalActions= totalActs;

    tmp= *req;
    if ( tmp.nTypes>0 )
	_XkbWriteKeyTypes(dpy,xkb,tmp.firstType,tmp.nTypes);
    if ( tmp.nKeySyms>0 )
	_XkbWriteKeySyms(dpy,xkb,tmp.firstKeySym,tmp.nKeySyms,tmp.totalSyms);
    if ( tmp.nKeyActions )
	_XkbWriteKeyActions(dpy,xkb,tmp.firstKeyAction,tmp.nKeyActions,
							     tmp.totalActions);
    if ( tmp.totalKeyBehaviors>0 )
	_XkbWriteKeyBehaviors(dpy,xkb,&tmp,pChanges);
    if ( tmp.virtualMods )
	_XkbWriteVirtualMods(dpy,xkb,tmp.virtualMods,szMods);
    if ( tmp.totalKeyExplicit>0)
	_XkbWriteKeyExplicit(dpy,xkb,&tmp,pChanges);
    return;
}

Status
XkbSetMap(dpy,which,xkb)
    Display *dpy;
    unsigned which;
    XkbDescRec *xkb;
{
    register xkbSetMapReq	*req;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;

    if (((which&XkbKeyTypesMask)&&(!xkb->map->types))||
	((which&XkbKeySymsMask)&&
				((!xkb->map->syms)||(!xkb->map->key_sym_map)))||
	((which&XkbKeyActionsMask)&&
				((!xkb->server)||(!xkb->server->key_acts)))||
	((which&XkbKeyBehaviorsMask)&&
			       ((!xkb->server)||(!xkb->server->behaviors)))||
	((which&XkbVirtualModsMask)&&(!xkb->server))||
	((which&XkbExplicitComponentsMask)&&
				((!xkb->server)||(!xkb->server->explicit))))
	return False;

    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbSetMap, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbSetMap;
    req->deviceSpec = xkb->device_spec;
    req->present = which;
    req->resize = which&XkbResizableInfoMask;
    req->firstType = 0;
    if (which&XkbKeyTypesMask)	req->nTypes = xkb->map->num_types;
    else			req->nTypes = 0;
    req->firstKeySym = 0;
    if (which&XkbKeySymsMask) {
	req->firstKeySym = xkb->min_key_code;
	req->nKeySyms = xkb->max_key_code-xkb->min_key_code+1;
    }
    if (which&XkbKeyActionsMask) {
	req->firstKeyAction = xkb->min_key_code;
	req->nKeyActions = xkb->max_key_code-xkb->min_key_code+1;
    }
    if (which&XkbVirtualModsMask)
	req->virtualMods= ~0;
    SendSetMap(dpy,xkb,req,NULL);
    UnlockDisplay(dpy);
    SyncHandle();
    return True;
}

Status
XkbChangeMap(dpy,xkb,changes)
    Display *dpy;
    XkbDescRec *xkb;
    XkbMapChangesRec *changes;
{
    register xkbSetMapReq	*req;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;

    if (((changes->changed&XkbKeyTypesMask)&&(!xkb->map->types))||
	((changes->changed&XkbKeySymsMask)&&((!xkb->map->syms)||
				(!xkb->map->key_sym_map)))||
	((changes->changed&XkbKeyActionsMask)&&
				((!xkb->server)||(!xkb->server->key_acts)))||
	((changes->changed&XkbKeyBehaviorsMask)&&
			       ((!xkb->server)||(!xkb->server->behaviors)))||
	((changes->changed&XkbVirtualModsMask)&&(!xkb->server))||
	((changes->changed&XkbExplicitComponentsMask)&&
			       ((!xkb->server)||(!xkb->server->explicit))))
	return False;

    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbSetMap, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbSetMap;
    req->deviceSpec = xkb->device_spec;
    req->present = changes->changed;
    req->resize = 0;
    req->firstType = changes->first_type;
    req->nTypes = changes->num_types;
    req->firstKeySym = changes->first_key_sym;
    req->nKeySyms = changes->num_key_syms;
    req->firstKeyAction = changes->first_key_act;
    req->nKeyActions = changes->num_key_acts;
    req->virtualMods = changes->vmods;
    SendSetMap(dpy,xkb,req,changes);
    UnlockDisplay(dpy);
    SyncHandle();
    return True;
}

