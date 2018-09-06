"{ Package: 'stx:libdb/nosql/sandstoneDb/tests' }"

SDActiveRecordTests subclass:#SDMemoryStoreTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Tests'
!


!SDMemoryStoreTests class methodsFor:'testing'!

isAbstract
	^ false
! !

!SDMemoryStoreTests methodsFor:'defaults'!

defaultStore
	^ SDMemoryStore new
!

testWarmUpInitializesCorrectDictionaries

	self manClass new save.
	self childClass warmUp.
	self assert: (self childClass findAll allSatisfy: [ :c | c class == self childClass ]).
! !

!SDMemoryStoreTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/tests/SDMemoryStoreTests.st,v 1.4 2013-04-17 23:47:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/tests/SDMemoryStoreTests.st,v 1.4 2013-04-17 23:47:36 cg Exp $'
! !

