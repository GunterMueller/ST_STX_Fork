"{ Package: 'stx:libcompat' }"

"{ NameSpace: Squeak }"

Object subclass:#TextColor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!TextColor class methodsFor:'documentation'!

documentation
"
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
    ^ '$Header: /cvs/stx/stx/libcompat/SQ_TextColor.st,v 1.1 2003-05-19 19:47:58 cg Exp $'
! !
