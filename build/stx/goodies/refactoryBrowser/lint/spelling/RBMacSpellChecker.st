"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellChecker subclass:#RBMacSpellChecker
	instanceVariableNames:''
	classVariableNames:'Utf16Converter'
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBMacSpellChecker class methodsFor:'initialization'!

initialize
    Smalltalk isSmalltalkX ifTrue:[
    ] ifFalse:[
        Utf16Converter := TextConverter newForEncoding: 'utf-16'
    ]
! !

!RBMacSpellChecker class methodsFor:'primitives'!

primitiveGetUniqueSpellingTag
"/        <primitive:'primitiveGetUniqueSpellingTag' module: 'SpellingPlugin'>

        ^ nil
! !

!RBMacSpellChecker class methodsFor:'testing'!

isSupported
	^ self primitiveGetUniqueSpellingTag notNil
! !

!RBMacSpellChecker methodsFor:'private'!

primitiveCheckSpelling: aString startingAt: anInteger
"/        <primitive:'primitiveCheckSpelling' module: 'SpellingPlugin'>
        
        self primitiveFailed
! !

!RBMacSpellChecker methodsFor:'public'!

check: aString
	| position errors string result |
	position := 1.
	errors := OrderedCollection new.
	string := aString convertToWithConverter: Utf16Converter.
	[ position <= string size ] whileTrue: [ 
		result := self
			primitiveCheckSpelling: string
			startingAt: position.
		(result first between: 1 and: string size)
			ifFalse: [ ^ errors ].
		errors addLast: (result first to: result first + result second - 1).
		position := result first + result second ].
	^ errors
! !

!RBMacSpellChecker class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBMacSpellChecker.st,v 1.5 2013-08-21 00:09:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBMacSpellChecker.st,v 1.5 2013-08-21 00:09:30 cg Exp $'
! !


RBMacSpellChecker initialize!
