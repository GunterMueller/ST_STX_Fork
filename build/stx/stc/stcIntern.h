/*
 * $Header$
 */
/*
 * COPYRIGHT (c) 1988 by Claus Gittinger
 * COPYRIGHT (c) 2015-2016 Jan Vrany
 * COPYRIGHT (c) 2018 Jan Vrany
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
 * common definitions for stc - compiler and runtime library
 * Will be later replaced by an interactive program or self-configuration
 * (well I hope it will :-)
 */

#ifndef __STCINTERN_H__
# define __STCINTERN_H__

#include "stx-config.h"
#ifndef __ASSEMBLER__
# include <stdint.h>
# include <inttypes.h>
#endif


#define METHOD_IN_CONTEXT               /* you have to remove the instvar in context if you disable this */
#ifndef NO_SUPPORT_EXTERNAL_LOOKUP
# define SUPPORT_EXTERNAL_LOOKUP
#endif
#define LOOKUP_OBJECT_IN_BEHAVIOR      /* you have to remove the instvar in behavior if you disable this */
#define LOOKUP_OBJECT_IN_METHOD        /* you have to remove the instvar in method if you disable this */

// #define METHOD_IN_ILC
// #define SELECTOR_IN_METHOD            /* not really needed - once we have the mclass, getting the selector is easy */
#define ANNOTATION_IN_METHOD          /* leave that in the annotatedMethod */


/**
 * Defines minimum and maximum allowed process ids, i.e., value of Process.id 
 * (see Process.st) and of struct process->id (see process.h).
 *
 * Maximum physical value is _MAX_INT, however, if thinlocking is enabled,
 * process id must fit into TID field of lockword, which is typically smaller
 * than 31/63 bits. Therefore the limit is actually smaller.
 */
#define MIN_PROCESS_ID 0x00001
#define MAX_PROCESS_ID 0xFFFFF

/**
 * Defines a (fixed) process id of system process. This is the initial
 * process that later becomes a scheduling process. 
 * 
 * It may not be 0 (zero) since then thinlocks won't work for system
 * process (one could not tell between unlocked lock and lock locked
 * once by system process). 
 */
#define SYS_PROCESS_ID MIN_PROCESS_ID

/*
 * Defines an invalid process id. No process can have this ID. 
 * Used as an error-indicating return value
 */
#define INV_PROCESS_ID MIN_PROCESS_ID - 1

/*
 * these two can no longer be turned off ...
 */
#define THIS_CONTEXT
#define STACK_PROBES

#define __UNROLL_LOOPS__

/*
 * -------------------------------
 * unify all those different OS and CPU-defines into a common format:
 * __xxx__, which will be one of:
 *      __x86__
 *      __x86_64__
 *      __sparc__
 *      __arm__
 *      __powerPC__
 *      __alpha__ optionally plus __alpha64__
 *      __transputer__
 *      __vax__
 *      __s390__
 *      __mc88k__
 *      __mc68k__
 *      __ns32k__
 *      __hppa__
 *
 * notice that some of the above are no longer common (outdated)
 * and/or no longer supported.
 * However - you never know:
 *      __mips__ and __mc68k__ seemed dead, until those
 *      embedded all-in-one chips came up.
 *      So never declare something completely dead.
 *
 * Operating systems are unified accordingly into:
 *      __linux__
 *      __win32__   (also if 64bit)
 *      __osx__
 *      __hpux__
 *      __vms__
 *      __aix__
 *
 * Compilers are unified to:
 *      __BORLANDC__
 *      __MINGW__  (optionally plus __MINGW64__)
 *      __GNUC__   (optionally plus __MINGW64__)
 *      __CLANG__  (attention: usually also defined __GNUC__)
 *      __VISUALC__
 *
 *
 * There is still some old code found in places,
 * which refers to the non-unified ifdefs (i.e. ifdef i386 or ifdef sparc).
 * These are being replaced, as we go along.
 * (however, as other open source C-code is also found here and there
 *  - for example in libjpeg or libbzip - , these should be kept)
 * So there may still be some confusion here and there.
 */

/*
 * map all ns32k cpus to ns32k
 */
#ifndef __ns32k__
# if defined(ns32k) || defined(ns32032) || defined(ns32332) || defined(ns32532)
#  define __ns32k__
# endif
# if defined(ns32016) || defined(ns32000)
#  define __ns32k__
# endif
#endif

#if defined(alpha64) || defined(__alpha64__)
# define __alpha__
# ifndef alpha64
#  define alpha64
# endif
# ifndef __alpha64__
#  define __alpha64__
# endif
#endif

#if defined(__alpha) || defined(__alpha__)
# ifndef alpha
#  define alpha
# endif
# ifndef __alpha__
#  define __alpha__
# endif
#endif

/*
 * sun3 stands for sunos and 68k cpu
 */
#if defined(sun3)
# ifndef sunos
#  define sunos
# endif
# ifndef mc68k
#  define mc68k
# endif
# ifndef __mc68k__
#  define __mc68k__
# endif
#endif

/*
 * sun386i stands for sunos4.x and 386 cpu
 */
#if defined(sun386i)
# ifndef sunos
#  define sunos
# endif
# ifndef i386
#  define i386
# endif
# ifndef __i386__
#  define __i386__
# endif
# ifndef __x86__
#  define __x86__
# endif
#endif

/*
 * solaris / solaris2_0 stand for SYSV4 and sparc cpu
 * sun4 stands for sunos and sparc cpu
 */
#ifdef solaris2_0
# ifndef solaris
#  define solaris
# endif
# endif
#ifdef solaris
# ifndef SYSV4
#  define SYSV4
# endif
#endif

#if defined(sun4) || defined(sun5)
# ifndef solaris
#  ifndef sunos
#   define sunos
#  endif
#  endif
# if !defined(__x86__) && !defined(__i386__) && !defined(i386)
#  ifndef sparc
#   define sparc
#  endif
#  ifndef __sparc__
#   define __sparc__
#  endif
# endif
#endif

/*
 * NEXT stands for BSD-like, mach and 68k cpu
 * (maybe this will change when new NeXTs arrive)
 * late news: forget it !
 */
#if defined(NEXT)
# if !defined(mc68k) && !defined(__mc68k__) && !defined(i386) && !defined(__i386__) && !defined(__x86__) && !defined(hppa) && !defined(__hppa__) && !defined(sparc) && !defined(__sparc__)
   /* default to 68k if not stated otherwise */
#  define mc68k
#  define __mc68k__
# endif
# ifndef BSD
#  define BSD
# endif
# ifndef MACH
#  define MACH
#  define __MACH__
# endif
#endif/* NEXT */

#if defined(__APPLE__) && defined(__MACH__)
# ifndef __osx__
#  define __osx__
# endif
#endif

#if defined(OSX) || defined(__osx__) || defined(__OSX__)

