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

StreamError subclass:#OpenError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!OpenError class methodsFor:'documentation'!

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
! !

!OpenError methodsFor:'accessing'!

pathName
    "the name of the file/device which failed to open"

    (parameter respondsTo:#pathName) ifTrue:[
        ^ parameter pathName.
    ].
    ^ parameter

    "Modified: / 16-01-2008 / 20:24:24 / cg"
!

stream
    "the stream which failed to open"

    ^ parameter
! !

!OpenError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/OpenError.st,v 1.13 2013-12-04 11:23:19 stefan Exp $'
! !

