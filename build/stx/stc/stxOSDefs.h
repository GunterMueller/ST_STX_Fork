/*
 * COPYRIGHT (c) 2003 by eXept Software AG
 *              All Rights Reserved
 *
 * This software is furnished under a license and may be used
 * only in accordance with the terms of that license and with the
 * inclusion of the above copyright notice.   This software may not
 * be provided or otherwise made available to, or used by, any
 * other person.  No title to or ownership of the software is
 * hereby transferred.
 *
 * $Header$
 *
 * These used to be located in UnixOperatingSystem.st as primitive definitions;
 * now, they are included, as most of it is to be shared with other OS's.
 */

#ifndef __STX_OSDEFS_H
# define __STX_OSDEFS_H

# if defined(__osx__) || defined(__MINGW__) || defined(LINUX) || defined(__LINUX__)
#  ifndef _STDIO_H_INCLUDED_
#   include <stdio.h>
#   define _STDIO_H_INCLUDED_
#  endif
# endif

# if defined(__osx__) || defined(__MINGW__) || defined(LINUX) || defined(__LINUX__)
#  ifndef _STRING_H_INCLUDED_
#   include <string.h>
#   define _STRING_H_INCLUDED_
#  endif
# endif

# if defined(__osx__) || defined(__MINGW__) || defined(LINUX) || defined(__LINUX__)
#  ifndef _UNISTD_H_INCLUDED_
#   include <unistd.h>
#   define _UNISTD_H_INCLUDED_
#  endif
# endif

# if defined(__osx__) || defined(__MINGW__) || defined(LINUX) || defined(__LINUX__)
#  ifndef _STDLIB_H_INCLUDED_
#   include <stdlib.h>
#   define _STDLIB_H_INCLUDED_
#  endif
# endif

# ifdef LINUX
#  define BUGGY_STDIO_LIB
#  include <linux/version.h>

#  ifndef KERNEL_VERSION
#   define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
#  endif
# endif /* LINUX */

# define UNIX_LIKE

# if defined(__win32__) || defined(__VMS__) || defined(__transputer__)
#  undef UNIX_LIKE
# endif

/*
 * Sound support
 */
# if defined(__transputer__)
#  ifndef NO_SOUND
#   define NO_SOUND
#  endif
# endif

# if defined(__TCC__)
   /* sigh: cannot compile SoundStream.st, yet */
#  ifndef NO_SOUND
#   define NO_SOUND
#  endif
# endif

/*
 * Socket support
 */
# if defined(transputer)
#  ifndef NO_SOCKET
#   define NO_SOCKET
#  endif
# endif

# if defined(__TCC__)
   /* sigh: cannot compile Socket.st */
#  ifndef NO_SOCKET
#   define NO_SOCKET
#  endif
# endif

# ifdef __VMS__
#  define WANT__AF_INET
#  define WANT__AF_DECnet
# endif

# ifdef __win32__
#  define WANT__AF_INET
#  define WANT__AF_INET6
# endif

# ifdef UNIX_LIKE
#  define WANT__AF_INET
#  define WANT__AF_UNIX
#  define WANT__NETDB_DOT_H
# endif

# ifdef LINUX
#  ifndef LINUX_VERSION_CODE
   /* PRE 2.0 Linux kernel. */
#  else
#   if LINUX_VERSION_CODE < KERNEL_VERSION(2,0,0)
   /* PRE 2.0 Linux kernel. */
#   else
#    define WANT__TCP_DOT_H
#    if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,0)
#     define WANT__AF_APPLETALK
#     define xxWANT__AF_X25
#     define xxWANT__AF_AX25
#     define xxWANT__AF_IPX
#     define WANT__AF_INET6
#     if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
#      define xxWANT__AF_IRDA
#     endif /* >= 2.2.0 */
#    endif /* >= 2.1.0 */
#   endif /* pre 2.0.0 */
#  endif /* pre 2.0.0 */
# endif /* LINIX */

# ifdef __osx__
#  define WANT__TCP_DOT_H
#  define WANT__AF_INET6
# endif

# ifdef solaris2_0
#  include <unistd.h>
#  include <sys/socket.h>
#  include <sys/sockio.h>
#  include <net/if.h>
# endif

