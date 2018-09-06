/*
 * $Header$
 */

/*
 * COPYRIGHT (c) 1995 by Claus Gittinger
 * COPYRIGHT (c) 2016-2017 Jan Vrany
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

#ifndef __CPU_I386_H__
# define __CPU_I386_H__

# if defined(__amd64__) || defined(__x86_64__)
#  define CPU_DEFINE "-D__amd64__ -D__x86_64__"
# else
#  define CPU_DEFINE "-D__i386__"
# endif

# define __CPU__386__           386
# define __CPU__486__           486
# define __CPU__586__           586
# define __CPU__686__           686
# define __CPU__AMD64__         1064
# define __CPU__IA64__          2064

# if !defined(__DEFAULT_CPU__)
#  if defined(__amd64__) || defined(__x86_64__)
#   define __DEFAULT_CPU__        __CPU__AMD64__
#  else
#   define __DEFAULT_CPU__        __CPU__586__
#  endif
# endif

# ifndef __POINTER_SIZE__
#  if defined(__amd64__) || defined(__x86_64__)
#   define __POINTER_SIZE__  8
#  else
#   define __POINTER_SIZE__  4
#  endif
# endif

#define __NEED_DOUBLE_ALIGN
#define __DOUBLE_ALIGN        sizeof(double)

#define __NEED_LONGLONG_ALIGN
#define __LONGLONG_ALIGN      sizeof(double)

#define __NEED_FLOATARRAY_ALIGN
#define __FLOATARRAY_ALIGN    sizeof(double)


# define SIGNED_SHIFTS
# if !defined(__LSBFIRST__)
#  define __LSBFIRST__
# endif

# if !defined(HAS_SIGNED_CHAR)
#  define HAS_SIGNED_CHAR
# endif

# define TRADITIONAL_STACK_FRAME
# define ARG_ORDER_NORMAL

# if !defined( __IN_STC__) && !defined(__ASSEMBLER__)
/*
 * bcc and msvc have different jmp_buf structs;
 * use our own, to be compatible with both.
 */
typedef volatile struct __qjmp_buf {
    unsigned    j_ebp;
    unsigned    j_ebx;
    unsigned    j_edi;
    unsigned    j_esi;
    unsigned    j_esp;
    unsigned    j_ret;
    unsigned    j_excep;
    unsigned    j_context;
} qjmp_buf[1];

#  define stx_jmp_buf qjmp_buf
# endif // !defined( __IN_STC__) && !defined(__ASSEMBLER__)


# if (__POINTER_SIZE__ == 4)
#  ifndef stx_longrestart
#   define stx_longrestart(j)         stx_longjmp(j, 0)
#   define HAVE_LONGRESTART
#  endif
# endif


# if defined(__GNUC__) && (__POINTER_SIZE__ == 4)

#  define __getStack__()                                          \
	({                                                         \
	    INT __rslt;                                            \
	    asm("movl %%esp,%0" : "=r" (__rslt) : /* no input */); \
	    __rslt;                                                \
	})

#  if __POINTER_SIZE__ == 8
#   define __switchStack__(sp)                                            \
	asm volatile ("movq %0, %%rsp" : /* no output */ : "r" (sp) );
#  else
#   define __switchStack__(sp)                                            \
	asm volatile ("movl %0, %%esp" : /* no output */ : "r" (sp) );
#  endif

#  if !defined(__IN_STC__)
#   ifndef stx_setjmp

#   if defined(ELF)

#    if defined(__IN_VM__) && defined(__STATIC_LIBRUN__)
#     if !defined(__SHAREDLIBCODE__)
#      define __SHAREDLIBCODE__
#     endif
#    endif

/*
 * disabled for sharedLibs, because the leal below does add an extra PC_RELATIVE
 * text relocation entry (i386 does not support pc-relative addressing)
 * that causes a copy on write of the text page when ld.so relocates the sharedLib
 * at startup time (thus leads to long startup delays).
 * In order to make it PIC, we need a call anyway, so the inline setjmp
 * would not be much faster than the regular qsetjmp function.
 */
#    ifndef __SHAREDLIBCODE__

    /*
     * SYSV4 does not support local labels, so use __LINE__
     */
