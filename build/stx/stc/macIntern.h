/*
 * $Header$
 */
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

#ifndef __MACINTERN_H__
# define __MACINTERN_H__

# ifdef __STATIC_LINK__
#  define __VMDATA_REF__
#  define __NO_SYMBASE__
#  define __NO_FIXBASE__
# else
#  define __INDIRECTGLOBALS__
#  define __VM_SEND_TABLE__
#  define __INDIRECTVMINITCALLS__
#  define __INDIRECTVMCALLS__
#  define NO_SECTION_ATTRIBUTES
# endif

# ifndef __GNUC__
#  define FORWARD_STATIC        /* nothing */
#  undef CONST
#  define CONST                 /* nothing */
# endif

# define NO_SECTION_ATTRIBUTES
# define DBL_CONV       "%lf"

# if defined(__x86__) || defined(__x86_64__)
#  define __LSBFIRST__
# else
#  define __DEFAULT_CPU__        __CPU__g3__
#  define __MSBFIRST__
# endif

# define xHAVE_FFI
# define xUSE_STANDARD_FFI

# define __FLOAT0_IS_INT0
# define __DOUBLE0_IS_INT0

# define xxxPASS_ARG_POINTER    // no!

# define SIGNED_SHIFTS
# define HAS_SIGNED_CHAR
# define ARG_ORDER_NORMAL
# define EASY_VAR_ARGS
# define SUPPORT_OBJECTIVE_C

# define __ALIGN__             sizeof(double)
# define __NON_INT_ALIGN

# if !defined(__x86__) && !defined(__x86_64__)

   // eg: power-cpu
#  define __NEED_DOUBLE_ALIGN
#  define __NEED_LONGLONG_ALIGN
#  define __DOUBLE_ALIGN        sizeof(double)
#  define __LONGLONG_ALIGN      sizeof(double)

# else

#  define __NEED_FLOATARRAY_ALIGN
#  define __NEED_DOUBLE_ALIGN
#  define __NEED_LONGLONG_ALIGN
#  define __FLOATARRAY_ALIGN    sizeof(double)
#  define __DOUBLE_ALIGN        sizeof(double)
#  define __LONGLONG_ALIGN      sizeof(double)

# endif

# if defined(__x86_64__)

#  define OLDSPACE_ADDRESS       (char *)0x20000000000
#  define COLLECTEDOLD_ADDRESS   (char *)0x40000000000
#  define MAX_MMAP                       0x20000000000  /* 128*16 Gbyte */

#  ifndef __NO_CODEBASE__
#   define __CODEBASE__                    0x180000000  /* must be in 32bit range to code, which is at 0x100000000 */
#   define __CODEOBJECTBASE__              0x170000000
#  endif

#  ifndef __NO_SYMBASE__
#   define __SYMBASE__                     0x160000000
#  endif
#  ifndef __NO_FIXBASE__
#   define __FIXBASE__                     0x15FFE0000  /* 128 kByte */
#  endif

# else

#  define OLDSPACE_ADDRESS       (char *)0x50000000
#  define COLLECTEDOLD_ADDRESS   (char *)0x80000000
#  define MAX_MMAP               0x30000000              /* 768 Mbyte */

#  ifndef __NO_SYMBASE__
#   define __SYMBASE__            0x20000000
#  endif
#  ifndef __NO_FIXBASE__
#   define __FIXBASE__            0x1FFE0000             /* 128 kByte */
#  endif
#  ifndef __NO_CODEBASE__
#   define __CODEBASE__           0x28000000
#  endif

# endif

# define NEED_TIME_H
# define NEED_SYS_TIME_H
# define NEED_SYS_MMAN_H
# define NEED_FCNTL_H
# define NEED_MACHL_H

