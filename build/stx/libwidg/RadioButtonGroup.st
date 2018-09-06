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

ValueHolder subclass:#RadioButtonGroup
	instanceVariableNames:'numberOfValues'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!RadioButtonGroup class methodsFor:'documentation'!

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
    RadioButtonGroups control the interaction between RadioButtons
    turning off other button(s) when one of the group is pressed.
    To group some buttons (and have one-on behavior) use:

        |g|

        g := RadioButtonGroup new.
        ...
        b1 := RadioButton label:....
        g add:b1
        ...
        b2 := RadioButton label:....
        g add:b2
        ...

    A radioButtonGroup is itself usable as a model, holding the index of
    the selected button. It can be used as a selectionIndexHolder of a
    SelectionInList instance.

    [author:]
        Claus Gittinger

    [see also:]
        RadioButton Toggle CheckBox CheckToggle Button
        Model ValueHolder SelectionInList
"

    "Modified: 1.3.1997 / 14:11:57 / cg"
!

examples 
"
    using Toggles for 'at most one-on behavior':
                                                                        [exBegin]
        |top panel b group|

        top := StandardSystemView label:'toggles'.
        panel := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
        group := RadioButtonGroup new.
        b := Toggle label:'one' in:panel.
        group add:b.
        b := Toggle label:'two' in:panel.
        group add:b.
        b := Toggle label:'three' in:panel.
        group add:b.
        top extent:(panel preferredExtent).
        top open.
                                                                        [exEnd]


    using RadioButtons for 'one-on behavior':
                                                                        [exBegin]
        |top panel b group|

        top := StandardSystemView label:'radio'.
        panel := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
        group := RadioButtonGroup new.
        b := RadioButton label:'one' in:panel.
        group add:b.
        b := RadioButton label:'two' in:panel.
        group add:b.
        b := RadioButton label:'three' in:panel.
        group add:b.
        top extent:(panel preferredExtent).
        top open.
                                                                        [exEnd]


    same, with initial selection:
                                                                        [exBegin]
        |top panel b group|

        top := StandardSystemView label:'radio'.
        panel := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
        group := RadioButtonGroup new.
        b := RadioButton label:'one' in:panel.
        group add:b.
        b := RadioButton label:'two' in:panel.
        group add:b.
        b := RadioButton label:'three' in:panel.
        group add:b.
        top extent:(panel preferredExtent).

        group value:1.
        top open.
                                                                        [exEnd]


    using Buttons for 'none-on behavior'; 
    buttons do not show the boolean state (they only fire);
    however, the groups value remembers the last pressed button:
                                                                        [exBegin]
        |top panel b group|

        top := StandardSystemView new.
        panel := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
        group := RadioButtonGroup new.
        b := Button label:'one' in:panel.
        group add:b.
        b := Button label:'two' in:panel.
        group add:b.
        b := Button label:'three' in:panel.
        group add:b.
        top extent:(panel preferredExtent).
        top open.

        group inspect
                                                                        [exEnd]


    using checkBoxes (these have a label included).
    notice, that we change their behavior to radioButton behavior:
                                                                        [exBegin]
        |top panel b group|

        top := StandardSystemView new.
        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
        panel horizontalLayout:#left.
        group := RadioButtonGroup new.
        b := CheckBox label:'one' in:panel.
        b controller beRadioButton.
        group add:b.
        b := CheckBox label:'two' in:panel.
        b controller beRadioButton.
        group add:b.
        b := CheckBox label:'three' in:panel.
        b controller beRadioButton.
        group add:b.
        top extent:(panel preferredExtent).
        top open.
                                                                        [exEnd]


    a small dialog
                                                                        [exBegin]
        |dialog group b|

        dialog := Dialog new.

        group := RadioButtonGroup new.
        group add:(b := dialog addCheckBox:'one' on:nil).
        b controller beRadioButton.
        group add:(b := dialog addCheckBox:'two' on:nil).
        b controller beRadioButton.
        group add:(b := dialog addCheckBox:'three' on:nil).
        b controller beRadioButton.
        group value:2.
        dialog addAbortButton; addOkButton.
        dialog open.

        dialog accepted ifTrue:[
            Transcript showCR:'you selected: ' , group value printString
        ] ifFalse:[
            Transcript showCR:'aborted'
        ]
                                                                        [exEnd]

  as a selectionIndexHolder of a selectionInList
  (i.e. a selectionInListView and a group displaying the same selection):
                                                                        [exBegin]
    |top top2 panel b sv group selectionInList|

    top := StandardSystemView extent:200@200.

    panel := HorizontalPanelView
                origin:0.0@0.0 corner:1.0@1.0 in:top.

    group := RadioButtonGroup new.
    selectionInList := SelectionInList new.
    selectionInList list:#('am' 'fm' 'off').
    selectionInList selectionIndexHolder:group.

    b := RadioButton label:'am' in:panel.
    group add:b.

    b := RadioButton label:'fm' in:panel.
    group add:b.

    b := RadioButton label:'off' in:panel.
    group add:b.

    group value:1.
    top open.


    top2 := StandardSystemView extent:200@200.
    sv := SelectionInListView in:top2.
    sv model:selectionInList.
    sv origin:0.0@0.0 corner:1.0@1.0.
    top2 open.
                                                                        [exEnd]
