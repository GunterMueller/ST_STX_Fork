"
 COPYRIGHT (c) 2013 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Notification subclass:#CascadingNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions'
!

!CascadingNotification class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by eXept Software AG
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
    A CascadingNotification behaves much like a regular notification,
    in that if no handler is present, execution proceeds after the raise.
    However, iff a handler is present, all other outer handlers are still called,
    if the handles simply fall through
    I.e. the default behavior of a handler is not to proceed or return, but to reject,
    iff there is another outer handler. 
    For the very outermost handler, the default is to proceed.

    This is used to allow for notifier-hooks to be stacked upon each other.
    For now, the one and only use is the aboutToOpenBox notifier, which can be used
    as a hook to add additional widget components to a standard dialog box.

    [author:]
        Claus Gittinger

    [see also:]
        Exception Query Notification
"
!

examples 
"
  an up-notification from a deeply nested operation to a higher level.
  Notice, that in contrast to a regular Notification, all outer handlers are called:
                                                                        [exBegin]
    |zero|

    zero := 0.
    CascadingNotification handle:[:n |
        Transcript showCR:'h1: ' , n description.
        n proceedWith:1.    
    ] do:[
        CascadingNotification handle:[:n |
            Transcript showCR:'h2: ' , n description.
        ] do:[
            CascadingNotification handle:[:n |
                Transcript showCR:'h3: ' , n description.
            ] do:[
                'nesting'.
                [
                    [
                        Error handle:[:ex |
                            Transcript showCR:'some error: ' , ex errorString.
                            ex proceed
                        ] do:[
                            [
                                |answer|

                                1 // zero.  'an error which is caught in the handler'.
                                answer := CascadingNotification notify:'hello world'.
                                Transcript show:'after notification 1: '; showCR:answer.
                            ] value
                        ]
                    ] value
                ] value.
                Transcript showCR:'after notification 2'.
            ].
            Transcript showCR:'after notification 3'.
        ].
        Transcript showCR:'after notification 4'.
    ].
    Transcript showCR:'after notification 5'.
                                                                        [exEnd]

  however, if any handler proceeds or returns, this is not the case:
                                                                        [exBegin]
    |zero|

    zero := 0.
    CascadingNotification handle:[:n |
        Transcript showCR:'h1: ' , n description.
    ] do:[
        CascadingNotification handle:[:n |
            Transcript showCR:'h2: ' , n description.
            n proceedWith:2.    
        ] do:[
            CascadingNotification handle:[:n |
                Transcript showCR:'h3: ' , n description.
            ] do:[
                'nesting'.
                [
                    [
                        Error handle:[:ex |
                            Transcript showCR:'some error: ' , ex errorString.
                            ex proceed
                        ] do:[
                            [
                                |answer|

                                1 // zero.  'an error which is caught in the handler'.
                                answer := CascadingNotification notify:'hello world'.
                                Transcript show:'after notification 1: '; showCR:answer.
                            ] value
                        ]
                    ] value
                ] value.
                Transcript showCR:'after notification 2'.
            ].
            Transcript showCR:'after notification 3'.
        ].
        Transcript showCR:'after notification 4'.
    ].
    Transcript showCR:'after notification 5'.
                                                                        [exEnd]
  however, if any handler proceeds or returns, this is not the case:
                                                                        [exBegin]
    |zero|

    zero := 0.
    CascadingNotification handle:[:n |
        Transcript showCR:'h1: ' , n description.
    ] do:[
        CascadingNotification handle:[:n |
            Transcript showCR:'h2: ' , n description.
            n return.    
        ] do:[
            CascadingNotification handle:[:n |
                Transcript showCR:'h3: ' , n description.
            ] do:[
                'nesting'.
                [
                    [
                        Error handle:[:ex |
                            Transcript showCR:'some error: ' , ex errorString.
                            ex proceed
                        ] do:[
                            [
                                |answer|

                                1 // zero.  'an error which is caught in the handler'.
                                answer := CascadingNotification notify:'hello world'.
                                Transcript show:'after notification 1: '; showCR:answer.
                            ] value
                        ]
                    ] value
                ] value.
                Transcript showCR:'after notification 2'.
            ].
            Transcript showCR:'after notification 3'.
        ].
        Transcript showCR:'after notification 4'.
    ].
    Transcript showCR:'after notification 5'.
                                                                        [exEnd]
"
! !

!CascadingNotification class methodsFor:'initialization'!

initialize

    NotifierString := 'Notification:'
! !

!CascadingNotification methodsFor:'default actions'!

doCallHandler:aHandlerBlock
    "call the handler proper - if the handler falls through, reject and try more handlers.
     - an extra method is needed to have a raise-marked context around.
       (see implementation of #reject and #proceed)."

    <context: #return>
    <exception: #raise>

    |val|

    aHandlerBlock argumentCount == 0 ifTrue:[
        "0-arg handler or any object - not interested in the exception argument"
        val := aHandlerBlock value
    ] ifFalse:[
        "1-arg handler - pass myself as exception argument"
        val := aHandlerBlock value:self.
    ].

    "handler fall through - this is different here!!"

    self reject
! !

!CascadingNotification class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CascadingNotification.st,v 1.3 2013-08-24 12:24:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/CascadingNotification.st,v 1.3 2013-08-24 12:24:42 cg Exp $'
! !


CascadingNotification initialize!