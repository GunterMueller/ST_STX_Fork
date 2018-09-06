"{ Package: 'stx:goodies/cypress' }"

Object subclass:#CypressJSONReader
	instanceVariableNames:'stream'
	classVariableNames:''
	poolDictionaries:''
	category:'Cypress-New-Reader & Writer'
!

CypressJSONReader comment:'Main comment stating the purpose of this class and relevant relationship to other classes.Possible useful expressions for doIt or printIt.Structure: instVar1		type -- comment about the purpose of instVar1 instVar2		type -- comment about the purpose of instVar2Any further useful comments about the general approach of this implementation.'
!


!CypressJSONReader class methodsFor:'instance creation'!

new
	self error: 'Instantiate the parser with a stream.'
!

on: aStream
	^ self basicNew initializeOn: aStream
! !

!CypressJSONReader class methodsFor:'accessing'!

parse: aStringOrFilename
        ^ self parseStream: aStringOrFilename readStream

    "Modified (format): / 11-09-2012 / 11:38:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseStream: aStream
	^ (self on: aStream) parse
! !

!CypressJSONReader methodsFor:'adding'!

addProperty: anAssociation to: anObject
	"Add the property anAssociation described with key and value to anObject. Subclasses might want to refine this implementation."
	
	^ anObject 
		add: anAssociation;
		yourself
!

addValue: anObject to: aCollection
	"Add anObject to aCollection. Subclasses might want to refine this implementation."

	^ aCollection copyWith: anObject
! !

!CypressJSONReader methodsFor:'creating'!

createArray
	"Create an empty collection. Subclasses might want to refine this implementation."

	^ Array new
!

createFalse
	"Create the false literal. Subclasses might want to refine this implementation."
	
	^ false
!

createNull
	"Create the null literal. Subclasses might want to refine this implementation."

	^ nil
!

createNumber: aString
	"Create a number literal. Subclasses might want to refine this implementation."

	^ aString asNumber
!

createObject
	"Create an empty object. Subclasses might want to refine this implementation."
	
	^ Dictionary new
!

createProperty: aKey with: aValue
	"Create an empty attribute value pair. Subclasses might want to refine this implementation."
	
	^ aKey -> aValue
!

createString: aString
	"Create a string literal. Subclasses might want to refine this implementation."

	^ aString
!

createTrue
	"Create the true literal. Subclasses might want to refine this implementation."

	^ true
! !

!CypressJSONReader methodsFor:'initialization'!

initializeOn: aStream
	self initialize.
	stream := aStream
! !

!CypressJSONReader methodsFor:'parsing'!

parse
	| result |
	result := self whitespace; parseValue.
	stream atEnd
		ifFalse: [ self error: 'end of input expected' ].
	^ result
!

parseArray
	| result |
	self expect: '['.
	result := self createArray.
	(self match: ']')
		ifTrue: [ ^ result ].
	[ stream atEnd ] whileFalse: [
		result := self
			addValue: self parseValue
			to: result.
		(self match: ']') 
			ifTrue: [ ^ result ].
		self expect: ',' ].
	self error: 'end of array expected'
!

parseObject
	| result |
	self expect: '{'.
	result := self createObject.
	(self match: '}')
		ifTrue: [ ^ result ].
	[ stream atEnd ] whileFalse: [
		result := self
			addProperty: self parseProperty
			to: result.
		(self match: '}')
			ifTrue: [ ^ result ].
		self expect: ',' ].
	self error: 'end of object expected'
!

