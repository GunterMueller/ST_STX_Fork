
#include <stdio.h>
#include "vogl.h"

#ifndef MULTI_X
static	Mstack	*msfree = (Mstack *)NULL;
#endif

void	_mapmsave();

/*
 * copyvector
 *
 * Copy the 4 vector b to a.
 *
 */
void
copyvector(a, b)
	register	Vector	a, b;
{
	a[0] = b[0];
	a[1] = b[1];
	a[2] = b[2];
	a[3] = b[3];
}

/*
 * copymatrix
 *
 * Copy the  4 x 4 matrix b to the 4 x 4 matrix a
 *
 */
void
copymatrix(a, b)
	register	Matrix	a, b;
{
	register int	i;
	register float	*pa, *pb;
	pa = (float *)a;
	pb = (float *)b;

#ifdef ORIGINAL
	for(i = 0; i < 16; i++)
		*(pa++) = *(pb++);
#else
	pa[0] = pb[0];
	pa[1] = pb[1];
	pa[2] = pb[2];
	pa[3] = pb[3];
	pa[4] = pb[4];
	pa[5] = pb[5];
	pa[6] = pb[6];
	pa[7] = pb[7];
	pa[8] = pb[8];
	pa[9] = pb[9];
	pa[10] = pb[10];
	pa[11] = pb[11];
	pa[12] = pb[12];
	pa[13] = pb[13];
	pa[14] = pb[14];
	pa[15] = pb[15];
#endif
}

#ifndef ORIGINAL

/*
 * software pipelined copy loop
 */
#define copymatrix(pa,pb) \
    { \
	float f0, f1;   \
			\
	f0 = ((float *)pb)[0]; \
	f1 = ((float *)pb)[1]; \
	((float *)pa)[0] = f0; \
	f0 = ((float *)pb)[2]; \
	((float *)pa)[1] = f1; \
	f1 = ((float *)pb)[3]; \
	((float *)pa)[2] = f0; \
	f0 = ((float *)pb)[4]; \
	((float *)pa)[3] = f1; \
	f1 = ((float *)pb)[5]; \
	((float *)pa)[4] = f0; \
	f0 = ((float *)pb)[6]; \
	((float *)pa)[5] = f1; \
	f1 = ((float *)pb)[7]; \
	((float *)pa)[6] = f0; \
	f0 = ((float *)pb)[8]; \
	((float *)pa)[7] = f1; \
	f1 = ((float *)pb)[9]; \
	((float *)pa)[8] = f0; \
	f0 = ((float *)pb)[10]; \
	((float *)pa)[9] = f1; \
	f1 = ((float *)pb)[11]; \
	((float *)pa)[10] = f0; \
	f0 = ((float *)pb)[12]; \
	((float *)pa)[11] = f1; \
	f1 = ((float *)pb)[13]; \
	((float *)pa)[12] = f0; \
	f0 = ((float *)pb)[14]; \
	((float *)pa)[13] = f1; \
	f1 = ((float *)pb)[15]; \
	((float *)pa)[14] = f0; \
	((float *)pa)[15] = f1; \
    }

#endif

/*
 * copytranspose
 *
 *	copy the transpose of the 4 x 4 matrix b to the 4 x 4 matrix a.
 */
void
copytranspose(a, b)
	register Matrix	a, b;
{
#ifdef ORIGINAL
	register int	i, j;

	for(i = 0; i < 4; i++)
		for(j = 0; j < 4; j++)
			a[i][j] = b[j][i];
#else
	a[0][0] = b[0][0];
	a[0][1] = b[1][0];
	a[0][2] = b[2][0];
	a[0][3] = b[3][0];

	a[1][0] = b[0][1];
	a[1][1] = b[1][1];
	a[1][2] = b[2][1];
	a[1][3] = b[3][1];

	a[2][0] = b[0][2];
	a[2][1] = b[1][2];
	a[2][2] = b[2][2];
	a[2][3] = b[3][2];

	a[3][0] = b[0][3];
	a[3][1] = b[1][3];
	a[3][2] = b[2][3];
	a[3][3] = b[3][3];
#endif
}

/*
 * Retreive the top matrix on the stack and place it in m
 */
void
getmatrix(m)
	Matrix m;
{
	copymatrix(m, vdevice.transmat->m);
}

/*
 * pushmatrix
 *
 * Push the top matrix of the stack down, placing a copy
 * of it on the top of the stack.
 *
 */
