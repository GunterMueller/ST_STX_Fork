"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBBlockLintRule subclass:#RBSpellingRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBSpellingRule class methodsFor:'testing'!

isVisible
	^ self name ~= #RBSpellingRule
! !

!RBSpellingRule class methodsFor:'utilities'!

normalizeCamelCase: aString
    "An ugly long method to get rid of camel case strings.
     Splits camelCase words and returns a string containing words separated by spaces"

    | input output char |
    input := aString readStream.
    output := WriteStream on: (String new: 2 * aString size).
    [ input atEnd ] whileFalse: [
            output nextPut: (char := input next).
            char isLetter
                    ifTrue: [
                            [ input atEnd not and: [ input peek isLowercase ] ]
                                    whileTrue: [ output nextPut: input next ].
                            (input atEnd not and: [ input peek isSeparator not ])
                                    ifTrue: [ output space ] ]
                    ifFalse: [
                            char isDigit
                                    ifTrue: [
                                            [ input atEnd not and: [ input peek isDigit ] ]
                                                    whileTrue: [ output nextPut: input next ].
                                            (input atEnd not and: [ input peek isSeparator not ])
                                                    ifTrue: [ output space ] ] ] ].
    ^ output contents

    "
     self normalizeCamelCase:'helloWorldFooBar'
    "
! !

!RBSpellingRule methodsFor:'accessing'!

group
	^ 'Spelling'
!

rationale
    |s|

    s := 'Checks for spelling errors in ' , self name asLowercase , '.'.

    result notNil ifTrue:[
        result searchStrings notEmptyOrNil ifTrue:[
            s := s , '<p><b>Questionable:</b>: ', (result searchStrings asSet asOrderedCollection sort asStringWith:', ')
        ].
    ].
    ^ s
!

severity
	^ #information
! !

!RBSpellingRule methodsFor:'normalization'!

normalizeCamelCase: aString
    ^ self class normalizeCamelCase: aString
!

normalizeIdentifier: aString
	^ self normalizeCamelCase: (aString copyReplaceAll: '_' with: ' ')
!

normalizeLiteral: aLiteral
	| stream |
	stream := WriteStream on: String new.
	self normalizeLiteral: aLiteral on: stream.
	^ stream contents
!

normalizeLiteral: aLiteral on: aStream
	aLiteral isSymbol
		ifTrue: [ ^ aStream nextPutAll: (self normalizeSelector: aLiteral) ].
	aLiteral isString
		ifTrue: [ ^ aStream nextPutAll: aLiteral ].
	aLiteral isCharacter
		ifTrue: [ ^ aStream nextPut: aLiteral ].
	aLiteral isCollection ifTrue: [
		^ aLiteral 
			do: [ :each | self normalizeLiteral: each on: aStream ]
			separatedBy: [ aStream nextPut: $ ] ].
	aStream print: aLiteral
!

normalizeSelector: aString
	^ self normalizeIdentifier: (aString copyReplaceAll: ':' with: ' ')
! !

!RBSpellingRule methodsFor:'public'!

check: aString
	^ (RBSpellChecker default check: aString) 
		collect: [ :each | aString copyFrom: each first to: each last ]
!

checkIdentifier: aString
	^ self check: (self normalizeIdentifier: aString)
!

checkLiteral: aLiteral
	^ self check: (self normalizeLiteral: aLiteral)
!

checkSelector: aString
	^ self check: (self normalizeSelector: aString)
! !

!RBSpellingRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBSpellingRule.st,v 1.6 2014-02-26 16:17:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBSpellingRule.st,v 1.6 2014-02-26 16:17:27 cg Exp $'
! !

