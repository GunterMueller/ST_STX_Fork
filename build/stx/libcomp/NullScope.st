"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

Object subclass:#NullScope 
       instanceVariableNames:''
       classVariableNames:''
       poolDictionaries:''
       category:'System-Compiler ST-80-compatibility'
!

!NullScope class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

version
    ^ '$Header: /cvs/stx/stx/libcomp/NullScope.st,v 1.5 1995-11-11 15:30:39 cg Exp $'
!

documentation
"
    This is a pure mimicri class.
    It is not used by ST/X, but provided to support limited
    compatibility for applications which build up codetrees,
    knowing internals of ST-80's compiler class hierarchy.
    This classes protocol is not (not meant to be) fully covering
    the corresponding ST-80's classes protocol. It maps ST-80 messages
    to corresponding ST/X messages (as far as possible).

    NO WARRANTY and GUARANTEE; this class may be removed without notice.
"
! !


