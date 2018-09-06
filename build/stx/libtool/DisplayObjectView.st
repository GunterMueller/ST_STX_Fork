"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

View subclass:#DisplayObjectView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!


!DisplayObjectView methodsFor:'drawing'!

redraw
    model displayOn:self x:0 y:(model ascentOn:self)
! !

!DisplayObjectView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

