"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

PPPredicateParser subclass:#PPPredicateObjectParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!

PPPredicateObjectParser class instanceVariableNames:'cache'

"
 No other class instance variables are inherited by this class.
"
!


!PPPredicateObjectParser class methodsFor:'instance creation'!

on: aBlock message: aString
	^ self on: aBlock message: aString negated: [ :each | (aBlock value: each) not ] message: 'no ' , aString
!

on: aBlock message: aString negated: aNegatedBlock message: aNegatedString
	^ self new initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString
!

startOfLine
	
	^ PPStartOfLineParser new.
! !

!PPPredicateObjectParser class methodsFor:'cache'!

cacheAt: aSymbol ifAbsentPut: aBlock

	cache ifNil: [ ^aBlock value ].
	^(cache
		at: aSymbol
		ifAbsentPut: aBlock) copy
!

useCache: aBoolean
"
	PPPredicateObjectParser useCache: true.
	PPPredicateObjectParser useCache: false.
"
	cache := aBoolean 
		ifTrue: [ Dictionary new ]
		ifFalse: [ nil ]
! !

!PPPredicateObjectParser class methodsFor:'factory-chars'!

blank
	^self
		cacheAt: #'blank'
		ifAbsentPut: [ self
			chars: (String with: Character space with: Character tab) message: 'blank expected' ]
!

char: aCharacter
	^ self expect: aCharacter message: (String with: $" with: aCharacter with: $") , ' expected'
!

char: aCharacter message: aString
	^ self expect: aCharacter message: aString
!

chars: aCollection message: aString
	^ self on: (PPCharSetPredicate on: [ :char | aCollection includes: char ]) message: aString
!

cr
	^self
		cacheAt: #'cr'
		ifAbsentPut: [ self char: (Character codePoint: 13) message: 'carriage return expected' ]
!

digit
	^self
		cacheAt: #'digit'
		ifAbsentPut: [ self on: (PPCharSetPredicate on: [ :char | char isDigit ]) message: 'digit expected' ]
!

hex
	^self
		cacheAt: #'hex'
		ifAbsentPut: [ self
		on: (PPCharSetPredicate on: [ :char | 
			(char between: $0 and: $9) 
				or: [ (char between: $a and: $f) 
				or: [ (char between: $A and: $F) ] ] ])
		message: 'hex digit expected' ]
!

letter
	^self
		cacheAt: #'letter'
		ifAbsentPut: [ self on: (PPCharSetPredicate on: [ :char | char isLetter ]) message: 'letter expected' ]
!

lf
	^self
		cacheAt: #'lf'
		ifAbsentPut: [ self char: (Character codePoint: 10) ]
!

lowercase
	^self
		cacheAt: #'lowercase'
		ifAbsentPut: [ self on: (PPCharSetPredicate on: [ :char | char isLowercase ]) message: 'lowercase letter expected' ]
!

newline
	^self
		cacheAt: #'newline'
		ifAbsentPut: [ self chars: (String with: (Character codePoint: 13) with: (Character codePoint: 10)) message: 'newline expected' ]
!

punctuation
	^self
		cacheAt: #'punctuation'
		ifAbsentPut: [ self chars: '.,"''?!!;:#$%&()*+-/<>=@[]\^_{}|~' message: 'punctuation expected' ]
!

space
	^self
		cacheAt: #'space'
		ifAbsentPut: [ self on: (PPCharSetPredicate on: [ :char | char isSeparator ]) message: 'separator expected' ]
!

tab
	^self
		cacheAt: #'tab'
		ifAbsentPut: [ self char: Character tab message: 'tab expected' ]
!

uppercase
	^self
		cacheAt: #'uppercase'
		ifAbsentPut: [ self on: (PPCharSetPredicate on: [ :char | char isUppercase ]) message: 'uppercase letter expected' ]
!

word
	^self
		cacheAt: #'word'
		ifAbsentPut: [ self on: (PPCharSetPredicate on: [ :char | char isAlphaNumeric ]) message: 'letter or digit expected' ]
! !

!PPPredicateObjectParser class methodsFor:'factory-objects'!

any
	^self
		cacheAt: #'any'
		ifAbsentPut: [ self
			on: [ :each | true ] message: 'input expected'
			negated: [ :each | false ] message: 'no input expected' ]
!

anyExceptAnyOf: aCollection
	^ self
		on: [ :each | (aCollection includes: each) not ] message: 'any except ' , aCollection printString , ' expected'
		negated: [ :each | aCollection includes: each ] message: aCollection printString ,  ' not expected'
!

anyOf: aCollection
	^ self
		on: [ :each | aCollection includes: each ] message: 'any of ' , aCollection printString , ' expected'
		negated: [ :each | (aCollection includes: each) not ] message: 'none of ' , aCollection printString ,  'expected'
!

between: min and: max
	^ self
		on: [ :each | each >= min and: [ each <= max ] ] message: min printString , '..' , max printString , ' expected'
		negated: [ :each | each < min or: [ each > max ] ] message: min printString , '..' , max printString , ' not expected'
!

endOfLine
	
	^ PPEndOfLineParser new.
!

eof
	
	^ PPEndOfFileParser new
!

expect: anObject
	^ self expect: anObject message: anObject printString , ' expected'
!

expect: anObject message: aString
	^ self 
		on: [ :each | each = anObject ] message: aString
		negated: [ :each | each ~= anObject ] message: 'no ' , aString
!

startOfLogicalLine
	
	^ PPStartOfLogicalLineParser new.
!

startOfWord
	
	^ PPStartOfWordParser new.
! !

!PPPredicateObjectParser methodsFor:'initialization'!

initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString
	predicate := aBlock.
	predicateMessage := aString.
	negated := aNegatedBlock.
	negatedMessage := aNegatedString
! !

!PPPredicateObjectParser methodsFor:'operators'!

negate
	"Answer a parser that is the negation of the receiving predicate parser."
	
	^ self class 
		on: negated message: negatedMessage 
		negated: predicate message: predicateMessage
! !

!PPPredicateObjectParser methodsFor:'parsing'!

parseOn: aPPContext
	^ (aPPContext atEnd not and: [ predicate value: aPPContext uncheckedPeek ])
		ifFalse: [ PPFailure message: predicateMessage context: aPPContext ]
		ifTrue: [ aPPContext next ]
! !

!PPPredicateObjectParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPPredicateObjectParser.st,v 1.5 2014-03-04 14:33:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPPredicateObjectParser.st,v 1.5 2014-03-04 14:33:20 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPPredicateObjectParser.st,v 1.5 2014-03-04 14:33:20 cg Exp $'
! !

