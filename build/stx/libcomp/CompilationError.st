"
 COPYRIGHT (c) 1989 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

ParseError subclass:#CompilationError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!CompilationError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    raised for code-generator problems.
    This can only be a super-sized method, for which we run out of literal-,
    or another index.
"
! !

!CompilationError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/CompilationError.st,v 1.2 2013-04-03 17:21:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/CompilationError.st,v 1.2 2013-04-03 17:21:19 cg Exp $'
! !

