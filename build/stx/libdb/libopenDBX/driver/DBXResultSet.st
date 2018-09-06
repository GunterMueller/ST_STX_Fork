"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXBaseResult subclass:#DBXResultSet
	instanceVariableNames:'open'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Structure'
!


!DBXResultSet class methodsFor:'instance creation'!

new
	self error: 'Use #on:handle:description:querySettings:'
!

on: aConnection handle: aNumber description: aDescription querySettings: aQuerySettings
	^(self basicNew)
		initializeConnection: aConnection 
			handle: aNumber
			description: aDescription
			querySettings: aQuerySettings;
		yourself.
! !

!DBXResultSet methodsFor:'accessing'!

columnCount
	"Returns the number of columns affected in the query. It will be the number of columns you specify in the select statement"
	^self description columnCount
!

columnDescriptionAt: anIndex
	"Returns the column description at that index.
	IMPORTANT: The index starts in 1."
	|desc|
	desc:=self description columnDescriptionAt: anIndex.
	desc type isBehavior
	ifTrue:[ ^ desc ]
	ifFalse:[
		^ self platform descriptionForColumn: (anIndex-1) handle: self handle on: self connection
	]
!

columnDescriptionWithName: aName 
	"Returns the column description with that name. If a column with that name was not in select statement a DBXError will be thrown"
	^ [self columnDescriptions
		detect: [:each | each name sameAs: aName]]
		on: Error
		do: [OpenDBXDriverError signal: 'A column with that name was not found' ]
!

columnDescriptions
	"Returns the column description of ALL the affected columns"
	^self description columnDescriptions
!

dataTypeAt: aInteger
	 ^ self platform dataTypeAt: aInteger
!

nextRow
	"it returns the next row of the resultSet. If there is no more row, it returns nil. 
	
	VERY IMPORTANT THINGS:

    * After doing a select query you should call nextRow till it returns nil. If you don't do this, you will get a segmentation fault in your next query. You have to do this no matter which number of rows you have got. Suppose you are looking for some record and you find it in the second one. The number of rows is 10. In this case, you should call nextRow 10 times, no matter you found the record in the second one. This limitation is in the database client library. We assume that someone has to do this (retrieve all results before execute another query): openDBX, database client library, OpenDBXDriver or OpenDBXDriver user. So, we decided OpenDBXDriver should do this. The other approach was the OpenDBXDriver user should do it and if it doesn't do it, OpenDBXDriver throws an error. In conclusion, you DON'T need to call nextRow till nil its returned, the framework will do it for you in your next query.
    * Some queries return more than one resultSet. This situation will be transparent for OpenDBXDriver user. nextRow will automatically obtain next resultSet when needed. 

"
	| row |
	self isOpen
		ifFalse: [ OpenDBXDriverError signal: 'The resultSet must be open to obtain the next row but it is closed' ].
	row := self platform moveNext: self.
	^ row
!

rows
	"It returns in an OrderedCollection, ALL the rows of all the resultSets of a query"
	| results |
	results := OrderedCollection new.
	self rowsDo: [ :each| 
		results add: each ].
	^results
! !

!DBXResultSet methodsFor:'enumerating'!

allRowsDo: aBlock 
	"It will execute the block to each row from the collection. It is different from rowsDo: because allRowsDo, first obtain (query) all the rows and then iterates them and evaluates the block. On the other hand, rowsDo: goes row by row executing the block."
	| rows |
	rows := self rows.
	rows do: aBlock
!

rowsDo: aBlock
	"It will execute the block to each row"
	| row |
	[ row := self nextRow.
	  row notNil ] 
	whileTrue: [ aBlock value: row ]
! !

!DBXResultSet methodsFor:'finalization'!

finalize
	"Will finalize the DBXResultSet object"
	self isOpen ifTrue: [ self finalizeResultSet ]
!

finalizeResultSet
	"It will release resources and change internal state"
	self platform releaseResultSet: self.
	self internalBeClosed.
! !

!DBXResultSet methodsFor:'initialization'!

detectNewTypes
	self description detectNewTypes: self.
	 
!

initializeConnection: aConnection handle: aNumber description: aDescription querySettings: aQuerySettings 
	super
		initializeConnection: aConnection
		handle: aNumber
		description: aDescription
		querySettings: aQuerySettings.
	open := ValueHolder new contents: false.
	self internalBeOpen.
! !

!DBXResultSet methodsFor:'private'!

internalBeClosed
	open contents: false
!

internalBeOpen
	open contents: true
! !

!DBXResultSet methodsFor:'release'!

releaseResult
	"It will release all the resources of all the resultsSets associated with a query."
	self isOpen
		ifTrue: [self platform releaseAllQueryResultSets: self.
			self internalBeClosed]
! !

!DBXResultSet methodsFor:'testing'!

isOpen
	"Returns if the DBXResultSet is open or not."
	^open contents
!

isResultSet
	^ true
! !

!DBXResultSet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXResultSet.st,v 1.2 2013-04-15 13:10:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXResultSet.st,v 1.2 2013-04-15 13:10:01 cg Exp $'
! !

