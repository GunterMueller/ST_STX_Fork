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

OSFileHandle subclass:#Win32FILEHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Windows'
!

!Win32FILEHandle primitiveDefinitions!
%{
#include <stdio.h>
%}

! !

!Win32FILEHandle class methodsFor:'documentation'!

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
!

documentation
"
    I represent a FILE*, as used in the stdio library.

    Since most stdio libs are inherently buggy, thread-unsave
    and hard to use in a multithreading environment,
    these will no longer be used in future ST/X versions.
    However, they may be useful when interfacing to external
    libraries...
"
! !

!Win32FILEHandle methodsFor:'release'!

closeFile
    "close the file"

%{
    FILE *f = (FILE *)(__externalAddressVal(self));

    if (f) {
        __externalAddressVal(self) = NULL;
        fclose(f);
    }
%}.
! !

!Win32FILEHandle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/Win32FILEHandle.st,v 1.5 2011-09-29 11:19:13 cg Exp $'
! !
