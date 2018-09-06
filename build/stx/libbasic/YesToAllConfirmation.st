"
 COPYRIGHT (c) 2004 by eXept Software AG
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

Notification subclass:#YesToAllConfirmation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Notifications'
!

!YesToAllConfirmation class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    used with confirmation dialogs, especially from the filebrowser and compilers
    to up-notify that further such confirmations are not wanted by the user.
"
! !

!YesToAllConfirmation class methodsFor:'queries'!

notify
    "raise a notification; usually will be remembered in a handler for the next
     query to return true"

    ^ self raiseRequestWith:#yesToAll.
! !

!YesToAllConfirmation class methodsFor:'utilities'!

handleConfirmationIn:aBlock
    "evaluate aBlock;
     if inside that block, a query for YesToAll is raised, remember it and
     answer it as required."

    |alreadyAnswered|

    alreadyAnswered := false.
    self handle:[:ex |
        ex parameter == #yesToAll ifTrue:[
            alreadyAnswered := true.
        ].
        ex proceedWith:alreadyAnswered
    ] do:aBlock.

    "
      YesToAllConfirmation
        handleConfirmationIn:[
            1 to:5 do:[:i |
                |confirmed|

                YesToAllConfirmation query ifFalse:[
                    confirmed := OptionBox
                                  request:(i printString)
                                  label:('Ask again and again')
                                  image:(YesNoBox iconBitmap)
                                  buttonLabels:#('Cancel' 'No' 'Yes' 'Yes to All')
                                  values:#(nil false true #yesToAll)
                                  default:false
                                  onCancel:false.
                    confirmed == #yesToAll ifTrue:[
                        YesToAllConfirmation notify
                    ].
                ].
                Transcript showCR:i.
            ].
        ].
    "
! !

!YesToAllConfirmation methodsFor:'defaults'!

defaultResumeValue
    "the default answer, if no one handles the query"

    ^ false
! !

!YesToAllConfirmation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/YesToAllConfirmation.st,v 1.7 2014-12-30 12:40:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/YesToAllConfirmation.st,v 1.7 2014-12-30 12:40:05 cg Exp $'
! !

