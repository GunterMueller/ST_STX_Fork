"{ Package: 'stx:libcompat' }"

"{ NameSpace: Squeak }"

Object subclass:#TextURL
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!TextURL class methodsFor:'documentation'!

documentation
"
    This is a dummy, mimicry class to allow some squeak code to be filed in.
    Its protocol is neither complete, nor fully compatible with the corresponding
    squeak original class.
"
! !

!TextURL methodsFor:'as yet unclassified'!

printHtmlCloseTagOn: strm
	strm
		nextPutAll: '</A>'
!

printHtmlOpenTagOn: strm
	strm
		nextPutAll: '<A HREF="';
		nextPutAll: self info;
		nextPutAll: '">'
! !

!TextURL class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/SQ_TextURL.st,v 1.1 2003-05-19 19:47:45 cg Exp $'
! !
