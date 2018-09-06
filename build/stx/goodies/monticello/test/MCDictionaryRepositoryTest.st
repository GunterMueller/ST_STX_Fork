"{ Package: 'stx:goodies/monticello/test' }"

MCRepositoryTest subclass:#MCDictionaryRepositoryTest
	instanceVariableNames:'dict'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCDictionaryRepositoryTest methodsFor:'as yet unclassified'!

addVersion: aVersion
	dict at: aVersion info put: aVersion
!

deleteNode: aNode
	dict removeKey: aNode
!

dictionary
	^ dict ifNil: [dict _ Dictionary new]
!

setUp
	repository _  MCDictionaryRepository new dictionary: self dictionary
! !

!MCDictionaryRepositoryTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCDictionaryRepositoryTest.st,v 1.2 2013-05-29 00:02:26 vrany Exp $'
! !

