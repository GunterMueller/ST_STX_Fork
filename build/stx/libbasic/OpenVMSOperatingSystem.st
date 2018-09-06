"
 COPYRIGHT (c) 1988 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

AbstractOperatingSystem subclass:#OpenVMSOperatingSystem
	instanceVariableNames:''
	classVariableNames:'HostName DomainName SlowFork CurrentDirectory'
	poolDictionaries:''
	category:'OS-OpenVMS'
!

Object subclass:#FileStatusInfo
	instanceVariableNames:'type mode uid gid size id accessed modified statusChanged path
		recordFormatNumeric recordFormat recordAttributes
		fixedHeaderSize recordSize'
	classVariableNames:''
	poolDictionaries:''
	privateIn:OpenVMSOperatingSystem
!

Object subclass:#OSProcessStatus
	instanceVariableNames:'pid status code core'
	classVariableNames:''
	poolDictionaries:''
	privateIn:OpenVMSOperatingSystem
!

!OpenVMSOperatingSystem primitiveDefinitions!
%{

#define UNIX_LIKE       /* assumption: a real operatingSystem */

#ifdef __VMS__
# undef __new
# undef HAS_WAITPID
# undef HAS_WAIT3
# undef WANT_REALPATH
# undef HAS_USLEEP
# define NO_WAITPID
# define NO_SETITIMER
# define NO_GRP_H
# define HAS_REMOVE

# ifdef __openVMS__
#  ifndef _UNISTD_H_INCLUDED_
#   include <unistd.h>
#   define _UNISTD_H_INCLUDED_
#  endif
# endif

  /*
   * req'd for additional fileInfo
   */
# include <rms.h> /* */
# include <fabdef.h>

  /*
   * req'd for subprocess support
   */
# include <iodef.h>
# include <ssdef.h>
# include <syidef.h>
# include <clidef.h>
# include <stsdef.h>
# include <dvidef.h>
# include <nam.h>
# include <descrip.h>
# include <lib$routines.h>
# include <starlet.h>

# define xxxUSE_SLOW_ALARM
# define USE_AST_TIMER

/* VMS variable length string */
struct Vstring {
  short length;
  char body[NAM$C_MAXRSS+1];
};

/* VMS typeahead-ask struct */

struct typahdask {
    short typcnt;       /* chars in buffer */
    char firstChar;     /* first character */
    char reserve1;      /* secret */
    long reserve2;      /* secret */
};

/* VMS I/O status block */
struct IOSB {
  short status, count;
  long devinfo;
};

/* VMS Item List 3 structure */
struct itm$list3 {
  short buflen;
  short itemcode;
  void *buffer;
  size_t *retlen;
};

/* ST/X maintained per-process information */

struct procInfo {
    long  returnStatus;
    long  pid;
    char  eventFlag;
    char  finished;
    struct procInfo *nextProc;
};

/*
 * move this to alphaIntern.h ...
 */
# if __VMS_VER < 70000000
#  define NO_PWD
# endif
# define NO_PWD_PASSWD
# define NO_PWD_GECOS

#endif /* __VMS__ */

/*
 * notice: although many systems' include files
 * already block against multiple inclusion, some
 * do not. Therefore, this is done here again.
 * (it does not hurt)
 */

#ifdef WANT_SHM
extern int shmctl(), shmget(), shmdt();
extern char * shmat();

# include <sys/types.h>
# define _SYS_TYPES_H_INCLUDED_

# include <sys/ipc.h>
# define _SYS_IPC_H_INCLUDED_

# include <sys/shm.h>
# define _SYS_SHM_H_INCLUDED_

#endif /* WANT_SHM */



#ifndef _SIGNAL_H_INCLUDED_
# include <signal.h>
# define _SIGNAL_H_INCLUDED_
#endif

#ifdef SYSV
# ifndef _SYS_TYPES_H_INCLUDED_
#  include <sys/types.h>
#  define _SYS_TYPES_H_INCLUDED_
# endif

# ifndef _SYS_PARAM_H_INCLUDED_
#  ifndef NO_SYS_PARAM_H
#   include <sys/param.h>
#   define _SYS_PARAM_H_INCLUDED_
#  endif
# endif

# ifndef _SYS_TIMES_H_INCLUDED_
#  include <sys/times.h>
#  define _SYS_TIMES_H_INCLUDED_
# endif

# ifndef _SYS_FILE_H_INCLUDED_
#  include <sys/file.h>
#  define _SYS_FILE_H_INCLUDED_
# endif

# ifndef _UNISTD_H_INCLUDED_
#  include <unistd.h>
#  define _UNISTD_H_INCLUDED_
# endif

# ifndef _TIME_H_INCLUDED_
#  include <time.h>
#  define _TIME_H_INCLUDED_
# endif

#else /* not SYSV */

# ifndef _SYS_TIME_H_INCLUDED_
#  include <sys/time.h>
#  define _SYS_TIME_H_INCLUDED_
# endif

# ifndef _SYS_TYPES_H_INCLUDED_
#  include <sys/types.h>
#  define _SYS_TYPES_H_INCLUDED_
# endif

#endif /* not SYSV */

#ifndef _PWD_H_INCLUDED_
# include <pwd.h>
# define _PWD_H_INCLUDED_
#endif

#ifndef NO_GRP_H
# ifndef _GRP_H_INCLUDED_
#  include <grp.h>
#  define _GRP_H_INCLUDED_
# endif
#endif

#ifndef _SYS_STAT_H_INCLUDED_
# include <sys/stat.h>
# define _SYS_STAT_H_INCLUDED_
#endif

#ifndef _SYS_FILE_H_INCLUDED_
# include <sys/file.h>
# define _SYS_FILE_H_INCLUDED_
#endif

#ifndef _ERRNO_H_INCLUDED_
# include <errno.h>
# define _ERRNO_H_INCLUDED_
#endif

#ifndef _STDIO_H_INCLUDED_
# include <stdio.h>
# define _STDIO_H_INCLUDED_
#endif

#ifndef _FCNTL_H_INCLUDED_
# include <fcntl.h>
# define _FCNTL_H_INCLUDED_
#endif

#ifndef _IOCTL_H_INCLUDED_
# ifndef __win32__
#  include <sys/ioctl.h>
#  define _IOCTL_H_INCLUDED_
# endif
#endif


#if defined (HAS_LOCALECONV)
# ifndef _LOCALE_H_INCLUDED_
#  include <locale.h>
#  define _LOCALE_H_INCLUDED_
# endif
#endif

/*
 * posix systems should define these ...
 * but on some (older) systems, they are not.
 */
#ifndef S_IXUSR
# ifdef S_IEXEC
#  define S_IXUSR S_IEXEC
#  define S_IXGRP (S_IEXEC>>3)
#  define S_IXOTH (S_IEXEC>>6)
# endif
#endif

#ifndef S_IXUSR
# define S_IXUSR 0100
# define S_IXGRP 0010
# define S_IXOTH 0001
#endif

#ifndef S_IRUSR
# define S_IRUSR 0400
# define S_IRGRP 0040
# define S_IROTH 0004
#endif

#ifndef S_IWUSR
# define S_IWUSR 0200
# define S_IWGRP 0020
# define S_IWOTH 0002
#endif

#ifndef MAXPATHLEN
# ifndef NO_SYS_PARAM_H
#  include <sys/param.h>
# endif
# ifndef MAXPATHLEN
#  define MAXPATHLEN 1024
# endif
#endif

#if defined(HAS_UNAME)
# include <sys/utsname.h>
#endif


/*
 * sigaction dummies (you won't believe these call themself ``POSIX'' systems ...)
 */
#ifndef SA_RESTART
# define SA_RESTART    0
#endif
#ifndef SA_SIGINFO
# define SA_SIGINFO    0
#endif

#if defined(HAS_SYSINFO)
# include <sys/systeminfo.h>
#endif


/*
 * on some systems errno is a macro ... check for it here
 */
#ifndef errno
 extern errno;
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
 * not all systems have time_t and off_t
 * explicit add of those we know to have ...
 */

#ifndef TIME_T
# define TIME_T long
#endif
#ifndef OFF_T
# define OFF_T  long
#endif

/*
 * where is the timezone info ?
 */
#if defined(HAS_NO_TIMEZONE)
# if defined(HAS_NO_TM_GMTOFF)
#  define TIMEZONE(tmPtr)       0
# else
#  define TIMEZONE(tmPtr)       ((tmPtr)->tm_gmtoff)
# endif
#else
# define TIMEZONE(tmPtr)       timezone
#endif

%}
! !

!OpenVMSOperatingSystem primitiveVariables!
%{

#ifdef __VMS__
static struct procInfo *procInfoHead = (struct procInfo *)0;
static struct procInfo *procInfoFree = (struct procInfo *)0;
static unsigned char procEventFlag = 1;
#endif

%}
! !

!OpenVMSOperatingSystem primitiveFunctions!
%{

#ifdef __VMS__

/* #define TRACE_STAT_CALLS /* */
/* #define TRACE_ACCESS_CALLS /* */

/*
 * a stat which retries with appended '.DIR' in case of
 * failure.
 * This allows to stat a directory.
 */
int
__vms_stat__(path, buffP)
    char *path;
    struct stat *buffP;
{
	int ret;
	int retry = 0;
	char t[MAXPATHLEN+1+5+2];

# ifdef TRACE_STAT_CALLS
	printf("===> stat('%s')\n", path);
# endif
	do {
	    ret = stat(path, buffP);
	} while ((ret < 0) && (errno == EINTR));

	if (ret < 0) {
	    /*
	     * try with appended ';0';
	     * but only, if it has no version
	     */
	    if (strchr(path, ';') == NULL) {
		strncpy(t, path, MAXPATHLEN);
		t[MAXPATHLEN] = '\0';
		strcat(t, ";0");
# ifdef TRACE_STAT_CALLS
		printf("===> stat('%s') - retry\n", t);
# endif
		do {
		    ret = stat(t, buffP);
		} while ((ret < 0) && (errno == EINTR));
		if (ret >= 0)
		    return ret;
	    }

	    /*
	     * try with appended '.DIR';
	     * but only, if it has no extension.
	     */
	    if (strchr(path, '.') == NULL) {
		strncpy(t, path, MAXPATHLEN);
		t[MAXPATHLEN] = '\0';
		strcat(t, ".DIR;0");
		retry = 1;
	    } else {
		/*
		 * try with appended 'DIR';
		 * but only, if it ends with '.'.
		 */
		if (path[strlen(path)-1] == '.') {
		    strncpy(t, path, MAXPATHLEN);
		    t[MAXPATHLEN] = '\0';
		    strcat(t, "DIR;0");
		    retry = 1;
		}
	    }

	    if (retry) {
# ifdef TRACE_STAT_CALLS
		printf("===> stat('%s') - retry\n", t);
# endif
		do {
		    ret = stat(t, buffP);
		} while ((ret < 0) && (errno == EINTR));
	    }
	}
	return ret;
}
# define stat(__path__, __buffP__)      __vms_stat__(__path__, __buffP__)

/*
 * same for access
 */
int
__vms_access__(path, mode)
    char *path;
    int mode;
{
	int ret;
	int retry = 0;
	char t[MAXPATHLEN+1+5];

	do {
	    ret = access(path, mode);
	} while ((ret < 0) && (errno == EINTR));
	if (ret < 0) {
	    /*
	     * try with appended '.DIR';
	     * but only, if it has no extension.
	     */
	    if (strchr(path, '.') == NULL) {
		strncpy(t, path, MAXPATHLEN);
		t[MAXPATHLEN] = '\0';
		strcat(t, ".DIR");
		retry = 1;
	    } else {
		if (path[strlen(path)-1] == '.') {
		    strncpy(t, path, MAXPATHLEN);
		    t[MAXPATHLEN] = '\0';
		    strcat(t, "DIR");
		    retry = 1;
		}
	    }
	    if (retry) {
		do {
		    ret = access(t, mode);
		} while ((ret < 0) && (errno == EINTR));
	    }
	}
	return ret;
}
# define access(__path__, __mode__)     __vms_access__(__path__, __mode__)

/* #define WAITDEBUG /* */
/* #define PROCESSDEBUG /* */

void
__vms_ASTChildWithInfo(pInfo)
    struct procInfo *pInfo;
{
#ifdef WAITDEBUG
	printf("__vms_ASTChildWithInfo pI=%x\n", pInfo);
#endif

	pInfo->finished = 1;
	__vmsASTChild();        /* this signals an ST/X interrupt */
}

int
__vms_waitPid(pidToWait, pStatus, pPid)
    int pidToWait;
    long *pStatus, *pPid;
{
    extern struct procInfo *procInfoHead, *procInfoFree;
    struct procInfo *pInfo, *prevInfo;

    prevInfo = 0;
#ifdef WAITDEBUG
    printf("__vms_waitPid ...\r\n", pInfo);
#endif

    for (pInfo = procInfoHead; pInfo; pInfo = pInfo->nextProc) {
#ifdef WAITDEBUG
	printf("__vms_waitPid pI=%x\r\n", pInfo);
#endif
	if (pInfo->finished) {
#ifdef WAITDEBUG
	    printf("  finished\n");
#endif
	    if ((pidToWait == -1)
	     || (pInfo->pid == pidToWait)) {
#ifdef WAITDEBUG
		printf("  pid is %d\n", pInfo->pid);
#endif
		if ((pInfo->returnStatus & STS$M_SUCCESS) != STS$M_SUCCESS)
		    *pStatus = pInfo->returnStatus;
		else
		    *pStatus = 0;
#ifdef WAITDEBUG
		printf("  status is %d (returning %d)\n", pInfo->returnStatus, *pStatus);
#endif
		*pPid = pInfo->pid;

		/*
		 * link this infoBlock back to the freeList
		 */
		if (prevInfo) {
		    prevInfo->nextProc = pInfo->nextProc;
		} else {
		    procInfoHead = pInfo->nextProc;
		}
		pInfo->nextProc = procInfoFree;
		procInfoFree = pInfo;
		return 1;
	    }
	}
    }
#ifdef WAITDEBUG
    printf("no child\r\n");
#endif
    return 0;
}

# ifndef HAS_OPENDIR

#  define lib$find_file LIB$FIND_FILE

/*
**  VMS readdir() routines.
**  Written by Rich $alz, <rsalz@bbn.com> in August, 1990.
**  This code has no copyright.
*/

/* 12-NOV-1990 added d_namlen field and special case "." name -GJC@MITECH.COM
 */

#   ifndef _STDIO_H_INCLUDED_
#    include <stdio.h>
#    define _STDIO_H_INCLUDED_
#   endif

#   ifndef _CTYPE_H_INCLUDED_
#    include <ctype.h>
#    define _CTYPE_H_INCLUDED_
#   endif

#   ifndef _ERRNO_H_INCLUDED_
#    include <errno.h>
#    define _ERRNO_H_INCLUDED_
#   endif

#   ifndef _DESCRIP_H_INCLUDED_
#    include <descrip.h>
#    define _DESCRIP_H_INCLUDED_
#   endif

#   ifndef _RMSDEF_H_INCLUDED_
#    include <rmsdef.h>
#    define _RMSDEF_H_INCLUDED_
#   endif

/*
 * actually, the following has to go into dirent.h ...
 */
/* BEGIN included dirent.h
 *
**  Header file for VMS readdir() routines.
**  Written by Rich $alz, <rsalz@bbn.com> in August, 1990.
**  This code has no copyright.
**
**  You must #include <descrip.h> before this file.
*/

/* 12-NOV-1990 added d_namlen field -GJC@MITECH.COM */

    /* Data structure returned by READDIR(). */
struct dirent {
    char        d_name[100];            /* File name            */
    int         d_namlen;
    int         vms_verscount;          /* Number of versions   */
    int         vms_versions[20];       /* Version numbers      */
};

    /* Handle returned by opendir(), used by the other routines.  You
     * are not supposed to care what's inside this structure. */
typedef struct _dirdesc {
    long                        context;
    int                         vms_wantversions;
    char                        *pattern;
    struct dirent               entry;
    struct dsc$descriptor_s     pat;
} DIR;


#define rewinddir(dirp)                 seekdir((dirp), 0L)


extern DIR              *opendir();
extern struct dirent    *readdir();
extern long             telldir();
extern void             seekdir();
extern void             closedir();
extern void             vmsreaddirversions();
/*
 * END dirent.h
 */
#define _DIRENT_H_INCLUDED_


    /* Number of elements in vms_versions array */
#define VERSIZE(e)      (sizeof e->vms_versions / sizeof e->vms_versions[0])

    /* Linked in later. */
extern char     *strrchr();
extern char     *strcpy();
/*  Don't need this when all these programs are lumped together.    RLD
extern char     *malloc();
*/

/*
**  Open a directory, return a handle for later use.
*/
DIR *
opendir(name)
    char        *name;
{
    DIR                 *dd;

    /* Get memory for the handle, and the pattern. */
    if ((dd = (DIR *)malloc(sizeof *dd)) == NULL) {
	__threadErrno = ENOMEM;
	return NULL;
    }

    if (strcmp(".",name) == 0) name = "";

    dd->pattern = malloc((unsigned int)(strlen(name) + sizeof "*.*" + 1));
    if (dd->pattern == NULL) {
	free((char *)dd);
	__threadErrno = ENOMEM;
	return NULL;
    }

    /* Fill in the fields; mainly playing with the descriptor. */
    (void)sprintf(dd->pattern, "%s*.*", name);
    dd->context = 0;
    dd->vms_wantversions = 0;
    dd->pat.dsc$a_pointer = dd->pattern;
    dd->pat.dsc$w_length = strlen(dd->pattern);
    dd->pat.dsc$b_dtype = DSC$K_DTYPE_T;
    dd->pat.dsc$b_class = DSC$K_CLASS_S;

    return dd;
}

/*
**  Set the flag to indicate we want versions or not.
*/
void
vmsreaddirversions(dd, flag)
    DIR                 *dd;
    int                 flag;
{
    dd->vms_wantversions = flag;
}

/*
**  Free up an opened directory.
*/
void
closedir(dd)
    DIR                 *dd;
{
    free(dd->pattern);
    free((char *)dd);
}

/*
**  Collect all the version numbers for the current file.
*/
static void
collectversions(dd)
    DIR                                 *dd;
{
    struct dsc$descriptor_s     pat;
    struct dsc$descriptor_s     res;
    struct dirent               *e;
    char                        *p;
    char                        buff[sizeof dd->entry.d_name];
    int                                 i;
    char                        *text;
    long                        context;

    /* Convenient shorthand. */
    e = &dd->entry;

    /* Add the version wildcard, ignoring the "*.*" put on before */
    i = strlen(dd->pattern);
    text = malloc((unsigned int)(i + strlen(e->d_name)+ 2 + 1));
    if (text == NULL)
	return;
    (void)strcpy(text, dd->pattern);
    (void)sprintf(&text[i - 3], "%s;*", e->d_name);

    /* Set up the pattern descriptor. */
    pat.dsc$a_pointer = text;
    pat.dsc$w_length = strlen(text);
    pat.dsc$b_dtype = DSC$K_DTYPE_T;
    pat.dsc$b_class = DSC$K_CLASS_S;

    /* Set up result descriptor. */
    res.dsc$a_pointer = buff;
    res.dsc$w_length = sizeof buff - 2;
    res.dsc$b_dtype = DSC$K_DTYPE_T;
    res.dsc$b_class = DSC$K_CLASS_S;

    /* Read files, collecting versions. */
    for (context = 0; e->vms_verscount < VERSIZE(e); e->vms_verscount++) {
	if (lib$find_file(&pat, &res, &context) == RMS$_NMF || context == 0)
	    break;
	buff[sizeof buff - 1] = '\0';
	if (p = strchr(buff, ';'))
	    e->vms_versions[e->vms_verscount] = atoi(p + 1);
	else
	    e->vms_versions[e->vms_verscount] = -1;
    }

    free(text);
}

/*
**  Read the next entry from the directory.
*/
struct dirent *
readdir(dd)
    DIR *dd;
{
    struct dsc$descriptor_s res;
    char                    *p;
    char                    buff[sizeof dd->entry.d_name + 10];
    int                     i;

    /* Set up result descriptor, and get next file. */
    res.dsc$a_pointer = buff;
    res.dsc$w_length = sizeof buff - 2;
    res.dsc$b_dtype = DSC$K_DTYPE_T;
    res.dsc$b_class = DSC$K_CLASS_S;
    if (lib$find_file(&dd->pat, &res, &dd->context) == RMS$_NMF
     || dd->context == 0L)
	/* None left... */
	return NULL;

    /* Force the buffer to end with a NUL. */
    buff[sizeof buff - 1] = '\0';
    for (p = buff; !isspace(*p); p++)
	;
    *p = '\0';

    /* Skip any directory component and just copy the name. */
    if (p = strchr(buff, ']'))
	(void)strcpy(dd->entry.d_name, p + 1);
    else
	(void)strcpy(dd->entry.d_name, buff);

    /* Clobber the version. */
    if (p = strchr(dd->entry.d_name, ';'))
	*p = '\0';

    /* claus: empty dirs seems to leave *.* in the buffer ... */
    if (strcmp(dd->entry.d_name, "*.*") == 0) {
	return NULL;
    }

    dd->entry.d_namlen = strlen(dd->entry.d_name);

    dd->entry.vms_verscount = 0;
    if (dd->vms_wantversions)
	collectversions(dd);
    return &dd->entry;
}

/*
**  Return something that can be used in a seekdir later.
*/
long
telldir(dd)
    DIR  *dd;
{
    return dd->context;
}

/*
**  Return to a spot where we used to be.
*/
void
seekdir(dd, pos)
    DIR  *dd;
    long pos;
{
    dd->context = pos;
}

#  define HAS_OPENDIR

# endif /* not HAS_OPENDIR */

#endif /* __VMS__ */
%}
! !

