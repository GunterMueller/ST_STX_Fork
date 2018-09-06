"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXBaseResult subclass:#DBXMultiStatementResultSetIterator
	instanceVariableNames:'open lastResult'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Structure'
!


!DBXMultiStatementResultSetIterator class methodsFor:'instance creation'!

new
	self error: 'Use #on:querySettings:'
!

on: aConnection querySettings: aQuerySettings
	^(self basicNew)
		initializeConnection: aConnection 
			querySettings: aQuerySettings;
		yourself.
! !

!DBXMultiStatementResultSetIterator methodsFor:'accessing'!

lastResult
	^ lastResult
!

lastResult: anObject 
	lastResult := anObject
! !

!DBXMultiStatementResultSetIterator methodsFor:'enumerating'!

allResultsDo: aBlock
	"For each result it evaluates the block"
	| result |
	[ result := self next.
	  result notNil ] 
	whileTrue: [ aBlock value: result ]
! !

!DBXMultiStatementResultSetIterator methodsFor:'finalize'!

finalize
	self isOpen ifTrue: [ self finalizeResults ]
!

finalizeResults
	"It will release all the results of the multistatment query"
	| result |
	self isOpen
		ifTrue: [[ result := self next.
	  			result notNil ] 
			whileTrue: [ result finalize ].
			self internalBeClosed]
! !

!DBXMultiStatementResultSetIterator methodsFor:'initialize'!

initializeConnection: aConnection querySettings: aQuerySettings
	super initialize.
	connection := aConnection.
	querySettings := aQuerySettings.
	open := ValueHolder new contents: false.
	self internalBeOpen.
! !

!DBXMultiStatementResultSetIterator methodsFor:'private'!

internalBeClosed
	open contents: false
!

internalBeOpen
	open contents: true
! !

!DBXMultiStatementResultSetIterator methodsFor:'processing'!

next
	"Obtains the next DBXBaseResult of the multistatement query"
	lastResult ifNotNil: [ 
		"I must finalize the previous result (if there is) before processing the next one"
		lastResult finalize ].
	lastResult := self connection processNextResultSetMultiStatement: self querySettings.
	^ lastResult
! !

!DBXMultiStatementResultSetIterator methodsFor:'release'!

releaseResult
	"It will release all the results of the multistatment query"
	| result |
	self isOpen
		ifTrue: [[ result := self next.
	  			result notNil ] 
			whileTrue: [ result releaseResult ].
			self internalBeClosed]
! !

!DBXMultiStatementResultSetIterator methodsFor:'testing'!

isDBXMultiStatementResultSetIterator
	^ true
!

isOpen
	"Returns if the DBXMultiStatementResultSetIterator is open or not."
	^open contents
! !

!DBXMultiStatementResultSetIterator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXMultiStatementResultSetIterator.st,v 1.2 2013-04-15 13:11:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXMultiStatementResultSetIterator.st,v 1.2 2013-04-15 13:11:36 cg Exp $'
! !

