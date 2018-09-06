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

ProceedableError subclass:#NameLookupError
	instanceVariableNames:'request'
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Sockets'
!

!NameLookupError class methodsFor:'documentation'!

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

!NameLookupError class methodsFor:'initialization'!

initialize

    NotifierString := 'Cannot resolve name'
! !

!NameLookupError methodsFor:'accessing'!

nameToLookup
    "subclasses redefine this"

    ^ ''.
!

request
    ^ request
!

request:something
    request := something.
! !

!NameLookupError methodsFor:'printing'!

description
    |description nameToLookup|

    description := super description.
    nameToLookup := self nameToLookup.
    nameToLookup notEmptyOrNil ifTrue:[
         description := description, ': "', nameToLookup printString, '"'.
    ].
    ^ description
! !

!NameLookupError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/NameLookupError.st,v 1.7 2014-11-24 18:12:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/NameLookupError.st,v 1.7 2014-11-24 18:12:02 cg Exp $'
! !


NameLookupError initialize!
