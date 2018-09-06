/* $XConsortium: XKBGetMap.c,v 1.2 94/04/08 15:11:51 erik Exp $ *
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

Status
XkbAllocClientMap(xkb,which,nTypes)
    XkbDescPtr		xkb;
    unsigned		which;
    unsigned		nTypes;
{
register int	i;
XkbClientMapPtr map;

    if ((xkb==NULL)||((nTypes>0)&&(nTypes<XkbNumRequiredTypes)))
	return False;
    if ((which&XkbKeySymsMask)&&
	((xkb->min_key_code<8)||(xkb->max_key_code<xkb->min_key_code)))
	return False;

    if (xkb->map==NULL) {
	map= (XkbClientMapPtr)Xcalloc(1,sizeof(XkbClientMapRec));
	if (map==NULL)
	    return False;
	xkb->map= map;
    }
    else map= xkb->map;

    if ((which&XkbKeyTypesMask)&&(nTypes>0)) {
	if (map->types==NULL) {
	    map->types= (XkbKeyTypePtr)Xcalloc(nTypes,sizeof(XkbKeyTypeRec));
	    if (map->types==NULL)
		return False;
	    map->num_types= 0;
	    /* 3/21/94 (ef) -- XXX! should create canonical types here */
	    map->size_types= nTypes;
	}
	else if (map->size_types<nTypes) {
	    map->types= (XkbKeyTypePtr)Xrealloc(map->types,
						nTypes*sizeof(XkbKeyTypeRec));
	    if (map->types==NULL) {
		map->num_types= map->size_types= 0;
		return False;
	    }
	    map->size_types= nTypes;
	    bzero(&map->types[map->num_types], 
		  ((map->size_types-map->num_types)*sizeof(XkbKeyTypeRec)));
	}
    }
    if (which&XkbKeySymsMask) {
	if (map->syms==NULL) {
	    map->syms= (KeySym *)Xcalloc(100,sizeof(KeySym));
	    if (!map->syms)
		return False;
	    map->size_syms= 100;
	    map->num_syms= 1;
	    map->syms[0]= NoSymbol;
	}
	if (map->key_sym_map==NULL) {
	    i= xkb->max_key_code+1;
	    map->key_sym_map=(XkbSymMapPtr)Xcalloc(i,sizeof(XkbSymMapRec));
	    if (map->key_sym_map==NULL)
		return False;
	    /* default is no groups, symbol at offset 0 */
	}
    }
    return True;
}

Status
XkbAllocServerMap(xkb,which,nActions)
    XkbDescPtr		xkb;
    unsigned		which;
    unsigned		nActions;
{
register int	i;
XkbServerMapPtr map;

    if (xkb==NULL)
	return False;
    if (xkb->server==NULL) {
	map= (XkbServerMapPtr)Xcalloc(1,sizeof(XkbServerMapRec));
	if (map==NULL)
	    return False;
	for (i=0;i<XkbNumVirtualMods;i++) {
	    map->vmods[i]= XkbNoModifier;
	}
	xkb->server= map;
    }
    else map= xkb->server;
    if ((which&XkbKeyActionsMask)&&(nActions>0)) {
	if ((xkb->min_key_code<8)||(xkb->max_key_code<xkb->min_key_code))
	    return False;
	if (map->acts==NULL) {
	    map->acts= (XkbAction *)Xcalloc((nActions+1),sizeof(XkbAction));
	    if (map->acts==NULL)
		return False;
	    map->num_acts= 1;
	    map->size_acts= nActions+1;
	}
	else if ((map->size_acts-map->num_acts)<nActions) {
	    unsigned need;
	    need= map->num_acts+nActions;
	    map->acts= (XkbAction *)Xrealloc(map->acts,
						need*sizeof(XkbAction));
	    if (map->acts==NULL) {
		map->num_acts= map->size_acts= 0;
		return False;
	    }
	    map->size_acts= need;
	    bzero(&map->acts[map->num_acts], 
		  ((map->size_acts-map->num_acts)*sizeof(XkbAction)));
	}
	if (map->key_acts==NULL) {
	    i= xkb->max_key_code+1;
	    map->key_acts=(unsigned short*)Xcalloc(i,sizeof(unsigned short));
	    if (map->key_acts==NULL)
		return False;
	}
    }
    if (which&XkbKeyBehaviorsMask) {
	if ((xkb->min_key_code<8)||(xkb->max_key_code<xkb->min_key_code))
	    return False;
	if (map->behaviors==NULL) {
	    i= xkb->max_key_code+1;
	    map->behaviors= (XkbBehavior *)Xcalloc(i,sizeof(XkbBehavior));
	    if (map->behaviors==NULL)
		return False;
	}
    }
    if (which&XkbExplicitComponentsMask) {
	if ((xkb->min_key_code<8)||(xkb->max_key_code<xkb->min_key_code))
	    return False;
	if (map->explicit==NULL) {
	    i= xkb->max_key_code+1;
	    map->explicit= (unsigned char *)Xcalloc(i,sizeof(unsigned char));
	    if (map->explicit==NULL)
		return False;
	}
    }
    return True;
}

