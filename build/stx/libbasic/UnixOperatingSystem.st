"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
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

AbstractOperatingSystem subclass:#UnixOperatingSystem
	instanceVariableNames:''
	classVariableNames:'Initialized HostName DomainName SlowFork ForkFailed
		CurrentDirectory LastTimeInfo LastTimeInfoSeconds
		LastTimeInfoMilliseconds LastTimeInfoIsLocal CachedMountPoints
		CacheMountPointsTimeStamp Codeset CodesetEncoder'
	poolDictionaries:''
	category:'OS-Unix'
!

SharedPool subclass:#ELFConstants
	instanceVariableNames:''
	classVariableNames:'EI_MAG0 ELFMAG0 EI_MAG1 ELFMAG1 EI_MAG2 ELFMAG2 EI_MAG3 ELFMAG3
		EI_CLASS ELFCLASSNONE ELFCLASS32 ELFCLASS64 ELFCLASSNUM EI_DATA
		ELFDATANONE ELFDATA2LSB ELFDATA2MSB ELFDATANUM EI_VERSION
		EI_OSABI ELFOSABI_NONE ELFOSABI_SYSV ELFOSABI_HPUX
		ELFOSABI_NETBSD ELFOSABI_GNU ELFOSABI_LINUX ELFOSABI_SOLARIS
		ELFOSABI_AIX ELFOSABI_IRIX ELFOSABI_FREEBSD ELFOSABI_TRU64
		ELFOSABI_MODESTO ELFOSABI_OPENBSD ELFOSABI_ARM_AEABI ELFOSABI_ARM
		ELFOSABI_STANDALONE EI_ABIVERSION EI_PAD ET_NONE ET_REL ET_EXEC
		ET_DYN ET_CORE ET_LOOS ET_HIOS ET_LOPROC ET_HIPROC EM_NONE EM_M32
		EM_SPARC EM_386 EM_68K EM_88K EM_860 EM_MIPS EM_S370
		EM_MIPS_RS3_LE EM_PARISC EM_VPP500 EM_SPARC32PLUS EM_960 EM_PPC
		EM_PPC64 EM_S390 EM_V800 EM_FR20 EM_RH32 EM_RCE EM_ARM
		EM_FAKE_ALPHA EM_SH EM_SPARCV9 EM_TRICORE EM_ARC EM_H8_300
		EM_H8_300H EM_H8S EM_H8_500 EM_IA_64 EM_MIPS_X EM_COLDFIRE
		EM_68HC12 EM_MMA EM_PCP EM_NCPU EM_NDR1 EM_STARCORE EM_ME16
		EM_ST100 EM_TINYJ EM_X86_64 EM_PDSP EM_FX66 EM_ST9PLUS EM_ST7
		EM_68HC16 EM_68HC11 EM_68HC08 EM_68HC05 EM_SVX EM_ST19 EM_VAX
		EM_CRIS EM_JAVELIN EM_FIREPATH EM_ZSP EM_MMIX EM_HUANY EM_PRISM
		EM_AVR EM_FR30 EM_D10V EM_D30V EM_V850 EM_M32R EM_MN10300
		EM_MN10200 EM_PJ EM_OPENRISC EM_ARC_A5 EM_XTENSA EM_AARCH64
		EM_TILEPRO EM_MICROBLAZE EM_TILEGX EM_ALPHA EV_NONE EV_CURRENT'
	poolDictionaries:''
	privateIn:UnixOperatingSystem
!

Object subclass:#ELFFileHeader
	instanceVariableNames:'file data msb'
	classVariableNames:''
	poolDictionaries:'UnixOperatingSystem::ELFConstants'
	privateIn:UnixOperatingSystem
!

Object subclass:#FileDescriptorHandle
	instanceVariableNames:'fd'
	classVariableNames:'OpenFiles'
	poolDictionaries:''
	privateIn:UnixOperatingSystem
!

OSFileHandle subclass:#FilePointerHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:UnixOperatingSystem
!

Object subclass:#FileStatusInfo
	instanceVariableNames:'type mode uid gid size id accessed modified statusChanged
		sourcePath targetPath numLinks'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UnixOperatingSystem
!

Object subclass:#MountInfo
	instanceVariableNames:'mountPointPath deviceOrRemotePath fsType attributeString'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UnixOperatingSystem
!

Object subclass:#OSProcessStatus
	instanceVariableNames:'pid status code core'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UnixOperatingSystem
!

UnixOperatingSystem::FilePointerHandle subclass:#SocketHandle
	instanceVariableNames:''
	classVariableNames:'ProtocolCache'
	poolDictionaries:''
	privateIn:UnixOperatingSystem
!

!UnixOperatingSystem primitiveDefinitions!
%{

#include "stxOSDefs.h"

#if defined(_AIX)
# ifndef WANT_REALPATH
#  define WANT_REALPATH
# endif
# ifndef WANT_SYSTEM
#  define WANT_SYSTEM
# endif
#endif

#ifdef LINUX

# define __xxUSE_GNU      /* new */
# undef HAS_UTS_DOMAINNAME
# define NET_IF_SUPPORT

# ifndef _STDIO_H_INCLUDED_
#  include <stdio.h>
#  define _STDIO_H_INCLUDED_
# endif

# ifndef _SYS_TYPES_H_INCLUDED_
#  include <sys/types.h>
#  define _SYS_TYPES_H_INCLUDED_
# endif
  /* use inline string macros */
# define __STRINGDEFS__
# include "linuxIntern.h"

# ifndef WANT_SYSTEM
#  define WANT_SYSTEM
# endif

# define WANT_SHM
# define HAS_SETENV
# define HAS_UNSETENV
# include <time.h>
#endif

#if defined(IRIX5) || defined(ultrix) || defined(hpux) || defined(solaris)
# define WANT_SYSTEM
#endif

#if defined(SYSV4) && defined(__i386__) /* e.g. unixware */
# define WANT_SYSTEM
#endif

#if defined (__osx__)
# define NET_IF_SUPPORT
#endif

/*
 * notice: although many systems' include files
 * already block against multiple inclusion, some
 * do not. Therefore, this is done here again.
 * (it does not hurt)
 */

#ifdef WANT_REALPATH
# ifndef NO_SYS_PARAM_H
#  include <sys/param.h>
#  define _SYS_PARAM_H_INCLUDED_
# endif

# include <errno.h>
# define _ERRNO_H_INCLUDED_

# include <sys/stat.h>
# define _SYS_STAT_H_INCLUDED_
#endif /* WANT_REALPATH */

# ifdef HAS_OPENDIR
#  include <sys/types.h>
#  ifdef NEXT
#   include <sys/dir.h>
#   define DIRENT_STRUCT        struct direct
#  else
#   include <dirent.h>
#   define DIRENT_STRUCT        struct dirent
#  endif
# endif

#ifdef WANT_SHM
# ifndef _SYS_TYPES_H_INCLUDED_
#  include <sys/types.h>
#  define _SYS_TYPES_H_INCLUDED_
# endif

# include <sys/ipc.h>
# define _SYS_IPC_H_INCLUDED_

# include <sys/shm.h>
# define _SYS_SHM_H_INCLUDED_
#endif /* WANT_SHM */

#ifdef IRIX5
# include <sys/syssgi.h>
#endif


#ifdef transputer

# define unlink(f)      ((remove(f) == 0) ? 0 : -1)

#else /* not transputer */

# ifdef __arm__
#  ifndef _SYS_TYPES_H_INCLUDED_
#   include <sys/types.h>
#   define _SYS_TYPES_H_INCLUDED_
#  endif
# endif

# ifndef _SIGNAL_H_INCLUDED_
#  include <signal.h>
#  define _SIGNAL_H_INCLUDED_
# endif

# ifdef SYSV
#  ifndef _SYS_TYPES_H_INCLUDED_
#   include <sys/types.h>
#   define _SYS_TYPES_H_INCLUDED_
#  endif

#  ifndef _SYS_PARAM_H_INCLUDED_
#   ifndef NO_SYS_PARAM_H
#    include <sys/param.h>
#    define _SYS_PARAM_H_INCLUDED_
#   endif
#  endif

#  ifndef _SYS_TIMES_H_INCLUDED_
#   include <sys/times.h>
#   define _SYS_TIMES_H_INCLUDED_
#  endif

#  ifndef _SYS_FILE_H_INCLUDED_
#   include <sys/file.h>
#   define _SYS_FILE_H_INCLUDED_
#  endif

#  ifndef _UNISTD_H_INCLUDED_
#   include <unistd.h>
#   define _UNISTD_H_INCLUDED_
#  endif

#  ifndef _TERMIOS_H_INCLUDED_
#   include <termios.h>
#   define _TERMIOS_H_INCLUDED_
#  endif


#  ifndef _TIME_H_INCLUDED_
#   include <time.h>
#   define _TIME_H_INCLUDED_
#  endif

# else /* not SYSV */

#  ifndef _SYS_TIME_H_INCLUDED_
#   include <sys/time.h>
#   define _SYS_TIME_H_INCLUDED_
#  endif

#  ifndef _SYS_TYPES_H_INCLUDED_
#   include <sys/types.h>
#   define _SYS_TYPES_H_INCLUDED_
#  endif

# endif /* not SYSV */


# ifdef aix
#  ifndef _TIME_H_INCLUDED_
#   include <time.h>
#   define _TIME_H_INCLUDED_
#  endif
#  ifndef _SYS_SELECT_H_INCLUDED_
#   include <sys/select.h>
#   define _SYS_SELECT_H_INCLUDED_
#  endif
# endif /* aix */

# ifdef __osx__
#  include <string.h>
#  include <stdlib.h>
#  include <time.h>
#  ifndef _TIME_H_
/* hack if the osx has been configured with case-ignoring filenames,
 * my own time.h was included above
 */
#   include "/usr/include/time.h"
#  endif
#  include <sys/time.h>
#  define HAS_TIMEGM

#  ifdef NO_LONGER_NEEDED
#   ifndef _TIME_H_
// old hack
struct tm {
	int     tm_sec;         /* seconds after the minute [0-60] */
	int     tm_min;         /* minutes after the hour [0-59] */
	int     tm_hour;        /* hours since midnight [0-23] */
	int     tm_mday;        /* day of the month [1-31] */
	int     tm_mon;         /* months since January [0-11] */
	int     tm_year;        /* years since 1900 */
	int     tm_wday;        /* days since Sunday [0-6] */
	int     tm_yday;        /* days since January 1 [0-365] */
	int     tm_isdst;       /* Daylight Savings Time flag */
	long    tm_gmtoff;      /* offset from CUT in seconds */
	char    *tm_zone;       /* timezone abbreviation */
};
#   endif
#  endif /* NO_LONGER */

#  include <crt_externs.h>
#  include <net/if_dl.h>

# endif /* __osx__ */

# ifndef _STDIO_H_INCLUDED_
#  include <stdio.h>
#  define _STDIO_H_INCLUDED_
# endif

# ifndef _PWD_H_INCLUDED_
#  include <pwd.h>
#  define _PWD_H_INCLUDED_
# endif

# ifndef NO_GRP_H
#  ifndef _GRP_H_INCLUDED_
#   include <grp.h>
#   define _GRP_H_INCLUDED_
#  endif
# endif


# ifndef _SYS_STAT_H_INCLUDED_
#  include <sys/stat.h>
#  define _SYS_STAT_H_INCLUDED_
# endif

# ifndef _SYS_FILE_H_INCLUDED_
#  include <sys/file.h>
#  define _SYS_FILE_H_INCLUDED_
# endif

# ifndef _ERRNO_H_INCLUDED_
#  include <errno.h>
#  define _ERRNO_H_INCLUDED_
# endif

# ifndef _FCNTL_H_INCLUDED_
#  include <fcntl.h>
#  define _FCNTL_H_INCLUDED_
# endif

# ifndef _SYS_IOCTL_H_INCLUDED_
#  include <sys/ioctl.h>
#  define _SYS_IOCTL_H_INCLUDED_
# endif

# if defined(LINUX)
#  define HAS_LOCALECONV
# endif

# if defined (HAS_LOCALECONV)
#  ifndef _LOCALE_H_INCLUDED_
#   include <locale.h>
#   define _LOCALE_H_INCLUDED_
#  endif
# endif

# if defined (HAS_FTIME)
#  include <sys/timeb.h>
# endif

// #include <signal.h>

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
#  ifndef NO_SYS_PARAM_H
#   include <sys/param.h>
#  endif

#  ifndef MAXPATHLEN
#   ifdef PATH_MAX
#    define MAXPATHLEN PATH_MAX
#   else
#    define MAXPATHLEN 1024
#   endif
#  endif

# endif

# if defined(HAS_UNAME)
#  include <sys/utsname.h>
# endif

# if defined(SYSV4)
#  include <stropts.h>
# endif

# ifndef aix
#  include <sys/termios.h>
# endif

/*
 * NeXT has no pid_t
 * and no sigemptyset
 */
# ifdef NEXT
#  define NO_WAITPID
# endif
# ifdef NEXT3
   typedef int pid_t;
#  define sigemptyset(set)      ((*(set) = 0L), 0)
#  define HAS_GETDOMAINNAME
#  define NO_WAITPID
# endif

# ifdef sunos
#  undef NO_WAITPID
#  undef HAS_WAITPID
#  define HAS_WAIT3
#  define HAS_SIGACTION
# endif
//# ifdef sunos
//#  define NO_WAITPID
//# endif

# ifdef __osx__
#  undef NO_WAITPID
#  undef xxHAS_WAITPID
#  define HAS_WAITPID
#  define HAS_WAIT3
#  define HAS_SIGACTION
#  include <unistd.h>
# endif

# ifdef HAS_WAIT3
#  ifdef __osx__
#   define WAIT_STATUS int
#  else
#   define WAIT_STATUS union wait
#  endif
# endif

/*
 * some (BSD ?) have no timezone global,
 * but provide the info in struct timezone.
 */
# if defined(ultrix) || defined(sunos) || defined(NEXT)
#  define HAS_NO_TIMEZONE
# endif
# if defined(__osx__)
#  define HAS_NO_TIMEZONE
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
#  include <sys/sysinfo.h>
#  include <sys/systeminfo.h>
# endif

# ifdef LINUX
#  include <linux/kernel.h>
# endif

# if defined(HAS_GETSYSINFO)
#  include <sys/sysinfo.h>
#  include <machine/hal_sysinfo.h>
#  include <machine/hal/cpuconf.h>
# endif

# if defined(HAS_SYSCONF)
#  ifndef _UNISTD_H_INCLUDED_
#   include <unistd.h>
#   define _UNISTD_H_INCLUDED_
#  endif
# endif

# if defined(HAS_SYSCTL)
#  include <sys/types.h>
#  include <sys/sysctl.h>
# endif

#endif /* not transputer */

#ifndef NO_SOCKET
# define __USE_GNU      // For AI_IDN in netdb.h
# include <netdb.h>
#endif

/*
 * on some systems errno is a macro ... check for it here
 */
#ifndef errno
 extern int errno;
#endif

/*
 * some (old ?) systems do not define this ...
 */
#if !defined(R_OK) && !defined(_AIX)
# define R_OK    4       /* Test for Read permission */
# define W_OK    2       /* Test for Write permission */
# define X_OK    1       /* Test for eXecute permission */
# define F_OK    0       /* Test for existence of File */
#endif

#define SIGHANDLER_ARG

/*
 * where is the timezone info ?
 */
#ifdef HAS_TM_GMTOFF
# define TIMEZONE(tmPtr)       (-((tmPtr)->tm_gmtoff))
#else
# if defined(HAS_NO_TIMEZONE)
#  if defined(HAS_NO_TM_GMTOFF)
#   define TIMEZONE(tmPtr)       0
#  else
#   define TIMEZONE(tmPtr)       (-((tmPtr)->tm_gmtoff))
#  endif
# else
#  if defined(HAS_ALTZONE)
#   define TIMEZONE(tmPtr)       ((tmPtr)->tm_isdst == 0 ? timezone : altzone)
#  else  /*!HAS_ALTZONE*/
#   define TIMEZONE(tmPtr)       ((tmPtr)->tm_isdst == 0 ? timezone : timezone-3600)
#  endif /*!HAS_ALTZONE*/
# endif
#endif
#ifndef CONST
# ifdef __GNUC__
#  define CONST const
# else
#  define CONST /* nothing */
# endif
#endif

#ifndef        FORK
# if defined(HAS_VFORK)
#  define     FORK            vfork
# else
#  define     FORK            fork
# endif
#endif



/*
 * Socket defines
 */
#include "stxOSDefs.h"

#ifdef NET_IF_SUPPORT  /* for mac address of interfaces */

# ifndef _NET_IF_H_INCLUDED_
#  include <net/if.h>
#  define _NET_IF_H_INCLUDED_
# endif

# ifndef _SYS_IOCTL_H_INCLUDED_
#  include <sys/ioctl.h>
#  define _SYS_IOCTL_H_INCLUDED_
# endif

#endif /* NET_IF_SUPPORT */

#if defined(TRY_AGAIN) || defined(HOST_NOT_FOUND)
# define USE_H_ERRNO
#endif

#ifdef USE_H_ERRNO
# ifndef h_errno
 extern h_errno;
# endif
#endif

#if (defined(__ELD__) || defined (ELF))
# ifndef ELFMAG1
#  include <elf.h>
# endif
#endif

%}
! !

!UnixOperatingSystem primitiveFunctions!
%{

/*
 * some systems' system() is broken in that it does not correctly
 * handle EINTR and returns failure even though it actually succeeded.
 * (LINUX is one of them)
 * Here is a fixed version. If you encounter EINTR returns from
 * UnixOperatingSystem>>executeCommand, you ought to define WANT_SYSTEM
 * in the xxxIntern.h file to get this fixed version.
 *
 * As an added BONUS, this system() enables interrupts while waiting
 * for the child which enables other threads to continue.
 * (i.e. it is RT safe)
 */

#if defined(WANT_SYSTEM)

/* # define DPRINTF(x)     printf x */
# define DPRINTF(x)     /* nothing */

# ifndef _STDDEF_H_INCLUDED_
#  include <stddef.h>
#  define _STDDEF_H_INCLUDED_
# endif

# ifndef _STDLIB_H_INCLUDED_
#  include <stdlib.h>
#  define _STDLIB_H_INCLUDED_
# endif

# ifndef _UNISTD_H_INCLUDED_
#  include <unistd.h>
#  define _UNISTD_H_INCLUDED_
# endif

# ifndef _SYS_WAIT_H_INCLUDED
#  include <sys/wait.h>
#  define _SYS_WAIT_H_INCLUDED
# endif

# ifndef _SIGNAL_H_INCLUDED_
#  include <signal.h>
#  define _SIGNAL_H_INCLUDED_
# endif

# ifndef _SYS_TYPES_H_INCLUDED_
#  include <sys/types.h>
#  define _SYS_TYPES_H_INCLUDED_
# endif

# if (!defined(HAVE_GNU_LD) && !defined (__ELF__)) || !defined(LINUX)
#  define       __environ       environ
    extern char **environ;
# endif

# if !defined (__sigemptyset)
#  define      __sigemptyset   sigemptyset
# endif
# if !defined (__sigaction)
#  define      __sigaction     sigaction
#  define      __sigaddset     sigaddset
#  define      __sigprocmask   sigprocmask
#  define      __execve        execve
#  define      __wait          wait
#  define      __waitpid       waitpid
# endif /* ! LINUX */

# define      __sigprocmask   sigprocmask
# define      __execve        execve

# define        SHELL_PATH      "/bin/sh"       /* Path of the shell.  */
# define        SHELL_NAME      "sh"            /* Name to give it.  */


static int
mySystem(const char *line)
{
    int status, save;
    pid_t pid;
    struct sigaction sa, intr, quit;
    sigset_t block, omask;

    if (line == NULL)
	return -1;

    sa.sa_handler = SIG_IGN;
    sa.sa_flags = 0;
    __sigemptyset (&sa.sa_mask);

    if (__sigaction (SIGINT, &sa, &intr) < 0) {
	DPRINTF(("1: errno=%d\n", errno));
	return -1;
    }
    if (__sigaction (SIGQUIT, &sa, &quit) < 0) {
	save = errno;
	(void) __sigaction (SIGINT, &intr, (struct sigaction *) NULL);
	errno = save;
	DPRINTF(("2: errno=%d\n", errno));
	return -1;
    }

    __sigemptyset (&block);
    __sigaddset (&block, SIGCHLD);
    save = errno;
    if (__sigprocmask(SIG_BLOCK, &block, &omask) < 0) {
	if (errno == ENOSYS)
	    errno = save;
	else {
	    save = errno;
	    (void) __sigaction(SIGINT, &intr, (struct sigaction *) NULL);
	    (void) __sigaction (SIGQUIT, &quit, (struct sigaction *) NULL);
	    errno = save;
	    DPRINTF(("3: errno=%d\n", errno));
	    return -1;
	}
    }

    pid = FORK ();
    if (pid == (pid_t) 0) {
	/* Child side.  */
	CONST char *new_argv[4];
	new_argv[0] = SHELL_NAME;
	new_argv[1] = "-c";
	new_argv[2] = line;
	new_argv[3] = NULL;

	/* Restore the signals.  */
	(void) __sigaction (SIGINT, &intr, (struct sigaction *) NULL);
	(void) __sigaction (SIGQUIT, &quit, (struct sigaction *) NULL);
	(void) __sigprocmask (SIG_SETMASK, &omask, (sigset_t *) NULL);

	/* Exec the shell.  */
	(void) __execve (SHELL_PATH, (char *CONST *) new_argv, __environ);
	_exit (127);
    } else {
	if (pid < (pid_t) 0) {
	    /* The fork failed.  */
	    DPRINTF(("4: errno=%d\n", errno));
	    status = -1;
	} else {
	    /* Parent side.  */
#ifdef  NO_WAITPID
	    pid_t child;

	    do {
		__BEGIN_INTERRUPTABLE__
		child = __wait (&status);
		__END_INTERRUPTABLE__
		if (child < 0 && errno != EINTR) {
		    DPRINTF(("5: errno=%d\n", errno));
		    status = -1;
		    break;
		}
	    } while (child != pid);
#else
	    pid_t child;

	    /* claus: the original did not care for EINTR here ... */
	    do {
		__BEGIN_INTERRUPTABLE__
		child = __waitpid (pid, &status, 0);
		__END_INTERRUPTABLE__
	    } while ((child != pid) && (errno == EINTR));
	    if (child != pid) {
		DPRINTF(("6: errno=%d\n", errno));
		status = -1;
	    }
#endif /* NO_WAITPID */
	}
    }
    save = errno;
    if ((__sigaction (SIGINT, &intr, (struct sigaction *) NULL)
     | __sigaction (SIGQUIT, &quit, (struct sigaction *) NULL)
     | __sigprocmask (SIG_SETMASK, &omask, (sigset_t *) NULL)) != 0) {
	if (errno == ENOSYS) {
	    errno = save;
	} else {
	    status = -1;
	    DPRINTF(("7: errno=%d\n", errno));
	}
    }

    return status;
}
#else
# define __wait wait
#endif /* WANT_SYSTEM */


/*
 * some systems do not have realpath();
 * the alternative of reading from a 'pwd'-pipe
 * is way too slow. Here is a realpath for the rest of us.
 * define WANT_REALPATH in the xxxIntern-file to get it.
 */

#if defined(HAS_REALPATH)
# undef WANT_REALPATH
#endif
#if !defined(HAS_GETWD) && !defined(HAS_GETCWD)
# undef WANT_REALPATH
#endif

#if defined(WANT_REALPATH)

# ifndef NULL
#  define NULL (char *)0
# endif

# define MAX_READLINKS 32

# ifndef MAXPATHLEN
#  define MAXPATHLEN     1024
# endif

static char *
realpath(const char *path, char *resolved_path)
{
	char copy_path[MAXPATHLEN];
	char link_path[MAXPATHLEN];
	char *new_path, *max_path, *mallocedPath;
	int readlinks = 0;
	int n;

	if (resolved_path == NULL) {
	    mallocedPath = resolved_path = malloc(MAXPATHLEN+1);
	}
	new_path = resolved_path;

	/* Make a copy of the source path since we may need to modify it. */
	strcpy(copy_path, path);
	path = copy_path;
	max_path = copy_path + MAXPATHLEN - 2;
	/* If it's a relative pathname use getwd for starters. */
	if (*path != '/') {
#ifdef HAS_GETCWD
		new_path = getcwd(new_path, MAXPATHLEN - 1);
#else
		new_path = getwd(new_path);
#endif
		if (new_path == NULL) {
		    if (mallocedPath) free(mallocedPath);
		    return(NULL);
		}

		new_path += strlen(new_path);
		if (new_path[-1] != '/')
			*new_path++ = '/';
	}
	else {
		*new_path++ = '/';
		path++;
	}
	/* Expand each slash-separated pathname component. */
	while (*path != '\0') {
		/* Ignore stray "/". */
		if (*path == '/') {
			path++;
			continue;
		}
		if (*path == '.') {
			/* Ignore ".". */
			if (path[1] == '\0' || path[1] == '/') {
				path++;
				continue;
			}
			if (path[1] == '.') {
				if (path[2] == '\0' || path[2] == '/') {
					path += 2;
					/* Ignore ".." at root. */
					if (new_path == resolved_path + 1)
						continue;
					/* Handle ".." by backing up. */
					while ((--new_path)[-1] != '/')
						;
					continue;
				}
			}
		}
		/* Safely copy the next pathname component. */
		while (*path != '\0' && *path != '/') {
			if (path > max_path) {
			    if (mallocedPath) free(mallocedPath);
			    errno = ENAMETOOLONG;
			    return NULL;
			}
			*new_path++ = *path++;
		}
#ifdef S_IFLNK
		/* Protect against infinite loops. */
		if (readlinks++ > MAX_READLINKS) {
		    if (mallocedPath) free(mallocedPath);
		    errno = ELOOP;
		    return NULL;
		}
		/* See if latest pathname component is a symlink. */
		*new_path = '\0';
		n = readlink(resolved_path, link_path, MAXPATHLEN - 1);
		if (n < 0) {
			/* EINVAL means the file exists but isn't a symlink. */
			if (errno != EINVAL) {
			    if (mallocedPath) free(mallocedPath);
			    return NULL;
			}
		}
		else {
			/* Note: readlink doesn't add the null byte. */
			link_path[n] = '\0';
			if (*link_path == '/')
				/* Start over for an absolute symlink. */
				new_path = resolved_path;
			else
				/* Otherwise back up over this component. */
				while (*(--new_path) != '/')
					;
			/* Safe sex check. */
			if (strlen(path) + n >= MAXPATHLEN) {
			    if (mallocedPath) free(mallocedPath);
			    errno = ENAMETOOLONG;
			    return NULL;
			}
			/* Insert symlink contents into path. */
			strcat(link_path, path);
			strcpy(copy_path, link_path);
			path = copy_path;
		}
#endif /* S_IFLNK */
		*new_path++ = '/';
	}
	/* Delete trailing slash but don't whomp a lone slash. */
	if (new_path != resolved_path + 1 && new_path[-1] == '/')
		new_path--;
	/* Make sure it's null terminated. */
	*new_path = '\0';
	return resolved_path;
}
# define HAS_REALPATH
#endif /* WANT_REALPATH && not HAS_REALPATH */

%}
! !

!UnixOperatingSystem class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
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
    This class realizes access to most (all?) required operating system services.
    At startup, the global 'OperatingSystem' will be bound to either me, or one of
    my sibling classes, Win32OperatingSystem, VMSOperatinSystem or OSXOperatingSystem.

    Never access UnixOperatingSystem directly. Always only refer to OperatingSystem,
    if at all. Most functionality is actually used indirectly, via the Filename, PipeStream
    or Socket classes.

    Some of the functions are specific for unix, some may not be found in other OS's
    or behave slightly different, returning different data.

    For portable programs, only rely on protocol which is found in my abstract
    superclass, and will therefore also be found in my correspnding sibling os-classes
    (i.e. Win32OperatingSystem).
    If you need os-specific functionality, surround it by a condition, such as
    OperatingSystem isUNIXlike or OperatingSystem isMSWINDOWSlike.

    On the other hand: I do not want to hide all features
    from you - in some situations it MAY be interesting to be
    able to get down to a select or fork system call easily (at least on Unix systems).
    You decide - portability vs. functionality.

    Notice, that on Unix systems, the Win32OperatingSystem class is not even loaded,
    and vice versa. So you may have to open a changes browser on the other class, to check
    how the corresponding function operates in the other os.

    [Class variables:]

	HostName        <String>        remembered hostname

	DomainName      <String>        remembered domainname

	SlowFork        <Boolean>       if set, fork and popen are avoided;
					(more or less obsolete now)


	CurrentDirectory <String>       remembered currentDirectories path

    [author:]
	Claus Gittinger

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

!UnixOperatingSystem class methodsFor:'initialization'!

initialize
    "initialize the class"

    "/ protect against double initialization
    Initialized isNil ifTrue:[
	ObjectMemory addDependent:self.
	self initializeCachedData.
	Initialized := true.
    ].
!

initializeCachedData
    HostName := nil.
    DomainName := nil.
    LastErrorNumber := nil.
    PipeFailed := false.
    ForkFailed := false.
    SlowFork := false.
    CurrentDirectory := nil.
    self initializeCodeset.

    "Modified: / 19-11-2017 / 14:52:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeCodeset
    "initialize the codeset, we are running under.
     The codeset is determined from the environment.
     The LC_CTYPE locale is set from the environment as a side effect."

    |codeset|

%{
#include <langinfo.h>
    char *__codeset;

    setlocale(LC_CTYPE, "");
    __codeset = nl_langinfo(CODESET);
    if (strlen(__codeset) > 0) {
	codeset = __MKSTRING(__codeset);
    }
%}.
    codeset notNil ifTrue:[
	codeset := codeset asLowercase.
	codeset = 'utf-8' ifTrue:[
	    codeset := #utf8.
	] ifFalse:[
	    codeset := codeset asSymbol.
	].
    ].
    Codeset := codeset.
    ^ codeset.

    "
     OperatingSystem initializeCodeset
    "
!

initializeLocale
    | locale |

    "/ Defaults
    Language := #en.
    LanguageTerritory := #us.   

    "/ Extract locale information from LC_ALL / LANG env variables.
    "/ Format of locale is: language[_territory][.codeset][@modifier]
    "/    language        ISO-639  Language code
    "/    territory       ISO-3166 Contry code
    locale := self getEnvironment: 'LC_ALL'.
    locale isNil ifTrue:[ locale := self getEnvironment: 'LANG' ].
    locale isNil ifTrue:[ locale := 'en' ].          
    locale notNil ifTrue:[ 
        | i lang territory |

        i := locale indexOf:$@.
        (i ~~ 0) ifTrue:[
            LanguageModifier := (locale copyFrom:(i + 1)) asLowercase asSymbol.
            locale := locale copyTo:(i - 1).
        ] ifFalse:[
            LanguageModifier := nil.
        ].
        i := locale indexOf:$..
        (i ~~ 0) ifTrue:[
            LanguageCodeset := (locale copyFrom:(i + 1)) asLowercase asSymbol.
            locale := locale copyTo:(i - 1).
        ] ifFalse:[
            LanguageCodeset := #'iso8859-1'.
        ].
        i := locale indexOf:$_.
        (i == 0) ifTrue:[
            lang := locale.
            territory := locale
        ] ifFalse:[
            lang := locale copyTo:(i - 1).
            territory := locale copyFrom:(i + 1)
        ].
        lang := lang asLowercase.
        territory := territory asLowercase.
        (lang = 'c') ifTrue:[
            Language := #en.
            LanguageTerritory := #us.
        ] ifFalse:[
            Language := lang asSymbol.
            LanguageTerritory := territory asSymbol
        ] 
    ].

    "Created: / 19-11-2017 / 14:26:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "catch image restart and flush some cached data"

    something == #earlyRestart ifTrue:[
	self initializeCachedData
    ]

    "Created: / 15.6.1996 / 15:22:37 / cg"
    "Modified: / 7.1.1997 / 19:36:11 / stefan"
    "Modified: / 11.12.1998 / 16:22:48 / cg"
! !

!UnixOperatingSystem class methodsFor:'OS signal constants'!

sigABRT
    "return the signal number for SIGABRT - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGABRT

    "
     OperatingSystem sigABRT
    "
!

sigALRM
    "return the signal number for SIGALRM - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGALRM

    "
     OperatingSystem sigALRM
    "
!

sigBREAK
    "return the signal number for SIGBREAK - 0 if not supported.
     This is an MSDOS specific signal"

    ^ self signalNamed:#SIGBREAK

    "
     OperatingSystem sigBREAK
    "
!

sigBUS
    "return the signal number for SIGBUS - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGBUS

    "
     OperatingSystem sigBUS
    "
!

sigCHLD
    "return the signal number for SIGCHLD - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGCHLD

    "
     OperatingSystem sigCHLD
    "
!

sigCONT
    "return the signal number for SIGCONT - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGCONT

    "
     OperatingSystem sigCONT
    "
!

sigDANGER
    "return the signal number for SIGDANGER - 0 if not supported
     (seems to be an AIX special)"

    ^ self signalNamed:#SIGDANGER

    "
     OperatingSystem sigDANGER
    "
!

sigEMT
    "return the signal number for SIGEMT - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGEMT

    "
     OperatingSystem sigEMT
    "
!

sigFP
    "return the signal number for SIGFP - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGFPE

    "
     OperatingSystem sigFP
    "
!

sigGRANT
    "return the signal number for SIGGRANT - 0 if not supported
     (seems to be an AIX special)"

    ^ self signalNamed:#SIGGRANT

    "
     OperatingSystem sigGRANT
    "
!

sigHUP
    "return the signal number for SIGHUP
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGHUP

    "
     OperatingSystem sigHUP
    "

!

sigILL
    "return the signal number for SIGILL - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGILL

    "
     OperatingSystem sigILL
    "
!

sigINT
    "return the signal number for SIGINT
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGINT

    "
     OperatingSystem sigINT
    "
!

sigIO
    "return the signal number for SIGIO - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGIO

    "
     OperatingSystem sigIO
    "
!

sigIOT
    "return the signal number for SIGIOT - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGIOT

    "
     OperatingSystem sigIOT
    "
!

sigKILL
    "return the signal number for SIGKILL
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGKILL

    "
     OperatingSystem sigKILL
    "
!

sigLOST
    "return the signal number for SIGLOST - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGLOST

    "
     OperatingSystem sigLOST
    "
!

sigMIGRATE
    "return the signal number for SIGMIGRATE - 0 if not supported
     (seems to be an AIX special)"

    ^ self signalNamed:#SIGMIGRATE

    "
     OperatingSystem sigMIGRATE
    "
!

sigMSG
    "return the signal number for SIGMSG - 0 if not supported
     (seems to be an AIX special)"

    ^ self signalNamed:#SIGMSG

    "
     OperatingSystem sigMSG
    "
!

sigPIPE
    "return the signal number for SIGPIPE - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGPIPE

    "
     OperatingSystem sigPIPE
    "

!

sigPOLL
    "return the signal number for SIGPOLL - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGPOLL

    "
     OperatingSystem sigPOLL
    "
!

sigPRE
    "return the signal number for SIGPRE - 0 if not supported
     (seems to be an AIX special)"

    ^ self signalNamed:#SIGPRE

    "
     OperatingSystem sigPRE
    "
!

sigPROF
    "return the signal number for SIGPROF - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGPROF

    "
     OperatingSystem sigPROF
    "
!

sigPWR
    "return the signal number for SIGPWR - 0 if not supported
     (not available on all systems)"

    ^ self signalNamed:#SIGPWR

    "
     OperatingSystem sigPWR
    "
!

sigQUIT
    "return the signal number for SIGQUIT
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGQUIT

    "
     OperatingSystem sigQUIT
    "
!

sigRETRACT
    "return the signal number for SIGRETRACT - 0 if not supported
     (seems to be an AIX special)"

    ^ self signalNamed:#SIGRETRACT

    "
     OperatingSystem sigRETRACT
    "

!

sigSAK
    "return the signal number for SIGSAK - 0 if not supported
     (seems to be an AIX special)"

    ^ self signalNamed:#SIGSAK

    "
     OperatingSystem sigSAK
    "

!

sigSEGV
    "return the signal number for SIGSEGV - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGSEGV

    "
     OperatingSystem sigSEGV
    "

!

sigSOUND
    "return the signal number for SIGSOUND - 0 if not supported
     (seems to be an AIX special)"

    ^ self signalNamed:#SIGSOUND

    "
     OperatingSystem sigSOUND
    "

!

sigSTOP
    "return the signal number for SIGSTOP - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGSTOP

    "
     OperatingSystem sigSTOP
    "
!

sigSYS
    "return the signal number for SIGSYS - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGSYS

    "
     OperatingSystem sigSYS
    "
!

sigTERM
    "return the signal number for SIGTERM - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGTERM

    "
     OperatingSystem sigTERM
    "

!

sigTRAP
    "return the signal number for SIGTRAP - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGTRAP

    "
     OperatingSystem sigTRAP
    "
!

sigTSTP
    "return the signal number for SIGTSTP - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGTSTP

    "
     OperatingSystem sigTSTP
    "
!

sigTTIN
    "return the signal number for SIGTTIN - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGTTIN

    "
     OperatingSystem sigTTIN
    "
!

sigTTOU
    "return the signal number for SIGTTOU - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGTTOU

    "
     OperatingSystem sigTTOU
    "
!

sigURG
    "return the signal number for SIGURG - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGURG

    "
     OperatingSystem sigURG
    "
!

sigUSR1
    "return the signal number for SIGUSR1 - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGUSR1

    "
     OperatingSystem sigUSR1
    "
!

sigUSR2
    "return the signal number for SIGUSR2 - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGUSR2

    "
     OperatingSystem sigUSR2
    "
!

sigVTALRM
    "return the signal number for SIGVTALRM - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGVTALRM

    "
     OperatingSystem sigVTALRM
    "
!

sigWINCH
    "return the signal number for SIGWINCH - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGWINCH

    "
     OperatingSystem sigWINCH
    "

!

sigXCPU
    "return the signal number for SIGXCPU - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGXCPU

    "
     OperatingSystem sigXCPU
    "

!

sigXFSZ
    "return the signal number for SIGXFSZ - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ self signalNamed:#SIGXFSZ

    "
     OperatingSystem sigXFSZ
    "

!

signalNamed:signalName
    "return the signal number for a named signal (must be a symbol)
     Return 0 if that signal is not supported by the OS
     (NOTICE: the numeric value is not the same across unix-systems,
      therefore do not remember or hardcode those numbers in the application)"

%{  /* NOCONTEXT */
#ifdef SIGABRT
    if (signalName == @symbol(SIGABRT)) {
	RETURN ( __mkSmallInteger(SIGABRT) );
    }
#endif
#ifdef SIGALRM
    if (signalName == @symbol(SIGALRM)) {
	RETURN ( __mkSmallInteger(SIGALRM) );
    }
#endif
#ifdef SIGBREAK
    if (signalName == @symbol(SIGBREAK)) {
	RETURN ( __mkSmallInteger(SIGBREAK) );
    }
#endif
#ifdef SIGBUS
    if (signalName == @symbol(SIGBUS)) {
	RETURN ( __mkSmallInteger(SIGBUS) );
    }
#endif
#ifdef SIGCHLD
    if ((signalName == @symbol(SIGCHLD))
     || (signalName == @symbol(SIGCLD)) ) {
	RETURN ( __mkSmallInteger(SIGCHLD) );
    }
#else
# if defined(SIGCLD)
    if ((signalName == @symbol(SIGCHLD))
     || (signalName == @symbol(SIGCLD)) ) {
	RETURN ( __mkSmallInteger(SIGCLD) );
    }
# endif
#endif
#ifdef SIGCONT
    if (signalName == @symbol(SIGCONT)) {
	RETURN ( __mkSmallInteger(SIGCONT) );
    }
#endif
#ifdef SIGDANGER
    if (signalName == @symbol(SIGDANGER)) {
	RETURN ( __mkSmallInteger(SIGDANGER) );
    }
#endif
#ifdef SIGEMT
    if (signalName == @symbol(SIGEMT)) {
	RETURN ( __mkSmallInteger(SIGEMT) );
    }
#endif
#ifdef SIGFPE
    if (signalName == @symbol(SIGFPE)) {
	RETURN ( __mkSmallInteger(SIGFPE) );
    }
#endif
#ifdef SIGGRANT
    if (signalName == @symbol(SIGGRANT)) {
	RETURN ( __mkSmallInteger(SIGGRANT) );
    }
#endif
#ifdef SIGHUP
    if (signalName == @symbol(SIGHUP)) {
	RETURN ( __mkSmallInteger(SIGHUP) );
    }
#endif
#ifdef SIGILL
    if (signalName == @symbol(SIGILL)) {
	RETURN ( __mkSmallInteger(SIGILL) );
    }
#endif
#ifdef SIGINT
    if (signalName == @symbol(SIGINT)) {
	RETURN ( __mkSmallInteger(SIGINT) );
    }
#endif
#ifdef SIGIO
    if (signalName == @symbol(SIGIO)) {
	RETURN ( __mkSmallInteger(SIGIO) );
    }
#endif
#ifdef SIGIOT
    if (signalName == @symbol(SIGIOT)) {
	RETURN ( __mkSmallInteger(SIGIOT) );
    }
#endif
#ifdef SIGKILL
    if (signalName == @symbol(SIGKILL)) {
	RETURN ( __mkSmallInteger(SIGKILL) );
    }
#endif
#ifdef SIGLOST
    if (signalName == @symbol(SIGLOST)) {
	RETURN ( __mkSmallInteger(SIGLOST) );
    }
#endif
#ifdef SIGMIGRATE
    if (signalName == @symbol(SIGMIGRATE)) {
	RETURN ( __mkSmallInteger(SIGMIGRATE) );
    }
#endif
#ifdef SIGMSG
    if (signalName == @symbol(SIGMSG)) {
	RETURN ( __mkSmallInteger(SIGMSG) );
    }
#endif
#ifdef SIGPIPE
    if (signalName == @symbol(SIGPIPE)) {
	RETURN ( __mkSmallInteger(SIGPIPE) );
    }
#endif
#ifdef SIGPOLL
    if (signalName == @symbol(SIGPOLL)) {
	RETURN ( __mkSmallInteger(SIGPOLL) );
    }
#endif
#ifdef SIGPRE
    if (signalName == @symbol(SIGPRE)) {
	RETURN ( __mkSmallInteger(SIGPRE) );
    }
#endif
#ifdef SIGPROF
    if (signalName == @symbol(SIGPROF)) {
	RETURN ( __mkSmallInteger(SIGPROF) );
    }
#endif
#ifdef SIGPWR
    if (signalName == @symbol(SIGPWR)) {
	RETURN ( __mkSmallInteger(SIGPWR) );
    }
#endif
#ifdef SIGQUIT
    if (signalName == @symbol(SIGQUIT)) {
	RETURN ( __mkSmallInteger(SIGQUIT) );
    }
#endif
#ifdef SIGRETRACT
    if (signalName == @symbol(SIGRETRACT)) {
	RETURN ( __mkSmallInteger(SIGRETRACT) );
    }
#endif
#ifdef SIGSAK
    if (signalName == @symbol(SIGSAK)) {
	RETURN ( __mkSmallInteger(SIGSAK) );
    }
#endif
#ifdef SIGSEGV
    if (signalName == @symbol(SIGSEGV)) {
	RETURN ( __mkSmallInteger(SIGSEGV) );
    }
#endif
#ifdef SIGSOUND
    if (signalName == @symbol(SIGSOUND)) {
	RETURN ( __mkSmallInteger(SIGSOUND) );
    }
#endif
#ifdef SIGSTOP
    if (signalName == @symbol(SIGSTOP)) {
	RETURN ( __mkSmallInteger(SIGSTOP) );
    }
#endif
#ifdef SIGSYS
    if (signalName == @symbol(SIGSYS)) {
	RETURN ( __mkSmallInteger(SIGSYS) );
    }
#endif
#ifdef SIGTERM
    if (signalName == @symbol(SIGTERM)) {
	RETURN ( __mkSmallInteger(SIGTERM) );
    }
#endif
#ifdef SIGTRAP
    if (signalName == @symbol(SIGTRAP)) {
	RETURN ( __mkSmallInteger(SIGTRAP) );
    }
#endif
#ifdef SIGTSTP
    if (signalName == @symbol(SIGTSTP)) {
	RETURN ( __mkSmallInteger(SIGTSTP) );
    }
#endif
#ifdef SIGTTIN
    if (signalName == @symbol(SIGTTIN)) {
	RETURN ( __mkSmallInteger(SIGTTIN) );
    }
#endif
#ifdef SIGTTOU
    if (signalName == @symbol(SIGTTOU)) {
	RETURN ( __mkSmallInteger(SIGTTOU) );
    }
#endif
#ifdef SIGURG
    if (signalName == @symbol(SIGURG)) {
	RETURN ( __mkSmallInteger(SIGURG) );
    }
#endif
#ifdef SIGUSR1
    if (signalName == @symbol(SIGUSR1)) {
	RETURN ( __mkSmallInteger(SIGUSR1) );
    }
#endif
#ifdef SIGUSR2
    if (signalName == @symbol(SIGUSR2)) {
	RETURN ( __mkSmallInteger(SIGUSR2) );
    }
#endif
#ifdef SIGVTALRM
    if (signalName == @symbol(SIGVTALRM)) {
	RETURN ( __mkSmallInteger(SIGVTALRM) );
    }
#endif
#ifdef SIGWINCH
    if (signalName == @symbol(SIGWINCH)) {
	RETURN ( __mkSmallInteger(SIGWINCH) );
    }
#endif
#ifdef SIGXCPU
    if (signalName == @symbol(SIGXCPU)) {
	RETURN ( __mkSmallInteger(SIGXCPU) );
    }
#endif
#ifdef SIGXFSZ
    if (signalName == @symbol(SIGXFSZ)) {
	RETURN ( __mkSmallInteger(SIGXFSZ) );
    }
#endif
#ifdef SIGINFO
    if (signalName == @symbol(SIGINFO)) {
	RETURN ( __mkSmallInteger(SIGINFO) );
    }
#endif
%}.
    ^ 0

    "
     OperatingSystem signalNamed:#SIGABRT
     OperatingSystem signalNamed:#SIGCHLD
     OperatingSystem signalNamed:#SIGXFSZ
     OperatingSystem signalNamed:#SIGSOUND
    "
! !

!UnixOperatingSystem class methodsFor:'TTY support'!

getTTYAttributes: fd

     | iflag oflag cflag lflag cc err |
%{
    if ( __isSmallInteger(fd) ) {
        struct termios attrs;
        if ( tcgetattr( __intVal(fd) , &attrs) == 0 ) {
            iflag = __MKINT(attrs.c_iflag);
            oflag = __MKINT(attrs.c_oflag);
            cflag = __MKINT(attrs.c_cflag);
            lflag = __MKINT(attrs.c_lflag);
            cc    = __BYTEARRAY_NEW_INT(NCCS);
            memcpy(__byteArrayVal(cc), attrs.c_cc, NCCS);
        } else {
            err = __mkSmallInteger(errno);        
        }
    }
%}.
    err notNil ifTrue:[
    	(OperatingSystem errorHolderForNumber:err)
             parameter:'tcgetattr() failed';
             reportError.       
    ].
    ^ TTYAttributes new
        c_iflag: iflag;
        c_oflag: oflag;
        c_cflag: cflag;
        c_lflag: lflag;
        c_cc:    cc;
        yourself.

    "Created: / 27-05-2017 / 20:16:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTTY: fd
    "Return true, if given filedescriptor refers to a terminal. See isatty() 
     for details."

%{
    if (__isSmallInteger(fd)) {
    	if ( isatty( __intVal(fd))  ) {
    	    RETURN(true)
    	} else {
            if ( errno == ENOTTY /* POSIX */ || errno == EINVAL /* Linux */ ) {
            	RETURN(false)
            }    		
    	}
    }
%}.
    self primitiveFailed.

    "Created: / 27-05-2017 / 20:27:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setTTYAttributes: fd to: ttyattrs withActions: actions
     | iflag oflag cflag lflag cc err |

     iflag := ttyattrs c_iflag.
     oflag := ttyattrs c_oflag.
     cflag := ttyattrs c_cflag.
     lflag := ttyattrs c_lflag.
     cc    := ttyattrs c_cc.
%{
    if (   __isSmallInteger(fd) 
    	&& __isSmallInteger(iflag) 
    	&& __isSmallInteger(oflag) 
    	&& __isSmallInteger(cflag) 
    	&& __isSmallInteger(lflag) 
    	&& __isByteArray(cc)
        && __isSmallInteger(actions)  ) {
        struct termios attrs;
        attrs.c_iflag = __intVal(iflag);
        attrs.c_oflag = __intVal(oflag);
        attrs.c_cflag = __intVal(cflag);
        attrs.c_lflag = __intVal(lflag);
        memcpy(attrs.c_cc, __byteArrayVal(cc), NCCS);

        if ( tcsetattr( __intVal(fd) , __intVal(actions), &attrs) == 0 ) {
            RETURN (self);
        } else {
            err = __mkSmallInteger(errno);        
        }
    }   
%}.
    err notNil ifTrue:[
        (OperatingSystem errorHolderForNumber:err)
        	parameter:'tcgetattr() failed';
            reportError.       
    ].
    self primitiveFailed.

 "Created: / 27-05-2017 / 20:27:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"

! !

!UnixOperatingSystem class methodsFor:'directory access'!

closeDirectory:dirPointer
    "low level close of a directoryStream"

%{
#ifdef HAS_OPENDIR
    if (__isExternalAddressLike(dirPointer)) {
	closedir( (DIR *)(__FILEVal(dirPointer)) );
    }
#endif
%}.
    self primitiveFailed
!

nextLinkInfoFrom:aDirectoryStream dirPointer:dirPointer
    "return a FileStatusInfo entry for the next entry, when reading from a directory.
     Under UNIX, the returned fileStatuInfo ONLY contains the name of the file,
     whereas under Windows, it contains the full info (incl. fileSize, access rights etc.).
     The reason is that under windows, the ReadNextEntry system call does this, whereas the
     the corresponding unix read from a readdir only returns the name."

    |entry error|
%{
#ifdef HAS_OPENDIR
    DIR *d;
    DIRENT_STRUCT *dp;

    if ((dirPointer != nil)
     && __isExternalAddressLike(dirPointer)) {
	d = (DIR *)__FILEVal(dirPointer);

	__BEGIN_INTERRUPTABLE__
	do {
	    do {
		__threadErrno = 0;
		dp = readdir(d);
		/*
		 * for compatibility with ST-80,
		 * skip entries for '.' and '..'.
		 * If wanted, these must be added synthetically.
		 */
	    } while (dp && ((strcmp(dp->d_name, ".")==0) || (strcmp(dp->d_name, "..")==0)));
	} while ((dp == NULL) && (__threadErrno == EINTR));
	__END_INTERRUPTABLE__

	if (dp != NULL) {
	    entry = __MKSTRING((char *)(dp->d_name));
	} else {
	    if (__threadErrno) {
		error = __mkSmallInteger(__threadErrno);
	    }
       }
    }
#endif /* HAS_OPENDIR */
%}.
    error notNil ifTrue:[
	^ StreamIOError newException
	    errorCode:error;
	    osErrorHolder:(OperatingSystem errorHolderForNumber:error);
	    parameter:aDirectoryStream;
	    raiseRequest
    ].
    entry notNil ifTrue:[
	^ FileStatusInfo new sourcePath:(self decodePath:entry).
    ].
    ^ aDirectoryStream pastEndRead
! !

!UnixOperatingSystem class methodsFor:'dummy shell operations'!

openApplicationForDocument:aFilenameOrString operation:operationSymbol mimeType:mimeTypeStringArgOrNil ifNone:exceptionBlock
    "open a windows-shell/mac finder/desktop application to present the document contained in aFilenameOrString.
     This is typically used to present help-files, html documents, pdf documents etc.
     operationSymbol is one of:
	open
	edit
	explore
     mimeTypeStringArgOrNil is e.g. 'text/html' or: 'application/pdf';
     if nil is passed in, the file's suffix is used to guess it.
    "

    | cmd |

    cmd := self openApplicationHelperCommand.
    cmd notNil ifTrue:[
	(cmd includesSubString:'%1') ifTrue:[
	    cmd := cmd bindWith:aFilenameOrString asString.
	] ifFalse:[
	    cmd := cmd, ' "', aFilenameOrString asString, '"'.
	].
	(self
	    startProcess:cmd
	    inputFrom:nil outputTo:nil
	    errorTo:nil auxFrom:nil
	    environment: self getEnvironment inDirectory:nil) notNil ifTrue:[ ^ self ]
    ].
    ^ super openApplicationForDocument:aFilenameOrString operation:operationSymbol mimeType:mimeTypeStringArgOrNil ifNone:exceptionBlock


    "
     self openApplicationForDocument: 'https://www.exept.de' operation: #open.
     self openApplicationForDocument: Filename currentDirectory operation:#open
     self openApplicationForDocument: '..\..\doc\books\ArtOfSmalltalk\artMissing186187Fix1.pdf' asFilename operation:#open

     self openApplicationForDocument: 'C:\WINDOWS\Help\clipbrd.chm' asFilename operation:#open
    "

    "Created: / 13-01-2015 / 08:30:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openApplicationHelperCommand
    "Return a command line helper to open a default application for file or URL"

    | xdgCurrentDesktop usersPref |

    ((usersPref := UserPreferences current osFileExplorerCommand) notEmptyOrNil
    and:[ self canExecuteCommand:(usersPref subStrings first) ]) ifTrue:[
	^ usersPref
    ].

    xdgCurrentDesktop := self getEnvironment: 'XDG_CURRENT_DESKTOP'.
    ((xdgCurrentDesktop = 'GNOME') and:[self canExecuteCommand: 'gnome-open']) ifTrue:[
	^ 'gnome-open'
    ].
    "/ Guess...
    ((xdgCurrentDesktop = 'KDE') and:[self canExecuteCommand: 'kde-open']) ifTrue:[
	^ 'kde-open'
    ].
    (self canExecuteCommand: 'xdg-open') ifTrue:[
	^ 'xdg-open'
    ].
    (self canExecuteCommand: 'nautilus') ifTrue:[
	^ 'nautilus'
    ].
    ^ nil

    "
     self openApplicationHelperCommand

     self openApplicationForDocument: 'https://www.exept.de' operation: #open.
     self openApplicationForDocument: Filename currentDirectory operation:#open
    "

    "Created: / 13-01-2015 / 09:02:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openTerminalWithCommand:shellCommand inBackground:inBackground
    "open a new terminal, which executes a command"

    |cmd|

    cmd := 'xterm -e "%1"' bindWith:shellCommand.

    inBackground ifTrue:[
	^ self
	    startProcess:cmd
	    inputFrom:nil
	    outputTo:nil
	    errorTo:nil
	    auxFrom:nil
	    environment:nil
	    inDirectory:nil
    ] ifFalse:[
	^ self executeCommand:cmd
    ].

    "
     OSXOperatingSystem openTerminalWithCommand:'ls -l' inBackground:true
    "
! !

!UnixOperatingSystem class methodsFor:'error messages'!

currentErrorNumber
    "returns the OS's last error nr (i.e. the value of errno).
     Notice, that the value of this flag is only valid immediately
     after the error occurred - it gets updated with every other
     request to the OS.
     Use lastErrorNumber - currentErrorNumber is invalidated by
     many, many internal calls."

%{  /* NOCONTEXT */

     RETURN ( __mkSmallInteger(errno) );
%}.
    ^ 0

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
     * standard across unixes
     */

    if (__isSmallInteger(errNr)) {
	switch ( __intVal(errNr)) {
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
#ifdef EOVERFLOW
	    case EOVERFLOW:
		sym = @symbol(EOVERFLOW);
		typ = @symbol(rangeErrorSignal);
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
#ifdef ENOTSUP
# if !defined(EOPNOTSUPP) || (ENOTSUP != EOPNOTSUPP)
	    case ENOTSUP:
		sym = @symbol(ENOTSUP);
		typ = @symbol(inappropriateOperationSignal);
		break;
# endif
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
#ifdef ECONNREFUSED
	    case ECONNREFUSED:
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
#ifdef EDQUOT
	    case EDQUOT:
		sym = @symbol(EDQUOT);
		typ = @symbol(noResourcesSignal);
		break;
#endif

#ifdef ENOMEDIUM
	    case ENOMEDIUM:
		sym = @symbol(ENOMEDIUM);
		typ = @symbol(noResourcesSignal);
		break;
#endif
#ifdef EMEDIUMTYPE
	    case EMEDIUMTYPE:
		sym = @symbol(EMEDIUMTYPE);
		typ = @symbol(noResourcesSignal);
		break;
#endif

	    default:
		break;
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
    holder errorSymbol:sym errorCategory:(typ ? #defaultOsErrorSignal).
    ^ holder


    "
     OperatingSystem errorHolderForNumber:4
     OperatingSystem errorHolderForNumber:45
     OperatingSystem errorHolderForNumber:#badArgument
     self errorHolderForNumber:(self errorNumberFor:#EPERM)
     self errorHolderForNumber:(self errorNumberFor:#EIO)
     self errorHolderForNumber:(self errorNumberFor:#ENXIO)
     self errorHolderForNumber:(self errorNumberFor:#EOVERFLOW)
    "
!

errorNumberFor:aSymbol
    "given a symbolic error, return the numeric;
     (i.e. errorNumberFor:#EBADF returns EBADF's value).
     Use this, since error numbers are really not standard across unix systems."

%{   /* NOCONTEXT */
    OBJ sym = aSymbol;

    /*
     * POSIX errnos - these should be defined
     */
#ifdef EPERM
    if (sym == @symbol(EPERM)) {
	RETURN ( __mkSmallInteger(EPERM) );
    }
#endif

#ifdef ENOENT
    /* ERROR_FILE_NOT_FOUND is originally windows, but referd to in ExternalStream>>#openError: */
    if (sym == @symbol(ENOENT) || sym == @symbol(ERROR_FILE_NOT_FOUND)) {
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

#ifdef ENOTSUP
# if !defined(EOPNOTSUPP) || (ENOTSUP != EOPNOTSUPP)
    if (sym == @symbol(ENOTSUP)) {
	RETURN ( __mkSmallInteger(ENOTSUP) );
    }
# endif
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

#ifdef EOVERFLOW
    if (sym == @symbol(EOVERFLOW)) {
	RETURN ( __mkSmallInteger(EOVERFLOW) );
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

#ifdef EREMOTEIO
    if (sym == @symbol(EREMOTEIO)) {
	RETURN ( __mkSmallInteger(EREMOTEIO) );
    }
#endif
#ifdef EDQUOT
    if (sym == @symbol(EDQUOT)) {
	RETURN ( __mkSmallInteger(EDQUOT) );
    }
#endif
#ifdef ENOMEDIUM
    if (sym == @symbol(ENOMEDIUM)) {
	RETURN ( __mkSmallInteger(ENOMEDIUM) );
    }
#endif
#ifdef EMEDIUMTYPE
    if (sym == @symbol(EMEDIUMTYPE)) {
	RETURN ( __mkSmallInteger(EMEDIUMTYPE) );
    }
#endif

%}.
    ^ -1

    "
     self errorNumberFor:#EOVERFLOW
     self errorNumberFor:#ENOTSUP
    "
! !

!UnixOperatingSystem class methodsFor:'executing OS commands-implementation'!

exec:aCommandPathArg withArguments:argColl environment:environmentDictionary
    fileDescriptors:fdColl fork:doFork newPgrp:newPgrp inDirectory:aDirectory showWindow:ignoredHere

    "Internal lowLevel entry for combined fork & exec;

     If fork is false (chain a command):
	 execute the OS command specified by the argument, aCommandPath, with
	 arguments in argArray (no arguments, if nil).
	 If successful, this method does not return and smalltalk is gone.
	 If not successful, it does return.
	 Normal use is with forkForCommand.

     If fork is true (subprocess command execution):
	fork a child to do the above.
	The process id of the child process is returned; nil if the fork failed.

     fdColl contains the filedescriptors, to be used for the child (if fork is true).
	fdArray[1] = 15 -> use fd 15 as stdin.
	If an element of the array is set to nil, the corresponding filedescriptor
	will be closed for the child.
	fdArray[1] == StdIn for child
	fdArray[2] == StdOut for child
	fdArray[3] == StdErr for child
	on VMS, these must be channels as returned by createMailBox.
	All filedescriptors not present in fdColl will be closed for the child.

     If newPgrp is true, the subprocess will be established in a new process group.
	The processgroup will be equal to id.
	newPgrp is not used on WIN32 and VMS systems.

     environmentDictionary specifies environment variables which are passed differently from
     the current environment. If non-nil, it must be a dictionary providing
     key-value pairs for changed/added environment variables.
     To pass a variable as empty (i.e. unset), pass a nil value.

     Notice: this used to be two separate ST-methods; however, in order to use
	    vfork on some machines, it had to be merged into one, to avoid write
	    accesses to ST/X memory from the vforked-child.
	    The code below only does read accesses."

    |envArray argArray fdArray dirName cnt aCommandPath|

    environmentDictionary notEmptyOrNil ifTrue:[
	envArray := Array new:environmentDictionary size.
	cnt := 1.
	environmentDictionary keysAndValuesDo:[:key :val |
	    val isNil ifTrue:[
		envArray at:cnt put:((self encodePath:key), '=')
	    ] ifFalse:[
		envArray at:cnt put:((self encodePath:key), '=', (self encodePath:val))
	    ].
	    cnt := cnt + 1.
	].
    ].
    argColl notNil ifTrue:[
	argArray := argColl asArray collect:[:eachArg| self encodePath:eachArg].
    ].
    fdColl notNil ifTrue:[
	fdArray := fdColl asArray
    ].
    aDirectory notNil ifTrue:[
	dirName := aDirectory asFilename osNameForFile.
	dirName := self encodePath:dirName.
    ].
    aCommandPath := self encodePath:aCommandPathArg.

%{  /* STACK: 16000 */
    char **argv;
    int nargs, i, id;
    OBJ arg;
#ifdef __osx__
    char **environ = *_NSGetEnviron();
#else
    extern char **environ;
#endif
    char **_env, **_nEnv;

    if (__isStringLike(aCommandPath) &&
	((argArray == nil) || __isArrayLike(argArray)) &&
	((fdArray == nil) || __isArrayLike(fdArray))
    ) {
	nargs = argArray == nil ? 0 : __arraySize(argArray);
	argv = (char **) malloc(sizeof(char *) * (nargs + 1));
	if (argv) {
	    int nOldEnv, nNewEnv;

	    for (i=0; i < nargs; i++) {
		arg = __ArrayInstPtr(argArray)->a_element[i];
		if (__isStringLike(arg)) {
		    argv[i] = (char *) __stringVal(arg);
		} else {
		    argv[i] = "";
		}
	    }
	    argv[i] = NULL;

	    /*
	     * number of new items in environment ..
	     */
	    nNewEnv = 0;
	    if ((envArray != nil) && __isArrayLike(envArray)) {
		nNewEnv = __arraySize(envArray);
	    }

	    if (nNewEnv == 0) {
		_nEnv = environ;
	    } else {
		_env = environ;
		/*
		 * get size of environment
		 */
		nOldEnv = 0;
		if (_env) {
		    while (*_env) {
			nOldEnv++;
			_env++;
		    }
		}

		/*
		 * generate a new environment
		 * I have not found a spec which defines if
		 * items at the end overwrite previous definitions,
		 * or if the first encountered definition is valid.
		 * To be prepared for any case, simply add the new definitions
		 * at both ends - that should do it in any case.
		 * Someone with more know-how may want to fix this.
		 * getenv() searches for the first entry.
		 * But maybe someone creates a Dictionary from the environment.
		 * In this case the last entry would overwrite previous entries.
		 */
		_nEnv = (char **)malloc(sizeof(char *) * (nNewEnv + nOldEnv + nNewEnv + 1));
		if (_nEnv) {
		    char **eO, **eN;

		    eN = _nEnv;
		    if (nNewEnv) {
			/*
			 * add new items at the front ...
			 */
			int i;
			OBJ *t;

			for (i=0, t = __arrayVal(envArray);
			     i < __arraySize(envArray);
			     i++, t++) {

			    if (__isStringLike(*t)) {
				*eN++ = (char *)__stringVal(*t);
			    }
			}
		    }

		    if (nOldEnv) {
			/*
			 * append old environment
			 */
			for (eO = environ; *eO; *eN++ = *eO++)
			    continue;
		    }

		    if (nNewEnv) {
			/*
			 * append new items again at the end
			 */
			for (eO = _nEnv, i=0; i<nNewEnv; i++) {
			    *eN++ = *eO++;
			}
		    }
		    *eN = NULL;
		}
	    }

	    if (doFork == true) {
		/*
		 * fork a subprocess.
		 */
		int nfd;

		nfd = fdArray == nil ? 0 : __arraySize(fdArray);
		id = FORK ();
		if (id == 0) {
		    /*
		    ** In child.
		    ** first: dup filedescriptors.
		    */
		    for (i = 0; i < nfd; i++) {
			OBJ fd;
			int rslt;

			fd = __arrayVal(fdArray)[i];
			if (__isSmallInteger(fd) && (__intVal(fd) != i)) {
			    do {
				rslt = dup2(__intVal(fd), i);
			    } while ((rslt < 0) && (errno == EINTR));
			}
		    }
		    /*
		    ** Second: close descriptors
		    **         marked as unwanted
		    ** (extra loop to allow duping of low filedescriptor numbers to
		    **  higher fd numbers)
		    */
		    for (i = 0; i < nfd; i++) {
			if (__arrayVal(fdArray)[i] == nil) {
			    close(i);
			}
		    }

		    /*
		    ** third: close all filedescriptors larger
		    ** then the explicitely closed or duped
		    ** filedescriptors
		    */
#ifndef OPEN_MAX
# define OPEN_MAX       256
#endif
		    for ( ;i < OPEN_MAX; i++) {
			close(i);
		    }

		    if (newPgrp == true) {
#ifndef NEXT
			setsid();
#endif
#if defined(TIOCSCTTY)
			ioctl(0, TIOCSCTTY, 0) ;
#endif

#if defined(TIOCSPGRP)
			{
			    int pgrp = getpid();

			    ioctl(0, TIOCSPGRP, (char *)&pgrp);
			}
#endif
#if defined(_POSIX_JOB_CONTROL) || defined(__osx__)
			(void) setpgid(0, 0);
#else
# if defined(BSD) || defined(LINUX) || defined(__osx__)
			(void) setpgrp(0);
# endif
#endif
		    }

		    if (dirName == nil || chdir((char *)__stringVal(dirName)) == 0) {
			execve((char *)__stringVal(aCommandPath), argv, _nEnv);
		    }
		    /* reached if chdir failed or aCommandPathh cannot be executed */
		    _exit(127);                 /* POSIX 2 compatible exit value */
		}
	    } else {
		/*
		 * no subprocess (i.e. transfer to another program)
		 */
		if (dirName == nil || chdir((char *)__stringVal(dirName)) == 0) {
		    execve((char *)__stringVal(aCommandPath), argv, _nEnv);
		}
		/*
		 * reached if chdir failed or command-path cannot be executed
		 */
		id = -1;
	    }

	    if (nNewEnv && (_nEnv != NULL)) {
		/*
		 * free new environment stuff
		 */
		free(_nEnv);
	    }

	    free(argv);

	    /*
	     * In parent: succes or failure
	     */
	    if (id == -1) {
		RETURN (nil);
	    } else {
		RETURN (__mkSmallInteger(id));
	    }
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

    "
     |id|

     id := OperatingSystem fork.
     id == 0 ifTrue:[
	'I am the child'.
	OperatingSystem exec:'/bin/ls' withArguments:#('ls' '/tmp').
	'not reached'.
     ]
    "
    "
     |id|

     id := OperatingSystem fork.
     id == 0 ifTrue:[
	'I am the child'.
	OperatingSystem
	   exec:'/bin/sh'
	   withArguments:#('sh' '-c' 'sleep 2;echo 1;sleep 2;echo 2').
	'not reached'.
     ].
     id printNL.
     (Delay forSeconds:3.5) wait.
     'killing ...' printNL.
     OperatingSystem sendSignal:(OperatingSystem sigTERM) to:id.
     OperatingSystem sendSignal:(OperatingSystem sigKILL) to:id
    "
!

fork
    "fork a new (HEAVY-weight) unix process.
     Not supported with MSDOS & VMS systems.
     Don't confuse this with Block>>fork, which creates
     lightweight smalltalk processes.
     This method will return 0 to the child process,
     and a non-zero number (which is the childs unix-process-id)
     to the parent (original) process.

     In normal situations, you don't need to use this low level entry;
     see #startProcess: and #executeCommand: for higher level interfaces."

%{  /* NOCONTEXT */
    int pid;

    pid = fork();
    RETURN ( __MKUINT(pid) );
%}.
    "/
    "/ not supported by OS
    "/
    ^ UnsupportedOperationSignal raise

    "
     |id t1 t2 t3|

     t1 := Timestamp now.
     id := OperatingSystem fork.
     id == 0 ifTrue:[
	 'Child t=' print. (Timestamp now - t1) printCR.
	 'I am the child process' printCR.
	 OperatingSystem exit
     ].
     'Parent t=' print. (Timestamp now - t1) printCR.
    "
! !

!UnixOperatingSystem class methodsFor:'executing OS commands-queries'!

commandAndArgsForOSCommand:aCommandStringOrArray
    "get a shell and shell arguments for command execution.
     If aCommandStringOrArray is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandStringOrArray is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     The third element is nil - here for windows compatibility (showWindow in windows)"

    aCommandStringOrArray isNonByteCollection ifTrue:[
	"if an array is passed, the command string has already been parsed an no shell is invoked"
	^ Array with:aCommandStringOrArray first with:aCommandStringOrArray with:nil.
    ].

    "/
    "/ '/bin/sh -c <command>'
    "/

    ^ Array with:'/bin/sh' with:(Array with:'sh' with:'-c' with:aCommandStringOrArray) with:nil.

    "Modified: / 20.1.1998 / 16:57:19 / md"
    "Modified: / 5.6.1998 / 17:40:48 / cg"
!

nameOfSTXExecutable
    "return the name of the running ST/X executable program.
     Usually, 'stx' is returned -
     but may be different for standAlone apps (or winstx.exe)."

    |info path|

    "shortcut - use the /proc filesystem (if present).
     Here we get an absolute path to the running executable.
     Notice: we cannot depend on /proc to be present (actually only is on linux)"
    info := '/proc/self/exe' asFilename linkInfo.
    info notNil ifTrue:[
	path := info path.
	path notEmptyOrNil ifTrue:[
	    ^ path
	].
     ].

    "Fall back - do it the hard way"

    ^ super nameOfSTXExecutable

    "
     OperatingSystem nameOfSTXExecutable
    "
!

pathOfCommand:aCommand
    "find where aCommand's executable file would be searched for if executed by a shell.
     Return nil if aCommand is either absolute, or relative and not executable,
     or not executable is found along the PATH."

    |path f fExt commandFilename|

    commandFilename := aCommand asFilename.
    commandFilename isAbsolute ifTrue:[
	"/ something like "/foo/...", tried path is it
	commandFilename isExecutable ifFalse:[^ nil].
	^ commandFilename pathName
    ].
    commandFilename isExplicitRelative ifTrue:[
	"/ something like "../foo/...", tried path resolved relative to the current directory
	commandFilename isExecutable ifFalse:[^ nil].
	 ^ commandFilename pathName
    ].
    (aCommand includes:$/) ifTrue:[
	"/ something like "smalltalk/stx", tried path is relative to the current directory
	(f := ('./',aCommand) asFilename) isExecutable ifTrue:[
	    ^ f pathName
	].
	^ nil
    ].

    "/ command is a single word, not relative and not absolute.
    "/ search along PATH environment variable to see what a shell would do.
    path := self getEnvironment:'PATH'.
    path notEmptyOrNil ifTrue:[
	(path asCollectionOfSubstringsSeparatedBy:self pathSeparator) do:[:eachPathComponent |
	    eachPathComponent isEmpty ifTrue:[
		f := commandFilename
	    ] ifFalse:[
		f := eachPathComponent asFilename construct:aCommand.
	    ].
	    self executableFileExtensions do:[:eachExtension |
		eachExtension notEmpty ifTrue:[
		    fExt := f addSuffix:eachExtension.
		] ifFalse:[
		    fExt := f.
		].
		fExt isExecutable ifTrue:[
		    ^ fExt pathName
		].
	    ].
	].
    ].
    ^ nil

    "unix:

     OperatingSystem pathOfCommand:'fooBar'
     OperatingSystem pathOfCommand:'ls'
     OperatingSystem pathOfCommand:'cvs'
     OperatingSystem pathOfCommand:'stx'
     OperatingSystem pathOfCommand:'./stx'
    "
    "windows:

     OperatingSystem pathOfCommand:'windbg'
    "

    "Modified: / 5.6.1998 / 19:03:32 / cg"
! !

!UnixOperatingSystem class methodsFor:'file access'!

closeFd:anInteger
    "low level close of a filedescriptor"

%{
     if (__isSmallInteger(anInteger)) {
	if (@global(ExternalStream:FileOpenTrace) == true) {
	    fprintf(stderr, "close [UnixOp] fd=%d\n", (int)__intVal(anInteger));
	}
	close(__intVal(anInteger));
	RETURN(self);
     }
%}.
     ^ self primitiveFailed.

    "
     10 to:400 do:[:fd | OperatingSystem closeFd:fd]
    "
!

copyFromFd:inFd toFd:outFd startIndex:startIdx count:count
    "directly copy from one Fd to another (if supported by the OS)"

%{
#if defined(HAS_SENDFILE)
# include <sys/sendfile.h>

     if (__isSmallInteger(inFd)
      && __isSmallInteger(outFd)
      && __isSmallInteger(startIdx)
      && __isSmallInteger(count)) {
	off_t startOffset = __intVal(startIdx);
	ssize_t nWritten;

	nWritten = sendfile(__intVal(outFd), __intVal(inFd), &startOffset, __intVal(count));
	if (nWritten < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	}
	RETURN (__mkSmallInteger(nWritten));
     }
#endif
%}.
    ^ 0 "/ not supported
!

createDirectory:aPathName
    "create a new directory with name 'aPathName', which may be an absolute
     path, or relative to the current directory.
     Return true if successful (or the directory existed already), false if failed.
     This is a low-level entry - use Filename protocol for compatibility."

    ^ self createDirectory:aPathName withAccess:((self getEnvironment:'UMASK') ? 8r0755)

    "
     OperatingSystem createDirectory:'foo'
    "

    "Modified: 20.12.1995 / 11:24:13 / stefan"
    "Modified: 29.6.1996 / 14:06:54 / cg"
!

createDirectory:aPathName withAccess:umask
    "create a new directory with name 'aPathName', which may be an absolute
     path, or relative to the current directory.
     Return nil if successful (or the directory existed already), an OsErrorHolder otherwise.
     This is a low-level entry - use Filename protocol for compatibility."

    |encodedPathName error|

    encodedPathName := self encodePath:aPathName.

%{
    if (__isStringLike(encodedPathName) && __isSmallInteger(umask)) {
	if (mkdir(__stringVal(encodedPathName), __smallIntegerVal(umask)) >= 0) {
	    RETURN(nil);
	}
	error = __mkSmallInteger(errno);
    }
%}.
    "/ could not create - if it already existed this is ok

    (self isDirectory:aPathName) ifTrue:[^ nil].

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    ^ self primitiveFailed


    "
     OperatingSystem createDirectory:'foo'
    "
!

createFileForReadAppend:pathName

    ^ self open:pathName attributes:#(O_RDWR O_CREAT O_APPEND) mode:nil
!

createFileForReadWrite:pathName
    "open a file for reading and writing, return an os specific fileHandle."

    ^ self open:pathName attributes:#(O_RDWR O_CREAT O_TRUNC) mode:nil
!

createFileForWrite:pathName
    "create a file for writing, return an os specific fileHandle."

    ^ self open:pathName attributes:#(O_WRONLY O_CREAT O_TRUNC) mode:nil
!

createHardLinkFrom:oldPath to:newPath
    "link the file 'oldPath' to 'newPath'. The link will be a hard link.
     Return true if successful, false if not."

    |encodedOldPathName encodedNewPathName error|

    encodedOldPathName := self encodePath:oldPath.
    encodedNewPathName := self encodePath:newPath.

%{
    int ret;

    if (__isStringLike(encodedOldPathName) && __isStringLike(encodedNewPathName)) {
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = link((char *) __stringVal(encodedOldPathName), (char *) __stringVal(encodedNewPathName));
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret >= 0) {
	    RETURN (nil);
	}
	error = __mkSmallInteger(errno);
    }
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    "/
    "/ bad argument(s) given
    "/
    ^ self primitiveFailed

    "
     OperatingSystem linkFile:'foo' to:'bar'
    "
!

createSymbolicLinkFrom:oldPath to:newPath
    "make a symbolic link for 'newPath' to the file 'oldPath'.
     The link will be a soft (symbolic) link.
     Answer nil on success and an OSErrorHolder on error."

    |encodedOldPathName encodedNewPathName error|

    encodedOldPathName := self encodePath:oldPath.
    encodedNewPathName := self encodePath:newPath.
%{
#ifdef S_IFLNK
    int ret;

    if (__isStringLike(encodedOldPathName) && __isStringLike(encodedNewPathName)) {
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = symlink((char *) __stringVal(encodedOldPathName), (char *) __stringVal(encodedNewPathName));
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret >= 0) {
	    RETURN (nil);
	}
	error = __mkSmallInteger(errno);
    }
#endif
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    (encodedOldPathName isString not or:[encodedNewPathName isString not]) ifTrue:[
	"/
	"/ bad argument(s) given
	"/
	^ self primitiveFailed
    ].

    "/
    "/ this Unix does not seem to support symbolic links
    "/
    ^ OSErrorHolder unsupportedOperation

    "
     OperatingSystem createSymbolicLinkFrom:'foo' to:'/tmp/bar'
     OperatingSystem createSymbolicLinkFrom:'foo' to:'/bla/bar'
    "
!

open:path attributes:attributes mode:modeInteger
    "open a file, return an os specific fileHandle.
     openmode is a symbol defining the way to open
     valid modes are:
	#O_RDONLY
	#O_RDWR
	#O_WRONLY
	#O_CREAT
	#O_APPEND
	#O_SYNC
	#O_LARGEFILE

     This is a private entry, but maybe useful to open/create a file in a special mode,
     which is proprietrary to the operatingSystem."

    |error fileDescriptor encodedPathName|

    encodedPathName := self encodePath:path.

%{
    OBJ *ap;
    int nAttributes;
    int fd;
    int mode, openFlags = 0;
    int n;

    if (!__isStringLike(encodedPathName)) {
	error = @symbol(badArgument1);
	goto err;
    }
    if (!__isArrayLike(attributes)) {
	error = @symbol(badArgument2);
	goto err;
    }
    if (modeInteger == nil) {
	mode = 0644;
    } else if (__isSmallInteger(modeInteger)) {
	mode = __intVal(modeInteger);
    } else {
	error = @symbol(badArgument3);
	goto err;
    }

    nAttributes = __arraySize(attributes);
    for (n = 0, ap = __arrayVal(attributes); n < nAttributes; n++) {
	OBJ attribute = ap[n];

	if (attribute == @symbol(O_RDONLY)) {
	    openFlags |= O_RDONLY;
	} else if (attribute == @symbol(O_RDWR)) {
	    openFlags |= O_RDWR;
	} else if (attribute == @symbol(O_WRONLY)) {
	    openFlags |= O_WRONLY;
	} else if (attribute == @symbol(O_CREAT)) {
	    openFlags |= O_CREAT;
	} else if (attribute == @symbol(O_APPEND)) {
	    openFlags |= O_APPEND;
	} else if (attribute == @symbol(O_EXCL)) {
	    openFlags |= O_EXCL;
	} else if (attribute == @symbol(O_TRUNC)) {
	    openFlags |= O_TRUNC;
	} else if (attribute == @symbol(O_LARGEFILE)) {
#ifdef O_LARGEFILE
	    openFlags |= O_LARGEFILE;
#else
	    error = @symbol(badArgument2);
	    goto err;
#endif
	} else if (attribute == @symbol(O_SYNC)) {
#ifdef O_SYNC
	    openFlags |= O_SYNC;
#else
	    error = @symbol(badArgument2);
	    goto err;
#endif
	}
    }

#if defined(O_NONBLOCK)
    openFlags |= O_NONBLOCK;
#elif defined(O_NDELAY)
    openFlags |= O_NDELAY;
#endif

again:
    fd = open((char *) __stringVal(encodedPathName), openFlags, mode);
    if (fd < 0) {
	if (errno == EINTR) {
	    __HANDLE_INTERRUPTS__;
	    goto again;
	} else {
	    error = __mkSmallInteger(errno);
	    goto err;
	}
    }
    fileDescriptor = __mkSmallInteger(fd);
err:;
%}.
    ^ fileDescriptor notNil ifTrue:[
	FileDescriptorHandle for:fileDescriptor.
    ] ifFalse:[
	(self errorHolderForNumber:error) reportError
    ].

    "
	self open:'/etc/hosts' attributes:#(O_RDONLY) mode:nil
	self open:'/tmp/xxzz' attributes:#(O_RDWR O_CREAT) mode:8r611
	self open:'/etc/passwd' attributes:#(O_RDWR) mode:nil
	self open:'/no one knows this file' attributes:#(O_RDONLY) mode:nil
	self open:'foo/bar/baz' attributes:#(O_RDWR O_CREAT) mode:nil
    "
!

openFileForAppend:pathName
    "open a file for appending, return an os specific fileHandle."

    ^ self open:pathName attributes:#(O_RDWR O_APPEND) mode:nil
!

openFileForRead:pathName
    "open a file for reading, return an os specific fileHandle."

    ^ self open:pathName attributes:#(O_RDONLY) mode:nil
!

openFileForReadAppend:pathName

    ^ self open:pathName attributes:#(O_RDWR O_APPEND) mode:nil
!

openFileForReadWrite:pathName
    "open a file for reading and writing, return an os specific fileHandle."

    ^ self open:pathName attributes:#(O_RDWR)  mode:nil
!

openFileForWrite:pathName
    "open a file for writing, return an os specific fileHandle."

    ^ self open:pathName attributes:#(O_WRONLY)  mode:nil
!

recursiveCopyDirectory:sourcePathName to:destination
    "copy the directory named 'sourcePathName' and all contained files/directories to 'destination'.
     Return true if successful."

    ^ self executeCommand:(Array with:'/bin/cp' with:'-af' with:sourcePathName with:destination)

    "
	self recursiveCopyDirectory:'packages' to:'foo'.
	self recursiveRemoveDirectory:'foo'.
    "

    "Modified: / 5.6.1998 / 18:33:57 / cg"
!

recursiveRemoveDirectory:fullPathName
    "remove the directory named 'fullPathName' and all contained files/directories.
     Return true if successful."

    ^ self executeCommand:(Array with:'/bin/rm' with:'-rf' with:fullPathName)

    "
     OperatingSystem recursiveCreateDirectory:'foo/bar/baz'
     OperatingSystem recursiveRemoveDirectory:'foo'
    "

    "Modified: / 5.6.1998 / 18:34:03 / cg"
!

removeDirectory:fullPathName
    "remove the directory named 'fullPathName'.
     The directory must be empty and you must have appropriate access rights.
     Return true if successful, false if directory is not empty or no permission.
     This is a lowLevel entry - use Filename protocol for compatibility."

    |encodedPathName error|

    encodedPathName := self encodePath:fullPathName.
%{
    int ret;

    if (__isStringLike(encodedPathName)) {
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = rmdir((char *) __stringVal(encodedPathName));
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__

	if (ret >= 0) {
	    RETURN (nil);
	}
	error = __mkSmallInteger(errno);
    }
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    "/
    "/ either not a string argument
    "/
    ^ self primitiveFailed

    "
     OperatingSystem createDirectory:'foo'
     OperatingSystem removeDirectory:'foo'
    "
!

removeFile:fullPathName
    "remove the file named 'fullPathName'; return true if successful.
     This is a lowLevel entry - use Filename protocol for compatibility."

    |encodedPathName error|

    encodedPathName := self encodePath:fullPathName.
%{
    int ret;

    if (__isStringLike(encodedPathName)) {
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = unlink((char *) __stringVal(encodedPathName));
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__

	if (ret >= 0) {
	    RETURN (nil);
	}
	error = __mkSmallInteger(errno);
    }
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
     directly. Instead, use Filename protocol to rename; this cares for
     any invalid names.
     Returns nil if successful, an OsErrorHolder if not"

    |encodedOldPathName encodedNewPathName error|

    encodedOldPathName := self encodePath:oldPath.
    encodedNewPathName := self encodePath:newPath.
%{
    int ret, eno;

    if (__isStringLike(encodedOldPathName) && __isStringLike(encodedNewPathName)) {
#if defined(HAS_RENAME)
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = rename((char *) __stringVal(encodedOldPathName), (char *) __stringVal(encodedNewPathName));
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
#else
	ret = link((char *) __stringVal(encodedOldPathName), (char *) __stringVal(encodedNewPathName));
	if (ret >= 0) {
	    ret = unlink((char *) __stringVal(encodedOldPathName));
	    if (ret < 0) {
		eno = errno;
		unlink((char *) __stringVal(encodedNewPathName));
		errno = eno;
	    }
	}
#endif
	if (ret >= 0) {
	    RETURN (nil);
	}
	error = __mkSmallInteger(errno);
    }
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    ^ self primitiveFailed

    "
     OperatingSystem renameFile:'foo' to:'bar'
    "
!

sync
    "sync all the filesystems"

%{
    sync();
%}.
    ^ nil
!

syncFileSystem:handle
    <resource: #glibc (#'2.14')>
    "sync the filesystem where the file represented by handle resides"

%{
// macosx does not support syncfs
// ... and we need to be compatible with GLIBC 2.12 (RedHat 6)
// so disable it for now.
#if 0
# if defined(LINUX)
#  if __GLIBC_PREREQ(2, 14)
    if (__isSmallInteger(handle)) {
	if (syncfs(__intVal(handle)) == 0) {
	    RETURN(self);
	}
    }
#  endif
# endif
#endif
%}.

    "fallback is to do a global sync"
    self sync.

    "
     '/etc/passwd' asFilename readStream syncFileSystem
    "
!

truncateFile:aPathName to:newSize
    "change a files size return nil on success, an OSErrorHolder on failure.
     This may not be supported on all architectures.

     This is a low-level entry - use Filename protocol."

    |encodedPathName error|

    encodedPathName := self encodePath:aPathName.

%{
#if defined(HAS_TRUNCATE) || defined(HAS_FTRUNCATE)
    int ret;
    off_t truncateSize;

    if (!__isStringLike(encodedPathName))
	goto getOutOfHere;

    if (__isSmallInteger(newSize)) {
	truncateSize = __intVal(newSize);
	if (truncateSize < 0) {
	    goto getOutOfHere;
	}
    } else {
	truncateSize = __signedLongIntVal(newSize);
	if (truncateSize < 0) {
	    goto getOutOfHere;
	}
	if (truncateSize == 0) {
	    if (sizeof(truncateSize) == 8) {
		if (__signedLong64IntVal(newSize, &truncateSize) == 0 || truncateSize < 0) {
		    goto getOutOfHere;
		}
	    } else {
		goto getOutOfHere;
	    }
	}
    }

#if defined(HAS_TRUNCATE)
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = truncate((char *) __stringVal(encodedPathName), truncateSize);
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__

#elif defined(HAS_FTRUNCATE)
    {
	int fd;

	do {
	    fd = ret = open((char *) __stringVal(encodedPathName), 2);
	} while (fd < 0 && errno == EINTR);
	if (fd >= 0) {
	    ret = ftruncate(fd, truncateSize);
	    close(fd);
	}
    }
#endif /* HAS_FTRUNCATE */
	if (ret >= 0) {
	    RETURN (nil);
	}
	error = __mkSmallInteger(errno);

getOutOfHere:;
#else
	error = __mkSmallInteger(ENOTSUP);
#endif
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    ^ self primitiveFailed

    "
	self truncateFile:'foo' to:2222222
    "
! !

!UnixOperatingSystem class methodsFor:'file access rights'!

accessMaskFor:aSymbol
    "return the access bits mask for numbers as returned by
     OperatingSystem>>accessModeOf:
     and expected by OperatingSystem>>changeAccessModeOf:to:.
     Since these numbers are OS dependent, always use the mask
     (never hardcode 8rxxx into your code)."

%{  /* NOCONTEXT */
#   ifndef S_IRUSR
    /* posix systems should define these ... */
#    define S_IRUSR 0400
#    define S_IWUSR 0200
#    define S_IXUSR 0100
#    define S_IRGRP 0040
#    define S_IWGRP 0020
#    define S_IXGRP 0010
#    define S_IROTH 0004
#    define S_IWOTH 0002
#    define S_IXOTH 0001
#    define S_ISUID 04000
#    define S_ISGID 02000
#    define S_ISVTX 01000
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
    if (aSymbol == @symbol(setUid)) {
	RETURN ( __mkSmallInteger(S_ISUID) );
    }
    if (aSymbol == @symbol(setGid)) {
	RETURN ( __mkSmallInteger(S_ISGID) );
    }
    if (aSymbol == @symbol(removeOnlyByOwner)) {
	RETURN ( __mkSmallInteger(S_ISVTX) );
    }
%}.
    ^ self primitiveFailed

    "
     OperatingSystem accessMaskFor:#readUser
     OperatingSystem accessMaskFor:#removeOnlyByOwner
    "
!

accessModeOf:aPathName
    "return a number representing access rights rwxrwxrwx for owner,
     group and others. Return an OSErrorHolder if such a file does not exist.
     Notice that the returned number is OS dependent - use the
     modeMasks as returned by OperatingSystem>>accessMaskFor:"

    "
     this could have been implemented as:
	(self infoOf:aPathName) at:#mode
     but for huge directory searches the code below is faster
    "

    |encodedPathName error|

    encodedPathName := self encodePath:aPathName.
%{
    struct stat buf;
    int ret;

    if (__isStringLike(encodedPathName)) {
#ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for accessMode\n", __stringVal(encodedPathName));
#endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(encodedPathName), &buf);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__

	if (ret >= 0) {
	    RETURN ( __mkSmallInteger(buf.st_mode & 0777) );
	}
	error = __mkSmallInteger(errno);
    }
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

   ^ self primitiveFailed

   "
    (OperatingSystem accessModeOf:'/') printStringRadix:8
   "
!

accessModeOfFd:aFileDescriptor
    "return a number representing access rights rwxrwxrwx for owner,
     group and others. Return nil if such a file does not exist.
     Notice that the returned number is OS dependent - use the
     modeMasks as returned by OperatingSystem>>accessMaskFor:"

    |error|

%{
    struct stat buf;
    int ret;

    if (__isSmallInteger(aFileDescriptor)) {
# ifdef TRACE_STAT_CALLS
	printf("fstat on '%d' for accessMode\n", __smallIntegerVal(aFileDescriptor));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = fstat(__smallIntegerVal(aFileDescriptor), &buf);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__

	if (ret >= 0) {
	    RETURN ( __mkSmallInteger(buf.st_mode & 0777) );
	}
	error = __mkSmallInteger(errno);
    }
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    ^ self primitiveFailed

   "
    '/' asFilename readingFileDo:[:s|
	(OperatingSystem accessModeOfFd:s fileDescriptor) printStringRadix:8
    ].
   "
!

changeAccessModeOf:aPathName to:modeBits
    "change the access rights of aPathName to the OS dependent modeBits.
     You should construct this mask using accessMaskFor, to be OS
     independent. Return nil if changed,
     anOSErrorHolder if such a file does not exist or change was not allowd."

    |encodedPathName error|

    encodedPathName := self encodePath:aPathName.
%{
    int ret;

    if (__isStringLike(encodedPathName) && __isSmallInteger(modeBits)) {
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = chmod((char *)__stringVal(encodedPathName), __intVal(modeBits));
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__

	if (ret >= 0) {
	    RETURN (nil);
	}
	error = __mkSmallInteger(errno);
    }
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    ^ self primitiveFailed

    "
	self changeAccessModeOf:'foo' to:8r666
    "
!

changeAccessModeOfFd:aFileDescriptor to:modeBits
    "change the access rights of the file referenced by aFileDescriptor
     to the OS dependent modeBits.
     You should construct this mask using accessMaskFor, to be OS
     independent. Return nil if changed,
     an OSErrorHolder if such a file does not exist or change was not allowed."

    |error|

%{
    int ret;

    if (__isSmallInteger(aFileDescriptor) && __isSmallInteger(modeBits)) {
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = fchmod(__smallIntegerVal(aFileDescriptor), __intVal(modeBits));
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__

	if (ret >= 0) {
	    RETURN (nil);
	}
	error = __mkSmallInteger(errno);
    }
%}.

    error notNil ifTrue:[
	LastErrorNumber := error.
	^ self errorHolderForNumber:error.
    ].

    ^ self primitiveFailed
! !

!UnixOperatingSystem class methodsFor:'file locking'!

lockFD:aFileDescriptor shared:isSharedReadLock blocking:blockIfLocked
   "set a lock on the file represented by aFileDescriptor.
    (such as returned by ExternalStream>>fileDescriptor).
    On some systems, only advisory locks are available -
    these depends on other accessors to also perform the locking operation.
    If they do not, they may still access the file
    (on some systems, locks are mandatory, on others, they are advisory).
    The isSharedReadLock argument (if true) specifies if multiple readers
    are to be allowed - if false, they are not.
    On some systems, all locks are non-exclusive locks.

    Returns true, if the lock was acquired, false otherwise.

    Notice, that not all OS's support these locks;
    on some, this may simply be a no-op.
    Also notice, that some systems block the process, to wait for the lock.
    This can (again: on some systems) be avoided by passing a false blockIfLocked
    argument."

%{
    if (__isSmallInteger(aFileDescriptor)) {
	int fd = __intVal(aFileDescriptor);
	int lockArg;

	/*
	 * claus: sigh - each one has a different interface ...
	 */
#if defined(F_SETLK)
	{
	    /*
	     * new fcntl(SETLK) interface;
	     * available on SYSV4 and Linux
	     */
	    struct flock flock;

	    if (isSharedReadLock == true) {
		flock.l_type = F_RDLCK;
	    } else {
		flock.l_type = F_WRLCK;
	    }
	    flock.l_whence = 0;
	    flock.l_start = 0;
	    flock.l_len = 0;
	    lockArg = F_SETLK;
# if defined(F_SETLKW)
	    if (blockIfLocked == true) {
		lockArg = F_SETLKW;
	    }
# endif
	    if (fcntl(fd, lockArg, &flock) != -1) {
		RETURN (true);
	    }
	}

#else /* no F_SETLK available */

# if defined(LOCK_EX) && defined(LOCK_UN)
	/*
	 * BSD 4.3 advisory locks
	 */
	lockArg = LOCK_EX;
#  if defined(LOCK_SH)
	if (isSharedReadLock == true) {
	    lockArg = LOCK_SH
	}
#  endif
#  if defined(LOCK_NB)
	if (blockIfLocked == false) {
	    lockArg |= LOCK_NB;
	}
#  endif
	if (flock(fd, lockArg) != -1) {
	    RETURN (true);
	}

# else /* no flock available */

#  if defined(F_LOCK) && defined(F_UNLOCK)
	/*
	 * SYSV3 advisory locks
	 */
	if (lockf(fd, F_LOCK, 0) != -1) {
	    RETURN (true);
	}
#  endif
# endif
#endif
    }
%}.
    ^ false
!

supportsFileLocks
    "return true, if the OS supports file locking"

%{ /* NOCONTEXT */
#if defined(F_SETLK) || (defined(LOCK_EX) && defined(LOCK_UN)) || defined(F_LOCK) && defined(F_UNLOCK)
    RETURN (true);
#endif
%}.
    ^ false

    "
     OperatingSystem supportsFileLocks
    "
!

supportsNonBlockingFileLocks
    "return true, if the OS supports nonBlocking file locking
     (i.e. with immediate return instead of waiting for the lock)"

%{ /* NOCONTEXT */
#if (defined(F_SETLK) && defined(F_SETLKW)) || (defined(LOCK_EX) && defined(LOCK_UN) && defined(LOCK_NB))
    RETURN (true);
#endif
%}.
    ^ false

    "
     OperatingSystem supportsNonBlockingFileLocks
    "
!

supportsSharedLocks
    "return true, if the OS supports shared (i.e. multiple reader)
     file locking."

%{ /* NOCONTEXT */
#if defined(F_SETLK) && defined(F_RDLCK) && defined(F_WRLCK)
    RETURN (true);
#else
# if defined(LOCK_EX) && defined(LOCK_SH) && defined(LOCK_UN)
    RETURN (true);
# endif
#endif
%}.
    ^ false

    "
     OperatingSystem supportsNonBlockingFileLocks
    "
!

unlockFD:aFileDescriptor
    "clear a file lock on the file represented by aFileDescriptor,
     which was previously acquired by #lockFD:.
     Return false, if the unlock failed
     (which may happens when a wrong fd is passed,
      no lock was set previously, or the systsem does not support locks).
     Notice, that not all OS's support file locks;
     on some, this may simply be a no-op."

%{
    if (__isSmallInteger(aFileDescriptor)) {
	int fd = __intVal(aFileDescriptor);

	/*
	 * claus: sigh - each one has a different interface ...
	 */
#if defined(F_SETLK)
	{
	    /*
	     * new fcntl(SETLK) interface;
	     * available on SYSV4 and Linux
	     */
	    struct flock flock;

	    flock.l_type = F_UNLCK;
	    flock.l_whence = 0;
	    flock.l_start = 0;
	    flock.l_len = 0;
	    if (fcntl(fd, F_SETLK, &flock) != -1) {
		RETURN (true);
	    }
	}

#else /* no F_SETLK available */

# if defined(LOCK_EX) && defined(LOCK_UN)
	/*
	 * BSD 4.3 advisory locks
	 */
	if (flock(fd, LOCK_UN) != -1) {
	    RETURN (true);
	}

# else /* no flock available */

#  if defined(F_LOCK) && defined(F_UNLOCK)
	/*
	 * SYSV3 advisory locks
	 */
	if (lockf(fd, F_UNLOCK, 0) != -1) {
	    RETURN (true);
	}
#  endif
# endif
#endif
    }
%}.
    ^ false
! !

!UnixOperatingSystem class methodsFor:'file queries'!

caseSensitiveFilenames
    "return true, if the OS has caseSensitive file naming.
     On MSDOS, this will return false;
     on a real OS, we return true.
     Be aware, that some OSs can be configured to be either.
     Also, that it actually depends on the mounted volume"

    "/ actually, this is wrong and may depend on the mounted volume;
    "/ so we need a query for a particular directory (and/or volume).
    ^ true

    "Modified: / 5.6.1998 / 18:35:18 / cg"
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
     OperatingSystem compressPath:'./..'
     OperatingSystem compressPath:'/foo/bar/baz/..'
     OperatingSystem compressPath:'foo/bar/baz/..'
     OperatingSystem compressPath:'foo/bar/baz/../'
     OperatingSystem compressPath:'foo/bar/baz/..///'
     OperatingSystem compressPath:'///foo/bar/baz/..///'
    "

    "Modified: 1.11.1996 / 20:13:48 / cg"
!

fileSeparator
    "return the character used to separate names in a path.
     This character differs for MSDOS and other systems,
     (but those are currently not supported - so this is some
      preparation for the future)"

    ^ $/

    "Modified: / 5.6.1998 / 18:35:24 / cg"
!

getCurrentDirectory
    "return the name of the current directory"

    |ret path|

    ret := self primGetCurrentDirectory.
    ret isNil ifTrue:[
	self primitiveFailed
    ].
    path := self decodePath:ret.    "/ possibly decode from UTF8 (depending on the OS)
    CurrentDirectory := path.

    ^ path.

    "
	self getCurrentDirectory
    "
!

getDiskInfoOf:aDirectoryPath
    "return some disk info.
     The amountof information returned depends upon the OS, and is
     not guaranteed to be consistent across architectures.
     On unix, the information returned is (at least):
	freeBytes
	totalBytes
    "

    |outputText keys values n info
     fileSystemIdx sizeIdx usedIdx availIdx capacityIdx mountIdx|

    outputText := PipeStream outputFromCommand:('df -k ' , aDirectoryPath).
    outputText isNil ifTrue:[^ nil].

    outputText := outputText asCollectionOfLines.
    outputText size < 2 ifTrue:[^ nil].

    keys := (outputText at:1) asLowercase asCollectionOfWords.
    values := (outputText at:2) asCollectionOfWords.

    "/ we may have to validate the following column indices
    "/ on some rude Unix versions ...

    fileSystemIdx := 1.
    sizeIdx := 2.
    usedIdx := 3.
    availIdx := 4.
    capacityIdx := 5.
    mountIdx := 6.

    values size < 6 ifTrue:[^ nil].

    info := IdentityDictionary new.

    n := Integer readFrom:(values at:capacityIdx) onError:nil.
    n notNil ifTrue:[
	info at:#percentUsed put:n
    ].

    n := Integer readFrom:(values at:availIdx) onError:nil.
    n notNil ifTrue:[
	info at:#freeBytes put:(n * 1024)
    ].

    n := Integer readFrom:(values at:usedIdx) onError:nil.
    n notNil ifTrue:[
	info at:#usedBytes put:(n * 1024)
    ].

    n := Integer readFrom:(values at:sizeIdx) onError:nil.
    n notNil ifTrue:[
	info at:#totalBytes put:(n * 1024)
    ].

    info at:#mountPoint put:(values at:mountIdx).
    info at:#fileSystem put:(values at:fileSystemIdx).

    ^ info

    "
     OperatingSystem getDiskInfoOf:'/'
     OperatingSystem getDiskInfoOf:'.'
    "

    "Modified: / 22.5.1999 / 00:32:13 / cg"
!

getDriveList
    "return a list of volumes in the system.
     On unix, no such thing like a volume exists
     - there, a synthetic list with root, home & current is returned.
     On MSDOS, a list of drive letters is returned.
     On VMS, a list of volumes is returned."

    "/
    "/ default: return array filled with
    "/ root, home and current directories.
    "/
    ^ Array
	with:'/'
	with:(self getHomeDirectory)
	with:(Filename currentDirectory pathName)

    "Modified: / 5.6.1998 / 18:35:35 / cg"
!

getMountedVolumes
    "return info about mounted volumes.
     The amount of information returned depends upon the OS, and is
     not guaranteed to be consistent across architectures.
     On unix, the information returned is (at least):
	mountPoint - mount point
	fileSystem - device or NFS-remotePath
    "

    |outputText keys values info infoEntry|

    outputText := PipeStream outputFromCommand:('df -k').
    outputText isNil ifTrue:[^ nil].

    outputText := outputText asCollectionOfLines.
    outputText size < 2 ifTrue:[^ nil].

    keys := (outputText at:1) asLowercase asCollectionOfWords.
    "/ we may have to validate the following column indices
    "/ on some rude Unix versions ...

    info := OrderedCollection new.

    outputText from:2 do:[:line |
	values := line asCollectionOfWords.

	values size >= 2 ifTrue:[

	    infoEntry := IdentityDictionary new.
	    infoEntry at:#mountPoint put:(values last).
	    infoEntry at:#fileSystem put:(values first).
	    info add:infoEntry.
	]
    ].
    ^ info

    "
     OperatingSystem getMountedVolumes
    "

    "Modified: / 22.5.1999 / 00:32:13 / cg"
!

getNullDevice
    "return the name of the OS's null device"

    ^ '/dev/null'
!

getObjectFileInfoFor:aStringOrFilename
    "Return an info object for a given executable or shared object
     or throw an error if given file is not a valid an executable now
     shared object.

     The info object returned is OS-specific, however it responds to at
     least
	#isFor32BitArchitecture
	#isFor64BitArchitecture ... returns true, if the given object is for
				     32bit, 64bit architecture respectively
    "
    ^ ELFFileHeader fromFile: aStringOrFilename

    "Created: / 17-03-2015 / 20:52:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
	 alternativeName     - (windows only:) the MSDOS name of the file
	 recordFormatNumeric - (VMS only:) numeric value of the recordFormat
	 recordFormat        - (VMS only:) symbolic value of the recordFormat
	 recordAttributes    - (VMS only:) recordAttributes
	 fixedHeaderSize     - (VMS only:) fixed header size in a variable record format
	 recordSize          - (VMS only:) record size.

     Some of the fields may be returned as nil on systems which do not provide
     all of the information.
     Return nil if such a file does not exist.
     For symbolic links (if supported by the OS),
     the info of the pointed-to-file (i.e. the target) is returned;
     use #linkInfoOf: to get info about the link itself.
    "

    |type mode uid gid size id nLink aOStime mOStime cOStime error encodedPathName|

    encodedPathName := self encodePath:aPathName.
%{
    struct stat buf;
    int ret;

    if (!__isStringLike(encodedPathName)) {
	error = @symbol(badArgument);
	goto out;
    }

# ifdef TRACE_STAT_CALLS
    printf("stat on '%s' for info\n", __stringVal(aPathName));
# endif
    __BEGIN_INTERRUPTABLE__
    do {
	ret = stat((char *) __stringVal(encodedPathName), &buf);
    } while ((ret < 0) && (errno == EINTR));
    __END_INTERRUPTABLE__

    if (ret < 0) {
	error = __mkSmallInteger(errno);
	@global(LastErrorNumber) = error;
	goto out;
    }
    switch (buf.st_mode & S_IFMT) {
	case S_IFDIR:
	    type = @symbol(directory);
	    break;

	case S_IFREG:
	    type = @symbol(regular);
	    break;
# ifdef S_IFCHR
	case S_IFCHR:
	    type = @symbol(characterSpecial);
	    break;
# endif
# ifdef S_IFBLK
	case S_IFBLK:
	    type = @symbol(blockSpecial);
	    break;
# endif
# ifdef S_IFMPC
	case S_IFMPC:
	    type = @symbol(multiplexedCharacterSpecial);
	    break;
# endif
# ifdef S_IFMPB
	case S_IFMPB:
	    type = @symbol(multiplexedBlockSpecial);
	    break;
# endif
# ifdef S_IFLNK
	case S_IFLNK:
	    type = @symbol(symbolicLink);
	    break;
# endif
# ifdef S_IFSOCK
	case S_IFSOCK:
	    type = @symbol(socket);
	    break;
# endif
# ifdef S_IFIFO
	case S_IFIFO:
	    type = @symbol(fifo);
	    break;
# endif
	default:
	    type = @symbol(unknown);
	    break;
    }

    if (sizeof(buf.st_ino) == 8) {
	id = __MKUINT64(&buf.st_ino);
    } else {
	id = __MKUINT(buf.st_ino);
    }
    mode = __mkSmallInteger(buf.st_mode & 0777);
    uid = __mkSmallInteger(buf.st_uid);
    gid = __mkSmallInteger(buf.st_gid);
    nLink = __mkSmallInteger(buf.st_nlink);
    if (sizeof(buf.st_size) == 8) {
	size = __MKINT64(&buf.st_size);
    } else {
	size = __MKINT(buf.st_size);
    }
    aOStime = __MKUINT(buf.st_atime);
    mOStime = __MKUINT(buf.st_mtime);
    cOStime = __MKUINT(buf.st_ctime);

    out:;
%}.
     mode notNil ifTrue:[
	"/ now done lazy in FileStatusInfo
	"/ atime := Timestamp fromOSTime:(aOStime * 1000).
	"/ mtime := Timestamp fromOSTime:(mOStime * 1000).
	"/ ctime := Timestamp fromOSTime:(cOStime * 1000).

	^ FileStatusInfo
		    type:type
		    mode:mode
		    uid:uid
		    gid:gid
		    size:size
		    id:id
		    accessed:aOStime
		    modified:mOStime
		    statusChanged:cOStime
		    sourcePath:nil targetPath:nil
		    numLinks:nLink.
    ].
    error notNil ifTrue:[
	^ nil.
    ].

    ^ self primitiveFailed

   "
    OperatingSystem infoOf:'/ccccccc'
    (OperatingSystem infoOf:'/') uid
    (OperatingSystem infoOf:'/') accessTime
   "
!

isDirectory:aPathName
    "return true, if 'aPathName' is a valid directory path name.
     (i.e. exists and is a directory).
     This also returns true for symbolic links pointing to a directory;
     if you need to check for this, use #linkInfo:."

    |encodedPathName|

    encodedPathName := self encodePath:aPathName.

%{
#ifdef __SCHTEAM__
    if (encodedPathName.isStringLike()) {
	java.io.File file = new java.io.File( encodedPathName.asString() );
	int _mode;

	if (file.exists() && file.isDirectory()) {
	    return __c__._RETURN_true();
	}
	return __c__._RETURN_false();
    }
#else
    int ret;

    if (__isStringLike(encodedPathName)) {
	struct stat buf;

# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for isDirectory\n", __stringVal(encodedPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(encodedPathName), &buf);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( false );
	}
	RETURN ( ((buf.st_mode & S_IFMT) == S_IFDIR) ? true : false);
    }
#endif /* not SCHTEAM */
%}.
    ^ self primitiveFailed

    "an alternative implementation would be:
	^ (self infoOf:aPathName) type == #directory
    "
!

isExecutable:aPathName
    "return true, if the given file is executable.
     For symbolic links, the pointed-to-file is checked."

    |encodedPathName|

    encodedPathName := self encodePath:aPathName.

%{
#ifdef __SCHTEAM__
    if (encodedPathName.isStringLike()) {
	java.io.File file = new java.io.File( encodedPathName.asString() );
	int _mode;

	if (file.exists() && file.canExecute()) {
	    return __c__._RETURN_true();
	}
	return __c__._RETURN_false();
    }
#else
    int ret;

    if (__isStringLike(encodedPathName)) {
# ifdef TRACE_ACCESS_CALLS
	printf("access on '%s' for executable\n", __stringVal(encodedPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = access(__stringVal(encodedPathName), X_OK);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	}
	RETURN ( ((ret == 0) ? true : false) );
    }
#endif /* not SCHTEAM */
%}.
    ^ self primitiveFailed
!

isReadable:aPathName
    "return true, if the file/dir 'aPathName' is readable.
     For symbolic links, the pointed-to-file is checked."

    |encodedPathName|

    encodedPathName := self encodePath:aPathName.
%{
#ifdef __SCHTEAM__
    if (encodedPathName.isStringLike()) {
	java.io.File file = new java.io.File( encodedPathName.asString() );
	int _mode;

	if (file.exists() && file.canRead()) {
	    return __c__._RETURN_true();
	}
	return __c__._RETURN_false();
    }
#else
    int ret;

    if (__isStringLike(encodedPathName)) {
# ifdef TRACE_ACCESS_CALLS
	printf("access on '%s' for readable\n", __stringVal(encodedPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = access(__stringVal(encodedPathName), R_OK);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	}
	RETURN ( ((ret == 0) ? true : false) );
    }
#endif /* not SCHTEAM */
%}.
    ^ self primitiveFailed
!

isValidPath:aPathName
    "return true, if 'aPathName' is a valid path name
     (i.e. the file or directory exists)"

    |encodedPathName|

    encodedPathName := self encodePath:aPathName.
%{
#ifdef __SCHTEAM__
    if (encodedPathName.isStringLike()) {
	java.io.File file = new java.io.File( encodedPathName.asString() );
	int _mode;

	if (file.exists()) {
	    return __c__._RETURN_true();
	}
	return __c__._RETURN_false();
    }
#else
    if (__isStringLike(encodedPathName)) {
	struct stat buf;
	int ret;

# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for isValidPath\n", __stringVal(encodedPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(encodedPathName), &buf);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN (false);
	}
	RETURN ( ret ? false : true );
    }
#endif /* not SCHTEAM */
%}.
    ^ self primitiveFailed

"/ alternative:
"/        ^ (self infoOf:aPathName) notNil
!

isWritable:aPathName
    "return true, if the given file is writable.
     For symbolic links, the pointed-to-file is checked."

    |encodedPathName|

    encodedPathName := self encodePath:aPathName.
%{
#ifdef __SCHTEAM__
    if (encodedPathName.isStringLike()) {
	java.io.File file = new java.io.File( encodedPathName.asString() );
	int _mode;

	if (file.exists() && file.canWrite()) {
	    return __c__._RETURN_true();
	}
	return __c__._RETURN_false();
    }
#else
    int ret;

    if (__isStringLike(encodedPathName)) {
# ifdef TRACE_ACCESS_CALLS
	printf("access on '%s' for writable\n", __stringVal(encodedPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = access(__stringVal(encodedPathName), W_OK);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	}
	RETURN ( ((ret == 0) ? true : false) );
    }
#endif /* not SCHTEAM */
%}.
    ^ self primitiveFailed
!

linkInfoOf:aPathName
    "return some object filled with info for the file 'aPathName'.

     The info (for which corresponding access methods are understood by
     the returned object) is:
	 type            - a symbol giving the file's type
	 mode            - numeric access mode
	 uid             - owners user id
	 gid             - owners group id
	 size            - files size
	 id              - files number (i.e. inode number)
	 accessed        - last access time (as Timestamp)
	 modified        - last modification time (as Timestamp)
	 statusChanged   - last status change time (as Timestamp)
	 alternativeName     - (windows only:) the MSDOS name of the file
	 recordFormatNumeric - (VMS only:) numeric value of the recordFormat
	 recordFormat        - (VMS only:) symbolic value of the recordFormat
	 recordAttributes    - (VMS only:) recordAttributes
	 fixedHeaderSize     - (VMS only:) fixed header size in a variable record format
	 recordSize          - (VMS only:) record size.

     Some of the fields may be returned as nil on systems which do not provide
     all of the information.

     If aPathName is invalid, nil is returned.
     If aPathName is NOT a symbolic link, the #infoOf: aPathname itself is returned.
     (which means, that systems like VMS or MSDOS always return the info here.)

     Return the info about the link itself,
     on contrast to #infoOf:, which returns the info of the pointed to file
     in case of a symbolic link."

    |type mode uid gid size id nLink aOStime mOStime cOStime path encodedPathName|

    encodedPathName := self encodePath:aPathName.

%{  /* STACK: 1200 */
#ifdef __SCHTEAM__
    if (encodedPathName.isStringLike()) {
	java.io.File file = new java.io.File( encodedPathName.asString() );
	int _mode;

	if (file.isDirectory()) {
	    type = STSymbol._new("directory");
	} else if (file.isFile()) {
	    type = STSymbol._new("regular");
	} else {
	    type = STSymbol._new("unknown");
	}
	_mode = 0;
	if (file.canRead()) {
	    _mode |= 0444;
	}
	if (file.canWrite()) {
	    _mode |= 0222;
	}
	if (file.canExecute()) {
	    _mode |= 0111;
	}
	mode = STInteger._new( _mode );
	uid = STInteger._0;
	gid = STInteger._0;
	nLink = STInteger._0;
	size = STInteger._new( file.length());
	aOStime = STInteger._new( file.lastModified() );
	mOStime = STInteger._new( file.lastModified() );
	cOStime = STInteger._new( file.lastModified() );
	path = new STString( file.getPath() );
    }
#else
    struct stat buf;
    int ret;
    char pathBuffer[1024];

    if (__isStringLike(encodedPathName)) {
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = lstat((char *) __stringVal(encodedPathName), &buf);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__

	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( nil );
	}
	switch (buf.st_mode & S_IFMT) {
# ifdef S_IFLNK
	    case S_IFLNK:
		type = @symbol(symbolicLink);
		if ((ret = readlink((char *) __stringVal(encodedPathName), pathBuffer, sizeof(pathBuffer))) < 0) {
		    @global(LastErrorNumber) = __mkSmallInteger(errno);
		    RETURN ( nil );
		}
		pathBuffer[ret] = '\0';  /* readlink does not 0-terminate */
		path = __MKSTRING(pathBuffer);
		break;
# endif
	    case S_IFDIR:
		type = @symbol(directory);
		break;

	    case S_IFREG:
		type = @symbol(regular);
		break;
# ifdef S_IFCHR
	    case S_IFCHR:
		type = @symbol(characterSpecial);
		break;
# endif
# ifdef S_IFBLK
	    case S_IFBLK:
		type = @symbol(blockSpecial);
		break;
# endif
# ifdef S_IFMPC
	    case S_IFMPC:
		type = @symbol(multiplexedCharacterSpecial);
		break;
# endif
# ifdef S_IFMPB
	    case S_IFMPB:
		type = @symbol(multiplexedBlockSpecial);
		break;
# endif
# ifdef S_IFSOCK
	    case S_IFSOCK:
		type = @symbol(socket);
		break;
# endif
# ifdef S_IFIFO
	    case S_IFIFO:
		type = @symbol(fifo);
		break;
# endif
	    default:
		type = @symbol(unknown);
		break;
	}

	if (sizeof(buf.st_ino) == 8) {
	    id = __MKUINT64(&buf.st_ino);
	} else {
	    id = __MKUINT(buf.st_ino);
	}
	mode = __mkSmallInteger(buf.st_mode & 0777);
	uid = __mkSmallInteger(buf.st_uid);
	gid = __mkSmallInteger(buf.st_gid);
	nLink = __mkSmallInteger(buf.st_nlink);
	if (sizeof(buf.st_size) == 8) {
	    size = __MKINT64(&buf.st_size);
	} else {
	    size = __MKINT(buf.st_size);
	}
	aOStime = __MKUINT(buf.st_atime);
	mOStime = __MKUINT(buf.st_mtime);
	cOStime = __MKUINT(buf.st_ctime);
    }
#endif /* not SCHTEAM */
%}.

    mode notNil ifTrue:[
	^ FileStatusInfo
	    type:type
	    mode:mode
	    uid:uid
	    gid:gid
	    size:size
	    id:id
	    accessed:aOStime
	    modified:mOStime
	    statusChanged:cOStime
	    sourcePath:aPathName targetPath:(self decodePath:path)
	    numLinks:nLink.
   ].
   ^ self primitiveFailed

   "
    OperatingSystem infoOf:'Make.proto'
    OperatingSystem linkInfoOf:'Make.proto'
    OperatingSystem linkInfoOf:'/usr/tmp'
   "
!

mountPoints
    "return a collection of mountPoints (aka. topDirectories of mounted file systems).
     As this might be expensive on some systems,
     the info is cached for some time (5 minutes)"

    CacheMountPointsTimeStamp notNil ifTrue:[
	Timestamp now < (CacheMountPointsTimeStamp addSeconds:5*60) ifTrue:[
	    ^ CachedMountPoints
	].
    ].

    '/proc/mounts' asFilename exists ifTrue:[
	CachedMountPoints := self mountPointsFromProcFS.
	CacheMountPointsTimeStamp := Timestamp now.
	^ CachedMountPoints
    ].

    "/ TODO: add fallback code for other OS's (i.e. reading /etc/mtab)
    ^ #()

    "
     OperatingSystem mountPoints
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

pathNameForDrive:driveName
    "given a drive name, return the pathname to open it as a directory.
     For Windows, this is the driveName itself.
     For OSX, '/Volumes' is prepended.
     Other OSs might prepent the pount point (i.e. /mnt/)"

    ^ driveName
!

pathNameOf:pathName
    "return the pathName of the argument, aPathString,
     - that's the full pathname of the directory, starting at '/'.
     This method needs the path to be valid
     (i.e. all directories must exist, be readable and executable).
     Notice: if symbolic links are involved, the result may look different
     from what you expect."

    |p path command|

    path = '.' ifTrue:[
	^ self getCurrentDirectory.
    ].

    "some systems have a convenient function for this ..."
    path := self primPathNameOf:(self encodePath:pathName).
    path notNil ifTrue:[
	path := self decodePath:path.
    ] ifFalse:[
	(self isValidPath:pathName) ifFalse:[
	    p := pathName.
	    [(p size > 1)
	     and:[p endsWith:(self fileSeparator)]
	    ] whileTrue:[
		p := p copyButLast.
	    ].
	    ^ p
	].

	(SlowFork==true or:[PipeFailed==true]) ifFalse:[
	    |directoryName fileBaseName|

	    (self isDirectory:pathName) ifTrue:[
		directoryName := pathName.
		fileBaseName := nil.
	    ] ifFalse:[
		|pathFilename|
		pathFilename := pathName asFilename.
		directoryName := pathFilename directoryName.
		fileBaseName := pathFilename baseName.
	    ].

	    PipeStream openErrorSignal handle:[:ex |
		PipeFailed := true.
		'UnixOperatingSystem [warning]: cannot fork/popen' errorPrintCR.
		ex return.
	    ] do:[
		"have to fall back ..."
		command := 'cd "' , directoryName , '"; pwd'.
		p := PipeStream readingFrom:command.
	    ].

	    (p isNil or:[p atEnd]) ifTrue:[
		('UnixOperatingSystem [warning]: PipeStream for <' , command , '> failed') errorPrintCR.
	    ] ifFalse:[
		path := p nextLine.
		p close.
	    ].
	    fileBaseName notNil ifTrue:[
		path := path, '/', fileBaseName.
	    ].
	].
	path isNil ifTrue:[
	    "/
	    "/ return the original - there is nothing else can we do
	    "/
	    path := pathName
	].
	(SlowFork==true or:[ForkFailed==true]) ifTrue:[
	    path := self compressPath:path
	]
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

    "Modified: / 29.11.1996 / 18:02:12 / stefan"
    "Modified: / 5.6.1998 / 18:37:15 / cg"
!

primGetCurrentDirectory
    "return the raw name of the current directory (nil if failed - can this ever happen?).
     Warning:
	Don't call this from outside: we may have to decode UTF on some systems.
	See getCurrentDirectory"

%{  /* UNLIMITEDSTACK */
    char nameBuffer[MAXPATHLEN + 1];

    if (getcwd(nameBuffer, MAXPATHLEN)) {
	OBJ path = __MKSTRING(nameBuffer);
	RETURN(path);
    }
    RETURN(nil);
%}

    "
     self primGetCurrentDirectory
    "
!

primIdOf:aPathName
    "the actual code to return the fileNumber (i.e. inode number) of a file."

    |encodedPathName|

    encodedPathName := self encodePath:aPathName.
%{
    if (__isStringLike(encodedPathName)) {
	struct stat buf;
	unsigned INT ino;
	OBJ retVal;
	int ret;

# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for id\n", __stringVal(encodedPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(encodedPathName), &buf);
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret >= 0) {
	    ino = buf.st_ino;
	    retVal = __MKUINT(ino);
	    RETURN (retVal);
	}
	@global(LastErrorNumber) = __mkSmallInteger(errno);
	RETURN (nil);
    }
    RETURN (nil);
%}.
!

primInfoOf:aPathName
   "for rel5 only"

   ^ self primitiveFailed


!

primPathNameOf:pathName
    "return the pathName of the argument, aPathString,
     - that's the full pathname of the directory, starting at '/'.
     This method here returns nil, if the OS does not provide a
     realPath library function.
     Notice: if symbolic links are involved, the result may look different
     from what you expect."

    |error|

%{  /* UNLIMITEDSTACK */
#ifdef __SCHTEAM__
    if (pathName.isStringLike()) {
	java.io.File file = new java.io.File( pathName.asString() );

	if (file.exists()) {
	    return __c__._RETURN( new STString( file.getAbsolutePath() ));
	}
    }
#else
    if (__isStringLike(pathName)) {
# ifdef HAS_REALPATH
	extern char *realpath();

	// POSIX-2008 says, that a NULL namebuffer causes realPath to malloc()
	// the required memory. But this does not work as of 2013-04
	char nameBuffer[MAXPATHLEN+1];
	char *nameP = realpath(__stringVal(pathName), nameBuffer);
	if (nameP) {
	    OBJ ret = __MKSTRING(nameP);
	    // free(nameP);
	    RETURN ( ret );
	}
	// fprintf(stderr, "stx[warning]: realpath(\"%s\") failed: %s\n", __stringVal(pathName), strerror(errno));
# endif /* ! HAS_REALPATH */
    } else {
	error = @symbol(argument);     // argument is not a string
    }
#endif
%}.
"/ Does not work as of 2013-04 (UNLIMITEDSTACK problem?)
"/    error notNil ifTrue:[
"/        ^ self primitiveFailed:error.
"/    ].
    ^ nil

    "
	self primPathNameOf:'.'
	self primPathNameOf:'/murks/quatsch/bla/.'
	self primPathNameOf:5555
    "
!

timeOfLastAccess:aPathName
    "return the time, when the file was last accessed.
     For nonexistent files, nil is returned."

    "could be implemented as:
	(self infoOf:aPathName) accessed
    "
    |osSeconds i encodedPathName|

    encodedPathName := self encodePath:aPathName.

%{
    if (__isStringLike(encodedPathName)) {
	struct stat buf;
	time_t mtime;
	int ret;

# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for timeOfLastAccess\n", __stringVal(encodedPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(encodedPathName), &buf);
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN (nil);
	}
	osSeconds = __MKUINT(buf.st_atime);
    }
%}.
    osSeconds notNil ifTrue:[^ Timestamp fromOSTime:(osSeconds * 1000)].

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

    |osSeconds i encodedPathName|

    encodedPathName := self encodePath:aPathName.
%{
    if (__isStringLike(encodedPathName)) {
	struct stat buf;
	int ret;
	time_t mtime;

# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for timeOfLastChange\n", __stringVal(encodedPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(encodedPathName), &buf);
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( nil );
	}
	osSeconds = __MKUINT(buf.st_mtime);
    }
%}.
    osSeconds notNil ifTrue:[^ Timestamp fromOSTime:(osSeconds * 1000)].

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

    |i osSeconds encodedPathName|

    encodedPathName := self encodePath:aPathName.

    "
     this could have been implemented as:
	(self infoOf:aPathName) type
     but for huge directory searches the code below is faster
    "

%{
    if (__isStringLike(encodedPathName)) {
	struct stat buf;
	int ret;

# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for type\n", __stringVal(encodedPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(encodedPathName), &buf);
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( nil );
	}
	switch (buf.st_mode & S_IFMT) {
	    case S_IFDIR:
		RETURN ( @symbol(directory) );
	    case S_IFREG:
		RETURN ( @symbol(regular) );
# ifdef S_IFCHR
	    case S_IFCHR:
		RETURN ( @symbol(characterSpecial) );
# endif
# ifdef S_IFBLK
	    case S_IFBLK:
		RETURN ( @symbol(blockSpecial) );
# endif
# ifdef S_IFLNK
	    case S_IFLNK:
		RETURN ( @symbol(symbolicLink) );
# endif
# ifdef S_IFSOCK
	    case S_IFSOCK:
		RETURN ( @symbol(socket) );
# endif
# ifdef S_IFIFO
	    case S_IFIFO:
		RETURN ( @symbol(fifo) );
# endif
	    default:
		RETURN ( @symbol(unknown) );
	}
    }
%}.
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

volumeNameOf:aPathString
    "return the volumeName of the argument, aPath
     - that's the name of the volume where aPath is.
     Not all OperatingSystems support/use volumes; on unix,
     this always returns an empty string."

    ^ ''

    "Modified: / 5.6.1998 / 18:38:11 / cg"
! !

!UnixOperatingSystem class methodsFor:'interrupts & signals'!

defaultSignal:signalNumber
    "revert to the default action on arrival of a (Unix-)signal.
     Don't confuse Unix signals with smalltalk signals.
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

%{  /* NOCONTEXT */

    int ret, flags, f;

#if (defined(F_GETFL) && defined(F_SETFL) && defined(FASYNC)) || defined(SYSV4)
    if (__isSmallInteger(fd)) {
	f = __intVal(fd);
# if defined(SYSV4)
	ret = ioctl(f, I_SETSIG, 0);
# else /*! SYSV4*/
	flags = fcntl(f, F_GETFL, 0);
	/*
	 * if already clear, there is no need for this syscall ...
	 */
	if (flags & FASYNC) {
	    ret = fcntl(f, F_SETFL, flags & ~FASYNC);
	    if (ret >= 0) ret = flags;
	} else {
	    ret = flags;
	}
# endif /* !SYSV4 */
	RETURN ( __mkSmallInteger(ret) );
    }
#endif
%}.
    "
     this error is triggered on non-integer argument
     or if the OS does not support IO interrupts.
    "
    ^ self primitiveFailed
!

disableSignal:signalNumber
    "disable (Unix-) signal processing for signalNumber.
     Don't confuse Unix signals with smalltalk signals.
     WARNING: for some signals, it is no good idea to disable
     them; for example, disabling the SIGINT signal turns off ^C
     handling.
     Also, NOTICE that signal numbers are not portable between unix
     systems - use OperatingSystem sigXXX to get the numeric value for
     a signal.
     Use only for fully debugged stand alone applications."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (signalNumber.isSmallInteger()) {
	int sigNo = signalNumber.intValue();

	if (sigNo != 0) {
	    java.lang.System.err.println("ignored disable-signal: "+sigNo);
	}
	return context._RETURN(self);
    }
#else
    if (__isSmallInteger(signalNumber)) {
	int sigNo = __intVal(signalNumber);

	if (sigNo == 0) {
	    RETURN (self);
	}
# ifdef SIG_IGN
	signal(sigNo, SIG_IGN);
	RETURN (self);
# endif
    }
#endif
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

#if defined(ITIMER_REAL) && !defined(NO_SETITIMER)
    struct itimerval dt;

    dt.it_interval.tv_sec = 0;
    dt.it_interval.tv_usec = 0;
    dt.it_value.tv_sec = 0;
    dt.it_value.tv_usec = 0;
    setitimer(ITIMER_REAL, &dt, 0);
    RETURN (true);
#else

# if defined(USE_SLOW_ALARM)
#  if defined(SIGALRM)
    alarm(0);
    RETURN (true);
#  endif /* SIGALRM */
# endif

#endif
%}.
    ^ false
!

enableChildSignalInterrupts
    "enable childSignal interrupts
     (SIGCHLD, if the architecture supports it).
     After enabling, these signals will send the message
     'childSignalInterrupt' to the ChildSignalInterruptHandler object."

    self enableSignal:(self sigCHLD)
!

enableIOInterruptsOn:fd
    "turn on IO interrupts for a filedescriptor"

%{  /* NOCONTEXT */

    int ret, flags, f;
#ifndef __signalIoInterrupt
    extern void __signalIoInterrupt();
#endif
    static int firstCall = 1;

#if (defined(F_GETFL) && defined(F_SETFL) && defined(FASYNC)) || defined(SYSV4)
    /*
     * SIGIO/SIGPOLL - data available for I/O
     * (used to wake up waiting processes)
     */
# ifdef SIGIO
#  define THESIGNAL SIGIO
# else
#  ifdef SIGPOLL
#   define THESIGNAL SIGPOLL
#  else
#   ifdef SIGURG
#    define THESIGNAL SIGURG
#   endif
#  endif
# endif

    if (__isSmallInteger(fd)) {
	if (firstCall) {
# ifdef HAS_SIGACTION
	    struct sigaction act;

	    /*
	     * Do not add SA_RESTART here. A signal can cause a
	     * thread switch, another thread can do a garbage collect
	     * and restarted system calls may write into old
	     * (collected) addresses.
	     */

	    act.sa_flags = SA_SIGINFO; /* <- if you add more, remember dummys at the top */
	    sigemptyset(&act.sa_mask);
	    act.sa_handler = __signalIoInterrupt;
	    sigaction(THESIGNAL, &act, 0);
# else
#  ifdef HAS_SIGVEC
	    struct sigvec vec;

	    vec.sv_flags = SV_INTERRUPT;
	    sigemptyset(&vec.sv_mask);
	    vec.sv_handler = __signalIoInterrupt;
	    sigvec(THESIGNAL, &vec, NULL);
#  else
	    signal(THESIGNAL, __signalIoInterrupt);
#  endif /* SIGVEC */
# endif /* SIGACTION */
	    firstCall = 0;
	}
#undef THESIGNAL

	f = __intVal(fd);
# if defined(SYSV4)
	ret = ioctl(f, I_SETSIG, S_INPUT | S_HIPRI | S_ERROR | S_RDNORM | S_RDBAND | S_MSG | S_HANGUP);
# else /*! SYSV4*/
	flags = fcntl(f, F_GETFL, 0);
	/*
	 * if already set, there is no need for this syscall ...
	 */
	if (flags & FASYNC) {
	    ret = flags;
	} else {
	    ret = fcntl(f, F_SETFL, flags | FASYNC);
	    if (ret >= 0) ret = flags;
	}
# endif /*!SYSV4*/

# if defined(F_SETOWN) || defined(FIOSETOWN)
	{
	    int pid;
	    int ok;

	    pid = getpid();

#  if defined(F_SETOWN)
	    ok = fcntl(f, F_SETOWN, pid);
	    /* printf("F_SETOWN returns %d (%d)\n", ret, errno); */
#  else
	    ok = ioctl(f, FIOSETOWN, &pid);
	    /* printf("FIOSETOWN returns %d (%d)\n", ret, errno); */
#  endif
	    if (ok < 0) {
		ret = ok;
	    }
	}
# endif
	RETURN ( __MKUINT(ret) );
    }
#endif
%}.
    "
     this error is triggered on non-integer argument
     or if the system does not support SIGIO
    "
    ^ self primitiveFailed
!

enableSignal:signalNumber
    "enable (Unix-)signal processing for signalNumber.
     Don't confuse Unix signals with smalltalk signals.
     The signal will be delivered to one of the standard handlers
     (SIGINT, SIGQUIT, etc) or to a general handler, which
     sends #signalInterrupt:.

     NOTICE that signal numbers are not portable between unix
     systems - use OperatingSystem sigXXX to get the numeric value for
     a signal."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (signalNumber.isSmallInteger()) {
	int sigNo = signalNumber.intValue();

	if (sigNo != 0) {
	    java.lang.System.err.println("ignored enable-signal: "+sigNo);
	}
	return context._RETURN(self);
    }
#else

# ifdef NSIG
#  define SIG_LIMIT NSIG
# else
#  ifdef SIGUSR2
#   define SIG_LIMIT SIGUSR2
#  else
#   ifdef SIGUSR
#    define SIG_LIMIT SIGUSR
#   endif
#  endif
# endif

# if defined(SIGPOLL) && !defined(SIGIO)
#  define SIGIO SIGPOLL
# endif

# ifdef SIGCHLD
#  define CHILD_SIGNAL   SIGCHLD
# else
#  ifdef SIGCLD
#   define CHILD_SIGNAL  SIGCLD
#  endif
# endif

    int sigNr;
# if defined(SIGINT) || defined(SIGQUIT)
#  ifndef __signalUserInterrupt
    extern void __signalUserInterrupt(SIGHANDLER_ARG);
#  endif
# endif
# ifdef SIGFPE
#  ifndef __signalFpExceptionInterrupt
    extern void __signalFpExceptionInterrupt(SIGHANDLER_ARG);
#  endif
# endif
# ifdef SIGIO
#  ifndef __signalIoInterrupt
    extern void __signalIoInterrupt(SIGHANDLER_ARG);
#  endif
# endif
# ifdef CHILD_SIGNAL
#  ifndef __signalChildInterrupt
    extern void __signalChildInterrupt(SIGHANDLER_ARG);
#  endif
# endif
# ifdef SIGPIPE
#  ifndef __signalPIPEInterrupt
    extern void __signalPIPEInterrupt(SIGHANDLER_ARG);
#  endif
# endif
# ifdef SIGBUS
#  ifndef __signalBUSInterrupt
    extern void __signalBUSInterrupt(SIGHANDLER_ARG);
#  endif
# endif
# ifdef SIGSEGV
#  ifndef __signalSEGVInterrupt
    extern void __signalSEGVInterrupt(SIGHANDLER_ARG);
#  endif
# endif
# if defined(SIGILL) || defined(SIGEMT)
#  ifndef __signalTrapInterrupt
    extern void __signalTrapInterrupt(SIGHANDLER_ARG);
#  endif
# endif
# ifdef SIGALRM
#  ifndef __signalTimerInterrupt
    extern void __signalTimerInterrupt(SIGHANDLER_ARG);
#  endif
# endif
# ifdef SIGABRT
#  ifndef __signalAbortInterrupt
    extern void __signalAbortInterrupt(SIGHANDLER_ARG);
#  endif
# endif
# ifndef __signalInterrupt
    extern void __signalInterrupt(SIGHANDLER_ARG);
# endif
    void (*handler)(SIGHANDLER_ARG);

    if (__isSmallInteger(signalNumber)
     && ((sigNr = __intVal(signalNumber)) >= 0)
# ifdef SIG_LIMIT
     &&  (sigNr <= SIG_LIMIT)
# endif
    ) {
	/*
	 * standard signals are forced into standard handlers
	 * - all others go into general signalInterrupt
	 */
# if defined(SIGPOLL) && defined(SIGIO)
	if (sigNr == SIGPOLL)
	    sigNr = SIGIO;
# endif
	switch (sigNr) {
	    case 0:
		/* enabling a non-supported signal */
		RETURN (self);

# ifdef SIGBREAK
	    case SIGBREAK:
# endif
# ifdef SIGINT
	    case SIGINT:
# endif
# ifdef SIGQUIT
	    case SIGQUIT:
# endif
# if defined(SIGINT) || defined(SIGQUIT) || defined(SIGBREAK)
		handler = __signalUserInterrupt;
		break;
# endif
# ifdef SIGFPE
	    case SIGFPE:
		handler = __signalFpExceptionInterrupt;
		break;
# endif

# ifdef SIGPIPE
	    case SIGPIPE:
		handler = __signalPIPEInterrupt;
		break;
# endif
# ifdef SIGBUS
	    case SIGBUS:
		handler = __signalBUSInterrupt;
		break;
# endif
# ifdef SIGSEGV
	    case SIGSEGV:
		handler = __signalSEGVInterrupt;
		break;
# endif
# ifdef SIGABRT
	    case SIGABRT:
		handler = __signalAbortInterrupt;
		break;
# endif
# ifdef SIGILL
	    case SIGILL:
		handler = __signalTrapInterrupt;
		break;
# endif
# ifdef SIGEMT
	    case SIGEMT:
		handler = __signalTrapInterrupt;
		break;
# endif
# ifdef SIGIO
	    case SIGIO:
		handler = __signalIoInterrupt;
		break;
# endif

# ifdef CHILD_SIGNAL
	    case CHILD_SIGNAL:
		handler = __signalChildInterrupt;
		break;
# endif
# ifdef SIGALRM
	    case SIGALRM:
		handler = __signalTimerInterrupt;
		break;
# endif

	    default:
		handler = __signalInterrupt;
		break;
	}

	{
# ifdef HAS_SIGACTION
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
# else
#  ifdef HAS_SIGVEC
	    struct sigvec vec;

	    vec.sv_flags = SV_INTERRUPT;
	    sigemptyset(&vec.sv_mask);
	    vec.sv_handler = handler;
	    sigvec(sigNr, &vec, NULL);
#  else
	    (void) signal(sigNr, handler);
#  endif
# endif
	}

	/*
	 * maybe, we should ret the old enable-status
	 * as boolean here ...
	 */
	RETURN (self);
    }
#endif /* not SCHTEAM */
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
#ifdef __SCHTEAM__
    if (milliSeconds.isSmallInteger()) {
	long millis = milliSeconds.longValue();

	java.lang.System.err.println("ignored enable-timer");
	return context._RETURN(self);
    }
#else
    int millis;

    millis = __intVal(milliSeconds);

# ifdef SIGALRM
    {
	static int firstCall = 1;
#  ifndef __signalTimerInterrupt
	extern void __signalTimerInterrupt(SIGHANDLER_ARG);
#  endif

	if (firstCall) {
#  ifdef HAS_SIGACTION
	    struct sigaction act;

	    act.sa_flags = SA_SIGINFO; /* <- if you add more, remember dummys at the top */
	    sigemptyset(&act.sa_mask);
	    act.sa_handler = __signalTimerInterrupt;
	    sigaction(SIGALRM, &act, 0);
#  else
#   ifdef HAS_SIGVEC
	    struct sigvec vec;

	    vec.sv_flags = SV_INTERRUPT;
	    sigemptyset(&vec.sv_mask);
	    vec.sv_handler = __signalTimerInterrupt;
	    sigvec(SIGALRM, &vec, NULL);
#   else /* neither SIGACTION nor SIGVEC */
	    signal(SIGALRM, __signalTimerInterrupt);
#   endif /* stupid system  */
#  endif
	    firstCall = 0;
	}
    }
# endif /* SIGALRM */


# if defined(ITIMER_REAL) && !defined(NO_SETITIMER)
    {
	struct itimerval dt;

	dt.it_interval.tv_sec = 0;
	dt.it_interval.tv_usec = 0;
	dt.it_value.tv_sec = millis / 1000;
	dt.it_value.tv_usec = (millis % 1000) * 1000;
	setitimer(ITIMER_REAL, &dt, 0);
	RETURN (true);
    }
# else /* no ITIMER_REAL */

#  ifdef USE_SLOW_ALARM
    {
	/*
	 * last fallback - use alarm (which only gives 1 second resolution).
	 * If the system does not support any of the above, you have to life
	 * with this. The consequence is that pressing CTRL-C processing and
	 * thread switching will take place much delayed.
	 */
	alarm(1);
	RETURN(true);
    }
#  endif
# endif /* ITIMER_REAL */
#endif /* not SCHTEAM */
%}.
    ^ false
!

interruptProcess:processId
    "interrupt (SIGINT) a unix process."

    self sendSignal:(self sigINT) to:processId toGroup:false toAll:false.
!

interruptProcessGroup:processId
    "interrupt (SIGINT) a unix process group."

    self sendSignal:(self sigINT) to:processId toGroup:false toAll:true.
!

isFatalSignal:aNumber
   "return true if a signal with number aNumber is a fatal signal,
    i.e. some severe internal error occurred"

   ^ (aNumber == self sigSEGV)
     or:[aNumber == self sigILL
     or:[aNumber == self sigBUS]]
!

killProcess:processId
    "kill a unix process.
     The process has a no chance to do some cleanup.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId."

    self sendSignal:(self sigKILL) to:processId toGroup:false toAll:false.

    "Modified: / 10.6.1998 / 11:59:12 / cg"
!

killProcessGroup:processGroupId
    "kill a unix process group.
     The process has a no chance to do some cleanup.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId."

    self sendSignal:(self sigKILL) to:processGroupId toGroup:false toAll:true.

    "Created: / 10.6.1998 / 11:59:29 / cg"
!

sendSignal:signalNumber to:processId
    "send a unix signal to some process (maybe myself).
     Returns false if any error occurred, true otherwise.

     Do not confuse UNIX signals with Smalltalk-Signals.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId
	      if the signal terminates that process."

    ^ self sendSignal:signalNumber to:processId toGroup:false toAll:false
!

sendSignal:signalNumber to:processId toGroup:toGroupBoolean toAll:toAllBoolean
    "send a unix signal to some process (maybe myself).
     Returns false if any error occurred, true otherwise.
     toGroup: sends the signal with pid as zero
     toAll:   sends the signal with pid negated

     From Unix man page:
	 If pid is greater than zero:
	     Sig is sent to the process whose ID is equal to pid.

	 If pid is zero:
	     Sig is sent to all processes whose group ID is equal to the process group ID of the
	     sender, and for which the process has permission; this is a variant of killpg(2).

	 If pid is -1:
	     If the user has super-user privileges, the signal is sent to all processes excluding
	     system processes and the process sending the signal.  If the user is not the super user,
	     the signal is sent to all processes with the same uid as the user, excluding the process
	     sending the signal.  No error is returned if any process could be signaled.

     Do not confuse UNIX signals with Smalltalk-Signals.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId
	      if the signal terminates that process."

%{
    if (__bothSmallInteger(signalNumber, processId)) {
	int sigNo, pid;

	sigNo = __intVal(signalNumber);
	pid = __intVal(processId);
	if (toAllBoolean == true) {
	    pid = -pid;
	} else if (toGroupBoolean == true) {
	    pid = 0;
	}
	if (kill(pid, sigNo) < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( false );
	}
	RETURN ( true );
    }
%}.
    "/
    "/ either invalid argument (non-integers)
    "/ or not supported by OS
    "/
    ^ self primitiveFailed
!

startSpyTimer
    "trigger a spyInterrupt, to be signalled after some short (virtual) time.
     This is used by the old MessageTally for profiling.
     Should be changed to use real profiling timer if available.
     On systems, where no virtual timer is available, use the real timer
     (which is of course less correct).
     OBSOLETE: the new messageTally runs as a high prio process, not using
	       spy interrupts."

%{  /* NOCONTEXT */

#ifndef __spyInterrupt
    extern void __spyInterrupt();
#endif

#if defined(ITIMER_VIRTUAL) && !defined(NO_SETITIMER)
    struct itimerval dt;

# ifdef SIGVTALRM
    signal(SIGVTALRM, __spyInterrupt);
# else
#  ifdef SIGALRM
    signal(SIGALRM, __spyInterrupt);
#  else
    /*
     * mhmh - system has neither SIGBTALRM nor SIGALRM ...
     * what should we do here ?
     */
#  endif
# endif

    dt.it_interval.tv_sec = 0;
    dt.it_interval.tv_usec = 0;
    dt.it_value.tv_sec = 0;
    dt.it_value.tv_usec = 1000;   /* 1000 Hz */
    setitimer(ITIMER_VIRTUAL, &dt, 0);

    RETURN (true);
#endif /* ITIMER_VIRTUAL */
%}.
    ^ false
!

stopSpyTimer
    "stop spy timing - disable spy timer.
     OBSOLETE: the new messageTally runs as a high prio process, not using
	       spy interrupts."

%{  /* NOCONTEXT */

#if defined(ITIMER_VIRTUAL) && !defined(NO_SETITIMER)
    struct itimerval dt;

    dt.it_interval.tv_sec = 0;
    dt.it_interval.tv_usec = 0;
    dt.it_value.tv_sec = 0;
    dt.it_value.tv_usec = 0;
    setitimer(ITIMER_VIRTUAL, &dt, 0);
    RETURN (true);
#endif /* ITIMER_VIRTUAL */
%}.
    ^ false
!

terminateProcess:processId
    "terminate a unix process.
     The process has a chance to do some cleanup.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId."

    self sendSignal:(self sigTERM) to:processId toGroup:false toAll:false.

    "Modified: / 28.12.1995 / 15:05:37 / stefan"
    "Modified: / 27.1.1998 / 20:05:47 / cg"
!

terminateProcessGroup:processGroupId
    "terminate a unix process group.
     The process has a chance to do some cleanup.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId."

    self sendSignal:(self sigTERM) to:processGroupId toGroup:false toAll:true.

    "Modified: / 28.12.1995 / 15:05:37 / stefan"
    "Created: / 23.4.1996 / 16:40:34 / stefan"
    "Modified: / 27.1.1998 / 20:05:59 / cg"
! !

!UnixOperatingSystem class methodsFor:'ipc support'!

makeBidirectionalPipe
    "make a socketPair, return array with two filedescriptors on success,
     nil on failure.
     This is a lowLevel entry, not for public use."

    |fd1 fd2|

%{
#ifndef NO_SOCKET
     int fds[2];

     if (socketpair(AF_UNIX, SOCK_STREAM, 0, fds) == -1) {
	@global(LastErrorNumber) = __mkSmallInteger(errno);
	RETURN ( nil );
     }

     fd1 = __mkSmallInteger(fds[0]);
     fd2 = __mkSmallInteger(fds[1]);
#endif
%}.
    fd1 notNil ifTrue:[
	^ Array with:fd1 with:fd2.
    ].
    ^ nil
!

makePTY
    "make a pty-pair, return a triple with two filedescriptors and the pty's name
     on success, nil on failure.
     This is a lowLevel entry, not for public use.
     See NonPositionableExternalStream>>makePTYPair for a more user-friendly,
     public interface."

    |fdS fdM ptyName|

%{
    /*
     * Find a pseudo tty to use and open both sides.
     *  _fdM receives the master file descriptor while _fdS
     *  receives the slave.
     */

#ifdef IRIX5
    int _fdM, _fdS;
    char *slaveName;

    slaveName = _getpty(&_fdM, O_RDWR|O_NDELAY, 0600, 0);
    if ((slaveName != 0) && (_fdM >= 0)) {
	_fdS = open(slaveName, O_RDWR);
	if (_fdS < 0) {
	    (void)close(_fdM);
	    _fdS = _fdM = -1;
	}
    } else {
	_fdM -1;
    }
    if ((_fdM >= 0) && (_fdS >= 0)) {
	fdM = __mkSmallInteger(_fdM);
	fdS = __mkSmallInteger(_fdS);
	ptyName = __MKSTRING(slaveName);
    }
#   define PTY_IS_IMPLEMENTED 1
#endif /* IRIX5 */


#if defined(HAS_UNIX98_PTY)
    int _fdM, _fdS;
    char *slaveName;
    extern char *ptsname(int);     /* also in #include <stdlib.h> */
    extern int grantpt(int);
    extern int unlockpt(int);

    _fdM = open("/dev/ptmx", O_RDWR | O_NOCTTY);

    if (_fdM >= 0) {
	/*
	** grantpt() changes owner, group and mode of the pseudo-tty
	*/
	grantpt(_fdM);
	unlockpt(_fdM);
	slaveName = ptsname(_fdM);

	if (slaveName != NULL) {
	    /* printf("slave is: %s\n", slaveName); */
	    _fdS = open(slaveName, O_RDWR);
	    if (_fdS < 0) {
		(void)close(_fdM);
		_fdS = _fdM = -1;
	    }
#if defined(UNIXWARE) || defined(solaris)
	    else {
		/* push terminal modules on stream */
		ioctl(_fdS, I_PUSH, "ptem");
		ioctl(_fdS, I_PUSH, "ldterm");
	    }
#endif
	} else {
	    (void)close(_fdM);
	    _fdS = _fdM = -1;
	}
    }

    if ((_fdM >= 0) && (_fdS >= 0)) {
	fdM = __mkSmallInteger(_fdM);
	fdS = __mkSmallInteger(_fdS);
	ptyName = __MKSTRING(slaveName);
    }
#   define PTY_IS_IMPLEMENTED 1
#endif /* HAS_UNIX98_PTY */

#if !defined(PTY_IS_IMPLEMENTED)
# ifdef LINUX
#   define PTY_TEMPL    "/dev/ptyXX"
#   define PT_INDEX      5
#   define PTY_1_CHARS  "pqrstuabcdevwxyz"
#   define PTY_2_CHARS  "0123456789abcdef"
# endif /* LINUX */

# ifdef solaris
#   define PTY_TEMPL    "/dev/ptyXX"
#   define PT_INDEX      5
#   define PTY_1_CHARS  "pqr"
#   define PTY_2_CHARS  "0123456789abcdef"
# endif /* solaris */

# ifdef aix
#   define PTY_TEMPL    "/dev/ptyXX"
#   define PT_INDEX      5
#   define PTY_1_CHARS  "pqr"
#   define PTY_2_CHARS  "0123456789abcdef"
# endif /* aix */

# ifdef next3
#   define PTY_TEMPL    "/dev/ptyXX"
#   define PT_INDEX      5
#   define PTY_1_CHARS  "pqr"
#   define PTY_2_CHARS  "0123456789abcdef"
# endif /* next3 */

# ifdef hpux
#   define PTY_TEMPL    "/dev/ptyXX"
#   define PT_INDEX      5
#   define PTY_1_CHARS  "pqrs"
#   define PTY_2_CHARS  "0123456789abcdef"
# endif /* hpux */

# if defined(__osf__)
#   define PTY_TEMPL    "/dev/ptyXX"
#   define PT_INDEX      5
#   define PTY_1_CHARS  "pq"
#   define PTY_2_CHARS  "0123456789abcdef"
# endif /* osf1 */

# if defined(BSD) && !defined(PTY_TEMPL)
#   define PTY_TEMPL    "/dev/ptyXX"
#   define PT_INDEX      5
#   define PTY_1_CHARS  "p"
#   define PTY_2_CHARS  "0123456789abcdefghijklmnopqrstuv"
# endif /* BSD */


#   include <grp.h>

    static int ttygid = -2;
    char line[128];
    register CONST char *cp1, *cp2;
    int len, _fdM = -1, _fdS = -1;
    char *slaveName = NULL;

    len = sizeof(PTY_TEMPL) - 1;
    strncpy(line, PTY_TEMPL, sizeof(PTY_TEMPL));

    if (ttygid == -2) {
	struct group *gr;

	if ((gr = getgrnam("tty")) != NULL)
	    ttygid = gr->gr_gid;
	else
	    ttygid = -1;
    }

    for (cp1 = PTY_1_CHARS; *cp1; cp1++) {
	line[len-2] = * cp1;

	for( cp2 = PTY_2_CHARS; *cp2; cp2++ ) {
	    line[PT_INDEX] = 'p';
	    line[len-1] = *cp2;

	    if ((_fdM = open(line, O_RDWR, 0)) < 0) {
		if (errno == ENOENT) {
		    _fdM = _fdS = -1;
		    goto getOutOfHere; /* out of ptys */
		}
	    } else {
		line[PT_INDEX] = 't';

		/*
		 * try to set owner and mode.
		 * this works only if running under root
		 */
		(void) chown( line, getuid(), ttygid );
		(void) chmod( line, S_IRUSR | S_IWUSR | S_IWGRP );

		if( (_fdS = open(line, O_RDWR, 0)) >= 0 ) {
		    slaveName = line;
		    goto getOutOfHere; /* success */
		}
		(void) close(_fdM );
	    }
	}
    }
  getOutOfHere: ;

    if ((_fdM >= 0) && (_fdS >= 0)) {
	fdM = __mkSmallInteger(_fdM);
	fdS = __mkSmallInteger(_fdS);
	ptyName = __MKSTRING(slaveName);
    }

#endif /* ! defined(PTY_IS_IMPLEMENTED) */
%}.

    fdM notNil ifTrue:[
	^ Array with:fdM with:fdS with:ptyName.
    ].

    ^ nil
!

makePTYPair
    "make a pty-pair, return an array with two filedescriptors on success,
     nil on failure.
     This is a leftover compatibility lowLevel entry, not for public use.
     See NonPositionableExternalStream>>makePTYPair for a more user-friendly,
     public interface."

    |triple|

    triple := self makePTY.
    triple isNil ifTrue:[^ nil].
    ^ Array with:(triple at:1) with:(triple at:2)
!

makePipe
    "make a pipe, return array with two filedescriptors on success,
     nil on failure.
     This is a lowLevel entry, not for public use.
     See ExternalStream>>makePipe for a more user-friendly, public interface."

    |fd1 fd2|

%{
     int fds[2];

     if (pipe(fds) < 0) {
	@global(LastErrorNumber) = __mkSmallInteger(errno);
	RETURN ( nil );
     }

     fd1 = __mkSmallInteger(fds[0]);
     fd2 = __mkSmallInteger(fds[1]);
%}.
    fd1 notNil ifTrue:[
	^ Array with:fd1 with:fd2.
    ].
    ^ nil
!

resetTerminalInputOutputModes:fd
    "reset the terminal attributes"
%{
    struct termios switcher;

    printf("setMappingMaster fd:%d\n", (int)__intVal(fd));
    if (__isSmallInteger(fd)) {
	if (tcgetattr( __intVal(fd), &switcher) < 0) RETURN (false);
	switcher.c_iflag = 0;
	switcher.c_oflag = 0;
	if (tcsetattr( __intVal(fd), TCSANOW, &switcher) >= 0) {
	    RETURN (true);
	}
    }
%}.
    ^ false
!

setWindowSizeOnFileDescriptor:fd width:w height:h
    "emit a TIOCSWINSZ ioctl; (req'd for terminal emulators)"
%{
#ifdef TIOCSWINSZ
    struct winsize wsize;

    if (__isSmallInteger(fd)
     && __isSmallInteger(w)
     && __isSmallInteger(h)) {
	wsize.ws_row = (unsigned short)__intVal(h);
	wsize.ws_col = (unsigned short)__intVal(w);
	if (ioctl(__intVal(fd), TIOCSWINSZ, (char *)&wsize) >= 0) {
	    RETURN (true);
	}
    }
#endif
%}.
    ^ false
!

shutdownBidirectionalPipeOutput:fileDescriptor
    "inform the other end of the bidirectional pipe represented by fileDescriptor, that
     we will send no more data to the pipe, i.e. EOF is reached"

%{
#ifndef NO_SOCKET
    if (__isSmallInteger(fileDescriptor)) {
	shutdown(__smallIntegerVal(fileDescriptor), 1);
	RETURN(self);
    }
#endif
%}.
    self primitiveFailed
! !

!UnixOperatingSystem class methodsFor:'misc'!

closeLeftOverFiles
    "a bad bad kludge and workaround for a big bug in the linux
     getAddrInfo implementation:
	if it gets interrupted (via a timer, for example), its domain-name
	socket remains open and is NEVER closed.
	These open files collect up and lead to no-more-files eventually.
     Invoking this method helps in this situation."

    |p|

    p := PipeStream
	    readingFrom:('lsof -p ' , (OperatingSystem getProcessId printString)).

    p linesDo:[:line |
	|words fd|

	words := line asCollectionOfWords.
	"/ COMMAND PID USER   FD   TYPE     DEVICE    SIZE    NODE NAME
	words first = 'stx' ifTrue:[
	    words second = (OperatingSystem getProcessId printString) ifTrue:[
		(words fourth endsWith:'u') ifTrue:[
		    (words fifth = 'IPv4') ifTrue:[
			(words seventh = 'UDP') ifTrue:[
			    (words last endsWith:'domain') ifTrue:[
				fd := Number readFrom:(words fourth copyButLast).
Transcript showCR:line.
				OperatingSystem closeFd:fd.
			    ]
			]
		    ]
		]
	    ]
	]
    ].
    p close.

    "
     self closeLeftOverFiles
    "
!

dup:aFileDescriptor
    "duplicate a file descriptor.
     Only use internally"

%{
    int dupFd;

    if (__isSmallInteger(aFileDescriptor)) {
	dupFd = dup(__smallIntegerVal(aFileDescriptor));
	if (dupFd >= 0) {
	    RETURN(__mkSmallInteger(dupFd));
	}
    }
%}.
    ^ self primitiveFailed.
!

slowFork:aBoolean
    "set/clear the `avoid-fork-if-possible-because-its-slow' flag.
     Only used internally on SYSV3 systems"

    SlowFork := aBoolean

    "Modified: 22.4.1996 / 13:13:09 / cg"
! !

!UnixOperatingSystem class methodsFor:'os queries'!

executableFileExtensions
    "return a collection of extensions for executable program files.
     Only req'd for msdos like systems ..."

    ^ #('')

    "Created: / 2.5.1997 / 11:42:29 / cg"
    "Modified: / 5.6.1998 / 18:38:52 / cg"
!

getCodeset
    "get the codeset the system is running under"

    ^ Codeset
!

getCodesetEncoder
    "Initialize CodesetEncoder used to encode/decode strings passed to/from
     the operating system (like file names, command output, environment ect.).

     NOTE: DO NOT CALL this in #initialize as CharacterEncoder might not yet
     be initialized. Therefore this method is called from CharacterEncoder class>>
     #initialize. Certainly a hack, but class initialization order is undefined,
     so some sort of hack is necessary.

     NOTE2: This should be called initializeCodesetEncoder but to make it consistent
     with getCodeset it is getCodesetEncoder
     "

    Codeset isNil ifTrue:[self initializeCodeset].
    CodesetEncoder := CharacterEncoder encoderFor: Codeset.

    "Created: / 23-01-2013 / 09:54:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDomainName
    "return the domain this host is in.
     Notice:
	not all systems support this; on some, #unknown is returned."

    |domainName idx hostName primDomainName|

    "/ use cached value, if present
    (DomainName notNil and:[DomainName ~~ #unknown]) ifTrue:[
	^ DomainName
    ].

    primDomainName := domainName := self primGetDomainName.
    domainName = '(none)' ifTrue:[
	domainName := nil.
    ].
    domainName isEmptyOrNil ifTrue:[
	"sometimes, we can extract the domainName from the hostName ..."
	hostName := self primGetHostName.
	hostName notNil ifTrue:[
	    idx := hostName indexOf:$..
	    idx ~~ 0 ifTrue:[
		domainName := hostName copyFrom:idx+1.
	    ]
	].
	domainName isEmptyOrNil ifTrue:[
	    "/ fallBack
	    domainName := self getEnvironment:'DOMAIN'.

	    "if #primGetDomainName did work, /bin/domainname would return the same result"
	    (domainName isNil and:[primDomainName isNil]) ifTrue:[
		domainName := self getCommandOutputFrom:'/bin/domainname'.
		(domainName isEmptyOrNil or:[ domainName = '(none)' ]) ifTrue:[
		    domainName := nil.
		].
	    ].
	    domainName isNil ifTrue:[
		DomainName ~~ #unknown ifTrue:[
		    "/ only warn once - the warning can be ignored, if you do not use the domain name
		    ObjectMemory debugPrinting ifTrue:[
			'UnixOperatingSystem [info]: cannot find out domainname' infoPrintCR.
		    ].
		].
		domainName := #unknown.
	    ].
	].
    ].

    "cache, because domainName fetching may be expensive;
     but if unknown, it will be tried again"
    DomainName := domainName.
    ^ domainName

    "
     OperatingSystem getDomainName
     OperatingSystem primGetDomainName
     OperatingSystem getHostName
     OperatingSystem primGetHostName
    "

    "Modified: 26.4.1996 / 10:04:54 / stefan"
!

getEnvironment
    "answer the whole environment as a Dictionary"

    |resultArray error dict sz "{ Class: SmallInteger }"|

%{
#ifdef __osx__
    char **environ = *_NSGetEnviron();
#else
    extern char **environ;
#endif
    char **env;
    int nEnv = 0;

    /*
     * get the size of the environment
     */
    if (environ) {
	for (env = environ; *env; env++) {
	    nEnv++;
	}
    }

    /*
     * allcate an array for keys and values
     */
    resultArray = __ARRAY_NEW_INT(nEnv * 2);
    if (resultArray == nil) {
	error = @symbol(allocationFailure);
	goto bad;
    }

    if (environ) {
	int envIndex;

	for (env = environ, envIndex = 0; *env; env++) {
	    OBJ t;
	    char *separatorPtr;

	    separatorPtr = strchr(*env, '=');
	    t = __MKSTRING_L(*env, separatorPtr-*env);
	    __arrayVal(resultArray)[envIndex++] = t;
	    __STORE(resultArray, t);
	    if (separatorPtr == 0) {
		t = nil;
	    } else {
		t = __MKSTRING(separatorPtr+1);
	    }
	    __arrayVal(resultArray)[envIndex++] = t;
	    __STORE(resultArray, t);
	}
    }

bad:;
%}.
    error notNil ifTrue:[
	^ self primitiveFailed:error.
    ].

    sz := resultArray size.
    dict := Dictionary new:(sz // 2).
    1 to:sz by:2 do:[:i |
	|key|

	key := resultArray at:i.
	key notNil ifTrue:[
	    "same behavior as getenv() - the first entry takes precedence"
	    (dict includesKey:key) ifFalse:[
		dict at:key put:(resultArray at:i+1)
	    ].
	].
    ].
    ^ dict

    "
     OperatingSystem getEnvironment
    "
!

getEnvironment:aStringOrSymbol
    "get an environment string"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
	java.lang.String val = java.lang.System.getenv( aStringOrSymbol.asString() );
	STObject retVal;

	if (val == null) {
	    retVal = STObject.Nil;
	} else {
	    retVal = new STString( val );
	}
	return context._RETURN( retVal );
	/* NOTREACHED */
    }
#else
    extern char *getenv();

    if (__isStringLike(aStringOrSymbol)) {
	char *env =  getenv(__stringVal(aStringOrSymbol));
	if (env) {
	    RETURN ( __MKSTRING(env) );
	}
	RETURN ( nil );
    }
#endif /* not SCHTEAM */
%}.
    ^ self primitiveFailed

    "
     OperatingSystem getEnvironment:'LANG'
     OperatingSystem getEnvironment:'LOGIN'
     OperatingSystem getEnvironment:'HOME'
     OperatingSystem getEnvironment:'NNTPSERVER'
     OperatingSystem getEnvironment:'MAIL'
     OperatingSystem getEnvironment:'PATH'
    "
!

getHostName
    "return the hostname we are running on.
     The host name returned is fully qualified - if returned so by the system."

    |hostName|

    (HostName notNil and:[HostName ~~ #unknown]) ifTrue:[
	^ HostName
    ].

    hostName := self primGetHostName.
    hostName isNil ifTrue:[
	"fallBack - in non-antique systes we never come here"
	hostName := self getEnvironment:'HOST'.
	hostName isNil ifTrue:[
	    hostName := self getCommandOutputFrom:'/bin/hostname'
	].
	hostName isNil ifTrue:[
	    HostName ~~ #unknown ifTrue:[
		'UnixOperatingSystem [info]: cannot find out hostname' infoPrintCR.
		hostName := #unknown.
	    ].
	].
    ].

    "cache, because hostname fetching may be expensive;
     but if unknown, it will be tried again"
    HostName := hostName.

    ^ hostName

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

getNetworkAddressInfo
    "return a Dictionary of network interface information.
	key -> name of interface
	value -> a Set of network address
		information for the interface - a dictionaries containing the
		information about the configuration of each interface in the system.
		The dictionary keys are:
		    #address
		    #netmask
		    #flags
		    #destAddress"

    |returnArray addressArray nameArray noOfIf retDictionary error retIndex|

    noOfIf := 0.

%{
#include <ifaddrs.h>
#if 0 && defined(linux)
# include <linux/if_packet.h>
# include <net/ethernet.h> /* the L2 protocols */
#endif

    struct ifaddrs *ifap, *ifaLoop;
    int n_ifa = 0;
    int retI = 0;
    OBJ t;

    if (getifaddrs(&ifap) < 0) {
	error = __MKSTRING("getifaddrs() failed");
	goto out;
    }

    for (ifaLoop = ifap; ifaLoop != 0; ifaLoop = ifaLoop->ifa_next) n_ifa++;
    noOfIf = __mkSmallInteger(n_ifa);

    returnArray = __ARRAY_NEW_INT(n_ifa*6);

    if (returnArray == nil) {
	/* Creating a string wouldn't work here */
	error = @symbol(allocationFailure);
	goto bad;
    }

    for (ifaLoop = ifap; ifaLoop != 0; ifaLoop = ifaLoop->ifa_next) {
	int family, len;

	if (ifaLoop->ifa_addr == 0)
	       continue;
	family = ifaLoop->ifa_addr->sa_family;
	switch (family) {
	    case AF_INET:
		len = sizeof(struct sockaddr_in);
		break;
	    case AF_INET6:
		len = sizeof(struct sockaddr_in6);
		break;
# ifdef WANT__AF_PACKET
	    case AF_PACKET:
		len = sizeof(struct sockaddr_ll);
		break;
#endif
# ifdef WANT__AF_LINK
	    case AF_LINK:
		len = sizeof(struct sockaddr_dl);
		break;
#endif
	    default:
		/* skip */
		continue;
	};
	t = __MKSTRING(ifaLoop->ifa_name);
	__arrayVal(returnArray)[retI++] = t; __STORE(returnArray, t);
	t = __MKUINT(ifaLoop->ifa_flags);
	__arrayVal(returnArray)[retI++] = t; __STORE(returnArray, t);
	t = __MKBYTEARRAY((char *)ifaLoop->ifa_addr, len);
	__arrayVal(returnArray)[retI++] = t; __STORE(returnArray, t);
	if (ifaLoop->ifa_netmask != 0) {
	    t = __MKBYTEARRAY((char *)ifaLoop->ifa_netmask, len);
	    __arrayVal(returnArray)[retI] = t; __STORE(returnArray, t);
	}
	retI++;
	if ((ifaLoop->ifa_flags&IFF_POINTOPOINT) && ifaLoop->ifa_dstaddr != 0) {
	    t = __MKBYTEARRAY((char *)ifaLoop->ifa_dstaddr, len);
	    __arrayVal(returnArray)[retI++] = t; __STORE(returnArray, t);
	} else if (retI++, ifaLoop->ifa_broadaddr != 0) {
	    t = __MKBYTEARRAY((char *)ifaLoop->ifa_broadaddr, len);
	    __arrayVal(returnArray)[retI] = t; __STORE(returnArray, t);
	}
	retI++;
    }

bad:
    freeifaddrs(ifap);

out:;
%}.

    error notNil ifTrue:[
	self primitiveFailed:error.
	"return empty dictionary if proceeding from error"
	^  Dictionary new.
    ].

    retDictionary := OrderedDictionary new:noOfIf.
    retIndex := 1.

    1 to:noOfIf do:[:cnt|
	|name addressBytes set dict|

	name := returnArray at:retIndex.
	addressBytes := returnArray at:retIndex+2.

	addressBytes notNil ifTrue:[
	    set := retDictionary at:name ifAbsentPut:[OrderedCollection new].
	    dict := Dictionary new:4.
	    dict at:#flags put:(returnArray at:retIndex+1).
	    dict at:#address put:(SocketAddress fromBytes:addressBytes).
	    addressBytes := returnArray at:retIndex+3.
	    addressBytes notNil ifTrue:[
		dict at:#netMask put:(SocketAddress fromBytes:addressBytes).
	    ].
	    addressBytes := returnArray at:retIndex+4.
	    addressBytes notNil ifTrue:[
		dict at:#destAddress put:(SocketAddress fromBytes:addressBytes).
	    ].
	    addressBytes := returnArray at:retIndex+5.
	    addressBytes notNil ifTrue:[
		dict at:#broadcastAddress put:(SocketAddress fromBytes:addressBytes).
	    ].
	    set add:dict.
	].
	retIndex := retIndex + 6.
    ].

    ^ retDictionary

    "
      OperatingSystem getNetworkAddressInfo
    "
!

getNetworkAddresses
    "return a dictionary filled with
	key -> name of interface
	value -> the first socket address of the interface
     for each interface"

    |addressInfo newDict|

    addressInfo := self getNetworkAddressInfo.
    newDict := OrderedDictionary new:addressInfo size.

    addressInfo keysAndValuesDo:[:ifName :infoColl|
	newDict at:ifName put:(infoColl first at:#address)
    ].

    ^ newDict.

    "
	self getNetworkAddresses
    "
!

getNetworkMACAddresses
    "return a dictionary filled with
	key -> name of interface
	value -> the MAC address (as ByteArray)
     for each interface"

    |addressArray nameArray noOfIf retDictionary error|

    noOfIf := 0.

%{  /* stack: 32000 */
#if defined(SIOCGIFCONF)
    int             afinet_socket = -1;

    struct ifconf   ifc;
    struct ifreq    *ifr;
    unsigned char   buf[4*1024];
    int             n_ifs, i, countOfIf;
    OBJ             t;

    /*
    ** Open an INET socket
    */

    afinet_socket = socket(AF_INET, SOCK_DGRAM, 0);
    if (afinet_socket < 0) {
	error = __MKSTRING("Cannot open socket");
	goto bad;
    }

    /*
    ** Get the list of network interfaces
    */

    ifc.ifc_len = sizeof (buf);
    ifc.ifc_buf = (caddr_t) buf;

    if (ioctl (afinet_socket, SIOCGIFCONF, (caddr_t) &ifc) < 0) {
	error = __MKSTRING("ioctl(SIOCGIFCONF) failed");
	goto bad;
    }

    // get the number of interfaces in the returned structure

    // cg: sigh
    // on linux, the records have constant size;
    // on osx, the max of the alen of each entry and the struct size needs to be taken to advance

    // I am not sure, which one is the correct way to do (maybe we should invert the test to say #ifdef linux ????
    // Please check on BSD, solaris, etc... (my feeling is, the the other would behave like __osx__ does, as they are all BSDish)
    // see also 2nd loop below
#ifndef __osx__
    n_ifs = ifc.ifc_len / sizeof (struct ifreq);
#else
    {
	unsigned char *cp = buf;
	unsigned char *limit = buf + ifc.ifc_len;

	n_ifs = 0;
	while (cp < limit) {
	    int sz;

	    ifr = (struct ifreq *)cp;
	    sz = IFNAMSIZ + ifr->ifr_addr.sa_len;

	    cp += sz;
	    n_ifs++;
	}
    }
#endif

    nameArray    = __ARRAY_NEW_INT(n_ifs);
    addressArray = __ARRAY_NEW_INT(n_ifs);

    if (nameArray == nil || addressArray == nil) {
	/* Creating a string wouldn/t work here */
	error = @symbol(allocationFailure);
	goto bad;
    }

    /*
    ** Iterate of the list of the system's netif. Find all
    ** active interfaces and their ethernet addresses
    */

    countOfIf = 0;

    for (i=0, ifr = ifc.ifc_req; i < n_ifs; i++) {
	/*
	** Get Flags for this interface
	*/

# ifndef __osx__ // SIOCGIFFLAGS fails on osx (Q@sv: what is this needed for anyway?)
	{
	    struct ifreq ifreq;
	    memcpy(&ifreq, ifr, sizeof(ifreq));
	    if (ioctl (afinet_socket, SIOCGIFFLAGS, &ifreq) < 0) {
		if (@global(InfoPrinting) == true) {
		    fprintf(stderr, "OS [warning]: ioctl(SIOCGIFFLAGS) failed");
		}
	    }
	}
# endif
	{
# ifdef SIOCGIFHWADDR
	    /*
	    ** Get Hardware address for this interface
	    */
	    {
		struct ifreq ifreq;
		memcpy(&ifreq, ifr, sizeof(ifreq));
		if (ioctl (afinet_socket, SIOCGIFHWADDR, &ifreq) >= 0) {
		    t = __MKBYTEARRAY(&ifreq.ifr_hwaddr.sa_data, IFHWADDRLEN);
		    __arrayVal(addressArray)[countOfIf] = t; __STORE(addressArray, t);
		    t = __MKSTRING(&ifreq.ifr_name);
		    __arrayVal(nameArray)[countOfIf] = t; __STORE(nameArray, t);
		    countOfIf += 1;
		}
	    }

#else
	    // macosx has no SIOCGIFHWADDR
	    // printf("family: %d\n", ifr->ifr_addr.sa_family);
	    // printf("name: %s\n", ifr->ifr_name);

	    if (ifr->ifr_addr.sa_family == AF_LINK) {
		struct sockaddr_dl *sdl;
		char *adr;
		extern char *ether_ntoa();
		unsigned char mac[6];
		int a,b,c,d,e,f;

		sdl = (struct sockaddr_dl *)&(ifr->ifr_addr);
		adr = ether_ntoa(LLADDR(sdl));
		// printf("name: %s adr: %s\n", ifr->ifr_name, adr);
		sscanf(adr, "%x:%x:%x:%x:%x:%x", &a, &b, &c, &d, &e, &f);
		mac[0] = a;
		mac[1] = b;
		mac[2] = c;
		mac[3] = d;
		mac[4] = e;
		mac[5] = f;

		t = __MKBYTEARRAY(mac, 6);
		__arrayVal(addressArray)[countOfIf] = t; __STORE(addressArray, t);
		t = __MKSTRING(ifr->ifr_name);
		__arrayVal(nameArray)[countOfIf] = t; __STORE(nameArray, t);
		countOfIf += 1;
	    }
#endif
	}

	// see (sigh) comment above
#ifndef __osx__
	ifr++;
#else
	{
	    int sz = IFNAMSIZ + ifr->ifr_addr.sa_len;

	    ifr = (struct ifreq *)( ((char *)ifr)+sz );
	}
#endif
    }

    noOfIf = __mkSmallInteger(countOfIf);
bad:
    if (afinet_socket >= 0)
	close(afinet_socket);
#else
    error = @symbol(notSupported);
#endif /* SIOCGIFHWADDR */
%}.

    error notNil ifTrue:[
	self primitiveFailed:error.
	"return an empty dictionary if proceed from error"
	^  Dictionary new.
    ].

    "we prefer OrderedDictionary here, because we want to keep the
     order as defined in the OS."
    retDictionary := OrderedDictionary new:noOfIf.
    1 to:noOfIf do:[:cnt|
	|macAddress|

	macAddress := addressArray at:cnt.
	macAddress ~= #[0 0 0 0 0 0] ifTrue:[
	    retDictionary at:(nameArray at:cnt) put:macAddress.
	].
    ].

    ^ retDictionary

    "
      OperatingSystem getNetworkMACAddresses
    "
!

getNumberOfProcessors
    "answer the number of physical processors in the system"

%{ /* NOCONTEXT */

#ifdef _SC_NPROCESSORS_CONF
    RETURN(__mkSmallInteger(sysconf(_SC_NPROCESSORS_CONF)));
#endif
%}.

    self shouldImplement.

    "
      self getNumberOfProcessors
    "
!

getNumberOfProcessorsOnline
    "answer the number of physical processors which are online in the system"

%{ /* NOCONTEXT */

#ifdef _SC_NPROCESSORS_ONLN
    RETURN(__mkSmallInteger(sysconf(_SC_NPROCESSORS_ONLN)));
#endif
%}.

    self shouldImplement.

    "
      self getNumberOfProcessorsOnline
    "
!

getProcessId
    "return the (unix-)processId"

%{  /* NOCONTEXT */
    RETURN ( __mkSmallInteger(getpid()) );
%}
    "
     OperatingSystem getProcessId
    "
!

getSystemID
    "if supported by the OS, return the systemID;
     a unique per machine identification.
     WARNING:
	not all systems support this; on some, #unknown is returned."

%{  /* NOCONTEXT */
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
#elif defined(HAS_GETHOSTID)
    int runningId;
    OBJ arr;

    runningId = gethostid();
    arr = __BYTEARRAY_UNINITIALIZED_NEW_INT(4);
    *(int *)(__byteArrayVal(arr)) = runningId;
    RETURN (arr);

#elif defined(IRIX5)
    char idBuffer[MAXSYSIDSIZE];
    int retVal;
    OBJ arr;

    if ((retVal = syssgi(SGI_SYSID, idBuffer)) == 0) {
	arr = __BYTEARRAY_UNINITIALIZED_NEW_INT(MAXSYSIDSIZE);
	bcopy(idBuffer, __byteArrayVal(arr), MAXSYSIDSIZE);
	RETURN (arr);
    }
#endif
%}.
    ^ #unknown

    "
     OperatingSystem getSystemID
    "
!

getSystemInfo
    "return info on the system we are running on.
     If the system supports uname and sysinfo-like system calls, that info is returned;
     otherwise, some simulated info is returned.

     WARNING:
       Do not depend on the amount and contents of the returned information, some
       systems may return more/less than others. Also, the contents depends on the
       OS, for example, linux returns 'ix86', while WIN32 returns 'x86'.

       This method is mainly provided to augment error reports with some system
       information.
       (in case of system/version specific OS errors, conditional workarounds and patches
	may be based upon this info).
       Also, applications could enable/disable buffering or otherwise reduce
       their memory usage depending upon the amount of memory installed.
       Your application may make use of available information for tuning,
       but should NEVER DEPEND upon this in any way.

     The returned info may (or may not) contain:
	#system -> some operating system identification (irix, Linux, nt, win32s ...)
	#version -> OS version (some os version identification)
	#release -> OS release (3.5, 1.2.1 ...)
	#node   -> some host identification (hostname)
	#domain  -> domain name (hosts domain)
	#machine -> type of CPU (i586, mips ...)

     those are currently returned on some machines (no warranty)
     linux:
	#totalRam         -> total amount of memory available
	#sharedRam        -> amount of memory which is shared among processes
			     (i.e. shared code)
	#bufferRam        -> amount used for buffers
	#swapSize         -> total size of swap space
	#freeSwap         -> free amount in swapSpace
	#numberOfCPUs     -> number of cpus in box
	#extendedInstructions -> extended instruction set info

     osf:
	#physicalRam      -> total amount of physical memory
	#cpuType          -> type of cpu (more detailed than machine)
	#numberOfCPUs     -> number of cpus in box

     osx:
	#physicalRam      -> total amount of physical memory

     solaris:
	#physicalRam      -> total amount of physical memory
	#availableRam     -> total available amount of physical memory (i.e. unused ram)
	#freeRam          -> amount of free memory
	#numberOfCPUs     -> number of cpus in box (online CPUS)
	[#dCacheSize]     -> bytes in data cache (only available on some solaris versions)
	[#iCacheSize]     -> bytes in data cache (only available on some solaris versions)
	[#instructionSets]-> instruction sets available (only available on some solaris versions)
	[#platform]       -> platform name (only available on some solaris versions)

     hpux:
	#physicalRam      -> total amount of physical memory in box
	#activeRealMemory -> ? - read pstat documentation
	#activeVirtualRam -> ? - read pstat documentation
	#freeMemory       -> ? - read pstat documentation
	#realMemory       -> ? (amount of memory left to user programs)
	#virtualRam       -> ? - read pstat documentation
    "

    |sys node rel ver mach dom mtyp brel info arch cpuType cpuSpeed
     physicalRam availableRam totalRam sharedRam bufferRam swapSize freeSwap
     numberOfCPUs numberOfPhysicalCPUs pageSize physicalPages availablePages dCacheSize iCacheSize
     virtualRam activeVirtualRam realMemory activeRealMemory freeMemory
     instructionSets extendedInstructions platform|

%{  /* STACK: 4096 */
#if defined(linux) && defined(ELF)  /* old a.out unixes do not have this ... */
# include <sys/sysinfo.h>
    /*
     * additional info available ...
     */
    struct sysinfo infoBuffer;

    if (sysinfo(&infoBuffer) >= 0) {
	totalRam   = __MKUINT(infoBuffer.totalram);
	sharedRam = __MKUINT(infoBuffer.sharedram);
	bufferRam = __MKUINT(infoBuffer.bufferram);
	swapSize  = __MKUINT(infoBuffer.totalswap);
	freeSwap  = __MKUINT(infoBuffer.freeswap);
    }
#endif /* LINUX */

#if defined(hpux) && !defined(__GNUC__)
# include <sys/pstat.h>
    struct pst_static stat_buf;
    struct pst_dynamic dynam_buf;
    union pstun pstun_static;
    union pstun pstun_dynamic;

    pstun_static.pst_static = &stat_buf;
    pstun_dynamic.pst_dynamic = &dynam_buf;
    pstat(PSTAT_STATIC, pstun_static, (size_t)(sizeof(stat_buf)), (size_t)0, 0);
    pstat(PSTAT_DYNAMIC, pstun_dynamic, (size_t)(sizeof(dynam_buf)), (size_t)0, 0);

    physicalRam        = __MKUINT(stat_buf.physical_memory/256*1024*1024);
    virtualRam         = __MKUINT(dynam_buf.psd_vm/256*1024*1024);
    activeVirtualRam   = __MKUINT(dynam_buf.psd_avm/256*1024*1024);
    realMemory         = __MKUINT(dynam_buf.psd_rm/256*1024*1024);
    activeRealMemory   = __MKUINT(dynam_buf.psd_arm/256*1024*1024);
    freeMemory         = __MKUINT(dynam_buf.psd_free/256*1024*1024);
#endif

#if defined(HAS_UNAME)
    {
	struct utsname ubuff;

	if (uname(&ubuff) >= 0) {
	    sys  = __MKSTRING(ubuff.sysname);
	    node = __MKSTRING(ubuff.nodename);
	    rel  = __MKSTRING(ubuff.release);
	    ver  = __MKSTRING(ubuff.version);
	    mach = __MKSTRING(ubuff.machine);
# if defined(HAS_UTS_DOMAINNAME) || defined(_GNU_SOURCE)
	    dom  = __MKSTRING(ubuff.domainname);
# endif /* no HAS_UTS_DOMAINNAME */
	}
    }

#else /* no UNAME */

    /*
     * use fallBack code below
     */
#endif /* no UNAME */

#if defined(HAS_SYSINFO)
# if defined(SI_ARCHITECTURE)
    if (arch == nil) {
	char buffer[128];

	if (sysinfo(SI_ARCHITECTURE, buffer, sizeof(buffer))) {
	    arch = __MKSTRING(buffer);
	}
    }
# endif /* SI_ARCHITECTURE */

# if defined(SI_ISALIST)
    {
	char buffer[128];

	if (sysinfo(SI_ISALIST, buffer, sizeof(buffer))) {
	    instructionSets = __MKSTRING(buffer);
	}
    }
# endif /* SI_ISALIST */

# if defined(SI_PLATFORM)
    {
	char buffer[128];

	if (sysinfo(SI_PLATFORM, buffer, sizeof(buffer))) {
	    platform = __MKSTRING(buffer);
	}
    }
# endif /* SI_PLATFORM */

# if defined(SI_RELEASE)
    {
	char buffer[128];

	if (sysinfo(SI_RELEASE, buffer, sizeof(buffer))) {
	    rel = __MKSTRING(buffer);
	}
    }
# endif /* SI_RELEASE */
#endif /* HAS_SYSINFO */

#if defined(HAS_SYSCONF)
# ifdef _SC_NPROCESSORS_ONLN
    {
	long val;

	val = sysconf(_SC_NPROCESSORS_ONLN);
	if (val > 0) {
	    numberOfCPUs = __MKINT(val);
	}
    }
# endif
# ifdef _SC_NPROCESSORS_CONF
    {
	long val;

	val = sysconf(_SC_NPROCESSORS_CONF);
	if (val > 0) {
	    numberOfPhysicalCPUs = __MKINT(val);
	}
    }
# endif

# if defined(_SC_PAGESIZE)
    {
	long val;

	val = sysconf(_SC_PAGESIZE);
	if (val != -1) {
	    pageSize = __MKUINT(val);
	}
    }
# endif

# if defined(_SC_PHYS_PAGES)
    {
	long val;

	val = sysconf(_SC_PHYS_PAGES);
	if (val != -1) {
	    physicalPages = __MKUINT(val);
	}
    }
# endif

# if defined(_SC_AVPHYS_PAGES)
    {
	long val;

	val = sysconf(_SC_AVPHYS_PAGES);
	if (val != -1) {
	    availablePages = __MKUINT(val);
	}
    }
# endif

# if defined(_SC_ICACHE_SZ)
    {
	long val;

	val = sysconf(_SC_ICACHE_SZ);
	if (val != -1) {
	    iCacheSize = __MKUINT(val);
	}
    }
# endif

# if defined(_SC_DCACHE_SZ)
    {
	long val;

	val = sysconf(_SC_DCACHE_SZ);
	if (val != -1) {
	    dCacheSize = __MKUINT(val);
	}
    }
# endif
#endif /* HAS_SYSCONF */

#if defined(HAS_GETSYSINFO)
    {
	INT index;
	int retInt32 = 0;

# if defined(GSI_CPU)
	index = 0;
	if (getsysinfo(GSI_CPU, &retInt32, sizeof(retInt32), &index, NULL) > 0) {
	    switch (retInt32) {
#  ifdef VAX_780
		case VAX_780:
		    cpuType = __MKSTRING("VAX_780");
		    break;
#  endif
#  ifdef VAX_750
		case VAX_750:
		    cpuType = __MKSTRING("VAX_750");
		    break;
#  endif
#  ifdef VAX_730
		case VAX_730:
		    cpuType = __MKSTRING("VAX_730");
		    break;
#  endif
#  ifdef VAX_8600
		case VAX_8600:
		    cpuType = __MKSTRING("VAX_8600");
		    break;
#  endif
#  ifdef VAX_8200
		case VAX_8200:
		    cpuType = __MKSTRING("VAX_8200");
		    break;
#  endif
#  ifdef VAX_8800
		case VAX_8800:
		    cpuType = __MKSTRING("VAX_8800");
		    break;
#  endif
#  ifdef MVAX_I
		case MVAX_I:
		    cpuType = __MKSTRING("MVAX_I");
		    break;
#  endif
#  ifdef MVAX_II
		case MVAX_II:
		    cpuType = __MKSTRING("MVAX_II");
		    break;
#  endif
#  ifdef V_VAX
		case V_VAX:
		    cpuType = __MKSTRING("V_VAX");
		    break;
#  endif
#  ifdef VAX_3600
		case VAX_3600:
		    cpuType = __MKSTRING("VAX_3600");
		    break;
#  endif
#  ifdef VAX_6200
		case VAX_6200:
		    cpuType = __MKSTRING("VAX_6200");
		    break;
#  endif
#  ifdef VAX_3400
		case VAX_3400:
		    cpuType = __MKSTRING("VAX_3400");
		    break;
#  endif
#  ifdef C_VAXSTAR
		case C_VAXSTAR:
		    cpuType = __MKSTRING("C_VAXSTAR");
		    break;
#  endif
#  ifdef VAX_60
		case VAX_60:
		    cpuType = __MKSTRING("VAX_60");
		    break;
#  endif
#  ifdef VAX_3900
		case VAX_3900:
		    cpuType = __MKSTRING("VAX_3900");
		    break;
#  endif
#  ifdef DS_3100
		case DS_3100:
		    cpuType = __MKSTRING("DS_3100");
		    break;
#  endif
#  ifdef VAX_8820
		case VAX_8820:
		    cpuType = __MKSTRING("VAX_8820");
		    break;
#  endif
#  ifdef DS_5400
		case DS_5400:
		    cpuType = __MKSTRING("DS_5400");
		    break;
#  endif
#  ifdef DS_5800
		case DS_5800:
		    cpuType = __MKSTRING("DS_5800");
		    break;
#  endif
#  ifdef DS_5000
		case DS_5000:
		    cpuType = __MKSTRING("DS_5000");
		    break;
#  endif
#  ifdef DS_CMAX
		case DS_CMAX:
		    cpuType = __MKSTRING("DS_CMAX");
		    break;
#  endif
#  ifdef VAX_6400
		case VAX_6400:
		    cpuType = __MKSTRING("VAX_6400");
		    break;
#  endif
#  ifdef VAXSTAR
		case VAXSTAR:
		    cpuType = __MKSTRING("VAXSTAR");
		    break;
#  endif
#  ifdef DS_5500
		case DS_5500:
		    cpuType = __MKSTRING("DS_5500");
		    break;
#  endif
#  ifdef DS_5100
		case DS_5100:
		    cpuType = __MKSTRING("DS_5100");
		    break;
#  endif
#  ifdef VAX_9000
		case VAX_9000:
		    cpuType = __MKSTRING("VAX_9000");
		    break;
#  endif
#  ifdef DS_500_100
		case DS_500_100:
		    cpuType = __MKSTRING("DS_500_100");
		    break;
#  endif


#  ifdef ALPHA_ADU
		case ALPHA_ADU:
		    cpuType = __MKSTRING("ALPHA_ADU");
		    break;
#  endif
#  ifdef DEC_4000
		case DEC_4000:
		    cpuType = __MKSTRING("DEC_4000");
		    break;
#  endif
#  ifdef DEC_3000_500
		case DEC_3000_500:
		    cpuType = __MKSTRING("DEC_3000_500");
		    break;
#  endif
#  ifdef DEC_7000
		case DEC_7000:
		    cpuType = __MKSTRING("DEC_7000");
		    break;
#  endif
#  ifdef DS_5000_300
		case DS_5000_300:
		    cpuType = __MKSTRING("DS_5000_300");
		    break;
#  endif
#  ifdef DEC_3000_300
		case DEC_3000_300:
		    cpuType = __MKSTRING("DEC_3000_300");
		    break;
#  endif
#  ifdef DEC_2000_300
		case DEC_2000_300:
		    cpuType = __MKSTRING("DEC_2000_300");
		    break;
#  endif
#  ifdef DEC_2100_A500
		case DEC_2100_A500:
		    cpuType = __MKSTRING("DEC_2100_A500");
		    break;
#  endif
#  ifdef DEC_2100_A50
		case DEC_2100_A50:
		    cpuType = __MKSTRING("DEC_2100_A50");
		    break;
#  endif
#  ifdef ALPHA_KN20AA
		case ALPHA_KN20AA:
		    cpuType = __MKSTRING("ALPHA_KN20AA");
		    break;
#  endif
#  ifdef DEC_21000
		case DEC_21000:
		    cpuType = __MKSTRING("DEC_21000");
		    break;
#  endif
#  ifdef DEC_AXPVME_64
		case DEC_AXPVME_64:
		    cpuType = __MKSTRING("DEC_AXPVME_64");
		    break;
#  endif
#  ifdef DEC_2100_C500
		case DEC_2100_C500:
		    cpuType = __MKSTRING("DEC_2100_C500");
		    break;
#  endif
#  ifdef DEC_AXPPCI_33
		case DEC_AXPPCI_33:
		    cpuType = __MKSTRING("DEC_AXPPCI_33");
		    break;
#  endif
#  ifdef DEC_1000
		case DEC_1000:
		    cpuType = __MKSTRING("DEC_1000");
		    break;
#  endif
#  ifdef EB64_PLUS
		case EB64_PLUS:
		    cpuType = __MKSTRING("EB64_PLUS");
		    break;
#  endif
#  ifdef LCA_EB66
		case LCA_EB66:
		    cpuType = __MKSTRING("LCA_EB66");
		    break;
#  endif
#  ifdef ALPHA_EB164
		case ALPHA_EB164:
		    cpuType = __MKSTRING("ALPHA_EB164");
		    break;
#  endif
#  ifdef DEC_EV45_PBP
		case DEC_EV45_PBP:
		    cpuType = __MKSTRING("DEC_EV45_PBP");
		    break;
#  endif
#  ifdef DEC_1000A
		case DEC_1000A:
		    cpuType = __MKSTRING("DEC_1000A");
		    break;
#  endif
#  ifdef DEC_4100
		case DEC_4100:
		    cpuType = __MKSTRING("DEC_4100");
		    break;
#  endif
#  ifdef DEC_ALPHAVME_224
		case DEC_ALPHAVME_224:
		    cpuType = __MKSTRING("DEC_ALPHAVME_224");
		    break;
#  endif
#  ifdef DEC_1000_5
		case DEC_1000_5:
		    cpuType = __MKSTRING("DEC_1000_5");
		    break;
#  endif
#  ifdef DEC_1000A_5
		case DEC_1000A_5:
		    cpuType = __MKSTRING("DEC_1000A_5");
		    break;
#  endif
#  ifdef DEC_EV56_PBP
		case DEC_EV56_PBP:
		    cpuType = __MKSTRING("DEC_EV56_PBP");
		    break;
#  endif
#  ifdef ALPHABOOK
		case ALPHABOOK:
		    cpuType = __MKSTRING("ALPHABOOK");
		    break;
#  endif
#  ifdef DEC_ALPHAVME_320
		case DEC_ALPHAVME_320:
		    cpuType = __MKSTRING("DEC_ALPHAVME_320");
		    break;
#  endif
#  ifdef DEC_550
		case DEC_550:
		    cpuType = __MKSTRING("DEC_550");
		    break;
#  endif
#  ifdef DEC_6600
		case DEC_6600:
		    cpuType = __MKSTRING("DEC_6600");
		    break;
#  endif
#  ifdef UNKN_SYSTEM
		case UNKN_SYSTEM:
		    cpuType = __MKSTRING("UNKN_SYSTEM");
		    break;
#  endif
		default:
		    cpuType = __MKSTRING("OTHER_DEC_SYSTEM");
		    break;
	    }
	}
# endif /* GSI_CPU */

# if defined(GSI_CPU_INFO)
	/*
	 * stupid: OSF1 pre V4.0 has no mhz, but V4.0 has it.
	 * use the GSI_PLATFORM_NAME as a hint - it is only defined in
	 * V4.0 and higher ... (sigh)
	 */
#  if defined(GSI_PLATFORM_NAME)
	{
	    struct cpu_info cpuInfo;

	    index = 0;
	    if (getsysinfo(GSI_CPU_INFO, &cpuInfo, sizeof(cpuInfo), &index, NULL) > 0) {
		cpuSpeed   = __MKUINT(cpuInfo.mhz);
	    }
	}
#  endif
# endif /* GSI_CPU_INFO */

# if defined(GSI_CPUS_IN_BOX)
	index = 0;
	if (getsysinfo(GSI_CPUS_IN_BOX, &retInt32, sizeof(retInt32), &index, NULL) > 0) {
	    numberOfCPUs   = __MKUINT(retInt32);
	}
# endif /* GSI_CPUS_IN_BOX */

# if defined(GSI_PHYSMEM)
	index = 0;
	if (getsysinfo(GSI_PHYSMEM, &retInt32, sizeof(retInt32), &index, NULL) > 0) {
	    INT bytes = retInt32 * 1024;

	    physicalRam   = __MKUINT(bytes);
	}
# endif /* GSI_PHYSMEM */

# if defined(GSI_PLATFORM_NAME) && (!defined(HAS_SYSINFO) || !defined(SI_PLATFORM))
    {
	char buffer[128];

	index = 0;
	if (getsysinfo(GSI_PLATFORM_NAME, buffer, sizeof(buffer), &index, NULL) > 0) {
	    platform = __MKSTRING(buffer);
	}
    }
# endif /* GSI_PLATFORM_NAME */

    }
#endif /* HAS_GETSYSINFO */

#if defined(HAS_SYSCTL) /* __osx__ */
    int mib[3];
    long _physmem;
    size_t _len;

    mib[0] = CTL_HW;
    mib[1] = HW_MEMSIZE;
    _len = sizeof(_physmem);
    sysctl(mib, 2, &_physmem, &_len, NULL, 0);
    physicalRam   = __MKUINT(_physmem);
#endif /* __osx__ */

#if defined(__x86_64__)
    cpuType = __MKSTRING("x86_64");
#endif


    {
	extern OBJ __getInstructionSetInfo();

	extendedInstructions = __getInstructionSetInfo();
    }
%}.
    sys isNil ifTrue:[
	sys := self getSystemType.
    ].
    node isNil ifTrue:[
	node := self getHostName.
    ].
    dom isNil ifTrue:[
	dom := self getDomainName.
    ].
    mach isNil ifTrue:[
	mach := self getCPUType.
    ].
    arch isNil ifTrue:[
	arch := sys.
    ].

    info := IdentityDictionary new.
    info at:#system put:sys.
    info at:#node put:node.
    rel notNil ifTrue:[info at:#release put:rel].
    ver notNil ifTrue:[info at:#version put:ver].
    mach notNil ifTrue:[info at:#machine put:mach].
    arch notNil ifTrue:[info at:#architecture put:arch].
    dom notNil ifTrue:[info at:#domain put:dom].
    (pageSize notNil and:[physicalPages notNil]) ifTrue:[
	physicalRam := pageSize * physicalPages. "/ done here - could be largeInt.
    ].
    physicalRam notNil ifTrue:[info at:#physicalRam put:physicalRam].
    (pageSize notNil and:[availablePages notNil]) ifTrue:[
	availableRam := pageSize * availablePages. "/ done here - could be largeInt.
	availableRam notNil ifTrue:[info at:#availableRam put:availableRam].
    ].
    totalRam notNil ifTrue:[info at:#totalRam put:totalRam].
    sharedRam notNil ifTrue:[info at:#sharedRam put:sharedRam].
    bufferRam notNil ifTrue:[info at:#bufferRam put:bufferRam].
    virtualRam notNil ifTrue:[info at:#virtualRam put:virtualRam].
    activeVirtualRam notNil ifTrue:[info at:#activeVirtualRam put:activeVirtualRam].
    realMemory notNil ifTrue:[info at:#realMemory put:realMemory].
    activeRealMemory notNil ifTrue:[info at:#activeRealMemory put:activeRealMemory].
    freeMemory notNil ifTrue:[info at:#freeMemory put:freeMemory].
    swapSize notNil ifTrue:[info at:#swapSize put:swapSize].
    freeSwap notNil ifTrue:[info at:#freeSwap put:freeSwap].
    numberOfCPUs notNil ifTrue:[info at:#numberOfCPUs put:numberOfCPUs].
    numberOfPhysicalCPUs notNil ifTrue:[info at:#numberOfPhysicalCPUs put:numberOfPhysicalCPUs].
    cpuType notNil ifTrue:[info at:#cpuType put:cpuType].
    cpuSpeed notNil ifTrue:[info at:#cpuSpeed put:cpuSpeed].
    dCacheSize notNil ifTrue:[info at:#dCacheSize put:dCacheSize].
    iCacheSize notNil ifTrue:[info at:#iCacheSize put:iCacheSize].
    instructionSets notNil ifTrue:[info at:#instructionSets put:instructionSets].
    extendedInstructions notNil ifTrue:[info at:#extendedInstructions put:(extendedInstructions asOrderedCollection select:[:e | e notNil])].
    platform notNil ifTrue:[info at:#platform put:platform].
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
     Don't depend on this - use getOSType. I don't really see a point
     here ...
     (except for slight differences between next/mach and other machs)"

    |sys|

%{
#   ifdef NEXT
#    define SYS_SYMBOL @symbol(next)
#   endif

#   ifdef IRIS
#    define SYS_SYMBOL @symbol(iris)
#   endif

#   ifdef SYS_SYMBOL
     sys = SYS_SYMBOL;
#    undef SYS_SYMBOL
#   endif

%}.
    sys isNil ifTrue:[
	^ self getOSType
    ].
    ^ sys

    "
     OperatingSystem getSystemType
    "
!

getThreadId
    "return the threadId of the currently executing thread,
     or nil on systems which use a single OS thread"

    ^ nil
    "
     OperatingSystem getThreadId
    "
!

isBSDlike
    "return true, if the OS we're running on is a 'real' unix."

%{  /* NOCONTEXT */

#if defined(BSD) || defined(MACH) || defined(SYSV4)
    RETURN ( true );
#endif
%}.
    ^ false

    "
     OperatingSystem isBSDlike
    "
!

isLinuxLike
    "return true, if the OS we're running on is a linux."


%{  /* NOCONTEXT */

#if defined(LINUX)
    RETURN ( true );
#endif
%}.
    ^ false

    "
     OperatingSystem isLinuxLike
    "
!

isOSXlike
    "return true, if the OS we're running on is a mac OSX unix (not A/UX or OS9)."

%{  /* NOCONTEXT */

#if defined(__osx__)
    RETURN ( true );
#endif
%}.
    ^ false

    "
     OperatingSystem isOSXlike
    "
!

isProcessIdPresent:pid
    "answer true, if a process with process id pid is present, false if not"

%{
    if (__isSmallInteger(pid)) {
	/* in UNIX, a kill(pid, 0) is a noop used to check if a pid exists */
	if (kill(__smallIntegerVal(pid), 0) < 0 && errno != EPERM) {
	    RETURN ( false );
	}
	RETURN ( true );
    }
%}.

    ^ self primitiveFailed:#invalidParameter


    "
      self isProcessIdPresent:self getProcessId
      self isProcessIdPresent:1
      self isProcessIdPresent:4711
    "
!

isUNIXlike
    "return true, if the OS we're running on is a unix like."

    ^ true

    "
     OperatingSystem isUNIXlike
    "
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
     * TODO: new systems provide a query function for this ... use it
     */
#   if defined(MAXFILENAMELEN)
      RETURN ( __mkSmallInteger(MAXFILENAMELEN) );
#   else
#    if defined(BSD) || defined(SYSV4) || defined(LONGFILENAMES)
      RETURN ( __mkSmallInteger(255) );
#    endif

#    ifdef realIX
       RETURN ( __mkSmallInteger(127) );
#    endif

#    ifdef SYSV
       RETURN ( __mkSmallInteger(14) );
#    endif
#   endif
%}.
    "unix default"

    ^ 14

    "
     OperatingSystem maxFileNameLength
    "
!

maxNumberOfOpenFiles

%{
     long l;

     l = sysconf(_SC_OPEN_MAX);
     if (l >= 0) {
	 RETURN(__mkSmallInteger(l));
     }
%}.
     self primitiveFailed

     "
      self maxNumberOfOpenFiles
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

pathSeparator
    "return the character which separates items in the PATH variable"

    ^ $:

    "Created: / 2.5.1997 / 11:36:47 / cg"
    "Modified: / 5.6.1998 / 18:41:01 / cg"
!

primGetDomainName
    "return the domain this host is in.
     Notice:
	not all systems support this; on some, nil is returned."

%{  /* STACK: 2048 */
#if defined(HAS_GETDOMAINNAME)
    char buffer[256];

    if (getdomainname(buffer, sizeof(buffer)) == 0) {
	RETURN (__MKSTRING(buffer));
    }
#else
# if defined(HAS_UNAME) && defined(HAS_UTS_DOMAINNAME)
    struct utsname ubuff;

    if (uname(&ubuff) >= 0) {
	RETURN (__MKSTRING(ubuff.domainname));
    }
# else
#  if defined(HAS_SYSINFO) && defined(SI_SRPC_DOMAIN)
    char buffer[256];
    int ret;

    if ((ret = sysinfo(SI_SRPC_DOMAIN, buffer, sizeof(buffer))) >= 0 && ret <= sizeof(buffer)) {
	RETURN (__MKSTRING(buffer));
    }
#  endif
# endif
#endif
%}.
    ^ nil

    "
     OperatingSystem primGetDomainName
    "

    "Modified: 26.4.1996 / 10:04:54 / stefan"
!

primGetHostName
    "return the hostname we are running on - if there is
     a HOST environment variable, we are much faster here ...
     Notice:
	not all systems support this; on some, nil is returned."

%{  /* STACK: 100000 */

    /* sigh - with libc.so.6, gethostname needs huge amounts of stack
     * actually this is linux specific, but should not hurt others
     */
#if defined(HAS_GETHOSTNAME)
    char buffer[256];

    if (gethostname(buffer, sizeof(buffer)) == 0) {
	RETURN (__MKSTRING(buffer));
    }
#else
# if defined(HAS_UNAME)
    struct utsname ubuff;

    if (uname(&ubuff) >= 0) {
	RETURN (__MKSTRING(ubuff.nodename));
    }
# else
#  if defined(HAS_SYSINFO) && defined(SI_HOSTNAME)
    char buffer[256];
    int ret;

    if ((ret = sysinfo(SI_HOSTNAME, buffer, sizeof(buffer))) >= 0 && ret <= sizeof(buffer)) {
	RETURN (__MKSTRING(buffer));
    }
#  endif
# endif
#endif
%}.
    ^ nil

    "
     OperatingSystem getHostName
    "
!

randomBytesInto:bufferOrInteger
    "If bufferOrInteger is a String or a ByteArray,
	fill a given buffer with random bytes from the RtlGenRandom function
	and answer the buffer.

     If bufferOrInteger is a SmallInteger,
	return this many bytes (max 4) as a SmallInteger.

     Return nil on error (may raise PrimitiveFailure, too).

     NOTE: This is a private interface, please use RandomGenerator!!"

%{
#ifdef LINUX
# include <linux/random.h>
# include <sys/syscall.h>
# if defined(GRND_RANDOM) && defined(GRND_NONBLOCK) && defined(SYS_getrandom)
    // getrandom(2) is upported starting with linux 3.17

    int wanted, cnt, gotSoFar = 0;
    char *buffer;

    if (__isSmallInteger(bufferOrInteger) 
        && ((wanted = __smallIntegerVal(bufferOrInteger)) <= sizeof(INT))) {
        INT buf = 0;

	do {
            cnt = syscall(SYS_getrandom, &buf + gotSoFar, wanted - gotSoFar, 0);
            if (cnt < 0) {
                // this should not happen, since getrandom <= 256 bytes
                // is guaranteed not to interrupt when fetching from zhe urandom pool
                if (errno != EINTR && errno != EAGAIN)
                    goto error;
            } else {
                gotSoFar = gotSoFar + cnt;
            }
        } while (gotSoFar < wanted);
        RETURN(__mkSmallInteger(buf & _MAX_INT));
    } else if (__isByteArray(bufferOrInteger)) {
	wanted = __byteArraySize(bufferOrInteger);
	buffer = __byteArrayVal(bufferOrInteger);
    } else if (__isString(bufferOrInteger)) {
	wanted = __stringSize(bufferOrInteger);
	buffer = __stringVal(bufferOrInteger);
    } else
	goto error;

    do {
        cnt = syscall(SYS_getrandom, buffer + gotSoFar, wanted - gotSoFar, 0);
	if (cnt < 0) {
	    if (errno != EINTR && errno != EAGAIN)
		goto error;
            buffer = __isByteArray(bufferOrInteger) ?
                        __byteArrayVal(bufferOrInteger) : __stringVal(bufferOrInteger);
	} else {
	    gotSoFar = gotSoFar + cnt;
	}
    } while (gotSoFar < wanted);
    RETURN(bufferOrInteger);

# endif // linux
#endif  // GRND_RANDOM
error: ;
%}.

    ^ self primitiveFailed.

    "
	self randomBytesInto:1.
	self randomBytesInto:2.
	self randomBytesInto:4.
	self randomBytesInto:8.
	self randomBytesInto:(ByteArray new:16).
	self randomBytesInto:(String new:16).
    "
!

setEnvironment:aKeyStringOrSymbol to:aString
    "put a string to the environment.
     If aString isNil, the variable will be removed from the environment.
     Currently there is some malloced memory lost each time a variable is put to the environment.
     We could use ExternalBytes and keep the references in a Dictionary to free the
     memory on change or delete"

%{  /* NOCONTEXT */

    char *env;
    int valueSize;

    if (__isStringLike(aKeyStringOrSymbol)) {
	if (aString == nil) {
	    /* env used only temporary for deregistration */
	    valueSize = 0;
	    env = __stringVal(aKeyStringOrSymbol);
	} else if (__isStringLike(aString)) {
	    /* have to use stable memory for env */
	    valueSize = __stringSize(aString);
	    env = (char *)malloc(__stringSize(aKeyStringOrSymbol) + valueSize + 2);
	    if (env == 0)
		goto err;
	    strcpy(env, __stringVal(aKeyStringOrSymbol));
	    strcat(env, "=");
	    strncat(env, __stringVal(aString), valueSize);
	} else
	    goto err;

	if (putenv(env) == 0) {
	    RETURN(self);
	}

	if (valueSize > 0) {
	    /* could not register, free */
	    free(env);
	}
err:;
    }
%}.
    ^ self primitiveFailed

    "
     OperatingSystem setEnvironment:#TEST to:'abc'.
     OperatingSystem getEnvironment:#TEST.
     OperatingSystem executeCommand:'echo $TEST' outputTo:Transcript.

     OperatingSystem setEnvironment:#TEST to:nil.
     OperatingSystem setEnvironment:#TEST to:''.

     OperatingSystem setEnvironment:#LD_LIBRARY_PATH to:'/opt/oracle/instantclient10_1'.
    "
!

setLocale:categorySymbol to:localeStringOrNil
    "set (and get) the locale for categorySymbol (e.g. #LC_ALL, #LC_CTYPE,....).
     If localeStringOrNil is nil, nothing is set.
     If localeStringOrNil is empty, the locale for categorySymbol ist set from the environment.
     If localeStringOrNil is 'C', the locale for categorySymbol ist set to the default.
     If localeStringOrNil is to a locale name, the locale for categorySymbol ist set.
     The current locale setting is returned."

    |locale error|

%{
    int __category;
    char *__locale, *ret;

    if (categorySymbol == @symbol(LC_ALL)) {
	__category = LC_ALL;
    } else if (categorySymbol == @symbol(LC_COLLATE)) {
	__category = LC_COLLATE;
    } else if (categorySymbol == @symbol(LC_CTYPE)) {
	__category = LC_CTYPE;
    } else if (categorySymbol == @symbol(LC_MESSAGES)) {
	__category = LC_MESSAGES;
    } else if (categorySymbol == @symbol(LC_MONETARY)) {
	__category = LC_MONETARY;
    } else if (categorySymbol == @symbol(LC_NUMERIC)) {
	__category = LC_NUMERIC;
    } else if (categorySymbol == @symbol(LC_TIME)) {
	__category = LC_TIME;
    } else {
	error = @symbol(argument1);
	goto out;
    }

    if (localeStringOrNil == nil) {
	__locale = 0;
    } else if (__isStringLike(localeStringOrNil)){
	__locale = __stringVal(localeStringOrNil);
    } else {
	error = @symbol(argument1);
	goto out;
    }

    ret = setlocale(__category, __locale);
    if (ret) {
	locale = __MKSTRING(ret);
    }

out:;
%}.
    locale notNil ifTrue:[
	^ locale.
    ].
    ^ self primitiveFailed:error.

    "
     OperatingSystem setLocale:#LC_ALL to:nil
     OperatingSystem setLocale:#LC_CTYPE to:nil
     OperatingSystem setLocale:#LC_CTYPE to:'C'
     OperatingSystem setLocale:#LC_CTYPE to:''
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

supportsFileLinks
    "return true, if the OS supports file links (hard links).
     Typically, only unix returns true here."

    ^ true

    "Modified: / 5.6.1998 / 18:35:01 / cg"
!

supportsIOInterrupts
    "return true, if the OS supports IO availability interrupts
     (i.e. SIGPOLL/SIGIO).

     Currently, this mechanism does not work on all
     systems ...
    "

%{  /* NOCONTEXT */

  /* positive defines here
   *  - irix5.2 does not work
   */
#if defined(LINUX)

# if defined(SIGIO) || defined(SIGPOLL)
#  if defined(F_GETFL) && defined(F_SETFL) && defined(FASYNC)
#   if defined(F_SETOWN) || defined(FIOSETOWN)

    RETURN (true);

#   endif
#  endif
# endif

#endif /* machines where it works */
%}.
    ^ false

    "
     OperatingSystem supportsIOInterrupts
    "

!

supportsNonBlockingIO
    "return true, if the OS supports nonblocking IO."

%{  /* NOCONTEXT */
#if defined(F_GETFL) && defined(F_SETFL)
# if defined(O_NONBLOCK) || defined(O_NDELAY) || defined(FNDELAY)
       RETURN (true);
# endif
#endif
%}.
    ^ false

    "
     OperatingSystem supportsNonBlockingIO
    "
!

supportsSymbolicLinks
    "return true, if the OS supports symbolic (soft) links;
     most UNIX'es do; many other OS's do not."

%{  /* NOCONTEXT */

#ifdef S_IFLNK
    /*
     * assume yes - if that is defined.
     */
    RETURN(true);
#endif
%}.
    ^ false

    "
     OperatingSystem supportsSymbolicLinks
    "

!

supportsTTYs
    "Return true if OS supports PTYs / TTYs. UNIX do, other 
     OSes usually don't"

    ^ true

    "Created: / 31-05-2017 / 10:37:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnixOperatingSystem class methodsFor:'path queries'!

decodePathOrCommandOutput:encodedPathNameOrOutputLine
    "decode the encodedPathNameOrOutputLine as returned by system calls or output by system commands.
     This takes care for any specific OS encodings or specific command encodings.

     E.g. linux system calls return single byte strings only,
     so pathNames and command output comes UTF-8 encoded.
     (actually, on a mac, it comes utf8-mac encoded)."

    Codeset notNil ifTrue:[
	encodedPathNameOrOutputLine notNil ifTrue:[
	    [
		"/ cg: I am not sure, why this shortcut.
		"/ calling the decoder directly should be much faster
		Codeset == #utf8 ifTrue:[
		    ^ encodedPathNameOrOutputLine utf8Decoded.
		].
		"/ Codeset encoder might not yet be initialized, sigh...
		CodesetEncoder isNil ifTrue:[
		    self getCodesetEncoder
		].
		CodesetEncoder notNil ifTrue:[
		    ^ CodesetEncoder decodeString: encodedPathNameOrOutputLine
		].
	    ] on:DecodingError do:[:ex|
		"maybe there are old filenames in ISO-8859-x,
		 just keep them untranslated"
	    ].
	].
    ].
    ^ encodedPathNameOrOutputLine

    "Modified: / 23-01-2013 / 10:02:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultSystemPath
    "add additional directories to the systemPath
     (but only, if the major version is the same)"

    |places sysPath majorVersionNr minorVersionNr releaseFile vsnDirName s v|

    majorVersionNr := Smalltalk majorVersionNr.
    minorVersionNr := Smalltalk minorVersionNr.
    vsnDirName := '%1.%2' bindWith:majorVersionNr with:minorVersionNr.

    sysPath := super defaultSystemPath.
    places :=
	#(
	    '/usr/local/lib/stx'
	    '/usr/local/lib/smalltalk'
	    '/usr/local/lib/smalltalk-x'
	    '/usr/lib/stx'
	    '/usr/lib/smalltalk'
	    '/usr/lib/smalltalk-x'
	    '/lib/stx'
	    '/lib/smalltalk'
	    '/lib/smalltalk-x'
	    '/opt/stx'
	    '/opt/smalltalk'
	    '/opt/smalltalk-x'
	).

    self isOSXlike ifTrue:[
	|pathOfSTX|

	 places :=
		{
		    '/Library/Smalltalk' .
		    '/Library/Smalltalk-x' .
		    '~/Library/Smalltalk' .
		    '~/Library/Smalltalk-x' .
		} , places.

	pathOfSTX := OperatingSystem pathOfSTXExecutable.
	pathOfSTX notNil ifTrue:[
	    places :=
		{
		    (pathOfSTX asFilename / '../Packages') name .
		    (pathOfSTX asFilename / '../../Packages') name .
		} , places.
	]
    ].
    places do:[:dirName |
	|dir vsnDir|

	dir := dirName asFilename.
	(dir isDirectory) ifTrue:[
	    "/ try to guess a gnu-smalltalk; skip it
	    (dir construct:'initialize.st') exists ifFalse:[
		vsnDir := dir / vsnDirName.
		vsnDir exists ifTrue:[
		    "/ new style: look for a major.minor directory there
		    sysPath add:vsnDir.
		] ifFalse:[
		    "/ old style: look for a RELEASE file there and check if it matches
		    releaseFile := dir construct:'RELEASE'.
		    releaseFile exists ifTrue:[
			s := releaseFile readStreamOrNil.
			s notNil ifTrue:[
			    v := Integer readFrom:s onError:-1.
			    s close.
			    v == majorVersionNr ifTrue:[
				sysPath add:dirName
			    ] ifFalse:[
				('UnixOperatingSystem [info]: ignore files in ' , dir pathName , ' (RELEASE mismatch)') infoPrintCR.
			    ]
			] ifFalse:[
			    ('UnixOperatingSystem [info]: ignore files in ' , dir pathName , ' (RELEASE missing)') infoPrintCR.
			]
		    ]
		]
	    ]
	]
    ].
    ^ sysPath

    "
     OperatingSystem defaultSystemPath
    "
!

encodePath:pathName
    "encode the pathName for use with system calls.
     E.g. linux system calls accept single byte strings only,
     so the pathName has been UTF-8 encoded, before using it in a system call
     (actually, on a mac, it has to be utf8-mac encoded)."

    Codeset notNil ifTrue:[
	pathName notNil ifTrue:[
	    [
		"/ cg: I am not sure, why this shortcut.
		"/ calling the encoder directly should be much faster
		Codeset == #utf8 ifTrue:[
		    ^ pathName utf8Encoded
		].
		"/ Codeset encoder might not yet be initialized, sigh...
		CodesetEncoder isNil ifTrue:[
		    self getCodesetEncoder
		].
		CodesetEncoder notNil ifTrue:[
		    ^ CodesetEncoder encodeString: pathName.
		].
	    ] on:EncodingError do:[:ex|
		"maybe there are old filenames in ISO-8859-x,
		 just keep them untranslated"
	    ].
	].
    ].
    ^ pathName

    "
     Codeset := #'utf8-mac'.
     CodesetEncoder := nil.
     OperatingSystem getCodesetEncoder
     OperatingSystem encodePath:''
    "

    "Modified: / 23-01-2013 / 10:00:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnixOperatingSystem class methodsFor:'private'!

mountPointsFromProcFS
    "return a collection of mountPoints (aka. topDirectories of mounted file systems)"

    |entries|

    entries := OrderedCollection new.
    ('/proc/mounts' asFilename) readingLinesDo:[:eachLine |
	|items mountInfo|

	items := eachLine asCollectionOfWords.
	mountInfo := (MountInfo new
	    mountPointPath:(items at:2)
	    deviceOrRemotePath:(items at:1)
	    fsType:(items at:3)
	    attributeString:(items at:4)).
	entries add:mountInfo
    ].
    ^ entries

    "
     OperatingSystem mountPointsFromProcFS
    "
!

osProcessStatusClass
    ^ OSProcessStatus

    "Created: / 12.6.1998 / 16:30:43 / cg"
! !

!UnixOperatingSystem class methodsFor:'shared memory access'!

shmAttach:id address:addr flags:flags
    "low level entry to shmat()-system call.
     Not supported on all operatingSystems"

%{  /* NOCONTEXT */
#ifdef WANT_SHM
    void *address, *shmaddr;
    int shmflg, shmid;

    if (__isSmallInteger(addr)
     && __bothSmallInteger(flags, id)) {
	shmaddr = (void *) __intVal(addr);
	shmflg = __intVal(flags);
	shmid = __intVal(id);

	address = shmat(shmid, shmaddr, shmflg);
	if (address != (void *)-1) {
	    RETURN (__MKEXTERNALBYTES(addr));
	}
	@global(LastErrorNumber) = __mkSmallInteger(errno);
	RETURN (nil);
    }
#endif
%}.
    ^ self primitiveFailed

    "Modified: 22.4.1996 / 13:15:12 / cg"
!

shmDetach:addr
    "low level entry to shmdt()-system call.
     Not supported on all operatingSystems"

%{  /* NOCONTEXT */
#ifdef WANT_SHM
    void *shmaddr;
    int rslt;

    if (__isSmallInteger(addr)) {
	shmaddr = (void *) __intVal(addr);

	rslt = shmdt(shmaddr);
	if (rslt != -1) {
	    RETURN (true);
	}
	@global(LastErrorNumber) = __mkSmallInteger(errno);
	RETURN (false);
    }
#endif
%}.
    ^ self primitiveFailed

    "Modified: 22.4.1996 / 13:15:03 / cg"
!

shmGet:key size:size flags:flags
    "low level entry to shmget()-system call.
     This is not for public use and not supported with all operatingSystems.
     - use the provided wrapper class SharedExternalBytes instead."

%{  /* NOCONTEXT */
#ifdef WANT_SHM
    if (__bothSmallInteger(key, size)
     && __isSmallInteger(flags)) {
	int rslt;

	rslt = shmget(__intVal(key), __intVal(size), __intVal(flags));
	if (rslt != -1) {
	    RETURN (__mkSmallInteger(rslt));
	}
	@global(LastErrorNumber) = __mkSmallInteger(errno);
	RETURN (nil);
    }
#endif
%}.
    ^ self primitiveFailed

    "Modified: 22.4.1996 / 13:14:46 / cg"
! !

!UnixOperatingSystem class methodsFor:'socket creation'!

socketAccessor
    ^ SocketHandle
!

socketWithDomain:domainArg type:typeArg protocol:protocolArg
    "set up socket with domain, type and protocol number.
     This is a low level entry; no binding, listening or connect
     is done. Both arguments must be symbols from one of
     #inet,#unix, #appletalk, #x25 .. and #stream, #datagram, #raw resp."

    ^ SocketHandle new domain:domainArg type:typeArg protocol:protocolArg
! !

!UnixOperatingSystem class methodsFor:'time and date'!

computeOSTimeFromYear:y month:m day:d hour:h minute:min second:s millisecond:millis utc:utcBoolean
    "return the OS-dependent time for the given time and day.
     If utcBoolean is true, the arguments are assumed to be in UTC;
     otherwise, in localtime including any daylight saving adjustings."

    |osSeconds|

%{
    struct tm tm;
#ifdef HAS_MKTIME64
#   define TIME_T time64_t
#else
#   define TIME_T time_t
#endif
    TIME_T t;

    if (__bothSmallInteger(y, m)
     && __bothSmallInteger(d, h)
     && __bothSmallInteger(min, s)) {
	tm.tm_hour = __intVal(h);
	tm.tm_min = __intVal(min);
	tm.tm_sec = __intVal(s);

	tm.tm_year = __intVal(y) - 1900;
	tm.tm_mon = __intVal(m) - 1;
	tm.tm_mday = __intVal(d);
	tm.tm_isdst = -1;

#if __POINTER_SIZE__ < 8 && !defined(HAS_MKTIME64)
	if (__intVal(y) > 2038) goto outOfRange;
	if (__intVal(y) == 2038) {
	    if (__intVal(m) > 1) goto outOfRange;
	    if (__intVal(d) > 19) goto outOfRange;
	    if (__intVal(d) == 19) {
		if (__intVal(h) > 3) goto outOfRange;
		if (__intVal(h) == 3) {
		    if (__intVal(min) > 14) goto outOfRange;
		    if (__intVal(min) == 14) {
			if (__intVal(s) > 7) goto outOfRange;
		    }
		}
	    }
	}
#endif

#ifdef HAS_TIMEGM
	if (utcBoolean == true) {               /* convert to utc time */
# ifdef HAS_MKTIME64
	    t = timegm64(&tm);                  /* timegm() interprets tm as utc time */
# else
	    t = timegm(&tm);                    /* timegm() interprets tm as utc time */
# endif
	} else
#endif
	{
#ifdef HAS_MKTIME64
	    t = mktime64(&tm);                  /* mktime() interprets tm as localtime */
#else
	    t = mktime(&tm);                    /* mktime() interprets tm as localtime */
#endif
	}
	if (t != (TIME_T)-1) {
#ifndef HAS_TIMEGM
	    if (utcBoolean == true) {           /* convert to utc time */
		// printf("tz=%d\n", TIMEZONE(&tm));
		t = t - TIMEZONE(&tm);          /* TIMZONE = seconds westward from 0 */
	    }
#endif
#ifdef HAS_MKTIME64
	    osSeconds = __MKLARGEINT64(1, (t & 0xFFFFFFFF), (t>>32)& 0xFFFFFFFF);
#else
	    /* be careful, t can be negative at the start of the epoch ! */
	    osSeconds = __MKINT((INT)t);
#endif
	}
    }
  outOfRange: ;
%}.
    osSeconds notNil ifTrue:[
	^ osSeconds * 1000 + millis
    ].
    ^ TimeConversionError raiseRequest.

    "
     OperatingSystem computeOSTimeFromYear:1970 month:1 day:1 hour:0 minute:0 second:0 millisecond:0 utc:true
     OperatingSystem computeOSTimeFromYear:1970 month:1 day:1 hour:0 minute:0 second:0 millisecond:0 utc:false
     OperatingSystem computeOSTimeFromYear:2080 month:1 day:1 hour:0 minute:0 second:0 millisecond:0 utc:false
    "
!

epochStartOSTime
    "private interface for timestamp to ask the OS what the minimum time
     (in milliseconds since the Unix epoch, 1.1.1970) is.
     Unix systems will return 0 here; other OS's may return a negative number to indicate,
     that they can deal with timestamps before 1970 (especially: win32 will do so).
     Notice that timestamp is prepared to compensate for any OS limitation by computing the timeInfo
     components itself.
     So it is usually (except for a little performance) no problem to return a range too small here."

    ^ -16r80000000 * 1000
!

getMicrosecondTime
    "This returns the microsecond timers value - if available.
     On some machines, times with this precision may not be available,
     on those, the returned value may be rounded towards some internal
     clock resolution value."

    |seconds micros error|

%{
#ifdef __SCHTEAM__
    {
	long nanos = java.lang.System.nanoTime();

	return context._RETURN( STInteger._new(nanos / 1000) );
    }
    /* NOTREACHED */
#else
    unsigned long _secs, _micros;

# if defined(_POSIX_MONOTONIC_CLOCK) && defined(CLOCK_MONOTONIC) && !defined(NO_CLOCK_GETTIME)
    struct timespec ts;
    static int has_clock_gettime = 1;

    if (has_clock_gettime) {
	if (clock_gettime(CLOCK_MONOTONIC, &ts) != -1) {
	    _secs = ts.tv_sec;
	    _micros  = ts.tv_nsec / 1000;
	    goto out;
	} else {
	    /*
	     * clock_gettime is not implemented in the kernel
	     * fall through to alternative implementation
	     */
	    has_clock_gettime = 0;
	}
    }
# endif

# if defined(HAS_GETTIMEOFDAY)
    struct timeval tb;

    gettimeofday(&tb, NULL /* &tzb */);
    if (tb.tv_usec >= (1000000)) {
	error = @symbol(bad);
	goto err;
    }

    _secs = tb.tv_sec;
    _micros  = tb.tv_usec;
# endif

out:

# if __POINTER_SIZE__ == 8
    {
	unsigned INT rslt;

	rslt = (unsigned INT)_secs * 1000000 + _micros;
	RETURN (__MKUINT(rslt));
    }
# else
#  ifdef HAS_LONGLONG
    {
	unsigned long long rslt;

	rslt = (unsigned long long)_secs * 1000000 + _micros;
	RETURN (__MKLARGEINT64(1, (unsigned INT)(rslt & 0xFFFFFFFF), (unsigned INT)(rslt >> 32)));
    }
#  else
    seconds = __MKUINT(_secs);
    micros = __MKUINT(_micros);
#  endif /* long long */
# endif /* __POINTER_SIZE__ == 8 */
err:;
#endif /* not SCHTEAM */
%}.

    seconds notNil ifTrue:[
	^ (seconds * 1000000) + micros
    ].
    error isNil ifTrue:[
	^ self getMillisecondTime * 1000
    ].
    self primitiveFailed:error.

    "
     Transcript showCR:(OperatingSystem getMicrosecondTime).
     Transcript showCR:(OperatingSystem getMicrosecondTime).
    "
!

getMillisecondTime
    "Return the millisecond timers value.
     The range is limited to 0..1fffffff (i.e. the SmallInteger range) to avoid
     LargeInteger arithmetic when doing timeouts and delays.
     Since this value is wrapping around in regular intervals, this can only be used for
     short relative time deltas.
     Use the XXXmillisecondTime:-methods to compare and add time deltas - these know about the wrap.

     BAD DESIGN:
	This should be changed to return some instance of RelativeTime,
	and these computations moved there.

     Don't use this method in application code since it is an internal (private)
     interface. For compatibility with ST-80, use Time millisecondClockValue.
    "

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
	long millis = java.lang.System.currentTimeMillis();
	return context._RETURN( STInteger._new(millis) );
    }
    /* NOTREACHED */
#else
    unsigned INT t = 0;

# if defined(_POSIX_MONOTONIC_CLOCK) && defined(CLOCK_MONOTONIC) && !defined(NO_CLOCK_GETTIME)
    static int has_clock_gettime = 1;
    struct timespec ts;

    if (has_clock_gettime) {
	if (clock_gettime(CLOCK_MONOTONIC, &ts) != -1) {
	    t = ts.tv_sec*1000 + ts.tv_nsec/1000000;
	    goto out;
	} else {
	    /*
	     * clock_gettime is not implemented in the kernel
	     * fall through to alternative implementation
	     */
	    has_clock_gettime = 0;
	}
    }
# endif /*  _POSIX_MONOTONIC_CLOCK */

# if defined(_SC_CLK_TCK)
/*
 * We prefer times here, since it is monotonic and immune to clock changes
 * but: it has less precision!
 */
#  include <sys/times.h>

    static int millisecondsPerTick;
    clock_t ticks;
    struct tms tb;

    if (!millisecondsPerTick) {
	int ticksPerSecond = sysconf(_SC_CLK_TCK);
	if (ticksPerSecond <= 0)
	    goto err;
	if (ticksPerSecond > 1000)
	    goto err;
	millisecondsPerTick = 1000 / ticksPerSecond;
/*
printf("milliSecondsPerTick: %d\n", millisecondsPerTick);
*/
    }

    ticks = times(&tb);
    if (ticks == -1)
	goto err;

    t = ticks * millisecondsPerTick;

# else /* !times */

    /* assume HAS_GETTIMEOFDAY
     * - will result in a linkage error if not fixed.
     */

    struct timeval tb;

    gettimeofday(&tb, NULL);
    t = tb.tv_sec*1000 + tb.tv_usec/1000;
# endif

out:
    RETURN ( __mkSmallInteger(t & (_MAX_INT >> 1)) );

err:;
#endif /* not SCHTEAM */
%}.
    self primitiveFailed


    "
      self getMillisecondTime

      Transcript showCR:(OperatingSystem getMillisecondTime).
      Transcript showCR:(OperatingSystem getMillisecondTime).
    "
!

getOSTime
    "This returns the OS time.
     The base of the returned value is not consistent across
     different OS's - some return the number of millis since jan, 1st 1970;
     others since 1900. The Time classes are prepared for this, and
     converts as appropriate (by using my fromOSTime: conversion methods).

     Don't use this method in application code since it is an internal (private)
     interface. For compatibility with ST-80, use Time>>millisecondClockValue.
     or use instances of Time, Date or Timestamp to work with."


    |seconds millis|

%{
#ifdef __SCHTEAM__
    {
	long millisSince1970 = java.lang.System.currentTimeMillis();
	return context._RETURN( STInteger._new(millisSince1970));
    }
    /* NOTREACHED */
#else

    unsigned long _secs, _millis;
# if !defined(HAS_GETTIMEOFDAY)
#  if defined(HAS_FTIME)
    {
	struct timeb timebuffer;

	ftime(&timebuffer);
	_secs = timebuffer.time;
	_millis = timebuffer.millitm;
    }
#    define HAVE_TIME
#  endif /* HAS_FTIME */
# endif /* no HAS_GETTIMEOFDAY */

# ifndef HAVE_TIME
    /*
     * use HAS_GETTIMEOFDAY even if HAS_GETTIMEOFDAY is undefined here.
     * Will result in a linkage error if not fixed and neither ftime() nor time() is used.
     */

    {
	/*
	 * bsd time
	 */
	struct timeval tb;
	/* struct timezone tzb; */

	gettimeofday(&tb, NULL /* &tzb */);

	_secs = tb.tv_sec;
	_millis = tb.tv_usec / 1000;
    }
# endif

# if __POINTER_SIZE__ == 8
    {
	unsigned INT rslt;

	rslt = (unsigned INT)_secs * 1000 + _millis;
	RETURN (__MKUINT(rslt));
    }
# else
#  ifdef HAS_LONGLONG
    {
	unsigned long long rslt;

	rslt = (unsigned long long)_secs * 1000 + _millis;
	RETURN (__MKLARGEINT64(1, (unsigned INT)(rslt & 0xFFFFFFFF), (unsigned INT)(rslt >> 32)));
    }
#  else
    seconds = __MKUINT(_secs);
    millis = __MKUINT(_millis);
#  endif /* long long */
# endif /* __POINTER_SIZE__ == 8 */
#endif /* SCHTEAM */
%}.
    seconds notNil ifTrue:[
	^ (seconds * 1000) + millis
    ].

    self primitiveFailed.


    "
     OperatingSystem getOSTime printCR.
     Delay waitForSeconds:0.2.
     OperatingSystem getOSTime printCR.
    "
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
#ifdef HAS_USLEEP
    INT secs, usecs;

    secs = __intVal(uLow);
    usecs = __intVal(uHigh);
    if (secs > 0) {
	sleep(secs);
    }
    usleep(usecs);
    RETURN (true);
#else
    struct timeval tv;
    fd_set dummy;
    int success;

    int s = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
    FD_ZERO(&dummy);
    FD_SET(s, &dummy);
    tv.tv_sec = __intVal(uLow);
    tv.tv_usec = __intVal(uHigh);
    success = (0 == select(0, 0, 0, &dummy, &tv));
    close(s);
    RETURN (success ? true : false);
#endif
%}

    "
     Timestamp now printCR.
     OperatingSystem microsecondSleep:100.
     Timestamp now printCR.
    "

    "Created: / 28-05-2015 / 14:14:53 / gg"
!

sleep:numberOfSeconds
    "{ Pragma: +optSpace }"

    "cease ANY action for some time. This suspends the whole smalltalk
     (unix-) process for some time if running threadless;
     if running with threads (which is the default), this will
     only block until the next clock tick and return with the next
     timer interrupt.
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

timeInfoFromSeconds:osSeconds milliseconds:osMilliseconds localTime:isLocalTime
    "return a timeInfo structure containing values for the given
     OS-second value.
     An internal helper"

    |year month day hours minutes seconds utcOffset dstOffset
     dst yDay wDay info|

%{
#ifdef __SCHTEAM__
    if (osSeconds.isSmallInteger()
     && osMilliseconds.isSmallInteger()) {
	long _seconds = osSeconds.longValue();
	long _millis = osMilliseconds.longValue();
	long _millisSinceEpoch = _seconds * 1000 + _millis;
	java.util.TimeZone _tz;
	java.util.Calendar _calendar;
	int _wDay;

	if (isLocalTime == STObject.True) {
	    _tz = java.util.TimeZone.getDefault();
	} else {
	    _tz = java.util.TimeZone.getTimeZone("UTC");
	}
	_calendar = java.util.Calendar.getInstance(_tz);
	_calendar.setTimeInMillis(_millisSinceEpoch);

	year = STInteger._new( _calendar.get(java.util.Calendar.YEAR) );
	month = STInteger._new( _calendar.get(java.util.Calendar.MONTH) + 1 );
	day = STInteger._new( _calendar.get(java.util.Calendar.DAY_OF_MONTH) );
	hours = STInteger._new( _calendar.get(java.util.Calendar.HOUR_OF_DAY) );
	minutes = STInteger._new( _calendar.get(java.util.Calendar.MINUTE) );
	seconds = STInteger._new( _calendar.get(java.util.Calendar.SECOND) );
	yDay = STInteger._new( _calendar.get(java.util.Calendar.DAY_OF_YEAR) );
	_wDay = _calendar.get(java.util.Calendar.DAY_OF_WEEK);
	// convert from 1=SUN, 2=MON,...
	// to 1=MON, 2=TUE,...
	_wDay = _wDay - 1; if (_wDay < 1) _wDay += 7;
	wDay = STInteger._new( _wDay );
	utcOffset = STInteger._new( (_calendar.get(java.util.Calendar.ZONE_OFFSET)) / 1000 );
	dstOffset = STInteger._new( (_calendar.get(java.util.Calendar.DST_OFFSET)) / 1000 );
    }
#else
    struct tm tmValue, *result;
    time_t tt = __signedLongIntVal(osSeconds);

    if (tt == 0 && !__isSmallInteger(osSeconds))
	goto out;             // __singedLongIntVal() returns 0 on failure

    /* try cache */
    {
	OBJ lastSeconds = @global(LastTimeInfoSeconds);

	if (__isInteger(lastSeconds)
	     && (__signedLongIntVal(lastSeconds) == tt)
	     && (@global(LastTimeInfoIsLocal) == isLocalTime)
	) {
	    OBJ lastTimeInfo = @global(LastTimeInfo);
	    if (lastTimeInfo != nil) {
		info = lastTimeInfo;
		goto out;
	    }
	}
    }

    result = (isLocalTime == true) ? localtime_r(&tt, &tmValue) :  gmtime_r(&tt, &tmValue);
    if (result != NULL) {
	hours = __mkSmallInteger(tmValue.tm_hour);
	minutes = __mkSmallInteger(tmValue.tm_min);
	seconds = __mkSmallInteger(tmValue.tm_sec);

	year = __mkSmallInteger(tmValue.tm_year + 1900);
	month = __mkSmallInteger(tmValue.tm_mon + 1);
	day = __mkSmallInteger(tmValue.tm_mday);

	yDay = __mkSmallInteger(tmValue.tm_yday+1);
	wDay = __mkSmallInteger(tmValue.tm_wday == 0 ? 7 : tmValue.tm_wday);
	utcOffset = __mkSmallInteger(TIMEZONE(&tmValue));
	dst = (tmValue.tm_isdst == 0 ? false : true);
    }
out:;
#endif
%}.
    info notNil ifTrue:[
	"there is a matching cached value"
	LastTimeInfoMilliseconds == osMilliseconds ifTrue:[
	    ^ info.
	].
	info := info copy.
	info milliseconds:osMilliseconds.
    ] ifFalse:[
	year isNil ifTrue:[
	    TimeConversionError raiseErrorString:' - out of range'.
	].
	dst isNil ifTrue:[
	    dst := (dstOffset ~= 0)
	].
	info := self timeInfoClass new.
	info
	    year:year
	    month:month
	    day:day
	    hours:hours
	    minutes:minutes
	    seconds:seconds
	    milliseconds:osMilliseconds
	    utcOffset:utcOffset
	    dst:dst
	    dayInYear:yDay
	    dayInWeek:wDay.
    ].

%{
    @global(LastTimeInfo) = info;                       __GSTORE(info);
    @global(LastTimeInfoSeconds) = osSeconds;           __GSTORE(osSeconds);
    @global(LastTimeInfoMilliseconds) = osMilliseconds; __GSTORE(osMilliseconds);
    @global(LastTimeInfoIsLocal) = isLocalTime;         __GSTORE(isLocalTime);
%}.

    ^ info

    "
     OperatingSystem timeInfoFromSeconds:3600 milliseconds:0 localTime:false
     OperatingSystem timeInfoFromSeconds:3600 milliseconds:0 localTime:true
     OperatingSystem timeInfoFromSeconds:7200 milliseconds:0 localTime:true

     OperatingSystem timeInfoFromSeconds:16r7FFFFFFF milliseconds:0 localTime:false
     OperatingSystem timeInfoFromSeconds:16r7FFFFFFF + 1 milliseconds:0 localTime:false
     OperatingSystem timeInfoFromSeconds:16r7FFFFFFFFFFFFFFFFFFFFFF milliseconds:0 localTime:false
     OperatingSystem timeInfoFromSeconds:0 milliseconds:0 localTime:true

    DST in MEZ in 1994:
      self assert:(Timestamp year:1994 month:7 day:1 hour:0 minute:0 second:0) timeInfo dst

     no DST in MEZ in 1970:
      self assert:(Timestamp year:1970 month:7 day:1 hour:0 minute:0 second:0) timeInfo dst not
    "
! !

!UnixOperatingSystem class methodsFor:'users & groups'!

getDesktopDirectory
    "{ Pragma: +optSpace }"
    "return the name of the user's desktop directory."

    |home desktop|

    home := self getHomeDirectory.
    desktop := home,'/Desktop'.
    desktop asFilename exists ifTrue:[^ desktop].
    ^ home.

    "
     OperatingSystem getDesktopDirectory
    "
!

getEffectiveGroupID
    "{ Pragma: +optSpace }"

    "return the current users (that's you) effective numeric group id.
     This is only different from getGroupID, if you have ST/X running
     as a setuid program (of which you should think about twice)."

%{  /* NOCONTEXT */
    int uid;

    uid = getegid();
    RETURN ( __mkSmallInteger(uid) );
%}

    "
     OperatingSystem getEffectiveGroupID
    "
!

getEffectiveUserID
    "{ Pragma: +optSpace }"

    "return the current users (that's you) effective numeric user id.
     This is only different from getUserID, if you have ST/X running
     as a setuid program (of which you should think about twice)."

%{  /* NOCONTEXT */
    int uid;

    uid = geteuid();
    RETURN ( __mkSmallInteger(uid) );
%}

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
    "return the current users (that's you) numeric group id"

    "{ Pragma: +optSpace }"


%{  /* NOCONTEXT */

    RETURN ( __mkSmallInteger(getgid()) );
%}.

    "
     OperatingSystem getGroupID
    "
!

getGroupNameFromID:aNumber
    "{ Pragma: +optSpace }"

    "return the group-name-string for a given numeric group-id"

%{  /* NOCONTEXT */
    struct group *g;

    if (__isSmallInteger(aNumber)) {
	g = getgrgid(__intVal(aNumber));
	if (g) {
	    RETURN ( __MKSTRING(g->gr_name) );
	}
    }
%}.
    ^ '???'

    "
     OperatingSystem getGroupNameFromID:0
     OperatingSystem getGroupNameFromID:10
    "
!

getHomeDirectory
    "return the name of the user's home directory (i.e. yours)"

    "{ Pragma: +optSpace }"

    |homeDir|

    homeDir := self getEnvironment:'HOME'.
    homeDir isNil ifTrue:[
	"/ mhmh - can only happen if started via some uncorrectly
	"/ initialized subprocess...
	'UnixOperatingSystem [warning]: cannot figure out home directory' errorPrintCR.
	homeDir := '/tmp'.
    ].
    ^ self decodePath:homeDir

    "
     OperatingSystem getHomeDirectory
    "

    "Modified: 24.1.1997 / 11:32:13 / cg"
!

getLoginName
    "{ Pragma: +optSpace }"

    "return a string with the users login name (that's yours)"

%{  /* NOCONTEXT */
    static char cachedName[128];
    static int firstCall = 1;
    extern char *getenv();
    extern char *getlogin();

    char *name = (char *)0;

    if (firstCall) {
	/*
	 * try a few common environment variables ...
	 */
	name = getenv("LOGNAME");
	if (! name || (name[0] == 0)) {
	    name = getlogin();
	    if (! name || (name[0] == 0) ) {
		name = getenv("LOGIN");
		if (! name || (name[0] == 0) ) {
		    name = getenv("USER");
		}
	    }
	}
	if (name && (strlen(name) < sizeof(cachedName))) {
	    strcpy(cachedName, name);
	    firstCall = 0;
	}
    } else {
	name = cachedName;
    }

    /*
     * nope - I really don't know who you are.
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
    "return the current users (that's you) numeric user id"

    "{ Pragma: +optSpace }"

%{  /* NOCONTEXT */

    RETURN ( __mkSmallInteger(getuid()) );
%}

    "
     OperatingSystem getUserID
    "
!

getUserNameFromID:aNumber
    "{ Pragma: +optSpace }"

    "return the user-name-string for a given numeric user-id.
     This is the login name, not the fullName."

%{  /* NOCONTEXT */

#ifndef NO_PWD
    struct passwd *p;

    if (__isSmallInteger(aNumber)) {
	p = getpwuid(__intVal(aNumber));
	if (p && p->pw_name && (strlen(p->pw_name) > 0)) {
	    RETURN ( __MKSTRING(p->pw_name) );
	}
    }
#endif /* unix-like */
%}.
    ^ super getUserNameFromID:aNumber

    "
     OperatingSystem getUserNameFromID:0
     OperatingSystem getUserNameFromID:100
     OperatingSystem getUserNameFromID:9991
     OperatingSystem getUserNameFromID:(OperatingSystem getUserID)
    "
!

isRunningWithElevatedRootOrAdminRights
    "return true, if a NORMAL user is running with elevated admin rights."

    ^ (self getEffectiveUserID == 0)
    and:[self getUserID ~~ 0 ]

    "
     self isRunningWithElevatedRootOrAdminRights
    "
!

isRunningWithRootOrAdminRights
    "return true, if running with root rights (either an elevated normal user
     or super user right away)."

    ^ self getEffectiveUserID == 0
!

primUserInfoOf:aNameOrID
    "return a dictionary filled with userinfo. The argument can be either
     a string with the users name or its numeric id.
     Notice, that not all systems provide (all of) this info;
     DOS systems return nothing;
     non-SYSV4 systems have no age/comment.
     Portable applications may want to check the systemType and NOT depend
     on all keys to be present in the returned dictionary.
     Another notice: on some systems (SYSV4), the gecos field includes multiple
     entries (i.e. not just the name), separated by commas. You may want to
     extract any substring, up to the first comma to get the real life name."


%{ /* UNLIMITEDSTACK */  /* Don't know whether NIS, LDAP or whatever is consulted */
#if !defined(NO_PWD)
    struct passwd *result = 0;
    int ret;
    int idx = 0;
    OBJ returnArray;
    OBJ tmp;

#if defined(_POSIX_SOURCE)
    char buf[4096];
    struct passwd pwd;

    if (__isStringLike(aNameOrID)) {
	getpwnam_r(__stringVal(aNameOrID), &pwd, buf, sizeof(buf), &result);
    } else if (__isSmallInteger(aNameOrID)) {
	getpwuid_r(__intVal(aNameOrID), &pwd, buf, sizeof(buf), &result);
    }
#else
    if (__isStringLike(aNameOrID)) {
	result = getpwnam(__stringVal(aNameOrID));
    } else if (__isSmallInteger(aNameOrID)) {
	result = getpwuid(__intVal(aNameOrID));
    }
#endif /* ! _POSIX_SOURCE */

    if (result) {
	returnArray = __ARRAY_NEW_INT(20);
	__PROTECT__(returnArray);
	tmp = __MKSTRING(result->pw_name);
	__UNPROTECT__(returnArray);
	__arrayVal(returnArray)[idx++] = @symbol(name);
	__arrayVal(returnArray)[idx++] = tmp; __STORE(returnArray, tmp);
#  ifndef NO_PWD_PASSWD
	__PROTECT__(returnArray);
	tmp = __MKSTRING(result->pw_passwd);
	__UNPROTECT__(returnArray);
	__arrayVal(returnArray)[idx++] = @symbol(passwd);
	__arrayVal(returnArray)[idx++] = tmp; __STORE(returnArray, tmp);
#  endif
#  ifdef SYSV4
	__PROTECT__(returnArray);
	tmp = __MKSTRING(result->pw_age);
	__UNPROTECT__(returnArray);
	__arrayVal(returnArray)[idx++] = @symbol(age);
	__arrayVal(returnArray)[idx++] = tmp; __STORE(returnArray, tmp);
	__PROTECT__(returnArray);
	tmp = __MKSTRING(result->pw_comment);
	__UNPROTECT__(returnArray);
	__arrayVal(returnArray)[idx++] = @symbol(comment);
	__arrayVal(returnArray)[idx++] = tmp; __STORE(returnArray, tmp);
#  endif
	__PROTECT__(returnArray);
	tmp = __MKSTRING(result->pw_dir);
	__UNPROTECT__(returnArray);
	__arrayVal(returnArray)[idx++] = @symbol(dir);
	__arrayVal(returnArray)[idx++] = tmp; __STORE(returnArray, tmp);
#  ifndef NO_PWD_GECOS
	__PROTECT__(returnArray);
	tmp = __MKSTRING(result->pw_gecos);
	__UNPROTECT__(returnArray);
	__arrayVal(returnArray)[idx++] = @symbol(gecos);
	__arrayVal(returnArray)[idx++] = tmp; __STORE(returnArray, tmp);
#  endif
	__PROTECT__(returnArray);
	tmp = __MKSTRING(result->pw_shell);
	 __UNPROTECT__(returnArray);
	__arrayVal(returnArray)[idx++] = @symbol(shell);
	__arrayVal(returnArray)[idx++] = tmp; __STORE(returnArray, tmp);

	__arrayVal(returnArray)[idx++] = @symbol(uid);
	__arrayVal(returnArray)[idx++] = __mkSmallInteger(result->pw_uid);

	__arrayVal(returnArray)[idx++] = @symbol(gid);
	__arrayVal(returnArray)[idx++] = __mkSmallInteger(result->pw_gid);
	RETURN(returnArray);
    }
# endif /* ! NO_PWD */
%}.
    ^ nil

    "
     OperatingSystem primUserInfoOf:'root'
     OperatingSystem primUserInfoOf:1
     OperatingSystem primUserInfoOf:'cg'
     OperatingSystem primUserInfoOf:'fooBar'
     OperatingSystem primUserInfoOf:(OperatingSystem getUserID)
    "
!

userInfoOf:aNameOrID
    "{ Pragma: +optSpace }"

    "return a dictionary filled with userinfo. The argument can be either
     a string with the users name or its numeric id.
     Notice, that not all systems provide (all of) this info;
     DOS systems return nothing;
     non-SYSV4 systems have no age/comment.
     Portable applications may want to check the systemType and NOT depend
     on all keys to be present in the returned dictionary.
     Another notice: on some systems (SYSV4), the gecos field includes multiple
     entries (i.e. not just the name), separated by commas. You may want to
     extract any substring, up to the first comma to get the real life name."

    |infoArray info name dir|

    infoArray := self primUserInfoOf:aNameOrID.
    info := IdentityDictionary new.

    infoArray notNil ifTrue:[
	infoArray pairWiseDo:[:key :value|
	    key notNil ifTrue:[
		info at:key put:value.
		key == #name ifTrue:[name := value].
		key == #dir  ifTrue:[dir := value].
	    ].
	].
    ].

    name isNil ifTrue:[
	info at:#name put:#unknown
    ].
    dir isNil ifTrue:[
	aNameOrID == self getUserID ifTrue:[
	    info at:#dir put:self getHomeDirectory
	]
    ].

    ^ info

    "
     OperatingSystem userInfoOf:'root'
     OperatingSystem userInfoOf:1
     OperatingSystem userInfoOf:'cg'
     OperatingSystem userInfoOf:'fooBar'
     OperatingSystem userInfoOf:(OperatingSystem getUserID)
    "
! !

!UnixOperatingSystem class methodsFor:'waiting for events'!

blockingChildProcessWait
    ^ self isChildProcessWaitBlocking
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
    int p;

#if defined(HAS_WAITPID)

    int s;
#   define __WAIT     waitpid(-1, &s, blocking == true ? WUNTRACED : WNOHANG|WUNTRACED)

#else
# if defined(HAS_WAIT3)

    WAIT_STATUS s;
#   define __WAIT      wait3(&s, blocking == true ? WUNTRACED : WNOHANG|WUNTRACED, 0)

# else /* neither waitpid, nor wait3; use wait, which is blocking */

    int s;
#   define __WAIT      wait(&s)
#   define __BLOCKING_WAIT__ 1

    if (blocking != true) {
	/*
	 * We do not support nonBlocking waits, so signal an error
	 * Sorry about the goto, but with all these ifdefs ...
	 */
	goto done;
    }
# endif /* !HAS_WAIT3 */
#endif  /* !HAS_WAITPID */

#if !defined(WIFEXITED)
# define WIFEXITED(stat)      (((int)((stat)&0377))==0)
# define WIFSIGNALED(stat)    (((int)((stat)&0377))>0&&((int)(((stat)>>8)&0377))==0)
# define WIFSTOPPED(stat)     (((int)((stat)&0377))==0177&&((int)(((stat)>>8)&0377))!=0)

# define WEXITSTATUS(stat)    ((int)(((stat)>>8)&0377))
# define WTERMSIG(stat)       (((int)((stat)&0377))&0177)
# define WSTOPSIG(stat)       ((int)(((stat)>>8)&0377))
#endif /*!WIFEXITED*/

#if !defined(WCOREDUMP)
   /*
    * some systems lack that definition, although the field is there ...
    */
# if defined(HAS_WAIT3)
#  define WCOREDUMP(status)    (((union __wait*)&(status))->__w_coredump)
# else
#  define WCOREDUMP(status)    ((int)(((status)>>8)&0200))
# endif
#endif /*!WCOREDUMP*/

#if __BLOCKING_WAIT__
    __BEGIN_INTERRUPTABLE__
#endif

    do {
	p = __WAIT;
    } while (p == -1 && errno == EINTR);

#if __BLOCKING_WAIT__
    __END_INTERRUPTABLE__
#  undef __BLOCKING_WAIT__
#endif

#undef __WAIT

    if (p == 0)
	RETURN(nil)

    if (p == -1) {
	if (errno == ECHILD)
	    RETURN(nil);
    } else {
	pid = __mkSmallInteger(p);
	if (WIFEXITED(s)) {
	    status = @symbol(exit);
	    code = __mkSmallInteger(WEXITSTATUS(s));
	    core = WCOREDUMP(s) ? true : false;
	} else if (WIFSIGNALED(s)) {
	    status = @symbol(signal);
	    code = __mkSmallInteger(WTERMSIG(s));
	} else if (WIFSTOPPED(s)) {
	    status = @symbol(stop);
	    code = __mkSmallInteger(WSTOPSIG(s));
	}
#if defined(WIFCONTINUED)
	else if (WIFCONTINUED(s)) {
	    status = @symbol(continue);
	}
#endif
    }
done: ;
%}.

    (status isNil or:[pid isNil]) ifTrue:[
	^ self primitiveFailed
    ].

"/ Transcript show:'pid: '; show:pid; show:' status: '; show:status;
"/ show:' code: '; show:code; show:' core:'; showCR:core.

    ^ OSProcessStatus pid:pid status:status code:code core:core

    "
     OperatingSystem childProcessWait:false
    "

    "Created: 5.1.1996 / 16:39:14 / stefan"
!

isBlockingOn:fd
    "{ Pragma: +optSpace }"

    "return the blocking attribute - if set (which is the default)
     a read on the fileDescriptor will block until data is available.
     If clear, a read operation will immediately return with a value nil.
     Also affects write operations, which may perform partial writes when
     blocking is off"

%{  /* NOCONTEXT */

    int flags;

#if defined(F_GETFL) && defined(F_SETFL)
# undef DELAY_FLAG
# if defined(O_NONBLOCK)
#  define DELAY_FLAG O_NONBLOCK
# elif defined(O_NDELAY)
#  define DELAY_FLAG O_NDELAY
# elif defined(FNDELAY)
#  define DELAY_FLAG FNDELAY
# endif
# if defined(DELAY_FLAG)
    if (__isSmallInteger(fd)) {
	int f = __intVal(fd);

	flags = fcntl(f, F_GETFL, 0);
	RETURN ((flags & DELAY_FLAG) ? false : true );
    }
#  undef DELAY_FLAG
# endif
#endif
%}.
    "
     fd argument not integer or bad return code
    "
    ^ self primitiveFailed
!

isChildProcessWaitBlocking
     "return true, if childProcessWait: blocks, if no children are ready.
      On those systems, we must be somewhat careful when looking out for
      a subprocesses status (to avoid blocking)."

%{ /*NOCONTEXT*/
#if defined(HAS_WAITPID) || defined(HAS_WAIT3)
    RETURN(false);
#else
    RETURN(true);
#endif
%}
!

numAvailableForReadOn:fd
    "return the number of bytes available for reading, without blocking."

%{
#if defined(FIONREAD)
    {
	int n = 0;

	if (__isSmallInteger(fd)) {
	    if (ioctl(__intVal(fd), FIONREAD, &n) >= 0) {
		RETURN (__MKINT(n));
	    }
	}
    }
#endif /* FIONREAD */
%}.
    ^ (self readCheck:fd) ifTrue:[1] ifFalse:[0]
!

readCheck:fd
    "return true, if data is available on a filedescriptor
     (i.e. read is possible without blocking).
     This depends on a working select or FIONREAD to be provided by the OS."

%{
#ifdef __SCHTEAM__
    {
	int avail = fd.streamAvailable();
	return __c__._RETURN (avail > 0 ? STObject.True : STObject.False);
    }
    /* NOTREACHED */
#else
    /*
     * if available, try FIONREAD first, which is usually done faster.
     */
# if 0 && defined(FIONREAD)
    if (__isSmallInteger(fd)) {
	int result = 0;

	if (ioctl(__smallIntegerVal(fd), FIONREAD, &result) >= 0) {
	    RETURN(result > 0 ? true : false);
	}
    }
# endif /* FIONREAD */
#endif
%}.

    ^ super readCheck:fd
!

selectOnAnyReadable:readFdArray writable:writeFdArray exception:exceptFdArray
	readableInto:readableResultFdArray writableInto:writableResultFdArray
	exceptionInto:exceptionResultFdArray
	withTimeOut:millis

    "wait for any fd in readFdArray (an Array of integers) to become ready for reading,
     writeFdArray to become ready for writing,
     or exceptFdArray to arrive exceptional data (i.e. out-of-band data).
     Timeout after t milliseconds or - if the timeout time is 0 - immediately.
     If the timeout is nil, not timeout will happen (but an interrupt may).
     Empty fd-sets will always wait. Zero time can be used to poll file-
     descriptors (i.e. to check if I/O possible without blocking).
     The corresponding filedescriptors which are ready are returned in readableResultFdArray,
     writableResultFdArray and exceptionResultFdArray respectively.
     The resultFdArrays can be the same arrays.

     Return the (overall) number of selected filedescriptors.
     readableResultFdArray, writableResultFdArray and exceptionResultFdArray will
     get a nil-value stored into the slot after the last valid fileDescriptor;
     Thus, the caller can simply scan these arrays upTo the end or a nil value."

%{
    fd_set rset, wset, eset;
    struct timeval wt, *wtp, et;
    int maxF;
    INT __millis;
    int ret;
    int cntR = 0, cntW = 0, cntE = 0, cntAll = 0;
    int *pcntR = &cntR, *pcntW = &cntW, *pcntE = &cntE;
    int resultSizeReadable = 0, resultSizeWritable = 0, resultSizeException = 0;
    int numFds = 0;

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

    FD_ZERO(&rset);
    FD_ZERO(&wset);
    FD_ZERO(&eset);

    maxF = -1;
    if (readFdArray != nil) {
	int i, count;

	if (! __isArrayLike(readFdArray)) {
	    goto fail;
	}
	count = __arraySize(readFdArray);

	for (i=0; i<count;i++) {
	    OBJ fd;

	    fd = __arrayVal(readFdArray)[i];
	    if (fd != nil) {
		if (! __isSmallInteger(fd)) {
		    if (@global(InfoPrinting) == true) {
			fprintf(stderr, "OS [warning]: funny read-fd (0x%lx) given to select\n", (unsigned long)fd);
		    }
		} else {
		    int f;

		    f = __intVal(fd);
		    if ((unsigned)f < FD_SETSIZE) {
			FD_SET(f, &rset);
			if (f > maxF) maxF = f;
			numFds++;
		    } else {
			if (@global(InfoPrinting) == true) {
			    fprintf(stderr, "OS [warning]: huge read-fd (0x%lx) given to select\n", (unsigned long)fd);
			}
		    }
		}
	    }
	}
    }

    if (writeFdArray != nil) {
	int i, count;

	if (! __isArrayLike(writeFdArray)) {
	    goto fail;
	}
	count = __arraySize(writeFdArray);
	for (i=0; i<count;i++) {
	    OBJ fd;

	    fd = __arrayVal(writeFdArray)[i];
	    if (fd != nil) {
		if (! __isSmallInteger(fd)) {
		    if (@global(InfoPrinting) == true) {
			fprintf(stderr, "OS [warning]: funny write-fd (0x%lx) given to select\n", (unsigned long)fd);
		    }
		} else {
		    int f;

		    f = __intVal(fd);
		    if ((unsigned)f < FD_SETSIZE) {
			FD_SET(f, &wset);
			if (f > maxF) maxF = f;
			numFds++;
		    } else {
			if (@global(InfoPrinting) == true) {
			    fprintf(stderr, "OS [warning]: huge write-fd (0x%lx) given to select\n", (unsigned long)fd);
			}
		    }
		}
	    }
	}
    }

    if (exceptFdArray != nil) {
	int i, count;

	if (! __isArrayLike(exceptFdArray)) {
	    goto fail;
	}
	count = __arraySize(exceptFdArray);
	for (i=0; i<count;i++) {
	    OBJ fd;

	    fd = __arrayVal(exceptFdArray)[i];
	    if (fd != nil) {
		if (! __isSmallInteger(fd)) {
		    if (@global(InfoPrinting) == true) {
			fprintf(stderr, "OS [warning]: funny except-fd (0x%lx) given to select\n", (unsigned long)fd);
		    }
		} else {
		    int f;

		    f = __intVal(fd);
		    if ((unsigned)f < FD_SETSIZE) {
			FD_SET(f, &eset);
			if (f > maxF) maxF = f;
			numFds++;
		    } else {
			if (@global(InfoPrinting) == true) {
			    fprintf(stderr, "OS [warning]: huge except-fd (0x%lx) given to select\n", (unsigned long)fd);
			}
		    }
		}
	    }
	}
    }

    if (millis == nil) {
	wtp = NULL;         // wait forever
    } else if (__isSmallInteger(millis)) {
	__millis = __intVal(millis);
	if (__millis > 0) {
	    wt.tv_sec = __millis / 1000;
	    wt.tv_usec = (__millis % 1000) * 1000;
	} else {
	    wt.tv_sec = wt.tv_usec = 0;
	}
	wtp = &wt;
    } else {
	goto fail;
    }

    /*
     * make certain, that interrupt gets us out of the select
     * However, we must then care for moved objects.
     */
    __BEGIN_INTERRUPTABLE__

    if (__millis == 0) {
	/*
	 * if there is no timeout time, we can stay here interruptable.
	 */
	do {
	    ret = select(maxF+1, &rset, &wset, &eset, wtp);
	} while ((ret < 0) && (errno == EINTR));
    } else {
	do {
	    ret = select(maxF+1, &rset, &wset, &eset, wtp);
	    /*
	     * for now: don't loop; if we did, we had to adjust the vt-timeval;
	     * could otherwise stay in this loop forever ...
	     * Premature ret (before the time expired) must be handled by the caller.
	     * A good solution is to update the wt-timeval and redo the select.
	     */
	} while (0 /* (ret < 0) && (errno == EINTR) */ );
    }
    __END_INTERRUPTABLE__

    if (ret > 0) {
	OBJ *__resultR = __arrayVal(readableResultFdArray);
	OBJ *__resultW = __arrayVal(writableResultFdArray);
	OBJ *__resultE = __arrayVal(exceptionResultFdArray);
	int i;

	for (i=0; i <= maxF; i++) {
	    if (FD_ISSET(i, &rset)) {
		if (*pcntR < resultSizeReadable) {
		    __resultR[*pcntR] = __mkSmallInteger(i);
		}
		(*pcntR)++; cntAll++;
	    }

	    if (FD_ISSET(i, &wset)) {
		if (*pcntW < resultSizeWritable) {
		    __resultW[*pcntW] = __mkSmallInteger(i);
		}
		(*pcntW)++; cntAll++;
	    }

	    if (FD_ISSET(i, &eset)) {
		if (*pcntE < resultSizeException) {
		    __resultE[*pcntE] = __mkSmallInteger(i);
		}
		(*pcntE)++;  cntAll++;
	    }
	}
	/* add a delimiter */
	if (*pcntR < resultSizeReadable) {
	    __resultR[*pcntR] = nil;
	}
	if (*pcntW < resultSizeWritable) {
	    __resultW[*pcntW] = nil;
	}
	if (*pcntE < resultSizeException) {
	    __resultE[*pcntE] = nil;
	}

	RETURN (__mkSmallInteger(cntAll));
    } else if (ret < 0 && errno != EINTR) {
	/*
	 * Error: Return -1
	 */
	if (@global(InfoPrinting) == true) {
	    fprintf(stderr, "OS [info]: select errno = %d\n", errno);
	}
	@global(LastErrorNumber) = __mkSmallInteger(errno);
	RETURN (__mkSmallInteger(-1));
    }

    /*
     * Return 0 (no filedescriptor ready)
     */
    @global(LastErrorNumber) = nil;
    RETURN (__mkSmallInteger(0));
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
    "{ Pragma: +optSpace }"

    "set/clear the blocking attribute - if set (which is the default)
     a read on the fileDescriptor will block until data is available.
     If cleared, a read operation will immediately return with a value of nil.
     Also affects write operations, which may perform partial writes when
     blocking is off.
     Return the previous blocking state."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    // TODO
    return context._RETURN(0);
#else

    int ret = 0, flags;

# if defined(F_GETFL) && defined(F_SETFL)
#  undef DELAY_FLAG
#  if defined(O_NONBLOCK)
#   define DELAY_FLAG O_NONBLOCK
#  elif defined(O_NDELAY)
#   define DELAY_FLAG O_NDELAY
#  elif defined(FNDELAY)
#   define DELAY_FLAG FNDELAY
#  endif
#  if defined(DELAY_FLAG)
    if (__isSmallInteger(fd)) {
	int f = __intVal(fd);

	flags = fcntl(f, F_GETFL, 0);
	if (aBoolean == true) {
	    ret = fcntl(f, F_SETFL, flags & ~DELAY_FLAG);
	} else if (aBoolean == false) {
	    ret = fcntl(f, F_SETFL, flags | DELAY_FLAG);
	}
	if (ret >= 0) {
	    RETURN ((flags & DELAY_FLAG) ? false : true );
	}
    }
#   undef DELAY_FLAG
#  endif
# endif
#endif /* not SCHTEAM */
%}.
    "
     fd argument not integer or bad return code
    "
    ^ self primitiveFailed
! !

!UnixOperatingSystem::ELFConstants class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

%{
#ifdef ELF
# define DEFCONST(c) __GLOBAL_SET(__MKSYMBOL("UnixOperatingSystem::ELFConstants:" #c, (OBJ *)0), __MKSMALLINT(c), (OBJ *)0);

    /* Fields in the e_ident array.  The EI_* macros are indices into the
       array.  The macros under each EI_* macro are the values the byte
       may have.  */

    DEFCONST(EI_MAG0)           /* File identification byte 0 index */
    DEFCONST(EI_MAG1)           /* File identification byte 1 index */
    DEFCONST(EI_MAG2)           /* File identification byte 2 index */
    DEFCONST(EI_MAG3)           /* File identification byte 3 index */

    DEFCONST(EI_CLASS)          /* File class byte index */
    DEFCONST(ELFCLASSNONE)      /* Invalid class */
    DEFCONST(ELFCLASS32)        /* 32-bit objects */
    DEFCONST(ELFCLASS64)        /* 64-bit objects */
    DEFCONST(ELFCLASSNUM)

    DEFCONST(EI_DATA)           /* Data encoding byte index */
    DEFCONST(ELFDATANONE)       /* Invalid data encoding */
    DEFCONST(ELFDATA2LSB)       /* 2's complement, little endian */
    DEFCONST(ELFDATA2MSB)       /* 2's complement, big endian */
    DEFCONST(ELFDATANUM)

    DEFCONST(EI_VERSION)        /* File version byte index */
				/* Value must be EV_CURRENT */

    DEFCONST(EI_OSABI)          /* OS ABI identification */
    DEFCONST(ELFOSABI_NONE)     /* UNIX System V ABI */
    DEFCONST(ELFOSABI_SYSV)     /* Alias.  */
    DEFCONST(ELFOSABI_HPUX)     /* HP-UX */
    DEFCONST(ELFOSABI_NETBSD)   /* NetBSD.  */
#ifdef ELFOSABI_GNU
    DEFCONST(ELFOSABI_GNU)      /* Object uses GNU ELF extensions.  */
#endif
    DEFCONST(ELFOSABI_LINUX)    /* Compatibility alias.  */
    DEFCONST(ELFOSABI_SOLARIS)  /* Sun Solaris.  */
    DEFCONST(ELFOSABI_AIX)      /* IBM AIX.  */
    DEFCONST(ELFOSABI_IRIX)     /* SGI Irix.  */
    DEFCONST(ELFOSABI_FREEBSD)  /* FreeBSD.  */
    DEFCONST(ELFOSABI_TRU64)    /* Compaq TRU64 UNIX.  */
    DEFCONST(ELFOSABI_MODESTO)  /* Novell Modesto.  */
    DEFCONST(ELFOSABI_OPENBSD)  /* OpenBSD.  */
#ifdef ELFOSABI_ARM_AEABI
    DEFCONST(ELFOSABI_ARM_AEABI)/* ARM EABI */
#endif
    DEFCONST(ELFOSABI_ARM)      /* ARM */
    DEFCONST(ELFOSABI_STANDALONE)/* Standalone (embedded) application */

    DEFCONST(EI_ABIVERSION)     /* ABI version */

    DEFCONST(EI_PAD)            /* Byte index of padding bytes */

    /* Legal values for e_type (object file type).  */

    DEFCONST(ET_NONE)           /* No file type */
    DEFCONST(ET_REL)            /* Relocatable file */
    DEFCONST(ET_EXEC)           /* Executable file */
    DEFCONST(ET_DYN)            /* Shared object file */
    DEFCONST(ET_CORE)           /* Core file */

    DEFCONST(ET_LOOS)           /* OS-specific range start */
    DEFCONST(ET_HIOS)           /* OS-specific range end */
    DEFCONST(ET_LOPROC)         /* Processor-specific range start */
    DEFCONST(ET_HIPROC)         /* Processor-specific range end */

    /* Legal values for e_machine (architecture).  */

    DEFCONST(EM_NONE)           /* No machine */
    DEFCONST(EM_M32)            /* AT&T WE 32100 */
    DEFCONST(EM_SPARC)          /* SUN SPARC */
    DEFCONST(EM_386)            /* Intel 80386 */
    DEFCONST(EM_68K)            /* Motorola m68k family */
    DEFCONST(EM_88K)            /* Motorola m88k family */
    DEFCONST(EM_860)            /* Intel 80860 */
    DEFCONST(EM_MIPS)           /* MIPS R3000 big-endian */
    DEFCONST(EM_S370)           /* IBM System/370 */
    DEFCONST(EM_MIPS_RS3_LE)    /* MIPS R3000 little-endian */

    DEFCONST(EM_PARISC)         /* HPPA */
    DEFCONST(EM_VPP500)         /* Fujitsu VPP500 */
    DEFCONST(EM_SPARC32PLUS)    /* Sun's "v8plus" */
    DEFCONST(EM_960)            /* Intel 80960 */
    DEFCONST(EM_PPC)            /* PowerPC */
    DEFCONST(EM_PPC64)          /* PowerPC 64-bit */
    DEFCONST(EM_S390)           /* IBM S390 */

    DEFCONST(EM_V800)           /* NEC V800 series */
    DEFCONST(EM_FR20)           /* Fujitsu FR20 */
    DEFCONST(EM_RH32)           /* TRW RH-32 */
    DEFCONST(EM_RCE)            /* Motorola RCE */
    DEFCONST(EM_ARM)            /* ARM */
    DEFCONST(EM_FAKE_ALPHA)     /* Digital Alpha */
    DEFCONST(EM_SH)             /* Hitachi SH */
    DEFCONST(EM_SPARCV9)        /* SPARC v9 64-bit */
    DEFCONST(EM_TRICORE)        /* Siemens Tricore */
    DEFCONST(EM_ARC)            /* Argonaut RISC Core */
    DEFCONST(EM_H8_300)         /* Hitachi H8/300 */
    DEFCONST(EM_H8_300H)        /* Hitachi H8/300H */
    DEFCONST(EM_H8S)            /* Hitachi H8S */
    DEFCONST(EM_H8_500)         /* Hitachi H8/500 */
    DEFCONST(EM_IA_64)          /* Intel Merced */
    DEFCONST(EM_MIPS_X)         /* Stanford MIPS-X */
    DEFCONST(EM_COLDFIRE)       /* Motorola Coldfire */
    DEFCONST(EM_68HC12)         /* Motorola M68HC12 */
    DEFCONST(EM_MMA)            /* Fujitsu MMA Multimedia Accelerator*/
    DEFCONST(EM_PCP)            /* Siemens PCP */
    DEFCONST(EM_NCPU)           /* Sony nCPU embeeded RISC */
    DEFCONST(EM_NDR1)           /* Denso NDR1 microprocessor */
    DEFCONST(EM_STARCORE)       /* Motorola Start*Core processor */
    DEFCONST(EM_ME16)           /* Toyota ME16 processor */
    DEFCONST(EM_ST100)          /* STMicroelectronic ST100 processor */
    DEFCONST(EM_TINYJ)          /* Advanced Logic Corp. Tinyj emb.fam*/
    DEFCONST(EM_X86_64)         /* AMD x86-64 architecture */
    DEFCONST(EM_PDSP)           /* Sony DSP Processor */

    DEFCONST(EM_FX66)           /* Siemens FX66 microcontroller */
    DEFCONST(EM_ST9PLUS)        /* STMicroelectronics ST9+ 8/16 mc */
    DEFCONST(EM_ST7)            /* STmicroelectronics ST7 8 bit mc */
    DEFCONST(EM_68HC16)         /* Motorola MC68HC16 microcontroller */
    DEFCONST(EM_68HC11)         /* Motorola MC68HC11 microcontroller */
    DEFCONST(EM_68HC08)         /* Motorola MC68HC08 microcontroller */
    DEFCONST(EM_68HC05)         /* Motorola MC68HC05 microcontroller */
    DEFCONST(EM_SVX)            /* Silicon Graphics SVx */
    DEFCONST(EM_ST19)           /* STMicroelectronics ST19 8 bit mc */
    DEFCONST(EM_VAX)            /* Digital VAX */
    DEFCONST(EM_CRIS)           /* Axis Communications 32-bit embedded processor */
    DEFCONST(EM_JAVELIN)        /* Infineon Technologies 32-bit embedded processor */
    DEFCONST(EM_FIREPATH)       /* Element 14 64-bit DSP Processor */
    DEFCONST(EM_ZSP)            /* LSI Logic 16-bit DSP Processor */
    DEFCONST(EM_MMIX)           /* Donald Knuth's educational 64-bit processor */
    DEFCONST(EM_HUANY)          /* Harvard University machine-independent object files */
    DEFCONST(EM_PRISM)          /* SiTera Prism */
    DEFCONST(EM_AVR)            /* Atmel AVR 8-bit microcontroller */
    DEFCONST(EM_FR30)           /* Fujitsu FR30 */
    DEFCONST(EM_D10V)           /* Mitsubishi D10V */
    DEFCONST(EM_D30V)           /* Mitsubishi D30V */
    DEFCONST(EM_V850)           /* NEC v850 */
    DEFCONST(EM_M32R)           /* Mitsubishi M32R */
    DEFCONST(EM_MN10300)        /* Matsushita MN10300 */
    DEFCONST(EM_MN10200)        /* Matsushita MN10200 */
    DEFCONST(EM_PJ)             /* picoJava */
    DEFCONST(EM_OPENRISC)       /* OpenRISC 32-bit embedded processor */
    DEFCONST(EM_ARC_A5)         /* ARC Cores Tangent-A5 */
    DEFCONST(EM_XTENSA)         /* Tensilica Xtensa Architecture */
#ifdef EM_AARCH64
    DEFCONST(EM_AARCH64)        /* ARM AARCH64 */
#endif
#ifdef EM_TILEPRO
    DEFCONST(EM_TILEPRO)        /* Tilera TILEPro */
#endif
#ifdef EM_MICROBLAZE
    DEFCONST(EM_MICROBLAZE)     /* Xilinx MicroBlaze */
#endif
#ifdef EM_TILEGX
    DEFCONST(EM_TILEGX)         /* Tilera TILE-Gx */
#endif

   /* If it is necessary to assign new unofficial EM_* values, please
      pick large random numbers (0x8523, 0xa7f2, etc.) to minimize the
      chances of collision with official or non-GNU unofficial values.  */

    DEFCONST(EM_ALPHA)

    /* Legal values for e_version (version).  */

    DEFCONST(EV_NONE)           /* Invalid ELF version */
    DEFCONST(EV_CURRENT)        /* Current version */

#undef DEFCONST
#endif /* ELF */
%}.
    ELFMAG0 := 16r7F.
    ELFMAG1 := $E codePoint.
    ELFMAG2 := $L codePoint.
    ELFMAG3 := $F codePoint.

    "Modified (comment): / 16-03-2015 / 15:15:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnixOperatingSystem::ELFFileHeader class methodsFor:'instance creation'!

fromFile: aStringOrFilename
    ^ self new initializeOnFile: aStringOrFilename

    "Created: / 16-03-2015 / 16:12:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnixOperatingSystem::ELFFileHeader methodsFor:'accessing'!

e_ident_class
    ^ data at: 1 + EI_CLASS

    "Created: / 17-03-2015 / 20:26:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

e_machine
    ^ data unsignedShortAt: 1 + 16r12 bigEndian: msb

    "Created: / 16-03-2015 / 16:29:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnixOperatingSystem::ELFFileHeader methodsFor:'initialization'!

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
	s binary.
	data := s next: 16r18.
	(data at: 1 + EI_MAG0) ~~ ELFMAG0 ifTrue:[
	    self error:'Given file is not a valid ELF file (magic not found)'.
	].
	(data at: 1 + EI_MAG1) ~~ ELFMAG1 ifTrue:[
	    self error:'Given file is not a valid ELF file (magic not found)'.
	].
	(data at: 1 + EI_MAG2) ~~ ELFMAG2 ifTrue:[
	    self error:'Given file is not a valid ELF file (magic not found)'.
	].
	(data at: 1 + EI_MAG3) ~~ ELFMAG3 ifTrue:[
	    self error:'Given file is not a valid ELF file (magic not found)'.
	].
	msb := (data at: 1 + EI_DATA) == ELFDATA2MSB
    ].

    "Created: / 16-03-2015 / 16:13:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnixOperatingSystem::ELFFileHeader methodsFor:'queries'!

isFor32BitArchitecture
    ^ self e_ident_class == ELFCLASS32

    "Created: / 17-03-2015 / 20:31:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFor64BitArchitecture
    ^ self e_ident_class == ELFCLASS64

    "Created: / 17-03-2015 / 20:31:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnixOperatingSystem::FileDescriptorHandle class methodsFor:'change & update'!

update:aspect with:argument from:anObject
    "one of our registered handles has been collected"

    aspect == #ElementExpired ifTrue:[
	OpenFiles keysAndValuesDo:[:fd :handle |
	    handle class == SmallInteger ifTrue:[
		"Have to close the file descriptor"

		OperatingSystem closeFd:fd.
		OpenFiles at:fd put:nil.
	    ].
	].
    ].

    "Created: 30.9.1997 / 12:57:35 / stefan"
! !

!UnixOperatingSystem::FileDescriptorHandle class methodsFor:'initialization'!

initialize
    OpenFiles := WeakArray new:10.
    OpenFiles addDependent:self.

    "
	self initialize
    "

    "Created: 26.9.1997 / 17:15:50 / stefan"
    "Modified: 30.9.1997 / 12:40:55 / stefan"
! !

!UnixOperatingSystem::FileDescriptorHandle class methodsFor:'instance creation'!

for:aFileDescriptor
    "create an instance of myself for a given fileDescriptor"

    ^ self new for:aFileDescriptor.

    "Created: 30.9.1997 / 14:00:00 / stefan"
! !

!UnixOperatingSystem::FileDescriptorHandle methodsFor:'error handling'!

error:anErrorSymbolOrErrno
    "got an error; arg is either a symbol specifying a primitive error
     or the error number as returned by the OperatingSystem"

    anErrorSymbolOrErrno isInteger ifTrue:[
	(UnixOperatingSystem errorHolderForNumber:anErrorSymbolOrErrno) reportError
    ].
    self primitiveFailed:anErrorSymbolOrErrno.
! !

!UnixOperatingSystem::FileDescriptorHandle methodsFor:'file access'!

close
    "close the descriptor"

    |desc|

    desc := fd.
    self invalidate.
    ^ OperatingSystem closeFd:desc.

    "Modified: 30.9.1997 / 13:06:55 / stefan"
! !

!UnixOperatingSystem::FileDescriptorHandle methodsFor:'initialization'!

for:aFileDescriptor
    "create a file for a handle"

    |oldHandle|

    fd := aFileDescriptor.

    "JV@2013-03-15: It may happen that OS returns a filedescriptor whose value
     is larger than twice the lenght of the weakarray. Care for this.
     Spotted by Martin Kobetic."
    oldHandle := OpenFiles at:aFileDescriptor ifAbsent: [nil].
    "/ the 0 is possible, if an fd was open when saving a snapshot image,
    "/ and we come up in the new image with no one referring to it.
    (oldHandle notNil and:[oldHandle class ~~ SmallInteger and:[ oldHandle ~~ self]]) ifTrue:[
	oldHandle invalidate.
    ].
    self register.

    "Created: 26.9.1997 / 17:14:40 / stefan"
    "Modified: 30.9.1997 / 12:41:43 / stefan"
    "Modified (comment): / 16-03-2013 / 00:04:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnixOperatingSystem::FileDescriptorHandle methodsFor:'input/output'!

readBytes:count into:aByteBuffer startingAt:firstIndex
    "read count bytes into a byte-buffer;
     Return the number of bytes read.
     The read is non-blocking. If the operation would block
     either an incomplete count or nil will be returned.

     An exception is raised on any other error"

    |error|

%{
    unsigned char *extPtr;
    int nRead = -1;
    INT fd;
    INT cnt, offs;
    int nInstBytes, objSize;

    if (! __isSmallInteger(__INST(fd))) {
	error = @symbol(errorNotOpen);
	goto bad;
    }
    if (! __bothSmallInteger(count, firstIndex)) {
	error = @symbol(badArgument);
	goto bad;
    }
    fd = __smallIntegerVal(__INST(fd));
    cnt = __smallIntegerVal(count);
    offs = __smallIntegerVal(firstIndex) - 1;

    if (fd < 0) {
	error = @symbol(internalError);
	goto bad;
    }
    if (__isExternalBytesLike(aByteBuffer)) {
	OBJ sz;

	nInstBytes = 0;
	extPtr = (char *)(__externalBytesAddress(aByteBuffer));
	if (extPtr == NULL) goto bad;
	sz = __externalBytesSize(aByteBuffer);
	if (__isSmallInteger(sz)) {
	    objSize = __smallIntegerVal(sz);
	} else {
	    objSize = -1; /* unknown */
	}
    } else {
	OBJ oClass = __Class(aByteBuffer);
	int nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);

	nInstBytes = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
	switch (__intVal(__ClassInstPtr(oClass)->c_flags) & ARRAYMASK) {
	    case BYTEARRAY:
	    case WORDARRAY:
	    case LONGARRAY:
	    case SWORDARRAY:
	    case SLONGARRAY:
	    case FLOATARRAY:
		break;
	    case DOUBLEARRAY:
#ifdef __NEED_DOUBLE_ALIGN
		nInstBytes = (nInstBytes-1+__DOUBLE_ALIGN) &~ (__DOUBLE_ALIGN-1);
#endif
		break;
	    case LONGLONGARRAY:
	    case SLONGLONGARRAY:
#ifdef __NEED_LONGLONG_ALIGN
		nInstBytes = (nInstBytes-1+__LONGLONG_ALIGN) &~ (__LONGLONG_ALIGN-1);
#endif
		break;
	    default:
		goto bad;
	}
	extPtr = (char *)0;
	objSize = __Size(aByteBuffer) - nInstBytes;
    }
    if ((offs >= 0)
	&& (cnt >= 0)
	&& ((objSize == -1) || (objSize >= (cnt + offs)))) {
	nRead = 0;

	do {
	    int n;

	    if (extPtr) {
		n = read(fd, extPtr+offs, cnt);
	    } else {
		char *bp;

		/*
		 * on interrupt, anObject may be moved to another location.
		 * So we recompute the byte-address here.
		 */
		bp = __byteArrayVal(aByteBuffer) + nInstBytes;

		n = read(fd, bp + offs, cnt);
	    }
	    if (n > 0) {
		cnt -= n;
		offs += n;
		nRead += n;
	    } else if (n == 0) {
		break;
	    } else if (n < 0) {
		if (0
#ifdef EWOULDBLOCK
		    || errno == EWOULDBLOCK
#endif
#ifdef EAGAIN
		    || errno == EAGAIN
#endif
		) {
		     RETURN(nil);
		}
		if (errno != EINTR) {
		     error = __mkSmallInteger(errno);
		     goto bad;
		}
		__HANDLE_INTERRUPTS__;
	    }
	} while (cnt > 0);

	RETURN (__mkSmallInteger(nRead));
    }
bad: ;
%}.
    ^ self error:error.

    "
     |h buff n|

     h := OperatingSystem openFileForRead:'/etc/hosts'.
     buff := ByteArray new:1000. buff inspect.
     n := h readBytes:1000 into:buff startingAt:1.
     Transcript show:n; space; showCR:buff asString.
    "

    "
     |h buff n|

     h := OperatingSystem openFileForRead:'/dev/cua0'.
     buff := ByteArray new:1000. buff inspect.
     n := h readBytes:1000 into:buff startingAt:1.
     Transcript show:n printString; space; showCR:buff asString.
    "
!

writeBytes:count from:aByteBuffer startingAt:firstIndex
    "write count bytes from a byte-buffer;
     Return the number of bytes written (negative on error)"

    |error|

%{
    unsigned char *extPtr;
    int nWritten = -1;
    INT fd;
    INT cnt, offs;
    int nInstBytes, objSize;

    if (! __isSmallInteger(__INST(fd))) {
	error = @symbol(errorNotOpen);
	goto bad;
    }
    if (! __bothSmallInteger(count, firstIndex)) {
	error = @symbol(badArgument);
	goto bad;
    }
    fd = __smallIntegerVal(__INST(fd));
    cnt = __smallIntegerVal(count);
    offs = __smallIntegerVal(firstIndex) - 1;

    if (fd < 0) {
	error = @symbol(internalError);
	goto bad;
    }
    if (__isExternalBytesLike(aByteBuffer)) {
	OBJ sz;

	nInstBytes = 0;
	extPtr = (char *)(__externalBytesAddress(aByteBuffer));
	if (extPtr == NULL) goto bad;
	sz = __externalBytesSize(aByteBuffer);
	if (__isSmallInteger(sz)) {
	    objSize = __smallIntegerVal(sz);
	} else {
	    objSize = -1; /* unknown */
	}
    } else {
	OBJ oClass = __Class(aByteBuffer);
	int nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);

	nInstBytes = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
	switch (__intVal(__ClassInstPtr(oClass)->c_flags) & ARRAYMASK) {
	    case BYTEARRAY:
	    case WORDARRAY:
	    case LONGARRAY:
	    case SWORDARRAY:
	    case SLONGARRAY:
	    case FLOATARRAY:
		break;
	    case DOUBLEARRAY:
#ifdef __NEED_DOUBLE_ALIGN
		nInstBytes = (nInstBytes-1+__DOUBLE_ALIGN) &~ (__DOUBLE_ALIGN-1);
#endif
		break;
	    case LONGLONGARRAY:
	    case SLONGLONGARRAY:
#ifdef __NEED_LONGLONG_ALIGN
		nInstBytes = (nInstBytes-1+__LONGLONG_ALIGN) &~ (__LONGLONG_ALIGN-1);
#endif
		break;
	    default:
		goto bad;
	}
	extPtr = (char *)0;
	objSize = __Size(aByteBuffer) - nInstBytes;
    }
    if ((offs >= 0)
	&& (cnt >= 0)
	&& ((objSize == -1) || (objSize >= (cnt + offs)))) {
	nWritten = 0;

	do {
	    int n;

	    if (extPtr) {
		n = write(fd, extPtr+offs, cnt);
	    } else {
		char *bp;

		/*
		 * on interrupt, anObject may be moved to another location.
		 * So we recompute the byte-address here.
		 */
		bp = __byteArrayVal(aByteBuffer) + nInstBytes;

		n = write(fd, bp + offs, cnt);
	    }
	    if (n > 0) {
		cnt -= n;
		offs += n;
		nWritten += n;
	    } else if (n == 0) {
		break;
	    } else if (n < 0) {
		if (0
#ifdef EWOULDBLOCK
		    || errno == EWOULDBLOCK
#endif
#ifdef EAGAIN
		    || errno == EAGAIN
#endif
		) {
		     RETURN(nil);
		}
		if (errno != EINTR) {
		     error = __mkSmallInteger(errno);
		     goto bad;
		}
		__HANDLE_INTERRUPTS__;
	    }
	} while (cnt > 0);

	RETURN (__mkSmallInteger(nWritten));
    }
bad: ;
%}.
    ^ self error:error

    "
     |h buff n|

     h := OperatingSystem createFileForReadWrite:'/tmp/xx'.
     buff := '12345678901234567890'.
     n := h writeBytes:10 from:buff startingAt:1.
    "

    "
     |h buff n|

     h := OperatingSystem createFileForReadWrite:'/dev/cua0'.
     buff := '12345678901234567890'.
     n := h writeBytes:10 from:buff startingAt:1.
    "
! !

!UnixOperatingSystem::FileDescriptorHandle methodsFor:'misc functions'!

nextError
    "retrieve the pending error from the current fileDescriptor
     and raise an error exception.
     This should be only called, when an error is pending.
     Otherwise a byte may be lost"

    |dummyByte|

    dummyByte := ByteArray new:1.
    ^ self readBytes:1 into:dummyByte startingAt:1.
!

seekTo:newPosition from:whence
    "seek to newPosition
     whence is one of: #begin #current #end.
     Return the new position."

    |error|

%{
    INT fd;
    INT __whence;
    off_t pos, ret;
    OBJ rslt;

    if (! __isSmallInteger(__INST(fd))) {
	error = @symbol(errorNotOpen);
	goto bad;
    }
    if (__isSmallInteger(newPosition)) {
	pos = __smallIntegerVal(newPosition);
    } else {
	pos = __signedLongIntVal(newPosition);
	if (pos < 0 && (sizeof(pos) < 8 || __signedLong64IntVal(newPosition, &pos) == 0)) {
	    error = @symbol(badArgument1);
	    goto bad;
	}
    }

    fd = __smallIntegerVal(__INST(fd));
    if (fd < 0) {
	error = @symbol(internalError);
	goto bad;
    }
    if (whence == @symbol(begin)) {
	__whence = SEEK_SET;
    } else if (whence == @symbol(current)) {
	__whence = SEEK_CUR;
    } else if (whence == @symbol(end)) {
	__whence = SEEK_END;
    } else {
	error = @symbol(badArgument2);
	goto bad;
    }

again:
    ret = lseek(fd, pos, __whence);
    if (ret < 0) {
	if (errno == EINTR) {
	    __HANDLE_INTERRUPTS__;
	    goto again;
	}
	error = __mkSmallInteger(errno);
	goto bad;
    }

    if (sizeof(ret) == 8) {
	rslt = __MKINT64 (&ret);
    } else {
	rslt = __MKINT(ret);
    }
    RETURN (rslt);

bad: ;
%}.
    ^ self error:error.

    "
     |h buff n|

     h := OperatingSystem openFileForRead:'/etc/hosts'.
     h seekTo:10 from:#begin.
     buff := ByteArray new:1000. buff inspect.
     n := h readBytes:1000 into:buff startingAt:1.
     Transcript show:n; space; showCR:buff asString.
    "
!

selectWithTimeOut:millis
    "wait for aFileDesriptor to become ready; timeout after t milliseconds.
     Return true, if i/o ok, false if timed-out or interrupted.
     With 0 as timeout argument, this can be used to check for availability
     of read-data.
     Experimental."

    ^ OperatingSystem selectOnAnyReadable:(Array with:fd)
		      writable:(Array with:fd)
		     exception:nil
		   withTimeOut:millis

    "Created: 1.10.1997 / 08:51:11 / stefan"
!

setBlocking:aBoolean
    "{ Pragma: +optSpace }"

    "set/clear the blocking attribute - if set (which is the default)
     a read on the fileDescriptor will block until data is available.
     If cleared, a read operation will immediately return with a value of
     nil if no data is available."

    |err|
%{
#ifdef __SCHTEAM__
    // TODO
    return context._RETURN(0);
#else
    int ret, flags;

# if defined(F_GETFL) && defined(F_SETFL)
#  if defined(O_NDELAY)
#   define DELAY_FLAG O_NDELAY
#  else
#   if defined(FNDELAY)
#    define DELAY_FLAG FNDELAY
#   endif
#  endif
#  if defined(DELAY_FLAG)
    if (__isSmallInteger(__INST(fd))) {
	int f = __intVal(__INST(fd));

	flags = fcntl(f, F_GETFL, 0);
	if (aBoolean == true) {
	    ret = fcntl(f, F_SETFL, flags & ~DELAY_FLAG);
	} else {
	    ret = fcntl(f, F_SETFL, flags | DELAY_FLAG);
	}
	if (ret >= 0) {
	    RETURN(__mkSmallInteger(flags));
	} else {
	    err = __mkSmallInteger(errno);
	}
    }
#  undef DELAY_FLAG
#  endif /* DELAY_FLAG */
# endif
#endif /* not SCHTEAM */
%}.
    err notNil ifTrue:[
	self error:err
    ].

    "
     fd argument not integer
    "
    ^ self primitiveFailed


! !

!UnixOperatingSystem::FileDescriptorHandle methodsFor:'private-accessing'!

fileDescriptor
    "return the (integer) fileDescriptor"

%{
    OBJ handle = __externalAddressVal(self);

    if (__isSmallInteger(handle)) {
	RETURN (handle);
    }
%}.
    ^ nil
!

setFileDescriptor:anInteger

%{
    if (__isSmallInteger(anInteger)) {
	__externalAddressVal(self) = (OBJ)(__smallIntegerVal(anInteger));
    }
%}


! !

!UnixOperatingSystem::FileDescriptorHandle methodsFor:'queries'!

canReadWithoutBlocking
    "return true, if data is available on a filedescriptor
     (i.e. read is possible without blocking).
     This depends on a working select or FIONREAD to be provided by the OS."

%{
    int fd;

    if (__isSmallInteger(__INST(fd))) {
	fd = __smallIntegerVal(__INST(fd));

	/*
	 * if available, try FIONREAD first, which is usually done faster.
	 */
# ifdef FIONREAD
	{
	    int result = 0;

	    if (ioctl(fd, FIONREAD, &result) >= 0) {
		RETURN(result > 0 ? true : false);
	    }
	}
# endif /* FIONREAD */
    }
%}.

    OperatingSystem supportsSelect ifFalse:[
	"/ mhmh - what should we do then ?
	"/ For now, return true as if data was present,
	"/ and let the thread fall into the read.
	"/ It will then (hopefully) be desceduled there and
	"/ effectively polling for input.

	^ true
    ].

    ^ (OperatingSystem selectOnAnyReadable:(Array with:fd)
		       writable:nil
		       exception:nil
		       withTimeOut:0) == fd

    "
     |h n|
     h := OperatingSystem openFileForRead:'/etc/hosts'.
     n := h canReadWithoutBlocking.
     h close.
     n
    "

    "
     |h n|
     h := OperatingSystem openFileForRead:'/dev/ttyS0'.
     n := h canReadWithoutBlocking.
     h close.
     n
    "
!

canWriteWithoutBlocking
    "return true, if filedescriptor can be written without blocking"

    OperatingSystem supportsSelect ifFalse:[
	"/ mhmh - what should we do then ?
	"/ For now, return true as if data was present,
	"/ and let the thread fall into the write.
	"/ It will then (hopefully) be desceduled there and
	"/ effectively polling for output.
	^ true
    ].

    ^ (OperatingSystem selectOnAnyReadable:nil
		       writable:(Array with:fd)
		       exception:nil
		       withTimeOut:0) == fd
!

isValid
    "answer true, if the handle is valid, i.e. connected to
     a file or some other OS object"

    ^ fd notNil
!

numAvailableForRead
    "return the number of bytes available for reading, without blocking."

%{
    /*
     * if available, try FIONREAD first, which is usually done faster.
     */
# if defined(FIONREAD)
    {
	int n = 0;

	if (__isSmallInteger(__INST(fd))) {
	    if (ioctl(__smallIntegerVal(__INST(fd)), FIONREAD, &n) >= 0) {
		RETURN (__MKINT(n));
	    }
	}
    }
# endif /* FIONREAD */
%}.
    ^ self canReadWithoutBlocking ifTrue:[1] ifFalse:[0]

    "
     |h n|
     h := OperatingSystem openFileForRead:'/etc/hosts'.
     n := h numAvailableForRead.
     h close.
     n
    "
! !

!UnixOperatingSystem::FileDescriptorHandle methodsFor:'registering'!

register
    "register myself as an open file"

    |sz old|

    sz := OpenFiles size.
    fd > sz ifTrue:[
	"grow for more descriptors"
	old := OpenFiles.

	"JV@2013-03-15: It may happen that OS returns a filedescriptor whose value
	 is larger than twice the lenght of the weakarray. Care for this.
	 Spotted by Martin Kobetic."
	OpenFiles := WeakArray new:((sz * 2) max:fd).
	old removeDependent:(self class).
	OpenFiles addDependent:(self class).
	old keysAndValuesDo:[:index :elem|
	    "be careful to not overwrite new entries in OpenFiles"
	    elem notNil ifTrue:[
		OpenFiles at:index put:elem.
	    ].
	].
    ].
    OpenFiles at:fd put:self.

    "Created: 30.9.1997 / 12:51:48 / stefan"
    "Modified: 30.9.1997 / 12:58:37 / stefan"
    "Modified (comment): / 16-03-2013 / 00:04:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnixOperatingSystem::FileDescriptorHandle methodsFor:'releasing'!

invalidate
    "a file handle has become invalid"

    OpenFiles at:fd put:nil.
    fd := nil.

    "Created: 30.9.1997 / 12:37:26 / stefan"
    "Modified: 30.9.1997 / 12:42:16 / stefan"
! !

!UnixOperatingSystem::FileDescriptorHandle methodsFor:'waiting'!

readWaitWithTimeoutMs:timeout
    "suspend the current process, until the receiver
     becomes ready for reading or a timeout (in milliseconds) expired.
     If data is already available, return immediate.
     Return true if a timeout occurred (i.e. false, if data is available).
     The other threads are not affected by the wait."

    |inputSema hasData wasBlocked|

    fd isNil ifTrue:[^ self error:#errorNotOpen].
    self canReadWithoutBlocking ifTrue:[
	^ false.
    ].

    wasBlocked := OperatingSystem blockInterrupts.
    inputSema := Semaphore new name:'readWait'.
    [
	timeout notNil ifTrue:[
	    Processor signal:inputSema afterMilliseconds:timeout
	].
	Processor signal:inputSema onInput:fd.
	Processor activeProcess state:#ioWait.
	inputSema wait.
	hasData := self canReadWithoutBlocking.
    ] ifCurtailed:[
	Processor disableSemaphore:inputSema.
	wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ].
    timeout notNil ifTrue:[
	Processor disableSemaphore:inputSema.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ hasData not
!

writeWaitWithTimeoutMs:timeout
    "suspend the current process, until the receiver
     becomes ready for writing or a timeout (in seconds) expired.
     Return true if a timeout occurred (i.e. false, if data is available).
     Return immediate if the receiver is already ready.
     The other threads are not affected by the wait."

    |outputSema canWrite wasBlocked|

    fd isNil ifTrue:[^ self error:#errorNotOpen].
    self canWriteWithoutBlocking ifTrue:[
	^ false.
    ].

    wasBlocked := OperatingSystem blockInterrupts.
    outputSema := Semaphore new name:'writeWait'.
    [
	timeout notNil ifTrue:[
	    Processor signal:outputSema afterMilliseconds:timeout
	].
	Processor signal:outputSema onOutput:fd.
	Processor activeProcess state:#ioWait.
	outputSema wait.
	canWrite := self canWriteWithoutBlocking.
    ] ifCurtailed:[
	Processor disableSemaphore:outputSema.
	wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ].
    timeout notNil ifTrue:[
	Processor disableSemaphore:outputSema.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ canWrite not
! !

!UnixOperatingSystem::FilePointerHandle methodsFor:'release'!

closeFile
    "close the underlying file"

%{
    FILE *f = (FILE *)(__externalAddressVal(self));

    if (f) {
	__externalAddressVal(self) = NULL;
	fclose(f);
    }
%}

! !

!UnixOperatingSystem::FileStatusInfo class methodsFor:'instance creation'!

type:t mode:m uid:u gid:g size:s id:i accessed:aT modified:mT statusChanged:sT path:lP numLinks:nL
    ^ self basicNew
	type:t mode:m uid:u gid:g size:s id:i accessed:aT modified:mT statusChanged:sT path:lP numLinks:nL
!

type:t mode:m uid:u gid:g size:s id:i accessed:aT modified:mT statusChanged:sT sourcePath:sP targetPath:tP numLinks:nL
    ^ self basicNew
	type:t mode:m uid:u gid:g size:s id:i accessed:aT modified:mT statusChanged:sT sourcePath:sP targetPath:tP numLinks:nL
! !

!UnixOperatingSystem::FileStatusInfo methodsFor:'accessing'!

accessTime
    "return accessed"

    accessed isInteger ifTrue:[
	"/ lazy time conversion
	accessed := Timestamp fromOSTime:(accessed * 1000).
    ].
    ^ accessed
!

alternativeName
    "return the file's other name (DOS name on Windows).
     Nil if there is no other name"

    ^ nil
!

creationTime
    ^ nil
!

fileSize
    "return size"

    ^ size
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

    ^ targetPath
!

mode
    "return mode"

    ^ mode
!

modificationTime
    "return modified"

    modified isInteger ifTrue:[
	"/ lazy time conversion
	modified := Timestamp fromOSTime:(modified * 1000).
    ].
    ^ modified
!

numLinks
    "return numLinks"

    ^ numLinks
!

path
    "for symbolic links only: return the path where the symbolic link points to"

    ^ targetPath
!

sourcePath
    ^ sourcePath
!

statusChangeTime
    statusChanged isInteger ifTrue:[
	"/ lazy time conversion
	statusChanged := Timestamp fromOSTime:(statusChanged * 1000).
    ].
    ^ statusChanged
!

targetPath
    "for symbolic links only: return the path where the symbolic link points to"

    ^ targetPath
!

type
    "return type"

    ^ type
!

uid
    "return uid"

    ^ uid
! !

!UnixOperatingSystem::FileStatusInfo methodsFor:'accessing-vms'!

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

!UnixOperatingSystem::FileStatusInfo methodsFor:'backward compatibility'!

accessed
    <resource:#obsolete>

    self obsoleteMethodWarning:'use #accessTime'.
    ^ self accessTime
!

at:key
    "backward compatibility access: in previous releases, IdentityDictionaries
     were used to hold my information. Allow access via key messages.
     This method will vanish - use the proper access protocol."

    ^ self perform:key
!

modified
    <resource:#obsolete>

    self obsoleteMethodWarning:'use #modificationTime'.
    ^ self modificationTime
!

statusChanged
    <resource:#obsolete>

    self obsoleteMethodWarning:'use #statusChangeTime'.
    ^ self statusChangeTime
! !

!UnixOperatingSystem::FileStatusInfo methodsFor:'private-accessing'!

sourcePath:lP
    sourcePath := lP.
!

type:t mode:m uid:u gid:g size:s id:i accessed:aT modified:mT statusChanged:sT path:lP numLinks:nL
    type := t.
    mode := m.
    uid := u.
    gid := g.
    size := s.
    id := i.
    accessed := aT.
    modified := mT.
    statusChanged := sT.
    targetPath := lP.
    numLinks := nL.
!

type:t mode:m uid:u gid:g size:s id:i accessed:aT modified:mT statusChanged:sT sourcePath:sP targetPath:tP numLinks:nL
    type := t.
    mode := m.
    uid := u.
    gid := g.
    size := s.
    id := i.
    accessed := aT.
    modified := mT.
    statusChanged := sT.
    sourcePath := sP.
    targetPath := tP.
    numLinks := nL.
! !

!UnixOperatingSystem::FileStatusInfo methodsFor:'queries-access'!

isGroupExecutable
    ^ mode bitTest:8r10

    "
      '/etc/passwd' asFilename info isGroupExecutable
    "
!

isGroupReadable
    ^ mode bitTest:8r40

    "
      '/etc/passwd' asFilename info isGroupReadable
    "
!

isGroupWritable
    ^ mode bitTest:8r20

    "
      '/etc/passwd' asFilename info isGroupWritable
    "
!

isOwnerExecutable
    ^ mode bitTest:8r100

    "
      '/etc/passwd' asFilename info isOwnerExecutable
    "
!

isOwnerReadable
    ^ mode bitTest:8r400

    "
      '/etc/passwd' asFilename info isOwnerReadable
    "
!

isOwnerWritable
    ^ mode bitTest:8r200

    "
      '/etc/passwd' asFilename info isOwnerWritable
    "
!

isWorldExecutable
    ^ mode bitTest:8r1

    "
      '/etc/passwd' asFilename info isWorldExecutable
    "
!

isWorldReadable
    ^ mode bitTest:8r4

    "
      '/etc/passwd' asFilename info isWorldReadable
    "
!

isWorldWritable
    ^ mode bitTest:8r2

    "
      '/etc/passwd' asFilename info isWorldWritable
    "
! !

!UnixOperatingSystem::FileStatusInfo methodsFor:'queries-type'!

isBlockSpecial
    ^ type == #blockSpecial
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
    "true if this info contains valid status info, or only the name.
     Under UNIX, the fileStatuInfo as returned from readDir ONLY contains the name of the file,
     whereas under Windows, it contains the full info (incl. fileSize, access rights etc.).
     The reason is that under windows, the ReadNextEntry system call does this, whereas the
     the corresponding unix readdir only returns the name."

    ^ type notNil
! !

!UnixOperatingSystem::MountInfo methodsFor:'accessing'!

mountPointPath
    "return the value of the instance variable 'mountPointPath' (automatically generated)"

    ^ mountPointPath
!

mountPointPath:mountPointArg deviceOrRemotePath:deviceOrRemotePathArg fsType:fsTypeArg attributeString:attributeStringArg
    "set instance variables (automatically generated)"

    mountPointPath := mountPointArg.
    deviceOrRemotePath := deviceOrRemotePathArg.
    fsType := fsTypeArg.
    attributeString := attributeStringArg.
! !

!UnixOperatingSystem::MountInfo methodsFor:'printing'!

printOn:aStream
    aStream
	nextPutAll:'MountInfo for ';
	nextPutAll:mountPointPath.
! !

!UnixOperatingSystem::MountInfo methodsFor:'queries'!

isRemote
    ^ fsType = 'nfs'
! !

!UnixOperatingSystem::OSProcessStatus class methodsFor:'documentation'!

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

!UnixOperatingSystem::OSProcessStatus class methodsFor:'instance creation'!

pid:pid status:status code:code core:core
    "private interface for UnixOperatingSystem"

    ^ self new pid:pid status:status code:code core:core

    "Created: 28.12.1995 / 14:16:14 / stefan"
    "Modified: 30.4.1996 / 18:25:00 / cg"
!

processCreationFailure
    "private interface for UnixOperatingSystem"

    ^ self new pid:-1 status:#failure code:-1 core:false

    "Created: 28.12.1995 / 14:35:29 / stefan"
    "Modified: 30.4.1996 / 18:25:05 / cg"
! !

!UnixOperatingSystem::OSProcessStatus methodsFor:'accessing'!

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

!UnixOperatingSystem::OSProcessStatus methodsFor:'initialization'!

pid:newPid status:newStatus code:newCode core:newCore
    pid := newPid.
    status := newStatus.
    code := newCode.
    core := newCore.

    "Created: 28.12.1995 / 14:18:22 / stefan"
! !

!UnixOperatingSystem::OSProcessStatus methodsFor:'printing & storing'!

printOn:aStream

    aStream nextPutAll:'ExitStatus ('.
    status printOn:aStream.
    aStream nextPutAll:', code='.
    code printOn:aStream.
    aStream nextPut:$).
! !

!UnixOperatingSystem::OSProcessStatus methodsFor:'private-OS interface'!

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

!UnixOperatingSystem::OSProcessStatus methodsFor:'queries'!

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

!UnixOperatingSystem::SocketHandle class methodsFor:'constants'!

protocolCodeOf:aNameOrNumber
    "convert a symbol to a numeric protocol code"

    |protocolCode protocolSymbol|

%{
    if (__isSmallInteger(aNameOrNumber) || aNameOrNumber == nil) {
	RETURN(aNameOrNumber);
    }
%}.

    ProtocolCache notNil ifTrue:[
	protocolCode := ProtocolCache at:(aNameOrNumber asSymbol) ifAbsent:[].
	protocolCode notNil ifTrue:[
	    ^ protocolCode.
	].
    ].

%{
#ifndef NO_SOCKET
    struct protoent *protoent = 0;

    if (__isStringLike(aNameOrNumber)) {
	protoent = getprotobyname((char *) __stringVal(aNameOrNumber));
	if (protoent) {
	    protocolCode = __mkSmallInteger(protoent->p_proto);
	    protocolSymbol = __MKSYMBOL(protoent->p_name, 0);
	}
    }
#endif /*NO_SOCKET*/
%}.

    protocolSymbol notNil ifTrue:[
	ProtocolCache isNil ifTrue:[
	    ProtocolCache := IdentityDictionary new.
	].
	"beware of polluting the protocol cache with aliases"
	ProtocolCache at:protocolSymbol put:protocolCode.
    ].
    ^ protocolCode

    "
     self protocolCodeOf:#tcp
     self protocolCodeOf:#udp
     self protocolCodeOf:#raw
    "
!

protocolSymbolOf:anInteger
    "convert a numeric protocol code to a symbol"

    |protocolSymbol|

    ProtocolCache notNil ifTrue:[
	protocolSymbol := ProtocolCache keyAtIdentityValue:anInteger ifAbsent:[].
	protocolSymbol notNil ifTrue:[
	    ^ protocolSymbol.
	].
    ].

%{
#ifndef NO_SOCKET
    struct protoent *protoent = 0;

    if (__isSmallInteger(anInteger)) {
	protoent = getprotobynumber(__intVal(anInteger));
	if (protoent) {
	    protocolSymbol = __MKSYMBOL(protoent->p_name, 0);
	}
    }
#endif /*NO_SOCKET*/
%}.

    protocolSymbol notNil ifTrue:[
	ProtocolCache isNil ifTrue:[
	    ProtocolCache := IdentityDictionary new.
	].
	ProtocolCache at:protocolSymbol put:anInteger.
    ].
    ^ protocolSymbol


    "
     self protocolSymbolOf:(self protocolCodeOf:#tcp)
     self protocolSymbolOf:(self protocolCodeOf:#udp)
     self protocolSymbolOf:(self protocolCodeOf:#icmp)
    "
! !

!UnixOperatingSystem::SocketHandle class methodsFor:'initialization'!

reinitialize
    "clear the protocol cache, when the system has been restarted"

    ProtocolCache := nil.
! !

!UnixOperatingSystem::SocketHandle class methodsFor:'queries'!

getAddressInfo:hostName serviceName:serviceName domain:domainArg type:typeArg protocol:protoArg flags:flags
    "answer an Array of socket addresses for serviceName on hostName.
     A nil hostName will return the loopback address(es) e.g. localhost.
     Domain, type, protocol may be nil or specify a hint for the socket
     addresses to be returned.
     The sorting function used within getaddrinfo() is defined in RFC 3484; in linux the order can be
     tweaked for a particular system by editing /etc/gai.conf"

    |result domain type proto encodedHostName|

    domainArg notNil ifTrue:[
	domain := OperatingSystem domainCodeOf:domainArg.
    ].
    typeArg notNil ifTrue:[
	type := OperatingSystem socketTypeCodeOf:typeArg.
    ].
    protoArg notNil ifTrue:[
	proto := self protocolCodeOf:protoArg.
    ].

    hostName isNil ifTrue:[
	encodedHostName := nil.
    ] ifFalse:[
	encodedHostName := hostName utf8Encoded.
    ].
    (encodedHostName ~~ hostName and:[OperatingSystem getCodeset ~~ #utf8]) ifTrue:[
	"hostName is not plain ASCII - so this is an IDN domain name. Have to ensure, that the locale is UTF-8.
	 Block interrupt to not affect other ST/X processes while the locale is changed."
	|interruptsBlocked oldLocale|

	interruptsBlocked := OperatingSystem blockInterrupts.
	oldLocale := OperatingSystem setLocale:#'LC_CTYPE' to:nil.
	OperatingSystem setLocale:#'LC_CTYPE' to:'en_US.UTF-8'.
	result := self primGetAddressInfo:encodedHostName serviceName:serviceName domainCode:domain socketTypeCode:type protocolCode:proto flags:flags.
	OperatingSystem setLocale:#'LC_CTYPE' to:oldLocale.
	interruptsBlocked ifFalse:[
	    OperatingSystem unblockInterrupts.
	].
    ] ifFalse:[
	result := self primGetAddressInfo:encodedHostName serviceName:serviceName domainCode:domain socketTypeCode:type protocolCode:proto flags:flags.
    ].
    result isArray ifFalse:[
	|request|
	request := SocketAddressInfo new
	    domain:domainArg;
	    type:typeArg;
	    protocol:protoArg;
	    canonicalName:hostName;
	    serviceName:serviceName.
	^ (HostNameLookupError new
		parameter:result;
		messageText:' - ', (result printString);
		request:request) raiseRequest.
    ].
    1 to:result size do:[:i |
	|entry dom info|

	entry := result at:i.

	info := SocketAddressInfo new.
	info
	    flags:(entry at:1);
	    domain:(dom := OperatingSystem domainSymbolOf:(entry at:2));
	    type:(OperatingSystem socketTypeSymbolOf:(entry at:3));
	    protocol:(self protocolSymbolOf:(entry at:4));
	    socketAddress:((SocketAddress newDomain:dom) fromBytes:(entry at:5));
	    canonicalName:(entry at:6).

	result at:i put:info.
    ].
    ^ result.


    "
     self getAddressInfo:'localhost' serviceName:nil
	    domain:nil type:nil protocol:nil flags:nil
     self getAddressInfo:nil serviceName:22
	    domain:nil type:nil protocol:nil flags:nil
     self getAddressInfo:'' serviceName:22
	    domain:nil type:nil protocol:nil flags:nil
     self getAddressInfo:'localhost' serviceName:nil
	    domain:nil type:#stream protocol:nil flags:nil
     self getAddressInfo:'localhost' serviceName:nil
	    domain:#inet type:#stream protocol:#tcp flags:nil
     self getAddressInfo:'blurb.exept.de' serviceName:nil
	    domain:#inet type:nil protocol:nil flags:nil
     self getAddressInfo:'1.2.3.4' serviceName:'bla'
	    domain:#inet type:nil protocol:nil flags:nil
     self getAddressInfo:'localhost' serviceName:'echo'
	    domain:#inet type:nil protocol:nil flags:nil
     self getAddressInfo:nil serviceName:'echo'
	    domain:#inet type:nil protocol:nil flags:nil
     self getAddressInfo:nil serviceName:nil
	    domain:#inet type:nil protocol:nil flags:nil
     self getAddressInfo:'www.google.de' serviceName:80
	    domain:nil type:nil protocol:nil flags:nil
     self getAddressInfo:'www.exept.de' serviceName:nil
	    domain:nil type:nil protocol:nil flags:nil
     self getAddressInfo:'www.exept.de' serviceName:'https'
	    domain:#'AF_INET' type:nil protocol:nil flags:nil
     self getAddressInfo:'www.exept.de' serviceName:nil
	    domain:#'AF_INET6' type:nil protocol:nil flags:nil
     self getAddressInfo:'www.baden-wrttemberg.de' serviceName:nil
	    domain:#'AF_INET' type:#stream protocol:nil flags:nil
     self getAddressInfo:'www.baden-wrttemberg.de' serviceName:nil
	    domain:#'AF_INET6' type:#stream protocol:nil flags:nil
    "
!

getNameInfo:socketAddress wantHostName:wantHostName wantServiceName:wantServiceName datagram:useDatagram flags:flags
    "answer an Array containing the hostName and serviceName
     in socketAddress.
     This is the generic version of getHostByAddr, however, if supported by the OS,
     this returns multiple hostnames (if appropriate)"

    |error errorString hostName serviceName|

%{ /* STACK: 100000 */  /* Don't know whether DNS, NIS, LDAP or whatever is consulted */

#undef xxNI_NUMERICHOST /* remove xx to test gethost...() path */

#if !defined(NO_SOCKET)

# ifndef NI_MAXHOST
#  define NI_MAXHOST 1025
#  define NI_MAXSERV 64
# endif

    char host[NI_MAXHOST];
    char service[NI_MAXSERV];
    char *hp = 0, *sp = 0;
    int hsz = 0, ssz = 0;
    int ret, __flags;
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
    if (hp == 0 && sp == 0) {
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
	__BEGIN_INTERRUPTABLE__
	ret = getnameinfo((struct sockaddr *)bp, sockAddrSize,
			  hp, hsz, sp, ssz, __flags);
	__END_INTERRUPTABLE__
    } while (ret == EAI_SYSTEM && errno == EINTR);
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
#ifdef EAI_ADDRFAMILY
	case EAI_ADDRFAMILY :
	    error = @symbol(unknownHostForProtocol);
	    break;
#endif
#ifdef EAI_NODATA
	case EAI_NODATA:
	    error = @symbol(noAddress);
	    break;
#endif
	case EAI_MEMORY:
	    error = @symbol(allocationFailure);
	    break;
	case EAI_FAIL:
	    error = @symbol(permanentFailure);
	    break;
	case EAI_AGAIN:
	    error = @symbol(tryAgain);
	    break;
	case EAI_SYSTEM:
	    error = @symbol(systemError);
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
	if (hp) {
	    struct hostent *hostp;
#  ifdef USE_H_ERRNO
	    do {
		bp = (char *)(__byteArrayVal(socketAddress));
		bp += nInstBytes;
		sa = (struct sockaddr_in *)bp;

		/* __BEGIN_INTERRUPTABLE__ is dangerous, because gethostbyname uses a static data area
		 */
		hostp = gethostbyaddr((char *)&sa->sin_addr, sockAddrSize, sa->sin_family);
		/* __END_INTERRUPTABLE__ */
	    } while ((hostp == NULL)
		      && ((h_errno == TRY_AGAIN)
			  || errno == EINTR
#   ifdef IRIX5_3
			  || (errno == ECONNREFUSED)
#   endif
			 )
	    );
	    if (hostp == 0) {
		switch (h_errno) {
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
		error = __mkSmallInteger(h_errno);
		goto err;
	    }
#  else /* !USE_H_ERRNO */
	    hostp = gethostbyaddr(sa->sin_addr, sockAddrSize, sa->sin_family);
	    if (hostp == 0) {
		errorString = @symbol(unknownHost);
		error = __mkSmallInteger(-1);
		goto err;
	    }
#  endif /* !USE_H_ERRNO*/
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
	^ (HostAddressLookupError new
		parameter:error;
		messageText:' - ', errorString;
		request:thisContext message) raiseRequest.
    ].

    ^ Array with:hostName with:serviceName

    "
     self getNameInfo:
	(self getAddressInfo:'localhost' serviceName:'echo'
		domain:#inet type:#stream protocol:nil flags:nil) first socketAddress
	 wantHostName:true wantServiceName:true datagram:false flags:0

     self getNameInfo:
	(self getAddressInfo:'exept.de' serviceName:'echo'
		domain:#inet type:#stream protocol:nil flags:nil) first socketAddress
	 wantHostName:true wantServiceName:true datagram:false flags:0

     self getNameInfo:
	(self getAddressInfo:'217.172.183.25' serviceName:'22'
		domain:#inet type:#stream protocol:nil flags:nil) first socketAddress
	 wantHostName:true wantServiceName:true datagram:false flags:0

     self getNameInfo:
	(self getAddressInfo:'1.2.3.4' serviceName:'22'
		domain:#inet type:#stream protocol:nil flags:nil) first socketAddress
	 wantHostName:true wantServiceName:true datagram:false flags:0
    "
!

primGetAddressInfo:hostName serviceName:serviceName domainCode:domain socketTypeCode:type protocolCode:proto flags:flags
    "answer an Array of socket addresses for serviceName on hostName
     Domain, type, protocol may be nil or specify a hint for the socket
     addresses to be returned.
     A nil hostName resolves to the loopback interface address (localhost).
     An empty hostname resolves to an address that may be used for a lisstening server."

    |error errorString result|

%{ /* UNLIMITEDSTACK */  /* Don't know whether DNS, NIS, LDAP or whatever is consulted */
#undef xxAI_NUMERICHOST /* remove xx to test gethost...() path */

#if !defined(NO_SOCKET)
    char *__hostName, *__serviceName;
    char intServiceName[21];
    int ret, cnt = 0;

    if (hostName == nil) {
	__hostName = 0;
    } else if (__isStringLike(hostName)) {
	__hostName = __stringVal(hostName);
    } else {
	error = @symbol(badArgument1);
	goto out;
    }
    if (serviceName == nil) {
	__serviceName = 0;
    } else if (__isStringLike(serviceName)) {
	__serviceName = __stringVal(serviceName);
    } else if (__isSmallInteger(serviceName)) {
	__serviceName = intServiceName;
	snprintf(intServiceName, sizeof(intServiceName), "%d", (int)(__intVal(serviceName)));
    } else {
	error = @symbol(badArgument2);
	goto out;
    }

{
# if defined(AI_NUMERICHOST)
    /*
     * Use getaddrinfo()
     */
    struct addrinfo hints = {0};
    struct addrinfo *info = NULL, *infop;

    hints.ai_flags = AI_ADDRCONFIG      // only return IPv6 or IPv4 addresses if there is at least on interface where this address type is configured
		    | AI_V4MAPPED;
    if (__isSmallInteger(serviceName))
	hints.ai_flags |= AI_NUMERICSERV;

    if (__hostName && __stringSize(hostName) == 0) {
	// empty string, this is a listening host - bound to INADDR_ANY
	__hostName = 0;
	hints.ai_flags |= AI_PASSIVE;
    }

#if defined(AI_IDN)
    hints.ai_flags |= AI_IDN | AI_CANONIDN;     // map non-ascii domain names to IDN format
#endif
    if (__isSmallInteger(domain))
	hints.ai_family = __intVal(domain);
    if (__isSmallInteger(type))
	hints.ai_socktype = __intVal(type);
    if (__isSmallInteger(proto))
	hints.ai_protocol = __intVal(proto);
    if (__isSmallInteger(flags))
	hints.ai_flags |= __intVal(flags);

    do {
	/* reload */
	if (__hostName) {
	    __hostName = __stringVal(hostName);
	}
	if (__isStringLike(serviceName)) {
	    __serviceName = __stringVal(serviceName);
	}

//        __BEGIN_INTERRUPTABLE__
	ret = getaddrinfo(__hostName, __serviceName, &hints, &info);
//        __END_INTERRUPTABLE__
    } while (ret == EAI_SYSTEM && errno == EINTR);
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
#ifdef EAI_ADDRFAMILY
	case EAI_ADDRFAMILY :
	    error = @symbol(unknownHostForProtocol);
	    break;
#endif
#ifdef EAI_NODATA
	case EAI_NODATA:
	    error = @symbol(noAddress);
	    break;
#endif
	case EAI_MEMORY:
	    error = @symbol(allocationFailure);
	    break;
	case EAI_FAIL:
	    error = @symbol(permanentFailure);
	    break;
	case EAI_AGAIN:
	    error = @symbol(tryAgain);
	    break;
	case EAI_SYSTEM:
	    error = @symbol(systemError);
	    break;
	default:
	    error = @symbol(unknownError);
	}
	errorString = __MKSTRING(gai_strerror(ret));
	goto ai_out;
    }
    for (cnt=0, infop=info; infop; infop=infop->ai_next)
	cnt++;

    result = __ARRAY_NEW_INT(cnt);
    if (result == nil) {
	error = @symbol(allocationFailure);
	goto ai_out;
    }
    for (infop=info, cnt=0; infop; infop=infop->ai_next, cnt++) {
	OBJ o, resp;

	resp = __ARRAY_NEW_INT(6);
	if (resp == nil) {
	    error = @symbol(allocationFailure);
	    goto ai_out;
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
	    goto ai_out;
	}
	memcpy(__byteArrayVal(o), infop->ai_addr, infop->ai_addrlen);
       __ArrayInstPtr(resp)->a_element[4] = o; __STORE(resp, o);

	if (infop->ai_canonname) {
	    __PROTECT__(resp);
	    o = __MKSTRING(infop->ai_canonname);
	    __UNPROTECT__(resp);
	    if (o == nil) {
		error = @symbol(allocationFailure);
		goto ai_out;
	    }
	    __ArrayInstPtr(resp)->a_element[5] = o; __STORE(resp, o);
	}
    }

ai_out:
    if (info) freeaddrinfo(info);

# else /* ! AI_NUMERICHOST =============================================================*/

    /*
     * Use getservbyname() / gethostByName()
     */
    struct hostent *hp;
    char **addrpp;
    int port = 0;
    int i;

    if (__serviceName) {
	struct servent *sp;
	char *__proto = 0;

	if (__isStringLike(protoArg))
	    __proto = __stringVal(protoArg);

	sp = getservbyname(__serviceName, __proto);
	if (sp == NULL) {
	    errorString = @symbol(unknownService);
	    error = __mkSmallInteger(-3);
	    goto out;
	}
	port = sp->s_port;
    }

    if (__hostName) {
#  ifdef USE_H_ERRNO
	do {
	    if (hostName == nil) {
		__hostName = 0;
	    } else if (__isStringLike(hostName)) {
		__hostName = __stringVal(hostName);
	    }
	    /* __BEGIN_INTERRUPTABLE__ is dangerous, because gethostbyname
	     * uses a static data area
	     */
	    __BEGIN_INTERRUPTABLE__
	    hp = gethostbyname(__hostName);
	    __END_INTERRUPTABLE__
	} while ((hp == NULL)
		  && (
			(h_errno == TRY_AGAIN)
		      || errno == EINTR
#   ifdef IRIX5_3
		      || (errno == ECONNREFUSED)
#   endif
		     )
	);
	if (hp == 0) {
	    switch (h_errno) {
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
	    error = __mkSmallInteger(h_errno);
	    goto out;
	}
#  else /* !USE_H_ERRNO */
	hp = gethostbyname(__hostName);
	if (hp == 0) {
	    errorString = @symbol(unknownHost);
	    error = __mkSmallInteger(-1);
	    goto out;
	}
#  endif /* !USE_H_ERRNO*/

	if (__isSmallInteger(domain) && hp->h_addrtype != __smallIntegerVal(domain)) {
	    errorString = @symbol(unknownHost);
	    error = __mkSmallInteger(-2);
	    goto out;
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
	goto out;
    }

    for (i = 0; i < cnt; i++) {
	OBJ o, resp;
	struct sockaddr_in *sa;

	resp = __ARRAY_NEW_INT(6);
	if (resp == nil) {
	    error = @symbol(allocationFailure);
	    goto out;
	}

	__ArrayInstPtr(result)->a_element[i] = resp; __STORE(result, resp);
	__ArrayInstPtr(resp)->a_element[0] = __mkSmallInteger(0);
	__ArrayInstPtr(resp)->a_element[2] = type; __STORE(result, type);
	__ArrayInstPtr(resp)->a_element[3] = proto; __STORE(result, proto);
	__PROTECT__(resp);
	o = __BYTEARRAY_NEW_INT(sizeof(*sa));
	__UNPROTECT__(resp);
	if (o == nil) {
	    error = @symbol(allocationFailure);
	    goto out;
	}
	__ArrayInstPtr(resp)->a_element[4] = o; __STORE(resp, o);
	sa = (struct sockaddr_in *)__byteArrayVal(o);
	sa->sin_port = port;

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
		    goto out;
		}
		__ArrayInstPtr(resp)->a_element[5] = o; __STORE(resp, o);
	    }
	    addrpp++;
	} else{
	    __ArrayInstPtr(resp)->a_element[1] = domain; __STORE(resp, domain);
	}
    }
# endif /* ! AI_NUMERICHOST */
}
#else /* ! HAS_SOCKET */
    error = @symbol(notImplemented);
#endif
out:;
%}.
    error notNil ifTrue:[
	errorString notNil ifTrue:[
	    ^ errorString.
	].
	^ error.
    ].
    ^ result.
! !

!UnixOperatingSystem::SocketHandle methodsFor:'accepting'!

acceptWithPeerAddressBuffer:peerOrNil
    "accept a connection on a server port.
     Returns a new SocketHandle or nil if the operation
     would block.
     If peerOrNil is set to a ByteArray, the socket address
     of the connection peer is stored into it."

    |error newFd|

%{
#if 0 && !defined(NO_SOCKET)
    int sock, newSock;
    struct sockaddr *sap;
    int alen;

    if (!__isSmallInteger(__INST(fd))) {
	error = @symbol(badFd);
	goto err;
    }
    if (peerOrNil != nil &&
	(!__isNonNilObject(peerOrNil) ||
	 (__intVal(__ClassInstPtr(__qClass(peerOrNil))->c_flags) & ARRAYMASK) != BYTEARRAY)) {
	error = @symbol(badArgument2);
	goto err;
    }

    sock = __smallIntegerVal(__INST(fd));

again:
    if (peerOrNil == nil) {
	alen = 0;
	sap = 0;
    } else {
	alen =  __byteArraySize(peerOrNil);
	sap = (struct sockaddr *)__byteArrayVal(peerOrNil);
    }
    newSock = accept(sock, sap, &alen);
    if (newSock < 0) {
	switch (errno) {
	case EINTR:
	    __HANDLE_INTERRUPTS__;
	    goto again;

#ifdef EWOULDBLOCK
	case EWOULDBLOCK:
# if defined(EAGAIN) && (EAGAIN != EWOULDBLOCK)
	case EAGAIN:
# endif
#else
# ifdef EAGAIN
	case EAGAIN:
# endif
#endif
	    RETURN(nil);

	default:
	    error = __mkSmallInteger(errno);
	    goto err;
	}
    }
    newFd = __mkSmallInteger(newSock);

err:;
#endif /* not NO_SOCKET */
%}.
    error notNil ifTrue:[
	^ self error:error.
    ].
    ^ self class for:newFd
! !

!UnixOperatingSystem::SocketHandle methodsFor:'binding'!

bindTo:socketAddress
    "low level bind -
     Set the local address of the socket"

    |error|

%{
#if 0 && !defined(NO_SOCKET)
    int sock;
    int sockaddr_size;
    int ret;

    if (!__isSmallInteger(__INST(fd))) {
	error = @symbol(badFd);
	goto err;
    }
    if (!__isNonNilObject(socketAddress) ||
	(__intVal(__ClassInstPtr(__qClass(socketAddress))->c_flags) & ARRAYMASK) != BYTEARRAY) {
	error = @symbol(badArgument1);
	goto err;
    }
    sockaddr_size = __byteArraySize(socketAddress);
    sock = __smallIntegerVal(__INST(fd));

again:
    ret = bind(sock, (struct sockaddr *)__byteArrayVal(socketAddress), sockaddr_size);
    if (ret < 0) {
	if (errno == EINTR) {
	    __HANDLE_INTERRUPTS__;
	    goto again;
	} else {
	    error = __mkSmallInteger(errno);
	    goto err;
	}
    }

    err:;
#endif /* NO_SOCKET */
%}.
    error notNil ifTrue:[
	^ self error:error.
    ].
    ^ nil

    "
     (Socket domain:#inet type:#stream)
	 bindTo:(IPSocketAddress hostAddress:IPSocketAddress anyAddress port:9999)
	 reuseAddress:false ;
     yourself
    "
! !

!UnixOperatingSystem::SocketHandle methodsFor:'connecting'!

cancelConnect
    "cancel an asynchronous connect in progress"

    |error|

%{
#if 0 && !defined(NO_SOCKET)
    int sock;
    int ret;
    struct sockaddr sockaddr;

    if (!__isSmallInteger(__INST(fd))) {
	error = @symbol(badFd);
	goto err;
    }
    sock = __smallIntegerVal(__INST(fd));

    /*
     * (dis-) connect by connecting to AF_UNSPEC socket
     */
again:
    sockaddr.sa_family = AF_UNSPEC;
    ret = connect(sock, &sockaddr, sizeof(sockaddr));
    if (ret < 0) {
       switch(errno) {
	   case EINTR:
# ifdef EAGAIN
	    case EAGAIN:
# endif
		__HANDLE_INTERRUPTS__;
		goto again;

	    default:
		error = __mkSmallInteger(errno);
		break;
	}
    }

err:;
#endif /* NO_SOCKET */
%}.

    error notNil ifTrue:[
	^ self error:error.
    ].
!

connectTo:socketAddress
    "low level connect; connect to a socket address.
     Return true if connection has been established,
     false, when the connection has been initiated but not yet
     completed. If an error occurred, an OSError is raised"

    |error|

%{
#if 0 && !defined(NO_SOCKET)
    int sock;
    int ret;
    int sockaddr_size;

    if (!__isSmallInteger(__INST(fd))) {
	error = @symbol(badFd);
	goto err;
    }
    if (!__isNonNilObject(socketAddress) ||
	(__intVal(__ClassInstPtr(__qClass(socketAddress))->c_flags) & ARRAYMASK) != BYTEARRAY) {
	error = @symbol(badArgument1);
	goto err;
    }
    sock = __smallIntegerVal(__INST(fd));
    sockaddr_size = __qSize(socketAddress);

again:
    ret = connect(sock, (struct sockaddr *)__byteArrayVal(socketAddress), sockaddr_size);
    if (ret >= 0) {
	RETURN(true)
    }

    switch(errno) {
	case EINTR:
# ifdef EAGAIN
	case EAGAIN:
# endif
	    __HANDLE_INTERRUPTS__;
	    goto again;

# if defined(EINPROGRESS) || defined(EALREADY)
#  ifdef EINPROGRESS
	case EINPROGRESS:
#  endif
#  ifdef EALREADY
	case EALREADY:
#  endif
	    RETURN(false);
# endif

    default:
	error = __mkSmallInteger(errno);
	break;
    }

err:;
#endif /* NO_SOCKET */
%}.
    error notNil ifTrue:[
	 ^ self error:error.
    ].
    ^ true

    "
     Socket newTCP connectTo:(IPSocketAddress hostAddress:IPSocketAddress local port:7)
		   withTimeout:nil.
     Socket newTCP connectTo:(IPSocketAddress hostAddress:IPSocketAddress local port:5768)
		   withTimeout:nil.
     Socket newTCP connectTo:(IPSocketAddress hostAddress:#[1 2 3 4] port:7)
		   withTimeout:nil.
    "
! !

!UnixOperatingSystem::SocketHandle methodsFor:'datagram transmission'!

receiveFrom:socketAddress buffer:aDataBuffer start:startIndex for:nBytes flags:flags
    "receive datagramm data - put address of originating host into
     anAddressBuffer, data into aBuffer. For ST-80 compatibility,
     the addressBuffer may be a non-ByteArray; then, it must understand
     the addressBytes-message (i.e. be a SocketAddress instance).
     Return the number of bytes received, or a negative number on error.

     The thread blocks until data arrives - you may want to wait before
     receiving, using #readWait or #readWaitWithTimeout:."

    |error|

%{
#if 0 && !defined(NO_SOCKET)
    OBJ oClass;
    int nInstVars, nInstBytes, objSize;
    int sock;
    struct sockaddr *saPtr;
    int alen0, alen;
    int n;
    char *cp;
    int __flags, __startIndex, __nBytes;

    if (!__isSmallInteger(__INST(fd))) {
	error = @symbol(badFd);
	goto err;
    }
    if (!__isSmallInteger(startIndex) ||
	(__startIndex = __intVal(startIndex)-1) < 0) {
	if (startIndex == nil) {
	    __startIndex = 0;
	} else {
	    error = @symbol(badArgument3);
	    goto err;
	}
    }
    if (__isSmallInteger(nBytes)) {
	__nBytes = __intVal(nBytes);
    } else if (nBytes == nil) {
	__nBytes = -1;
    } else {
	error = @symbol(badArgument4);
	goto err;
    }
    if (!__isInteger(flags)) {
	error = @symbol(badArgument5);
	goto err;
    }
    __flags = __longIntVal(flags);
    sock = __smallIntegerVal(__INST(fd));

    oClass = __Class(aDataBuffer);
    switch (__intVal(__ClassInstPtr(oClass)->c_flags) & ARRAYMASK) {
	case BYTEARRAY:
	case WORDARRAY:
	case SWORDARRAY:
	case LONGARRAY:
	case SLONGARRAY:
	case FLOATARRAY:
	case DOUBLEARRAY:
	    break;
	default:
	    error = @symbol(badArgument2);
	    goto err;
    }

    nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);
    nInstBytes = OHDR_SIZE + nInstVars * sizeof(OBJ);
    objSize = __qSize(aDataBuffer) - nInstBytes;
    nInstBytes += __startIndex;
    objSize -= __startIndex;

    if (__nBytes >= 0 &&__nBytes < objSize) {
	objSize = __nBytes;
    }

    if (socketAddress == nil) {
	alen0 = 0;
    } else {
	if (!__isNonNilObject(socketAddress) ||
	    (__intVal(__ClassInstPtr(__qClass(socketAddress))->c_flags) & ARRAYMASK) != BYTEARRAY) {
	    error = @symbol(badArgument1);
	    goto err;
	}
	alen0 = __byteArraySize(socketAddress);
    }
    saPtr = (struct sockaddr *)0;

again:
    alen = alen0;
    if (alen)
	saPtr = (struct sockaddr *)__byteArrayVal(socketAddress);
    cp = (char *)__InstPtr(aDataBuffer) + nInstBytes;
    n = recvfrom(sock, cp, objSize, __flags, saPtr, &alen);
    if (n < 0) {
	if (errno == EINTR) {
	    __HANDLE_INTERRUPTS__;
	    goto again;
	} else {
	    error = __mkSmallInteger(errno);
	    goto err;
	}
    }
    RETURN (__mkSmallInteger(n));
#endif
err: ;
%}.
    ^ self error:error.
!

sendTo:socketAddress buffer:aDataBuffer start:startIndex for:maxBytes flags:flags
    "send datagramm data - fetch address of destination host from
     anAddressBuffer, data from aDataBuffer starting at startIndex,
     sending count bytes.
     SocketAddress must be an instance of SocketAddress
     Return the number of bytes transmitted, or a negative number on error."

    |error|

%{
#if 0 && !defined(NO_SOCKET)
    OBJ oClass;
    int nInstVars, nInstBytes, objSize;
    int sock;
    int alen, n;
    struct sockaddr *saPtr;
    char *cp;
    int __flags;
    int offs, __startIndex, __maxBytes;

    if (!__isSmallInteger(__INST(fd))) {
	error = @symbol(badFd);
	goto err;
    }
    if (!__isSmallInteger(startIndex) ||
	(__startIndex = __intVal(startIndex)-1) < 0) {
	if (startIndex == nil) {
	    __startIndex = 0;
	} else {
	    error = @symbol(badArgument3);
	    goto err;
	}
    }
    if (__isSmallInteger(maxBytes)) {
	__maxBytes = __intVal(maxBytes);
    } else if (maxBytes == nil) {
	__maxBytes = -1;
    } else {
	error = @symbol(badArgument4);
	goto err;
    }
    if (!__isInteger(flags)) {
	error = @symbol(badArgument5);
	goto err;
    }
    __flags = __longIntVal(flags);
    sock = __smallIntegerVal(__INST(fd));

    oClass = __Class(aDataBuffer);
    switch (__intVal(__ClassInstPtr(oClass)->c_flags) & ARRAYMASK) {
	case BYTEARRAY:
	    offs = __startIndex;
	    break;
	case WORDARRAY:
	case SWORDARRAY:
	    offs = __startIndex * 2;
	    break;
	case LONGARRAY:
	case SLONGARRAY:
	    offs = __startIndex * 4;
	    break;
	case LONGLONGARRAY:
	case SLONGLONGARRAY:
	    offs = __startIndex * 8;
# ifdef __NEED_LONGLONG_ALIGN
	    offs += 4;
# endif
	    break;
	case FLOATARRAY:
	    offs = __startIndex * sizeof(float);
	    break;
	case DOUBLEARRAY:
	    offs = __startIndex * sizeof(double);
# ifdef __NEED_DOUBLE_ALIGN
	    offs += 4;
# endif
	    break;
	default:
	    error = @symbol(badArgument2);
	    goto err;
    }

    nInstVars = __smallIntegerVal(__ClassInstPtr(oClass)->c_ninstvars);
    nInstBytes = OHDR_SIZE + nInstVars * sizeof(OBJ);
    objSize = __qSize(aDataBuffer) - nInstBytes - offs;

    if (__maxBytes >= 0 && __maxBytes < objSize) {
# ifdef DGRAM_DEBUG
	printf("cut off ...\n");
# endif
	objSize = __maxBytes;
    }

    if (socketAddress == nil) {
	alen = 0;
    } else {
	if (! __isByteArrayLike(socketAddress)) {
	    error = @symbol(badArgument1);
	    goto err;
	}
	alen = __byteArraySize(socketAddress);
    }
    saPtr = (struct sockaddr *)0;

again:
    if (alen)
	saPtr = (struct sockaddr *)__byteArrayVal(socketAddress);
    cp = (char *)__InstPtr(aDataBuffer) + nInstBytes + offs;
    n = sendto(sock, cp, objSize, __flags, saPtr, alen);
    if (n < 0) {
	if (errno == EINTR) {
	    __HANDLE_INTERRUPTS__;
	    goto again;
	} else {
	    error = __mkSmallInteger(errno);
	    goto err;
	}
    }
    RETURN (__mkSmallInteger(n));
#endif
err: ;
%}.
    ^ self error:error.
! !

!UnixOperatingSystem::SocketHandle methodsFor:'initialization'!

domain:domainArg type:typeArg protocol:protocolArg
    "set up socket with domain, type and protocol number.
     This is a low level entry; no binding, listening or connect is done.
     All arguments must be symbols from one of
     domainArg: #AF_INET, #AF_UNIX, #AF_APPLETALK (#inet, #unix, #appletalk, #x25) ..
     type: #SOCK_STREAM, #SOCK_DGRAM (#stream, #datagram, #raw) ..
     protocol: #tcp, #udp, #raw ..
    "

    |error domainCode typeCode protocolNumber|

    domainCode := OperatingSystem domainCodeOf:domainArg.
    typeCode := OperatingSystem socketTypeCodeOf:typeArg.
    protocolArg notNil ifTrue:[
	protocolNumber := self class protocolCodeOf:protocolArg
    ].

%{
#if 0 && !defined(NO_SOCKET)
    int dom, typ, proto = 0, sock, ret;
    int on = 1;

    if (__INST(fd) != nil) {
	error = @symbol(internalError);
	goto err;
    }
    if (! __isSmallInteger(domainCode)) {
	error = @symbol(badArgument1);
	goto err;
    }
    if (! __isSmallInteger(typeArg)) {
	error = @symbol(badArgument2);
	goto err;
    }
    if (protocolNumber != nil) {
	if (!__isSmallInteger(protocolNumber)) {
	    error = @symbol(badArgument3);
	    goto err;
	}
	proto = __smallIntegerVal(protocolNumber);
    }
    dom = __smallIntegerVal(domainCode);

    /*
     * get socket-type and protocol-type
     */
    typ = __intVal(typeArg);

againSocket:
    sock = socket(dom, typ, proto);
    if (sock < 0) {
	if (errno == EINTR) {
	    __HANDLE_INTERRUPTS__;
	    goto againSocket;
	} else
# if defined(EPROTONOSUPPORT) /* for SGI */
	if (errno == EPROTONOSUPPORT && proto != 0) {
	    proto = 0;
	    goto againSocket;
	} else
# endif
	{
	    error = __mkSmallInteger(errno);
	    goto err;
	}
    }
    __INST(fd) = __mkSmallInteger(sock);

err:;
# else /* NOSOCKET */
    error = @symbol(notImplemented);
# endif /* NOSOCKET */
%}.
    error notNil ifTrue:[
	^ self error:error.
    ].
    self register.

    "
     self new domain:#inet type:#stream protocol:nil
    "
! !

!UnixOperatingSystem::SocketHandle methodsFor:'misc'!

getOptionsLevel:level name:name
    "answer a ByteArray containing the socket option value
     named name at level"

    |error bytes size|

    bytes := ByteArray new:256.

%{
#if 0 && !defined(NO_SOCKET)
    int sock;
    int intval, sz;
    char *p;

    if (!__isSmallInteger(__INST(fd))) {
	error = @symbol(badFd);
	goto err;
    }
    if (!__bothSmallInteger(level, name)) {
	error = @symbol(badArgument);
	goto err;
    }
    if (!__isByteArray(bytes)) {
	error = @symbol(internalError);
	goto err;
    }
    p = __byteArrayVal(bytes);
    sz = __byteArraySize(bytes);

    sock = __smallIntegerVal(__INST(fd));
    if (getsockopt(sock, __smallIntegerVal(level), __smallIntegerVal(name), p, &sz) < 0) {
	error = __mkSmallInteger(errno);
    }
    size = __mkSmallInteger(sz);

err:;
#endif
%}.
    error notNil ifTrue:[
	^ self error:error
    ].
    ^ bytes copyTo:size
!

listenFor:aNumber
    "start listening.
     aNumber is the number of connect indications queues
     by the operating system"

    |error|

%{
#if 0 && !defined(NO_SOCKET)
    int sock, ret;

    if (!__isSmallInteger(__INST(fd))) {
	error = @symbol(badFd);
	goto err;
    }
    if (!__isSmallInteger(aNumber)) {
	error = @symbol(badArgument1);
	goto err;
    }

    sock = __smallIntegerVal(__INST(fd));

again:
    ret = listen(sock, __smallIntegerVal(aNumber));
    if (ret < 0) {
	if (errno == EINTR) {
	    __HANDLE_INTERRUPTS__;
	    goto again;
	} else {
	    error = __mkSmallInteger(errno);
	}
    }

err:;
#endif
%}.
    error notNil ifTrue:[
	^ self error:error.
    ].
    ^ nil
!

setOptionsLevel:level name:name value:value
    "set the socket option name at level to value.
     Value may be one of SmallInteger, ByteArray or nil"

    |error|

%{
#if 0 && !defined(NO_SOCKET)
    int sock;
    int __level, __name, intval, sz;
    char *p;

    if (!__isSmallInteger(__INST(fd))) {
	error = @symbol(badFd);
	goto err;
    }
    if (__isSmallInteger(level)) {
	__level = __smallIntegerVal(level);
    } else if (level == @symbol(SOL_SOCKET)) {
	__level = SOL_SOCKET;
    } else {
	error = @symbol(badArgument1);
	goto err;
    }

    if (__isSmallInteger(name)) {
	__name = __smallIntegerVal(name);
    } else if (name == @symbol(SO_REUSEADDR)) {
	__name = SO_REUSEADDR;
    } else {
	error = @symbol(badArgument2);
	goto err;
    }

    if (__isSmallInteger(value)) {
	intval = __intVal(value);
	p = (char *) &intval;
	sz = sizeof(intval);
    } else if (__isByteArrayLike(value)) {
	p = __byteArrayVal(value);
	sz = __byteArraySize(value);
    } else {
	error = @symbol(badArgument3);
	goto err;
    }

    sock = __smallIntegerVal(__INST(fd));
    if (setsockopt(sock, __level, __name, p, sz) < 0) {
	error = __mkSmallInteger(errno);
    }
err:;
#endif
%}.
    error notNil ifTrue:[
	^ self error:error
    ].
    ^ nil.
!

shutdown:anInteger
    "inform the socket that no more I/O will happen.
     anInteger == 0   no reads will be performed
     anInteger == 1   no writes will be performed
     anInteger == 2   neither reads nor writes will be performed.
		      Pending data is discarded. This is faster tha
		      close, which may wait until pending (written)
		      data has been read by the other side"

    |error|

%{
#if 0 && !defined(NO_SOCKET)
    int ret;

    if (!__isSmallInteger(__INST(fd))) {
	error = @symbol(badFd);
	goto err;
    }
    if (!__isSmallInteger(anInteger)) {
	error = @symbol(badArgument1);
	goto err;
    }

again:
    ret = shutdown(__smallIntegerVal(__INST(fd)), __smallIntegerVal(anInteger));
    if (ret < 0) {
	if (errno == EINTR) {
	    __HANDLE_INTERRUPTS__;
	    goto again;
	} else {
	    error = __mkSmallInteger(errno);
	}
    }

err:;
#endif /*NO_SOCKET*/
%}.
    error notNil ifTrue:[
	^ self error:error
    ].
    ^ nil.
! !

!UnixOperatingSystem::SocketHandle methodsFor:'queries'!

getNameInto:socketAddress
    "answer the my own address (I am bound to this address).
     Note that this address may change after connect or accept."

    |error|

%{
#if 0 && !defined(NO_SOCKET)
    int sock;
    int sockaddr_size;
    int ret;

    if (!__isSmallInteger(__INST(fd))) {
	error = @symbol(badFd);
	goto err;
    }
    if (!__isNonNilObject(socketAddress) ||
	(__intVal(__ClassInstPtr(__qClass(socketAddress))->c_flags) & ARRAYMASK) != BYTEARRAY) {
	error = @symbol(badArgument1);
	goto err;
    }
    sockaddr_size = __byteArraySize(socketAddress);

    sock = __smallIntegerVal(__INST(fd));
    ret = getsockname(sock, (struct sockaddr *)__byteArrayVal(socketAddress), &sockaddr_size);
    if (ret < 0) {
	error = __mkSmallInteger(errno);
    }
err:;
#endif /* NO_SOCKET */
%}.
    error notNil ifTrue:[
	^ self error:error
    ].
    ^ nil.
!

getPeerInto:socketAddress
    "answer the my own address (I am bound to this address).
     Note that this address may change after connect or accept."

    |error|

%{
#if 0 && !defined(NO_SOCKET)
    int __sock;
    int __sockaddr_size;
    int __ret;

    if (!__isSmallInteger(__INST(fd))) {
	error = @symbol(badFd);
	goto err;
    }
    if (!__isNonNilObject(socketAddress) ||
	(__intVal(__ClassInstPtr(__qClass(socketAddress))->c_flags) & ARRAYMASK) != BYTEARRAY) {
	error = @symbol(badArgument1);
	goto err;
    }
    __sockaddr_size = __byteArraySize(socketAddress);

    __sock = __smallIntegerVal(__INST(fd));
    __ret = getpeername(__sock, (struct sockaddr *)__byteArrayVal(socketAddress),
				&__sockaddr_size);
    if (__ret < 0) {
	error = __mkSmallInteger(errno);
    }
err:;
#endif /* NO_SOCKET */
%}.
    error notNil ifTrue:[
	^ self error:error
    ].
    ^ nil
! !

!UnixOperatingSystem class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


UnixOperatingSystem initialize!
UnixOperatingSystem::ELFConstants initialize!
UnixOperatingSystem::FileDescriptorHandle initialize!
