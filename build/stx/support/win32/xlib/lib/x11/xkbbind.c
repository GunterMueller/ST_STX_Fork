/* $XConsortium: XKBBind.c,v 1.8 94/04/17 20:21:34 erik Exp $ */
/*

Copyright (c) 1985, 1987, 1994  X Consortium

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE X CONSORTIUM BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of the X Consortium shall
not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization
from the X Consortium.

*/

/* Beware, here be monsters (still under construction... - JG */

#define NEED_EVENTS
#include <X11/Xlibint.h>
#include <X11/Xutil.h>
#include <X11/keysym.h>
#include <stdio.h>
#include <ctype.h>
#include <locale.h>

#include <X11/extensions/XKBproto.h>
#include "XKBlibint.h"

#if defined(__sgi) && defined(USE_OWN_COMPOSE)
#define	COMPOSE_NO_CONST_MEMBERS
#include "Compose.h"
#endif

#define AllMods (ShiftMask|LockMask|ControlMask| \
		 Mod1Mask|Mod2Mask|Mod3Mask|Mod4Mask|Mod5Mask)

#define Is_KP_Keysym(k) ((((k) >= XK_KP_0) && ((k) <= XK_KP_9)) || \
			 ((k) == XK_KP_Decimal) || ((k)==XK_KP_Separator))

static int _XkbLoadDpy();

struct _XKeytrans {
	struct _XKeytrans *next;/* next on list */
	char *string;		/* string to return when the time comes */
	int len;		/* length of string (since NULL is legit)*/
	KeySym key;		/* keysym rebound */
	unsigned int state;	/* modifier state */
	KeySym *modifiers;	/* modifier keysyms you want */
	int mlen;		/* length of modifier list */
};

#define	XKB_UNAVAILABLE(d) \
    (((d)->flags&XlibDisplayNoXkb) ||\
     ((!(d)->xkb_info || (!(d)->xkb_info->desc)) && !_XkbLoadDpy(d)))

#define	CHECK_PENDING_REFRESH(d) {\
    if ((d)->xkb_info->flags&XkbMapPending) {\
	if (XkbRefreshMap(dpy,(d)->xkb_info->desc, &dpy->xkb_info->changes)) {\
	    LockDisplay(dpy);\
	    dpy->xkb_info->changes.changed= 0;\
	    UnlockDisplay(dpy);\
	}\
    }\
}

#if NeedFunctionPrototypes
KeySym
XKeycodeToKeysym(Display *dpy,
#if NeedWidePrototypes
		 unsigned int kc,
#else
		 KeyCode kc,
#endif
		 int col)
#else
KeySym
XKeycodeToKeysym(dpy, kc, col)
    Display *dpy;
    KeyCode kc;
    int col;
#endif
{
    int	offset;
    XkbDescRec	*xkb;
    
    if (XKB_UNAVAILABLE(dpy))
	return _XKeycodeToKeysym(dpy,kc,col);

    CHECK_PENDING_REFRESH(dpy);

    xkb = dpy->xkb_info->desc;
    if ((kc<xkb->min_key_code)||(kc>xkb->max_key_code))
	return NoSymbol;

    if (( col<0 ) || (col>=(int)XkbKeyNumSyms(xkb,kc)))
	return NoSymbol;
    
    return XkbKeySym(xkb,kc,col);
}

KeyCode
XKeysymToKeycode(dpy, ks)
    Display *dpy;
    KeySym ks;
{
    register int i, j, gotOne;

    if (XKB_UNAVAILABLE(dpy))
	return _XKeysymToKeycode(dpy,ks);
    CHECK_PENDING_REFRESH(dpy);

    j= 0;
    do {
	register XkbDescRec *xkb = dpy->xkb_info->desc;
	gotOne= 0;
	for (i = dpy->min_keycode; i <= dpy->max_keycode; i++) {
	    if ( j<(int)XkbKeyNumSyms(xkb,i) ) {
		gotOne = 1;
		if ((XkbKeySym(xkb,i,j)==ks))
		    return i;
	    }
	}
	j++;
    } while (gotOne);
    return 0;
}

static int
_XkbComputeModmap(dpy)
    Display *dpy;
{
XModifierKeymap	*modmap;

    if (!dpy->xkb_info)		return 0;
    if (dpy->xkb_info->modmap)	return 1;
    dpy->xkb_info->modmap= (char *)Xmalloc(dpy->xkb_info->desc->max_key_code+1);
    if (!dpy->xkb_info->modmap)	return 0;
    bzero(dpy->xkb_info->modmap,dpy->xkb_info->desc->max_key_code+1);
    modmap = XGetModifierMapping(dpy);
    if (modmap) {
	register int m,k;
	KeyCode *map;
	map= modmap->modifiermap;
	for (m=0;m<8;m++) {
	    for (k=0;k<modmap->max_keypermod;k++,map++) {
		if (((*map)>=dpy->xkb_info->desc->min_key_code)&&
		    ((*map)<=dpy->xkb_info->desc->max_key_code)) {
		    dpy->xkb_info->modmap[*map]|= (1<<m);
		}
	    }
	}
	XFreeModifiermap(modmap);
	return 1;
    }
    return 0;
}

unsigned
XkbKeysymToModifiers(dpy,ks)
    Display *dpy;
    KeySym ks;
{
    XkbDescRec *xkb;
    register int i,j;
    register KeySym *pSyms;
    CARD8 mods;

    if (XKB_UNAVAILABLE(dpy))
	return _XKeysymToModifiers(dpy,ks);
    CHECK_PENDING_REFRESH(dpy);

    if ((!dpy->xkb_info->modmap)&&(!_XkbComputeModmap(dpy)))
	return _XKeysymToModifiers(dpy,ks);

    xkb= dpy->xkb_info->desc;
    mods= 0;
    for (i = xkb->min_key_code; i <= (int)xkb->max_key_code; i++) {
	pSyms= XkbKeySymsPtr(xkb,i);
	for (j=XkbKeyNumSyms(xkb,i)-1;j>=0;j--) {
	    if (pSyms[j]==ks) {
		mods|= dpy->xkb_info->modmap[i];
		break;
	    }
	}
    }
    return mods;
}

KeySym
XLookupKeysym(event, col)
    register XKeyEvent *event;
    int col;
{
    Display *dpy = event->display;
    if (XKB_UNAVAILABLE(dpy))
	return _XLookupKeysym(event, col);
    CHECK_PENDING_REFRESH(dpy);
    return XKeycodeToKeysym(dpy, event->keycode, col);
}

#define	XkbModifiersGroup(m)	(((m)>>13)&0x7)

int
XkbTranslateKey(dpy, keycode, modifiers, modifiers_return, keysym_return)
    register Display *dpy;
    KeyCode keycode;
    register unsigned int modifiers;
    unsigned int *modifiers_return;
    KeySym *keysym_return;
{
    register XkbInfoPtr xkb;
    XkbKeyTypeRec *type;
    int col;
    unsigned preserve;
    KeySym *syms;

    if (XKB_UNAVAILABLE(dpy))
	return _XTranslateKey(dpy,keycode,modifiers,
						modifiers_return,keysym_return);
    CHECK_PENDING_REFRESH(dpy);

    if (modifiers_return!=NULL)
	*modifiers_return = modifiers;
    if (((int)keycode < dpy->min_keycode) || ((int)keycode > dpy->max_keycode))
    {
	if (keysym_return!=NULL)
	    *keysym_return = NoSymbol;
	return 0;
    }

    xkb= dpy->xkb_info;

    /* find the row */
    syms = XkbKeySymsPtr(xkb->desc,keycode);

    /* find the offset of the effective group */
    col = 0;
    type = XkbKeyKeyType(xkb->desc,keycode);
    if ( XkbModifiersGroup(modifiers)!=0 ) {
	unsigned effectiveGroup = XkbModifiersGroup(modifiers);
	if ( effectiveGroup >= XkbKeyNumGroups(xkb->desc,keycode) ) {
	    if ( XkbKeyGroupsWrap(xkb->desc,keycode) )
		 effectiveGroup %= XkbKeyNumGroups(xkb->desc,keycode);
	    else effectiveGroup = XkbKeyNumGroups(xkb->desc,keycode)-1;
	}
	col= effectiveGroup*type->group_width;
    }

    preserve= 0;
    if (type->map) { /* find the column (shift level) within the group */
	register int i;
	register XkbKTMapEntryPtr entry;
	for (i=0,entry=type->map;i<type->map_count;i++,entry++) {
	    if ((entry->active)&&((modifiers&type->mask)==entry->mask)) {
		col+= entry->level;
		if (type->preserve)
		    preserve= type->preserve[i].mask;
		break;
	    }
	}
    }

    if (keysym_return!=NULL)
	*keysym_return= syms[col];
    if (modifiers_return)
	*modifiers_return&= ~(type->mask&(~preserve));
    return (syms[col]!=NoSymbol);
}

