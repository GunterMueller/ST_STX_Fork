"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

FileStream subclass:#DirectoryStream
	instanceVariableNames:'dirPointer readAheadEntry'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-External'
!

!DirectoryStream primitiveDefinitions!
%{
#include "stxOSDefs.h"

#if defined(__win32__)
# undef UNIX_LIKE
#else
# if defined(__transputer__)
#  undef UNIX_LIKE
# else
#  define UNIX_LIKE
# endif
#endif

#ifdef UNIX_LIKE
# if defined(__GLIBC__) && (__GLIBC__ == 2)
#  if defined(__GLIBC_MINOR__) && (__GLIBC_MINOR__ == 1)
    /* there is a bug there, preventing 64bit readdir. */
#   undef __USE_FILE_OFFSET64
#   undef __USE_LARGEFILE64
#  endif
# endif

# include <stdio.h>
# define _STDIO_H_INCLUDED_

# include <errno.h>
# define _ERRNO_H_INCLUDED_

# include <sys/types.h>
# include <sys/stat.h>

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

/*
 * on some systems errno is a macro ... check for it here
 */
# ifndef errno
  extern errno;
# endif

#endif /* UNIX_LIKE */

#ifdef __win32__

# ifdef __i386__
#  define _X86_
# endif

# undef INT
# undef UINT
# undef Array
# undef Number
# undef Method
# undef Point
# undef Context
# undef Rectangle
# undef Block
# undef Time
# undef Date
# undef Message
# undef Process
# undef Processor
# undef INT

/* # include <types.h> /* */
# include <stdarg.h> /* */
# include <errno.h>
# define _ERRNO_H_INCLUDED_
# include <windef.h> /* */
# include <winbase.h> /* */
/* # include <wingdi.h> /* */
/* # include <winuser.h> /* */

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
# ifdef __DEF_Block
#  define Block __DEF_Block
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
# ifdef __DEF_Message
#  define Message __DEF_Message
# endif
# ifdef __DEF_Process
#  define Process __DEF_Process
# endif
# ifdef __DEF_Processor
#  define Processor __DEF_Processor
# endif

# define INT STX_INT
# define UINT STX_UINT

# define __HANDLEVal(o)  (HANDLE)__externalAddressVal(o)
// extern OBJ FileTimeToOsTime();
extern OBJ FileTimeToOsTime1970();
#endif /* __win32__ */

#include "stxOSDefs.h"
%}
! !

!DirectoryStream primitiveFunctions!
%{

#ifndef HAS_OPENDIR

# if defined(__VMS__)

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

# endif /* __VMS__ */
#endif /* not HAS_OPENDIR */
%}
! !

!DirectoryStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    Instances of DirectoryStream allow reading a file-directory,
    as if it was a stream of filenames.
    Basically, its an interface to opendir, readdir and closedir.
    Notice:
	DirectoryStream is an ST/X special;
	for portability, we recommend the use of Filename protocol.

    [author:]
	Claus Gittinger

    [see also:]
	Filename
"
! !

!DirectoryStream class methodsFor:'instance creation'!

directoryNamed:dirName
    "return a DirectoryStream for directory named dirName, aString
     Raises an openError, if the directory does not exists."

    |newStream|

    newStream := (self basicNew) text; pathName:dirName.
    newStream openForReading isNil ifTrue:[^nil].
    ^ newStream

    "
     self directoryNamed:'adadasd'
     self directoryNamed:'.'
    "
! !

!DirectoryStream methodsFor:'access-reading'!

contents
    "answer all of the directory entries as an OrderedCollection"

    |contents|

    contents := OrderedCollection new.
    [self atEnd] whileFalse:[
	|l|
	l := self nextLine.
	l isNil ifTrue:[
	    ^ contents
	].
	contents add:l
    ].
    ^ contents
!

nextLine
    "return the next filename as a string or nil"

    |linkInfo|

    linkInfo := self nextLinkInfo.
    linkInfo notNil ifTrue:[^ linkInfo sourcePath].
    ^ nil
!

nextLinkInfo
    "return the next FileStatusInfo or nil"

    |nextResult resultInfo|

    (hitEOF or:[readAheadEntry isNil]) ifTrue:[
	^ self pastEndRead
    ].

    nextResult := OperatingSystem nextLinkInfoFrom:self dirPointer:dirPointer.
    nextResult isNil ifTrue:[
	hitEOF := true.
    ].
    readAheadEntry notNil ifTrue:[
	resultInfo := readAheadEntry.
	readAheadEntry := nextResult.
	^ resultInfo
    ].
    nextResult isNil ifTrue:[
	^ self pastEndRead
    ].
    ^ nextResult
! !

!DirectoryStream protectedMethodsFor:'instance release'!

closeFile
    "low level close of a directoryStream"

    |dp|

    dp := dirPointer.
    dp isNil ifTrue:[
	^ self errorNotOpen.
    ].
    dirPointer := nil.
%{
#ifdef HAS_OPENDIR
    closedir( (DIR *)(__FILEVal(dp)) );
#else
# ifdef __win32__
    FindClose( __HANDLEVal(dp) );
# endif
#endif
%}
! !

!DirectoryStream methodsFor:'private'!

openForReading
    "open the file for readonly"

    |ok encodedPathName error fileSize osPathname osModTime osCrtTime osAccTime osFileAttributes |

    encodedPathName := OperatingSystem encodePath:pathName.
    mode := #readonly.
    hitEOF := false.