# ifdef hpux
#  include <unistd.h>
#  include <sys/time.h>
#  include <sys/socket.h>
#  include <net/if.h>
# endif

//
// could not get it to compile without this hack
//
# if defined( __arm__ ) && defined(LINUX)

#  define __need_timespec
#  include <time.h>
#  include <sys/time.h>

//
// linux/gnu is messing up those include files more and more...
//
#  ifndef __timespec_defined
struct timespec
  {
    __time_t tv_sec;            /* Seconds.  */
    long int tv_nsec;           /* Nanoseconds.  */
  };
#  endif
# endif /* __arm__ */

# ifndef __win32__
#  ifndef _FCNTL_H_INCLUDED_
#   include <fcntl.h>
#   define _FCNTL_H_INCLUDED_
#  endif

#  ifndef _SYS_TYPES_H_INCLUDED_
#   include <sys/types.h>
#   define _SYS_TYPES_H_INCLUDED_
#  endif

#  ifdef NEED_SYS_TIME_H
#   ifndef _SYS_TIME_H_INCLUDED_
#    include <sys/time.h>
#    define _SYS_TIME_H_INCLUDED_
#   endif
#  endif

#  ifdef NEED_TIME_H
#   ifndef _TIME_H_INCLUDED_
#    include <time.h>
#    define _TIME_H_INCLUDED_
#   endif
#  endif
# endif

# if defined(IRIS) && !defined(IRIX5)
   /* no socket.h on 4.0.5h ?!?!? */
# else
#  ifdef __win32__

#   undef Array
#   undef Number
#   undef Method
#   undef Point
#   undef Rectangle
#   undef Block
#   undef String
#   undef Character
#   undef Message
#   undef Object
#   undef Context
#   undef Time
#   undef Date
#   undef Set
#   undef Signal
#   undef Delay
#   undef NameSpace
#   undef Process
#   undef Processor
#   undef INT
#   undef UINT

#   if !defined(__BORLANDC__)
#    ifndef MAXFILELEN
#     define MAXFILELEN 256
#    endif
#   endif

#   ifdef __VISUALC__
#    define _WIN32_DCOM
#    define NO_GDI
// must be included before
#    include <WINSOCK2.H>
#    include <windows.h>

#   else

#    ifdef __MINGW__
      // must be included before windows.h
#     include <WINSOCK2.H>
#    endif

#    define NO_GDI
#    include <windows.h>

#    ifndef __MINGW__
#     include <WINSOCK2.H>
#    endif
#   endif

#  else /* not WIN32 */
#   include <sys/socket.h>
#  endif
# endif

# if defined( NEXT3 ) || defined( __next3__ )
#  include <netinet/in_systm.h>
# endif

# ifdef WANT__AF_UNIX
/* no socket.h on IRIS 4.0.5h ?!?!? */
#  ifndef AF_UNIX
#   define AF_UNIX 1
#  endif
# endif

# ifdef WANT__AF_INET
#  ifndef AF_INET
#   define AF_INET 2
#  endif
# endif

# ifndef SOCK_STREAM
#  define SOCK_STREAM 1
# endif
# ifndef SOCK_DGRAM
#  define SOCK_DGRAM  2
# endif
# ifndef SOCK_RAW
#  define SOCK_RAW    3
# endif

/*
 * include what is needed
 */
# ifdef WANT__AF_UNIX
#  ifdef UNIX_LIKE
#   include <sys/un.h>
#  endif
# endif

# ifdef WANT__AF_INET
#  ifdef UNIX_LIKE
#   include <netinet/in.h>
#  endif
# endif

# ifdef WANT__AF_INET6
#  if defined(LINUX)
#   include <netinet/in.h>
#  elif defined(__osx__)
#    include <netinet/in.h>
#  elif defined(UNIX_LIKE)
#    include <netinet/in6.h>
#  elif defined(__win32__)
#    include <Ws2TcpIp.h>
#  endif
# endif

# ifdef WANT__AF_APPLETALK
#  ifdef LINUX
#   include <asm/types.h>
#   include <linux/atalk.h>
#  else
#   ifdef UNIX_LIKE
#    include <netinet/atalk.h>
#   endif
#  endif
# endif

# ifdef WANT__AF_DECNET
#  ifdef solaris2_0
#   include <X11/dni8.h>
#  endif
# endif

