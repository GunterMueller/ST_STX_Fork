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

Object subclass:#TextColor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!TextColor class methodsFor:'documentation'!

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

!TextColor methodsFor:'printing'!

printHtmlCloseTagOn: strm
	strm
		nextPutAll: '</FONT>'
!

printHtmlOpenTagOn: strm
	strm
		nextPutAll: '<FONT COLOR="#';
		nextPutAll: self color hex;
		nextPutAll: '">'
! !

!TextColor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Squeak__TextColor.st,v 1.5 2017-03-02 09:34:37 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/Squeak__TextColor.st,v 1.5 2017-03-02 09:34:37 mawalch Exp $'
!

version_SVN
    ^ '$Id: Squeak__TextColor.st,v 1.5 2017-03-02 09:34:37 mawalch Exp $'
! !

