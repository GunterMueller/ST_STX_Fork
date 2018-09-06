"
 COPYRIGHT (c) 1998 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ZipArchive
	instanceVariableNames:'file mode archiveName firstEntry lastEntry centralDirectory
		startOfArchive endOfArchive zipMembersByName appendTrailingSlash'
	classVariableNames:'RecentlyUsedZipArchives FlushBlock ZipFileFormatErrorSignal
		UnsupportedZipFileFormatErrorSignal DefaultAppendTrailingSlash
		ZipFileCachingTime'
	poolDictionaries:'ZipArchiveConstants'
	category:'System-Support-FileFormats'
!

PeekableStream subclass:#AbstractZipStream
	instanceVariableNames:'zipArchive zipEntry zipFileStream compressingStream crc32
		uncompressedDataSize startDataPosition'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ZipArchive
!

Object subclass:#ZipCentralDirectory
	instanceVariableNames:'numberOfThisDisk centralDirectoryStartDiskNumber
		centralDirectoryTotalNoOfEntriesOnThisDisk
		centralDirectoryTotalNoOfEntries centralDirectorySize
		centralDirectoryStartOffset zipCommentLength zipComment
		digitalSignatureDataSize digitalSignatureData'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ZipArchive
!

Object subclass:#ZipMember
	instanceVariableNames:'next versionMadeBy versionNeedToExtract generalPurposBitFlag
		compressionMethod lastModFileTime lastModFileDate crc32
		compressedSize uncompressedSize fileNameLength extraFieldLength
		fileCommentLength diskNumberStart internalFileAttributes
		externalFileAttributes relativeLocalHeaderOffset fileName
		extraField fileComment dataStart data'
	classVariableNames:''
	poolDictionaries:'ZipArchiveConstants'
	privateIn:ZipArchive
!

ZipArchive::AbstractZipStream subclass:#ZipReadStream
	instanceVariableNames:'readPosition peek'
	classVariableNames:''
	poolDictionaries:'ZipArchiveConstants'
	privateIn:ZipArchive
!

ZipArchive::AbstractZipStream subclass:#ZipWriteStream
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'ZipArchiveConstants'
	privateIn:ZipArchive
!

!ZipArchive primitiveDefinitions!
%{
#include <stdlib.h>
#include <stdio.h>

#define uchar     unsigned char
#define ushort    unsigned short
#define ulong     unsigned long

/*
 * inflate definitions
 */
#define PKZIP_BUG_WORKAROUND    /* PKZIP 1.93a problem--live with it */
#ifndef WSIZE           /* default is 32K */
# define WSIZE 0x8000   /* window size--must be a power of two, and at least */
#endif                  /* 32K for zip's deflate method */

#define NEXTBYTE        (*inPtr++)
#define XXXFLUSH(n)        slide += (n)
#define FLUSH(n)        { bcopy(slide, outPtr, (n)); outPtr += (n); }

#ifdef DEBUG
# define Trace(x)       if (debugTrace) { console_fprintf x ; }
#else
# define Trace(x)       /* nothing */
#endif

/* Huffman code lookup table entry--this entry is four bytes for machines
   that have 16-bit pointers (e.g. PC's in the small or medium model).
   Valid extra bits are 0..13.  e == 15 is EOB (end of block), e == 16
   means that v is a literal, 16 < e < 32 means that v is a pointer to
   the next table, which codes e - 16 bits, and lastly e == 99 indicates
   an unused code.  If a code with e == 99 is looked up, this implies an
   error in the data. */
struct huft {
  uchar e;                /* number of extra bits or operation */
  uchar b;                /* number of bits in this code or subcode */
  union {
    ushort n;             /* literal, length base, or distance base */
    struct huft *t;       /* pointer to next level of table */
  } v;
};

%}
! !

!ZipArchive primitiveVariables!
%{

static int debugTrace = 0;

/*
 * inflate variables
 */

static unsigned char *inPtr;
static unsigned char *outPtr;
static unsigned char *slide;

static int qflag = 0;

/* The inflate algorithm uses a sliding 32K byte window on the uncompressed
   stream to find repeated byte strings.  This is implemented here as a
   circular buffer.  The index is updated simply by incrementing and then
   and'ing with 0x7fff (32K-1). */
/* It is left to other modules to supply the 32K area.  It is assumed
   to be usable as if it were declared "uchar slide[32768];" or as just
   "uchar *slide;" and then malloc'ed in the latter case.  The definition
   must be in unzip.h, included above. */
static unsigned wp;            /* current position in slide */


/* Tables for deflate from PKZIP's appnote.txt. */
static unsigned border[] = {    /* Order of the bit length code lengths */
        16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15};

static ushort cplens[] = {         /* Copy lengths for literal codes 257..285 */
        3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31,
        35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258, 0, 0};
        /* note: see note #13 above about the 258 in this list. */

static ushort cplext[] = {         /* Extra bits for literal codes 257..285 */
        0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2,
        3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0, 99, 99}; /* 99==invalid */

static ushort cpdist[] = {         /* Copy offsets for distance codes 0..29 */
        1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193,
        257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145,
        8193, 12289, 16385, 24577};
static ushort cpdext[] = {         /* Extra bits for distance codes */
        0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6,
        7, 7, 8, 8, 9, 9, 10, 10, 11, 11,
        12, 12, 13, 13};

/* And'ing with mask[n] masks the lower n bits */
static ushort mask[] = {
    0x0000,
    0x0001, 0x0003, 0x0007, 0x000f, 0x001f, 0x003f, 0x007f, 0x00ff,
    0x01ff, 0x03ff, 0x07ff, 0x0fff, 0x1fff, 0x3fff, 0x7fff, 0xffff
};


/* Macros for inflate() bit peeking and grabbing.
   The usage is:

        NEEDBITS(j)
        x = b & mask[j];
        DUMPBITS(j)

   where NEEDBITS makes sure that b has at least j bits in it, and
   DUMPBITS removes the bits from b.  The macros use the variable k
   for the number of bits in b.  Normally, b and k are register
   variables for speed, and are initialized at the begining of a
   routine that uses these macros from a global bit buffer and count.

   In order to not ask for more bits than there are in the compressed
   stream, the Huffman tables are constructed to only ask for just
   enough bits to make up the end-of-block code (value 256).  Then no
   bytes need to be "returned" to the buffer at the end of the last
   block.  See the huft_build() routine.
 */

static ulong bb;                       /* bit buffer */
static unsigned bk;                    /* bits in bit buffer */

#define NEEDBITS(n) { while(k<(n)){ b |= ((ulong)NEXTBYTE)<<k; k+=8; } }
#define DUMPBITS(n) { b>>=(n); k-=(n); }


/*
   Huffman code decoding is performed using a multi-level table lookup.
   The fastest way to decode is to simply build a lookup table whose
   size is determined by the longest code.  However, the time it takes
   to build this table can also be a factor if the data being decoded
   is not very long.  The most common codes are necessarily the
   shortest codes, so those codes dominate the decoding time, and hence
   the speed.  The idea is you can have a shorter table that decodes the
   shorter, more probable codes, and then point to subsidiary tables for
   the longer codes.  The time it costs to decode the longer codes is
   then traded against the time it takes to make longer tables.

   This results of this trade are in the variables lbits and dbits
   below.  lbits is the number of bits the first level table for literal/
   length codes can decode in one step, and dbits is the same thing for
   the distance codes.  Subsequent tables are also less than or equal to
   those sizes.  These values may be adjusted either when all of the
   codes are shorter than that, in which case the longest code length in
   bits is used, or when the shortest code is *longer* than the requested
   table size, in which case the length of the shortest code in bits is
   used.

   There are two different values for the two tables, since they code a
   different number of possibilities each.  The literal/length table
   codes 286 possible values, or in a flat code, a little over eight
   bits.  The distance table codes 30 possible values, or a little less
   than five bits, flat.  The optimum values for speed end up being
   about one bit more than those, so lbits is 8+1 and dbits is 5+1.
   The optimum values may differ though from machine to machine, and
   possibly even between compilers.  Your mileage may vary.
 */


static int lbits = 9;          /* bits in base literal/length lookup table */
static int dbits = 6;          /* bits in base distance lookup table */


/* If BMAX needs to be larger than 16, then h and x[] should be ulong. */
#define BMAX 16         /* maximum bit length of any code (16 for explode) */
#define N_MAX 288       /* maximum number of codes in any set */


static unsigned hufts;         /* track memory usage */

%}
! !

!ZipArchive primitiveFunctions!
%{

/*
 * inflate algorithm
 */

/* Free the malloc'ed tables built by huft_build(), which makes a linked
   list of the tables it made, with the links in a dummy first entry of
   each table. */
static int
huft_free(t)
    struct huft *t;         /* table to free */
{
  register struct huft *p, *q;


  /* Go through linked list, freeing from the malloced (t[-1]) address. */
  p = t;
  while (p != (struct huft *)NULL)
  {
    q = (--p)->v.t;
    free(p);
    p = q;
  }
  return 0;
}




/* Given a list of code lengths and a maximum table size, make a set of
   tables to decode that set of codes.  Return zero on success, one if
   the given code set is incomplete (the tables are still built in this
   case), two if the input is invalid (all zero length codes or an
   oversubscribed set of lengths), and three if not enough memory.
   The code with value 256 is special, and the tables are constructed
   so that no bits beyond that code are fetched when that code is
   decoded. */
static int
huft_build(b, n, s, d, e, t, m)
    unsigned *b;            /* code lengths in bits (all assumed <= BMAX) */
    unsigned n;             /* number of codes (assumed <= N_MAX) */
    unsigned s;             /* number of simple-valued codes (0..s-1) */
    ushort *d;              /* list of base values for non-simple codes */
    ushort *e;              /* list of extra bits for non-simple codes */
    struct huft **t;        /* result: starting table */
    int *m;                 /* maximum lookup bits, returns actual */
{
  unsigned a;                   /* counter for codes of length k */
  unsigned c[BMAX+1];           /* bit length count table */
  unsigned el;                  /* length of EOB code (value 256) */
  unsigned f;                   /* i repeats in table every f entries */
  int g;                        /* maximum code length */
  int h;                        /* table level */
  register unsigned i;          /* counter, current code */
  register unsigned j;          /* counter */
  register int k;               /* number of bits in current code */
  int lx[BMAX+1];               /* memory for l[-1..BMAX-1] */
  int *l = lx+1;                /* stack of bits per table */
  register unsigned *p;         /* pointer into c[], b[], or v[] */
  register struct huft *q;      /* points to current table */
  struct huft r;                /* table entry for structure assignment */
  struct huft *u[BMAX];         /* table stack */
  static unsigned v[N_MAX];     /* values in order of bit length */
  register int w;               /* bits before this table == (l * h) */
  unsigned x[BMAX+1];           /* bit offsets, then code stack */
  unsigned *xp;                 /* pointer into x */
  int y;                        /* number of dummy codes added */
  unsigned z;                   /* number of entries in current table */
  extern void *malloc();

  /* Generate counts for each bit length */
  el = n > 256 ? b[256] : BMAX; /* set length of EOB code, if any */
  bzero((char *)c, sizeof(c));
  p = b;  i = n;
  do {
    c[*p]++; p++;               /* assume all entries <= BMAX */
  } while (--i);
  if (c[0] == n)                /* null input--all zero length codes */
  {
    *t = (struct huft *)NULL;
    *m = 0;
    return 0;
  }


  /* Find minimum and maximum length, bound *m by those */
  for (j = 1; j <= BMAX; j++)
    if (c[j])
      break;
  k = j;                        /* minimum code length */
  if ((unsigned)*m < j)
    *m = j;
  for (i = BMAX; i; i--)
    if (c[i])
      break;
  g = i;                        /* maximum code length */
  if ((unsigned)*m > i)
    *m = i;


  /* Adjust last length count to fill out codes, if needed */
  for (y = 1 << j; j < i; j++, y <<= 1)
    if ((y -= c[j]) < 0)
      return 2;                 /* bad input: more codes than bits */
  if ((y -= c[i]) < 0)
    return 2;
  c[i] += y;


  /* Generate starting offsets into the value table for each length */
  x[1] = j = 0;
  p = c + 1;  xp = x + 2;
  while (--i) {                 /* note that i == g from above */
    *xp++ = (j += *p++);
  }


  /* Make a table of values in order of bit lengths */
  p = b;  i = 0;
  do {
    if ((j = *p++) != 0)
      v[x[j]++] = i;
  } while (++i < n);


  /* Generate the Huffman codes and for each, make the table entries */
  x[0] = i = 0;                 /* first Huffman code is zero */
  p = v;                        /* grab values in bit order */
  h = -1;                       /* no tables yet--level -1 */
  w = l[-1] = 0;                /* no bits decoded yet */
  u[0] = (struct huft *)NULL;   /* just to keep compilers happy */
  q = (struct huft *)NULL;      /* ditto */
  z = 0;                        /* ditto */

  /* go through the bit lengths (k already is bits in shortest code) */
  for (; k <= g; k++)
  {
    a = c[k];
    while (a--)
    {
      /* here i is the Huffman code of length k bits for value *p */
      /* make tables up to required level */
      while (k > w + l[h])
      {
        w += l[h++];            /* add bits already decoded */

        /* compute minimum size table less than or equal to *m bits */
        z = (z = g - w) > (unsigned)*m ? *m : z;        /* upper limit */
        if ((f = 1 << (j = k - w)) > a + 1)     /* try a k-w bit table */
        {                       /* too few codes for k-w bit table */
          f -= a + 1;           /* deduct codes from patterns left */
          xp = c + k;
          while (++j < z)       /* try smaller tables up to z bits */
          {
            if ((f <<= 1) <= *++xp)
              break;            /* enough codes to use up j bits */
            f -= *xp;           /* else deduct codes from patterns */
          }
        }
        if ((unsigned)w + j > el && (unsigned)w < el)
          j = el - w;           /* make EOB code end at table */
        z = 1 << j;             /* table entries for j-bit table */
        l[h] = j;               /* set table size in stack */

        /* allocate and link in new table */
        if ((q = (struct huft *)malloc((z + 1)*sizeof(struct huft))) ==
            (struct huft *)NULL)
        {
          if (h)
            huft_free(u[0]);
          return 3;             /* not enough memory */
        }
        hufts += z + 1;         /* track memory usage */
        *t = q + 1;             /* link to list for huft_free() */
        *(t = &(q->v.t)) = (struct huft *)NULL;
        u[h] = ++q;             /* table starts after link */

        /* connect to last table, if there is one */
        if (h)
        {
          x[h] = i;             /* save pattern for backing up */
          r.b = (uchar)l[h-1];    /* bits to dump before this table */
          r.e = (uchar)(16 + j);  /* bits in this table */
          r.v.t = q;            /* pointer to this table */
          j = (i & ((1 << w) - 1)) >> (w - l[h-1]);
          u[h-1][j] = r;        /* connect to last table */
        }
      }

      /* set up table entry in r */
      r.b = (uchar)(k - w);
      if (p >= v + n)
        r.e = 99;               /* out of values--invalid code */
      else if (*p < s)
      {
        r.e = (uchar)(*p < 256 ? 16 : 15);    /* 256 is end-of-block code */
        r.v.n = *p++;           /* simple code is just the value */
      }
      else
      {
        r.e = (uchar)e[*p - s];   /* non-simple--look up in lists */
        r.v.n = d[*p++ - s];
      }

      /* fill code-like entries with r */
      f = 1 << (k - w);
      for (j = i >> w; j < z; j += f)
        q[j] = r;

      /* backwards increment the k-bit code i */
      for (j = 1 << (k - 1); i & j; j >>= 1)
        i ^= j;
      i ^= j;

      /* backup over finished tables */
      while ((i & ((1 << w) - 1)) != x[h])
        w -= l[--h];            /* don't need to update q */
    }
  }


  /* return actual size of base table */
  *m = l[0];


  /* Return true (1) if we were given an incomplete table */
  return y != 0 && g != 1;
}



#ifdef ASM_INFLATECODES
#  define inflate_codes(tl,td,bl,bd)  flate_codes(tl,td,bl,bd,(uchar *)slide)
   int flate_codes OF((struct huft *, struct huft *, int, int, uchar *));

#else

/* inflate (decompress) the codes in a deflated (compressed) block.
   Return an error code or zero if it all goes ok. */
static int
inflate_codes(tl, td, bl, bd)
    struct huft *tl, *td;   /* literal/length and distance decoder tables */
    int bl, bd;             /* number of bits decoded by tl[] and td[] */
{
  register unsigned e;  /* table entry flag/number of extra bits */
  unsigned n, d;        /* length and index for copy */
  unsigned w;           /* current window position */
  struct huft *t;       /* pointer to table entry */
  unsigned ml, md;      /* masks for bl and bd bits */
  register ulong b;       /* bit buffer */
  register unsigned k;  /* number of bits in bit buffer */


  /* make local copies of globals */
  b = bb;                       /* initialize bit buffer */
  k = bk;
  w = wp;                       /* initialize window position */


  /* inflate the coded data */
  ml = mask[bl];           /* precompute masks for speed */
  md = mask[bd];
  while (1)                     /* do until end of block */
  {
    NEEDBITS((unsigned)bl)
    if ((e = (t = tl + ((unsigned)b & ml))->e) > 16)
      do {
        if (e == 99)
          return 1;
        DUMPBITS(t->b)
        e -= 16;
        NEEDBITS(e)
      } while ((e = (t = t->v.t + ((unsigned)b & mask[e]))->e) > 16);
    DUMPBITS(t->b)
    if (e == 16)                /* then it's a literal */
    {
      slide[w++] = (uchar)t->v.n;
      if (w == WSIZE)
      {
        FLUSH(w);
        w = 0;
      }
    }
    else                        /* it's an EOB or a length */
    {
      /* exit if end of block */
      if (e == 15)
        break;

      /* get length of block to copy */
      NEEDBITS(e)
      n = t->v.n + ((unsigned)b & mask[e]);
      DUMPBITS(e);

      /* decode distance of block to copy */
      NEEDBITS((unsigned)bd)
      if ((e = (t = td + ((unsigned)b & md))->e) > 16)
        do {
          if (e == 99)
            return 1;
          DUMPBITS(t->b)
          e -= 16;
          NEEDBITS(e)
        } while ((e = (t = t->v.t + ((unsigned)b & mask[e]))->e) > 16);
      DUMPBITS(t->b)
      NEEDBITS(e)
      d = w - t->v.n - ((unsigned)b & mask[e]);
      DUMPBITS(e)

      /* do the copy */
      do {
        n -= (e = (e = WSIZE - ((d &= WSIZE-1) > w ? d : w)) > n ? n : e);
#ifndef NOMEMCPY
        if (w - d >= e)         /* (this test assumes unsigned comparison) */
        {
# ifdef USE_MEMCPY
          memcpy(slide + w, slide + d, e);
# else
          bcopy(slide + d, slide + w, e);
# endif
          w += e;
          d += e;
        }
        else                      /* do it slow to avoid memcpy() overlap */
#endif /* !NOMEMCPY */
          do {
            slide[w++] = slide[d++];
          } while (--e);
        if (w == WSIZE)
        {
          FLUSH(w);
          w = 0;
        }
      } while (n);
    }
  }


  /* restore the globals from the locals */
  wp = w;                       /* restore global window pointer */
  bb = b;                       /* restore global bit buffer */
  bk = k;


  /* done */
  return 0;
}

#endif /* ASM_INFLATECODES */



/* "decompress" an inflated type 0 (stored) block. */
static int
inflate_stored()
{
  unsigned n;           /* number of bytes in block */
  unsigned w;           /* current window position */
  register ulong b;       /* bit buffer */
  register unsigned k;  /* number of bits in bit buffer */


  /* make local copies of globals */
  Trace((stderr, "stored block\n"));
  b = bb;                       /* initialize bit buffer */
  k = bk;
  w = wp;                       /* initialize window position */


  /* go to byte boundary */
  n = k & 7;
  DUMPBITS(n);


  /* get the length and its complement */
  NEEDBITS(16)
  n = ((unsigned)b & 0xffff);
  DUMPBITS(16)
  NEEDBITS(16)
  if (n != (unsigned)((~b) & 0xffff))
    return 1;                   /* error in compressed data */
  DUMPBITS(16)


  /* read and output the compressed data */
  while (n--)
  {
    NEEDBITS(8)
    slide[w++] = (uchar)b;
    if (w == WSIZE)
    {
      FLUSH(w);
      w = 0;
    }
    DUMPBITS(8)
  }


  /* restore the globals from the locals */
  wp = w;                       /* restore global window pointer */
  bb = b;                       /* restore global bit buffer */
  bk = k;
  return 0;
}


/* Globals for literal tables (built once) */
static struct huft *fixed_tl = (struct huft *)NULL;
static struct huft *fixed_td = (struct huft *)NULL;
static int fixed_bl, fixed_bd;

/* decompress an inflated type 1 (fixed Huffman codes) block.  We should
   either replace this with a custom decoder, or at least precompute the
   Huffman tables. */
static int
inflate_fixed()
{
  /* if first time, set up tables for fixed blocks */
  Trace((stderr, "fixed block\n"));
  if (fixed_tl == (struct huft *)NULL)
  {
    int i;                /* temporary variable */
    static unsigned l[288]; /* length list for huft_build */

    /* literal table */
    for (i = 0; i < 144; i++)
      l[i] = 8;
    for (; i < 256; i++)
      l[i] = 9;
    for (; i < 280; i++)
      l[i] = 7;
    for (; i < 288; i++)          /* make a complete, but wrong code set */
      l[i] = 8;
    fixed_bl = 7;
    if ((i = huft_build(l, 288, 257, cplens, cplext,
                        &fixed_tl, &fixed_bl)) != 0)
    {
      Trace((stderr, "incomplete code set 1\n"));
      fixed_tl = (struct huft *)NULL;
      return i;
    }

    /* distance table */
    for (i = 0; i < 30; i++)      /* make an incomplete code set */
      l[i] = 5;
    fixed_bd = 5;
    if ((i = huft_build(l, 30, 0, cpdist, cpdext, &fixed_td, &fixed_bd)) > 1)
    {
      Trace((stderr, "incomplete code set 2\n"));
      huft_free(fixed_tl);
      fixed_tl = (struct huft *)NULL;
      return i;
    }
  }


  /* decompress until an end-of-block code */
  return inflate_codes(fixed_tl, fixed_td, fixed_bl, fixed_bd) != 0;
}



/* decompress an inflated type 2 (dynamic Huffman codes) block. */
static int
inflate_dynamic()
{
  int i;                /* temporary variables */
  unsigned j;
  unsigned l;           /* last length */
  unsigned m;           /* mask for bit lengths table */
  unsigned n;           /* number of lengths to get */
  struct huft *tl;      /* literal/length code table */
  struct huft *td;      /* distance code table */
  int bl;               /* lookup bits for tl */
  int bd;               /* lookup bits for td */
  unsigned nb;          /* number of bit length codes */
  unsigned nl;          /* number of literal/length codes */
  unsigned nd;          /* number of distance codes */
#ifdef PKZIP_BUG_WORKAROUND
  static unsigned ll[288+32]; /* literal/length and distance code lengths */
#else
  static unsigned ll[286+30]; /* literal/length and distance code lengths */
#endif
  register ulong b;       /* bit buffer */
  register unsigned k;  /* number of bits in bit buffer */


  /* make local bit buffer */
  Trace((stderr, "dynamic block\n"));
  b = bb;
  k = bk;


  /* read in table lengths */
  NEEDBITS(5)
  nl = 257 + ((unsigned)b & 0x1f);      /* number of literal/length codes */
  DUMPBITS(5)
  NEEDBITS(5)
  nd = 1 + ((unsigned)b & 0x1f);        /* number of distance codes */
  DUMPBITS(5)
  NEEDBITS(4)
  nb = 4 + ((unsigned)b & 0xf);         /* number of bit length codes */
  DUMPBITS(4)
#ifdef PKZIP_BUG_WORKAROUND
  if (nl > 288 || nd > 32)
#else
  if (nl > 286 || nd > 30)
#endif
  {
    Trace((stderr, "bad length\n"));
    return 1;                   /* bad lengths */
  }


  /* read in bit-length-code lengths */
  for (j = 0; j < nb; j++)
  {
    NEEDBITS(3)
    ll[border[j]] = (unsigned)b & 7;
    DUMPBITS(3)
  }
  for (; j < 19; j++)
    ll[border[j]] = 0;


  /* build decoding table for trees--single level, 7 bit lookup */
  bl = 7;
  if ((i = huft_build(ll, 19, 19, NULL, NULL, &tl, &bl)) != 0)
  {
    if (i == 1)
      huft_free(tl);
    Trace((stderr, "incomplete code set 3\n"));
    return i;                   /* incomplete code set */
  }


  /* read in literal and distance code lengths */
  n = nl + nd;
  m = mask[bl];
  i = l = 0;
  while ((unsigned)i < n)
  {
    NEEDBITS((unsigned)bl)
    j = (td = tl + ((unsigned)b & m))->b;
    DUMPBITS(j)
    j = td->v.n;
    if (j < 16)                 /* length of code in bits (0..15) */
      ll[i++] = l = j;          /* save last length in l */
    else if (j == 16)           /* repeat last length 3 to 6 times */
    {
      NEEDBITS(2)
      j = 3 + ((unsigned)b & 3);
      DUMPBITS(2)
      if ((unsigned)i + j > n)
        return 1;
      while (j--)
        ll[i++] = l;
    }
    else if (j == 17)           /* 3 to 10 zero length codes */
    {
      NEEDBITS(3)
      j = 3 + ((unsigned)b & 7);
      DUMPBITS(3)
      if ((unsigned)i + j > n)
        return 1;
      while (j--)
        ll[i++] = 0;
      l = 0;
    }
    else                        /* j == 18: 11 to 138 zero length codes */
    {
      NEEDBITS(7)
      j = 11 + ((unsigned)b & 0x7f);
      DUMPBITS(7)
      if ((unsigned)i + j > n)
        return 1;
      while (j--)
        ll[i++] = 0;
      l = 0;
    }
  }


  /* free decoding table for trees */
  huft_free(tl);


  /* restore the global bit buffer */
  bb = b;
  bk = k;


  /* build the decoding tables for literal/length and distance codes */
  bl = lbits;
  if ((i = huft_build(ll, nl, 257, cplens, cplext, &tl, &bl)) != 0)
  {
    Trace((stderr, "incomplete code set 4\n"));
    if (i == 1 && !qflag) {
      Trace((stderr, "incomplete l-tree\n"));
      huft_free(tl);
    }
    return i;                   /* incomplete code set */
  }
  bd = dbits;
  if ((i = huft_build(ll + nl, nd, 0, cpdist, cpdext, &td, &bd)) != 0)
  {
    Trace((stderr, "huft_build err\n"));
    if (i == 1 && !qflag) {
      Trace((stderr, "incomplete d-tree\n"));
#ifdef PKZIP_BUG_WORKAROUND
      i = 0;
    }
#else
      huft_free(td);
    }
    huft_free(tl);
    return i;                   /* incomplete code set */
#endif
  }


  /* decompress until an end-of-block code */
  if (inflate_codes(tl, td, bl, bd)) {
    Trace((stderr, "inflate_codes error\n"));
    return 1;
  }


  /* free the decoding tables, return */
  huft_free(tl);
  huft_free(td);
  Trace((stderr, "block ok\n"));
  return 0;
}