static Bool
_XkbInitServerMap(xkb)
    XkbDescRec *xkb;
{
int	size;
XkbServerMapRec *map;

    if ((!xkb)||(xkb->server)||(xkb->max_key_code<8))
	return True;
    size= sizeof(XkbServerMapRec)+((xkb->max_key_code+1)*sizeof(XkbBehavior));
    size+= ((xkb->max_key_code+1)*sizeof(unsigned short));/* key acts */
    size+= ((xkb->max_key_code+1)*sizeof(unsigned char)); /* explicit info */
    xkb->server= map=(XkbServerMapRec *)Xmalloc(size);
    if (map) {
	register int i;
	bzero((char *)&map[1],size-sizeof(XkbServerMapRec));
	map->num_acts = 1;
	map->size_acts = 32;
	map->acts= (XkbAction *)Xmalloc(map->size_acts*sizeof(XkbAction));
	map->acts[0].type = XkbSA_NoAction;

	map->behaviors= (XkbBehavior *)&map[1];
	map->key_acts= (unsigned short *)&map->behaviors[xkb->max_key_code];
	map->explicit= (unsigned char *)&map->key_acts[xkb->max_key_code];
	for (i=0;i<XkbNumVirtualMods;i++) {
	    map->vmods[i]= XkbNoModifier;
	}
	return True;
    }
    return False;
}

/***====================================================================***/

static Bool
_XkbReadKeyTypes(dpy,buf,xkb,rep,replace)
    Display *		dpy;
    XkbReadBufferPtr	buf;
    XkbDescPtr 		xkb;
    xkbGetMapReply *	rep;
    int 		replace;
{
int		 i,n,last;
XkbKeyTypeRec	*map;

    if ( rep->nTypes>0 ) {
	last = rep->firstType+rep->nTypes-1;
	if (!XkbAllocClientMap(xkb,XkbKeyTypesMask,rep->totalTypes))
	    return False;

	map = &xkb->map->types[rep->firstType];
	for (i=0;i<(int)rep->nTypes;i++,map++) {
	    xkbKeyTypeWireDesc	*desc;
	    register int ndx;

	    ndx= i+rep->firstType;
	    if (ndx>=xkb->map->num_types)
		xkb->map->num_types= ndx+1;

	    desc= (xkbKeyTypeWireDesc *)_XkbGetReadBufferPtr(buf,
						SIZEOF(xkbKeyTypeWireDesc));
	    if (desc==NULL)
		return False;

	    if ( desc->nMapEntries>0 ) {
		if ((map->map!=NULL)&&(map->free&XkbNoFreeKTMap)) {
		    map->map_count= 0;
		    map->map= NULL;
		    map->free&= ~XkbNoFreeKTMap;
		}
		if ((map->map==NULL)||(desc->nMapEntries>map->map_count)){
		    register int size;
		    size= sizeof(XkbKTMapEntryRec)*desc->nMapEntries;
		    if ( map->map )
			 map->map= (XkbKTMapEntryPtr)Xrealloc(map->map,size);
		    else map->map = (XkbKTMapEntryPtr)Xmalloc(size);
		    if (map->map==NULL)
			return False;
		}
	    }
	    else if (map->map!=NULL) {
		Xfree(map->map);
		map->map_count= 0;
		map->map= NULL;
	    }

	    if ( desc->preserve ) {
		if ((map->preserve!=NULL)&&(map->free&XkbNoFreeKTPreserve)) {
		    map->preserve= NULL;
		    map->free&= ~XkbNoFreeKTPreserve;
		}
		if ((!map->preserve)||
		    (desc->nMapEntries>map->map_count)) {
		    register int size;
		    size= sizeof(XkbKTPreserveRec)*desc->nMapEntries;
		    if ( map->preserve )
			 map->preserve= (XkbKTPreservePtr)
					Xrealloc(map->preserve,size);
		    else map->preserve= (XkbKTPreservePtr)Xmalloc(size);
		    if (map->preserve==NULL)
			return False;
		}
	    }
	    else if (map->preserve!=NULL) {
		Xfree(map->preserve);
		map->preserve= NULL;
	    }

	    map->mask = desc->mask;
	    map->real_mods = desc->realMods;
	    map->vmods = desc->virtualMods;
	    map->group_width = desc->groupWidth;
	    map->free = 0;
	    map->map_count = desc->nMapEntries;
	    if (desc->nMapEntries>0) {
		register xkbKTMapEntryWireDesc *wire; 
		register XkbKTMapEntryPtr	entry;
		register int size;

		size= map->map_count*SIZEOF(xkbKTMapEntryWireDesc);
		wire= (xkbKTMapEntryWireDesc *)_XkbGetReadBufferPtr(buf,size);
		if (wire==NULL)
		    return False;
		entry= map->map;
		for (n=0;n<map->map_count;n++,wire++,entry++) {
		    entry->active= wire->active;
		    entry->mask= wire->mask;
		    entry->level= wire->level;
		    entry->real_mods= wire->realMods;
		    entry->vmods= wire->virtualMods;
		}

	 	if (desc->preserve) {
		    register xkbKTPreserveWireDesc *	pwire; 
		    register XkbKTPreservePtr		preserve;
		    register int sz;

		    sz= desc->nMapEntries*SIZEOF(xkbKTPreserveWireDesc);
		    pwire=(xkbKTPreserveWireDesc *)_XkbGetReadBufferPtr(buf,sz);
		    if (pwire==NULL)
			return False;
		    preserve= map->preserve;
		    for (n=0;n<desc->nMapEntries;n++,pwire++,preserve++) {
			preserve->mask=  pwire->mask;
			preserve->vmods=  pwire->virtualMods;
			preserve->real_mods= pwire->realMods;
		    }
		}
	    }
	}
    }
    return True;
}

