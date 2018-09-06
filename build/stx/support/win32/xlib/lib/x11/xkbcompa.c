/* $XConsortium: XKBCompat.c,v 1.2 94/04/08 15:10:49 erik Exp $ */
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

static Status
_XkbReadGetCompatMapReply(dpy,rep,xkb)
    Display *			dpy;
    xkbGetCompatMapReply *	rep;
    XkbDescPtr			xkb;
{
register int 		i;
XkbReadBufferRec	buf;
int			nMods,nVMods;

    if (!_XkbInitReadBuffer(dpy,&buf,rep->length*4)) 
	return False;

    if ((!xkb->compat)&&
	(!XkbAllocCompatMap(xkb,XkbAllCompatMask,rep->firstSI+rep->nSI-1)))
	return False;

    if (rep->nSI!=0) {
	XkbSymInterpretRec *syms;
	xkbSymInterpretWireDesc *wire;

	int lastSI= rep->firstSI+rep->nSI-1;
	wire= (xkbSymInterpretWireDesc *)_XkbGetReadBufferPtr(&buf,
				   rep->nSI*SIZEOF(xkbSymInterpretWireDesc));
	if (wire==NULL)
	    goto BAILOUT;
	syms= &xkb->compat->sym_interpret[rep->firstSI];

	for (i=0;i<rep->nSI;i++,syms++,wire++) {
	    syms->sym= wire->sym;
	    syms->mods= wire->mods;
	    syms->match= wire->match;
	    syms->virtual_mod= wire->virtualMod;
	    syms->flags= wire->flags;
	    syms->act= *((XkbAnyAction *)&wire->act);
	}
	xkb->compat->num_si+= rep->nSI;
    }
    nMods= nVMods= 0;

    if (rep->mods) {
	register int bit;
	xkbModCompatWireDesc *wire;

	for (i=0,bit=1;i<XkbNumModifiers;i++,bit<<=1) {
	    if (rep->mods&bit)
		nMods++;
	}
	wire= (xkbModCompatWireDesc *)_XkbGetReadBufferPtr(&buf,
					sz_xkbModCompatWireDesc*nMods);
	if (wire==NULL)
	    goto BAILOUT;
	for (i=0,bit=1;i<XkbNumModifiers;i++,bit<<=1) {
	    if (rep->mods&bit) {
		xkb->compat->real_mod_compat[i].mods= wire->mods;
		xkb->compat->real_mod_compat[i].groups= wire->groups;
		wire++;
	    }
	}
    }
    if (rep->virtualMods) {
	register int bit;
	xkbModCompatWireDesc *wire;

	for (i=0,bit=1;i<XkbNumVirtualMods;i++,bit<<=1) {
	    if (rep->virtualMods&bit)
		nVMods++;
	}
	wire= (xkbModCompatWireDesc *)_XkbGetReadBufferPtr(&buf,
					sz_xkbModCompatWireDesc*nVMods);
	if (wire==NULL)
	    goto BAILOUT;
	for (i=0,bit=1;i<XkbNumVirtualMods;i++,bit<<=1) {
	    if (rep->virtualMods&bit) {
		xkb->compat->vmod_compat[i].mods= wire->mods;
		xkb->compat->vmod_compat[i].groups= wire->groups;
		wire++;
	    }
	}
    }
    i= ((nMods+nVMods)*sz_xkbModCompatWireDesc);
    i= (((i+3)/4)*4)-i;
    if (i>0)
	_XkbSkipReadBufferData(&buf,i);

    i= _XkbFreeReadBuffer(&buf);
    if (i) 
	fprintf(stderr,"CompatMapReply! Bad length (%d extra bytes)\n",i);
    if (i || buf.error)
	return False;
    return True;
BAILOUT:
    _XkbFreeReadBuffer(&buf);
    return False;
}

