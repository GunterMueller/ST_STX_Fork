"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPContext
	instanceVariableNames:'stream root properties globals furthestFailure'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Core'
!

!PPContext class methodsFor:'as yet unclassified'!

on: aPPParser stream: aStream
	^ self basicNew 
		initialize;
		root: aPPParser;
		stream: aStream asPetitStream;
		yourself
! !

!PPContext methodsFor:'accessing-globals'!

globalAt: aKey
	"Answer the global property value associated with aKey."
	
	^ self globalAt: aKey ifAbsent: [ self error: 'Property not found' ]
!

globalAt: aKey ifAbsent: aBlock
	"Answer the global property value associated with aKey or, if aKey isn't found, answer the result of evaluating aBlock."
	
	^ globals isNil
		ifTrue: [ aBlock value ]
		ifFalse: [ globals at: aKey ifAbsent: aBlock ]
!

globalAt: aKey ifAbsentPut: aBlock
	"Answer the global property associated with aKey or, if aKey isn't found store the result of evaluating aBlock as new value."
	
	^ self globalAt: aKey ifAbsent: [ self globalAt: aKey put: aBlock value ]
!

globalAt: aKey put: anObject
	"Set the global property at aKey to be anObject. If aKey is not found, create a new entry for aKey and set is value to anObject. Answer anObject."

	^ (globals ifNil: [ globals := Dictionary new: 1 ])
		at: aKey put: anObject
!

hasGlobal: aKey
	"Test if the global property aKey is present."
	
	^ globals notNil and: [ globals includesKey: aKey ]
!

removeGlobal: aKey
	"Remove the property with aKey. Answer the property or raise an error if aKey isn't found."
	
	^ self removeGlobal: aKey ifAbsent: [ self error: 'Property not found' ]
!

removeGlobal: aKey ifAbsent: aBlock
	"Remove the global property with aKey. Answer the value or, if aKey isn't found, answer the result of evaluating aBlock."
	
	| answer |
	globals isNil ifTrue: [ ^ aBlock value ].
	answer := globals removeKey: aKey ifAbsent: aBlock.
	globals isEmpty ifTrue: [ globals := nil ].
	^ answer
! !

!PPContext methodsFor:'accessing-properties'!

hasProperty: aKey
	"Test if the property aKey is present."
	
	^ properties notNil and: [ properties includesKey: aKey ]
!

propertyAt: aKey
	"Answer the property value associated with aKey."
	
	^ self propertyAt: aKey ifAbsent: [ self error: 'Property not found' ]
!

propertyAt: aKey ifAbsent: aBlock
	"Answer the property value associated with aKey or, if aKey isn't found, answer the result of evaluating aBlock."
	
	^ properties isNil
		ifTrue: [ aBlock value ]
		ifFalse: [ properties at: aKey ifAbsent: aBlock ]
!

propertyAt: aKey ifAbsentPut: aBlock
	"Answer the property associated with aKey or, if aKey isn't found store the result of evaluating aBlock as new value."
	
	^ self propertyAt: aKey ifAbsent: [ self propertyAt: aKey put: aBlock value ]
!

propertyAt: aKey put: anObject
	"Set the property at aKey to be anObject. If aKey is not found, create a new entry for aKey and set is value to anObject. Answer anObject."

	^ (properties ifNil: [ properties := Dictionary new: 1 ])
		at: aKey put: anObject
!

removeProperty: aKey
	"Remove the property with aKey. Answer the property or raise an error if aKey isn't found."
	
	^ self removeProperty: aKey ifAbsent: [ self error: 'Property not found' ]
!

removeProperty: aKey ifAbsent: aBlock
	"Remove the property with aKey. Answer the value or, if aKey isn't found, answer the result of evaluating aBlock."
	
	| answer |
	properties isNil ifTrue: [ ^ aBlock value ].
	answer := properties removeKey: aKey ifAbsent: aBlock.
	properties isEmpty ifTrue: [ properties := nil ].
	^ answer
! !

!PPContext methodsFor:'acessing'!