# if !defined(MACH)
#  define MACH
# endif
# if !defined(__MACH__)
#  define __MACH__
# endif
# ifndef __OSX__
#  define __OSX__
# endif
# ifndef __osx__
#  define __osx__
# endif
# ifndef OSX
#  define OSX
# endif

# if !defined(i386) && !defined(__i386__) && !defined(__x86__) && !defined(__ia64__) && !defined(__x86_64__)
#  if !defined(powerPC)
#   define powerPC
#  endif
#  if !defined(__powerPC__)
#   define __powerPC__
#  endif
# endif

# ifndef MAC
#  define MAC
# endif

#endif /* OSX */


#if defined(__i386__)
# undef __amd64__
# undef __amd64
#endif

#if defined(__x86_64__)
# undef __amd64__
# undef __amd64
# undef __amd64_mode32__
#endif

#if defined(__amd64) && !defined(__amd64__)
# define __amd64__
#endif

#if defined(__amd64__) || defined(__x86_64__)
# undef __i386__
# undef i386
# undef __x86__
#endif

#if defined(__amd64__) && !defined(__x86_64__)
# define __x86_64__
#endif

/*
 * running on amd, but compiling for 32bit
 */
#if defined(__amd64_mode32__)
# undef __amd64__
# undef __amd64
# undef __x86_64__
# ifndef __i386__
#  define __i386__
# endif
# ifndef __x86__
#  define __x86__
# endif
#endif

/*
 * WIN32, WINNT stand for i386, if not stated otherwise
 */
#if defined(WINNT)
# ifndef WIN32
#  define WIN32
# endif
#endif
#if defined(WIN32) || defined(__win32__)
# ifndef WIN32
#  define WIN32
# endif
# ifndef __win32__
#  define __win32__
# endif
#endif

#if defined(WIN32)
# ifdef WIN32THREADS
#  if 0
#   define __PROBE__(f, arg)
#   define __PROBE_N__(f, arg, n)
# endif
# endif
# if !defined(i386) && !defined(__i386__) && !defined(mips) && !defined(__mips__) && !defined(alpha) && !defined(__alpha__) && !defined(__x86_64__)
#  define i386
#  define __i386__
#  if !defined(__x86__)
#   define __x86__
#  endif
# endif
#endif

/*
 * ultrix
 */
#if defined(ultrix4_4)
#  define ultrix
# endif

#if defined (solaris) || defined(__solaris__) || defined (solaris2_0)
# ifndef solaris
#  define solaris
# endif
# ifndef __solaris__
#  define __solaris__
# endif
#endif

/*
 * sunos 4.x is bsd like
 */
#if defined(sunos) && !defined(solaris)
#  define BSD
# define __sunos__
#endif

#if defined (solaris) || defined(solaris2_0)
# undef BSD
#endif

/*
 * sinix and dynix are sometimes bsd like
 */
#if defined(sinix) || defined(dynix)
# if defined(ATT)
#  define SYSV
# else
#  define BSD
# endif
#endif

/*
 * hpux is SYSV-like
 */
#if defined(hpux10) || defined(hpux11)
# ifndef hpux
#  define hpux
# endif
# ifndef __hpux__
#  define __hpux__
# endif
#endif

#if defined(hpux)
# define SYSV3
#endif

/*
 * irix5 is a sys5.4
 */
#if defined(IRIX5)
# define SYSV4
# define IRIS
#endif

#if defined(unixware)
# define SYSV4
#endif

// this belongs into a system specific
// xxxintern.h
#if 0
#if defined(SYSV4) && !defined(solaris)
# if defined(i386) || defined(__i386__)
#  define SYSV4i386
#  ifndef __ASSEMBLER__
/*
 * some defines in this file collide with definitions in
 * function prototypes. So we include the function prototypes before
 * redefining the symbols.
 */
#   include <string.h>
#   include <memory.h>
#  endif
# endif
#endif
#endif

/*
 * sco and isc are always SYS5-like
 */
#if defined(sco2_3) || defined(sco3_2)
# ifndef sco
#  define sco
# endif
#endif

#if defined(sco) || defined(isc3_2)
# ifndef __i386__
#  define __i386__
# endif
# ifndef __x86__
#  define __x86__
# endif
# define SYSV3
#endif

/*
 * unify vax and __vax__
 */
#if defined(VAX) || defined(__VAX__) || defined(vax) || defined(__vax__)
# ifndef vax
#  define vax
# endif
# ifndef __vax__
#  define __vax__
# endif
#endif

/*
 * unify __x86_64 and __x86_64__
 */
#if defined(__x86_64) || defined(__x86_64__)
# ifndef __x86_64__
#  define __x86_64__
# endif
# ifndef __x86_64
#  define __x86_64
# endif
#endif

/*
 * unify i386 and __i386__
 */
#if defined(i386) || defined(__i386__) || defined(__x86__) || defined(__x86)
# ifndef __x86_64__
#  ifndef __i386__
#   define __i386__
#  endif
#  ifndef i386
#   define i386
#  endif
#  ifndef __x86
#   define __x86
#  endif
#  ifndef __x86__
#   define __x86__
#  endif
# endif
#endif

/*
 * unify ia64 and __ia64__
 */
#if defined(ia64) || defined(__ia64__)
# ifndef ia64
#  define ia64
# endif
# ifndef __ia64__
#  define __ia64__
# endif
#endif

/*
 * unify sparc and __sparc__
 */
#if defined(sparc) || defined(__sparc__)
# ifndef sparc
#  define sparc
# endif
# ifndef __sparc__
#  define __sparc__
# endif
#endif

/*
 * unify powerPC and __powerPC__
 */
#if defined(powerPC) || defined(__powerPC__)
# ifndef powerPC
#  define powerPC
# endif
# ifndef __powerPC__
#  define __powerPC__
# endif
#endif
#if defined(__rs6k__)
# ifndef (__powerPC__)
#  define __powerPC__
# endif
#endif

/*
 * unify mips and __mips__
 */
#if defined(mips) || defined(__mips__)
# ifndef mips
#  define mips
# endif
# ifndef __mips__
#  define __mips__
# endif
#endif

/*
 * unify mc68k and __mc68k__
 */
#if defined(mc68k) || defined(__mc68k__)
# ifndef mc68k
#  define mc68k
# endif
# ifndef __mc68k__
#  define __mc68k__
# endif
#endif

/*
 * unify mc88k and __mc88k__
 */
#if defined(mc88k) || defined(__mc88k__)
# ifndef mc88k
#  define mc88k
# endif
# ifndef __mc88k__
#  define __mc88k__
# endif
#endif

/*
 * unify s390 and __s390__
 */
#if defined(s390) || defined(__s390__)
# ifndef s390
#  define s390
# endif
# ifndef __s390__
#  define __s390__
# endif
#endif

/*
 * unify arm and __arm__
 */
#if defined(arm) || defined(__arm__) || defined(__armv6l__)
# ifndef __arm__
#  define __arm__
# endif
#endif

/*
 * unify hppa and __hppa__
 */
