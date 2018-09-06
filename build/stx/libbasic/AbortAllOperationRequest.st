"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

ControlRequest subclass:#AbortAllOperationRequest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Control'
!

!AbortAllOperationRequest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    Raised by some dialogs 'Cancel All' button.

    If unhandled, this is equivalent to raising the AbortOperationRequest.
    However, some applications catch this signal when performing an operation
    on multiple objects (such as a fileBrowser, when deleting multiple files).
    In these situations, Abort is typically caught to cancel a single
    operation, while AbortAll is used to cancel the whole action.
"
! !

!AbortAllOperationRequest class methodsFor:'initialization'!

initialize

    NotifierString := 'abort all operations requested'.

    "
     self initialize
    "
! !

!AbortAllOperationRequest class methodsFor:'special handling'!

handleAndAnswerQueryIn:aBlock
    "evaluate aBlock, and return immediately, if the AbortAllRequest is raised.
     Answer any query if AllOperationWanted with true."

    self handle:[:ex |
    ] do:[
        AbortAllOperationWantedQuery 
            answer:true
            do:aBlock
    ].

    "
     AbortAllOperationRequest handleAndAnswerQueryIn:[
        AbortAllOperationWantedQuery query ifTrue:[
            self halt.
            AbortAllOperationRequest raise.
        ].
     ].
    "

    "Created: / 09-02-2011 / 13:58:01 / cg"
! !

!AbortAllOperationRequest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/AbortAllOperationRequest.st,v 1.9 2013-01-24 15:24:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/AbortAllOperationRequest.st,v 1.9 2013-01-24 15:24:00 cg Exp $'
! !


AbortAllOperationRequest initialize!
