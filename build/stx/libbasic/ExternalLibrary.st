"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ExternalLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

ExternalLibrary class instanceVariableNames:'default'

"
 No other class instance variables are inherited by this class.
"
!

!ExternalLibrary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    This is only a hook for compatibility (to be able to fileIn squeak libraries)
"
! !

!ExternalLibrary methodsFor:'error reporting'!

externalCallFailed
    "{ Pragma: +optSpace }"

    "report an error that some external libraray call failed.
     The error is reported by raising the PrimitiveFailure exception."

    <resource: #skipInDebuggersWalkBack>

    |sender|

    sender := thisContext sender.

    ^ PrimitiveFailure raiseRequestWith:(Message selector:sender selector arguments:sender args)
                       in:sender.
! !

!ExternalLibrary class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/ExternalLibrary.st,v 1.4 2015-02-09 09:43:30 cg Exp $'
! !