#if defined(hppa) || defined(__hppa__)
# ifndef hppa
#  define hppa
# endif
# ifndef __hppa__
#  define __hppa__
# endif
#endif

/*
 * unify transputer and __transputer__
 */
#if defined(transputer) || defined(__transputer__)
# ifndef transputer
#  define transputer
# endif
# ifndef __transputer__
#  define __transputer__
# endif
#endif

/*
 * SVR4 is a SYS5
 */
#if defined(SYSV4)
# define SYSV
#endif

#if defined(SYSV3)
# define SYSV
#endif

#if !defined(__aix__)
# if defined(_AIX) && !defined(aix)
#  define aix
# endif
# if defined(aix) && !defined(_AIX)
#  define _AIX
# endif
# if defined(aix) || defined(_AIX)
#  define __aix__
# endif
#endif

/*
 * osf is bsd-like
 */
#if defined __osf__
# define BSD
#endif

/*
 * vms
 */
#if defined(__openVMS__)
# ifndef __VMS__
#  define __VMS__
# endif
#endif
#if defined(__vms__) || defined(__VMS__) || defined(vms) || defined(VMS)
# ifndef __VMS__
#  define __VMS__
# endif
#endif
#ifdef __VMS__
# define __vms__
#endif

/*
 * interactive systems made a horrible mess in /usr/include
 */
#if defined(isc3_2) && defined(__STDC__)
# undef __STDC__
#endif

/*
 * everything else is a UNIX
 */
#ifndef UNIX
# if !defined(VMS) && !defined(WIN32) && !defined(MACOS) && !defined(BEOS) && !defined(__transputer__)
#  define UNIX
# endif
#endif

#if defined(__MINGW32__) || defined(__MINGW64__)
# ifndef __MINGW__
#  define __MINGW__
# endif
#endif

#if defined(__CLANG__) || defined(__clang__)
# ifndef __CLANG__
#  define __CLANG__
# endif
# ifndef __clang__
#  define __clang__
# endif
#endif

/* end of CPU+OS unification
 *---------------------------------
 */

/*
 * ################# machine specific stuff - moved into separate include file ######################
 */
#undef HAVE_ARCHSPEC_INTERN

#ifdef IRIS
# include "sgiIntern.h"
# define HAVE_ARCHSPEC_INTERN
#endif

#ifdef NEXT
# include "nextIntern.h"
# define HAVE_ARCHSPEC_INTERN
#endif

#ifdef LINUX
# include "linuxIntern.h"
# define HAVE_ARCHSPEC_INTERN
#endif

#ifdef FREEBSD
# include "freeBSDIntern.h"
# define HAVE_ARCHSPEC_INTERN
#endif

#ifdef ultrix
# include "ultrixIntern.h"
# define HAVE_ARCHSPEC_INTERN
#endif

#ifdef hpux
# include "hpuxIntern.h"
# define HAVE_ARCHSPEC_INTERN
#endif

#ifdef _AIX
# include "aixIntern.h"
# define HAVE_ARCHSPEC_INTERN
#endif

#if defined(SYSV4i386)
# include "sysv4i386Intern.h"
# define HAVE_ARCHSPEC_INTERN
#endif

#if defined(realIX)
# include "realIXIntern.h"
# define HAVE_ARCHSPEC_INTERN
#endif

#if defined(sunos) || defined(solaris)
# include "sunIntern.h"
# define HAVE_ARCHSPEC_INTERN
#endif

#if defined(__qnx__)
# include "qnxIntern.h"
# define HAVE_ARCHSPEC_INTERN
#endif

#if defined(__osx__)
# include "macIntern.h"
# define HAVE_ARCHSPEC_INTERN
#endif

#if defined(__win32__) || defined(WIN32) || defined(WINNT)
# if defined(__BORLANDC__)
#  define EXPORT    __export
#  define FASTCALL  __fastcall
# else
#  if defined(__VISUALC__)
#   define EXPORT    /* nothing */
#   define FASTCALL  __fastcall
#  else
#   ifndef EXPORT
#    define EXPORT   /* nothing */
#   endif
#   ifndef FASTCALL
#    define FASTCALL /* nothing */
#   endif
#  endif
# endif
# include "ntIntern.h"
# define HAVE_ARCHSPEC_INTERN
#else
# define EXPORT   /* nothing */
# define FASTCALL /* nothing */
# define DLL_EXPORT  /* as nothing - redefined for win32 */
# define DLL_IMPORT  /* as nothing - redefined for win32 */
#endif

#if defined(alpha) || defined(__alpha__)
# include "alphaIntern.h"
# define HAVE_ARCHSPEC_INTERN
#endif


#if defined(__GNUC__) && !defined(NO_SECTION_ATTRIBUTES)
# if (__GNUC__  == 2 && __GNUC_MINOR__ >= 7) || __GNUC__ > 2
#  undef INIT_TEXT_SECTION
#  define INIT_TEXT_SECTION __attribute__((section(".stxitext")))
# endif
#endif /* GNUC */

#if !defined(INIT_TEXT_SECTION)
# define INIT_TEXT_SECTION /* nothing */
#endif

#ifndef HAVE_ARCHSPEC_INTERN
error error error: missing architecture specific intern. Check #defines
#endif

/*
 * ################# machine/compiler dependencies ######################
 */

/*
 * value found in cpuType ...
 */
#define __CPU_UNKNOWN__         0

#if defined(__x86_64__)
# include "cpu_x86_64.h"
# undef __i386__
# undef __x86__
#else
# if defined(__i386__) || defined(__x86__)
#  include "cpu_i386.h"
# endif
#endif

#ifdef __hppa__
# include "cpu_hppa.h"
#endif

#if defined(__rs6k__) || defined(__powerPC__)
# include "cpu_power.h"
#endif

#if defined(__alpha__)
# include "cpu_alpha.h"
#endif

#if defined(__mc68k__)
# include "cpu_mc68k.h"
#endif

#if defined(__mips__)
# include "cpu_mips.h"
#endif

#if defined(__sparc__)
# include "cpu_sparc.h"
#endif

#if defined(__s390__)
# include "cpu_s390.h"
#endif

#if defined(__vax__)
# include "cpu_vax.h"
#endif

#if defined(__arm__)
# include "cpu_arm.h"
#endif

#ifndef __DEFAULT_CPU__
# define __DEFAULT_CPU__        __CPU_UNKNOWN__
#endif

/*
 * library stuff ..
 * none of these is needed to compile and run ST/X. But some turn on
 * alternative/better implementations for specific operations.
 *
 * define HAS_OPENDIR if your libc has the opendir function
 *     (if not defined, smalltalk uses a pipe to 'ls' to get the info)
 * define HAS_RENAME if your libc has the opendir function
 *     (if not defined, smalltalk uses link/unlink)
 * define HAS_UNAME or HAS_GETHOSTNAME if your libc has the corresponding function
 *     (if not defined, smalltalk uses a pipe to 'hostname')
 * and so on ...
 */

