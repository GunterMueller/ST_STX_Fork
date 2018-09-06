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

"{ Package: 'stx:libwidg' }"

ToggleController subclass:#RadioButtonController
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Controllers'
!

!RadioButtonController class methodsFor:'documentation'!

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

documentation
"
    RadioButtonControllers redefine the response to a button-click.
    While toggles (i.e. ToggleControllers) change state with every click,
    radioButtons will only do so for an off-to-on transition.
    They will NEVER turn themselfes off with a click.
    To turn a radioButton off, another button in its buttonGroup must
    be turned on and thereby (via the buttonGroup) turn the first button off.

    You can place both toggles (for 'zero-or-one-on' behavior) or
    radiobuttons (for 'one-on' behavior) into a buttongroup.

    [author:]
        Claus Gittinger
"
! !

!RadioButtonController methodsFor:'initialization & release'!

initialize
    super initialize.
    isToggle := false.
    isRadio := true.
    isTriggerOnDown := true.

    "Created: 15.7.1996 / 13:43:23 / cg"
! !

!RadioButtonController class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg/RadioButtonController.st,v 1.9 2003-05-07 14:56:15 cg Exp $'
! !
