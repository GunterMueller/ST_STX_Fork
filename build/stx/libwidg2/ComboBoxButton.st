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

Toggle subclass:#ComboBoxButton
	instanceVariableNames:''
	classVariableNames:'DefaultBorderWidth'
	poolDictionaries:''
	category:'Views-Interactors'
!

!ComboBoxButton class methodsFor:'documentation'!

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
    for ST-80 compatibility, a place to add mimicri protocol.
"
! !

!ComboBoxButton class methodsFor:'defaults'!

updateStyleCache
    <resource: #style (#'comboView.button.borderWidth' 
                      )>

    DefaultBorderWidth := StyleSheet at:#'comboView.button.borderWidth'.

    "
     self updateStyleCache
    "

    "Modified: / 28.4.1999 / 13:59:00 / cg"
! !

!ComboBoxButton methodsFor:'accessing'!

lastSelection:selectionIndex
    "ignored for now"

    "Modified: 30.8.1997 / 02:45:43 / cg"
! !

!ComboBoxButton methodsFor:'focus control'!

wantsFocusWithButtonPress
    "yes, catch the keyboard focus on button click"

    ^ true.
"/    ^ false
! !

!ComboBoxButton methodsFor:'initialization'!

initStyle
    "setup viewStyle specifics"

    super initStyle.

    DefaultBorderWidth notNil ifTrue:[self borderWidth: DefaultBorderWidth].
! !

!ComboBoxButton class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/ComboBoxButton.st,v 1.7 2014-07-08 09:17:36 cg Exp $'
! !

