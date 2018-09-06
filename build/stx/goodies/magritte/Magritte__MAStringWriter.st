"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAWriter subclass:#MAStringWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Visitor'
!


!MAStringWriter methodsFor:'private'!

defaultWriteStream
	^ WriteStream on: String new
! !

!MAStringWriter methodsFor:'visiting'!

write: anObject description: aDescription to: aStream
	anObject isNil 
		ifTrue: [ aStream nextPutAll: aDescription undefined ]
		ifFalse: [ super write: anObject description: aDescription to: aStream ].
	^ aStream contents
! !

!MAStringWriter methodsFor:'visiting-description'!

visitBooleanDescription: aDescription
	self stream nextPutAll: (self object
		ifTrue: [ aDescription trueString ]
		ifFalse: [ aDescription falseString ])
!

visitClassDescription: aDescription
	self stream nextPutAll: self object label
!

visitColorDescription: aDescription
        stream nextPut: $#.
        stream nextPutAll: ((self object redByte)
                printPaddedWith: $0 to: 2 base: 16).
        stream nextPutAll: ((self object greenByte) 
                printPaddedWith: $0 to: 2 base: 16).
        stream nextPutAll: ((self object blueByte)
                printPaddedWith: $0 to: 2 base: 16)
!

visitContainer: aDescription
	aDescription do: [ :each |
		each isVisible ifTrue: [
			each stringWriter
				write: (self object readUsing: each)
				description: each to: stream.
			^ self ] ]
!

visitElementDescription: aDescription
	self stream nextPutAll: self object asString
!

visitFileDescription: aDescription
	self stream nextPutAll: self object filename
!

visitMultipleOptionDescription: aDescription
	self object isEmpty
		ifTrue: [ self stream nextPutAll: aDescription undefined ]
		ifFalse: [
			self object
				do: [ :each | self stream nextPutAll: (aDescription labelForOption: each) ]
				separatedBy: [ self stream nextPutAll: ', ' ] ]
!

visitSingleOptionDescription: aDescription
	self stream nextPutAll: (aDescription labelForOption: self object)
!

visitTimeDescription: aDescription
	self object print24: true showSeconds: true on: self stream
!

visitTimeStampDescription: aDescription
	self stream print: self object asDate; space.
	self stream print: self object asTime
!

visitToManyRelationDescription: aDescription
	self object
		do: [ :each | self object: each during: [ self visit: each description ] ]
		separatedBy: [ self stream nextPutAll: ', ' ]
!

visitToOneRelationDescription: aDescription
	self visit: self object description
!

visitTokenDescription: aDescription
	self object
		do: [ :each | self object: each during: [ self visit: aDescription reference ] ]
		separatedBy: [ self stream nextPut: aDescription separators first ]
! !

!MAStringWriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAStringWriter.st,v 1.2 2009-08-14 21:40:25 cg Exp $'
! !