#if defined(SYSV4) && !defined(IRIX5) && !defined(SYSV4i386) && !defined(solaris)
# define LONGFILENAMES
# define HAS_GETTIMEOFDAY
# define HAS_OPENDIR
# define HAS_RENAME
# define HAS_UNAME
# define HAS_DEV_ZERO
# define HAS_SYSCONF
# define HAS_MMAP
# define HAS_MPROTECT
# define HAS_REALPATH
# define HAS_STRCOLL
# define HAS_SIGACTION
#endif

#ifndef stx_setjmp
# define stx_setjmp setjmp
#endif
#ifndef stx_longjmp
# define stx_longjmp longjmp
#endif

/*
 * fall back - will be removed
 */
#if !defined(HAS_RENAME)
# if defined(BSD)
#  define HAS_RENAME
# endif
#endif

/*
 * name a type, where sizeof(type) == sizeof(structure *)
 * On most 32bit machines this is int, but there might be machines around
 * using short integers.
 *
 * defining it as != int is untested - there might be places in the code,
 * where I forgot to replace int by INT - watch out.
 *
 * If there is no such type on your machine - forget it
 * or rewrite the macros in stc.h (and maybe much more) - sorry.
 */
#ifndef __POINTER_SIZE__
# define __POINTER_SIZE__   4
#endif

// define INT as a type which can hold a pointer
// also _lx_ for printing, and __ll__(x) to cas a constant

#define _lx_    PRIxPTR
#define _ld_    PRIdPTR
#define _lo_    PRIxPTR

# if __POINTER_SIZE__ == 8
#  ifdef __MINGW64__
#   define STX_INT       long long

#  else /* not mingw - i.e. alpha or i86_64 on unix */

#   define STX_INT       long

#  endif
#  define STX_INT_SHIFT 3
#  define __ll__  INT64_C
#  define __llu__ UINT64_C

# else /* not 64 bit */

#  define STX_INT       int
#  define STX_INT_SHIFT 2
#  define __ll__  INT32_C
#  define __llu__ UINT32_C


# endif

#ifndef INT
# define INT            STX_INT
# define INT_SHIFT      STX_INT_SHIFT
#endif

#define STX_UINT        unsigned STX_INT

#ifdef __GNUC__
#  define HAS_LONGLONG 1
#endif

/*
 * does your compiler produce a.out or coff or anything else ?
 * hope its a.out - currently only supported format in internal Compiler
 */
#if defined(sunos)
# if defined(sun386i)
#  define COFF
# else
#  define A_DOT_OUT
# endif
#endif

#if defined(sinix) && defined(BSD)
# define A_DOT_OUT
#endif

#if defined(sco) && defined(__GNUC__) && defined(private_gcc)
# define A_DOT_OUT
#endif

#if defined(LINUX)
# define A_DOT_OUT
#endif

#if defined(sco3_2)
# define COFF
#endif

#if defined(dynix) && defined(i386) && defined(BSD)
# define A_DOT_OUT
#endif

#if defined(MACH)
# define MACH_O
#endif

/*
 * fallback, knowing that all SYSV4 systems use ELF
 * all SYSV3 systems use COFF
 */
#if !defined(ELF) && !defined(COFF) && !defined(A_DOT_OUT) && !defined(MACH_O)
# if defined(SYSV)
#  if defined(SYSV4)
#   define ELF
#  else
#   define COFF
#  endif
# endif
#endif

/*
 * does your compiler limit the number of valid chars in an identifier
 */
#if defined(sco) || defined(microsoft)
# define SHORTNAMES
#endif

#if defined(sinix) && defined(ATT)
# define SHORTNAMES
#endif

/*
 * does your machine preserve sign bit when doing right shifts ? (see stc.h)
 * EFFECT -> slower value-fetch value from SmallInteger objects if left undef.
 */
#ifndef SIGNED_SHIFTS
# if defined(someCPUWithSignedShifts)
#  define SIGNED_SHIFTS
# endif
#endif

#if defined(someMachineWithLSBFirst)
# define __LSBFIRST__
#endif
#if defined(someMachineWithMSBFirst)
# define __MSBFIRST__
#endif

#if defined(MSBFIRST) && !defined(LSBFIRST)
# ifndef __MSBFIRST__
#  define __MSBFIRST__
# endif
#else
# if defined(LSBFIRST) && !defined(MSBFIRST)
#  ifndef __LSBFIRST__
#   define __LSBFIRST__
#  endif
# endif
#endif

#if defined(__MSBFIRST) && !defined(__LSBFIRST)
# ifndef __MSBFIRST__
#  define __MSBFIRST__
# endif
#else
# if defined(__LSBFIRST) && !defined(__MSBFIRST)
#  ifndef __LSBFIRST__
#   define __LSBFIRST__
#  endif
# endif
#endif

#if defined(__LSBFIRST__)
# define LSBFIRST
# define __LSBFIRST
#endif
#if defined(__MSBFIRST__)
# define MSBFIRST
# define __MSBFIRST
#endif
#if defined(__LSBFIRST__) && defined(__MSBFIRST__)
error both LSB and MSB - this should not happen.
#endif

#ifdef sun3
#  define __HAS_ALIGN2__
#endif

/*
 * define this if cpu passes arguments by pushing them onto a stack
 * (in contrast to register window machines)
 * EFFECT -> can fill context lazy from arguments
 */
#ifdef NO_TRADITIONAL_STACK_FRAME
# undef TRADITIONAL_STACK_FRAME
#endif

/*
 * define this, if arguments are stored reverse on the stack and
 * stack grows downward.
 * i.e. last argument is pushed first, having highest address
 * EFFECT -> can fill context lazy from arguments
 */
#ifdef someMachine
# define ARG_ORDER_NORMAL
#endif

#ifdef someOtherMachine
# define ARG_ORDER_REVERSE
#endif

/*
 * define this, if VAR-ARGS are always possible without special
 * declaration (I think this is always true for TRADITIONAL_STACK_FRAME)
 * EFFECT -> faster calling in some places
 */
#ifndef EASY_VAR_ARGS
# if defined(TRADITIONAL_STACK_FRAME)
#  define EASY_VAR_ARGS
# endif
#endif

/*
 * instead of writing foo / sizeof(long)
 * it is better on some machines to use a shift
 * (the compiler seems to not detect power-of-two divisions ...)
 * This is hidden in the following macros ...
 */
#if !defined(__BYTES2OBJS__) || !defined(__OBJS2BYTES__)

# if defined(USE_SHIFT_FOR_DIVISION_AND_MULTIPLICATION)
#  define __BYTES2OBJS__(x)  ((x) >> INT_SHIFT)
#  define __OBJS2BYTES__(x)  ((x) << INT_SHIFT)
# else
#  define __BYTES2OBJS__(x)  ((x) / sizeof(OBJ))
#  define __OBJS2BYTES__(x)  ((x) * sizeof(OBJ))
# endif
#endif

