"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

HVScrollableView subclass:#PluggableTextView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!PluggableTextView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    This is a dummy, mimicry class to allow some squeak code to be filed in.
    Its protocol is neither complete, nor fully compatible with the corresponding
    squeak original class.
"
! !

!PluggableTextView class methodsFor:'instance creation'!

new
    ^ super for:CodeView.
!

on:aModel text:textSelector accept:acceptSelector readSelection:readSelectionSelector menu:menuSelector
    |v tv|

    v := self new.
    tv := v scrolledView.
    tv aspectMessage:textSelector.
    tv changeMessage:acceptSelector.
    tv listMessage:textSelector.
    acceptSelector notNil ifTrue:[
        tv acceptEnabled:true
    ].
    tv acceptAction:[:contents| "aModel perform:acceptSelector with:contents"].
    menuSelector notNil ifTrue:[
        tv menuMessage:menuSelector.
    ].
    tv model:aModel.
    ^ v.
! !

!PluggableTextView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/PluggableTextView.st,v 1.7 2017-01-28 00:01:19 cg Exp $'
! !

