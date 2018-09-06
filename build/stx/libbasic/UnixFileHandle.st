"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

OSFileHandle subclass:#UnixFileHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Unix'
!

!UnixFileHandle primitiveDefinitions!
%{
#include <stdio.h>
%}
! !

!UnixFileHandle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!UnixFileHandle methodsFor:'release'!

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

!UnixFileHandle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/UnixFileHandle.st,v 1.4 2003/08/30 12:36:42 cg Exp $'
!

version_SVN
    ^ '$Id: UnixFileHandle.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !



