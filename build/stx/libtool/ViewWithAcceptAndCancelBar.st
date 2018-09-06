"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

SimpleView subclass:#ViewWithAcceptAndCancelBar
	instanceVariableNames:'slaveView bar reallyModifiedHolder acceptAction cancelAction
		compareAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Basic'
!

SimpleView subclass:#AcceptAndCancelBar
	instanceVariableNames:'acceptButton cancelButton compareButton'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ViewWithAcceptAndCancelBar
!

Button subclass:#ButtonWithHelpText
	instanceVariableNames:'helpText'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ViewWithAcceptAndCancelBar::AcceptAndCancelBar
!

!ViewWithAcceptAndCancelBar class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    experimental - self like accept/cancel bar in the browsers
    code view.
    Enable with:
         UserPreferences current showAcceptCancelBarInBrowser:true
"
! !

!ViewWithAcceptAndCancelBar methodsFor:'accessing'!

acceptAction:something
    "define the action to be performed when the green accept button is pressed"

    acceptAction := something.

    "Modified (comment): / 29-11-2011 / 12:59:18 / cg"
!

cancelAction:something
    "define the action to be performed when the red cancel button is pressed"

    cancelAction := something.

    "Modified (comment): / 29-11-2011 / 12:59:24 / cg"
!

compareAction:aBlock
    "define the action to be performed when the yellow compare button is pressed"

    compareAction := aBlock.

    "Modified (comment): / 29-11-2011 / 12:59:01 / cg"
!

reallyModifiedHolder:aValueHolder
    "set the holder which keeps track of the real modified state;
     the modified state of the view is set with every user-input,
     but cleared by the master (in order to trigger future modified events).
     With every modified change, the state of the reallyModified is updated"

    reallyModifiedHolder notNil ifTrue:[
        reallyModifiedHolder removeDependent:self.
    ].
    reallyModifiedHolder := aValueHolder.
    reallyModifiedHolder notNil ifTrue:[
        reallyModifiedHolder addDependent:self.
    ]

    "Modified: / 29-11-2011 / 13:01:02 / cg"
!

scrolledView
    "for protocol compatibility"

    ^ slaveView scrolledView
! !

!ViewWithAcceptAndCancelBar methodsFor:'action'!

accept
    acceptAction value
!

cancel
    cancelAction notNil ifTrue:[
        cancelAction value
    ]
!

compare
    compareAction notNil ifTrue:[
        compareAction value
    ]
! !

!ViewWithAcceptAndCancelBar methodsFor:'change & update'!

hideBar
    bar unmap.
    bar hiddenOnRealize:true.
    slaveView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
!

showBar
    slaveView origin:(20 @ 0.0) corner:(1.0 @ 1.0).
    bar hiddenOnRealize:false.
    bar realize.
!