static Bool
_XkbReadKeySyms(dpy,buf,xkb,rep,replace)
    Display *		dpy;
    XkbReadBufferPtr	buf;
    XkbDescPtr 		xkb;
    xkbGetMapReply *	rep;
    int 		replace;
{
register int i;
XkbClientMapPtr	map;

    map= xkb->map;
    if (map->key_sym_map==NULL) {
	register int offset;
	XkbSymMapRec *oldMap;
	xkbSymMapWireDesc *newMap;
	map->key_sym_map= (XkbSymMapRec *)Xmalloc((xkb->max_key_code+1)*
						   sizeof(XkbSymMapRec));
	if (map->key_sym_map==NULL)
	    return False;
	if (map->syms==NULL) {
	    int sz;
	    sz= (rep->totalSyms*12)/10;
	    sz= ((sz+(unsigned)128)/128)*128;
	    map->syms = (KeySym *)Xmalloc(sz*sizeof(KeySym));
	    if (map->syms==NULL)
		return False;
	    map->size_syms = sz;
	}
	offset = 1;
	oldMap = &map->key_sym_map[rep->firstKeySym];
	for (i=0;i<(int)rep->nKeySyms;i++,oldMap++) {
	    register int tmp;
	    newMap= (xkbSymMapWireDesc *)
			_XkbGetReadBufferPtr(buf,SIZEOF(xkbSymMapWireDesc));
	    oldMap->kt_index= newMap->ktIndex;
	    oldMap->group_info= newMap->groupInfo;
	    oldMap->offset= offset;
	    if (offset+newMap->nSyms>=map->size_syms) {
		register int sz;
		sz= map->size_syms+128;
		map->syms= (KeySym *)Xrealloc(map->syms,sz*sizeof(KeySym));
		if (map->syms==NULL) {
		    map->size_syms= 0;
		    return False;
		}
		map->size_syms= sz;
	    }
	    if (newMap->nSyms>0) {
		_XkbReadBufferCopy32(buf,(long *)&map->syms[offset],
							newMap->nSyms);
		offset+= newMap->nSyms;
	    }
	    else {
		map->syms[offset]= 0;
	    }
	}
	map->num_syms= offset;
    }
    else {
	xkbSymMapWireDesc *newMap;
	XkbSymMapRec *oldMap;
	KeySym *newSyms;
	int	tmp;

	oldMap = &map->key_sym_map[rep->firstKeySym];
	for (i=0;i<(int)rep->nKeySyms;i++,oldMap++) {
	    newMap= (xkbSymMapWireDesc *)
			_XkbGetReadBufferPtr(buf,SIZEOF(xkbSymMapWireDesc));
	    if (newMap->nSyms>0)
		 tmp= newMap->nSyms;
	    else tmp= 1;

	    newSyms = XkbEnlargeKeySyms(xkb,i+rep->firstKeySym,tmp);
	    if (newMap->nSyms>0)
		_XkbReadBufferCopy32(buf,(long *)newSyms,newMap->nSyms);
	    else newSyms[0]= NoSymbol;
	    oldMap->kt_index = newMap->ktIndex;
	    oldMap->group_info = newMap->groupInfo;
	}
    }
    return True;
}

