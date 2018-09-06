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

"{ Package: 'stx:goodies/communication' }"

Error subclass:#FTPServerException
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-FTP'
!

!FTPServerException class methodsFor:'documentation'!

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

!FTPServerException class methodsFor:'default exceptions'!

loginIncorrect
    self raiseErrorString:'530 Login incorrect'
!

noDataConnection
    self raiseErrorString:'426 Connection closed'
!

noWorkingDirectory
    "only possible if user is not logged in
    "
    self raiseErrorString:'530 Please login with USER and PASS'
!

permissionDenied
    self permissionDenied:nil
!

permissionDenied:aPathOrNil

    aPathOrNil isNil ifTrue:[
	self raiseErrorString:'550 Permission denied'.
    ] ifFalse:[
	self raiseErrorString:('550 "%1" Permission denied' bindWith:(aPathOrNil asString)).
    ]
!

wrongNumberOfArguments
    self raiseErrorString:'501 wrong numbers of arguments.'
! !

!FTPServerException class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/FTPServerException.st,v 1.2 2005-12-28 12:33:28 cg Exp $'
! !
