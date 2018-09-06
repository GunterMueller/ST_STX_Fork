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

NameLookupError subclass:#HostNameLookupError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!HostNameLookupError class methodsFor:'documentation'!

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

!HostNameLookupError class methodsFor:'initialization'!

initialize

    NotifierString := 'Cannot resolve host name'
! !

!HostNameLookupError methodsFor:'accessing'!

nameToLookup
    request notNil ifTrue:[
        ^ request canonicalName.
    ].
    ^ nil.
! !

!HostNameLookupError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/HostNameLookupError.st,v 1.4 2013-08-09 14:22:26 cg Exp $'
! !


HostNameLookupError initialize!
