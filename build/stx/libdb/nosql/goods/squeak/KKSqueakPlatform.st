"{ Package: 'stx:libdb/nosql/goods/squeak' }"

KKPlatform subclass:#KKSqueakPlatform
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Platform-Squeak'
!


!KKSqueakPlatform class methodsFor:'class initialization'!

initialize

	"self initialize"
	KKPlatform default: self new
! !

!KKSqueakPlatform methodsFor:'factories'!

integerDictionary

	^PluggableDictionary integerDictionary
!

weakIdentityKeyDictionary

	^WeakIdentityKeyDictionary new
! !

!KKSqueakPlatform methodsFor:'special objects'!

addPlatformSpecialObjectsTo: specialObjects

	specialObjects
		at: ActiveWorld
		put: -2
! !

!KKSqueakPlatform class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/squeak/KKSqueakPlatform.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/squeak/KKSqueakPlatform.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
! !


KKSqueakPlatform initialize!
