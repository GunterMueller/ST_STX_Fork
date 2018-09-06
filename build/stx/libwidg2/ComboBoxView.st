"
 COPYRIGHT (c) 1996 by eXept Software AG / Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

ComboView subclass:#ComboBoxView
	instanceVariableNames:'menuSelectAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!ComboBoxView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG / Claus Gittinger
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
    A ComboBoxView combines an inputField with a drop down list of default inputs;
    choosing any from the pulled list presets the string in the field.

    In contrast to a PopUpList or ComboListView, the string can still be edited -
    the list is actually only a set of values for the convenience of the user.

    Not yet finished - it may need more protocol.

    [author:]
        Claus Gittinger

    [see also:]
        ComboView
        PopUpList SelectionInListView
        ComboListView ExtendedComboBox
        PullDownMenu Label EntryField
"
!

examples
"
  non MVC operation:
                                                                        [exBegin]
     |top b|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     b := ComboBoxView in:top.
     b origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     b bottomInset:(b preferredExtent y negated).

     b list:#('hello' 'world' 'this' 'is' 'st/x').
     top open.
                                                                        [exEnd]



  with action:
                                                                        [exBegin]
     |top b|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     b := ComboBoxView in:top.
     b origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     b bottomInset:(b preferredExtent y negated).

     b list:#('hello' 'world' 'this' 'is' 'st/x').
     b action:[:entry | Transcript showCR:entry].
     top open.
                                                                        [exEnd]



  model operation:
                                                                        [exBegin]
     |model top b|

     model := 'foo' asValue.

     top := StandardSystemView new.
     top extent:(300 @ 200).

     b := ComboBoxView in:top.
     b origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     b bottomInset:(b preferredExtent y negated).

     b list:#('hello' 'world' 'this' 'is' 'st/x').
     b model:model.

     top openModal.
     Transcript showCR:('comboBox''s value: ' , model value).
                                                                        [exEnd]


  in a dialog:
                                                                        [exBegin]
     |model1 model2 dialog b|

     model1 := 'foo' asValue.
     model2 := 'bar' asValue.

     dialog := Dialog new.
     (dialog addTextLabel:'ComboBox example:') adjust:#left.
     dialog addVerticalSpace.

     (b := dialog addComboBoxOn:model1 tabable:true).
     b list:#('fee' 'foe' 'foo').
     dialog addVerticalSpace.

     (b := dialog addComboBoxOn:model2 tabable:true).
     b list:#('bar' 'baz' 'baloo').
     dialog addVerticalSpace.

     dialog addOkButton.

     dialog open.

     Transcript showCR:('1st comboBox''s value: ' , model1 value).
     Transcript showCR:('2nd comboBox''s value: ' , model2 value).
                                                                        [exEnd]
"
! !

!ComboBoxView class methodsFor:'defaults'!

defaultFont
    ^ EditField defaultFont.
    "/ ^ SelectionInListView defaultFont.
! !

!ComboBoxView methodsFor:'accessing-components'!

editor
    "return the inputField component"

    ^ field

    "Created: 9.2.1996 / 20:18:03 / cg"
    "Modified: 28.2.1996 / 15:10:50 / cg"
!

menuSelectAction:aBlock
    menuSelectAction := aBlock

    "Created: / 15-10-2006 / 15:10:25 / cg"
! !

!ComboBoxView methodsFor:'accessing-mvc'!

model
    ^ field model

    "Created: 9.2.1996 / 00:50:18 / cg"
    "Modified: 28.2.1996 / 15:10:59 / cg"
!

model:aModel
    super model:aModel.
    field model:aModel.

    "Created: 9.2.1996 / 00:50:12 / cg"
    "Modified: 28.2.1996 / 15:11:03 / cg"
! !

!ComboBoxView methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == field model ifTrue:[
        action notNil ifTrue:[
           action value:(changedObject value)
        ].
        ^ self.
    ].
    super update:something with:aParameter from:changedObject
! !

!ComboBoxView methodsFor:'event handling'!

hasKeyboardFocus:aBoolean
    super hasKeyboardFocus:aBoolean.
    field hasKeyboardFocus:aBoolean
!

showFocus:explicit
    super showFocus:explicit.
    field showCursor.

!

showNoFocus:explicit
    super showNoFocus:explicit.
    field hideCursor.

! !

!ComboBoxView methodsFor:'initialization'!

editFieldClass
    ^ EditField
!

initializeField
    |m|

    field := self editFieldClass in:self.
    field borderWidth:0.
    field model:(m := ValueHolder newString).
    m addDependent:self.
    field acceptOnLostFocus:true.
    field acceptOnLeave:true.
    field 
        leaveAction:[:key | 
            self fieldLeft.
            field handleFocusKey:key.
        ].

    "
     all of my input goes to the enterfield
    "
    self delegate:(KeyboardForwarder toView:field).
    field delegate:self.    "delegate mouseWheel events to myself"
    field font:self font.

    menuSelectAction := [:menuValue | field contents:menuValue].

    "
     |b|

     b := ComboBoxView new.
     b list:#('hello' 'world' 'this' 'is' 'st/x').
     b open
    "

    "Created: / 28-02-1996 / 15:07:51 / cg"
    "Modified: / 06-03-2007 / 20:19:32 / cg"
! !

!ComboBoxView methodsFor:'private'!

setFieldsFont:aFont
    "ignored - the inputFields font remains unchanged"
! !

!ComboBoxView methodsFor:'queries'!

specClass
    "XXX no longer needed (inherited default works here)"

    self class == ComboBoxView ifTrue:[
        ^ ComboBoxSpec
    ].
    ^ super specClass

    "Modified: / 31.10.1997 / 19:49:39 / cg"
! !

!ComboBoxView methodsFor:'user interaction'!

fieldLeft
    "the edit field was left (via cursor keys or focus change)"

    field acceptOnLeave ifTrue:[
        field accept.
        action notNil ifTrue:[
            action value:(field contents)
        ].

    ].

    "Created: / 26-02-1997 / 19:42:30 / cg"
    "Modified: / 15-10-2006 / 15:20:14 / cg"
!

select:index
    "a menu item (index) was selected"

    |what|

    pullDownButton turnOff.

    what := list at:index.
    currentIndex := index.

    menuSelectAction value:what.
    field accept.

    action notNil ifTrue:[
        action value:what
    ].

    "Created: / 28-02-1997 / 14:01:53 / cg"
    "Modified: / 15-10-2006 / 15:19:53 / cg"
! !

!ComboBoxView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/ComboBoxView.st,v 1.35 2014-07-03 11:46:02 cg Exp $'
! !

