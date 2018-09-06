/*
 * $Header$
 */
/*
 * COPYRIGHT (c) 1988 by Claus Gittinger
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

#ifndef __LINUXINTERN_H__
# define __LINUXINTERN_H__

# ifdef __x86_64__
#  define __POINTER_SIZE__ 8
# endif

/* enable large/64 bit files */
# define _LARGEFILE_SOURCE   1
# define _FILE_OFFSET_BITS   64

# ifdef USE_STAT64
#  define __USE_LARGEFILE64
# endif

# if defined(__x86_64__) || defined(__x86__)
#  define __NEED_FLOATARRAY_ALIGN
#  define __NEED_DOUBLE_ALIGN
#  define __NEED_LONGLONG_ALIGN
#  define __FLOATARRAY_ALIGN    sizeof(double)
#  define __DOUBLE_ALIGN        sizeof(double)
#  define __LONGLONG_ALIGN      sizeof(double)
# endif

/*
 * stc generates calls to strchr() and memcpy()
 * - include for correct function prototypes
 * - but not when compiling librun/asmhelp.c
 */

# if !defined(__ASSEMBLER__)
#  include <string.h>
#  include <memory.h>
# endif

/* SystemTap support */
# ifdef HAS_SYSTEMTAP
#  ifndef FORCE_NO_SYSTEMTAP
#   include <sys/sdt.h>
#  endif
# endif


# ifdef __arm__
#  define NO_CLOCK_GETTIME
# endif

/*
** VM and class lib defines
**
*/

# if __POINTER_SIZE__ == 8
#  if 0
#   define OLDSPACE_ADDRESS       (char *)0x500000000000
#   define COLLECTEDOLD_ADDRESS   (char *)0x800000000000
#   define MAX_MMAP                       0x300000000000  /* a lot */
#  endif // 0

#  define OLDSPACE_ADDRESS       (char *)0x10000000000
#  define COLLECTEDOLD_ADDRESS   (char *)0x40000000000
#  define MAX_MMAP                       0x30000000000    /* a lot */

#  ifndef __NO_SYMBASE__
#   define __SYMBASE__            0x20000000
#  endif
#  ifndef __NO_FIXBASE__
#   define __FIXBASE__            0x1FFE0000             /* 128 kByte */
#  endif
#  ifndef __NO_CODEBASE__
#   define __CODEBASE__           0x28000000
#  endif

#if 0
#  ifndef __NO_SYMBASE__
#   define __SYMBASE__                     0x160000000
#  endif
#  ifndef __NO_FIXBASE__
#   define __FIXBASE__                     0x15FFE0000  /* 128 kByte */
#  endif
#  ifndef __NO_CODEBASE__
#   define __CODEBASE__                    0x180000000  /* must be in 32bit range to code, which is at 0x100000000 */
#   define __CODEOBJECTBASE__              0x170000000
#  endif
#endif // 0

# else // __POINTER_SIZE__ != 8

#  ifdef __arm__

#    define OLDSPACE_ADDRESS       (char *)0x30000000
#    define COLLECTEDOLD_ADDRESS   (char *)0x60000000
#    define MAX_MMAP               0x30000000              /* 768 Mbyte */

#  else // x86

#   ifdef ELF
#    define OLDSPACE_ADDRESS       (char *)0x50000000
#    define COLLECTEDOLD_ADDRESS   (char *)0x80000000
#    define MAX_MMAP               0x30000000              /* 768 Mbyte */
#   else
#    define OLDSPACE_ADDRESS       (char *)0x30000000
#    define COLLECTEDOLD_ADDRESS   (char *)0x40000000
#    define MAX_MMAP               0x10000000              /* 256 Mbyte */
#   endif
#  endif

#  ifndef __NO_SYMBASE__
#   define __SYMBASE__            0x20000000
#  endif
#  ifndef __NO_FIXBASE__
#   define __FIXBASE__            0x1FFE0000             /* 128 kByte */
#  endif
#  ifndef __NO_CODEBASE__
#   define __CODEBASE__           0x28000000
#  endif

# endif /* __POINTER_SIZE__ */

# if defined(__FIXBASE__) && defined(ELF)
#  define __VM_SEND_TABLE__
#  define __INDIRECTVMINITCALLS__
#  define __INDIRECTVMCALLS__
# endif

# define NEED_SYS_MMAN_H
# define NEED_FCNTL_H
# define NEED_SYS_TIME_H
# define NEED_TIME_H

# define LONGFILENAMES

# define HAS_GETCWD
# define HAS_GETWD
# define HAS_GETTIMEOFDAY
# define HAS_GETHOSTID
# define HAS_GETHOSTNAME
# define HAS_GETDOMAINNAME
# define HAS_UNAME
# define HAS_UTSNAME_H
# define HAS_UTS_DOMAINNAME

# define HAS_WAITPID
# define HAS_WAIT3