parseValue
	| char |
	stream atEnd ifFalse: [ 
		char := stream peek.
		char = ${
			ifTrue: [ ^ self parseObject ].
		char = $[
			ifTrue: [ ^ self parseArray ].
		char = $"
			ifTrue: [ ^ self parseString ].
		(char = $- or: [ char between: $0 and: $9 ])
			ifTrue: [ ^ self parseNumber ].
		(self match: 'true')
			ifTrue: [ ^ self createTrue ].
		(self match: 'false')
			ifTrue: [ ^ self createFalse ].
		(self match: 'null')
			ifTrue: [ ^ self createNull ] ].
	self error: 'invalid input'
! !

!CypressJSONReader methodsFor:'parsing-internal'!

parseCharacter
        | char |
        (char := stream next) = $\ 
                ifFalse: [ ^ char ].
        (char := stream next) = $" 
                ifTrue: [ ^ char ].
        char = $\
                ifTrue: [ ^ char ].
        char = $/
                ifTrue: [ ^ char ].
        char = $b
                ifTrue: [ ^ Character backspace ].
        char = $f
                ifTrue: [ ^ Character newPage ].
        char = $n
                ifTrue: [ ^ Character linefeed ].
        char = $r
                ifTrue: [ ^ Character return ].
        char = $t
                ifTrue: [ ^ Character tab ].
        char = $u
                ifTrue: [ ^ self parseCharacterHex ].
        self error: 'invalid escape character \' , (String with: char)

    "Modified: / 18-09-2012 / 14:22:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCharacterHex
	| value |
	value := self parseCharacterHexDigit.
	3 timesRepeat: [ value := (value << 4) + self parseCharacterHexDigit ].
	^ Character unicodeCodePoint: value
!

parseCharacterHexDigit
	| digit |
	stream atEnd ifFalse: [
		digit _ stream next asUppercase digitValue.
		"accept hex digits"
		(digit >= 0 and: [ digit < 16 ]) ifTrue: [ ^ digit ]].
	self error: 'hex-digit expected'.
!

parseNumber
	| negated number |
	negated := stream peek = $-.
	negated ifTrue: [ stream next ].
	number := self parseNumberInteger.
	(stream peek = $.) ifTrue: [
		stream next. 
		number := number + self parseNumberFraction ].
	(stream peek = $e or: [ stream peek = $E ]) ifTrue: [
		stream next.
		number := number * self parseNumberExponent ].
	negated ifTrue: [ number := number negated ].
	^ self whitespace; createNumber: number
!

parseNumberExponent
    | number negated |
    number := 0.
    negated := stream peek = $-.
    (negated or: [ stream peek = $+ ])
        ifTrue: [ stream next ].
    [ stream atEnd not and: [ stream peek isDigit ] ] whileTrue: [ number := 10 * number + (stream next digitValue) ].
    negated
        ifTrue: [ number := number negated ].
    ^ 10 raisedTo: number
!

parseNumberFraction
    | number power |
    number := 0.
    power := 1.0.
    [ stream atEnd not and: [ stream peek isDigit ] ]
        whileTrue: [ 
            number := 10 * number + (stream next digitValue).
            power := power * 10.0 ].
    ^ number / power
!

parseNumberInteger
    | number |
    number := 0.
    [ stream atEnd not and: [ stream peek isDigit ] ] whileTrue: [ number := 10 * number + (stream next asciiValue - 48) ].
    ^ number
!

parseProperty
	| name value |
	name := self parseString.
	self expect: ':'.
	value := self parseValue.
	^ self createProperty: name with: value.
!

parseString
	| result |
	self expect: '"'.
	result := WriteStream on: String new.
	[ stream atEnd or: [ stream peek = $" ] ] 
		whileFalse: [ result nextPut: self parseCharacter ].
	^ self expect: '"'; createString: result contents
! !

!CypressJSONReader methodsFor:'private'!

expect: aString
	"Expects aString and consume input, throw an error otherwise."

	^ (self match: aString) ifFalse: [ self error: aString , ' expected' ]
!

match: aString
	"Tries to match aString, consume input and answer true if successful."
	
	| position |
	position := stream position.
	aString do: [ :each |
		(stream atEnd or: [ stream next ~= each ]) ifTrue: [ 
			stream position: position.
			^ false ] ].
	self whitespace.
	^ true
!

whitespace
	"Strip whitespaces from the input stream."

	[ stream atEnd not and: [ stream peek isSeparator ] ]
		whileTrue: [ stream next ]
! !

!CypressJSONReader class methodsFor:'documentation'!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !
