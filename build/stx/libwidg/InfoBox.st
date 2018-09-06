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

DialogBox subclass:#InfoBox
	instanceVariableNames:'formAndLabelPanel formLabel textLabel'
	classVariableNames:'InfoBitmap'
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!InfoBox class methodsFor:'documentation'!

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



    this class implements a pop-up box to show an information message.
    It has a single ok-Button, which closes the box.
    Also entering return has (by default) the same effect as pressing
    the ok-button.
    InfoBox is a superclass of some other boxes - see WarningBox, YesNoBox etc.
    most of them simply redefine the icon shown in the upper left or
    add buttons.

    [instance variables:]

        formLabel        <Label>        shows a bitmap (warning, question-mark)

        textLabel        <Label>        shows the boxes text


    [author:]
        Claus Gittinger
"
!

examples
"
    Notice, the preferred use is via the DialogBox class messages,
    such as
                                                                        [exBegin]
        Dialog information:'Time to go home'
                                                                        [exEnd]
    these (DialogBox) mesages are compatible with VW and should therefore
    be used for portability.

    Direct use of InfoBox is only required for highly specialized boxes.



    InfoBoxes are created with:

        aBox := InfoBox title:'some title'.

    and shown with:

        aBox showAtPointer
    or
        aBox open

    The default box shows 'yes' in its button; this can be changed with:

        aBox okText:'some string'.

    the boxes bitmap-image can be changed with:

        aBox image:aForm


    Since this type of information is pretty common, a convenient information
    method has been added to Object.
    Thus, you can use:
                                                                        [exBegin]
        self information:'hello world'
                                                                        [exEnd]

    everwhere in your program.
    for ST-80 compatibility, you can also use:
                                                                        [exBegin]
        Dialog information:'hello world'
                                                                        [exEnd]



    standard box:
                                                                        [exBegin]
        |box|

        box := InfoBox title:'hello world '.
        box open
                                                                        [exEnd]


    changing the buttons label:
                                                                        [exBegin]
        |box|

        box := InfoBox title:'hello world '.
        box okText:'wow'.
        box open
                                                                        [exEnd]


    changing the icon:

                                                                        [exBegin]
        |box|

        box := InfoBox title:'hello world '.
        box image:(Image fromFile:'libtool/bitmaps/SBrowser.xbm' inPackage:'stx:libtool').
        box okText:'wow'.
        box open
                                                                        [exEnd]

    or even:
                                                                        [exBegin]
        |box|

        box := InfoBox title:'hello garfield '.
        box image:((Image fromFile:'garfield.gif' inPackage:'stx:goodies/bitmaps/gifImages') magnifiedTo:200@100).
        box okText:'wow'.
        box open
                                                                        [exEnd]


    If you plan to use boxes as in the last example, you may want to
    keep the box around for reuse (since the image magnification takes some time).
                                                                        [exBegin]
        |box|

        box := InfoBox title:'hello garfield '.
        box image:((Image fromFile:'garfield.gif' inPackage:'stx:goodies/bitmaps/gifImages') magnifiedTo:200@100).
        box okText:'wow'.
        box open.

        box title:'hello again'.
        box open
                                                                        [exEnd]

"
! !

!InfoBox class methodsFor:'instance creation'!

title:titleString
    "create a new infoBox with title, aTitleString"

    ^ (self new) title:titleString

    "
     (InfoBox title:'hello') open
    "

    "Modified: / 22-12-2010 / 19:30:50 / cg"
!

title:titleString label:labelString
    "create a new infoBox with label, labelString"

    ^ (self new) title:titleString label:labelString

    "
     (InfoBox title:'hello' label:'Attention' ) open
    "

    "Created: / 22-12-2010 / 19:31:03 / cg"
! !

!InfoBox class methodsFor:'defaults'!

defaultLabel
    "return the boxes default window title."

    ^ 'Info'

    "Created: 23.4.1996 / 17:12:33 / cg"
!

iconBitmap
    "return the bitmap shown as icon in my instances.
     This is the default image; you can overwrite this in a concrete
     instance with the #image: message"

    <resource: #style (#'infoBox.icon' #'infoBox.iconFile')>

    InfoBitmap isNil ifTrue:[
        InfoBitmap := self iconBitmapFromStyle:'infoBox.icon' orStyleFile:'infoBox.iconFile' orFilename:'bitmaps/Information.xbm'.
    ].
    ^ InfoBitmap

    "Modified: / 26.10.1997 / 17:02:51 / cg"
!

iconBitmapFromStyle:styleName orStyleFile:styleFile orFilename:fileName
    "return the bitmap shown as icon in my instances.
     This is the default image; you can overwrite this in a concrete
     instance with the #image: message"

    |img imgFileName|

    img := self styleSheet at:styleName.
    img isNil ifTrue:[
        imgFileName := StyleSheet at:styleFile default:fileName.
        img := Smalltalk imageFromFileNamed:imgFileName forClass:self.
    ].
    img notNil ifTrue:[
        img := img onDevice:Display
    ].
    ^ img

    "Modified: / 26.10.1997 / 17:02:51 / cg"
