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
"{ Package: 'stx:libtool' }"

View subclass:#CodeCompletionHelpView
	instanceVariableNames:'myView editView'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Help'
!

!CodeCompletionHelpView class methodsFor:'documentation'!

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
    used with code completion suggestions

    [author:]
        Claus Gittinger

    [See also:]
        ActiveHelp Workspace::CodeCompletionService
"
! !

!CodeCompletionHelpView class methodsFor:'instance creation'!

with:aView
    "create a talking-view wrapping some other view"

    ^ self new withView:aView

    "
     (ActiveHelpView with:(TextView new)) realize
     (ActiveHelpView with:(TextView new)) open
     (ActiveHelpView with:(Button label:'ok')) open
    "

    "Modified: 27.4.1996 / 15:14:18 / cg"
! !

!CodeCompletionHelpView methodsFor:'accessing'!

editView:aView
    editView := aView
!

withView:aView
    "set the component view"

    |fg|

    (aView isKindOf:Label) ifTrue:[
        aView viewBackground:viewBackground.
        aView backgroundColor:viewBackground.
        (fg := styleSheet colorAt:#'activeHelp.foregroundColor' default:nil) notNil ifTrue:[
            aView foregroundColor:fg.    
        ].
    ].
    self addSubView:aView.
    myView := aView.
    myView borderWidth:0.
    myView origin:(0.0@0.0) corner:(1.0@1.0).

    "Modified: 27.4.1996 / 15:16:46 / cg"
! !

!CodeCompletionHelpView methodsFor:'initialization'!

initStyle
    "setup viewStyle specifics"

    <resource: #style (
                       "/ #'activeHelp.backgroundColor'
                       #'activeHelp.borderWidth'
                       "/ #'activeHelp.font'
                       )>

    |defaultFont|

    super initStyle.

"/    defaultFont := styleSheet fontAt:#'activeHelp.font' default:nil.
"/    defaultFont notNil ifTrue:[
"/        self font:defaultFont
"/    ].

    self borderWidth:(styleSheet at:#'activeHelp.borderWidth' default:1).

    "Modified: / 26.10.1997 / 17:02:09 / cg"
!

realize
    self create.
    "/ self computeShape.
    self enableMotionEvents.
    self enableButtonMotionEvents.
    super realize
! !

!CodeCompletionHelpView methodsFor:'private'!

resizeToFit
    "resize myself to make the component view fit"

    |pref bw|

    pref := myView preferredExtent.
    myView extent:pref.
    bw := self borderWidth.
    self extent:(pref + (bw * 2)).
    myView origin:(bw asPoint).

    "Modified: 28.6.1997 / 14:23:49 / cg"
! !

!CodeCompletionHelpView methodsFor:'queries'!

isPopUpView
    "return true - I am a popUp type of view (no decoration, pop-to-top)"

    ^ true

    "Modified: 12.5.1996 / 21:58:12 / cg"
!

wantsFocusWithButtonPress
    "DEFINITELY not, because if we do so,
     the editView looses focus on click, and sends me to hell in its lost focus handling!!
     So I will be terminated by a buttonPress, before I get a chance to handle the buttonRelease
     (in which I fire my action)"

    ^ false
!

wantsFocusWithPointerEnter
    "DEFINITELY not, because if we do so,
     the editView looses focus on entry, and sends me to hell in its lost focus handling!!
     So I will be terminated by a motion"

    ^ false
! !

!CodeCompletionHelpView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/CodeCompletionHelpView.st,v 1.6 2014-03-24 09:02:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/CodeCompletionHelpView.st,v 1.6 2014-03-24 09:02:41 cg Exp $'
! !

