"{ Package: 'stx:goodies/petitparser' }"!

!Block methodsFor:'*petitparser-core-converting'!

asParser
	"Answer a parser implemented in the receiving one-argument block."

	^ PPPluggableParser on: self
! !

!BlockContext methodsFor:'*petitparser-core-converting'!

asParser
	^ PPPluggableParser on: self
! !

!Character methodsFor:'*petitparser-core-converting'!

asParser
	"Answer a parser that accepts the receiving character."
	
	^ PPLiteralObjectParser on: self
! !

!Collection methodsFor:'*petitparser-core-converting'!

asChoiceParser
	^ PPChoiceParser withAll: (self collect: [ :each | each asParser ])
! !

!Collection methodsFor:'*petitparser-converting'!

asParser    
	"Create a range of characters between start and stop."

	(self allSatisfy: [ :e | e isCharacter ]) ifTrue: [ 
		| charSet |
		charSet := PPCharSetPredicate on: [ :char | self includes: char ] .
     	^ PPPredicateObjectParser on: charSet message: 'One of these charactes expected: ', self printString.
	].


	^ super asParser
	"
		($a to:$f) asParser parse:'a'
		($a to:$f) asParser parse:'g'
	"
! !

!Collection methodsFor:'*petitparser-core-converting'!

asSequenceParser
	^ PPSequenceParser withAll: (self collect: [ :each | each asParser ])
! !

!Interval methodsFor:'*petitparser-core-converting'!

asParser    
	"Create a range of characters between start and stop."

    self assert:start isCharacter.
    self assert:stop isCharacter.
    self assert:step == 1.
    ^ PPPredicateObjectParser between: start and: stop

    "
		($a to: $f) asParser parse: 'a'
		($a to: $f) asParser parse: 'g'
    "
! !

!Object methodsFor:'*petitparser-core-converting'!

asParser
	"Answer a parser accepting the receiving object."

	^ PPPredicateObjectParser expect: self
! !

!Object methodsFor:'*petitparser-core-testing'!

isPetitFailure
	^ false
! !

!Object methodsFor:'*petitparser-core-testing'!

isPetitParser
	^ false
! !

!PositionableStream methodsFor:'*petitparser-core-converting'!

asPetitStream
	"Some of my subclasses do not use the instance-variables collection, position and readLimit but instead have a completely different internal representation. In these cases just use the super implementation that is inefficient but should work in all cases."

"
	Disabled until we agree on some way how to optimize this

	^ (collection isNil or: [ position isNil or: [ readLimit isNil ] ])
		ifFalse: [ PPStream on: collection from: ( position + 1 ) to: readLimit ]
      ifTrue: [ super asPetitStream ]
"
	^ super asPetitStream
! !

!PositionableStream methodsFor:'*petitparser-core'!

peekTwice
	"Answer what would be returned if the message next were sent to the 
	receiver. If the receiver is at the end, answer nil."

	| array |
	self atEnd 
		ifTrue: [^Array with: nil with: nil].
	array := Array with: (self next) with: (self peek).
	position := position - 1.
	^array
! !

!SequenceableCollection methodsFor:'*petitparser-core-converting'!

asPetitStream
	^ PPStream on: self
! !

!Set methodsFor:'*petitparser-core-converting'!

asParser
	^ PPChoiceParser withAll: (self collect: [ :each | each asParser ])
! !

!Stream methodsFor:'*petitparser-core-converting'!

asPetitStream
	^ self contents asPetitStream
! !

!String methodsFor:'*petitparser-core-converting'!

asParser
	"Answer a parser that accepts the receiving string."

	^ PPLiteralSequenceParser on: self
! !

!Symbol methodsFor:'*petitparser-core-converting'!

asParser
	"Answer a predicate parser named after the receiving symbol. Possible symbols are the method selectors on the class-side of PPPredicateObjectParser."

	^ PPPredicateObjectParser perform: self
! !

!Symbol methodsFor:'Compatibility-Squeak'!

value:anObject
    ^ anObject perform: self.

    "Created: / 18-12-2010 / 16:47:22 / Jan Kurs <kurs.jan@post.cz>"
! !

!Text methodsFor:'*petitparser-core'!

asPetitStream
	^ string asPetitStream
! !

!UndefinedObject methodsFor:'*petitparser-converting'!

asParser
	"Answer a parser that succeeds and does not consume anything."
	
	^ PPEpsilonParser new
! !

!stx_goodies_petitparser class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
