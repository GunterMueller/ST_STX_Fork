"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPPredicateTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Tests'
!


!PPPredicateTest methodsFor:'private'!

charactersDo: aBlock
	1 to: 256 do: [ :index | aBlock value: (Character codePoint: index) ]
! !

!PPPredicateTest methodsFor:'testing'!

testOnMessage
	| block parser |
	block := [ :char | char = $* ].
	parser := PPPredicateObjectParser on: block message: 'starlet'.
	self assert: parser block equals: block.
	self assert: parser message equals: 'starlet'.
	self assertCharacterSets: parser.
	self assert: parser parse: '*' to: $*.
	self
		assert: parser
		parse: '**'
		to: $*
		end: 1.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'
! !

!PPPredicateTest methodsFor:'testing-chars'!

testBlank
	| parser |
	parser := #blank asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character space) to: Character space.
	self assert: parser parse: (String with: Character tab) to: Character tab.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: (String with: Character cr)
!

testChar
	| parser |
	parser := $* asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: '*' to: $*.
	self assert: parser parse: '**' to: $* end: 1.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'
!

testCr
	| parser |
	parser := #cr asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: (Character codePoint: 13)) to: (Character codePoint: 13)
!

testDigit
	| parser |
	parser := #digit asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: '0' to: $0.
	self assert: parser parse: '9' to: $9.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'
!