XRefreshKeyboardMapping(event)
    register XMappingEvent *event;
{
    XkbAnyEvent	*xkbevent = (XkbAnyEvent *)event;
    Display *dpy = event->display;
    XkbMapChangesRec changes;
    XkbInfoPtr xkbi;
    int	modsChanged;

    if (XKB_UNAVAILABLE(dpy))
	return _XRefreshKeyboardMapping(event);

    xkbi = dpy->xkb_info;

    if ((xkbi->flags&XkbMapPending)||(event->request==MappingKeyboard)) {
	if (xkbi->flags&XkbMapPending) {
	    changes= xkbi->changes;
	    XkbNoteCoreMapChanges(&changes,event,XKB_XLIB_MAP_MASK);
	}
	else {
	    bzero(&changes,sizeof(changes));
	    changes.changed= XkbKeySymsMask;
	    if (xkbi->desc->min_key_code<xkbi->desc->max_key_code) {
		changes.first_key_sym= xkbi->desc->min_key_code;
		changes.num_key_syms= xkbi->desc->max_key_code-
						xkbi->desc->min_key_code+1;
	    }
	    else {
		changes.first_key_sym= event->first_keycode;
		changes.num_key_syms= event->count;
	    }
	}

	if (!XkbRefreshMap(dpy,xkbi->desc, &changes)){
		fprintf(stderr,"Internal Error! XkbRefreshMap failed:\n");
#ifdef DEBUG
		if (changes.changed&XkbKeyTypesMask) {
		    int first= changes.first_type;
		    int last= changes.first_type+changes.num_types-1;
		    fprintf(stderr,"       types:  %d..%d\n",first,last);
		}
		if (changes.changed&XkbKeySymsMask) {
		    int first= changes.first_key_sym;
		    int last= changes.first_key_sym+changes.num_key_syms-1;
		    fprintf(stderr,"     symbols:  %d..%d\n",first,last);
		}
		if (changes.changed&XkbKeyActionsMask) {
		    int last,first= changes.first_key_act;
		    last= changes.first_key_act+changes.num_key_acts-1;
		    fprintf(stderr,"     acts:  %d..%d\n",first,last);
		}
		if (changes.changed&XkbKeyBehaviorsMask) {
		    int last,first= changes.first_key_behavior;
		    last= first+changes.num_key_behaviors-1;
		    fprintf(stderr,"   behaviors:  %d..%d\n",first,last);
		}
		if (changes.changed&XkbVirtualModsMask) {
		    fprintf(stderr,"virtual mods: 0x%04x\n",
					changes.vmods);
		}
		if (changes.changed&XkbExplicitComponentsMask) {
		    int last,first= changes.first_key_explicit;
		    last= first+changes.num_key_explicit-1;
		    fprintf(stderr,"    explicit:  %d..%d\n",first,last);
		}
#endif
	}
	LockDisplay(dpy);
	if (xkbi->flags&XkbMapPending) {
	    xkbi->flags&= ~XkbMapPending;
	    bzero(&xkbi->changes,sizeof(XkbMapChangesRec));
	}
	UnlockDisplay(dpy);
    }
    if (event->request==MappingModifier) {
	if (xkbi->modmap) {
	    Xfree(xkbi->modmap);
	    xkbi->modmap= NULL;
	}
	if (dpy->key_bindings) {
	    register struct _XKeytrans *p;
	    for (p = dpy->key_bindings; p; p = p->next) {
		register int i;
		p->state = AnyModifier;
		for (i = 0; i < p->mlen; i++) {
		    p->state|= XkbKeysymToModifiers(dpy,p->modifiers[i]);
		}
		p->state &= AllMods;
	    }
	}
	UnlockDisplay(dpy);
    }
    return;
}

