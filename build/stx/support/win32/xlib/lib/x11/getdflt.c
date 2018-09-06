/* $XConsortium: GetDflt.c,v 1.34 94/11/30 16:19:43 kaleb Exp $ */

/***********************************************************

Copyright (c) 1987, 1988  X Consortium

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
X CONSORTIUM BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of the X Consortium shall not be
used in advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization from the X Consortium.


Copyright 1987, 1988 by Digital Equipment Corporation, Maynard, Massachusetts.

                        All Rights Reserved

Permission to use, copy, modify, and distribute this software and its 
documentation for any purpose and without fee is hereby granted, 
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in 
supporting documentation, and that the name of Digital not be
used in advertising or publicity pertaining to distribution of the
software without specific, written prior permission.  

DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
SOFTWARE.

******************************************************************/

#include "Xlibint.h"
#include <X11/Xos.h>
#include <X11/Xresource.h>
#ifndef WIN32
#include <pwd.h>
#endif
#include <stdio.h>
#include <ctype.h>

#ifdef X_NOT_STDC_ENV
extern char *getenv();
#endif

/*ARGSUSED*/
static char *GetHomeDir (dest, destlen)
	char *dest;
	int destlen;
{
#ifdef WIN32
	register char *ptr;

	if (ptr = getenv("HOME"))
		(void) strcpy(dest, ptr);
	else {
		if (ptr = getenv("USERNAME")) {
			(void) strcpy (dest, "/users/");
			(void) strcat (dest, ptr);
		}
	}
	return dest;
#else
#ifndef X_NOT_POSIX
        uid_t uid;
#else
	int uid;
	extern int getuid();
#ifndef i386
# ifndef SYSV
	extern struct passwd *getpwuid(), *getpwnam();
# endif
#endif
#endif
#if defined(sun) && defined(SVR4) && defined(XTHREADS)
	struct passwd pws;
	char pwbuf[512];	/* ought to use MAX_INPUT */
#endif
	struct passwd *pw;
	register char *ptr;

	if (ptr = getenv("HOME")) {
		(void) strcpy(dest, ptr);

	} else {
		if (ptr = getenv("USER")) {
#if defined(sun) && defined(SVR4) && defined(XTHREADS)
			pw = getpwnam_r(ptr, &pws, pwbuf, sizeof pwbuf);
#else
			pw = getpwnam(ptr);
#endif
		} else {
			uid = getuid();
#if defined(sun) && defined(SVR4) && defined(XTHREADS)
			pw = getpwuid_r(uid, &pws, pwbuf, sizeof pwbuf);
#else
			pw = getpwuid(uid);
#endif
		}
		if (pw) {
			(void) strcpy(dest, pw->pw_dir);
		} else {
		        *dest = '\0';
		}
	}
	return dest;
#endif
}


static XrmDatabase InitDefaults (dpy)
    Display *dpy;			/* display for defaults.... */
{
    XrmDatabase userdb;
    XrmDatabase xdb;
    char fname[BUFSIZ];                 /* longer than any conceivable size */
    char *xenv;

    XrmInitialize();

    /*
     * See lib/Xtk/Initialize.c
     *
     * First, get the defaults from the server; if none, then load from
     * ~/.Xdefaults.  Next, if there is an XENVIRONMENT environment variable,
     * then load that file.
     */

    if (dpy->xdefaults == NULL) {
	(void) GetHomeDir (fname, sizeof(fname));
	(void) strcat (fname, "/.Xdefaults");
	xdb = XrmGetFileDatabase (fname);
    } else {
	xdb = XrmGetStringDatabase(dpy->xdefaults);
    }

    if (!(xenv = getenv ("XENVIRONMENT"))) {
	int len;
	(void) GetHomeDir (fname, sizeof(fname));
	(void) strcat (fname, "/.Xdefaults-");
	len = strlen (fname);
	(void) _XGetHostname (fname+len, BUFSIZ-len);
	xenv = fname;
    }
    userdb = XrmGetFileDatabase (xenv);
    XrmMergeDatabases (userdb, &xdb);
    return (xdb);

#ifdef old
    if (fname[0] != '\0') userdb =  XrmGetFileDatabase(fname);
    xdb = XrmGetStringDatabase(dpy->xdefaults);
    XrmMergeDatabases(userdb, &xdb);
    return xdb;
#endif
}

#if NeedFunctionPrototypes
char *XGetDefault(
	Display *dpy,			/* display for defaults.... */
	char _Xconst *prog,		/* name of program for option	*/
	register _Xconst char *name)	/* name of option program wants */
#else
char *XGetDefault(dpy, prog, name)
	Display *dpy;			/* display for defaults.... */
	char *prog;			/* name of program for option	*/
	register char *name;		/* name of option program wants */
#endif
{					/* to get, for example, "font"  */
	XrmName names[3];
	XrmClass classes[3];
	XrmRepresentation fromType;
	XrmValue result;
	char *progname;
#ifdef WIN32
	char *progname2;
#endif

	/*
	 * strip path off of program name (XXX - this is OS specific)
	 */
	progname = strrchr (prog, '/');
#ifdef WIN32
	progname2 = strrchr (prog, '\\');
	if (progname2 && (!progname || progname < progname2))
	    progname = progname2;
#endif
	if (progname)
	    progname++;
	else
	    progname = (char *)prog;

	/*
	 * see if database has ever been initialized.  Lookups can be done
	 * without locks held.
	 */
	LockDisplay(dpy);
	if (dpy->db == NULL) {
		dpy->db = InitDefaults(dpy);
		}
	UnlockDisplay(dpy);

	names[0] = XrmStringToName(progname);
	names[1] = XrmStringToName(name);
	names[2] = NULLQUARK;
	classes[0] = XrmStringToClass("Program");
	classes[1] = XrmStringToClass("Name");
	classes[2] = NULLQUARK;
	(void)XrmQGetResource(dpy->db, names, classes, &fromType, &result);
	return (result.addr);
}