/* decompress an inflated block */
static int
inflate_block(endPtr)
    int *endPtr;                 /* last block flag */
{
  unsigned t;           /* block type */
  register ulong b;       /* bit buffer */
  register unsigned k;  /* number of bits in bit buffer */


  Trace((stderr, "inflate_block\n"));

  /* make local bit buffer */
  b = bb;
  k = bk;


  /* read in last block bit */
  NEEDBITS(1)
  *endPtr = (int)b & 1;
  Trace((stderr, "  end = %d\n", (int)b & 1));

  DUMPBITS(1)


  /* read in block type */
  NEEDBITS(2)
  t = (unsigned)b & 3;
  DUMPBITS(2)
  Trace((stderr, "  type = %d\n", t));


  /* restore the global bit buffer */
  bb = b;
  bk = k;


  /* inflate that block type */
  if (t == 2) {
    return inflate_dynamic();
  }
  if (t == 0) {
    return inflate_stored();
  }
  if (t == 1) {
    return inflate_fixed();
  }

  Trace((stderr, "bad block type\n"));
  /* bad block type */
  return 2;
}



/* decompress an inflated entry */
static int
inflate()
{
  int endFlag;                /* last block flag */
  int r;                /* result code */
  unsigned h;           /* maximum struct huft's malloc'ed */

  /* initialize window, bit buffer */
  wp = 0;
  bk = 0;
  bb = 0;

  endFlag = 0;

  /* decompress until the last block */
  h = 0;
  do {
    hufts = 0;
    if ((r = inflate_block(&endFlag)) != 0) {
      Trace((stderr, "inflate_block -> %d\n", r));
      return r;
    }
    if (hufts > h)
      h = hufts;
  } while (!endFlag);


  /* flush out slide */
  FLUSH(wp);


  /* return success */
  Trace((stderr, "%u bytes in Huffman tables (%d/entry)\n", (unsigned)(h * sizeof(struct huft)), (int)(sizeof(struct huft))));
  return 0;
}



static int
inflate_free()
{
  if (fixed_td != (struct huft *)NULL)
  {
    huft_free(fixed_td);
    fixed_td = (struct huft *)NULL;
  }

  if (fixed_tl != (struct huft *)NULL)
  {
    huft_free(fixed_tl);
    fixed_tl = (struct huft *)NULL;
  }
  return 0;
}


static int
stx_inflate(in, out)
    char *in, *out;
{
    int rslt;
    extern void *malloc();

    inPtr = in;
    outPtr = out;
    slide = malloc(WSIZE+2);
    if (! slide) return 1;

    rslt = inflate();
    inflate_free();
    free(slide);
    return rslt;
}

%}
! !

!ZipArchive class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

!

documentation
"
    provides access to a zip archive.


    Trailing slash.
        Some implementations require a trailing slash in directory
        names (such as OpenOffice zip implementation). Others just
        ignore external file attrbutes and indicate directory entry
        by adding trailing slash (such a Java zip implementation).

        Since ZipArchive 1.98 a trailing slash is added for all directory
        entries iff appendTrailingSlash instvar is set to true. By default 
        it set to value of DefaultAppendTrailingSlash which defaults to true.

        Setting appendTrailingSlash to false inhibits trailing slash
        behavior.
        

    Caveat: 
        the only compression methods (for now) are store and deflate.

    [author:]
        Claus Gittinger

    [classvars:]
        DefaultAppendTrailingSlash...a default value for appendTralingSlash instvar.
                                     For details, se above

"
!

examples
"
                                                        [exBegin]
    |zip bytes|

    zip := ZipArchive oldFileNamed:'foo.zip'.
    bytes := zip extract:'bar'.
    zip closeFile.
                                                        [exEnd]

                                                        [exBegin]
    |zip bytes|

    zip := ZipArchive oldFileNamed:'source/stx/libbasic2.zip'.
    zip entries do:[:entry |
        Transcript showCR:entry
    ].
    zip closeFile.
                                                        [exEnd]

                                                        [exBegin]
    |zip bytes|

    zip := ZipArchive oldFileNamed:'source/stx/libbasic2.zip'.
    bytes := zip extract:'TwoByteStr.st'.
    zip closeFile.
    Transcript showCR:(bytes asString).
                                                        [exEnd]


    compatibility write check with winzip (compressed with deflate)
                                                        [exBegin]
    |zipwr testDirectory testFileWr|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileWr := 'crcTest_resume_compressed.zip'.

    zipwr := ZipArchive newFileNamed:(testDirectory, testFileWr).
    zipwr addFile:'crcTest_resume_compressed.txt' withContents: 'resume'.
    zipwr closeFile.
                                                        [exEnd]

    compatibility read check with winzip (compressed with deflate)
                                                        [exBegin]
    |ziprd testDirectory testFileRd contents|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileRd := 'crcTest_resume_compressed.zip'.

    ziprd := ZipArchive oldFileNamed:(testDirectory, testFileRd).
    contents := ziprd extract: ziprd entries first.
    contents inspect.
    ziprd closeFile.
                                                        [exEnd]

    compatibility write check with winzip (uncompressed)
                                                        [exBegin]
    |zipwr testDirectory testFileWr|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileWr := 'crcTest_resume_uncompressed.zip'.

    zipwr := ZipArchive newFileNamed:(testDirectory, testFileWr).

    zipwr addFile:'crcTest_resume_uncompressed.txt' 
        withContents:'resume' 
       compressMethod:0 
          asDirectory:false.

    zipwr closeFile.
                                                        [exEnd]

    compatibility read check with winzip (uncompressed)
                                                        [exBegin]
    |ziprd testDirectory testFileRd contents|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileRd := 'crcTest_resume_uncompressed.zip'.

    ziprd := ZipArchive oldFileNamed:(testDirectory, testFileRd).
    contents := ziprd extract: ziprd entries first.
    contents inspect.
    ziprd closeFile.
                                                        [exEnd]

    read an archive with files and/or directories, fetch the entries 
    and create a new archive with the same content
                                                        [exBegin]
    |ziprd zipwr entryDict testDirectory testFileRd testFileWr|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileRd := 'projects.zip'.
    testFileWr := 'projects_expecco_test.zip'.

    ziprd := ZipArchive oldFileNamed:(testDirectory, testFileRd).
    entryDict := Dictionary new.
    ziprd entries do: [:aFileName|
        entryDict at:aFileName put:(ziprd extract: aFileName) asString.
    ].
    ziprd closeFile.

    zipwr := ZipArchive newFileNamed:(testDirectory, testFileWr).
    entryDict keysAndValuesDo: [:key :value|
        (value size == 0) ifTrue: [
            zipwr addDirectory:key.
        ] ifFalse: [
            zipwr addFile:key withContents:value
        ].
    ].
    zipwr closeFile.
                                                        [exEnd]

                                                        [exBegin]
    |zipwr ziprd testDirectory testFileWr testFileRd zs|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileWr := 'crcTest_resume_compressed.zip'.

    zipwr := ZipArchive newFileNamed:(testDirectory, testFileWr).
    zipwr addFile:'crcTest_resume_compressed.txt' withContents: 'Das ist ein test, das ist ein test, das ist ein test'.
    zipwr close.

    testFileRd := 'crcTest_resume_compressed.zip'.

    ziprd := ZipArchive oldFileNamed:(testDirectory, testFileRd).
    zs := ziprd readStreamFor: 'crcTest_resume_compressed.txt'.
    zs inspect.
    ziprd close.
                                                        [exEnd]

                                                        [exBegin]
    |zipwr ziprd testDirectory testFileWr testFileRd rs result|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileWr := 'readStreamTest_HelloWorld.zip'.

    zipwr := ZipArchive newFileNamed:(testDirectory, testFileWr).
    zipwr addFile:'readStreamTest_HelloWorld.txt' withContents: 'Hello World!!' compressed: false.
    zipwr close.

    testFileRd := 'readStreamTest_HelloWorld.zip'.
    ziprd := ZipArchive oldFileNamed:(testDirectory, testFileRd).
    rs := ziprd readStreamFor: 'readStreamTest_HelloWorld.txt'.

    result := ''.
    [ rs atEnd ] whileFalse: [
        result := result, (rs nextAvailable:5).
    ].
    result inspect.
    rs close.
    ziprd close.
                                                        [exEnd]

    read an archive with files and/or directories and/or zipArchives, 
    fetch the entries (also from the include zip archives) 
    and create a new archive
                                                        [exBegin]
    |ziprd zipwr entryDict testDirectory testFileRd testFileWr zipRdSub1 zipRdSub2|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileRd := 'ZipInZipFileTest.zip'.
    testFileWr := 'ZipInZipFileTest_generated.zip'.

    ziprd := ZipArchive oldFileNamed:(testDirectory, testFileRd).
    entryDict := Dictionary new.
    ziprd entries do: [:aFileName|
        Transcript showCR: 'processing in top: ', aFileName.
        (aFileName endsWith:'.zip') ifTrue: [
            zipRdSub1 := ziprd extractArchive: aFileName.
            zipRdSub1 entries do: [:aFileName1|
                Transcript showCR: 'processing in sub 1: ', aFileName1.
                (aFileName1 endsWith:'.zip') ifTrue: [
                    zipRdSub2 := zipRdSub1 extractArchive: aFileName1.
                    zipRdSub2 entries do: [:aFileName2|
                        Transcript showCR: 'processing in sub 2: ', aFileName2.
                        (aFileName2 endsWith:'.zip') ifTrue: [
                            self halt.
                        ] ifFalse: [
                            entryDict at:aFileName2 put:(zipRdSub2 extract: aFileName2) asString.
                        ].
                    ].
                    zipRdSub2 closeFile.
                ] ifFalse: [
                    entryDict at:aFileName1 put:(zipRdSub1 extract: aFileName1) asString.
                ].
            ].
            zipRdSub1 closeFile.
        ] ifFalse: [
            entryDict at:aFileName put:(ziprd extract: aFileName) asString.
        ].
    ].
    ziprd closeFile.

    zipwr := ZipArchive newFileNamed:(testDirectory, testFileWr).
    entryDict keysAndValuesDo: [:key :value|
        (value size == 0) ifTrue: [
            zipwr addDirectory:key.
        ] ifFalse: [
            zipwr addFile:key withContents:value
        ].
    ].
    zipwr closeFile.
                                                        [exEnd]

"
!

