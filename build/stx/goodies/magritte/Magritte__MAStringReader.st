"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAReader subclass:#MAStringReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Visitor'
!


!MAStringReader methodsFor:'private'!

nextMatchAll: aCollection on: aStream
	"Tries to match ==aCollection== on ==aStream==. Answer ==true== if ==aCollection== was consumed, otherwise ==false==."

	| position |
	(aCollection isNil or: [ aCollection isEmpty ])
		ifTrue: [ ^ false ].
	position := aStream position.
	aCollection do: [ :char |
		(aStream atEnd or: [ aStream next ~= char ]) ifTrue: [
			aStream position: position.
			^ false ] ].
	^ true
! !

!MAStringReader methodsFor:'visiting'!

read: aStream description: aDescription
	(aStream atEnd or: [ self nextMatchAll: aDescription undefined on: aStream ])
		ifTrue: [ ^ nil ].
	^ super read: aStream description: aDescription
! !

!MAStringReader methodsFor:'visiting-description'!

visitBooleanDescription: aDescription
	(aDescription trueString = self contents
		or: [ aDescription trueStrings includes: self contents ])
			ifTrue: [ ^ self object: true ].
	(aDescription falseString = self contents
		or: [ aDescription falseStrings includes: self contents ])
			ifTrue: [ ^ self object: false ].
	MAReadError signal
!

visitClassDescription: aDescription
	self shouldNotImplement
!

visitColorDescription: aDescription
    |s clr|

    s := self contents.
    (s notEmpty and: [ s allSatisfy: [ :each | '#0123456789ABCDEFabcdef.' includes: each ] ]) ifFalse: [ 
        MAReadError signal 
    ].
    s first == $# ifTrue:[
        clr := aDescription kind rgbValue:(Integer readFrom:(s copyFrom:2) radix:16)   
    ] ifFalse:[
        clr := aDescription kind fromString: s
    ].
    self object: clr
!

visitContainer: anObject
	self shouldNotImplement
!

visitDurationDescription: aDescription
        | contents |
        contents := self contents.
Smalltalk isSmalltalkX ifFalse:[
        contents isEmpty
                ifTrue: [ MAReadError signal ].
        (contents occurrencesOf: $-) > 1
                ifTrue: [ MAReadError signal ].
        (contents indexOf: $-) > 1
                ifTrue: [ MAReadError signal ].
        (contents occurrencesOf: $.) > 1
                ifTrue: [ MAReadError signal ].
        (contents allSatisfy: [:each | '-0123456789.:' includes: each])
                ifFalse: [ MAReadError signal ].
].
        super visitDurationDescription: aDescription
!

visitElementDescription: aDescription
        "This implementation can be very dangerous and might lead to a potential security hole (this is tested), since the default implementation of #readFrom: in Object evaluates the expression to find its value. Most subclasses like Number, Date, Time, ... override this implementation, but some others (like Boolean) do not."

        self object: ([ aDescription kind readFrom: self stream ]
                on: Error do: [ :err | MAReadError signal: err messageText ])
!

visitFileDescription: aDescription
	self shouldNotImplement
!

visitMultipleOptionDescription: aDescription
	self object: (Array streamContents: [ :output |
		[ self stream atEnd ] whileFalse: [
			output nextPut: (aDescription reference
				fromString: (self stream upTo: $,)).
			self stream peek = Character space
				ifTrue: [ self stream next ] ] ])
!

visitNumberDescription: aDescription
	| contents |
	contents := self contents.
	contents isEmpty
		ifTrue: [ MAReadError signal ].
	(contents occurrencesOf: $-) > 1
		ifTrue: [ MAReadError signal ].
	(contents indexOf: $-) > 1
		ifTrue: [ MAReadError signal ].
	(contents occurrencesOf: $.) > 1
		ifTrue: [ MAReadError signal ].
	(contents allSatisfy: [ :each | '+-0123456789.eE' includes: each ])
		ifFalse: [ MAReadError signal ].
	super visitNumberDescription: aDescription
!

visitRelationDescription: aDescription
	self shouldNotImplement
!

visitSingleOptionDescription: aDescription
	aDescription propertyAt: #labels ifPresent: [ :labels |
		labels keysAndValuesDo: [ :key :value |
			(self nextMatchAll: value on: self stream)
				ifTrue: [ ^ self object: key ] ] ].
	self visit: aDescription reference
!

visitStringDescription: aDescription
	self object: self contents
!

visitSymbolDescription: aDescription
	self object: self contents asSymbol
!

visitTableDescription: aDescription
	self shouldNotImplement
!

visitTimeDescription: aDescription
	| string |
	string := self contents.
	(string notEmpty and: [ string allSatisfy: [ :each | '0123456789: apm' includes: each ] ])
		ifFalse: [ MAReadError signal ].
	self object: (aDescription kind readFrom: string readStream)
!

visitTokenDescription: aDescription
	| token |
	self object: (aDescription kind streamContents: [ :output |
		[ self stream atEnd ] whileFalse: [
			token := WriteStream on: String new.
			[ self stream atEnd or: [ aDescription separators includes: self stream peek ] ]
				whileFalse: [ token nextPut: self stream next ].
			self stream atEnd 
				ifFalse: [ self stream next ].
			token contents isEmpty
				ifFalse: [ output nextPut: (aDescription reference fromString: token contents) ] ] ])
! !

!MAStringReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAStringReader.st,v 1.3 2009-08-14 21:40:19 cg Exp $'
! !
