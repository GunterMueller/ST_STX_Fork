"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPStream subclass:#PPCContext
	instanceVariableNames:'root properties globals furthestFailure compiledParser rc ws
		currentTokenType currentTokenValue'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Context'
!


!PPCContext class methodsFor:'as yet unclassified'!

new
    ^ self basicNew initialize
!

on: aPPParser stream: aStream
    ^ self basicNew 
        initialize;
        root: aPPParser;
        stream: aStream asPetitStream;
        yourself
! !

!PPCContext methodsFor:'accessing-globals'!

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

invoke: parser
    ^ parser parseOn: self
!

peek2
    position = readLimit ifTrue: [ ^ nil ].
    ^ collection at: (position + 1)
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

!PPCContext methodsFor:'accessing-properties'!

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

!PPCContext methodsFor:'acessing'!

initializeFor: parser
    rc := 0.
    parser == root ifTrue: [ ^ self ].
    
    root := parser.
!

root
    ^ root 
!

stream
    ^ self
!

stream: aStream
    collection := aStream collection.
    position := aStream position.
    readLimit := collection size.
! !

!PPCContext methodsFor:'converting'!

asCompiledParserContext
    ^ self
! !

!PPCContext methodsFor:'failures'!

furthestFailure
    ^ furthestFailure 
!

noteFailure: aPPFailure
    (aPPFailure position > furthestFailure position)
        ifTrue: [ furthestFailure := aPPFailure ].
! !

!PPCContext methodsFor:'initialization'!

compiledParser
    ^ compiledParser
!

compiledParser: anObject
    compiledParser := anObject
!

initialize
    
    rc := 0.
    "Note a failure at -1"
    furthestFailure  := PPFailure new position: -1; yourself.
! !

!PPCContext methodsFor:'memoization'!

lwRemember

    ^ position
!

lwRestore: aPPContextMemento
    
    position := aPPContextMemento.
!

remember
    | memento |
"
    ^ position
"
    memento := PPCContextMemento new
        position: position;
        yourself.
        
    self rememberProperties: memento.
    "JK: Just while developing"
    rc := rc + 1.
    (rc > ((self size + 1)* 1000*1000)) ifTrue: [ self error: 'Hey, this is not normal, is it?' ].
    ^ memento
!

rememberProperties: aPPContextMemento
    properties ifNil: [ ^ self ].
    
    properties keysAndValuesDo: [ :key :value |
        aPPContextMemento propertyAt: key put: value
    ].
!

restore: aPPContextMemento
"	
    position := aPPContextMemento.
"	
    position := aPPContextMemento position.
    
    self restoreProperties: aPPContextMemento.
            
!

restoreProperties: aPPContextMemento
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

!PPCContext methodsFor:'whitespace'!

atWs
    ^ position = ws
!

goUpTo: char
    [ position < readLimit ] whileTrue: [ 
        (collection at: position + 1) == char ifTrue: [ position := position + 1. ^ char ] .
        position := position + 1.
    ]
    
!

setWs
    ^ ws := position
!

ws
    ^ ws
!

ws: anInteger
    ws := anInteger
! !

!PPCContext class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