#ifdef OLD
/*
 * old: generates two conditional branches
 * may generate shorter code sequence on old CPUs (68k)
 */
# define __ISVALIDINTEGER(i)    (((i) >= _MIN_INT) && ((i) <= _MAX_INT))
#else
/*
 * new: another instruction, but only one branch
 * better on modern pipelined CPUs
 */
# define __ISVALIDINTEGER(i)    (((INT)(i) ^ ((INT)(i)<<1)) >= 0)
#endif

/*
 * Integer arithmetic macros using GCC/Clang intrinsics
 * (https://gcc.gnu.org/onlinedocs/gcc/Integer-Overflow-Builtins.html)
 *
 * ADD_IO_IO -> int-object + int-object
 * ADD_IO_I  -> int-object + integer
 * SUB_IO_IO -> int-object - int-object
 * SUB_IO_I  -> int-object - integer
 */
#if (__GNUC__ >= 5)
# define _ADD_IO_IO(a, b)                               \
    ({                                                  \
        OBJ __rslt;                                     \
        if (__builtin_add_overflow((INT)a-1,(INT)b, (INT*)&__rslt)) {\
            /* Overflow */                              \
            __rslt = __MKLARGEINT(__smallIntegerVal(a) + __smallIntegerVal(b));\
        }                                               \
        __rslt;                                         \
    })    
# define _ADD_IO_I(a, b)                                \
    ({                                                  \
        OBJ __rslt;                                     \
        if (__builtin_add_overflow((INT)a,((INT)b)<<1, (INT*)&__rslt)) {\
            /* Overflow */                              \
            __rslt = __MKLARGEINT(__smallIntegerVal(a) + b);\
        }                                               \
        __rslt;                                         \
    })    
# define _SUB_IO_IO(a, b)                               \
    ({                                                  \
        OBJ __rslt;                                     \
        if (__builtin_sub_overflow((INT)a+1,(INT)b, (INT*)&__rslt)) {\
            /* Overflow */                              \
            __rslt = __MKLARGEINT(__smallIntegerVal(a) - __smallIntegerVal(b));\
        }                                               \
        __rslt;                                         \
    })    
# define _SUB_IO_I(a, b)                                \
    ({                                                  \
        OBJ __rslt;                                     \
        if (__builtin_sub_overflow((INT)a,((INT)b)<<1, (INT*)&__rslt)) {\
            /* Overflow */                              \
            __rslt = __MKLARGEINT(__smallIntegerVal(a) - b);\
        }                                               \
        __rslt;                                         \
    })
#endif // (__GNUC__ >= 5)

/*
 * Integer arithmetic macros with no asm support and no compiler intrinsics
 * (these work always)
 *
 * ADD_IO_IO -> int-object + int-object
 * ADD_IO_I  -> int-object + integer
 * SUB_IO_IO -> int-object - int-object
 * SUB_IO_I  -> int-object - integer
 */
#ifndef _ADD_IO_IO
# define _ADD_IO_IO(a,b)        \
    ((__tttI = (__smallIntegerVal(a) + __smallIntegerVal(b))), \
     __ISVALIDINTEGER(__tttI) \
     ? __MKSMALLINT(__tttI) : __MKLARGEINT(__tttI))

# define _ADD_IO_I(a,b) \
    ((__tttI = (__smallIntegerVal(a) + b)), \
     __ISVALIDINTEGER(__tttI) \
     ? __MKSMALLINT(__tttI) : __MKLARGEINT(__tttI))
#endif

#ifndef _SUB_IO_IO
# define _SUB_IO_IO(a,b)        \
    ((__tttI = (__smallIntegerVal(a) - __smallIntegerVal(b))), \
     __ISVALIDINTEGER(__tttI) \
     ? __MKSMALLINT(__tttI) : __MKLARGEINT(__tttI))

# define _SUB_IO_I(a,b) \
    ((__tttI = (__smallIntegerVal(a) - b)), \
     __ISVALIDINTEGER(__tttI) \
     ? __MKSMALLINT(__tttI) : __MKLARGEINT(__tttI))
#endif

#ifndef _ADD_IO_2
# define _ADD_IO_2(a) \
    ((__tttI = (__smallIntegerVal(a) + __smallIntegerVal(a))), \
     __ISVALIDINTEGER(__tttI) \
     ? __MKSMALLINT(__tttI) : __MKLARGEINT(__tttI))
#endif

#ifdef LATER

#if TAG_INT==1
# define _ADD_IO_1(op)   (((op) != __MKSMALLINT(_MAX_INT)) \
			 ? (OBJ)((INT)(op) + (INT)(__MASKSMALLINT(1))) \
			 : __minPositiveLargeInteger)

# define _SUB_IO_1(op)   (((op) != __MKSMALLINT(_MIN_INT)) \
			 ? (OBJ)((INT)(op) - (INT)(__MASKSMALLINT(1))) \
			 : __maxNegativeLargeInteger)
#else  /* TAG_INT != 1 */
# define _ADD_IO_1(op)   ((op == __MKSMALLINT(_MAX_INT)) \
			 ? __minPositiveLargeInteger \
			 : __MKSMALLINT(__smallIntegerVal(op) + 1))

# define _SUB_IO_1(op)   ((op == __MKSMALLINT(_MIN_INT)) \
			 ? __maxNegativeLargeInteger \
			 : __MKSMALLINT(__smallIntegerVal(op) - 1))
#endif /* TAG_INT != 1 */

#else /* !LATER */

# define _ADD_IO_1(op)  _ADD_IO_I(op, 1)
# define _SUB_IO_1(op)  _SUB_IO_I(op, 1)

#endif /* !LATER */

#ifndef __ALIGN__

# if defined(__NEED_LONGLONG_ALIGN) || defined(__NEED_DOUBLE_ALIGN) || defined(__NEED_FLOATARRAY_ALIGN)
#  define __ALIGN__ sizeof(double)
# else
#  define __ALIGN__ sizeof(INT)
# endif

#endif

/*
 * workaround for a bug in the gnu (1.34) compiler, which does not like
 * (double) casts in initializers.
 * (other compilers need the casts - oh well)
 */
#ifdef __GNUC__
# define NO_CAST_IN_INITIALIZER
#endif

/*
 * workaround for optimizing compilers (gnu-1.39 and above) compilers,
 * which do not honor volatile keyword in some constellations:
 * It may be due to the evaluation sequence, which computes left-to-
 * right and therefore computes the address on the left of an assignment
 * first ...
 *
 *   f(x)
 *      volatile OBJ x;
 *   {
 *      struct {
 *          OBJ *pX;
 *          ...
 *      } y;
 *
 *      y.pX = &x;
 *      x->field = g(&y);        -- changes *(y->pX)
 *      -- access is through old-x (in register)
 *
 * the workaround is to introduce another temporary (funny - it will be
 * optimized away !) ala:
 *
 *      OBJ ttt;
 *
 *      ttt = g(&y);
 *      x->field = ttt;
 */
