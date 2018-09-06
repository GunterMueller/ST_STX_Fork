'From Smalltalk/X, Version:7.1.0.0 on 07-05-2018 at 10:00:58 PM'                !

"{ Package: 'stx:goodies/communication/messagePack/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#MpTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePackTest-Core'
!

!MpTestCase methodsFor:'private'!

atRandom: integer
	"For portability"
	^ (MpPortableUtil default randomClass new next * integer) truncated + 1
!

collectionEquals: aCollection with: otherCollection
	^MpPortableUtil default collectionEquals: aCollection with: otherCollection
!

newCollection: aCollectionClass sized: size withAll: elem
	^MpPortableUtil default newCollection: aCollectionClass sized: size withAll: elem
! !