update:something with:aParameter from:changedObject
    |app|

    slaveView notNil ifTrue:[
        (changedObject == reallyModifiedHolder 
        or:[ changedObject == slaveView modifiedChannel ]) ifTrue:[
            (app := self application) notNil ifTrue:[
                "/ not sure if we really need to send it through the application
                app enqueueMessage:#updateBarVisibility for:self arguments:#().
            ] ifFalse:[
                self sensor pushUserEvent:#updateBarVisibility for:self withArguments:#()
            ]
        ].
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 29-11-2011 / 12:57:55 / cg"
!

updateBarVisibility
    |modified|

    modified := reallyModifiedHolder notNil 
                ifTrue:[ reallyModifiedHolder value ]
                ifFalse:[ slaveView modifiedChannel value ].

    modified ifTrue:[
        self showBar
    ] ifFalse:[
        self hideBar
    ].

    "Modified (format): / 29-11-2011 / 14:05:04 / cg"
! !

!ViewWithAcceptAndCancelBar methodsFor:'initialization'!

initialize
    super initialize.

    bar := AcceptAndCancelBar in:self.
    bar origin:(0.0 @ 0.0) corner:(20 @ 1.0).
    bar hiddenOnRealize:true.

    bar acceptButton action:[ self accept ].
    bar cancelButton action:[ self cancel ].
    bar compareButton action:[ self compare ].

    acceptAction := [ slaveView notNil ifTrue:[ slaveView accept ] ].
    cancelAction := [  ].

    "
     self new open
    "
!

setSlaveView:aView
    slaveView := aView.
    aView origin:(0.0@0.0) corner:(1.0@1.0).
    aView modifiedChannel addDependent:self.

    "
     |v|

     v := self new.
     v slaveView:CodeView new.
     v open
    "
!

slaveView:aView
    self add:aView.
    self setSlaveView:aView.

    "
     |v|

     v := self new.
     v slaveView:CodeView new.
     v open
    "
! !

!ViewWithAcceptAndCancelBar::AcceptAndCancelBar methodsFor:'accessing'!

acceptButton
    ^ acceptButton
!

cancelButton
    ^ cancelButton
!

compareButton
    ^ compareButton
! !

!ViewWithAcceptAndCancelBar::AcceptAndCancelBar methodsFor:'help'!

flyByHelpTextAt:srcPoint
    "return the helpText for aPoint (i.e. when mouse-pointer is moved over an item)."

    (acceptButton bounds containsPoint:srcPoint) ifTrue:[
        ^ resources string:'Accept'
    ].
    (cancelButton bounds containsPoint:srcPoint) ifTrue:[
        ^ resources string:'Cancel'
    ].
    (compareButton bounds containsPoint:srcPoint) ifTrue:[
        ^ resources string:'Compare against Original'
    ].
    ^ nil

    "Modified: / 26-09-2012 / 14:26:14 / cg"
! !

!ViewWithAcceptAndCancelBar::AcceptAndCancelBar methodsFor:'initialization'!

initialize
    |acceptColor cancelColor compareColor order|

    super initialize.

    UserPreferences current useColorsForColorBlindness ifTrue:[
        acceptColor := Color blue.
    ] ifFalse:[
        acceptColor := Color green.
    ].
    cancelColor := Color red.
    compareColor := Color yellow.

    order := UserPreferences current acceptCancelBarOrder.
    
    acceptButton := ButtonWithHelpText new.
    acceptButton origin:0.0 @ 0.0 corner:1.0@0.7.
    acceptButton backgroundColor:acceptColor.
    acceptButton enteredBackgroundColor:acceptColor lightened.
    acceptButton activeBackgroundColor:acceptColor darkened.
    acceptButton flyByHelpText:(resources string:'Accept').
    self add:acceptButton.

    cancelButton := ButtonWithHelpText new.
    order == #acceptCompareCancel ifTrue:[
        cancelButton origin:0.0 @ 0.9 corner:1.0@1.0.
    ] ifFalse:[
        cancelButton origin:0.0 @ 0.7 corner:1.0@0.9.
    ].
    cancelButton backgroundColor:cancelColor.
    cancelButton enteredBackgroundColor:cancelColor lightened.
    cancelButton activeBackgroundColor:cancelColor darkened.
    cancelButton flyByHelpText:(resources string:'Cancel').
    self add:cancelButton.

    compareButton := ButtonWithHelpText new.
    order == #acceptCompareCancel ifTrue:[
        compareButton origin:0.0 @ 0.7 corner:1.0@0.9.
    ] ifFalse:[
        compareButton origin:0.0 @ 0.9 corner:1.0@1.0.
    ].
    compareButton backgroundColor:compareColor.
    compareButton enteredBackgroundColor:compareColor lightened lightened.
    compareButton activeBackgroundColor:compareColor darkened.
    compareButton flyByHelpText:(resources string:'Compare against Original').
    compareButton label:'?'.
    self add:compareButton.

    "
     AcceptAndCancelBar new open
    "

    "Modified: / 26-09-2012 / 14:44:18 / cg"
! !

!ViewWithAcceptAndCancelBar::AcceptAndCancelBar::ButtonWithHelpText methodsFor:'accessing'!

flyByHelpText
    ^ helpText
!

flyByHelpText:something
    helpText := something.
! !

!ViewWithAcceptAndCancelBar::AcceptAndCancelBar::ButtonWithHelpText methodsFor:'initialization'!

reinitStyle
    "do nothing, especially keep the background color"
! !

!ViewWithAcceptAndCancelBar class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