# ifdef WANT__AF_X25
#  ifdef LINUX
#   include <linux/x25.h>
#  endif
# endif

# ifdef WANT__AF_AX25
#  ifdef LINUX
#   include <linux/ax25.h>
#  endif
# endif

# ifdef WANT__AF_IPX
#  ifdef LINUX
#   include <linux/ipx.h>
#  else
#   ifdef __win32__
#    include <wsipx.h>
#   endif
#  endif
# endif

# ifdef WANT__AF_NETBIOS
#  ifdef __win32__
#   include <wsnetbs.h>
#  endif
# endif

# ifdef WANT__AF_ATM
#  ifdef __win32__
#   include <ws2atm.h>
#  endif
# endif

# if defined(WANT__AF_ATMPVC) || defined(WANT__AF_ATMSVC)
#  ifdef LINUX
#   include <linux/atm.h>
#  endif
# endif

# ifdef WANT__AF_BAN
#  ifdef __win32__
#   include <wsvns.h>
#  endif
# endif

# ifdef WANT__AF_VOICEVIEW
#  ifdef __win32__
#   include <wsvv.h>
#  endif
# endif

# ifdef WANT__AF_IRDA
#  ifdef LINUX
#   include <linux/irda.h>
#  endif
# endif

# ifdef __win32__
#  ifdef __DEF_Array
#   define Array __DEF_Array
#  endif
#  ifdef __DEF_Number
#   define Number __DEF_Number
#  endif
#  ifdef __DEF_Method
#   define Method __DEF_Method
#  endif
#  ifdef __DEF_Point
#   define Point __DEF_Point
#  endif
#  ifdef __DEF_Rectangle
#   define Rectangle __DEF_Rectangle
#  endif
#  ifdef __DEF_Block
#   define Block __DEF_Block
#  endif
#  ifdef __DEF_String
#   define String __DEF_String
#  endif
#  ifdef __DEF_Character
#   define Character __DEF_Character
#  endif
#  ifdef __DEF_Message
#   define Message __DEF_Message
#  endif
#  ifdef __DEF_Object
#   define Object __DEF_Object
#  endif
#  ifdef __DEF_Context
#   define Context __DEF_Context
#  endif
#  ifdef __DEF_Date
#   define Date __DEF_Date
#  endif
#  ifdef __DEF_Time
#   define Time __DEF_Time
#  endif
#  ifdef __DEF_Set
#   define Set __DEF_Set
#  endif
#  ifdef __DEF_Signal
#   define Signal __DEF_Signal
#  endif
#  ifdef __DEF_Delay
#   define Delay __DEF_Delay
#  endif
#  ifdef __DEF_NameSpace
#   define NameSpace __DEF_NameSpace
#  endif
#  ifdef __DEF_Process
#   define Process __DEF_Process
#  endif
#  ifdef __DEF_Processor
#   define Processor __DEF_Processor
#  endif

#  define INT STX_INT
#  define UINT STX_UINT
# endif

/*
 * see what is leftOver
 */