#define ASSIGNMENT_ORDER_CARES

/*
 * some c-compilers need an extern declaration (which is wrong)
 * others want static (which is correct),
 * when referencing a static before its definition.
 * define to be either: static, extern or empty.
 * if you don't know what to put in here, try compiling libbasic first
 * and watch for compiler barking about redeclaration of endOfModule.
 * (see definition/use of *endOfModule in resulting c-file)
 */
#ifndef FORWARD_STATIC

# ifdef __GNUC__
#  define FORWARD_STATIC static
# endif

# if defined(sinix) && defined(ATT)
#  define FORWARD_STATIC static
# endif

# if defined(isc3_2) && !defined(__GNUC__)
#  define FORWARD_STATIC extern
# endif

# if defined(sco3_2)
#  define FORWARD_STATIC extern
# endif

# if defined(hpux) && !defined(__GNUC__)
#  define FORWARD_STATIC int
# endif

# if defined(solaris) && !defined(__GNUC__)
#  define FORWARD_STATIC int
# endif

# if defined(PCS) && defined(__mips__)
#  define FORWARD_STATIC int
# endif

# if defined(IRIX5)
#  define FORWARD_STATIC static
# endif

# if defined(_AIX) && !defined(__GNUC__)
#  define FORWARD_STATIC int
# endif

# if defined(_ANSI_) || defined(__STDC__)
#  undef FORWARD_STATIC
#  define FORWARD_STATIC static
# endif

# ifndef FORWARD_STATIC
#  define FORWARD_STATIC extern
# endif
#endif

#ifndef MODULE_STATIC
# define MODULE_STATIC static
#endif

/*
 * define this to use the __classes list for initialization
 * instead of searching for classes;
 * effect: faster initialization
 */
#define INIT_CLASS_LIST

#ifndef INIT_CLASS_LIST
 /*
  * if you run into deep trouble with any of
  * FORWARD_STATIC, NO_CAST_IN_INITIALIZER or  STATIC_DATA_IS_LINEAR
  * you can also turn the whole mess off with:
  */
# if defined(compilerWhichMakesTrouble) || defined(microsoft)
#  define NO_MODULE_CHAINING
# endif
#endif

#ifdef UPDATE_WHOLE_STACK
/*
 * assume that if we ever implement UPDATE_WHOLE_STACK,
 * we dont care for what the compiler does
 */
# define VOLATILE       /* as nothing */
#else
/*
 * heavily optimizing compilers might move automatics and/or arguments
 * into registers - which we don't want here since gc moves them around
 * - hope your compiler has volatile keyword for that ...
 */
# ifdef COMPILER_DOES_NOT_SUPPORT_VOLATILE
#  define VOLATILE      /* as nothing */
# else
#  define VOLATILE      volatile
# endif
#endif

#  define __MARG_VOLATILE__ volatile

/*
 * define this, if your linker has an -A option (incremental linking)
 */
#if defined(ultrix) && defined(__mips__)
# define CAN_LINK_INCREMENTAL
#endif

#if defined(dynix) && defined(__i386__)
# define CAN_LINK_INCREMENTAL
#endif

#if defined(sunos) && defined(__i386__)
# define CAN_LINK_INCREMENTAL
#endif

#if defined(sunos) && defined(__sparc__)
# define CAN_LINK_INCREMENTAL
#endif

#if defined(LINUX)
# define CAN_LINK_INCREMENTAL
#endif

/*
 * define this, if you need separate I&D spaces
 */
/* #define NEED_SEPARATE_ID */

/*
 * define this, if you can execute code in data-space
 */
#if defined(ultrix) || defined(sco) || defined(sinix) || defined(dynix)
# define CAN_USE_DATA_FOR_TEXT
#endif

#if defined(sunos)
# define CAN_USE_DATA_FOR_TEXT
#endif

#if defined(NeXT) && defined(mc68k)
# define CAN_USE_DATA_FOR_TEXT
#endif

#if defined(LINUX)
# define CAN_USE_DATA_FOR_TEXT
#endif

/*
 * defines passed on for compilation
 * (see libbasic/Compiler.st for its use)
 */
#ifndef CPU_DEFINE
# define CPU_DEFINE "-DunknownCPU"
#endif

#ifndef OS_DEFINE

# ifdef ultrix
#  define OS_DEFINE "-Dultrix"
# endif

# ifdef sinix
#  ifdef BSD
#   define OS_DEFINE "-Dsinix -DBSD"
#  else
#   define OS_DEFINE "-Dsinix -DATT"
#  endif
# endif

# ifdef dynix
#  ifdef BSD
#   define OS_DEFINE "-Ddynix -DBSD"
#  else
#   define OS_DEFINE "-Ddynix -DATT"
#  endif
# endif

# ifdef sco
#  ifdef sco2_3
#   define OS_DEFINE "-Dsco2_3"
#  else
#   ifdef sco3_2
#    define OS_DEFINE "-Dsco3_2"
#   else
#    define OS_DEFINE "-Dsco"
#   endif
#  endif
# endif

# ifdef PCS
#  define OS_DEFINE "-DPCS"
# endif

# ifdef MVS
#  define OS_DEFINE "-DMVS"
# endif

# ifdef OS2
#  define OS_DEFINE "-DOS2"
# endif

# ifdef MSWIN
#  define OS_DEFINE "-DMSWIN"
# endif

# ifdef __linux__
#  define OS_DEFINE "-D__linux__"
# endif

# ifndef OS_DEFINE
#  define OS_DEFINE "-DunknownOS"
# endif
#endif

/*
 * ####################### configuration ###########################
 */
/*
 * do we want a method cache - YES
 *
 * EFFECT -> runs much slower if undefined
 * (should only be undefd for debugging/statistics)
 */
#define METHOD_CACHE
#define BIG_CACHE

/*
 * some code alternatives (run autoconf to see if its worth doing it)
 *
 * for strings:
 * define FAST_STRING_MEMSET,           if memset is fastest
 * define FAST_STRING_MEMSET_UNROLLED,  if inline-loop is fastest
 *
 * for avg size objects:
 * define FAST_OBJECT_MEMSET,                  if memset is fastest
 * define FAST_OBJECT_MEMSET_WORDS_UNROLLED    if an unrolled loop using longs is fastest
 * define FAST_OBJECT_MEMSET_DOUBLES_UNROLLED  if an unrolled loop using doubles is fastest
 * define FAST_OBJECT_MEMSET_LONGLONG_UNROLLED if an unrolled loop using longlong is fastest
 *
 * for large objects:
 * define FAST_ARRAY_MEMSET,                  if memset is fastest
 * define FAST_ARRAY_MEMSET_WORDS_UNROLLED    if an unrolled loop using longs is fastest
 * define FAST_ARRAY_MEMSET_DOUBLES_UNROLLED  if an unrolled loop using doubles is fastest
 * define FAST_ARRAY_MEMSET_LONGLONG_UNROLLED if an unrolled loop using longlong is fastest
 *
 * define FAST_MEMCPY,       if memcpy-ing is faster than inline-word-loop
 * define FAST_MEMCHR,       if memchr is faster than inline-search
 *
 * EFFECT -> do not expect too much :-)
 * can usually be left unspecified, if in doubt
 * (system will use inline code for small objects, memXXX for large ones)
 */
