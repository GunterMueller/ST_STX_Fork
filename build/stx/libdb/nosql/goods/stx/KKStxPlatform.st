"{ Package: 'stx:libdb/nosql/goods/stx' }"

KKPlatform subclass:#KKStxPlatform
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Platform-Stx'
!


!KKStxPlatform class methodsFor:'class initialization'!

initialize

	"self initialize"
	KKPlatform default: self new
! !

!KKStxPlatform methodsFor:'factories'!

integerDictionary

	^ Dictionary new
"/        ^PluggableDictionary integerDictionary
!

weakIdentityKeyDictionary
	^ WeakIdentityDictionary new.
	"/ ^WeakIdentityKeyDictionary new
! !

!KKStxPlatform methodsFor:'special objects'!

addPlatformSpecialObjectsTo: specialObjects

	specialObjects
		at: ActiveWorld
		put: -2
! !

!KKStxPlatform class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/stx/KKStxPlatform.st,v 1.3 2013-03-28 10:38:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/stx/KKStxPlatform.st,v 1.3 2013-03-28 10:38:50 cg Exp $'
! !


KKStxPlatform initialize!
