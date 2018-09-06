"
 COPYRIGHT (c) 1999 by eXept Software AG
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

Warning subclass:#ProceedError
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Kernel-Exceptions-Errors'
!

!ProceedError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    ProceedError is raised to indicate that a handler tried to
    proceed an exception marked as nonproceedable.

    The parameter is the exception which tried to proceed.

    NOTE: In the past ST/X didn't distinguish between proceedable
          and non-proceedable exceptions. To make transistion easier,
          this exception is a warning for now. In a future release of
          ST/X, this exception will be changed to be an error 
          (child of SignalError).
          Please fix your code.
"

! !


!ProceedError class methodsFor:'initialization'!

initialize

    NotifierString := 'handler tried to proceed from nonproceedable exception'.

    "
     self initialize
    "


! !


!ProceedError methodsFor:'default actions'!

defaultAction
    "make proceeding from a non-proceedable raise a warning for now.
     This will change in future revisions"

    ('WARNING: signal <', parameter creator printString, '> has been raised nonproceedable') errorPrintCR.
    ('         by: ', parameter suspendedContext printString) errorPrintCR.
    ('           : ', parameter suspendedContext sender printString) errorPrintCR.
    ('           : ', parameter suspendedContext sender sender printString) errorPrintCR.
    ('         ', suspendedContext printString , ' tries to proceed.') errorPrintCR.
    ('         in: ', thisContext sender printString) errorPrintCR.
    ('           : ', thisContext sender sender printString) errorPrintCR.
    ('           : ', thisContext sender sender sender printString) errorPrintCR.
    ('         This may be an error in future ST/X versions.') errorPrintCR.

    self proceedWith:nil.

    "
      Object errorSignal handle:[:ex|
         ex proceedWith:nil
      ] do:[
         Object errorSignal raise
      ].

      Object errorSignal handle:[:ex|
         ex proceed
      ] do:[
         Object errorSignal raise
      ].
   "

    "Modified: / 13-11-2016 / 10:52:37 / cg"
! !


!ProceedError class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: ProceedError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


ProceedError initialize!
