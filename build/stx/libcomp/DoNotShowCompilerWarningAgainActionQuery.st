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
"{ Package: 'stx:libcomp' }"

Query subclass:#DoNotShowCompilerWarningAgainActionQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!DoNotShowCompilerWarningAgainActionQuery class methodsFor:'documentation'!

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
    Used to ask if a warning should be shown again.
    When the compiler makes an error notification, it raises this query to
    ask for an actionblock. If the query is not answered, the 'no not show again' dialog
    is not shown.
    If it is answered, the returned value must be the block.
    The dialog is shown, and if the user confirms (do not show again), the block is called.
    The block is typically provided from the warning generation code, which sets/clears
    some flag in the user preferences.
"
! !

!DoNotShowCompilerWarningAgainActionQuery class methodsFor:'queries'!

actionQuery
    ^ self query
! !

!DoNotShowCompilerWarningAgainActionQuery class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/DoNotShowCompilerWarningAgainActionQuery.st,v 1.3 2012-02-28 17:42:08 cg Exp $'
! !
