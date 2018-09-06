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

"{ NameSpace: Smalltalk }"

Error subclass:#OsError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Support'
!

!OsError class methodsFor:'documentation'!

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
! !

!OsError class methodsFor:'initialization'!

initialize
    NotifierString := 'OperatingSystem error'.
! !

!OsError class methodsFor:'queries'!

mayProceed
    ^ true
! !

!OsError methodsFor:'accessing'!

description

    "parameter is an OSErrorHolder, if present"
    parameter class == OSErrorHolder ifTrue:[
        ^ super description , ' (', parameter description, ')'.
    ].
    ^ super description.

    "
      [  
        (OperatingSystem errorHolderForNumber:22)
             parameter:'bla';
             reportError.
      ] on:OsError do:[:ex|
            ex description inspect.
      ].
    "
!

errorCategory

    "parameter is an OSErrorHolder, if present"
    parameter notNil ifTrue:[
        ^ parameter errorCategory.
    ].
    ^ ''.
!

errorString

    "parameter is an OSErrorHolder, if present"
    parameter notNil ifTrue:[
        ^ parameter errorString.
    ].
    ^ ''.
!

errorSymbol

    "parameter is an OSErrorHolder, if present"
    parameter notNil ifTrue:[
        ^ parameter errorSymbol.
    ].
    ^ ''.
! !

!OsError class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: OsError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


OsError initialize!
