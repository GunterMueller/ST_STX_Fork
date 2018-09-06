"
 COPYRIGHT (c) 1998 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

ComboBoxView subclass:#ComboBrowseView
	instanceVariableNames:'browseAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!ComboBrowseView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    This combines a text-input field with a '...'-Button.
    The Button opens a fileSelection browser to allow selecting a file.
    The browse action can be changed programatically via the #browseAction:
    method.

    [author:]
	Claus Gittinger
"
!

examples
"
  non MVC operation:
									[exBegin]
     |top b|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     b := ComboBrowseView in:top.
     b origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     b bottomInset:(b preferredExtent y negated).

     top open.
									[exEnd]



  model operation:
									[exBegin]
     |model top b|

     model := 'foo' asValue.

     top := StandardSystemView new.
     top extent:(300 @ 200).

     b := ComboBrowseView in:top.
     b origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     b bottomInset:(b preferredExtent y negated).

     b model:model.

     top openModal.
     Transcript showCR:('entered value: ' , model value).
									[exEnd]
"

! !

!ComboBrowseView class methodsFor:'defaults'!

buttonForm
    "return the pull-buttons image"

    ^ '...'

    "Created: / 13.10.1998 / 16:38:45 / cg"
! !

!ComboBrowseView methodsFor:'accessing'!

browseAction
    "return the value of the instance variable 'browseAction' (automatically generated)"

    ^ browseAction

    "Created: / 13.10.1998 / 16:46:59 / cg"
!

browseAction:something
    "set the value of the instance variable 'browseAction' (automatically generated)"

    browseAction := something.

    "Created: / 13.10.1998 / 16:46:59 / cg"
! !

!ComboBrowseView methodsFor:'initialization'!

initialize
    super initialize.

"/    self font:(Font family:'helvetica' size:10).
    browseAction := [FileSelectionBrowser open]

    "Created: / 13.10.1998 / 16:47:46 / cg"
!

initializeButton
    super initializeButton.
    pullDownButton enable.
    pullDownButton pressAction:[self openBrowser].

    "Created: / 13.10.1998 / 16:39:50 / cg"
!

openBrowser
    |s|

    s := browseAction value.
    pullDownButton turnOff.
    s notNil ifTrue:[
	field contents:s.
    ]

    "Created: / 13.10.1998 / 16:40:56 / cg"
    "Modified: / 13.10.1998 / 16:47:56 / cg"
! !

!ComboBrowseView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/ComboBrowseView.st,v 1.4 2006-11-13 16:11:29 cg Exp $'
! !

