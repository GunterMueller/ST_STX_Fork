"{ Package: 'stx:goodies/monticello/test' }"

MCRepositoryTest subclass:#MCDirectoryRepositoryTest
	instanceVariableNames:'directory'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCDirectoryRepositoryTest methodsFor:'as yet unclassified'!

addVersion: aVersion
	| file |
	file _ FileStream newFileNamed: (directory fullNameFor: aVersion fileName).
	aVersion fileOutOn: file.
	file close.
!

directory
	directory ifNil:
		[directory _ FileDirectory default directoryNamed: 'mctest'.
		directory assureExistence].
	^ directory
!

setUp
	repository _ MCDirectoryRepository new directory: self directory
!

tearDown
	self directory recursiveDelete
! !

!MCDirectoryRepositoryTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCDirectoryRepositoryTest.st,v 1.2 2013-05-29 00:00:31 vrany Exp $'
! !