! !

!InfoBox class methodsFor:'styles'!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables.
     Here, the cached infoBitmap is simply flushed."

    InfoBitmap := nil

    "Modified: 1.4.1997 / 14:44:50 / cg"
! !

!InfoBox methodsFor:'accessing'!

form:aFormOrImage
    "historical leftover - define a form to be displayed left of the title"

    <resource:#obsolete>

    self image:aFormOrImage
!

formLabel
    "return the formLabel = can be used to change its appearance"

    ^ formLabel
!

image:aForm
    "define a form to be displayed left of the title
     - usually left as defaulted:
        an exclamation-mark here, warn-sign in warningBox,
        others in other subclasses."

    formLabel label:aForm.
    formLabel forceResize.
    formAndLabelPanel forceResize.
    verticalPanel forceResize.
    shown ifTrue:[self resize]
!

textLabel
    "return the textLabel = can be used to change its appearance"

    ^ textLabel
!

title
    "return the boxes title string"

    ^ textLabel label

    "Created: / 22-12-2010 / 19:27:43 / cg"
!

title:aString
    "set the boxes label string"

    aString ~= textLabel label ifTrue:[
        textLabel label:aString.
        textLabel forceResize.
        formAndLabelPanel forceResize.
        verticalPanel forceResize.
        shown ifTrue:[self resize]
    ]

    "Created: / 22-12-2010 / 19:27:16 / cg"
!

title:aString label:windowLabel
    "set the boxes label string"

    self label:windowLabel.
    self title:aString.
! !

!InfoBox methodsFor:'initialization'!

initFormBitmap
    "setup the bitmap shown in the upper left -
     extracted into a separate method for easier redefinition
     in subclasses"

    formLabel label:(self class iconBitmap)
!

initFormLabel
    "setup the icon shown in the infoBox.
     Can be redefined in subclasses."

    |mm|

    mm := ViewSpacing.

    formLabel := Label in:formAndLabelPanel.
    formLabel name: 'formLabel'.
    formLabel borderWidth:0.
"/    formLabel origin:(mm @ mm).

    "Created: / 16-11-1995 / 18:32:32 / cg"
    "Modified: / 22-04-1996 / 18:15:37 / cg"
    "Modified (format): / 28-02-2012 / 18:20:23 / cg"
!

initialize
    |mm sep|

    super initialize.
    self addOkButton.

"/    label := 'Info'.

"/    mm := ViewSpacing.

    formAndLabelPanel := HorizontalPanelView in:self verticalPanel.

    self initFormLabel.
    self initFormBitmap.

    formLabel width > 500 ifTrue:[
        textLabel := Label label:'Information' in:verticalPanel.
    ] ifFalse:[
        textLabel := Label label:'Information' in:formAndLabelPanel.
    ].
    textLabel name: 'textLabel'.
    textLabel borderWidth:0.
    "/ textLabel origin:[(mm + formLabel widthIncludingBorder + mm) @ mm].

"/    yPosition := textLabel corner y.
"/    formLabel notNil ifTrue:[yPosition := yPosition max:(formLabel corner y)].
"/    yPosition := yPosition + ViewSpacing.

    (styleSheet at:'infoBoxSeparator' default:false) ifTrue:[
        sep := Separator in:self verticalPanel.
"/        sep origin:[0.0 @ ((formLabel bottom max:textLabel bottom) + mm)].
        sep width:1.0. "/ extent:(1.0 @ sep preferredHeight).
"/        yPosition := yPosition max:(sep corner y).
"/        yPosition := yPosition + ViewSpacing.
    ].

    "
     |b|

     b := InfoBox new.
     b title:'hello'.
     b open
    "

    "Modified: / 29-07-2011 / 12:31:29 / cg"
! !

!InfoBox methodsFor:'queries'!

beepWhenOpening
    ^ UserPreferences current beepForInfoDialog

    "
     Dialog information:'hello'
     Dialog warn:'hello'
     Dialog error:'hello'
    "
!

preferredExtent
    "return my preferred extent"

    |w h mm|

^ super preferredExtent.

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    mm := ViewSpacing.

    w := ((margin + mm) * 2) +
         formLabel widthIncludingBorder +
         mm + textLabel width.

    w := w max:(okButton preferredWidth + (mm * 2)).
    w := w max:self maxPreferredWidthOfAddedComponents.

    h := (mm * 6)
         + ((formLabel heightIncludingBorder) max:(textLabel height))
         + ((addedComponents ? #()) inject:0 into:[:sum :thisComponent | sum + thisComponent preferredHeight])
         + okButton heightIncludingBorder.

    (styleSheet at:'infoBoxSeparator' default:false) ifTrue:[
        h := h + (ViewSpacing * 3)
    ].

    ^ w @ h

    "Modified: 1.4.1997 / 14:53:35 / cg"
! !

!InfoBox class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

