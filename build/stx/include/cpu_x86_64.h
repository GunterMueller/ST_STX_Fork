/*
 * $Header$
 */

/*
 * COPYRIGHT (c) 2012 by Claus Gittinger
 * COPYRIGHT (c) 2016 Jan Vrany
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

#ifndef __CPU_X86_64_H__
# define __CPU_X86_64_H__

# define CPU_DEFINE "-D__x86_64__"

# define __CPU__X86_64__         4064
# define __DEFAULT_CPU__        __CPU__X86_64__
# define __POINTER_SIZE__  8

# ifdef WIN32
#  if !defined(__ASSEMBLER__)
#   include <basetsd.h>	// defines for 64-bit Windows
#  endif
# else
#  define INT64         long
#  define UINT64        unsigned long
# endif

# define SIGNED_SHIFTS
# if !defined(__LSBFIRST__)
#  define __LSBFIRST__
# endif

# if !defined(HAS_SIGNED_CHAR)
#  define HAS_SIGNED_CHAR
# endif

# define xTRADITIONAL_STACK_FRAME
# define ARG_ORDER_NORMAL

# if defined(__GNUC__) || defined(__CLANG__) || defined(__MINGW64__)
#  define HAS_INT128
#  define INT128        __int128_t
#  define UINT128       __uint128_t
# endif

# if defined(__GNUC__) || defined(__CLANG__) || defined(__MINGW64__)
#  define __getStack__()                                           \
	({                                                         \
	    INT __rslt;                                            \
	    asm("movq %%rsp,%0" : "=r" (__rslt) : /* no input */); \
	    __rslt;                                                \
	})

#  define __switchStack__(sp)                                      \
	asm volatile ("movq %0, %%rsp" : /* no output */ : "r" (sp) );
# endif

#endif /* __CPU_X86_64_H__ */
