/*
 * $Header$
 */

/*
 * COPYRIGHT (c) 1995 by Claus Gittinger
 * COPYRIGHT (c) 2015-2016 Jan Vrany
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

#ifndef __NTINTERN_H__
# define __NTINTERN_H__

// Additional internal return code for __vmWait()
#define __WAIT_INTERRUPTED    0x103         // WAIT_TIMEOUT + 1

# if defined( VISUALC ) && !defined( __VISUALC__ )
#  define __VISUALC__
# endif

# define WIN32THREADS
# define NATIVE_THREADS
# define DO_WRAP_CALLS
# define NO_LOCKING
# define NO_ASM
# define MSDOS_LIKE
# undef  UNIX_LIKE

# ifndef __x86_64__
#  define PASS_ARG_POINTER
# endif

# if !defined(__ASSEMBLER__)
#  if defined(__MINGW32__) || defined(__MINGW64__)
#   include <string.h> /* to get memcpy(), memset() and strchr() prototypes */
#  endif
#  include <stdio.h> /* to get FILE definition ised in __win32_fprintf() */
# endif

# define bcopy(src, dst, size)  memcpy(dst, src, size)
# define bzero(dst, count)      memset(dst, 0, count)
# define index(str, ch)         strchr(str, ch)

# ifdef __VISUALC__
#  if defined(_MSC_VER) && _MSC_VER<1900
#   define snprintf              sprintf_s
#  endif

#  define isatty(x)              0
#  define access(nm, how)        _access(nm, how)
#  define mktemp(templ)          _mktemp(templ)
#  define lseek(fd,offs,org)     _lseek(fd, offs, org)
#  define read(fd,buf,size)      _read(fd, buf, size)
#  ifndef write
#   define write(fd,buf,size)    _write(fd, buf, size)
#  endif
#  define rmdir(nm)              _rmdir(nm)
#  define chmod(nm, mode)        _chmod(nm, mode)
#  define unlink(nm)             _unlink(nm)
# endif /* __VISUALC__ */

# if 0
#  ifndef __IN_STC__
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

#   define stx_jmp_buf qjmp_buf

#   ifndef stx_setjmp
#    define stx_setjmp(j)             qsetjmp(j)
#   endif
#   ifndef stx_longjmp
#    define stx_longjmp(j,v)          qlongjmp(j,v)
#   endif
#   ifndef stx_longrestart
#    define stx_longrestart(j)        stx_longjmp(j,0)
#   endif
#   define HAVE_LONGRESTART

#  endif /* not __IN_STC__ */
# endif /* never */

/*
 * Both Borland and Microsoft align doubles and long longs
 * to a 8-byte boundary in 32 and 64bit mode
 */
#define __NEED_DOUBLE_ALIGN
#define __DOUBLE_ALIGN        sizeof(double)
#define __NEED_LONGLONG_ALIGN
#define __LONGLONG_ALIGN      sizeof(double)
#define __NON_INT_ALIGN

/*
 * borland maps its dll's right into the middle of
 * where we would like to mmap our symbols.
 * There is a fixed CW32 variant, which changes this
 * however, that dll only works with cBuilder3.
 *
 * WARNING: if you change this, every piece of the VM
 * and all classLibs, which were compiled with +commonSymbols
 * have to be recompiled (i.e you can only do this if you have the
 * full source at hand).
 */

# if defined(__x86_64__)
#  define __ALIGN__             sizeof(double)
// 256 Gbyte is too much; Windows will give me only 256!
// #  define MAX_MMAP              (INT)0x4000000000  /* 256 Gbyte */
#  define MAX_MMAP              (INT)0x1000000000  /* 64 Gbyte */
#  define xOLDSPACE_ADDRESS     (char *)0x20000000000
#  define xCOLLECTEDOLD_ADDRESS (char *)(OLDSPACE_ADDRESS + MAX_MMAP)
#  define MAX_SYMBASE           0x00800000              /* max sym-space 8Mb */

#  define __FIXBASE__           0x1FFE0000              /* 128 kByte */
#  define __SYMBASE__           0x20000000

#  define __CODEBASE__          0x28000000
//#  define __CODEOBJECTBASE__  0x17000000

# else  /* ! __win64__ */

// do not cast to char * here; visualc cannot compile then!
#  define __FIXBASE__            0x1FFE0000              /* 128 kByte */
#  define __SYMBASE__            0x20000000

#  define __CODEBASE__           0x28000000
//#  define __CODEOBJECTBASE__  0x17000000


