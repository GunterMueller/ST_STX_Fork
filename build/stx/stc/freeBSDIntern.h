/*
 * $Header: /cvs/stx/stx/stc/freeBSDIntern.h,v 1.6 2009/11/17 16:52:35 cg Exp $
 */
/*
 * COPYRIGHT (c) 2002 by eXept Software AG
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

#ifndef __FREEBSDINTERN_H__
# define __FREEBSDINTERN_H__

# define PASS_ARG_POINTER

# ifndef __NO_SYMBASE__
#  define __SYMBASE__            0x20000000
# endif
# ifndef __NO_FIXBASE__
#  define __FIXBASE__            0x1FFE0000             /* 128 kByte */
# endif
# ifndef __NO_CODEBASE__
#  define __CODEBASE__           0x28000000
# endif

# ifdef ELF
#  define OLDSPACE_ADDRESS       (char *)0x30000000
#  define COLLECTEDOLD_ADDRESS   (char *)0x38000000
#  define MAX_MMAP               0x08000000              /* 128 Mbyte */
# else
#  define OLDSPACE_ADDRESS       (char *)0x30000000
#  define COLLECTEDOLD_ADDRESS   (char *)0x40000000
#  define MAX_MMAP               0x10000000              /* 256 Mbyte */
# endif

# if defined(__FIXBASE__) && defined(ELF)
#  define __VM_SEND_TABLE__
#  define __INDIRECTVMINITCALLS__
#  define __INDIRECTVMCALLS__
# endif

# define NEED_SYS_MMAN_H
# define NEED_FCNTL_H
# define NEED_SYS_TYPES_H

# define LONGFILENAMES

# define HAS_GETCWD
# define HAS_GETWD
# define HAS_GETTIMEOFDAY
# define HAS_GETHOSTID
# define HAS_GETHOSTNAME
# define HAS_GETDOMAINNAME
# define HAS_UNAME
# define HAS_UTSNAME_H
# define HAS_TM_GMTOFF
# undef HAS_FDATASYNC
# define xxHAS_UTS_DOMAINNAME

# define HAS_WAITPID
# define HAS_WAIT3

# define HAS_OPENDIR
# define HAS_RENAME
# define HAS_REALPATH
# define HAS_TRUNCATE
# define HAS_FTRUNCATE

# define HAS_MMAP
/* # define HAS_SIGSETMASK */
# define HAS_SIGPROCMASK
# define HAS_SIGACTION
# define HAS_MPROTECT
# define HAS_STRCOLL
# define HAS_DEV_ZERO
# define HAS_GETPAGESIZE
# define HAS_SYSCONF

# ifndef HAS_DLOPEN
#  define HAS_DLOPEN
# endif

# define OS_DEFINE "-DFREEBSD -DELF"
# ifndef BSD
#  define BSD
# endif

# ifdef __x86__
#  if defined(__GNUC__)
#   define FAST_MEMCPY4
#  endif
#  define FAST_STRING_MEMSET
#  define FAST_OBJECT_MEMSET4
#  define FAST_ARRAY_MEMSET4

#  define __FLOAT0_IS_INT0
#  define __DOUBLE0_IS_INT0

#  define __SUPPORT_DIRECT_ILC

# endif /* x86 */

# ifdef NOTEF
#  ifndef __ASSEMBLER__
#   if defined(__x86__) && defined(__GNUC__)
#    if !defined(__ALL_REGISTERS__)
	register unsigned __bx       asm("%ebx");
#    endif
#   endif
#  endif
# endif

# if defined(__x86__) && defined(__GNUC__)
#  ifdef NOTDEF

/*
 * mhmh - this ought to be faster
 * (ommitting a conditional branch)
 * ... but the difference is not a big one on a 486;
 * it may show more of an effect on a pentium
 */
#  define __ALIGN4__(__op)                      \
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

#  endif
# endif /* __x86__ && __GNUC__ */


#endif /* __FREEBSDINTERN_H__ */

#ifdef __STRINGDEFS__
# define _STRINGDEFS_H_
# if !defined(_STRINGDEFS_H_) && !defined(__HAVE_ARCH_STRCPY)
#  if defined(__x86__) && defined(__GNUC__)

#   if (__GNUC__ == 2 && __GNUC_MINOR__ > 91) || __GNUC__ > 2
#   else
extern inline char * strcpy(char * dest,const char *src)
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

extern inline char * strncpy(char * dest,const char *src,size_t count)
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

extern inline char * strcat(char * dest,const char * src)
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

extern inline int strcmp(const char * cs,const char * ct)
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

extern inline int strncmp(const char * cs,const char * ct,size_t count)
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

extern inline char * strchr(const char * s,char c)
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

extern inline char * strrchr(const char * s,char c)
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

extern inline size_t strlen(const char * s)
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
#   endif /* (__GNUC__ == 2 && __GNUC_MINOR__ > 91) || __GNUC__ > 2 */
#  endif /* __x86__ __GNUC__ */
# endif /* _STRINGDEFS_H_ */
#endif /* __STRINGDEFS__ */
