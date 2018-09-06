"
 COPYRIGHT (c) 2013 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

CheckBox subclass:#TriggerBox
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!TriggerBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by Claus Gittinger
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
    A TriggerBox looks similar to a CheckBox (it contains a button and a label),
    but does not show a check-icon.
    Instead, a trigger button (unlabelled) performs a momentary action when pressed.
"
!

examples
"
  no-op TriggerBox without a label:
                                                                        [exBegin]
     |b|

     b := TriggerBox new.
     b open
                                                                        [exEnd]


  no-op TriggerBox:
                                                                        [exBegin]
     |b|

     b := TriggerBox new.
     b label:'foo'.
     b open
                                                                        [exEnd]


  combined instance creation & label setup:
                                                                        [exBegin]
     |b|

     b := TriggerBox label:'foo'.
     b open
                                                                        [exEnd]


  no-op trigger, disabled:
                                                                        [exBegin]
     |b|

     b := TriggerBox label:'foo'.
     b disable.
     b open
                                                                        [exEnd]


  using a trigger channel instead of a callback:
                                                                        [exBegin]
     |b holder|

     holder := TriggerValue new.
     holder onChangeEvaluate:[ Transcript showCR:'changed'].
     b := TriggerBox label:'foo'.
     b triggerChannel:holder.
     b open
                                                                        [exEnd]


  changing colors 
                                                                        [exBegin]
     |panel b|

     panel := VerticalPanelView new.

     b := TriggerBox label:'foo' in:panel.

     b := TriggerBox label:'bar' in:panel.
     b labelView foregroundColor:Color red.

     b := TriggerBox label:'baz' in:panel.
     b toggleView activeForegroundColor:Color blue.

     panel open
                                                                        [exEnd]


  using action-blocks:
                                                                        [exBegin]
     |b|

     b := TriggerBox label:'check'.
     b action:[:value | Transcript show:'trigger called: '].
     b open.
                                                                        [exEnd]




  with an enableChannel
                                                                        [exBegin]
     |b enaToggle enaHolder|

     enaHolder := true asValue.

     enaToggle := Toggle label:'enable'.
     enaToggle model:enaHolder.
     enaToggle open.

     b := TriggerBox label:'check'.
     b action:[:value | Transcript showCR:'triggered'].
     b enableChannel:enaHolder.
     b open.
                                                                        [exEnd]
"
! !

!TriggerBox methodsFor:'accessing - model'!

triggerChannel:aValueHolder
    toggleView controller pressChannel:aValueHolder.
! !

!TriggerBox methodsFor:'initialization & release'!

defaultCheckToggleClass
    ^ Toggle "/ Button
!

defaultControllerClass
    ^ ButtonController
!

initialize
    super initialize.
    toggleView extent:16@16.

    toggleView activeLogo:nil.
    toggleView passiveLogo:nil.
    toggleView activeLevel:-2.
    toggleView passiveLevel:2.
    toggleView extent:10@10.
    toggleView sizeFixed:true.

    toggleView controller:(ButtonController new).
! !

!TriggerBox class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/TriggerBox.st,v 1.2 2013-09-19 11:47:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg2/TriggerBox.st,v 1.2 2013-09-19 11:47:48 cg Exp $'
! !

