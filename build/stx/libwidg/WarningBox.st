"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

InfoBox subclass:#WarningBox
	instanceVariableNames:''
	classVariableNames:'WarnBitmap ErrorBitmap'
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!WarningBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

        In the future, those existing subclasses' functionality might
        be moved fully into Dialog, and the subclasses be replaced by dummy
        delegators. (They will be kept for backward compatibility, though).



    this class implements a pop-up box to show an information message.
    WarningBoxes are basically InfoBoxes with a different bitmap-image.
    (also, they add a beep when popping up)

    They are created with:

        aBox := WarningBox title:'some title'.

    and shown with:

        aBox showAtPointer

    The default box shows 'yes' in its button; this can be changed with:

        aBox okText:'some string'.

    Since showing warnings is a common action, a convenient method has been
    added to Object; thus you can use:

        self warn:'oops - headcrash'

    everywhere in your code.

    [see also:]
        DialogBox InfoBox YesNoBox
        ( introduction to view programming :html: programming/viewintro.html )

    [author:]
        Claus Gittinger
"
!

examples
"
    Notice, the preferred use is via the DialogBox class messages,
    such as
                                                                        [exBegin]
        Dialog warn:'Attention !!'
                                                                        [exEnd]
    these (DialogBox) mesages are compatible with VW and should therefore
    be used for portability.

    Direct reference to WarnBox is only required for highly specialized boxes.


    standard warning dialogs
    (recommended, since these are ST-80 compatible interfaces)
                                                                        [exBegin]
        Dialog warn:'you should not do this'
                                                                        [exEnd]
    since all objects support the #warn message,
    you can also simply use (for any self):
                                                                        [exBegin]
        self warn:'you should not do this'
                                                                        [exEnd]

    with attributed text:
                                                                        [exBegin]
        Dialog warn:(Text string:'you should not do this'
                          emphasis:#color->Color red)
                                                                        [exEnd]

    specifying more details of the warnBox (low level entries).
    label of OK-button:
                                                                        [exBegin]
        |aBox|

        aBox := WarningBox title:'Press ''OK'' to continue'.
        aBox okText:'OK'.
        aBox showAtPointer.
                                                                        [exEnd]

    accessing the ok-Button component and changing its color:
                                                                        [exBegin]
        |aBox|

        aBox := WarningBox title:'Do you really want to do this ?'.
        aBox okText:'yes, go on'.
        aBox okButton foregroundColor:Color red.
        aBox showAtPointer.
                                                                        [exEnd]
    since warnboxes are much like infoBoxes, all of look can be changed
    like described there:
                                                                        [exBegin]
        |image aBox|

        aBox := WarningBox title:'Press ''OK'' to continue'.
        aBox okText:'yes, continue'.
        image := Image fromFile:'bitmaps/SmalltalkX.xbm' inPackage:'stx:libtool'.
        aBox form:image.
        aBox showAtPointer.
                                                                        [exEnd]
"
! !

!WarningBox class methodsFor:'icon bitmap'!

errorIconBitmap
    "return the bitmap shown as icon in my instances.
     This is the default image; you can overwrite this in a concrete
     instance with the image: message"

    <resource: #style (#'errorBox.icon' #'errorBox.iconFile')>

    ErrorBitmap isNil ifTrue:[
        ErrorBitmap := self iconBitmapFromStyle:'errorBox.icon' orStyleFile:'errorBox.iconFile' orFilename:'bitmaps/Error.xbm'.
        ErrorBitmap isNil ifTrue:[
            ErrorBitmap := ToolbarIconLibrary errorIcon.
        ].
    ].
    ^ ErrorBitmap

    "
     |box|

     box := WarningBox title:'foo bar'.
     box image:(WarningBox errorIconBitmap).
     box showAtPointer.
    "

    "Created: / 17.11.1995 / 18:16:47 / cg"
    "Modified: / 16.11.2001 / 15:02:54 / cg"
!

iconBitmap
    "return the bitmap shown as icon in my instances.
     This is the default image; you can overwrite this in a concrete
     instance with the image: message"

    ^ self warnIconBitmap

    "
     self warn:'foo bar'.

     |box|
     box := WarningBox title:'foo bar'.
     box showAtPointer.

     |box|
     box := WarningBox title:'foo bar'.
     box image:(Image fromFile:'QUESTION.xpm' inPackage:'stx:goodies/bitmaps/xpmBitmaps').
     box showAtPointer.
    "

    "Created: / 17.11.1995 / 18:16:47 / cg"
    "Modified: / 16.11.2001 / 15:02:38 / cg"
!

warnIconBitmap
    "return the bitmap shown as icon in my instances.
     This is the default image; you can overwrite this in a concrete
     instance with the image: message"

    <resource: #style (#'warningBox.icon' #'warningBox.iconFile')>

    WarnBitmap isNil ifTrue:[
        WarnBitmap := self iconBitmapFromStyle:'warningBox.icon' orStyleFile:'warningBox.iconFile' orFilename:'bitmaps/Warning.xbm'.
        WarnBitmap isNil ifTrue:[
            WarnBitmap := ToolbarIconLibrary warnIcon.
        ].
    ].
    ^ WarnBitmap

    "
     self warn:'foo bar'.

     |box|
     box := WarningBox title:'foo bar'.
     box showAtPointer.

     |box|
     box := WarningBox title:'foo bar'.
     box image:(Image fromFile:'QUESTION.xpm' inPackage:'stx:goodies/bitmaps/xpmBitmaps').
     box showAtPointer.
    "

    "Modified: / 25.5.1999 / 15:22:25 / cg"
    "Created: / 16.11.2001 / 15:02:24 / cg"
! !

!WarningBox class methodsFor:'styles'!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables.
     Here, the cached infoBitmap is simply flushed."

    WarnBitmap := nil.
    ErrorBitmap := nil.

    "Modified: / 16.11.2001 / 15:00:43 / cg"
! !

!WarningBox methodsFor:'initialization'!

initialize
    super initialize.
    label := 'Warning'
! !

!WarningBox methodsFor:'queries'!

beepWhenOpening
    ^ UserPreferences current beepForWarningDialog
! !

!WarningBox class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

