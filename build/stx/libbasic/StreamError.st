"
 COPYRIGHT (c) 2001 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

ProceedableError subclass:#StreamError
	instanceVariableNames:'errorCode osErrorHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!StreamError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    The parent of all stream errors.
"
! !

!StreamError methodsFor:'accessing'!

errorCategory
    "return the generi OS independent error category.
     return #unknown, if this is not an OS error"

    |holder|

    holder := self osErrorHolder.
    holder isNil ifTrue:[
	^ #unknown
    ].
    ^ holder errorCategory.
!

errorCode
    ^ errorCode
!

errorCode:something
    errorCode := something.
!

osErrorHolder
    "return the error holder describing an OS error.
     return nil, if this is not an OS error"

    (osErrorHolder isNil and:[errorCode isInteger]) ifTrue:[
	osErrorHolder := OperatingSystem errorHolderForNumber:errorCode.
    ].
    ^ osErrorHolder.
!

osErrorHolder:something
    osErrorHolder := something.
! !

!StreamError methodsFor:'printing & storing'!

description
    "lazy initialization - the text is not needed for caught exceptions"

    messageText isNil ifTrue:[
	self initializeMessageText
    ].
    ^ super description
!

initializeMessageText
    "for lazy initialization - the text is not needed for caught exceptions"

    osErrorHolder notNil ifTrue:[
	messageText := (' : ' , osErrorHolder errorString)
    ].
!

messageText
    "lazy initialization - the text is not needed for caught exceptions"

    messageText isNil ifTrue:[
	self initializeMessageText
    ].
    ^ messageText
! !

!StreamError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/StreamError.st,v 1.11 2014-06-10 10:20:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/StreamError.st,v 1.11 2014-06-10 10:20:23 cg Exp $'
! !
