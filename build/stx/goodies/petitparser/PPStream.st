"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

ReadStream subclass:#PPStream
	instanceVariableNames:'newlines'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Core'
!


!PPStream methodsFor:'accessing'!

collection
	"Answer the underlying collection."
	
	^ collection
!

next: anInteger 
	"Answer up to anInteger elements of my collection. Overridden for efficiency."

	| answer endPosition |
	endPosition := position + anInteger min: readLimit.
	answer := collection copyFrom: position + 1 to: endPosition.
	position := endPosition.
	^ answer
!

peek
	"An improved version of peek, that is slightly faster than the built in version."

	^ self atEnd ifFalse: [ collection at: position + 1 ]
!

position: anInteger
	"The receiver does not check for invalid arguments passed to this method, as it is solely used with valid indexes for backtracking."

	position := anInteger
!

size
	"
		The same implementation as a ReadStream. Implemented here for compatibility with Smalltalk/X
		that has different implementation in a ReadStream
	"
	^readLimit
!

uncheckedPeek
	"An unchecked version of peek that throws an error if we try to peek over the end of the stream, even faster than #peek."

	^ collection at: position + 1
! !

!PPStream methodsFor:'converting'!

asPetitStream
	^ self
! !

!PPStream methodsFor:'positioning'!

column: pos
	| nl |
	(pos = -1) ifTrue: [  ^ 0 ].
	(pos > readLimit) ifTrue: [ ^ self error: 'Out of limit' ].
	
	nl := self newlines.
	nl keysAndValuesDo: [ :index :value |
		(value > pos) ifTrue: [ ^ pos - (nl at: (index - 1)) + 1]
	].	

	^ pos - (nl at: (nl size )) + 1
!

fillNewlines
	| tmp line |
	newlines := OrderedCollection new.	
	
	tmp := position.
	line := 0.
	
	(0 to: readLimit) do: [:index |
		position := index.
		self isStartOfLine ifTrue: [ newlines add: position ]
	].
	position := tmp.
	newlines := newlines asArray.
	^ newlines
!

line: pos
	| nl |
	(pos = -1) ifTrue: [  ^ 0 ].
	(pos > readLimit) ifTrue: [ ^ self error: 'Out of limit' ].
	
	nl := self newlines.
	nl keysAndValuesDo: [ :index :value |
		(value > pos) ifTrue: [ ^ (index - 1)]
	].	

	^ nl size
!

newlines
	^ newlines ifNil: [ 
		newlines := self fillNewlines.
	]
! !

!PPStream methodsFor:'printing'!

printOn: aStream
	collection isString
		ifFalse: [ ^ super printOn: aStream ].
	aStream
		nextPutAll: (collection copyFrom: 1 to: position);
		nextPutAll: '·';
		nextPutAll: (collection copyFrom: position + 1 to: readLimit)
! !

!PPStream methodsFor:'queries'!

column
	^ self column: position.
!

insideCRLF
	(position < 1) ifTrue: [ ^ false ].
	
	^ (self peek = (Character codePoint: 10)) and: [ self peekBack = (Character codePoint: 13) ]
!

isEndOfLine
	self atEnd ifTrue: [ ^ true ].
	self insideCRLF ifTrue: [ ^ false ].
	^ (self peek = (Character codePoint: 13) or: [ self peek = (Character codePoint: 10)]).
!

isStartOfLine
	(position = 0) ifTrue: [ ^ true ].

	self insideCRLF ifTrue: [ ^ false ].
	
	^ (self peekBack = (Character codePoint: 13)) or: [ self peekBack = (Character codePoint: 10)].
!

line
	^ self line: position
! !

!PPStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPStream.st,v 1.4 2014-03-04 14:32:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPStream.st,v 1.4 2014-03-04 14:32:00 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPStream.st,v 1.4 2014-03-04 14:32:00 cg Exp $'
! !

