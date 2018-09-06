"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPTokenTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Tests'
!


!PPTokenTest methodsFor:'accessing'!

identifier
	^ #word asParser plus token
! !

!PPTokenTest methodsFor:'testing'!

testCollection
	| input result |
	input := 'foo    '.
	result := self parse: input using: self identifier.
	self assert: result collection equals: input.
	self assert: result collection == input
!

testInitialize
	PPToken initialize
!

testNew
	self should: [ PPToken new ] raise: Error.
	
!

testPrinting
	| result |
	result := PPToken on: 'var'.
	self assert: result printString includesSubstring: 'PPToken[1,3]'
!

testSize
	| result |
	result := self parse: 'foo' using: self identifier.
	self assert: result size equals: 3
!

testStart
	| result |
	result := self parse: 'foo' using: self identifier.
	self assert: result start equals: 1
!

testStop
	| result |
	result := self parse: 'foo' using: self identifier.
	self assert: result stop equals: 3
!

testValue
	| result |
	result := PPToken on: 'var'.
	self should: [ result value ] raise: Notification
! !

!PPTokenTest methodsFor:'testing-comparing'!

testEquality
	| token1 token2 |
	token1 := self parse: 'foo' using: self identifier.
	token2 := self parse: 'foo' using: self identifier.
	self deny: token1 == token2.
	self assert: token1 equals: token2.
	self assert: token1 hash equals: token2 hash
! !

!PPTokenTest methodsFor:'testing-copying'!

testCopyFromTo
	| result other |
	result := PPToken on: 'abc'.
	other := result copyFrom: 2 to: 2.
	self assert: other size equals: 1.
	self assert: other start equals: 2.
	self assert: other stop equals: 2.
	self assert: other collection equals: result collection
! !

!PPTokenTest methodsFor:'testing-querying'!

testColumn
	| input parser result |
	input := '1' , (String with: (Character codePoint: 13)) , '12' , (String with: (Character codePoint: 13) with: (Character codePoint: 10)) , '123'
		, (String with: (Character codePoint: 10)) , '1234'.
	parser := #any asParser token star.
	result := parser parse: input.
	result with: #(1 2 1 2 3 4 1 2 3 4 1 2 3 4) do: [ :token :line | self assert: token column equals: line ]
!

testLine
	| input parser result |
	input := '1' , (String with: (Character codePoint: 13)) , '12' , (String with: (Character codePoint: 13) with: (Character codePoint: 10)) , '123'
		, (String with: (Character codePoint: 10)) , '1234'.
	parser := #any asParser token star.
	result := parser parse: input.
	result with: #(1 1 2 2 2 2 3 3 3 3 4 4 4 4) do: [ :token :line | self assert: token line equals: line ]
! !

!PPTokenTest methodsFor:'testing-values'!

testInputValue
	| input result |
	input := 'foo'.
	result := self parse: input using: self identifier.
	self assert: result inputValue equals: input.
	self deny: result inputValue == input
!

testParsedValue
	| input result |
	input := 'foo'.
	result := self parse: input using: self identifier.
	self assert: result parsedValue equals: #($f $o $o)
! !

!PPTokenTest methodsFor:'utilities'!

parse: aString using: aParser
	^ aParser parse: aString
! !

!PPTokenTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPTokenTest.st,v 1.5 2014-03-04 14:34:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPTokenTest.st,v 1.5 2014-03-04 14:34:24 cg Exp $'
!

version_SVN
    ^ '$Id: PPTokenTest.st,v 1.5 2014-03-04 14:34:24 cg Exp $'
! !

