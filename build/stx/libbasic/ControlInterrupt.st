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

"{ NameSpace: Smalltalk }"

GenericException subclass:#ControlInterrupt
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Kernel-Exceptions-Control'
!

!ControlInterrupt class methodsFor:'documentation'!

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
    Parent of all control-related interrupts (halt, breakpoint etc.)

    [author:]
        Claus Gittinger
"
! !


!ControlInterrupt class methodsFor:'initialization'!

initialize
    NotifierString := 'control interrupted'.

    "
     self initialize
    "
! !


!ControlInterrupt class methodsFor:'testing'!

isControlInterrupt
    ^ true

    "Created: / 16.11.2001 / 16:11:11 / cg"
! !


!ControlInterrupt class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: ControlInterrupt.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


ControlInterrupt initialize!
