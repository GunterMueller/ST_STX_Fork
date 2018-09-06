"
 COPYRIGHT (c) 2009 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

AbstractSourceFileReader subclass:#SmalltalkChunkFileSourceReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

!SmalltalkChunkFileSourceReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
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
    I know how to read smalltalk chunk file format
"
! !

!SmalltalkChunkFileSourceReader methodsFor:'fileIn'!

fileInStream: aStream
    ^ aStream fileIn

    "Modified: / 16-08-2009 / 10:00:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkChunkFileSourceReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/SmalltalkChunkFileSourceReader.st,v 1.9 2013-06-23 22:22:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/SmalltalkChunkFileSourceReader.st,v 1.9 2013-06-23 22:22:40 cg Exp $'
!

version_SVN
    ^'$Id: SmalltalkChunkFileSourceReader.st,v 1.9 2013-06-23 22:22:40 cg Exp $'
! !

