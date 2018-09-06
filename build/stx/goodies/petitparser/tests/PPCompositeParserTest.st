"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPCompositeParserTest
	instanceVariableNames:'parser result'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Core'
!


!PPCompositeParserTest class methodsFor:'accessing'!

resources
	^ Array with: PPParserResource
! !

!PPCompositeParserTest class methodsFor:'testing'!

isAbstract
	^ self name = #PPCompositeParserTest
! !

!PPCompositeParserTest methodsFor:'accessing'!

parserClass
	self subclassResponsibility
!

parserInstance
	^ PPParserResource current parserAt: self parserClass
!

parserInstanceFor: aSymbol
	^ aSymbol = #start
		ifTrue: [ self parserInstance ]
		ifFalse: [
			self parserInstance
				productionAt: aSymbol 
				ifAbsent: [ self error: 'Production ' , self parserClass name , '>>' , aSymbol printString , ' not found.' ] ]
! !

!PPCompositeParserTest methodsFor:'parsing'!

fail: aString rule: aSymbol 
	| production context |
	production := self parserInstanceFor: aSymbol.
	context := self context.
	
	result := production end parse: aString withContext: context.
	
	self
		assert: result isPetitFailure
		description: 'Able to parse ' , aString printString.
	^ result
!

parse: aString 
	^ self parse: aString rule: #start
!

parse: aString rule: aSymbol
	| production context |
	production := self parserInstanceFor: aSymbol.
	context := self context.
	
	result := production end parse: aString withContext: context.
	self
		deny: result isPetitFailure
		description: 'Unable to parse ' , aString printString.
	^ result
! !

!PPCompositeParserTest methodsFor:'running'!

setUp
	super setUp.
	parser := self parserInstance
!

tearDown
	super tearDown.
	parser := result := nil
! !

!PPCompositeParserTest methodsFor:'utilities'!

assert: aCollection is: anObject
	self parse: aCollection.
	self
		assert: result = anObject
		description: 'Got: ' , result printString , '; Expected: ' , anObject printString
		resumable: true
! !

!PPCompositeParserTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/tests/PPCompositeParserTest.st,v 1.2 2014-03-04 20:31:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/tests/PPCompositeParserTest.st,v 1.2 2014-03-04 20:31:51 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPCompositeParserTest.st,v 1.2 2014-03-04 20:31:51 cg Exp $'
! !

