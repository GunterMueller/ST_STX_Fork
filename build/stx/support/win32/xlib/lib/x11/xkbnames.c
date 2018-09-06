/* $XConsortium: XKBNames.c,v 1.3 94/04/08 15:12:04 erik Exp $ */
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
_XkbReadAtoms(buf,atoms,maxAtoms,present)
    XkbReadBufferPtr	 buf;
    Atom		*atoms;
    int			 maxAtoms;
    CARD32		 present;
{
register int i,bit;

    for (i=0,bit=1;(i<maxAtoms)&&(present);i++,bit<<=1) {
	if (present&bit) {
	    if (!_XkbReadBufferCopy32(buf,(long *)&atoms[i],1))
		return False;
	    present&= ~bit;
	}
    }
    return True;
}

static Status
_XkbReadGetNamesReply(dpy,rep,xkb)
    Display *dpy;
    xkbGetNamesReply *rep;
    XkbDescPtr xkb;
{
    int				 i,len;
    char		 	*desc;
    XkbReadBufferRec		 buf;
    register XkbNamesPtr	 names;

    if ( xkb->device_spec == XkbUseCoreKbd )
	xkb->device_spec = rep->deviceID;

    names= xkb->names;
    if (rep->length==0)
	return True;

    if (!_XkbInitReadBuffer(dpy,&buf,rep->length*4))
	return False;

    if ((rep->which&XkbKeycodesNameMask)&&
	(!_XkbReadBufferCopy32(&buf,(long *)&names->keycodes,1)))
	    goto BAILOUT;
    if ((rep->which&XkbGeometryNameMask)&&
	(!_XkbReadBufferCopy32(&buf,(long *)&names->geometry,1)))
	    goto BAILOUT;
    if ((rep->which&XkbSymbolsNameMask)&&
	(!_XkbReadBufferCopy32(&buf,(long *)&names->symbols,1)))
	    goto BAILOUT;
    if ((rep->which&XkbSemanticsNameMask)&&
	(!_XkbReadBufferCopy32(&buf,(long *)&names->semantics,1)))
	    goto BAILOUT;

    if ( rep->which & XkbKeyTypeNamesMask ) {
	XkbClientMapPtr	map= xkb->map;
	XkbKeyTypePtr	type;

	len= rep->nTypes*4;
	if (map!=NULL) {
	    type= map->types;
	    for (i=0;(i<map->num_types)&&(i<rep->nTypes);i++,type++) {
		if (!_XkbReadBufferCopy32(&buf,(long *)&type->name,1))
		    goto BAILOUT;
		len-= 4;
	    }
	}
	if (len>0) 
	    _XkbSkipReadBufferData(&buf,len);
    }
    if ( rep->which&XkbKTLevelNamesMask ) {
	CARD8 *nLevels;
	XkbClientMapPtr	map= xkb->map;
	XkbKeyTypePtr	type;

	nLevels=(CARD8*)_XkbGetReadBufferPtr(&buf,XkbPaddedSize(rep->nTypes));
	if (nLevels==NULL)
	    goto BAILOUT;
	if (map!=NULL) {
	    type= map->types;
	    for (i=0;i<(int)rep->nTypes;i++,type++) {
		if (i>=map->num_types) {
		    _XkbSkipReadBufferData(&buf,nLevels[i]*4);
		    continue;
		}
		if ((nLevels[i]>0)&&(nLevels[i]!=type->group_width)) {
		    fprintf(stderr,"group_width in names doesn't match type\n");
		    goto BAILOUT;
		}
		if (type->lvl_names!=NULL)
		    Xfree(type->lvl_names);
		if (nLevels[i]==0) {
		    type->lvl_names= NULL;
		    continue;
		}
		type->lvl_names= (Atom *)Xmalloc(nLevels[i]*sizeof(Atom));
		if (type->lvl_names!=NULL) {
		    if (!_XkbReadBufferCopy32(&buf,(long *)type->lvl_names,
								nLevels[i]))
			goto BAILOUT;
		}
		else {
		    _XkbSkipReadBufferData(&buf,nLevels[i]*4);
		}
	    }
	}
	else {
	    for (i=0;i<(int)rep->nTypes;i++,type++) {
		_XkbSkipReadBufferData(&buf,nLevels[i]*4);
	    }
	}
    }
    if (rep->which & XkbIndicatorNamesMask) {
	if (!_XkbReadAtoms(&buf,names->indicators,XkbNumIndicators,
							rep->indicators))
	    goto BAILOUT;
    }
    if ( rep->which&XkbModifierNamesMask ) {
	if (!_XkbReadAtoms(&buf,names->mods,
			   XkbNumModifiers,(CARD32)rep->modifiers))
	    goto BAILOUT;
    }
    if ( rep->which&XkbVirtualModNamesMask ) {
	if (!_XkbReadAtoms(&buf,names->vmods,XkbNumVirtualMods,
						(CARD32)rep->virtualMods))
	    goto BAILOUT;
    }
    if ( rep->which&XkbKeyNamesMask ) {
	if (names->keys==NULL) {
	    int nKeys= xkb->max_key_code+1;
	    names->keys= (XkbKeyNamePtr)Xmalloc(nKeys*4);
	}
	if (names->keys!=NULL) {
	    if (!_XkbCopyFromReadBuffer(&buf,
					(char *)&names->keys[rep->firstKey],
					rep->nKeys*4))
		goto BAILOUT;
	}
	else _XkbSkipReadBufferData(&buf,rep->nKeys*4);
    }
    if ( rep->which&XkbRGNamesMask ) {
	if (rep->nRadioGroups>0) {
	    Atom *rgNames;

	    len= sizeof(Atom)*rep->nRadioGroups;
	    if (names->radio_groups==NULL)
		names->radio_groups = (Atom *)Xmalloc(len);
	    else if (names->num_rg<rep->nRadioGroups)
		names->radio_groups = (Atom *)Xrealloc(names->radio_groups,len);
	    rgNames= names->radio_groups;
	    if (!rgNames) {
		fprintf(stderr,"Couldn't allocate radio group names\n");
		goto BAILOUT;
	    }
	    if (!_XkbReadBufferCopy32(&buf,(long *)rgNames,rep->nRadioGroups))
		goto BAILOUT;
	    names->num_rg= rep->nRadioGroups;
	}
	else if (names->num_rg>0) {
	    names->num_rg= 0;
	    Xfree(names->radio_groups);
	}
    }
    if ( (rep->which&XkbCharSetsMask)&&(rep->nCharSets>0) ) {
	len= rep->nCharSets*sizeof(Atom);
	if (names->char_sets) {
	    if (names->num_char_sets<rep->nCharSets) {
		Xfree(names->char_sets);
		names->char_sets= NULL;
		names->num_char_sets= 0;
	    }
	}
	if (!names->char_sets) {
	    names->char_sets= (Atom *)Xmalloc(len);
	    if (!names->char_sets) {
		fprintf(stderr,"Couldn't allocate char set names\n");
		goto BAILOUT;
	    }
	    if (!_XkbReadBufferCopy32(&buf,
				      (long *)names->char_sets,rep->nCharSets))
		goto BAILOUT;
	    names->num_char_sets= rep->nCharSets;
	}
    }
    if (rep->which&XkbPhysicalNamesMask) {
	if (!_XkbReadBufferCopy32(&buf,(long *)&names->phys_symbols,1))
	    goto BAILOUT;
	if (!_XkbReadBufferCopy32(&buf,(long *)&names->phys_geometry,1))
	    goto BAILOUT;
    }
    len= _XkbFreeReadBuffer(&buf);
    if (len!=0) {
	fprintf(stderr,"Warning! Bad length (got %d, not %d) in XkbGetNames\n",
					rep->length-len,rep->length);
    }
    return True;
BAILOUT:
    _XkbFreeReadBuffer(&buf);
    return False;
}