static int
_XkbLoadDpy(dpy)
    Display *dpy;
{
    XkbInfoPtr xkbi;
    unsigned query,oldEvents;
    XkbDescRec *desc;

    if (!XkbUseExtension(dpy))
	return 0;

    xkbi = dpy->xkb_info;
    query = XkbFullClientInfoMask;
    desc = XkbGetMap(dpy,query,XkbUseCoreKbd);
    if (!desc) {
#ifdef DEBUG
	fprintf(stderr,"Warning! XkbGetMap failed!\n");
#endif
	return 0;
    }
    LockDisplay(dpy);
    xkbi->desc = desc;

    xkbi->charset = _XkbGetCharset(NULL);
    _XkbGetConverters(xkbi->charset,&xkbi->cvt);
    UnlockDisplay(dpy);
    oldEvents= xkbi->selected_events;
    XkbSelectEventDetails(dpy,xkbi->desc->device_spec,XkbMapNotify,
				XkbAllMapComponentsMask,XkbFullClientInfoMask);
    LockDisplay(dpy);
    xkbi->selected_events= oldEvents;
    UnlockDisplay(dpy);
}

int
XkbTranslateKeySym(dpy, sym_return, modifiers, buffer, nbytes)
    Display *dpy;
    register KeySym *sym_return;
    unsigned int modifiers;
    char *buffer;
    int nbytes;
{
    char tmp[4];
    register XkbInfoPtr xkb;
    register struct _XKeytrans *p; 
    int n;

    if (XKB_UNAVAILABLE(dpy))
	return _XTranslateKeySym(dpy,*sym_return,modifiers,buffer,nbytes);
    CHECK_PENDING_REFRESH(dpy);

    if ((buffer==NULL)||(nbytes==0)) {
	buffer= tmp;
	nbytes= 4;
    }

    xkb = dpy->xkb_info;
    /* see if symbol rebound, if so, return that string. */
    for (p = dpy->key_bindings; p; p = p->next) {
	if (((modifiers & AllMods) == p->state) && (*sym_return == p->key)) {
	    int tmp = p->len;
	    if (tmp > nbytes) tmp = nbytes;
	    memcpy (buffer, p->string, tmp);
	    return tmp;
	}
    }

    if ( nbytes>0 )
	buffer[0]= '\0';

    if ( xkb->cvt.KSToUpper && (modifiers&LockMask) ) {
	*sym_return = (*xkb->cvt.KSToUpper)(*sym_return);
    }
    n = (*xkb->cvt.KSToMB)(xkb->cvt.KSToMBPriv,*sym_return,buffer,nbytes,NULL);

    if ((!xkb->cvt.KSToUpper)&&( modifiers&LockMask )) {
	register int i;

	if (!xkb->cvt.KSToUpper) {
	    int change;
	    char ch;
	    for (i=change=0;i<n;i++) {
		ch= toupper(buffer[i]);
		change= (change||(buffer[i]!=ch));
		buffer[i] = ch;
	    }
	    if (change) {
		if (n==1)
		     *sym_return=(*xkb->cvt.MBToKS)(xkb->cvt.MBToKSPriv,
								buffer,n,0);
		else *sym_return= NoSymbol;
	    }
	}
    }

    if ( modifiers&ControlMask ) {
	if ( n==1 ) {
	    register char c = buffer[0];

	    if ((c >= '@' && c < '\177') || c == ' ') c &= 0x1F;
	    else if (c == '2') c = '\000';
	    else if (c >= '3' && c <= '7') c -= ('3' - '\033');
	    else if (c == '8') c = '\177';
	    else if (c == '/') c = '_' & 0x1F;

	    buffer[0]= c;
	    if ( nbytes>1 )
		buffer[1]= '\0';
	    return 1;
	}
	if ( nbytes > 0 )
	    buffer[0]= '\0';
	return 0;
    }
    return n;
}