#ifndef LINUX /* already in linuxIntern */
# ifdef i386
#  if defined(__GNUC__)
#   define FAST_MEMCPY4
#  endif
#  define FAST_STRING_MEMSET
#  define FAST_OBJECT_MEMSET4
#  define FAST_ARRAY_MEMSET4
#  define FAST_MEMCHR
# endif
#endif

#ifdef sco
# define bcopy(src, dst, size)  memcpy(dst, src, size)
#endif

#ifdef __transputer__
# define FAST_MEMCPY
# define bcopy(src, dst, size)  memcpy(dst, src, size)
#endif

#ifdef PCS
# define FAST_MEMSET
# define FAST_MEMCHR
#endif

#if defined(delta88)
# define FAST_MEMSET
# define FAST_MEMSET_WORDS
#endif

#ifdef __sparc__
# undef FAST_MEMSET
# undef FAST_MEMSET_WORDS
# define FAST_MEMSET_UNROLLED
# define FAST_MEMSET_WORDS_UNROLLED
# define FAST_ARRAY_MEMSET_LONGLONG_UNROLLED
# define FAST_MEMCHR
#endif

#ifdef solaris
# define bcopy(src, dst, size)  memcpy(dst, src, size)
# define bzero(dst, count)      memset(dst, 0, count)
#endif

/*
 * some machines do not have strchr, bcopy etc
 */
#ifdef SOME_MACHINE
# define strchr                 index
# define bcopy(src, dst, size)  memcpy(dst, src, size)
# define memset                 .....
#endif

/*
 * if you have a stupid c-compiler, which does no cse (! GNU),
 * you probably want to have heavily used variables in registers;
 * those should define REGISTER as register - others leave it.
 */
#ifndef __GNUC__
# define REGISTER   register
#else
# define REGISTER   /* as nothing */
#endif

/*
 * there should be no need to change this (very kludgy !)
 * see (librun/init.c for its use)
 */
#define MAGIC1          0x01234567
#define MAGIC2          0xAFFEABCD
#define MAGIC3          MAGIC1
#define MAGIC4          MAGIC2

#define __CODE_MAGIC__  0xFEEDBEEF
#define __CODE_RMAGIC__ 0xBEEFFEED

#define MTHD_NORMAL     0
#define MTHD_PROTECTED  1
#define MTHD_PRIVATE    2
#define MTHD_IGNORED    3

#ifndef __ASSEMBLER__

/*
 * some optimized functions
 * can all be left as is - performance win is not spectacular
 */
# ifdef SOME_MACHINE
   /*
    * you may define an assembler function for bcopy-ing blocks of long words
    */
   extern asm_bcopy4();
   extern asm_memset4();
#  define bcopy4(src,dst,sz)     asm_bcopy4(src,dst,sz)
#  define memset4(dst,val,sz)    asm_memset4(dst,val,sz)
# endif

/*
 * most machines provide more info in case of a signal
 * than is defined in posix - make use of that info if
 * possible ...
 */
# if defined(__mc68k__) && defined(NeXT)
#  define SIGARGS        sigNo, sigType, sigContext
#  define SIGARGS_DECL   struct sigcontext *sigContext;
#  define SIGARG_SIGNO   sigNo
# endif

# if defined(LINUX)
#  undef SIGARGS
#  undef SIGARGS_DECL
#  undef SIGARG_SIGNO
  /*
   * the stuff below ought to be the args; but they are not ...
   */
#  ifdef NOT_TRUE
#   define SIGARGS        sigNo, sigCode, sigContext
#   define SIGARGS_DECL   struct sigcontext *sigContext;
#  else
#   ifdef __i386__
    /*
     * what we really get is:
     * (at least with 1.2 kernel)
     */
#    define SIGARGS       sigNo, gs, fs, es, ds, edi, esi, ebp, esp, ebx, edx, ecx, eax, trapno, err, eip, cs, eflags, esp_at_signal, ss, i387, oldMask, cr2
#    define SIGARGS_DECL  /* nothing */
#   else
#    define SIGARGS       sigNo
#    define SIGARGS_DECL  int sigNo;
#   endif
#  endif /* NOT_TRUE */
#  define SIGARG_SIGNO   sigNo
# endif /* LINUX */

# if defined(__sparc__) && defined(sunos)
#  define SIGARGS        sigNo, sigCode, sigContext
#  define SIGARGS_DECL   struct sigcontext *sigContext;
# endif /* __sparc__ + sunos */

# if defined(realIX) && defined(mc88k)
#  define SIGARGS        sigNo, reserved, evtInfo
#  define SIGARGS_DECL
#  define SIG_PC_VALID   2       /* see 88k handbook pg 6-12 */
# endif /* realIX */

# if defined(aix)
#  define SIGARGS        sigNo, sigCode, sigContext
#  define SIGARGS_DECL   struct sigcontext *sigContext;
# endif /* aix */

# if defined(hpux)
#  undef SIGARGS
#  undef SIGARGS_DECL
#  if defined(hpux10) || defined(hpux11)
#   define HAS_SIGINFO
#   define SIGARGS         sigNo, sigInfo, uContext
#   define SIGARGS_DECL    siginfo_t *sigInfo; ucontext_t *uContext;
#  else
#   define SIGARGS        sigNo, sigCode, sigContext
#   define SIGARGS_DECL   struct sigcontext *sigContext;
#  endif
# endif /* hpux */

# ifdef WIN32
#  define SIGARGS        sigNo, sigContext
#  define SIGARGS_DECL   int sigNo; CONTEXT *sigContext;
#  define SIGARG_SIGNO   sigNo
# endif

# ifndef SIGARGS
#  define SIGARGS        sigNo
#  define SIGARGS_DECL   int sigNo;
#  define SIGARG_SIGNO   sigNo
# endif

/*
 * block move macros - make some things slightly faster (but not much)
 */
# ifndef MOVE4LONGS
#  define MOVE4LONGS(src, dst)                                \
      *dst = *src;                                            \
      *(dst+1) = *(src+1);                                    \
      *(dst+2) = *(src+2);                                    \
      *(dst+3) = *(src+3);
# endif

# ifndef __CONT__
#  define __CONT__ /* nothing */
# endif

/*
 * stack probing
 */
# if defined(STACK_GROWS_UPWARD)
#  define __LT__    >
#  define __MINUS__ +
#  define __LIMIT__     __stackTop__
#  define __ON_C__      ((char *)-1)
# else
#  define __LT__    <
#  define __MINUS__ -
#  define __LIMIT__     __stackBottom__
#  define __ON_C__      ((char *)0)
# endif

