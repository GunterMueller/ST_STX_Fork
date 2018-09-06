"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

WarningBox subclass:#YesNoBox
	instanceVariableNames:''
	classVariableNames:'RequestBitmap'
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!YesNoBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

    New applications should use corresponding confirmation
    methods from DialogBox.

    this class implements yes-no boxes by adding another (no-) Button to the WarnBox-View.
    They are created with:

        aBox := YesNoBox title:'some title'.
        aBox okAction:[ .. some action to be performed when ok is pressed ].

    and finally shown with:

        aBox showAtPointer

    The default box shows 'yes' and 'no' in its buttons; this can be changed with:

        aBox yesText:'some string'.
        aBox noText:'some string'.

    There is also protocol to set both button titles in one message.
    Also, the action associated to the noButton can be changed.

    For very simple yes/no queries, you can also use the much simpler confirm:.
    Since implemented in Object, everyone understands confirm. You can pass
    a question message (but not change the buttons labels).
    Use is:
        self confirm:'some question'
    and will return true or false.

    For compatibility with ST-80, use:
        Dialog confirm:'hello'

    [see also:]
        DialogBox
        EnterBox

    [author:]
        Claus Gittinger

"
!

examples
"
    Notice, the preferred use is via the DialogBox class messages,
    such as
                                                                        [exBegin]
        Dialog confirm:'Coffee ?'
        Dialog confirmWithCancel:'Coffee ?'
                                                                        [exEnd]
    these (DialogBox) mesages are compatible with VW and should therefore
    be used for portability.

    Direct reference to YesNoBox is only required for highly specialized boxes.


    Examples:
                                                                        [exBegin]
        |aBox|

        aBox := YesNoBox title:'Coffee or tee ?'.
        aBox noText:'tee'.
        aBox yesText:'coffee'.
        aBox yesAction:[Transcript showCR:'make coffee'].
        aBox noAction:[Transcript showCR:'make tee'].
        aBox showAtPointer.
                                                                        [exEnd]
    or, shorter:
                                                                        [exBegin]
        |aBox|

        aBox := YesNoBox new.
        aBox title:'Coffee or Tee?'
             yesAction:[Transcript showCR:'make coffee']
             noAction:[Transcript showCR:'make tee'].
        aBox yesText:'Coffee' noText:'Tee'.
        aBox showAtPointer
                                                                        [exEnd]

    Also, have a look at the inherited protocol; for example, this allows changing
    the bitmap (default: a question mark) and other properties.

    If the box is needed to ask for a simple boolean, you can also use the
    #confirm method, to bring up a box, let it ask for something and return
    true or false.
    Example:
                                                                        [exBegin]
        |box value|

        box := YesNoBox new.
        value := box confirm:'yes or no:'.
        value ifTrue:[
            Transcript showCR:'yes'
        ] ifFalse:[
            Transcript showCR:'no'
        ]
                                                                        [exEnd]

    of course, this can also be written shorter as:
                                                                        [exBegin]
        (YesNoBox new confirm:'yes or no:') ifTrue:[
            Transcript showCR:'yes'
        ] ifFalse:[
            Transcript showCR:'no'
        ]
                                                                        [exEnd]
    or:
                                                                        [exBegin]
        (Dialog confirm:'yes or no:') ifTrue:[
            Transcript showCR:'yes'
        ] ifFalse:[
            Transcript showCR:'no'
        ]
                                                                        [exEnd]
"
! !

!YesNoBox class methodsFor:'instance creation'!

title:titleString yesText:yesString noText:noString
    "return a new YesNoBox with title, and buttonLabels yesString/noString"

    ^ (self new) title:titleString yesText:yesString noText:noString

    "Modified: 11.4.1997 / 21:11:45 / cg"
! !

!YesNoBox class methodsFor:'icon bitmap'!

