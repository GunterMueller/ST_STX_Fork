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

UserNotification subclass:#Warning
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions'
!

!Warning class methodsFor:'documentation'!

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
    Warning is the superclass of all warning signals in the system.
    The default beavior for an unhandled Warning is to display a warn
    box with the error decription. If no display is available, the error 
    description is written to the Transcript.

    [author:]
        Stefan Vogel

    [see also:]
        Signal
"
!

examples
"
  show a warning:
                                                            [exBegin]
    Transcript showCR:'1 - now raising'.
    Warning raiseRequest.
    Transcript showCR:'2 - after the raise'.
                                                            [exEnd]

  passing an errorString:
                                                            [exBegin]
    Warning raiseRequestErrorString:'hello world'
                                                            [exEnd]

  provide a handler for warnings:
                                                            [exBegin]
    Warning handle:[:ex |
        Transcript showCR:'WARNING: ' , ex description
    ] do:[
        '...'.
        Warning raiseRequest.
        '...'.
    ].

    Warning handle:[:ex |
        Transcript showCR:'WARNING: ' , ex description
    ] do:[
        '...'.
        Warning raiseRequestErrorString:'hello world'.
        '...'.
    ]
                                                            [exEnd]

  ignore warnings during some evaluation:
                                                            [exBegin]
    Warning ignoreIn:[
        '...'.
        Warning raiseRequest.
        '...'.
    ]
                                                            [exEnd]

  defer a warning to some later time:
                                                            [exBegin]
    Warning deferAfter:[
        Transcript showCR:'1 - no warning here ...'.
        Warning raiseRequestErrorString:'this warning is deferred'.
        Transcript showCR:'2 - but in a second...'.
    ].
    Transcript showCR:'3 - after warning-protected block'.
                                                            [exEnd]
"
! !

!Warning class methodsFor:'initialization'!

initialize

    NotifierString := 'Warning:'.

    "
     self initialize
    "

    "Created: / 23.7.1999 / 15:34:27 / stefan"
! !


!Warning methodsFor:'default actions'!

defaultAction
    "Default action for warnings: open a warn box with description"

    self showWarnDialog.
    self proceed.

    "
      Warning raiseRequestErrorString:' abc'
    "

    "Modified: / 3.8.1999 / 14:06:41 / stefan"
!

showWarnDialog
    "open a warn box with description"

    |text|

    text := self description.

    self hasDialog ifTrue:[
        Dialog warn:text.
    ] ifFalse:[
        "
         on systems without GUI, simply show
         the message on the Transcript.
        "
        Transcript show:'Warning: '; showCR:text.
    ].

    "
      Warning raiseRequestErrorString:' abc'
    "

    "Modified: / 3.8.1999 / 14:06:41 / stefan"
! !

!Warning class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Warning initialize!