# define HAS_OPENDIR
# define HAS_RENAME
# define HAS_REALPATH
# define HAS_TRUNCATE
# define HAS_FTRUNCATE

# define HAS_FDATASYNC

# define HAS_MMAP
# define HAS_MAP_ANONYMOUS
# define HAS_MADVISE
/* # define HAS_SIGSETMASK */
# define HAS_SIGPROCMASK
# define HAS_SIGACTION
# define HAS_MPROTECT
# define HAS_STRCOLL
# define HAS_DEV_ZERO
# define HAS_GETPAGESIZE
# define HAS_SYSCONF

# define HAS_SENDFILE           /* mhmh - only linux > 2.2 has it */
# define HAS_UNIX98_PTY         /* open pseudo ttys via /dev/ptmx */

# define HAS_DLOPEN
# define SYSV4_DL
# define HAS_DL

# if defined(__GNUC__) || defined(__clang__)
#  define __COMPILER_OPTIMIZES_ROTATE__
# endif


/* for now... */
# if __POINTER_SIZE__ == 4
#  define HAVE_FFI
# endif

# ifdef ELF
#  undef A_DOT_OUT
# endif

/* since this is used as a C-compiler flag, add "-m32" case we run on a 64bit system*/
# if defined(__x86__) || defined(__x86_64__) || defined(__amd64__)
#  ifdef ELF
#   if !defined(__amd64__) && !defined(__x86_64__)
#    define OS_DEFINE "-D__linux__ -DLINUX -DELF -m32"
#   else
#    define OS_DEFINE "-D__linux__ -DLINUX -DELF -m64 -fPIC"
#   endif
#  else
#   if !defined(__amd64__) && !defined(__x86_64__)
#    define OS_DEFINE "-D__linux__ -DLINUX -m32"
#   else
#    define OS_DEFINE "-D__linux__ -DLINUX -m64 -fPIC"
#   endif
#  endif
# endif

# ifdef __x86__
#  define PASS_ARG_POINTER

#  if defined(__GNUC__)
#   define FAST_MEMCPY4
#  endif
#  define FAST_STRING_MEMSET
#  define FAST_OBJECT_MEMSET4
#  define FAST_ARRAY_MEMSET4

#  define __FLOAT0_IS_INT0
#  define __DOUBLE0_IS_INT0

#  define __SUPPORT_DIRECT_ILC

# else /* not __x86__ */

#  undef PASS_ARG_POINTER       /* args passed in registers - not on stack */

# endif /* x86 */



# if (__POINTER_SIZE__ == 4)

#  ifdef NOTEF
#   ifndef __ASSEMBLER__
#    if defined(__x86__) && defined(__GNUC__)
#     if !defined(__ALL_REGISTERS__)
	 register unsigned __bx       asm("%ebx");
#     endif
#    endif
#   endif
#  endif

#  ifdef NOTDEF
#   if defined(__x86__) && defined(__GNUC__)

/*
 * mhmh - this ought to be faster
 * (ommitting a conditional branch)
 * ... but the difference is not a big one on a 486;
 * it may show more of an effect on a pentium
 */
#   define __ALIGN4__(__op)                      \
    ({                                          \
	int __rslt;                             \
	asm("addl  $1, %0            \n         \
	     roll  $31,%0            \n         \
	     adcl  $0, %0            \n         \
	     addl  %0,%0             \n         \
			"  : "=r" (__rslt)      \
			   : "0" ((int)(__op))  \
			   : "cc");             \
	__rslt;                                 \
     })

#   endif /* __x86__ && __GNUC__ */
#  endif // NOTDEF
# endif /* not 64bit */


#endif /* __LINUXINTERN_H__ */

/*
 * new string.h include files have fast string macros defined.
 * The following is only used with old systems (pre gcc2.91).
 */
#if (__POINTER_SIZE__ == 4)
# ifdef __STRINGDEFS__
#  define _STRINGDEFS_H_
#  if !defined(_STRINGDEFS_H_) && !defined(__HAVE_ARCH_STRCPY)
#   if defined(__x86__) && defined(__GNUC__)

#    if !((__GNUC__ == 2 && __GNUC_MINOR__ > 91) || __GNUC__ > 2)
extern inline char *
strcpy(char * dest,const char *src)
{
__asm__ __volatile__(
	"cld\n"
	"1:\tlodsb\n\t"
	"stosb\n\t"
	"testb %%al,%%al\n\t"
	"jne 1b"
	: /* no output */
	:"S" (src),"D" (dest):
	"si","di","ax","memory");
return dest;
}

extern inline char *
strncpy(char * dest,const char *src,size_t count)
{
__asm__ __volatile__(
	"cld\n"
	"1:\tdecl %2\n\t"
	"js 2f\n\t"
	"lodsb\n\t"
	"stosb\n\t"
	"testb %%al,%%al\n\t"
	"jne 1b\n\t"
	"rep\n\t"
	"stosb\n"
	"2:"
	: /* no output */
	:"S" (src),"D" (dest),"c" (count):
	"si","di","ax","cx","memory");
return dest;
}