union sockaddr_u {
# ifdef WANT__AF_UNIX
	struct sockaddr_un un;
# endif
# ifdef WANT__AF_INET
	struct sockaddr_in in;
# endif
# ifdef WANT__AF_INET6
	struct sockaddr_in6 in6;
# endif
# ifdef WANT__AF_APPLETALK
	struct sockaddr_at at;
# endif
# ifdef WANT__AF_DECNET
	struct sockaddr_dn dn;
# endif
# ifdef WANT__AF_X25
	struct sockaddr_x25 x25;
# endif
# ifdef WANT__AF_AX25
	struct sockaddr_ax25 ax25;
# endif
# ifdef WANT__AF_IPX
	struct sockaddr_ipx ipx;
# endif
# ifdef WANT__AF_NETBIOS
	struct sockaddr_nb nb;
# endif
# ifdef WANT__AF_ATM
	struct sockaddr_atm atm;
# endif
# ifdef WANT__AF_BAN
	struct sockaddr_vns vns;
# endif
# ifdef WANT__AF_VOICEVIEW
	struct sockaddr_vv vv;
# endif
# ifdef WANT__AF_IRDA
	struct sockaddr_irda irda;
# endif
# ifdef WANT__AF_PACKET
	struct sockaddr_ll ll;
# endif
# ifdef WANT__AF_LINK
	struct sockaddr_dl dl;
# endif

# ifdef WANT__AF_NETBEUI
	add definition here
# endif
# ifdef WANT__AF_NETLINK
	add definition here
# endif
# ifdef WANT__AF_ASH
	add definition here
# endif
# ifdef WANT__AF_ECONET
	add definition here
# endif
# ifdef WANT__AF_IMPLINK
	add definition here
# endif
# ifdef WANT__AF_CHAOS
	add definition here
# endif
# ifdef WANT__AF_DLI
	add definition here
# endif
# ifdef WANT__AF_LAT
	add definition here
# endif
# ifdef WANT__AF_HYLINK
	add definition here
# endif
# ifdef WANT__AF_FIREFOX
	add definition here
# endif
# ifdef WANT__AF_CLUSTER
	add definition here
# endif
# ifdef WANT__AF_12844
	add definition here
# endif
# ifdef WANT__AF_NETDES
	add definition here
# endif
# ifdef WANT__AF_SNA
	add definition here
# endif
# ifdef WANT__AF_ISDN
	add definition here
# endif
# ifdef WANT__AF_PPP
	add definition here
# endif
};

# ifdef __NEED_MALLOC_H__
#  ifdef __osx__
#   include <malloc/malloc.h>
#  else
#   if defined(FREEBSD)
#   else
#    include <malloc.h>
#   endif
#  endif
# endif

# ifdef LINUX
#  ifdef KLUDGE_FOR_GCC_WITHOUT_OPTIMIZER
/*
 * fstat is only defined as inline function in sys/stat.h - however,
 * inlined functions are not inlined with -g option in effect;
 * ought to use #define instead of inline functions there.
 */
#   define fstat(__fd__,__statbuf__) __fxstat(_STAT_VER,__fd__,__statbuf__)
#   define stat(__path__,__statbuf__) __xstat(_STAT_VER,__path__,__statbuf__)
#   define lstat(__path__,__statbuf__) __lxstat(_STAT_VER,__path__,__statbuf__)
#  endif
# endif /* LINUX */

# ifdef DO_WRAP_CALLS

#  define STX_C_CALL0(__nm__, __f__)                                                                    __STX_C_CALL0(__nm__,(void*)__f__)
#  define STX_C_CALL1(__nm__, __f__, __a1__)                                                            __STX_C_CALL1(__nm__,(void*)__f__, (void*)(__a1__))
#  define STX_C_CALL2(__nm__, __f__, __a1__, __a2__)                                                    __STX_C_CALL2(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__))
#  define STX_C_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)                                            __STX_C_CALL3(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__))
#  define STX_C_CALL4(__nm__, __f__, __a1__, __a2__, __a3__, __a4__)                                    __STX_C_CALL4(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a3__))
#  define STX_C_CALL5(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__)                            __STX_C_CALL5(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__))
#  define STX_C_CALL6(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__)                    __STX_C_CALL6(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__), (void*)(__a6__))
#  define STX_C_CALL7(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__)            __STX_C_CALL7(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__), (void*)(__a6__), (void*)(__a7__))
#  define STX_C_CALL8(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__,__a8__)            __STX_C_CALL8(__nm__,__f__, (__a1__), (__a2__),(__a3__),(__a4__),(__a5__),(__a6__),(__a7__),(__a8__))
#  define STX_C_CALL9(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__,__a8__,__a9__)            __STX_C_CALL9(__nm__,__f__, (__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__),(__a8__),(__a9__))
#  define STX_C_CALL10(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__,__a8__,__a9__,__a10__)            __STX_C_CALL10(__nm__,__f__, (__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__),(__a8__),(__a9__),(__a10__))
#  define STX_C_CALL11(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__,__a8__,__a9__,__a10__,__a11__)            __STX_C_CALL11(__nm__,__f__, (__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__),(__a8__),(__a9__),(__a10__),(__a11__))
#  define STX_C_CALL12(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__,__a8__,__a9__,__a10__,__a11__,__a12__)            __STX_C_CALL12(__nm__,__f__, (__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__),(__a8__),(__a9__),(__a10__,(__a11__),(__a12__)))
#  define STX_C_CALL13(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__,__a8__,__a9__,__a10__,__a11__,__a12__,__a13__)            __STX_C_CALL13(__nm__,__f__, (__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__),(__a8__),(__a9__),(__a10__),(__a11__),(__a12__),(__a13__))
#  define STX_C_CALL14(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__,__a8__,__a9__,__a10__,__a11__,__a12__,__a13__,__a14__)            __STX_C_CALL14(__nm__,__f__, (__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__),(__a8__),(__a9__),(__a10__),(__a11__),(__a12__),(__a13__),(__a14__))
#  define STX_C_CALL15(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__,__a8__,__a9__,__a10__,__a11__,__a12__,__a13__,__a14__,__a15__)            __STX_C_CALL15(__nm__,__f__, (__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__),(__a8__),(__a9__),(__a10__),(__a11__),(__a12__),(__a13__),(__a14__),(__a15__))

