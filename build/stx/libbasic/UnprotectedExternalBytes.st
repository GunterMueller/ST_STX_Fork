"
 COPYRIGHT (c) 2006 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

ExternalBytes subclass:#UnprotectedExternalBytes
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!UnprotectedExternalBytes class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    This is just a factory to generate ExternalBytes.
    There are no instances of this class!!

    The difference to ExternalBytes is, that #new: returns unprotected ExternalBytes,
    that are not protected from garbage collecteded. ExternalBytes allocated #with new:
    are not garbage collected.

    [author:]
        Stefan Vogel

    [see also:]
        ExternalBytes
"
! !

!UnprotectedExternalBytes class methodsFor:'instance creation'!

new
    "return ExternalBytes"

    ^ ExternalBytes new
!

new:size
    "return unprotected ExternalBytes"

    ^ ExternalBytes unprotectedNew:size
! !

!UnprotectedExternalBytes class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/UnprotectedExternalBytes.st,v 1.2 2014-02-05 17:18:22 cg Exp $'
! !

