"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

Controller subclass:#ListViewController
	 instanceVariableNames:''
	 classVariableNames:''
	 poolDictionaries:''
	 category:'Interface-Support'
!

!ListViewController class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

version
    ^ '$Header: /cvs/stx/stx/libwidg/ListViewController.st,v 1.2 1995-11-11 16:21:22 cg Exp $'
!

documentation
"
    a very simple controller: only handles some keys to pageup/down
    the view.
"
! !

!ListViewController methodsFor:'event processing'!

keyPress:key x:x y:y
    "a key was pressed - handle page-keys here"

    (key == #Prior)    ifTrue: [^ view pageUp].
    (key == #Next)     ifTrue: [^ view pageDown].

    (key == #Ctrlb) ifTrue:[^ view pageUp].
    (key == #Ctrlf) ifTrue:[^ view pageDown].
    (key == #Ctrld) ifTrue:[^ view halfPageDown].
    (key == #Ctrlu) ifTrue:[^ view halfPageUp].

    (key == #ScrollUp) ifTrue:[^ view scrollUp].
    (key == #ScrollDown) ifTrue:[^ view scrollDown].

    super keyPress:key x:x y:y
! !