#  define MAX_SYMBASE            0x00800000              /* max sym-space 8Mb */
#  define MAX_MMAP               0x24000000              /* 576 Mbyte */
#  define xOLDSPACE_ADDRESS       (char *)(__SYMBASE__ + MAX_SYMBASE)      /* 20800000..44800000 */
#  define xCOLLECTEDOLD_ADDRESS   (char *)(OLDSPACE_ADDRESS + MAX_MMAP)    /* 44800000..68800000 */

#  define __SUPPORT_DIRECT_ILC
# endif   /* __win32__ */

# define __VM_SEND_TABLE__

# define HAS_VM_ALLOCATE

/* # define NEED_SYS_MMAN_H     /* */
/* # define NEED_FCNTL_H        /* */

# define LONGFILENAMES

/* # define HAS_GETCWD          /* */
/* # define HAS_GETWD           /* */
/* # define HAS_GETTIMEOFDAY    /* */
/* # define HAS_GETHOSTID       /* */
/* # define HAS_GETHOSTNAME     /* */
/* # define HAS_GETDOMAINNAME   /* */
/* # define HAS_UNAME           /* */
/* # define HAS_UTSNAME_H       /* */
/* # define HAS_UTS_DOMAINNAME  /* */

/* # define HAS_OPENDIR         /* */
# define HAS_RENAME
/* # define HAS_REALPATH        /* */

/* # define HAS_MMAP            /* */
/* # define HAS_SIGSETMASK      /* */
/* # define HAS_SIGACTION       /* */
/* # define HAS_MPROTECT        /* */
# define HAS_STRCOLL         /* */
/* # define HAS_DEV_ZERO        /* */
/* # define HAS_GETPAGESIZE     /* */
/* # define HAS_SYSCONF         /* */

# undef HAS_FDATASYNC

# define HAS_DL
# define WIN_DL
# define HAVE_FFI

# ifdef __MINGW64__ // temporary
#  define MINGW_MODFL_BUG
# endif

# define OS_DEFINE "-DWIN32"

# ifdef __x86__
#  define FAST_STRING_MEMSET
#  define FAST_OBJECT_MEMSET4
#  define FAST_ARRAY_MEMSET4

#  if defined(__GNUC__) || defined(__CLANG__)
#   define FAST_MEMCPY4
#  endif

# endif

# if !defined(__BORLANDC__) && !defined(__VISUALC__)
#  define FAST_MEMCHR
# endif

# define __WRAP_CAPI           0
# define __WRAP_WINAPI         1
# define __WRAP_SOCKAPI        2
# define __WRAP_API_MASK       7        /* to mask out the above */
# define __WRAP_NO_INTERRUPT   8        /* ored in */

# ifndef __ASSEMBLER__

typedef void *(*wrapFunction_t)(void);

extern void * __doWrapCall0(int, char *, wrapFunction_t);
extern void * __doWrapCall1(int, char *, wrapFunction_t, void *a1);
extern void * __doWrapCall2(int, char *, wrapFunction_t, void *a1, void *a2);
extern void * __doWrapCall3(int, char *, wrapFunction_t, void *a1, void *a2, void *a3);
extern void * __doWrapCall4(int, char *, wrapFunction_t, void *a1, void *a2, void *a3, void *a4);
extern void * __doWrapCall5(int, char *, wrapFunction_t, void *a1, void *a2, void *a3, void *a4, void *a5);
extern void * __doWrapCall6(int, char *, wrapFunction_t, void *a1, void *a2, void *a3, void *a4, void *a5, void *a6);
extern void * __doWrapCall7(int, char *, wrapFunction_t, void *a1, void *a2, void *a3, void *a4, void *a5, void *a6, void *a7);
extern void * __doWrapCall8(int, char *, wrapFunction_t, void *a1, void *a2, void *a3, void *a4, void *a5, void *a6, void *a7, void *a8);
extern void * __doWrapCall9(int, char *, wrapFunction_t, void *a1, void *a2, void *a3, void *a4, void *a5, void *a6, void *a7, void *a8, void *a9);
extern void * __doWrapCall10(int, char *, wrapFunction_t, void *a1, void *a2, void *a3, void *a4, void *a5, void *a6, void *a7, void *a8, void *a9, void *a10);
extern void * __doWrapCall11(int, char *, wrapFunction_t, void *a1, void *a2, void *a3, void *a4, void *a5, void *a6, void *a7, void *a8, void *a9, void *a10, void *a11);
extern void * __doWrapCall12(int, char *, wrapFunction_t, void *a1, void *a2, void *a3, void *a4, void *a5, void *a6, void *a7, void *a8, void *a9, void *a10, void *a11, void *a12);
extern void * __doWrapCall13(int, char *, wrapFunction_t, void *a1, void *a2, void *a3, void *a4, void *a5, void *a6, void *a7, void *a8, void *a9, void *a10, void *a11, void *a12, void *a13);
extern void * __doWrapCall14(int, char *, wrapFunction_t, void *a1, void *a2, void *a3, void *a4, void *a5, void *a6, void *a7, void *a8, void *a9, void *a10, void *a11, void *a12, void *a13, void *a14);
extern void * __doWrapCall15(int, char *, wrapFunction_t, void *a1, void *a2, void *a3, void *a4, void *a5, void *a6, void *a7, void *a8, void *a9, void *a10, void *a11, void *a12, void *a13, void *a14, void *a15);

