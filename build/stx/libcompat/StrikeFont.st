"
 COPYRIGHT (c) 2011 by eXept Software AG
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

Object subclass:#StrikeFont
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!StrikeFont class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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

!StrikeFont class methodsFor:'instance creation'!

familyName:familyName size:size
    "/ mimicri

    ^ View defaultFont onDevice:Screen current
    "/ ^ (Font family:'Courier' size:size) onDevice:Screen current
! !

!StrikeFont class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/StrikeFont.st,v 1.6 2017-03-07 20:08:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/StrikeFont.st,v 1.6 2017-03-07 20:08:18 cg Exp $'
!

version_SVN
    ^ '$Id: StrikeFont.st,v 1.6 2017-03-07 20:08:18 cg Exp $'
! !