%{
    enum {
    	PASS_INITIAL = 1,
    	PASS_RETRY_AFTER_SCAVENGE = 2,
    	PASS_RETRY_AFTER_GARBAGE_COLLECT = 3,
    	PASS_FINAL = PASS_RETRY_AFTER_GARBAGE_COLLECT
    } pass = PASS_INITIAL;
#ifdef HAS_OPENDIR
    DIR *d;
    OBJ path, dp;

retry:
    ok = false;
    if (__INST(dirPointer) == nil) {
	if (__isStringLike(encodedPathName)) {
	    __BEGIN_INTERRUPTABLE__
	    __threadErrno = 0;
	    do {
		d = opendir((char *) __stringVal(encodedPathName));
	    } while ((d == NULL) && (__threadErrno == EINTR));
	    __END_INTERRUPTABLE__

	    if (d == NULL) {
		error = __mkSmallInteger(__threadErrno);
	    } else {
		dp = __MKEXTERNALADDRESS(d); __INST(dirPointer) = dp; __STORE(self, dp);
		ok = true;
	    }
	}
    }
#else
#ifdef __win32__
    HANDLE d;
    OBJ path, dp;
    union {
	char pattern[MAXPATHLEN];
	wchar_t wpattern[MAXPATHLEN];
    } uP;
    union {
	WIN32_FIND_DATAA data;
	WIN32_FIND_DATAW wdata;
    } uD;

retry:
    ok = false;
    if (__INST(dirPointer) == nil) {
	path = __INST(pathName);
	if (__isStringLike(path)) {
	    int l = __stringSize(path);

	    if (l < (MAXPATHLEN-4)) {
		strncpy(uP.pattern, __stringVal(path), l);
		strcpy(uP.pattern+l, "\\*");

		do {
		    __threadErrno = 0;
		    d = STX_API_NOINT_CALL2( "FindFirstFileA", FindFirstFileA, uP.pattern, &uD.data );
		} while ((d < 0) && (__threadErrno == EINTR));

		if (d == INVALID_HANDLE_VALUE) {
		    error = __mkSmallInteger(GetLastError());
		} else {
		    dp = __MKEXTERNALADDRESS(d); __INST(dirPointer) = dp; __STORE(self, dp);

		    fileSize   = __MKLARGEINT64(1, uD.data.nFileSizeLow, uD.data.nFileSizeHigh );
		    osPathname = __MKSTRING( uD.data.cFileName );
		    osFileAttributes = __mkSmallInteger( uD.data.dwFileAttributes );

		    osCrtTime = FileTimeToOsTime1970(&uD.data.ftCreationTime);
		    osAccTime = FileTimeToOsTime1970(&uD.data.ftLastAccessTime);
		    osModTime = FileTimeToOsTime1970(&uD.data.ftLastWriteTime);
		    ok = true;
		}
	    }
	}
	else if (__isUnicode16String(path)) {
	    int l = __unicode16StringSize(path);
	    int i;

	    if (l < (MAXPATHLEN-4)) {
		for (i=0; i<l; i++) {
		    uP.wpattern[i] = __unicode16StringVal(path)[i];
		}
		uP.wpattern[i++] = '\\';
		uP.wpattern[i++] = '*';
		uP.wpattern[i] = 0;

		do {
		    __threadErrno = 0;
		    d = STX_API_NOINT_CALL2( "FindFirstFileW", FindFirstFileW, uP.wpattern, &uD.wdata );
		} while ((d < 0) && (__threadErrno == EINTR));

		if (d == INVALID_HANDLE_VALUE) {
		    error = __mkSmallInteger(GetLastError());
		} else {
		    dp = __MKEXTERNALADDRESS(d); __INST(dirPointer) = dp; __STORE(self, dp);

		    fileSize   = __MKLARGEINT64(1, uD.wdata.nFileSizeLow, uD.wdata.nFileSizeHigh );
		    osPathname = __MKU16STRING( uD.wdata.cFileName );
		    osFileAttributes = __mkSmallInteger( uD.data.dwFileAttributes );

		    osCrtTime = FileTimeToOsTime1970(&uD.wdata.ftCreationTime);
		    osAccTime = FileTimeToOsTime1970(&uD.wdata.ftLastAccessTime);
		    osModTime = FileTimeToOsTime1970(&uD.wdata.ftLastWriteTime);
		    ok = true;
		}
	    }
	}
    }
#endif
#endif
    /*
    * If no filedescriptors available, try to finalize
    * possibly collected fd's and try again.
    */
    if ((__threadErrno == ENFILE || __threadErrno == EMFILE) && pass < PASS_FINAL) {
        switch (pass) {
       	    case PASS_INITIAL:
                {
                    pass = PASS_RETRY_AFTER_SCAVENGE;
                    __SSEND0(@global(ObjectMemory), @symbol(scavenge), 0);	    
                    __SSEND0(@global(ObjectMemory), @symbol(finalize), 0);
                }
                goto retry;
            case PASS_RETRY_AFTER_SCAVENGE:
                {
                     pass = PASS_RETRY_AFTER_GARBAGE_COLLECT;
                    __SSEND0(@global(ObjectMemory), @symbol(garbageCollect), 0);	    
                    __SSEND0(@global(ObjectMemory), @symbol(finalize), 0);
                }
                goto retry;
            case PASS_RETRY_AFTER_GARBAGE_COLLECT:
                /* Should never be reached */
                goto getOutOfHere;
        }                    
    }
    getOutOfHere:;
%}.

    ok == true ifTrue:[
	self registerForFinalization.
	osPathname isNil ifTrue:[
	    "UNIX: does not automatically provide the first entry"

	    StreamError handle:[:ex |
		self close.
		ex reject.
	    ] do:[
		readAheadEntry := OperatingSystem nextLinkInfoFrom:self dirPointer:dirPointer.
	    ].
	] ifFalse:[
	    "Windows already provides the first entry's info"

	    readAheadEntry := OperatingSystem
		linkInfoFor:osPathname
		fileSize:fileSize
		fileAttributes:osFileAttributes
		osCrtTime:osCrtTime
		osAccTime:osAccTime
		osModTime:osModTime
	].

	^ self
    ].

    ok notNil ifTrue:[
	dirPointer notNil ifTrue:[^ self errorAlreadyOpen].
    ].
    error notNil ifTrue:[
	^ self openError:(lastErrorNumber := error).
    ].
    ^ nil
!

reOpen
    "USERS WILL NEVER INVOKE THIS METHOD
     sent after snapin to reopen streams."

    dirPointer := nil.
    super reOpen
! !

!DirectoryStream methodsFor:'testing'!

atEnd
    "return true, if position is at end"

    ^ readAheadEntry == nil
!

isEmpty
    "test for if the unread portion of the directory stream is empty.
     This query changes the readPointer of the DirectoryStream"

    |entry|

    [self atEnd] whileFalse:[
	entry := self nextLine.
	entry asFilename isImplicit ifFalse:[
	    ^ false.
	]
    ].
    ^ true


    "
	(DirectoryStream directoryNamed:'/') isEmpty
	(DirectoryStream directoryNamed:'/var/tmp') isEmpty
    "

    "Modified: 18.9.1997 / 18:05:31 / stefan"
!

isOpen
    ^ dirPointer notNil.
! !

!DirectoryStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !
