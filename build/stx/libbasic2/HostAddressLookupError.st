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
"{ Package: 'stx:libbasic2' }"

NameLookupError subclass:#HostAddressLookupError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!HostAddressLookupError class methodsFor:'documentation'!

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

!HostAddressLookupError class methodsFor:'initialization'!

initialize

    NotifierString := 'Cannot resolve host address'
! !

!HostAddressLookupError methodsFor:'accessing'!

nameToLookup
    request notNil ifTrue:[
        ^ request arguments first.
    ].
    ^ nil.
! !

!HostAddressLookupError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/HostAddressLookupError.st,v 1.4 2013-08-09 14:22:29 cg Exp $'
! !


HostAddressLookupError initialize!