# define __STX_API_CALL0(nm, func)                                                      __doWrapCall0(__WRAP_WINAPI, nm, (wrapFunction_t)func)
# define __STX_API_CALL1(nm, func,a1)                                                   __doWrapCall1(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1))
# define __STX_API_CALL2(nm, func,a1,a2)                                                __doWrapCall2(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2))
# define __STX_API_CALL3(nm, func,a1,a2,a3)                                             __doWrapCall3(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3))
# define __STX_API_CALL4(nm, func,a1,a2,a3,a4)                                          __doWrapCall4(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4))
# define __STX_API_CALL5(nm, func,a1,a2,a3,a4,a5)                                       __doWrapCall5(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5))
# define __STX_API_CALL6(nm, func,a1,a2,a3,a4,a5,a6)                                    __doWrapCall6(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6))
# define __STX_API_CALL7(nm, func,a1,a2,a3,a4,a5,a6,a7)                                 __doWrapCall7(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7))
# define __STX_API_CALL8(nm, func,a1,a2,a3,a4,a5,a6,a7,a8)                              __doWrapCall8(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8))
# define __STX_API_CALL9(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9)                           __doWrapCall9(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9))
# define __STX_API_CALL10(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)                      __doWrapCall10(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10))
# define __STX_API_CALL11(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11)                  __doWrapCall11(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11))
# define __STX_API_CALL12(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12)              __doWrapCall12(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11),(void *)(a12))
# define __STX_API_CALL13(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13)          __doWrapCall13(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11),(void *)(a12),(void *)(a13))
# define __STX_API_CALL14(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14)      __doWrapCall14(__WRAP_WINAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11),(void *)(a12),(void *)(a13),(void *)(a14))

# define __STX_API_NOINT_CALL0(nm, func)                                                    __doWrapCall0(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func)
# define __STX_API_NOINT_CALL1(nm, func,a1)                                                 __doWrapCall1(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1))
# define __STX_API_NOINT_CALL2(nm, func,a1,a2)                                              __doWrapCall2(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2))
# define __STX_API_NOINT_CALL3(nm, func,a1,a2,a3)                                           __doWrapCall3(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3))
# define __STX_API_NOINT_CALL4(nm, func,a1,a2,a3,a4)                                        __doWrapCall4(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4))
# define __STX_API_NOINT_CALL5(nm, func,a1,a2,a3,a4,a5)                                     __doWrapCall5(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5))
# define __STX_API_NOINT_CALL6(nm, func,a1,a2,a3,a4,a5,a6)                                  __doWrapCall6(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6))
# define __STX_API_NOINT_CALL7(nm, func,a1,a2,a3,a4,a5,a6,a7)                               __doWrapCall7(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7))
# define __STX_API_NOINT_CALL8(nm, func,a1,a2,a3,a4,a5,a6,a7,a8)                            __doWrapCall8(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8))
# define __STX_API_NOINT_CALL9(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9)                         __doWrapCall9(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9))
# define __STX_API_NOINT_CALL10(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)                    __doWrapCall10(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10))
# define __STX_API_NOINT_CALL11(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11)                __doWrapCall11(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11))
# define __STX_API_NOINT_CALL12(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12)            __doWrapCall12(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11),(void *)(a12))
# define __STX_API_NOINT_CALL13(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13)        __doWrapCall13(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11),(void *)(a12),(void *)(a13))
# define __STX_API_NOINT_CALL14(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14)    __doWrapCall14(__WRAP_WINAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11),(void *)(a12),(void *)(a13),(void *)(a14))

