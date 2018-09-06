"{ Encoding: utf8 }" !
"{ Package: 'stx:libdb/nosql/minneStore' }"
!
!Bag methodsFor:'MinneStore'
!

asArrayByDescendingOccurrences
        "Added by MinneStore.  Specific to Dolphin because the contents variable is not 
        standard or accessible from outside the Bag.  If there were an accessor, I would 
        have put this code into a FlavorCompatibility method."
        "Fixed by GG, caused test3 to fail"

        | sc |

        sc := SortedCollection sortBlock: [ :a :b | a value > b value ].
        "Original:
        elements associationsDo: [ :assoc | sc add: assoc ]."
        "Fix:"
        contents associationsDo: [ :assoc | sc add: assoc ].
        ^sc asArrayCollect: [ :assoc | assoc key ].
! !

!Collection methodsFor:'MinneStore'
!

asArrayCollect: aBlock
        "Answer an Array containing all the elements of the receiver."

        | answer index |

        answer := Array new: self size.
        index := 1.
        self do:[ :element |
            answer at: index put: (aBlock value: element).
            index := index + 1
        ].
        ^answer
! !

!Collection methodsFor:'MinneStore'
!

doesNotInclude: anObject
        "Answer true if the receiver contains an
         element equal to anObject, else answer false."

        ^(self includes: anObject) not
! !

!Collection methodsFor:'MinneStore'
!

intersectionOf: aCollection
        "Answer the elements that are also in aCollection.
        If possible, the receiver should be the larger collection."

        self == aCollection ifTrue: [ ^self ].

        ^self select: [ :each | aCollection includes: each ].
! !

!Collection methodsFor:'MinneStore'
!

isCollectionOtherThanString
        "Answer true if receiver is an instance of class Collection
        or one of its subclasses other than String, else answer false."

        ^true
! !

!Integer methodsFor:'MinneStore'
!

asZeroFilledString: stringSize
        | result zeros |

        result := self printString.
        result size > stringSize
                ifTrue: [self error: result, ' is too large'].

        result size == stringSize
                ifTrue: [^result].

        zeros := (String new: stringSize - result size).

        1 to: zeros size do: [:i | zeros at: i put: $0].

        ^zeros, result.

        "
         123 asZeroFilledString: 4
        "
! !

!Object methodsFor:'MinneStore'
!

isCollectionOtherThanString
        "Answer true if receiver is an instance of class Collection
        or one of its subclasses other than String, else answer false."

        ^false
! !

!Object methodsFor:'MinneStore'
!

isDODeletedObject
        "Answer false."

        ^false
! !

!Object methodsFor:'MinneStore'
!

isDOService
        "Answer false."

        ^false
! !

!Object methodsFor:'MinneStore'
!

isMSNilValue
        "Answer false."

        ^false
! !

!Object methodsFor:'MinneStore'
!

isMSProxy
        "Answer false."

        ^false
! !

!Object methodsFor:'MinneStore'
!

isMSReadProxy
        "Answer false"

        ^false
! !

!Object methodsFor:'MinneStore'
!

isMSStorageProxy
        "Answer false"

        ^false
! !

!Object methodsFor:'MinneStore'
!

isMSText
        "Answer false."

        ^false
! !

!Object methodsFor:'MinneStore'
!

propertyAt: aSymbol 
        "Non sicuto che funzioni al 100%"
        "Transcript show: ('Requested propertyAt: of a ', self printString) ; cr."
        "By GG"

        MinneStorePropertyDB isNil ifTrue:[ ^nil].
        MinneStorePropertyDB at: (self) ifAbsent: [ ^nil].
        (MinneStorePropertyDB at: self) at: aSymbol  ifAbsent: [ ^nil].
        ^((MinneStorePropertyDB at: self) at: aSymbol ).
! !

!Object methodsFor:'MinneStore'
!

propertyAt: aSymbol ifAbsent: aBlock
        "Non sicuto che funzioni al 100%"
        "Transcript show: ('Requested propertyAt:ifAbsent of a ', self printString) ; cr."
        "by GG"

        MinneStorePropertyDB isNil ifTrue:[ ^aBlock value].
        MinneStorePropertyDB at: self ifAbsent: [ ^aBlock value].
        (MinneStorePropertyDB at: self) at: aSymbol  ifAbsent: [ ^aBlock value].
        ^((MinneStorePropertyDB at: self) at: aSymbol ).
! !

!Object methodsFor:'MinneStore'
!

propertyAt: aSymbol put: aObject 
        "Transcript show: ('Requested propertyAt:put: of a ', self printString) ; cr."
        "by GG"

        MinneStorePropertyDB isNil ifTrue:[
            self class initPropertyEngine.
        ].
        MinneStorePropertyDB at:self ifAbsent:[
            Smalltalk isSmalltalkX ifTrue:[
                MinneStorePropertyDB at: self put: (WeakIdentityDictionary new: 4)
            ] ifFalse:[
                MinneStorePropertyDB at: self put: (WeakDictionary new: 4)
            ]
        ].
        (MinneStorePropertyDB at: self)
                at: aSymbol put: aObject
! !

!Object class methodsFor:'MinnieStore'
!

initPropertyEngine
        Transcript cr; show:' Cleaning MinnieStorePropertyDB...';cr.

        "This code is strange but i cannot avoid it!!!!"
        Smalltalk isSmalltalkX ifTrue:[
            Smalltalk at:#MinneStorePropertyDB   put: (WeakIdentityDictionary new: 90).
        ] ifFalse:[
            Smalltalk at:#MinneStorePropertyDB   put: (WeakDictionary new: 90).
        ]
! !

!Stream methodsFor:'MinneStore'
!

skipSeparatorsAndPunctuation
        "Advance the receiver's position over any leading whitespace or punctuation.
        Answer whether their are more elements remaining in the receiver
        after the separators."
        
        self skipWhile: [:c | c isLetter not and: [c isDigit not]].
        ^self atEnd not
! !

!Stream methodsFor:'MinneStore'
!

skipWhile: aOneArgumentBlock
        | c |

        [self atEnd]
                whileFalse:
                        [c := self peek.
                        (aOneArgumentBlock value: c)
                                ifTrue: [self next]
                                ifFalse: [^self]]
! !

!String methodsFor:'MinneStore'
!

asMSText
        "Answer myself inside an MSText object."

        ^ Minnestore::MSText newOn: self.
! !

!String methodsFor:'MinneStore'
!

isCollectionOtherThanString
        "Answer true if receiver is an instance of class Collection
        or one of its subclasses other than String, else answer false."

        ^false
! !