"

    "Created: / 15.11.1995 / 17:14:53 / cg"
    "Modified: / 30.10.1997 / 20:18:25 / cg"
! !

!RadioButtonGroup class methodsFor:'helpers'!

adaptorFor:someValueHolder value:buttonValue
    "create and return an adaptor for a radioButton"

    |adaptor|

    adaptor := PluggableAdaptor on:someValueHolder.

    "/ the adapter plays boolean-value holder towards
    "/ the radioButton, returning true iff the groups
    "/ value is the same as the buttons index-value; false otherwise.
    "/ Likewise, a true-store from the button sets the group value
    "/ to the buttons index.

    adaptor getBlock:[:m | (m value = buttonValue) ]
            putBlock:[:m :onOff | 
                           onOff ifTrue:[
                               m value:buttonValue
                           ] ifFalse:[
                                "/ support for toggles
                                buttonValue = m value ifTrue:[
                                   m value:nil 
                                ]
                           ]
                     ]
         updateBlock:[:m :a :v | true].

    ^ adaptor

    "Created: / 30.10.1997 / 19:45:34 / cg"
    "Modified: / 30.10.1997 / 20:14:25 / cg"
! !

!RadioButtonGroup methodsFor:'adding & removing'!

add:aRadioButton
    "add a radioButton to the group - actually, this name is misleading;
     it simple creates an adaptor, which converts my value into a boolean,
     depending on the buttons index-number
    "
    self add:aRadioButton value:nil
!

add:aRadioButton value:aValueOrNil
    "add a radioButton to the group - actually, this name is misleading;
     it simply creates an adaptor, which converts my value into a boolean,
     depending on the buttons index-number or aValueOrNil"

    |adaptor selectValue|

    numberOfValues := (numberOfValues ? 0) + 1.
    selectValue  := aValueOrNil ? numberOfValues.

    "/ the adapter plays boolean-value holder towards
    "/ the radioButton, returning true iff the groups
    "/ value is the same as the buttons index-value; false otherwise.
    "/ Likewise, a true-store from the button sets the group value
    "/ to the buttons index.

    adaptor := self class adaptorFor:self value:selectValue.
    aRadioButton isOn ifTrue:[
        self value:selectValue.
    ].
    aRadioButton model:adaptor.

    "Modified: / 30.10.1997 / 20:14:54 / cg"
! !

!RadioButtonGroup methodsFor:'queries'!

numberOfValues
    ^ numberOfValues
! !

!RadioButtonGroup class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg/RadioButtonGroup.st,v 1.33 2002-11-11 09:49:19 cg Exp $'
! !
