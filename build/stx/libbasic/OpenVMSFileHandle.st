OSFileHandle subclass:#OpenVMSFileHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-OpenVMS'
!

!OpenVMSFileHandle primitiveDefinitions!
%{
#include <stdio.h>
%}

! !


!OpenVMSFileHandle methodsFor:'finalization'!

disposed
    "a file handle was garbage collected - close the underlying file"

%{
    FILE *f = (FILE *)(__externalAddressVal(self));

    if (f) {
        __externalAddressVal(self) = NULL;
        fclose(f);
    }
%}



! !

!OpenVMSFileHandle methodsFor:'release'!

close
    "close the file"

%{
    FILE *f = (FILE *)(__externalAddressVal(self));

    if (f) {
        __externalAddressVal(self) = NULL;
        fclose(f);
    }
%}.
    Lobby unregister:self



! !

!OpenVMSFileHandle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/OpenVMSFileHandle.st,v 1.1 1999/09/18 11:11:28 cg Exp $'
! !