void
pushmatrix()
{
	Mstack	*tmpmat;
	Token	*p;

	if (vdevice.inobject) {
		p = newtokens(1);

		p->i = PUSHMATRIX;

		return;
	}

	if (msfree != (Mstack *)NULL) {
		tmpmat = vdevice.transmat;
		vdevice.transmat = msfree;
		msfree = msfree->back;
		vdevice.transmat->back = tmpmat;
		copymatrix(vdevice.transmat->m, tmpmat->m);
	} else {
		tmpmat = (Mstack *)vallocate(sizeof(Mstack));
		tmpmat->back = vdevice.transmat;
		copymatrix(tmpmat->m, vdevice.transmat->m);
		vdevice.transmat = tmpmat;
	}
}

/*
 * popmatrix
 *
 * Pop the top matrix from the stack.
 *
 */
void
popmatrix()
{
	Token	*p;
	Mstack	*oldtop;

	if (vdevice.inobject) {
		p = newtokens(1);

		p->i = POPMATRIX;

		return;
	}

	if (vdevice.transmat->back == (Mstack *)NULL)
		verror("popmatrix: matrix stack empty");
	else {
		oldtop = vdevice.transmat;
		vdevice.transmat = vdevice.transmat->back;
		oldtop->back = msfree;
		msfree = oldtop;
	}

	vdevice.cpVvalid = 0;	/* may have changed mapping from world to device coords */
}

/*
 * loadmatrix
 *
 * Replace the top matrix on the stack
 *
 */
void
loadmatrix(mat)
	Matrix	mat;
{
	register int	i;
	register float	*cm, *mp;
	Token		*p;

	if (!vdevice.initialised) {
		verror("loadmatrix: vogl not initialised");
		return;
	}

	if (vdevice.inobject) {
		p = newtokens(17);

		p[0].i = LOADMATRIX;
		cm = (float *)mat;
		for (i = 0; i < 16; i++)
			(++p)->f = *cm++;

		return;
	}

	cm = (float *)vdevice.transmat->m;
	mp = (float *)mat;
#ifdef ORIGINAL
	for (i = 0; i < 16; i++)
		*cm++ = *mp++;
#else
	cm[0] = mp[0];
	cm[1] = mp[1];
	cm[2] = mp[2];
	cm[3] = mp[3];
	cm[4] = mp[4];
	cm[5] = mp[5];
	cm[6] = mp[6];
	cm[7] = mp[7];
	cm[8] = mp[8];
	cm[9] = mp[9];
	cm[10] = mp[10];
	cm[11] = mp[11];
	cm[12] = mp[12];
	cm[13] = mp[13];
	cm[14] = mp[14];
	cm[15] = mp[15];
#endif

	/*
	 * Save the untransformed matrix for the reverse mapping.
	 */

	_mapmsave(mat);

	vdevice.cpVvalid = 0;		/* may have changed mapping from world to device coords */
}

/*
 * mult4x4
 *
 *	multiply 4 x 4 matrices b and c assigning them into a. Readers are
 * reminded that speed can be important here.
 *
 */
void
mult4x4(a, b, c)
	register Matrix	a, b, c;
{
#ifdef ORIGINAL
	a[0][0] = b[0][0] * c[0][0] + b[0][1] * c[1][0] + b[0][2] * c[2][0] + b[0][3] * c[3][0];
	a[0][1] = b[0][0] * c[0][1] + b[0][1] * c[1][1] + b[0][2] * c[2][1] + b[0][3] * c[3][1];
	a[0][2] = b[0][0] * c[0][2] + b[0][1] * c[1][2] + b[0][2] * c[2][2] + b[0][3] * c[3][2];
	a[0][3] = b[0][0] * c[0][3] + b[0][1] * c[1][3] + b[0][2] * c[2][3] + b[0][3] * c[3][3];

	a[1][0] = b[1][0] * c[0][0] + b[1][1] * c[1][0] + b[1][2] * c[2][0] + b[1][3] * c[3][0];
	a[1][1] = b[1][0] * c[0][1] + b[1][1] * c[1][1] + b[1][2] * c[2][1] + b[1][3] * c[3][1];
	a[1][2] = b[1][0] * c[0][2] + b[1][1] * c[1][2] + b[1][2] * c[2][2] + b[1][3] * c[3][2];
	a[1][3] = b[1][0] * c[0][3] + b[1][1] * c[1][3] + b[1][2] * c[2][3] + b[1][3] * c[3][3];

	a[2][0] = b[2][0] * c[0][0] + b[2][1] * c[1][0] + b[2][2] * c[2][0] + b[2][3] * c[3][0];
	a[2][1] = b[2][0] * c[0][1] + b[2][1] * c[1][1] + b[2][2] * c[2][1] + b[2][3] * c[3][1];
	a[2][2] = b[2][0] * c[0][2] + b[2][1] * c[1][2] + b[2][2] * c[2][2] + b[2][3] * c[3][2];
	a[2][3] = b[2][0] * c[0][3] + b[2][1] * c[1][3] + b[2][2] * c[2][3] + b[2][3] * c[3][3];

	a[3][0] = b[3][0] * c[0][0] + b[3][1] * c[1][0] + b[3][2] * c[2][0] + b[3][3] * c[3][0];
	a[3][1] = b[3][0] * c[0][1] + b[3][1] * c[1][1] + b[3][2] * c[2][1] + b[3][3] * c[3][1];
	a[3][2] = b[3][0] * c[0][2] + b[3][1] * c[1][2] + b[3][2] * c[2][2] + b[3][3] * c[3][2];
	a[3][3] = b[3][0] * c[0][3] + b[3][1] * c[1][3] + b[3][2] * c[2][3] + b[3][3] * c[3][3];
#else
	register float b0, b1, b2, b3;

	b0 = b[0][0];
	b1 = b[0][1];
	b2 = b[0][2];
	b3 = b[0][3];
	a[0][0] = b0 * c[0][0] + b1 * c[1][0] + b2 * c[2][0] + b3 * c[3][0];
	a[0][1] = b0 * c[0][1] + b1 * c[1][1] + b2 * c[2][1] + b3 * c[3][1];
	a[0][2] = b0 * c[0][2] + b1 * c[1][2] + b2 * c[2][2] + b3 * c[3][2];
	a[0][3] = b0 * c[0][3] + b1 * c[1][3] + b2 * c[2][3] + b3 * c[3][3];

	b0 = b[1][0];
	b1 = b[1][1];
	b2 = b[1][2];
	b3 = b[1][3];
	a[1][0] = b0 * c[0][0] + b1 * c[1][0] + b2 * c[2][0] + b3 * c[3][0];
	a[1][1] = b0 * c[0][1] + b1 * c[1][1] + b2 * c[2][1] + b3 * c[3][1];
	a[1][2] = b0 * c[0][2] + b1 * c[1][2] + b2 * c[2][2] + b3 * c[3][2];
	a[1][3] = b0 * c[0][3] + b1 * c[1][3] + b2 * c[2][3] + b3 * c[3][3];

	b0 = b[2][0];
	b1 = b[2][1];
	b2 = b[2][2];
	b3 = b[2][3];
	a[2][0] = b0 * c[0][0] + b1 * c[1][0] + b2 * c[2][0] + b3 * c[3][0];
	a[2][1] = b0 * c[0][1] + b1 * c[1][1] + b2 * c[2][1] + b3 * c[3][1];
	a[2][2] = b0 * c[0][2] + b1 * c[1][2] + b2 * c[2][2] + b3 * c[3][2];
	a[2][3] = b0 * c[0][3] + b1 * c[1][3] + b2 * c[2][3] + b3 * c[3][3];

	b0 = b[3][0];
	b1 = b[3][1];
	b2 = b[3][2];
	b3 = b[3][3];
	a[3][0] = b0 * c[0][0] + b1 * c[1][0] + b2 * c[2][0] + b3 * c[3][0];
	a[3][1] = b0 * c[0][1] + b1 * c[1][1] + b2 * c[2][1] + b3 * c[3][1];
	a[3][2] = b0 * c[0][2] + b1 * c[1][2] + b2 * c[2][2] + b3 * c[3][2];
	a[3][3] = b0 * c[0][3] + b1 * c[1][3] + b2 * c[2][3] + b3 * c[3][3];
#endif
}

/*
 * multmatrix
 *
 * Premultipy the top matrix on the stack by "mat"
 *
 */
void
multmatrix(mat)
	Matrix	mat;
{
	Matrix	prod;
	float	*m;
	Token	*p;
	int	i;

	if (vdevice.inobject) {
		p = newtokens(17);

		p[0].i = MULTMATRIX;
		m = (float *)mat;
		for (i = 0; i < 16; i++)
			(++p)->f = *m++;

		return;
	}

	mult4x4(prod, mat, vdevice.transmat->m);
	loadmatrix(prod);
}