# define __STX_WSA_CALL0(nm, func)                              __doWrapCall0(__WRAP_SOCKAPI, nm, (wrapFunction_t)func)
# define __STX_WSA_CALL1(nm, func,a1)                           __doWrapCall1(__WRAP_SOCKAPI, nm, (wrapFunction_t)func,(void *)(a1))
# define __STX_WSA_CALL2(nm, func,a1,a2)                        __doWrapCall2(__WRAP_SOCKAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2))
# define __STX_WSA_CALL3(nm, func,a1,a2,a3)                     __doWrapCall3(__WRAP_SOCKAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3))
# define __STX_WSA_CALL4(nm, func,a1,a2,a3,a4)                  __doWrapCall4(__WRAP_SOCKAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4))
# define __STX_WSA_CALL5(nm, func,a1,a2,a3,a4,a5)               __doWrapCall5(__WRAP_SOCKAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5))
# define __STX_WSA_CALL6(nm, func,a1,a2,a3,a4,a5,a6)            __doWrapCall6(__WRAP_SOCKAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6))
# define __STX_WSA_CALL7(nm, func,a1,a2,a3,a4,a5,a6,a7)         __doWrapCall7(__WRAP_SOCKAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7))

# define __STX_WSA_NOINT_CALL0(nm, func)                        __doWrapCall0(__WRAP_SOCKAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func)
# define __STX_WSA_NOINT_CALL1(nm, func,a1)                     __doWrapCall1(__WRAP_SOCKAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1))
# define __STX_WSA_NOINT_CALL2(nm, func,a1,a2)                  __doWrapCall2(__WRAP_SOCKAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2))
# define __STX_WSA_NOINT_CALL3(nm, func,a1,a2,a3)               __doWrapCall3(__WRAP_SOCKAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3))
# define __STX_WSA_NOINT_CALL4(nm, func,a1,a2,a3,a4)            __doWrapCall4(__WRAP_SOCKAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4))
# define __STX_WSA_NOINT_CALL5(nm, func,a1,a2,a3,a4,a5)         __doWrapCall5(__WRAP_SOCKAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5))
# define __STX_WSA_NOINT_CALL6(nm, func,a1,a2,a3,a4,a5,a6)      __doWrapCall6(__WRAP_SOCKAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6))
# define __STX_WSA_NOINT_CALL7(nm, func,a1,a2,a3,a4,a5,a6,a7)   __doWrapCall7(__WRAP_SOCKAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7))

# define __STX_C_CALL0(nm, func)                                                        __doWrapCall0(__WRAP_CAPI, nm, (wrapFunction_t)func)
# define __STX_C_CALL1(nm, func,a1)                                                     __doWrapCall1(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1))
# define __STX_C_CALL2(nm, func,a1,a2)                                                  __doWrapCall2(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2))
# define __STX_C_CALL3(nm, func,a1,a2,a3)                                               __doWrapCall3(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3))
# define __STX_C_CALL4(nm, func,a1,a2,a3,a4)                                            __doWrapCall4(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4))
# define __STX_C_CALL5(nm, func,a1,a2,a3,a4,a5)                                         __doWrapCall5(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5))
# define __STX_C_CALL6(nm, func,a1,a2,a3,a4,a5,a6)                                      __doWrapCall6(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6))
# define __STX_C_CALL7(nm, func,a1,a2,a3,a4,a5,a6,a7)                                   __doWrapCall7(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7))
# define __STX_C_CALL8(nm, func,a1,a2,a3,a4,a5,a6,a7,a8)                                __doWrapCall8(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8))
# define __STX_C_CALL9(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9)                             __doWrapCall9(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9))
# define __STX_C_CALL10(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)                        __doWrapCall10(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10))
# define __STX_C_CALL11(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11)                    __doWrapCall11(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11))
# define __STX_C_CALL12(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12)                __doWrapCall12(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11),(void *)(a12))
# define __STX_C_CALL13(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13)            __doWrapCall13(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11),(void *)(a12),(void *)(a13))
# define __STX_C_CALL14(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14)        __doWrapCall14(__WRAP_CAPI, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11),(void *)(a12),(void *)(a13),(void *)(a14))