static Bool
_XkbReadKeyActions(dpy,buf,info,rep,replace)
    Display *		dpy;
    XkbDescPtr		info;
    XkbReadBufferPtr	buf;
    xkbGetMapReply *	rep;
    int 		replace;
{
int		 i,last;
CARD8		 numDesc[248];
XkbAction	*actDesc;

    if ( rep->nKeyActions>0 ) {
	XkbSymMapRec *symMap;
	_XkbCopyFromReadBuffer(buf, (char *)numDesc, rep->nKeyActions);
	i= XkbPaddedSize(rep->nKeyActions)-rep->nKeyActions;
	if (i>0)
	    _XkbSkipReadBufferData(buf,i);
	symMap = &info->map->key_sym_map[rep->firstKeyAction];
	for (i=0;i<(int)rep->nKeyActions;i++,symMap++) {
	    if (numDesc[i]==0) {
		info->server->key_acts[i+rep->firstKeyAction]= 0;
	    }
	    else {
		XkbAction *newActs;
		/* 8/16/93 (ef) -- XXX! Verify size here (numdesc must be */
		/*                 either zero or XkbKeyNumSyms(info,key) */
		newActs=XkbEnlargeKeyActions(info,i+rep->firstKeyAction,
								numDesc[i]);
		_XkbCopyFromReadBuffer(buf,(char *)newActs,
						numDesc[i]*sizeof(XkbAction));
	    }
	}
	return True;
    }
    return True;
}

static Bool
_XkbReadKeyBehaviors(dpy,buf,xkb,rep)
    Display *		dpy;
    XkbReadBufferPtr	buf;
    XkbDescPtr 		xkb;
    xkbGetMapReply *	rep;
{
register int i;
xkbBehaviorWireDesc	*wire;

    if ( rep->totalKeyBehaviors>0 ) {
	if ( xkb->server->behaviors == NULL ) {
	    int size = xkb->max_key_code+1;
	    xkb->server->behaviors = 
			(XkbBehavior *)Xcalloc(size,sizeof(XkbBehavior));
	    if (xkb->server->behaviors==NULL)
		return False;
	}
	for (i=0;i<rep->totalKeyBehaviors;i++) {
	    wire= (xkbBehaviorWireDesc *)_XkbGetReadBufferPtr(buf,
						SIZEOF(xkbBehaviorWireDesc));
	    if (wire==NULL)
		return False;
	    xkb->server->behaviors[wire->key].type= wire->type;
	    xkb->server->behaviors[wire->key].data= wire->data;
	}
    }
    return True;
}

static Bool
_XkbReadVirtualMods(dpy,buf,xkb,rep)
    Display *		dpy;
    XkbReadBufferPtr	buf;
    XkbDescPtr		xkb;
    xkbGetMapReply *	rep;
{
    if ( rep->virtualMods ) {
	register int i,bit,nVMods;
	register char *data;

	for (i=nVMods=0,bit=1;i<XkbNumVirtualMods;i++,bit<<=1) {
	    if (rep->virtualMods&bit)
		nVMods++;
	}
	data= _XkbGetReadBufferPtr(buf,XkbPaddedSize(nVMods));
	if (data==NULL)
	    return False;
	for (i=0,bit=1;(i<XkbNumVirtualMods)&&(nVMods>0);i++,bit<<=1) {
	    if (rep->virtualMods&bit) {
		xkb->server->vmods[i]= *data++;
		nVMods--;
	    }
	}
	return True;
    }
    return True;
}

