"{ Package: 'stx:libdb/nosql/goods' }"

KKAbstractWriteBarrier subclass:#KKEmptyWriteBarrier
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-WriteBarrier'
!

KKEmptyWriteBarrier comment:'I am a write barrier for use in read-only sessions.  I always indicate that no objects were changed.'
!


!KKEmptyWriteBarrier methodsFor:'api'!

dirtySet
	^#()
! !

!KKEmptyWriteBarrier class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKEmptyWriteBarrier.st,v 1.3 2013-03-31 12:18:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKEmptyWriteBarrier.st,v 1.3 2013-03-31 12:18:37 cg Exp $'
! !

