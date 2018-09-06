/*
 * COPYRIGHT (c) 1999 by Claus Gittinger
 *              All Rights Reserved
 *
 * This software is furnished under a license and may be used
 * only in accordance with the terms of that license and with the
 * inclusion of the above copyright notice.   This software may not
 * be provided or otherwise made available to, or used by, any
 * other person.  No title to or ownership of the software is
 * hereby transferred.
 *
 * $Header: /cvs/stx/stx/stc/stxAsmMacros.h,v 1.7 2005/07/08 15:02:18 cg Exp $
 *
 * These used to be located in stc.h; now, they are included.
 * (To avoid excessive recompilations due to makefile dependencies)
 */

#ifndef __STX_ASM_MACROS_H
# define __STX_ASM_MACROS_H

# if defined(__x86__) && defined(__GNUC__) && !defined(__IN_STC__) && !defined(__CROSS_COMPILE__) && (__POINTER_SIZE__ == 4)

#  define __HAS_BSWAP()             \
    (__cpuType__ >= 586)

#  define __BSWAP(__val)            \
    ({                              \
	int __rslt;                 \
	asm("bswap %0   \n          \
	    "  : "=r" (__rslt)      \
	       : "0" ((int)(__val)) \
	   );                       \
	__rslt;                     \
     })

#  define __BSR(__val)              \
    ({                              \
	int __rslt;                 \
	asm("bsr %0,%0   \n         \
	    "  : "=r" (__rslt)      \
	       : "0" ((int)(__val)) \
	   );                       \
	__rslt;                     \
     })

#  define __BSF(__val)              \
    ({                              \
	int __rslt;                 \
	asm("bsf %0,%0   \n         \
	    "  : "=r" (__rslt)      \
	       : "0" ((int)(__val)) \
	   );                       \
	__rslt;                     \
     })

/*
 * x86 has block-move/fill instructions
 * the xxx4 macros only work with 4-byte aligned addresses, and use longword-counts
 */

#  if (__GNUC__ == 2 && __GNUC_MINOR__ > 91) || __GNUC__ > 2
#  else
#   define bcopy(src,dst,sz)            \
	asm("rep; movsb"                \
	    : /* no output */           \
	    : "S" ((char *)(src)),      \
	      "D" ((char *)(dst)),      \
	      "c" (sz)                  \
	    : "cx", "si", "di")

#   define bcopy4(src,dst,sz)           \
	asm("rep; movsl"                \
	    : /* no output */           \
	    : "S" ((long *)(src)),      \
	      "D" ((long *)(dst)),      \
	      "c" (sz)                  \
	    : "cx", "si", "di")

#   define memset(dst,val,sz)           \
	asm("rep; stosb"                \
	    : /* no output */           \
	    : "a" (val),                \
	      "D" ((char *)(dst)),      \
	      "c" (sz)                  \
	    : "cx", "di")

#   define memset4(dst,val,sz)          \
	asm("rep; stosl"                \
	    : /* no output */           \
	    : "a" (val),                \
	      "D" ((long *)(dst)),      \
	      "c" (sz)                  \
	    : "cx", "di")


#   ifdef SYSV4
   /*
    * SYSV4 does not support local labels, use line numbers
    */
#    define memsrch4(ptr, what, count)   \
	({                              \
	    register void *__res;       \
	    __asm__ __volatile__(       \
		"cld\n\t"               \
		"repne\n\t"             \
		"scasl\n\t"             \
		"je LM%4\n\t"           \
		"movl $4,%0\n"          \
		"LM%4:\tsubl $4,%0"     \
		:"=D" (__res):"a" (what),"D" (ptr),"c" (count), "p" (__LINE__) \
		:"cx");                 \
	    __res;                      \
	})
#   else /* !SYSV4 */
#    define memsrch4(ptr, what, count)     \
	({                              \
	    register void *__res;       \
	    __asm__ __volatile__(       \
		"cld\n\t"               \
		"repne\n\t"             \
		"scasl\n\t"             \
		"je 1f\n\t"             \
		"movl $4,%0\n"          \
		"1:\tsubl $4,%0"        \
		:"=D" (__res):"a" (what),"D" (ptr),"c" (count) \
		:"cx");                 \
	    __res;                      \
	})
#   endif /* not SYSV4 */

#  endif /* __GNUC__ version <= 2.91 */
# endif /* x86 && GNUC && 32bit */

#endif /* __STX_ASM_MACROS_H */
