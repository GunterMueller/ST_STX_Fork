"
 COPYRIGHT (c) 1991 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

EnterBox subclass:#EnterBox2
	instanceVariableNames:'okButton2 okAction2'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!EnterBox2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
   Historic note:
        originally, ST/X had separate classes for the various entry methods;
        there were YesNoBox, EnterBox, InfoBox and so on.
        In the meantime, the DialogBox class (and therefore its alias: Dialog)
        is going to duplicate most functionality found in these classes.

        In the future, those existing subclasses' functionality is going to
        be moved fully into Dialog, and the subclasses will be replaced by dummy
        delegators. (They will be kept for backward compatibility, though).

    An EnterBox2 is like an EnterBox but with 2 action buttons.
    This is used (for example) in the search-boxes, where two ok-buttons
    'find-previous' and 'find-next' are needed in addition to the abort button.
    The protocol is like that of EnterBox, the additional buttons label
    can be set with 'okText2:aString' and its action with 'action2:aBlock'.

    [author:]
        Claus Gittinger

    [see also:]
        DialogBox
        EnterBox YesNoBox
        ListSelectionBox FileSelectionBox FileSaveBox
"

    "Modified: 25.4.1996 / 16:47:41 / cg"
! !

!EnterBox2 class methodsFor:'instance creation'!

title:titleString okText1:text1 okText2:text2 abortText:abortText
                  action1:block1 action2:block2
    "create and return a new EnterBox-with-2 buttons
     and define its text, button-labels and actions"

    ^ (super title:titleString
            okText:text1
         abortText:abortText
            action:block1) okText2:text2 action2:block2
! !

!EnterBox2 methodsFor:'accessing'!

action2:aBlock
    "set the action to be performed when user presses the 2nd ok-button;
     aBlock must be nil or a block with one argument "

    okAction2 := aBlock
!

okText2:aString
    "set the text to be displayed in the 2nd ok-button"

    aString ~= okButton2 label ifTrue:[
	okButton2 label:aString.
	okButton2 resize.
	shown ifTrue:[self resize]
    ]
!

okText2:aString action2:aBlock
    "set the text to be displayed in the 2nd ok-button,
     and its action"

    self okText2:aString.
    okAction2 := aBlock
! !

!EnterBox2 methodsFor:'initialization'!

initialize
    super initialize.

    "
     add a second ok-button (a return button)
    "
    okButton2 := Button okButton.
    okButton2 name: 'okButton2'.
    buttonPanel addSubView:okButton2 before:okButton.
    okButton2 model:self; change:#ok2Pressed.

    "
     the old (see superclass) ok-button is no longer a return-button
    "
    okButton isReturnButton:false.

    enterField leaveAction:[:key | self ok2Pressed]

    "Modified: / 29-08-2013 / 12:20:15 / cg"
! !

!EnterBox2 methodsFor:'user interaction'!

keyPress:aKey x:x y:y
    "return-key duplicates ok-function if acceptReturnAsOK is true"

    <resource: #keyboard (#Return)>

    acceptReturnAsOK ifTrue:[
        (aKey == #Return) ifTrue:[^ self ok2Pressed]
    ].
    super keyPress:aKey x:x y:y

    "Modified: 7.3.1996 / 13:16:37 / cg"
!

ok2Pressed
    "user pressed 2nd ok button - evaluate action"

    okButton2 turnOffWithoutRedraw.
    self hideAndEvaluate:okAction2
! !

!EnterBox2 class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

