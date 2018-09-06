"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCParser subclass:#SmaCCScannerParser
	instanceVariableNames:'tokens'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Scanner Generator'
!

SmaCCScannerParser comment:'SmaCCScannerParser is the parser for the scanner definition.

Instance Variables:
	tokens	<Dictionary key: String value: SmaCCRegularExpressionNode>	the tokens that are parsed

'
!


!SmaCCScannerParser class methodsFor:'generated-accessing'!

scannerClass
	^SmaCC::SmaCCScannerScanner
! !

!SmaCCScannerParser class methodsFor:'generated-comments'!

parserDefinitionComment

	"%left   ""|"";
%left ""("" <character> <backslashcharacter> <characterblock> <anycharacter> <tokenname>;
%left ""*"" ""+"" ""?"" <repeat> ;

File: Rules      {tokens} 
        |  {tokens};

Rules: Rule "";""
        | Rules Rule "";"" ;

Rule: <tokenname> "":"" Regex {'3' position: '1' startPosition. tokens at: '1' value put: '3'. nil};

Regex: RegexTerm {'1'}
        | Regex ""|"" Regex {'1' | '3'}
        | Regex RegexTerm {'1' , '2'};

RegexTerm:      <character> {SmaCCCharacterRENode characters: '1' value}
        | <anycharacter> {SmaCCCharacterRENode characters: self allCharacters}
        | <backslashcharacter> {self nodeFor: (ReadStream on: ('1' value copyFrom: 2 to: '1' value size))} 
        | ""("" Regex "")"" {'2'}
        | <characterblock> {SmaCCCharacterRENode characters: (self parseCharacterBlock: '1')}
        | <tokenname> {(tokens at: '1' value) copy}
        | RegexTerm ""*"" {'1' repeat}
        | RegexTerm ""+"" {'1' repeatForAtLeast: 1}
        | RegexTerm ""?"" {'1' repeatFor: 0 to: 1}
        | RegexTerm <repeat> {| readStream start stop | 
                                        readStream := ReadStream on: ('2' value copyFrom: 2 to: '2' value size - 1). 
                                        start := readStream upTo: $,. 
                                        stop := readStream upToEnd.
                                        '1' repeatFor: (start isEmpty ifTrue: [0] ifFalse: [start asNumber]) to: (stop isEmpty ifTrue: [(1 bitShift: 31)] ifFalse: [stop asNumber])} ;
"
! !

!SmaCCScannerParser class methodsFor:'generated-starting states'!

startingStateForFile
	^1
! !

!SmaCCScannerParser methodsFor:'generated-reduction actions'!

reduceActionForFile1:nodes 
    ^ tokens
!

reduceActionForFile2:nodes 
    ^ tokens
!

reduceActionForRegex1:nodes 
    ^ nodes at:1
!

reduceActionForRegex2:nodes 
    ^ (nodes at:1) | (nodes at:3)
!

reduceActionForRegex3:nodes 
    ^ (nodes at:1) , (nodes at:2)
!

reduceActionForRegexTerm10:nodes 
    |readStream start stop|

    readStream := ReadStream 
                on:((nodes at:2) value copyFrom:2 to:(nodes at:2) value size - 1).
    start := readStream upTo:$,.
    stop := readStream upToEnd.
    ^ (nodes at:1) 
        repeatFor:(start isEmpty ifTrue:[ 0 ] ifFalse:[ start asNumber ])
        to:(stop isEmpty ifTrue:[ (1 bitShift:31) ] ifFalse:[ stop asNumber ])
!

reduceActionForRegexTerm1:nodes 
    ^ SmaCCCharacterRENode characters:(nodes at:1) value
!

reduceActionForRegexTerm2:nodes 
    ^ SmaCCCharacterRENode characters:self allCharacters
!

reduceActionForRegexTerm3:nodes 
    ^ self nodeFor:(ReadStream 
                on:((nodes at:1) value copyFrom:2 to:(nodes at:1) value size))
!

reduceActionForRegexTerm4:nodes 
    ^ nodes at:2
!

reduceActionForRegexTerm5:nodes 
    ^ SmaCCCharacterRENode characters:(self parseCharacterBlock:(nodes at:1))
!

reduceActionForRegexTerm6:nodes 
    ^ (tokens at:(nodes at:1) value) copy
!

reduceActionForRegexTerm7:nodes 
    ^ (nodes at:1) repeat
!

reduceActionForRegexTerm8:nodes 
    ^ (nodes at:1) repeatForAtLeast:1
!

reduceActionForRegexTerm9:nodes 
    ^ (nodes at:1) repeatFor:0 to:1
!

reduceActionForRule1:nodes 
    (nodes at:3) position:(nodes at:1) startPosition.
    tokens at:(nodes at:1) value put:(nodes at:3).
    ^ nil
! !

!SmaCCScannerParser methodsFor:'generated-tables'!

reduceTable
	^#(
#(17 1 #reduceFor:)
#(18 1 #reduceActionForFile1:)
#(18 0 #reduceActionForFile2:)
#(19 1 #reduceActionForRegex1:)
#(19 3 #reduceActionForRegex2:)
#(19 2 #reduceActionForRegex3:)
#(20 1 #reduceActionForRegexTerm1:)
#(20 1 #reduceActionForRegexTerm2:)
#(20 1 #reduceActionForRegexTerm3:)
#(20 3 #reduceActionForRegexTerm4:)
#(20 1 #reduceActionForRegexTerm5:)
#(20 1 #reduceActionForRegexTerm6:)
#(20 2 #reduceActionForRegexTerm7:)
#(20 2 #reduceActionForRegexTerm8:)
#(20 2 #reduceActionForRegexTerm9:)
#(20 2 #reduceActionForRegexTerm10:)
#(23 2 #reduceFor:)
#(23 3 #reduceFor:)
#(24 3 #reduceActionForRule1:)
)
!

