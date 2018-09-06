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

"{ NameSpace: Smalltalk }"

MenuView subclass:#CodeCompletionHelpMenuView
	instanceVariableNames:'infoPerEntry'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Help'
!

PopUpView subclass:#SimulatedMenuForHTMLView
	instanceVariableNames:'codeCompletionMenu'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CodeCompletionHelpMenuView
!

!CodeCompletionHelpMenuView class methodsFor:'documentation'!

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
        Workspace::CodeCompletionService
"
! !

!CodeCompletionHelpMenuView methodsFor:'accessing'!

infoPerEntry:something
    infoPerEntry := something.
! !

!CodeCompletionHelpMenuView methodsFor:'initialization'!

initStyle
    |defaultFont|

    super initStyle.
    defaultFont := StyleSheet fontAt:#'activeHelp.font' default:nil.
    defaultFont notNil ifTrue:[
        self font:defaultFont
    ].
    self viewBackground:Color orange lightened lightened lightened.
! !

!CodeCompletionHelpMenuView methodsFor:'queries'!

isGraphicItem:line
    ^ false
!

wantsFocusWithPointerEnter
    "DEFINITELY not, because if we do so,
     the editView looses focus on entry, and sends me to hell in its lost focus handling!!
     So I will be terminated by a motion"

    ^ false
! !

!CodeCompletionHelpMenuView methodsFor:'selections'!

setSelection:newSelection
    super setSelection:newSelection.
    self showInfoForSelection:newSelection.
!

showInfoForSelection:newSelection
    |selector info|
    
    "/ work in progress...
    
false ifTrue:[
    newSelection notNil ifTrue:[
        selector := self listAt:newSelection.
        infoPerEntry notNil ifTrue:[
            info := infoPerEntry at:newSelection.
        ] ifFalse:[
            info := 'bla bla bla'.
        ].
        info notNil ifTrue:[
            (self subMenuAt:newSelection) isNil ifTrue:[
                "/ TODO: install another menu, showing the tooltop

                |infoView htmlView|

                infoView := SimulatedMenuForHTMLView new.
                htmlView := HTMLView origin:0.0@0.0 corner:1.0@1.0 in:infoView.
                htmlView contents:info.
                
                self subMenuAt:newSelection put:infoView.
                "/ Transcript showCR:selector.
                self invalidateLine:newSelection.
            ].    
        ].    
    ].
].
! !

!CodeCompletionHelpMenuView::SimulatedMenuForHTMLView methodsFor:'menu protocol'!

action:anActionBlock
    "ignored for now"
!

haveControl:aBoolean
    "ignored here"
!

menuView
    ^ self
!

noShadow
!

superMenu:aMenu
    "ignored for now"
! !

!CodeCompletionHelpMenuView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