/*
 * identmatrix
 *
 * Return a 4 x 4 identity matrix
 *
 */
void
identmatrix(a)
	Matrix 	 a;
{
	register float	*p;

	for (p = (float *)a; p != (float *)a + 16; p++)
		*p = 0;

	a[0][0] = a[1][1] = a[2][2] = a[3][3] = 1;
}

/*
 * multvector
 *
 * Multiply the vector a and the matrix b to form v. Need it to be snappy again.
 * 
 */
void
multvector(v, a, b)
	register	Vector	v, a;
	register	Matrix	b;
{
#ifdef ORIGINAL
	v[0] = a[0] * b[0][0] + a[1] * b[1][0] + a[2] * b[2][0] + a[3] * b[3][0];
	v[1] = a[0] * b[0][1] + a[1] * b[1][1] + a[2] * b[2][1] + a[3] * b[3][1];
	v[2] = a[0] * b[0][2] + a[1] * b[1][2] + a[2] * b[2][2] + a[3] * b[3][2];
	v[3] = a[0] * b[0][3] + a[1] * b[1][3] + a[2] * b[2][3] + a[3] * b[3][3];
#else
	float tmp;

	tmp =  a[0];
	v[0] = tmp * b[0][0];
	v[1] = tmp * b[0][1];
	v[2] = tmp * b[0][2];
	v[3] = tmp * b[0][3];

	tmp =  a[1];
	v[0] += tmp * b[1][0];
	v[1] += tmp * b[1][1];
	v[2] += tmp * b[1][2];
	v[3] += tmp * b[1][3];

	tmp =  a[2];
	v[0] += tmp * b[2][0];
	v[1] += tmp * b[2][1];
	v[2] += tmp * b[2][2];
	v[3] += tmp * b[2][3];

	tmp =  a[3];
	v[0] += tmp * b[3][0];
	v[1] += tmp * b[3][1];
	v[2] += tmp * b[3][2];
	v[3] += tmp * b[3][3];
#endif
}

/*
 * premultvector
 *
 * PreMultiply the vector a and the matrix b to form v. 
 * Need it to be snappy again.
 * 
 */
void
premultvector(v, a, b)
	Vector	v, a;
	Matrix	b;
{
#ifdef ORIGINAL
	v[0] = a[0] * b[0][0] + a[1] * b[0][1] + a[2] * b[0][2] + a[3] * b[0][3];
	v[1] = a[0] * b[1][0] + a[1] * b[1][1] + a[2] * b[1][2] + a[3] * b[1][3];
	v[2] = a[0] * b[2][0] + a[1] * b[2][1] + a[2] * b[2][2] + a[3] * b[2][3];
	v[3] = a[0] * b[3][0] + a[1] * b[3][1] + a[2] * b[3][2] + a[3] * b[3][3];
#else
	float tmp;

	tmp = a[0];
	v[0] = tmp * b[0][0];
	v[1] = tmp * b[1][0];
	v[2] = tmp * b[2][0];
	v[3] = tmp * b[3][0];

	tmp = a[1];
	v[0] += tmp * b[0][1];
	v[1] += tmp * b[1][1];
	v[2] += tmp * b[2][1];
	v[3] += tmp * b[3][1];

	tmp = a[2];
	v[0] += tmp * b[0][2];
	v[1] += tmp * b[1][2];
	v[2] += tmp * b[2][2];
	v[3] += tmp * b[3][2];

	tmp = a[3];
	v[0] += tmp * b[0][3];
	v[1] += tmp * b[1][3];
	v[2] += tmp * b[2][3];
	v[3] += tmp * b[3][3];
#endif
}

#ifdef DEBUG 

/*
 * printmat
 *
 *	print s and then dump matrix m. Useful for debugging, you get
 * sick of typing in the print loop otherwise.
 */
printmat(s, m)
	char	*s;
	Matrix	m;
{
	int	i, j;

	printf("%s\n", s);
	for (i = 0; i < 4; i++) {
		for (j = 0; j < 4; j++)
			printf("%f ",m[i][j]);
		printf("\n");
	}
}
printvect(s, v)
	char	*s;
	Vector v;
{
	printf("%s %f %f %f %f\n", s, v[0], v[1], v[2], v[3]);
}

#endif