transitionTable
	^#(
#[1 0 9 0 12 0 13 0 18 0 14 0 21 0 17 0 23 0 21 0 24]
#[0 0 25 0 7]
#[0 0 0 0 21]
#[1 0 9 0 12 0 10 0 21 0 29 0 24]
#[0 0 33 0 8]
#[1 0 37 0 1 0 41 0 9 0 45 0 10 0 49 0 12 0 53 0 15 0 57 0 16 0 61 0 19 0 65 0 20]
#[0 0 69 0 8]
#[0 0 70 0 12 0 21]
#[1 0 37 0 1 0 41 0 9 0 45 0 10 0 49 0 12 0 53 0 15 0 57 0 16 0 73 0 19 0 65 0 20]
#[0 0 38 0 1 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 46 0 1 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 50 0 1 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 30 0 1 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 34 0 1 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[1 0 37 0 1 0 77 0 2 0 78 0 8 0 41 0 9 0 45 0 10 0 49 0 12 0 53 0 15 0 57 0 16 0 81 0 20]
#[1 0 18 0 1 0 18 0 2 0 85 0 3 0 18 0 4 0 89 0 5 0 93 0 6 0 18 0 8 0 18 0 9 0 18 0 10 0 18 0 12 0 97 0 14 0 18 0 15 0 18 0 16]
#[0 0 74 0 12 0 21]
#[1 0 37 0 1 0 77 0 2 0 101 0 4 0 41 0 9 0 45 0 10 0 49 0 12 0 53 0 15 0 57 0 16 0 81 0 20]
#[1 0 37 0 1 0 41 0 9 0 45 0 10 0 49 0 12 0 53 0 15 0 57 0 16 0 105 0 19 0 65 0 20]
#[1 0 26 0 1 0 26 0 2 0 85 0 3 0 26 0 4 0 89 0 5 0 93 0 6 0 26 0 8 0 26 0 9 0 26 0 10 0 26 0 12 0 97 0 14 0 26 0 15 0 26 0 16]
#[0 0 54 0 1 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 58 0 1 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 62 0 1 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 66 0 1 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 42 0 1 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[1 0 37 0 1 0 22 0 2 0 22 0 4 0 22 0 8 0 41 0 9 0 45 0 10 0 49 0 12 0 53 0 15 0 57 0 16 0 81 0 20]
)
! !

!SmaCCScannerParser methodsFor:'initialize-release'!

initialize
	super initialize.
	tokens := Dictionary new
