"{ Package: 'stx:libcompat' }"

"{ NameSpace: Squeak }"

Object subclass:#TextAnchor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!TextAnchor class methodsFor:'documentation'!

documentation
"
    This is a dummy, mimicry class to allow some squeak code to be filed in.
    Its protocol is neither complete, nor fully compatible with the corresponding
    squeak original class.
"
! !

!TextAnchor methodsFor:'as yet unclassified'!

printHtmlOpenTagOn: strm
	"do nothing for now"
	"save the embedded image in a file to be served by Comanche"
! !

!TextAnchor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/SQ_TextAnchor.st,v 1.1 2003-05-19 19:47:20 cg Exp $'
! !
