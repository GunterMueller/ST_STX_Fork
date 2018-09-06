"
 COPYRIGHT (c) 2004 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

OSHandle subclass:#Win32Handle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Windows'
!

!Win32Handle primitiveDefinitions!
%{

#include "stxOSDefs.h"

/*
 * ensure that ST/X runs on NT, 95 and 98
 * (however, this disables some Win2K and XP features (sigh)
 */
#ifndef WINVER
# define WINVER 0x0400
#endif

#if WINVER < 0x0400
# define NO_GETADAPTERSINFO
#endif

#define WANT_OLE
#define OLE_DEBUG
#define COBJMACROS
#define CINTERFACE

#define USE_H_ERRNO

# if defined(i386) || defined(__i386__)
#  ifndef _X86_
#   define _X86_
#  endif
# endif

/*
 * notice: although many systems' include files
 * already block against multiple inclusion, some
 * do not. Therefore, this is done here again.
 * (it does not hurt)
 */

# undef INT
# undef UINT
# undef Array
# undef Number
# undef Method
# undef Point
# undef Rectangle
# undef Block
# undef String
# undef Message
# undef Object
# undef Context
# undef Time
# undef Date
# undef Set
# undef Signal
# undef Delay
# undef Message
# undef Process
# undef Processor

# include <stdarg.h> /* */

# ifndef WINDOWS_H_INCLUDED
#  define WINDOWS_H_INCLUDED
#  include <windows.h>
# endif

# ifdef WANT_OLE

#if 0
#  ifndef COMDEF_H_INCLUDED
#   define COMDEF_H_INCLUDED
#   include <comdef.h>
#  endif
#endif

#  ifndef OLEAUTO_H_INCLUDED
#   define OLEAUTO_H_INCLUDED
#   include <oleauto.h>
#  endif

# endif

# ifdef __DEF_Array
#  define Array __DEF_Array
# endif
# ifdef __DEF_Number
#  define Number __DEF_Number
# endif
# ifdef __DEF_Method
#  define Method __DEF_Method
# endif
# ifdef __DEF_Point
#  define Point __DEF_Point
# endif
# ifdef __DEF_Rectangle
#  define Rectangle __DEF_Rectangle
# endif
# ifdef __DEF_Block
#  define Block __DEF_Block
# endif
# ifdef __DEF_String
#  define String __DEF_String
# endif
# ifdef __DEF_Message
#  define Message __DEF_Message
# endif
# ifdef __DEF_Object
#  define Object __DEF_Object
# endif
# ifdef __DEF_Context
#  define Context __DEF_Context
# endif
# ifdef __DEF_Date
#  define Date __DEF_Date
# endif
# ifdef __DEF_Time
#  define Time __DEF_Time
# endif
# ifdef __DEF_Set
#  define Set __DEF_Set
# endif
# ifdef __DEF_Signal
#  define Signal __DEF_Signal
# endif
# ifdef __DEF_Delay
#  define Delay __DEF_Delay
# endif
# ifdef __DEF_Message
#  define Message __DEF_Message
# endif
# ifdef __DEF_Process
#  define Process __DEF_Process
# endif
# ifdef __DEF_Processor
#  define Processor __DEF_Processor
# endif

# define INT  STX_INT
# define UINT STX_UINT

typedef int (*intf)(int);

#define _HANDLEVal(o)        (HANDLE)(__externalAddressVal(o))

%}
! !

!Win32Handle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    I represent a non-I/O HANDLE.
"
! !

!Win32Handle methodsFor:'release'!

close
    "close the handle"

    self closeHandle
!

closeHandle
    "close the handle"

%{
    HANDLE h = _HANDLEVal(self);

    if (h) {
	__externalAddressVal(self) = (HANDLE)0;
	CloseHandle(h);
    }
%}.
!

finalize
    "a filedescriptor was garbage collected - close the underlying handle"

    self closeHandle
! !

!Win32Handle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/Win32Handle.st,v 1.9 2013-01-10 11:43:30 cg Exp $'
! !