static Bool
_XkbReadExplicitComponents(dpy,buf,xkb,rep)
    Display *		dpy;
    XkbReadBufferPtr	buf;
    XkbDescPtr		xkb;
    xkbGetMapReply *	rep;
{
register int i;
unsigned char *wire,*start;

    if ( rep->totalKeyExplicit>0 ) {
	if ( xkb->server->explicit == NULL ) {
	    int size = xkb->max_key_code+1;
	    xkb->server->explicit = (unsigned char *)Xcalloc(size,1);
	    if (xkb->server->explicit==NULL)
		return False;
	}
	i= XkbPaddedSize(2*rep->totalKeyExplicit);
	wire=(unsigned char *)_XkbGetReadBufferPtr(buf,i);
	for (i=0;i<rep->totalKeyExplicit;i++,wire+=2) {
	    xkb->server->explicit[wire[0]]= wire[1];
	}
    }
    return True;
}

static xkbGetMapReq *
_XkbGetGetMapReq(dpy,xkb)
    Display *dpy;
    XkbDescRec *xkb;
{
xkbGetMapReq *req;

    GetReq(kbGetMap, req);
    req->reqType = dpy->xkb_info->codes->major_opcode;
    req->xkbReqType = X_kbGetMap;
    req->deviceSpec = xkb->device_spec;
    req->full = req->partial = 0;
    req->firstType = req->nTypes = 0;
    req->firstKeySym = req->nKeySyms = 0;
    req->firstKeyAction = req->nKeyActions = 0;
    req->firstKeyBehavior = req->nKeyBehaviors = 0;
    req->virtualMods = 0;
    req->firstKeyExplicit = req->nKeyExplicit = 0;
    return req;
}

static Bool
_XkbHandleGetMapReply(dpy,xkb)
    Display *dpy;
    XkbDescRec *xkb;
{
xkbGetMapReply rep;

    if (!_XReply(dpy, (xReply *)&rep, 0, xFalse)) {
	return False;
    }
    if ( xkb->device_spec == XkbUseCoreKbd )
	xkb->device_spec= rep.deviceID;
    xkb->min_key_code = rep.minKeyCode;
    xkb->max_key_code = rep.maxKeyCode;

    if ((rep.present&XkbFullServerInfoMask)&&(!xkb->server))
	_XkbInitServerMap(xkb);
    if (rep.length) {
	XkbReadBufferRec	buf;
	int			left;
	if (_XkbInitReadBuffer(dpy,&buf,rep.length*4)) {
	    Status ok= True;
	    ok= _XkbReadKeyTypes(dpy,&buf,xkb,&rep,1)&&ok;
	    ok= _XkbReadKeySyms(dpy,&buf,xkb,&rep,1)&&ok;
	    ok= _XkbReadKeyActions(dpy,&buf,xkb,&rep,1)&&ok;
	    ok= _XkbReadKeyBehaviors(dpy,&buf,xkb,&rep)&&ok;
	    ok= _XkbReadVirtualMods(dpy,&buf,xkb,&rep)&&ok;
	    ok= _XkbReadExplicitComponents(dpy,&buf,xkb,&rep)&&ok;
	    left= _XkbFreeReadBuffer(&buf);
	    if (ok && left) 
		fprintf(stderr,
			"HandleGetMapReply! Bad length (%d extra bytes)\n",
			left);
	    if ((!ok) || left || buf.error) {
		return False;
	    }
	}
    }
    return True;
}

Status
XkbGetUpdatedMap(dpy,which,xkb)
    Display *dpy;
    unsigned which;
    XkbDescRec *xkb;
{
    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    if (which) {
	register xkbGetMapReq *req;
	Status ok;

	LockDisplay(dpy);

	req = _XkbGetGetMapReq(dpy, xkb);
	req->full = which;
	ok= _XkbHandleGetMapReply(dpy, xkb);

	UnlockDisplay(dpy);
	SyncHandle();
	return ok;
    }
    return True;
}

XkbDescRec	*
XkbGetMap(dpy,which,deviceSpec)
    Display *dpy;
    unsigned which;
    unsigned deviceSpec;
{
XkbDescRec *xkb;

    xkb = (XkbDescRec *)Xmalloc(sizeof(XkbDescRec)+sizeof(XkbClientMapRec));
    if (xkb) {
	bzero(xkb,sizeof(XkbDescRec));
	xkb->device_spec = deviceSpec;
	xkb->map = (XkbClientMapRec *)&xkb[1];
	bzero(xkb->map,sizeof(XkbClientMapRec));
	if ((which)&&(!XkbGetUpdatedMap(dpy,which,xkb))) {
	    Xfree(xkb);
	    xkb= NULL;
	}
    }
    return xkb;
}

