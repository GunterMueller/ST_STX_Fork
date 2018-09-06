"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCScanner
	instanceVariableNames:'stream start matchActions matchEnd currentCharacter outputStream
		lastOutputStreamMatchPosition lastMatchWasEmpty returnMatchBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Runtime'
!

SmaCCScanner class instanceVariableNames:'keywordMap'

"
 No other class instance variables are inherited by this class.
"
!

SmaCCScanner comment:'SmaCCScanner is an abstract class that represents a scanner for the parser. The scanner converts its string input into SmaCCToken objects that the parser then uses for its parsing.

Subclasses must implement the following messages:
	accessing
		scanForToken

Instance Variables:
	currentCharacter	<Character>	the current character we are scanning
	lastMatchWasEmpty	<Boolean>	was our last scanning match an empty string -- don''t allow two empty matches in a row
	lastOutputStreamMatchPosition	<Integer>	the position in the outputStream of the last match
	matchActions	<Array | Symbol>	the actions for the last match (a symbol means that the action should be performed on the scanner)
	matchEnd	<Integer>	the position of the last match in the stream (our input stream)
	outputStream	<PositionableStream>	the matched characters go in this stream. After a match is made, we take this stream''s contents and create a token object.
	returnMatchBlock	<BlockClosure>	when we match a token evaluate this block with the token (hack to return from multiple levels)
	start	<Integer>	the starting position of a match in the stream
	stream	<Stream>	our input

'
!


!SmaCCScanner class methodsFor:'instance creation'!

new
	^(super new)
		initialize;
		yourself
!

on: aStream 
	^(self new)
		on: (self needsLineNumbers 
					ifTrue: [SmaCCLineNumberStream on: aStream]
					ifFalse: [aStream]);
		yourself
! !

!SmaCCScanner class methodsFor:'accessing'!

frequencyTable
	^#(1)
!

keywordMap
	keywordMap isNil ifTrue: [self initializeKeywordMap].
	^keywordMap
! !

!SmaCCScanner class methodsFor:'class initialization'!

initialize
	self initializeKeywordMap
!

initializeKeywordMap
	keywordMap := Dictionary new
! !

!SmaCCScanner class methodsFor:'public'!

needsLineNumbers
	"Redefine to return true, if you need line number information"

	^false
! !

!SmaCCScanner methodsFor:'accessing'!

contents
	| writeStream token |
	writeStream := WriteStream on: Array new.
	[self atEnd] whileFalse: 
			[token := self next.
			token notNil ifTrue: [writeStream nextPut: token]].
	^writeStream contents
!

emptySymbolTokenId
	^self subclassResponsibility
!

errorTokenId
	^self subclassResponsibility
!

lineNumber
	"This requires the stream to be a line number stream (see the #needsLineNumbers class method)."

	^stream lineNumber
!

next
	self resetScanner.
	returnMatchBlock := [:match | ^match].
	self scanForToken
!

position
	^stream position
!

position: anInteger
	^stream position: anInteger
!

scanForToken
	^self subclassResponsibility
!

stream

    ^stream

    "Created: / 06-06-2008 / 20:51:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmaCCScanner methodsFor:'default token handling'!

comment
	"In case someone wants to record the comments"

	self whitespace
!

whitespace
        "By default, eat the whitespace"

        self resetScanner.
        self scanForToken
! !

!SmaCCScanner methodsFor:'initialize-release'!

initialize
	outputStream := WriteStream on: (String new: self initialBufferSize).
	lastMatchWasEmpty := true
!

on: aStream 
	stream := aStream.
	start := stream position
! !

!SmaCCScanner methodsFor:'private'!

checkForKeyword: aString 
	| stateMap action |
	action := matchActions isSymbol 
				ifTrue: [matchActions]
				ifFalse: [matchActions first].
	stateMap := self class keywordMap at: action ifAbsent: [nil].
	stateMap isNil ifTrue: [^self].
	matchActions := stateMap at: (self keywordFor: aString)
				ifAbsent: [matchActions].
	matchActions isInteger 
		ifTrue: [matchActions := Array with: matchActions with: action]
!

checkForValidMatch
	matchActions isNil ifTrue: [self scannerError]
!

createTokenFor: string 
	| token |
	token := SmaCCToken 
				value: string
				start: start
				id: matchActions.
	outputStream reset.
	matchActions := nil.
	returnMatchBlock value: token
!

initialBufferSize
	^128
!

recordAndReportMatch: aCollection 
	self
		recordMatch: aCollection;
		reportLastMatch
!

recordMatch: aCollection 
	matchActions := aCollection.
	matchEnd := stream position.
	lastOutputStreamMatchPosition := outputStream position
!

reportLastMatch
        "The scanner has found the end of a token and must report it"

        | string |
        self checkForValidMatch.
        self resetOutputToLastMatch.
        stream position: matchEnd.
        string := outputStream contents.
        Smalltalk isSmalltalkX ifTrue:[
            outputStream reset.
        ].
        self checkForKeyword: string.

        matchActions isSymbol 
                ifTrue: [self perform: matchActions]
                ifFalse: [self createTokenFor: string]
!

resetOutputToLastMatch
        |streamStartPosition|

        outputStream position: lastOutputStreamMatchPosition.
        Smalltalk isSmalltalkX ifTrue:[
            streamStartPosition := outputStream class zeroPosition.
        ] ifFalse:[
            streamStartPosition := 0.
        ].
        lastOutputStreamMatchPosition == streamStartPosition 
                ifTrue: 
                        [lastMatchWasEmpty ifTrue: [self scannerError].
                        lastMatchWasEmpty := true]
                ifFalse: [lastMatchWasEmpty := false]
!

resetScanner
        start := stream position.
        outputStream reset.
        Smalltalk isSmalltalkX ifTrue:[
            lastOutputStreamMatchPosition := outputStream class zeroPosition .
        ] ifFalse:[
            lastOutputStreamMatchPosition := 0 .
        ].
!

scannerError
	(stream atEnd and: [start == stream position]) 
		ifTrue: 
			[returnMatchBlock value: (SmaCCToken 
						value: ''
						start: stream position
						id: (Array with: self emptySymbolTokenId))].
	stream position: start.
	returnMatchBlock value: (SmaCCToken 
				value: (String with: stream next)
				start: start
				id: #(0))
!

step
	stream atEnd ifTrue: [^self reportLastMatch].
	currentCharacter := stream next.
	outputStream nextPut: currentCharacter
! !

!SmaCCScanner methodsFor:'private-utility'!

keywordFor: aString 
	"Subclasses can override this to ignore case"

	^aString
! !

!SmaCCScanner methodsFor:'public'!

atEnd
	^stream atEnd
! !

!SmaCCScanner class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCScanner.st,v 1.1 2006-02-09 21:15:31 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

SmaCCScanner initialize!