!OpenVMSOperatingSystem class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
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
    this class realizes access to most (all ?) required operating system services;
    some of it is very specific for unix, so do not depend on
    things available here in your applications
    - some may not be found in other OS's or be slightly different ...

    (On the other hand: I do not want to hide all features
     from you - in some situations it MAY be interesting to be
     able to get down to a select or fork system call easily (at least on Unix systems).
     You decide - portability vs. functionality)

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

!OpenVMSOperatingSystem class methodsFor:'initialization'!

initialize
    "initialize the class"

    ObjectMemory addDependent:self.
    HostName := nil.
    DomainName := nil.
    LastErrorNumber := nil.
    PipeFailed := false.
    SlowFork := false.

    "Modified: 13.9.1997 / 10:47:32 / cg"
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
	SlowFork := false.
    ]

    "Modified: 22.4.1996 / 13:10:43 / cg"
    "Created: 15.6.1996 / 15:22:37 / cg"
    "Modified: 7.1.1997 / 19:36:11 / stefan"
! !

!OpenVMSOperatingSystem class methodsFor:'OS signal constants'!

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
    RETURN ( __mkSmallInteger(0) );
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
    RETURN ( __mkSmallInteger(0) );
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

!OpenVMSOperatingSystem class methodsFor:'error messages'!

currentErrorNumber
    "returns the OS's last error nr (i.e. the value of errno).
     Notice, that the value of this flag is only valid immediately
     after the error occurred - it gets updated with every other
     request to the OS.
     Use lastErrorNumber - currentErrorNumber is invalidated by
     many, many internal calls."

%{  /* NOCONTEXT */

     RETURN ( __mkSmallInteger(errno) );
%}
     "
      OperatingSystem currentErrorNumber
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
     * VMS errors
     */
#ifdef EVMSERR
    if (sym == @symbol(EVMSERR)) {
	RETURN ( __mkSmallInteger(EVMSERR) );
    }
#endif

%}.
    ^ -1
!

errorSymbolAndTextForNumber:errNr
    "return an array consisting of symbol &  message string from a unix errorNumber
     (as returned by a system call).
     The returned message is in english (as found in /usr/include/errno.h)
     and should be replaced by a resource lookup before being presented to the user."

    |sym text|

%{
    /* claus:
     * I made this primitive code, since errnos are not
     * standard across unixes
     */
    char *msg = "unknown error";
    char buffer[128];
    OBJ eno = errNr;

    if (__isSmallInteger(eno)) {
	switch (__intVal(eno)) {
	    /*
	     * POSIX errnos - these should be defined
	     */
#ifdef EPERM
	    case EPERM:
		msg = "Operation not permitted";
		sym = @symbol(EPERM);
		break;
#endif
#ifdef ENOENT
	    case ENOENT:
		msg = "No such file or directory";
		sym = @symbol(ENOENT);
		break;
#endif
#ifdef ESRCH
	    case ESRCH:
		msg = "No such process";
		sym = @symbol(ESRCH);
		break;
#endif
#ifdef EINTR
	    case EINTR:
		msg = "Interrupted system call";
		sym = @symbol(EINTR);
		break;
#endif
#ifdef EIO
	    case EIO:
		msg = "I/O error";
		sym = @symbol(EIO);
		break;
#endif
#ifdef ENXIO
	    case ENXIO:
		msg = "No such device or address";
		sym = @symbol(ENXIO);
		break;
#endif
#ifdef E2BIG
	    case E2BIG:
		msg = "Arg list too long";
		sym = @symbol(E2BIG);
		break;
#endif
#ifdef ENOEXEC
	    case ENOEXEC:
		msg = "Exec format error";
		sym = @symbol(ENOEXEC);
		break;
#endif
#ifdef EBADF
	    case EBADF:
		msg = "Bad file number";
		sym = @symbol(EBADF);
		break;
#endif
#ifdef ECHILD
	    case ECHILD:
		msg = "No child processes";
		sym = @symbol(ECHILD);
		break;
#endif
#if !defined(EWOULDBLOCK) && defined(EAGAIN) && (EWOULDBLOCK != EAGAIN)
	    case EAGAIN:
		msg = "Try again";
		sym = @symbol(EAGAIN);
		break;
#endif
#ifdef ENOMEM
	    case ENOMEM:
		msg = "Out of memory";
		sym = @symbol(ENOMEM);
		break;
#endif
#ifdef EACCES
	    case EACCES:
		msg = "Permission denied";
		sym = @symbol(EACCES);
		break;
#endif
#ifdef EFAULT
	    case EFAULT:
		msg = "Bad address";
		sym = @symbol(EFAULT);
		break;
#endif
#ifdef EBUSY
	    case EBUSY:
		msg = "Device or resource busy";
		sym = @symbol(EBUSY);
		break;
#endif
#ifdef EEXIST
	    case EEXIST:
		msg = "File exists";
		sym = @symbol(EEXIST);
		break;
#endif
#ifdef EXDEV
	    case EXDEV:
		msg = "Cross-device link";
		sym = @symbol(EXDEV);
		break;
#endif
#ifdef ENODEV
	    case ENODEV:
		msg = "No such device";
		sym = @symbol(ENODEV);
		break;
#endif
#ifdef ENOTDIR
	    case ENOTDIR:
		msg = "Not a directory";
		sym = @symbol(ENOTDIR);
		break;
#endif
#ifdef EISDIR
	    case EISDIR:
		msg = "Is a directory";
		sym = @symbol(EISDIR);
		break;
#endif
#ifdef EINVAL
	    case EINVAL:
		msg = "Invalid argument";
		sym = @symbol(EINVAL);
		break;
#endif
#ifdef ENFILE
	    case ENFILE:
		msg = "File table overflow";
		sym = @symbol(ENFILE);
		break;
#endif
#ifdef EMFILE
	    case EMFILE:
		msg = "Too many open files";
		sym = @symbol(EMFILE);
		break;
#endif
#ifdef ENOTTY
	    case ENOTTY:
		msg = "Not a typewriter";
		sym = @symbol(ENOTTY);
		break;
#endif
#ifdef EFBIG
	    case EFBIG:
		msg = "File too large";
		sym = @symbol(EFBIG);
		break;
#endif
#ifdef ENOSPC
	    case ENOSPC:
		msg = "No space left on device";
		sym = @symbol(ENOSPC);
		break;
#endif
#ifdef ESPIPE
	    case ESPIPE:
		msg = "Illegal seek";
		sym = @symbol(ESPIPE);
		break;
#endif
#ifdef EROFS
	    case EROFS:
		msg = "Read-only file system";
		sym = @symbol(EROFS);
		break;
#endif
#ifdef EMLINK
	    case EMLINK:
		msg = "Too many links";
		sym = @symbol(EMLINK);
		break;
#endif
#ifdef EPIPE
	    case EPIPE:
		msg = "Broken pipe";
		sym = @symbol(EPIPE);
		break;
#endif
#ifdef EDOM
	    case EDOM:
		msg = "Math argument out of domain";
		sym = @symbol(EDOM);
		break;
#endif
#ifdef ERANGE
	    case ERANGE:
		msg = "Math result not representable";
		sym = @symbol(ERANGE);
		break;
#endif
#ifdef EDEADLK
# if EDEADLK != EWOULDBLOCK
	    case EDEADLK:
		msg = "Resource deadlock would occur";
		sym = @symbol(EDEADLK);
		break;
# endif
#endif
#ifdef ENAMETOOLONG
	    case ENAMETOOLONG:
		msg = "File name too long";
		sym = @symbol(ENAMETOOLONG);
		break;
#endif
#ifdef ENOLCK
	    case ENOLCK:
		msg = "No record locks available";
		sym = @symbol(ENOLCK);
		break;
#endif
#ifdef ENOSYS
	    case ENOSYS:
		msg = "Function not implemented";
		sym = @symbol(ENOSYS);
		break;
#endif
#if defined(ENOTEMPTY) && (ENOTEMPTY != EEXIST)
	    case ENOTEMPTY:
		msg = "Directory not empty";
		sym = @symbol(ENOTEMPTY);
		break;
#endif
#ifdef EILSEQ
	    case EILSEQ:
		msg = "Illegal byte sequence";
		sym = @symbol(EILSEQ);
		break;
#endif
	    /*
	     * XPG3 errnos - defined on most systems
	     */
#ifdef ENOTBLK
	    case ENOTBLK:
		msg = "Block device required";
		sym = @symbol(ENOTBLK);
		break;
#endif
#ifdef ETXTBSY
	    case ETXTBSY:
		msg = "Text file busy";
		sym = @symbol(ETXTBSY);
		break;
#endif
	    /*
	     * some others
	     */
#ifdef EWOULDBLOCK
	    case EWOULDBLOCK:
		msg = "Operation would block";
		sym = @symbol(EWOULDBLOCK);
		break;
#endif
#ifdef ENOMSG
	    case ENOMSG:
		msg = "No message of desired type";
		sym = @symbol(ENOMSG);
		break;
#endif
#ifdef ELOOP
	    case ELOOP:
		msg = "Too many levels of symbolic links";
		sym = @symbol(ELOOP);
		break;
#endif

	    /*
	     * some stream errors
	     */
#ifdef ETIME
	    case ETIME:
		msg = "Timer expired";
		sym = @symbol(ETIME);
		break;
#endif
#ifdef ENOSR
	    case ENOSR:
		msg = "Out of streams resources";
		sym = @symbol(ENOSR);
		break;
#endif
#ifdef ENOSTR
	    case ENOSTR:
		msg = "Device not a stream";
		sym = @symbol(ENOSTR);
		break;
#endif
#ifdef ECOMM
	    case ECOMM:
		msg = "Communication error on send";
		sym = @symbol(ECOMM);
		break;
#endif
#ifdef EPROTO
	    case EPROTO:
		msg = "Protocol error";
		sym = @symbol(EPROTO);
		break;
#endif
	    /*
	     * nfs errors
	     */
#ifdef ESTALE
	    case ESTALE:
		msg = "Stale NFS file handle";
		sym = @symbol(ESTALE);
		break;
#endif
#ifdef EREMOTE
	    case EREMOTE:
		msg = "Too many levels of remote in path";
		sym = @symbol(EREMOTE);
		break;
#endif
	    /*
	     * some networking errors
	     */
#ifdef EINPROGRESS
	    case EINPROGRESS:
		msg = "Operation now in progress";
		sym = @symbol(EINPROGRESS);
		break;
#endif
#ifdef EALREADY
	    case EALREADY:
		msg = "Operation already in progress";
		sym = @symbol(EALREADY);
		break;
#endif
#ifdef ENOTSOCK
	    case ENOTSOCK:
		msg = "Socket operation on non-socket";
		sym = @symbol(ENOTSOCK);
		break;
#endif
#ifdef EDESTADDRREQ
	    case EDESTADDRREQ:
		msg = "Destination address required";
		sym = @symbol(EDESTADDRREQ);
		break;
#endif
#ifdef EMSGSIZE
	    case EMSGSIZE:
		msg = "Message too long";
		sym = @symbol(EMSGSIZE);
		break;
#endif
#ifdef EPROTOTYPE
	    case EPROTOTYPE:
		msg = "Protocol wrong type for socket";
		sym = @symbol(EPROTOTYPE);
		break;
#endif
#ifdef ENOPROTOOPT
	    case ENOPROTOOPT:
		msg = "Protocol not available";
		sym = @symbol(ENOPROTOOPT);
		break;
#endif
#ifdef EPROTONOSUPPORT
	    case EPROTONOSUPPORT:
		msg = "Protocol not supported";
		sym = @symbol(EPROTONOSUPPORT);
		break;
#endif
#ifdef ESOCKTNOSUPPORT
	    case ESOCKTNOSUPPORT:
		msg = "Socket type not supported";
		sym = @symbol(ESOCKTNOSUPPORT);
		break;
#endif
#ifdef EOPNOTSUPP
	    case EOPNOTSUPP:
		msg = "Operation not supported on socket";
		sym = @symbol(EOPNOTSUPP);
		break;
#endif
#ifdef EPFNOSUPPORT
	    case EPFNOSUPPORT:
		msg = "Protocol family not supported";
		sym = @symbol(EPFNOSUPPORT);
		break;
#endif
#ifdef EAFNOSUPPORT
	    case EAFNOSUPPORT:
		msg = "Address family not supported by protocol family";
		sym = @symbol(EAFNOSUPPORT);
		break;
#endif
#ifdef EADDRINUSE
	    case EADDRINUSE:
		msg = "Address already in use";
		sym = @symbol(EADDRINUSE);
		break;
#endif
#ifdef EADDRNOTAVAIL
	    case EADDRNOTAVAIL:
		msg = "Can\'t assign requested address";
		sym = @symbol(EADDRNOTAVAIL);
		break;
#endif
#ifdef ETIMEDOUT
	    case ETIMEDOUT:
		msg = "Connection timed out";
		sym = @symbol(ETIMEDOUT);
		break;
#endif
#ifdef ECONNREFUSED
	    case ECONNREFUSED:
		msg = "Connection refused";
		sym = @symbol(ECONNREFUSED);
		break;
#endif
#ifdef ENETDOWN
	    case ENETDOWN:
		msg = "Network is down";
		sym = @symbol(ENETDOWN);
		break;
#endif
#ifdef ENETUNREACH
	    case ENETUNREACH:
		msg = "Network is unreachable";
		sym = @symbol(ENETUNREACH);
		break;
#endif
#ifdef ENETRESET
	    case ENETRESET:
		msg = "Network dropped conn due to reset";
		sym = @symbol(ENETRESET);
		break;
#endif
#ifdef ECONNABORTED
	    case ECONNABORTED:
		msg = "Software caused connection abort";
		sym = @symbol(ECONNABORTED);
		break;
#endif
#ifdef ECONNRESET
	    case ECONNRESET:
		msg = "Connection reset by peer";
		sym = @symbol(ECONNRESET);
		break;
#endif
#ifdef EISCONN
	    case EISCONN:
		msg = "Socket is already connected";
		sym = @symbol(EISCONN);
		break;
#endif
#ifdef ENOTCONN
	    case ENOTCONN:
		msg = "Socket is not connected";
		sym = @symbol(ENOTCONN);
		break;
#endif
#ifdef ESHUTDOWN
	    case ESHUTDOWN:
		msg = "Can't send after socket shutdown";
		sym = @symbol(ESHUTDOWN);
		break;
#endif
#ifdef EHOSTDOWN
	    case EHOSTDOWN:
		msg = "Host is down";
		sym = @symbol(EHOSTDOWN);
		break;
#endif
#ifdef EHOSTUNREACH
	    case EHOSTUNREACH:
		msg = "No route to host";
		sym = @symbol(EHOSTUNREACH);
		break;
#endif

#ifdef __VMS__
# ifdef EVMSERR
	    case EVMSERR:
		msg = "VMS system request error";
		sym = @symbol(EVMSERR);
		break;
# endif
#endif

	    default:
		{
		    __BEGIN_PROTECT_REGISTERS__
		    sprintf(buffer, "ErrorNr: %d", __intVal(eno));
		    __END_PROTECT_REGISTERS__
		}
		msg = buffer;
		sym = @symbol(ERROR_OTHER);
		break;
	}
	text = __MKSTRING(msg);
    } else {
	text = nil;
	sym = nil;
    }
%}.
    ^ Array with:sym with:text

    "
     OperatingSystem errorSymbolAndTextForNumber:4
    "
