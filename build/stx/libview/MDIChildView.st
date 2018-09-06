"{ Package: 'stx:libview' }"

TopView subclass:#MDIChildView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Basic'
!


!MDIChildView methodsFor:'queries'!

windowType
    "return a symbol describing my type (one of: #mdichild or nil)"

    ^ #mdichild
! !

!MDIChildView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview/MDIChildView.st,v 1.1 2006-02-24 11:27:01 cg Exp $'
! !