testEndOfFile
	| parser |
	parser := (#letter asParser / #blank asParser) star, #eof asParser.
	
	self assert: parser parse: 'lorem ipsum'.
	
	parser := #any asParser, #eof asParser, #any asParser star.
	self assert: parser fail: 'a', Character cr asString, 'b'.
	self assert: parser fail: Character cr asString , Character lf asString.
	self assert: parser parse: 'a'.
!

testEndOfLine
        | cr crlf lf parser |
        cr := (Character codePoint: 13) asString.
        crlf := (Character codePoint: 13) , Character lf asString.
        lf := Character lf asString.
        parser := (#letter asParser / #blank asParser) star, #endOfLine asParser.
        
        self assert: parser parse: 'lorem ipsum'.
        
        parser := #any asParser, #endOfLine asParser, #any asParser star.
        self assert: parser parse: 'a', cr, 'b'.
        self assert: parser fail: crlf.
        self assert: parser fail: 'lorem ipsum'.
        
        parser := #endOfLine asParser, #any asParser, #endOfLine asParser negate star, #endOfLine asParser.
        self assert: parser parse: cr, 'lorem ipsum'.
        self assert: parser parse: lf, 'lorem ipsum'.   
        self assert: parser parse: crlf, 'lorem ipsum'. 
        
        self assert: parser parse: crlf.
        self assert: parser parse: cr.
        self assert: parser parse: lf.
        
        parser := #endOfLine asParser negate star, #endOfLine asParser, #any asParser star.
        self assert: parser parse: crlf, 'lorem ipsum'.
        self assert: parser parse: crlf.

    "Modified: / 13-04-2015 / 21:55:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testHex
	| parser |
	parser := #hex asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: '0' to: $0.
	self assert: parser parse: '5' to: $5.
	self assert: parser parse: '9' to: $9.
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: 'D' to: $D.
	self assert: parser parse: 'F' to: $F.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'e' to: $e.
	self assert: parser parse: 'f' to: $f.
	self assert: parser fail: ''.
	self assert: parser fail: 'g'
!

testLetter
	| parser |
	parser := #letter asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'Z' to: $Z.
	self assert: parser fail: ''.
	self assert: parser fail: '0'
!

testLf
	| parser |
	parser := #lf asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character lf) to: Character lf
!

testLowercase
	| parser |
	parser := #lowercase asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'z' to: $z.
	self assert: parser fail: ''.
	self assert: parser fail: 'A'.
	self assert: parser fail: '0'
!

testNewline
	| parser |
	parser := #newline asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character cr) to: Character cr.
	self assert: parser parse: (String with: Character lf) to: Character lf.
	self assert: parser fail: ' '
!

testPunctuation
	| parser |
	parser := #punctuation asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: '.' to: $..
	self assert: parser parse: ',' to: $,.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: '1'
!

testSpace
	| parser |
	parser := #space asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character tab) to: Character tab.
	self assert: parser parse: ' ' to: Character space.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'
!

testStartOfLine
        | cr crlf lf parser |
        cr := (Character codePoint: 13) asString.
        crlf := (Character codePoint: 13) , Character lf asString.
        lf := Character lf asString.
        parser := #startOfLine asParser, #any asParser star.
        
        self assert: parser parse: 'lorem ipsum'.
        
        parser := #any asParser, #startOfLine asParser, #any asParser star.
        self assert: parser fail: 'lorem ipsum'.
        
        parser := #startOfLine asParser, #any asParser, #startOfLine asParser, #any asParser star.
        self assert: parser parse: cr, 'lorem ipsum'.
        self assert: parser parse: lf, 'lorem ipsum'.   
        self assert: parser fail: crlf, 'lorem ipsum'.  
        
        self assert: parser fail: crlf.
        self assert: parser parse: cr.
        self assert: parser parse: lf.
        
        parser := #startOfLine asParser, #any asParser, #any asParser, #startOfLine asParser, #any asParser star.
        self assert: parser parse: crlf, 'lorem ipsum'.
        self assert: parser parse: crlf.

    "Modified: / 13-04-2015 / 21:56:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testStartOfLogicalLine
	| parser |
	parser := #startOfLogicalLine asParser, #any asParser star.
	
	self assert: parser parse: 'lorem'.
	self assert: parser fail: ' lorem'.
	
	parser := #any asParser, #startOfLogicalLine asParser, #any asParser star.
	self assert: parser fail: 'lorem'.
	self assert: parser fail: '        lorem'.
	self assert: parser parse: ' lorem'.
	self assert: parser parse: '	lorem'.
!

testStartOfWord
	| parser |
	parser := #startOfWord asParser, #word asParser plus.
	
	self assert: parser parse: 'lorem'.
	
	parser := #any asParser, #startOfWord asParser, #word asParser plus.
	self assert: parser fail: 'lorem'.
	self assert: parser fail: '1234'.
	
	self assert: parser parse: ' lorem'.	
	self assert: parser parse: ' 123'.
	self assert: parser parse: ')lorem'.
	self assert: parser parse: ':lorem'.
	
	parser := #startOfWord asParser, #any asParser optional.
	self assert: parser fail: ''.
	self assert: parser parse: 'a'.
	self assert: parser fail: '.'.
!

testTab
	| parser |
	parser := #tab asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character tab) to: Character tab
!

testUppercase
	| parser |
	parser := #uppercase asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: 'Z' to: $Z.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: '0'
!

testWord
	| parser |
	parser := #word asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: '0' to: $0.
	self assert: parser fail: ''.
	self assert: parser fail: '-'
! !

!PPPredicateTest methodsFor:'testing-objects'!

testAny
	| parser |
	parser := #any asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: ' ' to: $ .
	self assert: parser parse: '1' to: $1.
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: ''
!

testAnyExceptAnyOf
	| parser |
	parser := PPPredicateObjectParser anyExceptAnyOf: #($: $,).
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'z' to: $z.
	self assert: parser fail: ':'.
	self assert: parser fail: ','
!

testAnyOf
	| parser |
	parser := PPPredicateObjectParser anyOf: #($a $z).
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'z' to: $z.
	self assert: parser fail: 'x'
!

testBetweenAnd
	| parser |
	parser := PPPredicateObjectParser between: $b and: $d.
	self assertCharacterSets: parser.
	self assert: parser fail: 'a'.
	self assert: parser parse: 'b' to: $b.
	self assert: parser parse: 'c' to: $c.
	self assert: parser parse: 'd' to: $d.
	self assert: parser fail: 'e'
!

testExpect
	| parser |
	parser := PPPredicateObjectParser expect: $a.
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: 'b'.
	self assert: parser fail: ''
! !

!PPPredicateTest methodsFor:'testing-sequence'!

testSequenceParser
	| parser |
	parser := PPPredicateSequenceParser
		on: [ :value | value first isUppercase ]
		message: 'uppercase 3 letter words'
		size: 3.
	self assert: parser size equals: 3.
	self assert: parser parse: 'Abc'.
	self assert: parser parse: 'ABc'.
	self assert: parser parse: 'ABC'.
	self assert: parser fail: 'abc'.
	self assert: parser fail: 'aBC'.
	self assert: parser fail: 'Ab'.
	parser := parser negate.
	self assert: parser size equals: 3.
	self assert: parser fail: 'Abc'.
	self assert: parser fail: 'ABc'.
	self assert: parser fail: 'ABC'.
	self assert: parser parse: 'abc'.
	self assert: parser parse: 'aBC'.
	self assert: parser fail: 'Ab'
! !

!PPPredicateTest methodsFor:'utilities'!

assertCharacterSets: aParser
	"Assert the character set of aParser does not overlap with the character set with the negated parser, and that they both cover the complete character space."

	| positives negatives |
	positives := self parsedCharacterSet: aParser.
	negatives := self parsedCharacterSet: aParser negate.
	self charactersDo: [ :char | 
		| positive negative |
		positive := positives includes: char.
		negative := negatives includes: char.
		self 
			assert: ((positive and: [ negative not ])
				or: [ positive not and: [ negative ] ])
			description: char printString , ' should be in exactly one set' ]
!

parsedCharacterSet: aParser
	| result |
	result := String new writeStream.
	self charactersDo: [ :char |
		(aParser matches: (char asString))
			ifTrue: [ result nextPut: char ] ].
	^ result contents
! !

!PPPredicateTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPPredicateTest.st,v 1.6 2014-03-04 20:09:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPPredicateTest.st,v 1.6 2014-03-04 20:09:46 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPPredicateTest.st,v 1.6 2014-03-04 20:09:46 cg Exp $'
! !

