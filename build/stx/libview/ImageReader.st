"
 COPYRIGHT (c) 1991 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ImageReader
	instanceVariableNames:'width height data byteOrder inStream outStream photometric
		samplesPerPixel bitsPerSample colorMap mask maskPixel
		dimensionCallBack dimensionHolder progressHolder imageSequence
		metaData'
	classVariableNames:'ReverseBits'
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!ImageReader primitiveDefinitions!
%{

# define STDC_HEADERS
#ifndef _STDIO_H_INCLUDED_
# include <stdio.h>
# define _STDIO_H_INCLUDED_
#endif

#if defined(__osx__)
# include <stdlib.h>
# define _MALLOC_H_INCLUDED_
#endif

#ifndef _MALLOC_H_INCLUDED_
# if !defined(FREEBSD)
#  include <malloc.h>
#  define _MALLOC_H_INCLUDED_
# endif
#endif


%}
! !

!ImageReader primitiveFunctions!
%{

/*
 * ccitt decompression
 */
static short *whiteCountTable;
static char  *whiteShiftTable;
static short *blackCountTable;
static char  *blackShiftTable;

struct ccitt_def {
    unsigned short bits;
    short nBits;
};

static struct ccitt_def
whiteDef[] = {
    { 0x3500, 8 }, /* 0 */
    { 0x1c00, 6 },
    { 0x7000, 4 },
    { 0x8000, 4 },
    { 0xb000, 4 },
    { 0xc000, 4 },
    { 0xe000, 4 },
    { 0xf000, 4 },
    { 0x9800, 5 },
    { 0xA000, 5 },
    { 0x3800, 5 }, /* 10 */
    { 0x4000, 5 },
    { 0x2000, 6 },
    { 0x0c00, 6 },
    { 0xd000, 6 },
    { 0xd400, 6 },
    { 0xa800, 6 },
    { 0xac00, 6 },
    { 0x4e00, 7 },
    { 0x1800, 7 },
    { 0x1000, 7 }, /* 20 */
    { 0x2e00, 7 },
    { 0x0600, 7 },
    { 0x0800, 7 },
    { 0x5000, 7 },
    { 0x5600, 7 },
    { 0x2600, 7 },
    { 0x4800, 7 },
    { 0x3000, 7 },
    { 0x0200, 8 },
    { 0x0300, 8 }, /* 30 */
    { 0x1a00, 8 },
    { 0x1b00, 8 },
    { 0x1200, 8 },
    { 0x1300, 8 },
    { 0x1400, 8 },
    { 0x1500, 8 },
    { 0x1600, 8 },
    { 0x1700, 8 },
    { 0x2800, 8 },
    { 0x2900, 8 }, /* 40 */
    { 0x2a00, 8 },
    { 0x2b00, 8 },
    { 0x2c00, 8 },
    { 0x2d00, 8 },
    { 0x0400, 8 },
    { 0x0500, 8 },
    { 0x0a00, 8 },
    { 0x0b00, 8 },
    { 0x5200, 8 },
    { 0x5300, 8 }, /* 50 */
    { 0x5400, 8 },
    { 0x5500, 8 },
    { 0x2400, 8 },
    { 0x2500, 8 },
    { 0x5800, 8 },
    { 0x5900, 8 },
    { 0x5a00, 8 },
    { 0x5b00, 8 },
    { 0x4a00, 8 },
    { 0x4b00, 8 }, /* 60 */
    { 0x3200, 8 },
    { 0x3300, 8 },
    { 0x3400, 8 },
/* ---------------- */
    { 0xd800, 5 }, /* 64 */
    { 0x9000, 5 }, /* 128 */
    { 0x5c00, 6 }, /* 192 */
    { 0x6e00, 7 }, /* 256 */
    { 0x3600, 8 }, /* 320 */
    { 0x3700, 8 },
    { 0x6400, 8 },
    { 0x6500, 8 },
    { 0x6800, 8 },
    { 0x6700, 8 }, /* 640 */
    { 0x6600, 9 }, /* 704 */
    { 0x6680, 9 },
    { 0x6900, 9 },
    { 0x6980, 9 },
    { 0x6a00, 9 },
    { 0x6a80, 9 },
    { 0x6b00, 9 },
    { 0x6b80, 9 },
    { 0x6c00, 9 },
    { 0x6c80, 9 },
    { 0x6d00, 9 },
    { 0x6d80, 9 },
    { 0x4c00, 9 },
    { 0x4c80, 9 },
    { 0x4d00, 9 }, /* 1600 */
    { 0x6000, 6 }, /* 1664 */
    { 0x4d80, 9 }, /* 1728 */
/* -------------------------------- */
    { 0x0100, 11 }, /* 1792 */
    { 0x0180, 11 },
    { 0x01a0, 11 }, /* 1920 */
    { 0x0120, 12 }, /* 1984 */
    { 0x0130, 12 },
    { 0x0140, 12 },
    { 0x0150, 12 },
    { 0x0160, 12 },
    { 0x0170, 12 },
    { 0x01c0, 12 },
    { 0x01d0, 12 },
    { 0x01e0, 12 },
    { 0x01f0, 12 }, /* 2560 */
/* -------------------------------- */
    { 0x0010, 12 }, /* EOL */
};

static struct ccitt_def
blackDef[] = {
    { 0x0dc0, 10 }, /* 0 */
    { 0x4000, 3 },
    { 0xc000, 2 },
    { 0x8000, 2 },
    { 0x6000, 3 },
    { 0x3000, 4 },
    { 0x2000, 4 },
    { 0x1800, 5 },
    { 0x1400, 6 },
    { 0x1000, 6 },
    { 0x0800, 7 }, /* 10 */
    { 0x0a00, 7 },
    { 0x0e00, 7 },
    { 0x0400, 8 },
    { 0x0700, 8 },
    { 0x0c00, 9 },
    { 0x05c0, 10 },
    { 0x0600, 10 },
    { 0x0200, 10 },
    { 0x0ce0, 11 },
    { 0x0d00, 11 }, /* 20 */
    { 0x0d80, 11 },
    { 0x06e0, 11 },
    { 0x0500, 11 },
    { 0x02e0, 11 },
    { 0x0300, 11 },
    { 0x0ca0, 12 },
    { 0x0cb0, 12 },
    { 0x0cc0, 12 },
    { 0x0cd0, 12 },
    { 0x0680, 12 }, /* 30 */
    { 0x0690, 12 },
    { 0x06a0, 12 },
    { 0x06b0, 12 },
    { 0x0d20, 12 },
    { 0x0d30, 12 },
    { 0x0d40, 12 },
    { 0x0d50, 12 },
    { 0x0d60, 12 },
    { 0x0d70, 12 },
    { 0x06c0, 12 }, /* 40 */
    { 0x06d0, 12 },
    { 0x0da0, 12 },
    { 0x0db0, 12 },
    { 0x0540, 12 },
    { 0x0550, 12 },
    { 0x0560, 12 },
    { 0x0570, 12 },
    { 0x0640, 12 },
    { 0x0650, 12 },
    { 0x0520, 12 }, /* 50 */
    { 0x0530, 12 },
    { 0x0240, 12 },
    { 0x0370, 12 },
    { 0x0380, 12 },
    { 0x0270, 12 },
    { 0x0280, 12 },
    { 0x0580, 12 },
    { 0x0590, 12 },
    { 0x02b0, 12 },
    { 0x02c0, 12 }, /* 60 */
    { 0x05a0, 12 },
    { 0x0660, 12 },
    { 0x0670, 12 },
/* ---------------- */
    { 0x03c0, 10 }, /* 64 */
    { 0x0c80, 12 }, /* 128 */
    { 0x0c90, 12 }, /* 192 */
    { 0x05b0, 12 }, /* 256 */
    { 0x0330, 12 }, /* 320 */
    { 0x0340, 12 },
    { 0x0350, 12 }, /* 448 */
    { 0x0360, 13 }, /* 512 */
    { 0x0368, 13 },
    { 0x0250, 13 }, /* 640 */
    { 0x0258, 13 }, /* 704 */
    { 0x0260, 13 },
    { 0x0268, 13 },
    { 0x0390, 13 },
    { 0x0398, 13 },
    { 0x03a0, 13 },
    { 0x03a8, 13 },
    { 0x03b0, 13 },
    { 0x03b8, 13 },
    { 0x0290, 13 },
    { 0x0298, 13 },
    { 0x02a0, 13 },
    { 0x02a8, 13 },
    { 0x02d0, 13 },
    { 0x02d8, 13 }, /* 1600 */
    { 0x0320, 13 }, /* 1664 */
    { 0x0328, 13 }, /* 1728 */
/* -------------------------------- */
};

static void
initCCITTTables() {
    register int cnt, bits, value;
    int nBits, index;

    if (whiteCountTable != (short *)0) return;

    whiteCountTable = (short *) malloc(sizeof(short) * 8192);
    if (! whiteCountTable) return;
    whiteShiftTable = (char *) malloc(sizeof(char) * 8192);
    if (! whiteShiftTable) {
	goto fail1;
    }
    blackCountTable = (short *) malloc(sizeof(short) * 8192);
    if (! blackCountTable) {
	goto fail2;
    }
    blackShiftTable = (char *) malloc(sizeof(char) * 8192);
    if (! blackShiftTable) {
	free(blackCountTable); blackCountTable = (short *)0;
fail2:
	free(whiteShiftTable); whiteShiftTable = (char *)0;
fail1:
	free(whiteCountTable); whiteCountTable = (short *)0;
	return;
    }

    for (index = 0; index < 8192; index++) {
	whiteCountTable[index] = -1;
	blackCountTable[index] = -1;
    }

    for (value = 0; value <= 63; value++) {
	nBits = whiteDef[value].nBits;
	bits = whiteDef[value].bits >> 3;
	for (cnt = 1 << (13 - nBits); cnt; cnt--, bits++) {
	    whiteCountTable[bits] = value;
	    whiteShiftTable[bits] = nBits;
	}
	nBits = blackDef[value].nBits;
	bits = blackDef[value].bits >> 3;
	for (cnt = 1 << (13 - nBits); cnt; cnt--, bits++) {
	    blackCountTable[bits] = value;
	    blackShiftTable[bits] = nBits;
	}
    }
    index = value;

    for (; value <= 1728; value += 64) {
	nBits = whiteDef[index].nBits;
	bits = whiteDef[index].bits >> 3;
	for (cnt = 1 << (13 - nBits); cnt; cnt--, bits++) {
	    whiteCountTable[bits] = value;
	    whiteShiftTable[bits] = nBits;
	}
	nBits = blackDef[index].nBits;
	bits = blackDef[index].bits >> 3;
	for (cnt = 1 << (13 - nBits); cnt; cnt--, bits++) {
	    blackCountTable[bits] = value;
	    blackShiftTable[bits] = nBits;
	}
	index++;
    }

    for (; value <= 2560; value += 64) {
	nBits = whiteDef[index].nBits;
	bits = whiteDef[index].bits >> 3;
	for (cnt = 1 << (13 - nBits); cnt; cnt--, bits++) {
	    whiteCountTable[bits] = value;
	    whiteShiftTable[bits] = nBits;
	    blackCountTable[bits] = value;
	    blackShiftTable[bits] = nBits;
	}
	index++;
    }
}

static short
leftBits[] = {
     0, 0x80, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC, 0xFE, 0xFF
};

static int
__decodeCCITTgroup3__(unsigned char *from, unsigned char *to, int len)
{
    register int cnt;
    register short *countPtr;
    register char *shiftPtr;
    unsigned int bits, bits13;
    int shift, outCount, nBitsLess13;
    int outBitOffset;
    int nLeft, t;

    if (! whiteCountTable) initCCITTTables();
    if (! whiteCountTable) return 0; /* malloc failed */

    countPtr = whiteCountTable;
    shiftPtr = whiteShiftTable;
    outCount = 0;
    outBitOffset = 0;
    bits = *from++;
    bits = (bits << 8) | *from++;
    nBitsLess13 = 3;
    for (;;) {
	bits13 = (bits >> nBitsLess13) & 0x1FFF;
	cnt = countPtr[bits13];
	if (cnt < 0) return 1;
	shift = shiftPtr[bits13];
	outCount += cnt;
	if (countPtr == blackCountTable) {
	    /* toggle if it was a terminating code */
	    if (cnt < 64) {
		countPtr = whiteCountTable;
		shiftPtr = whiteShiftTable;
	    }

	    /* draw cnt black bits */
	    if (cnt) {
		if (outBitOffset) {
		    nLeft = 8 - outBitOffset;
		    if (cnt < nLeft) nLeft = cnt;
		    t = leftBits[nLeft] >> outBitOffset;
		    *to |= t;
		    cnt -= nLeft;
		    outBitOffset += nLeft;
		    if (outBitOffset >= 8) {
			to++;
			outBitOffset -= 8;
		    }
		}
		if (cnt > 256) {
		    while ((INT)to & 3) {
			*to++ = 0xFF;
			cnt -= 8;
		    }
#if __POINTER_SIZE__ == 8
		    while ((INT)to & 7) {
			*to++ = 0xFF;
			cnt -= 8;
		    }
		    while (cnt >= 64) {
			(*(INT *)to) = 0xFFFFFFFFFFFFFFFF;
			to += 8;
			cnt -= 64;
		    }
		    if (cnt >= 32) {
			(*(long *)to) = 0xFFFFFFFF;
			to += 4;
			cnt -= 32;
		    }
#else
		    while ((INT)to & 3) {
			*to++ = 0xFF;
			cnt -= 8;
		    }
		    while (cnt >= 32) {
			(*(long *)to) = 0xFFFFFFFF;
			to += 4;
			cnt -= 32;
		    }
#endif
		}
		while (cnt >= 8) {
		    *to++ = 0xFF;
		    cnt -= 8;
		}
		*to |= leftBits[cnt];
		outBitOffset += cnt;
	    }
	} else {
	    /* toggle if it was a terminating code */
	    if (cnt < 64) {
		countPtr = blackCountTable;
		shiftPtr = blackShiftTable;
	    }

	    /* skip cnt bits */
	    to += cnt >> 3;
	    outBitOffset += cnt & 7;
	    if (outBitOffset >= 8) {
		to++;
		outBitOffset -= 8;
	    }
	}
	if (outCount >= len) return 1;

	nBitsLess13 -= shift;
	while (nBitsLess13 < 0) {
	    bits = (bits << 8) | *from++;
	    nBitsLess13 += 8;
	}
    }
}

/*
 * LZW decompression
 */
struct buffer {
	struct buffer *prev;
	unsigned char chars[8192 - 4];
};

static int
__decodeLZW__(unsigned char *from, unsigned char *to, int inCount, int fromSize, int toSize)
{
    register unsigned code;
    unsigned char **strings;
    short *stringLen;
    struct buffer *scratchBuffer;
    struct buffer *newBuffer;
    unsigned char *scratchPtr;
    int nScratch;
    unsigned nextCode;
    int oldCode = -1;
    register unsigned bits;
    int nBits, mask, shift;
    int i;
    int len;
    int codeLen = 9;
    unsigned char *fromEnd, *toEnd;
    int ret = 1;        /* return success */

    fromEnd = from + fromSize;
    toEnd = to + toSize;

    scratchBuffer = (struct buffer *)malloc(sizeof(struct buffer));
    if (! scratchBuffer) return 0;

    strings = (unsigned char **)malloc(sizeof(unsigned char *) * 4096);
    if (! strings) {
	free(scratchBuffer);
	return 0;
    }
    stringLen = (short *)malloc(sizeof(short) * 4096);
    if (! stringLen) {
	free(strings);
	free(scratchBuffer);
	return 0;
    }

    scratchBuffer->prev = (struct buffer *)0;
    scratchPtr = scratchBuffer->chars;
    nScratch = sizeof(scratchBuffer->chars);

    for (i = 0; i < 256; i++) {
	*scratchPtr = i;
	strings[i] = scratchPtr++;
	stringLen[i] = 1;
    }

    nextCode = 258;
    nScratch -= 256;
    mask = 0x1FF;
    nBits = 0;
    bits = 0;
    while (inCount) {
	/* fetch code */
	while (nBits < codeLen) {
	    bits = (bits<<8) | *from++;
	    inCount--;
	    nBits += 8;
	}
	shift = nBits - codeLen;
	code = (bits >> shift) & mask;
	bits &= ~(mask << shift);
	nBits -= codeLen;

	if (code == 257) break;
	if (code == 256) {
	    if (! inCount)
		break;

	    /* free stuff */
	    while (scratchBuffer->prev) {
		newBuffer = scratchBuffer;
		scratchBuffer = scratchBuffer->prev;
		free(newBuffer);
	    }
	    /* reset everything */
	    scratchPtr = scratchBuffer->chars + 256;
	    nScratch = sizeof(scratchBuffer->chars) - 256;
	    codeLen = 9;
	    nextCode = 258;
	    mask = 0x1FF;
	    /* fetch code */
	    while (nBits < codeLen) {
		bits = (bits<<8) | *from++;
		inCount--;
		nBits += 8;
	    }
	    shift = nBits - codeLen;
	    code = (bits >> shift) & mask;
	    bits &= ~(mask << shift);
	    nBits -= codeLen;
	    if (code == 257) break;
	    /* add to output */
	    if (to >= toEnd) {
		if (@global(InfoPrinting) == true) {
		    console_fprintf(stderr, "ImageReader [warning]: LZW outBuffer overrun\n");
		}
		ret = 0;
		break;
	    }
	    *to++ = code;
	    oldCode = code;
	} else {
	    if (code < nextCode) {
		/* writeString(string[code]) */
		len = stringLen[code];
		bcopy(strings[code], to, len);
		to += len;

		if (oldCode != -1) {
		    /* add( string[oldcode] + first(string[code]) ) */
		    len = stringLen[oldCode] + 1;
		    if (nScratch < len) {
			newBuffer = (struct buffer *)malloc(sizeof(struct buffer));
			if (! newBuffer) goto out;
			newBuffer->prev = scratchBuffer;
			scratchBuffer = newBuffer;
			scratchPtr = scratchBuffer->chars;
			nScratch = sizeof(scratchBuffer->chars);
		    }
		    stringLen[nextCode] = len;
		    strings[nextCode] = scratchPtr;
		    bcopy(strings[oldCode], scratchPtr, len-1);
		    scratchPtr += len-1;
		    *scratchPtr++ = strings[code][0];
		    nScratch -= len;
		    nextCode++;
		}
	    } else {
		if (oldCode == -1) {
		    /* bad input */
		    ret = 0;
		    goto out;
		}

		/* writeString(string[oldCode] + first(string[oldCode]) ) */
		len = stringLen[oldCode];
		if ((to+len) >= toEnd) {
		    if (@global(InfoPrinting) == true) {
			console_fprintf(stderr, "ImageReader [warning]: LZW outBuffer overrun\n");
		    }
		    ret = 0;
		    goto out;
		}
		bcopy(strings[oldCode], to, len);
		to += len;
		*to++ = strings[oldCode][0];

		/* add( string[oldcode] + first(string[oldCode]) ) */
		len++;
		if (nScratch < len) {
		    newBuffer = (struct buffer *)malloc(sizeof(struct buffer));
		    if (! newBuffer) goto out;
		    newBuffer->prev = scratchBuffer;
		    scratchBuffer = newBuffer;
		    scratchPtr = scratchBuffer->chars;
		    nScratch = sizeof(scratchBuffer->chars);
		}
		stringLen[nextCode] = len;
		strings[nextCode] = scratchPtr;
		bcopy(strings[oldCode], scratchPtr, len-1);
		scratchPtr += len-1;
		*scratchPtr++ = strings[oldCode][0];
		nScratch -= len;
		nextCode++;
	    }
	    oldCode = code;
	    if (nextCode >= 511) {
		if (nextCode == 511) {
		    codeLen = 10;
		    mask = 0x3FF;
		} else if (nextCode >= 1023) {
		    if (nextCode == 1023) {
			codeLen = 11;
			mask = 0x7FF;
		    } else {
			if (nextCode == 2047) {
			    codeLen = 12;
			    mask = 0xFFF;
			}
		    }
		}
	    }
	}
    }
out: ;
    /* free stuff */
    while (scratchBuffer) {
	newBuffer = scratchBuffer;
	scratchBuffer = scratchBuffer->prev;
	free(newBuffer);
    }

    free(strings);
    free(stringLen);

    if (from > fromEnd) {
	if (@global(InfoPrinting) == true) {
	    console_fprintf(stderr, "ImageReader [warning]: LZW inBuffer overrun\n");
	}
	ret = 0;
    }
    return ret;
}

/*
 * delta decoding (TIFF predictor = 2)
 */
static void
__decodeDelta__(register unsigned char *bytes, int width, int height)
{
	register int w;
	unsigned char r, g, b;

	while (height--) {
	    r = g = b = 0;
	    for (w = width; w; w--) {
		r += *bytes;
		*bytes++ = r;
		g += *bytes;
		*bytes++ = g;
		b += *bytes;
		*bytes++ = b;
	    }
	}
}

/*
 * GIF decompression
 */
static int
__decodeGIF__(unsigned char *from, unsigned char *to, int inCount, int initialCodeLen, int fromSize, int toSize)
{
    register unsigned code;
    unsigned short *prefix;
    unsigned short *suffix;
    unsigned short *outCode;
    int outCount;
    unsigned maxCode, oldCode, fin, inCode, curCode;
    register unsigned bits;
    register int nBits, mask, shift;
    int ret = 1;
    int i;
    int len;
    int endCode, clearCode, freeCode;
    int codeLen = initialCodeLen;
    unsigned char *fromEnd, *toEnd;
    static int ranges[] = {0, 1, 2, 4, 8, 16, 32, 64,
			   128, 256, 512, 1024, 2048 };

    fromEnd = from + fromSize;
    toEnd = to + toSize;

    if ((unsigned)codeLen > 12) {
	if (@global(InfoPrinting) == true) {
	    console_fprintf(stderr, "ImageReader [warning]: GIF bad codelen (>12)\n");
	}
	return 0;
    }
    prefix = (unsigned short *)malloc(sizeof(short) * 4096);
    if (! prefix) return 0;
    suffix  = (unsigned short *)malloc(sizeof(short) * 4096);
    if (! suffix) {
	free(prefix);
	return 0;
    }
    outCode = (unsigned short *)malloc(sizeof(short) * 4096);
    if (! outCode) {
	free(prefix);
	free(suffix);
	return 0;
    }
    clearCode = ranges[codeLen]; /* 256 */
    endCode = clearCode + 1;     /* 257 */
    freeCode = clearCode + 2;    /* 258 */
    maxCode = clearCode << 1;    /* 512 */
    outCount = 0;

    mask = maxCode - 1;          /* 1FF */
    nBits = 0;
    bits = 0;
    while (inCount) {
	/* fetch code */
	while (nBits < codeLen) {
	    bits = bits | (*from++ << nBits);
	    inCount--;
	    nBits += 8;
	}
	if (inCount <= 0)
	    break;
	code = bits & mask;
	bits >>= codeLen;
	nBits -= codeLen;
	if (code == endCode) break;
	if (code == clearCode) {
	    if (inCount <= 0)
		break;

	    codeLen = initialCodeLen;
	    maxCode = clearCode<<1;
	    mask = maxCode - 1;
	    freeCode = clearCode + 2;

	    /* fetch code */
	    while (nBits < codeLen) {
		bits = bits | (*from++ << nBits);
		inCount--;
		nBits += 8;
	    }
	    if (inCount <= 0)
		break;
	    code = bits & mask;
	    bits >>= codeLen;
	    nBits -= codeLen;
	    if (code == endCode) break;
	    /* add to output */
	    if (to >= toEnd) {
		if (@global(InfoPrinting) == true) {
		    console_fprintf(stderr, "ImageReader [warning]: GIF outBuffer overrun\n");
		}
		ret = 0;
		break;
	    }
	    *to++ = code;
	    oldCode = fin = curCode = code;
	} else {
	    curCode = inCode = code;
	    if (curCode >= freeCode) {
		curCode = oldCode;
		outCode[outCount++] = fin;
	    }

	    while (curCode >= clearCode) {
		if (outCount > 1024) {
		    goto out;
		}

		/* debugging and protecting myself from overwrites */
		if (curCode >= 4096) {
		    if (@global(InfoPrinting) == true) {
			console_fprintf(stderr, "ImageReader [warning]: GIF corrupted input (code > 4095)\n");
		    }
		    ret = 0;
		    break;
		}
		outCode[outCount++] = suffix[curCode];
		curCode = prefix[curCode];
	    }

	    fin = curCode;
	    outCode[outCount++] = fin;

#if 0
	    if ((to+outCount) >= toEnd) {
		if (@global(InfoPrinting) == true) {
		    console_fprintf(stderr, "ImageReader [warning]: GIF outBuffer overrun\n");
		}
		ret = 0;
		break;
	    }
#endif
	    for (i = outCount - 1; i >= 0; i--) {
		if (to >= toEnd) {
		    if (@global(InfoPrinting) == true) {
			console_fprintf(stderr, "ImageReader [warning]: GIF outBuffer overrun\n");
		    }
		    ret = 0;
		    break;
		}
		*to++ = outCode[i];
	    }
	    outCount = 0;

	    /* debugging and protecting myself from overwrites */
	    if (freeCode >= 4096) {
		if (@global(InfoPrinting) == true) {
		    console_fprintf(stderr, "ImageReader [warning]: GIF corrupted input (freeCode > 4095)\n");
		}
		ret = 0;
		break;
	    }

	    prefix[freeCode] = oldCode;
	    suffix[freeCode] = fin;
	    oldCode = inCode;

	    freeCode++;
	    if (freeCode >= maxCode) {
		if (codeLen < 12) {
		    codeLen++;
		    maxCode *= 2;
		    mask = (1 << codeLen) - 1;
		}
	    }
	}
    }
out: ;
    free(prefix);
    free(suffix);
    free(outCode);

    if (from > fromEnd) {
	if (@global(InfoPrinting) == true) {
	    console_fprintf(stderr, "ImageReader [warning]: GIF inBuffer overrun\n");
	}
	ret = 0;
    }
    return ret;
}

%}
! !

!ImageReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    Abstract class to provide common functions for image-readers/writers.
    (i.e. TIFFReader, GIFReader etc.).

    In contrast to what the name suggests, ImageReaders are supposed to support
    both reading and writing of images
    (i.e. the name is somewhat outdated, but kept for historic and backward
    compatibility reasons).
    They provide functionality similar to Squeak's ImageReaderWriter classes.

    ImageReaders are created temporary to read an image from a stream.
    Normally, they are not directly used - instead, the image class is
    asked to read some file, and return an instance for it:
	Image fromFile:<someFileName>
    The Image class will guess the image's format and forward the task to
    some concrete ImageReaderClass.
    If that class thinks, that the file's format is incorrect,
    other readers are tried until some reader class finds the file's format acceptable.

    Image readers read the stream and collect all relevant information internally.
    Once done with reading, the actual image object is created and
    data filled in from the imageReaders collected info.

    See the implementation of #fromStream: in concrete subclasses.
    The public interfaces are:
	 <ConcreteReaderClass> fromFile:aFilename
    or:
	 <ConcreteReaderClass> fromStream:aStream

    If you add a new reader, don't forget to add the method #isValidImageFile:
    which should return true, if this reader supports reading a given file.

    If your new reader class supports writing files, don't forget to add
    #canRepresent:anImage and return true from this method.

    writing:
	tell the image, to save itself, via <image> saveOn:fileName
	or <image> saveOn:fileName using:<readerClass>

    [See also:]
	Image Icon Form

    [author:]
	Claus Gittinger