! !

!OpenVMSOperatingSystem class methodsFor:'executing OS commands'!

commandAndArgsForOSCommand:aCommandString
    "get a shell and shell arguments for command execution"

    |shell args|

    shell := ''.                "/ always DCL
    args := aCommandString.
    ^ Array with:shell with:args

    "Modified: 2.5.1997 / 11:56:36 / cg"
    "Modified: 20.1.1998 / 16:57:19 / md"
!

exec:aCommandPath withArguments:argArray fileDescriptors:fdArray fork:doFork newPgrp:newPgrp
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

     fdArray contains the filedescriptors, to be used for the child (if fork is true).
	fdArray[1] = 15 -> use fd 15 as stdin.
	If an element of the array is set to nil, the corresponding filedescriptor
	will be closed for the child.
	fdArray[0] == StdIn for child
	fdArray[1] == StdOut for child
	fdArray[2] == StdErr for child
	on VMS, these must be channels as returned by createMailBox.

     If newPgrp is true, the subprocess will be established in a new process group.
	The processgroup will be equal to id.
	newPgrp is not used on WIN32 and VMS systems.

     Notice: this used to be two separate ST-methods; however, in order to use
	    vfork on some machines, it had to be merged into one, to avoid write
	    accesses to ST/X memory from the vforked-child.
	    The code below only does read accesses."

    |channelIn channelOut mbxName_in mbxName_out|

    fdArray notNil ifTrue:[
	(channelIn := fdArray at:1) notNil ifTrue:[
	    mbxName_in := self mailBoxNameOf:channelIn.
	].
	(channelOut := fdArray at:2) notNil ifTrue:[
	    mbxName_out := self mailBoxNameOf:channelOut.
	].
    ].

%{  /* STACK: 16000 */

#ifdef __VMS__
    /*
     * if fork is false, chain to another command (not yet supported)
     * otherwise, spawn a subprocess and let it execute the command.
     * Currently, only the forking version is supported (who chains anyway ?)
     * Only stdIn & stdOut are allowed in fdArray;
     */
    char fullCmdLine[1024];
    char cliBuffer[1024];

    if (__isString(aCommandPath) && __isString(argArray)) {
	struct dsc$descriptor_s cmddsc, clidsc, in_mbxdsc, out_mbxdsc;
	int status;
	static struct Vstring in_mbxname, out_mbxname;
	int in_channel, out_channel;
	int flags;
	struct procInfo *pInfo;
	char *cli = (char *)0;
	extern void __vms_ASTChildWithInfo();
	int l;

	if (__isSmallInteger(channelIn)) {
	    in_channel = __intVal(channelIn);
	} else {
	    in_channel = 0;
	}
	if (__isSmallInteger(channelOut)) {
	    out_channel = __intVal(channelOut);
	} else {
	    out_channel = 0;
	}

	/*
	 * generate command line & cli line
	 */
	if (aCommandPath && ((l = __stringSize(__stringVal(aCommandPath))) > 0)) {
	    if (l < (sizeof(cliBuffer)-1)) {
		strncpy(cliBuffer, __stringVal(aCommandPath), l);
		cliBuffer[l] = '\0';
	    } else {
		cliBuffer[0] = '\0';
	    }
	    if (cliBuffer[0]) {
		cli = cliBuffer;
	    }
	}
	strcpy( fullCmdLine, __stringVal(argArray) );
# ifdef PROCESSDEBUG
	printf("DCL command: <%s>\n", fullCmdLine);
# endif

	/*
	 * get the mailBox names for in & out
	 */
	if (__isString(mbxName_in)) {
	    strcpy(in_mbxname.body, __stringVal(mbxName_in));
	    in_mbxname.length = strlen(__stringVal(mbxName_in));

# ifdef PROCESSDEBUG
	    printf("DCL input: <%s>\n", __stringVal(mbxName_in));
# endif
	    /* Build descriptors for in & out */
	    in_mbxdsc.dsc$w_length  = in_mbxname.length;
	    in_mbxdsc.dsc$b_dtype   = DSC$K_DTYPE_T;
	    in_mbxdsc.dsc$b_class   = DSC$K_CLASS_S;
	    in_mbxdsc.dsc$a_pointer = in_mbxname.body;
	}
	if (__isString(mbxName_out)) {
	    strcpy(out_mbxname.body, __stringVal(mbxName_out));
	    out_mbxname.length = __stringSize(__stringVal(mbxName_out));

# ifdef PROCESSDEBUG
	    printf("DCL output: <%s>\n", __stringVal(mbxName_out));
# endif
	    out_mbxdsc.dsc$w_length  = out_mbxname.length;
	    out_mbxdsc.dsc$b_dtype   = DSC$K_DTYPE_T;
	    out_mbxdsc.dsc$b_class   = DSC$K_CLASS_S;
	    out_mbxdsc.dsc$a_pointer = out_mbxname.body;
	}

	/*
	 * Build descriptor for command line
	 */
	cmddsc.dsc$w_length  = strlen(fullCmdLine);
	cmddsc.dsc$b_dtype   = DSC$K_DTYPE_T;
	cmddsc.dsc$b_class   = DSC$K_CLASS_S;
	cmddsc.dsc$a_pointer = fullCmdLine;

	/*
	 * optional cli descriptor
	 */
	if (cli) {
	    clidsc.dsc$w_length  = strlen(cli);
	    clidsc.dsc$b_dtype   = DSC$K_DTYPE_T;
	    clidsc.dsc$b_class   = DSC$K_CLASS_S;
	    clidsc.dsc$a_pointer = cli;
	}

	flags = CLI$M_NOWAIT;

	if (doFork == true) {
# ifdef NOTDEF
	    /*
	     * Allocate an event flag to signal process termination
	     */
	    status = LIB$GET_EF(&siop->event_flag);
	    if (status != SS$_NORMAL) {
		vaxc$errno = status;
		errno = EVMSERR;
		if (in_channel) SYS$DASSGN(in_channel);
		if (out_channel) SYS$DASSGN(out_channel);
		fprintf(stderr, "OpenVMSOperatingSystem [warning]: LIB$GET_EF failed\n");
		RETURN (nil);
	    }
# endif

	    /*
	     * get a new procInfo struct
	     */
	    {
		pInfo = procInfoFree;
		if (pInfo) {
		    procInfoFree = pInfo->nextProc;
		} else {
		    pInfo = (struct procInfo *)malloc(sizeof(struct procInfo));
		}
	    }

	    pInfo->finished = 0;

	    pInfo->nextProc = procInfoHead;
	    procInfoHead = pInfo;

# ifdef PROCESSDEBUG
	    printf("spawn pInfo=%x\n", pInfo);
# endif
	    /*
	     * now, spawn
	     */
	    status = LIB$SPAWN(&cmddsc,
			       (in_channel ? &in_mbxdsc : 0),
			       (out_channel ? &out_mbxdsc : 0),
			       &flags,
			       0,               /* process name */
			       &(pInfo->pid),
			       &(pInfo->returnStatus),
			       &procEventFlag,
			       __vms_ASTChildWithInfo,
			       pInfo,           /* AST argument */
			       0,               /* prompt */
			       (cli ? &clidsc : 0)
			      );

	    if (status != SS$_NORMAL) {
		procInfoHead = pInfo->nextProc;

		pInfo->nextProc = procInfoFree;
		procInfoFree = pInfo;

		vaxc$errno = status;
		errno = EVMSERR;
		if (in_channel) SYS$DASSGN(in_channel);
		if (out_channel) SYS$DASSGN(out_channel);
		fprintf(stderr, "OpenVMSOperatingSystem [warning]: LIB$SPAWN failed: %d\n", status);

		RETURN (nil);
	    }

# ifdef PROCESSDEBUG
	    printf("pid = %d\n", pInfo->pid);
# endif
	    /*
	     * got the pid ...
	     */
	    RETURN (__MKUINT(pInfo->pid));
	} else {
	    /* should never be called that way ... */
	}
    }
#endif /* VMS */
%}.
    "
     path-argument not string
     or argArray not an array/nil
     or malloc failed
     or not supported by OS
    "
    ^ self primitiveFailed
!

exec:aCommandPath withArguments:argArray fileDescriptors:fdArray fork:doFork newPgrp:newPgrp inDirectory:aDirectory
    "Internal lowLevel entry for combined fork & exec for WIN32"

    ^ self primitiveFailed

    "Modified: 31.1.1998 / 10:54:24 / md"
!

executeCommand:aCommandString inDirectory:aDirectory
    "much like #executeCommand:, but changes the current directory
     for the command. Since this is OS specific, use this instead of
     hardwiring any 'cd ..' command strings into your applictions."

    |tmpComFile cmd ret|

    tmpComFile := OpenVMSOperatingSystem createCOMFileForVMSCommand:aCommandString in:aDirectory.
    cmd := '@' , tmpComFile osName.

    [
	ret := self executeCommand:cmd.
    ] valueNowOrOnUnwindDo:[
	tmpComFile delete.
    ].
    ^ ret

    "Modified: 20.1.1998 / 17:03:03 / md"
!

executeCommand:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream errorTo:anExternalErrStream onError:aBlock
    "execute the unix command specified by the argument, aCommandString.
     The commandString is passed to a shell for execution - see the description of
     'sh -c' in your UNIX manual.
     Return true if successful.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument."

    |pid exitStatus sema|

    sema := Semaphore new name:'OS command wait'.

    pid := Processor
		monitor:[
		    self
			startProcess:aCommandString
			inputFrom:anExternalInStream
			outputTo:anExternalOutStream
			errorTo:anExternalErrStream.
		]
		action:[:status |
		    status stillAlive ifFalse:[
			exitStatus := status.
			self closePid:pid.
			sema signal
		    ].
		].
    pid notNil ifTrue:[
	sema wait.
    ] ifFalse:[
	exitStatus := OSProcessStatus processCreationFailure.
    ].

    exitStatus success ifFalse:[
	^ aBlock value:exitStatus
    ].
    ^ true.

    "Modified: 25.3.1997 / 11:02:02 / stefan"
    "Modified: 19.4.1997 / 18:15:04 / cg"
    "Modified: 28.1.1998 / 14:46:36 / md"
!

executeCommand:aCommandString onError:aBlock
    "execute the unix command specified by the argument, aCommandString.
     The commandString is passed to a shell for execution - see the description of
     'sh -c' in your UNIX manual.
     Return true if successful.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument."

    |pid exitStatus sema|

    sema := Semaphore new name:'OS command wait'.

    pid := Processor
		monitor:[self startProcess:aCommandString]
		action:[:status |
			status stillAlive ifFalse:[
			    exitStatus := status.
			    self closePid:pid.
			    sema signal
			].
		].
    pid notNil ifTrue:[
	sema wait.
    ] ifFalse:[
	exitStatus := OSProcessStatus processCreationFailure.
    ].

    exitStatus success ifFalse:[
	^ aBlock value:exitStatus
    ].
    ^ true.

    "
     OperatingSystem executeCommand:'sleep 30' onError:[].
     OperatingSystem executeCommand:'pwd' onError:[:status|status inspect].
     OperatingSystem executeCommand:'ls -l' onError:[].
     OperatingSystem executeCommand:'invalidCommand' onError:[:status| status inspect].
     OperatingSystem executeCommand:'rm /tmp/foofoofoofoo'onError:[:status | status inspect].
    "

    "Created: 22.12.1995 / 14:49:59 / stefan"
    "Modified: 25.3.1997 / 11:06:43 / stefan"
    "Modified: 19.4.1997 / 18:14:41 / cg"
    "Modified: 28.1.1998 / 14:46:56 / md"
