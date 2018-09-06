"{ Package: 'stx:libdb/nosql/goods' }"

ProtoObject subclass:#KKObjectProxy
	instanceVariableNames:'key value database'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Database'
!

KKObjectProxy comment:''
!


!KKObjectProxy class methodsFor:'as yet unclassified'!

database: aDatabase key: key
	^ self basicNew
		xxxDatabase: aDatabase;
		xxxKey: key
! !

!KKObjectProxy methodsFor:'accessing'!

xxxDatabase
	^database
!

xxxKey
	^ key
! !

!KKObjectProxy methodsFor:'as yet unclassified'!

goodsIsImmediateValue
	^ false
!

xxxDatabase: aDatabase
	database := aDatabase
!

xxxKey: oid
	key := oid
!

xxxObject
	value ifNil: [^value := database at: key "forProxy: self...not quite ready for become: yet"].
	^ value
! !

!KKObjectProxy methodsFor:'system primitives'!

doesNotUnderstand: aMessage
	^ self xxxObject perform: aMessage selector withArguments: aMessage arguments
! !

!KKObjectProxy methodsFor:'testing'!

isInMemory
	^ value notNil
!

isMorph
	"satisfy CommandHistory"
	^ false
!

xxxIsProxy

	^true
! !

!KKObjectProxy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKObjectProxy.st,v 1.3 2013-03-31 12:03:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKObjectProxy.st,v 1.3 2013-03-31 12:03:02 cg Exp $'
! !

