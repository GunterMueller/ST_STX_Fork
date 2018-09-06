"
 COPYRIGHT (c) 2014 by eXept Software AG
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

FontDescription subclass:#TTFontDescription
	instanceVariableNames:'kernPairs'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

Object subclass:#TTKernPair
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TTFontDescription
!

!TTFontDescription class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by eXept Software AG
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

!TTFontDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/TTFontDescription.st,v 1.4 2017-01-28 00:01:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/TTFontDescription.st,v 1.4 2017-01-28 00:01:46 cg Exp $'
! !

