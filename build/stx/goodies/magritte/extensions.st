"{ Package: 'stx:goodies/magritte' }"
!

!ArrayedCollection methodsFor:'*magritte-model'!

copyWithAll: aCollection
	^ (self species new: self size + aCollection size)
		replaceFrom: 1 to: self size with: self startingAt: 1;
		replaceFrom: self size + 1 to: self size + aCollection size with: aCollection startingAt: 1;
		yourself
! !

!Block methodsFor:'*magritte-model'!

asDynamicObject
        "Answer an object that will automatically evaluate the receiver when it receives a message. It will eventually pass the message to the resulting object. Use with caution, for details see *MADynamicObject*."

        ^ Magritte::MADynamicObject on: self
! !

!BlockContext methodsFor:'*magritte-model-converting'!

asDynamicObject
	"Answer an object that will automatically evaluate the receiver when it receives a message. It will eventually pass the message to the resulting object. Use with caution, for details see *MADynamicObject*."

	^ MADynamicObject on: self
! !

!Class methodsFor:'*magritte-model-configuration'!

descriptionContainer
        "Return the default description container."

        ^ Magritte::MAPriorityContainer new
                label: self label;
                yourself
! !

!Class methodsFor:'*magritte-model-accessing'!

label
	"Answer a human-readable name of the receiving class. This implementation tries to be smart and return a nice label, unfortunately for a lot of classes this doesn't work well so subclasses might want to override this method and return soemthing more meaningfull to end-users."

	| start input |
	start := self name findFirst: [ :each | each isLowercase ].
	input := (self name copyFrom: (1 max: start - 1) to: self name size)
		readStream.
	^ String streamContents: [ :stream |
		[ input atEnd ] whileFalse: [
			stream nextPut: input next.
			(input atEnd or: [ input peek isLowercase ])
				ifFalse: [ stream nextPut: Character space ] ] ]
! !

!Collection methodsFor:'*magritte-model'!

asMultilineString
	^ String streamContents: [ :stream |
		self
			do: [ :each | stream nextPutAll: each ]
			separatedBy: [ stream nextPut: Character cr ] ]
! !

!Collection methodsFor:'*magritte-model'!

copyWithAll: aCollection
	^ self copy
		addAll: aCollection;
		yourself
! !

!Collection methodsFor:'*magritte-model'!

copyWithoutFirst: anObject
	| done |
	done := false.
	^ self reject: [ :each |
		each = anObject
			and: [ done not ]
			and: [ done := true ] ]
! !

!Integer methodsFor:'*magritte-model-converting'!

asFileSize
	#( 'B' 'KB' 'MB' 'GB' 'TB' 'PB' 'EB' 'ZB' 'YB' )
		inject: self
		into: [ :value :each |
			value < 1024
				ifFalse: [ value // 1024 ]
				ifTrue: [ ^ value asString , ' ' , each ] ]
! !

!Object methodsFor:'*magritte-seaside-converting'!

asComponent
	^ self description asComponentOn: self
! !

!Object methodsFor:'*magritte-model-accessing'!

basicDescription
	"Return the description of the reciever. Subclasses might override this message to return instance-based descriptions."

	^ self class description
! !

!Object methodsFor:'*magritte-model-accessing'!

description
	"Return the canonical description of the receiver. Never override this method, instead modify #description."

	^ self basicDescription
! !

!Object methodsFor:'*magritte-model-model'!

initializeMagritte
	"Initializes the receiving object with the default values of its description."

	self description do: [ :each |
		each isReadonly
			ifFalse: [ self write: each default using: each ] ]
! !

!Object methodsFor:'*magritte-model-testing'!

isDescription
	^ false
! !

!Object methodsFor:'*magritte-model-accessing'!

mementoClass
	"Return a class to be used to remember or cache the receiver, namely a memento object."

	^ MACheckedMemento
! !

!Object methodsFor:'*magritte-model-model'!

readUsing: aDescription
	"Dispatch the read-access to the receiver using the accessor of aDescription."

	^ aDescription accessor read: self
! !

!Object methodsFor:'*magritte-model-model'!

write: anObject using: aDescription
	"Dispatch the write-access to the receiver of anObject using the accessor of aDescription."

	aDescription accessor write: anObject to: self
! !

!Object class methodsFor:'*magritte-model-accessing'!

description
        ^ Magritte::MADescriptionBuilder for: self
! !

!SequenceableCollection methodsFor:'*magritte-model'!

asAccessor
        ^ Magritte::MAChainAccessor accessors: self
! !

!SequenceableCollection methodsFor:'*magritte-model'!

moveDown: anObject
	| first second |
	first := self identityIndexOf: anObject ifAbsent: [ ^ 0 ].
	second := first < self size ifTrue: [ first + 1 ] ifFalse: [ ^ first ].
	self swap: first with: second.
	^ second
! !

!SequenceableCollection methodsFor:'*magritte-model'!

moveUp: anObject
	| first second |

	first := self identityIndexOf: anObject ifAbsent: [ ^ 0 ].
	second := first > 1 ifTrue: [ first - 1 ] ifFalse: [ ^ first ].
	self swap: first with: second.
	^ second
! !

!SequenceableCollection methodsFor:'*magritte-model'!

reduce: aBlock
	| result |
	self isEmpty
		ifTrue: [ ^ nil ].
	result := self first.
	2 to: self size do: [ :index |
		result := aBlock
			value: result
			value: (self at: index) ].
	^ result
! !

!String methodsFor:'*magritte-model-accessing'!

lines
	"Retrun a collection with the string-lines of the receiver."

	| input |
	input := self readStream.
	^ Array streamContents: [ :output |
		[ input atEnd ] whileFalse: [
			output nextPut: (input upTo: Character cr).
			input peek = Character lf
				ifTrue: [ input next ] ] ]
! !

!String methodsFor:'*magritte-model-testing'!

matches: aString
	aString isEmpty ifTrue: [ ^ true ].
	^ (aString includesAnyOf: '*#')
		ifTrue: [ aString match: self ]
		ifFalse: [ self includesSubstring: aString caseSensitive: false ]
! !

!Symbol methodsFor:'*magritte-model-converting'!

asAccessor
        ^ Magritte::MASelectorAccessor selector: self
! !

!Symbol methodsFor:'*magritte-seaside'!

fixTemps
	^ self
! !

!Symbol methodsFor:'*magritte-model-testing'!

isDescriptionDefinition
	"Answer wheter the receiver is a method selector following the naming conventions of a description definition."

	^ self isDescriptionSelector
		and: [ self isUnary ]
! !

!Symbol methodsFor:'*magritte-model-testing'!

isDescriptionExtension: aSelector
	"Answer wheter the receiver is a method selector following the naming conventions of a description extension to aSelector."

	^ self isDescriptionSelector
		and: [ self numArgs = 1
		and: [ self beginsWith: aSelector ] ]
! !

!Symbol methodsFor:'*magritte-model-testing'!

isDescriptionSelector
	"Answer wheter the receiver is a method selector following the naming conventions of a  description selector."

	^ self ~= #description
		and: [ self beginsWith: #description ]
! !

!UndefinedObject methodsFor:'*magritte-model-converting'!

asAccessor
        ^ Magritte::MANullAccessor new
! !

!UndefinedObject methodsFor:'*magritte-model-accessing'!

label
	^ 'n/a'
! !
