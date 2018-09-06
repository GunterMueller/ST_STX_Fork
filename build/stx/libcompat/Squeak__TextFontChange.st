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

"{ NameSpace: Squeak }"

Object subclass:#TextFontChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!TextFontChange class methodsFor:'documentation'!

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

!TextFontChange methodsFor:'as yet unclassified'!

printHtmlCloseTagOn: strm
	strm
		nextPutAll: '</FONT>'
!

printHtmlOpenTagOn: strm
	strm
		nextPutAll: '<FONT SIZE="';
		nextPutAll: (self fontNumber + 2) asString;
		nextPutAll: '">'
! !

!TextFontChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Squeak__TextFontChange.st,v 1.4 2017-01-28 00:00:22 cg Exp $'
!

version_SVN
    ^ '$Id: Squeak__TextFontChange.st,v 1.4 2017-01-28 00:00:22 cg Exp $'
! !

