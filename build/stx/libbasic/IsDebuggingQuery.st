"
 COPYRIGHT (c) 2012 by eXept Software AG
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

Query subclass:#IsDebuggingQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Debugger'
!

!IsDebuggingQuery class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by eXept Software AG
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
    Answered by the debugger while we are in it.

    Currently the only one interested in that are Futures,
    which will not force their value while in the debugger
    (so we can look at a future inside a debugger's inspector without
    forcing them)

    [Author:]
        Stefan Vogel, eXept
"
! !

!IsDebuggingQuery methodsFor:'default values'!

defaultResumeValue
    "the default answer, if no one handles the query"

    ^ false
! !

!IsDebuggingQuery class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/IsDebuggingQuery.st,v 1.4 2014-12-30 12:39:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/IsDebuggingQuery.st,v 1.4 2014-12-30 12:39:56 cg Exp $'
! !

