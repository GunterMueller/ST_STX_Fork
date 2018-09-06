"{ Package: 'stx:libcompat' }"

"{ NameSpace: Squeak }"

Object subclass:#TextEmphasis
	instanceVariableNames:'emphasisCode'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!TextEmphasis class methodsFor:'documentation'!

documentation
"
    This is a dummy, mimicry class to allow some squeak code to be filed in.
    Its protocol is neither complete, nor fully compatible with the corresponding
    squeak original class.
"
! !

!TextEmphasis methodsFor:'as yet unclassified'!

printHtmlCloseTagOn: strm
        emphasisCode = 1 ifTrue: [strm nextPutAll: '</B>'].
        emphasisCode = 2 ifTrue: [strm nextPutAll: '</I>'].
        emphasisCode = 4 ifTrue: [strm nextPutAll: '</U>'].
        emphasisCode = 16 ifTrue: [strm nextPutAll: '</S>']
!

printHtmlOpenTagOn: strm
	emphasisCode = 1 ifTrue: [strm nextPutAll: '<B>'].
	emphasisCode = 2 ifTrue: [strm nextPutAll: '<I>'].
	emphasisCode = 4 ifTrue: [strm nextPutAll: '<U>'].
	emphasisCode = 16 ifTrue: [strm nextPutAll: '<S>']
! !

!TextEmphasis class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/SQ_TextEmphasis.st,v 1.2 2008-03-02 20:09:40 stefan Exp $'
! !