Status
XkbGetCompatMap(dpy,which,xkb)
    Display *dpy;
    unsigned which;
    XkbDescRec *xkb;
{
    register xkbGetCompatMapReq *req;
    xkbGetCompatMapReply	 rep;
    Status		     ok;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbGetCompatMap, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbGetCompatMap;
    req->deviceSpec = xkb->device_spec;
    if (which&XkbSymInterpMask)
	 req->getAllSI= True;
    else req->getAllSI= False;
    req->firstSI= req->nSI= 0;

    if (which&XkbModCompatMask)
	 req->mods=  ~0;
    else req->mods=  0;

    if (which&XkbVirtualModCompatMask)
	 req->virtualMods=  ~0;
    else req->virtualMods=  0;

    if (!_XReply(dpy, (xReply *)&rep, 0, xFalse)) {
	UnlockDisplay(dpy);
	SyncHandle();
	return False;
    }
    if (xkb->device_spec==XkbUseCoreKbd)
	xkb->device_spec= rep.deviceID;

    ok = _XkbReadGetCompatMapReply(dpy,&rep,xkb);
    UnlockDisplay(dpy);
    SyncHandle();
    return ok;
}

static Status
_XkbWriteSetCompatMap(dpy,req,xkb)
    Display *		dpy;
    xkbSetCompatMapReq	*req;
    XkbDescPtr		xkb;
{
CARD8	mods = req->mods;
CARD16	vmods = req->virtualMods;
CARD16	firstSI = req->firstSI;
CARD16	nSI = req->nSI;
int	size,nMods,nVMods;
register int i,bit;
char	*buf;

    for (i=0,bit=1;i<XkbNumModifiers;i++,bit<<=1) {
	if (mods&bit)	nMods++;
	if (vmods&bit)	nVMods++;
    }
    for (;i<XkbNumVirtualMods;i++,bit<<=1) {
	if (vmods&bit) nVMods++;
    }

    size= nSI*sz_xkbSymInterpretWireDesc;
    size+= (((nMods*sz_xkbModCompatWireDesc)+3)/4)*4;
    req->length+= (size+3)/4;
    BufAlloc(char *,buf,size);
    if (!buf)
	return False;

    if (nSI) {
	XkbSymInterpretPtr sym= &xkb->compat->sym_interpret[firstSI];
	xkbSymInterpretWireDesc *wire= (xkbSymInterpretWireDesc *)buf;
	for (i=0;i<nSI;i++) {
	    wire->sym= sym->sym;
	    wire->mods= sym->mods;
	    wire->match= sym->match;
	    wire->flags= sym->flags;
	    wire->virtualMod= sym->virtual_mod;
	    memcpy(&wire->act,&sym->act,sz_xkbActionWireDesc);
	}
	buf+= nSI*sz_xkbSymInterpretWireDesc;
    }
    if (mods) {
	xkbModCompatWireDesc *out= (xkbModCompatWireDesc *)buf;
	for (i=0,bit=1;i<XkbNumModifiers;i++,bit<<=1) {
	    if (mods&bit) {
		out->mods= xkb->compat->real_mod_compat[i].mods;
		out->groups= xkb->compat->real_mod_compat[i].groups;
		out++;
	    }
	}
    }
    if (vmods) {
	xkbModCompatWireDesc *out= (xkbModCompatWireDesc *)buf;
	for (i=0,bit=1;i<XkbNumVirtualMods;i++,bit<<=1) {
	    if (vmods&bit) {
		out->mods= xkb->compat->vmod_compat[i].mods;
		out->groups= xkb->compat->vmod_compat[i].groups;
		out++;
	    }
	}
    }
    return True;
}