!

executeCommand:aCommandString onError:aBlock inDirectory:aDirectory
    "execute the unix command specified by the argument, aCommandString.
     The commandString is passed to a shell for execution - see the description of
     'sh -c' in your UNIX manual.
     Return true if successful.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument."

    |pid exitStatus sema|

    sema := Semaphore new name:'OS command wait'.

    pid := Processor
		monitor:[self startProcess:aCommandString inDirectory:aDirectory]
		action:[:status |
			status stillAlive ifFalse:[
			    exitStatus := status.
			    self closePid:pid.
			    sema signal
			].
		].
    pid notNil ifTrue:[
	sema wait.
    ] ifFalse:[
	exitStatus := OSProcessStatus processCreationFailure.
    ].

    exitStatus success ifFalse:[
	^ aBlock value:exitStatus
    ].
    ^ true.

    "
     OperatingSystem executeCommand:'sleep 30' onError:[].
     OperatingSystem executeCommand:'pwd' onError:[:status|status inspect].
     OperatingSystem executeCommand:'ls -l' onError:[].
     OperatingSystem executeCommand:'invalidCommand' onError:[:status| status inspect].
     OperatingSystem executeCommand:'rm /tmp/foofoofoofoo'onError:[:status | status inspect].
    "

    "Created: 28.1.1998 / 14:12:15 / md"
!

fork
    "fork a new (HEAVY-weight) unix process.
     Not supported with MSDOS & VMS systems.
     Dont confuse this with Block>>fork, which creates
     lightweight smalltalk processes. This method will return
     0 to the child process, and a non-zero number (which is the childs
     unix-process-id) to the parent (original) process.

     In normal situations, you dont need to use this low level entry; see
     #startProcess: and #executCommand: for higher level interfaces."

    ^ UnsupportedOperationSignal raise

    "
     |id|

     id := OpenVMSOperatingSystem fork.
     id == 0 ifTrue:[
	'I am the child process' printCR.
	OpenVMSOperatingSystem exit
     ]
    "
!

getStatusOfProcess:aProcessId
    "wait for a process to terminate and fetch its exit status.
     This is required to avoid zombie processes."

%{
    int status;

    if (__isSmallInteger(aProcessId)) {
	pid_t pid = (pid_t)(__intVal(aProcessId));
	{

#ifdef  NO_WAITPID
	    pid_t child;

	    do {
		__BEGIN_INTERRUPTABLE__
		child = __wait (&status);
		__END_INTERRUPTABLE__
		if (child < 0 && errno != EINTR) {
		    fprintf(stderr, "OS: child-wait errno=%d\n", errno);
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
		fprintf(stderr, "OS: child-waitpid errno=%d\n", errno);
		status = -1;
	    }
#endif /* NO_WAITPID */
	}
	RETURN ( __mkSmallInteger(status));
    }
%}.
    self primitiveFailed

!

getVMSSymbol:aSymbolString
    "get a symbols value, or nil if there is none"

    |p l i1 i2|

    p := PipeStream readingFrom:'sho sym ' , aSymbolString.
    p notNil ifTrue:[
	l := p nextLIne.
	p close.
    ].
    l notNil ifTrue:[
	i1 := l indexOf:$".
	i1 ~~ 0 ifTrue:[
	    i2 := l lastIndexOf:$".
	    (i2 ~~ 0 and:[i2 > i1]) ifTrue:[
		^ l copyFrom:i1+1 to:i2-1
	    ]
	].
    ].
    ^ nil
!

pathOfCommand:aCommand
    "find where aCommand's executable file is;
     return its full pathName if there is such a command, otherwise
     return nil."

    |path f fExt|

    aCommand asFilename isAbsolute ifTrue:[
	^ aCommand
    ].

    (self getVMSSymbol:aCommand) notNil ifTrue:[
	^ aCommand
    ].
    ^ nil

    "Modified: 24.7.1997 / 17:19:04 / cg"
!

startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream errorTo:anExternalErrStream
    "start executing the OS command as specified by the argument, aCommandString
     as a separate process; do not wait for the command to finish.
     The commandString is passed to a shell for execution - see the description of
     'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     The command gets stdIn, stdOut and stdErr assigned from the arguments;
     each may be nil.
     Return the processId if successful, nil otherwise.
     Use #monitorPid:action: for synchronization and exec status return,
     or #killProcess: to stop it."

    |in out err shellAndArgs|

    aCommandString isNil ifTrue:[^ nil].

    anExternalInStream notNil ifTrue:[
	in := anExternalInStream fileDescriptor.
"/    ] ifFalse:[
"/      self isUNIXlike ifTrue:[
"/          in := '/dev/null' asFilename readStream fileDescriptor
"/      ]
    ].
    anExternalOutStream notNil ifTrue:[
	out := anExternalOutStream fileDescriptor.
    ].
    anExternalErrStream notNil ifTrue:[
	err := anExternalErrStream fileDescriptor.
    ].

    shellAndArgs := self commandAndArgsForOSCommand:aCommandString.
    ^ self
	exec:(shellAndArgs at:1)
	withArguments:(shellAndArgs at:2)
	fileDescriptors:(Array with:in with:out with:err)
	fork:true
	newPgrp:false.

    "blocking at current prio (i.e. only higher prio threads execute):

     OperatingSystem executeCommand:'ls -l > out'.
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

    "Created: 29.2.1996 / 12:31:29 / cg"
    "Modified: 21.3.1997 / 10:04:35 / dq"
    "Modified: 2.5.1997 / 12:18:20 / cg"
    "Modified: 15.7.1997 / 16:03:51 / stefan"
! !

!OpenVMSOperatingSystem class methodsFor:'directory access'!

nextLinkInfoFrom:aDirectoryStream dirPointer:dirPointer
    "return a FileStatusInfo entry for the next entry, when reading from a directory.
     Under UNIX, the returned fileStatuInfo ONLY contains the name of the file,
     whereas under Windows, it contains the full info (incl. fileSize, access rights etc.).
     The reason is that under wndows, the ReadNextEntry system call does this, whereas the
     the corresponding unix read from a readdir only returns the name."

    |entry isUnix error|
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
	^ entry.
    ].
    ^ aDirectoryStream pastEndRead
! !

!OpenVMSOperatingSystem class methodsFor:'file access'!

closeFd:anInteger
    "low level close of a filedescriptor"

%{
     if (__isSmallInteger(anInteger)) {
	close(__intVal(anInteger));
	RETURN(self);
     }
%}.
     ^ self primitiveFailed.
!

createDirectory:aPathName
    "create a new directory with name 'aPathName', which may be an absolute
     path, or relative to the current directory.
     Return true if successful (or the directory existed already), false if failed.
     This is a low-level entry - use Filename protocol for compatibility."

    "/ if it already exists this is ok

    (self isDirectory:aPathName) ifTrue:[^ true].

%{
    if (__isString(aPathName)) {
	int ret;

	ret = mkdir(__stringVal(aPathName), 0755);
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN (false);
	}
	RETURN (true);
      }
%}.

"/    self isUNIXlike ifTrue:[
"/      ^ self executeCommand:('mkdir 2>/dev/null ', newPathName)
"/    ].
"/    ^ self executeCommand:('mkdir ', newPathName)

    self primitiveFailed

    "
     OperatingSystem createDirectory:'foo'
    "

    "Modified: 20.12.1995 / 11:24:13 / stefan"
    "Modified: 29.6.1996 / 14:06:54 / cg"
!

linkFile:oldPath to:newPath
    "link the file 'oldPath' to 'newPath'. The link will be a hard link.
     Return true if successful, false if not."

    (oldPath isString not or:[newPath isString not]) ifTrue:[
	"/
	"/ bad argument(s) given
	"/
	^ self primitiveFailed
    ].

    "/
    "/ this OperatingSystem does not support links
    "/
    ^ UnsupportedOperationSignal raise
!

recursiveCopyDirectory:sourcePathName to:destination
    "copy the directory named 'sourcePathName' and all contained files/directories to 'destination'.
     Return true if successful."

    "/
    "/ this OperatingSystem does not support links
    "/
    ^ false

    "Modified: / 4.6.1998 / 04:29:49 / cg"
!

recursiveRemoveDirectory:fullPathName
    "remove the directory named 'fullPathName' and all contained files/directories.
     Return true if successful."

    "/
    "/ this OperatingSystem does not support links
    "/
    ^ false.

    "
     OperatingSystem recursiveCreateDirectory:'foo/bar/baz'
     OperatingSystem recursiveRemoveDirectory:'foo'
    "

    "Modified: 7.3.1996 / 15:26:30 / cg"
!

removeDirectory:fullPathName
    "remove the directory named 'fullPathName'.
     The directory must be empty and you must have appropriate access rights.
     Return true if successful, false if directory is not empty or no permission.
     This is a lowLevel entry - use Filename protocol for compatibility."

%{
    int ret;

    if (__isString(fullPathName)) {
#if defined(HAS_REMOVE)
	__BEGIN_INTERRUPTABLE__
	do {
	    errno = 0;
	    ret = remove((char *) __stringVal(fullPathName));
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( false );
	}
	RETURN (true);
#endif /* HAS_REMOVE */
    }
%}.
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
    "remove the file named 'fullPathName'; return true if successful.
     This is a lowLevel entry - use Filename protocol for compatibility."

%{
    int ret;

    if (__isString(fullPathName)) {
#if defined(HAS_REMOVE)
	__BEGIN_INTERRUPTABLE__
	do {
	    errno = 0;
	    ret = remove((char *) __stringVal(fullPathName));
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( false );
	}
	RETURN (true);
#endif
    }
%}.
    ^ self primitiveFailed
!

renameFile:oldPath to:newPath
    "rename the file 'oldPath' to 'newPath'.
     Someone else has to care for the names to be correct and
     correct for the OS used - therefore, this should not be called
     directlt. Instead, use Filename protocol to rename; this cares for
     any invalid names.
     Returns true if successful, false if not"

%{
    int ret, eno;

    if (__isString(oldPath) && __isString(newPath)) {
#if defined(HAS_RENAME)
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = rename((char *) __stringVal(oldPath), (char *) __stringVal(newPath));
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( false );
	}
	RETURN (true);
#else
	RETURN (false);
#endif
    }
%}.
    ^ self primitiveFailed

    "
     OperatingSystem renameFile:'foo' to:'bar'
    "
!

truncateFile:aPathName to:newSize
    "change a files size return true on success, false on failure.
     This may not be supported on all architectures.

     This is a low-level entry - use Filename protocol."

%{
#ifdef HAS_TRUNCATE
    int ret;

    if (__isString(aPathName)
     && __isSmallInteger(newSize)) {
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = truncate((char *) __stringVal(aPathName), __intVal(newSize));
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( false );
	}
	RETURN (true);
    }
#else
# ifdef HAS_FTRUNCATE
    int ret;
    int fd;

    if (__isString(aPathName)
     && __isSmallInteger(newSize)) {
	do {
	    fd = open((char *) __stringVal(aPathName), 2);
	} while (fd < 0 && errno == EINTR);
	if (fd < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( false );
	}

	ret = ftruncate(fd, __intVal(newSize));
	close(fd);
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( false );
	}
	RETURN (true);
    }
# endif /* using FTRUNCATE */
#endif
%}.
    ^ self primitiveFailed
! !

!OpenVMSOperatingSystem class methodsFor:'file access rights'!

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

%{
    struct stat buf;
    int ret;

    if (__isString(aPathName)) {
# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for accessMode\n", __stringVal(aPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(aPathName), &buf);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__

	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( nil );
	}
	RETURN ( __mkSmallInteger(buf.st_mode & 0777) );
    }
%}.
   ^ self primitiveFailed

   "
    (OperatingSystem accessModeOf:'/') printStringRadix:8
   "
!

changeAccessModeOf:aPathName to:modeBits
    "change the access rights of aPathName to the OS dependent modeBits.
     You should construct this mask using accessMaskFor, to be OS
     independent. Return true if changed,
     false if such a file does not exist or change was not allowd."

%{
    int ret;

    if (__isString(aPathName) && __isSmallInteger(modeBits)) {
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = chmod((char *)__stringVal(aPathName), __intVal(modeBits));
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( false );
	}
	RETURN ( true );
    }
%}.
    ^ self primitiveFailed
! !

!OpenVMSOperatingSystem class methodsFor:'file locking'!

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

    Returns true, if the lock was aquired, false otherwise.

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

supportsFileLinks
    "return true, if the OS supports file links (hard links).
     Typically, only unix returns true here."

    ^ false
!

supportsFileLocks
    "return true, if the OS supports file locking"

%{ /* NOCONTEXT */
#if defined(F_SETLK)
    RETURN (true);
#else
# if defined(LOCK_EX) && defined(LOCK_UN)
    RETURN (true);
# else
#  if defined(F_LOCK) && defined(F_UNLOCK)
    RETURN (true);
#  endif
# endif
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
#if defined(F_SETLK) && defined(F_SETLKW)
    RETURN (true);
#else
# if defined(LOCK_EX) && defined(LOCK_UN) && defined(LOCK_NB)
    RETURN (true);
# endif
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

supportsSymbolicLinks
    "return true, if the OS supports symbolic links on files/directories.
     Typically, only Unix returns true here"

    ^ false
!

unlockFD:aFileDescriptor
    "clear a file lock on the file represented by aFileDescriptor,
     which was previously aquired by #lockFD:.
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

!OpenVMSOperatingSystem class methodsFor:'file queries'!

caseSensitiveFilenames
    "return true, if the OS has caseSensitive file naming.
     On MSDOS, this will return false;
     on a real OS, we return true."

    ^ false
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
#if defined(__VMS__)
    /*
     * add volume names to list ...
     */
    RETURN (list);
#endif
%}.
    "/
    "/ default: retrurn array filled with
    "/ root, home and current directories.
    "/
    ^ Array
	with:'/'
	with:(self getHomeDirectory)
	with:(Filename currentDirectory pathName)
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

    |info type mode uid gid size id
     atime mtime ctime
     aOStime mOStime cOStime
     aYr aMon aDay aHr aMin aSec aMS
     mYr mMon mDay mHr mMin mSec mMS
     cYr cMon cDay cHr cMin cSec cMS
     name2
     recordFormat recordAttribs fixedHeaderSize recordSize
     recordFormatNumeric|

