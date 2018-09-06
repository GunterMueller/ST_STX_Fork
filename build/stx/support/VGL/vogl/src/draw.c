#include "vogl.h"

#ifndef MULTI_X
static int	saveSync;
#endif

/*
 * draw
 *
 * draw a line form the logical graphics position to the
 * the world coordinates x, y, z.
 *
 */
void
draw(x, y, z)
	float		x, y, z;
{
	Token	*tok;
	int	vx, vy;
	Vector	res;


	if (!vdevice.initialised) {
		verror("draw: vogl not initialised");
		return;
	}

	if (vdevice.inobject) {
		tok = newtokens(4);

		tok[0].i = DRAW;
		tok[1].f = x;
		tok[2].f = y;
		tok[3].f = z;

		vdevice.cpW[V_X] = x;
		vdevice.cpW[V_Y] = y;
		vdevice.cpW[V_Z] = z;

		vdevice.cpVvalid = 0;

		return;
	}

	if (!vdevice.cpVvalid) {
		multvector(vdevice.cpWtrans, vdevice.cpW, vdevice.transmat->m);
	}

	vdevice.cpW[V_X] = x;
	vdevice.cpW[V_Y] = y;
	vdevice.cpW[V_Z] = z;
	multvector(res, vdevice.cpW, vdevice.transmat->m);

	if (vdevice.clipoff) {	
		vx = WtoVx(res);		/* just draw it */
		vy = WtoVy(res);
	 
		(*vdevice.dev.Vdraw)(vx, vy);

		vdevice.cpVx = vx;
		vdevice.cpVy = vy;

		vdevice.cpVvalid = 0;
	} else {
		if (vdevice.cpVvalid)
			quickclip(vdevice.cpWtrans, res);
		else
			clip(vdevice.cpWtrans, res);
	}

	vdevice.cpWtrans[V_X] = res[V_X];
	vdevice.cpWtrans[V_Y] = res[V_Y];
	vdevice.cpWtrans[V_Z] = res[V_Z];
	vdevice.cpWtrans[V_W] = res[V_W];
}

/*
 * draws
 *
 * draw a line form the logical graphics position to the
 * the world coordinates x, y, z expressed as a short integer data type.
 *
 */
void
draws(x, y, z)
	Scoord 	x, y, z;
{
	draw((Coord)x, (Coord)y, (Coord)z);
}


/*
 * drawi
 *
 * draw a line form the logical graphics position to the
 * the world coordinates x, y, z expressed as an integer data type.
 *
 */
void
drawi(x, y, z)
	Icoord 	x, y, z;
{
	draw((Coord)x, (Coord)y, (Coord)z);
}



/*
 * draw2
 *
 * draw a line from the logical graphics position  to the
 * the world coordinates x, y.
 *
 */
void
draw2(x, y)
	float		x, y;
{
#ifdef ORIGINAL
	if (!vdevice.initialised) {
		verror("draw2: vogl not initialised");
		return;
	}
#endif

	draw(x, y, 0.0);
}

/*
 * draw2s
 *
 * draw a line from the logical graphics position  to the
 * the world coordinates x, y expressed as a short integer data type.
 *
 */
void
draw2s(x, y)
	Scoord 	x, y;
{
	draw2((Coord)x, (Coord)y);
}


/*
 * draw2i
 *
 * draw a line from the logical graphics position  to the
 * the world coordinates x, y expressed as an integer data type.
 *
 */
void
draw2i(x, y)
	Icoord 	x, y;
{
	draw2((Coord)x, (Coord)y);
}

/*
 * rdr
 *
 * 3D relative draw from the logical graphics position by dx, dy, dz.
 * This is the same as the VOGLE routine rdraw.
 *
 */
void
rdr(dx, dy, dz)
	float		dx, dy, dz;
{
	if (!vdevice.initialised) {
		verror("rdr: vogl not initialised");
		return;
	}

	draw((vdevice.cpW[V_X] + dx), (vdevice.cpW[V_Y] + dy), (vdevice.cpW[V_Z] + dz));
}

/*
 * rdrs
 *
 * 3D relative draw from the logical graphics position by dx, dy, dz
 * expressed as a short integer data type.
 *
 */
void
rdrs(dx, dy, dz)
	Scoord	dx, dy, dz;
{
	rdr((Coord)dx, (Coord)dy, (Coord)dz);
}

/*
 * rdri
 *
 * 3D relative draw from the logical graphics position by dx, dy, dz
 * expressed as an integer data type.
 *
 */
void
rdri(dx, dy, dz)
	Icoord	dx, dy, dz;
{
	rdr((Coord)dx, (Coord)dy, (Coord)dz);
}


/*
 * rdr2
 *
 * 2D relative draw from the logical graphics position by dx, dy.
 * This is the same as the VOGLE routine rdraw2.
 *
 */
void
rdr2(dx, dy)
	float		dx, dy;
{
	if (!vdevice.initialised) {
		verror("rdr2: vogl not initialised");
		return;
	}

	draw((vdevice.cpW[V_X] + dx), (vdevice.cpW[V_Y] + dy), 0.0);
}


/*
 * rdr2s
 *
 * 3D relative draw from the logical graphics position by dx, dy
 * expressed as a short integer data type.
 *
 */
void
rdr2s(dx, dy)
	Scoord	dx, dy;
{
	rdr2((Coord)dx, (Coord)dy);
}

/*
 * rdr2i
 *
 * 3D relative draw from the logical graphics position by dx, dy
 * expressed as an integer data type.
 *
 */
void
rdr2i(dx, dy)
	Icoord	dx, dy;
{
	rdr2((Coord)dx, (Coord)dy);
}


/*
 * bgnline
 *
 * 	Flags that all v*() routine points will be building up a line list.
 */
void
bgnline()
{
	if (vdevice.bgnmode != NONE) {
		verror("vogl: bgnline already in some other bgn routine");
		return;
	}

	vdevice.bgnmode = VLINE;
	vdevice.save = 1;
	if (saveSync = vdevice.sync)
		vdevice.sync = 0;
}

/*
 * endline
 *
 * 	Flags that all v*() routine points will be simply setting the 
 * 	current position.
 */
void
endline()
{
#ifndef ORIGINAL
	if (vdevice.bgnmode != VLINE) {
	    vwarning("vogl: endline, without bgnline (%d)", vdevice.bgnmode);
	    if (vdevice.bgnmode == NONE) {
		return;
	    }
	}
#endif
	vdevice.bgnmode = NONE;
	vdevice.save = 0;
	if (saveSync) {
		vdevice.sync = 1;
		(*vdevice.dev.Vsync)();
	}
}

/*
 * bgnclosedline
 *
 * 	Flags that all v*() routine points will be building up a line list.
 */
void
bgnclosedline()
{
	if (vdevice.bgnmode != NONE) {
		verror("vogl: bgncloseline already in some other bgn routine");
		return;
	}

	vdevice.bgnmode = VCLINE;
	vdevice.save = 1;
	if (saveSync = vdevice.sync)
	    vdevice.sync = 0;
}

/*
 * endclosedline
 *
 * 	Flags that all v*() routine points will be simply setting the 
 * 	current position.
 */
void
endclosedline()
{
#ifndef ORIGINAL
	if (vdevice.bgnmode != VCLINE) {
	    vwarning("vogl: endclosedline, without bgnclosedline (%d)",
			    vdevice.bgnmode);
	    if (vdevice.bgnmode == NONE) {
		return;
	    }
	}
#endif
	vdevice.bgnmode = NONE;
	if (saveSync)
	    vdevice.sync = 1;
	draw(vdevice.savex, vdevice.savey, vdevice.savez);
}
