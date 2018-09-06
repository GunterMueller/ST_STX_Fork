"{ Package: 'stx:libcompat' }"

"{ NameSpace: Squeak }"

Object subclass:#TextFontChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!TextFontChange class methodsFor:'documentation'!

documentation
"
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
    ^ '$Header: /cvs/stx/stx/libcompat/SQ_TextFontChange.st,v 1.1 2003-05-19 19:48:11 cg Exp $'
! !