extern char *__LIMIT__;

# if defined(__getStack__)

#  define __PROBE__(f, arg)                                    \
	if ((char *)__getStack__() __LT__ (char *)__LIMIT__) \
	    return (OBJ)__STACK_HANDLER__(f, &(arg));

#  define __PROBE_N__(f, arg, n)                                     \
	if (((char *)__getStack__()-(n)) __LT__ (char *)__LIMIT__) \
	    return (OBJ)__STACK_HANDLER_N__(f, &(arg), n);

# endif /* __getStack__ */

/*
 * for stack machines (use addr of 1st arg)
 */
# if defined(TRADITIONAL_STACK_FRAME)
#   ifndef __PROBE__
#    define __PROBE__(f, arg)                          \
	if ((char *)(&(arg)) __LT__ (char *)__LIMIT__) \
	    return (OBJ)__STACK_HANDLER__(f, &(arg));
#   endif

#   ifndef __PROBE_N__
#    define __PROBE_N__(f, arg,n)                                       \
	if (((char *)(&(arg))__MINUS__(n)) __LT__ (char *)__LIMIT__)    \
	    return (OBJ)__STACK_HANDLER_N__(f, &(arg), n);
#   endif


# else /* generic (checking on context) for non-stack machines */
#  define __GENERIC_PROBE__
# endif

#  ifndef __PROBE_U__
#   define __PROBE_U__(f, arg)                        \
	if (__LIMIT__ != __ON_C__)                     \
	    return (OBJ)__STACK_HANDLER_U__(f, &(arg));
#  endif

#  ifndef __PROBE_NN__
#   define __PROBE_NN__(f,arg,n)        __PROBE_N__(f,arg,n)
#  endif

#endif /* __ASSEMBLER__ */

/*
 * stupid
 */
#ifndef N_TAG_BITS
# define N_TAG_BITS 1
#endif

#define _MAX_INT16       (INT)(0x7FFF)
#define _MIN_INT16       (INT)(- _MAX_INT16 - 1)
#define _MAX_INT32       (INT)(0x7FFFFFFFL)
#define _MIN_INT32       (INT)(- _MAX_INT32 - 1)

#if N_TAG_BITS != 1
# error "unhandled tag bits"
#endif

#if (__POINTER_SIZE__ == 8)
// # define _MAX_INT       (INT)(((INT)0x7FFFFFFFFFFFFFFFLL) >> (N_TAG_BITS))
# define _MAX_INT       ((INT)0x3FFFFFFFFFFFFFFFLL)
// # define _MIN_INT       (INT)(- _MAX_INT - 1)
# define _MIN_INT       ((INT)-0x4000000000000000LL)
// # define N_INT_BITS     (64 - N_TAG_BITS)
# define N_INT_BITS     63
# define HW_SIGN_BIT    0x8000000000000000LL
# define HW_HALF_MASK   0xFFFFFFFFLL
# define HW_HALF_NBITS  32
#else
// # define _MAX_INT       (INT)(0x7FFFFFFF >> (N_TAG_BITS))
# define _MAX_INT       ((INT)0x3FFFFFFFL)
// # define _MIN_INT       (INT)(- _MAX_INT - 1)
# define _MIN_INT       ((INT)-0x40000000L)
// # define N_INT_BITS     (32 - N_TAG_BITS)
# define N_INT_BITS     31
# define HW_SIGN_BIT    0x80000000
# define HW_HALF_MASK   0xFFFF
# define HW_HALF_NBITS  16
#endif

#if 0
/* computes _intVal(ep) * 2 */
#ifdef POSITIVE_ADDRESSES
# if N_TAG_BITS == 1
#  define __smallIntegerVal2(i)         ((INT)(i) << 1)
# endif
#else
# if N_TAG_BITS == 1
#  if TAG_INT==1
#   define __smallIntegerVal2(i)         ((INT)(i) & ~TAG_INT)
#  else
#   if TAG_INT==0
#    define __smallIntegerVal2(i)        ((INT)(i))
#   endif
#  endif
# endif
#endif
#ifdef __smallIntegerVal2
# define _intVal2(i)         __smallIntegerVal2(i)
#endif
#endif


/* Define void DTrace/SystemTap probe macros if not defined */
#if defined(HAS_SYSTEMTAP) && !defined(FORCE_NO_SYSTEMTAP)
#  ifndef DTRACE_PROBE
#    error "HAS_SYSTEMTAP defined but no DTRACE_PROBE? macros!"
#  endif
#endif

#if defined(HAS_DTRACE) && !defined(FORCE_NO_DTRACE)
#  ifndef DTRACE_PROBE
#    error "HAS_DTRACE defined but no DTRACE_PROBE? macros!"
#  endif
#endif


#ifndef DTRACE_PROBE
# define DTRACE_PROBE(provider,probe)
#endif
#ifndef DTRACE_PROBE1
# define DTRACE_PROBE1(provider,probe,parm1)
#endif
#ifndef DTRACE_PROBE2
# define DTRACE_PROBE2(provider,probe,parm1,parm2)
#endif
#ifndef DTRACE_PROBE3
# define DTRACE_PROBE3(provider,probe,parm1,parm2,parm3)
#endif
#ifndef DTRACE_PROBE4
# define DTRACE_PROBE4(provider,probe,parm1,parm2,parm3,parm4)
#endif
#ifndef DTRACE_PROBE5
# define DTRACE_PROBE5(provider,probe,parm1,parm2,parm3,parm4,parm5)
#endif
#ifndef DTRACE_PROBE6
# define DTRACE_PROBE6(provider,probe,parm1,parm2,parm3,parm4,parm5,parm6)
#endif
#ifndef DTRACE_PROBE7
# define DTRACE_PROBE7(provider,probe,parm1,parm2,parm3,parm4,parm5,parm6,parm7)
#endif
#ifndef DTRACE_PROBE8
# define DTRACE_PROBE8(provider,probe,parm1,parm2,parm3,parm4,parm5,parm6,parm7,parm8)
#endif
#ifndef DTRACE_PROBE9
# define DTRACE_PROBE9(provider,probe,parm1,parm2,parm3,parm4,parm5,parm6,parm7,parm8,parm9)
#endif
#ifndef DTRACE_PROBE10
# define DTRACE_PROBE10(provider,probe,parm1,parm2,parm3,parm4,parm5,parm6,parm7,parm8,parm9,parm10)
#endif
#ifndef DTRACE_PROBE11
# define DTRACE_PROBE11(provider,probe,parm1,parm2,parm3,parm4,parm5,parm6,parm7,parm8,parm9,parm10,parm11)
#endif
#ifndef DTRACE_PROBE12
# define DTRACE_PROBE12(provider,probe,parm1,parm2,parm3,parm4,parm5,parm6,parm7,parm8,parm9,parm10,parm11,parm12)
#endif

#endif /* __STCINTERN_H__ */
