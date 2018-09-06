#include <stdio.h>
#include "vogl.h"

#ifndef MULTI_X
static	Astack	*asfree = (Astack *)NULL;
#endif

/*
 * copyattributes
 *
 *	Copies attribute stack entries from b to a
 */
static	void
copyattributes(a, b)
	Attribute	*a, *b;
{
	a->color = b->color;
	a->fontwidth = b->fontwidth;
	a->fontheight = b->fontheight;
	a->fontnum = b->fontnum;
#ifndef ORIGINAL
	a->ls = b->ls;
	a->lw = b->lw;
	a->backface = b->backface;
#endif
}

/*
 * pushattributes
 *
 * save the current attributes on the matrix stack
 *
 */
void
pushattributes()
{
	Astack	*nattr;
	Token	*p;

	if (!vdevice.initialised) {
		verror("pushattributes:  vogl not initialised");
		return;
	}
	
	if (vdevice.inobject) {
		p = newtokens(1);

		p[0].i = PUSHATTRIBUTES;

		return;
	}

	if (asfree != (Astack *)NULL) {
		nattr = vdevice.attr;
		vdevice.attr = asfree;
		asfree = asfree->back;
		vdevice.attr->back = nattr;
		copyattributes(&vdevice.attr->a, &nattr->a);
	} else {	
		nattr = (Astack *)vallocate(sizeof(Astack));
		nattr->back = vdevice.attr;
		copyattributes(&nattr->a, &vdevice.attr->a);
		vdevice.attr = nattr;
	}
}

/*
 * popattributes
 *
 * pop the top entry on the attribute stack 
 *
 */
void
popattributes()
{
	Astack	*nattr;
	Token	*p;

	if (!vdevice.initialised) {
		verror("popattributes: vogl not initialised");
		return;
	}
	
	if (vdevice.inobject) {
		p = newtokens(1);

		p[0].i = POPATTRIBUTES;

		return;
	}

	if (vdevice.attr->back == (Astack *)NULL) {
		verror("popattributes: attribute stack is empty");
		return;
	} else {
		font(vdevice.attr->back->a.fontnum);
		nattr = vdevice.attr;
		vdevice.attr = vdevice.attr->back;
		nattr->back = asfree;
		asfree = nattr;
	}

#ifndef ORIGINAL
	(*vdevice.dev.Vsetls)(vdevice.attr->a.ls);
	(*vdevice.dev.Vsetlw)(vdevice.attr->a.lw);
#endif
	color(vdevice.attr->a.color);
}

#ifdef	DEBUG

printattribs(s)
	char	*s;
{
	printf("%s\n", s);
	printf("clipoff    = %d\n", vdevice.clipoff);
	printf("color      = %d\n", vdevice.attr->a.color);
	printf("textcos    = %f\n", vdevice.attr->a.textcos);
	printf("textsin    = %f\n", vdevice.attr->a.textsin);
	printf("fontwidth  = %f\n", vdevice.attr->a.fontwidth);
	printf("fontwidth  = %f\n", vdevice.attr->a.fontheight);
	printf("fontnum    = %d\n", vdevice.attr->a.fontnum);
	printf("mode       = %d\n", vdevice.attr->a.mode);
}

#endif
