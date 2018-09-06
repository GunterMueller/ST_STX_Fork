"
 COPYRIGHT (c) 2009 by eXept Software AG
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

PopUpMenu subclass:#SelectionMenu
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!SelectionMenu class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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

!SelectionMenu class methodsFor:'menu opening'!

selections:labels lines:separatingLineIndices
    ^ (self labels:labels lines:separatingLineIndices values:labels)
! !

!SelectionMenu methodsFor:'menu opening'!

startUpWithCaption:title
    ^ self startUpWithHeading:title
! !

!SelectionMenu class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/SelectionMenu.st,v 1.3 2017-01-28 00:01:33 cg Exp $'
! !