#  define STX_C_NOINT_CALL0(__nm__, __f__)                                                              __STX_C_NOINT_CALL0(__nm__,(void*)__f__)
#  define STX_C_NOINT_CALL1(__nm__, __f__, __a1__)                                                      __STX_C_NOINT_CALL1(__nm__,(void*)__f__, (void*)(__a1__))
#  define STX_C_NOINT_CALL2(__nm__, __f__, __a1__, __a2__)                                              __STX_C_NOINT_CALL2(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__))
#  define STX_C_NOINT_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)                                      __STX_C_NOINT_CALL3(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__))
#  define STX_C_NOINT_CALL4(__nm__, __f__, __a1__, __a2__, __a3__, __a4__)                              __STX_C_NOINT_CALL4(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a3__))
#  define STX_C_NOINT_CALL5(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__)                      __STX_C_NOINT_CALL5(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__))
#  define STX_C_NOINT_CALL6(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__)              __STX_C_NOINT_CALL6(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__), (void*)(__a6__))
#  define STX_C_NOINT_CALL7(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__)      __STX_C_NOINT_CALL7(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__), (void*)(__a6__), (void*)(__a7__))
#  define STX_C_NOINT_CALL8   __STX_C_NOINT_CALL8
#  define STX_C_NOINT_CALL9   __STX_C_NOINT_CALL9
#  define STX_C_NOINT_CALL10  __STX_C_NOINT_CALL10
#  define STX_C_NOINT_CALL11  __STX_C_NOINT_CALL11
#  define STX_C_NOINT_CALL12  __STX_C_NOINT_CALL12
#  define STX_C_NOINT_CALL13  __STX_C_NOINT_CALL13
#  define STX_C_NOINT_CALL14  __STX_C_NOINT_CALL14
#  define STX_C_NOINT_CALL15  __STX_C_NOINT_CALL15

#  define STX_API_CALL0(__nm__, __f__)                                                                  __STX_API_CALL0(__nm__,(void*)__f__)
#  define STX_API_CALL1(__nm__, __f__, __a1__)                                                          __STX_API_CALL1(__nm__,(void*)__f__, (void*)(__a1__))
#  define STX_API_CALL2(__nm__, __f__, __a1__, __a2__)                                                  __STX_API_CALL2(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__))
#  define STX_API_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)                                          __STX_API_CALL3(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__))
#  define STX_API_CALL4(__nm__, __f__, __a1__, __a2__, __a3__, __a4__)                                  __STX_API_CALL4(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__))
#  define STX_API_CALL5(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__)                          __STX_API_CALL5(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__))
#  define STX_API_CALL6(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__)                  __STX_API_CALL6(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__), (void*)(__a6__))
#  define STX_API_CALL7(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__)          __STX_API_CALL7(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__), (void*)(__a6__), (void*)(__a7__))
#  define STX_API_CALL8   __STX_API_CALL8
#  define STX_API_CALL9   __STX_API_CALL9
#  define STX_API_CALL10  __STX_API_CALL10
#  define STX_API_CALL11  __STX_API_CALL11
#  define STX_API_CALL12  __STX_API_CALL12
#  define STX_API_CALL13  __STX_API_CALL13
#  define STX_API_CALL14  __STX_API_CALL14
#  define STX_API_CALL15  __STX_API_CALL15