extern inline char *
strcat(char * dest,const char * src)
{
__asm__ __volatile__(
	"cld\n\t"
	"repne\n\t"
	"scasb\n\t"
	"decl %1\n"
	"1:\tlodsb\n\t"
	"stosb\n\t"
	"testb %%al,%%al\n\t"
	"jne 1b"
	: /* no output */
	:"S" (src),"D" (dest),"a" (0),"c" (0xffffffff)
	:"si","di","ax","cx");
return dest;
}

extern inline int
strcmp(const char * cs,const char * ct)
{
register int __res;
__asm__ __volatile__(
	"cld\n"
	"1:\tlodsb\n\t"
	"scasb\n\t"
	"jne 2f\n\t"
	"testb %%al,%%al\n\t"
	"jne 1b\n\t"
	"xorl %%eax,%%eax\n\t"
	"jmp 3f\n"
	"2:\tsbbl %%eax,%%eax\n\t"
	"orb $1,%%eax\n"
	"3:"
	:"=a" (__res):"S" (cs),"D" (ct)
	:"si","di");
return __res;
}

extern inline int
strncmp(const char * cs,const char * ct,size_t count)
{
register int __res;
__asm__ __volatile__(
	"cld\n"
	"1:\tdecl %3\n\t"
	"js 2f\n\t"
	"lodsb\n\t"
	"scasb\n\t"
	"jne 3f\n\t"
	"testb %%al,%%al\n\t"
	"jne 1b\n"
	"2:\txorl %%eax,%%eax\n\t"
	"jmp 4f\n"
	"3:\tsbbl %%eax,%%eax\n\t"
	"orb $1,%%al\n"
	"4:"
	:"=a" (__res):"S" (cs),"D" (ct),"c" (count)
	:"si","di","cx");
return __res;
}

extern inline char *
strchr(const char * s,char c)
{
register char * __res;
__asm__ __volatile__(
	"cld\n\t"
	"movb %%al,%%ah\n"
	"1:\tlodsb\n\t"
	"cmpb %%ah,%%al\n\t"
	"je 2f\n\t"
	"testb %%al,%%al\n\t"
	"jne 1b\n\t"
	"movl $1,%1\n"
	"2:\tmovl %1,%0\n\t"
	"decl %0"
	:"=a" (__res):"S" (s),"0" (c)
	:"si");
return __res;
}

extern inline char *
strrchr(const char * s,char c)
{
register char * __res;
__asm__ __volatile__(
	"cld\n\t"
	"movb %%al,%%ah\n"
	"1:\tlodsb\n\t"
	"cmpb %%ah,%%al\n\t"
	"jne 2f\n\t"
	"leal -1(%%esi),%0\n"
	"2:\ttestb %%al,%%al\n\t"
	"jne 1b"
	:"=d" (__res):"0" (0),"S" (s),"a" (c)
	:"ax","si");
return __res;
}

extern inline size_t
strlen(const char * s)
{
register int __res;
__asm__ __volatile__(
	"cld\n\t"
	"repne\n\t"
	"scasb\n\t"
	"notl %0\n\t"
	"decl %0"
	:"=c" (__res):"D" (s),"a" (0),"0" (0xffffffff)
	:"di");
return __res;
}
#    endif /* (__GNUC__ == 2 && __GNUC_MINOR__ > 91) || __GNUC__ > 2 */
#   endif /* __x86__ __GNUC__ */
#  endif /* _STRINGDEFS_H_ */
# endif /* __STRINGDEFS__ */
#endif /* not 64bit */


#if !defined(__ASSEMBLER__)
/*
 * Make sure, that we use glibc symbols that are comaptible with older linux versions
 */
# if defined(__GNUC__)
#  include <features.h>       /* for glibc version */
#  if defined(__GLIBC__) && (__GLIBC__ == 2) && (__GLIBC_MINOR__ >= 2)
#   ifdef __x86_64__
	__asm__(".symver clock_gettime,clock_gettime@GLIBC_2.2.5"); // from librt.so.1
	__asm__(".symver memcpy,memcpy@GLIBC_2.2.5");
#   else // __x86__
      /*
       * JV@2016-05-19: Interestingly, on my Debian Stretch it seems that
       * GLIBC 2.14 does no longer export memcpy@GLIBC_2.0. Hence this hack,
       * otherwise XWorkstation won't link. Sigh. 
       */
#     if (__GLIBC_MINOR__ < 14)
	  __asm__(".symver memcpy,memcpy@GLIBC_2.0");
#     endif      
#   endif // __x86__
#  endif
#  undef _FEATURES_H      /* so gets reloaded if necessary */
# endif
#endif // __ASSEMBLER__
