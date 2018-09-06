"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 1998-2004 by eXept Software AG
 COPYRIGHT (c) 2015-2018 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

AbstractOperatingSystem subclass:#Win32OperatingSystem
	instanceVariableNames:''
	classVariableNames:'CurrentDirectory DomainName HostName Initialized LastOsTimeHi
		LastOsTimeLow LastTimeInfo LastTimeInfoIsLocal'
	poolDictionaries:'Win32Constants'
	category:'OS-Windows'
!

ByteArray variableByteSubclass:#DevModeStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

ByteArray variableByteSubclass:#DocInfoStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Object subclass:#FileStatusInfo
	instanceVariableNames:'type mode uid gid size id accessed modified created statusChanged
		sourcePath linkTargetPath fullPathName alternativePathName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Object subclass:#OSProcessDescriptor
	instanceVariableNames:'pid parentPid commandLine'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Object subclass:#OSProcessStatus
	instanceVariableNames:'pid status code core'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

SharedPool subclass:#PECOFFConstants
	instanceVariableNames:''
	classVariableNames:'PE_Signature_OFFSET_OFFSET PE_Signature COFF_HEADER_SIZE
		COFF_HEADER_Machine_OFFSET IMAGE_FILE_MACHINE_UNKNOWN
		IMAGE_FILE_MACHINE_AM33 IMAGE_FILE_MACHINE_AMD64
		IMAGE_FILE_MACHINE_ARM IMAGE_FILE_MACHINE_ARMNT
		IMAGE_FILE_MACHINE_ARM64 IMAGE_FILE_MACHINE_EBC
		IMAGE_FILE_MACHINE_I386 IMAGE_FILE_MACHINE_IA64
		IMAGE_FILE_MACHINE_M32R IMAGE_FILE_MACHINE_MIPS16
		IMAGE_FILE_MACHINE_MIPSFPU IMAGE_FILE_MACHINE_MIPSFPU16
		IMAGE_FILE_MACHINE_POWERPC IMAGE_FILE_MACHINE_POWEPCFP
		IMAGE_FILE_MACHINE_R4000 IMAGE_FILE_MACHINE_SH3
		IMAGE_FILE_MACHINE_SH3DSP IMAGE_FILE_MACHINE_SH4
		IMAGE_FILE_MACHINE_SH5 IMAGE_FILE_MACHINE_THUMB
		IMAGE_FILE_MACHINE_WCEMIPSV2'
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Object subclass:#PECOFFFileHeader
	instanceVariableNames:'file data'
	classVariableNames:''
	poolDictionaries:'Win32OperatingSystem::PECOFFConstants'
	privateIn:Win32OperatingSystem
!

Object subclass:#PerformanceData
	instanceVariableNames:'objectArray perfTime perfFreq perfTime100nSec'
	classVariableNames:'PerformanceText CounterIndexTextDictionary
		HelpIndexTextDictionary'
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Object subclass:#Abstract
	instanceVariableNames:'lastData lastTimestamp cachedResults'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem::PerformanceData
!

Win32OperatingSystem::PerformanceData::Abstract subclass:#DiskIO
	instanceVariableNames:''
	classVariableNames:'TheOneAndOnlyInstance'
	poolDictionaries:''
	privateIn:Win32OperatingSystem::PerformanceData
!

Win32OperatingSystem::PerformanceData::Abstract subclass:#Global
	instanceVariableNames:''
	classVariableNames:'TheOneAndOnlyInstance'
	poolDictionaries:''
	privateIn:Win32OperatingSystem::PerformanceData
!

Win32OperatingSystem::PerformanceData::Abstract subclass:#Memory
	instanceVariableNames:''
	classVariableNames:'TheOneAndOnlyInstance'
	poolDictionaries:''
	privateIn:Win32OperatingSystem::PerformanceData
!

Win32OperatingSystem::PerformanceData::Abstract subclass:#Network
	instanceVariableNames:''
	classVariableNames:'TheOneAndOnlyInstance'
	poolDictionaries:''
	privateIn:Win32OperatingSystem::PerformanceData
!

Win32OperatingSystem::PerformanceData::Abstract subclass:#Process
	instanceVariableNames:''
	classVariableNames:'TheOneAndOnlyInstance'
	poolDictionaries:''
	privateIn:Win32OperatingSystem::PerformanceData
!

Win32OperatingSystem::PerformanceData::Abstract subclass:#Processor
	instanceVariableNames:''
	classVariableNames:'TheOneAndOnlyInstance'
	poolDictionaries:''
	privateIn:Win32OperatingSystem::PerformanceData
!

ByteArray variableByteSubclass:#PrinterInfo2Structure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Object subclass:#RegistryEntry
	instanceVariableNames:'path handle isNew'
	classVariableNames:'Lobby HKEY_CLASSES_ROOT HKEY_CURRENT_USER HKEY_LOCAL_MACHINE
		HKEY_USERS HKEY_PERFORMANCE_DATA HKEY_CURRENT_CONFIG
		HKEY_DYN_DATA HKEY_PERFORMANCE_TEXT HKEY_PERFORMANCE_NLSTEXT'
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

ByteArray variableByteSubclass:#TextMetricsStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Win32Handle subclass:#Win32ChangeNotificationHandle
	instanceVariableNames:''
	classVariableNames:'Lobby'
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Win32Handle subclass:#Win32IOHandle
	instanceVariableNames:''
	classVariableNames:'Lobby'
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Win32Handle subclass:#Win32MutexHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Win32Handle subclass:#Win32NetworkResourceHandle
	instanceVariableNames:''
	classVariableNames:'ScopeMappingTable TypeMappingTable DisplayTypeMappingTable
		UsageMappingTable'
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Object subclass:#NetworkResource
	instanceVariableNames:'scope type usage displayType remoteName localName provider
		comment'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem::Win32NetworkResourceHandle
!

Win32Handle subclass:#Win32PrinterHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Win32Handle subclass:#Win32ProcessHandle
	instanceVariableNames:'pid'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Win32OperatingSystem::Win32IOHandle subclass:#Win32SerialPortHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

Win32OperatingSystem::Win32IOHandle subclass:#Win32SocketHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

ByteArray variableByteSubclass:#WinPointStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32OperatingSystem
!

!Win32OperatingSystem primitiveDefinitions!
%{

# define WINVER 0x0500   /*required for CoInitializeEx*/
# undef  WINVER
# define WINVER 0x0600   /*required for GetTokenInformation & associated typedefs */
# undef  WINVER
# define WINVER 0x0601   /*required for GetTimeZoneInformationForYear & associated typedefs */
#include "stxOSDefs.h"

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
# ifndef _SIGNAL_H_INCLUDED_
#  include <signal.h>
#  define _SIGNAL_H_INCLUDED_
# endif

# ifndef _SYS_TYPES_H_INCLUDED_
#  include <sys/types.h>
#  define _SYS_TYPES_H_INCLUDED_
# endif

# ifndef _TIME_H_INCLUDED_
#  include <time.h>
#  define _TIME_H_INCLUDED_
# endif

# ifndef _SYS_TIMEB_H_INCLUDED_
#  include <sys/timeb.h>
#  define _SYS_TIMEB_H_INCLUDED_
# endif

# ifndef _SYS_STAT_H_INCLUDED_
#  include <sys/stat.h>
#  define _SYS_STAT_H_INCLUDED_
# endif

# ifndef _ERRNO_H_INCLUDED_
#  include <errno.h>
#  define _ERRNO_H_INCLUDED_
# endif

# ifndef _STDIO_H_INCLUDED_
#  include <stdio.h>
#  define _STDIO_H_INCLUDED_
# endif

# ifndef _FCNTL_H_INCLUDED_
#  include <fcntl.h>
#  define _FCNTL_H_INCLUDED_
# endif

# define PROCESSDEBUGWIN32
// # define PROCESS1DEBUGWIN32
// # define PROCESS2DEBUGWIN32
// # define PROCESSDEBUG_CHILDPROCESSWAIT
// # define SELECTDEBUGWIN32
// # define SELECT1DEBUGWIN32
// # define SELECT2DEBUGWIN32
// # define WAITDEBUGWIN32
// # define SIGNALDEBUGWIN32

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
# undef Class
# undef Context
# undef Time
# undef Date
# undef Set
# undef Signal
# undef Delay
# undef Message
# undef Process
# undef NameSpace
# undef Processor
# undef String
# undef Character

# include <stdarg.h> /* */

# ifndef WINDOWS_H_INCLUDED
#  define WINDOWS_H_INCLUDED
#  include <windows.h>
# endif

# ifndef TLHELP32_H_INCLUDE
#  define TLHELP32_H_INCLUDE
#  include <TLHELP32.h>         /* to get all processes in system */
#endif

# ifndef NO_GETADAPTERSINFO
#  include <iphlpapi.h>
# endif

# ifndef WINDOWSX_H_INCLUDED
#  define WINDOWSX_H_INCLUDED
#  include <windowsx.h>
# endif

# define _WIN32_DCOM     /*required for CoInitializeEx*/
# include <objbase.h>    //for COM

# include <shlobj.h>
# include <objbase.h>
# include <initguid.h>
# ifndef _STRING_H_INCLUDED_
#  define _STRING_H_INCLUDED_
#  include <string.h>
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
# ifndef __DEF_Class
#  define Class __DEF_Class
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
# ifdef __DEF_NameSpace
#  define NameSpace __DEF_NameSpace
# endif
# ifdef __DEF_String
#  define String __DEF_String
# endif
# ifdef __DEF_Character
#  define Character __DEF_Character
# endif

# define INT STX_INT
# define UINT STX_UINT

typedef int (*intf)(int);
BOOL __signalUserInterruptWIN32(DWORD sig);

# if defined (HAS_LOCALECONV)
#  ifndef _LOCALE_H_INCLUDED_
#   include <locale.h>
#   define _LOCALE_H_INCLUDED_
#  endif
# endif

# ifdef __BORLANDC__
#  include <dir.h>
#  define xMAXPATHLEN MAXPATH
#  define MAXFILELEN MAXFILE

#  if 0
OBJ _SEND0(OBJ, OBJ, OBJ, inlineCachePtr);
OBJ _SEND1(OBJ, OBJ, OBJ, inlineCachePtr, OBJ);
OBJ _SEND2(OBJ, OBJ, OBJ, inlineCachePtr, OBJ, OBJ);
OBJ _SEND3(OBJ, OBJ, OBJ, inlineCachePtr, OBJ, OBJ, OBJ);
#  endif

# endif /* BORLANDC */

# ifndef __BORLANDC__
#   define chmod _chmod
# endif /* not BORLANDC */

# ifndef MAXPATHLEN

#  ifdef FILENAME_MAX
#   define xMAXPATHLEN FILENAME_MAX
#  endif

#  ifndef MAXPATHLEN
#   define MAXPATHLEN 1024
#  endif

# endif

/*
 * sigaction dummies (you won't believe these call themself ``POSIX'' systems ...)
 */
# ifndef SA_RESTART
#  define SA_RESTART    0
# endif
# ifndef SA_SIGINFO
#  define SA_SIGINFO    0
# endif

# if defined(HAS_WAITPID) || defined(HAS_WAIT3)
#  include <sys/wait.h>
# endif

# if defined(HAS_SYSINFO)
#  include <sys/systeminfo.h>
# endif

# ifndef __BORLANDC__
#  ifndef COINIT_MULTITHREADED
#   define COINIT_MULTITHREADED 0x0
#  endif
# endif

#define SIGHANDLER_ARG int

#define _HANDLEVal(o)        (HANDLE)(__externalAddressVal(o))
#define _SETHANDLEVal(o, v)  (__externalAddressVal(o) = (v))
#if defined(__BORLANDC__)
HANDLE _get_osfhandle(int);
#endif

/*
 * Borland (oh, my!) and __old__ MING32 have no TOKEN_ELEVATION_TYPE defined. 
 * However, MINGW32 coming with MSYS2 (https://msys2.github.io/) uses 
 * MINGW32 5.3.x which does have the enum defined. Hence the test for 
 * (__GNUC__ < 5). 
 * Q: Is there any better way to do so? 
 */
#if defined(__BORLANDC__) || (defined(__MINGW32__) && (__GNUC__ < 5))

typedef enum _TOKEN_ELEVATION_TYPE {
    TokenElevationTypeDefault = 1,
    TokenElevationTypeFull,
    TokenElevationTypeLimited,
} TOKEN_ELEVATION_TYPE, *PTOKEN_ELEVATION_TYPE;

#endif

#if defined(__BORLANDC__)

typedef struct _TOKEN_ELEVATION {
    DWORD TokenIsElevated;
} TOKEN_ELEVATION, *PTOKEN_ELEVATION;

typedef enum _TOKEN_INFORMATION_CLASS_V2 {
    nTokenUser = 1,
    nTokenGroups,
    nTokenPrivileges,
    nTokenOwner,
    nTokenPrimaryGroup,
    nTokenDefaultDacl,
    nTokenSource,
    nTokenType,
    nTokenImpersonationLevel,
    nTokenStatistics,
    nTokenRestrictedSids,
    nTokenSessionId,
    nTokenGroupsAndPrivileges,
    nTokenSessionReference,
    nTokenSandBoxInert,
    nTokenAuditPolicy,
    nTokenOrigin,
    nTokenElevationType,
    nTokenLinkedToken,
    nTokenElevation,
    nTokenHasRestrictions,
    nTokenAccessInformation,
    nTokenVirtualizationAllowed,
    nTokenVirtualizationEnabled,
    nTokenIntegrityLevel,
    nTokenUIAccess,
    nTokenMandatoryPolicy,
    nTokenLogonSid,
    nMaxTokenInfoClass  // MaxTokenInfoClass should always be the last enum
} TOKEN_INFORMATION_CLASS_V2, *PTOKEN_INFORMATION_CLASS_V2;
# define TokenElevationType (TOKEN_INFORMATION_CLASS)nTokenElevationType
# define TokenElevation     (TOKEN_INFORMATION_CLASS)nTokenElevation

#endif /* BORLAND */

#ifdef PROCESSDEBUGWIN32
static int flag_PROCESSDEBUGWIN32 = 0;
#endif

%}
! !

!Win32OperatingSystem primitiveVariables!
%{
static int coInitialized = 0;
%}
! !

!Win32OperatingSystem primitiveFunctions!
%{

/**
 * The `_makeWchar()` function copies contents of a string object `srcObj` to a 
 * (wide char) buffer `dst`. At most `n` **bytes** including null terminator 
 * are copied to destination buffer `dst`. 
 * 
 * Returns the number of **bytes** copied (including null terminator). If 
 * source string object is not an instance of `String` or `Unicode16String`, 
 * returns `-1`.
 */ 
static int
_makeWchar(OBJ srcObj, wchar_t *dst, int n/* in bytes!!! */)
{
    int i;
    int srcLen; /* length of string to be copied, in **characters** */
    int dstLen; /* length of destination buffer,  in **characters** */

    dstLen = n / sizeof(wchar_t);
	
    if (__isStringLike(srcObj)) {
	srcLen = __stringSize(srcObj);	
	
	if (srcLen >= dstLen) srcLen = dstLen - 1;

	for (i=0; i<srcLen; i++) {
	    dst[i] = __stringVal(srcObj)[i];
	}
    } else if (__isUnicode16String(srcObj)) {    	
	srcLen = __unicode16StringSize(srcObj);
	
	if (srcLen >= dstLen) srcLen = dstLen - 1;		
	
	memcpy(dst, __unicode16StringVal(srcObj), srcLen * sizeof(wchar_t));
    } else {
    	dst[0] = 0;
	return(-1);
    }
    dst[srcLen] = 0;    
    return(srcLen * sizeof(wchar_t));
}



static int
_canAccessIOWithoutBlocking (HANDLE handle, int readMode)
{
    struct timeval tv;
    fd_set         fds;
    int            n;
    int winErrNo;

    FD_ZERO(&fds);
    FD_SET (handle, &fds);

    tv.tv_sec  = 0;
    tv.tv_usec = 0;

    if (readMode) {
	n = select (1 , &fds, NULL, NULL, &tv);  // first parameter to select is ignored in windows
    } else {
	n = select (1, NULL, &fds, NULL, &tv);
    }

    if (n == 0) {
	return (0);
    }

    if (n > 0) {
	return (FD_ISSET(handle, &fds) ? 1 : 0);
    }

    winErrNo = WSAGetLastError();
    switch (winErrNo) {
	case WSAENOTSOCK:
	    if (readMode) {
		DWORD  w = 0;

		if (PeekNamedPipe (handle, 0, 0, 0, & w, 0)) {
		    return (w > 0);
		}
#if 0
		console_fprintf(stderr, "_canAccessIOWithoutBlocking non Socket\n");
#endif
		return (-1);
	    }
	    /* in writeMode we return always true for none-sockets */
	    return (1);

	case WSAEINPROGRESS:
	case WSAEWOULDBLOCK:
	    return (0);

	default:
	    console_fprintf(stderr, "_canAccessIOWithoutBlocking -> %d (0x%x)\n", winErrNo, winErrNo);
	    return (-1);
    }

    /* not reached */
    return (0);
}

#define _canReadWithoutBlocking(fd)     _canAccessIOWithoutBlocking(fd, 1)
#define _canWriteWithoutBlocking(fd)    _canAccessIOWithoutBlocking(fd, 0)

/*
 * Attention: some API calls are not available on old NT4.0/W95/W98
 * For those, the dll does not include the calls directly, but tries to
 * load the library and looks what we get.
 * Here are support functions to load the libs.
 */
static FARPROC
__get_functionAddress(HINSTANCE *pLibHandle, char *libraryName, char *functionName)
{
    FARPROC entry;

    if (*pLibHandle == NULL) {
	*pLibHandle = LoadLibrary(libraryName);
    }
    entry = GetProcAddress(*pLibHandle, functionName);
    return entry;
}

static FARPROC
__get_kernel32_functionAddress(char *functionName)
{
    static HINSTANCE libHandle = NULL;

    return __get_functionAddress(&libHandle, "kernel32.DLL", functionName);
}

static FARPROC
__get_iphlpapi_functionAddress(functionName)
    char *functionName;
{
    static HINSTANCE libHandle = NULL;

    return __get_functionAddress(&libHandle, "iphlpapi.DLL", functionName);
}

static FARPROC
__get_ole32_functionAddress(functionName)
    char *functionName;
{
    static HINSTANCE libHandle = NULL;

    return __get_functionAddress(&libHandle, "ole32.DLL", functionName);
}

#if 0
// original: biased for 1.1.1601
// obsolete...
OBJ
FileTimeToOsTime(LPFILETIME pft)
{
    LONGLONG lTime = ((LONGLONG)pft->dwHighDateTime << 32) + pft->dwLowDateTime;
    lTime = (lTime / 10000);    // convert multiple of 100ns to milliseconds
#if __POINTER_SIZE__ == 8
    return(__MKUINT(lTime));
#else
    return(__MKLARGEINT64(1, (unsigned INT)(lTime & 0xFFFFFFFF), (unsigned INT)(lTime >> 32)));
#endif
}
#endif

// biased for 1.1.1970
// (renamed to catch references from other classes)
OBJ
FileTimeToOsTime1970(LPFILETIME pft)
{
    LONGLONG lTime = ((LONGLONG)pft->dwHighDateTime << 32) + pft->dwLowDateTime;
    lTime = (lTime / 10000);    // convert multiple of 100ns to milliseconds

#if __POINTER_SIZE__ == 8
    lTime -= 11644473600000LL;  // the number of millis from 1.1.1601 to 1.1.1970
    return(__MKINT(lTime));
#else
    if (lTime >= (LONGLONG)11644473600000L) {
	lTime -= (LONGLONG)11644473600000L;  // the number of millis from 1.1.1601 to 1.1.1970
	return(__MKLARGEINT64(1, (unsigned INT)(lTime & 0xFFFFFFFF), (unsigned INT)(lTime >> 32)));
    } else {
	lTime = (LONGLONG)11644473600000L - lTime;
	return(__MKLARGEINT64(-1, (unsigned INT)(lTime & 0xFFFFFFFF), (unsigned INT)(lTime >> 32)));
    }
#endif
}

#if 0
// obsolete; biased for 1.1.1601
int
OsTimeToFileTime(OBJ tLow, OBJ tHigh, LPFILETIME pft) {
    LONGLONG lTime;
    UINT low = __unsignedLongIntVal(tLow);
    UINT hi = __unsignedLongIntVal(tHigh);

    if (hi == 0 && !__isSmallInteger(tHigh))
	return(0);      // conversion error

    lTime = ((LONGLONG)hi << 32) + (LONGLONG)low;
    lTime = lTime * 10000;      // convert to multiple of 100ns

    pft->dwHighDateTime = (UINT)(lTime >> 32);
    pft->dwLowDateTime = (UINT)(lTime & 0xFFFFFFFF);
    return(1);
}
#endif

// biased for 1.1.1970
// renamed to catch any references from other classes.
int
OsTime1970ToFileTime(OBJ tLow, OBJ tHigh, LPFILETIME pft) {
    LONGLONG lTime;
    UINT low = __unsignedLongIntVal(tLow);
    UINT hi = __unsignedLongIntVal(tHigh);

    if (hi == 0 && !__isSmallInteger(tHigh))
	return(0);      // conversion error

    lTime = ((LONGLONG)hi << 32) + (LONGLONG)low;
    lTime += (LONGLONG)11644473600000L;  // rebias to 1.1.1601
    lTime = lTime * 10000;      // convert to multiple of 100ns

    pft->dwHighDateTime = (UINT)(lTime >> 32);
    pft->dwLowDateTime = (UINT)(lTime & 0xFFFFFFFF);
    return(1);
}

%}
! !

!Win32OperatingSystem class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 1998-2004 by eXept Software AG
 COPYRIGHT (c) 2015-2018 Jan Vrany
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
    This class resulted from extracting WIN32 specifics of the old
    OperatingSystemClass into this sub-class.

    This class realizes required operating system services for MS-Windows systems.
    The name is misleading and a historic leftover: it supports both 32bit and 64bit OSes.

    Some of it is very specific for windows, so do not depend on
    things available here if your application runs under unix/linux/osx
    Some may not be found in other OS's or be slightly different.
    On the other hand: I do not want to hide all features
    from you - in some situations it MAY be interesting to be
    able to get down to a low level system call easily.
    If you use sch features, make sure that you wrap the call into a condition,
    such as 'OperatingSystem isMSWINDOWSlike ifTrue:[...]'

    You decide - portability vs. functionality)

    [Class variables:]

	HostName        <String>        remembered hostname

	DomainName      <String>        remembered domainname

	CurrentDirectory <String>       remembered currentDirectories path

    [author:]
	Claus Gittinger (initial version & cleanup)
	Manfred Dierolf (many features)

    [see also:]
	OSProcessStatus
	Filename Date Time
	ExternalStream FileStream PipeStream Socket
"
!

examples
"
  various queries
								[exBegin]
    Transcript
	showCR:'hello ' , (OperatingSystem getLoginName)
								[exEnd]

								[exBegin]
    OperatingSystem isUNIXlike ifTrue:[
	Transcript showCR:'this is some UNIX-like OS'
    ] ifFalse:[
	Transcript showCR:'this OS is not UNIX-like'
    ]
								[exEnd]

								[exBegin]
    Transcript
	showCR:'this machine is called ' , OperatingSystem getHostName
								[exEnd]

								[exBegin]
    Transcript
	showCR:('this machine is in the '
	       , OperatingSystem getDomainName
	       , ' domain')
								[exEnd]

								[exBegin]
    Transcript
	showCR:('this machine''s CPU is a '
	       , OperatingSystem getCPUType
	       )
								[exEnd]

								[exBegin]
    Transcript showCR:'executing ls command ...'.
    OperatingSystem executeCommand:'ls'.
    Transcript showCR:'... done.'.
								[exEnd]

  locking a file
  (should be executed on two running smalltalks - not in two threads):
								[exBegin]
    |f|

    f := 'testFile' asFilename readWriteStream.

    10 timesRepeat:[
	'about to lock ...' printCR.
	[
	  OperatingSystem
	    lockFD:(f fileDescriptor)
	    shared:false
	    blocking:false
	] whileFalse:[
	    'process ' print. OperatingSystem getProcessId print. ' is waiting' printCR.
	    Delay waitForSeconds:1
	].
	'LOCKED ...' printCR.
	Delay waitForSeconds:10.
	'unlock ...' printCR.
	(OperatingSystem
	    unlockFD:(f fileDescriptor)) printCR.
	Delay waitForSeconds:3.
    ]
								[exBegin]
"
! !

!Win32OperatingSystem class methodsFor:'initialization'!

coInitialize
%{
    HRESULT hres;

    if( ! coInitialized ) {

	hres = CoInitializeEx(NULL, COINIT_MULTITHREADED);
	if (! SUCCEEDED(hres)) {
	    console_fprintf(stderr, "OperatingSystem [info]: Could not open the COM library hres = %08x\n", hres );
	    goto error;
	}
	coInitialized = 1;

#ifdef COM_DEBUG

	console_fprintf(stderr, "OperatingSystem [info]: COM initialized\n" );
#endif
    }
    RETURN (self );

error: ;
%}.
    self primitiveFailed
!

getOSVersion
%{  /* NOCONTEXT */
    OSVERSIONINFO osvi;

    memset(&osvi, 0, sizeof(OSVERSIONINFO));
    osvi.dwOSVersionInfoSize = sizeof (OSVERSIONINFO);
    GetVersionEx (&osvi);

    RETURN(__mkSmallInteger(osvi.dwPlatformId));
%}.
!

initialize
    "initialize the class"

    "/ attention: must be ok to be called twice during startup.
    Initialized isNil ifTrue:[
	Initialized := true.
	ObjectMemory addDependent:self.
	HostName := nil.
	DomainName := nil.
	LastErrorNumber := nil.
	PipeFailed := false.
	self coInitialize.
    ].

    "Modified: 13.9.1997 / 10:47:32 / cg"
!

initializeLocale
   | lang territory |

    "/ Defaults
    Language := #en.
    LanguageTerritory := #us.   

%{    
    char str_buf[9];
    int  str_len = 0;
    
    /*
     * While the documentation says we should use GetLocaleInfoEx(), 
     * we by purpose use (discourage) GetLocaleInfo() in order to run
     * also on Windows XP. Not sure it makes much sense these days,
     * but there was a request recently some XP fixes.
     */
    str_len = GetLocaleInfoA(LOCALE_NAME_USER_DEFAULT, LOCALE_SISO639LANGNAME, str_buf, sizeof(str_buf));
    if (str_len) {    	
    	lang = __MKSTRING_L(str_buf, str_len);
    }
    str_len = GetLocaleInfoA(LOCALE_NAME_USER_DEFAULT, LOCALE_SISO3166CTRYNAME, str_buf, sizeof(str_buf));
    if (str_len) {    	
    	territory = __MKSTRING_L(str_buf, str_len);
    }
%}.
    "/ Since this may be called early during initialization, do not make
    "/ `#primitiveFailed` when `GetLocaleInfoEx()` fails. Otherwise smalltalk
    "/ may fail to compe up. 
    "/ Instead, log an error and proceed with `en-us` locale. 
    lang isNil ifTrue:[
    	Logger error: 'GetLocaleInfoEx(..., LOCALE_SISO639LANGNAME, ...) failed'.
    ].
    territory isNil ifTrue:[
    	Logger error: 'GetLocaleInfoEx(..., LOCALE_SISO3166CTRYNAME, ...) failed'.
    ].
    Language := lang asSymbol.
    LanguageTerritory := territory asLowercase asSymbol.   

!

update:something with:aParameter from:changedObject
    "catch image restart and flush some cached data"

    something == #earlyRestart ifTrue:[
	"
	 flush cached data
	"
	HostName := nil.
	DomainName := nil.
	LastErrorNumber := nil.
	PipeFailed := false.
	self coInitialize.
    ]

    "Modified: 22.4.1996 / 13:10:43 / cg"
    "Created: 15.6.1996 / 15:22:37 / cg"
    "Modified: 7.1.1997 / 19:36:11 / stefan"
! !

!Win32OperatingSystem class methodsFor:'OS signal constants'!

sigABRT
    "return the signal number for SIGABRT - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGABRT
    RETURN ( __mkSmallInteger(SIGABRT) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigALRM
    "return the signal number for SIGALRM - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGALRM
    RETURN ( __mkSmallInteger(SIGALRM) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigBREAK
    "return the signal number for SIGBREAK - 0 if not supported.
     This is an MSDOS specific signal"

%{  /* NOCONTEXT */
#ifdef SIGBREAK
    RETURN ( __mkSmallInteger(SIGBREAK) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigBUS
    "return the signal number for SIGBUS - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGBUS
    RETURN ( __mkSmallInteger(SIGBUS) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigCHLD
    "return the signal number for SIGCHLD - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGCHLD)
    RETURN ( __mkSmallInteger(SIGCHLD) );
#else
# if  defined(SIGCLD)
    RETURN ( __mkSmallInteger(SIGCLD) );
# else
    RETURN ( __mkSmallInteger(0) );
# endif
#endif
%}
!

sigCONT
    "return the signal number for SIGCONT - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGCONT)
    RETURN ( __mkSmallInteger(SIGCONT) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigDANGER
    "return the signal number for SIGDANGER - 0 if not supported
     (seems to be an AIX special)"

%{  /* NOCONTEXT */
#if defined(SIGDANGER)
    RETURN ( __mkSmallInteger(SIGDANGER) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigEMT
    "return the signal number for SIGEMT - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGEMT
    RETURN ( __mkSmallInteger(SIGEMT) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigFP
    "return the signal number for SIGFP - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGFPE
    RETURN ( __mkSmallInteger(SIGFPE) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigGRANT
    "return the signal number for SIGGRANT - 0 if not supported
     (seems to be an AIX special)"

%{  /* NOCONTEXT */
#if defined(SIGGRANT)
    RETURN ( __mkSmallInteger(SIGGRANT) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigHUP
    "return the signal number for SIGHUP
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGHUP
    RETURN ( __mkSmallInteger(SIGHUP) );
#else
    RETURN ( __mkSmallInteger(1) );
#endif
%}
!

sigILL
    "return the signal number for SIGILL - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGILL
    RETURN ( __mkSmallInteger(SIGILL) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigINT
    "return the signal number for SIGINT
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGINT
    RETURN ( __mkSmallInteger(SIGINT) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigIO
    "return the signal number for SIGIO - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGIO)
    RETURN ( __mkSmallInteger(SIGIO) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigIOT
    "return the signal number for SIGIOT - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGIOT
    RETURN ( __mkSmallInteger(SIGIOT) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigKILL
    "return the signal number for SIGKILL
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGKILL
    RETURN ( __mkSmallInteger(SIGKILL) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigLOST
    "return the signal number for SIGLOST - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGLOST)
    RETURN ( __mkSmallInteger(SIGLOST) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigMIGRATE
    "return the signal number for SIGMIGRATE - 0 if not supported
     (seems to be an AIX special)"

%{  /* NOCONTEXT */
#if defined(SIGMIGRATE)
    RETURN ( __mkSmallInteger(SIGMIGRATE) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigMSG
    "return the signal number for SIGMSG - 0 if not supported
     (seems to be an AIX special)"

%{  /* NOCONTEXT */
#if defined(SIGMSG)
    RETURN ( __mkSmallInteger(SIGMSG) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigPIPE
    "return the signal number for SIGPIPE - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGPIPE
    RETURN ( __mkSmallInteger(SIGPIPE) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigPOLL
    "return the signal number for SIGPOLL - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGPOLL)
    RETURN ( __mkSmallInteger(SIGPOLL) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigPRE
    "return the signal number for SIGPRE - 0 if not supported
     (seems to be an AIX special)"

%{  /* NOCONTEXT */
#if defined(SIGPRE)
    RETURN ( __mkSmallInteger(SIGPRE) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigPROF
    "return the signal number for SIGPROF - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGPROF)
    RETURN ( __mkSmallInteger(SIGPROF) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigPWR
    "return the signal number for SIGPWR - 0 if not supported
     (not available on all systems)"

%{  /* NOCONTEXT */
#if defined(SIGPWR)
    RETURN ( __mkSmallInteger(SIGPWR) );
#else
    RETURN ( __mkSmallInteger(30) );
#endif
%}
!

sigQUIT
    "return the signal number for SIGQUIT
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGQUIT
    RETURN ( __mkSmallInteger(SIGQUIT) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigRETRACT
    "return the signal number for SIGRETRACT - 0 if not supported
     (seems to be an AIX special)"

%{  /* NOCONTEXT */
#if defined(SIGRETRACT)
    RETURN ( __mkSmallInteger(SIGRETRACT) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigSAK
    "return the signal number for SIGSAK - 0 if not supported
     (seems to be an AIX special)"

%{  /* NOCONTEXT */
#if defined(SIGSAK)
    RETURN ( __mkSmallInteger(SIGSAK) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigSEGV
    "return the signal number for SIGSEGV - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGSEGV
    RETURN ( __mkSmallInteger(SIGSEGV) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigSOUND
    "return the signal number for SIGSOUND - 0 if not supported
     (seems to be an AIX special)"

%{  /* NOCONTEXT */
#if defined(SIGSOUND)
    RETURN ( __mkSmallInteger(SIGSOUND) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigSTOP
    "return the signal number for SIGSTOP - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGSTOP)
    RETURN ( __mkSmallInteger(SIGSTOP) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigSYS
    "return the signal number for SIGSYS - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGSYS
    RETURN ( __mkSmallInteger(SIGSYS) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigTERM
    "return the signal number for SIGTERM - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGTERM
    RETURN ( __mkSmallInteger(SIGTERM) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigTRAP
    "return the signal number for SIGTRAP - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#ifdef SIGTRAP
    RETURN ( __mkSmallInteger(SIGTRAP) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigTSTP
    "return the signal number for SIGTSTP - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGTSTP)
    RETURN ( __mkSmallInteger(SIGTSTP) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigTTIN
    "return the signal number for SIGTTIN - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGTTIN)
    RETURN ( __mkSmallInteger(SIGTTIN) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigTTOU
    "return the signal number for SIGTTOU - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGTTOU)
    RETURN ( __mkSmallInteger(SIGTTOU) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigURG
    "return the signal number for SIGURG - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGURG)
    RETURN ( __mkSmallInteger(SIGURG) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigUSR1
    "return the signal number for SIGUSR1 - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGUSR1)
    RETURN ( __mkSmallInteger(SIGUSR1) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigUSR2
    "return the signal number for SIGUSR2 - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGUSR2)
    RETURN ( __mkSmallInteger(SIGUSR2) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigVTALRM
    "return the signal number for SIGVTALRM - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGVTALRM)
    RETURN ( __mkSmallInteger(SIGVTALRM) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigWINCH
    "return the signal number for SIGWINCH - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGWINCH)
    RETURN ( __mkSmallInteger(SIGWINCH) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigXCPU
    "return the signal number for SIGXCPU - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGXCPU)
    RETURN ( __mkSmallInteger(SIGXCPU) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
!

sigXFSZ
    "return the signal number for SIGXFSZ - 0 if not supported
     (the numeric value is not the same across unix-systems)"

%{  /* NOCONTEXT */
#if defined(SIGXFSZ)
    RETURN ( __mkSmallInteger(SIGXFSZ) );
#else
    RETURN ( __mkSmallInteger(0) );
#endif
%}
! !

!Win32OperatingSystem class methodsFor:'TTY support'!

getTTYAttributes: fd
	OsError raiseErrorString: 'TTYs / PTYs not supported on Windows'

!

isTTY: fd                                                                                                     
    "Return true, if given filedescriptor refers to a character device (console). See _isatty()                                  
     for details."                                                                                            

%{                                                                                                            
    if (__isSmallInteger(fd)) {                                                                               
        if ( _isatty( __intVal(fd) )  ) {                                                                       
            RETURN(true)                                                                                      
        } else {                                                                                              
            RETURN(false);                                                                                           
        }                                                                                                     
    }                                                                                                         
%}.                                                                                                           
    self primitiveFailed.                                                                                     

    "Created: / 01-06-2017 / 20:12:57 / jv"

!

setTTYAttributes: fd to: ttyattrs withActions: actions
	OsError raiseErrorString: 'TTYs / PTYs not supported on Windows'

! !

!Win32OperatingSystem class methodsFor:'VM messages'!

win32LogFile
    "return the name of the log file.
     This is mostly used by standAlone apps, without a console,
     which write their log info into a file named xxx_log_xxx.log.
     The default logFilename is defined be the make-build process, and
     can be overwritten by a command line argumen (--logFile). In order to
     provide access to that files path (for example, to open an editor on it),
     use this method to ask for the files name.
     Returns nil, of nothing has been written to the logfile, yet.
     Enforce a logFile, by doing an errorPrint or infoPrint first."

    |ret|

%{
    extern char *__win32_getLogFilename();
    char *lp;

    lp = __win32_getLogFilename();
    if (lp) {
	ret = __MKSTRING(lp);
    }
%}.
    ^ ret

    "
     Win32OperatingSystem win32LogFile
    "
!

win32LogFile:aFilenameOrNil
    "change the file, into which log info is written.
     This is mostly used by standAlone apps, without a console,
     which write their log info into a file named xxx_log_xxx.log"

    |logFilePath|

    aFilenameOrNil notNil ifTrue:[
	logFilePath := aFilenameOrNil asFilename pathName
    ].

%{
    extern void __win32_setLogFile();

    if (__isStringLike(logFilePath)) {
	__win32_setLogFile(__stringVal(logFilePath));
    } else {
	__win32_setLogFile( NULL );
    }
%}

    "
     Win32OperatingSystem win32LogFile:'myLog.log'
     Win32OperatingSystem win32LogFile:nil
    "
! !

!Win32OperatingSystem class methodsFor:'accessing'!

performanceData
    ^ PerformanceData
! !

!Win32OperatingSystem class methodsFor:'clipboard'!

clipboardContainsBitmap
	"Answer whether the clipboard contains a bitmap."

    ^self clipboardContainsFormat: 2 "CfBitmap"
!

clipboardContainsFormat: aCfConstant
	"Answer true if the clipboard contains data in
	 the format described by aCfConstant.  "

    ^self primIsClipboardFormatAvailable: aCfConstant
!

closeClipboard
    | result |
    result := self primCloseClipboard.
    result ifFalse: [ ^self error].
    ^result
!

emptyClipboard
	"Private - empty the clipboard. Note: it must be opened first."
    | result |
    result := self primEmptyClipboard.
    result ifFalse: [ ^self error].
    ^result
!

getDesktopWindow

    ^self primGetDesktopWindow
!

openClipboard

    ^self openClipboard: self getDesktopWindow
!

openClipboard: aHwnd
    | result |
    result := self primOpenClipboard: aHwnd.
    result ifFalse: [ ^self error].
    ^result
!

primCloseClipboard

    <apicall: bool "CloseClipboard" () module: "user32.dll" >
    ^self primitiveFailed
!

primEmptyClipboard

    <apicall: bool "EmptyClipboard" () module: "user32.dll" >
    ^self primitiveFailed
!

primGetDesktopWindow

    <apicall: ulongReturn "GetDesktopWindow" () module: "user32.dll" >
    ^self primitiveFailed
!

primIsClipboardFormatAvailable: aCfConstant

    <apicall: boolean "IsClipboardFormatAvailable" (ulong) module: "user32.dll" >
     ^self primitiveFailed
!

primOpenClipboard: aHwnd

    <apicall: bool "OpenClipboard" (ulong) module: "user32.dll" >
    ^self primitiveFailed
!

primSetClipboardData: aCfConstant hMem: aMemHandle

    <apicall: ulongReturn "SetClipboardData" (ulong ulong) module: "user32.dll" >
    ^self primitiveFailed
!

setBitmapToClipboard: aBitmap
	"Copy aBitmap to the clipboard."
    | handle |
    aBitmap isNil ifTrue:[ ^nil ].
    aBitmap id isNil ifTrue:[aBitmap onDevice: Screen current].
    handle := aBitmap id.
    handle isNil ifTrue: [ ^nil ].
    self openClipboard ifFalse: [ ^nil ].
    self emptyClipboard.
    self setClipboardData: 2 "CfBitmap" hMem: handle.
    self closeClipboard

    "
	self setBitmapToClipboard: Image fromUser
    "
!

setClipboardData: aCfConstant hMem: aMemHandle
    |result|
    result := self primSetClipboardData: aCfConstant hMem: aMemHandle address.
    result = 0 ifTrue: [ ^self error ].
! !

!Win32OperatingSystem class methodsFor:'debugging'!

verbose:aBoolean
%{
#ifdef PROCESSDEBUGWIN32
    flag_PROCESSDEBUGWIN32 = (aBoolean == true);
#endif
%}
! !

!Win32OperatingSystem class methodsFor:'directory access'!

linkInfoFor:osPathname fileSize:fileSize fileAttributes:osFileAttributes osCrtTime:osCrtTime osAccTime:osAccTime osModTime:osModTime
    |type modeBits crtTime accTime modTime|

%{
    DWORD  __fileAttr = __unsignedLongIntVal( osFileAttributes );
    int    __modeBits = 0;

    if (__fileAttr & FILE_ATTRIBUTE_DIRECTORY) {
	type = @symbol(directory);
	__modeBits = 0777;   /* executable and WRITABLE - refer to comment in #isWritable: */
    } else if (__fileAttr & FILE_ATTRIBUTE_REPARSE_POINT) {
	type = @symbol(symbolicLink);
	__modeBits = 0777;   /* even in UNIX symlinks have 0777 */
    } else {
	type = @symbol(regular);
	if (__fileAttr & FILE_ATTRIBUTE_READONLY) {
	    __modeBits = 0444;
	} else {
	    __modeBits = 0666;
	}
    }
    modeBits = __mkSmallInteger(__modeBits);

%}.
    osCrtTime isNil
	ifTrue: [crtTime := Timestamp now]
	ifFalse:[crtTime := Timestamp new fromOSTime:(osCrtTime "- OperatingSystem osTimeOf19700101 -- already done")].

    osAccTime isNil
	ifTrue: [accTime := Timestamp now]
	ifFalse:[accTime := Timestamp new fromOSTime:(osAccTime "- OperatingSystem osTimeOf19700101 -- already done")].

    osModTime isNil
	ifTrue: [modTime := accTime]
	ifFalse:[modTime := Timestamp new fromOSTime:(osModTime "- OperatingSystem osTimeOf19700101 -- already done")].

    ^ FileStatusInfo
		type:type
		mode:modeBits
		uid:nil
		gid:nil
		size:fileSize
		id:0
		accessed:accTime
		modified:modTime
		created:crtTime
		sourcePath:osPathname
		fullName:nil
		alternativeName:nil.
!

nextLinkInfoFrom:aDirectoryStream dirPointer:dirPointer
    "return the next FileStatusInfo or nil at the end"

    |resultInfo error fileSize osPathname osModTime osCrtTime osAccTime osFileAttributes|

%{
    HANDLE d;
    WIN32_FIND_DATAW data;
    int rslt;

    if ((dirPointer != nil)
    && __isExternalAddressLike(dirPointer)) {
	// __INST(lastErrorNumber) = nil;
	d = _HANDLEVal(dirPointer);

	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    rslt = (int)(STX_API_NOINT_CALL2( "FindNextFileW", FindNextFileW, d, &data ));
	} while ((rslt < 0) && (__threadErrno == EINTR));

	if (rslt > 0) {
	    fileSize  = __MKLARGEINT64(1, data.nFileSizeLow, data.nFileSizeHigh);
	    osPathname = __mkStringOrU16String_maxlen( data.cFileName, MAXPATHLEN );
	    osFileAttributes = __mkSmallInteger( data.dwFileAttributes );

	    osCrtTime = FileTimeToOsTime1970(&data.ftCreationTime);
	    osAccTime = FileTimeToOsTime1970(&data.ftLastAccessTime);
	    osModTime = FileTimeToOsTime1970(&data.ftLastWriteTime);
	} else {
	    // we signal end-of-directory through a nil osPathName
	    if (__threadErrno != __WIN32_ERR(ERROR_NO_MORE_FILES))
		error = __mkSmallInteger( __threadErrno );
	}
    }
%}.
    error notNil ifTrue:[
	^ StreamIOError newException
	    errorCode:error;
	    osErrorHolder:(OperatingSystem errorHolderForNumber:error);
	    parameter:aDirectoryStream;
	    raiseRequest
    ].

    osPathname isNil ifTrue:[^ nil].

    ^ self
	linkInfoFor:osPathname
	fileSize:fileSize
	fileAttributes:osFileAttributes
	osCrtTime:osCrtTime
	osAccTime:osAccTime
	osModTime:osModTime
! !

!Win32OperatingSystem class methodsFor:'error messages'!

currentErrorNumber
    "returns the OS's last error nr (i.e. the value of errno).
     Notice, that the value of this flag is only valid immediately
     after the error occurred - it gets updated with every other
     request to the OS.
     Use lastErrorNumber - currentErrorNumber is invalidated by
     many, many internal calls."

%{  /* NOCONTEXT */

     RETURN ( __mkSmallInteger(__threadErrno) );
%}
     "
      OperatingSystem currentErrorNumber
     "
!

errorHolderForNumber:errNr
    "return an osErrorHolder for the given error number (as returned by a system call)."

    |sym typ holder|

%{
    /* claus:
     * I made this primitive code, since errnos are not
     * standard across operating systems
     */

    if (__isSmallInteger(errNr) || (__unsignedLongIntVal(errNr) > 0)) {
      int __eno = __unsignedLongIntVal(errNr);

      if (__isWIN32Error(__eno)) {
	switch (__eno & 0xFFFF) {
	    /*
	     * WIN32 GetLastError returns
	     */
	    case ERROR_INVALID_FUNCTION:
		sym = @symbol(ERROR_INVALID_FUNCTION);
		typ = @symbol(illegalOperationSignal);
		break;

	    case ERROR_BAD_FORMAT:
		sym = @symbol(ERROR_BAD_FORMAT);
		typ = @symbol(invalidArgumentsSignal);
		break;

	    case ERROR_FILE_NOT_FOUND:
		sym = @symbol(ERROR_FILE_NOT_FOUND);
		typ = @symbol(nonexistentSignal);
		break;

	    case ERROR_PATH_NOT_FOUND:
		sym = @symbol(ERROR_PATH_NOT_FOUND);
		typ = @symbol(nonexistentSignal);
		break;

	    case ERROR_TOO_MANY_OPEN_FILES:
		sym = @symbol(ERROR_TOO_MANY_OPEN_FILES);
		typ = @symbol(noResourcesSignal);
		break;

	    /*
	     * what a nice errorCode - thats the most "useful" one I ever
	     * encountered ... (... those stupid micro-softies ...)
	     */
	    case ERROR_OPEN_FAILED:
		sym = @symbol(ERROR_OPEN_FAILED);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_ACCESS_DENIED:
		sym = @symbol(ERROR_ACCESS_DENIED);
		typ = @symbol(noPermissionsSignal);
		break;

	    case ERROR_INVALID_HANDLE:
		sym = @symbol(ERROR_INVALID_HANDLE);
		typ = @symbol(invalidArgumentsSignal);
		break;

	    case ERROR_NOT_ENOUGH_MEMORY:
		sym = @symbol(ERROR_NOT_ENOUGH_MEMORY);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_NO_SYSTEM_RESOURCES:
		sym = @symbol(ERROR_NO_SYSTEM_RESOURCES);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_NONPAGED_SYSTEM_RESOURCES:
		sym = @symbol(ERROR_NONPAGED_SYSTEM_RESOURCES);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_PAGED_SYSTEM_RESOURCES:
		sym = @symbol(ERROR_PAGED_SYSTEM_RESOURCES);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_INVALID_ACCESS:
		sym = @symbol(ERROR_INVALID_ACCESS);
		typ = @symbol(inappropriateOperationSignal);
		break;

	    case ERROR_INVALID_DATA:
		sym = @symbol(ERROR_INVALID_DATA);
		typ = @symbol(invalidArgumentsSignal);
		break;

	    case ERROR_INVALID_NAME:
		sym = @symbol(ERROR_INVALID_NAME);
		typ = @symbol(invalidArgumentsSignal);
		break;

	    case ERROR_ARENA_TRASHED:
		sym = @symbol(ERROR_ARENA_TRASHED);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_OUTOFMEMORY:
		sym = @symbol(ERROR_OUTOFMEMORY);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_BROKEN_PIPE:
		sym = @symbol(ERROR_BROKEN_PIPE);
		typ = @symbol(peerFaultSignal);
		break;

	    case ERROR_GEN_FAILURE:
		sym = @symbol(ERROR_GEN_FAILURE);
		break;

	    case ERROR_WRITE_PROTECT:
		sym = @symbol(ERROR_WRITE_PROTECT);
		typ = @symbol(inappropriateOperationSignal);
		break;

	    case ERROR_WRITE_FAULT:
		sym = @symbol(ERROR_WRITE_FAULT);
		typ = @symbol(transferFaultSignal);
		break;

	    case ERROR_READ_FAULT:
		sym = @symbol(ERROR_READ_FAULT);
		typ = @symbol(transferFaultSignal);
		break;

	    case ERROR_HANDLE_DISK_FULL:
		sym = @symbol(ERROR_HANDLE_DISK_FULL);
		typ = @symbol(volumeFullSignal);
		break;

	    case ERROR_DISK_FULL:
		sym = @symbol(ERROR_DISK_FULL);
		typ = @symbol(volumeFullSignal);
		break;

	    case ERROR_SHARING_VIOLATION:
		sym = @symbol(ERROR_SHARING_VIOLATION);
		typ = @symbol(noPermissionsSignal);
		break;

	    case ERROR_LOCK_VIOLATION:
		sym = @symbol(ERROR_LOCK_VIOLATION);
		typ = @symbol(noPermissionsSignal);
		break;

	    case ERROR_INVALID_PARAMETER:
		sym = @symbol(ERROR_INVALID_PARAMETER);
		typ = @symbol(invalidArgumentsSignal);
		break;

	    case ERROR_NET_WRITE_FAULT:
		sym = @symbol(ERROR_NET_WRITE_FAULT);
		typ = @symbol(transferFaultSignal);
		break;

	    case ERROR_NOT_SUPPORTED:
		sym = @symbol(ERROR_NOT_SUPPORTED);
		typ = @symbol(inappropriateOperationSignal);
		break;

	    case ERROR_REM_NOT_LIST:
		sym = @symbol(ERROR_REM_NOT_LIST);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_NETWORK_ACCESS_DENIED:
		sym = @symbol(ERROR_NETWORK_ACCESS_DENIED);
		typ = @symbol(noPermissionsSignal);
		break;

	    case ERROR_DUP_NAME:
		sym = @symbol(ERROR_DUP_NAME);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_BAD_NETPATH:
		sym = @symbol(ERROR_BAD_NETPATH);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_NETWORK_BUSY:
		sym = @symbol(ERROR_NETWORK_BUSY);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_DRIVE_LOCKED:
		sym = @symbol(ERROR_DRIVE_LOCKED);
		typ = @symbol(inappropriateOperationSignal);
		break;

	    case ERROR_INVALID_DRIVE:
		sym = @symbol(ERROR_INVALID_DRIVE);
		typ = @symbol(invalidArgumentsSignal);
		break;

	    case ERROR_WRONG_DISK:
		sym = @symbol(ERROR_WRONG_DISK);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_CURRENT_DIRECTORY:
		sym = @symbol(ERROR_CURRENT_DIRECTORY);
		typ = @symbol(invalidArgumentsSignal);
		break;

	    /*
	     * what a nice errorCode - thats the most "useful" one I ever
	     * encountered ... (... those stupid micro-softies ...)
	     */
	    case ERROR_CANNOT_MAKE:
		sym = @symbol(ERROR_CANNOT_MAKE);
		typ = @symbol(inappropriateOperationSignal);
		break;

	    case ERROR_NO_MORE_FILES:
		sym = @symbol(ERROR_NO_MORE_FILES);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_NOT_READY:
		sym = @symbol(ERROR_NOT_READY);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_NOT_DOS_DISK:
		sym = @symbol(ERROR_NOT_DOS_DISK);
		typ = @symbol(invalidArgumentsSignal);
		break;

	    case ERROR_OUT_OF_PAPER:
		sym = @symbol(ERROR_OUT_OF_PAPER);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_PRINTQ_FULL:
		sym = @symbol(ERROR_PRINTQ_FULL);
		typ = @symbol(noResourcesSignal);
		break;

	    case ERROR_FILE_EXISTS:
		sym = @symbol(ERROR_FILE_EXISTS);
		typ = @symbol(existingReferentSignal);
		break;

	    case ERROR_ALREADY_EXISTS:
		sym = @symbol(ERROR_ALREADY_EXISTS);
		typ = @symbol(existingReferentSignal);
		break;

	    default:
		break;
	}
      } else {
	switch (__eno) {
	    /*
	     * POSIX errnos - these should be defined
	     */
#ifdef EPERM
	    case EPERM:
		sym = @symbol(EPERM);
		typ = @symbol(noPermissionsSignal);
		break;
#endif
#ifdef ENOENT
	    case ENOENT:
		sym = @symbol(ENOENT);
		typ = @symbol(nonexistentSignal);
		break;
#endif
#ifdef ESRCH
	    case ESRCH:
		sym = @symbol(ESRCH);
		typ = @symbol(unavailableReferentSignal);
		break;
#endif
#ifdef EINTR
	    case EINTR:
		sym = @symbol(EINTR);
		typ = @symbol(transientErrorSignal);
		break;
#endif
#ifdef EIO
	    case EIO:
		sym = @symbol(EIO);
		typ = @symbol(transferFaultSignal);
		break;
#endif
#ifdef ENXIO
	    case ENXIO:
		sym = @symbol(ENXIO);
		typ = @symbol(unavailableReferentSignal);
		break;
#endif
#ifdef E2BIG
	    case E2BIG:
		sym = @symbol(E2BIG);
		typ = @symbol(invalidArgumentsSignal);
		break;
#endif
#ifdef ENOEXEC
	    case ENOEXEC:
		sym = @symbol(ENOEXEC);
		typ = @symbol(inappropriateOperationSignal);
		break;
#endif
#ifdef EBADF
	    case EBADF:
		sym = @symbol(EBADF);
		typ = @symbol(badAccessorSignal);
		break;
#endif
#ifdef ECHILD
	    case ECHILD:
		sym = @symbol(ECHILD);
		typ = @symbol(informationSignal);
		break;
#endif
#if !defined(EWOULDBLOCK) && defined(EAGAIN) && (EWOULDBLOCK != EAGAIN)
	    case EAGAIN:
		sym = @symbol(EAGAIN);
		typ = @symbol(notReadySignal);
		break;
#endif
#ifdef ENOMEM
	    case ENOMEM:
		sym = @symbol(ENOMEM);
		typ = @symbol(noMemorySignal);
		break;
#endif
#ifdef EACCES
	    case EACCES:
		sym = @symbol(EACCES);
		typ = @symbol(noPermissionsSignal);
		break;
#endif
#ifdef EFAULT
	    case EFAULT:
		sym = @symbol(EFAULT);
		typ = @symbol(invalidArgumentsSignal);
		break;
#endif
#ifdef EBUSY
	    case EBUSY:
		sym = @symbol(EBUSY);
		typ = @symbol(unavailableReferentSignal);
		break;
#endif
#ifdef EEXIST
	    case EEXIST:
		sym = @symbol(EEXIST);
		typ = @symbol(existingReferentSignal);
		break;
#endif
#ifdef EXDEV
	    case EXDEV:
		sym = @symbol(EXDEV);
		typ = @symbol(inappropriateReferentSignal);
		break;
#endif
#ifdef ENODEV
	    case ENODEV:
		sym = @symbol(ENODEV);
		typ = @symbol(inaccessibleSignal);
		break;
#endif
#ifdef ENOTDIR
	    case ENOTDIR:
		sym = @symbol(ENOTDIR);
		typ = @symbol(inappropriateOperationSignal);
		break;
#endif
#ifdef EISDIR
	    case EISDIR:
		sym = @symbol(EISDIR);
		typ = @symbol(inappropriateOperationSignal);
		break;
#endif
#ifdef EINVAL
	    case EINVAL:
		sym = @symbol(EINVAL);
		typ = @symbol(invalidArgumentsSignal);
		break;
#endif
#ifdef ENFILE
	    case ENFILE:
		sym = @symbol(ENFILE);
		typ = @symbol(noResourcesSignal);
		break;
#endif
#ifdef EMFILE
	    case EMFILE:
		sym = @symbol(EMFILE);
		typ = @symbol(noResourcesSignal);
		break;
#endif
#ifdef ENOTTY
	    case ENOTTY:
		sym = @symbol(ENOTTY);
		typ = @symbol(inappropriateOperationSignal);
		break;
#endif
#ifdef EFBIG
	    case EFBIG:
		sym = @symbol(EFBIG);
		typ = @symbol(noResourcesSignal);
		break;
#endif
#ifdef ENOSPC
	    case ENOSPC:
		sym = @symbol(ENOSPC);
		typ = @symbol(noResourcesSignal);
		break;
#endif
#ifdef ESPIPE
	    case ESPIPE:
		sym = @symbol(ESPIPE);
		typ = @symbol(inappropriateOperationSignal);
		break;
#endif
#ifdef EROFS
	    case EROFS:
		sym = @symbol(EROFS);
		typ = @symbol(inappropriateOperationSignal);
		break;
#endif
#ifdef EMLINK
	    case EMLINK:
		sym = @symbol(EMLINK);
		typ = @symbol(rangeErrorSignal);
		break;
#endif
#ifdef EPIPE
	    case EPIPE:
		sym = @symbol(EPIPE);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef EDOM
	    case EDOM:
		sym = @symbol(EDOM);
		typ = @symbol(rangeErrorSignal);
		break;
#endif
#ifdef ERANGE
	    case ERANGE:
		sym = @symbol(ERANGE);
		typ = @symbol(rangeErrorSignal);
		break;
#endif
#ifdef EDEADLK
# if EDEADLK != EWOULDBLOCK
	    case EDEADLK:
		sym = @symbol(EDEADLK);
		typ = @symbol(noResourcesSignal);
		break;
# endif
#endif
#ifdef ENAMETOOLONG
	    case ENAMETOOLONG:
		sym = @symbol(ENAMETOOLONG);
		typ = @symbol(rangeErrorSignal);
		break;
#endif
#ifdef ENOLCK
	    case ENOLCK:
		sym = @symbol(ENOLCK);
		typ = @symbol(inappropriateOperationSignal);
		break;
#endif
#ifdef ENOSYS
	    case ENOSYS:
		sym = @symbol(ENOSYS);
		typ = @symbol(inappropriateOperationSignal);
		break;
#endif
#if defined(ENOTEMPTY) && (ENOTEMPTY != EEXIST)
	    case ENOTEMPTY:
		sym = @symbol(ENOTEMPTY);
		typ = @symbol(inappropriateReferentSignal);
		break;
#endif
#ifdef EILSEQ
	    case EILSEQ:
		sym = @symbol(EILSEQ);
		typ = @symbol(transferFaultSignal);
		break;
#endif
	    /*
	     * XPG3 errnos - defined on most systems
	     */
#ifdef ENOTBLK
	    case ENOTBLK:
		sym = @symbol(ENOTBLK);
		typ = @symbol(inappropriateReferentSignal);
		break;
#endif
#ifdef ETXTBSY
	    case ETXTBSY:
		sym = @symbol(ETXTBSY);
		typ = @symbol(inaccessibleSignal);
		break;
#endif
	    /*
	     * some others
	     */
#ifdef EWOULDBLOCK
	    case EWOULDBLOCK:
		sym = @symbol(EWOULDBLOCK);
		typ = @symbol(notReadySignal);
		break;
#endif
#ifdef ENOMSG
	    case ENOMSG:
		sym = @symbol(ENOMSG);
		typ = @symbol(noDataSignal);
		break;
#endif
#ifdef ELOOP
	    case ELOOP:
		sym = @symbol(ELOOP);
		typ = @symbol(rangeErrorSignal);
		break;
#endif

	    /*
	     * some stream errors
	     */
#ifdef ETIME
	    case ETIME:
		sym = @symbol(ETIME);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef ENOSR
	    case ENOSR:
		sym = @symbol(ENOSR);
		typ = @symbol(noResourcesSignal);
		break;
#endif
#ifdef ENOSTR
	    case ENOSTR:
		sym = @symbol(ENOSTR);
		typ = @symbol(inappropriateReferentSignal);
		break;
#endif
#ifdef ECOMM
	    case ECOMM:
		sym = @symbol(ECOMM);
		typ = @symbol(transferFaultSignal);
		break;
#endif
#ifdef EPROTO
	    case EPROTO:
		sym = @symbol(EPROTO);
		typ = @symbol(inappropriateOperationSignal);
		break;
#endif
	    /*
	     * nfs errors
	     */
#ifdef ESTALE
	    case ESTALE:
		sym = @symbol(ESTALE);
		typ = @symbol(unavailableReferentSignal);
		break;
#endif
#ifdef EREMOTE
	    case EREMOTE:
		sym = @symbol(EREMOTE);
		typ = @symbol(rangeErrorSignal);
		break;
#endif
	    /*
	     * some networking errors
	     */
#ifdef EINPROGRESS
	    case EINPROGRESS:
		sym = @symbol(EINPROGRESS);
		typ = @symbol(operationStartedSignal);
		break;
#endif
#ifdef EALREADY
	    case EALREADY:
		sym = @symbol(EALREADY);
		typ = @symbol(operationStartedSignal);
		break;
#endif
#ifdef ENOTSOCK
	    case ENOTSOCK:
		sym = @symbol(ENOTSOCK);
		typ = @symbol(inappropriateOperationSignal);
		break;
#endif
#ifdef EDESTADDRREQ
	    case EDESTADDRREQ:
		sym = @symbol(EDESTADDRREQ);
		typ = @symbol(underspecifiedSignal);
		break;
#endif
#ifdef EMSGSIZE
	    case EMSGSIZE:
		sym = @symbol(EMSGSIZE);
		typ = @symbol(rangeErrorSignal);
		break;
#endif
#ifdef EPROTOTYPE
	    case EPROTOTYPE:
		sym = @symbol(EPROTOTYPE);
		typ = @symbol(wrongSubtypeForOperationSignal);
		break;
#endif
#ifdef ENOPROTOOPT
	    case ENOPROTOOPT:
		sym = @symbol(ENOPROTOOPT);
		typ = @symbol(unsupportedOperationSignal);
		break;
#endif
#ifdef EPROTONOSUPPORT
	    case EPROTONOSUPPORT:
		sym = @symbol(EPROTONOSUPPORT);
		typ = @symbol(unsupportedOperationSignal);
		break;
#endif
#ifdef ESOCKTNOSUPPORT
	    case ESOCKTNOSUPPORT:
		sym = @symbol(ESOCKTNOSUPPORT);
		typ = @symbol(unsupportedOperationSignal);
		break;
#endif
#ifdef EOPNOTSUPP
	    case EOPNOTSUPP:
		sym = @symbol(EOPNOTSUPP);
		typ = @symbol(inappropriateOperationSignal);
		break;
#endif
#ifdef EPFNOSUPPORT
	    case EPFNOSUPPORT:
		sym = @symbol(EPFNOSUPPORT);
		typ = @symbol(unsupportedOperationSignal);
		break;
#endif
#ifdef EAFNOSUPPORT
	    case EAFNOSUPPORT:
		sym = @symbol(EAFNOSUPPORT);
		typ = @symbol(unsupportedOperationSignal);
		break;
#endif
#ifdef EADDRINUSE
	    case EADDRINUSE:
		sym = @symbol(EADDRINUSE);
		typ = @symbol(existingReferentSignal);
		break;
#endif
#ifdef WSAEADDRINUSE
	    case WSAEADDRINUSE:
		sym = @symbol(WSAEADDRINUSE);
		typ = @symbol(existingReferentSignal);
		break;
#endif

#ifdef EADDRNOTAVAIL
	    case EADDRNOTAVAIL:
		sym = @symbol(EADDRNOTAVAIL);
		typ = @symbol(noPermissionsSignal);
		break;
#endif
#ifdef ETIMEDOUT
	    case ETIMEDOUT:
		sym = @symbol(ETIMEDOUT);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef WSAETIMEDOUT
	    case WSAETIMEDOUT:
		sym = @symbol(ETIMEDOUT);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef ECONNREFUSED
	    case ECONNREFUSED:
		sym = @symbol(ECONNREFUSED);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef WSAECONNREFUSED
	    case WSAECONNREFUSED:
		sym = @symbol(ECONNREFUSED);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef ENETDOWN
	    case ENETDOWN:
		sym = @symbol(ENETDOWN);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef ENETUNREACH
	    case ENETUNREACH:
		sym = @symbol(ENETUNREACH);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef ENETRESET
	    case ENETRESET:
		sym = @symbol(ENETRESET);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef ECONNABORTED
	    case ECONNABORTED:
		sym = @symbol(ECONNABORTED);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef ECONNRESET
	    case ECONNRESET:
		sym = @symbol(ECONNRESET);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef EISCONN
	    case EISCONN:
		sym = @symbol(EISCONN);
		typ = @symbol(unpreparedOperationSignal);
		break;
#endif
#ifdef ENOTCONN
	    case ENOTCONN:
		sym = @symbol(ENOTCONN);
		typ = @symbol(unpreparedOperationSignal);
		break;
#endif
#ifdef ESHUTDOWN
	    case ESHUTDOWN:
		sym = @symbol(ESHUTDOWN);
		typ = @symbol(unpreparedOperationSignal);
		break;
#endif
#ifdef EHOSTDOWN
	    case EHOSTDOWN:
		sym = @symbol(EHOSTDOWN);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef EHOSTUNREACH
	    case EHOSTUNREACH:
		sym = @symbol(EHOSTUNREACH);
		typ = @symbol(peerFaultSignal);
		break;
#endif
#ifdef WSAHOSTUNREACH
	    case WSAHOSTUNREACH:
		sym = @symbol(EHOSTUNREACH);
		typ = @symbol(peerFaultSignal);
		break;
#endif

#ifdef WSAEFAULT
	    case WSAEFAULT:
		sym = @symbol(WSAEFAULT);
		typ = @symbol(invalidArgumentsSignal);
		break;
#endif
#ifdef WSAEINTR
	    case WSAEINTR:
		sym = @symbol(WSAEINTR);
		typ = @symbol(transientErrorSignal);
		break;
#endif
#ifdef WSAEBADF
	    case WSAEBADF:
		sym = @symbol(WSAEBADF);
		typ = @symbol(badAccessorSignal);
		break;
#endif
#ifdef WSAEACCES
	    case WSAEACCES:
		sym = @symbol(WSAEACCES);
		typ = @symbol(badAccessorSignal);
		break;
#endif
#ifdef WSAEINVAL
	    case WSAEINVAL:
		sym = @symbol(WSAEINVAL);
		typ = @symbol(invalidArgumentsSignal);
		break;
#endif
#ifdef WSAEMFILE
	    case WSAEMFILE:
		sym = @symbol(WSAEMFILE);
		typ = @symbol(noResourcesSignal);
		break;
#endif
#ifdef WSAEWOULDBLOCK
	    case WSAEWOULDBLOCK:
		sym = @symbol(WSAEWOULDBLOCK);
		typ = @symbol(notReadySignal);
		break;
#endif
#ifdef WSAEINPROGRESS
	    case WSAEINPROGRESS:
		sym = @symbol(WSAEINPROGRESS);
		typ = @symbol(operationStartedSignal);
		break;
#endif
#ifdef WSAEALREADY
	    case WSAEALREADY:
		sym = @symbol(WSAEALREADY);
		typ = @symbol(operationStartedSignal);
		break;
#endif
#ifdef WSAENOTSOCK
	    case WSAENOTSOCK:
		sym = @symbol(WSAENOTSOCK);
		typ = @symbol(inappropriateOperationSignal);
		break;
#endif
#ifdef WSAEPROTONOSUPPORT
	    case WSAEPROTONOSUPPORT:
		sym = @symbol(WSAEPROTONOSUPPORT);
		typ = @symbol(unsupportedOperationSignal);
		break;
#endif
#ifdef WSAESOCKTNOSUPPORT
	    case WSAESOCKTNOSUPPORT:
		sym = @symbol(WSAESOCKTNOSUPPORT);
		typ = @symbol(unsupportedOperationSignal);
		break;
#endif
#ifdef E_NOINTERFACE
	    case E_NOINTERFACE:
		sym = @symbol(E_NOINTERFACE);
		typ = @symbol(noInterfaceSignal);
		break;
#endif
#ifdef CO_E_NOTINITIALIZED
	    case CO_E_NOTINITIALIZED:
		sym = @symbol(CO_E_NOTINITIALIZED);
		typ = @symbol(coNotInitializedSignal);
		break;
#endif
#ifdef REGDB_E_CLASSNOTREG
	    case REGDB_E_CLASSNOTREG:
		sym = @symbol(REGDB_E_CLASSNOTREG);
		typ = @symbol(classNotRegisteredSignal);
		break;
#endif
#ifdef CLASS_E_NOAGGREGATION
	    case CLASS_E_NOAGGREGATION:
		sym = @symbol(CLASS_E_NOAGGREGATION);
		typ = @symbol(noAggregationSignal);
		break;
#endif
#ifdef DISP_E_UNKNOWNNAME
	    case DISP_E_UNKNOWNNAME:
		sym = @symbol(DISP_E_UNKNOWNNAME);
		typ = @symbol(unknownNameSignal);
		break;
#endif
#ifdef OLEOBJ_E_NOVERBS
	    case OLEOBJ_E_NOVERBS:
		sym = @symbol(OLEOBJ_E_NOVERBS);
		typ = @symbol(noVerbsSignal);
		break;
#endif

	    default:
		break;
	}
      }
    }
%}.
    holder := OSErrorHolder new.
    sym isNil ifTrue:[
	sym := #ERROR_OTHER.
	errNr notNil ifTrue:[
	    "keep symbols as symbols"
	    holder parameter:(errNr isString ifTrue:[errNr] ifFalse:[errNr asString]).
	].
    ].
    holder errorSymbol:sym errorCategory:typ.
    ^ holder


    "
     OperatingSystem errorHolderForNumber:4
     OperatingSystem errorHolderForNumber:#badArgument
     self errorHolderForNumber:16777296
     self errorHolderForNumber:(self errorNumberFor:#EPERM)
     self errorHolderForNumber:(self errorNumberFor:#EIO)
     self errorHolderForNumber:(self errorNumberFor:#ENXIO)
     self errorHolderForNumber:(self errorNumberFor:#E_NOINTERFACE)
    "
!

errorNumberFor:aSymbol
    "given a symbolic error, return the numeric;
     (i.e. errorNumberFor:#EBADF returns EBADF's value).
     Use this, since error numbers are really not standard across unix systems."

%{   /* NOCONTEXT */
    OBJ sym = aSymbol;

    /*
     * WIN32 GetLastError error codes - use __WIN32_ERR() to return the same as
     * the smalltalk methods
     */
#ifdef ERROR_INVALID_FUNCTION
    if (sym == @symbol(ERROR_INVALID_FUNCTION)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_INVALID_FUNCTION)) );
    }
#endif
#ifdef ERROR_BAD_FORMAT
    if (sym == @symbol(ERROR_BAD_FORMAT)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_BAD_FORMAT)));
    }
#endif
#ifdef ERROR_FILE_NOT_FOUND
    if (sym == @symbol(ERROR_FILE_NOT_FOUND)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_FILE_NOT_FOUND)));
    }
#endif
#ifdef ERROR_PATH_NOT_FOUND
    if (sym == @symbol(ERROR_PATH_NOT_FOUND)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_PATH_NOT_FOUND)));
    }
#endif
#ifdef ERROR_TOO_MANY_OPEN_FILES
    if (sym == @symbol(ERROR_TOO_MANY_OPEN_FILES)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_TOO_MANY_OPEN_FILES)));
    }
#endif
#ifdef ERROR_OPEN_FAILED
    if (sym == @symbol(ERROR_OPEN_FAILED)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_OPEN_FAILED)));
    }
#endif
#ifdef ERROR_ACCESS_DENIED
    if (sym == @symbol(ERROR_ACCESS_DENIED)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_ACCESS_DENIED)));
    }
#endif
#ifdef ERROR_INVALID_HANDLE
    if (sym == @symbol(ERROR_INVALID_HANDLE)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_INVALID_HANDLE)));
    }
#endif
#ifdef ERROR_NOT_ENOUGH_MEMORY
    if (sym == @symbol(ERROR_NOT_ENOUGH_MEMORY)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_NOT_ENOUGH_MEMORY)));
    }
#endif
#ifdef ERROR_NO_SYSTEM_RESOURCES
    if (sym == @symbol(ERROR_NO_SYSTEM_RESOURCES)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_NO_SYSTEM_RESOURCES)));
    }
#endif
#ifdef ERROR_INVALID_ACCESS
    if (sym == @symbol(ERROR_INVALID_ACCESS)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_INVALID_ACCESS)));
    }
#endif
#ifdef ERROR_INVALID_DATA
    if (sym == @symbol(ERROR_INVALID_DATA)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_INVALID_DATA)));
    }
#endif
#ifdef ERROR_INVALID_NAME
    if (sym == @symbol(ERROR_INVALID_NAME)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_INVALID_NAME)));
    }
#endif
#ifdef ERROR_ARENA_TRASHED
    if (sym == @symbol(ERROR_ARENA_TRASHED)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_ARENA_TRASHED)));
    }
#endif
#ifdef ERROR_OUTOFMEMORY
    if (sym == @symbol(ERROR_OUTOFMEMORY)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_OUTOFMEMORY)));
    }
#endif
#ifdef ERROR_BROKEN_PIPE
    if (sym == @symbol(ERROR_BROKEN_PIPE)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_BROKEN_PIPE)));
    }
#endif
#ifdef ERROR_GEN_FAILURE
    if (sym == @symbol(ERROR_GEN_FAILURE)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_GEN_FAILURE)));
    }
#endif
#ifdef ERROR_WRITE_PROTECT
    if (sym == @symbol(ERROR_WRITE_PROTECT)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_WRITE_PROTECT)));
    }
#endif
#ifdef ERROR_WRITE_FAULT
    if (sym == @symbol(ERROR_WRITE_FAULT)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_WRITE_FAULT)));
    }
#endif
#ifdef ERROR_READ_FAULT
    if (sym == @symbol(ERROR_READ_FAULT)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_READ_FAULT)));
    }
#endif
#ifdef ERROR_HANDLE_DISK_FULL
    if (sym == @symbol(ERROR_HANDLE_DISK_FULL)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_HANDLE_DISK_FULL)));
    }
#endif
#ifdef ERROR_DISK_FULL
    if (sym == @symbol(ERROR_DISK_FULL)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_DISK_FULL)));
    }
#endif
#ifdef ERROR_SHARING_VIOLATION
    if (sym == @symbol(ERROR_SHARING_VIOLATION)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_SHARING_VIOLATION)));
    }
#endif
#ifdef ERROR_LOCK_VIOLATION
    if (sym == @symbol(ERROR_LOCK_VIOLATION)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_LOCK_VIOLATION)));
    }
#endif
#ifdef ERROR_INVALID_PARAMETER
    if (sym == @symbol(ERROR_INVALID_PARAMETER)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_INVALID_PARAMETER)));
    }
#endif
#ifdef ERROR_NET_WRITE_FAULT
    if (sym == @symbol(ERROR_NET_WRITE_FAULT)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_NET_WRITE_FAULT)));
    }
#endif
#ifdef ERROR_NOT_SUPPORTED
    if (sym == @symbol(ERROR_NOT_SUPPORTED)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_NOT_SUPPORTED)));
    }
#endif
#ifdef ERROR_REM_NOT_LIST
    if (sym == @symbol(ERROR_REM_NOT_LIST)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_REM_NOT_LIST)));
    }
#endif
#ifdef ERROR_NETWORK_ACCESS_DENIED
    if (sym == @symbol(ERROR_NETWORK_ACCESS_DENIED)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_NETWORK_ACCESS_DENIED)));
    }
#endif
#ifdef ERROR_DUP_NAME
    if (sym == @symbol(ERROR_DUP_NAME)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_DUP_NAME)));
    }
#endif
#ifdef ERROR_BAD_NETPATH
    if (sym == @symbol(ERROR_BAD_NETPATH)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_BAD_NETPATH)));
    }
#endif
#ifdef ERROR_NETWORK_BUSY
    if (sym == @symbol(ERROR_NETWORK_BUSY)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_NETWORK_BUSY)));
    }
#endif
#ifdef ERROR_DRIVE_LOCKED
    if (sym == @symbol(ERROR_DRIVE_LOCKED)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_DRIVE_LOCKED)));
    }
#endif
#ifdef ERROR_INVALID_DRIVE
    if (sym == @symbol(ERROR_INVALID_DRIVE)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_INVALID_DRIVE)));
    }
#endif
#ifdef ERROR_WRONG_DISK
    if (sym == @symbol(ERROR_WRONG_DISK)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_WRONG_DISK)));
    }
#endif
#ifdef ERROR_CURRENT_DIRECTORY
    if (sym == @symbol(ERROR_CURRENT_DIRECTORY)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_CURRENT_DIRECTORY)));
    }
#endif
#ifdef ERROR_FILE_EXISTS
    if (sym == @symbol(ERROR_FILE_EXISTS)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_FILE_EXISTS)));
    }
#endif
#ifdef ERROR_ALREADY_EXISTS
    if (sym == @symbol(ERROR_FILE_EXISTS)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_ALREADY_EXISTS)));
    }
#endif
#ifdef ERROR_CANNOT_MAKE
    if (sym == @symbol(ERROR_CANNOT_MAKE)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_CANNOT_MAKE)));
    }
#endif
#ifdef ERROR_NO_MORE_FILES
    if (sym == @symbol(ERROR_NO_MORE_FILES)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_NO_MORE_FILES)));
    }
#endif
#ifdef ERROR_NOT_READY
    if (sym == @symbol(ERROR_NOT_READY)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_NOT_READY)));
    }
#endif
#ifdef ERROR_NOT_DOS_DISK
    if (sym == @symbol(ERROR_NOT_DOS_DISK)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_NOT_DOS_DISK)));
    }
#endif
#ifdef ERROR_OUT_OF_PAPER
    if (sym == @symbol(ERROR_OUT_OF_PAPER)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_OUT_OF_PAPER)));
    }
#endif
#ifdef ERROR_PRINTQ_FULL
    if (sym == @symbol(ERROR_PRINTQ_FULL)) {
	RETURN ( __mkSmallInteger(__WIN32_ERR(ERROR_PRINTQ_FULL)));
    }
#endif

    /*
     * POSIX errnos - these should be defined
     */
#ifdef EPERM
    if (sym == @symbol(EPERM)) {
	RETURN ( __mkSmallInteger(EPERM) );
    }
#endif

#ifdef ENOENT
    if (sym == @symbol(ENOENT)) {
	RETURN ( __mkSmallInteger(ENOENT) );
    }
#endif

#ifdef ESRCH
    if (sym == @symbol(ESRCH)) {
	RETURN ( __mkSmallInteger(ESRCH) );
    }
#endif

#ifdef EINTR
    if (sym == @symbol(EINTR)) {
	RETURN ( __mkSmallInteger(EINTR) );
    }
#endif

#ifdef EIO
    if (sym == @symbol(EIO)) {
	RETURN ( __mkSmallInteger(EIO) );
    }
#endif

#ifdef ENXIO
    if (sym == @symbol(ENXIO)) {
	RETURN ( __mkSmallInteger(ENXIO) );
    }
#endif

#ifdef E2BIG
    if (sym == @symbol(E2BIG)) {
	RETURN ( __mkSmallInteger(E2BIG) );
    }
#endif

#ifdef ENOEXEC
    if (sym == @symbol(ENOEXEC)) {
	RETURN ( __mkSmallInteger(ENOEXEC) );
    }
#endif

#ifdef EBADF
    if (sym == @symbol(EBADF)) {
	RETURN ( __mkSmallInteger(EBADF) );
    }
#endif

#ifdef ECHILD
    if (sym == @symbol(ECHILD)) {
	RETURN ( __mkSmallInteger(ECHILD) );
    }
#endif

#if defined(EAGAIN)
    if (sym == @symbol(EAGAIN)) {
	RETURN ( __mkSmallInteger(EAGAIN) );
    }
#endif

#ifdef ENOMEM
    if (sym == @symbol(ENOMEM)) {
	RETURN ( __mkSmallInteger(ENOMEM) );
    }
#endif

#ifdef EACCES
    if (sym == @symbol(EACCES)) {
	RETURN ( __mkSmallInteger(EACCES) );
    }
#endif

#ifdef EFAULT
    if (sym == @symbol(EFAULT)) {
	RETURN ( __mkSmallInteger(EFAULT) );
    }
#endif

#ifdef EBUSY
    if (sym == @symbol(EBUSY)) {
	RETURN ( __mkSmallInteger(EBUSY) );
    }
#endif

#ifdef EXDEV
    if (sym == @symbol(EXDEV)) {
	RETURN ( __mkSmallInteger(EXDEV) );
    }
#endif

#ifdef ENODEV
    if (sym == @symbol(ENODEV)) {
	RETURN ( __mkSmallInteger(ENODEV) );
    }
#endif

#ifdef ENOTDIR
    if (sym == @symbol(ENOTDIR)) {
	RETURN ( __mkSmallInteger(ENOTDIR) );
    }
#endif

#ifdef EISDIR
    if (sym == @symbol(EISDIR)) {
	RETURN ( __mkSmallInteger(EISDIR) );
    }
#endif

#ifdef EINVAL
    if (sym == @symbol(EINVAL)) {
	RETURN ( __mkSmallInteger(EINVAL) );
    }
#endif

#ifdef ENFILE
    if (sym == @symbol(ENFILE)) {
	RETURN ( __mkSmallInteger(ENFILE) );
    }
#endif

#ifdef EMFILE
    if (sym == @symbol(EMFILE)) {
	RETURN ( __mkSmallInteger(EMFILE) );
    }
#endif

#ifdef ENOTTY
    if (sym == @symbol(ENOTTY)) {
	RETURN ( __mkSmallInteger(ENOTTY) );
    }
#endif

#ifdef EFBIG
    if (sym == @symbol(EFBIG)) {
	RETURN ( __mkSmallInteger(EFBIG) );
    }
#endif

#ifdef ENOSPC
    if (sym == @symbol(ENOSPC)) {
	RETURN ( __mkSmallInteger(ENOSPC) );
    }
#endif

#ifdef ESPIPE
    if (sym == @symbol(ESPIPE)) {
	RETURN ( __mkSmallInteger(ESPIPE) );
    }
#endif

#ifdef EROFS
    if (sym == @symbol(EROFS)) {
	RETURN ( __mkSmallInteger(EROFS) );
    }
#endif

#ifdef EMLINK
    if (sym == @symbol(EMLINK)) {
	RETURN ( __mkSmallInteger(EMLINK) );
    }
#endif

#ifdef EPIPE
    if (sym == @symbol(EPIPE)) {
	RETURN ( __mkSmallInteger(EPIPE) );
    }
#endif

#ifdef EDOM
    if (sym == @symbol(EDOM)) {
	RETURN ( __mkSmallInteger(EDOM) );
    }
#endif

#ifdef ERANGE
    if (sym == @symbol(ERANGE)) {
	RETURN ( __mkSmallInteger(ERANGE) );
    }
#endif

#ifdef EDEADLK
    if (sym == @symbol(EDEADLK)) {
	RETURN ( __mkSmallInteger(EDEADLK) );
    }
#endif

#ifdef ENAMETOOLONG
    if (sym == @symbol(ENAMETOOLONG)) {
	RETURN ( __mkSmallInteger(ENAMETOOLONG) );
    }
#endif

#ifdef ENOLCK
    if (sym == @symbol(ENOLCK)) {
	RETURN ( __mkSmallInteger(ENOLCK) );
    }
#endif

#ifdef ENOSYS
    if (sym == @symbol(ENOSYS)) {
	RETURN ( __mkSmallInteger(ENOSYS) );
    }
#endif

#ifdef ENOTEMPTY
    if (sym == @symbol(ENOTEMPTY)) {
	RETURN ( __mkSmallInteger(ENOTEMPTY) );
    }
#endif

#ifdef EEXIST
    if (sym == @symbol(EEXIST)) {
	RETURN ( __mkSmallInteger(EEXIST) );
    }
#endif

#ifdef EILSEQ
    if (sym == @symbol(EILSEQ)) {
	RETURN ( __mkSmallInteger(EILSEQ) );
    }
#endif

    /*
     * XPG3 errnos - defined on most systems
     */
#ifdef ENOTBLK
    if (sym == @symbol(ENOTBLK)) {
	RETURN ( __mkSmallInteger(ENOTBLK) );
    }
#endif

#ifdef ETXTBSY
    if (sym == @symbol(ETXTBSY)) {
	RETURN ( __mkSmallInteger(ETXTBSY) );
    }
#endif

    /*
     * some others
     */
#ifdef EWOULDBLOCK
    if (sym == @symbol(EWOULDBLOCK)) {
	RETURN ( __mkSmallInteger(EWOULDBLOCK) );
    }
#endif

#ifdef ENOMSG
    if (sym == @symbol(ENOMSG)) {
	RETURN ( __mkSmallInteger(ENOMSG) );
    }
#endif

#ifdef ELOOP
    if (sym == @symbol(ELOOP)) {
	RETURN ( __mkSmallInteger(ELOOP) );
    }
#endif

    /*
     * some stream errors
     */
#ifdef ETIME
    if (sym == @symbol(ETIME)) {
	RETURN ( __mkSmallInteger(ETIME) );
    }
#endif

#ifdef ENOSR
    if (sym == @symbol(ENOSR)) {
	RETURN ( __mkSmallInteger(ENOSR) );
    }
#endif

#ifdef ENOSTR
    if (sym == @symbol(ENOSTR)) {
	RETURN ( __mkSmallInteger(ENOSTR) );
    }
#endif

#ifdef ECOMM
    if (sym == @symbol(ECOMM)) {
	RETURN ( __mkSmallInteger(ECOMM) );
    }
#endif

#ifdef EPROTO
    if (sym == @symbol(EPROTO)) {
	RETURN ( __mkSmallInteger(EPROTO) );
    }
#endif

    /*
     * nfs errors
     */
#ifdef ESTALE
    if (sym == @symbol(ESTALE)) {
	RETURN ( __mkSmallInteger(ESTALE) );
    }
#endif

#ifdef EREMOTE
    if (sym == @symbol(EREMOTE)) {
	RETURN ( __mkSmallInteger(EREMOTE) );
    }
#endif

    /*
     * some networking errors
     */
#ifdef EINPROGRESS
    if (sym == @symbol(EINPROGRESS)) {
	RETURN ( __mkSmallInteger(EINPROGRESS) );
    }
#endif

#ifdef EALREADY
    if (sym == @symbol(EALREADY)) {
	RETURN ( __mkSmallInteger(EALREADY) );
    }
#endif

#ifdef ENOTSOCK
    if (sym == @symbol(ENOTSOCK)) {
	RETURN ( __mkSmallInteger(ENOTSOCK) );
    }
#endif

#ifdef EDESTADDRREQ
    if (sym == @symbol(EDESTADDRREQ)) {
	RETURN ( __mkSmallInteger(EDESTADDRREQ) );
    }
#endif

#ifdef EMSGSIZE
    if (sym == @symbol(EMSGSIZE)) {
	RETURN ( __mkSmallInteger(EMSGSIZE) );
    }
#endif

#ifdef EPROTOTYPE
    if (sym == @symbol(EPROTOTYPE)) {
	RETURN ( __mkSmallInteger(EPROTOTYPE) );
    }
#endif

#ifdef ENOPROTOOPT
    if (sym == @symbol(ENOPROTOOPT)) {
	RETURN ( __mkSmallInteger(ENOPROTOOPT) );
    }
#endif

#ifdef EPROTONOSUPPORT
    if (sym == @symbol(EPROTONOSUPPORT)) {
	RETURN ( __mkSmallInteger(EPROTONOSUPPORT) );
    }
#endif

#ifdef ESOCKTNOSUPPORT
    if (sym == @symbol(ESOCKTNOSUPPORT)) {
	RETURN ( __mkSmallInteger(ESOCKTNOSUPPORT) );
    }
#endif

#ifdef EOPNOTSUPP
    if (sym == @symbol(EOPNOTSUPP)) {
	RETURN ( __mkSmallInteger(EOPNOTSUPP) );
    }
#endif

#ifdef EPFNOSUPPORT
    if (sym == @symbol(EPFNOSUPPORT)) {
	RETURN ( __mkSmallInteger(EPFNOSUPPORT) );
    }
#endif

#ifdef EAFNOSUPPORT
    if (sym == @symbol(EAFNOSUPPORT)) {
	RETURN ( __mkSmallInteger(EAFNOSUPPORT) );
    }
#endif

#ifdef EADDRINUSE
    if (sym == @symbol(EADDRINUSE)) {
	RETURN ( __mkSmallInteger(EADDRINUSE) );
    }
#endif

#ifdef EADDRNOTAVAIL
    if (sym == @symbol(EADDRNOTAVAIL)) {
	RETURN ( __mkSmallInteger(EADDRNOTAVAIL) );
    }
#endif

#ifdef ETIMEDOUT
    if (sym == @symbol(ETIMEDOUT)) {
	RETURN ( __mkSmallInteger(ETIMEDOUT) );
    }
#endif
#ifdef WSAETIMEDOUT
    if (sym == @symbol(ETIMEDOUT)) {
	RETURN ( __mkSmallInteger(WSAETIMEDOUT) );
    }
#endif

#ifdef ECONNREFUSED
    if (sym == @symbol(ECONNREFUSED)) {
	RETURN ( __mkSmallInteger(ECONNREFUSED) );
    }
#endif

#ifdef ENETDOWN
    if (sym == @symbol(ENETDOWN)) {
	RETURN ( __mkSmallInteger(ENETDOWN) );
    }
#endif

#ifdef ENETUNREACH
    if (sym == @symbol(ENETUNREACH)) {
	RETURN ( __mkSmallInteger(ENETUNREACH) );
    }
#endif

#ifdef ENETRESET
    if (sym == @symbol(ENETRESET)) {
	RETURN ( __mkSmallInteger(ENETRESET) );
    }
#endif

#ifdef ECONNABORTED
    if (sym == @symbol(ECONNABORTED)) {
	RETURN ( __mkSmallInteger(ECONNABORTED) );
    }
#endif

#ifdef ECONNRESET
    if (sym == @symbol(ECONNRESET)) {
	RETURN ( __mkSmallInteger(ECONNRESET) );
    }
#endif

#ifdef EISCONN
    if (sym == @symbol(EISCONN)) {
	RETURN ( __mkSmallInteger(EISCONN) );
    }
#endif

#ifdef ENOTCONN
    if (sym == @symbol(ENOTCONN)) {
	RETURN ( __mkSmallInteger(ENOTCONN) );
    }
#endif

#ifdef ESHUTDOWN
    if (sym == @symbol(ESHUTDOWN)) {
	RETURN ( __mkSmallInteger(ESHUTDOWN) );
    }
#endif

#ifdef EHOSTDOWN
    if (sym == @symbol(EHOSTDOWN)) {
	RETURN ( __mkSmallInteger(EHOSTDOWN) );
    }
#endif

#ifdef EHOSTUNREACH
    if (sym == @symbol(EHOSTUNREACH)) {
	RETURN ( __mkSmallInteger(EHOSTUNREACH) );
    }
#endif
    /*
     * windows socket errors
     */
#ifdef WSAEINTR
    if (sym == @symbol(WSAEINTR)) {
	RETURN ( __mkSmallInteger(WSAEINTR) );
    }
#endif
#ifdef WSAEBADF
    if (sym == @symbol(WSAEBADF)) {
	RETURN ( __mkSmallInteger(WSAEBADF) );
    }
#endif
#ifdef WSAEACCESS
    if (sym == @symbol(WSAEACCESS)) {
	RETURN ( __mkSmallInteger(WSAEACCESS) );
    }
#endif
#ifdef WSAEFAULT
    if (sym == @symbol(WSAEFAULT)) {
	RETURN ( __mkSmallInteger(WSAEFAULT) );
    }
#endif
#ifdef WSAEINVAL
    if (sym == @symbol(WSAEINVAL)) {
	RETURN ( __mkSmallInteger(WSAEINVAL) );
    }
#endif
#ifdef WSAEMFILE
    if (sym == @symbol(WSAEMFILE)) {
	RETURN ( __mkSmallInteger(WSAEMFILE) );
    }
#endif
#ifdef WSAEWOULDBLOCK
    if (sym == @symbol(WSAEWOULDBLOCK)) {
	RETURN ( __mkSmallInteger(WSAEWOULDBLOCK) );
    }
#endif
#ifdef WSAEINPROGRESS
    if (sym == @symbol(WSAEINPROGRESS)) {
	RETURN ( __mkSmallInteger(WSAEINPROGRESS) );
    }
#endif
#ifdef WSAEALREADY
    if (sym == @symbol(WSAEALREADY)) {
	RETURN ( __mkSmallInteger(WSAEALREADY) );
    }
#endif
#ifdef WSAENOTSOCK
    if (sym == @symbol(WSAENOTSOCK)) {
	RETURN ( __mkSmallInteger(WSAENOTSOCK) );
    }
#endif
#ifdef WSAEPROTONOSUPPORT
    if (sym == @symbol(WSAEPROTONOSUPPORT)) {
	RETURN ( __mkSmallInteger(WSAEPROTONOSUPPORT) );
    }
#endif
#ifdef WSAESOCKTNOSUPPORT
    if (sym == @symbol(WSAESOCKTNOSUPPORT)) {
	RETURN ( __mkSmallInteger(WSAESOCKTNOSUPPORT) );
    }
#endif
#ifdef E_NOINTERFACE
    if (sym == @symbol(E_NOINTERFACE)) {
	RETURN ( __MKUINT(E_NOINTERFACE) );
    }
#endif
#ifdef CO_E_NOTINITIALIZED
    if (sym == @symbol(CO_E_NOTINITIALIZED)) {
	RETURN ( __MKUINT(CO_E_NOTINITIALIZED) );
    }
#endif
#ifdef REGDB_E_CLASSNOTREG
    if (sym == @symbol(REGDB_E_CLASSNOTREG)) {
	RETURN ( __MKUINT(REGDB_E_CLASSNOTREG) );
    }
#endif
#ifdef CLASS_E_NOAGGREGATION
    if (sym == @symbol(CLASS_E_NOAGGREGATION)) {
	RETURN ( __MKUINT(CLASS_E_NOAGGREGATION) );
    }
#endif
#ifdef DISP_E_UNKNOWNNAME
    if (sym == @symbol(DISP_E_UNKNOWNNAME)) {
	RETURN ( __MKUINT(DISP_E_UNKNOWNNAME) );
    }
#endif
#ifdef OLEOBJ_E_NOVERBS
    if (sym == @symbol(OLEOBJ_E_NOVERBS)) {
	RETURN ( __MKUINT(OLEOBJ_E_NOVERBS) );
    }
#endif

%}.
    ^ -1
! !

!Win32OperatingSystem class methodsFor:'executing OS commands'!

canExecuteCommand:aCommandString
    "return true, if the OS can execute aCommand."

"/    |fn|
"/
"/    fn := aCommandString asFilename.
"/    ( #('com' 'exe') includes:fn suffix) ifFalse:[^ false].
    ^ super canExecuteCommand:aCommandString

    "
     OperatingSystem canExecuteCommand:'fooBar'
     OperatingSystem canExecuteCommand:'ls'
     OperatingSystem canExecuteCommand:'cvs'
     OperatingSystem canExecuteCommand:'diff'
     OperatingSystem canExecuteCommand:'cvs.exe'
     OperatingSystem canExecuteCommand:'C:\Dokumente und Einstellungen\penk\work\stx\projects\smalltalk\cvs.exe'
     OperatingSystem canExecuteCommand:'C:\Windows\cvs.exe'
     OperatingSystem canExecuteCommand:'C:\Windows\system32\mspaint.exe'
    "

    "Created: 4.11.1995 / 19:13:54 / cg"
!

commandAndArgsForOSCommand:aCommandString
    "get a shell and shell arguments for command execution.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.exe' in your Windows manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the next elements are the arguments to the command. No shell is invoked in this case.
     Answer am Array with the command string as the first element,
     the arguments (a String) as second element,
     and whether a window should be opened (true, false or nil = let the executed program determine)
     as third element."

    |shell args wDir cmdName path|

    aCommandString isNonByteCollection ifTrue:[
	"easy: the caller does not want a shell to be executed"
	^ Array with:aCommandString first with:(aCommandString asStringWith:' ') with:nil.
    ].

    "/
    "/ 'x:\WINDOWS\System32\cmd /c <command>'
    "/ or 'x:\WINDOWS\System\cmd /c <command>'
    "/ or whatever ...
    "/

    "/ to workaround a bug in win95's command.com
    "/ (which always returns a 0-exit code
    "/  - even if the command failed),
    "/ Here, we see if the command is found along the path and
    "/ call it directly if found.
    "/ If not found, assume its a builtIn or batch command
    "/ and pass it to cmd.exe.
    "/ Also use cmd.exe, if any I/O redirection is
    "/ involved, since that is (not yet) handled here.
    "/
    "/ I know: this is a kludge but should work for now...
    "/ ...this will change in an upcoming version to include
    "/ cmd.exe command-line parsing here (sigh).

    cmdName := (aCommandString ? '') withoutSeparators.

    (cmdName isEmpty or:[cmdName includesAny:'<>|']) ifFalse:[
	"/ test whether the command is a plain executable;
	"/ if so, no shell is required
	|index file suffix|

	index := cmdName indexOfSeparatorStartingAt:1.
	index ~~ 0 ifTrue:[
	    cmdName := cmdName copyFrom:1 to:(index-1).
	    args := cmdName copyFrom:(index+1).
	] ifFalse:[
	    args := ''.
	].

	(cmdName first = $" and:[cmdName last = $"]) ifTrue:[
	    cmdName := (cmdName copyFrom:2 to:cmdName size - 1) withoutSeparators.
	].
	file := cmdName asFilename.
	file suffix isEmpty ifTrue:[
	    file := file withSuffix:'exe'.
	].
	path := file fullAlternativePathName.
	(OperatingSystem getBinaryType:path) notNil ifTrue:[
	    "/ is an executable, no shell required
	    ^ Array with:path with:aCommandString with:nil.
"/                ^ Array with:path with:(path, ' ', args).
	].
	path := self pathOfCommand:cmdName.
	(path notNil and:[(OperatingSystem getBinaryType:path) notNil]) ifTrue:[
	    "/ is an executable, no shell required
	    ^ Array with:path with:aCommandString with:nil.
"/                ^ Array with:path with:(path, ' ', args).
	].
    ].

    shell := self getEnvironment:'COMSPEC'.
    shell isNil ifTrue:[
	wDir := self getWindowsSystemDirectory asFilename.
	shell := #('cmd.exe' 'command.com') detect:[:eachCommand|
			(wDir / eachCommand) isExecutableProgram
		    ] ifNone:[
			self error:'no cmd.exe available'.
		    ].
	shell := (wDir / shell) pathName.
    ].

    cmdName isEmpty ifTrue:[
	^ Array with:shell with:nil with:nil.
    ].

    ^ Array with:shell with:(' /c "' , aCommandString, '"') with:false.

   "
     self commandAndArgsForOSCommand:''
     self commandAndArgsForOSCommand:'%ProgramFiles%\notepad++\notepad++.exe'
     self commandAndArgsForOSCommand:'diff'
     self commandAndArgsForOSCommand:'diff.exe'
     self commandAndArgsForOSCommand:'dir/w'
     self commandAndArgsForOSCommand:'diff >nul:'
     self commandAndArgsForOSCommand:'diff /bla'
   "

    "Modified: / 20-01-1998 / 16:57:19 / md"
    "Modified: / 11-02-2007 / 20:51:08 / cg"
!

exec:commandPath withArguments:argumentsOrCommandLine environment:environment fileDescriptors:fdArray fork:doFork
        newPgrp:newPgrp inDirectory:aDirectory
        showWindow:showWindowBooleanOrNil

    "Internal lowLevel entry for combined fork & exec for WIN32

     If fork is false (chain a command):
         execute the OS command specified by the argument, aCommandPath, with
         arguments in argArray (no arguments, if nil).
         If successful, this method does not return and smalltalk is gone.
         If not successful, it does return.
         Normal use is with forkForCommand.

     If fork is true (subprocess command execution):
        fork a child to do the above.
        The Win32ProcessHandle of the child process is returned; nil if the fork failed.

     fdArray contains the filedescriptors, to be used for the child (if fork is true).
        fdArray[1] = 15 -> use fd 15 as stdin.
        If an element of the array is set to nil, the corresponding filedescriptor
        will be closed for the child.
        fdArray[0] == StdIn for child
        fdArray[1] == StdOut for child
        fdArray[2] == StdErr for child

     NOTE that in WIN32 the fds are HANDLES.

     If newPgrp is true, the subprocess will be established in a new process group.
        The processgroup will be equal to id.
        newPgrp is not used on WIN32 and VMS systems.

     showWindowOrBoolean may be:
        true  - a window is shown on start of the command
        false - the command window is hidden
        nil   - the nCmdShown parameter of the commans's winmain function determins,
                if a window is shown.
        #default
              - same as nil
    "

    |commandLine dirPath rslt|

    argumentsOrCommandLine isString ifTrue:[ 
        commandLine := argumentsOrCommandLine
    ] ifFalse:[
        argumentsOrCommandLine isSequenceable ifTrue:[ 
            commandLine := String streamContents:[:s|
                argumentsOrCommandLine 
                    do:[:p |self quoteCommandParameter: p on: s]
                    separatedBy:[ s space ]
            ].
        ].
    ].
    aDirectory notNil ifTrue:[
        dirPath := aDirectory asFilename asAbsoluteFilename osNameForDirectory.
        (dirPath endsWith:':') ifTrue:[
            dirPath := dirPath , '\'.
        ].
    ].

    rslt := self
        primExec:commandPath
        commandLine:commandLine
        environment:environment
        fileDescriptors:fdArray
        fork:doFork
        newPgrp:newPgrp
        inPath:dirPath
        createFlags:nil
        inheritHandles:true
        showWindow:showWindowBooleanOrNil.

"/ 'created ' print. cmdLine print. ' -> ' print. rslt printCR.
    ^ rslt

    "Modified: / 31-01-1998 / 10:54:24 / md"
    "Modified: / 15-05-1999 / 18:07:51 / cg"
    "Modified (comment): / 18-10-2016 / 16:00:26 / cg"
    "Modified: / 11-01-2018 / 23:31:55 / jv"
!

getStatusOfProcess:aProcessId
    "wait for a process to terminate and fetch its exit status.
     This is required to avoid zombie processes."

%{
    DWORD endStatus;
    INT status = -1;

    if (__isExternalAddressLike(aProcessId)) {
	HANDLE handle = _HANDLEVal(aProcessId);
	if (handle) {
#ifdef DO_WRAP_CALLS
	    do {
		__threadErrno = 0;
		endStatus = (INT)STX_API_CALL2( "WaitForSingleObject", WaitForSingleObject, handle, INFINITE);
	    } while ((endStatus < 0) && (__threadErrno == EINTR));
#else
	    endStatus = (INT)WaitForSingleObject(handle , INFINITE);
#endif
	    if (endStatus != WAIT_FAILED) {
		if (GetExitCodeProcess(handle,&endStatus)) {
		    status = endStatus;
#ifdef PROCESSDEBUGWIN32
		    if (flag_PROCESSDEBUGWIN32) {
			console_fprintf(stderr, "getexitcode status = %d\n",status);
		    }
		} else {
		    if (flag_PROCESSDEBUGWIN32) {
			console_fprintf(stderr, "getexitcode failed.\n");
		    }
#endif
		}
	    }
	}
	RETURN ( __mkSmallInteger(status));
    }
%}.
    self primitiveFailed
!

pathOfCommand:aCommand
    "find where aCommand's executable file is;
     return its full pathName if there is such a command, otherwise
     return nil."

    |cmdFile path rentry rpath hasSuffix|

    cmdFile := aCommand asFilename.
    cmdFile isAbsolute ifTrue:[
	cmdFile isExecutableProgram ifTrue:[
	    ^ aCommand
	].
        cmdFile suffix isEmpty ifTrue:[ 
            ((path := cmdFile withSuffix: 'com') exists 
                or:[ (path := cmdFile withSuffix: 'exe') exists 
                or:[ (path := cmdFile withSuffix: 'bar') exists ]]) ifTrue:[ 
                    path isExecutable ifTrue:[
                        ^ path pathName
                    ]. 
                ].
        ].
	^ nil
    ].

    (aCommand includes:Filename separator) ifTrue:[
	path := Filename currentDirectory construct:aCommand.
	path isExecutableProgram ifTrue:[
	    ^ path pathName.
	].
	^ nil
    ].

    "search in all directories of PATH.
     If there no extension, add the known extensions."
    path := (self getEnvironment:'PATH') ? ''.
    (rentry := self registryEntry key: 'HKEY_CURRENT_USER\Environment') notNil ifTrue:[
	rpath := rentry valueNamed: 'PATH'.
	rpath notNil ifTrue:[
	    path := path , self pathSeparator , rpath
	].
    ].
    path := '.;', path.
    hasSuffix := cmdFile suffix notEmpty.

    (path asCollectionOfSubstringsSeparatedBy:self pathSeparator) do:[:eachDirectory |
	|file|

	eachDirectory isEmpty ifTrue:[
	    file := cmdFile
	] ifFalse:[
	    file := eachDirectory asFilename construct:aCommand.
	].
	hasSuffix ifTrue:[
	    file isExecutableProgram ifTrue:[
		^ file pathName.
	    ].
	] ifFalse:[
	    self executableFileExtensions do:[:ext |
		|fExt|

		fExt := file withSuffix:ext.
		fExt isExecutableProgram ifTrue:[
		    ^ fExt pathName.
		].
	    ].
	].
    ].
    ^ nil

    "
     OperatingSystem pathOfCommand:'bcc32'
     OperatingSystem pathOfCommand:'diff'
     OperatingSystem pathOfCommand:'cvs'
     OperatingSystem pathOfCommand:'cvs.exe'
     OperatingSystem pathOfCommand:'stx.exe'
     OperatingSystem pathOfCommand:'stx'
     OperatingSystem pathOfCommand:'blaFaselQuall'
    "

    "Modified: / 20-01-2012 / 13:32:55 / cg"
    "Modified: / 01-07-2015 / 06:04:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

primExec:commandPath commandLine:commandLine environment:environmentOrNil
	fileDescriptors:fdArray fork:doFork newPgrp:newPgrp
	inPath:dirName createFlags:flagsOrNil inheritHandles:inheritHandles
	showWindow:showWindowBooleanOrNil
    "Internal lowLevel entry for combined fork & exec for WIN32

     showWindowBooleanOrNil may be:
	true  - a window is shown on start of the command
	false - the command window is hidden
	nil   - the nCmdShown parameter of the commans's winmain function determins,
		if a window is shown.
	#default
	      - same as nil
    "

    |handle commandPathUni16 commandLineUni16 dirNameUni16 envString16|

    handle := Win32ProcessHandle new.

    commandPathUni16 := commandPath.
    commandLineUni16 := commandLine.
    dirNameUni16 := dirName.

    commandPathUni16 notNil ifTrue:[
	commandPathUni16 := commandPathUni16 asUnicode16String.
    ].
    commandLineUni16 notNil ifTrue:[
	commandLineUni16 := commandLineUni16 asUnicode16String.
    ].
    dirNameUni16 notNil ifTrue:[
	dirNameUni16 := dirNameUni16 asUnicode16String.
    ].
    environmentOrNil notNil ifTrue:[
	|newEnv|

	"/ take my current environment; add the definitions given by the argument.
	newEnv := Dictionary new
		    declareAllFrom:(OperatingSystem getEnvironment);
		    declareAllFrom:environmentOrNil;
		    yourself.

	envString16 :=
	    Unicode16String streamContents:[:s |
		newEnv keysSorted do:[:k |
		    s nextPutAll:k; nextPutAll:'='; nextPutAll:(newEnv at:k).
		    s nextPut:(Character value:0).
		].
		s nextPut:(Character value:0).
	    ].
    ].

%{  /* STACK: 32000 */

    /*
     * if fork is false, chain to another command (not yet supported)
     * otherwise, spawn a subprocess and let it execute the command.
     * Currently, only the forking version is supported (who chains anyway ?)
     */
    int i, l; // i -> for iteration, l -> for length

    /*
     * CreateProcess supports 32767 characters/bytes including all variables and values
     * so take a good average for its arguments 4096
     * ATTENTION this value is also used hardcoded in the following code to check the length
     */
    wchar_t cmdPathW[4096];
    wchar_t cmdLineW[4096];
    wchar_t dirNameW[4096];

    /*
     * pass pointers to CreateProcess
     * NULL pointers used to indicate no value
     * so only set the pointer if the value is valid
     */
    wchar_t *cmdPathWP = NULL;
    wchar_t *cmdLineWP = NULL;
    wchar_t *dirNameWP = NULL;
    wchar_t *envWP = NULL;

    DWORD               fdwCreate = 0;
    STARTUPINFOW        lpsiStartInfo;
    PROCESS_INFORMATION lppiProcInfo;
    SECURITY_ATTRIBUTES securityAttributes;
    SECURITY_DESCRIPTOR securityDescriptor;

    if ((__isUnicode16String(commandPathUni16) || (commandPathUni16 == nil)) && __isUnicode16String(commandLineUni16)) {
	HANDLE stdinHandle = NULL;
	HANDLE stdoutHandle = NULL;
	HANDLE stderrHandle = NULL;
	int mustClose_stdinHandle = 0;
	int mustClose_stdoutHandle = 0;
	int mustClose_stderrHandle = 0;

	/*
	 * terminate the multi byte strings
	 */
	// #commandPathUni16
	if (commandPathUni16 != nil) {
	    l = __unicode16StringSize(commandPathUni16);
	    if (l >= 4096) { // >= need 1 space for terminator
# ifdef PROCESSDEBUGWIN32
		if (flag_PROCESSDEBUGWIN32) {
		    console_fprintf(stderr, "argument #commandPathUni16 is to long\n");
		}
# endif
		RETURN(nil);
	    }
	    for (i = 0; i < l; i++) {
		cmdPathW[i] = __unicode16StringVal(commandPathUni16)[i];
	    }
	    cmdPathW[i] = 0; // set terminator
	    cmdPathWP = &cmdPathW[0];
	}

	// commandLineUni16
	l = __unicode16StringSize(commandLineUni16);
	if (l >= 4096) { // >= need 1 space for terminator
# ifdef PROCESSDEBUGWIN32
	    if (flag_PROCESSDEBUGWIN32) {
		console_fprintf(stderr, "argument #commandLineUni16 is to long\n");
	    }
# endif
	    RETURN(nil);
	}
	for (i = 0; i < l; i++) {
	    cmdLineW[i] = __unicode16StringVal(commandLineUni16)[i];
	}
	cmdLineW[i] = 0; // set terminator
	cmdLineWP = &cmdLineW[0];

	// #dirNameUni16
	if (__isUnicode16String(dirNameUni16)) {
	    l = __unicode16StringSize(dirNameUni16);
	    if (l >= 4096) { // >= need 1 space for terminator
# ifdef PROCESSDEBUGWIN32
		if (flag_PROCESSDEBUGWIN32) {
		    console_fprintf(stderr, "argument #dirNameUni16 is to long\n");
		}
# endif
		RETURN(nil);
	    }
	    for (i = 0; i < l; i++) {
		dirNameW[i] = __unicode16StringVal(dirNameUni16)[i];
	    }
	    dirNameW[i] = 0; // set terminator
	    dirNameWP = &dirNameW[0];
	}

	if (envString16 != nil) {
	    envWP = __unicode16StringVal(envString16);
	}

	/*
	 * create descriptors as req'd
	 */
	memset(&securityAttributes, 0, sizeof(securityAttributes));
	securityAttributes.nLength = sizeof(securityAttributes);
	securityAttributes.bInheritHandle = (inheritHandles == true) ? TRUE : FALSE;

	InitializeSecurityDescriptor(&securityDescriptor, SECURITY_DESCRIPTOR_REVISION);
	SetSecurityDescriptorDacl(&securityDescriptor, -1, 0, 0);

	securityAttributes.lpSecurityDescriptor = &securityDescriptor;

	memset(&lpsiStartInfo, 0, sizeof(lpsiStartInfo));
	lpsiStartInfo.cb                = sizeof(lpsiStartInfo);
	lpsiStartInfo.lpReserved        = NULL;
	lpsiStartInfo.lpDesktop         = NULL;
	lpsiStartInfo.lpTitle           = NULL;
	lpsiStartInfo.dwX               = 0;
	lpsiStartInfo.dwY               = 0;
	lpsiStartInfo.dwXSize           = 100;
	lpsiStartInfo.dwYSize           = 100;
	lpsiStartInfo.dwXCountChars     = 0;
	lpsiStartInfo.dwYCountChars     = 0;
	lpsiStartInfo.dwFillAttribute   = 0;
	lpsiStartInfo.dwFlags           = STARTF_USESTDHANDLES /*| STARTF_USEPOSITION*/;
	if ((showWindowBooleanOrNil != nil) && (showWindowBooleanOrNil != @symbol(default))) {
	    lpsiStartInfo.dwFlags |= STARTF_USESHOWWINDOW;
	    lpsiStartInfo.wShowWindow = showWindowBooleanOrNil == true ? SW_SHOWNORMAL : SW_HIDE;
	}
	lpsiStartInfo.cbReserved2       = 0;
	lpsiStartInfo.lpReserved2       = NULL;
	lpsiStartInfo.hStdInput         = NULL;
	lpsiStartInfo.hStdOutput        = NULL;
	lpsiStartInfo.hStdError         = NULL;

	/*
	 * set create process flags
	 * if the flags arg is nil, use common defaults;
	 * if non-nil, it must be a positive integer containing the fdwCreate bits.
	 */
	if (flagsOrNil != nil) {
	    fdwCreate = __longIntVal(flagsOrNil);
	} else {
	    fdwCreate = CREATE_NEW_CONSOLE; //|IDLE_PRIORITY_CLASS; // DETACHED_PROCESS; // NORMAL_PRIORITY_CLASS ;
	    if (newPgrp == true) {
		fdwCreate |= CREATE_NEW_PROCESS_GROUP;
	    }
	    fdwCreate |= CREATE_DEFAULT_ERROR_MODE;
	}

	if (fdArray == nil) {
	    stdinHandle  = (HANDLE) _get_osfhandle (0);
	    stdoutHandle = (HANDLE) _get_osfhandle (1);
	    stderrHandle  = (HANDLE) _get_osfhandle (2);
	} else if (__isArrayLike(fdArray) && (__arraySize(fdArray) >= 3)) {
	    if (__ArrayInstPtr(fdArray)->a_element[0] != nil) {
		if (__isExternalAddressLike(__ArrayInstPtr(fdArray)->a_element[0])) {
		    stdinHandle = _HANDLEVal(__ArrayInstPtr(fdArray)->a_element[0]);
		} else {
		    stdinHandle = (HANDLE) _get_osfhandle (__intVal(__ArrayInstPtr(fdArray)->a_element[0]));
		}
	    }
	    if (__ArrayInstPtr(fdArray)->a_element[1] != nil) {
		if (__isExternalAddressLike(__ArrayInstPtr(fdArray)->a_element[1])) {
		    stdoutHandle = _HANDLEVal(__ArrayInstPtr(fdArray)->a_element[1]);
		} else {
		    stdoutHandle = (HANDLE) _get_osfhandle (__intVal(__ArrayInstPtr(fdArray)->a_element[1]));
		}
	    }
	    if (__ArrayInstPtr(fdArray)->a_element[2] != nil) {
		if (__isExternalAddressLike(__ArrayInstPtr(fdArray)->a_element[2])) {
		    stderrHandle  = _HANDLEVal(__ArrayInstPtr(fdArray)->a_element[2]);
		} else {
		    stderrHandle = (HANDLE) _get_osfhandle (__intVal(__ArrayInstPtr(fdArray)->a_element[2]));
		}
	    }
	} else {
	    console_fprintf(stderr, "Win32OS [warning]: bad fd arg in createProcess\n");
	}

#if defined(PROCESSDEBUGWIN32)
	if (flag_PROCESSDEBUGWIN32) {
	    console_fprintf(stderr, "stdin %x\n", stdinHandle);
	    console_fprintf(stderr, "stdout %x\n", stdoutHandle);
	    console_fprintf(stderr, "stderr %x\n", stderrHandle);
	}
#endif

	{
	    HANDLE childHandle;
	    int sameHandle = (stdoutHandle == stderrHandle);

	    // these MUST be inheritable!
	    if (stdinHandle) {
#if 0
		if (SetHandleInformation(stdinHandle, HANDLE_FLAG_INHERIT, HANDLE_FLAG_INHERIT)) {
		    // good
		} else {
		    console_fprintf(stderr, "Win32OS [warning]: SetHandleInformation failed in createProcess\n");
		}
#else
		if (DuplicateHandle(GetCurrentProcess(), stdinHandle, GetCurrentProcess(),
				      &childHandle, 0, TRUE, DUPLICATE_SAME_ACCESS)) {
		    stdinHandle = childHandle;
		    mustClose_stdinHandle = 1;
		} else {
		    console_fprintf(stderr, "Win32OS [warning]: duplicateHandle failed in createProcess\n");
		}
#endif
	    }
	    if (stdoutHandle) {
#if 0
		if (SetHandleInformation(stdoutHandle, HANDLE_FLAG_INHERIT, HANDLE_FLAG_INHERIT)) {
		    // good
		} else {
		    console_fprintf(stderr, "Win32OS [warning]: SetHandleInformation failed in createProcess\n");
		}
#else
		if (DuplicateHandle(GetCurrentProcess(), stdoutHandle, GetCurrentProcess(),
				      &childHandle, 0, TRUE, DUPLICATE_SAME_ACCESS)) {
		    stdoutHandle = childHandle;
		    mustClose_stdoutHandle = 1;
		} else {
		    console_fprintf(stderr, "Win32OS [warning]: duplicateHandle failed in createProcess\n");
		}
#endif
	    }
	    if (stderrHandle) {
		if (sameHandle) {
		    stderrHandle = stdoutHandle;
		} else {
#if 0
		    if (SetHandleInformation(stderrHandle, HANDLE_FLAG_INHERIT, HANDLE_FLAG_INHERIT)) {
			// good
		    } else {
			console_fprintf(stderr, "Win32OS [warning]: SetHandleInformation failed in createProcess\n");
		    }
#else
		    if (DuplicateHandle(GetCurrentProcess(), stderrHandle, GetCurrentProcess(),
					  &childHandle, 0, TRUE, DUPLICATE_SAME_ACCESS)) {
			stderrHandle = childHandle;
			mustClose_stderrHandle = 1;
		    } else {
			console_fprintf(stderr, "Win32OS [warning]: duplicateHandle failed in createProcess\n");
		    }
#endif
		}
	    }
	}
	lpsiStartInfo.hStdInput  = stdinHandle;
	lpsiStartInfo.hStdOutput = stdoutHandle;
	lpsiStartInfo.hStdError  = stderrHandle;

	if (doFork == true) {
#ifdef PROCESSDEBUGWIN32
	    if (flag_PROCESSDEBUGWIN32) {
		console_fprintf(stderr, "create process cmdPath:<%s> cmdLine:<%s> in <%s>\n", __stringVal(commandPath), __stringVal(commandLine), __stringVal(dirName));
	    }
#endif
	    memset(&lppiProcInfo, 0, sizeof (lppiProcInfo));

	    if (CreateProcessW( cmdPathWP,
				cmdLineWP,
				&securityAttributes, NULL               /* &securityAttributes */,
				securityAttributes.bInheritHandle,      /* inherit handles */
				fdwCreate | CREATE_SUSPENDED            /* resume after setting affinity */
					  | CREATE_UNICODE_ENVIRONMENT,
				envWP,                                  /* env */
				dirNameWP,
				&lpsiStartInfo,
				&lppiProcInfo ))
	    {
		DWORD_PTR processAffinityMask, systemAffinityMask;

		/*
		 * Process was created suspended, now set the affinity mask
		 * to any processor, and resume the processes main thread.
		 * (librun/process.s limited the affinity to a single processor).
		 */
		GetProcessAffinityMask(lppiProcInfo.hProcess, &processAffinityMask, &systemAffinityMask);
		SetProcessAffinityMask(lppiProcInfo.hProcess, systemAffinityMask);
		if ((fdwCreate & CREATE_SUSPENDED) == 0) {
		    ResumeThread(lppiProcInfo.hThread);
		}
		CloseHandle(lppiProcInfo.hThread);

#if 0
		// only works with real console handles
		{
		    // change the child's stdIn (console) mode
		    DWORD mode = 0;

		    if (! GetConsoleMode(stdinHandle, &mode)) {
			console_fprintf(stderr, "Win32OS [warning]: GetConsoleMode failed in createProcess\n");
		    }
		    if (! SetConsoleMode(stdinHandle, mode & (~ENABLE_ECHO_INPUT))){
			console_fprintf(stderr, "Win32OS [warning]: SetConsoleMode failed in createProcess\n");
		    }
		}
#endif
		if (mustClose_stdinHandle) {
		    CloseHandle(stdinHandle);
		}
		if (mustClose_stdoutHandle) {
		    CloseHandle(stdoutHandle);
		}
		if (mustClose_stderrHandle) {
		    CloseHandle(stderrHandle);
		}
#ifdef PROCESSDEBUGWIN32
		if (flag_PROCESSDEBUGWIN32) {
		    console_fprintf(stderr, "created process hProcess=%x pid=%d\n", lppiProcInfo.hProcess, lppiProcInfo.dwProcessId);
		}
#endif

		__externalAddressVal(handle) = lppiProcInfo.hProcess;
		((struct __Win32OperatingSystem__Win32ProcessHandle_struct *)(handle))->pid = __mkSmallInteger(lppiProcInfo.dwProcessId);
		RETURN (handle);
	    }
#ifdef PROCESSDEBUGWIN32
	    if (flag_PROCESSDEBUGWIN32) {
		console_fprintf(stderr, "created process error %d\n", GetLastError());
	    }
#endif
	    RETURN (nil);
	} else {
	    ; /* should never be called that way */
	}
    }
%}.
    "
     path-argument not string
     or argArray not an array/nil
     or malloc failed
     or not supported by OS
    "
    ^ self primitiveFailed

    "Created: / 15-11-2016 / 19:39:49 / cg"
!

shellExecute:hwndArg lpOperation:lpOperationArg lpFile:lpFileArg lpParameters:lpParametersArg lpDirectory:lpDirectoryArg nShowCmd:nShowCmd
    "Opens or prints the specified file, which can be an executable, document file, or directory.
     If its a directory, an explorer window is opened (see example below).
     Can be used to open a browser or viewer on html-files, pdf-files etc.
     lpDirectory: the pathname string of the directory used for the command,
		  or nil for the current directory."

    |errorNumber handle|

    handle := Win32ProcessHandle new.

%{
    SHELLEXECUTEINFO shExecInfo = {0};
    shExecInfo.cbSize = sizeof(shExecInfo);

    if (__isSmallInteger(nShowCmd)) {
	shExecInfo.nShow = __intVal(nShowCmd);
    } else {
	if (nShowCmd == @symbol(SW_SHOW)) {
	    shExecInfo.nShow = SW_SHOW;
	} else if (nShowCmd == @symbol(SW_SHOWNORMAL)) {
	    shExecInfo.nShow = SW_SHOWNORMAL;
	} else if (nShowCmd == @symbol(SW_SHOWDEFAULT)) {
	    shExecInfo.nShow = SW_SHOWDEFAULT;
	} else if (nShowCmd == @symbol(SW_SHOWMAXIMIZED)) {
	    shExecInfo.nShow = SW_SHOWMAXIMIZED;
	} else if (nShowCmd == @symbol(SW_SHOWMINIMIZED)) {
	    shExecInfo.nShow = SW_SHOWMINIMIZED;
	} else if (nShowCmd == @symbol(SW_SHOWMINNOACTIVE)) {
	    shExecInfo.nShow = SW_SHOWMINNOACTIVE;
	} else if (nShowCmd == @symbol(SW_SHOWNA)) {
	    shExecInfo.nShow = SW_SHOWNA;
	} else if (nShowCmd == @symbol(SW_SHOWNOACTIVATE)) {
	    shExecInfo.nShow = SW_SHOWNOACTIVATE;
	} else if (nShowCmd == @symbol(SW_MAXIMIZE)) {
	    shExecInfo.nShow = SW_MAXIMIZE;
	} else if (nShowCmd == @symbol(SW_RESTORE)) {
	    shExecInfo.nShow = SW_RESTORE;
	} else {
	    goto badArgument;
	}
    }
    if (((lpOperationArg == nil) || __isStringLike(lpOperationArg))
     && ((lpFileArg == nil) || __isStringLike(lpFileArg))
     && ((lpParametersArg == nil) || __isStringLike(lpParametersArg))
     && ((lpDirectoryArg == nil) || __isStringLike(lpDirectoryArg))
    ) {
	// hProcess member receives the process handle
	shExecInfo.fMask = SEE_MASK_NOCLOSEPROCESS;

	shExecInfo.hwnd = 0;
	shExecInfo.lpVerb        = (lpOperationArg != nil) ? __stringVal(lpOperationArg) : NULL;
	shExecInfo.lpFile        = (lpFileArg != nil) ? __stringVal(lpFileArg) : NULL;
	shExecInfo.lpParameters  = (lpParametersArg != nil) ? __stringVal(lpParametersArg) : NULL;
	shExecInfo.lpDirectory   = (lpDirectoryArg != nil) ? __stringVal(lpDirectoryArg) : NULL;
	if (hwndArg != nil) {
	    if (__isExternalAddressLike(hwndArg)) {
		shExecInfo.hwnd = _HANDLEVal(hwndArg);
	    } else
		goto badArgument;
	}
	if (ShellExecuteEx(&shExecInfo)) {
	    if (shExecInfo.hProcess) {
		DWORD_PTR processAffinityMask, systemAffinityMask;
		/*
		 * Set the affinity mask
		 * to any processor, and resume the processes main thread.
		 * (librun/process.s limited the affinity to a single processor).
		 */
		GetProcessAffinityMask(shExecInfo.hProcess, &processAffinityMask, &systemAffinityMask);
		SetProcessAffinityMask(shExecInfo.hProcess, systemAffinityMask);

		__externalAddressVal(handle) = shExecInfo.hProcess;
		RETURN (handle);
	    } else {
		RETURN (nil); /* OK */
	    }
	} else {
	    /* error */
	    errorNumber = __mkSmallInteger(__WIN32_ERR(GetLastError()));
	}
    }
badArgument: ;
%}.
    errorNumber isNil ifTrue:[
	self primitiveFailed:'invalid argument(s)'.
    ] ifFalse:[
	(OperatingSystem errorHolderForNumber:errorNumber)
	    parameter:lpFileArg;
	    reportError
    ].

    "
     self
	shellExecute:nil
	lpOperation:'open'
	lpFile:(Filename currentDirectory pathName)
	lpParameters:nil
	lpDirectory:nil
	nShowCmd:#SW_SHOWNORMAL
    self
	shellExecute:nil
	lpOperation:'explore'
	lpFile:(Filename currentDirectory pathName)
	lpParameters:nil
	lpDirectory:nil
	nShowCmd:#SW_SHOWNORMAL
    "
!

startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream
    errorTo:anExternalErrStream auxFrom:anAuxiliaryStream
    environment:anEvironmentDictionary inDirectory:dir
    newPgrp:newPgrp showWindow:showWindowBooleanOrNil

    "start executing the OS command as specified by the argument, aCommandString
     as a separate process; do not wait for the command to finish.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     The command gets stdIn, stdOut and stdErr assigned from the arguments;
     each may be nil.

     Return the Win32ProcessHandle if successful, nil otherwise.

     Use #monitorPid:action: for synchronization and exec status return,
     or #killProcess: to stop it."

    |shellAndArgs nullStream in out err rslt|

    aCommandString isNil ifTrue:[^ nil].
    shellAndArgs := self commandAndArgsForOSCommand:aCommandString.

    (in := anExternalInStream) isNil ifTrue:[
	nullStream := Filename nullDevice readWriteStream.
	in := nullStream.
    ].
    (out := anExternalOutStream) isNil ifTrue:[
	nullStream isNil ifTrue:[nullStream := Filename nullDevice writeStream].
	out := nullStream.
    ].
    (err := anExternalErrStream) isNil ifTrue:[
	err := out
    ].

    rslt := self
	exec:(shellAndArgs at:1)
	withArguments:(shellAndArgs at:2)
	environment:anEvironmentDictionary
	fileDescriptors:(Array with:in fileHandle
			       with:out fileHandle
			       with:err fileHandle
			       with:(anAuxiliaryStream notNil ifTrue:[anAuxiliaryStream fileHandle] ifFalse:[nil]))
	fork:true
	newPgrp:newPgrp
	inDirectory:dir
	showWindow:(showWindowBooleanOrNil ? (shellAndArgs at:3)).

    nullStream notNil ifTrue:[
	nullStream close.
    ].
    ^ rslt

    "blocking at current prio (i.e. only higher prio threads execute):

     OperatingSystem executeCommand:'dir > out'.
     OperatingSystem executeCommand:'tree /A' outputTo:Transcript.
     OperatingSystem executeCommand:#('c:\windows\system32\tree.com' '/A' '/F') outputTo:Transcript.
     OperatingSystem executeCommand:#('c:\windows\system32\where.exe' '/T' '*.dll') outputTo:Transcript.
    "

    "non-blocking (lower prio threads continue):

     |in out err pid sema|

     in := 'out' asFilename readStream.
     out := 'out2' asFilename writeStream.
     err := 'err' asFilename writeStream.

     sema := Semaphore new.
     pid := OperatingSystem startProcess:'sleep 10; grep drw' inputFrom:in outputTo:out errorTo:err.

     The following will no longer work. monitorPid has disappeared

     pid notNil ifTrue:[
	 Processor monitorPid:pid action:[:OSstatus | sema signal ].
     ].
     in close.
     out close.
     err close.
     sema wait.
     Transcript showCR:'finished'
    "

    "
     |pid sema|

     sema := Semaphore new.

     Processor
	    monitor:[
		pid := OperatingSystem startProcess:'dir > out 2>err'
	    ]
	    action:[:osStatus | sema signal ].

     sema wait.
     Transcript showCR:'finished'
    "

"<<END
     |pid sema|

     sema := Semaphore new.

     Processor
	    monitor:[
		pid := OperatingSystem startProcess:'(echo 1 & stx --eval "Delay waitForSeconds:100" & dir) >out' withCRs
	    ]
	    action:[:osStatus | sema signal ].

     Delay waitForSeconds:5.
     OperatingSystem terminateProcessGroup:pid.
     Transcript showCR:'terminated'
END"

"<<END
     |pid sema|

     sema := Semaphore new.

     Processor
	    monitor:[
		pid := OperatingSystem startProcess:{ 'C:\Users\cg\work\stx\projects\smalltalk\stx.com' . '--eval' . '"Delay waitForSeconds:100"' }
	    ]
	    action:[:osStatus | sema signal ].

     Delay waitForSeconds:5.
     OperatingSystem terminateProcess:pid.
     Transcript showCR:'terminated'
END"

    "Created: / 08-11-2016 / 21:23:17 / cg"
! !

!Win32OperatingSystem class methodsFor:'file access'!

closeFd:anIntegerOrHandle
    "low level close of a filedescriptor"

%{
    if (__isSmallInteger(anIntegerOrHandle)) {
	close(__intVal(anIntegerOrHandle));
	RETURN(self);
    }
    if (__isExternalAddressLike(anIntegerOrHandle)) {
       if (!CloseHandle( _HANDLEVal(anIntegerOrHandle))) {
	   console_fprintf( stderr, "Win32OS [warning]: Could not close handle : %x\n", _HANDLEVal(anIntegerOrHandle));
       }
       RETURN(self);
    }
%}.
    ^ self primitiveFailed.
!

createDirectory:aPathName
    "create a new directory with name 'aPathName', which may be an absolute
     path, or relative to the current directory.
     Return nil if successful (or the directory existed already), an OsErrorHolder otherwise.
     This is a low-level entry - use Filename protocol for compatibility."

    |error|

    "/ if it already exists this is ok
    (self isDirectory:aPathName) ifTrue:[^ nil].

%{
    SECURITY_ATTRIBUTES sa;
    int success;

    sa.nLength = sizeof( sa );
    sa.lpSecurityDescriptor = NULL;
    // sa.bInheritHandle = TRUE;
    sa.bInheritHandle = FALSE;

    if (__isStringLike(aPathName)) {
	success = CreateDirectoryA(__stringVal(aPathName), &sa);
    } else if (__isUnicode16String(aPathName)) {
	wchar_t _wPathName[MAXPATHLEN+1];

	_makeWchar(aPathName, _wPathName, sizeof(_wPathName));
	success = CreateDirectoryW(_wPathName, &sa);
    } else
	goto err;

    if (success == TRUE) {
	RETURN (nil);
    }

    error = __mkSmallInteger(__WIN32_ERR(GetLastError()));

err:;
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    ^ self primitiveFailed

    "
     OperatingSystem createDirectory:'foo'
    "

    "Modified: 20.12.1995 / 11:24:13 / stefan"
    "Modified: 29.6.1996 / 14:06:54 / cg"
!

createFileForReadAppend:pathName
     ^ self openFile:pathName attributes:#(#'GENERIC_READ' #'GENERIC_WRITE')
!

createFileForReadWrite:pathName
     ^ self openFile:pathName attributes:#(#'GENERIC_READ' #'GENERIC_WRITE' #'CREATE_ALWAYS')
!

createHardLinkFrom:oldPath to:newPath
    "link the file 'oldPath' to 'newPath'. The link will be a hard link.
     Return nil if successful, an OsErrorHolder if not."

    (self executeCommand:('mklink/h "%1" "%2"' bindWith:newPath with:oldPath)) ifFalse:[
	^ OSErrorHolder errorSymbol:'mklink/h failed' errorCategory:nil.
    ].
    ^ nil.

    "Created: / 19-01-2011 / 08:42:11 / cg"
!

createSymbolicLinkFrom:oldPath to:newPath
    "make a link from the file 'oldPath' to the file 'newPath'.
     The link will be a soft (symbolic) link.
     Return nil if successful, an OsErrorHolder if not.

     Note: mklink needs special permissions or Administrator rights."

    |dirFlag|

    dirFlag := ''.
    (self isDirectory:oldPath) ifTrue:[
	dirFlag := '/d'.
    ].

    (self executeCommand:('mklink %3 "%1" "%2"' bindWith:newPath with:oldPath with:dirFlag)) ifFalse:[
	^ OSErrorHolder errorSymbol:'mklink failed' errorCategory:nil.
    ].
    ^ nil.

    "Created: / 19-01-2011 / 08:41:44 / cg"
!

getLastError
%{
    RETURN ( __mkSmallInteger( __WIN32_ERR(GetLastError()) ));
%}.

    "Created: / 31-07-2006 / 12:40:39 / fm"
!

getLinkTarget:aPathName
    "given a filename, which represents a link-file (.lnk),
     return its resolved path, or nil"

    |resolvedPath|

%{  /* STACK:100000 */

    static IShellLink   * ipShellLink   = NULL;
    static IPersistFile * ipPersistFile = NULL;

    HRESULT hres;
    WIN32_FIND_DATA wfd;
    WORD wsz[MAXPATHLEN];
    char szGotPath[MAXPATHLEN];

    if (! __isStringLike(aPathName)) {
	console_fprintf(stderr, "OperatingSystem [info]: invalid argument\n");
	goto error;
    }

    if( ! coInitialized ) {
	console_fprintf(stderr, "OperatingSystem [info]: com not initialized\n");
	goto error;
    }

    if ( ipShellLink == NULL ) {
	hres = CoCreateInstance(&CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER,
				&IID_IShellLink, (LPVOID *)&ipShellLink);
	if (! SUCCEEDED(hres)) {
	    console_fprintf(stderr, "OperatingSystem [info]: CoCreateInstance Error - hres = %08x\n", hres);
	    ipShellLink = NULL;
	    goto error;
	}

	hres = ipShellLink->lpVtbl->QueryInterface( ipShellLink, &IID_IPersistFile, (void **)&ipPersistFile );
	if (! SUCCEEDED(hres)) {
	    console_fprintf(stderr, "OperatingSystem [info]: QueryInterface Error - hres = %08x\n", hres);
	    ipShellLink->lpVtbl->Release(ipShellLink);
	    ipShellLink   = NULL;
	    ipPersistFile = NULL;
	    goto error;
	}
    }

    MultiByteToWideChar(CP_ACP, 0, __stringVal(aPathName), -1, wsz, MAXPATHLEN);

    hres = ipPersistFile->lpVtbl->Load(ipPersistFile, wsz, STGM_READ);

    if (SUCCEEDED(hres)) {
	hres = ipShellLink->lpVtbl->GetPath(ipShellLink, szGotPath, MAXPATHLEN,
		    (WIN32_FIND_DATA *)&wfd, 0 /* SLGP_SHORTPATH */ );
	if (SUCCEEDED(hres)) {
	    resolvedPath = __MKSTRING(szGotPath);
	} else {
#ifdef COM_DEBUG
	    console_fprintf(stderr, "OperatingSystem [info]: GetPath failed - hres = %08x\n", hres );
#endif
	}
    } else {
#ifdef COM_DEBUG
	console_fprintf(stderr, "OperatingSystem [info]: Load failed - hres = %08x\n", hres );
#endif
    }
    /* ipPersistFile->lpVtbl->Release(ipPersistFile);  */

error: ;
%}.
    resolvedPath notNil ifTrue:[^ resolvedPath ].

    "/ self primitiveFailed.
    ^ nil.

    "
     OperatingSystem getLinkTarget:'C:\Dokumente und Einstellungen\cg\Favoriten\Incoming.lnk'
     OperatingSystem getLinkTarget:'C:\Dokumente und Einstellungen\cg\Favoriten\cg auf G5.lnk'
    "

    "Created: / 07-11-2006 / 10:52:44 / cg"
    "Modified: / 07-02-2007 / 10:37:48 / cg"
!

openFile:pathName attributes:attributeSpec
    "non public internal helper.
     open a file, return an os specific fileHandle.
     attributes is a collection of symbols specifying how the file is
     to be opened."

    |fileHandle errorNumber argumentError|

    fileHandle := Win32Handle new.

%{
    HANDLE h;
    char *name;
    wchar_t _wPathName[MAXPATHLEN+1];
    OBJ *ap;
    int numAttrib;
    int i, l;
    DWORD access, share, create, attr;

    if (__isStringLike(pathName)) {
	name = __stringVal(pathName);
    } else if (__isUnicode16String(pathName)) {
	_makeWchar(pathName, _wPathName, sizeof(_wPathName));
    } else {
	fileHandle = nil;
	argumentError = @symbol(badPathName);
	goto badArgument;
    }

    if (! __isArrayLike(attributeSpec)) {
	fileHandle = nil;
	argumentError = @symbol(badAttributeSpec);
	goto badArgument;
    }
    ap = __ArrayInstPtr(attributeSpec)->a_element;
    numAttrib = __arraySize(attributeSpec);

    share = 0;
    access = 0;
    create = 0;
    attr = 0;

    for (i=0; i<numAttrib;i++) {
	OBJ attrSym = ap[i];

	if (attrSym == @symbol(FILE_SHARE_READ)) {
	    share |= FILE_SHARE_READ;
	} else if (attrSym == @symbol(FILE_SHARE_WRITE)) {
	    share |= FILE_SHARE_WRITE;

	} else if (attrSym == @symbol(GENERIC_READ)) {
	    access |= GENERIC_READ;
	} else if (attrSym == @symbol(GENERIC_WRITE)) {
	    access |= GENERIC_WRITE;

	} else if (attrSym == @symbol(CREATE_NEW)) {
	    create |= CREATE_NEW;
	} else if (attrSym == @symbol(CREATE_ALWAYS)) {
	    create |= CREATE_ALWAYS;
	} else if (attrSym == @symbol(OPEN_EXISTING)) {
	    create |= OPEN_EXISTING;
	} else if (attrSym == @symbol(OPEN_ALWAYS)) {
	    create |= OPEN_ALWAYS;
	} else if (attrSym == @symbol(TRUNCATE_EXISTING)) {
	    create |= TRUNCATE_EXISTING;

	} else if (attrSym == @symbol(FILE_ATTRIBUTE_HIDDEN)) {
	    attr |= FILE_ATTRIBUTE_HIDDEN;
	} else if (attrSym == @symbol(FILE_ATTRIBUTE_READONLY)) {
	    attr |= FILE_ATTRIBUTE_READONLY;
	} else if (attrSym == @symbol(FILE_ATTRIBUTE_READONLY)) {
	    attr |= FILE_ATTRIBUTE_READONLY;
	} else if (attrSym == @symbol(FILE_FLAG_WRITE_THROUGH)) {
	    attr |= FILE_FLAG_WRITE_THROUGH;
	} else if (attrSym == @symbol(FILE_FLAG_SEQUENTIAL_SCAN)) {
	    attr |= FILE_FLAG_SEQUENTIAL_SCAN;
	} else if (attrSym == @symbol(FILE_FLAG_DELETE_ON_CLOSE)) {
	    attr |= FILE_FLAG_DELETE_ON_CLOSE;
	} else {
	    console_fprintf(stderr, "Win32OS [warning]: unsupported open mode\n");
	}
    }
    if (create == 0) {
	fileHandle = nil;
	argumentError = @symbol(missingCreateMode);
	goto badArgument;
    }
#ifdef PROCESSDEBUGWIN32
    if (flag_PROCESSDEBUGWIN32) {
	console_fprintf(stderr, "name:<%s> access:%x share:%x create:%x attr:%x\n",
			name, access, share, create, attr);
    }
#endif
    if (__isStringLike(pathName)) {
	h = CreateFileA(name, access, share, 0 /* sa */, create, attr, 0 /* hTempl */);
    } else {
	h = CreateFileW(_wPathName, access, share, 0 /* sa */, create, attr, 0 /* hTempl */);
    }

    if (h != INVALID_HANDLE_VALUE) {
	__externalAddressVal(fileHandle) = (void *)h;
    } else {
	fileHandle = nil;
	errorNumber = __mkSmallInteger( __WIN32_ERR(GetLastError()) );
    }

badArgument: ;
%}.
    fileHandle notNil ifTrue:[
	fileHandle registerForFinalization.
	^ fileHandle.
    ].
    errorNumber isNil ifTrue:[
	self error:'invalid argument(s): ', argumentError.
    ] ifFalse:[
	(self errorHolderForNumber:errorNumber) reportError
    ].
!

openFileForAppend:pathName
    "noone sends this message yet"

    ^ self shouldImplement
!

openFileForRead:pathName
     ^ self openFile:pathName attributes:#(#'GENERIC_READ' #'OPEN_EXISTING')
!

openFileForReadAppend:pathName
    "noone sends this message yet"

    ^ self shouldImplement
!

openFileForReadWrite:pathName
     ^ self openFile:pathName attributes:#(#'GENERIC_READ' #'GENERIC_WRITE')
!

openFileForWrite:pathName
     ^ self openFile:pathName attributes:#(#'GENERIC_WRITE' #'OPEN_EXISTING')
!

recursiveCopyDirectory:sourcePathName to:destination
    "copy the directory named 'sourcePathName' and all contained files/directories to 'destination'.
     Return true if successful."

    ^ OperatingSystem executeCommand:('xcopy %1 %2 /q /s /e /h /r /o /g /y' bindWith:sourcePathName with:destination)
!

removeDirectory:fullPathName
    "remove the directory named 'fullPathName'.
     The directory must be empty and you must have appropriate access rights.
     Return nil if successful, an OSErrorHolder if directory is not empty or no permission.
     This is a lowLevel entry - use Filename protocol for compatibility."

    |error|

%{
    int success;

    if (__isStringLike(fullPathName)) {
#ifdef DO_WRAP_CALLS
	{
	    char _aPathName[MAXPATHLEN];

	    strncpy(_aPathName, __stringVal(fullPathName), MAXPATHLEN-1); _aPathName[MAXPATHLEN-1] = '\0';
	    do {
		// do not cast to INT - will loose sign bit then!
		success = (int)STX_API_NOINT_CALL1( "RemoveDirectoryA", RemoveDirectoryA, _aPathName);
	    } while ((success < 0) && (__threadErrno == EINTR));
	}
#else
	success = RemoveDirectoryA((char *)__stringVal(fullPathName));
	if (!success) __threadErrno = __WIN32_ERR(GetLastError());
#endif
    } else if (__isUnicode16String(fullPathName)) {
#ifdef DO_WRAP_CALLS
	{
	    wchar_t _wPathName[MAXPATHLEN+1];

	    _makeWchar(fullPathName, _wPathName, sizeof(_wPathName));
	    do {
		// do not cast to INT - will loose sign bit then!
		success = (int)STX_API_NOINT_CALL1( "RemoveDirectoryW", RemoveDirectoryW, _wPathName);
	    } while ((success < 0) && (__threadErrno == EINTR));
	}
#else
	success = RemoveDirectoryW((wchar_t *)__unicode16StringVal(fullPathName));
	if (!success) __threadErrno = __WIN32_ERR(GetLastError());
#endif
    }

    if (success == TRUE) {
	RETURN (nil);
    }

    error = __mkSmallInteger(__threadErrno);
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    "/
    "/ either not a string argument,
    "/ or not supported by OS
    "/
    ^ self primitiveFailed

    "
     OperatingSystem createDirectory:'foo'
     OperatingSystem removeDirectory:'foo'
    "
!

removeFile:fullPathName
    "remove the file named 'fullPathName'; return nil if successful, an OSErrorHolder on errror.
     This is a lowLevel entry - use Filename protocol for compatibility."

    |error|

%{
    int success;

    if (__isStringLike(fullPathName)) {
#ifdef DO_WRAP_CALLS
	{
	    char _aPathName[MAXPATHLEN];

	    strncpy(_aPathName, __stringVal(fullPathName), MAXPATHLEN-1); _aPathName[MAXPATHLEN-1] = '\0';
	    do {
		// do not cast to INT - will loose sign bit then!
		success = (int)STX_API_NOINT_CALL1( "DeleteFileA", DeleteFileA, _aPathName);
	    } while ((success < 0) && (__threadErrno == EINTR));
	}
#else
	success = DeleteFileA((char *)__stringVal(fullPathName));
	if (!success) __threadErrno = __WIN32_ERR(GetLastError());
#endif
    } else if (__isUnicode16String(fullPathName)) {
#ifdef DO_WRAP_CALLS
	{
	    wchar_t _wPathName[MAXPATHLEN+1];

	    _makeWchar(fullPathName, _wPathName, sizeof(_wPathName));
	    do {
		// do not cast to INT - will loose sign bit then!
		success = (int)(STX_API_NOINT_CALL1( "DeleteFileW", DeleteFileW, _wPathName));
	    } while ((success < 0) && (__threadErrno == EINTR));
	}
#else
	success = DeleteFileW((wchar_t *)__unicode16StringVal(fullPathName));
	if (!success) __threadErrno = __WIN32_ERR(GetLastError());
#endif
    }

    if (success == TRUE) {
	RETURN (nil);
    }

    error = __mkSmallInteger(__threadErrno);
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    ^ self primitiveFailed
!

renameFile:oldPath to:newPath
    "rename the file 'oldPath' to 'newPath'.
     Someone else has to care for the names to be correct and
     correct for the OS used - therefore, this should not be called
     directlt. Instead, use Filename protocol to rename; this cares for
     any invalid names.
     Returns nil if successful, an OsErrorHolder if not"

    |error|

%{
    int success;

    if (__isStringLike(oldPath) && __isStringLike(newPath)) {
#ifdef DO_WRAP_CALLS
	char _oldPath[MAXPATHLEN], _newPath[MAXPATHLEN];

	strncpy(_oldPath, __stringVal(oldPath), MAXPATHLEN-1); _oldPath[MAXPATHLEN-1] = '\0';
	strncpy(_newPath, __stringVal(newPath), MAXPATHLEN-1); _newPath[MAXPATHLEN-1] = '\0';

	do {
	    success = STX_API_NOINT_CALL2("MoveFileA", MoveFileA, _oldPath, _newPath);
	} while (success < 0 && __threadErrno == EINTR);
#else
	__BEGIN_INTERRUPTABLE__
	do {
	    success = MoveFileA((char *) __stringVal(oldPath), (char *) __stringVal(newPath));
	} while (success < 0 && __threadErrno == EINTR);
	__END_INTERRUPTABLE__
#endif
    } else {
	wchar_t _oldPathW[MAXPATHLEN], _newPathW[MAXPATHLEN];

	if (_makeWchar(oldPath, _oldPathW, sizeof(_oldPathW)) < 0
	    || _makeWchar(newPath, _newPathW, sizeof(_newPathW)) < 0) {
	    goto err;
	}
#ifdef DO_WRAP_CALLS
	do {
	    success = STX_API_NOINT_CALL2( "MoveFileW", MoveFileW, _oldPathW, _newPathW);
	} while (success < 0 && __threadErrno == EINTR);
#else
	__BEGIN_INTERRUPTABLE__
	do {
	    success = MoveFileW(_oldPathW, _newPathW);
	} while (success < 0 && __threadErrno == EINTR);
	__END_INTERRUPTABLE__
#endif
    }
    if (success > 0) {
	RETURN (nil);
    }
    error = __mkSmallInteger(__threadErrno);

err:;
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    ^ self primitiveFailed

    "
     OperatingSystem renameFile:'foo' to:'bar'
     OperatingSystem renameFile:'c:\windows' to:'c:\win'
    "
!

truncateFile:aPathName to:newSize
    "change a files size return true on success, false on failure.
     This may not be supported on all architectures.

     This is a low-level entry - use Filename protocol."

    ^ self primitiveFailed
! !

!Win32OperatingSystem class methodsFor:'file access rights'!

accessMaskFor:aSymbol
    "return the access bits mask for numbers as returned by
     OperatingSystem>>accessModeOf:
     and expected by OperatingSystem>>changeAccessModeOf:to:.
     Since these numbers are OS dependent, always use the mask
     (never hardcode 8rxxx into your code)."

%{  /* NOCONTEXT */
    /* posix systems should define these ... */
#   ifndef S_IRUSR
#    define S_IRUSR 0400
#   endif
#   ifndef S_IWUSR
#    define S_IWUSR 0200
#   endif
#   ifndef S_IXUSR
#    define S_IXUSR 0100
#   endif
#   ifndef S_IRGRP
#    define S_IRGRP 0040
#   endif
#   ifndef S_IWGRP
#    define S_IWGRP 0020
#   endif
#   ifndef S_IXGRP
#    define S_IXGRP 0010
#   endif
#   ifndef S_IROTH
#    define S_IROTH 0004
#   endif
#   ifndef S_IWOTH
#    define S_IWOTH 0002
#   endif
#   ifndef S_IXOTH
#    define S_IXOTH 0001
#   endif

    if (aSymbol == @symbol(readUser)) {
	RETURN ( __mkSmallInteger(S_IRUSR) );
    }
    if (aSymbol == @symbol(writeUser)) {
	RETURN ( __mkSmallInteger(S_IWUSR) );
    }
    if (aSymbol == @symbol(executeUser)) {
	RETURN ( __mkSmallInteger(S_IXUSR) );
    }
    if (aSymbol == @symbol(readGroup)) {
	RETURN ( __mkSmallInteger(S_IRGRP) );
    }
    if (aSymbol == @symbol(writeGroup)) {
	RETURN ( __mkSmallInteger(S_IWGRP) );
    }
    if (aSymbol == @symbol(executeGroup)) {
	RETURN ( __mkSmallInteger(S_IXGRP) );
    }
    if (aSymbol == @symbol(readOthers)) {
	RETURN ( __mkSmallInteger(S_IROTH) );
    }
    if (aSymbol == @symbol(writeOthers)) {
	RETURN ( __mkSmallInteger(S_IWOTH) );
    }
    if (aSymbol == @symbol(executeOthers)) {
	RETURN ( __mkSmallInteger(S_IXOTH) );
    }

    // These are not defined for Win32 - simply ignore them
    // (but handle them for UNIX compatibility
    if (aSymbol == @symbol(setUid)) {
	RETURN ( __mkSmallInteger(0) );
    }
    if (aSymbol == @symbol(setGid)) {
	RETURN ( __mkSmallInteger(0) );
    }
    if (aSymbol == @symbol(removeOnlyByOwner)) {
	RETURN ( __mkSmallInteger(0) );
    }

%}.
    ^ self primitiveFailed

    "
     OperatingSystem accessMaskFor:#readUser
    "
!

accessModeOf:aPathName
    "return a number representing access rights rwxrwxrwx for owner,
     group and others. Return nil if such a file does not exist.
     Notice that the returned number is OS dependent - use the
     modeMasks as returned by OperatingSystem>>accessMaskFor:"

    "
     this could have been implemented as:
	(self infoOf:aPathName) at:#mode
     but for huge directory searches the code below is faster
    "

    |error|

%{
    struct stat buf;
    int ret;

    if (__isStringLike(aPathName)) {
#ifdef DO_WRAP_CALLS
	char _aPathName[MAXPATHLEN];

	strncpy(_aPathName, __stringVal(aPathName), MAXPATHLEN-1); _aPathName[MAXPATHLEN-1] = '\0';

	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    ret = STX_C_NOINT_CALL2( "_stat", _stat, _aPathName, &buf);
	} while ((ret < 0) && (__threadErrno == EINTR));
#else
	__BEGIN_INTERRUPTABLE__
	do {
	    __threadErrno = 0;
	    ret = _stat( (char *)__stringVal(aPathName), &buf);
	} while ((ret < 0) && (__threadErrno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    __threadErrno = __WIN32_ERR(GetLastError());
	}
#endif
    } else if (__isUnicode16String(aPathName)) {
#ifdef DO_WRAP_CALLS
	char _wPathName[MAXPATHLEN];

	_makeWchar(aPathName, _wPathName, sizeof(_wPathName));

	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    ret = STX_C_NOINT_CALL2( "_wstat", _wstat, _wPathName, &buf);
	} while ((ret < 0) && (__threadErrno == EINTR));
#else
	__BEGIN_INTERRUPTABLE__
	do {
	    __threadErrno = 0;
	    ret = _wstat((char *)__unicode16StringVal(aPathName), &buf);
	} while ((ret < 0) && (__threadErrno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    __threadErrno = __WIN32_ERR(GetLastError());
	}
#endif
    } else
	goto out;

    if (ret >= 0) {
	RETURN ( __mkSmallInteger(buf.st_mode & 0777) );
    }
    error = __mkSmallInteger(__threadErrno);
out:;
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    ^ self primitiveFailed

   "
    (OperatingSystem accessModeOf:'/') printStringRadix:8
    (OperatingSystem accessModeOf:'foo') printStringRadix:8
    (OperatingSystem accessModeOf:'Make.proto') printStringRadix:8
    (OperatingSystem changeAccessModeOf:'foo' to:8r644)
    'Make.proto' asUnicode16String asFilename accessRights printStringRadix:8
   "
!

accessModeOfFd:aFileDescriptor
    "return a number representing access rights rwxrwxrwx for owner,
     group and others. Return nil if such a file does not exist.
     Notice that the returned number is OS dependent - use the
     modeMasks as returned by OperatingSystem>>accessMaskFor:"

    "
     this could have been implemented as:
	(self infoOf:aPathName) at:#mode
     but for huge directory searches the code below is faster
    "

    |error|

%{
    struct stat buf;
    int ret;

    if (__isSmallInteger(aFileDescriptor)) {
#ifdef DO_WRAP_CALLS
	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    ret = STX_C_NOINT_CALL2( "fstat", fstat, __smallIntegerVal(aFileDescriptor), &buf);
	} while ((ret < 0) && (__threadErrno == EINTR));
#else
	__BEGIN_INTERRUPTABLE__
	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    ret = fstat( __smallIntegerVal(aFileDescriptor), &buf);
	} while ((ret < 0) && (__threadErrno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    __threadErrno = __WIN32_ERR(GetLastError());
	}
#endif
    } else
	goto out;

    if (ret >= 0) {
	RETURN ( __mkSmallInteger(buf.st_mode & 0777) );
    }
    error = __mkSmallInteger(__threadErrno);
out:;
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].
    ^ self primitiveFailed

   "
    'c:\windows' asFilename readingFileDo:[:s|
	(OperatingSystem accessModeOfFd:s fileDescriptor) printStringRadix:8.
    ].
    'Make.proto' asFilename readingFileDo:[:s|
	(OperatingSystem accessModeOfFd:s fileDescriptor) printStringRadix:8.
    ].
    (OperatingSystem changeAccessModeOf:'Make.proto' to:8r644)
   "
!

changeAccessModeOf:aPathName to:modeBits
    "change the access rights of aPathName to the OS dependent modeBits.
     You should construct this mask using accessMaskFor, to be OS
     independent. Return nil if changed,
     an OsErrorHolder if such a file does not exist or change was not allowd."

    |error|

%{
    int ret;

    if (__isSmallInteger(modeBits)) {
	if (__isStringLike(aPathName)) {
#ifdef DO_WRAP_CALLS
	    int _chmod();
	    char _aPathName[MAXPATHLEN];

	    strncpy(_aPathName, __stringVal(aPathName), MAXPATHLEN-1); _aPathName[MAXPATHLEN-1] = '\0';
	    do {
		// do not cast to INT - will loose sign bit then!
		ret = STX_C_NOINT_CALL2( "_chmod", _chmod, _aPathName, __intVal(modeBits));
	    } while ((ret < 0) && (__threadErrno == EINTR));
#else
	    __BEGIN_INTERRUPTABLE__
	    do {
		ret = _chmod((char *)__stringVal(aPathName), __intVal(modeBits));
	    } while ((ret < 0) && (__threadErrno == EINTR));
	    __END_INTERRUPTABLE__
#endif
	} else if (__isUnicode16String(aPathName)) {
#ifdef DO_WRAP_CALLS
	    int _wchmod();
	    char _wPathName[MAXPATHLEN];

	    _makeWchar(aPathName, _wPathName, sizeof(_wPathName));
	    do {
		// do not cast to INT - will loose sign bit then!
		ret = STX_C_NOINT_CALL2( "_wchmod", _wchmod, _wPathName, __intVal(modeBits));
	    } while ((ret < 0) && (__threadErrno == EINTR));
#else
	    __BEGIN_INTERRUPTABLE__
	    do {
		ret = _chmod((wchar_t *)__unicode16StringVal(fullPathName), __intVal(modeBits));
	    } while ((ret < 0) && (__threadErrno == EINTR));
	    __END_INTERRUPTABLE__
#endif
	} else
	    goto out;

	if (ret >= 0) {
	    RETURN (nil);
	}

	error = __mkSmallInteger(__threadErrno);
    }
out:;
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    ^ self primitiveFailed:#argumentError

   "
    (OperatingSystem accessModeOf:'Make.proto') printStringRadix:8
    (OperatingSystem changeAccessModeOf:'Make.proto' to:8r644)
    'Make.proto' asUnicode16String asFilename accessRights
    'Make.proto' asUnicode16String asFilename accessRights:8r644
   "
! !

!Win32OperatingSystem class methodsFor:'file dialogs'!

commDlgExtendedError

    <apicall: ulong "CommDlgExtendedError" () module: "comdlg32.dll" >
    ^self primitiveFailed
!

getOpenFilename: openFilenameStructureExternalAddress
    "Opens a windows native file dialog without blocking stx
     for an OpenFilenameStructure stored in an externalStructure"

    | rslt |

%{  /* STACK: 32000*/

    void *__address;
    int __rslt;

    if (__isExternalAddressLike(openFilenameStructureExternalAddress)
     || __isExternalBytesLike(openFilenameStructureExternalAddress)){
	__address = __externalAddressVal(openFilenameStructureExternalAddress);
	__rslt = __STX_API_CALL1( "GetOpenFileNameA", (void *)GetOpenFileNameA, __address);

	if (__rslt == TRUE) {
	    rslt = true;
	} else {
	    rslt = false;
	}
    }
%}.
    rslt isNil ifTrue:[ self primitiveFailed ].
    ^ rslt

    "Modified (format): / 11-02-2014 / 21:18:02 / cg"
!

getSaveFilename: openFilenameStructureExternalAddress

    "Opens a windows native file dialog without blocking stx
     for an OpenFilenameStructure stored in an externalStructure."

    | rslt |

%{  /* STACK: 32000*/

    void  *__address;
    int __rslt;

    if (__isExternalAddressLike(openFilenameStructureExternalAddress)
     || __isExternalBytesLike(openFilenameStructureExternalAddress)){
	__address = __externalAddressVal(openFilenameStructureExternalAddress);
	__rslt = __STX_API_CALL1( "GetSaveFileName", (void *)GetSaveFileName, __address);

	if (__rslt == TRUE) {
	    rslt = true;
	} else {
	    rslt = false;
	}
    }
%}.
    rslt isNil ifTrue:[ self primitiveFailed ].
    ^ rslt

    "Modified: / 11-02-2014 / 21:18:20 / cg"
! !

!Win32OperatingSystem class methodsFor:'file queries'!

caseSensitiveFilenames
    "return true, if the OS has caseSensitive file naming.
     On MSDOS, this will return false;
     on a real OS, we return true."

    ^ false
!

clearHidden:aPathName
    "set the hidden attribute; Return true if the operation succeeded"

    |attr|

    attr := self primGetFileAttributes:aPathName.
    (attr bitTest:FILE_ATTRIBUTE_HIDDEN ) ifTrue:[
	^ self primSetFileAttributes:aPathName to:(attr bitClear:2).
    ].
    ^ true

    "Created: / 29-07-2010 / 11:31:55 / sr"
!

compressPath:pathName
    "return the pathName compressed - that is, remove all ..-entries
     and . entries. This does not always (in case of symbolic links)
     return the true pathName and is therefore used as a fallback
     if realPath and popen failed."

    |names n "{ Class: SmallInteger }" |

    names := pathName
		asCollectionOfSubstringsSeparatedBy:self fileSeparator.
    names := names asOrderedCollection.
    "
     cut off initial double-slashes
    "
    [names startsWith:#('' '')] whileTrue:[
	names removeFirst.
    ].
    "
     cut off double-slashes at end
    "
    [names endsWith:#('')] whileTrue:[
	names removeLast.
    ].
    "
     cut off current-dir at beginning
    "
    n := names size.
    [(n >= 2) and:[names startsWith:#('.')]] whileTrue:[
	names removeFirst.
	n := n - 1.
    ].

    "
     cut off parent-dirs at end
    "
    [(n > 2)
     and:[(names endsWith:#('..'))
     and:[((names at:(n - 1)) startsWith:'.') not ]]] whileTrue:[
	names removeLast; removeLast.
	n := n - 2.
    ].

    ^ names asStringWith:self fileSeparator
		    from:1
		    to:n
		    compressTabs:false final:nil

    "
     OperatingSystem compressPath:'.\..'
     OperatingSystem compressPath:'\foo\bar\baz\..'
     OperatingSystem compressPath:'foo\bar\baz\..'
     OperatingSystem compressPath:'foo\bar\baz\..\'
     OperatingSystem compressPath:'foo\bar\baz\..\\\'
     OperatingSystem compressPath:'\\\foo\bar\baz\..\\\'
    "

    "Modified: 1.11.1996 / 20:13:48 / cg"
!

fileSeparator
    "return the character used to separate names in a path.
     This character differs for MSDOS and other systems,
     (but those are currently not supported - so this is some
      preparation for the future)"

    ^ $\
!

getBinaryType:aPathName
    "determines whether a file is executable.
     Returns nil if not, or some symbol describing the type of
     binary otherwise."

%{
// the following is 'not-yet-known' in borland
#ifndef SCS_64BIT_BINARY
# define SCS_64BIT_BINARY 6
    // SCS_32BIT_BINARY = 0, // A 32-bit Windows-based application
    // SCS_64BIT_BINARY = 6, // A 64-bit Windows-based application.
    // SCS_DOS_BINARY = 1, // An MS-DOS – based application
    // SCS_OS216_BINARY = 5, // A 16-bit OS/2-based application
    // SCS_PIF_BINARY = 3, // A PIF file that executes an MS-DOS – based application
    // SCS_POSIX_BINARY = 4, // A POSIX – based application
    // SCS_WOW_BINARY = 2 // A 16-bit Windows-based application
#endif

    BOOL ok;
    DWORD binaryType;

    if (__isStringLike(aPathName)) {
	ok = GetBinaryTypeA(__stringVal(aPathName), &binaryType);
    } else if (__isUnicode16String(aPathName)) {
	ok = GetBinaryTypeW(__unicode16StringVal(aPathName), &binaryType);
    } else {
	goto badArgument;
    }

    if (ok) {
	OBJ typeSymbol = nil;

	switch (binaryType) {
	    case SCS_32BIT_BINARY:
		// A 32bit Windows-based application
		typeSymbol = @symbol(BINARY_32BIT);
		break;
	    case SCS_64BIT_BINARY:
		// A 64bit Windows-based application.
		typeSymbol = @symbol(BINARY_64BIT);
		break;
	    case SCS_DOS_BINARY:
		// An MSDOS based application
		typeSymbol = @symbol(BINARY_DOS);
		break;
	    case SCS_OS216_BINARY:
		// A 16bit OS/2-based application
		typeSymbol = @symbol(BINARY_OS2_16BIT);
		break;
	    case SCS_PIF_BINARY:
		// A PIF file that executes an MS-DOS – based application
		typeSymbol = @symbol(BINARY_PIF);
		break;
	    case SCS_POSIX_BINARY:
		// A POSIX based application
		typeSymbol = @symbol(BINARY_POSIX);
		break;
	    case SCS_WOW_BINARY:
		// A 16-bit Windows-based application
		typeSymbol = @symbol(BINARY_WOW16);
		break;
	    default:
		typeSymbol = @symbol(other);
		break;
	}
	RETURN (typeSymbol);
    }
    RETURN (nil);

badArgument: ;
%}.
    self primitiveFailed
!

getCurrentDirectory
    "get the current directory"

%{  /* NOCONTEXT */
    int ret;
    wchar_t _aPathName[MAXPATHLEN+1];

    ret = GetCurrentDirectoryW(MAXPATHLEN, _aPathName);
    if (ret == 0) {
	__threadErrno = __WIN32_ERR(GetLastError());
    }
    RETURN(__mkStringOrU16String_maxlen(_aPathName, MAXPATHLEN));
%}.

    "
     self getCurrentDirectory
    "
!

getDiskInfoOf:volumeNameArg
    "returns a dictionary filled with any of:
	freeBytes
	totalBytes
     and possibly additional (OS-specific) information"

    |volumeName info ok sectorsPerCluster bytesPerSector freeClusters totalClusters
     type freeBytesForUsersQuota freeBytes totalBytes |

    volumeName := volumeNameArg.
    (volumeName endsWith:$\) ifFalse:[
	volumeName := volumeName , '\'
    ].
%{
    typedef BOOL (WINAPI *P_GDFSE)(LPCTSTR, PULARGE_INTEGER,
				   PULARGE_INTEGER, PULARGE_INTEGER);
    P_GDFSE pGetDiskFreeSpaceEx = NULL;

    DWORD __sectorsPerCluster, __bytesPerSector, __freeClusters, __totalClusters;
    BOOL  fResult = 0;
    unsigned __int64 i64FreeBytesForUsersQuota, i64TotalBytes, i64FreeBytes;

    if (__isStringLike(volumeName) || __isSymbol(volumeName)) {
	 /*
	  *  Use GetDiskFreeSpaceEx if available; otherwise, use GetDiskFreeSpace.
	  *  Notice that GetDiskFreeSpace does not work correctly under win2k,
	  *  and GetDiskFreeSpaceEx is not avail. for all win versions (can microsoft ever do something right ?).
	  */
	pGetDiskFreeSpaceEx = (P_GDFSE)GetProcAddress (
					    GetModuleHandle ("kernel32.dll"),
							     "GetDiskFreeSpaceExA");
	if (pGetDiskFreeSpaceEx) {
	    fResult = pGetDiskFreeSpaceEx (__stringVal(volumeName),
				 (PULARGE_INTEGER)&i64FreeBytesForUsersQuota,
				 (PULARGE_INTEGER)&i64TotalBytes,
				 (PULARGE_INTEGER)&i64FreeBytes);
	    if (fResult) {
		freeBytesForUsersQuota = __MKUINT64(&i64FreeBytesForUsersQuota);
		totalBytes = __MKUINT64(&i64TotalBytes);
		freeBytes = __MKUINT64(&i64FreeBytes);
	    }
	}
	fResult = GetDiskFreeSpace(__stringVal(volumeName),
			     &__sectorsPerCluster,
			     &__bytesPerSector,
			     &__freeClusters,
			     &__totalClusters);
	if (fResult) {
	    sectorsPerCluster = __MKUINT(__sectorsPerCluster);
	    bytesPerSector = __MKUINT(__bytesPerSector);
	    freeClusters = __MKUINT(__freeClusters);
	    totalClusters = __MKUINT(__totalClusters);
	}
	switch (GetDriveType(__stringVal(volumeName))) {
	    case DRIVE_REMOVABLE:
		type = @symbol(removable); break;
	    case DRIVE_FIXED:
		type = @symbol(fixed); break;
	    case DRIVE_REMOTE:
		type = @symbol(network); break;
	    case DRIVE_CDROM:
		type = @symbol(cdrom); break;
	    case DRIVE_RAMDISK:
		type = @symbol(ramdisk); break;
	    case DRIVE_UNKNOWN:
	    default:
		break;
	}
	if (fResult) {
	    ok = true;
	} else {
	    __threadErrno = __WIN32_ERR(GetLastError());
	    @global(LastErrorNumber) = __mkSmallInteger(__threadErrno);
	}
    }
%}.
    ok == true ifFalse:[
	self primitiveFailed.
	^ self
    ].

    info := IdentityDictionary new.
    info at:#sectorsPerCluster put:sectorsPerCluster.
    info at:#bytesPerSector put:bytesPerSector.
    info at:#freeClusters put:freeClusters.
    info at:#totalClusters put:totalClusters.

    info at:#freeBytes put:(freeBytes notNil
				ifTrue:[freeBytes]
				ifFalse:[freeClusters * sectorsPerCluster * bytesPerSector]).
    info at:#totalBytes put:(totalBytes notNil
				ifTrue:[totalBytes]
				ifFalse:[totalClusters * sectorsPerCluster * bytesPerSector]).
    info at:#freeBytesForUsersQuota put:freeBytesForUsersQuota.
    type notNil ifTrue:[
	info at:#type put:type
    ].
    ^ info

    "
     self getDiskInfoOf:'c:\'
     self getDiskInfoOf:'d:\'
     self getDiskInfoOf:'e:\'
     self getDiskInfoOf:'f:\'. OperatingSystem lastErrorString
    "

    "Modified: / 26-09-2006 / 16:19:33 / cg"
!

getDriveList
    "return a list of volumes in the system.
     On unix, no such thing like a volume exists
     - there, a syntetic list with root, home & current is returned.
     On MSDOS, a list of drive letters is (eventually) returned.
     On VMS, a list of volumes is (eventually) returned."

    |list|

    list := OrderedCollection new.
%{
    /*
     * add drive letters as strings to list ...
     */
    char buffer[1024];
    char *cp;

    GetLogicalDriveStrings(1023, buffer);
    for (cp=buffer; *cp; ) {
      __SSEND1(list, @symbol(add:), 0, __MKSTRING(cp));
      cp += strlen(cp) + 1;
    }
%}.
    ^ list
!

getDriveType:aPathName
    "returns:
	0 -> Unknown
	1 -> Invalid
	2 -> removable
	3 -> fixed
	4 -> remote
	5 -> cdrom
	6 -> ramdisk.
    This is a stupid interface - do not use."

%{
    int ret;
    wchar_t _aPathName[MAXPATHLEN];

    if (_makeWchar(aPathName, _aPathName, sizeof(_aPathName)) > 0) {
#ifdef DO_WRAP_CALLS
	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    ret = (int)(STX_API_NOINT_CALL1( "GetDriveTypeW", GetDriveTypeW, _aPathName));
	} while ((ret < 0) && (__threadErrno == EINTR));
#else
	ret = GetDriveTypeW(_aPathName);
	if (ret < 0) {
	    __threadErrno = __WIN32_ERR(GetLastError());
	}
#endif
	RETURN (__MKSMALLINT(ret));
    }
%}.
    ^ self primitiveFailed

    "
     self getDriveType:'x:\'
     self getDriveType:'C:\'
     self getDriveType:'D:\'
    "
!

getFileVersionInfoOf:aPathName
    "retrieves the versionData from an executable or dll.
     The returned value is either a byteArray, which should be
     processed further with extractVersionValue (VerQueryValue),
     or nil.
     This is a WIN32 specific entry, not for common usage."
%{
    int sz;
    DWORD dummy;

    if (__isStringLike(aPathName)) {
	sz = GetFileVersionInfoSizeA(__stringVal(aPathName), &dummy);
    } else if (__isUnicode16String(aPathName)) {
	sz = GetFileVersionInfoSizeW(__unicode16StringVal(aPathName), &dummy);
    } else {
	goto badArgument;
    }

    if (sz > 0) {
	OBJ versionData;

	versionData = __BYTEARRAY_UNINITIALIZED_NEW_INT(sz);
	if (versionData == nil) {
	    RETURN (nil);
	}
	if (GetFileVersionInfo(__stringVal(aPathName), 0, sz, __ByteArrayInstPtr(versionData)->ba_element) == FALSE) {
	    RETURN (nil);
	}
	RETURN (versionData);
    }
    RETURN (nil);
badArgument: ;
%}.
    self primitiveFailed

    "Modified: / 05-07-2006 / 16:56:06 / cg"
!

getLongPathName:aPathName
    "get the full (long, not 8.3) version of aPathName"

%{
    int ret;
    wchar_t _aPathName[MAXPATHLEN+1];

    if (_makeWchar(aPathName, _aPathName, sizeof(_aPathName)) > 0) {
#ifdef DO_WRAP_CALLS
	 do {
	     __threadErrno = 0;
	     // do not cast to INT - will loose sign bit then!
	     ret = (int)(STX_API_NOINT_CALL3( "GetLongPathNameW", GetLongPathNameW, _aPathName, _aPathName, MAXPATHLEN));
	 } while ((ret == 0) && (__threadErrno == EINTR));
#else
	 ret = GetLongPathNameW(_aPathName, _aPathName, MAXPATHLEN);
	 if (ret == 0) {
	     __threadErrno = __WIN32_ERR(GetLastError());
	 }
#endif
	 RETURN (__mkStringOrU16String_maxlen(_aPathName, MAXPATHLEN));
    }
%}.
    ^ self primitiveFailed

    "
     self getLongPathName:'x:\'
     self getLongPathName:'c:\Dokumente und Einstellungen'
     self getShortPathName:'c:\Dokumente und Einstellungen'
    "
!

getNullDevice
    "get the name of the null-device."

    ^ 'nul:'
!

getObjectFileInfoFor:aStringOrFilename
    "Return and info object for given executable or shared object
     or throw an error if given file is not a valid an executable now
     shared object.

     The info object returned is OS-specific, however it responds to at
     least
	#isFor32BitArchitecture
	#isFor64BitArchitecture ... returns true, if the given object is for
				     32bit, 64bit architecture respectively
    "
    ^ PECOFFFileHeader fromFile: aStringOrFilename

    "Created: / 18-03-2015 / 09:52:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getShortPathName:aPathName
    "get the full (long, not 8.3) version of aPathName"

%{
    int ret;
    wchar_t _aPathName[MAXPATHLEN+1];

    if (_makeWchar(aPathName, _aPathName, sizeof(_aPathName)) > 0) {
#ifdef DO_WRAP_CALLS
	 do {
	     __threadErrno = 0;
	     // do not cast to INT - will loose sign bit then!
	     ret = (int)(STX_API_NOINT_CALL3( "GetShortPathNameW", GetShortPathNameW, _aPathName, _aPathName, MAXPATHLEN));
	 } while ((ret == 0) && (__threadErrno == EINTR));
#else
	 ret = GetShortPathNameW(_aPathName, _aPathName, MAXPATHLEN);
	 if (ret == 0) {
	     __threadErrno = __WIN32_ERR(GetLastError());
	 }
#endif
	 RETURN (__mkStringOrU16String_maxlen(_aPathName, MAXPATHLEN));
     }
%}.
    ^ self primitiveFailed

    "
     self getShortPathName:'x:\'
     self getShortPathName:'c:\Dokumente und Einstellungen'
     self getLongPathName:'c:\Dokumente und Einstellungen'
    "
!

getVolumeInformation: rootPath
    name: volumeNameBuffer
    nameSize: volumeNameSize
    serialNumber: serialNumber
    maximumComponentLength: maximumComponentLength
    fileSystemFlags: fileSystemFlags
    fileSystemName: fileSystemName
    fileSystemNameSize: fileSystemNameSize

    <apicall: boolean "GetVolumeInformationA" (struct struct ulong struct struct struct struct ulong) module: "kernel32.dll" >
    ^self primitiveFailed
!

infoOf:aPathName
    "return some object filled with info for the file 'aPathName';
     the info (for which corresponding access methods are understood by
     the returned object) is:
	 type            - a symbol giving the files type
	 mode            - numeric access mode
	 uid             - owners user id
	 gid             - owners group id
	 size            - files size
	 id              - files number (i.e. inode number)
	 accessed        - last access time (as Timestamp)
	 modified        - last modification time (as Timestamp)
	 statusChanged   - last status change time (as Timestamp)
	 alternativeName - (windows only:) the MSDOS name of the file

     Some of the fields may be returned as nil on systems which do not provide
     all of the information.
     Return nil if such a file does not exist.
     For symbolic links (if supported by the OS),
     the info of the pointed-to-file (i.e. the target) is returned;
     use #linkInfoOf: to get info about the link itself.
    "

    |info target|

    info := self linkInfoOf:aPathName.
    (info notNil and:[info isSymbolicLink]) ifTrue:[
	target := info path.
	target notNil ifTrue:[
	    ^ self linkInfoOf:target.
	]
    ].
    ^ info

   "
    OperatingSystem infoOf:'c:\windows'
    OperatingSystem infoOf:'stx.exe'
    (OperatingSystem infoOf:'/') uid
    (OperatingSystem infoOf:'/') accessed
   "

    "Modified: / 07-02-2007 / 10:37:14 / cg"
!

isDirectory:aPathName
    "return true, if 'aPathName' is a valid directory path name.
     (i.e. exists and is a directory).
     This also returns true for symbolic links pointing to a directory;
     if you need to check for this, use #linkInfo:."

%{
    int ret;

    if (__isStringLike(aPathName)) {
#ifdef DO_WRAP_CALLS
	char _aPathName[MAXPATHLEN];

	strncpy(_aPathName, __stringVal(aPathName), MAXPATHLEN-1); _aPathName[MAXPATHLEN-1] = '\0';
	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    ret = (int)(STX_API_NOINT_CALL1( "GetFileAttributesA", GetFileAttributesA, _aPathName));
	} while ((ret == -1) && (__threadErrno == EINTR));
#else
	ret = GetFileAttributesA((char *) __stringVal(aPathName));
	if (ret == -1) {
	    __threadErrno = __WIN32_ERR(GetLastError());
	}
#endif
    } else if (__isUnicode16String(aPathName)) {
	wchar_t _wPathName[MAXPATHLEN+1];

	_makeWchar(aPathName, _wPathName, sizeof(_wPathName));
#ifdef DO_WRAP_CALLS
	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    ret = (int)(STX_API_NOINT_CALL1( "GetFileAttributesW", GetFileAttributesW, _wPathName));
	} while ((ret == -1) && (__threadErrno == EINTR));
#else
	ret = GetFileAttributesW(_wPathName);
	if (ret == -1) {
	    __threadErrno = __WIN32_ERR(GetLastError());
	}
#endif
    } else
	goto err;

    if (ret < 0) {
	@global(LastErrorNumber) = __mkSmallInteger(__threadErrno);
	RETURN ( false );
    }
    RETURN ( (ret & FILE_ATTRIBUTE_DIRECTORY) ? true : false);
err:;
%}.
    ^ self primitiveFailed

    "an alternative implementation would be:
	^ (self infoOf:aPathName) type == #directory
    "
    "
     self isDirectory:'.'
     self isDirectory:'.' asUnicode16String
    "

    "Modified: / 05-07-2006 / 17:23:42 / cg"
!

isExecutable:aPathName
    "return true, if the given file is executable.
     For symbolic links, the pointed-to-file is checked."

    "/
    "/ under windows, there is no executable attribute ...
    "/ so, only check for the files existence here.
    "/
    ^ self isValidPath:aPathName.

    "Modified: / 05-07-2006 / 17:23:19 / cg"
!

isHidden:aPathName
    "return true, if the given file is hidden"

    |attr|

    attr := self primGetFileAttributes:aPathName.
    attr notNil ifTrue:[^ attr bitTest: FILE_ATTRIBUTE_HIDDEN ].
    ^ false

    "
     self isHidden:'.'
     self isHidden:'.' asUnicode16String
    "
!

isReadable:aPathName
    "return true, if the file/dir 'aPathName' is readable.
     For symbolic links, the pointed-to-file is checked."

    "under windows, all files are readable ...
     so, only check for the files existence here"

    ^ (self primGetFileAttributes:aPathName) notNil.

    "
     self isReadable:'.'
     self isReadable:'ughoiweuhiourw'
     self isReadable:'.' asUnicode16String
    "
!

isTemporary:aPathName
    "return true, if the given file is a temporary file"

    |attr|

    attr := self primGetFileAttributes:aPathName.
    attr notNil ifTrue:[^ attr bitTest: FILE_ATTRIBUTE_TEMPORARY ].
    ^ false

    "
     self isTemporary:'.'
     self isTemporary:'.' asUnicode16String
    "
!

isValidPath:aPathName
    "return true, if 'aPathName' is a valid path name
     (i.e. the file or directory exists)"

    ^ (self primGetFileAttributes:aPathName) notNil.
!

isWritable:aPathName
    "return true, if the given file is writable.
     For symbolic links, the pointed-to-file is checked.

     In Windows, files can possibly be created in and deleted from directories marked as read only.
     See http://support.microsoft.com/kb/326549.
     So we always return true for directories."

    |attr|

    attr := self primGetFileAttributes:aPathName.
    attr notNil ifTrue:[
	^ (attr bitAnd: (FILE_ATTRIBUTE_DIRECTORY bitOr: FILE_ATTRIBUTE_READONLY ))
	    ~~ FILE_ATTRIBUTE_READONLY
    ].
    ^ false

    "
     self isWritable:'.'
     self isWritable:'.' asUnicode16String
     self isWritable:'' asUnicode16String
    "
!

linkInfoOf:aPathName
    "return some object filled with info for the file 'aPathName';
     the info (for which corresponding access methods are understood by
     the returned object) is:
	 type            - a symbol giving the files type
	 mode            - numeric access mode
	 uid             - owners user id
	 gid             - owners group id
	 size            - files size
	 id              - files number (i.e. inode number)
	 accessed        - last access time (as Timestamp)
	 modified        - last modification time (as Timestamp)
	 statusChanged   - last status change time (as Timestamp)
	 alternativeName - (windows only:) the MSDOS name of the file

     Some of the fields may be returned as nil on systems which do not provide
     all of the information.
     Return nil if such a file does not exist.

     Return the info about the link itself,
     on contrast to #infoOf:, which returns the info of the pointed to file
     in case of a symbolic link.
    "

    |info type mode uid gid size id
     atime mtime ctime
     aOsTime mOsTime cOsTime
     fileName alternativeName|

%{
    BOOL result;
    int ret;
    wchar_t alternativeFileNameBuffer[15];
    wchar_t fileNameBuffer[MAXPATHLEN+1];
    int modeBits = 0;
    WIN32_FILE_ATTRIBUTE_DATA fileAttributeData;
    unsigned INT ino;
    wchar_t _wPathName[MAXPATHLEN+1];

    if (_makeWchar(aPathName, _wPathName, sizeof(_wPathName)) < 0)
	goto badArgument;

#ifdef DO_WRAP_CALLS
    {
	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    result = (int)(STX_API_NOINT_CALL3( "GetFileAttributesExW", GetFileAttributesExW, _wPathName, GetFileExInfoStandard, &fileAttributeData));
	} while (!result && (__threadErrno == EINTR));
    }
#else
    result = GetFileAttributesExW(_wPathName, GetFileExInfoStandard, &fileAttributeData);
    if (!result) {
	__threadErrno = __WIN32_ERR(GetLastError());
    }
#endif

    if (!result) {
	@global(LastErrorNumber) = __mkSmallInteger(__threadErrno);
    } else {
	id = __mkSmallInteger(0);   /* could get it by opening ... */
	size = __MKLARGEINT64(1, fileAttributeData.nFileSizeLow, fileAttributeData.nFileSizeHigh);

//        if (fileAttributeData.cFileName[0] != '\0') {
//            bcopy(fileAttributeData.cFileName, fileNameBuffer, MAXPATHLEN*sizeof(wchar_t));
//            fileNameBuffer[MAXPATHLEN] = '\0';
//            fileName = __mkStringOrU16String_maxlen(fileNameBuffer, MAXPATHLEN);             /* FULL name */
//        }

//        if (fileAttributeData.cAlternateFileName[0] != '\0') {
//            bcopy(fileAttributeData.cAlternateFileName, alternativeFileNameBuffer, 14*sizeof(wchar_t));
//            alternativeFileNameBuffer[14] = '\0';
//            alternativeName = __mkStringOrU16String_maxlen(alternativeFileNameBuffer, 14); /* DOS name */
//        }

	/*
	 * simulate access bits
	 */
	if (fileAttributeData.dwFileAttributes & FILE_ATTRIBUTE_READONLY) {
	    modeBits = 0444;
	} else {
	    modeBits = 0666;
	}

	if (fileAttributeData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
	    type = @symbol(directory);
	    modeBits = 0777;   /* executable and WRITABLE - refer to comment in #isWritable: */
	} else if (fileAttributeData.dwFileAttributes & FILE_ATTRIBUTE_REPARSE_POINT) {
	    type = @symbol(symbolicLink);
	    modeBits = 0777;   /* even in UNIX symlinks have 0777 */
	} else {
	    type = @symbol(regular);
	}

	mode = __mkSmallInteger(modeBits);

	cOsTime = FileTimeToOsTime1970(&fileAttributeData.ftCreationTime);
	aOsTime = FileTimeToOsTime1970(&fileAttributeData.ftLastAccessTime);
	mOsTime = FileTimeToOsTime1970(&fileAttributeData.ftLastWriteTime);
    }

  badArgument: ;
%}.

    (aPathName endsWith:'.lnk') ifTrue:[
	type := #symbolicLink.
	"/ now done lazily in FileStatusInfo, when the path is accessed
	"/ path := self getLinkTarget:aPathName.
    ].

    mode isNil ifTrue:[
	(self isDirectory:aPathName) ifTrue:[
	    "/ the code above fails for root directories (these do not exist).
	    "/ simulate here
	    mode := 8r777.
	    type := #directory.
	    uid := gid := 0.
	    size := 0.
	    id := 0.
	    atime := mtime := ctime := Timestamp now.
	].
    ].
    mode notNil ifTrue:[
	atime isNil ifTrue:[
	    "/ rebias to 1970 by subtracting the number of millis from 1.1.1601 to 1.1.1970
	    "/ aOsTime := aOsTime - self osTimeOf19700101. -- already done
	    atime := Timestamp new fromOSTime:aOsTime.
	].
	mtime isNil ifTrue:[
	    "/ rebias to 1970 by subtracting the number of millis from 1.1.1601 to 1.1.1970
	    "/ mOsTime := mOsTime - self osTimeOf19700101. -- already done
	    mtime := Timestamp new fromOSTime:mOsTime.
	].
	ctime isNil ifTrue:[
	    "/ rebias to 1970 by subtracting the number of millis from 1.1.1601 to 1.1.1970
	    "/ cOsTime := cOsTime - self osTimeOf19700101. -- already done
	    ctime := Timestamp new fromOSTime:cOsTime.
	].

	info := FileStatusInfo
		    type:type mode:mode
		    uid:uid gid:gid
		    size:size
		    id:id
		    accessed:atime modified:mtime created:ctime
		    sourcePath:aPathName
		    fullName:fileName alternativeName:alternativeName.
	^ info
   ].
   ^ nil

   "
    OperatingSystem linkInfoOf:'c:\windows'
    OperatingSystem linkInfoOf:'stx.exe'
    (OperatingSystem linkInfoOf:'/') uid
    (OperatingSystem linkInfoOf:'/') accessed
    OperatingSystem linkInfoOf:'C:\Dokumente und Einstellungen\stefan\Desktop\System.lnk'
   "

    "Modified: / 07-02-2007 / 10:30:14 / cg"
!

mimeTypeForSuffix:aFileSuffix
    "given a file suffix, return a corresponding mimeType.
     Here, the Registry is consulted.
     Returns nil if no mimeType for the given suffix is known."

    ^ RegistryEntry
	stringValueFor:'Content Type'
	atKey:('HKEY_CLASSES_ROOT\.' , aFileSuffix)

    "
     self mimeTypeForSuffix:'au'
     self mimeTypeForSuffix:'st'
     self mimeTypeForSuffix:'dll'
    "
!

parentDirectoryName
    "return the name used to refer to parent directories.
     In MSDOS, Unix and other systems this is '..', but maybe different
     for other systems.
     (but those are currently not supported - so this is some
      preparation for the future)"

    ^ '..'
!

pathNameOf:pathName
    "return the pathName of the argument, aPathString,
     - thats the full pathname of the directory, starting at '/'.
     This method needs the path to be valid
     (i.e. all directories must exist, be readable and executable).
     Notice: if symbolic links are involved, the result may look different
     from what you expect."

    |p path|

    "some systems have a convenient function for this ..."
    path := self primPathNameOf:pathName.

    path isNil ifTrue:[
	(self isValidPath:pathName) ifFalse:[
	    p := pathName.
	    [(p size > 1)
	     and:[p endsWith:(self fileSeparator)]
	    ] whileTrue:[
		p := p copyButLast:1.
	    ].
	    ^ p
	].

	"/
	"/ return the original - there is nothing else can we do
	"/
	path := self compressPath:pathName
    ].
    ^ path.

    "
     OperatingSystem pathNameOf:'.'
     OperatingSystem pathNameOf:'../smalltalk/../smalltalk'
     OperatingSystem pathNameOf:'../../..'
     OperatingSystem pathNameOf:'..'
     OperatingSystem pathNameOf:'/tmp////'
     OperatingSystem pathNameOf:'/foo/bar'
     OperatingSystem pathNameOf:'/foo/bar/'
     OperatingSystem pathNameOf:'/foo/bar//'
    "

    "Modified: 29.11.1996 / 18:02:12 / stefan"
    "Modified: 10.1.1997 / 19:10:42 / cg"
!

primGetFileAttributes:aPathName
    "get the file-attributes"

    |errorNumber|

%{
    int ret;

    if (__isStringLike(aPathName)) {
#ifdef DO_WRAP_CALLS
	char _aPathName[MAXPATHLEN];

	strncpy(_aPathName, __stringVal(aPathName), MAXPATHLEN-1); _aPathName[MAXPATHLEN-1] = '\0';
	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    ret = (int)(STX_API_NOINT_CALL1( "GetFileAttributesA", GetFileAttributesA, _aPathName));
	} while ((ret < 0) && (__threadErrno == EINTR));
#else
	ret = GetFileAttributesA((char *) __stringVal(aPathName));
	if (ret < 0) {
	    __threadErrno = __WIN32_ERR(GetLastError());
	}
#endif
	if (ret >= 0) {
	    RETURN ( __mkSmallInteger(ret) );
	}
	__threadErrno = __WIN32_ERR(GetLastError());
	RETURN (nil);
    }

    if (__isUnicode16String(aPathName)) {
	wchar_t _wPathName[MAXPATHLEN+1];

	_makeWchar(aPathName, _wPathName, sizeof(_wPathName));

#ifdef DO_WRAP_CALLS
	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    ret = (int)(STX_API_NOINT_CALL1( "GetFileAttributesW", GetFileAttributesW, _wPathName));
	} while ((ret < 0) && (__threadErrno == EINTR));
#else
	ret = GetFileAttributesW(_wPathName);
	if (ret < 0) {
	    __threadErrno = __WIN32_ERR(GetLastError());
	}
#endif
	if (ret >= 0) {
	    RETURN ( __mkSmallInteger(ret) );
	}
	__threadErrno = __WIN32_ERR(GetLastError());
	RETURN (nil);
    }
%}.
    (aPathName isString and:[aPathName isUnicode32String]) ifTrue:[
	"/ WIN32 only support 16 bit (wide) strings
	^ self primGetFileAttributes:aPathName asUnicode16String
    ].

    ^ self primitiveFailed

    "
     self primGetFileAttributes:'.'
     self primGetFileAttributes:'bc.mak'

     self primGetFileAttributes:'.' asUnicodeString
     self primGetFileAttributes:'.' asUnicode32String
     self primGetFileAttributes:'bc.mak' asUnicodeString
    "
!

primIdOf:aPathName
    "the actual code to return the fileNumber (i.e. inode number) of a file."

    ^ nil
!

primPathNameOf:aPathName
    "return the pathName of the argument, aPathString,
     - thats the full pathname of the directory, starting at 'X:\'.
     This method here returns nil, if the OS cannot perform the operation.
     Notice: if symbolic links are involved, the result may look different
     from what you expect."

    |error|

%{
    if (__isStringLike(aPathName)) {
	char nameBuffer[MAXPATHLEN + 1];
	char nameBuffer2[MAXPATHLEN + 1];
	char *returnedName = NULL;
	int rslt;

#ifdef DO_WRAP_CALLS
	char _aPathName[MAXPATHLEN+1];

	strncpy(_aPathName, __stringVal(aPathName), MAXPATHLEN-1); _aPathName[MAXPATHLEN-1] = '\0';
	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    rslt = (int)(STX_API_NOINT_CALL4( "GetFullPathNameA", GetFullPathNameA, _aPathName, MAXPATHLEN, nameBuffer, NULL));
	} while ((rslt < 0) && (__threadErrno == EINTR));
#else
	rslt = GetFullPathNameA(__stringVal(aPathName), MAXPATHLEN, nameBuffer, NULL);
#endif
	returnedName = nameBuffer;

	if (rslt > 0) {
#ifdef DO_WRAP_CALLS
	    do {
		__threadErrno = 0;
		// do not cast to INT - will loose sign bit then!
		rslt = (int)(STX_API_NOINT_CALL3( "GetLongPathNameA", GetLongPathNameA, nameBuffer, nameBuffer2, MAXPATHLEN));
	    } while ((rslt < 0) && (__threadErrno == EINTR));
#else
	    rslt = GetLongPathNameA(nameBuffer, nameBuffer2, MAXPATHLEN);
#endif
	    returnedName = nameBuffer2;
	}
	if (rslt > 0) {
	    RETURN ( __MKSTRING(returnedName) );
	}
	__threadErrno = __WIN32_ERR(GetLastError());
	RETURN (nil);
    }
    if (__isUnicode16String(aPathName)) {
	wchar_t nameBuffer[MAXPATHLEN + 1];
	wchar_t nameBuffer2[MAXPATHLEN + 1];
	wchar_t *returnedName = NULL;
	int rslt;
	wchar_t _wPathName[MAXPATHLEN+1];

	_makeWchar(aPathName, _wPathName, sizeof(_wPathName));

#ifdef DO_WRAP_CALLS
	do {
	    __threadErrno = 0;
	    rslt = (int)(STX_API_NOINT_CALL4( "GetFullPathNameW", GetFullPathNameW, _wPathName, MAXPATHLEN, nameBuffer, NULL));
	} while ((rslt < 0) && (__threadErrno == EINTR));
#else
	rslt = GetFullPathNameW(_wPathName, MAXPATHLEN, nameBuffer, NULL);
#endif

	returnedName = nameBuffer;

	if (rslt > 0) {

#ifdef DO_WRAP_CALLS
	    do {
		__threadErrno = 0;
		rslt = (int)(STX_API_NOINT_CALL3( "GetLongPathNameW", GetLongPathNameW, nameBuffer, nameBuffer2, MAXPATHLEN));
	    } while ((rslt < 0) && (__threadErrno == EINTR));
#else
	    rslt = GetLongPathNameW(nameBuffer, nameBuffer2, MAXPATHLEN);
#endif
	    returnedName = nameBuffer2;
	}
	if (rslt > 0) {
	    RETURN (__mkStringOrU16String_maxlen(returnedName, MAXPATHLEN));
	}
	__threadErrno = __WIN32_ERR(GetLastError());
	RETURN (nil);
    }
    error = @symbol(argument);     // argument is not a string or unicode16string
%}.

    error notNil ifTrue:[
	self primitiveFailed:error.
    ].
    ^ nil

    "
     self primPathNameOf:'.'
     self primPathNameOf:'.' asUnicode16String
     self primPathNameOf:5555
    "
!

primSetCurrentDirectoryA:pathName
    <apicall: bool "SetCurrentDirectoryA" ( pointer ) module: "kernel32.dll" >

    self primitiveFailed.

    "
     self primSetCurrentDirectory:'C:\Dokumente und Einstellungen\User\Eigene Dateien\work5\stx\projects\smalltalk'.
    "

    "Created: / 27-07-2006 / 14:47:12 / fm"
!

primSetCurrentDirectoryW:pathName
    <apicall: bool "SetCurrentDirectoryW" ( pointer ) module: "kernel32.dll" >

    self primitiveFailed.
!

primSetFileAttributes:aPathName to:anInteger
    "set the file-attributes; return true if the set did happen"

    |errorNumber|

%{
    int ret;

    if (__isSmallInteger(anInteger)) {
	if (__isStringLike(aPathName)) {
#ifdef DO_WRAP_CALLS
	    char _aPathName[MAXPATHLEN+1];

	    strncpy(_aPathName, __stringVal(aPathName), MAXPATHLEN-1); _aPathName[MAXPATHLEN-1] = '\0';
	    do {
		__threadErrno = 0;
		// do not cast to INT - will loose sign bit then!
		ret = (int)(STX_API_NOINT_CALL2( "SetFileAttributesA", SetFileAttributesA, _aPathName, __intVal(anInteger)));
	    } while ((ret < 0) && (__threadErrno == EINTR));
#else
	    ret = SetFileAttributesA((char *) __stringVal(aPathName), __intVal(anInteger));
	    if (ret < 0) {
		__threadErrno = __WIN32_ERR(GetLastError());
	    }
#endif
	    if (ret >= 0) {
		RETURN ( true );
	    }
	    __threadErrno = __WIN32_ERR(GetLastError());
	    RETURN (false);
	}

	if (__isUnicode16String(aPathName)) {
	    wchar_t _wPathName[MAXPATHLEN+1];

	    _makeWchar(aPathName, _wPathName, sizeof(_wPathName));
#ifdef DO_WRAP_CALLS
	    do {
		__threadErrno = 0;
		// do not cast to INT - will loose sign bit then!
		ret = (int)(STX_API_NOINT_CALL2( "SetFileAttributesW", SetFileAttributesW, _wPathName, __intVal(anInteger)));
	    } while ((ret < 0) && (__threadErrno == EINTR));
#else
	    ret = SetFileAttributesW(_wPathName, __intVal(anInteger));
	    if (ret < 0) {
		__threadErrno = __WIN32_ERR(GetLastError());
	    }
#endif
	    if (ret >= 0) {
		RETURN ( true );
	    }
	    __threadErrno = __WIN32_ERR(GetLastError());
	    RETURN (false);
	}
    }
%}.
    ^ self primitiveFailed
!

setCurrentDirectory:pathName
    pathName bitsPerCharacter == 16 ifTrue:[
	self primSetCurrentDirectoryW:(pathName copyWith:(Character value:0))
    ] ifFalse:[
	self primSetCurrentDirectoryA:pathName
    ].

    "
     self getCurrentDirectory
     self setCurrentDirectory:'C:\Users\cg\work\stx\projects'
     self getCurrentDirectory
     self setCurrentDirectory:'C:\Users\cg\work\stx\projects\smalltalk'
    "
!

setHidden:aPathName
    "set the hidden attribute. Return true if the operation succeeded"

    |attr|

    attr := self primGetFileAttributes:aPathName.
    (attr bitTest:FILE_ATTRIBUTE_HIDDEN ) ifFalse:[
	^ self primSetFileAttributes:aPathName to:(attr bitOr:2).
    ].
    ^ true  "/ aready set

    "Modified: / 29-07-2010 / 11:32:26 / sr"
!

setNormal:aPathName
    " sets all file attributes to the normal state
      e.g. set the hidden attribute to false (unhidden)"

    |attr|

    attr := self primGetFileAttributes:aPathName.
    (attr bitTest:FILE_ATTRIBUTE_NORMAL ) ifFalse:[
	^ self primSetFileAttributes:aPathName to:(attr bitOr:2).
    ].
    ^ true  "/ aready set
!

setTemporary:aPathName
    " set the temporary attribute of aPathName"

    |attr|

    attr := self primGetFileAttributes:aPathName.
    (attr bitTest:FILE_ATTRIBUTE_TEMPORARY ) ifFalse:[
	^ self primSetFileAttributes:aPathName to:(attr bitOr:2).
    ].
    ^ true  "/ aready set
!

timeOfLastAccess:aPathName
    "return the time, when the file was last accessed.
     For nonexistent files, nil is returned."

    "could be implemented as:
	(self infoOf:aPathName) accessed
    "
    | i|

    i := self infoOf:aPathName.
    i notNil ifTrue:[^ i accessTime].
    ^ nil.

    "
     OperatingSystem timeOfLastAccess:'/'
    "
!

timeOfLastChange:aPathName
    "return the time, when the file was last changed.
     For nonexistent files, nil is returned."

    "could be implemented as:
	(self infoOf:aPathName) modified
    "

    | i|

    i := self infoOf:aPathName.
    i notNil ifTrue:[^ i modificationTime].
    ^ nil.

    "
     OperatingSystem timeOfLastChange:'/'
    "
!

typeOf:aPathName
    "return the type of a file as a symbol; for nonexistent files,
     nil is returned.
     Notice: for symbolic links, the type of the pointed-to file is returned."

    |i|

    "
     this could have been implemented as:
	(self infoOf:aPathName) type
    "

    i := self infoOf:aPathName.
    i notNil ifTrue:[^ i type].
    ^ nil.

    "
     OperatingSystem typeOf:'/'
     OperatingSystem typeOf:'.'
     OperatingSystem typeOf:'Make.proto'
     OperatingSystem typeOf:'resources/motif.style'
    "
!

volumeLabelOf: aFilenameOrString

	"Answer the volume label of the disk containing aFilenameOrString."

    | volName |

    volName := String new: 255.
    ( self
	getVolumeInformation: aFilenameOrString asFilename volume, '\'
	name: volName
	nameSize: volName size
	serialNumber: nil
	maximumComponentLength: nil
	fileSystemFlags: nil
	fileSystemName: nil
	fileSystemNameSize: 0 )
	    ifFalse: [
		Transcript showCR:'GetVolumeInformation error'.
		^ ''
	].
    ^ volName copyUpTo: Character null

    "
	self volumeLabelOf: 'C:\pepe.pep'
	self volumeLabelOf: 'C:'
	self volumeLabelOf: 'C:\\'
	self volumeLabelOf: 'C:\'

    "
!

volumeNameOf:aPathString
    "return the volumeName of the argument, aPath
     - thats the name of the volume where aPath is.
     Not all OperatingSystem support/use volumes; on unix,
     this always returns an empty string."

    aPathString size < 2 ifTrue:[^ ''].
    (aPathString at:2) == $: ifTrue:[
	^ (aPathString at:1) asString.
    ].
    ^ ''
! !

!Win32OperatingSystem class methodsFor:'help support'!

openDocumentationFilename: aFilenameOrString
    <resource: #obsolete>

    self obsoleteMethodWarning:'call openApplicationForDocument:operation: and provide a proper error handler yourself'.

    "open a windows-shell application to present the document contained in aFilenameOrString.
     This looks for the files extension, and is typically used to present help-files,
     html documents, pdf documents etc."

    Error
	handle:[:ex |
	    Dialog warn:'Shell execution failed'
	] do:[
	    self openApplicationForDocument:aFilenameOrString operation:#open
	]

    "
     self openDocumentationFilename: 'C:\WINDOWS\Help\clipbrd.chm' asFilename
     self openDocumentationFilename: Filename currentDirectory
    "

    "Created: / 04-08-2006 / 18:04:52 / fm"
    "Modified: / 26-01-2007 / 14:05:44 / cg"
!

openHelpFile: helpFilename inContextID: contextID withOwner: anApplicationModel

    |ownerHandle macro|

    anApplicationModel notNil ifTrue:[ownerHandle := anApplicationModel window id].

    contextID isNil ifTrue: [^self primWinHelp: ownerHandle helpFile: helpFilename command: 3 "HelpIndex" dwData: nil ].
    contextID isInteger ifTrue: [^self primWinHelp: ownerHandle helpFile: helpFilename command: 1 "HelpContext" dwData: contextID ].

    self primWinHelp: ownerHandle helpFile: helpFilename command: 3 "HelpIndex" dwData: nil.       "force the help window open if not currently"

    macro := 'JumpId("', helpFilename asFilename baseName , '", "', contextID, '")'.
    self primWinHelp: nil helpFile: helpFilename command: 258 "HelpCommand" dwData: macro


"
    self openHelpFile: 'C:\vsw311\dapas.hlp' inContextID: 'IDH_ACI' withOwner: nil
"
!

primWinHelp: hWnd helpFile: aString command: anInteger dwData: anObject
    <apicall: bool "WinHelpA" ( handle lpstr int32 lpstr ) module: "user32.dll" >
    self primitiveFailed.

"
    anInteger
    - 1         HelpContext     to open in the specified contextID
    - 3         HelpIndex       to open in the help index
    - 258       HelpCommand     execute a macro string
"

"
    self primWinHelp: nil helpFile: 'C:\vsw311\dapas.hlp' command: 3 dwData: nil
"

    "Modified: / 19-12-2006 / 11:48:15 / User"
! !

!Win32OperatingSystem class methodsFor:'interrupts & signals'!

blockingTest
    "this is a test method;
     For testing double CTRL-C in blocking primitives"

%{
    while(1) {
	console_printf("blocking...");
	Sleep(50);
    }
%}.
    "
     OperatingSystem blockingTest
    "
!

blockingTest2
    "this is a test method;
     For testing single CTRL-C in blocking primitives"

%{
    while(1) {
	console_printf("blocking...");
	STX_API_CALL1("Sleep", Sleep, 50);
    }
%}.
    "
     OperatingSystem blockingTest2
    "
!

blockingTest3
    "this is a test method;
     For testing single CTRL-C in non-interruptable blocking primitives.
     This one should continue after typing continue in the debugger"

%{
    int ret;

    do {
	// do not cast to INT - will loose sign bit then!
	ret = (int)(STX_API_NOINT_CALL1("Sleep", Sleep, 60000));
    } while (ret < 0 && __threadErrno == EINTR);
%}.
    "
     OperatingSystem blockingTest3
    "
!

blockingTest4
    "this is a test method;
     For testing single CTRL-C in non-interruptable blocking primitives.
     This one start a new sleep after typing continue in the debugger"

%{
    int ret;

    do {
	// do not cast to INT - will loose sign bit then!
	ret = STX_API_CALL1("Sleep", Sleep, 60000);
    } while (ret < 0 && __threadErrno == EINTR);
%}.
    "
     OperatingSystem blockingTest4
    "
!

defaultSignal:signalNumber
    "revert to the default action on arrival of a (Unix-)signal.
     Dont confuse Unix signals with smalltalk signals.
     WARNING: for some signals, it is no good idea to revert to default;
     for example, the default for SIGINT (i.e. ^C) is to exit; while the
     default for SIGQUIT (^ \) is to dump core.
     Also, NOTICE that signal numbers are not portable between unix
     systems - use OperatingSystem sigXXX to get the numeric value for
     a signal."

%{  /* NOCONTEXT */

    if (__isSmallInteger(signalNumber)) {
#ifdef SIG_DFL
	signal(__intVal(signalNumber), SIG_DFL);
	RETURN (self);
#endif
    }
%}.
    "
     this error is triggered on non-integer argument
    "
    ^ self primitiveFailed

    "you better save a snapshot image before trying this ..."
    "
     'if you hit ^C now, Smalltalk will exit immediately' printNewline.
     OperatingSystem defaultSignal:(OperatingSystem sigINT).
     1 to:1000000 do:[:i| ].
     OperatingSystem enableSignal:(OperatingSystem sigINT).
     'normal ^C handling again.' printNewline
    "
!

disableIOInterruptsOn:fd
    "turn off IO interrupts for a filedescriptor"

    "
     this error is triggered on non-integer argument
     or if the OS does not support IO interrupts.
    "
    ^ self primitiveFailed
!

disableSignal:signalNumber
    "disable (Unix-) signal processing for signalNumber.
     Dont confuse Unix signals with smalltalk signals.
     WARNING: for some signals, it is no good idea to disable
     them; for example, disabling the SIGINT signal turns off ^C
     handling.
     Also, NOTICE that signal numbers are not portable between unix
     systems - use OperatingSystem sigXXX to get the numeric value for
     a signal.
     Use only for fully debugged stand alone applications."

%{  /* NOCONTEXT */

    if (__isSmallInteger(signalNumber)) {
	int sigNo = __intVal(signalNumber);

	if (sigNo == 0) {
	    RETURN (self);
	}
#ifdef SIG_IGN
	signal(sigNo, SIG_IGN);
	RETURN (self);
#endif
    }
%}.
    "
     this error is triggered on non-integer argument
    "
    ^ self primitiveFailed

    "
     'now, ^C is totally ignored ...' printNewline.
     OperatingSystem disableSignal:(OperatingSystem sigINT).
     1 to:1000000 do:[:i| ].
     OperatingSystem enableSignal:(OperatingSystem sigINT).
     '^C handled again.' printNewline
    "
!

disableTimer
    "disable timer interrupts.
     WARNING:
	the system will not operate correctly with timer interrupts
	disabled, because no scheduling or timeouts are possible."

%{  /* NOCONTEXT */

    extern void __win32ClearTimer();

    __win32ClearTimer();
%}.
    ^ true
!

enableChildSignalInterrupts
    "childSignal interrupts are not supported in windows"

    ^ self
!

enableIOInterruptsOn:fd
    "turn on IO interrupts for a filedescriptor"

    "
     this error is triggered on non-integer argument
     or if the system does not support SIGIO
    "
    ^ self primitiveFailed
!

enableSignal:signalNumber
    "enable (Unix-)signal processing for signalNumber.
     Dont confuse Unix signals with smalltalk signals.
     The signal will be delivered to one of the standard handlers
     (SIGINT, SIGQUIT, etc) or to a general handler, which
     sends #signalInterrupt:.

     NOTICE that signal numbers are not portable between unix
     systems - use OperatingSystem sigXXX to get the numeric value for
     a signal."

%{  /* NOCONTEXT */

# define SIG_LIMIT 30

#if defined(SIGPOLL) && !defined(SIGIO)
# define SIGIO SIGPOLL
#endif

#ifdef SIGCHLD
# define CHILD_SIGNAL   SIGCHLD
#else
# ifdef SIGCLD
#  define CHILD_SIGNAL  SIGCLD
# endif
#endif

    int sigNr;

#if defined(SIGINT) || defined(SIGQUIT)
# ifndef __signalUserInterrupt
    extern void __signalUserInterrupt(SIGHANDLER_ARG);
# endif
#endif

#ifdef SIGFPE
# ifndef __signalFpExceptionInterrupt
    extern void __signalFpExceptionInterrupt(SIGHANDLER_ARG);
# endif
#endif

#ifdef SIGIO
# ifndef __signalIoInterrupt
    extern void __signalIoInterrupt(SIGHANDLER_ARG);
# endif
#endif

#ifdef CHILD_SIGNAL
# ifndef __signalChildInterrupt
    extern void __signalChildInterrupt(SIGHANDLER_ARG);
# endif
#endif

#ifdef SIGPIPE
# ifndef __signalPIPEInterrupt
    extern void __signalPIPEInterrupt(SIGHANDLER_ARG);
# endif
#endif

#ifdef SIGBUS
# ifndef __signalBUSInterrupt
    extern void __signalBUSInterrupt(SIGHANDLER_ARG);
# endif
#endif

#ifdef SIGSEGV
# ifndef __signalSEGVInterrupt
    extern void __signalSEGVInterrupt(SIGHANDLER_ARG);
# endif
#endif

#if defined(SIGILL) || defined(SIGEMT)
# ifndef __signalTrapInterrupt
    extern void __signalTrapInterrupt(SIGHANDLER_ARG);
# endif
#endif

#ifdef SIGALRM
# ifndef WIN32
#  ifndef __signalTimerInterrupt
    extern void __signalTimerInterrupt(SIGHANDLER_ARG);
#  endif
# endif
#endif

#ifndef __signalInterrupt
    extern void __signalInterrupt(SIGHANDLER_ARG);
#endif
    void (*handler)(SIGHANDLER_ARG);

    if (__isSmallInteger(signalNumber)
     && ((sigNr = __intVal(signalNumber)) >= 0)
#ifdef SIG_LIMIT
     &&  (sigNr <= SIG_LIMIT)
#endif
    ) {
	/*
	 * standard signals are forced into standard handlers
	 * - all others go into general signalInterrupt
	 */
#if defined(SIGPOLL) && defined(SIGIO)
	if (sigNr == SIGPOLL)
	    sigNr = SIGIO;
#endif
	switch (sigNr) {
	    case 0:
		/* enabling a non-supported signal */
		RETURN (self);

#ifdef SIGBREAK
	    case SIGBREAK:
#endif
#ifdef SIGINT
	    case SIGINT:
#endif
#ifdef SIGQUIT
	    case SIGQUIT:
#endif
#ifdef SIGNALDEBUGWIN32
		console_printf("ConsoleSignal %d\n",sigNr);
#endif
		SetConsoleCtrlHandler((PHANDLER_ROUTINE)__signalUserInterruptWIN32,TRUE);
		RETURN (self);
#ifdef SIGFPE
	    case SIGFPE:
		handler = __signalFpExceptionInterrupt;
		break;
#endif

#ifdef SIGPIPE
	    case SIGPIPE:
		handler = __signalPIPEInterrupt;
		break;
#endif
#ifdef SIGBUS
	    case SIGBUS:
		handler = __signalBUSInterrupt;
		break;
#endif
#ifdef SIGSEGV
	    case SIGSEGV:
		handler = __signalSEGVInterrupt;
		break;
#endif
#ifdef SIGILL
	    case SIGILL:
		handler = __signalTrapInterrupt;
		break;
#endif
#ifdef SIGEMT
	    case SIGEMT:
		handler = __signalTrapInterrupt;
		break;
#endif
#ifdef SIGIO
	    case SIGIO:
		handler = __signalIoInterrupt;
		break;
#endif

#ifdef CHILD_SIGNAL
	    case CHILD_SIGNAL:
		handler = __signalChildInterrupt;
		break;
#endif

	    default:
		handler = __signalInterrupt;
		break;
	}

	{
#ifdef HAS_SIGACTION
	    struct sigaction act;

	    /*
	     * Do not add SA_RESTART here. A signal can cause a
	     * thread switch, another thread can do a garbage collect
	     * and restarted system calls may write into old
	     * (collected) addresses.
	     */

	    act.sa_flags = SA_SIGINFO; /* <- if you add more, remember dummys at the top */
	    sigemptyset(&act.sa_mask);
	    act.sa_handler = handler;
	    sigaction(sigNr, &act, 0);
#else
# ifdef HAS_SIGVEC
	    struct sigvec vec;

	    vec.sv_flags = SV_INTERRUPT;
	    sigemptyset(&vec.sv_mask);
	    vec.sv_handler = handler;
	    sigvec(sigNr, &vec, NULL);
# else
#  ifdef WIN32
#   ifdef SIGNALDEBUGWIN32
	    console_printf("signal %d can't change handler\n",sigNr);
#   endif
#  else
	    (void) signal(sigNr, handler);
#  endif
# endif
#endif
	}

	/*
	 * maybe, we should Return the old enable-status
	 * as boolean here ...
	 */
	RETURN (self);
    }
%}.

    "
     this error is triggered on non-integer argument, or
     if the signal number is not in the valid range (1..NSIG)
    "
    ^ self primitiveFailed
!

enableTimer:milliSeconds
    "setup for a timerInterrupt, to be signalled after some (real) time."

%{  /* NOCONTEXT */
    extern void __win32SetTimer();

    if (__isSmallInteger(milliSeconds)) {
	__win32SetTimer( __intVal(milliSeconds) );
	RETURN (true);
    }
%}.
    ^ false
!

isFatalSignal:aNumber
   "return true if a signal with number aNumber is a fatal signal,
    i.e. some severe internal error occured"

   ^ (aNumber == self sigSEGV)
     or:[aNumber == self sigILL
     or:[aNumber == self sigBUS]]
!

killProcess:processId
    "kill a process.
     The process terminates immediately and has no chance to perform any cleanup actions.

     WARNING: in order to avoid zombie processes (on unix),
	      you have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId."

    self terminateProcess:processId
!

killProcessGroup:processGroupId
    "kill a process group.
     The process(es) terminate immediately and has no chance to perform any cleanup actions.

     WARNING: in order to avoid zombie processes (on unix),
	      you have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId."

    self terminateProcessGroup:processGroupId
!

microsecondSleep:micros
    "cease ANY action for some time.
     This suspends the whole smalltalk (unix/windows-) process for some time.
     Not really useful since not even low-prio processes and interrupt
     handling will run during the sleep.
     Use either OperatingSystem>>millisecondDelay: (which makes all
     threads sleep, but handles interrupts) or use a Delay
     (which makes only the calling thread sleep)."

    |uLow uHigh|

    uLow := micros // 1000000.
    uHigh := micros \\ 1000000.
%{
    struct timeval tv;
    fd_set dummy;
    int success;

    SOCKET s = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
    FD_ZERO(&dummy);
    FD_SET(s, &dummy);
    tv.tv_sec = __intVal(uLow);
    tv.tv_usec = __intVal(uHigh);
    success = (0 == select(0, 0, 0, &dummy, &tv));
    closesocket(s);
    RETURN (success ? true : false);
%}

    "
     Timestamp now printCR.
     OperatingSystem microsecondSleep:100.
     Timestamp now printCR.
    "

    "Created: / 28-05-2015 / 14:14:53 / gg"
!

sendSignal:signalNumber to:processId
    "send a unix signal to some process (maybe myself).
     Returns false if any error occurred, true otherwise.

     Do not confuse UNIX signals with Smalltalk-Signals.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId
	      if the signal terminates that process."

    "/
    "/ either invalid argument (non-integers)
    "/ or not supported by OS
    "/
    ^ self primitiveFailed
!

sendSignal:signalNumber to:processId toGroup:toGroupBoolean toAll:toAllBoolean
    "send a unix signal to some process (maybe myself).
     Returns false if any error occurred, true otherwise.

     Do not confuse UNIX signals with Smalltalk-Signals.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId
	      if the signal terminates that process."

    "/
    "/ either invalid argument (non-integers)
    "/ or not supported by OS
    "/
    ^ self primitiveFailed
!

terminateProcess:processHandleOrPid
    "terminate a process.

     ATTENTION WIN32:
	 Under unix, we have terminateProcess, which does a soft
	 terminate (giving the process a chance to cleanup) and
	 killProcess, which does a hard terminate.
	 Under WIN32, both (currently) use the TerminateProcess
	 function, which unconditionally causes a process to exit.
	 I.e. under WIN32, the process has no chance to perform cleanup.
	 Use it only in extreme circumstances. The state of
	 global data maintained by dynamic-link libraries (DLLs)
	 may be compromised if TerminateProcess is used.

     TODO: send a WM_QUIT instead, to allow for proper shutdown."

    self terminateProcess:processHandleOrPid exitCode:0
!

terminateProcess:processHandleOrPid exitCode:exitCode
    "terminate a process.

     ATTENTION WIN32:
	 Under unix, we have terminateProcess, which does a soft
	 terminate (giving the process a chance to cleanup) and
	 killProcess, which does a hard terminate.
	 Under WIN32, both (currently) use the TerminateProcess
	 function, which unconditionally causes a process to exit.
	 I.e. under WIN32, the process has no chance to perform cleanup.
	 Use it only in extreme circumstances. The state of
	 global data maintained by dynamic-link libraries (DLLs)
	 may be compromised if TerminateProcess is used.

     TODO: send a WM_QUIT instead, to allow for proper shutdown."

%{
    if (__isExternalAddressLike(processHandleOrPid) ) {
	HANDLE hProcess = _HANDLEVal(processHandleOrPid);

	if (hProcess != 0) {
	    TerminateProcess( hProcess, __intVal(exitCode) );
	}
	RETURN( true );
    } else if( __isSmallInteger(processHandleOrPid) ) {
	HANDLE hProcess = OpenProcess(PROCESS_TERMINATE, 0, __smallIntegerVal(processHandleOrPid));

	if( hProcess != 0 ) {
	    TerminateProcess( hProcess, __intVal(exitCode) );
	    CloseHandle(hProcess);
	}
	RETURN( true );
    }
%}.
    self primitiveFailed:#invalidParameter.


    "Modified: / 28.12.1995 / 15:05:37 / stefan"
    "Modified: / 27.1.1998 / 20:05:47 / cg"
!

terminateProcessGroup:processGroupHandleOrPid
    "terminate a process group (that is all subprocesses of a process).

     ATTENTION WIN32:
	 Under unix, we have terminateProcess, which does a soft
	 terminate (giving the process a chance to cleanup) and
	 killProcess, which does a hard terminate.
	 Under WIN32, both (currently) use the TerminateProcess
	 function, which unconditionally causes a process to exit.
	 I.e. under WIN32, the process has no chance to perform cleanup.
	 Use it only in extreme circumstances. The state of
	 global data maintained by dynamic-link libraries (DLLs)
	 may be compromised if TerminateProcess is used.
     TODO: send a WM_QUIT instead, to allow for proper shutdown."

    | pid list groupsToTerminate anyMore |

    list := self getAllProcesses.
    list size == 0 ifTrue:[^ self ].

    processGroupHandleOrPid isInteger ifTrue:[
	pid := processGroupHandleOrPid
    ] ifFalse:[
	pid := processGroupHandleOrPid pid.
    ].
    groupsToTerminate := Set with:pid.
    list := list asSet.

    "/ Transcript show:'terminate group '; showCR:pid.
    anyMore := true.
    [anyMore] whileTrue:[
	anyMore := false.
	list doWithExit:[:anOSProcess :exit |
	    |pid|

	    (groupsToTerminate includes:anOSProcess parentPid) ifTrue:[
		pid := anOSProcess pid.
		groupsToTerminate add:pid.
		"/ Transcript show:'terminate '; showCR:pid.
		self terminateProcess:pid.
		list remove:anOSProcess.
		anyMore := true.
		"/ need to restart: we have removed an element inside the loop
		exit value:nil
	    ].
	].
    ].
! !

!Win32OperatingSystem class methodsFor:'ipc support'!

makePipe
    "make a pipe, return array with two filedescriptors on success,
     nil on failure.
     This is a lowLevel entry, not for public use.
     See NonPositionableExternalStream>>makePipe for a more user-friendly, public interface."

    |fd1 fd2 error|

%{
    HANDLE   pipeRead  = (HANDLE)0;
    HANDLE   pipeWrite = (HANDLE)0;

    SECURITY_ATTRIBUTES sa;

    ZeroMemory(&sa, sizeof(SECURITY_ATTRIBUTES));
    sa.nLength = sizeof(SECURITY_ATTRIBUTES);
    sa.lpSecurityDescriptor = NULL;
    // sa.bInheritHandle = TRUE;
    sa.bInheritHandle = FALSE;

    if( ! CreatePipe( &pipeRead, &pipeWrite, &sa, 0 ) ) {
	@global(LastErrorNumber) = error = __mkSmallInteger( __WIN32_ERR(GetLastError()) );
	goto out;
    }

#if 1
    fd1 = __MKEXTERNALADDRESS(pipeRead);
    fd2 = __MKEXTERNALADDRESS(pipeWrite);
#else
    /*
     * make fileDescriptors from handles
     */
# ifdef PROCESSDEBUGWIN32
    if (flag_PROCESSDEBUGWIN32) {
	console_printf("piperead %x\n",pipeRead);
	console_printf("pipewrite %x\n",pipeWrite);
    }
# endif
    fd1 = __mkSmallInteger(_open_osfhandle(pipeRead, O_BINARY));
    fd2 = __mkSmallInteger(_open_osfhandle(pipeWrite, O_BINARY));
#endif
out:;
%}.
    (fd1 notNil and:[fd2 notNil]) ifTrue:[
	(fd1 ~~ -1 and:[fd2 ~~ -1]) ifTrue:[
	    ^ Array with:fd1 with:fd2.
	].
    ].

    ^ nil
! !

!Win32OperatingSystem class methodsFor:'misc'!

closePid:pid
    "free pid resource"
%{
    if (__isExternalAddressLike(pid) ) {
	HANDLE __pid = _HANDLEVal(pid);

	if (__pid != 0) {
#ifdef PROCESSDEBUGWIN32
	    if (flag_PROCESSDEBUGWIN32) {
		console_printf("Close ProcessHandle %x\n", __pid);
	    }
#endif
	    CloseHandle(__pid);
	    _SETHANDLEVal(pid, 0);
	}
    }
%}.
    ^ true.

    "Created: 28.1.1998 / 14:23:04 / md"
    "Modified: 28.1.1998 / 14:27:18 / md"
!

duplicateHandle:aHandle to:targetProcessHandle
    |hMe spaceForTargetHandle rslt addr|

    spaceForTargetHandle := ExternalLong unprotectedNew.
    hMe := self getCurrentProcess.
    rslt := self
		primDuplicateHandle_hSourcProcessHandle:hMe
		hSourceHandle:aHandle
		hTargetProcesshandle:targetProcessHandle ? hMe
		lpTargetHandle:spaceForTargetHandle
		dwDesiredAccess:0
		bInheritHandle:false
		dwOptions:2 "DUPLICATE_SAME_ACCESS".

    rslt ifFalse:[
	spaceForTargetHandle free.
	self primitiveFailed:self primGetLastError.
	^ nil
    ].

    addr := spaceForTargetHandle value.
    spaceForTargetHandle free.
    ^ ExternalAddress newAddress:addr.

    "Created: / 18-09-2007 / 16:34:25 / cg"
    "Modified: / 21-11-2012 / 12:14:06 / anwild"
!

getAllProcesses
    "answer a sequence of OSProcess, all processes running in system"

    |list st_perProc f|

    list := OrderedCollection new.

%{
#ifdef TLHELP32_H_INCLUDE

    HANDLE hProcessSnap;
    PROCESSENTRY32 pe32;
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

    if( hProcessSnap != INVALID_HANDLE_VALUE ) {
	pe32.dwSize = sizeof(PROCESSENTRY32);
	Process32First( hProcessSnap, & pe32 );

	do {
	    st_perProc = __SSEND0(@global(Win32OperatingSystem::OSProcessDescriptor), @symbol(new), 0);
	    f = __MKSTRING(pe32.szExeFile);
	    __SSEND1(st_perProc, @symbol(commandLine:), 0, f );
	    __SSEND1(st_perProc, @symbol(pid:), 0, __mkSmallInteger(pe32.th32ProcessID) );
	    __SSEND1(st_perProc, @symbol(parentPid:), 0, __mkSmallInteger(pe32.th32ParentProcessID) );

	    __SSEND1(list, @symbol(add:), 0, st_perProc );
	}
	while(Process32Next(hProcessSnap,&pe32));
	CloseHandle( hProcessSnap );
    }

#endif  /* TLHELP32_H_INCLUDE */

%}.
    ^ list
!

getCurrentProcess
    <apicall: handle "GetCurrentProcess" ( ) module: "kernel32.dll" >

    "
     self getCurrentProcess
    "

    "Created: / 18-09-2007 / 16:32:22 / cg"
!

getPrivateProfileString:appNameString key:keyNameString default:defaultString fileName:fileName
    ^ self
	getProfileString:appNameString key:keyNameString default:defaultString
	fileName:fileName private:true

    "Modified: / 27-07-2006 / 11:57:03 / fm"
!

getProfileString:appNameString key:keyNameString default:defaultString
%{
    char *__appNameString = NULL;
    char *__keyNameString = NULL;
    char *__defaultString = NULL;
    char *__returnedString = NULL;
    char quickBuffer[1024];
    char *usedBuffer = quickBuffer;
    int bufferSize = sizeof(quickBuffer);
    int nChars;
    OBJ retVal;

    if (__isStringLike(appNameString)) {
	__appNameString = __stringVal(appNameString);
    } else if (appNameString != nil)
	goto primitiveFail;

    if (__isStringLike(keyNameString)) {
	__keyNameString = __stringVal(keyNameString);
    } else if (keyNameString != nil)
	goto primitiveFail;

    if (__isStringLike(defaultString)) {
	__defaultString = __stringVal(defaultString);
    } else if (defaultString != nil)
	goto primitiveFail;

    do {
	nChars = GetProfileString(__appNameString, __keyNameString, __defaultString, usedBuffer, bufferSize);
	if (nChars >= 0) {
	    if (nChars != bufferSize-1) {
		retVal = __MKSTRING_L(usedBuffer, nChars);
		if (usedBuffer != quickBuffer) free(usedBuffer);
		RETURN (retVal);
	    }

	    {
		/* use a bigger buffer */
		char *newBuffer;
		int newBufferSize = bufferSize * 2;

		newBuffer = (char *)malloc( newBufferSize );
		if (usedBuffer != quickBuffer) free(usedBuffer);
		usedBuffer = newBuffer;
		bufferSize = newBufferSize;
	    }
	}

    } while (nChars > 0);
    RETURN (nil);
  primitiveFail: ;
%}.
    ^ self primitiveFailed

    "Created: / 27-07-2006 / 11:54:59 / fm"
!

getProfileString:appNameString key:keyNameString default:defaultString fileName:fileName private:private
%{
    char *__appNameString = NULL;
    char *__keyNameString = NULL;
    char *__defaultString = NULL;
    char *__returnedString = NULL;
    char *__fileName = NULL;
    char quickBuffer[1024];
    char *usedBuffer = quickBuffer;
    int bufferSize = sizeof(quickBuffer);
    int nChars;
    OBJ retVal;

    if (__isStringLike(appNameString)) {
	__appNameString = __stringVal(appNameString);
    } else if (appNameString != nil)
	goto primitiveFail;

    if (__isStringLike(keyNameString)) {
	__keyNameString = __stringVal(keyNameString);
    } else if (keyNameString != nil)
	goto primitiveFail;

    if (__isStringLike(defaultString)) {
	__defaultString = __stringVal(defaultString);
    } else if (defaultString != nil)
	goto primitiveFail;

    if (private == true) {
	if (! __isStringLike(fileName)) goto primitiveFail;
	__fileName = __stringVal(fileName);
    }

    do {
	if (private == true) {
	    nChars = GetPrivateProfileString(__appNameString, __keyNameString, __defaultString, usedBuffer, bufferSize, __fileName);
	} else {
	    nChars = GetProfileString(__appNameString, __keyNameString, __defaultString, usedBuffer, bufferSize);
	}
	if (nChars >= 0) {
	    if (nChars != bufferSize-1) {
		retVal = __MKSTRING_L(usedBuffer, nChars);
		if (usedBuffer != quickBuffer) free(usedBuffer);
		RETURN (retVal);
	    }

	    {
		/* use a bigger buffer */
		char *newBuffer;
		int newBufferSize = bufferSize * 2;

		newBuffer = (char *)malloc( newBufferSize );
		if (usedBuffer != quickBuffer) free(usedBuffer);
		usedBuffer = newBuffer;
		bufferSize = newBufferSize;
	    }
	}

    } while (nChars > 0);
    RETURN (nil);
  primitiveFail: ;
%}.
    ^ self primitiveFailed

    "Created: / 27-07-2006 / 11:55:25 / fm"
!

hInstance
    "very Win32 specific: get the HINSTANCE of the executable"

%{
    extern void *__getHInstance();

    RETURN (__MKEXTERNALADDRESS(__getHInstance()));
%}.

    "
     Win32OperatingSystem hInstance
    "
!

isValidHandle:anExternalAddress
    |newHandle|

    newHandle := self duplicateHandle:anExternalAddress to:nil.
    newHandle isNil ifTrue:[
	^ false.
    ].
"/    self closeHandle:newHandle.
    ^ true.
!

playSound:fileName
    self playSound:fileName mode:1

"/#define SND_SYNC            0x0000  /* play synchronously (default) */
"/#define SND_ASYNC           0x0001  /* play asynchronously */
"/#define SND_NODEFAULT       0x0002  /* silence (!!default) if sound not found */
"/#define SND_LOOP            0x0008  /* loop the sound until next sndPlaySound */
"/#define SND_NOSTOP          0x0010  /* don't stop any currently playing sound */

    "
     self
	playSound:'C:\Dokumente und Einstellungen\cg\work\exept\expecco\resources\sounds\start.wav'
    "

    "Created: / 06-11-2007 / 00:46:57 / cg"
!

playSound:fileName mode:modeInteger
    <apicall: void "sndPlaySoundA" ( lpstr uint32) module: "winmm.dll" >
    ^ self primitiveFailed.

"/#define SND_SYNC            0x0000  /* play synchronously (default) */
"/#define SND_ASYNC           0x0001  /* play asynchronously */
"/#define SND_NODEFAULT       0x0002  /* silence (!!default) if sound not found */
"/#define SND_LOOP            0x0008  /* loop the sound until next sndPlaySound */
"/#define SND_NOSTOP          0x0010  /* don't stop any currently playing sound */

    "
     self
	playSound:'C:\Dokumente und Einstellungen\cg\work\exept\expecco\resources\sounds\start.wav'
	mode:1
    "

    "Modified: / 06-11-2007 / 00:46:27 / cg"
!

primCloseHandle: handle

    <apicall: ulongReturn "CloseHandle" ( handle ) module: "kernel32.dll" >
!

primDuplicateHandle_hSourcProcessHandle:hSourceProcess
    hSourceHandle:hSourceHandle
    hTargetProcesshandle:hTargetProcessHandle
    lpTargetHandle:lpTargetHandle
    dwDesiredAccess:desiredAccess
    bInheritHandle:bInheritHandle
    dwOptions:dwOptions

    <apicall: bool "DuplicateHandle" ( handle, handle, handle, pointer, dword, bool, dword) module: "kernel32.dll" >
    ^ self primitiveFailed.

    "Created: / 18-09-2007 / 16:31:23 / cg"
!

primGetLastError
    "get the last error code"
%{  /* NOCONTEXT */
    DWORD e = GetLastError();
    RETURN(__MKUINT(e));
%}.

    "/ <apicall: dword "GetLastError" () module: "kernel32.dll" >

    "
	self primGetLastError
    "
!

primSetLastError: i
    "mostly used to clear the last error code"

%{  /* NOCONTEXT */
    if (__isSmallInteger(i)) {
	SetLastError(__intVal(i));
	RETURN(self);
    }
%}.
   "/ <apicall: void "SetLastError" (dword) module: "kernel32.dll" >
    ^ self primitiveFailed.

    "
     self primSetLastError: 0
    "
!

primWritePrivateProfileString:appName keyName:keyName profileString:profString fileName:fnString
%{  /* NOCONTEXT */
    if (__isString(appName)
     && __isString(keyName)
     && __isString(profString)
     && __isString(fnString)) {
	BOOL ret;

	ret = WritePrivateProfileStringA(__stringVal(appName), __stringVal(keyName), __stringVal(profString), __stringVal(fnString));
	RETURN( ret == 0 ? false : true);
    }
%}.

    "/ <apicall: bool "WritePrivateProfileStringA" ( lpstr lpstr lpstr lpstr ) module: "Kernel32.dll" >
    ^ self primitiveFailed

    "Created: / 18-12-2006 / 13:01:41 / User"
!

writePrivateProfileString:appName keyName:keyName profileString:profString fileName:aString

   ^self primWritePrivateProfileString:appName keyName:keyName profileString:profString fileName:aString

"
    |profileStringToWrite recoveredProfileString|
    profileStringToWrite :=  'c:\vsw311'.
    self writePrivateProfileString:'PAV-Editor' keyName:'ExportPath' profileString:profileStringToWrite fileName:'C:\vsw311\dapas.ini'.
    recoveredProfileString := self getProfileString:'PAV-Editor' key:'ExportPath' default:'@@@nil@@@' fileName:'C:\vsw311\dapas.ini' private:true.
    self assert: (profileStringToWrite = recoveredProfileString).
"

    "Modified: / 18-12-2006 / 13:20:20 / User"
! !

!Win32OperatingSystem class methodsFor:'mutex'!

createMutexNamed: name
    "Returns an array with the handle and the lastErrorCode"

    |handle lastErrorCode|

    self primSetLastError:0.
    self primGetLastError.
    handle := self primCreateMutex:nil initialOwner:true name:name.
    lastErrorCode := self primGetLastError.
    "/ lastErrorCode printCR.
    "/    lastErrorCode == 5 "ERROR_ACCESS_DENIED" ifTrue:[Transcript showCR: 'Mutex not accesible (GetLastError = ERROR_ACCESS_DENIED)'.].
    "/    lastErrorCode == 183 "ERROR_ALREADY_EXISTS" ifTrue:[Transcript showCR: 'Mutex already exists (GetLastError = ERROR_ALREADY_EXISTS)'.].
    ^ Array with: handle with: lastErrorCode

    "
     |arr|
     arr := self createMutexNamed: '8906f5e0-54ed-11dd-9da4-001558137da0'.
     self releaseMutex: arr first.

     self releaseMutexNamed: '8906f5e0-54ed-11dd-9da4-001558137da0'
    "

    "Modified: / 03-08-2010 / 16:57:36 / cg"
!

existsMutexNamed: name
    |handle lastErrorCode handleAndLastErrorCode|

    handleAndLastErrorCode := self createMutexNamed:name.
    handle := handleAndLastErrorCode first.
    lastErrorCode := handleAndLastErrorCode second.
    "/  self assert: lastErrorCode == 0.
    ^ handle isNil
	or:[lastErrorCode == 183 "ERROR_ALREADY_EXISTS"
	    or:[ lastErrorCode == 5 "ERROR_ACCESS_DENIED"]]

    "Modified: / 03-08-2010 / 16:59:41 / cg"
!

openMutexNamed: name
    "If the function succeeds, the return value is a handle to the mutex object.
     If the function fails, the return value is NULL. To get extended error information, call GetLastError.
     If a named mutex does not exist, the function fails and GetLastError returns ERROR_FILE_NOT_FOUND."

    |handle |

    handle := self primOpenMutex:nil initialOwner:true name:name.
    "/    lastErrorCode := self primGetLastError.
    "/    lastErrorCode = 2 ifTrue:[Transcript showCR: 'Mutex does not exist (GetLastError = ERROR_FILE_NOT_FOUND)'.].
    "/    lastErrorCode = 5 ifTrue:[Transcript showCR: 'Mutex not accessable (GetLastError = ERROR_ACCESS_DENIED)'.].
    ^ handle

    "
     self openMutexNamed: '8906f5e0-54ed-11dd-9da4-001558137da0'
    "

    "Modified: / 03-08-2010 / 16:59:37 / cg"
!

primCreateMutex:lpSecurityDescriptor initialOwner:bInitialOwner name:lpName
    "If the function succeeds, the return value is a handle to the newly created mutex object.
     If the function fails, the return value is nil.
     If the mutex is a named mutex and the object existed before this function call, the return value is a handle to the existing object."

    |handle|

    handle := Win32MutexHandle new.
%{
    if (__isString(lpName)
     && ((bInitialOwner == true) || (bInitialOwner == false))) {
	void *c_descr = NULL;
	char *c_name;
	HANDLE c_handle;

	c_name = __stringVal(lpName);

	if (lpSecurityDescriptor != nil) {
	    if (__isExternalAddressLike(lpSecurityDescriptor)
	     || __isExternalBytesLike(lpSecurityDescriptor) ) {
		c_descr = __externalAddressVal(lpSecurityDescriptor);
	    } else
		goto badArg;
	}
	c_handle = CreateMutexA(c_descr, bInitialOwner == true, c_name);
	if (c_handle == NULL) {
	    RETURN(nil);
	}
	__externalAddressVal(handle) = c_handle;
	RETURN(handle);
    }
    badArg: ;
%}.
    "/ <apicall: handle "CreateMutexA" (lpstr bool lpstr) module: "kernel32.dll" >
    ^ self primitiveFailed

    "Modified: / 03-08-2010 / 16:59:26 / cg"
!

primOpenMutex:dwDesiredAccess initialOwner:bInitialOwner name:lpName
    "If the function succeeds, the return value is a handle to the mutex object.
     If the function fails, the return value is nil. To get extended error information, call GetLastError.
     If a named mutex does not exist, the function fails and GetLastError returns ERROR_FILE_NOT_FOUND."

    |handle|

    handle := Win32MutexHandle new.
%{
    if (__isString(lpName)
     && ((bInitialOwner == true) || (bInitialOwner == false))) {
	DWORD c_dwDesiredAccess = 0;
	char *c_name;
	BOOL c_initialOwner = (bInitialOwner == true);
	HANDLE c_handle;

	c_name = __stringVal(lpName);

	if (dwDesiredAccess != nil) {
	    if (! __isSmallInteger(dwDesiredAccess)) {
		goto badArg;
	    }
	    c_dwDesiredAccess = __intVal(dwDesiredAccess);
	}
	c_handle = OpenMutexA(c_dwDesiredAccess, c_initialOwner, c_name);
	if (c_handle == NULL) {
	    RETURN(nil);
	}
	__externalAddressVal(handle) = c_handle;
	RETURN(handle);
    }
    badArg: ;
%}.
    "/ <apicall: handle "OpenMutexA" (lpstr bool lpstr) module: "kernel32.dll" >
    ^ self primitiveFailed

    "Modified: / 03-08-2010 / 16:59:11 / cg"
!

primReleaseMutex:hMutex
    "If the function succeeds, the return value is nonzero.
     If the function fails, the return value is zero."
%{
    if (__isExternalAddressLike(hMutex)
     || __isExternalBytesLike(hMutex) ) {
	HANDLE _handle = _HANDLEVal(hMutex);
	BOOL _ret;

	_ret = ReleaseMutex(_handle);
	RETURN(_ret == 0 ? false : true);
    }
%}.
    "/ <apicall: bool "ReleaseMutex" (handle) module: "kernel32.dll" >
    ^ self primitiveFailed

    "Modified: / 03-08-2010 / 16:59:55 / cg"
!

primWaitForSingleObject:handle milliseconds:dwMilliseconds
    "If the function succeeds, the return value indicates the event that caused the function to return.
     If the function fails, the return value is WAIT_FAILED ((DWORD)0xFFFFFFFF)."

%{
    if (__isExternalAddressLike(handle)
     || __isExternalBytesLike(handle) ) {
	HANDLE _handle = _HANDLEVal(handle);

	if (__isSmallInteger(dwMilliseconds)) {
	    DWORD _millis = __intVal(dwMilliseconds);
	    DWORD _ret;

	    _ret = ReleaseMutex(_handle);
	    RETURN( __mkSmallInteger(_ret));
	}
    }
%}.
    "/ <apicall: dword "WaitForSingleObject" (handle dword) module: "kernel32.dll" >
    ^ self primitiveFailed

    "Modified: / 03-08-2010 / 17:00:02 / cg"
!

releaseMutex: hMutex
    "Returns true if the Mutex was released. Otherwise, returns false."

    | released|

    hMutex isNil ifTrue:[
	Transcript showCR: 'hMutex is nil - cannot release'.
	^ false
    ].
    released := self primReleaseMutex: hMutex.
    released ifFalse:[Transcript showCR: 'Release Mutex failed'.].
    ^ released

    "Modified: / 03-08-2010 / 17:00:05 / cg"
!

releaseMutexNamed: name
    "Returns true if the Mutex was released. Otherwise, returns false."

    | hMutex |

    hMutex := self openMutexNamed: name.
    hMutex isNil ifTrue:[
	Transcript showCR: 'Cannot release Mutex named: "', name printString,'"'.
	^ false
    ].
    ^ self releaseMutex: hMutex.

    "Modified: / 03-08-2010 / 16:58:25 / cg"
!

waitForSingleObject: handle
    |result|

    result := self primWaitForSingleObject: handle milliseconds: 500.
    ^ result

    "Modified: / 03-08-2010 / 17:00:10 / cg"
! !

!Win32OperatingSystem class methodsFor:'network resources'!

networkResourceAccessor
    "answer the Win32NetworkResourceHandle or nil if not supported"

    ^ Win32NetworkResourceHandle
! !

!Win32OperatingSystem class methodsFor:'notifications'!

createChangeNotificationHandleFor:aDirectoryPathName flags:changeFlags
    |handle|

    handle := Win32ChangeNotificationHandle new.
%{
    if (__isString(aDirectoryPathName)
     && __isSmallInteger(changeFlags)) {
	char *__dirName = __stringVal(aDirectoryPathName);
	INT __flags = __intVal(changeFlags);
	HANDLE __changeHandle;

	__changeHandle = FindFirstChangeNotification(__dirName, FALSE, __flags);
	if (__changeHandle == INVALID_HANDLE_VALUE) {
	    console_printf("failed to create handle\n");
	} else {
	    __externalAddressVal(handle) = __changeHandle;
	    RETURN (handle);
	}
    }
%}.
    self primitiveFailed

    "
	|h|

	[
	    h := OperatingSystem createChangeNotificationHandleFor:'.'
		flags:(FILE_NOTIFY_CHANGE_FILE_NAME  |
		       FILE_NOTIFY_CHANGE_DIR_NAME |
		       FILE_NOTIFY_CHANGE_ATTRIBUTES |
		       FILE_NOTIFY_CHANGE_SIZE |
		       FILE_NOTIFY_CHANGE_LAST_WRITE).
	    Transcript showCR:'waiting...'.
	    OperatingSystem waitForSingleObject:h withTimeout:1000.
	    Transcript showCR:'got a change...'.
	    h close.
	] fork.
	Delay waitForSeconds:0.25.
	Transcript showCR:'changing...'.
	'./bla' asFilename contents:'hello'.

    "
! !

!Win32OperatingSystem class methodsFor:'os queries'!

executableFileExtensions
    "return a collection of extensions for executable program files.
     Only req'd for msdos like systems ..."

    ^ #('com' 'exe' 'bat' 'cmd')

    "Created: / 02-05-1997 / 11:42:29 / cg"
    "Modified: / 23-08-2011 / 21:14:45 / jv"
!

expandEnvironmentStrings:aString
    "expand the environmentStrings (e.g. %ProgramFiles%) in aString"

    |count resultString resultCount|

    count := aString size + 128.
    [
	aString isWideString ifTrue:[
	    resultString := Unicode16String new:count.
	    resultCount := self primExpandEnvironmentStringsW:aString into:resultString size:count.
	] ifFalse:[
	    resultString := String new:count.
	    resultCount := self primExpandEnvironmentStringsA:aString into:resultString size:count.
	].
	resultCount <= count ifTrue:[
	    true
	] ifFalse:[
	    "resultString was too small. resultCount is the required buffer size"
	    count := resultCount.
	    false
	].
    ] whileFalse.
    ^ resultString copyTo:resultCount-1.


    "
	self expandEnvironmentStrings:'%ProgramFiles%\test\x'
	self expandEnvironmentStrings:'%ProgramFiles%\test\x' asUnicode16String
    "
!

getDomainName
    "return the DNS domain this host is in.
     Notice:
	not all systems support this; on some, 'unknown' is returned."

    |domainName idx hostName k|

    DomainName notNil ifTrue:[
	^ DomainName
    ].

    "/ sometimes, we can extract the domainName from the hostName ...
    hostName := self getHostName.
    hostName notEmptyOrNil ifTrue:[
	idx := hostName indexOf:$..
	idx ~~ 0 ifTrue:[
	    domainName := hostName copyFrom:idx+1.
	]
    ].

    domainName isNil ifTrue:[
	domainName := self getEnvironment:'DOMAIN'.
	domainName isNil ifTrue:[
	    domainName := self getEnvironment:'DOMAINNAME'.
	].

	domainName isNil ifTrue:[
	    "/ ok, search the registry ...
	    "/ under NT and later, it is found there ...
	    k := RegistryEntry key:'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'.
	    k notNil ifTrue:[
		domainName := k valueNamed:'Domain'.
		k close.
	    ].
	].

	domainName isNil ifTrue:[
	    ^ 'unknown'.
	].
	DomainName := domainName.     "cache only, if it is fixed"
    ].
    ^ domainName

    "
     DomainName := nil.
     OperatingSystem getDomainName
     OperatingSystem getHostName
    "

    "Modified: 26.4.1996 / 10:04:54 / stefan"
!

getEnvironment
    "get all environment variables as a dictionary of key-value associations.
     You will find a few strange name-keys starting wth a $=.
     These are leftovers of cmd.com, which are used for keeping track of per-drive current dirs.
     It was reported, that some batch/apps depend on them, so they should probably
     be preserved when forking off new programs.
     Read: 'What are these strange =C: environment variables?'
     (https://blogs.msdn.microsoft.com/oldnewthing/20100506-00/?p=14133/) for more info."

    |strings assocString envDict|

    strings := OrderedCollection new:128.
%{
    LPWSTR lpvEnv;

    lpvEnv = GetEnvironmentStringsW();
    if (lpvEnv != NULL) {
	static struct inlineCache add = _ILC1;
	LPWSTR cp = lpvEnv;

	while (*cp) {
	    assocString = __MKU16STRING(cp);
	    (*add.ilc_func)(strings, @symbol(add:), nil, &add, assocString);
	    cp += wcslen(cp) + 1;
	}
    }
%}.

    envDict := Dictionary new.
    strings do:[:each |
	|idx key value|

	idx := each indexOf:$= startingAt:2.
	self assert:(idx ~~ 0).
	key := each copyTo:idx-1.
	value := each copyFrom:idx+1.
	envDict at:key put:value.
    ].
    ^ envDict

    "
     OperatingSystem getEnvironment
    "

    "Created: / 15-11-2016 / 16:10:12 / cg"
!

getEnvironment:aStringOrSymbol
    "get the whole environment as a dictionary"

%{  /* NOCONTEXT */
#   define ENV_BUFSIZE 2048
    WCHAR _varName[ENV_BUFSIZE];
    WCHAR buff[ENV_BUFSIZE];
    int nNeeded;
    OBJ ret = nil;
    int i, l;

    if (__isStringLike(aStringOrSymbol)) {
	l = __stringSize(aStringOrSymbol);
	if (l > ENV_BUFSIZE-1)
	    goto badArgument;
	for (i=0; i<l; i++) {
	    _varName[i] = __stringVal(aStringOrSymbol)[i];
	}
    } else if (__isUnicode16String(aStringOrSymbol)) {
	l = __unicode16StringSize(aStringOrSymbol);
	if (l > ENV_BUFSIZE-1)
	    goto badArgument;
	for (i=0; i<l; i++) {
	    _varName[i] = __unicode16StringVal(aStringOrSymbol)[i];
	}
    } else {
	goto badArgument;
    }
    _varName[l] = 0;

    nNeeded = GetEnvironmentVariableW(_varName, buff, ENV_BUFSIZE);
    if (nNeeded > sizeof(buff)) {
	WCHAR *buff2;

	buff2 = (char *)malloc(nNeeded * sizeof(WCHAR));
	GetEnvironmentVariableW(_varName, buff2, nNeeded);
	ret = __mkStringOrU16String_maxlen(buff2, nNeeded);
	free(buff2);
    } else if (nNeeded > 0) {
	ret = __mkStringOrU16String_maxlen(buff, nNeeded);
	// console_printf("getenv() -> %"_lx_"\n", (INT)ret);
    }
    RETURN (ret);

badArgument:;
%}.
    ^ nil

    "
     OperatingSystem getEnvironment:'PATH'
    "

    "Modified: / 15-11-2016 / 16:10:27 / cg"
!

getHostName
    "return the hostname we are running on
      - if possible, the fully qualified host name."

    |hostName|

%{  /* STACK: 2048 */
#if defined(__MINGW32__)
    char bufferA[512];
    DWORD buffSize = sizeof(bufferA);
#else
    WCHAR buffer[512];
    DWORD buffSize = sizeof(buffer)/sizeof(buffer[0]);
#endif

    // Note: GetComputerNameExA can fail in certain locales!
#if defined(__MINGW32__)
    if (GetComputerNameA(bufferA, &buffSize) == TRUE) {
	RETURN(__MKSTRING_L(bufferA, buffSize));
    }
#else
    if (GetComputerNameExW(ComputerNameDnsFullyQualified, buffer, &buffSize) == TRUE) {
	RETURN(__mkStringOrU16String_maxlen(buffer, buffSize));
    }
#endif
%}.

    "
     OperatingSystem getHostName
    "
!

getLocaleInfo
    "return a dictionary filled with values from the locale information;
     Not all fields may be present, depending on the OS's setup and capabilities.
     Possible fields are:
	decimalPoint                    <String>
	thousandsSep                    <String>
	internationalCurrencySymbol     <String>
	currencySymbol                  <String>
	monetaryDecimalPoint            <String>
	monetaryThousandsSeparator      <String>
	positiveSign                    <String>
	negativeSign                    <String>
	internationalFractionalDigits   <Integer>
	fractionalDigits                <Integer>
	positiveSignPrecedesCurrencySymbol      <Boolean>
	negativeSignPrecedesCurrencySymbol      <Boolean>
	positiveSignSeparatedBySpaceFromCurrencySymbol  <Boolean>
	negativeSignSeparatedBySpaceFromCurrencySymbol  <Boolean>
	positiveSignPosition                            <Symbol>
							one of: #parenthesesAround,
								#signPrecedes,
								#signSuceeds,
								#signPrecedesCurrencySymbol,
								#signSuceedsCurrencySymbol

	negativeSignPosition                            <like above>

     it is up to the application to deal with undefined values.

     Notice, that (for now), the system does not use this information;
     it should be used by applications as required.
    "

    |info val|

    LocaleInfo notNil ifTrue:[
	"/ return the internal info; useful on systems which do not
	"/ support this.
	^ LocaleInfo
    ].

    info := IdentityDictionary new.
%{
    char *decimalPoint;         /* something like "." (US) or "," (german) */
    char *thousandsSep;         /* something like "," (US) or "." (german) */
    char *intCurrencySymbol;    /* international currency symbol; something like "USD "  "DM  " */
    char *currencySymbol;       /* local currency symbol;         something like "USD "  "DM  " */
    char *monDecimalPoint;      /* money: decimal point */
    char *monThousandsSep;      /* money: thousands sep */
    char *positiveSign;
    char *negativeSign;
    int   intFractDigits;       /* money: international digits after decPoint */
    int   fractDigits;          /* money: local digits after decPoint */
    int   csPosPrecedes;        /* money: 1 if currency symbol precedes a positive value; 0 if it sceeds */
    int   csNegPrecedes;        /* money: 1 if currency symbol precedes a negative value; 0 if it sceeds */
    int   csPosSepBySpace;      /* money: 1 if currency symbol should be separated by a space from a positive value; 0 if no space */
    int   csNegSepBySpace;      /* money: 1 if currency symbol should be separated by a space from a negative value; 0 if no space */
    int   csPosSignPosition;    /* money: 0: ()'s around the value & currency symbol */
    int   csNegSignPosition;    /*        1: sign precedes the value & currency symbol */
				/*        2: sign succeeds the value & currency symbol */
				/*        3: sign immediately precedes the currency symbol */
				/*        4: sign immediately suceeds the currency symbol */

#if defined(HAS_LOCALECONV)
    struct lconv *conf;

    conf = localeconv();
    if (conf) {
	decimalPoint = conf->decimal_point;
	thousandsSep = conf->thousands_sep;
	intCurrencySymbol = conf->int_curr_symbol;
	currencySymbol = conf->currency_symbol;
	monDecimalPoint = conf->mon_decimal_point;
	monThousandsSep = conf->mon_thousands_sep;
	positiveSign = conf->positive_sign;
	negativeSign = conf->negative_sign;
	intFractDigits = conf->int_frac_digits;
	fractDigits = conf->frac_digits;
	csPosPrecedes = conf->p_cs_precedes;
	csNegPrecedes = conf->n_cs_precedes;
	csPosSepBySpace = conf->p_sep_by_space;
	csNegSepBySpace = conf->n_sep_by_space;
	csPosSignPosition = conf->p_sign_posn;
	csNegSignPosition = conf->n_sign_posn;
    }
#else
    decimalPoint = (char *)0;
    thousandsSep = (char *)0;
    intCurrencySymbol = (char *)0;
    currencySymbol = (char *)0;
    monDecimalPoint = (char *)0;
    monThousandsSep = (char *)0;
    positiveSign =  (char *)0;
    negativeSign =(char *)0;
    intFractDigits = -1;
    fractDigits = -1;
    csPosPrecedes = -1;
    csNegPrecedes = -1;
    csPosSepBySpace = -1;
    csNegSepBySpace = -1;
    csPosSignPosition = -1;
    csNegSignPosition = -1;
#endif
    if (decimalPoint) {
	val = __MKSTRING(decimalPoint);
	__AT_PUT_(info, @symbol(decimalPoint), val);
    }
    if (thousandsSep) {
	val = __MKSTRING(thousandsSep);
	__AT_PUT_(info, @symbol(thousandsSeparator), val);
    }
    if (intCurrencySymbol) {
	val = __MKSTRING(intCurrencySymbol);
	__AT_PUT_(info, @symbol(internationCurrencySymbol), val);
    }
    if (currencySymbol) {
	val = __MKSTRING(currencySymbol);
	__AT_PUT_(info, @symbol(currencySymbol), val);
    }
    if (monDecimalPoint) {
	val = __MKSTRING(monDecimalPoint);
	__AT_PUT_(info, @symbol(monetaryDecimalPoint), val);
    }
    if (monThousandsSep) {
	val = __MKSTRING(monThousandsSep);
	__AT_PUT_(info, @symbol(monetaryThousandsSeparator), val);
    }
    if (positiveSign) {
	val = __MKSTRING(positiveSign);
	__AT_PUT_(info, @symbol(positiveSign), val);
    }
    if (negativeSign) {
	val = __MKSTRING(negativeSign);
	__AT_PUT_(info, @symbol(negativeSign), val);
    }
    if (intFractDigits >= 0) {
	__AT_PUT_(info, @symbol(internationalFractionalDigits),  __mkSmallInteger(intFractDigits));
    }
    if (fractDigits >= 0) {
	__AT_PUT_(info, @symbol(fractionalDigits),  __mkSmallInteger(fractDigits));
    }
    if (csPosPrecedes >= 0) {
	if (csPosPrecedes == 0) {
	    val = false;
	} else {
	    val = true;
	}
	__AT_PUT_(info, @symbol(positiveSignPrecedesCurrencySymbol), val );
    }
    if (csNegPrecedes >= 0) {
	if (csNegPrecedes == 0) {
	    val = false;
	} else {
	    val = true;
	}
	__AT_PUT_(info, @symbol(negativeSignPrecedesCurrencySymbol), val );
    }
    if (csPosSepBySpace >= 0) {
	if (csPosSepBySpace == 0) {
	    val = false;
	} else {
	    val = true;
	}
	__AT_PUT_(info, @symbol(positiveSignSeparatedBySpaceFromCurrencySymbol), val);
    }
    if (csNegSepBySpace >= 0) {
	if (csNegSepBySpace == 0) {
	    val = false;
	} else {
	    val = true;
	}
	__AT_PUT_(info, @symbol(negativeSignSeparatedBySpaceFromCurrencySymbol), val);
    }
    switch (csPosSignPosition) {
	case 0:
	    val = @symbol(parenthesesAround);
	    break;

	case 1:
	    val = @symbol(signPrecedes);
	    break;

	case 2:
	    val = @symbol(signSuceeds);
	    break;

	case 3:
	    val = @symbol(signPrecedesCurrencySymbol);
	    break;

	case 4:
	    val = @symbol(signSuceedsCurrencySymbol);
	    break;

	default:
	    val = nil;
    }
    if (val != nil) {
	__AT_PUT_(info, @symbol(positiveSignPosition), val);
    }

    switch (csNegSignPosition) {
	case 0:
	    val = @symbol(parenthesesAround);
	    break;

	case 1:
	    val = @symbol(signPrecedes);
	    break;

	case 2:
	    val = @symbol(signSuceeds);
	    break;

	case 3:
	    val = @symbol(signPrecedesCurrencySymbol);
	    break;

	case 4:
	    val = @symbol(signSuceedsCurrencySymbol);
	    break;

	default:
	    val = nil;
    }
    if (val != nil) {
	__AT_PUT_(info, @symbol(negativeSignPosition), val);
    }
%}.
    ^ info

    "
     OperatingSystem getLocaleInfo
    "

    "Created: 23.12.1995 / 14:19:20 / cg"
!

getNetworkAddresses
    "return a dictionary filled with
	key -> name of interface
	value -> the network adsress (as SocketAddress)
     for each interface
    "

    |info nAdapters rawData entry
     name description macAddress ipAddress ipAddressMask|

    rawData := Array new:100.
%{
/*
 * temporary undef String to avoid a #define-conflict
 * between ST/X's String and Windows String typedef
 */
# undef String
# undef Context

    IP_ADAPTER_INFO AdapterInfo[99];
    DWORD dwBufLen = sizeof(AdapterInfo);
    DWORD dwStatus;

    dwStatus = GetAdaptersInfo(
			    AdapterInfo,                 // [out] buffer to receive data
			    &dwBufLen);                  // [in] size of receive data buffer
    if (dwStatus == ERROR_SUCCESS) {
	PIP_ADAPTER_INFO pAdapterInfo = AdapterInfo;
	unsigned char *bP;
	int nA = 0;

	bP = __byteArrayVal(rawData);
	do {
	    name = __MKSTRING(pAdapterInfo->AdapterName);
	    description = __MKSTRING(pAdapterInfo->Description);
	    macAddress = __MKBYTEARRAY(pAdapterInfo->Address, 6);
	    ipAddress = __MKSTRING(pAdapterInfo->IpAddressList.IpAddress.String);
	    ipAddressMask = __MKSTRING(pAdapterInfo->IpAddressList.IpMask.String);
	    entry = __ARRAY_NEW_INT(5);

/*
 * back to ST/X's String definition
 */
# ifdef __DEF_String
#  define String __DEF_String
# endif
# ifdef __DEF_String
#  define Context __DEF_Context
# endif
	    __ArrayInstPtr(entry)->a_element[0] = name; __STORE(entry, name);
	    __ArrayInstPtr(entry)->a_element[1] = description; __STORE(entry, description);
	    __ArrayInstPtr(entry)->a_element[2] = macAddress; __STORE(entry, macAddress);
	    __ArrayInstPtr(entry)->a_element[3] = ipAddress; __STORE(entry, ipAddress);
	    __ArrayInstPtr(entry)->a_element[4] = ipAddressMask; __STORE(entry, ipAddressMask);

	    __ArrayInstPtr(rawData)->a_element[nA] = entry; __STORE(rawData, entry);
	    nA++;
	    pAdapterInfo = pAdapterInfo->Next;
	} while(pAdapterInfo);
	nAdapters = __mkSmallInteger(nA);
    }
%}.
    "Keep the order as returned by the OS"
    info := OrderedDictionary new:nAdapters ? 0.
    nAdapters notNil ifTrue:[
	1 to:nAdapters do:[:i |
	    |entry name description macAddr ipAddr|

	    entry := rawData at:i.
	    name := entry at:1.
	    "/ description := entry at:2.
	    ipAddr := entry at:4.
	    ipAddr := IPSocketAddress addressString:ipAddr.
	    "take the first name"
	    (ipAddr hostAddress contains:[:b| b ~~ 0]) ifTrue:[
		info at:name ifAbsentPut:ipAddr.
	    ]
	].
    ].
    ^ info

    "
     OperatingSystem getNetworkAddresses
    "
!

getNetworkMACAddresses
    "return a dictionary filled with
	key -> name of interface
	value -> the MAC adress (as ByteArray)
     for each interface
    "

    |info nAdapters rawData entry
     name description macAddress ipAddress ipAddressMask|

    rawData := Array new:100.
%{
/*
 * temporary undef String to avoid a #define-conflict
 * between ST/X's String and Windows String typedef
 */
# undef String
# undef Context

    IP_ADAPTER_INFO AdapterInfo[99];
    DWORD dwBufLen = sizeof(AdapterInfo);
    DWORD dwStatus;

    dwStatus = GetAdaptersInfo(
			    AdapterInfo,                 // [out] buffer to receive data
			    &dwBufLen);                  // [in] size of receive data buffer
    if (dwStatus == ERROR_SUCCESS) {
	PIP_ADAPTER_INFO pAdapterInfo = AdapterInfo;
	unsigned char *bP;
	int nA = 0;

	bP = __byteArrayVal(rawData);
	do {
	    name = __MKSTRING(pAdapterInfo->AdapterName);
	    description = __MKSTRING(pAdapterInfo->Description);
	    macAddress = __MKBYTEARRAY(pAdapterInfo->Address, 6);
	    ipAddress = __MKSTRING(pAdapterInfo->IpAddressList.IpAddress.String);
	    ipAddressMask = __MKSTRING(pAdapterInfo->IpAddressList.IpMask.String);
	    entry = __ARRAY_NEW_INT(5);

/*
 * back to ST/X's String definition
 */
# ifdef __DEF_String
#  define String __DEF_String
# endif
# ifdef __DEF_String
#  define Context __DEF_Context
# endif
	    __ArrayInstPtr(entry)->a_element[0] = name; __STORE(entry, name);
	    __ArrayInstPtr(entry)->a_element[1] = description; __STORE(entry, description);
	    __ArrayInstPtr(entry)->a_element[2] = macAddress; __STORE(entry, macAddress);
	    __ArrayInstPtr(entry)->a_element[3] = ipAddress; __STORE(entry, ipAddress);
	    __ArrayInstPtr(entry)->a_element[4] = ipAddressMask; __STORE(entry, ipAddressMask);

	    __ArrayInstPtr(rawData)->a_element[nA] = entry; __STORE(rawData, entry);
	    nA++;
	    pAdapterInfo = pAdapterInfo->Next;
	} while(pAdapterInfo);
	nAdapters = __mkSmallInteger(nA);
    }
%}.
    "Keep the order as reurned by the OS"
    info := OrderedDictionary new:nAdapters ? 0.
    nAdapters notNil ifTrue:[
	1 to:nAdapters do:[:i |
	    |entry name description macAddr ipAddr|

	    entry := rawData at:i.
	    name := entry at:1.
	    "/ description := entry at:2.
	    macAddr := entry at:3.
	    "/ ipAddr := entry at:4.
	    info at:name put:macAddr.
	].
    ].
    ^ info

    "
     OperatingSystem getNetworkMACAddresses
    "
!

getNumberOfProcessors
    "answer the number of physical processors in the system"

%{
	SYSTEM_INFO sInfo;
	GetSystemInfo(&sInfo);

	return __mkSmallInteger(sInfo.dwNumberOfProcessors);
%}.

    "
	self getNumberOfProcessors
    "
!

getProcessId
    "return the (unix-)processId"

%{  /* NOCONTEXT */

    int pid = 0;

    pid = GetCurrentProcessId() & 0x3FFFFFFF;
    RETURN ( __mkSmallInteger(pid) );
%}.
    "
     OperatingSystem getProcessId
    "
!

getSystemID
    "if supported by the OS, return the systemID;
     a unique per machine identification.
     WARNING:
	not all systems support this; on some, 'unknown' is returned."

    |regKey systemId|

%{  /* NO_CONTEXT */
#if defined(HAS_GETHOSTID)
    int runningId;
    OBJ arr;

    runningId = gethostid();
    arr = __BYTEARRAY_UNINITIALIZED_NEW_INT(4);
    *(int *)(__ByteArrayInstPtr(arr)->ba_element) = runningId;
    RETURN (arr);
#endif
#if defined(HAS_SYSINFO) && defined(SI_HW_SERIAL)
    {
	char buffer[128];

	buffer[0] = 0;
	if (sysinfo(SI_HW_SERIAL, buffer, sizeof(buffer))) {
	    buffer[127] = 0;
	    if (strlen(buffer) > 0) {
		RETURN(__MKSTRING(buffer));
	    }
	}
    }
#endif
%}.

    regKey := self registryEntry
	key:'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion'.

    regKey notNil ifTrue:[
	systemId := regKey valueNamed:'ProductId'.
	systemId isNil ifTrue:[
	    regKey := self registryEntry
		key:'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
		flags:#KEY_WOW64_64KEY createIfAbsent:false.
	    systemId := regKey valueNamed:'ProductId'.
	].
    ].

    ^ systemId ? 'unknown'

    "
     OperatingSystem getSystemID
    "
!

getSystemInfo
    "return info on the system weare running on.
     If the system supports the uname system call, that info is returned;
     otherwise, some simulated info is returned.

     WARNING:
       Do not depend on the amount and contents of the returned information, some
       systems may return more/less than others. Also, the contents depends on the
       OS, for example, linux returns 'ix86', while WIN32 returns 'x86'.

       This method is mainly provided to augment error reports with some system
       information.
       (in case of system/version specific OS errors, conditional workarounds and patches
	may be based upon this info).
       Your application should NOT depend upon this in any way.

     The returned info may (or may not) contain:
	#system -> some operating system identification (irix, Linux, nt, win32s ...)
	#version -> OS version (some os version identification)
	#release -> OS release (3.5, 1.2.1 ...)
	#node   -> some host identification (hostname)
	#domain  -> domain name (hosts domain)
	#machine -> type of machine (i586, mips ...)

     win32:
	#physicalRam -> total amount of physical memory
	#freeRam -> amount of free memory
	#swapSize -> size of swapSpace (page file)
	#freeSwap -> free bytes in swapSpace
	#virtualRam -> total amount of virtual memory
	#freeVirtual -> amount of free virtual memory
	#memoryLoad -> percentage of memory usage (useless)
    "

    |sys node rel ver minorVer majorVer mach dom info arch
     physicalRam freeRam swapSize freeSwap
     virtualRam freeVirtual memoryLoad numberOfCPUs|

%{  /* STACK: 4096 */

    char vsnBuffer[32];
    char *s;
    int winVer, verMinor, verMajor;
    DWORD vsn;
    SYSTEM_INFO sysInfo;
    MEMORYSTATUS memStatus;
    int len;

    vsn = GetVersion();
    winVer = LOWORD(vsn);
    verMinor = HIBYTE(winVer);
    verMajor = LOBYTE(winVer);

    minorVer = __mkSmallInteger(verMinor);
    majorVer = __mkSmallInteger(verMajor);

    if (HIWORD(vsn) & 0x8000) {
	sys = @symbol(win95);
    } else {
	if ((verMajor > 5)
	 || ((verMajor == 5) && (verMinor >= 1))) {
	    sys = @symbol(xp);
	    if (verMajor >= 6) {
		sys = @symbol(vista);
		if (verMinor >= 1) {
		    sys = @symbol(win7);
		    if (verMinor >= 2) {
			sys = @symbol(win8);
		    }
		}
	    }
	} else {
	    sys = @symbol(nt);
	}
    }
    len = snprintf(vsnBuffer, sizeof(vsnBuffer), "%d.%d", verMajor, verMinor);
    rel = __MKSTRING_L(vsnBuffer, len);

    GetSystemInfo(&sysInfo);
    memStatus.dwLength = sizeof(memStatus);
    GlobalMemoryStatus(&memStatus);

    memoryLoad = __MKUINT(memStatus.dwMemoryLoad);
    physicalRam = __MKUINT(memStatus.dwTotalPhys);
    freeRam = __MKUINT(memStatus.dwAvailPhys);
    swapSize = __MKUINT(memStatus.dwTotalPageFile);
    freeSwap = __MKUINT(memStatus.dwAvailPageFile);
    virtualRam = __MKUINT(memStatus.dwTotalVirtual);
    freeVirtual = __MKUINT(memStatus.dwAvailVirtual);

#if defined(__BORLANDC__) && (__BORLANDC__ <= 1339)
    /* BorlandC3 ... */
    switch (sysInfo.u.s.wProcessorArchitecture)
#else
    /* MSC, BorlandC4 ... */
    switch (sysInfo.wProcessorArchitecture)
#endif
    {
#ifdef PROCESSOR_ARCHITECTURE_INTEL
	case PROCESSOR_ARCHITECTURE_INTEL:
	    arch = @symbol(intel);
	    break;
#endif
#ifdef PROCESSOR_ARCHITECTURE_AMD64
	case PROCESSOR_ARCHITECTURE_AMD64:
	    arch = @symbol(x64);
	    break;
#endif
#ifdef PROCESSOR_ARCHITECTURE_MIPS
	case PROCESSOR_ARCHITECTURE_MIPS:
	    arch = @symbol(mips);
	    break;
#endif
#ifdef PROCESSOR_ARCHITECTURE_ALPHA
	case PROCESSOR_ARCHITECTURE_ALPHA:
	    arch = @symbol(alpha);
	    break;
#endif
#ifdef PROCESSOR_ARCHITECTURE_ALPHA64
	case PROCESSOR_ARCHITECTURE_ALPHA64:
	    arch = @symbol(alpha64);
	    break;
#endif
#ifdef PROCESSOR_ARCHITECTURE_PPC
	case PROCESSOR_ARCHITECTURE_PPC:
	    arch = @symbol(ppc);
	    break;
#endif
#ifdef PROCESSOR_ARCHITECTURE_ARM
	case PROCESSOR_ARCHITECTURE_ARM:
	    arch = @symbol(arm);
	    break;
#endif
#ifdef PROCESSOR_ARCHITECTURE_SHX
	case PROCESSOR_ARCHITECTURE_SHX:
	    arch = @symbol(shx);
	    break;
#endif
#ifdef PROCESSOR_ARCHITECTURE_IA64
	case PROCESSOR_ARCHITECTURE_IA64:
	    arch = @symbol(ia64);
	    break;
#endif
#ifdef PROCESSOR_ARCHITECTURE_MSIL
	case PROCESSOR_ARCHITECTURE_MSIL:
	    arch = @symbol(msil);
	    break;
#endif
#ifdef PROCESSOR_ARCHITECTURE_IA32_ON_WIN64
	case PROCESSOR_ARCHITECTURE_IA32_ON_WIN64:
	    arch = @symbol(ia32_on_win64);
	    break;
#endif
	default:
	    arch = @symbol(unknown);
	    break;
    }

    switch (sysInfo.dwProcessorType) {
#ifdef PROCESSOR_INTEL_386
	case PROCESSOR_INTEL_386:
	    mach = @symbol(i386);
	    break;
#endif
#ifdef PROCESSOR_INTEL_486
	case PROCESSOR_INTEL_486:
	    mach = @symbol(i486);
	    break;
#endif
#ifdef PROCESSOR_INTEL_PENTIUM
	case PROCESSOR_INTEL_PENTIUM:
	    mach = @symbol(i586);
	    break;
#endif
#ifdef PROCESSOR_INTEL_860
	case PROCESSOR_INTEL_860:
	    mach = @symbol(i860);
	    break;
#endif
#ifdef PROCESSOR_INTEL_IA64
	case PROCESSOR_INTEL_IA64:
	    mach = @symbol(ia64);
	    break;
#endif
#ifdef PROCESSOR_AMD_X8664
	case PROCESSOR_AMD_X8664:
	    mach = @symbol(x86_64);
	    break;
#endif
#ifdef PROCESSOR_MIPS_R2000
	case PROCESSOR_MIPS_R2000:
	    mach = @symbol(r2000);
	    break;
#endif
#ifdef PROCESSOR_MIPS_R3000
	case PROCESSOR_MIPS_R3000:
	    mach = @symbol(r3000);
	    break;
#endif
#ifdef PROCESSOR_MIPS_R4000
	case PROCESSOR_MIPS_R4000:
	    mach = @symbol(r4000);
	    break;
#endif
#ifdef PROCESSOR_ALPHA_21064
	case PROCESSOR_ALPHA_21064:
	    mach = @symbol(alpha21064);
	    break;
#endif
#ifdef PROCESSOR_ARM720
	case PROCESSOR_ARM720:
	    mach = @symbol(arm720);
	    break;
#endif
#ifdef PROCESSOR_ARM820
	case PROCESSOR_ARM820:
	    mach = @symbol(arm820);
	    break;
#endif
#ifdef PROCESSOR_ARM920
	case PROCESSOR_ARM920:
	    mach = @symbol(arm920);
	    break;
#endif
#ifdef PROCESSOR_ARM_7TDMI
	case PROCESSOR_ARM_7TDMI:
	    mach = @symbol(arm70001);
	    break;
#endif
#ifdef PROCESSOR_STRONGARM
	case PROCESSOR_STRONGARM:
	    mach = @symbol(strongarm);
	    break;
#endif
#ifdef PROCESSOR_PPC_601
	case PROCESSOR_PPC_601:
	    mach = @symbol(ppc601);
	    break;
#endif
#ifdef PROCESSOR_PPC_603
	case PROCESSOR_PPC_603:
	    mach = @symbol(ppc603);
	    break;
#endif
#ifdef PROCESSOR_PPC_604
	case PROCESSOR_PPC_604:
	    mach = @symbol(ppc604);
	    break;
#endif
#ifdef PROCESSOR_PPC_620
	case PROCESSOR_PPC_620:
	    mach = @symbol(ppc620);
	    break;
#endif
#ifdef PROCESSOR_HITACHI_SH3
	case PROCESSOR_HITACHI_SH3:
	    mach = @symbol(sh3);
	    break;
#endif
#ifdef PROCESSOR_HITACHI_SH3E
	case PROCESSOR_HITACHI_SH3E:
	    mach = @symbol(sh3e);
	    break;
#endif
#ifdef PROCESSOR_HITACHI_SH4
	case PROCESSOR_HITACHI_SH4:
	    mach = @symbol(sh4);
	    break;
#endif
#ifdef PROCESSOR_MOTOROLA_821
	case PROCESSOR_MOTOROLA_821:
	    mach = @symbol(mc821);
	    break;
#endif
#ifdef PROCESSOR_SHx_SH3
	case PROCESSOR_SHx_SH3:
	    mach = @symbol(shx_sh3);
	    break;
#endif
#ifdef PROCESSOR_SHx_SH4
	case PROCESSOR_SHx_SH4:
	    mach = @symbol(shx_sh4);
	    break;
#endif

	default:
	    sprintf(vsnBuffer, "%d", sysInfo.dwProcessorType);
	    mach =  __MKSTRING(vsnBuffer);
	    break;
    }

    numberOfCPUs = __MKUINT(sysInfo.dwNumberOfProcessors);
%}.
    node isNil ifTrue:[
	node := self getHostName.
    ].
    dom isNil ifTrue:[
	dom := self getDomainName.
    ].

    info := IdentityDictionary new.
    info at:#system put:sys.
    info at:#node put:node.
    rel notNil ifTrue:[info at:#release put:rel].
    ver notNil ifTrue:[info at:#version put:ver].
    majorVer notNil ifTrue:[info at:#majorVersion put:majorVer].
    minorVer notNil ifTrue:[info at:#minorVersion put:minorVer].
    mach notNil ifTrue:[info at:#machine put:mach. info at:#cpuType put:mach].
    arch notNil ifTrue:[info at:#architecture put:arch].
    dom notNil ifTrue:[info at:#domain put:dom].
    numberOfCPUs notNil ifTrue:[info at:#numberOfCPUs put:numberOfCPUs].

    info at:#memoryLoad put:memoryLoad.
    info at:#physicalRam put:physicalRam.
    info at:#freeRam put:freeRam.
    info at:#swapSize put:swapSize.
    info at:#freeSwap put:freeSwap.
    info at:#virtualRam put:virtualRam.
    info at:#freeVirtual put:freeVirtual.

    info at:#osType put:(self getOSType).
    ^ info

    "
     OperatingSystem getSystemInfo
    "
!

getSystemType
    "return a string giving the type of system we're running on.
     This is almost the same as getOSType, but the returned string
     is slightly different for some systems (i.e. iris vs. irix).
     Dont depend on this - use getOSType. I dont really see a point
     here ...
     (except for slight differences between next/mach and other machs)"

    ^ #win32

    "
     OperatingSystem getSystemType
    "
!

getThreadId
    "return the (windows-) threadId"

%{  /* NOCONTEXT */

    int pid = 0;

    pid = GetCurrentThreadId() & 0x3FFFFFFF;
    RETURN ( __mkSmallInteger(pid) );
%}.
    "
     OperatingSystem getThreadId
    "
!

getWindowsDirectory
    "internal interface - only for Windows based systems.
     Return the windows directory
     (which - depending on the system - may be \WINNT, \WINDOWS or whatever)
     On non-windows systems, nil is returned."

%{
    wchar_t buffer[MAXPATHLEN+1];

    if (GetWindowsDirectoryW(buffer, MAXPATHLEN)) {
	RETURN (__mkStringOrU16String_maxlen(buffer, MAXPATHLEN));
    }
%}.
    ^ nil

    "
     OperatingSystem getWindowsDirectory
    "
!

getWindowsSystemDirectory
    "internal interface - only for Windows based systems.
     Return the windows system directory
     (which - depending on the system - may be \WINNT\SYSTEM32,
      \WINDOWS\SYSTEM or whatever)
     On non-windows systems, nil is returned."

%{
    wchar_t buffer[MAXPATHLEN+1];

    if (GetSystemDirectoryW(buffer, MAXPATHLEN)) {
	RETURN (__mkStringOrU16String_maxlen(buffer, MAXPATHLEN));
    }
%}.
    ^ nil

    "
     OperatingSystem getWindowsSystemDirectory
    "
!

hasConsole
    "return true, if there is some kind of console available
     (i.e. for proper stdIn, stdOut and stdErr handling).
     This only returns false when running únder windows, and
     the system is running as a pure windows application.
     If false, the miniDebugger is useless and not used."

%{  /* NOCONTEXT */
    extern int __getNoConsoleFlag();

    RETURN ( __getNoConsoleFlag() ? false : true);
%}
!

isMSDOSlike
    "return true, if the OS we're running on is msdos like
     (in contrast to unix-like or vms-like).
     This returns true for any of msdos, win32s, win95,
     winNT, winXP, Vista, Win7, win8 and os/2."

    ^ true

    "Modified (comment): / 27-10-2012 / 14:00:52 / cg"
!

isMSWINDOWSNTlike
    "This returns true if running in a Windows-NT system."

     ^ true.
!

isMSWINDOWSlike
    "return true, if running on a MS-Windows like system.
     This returns true for any of win32s, win95, winNT, XP, Vista, Win7, Win8 etc."

    ^ true

    "Modified (comment): / 27-10-2012 / 14:01:30 / cg"
!

isProcessIdPresent:processHandleOrPid
    "answer true, if a process with process id pid (or handle) is present, false if not.
     Raise an error, if an exception occures"

    |error|

%{
    HANDLE processHandle, processHandleToClose = 0;
    int err;
    DWORD exitCode;

    if (__isExternalAddressLike(processHandleOrPid) ) {
	processHandle = _HANDLEVal(processHandleOrPid);
	if (processHandle == 0) {
	    RETURN(false);
	    // error = @symbol(invalidParameter);
	    // goto out;
	}
    } else if( __isSmallInteger(processHandleOrPid) ) {
	// assume, that synchronize needs less privilege...
	processHandle = processHandleToClose = OpenProcess(SYNCHRONIZE, FALSE, __smallIntegerVal(processHandleOrPid));
	if (!processHandle) {
	    goto checkError;
	}
    } else {
	error = @symbol(invalidParameter);
	goto out;
    }

    /* check if the handle still refers to a running process */
    if (GetExitCodeProcess(processHandle, &exitCode) != 0) {
	if (processHandleToClose != 0)
	    CloseHandle(processHandleToClose);
	if (exitCode == STILL_ACTIVE) {
	    RETURN(true);
	} else {
	    RETURN(false);
	}
    } else if (processHandleToClose != 0) {
	CloseHandle(processHandleToClose);
    }

checkError:
    err = GetLastError();
    // we do not have access to the process (so pid does exist ;-))
    if (err == ERROR_ACCESS_DENIED) {
	RETURN(true);
    }
    // pid does not exist
    if (err == ERROR_INVALID_PARAMETER) {
	RETURN(false);
    }

    // any other error - raise signal
    __threadErrno = __WIN32_ERR(err);
    error = __mkSmallInteger(__threadErrno);
out:;
%}.

    self primitiveFailed:error.

    "
      self isProcessIdPresent:(self getProcessId)
      self isProcessIdPresent:10196
      self isProcessIdPresent:512
      self isProcessIdPresent:'abc'
    "
!

isVistaLike
    "return true, if running on a Vista (or newer) like system.
     (also true for server 2008)"

    ^ (self getSystemInfo at:#majorVersion) >= 6

    "
     self isVistaLike
    "

    "Modified (comment): / 27-10-2012 / 13:59:53 / cg"
!

isWin10Like
    "return true, if running on a Windows10 (or newer) like system.
     (also true for server 2016)"

    |sysInfo major|

    sysInfo := self getSystemInfo.
    major := sysInfo at:#majorVersion.

    ^ (major >= 10)

    "
     self isWin10Like
    "
!

isWin7Like
    "return true, if running on a Windows7 (or newer) like system."

    |sysInfo major|

    sysInfo := self getSystemInfo.
    major := sysInfo at:#majorVersion.

    ^ (major == 6 and:[(sysInfo at:#minorVersion) >= 1])
      or:[major > 6]

    "
     self isWin7Like
    "

    "Modified (comment): / 27-10-2012 / 13:59:14 / cg"
!

isWin8Like
    "return true, if running on a Windows8 (or newer) like system.
     (also true for server 2012)"

    |sysInfo major|

    sysInfo := self getSystemInfo.
    major := sysInfo at:#majorVersion.

    ^ (major == 6 and:[(sysInfo at:#minorVersion) >= 2])
      or:[major > 6]

    "
     self isWin8Like
    "

    "Created: / 27-10-2012 / 13:59:03 / cg"
!

maxFileNameLength
    "return the max number of characters in a filename.
     CAVEAT:
	 Actually, the following is somewhat wrong - some systems
	 support different sizes, depending on the volume.
	 We return a somewhat conservative number here.
	 Another entry, to query for volume specific max
	 will be added in the future."

%{  /* NOCONTEXT */

    /*
     * TODO: newer systems provide a query function for this ... use it
     */
     /*
      * mhmh - depends on the filesystem type
      */
     RETURN ( __mkSmallInteger(MAXFILELEN) );
%}
    "
     OperatingSystem maxFileNameLength
    "
!

maxPathLength
    "return the max number of characters in a pathName."

%{  /* NOCONTEXT */
    RETURN ( __mkSmallInteger(MAXPATHLEN) );
%}
    "
     OperatingSystem maxPathLength
    "
!

osName
    |osVersion|

    osVersion := OperatingSystem osVersion.
    ^ 'Windows ',
	(#('2000' 'XP' 'Server2003' 'VISTA' '7' '8' '8.1' '10')
	    at: (#('5.0' '5.1' '5.2' '6.0' '6.1' '6.2' '6.3' '10.0') indexOf:osVersion)
	    ifAbsent:osVersion).

    "
     self osName
    "

    "Modified (comment): / 30-07-2011 / 17:00:50 / cg"
!

osVersion

    ^OperatingSystem getSystemInfo at:#release

    "Created: / 19-01-2007 / 13:15:47 / User"
!

pathSeparator
    "return the character which separates items in the PATH variable"

    ^ $;

    "Created: 2.5.1997 / 11:36:47 / cg"
!

platformName
    "return a string describing the OS platform very we're running on.
     This returns #unix for all unix derivatives,
     #os2, #win32, #vms or #mac for the others.
     I.e. it is much less specific than getOSType or getSystemType."

    ^ #win32

    "
     OperatingSystem platformName
    "

    "Modified: 20.6.1997 / 17:37:26 / cg"
!

randomBytesInto:bufferOrInteger
    "If bufferOrInteger is a String or a ByteArray,
	fill a given buffer with random bytes from the RtlGenRandom function
	and nswer the buffer.

     If bufferOrInteger is a SmallInteger,
	return this many bytes (max 4) as a SmallInteger.

     Return nil on error (and raise PrimitiveFailure).

     NOTE: This is a private interface, please use RandomGenerator!!"

%{
//    BOOLEAN RtlGenRandom(
//      __out  PVOID RandomBuffer,
//      __in   ULONG RandomBufferLength
//    );
    static BOOL (__stdcall *P_RtlGenRandom)(PVOID , ULONG) = 0;
    unsigned char *__buffer;
    int __bufferSize;
    int __useLocalBuffer = 0;
    unsigned int __localBuffer = 0;

    if (__isSmallInteger(bufferOrInteger)) {
	__useLocalBuffer = 1;
	__buffer = (unsigned char *)&__localBuffer;
	__bufferSize = __smallIntegerVal(bufferOrInteger);
	if (__bufferSize > sizeof(INT))
	    __bufferSize = sizeof(INT);
    } else if (__isString(bufferOrInteger)) {
	__buffer = __stringVal(bufferOrInteger);
	__bufferSize = __stringSize(bufferOrInteger);
    } else if (__isByteArray(bufferOrInteger)) {
	__buffer = __byteArrayVal(bufferOrInteger);
	__bufferSize = __byteArraySize(bufferOrInteger);
    } else {
	goto error;
    }

    if (P_RtlGenRandom == 0) {
	HINSTANCE hAdvapi32 = LoadLibrary("advapi32.dll");
	// console_printf("hAdvapi32: %x\n", hAdvapi32);
	if (hAdvapi32) {
	    P_RtlGenRandom = (BOOL (__stdcall *)(PVOID , ULONG))
				GetProcAddress(hAdvapi32, "SystemFunction036");
	    // console_printf("P_RtlGenRandom: %x\n", P_RtlGenRandom);
	    if (P_RtlGenRandom == 0) {
		goto error;
	    }
	}
    }
    if ((*P_RtlGenRandom)(__buffer, __bufferSize)) {
	if (__useLocalBuffer) {
	    RETURN(__mkSmallInteger(__localBuffer & _MAX_INT));
	}
	RETURN (bufferOrInteger);
    }
error: ;
%}.
    self primitiveFailed.
    ^ nil

    "
     self randomBytesInto:(ByteArray new:4)
     self randomBytesInto:4
     self randomBytesInto:1
    "
!

setEnvironment:aStringOrSymbol to:newValueString
    "set an environment variable"

%{  /* NOCONTEXT */
    char *env;

    if (__isStringLike(aStringOrSymbol)
     && __isStringLike(newValueString) ) {
	if (SetEnvironmentVariable(__stringVal(aStringOrSymbol), __stringVal(newValueString)) != 0) {
	    RETURN(self);
	}
    }
%}.
    self primitiveFailed

    "
     OperatingSystem getEnvironment:'PATH'
     OperatingSystem setEnvironment:'PATH' to:('c:\cygwin\bin;' , (OperatingSystem getEnvironment:'PATH'))
    "
!

setLocaleInfo:anInfoDictionary
    "set the locale information; if set, this oerrides the OS's settings.
     (internal in ST/X only - the OS's settings remain unaffected)
     See description of fields in #getLocaleInfo.

     Notice, that (for now), the system does not use this information;
     it should be used by applications as required."

    LocaleInfo := anInfoDictionary

    "
     |d|

     d := IdentityDictionary new.
     d at:#decimalPoint                 put:'.'         .
     d at:#thousandsSeparator           put:','         .
     d at:#currencySymbol               put:'USD'       .
     d at:#monetaryDecimalPoint         put:'.'         .
     d at:#monetaryThousandsSeparator   put:'.'         .
     d at:#fractionalDigits             put:2           .
     d at:#positiveSign                 put:'+'         .
     d at:#negativeSign                 put:'-'         .
     d at:#positiveSignPrecedesCurrencySymbol put:true          .
     d at:#negativeSignPrecedesCurrencySymbol put:false         .
     OperatingSystem setLocaleInfo:d
    "
!

supportsChildInterrupts
    "return true, if the OS supports childProcess termination signalling
     through interrupts (i.e. SIGCHILD)"

%{  /* NOCONTEXT */
#if defined(SIGCHLD) || defined(SIGCLD)
    RETURN (true);
#endif
%}.
    ^ false

    "
     OperatingSystem supportsChildInterrupts
    "
!

supportsFileOwnerGroups
    "return true, if the OS's file system supports file
     group ownership - all OS's except windows do"

    ^ false

    "Created: / 10.9.1998 / 17:57:03 / cg"
!

supportsFileOwners
    "return true, if the OS's file system supports file
     ownership - all OS's except windows do"

    ^ false

    "Created: / 10.9.1998 / 17:55:16 / cg"
    "Modified: / 10.9.1998 / 17:57:11 / cg"
!

supportsIOInterrupts
    "return true, if the OS supports IO availability interrupts
     (i.e. SIGPOLL/SIGIO).

     Currently, this mechanism does not work on all
     systems ...
    "

    ^ false

    "
     OperatingSystem supportsIOInterrupts
    "
!

supportsNonBlockingIO
    "return true, if the OS supports nonblocking IO."

    ^ false

    "
     OperatingSystem supportsNonBlockingIO
    "
!

supportsSelect
    "return true, if the OS supports selecting on multiple
     filedescriptors via select.
     If false is returned, ProcessorScheduler will poll in 50ms
     intervals for I/O becoming ready."

%{  /* NOCONTEXT */

# if defined(WIN32S)
    RETURN (false);
# endif
%}.
    ^ true

    "
     OperatingSystem supportsSelect
    "
!

supportsSelectOnPipes
    "return true, if the OS supports selecting on pipe
     filedescriptors via select.
     If false is returned, ProcessorScheduler will poll in 50ms
     intervals for I/O becoming ready."

    ^ false

    "
     OperatingSystem supportsSelectOnPipes
    "

    "Modified: / 14.12.1999 / 19:41:03 / cg"
    "Created: / 14.12.1999 / 19:43:13 / cg"
!

supportsSelectOnSockets
    "return true, if the OS supports selecting on socket
     filedescriptors via select.
     If false is returned, ProcessorScheduler will poll in 50ms
     intervals for I/O becoming ready."

    ^ false

    "
     OperatingSystem supportsSelectOnSockets
    "

    "Modified: / 14.12.1999 / 19:41:03 / cg"
!

supportsVolumes
    "return true, if the OS supports disk volumes.
     False is returned for UNIX, true for MSDOS and VMS"

    ^ true
! !

!Win32OperatingSystem class methodsFor:'path queries'!

defaultPackagePath
    |packagePath key value |

    packagePath := super defaultPackagePath.

    "/ For backward compatibility, also add package path specified
    "/ in registry. DO NOT USE, this will wanish.
    key := RegistryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\eXept\Smalltalk/X\' , Smalltalk versionString.
    key notNil ifTrue:[
        value := key valueNamed:'PackageDirPath'.
    ].
    value notNil ifTrue:[
        | directories |

        directories := value asCollectionOfSubstringsSeparatedBy:self pathSeparator.
        directories reverseDo:[:each|
            (packagePath includes:each) ifFalse:[
                packagePath addFirst:each.
            ].
        ].  
    ].
    ^ packagePath

    "
     self defaultPackagePath
    "

    "Created: / 24-12-1999 / 00:10:41 / cg"
    "Modified (comment): / 04-07-2016 / 23:35:06 / jv"
!

defaultSystemPath
    |sysPath libDirPath|

    sysPath := super defaultSystemPath.

    libDirPath := self stxLibDirPath.
    libDirPath notNil ifTrue:[
	"/ and also add the libDirPath from the registry ...
	(sysPath includes:libDirPath) ifFalse:[
	    sysPath add:libDirPath
	].
    ].
"/    #(
"/        '\programs\eXept\smalltalk'
"/        '\programme\eXept\smalltalk'
"/        '\programs\smalltalk'
"/        '\programme\smalltalk'
"/        '\smalltalk'
"/    ) do:[:dir |
"/        |vsnDir|
"/
"/        (dir asFilename isDirectory) ifTrue:[
"/            vsnDir := dir , '\' , Smalltalk versionString.
"/            (vsnDir asFilename isDirectory) ifTrue:[
"/                (sysPath includes:vsnDir) ifFalse:[
"/                    sysPath add:vsnDir.
"/                ]
"/            ].
"/            (sysPath includes:dir) ifFalse:[
"/                sysPath add:dir.
"/            ].
"/        ]
"/    ].

    ^ sysPath

    "Modified: / 24.12.1999 / 00:29:18 / cg"
!

stxBinDirPath
    "ask the registry for the binary directory"

    |k p|

    k := RegistryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\eXept\Smalltalk/X\' , Smalltalk versionString.
    k notNil ifTrue:[
	p := k valueNamed:'BinDir'.
    ].
    ^ p

    "
     OperatingSystem stxBinDirPath
    "
!

stxLibDirPath
    "ask the registry for the lib directory"

    (Array
	with:('HKEY_LOCAL_MACHINE\SOFTWARE\eXept\Smalltalk/X\' , Smalltalk versionString)
	with:('HKEY_LOCAL_MACHINE\SOFTWARE\eXept\Smalltalk/X'))
    do:[:eachKeyToTry |
	|k p|

	k := RegistryEntry key:eachKeyToTry.
	k notNil ifTrue:[
	    p := k valueNamed:'LibDir'.
	    k closeKey.
	    ^ p
	].
    ].
    ^ nil

    "
     OperatingSystem stxLibDirPath
    "
! !

!Win32OperatingSystem class methodsFor:'printing support'!

abortDoc: deviceContext
    ^ self primAbortDoc:deviceContext

    "Created: / 02-08-2006 / 12:52:12 / fm"
    "Modified: / 04-10-2006 / 11:34:37 / cg"
!

closePrinter:handle
    self primClosePrinter:handle

    "Created: / 28-07-2006 / 17:55:59 / fm"
    "Modified: / 04-10-2006 / 11:34:34 / cg"
!

createPrinterDC:driverName device:deviceName output:outputMedium initData:driverData
    |h|

    h := self primCreatePrinterDC:driverName device:deviceName output:outputMedium initData:driverData.
"/    h notNil ifTrue:[
"/        ^ (Win32Handle newAddress:h address) registerForFinalization
"/    ].
    ^ h

    "
     |p hPrinter driverNm mediumNm deviceNm driverData hDC|

     p := self getPrinters first.
     driverNm := p attributes at:#driverName.
     mediumNm := p attributes at:#medium.
     deviceNm := p printerName.

     hPrinter := self openPrinter:deviceNm.
     driverData := self getDocumentProperties:nil hPrinter:hPrinter pDeviceName:deviceNm.
     self primClosePrinter:hPrinter.

     hDC := self createPrinterDC:driverNm device:deviceNm output:mediumNm initData:driverData.
    "

    "Created: / 27-07-2006 / 16:22:34 / fm"
    "Modified: / 16-04-2007 / 13:09:16 / cg"
!

deletePrinterDC: hwndArg
    |return|
    return := self primDeletePrinterDC:hwndArg .
    ^return

    "Created: / 27-07-2006 / 16:22:34 / fm"
!

documentPropertiesDialogFor:hwndOrNil hPrinter:hPrinter pDeviceName:deviceName devModeInput:pDevModeInputOrNil
    |nBytesNeeded hPrinter rslt devModeOutput|

"
#define DM_UPDATE           1
#define DM_COPY             2
#define DM_PROMPT           4
#define DM_MODIFY           8

#define DM_IN_BUFFER        DM_MODIFY
#define DM_IN_PROMPT        DM_PROMPT
#define DM_OUT_BUFFER       DM_COPY
#define DM_OUT_DEFAULT      DM_UPDATE
"
    nBytesNeeded := self
	   primDocumentProperties:nil
	   hPrinter:hPrinter
	   pDeviceName: deviceName
	   pDevModeOutput:nil
	   pDevModeInput:nil
	   fMode:0.

    devModeOutput := DevModeStructure new:(nBytesNeeded * 2 "never trust MS !!").

    rslt := self
	   primDocumentProperties:nil
	   hPrinter:hPrinter
	   pDeviceName: deviceName
	   pDevModeOutput:devModeOutput
	   pDevModeInput:pDevModeInputOrNil
	   fMode:4+2.

    ^ devModeOutput

    "
     |h|

     h := self openPrinter:'\\http://exept.exept.de:631\lj4'.
     self documentPropertiesDialogFor:nil hPrinter:h pDeviceName:'\\http://exept.exept.de:631\lj4' devModeInput:nil
    "

    "Created: / 27-07-2006 / 15:39:21 / fm"
!

endDoc: deviceContext
    ^ self primEndDoc:deviceContext

    "Created: / 27-07-2006 / 19:46:19 / fm"
    "Modified: / 28-07-2006 / 19:23:03 / fm"
    "Modified: / 04-10-2006 / 11:35:01 / cg"
!

endPage: deviceContext
    ^ self primEndPage:deviceContext

    "Created: / 27-07-2006 / 19:45:28 / fm"
    "Modified: / 28-07-2006 / 18:49:40 / fm"
    "Modified: / 04-10-2006 / 11:35:06 / cg"
!

getDefaultPrinterName
    "returns the default printer name"

    ^ (self getProfileString:'windows' key:'device' default:'')

    "
     OperatingSystem getDefaultPrinterName
    "

    "Created: / 02-08-2006 / 17:25:34 / fm"
    "Modified: / 04-10-2006 / 11:35:18 / cg"
!

getDeviceCaps:hwndArg index: index
    ^ self primGetDeviceCaps:hwndArg index: index

    "Created: / 28-07-2006 / 17:45:27 / fm"
    "Modified: / 04-10-2006 / 11:35:29 / cg"
!

getDocumentProperties:hwndOrNil hPrinter:hPrinter pDeviceName:deviceName
    |nBytesNeeded rslt devModeOutput|

"
#define DM_UPDATE           1
#define DM_COPY             2
#define DM_PROMPT           4
#define DM_MODIFY           8

#define DM_IN_BUFFER        DM_MODIFY
#define DM_IN_PROMPT        DM_PROMPT
#define DM_OUT_BUFFER       DM_COPY
#define DM_OUT_DEFAULT      DM_UPDATE
"
    nBytesNeeded := self
	   primDocumentProperties:nil
	   hPrinter:hPrinter
	   pDeviceName: deviceName
	   pDevModeOutput:nil
	   pDevModeInput:nil
	   fMode:0.

    nBytesNeeded < 0 ifTrue:[^nil].
    devModeOutput := DevModeStructure new:(nBytesNeeded * 2 "never trust MS !!").

    rslt := self
	   primDocumentProperties:nil
	   hPrinter:hPrinter
	   pDeviceName: deviceName
	   pDevModeOutput:devModeOutput
	   pDevModeInput:nil
	   fMode:2.

     ^ devModeOutput

    "
     |h|

     h := self openPrinter:'\\http://exept.exept.de:631\lj4'.
     self getDocumentProperties:nil hPrinter:h pDeviceName:'\\http://exept.exept.de:631\lj4'
    "

    "Created: / 27-07-2006 / 15:38:03 / fm"
    "Modified: / 31-07-2006 / 13:02:02 / fm"
    "Modified: / 04-10-2006 / 11:35:39 / cg"
!

getPrinterInfo2: printerName
    |hPrinter rslt informationBuffer bytesNeeded sizeBytesArray|

     hPrinter := self openPrinter: printerName .
     sizeBytesArray := ByteArray new:4.

     bytesNeeded := self
		primGetPrinter:hPrinter
		level:2
		informationBuffer: nil
		bufferSize: 0
		bufferNeededSize:sizeBytesArray.
     bytesNeeded := sizeBytesArray longAt:1.
     informationBuffer := PrinterInfo2Structure new: bytesNeeded.
     rslt := self
		primGetPrinter:hPrinter
		level:2
		informationBuffer:informationBuffer
		bufferSize: bytesNeeded
		bufferNeededSize:sizeBytesArray.
     self closePrinter: printerName.
     ^informationBuffer

    "
     OperatingSystem getPrinterInfo2:(OperatingSystem getDefaultPrinterName)
    "

    "Created: / 01-08-2006 / 13:47:19 / fm"
    "Modified: / 04-10-2006 / 11:36:41 / cg"
!

getPrinters
    "return a collection of PrinterInfos"

    |printerNames collectedInfo|

    printerNames := self getPrintersNames.
    collectedInfo := OrderedCollection new.
    printerNames do:[:eachName |
	|fn vol attributes nm deviceInfo infoFields driverName|

	attributes := Dictionary new.

	fn := eachName asFilename.
	vol := fn volume.
	vol notEmptyOrNil ifTrue:[
	    (vol startsWith:'\\') ifTrue:[
		"/ a remote printer
		attributes at:#isRemotePrinter put:true.
		attributes at:#remotePrinterName put:(fn baseName).
		attributes at:#remotePrinterHost put:(fn directoryName copyFrom:3).
	    ] ifFalse:[
		"/ some other printer
	    ].
	] ifFalse:[
	    "/ some other printer
	].

	deviceInfo := self getProfileString:'PrinterPorts' key:eachName default:''.
	"gives us smething like 'winspool,Ne00:,15,45',
	 which is: driverName, deviceName, ? , ?"

	infoFields := deviceInfo asCollectionOfSubstringsSeparatedBy:$,.
	driverName := infoFields at:1.
	2 to: infoFields size by:3 do:[:i |
	    |medium longName|

	    medium := infoFields at:i.
	    longName := eachName ,',' , driverName , ',' , medium.
	    attributes at:#driverName put:driverName.
	    attributes at:#longName put:longName.
	    attributes at:#medium put:medium.

	    collectedInfo add:
		(AbstractOperatingSystem::PrinterInfo new
		    printerName:eachName
		    attributes:attributes;
		    setDocumentProperties;
		    yourself)
	].
    ].
    ^ collectedInfo

    "
     OperatingSystem getPrinters
    "

    "Created: / 27-07-2006 / 12:18:11 / fm"
    "Modified: / 31-07-2006 / 13:06:04 / fm"
!

getPrintersNames
    "return a collection of Printer names"

    |printerNames|

    printerNames := (self getProfileString:'PrinterPorts' key:nil default:'')
		       asCollectionOfSubstringsSeparatedBy:(Character value:0).
    printerNames := printerNames reject:[:nm | nm isEmpty].
    ^printerNames

    "
     OperatingSystem getPrintersNames
    "

    "Created: / 27-07-2006 / 17:55:46 / fm"
    "Modified: / 04-10-2006 / 11:37:41 / cg"
!

getTextExtentPoint: handle string: lpString size: pSize

   ^self primGetTextExtentPoint: handle string: lpString count: lpString size size: pSize

    "Created: / 03-08-2006 / 11:17:17 / fm"
!

getTextMetrics: deviceContext lpMetrics: textMetrics

    ^self primGetTextMetrics: deviceContext lpMetrics: textMetrics

    "Created: / 02-08-2006 / 16:07:07 / fm"
    "Modified: / 04-10-2006 / 11:37:49 / cg"
!

openPrinter:name
    |h hh rslt|

    hh := ByteArray new:(ExternalAddress pointerSize).
    rslt := self primOpenPrinter:name handleHolder:hh ignored:nil.
    rslt ifFalse:[^ nil].

    h := Win32PrinterHandle new setAddressFromBytes:hh.
    h registerForFinalization.
    ^ h

    "
     self openPrinter:'\\http://exept.exept.de:631\lj4'
    "

    "Created: / 27-07-2006 / 14:40:41 / fm"
!

primAbortDoc:hwndArg
    <apicall: int32 "AbortDoc" (handle) module: "gdi32.dll" >
    self primitiveFailed.

    "Created: / 02-08-2006 / 12:52:32 / fm"
!

primClosePrinter:handle
    <apicall: bool "ClosePrinter" ( handle ) module: "winspool.drv" >
    self primitiveFailed.

    "
     |h hh rslt|

     hh := ByteArray new:4.
     rslt := self primOpenPrinter:'\\http://exept.exept.de:631\lj4' handleHolder:hh ignored: nil.
     h := Win32PrinterHandle new setAddressFromBytes:hh.
     self primClosePrinter: h.
    "

    "Created: / 27-07-2006 / 14:47:12 / fm"
!

primCreatePrinterDC:driverName device:deviceName output:outputMedium initData:driverData
    <apicall: handle "CreateDCA" ( pointer pointer pointer pointer ) module: "gdi32.dll" >
    self primitiveFailed.

    "Modified: / 27-07-2006 / 16:26:25 / fm"
!

primDeletePrinterDC: hwndArg
    <apicall: bool "DeleteDC" ( handle ) module: "gdi32.dll" >
    self primitiveFailed.
!

primDocumentProperties:hwndOrNil hPrinter:hPrinter pDeviceName:deviceName pDevModeOutput:pDevModeOutput pDevModeInput:pDevModeInput fMode:fMode
    <apicall: int32 "DocumentPropertiesA" ( handle handle lpstr pointer pointer uint32) module: "winspool.drv" >
    self primitiveFailed.

    "
     |hPrinter rslt|

     hPrinter := self openPrinter:'\\http://exept.exept.de:631\lj4' .
     rslt := self
	    primDocumentProperties:nil
	    hPrinter:hPrinter
	    pDeviceName: '\\http://exept.exept.de:631\lj4'
	    pDevModeOutput:nil
	    pDevModeInput:nil
	    fMode:0.

     self halt.
    "

    "Created: / 27-07-2006 / 15:02:14 / fm"
!

primEndDoc:hwndArg
    <apicall: int32 "EndDoc" (handle) module: "gdi32.dll" >
    self primitiveFailed.

    "
     |hPrinter rslt|

     hPrinter := self openPrinter:'\\http://exept.exept.de:631\lj4' .
     rslt := self
	    primDocumentProperties:nil
	    hPrinter:hPrinter
	    pDeviceName: '\\http://exept.exept.de:631\lj4'
	    pDevModeOutput:nil
	    pDevModeInput:nil
	    fMode:0.

     self halt.
    "

    "Created: / 27-07-2006 / 19:31:31 / fm"
!

primEndPage:hwndArg
    <apicall: int32 "EndPage" (handle) module: "gdi32.dll" >
    self primitiveFailed.

    "
     |hPrinter rslt|

     hPrinter := self openPrinter:'\\http://exept.exept.de:631\lj4' .
     rslt := self
	    primDocumentProperties:nil
	    hPrinter:hPrinter
	    pDeviceName: '\\http://exept.exept.de:631\lj4'
	    pDevModeOutput:nil
	    pDevModeInput:nil
	    fMode:0.

     self halt.
    "

    "Created: / 27-07-2006 / 19:30:50 / fm"
!

primGetDeviceCaps:hwndArg index: index
    "Returns driver specific information about the device"

    <apicall: int32 "GetDeviceCaps" (handle int32) module: "gdi32.dll" >
    self primitiveFailed.

    "Modified: / 01-08-2006 / 16:13:05 / fm"
    "Modified: / 04-10-2006 / 11:38:06 / cg"
!

primGetPrinter:hwndArg level:index informationBuffer:informationBuffer bufferSize:bufferSize bufferNeededSize:bufferNeededSize
    <apicall: bool "GetPrinterA" (handle dword pointer dword pointer) module: "winspool.drv" >
    self primitiveFailed.

"
|hPrinter rslt printerName informationBuffer bytesNeeded sizeBytesArray ok|
     printerName := '\\http://exept.exept.de:631\lj4'.
     hPrinter := self openPrinter: printerName .

     sizeBytesArray := ByteArray new:4.
     ok := self
		primGetPrinter:hPrinter
		level:2
		informationBuffer: nil
		bufferSize: 0
		bufferNeededSize:sizeBytesArray.
     bytesNeeded := sizeBytesArray longAt:1.

     informationBuffer := PrinterInfo2Structure new: bytesNeeded.
     rslt := self
		primGetPrinter:hPrinter
		level:2
		informationBuffer:informationBuffer
		bufferSize: bytesNeeded
		bufferNeededSize:sizeBytesArray.
     self assert: rslt.
     informationBuffer inspect.
     self closePrinter: printerName.
"

    "Modified: / 01-08-2006 / 12:39:26 / fm"
!

primGetTextExtentPoint: handle string: lpString count: nCount size: pSize
    <apicall: bool "GetTextExtentPointA" (handle pointer int32 pointer) module: "gdi32.dll" >
    self primitiveFailed.

    "Created: / 03-08-2006 / 11:06:23 / fm"
    "Modified: / 04-10-2006 / 11:38:21 / cg"
!

primGetTextMetrics: deviceContext lpMetrics: textMetrics
    <apicall: bool "GetTextMetricsA" (handle pointer) module: "gdi32.dll" >
    self primitiveFailed.

    "Modified: / 02-08-2006 / 16:17:51 / fm"
!

primOpenPrinter:name handleHolder:handleHolder ignored: ignored
    <apicall: bool "OpenPrinterA" ( lpstr lpstr lpstr ) module: "winspool.drv" >
    self primitiveFailed.

    "
     |h hh rslt|

     hh := ByteArray new:4.
     rslt := self primOpenPrinter:'\\http://exept.exept.de:631\lj4' handleHolder:hh ignored: nil.
     h := Win32Handle new setAddressFromBytes:hh.
     self halt.
    "

    "Created: / 27-07-2006 / 14:39:35 / fm"
!

primSetTextAlign:handle with:fMode
    <apicall: bool "SetTextAlign" (handle int16) module: "gdi32.dll" >
    "SetTextAlign"
    "gdi32.dll"

    self primitiveFailed.
!

primSetViewportOrgEx: h x: x y: y oldOrigin: oldOrigin

    <apicall: bool "SetViewportOrgEx" (handle int16 int16 pointer) module: "gdi32.dll" >
    self primitiveFailed.
!

primStartDoc:hwndArg docInfo: aDocInfo
    "Returns a jobId"
    <apicall: int32 "StartDocA" (handle pointer) module: "gdi32.dll" >
    self primitiveFailed.

    "Modified: / 31-07-2006 / 11:47:10 / fm"
!

primStartPage:hwndArg
    <apicall: int32 "StartPage" (handle) module: "gdi32.dll" >
    self primitiveFailed.

    "Created: / 27-07-2006 / 19:02:12 / fm"
    "Modified: / 31-07-2006 / 11:47:06 / fm"
!

setTextAlign: fMode to: handle

    self primSetTextAlign: handle with: fMode
!

setViewportOrg: h x: x y: y oldOrigin: oldOrigin

    self primSetViewportOrgEx: h x: x y: y oldOrigin: oldOrigin
!

startDoc: deviceContext docInfo: docInfoStruct
    ^self primStartDoc:deviceContext docInfo: docInfoStruct

    "Created: / 27-07-2006 / 19:42:39 / fm"
    "Modified: / 04-10-2006 / 11:38:30 / cg"
!

startPage: deviceContext
    ^self primStartPage:deviceContext

    "Created: / 27-07-2006 / 19:43:56 / fm"
    "Modified: / 28-07-2006 / 18:48:58 / fm"
    "Modified: / 04-10-2006 / 11:38:34 / cg"
! !

!Win32OperatingSystem class methodsFor:'private'!

mapLanguage:aWindowsLanguageString
    "map a windows language string to ISO languageCode_languageTerritory format"

    |windowsLanguageString|

    windowsLanguageString := aWindowsLanguageString asUppercase.

    #('DEU'     'de_DE'
      'DES'     'de_CH'
      'DEA'     'de_AT'
      'DAN'     'da_DA'
      'ENA'     'en_AU'
      'ENC'     'en_CA'
      'ENG'     'en_GB'
      'ENI'     'en_IR'
      'ENU'     'en_US'
      'ENZ'     'en_NZ'
      'FRA'     'fr_FR'
      'FRB'     'fr_BE'
      'FRC'     'fr_CA'
      'FRS'     'fr_CH'
      'ITA'     'it_IT'
      'ITS'     'it_CH'
      'ESM'     'es_MX'
      'ESN'     'es_ES'
      'ESP'     'es'            "Castillian"
      'NLB'     'nl_BE'
      'NLD'     'nl_NL'
      'CSY'     'cs_CS'
      'ELL'     'el_EL'
      'NON'     'no_NO'
      'NOR'     'no_NO'
     ) pairWiseDo:[:key :mappedValue|
	key = windowsLanguageString ifTrue:[
	    ^ mappedValue
	]
    ].

    "no mapping"
    ^ windowsLanguageString.

    "
     self mapLanguage:'DEU'
    "
!

osProcessStatusClass
    ^ OSProcessStatus

    "Created: / 12.6.1998 / 16:30:43 / cg"
!

primExpandEnvironmentStringsA:inString into:outString size:outBufferSize
%{
    if (__isString(inString)
     && __isString(outString)
     && __isSmallInteger(outBufferSize)) {
	unsigned long c_outBufferSize = __intVal(outBufferSize);

	if (__stringSize(outString) <= c_outBufferSize) {
	    unsigned long c_ret;

	    c_ret = ExpandEnvironmentStringsA(__stringVal(inString), __stringVal(outString), c_outBufferSize);
	    RETURN( __mkSmallInteger(c_ret) );
	}
    }
%}.
    "/ <apicall: ulongReturn "ExpandEnvironmentStringsA" (pointer pointer ulong) module: "kernel32.dll" >
    ^self primitiveFailed

    "
	self primExpandEnvironmentStringsA:'%ProgramFiles%\test\x' into:(String new:256) inspect size:256
    "
!

primExpandEnvironmentStringsW:inString into:outString size:outBuffer

    <apicall: ulongReturn "ExpandEnvironmentStringsW" (pointer pointer ulong) module: "kernel32.dll" >
    ^self primitiveFailed

    "
	self primExpandEnvironmentStringsW:'%ProgramFiles%\test\x' asUnicodeString into:(Unicode16String new:256) inspect size:256
    "
!

quoteCommandParameter: parameter on: stream
    "Quotes the parameter as neccesary on Windows"

    "/ Adapted version of ArgvQuote,
    "/ see http://blogs.msdn.com/b/twistylittlepassagesallalike/archive/2011/04/23/everyone-quotes-arguments-the-wrong-way.aspx

    | parameterS |

    stream nextPut: $".
    parameterS := parameter readStream.
    [ parameterS atEnd ] whileFalse:[
        | numBackSlashes |

        numBackSlashes := 0.

        [ parameterS atEnd not and:[ parameterS peek == $\ ] ] whileTrue:[
            numBackSlashes := numBackSlashes + 1.
            parameterS next.
        ].
        parameterS atEnd ifTrue:[
            "/ Escape all backslashes, but let the terminating
            "/ double quotation mark we add below be interpreted
            "/ as a metacharacter.
            stream next: numBackSlashes * 2 put: $\
        ] ifFalse:[
            parameterS peek == $" ifTrue:[
                "/ Escape all backslashes and the following
                "/ double quotation mark.
                stream next: numBackSlashes * 2 put: $\.
                stream nextPut: $\.
                stream nextPut: $".
            ] ifFalse:[
                "/ Backslashes aren't special here.
                stream next: numBackSlashes put: $\.               
                stream nextPut: parameterS peek.
            ].
            parameterS next.
        ].
    ].
    stream nextPut: $".

    "Created: / 11-01-2018 / 23:24:07 / jv"
! !

!Win32OperatingSystem class methodsFor:'regional settings'!

country
	"Answer the current system value for country."

    ^self queryNationalProfileString: 'iCountry' default: 0

    "
	self country
    "

    "Modified: / 22-12-2006 / 16:45:32 / User"
!

countryName
	"Answer the current system value for country name."

    ^self queryNationalProfileString: 'sCountry' default: 'Deutschland'

    "
	self countryName
    "

    "Modified: / 22-12-2006 / 16:45:32 / User"
!

dateFormat
    "Answer the current system value for date format.
     Answer DfMDY = Month-Day-Year
	    DfDMY = Day-Month-Year
	    DfYMD = Year-Month-Day."

    |separatorString code|

    separatorString := self dateSeparator.

    code := self dateFormatCode.
    code = 0 ifTrue:[ ^ '%(mon)', separatorString, '%(day)', separatorString, '%(year)' ].
    code = 1 ifTrue:[ ^ '%(day)', separatorString, '%(mon)', separatorString, '%(year)' ].
    code = 2 ifTrue:[ ^ '%(year)', separatorString, '%(mon)', separatorString, '%(day)' ].

    ^ '%(day)', separatorString, '%(mon)', separatorString, '%(year)'

    "
     self dateFormat
    "

    "Modified: / 22-12-2006 / 16:43:30 / User"
    "Modified: / 28-03-2011 / 17:10:01 / cg"
!

dateFormatCode
	"Answer the current system value for date format.
	 Answer DfMDY = Month-Day-Year = 0
		DfDMY = Day-Month-Year = 1
		DfYMD = Year-Month-Day = 2"

    ^self queryNationalProfileInt: 'iDate' default: 0

    "
	self dateFormatCode
    "

    "Modified: / 22-12-2006 / 16:45:53 / User"
!

dateSeparator
	"Answer the current system value for date separator."

    ^self queryNationalProfileString: 'sDate' default: '/'

    "
	self dateSeparator
    "

    "Modified: / 22-12-2006 / 16:45:32 / User"
!

decimalSeparator
	"Answer the current system value for decimal separator."

    ^self queryNationalProfileString: 'sDecimal' default: '.'

    "
	self decimalSeparator
    "

    "Created: / 22-12-2006 / 16:45:11 / User"
!

isDateFormatDMY
	"Answer the current system value for date format.
	 Answer DfMDY = Month-Day-Year
		DfDMY = Day-Month-Year
		DfYMD = Year-Month-Day."

    ^self dateFormatCode = 1

    "Created: / 18-01-2007 / 14:56:23 / User"
!

isDateFormatMDY
	"Answer the current system value for date format.
	 Answer DfMDY = Month-Day-Year
		DfDMY = Day-Month-Year
		DfYMD = Year-Month-Day."

    ^self dateFormatCode = 0

    "Created: / 18-01-2007 / 14:56:07 / User"
!

isDateFormatYMD
	"Answer the current system value for date format.
	 Answer DfMDY = Month-Day-Year
		DfDMY = Day-Month-Year
		DfYMD = Year-Month-Day."

    ^self dateFormatCode = 2

    "Created: / 18-01-2007 / 14:56:30 / User"
!

isTimeFormat12Hour
	"Answer whether the current system time format is 12-hour."

    ^self timeFormat = 0

    "Created: / 22-12-2006 / 16:48:17 / User"
!

primGetProfileInt: appName keyName: keyName default: anInt

    <apicall: uint32 "GetProfileIntA" ( lpstr lpstr uint32) module: "kernel32.dll" >
    ^self primitiveFailed

    "Created: / 22-12-2006 / 16:17:18 / User"
!

primGetProfileString: appName keyName: keyName default: defaultStr returnedString: retStr size: anInt

    <apicall: uint32 "GetProfileStringA" ( lpstr lpstr lpstr lpstr uint32) module: "kernel32.dll" >
    ^self primitiveFailed

    "Created: / 22-12-2006 / 16:20:23 / User"
!

queryNationalProfileInt: aKeyName default: defaultValue

    | answer |
    answer := self primGetProfileInt: 'Intl'
	keyName: aKeyName
	default: -1 asUnsigned32.
    ^answer = -1 asUnsigned32
	ifTrue: [ defaultValue ]
	ifFalse: [ answer ]

"
    self queryNationalProfileInt: 'iDate' default: 0
"

    "Modified: / 22-12-2006 / 16:23:05 / User"
!

queryNationalProfileString: aKeyName default: defaultValue
	"Answer the string value of key aKeyName in
	the [Intl] application section of the WIN.INI profile file.
	Answer defaultValue if aKeyName cannot be found."
    | extString result |
    extString := String new: 80.
    result := self primGetProfileString: 'Intl'
	keyName: aKeyName
	default: ''
	returnedString: extString
	size: extString size.
    ^result > 0
	ifTrue: [extString copyFrom: 1 to: result]
	ifFalse: [ defaultValue ]

    "Created: / 22-12-2006 / 16:13:01 / User"
!

thousandsSeparator
	"Answer the current system value
	for the thousands separator."

    ^self queryNationalProfileString: 'sThousand' default: ','

    "
	self thousandsSeparator
    "

    "Created: / 22-12-2006 / 16:46:50 / User"
!

timeFormat
	"Answer the current system value for time format."

    ^self queryNationalProfileInt: 'iTime' default: 0

    "
	self timeFormat
    "

    "Created: / 22-12-2006 / 16:48:27 / User"
! !

!Win32OperatingSystem class methodsFor:'registry support'!

registryEntry
    "provide access to the registryEntry class"

    ^ RegistryEntry
! !

!Win32OperatingSystem class methodsFor:'serial port support'!

serialPortAccessor
    "provide access to the serial port class"

    ^ Win32SerialPortHandle
! !

!Win32OperatingSystem class methodsFor:'shell operations'!

openApplicationForDocument:fileOrUrl operation:operationSymbol mimeType:mimeType inDirectory:directoryStringOrFilenameOrNil
    "open a windows-shell application to present the document contained in aFilenameOrString.
     This looks for the files extension, and is typically used to present help-files,
     html documents, pdf documents etc.
     operationSymbol is one of:
	open
	edit
	explore
	print
    "

    |handle directoryName|

    "nil directory is the current directory"
    directoryStringOrFilenameOrNil notNil ifTrue:[
	directoryName := directoryStringOrFilenameOrNil asFilename pathName.
    ].

    handle := self
	shellExecute:nil
	lpOperation:operationSymbol
	lpFile:fileOrUrl asString
	lpParameters:nil
	lpDirectory:directoryName
	nShowCmd:#SW_SHOWNORMAL.

    handle notNil ifTrue:[
	handle close.
    ].


    "
     self openApplicationForDocument: Filename currentDirectory operation:#open
     self openApplicationForDocument: 'C:\' operation:#open
     self openApplicationForDocument: '..\..\doc\books\ArtOfSmalltalk\artMissing186187Fix1.pdf' asFilename operation:#open
     self openApplicationForDocument: 'http://www.exept.de' asFilename operation:#open

     self openApplicationForDocument: 'C:\WINDOWS\Help\clipbrd.chm' asFilename operation:#open
    "

    "Created: / 04-08-2006 / 18:04:52 / fm"
    "Modified: / 05-02-2011 / 16:25:31 / cg"
! !

!Win32OperatingSystem class methodsFor:'socket support'!

socketAccessor
    "provide access to the socket handle class"

    ^ Win32SocketHandle
! !

!Win32OperatingSystem class methodsFor:'system management'!

exitWindows
    "do not use - may be removed without notice"

    self exitWindows:#shutdown confirm:'Do you really want to shutdown the system'
!

exitWindows:how confirm:confirmationMessageOrNil
    "this method is temporary -
     since my windows system menu crashes so often
     (even CTRL-ALT-DEL does no longer function, but ST/X is still alive),
     I added this in order to be able to shutdown w95 cleanly"

    confirmationMessageOrNil notNil ifTrue:[
	(Dialog confirm:confirmationMessageOrNil) ifFalse:[
	    ^ false
	].
    ].
%{
    int flag;

    if (how == @symbol(shutdown)) {
	flag = EWX_SHUTDOWN;
    } else if (how == @symbol(reboot)) {
	flag = EWX_REBOOT;
    } else if (how == @symbol(logoff)) {
	flag = EWX_LOGOFF;
    } else if (how == @symbol(forceShutdown)) {
	flag = EWX_SHUTDOWN | EWX_FORCE;
    } else if (how == @symbol(forceReboot)) {
	flag = EWX_REBOOT | EWX_FORCE;
    } else if (how == @symbol(forceLogoff)) {
	flag = EWX_LOGOFF | EWX_FORCE;
    } else {
	RETURN (false);
    }
    RETURN ((ExitWindowsEx(flag, 0) == TRUE) ? true : false);
%}
! !

!Win32OperatingSystem class methodsFor:'time and date'!

computeOSTimeFromYear:y month:m day:d hour:h minute:min second:s millisecond:millis utc:utcBoolean
    "return the OS-dependent time for the given time and day.
     The arguments are assumed to be in localtime including
     any daylight saving adjustings."

    |osTime|

%{
    if (__bothSmallInteger(y, m)
     && __bothSmallInteger(d, h)
     && __bothSmallInteger(min, s)
     && __isSmallInteger(millis)) {
	SYSTEMTIME sysTime;
	FILETIME fileTime;

	sysTime.wHour = __intVal(h);
	sysTime.wMinute = __intVal(min);
	sysTime.wSecond = __intVal(s);
	sysTime.wMilliseconds = __intVal(millis);

	sysTime.wYear = __intVal(y);
	sysTime.wMonth = __intVal(m);
	sysTime.wDay = __intVal(d);

	if (sysTime.wYear < 1602) goto outOfRange;   // not 1601 - so we don't have to care for timezone
	if (sysTime.wYear > 9999) goto outOfRange;

	if (utcBoolean != true) {
	    // adjust for local time

	    // TzSpecificLocalTimeToSystemTime() is not supported in Win2000
	    // - but we do not support Win2k any longer as of 2014
#ifdef __BORLANDC__
	    {
		typedef BOOL (WINAPI *P_TzSpecificLocalTimeToSystemTime)(LPTIME_ZONE_INFORMATION, LPSYSTEMTIME, LPSYSTEMTIME);
		static P_TzSpecificLocalTimeToSystemTime pTzSpecificLocalTimeToSystemTime;

		if (pTzSpecificLocalTimeToSystemTime == NULL) {
		    pTzSpecificLocalTimeToSystemTime =
			(P_TzSpecificLocalTimeToSystemTime)
			    GetProcAddress ( GetModuleHandle ("kernel32.dll"),
							      "TzSpecificLocalTimeToSystemTime");
		}
		if (!pTzSpecificLocalTimeToSystemTime(0, &sysTime, &sysTime))
		    goto error;
	    }
#else
	    if (!TzSpecificLocalTimeToSystemTime(0, &sysTime, &sysTime))
		goto error;
#endif
	}

	if (! SystemTimeToFileTime(&sysTime, &fileTime))
	    goto error;

	osTime = FileTimeToOsTime1970(&fileTime);
    }
outOfRange: ;
error: ;
%}.
    osTime notNil ifTrue:[
	"/ rebias to 1970 by subtracting the number of millis from 1.1.1601 to 1.1.1970
	"/ ^ osTime - self osTimeOf19700101. -- already done
	^ osTime
    ].

    "Error, some invalid date ot time"
    ^ TimeConversionError raiseRequest

    "
     OperatingSystem computeOSTimeFromUTCYear:1970 month:1 day:1 hour:0 minute:0 second:0 millisecond:0
     OperatingSystem computeOSTimeFromYear:1970 month:1 day:1 hour:0 minute:0 second:0 millisecond:0
     OperatingSystem computeOSTimeFromYear:2014 month:7 day:1 hour:0 minute:0 second:0 millisecond:0
    "

    "Modified: / 07-07-2010 / 16:56:56 / cg"
!

epochEndOSTime
    "private interface for timestamp to ask the OS what the maximum time
     (in milliseconds since the Unix epoch, 1.1.1970) is."

    "Windows has a 64 Unix 100ns osTime internally, which goes from 0 (1601)
     to 16r7FFFFFFFFFFFFFFF."
    "/ ^ (16r7FFFFFFFFFFFFFFF // 10000) - self osTimeOf19700101

    "/ but I changed the interface to use unix-biased times as well
    ^ (SmallInteger maxVal * 2 + 1) * 1000
!

epochStartOSTime
    "private interface for timestamp to ask the OS what the minimum time
     (in milliseconds since the Unix epoch, 1.1.1970) is."

    "Windows epoch starts at 1.1.1601."
    "/ ^ self osTimeOf19700101 negated

    "/ but I changed the interface to use unix-biased times as well
    ^ 0
!

getMicrosecondTime
    "This returns a microsecond timer value.
     The returned value is a 64bit value
     (which is the number of microseconds since the system's boot time -
      but you should not depend on that because it is system specific.
     Only use for relative delta-times."

%{  /* NOCONTEXT */
    static int frequencyKnown = 0;
    static LONGLONG ticksPerSecond;
    static LONGLONG divisor;
    LONGLONG tick;     // A point in time
    LONGLONG micros;

    if (! frequencyKnown) {
	// get the high resolution counter's accuracy
	QueryPerformanceFrequency(&ticksPerSecond);
	frequencyKnown = 1;
	divisor = ticksPerSecond / (LONGLONG)1000000;
    }

    // what time is it?
    QueryPerformanceCounter(&tick);

    micros = tick / divisor;
    RETURN ( __MKLARGEINT64(1, (micros & 0xFFFFFFFF), (micros >> 32)) );
%}
    "
     |t1 t2 dT|

     t1 := self getMicrosecondTime.
     Delay waitForSeconds:1.
     t2 := self getMicrosecondTime.
     dT := t2 - t1
    "
    "
     |t1 t2 dT|

     t1 := self getMillisecondTime.
     Delay waitForSeconds:1.
     t2 := self getMillisecondTime.
     dT := t2 - t1
    "
!

getMillisecondTime
    "This returns the millisecond timers value.
     The range is limited to 0..1fffffff (i.e. the SmallInteger range) to avoid
     LargeInteger arithmetic when doing timeouts and delays.
     Since this value is wrapping around in regular intervals (approx. every 6.21 days),
     this can only be used for short relative time deltas.
     Use the millisecondTimeXXX:-methods to compare and add time deltas - these know about the wrap.

     BAD DESIGN:
	This should be changed to return some instance of RelativeTime,
	and these computations moved there.

     Don't use this method in application code since it is an internal (private)
     interface. For compatibility with ST-80, use Time millisecondClockValue.
    "

%{  /* NOCONTEXT */
#if POINTERSIZE == 8
    RETURN ( __mkSmallInteger(GetTickCount64() & (_MAX_INT >> 1)) );
#else
    RETURN ( __mkSmallInteger(GetTickCount() & (_MAX_INT >> 1)) );
#endif
%}

    "
	self getMillisecondTime

	|t1 t2|
	t1 := self getMillisecondTime.
	Delay waitForSeconds:1.
	t2 := self getMillisecondTime.
	t2 - t1.
    "
!

getOSTime
    "This returns the OS time.
     The base of the returned value is not consistent across
     different OS's - some return the number of millis since jan, 1st 1970;
     others since 1600. Here, the original value of the OS is rebiased to 1.1.1970,
     meaning that the returned value has the number of seconds since 1970 subtracted,
     so the returned value is consistent across ST/X's running on different systems.

     Don't use this method in application code since it is an internal (private)
     interface. For compatibility with ST-80, use Time>>millisecondClockValue.
     or use instances of Time, Date or Timestamp to work with."

    |osTime|

%{
    FILETIME fileTime;

    GetSystemTimeAsFileTime(&fileTime);
    osTime = FileTimeToOsTime1970(&fileTime);
%}.
    "/ rebias to 1970 by subtracting the number of millis from 1.1.1601 to 1.1.1970
    "/ ^ osTime - self osTimeOf19700101 -- already done.
    ^ osTime

    "
     OperatingSystem getOSTime.
     Delay waitForSeconds:0.2.
     OperatingSystem getOSTime printCR.
    "
!

getTimezoneInformation
    "get information about the OS's timezone setting. See documentation in
     AbstractOperatingSystem::TimeZoneInformation for details"

    ^ self getTimezoneInformationForYear:nil.

    "
     self getTimezoneInformation
    "
!

getTimezoneInformationForYear:anIntegerOrNil
    "get information about the OS's timezone setting. See documentation in
     AbstractOperatingSystem::TimeZoneInformation for details"

    |error bias standardName
     standardDate_y standardDate_m standardDate_d standardDate_wd
     standardDate_h standardDate_min standardDate_s
     standardBias
     daylightName
     daylightDate_y daylightDate_m daylightDate_d daylightDate_wd
     daylightDate_h daylightDate_min daylightDate_s
     daylightBias info|

%{
    TIME_ZONE_INFORMATION tzInfo;
    DWORD retVal;
    WCHAR nm[33];

    if (anIntegerOrNil == nil) {
	retVal = GetTimeZoneInformation(&tzInfo);
	switch (retVal) {
	    case TIME_ZONE_ID_STANDARD:
	    case TIME_ZONE_ID_DAYLIGHT:
	    case TIME_ZONE_ID_UNKNOWN:
		break;

	    default:
	    case TIME_ZONE_ID_INVALID:
		error = __mkSmallInteger(__WIN32_ERR(GetLastError()));
		goto out;
	}
    } else if (__isSmallInteger(anIntegerOrNil)) {
	int year = __intVal(anIntegerOrNil);
#if defined(__BORLANDC__) || (defined(__MINGW32__) && !defined(__MINGW64__))
	{
	    typedef BOOL (WINAPI *P_GetTimeZoneInformationForYear)(
					USHORT,
					LPTIME_ZONE_INFORMATION, // - should be, but is not defined: PDYNAMIC_TIME_ZONE_INFORMATION,
					LPTIME_ZONE_INFORMATION);
	    static P_GetTimeZoneInformationForYear pGetTimeZoneInformationForYear;
	    static int haveTriedToGet_P_GetTimeZoneInformationForYear = 0;

	    if (! haveTriedToGet_P_GetTimeZoneInformationForYear) {
		pGetTimeZoneInformationForYear =
		    (P_GetTimeZoneInformationForYear)GetProcAddress(GetModuleHandle("kernel32.dll"), "GetTimeZoneInformationForYear");
		haveTriedToGet_P_GetTimeZoneInformationForYear = 1;
	    }
	    if (pGetTimeZoneInformationForYear == NULL) {
		error = __mkSmallInteger(@symbol(primitiveFailed));
		goto out;
	    } else {
		if (!pGetTimeZoneInformationForYear(year, NULL, &tzInfo)) {
		    error = __mkSmallInteger(__WIN32_ERR(GetLastError()));
		    goto out;
		}
	    }
	}
#else
	if (!GetTimeZoneInformationForYear(year, NULL, &tzInfo)) {
	    error = __mkSmallInteger(__WIN32_ERR(GetLastError()));
	    goto out;
	}
#endif
    } else {
	error = @symbol(badArgument);
	goto out;
    }

    bias = __mkSmallInteger(tzInfo.Bias);
    memmove(nm, tzInfo.StandardName, 32*sizeof(WCHAR));
    nm[32] = 0;
    standardName = __mkStringOrU16String_maxlen(nm, sizeof(nm));
    standardDate_y = __mkSmallInteger(tzInfo.StandardDate.wYear);
    standardDate_m = __mkSmallInteger(tzInfo.StandardDate.wMonth);
    standardDate_d = __mkSmallInteger(tzInfo.StandardDate.wDay);
    standardDate_wd = __mkSmallInteger(tzInfo.StandardDate.wDayOfWeek);
    standardDate_h = __mkSmallInteger(tzInfo.StandardDate.wHour);
    standardDate_min = __mkSmallInteger(tzInfo.StandardDate.wMinute);
    standardDate_s = __mkSmallInteger(tzInfo.StandardDate.wSecond);
    standardBias =  __mkSmallInteger(tzInfo.StandardBias);
    memmove(nm, tzInfo.DaylightName, 32*sizeof(WCHAR));
    nm[32] = 0;
    daylightName = __mkStringOrU16String_maxlen(nm, sizeof(nm));
    daylightDate_y = __mkSmallInteger(tzInfo.DaylightDate.wYear);
    daylightDate_m = __mkSmallInteger(tzInfo.DaylightDate.wMonth);
    daylightDate_d = __mkSmallInteger(tzInfo.DaylightDate.wDay);
    daylightDate_wd = __mkSmallInteger(tzInfo.DaylightDate.wDayOfWeek);
    daylightDate_h = __mkSmallInteger(tzInfo.DaylightDate.wHour);
    daylightDate_min = __mkSmallInteger(tzInfo.DaylightDate.wMinute);
    daylightDate_s = __mkSmallInteger(tzInfo.DaylightDate.wSecond);
    daylightBias =  __mkSmallInteger(tzInfo.DaylightBias);

out:;
%}.
    error notNil ifTrue:[
	self primitiveFailed:error.
    ].

    info := self timeZoneInfoClass new.
    info
	bias:bias
	name:standardName standardBias:standardBias
	daylightName:daylightName daylightBias:daylightBias.

    standardDate_m ~~ 0 ifTrue:[
	info standardYear:standardDate_y standardMonth:standardDate_m standardDay:standardDate_d
	     standardWeekDay:standardDate_wd standardHour:standardDate_h standardMinute:standardDate_min.
    ].
    daylightDate_m ~~ 0 ifTrue:[
	info daylightYear:daylightDate_y daylightMonth:daylightDate_m daylightDay:daylightDate_d
	     daylightWeekDay:daylightDate_wd daylightHour:daylightDate_h daylightMinute:daylightDate_min.
    ].

    ^ info

    "
     self getTimezoneInformationForYear:2014
     self getTimezoneInformationForYear:2015
     self getTimezoneInformationForYear:1977
     self getTimezoneInformationForYear:nil
    "
!

osTimeOf19700101
    "the number of millis from 1.1.1601 to 1.1.1970"

    ^ 11644473600000

    "
      self computeOSTimeFromUTCYear:1970 month:1 day:1 hour:0 minute:0 second:0 millisecond:0
    "
!

sleep:numberOfSeconds
    "{ Pragma: +optSpace }"

    "cease ANY action for some time. This suspends the whole smalltalk
     (unix-) process for some time.
     Not really useful since not even low-prio processes and interrupt
     handling will run during the sleep.
     Use either OperatingSystem>>millisecondDelay: (which makes all
     threads sleep, but handles interrupts) or use a Delay (which makes
     only the calling thread sleep)."

%{  /* NOCONTEXT */

    if (__isSmallInteger(numberOfSeconds)) {
	sleep(__intVal(numberOfSeconds));
	RETURN ( self );
    }
%}.
    "
     argument not integer
    "
    ^ self primitiveFailed

    "
     OperatingSystem sleep:2
    "
!

timeInfoFromSeconds:osSeconds milliseconds:osMilliSeconds localTime:isLocalTime
    "return a timeInfo structure containing values for the given OS-millisecond value.
     An internal helper"

    |year month day hour minute second millis utcOffset isDst
     dst yDay weekDay info reason tLow tHigh t error |

    t := (osSeconds * 1000) + osMilliSeconds "+ self osTimeOf19700101 -- done in C".
    tLow := (t bitAnd:16rFFFFFFFF).
    tHigh := t bitShift:-32.

%{
    FILETIME fileTime;
    SYSTEMTIME sysTime, *sysTimePtr;
    INT _utcOffset, _stdUtcOffset;

    /* try cache */
    {
	OBJ lastOsTimeLow, lastOsTimeHi, lastTimeInfo;

	lastOsTimeLow = @global(LastOsTimeLow);
	lastOsTimeHi = @global(LastOsTimeHi);
	if (__isInteger(lastOsTimeLow)
	     && (__unsignedLongIntVal(lastOsTimeLow) == __unsignedLongIntVal(tLow))
	     && lastOsTimeHi
	     && (__unsignedLongIntVal(lastOsTimeHi) == __unsignedLongIntVal(tHigh))
	     && (@global(LastTimeInfoIsLocal) == isLocalTime)
	) {
	    lastTimeInfo = @global(LastTimeInfo);
	    if (lastTimeInfo != nil) {
		RETURN (lastTimeInfo);
	    }
	}
    }

    if (!OsTime1970ToFileTime(tLow, tHigh, &fileTime))
	goto out;
    if (!FileTimeToSystemTime(&fileTime, &sysTime))
	goto out;

    if (isLocalTime == false) { // easy: UTC time
	sysTimePtr = &sysTime;
	utcOffset = __mkSmallInteger(0);
	isDst = false;
    } else {  // local time: have to convert and find out about DST
	TIME_ZONE_INFORMATION tzInfo;
	LONGLONG longTime;
	SYSTEMTIME localSysTime;
	FILETIME localFileTime;

	sysTimePtr = &localSysTime;

	if (!SystemTimeToTzSpecificLocalTime(NULL, &sysTime, &localSysTime))
	    goto out;
	if (!SystemTimeToFileTime(&localSysTime, &localFileTime))
	    goto out;

	// all the rest is computing the UTC offset and whether DST applies
	longTime = ((LONGLONG)fileTime.dwHighDateTime << 32) + fileTime.dwLowDateTime;
	longTime -= ((LONGLONG)localFileTime.dwHighDateTime << 32) + localFileTime.dwLowDateTime;

	// utcOffset is the difference from UTC to local time including possible DST
	_utcOffset = longTime / 10000000;
	utcOffset = __mkSmallInteger(_utcOffset);

# if defined(__BORLANDC__) || (defined(__MINGW32__) && !defined(__MINGW64__))
	{
	    typedef BOOL (WINAPI *P_GetTimeZoneInformationForYear)(
					USHORT,
					LPTIME_ZONE_INFORMATION, // - should be, but is not defined: PDYNAMIC_TIME_ZONE_INFORMATION,
					LPTIME_ZONE_INFORMATION);
	    static P_GetTimeZoneInformationForYear pGetTimeZoneInformationForYear;
	    static int haveTriedToGet_P_GetTimeZoneInformationForYear = 0;

	    if (! haveTriedToGet_P_GetTimeZoneInformationForYear) {
		pGetTimeZoneInformationForYear =
		    (P_GetTimeZoneInformationForYear)GetProcAddress(GetModuleHandle("kernel32.dll"), "GetTimeZoneInformationForYear");
		haveTriedToGet_P_GetTimeZoneInformationForYear = 1;
	    }
	    if (pGetTimeZoneInformationForYear == NULL) {
		// ignore this error and fall back to GetTimeZoneInformation()
		reason = @symbol(NoGetTimeZoneInformationForYear);
	    } else {
		if (pGetTimeZoneInformationForYear(localSysTime.wYear, NULL, &tzInfo)) {
		    _stdUtcOffset = (tzInfo.Bias + tzInfo.StandardBias) * 60;
		    isDst = (_stdUtcOffset != _utcOffset) ? true : false;
		} else {
		    // ignore this error and fall back to GetTimeZoneInformation()
		    reason = @symbol(GetTimeZoneInformationForYearFailed);
		    error = __mkSmallInteger(__WIN32_ERR(GetLastError()));
		}
	    }
	}
# else
	if (GetTimeZoneInformationForYear(localSysTime.wYear, NULL, &tzInfo)) {
	    _stdUtcOffset = (tzInfo.Bias + tzInfo.StandardBias) * 60;
	    isDst = (_stdUtcOffset != _utcOffset) ? true : false;
	} else {
	    // ignore this error and fall back to GetTimeZoneInformation()
	    reason = @symbol(GetTimeZoneInformationForYearFailed);
	    error = __mkSmallInteger(__WIN32_ERR(GetLastError()));
	}
# endif
	// this code is a fallback for WIN XP
	if (isDst == nil) {
	    DWORD retVal = GetTimeZoneInformation(&tzInfo);
	    switch (retVal) {
		case TIME_ZONE_ID_STANDARD:
		case TIME_ZONE_ID_DAYLIGHT:
		case TIME_ZONE_ID_UNKNOWN:
		    // nonDstOffset is the difference from UTC to local time without DST
		    _stdUtcOffset = (tzInfo.Bias + tzInfo.StandardBias) * 60;
		    isDst = (_stdUtcOffset != _utcOffset) ? true : false;
		    break;

		// these are errors, which may occur, if the
		// Windows OS has not been setupm correctly.
		// We ignore these errors here, but we don't know if DST applies.
		// Assume that there is no DST.
		default:
		case TIME_ZONE_ID_INVALID:
		    isDst = false;
		    reason = @symbol(TIME_ZONE_ID_INVALID);
		    error = __mkSmallInteger(__WIN32_ERR(GetLastError()));
		    break;
	    }
	}  // End WINXP backward compatibility
    }

    hour = __mkSmallInteger(sysTimePtr->wHour);
    minute = __mkSmallInteger(sysTimePtr->wMinute);
    second = __mkSmallInteger(sysTimePtr->wSecond);

    year = __mkSmallInteger(sysTimePtr->wYear);
    month = __mkSmallInteger(sysTimePtr->wMonth);
    day = __mkSmallInteger(sysTimePtr->wDay);

    millis = __mkSmallInteger(sysTimePtr->wMilliseconds);

    weekDay = __mkSmallInteger(sysTimePtr->wDayOfWeek == 0 ? 7 : sysTimePtr->wDayOfWeek);
out:;
%}.
"/    '--> REASON: ' errorPrint. reason errorPrintCR. '--> ERROR: ' errorPrint. error errorPrintCR.

    year isNil ifTrue:[
	TimeConversionError raiseErrorString:' - out of range'.
    ].

    info := self timeInfoClass new.
    info
	year:year
	month:month
	day:day
	hours:hour
	minutes:minute
	seconds:second
	milliseconds:millis
	utcOffset:utcOffset
	dst:isDst
	dayInYear:yDay
	dayInWeek:weekDay.

    LastTimeInfo := info.
    LastOsTimeLow := tLow.
    LastOsTimeHi := tHigh.
    LastTimeInfoIsLocal := isLocalTime.

    ^ info

    "
    self assert:(Timestamp year:1994 month:2 day:1 hour:12 minute:0 second:0) timeInfo dst not

    DST in MEZ in 1994:
      self assert:(Timestamp year:1994 month:7 day:1 hour:12 minute:0 second:0) timeInfo dst

     no DST in MEZ in 1970:
      self assert:(Timestamp year:1977 month:7 day:1 hour:12 minute:0 second:0) timeInfo dst not
    "

    "Modified: / 06-07-2006 / 18:18:56 / cg"
! !

!Win32OperatingSystem class methodsFor:'users & groups'!

getApplicationDataDirectoryFor:appName
    "return the directory, where user-and-application-specific private files are to be
     located (ini-files, preferences etc.).
     Under windows, something like 'C:\Users\Administrator\AppData\Roaming\<appName>'
     is returned, here, the fallback ~/.<appName> is returned.
     Notice that only the name is returned; the directory is not guaranteed to exist."

    "{ Pragma: +optSpace }"

    |appDataDirFromEnv appDataDirFromRegistry|

    appDataDirFromEnv := self getEnvironment:'APPDATA'.
    appDataDirFromEnv notNil ifTrue:[
	^ appDataDirFromEnv , '\' , appName
    ].
    appDataDirFromRegistry :=
	(self registryEntry key:'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders')
	    valueNamed:'AppData'.
    appDataDirFromRegistry notNil ifTrue:[
	^ appDataDirFromRegistry , '\' , appName
    ].
    ^ super getApplicationDataDirectoryFor:appName

    "
     OperatingSystem getApplicationDataDirectoryFor:'expecco'
    "

    "Created: / 29-07-2010 / 12:13:12 / sr"
!

getDesktopDirectory
    "return the name of the users desktop directory (i.e. yours)."

    "{ Pragma: +optSpace }"

    |dir path|

    path := (self registryEntry
		key:'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders')
	    valueNamed:'Desktop'.

    path isNil ifTrue:[
	"Fallback"
	dir := self getHomeDirectory.
	dir isNil ifTrue:[ ^ nil ].

	path := dir , '\Desktop'.
    ].

    (self isValidPath:path) ifFalse:[ ^ nil ].
    ^ path

    "
     OperatingSystem getDesktopDirectory
    "

    "Created: / 16-05-2007 / 13:23:43 / cg"
!

getDocumentsDirectory
    "return the name of the users 'Documents' directory."

    "{ Pragma: +optSpace }"

    |dir|

    dir := (self registryEntry
		key:'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders')
	    valueNamed:'Personal'.

    dir isNil ifTrue:[
	dir := self getHomeDirectory.
    ].

    ^ dir.

    "
     OperatingSystem getDocumentsDirectory
    "
!

getEffectiveGroupID
    "{ Pragma: +optSpace }"

    "return the current users (thats you) effective numeric group id.
     This is only different from getGroupID, if you have ST/X running
     as a setuid program (of which you should think about twice)."

    ^ self getGroupID

    "
     OperatingSystem getEffectiveGroupID
    "
!

getEffectiveUserID
    "{ Pragma: +optSpace }"

    "return the current users (thats you) effective numeric user id.
     This is only different from getUserID, if you have ST/X running
     as a setuid program (of which you should think about twice)."

    ^ self getUserID

    "
     OperatingSystem getEffectiveUserID
    "
!

getFullUserNameFromID:userID
    "{ Pragma: +optSpace }"

    "return a string with the users full name - if available.
     If not, return the login name as a fallBack."

    |info gecos|

    info := self userInfoOf:userID.
    (info notNil
    and:[info includesKey:#gecos]) ifTrue:[
	gecos := info at:#gecos.
	(gecos includes:$,) ifTrue:[
	    ^ gecos copyTo:(gecos indexOf:$,) - 1
	].
	^ gecos
    ].
    ^ self getUserNameFromID:userID

    "
     OperatingSystem getFullUserNameFromID:0
     OperatingSystem getFullUserNameFromID:(OperatingSystem getUserID)

     OperatingSystem getUserNameFromID:(OperatingSystem getUserID)
    "

    "Modified: 15.7.1996 / 12:44:21 / cg"
!

getGroupID
    "{ Pragma: +optSpace }"

    "return the current users (thats you) numeric group id"

    ^ 1 "just a dummy for systems which do not have groupIDs"

    "
     OperatingSystem getGroupID
    "
!

getGroupNameFromID:aNumber
    "{ Pragma: +optSpace }"

    "return the group-name-string for a given numeric group-id"

    ^ '???' "just a dummy for systems which do not have groupIDs"

    "
     OperatingSystem getGroupNameFromID:0
     OperatingSystem getGroupNameFromID:10
    "
!

getHomeDirectory
    "return the name of the users home directory (i.e. yours)."

    "{ Pragma: +optSpace }"

    |dir|

    dir := self getEnvironment:'USERPROFILE'.
    dir isNil ifTrue:[
	dir := '.'.
    ].
    ^ dir.

    "
     OperatingSystem getHomeDirectory
    "

    "Modified: / 16.2.2000 / 09:17:55 / cg"
!

getLoginName
    "{ Pragma: +optSpace }"

    "return a string with the users login name (thats yours)"

%{  /* NOCONTEXT */
    static char cachedName[64];
    static firstCall = 1;
#ifndef __BORLANDC__
    extern char *getenv();
#endif
    char *name = (char *)0;

    if (firstCall) {
	DWORD nameSize = sizeof(cachedName);

	if (GetUserName(cachedName, &nameSize) == TRUE) {
	    name = cachedName;
	    firstCall = 0;
	}
    } else {
	name = cachedName;
    }

    /*
     * try a few common environment variables ...
     */
    if (! name || (name[0] == 0) ) {
	name = getenv("LOGIN");
	if (! name || (name[0] == 0) ) {
	    name = getenv("LOGNAME");
	    if (! name || (name[0] == 0) ) {
		name = getenv("USER");
	    }
	}
    }
    /*
     * nope - I really font know who you are.
     */
    if (! name || (name[0] == 0) ) {
	name = "you";
    }

    RETURN ( __MKSTRING(name) );
%}.
    "
     OperatingSystem getLoginName
    "
!

getUserID
    "{ Pragma: +optSpace }"

    "return the current users (thats you) numeric user id"

    ^ 1 "just a dummy for systems which do not have userIDs"

    "
     OperatingSystem getUserID
    "
!

getUserNameFromID:aNumber
    "{ Pragma: +optSpace }"

    "return the user-name-string for a given numeric user-id.
     This is the login name, not the fullName."

    aNumber == self getUserID ifTrue:[
	^ self getLoginName
    ].

    ^ '? (' , aNumber printString , ')'

    "
     OperatingSystem getUserNameFromID:0
     OperatingSystem getUserNameFromID:100
     OperatingSystem getUserNameFromID:9991
    "
!

isRunningWithElevatedRootOrAdminRights
    "return true, if a NORMAL user is running with elevated admin rights."

%{

    HANDLE h_Process;
    HANDLE h_Token;
    TOKEN_ELEVATION t_TokenElevation;
    TOKEN_ELEVATION_TYPE e_ElevationType;
    DWORD dw_TokenLength;

    h_Process = GetCurrentProcess();
    if (OpenProcessToken(h_Process,TOKEN_READ,&h_Token) == FALSE) {
	console_printf("Error: Couldn't open the process token\n");
	goto getOutOfHere;
    }
    if (GetTokenInformation(h_Token,TokenElevation,&t_TokenElevation,sizeof(t_TokenElevation),&dw_TokenLength) == FALSE) {
	console_printf("Error: Couldn't retrieve the elevation right of the current process token\n");
	CloseHandle(h_Token);
	goto getOutOfHere;
    }
    if (t_TokenElevation.TokenIsElevated != 0) {
	if (GetTokenInformation(h_Token,TokenElevationType,&e_ElevationType,sizeof(e_ElevationType),&dw_TokenLength) == FALSE) {
	    console_printf("Error: Couldn't retrieve the elevation token class\n");
	    CloseHandle(h_Token);
	    goto getOutOfHere;
	} else {
	    if (e_ElevationType == TokenElevationTypeFull || e_ElevationType == TokenElevationTypeDefault) {
		CloseHandle(h_Token);
		RETURN(true);
	    }
	    CloseHandle(h_Token);
	    RETURN(false);
	}
    } else {
	CloseHandle(h_Token);
	RETURN(false);
    }
getOutOfHere: ;
%}.
    "/ self primitiveFailed.
    ^ false

    "Modified: / 17-12-2013 / 17:12:23 / cg"
!

isRunningWithRootOrAdminRights
    "read some registry entry which only Admin can read;
     if we can, we are; otherwise, we are not."

%{
    SID_IDENTIFIER_AUTHORITY NtAuthority = SECURITY_NT_AUTHORITY;
    PSID AdministratorsGroup;
    BOOL IsInAdminGroup = FALSE;

    // Initialize SID.
    if( !AllocateAndInitializeSid( &NtAuthority,
				   2,
				   SECURITY_BUILTIN_DOMAIN_RID,
				   DOMAIN_ALIAS_RID_ADMINS,
				   0, 0, 0, 0, 0, 0,
				   &AdministratorsGroup))
    {
	// Initializing SID Failed.
	RETURN( false );
    }
    // Check whether the token is present in admin group.
    if( !CheckTokenMembership( NULL,
			       AdministratorsGroup,
			       &IsInAdminGroup ))
    {
	// Error occurred.
	IsInAdminGroup = FALSE;
    }
    // Free SID and return.
    FreeSid(AdministratorsGroup);
    RETURN( IsInAdminGroup ? true : false);
%}.
    "/ seems not to work...

"/    "/ RegOpenKey(HKEY_USERS, "S-1-5-19", &key)
"/    (RegistryEntry key:'HKEY_USERS') notNil ifTrue:[
"/        (RegistryEntry key:'HKEY_USERS/S-1-5-19') notNil ifTrue:[
"/            ^ true
"/        ]
"/    ].
    ^ false.

    "
     OperatingSystem isRunningWithRootOrAdminRights
    "

    "Created: / 28-11-2013 / 14:00:02 / cg"
!

userInfoOf:aNameOrID
    "{ Pragma: +optSpace }"

    "return a dictionary filled with userinfo. The argument can be either
     a string with the users name or its numeric id.
     Notice, that DOS systems only provide a very limited set of information.
     Portable applications may want to check the systemType and NOT depend
     on all keys to be present in the returned dictionary."

    |info userName loginName "uid gid"|

    info := IdentityDictionary new.
    loginName := self getLoginName.
    (aNameOrID == self getUserID or:[aNameOrID = loginName]) ifTrue:[
	userName := loginName.
	info at:#dir put:self getHomeDirectory.
    ] ifFalse:[
	userName := 'unknown'.
    ].
    info at:#name put:userName.
    "/ uid notNil ifTrue:[info at:#uid put:uid].
    "/ gid  notNil ifTrue:[info at:#gid put:gid].
    ^ info

    "
     OperatingSystem userInfoOf:'root'
     OperatingSystem userInfoOf:1
     OperatingSystem userInfoOf:'fooBar'
     OperatingSystem userInfoOf:(OperatingSystem getUserID)
    "
! !

!Win32OperatingSystem class methodsFor:'waiting for events'!

blockingChildProcessWait
     "return true, if childProcessWait: blocks, if no children are ready.
      On those systems, we must be somewhat careful when looking out for
      a subprocesses status (to avoid blocking)."

    ^ false
!

childProcessWait:blocking pid:pidToWait
    "{ Pragma: +optSpace }"

    "get status changes from child processes.
     Return an OSProcessStatus or nil, if no process has terminated.
     If blocking is true, we wait until a process changed state,
     otherwise we return immediately.
     Note that win32 needs to know the HANDLE of the process on which
     it waits.  In case of an error, THIS ALWAYS WAITS and then times out."

    |pid status code core|
%{
//#define PROCESSDEBUG_CHILDPROCESSWAIT

    int endStatus;
    DWORD exitCode;

    if (__isExternalAddressLike(pidToWait) ) {
	HANDLE __pidToWait = _HANDLEVal(pidToWait);

#ifdef PROCESSDEBUG_CHILDPROCESSWAIT
	console_printf("childProcessWait %x b %d\n",__pidToWait,blocking==true);
#endif

	if (blocking == true) {
#ifdef DO_WRAP_CALLS
	    do {
		__threadErrno = 0;
		// do not cast to INT - will loose sign bit then!
		endStatus = STX_API_CALL2( "WaitForSingleObject", WaitForSingleObject, __pidToWait, INFINITE);
	    } while ((endStatus < 0) && (__threadErrno == EINTR));
#else
	    endStatus = WaitForSingleObject(__pidToWait, INFINITE);
	    if (endStatus < 0) {
		__threadErrno = __WIN32_ERR(GetLastError());
	    }
#endif
	    if (endStatus == WAIT_TIMEOUT) {
		if (blocking==true)
		    status = @symbol(timeout);
		else {
		    status = @symbol(continue);
#ifdef PROCESSDEBUG_CHILDPROCESSWAIT
		    console_printf("ret nil\n");
#endif
		    RETURN(nil);
		}
	    } else if (endStatus == WAIT_OBJECT_0) {

	    }
	}

#ifdef PROCESSDEBUG_CHILDPROCESSWAIT
	console_printf("GetExitCodeProcess\n");
#endif

	if (GetExitCodeProcess(__pidToWait, &exitCode)) {
	    if (exitCode == STILL_ACTIVE) {
#ifdef PROCESSDEBUG_CHILDPROCESSWAIT
		console_printf("exitCode: STILL_ACTIVE\n");
#endif
		RETURN(nil);
	    }
#ifdef PROCESSDEBUG_CHILDPROCESSWAIT
	    console_printf("exitCode %d\n", exitCode);
#endif
	    status = @symbol(exit);
	    code = __mkSmallInteger(exitCode);
	    core = false;
	    pid = pidToWait;
	} else {
	    code = __mkSmallInteger(GetLastError());
#ifdef PROCESSDEBUG_CHILDPROCESSWAIT
	    console_printf("GetExitCodeProcess failed: error=%d\n", GetLastError());
#endif
	}
    }
%}.

    (status isNil or:[pid isNil]) ifTrue:[
	^ self primitiveFailed:code
    ].

"/ Transcript show:'pid: '; show:pid; show:' status: '; show:status;
"/ show:' code: '; show:code; show:' core:'; showCR:core.

    ^ OSProcessStatus pid:pid status:status code:code core:core
!

isBlockingOn:fd
    ^ true
!

numAvailableForReadOn:fd
    "return the number of bytes available for reading, without blocking."

%{
    unsigned long bytes_available;

    if (__Class(fd) == @global(Win32SocketHandle)) {
	if (ioctlsocket((SOCKET)_HANDLEVal(fd), FIONREAD, &bytes_available) == 0) {
	    if (bytes_available > _MAX_INT) bytes_available = _MAX_INT;
	    RETURN(__mkSmallInteger(bytes_available));
	}
    } else if (__isSmallInteger(fd)) {
	if (PeekNamedPipe(_get_osfhandle(__intVal(fd)), NULL, 0, NULL, &bytes_available, NULL) != 0){
	    if (bytes_available > _MAX_INT) bytes_available = _MAX_INT;
	    RETURN(__mkSmallInteger(bytes_available));
	}
    }
%}.

    ^ (self readCheck:fd) ifTrue:[1] ifFalse:[0]
!

selectOnAnyReadable:readFdArray writable:writeFdArray exception:exceptFdArray
  readableInto:readableResultFdArray writableInto:writableResultFdArray exceptionInto:exceptionResultFdArray
  withTimeOut:millis
    "wait for any fd in readFdArray (an Array of integers) to become ready for reading,
     writeFdArray to become ready for writing,
     or exceptFdArray to arrive exceptional data (i.e. out-of-band data).
     Timeout after t milliseconds or - if the timeout time is 0 - immediately..
     Empty fd-sets will always wait. Zero time can be used to poll file-
     descriptors (i.e. to check if I/O possible without blocking).
     The corresponding filedescriptors which are ready are returned in readableResultFdArray,
     writableResultFdArray and exceptionResultFdArray respectively.

     Return the (overall) number of selected filedescriptors.
     readableResultFdArray, writableResultFdArray and exceptionResultFdArray will
     get a nil-value stored into the slot after the last valid fileDescriptor;
     Thus, the caller can simply scan these arrays upTo the end or a nil value."

%{
//#define SELECTDEBUGWIN32
//#define SELECT3DEBUGWIN32
#define MAXHANDLE 128
    int i, idx;
    INT t;
    int numHandles;
    DWORD res;
    HANDLE hArray[MAXHANDLE+1];
    int retArray[MAXHANDLE];
    int readCount, writeCount, exceptCount;
    int resultSizeReadable = 0, resultSizeWritable = 0, resultSizeException = 0;
    int cntR = 0, cntW = 0, cntE = 0, cntAll = 0;
    int *pcntR = &cntR, *pcntW = &cntW, *pcntE = &cntE;
    fd_set readFds;
    fd_set writeFds;
    fd_set exceptFds;
    int hasSockets;
    int hasPipes;
    int pass = 1;       // perform up to 2 passes

    if (readableResultFdArray != nil) {
	if (! __isArrayLike(readableResultFdArray)) {
	    goto fail;
	}
	resultSizeReadable = __arraySize(readableResultFdArray);
    }
    if (writableResultFdArray != nil) {
	if (! __isArrayLike(writableResultFdArray)) {
	    goto fail;
	}
	resultSizeWritable = __arraySize(writableResultFdArray);
	if (readableResultFdArray == writableResultFdArray) {
	    // allow common result set for read/write/except
	    pcntW = &cntR;
	}
    }
    if (exceptionResultFdArray != nil) {
	if (! __isArrayLike(exceptionResultFdArray)) {
	    goto fail;
	}
	resultSizeException = __arraySize(exceptionResultFdArray);
	if (exceptionResultFdArray == readableResultFdArray) {
	    // allow common result set for read/write/except
	    pcntE = &cntR;
	} else if (exceptionResultFdArray == writableResultFdArray) {
	    pcntE = &cntW;
	}
    }

    if (__isNonNilObject(readFdArray)) {
	if (! __isArrayLike(readFdArray)) goto fail;
	readCount = __arraySize(readFdArray);
    } else {
	readCount = 0;
    }

    if (__isNonNilObject(writeFdArray)) {
	if (! __isArrayLike(writeFdArray)) goto fail;
	writeCount = __arraySize(writeFdArray);
    } else {
	writeCount = 0;
    }

    if (__isNonNilObject(exceptFdArray)) {
	if (! __isArrayLike(exceptFdArray)) goto fail;
	exceptCount = __arraySize(exceptFdArray);
    } else {
	exceptCount = 0;
    }

pollAgain:
    FD_ZERO(&readFds);
    FD_ZERO(&writeFds);
    FD_ZERO(&exceptFds);
    numHandles = hasSockets = hasPipes = 0;

    for (i = 0; (i < readCount) && (numHandles < MAXHANDLE); i++) {
	OBJ fd = __arrayVal(readFdArray)[i];

	if (fd != nil) {
	    if (__Class(fd) == @global(Win32SocketHandle)) {
		FD_SET (_HANDLEVal(fd), &readFds);
		hasSockets++;
	    } else if (__isSmallInteger(fd)) {
		DWORD canRead;
		if (PeekNamedPipe(_get_osfhandle(__intVal(fd)), 0, 0, 0, &canRead, 0)) {
		    if (canRead > 0) {
			if (*pcntR < resultSizeReadable) {
			    __arrayVal(readableResultFdArray)[*pcntR] = fd;
			}
			(*pcntR)++; cntAll++;
		    }
		} else {
		    @global(LastErrorNumber) = __mkSmallInteger(EBADF);
		    RETURN (__mkSmallInteger(-1));
		}
		hasPipes++;
	    } else {
		hArray  [numHandles] = _HANDLEVal(fd);
		retArray[numHandles] = i;
		++numHandles;
	    }
	}
    }

    for (i = 0; (i < writeCount) && (numHandles < MAXHANDLE); i++) {
	OBJ fd = __arrayVal(writeFdArray)[i];

	if (fd != nil) {
	    if (__Class(fd) == @global(Win32SocketHandle)) {
		FD_SET (_HANDLEVal(fd), &writeFds);
		hasSockets++;
	    } else if (__isSmallInteger(fd)) {
		// kludge: assume that pipes can alway be written
	       if (*pcntW < resultSizeWritable) {
		    __arrayVal(writableResultFdArray)[*pcntW] = fd;
		}
		(*pcntW)++; cntAll++;
		// there is no pipe to check
	    } else {
		hArray  [numHandles] = _HANDLEVal(fd);
		retArray[numHandles] = i + 10000;
		++numHandles;
	    }
	}
    }

    for (i = 0; (i < exceptCount) && (numHandles < MAXHANDLE); i++) {
	OBJ fdOrPid = __arrayVal(exceptFdArray)[i];

	if (fdOrPid != nil) {
	    if (__Class(fdOrPid) == @global(Win32SocketHandle)) {
		FD_SET (_HANDLEVal(fdOrPid), &exceptFds);
		hasSockets++;
	    } else if (__isExternalAddressLike(fdOrPid)) {
		// a PID
		hArray  [numHandles] = _HANDLEVal(fdOrPid);
		retArray[numHandles] = i + 20000;
		++numHandles;
	    }
	}
    }

    if (hasSockets) {
	struct timeval tv = {0, 0};
	int nReady;

#ifdef SELECT3DEBUGWIN32
	console_printf("select hasSockets = %d\n", hasSockets);
#endif
	nReady = select(1 , &readFds, &writeFds, &exceptFds, &tv);  // first parameter to select is ignored in windows
	if (nReady < 0) {
#ifdef SELECTDEBUGWIN32
	    console_printf("error in select %d %d\n", nReady, GetLastError());
#endif
	    @global(LastErrorNumber) = __mkSmallInteger(EBADF);
	    RETURN (__mkSmallInteger(-1));
	}
	if (nReady > 0) {
#ifdef SELECT3DEBUGWIN32
	    console_printf("select nReady %d of %d\n", nReady, hasSockets);
#endif
	    for (i = 0; i < readCount; i++) {
		OBJ fd = __arrayVal(readFdArray)[i];
		if ((__Class(fd) == @global(Win32SocketHandle)) && FD_ISSET(_HANDLEVal(fd), &readFds)) {
		    if (*pcntR < resultSizeReadable) {
			__arrayVal(readableResultFdArray)[*pcntR] = fd;
			__STORE(readableResultFdArray, fd);
		    }
		    (*pcntR)++; cntAll++;
		}
	    }
	    for (i = 0; i < writeCount; i++) {
		OBJ fd = __arrayVal(writeFdArray)[i];
		if ((__Class(fd) == @global(Win32SocketHandle)) && FD_ISSET(_HANDLEVal(fd), &writeFds)) {
		    if (*pcntW < resultSizeWritable) {
			__arrayVal(writableResultFdArray)[*pcntW] = fd;
			__STORE(writableResultFdArray, fd);
		    }
		    (*pcntW)++; cntAll++;
		}
	    }
	    for (i = 0; i < exceptCount; i++) {
		OBJ fd = __arrayVal(exceptFdArray)[i];
		if ((__Class(fd) == @global(Win32SocketHandle)) && FD_ISSET(_HANDLEVal(fd), &exceptFds)) {
		    if (*pcntE < resultSizeException) {
			__arrayVal(exceptionResultFdArray)[*pcntE] = fd;
			__STORE(exceptionResultFdArray, fd);
		    }
		    (*pcntE)++; cntAll++;
		}
	    }

	}
    }
    if (pass > 1)       // perform maximum 2 passes
	goto done;

    if (cntAll) {
	// check for other handles and return immediately, no timeout
	    t = 0;
    } else {
	if (__isSmallInteger(millis)) {
	    t = __intVal(millis);

	    if (t <= 0 && numHandles == 0) {
		RETURN (__mkSmallInteger(0));
	    }
	} else {
	    t = INFINITE;
	}
    }

    if (numHandles == 0 && t == 0) {
	// nothing to do and no wait
	goto done;
    }

#ifdef SELECT3DEBUGWIN32
	console_printf("wait numhandles = %d timeout = %d\n", numHandles, t);
#endif

    res = __vmWait(numHandles, hArray, MAXHANDLE, t);

	if (res == WAIT_TIMEOUT) {
#ifdef SELECT3DEBUGWIN32
	console_printf("- timeOut; ret nil\n" );
#endif
	if (t != 0 && (hasSockets || hasPipes)) {
	    // if not a single handle is ready, poll sockets an pipes again
	    pass = 2;
	    goto pollAgain;
	}
	    goto done;
	}

	if (res == WAIT_FAILED) {
#ifdef SELECT2DEBUGWIN32
	    console_printf("- error %d (last %d); ret -1\n", __threadErrno, GetLastError());
#endif
	    if (__threadErrno == EINTR) {
		@global(LastErrorNumber) = nil;
		RETURN (__mkSmallInteger(0));
	    } else {
		if (@global(InfoPrinting) == true) {
//                    console_fprintf(stderr, "Win32OS [info]: select errno = %d (last %d)\n", __threadErrno, GetLastError());
		    console_printf("Win32OS [info]: select errno = %d (last %d)\n", __threadErrno, GetLastError());
		}
		@global(LastErrorNumber) = __mkSmallInteger(EBADF);
		RETURN (__mkSmallInteger(-1));
	    }
	}

    if (numHandles) {
	    if (res == numHandles) {
		// vmwait() added an IRQ event to the handles, and this one has been triggered
		if (1 /* @global(InfoPrinting) == true */) {
		    console_fprintf(stderr, "Win32OS [info]: plugIn event has been handled\n");
		}
	    goto done;
	    }
	if ((res < 0) || (res >= numHandles)) {
#ifdef SELECTDEBUGWIN32	
	    console_printf("- res=%d error1 %d\n", res, GetLastError());
#endif	    
	    goto done;
	}

	idx = retArray[res];
	cntAll++;

#ifdef SELECTDEBUGWIN32
	console_printf("wait Handles res %d idx %d numHandles %d --- ", res, idx, numHandles);
#endif
	if (idx < 10000) {
	    if (*pcntR < resultSizeReadable) {
		OBJ temp = __arrayVal(readFdArray)[idx];
		__arrayVal(readableResultFdArray)[*pcntR] = temp;
		__STORE(readableResultFdArray, temp);
#ifdef SELECTDEBUGWIN32
		console_printf("read ready: %x\n", __externalAddressVal(temp));
#endif
		(*pcntR)++;
	    }
	} else if (idx < 20000) {
	    if (*pcntW < resultSizeWritable) {
		OBJ temp = __arrayVal(writeFdArray)[idx-10000];
		__arrayVal(writableResultFdArray)[*pcntW] = temp;
		__STORE(writableResultFdArray, temp);
#ifdef SELECTDEBUGWIN32
		console_printf("write ready: %x\n", temp);
#endif
		(*pcntW)++;
	    }
	} else {
	    if (*pcntE < resultSizeException) {
		OBJ temp = __arrayVal(exceptFdArray)[idx-20000];
		__arrayVal(exceptionResultFdArray)[*pcntE] = temp;
		__STORE(exceptionResultFdArray, temp);
#ifdef SELECTDEBUGWIN32
		console_printf("except ready: %x\n", temp);
#endif
		(*pcntE)++;
	    }
#ifdef SELECTDEBUGWIN32
	    else
		console_printf("cntE: %d, resultSizeException: %d\n", *pcntE, resultSizeException);
#endif
	}
    }
    if (t != 0 && (hasSockets || hasPipes)) {
	// back after timeout, maybe some sockets or pipes did wake up
	    // in the meantime?
	    pass = 2;
	    goto pollAgain;
    }

done:
    /* add a delimiter */
    if (*pcntR < resultSizeReadable) {
	__arrayVal(readableResultFdArray)[*pcntR] = nil;
    }
    if (*pcntW < resultSizeWritable) {
	__arrayVal(writableResultFdArray)[*pcntW] = nil;
    }
    if (*pcntE < resultSizeException) {
	__arrayVal(exceptionResultFdArray)[*pcntE] = nil;
    }

    @global(LastErrorNumber) = nil;
    RETURN (__mkSmallInteger(cntAll));

fail: ;
%}.
    "
     timeout argument not integer,
     or any fd-array nonNil and not an array
     or not supported by OS
    "
    ^ self primitiveFailed
!

setBlocking:aBoolean on:fd
    "set/clear the blocking attribute - if set (which is the default)
     a read on the fileDescriptor will block until data is available.
     If cleared, a read operation will immediately return with a value of
     nil.

     Ignored in windows. Windows calls operate in their own thread,
     so non-blocking mode doesn't make sense."

    ^ true
!

waitForMultipleObjects:fdOrHandleArray withTimeout:millis
    "wait for an fd to become ready.
     Timeout after t milliseconds or, if the timeout time is 0, immediately..
     Zero time can be used to poll a file-
     descriptors (i.e. to check if I/O possible without blocking).
     Return the fd if I/O ok, nil if timed-out or interrupted."

%{
#ifndef MAXHANDLE
# define MAXHANDLE 128
#endif
    INT t;
    int res;
    HANDLE hArray[MAXHANDLE];
    int idxArray[MAXHANDLE];
    INT i, count, hIdx;

    if (! __isArrayLike(fdOrHandleArray)) {
	goto fail;
    }
    count = __arraySize(fdOrHandleArray);

    for (hIdx=0, i=0; i<count; i++) {
	OBJ fdOrHandle = __ArrayInstPtr(fdOrHandleArray)->a_element[i];
	HANDLE h;

	if (fdOrHandle != nil) {
	    if (__isExternalAddressLike(fdOrHandle)) {
		h = _HANDLEVal(fdOrHandle);
	    } else {
		if (__isSmallInteger(fdOrHandle)) {
		    h = (HANDLE) _get_osfhandle (__intVal(fdOrHandle));
		} else {
		    goto fail;
		}
	    }
	    hArray[hIdx] = h;
	    idxArray[hIdx++] = i;
	}
    }

    if (__isSmallInteger(millis)) {
	t = __intVal(millis);
    } else {
	t = INFINITE;
    }

#ifdef DO_WRAP_CALLS
    if (t != 0) {
	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    res = STX_API_CALL4( "WaitForMultipleObjects", WaitForMultipleObjects, hIdx, hArray, FALSE, t);
	} while ((res < 0) && (__threadErrno == EINTR));
    } else
#endif
    {
	res = WaitForMultipleObjects(hIdx, hArray, FALSE, t);
	if (res < 0) {
	    __threadErrno = __WIN32_ERR(GetLastError());
	}
    }

    if (res == WAIT_FAILED) {
	RETURN (nil);
    }
    if (res == WAIT_TIMEOUT) {
	RETURN (nil);
    }
    if ((res >= WAIT_OBJECT_0) && (res < (WAIT_OBJECT_0+hIdx))) {
	RETURN (__arrayVal(fdOrHandleArray)[idxArray[res-WAIT_OBJECT_0]]);
    }

    RETURN (nil);
fail: ;
%}.
    "
     invalid arg,
    "
    ^ self primitiveFailed
!

waitForSingleObject:fdOrHandle withTimeout:millis
    "wait for an fd to become ready.
     Timeout after t milliseconds or, if the timeout time is 0, immediately..
     Zero time can be used to poll a file-
     descriptors (i.e. to check if I/O possible without blocking).
     Return the fd if I/O ok, nil if timed-out or interrupted."

%{
    INT t;
    int res;
    HANDLE h = NULL;

    if (__isExternalAddressLike(fdOrHandle)) {
	h = _HANDLEVal(fdOrHandle);
    } else {
	if (__isSmallInteger(fdOrHandle)) {
	    h = (HANDLE) _get_osfhandle (__intVal(fdOrHandle));
	} else {
	    goto fail;
	}
    }

    if (__isSmallInteger(millis)) {
	t = __intVal(millis);
    } else {
	t = INFINITE;
    }

#ifdef DO_WRAP_CALLS
    do {
	__threadErrno = 0;
	// do not cast to INT - will loose sign bit then!
	res = STX_API_CALL2( "WaitForSingleObject", WaitForSingleObject, h,  t);
    } while ((res < 0) && (__threadErrno == EINTR));
#else
    res = WaitForSingleObject(h, t);
    if (res < 0) {
	__threadErrno = __WIN32_ERR(GetLastError());
    }
#endif
    if (res == WAIT_FAILED) {
	RETURN (nil);
    }
    if (res == WAIT_TIMEOUT) {
	RETURN (nil);
    }

    RETURN (fdOrHandle);
fail: ;
%}.
    "
     invalid arg,
    "
    ^ self primitiveFailed
! !

!Win32OperatingSystem::DevModeStructure methodsFor:'accessing'!

bitsPerPel
    ^ self unsignedLongAt: 1+104

    "Created: / 27-07-2006 / 15:14:17 / fm"
!

collate
    ^ self signedInt16At: 1+68 MSB: UninterpretedBytes isBigEndian

    "Created: / 01-08-2006 / 09:56:38 / fm"
!

collate: n
    ^ self signedInt16At: 1+68 put: n MSB: UninterpretedBytes isBigEndian

    "Created: / 01-08-2006 / 09:58:07 / fm"
!

color
    ^ self signedInt16At: 1+60 MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:31:25 / fm"
!

copies
    ^ self signedInt16At: 1+54 MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:30:52 / fm"
!

copies: n
    ^ self signedInt16At: 1+54 put: n MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:36:39 / fm"
!

deviceName
    ^ self stringAt: 1+0 size: 32

    "Created: / 27-07-2006 / 15:15:52 / fm"
!

orientation
    ^ self signedInt16At: 1+44 MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:34:57 / fm"
!

orientation: orientationInt
    ^ self signedInt16At: 1+44 put: orientationInt MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:36:31 / fm"
!

paperLength
    ^ self signedInt16At: 1+48 MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:32:59 / fm"
!

paperSize
    ^ self signedInt16At: 1+46 MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:32:12 / fm"
!

paperSize:funnyMSPaperSizeCode
    ^ self signedInt16At: 1+46 put: funnyMSPaperSizeCode MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:35:53 / fm"
!

paperWidth
    ^ self signedInt16At: 1+50 MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:32:25 / fm"
!

printQuality
    ^ self signedInt16At: 1+58 MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:33:58 / fm"
!

printQuality: qualityInteger
    ^ self signedInt16At: 1+58 put: qualityInteger MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:36:20 / fm"
!

scale
    ^ self signedInt16At: 1+52 MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:33:31 / fm"
!

scale: percent
    ^ self signedInt16At: 1+52 put: percent MSB: UninterpretedBytes isBigEndian

    "Created: / 27-07-2006 / 15:36:05 / fm"
! !

!Win32OperatingSystem::DocInfoStructure class methodsFor:'instance creation'!

new

^super new: self sizeInBytes

    "Created: / 02-08-2006 / 16:21:01 / fm"
!

sizeInBytes

^20

    "Created: / 02-08-2006 / 16:21:10 / fm"
! !

!Win32OperatingSystem::DocInfoStructure methodsFor:'accessing'!

cbSize

^self longAt: 0+1

    "Created: / 28-07-2006 / 18:36:02 / fm"
!

cbSize: aValue

self longAt: 0+1 put: aValue

    "Created: / 28-07-2006 / 18:37:25 / fm"
!

fwType

^self longAt: 16+1

    "Created: / 28-07-2006 / 18:37:44 / fm"
!

fwType: aValue
"Set a DWORD fwType"

self longAt: 16+1 put:aValue

    "Created: / 28-07-2006 / 18:38:17 / fm"
!

lpszDocName

^(ExternalBytes address:(self unsignedLongAt: 4+1)) stringAt:1

    "Created: / 03-08-2006 / 15:06:56 / fm"
!

lpszDocName: aValue

^self unsignedLongAt: 4+1 put: aValue

    "Created: / 03-08-2006 / 15:08:32 / fm"
!

lpszOutput

^(ExternalBytes address:(self unsignedLongAt: 8+1)) stringAt:1

    "Created: / 03-08-2006 / 15:07:52 / fm"
!

lpszOutput: aValue

^self unsignedLongAt: 8+1 put: aValue

    "Created: / 03-08-2006 / 15:08:49 / fm"
! !

!Win32OperatingSystem::FileStatusInfo class methodsFor:'instance creation'!

type:t mode:m uid:u gid:g size:s id:i accessed:aT modified:mT created:cT sourcePath:lP fullName:fullName alternativeName:name2
    ^ self basicNew
	type:t mode:m uid:u gid:g size:s
	id:i accessed:aT modified:mT created:cT
	sourcePath:lP
	fullName:fullName
	alternativeName:name2
! !

!Win32OperatingSystem::FileStatusInfo methodsFor:'accessing'!

accessTime
    "return accessed"

    ^ accessed

    "Created: / 1.2.2002 / 11:05:49 / cg"
!

alternativeName
    "return the files other name (DOS name on windows).
     Nil if there is no other name"

    |path idx|

    path := self alternativePathName.
    path notNil ifTrue:[
	idx := path lastIndexOf:$\ startingAt:path size-1.
	idx ~~ 0 ifTrue:[
	    path := path copyFrom:(idx+1).
	].
    ].

    ^ path

    "
	'C:\' asFilename info alternativeName
	'C:\Dokumente und Einstellungen\' asFilename info alternativeName
	'C:\Dokumente und Einstellungen' asFilename info alternativeName
    "
!

alternativePathName
    "return the files real name (non-DOS name on windows).
     Nil if there is no other name"

    "/ access lazily...
    alternativePathName isNil ifTrue:[
	alternativePathName := (OperatingSystem getShortPathName:sourcePath) asSingleByteString.
    ].

    ^ alternativePathName

    "
	'C:\' asFilename info alternativePathName
	'C:\Dokumente und Einstellungen' asFilename info alternativePathName
    "
!

creationTime
    ^ created
!

fileSize
    "return size"

    ^ size

    "Created: / 1.2.2002 / 11:06:15 / cg"
!

fullName
    "return the files real name (non-DOS name on windows).
     Nil if there is no other name"

    |path idx|

    path := self fullPathName.
    path notNil ifTrue:[
	idx := path lastIndexOf:$\ startingAt:path size-1.
	idx ~~ 0 ifTrue:[
	    path := path copyFrom:(idx+1).
	].
    ].

    ^ path

    "
	'\' asFilename info fullName
	'C:\' asFilename info fullName
	'C:\Dokumente und Einstellungen' asFilename info fullName
    "
!

fullPathName
    "return the files real name (non-DOS name on windows).
     Nil if there is no other name"

    "/ access lazily...
    fullPathName isNil ifTrue:[
	fullPathName := OperatingSystem getLongPathName:sourcePath.
    ].

    ^ fullPathName

    "
	'C:\' asFilename info fullPathName
	'C:\Dokumente und Einstellungen' asFilename info fullPathName
    "
!

gid
    "return gid"

    ^ gid
!

id
    "return id"

    ^ id
!

linkTargetPath
    "for symbolic links only: return the path where the symbolic link points to"

    "/ access lazily...
    linkTargetPath isNil ifTrue:[
	type == #symbolicLink ifTrue:[
	    linkTargetPath := OperatingSystem getLinkTarget:sourcePath.
	]
    ].

    ^ linkTargetPath

    "Modified: / 07-02-2007 / 10:31:56 / cg"
!

mode
    "return mode"

    ^ mode
!

modificationTime
    "return modified"

    ^ modified

    "Created: / 1.2.2002 / 11:06:33 / cg"
!

numLinks
    "DOS has no hardLinks - return 1"

    ^ 1

    "Created: / 1.2.2002 / 11:07:04 / cg"
!

path
    "for symbolic links only: return the path where the symbolic link points to.
     bad named method - left here for backward compatibility"

    ^ self linkTargetPath.
!

size
    "return size"

    ^ size
!

sourcePath
    ^ sourcePath
!

statusChangeTime
    "return statusChanged"

    ^ statusChanged ? modified

    "Created: / 1.2.2002 / 11:07:27 / cg"
!

type
    "return type"

    ^ type
!

uid
    "return uid"

    ^ uid
! !

!Win32OperatingSystem::FileStatusInfo methodsFor:'accessing-vms'!

fixedHeaderSize
    "return the fixedHeaderSize (VMS only; nil everywhere else)"

    ^ nil
!

recordAttributes
    "return the recordAttributes (VMS only; nil everywhere else)"

    ^ nil
!

recordFormat
    "return the recordFormat (VMS only; nil everywhere else)"

    ^ nil
!

recordFormatNumeric
    "return the recordFormat as numeric (VMS only; nil everywhere else)"

    ^ nil
!

recordSize
    "return the recordSize (VMS only; nil everywhere else)"

    ^ nil
! !

!Win32OperatingSystem::FileStatusInfo methodsFor:'backward compatibility'!

accessed
    "return accessed"

    <resource: #obsolete>

    self obsoleteMethodWarning:'use #accessTime'.
    ^ accessed
!

at:key
    "backward compatibility access: in previous releases, IdentityDictionaries
     were used to hold my information. Allow access via key messages.
     This method will vanish - use the proper access protocol."

    ^ self perform:key
!

modified
    <resource: #obsolete>

    self obsoleteMethodWarning:'use #modificationTime'.
    ^ modified
!

statusChanged
    <resource: #obsolete>

    self obsoleteMethodWarning:'use #statusChangeTime'.
    ^ statusChanged
! !

!Win32OperatingSystem::FileStatusInfo methodsFor:'private accessing'!

type:t mode:m uid:u gid:g size:s id:i accessed:aT modified:mT created:cT sourcePath:lP fullName:name1 alternativeName:name2
    type := t.
    mode := m.
    uid := u.
    gid := g.
    size := s.
    id := i.
    accessed := aT.
    modified := mT.
    created := cT.
    sourcePath := lP.
    fullPathName := name1.
    alternativePathName := name2.
! !

!Win32OperatingSystem::FileStatusInfo methodsFor:'queries-access'!

isGroupExecutable
    ^ mode bitTest:8r10

    "
      'smalltalk.rc' asFilename info isGroupExecutable
    "
!

isGroupReadable
    ^ mode bitTest:8r40

    "
      'smalltalk.rc' asFilename info isGroupReadable
    "
!

isGroupWritable
    ^ mode bitTest:8r20

    "
      'smalltalk.rc' asFilename info isGroupWritable
    "
!

isOwnerExecutable
    ^ mode bitTest:8r100

    "
      'smalltalk.rc' asFilename info isOwnerExecutable
    "
!

isOwnerReadable
    ^ mode bitTest:8r400

    "
      'smalltalk.rc' asFilename info isOwnerReadable
    "
!

isOwnerWritable
    ^ mode bitTest:8r200

    "
      'smalltalk.rc' asFilename info isOwnerWritable
    "
!

isWorldExecutable
    ^ mode bitTest:8r1

    "
      'smalltalk.rc' asFilename info isWorldExecutable
    "
!

isWorldReadable
    ^ mode bitTest:8r4

    "
      'smalltalk.rc' asFilename info isWorldReadable
    "
!

isWorldWritable
    ^ mode bitTest:8r2

    "
      'smalltalk.rc' asFilename info isWorldWritable
    "
! !

!Win32OperatingSystem::FileStatusInfo methodsFor:'queries-type'!

isBlockSpecial
    ^ type == #characterSpecial
!

isCharacterSpecial
    ^ type == #characterSpecial
!

isDirectory
    ^ type == #directory
!

isFifo
    ^ type == #fifo
!

isRegular
    ^ type == #regular
!

isSocket
    ^ type == #socket
!

isSpecialFile
    ^ (type ~~ #directory
	and:[type ~~ #remoteDirectory
	and:[type ~~ #regular
	and:[type ~~ #symbolicLink
    ]]])
!

isSymbolicLink
    ^ type == #symbolicLink
!

isUnknown
    ^ type == #unknown
!

isValid
    "answer true if the fileInfo is valid"
    ^ type notNil
! !

!Win32OperatingSystem::OSProcessDescriptor methodsFor:'accessing'!

commandLine
    ^ commandLine
!

commandLine:something
    commandLine := something.
!

parentPid
    ^ parentPid
!

parentPid:something
    parentPid := something.
!

pid
    ^ pid
!

pid:something
    pid := something.
! !

!Win32OperatingSystem::OSProcessStatus class methodsFor:'documentation'!

documentation
"
    This is an auxillary class, that holds information about status changes of
    operating system processes (these are no smalltalk processes!!).

    [Instance variables:]

	pid     <Integer>       OS-Process identifier

	status  <Symbol>        either #exit #signal #stop #continue

	code    <Integer>       either exitcode or signalnumber

	core    <Boolean>       true if core has been dumped


    [author:]
	Stefan Vogel

    [see also:]
	OperatingSystem
"
! !

!Win32OperatingSystem::OSProcessStatus class methodsFor:'instance creation'!

pid:pid status:status code:code core:core
    "private interface for Win32OperatingSystem"

    ^ self new pid:pid status:status code:code core:core

    "Created: 28.12.1995 / 14:16:14 / stefan"
    "Modified: 30.4.1996 / 18:25:00 / cg"
!

processCreationFailure
    "private interface for Win32OperatingSystem"

    ^ self new pid:-1 status:#failure code:-1 core:false

    "Created: 28.12.1995 / 14:35:29 / stefan"
    "Modified: 30.4.1996 / 18:25:05 / cg"
! !

!Win32OperatingSystem::OSProcessStatus methodsFor:'accessing'!

code
    "return the exitcode / signalNumber"

    ^ code

    "Created: 28.12.1995 / 14:05:07 / stefan"
    "Modified: 30.4.1996 / 18:26:23 / cg"
!

core
    "return true if core has been dumped, false otherwise"

    ^ core == true

    "Modified: 28.12.1995 / 14:14:38 / stefan"
!

pid
    "return the pid"

    ^ pid

    "Created: 28.12.1995 / 14:05:07 / stefan"
    "Modified: 30.4.1996 / 18:26:30 / cg"
!

status
    "return status as a Symbol;
     one of #exit #signal #stop #continue"

    ^ status

    "Created: 28.12.1995 / 14:05:07 / stefan"
    "Modified: 30.4.1996 / 18:26:54 / cg"
! !

!Win32OperatingSystem::OSProcessStatus methodsFor:'initialization'!

pid:newPid status:newStatus code:newCode core:newCore
    pid := newPid.
    status := newStatus.
    code := newCode.
    core := newCore.

    "Created: 28.12.1995 / 14:18:22 / stefan"
! !

!Win32OperatingSystem::OSProcessStatus methodsFor:'private-OS interface'!

code:something
    "set the exitCode"

    code := something.

    "Created: 28.12.1995 / 14:05:07 / stefan"
    "Modified: 30.4.1996 / 18:25:18 / cg"
!

core:something
    "set core"

    core := something.

    "Created: 28.12.1995 / 14:05:07 / stefan"
!

pid:something
    "set pid"

    pid := something.

    "Created: 28.12.1995 / 14:05:07 / stefan"
!

status:something
    "set status"

    status := something.

    "Created: 28.12.1995 / 14:05:07 / stefan"
! !

!Win32OperatingSystem::OSProcessStatus methodsFor:'queries'!

couldNotExecute
    "return true when a command could not be executed"

    ^ status == #failure or:[status == #exit and:[code = 127]].

    "Created: 28.12.1995 / 15:43:17 / stefan"
    "Modified: 30.4.1996 / 18:27:03 / cg"
!

isError
    "true if process terminated with error"

    ^ status == #exit and:[code ~= 0]
!

stillAlive
    "true if process is still alive"

    ^ status == #stop or:[status == #continue]

    "Created: 28.12.1995 / 14:27:26 / stefan"
!

success
    "true if process terminated successfully"

    ^ status == #exit and:[code = 0]

    "Created: 28.12.1995 / 14:13:05 / stefan"
    "Modified: 28.12.1995 / 14:13:41 / stefan"
! !

!Win32OperatingSystem::PECOFFConstants class methodsFor:'documentation'!

documentation
"
    COFF machine type IDs.

    [author:]
	Jan Vrany

    [instance variables:]

    [class variables:]

    [see also:]
	Microsoft Portable Executable and Common Object File Format Specification,
	section 6. Machine Types

"
! !

!Win32OperatingSystem::PECOFFConstants class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ See Microsoft Portable Executable and Common Object File Format Specification,
    "/ section 4

    PE_Signature_OFFSET_OFFSET := 16r3C.
    PE_Signature := #[80 69 0 0].

    "/ See Microsoft Portable Executable and Common Object File Format Specification,
    "/ section 5

    COFF_HEADER_SIZE := 20.
    COFF_HEADER_Machine_OFFSET := 0.

    "/ See Microsoft Portable Executable and Common Object File Format Specification,
    "/ section 6

    IMAGE_FILE_MACHINE_UNKNOWN := 16r0.
    IMAGE_FILE_MACHINE_AM33 := 16r1D3.
    IMAGE_FILE_MACHINE_AMD64 := 16r8664.
    IMAGE_FILE_MACHINE_ARM := 16r1C0.
    IMAGE_FILE_MACHINE_ARMNT := 16r1C4.
    IMAGE_FILE_MACHINE_ARM64 := 16rAA64.
    IMAGE_FILE_MACHINE_EBC := 16rEBC.
    IMAGE_FILE_MACHINE_I386 := 16r14C.
    IMAGE_FILE_MACHINE_IA64 := 16r200.
    IMAGE_FILE_MACHINE_M32R := 16r9041.
    IMAGE_FILE_MACHINE_MIPS16 := 16r266.
    IMAGE_FILE_MACHINE_MIPSFPU := 16r366.
    IMAGE_FILE_MACHINE_MIPSFPU16 := 16r466.
    IMAGE_FILE_MACHINE_POWERPC := 16r1F0.
    IMAGE_FILE_MACHINE_POWEPCFP := 16r1F1.
    IMAGE_FILE_MACHINE_R4000 := 16r166.
    IMAGE_FILE_MACHINE_SH3 := 16r1A2.
    IMAGE_FILE_MACHINE_SH3DSP := 16r1A3.
    IMAGE_FILE_MACHINE_SH4 := 16r1A6.
    IMAGE_FILE_MACHINE_SH5 := 16r1A8.
    IMAGE_FILE_MACHINE_THUMB := 16r1C2.
    IMAGE_FILE_MACHINE_WCEMIPSV2 := 16r169.

    "Modified: / 16-03-2015 / 13:34:57 / jv"
    "Modified: / 16-03-2015 / 18:14:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Win32OperatingSystem::PECOFFFileHeader class methodsFor:'documentation'!

documentation
"
    Inteances of COFFFileHeader provides an access to various
    information about executables / .dlls on Windows

    [author:]
	Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
	Microsoft Portable Executable and Common Object File Format Specification

"
! !

!Win32OperatingSystem::PECOFFFileHeader class methodsFor:'instance creation'!

fromFile: aStringOrFilename
    "Returns a COFFFileHeader of given file.
     If the given file is not a regular file or
     of it's not an PE file them an error is thrown."

    ^ self new initializeOnFile: aStringOrFilename

    "Created: / 16-03-2015 / 14:33:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Win32OperatingSystem::PECOFFFileHeader methodsFor:'accessing'!

machine
   ^ data unsignedInt16At: COFF_HEADER_Machine_OFFSET + 1 MSB: false

    "Created: / 16-03-2015 / 14:29:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Win32OperatingSystem::PECOFFFileHeader methodsFor:'initialization'!

initializeOnFile: aStringOrFilename
    file := aStringOrFilename asFilename.
    file exists ifFalse:[
	self error:'Given file does not exist'.
	^ nil
    ].
    file isRegularFile ifFalse:[
	self error:'Given file is not a regular file'.
	^ nil
    ].
    file readingFileDo:[ :s |
	| sig |
	s binary.
	s position: PE_Signature_OFFSET_OFFSET.
	s position: (s nextUnsignedLongMSB: false).
	sig := s next: PE_Signature size.
	sig = PE_Signature ifFalse:[
	    self error: 'Given file is not a valid PE file (no valid PE signature found)'.
	    ^ nil
	].
	data := s next: COFF_HEADER_SIZE
    ].

    "Created: / 16-03-2015 / 14:34:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Win32OperatingSystem::PECOFFFileHeader methodsFor:'queries'!

isFor32BitArchitecture
    ^ { IMAGE_FILE_MACHINE_I386 . IMAGE_FILE_MACHINE_ARM . IMAGE_FILE_MACHINE_ARMNT } includes: self machine

    "Created: / 18-03-2015 / 09:54:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFor64BitArchitecture
    ^ { IMAGE_FILE_MACHINE_AMD64 . IMAGE_FILE_MACHINE_IA64 . IMAGE_FILE_MACHINE_ARM64 } includes: self machine

    "Created: / 18-03-2015 / 09:57:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Win32OperatingSystem::PerformanceData class methodsFor:'accessing'!

counterIndexTextDictionary

    "
	self counterIndexTextDictionary
    "

    CounterIndexTextDictionary isNil ifTrue:[
	self synchronized:[
	    CounterIndexTextDictionary isNil ifTrue:[
		|performanceText counterIndexTextDictionary|

		performanceText := self getPerformanceText valueNamed:'Counter'.
		counterIndexTextDictionary := IdentityDictionary new.

		1 to:performanceText size by:2 do:[:index|
		    counterIndexTextDictionary at:(performanceText at:index) asInteger put:(performanceText at:index + 1).
		].

		CounterIndexTextDictionary := counterIndexTextDictionary.
	    ].
	].
    ].

    ^ CounterIndexTextDictionary
!

helpIndexTextDictionary

    "
	self helpIndexTextDictionary
    "

    HelpIndexTextDictionary isNil ifTrue:[
	self synchronized:[
	    HelpIndexTextDictionary isNil ifTrue:[
		|performanceText helpIndexTextDictionary|

		performanceText := self getPerformanceText valueNamed:'Help'.
		helpIndexTextDictionary := IdentityDictionary new.

		1 to:performanceText size by:2 do:[:index|
		    helpIndexTextDictionary at:(performanceText at:index) asInteger put:(performanceText at:index + 1).
		].

		HelpIndexTextDictionary := helpIndexTextDictionary.
	    ].
	].
    ].

    ^ HelpIndexTextDictionary
! !

!Win32OperatingSystem::PerformanceData class methodsFor:'accessing subclasses'!

diskIO
    ^ DiskIO current
!

global
    ^ Global current
!

memory
    ^ Memory current
!

network
    ^ Network current
!

process
    ^ Process current
!

processor
    ^ Processor current
! !

!Win32OperatingSystem::PerformanceData class methodsFor:'documentation'!

documentation

    "
	VISTA:

	Wer versucht unter Vista die Registy HKEY_PERFORMANCE_DATA abzufragen wird zunächst enttäuscht.
	Die UAC UserAccessControl verhindern dies nämlich (selbs für den admin).

	Um dies zu umgehen:

	To turn off UAC

	1. Click Start, and then click Control Panel.
	2. In Control Panel, click User Accounts.
	3. In the User Accounts window, click User Accounts.
	4. In the User Accounts tasks window, click Turn User Account Control on or off.
	5. If UAC is currently configured in Admin Approval Mode, the User Account Control message appears. Click Continue.
	6. Clear the Use User Account Control (UAC) to help protect your computer check box, and then click OK.
	7. Click Restart Now to apply the change right away, or click Restart Later and close the User Accounts tasks window.
    "
!

examples

    "
	######################################### PRIMITIVE
	self getUsedMemoryInPercentage.

	self getPhysicalMemoryInKB.
	self getPhysicalMemoryInMB.

	self getFreePhysicalMemoryInKB.
	self getFreePhysicalMemoryInMB.

	self getPageFileSizeInKB.
	self getPageFileSizeInMB.

	self getFreePageFileSizeInKB.
	self getFreePageFileSizeInMB.

	self getVirtualMemoryInKB.
	self getVirtualMemoryInMB.

	######################################### REGISTRY
	self helpIndexTextDictionary
	self counterIndexTextDictionary

	self global getCounterNameIndexArray.
	self global getObjectNameIndexArray.

	self processor getCounterNameIndexArray.
	self processor processorUsage.
	self processor processorUsageFromLast.
	self processor interruptsPerSecond.
	self processor interruptsPerSecondFromLast.

	self process getCounterNameIndexArray.
	self process processUsage.
	self process processUsageFromLast.
	self process runningProcesses.
	self process runningProcessNameList.

	self network getCounterNameIndexArray.
	self network kBytesReceivedPerSecond.
	self network kBytesReceivedPerSecondFromLast.
	self network kBytesSentPerSecond.
	self network kBytesSentPerSecondFromLast.

	self memory getCounterNameIndexArray.
	self memory availableMBytes.
	self memory availableKBytes.

	self diskIO getCounterNameIndexArray.
	self diskIO diskSpaceFreeInMegaByte.
	self diskIO diskQueueLength.
	self diskIO diskTransfersPerSecond.
	self diskIO diskTransfersPerSecondFromlast.
	self diskIO diskReadsPerSecond.
	self diskIO diskReadsPerSecondFromLast.
	self diskIO diskWritesPerSecond.
	self diskIO diskWritesPerSecondFromLast.
	self diskIO diskBytesPerSecond.
	self diskIO diskBytesPerSecondFromLast.
    "
! !

!Win32OperatingSystem::PerformanceData class methodsFor:'initialization'!

initialize

    "
	self initialize
    "

    PerformanceText := CounterIndexTextDictionary := HelpIndexTextDictionary := nil.
! !

!Win32OperatingSystem::PerformanceData class methodsFor:'private'!

getPerformanceText

    PerformanceText isNil ifTrue:[
	PerformanceText := Win32OperatingSystem registryEntry key:'HKEY_PERFORMANCE_TEXT'.
    ].

    ^ PerformanceText
! !

!Win32OperatingSystem::PerformanceData class methodsFor:'queries - memory'!

getFreePageFileSizeInKB
    |ret|

    %{
	MEMORYSTATUS mState;
	GlobalMemoryStatus (&mState);

	ret = __mkSmallInteger(mState.dwAvailPageFile / 1024);
    %}.

    ^ ret

    "
	self getFreePageFileSizeInKB
    "
!

getFreePageFileSizeInMB
    ^ (self getFreePageFileSizeInKB / 1024) asInteger

    "
	self getFreePageFileSizeInMB
    "
!

getFreePhysicalMemoryInKB
    |ret|

    %{
	MEMORYSTATUS mState;
	GlobalMemoryStatus (&mState);

	ret = __mkSmallInteger(mState.dwAvailPhys / 1024);
    %}.

    ^ ret

    "
	self getFreePhysicalMemoryInKB
    "
!

getFreePhysicalMemoryInMB
    ^ (self getFreePhysicalMemoryInKB / 1024) asInteger

    "
	self getFreePhysicalMemoryInMB
    "
!

getPageFileSizeInKB
    ^ self getPageFileSizeInMB * 1024

    "
	self getPageFileSizeInKB
    "
!

getPageFileSizeInMB
    |ret|

    %{
	SYSTEM_INFO sInfo;
	GetSystemInfo(&sInfo);

	ret = __mkSmallInteger(sInfo.dwPageSize);
    %}.

    ^ ret

    "
	self getPageFileSizeInMB
    "
!

getPhysicalMemoryInKB
    |ret|

    %{
	MEMORYSTATUS mState;
	GlobalMemoryStatus (&mState);

	ret = __mkSmallInteger(mState.dwTotalPhys / 1024);
    %}.

    ^ ret

    "
	self getPhysicalMemoryInKB
    "
!

getPhysicalMemoryInMB
    ^ (self getPhysicalMemoryInKB / 1024) asInteger

    "
	self getPhysicalMemoryInMB
    "
!

getUsedMemoryInPercentage
    |ret|

    %{
	MEMORYSTATUS mState;
	GlobalMemoryStatus (&mState);

	ret = __mkSmallInteger(mState.dwMemoryLoad);
    %}.

    ^ ret

    "
	self getUsedMemoryInPercentage
    "
!

getVirtualMemoryInKB
    |ret|

    %{
	MEMORYSTATUS mState;
	GlobalMemoryStatus (&mState);

	ret = __mkSmallInteger(mState.dwTotalVirtual / 1024);
    %}.

    ^ ret

    "
	self getVirtualMemoryInKB
    "
!

getVirtualMemoryInMB
    ^ (self getVirtualMemoryInKB / 1024) asInteger

    "
	self getVirtualMemoryInMB
    "
! !

!Win32OperatingSystem::PerformanceData methodsFor:'accessing'!

objectArray
    ^ objectArray
!

perfFreq
    ^ perfFreq
!

perfTime
    ^ perfTime
!

perfTime100nSec
    ^ perfTime100nSec
! !

!Win32OperatingSystem::PerformanceData methodsFor:'setup'!

fromRawBytes:st_data
    |
    getNameBlock getCounterValueBlock
    st_perfTime st_perfFreq st_perfTime100nSec
    st_objectArray st_counterArray st_instanceArray
    st_perObject st_perCounter st_perInstance
    |

%{
    //declarate counters
    int objectIterator, counterIterator, instanceIterator, numObjectTypes;

    //declarate pointers
    PERF_DATA_BLOCK *perfData;
    PERF_OBJECT_TYPE *perfObjectPtr;
    PERF_COUNTER_DEFINITION *perfCounterPtr;
    PERF_INSTANCE_DEFINITION *perfInstancePtr;
    PERF_COUNTER_BLOCK *perfCounterBlockPtr;

    #define PERF_SIZE_MASK        (PERF_SIZE_DWORD|PERF_SIZE_LARGE|PERF_SIZE_ZERO|PERF_SIZE_VARIABLE_LEN)
    #define PERF_TYPE_MASK        (PERF_TYPE_NUMBER|PERF_TYPE_COUNTER|PERF_TYPE_TEXT|PERF_TYPE_ZERO)
    #define PERF_NUMBERTYPE_MASK  (PERF_NUMBER_HEX|PERF_NUMBER_DECIMAL|PERF_NUMBER_DEC_1000)
#ifdef PERF_COUNTER_PRECISION
    #define PERF_COUNTERTYPE_MASK (PERF_COUNTER_VALUE|PERF_COUNTER_RATE|PERF_COUNTER_FRACTION|PERF_COUNTER_BASE|PERF_COUNTER_ELAPSED|PERF_COUNTER_QUEUELEN|PERF_COUNTER_HISTOGRAM|PERF_COUNTER_PRECISION)
#else
    #define PERF_COUNTERTYPE_MASK (PERF_COUNTER_VALUE|PERF_COUNTER_RATE|PERF_COUNTER_FRACTION|PERF_COUNTER_BASE|PERF_COUNTER_ELAPSED|PERF_COUNTER_QUEUELEN|PERF_COUNTER_HISTOGRAM)
#endif
    #define PERF_TEXTTYPE_MASK    (PERF_TEXT_UNICODE|PERF_TEXT_ASCII)

    if (!__isByteArray(st_data)) RETURN (nil);

    //setup start pointer
    perfData = (PERF_DATA_BLOCK *)(__ByteArrayInstPtr(st_data)->ba_element);

    //get header data
    st_perfTime = __MKINT64(&(perfData->PerfTime));
    st_perfFreq = __MKINT64(&(perfData->PerfFreq));
    st_perfTime100nSec = __MKINT64(&(perfData->PerfTime100nSec));

    //setup object array and initialize its pointer
    numObjectTypes = perfData->NumObjectTypes;
    st_objectArray = __ARRAY_NEW_INT(numObjectTypes);
    perfObjectPtr = (PERF_OBJECT_TYPE *)((char *)perfData + perfData->HeaderLength);

    //iterate all following objetcs
    for (objectIterator=0; objectIterator<numObjectTypes; objectIterator++) {
	//add the st_perObject dictionary to st_objectArray
	st_perObject = __SSEND0(@global(Dictionary), @symbol(new), 0);
	__AT_PUT_(st_objectArray, __mkSmallInteger(objectIterator+1), st_perObject);

	//get the object data
	__AT_PUT_(st_perObject, @symbol(ObjectNameTitleIndex), __mkSmallInteger(perfObjectPtr->ObjectNameTitleIndex));
	__AT_PUT_(st_perObject, @symbol(DetailLevel), __mkSmallInteger(perfObjectPtr->DetailLevel));
	__AT_PUT_(st_perObject, @symbol(NumCounters), __mkSmallInteger(perfObjectPtr->NumCounters));
	__AT_PUT_(st_perObject, @symbol(NumInstances), __mkSmallInteger(perfObjectPtr->NumInstances));

	//setup counter array and initialize its pointer
	st_counterArray = __ARRAY_NEW_INT(perfObjectPtr->NumCounters);
	perfCounterPtr = (PERF_COUNTER_DEFINITION *)((char *)perfObjectPtr + perfObjectPtr->HeaderLength);

	//add the st_counterArray to st_perObject dictionary
	__AT_PUT_(st_perObject, @symbol(Counters), st_counterArray);

	//iterate all following counter definition
	for (counterIterator=0; counterIterator<perfObjectPtr->NumCounters; counterIterator++) {
	    //add the st_perCounter dictionary to st_counterArray
	    st_perCounter = __SSEND0(@global(Dictionary), @symbol(new), 0);
	    __AT_PUT_(st_counterArray, __mkSmallInteger(counterIterator+1), st_perCounter);

	    //get the counter data
	    __AT_PUT_(st_perCounter, @symbol(CounterNameTitleIndex), __mkSmallInteger(perfCounterPtr->CounterNameTitleIndex));
	    __AT_PUT_(st_perCounter, @symbol(CounterTypeBits), __mkSmallInteger(perfCounterPtr->CounterType));
	    __AT_PUT_(st_perCounter, @symbol(CounterSize), __mkSmallInteger(perfCounterPtr->CounterSize));
	    __AT_PUT_(st_perCounter, @symbol(CounterOffset), __mkSmallInteger(perfCounterPtr->CounterOffset));

	    //put the counter type size
	    switch (perfCounterPtr->CounterType & PERF_SIZE_MASK) {
		case PERF_SIZE_DWORD:
		    __AT_PUT_(st_perCounter, @symbol(SIZE),@symbol(DWORD));
		    break;
		case PERF_SIZE_LARGE:
		    __AT_PUT_(st_perCounter, @symbol(SIZE),@symbol(LARGE));
		    break;
		case PERF_SIZE_ZERO:
		    __AT_PUT_(st_perCounter, @symbol(SIZE),@symbol(ZERO));
		    break;
		case PERF_SIZE_VARIABLE_LEN:
		    __AT_PUT_(st_perCounter, @symbol(SIZE),@symbol(VARIABLE_LEN));
		    break;
	    }
	    switch (perfCounterPtr->CounterType & PERF_TYPE_MASK) {
		case PERF_TYPE_NUMBER:
		    __AT_PUT_(st_perCounter, @symbol(TYPE),@symbol(NUMBER));
		    switch (perfCounterPtr->CounterType & PERF_NUMBERTYPE_MASK) {
			case PERF_NUMBER_HEX:
			    __AT_PUT_(st_perCounter, @symbol(NUMBER),@symbol(HEX));
			    break;
			case PERF_NUMBER_DECIMAL:
			    __AT_PUT_(st_perCounter, @symbol(NUMBER),@symbol(DECIMAL));
			    break;
			case PERF_NUMBER_DEC_1000:
			    __AT_PUT_(st_perCounter, @symbol(NUMBER),@symbol(DEC_1000));
			    break;
		    }
		    break;
		case PERF_TYPE_COUNTER:
		    __AT_PUT_(st_perCounter, @symbol(TYPE),@symbol(COUNTER));
		    switch (perfCounterPtr->CounterType & PERF_COUNTERTYPE_MASK) {
			case PERF_COUNTER_VALUE:
			    __AT_PUT_(st_perCounter, @symbol(COUNTER),@symbol(VALUE));
			    break;
			case PERF_COUNTER_RATE:
			    __AT_PUT_(st_perCounter, @symbol(COUNTER),@symbol(RATE));
			    break;
			case PERF_COUNTER_FRACTION:
			    __AT_PUT_(st_perCounter, @symbol(COUNTER),@symbol(FRACTION));
			    break;
			case PERF_COUNTER_BASE:
			    __AT_PUT_(st_perCounter, @symbol(COUNTER),@symbol(BASE));
			    break;
			case PERF_COUNTER_ELAPSED:
			    __AT_PUT_(st_perCounter, @symbol(COUNTER),@symbol(ELAPSED));
			    break;
			case PERF_COUNTER_QUEUELEN:
			    __AT_PUT_(st_perCounter, @symbol(COUNTER),@symbol(QUEUELEN));
			    break;
			case PERF_COUNTER_HISTOGRAM:
			    __AT_PUT_(st_perCounter, @symbol(COUNTER),@symbol(HISTOGRAM));
			    break;
#ifdef PERF_COUNTER_PRECISION
			case PERF_COUNTER_PRECISION:
			    __AT_PUT_(st_perCounter, @symbol(COUNTER),@symbol(PRECISION));
			    break;
#endif
		    }
		    break;
		case PERF_TYPE_TEXT:
		    __AT_PUT_(st_perCounter, @symbol(TYPE),@symbol(TEXT));
		    switch (perfCounterPtr->CounterType & PERF_TEXTTYPE_MASK) {
			case PERF_TEXT_UNICODE:
			    __AT_PUT_(st_perCounter, @symbol(TEXT),@symbol(UNICODE));
			    break;
			case PERF_TEXT_ASCII:
			    __AT_PUT_(st_perCounter, @symbol(TEXT),@symbol(ASCII));
			    break;
		    }
		    break;
		case PERF_TYPE_ZERO:
		    __AT_PUT_(st_perCounter, @symbol(TYPE),@symbol(ZERO));
		    break;
	    }

	    //setup the counter pointer to the next counter definition
	    perfCounterPtr = (PERF_COUNTER_DEFINITION *)((char *)perfCounterPtr + perfCounterPtr->ByteLength);
	}

	//goon dependent on the count of instances
	if (perfObjectPtr->NumInstances < 1) {
	    perfCounterBlockPtr = (PERF_COUNTER_BLOCK *)(perfCounterPtr);
	    __AT_PUT_(st_perObject, @symbol(RawData), __MKBYTEARRAY(perfCounterBlockPtr, perfCounterBlockPtr->ByteLength));
	} else {
	    //setup the instance pointer to the end of all counters
	    perfInstancePtr = (PERF_INSTANCE_DEFINITION *)(perfCounterPtr);

	    //setup st_instanceArray and add it to st_perObject
	    st_instanceArray = __ARRAY_NEW_INT(perfObjectPtr->NumInstances);
	    __AT_PUT_(st_perObject, @symbol(Instances), st_instanceArray);

	    //iterate the instances
	    for (instanceIterator=0; instanceIterator<perfObjectPtr->NumInstances; instanceIterator++) {
		//setup st_perInstance and add it to st_instanceArray
		st_perInstance = __SSEND0(@global(Dictionary), @symbol(new), 0);
		__AT_PUT_(st_instanceArray, __mkSmallInteger(instanceIterator+1), st_perInstance);

		//get the instance data
		__AT_PUT_(st_perInstance, @symbol(Name), __MKBYTEARRAY((wchar_t *)((BYTE *)perfInstancePtr + perfInstancePtr->NameOffset),perfInstancePtr->NameLength));
		__AT_PUT_(st_perInstance, @symbol(ParentObjectTitleIndex), __mkSmallInteger(perfInstancePtr->ParentObjectTitleIndex));
		__AT_PUT_(st_perInstance, @symbol(ParentObjectInstance), __mkSmallInteger(perfInstancePtr->ParentObjectInstance));
		__AT_PUT_(st_perInstance, @symbol(NameOffset), __mkSmallInteger(perfInstancePtr->NameOffset));
		__AT_PUT_(st_perInstance, @symbol(NameLength), __mkSmallInteger(perfInstancePtr->NameLength));

		//setup the instance pointer to the its end
		perfInstancePtr = (PERF_INSTANCE_DEFINITION *)((char *)perfInstancePtr + perfInstancePtr->ByteLength);

		//setup the counter block pointer
		perfCounterBlockPtr = (PERF_COUNTER_BLOCK *)(perfInstancePtr);

		//get the instance raw data
		__AT_PUT_(st_perInstance, @symbol(RawData), __MKBYTEARRAY(perfCounterBlockPtr, perfCounterBlockPtr->ByteLength));

		//setup the instance pointer to the next instance
		perfInstancePtr = (PERF_INSTANCE_DEFINITION *)((char *)perfCounterBlockPtr + perfCounterBlockPtr->ByteLength);
	    }
	}

	//setup the object pointer to the next object
	perfObjectPtr = (PERF_OBJECT_TYPE *)((char *)perfObjectPtr + perfObjectPtr->TotalByteLength);
    }
%}.
    objectArray := st_objectArray.
    perfTime := st_perfTime.
    perfFreq := st_perfFreq.
    perfTime100nSec := st_perfTime100nSec.

    getNameBlock := [:i|
	self class counterIndexTextDictionary at:i ifAbsent:['<<no name>>'].
    ].

    getCounterValueBlock := [:counter :rawData|
	|offset counterValue|

	offset := counter at:#CounterOffset.
	offset >= rawData size ifTrue:[
	    counterValue := nil.
	] ifFalse:[
	    (counter at:#SIZE) == #LARGE ifTrue:[
		counterValue := rawData unsignedLongLongAt:offset + 1 bigEndian:false.
	    ] ifFalse:[
		(counter at:#SIZE) == #DWORD ifTrue:[
		    counterValue := rawData unsignedLongAt:offset + 1 bigEndian:false.
		] ifFalse:[
		    self halt:'unhandled counter-size; please check'.
		].
	    ].
	].

	counterValue
    ].

    objectArray do:[:anObject|
	"setup the object name"
	anObject at:#ObjectNameTitle put:(getNameBlock value:(anObject at:#ObjectNameTitleIndex)).

	"setup the name and a counter value array to each counter"
	(anObject at:#Counters) do:[:aCounter|
	    aCounter at:#CounterNameTitle put:(getNameBlock value:(aCounter at:#CounterNameTitleIndex)).
	    aCounter at:#CounterValueArray put:OrderedCollection new.
	].

	(anObject at:#NumInstances) < 1 ifTrue:[
	    |rawData|

	    rawData := anObject at:#RawData.

	    (anObject at:#Counters) do:[:aCounter|
		(aCounter at:#CounterValueArray) add:(getCounterValueBlock value:aCounter value:rawData).
	    ].
	] ifFalse:[
	    (anObject at:#Instances) do:[:anInstance|
		|rawData|

		rawData := anInstance at:#RawData.

		anInstance at:#Name put:((Unicode16String fromBytes:(anInstance at:#Name) copy swapBytes) copyButLast:1).

		(anObject at:#Counters) do:[:aCounter|
		    (aCounter at:#CounterValueArray) add:(getCounterValueBlock value:aCounter value:rawData).
		].
	    ].
	].
    ].

    ^ self
! !

!Win32OperatingSystem::PerformanceData::Abstract methodsFor:'accessing'!

cachedResults

    cachedResults isNil ifTrue:[
	cachedResults := IdentityDictionary new.
    ].

    ^ cachedResults
!

lastData
    ^ lastData
!

lastData:something
    lastData := something.
!

lastTimestamp
    ^ lastTimestamp
!

lastTimestamp:something
    lastTimestamp := something.
! !

!Win32OperatingSystem::PerformanceData::Abstract methodsFor:'definitions'!

aliveTime

    "
	returns the time a data stays alive, in milliseconds
	before we push a new call and overwrite the data
    "

    ^ self subclassResponsibility
!

indexedName
    ^ self subclassResponsibility
!

indexedNameNumbered
    ^ self indexedName asInteger
!

timedQueryMilliseconds
    ^ 100
! !

!Win32OperatingSystem::PerformanceData::Abstract methodsFor:'private'!

data

    self synchronized:[
	|lastTS|

	lastTS := self lastTimestamp.
	lastTS isNil ifTrue:[
	    ^ self dataBasic
	] ifFalse:[
	    Timestamp now asMilliseconds - lastTS >= self aliveTime ifTrue:[
		^ self dataBasic
	    ] ifFalse:[
		^ self lastData
	    ].
	].
    ].
!

dataBasic
    |regEntry|

    regEntry := (Win32OperatingSystem registryEntry key:'HKEY_PERFORMANCE_DATA') valueNamed:self indexedName asString.
    self assert:(regEntry notNil).

    self lastTimestamp:Timestamp now asMilliseconds.
    self lastData:(Win32OperatingSystem::PerformanceData new fromRawBytes:regEntry).

    ^ self lastData
! !

!Win32OperatingSystem::PerformanceData::Abstract methodsFor:'queries'!

getCounterNameIndexArray
    |data object debugBlock|

    data := self data.

    self indexedNameNumbered == 0 ifTrue:[
	object := data objectArray at:1 ifAbsent:[debugBlock value:(object at:#ObjectNameTitle)].
    ] ifFalse:[
	object := data objectArray detect:[:el|(el at:#ObjectNameTitleIndex) == self indexedNameNumbered] ifNone:[self error:'counter not found'].
    ].

    ^ (object at:#Counters) collect:[:el|Array with:(el at:#CounterNameTitle) with:(el at:#CounterNameTitleIndex)].
! !

!Win32OperatingSystem::PerformanceData::Abstract methodsFor:'queries - timed'!

getPerSecondFromLast:aSelector
    |cachedResult return|

    cachedResult := self cachedResults at:aSelector ifAbsent:nil.
    cachedResult notNil ifTrue:[
	|currentResult|

	currentResult := self perform:aSelector.
	return := self getPerSecondViaResult1:cachedResult result2:currentResult.

	self cachedResults at:aSelector put:currentResult.
    ] ifFalse:[
	self cachedResults at:aSelector put:(self perform:aSelector).
    ].

    ^ return
!

getPerSecondViaPerformBlock:performBlock
    |result1 result2 runTimeInNS runTimeInS values1 values2 globalResult|

    self assert:(self aliveTime < self timedQueryMilliseconds).

    result1 := performBlock value.
    Delay waitForMilliseconds:self timedQueryMilliseconds.
    result2 := performBlock value.

    runTimeInNS := ((result2 at:#time100nSec) - (result1 at:#time100nSec)) * 100.
    runTimeInS := runTimeInNS / 1000 / 1000 / 1000.

    values1 := result1 at:#values.
    values2 := result2 at:#values.

    globalResult := Dictionary new.

    values2 keysDo:[:key|
	|difference|

	difference := (values2 at:key) - (values1 at:key).

	runTimeInS = 0 ifTrue:[
	    globalResult at:key put:0.
	] ifFalse:[
	    globalResult at:key put:(difference / runTimeInS) asFloat.
	].
    ].

    ^ globalResult
!

getPerSecondViaResult1:result1 result2:result2
    |runTimeInNS runTimeInS values1 values2 globalResult|

    runTimeInNS := ((result2 at:#time100nSec) - (result1 at:#time100nSec)) * 100.
    runTimeInS := runTimeInNS / 1000 / 1000 / 1000.

    values1 := result1 at:#values.
    values2 := result2 at:#values.

    globalResult := Dictionary new.

    values2 keysDo:[:key|
	|difference|

	difference := (values2 at:key) - (values1 at:key).

	runTimeInS = 0 ifTrue:[
	    globalResult at:key put:0.
	] ifFalse:[
	    globalResult at:key put:(difference / runTimeInS) asFloat.
	].
    ].

    ^ globalResult
!

getUsageFromLast:aSelector
    |cachedResult return|

    cachedResult := self cachedResults at:aSelector ifAbsent:nil.
    cachedResult notNil ifTrue:[
	|currentResult|

	currentResult := self perform:aSelector.
	return := self getUsageViaResult1:cachedResult result2:currentResult.

	self cachedResults at:aSelector put:currentResult.
    ] ifFalse:[
	self cachedResults at:aSelector put:(self perform:aSelector).
    ].

    ^ return
!

getUsageViaPerformBlock:performBlock
    |result1 result2 deltaTIn100Ns value1 value2 globalResult|

    self assert:(self aliveTime < self timedQueryMilliseconds).

    result1 := performBlock value.
    Delay waitForMilliseconds:self timedQueryMilliseconds.
    result2 := performBlock value.

    globalResult := Dictionary new.

    deltaTIn100Ns := (result2 at:#time100nSec) - (result1 at:#time100nSec).

    value1 := result1 at:#values.
    value2 := result2 at:#values.

    value1 keysDo:[:key|
	|diff dPerSecond load1024 res|

	diff := (value2 at:key) - (value1 at:key).
	diff := diff bitShift:10.

	deltaTIn100Ns = 0 ifTrue:[
	    dPerSecond := 0.
	] ifFalse:[
	    dPerSecond := (diff / deltaTIn100Ns) asFloat.
	].
	load1024 := 1024 - dPerSecond.

	res := (load1024 / 1024 * 100) asFloat.
	res < 0 ifTrue:[res := 0].

	globalResult at:key put:res.
    ].

    ^ globalResult
!

getUsageViaResult1:result1 result2:result2
    |deltaTIn100Ns value1 value2 globalResult|

    globalResult := Dictionary new.
    deltaTIn100Ns := (result2 at:#time100nSec) - (result1 at:#time100nSec).

    value1 := result1 at:#values.
    value2 := result2 at:#values.

    value1 keysDo:[:key|
	|diff dPerSecond load1024 res|

	diff := (value2 at:key) - (value1 at:key).
	diff := diff bitShift:10.

	deltaTIn100Ns = 0 ifTrue:[
	    dPerSecond := 0.
	] ifFalse:[
	    dPerSecond := (diff / deltaTIn100Ns) asFloat.
	].
	load1024 := 1024 - dPerSecond.

	res := (load1024 / 1024 * 100) asFloat.
	res < 0 ifTrue:[res := 0].

	globalResult at:key put:res.
    ].

    ^ globalResult
! !

!Win32OperatingSystem::PerformanceData::Abstract methodsFor:'queries - values'!

getBasicValuesByCounter:counterIndex
    ^ self getBasicValuesByObject:0 counter:counterIndex timed:false
!

getBasicValuesByCounter:counterIndex timed:aBoolean
    ^ self getBasicValuesByObject:0 counter:counterIndex timed:aBoolean
!

getBasicValuesByObject:objectIndex counter:counterIndex
    ^ self getBasicValuesByObject:0 counter:counterIndex timed:false
!

getBasicValuesByObject:objectIndex counter:counterIndex timed:aBoolean
    |data object counter values debugBlock numInstances|

    debugBlock := [:obj|
	^ 'obj:', obj , ' this:', self printString , ' idx:', self indexedName
    ].

    data := self dataBasic.

    objectIndex == 0 ifTrue:[
	object := data objectArray at:1 ifAbsent:[debugBlock value:(object at:#ObjectNameTitle)].
    ] ifFalse:[
	object := data objectArray detect:[:el|(el at:#ObjectNameTitleIndex) == objectIndex] ifNone:[debugBlock value:(object at:#ObjectNameTitle)].
    ].

    counter := (object at:#Counters) detect:[:aCounter|(aCounter at:#CounterNameTitleIndex) == counterIndex] ifNone:[debugBlock value:(object at:#ObjectNameTitle)].

    values := Dictionary new.
    numInstances := object at:#NumInstances.

    numInstances > 0 ifTrue:[
	1 to:numInstances do:[:idx|
	    |value instanceName|

	    value := (counter at:#CounterValueArray) at:idx.
	    instanceName := ((object at:#Instances) at:idx) at:#Name.

	    values at:instanceName put:value.
	].
    ] ifFalse:[
	values at:'<<singleton>>' put:(counter at:#CounterValueArray) first.
    ].

    aBoolean ifTrue:[
	|return|

	return := IdentityDictionary new.
	return at:#time put:data perfTime.
	return at:#frequence put:data perfFreq.
	return at:#time100nSec put:data perfTime100nSec.
	return at:#values put:values.

	^ return
    ].

    ^ values
!

getValuesByCounter:counterIndex
    ^ self getValuesByObject:0 counter:counterIndex timed:false
!

getValuesByCounter:counterIndex timed:aBoolean
    ^ self getValuesByObject:0 counter:counterIndex timed:aBoolean
!

getValuesByObject:objectIndex counter:counterIndex
    ^ self getValuesByObject:0 counter:counterIndex timed:false
!

getValuesByObject:objectIndex counter:counterIndex timed:aBoolean
    |data object counter values debugBlock numInstances|

    debugBlock := [:obj|
	^ 'obj:', obj , ' this:', self printString , ' idx:', self indexedName
    ].

    data := self data.

    objectIndex == 0 ifTrue:[
	object := data objectArray at:1 ifAbsent:[debugBlock value:(object at:#ObjectNameTitle)].
    ] ifFalse:[
	object := data objectArray detect:[:el|(el at:#ObjectNameTitleIndex) == objectIndex] ifNone:[debugBlock value:(object at:#ObjectNameTitle)].
    ].

    counter := (object at:#Counters) detect:[:aCounter|(aCounter at:#CounterNameTitleIndex) == counterIndex] ifNone:[debugBlock value:(object at:#ObjectNameTitle)].

    values := Dictionary new.
    numInstances := object at:#NumInstances.

    numInstances > 0 ifTrue:[
	1 to:numInstances do:[:idx|
	    |value instanceName|

	    value := (counter at:#CounterValueArray) at:idx.
	    instanceName := ((object at:#Instances) at:idx) at:#Name.

	    values at:instanceName put:value.
	].
    ] ifFalse:[
	values at:'<<singleton>>' put:(counter at:#CounterValueArray) first.
    ].

    aBoolean ifTrue:[
	|return|

	return := IdentityDictionary new.
	return at:#time put:data perfTime.
	return at:#frequence put:data perfFreq.
	return at:#time100nSec put:data perfTime100nSec.
	return at:#values put:values.

	^ return
    ].

    ^ values
! !

!Win32OperatingSystem::PerformanceData::DiskIO class methodsFor:'accessing'!

current

    TheOneAndOnlyInstance isNil ifTrue:[
	TheOneAndOnlyInstance := self new.
    ].

    ^ TheOneAndOnlyInstance
! !

!Win32OperatingSystem::PerformanceData::DiskIO methodsFor:'definition'!

aliveTime
    ^ 80
!

indexedName
    ^ '236'
! !

!Win32OperatingSystem::PerformanceData::DiskIO methodsFor:'queries'!

diskBytes
    ^ self getValuesByCounter:218 timed:true

    "
	self current diskBytes
    "
!

diskBytesBasic
    ^ self getBasicValuesByCounter:218 timed:true

    "
	self current diskBytesBasic
    "
!

diskBytesPerSecond
    ^ self getPerSecondViaPerformBlock:[self diskBytes]

    "
	self current diskBytesPerSecond
    "
!

diskBytesPerSecondFromLast
    ^ self getPerSecondFromLast:#diskBytesBasic

    "
	self current diskBytesPerSecondFromLast
    "
!

diskQueueLength
    ^ self getValuesByCounter:198

    "
	self current diskQueueLength
    "
!

diskRead
    ^ self getValuesByCounter:214 timed:true

    "
	self current diskRead
    "
!

diskReadBasic
    ^ self getBasicValuesByCounter:214 timed:true

    "
	self current diskReadBasic
    "
!

diskReadsPerSecond
    ^ self getPerSecondViaPerformBlock:[self diskRead]

    "
	self current diskReadsPerSecond
    "
!

diskReadsPerSecondFromLast
    ^ self getPerSecondFromLast:#diskReadBasic

    "
	self current diskReadsPerSecondFromLast
    "
!

diskSpaceFreeInMegaByte
    ^ self getValuesByCounter:408

    "
	self current diskSpaceFreeInMegaByte
    "
!

diskTransfers
    ^ self getValuesByCounter:212 timed:true

    "
	self current diskTransfers
    "
!

diskTransfersBasic
    ^ self getBasicValuesByCounter:212 timed:true

    "
	self current diskTransfersBasic
    "
!

diskTransfersPerSecond
    ^ self getPerSecondViaPerformBlock:[self diskTransfers]

    "
	self current diskTransfersPerSecond
    "
!

diskTransfersPerSecondFromLast
    ^ self getPerSecondFromLast:#diskTransfersBasic

    "
	self current diskTransfersPerSecondFromlast
    "
!

diskWrite
    ^ self getValuesByCounter:216 timed:true

    "
	self current diskWrite
    "
!

diskWriteBasic
    ^ self getBasicValuesByCounter:216 timed:true

    "
	self current diskWriteBasic
    "
!

diskWritesPerSecond
    ^ self getPerSecondViaPerformBlock:[self diskWrite]

    "
	self current diskWritesPerSecond
    "
!

diskWritesPerSecondFromLast
    ^ self getPerSecondFromLast:#diskWriteBasic

    "
	self current diskWritesPerSecondFromLast
    "
! !

!Win32OperatingSystem::PerformanceData::Global class methodsFor:'accessing'!

current

    TheOneAndOnlyInstance isNil ifTrue:[
	TheOneAndOnlyInstance := self new.
    ].

    ^ TheOneAndOnlyInstance
! !

!Win32OperatingSystem::PerformanceData::Global methodsFor:'definitions'!

aliveTime
    ^ 200
!

indexedName
    ^ 'Global'
! !

!Win32OperatingSystem::PerformanceData::Global methodsFor:'queries'!

getCounterNameIndexArray
    self error:'Global implements objects only'.
!

getObjectNameIndexArray
    |data indexNameArray|

    data := self data.
    indexNameArray := OrderedCollection new.

    data objectArray do:[:anObject|
	|index name|

	index := anObject at:#ObjectNameTitleIndex.
	name := Win32OperatingSystem::PerformanceData counterIndexTextDictionary at:index.

	indexNameArray add:(Array with:name with:index).
    ].

    ^ indexNameArray
! !

!Win32OperatingSystem::PerformanceData::Memory class methodsFor:'accessing'!

current

    TheOneAndOnlyInstance isNil ifTrue:[
	TheOneAndOnlyInstance := self new.
    ].

    ^ TheOneAndOnlyInstance
! !

!Win32OperatingSystem::PerformanceData::Memory methodsFor:'definitions'!

aliveTime
    ^ 80
!

indexedName
    ^ '4'
! !

!Win32OperatingSystem::PerformanceData::Memory methodsFor:'queries'!

availableKBytes
    ^ self getValuesByCounter:1380

    "
	self current availableKBytes
    "
!

availableMBytes
    ^ self getValuesByCounter:1382

    "
	self current availableMBytes
    "
! !

!Win32OperatingSystem::PerformanceData::Network class methodsFor:'accessing'!

current

    TheOneAndOnlyInstance isNil ifTrue:[
	TheOneAndOnlyInstance := self new.
    ].

    ^ TheOneAndOnlyInstance
! !

!Win32OperatingSystem::PerformanceData::Network methodsFor:'definition'!

aliveTime
    ^ 80
!

indexedName
    ^ '510'
!

timedQueryMilliseconds
    ^ 200
! !

!Win32OperatingSystem::PerformanceData::Network methodsFor:'queries'!

bytesReceived
    ^ self getValuesByCounter:264 timed:true

    "
	self current bytesReceived
    "
!

bytesReceivedBasic
    ^ self getBasicValuesByCounter:264 timed:true

    "
	self current bytesReceivedBasic
    "
!

bytesReceivedPerSecond
    ^ self getPerSecondViaPerformBlock:[self bytesReceived]

    "
	self current bytesReceivedPerSecond
    "
!

bytesReceivedPerSecondFromlast
    ^ self getPerSecondFromLast:#bytesReceivedBasic

    "
	self current bytesReceivedPerSecondFromlast
    "
!

bytesSent
    ^ self getValuesByCounter:506 timed:true

    "
	self current bytesSent
    "
!

bytesSentBasic
    ^ self getBasicValuesByCounter:506 timed:true

    "
	self current bytesSentBasic
    "
!

bytesSentPerSecond
    ^ self getPerSecondViaPerformBlock:[self bytesSent]

    "
	self current bytesSentPerSecond
    "
!

bytesSentPerSecondFromlast
    ^ self getPerSecondFromLast:#bytesSentBasic

    "
	self current bytesSentPerSecondFromlast
    "
!

kBytesReceivedPerSecond
    |modifiedDictionary|

    modifiedDictionary := Dictionary new.

    (self getPerSecondViaPerformBlock:[self bytesReceived]) keysAndValuesDo:[:key :value|
	modifiedDictionary at:key put:(value / 1024).
    ].

    ^ modifiedDictionary

    "
	self current kBytesReceivedPerSecond
    "
!

kBytesReceivedPerSecondFromLast
    |return modifiedDictionary|

    return := self bytesReceivedPerSecondFromlast.
    return isNil ifTrue:[^ nil].

    modifiedDictionary := Dictionary new.

    return keysAndValuesDo:[:key :value|
	modifiedDictionary at:key put:(value / 1024).
    ].

    ^ modifiedDictionary

    "
	self current kBytesReceivedPerSecondFromLast
    "
!

kBytesSentPerSecond
    |modifiedDictionary|

    modifiedDictionary := Dictionary new.

    (self getPerSecondViaPerformBlock:[self bytesSent]) keysAndValuesDo:[:key :value|
	modifiedDictionary at:key put:(value / 1024).
    ].

    ^ modifiedDictionary

    "
	self current kBytesSentPerSecond
    "
!

kBytesSentPerSecondFromLast
    |return modifiedDictionary|

    return := self bytesSentPerSecondFromlast.
    return isNil ifTrue:[^ nil].

    modifiedDictionary := Dictionary new.

    return keysAndValuesDo:[:key :value|
	modifiedDictionary at:key put:(value / 1024).
    ].

    ^ modifiedDictionary

    "
	self current kBytesSentPerSecondFromLast
    "
! !

!Win32OperatingSystem::PerformanceData::Process class methodsFor:'accessing'!

current

    TheOneAndOnlyInstance isNil ifTrue:[
	TheOneAndOnlyInstance := self new.
    ].

    ^ TheOneAndOnlyInstance
! !

!Win32OperatingSystem::PerformanceData::Process methodsFor:'definition'!

aliveTime
    ^ 80
!

indexedName
    ^ '230'
! !

!Win32OperatingSystem::PerformanceData::Process methodsFor:'queries'!

processTime
    ^ self getValuesByCounter:6 timed:true

    "
	self current processTime
    "
!

processTimeBasic
    ^ self getBasicValuesByCounter:6 timed:true

    "
	self current processTimeBasic
    "
!

processUsage
    |modifiedDictionary|

    modifiedDictionary := Dictionary new.

    (self getUsageViaPerformBlock:[self processTime]) keysAndValuesDo:[:key :value|
	modifiedDictionary at:key put:(100 - value).
    ].

    ^ modifiedDictionary

    "
	self current processUsage
    "
!

processUsageFromLast
    |return modifiedDictionary|

    return := self getUsageFromLast:#processTimeBasic.
    return isNil ifTrue:[^ nil].

    modifiedDictionary := Dictionary new.

    return keysAndValuesDo:[:key :value|
	modifiedDictionary at:key put:(100 - value).
    ].

    ^ modifiedDictionary

    "
	self current processUsageFromLast
    "
!

runningProcessNameList
    "_Total ~ pseudo process; Idle ~ pseudo process represents the free resources"
    ^ (self data objectArray first at:#Instances) collect:[:el|el at:#Name]

    "
	self current runningProcessNameList
    "
!

runningProcesses
    "_Total ~ pseudo process; Idle ~ pseudo process represents the free resources"
    ^ (self data objectArray first at:#NumInstances)

    "
	self current runningProcesses
    "
! !

!Win32OperatingSystem::PerformanceData::Processor class methodsFor:'accessing'!

current

    TheOneAndOnlyInstance isNil ifTrue:[
	TheOneAndOnlyInstance := self new.
    ].

    ^ TheOneAndOnlyInstance
! !

!Win32OperatingSystem::PerformanceData::Processor methodsFor:'definitions'!

aliveTime
    ^ 80
!

indexedName
    ^ '238'
! !

!Win32OperatingSystem::PerformanceData::Processor methodsFor:'queries'!

interrupts
    ^ self getValuesByCounter:148 timed:true

    "
	self current interrupts
    "
!

interruptsBasic
    ^ self getBasicValuesByCounter:148 timed:true

    "
	self current interruptsBasic
    "
!

interruptsPerSecond
    ^ self getPerSecondViaPerformBlock:[self interrupts]

    "
	self current interruptsPerSecond
    "
!

interruptsPerSecondFromLast
    ^ self getPerSecondFromLast:#interruptsBasic

    "
	self current interruptsPerSecondFromLast
    "
!

processorTime
    ^ self getValuesByCounter:6 timed:true

    "
	self current processorTime
    "
!

processorTimeBasic
    ^ self getBasicValuesByCounter:6 timed:true

    "
	self current processorTimeBasic
    "
!

processorUsage
    ^ self getUsageViaPerformBlock:[self processorTime]

    "
	self current processorUsage
    "
!

processorUsageFromLast
    ^ self getUsageFromLast:#processorTimeBasic

    "
	self current processorUsageFromLast
    "
! !

!Win32OperatingSystem::PrinterInfo2Structure methodsFor:'accessing'!

defaultPriority

    |defaultPriority|

    Error handle:[:ex |
	Transcript showCR: 'PrinterInfo2 error getting defaultPriority - ', ex description.
	defaultPriority := 0.
    ] do:[
	defaultPriority := self unsignedLongAt:(60 + 1)
    ].
    ^ defaultPriority

    "Created: / 01-08-2006 / 12:46:50 / fm"
    "Modified: / 16-04-2007 / 13:08:33 / cg"
!

pComment
    |pComment|

    Error handle:[:ex |
	Transcript showCR: 'PrinterInfo2 error getting pComment - ', ex description.
	pComment := 0.
    ] do:[
	pComment := self unsignedLongAt:(20 + 1).
    ].

    ^ pComment == 0
	ifTrue:''
	ifFalse:[ (ExternalBytes address:pComment) stringAt:1 ]

    "Created: / 01-08-2006 / 14:02:55 / fm"
    "Modified: / 16-04-2007 / 13:08:39 / cg"
!

pDriverName
    |pName|

    Error handle:[:ex |
	Transcript showCR: 'PrinterInfo2 error getting pDriverName - ', ex description.
	pName := 0.
    ] do:[
	pName := self unsignedLongAt:(16 + 1).
    ].
    pName == 0 ifTrue:[^ ''].
    ^ (ExternalBytes address:pName) stringAt:1

    "Created: / 01-08-2006 / 14:05:18 / fm"
    "Modified: / 16-04-2007 / 13:08:43 / cg"
!

pLocation
    |pLocation externalBytes|

    Error handle:[:ex |
	Transcript showCR: 'PrinterInfo2 error getting pLocation - ', ex description.
	pLocation := 0.
    ] do:[
	pLocation := self unsignedLongAt:(24 + 1).
    ].

    pLocation == 0 ifTrue:[^ nil].

    externalBytes := ExternalBytes address:pLocation.
    ^ externalBytes isEmpty
	ifTrue:[ nil ]
	ifFalse:[ externalBytes stringAt:1 ]

    "Created: / 01-08-2006 / 14:03:21 / fm"
    "Modified: / 18-10-2006 / 12:06:45 / User"
    "Modified: / 16-04-2007 / 13:08:27 / cg"
!

priority

    |priority|

    Error handle:[:ex |
	Transcript showCR: 'PrinterInfo2 error getting priority - ', ex description.
	priority := 0.
    ] do:[
	priority := self unsignedLongAt: 56 + 1
    ].
    ^ priority

    "Created: / 01-08-2006 / 14:40:08 / fm"
    "Modified: / 16-04-2007 / 13:09:02 / cg"
!

status

    |status|

    Error handle:[:ex |
	Transcript showCR: 'PrinterInfo2 error getting status - ', ex description.
	status := -1.
    ] do:[
	status := self unsignedLongAt: 72 + 1
    ].
    ^ status

    "Created: / 31-07-2006 / 11:08:05 / fm"
    "Modified: / 16-04-2007 / 13:08:59 / cg"
! !

!Win32OperatingSystem::RegistryEntry class methodsFor:'defaults'!

rootKeyNames
    "returns a collection of root keyNames"

    ^ #(
	'HKEY_CLASSES_ROOT'
	'HKEY_CURRENT_USER'
	'HKEY_LOCAL_MACHINE'
	'HKEY_USERS'
	'HKEY_PERFORMANCE_DATA'
	'HKEY_CURRENT_CONFIG'
	'HKEY_DYN_DATA'
      )
!

separator
    "returns the registry-key-path separator character"

    ^$\
! !

!Win32OperatingSystem::RegistryEntry class methodsFor:'documentation'!

documentation
"
    Interface to a WIN32 registry.

    As this is a private class, access it via
	Win32OperatingSystem registryEntry

    [author:]
	Claus Gittinger (initial version & cleanup)
"
!

examples
"
    retrieve an existing entry by key:
									[exBegin]
	|k|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\Software\eXept\Smalltalk/X'
									[exEnd]


    retrieve a non-existing entry by key:
									[exBegin]
	|k|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\Software\xxx'
									[exEnd]


    ask a keys value:
									[exBegin]
	|k|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion'.
	Transcript show:'Windows serial NR:'; showCR:(k valueNamed:'ProductId').

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\Software\eXept\Smalltalk/X'.
	Transcript showCR:(k valueNamed:'CurrentVersion').
									[exEnd]


    create a sub-key (if not already present):
									[exBegin]
	|k subKey|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\Software\eXept\Smalltalk/X'.
	subKey := k createSubKeyNamed:'RegistryDemo'
									[exEnd]


    change a keys value:
									[exBegin]
	|k|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\Software\eXept\Smalltalk/X\RegistryDemo'.
	k valueNamed:'FooBarBaz' put:'a foo bar baz string'.
									[exEnd]

    delete a value:
									[exBegin]
	|k|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\Software\eXept\Smalltalk/X\RegistryDemo'.
	k deleteValueNamed:'FooBarBaz'.
									[exEnd]

    delete a key:
									[exBegin]
	|k|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\Software\eXept\Smalltalk/X'.
	k deleteSubKeyNamed:'RegistryDemo'.
									[exEnd]

    enumerate keys:
									[exBegin]
	|k|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\Software'.
	k subKeysDo:[:subKey |
	    Transcript showCR:subKey path
	]
									[exEnd]

    enumerate all keys (recursive):
									[exBegin]
	|k|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\Software'.
	k allSubKeysDo:[:subKey |
	    Transcript showCR:subKey path
	]
									[exEnd]

    fetch value by index:
									[exBegin]
	|k|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\eXept\Smalltalk/X'.
	Transcript showCR:(k valueNameAtIndex:0)
									[exEnd]


    enumerate value names:
									[exBegin]
	|k|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\eXept\Smalltalk/X'.
	k valueNamesDo:[:nm  |
	   Transcript showCR:nm.
	]
									[exEnd]

    enumerate values:
									[exBegin]
	|k|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\eXept\Smalltalk/X'.
	k valueNamesAndValuesDo:[:nm :val |
	    Transcript showCR:(nm , ' -> ' , val storeString).
	]
									[exEnd]

    search for a value (where does NT store the domain ?):
									[exBegin]
	|k|

	k := Win32OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\System'.
	k subKeysDo:[:subKey |
	    subKey subKeysDo:[:subSubKey |
		|tcp params|

		(subSubKey path asLowercase endsWith:'services') ifTrue:[
		    tcp := subSubKey subKeyNamed:'tcpip'.
		    tcp notNil ifTrue:[
			params := tcp subKeyNamed:'parameters'.
			params notNil ifTrue:[
			    Transcript showCR:'Domain is found in ' , params path ,
					' value: ' , (params valueNamed:'Domain').
			    params close.
			].
			tcp close.
		    ]
		]
	    ]
	]
									[exEnd]
    register an exe for shell-open:
									[exBegin]
	|k stx shell open cmd st_af edit st owl list id|

	k := Win32OperatingSystem registryEntry key:'HKEY_CURRENT_USER\Software\Classes\Applications'.
	stx := k createSubKeyNamed:'SmalltalkX.exe'.
	shell := stx createSubKeyNamed:'shell'.
	open := shell createSubKeyNamed:'open'.
	cmd := open createSubKeyNamed:'command'.
	cmd defaultValue:(Character doubleQuote asString,OperatingSystem nameOfSTXExecutable,Character doubleQuote,
			 ' ',Character doubleQuote,'%1',Character doubleQuote).

	k := Win32OperatingSystem registryEntry key:'HKEY_CURRENT_USER\Software\Classes'.
	st_af := k createSubKeyNamed:'st_auto_file'.
	shell := st_af createSubKeyNamed:'shell'.
	open := shell createSubKeyNamed:'open'.
	cmd := open createSubKeyNamed:'command'.
	cmd defaultValue:(Character doubleQuote asString,OperatingSystem nameOfSTXExecutable,Character doubleQuote,
			 ' --open ',Character doubleQuote,'%1',Character doubleQuote).
	edit := shell createSubKeyNamed:'edit'.
	cmd := edit createSubKeyNamed:'command'.
	cmd defaultValue:(Character doubleQuote asString,OperatingSystem nameOfSTXExecutable,Character doubleQuote,
			 ' --edit ',Character doubleQuote,'%1',Character doubleQuote).

	k := Win32OperatingSystem registryEntry key:'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts'.
	st := k createSubKeyNamed:'.st'.
	owl := st createSubKeyNamed:'OpenWithList'.
	list := owl valueNames.
	(list contains:[:k | (owl valueNamed:k) = 'SmalltalkX.exe']) ifTrue:[
	    Transcript showCR:'already registered.'.
	] ifFalse:[
	    id := ($a to:$z) detect:[:k | (list includes:(k asString)) not] ifNone:nil.
	    owl valueNamed:id asString put:'SmalltalkX.exe'.
	]
									[exEnd]




"
! !

!Win32OperatingSystem::RegistryEntry class methodsFor:'initialization'!

initialize
    Lobby := Registry new.
    ObjectMemory addDependent:self.

    HKEY_CLASSES_ROOT     := %{ __MKEXTERNALADDRESS(HKEY_CLASSES_ROOT) %}.
    HKEY_CURRENT_USER     := %{ __MKEXTERNALADDRESS(HKEY_CURRENT_USER) %}.
    HKEY_LOCAL_MACHINE    := %{ __MKEXTERNALADDRESS(HKEY_LOCAL_MACHINE) %}.
    HKEY_USERS            := %{ __MKEXTERNALADDRESS(HKEY_USERS) %}.
    HKEY_PERFORMANCE_DATA := %{ __MKEXTERNALADDRESS(HKEY_PERFORMANCE_DATA) %}.
    HKEY_CURRENT_CONFIG   := %{ __MKEXTERNALADDRESS(HKEY_CURRENT_CONFIG) %}.
    HKEY_DYN_DATA         := %{ __MKEXTERNALADDRESS(HKEY_DYN_DATA) %}.

%{
#ifndef HKEY_PERFORMANCE_TEXT
    /* sigh - not defined with borland-cc */
# define HKEY_PERFORMANCE_TEXT  (( HKEY ) (ULONG_PTR)((LONG)0x80000050) )
#endif
#ifndef HKEY_PERFORMANCE_NLSTEXT
    /* sigh - not defined with borland-cc */
# define HKEY_PERFORMANCE_NLSTEXT  (( HKEY ) (ULONG_PTR)((LONG)0x80000060) )
#endif
%}.
    HKEY_PERFORMANCE_TEXT    := %{ __MKEXTERNALADDRESS(HKEY_PERFORMANCE_TEXT) %}.
    HKEY_PERFORMANCE_NLSTEXT := %{ __MKEXTERNALADDRESS(HKEY_PERFORMANCE_NLSTEXT) %}.

    "
     self initialize
    "

    "Created: / 19.5.1999 / 21:39:57 / cg"
    "Modified: / 19.5.1999 / 22:45:31 / cg"
!

rootKeyValueFor:specialKeyStringOrSymbol
    "returns one of the root keys or nil
     (these are shared and not finalized, as opposed to all other keys)"

    HKEY_CLASSES_ROOT isNil ifTrue:[self initialize].

    specialKeyStringOrSymbol = #'HKEY_CLASSES_ROOT' ifTrue:[
	^ HKEY_CLASSES_ROOT.
    ].
    specialKeyStringOrSymbol = #'HKEY_CURRENT_USER' ifTrue:[
	^ HKEY_CURRENT_USER.
    ].
    specialKeyStringOrSymbol = #'HKEY_LOCAL_MACHINE' ifTrue:[
	^ HKEY_LOCAL_MACHINE.
    ].
    specialKeyStringOrSymbol = #'HKEY_USERS' ifTrue:[
	^ HKEY_USERS.
    ].
    specialKeyStringOrSymbol = #'HKEY_PERFORMANCE_DATA' ifTrue:[
	^ HKEY_PERFORMANCE_DATA.
    ].
    specialKeyStringOrSymbol = #'HKEY_CURRENT_CONFIG' ifTrue:[
	^ HKEY_CURRENT_CONFIG.
    ].
    specialKeyStringOrSymbol = #'HKEY_DYN_DATA' ifTrue:[
	^ HKEY_DYN_DATA.
    ].
    specialKeyStringOrSymbol = #'HKEY_PERFORMANCE_TEXT' ifTrue:[
	^ HKEY_PERFORMANCE_TEXT.
    ].
    specialKeyStringOrSymbol = #'HKEY_PERFORMANCE_NLSTEXT' ifTrue:[
	^ HKEY_PERFORMANCE_NLSTEXT.
    ].

    ^ nil

    "Created: / 19.5.1999 / 21:40:30 / cg"
    "Modified: / 24.12.1999 / 00:02:06 / cg"
!

update:something with:aParameter from:changedObject
    "handle image restarts and refetch registry handles"

    (something == #returnFromSnapshot) ifTrue:[
	self initialize
    ]

    "Created: 15.6.1996 / 15:14:03 / cg"
    "Modified: 24.2.1997 / 22:08:05 / cg"
! !

!Win32OperatingSystem::RegistryEntry class methodsFor:'instance creation'!

immediateHandle:aHandleValue
    |h newEntry|

    aHandleValue isInteger ifTrue:[
	h := ExternalAddress newAddress:aHandleValue
    ] ifFalse:[
	h := aHandleValue
    ].

    "/ rootKeys are not registered for RegClose ...
    newEntry := self basicNew setHandle:h path:nil.
    newEntry registerForFinalization.
    ^ newEntry.

    "
     RegistryEntry immediateHandle:16r80000002
    "
!

key:aKeyNamePath
    "retrieve an entry by full path name (starting at a root)"

    ^ self key:aKeyNamePath flags:nil createIfAbsent:false

    "
     self key:'HKEY_LOCAL_MACHINE'
     self key:'HKEY_LOCAL_MACHINE\Software'
     self key:'HKEY_LOCAL_MACHINE\Software\Borland\'
     self key:'HKEY_LOCAL_MACHINE\Software\eXept\Smalltalk/X\3.2.5\Directory'
     (self key:'HKEY_CLASSES_ROOT\MicrosoftWorks.WordProcessor\CLSID') valueNamed:''
    "

    "Modified: / 19-01-2011 / 15:59:36 / cg"
!

key:aKeyNamePath createIfAbsent:createIfAbsent
    "retrieve an entry by full path name (starting at a root)"

    ^ self key:aKeyNamePath flags:nil createIfAbsent:createIfAbsent

    "
     self key:'HKEY_LOCAL_MACHINE'
     self key:'HKEY_LOCAL_MACHINE\Software'
     self key:'HKEY_LOCAL_MACHINE\Software\Borland\'
     self key:'HKEY_LOCAL_MACHINE\Software\eXept\Smalltalk/X\3.2.5\Directory'
     (self key:'HKEY_CLASSES_ROOT\MicrosoftWorks.WordProcessor\CLSID') valueNamed:''
    "

    "Created: / 19-01-2011 / 15:59:21 / cg"
!

key:aKeyNamePath flags:flags
    "retrieve an entry by full path name (starting at a root).
     flags may be one of:
	#KEY_WOW64_64KEY to force access to the 64Bit Windows key,
	#KEY_WOW64_32KEY to force access to the 32Bit Windows key,
	or nil, to access the key (32/64) for the current application"

    ^ self key:aKeyNamePath flags:flags createIfAbsent:false

    "
     self key:'HKEY_LOCAL_MACHINE'
     self key:'HKEY_LOCAL_MACHINE\Software'
     self key:'HKEY_LOCAL_MACHINE\Software\Borland\'
     self key:'HKEY_LOCAL_MACHINE\Software\eXept\Smalltalk/X\3.2.5\Directory'
     (self key:'HKEY_CURRENT_USER\Console' flags:#KEY_WOW64_64KEY) subKeys
     (self key:'HKEY_CURRENT_USER\Console' flags:#KEY_WOW64_32KEY) subKeys
    "

    "Modified: / 19-01-2011 / 15:59:36 / cg"
!

key:aKeyNamePath flags:flags createIfAbsent:createIfAbsent
    "retrieve an entry by full path name (starting at a root).
     flags may be one of:
	#KEY_WOW64_64KEY to force access to the 64Bit Windows key,
	#KEY_WOW64_32KEY to force access to the 32Bit Windows key,
	or nil, to access the key (32/64) for the current application"

    |idx first rest root|

    HKEY_CLASSES_ROOT isNil ifTrue:[self initialize].

    idx := aKeyNamePath indexOf:(self separator).
    idx == 0 ifTrue:[
	first := aKeyNamePath.
	rest := nil.
    ] ifFalse:[
	first := aKeyNamePath copyTo:idx-1.
	rest := aKeyNamePath copyFrom:idx+1
    ].

    first := first asUppercase.

    "/ the first is a pseudo name
    root := self rootKey:first.
    root isNil ifTrue:[
	^ nil
    ].

    rest size == 0 ifTrue:[
	^ root
    ].

    Error handle:[:ex |
	^ nil
    ] do:[
	^ root subKeyNamed:rest flags:flags createIfAbsent:createIfAbsent.
    ].

    "
     self key:'HKEY_LOCAL_MACHINE'
     self key:'HKEY_LOCAL_MACHINE\Software'
     self key:'HKEY_LOCAL_MACHINE\Software\Borland\'
     self key:'HKEY_LOCAL_MACHINE\Software\eXept\Smalltalk/X\3.2.5\Directory'
     (self key:'HKEY_CLASSES_ROOT\MicrosoftWorks.WordProcessor\CLSID' flags:#KEY_WOW64_64KEY) valueNamed:''
    "

    "Created: / 19-01-2011 / 15:59:21 / cg"
!

rootKey:aRootKeyStringOrSymbol
    "retrieve one of the root entries by name"

    |keyVal|

    keyVal := self rootKeyValueFor:aRootKeyStringOrSymbol.
    keyVal isNil ifTrue:[^ nil].
    "/ rootKeys are not registered for RegClose ...
    ^ self basicNew setHandle:keyVal path:aRootKeyStringOrSymbol.

    "
     RegistryEntry rootKey:#'HKEY_LOCAL_MACHINE'
    "
! !

!Win32OperatingSystem::RegistryEntry class methodsFor:'misc queries'!

classIDOf:applicationName
    |k clsIDString|

    k := self key:'HKEY_CLASSES_ROOT\',applicationName,'\CLSID'.
    k isNil ifTrue:[ ^ nil ].

    clsIDString := k defaultValue.
    k close.
    ^ UUID fromString:clsIDString

    "
     self classIDOf:'MicrosoftWorks.WordProcessor'
     self classIDOf:'AcroPDF.PDF'
     self classIDOf:'PDF.PdfCtrl.5'
    "
!

commandTemplateToOpenMimeType:mimeType
    "given a mimeType, retrieve the command-template of an application for opening the document.
     Return nil, if no such application is known.
     Do nor use directly - this is a helper for MIMEType"

    ^ self commandTemplateToOpenSuffix:(self extensionForMimeType:mimeType)

    "
     Win32OperatingSystem::RegistryEntry commandTemplateToOpenMimeType:'application/pdf'
     Win32OperatingSystem::RegistryEntry commandTemplateToOpenMimeType:'audio/mp3'
     Win32OperatingSystem::RegistryEntry commandTemplateToOpenMimeType:'video/avi'
     Win32OperatingSystem::RegistryEntry commandTemplateToOpenMimeType:'application/x-zip-compressed'
    "
!

commandTemplateToOpenSuffix:suffixArg
    "given a suffix, retrieve the command template for an application to print the document.
     Do nor use directly - this is a helper for MIMEType"

    ^ self shellCommandTemplateFor:'open' onSuffix:suffixArg

    "
     self commandTemplateToOpenSuffix:'pdf'
     self commandTemplateToOpenSuffix:'zip'
    "
!

commandTemplateToPrintMimeType:mimeType
    "given a mimeType, retrieve the command-template of an application for printing the document.
     Return nil, if no such application is known.
     Do nor use directly - this is a helper for MIMEType"

    ^ self commandTemplateToPrintSuffix:(self extensionForMimeType:mimeType)

    "
     Win32OperatingSystem::RegistryEntry commandTemplateToPrintMimeType:'application/pdf'
     Win32OperatingSystem::RegistryEntry commandTemplateToPrintMimeType:'audio/mp3'
    "
!

commandTemplateToPrintSuffix:suffixArg
    "given a suffix, retrieve the command template for an application to open the document.
     Do nor use directly - this is a helper for MIMEType"

    ^ self shellCommandTemplateFor:'print' onSuffix:suffixArg

    "
     self commandTemplateToPrintSuffix:'pdf'
     self commandTemplateToPrintSuffix:'zip'
    "
!

executableForMimeType:mimeType
    "given a mimeType, retrieve the path to an application from the registry"

    <resource: #obsolete>

    self obsoleteMethodWarning:'use commandTemplateToOpenMimeType:'.
    ^ self commandTemplateToOpenMimeType:mimeType

    "
     Win32OperatingSystem::RegistryEntry executableForMimeType:'application/pdf'
     Win32OperatingSystem::RegistryEntry executableForMimeType:'audio/mp3'
     Win32OperatingSystem::RegistryEntry executableForMimeType:'video/avi'
     Win32OperatingSystem::RegistryEntry executableForMimeType:'application/x-zip-compressed'
    "
!

executableForSuffix:suffixArg
    "given a suffix, retrieve the path to an application from the registry"

    <resource: #obsolete>

    self obsoleteMethodWarning:'use commandTemplateToOpenSuffix:'.
    ^ self commandTemplateToOpenSuffix:suffixArg.

    "
     self executableForSuffix:'pdf'
     self executableForSuffix:'zip'
    "
!

extensionForMimeType:mimeType
    "HELPER: given a mimeType, retrieve the file extension or nil (if unknown)"

    |k suffix|

    k := self key:'HKEY_CLASSES_ROOT\MIME\Database\Content Type\',mimeType.
    k notNil ifTrue:[
	suffix := k valueNamed:'extension'.
    ].
    ^ suffix
!

shellCommandTemplateFor:operation onSuffix:suffixArg
    "HELPER: given a suffix, and an operation, retrieve a command template for an application"

    |k fkey cmd suffix redirect|

    suffix := suffixArg.
    suffix isNil ifTrue:[^ nil].

    (suffix startsWith:'.') ifTrue:[
	suffix := suffix copyFrom:2
    ].
    k := self key:'HKEY_CLASSES_ROOT\.',suffix.

    k notNil ifTrue:[
	fkey := (k valueNamed:'').
    ].
    fkey isNil ifTrue:[
	fkey := suffix,'_auto_file'
    ].

    fkey notEmptyOrNil ifTrue:[

	redirect := nil.

	k := Win32OperatingSystem::RegistryEntry key:('HKEY_CLASSES_ROOT\' , fkey , '\CurVer').
	k notNil ifTrue:[
	    redirect := k defaultValue
	].

	redirect isNil ifTrue:[
	     k := Win32OperatingSystem::RegistryEntry key:('HKEY_CLASSES_ROOT\' , (fkey) , '\shell\',operation,'\command').
	] ifFalse:[
	     k := Win32OperatingSystem::RegistryEntry key:('HKEY_CLASSES_ROOT\' , (redirect) , '\shell\',operation,'\command').
	].

	k notNil ifTrue:[
	    cmd := k defaultValue
	].
    ].


    ^ cmd
! !

!Win32OperatingSystem::RegistryEntry class methodsFor:'registry access'!

stringValueFor:valueName atKey:keyPath
    "convenient accessing method;
     Looks for a string value under keyPath;
     returns nil if either not found, or no string value"

    |k v|

    k := self key:keyPath.
    k isNil ifTrue:[^ nil].
    v := k valueNamed:valueName.
    k close.
    v isString ifFalse:[^ nil].
    ^ v

    "
     self
	stringValueFor:'Content Type'
	atKey:'HKEY_CLASSES_ROOT\.au'
    "
! !

!Win32OperatingSystem::RegistryEntry methodsFor:'accessing'!

handleValue
    ^ handle address
!

isNew
    "answer true, if this key hats just be created, false if it did already exist"

    ^ isNew ? false
!

name
    "return the keys name component (subKey name within my
     parent key)"

    |idx|

    idx := path lastIndexOf:(self class separator).
    idx == 0 ifTrue:[^ path].
    ^ path copyFrom:idx+1
!

path
    "return the keys full key path name"

    ^ path.
! !

!Win32OperatingSystem::RegistryEntry methodsFor:'accessing subkeys'!

createSubKeyNamed:subKeyString
    "create a new key below mySelf and return a new registry entry for it.
     If it already exists, return it.
     Return nil if the new key cannot be created."

    ^ self subKeyNamed:subKeyString flags:nil createIfAbsent:true

    "
     |top sub|

     top := self key:'HKEY_CURRENT_USER'.
     sub := top createSubKeyNamed:'FooBarBaz'.
    "
!

createSubKeyNamed:subKeyString flags:flags
    "create a new key below mySelf and return a new registry entry for it.
     If it already exists, return it.
     Return nil if the new key cannot be created.
     flags may be one of:
	#KEY_WOW64_64KEY to force access to the 64Bit Windows key,
	#KEY_WOW64_32KEY to force access to the 32Bit Windows key,
	or nil, to access the key (32/64) for the current application"


    ^ self subKeyNamed:subKeyString flags:flags createIfAbsent:true

    "
     |top sub|

     top := self key:'HKEY_CURRENT_USER'.
     sub := top createSubKeyNamed:'FooBarBaz' flags:nil.
    "
!

deleteSubKeyNamed:subKeyString
    "delete a key below mySelf.
     Return true on success."

    ^ self deleteSubKeyNamed:subKeyString flags:nil

    "
     |top sub|

     top := self key:'HKEY_CURRENT_USER'.
     sub := top createSubKeyNamed:'FooBarBaz'.
     top deleteSubKeyNamed:'FooBarBaz'.
    "
!

deleteSubKeyNamed:subKeyString flags:flags
    "Delete a key below myself. return true on success.
     
     `flags` may be one of:
	#KEY_WOW64_64KEY to force access to the 64Bit Windows key,
	#KEY_WOW64_32KEY to force access to the 32Bit Windows key,
	or nil, to access the key (32/64) for the current application.
    "

    |subKeyStringZ errorNumber|

    subKeyStringZ := subKeyString asUnicode16StringZ.

%{
    /* 
     * Following is a little tricky. To be able to access 32bit / 64bit keys
     * we need to use RegDeleteKeyExW() which not however available on (old)\
     * 32bit Windows XP. Yet we'd like Smalltalk/X to run on those. 
     *
     * To do so, call RegDeleteKeyExW() indirectly via a function pointer
     * obtained by GetProcAddress(). If GetProcAddress() fails - meaning 
     * we're running on such old Windows - we call old RegDeleteKeyW(). 
     */
    static int initialized = 0;
    static LONG (WINAPI *RegDeleteKeyExWPtr)(HKEY hKey, LPCTSTR lpSubKey, REGSAM  samDesired, DWORD   Reserved) = NULL;
    if (!initialized) {
        initialized = 1;
        HMODULE advapi32 = LoadLibrary("advapi32.dll");
        if (!advapi32) {
            /* 
             * Hmm, failed to load Advapi32.dll, can this happen?
             */            
            errorNumber = __MKSMALLINT(GetLastError());
            goto out;
        }
        RegDeleteKeyExWPtr = GetProcAddress(advapi32, "RegDeleteKeyExW");        
    }    
    
    HKEY myKey, subKey = 0;
    int _retVal;
    int _flags = 0;

    if (flags != nil) {
	if (flags == @symbol(KEY_WOW64_64KEY)) {
	    _flags = KEY_WOW64_64KEY;
	} else if (flags == @symbol(KEY_WOW64_32KEY)) {
	    _flags = KEY_WOW64_32KEY;
	} else {
	    errorNumber = @symbol(badArgument2);
	    goto out;
	}
    }

    if (__isExternalAddressLike(__INST(handle))
     && __isUnicode16String(subKeyStringZ)) {
	myKey = (HKEY)__externalAddressVal(__INST(handle));
	if (RegDeleteKeyExWPtr) {
	    _retVal = RegDeleteKeyExWPtr(myKey,
		                      __unicode16StringVal(subKeyStringZ),
		                      _flags,
		                      0); // reserved	
	} else {
	    /* 
	     * Some old Windows without RegDeleteKeyExW() such as
	     * 32bit Windows XP. 
	     * In that case, try hard and call RegDeleteKeyW() - but only
	     * if no flags are passed, i.e., `flags` parameter is nil.
	     * This is to avoid silent failures when one explicitly asks
	     * for 32bit or 64bit view on Windows that does not support 
	     * RegDeleteKeyExW().
	     */
	    if (flags != nil) {
	        errorNumber = __MKSMALLINT(-1); // really stupid, should do better
	        goto out;
	    }
	    _retVal = RegDeleteKeyW(myKey, __unicode16StringVal(subKeyStringZ));    
	}
	if (_retVal == ERROR_SUCCESS) {
	    RETURN (true);
	}
	if ((_retVal != ERROR_PATH_NOT_FOUND)
	 && (_retVal != ERROR_FILE_NOT_FOUND)) {
	    errorNumber = __MKSMALLINT(_retVal);
	}
    }
out:;
%}.

    errorNumber notNil ifTrue:[
        errorNumber == -1 ifTrue:[
            self primitiveFailed: '32/64bit registry view requested but no RegDeleteKeyExW(). Windows too old?'
        ] ifFalse:[
	    (OperatingSystem errorHolderForNumber:errorNumber) reportError.
        ]
    ].
    ^ false

    "
     |top sub|

     top := self key:'HKEY_CURRENT_USER'.
     sub := top createSubKeyNamed:'FooBarBaz'.
     top deleteSubKeyNamed:'FooBarBaz' flags:nil.
    "
!

remoteKeyOnHost:hostName
    "return the corresponding registry entry from
     a remote computers registry."

    |newEntry remoteHandle errorNumber|

%{
    HKEY myKey, remoteKey = 0;
    int _retVal;

    if (__isExternalAddressLike(__INST(handle)) && __isStringLike(hostName)) {
	myKey = (HKEY)__externalAddressVal(__INST(handle));
	if ((_retVal = RegConnectRegistryA(__stringVal(hostName), myKey, &remoteKey)) == ERROR_SUCCESS) {
	    remoteHandle = __MKEXTERNALADDRESS(remoteKey);
	} else {
	    if ((_retVal != ERROR_PATH_NOT_FOUND)
	     && (_retVal != ERROR_FILE_NOT_FOUND)) {
		errorNumber = __MKSMALLINT(_retVal);
	    }
	}
    }
%}.
    remoteHandle notNil ifTrue:[
	newEntry := self class basicNew setHandle:remoteHandle path:path.
	newEntry registerForFinalization.
	^ newEntry.
    ].
    errorNumber notNil ifTrue:[
	(OperatingSystem errorHolderForNumber:errorNumber) reportError.
    ].
    ^ nil

    "
     |top remote|

     top := self key:'HKEY_LOCAL_MACHINE'.
     remote := top remoteKeyOnHost:'BETTI'
    "
    "
     |top remote|

     top := self key:'HKEY_USERS'.
     remote := top remoteKeyOnHost:'BETTI'
    "
    "
     |top remote|

     top := self key:'HKEY_LOCAL_MACHINE'.
     remote := top remoteKeyOnHost:'JOSHUA'
    "
    "
     |top remote|

     top := self key:'HKEY_USERS'.
     remote := top remoteKeyOnHost:'JOSHUA'
    "
!

subKeyAtIndex:subKeyIndex
    "return a new registry entry below mySelf for the given subKey index.
     Return nil if no such key exists"

    |subKeyName subKeyClassName errorNumber|

%{
    HKEY myKey, subKey = 0;
    char nameBuffer[256];
    DWORD nameSize = sizeof(nameBuffer) - 1;
    char classNameBuffer[256];
    DWORD classNameSize = sizeof(classNameBuffer) - 1;
    FILETIME modificationTime;
    int _retVal;

    if (__isExternalAddressLike(__INST(handle))
     && __isSmallInteger(subKeyIndex)) {
	myKey = (HKEY)__externalAddressVal(__INST(handle));
	if ((_retVal = RegEnumKeyExA(myKey, __intVal(subKeyIndex),
			 nameBuffer, &nameSize,
			 NULL,
			 classNameBuffer, &classNameSize,
			 &modificationTime)) == ERROR_SUCCESS) {
	    nameBuffer[nameSize] = '\0';
	    classNameBuffer[classNameSize] = '\0';
	    subKeyName = __MKSTRING(nameBuffer);
	    subKeyClassName = __MKSTRING(classNameBuffer);
	} else {
	    if ((_retVal != ERROR_PATH_NOT_FOUND)
	     && (_retVal != ERROR_FILE_NOT_FOUND)
	     && (_retVal != ERROR_NO_MORE_ITEMS)) {
		errorNumber = __MKSMALLINT(_retVal);
	    }
	}
    }
%}.
    subKeyName notNil ifTrue:[
	^ self subKeyNamed:subKeyName.
    ].
    errorNumber notNil ifTrue:[
	(OperatingSystem errorHolderForNumber:errorNumber) reportError.
    ].
    ^ nil

    "
     |top sub|

     top := self key:'HKEY_LOCAL_MACHINE'.
     sub := top subKeyAtIndex:0
    "
!

subKeyNameAndClassAtIndex:subKeyIndex
    "return the name and className of the given subKey at index as a pair.
     Return nil if no such key exists"

    |subKeyName subKeyClassName errorNumber|

%{
    HKEY myKey, subKey = 0;
    char nameBuffer[256];
    DWORD nameSize = sizeof(nameBuffer) - 1;
    char classNameBuffer[256];
    DWORD classNameSize = sizeof(classNameBuffer) - 1;
    FILETIME modificationTime;
    int _retVal;

    if (__isExternalAddressLike(__INST(handle))
     && __isSmallInteger(subKeyIndex)) {
	myKey = (HKEY)__externalAddressVal(__INST(handle));
	if ((_retVal = RegEnumKeyExA(myKey, __intVal(subKeyIndex),
			 nameBuffer, &nameSize,
			 NULL,
			 classNameBuffer, &classNameSize,
			 &modificationTime)) == ERROR_SUCCESS) {
	    nameBuffer[nameSize] = '\0';
	    classNameBuffer[classNameSize] = '\0';
	    subKeyName = __MKSTRING(nameBuffer);
	    subKeyClassName = __MKSTRING(classNameBuffer);
	} else {
	    if ((_retVal != ERROR_PATH_NOT_FOUND)
	     && (_retVal != ERROR_FILE_NOT_FOUND)
	     && (_retVal != ERROR_NO_MORE_ITEMS)) {
		errorNumber = __MKSMALLINT(_retVal);
	    }
	}
    }
%}.
    subKeyName notNil ifTrue:[
	^ {subKeyName . subKeyClassName}.
    ].
    errorNumber notNil ifTrue:[
	(OperatingSystem errorHolderForNumber:errorNumber) reportError.
    ].
    ^ nil

    "
     |top sub|

     top := self key:'HKEY_LOCAL_MACHINE'.
     sub := top subKeyNameAndClassAtIndex:0
    "
!

subKeyNamed:subKeyString
    "return a new registry entry below mySelf with the given subKey.
     Return nil if no such key exists"

    ^ self subKeyNamed:subKeyString flags:nil createIfAbsent:false

    "
     |top sub|

     top := self key:'HKEY_LOCAL_MACHINE'.
     sub := top subKeyNamed:'Software'
    "
!

subKeyNamed:subKeyString createIfAbsent:createIfAbsent
    "return a new registry entry below mySelf with the given subKey.
     If no such key exists and createIfAbsent is true, the key is created.
     Otherwise, nil is returned"

    ^ self subKeyNamed:subKeyString flags:nil createIfAbsent:createIfAbsent
!

subKeyNamed:subKeyString flags:flags
    "return a new registry entry below mySelf with the given subKey.
     Return nil if no such key exists.
     flags may be one of:
	#KEY_WOW64_64KEY to force access to the 64Bit Windows key,
	#KEY_WOW64_32KEY to force access to the 32Bit Windows key,
	or nil, to access the key (32/64) for the current application"


    ^ self subKeyNamed:subKeyString flags:flags createIfAbsent:false
!

subKeyNamed:subKeyString flags:flags createIfAbsent:createIfAbsent
    "return a new registry entry below mySelf with the given subKey.
     If no such key exists and createIfAbsent is true, the key is created.
     Otherwise, nil is returned.
     flags may be one of:
	#KEY_WOW64_64KEY to force access to the 64Bit Windows key,
	#KEY_WOW64_32KEY to force access to the 32Bit Windows key,
	or nil, to access the key (32/64) for the current application"

    |subKeyStringZ newEntry subHandle errorNumber disposition|

    subKeyStringZ := subKeyString asUnicode16StringZ.

%{
#ifndef KEY_WOW64_64KEY
// this is missing in BCC header files
# define KEY_WOW64_64KEY    0x0100
# define KEY_WOW64_32KEY    0x0200
#endif

    HKEY myKey, subKey = 0;
    int _retVal;
    int _flags = 0;
    int _disposition = 0;

    if (flags != nil) {
	if (flags == @symbol(KEY_WOW64_64KEY)) {
	    _flags = KEY_WOW64_64KEY;
	} else if (flags == @symbol(KEY_WOW64_32KEY)) {
	    _flags = KEY_WOW64_32KEY;
	} else {
	    errorNumber = @symbol(badArgument2);
	    goto out;
	}
    }

    if (__isExternalAddressLike(__INST(handle))
	&& __isUnicode16String(subKeyStringZ)) {
	myKey = (HKEY)__externalAddressVal(__INST(handle));
	if (createIfAbsent == true) {
	    _retVal = RegCreateKeyExW(myKey,
			__unicode16StringVal(subKeyStringZ),
			0,      // reserved
			NULL,   // class
			0,      // options
			KEY_ALL_ACCESS|_flags,   // rights
			NULL,   // securityAttributes - handle cannot be inherited
			&subKey,
			&_disposition);  // disposition (created vs. opened)
	    disposition = _disposition == REG_CREATED_NEW_KEY ? true : false;
	} else {
	    _retVal = RegOpenKeyExW(
		myKey,
		__unicode16StringVal(subKeyStringZ),
		0,
		KEY_ALL_ACCESS|_flags,
		&subKey);

	    if (!(_retVal == 0)) {
		// try again with less permission
		_retVal = RegOpenKeyExW(
		    myKey,
		    __unicode16StringVal(subKeyStringZ),
		    0,
		    KEY_READ |_flags,
		    &subKey);
	    }

	    disposition = false;
	}
	if (_retVal == ERROR_SUCCESS) {
	    subHandle = __MKEXTERNALADDRESS(subKey);
	} else {
	    if ((_retVal != ERROR_PATH_NOT_FOUND)
	     && (_retVal != ERROR_FILE_NOT_FOUND)) {
		errorNumber = __MKSMALLINT(_retVal);
	    }
	}
    }
out:;
%}.
    subHandle notNil ifTrue:[
	newEntry := self class basicNew
			setHandle:subHandle
			path:((path ? '?') , self class separator asString , subKeyString)
			isNew:disposition.

	newEntry registerForFinalization.
	^ newEntry.
    ].
    errorNumber notNil ifTrue:[
	(OperatingSystem errorHolderForNumber:errorNumber) reportProceedableError.
    ].
    ^ nil

    "
     |top sub|

     top := self key:'HKEY_LOCAL_MACHINE'.
     sub := top subKeyNamed:'Software' flags:nil createIfAbsent:false

     |top sub|

     top := self key:'HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit'.
     top valueNamed:'CurrentVersion'.
     sub := top subKeyNamed:'1.8' flags:#KEY_WOW64_64KEY createIfAbsent:false.
    "
! !

!Win32OperatingSystem::RegistryEntry methodsFor:'accessing values'!

defaultValue
    ^ self valueNamed:''

    "
     (self key:'HKEY_CLASSES_ROOT\MicrosoftWorks.WordProcessor\CLSID') defaultValue
    "
!

defaultValue:datum
    "store a value; the value type depends upon the stored value:
	ByteArray       -> REG_BINARY
	String          -> REG_SZ
	Array of string -> REG_MULTI_SZ
	Integer         -> REG_DWORD
	nil             -> REG_NONE
    "

    ^ self valueNamed:'' put:datum

    "
     (self key:'HKEY_CLASSES_ROOT\MicrosoftWorks.WordProcessor\CLSID') defaultValue
    "
!

deleteValueNamed:aValueName
    "delete a value.
     Return true on success."

    |errorNumber|

%{
    HKEY myKey;
    int _retVal;

    if (__isExternalAddressLike(__INST(handle))
     && __isStringLike(aValueName)) {
	myKey = (HKEY)__externalAddressVal(__INST(handle));
	if ((_retVal = RegDeleteValueA(myKey, __stringVal(aValueName))) == ERROR_SUCCESS) {
	    RETURN (true);
	}
	if ((_retVal != ERROR_PATH_NOT_FOUND)
	 && (_retVal != ERROR_FILE_NOT_FOUND)) {
	    errorNumber = __MKSMALLINT(_retVal);
	}
    }
%}.
    errorNumber notNil ifTrue:[
	(OperatingSystem errorHolderForNumber:errorNumber) reportError.
    ].
    ^ false
!

valueNameAtIndex:valueIndex
    "return a values name for the given value index.
     Return nil if no such value exists"

    |valueName errorNumber|

%{
    HKEY myKey;
    char nameBuffer[256];
    DWORD nameSize = sizeof(nameBuffer) - 1;
    DWORD valueType;
    int _retVal;

    if (__isExternalAddressLike(__INST(handle))
     && __isSmallInteger(valueIndex)) {
	myKey = (HKEY)__externalAddressVal(__INST(handle));
	if ((_retVal = RegEnumValueA(myKey, __intVal(valueIndex),
			 nameBuffer, &nameSize,
			 NULL,
			 &valueType,
			 NULL, NULL)) == ERROR_SUCCESS) {
	    nameBuffer[nameSize] = '\0';
	    valueName = __MKSTRING(nameBuffer);
	} else {
	    if ((_retVal != ERROR_PATH_NOT_FOUND)
	     && (_retVal != ERROR_FILE_NOT_FOUND)
	     && (_retVal != ERROR_NO_MORE_ITEMS)) {
		errorNumber = __MKSMALLINT(_retVal);
	    }
	}
    }
%}.
    errorNumber notNil ifTrue:[
	(OperatingSystem errorHolderForNumber:errorNumber) reportError.
    ].
    ^ valueName

    "
     |top sub|

     top := self key:'HKEY_LOCAL_MACHINE'.
     sub := top subKeyAtIndex:0
    "
!

valueNamed:aValueName
    "retrieve a value; the returned object depends upon the type:
	REG_BINARY      -> ByteArray
	REG_SZ          -> String
	REG_MULTI_SZ    -> Array of strings
	REG_DWORD       -> Integer
	REG_NONE        -> nil
    "

    |stringArray retVal errorNumber|

%{  /* STACK: 20000 */
    HKEY myKey;
    DWORD valueType;
    union {
	DWORD dWord;
	unsigned char dWordBytes[4];
	unsigned char smallDataBuffer[1024*16];
    } quickData;
    int val;
    DWORD dataSize = sizeof(quickData);
    unsigned char *dataBuffer = NULL;
#define xxUSE_UNICODE
#ifdef USE_UNICODE
# define xRegQueryValueEx  RegQueryValueExW
# define CHAR             short
#else
# define RegQueryValueEx  RegQueryValueExA
# define CHAR             char
#endif

    if (__isExternalAddressLike(__INST(handle))
     && __isStringLike(aValueName)) {
	int ret;

	myKey = (HKEY)__externalAddressVal(__INST(handle));

	/*
	 * try to get it with one call ...
	 */
	ret = RegQueryValueExA(myKey, __stringVal(aValueName),
			 NULL,
			 &valueType,
			 (char *)&quickData,
			 &dataSize);
#if 0
	console_printf("get \"%s\": dataSize=%d ret=%d\n", __stringVal(aValueName), dataSize, ret);
#endif
	while (ret == ERROR_MORE_DATA) {
#if 0
	    console_printf("ERROR_MORE_DATA dataSize=%d valueType=%d\n", dataSize, valueType);
#endif
	    /*
	     * nope - need another one ...
	     */
	    if (myKey = HKEY_PERFORMANCE_DATA) {
		dataSize = dataSize * 2;
	    }
	    switch (valueType) {
		case REG_BINARY:
		case REG_MULTI_SZ:
		    dataBuffer = malloc(dataSize);;
		    break;
		case REG_SZ:
		    dataBuffer = malloc(dataSize);
		    break;
		default:
		    console_printf("RegistryEntry [warning]: unhandled valueType: %d\n", valueType);
		    break;
	    }
	    if (dataBuffer) {
		ret = RegQueryValueEx(myKey, __stringVal(aValueName),
				 NULL,
				 &valueType,
				 dataBuffer,
				 &dataSize);
	    } else {
		break;
	    }
	    if (myKey != HKEY_PERFORMANCE_DATA) {
		if (ret != ERROR_SUCCESS) break;
	    }
	}

	if (ret == ERROR_SUCCESS) {
#if 0
	    console_printf("ERROR_SUCCESS dataSize=%d valueType=%d\n", dataSize, valueType);
#endif
	    switch (valueType) {
		case REG_NONE:
		    /* RETURN (@symbol(none));  */
		    retVal = nil;
		    break;

		case REG_BINARY:
		    retVal = __MKBYTEARRAY(dataBuffer ? dataBuffer : quickData.smallDataBuffer, dataSize);
		    break;

		case REG_SZ:
		case REG_EXPAND_SZ:
#ifdef USE_UNICODE
		    retVal = __MKU16STRING(dataBuffer ? dataBuffer : quickData.smallDataBuffer);
#else
		    retVal = __MKSTRING(dataBuffer ? dataBuffer : quickData.smallDataBuffer);
#endif
		    break;

#if 0
		case REG_DWORD:
		    /* int in native format */
		    retVal = __MKUINT(quickData.dWord);
		    break;
#endif
		case REG_DWORD_LITTLE_ENDIAN:
		    val = quickData.dWordBytes[3];
		    val = (val << 8) | quickData.dWordBytes[2];
		    val = (val << 8) | quickData.dWordBytes[1];
		    val = (val << 8) | quickData.dWordBytes[0];
		    retVal = __MKUINT(val);
		    break;

		case REG_DWORD_BIG_ENDIAN:
		    val = quickData.dWordBytes[0];
		    val = (val << 8) | quickData.dWordBytes[1];
		    val = (val << 8) | quickData.dWordBytes[2];
		    val = (val << 8) | quickData.dWordBytes[3];
		    retVal = __MKUINT(val);
		    break;

		case REG_MULTI_SZ:
		    {
			CHAR *cp, *cp0;
			int ns, i;

			cp0 = dataBuffer ? dataBuffer : quickData.smallDataBuffer;
#if 0
			console_printf("**************\n");
			for (i=0;i<50;i++) {
			  console_printf("%x ", cp0[i]);
			}
			console_printf("\n");
			for (i=0;i<50;i++) {
			  if (cp0[i] == 0)
			    console_printf("\n");
			  else
			    console_printf("%c", cp0[i]);
			}
			console_printf("\n");
			console_printf("**************\n");
#endif
			cp = cp0;
			ns = 0;
			while (*cp) {
			    while (*cp++) ;;
			    ns++;
			}
			stringArray = __ARRAY_NEW_INT(ns);

			i = 0;
			while (*cp0) {
			    OBJ s;
			    CHAR *cp;

			    cp = cp0;
			    while (*cp++) ;;
#ifdef USE_UNICODE
			    s = __MKU16STRING(cp0); __ArrayInstPtr(stringArray)->a_element[i] = s; __STORE(stringArray, s);
#else
			    s = __MKSTRING(cp0); __ArrayInstPtr(stringArray)->a_element[i] = s; __STORE(stringArray, s);
#endif
			    cp0 = cp;
			    i++;
			}
			retVal = stringArray;
			break;
		    }
		default:
		    console_printf("RegistryEntry [warning]: unhandled valueType: %d\n", valueType);
		    break;
	    }
	} else {
	    if ((ret != ERROR_PATH_NOT_FOUND)
	     && (ret != ERROR_FILE_NOT_FOUND)) {
		errorNumber = __MKSMALLINT(ret);
	    }
	}
    }
    if (dataBuffer) free(dataBuffer);
%}.
    errorNumber notNil ifTrue:[
	(OperatingSystem errorHolderForNumber:errorNumber) reportError.
    ].

    ^ retVal

    "
     |key|

     key := self key:'HKEY_LOCAL_MACHINE\SOFTWARE\eXept\Smalltalk/X'.
     key valueNamed:'CurrentVersion'
    "
!

valueNamed:aValueName put:datum
    "store a value; the value type depends upon the stored value:
	ByteArray       -> REG_BINARY
	String          -> REG_SZ
	Array of string -> REG_MULTI_SZ
	Integer         -> REG_DWORD
	nil             -> REG_NONE
    "

    |data stringArray errorNumber|
%{
    HKEY myKey;
    DWORD valueType = -1;
    int val;
    DWORD dataSize = -1;
    unsigned char *dataPointer = NULL;
    int datumOk = 1, mustFreeData = 0;

    if (__isExternalAddressLike(__INST(handle))
     && __isStringLike(aValueName)) {
	int ret;
	OBJ cls;

	myKey = (HKEY)__externalAddressVal(__INST(handle));

	if (datum == nil) {
	    valueType = REG_NONE;
	    dataSize = 0;
	} else if (__isSmallInteger(datum)) {
	    valueType = REG_DWORD;
	    val = __intVal(datum);
	    dataPointer = (unsigned char *)(&val);
	    dataSize = sizeof(val);
	} else if (__isStringLike(datum)) {
	    valueType = REG_SZ;
	    dataPointer = __stringVal(datum);
	    dataSize = __stringSize(datum) + 1;
	} else if (__Class(datum) == ByteArray) {
	    valueType = REG_BINARY;
	    dataPointer = __ByteArrayInstPtr(datum)->ba_element;
	    dataSize = __byteArraySize(datum);
	} else if (__Class(datum) == LargeInteger) {
	    valueType = REG_DWORD;
	    val = __longIntVal(datum);
	    if (val) {
		dataPointer = (unsigned char *)(&val);
		dataSize = sizeof(val);
	    } else {
		datumOk = 0;
	    }
	} else if (__Class(datum) == Array) {
	    int i = 0, ns = 0, totalSize = 0;

	    valueType = REG_MULTI_SZ;

	    /*
	     * must allocate a local buffer
	     * find size ...
	     */
	    for (i=0; i<__arraySize(datum); i++) {
		OBJ s = __ArrayInstPtr(datum)->a_element[i];

		if (__isStringLike(s)) {
		    totalSize += __stringSize(s) + 1;
		} else {
		    datumOk = 0;
		    break;
		}
		ns++;
	    }
	    if (datumOk) {
		char *cp;

		/*
		 * allocate and fill...
		 */
		totalSize ++;
		dataPointer = (char *)(malloc(totalSize));
		mustFreeData = 1;
		cp = dataPointer;
		for (i=0; i<__arraySize(datum); i++) {
		    OBJ s = __ArrayInstPtr(datum)->a_element[i];

		    strcpy(cp, __stringVal(s));
		    cp += __stringSize(s);
		    *cp++ = '\0';
		}
		*cp++ = '\0';
		dataSize = totalSize;
	    }
	} else {
	    datumOk = 0;
	}

	if (datumOk) {
	    ret = RegSetValueExA(myKey, __stringVal(aValueName),
				0, valueType,
				dataPointer, dataSize);
	    if (mustFreeData) {
		free(dataPointer);
	    }
	    if (ret == ERROR_SUCCESS) {
		RETURN (true);
	    }
	    if ((ret != ERROR_PATH_NOT_FOUND)
	     && (ret != ERROR_FILE_NOT_FOUND)) {
		errorNumber = __MKSMALLINT(ret);
	    }
	}
    }
%}.
    errorNumber notNil ifTrue:[
	(OperatingSystem errorHolderForNumber:errorNumber) reportError.
    ].
    ^ false

    "
     |key|

     key := self key:'HKEY_LOCAL_MACHINE\SOFTWARE\eXept\Smalltalk/X'.
     key valueNamed:'CurrentVersion' put:'3.5.2'
    "
! !

!Win32OperatingSystem::RegistryEntry methodsFor:'enumeration'!

allSubKeysDo:aBlock
    "recursively evaluate aBlock for all subKeys below the receiver"

    |idx subEntry|

    idx := 0.
    [true] whileTrue:[
	subEntry := self subKeyAtIndex:idx.
	subEntry isNil ifTrue:[
	    ^self
	].
	aBlock value:subEntry.
	subEntry allSubKeysDo:aBlock.
	subEntry close.
	idx := idx + 1.
    ]

    "
     |top sub|

     top := self key:'HKEY_LOCAL_MACHINE'.
     top allSubKeysDo:[:subEntry |
	Transcript showCR:subEntry path
     ]
    "
!

subKeyNamesAndClassesDo:aTwoArgBlock
    "evaluate aBlock for all subKeys names and class names below the receiver"

    |idx nameAndClassNameOrNil|

    idx := 0.
    [true] whileTrue:[
	nameAndClassNameOrNil := self subKeyNameAndClassAtIndex:idx.
	nameAndClassNameOrNil isNil ifTrue:[
	    ^self
	].
	aTwoArgBlock value:nameAndClassNameOrNil first value:nameAndClassNameOrNil second.
	idx := idx + 1.
    ]

    "
     |top sub|

     top := self key:'HKEY_LOCAL_MACHINE'.
     top subKeyNamesAndClassesDo:[:nm :cls |
	Transcript showCR:('name: ',nm,' class: ',cls)
     ]
    "
!

subKeys
    "return a collection of subKeys below the receiver"

    |idx subEntry subKeys|

    subKeys := OrderedCollection new.
    self subKeysDo:[:k | subKeys add:k].
    ^ subKeys

    "
     |top sub|

     top := self key:'HKEY_LOCAL_MACHINE'.
     top subKeys
    "

    "Created: / 23.12.1999 / 22:15:22 / cg"
    "Modified: / 23.12.1999 / 22:15:44 / cg"
!

subKeysDo:aBlock
    "evaluate aBlock for all subKeys below the receiver"

    |idx subEntry|

    idx := 0.
    [true] whileTrue:[
	subEntry := self subKeyAtIndex:idx.
	subEntry isNil ifTrue:[
	    ^self
	].
	aBlock value:subEntry.
	subEntry close.
	idx := idx + 1.
    ]

    "
     |top sub|

     top := self key:'HKEY_LOCAL_MACHINE'.
     top subKeysDo:[:subEntry |
	Transcript showCR:subEntry path
     ]
    "
    "
     |top sub|

     top := self key:'HKEY_LOCAL_MACHINE'.
     OSErrorHolder noPermissionsSignal handle:[:ex |
	ex proceed
     ] do:[
	 top subKeysDo:[:subEntry |
	    Transcript showCR:subEntry path
	 ]
     ]
    "
!

valueNames
    "evaluate aBlock for all value names"

    ^ Array streamContents:[:s |
	self valueNamesDo:[:nm | s nextPut:nm]
    ].

    "Created: / 18-01-2011 / 20:24:52 / cg"
!

valueNamesAndValuesDo:aBlock
    "evaluate aBlock for all value names"

    self valueNamesDo:[:nm |
	aBlock value:nm value:(self valueNamed:nm)
    ]

    "
     |key|

     key := self key:'HKEY_LOCAL_MACHINE\SOFTWARE\eXept\Smalltalk/X'.
     key valueNamesAndValuesDo:[:nm :val |
	Transcript showCR:(nm , ' -> ' , val storeString).
     ]
    "
!

valueNamesDo:aBlock
    "evaluate aBlock for all value names"

    |idx valueName|

    idx := 0.
    [true] whileTrue:[
	valueName := self valueNameAtIndex:idx.
	valueName isNil ifTrue:[
	    ^self
	].
	aBlock value:valueName.
	idx := idx + 1.
    ]
! !

!Win32OperatingSystem::RegistryEntry methodsFor:'instance release'!

close
    "close mySelf"

    self closeKey.
    self unregisterForFinalization.
!

closeKey
    "close mySelf"

%{
    HKEY myKey;

    if (__isExternalAddressLike(__INST(handle))) {
	myKey = (HKEY)(__externalAddressVal(__INST(handle)));
	__INST(handle) = nil;
	RegCloseKey(myKey);
    }
%}
!

finalizationLobby
    ^ Lobby
!

finalize
    "some entry has been collected - close it"

    handle notNil ifTrue:[
	self closeKey.
    ]

    "Created: / 19.5.1999 / 22:39:52 / cg"
    "Modified: / 19.5.1999 / 22:44:50 / cg"
! !

!Win32OperatingSystem::RegistryEntry methodsFor:'printing & storing'!

printOn:aStream
    aStream
	nextPutAll:self className;
	nextPut:$(;
	nextPutAll:path;
	nextPut:$).
! !

!Win32OperatingSystem::RegistryEntry methodsFor:'private'!

setHandle:aHandle path:aPathString
    handle := aHandle.
    path := aPathString.

    "Created: / 19.5.1999 / 22:27:05 / cg"
!

setHandle:aHandle path:aPathString isNew:disposition
    handle := aHandle.
    path := aPathString.
    isNew := disposition.

    "Created: / 19.5.1999 / 22:27:05 / cg"
!

setupForHandleValue:integerHandleValue
    "not normally used - given an integer address,
     return a registry entry. This is provided to
     allow for future root keys to be added at the smalltalk level"

%{
    HKEY key;
    OBJ t;

    key = (HKEY)__longIntVal(integerHandleValue);
    if (! key) {
	RETURN (nil);
    }

    t = __MKEXTERNALADDRESS(key); __INST(handle) = t; __STORE(self, t);
%}.

    "Created: / 19.5.1999 / 21:45:05 / cg"
! !

!Win32OperatingSystem::TextMetricsStructure class methodsFor:'instance creation'!

new

^super new: self sizeInBytes

    "Created: / 02-08-2006 / 16:20:02 / fm"
!

sizeInBytes

  ^53

    "Created: / 02-08-2006 / 16:20:09 / fm"
! !

!Win32OperatingSystem::TextMetricsStructure methodsFor:'accessing'!

tmDefaultChar
    ^self byteAt: 46 + 1

    "Created: / 02-08-2006 / 16:15:35 / fm"
!

tmExternalLeading
    ^self longAt: 16 + 1

    "Created: / 02-08-2006 / 16:17:11 / fm"
!

tmHeight
    ^self longAt: 0 + 1

    "Created: / 02-08-2006 / 16:16:38 / fm"
! !

!Win32OperatingSystem::Win32ChangeNotificationHandle class methodsFor:'documentation'!

documentation
"
    I represent a handle on change notifications (directory changes).
    I can be waited upon in a WaitForHandle / WaitForMultipleObjects call.
"
! !

!Win32OperatingSystem::Win32ChangeNotificationHandle methodsFor:'release'!

close
    "close the handle"

    self closeHandle.
    self unregisterForFinalization.
! !

!Win32OperatingSystem::Win32IOHandle class methodsFor:'documentation'!

documentation
"
    I represent a handle on which I/O is possible.
    Typical instances are File-Handles, Socket-Handles etc.
"
! !

!Win32OperatingSystem::Win32IOHandle methodsFor:'io'!

readBytes:count into:aByteBuffer startingAt:firstIndex
    "read count bytes into a byte-buffer;
     Return the number of bytes read (negative on error)"

    |errSym errorNumber|

%{
    unsigned char *extPtr;
    int bufferIsExternalBytes;
    int mustFreeBuffer = 0;
    int nRead = -1;
    HANDLE hFile = (HANDLE)(__externalAddressVal(self));
    DWORD cntWanted, offs, cntRead;
    int bufferSize;
    char miniBuffer[32];
    int ok;

    if ((hFile == 0) || (hFile == INVALID_HANDLE_VALUE)) {
	errSym = @symbol(errorNotOpen);
	goto bad;
    }
    if (! __bothSmallInteger(count, firstIndex)) {
	errSym = @symbol(badArgument);
	goto bad;
    }
    cntWanted = __smallIntegerVal(count);
    if (cntWanted <= 0) {
	errSym = @symbol(badCount);
	goto bad;
    }
    offs = __smallIntegerVal(firstIndex) - 1;
    if (offs < 0) {
	errSym = @symbol(badOffset);
	goto bad;
    }

    bufferIsExternalBytes = __isExternalBytesLike(aByteBuffer);
    if (! bufferIsExternalBytes) {
	if (__isByteArray(aByteBuffer)) {
	    bufferSize = __byteArraySize(aByteBuffer);
	} else if (__isString(aByteBuffer)) {  // not isStringLike here !
	    bufferSize = __stringSize(aByteBuffer);
	} else {
	    errSym = @symbol(badBuffer);
	    goto bad;
	}
	if (bufferSize < (cntWanted + offs)) {
	    errSym = @symbol(badBufferSize);
	    goto bad;
	}
	if (cntWanted <= sizeof(miniBuffer)) {
	    extPtr = miniBuffer;
	} else {
	    extPtr = malloc(cntWanted);
	    mustFreeBuffer = 1;
	}
    } else {
	OBJ sz;

	extPtr = (char *)(__externalBytesAddress(aByteBuffer));
	if (extPtr == NULL) goto bad;
	sz = __externalBytesSize(aByteBuffer);
	if (! __isSmallInteger(sz)) {
	    errSym = @symbol(badBufferSize);
	    goto bad;
	}
	bufferSize = __smallIntegerVal(sz);
	if (bufferSize < (cntWanted + offs)) {
	    errSym = @symbol(badBufferSize);
	    goto bad;
	}
	extPtr = extPtr + offs;
    }

    do {
	__threadErrno = 0;
	// do not cast to INT - will loose sign bit then!
	ok = (int)(STX_API_NOINT_CALL5( "ReadFile", ReadFile, hFile, extPtr, cntWanted, &cntRead, 0 /* lpOverlapped */));
    } while(__threadErrno == EINTR);

    if (ok == TRUE) {
	if (! bufferIsExternalBytes) {
	    /* copy over */
	    memcpy(__byteArrayVal(aByteBuffer)+offs, extPtr, cntRead);
	    if (mustFreeBuffer) {
		free(extPtr);
	    }
	}
	RETURN (__mkSmallInteger(cntRead));
    }
    errorNumber = __mkSmallInteger( __WIN32_ERR(GetLastError()) );

bad: ;
    if (mustFreeBuffer) {
	free(extPtr);
    }
%}.

    errorNumber isNil ifTrue:[
	self error:'invalid argument(s): ', errSym.
    ] ifFalse:[
	(OperatingSystem errorHolderForNumber:errorNumber) reportError
    ].

    "
     |h buff n|

     h := self basicNew.
     buff := ByteArray new:10.
     n := h readBytes:10 into:buff startingAt:1.
     Transcript show:n; show:' '; showCR:buff.
    "
!

readWaitWithTimeoutMs:millis
    "return true if a timeout occurred"

    |errSym errorNumber|

%{
    HANDLE hFile = (HANDLE)(__externalAddressVal(self));
    DWORD res;
    INT t;

    if ((hFile == 0) || (hFile == INVALID_HANDLE_VALUE)) {
	errSym = @symbol(errorNotOpen);
	goto bad;
    }

#if 0
    if (ioctlsocket((SOCKET)hFile, FIONREAD, &res)==0) {
	/* its a socket */
	if (res > 0) {
	    RETURN ( false );
	}
    }
    if (PeekNamedPipe(hFile, 0, 0, 0, &res, 0)) {
	/* its a namedPipe */
	if (res > 0) {
	    RETURN ( false );
	}
    }
#endif
    if (__isSmallInteger(millis)) {
	t = __intVal(millis);
    } else {
	t = INFINITE;
    }

    do {
	__threadErrno = 0;
	res = WaitForSingleObject(hFile, t);
    } while (__threadErrno == EINTR);

    switch (res) {
	case WAIT_OBJECT_0:
	    /* signalled */
	    RETURN ( false );

	case WAIT_TIMEOUT:
	    /* signalled */
	    RETURN ( true );

	default:
	case WAIT_ABANDONED:
	    errorNumber = __mkSmallInteger( __WIN32_ERR(GetLastError()) );
	    goto bad;
    }

bad: ;
%}.
    "
     timeout argument not integer,
     or any fd-array nonNil and not an array
     or not supported by OS
    "
    ^ self primitiveFailed
!

seekTo:newPosition from:whence
    "whence is one of:
	#begin
	#current
	#end
    "

    |errSym errorNumber|

%{
    HANDLE hFile = (HANDLE)(__externalAddressVal(self));
    DWORD moveHow;
    LONG posLo, posHi = 0;
    __uint64__ pos64, newPos64;

    if ((hFile == 0) || (hFile == INVALID_HANDLE_VALUE)) {
	errSym = @symbol(errorNotOpen);
	goto bad;
    }

    if (whence == @symbol(begin)) {
	moveHow = FILE_BEGIN;
    } else if (whence == @symbol(current)) {
	moveHow = FILE_CURRENT;
    } else if (whence == @symbol(end)) {
	moveHow = FILE_END;
    } else {
	errSym = @symbol(badArgument2);
	goto bad;
    }

    if (__signedLong64IntVal(newPosition, &pos64) == 0) {
	errSym = @symbol(badArgument);
	goto bad;
    }
#if __POINTER_SIZE__ == 8
    posLo = pos64 & 0xFFFFFFFF;
    posHi = (pos64 >> 32) & 0xFFFFFFFF;
#else
    posLo = pos64.lo;
    posHi = pos64.hi;
#endif
    posLo = SetFilePointer(hFile, posLo, &posHi, moveHow);
    if (posLo == 0xFFFFFFFF) {
	int lastError;

	/* can be either an error, or a valid low-word */
	lastError = GetLastError();
	if (lastError != NO_ERROR) {
	    errorNumber = __mkSmallInteger( __WIN32_ERR(lastError) );
	    goto bad;
	}
    }

    if (posHi == 0) {
	RETURN (__MKUINT( posLo ));
    }
#if __POINTER_SIZE__ == 8
    newPos64 = (__uint64__)posLo | ((__uint64__)posHi << 32);
    RETURN ( __MKUINT(newPos64) );
#else
    newPos64.lo = posLo;
    newPos64.hi = posHi;
    RETURN ( __MKUINT64(&newPos64) );
#endif

bad: ;
%}.

    errorNumber isNil ifTrue:[
	self error:'invalid argument(s): ', errSym.
    ] ifFalse:[
	(OperatingSystem errorHolderForNumber:errorNumber) reportError
    ].
!

writeBytes:count from:aByteBuffer startingAt:firstIndex
    "write count bytes from a byte-buffer;
     Return the number of bytes written (negative on error)"

    |errSym errorNumber|
%{
    unsigned char *extPtr;
    int bufferIsExternalBytes;
    int mustFreeBuffer = 0;
    int nWritten = -1;
    HANDLE hFile = (HANDLE)(__externalAddressVal(self));
    DWORD cntWanted, offs, cntWritten;
    int bufferSize;
    char miniBuffer[32];
    int ok;

    if ((hFile == 0) || (hFile == INVALID_HANDLE_VALUE)) {
	errSym = @symbol(errorNotOpen);
	goto bad;
    }
    if (! __bothSmallInteger(count, firstIndex)) {
	errSym = @symbol(badArgument);
	goto bad;
    }
    cntWanted = __smallIntegerVal(count);
    if (cntWanted <= 0) {
	errSym = @symbol(badCount);
	goto bad;
    }
    offs = __smallIntegerVal(firstIndex) - 1;
    if (offs < 0) {
	errSym = @symbol(badOffset);
	goto bad;
    }

    bufferIsExternalBytes = __isExternalBytesLike(aByteBuffer);
    if (! bufferIsExternalBytes) {
	if (__isByteArray(aByteBuffer)) {
	    bufferSize = __byteArraySize(aByteBuffer);
	} else if (__isStringLike(aByteBuffer)) {
	    bufferSize = __stringSize(aByteBuffer);
	} else {
	    errSym = @symbol(badBuffer);
	    goto bad;
	}
	if (bufferSize < (cntWanted + offs)) {
	    errSym = @symbol(badBufferSize);
	    goto bad;
	}
	if (cntWanted <= sizeof(miniBuffer)) {
	    extPtr = miniBuffer;
	} else {
	    extPtr = malloc(cntWanted);
	    mustFreeBuffer = 1;
	}
	memcpy(extPtr, __byteArrayVal(aByteBuffer)+offs, cntWanted);
    } else {
	extPtr = (char *)(__externalBytesAddress(aByteBuffer));
	if (extPtr == NULL) goto bad;
	bufferSize = __externalBytesSize(aByteBuffer);
	if (! __isSmallInteger(bufferSize)) {
	    errSym = @symbol(badBufferSize);
	    goto bad;
	}
	bufferSize = __smallIntegerVal(bufferSize);
	if (bufferSize < (cntWanted + offs)) {
	    errSym = @symbol(badBufferSize);
	    goto bad;
	}
	extPtr = extPtr + offs;
    }

    do {
	__threadErrno = 0;
	// do not cast to INT - will loose sign bit then!
	ok = (int)(STX_API_NOINT_CALL5( "WriteFile", WriteFile, hFile, extPtr, cntWanted, &cntWritten, 0 /* lpOverlapped */));
    } while(__threadErrno == EINTR);

    if (ok == TRUE) {
	if (mustFreeBuffer) {
	    free(extPtr);
	}
	RETURN (__mkSmallInteger(cntWritten));
    }
    errorNumber = __mkSmallInteger( __WIN32_ERR(GetLastError()) );

bad: ;
    if (mustFreeBuffer) {
	free(extPtr);
    }
%}.
    errorNumber isNil ifTrue:[
	self error:'invalid argument(s): ', errSym.
    ] ifFalse:[
	(OperatingSystem errorHolderForNumber:errorNumber) reportError
    ].

    "
     |h buff n|

     h := self basicNew.
     h setFileDescriptor:1.
     buff := '12345678901234567890'.
     n := h writeBytes:10 from:buff startingAt:1.
    "
! !

!Win32OperatingSystem::Win32IOHandle methodsFor:'release'!

close
    "close the file"

    self closeHandle.
    self unregisterForFinalization.
! !

!Win32OperatingSystem::Win32MutexHandle class methodsFor:'documentation'!

documentation
"
    I represent a mutex (can be used from more than a single OS processe).
    I can be waited upon in a WaitForHandle / WaitForMultipleObjects call.
"
! !

!Win32OperatingSystem::Win32NetworkResourceHandle class methodsFor:'accessing - types'!

displayTypeMappingTable
    "answer a Dictionary containing displayTypes symbols to integer mapping and vice versa"
    | symbTable |

    DisplayTypeMappingTable notNil ifTrue:[ ^ DisplayTypeMappingTable ].

    symbTable := Dictionary new.
%{
    __AT_PUT_(symbTable , @symbol(GENERIC),      __MKUINT( RESOURCEDISPLAYTYPE_GENERIC ) );
    __AT_PUT_(symbTable , @symbol(DOMAIN),       __MKUINT( RESOURCEDISPLAYTYPE_DOMAIN ) );
    __AT_PUT_(symbTable , @symbol(SERVER),       __MKUINT( RESOURCEDISPLAYTYPE_SERVER ) );
    __AT_PUT_(symbTable , @symbol(SHARE),        __MKUINT( RESOURCEDISPLAYTYPE_SHARE ) );
    __AT_PUT_(symbTable , @symbol(FILE),         __MKUINT( RESOURCEDISPLAYTYPE_FILE ) );
    __AT_PUT_(symbTable , @symbol(GROUP),        __MKUINT( RESOURCEDISPLAYTYPE_GROUP ) );
    __AT_PUT_(symbTable , @symbol(NETWORK),      __MKUINT( RESOURCEDISPLAYTYPE_NETWORK ) );
    __AT_PUT_(symbTable , @symbol(ROOT),         __MKUINT( RESOURCEDISPLAYTYPE_ROOT ) );
    __AT_PUT_(symbTable , @symbol(SHAREADMIN),   __MKUINT( RESOURCEDISPLAYTYPE_SHAREADMIN ) );
    __AT_PUT_(symbTable , @symbol(DIRECTORY),    __MKUINT( RESOURCEDISPLAYTYPE_DIRECTORY ) );
    __AT_PUT_(symbTable , @symbol(TREE),         __MKUINT( RESOURCEDISPLAYTYPE_TREE ) );
#ifdef RESOURCEDISPLAYTYPE_NDSCONTAINER
    __AT_PUT_(symbTable , @symbol(NDSCONTAINER), __MKUINT( RESOURCEDISPLAYTYPE_NDSCONTAINER ) );
#endif
%}.
    DisplayTypeMappingTable := Dictionary new.

    symbTable keysAndValuesDo:[:aSYMB :anINT |
	DisplayTypeMappingTable at: aSYMB put: anINT.
	DisplayTypeMappingTable at: anINT put: aSYMB. "/ vice versa
    ].
    ^ DisplayTypeMappingTable
!

scopeMappingTable
    "answer a Dictionary with scopes mapping symbol to integer and vice verca"
    | symbTable |

    ScopeMappingTable notNil ifTrue:[ ^ ScopeMappingTable].

    symbTable := Dictionary new.
%{
    __AT_PUT_(symbTable, @symbol(CONNECTED),  __MKUINT( RESOURCE_CONNECTED ) );
    __AT_PUT_(symbTable, @symbol(CONTEXT),    __MKUINT( RESOURCE_CONTEXT ) );
    __AT_PUT_(symbTable, @symbol(GLOBALNET),  __MKUINT( RESOURCE_GLOBALNET ) );
    __AT_PUT_(symbTable, @symbol(REMEMBERED), __MKUINT( RESOURCE_REMEMBERED ) );
    __AT_PUT_(symbTable, @symbol(RECENT),     __MKUINT( RESOURCE_RECENT ) );
%}.
    ScopeMappingTable := Dictionary new.

    symbTable keysAndValuesDo:[:aSYMB :anINT |
	ScopeMappingTable at: aSYMB put: anINT.
	ScopeMappingTable at: anINT put: aSYMB. "/ vice versa
    ].
    ^ ScopeMappingTable
!

typeMappingTable
    "answer a Dictionary containing types symbols to integer mapping and vice versa"
    | symbTable |

    TypeMappingTable notNil ifTrue:[ ^ TypeMappingTable].

    symbTable := Dictionary new.
%{
    __AT_PUT_(symbTable , @symbol(ANY),      __MKUINT( RESOURCETYPE_ANY ) );
    __AT_PUT_(symbTable , @symbol(DISK),     __MKUINT( RESOURCETYPE_DISK ) );
    __AT_PUT_(symbTable , @symbol(PRINT),    __MKUINT( RESOURCETYPE_PRINT ) );
    __AT_PUT_(symbTable , @symbol(UNKNOWN),  __MKUINT( RESOURCETYPE_UNKNOWN ) );
    __AT_PUT_(symbTable , @symbol(RESERVED), __MKUINT( RESOURCETYPE_RESERVED ) );
%}.
    TypeMappingTable := Dictionary new.

    symbTable keysAndValuesDo:[:aSYMB :anINT |
	TypeMappingTable at: aSYMB put: anINT.
	TypeMappingTable at: anINT put: aSYMB. "/ vice versa
    ].
    ^ TypeMappingTable
!

usageMappingTable
    "answer a Dictionary containing usages symbols to integer mapping and vice versa"
    | symbTable |

    UsageMappingTable notNil ifTrue:[ ^ UsageMappingTable].

    symbTable := Dictionary new.
%{
    __AT_PUT_(symbTable , @symbol(NULL),          __MKUINT( 0 ) );
    __AT_PUT_(symbTable , @symbol(CONNECTABLE),   __MKUINT( RESOURCEUSAGE_CONNECTABLE ) );
    __AT_PUT_(symbTable , @symbol(CONTAINER),     __MKUINT( RESOURCEUSAGE_CONTAINER ) );
    __AT_PUT_(symbTable , @symbol(ATTACHED),      __MKUINT( RESOURCEUSAGE_ATTACHED ) );
    __AT_PUT_(symbTable , @symbol(ALL),           __MKUINT( RESOURCEUSAGE_ALL ) );
    __AT_PUT_(symbTable , @symbol(NOLOCALDEVICE), __MKUINT( RESOURCEUSAGE_NOLOCALDEVICE ) );
    __AT_PUT_(symbTable , @symbol(SIBLING),       __MKUINT( RESOURCEUSAGE_SIBLING ) );
    __AT_PUT_(symbTable , @symbol(RESERVED),      __MKUINT( RESOURCEUSAGE_RESERVED ) );
%}.
    UsageMappingTable := Dictionary new.

    symbTable keysAndValuesDo:[:aSYMB :anINT |
	UsageMappingTable at: aSYMB put: anINT.
	UsageMappingTable at: anINT put: aSYMB. "/ vice versa
    ].
    ^ UsageMappingTable
! !

!Win32OperatingSystem::Win32NetworkResourceHandle class methodsFor:'fetch resources'!

fetchResourcesStartingAt: aNetworkResourceOrNil
    withScope: aScope type: aType usage: aUsage onError: aBlock

    "Fetch all resources from the given network resource or if nil the root system.
     On success a collection of al network resources is returned.
     If the open fails, the error block if notNil will be evaluated with the error number
     and nil is returned.

    self fetchResourcesStartingAt: nil withScope: #GLOBALNET type: #ANY usage: 0
	onError: [:err| Transcript showCR: err ].
    "
    | stream networkResources |

    [
	stream := self openAt: aNetworkResourceOrNil
	    withScope: aScope type: aType usage: aUsage onError: aBlock.

	stream notNil ifTrue:[
	    |next|

	    networkResources := OrderedCollection new.

	    [ (next := stream nextOrNil) notNil ] whileTrue:[
		networkResources add:next.
	    ].
	]
    ] ensure:[
	stream notNil ifTrue:[ stream close ].
    ].
    ^ networkResources.
!

fetchSystemResourcesWithScope: aScope type: aType usage: aUsage onError: aBlock

    "Fetch all system resources.
     On success a collection of al network resources is returned.
     If the open fails, the error block if notNil will be evaluated with the error number
     and nil is returned.

    self fetchSystemResourcesWithScope: #GLOBALNET type: #ANY usage: 0
	onError: [:err| Transcript showCR: err ].

    self fetchSystemResourcesWithScope: #REMEMBERED type: #DISK usage: 0
	onError: [:err| Transcript showCR: err ].

    self fetchSystemResourcesWithScope: #REMEMBERED type: #ANY usage: 0
	onError: [:err| Transcript showCR: err ].
    "

    ^ self fetchResourcesStartingAt: nil
	    withScope: aScope type: aType usage: aUsage onError: aBlock
!

fetchVirtualDrives
    "answer a collection of virtual drive resources

     self fetchVirtualDrives
    "
    ^ self fetchSystemResourcesWithScope: #REMEMBERED type: #DISK usage: 0 onError: nil.
! !

!Win32OperatingSystem::Win32NetworkResourceHandle class methodsFor:'opening'!

openAt: aResourceOrNil withScope: aScope type: aType usage: aUsage onError: aBlock
    "Open a handle for network resource enumeratation starting at the given NetworkResource
     or if nil on the system root. On success the handle will is returned.
     If the open fails, the error block if notNil will be evaluated with the error number
     and nil is returned.

    OperatingSystem networkResourceAccessor openOn:nil withScope:#GLOBALNET  type:#ANY  usage:0 onError:nil.
    OperatingSystem networkResourceAccessor openOn:nil withScope:#REMEMBERED type:#DISK usage:0 onError:nil.
    "
    | resourceHandle errorNumber enumScope enumUsage enumType
      resScope resType resUsage resDisplayType resComment resLocalName resRemoteName resProvider |

    "/ map symbols to integer values.. on error an exception is raised
    aScope isInteger ifTrue:[ enumScope := aScope ]
		    ifFalse:[ enumScope := self scopeMappingTable at:aScope ].

    aUsage isInteger ifTrue:[ enumUsage := aUsage ]
		    ifFalse:[ enumUsage := self usageMappingTable at:aUsage ].

    aType isInteger ifTrue:[ enumType := aType ]
		   ifFalse:[ enumType := self typeMappingTable at:aType ].

    aResourceOrNil notNil ifTrue:[ | checkAndGetString |
	resScope := aResourceOrNil scope.
	resScope isInteger ifFalse:[ resScope := self scopeMappingTable at:resScope ].

	resType := aResourceOrNil type.
	resType isInteger ifFalse:[ resType := self typeMappingTable at: resType ].

	resUsage := aResourceOrNil usage.
	resUsage isInteger ifFalse:[ resUsage := self usageMappingTable at: resUsage ].

	resDisplayType := aResourceOrNil displayType.
	resDisplayType isInteger ifFalse:[ resDisplayType := self displayTypeMappingTable at:resDisplayType ].

	checkAndGetString := [: aString| |string|
	    aString notNil ifTrue:[
		self isUsingUnicode
		    ifTrue: [ string := aString asUnicode16String  ]
		    ifFalse:[ string := aString asSingleByteString ].
	    ].
	    string
	].
	resRemoteName  := checkAndGetString value:( aResourceOrNil remoteName ).
	resLocalName   := checkAndGetString value:( aResourceOrNil localName ).
	resComment     := checkAndGetString value:( aResourceOrNil comment ).
	resProvider    := checkAndGetString value:( aResourceOrNil provider ).
    ].
    resourceHandle := self new.

%{
    HANDLE __hEnum;
    int    __errno;
    DWORD  __scope = __unsignedLongIntVal( enumScope );
    DWORD  __usage = __unsignedLongIntVal( enumUsage );
    DWORD  __type  = __unsignedLongIntVal( enumType );

#ifdef USE_ANSI_NETWORKRESOURCES
    char           __buffer[ 8192 ];
    LPNETRESOURCE  __lpnetRes = (LPNETRESOURCE) __buffer;
    char *         __cp = __buffer + sizeof(NETRESOURCE);
    char *         __sp;
#else
    wchar_t        __buffer[ 8192 ];
    LPNETRESOURCEW __lpnetRes = (LPNETRESOURCEW) __buffer;
    wchar_t *      __cp = __buffer + sizeof(NETRESOURCEW);
    wchar_t *      __sp;
#endif

    if( resScope == nil ) {
	__lpnetRes = 0;
    } else {
	int __sz;

	ZeroMemory( __buffer, (__cp - __buffer) );

	__lpnetRes->dwScope       = __unsignedLongIntVal( resScope );
	__lpnetRes->dwType        = __unsignedLongIntVal( resType  );
	__lpnetRes->dwUsage       = __unsignedLongIntVal( resUsage );
	__lpnetRes->dwDisplayType = __unsignedLongIntVal( resDisplayType );

	if( resRemoteName != nil ) {
#ifdef USE_ANSI_NETWORKRESOURCES
	    __sp = __stringVal(resRemoteName);
	    __sz = strlen(__sp);
#else
	    __sp = __unicode16StringVal(resRemoteName);
	    __sz = __unicode16StringSize(resRemoteName);
#endif
	    for( __lpnetRes->lpRemoteName = __cp; __sz > 0; --__sz ) { * __cp++ = * __sp++; }
	    *__cp++ = 0;
	}

	if( resLocalName != nil ) {
#ifdef USE_ANSI_NETWORKRESOURCES
	    __sp = __stringVal(resLocalName);
	    __sz = strlen(__sp);
#else
	    __sp = __unicode16StringVal(resLocalName);
	    __sz = __unicode16StringSize(resLocalName);
#endif
	    for( __lpnetRes->lpLocalName = __cp; __sz > 0; --__sz ) { * __cp++ = * __sp++; }
	    *__cp++ = 0;
	}

	if( resComment != nil ) {
#ifdef USE_ANSI_NETWORKRESOURCES
	    __sp = __stringVal(resComment);
	    __sz = strlen(__sp);
#else
	    __sp = __unicode16StringVal(resComment);
	    __sz = __unicode16StringSize(resComment);
#endif
	    for( __lpnetRes->lpComment = __cp; __sz > 0; --__sz ) { * __cp++ = * __sp++; }
	    *__cp++ = 0;
	}

	if( resProvider != nil ) {
#ifdef USE_ANSI_NETWORKRESOURCES
	    __sp = __stringVal(resProvider);
	    __sz = strlen(__sp);
#else
	    __sp = __unicode16StringVal(resProvider);
	    __sz = __unicode16StringSize(resProvider);
#endif
	    for( __lpnetRes->lpProvider = __cp; __sz > 0; --__sz ) { * __cp++ = * __sp++; }
	    *__cp++ = 0;
	}
    }

#ifdef DO_WRAP_CALLS
    do {
	__threadErrno = 0;
#ifdef USE_ANSI_NETWORKRESOURCES
	// do not cast to INT - will loose sign bit then!
	__errno = (int)(STX_API_NOINT_CALL5( "WNetOpenEnumA",  WNetOpenEnumA,  __scope, __type, __usage, __lpnetRes, & __hEnum ));
#else
	// do not cast to INT - will loose sign bit then!
	__errno = (int)(STX_API_NOINT_CALL5( "WNetOpenEnumW", WNetOpenEnumW, __scope, __type, __usage, __lpnetRes, & __hEnum ));
#endif
    } while ((__errno < 0) && (__threadErrno == EINTR));
#else

#ifdef USE_ANSI_NETWORKRESOURCES
    __errno = WNetOpenEnumA ( __scope, __type, __usage, __lpnetRes, & __hEnum );
#else
    __errno = WNetOpenEnumW( __scope, __type, __usage, __lpnetRes, & __hEnum );
#endif

#endif

    if( __errno == NO_ERROR ) {
	__externalAddressVal(resourceHandle) = (void *) __hEnum;
    } else {
	resourceHandle = nil;
	errorNumber    = __mkSmallInteger( __errno );
    }

%}.
    resourceHandle isNil ifTrue:[
	aBlock notNil ifTrue:[ aBlock value: errorNumber ].
	^ nil
    ].
    resourceHandle registerForFinalization.
    ^ resourceHandle
! !

!Win32OperatingSystem::Win32NetworkResourceHandle class methodsFor:'testing'!

isUsingUnicode
    "answer true if we are using unicode; has effect to the open and next operation"

%{
#ifdef USE_ANSI_NETWORKRESOURCES
    RETURN( false );
#endif
%}.
    ^ true
! !

!Win32OperatingSystem::Win32NetworkResourceHandle methodsFor:'queries'!

atEnd
    "answer true if the stream is at the end (no longer valid)"
    ^ (self address == 0)
! !

!Win32OperatingSystem::Win32NetworkResourceHandle methodsFor:'reading'!

nextOrNil
    "answer the next NetworkResource or nil (no more resource available);
     if no more resource is available the stream is closed"

    | scope type usage displayType comment localName remoteName provider |

    self atEnd ifTrue:[ ^ nil ].

%{
    HANDLE __hEnum = (HANDLE)(__externalAddressVal(self));

    if ((__hEnum == 0) || (__hEnum == INVALID_HANDLE_VALUE)) {
	__externalAddressVal(self) = (HANDLE)0;
    } else {
	DWORD           __entries = 1;
	DWORD           __bufSize = 8192;
	int             __errno;

#ifdef USE_ANSI_NETWORKRESOURCES
	char            __buffer[ 8192 ];
	LPNETRESOURCE   __lpNetRes  = (LPNETRESOURCE)  __buffer;

	ZeroMemory( __buffer, sizeof(NETRESOURCE) );
	__errno = WNetEnumResourceA ( __hEnum , & __entries , __lpNetRes, & __bufSize );
#else
	wchar_t         __buffer[ 8192 ];
	LPNETRESOURCEW  __lpNetRes  = (LPNETRESOURCEW) __buffer;

	ZeroMemory( __buffer, sizeof(NETRESOURCEW) );
	__errno = WNetEnumResourceW ( __hEnum , & __entries , __lpNetRes, & __bufSize );
#endif

	if( (__errno  == NO_ERROR) && (__entries == 1) ) {
	    scope       = __MKUINT( __lpNetRes->dwScope );
	    type        = __MKUINT( __lpNetRes->dwType );
	    usage       = __MKUINT( __lpNetRes->dwUsage );
	    displayType = __MKUINT( __lpNetRes->dwDisplayType );

#ifdef USE_ANSI_NETWORKRESOURCES
	    if( __lpNetRes->lpRemoteName != 0 ) { remoteName =  __MKSTRING( __lpNetRes->lpRemoteName ); }
	    if( __lpNetRes->lpLocalName  != 0 ) { localName  =  __MKSTRING( __lpNetRes->lpLocalName ); }
	    if( __lpNetRes->lpComment    != 0 ) { comment    =  __MKSTRING( __lpNetRes->lpComment ); }
	    if( __lpNetRes->lpProvider   != 0 ) { provider   =  __MKSTRING( __lpNetRes->lpProvider ); }
#else
	    if( __lpNetRes->lpRemoteName != 0 ) { remoteName =  __MKU16STRING( __lpNetRes->lpRemoteName ); }
	    if( __lpNetRes->lpLocalName  != 0 ) { localName  =  __MKU16STRING( __lpNetRes->lpLocalName ); }
	    if( __lpNetRes->lpComment    != 0 ) { comment    =  __MKU16STRING( __lpNetRes->lpComment ); }
	    if( __lpNetRes->lpProvider   != 0 ) { provider   =  __MKU16STRING( __lpNetRes->lpProvider ); }
#endif
	}
    }
%}.
    scope notNil ifTrue:[ |netResource|
	netResource := NetworkResource new.

	"map integer values to symbol excluding the usage..."
	netResource scope: (self class scopeMappingTable at:scope ifAbsent:[scope]).
	netResource type:  (self class typeMappingTable  at:type ifAbsent:[type]).
	netResource displayType: (self class displayTypeMappingTable at:displayType ifAbsent:[displayType]).
	netResource usage: usage.

	netResource remoteName: remoteName.
	netResource localName: localName.
	netResource comment: comment.
	netResource provider: provider.

	^ netResource
    ].
    self close.
    ^ nil
! !

!Win32OperatingSystem::Win32NetworkResourceHandle methodsFor:'release'!

closeHandle
    "close the handle"

    self address == 0 ifTrue:[ ^ self ].
%{
    HANDLE __hEnum = (HANDLE)(__externalAddressVal(self));

    if (__hEnum) {
	__externalAddressVal(self) = (HANDLE)0;
	WNetCloseEnum(__hEnum);
    }
%}.
! !

!Win32OperatingSystem::Win32NetworkResourceHandle::NetworkResource methodsFor:'accessing'!

comment
    "comment supplied by the network provider or nil"

    ^ comment
!

comment: aStringOrNil
    "comment supplied by the network provider or nil"

    comment := aStringOrNil.
!

displayType
    "The display options for the network object in a network browsing user interface"

    ^ displayType
!

displayType: theDisplayType
    "The display options for the network object in a network browsing user interface"

    displayType := theDisplayType.
!

localName
    "if the scope member is equal to RESOURCE_CONNECTED or RESOURCE_REMEMBERED,
     this specifies the name of a local device. This member is NULL if the connection
     does not use a device."

    ^ localName
!

localName: aStringOrNil
    "if the scope member is equal to RESOURCE_CONNECTED or RESOURCE_REMEMBERED,
     this specifies the name of a local device. This member is NULL if the connection
     does not use a device."

    localName := aStringOrNil.
!

provider
    "the name of the provider that owns the resource or nil"

    ^ provider
!

provider: aStringOrNil
    "the name of the provider that owns the resource or nil"

    provider := aStringOrNil.
!

remoteName
    "If the resource is a network resource, this specifies the remote network name.
     If the resource is a current or persistent connection, this specifies the network
     name associated with the name pointed to by the localName"

    ^ remoteName
!

remoteName: aStringOrNil
    "If the resource is a network resource, this specifies the remote network name.
     If the resource is a current or persistent connection, this specifies the network
     name associated with the name pointed to by the localName"

    remoteName := aStringOrNil.
!

scope
    "The scope of the enumeration
	RESOURCE_CONNECTED RESOURCE_GLOBALNET RESOURCE_REMEMBERED
    "
    ^ scope
!

scope: theScope
    "The scope of the enumeration
	RESOURCE_CONNECTED RESOURCE_GLOBALNET RESOURCE_REMEMBERED
    "
    scope := theScope.
!

type
    "describes the type of the resource
	RESOURCETYPE_ANY  RESOURCETYPE_DISK  RESOURCETYPE_PRINT
    "
    ^ type
!

type: theType
    "describes the type of the resource
	RESOURCETYPE_ANY  RESOURCETYPE_DISK  RESOURCETYPE_PRINT
    "
    type := theType.
!

usage
    "a set of bit flags (INTEGER) describing how the resource can be used"

    ^ usage
!

usage: anInteger
    "a set of bit flags (INTEGER) describing how the resource can be used"

    usage := anInteger.
! !

!Win32OperatingSystem::Win32NetworkResourceHandle::NetworkResource methodsFor:'printing'!

printOn: aStream
    "print self on a stream"

    | paction |

    paction := [: anIdentifier :theValue |
	anIdentifier printOn: aStream.

	theValue notNil ifTrue:[
	    theValue isInteger ifTrue:[
		theValue printOn:aStream base:2 showRadix:true.
	    ] ifFalse:[
		theValue isSymbol ifTrue:[
		    theValue printOn: aStream.
		] ifFalse:[
		    aStream nextPut: $". theValue printOn: aStream. aStream nextPut: $"
		]
	    ]
	].
	aStream cr.
    ].

    aStream nextPutAll: 'NetworkResource {'; cr.

    paction value: '  Scope:        ' value:scope.
    paction value: '  Type:         ' value:type.
    paction value: '  DisplayType:  ' value:displayType.
    paction value: '  Usage(mask):  ' value:usage.

    aStream cr.

    paction value: '  RemoteName:   ' value:remoteName.
    paction value: '  LocalName:    ' value:localName.
    paction value: '  Comment       ' value:comment.
    paction value: '  Provider      ' value:provider.

    aStream nextPut: $}; cr.
! !

!Win32OperatingSystem::Win32NetworkResourceHandle::NetworkResource methodsFor:'queries'!

isResourceContainer
    "answer true if the resource is a resource container"

    | flag |

    usage isInteger ifFalse:[ ^ usage = #CONTAINER ].
    flag := usage.
%{
    DWORD __usage = __unsignedLongIntVal( flag );

    if( __usage & RESOURCEUSAGE_CONTAINER ) {
	RETURN( true );
    }
%}.
    ^ false
! !

!Win32OperatingSystem::Win32PrinterHandle methodsFor:'release'!

closeHandle
    self address ~~ 0 ifTrue:[
	OperatingSystem primClosePrinter:self.
    ]

    "Created: / 27-07-2006 / 14:48:37 / fm"
! !

!Win32OperatingSystem::Win32ProcessHandle methodsFor:'accessing'!

pid
    ^ pid
! !

!Win32OperatingSystem::Win32ProcessHandle methodsFor:'comparing'!

= aWin32ProcessHandle
    ^ aWin32ProcessHandle class == self class and:[pid = aWin32ProcessHandle pid]
!

hash
    ^ pid hash
! !

!Win32OperatingSystem::Win32ProcessHandle methodsFor:'printing & storing'!

printOn:aStream
    "return a printed representation of the receiver"

    super printOn:aStream.
    aStream nextPutAll:' pid:'.
    pid printOn:aStream.
! !

!Win32OperatingSystem::Win32SerialPortHandle methodsFor:'opening'!

open:portName baudRate:baudRate stopBitsType:stopBitsType
		    parityType:parityType dataBits:dataBits
		    inFlowCtrl:inFlowCtrlType outFlowCtrl:outFlowCtrlType
		    xOnChar:xOnChar xOffChar:xOffChar
    "portName: COM%d
     baudRate: Integer
     stopBitsType: #stop1, #stop2 or #stop1_5
     parityType: #odd, #even or #none
     dataBits: #integer
     inFlowCtrlType: #xOnOff #hardware
     outFlowCtrlType: #xOnOff #hardware
     xOnChar: Character or Integer
     xOffChar: Character or Integer"

    |errorNumber|

%{
    HANDLE port;
    COMMTIMEOUTS timeouts;
    DCB dcb;
    char *__portName;
    int __setBaudRate = 1,
	__setDataBits = 1,
	__setXOnChar = 1,
	__setXOffChar = 1,
	__setInFlowCtrl = 1,
	__setOutFlowCtrl = 1,
	__setStopBits = 1,
	__setParityType = 1;
    int __baudRate, __dataBits;
    int __xOnChar, __xOffChar;
    int __inFlowCtrl, __outFlowCtrl;
    int __stopBits, __parityType;
#   define XONOFF       1
#   define HARDWARE     2
#   define STOP1     1
#   define STOP2     2
#   define STOP1_5   3
#   define ODD       1
#   define EVEN      2
#   define NONE      3

    if (__isStringLike(portName)) {
	__portName = __stringVal(portName);
    } else {
	goto failure;
    }
    if (__isSmallInteger(baudRate)) {
	__baudRate = __intVal(baudRate);
    } else if (baudRate == nil) {
	__setBaudRate = 0;
    } else {
	goto failure;
    }

    if (__isSmallInteger(dataBits)) {
	__dataBits = __intVal(dataBits);
    } else if (dataBits == nil) {
	__setDataBits = 0;
    } else {
	goto failure;
    }

    if (__isSmallInteger(xOnChar)) {
	__xOnChar = __intVal(xOnChar);
    } else if (__isCharacter(xOnChar)) {
	__xOnChar = __intVal(_characterVal(xOnChar));
    } else if (xOnChar == nil) {
	__setXOnChar = 0;
    } else {
	goto failure;
    }

    if (__isSmallInteger(xOffChar)) {
	__xOffChar = __intVal(xOffChar);
    } else if (__isCharacter(xOffChar)) {
	__xOffChar = __intVal(_characterVal(xOffChar));
    } else if (xOffChar == nil) {
	__setXOffChar = 0;
    } else {
	goto failure;
    }

    if (inFlowCtrlType == @symbol(xOnOff)) {
	__inFlowCtrl = XONOFF;
    } else if (inFlowCtrlType == @symbol(hardware)) {
	__inFlowCtrl = HARDWARE;
    } else if (inFlowCtrlType == nil) {
	__setInFlowCtrl = 0;
    } else {
	goto failure;
    }

    if (outFlowCtrlType == @symbol(xOnOff)) {
	__outFlowCtrl = XONOFF;
    } else if (outFlowCtrlType == @symbol(hardware)) {
	__outFlowCtrl = HARDWARE;
    } else if (outFlowCtrlType == nil) {
	__setOutFlowCtrl = 0;
    } else {
	goto failure;
    }

    if (stopBitsType == @symbol(stop1)) {
	__stopBits = STOP1;
    } else if (stopBitsType == @symbol(stop2)) {
	__stopBits = STOP2;
    } else if (stopBitsType == @symbol(stop1_5)) {
	__stopBits = STOP1_5;
    } else if (stopBitsType == nil) {
	__setStopBits = 0;
    } else {
	goto failure;
    }

    port = CreateFile(__portName,
	      GENERIC_READ | GENERIC_WRITE,
	      0,             /* comm devices must be opened with exclusive access */
	      NULL,          /* no security attrs */
	      OPEN_EXISTING, /* comm devices must use OPEN_EXISTING */
	      0,             /* no overlapped I/O */
	      NULL           /* hTemplate must be NULL for comm devices */
	   );
    if (port == INVALID_HANDLE_VALUE) {
	console_fprintf(stderr, "Win32OS [info]: serial port open failed\n");
	errorNumber = __mkSmallInteger( __WIN32_ERR(GetLastError()) );
	goto failure;
    }
    /* Flush the driver */
    PurgeComm( port, PURGE_TXABORT | PURGE_RXABORT | PURGE_TXCLEAR | PURGE_RXCLEAR );

    /* Set driver buffer sizes */
    SetupComm( port, 4096 /*SERIAL_IN_QUEUE_SIZE*/, 4096 /*SERIAL_OUT_QUEUE_SIZE*/);

    /* Reset timeout constants */
    timeouts.ReadIntervalTimeout= 0xFFFFFFFF;
    timeouts.ReadTotalTimeoutMultiplier = 0;
    timeouts.ReadTotalTimeoutConstant = 0;
    timeouts.WriteTotalTimeoutMultiplier = 0;
    timeouts.WriteTotalTimeoutConstant = 0;
    SetCommTimeouts( port, &timeouts );

    /* Set communication parameters */
    ZeroMemory(&dcb, sizeof(dcb));
    dcb.DCBlength = sizeof(dcb);
    GetCommState(port, &dcb);

    if (__setBaudRate) dcb.BaudRate = __baudRate;
    if (__setDataBits) dcb.ByteSize = __dataBits;
    if (__setXOnChar)  dcb.XonChar = __xOnChar;
    if (__setXOffChar) dcb.XoffChar = __xOffChar;

    if (__setStopBits) {
	/* set stop bits */
	switch(__stopBits) {
	    case STOP1_5: dcb.StopBits = 1; break; /* 1.5 stop bits */
	    case STOP1: dcb.StopBits = 0; break; /* 1 stop bit */
	    case STOP2: dcb.StopBits = 2; break; /* 2 stop bits */
	    default: goto errExit;
	}
    }

    if (__setParityType) {
	/* set parity */
	switch(__parityType) {
	    case NONE: dcb.Parity = NOPARITY; break;
	    case ODD: dcb.Parity = ODDPARITY; break;
	    case EVEN: dcb.Parity = EVENPARITY; break;
	    default: goto errExit;
	}
    }

    if (__setInFlowCtrl) {
	/* set control flow */
	dcb.fInX = FALSE;
	dcb.fDtrControl = FALSE;
	if (__inFlowCtrl == XONOFF) dcb.fInX = TRUE;  /* XOn/XOff handshaking */
	if (__inFlowCtrl == HARDWARE) dcb.fDtrControl = TRUE;  /* hardware handshaking */
    }
    if (__setOutFlowCtrl) {
	dcb.fOutX = FALSE;
	dcb.fOutxCtsFlow = FALSE;

	if (__outFlowCtrl == XONOFF) dcb.fOutX = TRUE;  /* XOn/XOff handshaking */
	if (__outFlowCtrl == HARDWARE) dcb.fOutxCtsFlow = TRUE;  /* hardware handshaking */
    }

    if (SetCommState(port, &dcb)) {
	RETURN( true );
    }

    console_fprintf(stderr, "Win32OS [info]: serial port comm-setup failed\n");
    errorNumber = __mkSmallInteger( __WIN32_ERR(GetLastError()) );
    /* fall into */
errExit: ;
    CloseHandle(port);

failure: ;
#   undef XONOFF
#   undef HARDWARE
#   undef STOP1
#   undef STOP2
#   undef STOP1_5
#   undef ODD
#   undef EVEN
#   undef NONE
%}.
    errorNumber isNil ifTrue:[
	self error:'invalid argument(s)'.
    ] ifFalse:[
	(OperatingSystem errorHolderForNumber:errorNumber) reportError
    ].
! !

!Win32OperatingSystem::Win32SerialPortHandle methodsFor:'release'!

closeHandle
    "close the handle"

%{
    HANDLE port = (HANDLE)(__externalAddressVal(self));

    if (port) {
	__externalAddressVal(self) = (HANDLE)0;
	PurgeComm( port, PURGE_TXABORT | PURGE_RXABORT | PURGE_TXCLEAR | PURGE_RXCLEAR );
	CloseHandle(port);
    }
%}.
! !

!Win32OperatingSystem::Win32SerialPortHandle methodsFor:'setup'!

baudRate:newRate
%{
    HANDLE port = (HANDLE)(__externalAddressVal(self));

    if (port
     && __isSmallInteger(newRate)) {
	DCB dcb;

	ZeroMemory(&dcb, sizeof(dcb));
	dcb.DCBlength = sizeof(dcb);
	GetCommState(port, &dcb);

	dcb.BaudRate = __intVal(newRate);

	if (! SetCommState(port, &dcb)) {
	    RETURN(false);
	}
	RETURN(true);
    }
%}.
    self primitiveFailed.
!

dataBits:newNumberOfBits
%{
    HANDLE port = (HANDLE)(__externalAddressVal(self));

    if (port
     && __isSmallInteger(newNumberOfBits)) {
	DCB dcb;

	ZeroMemory(&dcb, sizeof(dcb));
	dcb.DCBlength = sizeof(dcb);
	GetCommState(port, &dcb);

	dcb.ByteSize = __intVal(newNumberOfBits);

	if (! SetCommState(port, &dcb)) {
	    RETURN(false);
	}
	RETURN(true);
    }
%}.
    self primitiveFailed.
!

parityType:newParityTypeSymbol
    "newParityTypeSymbol must be one of #odd, #even or #none (or nil)"

%{
    HANDLE port = (HANDLE)(__externalAddressVal(self));

    if (port) {
	DCB dcb;

	ZeroMemory(&dcb, sizeof(dcb));
	dcb.DCBlength = sizeof(dcb);
	GetCommState(port, &dcb);


	if ((newParityTypeSymbol == nil) || (newParityTypeSymbol == @symbol(none))) {
	    dcb.Parity = NOPARITY;
	} else if (newParityTypeSymbol == @symbol(odd)) {
	    dcb.Parity = ODDPARITY;
	} else if (newParityTypeSymbol == @symbol(even)) {
	    dcb.Parity = EVENPARITY;
	} else {
	    goto failure;
	}

	if (! SetCommState(port, &dcb)) {
	    RETURN(false);
	}
	RETURN(true);
    }
  failure: ;
%}.
    self primitiveFailed.
!

stopBitsType:newStopBitsSymbol
    "newParityTypeSymbol must be one of #stop1, #stop2 or #stop1_5"
%{
    HANDLE port = (HANDLE)(__externalAddressVal(self));

    if (port) {
	DCB dcb;

	ZeroMemory(&dcb, sizeof(dcb));
	dcb.DCBlength = sizeof(dcb);
	GetCommState(port, &dcb);

	if (newStopBitsSymbol == @symbol(stop1)) {
	    dcb.Parity = 0 /* STOP1 */;
	} else if (newStopBitsSymbol == @symbol(stop2)) {
	    dcb.Parity = 2 /* STOP2 */;
	} else if (newStopBitsSymbol == @symbol(stop1_5)) {
	    dcb.Parity = 1 /* STOP1_5 */;
	} else {
	    goto failure;
	}

	if (! SetCommState(port, &dcb)) {
	    RETURN(false);
	}
	RETURN(true);
    }
  failure: ;
%}.
    self primitiveFailed.
! !

!Win32OperatingSystem::Win32SocketHandle class methodsFor:'constants'!

protocolCodeOf:aNameOrNumber
    "q&d hack for unix-compatibility"

    aNameOrNumber isNumber ifTrue:[^ aNameOrNumber].
    aNameOrNumber isNil ifTrue:[^ aNameOrNumber].

    aNameOrNumber = 'tcp' ifTrue:[^ 6].
    aNameOrNumber = 'udp' ifTrue:[^ 17].
    aNameOrNumber = 'raw' ifTrue:[^ 255].

    self error:'unsupported protocol' mayProceed:true.
    ^ nil.

    "
     self protocolCodeOf:#tcp
    "
!

protocolSymbolOf:anInteger
    "q&d hack for unix-compatibility"

    anInteger isNil ifTrue:[^ nil].
    anInteger isSymbol ifTrue:[^ anInteger].

    anInteger ==   0 ifTrue:[ ^ #ip ].
    anInteger ==   6 ifTrue:[ ^ #tcp ].
    anInteger ==  17 ifTrue:[ ^ #udp ].
    anInteger == 255 ifTrue:[ ^ #raw ].

    self error:'unsupported protocol' mayProceed:true.
    ^ nil.

    "
     self protocolSymbolOf:6
    "
! !

!Win32OperatingSystem::Win32SocketHandle class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!Win32OperatingSystem::Win32SocketHandle class methodsFor:'queries'!

getAddressInfo:hostNameOrNil serviceName:serviceNameOrNil domain:domainArg type:typeArg protocol:protoArg flags:flags
    "answer an Array of socket addresses for serviceName on hostName.
     Domain, type, protocol may be nil or specify a hint for the socket
     addresses to be returned."

    |error errorString result domain type proto hostName serviceName port|

    domain := OperatingSystem domainCodeOf:domainArg.
    type := OperatingSystem socketTypeCodeOf:typeArg.
    proto := self protocolCodeOf:protoArg.
    serviceNameOrNil notNil ifTrue:[
	serviceName := serviceNameOrNil printString.      "convert integer port numbers"
	serviceNameOrNil isInteger ifTrue:[
	    port := serviceNameOrNil.
	].
    ]. "ifFalse:[serviceName := nil]"


%{
#if 1 || !defined(AI_NUMERICHOST)
%}.

    "have to convert serviceName and hostName to single byte strings
     until we implement getAddrInfoW() for Borland C.
     If we really have 16-bit hostnames, this fails with #primitiveFailed"
    hostNameOrNil notNil ifTrue:[
	hostName := hostNameOrNil asSingleByteStringIfPossible.
    ].  "ifFalse:[hostName := nil] is nil anyway"
    serviceName notNil ifTrue:[
	serviceName := serviceName asSingleByteStringIfPossible.
    ].
%{
#endif // !AI_NUMERICHOST
%}.


%{ /* STACK:32000 */
#if !defined(NO_SOCKET)
    char *__hostName, *__serviceName;
    char __hostNameCopy[1024], __serviceNameCopy[256];
    int ret;
    int cnt = 0;

    if (hostName == nil) {
	__hostName = 0;
    } else if (__isStringLike(hostName)) {
	strncpy(__hostNameCopy, __stringVal(hostName), sizeof(__hostNameCopy)-1);
	__hostName = __hostNameCopy;
    } else if (__isUnicode16String(hostName)) {
	error = @symbol(unsupportedUnicodeName);
	errorString = __MKSTRING("Unicode hostnames are not yet supported");
	goto exitPrim;
    } else {
	error = @symbol(badArgument1);
	goto exitPrim;
    }
    if (serviceName == nil) {
	__serviceName = 0;
    } else if (__isStringLike(serviceName)) {
	strncpy(__serviceNameCopy, __stringVal(serviceName), sizeof(__serviceNameCopy)-1);
	__serviceName = __serviceNameCopy;
    } else {
	error = @symbol(badArgument2);
	goto exitPrim;
    }
    if (__hostName == 0 && __serviceName == 0) {
	error = @symbol(badArgument);
	goto exitPrim;
    }

{
# if defined(AI_NUMERICHOST)
    /*
     * Use getaddrinfo()
     */
    struct addrinfo hints;
    struct addrinfo *info = NULL, *infop;

    memset(&hints, 0, sizeof(hints));
    if (__isSmallInteger(domain))
	hints.ai_family = __intVal(domain);
    if (__isSmallInteger(type))
	hints.ai_socktype = __intVal(type);
    if (__isSmallInteger(proto))
	hints.ai_protocol = __intVal(proto);

    do {
# ifdef DO_WRAP_CALLS
	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    ret = (int)(STX_WSA_NOINT_CALL4( "getaddrinfo", getaddrinfo, __hostName, __serviceName, &hints, &info));
	} while ((ret < 0) && (__threadErrno == EINTR));
# else
	__BEGIN_INTERRUPTABLE__
	ret = getaddrinfo(__hostName, __serviceName, &hints, &info);
	__END_INTERRUPTABLE__
# endif
    } while (ret != 0 && __threadErrno == EINTR);
    if (ret != 0) {
	switch (ret) {
	case EAI_FAMILY:
	    error = @symbol(badProtocol);
	    break;
	case EAI_SOCKTYPE:
	    error = @symbol(badSocketType);
	    break;
	case EAI_BADFLAGS:
	    error = @symbol(badFlags);
	    break;
	case EAI_NONAME:
	    error = @symbol(unknownHost);
	    break;
	case EAI_SERVICE:
	    error = @symbol(unknownService);
	    break;
	case EAI_MEMORY:
	    error = @symbol(allocationFailure);
	    break;
	case EAI_FAIL:
	    error = @symbol(permanentFailure);
	    break;
	case EAI_AGAIN:
	    error = @symbol(tryAgain);
	    break;
	default:
	    error = @symbol(unknownError);
	}
	errorString = __MKSTRING(gai_strerror(ret));
	goto err;
    }
    for (cnt=0, infop=info; infop; infop=infop->ai_next)
	cnt++;

    result = __ARRAY_NEW_INT(cnt);
    if (result == nil) {
	error = @symbol(allocationFailure);
	goto err;
    }
    for (infop=info, cnt=0; infop; infop=infop->ai_next, cnt++) {
	OBJ o, resp;

	resp = __ARRAY_NEW_INT(6);
	if (resp == nil) {
	    error = @symbol(allocationFailure);
	    goto err;
	}

	__ArrayInstPtr(result)->a_element[cnt] = resp; __STORE(result, resp);

	__ArrayInstPtr(resp)->a_element[0] = __mkSmallInteger(infop->ai_flags);
	__ArrayInstPtr(resp)->a_element[1] = __mkSmallInteger(infop->ai_family);
	__ArrayInstPtr(resp)->a_element[2] = __mkSmallInteger(infop->ai_socktype);
	__ArrayInstPtr(resp)->a_element[3] = __mkSmallInteger(infop->ai_protocol);

	__PROTECT__(resp);
	o = __BYTEARRAY_NEW_INT(infop->ai_addrlen);
	__UNPROTECT__(resp);
	if (o == nil) {
	    error = @symbol(allocationFailure);
	    goto err;
	}
	memcpy(__byteArrayVal(o), infop->ai_addr, infop->ai_addrlen);
       __ArrayInstPtr(resp)->a_element[4] = o; __STORE(resp, o);

	if (infop->ai_canonname) {
	    __PROTECT__(resp);
	    o = __MKSTRING(infop->ai_canonname);
	    __UNPROTECT__(resp);
	    if (o == nil) {
		error = @symbol(allocationFailure);
		goto err;
	    }
	    __ArrayInstPtr(resp)->a_element[5] = o; __STORE(resp, o);
	}
    }

err:
    if (info) freeaddrinfo(info);

# else /* ! AI_NUMERICHOST =============================================================*/

    /*
     * Use getservbyname() / gethostByName()
     */
    struct hostent *hp;
    char **addrpp;
    int __port = 0;
    int i;

    if (__isSmallInteger(port)) {
	__port = htons(__smallIntegerVal(port));
    } else if (__serviceName) {
	struct servent *sp;
	char *__proto = 0;

	if (__isStringLike(protoArg))
	    __proto = __stringVal(protoArg);

	sp = getservbyname(__serviceName, __proto);
	if (sp == NULL) {
	    __port = atoi(__serviceName);
	    if (__port <= 0) {
		errorString = @symbol(unknownService);
		error = __mkSmallInteger(-3);
		goto err;
	    }
	    __port = htons(__port);
	} else
	    __port = sp->s_port;
    }

    if (__hostName) {
	int err;

	do {
# if 0 && defined(DO_WRAP_CALLS)
	    /* This does not work - the structure is allocated in thread local storage */
	    hp = STX_WSA_NOINT_CALL1("gethostbyname", gethostbyname, __hostName);
	    if ((INT)hp < 0) hp = NULL;
# else
	    /* __BEGIN_INTERRUPTABLE__ is dangerous, because gethostbyname
	     * uses a static data area, but allocates it in thread local storage
	     */
	    // __BEGIN_INTERRUPTABLE__
	    hp = gethostbyname(__hostName);
	    // __END_INTERRUPTABLE__
#endif
	} while ((hp == NULL
		  && (err = WSAGetLastError()) == EINTR));
	if (hp == 0) {
	    switch (err) {
	    case HOST_NOT_FOUND:
		errorString = @symbol(unknownHost);
		break;
	    case NO_ADDRESS:
		errorString = @symbol(noAddress);
		break;
	    case NO_RECOVERY:
		errorString = @symbol(permanentFailure);
		break;
	    case TRY_AGAIN:
		errorString = @symbol(tryAgain);
		break;
	    default:
		errorString = @symbol(unknownError);
		break;
	    }
	    error = __mkSmallInteger(err);
	    goto err;
	}

	if (__isSmallInteger(domain) && hp->h_addrtype != __smallIntegerVal(domain)) {
	    errorString = @symbol(unknownHost);
	    error = __mkSmallInteger(-2);
	    goto err;
	}

	for (cnt = 0, addrpp = hp->h_addr_list; *addrpp; addrpp++)
	    cnt++;
	addrpp = hp->h_addr_list;
    } else {
	cnt = 1;
    }

    result = __ARRAY_NEW_INT(cnt);
    if (result == nil) {
	error = @symbol(allocationFailure);
	goto err;
    }

    for (i = 0; i < cnt; i++) {
	OBJ o, resp;
	struct sockaddr_in *sa;

	resp = __ARRAY_NEW_INT(6);
	if (resp == nil) {
	    error = @symbol(allocationFailure);
	    goto err;
	}

	__ArrayInstPtr(result)->a_element[i] = resp; __STORE(result, resp);
	__ArrayInstPtr(resp)->a_element[0] = __mkSmallInteger(0);
	__ArrayInstPtr(resp)->a_element[2] = type; __STORE(resp, type);
	__ArrayInstPtr(resp)->a_element[3] = proto; __STORE(resp, proto);
	__PROTECT__(resp);
	o = __BYTEARRAY_NEW_INT(sizeof(*sa));
	__UNPROTECT__(resp);
	if (o == nil) {
	    error = @symbol(allocationFailure);
	    goto err;
	}
	__ArrayInstPtr(resp)->a_element[4] = o; __STORE(resp, o);
	sa = (struct sockaddr_in *)__byteArrayVal(o);
	sa->sin_port = __port;

	if (__hostName) {
	    sa->sin_family = hp->h_addrtype;
	    memcpy(&sa->sin_addr, *addrpp, hp->h_length);
	    __ArrayInstPtr(resp)->a_element[1] = __mkSmallInteger(hp->h_addrtype);
	    if (hp->h_name) {
		__PROTECT__(resp);
		o = __MKSTRING(hp->h_name);
		__UNPROTECT__(resp);
		if (o == nil) {
		    error = @symbol(allocationFailure);
		    goto err;
		}
		__ArrayInstPtr(resp)->a_element[5] = o; __STORE(resp, o);
	    }
	    addrpp++;
	} else{
	    if (__isSmallInteger(domain))
		sa->sin_family = __intVal(domain);
	    else
		sa->sin_family = AF_INET;
	    __ArrayInstPtr(resp)->a_element[1] = domain; __STORE(resp, domain);
	}
    }

err:;
# endif /* ! AI_NUMERICHOST */
}
#else /* ! HAS_SOCKET */
    error = @symbol(notImplemented);
#endif
exitPrim:;
%}.
    error notNil ifTrue:[
	|request|
	request := SocketAddressInfo new
	    domain:domainArg;
	    type:typeArg;
	    protocol:protoArg;
	    canonicalName:hostName;
	    serviceName:serviceName.
	^ (HostNameLookupError new
		parameter:error;
		messageText:' - ', (errorString ? error printString);
		request:request) raiseRequest.
    ].
    1 to:result size do:[:i |
	|entry dom info|

	info := SocketAddressInfo new.
	entry := result at:i.
	info flags:(entry at:1).
	info domain:(dom := OperatingSystem domainSymbolOf:(entry at:2)).
	info type:(OperatingSystem socketTypeSymbolOf:(entry at:3)).
	info protocol:(self protocolSymbolOf:(entry at:4)).
	info socketAddress:((SocketAddress newDomain:dom) fromBytes:(entry at:5)).
	info canonicalName:(entry at:6).
	result at:i put:info
    ].
    ^ result

    "
     self getAddressInfo:'localhost' serviceName:nil
	    domain:nil type:nil protocol:nil flags:nil
     self getAddressInfo:'localhost' serviceName:nil
	    domain:#AF_INET type:#stream protocol:nil flags:nil
     self getAddressInfo:'localhost' serviceName:nil
	    domain:#AF_INET type:#stream protocol:#tcp flags:nil
     self getAddressInfo:'localhost' serviceName:10
	    domain:#AF_INET type:#stream protocol:#tcp flags:nil
     self getAddressInfo:'localhost' serviceName:'10'
	    domain:#AF_INET type:#stream protocol:#tcp flags:nil
     self getAddressInfo:'blurb.exept.de' serviceName:nil
	    domain:#AF_INET type:nil protocol:nil flags:nil
     self getAddressInfo:'1.2.3.4' serviceName:'bla'
	    domain:#AF_INET type:nil protocol:nil flags:nil
     self getAddressInfo:'localhost' serviceName:'echo'
	    domain:#AF_INET type:nil protocol:nil flags:nil
     self getAddressInfo:nil serviceName:'echo'
	    domain:#AF_INET type:nil protocol:nil flags:nil
     self getAddressInfo:nil serviceName:nil
	    domain:#AF_INET type:nil protocol:nil flags:nil
     self getAddressInfo:'www.google.de' serviceName:nil
	    domain:nil type:nil protocol:nil flags:nil
     self getAddressInfo:'exeptn' serviceName:nil
	    domain:nil type:nil protocol:nil flags:nil

     self getAddressInfo:'localhost' asUnicode16String serviceName:nil
	    domain:nil type:nil protocol:nil flags:nil
     self getAddressInfo:'ützlbrützl' serviceName:nil
	    domain:nil type:nil protocol:nil flags:nil
     self getAddressInfo:'ützlbrützl' serviceName:nil
	    domain:nil type:nil protocol:nil flags:nil
     self getAddressInfo:'путин.ру' asUnicode16String serviceName:nil
	    domain:nil type:nil protocol:nil flags:nil
    "
!

getNameInfo:socketAddressIn wantHostName:wantHostName wantServiceName:wantServiceName datagram:useDatagram flags:flags
    "answer an Array containing the hostName and serviceName
     in socketAddress.
     This is the generic version of getHostByAddr, however, if supported by the OS,
     this returns multiple hostnames (if appropriate)"

    |socketAddress error errorString hostName serviceName|

    socketAddress := socketAddressIn.

%{   /* STACK:32000 */
#if !defined(NI_NUMERICHOST)
%}.
    "if the getNameInfo() syscall is not present (as in Borland),
     convert mapped IPv4 to IPv6Addresses back to IPv4,
     so that these addresses can be resolved"
    socketAddress := socketAddress asIPv4SocketAddressIfPossible.
%{
#endif // !defined(NI_NUMERICHOST)
%}.

%{  /* STACK:32000 */

#if !defined(NO_SOCKET)

# ifndef NI_MAXHOST
#  define NI_MAXHOST 256
#  define NI_MAXSERV 64
# endif

    char host[NI_MAXHOST];
    char service[NI_MAXSERV];
    char *hp = NULL, *sp = NULL;
    int hsz = 0, ssz = 0;
    int ret;
    int __flags;
    char *bp;
    int nInstBytes, sockAddrSize;

    if (wantHostName == true) {
	hp = host;
	hsz = sizeof(host);
    }
    if (wantServiceName == true) {
	sp = service;
	ssz = sizeof(service);
    }
    if (hp == NULL && sp == NULL) {
	error = @symbol(badArgument);
	goto err;
    }
    if (!__isBytes(socketAddress)) {
	error = @symbol(badArgument1);
	goto err;
    }

    nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(socketAddress))->c_ninstvars));
    sockAddrSize = __byteArraySize(socketAddress);
    sockAddrSize -= nInstBytes;

    if (!__isSmallInteger(flags)) {
	error = @symbol(badArgument5);
	goto err;
    }
    __flags = __intVal(flags);

#if defined(NI_NUMERICHOST)
    if (useDatagram == true) {
	__flags |= NI_DGRAM;
    }

    {
	bp = (char *)(__byteArrayVal(socketAddress));
	bp += nInstBytes;
# ifdef DO_WRAP_CALLS
	do {
	    __threadErrno = 0;
	    // do not cast to INT - will loose sign bit then!
	    ret = (int)(STX_WSA_NOINT_CALL7( "getnameinfo", getnameinfo, (struct sockaddr *)bp, (INT)sockAddrSize, hp, (INT)hsz, sp, (INT)ssz, (INT)__flags));
	} while ((ret < 0) && (__threadErrno == EINTR));
# else
	__BEGIN_INTERRUPTABLE__
	ret = getnameinfo((struct sockaddr *)bp, sockAddrSize,
			  hp, hsz, sp, ssz, __flags);
	__END_INTERRUPTABLE__
# endif
    } while (ret != 0 && __threadErrno == EINTR);

    if (ret != 0) {
	switch (ret) {
	    case EAI_FAMILY:
		error = @symbol(badProtocol);
		break;
	    case EAI_SOCKTYPE:
		error = @symbol(badSocketType);
		break;
	    case EAI_BADFLAGS:
		error = @symbol(badFlags);
		break;
	    case EAI_NONAME:
		error = @symbol(unknownHost);
		break;
	    case EAI_SERVICE:
		error = @symbol(unknownService);
		break;
	    case EAI_MEMORY:
		error = @symbol(allocationFailure);
		break;
	    case EAI_FAIL:
		error = @symbol(permanentFailure);
		break;
	    case EAI_AGAIN:
		error = @symbol(tryAgain);
		break;
	    default:
		error = @symbol(unknownError);
	}
	errorString = __MKSTRING(gai_strerror(ret));
	goto err;
    }
# else /* ! NI_NUMERICHOST */
    {
	/*
	 * Do it using gethostbyaddr()
	 */
	struct sockaddr_in *sa;

	if (sockAddrSize < sizeof(*sa)) {
	    error = @symbol(badArgument1);
	    goto err;
	}
	bp = (char *)(__byteArrayVal(socketAddress));
	bp += nInstBytes;
	sa = (struct sockaddr_in *)bp;

	if (sp) {
	    struct servent *servp;
	    char *__proto = 0;

	    __proto = (useDatagram == true ? "udp" : "tcp");

	    servp = getservbyport(sa->sin_port, __proto);
	    if (servp) {
		sp = servp->s_name;
	    }
	}

	if (sa->sin_family == AF_INET6) {
	    if (sp)
		serviceName = __MKSTRING(sp);
	    error = @symbol(AF_INET6);
	    goto err;
	}

	if (hp) {
	    struct hostent *hostp;
	    int err;

	    do {
		/* must refetch in loop */
		bp = (char *)(__byteArrayVal(socketAddress));
		bp += nInstBytes;
		sa = (struct sockaddr_in *)bp;
		/* __BEGIN_INTERRUPTABLE__ is dangerous, because gethostbyname uses a static data area
		 */
		hostp = gethostbyaddr((char *)&sa->sin_addr, sockAddrSize, sa->sin_family);
		/* __END_INTERRUPTABLE__ */
	    } while ((hostp == NULL)
		      && ((err = WSAGetLastError()) == EINTR)
	    );
	    if (hostp == 0) {
		switch (err) {
		case HOST_NOT_FOUND:
		    errorString = @symbol(unknownHost);
		    break;
		case NO_ADDRESS:
		    errorString = @symbol(noAddress);
		    break;
		case NO_RECOVERY:
		    errorString = @symbol(permanentFailure);
		    break;
		case TRY_AGAIN:
		    errorString = @symbol(tryAgain);
		    break;
		default:
		    errorString = @symbol(unknownError);
		    break;
		}
		error = __mkSmallInteger(err);
		goto err;
	    }
	    hp = hostp->h_name;
	}
    }
# endif /* ! NI_NUMERICHOST */

    if (hp)
	hostName = __MKSTRING(hp);
    if (sp)
	serviceName = __MKSTRING(sp);
err:;
#else
    error = @symbol(notImplemented);
#endif
%}.
    error notNil ifTrue:[
	(error == #AF_INET6 or:[errorString == #noAddress]) ifTrue:[
	    "This is a socket address of wrong size - probably an IPv6SocketAddres on a system where
	     the getNetByAddr() syscall is not supported"
	    ^ Array
		with:socketAddress hostAddressString
		with:serviceName.
	].
	error isSymbol ifTrue:[
	    self primitiveFailed:error.
	].
	^ (HostAddressLookupError new
		parameter:error;
		messageText:' - ', (errorString ? error printString);
		request:thisContext message) raiseRequest.
    ].

    ^ Array with:hostName with:serviceName

    "
     self getNameInfo:
	(self getAddressInfo:'localhost' serviceName:'echo'
		domain:#AF_INET type:#stream protocol:nil flags:nil) first socketAddress
	 wantHostName:true wantServiceName:true datagram:false flags:0

     self getNameInfo:
	(self getAddressInfo:'exept.exept.de' serviceName:'echo'
		domain:#AF_INET type:#stream protocol:nil flags:nil) first socketAddress
	 wantHostName:true wantServiceName:true datagram:false flags:0

     self getNameInfo:(IPSocketAddress hostAddress:#[1 2 3 4])
	 wantHostName:true wantServiceName:true datagram:false flags:0

     self getNameInfo:(IPv6SocketAddress localHost port:21)
	 wantHostName:true wantServiceName:true datagram:false flags:0
    "
! !

!Win32OperatingSystem::Win32SocketHandle methodsFor:'initialization'!

initialize
%{ /* NOCONTEXT */
	__ExternalAddressInstPtr(self)->e_address = (void *)(INVALID_SOCKET);
%}

    "
      self new
      self new isValid
    "
! !

!Win32OperatingSystem::Win32SocketHandle methodsFor:'queries'!

handleType
    ^ #socketHandle
!

isValid
%{  /* NOCONTEXT */
    SOCKET sock = (SOCKET)(__externalAddressVal(self));

    RETURN(sock == INVALID_SOCKET ? false : true);
%}.

    "
      self new isValid
    "
! !

!Win32OperatingSystem::Win32SocketHandle methodsFor:'release'!

closeHandle
    "close the handle"

%{ /* NOCONTEXT */
    SOCKET sock = (SOCKET)(__externalAddressVal(self));

    if (sock != INVALID_SOCKET) {
	__externalAddressVal(self) = (void *)(INVALID_SOCKET);
	closesocket(sock);
    }
%}.
! !

!Win32OperatingSystem::Win32SocketHandle methodsFor:'testing'!

isSocketHandle
    ^ true
! !

!Win32OperatingSystem::WinPointStructure class methodsFor:'instance creation'!

new

^super new: self sizeInBytes

    "Created: / 03-08-2006 / 10:37:59 / fm"
!

sizeInBytes

^8

    "Created: / 03-08-2006 / 10:38:06 / fm"
! !

!Win32OperatingSystem::WinPointStructure methodsFor:'accessing'!

asPoint
	"Private - Answer the receiver as a Point."
    ^self x @ self y

    "Created: / 03-08-2006 / 10:45:55 / fm"
!

x
	"Private - Answer the x coordinate of the point."
    ^self longAt: 0 + 1

    "Created: / 03-08-2006 / 10:46:11 / fm"
!

x: anInteger
	"Private - Set the x coordinate of the point."
    self longAt: 0 + 1 put: anInteger

    "Created: / 03-08-2006 / 10:46:41 / fm"
!

y
	"Private - Answer the y coordinate of the point."
    ^self longAt: 4 + 1

    "Created: / 03-08-2006 / 10:46:26 / fm"
!

y: anInteger
	"Private - Set the y coordinate of the point."
    self longAt: 4 + 1 put: anInteger

    "Created: / 03-08-2006 / 10:46:56 / fm"
! !

!Win32OperatingSystem::WinPointStructure methodsFor:'printing'!

printOn: aStream
	"Append a textual representation of the receiver to aStream."
    aStream nextPutAll: self class name, ' { ', self asPoint printString, ' } '

    "Created: / 03-08-2006 / 10:45:40 / fm"
! !

!Win32OperatingSystem class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'

! !


Win32OperatingSystem initialize!
Win32OperatingSystem::PECOFFConstants initialize!
Win32OperatingSystem::PerformanceData initialize!
Win32OperatingSystem::RegistryEntry initialize!
