"{ Encoding: utf8 }"

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

DomainError subclass:#ZeroDivide
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!ZeroDivide class methodsFor:'documentation'!

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
    Raised when a division by zero is attempted.
"
!

examples
"
    the following leads into a debugger:
                                                                    [exBegin]
        |divisor|

        divisor := 0.
        Transcript showCR: ( 5 / divisor ).
                                                                    [exEnd]


    the following does NOT lead into a debugger:
                                                                    [exBegin]
        |divisor|

        divisor := 0.
        [
            Transcript showCR: ( 5 / divisor ).
        ] on:ZeroDivide do:[
            Transcript flash.
        ]
                                                                    [exEnd]
"
! !


!ZeroDivide class methodsFor:'initialization'!

initialize
    NotifierString := 'division by zero'.
! !


!ZeroDivide methodsFor:'accessing'!

defaultResumeValue
    "return infinity here, if ever proceeded"

    ^ parameter receiver class infinity

    "
     |a b|

     a := 5.
     b := 0.
     ZeroDivide handle:[:ex |
        Transcript showCR:('division by zero - dividend was: ' , ex dividend printString).
        ex proceed
     ] do:[
        a / b
     ]            
    "

    "
     |a b|

     a := 5.0.
     b := 0.0.
     ZeroDivide handle:[:ex |
        Transcript showCR:('division by zero - dividend was: ' , ex dividend printString).
        ex proceed
     ] do:[
        a / b
     ]            
    "
!

dividend
    "Return the number that was being divided by zero."

    ^ parameter receiver

    "
     |a b|

     a := 5.
     b := 0.
     Integer divisionByZeroSignal handle:[:ex |
        Transcript showCR:('division by zero - dividend was: ' , ex dividend printString)
     ] do:[
        a // b
     ]
    "
! !


!ZeroDivide class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: ZeroDivide.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


ZeroDivide initialize!