examples2
"
    add to new zip archive a entry which is located in memory using selector
        addFile:'crcTest_resume_compressed.txt' withContents:
    and real file contents from disk (uncompressed) identified by a readStream using selector
        addFile:rdStreamFile fromStream:
                                                        [exBegin]
    |zipwr testDirectory testFileWr rdStreamFile rdFileStream |

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileWr := 'streamtest_uncompressed.zip'.
    rdStreamFile := 'projects.zip'.

    rdFileStream := ('C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\', rdStreamFile) asFilename readStream.
    zipwr := ZipArchive newFileNamed:(testDirectory, testFileWr).
    zipwr addFile:'crcTest_resume_compressed.txt' withContents: 'resume'.
    zipwr addFile:rdStreamFile fromStream: rdFileStream.

    zipwr closeFile.
                                                        [exEnd]

    read from zip archive a entry into memory using selector
        extract:'crcTest_resume_compressed.txt'
    and store an uncompressed archive entry to disk using a writeStream
        extract: intoStream:
                                                        [exBegin]
    |ziprd testDirectory testFileRd wrStreamFile wrFileStream data1|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileRd := 'streamtest_uncompressed.zip'.
    wrStreamFile := 'test_projects.zip'.

    ziprd := ZipArchive oldFileNamed:(testDirectory, testFileRd).
    data1 := ziprd extract:'crcTest_resume_compressed.txt'.

    wrFileStream := ('C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\', wrStreamFile) asFilename writeStream.
    (ziprd extract:'projects.zip' intoStream: wrFileStream) ifFalse: [
        self halt.
    ].

    ziprd closeFile.
    wrFileStream close.
                                                        [exEnd]

    add (compressed) to new zip archive a real file contents from disk e.g. a pdf
    identified by a readStream
    using selector
        addFile:  fromStream:  compressMethod: 
                                                        [exBegin]
    |zipwr testDirectory testFileWr rdStreamFile rdFileStream|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileWr := 'streamtest_compressed.zip'.
    rdStreamFile := 'test.pdf'.

    rdFileStream := ('C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\', rdStreamFile) asFilename readStream.
    zipwr := ZipArchive newFileNamed:(testDirectory, testFileWr).
    zipwr addFileCompressed:rdStreamFile fromStream: rdFileStream.

    zipwr closeFile.
                                                        [exEnd]

    read from zip archive a compressed entry e.g. a pdf and store the contents 
    to disk using a readStream
    using selector
        readStreamFor: rdStreamFile 
                                                        [exBegin]
    |ziprd testDirectory testFileRd wrStreamFile wrFileStream|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileRd := 'streamtest_compressed.zip'.
    wrStreamFile := 'test_expecco.pdf'.

    ziprd := ZipArchive oldFileNamed:(testDirectory, testFileRd).

    wrFileStream := ('C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\', wrStreamFile) asFilename writeStream.
    (ziprd extract:'test.pdf' intoStream: wrFileStream) ifFalse: [
        self halt.
    ].

    ziprd closeFile.
    wrFileStream close.
                                                        [exEnd]

"
!

examples3
"
    add to new zip archive recursive the contents of a directory (uncompressed)
        addArchiveDirectory:  fromOsDirectory:
                                                        [exBegin]
    |zipwr testDirectory testFileWr zipDirectory |

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileWr := 'zipDirectoryTest.zip'.
    zipDirectory := 'abc'.

    zipwr := ZipArchive newFileNamed:(testDirectory, testFileWr).

    zipwr addArchiveDirectory: 'attachments' fromOsDirectory: (testDirectory,zipDirectory).

    zipwr closeFile.
                                                        [exEnd]

    read from zip archive all entries which are stored in an archive directory (uncompressed)
    and store all those entries in a directory on the file system
        restoreOsDirectory:  fromArchiveDirectory:
                                                        [exBegin]
    |ziprd testDirectory testFileRd zipDirectory|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileRd := 'zipDirectoryTest.zip'.
    zipDirectory := 'xxx'.

    ziprd := ZipArchive oldFileNamed:(testDirectory, testFileRd).
    ziprd restoreOsDirectory: (testDirectory,zipDirectory) fromArchiveDirectory: 'attachments'.
    ziprd closeFile.
                                                        [exEnd]


    add to new zip archive recursive the contents of a directory (compressed)
        addArchiveDirectoryCompressed:  fromOsDirectory:
                                                        [exBegin]
    |zipwr testDirectory testFileWr zipDirectory |

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileWr := 'zipDirectoryTestCompressed.zip'.
    zipDirectory := 'abc'.

    zipwr := ZipArchive newFileNamed:(testDirectory, testFileWr).

    zipwr addArchiveDirectoryCompressed: 'attachments' fromOsDirectory: (testDirectory,zipDirectory).

    zipwr closeFile.
                                                        [exEnd]

    read from zip archive all entries which are stored in an archive directory (compressed)
    and store all those entries in a directory on the file system
        restoreOsDirectory:  fromArchiveDirectory:
                                                        [exBegin]
    |ziprd testDirectory testFileRd zipDirectory|

    testDirectory := 'C:\Dokumente und Einstellungen\stefan\Eigene Dateien\tmp\'.
    testFileRd := 'zipDirectoryTestCompressed.zip'.
    zipDirectory := 'xxx-compressed'.

    ziprd := ZipArchive oldFileNamed:(testDirectory, testFileRd).
    ziprd restoreOsDirectory: (testDirectory,zipDirectory) fromArchiveDirectory: 'attachments'.
    ziprd closeFile.
                                                        [exEnd]

"
!

fileFormatDescription

"/File:    APPNOTE.TXT - .ZIP File Format Specification
"/Version: 6.3.2 
"/Revised: September 28, 2007
"/Copyright (c) 1989 - 2007 PKWARE Inc., All Rights Reserved.
"/
"/The use of certain technological aspects disclosed in the current
"/APPNOTE is available pursuant to the below section entitled
"/"Incorporating PKWARE Proprietary Technology into Your Product".
"/
"/I. Purpose
"/----------
"/
"/This specification is intended to define a cross-platform,
"/interoperable file storage and transfer format.  Since its 
"/first publication in 1989, PKWARE has remained committed to 
"/ensuring the interoperability of the .ZIP file format through 
"/publication and maintenance of this specification.  We trust that 
"/all .ZIP compatible vendors and application developers that have 
"/adopted and benefited from this format will share and support 
"/this commitment to interoperability.
"/
"/II. Contacting PKWARE
"/---------------------
"/
"/     PKWARE, Inc.
"/     648 N. Plankinton Avenue, Suite 220
"/     Milwaukee, WI 53203
"/     +1-414-289-9788
"/     +1-414-289-9789 FAX
"/     zipformat@pkware.com
"/
"/III. Disclaimer
"/---------------
"/
"/Although PKWARE will attempt to supply current and accurate
"/information relating to its file formats, algorithms, and the
"/subject programs, the possibility of error or omission cannot 
"/be eliminated. PKWARE therefore expressly disclaims any warranty 
"/that the information contained in the associated materials relating 
"/to the subject programs and/or the format of the files created or
"/accessed by the subject programs and/or the algorithms used by
"/the subject programs, or any other matter, is current, correct or
"/accurate as delivered.  Any risk of damage due to any possible
"/inaccurate information is assumed by the user of the information.
"/Furthermore, the information relating to the subject programs
"/and/or the file formats created or accessed by the subject
"/programs and/or the algorithms used by the subject programs is
"/subject to change without notice.
"/
"/If the version of this file is marked as a NOTIFICATION OF CHANGE,
"/the content defines an Early Feature Specification (EFS) change 
"/to the .ZIP file format that may be subject to modification prior 
"/to publication of the Final Feature Specification (FFS).  This
"/document may also contain information on Planned Feature 
"/Specifications (PFS) defining recognized future extensions.
"/
"/IV. Change Log
"/--------------
"/
"/Version       Change Description                        Date
"/-------       ------------------                       ----------
"/5.2           -Single Password Symmetric Encryption    06/02/2003
"/               storage
"/
"/6.1.0         -Smartcard compatibility                 01/20/2004
"/              -Documentation on certificate storage
"/
"/6.2.0         -Introduction of Central Directory       04/26/2004
"/               Encryption for encrypting metadata
"/              -Added OS/X to Version Made By values
"/
"/6.2.1         -Added Extra Field placeholder for       04/01/2005
"/               POSZIP using ID 0x4690
"/
"/              -Clarified size field on 
"/               "zip64 end of central directory record"
"/
"/6.2.2         -Documented Final Feature Specification  01/06/2006
"/               for Strong Encryption
"/
"/              -Clarifications and typographical 
"/               corrections
"/
"/6.3.0         -Added tape positioning storage          09/29/2006
"/               parameters
"/
"/              -Expanded list of supported hash algorithms
"/
"/              -Expanded list of supported compression
"/               algorithms
"/
"/              -Expanded list of supported encryption
"/               algorithms
"/
"/              -Added option for Unicode filename 
"/               storage
"/
"/              -Clarifications for consistent use
"/               of Data Descriptor records
"/
"/              -Added additional "Extra Field" 
"/               definitions
"/
"/6.3.1         -Corrected standard hash values for      04/11/2007
"/               SHA-256/384/512
"/
"/6.3.2         -Added compression method 97             09/28/2007
"/
"/              -Documented InfoZIP "Extra Field"
"/               values for UTF-8 file name and
"/               file comment storage
"/
"/V. General Format of a .ZIP file
"/--------------------------------
"/
"/  Files stored in arbitrary order.  Large .ZIP files can span multiple
"/  volumes or be split into user-defined segment sizes. All values
"/  are stored in little-endian byte order unless otherwise specified. 
"/
"/  Overall .ZIP file format:
"/
"/    [local file header 1]
"/    [file data 1]
"/    [data descriptor 1]
"/    . 
"/    .
"/    .
"/    [local file header n]
"/    [file data n]
"/    [data descriptor n]
"/    [archive decryption header] 
"/    [archive extra data record] 
"/    [central directory]
"/    [zip64 end of central directory record]
"/    [zip64 end of central directory locator] 
"/    [end of central directory record]
"/
"/
"/  A.  Local file header:
"/
"/        local file header signature     4 bytes  (0x04034b50)
"/        version needed to extract       2 bytes
"/        general purpose bit flag        2 bytes
"/        compression method              2 bytes
"/        last mod file time              2 bytes
"/        last mod file date              2 bytes
"/        crc-32                          4 bytes
"/        compressed size                 4 bytes
"/        uncompressed size               4 bytes
"/        file name length                2 bytes
"/        extra field length              2 bytes
"/
"/        file name (variable size)
"/        extra field (variable size)
"/
"/  B.  File data
"/
"/      Immediately following the local header for a file
"/      is the compressed or stored data for the file. 
"/      The series of [local file header][file data][data
"/      descriptor] repeats for each file in the .ZIP archive. 
"/
"/  C.  Data descriptor:
"/
"/        crc-32                          4 bytes
"/        compressed size                 4 bytes
"/        uncompressed size               4 bytes
"/
"/      This descriptor exists only if bit 3 of the general
"/      purpose bit flag is set (see below).  It is byte aligned
"/      and immediately follows the last byte of compressed data.
"/      This descriptor is used only when it was not possible to
"/      seek in the output .ZIP file, e.g., when the output .ZIP file
"/      was standard output or a non-seekable device.  For ZIP64(tm) format
"/      archives, the compressed and uncompressed sizes are 8 bytes each.
"/
"/      When compressing files, compressed and uncompressed sizes 
"/      should be stored in ZIP64 format (as 8 byte values) when a 
"/      files size exceeds 0xFFFFFFFF.   However ZIP64 format may be 
"/      used regardless of the size of a file.  When extracting, if 
"/      the zip64 extended information extra field is present for 
"/      the file the compressed and uncompressed sizes will be 8
"/      byte values.  
"/
"/      Although not originally assigned a signature, the value 
"/      0x08074b50 has commonly been adopted as a signature value 
"/      for the data descriptor record.  Implementers should be 
"/      aware that ZIP files may be encountered with or without this 
"/      signature marking data descriptors and should account for
"/      either case when reading ZIP files to ensure compatibility.
"/      When writing ZIP files, it is recommended to include the
"/      signature value marking the data descriptor record.  When
"/      the signature is used, the fields currently defined for
"/      the data descriptor record will immediately follow the
"/      signature.
"/
"/      An extensible data descriptor will be released in a future
"/      version of this APPNOTE.  This new record is intended to
"/      resolve conflicts with the use of this record going forward,
"/      and to provide better support for streamed file processing.
"/
"/      When the Central Directory Encryption method is used, the data
"/      descriptor record is not required, but may be used.  If present,
"/      and bit 3 of the general purpose bit field is set to indicate
"/      its presence, the values in fields of the data descriptor
"/      record should be set to binary zeros.
"/
"/  D.  Archive decryption header:  
"/
"/      The Archive Decryption Header is introduced in version 6.2
"/      of the ZIP format specification.  This record exists in support
"/      of the Central Directory Encryption Feature implemented as part of 
"/      the Strong Encryption Specification as described in this document.
"/      When the Central Directory Structure is encrypted, this decryption
"/      header will precede the encrypted data segment.  The encrypted
"/      data segment will consist of the Archive extra data record (if
"/      present) and the encrypted Central Directory Structure data.
"/      The format of this data record is identical to the Decryption
"/      header record preceding compressed file data.  If the central 
"/      directory structure is encrypted, the location of the start of
"/      this data record is determined using the Start of Central Directory
"/      field in the Zip64 End of Central Directory record.  Refer to the 
"/      section on the Strong Encryption Specification for information
"/      on the fields used in the Archive Decryption Header record.
"/
"/
"/  E.  Archive extra data record: 
"/
"/        archive extra data signature    4 bytes  (0x08064b50)
"/        extra field length              4 bytes
"/        extra field data                (variable size)
"/
"/      The Archive Extra Data Record is introduced in version 6.2
"/      of the ZIP format specification.  This record exists in support
"/      of the Central Directory Encryption Feature implemented as part of 
"/      the Strong Encryption Specification as described in this document.
"/      When present, this record immediately precedes the central 
"/      directory data structure.  The size of this data record will be
"/      included in the Size of the Central Directory field in the
"/      End of Central Directory record.  If the central directory structure
"/      is compressed, but not encrypted, the location of the start of
"/      this data record is determined using the Start of Central Directory
"/      field in the Zip64 End of Central Directory record.  
"/
"/
"/  F.  Central directory structure:
"/
"/      [file header 1]
"/      .
"/      .
"/      . 
"/      [file header n]
"/      [digital signature] 
"/
"/      File header:
"/
"/        central file header signature   4 bytes  (0x02014b50)
"/        version made by                 2 bytes
"/        version needed to extract       2 bytes
"/        general purpose bit flag        2 bytes
"/        compression method              2 bytes
"/        last mod file time              2 bytes
"/        last mod file date              2 bytes
"/        crc-32                          4 bytes
"/        compressed size                 4 bytes
"/        uncompressed size               4 bytes
"/        file name length                2 bytes
"/        extra field length              2 bytes
"/        file comment length             2 bytes
"/        disk number start               2 bytes
"/        internal file attributes        2 bytes
"/        external file attributes        4 bytes
"/        relative offset of local header 4 bytes
"/
"/        file name (variable size)
"/        extra field (variable size)
"/        file comment (variable size)
"/
"/      Digital signature:
"/
"/        header signature                4 bytes  (0x05054b50)
"/        size of data                    2 bytes
"/        signature data (variable size)
"/
"/      With the introduction of the Central Directory Encryption 
"/      feature in version 6.2 of this specification, the Central 
"/      Directory Structure may be stored both compressed and encrypted. 
"/      Although not required, it is assumed when encrypting the
"/      Central Directory Structure, that it will be compressed
"/      for greater storage efficiency.  Information on the
"/      Central Directory Encryption feature can be found in the section
"/      describing the Strong Encryption Specification. The Digital 
"/      Signature record will be neither compressed nor encrypted.
"/
"/  G.  Zip64 end of central directory record
"/
"/        zip64 end of central dir 
"/        signature                       4 bytes  (0x06064b50)
"/        size of zip64 end of central
"/        directory record                8 bytes
"/        version made by                 2 bytes
"/        version needed to extract       2 bytes
"/        number of this disk             4 bytes
"/        number of the disk with the 
"/        start of the central directory  4 bytes
"/        total number of entries in the
"/        central directory on this disk  8 bytes
"/        total number of entries in the
"/        central directory               8 bytes
"/        size of the central directory   8 bytes
"/        offset of start of central
"/        directory with respect to
"/        the starting disk number        8 bytes
"/        zip64 extensible data sector    (variable size)
"/
"/        The value stored into the "size of zip64 end of central
"/        directory record" should be the size of the remaining
"/        record and should not include the leading 12 bytes.
"/
"/        Size = SizeOfFixedFields + SizeOfVariableData - 12.
"/
"/        The above record structure defines Version 1 of the 
"/        zip64 end of central directory record. Version 1 was 
"/        implemented in versions of this specification preceding 
"/        6.2 in support of the ZIP64 large file feature. The 
"/        introduction of the Central Directory Encryption feature 
"/        implemented in version 6.2 as part of the Strong Encryption 
"/        Specification defines Version 2 of this record structure. 
"/        Refer to the section describing the Strong Encryption 
"/        Specification for details on the version 2 format for 
"/        this record.
"/
"/        Special purpose data may reside in the zip64 extensible data
"/        sector field following either a V1 or V2 version of this
"/        record.  To ensure identification of this special purpose data
"/        it must include an identifying header block consisting of the
"/        following:
"/
"/           Header ID  -  2 bytes
"/           Data Size  -  4 bytes
"/
"/        The Header ID field indicates the type of data that is in the 
"/        data block that follows.
"/
"/        Data Size identifies the number of bytes that follow for this
"/        data block type.
"/
"/        Multiple special purpose data blocks may be present, but each
"/        must be preceded by a Header ID and Data Size field.  Current
"/        mappings of Header ID values supported in this field are as
"/        defined in APPENDIX C.
"/
"/  H.  Zip64 end of central directory locator
"/
"/        zip64 end of central dir locator 
"/        signature                       4 bytes  (0x07064b50)
"/        number of the disk with the
"/        start of the zip64 end of 
"/        central directory               4 bytes
"/        relative offset of the zip64
"/        end of central directory record 8 bytes
"/        total number of disks           4 bytes
"/
"/  I.  End of central directory record:
"/
"/        end of central dir signature    4 bytes  (0x06054b50)
"/        number of this disk             2 bytes
"/        number of the disk with the
"/        start of the central directory  2 bytes
"/        total number of entries in the
"/        central directory on this disk  2 bytes
"/        total number of entries in
"/        the central directory           2 bytes
"/        size of the central directory   4 bytes
"/        offset of start of central
"/        directory with respect to
"/        the starting disk number        4 bytes
"/        .ZIP file comment length        2 bytes
"/        .ZIP file comment       (variable size)
"/
"/  J.  Explanation of fields:
"/
"/      version made by (2 bytes)
"/
"/          The upper byte indicates the compatibility of the file
"/          attribute information.  If the external file attributes 
"/          are compatible with MS-DOS and can be read by PKZIP for 
"/          DOS version 2.04g then this value will be zero.  If these 
"/          attributes are not compatible, then this value will 
"/          identify the host system on which the attributes are 
"/          compatible.  Software can use this information to determine
"/          the line record format for text files etc.  The current
"/          mappings are:
"/
"/          0 - MS-DOS and OS/2 (FAT / VFAT / FAT32 file systems)
"/          1 - Amiga                     2 - OpenVMS
"/          3 - UNIX                      4 - VM/CMS
"/          5 - Atari ST                  6 - OS/2 H.P.F.S.
"/          7 - Macintosh                 8 - Z-System
"/          9 - CP/M                     10 - Windows NTFS
"/         11 - MVS (OS/390 - Z/OS)      12 - VSE
"/         13 - Acorn Risc               14 - VFAT
"/         15 - alternate MVS            16 - BeOS
"/         17 - Tandem                   18 - OS/400
"/         19 - OS/X (Darwin)            20 thru 255 - unused
"/
"/          The lower byte indicates the ZIP specification version 
"/          (the version of this document) supported by the software 
"/          used to encode the file.  The value/10 indicates the major 
"/          version number, and the value mod 10 is the minor version 
"/          number.  
"/
"/      version needed to extract (2 bytes)
"/
"/          The minimum supported ZIP specification version needed to 
"/          extract the file, mapped as above.  This value is based on 
"/          the specific format features a ZIP program must support to 
"/          be able to extract the file.  If multiple features are
"/          applied to a file, the minimum version should be set to the 
"/          feature having the highest value. New features or feature 
"/          changes affecting the published format specification will be 
"/          implemented using higher version numbers than the last 
"/          published value to avoid conflict.
"/
"/          Current minimum feature versions are as defined below:
"/
"/          1.0 - Default value
"/          1.1 - File is a volume label
"/          2.0 - File is a folder (directory)
"/          2.0 - File is compressed using Deflate compression
"/          2.0 - File is encrypted using traditional PKWARE encryption
"/          2.1 - File is compressed using Deflate64(tm)
"/          2.5 - File is compressed using PKWARE DCL Implode 
"/          2.7 - File is a patch data set 
"/          4.5 - File uses ZIP64 format extensions
"/          4.6 - File is compressed using BZIP2 compression*
"/          5.0 - File is encrypted using DES
"/          5.0 - File is encrypted using 3DES
"/          5.0 - File is encrypted using original RC2 encryption
"/          5.0 - File is encrypted using RC4 encryption
"/          5.1 - File is encrypted using AES encryption
"/          5.1 - File is encrypted using corrected RC2 encryption**
"/          5.2 - File is encrypted using corrected RC2-64 encryption**
"/          6.1 - File is encrypted using non-OAEP key wrapping***
"/          6.2 - Central directory encryption
"/          6.3 - File is compressed using LZMA
"/          6.3 - File is compressed using PPMd+
"/          6.3 - File is encrypted using Blowfish
"/          6.3 - File is encrypted using Twofish
"/
"/
"/          * Early 7.x (pre-7.2) versions of PKZIP incorrectly set the
"/          version needed to extract for BZIP2 compression to be 50
"/          when it should have been 46.
"/
"/          ** Refer to the section on Strong Encryption Specification
"/          for additional information regarding RC2 corrections.
"/
"/          *** Certificate encryption using non-OAEP key wrapping is the
"/          intended mode of operation for all versions beginning with 6.1.
"/          Support for OAEP key wrapping should only be used for
"/          backward compatibility when sending ZIP files to be opened by
"/          versions of PKZIP older than 6.1 (5.0 or 6.0).
"/
"/          + Files compressed using PPMd should set the version
"/          needed to extract field to 6.3, however, not all ZIP 
"/          programs enforce this and may be unable to decompress 
"/          data files compressed using PPMd if this value is set.
"/
"/          When using ZIP64 extensions, the corresponding value in the
"/          zip64 end of central directory record should also be set.  
"/          This field should be set appropriately to indicate whether 
"/          Version 1 or Version 2 format is in use. 
"/
"/      general purpose bit flag: (2 bytes)
"/
"/          Bit 0: If set, indicates that the file is encrypted.
"/
"/          (For Method 6 - Imploding)
"/          Bit 1: If the compression method used was type 6,
"/                 Imploding, then this bit, if set, indicates
"/                 an 8K sliding dictionary was used.  If clear,
"/                 then a 4K sliding dictionary was used.
"/          Bit 2: If the compression method used was type 6,
"/                 Imploding, then this bit, if set, indicates
"/                 3 Shannon-Fano trees were used to encode the
"/                 sliding dictionary output.  If clear, then 2
"/                 Shannon-Fano trees were used.
"/
"/          (For Methods 8 and 9 - Deflating)
"/          Bit 2  Bit 1
"/            0      0    Normal (-en) compression option was used.
"/            0      1    Maximum (-exx/-ex) compression option was used.
"/            1      0    Fast (-ef) compression option was used.
"/            1      1    Super Fast (-es) compression option was used.
"/
"/          (For Method 14 - LZMA)
"/          Bit 1: If the compression method used was type 14,
"/                 LZMA, then this bit, if set, indicates
"/                 an end-of-stream (EOS) marker is used to
"/                 mark the end of the compressed data stream.
"/                 If clear, then an EOS marker is not present
"/                 and the compressed data size must be known
"/                 to extract.
"/
"/          Note:  Bits 1 and 2 are undefined if the compression
"/                 method is any other.
"/
"/          Bit 3: If this bit is set, the fields crc-32, compressed 
"/                 size and uncompressed size are set to zero in the 
"/                 local header.  The correct values are put in the 
"/                 data descriptor immediately following the compressed
"/                 data.  (Note: PKZIP version 2.04g for DOS only 
"/                 recognizes this bit for method 8 compression, newer 
"/                 versions of PKZIP recognize this bit for any 
"/                 compression method.)
"/
"/          Bit 4: Reserved for use with method 8, for enhanced
"/                 deflating. 
"/
"/          Bit 5: If this bit is set, this indicates that the file is 
"/                 compressed patched data.  (Note: Requires PKZIP 
"/                 version 2.70 or greater)
"/
"/          Bit 6: Strong encryption.  If this bit is set, you should
"/                 set the version needed to extract value to at least
"/                 50 and you must also set bit 0.  If AES encryption
"/                 is used, the version needed to extract value must 
"/                 be at least 51.
"/
"/          Bit 7: Currently unused.
"/
"/          Bit 8: Currently unused.
"/
"/          Bit 9: Currently unused.
"/
"/          Bit 10: Currently unused.
"/
"/          Bit 11: Language encoding flag (EFS).  If this bit is set,
"/                  the filename and comment fields for this file
"/                  must be encoded using UTF-8. (see APPENDIX D)
"/
"/          Bit 12: Reserved by PKWARE for enhanced compression.
"/
"/          Bit 13: Used when encrypting the Central Directory to indicate 
"/                  selected data values in the Local Header are masked to
"/                  hide their actual values.  See the section describing 
"/                  the Strong Encryption Specification for details.
"/
"/          Bit 14: Reserved by PKWARE.
"/
"/          Bit 15: Reserved by PKWARE.
"/
"/      compression method: (2 bytes)
"/
"/          (see accompanying documentation for algorithm
"/          descriptions)
"/
"/          0 - The file is stored (no compression)
"/          1 - The file is Shrunk
"/          2 - The file is Reduced with compression factor 1
"/          3 - The file is Reduced with compression factor 2
"/          4 - The file is Reduced with compression factor 3
"/          5 - The file is Reduced with compression factor 4
"/          6 - The file is Imploded
"/          7 - Reserved for Tokenizing compression algorithm
"/          8 - The file is Deflated
"/          9 - Enhanced Deflating using Deflate64(tm)
"/         10 - PKWARE Data Compression Library Imploding (old IBM TERSE)
"/         11 - Reserved by PKWARE
"/         12 - File is compressed using BZIP2 algorithm
"/         13 - Reserved by PKWARE
"/         14 - LZMA (EFS)
"/         15 - Reserved by PKWARE
"/         16 - Reserved by PKWARE
"/         17 - Reserved by PKWARE
"/         18 - File is compressed using IBM TERSE (new)
"/         19 - IBM LZ77 z Architecture (PFS)
"/         97 - WavPack compressed data
"/         98 - PPMd version I, Rev 1
"/
"/      date and time fields: (2 bytes each)
"/
"/          The date and time are encoded in standard MS-DOS format.
"/          If input came from standard input, the date and time are
"/          those at which compression was started for this data. 
"/          If encrypting the central directory and general purpose bit 
"/          flag 13 is set indicating masking, the value stored in the 
"/          Local Header will be zero. 
"/
"/      CRC-32: (4 bytes)
"/
"/          The CRC-32 algorithm was generously contributed by
"/          David Schwaderer and can be found in his excellent
"/          book "C Programmers Guide to NetBIOS" published by
"/          Howard W. Sams & Co. Inc.  The 'magic number' for
"/          the CRC is 0xdebb20e3.  The proper CRC pre and post
"/          conditioning is used, meaning that the CRC register
"/          is pre-conditioned with all ones (a starting value
"/          of 0xffffffff) and the value is post-conditioned by
"/          taking the one's complement of the CRC residual.
"/          If bit 3 of the general purpose flag is set, this
"/          field is set to zero in the local header and the correct
"/          value is put in the data descriptor and in the central
"/          directory. When encrypting the central directory, if the
"/          local header is not in ZIP64 format and general purpose 
"/          bit flag 13 is set indicating masking, the value stored 
"/          in the Local Header will be zero. 
"/
"/      compressed size: (4 bytes)
"/      uncompressed size: (4 bytes)
"/
"/          The size of the file compressed and uncompressed,
"/          respectively.  When a decryption header is present it will
"/          be placed in front of the file data and the value of the
"/          compressed file size will include the bytes of the decryption
"/          header.  If bit 3 of the general purpose bit flag is set, 
"/          these fields are set to zero in the local header and the 
"/          correct values are put in the data descriptor and
"/          in the central directory.  If an archive is in ZIP64 format
"/          and the value in this field is 0xFFFFFFFF, the size will be
"/          in the corresponding 8 byte ZIP64 extended information 
"/          extra field.  When encrypting the central directory, if the
"/          local header is not in ZIP64 format and general purpose bit 
"/          flag 13 is set indicating masking, the value stored for the 
"/          uncompressed size in the Local Header will be zero. 
"/
"/      file name length: (2 bytes)
"/      extra field length: (2 bytes)
"/      file comment length: (2 bytes)
"/
"/          The length of the file name, extra field, and comment
"/          fields respectively.  The combined length of any
"/          directory record and these three fields should not
"/          generally exceed 65,535 bytes.  If input came from standard
"/          input, the file name length is set to zero.  
"/
"/      disk number start: (2 bytes)
"/
"/          The number of the disk on which this file begins.  If an 
"/          archive is in ZIP64 format and the value in this field is 
"/          0xFFFF, the size will be in the corresponding 4 byte zip64 
"/          extended information extra field.
"/
"/      internal file attributes: (2 bytes)
"/
"/          Bits 1 and 2 are reserved for use by PKWARE.
"/
"/          The lowest bit of this field indicates, if set, that
"/          the file is apparently an ASCII or text file.  If not
"/          set, that the file apparently contains binary data.
"/          The remaining bits are unused in version 1.0.
"/
"/          The 0x0002 bit of this field indicates, if set, that a 
"/          4 byte variable record length control field precedes each 
"/          logical record indicating the length of the record. The 
"/          record length control field is stored in little-endian byte
"/          order.  This flag is independent of text control characters, 
"/          and if used in conjunction with text data, includes any 
"/          control characters in the total length of the record. This 
"/          value is provided for mainframe data transfer support.
"/
"/      external file attributes: (4 bytes)
"/
"/          The mapping of the external attributes is
"/          host-system dependent (see 'version made by').  For
"/          MS-DOS, the low order byte is the MS-DOS directory
"/          attribute byte.  If input came from standard input, this
"/          field is set to zero.
"/
"/      relative offset of local header: (4 bytes)
"/
"/          This is the offset from the start of the first disk on
"/          which this file appears, to where the local header should
"/          be found.  If an archive is in ZIP64 format and the value
"/          in this field is 0xFFFFFFFF, the size will be in the 
"/          corresponding 8 byte zip64 extended information extra field.
"/
"/      file name: (Variable)
"/
"/          The name of the file, with optional relative path.
"/          The path stored should not contain a drive or
"/          device letter, or a leading slash.  All slashes
"/          should be forward slashes '/' as opposed to
"/          backwards slashes '\' for compatibility with Amiga
"/          and UNIX file systems etc.  If input came from standard
"/          input, there is no file name field.  If encrypting
"/          the central directory and general purpose bit flag 13 is set 
"/          indicating masking, the file name stored in the Local Header 
"/          will not be the actual file name.  A masking value consisting 
"/          of a unique hexadecimal value will be stored.  This value will 
"/          be sequentially incremented for each file in the archive. See
"/          the section on the Strong Encryption Specification for details 
"/          on retrieving the encrypted file name. 
"/
"/      extra field: (Variable)
"/
"/          This is for expansion.  If additional information
"/          needs to be stored for special needs or for specific 
"/          platforms, it should be stored here.  Earlier versions 
"/          of the software can then safely skip this file, and 
"/          find the next file or header.  This field will be 0 
"/          length in version 1.0.
"/
"/          In order to allow different programs and different types
"/          of information to be stored in the 'extra' field in .ZIP
"/          files, the following structure should be used for all
"/          programs storing data in this field:
"/
"/          header1+data1 + header2+data2 . . .
"/
"/          Each header should consist of:
"/
"/            Header ID - 2 bytes
"/            Data Size - 2 bytes
"/
"/          Note: all fields stored in Intel low-byte/high-byte order.
"/
"/          The Header ID field indicates the type of data that is in
"/          the following data block.
"/
"/          Header ID's of 0 thru 31 are reserved for use by PKWARE.
"/          The remaining ID's can be used by third party vendors for
"/          proprietary usage.
"/
"/          The current Header ID mappings defined by PKWARE are:
"/
"/          0x0001        Zip64 extended information extra field
"/          0x0007        AV Info
"/          0x0008        Reserved for extended language encoding data (PFS)
"/                        (see APPENDIX D)
"/          0x0009        OS/2
"/          0x000a        NTFS 
"/          0x000c        OpenVMS
"/          0x000d        UNIX
"/          0x000e        Reserved for file stream and fork descriptors
"/          0x000f        Patch Descriptor
"/          0x0014        PKCS#7 Store for X.509 Certificates
"/          0x0015        X.509 Certificate ID and Signature for 
"/                        individual file
"/          0x0016        X.509 Certificate ID for Central Directory
"/          0x0017        Strong Encryption Header
"/          0x0018        Record Management Controls
"/          0x0019        PKCS#7 Encryption Recipient Certificate List
"/          0x0065        IBM S/390 (Z390), AS/400 (I400) attributes 
"/                        - uncompressed
"/          0x0066        Reserved for IBM S/390 (Z390), AS/400 (I400) 
"/                        attributes - compressed
"/          0x4690        POSZIP 4690 (reserved) 
"/
"/          Third party mappings commonly used are:
"/
"/
"/          0x07c8        Macintosh
"/          0x2605        ZipIt Macintosh
"/          0x2705        ZipIt Macintosh 1.3.5+
"/          0x2805        ZipIt Macintosh 1.3.5+
"/          0x334d        Info-ZIP Macintosh
"/          0x4341        Acorn/SparkFS 
"/          0x4453        Windows NT security descriptor (binary ACL)
"/          0x4704        VM/CMS
"/          0x470f        MVS
"/          0x4b46        FWKCS MD5 (see below)
"/          0x4c41        OS/2 access control list (text ACL)
"/          0x4d49        Info-ZIP OpenVMS
"/          0x4f4c        Xceed original location extra field
"/          0x5356        AOS/VS (ACL)
"/          0x5455        extended timestamp
"/          0x554e        Xceed unicode extra field
"/          0x5855        Info-ZIP UNIX (original, also OS/2, NT, etc)
"/          0x6375        Info-ZIP Unicode Comment Extra Field
"/          0x6542        BeOS/BeBox
"/          0x7075        Info-ZIP Unicode Path Extra Field
"/          0x756e        ASi UNIX
"/          0x7855        Info-ZIP UNIX (new)
"/          0xa220        Microsoft Open Packaging Growth Hint
"/          0xfd4a        SMS/QDOS
"/
"/          Detailed descriptions of Extra Fields defined by third 
"/          party mappings will be documented as information on
"/          these data structures is made available to PKWARE.  
"/          PKWARE does not guarantee the accuracy of any published
"/          third party data.
"/
"/          The Data Size field indicates the size of the following
"/          data block. Programs can use this value to skip to the
"/          next header block, passing over any data blocks that are
"/          not of interest.
"/
"/          Note: As stated above, the size of the entire .ZIP file
"/                header, including the file name, comment, and extra
"/                field should not exceed 64K in size.
"/
"/          In case two different programs should appropriate the same
"/          Header ID value, it is strongly recommended that each
"/          program place a unique signature of at least two bytes in
"/          size (and preferably 4 bytes or bigger) at the start of
"/          each data area.  Every program should verify that its
"/          unique signature is present, in addition to the Header ID
"/          value being correct, before assuming that it is a block of
"/          known type.
"/
"/         -Zip64 Extended Information Extra Field (0x0001):
"/
"/          The following is the layout of the zip64 extended 
"/          information "extra" block. If one of the size or
"/          offset fields in the Local or Central directory
"/          record is too small to hold the required data,
"/          a Zip64 extended information record is created.
"/          The order of the fields in the zip64 extended 
"/          information record is fixed, but the fields will
"/          only appear if the corresponding Local or Central
"/          directory record field is set to 0xFFFF or 0xFFFFFFFF.
"/
"/          Note: all fields stored in Intel low-byte/high-byte order.
"/
"/          Value      Size       Description
"/          -----      ----       -----------
"/  (ZIP64) 0x0001     2 bytes    Tag for this "extra" block type
"/          Size       2 bytes    Size of this "extra" block
"/          Original 
"/          Size       8 bytes    Original uncompressed file size
"/          Compressed
"/          Size       8 bytes    Size of compressed data
"/          Relative Header
"/          Offset     8 bytes    Offset of local header record
"/          Disk Start
"/          Number     4 bytes    Number of the disk on which
"/                                this file starts 
"/
"/          This entry in the Local header must include BOTH original
"/          and compressed file size fields. If encrypting the 
"/          central directory and bit 13 of the general purpose bit
"/          flag is set indicating masking, the value stored in the
"/          Local Header for the original file size will be zero.
"/
"/
"/         -OS/2 Extra Field (0x0009):
"/
"/          The following is the layout of the OS/2 attributes "extra" 
"/          block.  (Last Revision  09/05/95)
"/
"/          Note: all fields stored in Intel low-byte/high-byte order.
"/
"/          Value       Size          Description
"/          -----       ----          -----------
"/  (OS/2)  0x0009      2 bytes       Tag for this "extra" block type
"/          TSize       2 bytes       Size for the following data block
"/          BSize       4 bytes       Uncompressed Block Size
"/          CType       2 bytes       Compression type
"/          EACRC       4 bytes       CRC value for uncompress block
"/          (var)       variable      Compressed block
"/
"/          The OS/2 extended attribute structure (FEA2LIST) is 
"/          compressed and then stored in it's entirety within this 
"/          structure.  There will only ever be one "block" of data in 
"/          VarFields[].
"/
"/         -NTFS Extra Field (0x000a):
"/
"/          The following is the layout of the NTFS attributes 
"/          "extra" block. (Note: At this time the Mtime, Atime
"/          and Ctime values may be used on any WIN32 system.)  
"/
"/          Note: all fields stored in Intel low-byte/high-byte order.
"/
"/          Value      Size       Description
"/          -----      ----       -----------
"/  (NTFS)  0x000a     2 bytes    Tag for this "extra" block type
"/          TSize      2 bytes    Size of the total "extra" block
"/          Reserved   4 bytes    Reserved for future use
"/          Tag1       2 bytes    NTFS attribute tag value #1
"/          Size1      2 bytes    Size of attribute #1, in bytes
"/          (var.)     Size1      Attribute #1 data
"/          .
"/          .
"/          .
"/          TagN       2 bytes    NTFS attribute tag value #N
"/          SizeN      2 bytes    Size of attribute #N, in bytes
"/          (var.)     SizeN      Attribute #N data
"/
"/          For NTFS, values for Tag1 through TagN are as follows:
"/          (currently only one set of attributes is defined for NTFS)
"/
"/          Tag        Size       Description
"/          -----      ----       -----------
"/          0x0001     2 bytes    Tag for attribute #1 
"/          Size1      2 bytes    Size of attribute #1, in bytes
"/          Mtime      8 bytes    File last modification time
"/          Atime      8 bytes    File last access time
"/          Ctime      8 bytes    File creation time
"/
"/         -OpenVMS Extra Field (0x000c):
"/
"/          The following is the layout of the OpenVMS attributes 
"/          "extra" block.
"/
"/          Note: all fields stored in Intel low-byte/high-byte order.
"/
"/          Value      Size       Description
"/          -----      ----       -----------
"/  (VMS)   0x000c     2 bytes    Tag for this "extra" block type
"/          TSize      2 bytes    Size of the total "extra" block
"/          CRC        4 bytes    32-bit CRC for remainder of the block
"/          Tag1       2 bytes    OpenVMS attribute tag value #1
"/          Size1      2 bytes    Size of attribute #1, in bytes
"/          (var.)     Size1      Attribute #1 data
"/          .
"/          .
"/          .
"/          TagN       2 bytes    OpenVMS attribute tag value #N
"/          SizeN      2 bytes    Size of attribute #N, in bytes
"/          (var.)     SizeN      Attribute #N data
"/
"/          Rules:
"/
"/          1. There will be one or more of attributes present, which 
"/             will each be preceded by the above TagX & SizeX values.  
"/             These values are identical to the ATR$C_XXXX and 
"/             ATR$S_XXXX constants which are defined in ATR.H under 
"/             OpenVMS C.  Neither of these values will ever be zero.
"/
"/          2. No word alignment or padding is performed.
"/
"/          3. A well-behaved PKZIP/OpenVMS program should never produce
"/             more than one sub-block with the same TagX value.  Also,
"/             there will never be more than one "extra" block of type
"/             0x000c in a particular directory record.
"/
"/         -UNIX Extra Field (0x000d):
"/
"/          The following is the layout of the UNIX "extra" block.
"/          Note: all fields are stored in Intel low-byte/high-byte 
"/          order.
"/
"/          Value       Size          Description
"/          -----       ----          -----------
"/  (UNIX)  0x000d      2 bytes       Tag for this "extra" block type
"/          TSize       2 bytes       Size for the following data block
"/          Atime       4 bytes       File last access time
"/          Mtime       4 bytes       File last modification time
"/          Uid         2 bytes       File user ID
"/          Gid         2 bytes       File group ID
"/          (var)       variable      Variable length data field
"/
"/          The variable length data field will contain file type 
"/          specific data.  Currently the only values allowed are
"/          the original "linked to" file names for hard or symbolic 
"/          links, and the major and minor device node numbers for
"/          character and block device nodes.  Since device nodes
"/          cannot be either symbolic or hard links, only one set of
"/          variable length data is stored.  Link files will have the
"/          name of the original file stored.  This name is NOT NULL
"/          terminated.  Its size can be determined by checking TSize -
"/          12.  Device entries will have eight bytes stored as two 4
"/          byte entries (in little endian format).  The first entry
"/          will be the major device number, and the second the minor
"/          device number.
"/
"/         -PATCH Descriptor Extra Field (0x000f):
"/
"/          The following is the layout of the Patch Descriptor "extra"
"/          block.
"/
"/          Note: all fields stored in Intel low-byte/high-byte order.
"/
"/          Value     Size     Description
"/          -----     ----     -----------
"/  (Patch) 0x000f    2 bytes  Tag for this "extra" block type
"/          TSize     2 bytes  Size of the total "extra" block
"/          Version   2 bytes  Version of the descriptor
"/          Flags     4 bytes  Actions and reactions (see below) 
"/          OldSize   4 bytes  Size of the file about to be patched 
"/          OldCRC    4 bytes  32-bit CRC of the file to be patched 
"/          NewSize   4 bytes  Size of the resulting file 
"/          NewCRC    4 bytes  32-bit CRC of the resulting file 
"/
"/          Actions and reactions
"/
"/          Bits          Description
"/          ----          ----------------
"/          0             Use for auto detection
"/          1             Treat as a self-patch
"/          2-3           RESERVED
"/          4-5           Action (see below)
"/          6-7           RESERVED
"/          8-9           Reaction (see below) to absent file 
"/          10-11         Reaction (see below) to newer file
"/          12-13         Reaction (see below) to unknown file
"/          14-15         RESERVED
"/          16-31         RESERVED
"/
"/          Actions
"/
"/          Action       Value
"/          ------       ----- 
"/          none         0
"/          add          1
"/          delete       2
"/          patch        3
"/
"/          Reactions
"/
"/          Reaction     Value
"/          --------     -----
"/          ask          0
"/          skip         1
"/          ignore       2
"/          fail         3
"/
"/          Patch support is provided by PKPatchMaker(tm) technology and is 
"/          covered under U.S. Patents and Patents Pending. The use or 
"/          implementation in a product of certain technological aspects set
"/          forth in the current APPNOTE, including those with regard to 
"/          strong encryption, patching, or extended tape operations requires
"/          a license from PKWARE.  Please contact PKWARE with regard to 
"/          acquiring a license. 
"/
"/         -PKCS#7 Store for X.509 Certificates (0x0014):
"/
"/          This field contains information about each of the certificates 
"/          files may be signed with. When the Central Directory Encryption 
"/          feature is enabled for a ZIP file, this record will appear in 
"/          the Archive Extra Data Record, otherwise it will appear in the 
"/          first central directory record and will be ignored in any 
"/          other record.
"/
"/          Note: all fields stored in Intel low-byte/high-byte order.
"/
"/          Value     Size     Description
"/          -----     ----     -----------
"/  (Store) 0x0014    2 bytes  Tag for this "extra" block type
"/          TSize     2 bytes  Size of the store data
"/          TData     TSize    Data about the store
"/
"/
"/         -X.509 Certificate ID and Signature for individual file (0x0015):
"/
"/          This field contains the information about which certificate in 
"/          the PKCS#7 store was used to sign a particular file. It also 
"/          contains the signature data. This field can appear multiple 
"/          times, but can only appear once per certificate.
"/
"/          Note: all fields stored in Intel low-byte/high-byte order.
"/
"/          Value     Size     Description
"/          -----     ----     -----------
"/  (CID)   0x0015    2 bytes  Tag for this "extra" block type
"/          TSize     2 bytes  Size of data that follows
"/          TData     TSize    Signature Data
"/
"/         -X.509 Certificate ID and Signature for central directory (0x0016):
"/
"/          This field contains the information about which certificate in 
"/          the PKCS#7 store was used to sign the central directory structure.
"/          When the Central Directory Encryption feature is enabled for a 
"/          ZIP file, this record will appear in the Archive Extra Data Record, 
"/          otherwise it will appear in the first central directory record.
"/
"/          Note: all fields stored in Intel low-byte/high-byte order.
"/
"/          Value     Size     Description
"/          -----     ----     -----------
"/  (CDID)  0x0016    2 bytes  Tag for this "extra" block type
"/          TSize     2 bytes  Size of data that follows
"/          TData     TSize    Data
"/
"/         -Strong Encryption Header (0x0017):
"/
"/          Value     Size     Description
"/          -----     ----     -----------
"/          0x0017    2 bytes  Tag for this "extra" block type
"/          TSize     2 bytes  Size of data that follows
"/          Format    2 bytes  Format definition for this record
"/          AlgID     2 bytes  Encryption algorithm identifier
"/          Bitlen    2 bytes  Bit length of encryption key
"/          Flags     2 bytes  Processing flags
"/          CertData  TSize-8  Certificate decryption extra field data
"/                             (refer to the explanation for CertData
"/                              in the section describing the 
"/                              Certificate Processing Method under 
"/                              the Strong Encryption Specification)
"/
"/
"/         -Record Management Controls (0x0018):
"/
"/          Value     Size     Description
"/          -----     ----     -----------
"/(Rec-CTL) 0x0018    2 bytes  Tag for this "extra" block type
"/          CSize     2 bytes  Size of total extra block data
"/          Tag1      2 bytes  Record control attribute 1
"/          Size1     2 bytes  Size of attribute 1, in bytes
"/          Data1     Size1    Attribute 1 data
"/            .
"/            .
"/            .
"/          TagN      2 bytes  Record control attribute N
"/          SizeN     2 bytes  Size of attribute N, in bytes
"/          DataN     SizeN    Attribute N data
"/
"/
"/         -PKCS#7 Encryption Recipient Certificate List (0x0019): 
"/
"/          This field contains information about each of the certificates
"/          used in encryption processing and it can be used to identify who is
"/          allowed to decrypt encrypted files.  This field should only appear 
"/          in the archive extra data record. This field is not required and 
"/          serves only to aide archive modifications by preserving public 
"/          encryption key data. Individual security requirements may dictate 
"/          that this data be omitted to deter information exposure.
"/
"/          Note: all fields stored in Intel low-byte/high-byte order.
"/
"/          Value     Size     Description
"/          -----     ----     -----------
"/ (CStore) 0x0019    2 bytes  Tag for this "extra" block type
"/          TSize     2 bytes  Size of the store data
"/          TData     TSize    Data about the store
"/
"/          TData:
"/
"/          Value     Size     Description
"/          -----     ----     -----------
"/          Version   2 bytes  Format version number - must 0x0001 at this time
"/          CStore    (var)    PKCS#7 data blob
"/
"/
"/         -MVS Extra Field (0x0065):
"/
"/          The following is the layout of the MVS "extra" block.
"/          Note: Some fields are stored in Big Endian format.
"/          All text is in EBCDIC format unless otherwise specified.
"/
"/          Value       Size          Description
"/          -----       ----          -----------
"/  (MVS)   0x0065      2 bytes       Tag for this "extra" block type
"/          TSize       2 bytes       Size for the following data block
"/          ID          4 bytes       EBCDIC "Z390" 0xE9F3F9F0 or
"/                                    "T4MV" for TargetFour
"/          (var)       TSize-4       Attribute data (see APPENDIX B)
"/
"/
"/         -OS/400 Extra Field (0x0065):
"/
"/          The following is the layout of the OS/400 "extra" block.
"/          Note: Some fields are stored in Big Endian format.
"/          All text is in EBCDIC format unless otherwise specified.
"/
"/          Value       Size          Description
"/          -----       ----          -----------
"/  (OS400) 0x0065      2 bytes       Tag for this "extra" block type
"/          TSize       2 bytes       Size for the following data block
"/          ID          4 bytes       EBCDIC "I400" 0xC9F4F0F0 or
"/                                    "T4MV" for TargetFour
"/          (var)       TSize-4       Attribute data (see APPENDIX A)
"/
"/
"/          Third-party Mappings:
"/
"/         -ZipIt Macintosh Extra Field (long) (0x2605):
"/
"/          The following is the layout of the ZipIt extra block 
"/          for Macintosh. The local-header and central-header versions 
"/          are identical. This block must be present if the file is 
"/          stored MacBinary-encoded and it should not be used if the file 
"/          is not stored MacBinary-encoded.
"/
"/          Value         Size        Description
"/          -----         ----        -----------
"/  (Mac2)  0x2605        Short       tag for this extra block type
"/          TSize         Short       total data size for this block
"/          "ZPIT"        beLong      extra-field signature
"/          FnLen         Byte        length of FileName
"/          FileName      variable    full Macintosh filename
"/          FileType      Byte[4]     four-byte Mac file type string
"/          Creator       Byte[4]     four-byte Mac creator string
"/
"/
"/         -ZipIt Macintosh Extra Field (short, for files) (0x2705):
"/
"/          The following is the layout of a shortened variant of the
"/          ZipIt extra block for Macintosh (without "full name" entry).
"/          This variant is used by ZipIt 1.3.5 and newer for entries of
"/          files (not directories) that do not have a MacBinary encoded
"/          file. The local-header and central-header versions are identical.
"/
"/          Value         Size        Description
"/          -----         ----        -----------
"/  (Mac2b) 0x2705        Short       tag for this extra block type
"/          TSize         Short       total data size for this block (12)
"/          "ZPIT"        beLong      extra-field signature
"/          FileType      Byte[4]     four-byte Mac file type string
"/          Creator       Byte[4]     four-byte Mac creator string
"/          fdFlags       beShort     attributes from FInfo.frFlags,
"/                                    may be omitted
"/          0x0000        beShort     reserved, may be omitted
"/
"/
"/         -ZipIt Macintosh Extra Field (short, for directories) (0x2805):
"/
"/          The following is the layout of a shortened variant of the
"/          ZipIt extra block for Macintosh used only for directory
"/          entries. This variant is used by ZipIt 1.3.5 and newer to 
"/          save some optional Mac-specific information about directories.
"/          The local-header and central-header versions are identical.
"/
"/          Value         Size        Description
"/          -----         ----        -----------
"/  (Mac2c) 0x2805        Short       tag for this extra block type
"/          TSize         Short       total data size for this block (12)
"/          "ZPIT"        beLong      extra-field signature
"/          frFlags       beShort     attributes from DInfo.frFlags, may
"/                                    be omitted
"/          View          beShort     ZipIt view flag, may be omitted
"/
"/
"/          The View field specifies ZipIt-internal settings as follows:
"/
"/          Bits of the Flags:
"/              bit 0           if set, the folder is shown expanded (open)
"/                              when the archive contents are viewed in ZipIt.
"/              bits 1-15       reserved, zero;
"/
"/
"/         -FWKCS MD5 Extra Field (0x4b46):
"/
"/          The FWKCS Contents_Signature System, used in
"/          automatically identifying files independent of file name,
"/          optionally adds and uses an extra field to support the
"/          rapid creation of an enhanced contents_signature:
"/
"/              Header ID = 0x4b46
"/              Data Size = 0x0013
"/              Preface   = 'M','D','5'
"/              followed by 16 bytes containing the uncompressed file's
"/              128_bit MD5 hash(1), low byte first.
"/
"/          When FWKCS revises a .ZIP file central directory to add
"/          this extra field for a file, it also replaces the
"/          central directory entry for that file's uncompressed
"/          file length with a measured value.
"/
"/          FWKCS provides an option to strip this extra field, if
"/          present, from a .ZIP file central directory. In adding
"/          this extra field, FWKCS preserves .ZIP file Authenticity
"/          Verification; if stripping this extra field, FWKCS
"/          preserves all versions of AV through PKZIP version 2.04g.
"/
"/          FWKCS, and FWKCS Contents_Signature System, are
"/          trademarks of Frederick W. Kantor.
"/
"/          (1) R. Rivest, RFC1321.TXT, MIT Laboratory for Computer
"/              Science and RSA Data Security, Inc., April 1992.
"/              ll.76-77: "The MD5 algorithm is being placed in the
"/              public domain for review and possible adoption as a
"/              standard."
"/
"/
"/         -Info-ZIP Unicode Comment Extra Field (0x6375):
"/
"/          Stores the UTF-8 version of the file comment as stored in the
"/          central directory header. (Last Revision 20070912)
"/
"/          Value         Size        Description
"/          -----         ----        -----------
"/   (UCom) 0x6375        Short       tag for this extra block type ("uc")
"/          TSize         Short       total data size for this block
"/          Version       1 byte      version of this extra field, currently 1
"/          ComCRC32      4 bytes     Comment Field CRC32 Checksum
"/          UnicodeCom    Variable    UTF-8 version of the entry comment
"/
"/          Currently Version is set to the number 1.  If there is a need
"/          to change this field, the version will be incremented.  Changes
"/          may not be backward compatible so this extra field should not be
"/          used if the version is not recognized.
"/
"/          The ComCRC32 is the standard zip CRC32 checksum of the File Comment
"/          field in the central directory header.  This is used to verify that
"/          the comment field has not changed since the Unicode Comment extra field
"/          was created.  This can happen if a utility changes the File Comment 
"/          field but does not update the UTF-8 Comment extra field.  If the CRC 
"/          check fails, this Unicode Comment extra field should be ignored and 
"/          the File Comment field in the header should be used instead.
"/
"/          The UnicodeCom field is the UTF-8 version of the File Comment field
"/          in the header.  As UnicodeCom is defined to be UTF-8, no UTF-8 byte
"/          order mark (BOM) is used.  The length of this field is determined by
"/          subtracting the size of the previous fields from TSize.  If both the
"/          File Name and Comment fields are UTF-8, the new General Purpose Bit
"/          Flag, bit 11 (Language encoding flag (EFS)), can be used to indicate
"/          both the header File Name and Comment fields are UTF-8 and, in this
"/          case, the Unicode Path and Unicode Comment extra fields are not
"/          needed and should not be created.  Note that, for backward
"/          compatibility, bit 11 should only be used if the native character set
"/          of the paths and comments being zipped up are already in UTF-8. It is
"/          expected that the same file comment storage method, either general
"/          purpose bit 11 or extra fields, be used in both the Local and Central
"/          Directory Header for a file.
"/
"/
"/         -Info-ZIP Unicode Path Extra Field (0x7075):
"/
"/          Stores the UTF-8 version of the file name field as stored in the
"/          local header and central directory header. (Last Revision 20070912)
"/
"/          Value         Size        Description
"/          -----         ----        -----------
"/  (UPath) 0x7075        Short       tag for this extra block type ("up")
"/          TSize         Short       total data size for this block
"/          Version       1 byte      version of this extra field, currently 1
"/          NameCRC32     4 bytes     File Name Field CRC32 Checksum
"/          UnicodeName   Variable    UTF-8 version of the entry File Name
"/
"/          Currently Version is set to the number 1.  If there is a need
"/          to change this field, the version will be incremented.  Changes
"/          may not be backward compatible so this extra field should not be
"/          used if the version is not recognized.
"/
"/          The NameCRC32 is the standard zip CRC32 checksum of the File Name
"/          field in the header.  This is used to verify that the header
"/          File Name field has not changed since the Unicode Path extra field
"/          was created.  This can happen if a utility renames the File Name but
"/          does not update the UTF-8 path extra field.  If the CRC check fails,
"/          this UTF-8 Path Extra Field should be ignored and the File Name field
"/          in the header should be used instead.
"/
"/          The UnicodeName is the UTF-8 version of the contents of the File Name
"/          field in the header.  As UnicodeName is defined to be UTF-8, no UTF-8
"/          byte order mark (BOM) is used.  The length of this field is determined
"/          by subtracting the size of the previous fields from TSize.  If both
"/          the File Name and Comment fields are UTF-8, the new General Purpose
"/          Bit Flag, bit 11 (Language encoding flag (EFS)), can be used to
"/          indicate that both the header File Name and Comment fields are UTF-8
"/          and, in this case, the Unicode Path and Unicode Comment extra fields
"/          are not needed and should not be created.  Note that, for backward
"/          compatibility, bit 11 should only be used if the native character set
"/          of the paths and comments being zipped up are already in UTF-8. It is
"/          expected that the same file name storage method, either general
"/          purpose bit 11 or extra fields, be used in both the Local and Central
"/          Directory Header for a file.
"/
"/
"/        -Microsoft Open Packaging Growth Hint (0xa220):
"/
"/          Value         Size        Description
"/          -----         ----        -----------
"/          0xa220        Short       tag for this extra block type
"/          TSize         Short       size of Sig + PadVal + Padding
"/          Sig           Short       verification signature (A028)
"/          PadVal        Short       Initial padding value
"/          Padding       variable    filled with NULL characters
"/
"/
"/      file comment: (Variable)
"/
"/          The comment for this file.
"/
"/      number of this disk: (2 bytes)
"/
"/          The number of this disk, which contains central
"/          directory end record. If an archive is in ZIP64 format
"/          and the value in this field is 0xFFFF, the size will 
"/          be in the corresponding 4 byte zip64 end of central 
"/          directory field.
"/
"/
"/      number of the disk with the start of the central
"/      directory: (2 bytes)
"/
"/          The number of the disk on which the central
"/          directory starts. If an archive is in ZIP64 format
"/          and the value in this field is 0xFFFF, the size will 
"/          be in the corresponding 4 byte zip64 end of central 
"/          directory field.
"/
"/      total number of entries in the central dir on 
"/      this disk: (2 bytes)
"/
"/          The number of central directory entries on this disk.
"/          If an archive is in ZIP64 format and the value in 
"/          this field is 0xFFFF, the size will be in the 
"/          corresponding 8 byte zip64 end of central 
"/          directory field.
"/
"/      total number of entries in the central dir: (2 bytes)
"/
"/          The total number of files in the .ZIP file. If an 
"/          archive is in ZIP64 format and the value in this field
"/          is 0xFFFF, the size will be in the corresponding 8 byte 
"/          zip64 end of central directory field.
"/
"/      size of the central directory: (4 bytes)
"/
"/          The size (in bytes) of the entire central directory.
"/          If an archive is in ZIP64 format and the value in 
"/          this field is 0xFFFFFFFF, the size will be in the 
"/          corresponding 8 byte zip64 end of central 
"/          directory field.
"/
"/      offset of start of central directory with respect to
"/      the starting disk number:  (4 bytes)
"/
"/          Offset of the start of the central directory on the
"/          disk on which the central directory starts. If an 
"/          archive is in ZIP64 format and the value in this 
"/          field is 0xFFFFFFFF, the size will be in the 
"/          corresponding 8 byte zip64 end of central 
"/          directory field.
"/
"/      .ZIP file comment length: (2 bytes)
"/
"/          The length of the comment for this .ZIP file.
"/
"/      .ZIP file comment: (Variable)
"/
"/          The comment for this .ZIP file.  ZIP file comment data
"/          is stored unsecured.  No encryption or data authentication
"/          is applied to this area at this time.  Confidential information
"/          should not be stored in this section.
"/
"/      zip64 extensible data sector    (variable size)
"/
"/          (currently reserved for use by PKWARE)
"/
"/
"/  K.  Splitting and Spanning ZIP files
"/
"/          Spanning is the process of segmenting a ZIP file across 
"/          multiple removable media. This support has typically only 
"/          been provided for DOS formatted floppy diskettes. 
"/
"/          File splitting is a newer derivative of spanning.  
"/          Splitting follows the same segmentation process as
"/          spanning, however, it does not require writing each
"/          segment to a unique removable medium and instead supports
"/          placing all pieces onto local or non-removable locations
"/          such as file systems, local drives, folders, etc...
"/
"/          A key difference between spanned and split ZIP files is
"/          that all pieces of a spanned ZIP file have the same name.  
"/          Since each piece is written to a separate volume, no name 
"/          collisions occur and each segment can reuse the original 
"/          .ZIP file name given to the archive.
"/
"/          Sequence ordering for DOS spanned archives uses the DOS 
"/          volume label to determine segment numbers.  Volume labels
"/          for each segment are written using the form PKBACK#xxx, 
"/          where xxx is the segment number written as a decimal 
"/          value from 001 - nnn.
"/
"/          Split ZIP files are typically written to the same location
"/          and are subject to name collisions if the spanned name
"/          format is used since each segment will reside on the same 
"/          drive. To avoid name collisions, split archives are named 
"/          as follows.
"/
"/          Segment 1   = filename.z01
"/          Segment n-1 = filename.z(n-1)
"/          Segment n   = filename.zip
"/
"/          The .ZIP extension is used on the last segment to support
"/          quickly reading the central directory.  The segment number
"/          n should be a decimal value.
"/
"/          Spanned ZIP files may be PKSFX Self-extracting ZIP files.
"/          PKSFX files may also be split, however, in this case
"/          the first segment must be named filename.exe.  The first
"/          segment of a split PKSFX archive must be large enough to
"/          include the entire executable program.
"/
"/          Capacities for split archives are as follows.
"/
"/          Maximum number of segments = 4,294,967,295 - 1
"/          Maximum .ZIP segment size = 4,294,967,295 bytes
"/          Minimum segment size = 64K
"/          Maximum PKSFX segment size = 2,147,483,647 bytes
"/
"/          Segment sizes may be
! !

!ZipArchive class methodsFor:'instance creation'!

appendFileNamed:name
    ^ self new name:name mode:#append

    "Created: / 31-08-2010 / 11:53:01 / sr"
!

newFileNamed:name
    ^ self new name:name mode:#write
!

oldFileNamed:name
    ^ self new name:name mode:#read.
!

oldFileNamed:name startOfArchive: startOfArchive endOfArchive: endOfArchive
    ^ self new
        setArchiveStartPosition:startOfArchive endPosition:endOfArchive;
        name:name mode:#read.
!

readingFrom:aPositionableStream
    "open an existing Zip archive - read data from aPositionableStream"

    ^ self new readingFrom:aPositionableStream.    
!

writingTo:aPositionableStream
    "open an new Zip archive - write data to aPositionableStream"

    ^ self new writingTo:aPositionableStream.    
! !

!ZipArchive class methodsFor:'Signal constants'!

unsupportedZipFileFormatErrorSignal
    ^ UnsupportedZipFileFormatErrorSignal
!

zipFileFormatErrorSignal
    ^ ZipFileFormatErrorSignal
! !

!ZipArchive class methodsFor:'accessing-default'!

defaultAppendTrailingSlash
    "Returns default trailing slash behavior, For details,
     see class documentation"

    ^DefaultAppendTrailingSlash

    "Created: / 19-11-2012 / 11:53:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultAppendTrailingSlash: aBoolean
    "Sets the default trailing slash behavior, For details,
     see class documentation"
    DefaultAppendTrailingSlash := aBoolean

    "Created: / 19-11-2012 / 11:53:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

zipFileCachingTime:seconds
    "by default, zip files are cached for some time, 
     in case they are reconsulted soon.
     The defualt time is 60s, but can be changed by this setter"
     
    ZipFileCachingTime := seconds
! !

!ZipArchive class methodsFor:'class initialization'!

initialize
    ZipFileFormatErrorSignal isNil ifTrue:[
        ZipFileFormatErrorSignal := OpenError newSignalMayProceed:true.
        ZipFileFormatErrorSignal nameClass:self message:#zipFileFormatErrorSignal.
        ZipFileFormatErrorSignal notifierString:'unrecognized/bad zip file format'.

        UnsupportedZipFileFormatErrorSignal := ZipFileFormatErrorSignal newSignal.
        UnsupportedZipFileFormatErrorSignal nameClass:self message:#unsupportedZipFileFormatErrorSignal.
        UnsupportedZipFileFormatErrorSignal notifierString:'unsupported zip file format'.
    ].

    DefaultAppendTrailingSlash := true.

    "
     self initialize
    "

    "Modified: / 19-11-2010 / 15:44:28 / cg"
    "Modified: / 19-11-2012 / 11:53:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ZipArchive class methodsFor:'cleanup'!

flush
    "forget about cached zipArchives"

    FlushBlock notNil ifTrue:[
        Processor removeTimedBlock:FlushBlock.
    ].
    RecentlyUsedZipArchives := nil. FlushBlock := nil.

    "
     self flush
    "
!

installFlushBlock
    "forget about cached zipArchives"

    FlushBlock isNil ifTrue:[
        FlushBlock := [RecentlyUsedZipArchives := nil. FlushBlock := nil].
    ].
    Processor addTimedBlock:FlushBlock for:Processor timeoutHandlerProcess afterSeconds:(ZipFileCachingTime ? 60).

    "
     self installFlushBlock
    "

    "Created: / 9.4.1998 / 13:17:07 / cg"
    "Modified: / 19.10.1998 / 21:02:22 / cg"
!

lowSpaceCleanup
    "forget about cached zipArchives"

    RecentlyUsedZipArchives := nil

    "
     self lowSpaceCleanup
    "

    "Modified: / 7.4.1998 / 17:58:57 / cg"
! !

!ZipArchive class methodsFor:'constants'!

COMPRESSION_DEFLATED
    <resource: #obsolete>

    "please use compressionDeflated instead (Squeak compat.)"

    self obsoleteMethodWarning.
    ^ COMPRESSION_DEFLATED

    "Created: / 19-11-2010 / 15:40:38 / cg"
!

COMPR_DEFLATED
    <resource: #obsolete>

    "please use compressionDeflated instead (Squeak compat.)"

    self obsoleteMethodWarning.
    ^ COMPRESSION_DEFLATED

    "Modified: / 19-11-2010 / 15:58:28 / cg"
!

LREC_SIZE
    ^ LREC_SIZE

    "Created: / 29.3.1998 / 19:11:20 / cg"
!

centralDirectoryMinimumSize
    ^ 46

    "Created: / 29.3.1998 / 19:11:20 / cg"
!

compressionDeflated
    "same as COMPRESSION_DEFLATED - squeak compatibility"

    ^ COMPRESSION_DEFLATED

    "Modified: / 19-11-2010 / 15:58:39 / cg"
!

compressionStored
    "same as COMPRESSION_STORED - squeak compatibility"

    ^ COMPRESSION_STORED

    "Modified: / 19-11-2010 / 15:59:00 / cg"
!

streamBufferSize
    ^ 65536     "/ 1024 * 64

    "Created: / 29.3.1998 / 19:11:20 / cg"
! !

!ZipArchive class methodsFor:'debugging'!

debugTrace:aBoolean
%{
    if (aBoolean == true) {
        debugTrace = 1;
    } else {
        debugTrace = 0;
    }
%}
! !

!ZipArchive class methodsFor:'queries'!

isZipArchive:aFilename
    "answer true, if aFilename references a Zip archive"

    |f|

    f := aFilename asFilename.
    f exists ifFalse:[^ false].
    f isDirectory ifTrue:[^ false].

    ^ self new checkZipArchive:f.


    "Created: / 29.3.1998 / 17:46:09 / cg"
    "Modified: / 20.10.1998 / 00:30:02 / cg"
! !

!ZipArchive class methodsFor:'utilities'!

dateToZipFileDate:aDate
    "/ data in msdos format
    ^ (((aDate day) 
        bitOr: (aDate month bitShift: 5)) 
        bitOr: (((aDate year) - 1980) bitShift: 9))
!

timeToZipFileTime:aTime
    "/ time in msdos format
    ^ (((aTime seconds // 2) 
        bitOr: (aTime minutes bitShift: 5)) 
        bitOr: (aTime hours bitShift: 11))
! !

!ZipArchive methodsFor:'Compatibility-Squeak'!

binaryContentsOf: fileName
    ^ self extract: fileName asString:false.
!

desiredCompressionMethod:aCompressionMethod
    "for now: ignored"
! !

!ZipArchive methodsFor:'accessing'!

appendTrailingSlash
    "Returns default trailing slash behavior, For details,
     see class documentation"

    appendTrailingSlash isNil ifTrue:[
        appendTrailingSlash := DefaultAppendTrailingSlash 
    ].
    ^appendTrailingSlash

    "Modified: / 19-11-2012 / 12:04:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

appendTrailingSlash:aBoolean
    "Sets trailing slash behavior. If true, all directory entries
     will have a trailing slash in its nama. For details, see class 
     documentation"

    appendTrailingSlash := aBoolean.

    "Modified (comment): / 19-11-2012 / 12:01:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

entries
    "return a collection of fileName entries"

    ^ zipMembersByName keys
!

file
    ^ file
!

fileSize
    file notNil ifTrue:[
        ^ file size
    ].
    ^ 0
!

members
    "return a collection of members"

    ^ zipMembersByName values.
!

membersMatching:aFileMatchPattern
    "return a collection of members which match aFileMatchPattern"

    ^ self zipMembersByName select:[:m | aFileMatchPattern match:m fileName]
!

name
    "return the (file-)name of this zipArchive"

    ^ archiveName
!

numberOfEntries
    "return the number of entries in the archive"

    ^ zipMembersByName size
!

pathName
    "FileStream compatibility: answer the name of the underlying file - a String"

    ^ archiveName
!

setArchiveStartPosition: aStartposition endPosition: anEndPosition
    startOfArchive := aStartposition.
    endOfArchive   := anEndPosition.
!

signatureInformation
    "for compatibility with SignedZipArchive"
    
    ^ nil
!

size
    ^self fileSize
!

zipMembersByName
    ^ zipMembersByName
! !

!ZipArchive methodsFor:'error raising'!

error:anErrorString
    "redefined, to raise ZipFileFormatErrorSignal"

    ZipFileFormatErrorSignal raiseErrorString:anErrorString.
! !

!ZipArchive methodsFor:'open & close'!

close
    file notNil ifTrue:[
        self flush.
        file close.
        file := archiveName := centralDirectory := zipMembersByName := nil.
        firstEntry := lastEntry := nil.
    ].
!

flush
    "finish the zip archive, but do not close the underlying stream"

    (file notNil and:[mode == #write]) ifTrue: [
        self addCentralZipDirectory
    ]
!

name:name mode:readOrWriteMode
    "open read or writestream on archiveFileName"

    |filename members maxStartPosition lastMember|

    filename := name asFilename.
    (readOrWriteMode = #read and:[filename exists not]) ifTrue:[
        ^ OpenError raiseRequestWith:filename errorString:' - file does not exist'.
    ].
    filename isDirectory ifTrue:[
        ^ OpenError raiseRequestWith:filename errorString:' - file is a directory'.
    ].

    file notNil ifTrue: [
        self close.
    ].

    archiveName := filename name.
    mode := readOrWriteMode.

    self openFile.
    mode ~~ #write ifTrue:[
        |mustCloseFile|

        [
            mustCloseFile := true.
            self readDirectory.
            mustCloseFile := false.

            mode == #append ifTrue:[
                members := self zipMembersByName values.
                members isEmptyOrNil ifTrue:[^ self].

                maxStartPosition := members maxApplying:[:eachMember | self dataStartOf:eachMember].
                lastMember := members detect:[:eachMember | eachMember dataStart = maxStartPosition].

                file position:(startOfArchive + lastMember dataStart + lastMember compressedSize).
                mode := #write.
            ].
        ] ensure:[
            mustCloseFile ifTrue:[self close].
        ].
    ] ifFalse:[
        zipMembersByName := Dictionary new.
    ].

    "Modified: / 31-08-2010 / 12:39:25 / sr"
!

readFrom:aPositionableStream
    <resource: #obsolete>
    "initialize the archive to read from aPositionableStream.
     Obsolete - backward compatibility."

    self obsoleteMethodWarning.
    ^ self readingFrom:aPositionableStream
!

readingFrom:aPositionableStream
    "initialize the archive to read from aPositionableStream"

    file notNil ifTrue: [
        file ~~ aPositionableStream ifTrue: [
            self close.
        ].
    ].

    mode := #read.
    aPositionableStream binary.
    file := aPositionableStream.
    aPositionableStream isFileStream ifTrue:[
        archiveName := aPositionableStream pathName.
        aPositionableStream isDirectory ifTrue:[
            OpenError raiseWith:self errorString:(' - is a directory').
        ].        
    ] ifFalse:[
        archiveName := 'internal stream'.
    ].
    self readDirectory.

    "Modified: / 21-11-2010 / 11:45:53 / cg"
!

reopenForReading
    file isNil ifTrue:[
        mode := #read.
        file := archiveName asFilename readStream.
        file binary
    ]

    "Created: / 21-11-2010 / 12:02:37 / cg"
!

writingTo:aPositionableStream
    "initialize the archive to write to aPositionableStream"

    file notNil ifTrue: [
        self close.
    ].

    mode := #write.
    aPositionableStream binary.
    file := aPositionableStream.
    aPositionableStream isFileStream ifTrue:[
        archiveName := aPositionableStream pathName.
    ] ifFalse:[
        archiveName := 'internal stream'.
    ].
    zipMembersByName := Dictionary new.
! !

!ZipArchive methodsFor:'private'!

closeFile
    <resource: #obsolete>
    "backward compatibility"

    self obsoleteMethodWarning:'use #close'.

    self close.
!

dataStartOf:zipEntry
    "fetch the absolute start address of the data of a given zipEntry.
     Note: extra field and extra field length may be different from that in
           the central directory entry. Sow e have to fetch the local header."

    |dataStart fileHeaderStart fileNameLength extraFieldLength|

    dataStart := zipEntry dataStart.
    dataStart notNil ifTrue:[
        ^ dataStart.
    ].

    fileHeaderStart := zipEntry relativeLocalHeaderOffset + startOfArchive.
    (fileHeaderStart + 30) > endOfArchive ifTrue: [
        ^ ZipFileFormatErrorSignal raiseRequestErrorString:' - zipEntry end is out of the archive bounds'.
    ].

    "Now read the fileHeader:
        0  local file header signature     4 bytes  (0x04034b50)
        4  version needed to extract       2 bytes
        6  general purpose bit flag        2 bytes
        8  compression method              2 bytes
        10 last mod file time              2 bytes
        12 last mod file date              2 bytes
        14 crc-32                          4 bytes
        18 compressed size                 4 bytes
        22 uncompressed size               4 bytes
        26 file name length (x)            2 bytes
        28 extra field length (y)          2 bytes
              fixd size total len:    30
        30 file name (variable size)
        30+x    extra field (variable size)
        30+x+y  data
     Note: extra field and extra field length may be different from that in
           the central directory entry!!
    "

    file position:fileHeaderStart+26.
    fileNameLength := file nextUnsignedInt16MSB:false.
    extraFieldLength := file nextUnsignedInt16MSB:false.

    dataStart := fileHeaderStart + 30 + fileNameLength + extraFieldLength.

    (dataStart + (zipEntry compressedSize)) > endOfArchive ifTrue: [
        ^ ZipFileFormatErrorSignal raiseRequestErrorString:' - zipEntry end is out of the archive bounds'.
    ].
    zipEntry dataStart:dataStart.

    ^ dataStart
!

openFile
    |fn|

    file isNil ifTrue:[
        fn := archiveName asFilename.
        mode ~~ #write ifTrue:[
            mode == #append ifTrue:[
                file := fn readWriteStream.
            ] ifFalse:[
                file := fn readStream.
            ].
        ] ifFalse:[
            file := fn writeStream
        ].
        file binary.
    ].

    "Modified: / 31-08-2010 / 12:40:41 / sr"
!

setDefaultArchiveBounds
    "set start and end of archive if it is nil. That means no bounds have been defined
     before. In that case the archive is the complete file."

    startOfArchive isNil ifTrue: [
        "/ set archive zero position
        startOfArchive := 0.
    ].

    endOfArchive isNil ifTrue: [
        "/ set archive end position
        endOfArchive := file size.
    ].
!

validZipFileNameFrom:zipFileName
    |fileNameParts partCol partOfPartCol validZipFileName theElement|
    fileNameParts := OrderedCollection new.

    partCol := zipFileName asCollectionOfSubstringsSeparatedBy:$\.
    partCol do:[:aSegm|
        partOfPartCol := aSegm asCollectionOfSubstringsSeparatedBy:$/.
        partOfPartCol do:[:nextSegm|
            fileNameParts add: nextSegm.
        ].
    ].

    fileNameParts do:[:anElement|
        anElement notEmptyOrNil ifTrue:[    
            theElement := anElement.
"/ disabled by sr - no reason to not allow spaces in a fileName
"/            (anElement includes:$ ) ifTrue:[ 
"/                theElement := (anElement replString:' ' withString:'').
"/            ].

            validZipFileName isNil ifTrue:[
                validZipFileName := theElement.
            ] ifFalse:[
                validZipFileName := (validZipFileName, '/', theElement).
            ].
        ].
    ].

    validZipFileName isEmptyOrNil ifTrue:[
        ^ ZipFileFormatErrorSignal raiseRequestErrorString: (' - invalid zip file name ', zipFileName).
    ].

    ^ validZipFileName

"
    ZipArchive new validZipFileNameFrom:'hello//world'
    ZipArchive new validZipFileNameFrom:'hello\\world'
    ZipArchive new validZipFileNameFrom:'hello\/world'
    ZipArchive new validZipFileNameFrom:'hello/\world'
    ZipArchive new validZipFileNameFrom:'hello/\world/aaa bbb/ccc'
"
! !

!ZipArchive methodsFor:'private - decompression'!

decode:rawBytes method:compressionMethod size:uncompressedSize
    "decode rawBytes into a byteArray"

    ^ self
        decode:rawBytes 
        method:compressionMethod 
        size:uncompressedSize
        asString:false
!

decode:rawBytes method:compressionMethod size:uncompressedSize asString:asString
    "decode rawBytes into a byteArray or string"

    |outBytes|

    compressionMethod == COMPRESSION_STORED ifTrue:[
        "/
        "/ uncompressed
        "/
        asString ifTrue:[^ rawBytes asString].
        ^ rawBytes
    ].

    compressionMethod == COMPRESSION_DEFLATED ifTrue:[
        "/
        "/ deflate/inflate algorithm
        "/
        asString ifTrue:[
            outBytes := String new:uncompressedSize.
        ] ifFalse:[
            outBytes := ByteArray new:uncompressedSize.
        ].
        ^ self inflate:rawBytes to:outBytes
    ].

    "/
    "/ the other algorithms are not (yet) supported
    "/
    compressionMethod == COMPRESSION_SHRUNK ifTrue:[
        self error:'unsupported compression method: SHRUNK'.
        ^ nil
    ].
    compressionMethod == COMPRESSION_REDUCED1 ifTrue:[
        self error:'unsupported compression method: REDUCED1'.
        ^ nil
    ].
    compressionMethod == COMPRESSION_REDUCED2 ifTrue:[
        self error:'unsupported compression method: REDUCED2'.
        ^ nil
    ].
    compressionMethod == COMPRESSION_REDUCED3 ifTrue:[
        self error:'unsupported compression method: REDUCED3'.
        ^ nil
    ].
    compressionMethod == COMPRESSION_REDUCED4 ifTrue:[
        self error:'unsupported compression method: REDUCED4'.
        ^ nil
    ].
    compressionMethod == COMPRESSION_IMPLODED ifTrue:[
        self error:'unsupported compression method: IMPLODED'.
        ^ nil
    ].
    compressionMethod == COMPRESSION_TOKENIZED ifTrue:[
        self error:'unsupported compression method: TOKENIZED'.
        ^ nil
    ].

    self error:'unsupported compression method'.
    ^ nil

    "Created: / 29-03-1998 / 20:14:45 / cg"
    "Modified: / 19-11-2010 / 15:39:49 / cg"
!

inflate:inBytes to:outBytes
    |inflateReturnCode|

%{  /* STACK:32768 */
    char *in, *out;

    if (__isByteArrayLike(inBytes)) {
        in = __byteArrayVal(inBytes);
    } else if (__isStringLike(inBytes)) {
        in = __stringVal(inBytes);
    } else {
        inflateReturnCode = @symbol(badArgument1);
        goto badArgument;
    }

    if (__isByteArray(outBytes)) {
        out = __byteArrayVal(outBytes);
    } else if (__isString(outBytes)) {
        out = __stringVal(outBytes);
    } else {
        inflateReturnCode = @symbol(badArgument2);
        goto badArgument;
    }

    {
        int rc = stx_inflate(in, out);

        if (rc == 0) {
            RETURN (outBytes);
        }
        inflateReturnCode = __MKSMALLINT(rc);
    }
badArgument: ;
%}.
    inflateReturnCode notNil ifTrue:[
        inflateReturnCode isSymbol ifTrue:[
            self primitiveFailed:inflateReturnCode
        ].

        "/ bad blockType 2
        self error:'inflate error: ' , inflateReturnCode printString
    ].
    ^ nil.

    "Created: / 8.4.1998 / 10:31:27 / cg"
! !

!ZipArchive methodsFor:'private - directory stuff'!

addCentralZipDirectory 
    |noEntries|

    centralDirectory isNil ifTrue: [
        centralDirectory := ZipCentralDirectory new default.
    ].

    noEntries := 0.

    "/ ensure that the file position is at end
    file setToEnd.

    centralDirectory centralDirectoryStartOffset: file position.

    self zipMembersDo:[:zipEntry |
        noEntries := noEntries + 1.
        file nextPutInt32LSB: C_CENTRAL_HEADER_SIGNATURE.            
        file nextPutInt16LSB:zipEntry versionMadeBy.
        file nextPutInt16LSB:zipEntry versionNeedToExtract.
        file nextPutInt16LSB:zipEntry generalPurposBitFlag.
        file nextPutInt16LSB:zipEntry compressionMethod.
        file nextPutInt16LSB:zipEntry lastModFileTime.
        file nextPutInt16LSB:zipEntry lastModFileDate.
        file nextPutInt32LSB:zipEntry crc32.
        file nextPutInt32LSB:zipEntry compressedSize.
        file nextPutInt32LSB:zipEntry uncompressedSize.
        file nextPutInt16LSB:zipEntry fileNameLength.
        file nextPutInt16LSB:zipEntry extraFieldLength.
        file nextPutInt16LSB:zipEntry fileCommentLength.
        file nextPutInt16LSB:zipEntry diskNumberStart.
        file nextPutInt16LSB:zipEntry internalFileAttributes.
        file nextPutInt32LSB:zipEntry externalFileAttributes.
        file nextPutInt32LSB:zipEntry relativeLocalHeaderOffset.

        self assert:zipEntry fileNameLength = zipEntry fileName size.
        file nextPutAll:zipEntry fileName.

        zipEntry extraField notNil ifTrue: [
            self assert:zipEntry extraFieldLength = zipEntry extraField size.
            file nextPutAll:zipEntry extraField.
        ].
        zipEntry fileComment notNil ifTrue: [
            self assert:zipEntry fileCommentLength = zipEntry fileComment size.
            file nextPutAll:zipEntry fileComment.
        ].
    ].

    centralDirectory centralDirectoryTotalNoOfEntries: noEntries.
    centralDirectory centralDirectoryTotalNoOfEntriesOnThisDisk: noEntries.
    centralDirectory centralDirectorySize: (file position) - (centralDirectory centralDirectoryStartOffset).

    file nextPutByte:($P codePoint).
    file nextPutByte:($K codePoint).
    file nextPutByte:8r005.
    file nextPutByte:8r006.
    file nextPutInt16LSB:centralDirectory numberOfThisDisk.
    file nextPutInt16LSB:centralDirectory centralDirectoryStartDiskNumber.
    file nextPutInt16LSB:centralDirectory centralDirectoryTotalNoOfEntriesOnThisDisk.
    file nextPutInt16LSB:centralDirectory centralDirectoryTotalNoOfEntries.
    file nextPutInt32LSB:centralDirectory centralDirectorySize.
    file nextPutInt32LSB:centralDirectory centralDirectoryStartOffset.
    file nextPutInt16LSB:centralDirectory zipCommentLength.

    centralDirectory zipCommentLength ~~ 0 ifTrue: [
        file nextPutAll: centralDirectory zipComment.
    ].

    "Modified: / 19-11-2010 / 16:23:36 / cg"
!

addMember:zmemb
    "add a zipMember"

    (firstEntry isNil) ifTrue:[
        firstEntry := zmemb
    ] ifFalse:[
        lastEntry next:zmemb.
    ].
    lastEntry := zmemb.
    (zipMembersByName includesKey:zmemb fileName) ifTrue:[
        "ignore duplicate entries for backward compatibility.
         Argh: expecco once added wrong duplicates to the end of ets files.
               The first entry is valid."
        Logger warning:'duplicate entry in ZIP file ignored: %1' with:zmemb fileName.
    ] ifFalse:[
        zipMembersByName at:zmemb fileName put:zmemb.
    ].
    ^ zmemb.

    "Modified: / 30-03-1998 / 17:13:20 / cg"
    "Created: / 09-09-1998 / 20:33:06 / cg"
    "Modified: / 09-11-2015 / 11:51:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkZipArchive
    "check if my file is really a zip archive. answer true or false."

    |size count_in|

    file isNil ifTrue: [
        ^ false
    ].

    self setDefaultArchiveBounds.

    size := endOfArchive - startOfArchive.
    (size == 0) ifTrue:[
        count_in := 0.
        ^ false
    ].

    (size < (ECREC_SIZE+4)) ifTrue:[
        ^ false.
    ].

    ^ self searchForEndOfCentralDirectorySignature
!

checkZipArchive:archiveFileName
    |isValidArchive|

    archiveName := archiveFileName asFilename name.
    isValidArchive := false.
    mode := #read.
    self openFile.

    [
        isValidArchive := self checkZipArchive.
    ] ensure:[
        self close.
    ].
    ^ isValidArchive
!

findMember:name
    "find a zipMember by name"

    zipMembersByName isNil ifTrue:[^ nil].
    ^ zipMembersByName at:name ifAbsent:[].
!

findMemberAllowForMissingTrailingSlash: name
    "find a zipMember by name. Allow for missing trailing slash for directories.
     This method is currently used by JavaVM"
    | nameWithSlash |

    nameWithSlash := name , '/'.

    self zipMembersDo:[:each |
        | fn |

        fn := each fileName.
        (fn = name) ifTrue:[^ each].
        "Try if they differ only in trailing slash"
        ((fn size) = (name size + 1) 
            and:[fn = nameWithSlash]) ifTrue:[ 
                "/Here, return a copy with patched name:
                ^each copy
                    fileName: name;
                    yourself.
            ]
    ].
    ^ nil

    "Created: / 20-07-2012 / 19:33:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

findMemberForWhich:aBlock
    "find a zipMember by condition"

    self zipMembersDo:[:zipd |
        (aBlock value:zipd) ifTrue:[^ zipd].
    ].
    ^ nil

    "Created: / 12-04-2011 / 17:20:40 / cg"
!

readDirectory
    "read the zip directory into a linked-list of zipMembers"

    |size pos0|

    self setDefaultArchiveBounds.

    size := endOfArchive - startOfArchive.
    (size == 0) ifTrue:[
        ^ self
    ].

    (size < (ECREC_SIZE+4)) ifTrue:[
        ^ ZipFileFormatErrorSignal raiseRequestErrorString:' - zipfile too short'.
    ].

    self searchForEndOfCentralDirectorySignature ifFalse: [
        ^ ZipFileFormatErrorSignal raiseRequestErrorString:' - could not find end of directory signature'.
    ].

    "/ position before end of central directory signature
    pos0 := file position - 4.

    "/ Now we have found the end of central directory record
    centralDirectory := ZipCentralDirectory new.
    EndOfStreamNotification handle:[:ex|
        ZipFileFormatErrorSignal raiseRequestErrorString:' - file format error or short file: ' ,
                                        (file isFileStream ifTrue:[file pathName] ifFalse:['inStream']).
        ^ self.
    ] do:[
        centralDirectory readFrom:file.

        "/ set file position to start of central directory
        (pos0 - centralDirectory centralDirectoryStartOffset - centralDirectory centralDirectorySize) < startOfArchive ifTrue: [
            ^ ZipFileFormatErrorSignal raiseRequestErrorString:' - central directory start is out of the archive bounds'.
        ].

        startOfArchive := pos0 - centralDirectory centralDirectoryStartOffset - centralDirectory centralDirectorySize.
        file position:(pos0 - (centralDirectory centralDirectorySize)).

        zipMembersByName := Dictionary new:centralDirectory centralDirectoryTotalNoOfEntries.

        "/ read central directory entries
        1 to:(centralDirectory centralDirectoryTotalNoOfEntries) do:[:i |
            |zipd filename_length centralFileHeaderSignature relative_offset_local_header 
             posOfNextMember extra|

            (file position + (self class centralDirectoryMinimumSize)) > endOfArchive ifTrue: [
                ^ ZipFileFormatErrorSignal raiseRequestErrorString:' - central directory entry out of archive bounds'.
            ].
            centralFileHeaderSignature := file nextInt32MSB:false.            
            centralFileHeaderSignature ~= C_CENTRAL_HEADER_SIGNATURE ifTrue:[
                ZipFileFormatErrorSignal raiseRequestErrorString:' - file format error - bad centralHeaderSignature in: ' ,
                                                (file isFileStream ifTrue:[file pathName] ifFalse:['inStream']).
                ^ self.
            ].

            zipd := ZipMember new readCentralDirectoryEntryFrom:file.
            self addMember:zipd.
        ].

        (file position + 6) > endOfArchive ifTrue: [
            "/ archive has no digital signature
            ^ self.
        ].

        "/ check for digital signature
        ((file nextByte ~~ ($P codePoint))
         or:[file nextByte ~~ ($K codePoint)
         or:[file nextByte ~~ 8r005
         or:[file nextByte ~~ 8r005]]]) ifTrue:[
            centralDirectory readDigitalSignatureFrom:file.
        ].
    ]

    "
     ZipArchive flush.
     ZipArchive oldFileNamed:'/usr/lib/jdk1.1.7/lib/classes.zip'
     ZipArchive oldFileNamed:'/usr/lib/jdk1.1.8/lib/classes.zip'
    "

    "Modified: / 19-11-2010 / 15:43:24 / cg"
!

searchForEndOfCentralDirectorySignature
    "read the zip directory into a linked-list of zipMembers"

    |size foundPK pos0 searchEndPos|

    foundPK := false.
    size := endOfArchive - startOfArchive.
    file position:(pos0 := endOfArchive - ECREC_SIZE - 4).

    "/ set position to end of central directory record
    ((file nextByte ~~ ($P codePoint))
    or:[file nextByte ~~ ($K codePoint)
    or:[file nextByte ~~ 8r005
    or:[file nextByte ~~ 8r006]]]) ifTrue:[
        "/ search from end of archive backwards for "end of central directory signature", 
        "/ this is necessary if the archive includes a .ZIP file comment or a digital signature
        "/ then the end of the directory signature may be on an other position

        "/ but the "end of central directory signature" must be located in the 
        "/ last 64k of the archive
        size > 65536 ifTrue: [
            searchEndPos := (endOfArchive - 65536).
        ] ifFalse: [
            searchEndPos := startOfArchive.
        ].

        file position: (pos0 := endOfArchive - 4).

        [foundPK] whileFalse: [
            (file nextByte == ($P codePoint)
            and:[file nextByte == ($K codePoint)
            and:[file nextByte == 8r005
            and:[file nextByte == 8r006]]]) ifTrue:[
                ^ true                
            ].
            file position <= searchEndPos ifTrue: [
                ^ false.
            ].
            pos0 == 0 ifTrue:[
                ^ false.
            ].
            file position: (pos0 := pos0 - 1).
        ].
        ^ false
    ].
    ^ true
!

zipMembersDo:aBlock
    "evaluate aBlock for all zipMembers"

    |zipd|

    zipd := firstEntry.
    [zipd notNil] whileTrue:[
        aBlock value:zipd.
        zipd := zipd next
    ].

    "Created: / 29.3.1998 / 19:15:15 / cg"
    "Modified: / 30.3.1998 / 17:13:47 / cg"
! !

!ZipArchive methodsFor:'queries'!

isValidPath: anArchivePathName
    self zipMembersByName
        keysDo:[:eachMemberName |
            ((eachMemberName startsWith:anArchivePathName,'/') 
             or:[eachMemberName = anArchivePathName]) ifTrue:[^ true]
        ].

    ^ false.
! !

!ZipArchive methodsFor:'reading'!

extract:fileName
    "extract an entry identified by fileName as a byteArray;
     nil on errors"

    ^ self extract:fileName asString:false
!

extract:fileName asString:asString
    "extract an entry identified by fileName as a byteArray or string;
     nil on errors"

    self 
        withPositionAndMemberFor:fileName 
        do:[:zmemb :position |
            |rawContents data|

            file position:position.
            rawContents := file nextBytes:(zmemb compressedSize).

            data := self
                decode:rawContents
                method:(zmemb compressionMethod)
                size:(zmemb uncompressedSize)
                asString:asString.

            ^ data.
        ].

    ^ nil

    "Modified: / 21-11-2010 / 11:53:00 / cg"
    "Modified: / 22-12-2010 / 12:24:54 / sr"
!

restoreOsDirectory:osDirectoryName fromArchiveDirectory: archiveDirectoryName
    |osDirectory directoryAlreadyCreated archiveDirectoryNameSize|

    osDirectory := osDirectoryName asFilename.
    directoryAlreadyCreated := osDirectory exists.
    (directoryAlreadyCreated and: [osDirectory isDirectory not]) ifTrue:[
        "no way to create the base directory - done"
        OperatingSystem accessDeniedErrorSignal
            raiseRequestWith:osDirectory
            errorString:(' - ZipArchive - cannot create base directory: ' , osDirectory asString).
        ^ self.
    ].

    archiveDirectoryNameSize := archiveDirectoryName size.

    self members do: [:eachZipArchiveMember|
        |eachZipArchiveMemberName baseName directory fileNameOrDirectoryEntry|

        eachZipArchiveMemberName := eachZipArchiveMember fileName.

        ((eachZipArchiveMemberName startsWith:archiveDirectoryName)
         and:[eachZipArchiveMemberName size = archiveDirectoryNameSize
              or:[(eachZipArchiveMemberName at:archiveDirectoryNameSize+1) == $/]]) ifTrue: [

            directoryAlreadyCreated ifFalse:[
                osDirectory recursiveMakeDirectory.
                directoryAlreadyCreated := true.
            ].
            baseName := eachZipArchiveMemberName copyFrom:(archiveDirectoryNameSize+1).
            (baseName notEmpty and:[baseName first == $/]) ifTrue:[
                baseName := baseName copyFrom:2.
            ].

            baseName notEmpty ifTrue:[
                fileNameOrDirectoryEntry := osDirectory construct:baseName.

                "Note, that a ZipArchive usually does not contain entries for directories!!"
                (eachZipArchiveMember externalFileAttributes bitTest:EXTERNALFILEATTRIBUTES_ISDIRECTORY) ifTrue:[
                    fileNameOrDirectoryEntry recursiveMakeDirectory.
                ] ifFalse: [
                    "make sure, that the directory exists"
                    directory := fileNameOrDirectoryEntry directory.
                    directory isDirectory ifFalse:[
                        directory recursiveMakeDirectory.
                    ].
                    
                    fileNameOrDirectoryEntry writingFileDo:[:aStream|
                        self 
                            extract:eachZipArchiveMemberName 
                            intoStream: aStream.
                    ].
                ].
            ].
        ]
    ].
!

withPositionAndMemberFor:fileName do:aBlock
    |zmemb dataStart|

    (file isNil or:[mode ~~ #read]) ifTrue:[
        ^ self error: 'ZipArchive not open for reading ...'.
    ].    

    zmemb := self findMember:fileName.
    zmemb isNil ifTrue:[^ nil].

    dataStart := self dataStartOf:zmemb.
    aBlock value:zmemb value:dataStart.

    "Created: / 21-11-2010 / 11:51:41 / cg"
! !

!ZipArchive methodsFor:'reading - stream'!

extract:fileName intoStream: aWriteStream
    "extract an entry indentified by filename into aWriteStream"

    self 
        withPositionAndMemberFor:fileName 
        do:[:zmemb :position |
            |buffer rdSize compressionMethod nextBlockSize streamBufferSize myZipStream|

            file position:position.

            compressionMethod := zmemb compressionMethod.
            rdSize := zmemb uncompressedSize.
            nextBlockSize := streamBufferSize := self class streamBufferSize.    
            buffer := ByteArray new: streamBufferSize.
            [
                [rdSize > 0] whileTrue: [
                    rdSize < streamBufferSize ifTrue: [
                        nextBlockSize := rdSize.
                    ].

                    compressionMethod == COMPRESSION_DEFLATED ifTrue:[
                        myZipStream isNil ifTrue: [
                            file binary.
                            myZipStream := ZipStream readOpenAsZipStreamOn:file suppressHeaderAndChecksum:true.
                        ].
                        myZipStream next:nextBlockSize into:buffer startingAt:1.
                    ] ifFalse:[compressionMethod == COMPRESSION_STORED ifTrue:[
                        file nextBytes:nextBlockSize into:buffer startingAt:1.
                    ] ifFalse:[
                        UnsupportedZipFileFormatErrorSignal raiseErrorString:'unsupported compressMethod'
                    ]].

                    aWriteStream nextPutBytes:nextBlockSize from:buffer startingAt:1.
                    rdSize := rdSize - nextBlockSize.
                ].
            ] ensure:[
                myZipStream notNil ifTrue:[
                    myZipStream close.
                ].
            ].
        ]

    "Modified: / 21-11-2010 / 11:56:51 / cg"
!

readStreamFor:nameOfFileInArchive
    "open a stream on archive contents identified by nameOfFileInArchive"

    |zipEntry dataStart|

    (file isNil or:[mode ~~ #read]) ifTrue:[
        ^ OpenError raiseRequestWith:nameOfFileInArchive errorString:'ZipArchive not open for reading ...'.
    ].    

    zipEntry := self findMember:nameOfFileInArchive.
    zipEntry isNil ifTrue:[
        ^ OpenError raiseRequestWith:nameOfFileInArchive errorString:'ZipArchive member does not exist: '.
    ].

    dataStart := self dataStartOf:zipEntry.
    file position:dataStart.

    ^ (ZipReadStream zipFileStream:file zipEntry:zipEntry)
        zipArchive:self.
!

reopenAndExtract:fileName intoStream: aWriteStream
    "extract an entry indentified by filename into aWriteStream"

    file isNil ifTrue:[
        self reopenForReading.
    ].
    self extract:fileName intoStream: aWriteStream.
    file close.
    file := nil.

    "Created: / 21-11-2010 / 11:59:04 / cg"
! !

!ZipArchive methodsFor:'writing'!

addArchiveDirectory: archiveDirectoryName fromOsDirectory: osDirectoryName
    ^ self addArchiveDirectory: archiveDirectoryName fromOsDirectory: osDirectoryName compressMethod: 0
!

addArchiveDirectory: archiveDirectoryName fromOsDirectory: osDirectoryName compressMethod: theCompressMethod
    |osDirectory fileNameOrDirectoryEntry|

    osDirectory := osDirectoryName asFilename.
    osDirectory exists ifFalse:[
        ^ self
    ].

    "do not create directories (isDirectory = true) - they are not compatible between operating systems"
"/    self addDirectory: archiveDirectoryName.
    osDirectory recursiveDirectoryContentsDo: [:entry|
        fileNameOrDirectoryEntry := osDirectory construct: entry. 
        fileNameOrDirectoryEntry isDirectory ifTrue: [
"/            self addDirectory: (archiveDirectoryName, '/', entry).
        ] ifFalse: [
            fileNameOrDirectoryEntry readingFileDo: [:aStream|    
                self addFile: (archiveDirectoryName, '/', entry) 
                     fromStream: aStream 
                     compressMethod: theCompressMethod
                     asDirectory:false.
            ].
        ].
    ].
!

addArchiveDirectoryCompressed: archiveDirectoryName fromOsDirectory: osDirectoryName
    ^ self addArchiveDirectory: archiveDirectoryName fromOsDirectory: osDirectoryName compressMethod:COMPRESSION_DEFLATED

    "Modified: / 19-11-2010 / 15:58:04 / cg"
!

addDirectory: aDirectoryName
    "do not create directories (isDirectory = true) - they are not compatible between operating systems"

    <resource: #obsolete>

    self obsoleteMethodWarning.
    ^ self addFile:aDirectoryName withContents:nil compressMethod:COMPRESSION_STORED asDirectory:true.

    "Modified: / 19-11-2010 / 15:38:59 / cg"
!

addFile: aFileName fromStream: aStream
    ^ self addFile: aFileName fromStream: aStream compressMethod:COMPRESSION_STORED asDirectory:false

    "Modified: / 19-11-2010 / 15:39:02 / cg"
!

addFile:aFileName fromStream:aStream compressMethod: theCompressMethodArg
    ^ self addFile:aFileName fromStream:aStream compressMethod:theCompressMethodArg asDirectory:false
!

addFile:aFileName fromStream:aStream compressMethod:theCompressMethodArg asDirectory:isDirectory
    "do not create directories (isDirectory = true) - they are not compatible between operating systems"

    |zipEntry theZipFileName theCompressMethod streamBufferSize buffer 
     crc32 unCompressedDataSize startDataPosition nextBlockSize myZipStream|

    (file isNil or: [mode ~~ #write]) ifTrue: [
        ^ self error: 'ZipArchive not open for writing ...'.
    ].

    theCompressMethod := theCompressMethodArg.

    ((theCompressMethod == COMPRESSION_DEFLATED) 
    or:[ theCompressMethod == COMPRESSION_STORED ]) ifFalse:[
        UnsupportedZipFileFormatErrorSignal raiseRequestErrorString:'unsupported compressMethod'.
        "/ if proceeded, write as uncompressed
        theCompressMethod := COMPRESSION_STORED
    ].

    zipEntry := ZipMember new default.
    theZipFileName := self validZipFileNameFrom:aFileName. 

    zipEntry fileName: theZipFileName.
    zipEntry uncompressedSize: 0.

    isDirectory ifTrue: [
        theCompressMethod := COMPRESSION_STORED.
        zipEntry externalFileAttributes: EXTERNALFILEATTRIBUTES_ISDIRECTORY.
    ] ifFalse: [
        zipEntry compressionMethod: theCompressMethod.
        zipEntry internalFileAttributes: 1.
        zipEntry externalFileAttributes: EXTERNALFILEATTRIBUTES_ISFILE.
    ].

    "/ data and time in msdos format
    zipEntry setModificationTimeAndDateToNow.

    "/ ensure that the file position is at the end
    file setToEnd.

    zipEntry writeTo:file.

    streamBufferSize := self class streamBufferSize.    
    buffer := ByteArray new:streamBufferSize.
    crc32 := 0.
    unCompressedDataSize := 0.
    startDataPosition := file position.

    [
        [aStream atEnd] whileFalse: [
            nextBlockSize := aStream nextBytes:streamBufferSize into:buffer startingAt:1.

            nextBlockSize > 0 ifTrue: [
                unCompressedDataSize := unCompressedDataSize + nextBlockSize.
                crc32 := ZipStream crc32BytesIn: buffer from:1 to:nextBlockSize crc:crc32.
                theCompressMethod == COMPRESSION_DEFLATED ifTrue: [
                    myZipStream isNil ifTrue: [
                        myZipStream := ZipStream writeOpenAsZipStreamOn:file suppressHeaderAndChecksum:true.
                    ].
                    myZipStream nextPutBytes:nextBlockSize from:buffer startingAt:1.
                ] ifFalse: [theCompressMethod == COMPRESSION_STORED ifTrue: [
                    file nextPutBytes:nextBlockSize from:buffer startingAt:1.
                ] ifFalse:[
                    UnsupportedZipFileFormatErrorSignal raiseRequestErrorString:'unsupported compressMethod'.
                ]].
            ].
        ].
    ] ensure:[
        myZipStream notNil ifTrue:[
            myZipStream close.
        ].
    ].

    zipEntry compressedSize:(file position) - startDataPosition.

    "/ crc32 is always required (not as written in docu to be zero in case of uncompressed mode)
    zipEntry crc32:crc32.
    zipEntry uncompressedSize: unCompressedDataSize.

    zipEntry rewriteCrcAndSizeTo:file.
    self addMember:zipEntry.

    file setToEnd.

    "Modified: / 19-11-2010 / 15:39:32 / cg"
!

addFile: aFileName withContents: data
    ^ self addFile: aFileName withContents: data compressMethod:COMPRESSION_STORED asDirectory: false.

    "Modified: / 19-11-2010 / 15:39:13 / cg"
!

addFile:aFileName withContents:data compressMethod:theCompressMethodArg asDirectory:isDirectory
    "do not create directories (isDirectory = true) - they are not compatible between operating systems"

    ^ self basicAddFile:aFileName withContents:data compressMethod:theCompressMethodArg asDirectory:isDirectory

    "Modified: / 18-11-2010 / 19:31:36 / cg"
!

addFileCompressed: aFileName fromStream: aStream
    ^ self addFile: aFileName fromStream: aStream compressMethod: COMPRESSION_DEFLATED asDirectory:false

    "Modified: / 19-11-2010 / 15:58:07 / cg"
!

addFileCompressed: aFileName withContents: data
    ^ self addFile: aFileName withContents: data compressMethod: COMPRESSION_DEFLATED asDirectory: false.

    "Modified: / 19-11-2010 / 15:58:10 / cg"
!

addString: aString as: path
    ^ self addFile: path fromStream: (aString readStream)

    "Modified: / 19-11-2010 / 17:47:26 / cg"
!

basicAddFile:aFileName withContents:data compressMethod:theCompressMethodArg asDirectory:isDirectory 
    "do not create directories (isDirectory = true) - they are not compatible between operating systems"
    
    | zipEntry theCompressedData theZipFileName theCompressMethod  compressedDataOffset|

    (file isNil or:[ mode ~~ #write ]) ifTrue:[
        ^ self error:'ZipArchive not open for writing ...'.
    ].
    theCompressMethod := theCompressMethodArg.
    ((theCompressMethod ~~ COMPRESSION_DEFLATED) 
      and:[theCompressMethod ~~ COMPRESSION_STORED]) ifTrue:[
        UnsupportedZipFileFormatErrorSignal 
            raiseRequestErrorString:'unsupported compressMethod'.
        "/ if proceeded, write as uncompressed
        theCompressMethod := COMPRESSION_STORED
    ].

    zipEntry := ZipMember new default.
    theZipFileName := self validZipFileNameFrom:aFileName.
    zipEntry fileName:theZipFileName.

    (self appendTrailingSlash and:[isDirectory]) ifTrue:[
        theZipFileName last == $/ ifFalse:[
            zipEntry fileName:theZipFileName , $/.
            zipEntry fileNameLength:theZipFileName size + 1.
        ].
    ].

    zipEntry uncompressedSize:data size.
    isDirectory ifTrue:[
        zipEntry externalFileAttributes:EXTERNALFILEATTRIBUTES_ISDIRECTORY.
    ] ifFalse:[
        zipEntry compressionMethod:theCompressMethod.        
        zipEntry internalFileAttributes: 1.
        zipEntry externalFileAttributes: EXTERNALFILEATTRIBUTES_ISFILE.
    ].
    
    "/ data and time in msdos format
    zipEntry setModificationTimeAndDateToNow.

    data notEmptyOrNil ifTrue:[
        "/ crc32 is always required (not as written in docu to be zero in case of uncompressed mode)
        zipEntry crc32:(ZipStream crc32BytesIn:data from:1 to:data size crc:0).
    ].
    (isDirectory not and:[ theCompressMethod == COMPRESSION_DEFLATED ]) ifTrue:[
        |tmpCompressedDataSize|

        theCompressedData := ByteArray new:(data size + 16).
        tmpCompressedDataSize := ZipStream compress:data into:theCompressedData.
        zipEntry compressedSize:tmpCompressedDataSize - 6.
        compressedDataOffset := 3.
    ] ifFalse:["theCompressMethod == COMPRESSION_STORED"
        zipEntry compressedSize:zipEntry uncompressedSize.
        theCompressedData := data.
        compressedDataOffset := 1.
    ].
    
    "/ ensure that the file position is at the end
    file setToEnd.
    zipEntry writeTo:file.
    theCompressedData notNil ifTrue:[
        file nextPutBytes:zipEntry compressedSize from:theCompressedData startingAt:compressedDataOffset.
    ].
    self addMember:zipEntry.

    "Created: / 18-11-2010 / 19:31:10 / cg"
    "Modified: / 19-11-2010 / 17:47:01 / cg"
    "Modified: / 19-11-2012 / 12:04:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ZipArchive methodsFor:'writing - stream'!

compressedWriteStreamFor:nameOfFileInArchive
    "create new entry in central directory"

    ^ self writeStreamFor:nameOfFileInArchive compressMethod:COMPRESSION_DEFLATED

    "Modified: / 19-11-2010 / 15:58:13 / cg"
!

writeStreamFor:nameOfFileInArchive compressMethod:theCompressMethodArg
    "create new entry in central directory"

    |zipEntry theZipFileName theCompressMethod|

    (file isNil or:[mode ~~ #write]) ifTrue: [
        ^ self error: 'ZipArchive not open for writing ...'.
    ].

    theCompressMethod := theCompressMethodArg.

    ((theCompressMethod == COMPRESSION_DEFLATED) 
     or:[theCompressMethod == COMPRESSION_STORED]) ifFalse:[
        UnsupportedZipFileFormatErrorSignal raiseRequestErrorString:'unsupported compressMethod'.
        "/ if proceeded, write as uncompressed
        theCompressMethod := COMPRESSION_STORED
    ].

    zipEntry := ZipMember new default.
    theZipFileName := self validZipFileNameFrom:nameOfFileInArchive. 

    zipEntry fileName: theZipFileName.
    zipEntry uncompressedSize: 0.

    zipEntry compressionMethod: theCompressMethod.
    zipEntry internalFileAttributes: 1.
    zipEntry externalFileAttributes: EXTERNALFILEATTRIBUTES_ISFILE.

    "/ data and time in msdos format
    zipEntry setModificationTimeAndDateToNow.

    "/ ensure that the file position is at the end
    file setToEnd.

    zipEntry writeTo:file.
    self addMember:zipEntry.

    ^ (ZipWriteStream zipFileStream:file zipEntry:zipEntry) zipArchive:self.

    "Modified: / 19-11-2010 / 15:38:54 / cg"
! !

!ZipArchive::AbstractZipStream class methodsFor:'instance creation'!

zipFileStream:something zipEntry:compressionMethodArg
    ^ self basicNew zipFileStream:something zipEntry:compressionMethodArg
! !

!ZipArchive::AbstractZipStream methodsFor:'accessing'!

zipArchive
    ^ zipArchive
!

zipArchive:something
    zipArchive := something.
!

zipEntry
    ^ zipEntry
!

zipEntry:something
    zipEntry := something.
!

zipFileStream
    ^ zipFileStream
! !

!ZipArchive::AbstractZipStream methodsFor:'misc'!

binary
    compressingStream binary
!

contentsSpecies
    "return a class of which instances will be returned, when
     parts of the collection are asked for. 
     (see upTo-kind of methods in Stream)"

    ^ compressingStream contentsSpecies
!

isBinary
    ^ compressingStream isBinary
!

text
    compressingStream text
! !

!ZipArchive::ZipCentralDirectory methodsFor:'accessing'!

centralDirectorySize
    ^ centralDirectorySize
!

centralDirectorySize:something
    centralDirectorySize := something.
!

centralDirectoryStartDiskNumber
    ^ centralDirectoryStartDiskNumber
!

centralDirectoryStartDiskNumber:something
    centralDirectoryStartDiskNumber := something.
!

centralDirectoryStartOffset
    ^ centralDirectoryStartOffset
!

centralDirectoryStartOffset:something
    centralDirectoryStartOffset := something.
!

centralDirectoryTotalNoOfEntries
    ^ centralDirectoryTotalNoOfEntries
!

centralDirectoryTotalNoOfEntries:something
    centralDirectoryTotalNoOfEntries := something.
!

centralDirectoryTotalNoOfEntriesOnThisDisk
    ^ centralDirectoryTotalNoOfEntriesOnThisDisk
!

centralDirectoryTotalNoOfEntriesOnThisDisk:something
    centralDirectoryTotalNoOfEntriesOnThisDisk := something.
!

digitalSignatureData
    ^ digitalSignatureData
!

digitalSignatureData:something
    digitalSignatureData := something.
!

digitalSignatureDataSize
    ^ digitalSignatureDataSize
!

digitalSignatureDataSize:something
    digitalSignatureDataSize := something.
!

numberOfThisDisk
    ^ numberOfThisDisk.
!

numberOfThisDisk:something
    numberOfThisDisk := something.
!

zipComment
    ^ zipComment
!

zipComment:something
    zipComment := something.
!

zipCommentLength
    ^ zipCommentLength
!

zipCommentLength:something
    zipCommentLength := something.
! !

!ZipArchive::ZipCentralDirectory methodsFor:'initialization'!

default
    numberOfThisDisk := 0.
    centralDirectoryStartDiskNumber := 0.
    centralDirectoryTotalNoOfEntriesOnThisDisk := 0.
    centralDirectoryTotalNoOfEntries := 0.
    centralDirectorySize := 0.
    centralDirectoryStartOffset := 0.
    zipCommentLength := 0. 
    zipComment := nil.
    digitalSignatureDataSize := 0. 
    digitalSignatureData := nil.
! !

!ZipArchive::ZipCentralDirectory methodsFor:'reading & writing'!

readDigitalSignatureFrom:aStream
    "read a digitalSignature trailer from aStream"

    digitalSignatureDataSize := aStream nextUnsignedInt16MSB:false.
    digitalSignatureDataSize ~~ 0 ifTrue:[
"/        (file position + (centralDirectory digitalSignatureDataSize)) > endOfArchive ifTrue: [
"/            ^ ZipFileFormatErrorSignal raiseRequestErrorString:' - digital signature entry out of archive bounds'.
"/        ].
        digitalSignatureData := String new:digitalSignatureDataSize.
        aStream nextBytes:digitalSignatureDataSize into:digitalSignatureData.
    ].
!

readFrom:aStream
    "read a Central Directory Header from aStream"

    numberOfThisDisk := aStream nextUnsignedInt16MSB:false.
    centralDirectoryStartDiskNumber := aStream nextUnsignedInt16MSB:false.
    centralDirectoryTotalNoOfEntriesOnThisDisk := aStream nextUnsignedInt16MSB:false.
    centralDirectoryTotalNoOfEntries := aStream nextUnsignedInt16MSB:false.
    centralDirectorySize := aStream nextInt32MSB:false.
    centralDirectoryStartOffset := aStream nextInt32MSB:false.
    zipCommentLength := aStream nextUnsignedInt16MSB:false.
    zipCommentLength ~~ 0 ifTrue: [
        zipComment := String new:zipCommentLength.
        aStream nextBytes:zipCommentLength into:zipComment.
    ].
! !

!ZipArchive::ZipMember class methodsFor:'documentation'!

documentation
"
    keeps some information for a single entry in a zipFile.
"


! !

!ZipArchive::ZipMember methodsFor:'accessing'!

compressedSize
    ^ compressedSize
!

compressedSize:something
    compressedSize := something.
!

compressionMethod
    ^ compressionMethod
!

compressionMethod:something
    compressionMethod := something.
!

crc32
    ^ crc32

    "Created: / 29-03-1998 / 20:03:00 / cg"
    "Modified: / 21-01-2011 / 00:04:48 / cg"
!

crc32:something
    crc32 := something.

    "Created: / 29-03-1998 / 20:03:00 / cg"
    "Modified: / 21-01-2011 / 00:04:52 / cg"
!

data
    ^ data

    "Created: / 09-04-1998 / 13:05:03 / cg"
    "Modified: / 21-01-2011 / 00:04:57 / cg"
!

data:something
    data := something.

    "Created: / 09-04-1998 / 13:05:03 / cg"
    "Modified: / 21-01-2011 / 00:05:00 / cg"
!

dataStart
    "tell the file offset, where the data of this zip entry starts"

    ^ dataStart
    "Created: / 29.3.1998 / 18:28:40 / cg"
!

dataStart:something
    "set the value of the instance variable 'dataStart' (automatically generated)"

    dataStart := something.

    "Created: / 29.3.1998 / 18:28:40 / cg"
!

diskNumberStart
    ^ diskNumberStart
!

diskNumberStart:something
    diskNumberStart := something.
!

externalFileAttributes
    ^ externalFileAttributes
!

externalFileAttributes:something
    externalFileAttributes := something.
!

extraField
    ^ extraField
!

extraField:something
    extraField := something.
!

extraFieldLength
    ^ extraFieldLength
!

extraFieldLength:something
    extraFieldLength := something.
!

fileComment
    ^ fileComment
!

fileComment:something
    fileComment := something.
!

fileCommentLength
    ^ fileCommentLength
!

fileCommentLength:something
    fileCommentLength := something.
!

fileName
    ^ fileName
!

fileName:something
    fileName := something.
!

fileNameLength
    fileNameLength isNil ifTrue:[
        ^ fileName size.
    ].
    ^ fileNameLength
!

fileNameLength:something
    fileNameLength := something.
!

generalPurposBitFlag
    ^ generalPurposBitFlag
!

generalPurposBitFlag:something
    generalPurposBitFlag := something.
!

internalFileAttributes
    ^ internalFileAttributes
!

internalFileAttributes:something
    internalFileAttributes := something.
!

lastModFileDate
    ^ lastModFileDate
!

lastModFileDate:something
    lastModFileDate := something.
!

lastModFileTime
    ^ lastModFileTime
!

lastModFileTime:something
    lastModFileTime := something.
!

next
    "return the value of the instance variable 'next' (automatically generated)"

    ^ next

    "Created: / 29.3.1998 / 18:29:42 / cg"
!

next:something
    "set the value of the instance variable 'next' (automatically generated)"

    next := something.

    "Created: / 29.3.1998 / 18:29:42 / cg"
!

relativeLocalHeaderOffset
    ^ relativeLocalHeaderOffset
!

relativeLocalHeaderOffset:something
    relativeLocalHeaderOffset := something.
!

setModificationTimeAndDateToNow
    |curTime curDate|

    curTime := Time now.                                                   
    curDate := Date today.
    "/ data and time in msdos format
    self lastModFileTime: (ZipArchive timeToZipFileTime:curTime).
    self lastModFileDate: (ZipArchive dateToZipFileDate:curDate).
!

uncompressedSize
    ^ uncompressedSize
!

uncompressedSize:something
    uncompressedSize := something.
!

versionMadeBy
    ^ versionMadeBy
!

versionMadeBy:something
    versionMadeBy := something.
!

versionNeedToExtract
    ^ versionNeedToExtract
!

versionNeedToExtract:something
    versionNeedToExtract := something.
! !

!ZipArchive::ZipMember methodsFor:'initialization'!

default
    versionMadeBy := 20.
    versionNeedToExtract := 20.
    generalPurposBitFlag := 0.
    compressionMethod := 0.
    lastModFileTime := 0.
    lastModFileDate := 0.
    crc32 := 0.
    compressedSize := 0.
    uncompressedSize := 0.
    extraFieldLength := 0.
    fileCommentLength := 0.
    diskNumberStart := 0.
    internalFileAttributes := 0.
    externalFileAttributes := 0.
    relativeLocalHeaderOffset := 0.
    fileName := fileNameLength := nil.
    extraField := nil.
    fileComment := nil.
    dataStart := 0.
    data := nil.
! !

!ZipArchive::ZipMember methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:'ZipMember('.
    aStream nextPutAll:(fileName ? '*nil*').
    aStream nextPutAll:')'

    "Modified: / 02-04-1998 / 15:10:08 / cg"
    "Created: / 25-11-2011 / 17:59:47 / cg"
! !

!ZipArchive::ZipMember methodsFor:'queries'!

isDirectory
    ^ 
    ((externalFileAttributes ? 0) bitTest:EXTERNALFILEATTRIBUTES_ISDIRECTORY)
        or:[uncompressedSize == 0 and:[fileName last = $/]].

    "Created: / 28-03-2011 / 19:19:26 / cg"
    "Modified: / 19-11-2012 / 12:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ZipArchive::ZipMember methodsFor:'reading & writing'!

readCentralDirectoryEntryFrom:aStream
    "read a central directory entry"

    versionMadeBy := aStream nextUnsignedInt16MSB:false. 
    versionNeedToExtract := aStream nextUnsignedInt16MSB:false. 
    generalPurposBitFlag := aStream nextUnsignedInt16MSB:false. 
    compressionMethod := aStream nextUnsignedInt16MSB:false.
    lastModFileTime := aStream nextUnsignedInt16MSB:false.   
    lastModFileDate := aStream nextUnsignedInt16MSB:false.
    crc32 := aStream nextUnsignedInt32MSB: false.
    compressedSize := aStream nextUnsignedInt32MSB:false.     
    uncompressedSize := aStream nextUnsignedInt32MSB:false.      
    fileNameLength := aStream nextUnsignedInt16MSB:false.   
    extraFieldLength := aStream nextUnsignedInt16MSB:false. 
    fileCommentLength := aStream nextUnsignedInt16MSB:false. 
    diskNumberStart := aStream nextUnsignedInt16MSB:false.  
    internalFileAttributes := aStream nextUnsignedInt16MSB:false.   
    externalFileAttributes := aStream nextUnsignedInt32MSB:false.
    relativeLocalHeaderOffset := aStream nextUnsignedInt32MSB:false.

"/    (aStream position + fileNameLength) > endOfArchive ifTrue: [
"/        ^ ZipArchive zipFileFormatErrorSignal raiseRequestErrorString:' - central directory entry out of archive bounds'.
"/    ].
    fileName:= String new:fileNameLength.
    aStream nextBytes:fileNameLength into:fileName.
    "/ If bit 11 of general purpose bit flag is 1, then
    "/ fileName is UTF8 encoded.
    "/ 
    "/ See ZIP spec, section 4.4.4
    "/ https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT
    (generalPurposBitFlag isBitSet: 12"1-based indexing") ifTrue:[ 
        fileName := fileName utf8Decoded.
    ].

    extraFieldLength ~~ 0 ifTrue: [
"/        (aStream position + extraFieldLength) > endOfArchive ifTrue: [
"/            ^ ZipArchive zipFileFormatErrorSignal raiseRequestErrorString:' - central directory entry out of archive bounds'.
"/        ].
        extraField := ByteArray new:extraFieldLength.
        aStream nextBytes:extraFieldLength into:extraField.
    ].

    fileCommentLength ~~ 0 ifTrue: [
"/        (aStream position + fileCommentLength) > endOfArchive ifTrue: [
"/            ^ ZipArchive zipFileFormatErrorSignal raiseRequestErrorString:' - central directory entry out of archive bounds'.
"/        ].
        fileComment := String new:fileCommentLength.
        aStream nextBytes:fileCommentLength into:fileComment.
        "/ If bit 11 of general purpose bit flag is 1, then
        "/ fileName is UTF8 encoded.
        "/ 
        "/ See ZIP spec, section 4.4.4
        "/ https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT
        (generalPurposBitFlag isBitSet: 12"1-based indexing") ifTrue:[ 
            fileComment := fileComment utf8Decoded.
        ].

    ].

    "Modified: / 15-06-2017 / 13:41:46 / jv"
!

rewriteCrcAndSizeTo:aStream
    "Header has already been written - now rewrite CRC and sizes"

    aStream position:relativeLocalHeaderOffset+14.

    aStream 
        nextPutInt32:crc32 MSB:false;
        nextPutInt32:compressedSize MSB:false;
        nextPutInt32:uncompressedSize MSB:false.
!

writeTo:aStream
    "represent myself on aStream"

    relativeLocalHeaderOffset := aStream position.

    aStream 
        nextPutInt32LSB:C_LOCAL_HEADER_SIGNATURE ;
        nextPutInt16LSB:versionNeedToExtract;
        nextPutInt16LSB:generalPurposBitFlag;
        nextPutInt16LSB:compressionMethod;
        nextPutInt16LSB:lastModFileTime;
        nextPutInt16LSB:lastModFileDate;
        nextPutInt32LSB:crc32;
        nextPutInt32LSB:compressedSize;
        nextPutInt32LSB:uncompressedSize;
        nextPutInt16LSB:self fileNameLength;
        nextPutInt16LSB:extraFieldLength;
        nextPutAll:fileName.

    extraField notNil ifTrue: [
        self assert:(extraField size = extraFieldLength).
        aStream nextPutAll:extraField.
    ].

    "Modified: / 19-11-2010 / 15:45:38 / cg"
! !

!ZipArchive::ZipReadStream methodsFor:'closing'!

close
    "nothing to do here"
! !

!ZipArchive::ZipReadStream methodsFor:'initialization'!

zipFileStream:something  zipEntry:aZipEntry

    zipEntry := aZipEntry.
    zipFileStream := something.
    startDataPosition := zipFileStream position.
    crc32 := 0.
    uncompressedDataSize := zipEntry uncompressedSize.
    readPosition := 0.

    zipEntry compressionMethod == COMPRESSION_DEFLATED ifTrue:[
        compressingStream := ZipStream readOpenAsZipStreamOn:zipFileStream suppressHeaderAndChecksum:true.
    ] ifFalse:[
        compressingStream := zipFileStream.
        compressingStream text.
    ].

    "Modified: / 19-11-2010 / 15:47:14 / cg"
! !

!ZipArchive::ZipReadStream methodsFor:'queries'!

atEnd
    ^ peek isNil and:[readPosition >= uncompressedDataSize]
!

position
    ^ readPosition
! !

!ZipArchive::ZipReadStream methodsFor:'reading'!

next
    "read a character"

    |result|

    peek notNil ifTrue:[
        result := peek.
        peek := nil.
    ] ifFalse:[
        readPosition >= uncompressedDataSize ifTrue:[
            ^ self pastEndRead.        
        ].

        result := compressingStream next.
    ].

    readPosition := readPosition + 1.
    ^ result.
!

nextOrNil
    "read a character"

    |result|

    peek notNil ifTrue:[
        result := peek.
        peek := nil.
    ] ifFalse:[
        readPosition >= uncompressedDataSize ifTrue:[
            ^ nil.        
        ].

        result := compressingStream next.
    ].

    readPosition := readPosition + 1.
    ^ result.
!

peek
    "peek a character"

    peek notNil ifTrue:[
        ^ peek.
    ].

    readPosition >= uncompressedDataSize ifTrue:[
        ^ self pastEndRead.        
    ].

    peek := compressingStream next.
    ^ peek.
! !

!ZipArchive::ZipWriteStream methodsFor:'closing'!

close
    "finalize the data"

    compressingStream ~~ zipFileStream ifTrue:[
        "close ZipStream"
        compressingStream close.
    ].
    compressingStream := nil.

    zipEntry compressedSize:(zipFileStream position) - startDataPosition.

    "/ crc32 is always reqired (not as written in docu to be zero in case of uncompressed mode)
    zipEntry crc32:crc32.
    zipEntry uncompressedSize:uncompressedDataSize.

    zipEntry rewriteCrcAndSizeTo:zipFileStream.

    zipFileStream setToEnd.
! !

!ZipArchive::ZipWriteStream methodsFor:'initialization'!

zipFileStream:something  zipEntry:aZipEntry

    zipEntry := aZipEntry.
    zipFileStream := something.
    startDataPosition := zipFileStream position.
    crc32 := 0.
    uncompressedDataSize := 0.

    zipEntry compressionMethod == COMPRESSION_DEFLATED ifTrue:[
        compressingStream := ZipStream writeOpenAsZipStreamOn:zipFileStream suppressHeaderAndChecksum:true.
    ] ifFalse:[
        compressingStream := zipFileStream.
    ].

    "Modified: / 19-11-2010 / 15:46:57 / cg"
! !

!ZipArchive::ZipWriteStream methodsFor:'queries'!

isReadable
    "return true, if reading is supported by the receiver.
     This has to be redefined in concrete subclasses."

    ^ false
!

isWritable
    "return true, if writing is supported by the receiver.
     This has to be redefined in concrete subclasses."

    ^ true
! !

!ZipArchive::ZipWriteStream methodsFor:'reading'!

contents
    "return the entire contents of the stream.
     For a readStream, that is the rest (i.e. upToEnd),
     for a writeStream, that is the collected data. As we do not know here,
     what we are, this is the responsibility of a subclass..."

    self shouldNotImplement
!

next
    "return the next element of the stream
     - we do not know here how to do it, it must be redefined in subclass"

    self shouldNotImplement
!

peek
    "return the next element of the stream
     - we do not know here how to do it, it must be redefined in subclass"

    self shouldNotImplement
! !

!ZipArchive::ZipWriteStream methodsFor:'writing'!

contents:aCollection
    |size|

    size := aCollection size.
    uncompressedDataSize := uncompressedDataSize + size.
    crc32 := ZipStream crc32BytesIn:aCollection from:1 to:size crc:crc32.
    compressingStream contents:aCollection
!

flush
    compressingStream flush
!

nextPut:anObject
    "put the argument, anObject onto the receiver
     - we do not know here how to do it, it must be redefined in subclass"

    uncompressedDataSize := uncompressedDataSize + 1.
    crc32 := ZipStream crc32Add:anObject crc:crc32.
    compressingStream nextPut:anObject
!

nextPutAll:aCollection
    |size|

    size := aCollection size.
    size = 0 ifFalse:[
        uncompressedDataSize := uncompressedDataSize + size.
        crc32 := ZipStream crc32BytesIn:aCollection from:1 to:size crc:crc32.
        compressingStream nextPutAll:aCollection
    ].
! !

!ZipArchive class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


ZipArchive initialize!