%{
    struct stat buf;
    int ret;
    char nameBuffer[15];
    unsigned INT ino;

    if (__isString(aPathName)) {
# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for info\n", __stringVal(aPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(aPathName), &buf);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__

	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( nil );
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

# ifdef __VMS__
#  ifndef _POSIX_C_SOURCE
	switch (buf.st_fab_rfm) {
	    case FAB$C_UDF:
		/* undefined (also stream binary)   */
		recordFormat = @symbol(streamBinary);
		break;
	    case FAB$C_FIX:
		/* fixed length records             */
		recordFormat = @symbol(fixedRecord);
		break;
	    case FAB$C_VAR:
		/* variable length records          */
		recordFormat = @symbol(variableRecord);
		break;
	    case FAB$C_VFC:
		/* variable fixed control           */
		recordFormat = @symbol(variableFixedControl);
		break;
	    case FAB$C_STM:
		/* RMS-11 stream (valid only for sequen> */
		recordFormat = @symbol(streamRMS11);
		break;
	    case FAB$C_STMLF:
		/* LF stream (valid only for sequential> */
		recordFormat = @symbol(streamLF);
		break;
	    case FAB$C_STMCR:
		/* CR stream (valid only for sequential> */
		recordFormat = @symbol(streamCR);
		break;
	    default:
		recordFormat = @symbol(unknown);
		break;
	}

	recordFormatNumeric = __mkSmallInteger(buf.st_fab_rfm);
	recordAttribs = __mkSmallInteger(buf.st_fab_rat);
	fixedHeaderSize = __mkSmallInteger(buf.st_fab_fsz);
	recordSize = __mkSmallInteger(buf.st_fab_mrs);
#  endif /* _POSIX_C_SOURCE */

#  if __POINTER_SIZE__ == 8
	ino = buf.st_ino[2];
	ino = (ino << 16) + buf.st_ino[1];
	ino = (ino << 16) + buf.st_ino[0];
	id = __MKUINT(ino);
#  else
	{
	    unsigned int inoHi, inoLow;

	    inoHi = buf.st_ino[2];
	    inoLow = buf.st_ino[1];
	    inoLow = (inoLow << 16) + buf.st_ino[0];
	    id = __MKLARGEINT64(1, inoLow, inoHi);
	}
#  endif
# else /* not VMS */
	ino = buf.st_ino;
	id = __MKUINT(ino);
# endif

	mode = __mkSmallInteger(buf.st_mode & 0777);
	uid = __mkSmallInteger(buf.st_uid);
	gid = __mkSmallInteger(buf.st_gid);
	size = __MKUINT(buf.st_size);
	aOStime = __MKUINT(buf.st_atime);
	mOStime = __MKUINT(buf.st_mtime);
	cOStime = __MKUINT(buf.st_ctime);
    }
%}.
    mode notNil ifTrue:[
	aOStime notNil ifTrue:[
	    atime := Timestamp fromOSTime:(aOStime * 1000).
	    mtime := Timestamp fromOSTime:(mOStime * 1000).
	    ctime := Timestamp fromOSTime:(cOStime * 1000).
	] ifFalse:[
	    atime := Timestamp day:aDay month:aMon year:aYr hour:aHr minutes:aMin seconds:aSec milliseconds:aMS.
	    mtime := Timestamp day:mDay month:mMon year:mYr hour:mHr minutes:mMin seconds:mSec milliseconds:mMS.
	    ctime := Timestamp day:cDay month:cMon year:cYr hour:cHr minutes:cMin seconds:cSec milliseconds:cMS.
	].

	info := FileStatusInfo
		    type:type
		    mode:mode
		    uid:uid
		    gid:gid
		    size:size
		    id:id
		    accessed:atime
		    modified:mtime
		    statusChanged:ctime
		    path:nil.

	recordFormat notNil ifTrue:[
	    "/ additional VMS info
	    info
		recordFormat:recordFormat
		recordFormatNumeric:recordFormatNumeric
		recordAttributes:recordAttribs
		fixedHeaderSize:fixedHeaderSize
		recordSize:recordSize
	].
	^ info
   ].
   ^ self primitiveFailed

   "
    OperatingSystem infoOf:'/'
    (OperatingSystem infoOf:'/') uid
    (OperatingSystem infoOf:'/') accessed
   "
!

isDirectory:aPathName
    "return true, if 'aPathName' is a valid directory path name.
     (i.e. exists and is a directory).
     This also returns true for symbolic links pointing to a directory;
     if you need to check for this, use #linkInfo:."

%{
    int ret;

    if (__isString(aPathName)) {
	struct stat buf;

# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for isDirectory\n", __stringVal(aPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(aPathName), &buf);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( false );
	}
	RETURN ( ((buf.st_mode & S_IFMT) == S_IFDIR) ? true : false);
    }
%}.
    ^ self primitiveFailed

    "an alternative implementation would be:
	^ (self infoOf:aPathName) type == #directory
    "
!

isExecutable:aPathName
    "return true, if the given file is executable.
     For symbolic links, the pointed-to-file is checked."