iconBitmap
    "return the bitmap shown as icon in my instances.
     This is the default image; you can overwrite this in a concrete
     instance with the #image: message."

    <resource: #style (#'requestBox.icon' #'requestBox.iconFile')>

    RequestBitmap isNil ifTrue:[
        RequestBitmap := self iconBitmapFromStyle:'requestBox.icon' orStyleFile:'requestBox.iconFile' orFilename:'bitmaps/Request.xbm'.
    ].
    ^ RequestBitmap

    "Created: / 17.11.1995 / 18:16:47 / cg"
    "Modified: / 26.10.1997 / 17:06:19 / cg"
! !

!YesNoBox class methodsFor:'styles'!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables.
     Here, the cached infoBitmap is simply flushed."

    RequestBitmap := nil

    "Modified: 1.4.1997 / 14:51:30 / cg"
! !

!YesNoBox methodsFor:'initialization'!

initialize
    super initialize.

    label := resources string:'Choose'.

    buttonPanel horizontalLayout:#fitSpace.  "/ looks better; should it come from the StyleSheet ?

    textLabel label:(resources string:'Please confirm').
    okButton label:(resources string:'Yes').

    abortButton := Button abortButton.

    "/ changed:
    "/ now exclusively done by the buttonPanel itself

"/    (Dialog defaultOKButtonAtLeft) ifTrue:[
"/        buttonPanel addSubView:abortButton after:okButton.
"/    ] ifFalse:[
"/        buttonPanel addSubView:abortButton before:okButton.
"/    ].
    buttonPanel addSubView:abortButton before:okButton.

    abortButton label:(resources string:'No').
    abortButton height:(okButton height).
    abortButton model:self; change:#noPressed

    "Modified: 15.1.1997 / 23:32:21 / cg"
! !

!YesNoBox methodsFor:'queries'!

beepWhenOpening
    ^ false
!

preferredExtent
    "compute the boxes preferredExtent from the components' sizes"

    |w h max mm|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    mm := ViewSpacing.

    "
     make the two buttons of equal size
    "
    max := okButton preferredWidth max:abortButton preferredWidth.
    okButton width:max.
    abortButton width:max.

    w := (formLabel width + textLabel width) max:max * 2.
    w := w + (3 * mm) + ((okButton borderWidth + abortButton borderWidth) * 2).
    w := w max:self maxPreferredWidthOfAddedComponents.

    h := (mm * 5)
         + ((formLabel height) max:(textLabel height))
         + ((addedComponents ? #()) inject:0 into:[:sum :thisComponent | sum + thisComponent preferredHeight])
         + okButton heightIncludingBorder.

    ^ (w @ h).

    "Modified: / 19-07-1996 / 20:45:53 / cg"
    "Modified (format): / 16-11-2016 / 23:14:45 / cg"
! !

!YesNoBox methodsFor:'startup'!

confirm
    "open the receiver and return true for yes, false for no.
     This is an easier interface to use, since no action blocks
     have to be defined. The title is used as previously defined."

    self yesAction:[^ true] noAction:[^ false].
    self showAtPointer.
    self yesAction:nil noAction:nil. "/ clear actions for earlier release of context

    "
     YesNoBox new confirm
    "
!

confirm:aString
    "open a modal yes-no dialog.
     Return true for yes, false for no.
     This is an easier interface to use, since no action blocks have to be defined."

    self title:aString.
    ^ self confirm

    "
     YesNoBox new confirm:'really?'
     YesNoBox confirm:'really?'
     self confirm:'really?'

    for ST-80 compatibility, you should use Dialogs confirm
    (which simply forwards the request to the YesNoBox anyway):

     Dialog confirm:'really?'
    "

    "Modified: 13.12.1995 / 16:20:01 / cg"
! !

!YesNoBox methodsFor:'user interaction'!

noPressed
    "user pressed the no-button;
     hide myself and evaluate the action"

    abortButton turnOffWithoutRedraw.
    self hideAndEvaluate:abortAction
! !

!YesNoBox class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