Status
XkbGetKeyTypes(dpy,first,num,xkb)
    Display *dpy;
    unsigned first;
    unsigned num;
    XkbDescRec *xkb;
{
    register xkbGetMapReq *req;
    Status ok;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;

    LockDisplay(dpy);

    req = _XkbGetGetMapReq(dpy, xkb);
    req->firstType = first;
    req->nTypes = num;
    ok= _XkbHandleGetMapReply(dpy, xkb);

    UnlockDisplay(dpy);
    SyncHandle();
    return ok;
}

Status
XkbGetKeyActions(dpy,first,num,xkb)
    Display *dpy;
    unsigned first;
    unsigned num;
    XkbDescRec *xkb;
{
    register xkbGetMapReq *req;
    Status ok;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;

    LockDisplay(dpy);

    req = _XkbGetGetMapReq(dpy, xkb);
    req->firstKeyAction = first;
    req->nKeyActions = num;
    ok= _XkbHandleGetMapReply(dpy, xkb);

    UnlockDisplay(dpy);
    SyncHandle();
    return ok;
}

Status
XkbGetKeySyms(dpy,first,num,xkb)
    Display *dpy;
    unsigned first;
    unsigned num;
    XkbDescRec *xkb;
{
    register xkbGetMapReq *req;
    Status ok;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;

    LockDisplay(dpy);

    req = _XkbGetGetMapReq(dpy, xkb);
    req->firstKeySym = first;
    req->nKeySyms = num;
    ok= _XkbHandleGetMapReply(dpy, xkb);

    UnlockDisplay(dpy);
    SyncHandle();

    return ok;
}

Status
XkbGetKeyBehaviors(dpy,first,num,xkb)
    Display *dpy;
    unsigned first;
    unsigned num;
    XkbDescRec *xkb;
{
    register xkbGetMapReq *req;
    Status ok;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;

    LockDisplay(dpy);

    req = _XkbGetGetMapReq(dpy, xkb);
    req->firstKeyBehavior = first;
    req->nKeyBehaviors = num;
    ok= _XkbHandleGetMapReply(dpy, xkb);

    UnlockDisplay(dpy);
    SyncHandle();
    return ok;
}

Status
XkbGetVirtualMods(dpy,which,xkb)
    Display *dpy;
    unsigned which;
    XkbDescRec *xkb;
{
    register xkbGetMapReq *req;
    Status ok;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;

    LockDisplay(dpy);

    req = _XkbGetGetMapReq(dpy, xkb);
    req->virtualMods = which;
    ok= _XkbHandleGetMapReply(dpy, xkb);

    UnlockDisplay(dpy);
    SyncHandle();
    return ok;
}

Status
XkbGetKeyExplicitComponents(dpy,first,num,xkb)
    Display *dpy;
    unsigned first;
    unsigned num;
    XkbDescRec *xkb;
{
    register xkbGetMapReq *req;
    Status ok;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;

    LockDisplay(dpy);

    req = _XkbGetGetMapReq(dpy, xkb);
    req->firstKeyExplicit = first;
    req->nKeyExplicit = num;
    ok= _XkbHandleGetMapReply(dpy, xkb);

    UnlockDisplay(dpy);
    SyncHandle();
    return ok;
}

Status
XkbRefreshMap(dpy,xkb,changes)
    Display *dpy;
    XkbDescRec *xkb;
    XkbMapChangesRec *changes;
{
    xkbGetMapReq *req;
    xkbGetMapReply rep;
    int nRead;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    if (changes->changed) {
	Status ok= True;
	req = _XkbGetGetMapReq(dpy, xkb);
	req->full = 0;
	req->partial = changes->changed;
	req->firstType = changes->first_type;
	req->nTypes = changes->num_types;
	req->firstKeySym = changes->first_key_sym;
	req->nKeySyms = changes->num_key_syms;
	req->firstKeyAction = changes->first_key_act;
	req->nKeyActions = changes->num_key_acts;
	req->firstKeyBehavior = changes->first_key_behavior;
	req->nKeyBehaviors = changes->num_key_behaviors;
	req->virtualMods = changes->vmods;
	req->firstKeyExplicit = changes->first_key_explicit;
	req->nKeyExplicit = changes->num_key_explicit;
	ok= _XkbHandleGetMapReply(dpy, xkb);
	SyncHandle();
	UnlockDisplay(dpy);
	return ok;
    }
    return True;
}
