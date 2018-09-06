"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCGuard
	instanceVariableNames:'classification id message'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Guards'
!

!PPCGuard class methodsFor:'as yet unclassified'!

on: aPPCNode
    ^ self new
        initializeFor: aPPCNode;
        yourself
!

on: aPPCNode id: id
    ^ self new
        initializeFor: aPPCNode;
        id: id;
        yourself
! !

!PPCGuard methodsFor:'accessing'!

classification
    ^ classification
!

id
    
    ^ id
!

id: anObject
    
    id := anObject
!

message
    (message == #unknown) ifTrue: [ 
        (self testMessage: #isLetter) ifTrue: [ ^ message := #isLetter ].
        (self testMessage: #isAlphaNumeric) ifTrue: [ ^ message := #isAlphaNumeric ].
        (self testMessage: #isDigit) ifTrue: [ ^ message := #isDigit ].
        
        ^ message := nil.
    ].
    ^ message
! !

!PPCGuard methodsFor:'as yet unclassified'!

classificationOn: aBlock
    classification := Array new: 255.
    1 to: classification size do: [ :index |
        classification at: index put: (aBlock
            value: (Character value: index)) ].
!

compileAny: compiler
    compiler code: '(context atEnd not)'.
!

compileCharacter: compiler
    self assert: (classification select: [ :e | e ]) size = 1.
    
    classification keysAndValuesDo: [ :index :value | value ifTrue: [  
        (index > 32 and: [ index < 127 ]) ifTrue: [ 
            compiler code: '(context peek == ', (Character value: index) storeString, ')'
        ] ifFalse: [ 
            id := compiler idFor: (Character value: index) defaultName: #character.
            compiler addConstant: (Character value: index) as: id.
            compiler code: '(context peek = ', id, ')'.
     		] 
    ] ].
!

compileGuard: compiler id: symbol
    self id: symbol.
    ^ self compileGuard: compiler
!

compileMessage: compiler
    compiler code: '(context peek ', message, ')'
!

testAny
    ^ classification allSatisfy: [ :e | e ].
!

testMessage: selector
 				classification keysAndValuesDo: [:index :element |
								(element = ((Character value: index) perform: selector)) ifFalse: [ 
												^ false 
								]
				].
				^ true
!

testSingleCharacter
    ^ (classification select: [ :e | e ]) size = 1
! !

!PPCGuard methodsFor:'code generation'!

compileArray: compiler
    | array |
    self assert: id isNotNil.

    array := ((classification asOrderedCollection) addLast: false; yourself) asArray.
    compiler addConstant: array as: id.
    compiler code: '(', id, ' at: context peek asInteger)'.
!

compileGuard: compiler
    self assert: self makesSense description: 'No Guard could be compiled'.
    self assert: id notNil.
    
    self message ifNotNil: [ ^ self compileMessage: compiler ].
    self testAny ifTrue: [ ^ self compileAny: compiler ].
    self testSingleCharacter ifTrue: [ ^ self compileCharacter: compiler ].
    
    ^ self compileArray: compiler
!

makesSense
    ^ classification isNil not
! !

!PPCGuard methodsFor:'initialization'!

initializeFor: node
    message := #unknown.
    id := nil.
    
    "No Guards for trimming parser so far"
"	((node firstSetSuchThat: [ :e | e isKindOf: PPCTrimNode ]) isEmpty) ifFalse: [ 
        ^ self initializeForNoGuard 
    ]."
    (node acceptsEpsilon) ifTrue: [  
        ^ self initializeForEpsilon
    ].

    self classificationOn: [:char | node firstSet anySatisfy: [:e | (e firstCharSetCached value: char) ]]

"	self classificationOn: [ :char | node firstSet anySatisfy: [ :e |  (e firstCharParser parse: char asString) isPetitFailure not ] ]"
!

initializeForEpsilon
    classification := nil
    
!

initializeForNoGuard
    classification := nil
    
! !