root
	^ root 
!

stream
	^ stream
!

stream: aStream
	stream := aStream.
! !

!PPContext methodsFor:'failures'!

furthestFailure
	" the furthest failure encountered while parsing the input stream "
	
	"^ self globalAt: #furthestFailure ifAbsent: [ nil ]"
	"performance optimization:"
	^ furthestFailure
!

noteFailure: aPPFailure
	"record the furthest failure encountered while parsing the input stream "

	( furthestFailure isNil or: [ aPPFailure position > furthestFailure position ]) 
		ifTrue: [ furthestFailure := aPPFailure ].
! !

!PPContext methodsFor:'initialization'!

initialize
	stream := nil.
!

initializeFor: parser
	parser == root ifTrue: [ ^ self ].
	
	root := parser.
	root allParsersDo: [ :p | 
		p updateContext: self
	]
! !

!PPContext methodsFor:'memoization'!

remember
	| memento |
	memento := PPContextMemento new
		stream: stream;
		position: stream position;
		yourself.
		
	self rememberProperties: memento.
	^ memento
!

rememberProperties: aPPContextMemento
	properties ifNil: [ ^ self ].
	
	properties keysAndValuesDo: [ :key :value |
		aPPContextMemento propertyAt: key put: value
	].
!

restore: aPPContextMemento
	aPPContextMemento stream == stream ifFalse: [ self error: 'Oops!!' ].

	stream position: aPPContextMemento position.
	self restoreProperties: aPPContextMemento.
!

restoreProperties: aPPContextMemento
	aPPContextMemento stream == stream ifFalse: [ self error: 'Oops!!' ].
	
	properties ifNil: [ ^ self ].
	
	properties keysDo: [ :key |
		(aPPContextMemento hasProperty: key)
			ifTrue: [ properties at: key put: (aPPContextMemento propertyAt: key) ]
			ifFalse: [ properties removeKey: key  ]. 
	].

	aPPContextMemento keysAndValuesDo: [ :key :value |
		properties at: key put: value
	]
! !

!PPContext methodsFor:'printing'!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $:.
	aStream nextPut: $ .
	stream printOn: aStream
! !

!PPContext methodsFor:'stream mimicry'!

atEnd
	^ stream atEnd
!

back
	^ stream back
!

collection
	^ stream collection  
!

contents 
	^ stream contents
!

isEndOfLine
	^ stream isEndOfLine
!

isStartOfLine
	^ stream isStartOfLine
!

next
	^ stream next
!

next: anInteger
	^ stream next: anInteger
!

peek
	^ stream peek
!

peekTwice
	^ stream peekTwice
!

position
	^ stream position
!

position: anInteger
	^ stream position: anInteger
!

skip: anInteger 
	^ stream skip: anInteger 
!

skipTo: anObject 
	^ stream skipTo: anObject 
!

skipToAll: aString
	"Set the access position of the receiver to be past the next occurrence of the subCollection. Answer whether subCollection is found.  No wildcards, and case does matter."
	| pattern startMatch |
	pattern := aString readStream.
	startMatch := nil.
	[ pattern atEnd ] whileFalse: 
		[ stream atEnd ifTrue: [ ^ false ].
		stream next = pattern next 
			ifTrue: [ pattern position = 1 ifTrue: [ startMatch := stream position ] ]
			ifFalse: 
				[ pattern position: 0.
				startMatch ifNotNil: 
					[ stream position: startMatch.
					startMatch := nil ] ] ].
	^ true
!

skipToAnyOf: aCharacterSet 
	"Set the access position of the receiver to be past the next occurrence of
	a character in the character set. Answer whether a fitting character is found."

	[stream atEnd]
		whileFalse: [ (aCharacterSet includes: stream next) ifTrue: [^true]].
	^false
!

uncheckedPeek
	^ stream uncheckedPeek
!

upTo: anObject
	^ stream upTo: anObject
!

upToAll: whatever
	^ stream upToAll: whatever
!

upToAnyOf: whatever
	^ stream upToAnyOf: whatever
! !