#  define STX_API_NOINT_CALL0(__nm__, __f__)                                                            __STX_API_NOINT_CALL0(__nm__,(void*)__f__)
#  define STX_API_NOINT_CALL1(__nm__, __f__, __a1__)                                                    __STX_API_NOINT_CALL1(__nm__,(void*)__f__, (void*)(__a1__))
#  define STX_API_NOINT_CALL2(__nm__, __f__, __a1__, __a2__)                                            __STX_API_NOINT_CALL2(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__))
#  define STX_API_NOINT_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)                                    __STX_API_NOINT_CALL3(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__))
#  define STX_API_NOINT_CALL4(__nm__, __f__, __a1__, __a2__, __a3__, __a4__)                            __STX_API_NOINT_CALL4(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__))
#  define STX_API_NOINT_CALL5(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__)                    __STX_API_NOINT_CALL5(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__))
#  define STX_API_NOINT_CALL6(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__)            __STX_API_NOINT_CALL6(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__), (void*)(__a6__))
#  define STX_API_NOINT_CALL7(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__)    __STX_API_NOINT_CALL7(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__), (void*)(__a6__), (void*)(__a7__))
#  define STX_API_NOINT_CALL8   __STX_API_NOINT_CALL8
#  define STX_API_NOINT_CALL9   __STX_API_NOINT_CALL9
#  define STX_API_NOINT_CALL10  __STX_API_NOINT_CALL10
#  define STX_API_NOINT_CALL11  __STX_API_NOINT_CALL11
#  define STX_API_NOINT_CALL12  __STX_API_NOINT_CALL12
#  define STX_API_NOINT_CALL13  __STX_API_NOINT_CALL13
#  define STX_API_NOINT_CALL14  __STX_API_NOINT_CALL14
#  define STX_API_NOINT_CALL15  __STX_API_NOINT_CALL15

#  define STX_WSA_CALL0(__nm__, __f__)                                                                  __STX_WSA_CALL0(__nm__,(void*)__f__)
#  define STX_WSA_CALL1(__nm__, __f__, __a1__)                                                          __STX_WSA_CALL1(__nm__,(void*)__f__, (void*)(__a1__))
#  define STX_WSA_CALL2(__nm__, __f__, __a1__, __a2__)                                                  __STX_WSA_CALL2(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__))
#  define STX_WSA_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)                                          __STX_WSA_CALL3(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__))
#  define STX_WSA_CALL4(__nm__, __f__, __a1__, __a2__, __a3__, __a4__)                                  __STX_WSA_CALL4(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__))
#  define STX_WSA_CALL5(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__)                          __STX_WSA_CALL5(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__))
#  define STX_WSA_CALL6(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__)                  __STX_WSA_CALL6(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__), (void*)(__a6__))
#  define STX_WSA_CALL7(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__)          __STX_WSA_CALL7(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__), (void*)(__a6__), (void*)(__a7__))

#  define STX_WSA_NOINT_CALL0(__nm__, __f__)                                                            __STX_WSA_NOINT_CALL0(__nm__,(void*)__f__)
#  define STX_WSA_NOINT_CALL1(__nm__, __f__, __a1__)                                                    __STX_WSA_NOINT_CALL1(__nm__,(void*)__f__, (void*)(__a1__))
#  define STX_WSA_NOINT_CALL2(__nm__, __f__, __a1__, __a2__)                                            __STX_WSA_NOINT_CALL2(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__))
#  define STX_WSA_NOINT_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)                                    __STX_WSA_NOINT_CALL3(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__))
#  define STX_WSA_NOINT_CALL4(__nm__, __f__, __a1__, __a2__, __a3__, __a4__)                            __STX_WSA_NOINT_CALL4(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__))
#  define STX_WSA_NOINT_CALL5(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__)                    __STX_WSA_NOINT_CALL5(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__))
#  define STX_WSA_NOINT_CALL6(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__)            __STX_WSA_NOINT_CALL6(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__), (void*)(__a6__))
#  define STX_WSA_NOINT_CALL7(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__)    __STX_WSA_NOINT_CALL7(__nm__,(void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__), (void*)(__a4__), (void*)(__a5__), (void*)(__a6__), (void*)(__a7__))

# else /* no DO_WRAP_CALLS */