Status
XkbGetNames(dpy,which,xkb)
    Display *	dpy;
    unsigned	which;
    XkbDescPtr	xkb;
{
    register xkbGetNamesReq *req;
    xkbGetNamesReply	     rep;
    Status		     ok;
    XkbInfoPtr xkbi;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    if (!xkb->names) {
	xkb->names = (XkbNamesRec *)Xmalloc(sizeof(XkbNamesRec));
	if (xkb->names)
	    bzero(xkb->names,sizeof(XkbNamesRec));
	else {
	    UnlockDisplay(dpy);
	    SyncHandle();
	    return False;
	}
    }
    GetReq(kbGetNames, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbGetNames;
    req->deviceSpec = xkb->device_spec;
    req->which = which;
    if (!_XReply(dpy, (xReply *)&rep, 0, xFalse)) {
	UnlockDisplay(dpy);
	SyncHandle();
	return False;
    }

    ok = _XkbReadGetNamesReply(dpy,&rep,xkb);
    UnlockDisplay(dpy);
    SyncHandle();
    return ok;
}

/***====================================================================***/

static CARD32
_XkbCountAtoms(atoms,maxAtoms,count)
    Atom *atoms;
    int   maxAtoms;
    int  *count;
{
register unsigned int i,bit,nAtoms;
register CARD32 atomsPresent;

    for (i=nAtoms=atomsPresent=0,bit=1;i<maxAtoms;i++,bit<<=1) {
        if (atoms[i]!=None) {
            atomsPresent|= bit;
            nAtoms++;
        }
    }
    if (count)
        *count= nAtoms;
    return atomsPresent;
}

static void
_XkbCopyAtoms(dpy,atoms,maxAtoms)
    Display *	dpy;
    Atom *	atoms;
    int   	maxAtoms;
{
register unsigned int i;

    for (i=0;i<maxAtoms;i++) {
        if (atoms[i]!=None)
	    Data32(dpy,&atoms[i],4);
    }
    return;
}

Status
XkbSetNames(dpy,which,firstType,nTypes,xkb)
    Display *	dpy;
    unsigned	which;
    unsigned	firstType;
    unsigned	nTypes;
    XkbDescPtr	xkb;
{
    register xkbSetNamesReq *req;
    int  nLvlNames;
    XkbInfoPtr xkbi;
    XkbNamesPtr names;
    int	nMods,nVMods,nLEDs,nRG,nCharSets;
    int nKeys,firstKey,nAtoms;

    if ((dpy->flags & XlibDisplayNoXkb) ||
	(!dpy->xkb_info && !XkbUseExtension(dpy)))
	return False;
    if ((!xkb)||(!xkb->names))
	return False;
    names= xkb->names;
    if (which&(XkbKTLevelNamesMask|XkbKeyTypeNamesMask)) {
	register int	i;
	XkbKeyTypePtr	type;
	if((xkb->map==NULL)||(xkb->map->types==NULL)||(nTypes==0)||
				(firstType+nTypes>xkb->map->num_types))
	    return False;
	if (which&XkbKTLevelNamesMask) {
	    type= &xkb->map->types[firstType];
	    for (i=nLvlNames=0;i<nTypes;i++,type++) {
		if (type->lvl_names[i]!=None)
		    nLvlNames+= type->group_width;
	    }
	}
    }
 
    nMods= nVMods= nLEDs= nRG= nCharSets= nAtoms= 0;
    LockDisplay(dpy);
    xkbi = dpy->xkb_info;
    GetReq(kbSetNames, req);
    req->reqType = xkbi->codes->major_opcode;
    req->xkbReqType = X_kbSetNames;
    req->deviceSpec = xkb->device_spec;
    req->firstType = firstType;
    req->nTypes = nTypes;
    req->firstKey = xkb->min_key_code;
    req->nKeys = xkb->max_key_code-xkb->min_key_code+1;

    if (which&XkbKeycodesNameMask)
	nAtoms++;
    if (which&XkbGeometryNameMask)
	nAtoms++;
    if (which&XkbSymbolsNameMask)
	nAtoms++;
    if (which&XkbSemanticsNameMask)
	nAtoms++;
    if (which&XkbKeyTypeNamesMask)
	nAtoms+= nTypes;
    if (which&XkbKTLevelNamesMask) {
	req->length+= XkbPaddedSize(nTypes)/4; /* room for group widths */
	nAtoms+= nLvlNames;
    }

    if (which&XkbIndicatorNamesMask) {
	req->indicators= 
		_XkbCountAtoms(names->indicators,XkbNumIndicators,&nLEDs);
	if (nLEDs>0)
	     nAtoms+= nLEDs;
	else which&= ~XkbIndicatorNamesMask;
    }
    else req->indicators= 0;

    if (which&XkbModifierNamesMask) {
	req->modifiers= _XkbCountAtoms(names->mods,XkbNumModifiers,&nMods);
	if (nMods>0)
	     nAtoms+= nMods;
	else which&= ~XkbModifierNamesMask;
    }
    else req->modifiers= 0;

    if (which&XkbVirtualModNamesMask) {
	req->virtualMods= 
		_XkbCountAtoms(names->vmods,XkbNumVirtualMods,&nVMods);
	if (nVMods>0)
	     nAtoms+= nVMods;
	else which&= ~XkbVirtualModNamesMask;
    }
    else req->virtualMods= 0;

    if ((which&XkbKeyNamesMask)&&(names->keys!=NULL)) {
	firstKey= req->firstKey;
	nKeys= req->nKeys;
	nAtoms+= nKeys;	/* technically not atoms, but 4 bytes wide */
    }
    else which&= ~XkbKeyNamesMask;

    if (which&XkbRGNamesMask) {
	nRG= names->num_rg;
	if (nRG>0)
	     nAtoms+= nRG;
	else which&= ~XkbRGNamesMask;
    }

    if (which&XkbCharSetsMask) {
	nCharSets= names->num_char_sets;
	if (nCharSets>0)
	     nAtoms+= nCharSets;
	else which&= ~XkbCharSetsMask;
    }
    if (which&XkbCharSetsMask)
	nAtoms+= 2;

    req->which= which;
    req->nRadioGroups= nRG;
    req->nCharSets= nCharSets;
    req->length+= (nAtoms*4)/4;

    if (which&XkbKeycodesNameMask)
	Data32(dpy,(long *)&names->keycodes,4);
    if (which&XkbGeometryNameMask)
	Data32(dpy,(long *)&names->geometry,4);
    if (which&XkbSymbolsNameMask)
	Data32(dpy,(long *)&names->symbols,4);
    if (which&XkbSemanticsNameMask)
	Data32(dpy,(long *)&names->semantics,4);
    if (which&XkbKeyTypeNamesMask) {
	register int 		i;
	register XkbKeyTypePtr	type;
	type= &xkb->map->types[firstType];
	for (i=0;i<xkb->map->num_types;i++,type++) {
	    Data32(dpy,(long *)&type->name,4);
	}
    }
    if (which&XkbKTLevelNamesMask) {
	XkbKeyTypePtr type;
	int i;
	char *tmp;

	BufAlloc(char *,tmp,XkbPaddedSize(nTypes));
	type = &xkb->map->types[firstType];
	for (i=0;i<nTypes;i++,type++) {
	    *tmp++ = type->group_width;
	}
	for (i=0;i<nTypes;i++,type++) {
	    if (type->lvl_names!=NULL)
		Data32(dpy,(long *)type->lvl_names,type->group_width*4);
	}
    }
    if (which&XkbIndicatorNamesMask)
	_XkbCopyAtoms(dpy,names->indicators,XkbNumIndicators);
    if (which&XkbModifierNamesMask)
	_XkbCopyAtoms(dpy,names->mods,XkbNumModifiers);
    if (which&XkbVirtualModNamesMask)
	_XkbCopyAtoms(dpy,names->vmods,XkbNumVirtualMods);
    if (which&XkbKeyNamesMask) {
#ifdef WORD64
	char *tmp;
	register int i;
	BufAlloc(char *,tmp,nKeys*4);
	for (i=0;i<nKeys;i++,tmp+= 4) {
	    tmp[0]= names->keys[firstKey+i].name[0];
	    tmp[1]= names->keys[firstKey+i].name[1];
	    tmp[2]= names->keys[firstKey+i].name[2];
	    tmp[3]= names->keys[firstKey+i].name[3];
	}
#else
	Data(dpy,(char *)&names->keys[firstKey],nKeys*4);
#endif
    }
    if (which&XkbRGNamesMask) {
	Data32(dpy,(long *)names->radio_groups,nRG*4);
    }
    if (which&XkbCharSetsMask) {
	Data32(dpy,(long *)names->char_sets,nCharSets*4);
    }
    if (which&XkbPhysicalNamesMask) {
	Data32(dpy,(long *)&names->phys_symbols,4);
	Data32(dpy,(long *)&names->phys_geometry,4);
    }
    UnlockDisplay(dpy);
    SyncHandle();
    return True;
}

/***====================================================================***/

Status
XkbFreeNames(xkb,all,which)
    XkbDescPtr	xkb;
    Bool	all;
    unsigned	which;
{
XkbNamesPtr	names;

    if ((xkb==NULL)||(xkb->names==NULL))
	return False;

    names= xkb->names;
    if (all)
	which= XkbAllNamesMask; 
    if (which&XkbKTLevelNamesMask) {
	XkbClientMapPtr	map= xkb->map;
	if ((map!=NULL)&&(map->types!=NULL)) {
	    register int 		i;
	    register XkbKeyTypePtr	type;
	    type= map->types;
	    for (i=0;i<map->num_types;i++,type++) {
		if (type->lvl_names!=NULL) {
		    Xfree(type->lvl_names);
		    type->lvl_names= NULL;
		}
	    }
	}
    }
    if ((which&XkbKeyNamesMask)&&(names->keys!=NULL)) {
	Xfree(names->keys);
	names->keys= NULL;
	names->num_keys= 0;
    }
    if ((which&XkbRGNamesMask)&&(names->radio_groups)) {
	Xfree(names->radio_groups);
	names->radio_groups= NULL;
	names->num_rg= 0;
    }
    if ((which&XkbCharSetsMask)&&(names->char_sets)) {
	Xfree(names->char_sets);
	names->char_sets= NULL;
	names->num_char_sets= 0;
    }
    if (all) {
	Xfree(names);
	xkb->names= NULL;
    }
    return True;
}

/***====================================================================***/

Status
XkbAllocNames(xkb,which)
    XkbDescPtr	xkb;
    unsigned	which;
{
XkbNamesPtr	names;

    if (xkb==NULL)
	return False;
    if (!xkb->names) {
	xkb->names = (XkbNamesRec *)Xmalloc(sizeof(XkbNamesRec));
	if (xkb->names==NULL)
	    return False;
	bzero(xkb->names,sizeof(XkbNamesRec));
    }
    names= xkb->names;
    if ((which&XkbKeyTypeNamesMask)&&
			((xkb->map==NULL)||(xkb->map->types==NULL))) {
	return False;
    }
    if (which&XkbKTLevelNamesMask) {
	register int	i;
	XkbKeyTypePtr	type;

	if ((xkb->map==NULL)||(xkb->map->types==NULL))
	    return False;
	type= xkb->map->types;
	for (i=0;i<xkb->map->num_types;i++,type++) {
	    if (type->lvl_names==NULL) {
		type->lvl_names=
				(Atom*)Xcalloc(type->group_width,sizeof(Atom));
		if (type->lvl_names==NULL)
		    return False;
	    }
	}
    }
    if (which&XkbKeyNamesMask) {
	int size;
	if ((xkb->min_key_code<1)||(xkb->max_key_code<1))
	    return False;
	size= (xkb->max_key_code+1)*sizeof(XkbKeyNameRec);
	names->keys= (XkbKeyNamePtr)Xmalloc(size);
	if (names->keys==NULL)
	    return False;
	bzero(names->keys,size);
    }
    /* 3/12/94 (ef) -- XXX! Handle XkbRGNamesMask */
    /* 3/12/94 (ef) -- XXX! Handle XkbCharSetsMask */
    return True;
}

