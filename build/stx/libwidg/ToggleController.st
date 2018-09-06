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

ButtonController subclass:#ToggleController
	instanceVariableNames:'action'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Controllers'
!

!ToggleController class methodsFor:'documentation'!

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
    ToggleControllers redefine some of ButtonControllers behavior;
    user interaction: they always triggerOnDown, and ignore buttonrelease.
    Finally, every buttonPress leads to a toggle action.

    ToggleController adds another actionBlock, since it inherits press-
    and releaseActions, while we want one actionBlock to be used for both
    on- and off. The actionBlock (if any) is evaluated with the current
    toggles state if it expects an argument, or without argument if its a no-arg
    block.

    Other than that, all model relations are inherited - i.e. if the view has a model,
    that one gets change-messages and the toggle updates on aspect changes.

    [author:]
        Claus Gittinger
"
! !

!ToggleController methodsFor:'accessing'!

action:aBlock
    "set the action to be performed. This is called
     with the toggles state as argument."

    action := aBlock
! !

!ToggleController methodsFor:'events'!

keyPress:key x:x y:y
    "toggle on space"

    <resource: #keyboard (#Space)>

    (key == Character space) ifTrue:[
        enableChannel value ifTrue:[
            self toggle.
            ^ self
        ].
    ].
    super keyPress:key x:x y:y
!

performAction
    "the toggle changed its state; first tell the model and
     channels, then evaluate any (optional) press/release actions,
     finally evaluate my real action, the toggle action.
     Individual press/release actions are usually nil for toggles."

    super performAction.

    action notNil ifTrue:[
        active := true.
        action valueWithOptionalArgument:pressed.
        active := false.
    ].

    "Modified: 24.1.1997 / 15:42:14 / cg"
! !

!ToggleController methodsFor:'initialization'!

initialize
    super initialize.
    self beToggle
! !

!ToggleController class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg/ToggleController.st,v 1.15 2013-02-27 11:23:05 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg/ToggleController.st,v 1.15 2013-02-27 11:23:05 stefan Exp $'
! !

