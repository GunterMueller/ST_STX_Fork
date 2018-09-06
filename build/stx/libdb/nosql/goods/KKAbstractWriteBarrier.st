"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKAbstractWriteBarrier
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-WriteBarrier'
!

KKAbstractWriteBarrier comment:'I define the API for write barrier implementations.  You can (obivously) subclass or duck-type me.'
!


!KKAbstractWriteBarrier class methodsFor:'instance creation'!

new
	"Answer a newly created and initialized instance."

	^self basicNew initialize
! !

!KKAbstractWriteBarrier methodsFor:'api'!

add: anObject
	"Begin tracking anObject for modifications.  Do not keep a strong reference to anObject!!"
!

clearDirtySet
	"Mark all objects as clean"
!

database: aDatabase
	"Tell the write barrier about the database.  All write barriers must notify the database the first an object is modified (once for each modified object) using the KKDatabase>>objectChanged: message."
!

dirtySet
	"Answer list of dirty objects"
	self subclassResponsibility
!

isAuthoritative
	"Answer true if this write barrier can determine dirty objects authoritatively.  The only class that should answer false here is the 'non-write barrier'"

	^true
!

keyCache: aKeyCache
!

markClean: anObject
	"remove anObject from our list of dirty objects."

!

modified: anObject
	"anObject has been 'manually' marked as dirty.  Subsequent calls to dirtSet should include anObject in the response."
! !

!KKAbstractWriteBarrier methodsFor:'initialize-release'!

initialize
	"Initialize a newly created instance. This method must answer the receiver."

	^self
! !

!KKAbstractWriteBarrier class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKAbstractWriteBarrier.st,v 1.3 2013-03-31 12:05:53 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKAbstractWriteBarrier.st,v 1.3 2013-03-31 12:05:53 cg Exp $'
! !