# define __STX_C_NOINT_CALL0(nm, func)                                                  __doWrapCall0(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func)
# define __STX_C_NOINT_CALL1(nm, func,a1)                                               __doWrapCall1(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1))
# define __STX_C_NOINT_CALL2(nm, func,a1,a2)                                            __doWrapCall2(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2))
# define __STX_C_NOINT_CALL3(nm, func,a1,a2,a3)                                         __doWrapCall3(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3))
# define __STX_C_NOINT_CALL4(nm, func,a1,a2,a3,a4)                                      __doWrapCall4(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4))
# define __STX_C_NOINT_CALL5(nm, func,a1,a2,a3,a4,a5)                                   __doWrapCall5(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5))
# define __STX_C_NOINT_CALL6(nm, func,a1,a2,a3,a4,a5,a6)                                __doWrapCall6(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6))
# define __STX_C_NOINT_CALL7(nm, func,a1,a2,a3,a4,a5,a6,a7)                             __doWrapCall7(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7))
# define __STX_C_NOINT_CALL8(nm, func,a1,a2,a3,a4,a5,a6,a7,a8)                          __doWrapCall8(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8))
# define __STX_C_NOINT_CALL9(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9)                       __doWrapCall9(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9))
# define __STX_C_NOINT_CALL10(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)                  __doWrapCall10(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10))
# define __STX_C_NOINT_CALL11(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11)              __doWrapCall11(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11))
# define __STX_C_NOINT_CALL12(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12)          __doWrapCall12(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11),(void *)(a12))
# define __STX_C_NOINT_CALL13(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13)      __doWrapCall13(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11),(void *)(a12),(void *)(a13))
# define __STX_C_NOINT_CALL14(nm, func,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14)  __doWrapCall14(__WRAP_CAPI|__WRAP_NO_INTERRUPT, nm, (wrapFunction_t)func,(void *)(a1),(void *)(a2),(void *)(a3),(void *)(a4),(void *)(a5),(void *)(a6),(void *)(a7),(void *)(a8),(void *)(a9),(void *)(a10),(void *)(a11),(void *)(a12),(void *)(a13),(void *)(a14))

/* tag GetLastError codes */
/* to distinguish from Posix errors */
# define __isWIN32Error(x)     (x & 0x01000000)
# define __WIN32_ERR(x)        ((x) | 0x01000000)

# endif /* __ASSEMBLER__ */

# if !defined(__FOR_STC__) && !defined(__IN_STC__) && !defined(__IN_GENOFFSETS__)

/* sigh - the win32 printf-functions are not thread-save
 * use our own (fixed) ones.
 */
#ifdef __GNUC__
# undef printf
# ifndef __ASSEMBLER__
int __win32_printf(const char *format, ...) __attribute__((format(printf, 1,2)));
int __win32_fprintf(FILE *stream, const char *format, ...) __attribute__((format(printf, 2,3)));
#  endif
# define printf  __win32_printf
#else
# ifndef __ASSEMBLER__
int __win32_printf(const char *format, ...);
int __win32_fprintf(FILE *stream, const char *format, ...);
# endif
#endif

# ifndef __ASSEMBLER__
int __win32_putchar(int c);
# endif
#  undef putchar
#  define putchar  __win32_putchar

# ifndef __ASSEMBLER__
int __win32_getchar(void);
# endif
#  undef getchar
#  define getchar  __win32_getchar

#  if 0
#   undef putc
#   define putc    __win32_putc
#   undef fprintf
#   define fprintf __win32_fprintf
#   undef fflush
#   define fflush  __win32_fflush
#   undef fwrite
#   define fwrite  __win32_fwrite
#  endif

#  if !defined(__IN_VM__)
#   ifndef __ASSEMBLER__
FILE* __win32_stderr();
FILE* __win32_stdout();
FILE* __win32_stdin();
#   endif
#   ifdef stderr
#    undef stderr
#   endif
#   define stderr         ((FILE *)__win32_stderr())
#   ifdef stdout
#    undef stdout
#   endif
#   define stdout         ((FILE *)__win32_stdout())
#   ifdef stdin
#    undef stdin
#   endif
#   define stdin          ((FILE *)__win32_stdin())
#  endif /* ! IN_VM */

#  define console_fprintf        __win32_fprintf
#  define console_printf         __win32_printf
#  define console_fflush         __win32_fflush

#  ifndef _MT
#   define _MT            /* multiThreaded */
#  endif

#  define __threadErrno __stxThreadErrno

# endif /* ! STC */

# define INIT_TEXT_SECTION     /* as nothing */

/*
 * prepend this to function declarations, that should be AUTO-exported in DLLs
 */
# define DLL_EXPORT  __declspec(dllexport)

# if !defined(__IN_VM__)
#  define DLL_IMPORT  __declspec(dllimport)
# else
#  define DLL_IMPORT /* nothing */
# endif

#endif /* __NTINTERN_H__ */
