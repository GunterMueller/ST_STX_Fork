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

DialogBox subclass:#OptionBox
	instanceVariableNames:'labelPanel formLabel textLabel buttons actions defaultButtonIndex'
	classVariableNames:'WarnBitmap'
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!OptionBox class methodsFor:'documentation'!

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
   CAVEAT: this is a leftover - functionality has been merged into DialogBox
   PLEASE use one of the `Dialog chooseXXX' methods instead of OptionBox.


   Historic note:
      originally, ST/X had separate classes for the various entry methods;
      there were YesNoBox, EnterBox, InfoBox and so on.
      In the meantime, the DialogBox class (and therefore its alias: Dialog)
      is going to duplicate most functionality found in these classes.

      In the future, those existing subclasses' functionality is going to
      be moved fully into Dialog, and the subclasses will be replaced by dummy
      delegators. (They will be kept for backward compatibility, though).


    OptionBoxes are like YesNoBoxes but with as many buttons as you like;
    this will finally be a superclass of WarnBox and YesNoBox - or maybe merged
    all into DialogBox..
    Use them for multiway questions.
    For a consistent user interface, the rightmost button is the default return
    button (i.e. pressing return in the box performs this buttons function).

    [author:]
        Claus Gittinger

    [see also:]
        DialogBox
"
!

examples
"
                                                                        [exBegin]
    |box|

    box := OptionBox title:'hello' numberOfOptions:4.
    box showAtPointer
                                                                        [exEnd]


                                                                        [exBegin]
    |box|
    box := OptionBox title:'hello' numberOfOptions:3.
    box buttonTitles:#('one' 'two' 'three').
    box showAtPointer
                                                                        [exEnd]

 performing an action:

                                                                        [exBegin]
    |box|
    box := OptionBox title:'hello' numberOfOptions:3.
    box buttonTitles:#('one' 'two' 'three').
    box action:[:which | Transcript show:'button ';
                                    show: which;
                                    showCR:' was pressed'].
    box showAtPointer
                                                                        [exEnd]

 returning a value:
                                                                        [exBegin]
    |what|

    what := OptionBox
                  request:('text has not been accepted.\\Your modifications will be lost when continuing.') withCRs
                  label:' Attention'
                  image:(WarningBox iconBitmap)
                  buttonLabels:#('Abort' 'Accept' 'Continue')
                  values:#(#abort #accept #continue).
    Transcript showCR:what.
                                                                        [exEnd]


 use callBack-hook to intercept creation:
                                                                        [exBegin]
    |what|

    AboutToOpenBoxNotificationSignal handle:[:ex |
        |box|

        box := ex parameter.
        box verticalPanel
            add:(CheckBox label:'Do no show this Dialog again.'
                          model:false asValue).
        ex proceed.
    ] do:[
        what := OptionBox
                      request:('bla bla bla bla.\\You must bla bla bla!!') withCRs
                      label:' Attention'
                      image:(WarningBox iconBitmap)
                      buttonLabels:#('Abort' 'Accept' 'Continue')
                      values:#(#abort #accept #continue)
                      default:#continue.
    ].
    Transcript showCR:what.
                                                                        [exEnd]
"
! !

!OptionBox class methodsFor:'instance creation'!

title:titleString numberOfOptions:nOptions
    "create a new optionBox with title, aTitleString and nOptions options"

    |box|

    box := self basicNew numberOfOptions:nOptions.
"/ Later...
"/    box initializeForDevice:Screen current.
    box device:Screen current.
    box initialize.
    box title:titleString.
    ^ box
! !

!OptionBox class methodsFor:'easy startup'!

forRequest:title label:label image:anImage buttonLabels:labels values:values default:defaultValue
    "create a new optionBox and return it.
     Does not open the box."

    |box|

    box := OptionBox title:title numberOfOptions:(labels size).
    box buttonTitles:labels.
    box defaultButtonIndex:(values indexOf:defaultValue).
    box label:label; image:anImage.
    values keysAndValuesDo:[:idx :val |
        val == false ifTrue:[
            (box buttons at:idx) cursor:(Cursor thumbsDown).
        ].
        val == true ifTrue:[
            (box buttons at:idx) cursor:(Cursor thumbsUp).
        ].
    ].
    ^ box

    "Modified: / 23.2.2000 / 11:59:32 / cg"
!

request:title buttonLabels:labels values:values
    "create a new optionBox, open it modal and return the value of
     the corresponding values collection. Return nil if cancelled"

    ^ self
        request:title
        label:title
        buttonLabels:labels
        values:values

    "
     OptionBox
        request:'please select any'
        buttonLabels:#('one' 'two' 'three')
        values:#(1 2 3)
    "

    "Modified: / 08-02-2011 / 11:22:13 / cg"
!

request:title buttonLabels:labels values:values default:defaultValue
    "create a new optionBox, open it modal and return the value of
     the corresponding values collection. Return nil if cancelled."

    ^ self
        request:title label:title image:(YesNoBox iconBitmap) buttonLabels:labels values:values
        default:defaultValue onCancel:nil

    "
     OptionBox
        request:'please select'
        buttonLabels:#('one' 'two' 'three')
        values:#(1 2 3)
        default:3
    "
!

request:title label:label buttonLabels:labels values:values
    "create a new optionBox, open it modal and return the value of
     the corresponding values collection. Return nil if cancelled"

    ^ self
        request:title
        label:label
        image:(YesNoBox iconBitmap)
        buttonLabels:labels
        values:values
        default:nil
        onCancel:nil

    "
     OptionBox
        request:'please select'
        label:'select any'
        buttonLabels:#('one' 'two' 'three')
        values:#(1 2 3)
    "

    "Modified: / 08-02-2011 / 11:32:48 / cg"
!

request:title label:label buttonLabels:labels values:values default:defaultValue
    "create a new optionBox, open it modal and return the value of
     the corresponding values collection. Return nil if cancelled"

    ^ self
        request:title label:label image:(YesNoBox iconBitmap) buttonLabels:labels values:values
        default:defaultValue onCancel:nil

    "
     OptionBox
        request:'please select'
        label:'select any'
        buttonLabels:#('one' 'two' 'three')
        values:#(1 2 3)
        default:3
    "
!

request:title label:label buttonLabels:labels values:values default:defaultValue onCancel:cancelValue
    "create a new optionBox, open it modal and return the value of
     the corresponding values collection. Return cancelValue if cancelled."

    ^ self
        request:title label:label image:(YesNoBox iconBitmap) buttonLabels:labels values:values
        default:defaultValue onCancel:cancelValue

    "
     OptionBox
        request:'please select'
        label:'select any'
        buttonLabels:#('one' 'two' 'three')
        values:#(1 2 3)
        default:3
        onCancel:2
    "
!

request:title label:label image:anImage buttonLabels:labels values:values
    "create a new optionBox, open it modal and return the value of
     the corresponding values collection. Return nil, if cancelled."

    ^ self
        request:title label:label image:anImage buttonLabels:labels values:values
        default:nil onCancel:nil

    "
     OptionBox
        request:'please select'
        label:'select any'
        image:(WarningBox iconBitmap)
        buttonLabels:#('one' 'two' 'three')
        values:#(1 2 3)
    "
!

request:title label:label image:anImage buttonLabels:labels values:values default:defaultValue
    "create a new optionBox, open it modal and return the value of
     the corresponding values collection. Return nil if cancelled."

    ^ self
        request:title label:label image:anImage buttonLabels:labels values:values
        default:defaultValue onCancel:nil

    "
     OptionBox
        request:'please select'
        label:'select any'
        image:(WarningBox iconBitmap)
        buttonLabels:#('one' 'two' 'three')
        values:#(1 2 3)
        default:3
    "
!

request:title label:label image:anImage buttonLabels:labels values:values default:defaultValue onCancel:cancelValue
    "create a new optionBox, open it modal and return the value of
     the corresponding values collection. Return cancelValue if cancelled."

    |box retVal|

    retVal := cancelValue.
    box := self
                forRequest:title
                label:label
                image:anImage
                buttonLabels:labels
                values:values
                default:defaultValue.

    box action:[:n | retVal := values at:n].
    self showAndThenDestroyBox:box.

    ^ retVal

    "
     OptionBox
        request:'please select'
        label:'select any'
        image:(WarningBox iconBitmap)
        buttonLabels:#('one' 'two' 'three')
        values:#(1 2 3)
        default:3
        onCancel:nil
    "

    "Modified: / 23.2.2000 / 11:59:32 / cg"
! !

!OptionBox class methodsFor:'obsolete'!

forRequest:title label:label form:anImage buttonLabels:labels values:values default:defaultValue
    "create a new optionBox and return it.
     Does not open the box."

    <resource:#obsolete>

    self forRequest:title label:label image:anImage buttonLabels:labels values:values default:defaultValue
!

request:title label:label form:aForm buttonLabels:labels values:values
    "create a new optionBox, open it modal and return the value of
     the corresponding values collection. Return nil, if cancelled."

    <resource:#obsolete>

    ^ self
        request:title label:label image:aForm buttonLabels:labels values:values
        default:nil onCancel:nil
!

request:title label:label form:aForm buttonLabels:labels values:values default:defaultValue
    "create a new optionBox, open it modal and return the value of
     the corresponding values collection. Return nil if cancelled."

    <resource:#obsolete>

    ^ self
        request:title
        label:label
        image:aForm
        buttonLabels:labels
        values:values
        default:defaultValue
        onCancel:nil
!

request:title label:label form:aForm buttonLabels:labels values:values default:defaultValue onCancel:cancelValue
    "create a new optionBox, open it modal and return the value of
     the corresponding values collection. Return cancelValue if cancelled."

    <resource:#obsolete>

    ^ self request:title label:label image:aForm buttonLabels:labels values:values default:defaultValue onCancel:cancelValue
! !

!OptionBox methodsFor:'accessing'!

action:actionBlock
    "define a single the action for all buttons.
     The action will be evaluated with the button index as argument."

    buttons keysAndValuesDo:[:index :button |
	button action:[
		       button turnOffWithoutRedraw.
		       self hide.
		       actionBlock value:index
		      ]
    ].
!

actions:actionBlocks
    "define the actions"

    actions := actionBlocks
!

buttonTitles:titles actions:actionBlocks
    "define both button titles and actions"

    self buttonTitles:titles.
    actions := actionBlocks.
!

defaultButtonIndex:index
    "define which button is the default (i.e. return-) button.
     By default, no returnButton is setup. The argument must be an
     index 1..nButtons, or nil"

    defaultButtonIndex notNil ifTrue:[
        (buttons at:defaultButtonIndex) isReturnButton:false
    ].
    (index notNil and:[index ~~ 0]) ifTrue:[
        defaultButtonIndex := index.
        defaultButtonIndex notNil ifTrue:[
            (buttons at:defaultButtonIndex) isReturnButton:true
        ].
    ]

    "Modified: 18.10.1996 / 14:53:36 / cg"
!

numberOfOptions
    "return the number of options"

    ^ buttons size
!

numberOfOptions:nOptions
    "set the number of options - this is a private interface"

    buttons := OrderedCollection newWithSize:nOptions.
    actions := OrderedCollection newWithSize:nOptions

    "Modified: 18.10.1996 / 14:54:30 / cg"
! !

!OptionBox methodsFor:'accessing-components'!

buttons
    "return the buttons collection"

    ^ buttons
!

labelPanel
    ^ labelPanel
! !

!OptionBox methodsFor:'accessing-look'!

buttonTitles:titles
    "set the button titles"

    titles keysAndValuesDo:[:index :aString |
        |b|

        (b := buttons at:index) label:aString.
        b name: (b name? ''), index printString.
        b resize.
    ].
    shown ifTrue:[self resize]
!

form:aFormOrImage
    "historical leftover - define a form to be displayed left of the title"

    <resource:#obsolete>

    self image:aFormOrImage
!

formLabel
    "return the label-view which displays a bitmap"

    ^ formLabel
!

image:aFormOrImage
    "set the image shown in the label-view"

    |mm|

    mm := ViewSpacing.
    formLabel label:aFormOrImage.
    textLabel origin:((mm + formLabel width + mm) @ mm).
!

textLabel
    "return the label-view which displays a message string"

    ^ textLabel
!

title:aString
    "set the boxes title"

    aString ~= textLabel label ifTrue:[
	textLabel label:aString withoutSeparators.
	textLabel forceResize.
	shown ifTrue:[self resize]
    ]
!

title:aString numberOfOptions:nOptions
    "set the boxes title and number of options"

    self title:aString.
    buttons grow:nOptions.
    actions grow:nOptions
! !

!OptionBox methodsFor:'events'!

keyPress:aKey x:x y:y
    "return-key duplicates ok-function if acceptReturnAsOK is true"

"/    <resource: #keyboard (#Return)>

"/ now done by keyboard processor
"/    |action|
"/
"/    defaultButtonIndex notNil ifTrue:[
"/        (aKey == #Return) ifTrue:[
"/            self hide.
"/            action := actions at:defaultButtonIndex.
"/            action value
"/        ]
"/    ].
    super keyPress:aKey x:x y:y

    "Modified: 7.3.1996 / 13:17:36 / cg"
! !

!OptionBox methodsFor:'initialization'!

initFormBitmap
    WarnBitmap isNil ifTrue:[
        WarnBitmap := WarningBox iconBitmap.
"/        WarnBitmap := Image fromFile:'bitmaps/Warning.xbm' resolution:100 on:Display
    ].
    formLabel label:WarnBitmap

    "Modified: / 25.5.1999 / 16:08:06 / cg"
!

initialize
    |mm vPanelLayout|

    super initialize.

    mm := ViewSpacing.

    verticalPanel := VerticalPanelView in:self.
    vPanelLayout := LayoutFrame origin:(mm @ mm) corner:(1.0@1.0).
    vPanelLayout bottomOffset:(gc font height + (mm * 5)) negated.
    vPanelLayout rightOffset:mm negated.
    verticalPanel geometryLayout:vPanelLayout.
    verticalPanel horizontalLayout:#fit.
    verticalPanel verticalLayout:#bottomFit.

    labelPanel := HorizontalPanelView in:verticalPanel.
    labelPanel horizontalLayout:#leftSpace.
    labelPanel verticalLayout:#topSpace.
    labelPanel height:(labelPanel preferredHeight + (mm * 4)).

    formLabel := Label in:labelPanel.
    self initFormBitmap.
    formLabel borderWidth:0.
"/    formLabel origin:(mm @ mm).

    textLabel := Label label:'Select' in:labelPanel.
    textLabel borderWidth:0.
"/    textLabel origin:((mm + formLabel width + mm) @ mm).

    verticalPanel resize.
    "/ cannot be done here - verticalPanel still has its defaul height and may be
    "/ not yet filled...
    "/ yPosition := verticalPanel height + (mm * 3).

"/    buttonPanel isNil ifTrue:[
"/        buttonPanel := HorizontalPanelView origin:(0.0 @ 1.0) corner:(1.0 @ 1.0) in:self.
"/    ].
    buttonPanel
        bottomInset:0 "mm";
        topInset:(gc font height + (mm * 4) + ViewSpacing + ViewSpacing) negated.
    buttonPanel
        borderWidth:0;
        horizontalLayout:#fitSpace.

    1 to:(buttons size) do:[:index |
        |button|

        button := Button label:'press'.
        button action:[
                       (buttons at:index) turnOffWithoutRedraw.
                       self hide.
                       (actions at:index) value
                      ].
"/        index == nButt ifTrue:[
"/            button isReturnButton:true
"/        ].
        buttonPanel addSubView:button.
        buttons at:index put:button.
    ].

    "
     |box|

     box := OptionBox title:'hello' numberOfOptions:4.
     box open
    "

    "Modified: / 28-02-2012 / 15:56:57 / cg"
! !

!OptionBox methodsFor:'queries'!

preferredExtent
    "return a size to make everything fit into myself"

    |w w1 h buttonPanelsPref vPanelsPref mm|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    mm := ViewSpacing.

    vPanelsPref := verticalPanel preferredExtent.
    w1 := (mm * 3) + formLabel width + textLabel width.
    buttonPanelsPref := buttonPanel preferredExtent.
    w := w1 max:buttonPanelsPref x.
    w := w max:vPanelsPref x.

    h := mm
         + vPanelsPref y
         + mm
         + buttonPanelsPref y
         + mm.

    self subViews do:[:v |
        (v ~~ verticalPanel and:[v ~~ buttonPanel]) ifTrue:[
            h := h + v preferredExtent y.
            w := w max:(v preferredExtent x).
        ].
    ].

    preferredExtent := super preferredExtent max:(w @ h).
    ^ preferredExtent

    "Modified: 19.7.1996 / 20:45:11 / cg"
! !

!OptionBox class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

