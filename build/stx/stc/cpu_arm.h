/*
 * $Header: /cvs/stx/stx/stc/cpu_arm.h,v 1.3 2007/01/17 18:53:31 cg Exp $
 */

/*
 * COPYRIGHT (c) 2007 by Claus Gittinger
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

#ifndef __CPU_ARM_H__
# define __CPU_ARM_H__

# define __CPU__ARMV6__     60
# define __CPU__ARMV7__     70
# define __CPU__ARMV8__     80
# define __CPU__ARMV9__     90
# define __DEFAULT_CPU__    __CPU__ARMV6__

# ifdef __armv6l__
#  define CPU_DEFINE "-D__arm__ -D__armv6l__"
#  define __LSBFIRST__
# else
#  ifdef __armv6h__
#   define CPU_DEFINE "-D__arm__ -D__armv6h__"
#   define __MSBFIRST__
#  else
#  define CPU_DEFINE "-D__arm__"
#  endif
# endif

# define __CPU__ARMV6__         60
# define __CPU__ARMV7__         70
# define __CPU__ARMV8__         80
# define __CPU__ARMV9__         90

# define SIGNED_SHIFTS

# if !defined(__LSBFIRST__) && !defined(__MSBFIRST__)
#  define __LSBFIRST__
# endif

# define ARG_ORDER_REVERSE
# define EASY_VAR_ARGS

# if defined(__GNUC__)
#  define __switchStack__(sp) \
	asm volatile ("mov %%sp, %0" : /* no output */ : "r" (sp) );
# endif /* GNUC */

#endif /* __CPU_ARM_H__ */