#  define STX_C_CALL0(__nm__, __f__)                                                                    __f__()
#  define STX_C_CALL1(__nm__, __f__, __a1__)                                                            __f__((__a1__))
#  define STX_C_CALL2(__nm__, __f__, __a1__, __a2__)                                                    __f__((__a1__), (__a2__))
#  define STX_C_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)                                            __f__((__a1__), (__a2__), (__a3__))
#  define STX_C_CALL4(__nm__, __f__, __a1__, __a2__, __a3__, __a4__)                                    __f__((__a1__), (__a2__), (__a3__), (__a4__))
#  define STX_C_CALL5(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__)                            __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__))
#  define STX_C_CALL6(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__)                    __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__))
#  define STX_C_CALL7(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__)            __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__))
#  define STX_C_CALL8   __STX_C_CALL8
#  define STX_C_CALL9   __STX_C_CALL9
#  define STX_C_CALL10  __STX_C_CALL10
#  define STX_C_CALL11  __STX_C_CALL11
#  define STX_C_CALL12  __STX_C_CALL12
#  define STX_C_CALL13  __STX_C_CALL13
#  define STX_C_CALL14  __STX_C_CALL14
#  define STX_C_CALL15  __STX_C_CALL15

#  define STX_C_NOINT_CALL0(__nm__, __f__)                                                              __f__()
#  define STX_C_NOINT_CALL1(__nm__, __f__, __a1__)                                                      __f__((__a1__))
#  define STX_C_NOINT_CALL2(__nm__, __f__, __a1__, __a2__)                                              __f__((__a1__), (__a2__))
#  define STX_C_NOINT_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)                                      __f__((__a1__), (__a2__), (__a3__))
#  define STX_C_NOINT_CALL4(__nm__, __f__, __a1__, __a2__, __a3__, __a4__)                              __f__((__a1__), (__a2__), (__a3__), (__a4__))
#  define STX_C_NOINT_CALL5(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__)                      __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__))
#  define STX_C_NOINT_CALL6(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__)              __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__))
#  define STX_C_NOINT_CALL7(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__)      __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__))
#  define STX_C_NOINT_CALL8   __STX_C_NOINT_CALL8
#  define STX_C_NOINT_CALL9   __STX_C_NOINT_CALL9
#  define STX_C_NOINT_CALL10  __STX_C_NOINT_CALL10
#  define STX_C_NOINT_CALL11  __STX_C_NOINT_CALL11
#  define STX_C_NOINT_CALL12  __STX_C_NOINT_CALL12
#  define STX_C_NOINT_CALL13  __STX_C_NOINT_CALL13
#  define STX_C_NOINT_CALL14  __STX_C_NOINT_CALL14
#  define STX_C_NOINT_CALL15  __STX_C_NOINT_CALL15

#  define STX_API_CALL0(__nm__, __f__)                                                                  __f__((__a1__))
#  define STX_API_CALL1(__nm__, __f__, __a1__)                                                          __f__((__a1__))
#  define STX_API_CALL2(__nm__, __f__, __a1__, __a2__)                                                  __f__((__a1__), (__a2__))
#  define STX_API_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)                                          __f__((__a1__), (__a2__), (__a3__))
#  define STX_API_CALL4(__nm__, __f__, __a1__, __a2__, __a3__, __a4__)                                  __f__((__a1__), (__a2__), (__a3__), (__a4__))
#  define STX_API_CALL5(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__)                          __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__))
#  define STX_API_CALL6(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__)                  __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__))
#  define STX_API_CALL7(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__)          __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__))
#  define STX_API_CALL8   __STX_API_CALL8
#  define STX_API_CALL9   __STX_API_CALL9
#  define STX_API_CALL10  __STX_API_CALL10
#  define STX_API_CALL11  __STX_API_CALL11
#  define STX_API_CALL12  __STX_API_CALL12
#  define STX_API_CALL13  __STX_API_CALL13
#  define STX_API_CALL14  __STX_API_CALL14
#  define STX_API_CALL15  __STX_API_CALL15