#     define stx_setjmp(jmpbuf)                      \
	({                                      \
	    int __rslt;                         \
	    asm volatile("                  \n  \
		 movl  %%ebx, 0(%1)         \n  \
		 movl  %%esi, 4(%1)         \n  \
		 movl  %%edi, 8(%1)         \n  \
		 movl  %%ebp, 12(%1)        \n  \
		 movl  %%esp, 16(%1)        \n  \
		 leal  LM%2, %%ecx            \n  \
		 movl  %%ecx, 20(%1)        \n  \
		 xorl  %%eax, %%eax         \n  \
	    LM%2:                           \n  \
		"  : "=a" (__rslt)              \
		   : "0" ((char *)(jmpbuf)), "p" (__LINE__) \
		   : "ecx","edx" );             \
	    __rslt;                             \
	})

#    endif /* not SHAREDLIBCODE */
#   else /* !defined(ELF) */

#    define setjmp_VERSION4 /* works */


#    ifdef setjmp_VERSION5
     /*
      * eliminates the setjmp-return-value check
      * (requires that longreturn is available)
      */
#     define stx_setjmp(jmpbuf)                      \
	({                                      \
	    int __rslt;                         \
	    asm volatile("                  \n  \
		 movl  %%ebx, 0(%1)         \n  \
		 movl  %%esi, 4(%1)         \n  \
		 movl  %%edi, 8(%1)         \n  \
		 movl  %%ebp, 12(%1)        \n  \
		 movl  %%esp, 16(%1)        \n  \
		 leal  0f, %%ecx            \n  \
		 movl  %%ecx, 20(%1)        \n  \
		 jmp   9f                   \n  \
	    0:                              \n  \
		"  : "=a" (__rslt)              \
		   : "0" ((char *)(jmpbuf))     \
		   : "ecx","edx" );             \
	    __rslt;                             \
	})

#     define __CONT__                            \
	 asm volatile("9:");

#    endif /* setjmp_VERSION5 */


#    ifdef setjmp_VERSION4
#     define stx_setjmp(jmpbuf)                      \
	({                                      \
	    int __rslt;                         \
	    asm volatile("                  \n  \
		 movl  %%ebx, 0(%1)         \n  \
		 movl  %%esi, 4(%1)         \n  \
		 movl  %%edi, 8(%1)         \n  \
		 movl  %%ebp, 12(%1)        \n  \
		 movl  %%esp, 16(%1)        \n  \
		 leal  0f, %%ecx            \n  \
		 movl  %%ecx, 20(%1)        \n  \
		 xorl  %%eax, %%eax         \n  \
	    0:                              \n  \
		"  : "=a" (__rslt)              \
		   : "0" ((char *)(jmpbuf))     \
		   : "ecx","edx" );             \
	    __rslt;                             \
	})

#    endif /* setjmp_VERSION4 */


#    ifdef __OPTSPACE2__
     /*
      * nope - redefine it to call setjmp
      * this requires some more cycles, though
      */
#     undef __CONT__
#    endif

#   endif /* not ELF */
#  endif /* not STC */
#  endif /* stx_setjmp not already defined */
# endif /* 32bit & GNUC */

# ifndef stx_setjmp
#  if !defined(__IN_VM__) && !defined(__IN_STC__) && !defined(__ASSEMBLER__)
#   if defined(__VISUALC__)
    extern void qsetjmp();
#   else
    extern int qsetjmp(stx_jmp_buf);
#   endif
#  endif
#  define stx_setjmp(j)      qsetjmp(j)
# endif

# ifndef stx_longjmp
#  if !defined(__IN_VM__) && !defined(__IN_STC__) && !defined(__ASSEMBLER__)
#   if defined(__VISUALC__)
    extern void qlongjmp();
#   else
    extern void qlongjmp(stx_jmp_buf, int);
#   endif
#  endif
#  define stx_longjmp(j,v)   qlongjmp(j,v)
# endif

# if !defined(stx_longrestart) && !defined(__ASSEMBLER__)
#  define stx_longrestart(j) qlongjmp(j,0)
#  define HAVE_LONGRESTART
# endif

#if defined(__GNUC__) || defined (__clang__)
# define SET_MFRAME_HANDLE(con)                                                \
        (con)->c_pSelf =                                                       \
          (OBJ *)(__builtin_frame_address(0)                                   \
                    + sizeof(void*)   /* return address */                     \
                    + sizeof(void*)   /* saved sp */);
#  define SET_BFRAME_HANDLE(con)        SET_MFRAME_HANDLE(con)
#endif


#endif /* __CPU_I386_H__ */