int
XLookupString (event, buffer, nbytes, keysym, status)
    register XKeyEvent *event;
    char *buffer;	/* buffer */
    int nbytes;	/* space in buffer for characters */
    KeySym *keysym;
    XComposeStatus *status;
{
    KeySym	dummy;
    int rtrnLen;
    unsigned int new_mods;
    Display *dpy = event->display;

    if (XKB_UNAVAILABLE(dpy))
	return _XLookupString(event, buffer, nbytes, keysym, status);
    CHECK_PENDING_REFRESH(dpy);

    if (keysym==NULL)
	keysym= &dummy;

    if (!XkbTranslateKey(dpy,event->keycode,event->state, &new_mods,keysym))
	return 0;

#if defined(__sgi) && defined(USE_OWN_COMPOSE)
    if ( status ) {
	static int been_here= 0;
	if ( !been_here ) {
	    ComposeInitTables();
	    been_here = 1;
	}
	if ( !ComposeLegalStatus(status) ) {
	    status->compose_ptr = NULL;
	    status->chars_matched = 0;
	}
	if ( ((status->chars_matched>0)&&(status->compose_ptr!=NULL)) || 
		IsComposeKey(*keysym,event->keycode,status) ) {
	    ComposeRtrn rtrn;
	    switch (ComposeProcessSym(status,*keysym,&rtrn)) {
		case COMPOSE_IGNORE:
		    break;
		case COMPOSE_IN_PROGRESS:
		    if ( keysym!=NULL )
			*keysym = NoSymbol;
		    return 0;
		case COMPOSE_FAIL:
		{
		    int n = 0, len= 0;
		    for (n=len=0;rtrn.sym[n]!=XK_VoidSymbol;n++) {
			if ( nbytes-len > 0 ) {
			    len+= _XTranslateKeySym(event->display,&rtrn.sym[n],
							new_mods,
							buffer+len,nbytes-len);
			}
		    }
		    if ( keysym!=NULL ) {
			if ( n==1 )	*keysym = rtrn.sym[0];
			else		*keysym = NoSymbol;
		    }
		    return len;
		}
		case COMPOSE_SUCCEED:
		{
		    int len,n = 0;

		    *keysym = rtrn.matchSym;
		    if ( rtrn.str[0]!='\0' ) {
			strncpy(buffer,rtrn.str,nbytes-1);
			buffer[nbytes-1]= '\0';
			len = strlen(buffer);
		    }
		    else {
			len = XkbTranslateKeySym(event->display,keysym,
							new_mods,
							buffer,nbytes);
		    }
		    for (n=0;rtrn.sym[n]!=XK_VoidSymbol;n++) {
			if ( nbytes-len > 0 ) {
			    len+= _XTranslateKeySym(event->display,rtrn.sym[n],
							event->state,
							buffer+len,nbytes-len);
			}
		    }
		    return len;
		}
	    }
	}
    }
#endif

    rtrnLen = XkbTranslateKeySym(dpy,keysym,new_mods,buffer,nbytes);
    return rtrnLen;
}


int
XkbLookupKeyBinding(dpy, sym_return, modifiers, buffer, nbytes)
    Display *dpy;
    register KeySym *sym_return;
    unsigned int modifiers;
    char *buffer;
    int nbytes;
{
    char tmp[4];
    register struct _XKeytrans *p; 
    int n;

    for (p = dpy->key_bindings; p; p = p->next) {
	if (((modifiers & AllMods) == p->state) && (*sym_return == p->key)) {
	    int tmp = p->len;
	    if (tmp > nbytes) tmp = nbytes;
	    memcpy (buffer, p->string, tmp);
	    if (tmp < nbytes)	buffer[tmp]= '\0';
	    return tmp;
	}
    }
    return 0;
}

char
XkbToControl( c )
    char c;
{
    if ((c >= '@' && c < '\177') || c == ' ') c &= 0x1F;
    else if (c == '2') c = '\000';
    else if (c >= '3' && c <= '7') c -= ('3' - '\033');
    else if (c == '8') c = '\177';
    else if (c == '/') c = '_' & 0x1F;
    return c;
}
