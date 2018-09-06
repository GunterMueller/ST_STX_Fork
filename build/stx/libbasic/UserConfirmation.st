"
 COPYRIGHT (c) 2007 by eXept Software AG
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

Notification subclass:#UserConfirmation
	instanceVariableNames:'canCancel defaultAnswerInDialog defaultAnswer'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Notifications'
!

!UserConfirmation class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
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
    This confirmation query is used when a user confirmation is required
    somewhere within a model's operation (i.e. in non-GUI code).
    Instead of directly asking via Dialog confirm... messages,
    this should be raised.
    Its default behavior is the same as the above dialog.
    However, the query can be caught and answered by an exceoptn (a query-) handler,
    to suppress these GUI interactions in situations, where they are not wanted.

    This is a much better approach to the alternatives:
	passing additional 'doConfirm' arguments down from the high level caller
	keeping the doConfirm settings in a passed down flag object
	keeping the flag in a global (very bad)
	keeping it in a class var (almost as bad)

    Notice: that's one of the nice consequences of proceedable exceptions.

    [authors:]
	Stefan Vogel
	Claus Gittinger

    [see also:]
	Query Notification Exception
"
! !

!UserConfirmation methodsFor:'accessing'!

aspect
    "the aspect the user is asked. Set this to a symbol.
     It can be used by a exception handler"

    ^ parameter
!

aspect:aSymbol
    "the aspect the user is asked. Set this to a symbol.
     It can be used by a exception handler"

    parameter := aSymbol
!

canCancel
    "answer true, if the user is allowed to press the cancel button
     in a confirmation dialog"

    ^ canCancel ? false
!

canCancel:something
    canCancel := something.
!

defaultAnswer
    "used to pass information from the raiser to the GUI dialog.
     Specifies, which answer of the three (yes/no/cancel) should be the return-key-default.
     If not specified, the cancel-key will be the default"

    ^ defaultAnswer
!

defaultAnswer:aBooleanOrNil
    "used to pass information from the raiser to the GUI dialog.
     Specifies, which answer of the three (yes/no/cancel) should be the return-key-default.
     If not specified, the cancel-key will be the default"

    defaultAnswer := aBooleanOrNil
! !

!UserConfirmation methodsFor:'default actions'!

defaultAction
    "Default action for confirmations: open a info box with description.
     If no GUI present, assume that the user pressed 'yes'"

    |text retVal retValText|

    text := self description.

    self hasDialog ifTrue:[
	self canCancel ifTrue:[
	    ^ Dialog confirmWithCancel:text default:defaultAnswer
	] ifFalse:[
	    ^ Dialog confirm:text default:defaultAnswer
	].
    ].

    "
     on systems without GUI, simply show
     the message on the Transcript and assume, that he would have typed 'yes' (or the defaultAnswer).
    "
    retVal := defaultAnswer notNil
		ifTrue:[ defaultAnswer ]
		ifFalse:[
		    self canCancel
			ifTrue:[ nil ]
			ifFalse:[ true ]].

    retValText := retVal isNil
		ifTrue:[ 'cancel' ]
		ifFalse:[
		    retVal
			ifTrue:[ 'yes' ]
			ifFalse:[ 'no' ]].

    Transcript
	show:('User confirmation requested (assuming %1): ' bindWith:retValText);
	showCR:text.
    ^ retVal

    "
      UserConfirmation raiseRequestErrorString:'Please click yes or no!!'
    "
! !

!UserConfirmation methodsFor:'queries'!

askingContext
    "return the context which did the confirm-request"

    |con|

    con := self suspendedContext.
    [
        (con selector startsWith:'confirm')
        and:[ con method mclass == Object ]
    ] whileTrue:[
        con := con sender.
    ].
    ^con
! !

!UserConfirmation class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

