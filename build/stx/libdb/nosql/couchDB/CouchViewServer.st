"{ Package: 'stx:libdb/nosql/couchDB' }"

Object subclass:#CouchViewServer
	instanceVariableNames:'functions stream'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-CouchDB-Viewserver'
!


!CouchViewServer methodsFor:'commands'!

addFunction: aString
	"Compile aString as a Block with self
	being a CouchViewServerFunction instance."

	functions add: (self compile: aString).
	^true
!

mapDocument: document
	"We run all functions with the document as argument.
	Each function can emit 0..n key-value pairs which means
	that we in the end return an Array of Arrays of key-value pairs.
	Any execution errors that are not explicitly thrown are logged."

	^functions collect: [:block |
		[block value: document]
			on: Exception do: [:ex |
				(ex isKindOf: CouchViewServerError)
					ifTrue: [ex pass]
					ifFalse: [self log: 'Error in function: ', ex messageText, ' for doc._id: ', (document at: '_id')]].
		block receiver emits]
!

reduce: funcs mapResults: array

	| keys values |
	keys := Array new: array size.
	values := Array new: array size.
	array withIndexDo: [:each :i |
		keys at: i put: each first.
		values at: i put: each second].
	^Array with: true with: (self reduce: (funcs collect: [:f | self compile: f]) keys: keys values: values rereduce: false)
!

rereduce: reduceFunctions mapResults: array

	^Array with: true with: (self reduce: reduceFunctions keys: nil values: array rereduce: true)
!

reset
	"Just clear out functions. GC is not needed in Squeak."

	functions := OrderedCollection new.
	^true
! !

!CouchViewServer methodsFor:'commands-private'!

reduce: funcs keys: keys values: values rereduce: rereduce

	^funcs collect: [:func |
		[func numArgs = 3
				ifTrue: [func value: keys value: values value: rereduce]
				ifFalse: [func numArgs = 2
							ifTrue: [func value: keys value: values]
							ifFalse: [func value: values]]]
			on: Exception do: [:ex |
				(ex isKindOf: CouchViewServerError)
					ifTrue: [ex pass]
					ifFalse: [self log: 'Error in reduce function: ', ex messageText.
						nil]]]
! !

!CouchViewServer methodsFor:'compiler support'!

notify: error at: location in: source
	"Open a syntax error view, inserting the given error message into the given source at the given location. This message is sent to the 'requestor' when the parser or compiler finds a syntax error."

	| aString |
	aString :=
		source contents
			copyReplaceFrom: location
			to: location - 1
			with: error.
	Error new signal: aString
!

select
!

selectFrom: aPos to: anotherPos
!

selectionInterval
	^ 1 to: 1
!

text
	^ Text fromString: ''
! !

!CouchViewServer methodsFor:'initialize-release'!

initialize

	functions := OrderedCollection new
! !

!CouchViewServer methodsFor:'private'!

command: aString
	"Parse input as JSON. Expect an array and use
	first element as name of command and second element as argument.
	The commands should return objects that implement #jsonWriteOn:"

	| json |
	[json := Json readFrom: aString readStream.
	Transcript show: json asString; cr; show: '----------------------------------------------';cr.
	(json first = 'reset') ifTrue: [^self reset].
	(json first = 'add_fun') ifTrue: [^self addFunction: json second].
	(json first = 'map_doc') ifTrue: [^self mapDocument: json second].
	(json first = 'reduce') ifTrue: [^self reduce: json second mapResults: json third].
	(json first = 'rereduce') ifTrue: [^self rereduce: json second mapResults: json third]]
		on: CouchViewServerError do: [:ex |
			^ex].

!

compile: aString
	"We compile functions as blocks with an instance
	of CouchViewServerFunction as self."

	[^Compiler new
				evaluate: aString
				in: nil
				to: (CouchViewServerFunction server: self)
				notifying: self
				ifFail: [^nil]
				logged: false]
		on: Error do: [:ex |
			CouchViewServerCompilationError signal: ex messageText]
!

handle: aSocketStream

	| result |
	stream := aSocketStream.
	[[result := self command: stream nextLineLf.
	Transcript show: result asString; cr.
	result jsonWriteOn: stream.
	stream nextPut: Character lf; flush]
		on: ConnectionClosed do: [:ex | ^true "breaks out"]] repeat
!

log: object

	stream nextPutAll: '{"log":', object asJsonString , '}'
! !

!CouchViewServer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/CouchViewServer.st,v 1.2 2013-04-17 18:44:57 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/CouchViewServer.st,v 1.2 2013-04-17 18:44:57 cg Exp $'
! !