! !

!SmaCCScannerParser methodsFor:'private'!

allCharacters
        ^UnicodeString withAll: ((0 to: SmaCCGrammar maximumCharacterValue) 
                                collect: [:each | Character value: each])

    "Modified: / 26-05-2006 / 22:16:45 / janfrog"
!

charactersFor: aStream in: aToken 
	| characters char endCharacters |
	aStream atEnd ifTrue: [self reportCharacterBlockErrorForToken: aToken].
	char := aStream next.
	characters := char == $\ 
				ifTrue: [(self nodeFor: aStream) characters]
				ifFalse: [OrderedCollection with: char].
	(characters size = 1 and: [aStream peekFor: $-]) ifFalse: [^characters].
	endCharacters := self charactersFor: aStream in: aToken.
	endCharacters size > 1 
		ifTrue: [self reportCharacterBlockErrorForToken: aToken].
	^(characters first asInteger to: endCharacters first asInteger) 
		collect: [:each | Character value: each]
!

nodeFor: aStream 
	| block char value count |
	char := aStream next.
	char == $f 
		ifTrue: 
			[^SmaCCCharacterRENode characters: (String with: (Character value: 12))].
	char == $n 
		ifTrue: 
			[^SmaCCCharacterRENode characters: (String with: (Character value: 10))].
	char == $r 
		ifTrue: 
			[^SmaCCCharacterRENode characters: (String with: (Character value: 13))].
	char == $t ifTrue: [^SmaCCCharacterRENode characters: '	'].
	char == $v 
		ifTrue: 
			[^SmaCCCharacterRENode characters: (String with: (Character value: 11))].
	char == $c 
		ifTrue: 
			[^SmaCCCharacterRENode characters: (String 
						with: (Character value: aStream next asInteger - $A asInteger))].
	char == $x 
		ifTrue: 
			[count := value := 0.
			
			[aStream atEnd not and: 
					[count < 4 and: 
							[char := aStream peek.
							(char between: $0 and: $9) 
								or: [(char between: $A and: $F) or: [char between: $a and: $f]]]]] 
					whileTrue: 
						[count := count + 1.
						value := value * 16 + aStream next digitValue].
			^SmaCCCharacterRENode characters: (String with: (Character value: value))].
	char == $d ifTrue: [block := [:each | each between: $0 and: $9]].
	char == $D ifTrue: [block := [:each | (each between: $0 and: $9) not]].
	char == $s 
		ifTrue: [block := [:each | #[9 10 11 12 13 32] includes: each asInteger]].
	char == $S 
		ifTrue: 
			[block := [:each | (#[9 10 11 12 13 32] includes: each asInteger) not]].
	char == $w 
		ifTrue: 
			[block := 
					[:each | 
					(each between: $a and: $z) or: 
							[(each between: $A and: $Z) 
								or: [(each between: $0 and: $9) or: [each == $_]]]]].
	char == $W 
		ifTrue: 
			[block := 
					[:each | 
					((each between: $a and: $z) or: 
							[(each between: $A and: $Z) 
								or: [(each between: $0 and: $9) or: [each == $_]]]) 
						not]].
	block isNil 
		ifTrue: [^SmaCCCharacterRENode characters: (String with: char)].
	^SmaCCCharacterRENode 
		characters: (String withAll: (self allCharacters select: block))
!

parseCharacterBlock: aToken 
        | characters aStream invert |
        aStream := ReadStream 
                                on: (aToken value copyFrom: 2 to: aToken value size - 1).
        characters := OrderedCollection new.
        invert := aStream peekFor: $^.
        [aStream atEnd] 
                whileFalse: [characters addAll: (self charactersFor: aStream in: aToken)].
        ^UnicodeString withAll: (invert 
                                ifTrue: [self allCharacters reject: [:each | characters includes: each]]
                                ifFalse: [characters])

    "Modified: / 26-05-2006 / 22:17:06 / janfrog"
!

reportCharacterBlockErrorForToken: aToken 
	currentToken := aToken.
	self reportErrorMessage: 'Invalid character block'
! !

!SmaCCScannerParser class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCScannerParser.st,v 1.2 2006-05-28 20:10:22 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