%{
    int ret;

    if (__isString(aPathName)) {
# ifdef TRACE_ACCESS_CALLS
	printf("access on '%s' for executable\n", __stringVal(aPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = access(__stringVal(aPathName), X_OK);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	}
	RETURN ( ((ret == 0) ? true : false) );
    }
%}.
    ^ self primitiveFailed
!

isReadable:aPathName
    "return true, if the file/dir 'aPathName' is readable.
     For symbolic links, the pointed-to-file is checked."

%{
    int ret;

    if (__isString(aPathName)) {
# ifdef TRACE_ACCESS_CALLS
	printf("access on '%s' for readable\n", __stringVal(aPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = access(__stringVal(aPathName), R_OK);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	}
	RETURN ( ((ret == 0) ? true : false) );
    }
%}.
    ^ self primitiveFailed
!

isSymbolicLink:aPathName
    "return true, if the given file is a symbolic link"

    ^ (self linkInfoOf:aPathName) notNil

    "
     OperatingSystem isSymbolicLink:'Make.proto'
     OperatingSystem isSymbolicLink:'Makefile'
    "
!

isValidPath:aPathName
    "return true, if 'aPathName' is a valid path name
     (i.e. the file or directory exists)"

%{
    struct stat buf;
    int ret;

    if (__isString(aPathName) || __isSymbol(aPathName) ) {
# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for isValidPath\n", __stringVal(aPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(aPathName), &buf);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN (false);
	}
	RETURN ( ret ? false : true );
    }
%}.
    ^ self primitiveFailed
!

isWritable:aPathName
    "return true, if the given file is writable.
     For symbolic links, the pointed-to-file is checked."

%{
    int ret;

    if (__isString(aPathName)) {
# ifdef TRACE_ACCESS_CALLS
	printf("access on '%s' for writable\n", __stringVal(aPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = access(__stringVal(aPathName), W_OK);
	} while ((ret < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	}
	RETURN ( ((ret == 0) ? true : false) );
    }
%}.
    ^ self primitiveFailed
!

linkInfoOf:aPathName
    "return a dictionary filled with info for the file 'aPathName',
     IFF aPathName is a symbolic link.
     If aPathName is invalid, or its NOT a symbolic link, nil is returned.
     (which means, that systems like VMS or MSDOS always return nil here.)

     The contents of the dictionary gives info about the link itself,
     on contrast to #infoOf:, which returns the info of the pointed to file
     in case of a symbolic link."

    ^ nil
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

    |p path command|

    "some systems have a convenient function for this ..."
    path := self primPathNameOf:pathName.

    path isNil ifTrue:[
	(self isValidPath:pathName) ifFalse:[
	    p := pathName.
	    [(p size > 1)
	     and:[p endsWith:(self fileSeparator)]
	    ] whileTrue:[
		p := p copyWithoutLast:1.
	    ].
	    ^ p
	].

	path isNil ifTrue:[
	    "/
	    "/ return the original - there is nothing else can we do
	    "/
	    path := pathName
	].
	path := self compressPath:path
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

primIdOf:aPathName
    "the actual code to return the fileNumber (i.e. inode number) of a file."

%{  /* UNLIMITEDSTACK(WIN32) */
    struct stat buf;
    int ret;
    unsigned INT ino;
    OBJ retVal;

    if (__isString(aPathName)) {
# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for id\n", __stringVal(aPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(aPathName), &buf);
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret >= 0) {
#ifdef __VMS__
# if __POINTER_SIZE__ == 8
	    ino = buf.st_ino[2];
	    ino = (ino << 16) + buf.st_ino[1];
	    ino = (ino << 16) + buf.st_ino[0];
	    retVal = __MKUINT(ino);
# else
	    {
		unsigned inoLow, inoHi;

		inoHi = buf.st_ino[2];
		inoLow = buf.st_ino[1];
		inoLow = (inoLow << 16) + buf.st_ino[0];
		retVal = __MKLARGEINT64(1, inoLow, inoHi);
	    }
# endif
#else
	    ino = buf.st_ino;
	    retVal = __MKUINT(ino);
#endif
	    RETURN (retVal);
	}
	@global(LastErrorNumber) = __mkSmallInteger(errno);
	RETURN (nil);
    }
    RETURN (nil);
%}.
!

primPathNameOf:pathName
    "return the pathName of the argument, aPathString,
     - thats the full pathname of the directory, starting at '/'.
     This method here returns nil, if the OS does not provide a
     realPath library function.
     Notice: if symbolic links are involved, the result may look different
     from what you expect."

    |path|

%{  /* STACK: 16000 */

    if (__isString(pathName)) {

#ifdef HAS_GETCWD
	if (strcmp(__stringVal(pathName), "[]") == 0)
	{
	    char nameBuffer[MAXPATHLEN + 1];

	    if (@global(CurrentDirectory) == nil) {
		if (getcwd(nameBuffer, MAXPATHLEN)) {
		    OBJ d;

		    @global(CurrentDirectory) = d = __MKSTRING(nameBuffer);
		    __GSTORE(d);
		}
	    }
	    RETURN (@global(CurrentDirectory));
	}
#endif /* HAS_GETCWD */

#ifdef HAS_REALPATH
	{
	    char nameBuffer[MAXPATHLEN + 1 + MAXPATHLEN + 1];

	    if (realpath(__stringVal(pathName), nameBuffer)) {
		RETURN ( __MKSTRING(nameBuffer) );
	    }
	}
#endif /* ! HAS_REALPATH */
    }
%}.
    ^ nil
!

timeOfLastAccess:aPathName
    "return the time, when the file was last accessed.
     For nonexistent files, nil is returned."

    "could be implemented as:
	(self infoOf:aPathName) accessed
    "

    |osSeconds i|
%{
#if !defined(__win32__) && !defined(__VMS__)
    struct stat buf;
    time_t mtime;
    int ret;

    if (__isString(aPathName)) {
# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for timeOfLastAccess\n", __stringVal(aPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(aPathName), &buf);
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN (nil);
	}
	osSeconds = __MKUINT(buf.st_atime);
    }
#endif
%}.
    osSeconds notNil ifTrue:[^ Timestamp fromOSTime:(osSeconds * 1000)].

    i := self infoOf:aPathName.
    i notNil ifTrue:[^ i accessed].
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

    |osSeconds i|
%{
#if !defined(__win32__) && !defined(__VMS__)
    struct stat buf;
    int ret;
    time_t mtime;

    if (__isString(aPathName)) {
# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for timeOfLastChange\n", __stringVal(aPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(aPathName), &buf);
	} while (ret < 0 && errno == EINTR);
	__END_INTERRUPTABLE__
	if (ret < 0) {
	    @global(LastErrorNumber) = __mkSmallInteger(errno);
	    RETURN ( nil );
	}
	osSeconds = __MKUINT(buf.st_mtime);
    }
#endif
%}.
    osSeconds notNil ifTrue:[^ Timestamp fromOSTime:(osSeconds * 1000)].

    i := self infoOf:aPathName.
    i notNil ifTrue:[^ i modified].
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
     but for huge directory searches the code below is faster
    "

%{
    struct stat buf;
    int ret;

    if (__isString(aPathName)) {
# ifdef TRACE_STAT_CALLS
	printf("stat on '%s' for type\n", __stringVal(aPathName));
# endif
	__BEGIN_INTERRUPTABLE__
	do {
	    ret = stat((char *) __stringVal(aPathName), &buf);
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
     - thats the name of the volume where aPath is.
     Not all OperatingSystems support/use volumes; on unix,
     this always returns an empty string."

    |idx|

    idx := aPathString indexOf:$:.
    idx ~~ 0 ifTrue:[
	^ aPathString copyTo:(idx - 1).
    ].
    ^ ''
! !

!OpenVMSOperatingSystem class methodsFor:'interrupts & signals'!

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

#if defined(ITIMER_REAL) && !defined(NO_SETITIMER)
    struct itimerval dt;

    dt.it_interval.tv_sec = 0;
    dt.it_interval.tv_usec = 0;
    dt.it_value.tv_sec = 0;
    dt.it_value.tv_usec = 0;
    setitimer(ITIMER_REAL, &dt, 0);
    RETURN (true);
#else

# if defined(USE_AST_TIMER)
    extern void __vmsClearTimer();

    __vmsClearTimer();
    RETURN (true);
# endif /* USE_AST_TIMER */

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

%{
    extern void __vmsEnableChildInterrupts();

    __vmsEnableChildInterrupts();
%}.
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
#ifdef SIGIO
# define THESIGNAL SIGIO
#else
# ifdef SIGPOLL
#  define THESIGNAL SIGPOLL
# else
#  ifdef SIGURG
#   define THESIGNAL SIGURG
#  endif
# endif
#endif

    if (__isSmallInteger(fd)) {
	if (firstCall) {
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
	    act.sa_handler = __signalIoInterrupt;
	    sigaction(THESIGNAL, &act, 0);
#else
# ifdef HAS_SIGVEC
	    struct sigvec vec;

	    vec.sv_flags = SV_INTERRUPT;
	    sigemptyset(&vec.sv_mask);
	    vec.sv_handler = __signalIoInterrupt;
	    sigvec(THESIGNAL, &vec, NULL);
# else
	    signal(THESIGNAL, __signalIoInterrupt);
# endif
#endif
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

#if defined(F_SETOWN) || defined(FIOSETOWN)
	{
	    int pid;
	    int ok;

	    pid = getpid();

# if defined(F_SETOWN)
	    ok = fcntl(f, F_SETOWN, pid);
	    /* printf("F_SETOWN returns %d (%d)\n", ret, errno); */
# else
	    ok = ioctl(f, FIOSETOWN, &pid);
	    /* printf("FIOSETOWN returns %d (%d)\n", ret, errno); */
# endif
	    if (ok < 0) {
		ret = ok;
	    }
	}
#endif
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
     Dont confuse Unix signals with smalltalk signals.
     The signal will be delivered to one of the standard handlers
     (SIGINT, SIGQUIT, etc) or to a general handler, which
     sends #signalInterrupt:.

     NOTICE that signal numbers are not portable between unix
     systems - use OperatingSystem sigXXX to get the numeric value for
     a signal."

%{  /* NOCONTEXT */

#ifdef NSIG
# define SIG_LIMIT NSIG
#else
# ifdef SIGUSR2
#  define SIG_LIMIT SIGUSR2
# else
#  ifdef SIGUSR
#   define SIG_LIMIT SIGUSR
#  endif
# endif
#endif

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
# ifndef __win32__
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
#ifdef __win32__
# ifdef PROCESSDEBUGWIN32
		printf("ConsoleSignal %d\n",sigNr);
# endif
		SetConsoleCtrlHandler((PHANDLER_ROUTINE)__signalUserInterruptWIN32,TRUE);
		RETURN (self);
#else
# if defined(SIGINT) || defined(SIGQUIT) || defined(SIGBREAK)
		handler = __signalUserInterrupt;
		break;
# endif
#endif
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
#ifdef SIGALRM
	    case SIGALRM:
		handler = __signalTimerInterrupt;
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
#  ifdef __win32__
#   ifdef PROCESSDEBUGWIN32
	    printf("signal %d can't change handler\n",sigNr);
#   endif
#  else
	    (void) signal(sigNr, handler);
#  endif
# endif
#endif
	}

	/*
	 * maybe, we should return the old enable-status
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
    int millis;

    millis = __intVal(milliSeconds);

#ifdef SIGALRM
    {
	static int firstCall = 1;
# ifndef __signalTimerInterrupt
	extern void __signalTimerInterrupt(SIGHANDLER_ARG);
# endif

	if (firstCall) {
# ifdef HAS_SIGACTION
	    struct sigaction act;

	    act.sa_flags = SA_SIGINFO; /* <- if you add more, remember dummys at the top */
	    sigemptyset(&act.sa_mask);
	    act.sa_handler = __signalTimerInterrupt;
	    sigaction(SIGALRM, &act, 0);
# else
#  ifdef HAS_SIGVEC
	    struct sigvec vec;

	    vec.sv_flags = SV_INTERRUPT;
	    sigemptyset(&vec.sv_mask);
	    vec.sv_handler = __signalTimerInterrupt;
	    sigvec(SIGALRM, &vec, NULL);
#  else /* neither SIGACTION nor SIGVEC */
	    signal(SIGALRM, __signalTimerInterrupt);
#  endif /* stupid system  */
# endif
	    firstCall = 0;
	}
    }
#endif /* SIGALRM */


#if defined(ITIMER_REAL) && !defined(NO_SETITIMER)
    {
	struct itimerval dt;

	dt.it_interval.tv_sec = 0;
	dt.it_interval.tv_usec = 0;
	dt.it_value.tv_sec = millis / 1000;
	dt.it_value.tv_usec = (millis % 1000) * 1000;
	setitimer(ITIMER_REAL, &dt, 0);
	RETURN (true);
    }
#else /* no ITIMER_REAL */

# if defined(USE_AST_TIMER)
    {
	extern void __vmsSetTimer();

	__vmsSetTimer(millis);
	RETURN (true);
    }
# endif /* USE_AST_TIMER */

# ifdef USE_SLOW_ALARM
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
# endif
#endif /* ITIMER_REAL */
%}.
    ^ false
!

killProcess:processId
    "kill a unix process.
     The process terminates immediately and has no chance to perform any cleanup actions.

     WARNING: in order to avoid zombie processes (on unix),
	      you have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId."

    self sendSignal:(self sigKILL) to:processId.

    "Modified: 28.12.1995 / 15:06:18 / stefan"
!

sendSignal:signalNumber to:processId
    "send a unix signal to some process (maybe myself).
     Returns false if any error occurred, true otherwise.

     Do not confuse UNIX signals with Smalltalk-Signals.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId
	      if the signal terminates that process."

%{
    if (__bothSmallInteger(signalNumber, processId)) {
	if (kill(__intVal(processId), __intVal(signalNumber)) < 0) {
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

    ^ UnsupportedOperationSignal raise.
!

terminateProcessGroup:processGroupId
    "terminate a unix process group.
     The process has a chance to do some cleanup.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId."

    ^ UnsupportedOperationSignal raise.
! !

!OpenVMSOperatingSystem class methodsFor:'ipc support - UNIX'!

makePipe
    "make a pipe, return array with two filedescriptors on success,
     nil on failure.
     This is a lowLevel entry, not for public use.
     See ExternalStream>>makePipe for a more user-friendly, public interface."

    ^ nil
! !

!OpenVMSOperatingSystem class methodsFor:'ipc support - VMS'!

createCOMFileForVMSCommand:aCommandString in:aDirectory
    "since DCL seems to not support multiple commands in one
     line, create a temporary COM file for a set def, followed
     by the actual command string.
     A kludge around a poor CLI design."

    |path|

    path := aDirectory asFilename pathName asFilename osNameForDirectory.
    ^ self
	createCOMFileForVMSCommands:(Array
					with:('set def ' , path)
					with:aCommandString).
!

createCOMFileForVMSCommands:aCollectionOfCommandStrings
    "since DCL seems to not support multiple commands in one
     line, create a temporary COM file for them and let DCL
     execute that one.
     A kludge around a poor CLI design."

    |tmpComFile s|

    tmpComFile := Filename newTemporary withSuffix:'COM'.
    s := tmpComFile writeStream.
    aCollectionOfCommandStrings do:[:aCommand |
	(aCommand startsWith:$$) ifFalse:[
	    s nextPutAll:'$'.
	].
	s nextPutAll:aCommand.
	s nextPut:(Character nl).
    ].
    s close.
    ^ tmpComFile.
!

createMailBox
    "create a VMS mailBox. Return the mbx-channel number or nil on failure.
     This is only supported with VMS and needed with I/O redirection when
     OS commands are spawned. On non-VMS systems, nil is always returned."

    |mbxChannel|

%{
#ifdef __VMS__
    struct IOSB iosb;
    static int mbxSize = 0;
    int status;
    short channel;

    /*
     * get the mailbox size, when called for the very first time.
     */
    if (mbxSize == 0) {
	struct itm$list3 syilist[2] = {
	  { sizeof(mbxSize), SYI$_MAXBUF, &mbxSize, (void *) 0 },
	  { 0, 0, 0, 0}
	};

	/*
	 * Use the smaller of SYI$_MAXBUF and 2048 for the mailbox size
	 */
	status = SYS$GETSYIW(0, 0, 0, syilist, &iosb, 0, 0, 0);
	if (status != SS$_NORMAL && !(iosb.status & STS$M_SUCCESS)) {
	    vaxc$errno = iosb.status;
	    errno = EVMSERR;
	    fprintf(stderr, "OpenVMSOperatingSystem [warning]: $GETSYIW failure for SYI$_MAXBUF");
	    RETURN( nil );
	}
	if (mbxSize > 2048) {
	    mbxSize = 2048;
	}
    }

    /*
     * create a mailBox ...
     */
    status = SYS$CREMBX (0, &channel, mbxSize, mbxSize, 0, 0, 0, 0);
    if (status != SS$_NORMAL) {
	vaxc$errno = status;
	errno = EVMSERR;
	fprintf(stderr, "OpenVMSOperatingSystem [warning]: $CREMBX failure");
	RETURN ( nil );
    }
    mbxChannel = __mkSmallInteger(channel);
#endif
%}.
    ^ mbxChannel
!

createMailBoxPair
    |in out|

    in := self createMailBox.
    in isNil ifTrue:[
	^ nil
    ].
    out := self createMailBox.
    out isNil ifTrue:[
	self destroyMailBox:in.
	^ nil
    ].
    ^ Array with:in with:out
!

destroyMailBox:aChannelNr
    "deallocate a mailBox.
     This is only needed for VMS subprocess handling and ignored
     on other systems."
%{
#ifdef __VMS__
    if (__isSmallInteger(aChannelNr)) {
	int channel = __intVal(aChannelNr);

	SYS$DASSGN (channel);
    }
#endif
%}.
!

mailBoxNameOf:aChannelNr
    "retrieve a mailBoxes name, given its channel nr.
     This is required in VMS for subprocess execution, to be
     able to open a mailbox as a file.
     Non VMS systems return nil."
%{
#ifdef __VMS__
    struct IOSB iosb;
    int status;
    short channel;
    struct Vstring mbxname = { sizeof(mbxname.body) };
    struct itm$list3 mbxlist[2] = {
      { sizeof(mbxname.body)-1, DVI$_DEVNAM, &mbxname.body, &mbxname.length },
      { 0, 0, 0, 0}
    };

    if (__isSmallInteger(aChannelNr)) {
	channel = __intVal(aChannelNr);
	status = SYS$GETDVIW (0, channel, 0, &mbxlist, &iosb, 0, 0, 0);
	if (status != SS$_NORMAL && !(iosb.status & STS$M_SUCCESS)) {
	    vaxc$errno = iosb.status;
	    errno = EVMSERR;
#if 0
	    fprintf(stderr, "OpenVMSOperatingSystem [info]: $GETDVIW for mailBox name failed mbx=%d\n",channel);
#endif
	    RETURN ( nil );
	}
	mbxname.body[mbxname.length] = 0;
	RETURN (__MKSTRING(mbxname.body));
    }
#endif
%}.
    ^ nil
! !

!OpenVMSOperatingSystem class methodsFor:'misc'!

closePid:pid
    "free pid resource"

    ^ true.

    "Created: 28.1.1998 / 14:23:04 / md"
    "Modified: 28.1.1998 / 14:27:18 / md"
! !

!OpenVMSOperatingSystem class methodsFor:'path queries'!

defaultSystemPath
    |sysPath|

    sysPath := super defaultSystemPath.
    #(
	'stx$lib:'
	'stx$root:[lib]'
	'stx$root:'
    ) do:[:d |
	(d asFilename isDirectory) ifTrue:[
	    sysPath add:d
	]
    ].
    ^ sysPath
! !

!OpenVMSOperatingSystem class methodsFor:'os queries'!

executableFileExtensions
    "return a collection of extensions for executable program files.
     Only req'd for msdos like systems ..."

    ^ #('com' 'exe')

    "Created: 2.5.1997 / 11:42:29 / cg"
!

getDomainName
    "return the domain this host is in.
     Notice:
	not all systems support this; on some, 'unknown' is returned."

    |name idx hostName|

    DomainName notNil ifTrue:[
	^ DomainName
    ].

%{  /* STACK: 2048 */
#if defined(HAS_GETDOMAINNAME)
    char buffer[128];

    if (getdomainname(buffer, sizeof(buffer)) == 0) {
	name = __MKSTRING(buffer);
    }
#else
# if defined(HAS_UNAME) && defined(HAS_UTS_DOMAINNAME)
    struct utsname ubuff;

    if (uname(&ubuff) >= 0) {
	name = __MKSTRING(ubuff.domainname);
    }
# else
#  if defined(HAS_SYSINFO) && defined(SI_SRPC_DOMAIN)
    char buffer[256];
    int ret;

    if ((ret = sysinfo(SI_SRPC_DOMAIN, buffer, sizeof(buffer))) >= 0 && ret <= sizeof(buffer)) {
	name = __MKSTRING(buffer);
    }
#  endif
# endif
#endif
%}.
    name isNil ifTrue:[
	name := self getEnvironment:'DOMAIN'.
"/      name isNil ifTrue:[
"/          OperatingSystem isUNIXlike ifTrue:[
"/              name := self getCommandOutputFrom:'domainname'
"/          ]
"/      ]
    ].
    name isNil ifTrue:[
	"/ sometimes, we can extract the domainName from the hostName ...
	hostName := self getHostName.
	hostName notNil ifTrue:[
	    idx := hostName indexOf:$..
	    idx ~~ 0 ifTrue:[
		name := hostName copyFrom:idx+1.
	    ]
	].
	name isNil ifTrue:[
	    'OpenVMSOperatingSystem [warning]: cannot find out domainname' errorPrintCR.
	    name := 'unknown'.
	]
    ].
    DomainName := name.
    ^ name

    "
     OperatingSystem getDomainName
    "

    "Modified: 26.4.1996 / 10:04:54 / stefan"
!

getEnvironment:aStringOrSymbol
    "get an environment string"

%{  /* NOCONTEXT */

    char *env;
    extern char *getenv();

    if (__isString(aStringOrSymbol) || __isSymbol(aStringOrSymbol)) {
	env =  getenv(__stringVal(aStringOrSymbol));
	if (env) {
	    RETURN ( __MKSTRING(env) );
	}
    }
%}
.
    ^ nil

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
    "return the hostname we are running on - if there is
     a HOST environment variable, we are much faster here ...
     Notice:
	not all systems support this; on some, 'unknown' is returned."

    |name idx|

    HostName notNil ifTrue:[
	^ HostName
    ].

%{  /* STACK: 2048 */
#if defined(HAS_GETHOSTNAME)
    char buffer[256];

    if (gethostname(buffer, sizeof(buffer)) == 0) {
	name = __MKSTRING(buffer);
    }
#else
# if defined(HAS_UNAME)
    struct utsname ubuff;

    if (uname(&ubuff) >= 0) {
	name = __MKSTRING(ubuff.nodename);
    }
# else
#  if defined(HAS_SYSINFO) && defined(SI_HOSTNAME)
    char buffer[256];
    int ret;

    if ((ret = sysinfo(SI_HOSTNAME, buffer, sizeof(buffer))) >= 0 && ret <= sizeof(buffer)) {
	name = __MKSTRING(buffer);
    }
#  endif
# endif
#endif
%}.
    name isNil ifTrue:[
	name := self getEnvironment:'HOST'.
"/      name isNil ifTrue:[
"/          OperatingSystem isUNIXlike ifTrue:[
"/              name := self getCommandOutputFrom:'hostname'
"/          ]
"/      ]
    ].
    name isNil ifTrue:[
	'OpenVMSOperatingSystem [warning]: cannot find out hostname' errorPrintCR.
	name := 'unknown'.
    ] ifFalse:[
	"/ on some systems, the hostname already contains the domain.
	"/ decompose it here.
	idx := name indexOf:$..
	idx ~~ 0 ifTrue:[
	    DomainName := name copyFrom:(idx+1).
	    name := name copyTo:(idx-1).
	]
    ].
    HostName := name.
    ^ name

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

getProcessId
    "return the (unix-)processId"

%{  /* NOCONTEXT */

    int pid = 0;

    /* XXX TODO */
#ifdef UNIX_LIKE
    pid = getpid();
#endif
    RETURN ( __mkSmallInteger(pid) );
%}
    "
     OperatingSystem getProcessId
    "
!

getSystemID
    "if supported by the OS, return the systemID;
     a unique per machine identification.
     WARNING:
	not all systems support this; on some, 'unknown' is returned."

%{  /* NO_CONTEXT */
#ifdef __VMS__
    {
	int sid = 0;
	int status;
	char buffer[64];

	struct itm$list3 syilist[2] = {
	  { sizeof(sid), SYI$_SID, &sid, (void *) 0 },
	  { 0, 0, 0, 0}
	};
	status = SYS$GETSYIW(0, 0, 0, syilist, 0, 0, 0, 0);
	if (status != SS$_NORMAL) {
	    errno = EVMSERR;
	    fprintf(stderr, "OpenVMSOperatingSystem [warning]: $GETSYI failure for SYI$_SID");
	    RETURN( nil );
	}
	sprintf(buffer, "%x", sid);
	RETURN(__MKSTRING(buffer));
    }
#endif
%}.
    ^ 'unknown'

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
    "

    |sys node rel ver mach dom mtyp brel info arch|

%{  /* STACK: 4096 */

#if defined(HAS_UNAME)
    struct utsname ubuff;

    if (uname(&ubuff) >= 0) {
	sys  = __MKSTRING(ubuff.sysname);
	node = __MKSTRING(ubuff.nodename);
	rel  = __MKSTRING(ubuff.release);
	ver  = __MKSTRING(ubuff.version);
	mach = __MKSTRING(ubuff.machine);
# ifdef HAS_UTS_DOMAINNAME
	dom  = __MKSTRING(ubuff.domainname);
# else
#  if defined(HAS_GETDOMAINNAME)
	{
	    char buffer[128];

	    if (getdomainname(buffer, sizeof(buffer)) == 0) {
		dom = __MKSTRING(buffer);
	    }
	}
#  endif
# endif
    }

# if defined(HAS_SYSINFO) && defined(SI_ARCHITECTURE)
    {
	char buffer[128];

	if (sysinfo(SI_ARCHITECTURE, buffer, sizeof(buffer))) {
	    arch = __MKSTRING(buffer);
	}
    }
# endif

#else /* no uname */

# ifdef __VMS__
# endif /* VMS */

#endif /* no uname */
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
	arch := 'unknown'.
    ].

    info := IdentityDictionary new.
    info at:#system put:sys.
    info at:#node put:node.
    rel notNil ifTrue:[info at:#release put:rel].
    ver notNil ifTrue:[info at:#version put:ver].
    mach notNil ifTrue:[info at:#machine put:mach].
    arch notNil ifTrue:[info at:#architecture put:arch].
    dom notNil ifTrue:[info at:#domain put:dom].
    info at:#osType put:(self getOSType).
    ^ info

    "
     OperatingSystem getSystemInfo
    "
!

isVMSlike
    "return true, if the OS we're running in is VMS (or openVMS)."

    ^ true
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

#   ifdef __VMS__
     RETURN ( __mkSmallInteger(38) );
#   endif
%}.
    "unix default"

    ^ 14
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

    "Created: 2.5.1997 / 11:36:47 / cg"
!

platformName
    "return a string describing the OS platform very we're running on.
     This returns #unix for all unix derivatives.
     I.e. it is much less specific than getOSType or getSystemType."

    ^ #vms

    "
     OperatingSystem platformName
    "

    "Modified: 20.6.1997 / 17:37:26 / cg"
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

    ^ true

    "
     OperatingSystem supportsChildInterrupts
    "
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

%{  /* NOCONTEXT */
#if defined(F_GETFL) && defined(F_SETFL) && defined(FNDELAY)
       RETURN (true);
#endif
%}.
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

    ^ false "/ for now ...

    "
     OperatingSystem supportsSelect
    "
!

supportsVolumes
    "return true, if the OS supports disk volumes.
     False is returned for UNIX, true for MSDOS and VMS"

    ^ true
! !

!OpenVMSOperatingSystem class methodsFor:'private'!

osProcessStatusClass
    ^ OSProcessStatus

    "Created: / 12.6.1998 / 16:30:43 / cg"
! !

!OpenVMSOperatingSystem class methodsFor:'shared memory access'!

shmAttach:id address:addr flags:flags
    "low level entry to shmat()-system call.
     Not supported on all operatingSystems"

    ^ self primitiveFailed

    "Modified: 22.4.1996 / 13:15:12 / cg"
!

shmDetach:addr
    "low level entry to shmdt()-system call.
     Not supported on all operatingSystems"

    ^ self primitiveFailed

    "Modified: 22.4.1996 / 13:15:03 / cg"
!

shmGet:key size:size flags:flags
    "low level entry to shmget()-system call.
     This is not for public use and not supported with all operatingSystems.
     - use the provided wrapper class SharedExternalBytes instead."

    ^ self primitiveFailed

    "Modified: 22.4.1996 / 13:14:46 / cg"
! !

!OpenVMSOperatingSystem class methodsFor:'time and date'!

computeDatePartsOf:osTime for:aBlock
    "compute year, month and day from the OS time, osTime
     and evaluate the argument, a 3-arg block with these.
     Conversion is to localtime including any daylight saving adjustments."

    |year month day osSeconds|

    osSeconds := osTime // 1000.
%{
    struct tm* tmPtr;
    INT t;
    TIME_T tt;

    t = __longIntVal(osSeconds);
    tt = (TIME_T)t;

    tmPtr = localtime(&tt);
    year = __mkSmallInteger(tmPtr->tm_year + 1900);
    month = __mkSmallInteger(tmPtr->tm_mon + 1);
    day = __mkSmallInteger(tmPtr->tm_mday);
%}.
    aBlock value:year value:month value:day

    "
     OperatingSystem computeDatePartsOf:0 for:[:y :m :d |
	y printCR. m printCR. d printCR
     ]
    "
!

computeOSTimeFromYear:y month:m day:d hour:h minute:min seconds:s millis:millis
    "return the OS-dependent time for the given time and day.
     The arguments are assumed to be in localtime including
     any daylight saving adjustings."

    |osSeconds|

%{
    struct tm tm;
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

	t = mktime(&tm);
	osSeconds = __MKUINT((INT)t);
    }
%}.
    osSeconds notNil ifTrue:[
	^ osSeconds * 1000 + millis
    ].
    ^ self primitiveFailed

    "
     OperatingSystem computeOSTimeFromYear:1970 month:1 day:1 hour:0 minute:0 seconds:0 millis:0
    "

!

computeTimeAndDateFrom:osTime
    "given an OS-dependent time in osTime, return an Array
     containing (full-) year, month, day, hour, minute and seconds,
     offset to UTC, daylight savings time flag, milliseconds,
     dayInYear (1..) and dayInWeek (1..).
     Conversion is to localtime including any daylight saving adjustments."

    |low hi year month day hours minutes seconds millis utcOffset
     dst yDay wDay osSeconds ret|

    millis := osTime \\ 1000.
    osSeconds := osTime // 1000.
%{
    struct tm *tmPtr;
    struct tm *gmTmPtr;
    INT t;
    TIME_T tt;

    t = __longIntVal(osSeconds);
    tt = (TIME_T)t;

    tmPtr = localtime(&tt);
    hours = __mkSmallInteger(tmPtr->tm_hour);
    minutes = __mkSmallInteger(tmPtr->tm_min);
    seconds = __mkSmallInteger(tmPtr->tm_sec);

    year = __mkSmallInteger(tmPtr->tm_year + 1900);
    month = __mkSmallInteger(tmPtr->tm_mon + 1);
    day = __mkSmallInteger(tmPtr->tm_mday);

    yDay = __mkSmallInteger(tmPtr->tm_yday+1);
    wDay = __mkSmallInteger(tmPtr->tm_wday == 0 ? 7 : tmPtr->tm_wday);

    if (tmPtr->tm_isdst == 0) {
	dst = false;
	utcOffset = __MKINT(TIMEZONE(tmPtr));
    } else {
	dst = true;
#ifdef HAS_ALTZONE
	utcOffset = __MKINT(altzone);
#else
	utcOffset = __MKINT(TIMEZONE(tmPtr) + 3600);
#endif
    }
%}.
    "I would love to have SELF-like inline objects ..."
    ret := Array new:11.
    ret at:1 put:year.
    ret at:2 put:month.
    ret at:3 put:day.
    ret at:4 put:hours.
    ret at:5 put:minutes.
    ret at:6 put:seconds.
    ret at:7 put:utcOffset.
    ret at:8 put:dst.
    ret at:9 put:millis.
    ret at:10 put:yDay.
    ret at:11 put:wDay.
    ^ ret

    "
     OperatingSystem computeTimeAndDateFrom:0
    "
!

computeTimePartsOf:osTime for:aBlock
    "compute hours, minutes, seconds and milliseconds from the osTime
     and evaluate the argument, a 4-arg block with these.
     Conversion is to localtime including any daylight saving adjustments."

    |hours minutes seconds millis osSeconds|

    osSeconds := osTime // 1000.
    millis := osTime \\ 1000.
%{
    struct tm *tmPtr;
    INT t;
    TIME_T tt;

    t = __longIntVal(osSeconds);
    tt = (TIME_T)t;

    tmPtr = localtime(&tt);
    hours = __mkSmallInteger(tmPtr->tm_hour);
    minutes = __mkSmallInteger(tmPtr->tm_min);
    seconds = __mkSmallInteger(tmPtr->tm_sec);
%}.
    aBlock value:hours value:minutes value:seconds value:millis

    "
     OperatingSystem computeTimePartsOf:100 for:[:h :m :s :milli |
	h printCR. m printCR. s printCR. millis printCR
     ]
    "
!

computeUTCTimeAndDateFrom:osTime
    "given an OS-dependent time in osTime, return an Array
     containing year, month, day, hour, minute and seconds,
     offset to UTC, daylight savings time flag, milliseconds,
     dayInYear (1..) and dayInWeek (1..).
     Conversion is to UTC."

    |low hi year month day hours minutes seconds millis utcOffset
     dst yDay wDay osSeconds ret|

    millis := osTime \\ 1000.
    osSeconds := osTime // 1000.
%{
    struct tm *tmPtr;
    struct tm *gmTmPtr;
    long t;

    t = __longIntVal(osSeconds);

    tmPtr = gmtime(&t);
    hours = __mkSmallInteger(tmPtr->tm_hour);
    minutes = __mkSmallInteger(tmPtr->tm_min);
    seconds = __mkSmallInteger(tmPtr->tm_sec);

    year = __mkSmallInteger(tmPtr->tm_year + 1900);
    month = __mkSmallInteger(tmPtr->tm_mon + 1);
    day = __mkSmallInteger(tmPtr->tm_mday);

    yDay = __mkSmallInteger(tmPtr->tm_yday + 1);
    wDay = __mkSmallInteger(tmPtr->tm_wday == 0 ? 7 : tmPtr->tm_wday);

    if (tmPtr->tm_isdst == 0) {
	dst = false;
	utcOffset = __MKINT(TIMEZONE(tmPtr));
    } else {
	dst = true;
#ifdef HAS_ALTZONE
	utcOffset = __MKINT(altzone);
#else
	utcOffset = __MKINT(TIMEZONE(tmPtr) + 3600);
#endif
    }
%}.
    "I would love to have SELF-like inline objects ..."
    ret := Array new:11.
    ret at:1 put:year.
    ret at:2 put:month.
    ret at:3 put:day.
    ret at:4 put:hours.
    ret at:5 put:minutes.
    ret at:6 put:seconds.
    ret at:7 put:utcOffset.
    ret at:8 put:dst.
    ret at:9 put:millis.
    ret at:10 put:yDay.
    ret at:11 put:wDay.
    ^ ret

    "
     OperatingSystem computeUTCTimeAndDateFrom:0
    "
!

computeUTCTimePartsOf:osTime for:aBlock
    "compute hours, minutes, seconds and milliseconds from the osTime
     and evaluate the argument, a 4-arg block with these.
     Conversion is to UTC."

    |hours minutes seconds millis osSeconds|

    osSeconds := osTime // 1000.
    millis := osTime \\ 1000.
%{
    struct tm *tmPtr;
    long t;

    t = __longIntVal(osSeconds);

    tmPtr = gmtime(&t);
    hours = __mkSmallInteger(tmPtr->tm_hour);
    minutes = __mkSmallInteger(tmPtr->tm_min);
    seconds = __mkSmallInteger(tmPtr->tm_sec);
%}.
    aBlock value:hours value:minutes value:seconds value:millis

    "
     OperatingSystem computeUTCTimePartsOf:100 for:[:h :m :s :milli |
	h printCR. m printCR. s printCR. milli printCR
     ]
    "
!

getMillisecondTime
    "This returns the millisecond timers value.
     The range is limited to 0..1fffffff (i.e. the SmallInteger range) to avoid
     LargeInteger arithmetic when doing timeouts and delays.
     Since this value is wrapping around in regular intervals, this can only be used for
     short relative time deltas.
     Use the millisecondTimeXXX:-methods to compare and add time deltas - these know about the wrap.

     BAD DESIGN:
	This should be changed to return some instance of RelativeTime,
	and these computations moved there.

     Dont use this method in application code since it is an internal (private)
     interface. For compatibility with ST-80, use Time millisecondClockValue.
    "

%{  /* NOCONTEXT */

    long t = 0;

#if !defined(HAS_GETTIMEOFDAY)
# if defined(HAS_FTIME)
    struct timeb timebuffer;

    ftime(&timebuffer);
    t = (timebuffer.time * 1000) + timebuffer.millitm;
#   define HAVE_TIME
# endif

# ifndef HAVE_TIME
#  if defined(SYSV) && defined(HZ)
    /*
     * sys5 time
     */
    long ticks;
    struct tms tb;

    ticks = times(&tb);
    t = (ticks * 1000) / HZ;
#   define HAVE_TIME
#  endif /* old SYSV stuff */
# endif

#endif

#ifndef HAVE_TIME
    /* assume HAS_GETTIMEOFDAY
     * - will result in a linkage error
     * if not fixed.
     */

    /*
     * bsd time
     */
    struct timeval tb;
    struct timezone tzb;

    gettimeofday(&tb, &tzb);
    t = tb.tv_sec*1000 + tb.tv_usec/1000;
#endif

#undef HAVE_TIME

    RETURN ( __mkSmallInteger(t & 0x1FFFFFFF) );
%}
!

getOSTime
    "This returns the OS time.
     The base of the returned value is not consistent across
     different OS's - some return the number of millis since jan, 1st 1970;
     others since 1900. The Time classes are prepared for this, and
     converts as appropriate (by using my fromOSTime: conversion methods).

     Dont use this method in application code since it is an internal (private)
     interface. For compatibility with ST-80, use Time>>millisecondClockValue.
     or use instances of Time, Date or Timestamp to work with.
    "

    |seconds millis|

%{

    long t;

#if !defined(HAS_GETTIMEOFDAY)
# if defined(HAS_FTIME)
    struct timeb timebuffer;

    ftime(&timebuffer);
    seconds = __MKUINT(timebuffer.time);
    millis = __MKUINT(timebuffer.millitm);
#   define HAVE_TIME
# endif

# ifndef HAVE_TIME
#  if defined(SYSV) && defined(HZ)
    /*
     * sys5 time; we have to fake the information
     * the returned value is inexact.
     */
    int now;
    long ticks;
    struct tms tb;

    now = time(0);   /* seconds since 1970 ... */
    seconds = __MKUINT(now);

    ticks = times(&tb);
    t = (ticks * 1000) / HZ;
    t = t % 1000;
    millis = __mkSmallInteger(t);
#  endif /* OLD SYSV stuff */
# endif

# ifndef HAVE_TIME
#  ifdef MSDOS_LIKE
    struct _timeb timebuffer;

    _ftime(&timebuffer);
    seconds = __MKUINT(timebuffer.time);
    millis = __MKUINT(timebuffer.millitm);
#   define HAVE_TIME
#  endif
# endif
#endif

#ifndef HAVE_TIME
    /* assume HAS_GETTIMEOFDAY
     * - will result in a linkage error
     * if not fixed.
     */
    /*
     * bsd time
     */
    struct timeval tb;
    struct timezone tzb;

    gettimeofday(&tb, &tzb);

    /*
     * mhmh long-long stuff seems not to work correctly
     * on all machines (sparc)
     * being conservative here ...
     */
# ifdef HAS_LONGLONG
    {
	unsigned long long _secs, _millis, rslt;
	unsigned low, hi;

	_secs = tb.tv_sec;
	_millis = tb.tv_usec / 1000;
	rslt = _secs * 1000 + _millis;
	low = rslt & 0xFFFFFFFF;
	hi = rslt >> 32;
	RETURN (__MKLARGEINT64(1, low, hi));
    }
# endif /* long long */

# if __POINTER_SIZE__ == 8
    {
	unsigned INT _secs, _millis, rslt;

	_secs = (INT) tb.tv_sec;
	_millis = (INT) tb.tv_usec / 1000;
	rslt = _secs * 1000 + _millis;
	RETURN (__MKUINT(rslt));
    }
# endif /* alpha */

    seconds = __MKUINT(tb.tv_sec);
    millis = __MKUINT(tb.tv_usec / 1000);

#endif

#undef HAVE_TIME

%}.
    ^ (seconds * 1000) + millis

    "
     OperatingSystem getOSTime printCR.
     Delay waitForSeconds:0.2.
     OperatingSystem getOSTime printCR.
    "
!

millisecondDelay:millis
    "delay execution for millis milliseconds or until the next event
     arrives.
     All lower priority threads will also sleep for the duration,
     interrupts (and therefore, higher prio processes) are
     still handled.
     Better use a Delay, to only delay the calling thread.
     (however, a delay cannot be used in the event handler or scheduler)"

    |now then delta|

%{  /* NOCONTEXT */
#ifdef __openVMS__
# ifdef HAS_USLEEP
    int millis = __intVal(millis);
    int micros;

    while (millis >= 1000) {
	sleep(1);
	if (InterruptPending != nil) {
	    break;
	}
	millis -= 1000;
    }
    micros = millis * 1000;
    if (InterruptPending == nil) {
	usleep(micros);
    }
    RETURN(self);
# endif
#endif
%}.

    now := OpenVMSOperatingSystem getMillisecondTime.
    then := OpenVMSOperatingSystem millisecondTimeAdd:now and:millis.

    [OpenVMSOperatingSystem millisecondTime:then isAfter:now] whileTrue:[
	delta := OpenVMSOperatingSystem millisecondTimeDeltaBetween:then and:now.
	self selectOnAnyReadable:nil writable:nil exception:nil withTimeOut:delta.
	now := OpenVMSOperatingSystem getMillisecondTime.
    ]

    "
     OperatingSystem millisecondDelay:2000
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
! !

!OpenVMSOperatingSystem class methodsFor:'users & groups'!

getEffectiveGroupID
    "{ Pragma: +optSpace }"

    "return the current users (thats you) effective numeric group id.
     This is only different from getGroupID, if you have ST/X running
     as a setuid program (of which you should think about twice)."

%{  /* NOCONTEXT */

#ifdef UNIX_LIKE
    int uid;

    uid = getegid();
    RETURN ( __mkSmallInteger(uid) );
#endif
    /* --- return same as getGroupID --- */
%}.
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

%{  /* NOCONTEXT */

#ifdef UNIX_LIKE
    int uid;

    uid = geteuid();
    RETURN ( __mkSmallInteger(uid) );
#endif
    /* --- return same as getUserID --- */
%}.
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

%{  /* NOCONTEXT */

#ifdef UNIX_LIKE
    int uid;

    uid = getgid();
    RETURN ( __mkSmallInteger(uid) );
#else
# ifdef SYSTEM_HAS_GROUPS
    /* ... */
# endif
#endif
%}.
    ^ 1 "just a dummy for systems which do not have userIDs"

    "
     OperatingSystem getGroupID
    "
!

getGroupNameFromID:aNumber
    "{ Pragma: +optSpace }"

    "return the group-name-string for a given numeric group-id"

%{  /* NOCONTEXT */

#ifdef UNIX_LIKE
# ifndef __openVMS__
    struct group *g;

    if (__isSmallInteger(aNumber)) {
	g = getgrgid(__intVal(aNumber));
	if (g) {
	    RETURN ( __MKSTRING(g->gr_name) );
	}
    }
# endif /* not openVMS */
#endif /* unix-like */
%}.
    ^ '???'

    "
     OperatingSystem getGroupNameFromID:0
     OperatingSystem getGroupNameFromID:10
    "
!

getHomeDirectory
    "{ Pragma: +optSpace }"

    "return the name of the users home directory
     (i.e. yours)"

    ^ OpenVMSOperatingSystem getEnvironment:'HOME'

    "
     OperatingSystem getHomeDirectory
    "

    "Modified: 24.1.1997 / 11:32:13 / cg"
!

getLoginName
    "{ Pragma: +optSpace }"

    "return a string with the users login name (thats yours)"

%{  /* NOCONTEXT */
    static char cachedName[64];
    static firstCall = 1;
    extern char *getenv();
    extern char *getlogin();

    char *name = (char *)0;

#ifdef UNIX_LIKE
# ifndef __openVMS__
    if (firstCall) {
	name = getlogin();
	if (! name || (name[0] == 0)) {
	    name = getenv("LOGNAME");
	}
	if (name && (strlen(name) < sizeof(cachedName))) {
	    strcpy(cachedName, name);
	    firstCall = 0;
	}
    } else {
	name = cachedName;
    }
# else /* openVMS */
# endif
#endif
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

%{  /* NOCONTEXT */

#ifdef UNIX_LIKE
    int uid;

    uid = getuid();
    RETURN ( __mkSmallInteger(uid) );
#else
# ifdef SYSTEM_HAS_USERS
    /* ... */
# endif
#endif
%}.
    ^ 1 "just a dummy for systems which do not have userIDs"

    "
     OperatingSystem getUserID
    "
!

getUserNameFromID:aNumber
    "{ Pragma: +optSpace }"

    "return the user-name-string for a given numeric user-id.
     This is the login name, not the fullName."

%{  /* NOCONTEXT */

#ifdef UNIX_LIKE
# ifndef NO_PWD
    struct passwd *p;

    if (__isSmallInteger(aNumber)) {
	p = getpwuid(__intVal(aNumber));
	if (p) {
	    RETURN ( __MKSTRING(p->pw_name) );
	}
    }
# else
#  ifdef __VMS__
#  endif
# endif
#endif /* unix-like */
%}.
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

    |info name passw uid gid age comment
     gecos dir shell|

%{
#ifdef UNIX_LIKE
# ifndef NO_PWD
    struct passwd *buf;
    int ret;

    if (__isString(aNameOrID)) {
	buf = getpwnam(__stringVal(aNameOrID));
    } else if (__isSmallInteger(aNameOrID)) {
	buf = getpwuid(__intVal(aNameOrID));
    } else {
	buf = (struct passwd *)0;
    }
    if (buf) {
	name = __MKSTRING(buf->pw_name);
#  ifndef NO_PWD_PASSWD
	passw = __MKSTRING(buf->pw_passwd);
#  endif
#  ifdef SYSV4
	age = __MKSTRING(buf->pw_age);
	comment = __MKSTRING(buf->pw_comment);
#  endif
	dir = __MKSTRING(buf->pw_dir);
#  ifndef NO_PWD_GECOS
	gecos = __MKSTRING(buf->pw_gecos);
#  endif
	shell = __MKSTRING(buf->pw_shell);

	uid = __mkSmallInteger(buf->pw_uid);
	gid = __mkSmallInteger(buf->pw_gid);
    }
# endif /* has PWD */
#endif
%}.
    info := IdentityDictionary new.
    name isNil ifTrue:[
	aNameOrID == self getUserID ifTrue:[
	    name := self getLoginName
	].
    ].
    name notNil ifTrue:[
	info at:#name put:name.
    ] ifFalse:[
	info at:#name put:'unknown'
    ].
    passw notNil ifTrue:[info at:#passwd put:passw].
    age notNil ifTrue:[info at:#age put:age].
    comment notNil ifTrue:[info at:#comment put:comment].
    gecos notNil ifTrue:[info at:#gecos put:gecos].
    shell notNil ifTrue:[info at:#shell put:shell].
    dir isNil ifTrue:[
	aNameOrID == self getUserID ifTrue:[
	    dir := self getHomeDirectory
	]
    ].
    dir notNil ifTrue:[info at:#dir put:dir].
    uid notNil ifTrue:[info at:#uid put:uid].
    gid  notNil ifTrue:[info at:#gid put:gid].
    ^ info

    "
     OperatingSystem userInfoOf:'root'
     OperatingSystem userInfoOf:1
     OperatingSystem userInfoOf:'claus'
     OperatingSystem userInfoOf:'fooBar'
     OperatingSystem userInfoOf:(OperatingSystem getUserID)
    "
! !

!OpenVMSOperatingSystem class methodsFor:'waiting for events'!

blockingChildProcessWait
     "return true, if childProcessWait: blocks, if no children are ready.
      On those systems, we must be somewhat careful when looking out for
      a subprocesses status (to avoid blocking)."

%{ /*NOCONTEXT*/
#if defined(__VMS__)
    RETURN(false);
#else
    RETURN(true);
#endif
%}
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
#ifdef __VMS__
    {
	long endStatus, endPid;

	if (! __vms_waitPid(-1, &endStatus, &endPid)) {
	    /*
	     * no process finished
	     */
	    RETURN(nil);
	}
	status = @symbol(exit);
	code = __MKUINT(endStatus);
	pid = __MKUINT(endPid);
	core = false;
    }
#endif /* __VMS__ */
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

numAvailableForReadOn:fd
    "return the number of bytes available for reading, without blocking."

%{
#ifdef NOTDEF   /* does not work ... */
    /*
     * if available, try FIONREAD first, which is usually done faster.
     */
# if defined(FIONREAD)
    {
	int n;

	if (__isSmallInteger(fd)) {
	    if (ioctl(__intVal(fd), FIONREAD, &n) >= 0) {
		RETURN (__MKINT(n));
	    }
	}
    }
# endif /* FIONREAD */
#endif
%}.
    ^ (self readCheck:fd) ifTrue:[1] ifFalse:[0]
!

readCheck:fd
    "return true, if data is available on a filedescriptor
     (i.e. read is possible without blocking).
     This depends on a working select or FIONREAD to be provided by the OS."

%{
#ifdef NOTDEF   /* does not work ... */
    /*
     * if available, try FIONREAD first, which is usually done faster.
     */
# if defined(FIONREAD)
    {
	int n;

	if (__isSmallInteger(fd)) {
	    if (n = ioctl(__intVal(fd), FIONREAD)) {
		printf("FIONREAD returns %d\n", n);
	    }
	}
    }
# endif /* FIONREAD */
#endif

# ifdef __VMS__
#  ifdef DOES_NOT_WORK_YET
    {
	/*
	 * do a sys$qio ..
	 * fd here is suposed to be a channel nr.
	 */
	struct IOSB iosb;
	int status;
	int channel;
	struct typahdask sensebuf;

	if (__isSmallInteger(fd)) {
	    channel = __intVal(fd);
	    status = SYS$QIO(0, /* efn */
			     channel,
			     IO$_SENSEMODE | IO$M_TYPEAHDCNT,
			     &iosb,
			     0, /* ast */
			     0, /* ast arg */
			     &sensebuf,         /* data */
			     sizeof(sensebuf),  /* data size */
			     0, 0, 0, 0);
	    if (status != SS$_NORMAL) {
		fprintf(stderr, "OS [info]: SYS$QIO failed on %d\n", channel);
	    } else {
		fprintf(stderr, "sys$QIO -> %d\n", sensebuf.typcnt);
	    }
	}
    }
#  endif
# endif /* __VMS__ */
%}.

    ^ super readCheck:fd
!

selectOnAnyReadable:readFdArray writable:writeFdArray exception:exceptFdArray withTimeOut:millis
    "wait for any fd in readFdArray (an Array of integers) to become ready for
     reading, writeFdArray to become ready for writing, or exceptFdArray to
     arrive exceptional data (i.e. out-of-band data).
     Timeout after t milliseconds or, if the timeout time is 0, immediately..
     Empty fd-sets will always wait. Zero time can be used to poll file-
     descriptors (i.e. to check if I/O possible without blocking).
     Return first ready fd if I/O ok, nil if timed-out or interrupted."

%{
    fd_set rset, wset, eset;
    struct timeval wt, et;
    int f, maxF, i, lX, bX;
    INT t;
    OBJ fd, retFd;
    int ret;
    int count;
    int numFds = 0;

    if (__isSmallInteger(millis)) {
	FD_ZERO(&rset);
	FD_ZERO(&wset);
	FD_ZERO(&eset);

	maxF = -1;
	if (__isNonNilObject(readFdArray)) {
	    if (! __isArrayLike(readFdArray)) {
		goto fail;
	    }
	    count = __arraySize(readFdArray);

	    for (i=0; i<count;i++) {
		fd = __ArrayInstPtr(readFdArray)->a_element[i];
		if (fd != nil) {
		    f = __intVal(fd);
		    if ((unsigned)f < FD_SETSIZE) {
			FD_SET(f, &rset);
			if (f > maxF) maxF = f;
			numFds++;
		    }
		}
	    }
	}

	if (__isNonNilObject(writeFdArray)) {
	    if (! __isArrayLike(writeFdArray)) {
		goto fail;
	    }
	    count = __arraySize(writeFdArray);
	    for (i=0; i<count;i++) {
		fd = __ArrayInstPtr(writeFdArray)->a_element[i];
		if (fd != nil) {
		    f = __intVal(fd);
		    if ((unsigned)f < FD_SETSIZE) {
			FD_SET(f, &wset);
			if (f > maxF) maxF = f;
			numFds++;
		    }
		}
	    }
	}

	if (__isNonNilObject(exceptFdArray)) {
	    if (! __isArrayLike(exceptFdArray)) {
		goto fail;
	    }
	    count = __arraySize(exceptFdArray);
	    for (i=0; i<count;i++) {
		fd = __ArrayInstPtr(exceptFdArray)->a_element[i];
		if (fd != nil) {
		    f = __intVal(fd);
		    if ((unsigned)f < FD_SETSIZE) {
			FD_SET(f, &eset);
			if (f > maxF) maxF = f;
			numFds++;
		    }
		}
	    }
	}

	t = __intVal(millis);
	if (t) {
	    wt.tv_sec = t / 1000;
	    wt.tv_usec = (t % 1000) * 1000;
	} else {
	    wt.tv_sec = wt.tv_usec = 0;
	}

	/*
	 * make certain, that interrupt gets us out of the select
	 * However, we must then care for moved objects.
	 */
	__BEGIN_INTERRUPTABLE__
	errno = 0;

	if (t == 0) {
	    /*
	     * if there is no timeout time, we can stay here interruptable.
	     */
	    do {
		ret = select(maxF+1, &rset, &wset, &eset, &wt);
	    } while ((ret < 0) && (errno == EINTR));
	} else {
	    do {
		ret = select(maxF+1, &rset, &wset, &eset, &wt);
		/*
		 * for now: dont loop; if we did, we had to adjust the vt-timeval;
		 * could otherwise stay in this loop forever ...
		 * Premature return (before the time expired) must be handled by the caller.
		 * A good solution is to update the wt-timeval and redo the select.
		 */
	    } while (0 /* (ret < 0) && (errno == EINTR) */ );
	}
	__END_INTERRUPTABLE__

	if (ret > 0) {
	    for (i=0; i <= maxF; i++) {
		if (FD_ISSET(i, &rset)
		 || FD_ISSET(i, &wset)
		 || FD_ISSET(i, &eset)) {
		    RETURN ( __mkSmallInteger(i) );
		}
	    }
	} else {
	    if (ret < 0) {
		if (errno == EINTR) {
		    errno = 0;
		    @global(LastErrorNumber) = nil;
		} else {
		    if (@global(InfoPrinting) == true) {
			fprintf(stderr, "OS [info]: select errno = %d\n", errno);
		    }
		    @global(LastErrorNumber) = __mkSmallInteger(errno);
		}
	    } else {
		@global(LastErrorNumber) = nil;
	    }
	}

	/*
	 * return nil (means time expired or interrupted)
	 */
	RETURN ( nil );
    }

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
     If cleared, a read operation will immediately return with a value of
     nil."

%{  /* NOCONTEXT */

    int ret, flags;

#if defined(F_GETFL) && defined(F_SETFL)
# if defined(FNDELAY)
    if (__isSmallInteger(fd)) {
	int f = __intVal(fd);

	flags = fcntl(f, F_GETFL, 0);
	if (aBoolean == true) {
	    ret = fcntl(f, F_SETFL, flags & ~FNDELAY);
	} else {
	    ret = fcntl(f, F_SETFL, flags | FNDELAY);
	}
	if (ret >= 0) ret = flags;
	RETURN ( __mkSmallInteger(ret) );
    }
# endif
#endif
%}.
    "
     fd argument not integer
    "
    ^ self primitiveFailed
! !

!OpenVMSOperatingSystem::FileStatusInfo class methodsFor:'instance creation'!

type:t mode:m uid:u gid:g size:s id:i accessed:aT modified:mT statusChanged:sT path:lP
    ^ self basicNew
	type:t mode:m uid:u gid:g size:s id:i accessed:aT modified:mT statusChanged:sT path:lP
! !

!OpenVMSOperatingSystem::FileStatusInfo methodsFor:'accessing'!

accessed
    "return accessed"

    ^ accessed!

alternativeName
    "return the files other name (DOS name on windows).
     Nil if there is no other name"

    ^ nil
!

fixedHeaderSize
    "return the fixedHeaderSize (VMS only; nil everywhere else)"

    ^ fixedHeaderSize
!

gid
    "return gid"

    ^ gid!

id
    "return id"

    ^ id!

mode
    "return mode"

    ^ mode!

modified
    "return modified"

    ^ modified!

path
    "for symbolic links only: return the path where the symbolic link points to"

    ^ path

!

recordAttributes
    "return the recordAttributes (VMS only; nil everywhere else)"

    ^ recordAttributes
!

recordFormat
    "return the recordFormat (VMS only; nil everywhere else)"

    ^ recordFormat
!

recordFormatNumeric
    "return the recordFormat as numeric (VMS only; nil everywhere else)"

    ^ recordFormatNumeric
!

recordSize
    "return the recordSize (VMS only; nil everywhere else)"

    ^ recordSize
!

size
    "return size"

    ^ size!

statusChanged
    "return statusChanged"

    ^ statusChanged!

type
    "return type"

    ^ type!

uid
    "return uid"

    ^ uid
! !

!OpenVMSOperatingSystem::FileStatusInfo methodsFor:'backward compatibility'!

at:key
    "backward compatibility access: in previous releases, IdentityDictionaries
     were used to hold my information. Allow access via key messages.
     This method will vanish - use the proper access protocol."

    ^ self perform:key
! !

!OpenVMSOperatingSystem::FileStatusInfo methodsFor:'private accessing'!

recordFormat:rf recordFormatNumeric:nrf recordAttributes:ra fixedHeaderSize:hs recordSize:rs
    recordFormat := rf.
    recordFormatNumeric := nrf.
    recordAttributes := ra.
    fixedHeaderSize := hs.
    recordSize := rs
!

type:t mode:m uid:u gid:g size:s id:i accessed:aT modified:mT statusChanged:sT path:lP
    type := t.
    mode := m.
    uid := u.
    gid := g.
    size := s.
    id := i.
    accessed := aT.
    modified := mT.
    statusChanged := sT.
    path := lP.
! !

!OpenVMSOperatingSystem::OSProcessStatus class methodsFor:'documentation'!

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

!OpenVMSOperatingSystem::OSProcessStatus class methodsFor:'instance creation'!

pid:pid status:status code:code core:core
    "private interface for OpenVMSOperatingSystem"

    ^ self new pid:pid status:status code:code core:core

    "Created: 28.12.1995 / 14:16:14 / stefan"
    "Modified: 30.4.1996 / 18:25:00 / cg"
!

processCreationFailure
    "private interface for OpenVMSOperatingSystem"

    ^ self new pid:-1 status:#failure code:-1 core:false

    "Created: 28.12.1995 / 14:35:29 / stefan"
    "Modified: 30.4.1996 / 18:25:05 / cg"
! !

!OpenVMSOperatingSystem::OSProcessStatus methodsFor:'accessing'!

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

!OpenVMSOperatingSystem::OSProcessStatus methodsFor:'initialization'!

pid:newPid status:newStatus code:newCode core:newCore
    pid := newPid.
    status := newStatus.
    code := newCode.
    core := newCore.

    "Created: 28.12.1995 / 14:18:22 / stefan"
! !

!OpenVMSOperatingSystem::OSProcessStatus methodsFor:'private-OS interface'!

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

!OpenVMSOperatingSystem::OSProcessStatus methodsFor:'queries'!

couldNotExecute
    "return true when a command could not be executed"

    ^ status == #exit and:[code = 127].

    "Created: 28.12.1995 / 15:43:17 / stefan"
    "Modified: 30.4.1996 / 18:27:03 / cg"
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

!OpenVMSOperatingSystem class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
OpenVMSOperatingSystem initialize!
