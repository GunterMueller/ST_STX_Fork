/* static const char rcsid[] = "$Header: /cvs/stx/stx/librun/symlist.c,v 1.6 2008/09/15 13:56:20 stefan Exp $"; */

/*
 * COPYRIGHT (c) 1988 by Claus Gittinger
 *              All Rights Reserved
 *
 * This software is furnished under a license and may be used
 * only in accordance with the terms of that license and with the
 * inclusion of the above copyright notice.   This software may not
 * be provided or otherwise made available to, or used by, any
 * other person.  No title to or ownership of the software is
 * hereby transferred.
 *
 */

/*
 * This file defines all symbols contained in the base image.
 * If EXTERNAL_SYMBOLS is defined, symbols are loaded from symbols.stc
 * at smalltalk startup time
 */

#define __IN_VM__
#include "stc.h"

/*
 * XXX This should go into stcIntern!
 */
#if !defined(CONST)
# if defined(__GNUC__)
#  define CONST const
# else
#  define CONST /*as nothing*/
# endif
#endif

#if defined(__openVMS__) || defined(__win32__)
# define EXTERNAL_SYMBOLS
#endif


#ifdef EXTERNAL_SYMBOLS
char **__symbols = 0;
int __symbolsSeqNr = 0;
# else
CONST char * CONST
__symbols[]
=
# include "symbols.h"
#endif /* ! EXTERNAL_SYMBOLS */