#  define STX_API_NOINT_CALL0(__nm__, __f__)                                                            __f__((__a1__))
#  define STX_API_NOINT_CALL1(__nm__, __f__, __a1__)                                                    __f__((__a1__))
#  define STX_API_NOINT_CALL2(__nm__, __f__, __a1__, __a2__)                                            __f__((__a1__), (__a2__))
#  define STX_API_NOINT_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)                                    __f__((__a1__), (__a2__), (__a3__))
#  define STX_API_NOINT_CALL4(__nm__, __f__, __a1__, __a2__, __a3__, __a4__)                            __f__((__a1__), (__a2__), (__a3__), (__a4__))
#  define STX_API_NOINT_CALL5(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__)                    __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__))
#  define STX_API_NOINT_CALL6(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__)            __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__))
#  define STX_API_NOINT_CALL7(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__)    __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__))
#  define STX_API_NOINT_CALL8   __STX_API_NOINT_CALL8
#  define STX_API_NOINT_CALL9   __STX_API_NOINT_CALL9
#  define STX_API_NOINT_CALL10  __STX_API_NOINT_CALL10
#  define STX_API_NOINT_CALL11  __STX_API_NOINT_CALL11
#  define STX_API_NOINT_CALL12  __STX_API_NOINT_CALL12
#  define STX_API_NOINT_CALL13  __STX_API_NOINT_CALL13
#  define STX_API_NOINT_CALL14  __STX_API_NOINT_CALL14
#  define STX_API_NOINT_CALL15  __STX_API_NOINT_CALL15

#  define STX_WSA_CALL0(__nm__, __f__)                                                                  __f__((__a1__))
#  define STX_WSA_CALL1(__nm__, __f__, __a1__)                                                          __f__((__a1__))
#  define STX_WSA_CALL2(__nm__, __f__, __a1__, __a2__)                                                  __f__((__a1__), (__a2__))
#  define STX_WSA_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)                                          __f__((__a1__), (__a2__), (__a3__))
#  define STX_WSA_CALL4(__nm__, __f__, __a1__, __a2__, __a3__, __a4__)                                  __f__((__a1__), (__a2__), (__a3__), (__a4__))
#  define STX_WSA_CALL5(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__)                          __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__))
#  define STX_WSA_CALL6(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__)                  __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__))
#  define STX_WSA_CALL7(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__)          __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__))

#  define STX_WSA_NOINT_CALL0(__nm__, __f__)                                                            __f__((__a1__))
#  define STX_WSA_NOINT_CALL1(__nm__, __f__, __a1__)                                                    __f__((__a1__))
#  define STX_WSA_NOINT_CALL2(__nm__, __f__, __a1__, __a2__)                                            __f__((__a1__), (__a2__))
#  define STX_WSA_NOINT_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)                                    __f__((__a1__), (__a2__), (__a3__))
#  define STX_WSA_NOINT_CALL4(__nm__, __f__, __a1__, __a2__, __a3__, __a4__)                            __f__((__a1__), (__a2__), (__a3__), (__a4__))
#  define STX_WSA_NOINT_CALL5(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__)                    __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__))
#  define STX_WSA_NOINT_CALL6(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__)            __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__))
#  define STX_WSA_NOINT_CALL7(__nm__, __f__, __a1__, __a2__, __a3__, __a4__, __a5__, __a6__, __a7__)    __f__((__a1__), (__a2__), (__a3__), (__a4__), (__a5__), (__a6__), (__a7__))

# endif /* no DO_WRAP_CALLS */

/*
 * posix systems should define these ...
 * but on some (older) systems, they are not.
 */
# ifndef S_IXUSR
#  ifdef S_IEXEC
#   define S_IXUSR S_IEXEC
#   define S_IXGRP (S_IEXEC>>3)
#   define S_IXOTH (S_IEXEC>>6)
#  endif
# endif

# ifndef S_IXUSR
#  define S_IXUSR 0100
#  define S_IXGRP 0010
#  define S_IXOTH 0001
# endif

# ifndef S_IRUSR
#  define S_IRUSR 0400
#  define S_IRGRP 0040
#  define S_IROTH 0004
# endif

# ifndef S_IWUSR
#  define S_IWUSR 0200
#  define S_IWGRP 0020
#  define S_IWOTH 0002
# endif

# ifndef MAXPATHLEN
#  ifdef __win32__
#   define xxxMAXPATHLEN MAXPATH
#   define MAXPATHLEN 1024
#  endif
# endif

#endif /* __STX_OSDEFS_H */