"
! !

!ImageReader class methodsFor:'instance creation'!

new
    ^ self basicNew initialize

    "Created: 18.2.1997 / 17:08:45 / cg"
! !

!ImageReader class methodsFor:'cleanup'!

lowSpaceCleanup
    "cleanup things we do not need"

    ReverseBits := nil
! !

!ImageReader class methodsFor:'constants'!

reverseBits
    "return a table filled with bit reverse information.
     To convert from msbit-first to lsbit-first bytes, use
     the value as index into the table, retrieving the reverse
     value. Since indexing must start at 1, use (value + 1) as
     index."

    |val "{ Class: SmallInteger }" |

    ReverseBits isNil ifTrue:[
	ReverseBits := ByteArray uninitializedNew:256.
	0 to:255 do:[:i |
	    val := 0.
	    (i bitTest:16r01) ifTrue:[val := val bitOr:16r80].
	    (i bitTest:16r02) ifTrue:[val := val bitOr:16r40].
	    (i bitTest:16r04) ifTrue:[val := val bitOr:16r20].
	    (i bitTest:16r08) ifTrue:[val := val bitOr:16r10].
	    (i bitTest:16r10) ifTrue:[val := val bitOr:16r08].
	    (i bitTest:16r20) ifTrue:[val := val bitOr:16r04].
	    (i bitTest:16r40) ifTrue:[val := val bitOr:16r02].
	    (i bitTest:16r80) ifTrue:[val := val bitOr:16r01].
	    ReverseBits at:(i + 1) put:val
	]
    ].
    ^ ReverseBits