# define HAS_OPENDIR
# define HAS_RENAME
# define HAS_SETENV
# define HAS_UNSETENV
# define HAS_PUTENV
# define HAS_REALPATH
# define HAS_FTRUNCATE
# define HAS_TRUNCATE
# define HAS_UNAME
# define HAS_UTSNAME_H
# define HAS_SYSCTL
# define HAS_MMAP
# define HAS_MAP_ANONYMOUS
# define HAS_DEV_ZERO
# define HAS_VM_ALLOCATE
# define HAS_VFORK
# define HAS_MPROTECT
# define HAS_VMPROTECT
# define HAS_MINCORE
# define HAS_SIGSTACK
# define HAS_SIGSETMASK
# define HAS_LOCALECONV
# define HAS_STRCOLL
# define HAS_DLOPEN
# define HAS__SETJMP
# define HAS__LONGJMP
# define HAS_UNIX98_PTY
# define HAS_USLEEP

# undef HAS_FDATASYNC

# define LONGFILENAMES
# define HAS_STRCOLL
# define HAS_GETCWD
# define HAS_GETWD
# define HAS_GETTIMEOFDAY
# define HAS_GETHOSTID
# define HAS_GETDOMAINNAME
# define HAS_GETHOSTNAME
# define HAS_SYSCONF
# define HAS_LOCALECONV

# define OS_DEFINE "-D__osx__"

# define FAST_MEMCPY
# define FAST_MEMSET
# define FAST_MEMCHR

# define HAS_WAITPID
# define HAS_WAIT3
# define HAS_DAYLIGHT
# define HAS_GETPAGESIZE
# define HAS_SIGPROCMASK
# define HAS_SIGVEC
# define HAS_SIGACTION

# if defined(__GNUC__) || defined(__clang__)
#  define __COMPILER_OPTIMIZES_ROTATE__
# endif

#if 0 // needs testing */
# if defined (__GNUC__) && defined(__x86__)  && !defined(__x86_64__)
#  define inline_setjmpNoFP(jmpbuf)             \
	({                                      \
	    int __rslt;                         \
	    asm volatile("                  \n  \
		 movl  %%ebx, 12(%1)        \n  \
		 movl  %%edi, 24(%1)        \n  \
		 movl  %%esi, 28(%1)        \n  \
		 movl  %%ebp, 32(%1)        \n  \
		 movl  %%esp, 36(%1)        \n  \
		 leal  0f, %%ecx            \n  \
		 movl  %%ecx, 48(%1)        \n  \
		 xorl  %%eax, %%eax         \n  \
	    0:                              \n  \
		"  : "=a" (__rslt)              \
		   : "0" ((char *)(jmpbuf))     \
		   : "ecx","edx" );             \
	    __rslt;                             \
	})
# endif
#endif

#if 0 // needs testing */
# if (defined (__GNUC__) || defined (__clang__)) && defined(__x86_64__)
#  define inline_setjmpNoFP(jmpbuf)             \
	({                                      \
	    int __rslt;                         \
	    asm volatile("\n  \
		 mov  %%rbx, 0(%1)         \n  \
		 mov  %%rbp, 8(%1)         \n  \
		 mov  %%r12, 0x18(%1)      \n  \
		 mov  %%r13, 0x20(%1)      \n  \
		 mov  %%r14, 0x28(%1)      \n  \
		 mov  %%r15, 0x30(%1)      \n  \
		 mov  %%rsp, 0x10(%1)      \n  \
		 leaq  0f(%%rip), %%rax            \n  \
		 movq  %%rax, 0x38(%1)      \n  \
		 xor  %%rax, %%rax         \n  \
	    0:                              \n  \
		"  : "+&a" (__rslt)              \
		   : "r" ((char *)(jmpbuf))     \
		     );                         \
	    __rslt;                             \
	})
# endif
#endif

# ifndef stx_setjmp
#  ifdef inline_setjmpNoFP
#   define stx_setjmp inline_setjmpNoFP
#  else
#   define stx_setjmp _setjmp
#  endif
# endif

# ifndef stx_longjmp
#  define stx_longjmp _longjmp
# endif

#endif /* __MACINTERN_H__ */