Status
XkbSetCompatMap(dpy,which,xkb,updateActions)
    Display *		dpy;
    unsigned 		which;
    XkbDescPtr		xkb;
    Bool		updateActions;
{
    register xkbSetCompatMapReq *req;
    Status		     ok;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    if ((!xkb->compat) ||
	((which&XkbSymInterpMask)&&(!xkb->compat->sym_interpret)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbSetCompatMap, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbSetCompatMap;
    req->deviceSpec = xkb->device_spec;
    req->recomputeActions = updateActions;
    if (which&XkbSymInterpMask) {
	req->truncateSI = True;
	req->firstSI= 0;
	req->nSI= xkb->compat->num_si;
    }
    else {
	req->truncateSI = False;
	req->firstSI= 0;
	req->nSI= 0;
    }
    if (which&XkbModCompatMask)
	 req->mods=	~0;
    else req->mods=  	 0;
    if (which&XkbVirtualModCompatMask)
	 req->virtualMods=	~0;
    else req->virtualMods=	 0;
    ok= _XkbWriteSetCompatMap(dpy,req,xkb);
    UnlockDisplay(dpy);
    SyncHandle();
    return ok;
}

/***====================================================================***/

Status
XkbAllocCompatMap(xkb,which,nInterpret)
    XkbDescPtr	xkb;
    unsigned	which;
    unsigned	nInterpret;
{
register int	i;
XkbCompatPtr	compat;

    if (!xkb)
	return False;
    if (xkb->compat) {
	if (xkb->compat->size_si>=nInterpret)
	    return True;
	compat= xkb->compat;
	compat->size_si= nInterpret;
	i= nInterpret*sizeof(XkbSymInterpretRec);
	if (compat->sym_interpret==NULL) {
	    compat->num_si= 0;
	    compat->sym_interpret= (XkbSymInterpretPtr)
				Xcalloc(nInterpret,sizeof(XkbSymInterpretRec));
	}
	else {
	    compat->sym_interpret= (XkbSymInterpretPtr)
				Xrealloc(compat->sym_interpret,i);
	    if (compat->sym_interpret!=NULL)
		bzero(&compat->sym_interpret[compat->num_si],
		      (nInterpret-compat->size_si)*sizeof(XkbSymInterpretRec));
	}
	if (compat->sym_interpret==NULL) {
	    compat->size_si= compat->num_si= 0;
	    return False;
	}
	return True;
    }
    compat= (XkbCompatPtr)Xmalloc(sizeof(XkbCompatRec));
    if (compat==NULL)
	return False;
    if (nInterpret>0) {
	i= nInterpret*sizeof(XkbSymInterpretRec);
	compat->sym_interpret= (XkbSymInterpretPtr)Xmalloc(i);
	if (!compat->sym_interpret) {
	    Xfree(compat);
	    return False;
	}
	bzero(compat->sym_interpret,i);
    }
    compat->size_si= nInterpret;
    compat->num_si= 0;
    for (i=0;i<XkbNumModifiers;i++) {
	compat->real_mod_compat[i].mods= (1<<i);
	compat->real_mod_compat[i].groups= 0;
	compat->mod_compat[i]= &compat->real_mod_compat[i];
    }
    bzero(compat->vmod_compat,sizeof(compat->vmod_compat));
    xkb->compat= compat;
    return True;
}


Status
XkbFreeCompatMap(xkb,all,which)
    XkbDescPtr	xkb;
    Bool	all;
    unsigned	which;
{
    if ((xkb==NULL)||(xkb->compat==NULL))
	return False;
    if (which&XkbModCompatMask) {
	register int i;
	for (i=0;i<XkbNumModifiers;i++) {
	    xkb->compat->real_mod_compat[i].mods= (1<<i);
	    xkb->compat->real_mod_compat[i].groups= 0;
	    xkb->compat->mod_compat[i]= &xkb->compat->real_mod_compat[i];
	}
    }
    if (which&XkbVirtualModCompatMask) {
	bzero(xkb->compat->vmod_compat,sizeof(xkb->compat->vmod_compat));
    }
    if (which&XkbSymInterpMask) {
	if ((xkb->compat->sym_interpret)&&(xkb->compat->size_si>0))
	    Xfree(xkb->compat->sym_interpret);
	xkb->compat->size_si= xkb->compat->num_si= 0;
	xkb->compat->sym_interpret= NULL;
    }
    if (all) {
	Xfree(xkb->compat);
	xkb->compat= NULL;
    }
    return True;
}