! !

!ImageReader class methodsFor:'decompression support'!

decodeDelta:step in:data width:width height:height
    "perform NeXT special predictor delta decoding inplace in data.
     Calls primitive c function for speed"

    (step ~~ 3) ifTrue:[
	^ self error:'only rgb pictures supported'
    ].

%{
    if (__isByteArray(data)
     && __bothSmallInteger(width, height)) {
	__decodeDelta__(__ByteArrayInstPtr(data)->ba_element,
		    __intVal(width), __intVal(height));
	RETURN ( self );
    }
%}
.
    self primitiveFailed
!

decompressCCITT3From:srcBytes into:dstBytes startingAt:offset count:count
    "decompress CCITT Group 3 compressed image data.
     count bytes from srcBytes are decompressed into dstBytes.
     Calls primitive c function for speed"
%{
    if (__isByteArrayLike(srcBytes)
     && __isByteArray(dstBytes)
     && __bothSmallInteger(offset, count)) {
	if (__decodeCCITTgroup3__(__ByteArrayInstPtr(srcBytes)->ba_element,
				  __ByteArrayInstPtr(dstBytes)->ba_element
				  + __intVal(offset) - 1,
				  __intVal(count))) {
	    RETURN ( self );
	}
    }
%}
.
    self primitiveFailed
!

decompressGIFFrom:srcBytes count:count into:dstBytes startingAt:offset codeLen:codeLen
    "decompress GIF compressed image data.
     count bytes from srcBytes are decompressed into dstBytes.
     Calls primitive c function for speed"
%{
    if (__isByteArrayLike(srcBytes)
     && __isByteArray(dstBytes)
     && __bothSmallInteger(codeLen, offset)
     && __isSmallInteger(count)) {
	if (__decodeGIF__(__ByteArrayInstPtr(srcBytes)->ba_element,
			  __ByteArrayInstPtr(dstBytes)->ba_element
						+__intVal(offset) - 1,
			  __intVal(count),
			  __intVal(codeLen),
			  __byteArraySize(srcBytes),
			  __byteArraySize(dstBytes)
			 )) {
	    RETURN ( self );
	}
    }
%}
.
    self primitiveFailed
!

decompressLZWFrom:srcBytes count:count into:dstBytes startingAt:offset
    "decompress LZW (tiff) compressed image data.
     count bytes from srcBytes are decompressed into dstBytes.
     Calls primitive c function for speed"
