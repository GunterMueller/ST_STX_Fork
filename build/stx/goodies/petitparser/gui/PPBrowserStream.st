"{ Package: 'stx:goodies/petitparser/gui' }"

PPStream subclass:#PPBrowserStream
	instanceVariableNames:'positions stamps parsers'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Core'
!


!PPBrowserStream methodsFor:'accessing'!

next
	| result |
	result := super next.
	self step.
	^ result
!

next: aNumber
	| result |
	result := super next: aNumber.
	self step.
	^ result
! !

!PPBrowserStream methodsFor:'converting'!

asExecutionTrace
	| trace |
	trace := OrderedCollection new: parsers size.
	1 to: parsers size do: [ :index |
		| parser |
		parser := parsers at: index.
		parser name isNil ifFalse: [
			| start stop |
			start := positions at: index.
			stop := positions at: index + 1 ifAbsent: [ self size ].
			trace addLast: (Array with: parser with: start with: stop) ] ].
	^ trace
!

asFrequencyTable
	| bag total result |
	bag := parsers asBag.
	total := 100.0 / bag size.
	result := OrderedCollection new.
	bag sortedCounts 
		do: [ :each | result addLast: (Array with: each value with: each key with: total * each key) ].
	^ result
!

asPositionDrawing
	| stream source last |
	stream := WriteStream on: String new.
	source := self contents readStream.
	last := 0.
	[ source atEnd ] whileFalse: [
		[ source atEnd not and: [ source peek isSeparator ] ]
			whileTrue: [ source next ].
		stream nextPutAll: '\fill [source] ('; print: source position / 100.0; nextPutAll: ', 0) rectangle ('.
		[ source atEnd not and: [ source peek isSeparator not ] ]
			whileTrue: [ source next ].
		stream print: source position / 100.0; nextPutAll: ', '; print: self positions size / 100.0; nextPutAll: ');'; cr ].
	stream nextPutAll: '\draw [parser] (0, 0)'.
	1 to: self positions size do: [ :index |
		last <= (self positions at: index)
			ifTrue: [ stream nextPutAll: ' --' ].
		last := self positions at: index.
		stream nextPutAll: ' ('; print: last / 100.0; nextPutAll: ', '; print: index / 100.0; nextPut: $) ].
	stream nextPut: $;.
	^ stream contents
!

asPositionMorph
	| width height canvas morph |
	width := self size + 1 min: 2048.
	height := self positions size min: 2048.
	canvas := FormCanvas extent: width @ height.
	self contents keysAndValuesDo: [ :index :char |
		char isSeparator 
			ifFalse: [ canvas line: index @ 1 to: index @ height color: Color paleBlue ] ].
	1 to: height do: [ :index |
		canvas form colorAt: (self positions at: index) @ index put: Color black ].
	morph := canvas form asMorph.
	morph 
		on: #mouseDown
		send: #mouseDown:with:
		to: self.
	^ morph
!

asTimingTable
	| bag total result |
	bag := Bag new.
	1 to: stamps size - 1 do: [ :index |
		bag
			add: (parsers at: index) 
			withOccurrences: (stamps at: index + 1) - (stamps at: index) ].
	total := stamps last - stamps first.
	result := OrderedCollection new.
	bag sortedCounts
		do: [ :each | result addLast: (Array with: each value with: each key with: total * each key) ].
	^ result
! !

!PPBrowserStream methodsFor:'information'!

parsers
	^ parsers
!

positions
	^ positions
!

stamps
	^ stamps
! !

!PPBrowserStream methodsFor:'positioning'!

position: aNumber
	super position: aNumber.
	self step
!

reset
	super reset.
	positions := OrderedCollection new: 1024.
	stamps := OrderedCollection new: 1024.
	parsers := OrderedCollection new: 1024
! !

!PPBrowserStream methodsFor:'private'!

mouseDown: anEvent with: aMorph
	| location string parser |
	location := anEvent position.
	string := collection 
		copyFrom: (location x - 5 min: collection size max: 1) asInteger
		to: (location x + 5 min: collection size max: 1) asInteger.
	parser := parsers at: location y
!

step
	positions addLast: position.
	stamps addLast: Time millisecondClockValue.
	parsers addLast: thisContext sender sender receiver
! !

!PPBrowserStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPBrowserStream.st,v 1.1 2014-03-04 21:14:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPBrowserStream.st,v 1.1 2014-03-04 21:14:15 cg Exp $'
! !

