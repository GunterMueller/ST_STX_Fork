"
 COPYRIGHT (c) 2003 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic' }"

ExternalBytes subclass:#MappedExternalBytes
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!MappedExternalBytes class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    Much like externalBytes - however, instances of MappedExternalBytes are created
    by mapping virtual memory (i.e. mmap).
    For now, this class provides only the minimum required protocol to support
    the VideoForLinux API for video grabbing.
    (actually, all that is found here is a redefined finalization method, as my instances
    must be freed by unmapping the underlying memory, as opposed to instances of my superclass,
    which must be freed w.r.t. malloc).

    More will (might be required) be added in the future.

    [authors:]
	Claus Gittinger
"
! !

!MappedExternalBytes methodsFor:'freeing'!

finalize
    "some MappedExternalBytes object was finalized;
     free the associated heap memory with it"

%{  /* NOCONTEXT */
#if defined(HAS_MMAP)

    char *_mem = (char *)(__INST(address_));
    OBJ sz = __INST(size);

# ifdef SUPERDEBUG
    console_fprintf(stderr, "MappedExternalBytes finalize\n");
# endif
    if (__isSmallInteger(sz)) {
	if (_mem && (OBJ)_mem != nil) {
# ifdef SUPERDEBUG
	    console_fprintf(stderr, "MappedExternalBytes munmap (%x, %d)\n", _mem, __intVal(sz));
# endif
	    munmap (_mem, __intVal(sz));
	}
	__INST(address_) = __INST(size) = nil;
    }
#endif /* HAS_MMAP */
%}
! !

!MappedExternalBytes class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/MappedExternalBytes.st,v 1.3 2007/02/22 15:27:19 cg Exp $'
! !