%{
    if (__isByteArrayLike(srcBytes)
     && __isByteArray(dstBytes)
     && __bothSmallInteger(offset, count)) {
	if (__decodeLZW__(__ByteArrayInstPtr(srcBytes)->ba_element,
			  __ByteArrayInstPtr(dstBytes)->ba_element
					      + __intVal(offset) - 1,
			  __intVal(count),
			  __byteArraySize(srcBytes),
			  __byteArraySize(dstBytes)
			)) {
	    RETURN ( self );
	}
    }
%}
.
    self primitiveFailed
!

decompressPackBits:nIn from:srcBytes to:dstBytes startingAt:dstOffset
    "decompress a number of input bytes.
     Used by tiff and some mac image formats.
     Return the number of decompressed output bytes."

    |i b n v dstOffs|

    dstOffs := dstOffset.
    i := 1.

    [i <= nIn] whileTrue:[
	b := srcBytes at:i.
	i := i + 1.

	b ~~ 16rFF ifTrue:[   "/ not a NOP
	    b <= 127 ifTrue:[
		"/ 0..127 literal bytes
		n := b + 1.
		dstBytes replaceFrom:dstOffs to:dstOffs+n-1 with:srcBytes startingAt:i.
		i := i + n.
	    ] ifFalse:[
		"/ 128..254 a run
		n := b - 125.

		v := srcBytes at:i.
		i := i + 1.

		dstBytes from:dstOffs to:dstOffs+n put:v.
	    ].
	    dstOffs := dstOffs + n.
	]
    ].
    ^ dstOffs - dstOffset

    "Created: / 1.12.1997 / 18:39:23 / cg"
    "Modified: / 1.12.1997 / 18:49:58 / cg"
!

decompressPackBitsFrom:srcBytes at:srcStart to:dstBytes at:dstStart count:outCount
    "decompress until a number of output bytes has been decompressed.
     Used by some mac image formats.
     Return the number of processed input bytes."

    |i b n v dstOffs nRemaining|

    dstOffs := dstStart.
    i := srcStart.
    nRemaining := outCount.
    [nRemaining > 0] whileTrue:[
	b := srcBytes at:i.
	i := i + 1.

	b ~~ 16rFF ifTrue:[   "/ not a NOP
	    b <= 127 ifTrue:[
		"/ 0..127 literal bytes
		n := b + 1.
		dstBytes replaceFrom:dstOffs to:dstOffs+n-1 with:srcBytes startingAt:i.
		nRemaining := nRemaining - n.
		i := i + n.
	    ] ifFalse:[
		"/ 128..254 a run
		n := b - 125.

		v := srcBytes at:i.
		i := i + 1.

		dstBytes from:dstOffs to:dstOffs+n-1 put:v.
		nRemaining := nRemaining - n.
	    ].
	    dstOffs := dstOffs + n.
	]
    ].
    ^ i-srcStart
!

decompressRLEFrom:srcBytes at:srcStartIndex into:dstBytes at:dstStartIndex increment:dstIncrement
    "common helper to expand RLE encoded data"

    "/ the code below expands common RLE formats, where the high bit
    "/ controls how the count in the low 7 bits is to be interpreted:
    "/ 1 means: count verbatim bytes follow;
    "/ 0 means: repeat the next byte count times.
    "/ Decoding stops when a 0-count is encountered.
    "/ srcBytes and dstBytes should not overlap.
    "/ dstIncrement controls the stepping in the destination (usually: 1)
    "/
    "/ this may be recoded in C in the future

    |srcIdx "{Class: SmallInteger }"
     dstIdx "{Class: SmallInteger }"
     pixel  "{Class: SmallInteger }"
     count  "{Class: SmallInteger }"|

    srcIdx := srcStartIndex.
    dstIdx := dstStartIndex.
    [true] whileTrue:[
	pixel := srcBytes at:srcIdx.
	count := pixel bitAnd:16r7F.
	count == 0 ifTrue:[
	    ^ self
	].
	srcIdx := srcIdx + 1.
	(pixel bitAnd:16r80) == 0 ifTrue:[
	    "/ run bytes
	    pixel := srcBytes at:srcIdx.
	    srcIdx := srcIdx + 1.
	    dstIncrement == 1 ifTrue:[
		dstBytes from:dstIdx to:(dstIdx+count-1) put:pixel.
		dstIdx := dstIdx + count.
	    ] ifFalse:[
		1 to:count do:[:c |
		    dstBytes at:dstIdx put:pixel.
		    dstIdx := dstIdx + dstIncrement.
		]
	    ]
	] ifFalse:[
	    "/ verbatim bytes
	    dstIncrement == 1 ifTrue:[
		dstBytes replaceFrom:dstIdx to:(dstIdx+count-1) with:srcBytes startingAt:srcIdx.
		srcIdx := srcIdx + count.
		dstIdx := dstIdx + count.
	    ] ifFalse:[
		1 to:count do:[:c |
		    dstBytes at:dstIdx put:(srcBytes at:srcIdx).
		    srcIdx := srcIdx + 1.
		    dstIdx := dstIdx + dstIncrement.
		]
	    ]
	]
    ].

    "Modified: 23.4.1997 / 18:54:05 / cg"
!

swap:nBytes bytesFromRGBA_to_BGRA_in:data startingAt:startIndex
    "swap bytes from RGBA into BGRA order.
     The argument is a pixel data buffer (byteArray)"

    self swap:(nBytes//4) pixelsFromRGB_to_BGR_in:data startingAt:startIndex bytesPerPixel:4

    "
     |bytes|

     bytes := #[ 0 1 2 3 4 5 6 7 8 9 ].
     self swap:6 bytesFromRGB_to_BGR_in:bytes startingAt:1.
     bytes.
    "
    "
     |bytes|

     bytes := ByteArray new:1000000.
     bytes replaceFrom:1 with:#[ 0 1 2 3 4 5 6 7 8 9 10 11 12].
     Time millisecondsToRun:[
	self swap:1000000 bytesFromRGB_to_BGR_in:bytes.
     ].
     bytes copyTo:10.
    "
!

swap:nBytes bytesFromRGB_to_BGR_in:data
    "swap bytes from RGB into BGR order.
     The argument is a pixel data buffer (byteArray)"

    self swap:(nBytes//3) pixelsFromRGB_to_BGR_in:data startingAt:1 bytesPerPixel:3

    "
     |bytes|

     bytes := #[ 0 1 2 3 4 5 6 7 8 9 ].
     self swap:6 bytesFromRGB_to_BGR_in:bytes.
     bytes.
    "
    "
     |bytes|

     bytes := ByteArray new:1000000.
     bytes replaceFrom:1 with:#[ 0 1 2 3 4 5 6 7 8 9 10 11 12].
     Time millisecondsToRun:[
	self swap:1000000 bytesFromRGB_to_BGR_in:bytes.
     ].
     bytes copyTo:10.
    "
!

swap:nBytes bytesFromRGB_to_BGR_in:data startingAt:startIndex
    "swap bytes from RGB into BGR order.
     The argument is a pixel data buffer (byteArray)"

    self swap:(nBytes//3) pixelsFromRGB_to_BGR_in:data startingAt:startIndex bytesPerPixel:3

    "
     |bytes|

     bytes := #[ 0 1 2 3 4 5 6 7 8 9 ].
     self swap:6 bytesFromRGB_to_BGR_in:bytes startingAt:1.
     bytes.
    "
    "
     |bytes|

     bytes := ByteArray new:1000000.
     bytes replaceFrom:1 with:#[ 0 1 2 3 4 5 6 7 8 9 10 11 12].
     Time millisecondsToRun:[
	self swap:1000000 bytesFromRGB_to_BGR_in:bytes.
     ].
     bytes copyTo:10.
    "
!

swap:count pixelsFromRGB_to_BGR_in:data startingAt:startIndex bytesPerPixel:bpp
    "swap bytes from RGB into BGR order.
     The argument is a pixel data buffer (byteArray).
     Can be used for both 24bit rgb data (bpp=3) or rgba data (bpp=4)"

    |t idx|

%{  /* OPTIONAL */
    if (__isByteArray(data)
     && __isSmallInteger(count)
     && __isSmallInteger(startIndex)
     && __isSmallInteger(bpp)) {
	INT __count = __intVal(count);
	INT __startOffset = __intVal(startIndex) - 1;
	INT __dataSize = __byteArraySize(data);
	int __bpp = __intVal(bpp);
	INT __nBytes = __count * __bpp;

	if ((__startOffset + __nBytes) <= __dataSize) {
	    unsigned char *__cp = __ByteArrayInstPtr(data)->ba_element + __startOffset;

	    while (__count-- > 0) {
		unsigned char __t;

		__t = __cp[0];
		__cp[0] = __cp[2];
		__cp[2] = __t;
		__cp += __bpp;
	    }
	    RETURN (true);
	}
    }
%}.
    idx := startIndex.
    1 to:count do:[:i |
	t := data at:idx.
	data at:idx put:(data at:idx+2).
	data at:idx+2 put:t.
	idx := idx + bpp.
    ].

    "
     |bytes|

     bytes := #[ 0 1 2  3 4 5  6 7 8  9 ].
     self swap:2 pixelsFromRGB_to_BGR_in:bytes startingAt:1 bytesPerPixel:3.
     bytes.
    "

    "
     |bytes|

     bytes := #[ 0 1 2 3  4 5 6 7  8 9 ].
     self swap:2 pixelsFromRGB_to_BGR_in:bytes startingAt:1 bytesPerPixel:4.
     bytes.
    "
! !

!ImageReader class methodsFor:'i/o support'!

streamReadingFile:aFilename
    "return a stream to read aFilename.
     If the filename ends with '.Z' or '.gz', return a stream
     to a pipe for the uncompressor. Otherwise, return a stream to read
     the file directly."

    |inStream name fn|

    name := aFilename asString.
    ((name endsWith:'.Z') or:[name endsWith:'.gz']) ifTrue:[
	fn := Smalltalk getSystemFileName:name.
	inStream := PipeStream readingFrom:'gunzip < ' , fn.
    ] ifFalse:[
	inStream := Smalltalk systemFileStreamFor:aFilename.
	inStream isNil ifTrue:[
	    inStream := Smalltalk bitmapFileStreamFor:aFilename
	]
    ].
    inStream isNil ifTrue:[
	'ImageReader [warning]: open error on: ' infoPrint. aFilename infoPrintCR.
    ].
    ^ inStream

    "Modified: 31.1.1997 / 10:37:24 / cg"
! !

!ImageReader class methodsFor:'image reading'!

fromBytes:aByteArray
    "read an image (in my format) from aByteArray.
     Return the image or nil (if unrecognized format or error)"

    |reader|

    reader := self readStream:aByteArray readStream.
    ^ reader image
!

fromFile:aFileName
    "read an image (in my format) from aFileName.
     Return the image or nil on error."

    |reader|

    reader := self readFile:aFileName.
    reader notNil ifTrue:[
	^ reader image
    ].
    ^ nil

    "
     XBMReader fromFile:'bitmaps/SBrowser.xbm'
     XPMReader fromFile:'bitmaps/xpmBitmaps/misc_icons/BOOK.xpm'
     XBMReader fromFile:'bitmaps/xpmBitmaps/misc_icons/BOOK.xpm'
    "

    "Modified: 4.4.1997 / 22:09:49 / cg"
!

fromStream:aStream
    "read an image (in my format) from aStream.
     Return the image or nil (if unrecognized format or error).
     The stream remains open."

    |reader|

    reader := self readStream:aStream.
    ^ reader image
!

fromURL:url
    "read an image (in my format) from url.
     Return the image or nil (if unrecognized format or error)"

    |readerClass response|

    self == ImageReader ifTrue:[
	"select a reader supporting this file format"
	readerClass := self readerClassForFilename:url asURL path.
	readerClass ~~ self ifTrue:[
	    ^ readerClass fromURL:url.
	].
    ].

    response := HTTPInterface get:url.
    response isErrorResponse ifTrue:[
	self error:'failed to read url' mayProceed:true.
	^ nil
    ].
    ^ self fromBytes:(response data).

    "
     self fromURL:'http://www.lutece.paris.fr/tech/images/helloworld.png'
    "
!

imagesFromFile:aFileName
    "read all images (in my format) from aFileName.
     Return a collection of images or nil on error.
     Not all reader may support multiple images."

    |reader|

    reader := self readFile:aFileName.
    reader notNil ifTrue:[
	^ reader images
    ].
    ^ nil

    "Modified: 4.4.1997 / 22:11:01 / cg"
!

imagesFromStream:aStream
    "read all images (in my format) from aStream.
     Return a collection of images or nil (if unrecognized format or error).
     The stream remains open.
     Not all reader may support multiple images."

    |reader|

    reader := self new.
    reader inStream:aStream.
    reader fromStream:aStream.
    ^ reader images

    "Modified: 4.4.1997 / 22:11:40 / cg"
!

readFile:aFilename
    "create a reader and let it read an image (in my format) from aFilename.
     Return the reader, NOT the image (however, the reader has already read the image,
     so it can be asked with 'reader image')."

    |readerClass reader inStream|

    self == ImageReader ifTrue:[
	"select a reader supporting this file format"
	readerClass := self readerClassForFilename:aFilename.
	readerClass ~~ self ifTrue:[
	    ^ readerClass readFile:aFilename.
	].
    ].

    inStream := self streamReadingFile:aFilename.
    inStream isNil ifTrue:[
	'ImageReader [warning]: file open error' errorPrintCR.
	^ nil
    ].
    reader := self new.
    reader inStream:inStream.
    [
	reader fromStream:inStream.
    ] ensure:[
	inStream close.
    ].
    ^ reader

    "
     XPMReader readFile:'../../goodies/bitmaps/xpmBitmaps/misc_icons/BOOK.xpm'
     (XPMReader readFile:'../../goodies/bitmaps/xpmBitmaps/misc_icons/BOOK.xpm') image
    "

    "Modified: / 04-04-2011 / 14:16:56 / cg"
!

readStream:aStream
    "create a reader and let it read a stream (in my format).
     Return the reader, NOT the image (however, the reader has already read the image,
     so it can be asked with 'reader image').
     The stream remains open."

    |reader|

    reader := self new.
    reader fromStream:aStream.
    ^ reader

    "Created: 4.4.1997 / 22:08:13 / cg"
!

readerClassForFilename:aStringOrFilename
    "return a reader class, determined by the file's name"

    |mime reader|

    mime := aStringOrFilename asFilename mimeTypeFromName.
    mime isNil ifTrue:[
	mime := aStringOrFilename asFilename mimeTypeOfContents.
    ].

    mime notNil ifTrue:[
	reader := MIMETypes imageReaderForType:mime.
    ].
    reader isNil ifTrue:[
	"answer the reader when proceeding form this error"
	reader := ConversionError raiseRequestErrorString:(' - unsupported image type: ''%1''' bindWith:(mime ? aStringOrFilename asFilename suffix)).
    ].
    ^ reader

    "
     self readerClassForFilename:('http://www.foo.bar/helloworld.png' asURL path)
     self readerClassForFilename:('http://www.foo.bar/helloworld.gif' asURL path)
    "
! !

!ImageReader class methodsFor:'image support'!

buildMaskFromColor:maskPixelValue for:pixels width:width height:height
    "helper for image formats, where an individual pixel value
     has been defined as a mask-pixel (i.e. GIF).
     Creates a maskImage, with zeros at positions where the image
     has the given pixelValue; all other mask pixels are set to 1."

    |maskArray bytesPerMaskRow mask|

    bytesPerMaskRow := (width+7) // 8.

    maskArray := ByteArray uninitializedNew:bytesPerMaskRow * height.

%{
    int __w = __intVal(width);
    int __h = __intVal(height);
    int __x, __y;
    int __outBits, __nOut;
    unsigned char *__inP, *__outP, *__nextOutRow;
    int __bpr = __intVal(bytesPerMaskRow);
    int __maskPixel = __intVal(maskPixelValue);
#ifdef DEBUG
    unsigned char *outEnd;
#endif

    if (! __isByteArrayLike(pixels)) goto fail;
    if (! __isByteArray(maskArray)) goto fail;

    __inP = __ByteArrayInstPtr(pixels)->ba_element;
    __outP = __ByteArrayInstPtr(maskArray)->ba_element;

#ifdef DEBUG
    outEnd = __outP + (__byteArraySize(maskArray));
#endif
/*
printf("outP: %x outEnd: %x sz: %d\n", __outP, outEnd, __byteArraySize(maskArray));
*/

    for (__y=__h; __y>0; __y--) {
	__outBits = 0;
	__nOut = 8;
	__nextOutRow = __outP + __bpr;

	for (__x=__w; __x>=8; __x-=8) {
	    if (__inP[0] != __maskPixel) { __outBits |= 0x80; };
	    if (__inP[1] != __maskPixel) { __outBits |= 0x40; };
	    if (__inP[2] != __maskPixel) { __outBits |= 0x20; };
	    if (__inP[3] != __maskPixel) { __outBits |= 0x10; };
	    if (__inP[4] != __maskPixel) { __outBits |= 0x08; };
	    if (__inP[5] != __maskPixel) { __outBits |= 0x04; };
	    if (__inP[6] != __maskPixel) { __outBits |= 0x02; };
	    if (__inP[7] != __maskPixel) { __outBits |= 0x01; };
	    __inP += 8;
	    *__outP++ = __outBits;
	    __outBits = 0;
	}
	for (; __x>0; __x--) {
	    __outBits <<= 1;
	    if (*__inP != __maskPixel) {
		__outBits |= 1;
	    }
	    __inP++;

/*
 printf("x: %d  bits: %x\n", __x, __outBits);
*/
	    if (--__nOut == 0) {
#ifdef DEBUG
		if (__outP >= outEnd) {
		    if (@global(InfoPrinting) == true) {
			console_fprintf(stderr, "oops %d\n", __LINE__);
		    }
		    goto fail;
		}
#endif
		*__outP = __outBits;

		__outP++;
		__nOut = 8;
		__outBits = 0;
	    }
	}

	if (__nOut != 8) {
	    __outBits <<= __nOut;

#ifdef DEBUG
	    if (__outP >= outEnd) {
		if (@global(InfoPrinting) == true) {
		    console_fprintf(stderr, "oops2 %d\n", __LINE__);
		}
		goto fail;
	    }
#endif
	    *__outP = __outBits;

	}
	__outP = __nextOutRow;
    }
fail: ;
%}.
    mask := ImageMask width:width height:height fromArray:maskArray.
    ^ mask

    "Created: 21.6.1996 / 11:43:47 / cg"
! !

!ImageReader class methodsFor:'image writing'!

save:anImage onFile:aFileName
    "save the image in my format on aFileName"

    ^ (self basicNew) save:anImage onFile:aFileName

    "Modified: 10.4.1997 / 17:42:57 / cg"
!

save:anImage onFile:aFileName quality:qualityPercent
    "save the image in my format on aFileName.
     qualityPercent is ignored by all lossless formats.
     JPG does care for it."

    ^ (self basicNew) save:anImage onFile:aFileName quality:qualityPercent

    "Modified: 10.4.1997 / 17:42:57 / cg"
!

save:anImage onStream:aStream
    "save the image in my format on a Stream"

    ^ (self basicNew) save:anImage onStream:aStream

    "Modified: 10.4.1997 / 17:42:57 / cg"
!

save:anImage onStream:aStream quality:qualityPercent
    "save the image in my format on a Stream.
     qualityPercent is ignored by all lossless formats.
     JPG does care for it."

    ^ (self basicNew) save:anImage onStream:aStream quality:qualityPercent

    "
     (Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif') saveOn:'garfield.gif'
     (Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif') saveOn:'garfield.jpg'
     (Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif') saveOn:'garfield50.jpg' quality:50
     (Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif') saveOn:'garfield100.jpg' quality:100
    "
! !

!ImageReader class methodsFor:'testing'!

canRepresent:anImage
    "return true, if anImage can be represented in my file format.
     must be redefined in concrete subclasses which support saving."

    ^ false
!

isValidImageFile:aFileName
    "return true, if aFileName contains an image this
     reader understands - must be redefined in concrete subclasses
     which support reading."

    ^ false
! !

!ImageReader methodsFor:'accessing'!

bitsPerPixel
    "return the number of bits per pixel"

    bitsPerSample isNil ifTrue:[^ nil].
    ^ bitsPerSample sum
!

bitsPerRow
    "return the number of bits in one scanline of the image"

    ^ width * (self bitsPerPixel).

    "Created: 31.1.1997 / 10:38:42 / cg"
!

bitsPerSample
    "return the number of bits per sample"

    ^ bitsPerSample

    "Modified: 22.4.1996 / 19:15:18 / cg"
!

bytesPerRow
    "return the number of bytes in one scanline of the image"

    |bitsPerRow bytesPerRow|

    bitsPerRow := width * (self bitsPerPixel).
    bytesPerRow := bitsPerRow // 8.
    ((bitsPerRow \\ 8) ~~ 0) ifTrue:[
	bytesPerRow := bytesPerRow + 1
    ].
    ^ bytesPerRow

    "Created: 31.1.1997 / 10:39:06 / cg"
!

colorMap
    "return the colormap"

    ^ colorMap

    "Modified: 22.4.1996 / 19:15:24 / cg"
!

compressQuality:qualityPercentIgnoredHere
    "/ intentionally ignored here (redefined in JPEGReader)
!

data
    "return the raw image data"

    ^ data

    "Modified: 22.4.1996 / 19:15:31 / cg"
!

hasMultipleImages
    ^ imageSequence size > 1

    "Created: 4.4.1997 / 21:37:06 / cg"
    "Modified: 24.6.1997 / 15:33:43 / cg"
!

height
    "return the height of the image"

    ^ height

    "Modified: 22.4.1996 / 19:15:39 / cg"
!

image
    "return the image as represented by myself;
     If my file contained multiple images, return the first one."

    imageSequence size > 0 ifTrue:[
	^ self images first.
    ].

    ^ self makeImage.

    "Modified: / 15.1.1998 / 15:46:24 / stefan"
    "Modified: / 1.4.1998 / 14:31:35 / cg"
!

imageFrames
    "return a collection of all imageFrames as represented by myself.
     ImageFrames are wrappers for individual images, which hold
     additional information (such as image delay time).
     Nil is return for single image formats/files."

    ^ imageSequence

    "Created: / 1.4.1998 / 14:37:42 / cg"
!

images
    "return a collection of all images as represented by myself.
     For compatibility with single-image formats, return a collection
     containing my single image here if the reader does not support
     multiple images.
     Readers for formats with multiple images should leave the images
     in the imageSequence instVar as a side effect of reading."

    |img|

    imageSequence notNil ifTrue:[
	^ (imageSequence collect:[:aFrame | aFrame image])
    ].

    img := self makeImage.
    img isNil ifTrue:[
	^ img
    ].
    ^ Array with:img

    "Modified: / 1.4.1998 / 14:36:23 / cg"
!

makeImage
    "return the image as represented by the values found in my
     instvars; these have been typically set as a side effect of
     the fromStream:-method, which reads images."

    |image depth|

    depth := self bitsPerPixel.
    (depth notNil and:[data notNil]) ifTrue:[
	image := Image newForDepth:depth.
	image depth:depth.
	inStream isFileStream ifTrue:[
	    image fileName:inStream pathName.
	].
	image
	    width:width
	    height:height
	    photometric:photometric
	    samplesPerPixel:samplesPerPixel
	    bitsPerSample:bitsPerSample
	    colorMap:colorMap
	    bits:data
	    mask:mask.

	imageSequence notNil ifTrue:[
	    image imageSequence:imageSequence.
	].
	(metaData notNil and:[metaData notEmpty]) ifTrue:[
	    image metaData:metaData
	].
    ].
    ^ image

    "Modified: / 15.1.1998 / 15:46:24 / stefan"
    "Created: / 1.4.1998 / 14:09:45 / cg"
    "Modified: / 1.4.1998 / 14:41:35 / cg"
!

mask
    "return the image mask (or nil)"

    ^ mask

    "Modified: 22.4.1996 / 19:15:31 / cg"
    "Created: 20.6.1996 / 17:08:29 / cg"
!

numberOfImages
    "return the number of images as read.
     By default (here), I hold a single image;
     however, some fileFormats allow for multiple images"

    |n|

    (n := imageSequence size) > 0 ifTrue:[
	^ n
    ].
    ^ 1

    "Created: 21.6.1997 / 18:33:45 / cg"
    "Modified: 24.6.1997 / 15:33:26 / cg"
!

photometric
    "return the photometric interpretation of the image data.
     This may be a somewhat old leftover from times, when tiff was the first image file type to be read.
     Much better would be to always have some (possibly fake and virtual) colormap around, and ask that one.
     However, in the meantime, many other classes depend on that, so that it should be kept as an API
     - even when the internal representation will be replaced by something better in the future."

    ^ photometric

    "Modified: 22.4.1996 / 19:15:57 / cg"
!

samplesPerPixel
    "return the number of samples per pixel"

    ^ samplesPerPixel

    "Modified: 22.4.1996 / 19:16:03 / cg"
!

width
    "return the width of the image"

    ^ width

    "Modified: 22.4.1996 / 19:16:10 / cg"
! !

!ImageReader methodsFor:'accessing-private'!

byteOrder:aSymbol
    "set the byte order - either #lsb or #msb"

    byteOrder := aSymbol

    "Created: 15.2.1997 / 13:58:50 / cg"
!

inStream
    ^ inStream

    "Created: 15.2.1997 / 13:57:40 / cg"
!

inStream:aStream
    inStream := aStream

    "Created: 15.2.1997 / 13:57:35 / cg"
! !

!ImageReader methodsFor:'error reporting'!

fileFormatError:aMessage
    "report a format error - no image could be read"

    |errorString|

    errorString := self class name , ' [info]: ' , aMessage.
    inStream isFileStream ifTrue:[
	errorString := errorString , ' [in ' , inStream pathName , ']'
    ].

    Image badImageFormatQuerySignal raiseRequestErrorString:errorString.
    ^ nil

    "Created: / 3.2.1998 / 17:50:06 / cg"
! !

!ImageReader methodsFor:'i/o support'!

readLong
    "return the next 4-byte long, honoring the byte-order"

    ^ inStream nextInt32MSB:(byteOrder ~~ #lsb)
!

readShort
    "return the next 2-byte short, honoring the byte-order"

    ^ inStream nextUnsignedInt16MSB:(byteOrder ~~ #lsb)
!

readShortLong
    "return the next 2-byte short, honoring the byte-order.
     There are actually 4 bytes read, but only 2 looked at."

    |bytes val|

    bytes := ByteArray uninitializedNew:4.
    inStream nextBytes:4 into:bytes.
    (byteOrder == #lsb) ifTrue:[
	val := bytes at:2.
	val := val * 256 + (bytes at:1)
    ] ifFalse:[
	val := bytes at:3.
	val := val * 256 + (bytes at:4)
    ].
    ^ val
!

readUnsignedLong
    "return the next 4-byte long, honoring the byte-order"

    ^ inStream nextUnsignedInt32MSB:(byteOrder ~~ #lsb)
!

writeLong:anInteger
    "write a 4-byte long, honoring the byte-order."

    outStream nextPutInt32:anInteger MSB:(byteOrder ~~ #lsb)
!

writeShort:anInteger
    "write a 2-byte short, honoring the byte-order."

    outStream nextPutInt16:anInteger MSB:(byteOrder ~~ #lsb)
! !

!ImageReader methodsFor:'image reading'!

fromStream:aStream
    "read an image in my format from aStream.
     Leave image description in instance variables."

    self inStream:aStream.
    self readImage.
!

readImage
    "read an image in my format from my inStream.
     Leave image description in instance variables."

    self subclassResponsibility.
! !

!ImageReader methodsFor:'image reading support'!

buildMaskFromColor:maskPixelValue
    "helper for image formats, where an individual pixel value
     has been defined as a mask-pixel (i.e. GIF).
     Creates a maskImage, with zeros at positions where the image
     has the given pixelValue; all other mask pixels are set to 1."

    mask := self class
		buildMaskFromColor:maskPixelValue
		for:data
		width:width
		height:height

    "Modified: / 14.1.1998 / 14:48:33 / cg"
! !

!ImageReader methodsFor:'image writing'!

save:image onFile:aFileName
    "save image in my format on aFile"

    self writingFile:aFileName for:image do:[:stream |
	self save:image onStream:stream.
    ].
!

save:image onFile:aFileName quality:qualityPercentOrNil
    "save image in my format on aFile"

    self compressQuality:qualityPercentOrNil.
    self save:image onFile:aFileName

    "Modified: / 01-06-2010 / 19:02:17 / cg"
!

save:image onStream:aStream
    "save image in my file-format onto aStream"

    ^ Image cannotRepresentImageSignal
	raiseWith:image
	errorString:('image save not implemented/supported for this format').
!

save:image onStream:aStream quality:qualityPercentOrNil
    "save image in my format on a Stream.
     QualityPercent is ignored by lossless formats (jpg uses it)"

    self compressQuality:qualityPercentOrNil.
    self save:image onStream:aStream
!

saveAll:aCollectionOfImages onFile:aFileName
    "save a collection of images in my format on aFile.
     Not all file formats support multiple images, so be prepared
     for an exception to be raised."

    self writingFile:aFileName for:aCollectionOfImages do:[:stream |
	self saveAll:aCollectionOfImages onStream:stream.
    ].

    "Modified: / 01-06-2010 / 19:02:17 / cg"
!

saveAll:aCollectionOfImages onStream:aStream
    "save an image collection in my format on a Stream.
     Not all file formats support multiple images, so be prepared
     for an exception to be raised."

    ^ Image cannotRepresentImageSignal
	raiseWith:aCollectionOfImages
	errorString:('save of imageSequence not implemented/supported for this format').
!

writingFile:aFileName for:something do:aBlock
    "helper for save image"

    |stream|

    [
        stream := aFileName asFilename newReadWriteStream.
    ] on:FileStream openErrorSignal do:[:ex|
        ^ Image fileCreationErrorSignal
            raiseWith:something
            errorString:('file creation error: ' , aFileName asString).
    ].

    [
        [
            aBlock value: stream
        ] ensure:[
            stream close.
        ].
    ] ifCurtailed:[
        OsError catch:[
            aFileName asFilename delete.
        ]
    ].
! !

!ImageReader methodsFor:'initialization'!

initialize

    "Created: 18.2.1997 / 17:08:31 / cg"
! !

!ImageReader methodsFor:'progress reporting'!

dimensionCallBack:aBlock
    "set the block, which is evaluated during the readProcess, as soon as
     the images dimension is known. This is useful for background image reading,
     if the size is need to be known (for example: for formatting purposes).
     Obsoleted by dimensionHolder."

    <resource:#obsolete>
    self obsoleteMethodWarning:'use #dimensionHolder'.
    dimensionCallBack := aBlock

    "Created: 14.9.1996 / 17:10:58 / cg"
!

dimensionHolder:aValueHolderOrBlock
    "set the valueHolder or block, which is evaluated during the readProcess,
     as soon as the images dimension is known.
     Useful for background image reading, if the size is need to be known (for example: for formatting purposes)."

    dimensionHolder := aValueHolderOrBlock
!

progressHolder:aValueHolderOrBlock
    "set the valueHolder or block, which is evaluated during the readProcess,
     and set with progress information (0..100 percent).
     Useful for user feedback"

    progressHolder := aValueHolderOrBlock
!

reportDimension
    dimensionCallBack notNil ifTrue:[
	dimensionCallBack value:self
    ].
    dimensionHolder notNil ifTrue:[
	dimensionHolder value:(width @ height)
    ].
!

reportProgress:fraction
    "can be used by a GUI application to indicate loading progress (0..1)"

    progressHolder notNil ifTrue:[
	progressHolder value:fraction
    ].
! !

!ImageReader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

