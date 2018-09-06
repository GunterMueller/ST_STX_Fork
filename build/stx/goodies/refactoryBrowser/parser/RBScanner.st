"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

Stream subclass:#RBScanner
	instanceVariableNames:'stream buffer tokenStart currentCharacter characterType
		classificationTable numberType separatorsInLiterals
		extendedLiterals extendedSymbols extendedSymbols2 saveComments
		commentsBeforeToken commentsAfterToken extendedLanguage
		errorBlock nameSpaceCharacter stxEOLComments stxTokenComments
		nameSpaceCharacterIsDoubled nameSpaceCharacter2
		nameSpaceCharacter2IsDoubled allowOldStyleAssignment
		forceOldStyleAssignment lineStartPosition lineNumber
		tokenLineNumber tokenNumberBase tokensSoFar
		allowSymbolsStartingWithColon'
	classVariableNames:'ClassificationTable MetaVariableCharacter
		PatternVariableCharacter'
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBScanner class methodsFor:'instance creation'!

on:aStream 
    |str|

    str := self basicNew on:aStream.
    str
        step;
        stripSeparators.
    ^ str
!

on:aStream errorBlock:aBlock 
    |str|

    str := self basicNew on:aStream.
    str
        errorBlock:aBlock;
        step;
        stripSeparators.
    ^ str
!

rewriteOn:aStream 
    |str|

    str := self basicNew on:aStream.
    str
        extendedLanguage:true;
        ignoreComments;
        step;
        stripSeparators.
    ^ str
!

rewriteOn:aStream errorBlock:aBlock 
    |str|

    str := self basicNew on:aStream.
    str
        extendedLanguage:true;
        ignoreComments;
        errorBlock:aBlock;
        step;
        stripSeparators.
    ^ str
!

rewriteSavingCommentsOn:aStream 
    |str|

    str := self basicNew on:aStream.
    str
        extendedLanguage:true;
        saveComments;
        step;
        stripSeparators.
    ^ str

    "Created: / 24-05-2014 / 01:03:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rewriteSavingCommentsOn:aStream errorBlock:aBlock 
    |str|

    str := self basicNew on:aStream.
    str
        extendedLanguage:true;
        saveComments;
        errorBlock:aBlock;
        step;
        stripSeparators.
    ^ str

    "Created: / 24-05-2014 / 01:01:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchOn:aStream errorBlock:aBlock 
    |str|

    str := self basicNew on:aStream.
    str
        ignoreComments;
        errorBlock:aBlock;
        step;
        stripSeparators.
    ^ str
! !

!RBScanner class methodsFor:'accessing'!

classificationTable
	ClassificationTable isNil ifTrue: [self initialize].
	^ClassificationTable
!

metaVariableCharacter
        <resource: #obsolete>
        ^MetaVariableCharacter
!

patternVariableCharacter
	^PatternVariableCharacter
! !

!RBScanner class methodsFor:'class initialization'!

initialize
	MetaVariableCharacter := $`.
	PatternVariableCharacter := $`.
	ClassificationTable := Array new: 255.
	self initializeChars: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_' to: #alphabetic.
	self initializeChars: '01234567890' to: #digit.
	self initializeChars: '!!%&*+,-/<=>?@\~|' to: #binary.
	ClassificationTable at: 177 put: #binary.       "plus-or-minus"
	ClassificationTable at: 183 put: #binary.       "centered dot"
	ClassificationTable at: 215 put: #binary.       "times"
	ClassificationTable at: 247 put: #binary.       "divide"
"        self initializeChars: '().:;[]^' to: #special. "
	" Squeak support ... "
	self initializeChars: '{}().:;[]^' to: #special.
	" ST/X primitive support "
	RBParser isSmalltalkX ifTrue:[
	    self initializeChars: '%' to: #special.
	].
	#(9 10 12 13 26 32) do: [:i | ClassificationTable at: i put: #separator]

       "
	self initialize
       "
!

initializeChars: characters to: aSymbol 
	characters do: [:c | ClassificationTable at: c asInteger put: aSymbol]
! !

!RBScanner class methodsFor:'testing'!

isSelector: aSymbol 
	| scanner token |
	scanner := self basicNew.
	scanner on: (ReadStream on: aSymbol asString).
	scanner step.
	token := scanner scanAnySymbol.
	token isLiteral ifFalse: [^false].
	token value isEmpty ifTrue: [^false].
	^scanner atEnd
!

isVariable: aString 
	| scanner token |
	aString isString ifFalse: [^false].
	aString isEmpty ifTrue: [^false].
	(ClassificationTable at: aString first asInteger) == #alphabetic
		ifFalse: [^false].
	scanner := self basicNew.
	scanner on: (ReadStream on: aString asString).
	scanner errorBlock: [:s :p | ^false].
	scanner step.
	token := scanner scanIdentifierOrKeyword.
	token isKeyword ifTrue: [^false].
	^scanner atEnd
! !

!RBScanner methodsFor:'accessing'!

addToCommentsBeforeToken:aCollection
    aCollection notNil ifTrue:[
        commentsBeforeToken isNil ifTrue: [
            commentsBeforeToken := OrderedCollection new.
        ].
        commentsBeforeToken addAll:aCollection
    ]
!

classificationTable: anObject
	classificationTable := anObject
!

contents
	| contentsStream |
	contentsStream := WriteStream on: (Array new: 50).
	self do: [:each | contentsStream nextPut: each].
	^contentsStream contents
!

currentCharacter
    ^ currentCharacter
!

errorBlock: aBlock 
	errorBlock := aBlock
!

extendedLanguage
	^extendedLanguage
!

extendedLanguage: aBoolean 
	extendedLanguage := aBoolean
!

flush
!

getComments
        commentsAfterToken size > 0 ifTrue:[  
            commentsBeforeToken isNil ifTrue: [
                commentsBeforeToken := OrderedCollection new.
            ].
            commentsBeforeToken addAll:commentsAfterToken.
            commentsAfterToken := nil.
        ].
        ^ self getCommentsBeforeToken
!

getCommentsAfterToken
        | oldComments |

        commentsAfterToken isEmptyOrNil ifTrue: [^nil].

        oldComments := commentsAfterToken.
        commentsAfterToken := nil.
        ^oldComments
!

getCommentsAfterTokenIfInLine:lineNrArg
        | comments lineNr |

        commentsAfterToken isEmptyOrNil ifTrue: [^nil].
        lineNr := lineNrArg ? lineNumber.
        comments := commentsAfterToken select:[:aComment | aComment lineNumber <= lineNr].
        commentsAfterToken := commentsAfterToken select:[:aComment | aComment lineNumber > lineNr].

        ^ comments
!

getCommentsBeforeToken
        | oldComments |

        commentsBeforeToken isEmptyOrNil ifTrue: [^nil].

        oldComments := commentsBeforeToken.
        commentsBeforeToken := nil.
        ^oldComments
!

ignoreComments
	saveComments := false
!

nextPut: anObject 
	"Provide an error notification that the receiver does not
	implement this message."

	self shouldNotImplement
!

rememberTokens:aBoolean
    aBoolean ifTrue:[
        tokensSoFar := OrderedCollection new.
    ].
!

rememberedTokens
    ^ tokensSoFar
!

saveComments
	saveComments := true
!

saveComments:aBoolean
    saveComments := aBoolean
!

stream
    ^ stream
!

tokenLineNumber
    ^ tokenLineNumber
! !

!RBScanner methodsFor:'error handling'!

errorBlock
	^errorBlock isNil
		ifTrue: [[:message :position | ]]
		ifFalse: [errorBlock]
!

errorPosition
        ^stream position
!

scannerError: aString 
        "Evaluate the block. If it returns raise an error"

        |errorBlock errorPosition|

        errorPosition := self errorPosition.
        errorBlock := self errorBlock.
        errorBlock notNil ifTrue:[
            errorBlock valueWithOptionalArgument:aString and:errorPosition and:#() and:nil.
"/            proceedAfterError == true ifTrue:[^ self].
        ].

        Compiler parseErrorSignal new
            errorMessage:aString startPosition:errorPosition;
            raiseRequest

"/        self errorBlock value: aString value: self errorPosition.
"/        self error: aString

    "Modified: / 13-01-2012 / 11:53:31 / cg"
! !

!RBScanner methodsFor:'initialization & release'!

initializeForIBM
        numberType := #scanNumberIBM.
        separatorsInLiterals := false.
        extendedLiterals := true.
        extendedSymbols := false.
        nameSpaceCharacter := $:.
        stxEOLComments := false.
        stxTokenComments := false.
        forceOldStyleAssignment := allowOldStyleAssignment := false.
        allowSymbolsStartingWithColon := false.
!

initializeForSmalltalkX
        numberType := #scanNumberVisualWorks.
        separatorsInLiterals := true.
        extendedLiterals := false.
        extendedSymbols := false.
        extendedSymbols2 := true.
        nameSpaceCharacter := $:.
        nameSpaceCharacterIsDoubled := true.
        nameSpaceCharacter2 := $..
        nameSpaceCharacter2IsDoubled := false.
        stxEOLComments := true.
        stxTokenComments := true.   
        allowOldStyleAssignment := true.
        forceOldStyleAssignment := false.
        allowSymbolsStartingWithColon := false.

    "Modified: / 19.11.1999 / 18:29:44 / cg"
!

initializeForSqueak
        numberType := #scanNumberVisualWorks.
        separatorsInLiterals := true.
        extendedLiterals := false.
        extendedSymbols := true.
        nameSpaceCharacter := $..
        nameSpaceCharacterIsDoubled := false.
        stxEOLComments := false.
        stxTokenComments := false.
        allowOldStyleAssignment := true.
        forceOldStyleAssignment := true.
        allowSymbolsStartingWithColon := true.

    "Modified: / 19.11.1999 / 18:29:44 / cg"
!

initializeForVisualWorks
        numberType := #scanNumberVisualWorks.
        separatorsInLiterals := true.
        extendedLiterals := false.
        extendedSymbols := false.
        (Smalltalk includesKey: #QualifiedName) ifTrue: [nameSpaceCharacter := $.].
        stxEOLComments := false.
        stxTokenComments := false.
        forceOldStyleAssignment := allowOldStyleAssignment := false.
        allowSymbolsStartingWithColon := false.
!

on: aStream 
        (Smalltalk isSmalltalkX) ifTrue:[
            buffer := CharacterWriteStream on: (String new: 60).
        ] ifFalse:[
            buffer := WriteStream on: (String new: 60).
        ].
        lineNumber := 1.
        stream := aStream.
        classificationTable := self class classificationTable.
        saveComments := true.
        extendedLanguage := false.
        commentsBeforeToken := nil. "/ OrderedCollection new.
        commentsAfterToken := nil. "/ OrderedCollection new.

        separatorsInLiterals := false.
        extendedLiterals := false.
        extendedSymbols := false.
        nameSpaceCharacter := nil.
        stxEOLComments := false.
        stxTokenComments := false.
        forceOldStyleAssignment := false.
        allowOldStyleAssignment := false.
        extendedSymbols := false.
        extendedSymbols2 := false.

        RBParser isIBM 
            ifTrue: [self initializeForIBM]
            ifFalse:[
                RBParser isVisualWorks 
                    ifTrue: [
                        (RBParser isSmalltalkX)
                            ifTrue:[self initializeForSmalltalkX]
                            ifFalse:[self initializeForVisualWorks]
                    ]
                    ifFalse:[
                        RBParser isSqueak ifTrue: [ self initializeForSqueak].
                    ]
            ]

    "Modified: / 27-04-2010 / 17:45:06 / cg"
! !

!RBScanner methodsFor:'private'!

bufferContents
    Smalltalk isSmalltalkX ifTrue:[
        ^ buffer contents asSingleByteStringIfPossible
    ].
    ^ buffer contents
!

classify: aCharacter  
        | index |

        aCharacter isNil ifTrue: [^nil].
        index := aCharacter codePoint.
        index == 0 ifTrue: [^#separator].
        index > 255 ifTrue: [^nil].
        ^classificationTable at: index
!

previousStepPosition
        ^characterType == #eof 
                ifTrue: [stream position]
                ifFalse: [stream position - 1]
!

step
        stream atEnd ifTrue: 
                        [characterType := #eof.
                        ^currentCharacter := nil].
        currentCharacter := stream next.
        characterType := self classify: currentCharacter.
        currentCharacter == Character cr ifTrue:[
            lineStartPosition := stream position.
            lineNumber := lineNumber + 1.
        ].

        tokenStart isNil ifTrue:[
            "/ only happens if scan methods are called not via #next;
            "/ for example via the isVariable: query.
            tokenStart := stream position.
            tokenLineNumber := lineNumber.
        ].
        ^currentCharacter
! !

!RBScanner methodsFor:'private-scanning'!

scanAnySymbol
        characterType == #alphabetic ifTrue: [^self scanSymbol].
        characterType == #binary ifTrue: [^self scanBinary: RBLiteralToken].
        ^RBEndOfFileToken new

    "Modified: / 06-03-2012 / 11:19:55 / cg"
!

scanBinary: aClass alreadyRead:prevCharacter
        "This doesn't parse according to the ANSI draft. It only parses 1 or 2 letter binary tokens."

        | val scanMore |

        prevCharacter notNil ifTrue:[ buffer nextPut: prevCharacter ].

        scanMore := false.
        currentCharacter notNil ifTrue:[
            (characterType == #binary and: [currentCharacter ~~ $-]) ifTrue:[
                buffer nextPut: currentCharacter.
                self step.
                Smalltalk isSmalltalkX ifTrue:[ scanMore := true ].
            ] ifFalse:[
                Smalltalk isSmalltalkX ifTrue:[
                    currentCharacter == $: ifTrue:[
                        buffer nextPut: currentCharacter.
                        self step.
                        scanMore := true.
                    ] ifFalse:[
                        "/ allow something like <- as a binary selector,
                        "/ but only if not followed by a digit;
                        "/ <-nnn makes it < -nnn (i.e. the minus is the sign of the number)
                        (currentCharacter == $-) ifTrue:[
                            (stream atEnd or:[stream peek isDigit not]) ifTrue:[
                                buffer nextPut: currentCharacter.
                                self step.
                                scanMore := true.
                            ]
                        ]
                    ]
                ].
            ].
        ].

        "/ st/x supports longer binary tokens
        Smalltalk isSmalltalkX ifTrue:[
            scanMore ifTrue:[ ^ self scanBinary: aClass alreadyRead:nil]
        ].

        val := self bufferContents.
        val := val asSymbol.
        ^ aClass value: val start: tokenStart lineNumber: tokenLineNumber.

    "Modified: / 14-07-2011 / 16:51:26 / cg"
!

scanByteArray
        | start byteStream tokenStream startLineNumber elementToken number arrayToken
          firstElement startCol tokenCol|

        byteStream := WriteStream on: (ByteArray new: 100).
        tokenStream := WriteStream on:(Array new:100).

        startCol := stream position - 1 - (lineStartPosition ? 0).

        self step.
        start := tokenStart.
        firstElement := true.

        [
            self stripSeparators.
            tokenStart := stream position.
            tokenLineNumber := lineNumber.
            tokenCol := stream position - 1 - (lineStartPosition ? 0).
            firstElement ifTrue:[startLineNumber := tokenLineNumber].
            firstElement := false.
            characterType == #digit
        ] whileTrue: 
            [
            elementToken := self scanNumber.
            elementToken columnNumber: tokenCol.

            number := elementToken value.
            (number isInteger and: [number between: 0 and: 255]) 
                    ifFalse: [self scannerError: 'Expecting 8-bit integer'].
            tokenStream nextPut:elementToken.
            byteStream nextPut: number].

        currentCharacter == $] ifFalse: [self scannerError: ''']'' expected'].
        self step.      

        arrayToken := RBLiteralByteArrayToken 
                value: byteStream contents
                start: start
                stop: self previousStepPosition
                lineNumber: startLineNumber.
        arrayToken columnNumber: startCol.
        arrayToken elementTokens:tokenStream contents.
        ^ arrayToken
!

scanExponentMultipler
	| exponent isExpNegative position |
	currentCharacter == $e
		ifTrue: 
			[position := stream position.
			self step.
			(isExpNegative := currentCharacter == $-) ifTrue: [self step].
			exponent := self scanNumberOfBase: 10.
			exponent isNil
				ifTrue: 
					["Did not read a valid exponent, e must be start of a message send"

					stream position: position - 1.
					self step.
					exponent := 0]
				ifFalse: [isExpNegative ifTrue: [exponent := exponent negated]]]
		ifFalse: [exponent := 0].
	^10 raisedToInteger: exponent
!

scanExtendedLiterals
        | token |
        self step.
        separatorsInLiterals ifTrue: [self stripSeparators].
        characterType == #alphabetic 
                                ifTrue: [token := self scanSymbol]
                                ifFalse: 
                                        [characterType == #binary 
                                                ifTrue: [token := (self scanBinary: RBLiteralToken) start:tokenStart stop: self previousStepPosition]
                                                ifFalse: 
                                                        [currentCharacter == $' 
                                                                ifTrue: [token := self scanStringSymbol]
                                                                ifFalse: 
                                                                        [currentCharacter == $( 
                                                                                ifTrue: 
                                                                                        [self step.
                                                                                        ^RBOptimizedToken start: tokenStart lineNumber:tokenLineNumber]]]].
        token isNil ifTrue: [self scannerError: 'Expecting a extended literal'].
        (Smalltalk isSmalltalkX) ifFalse:[
            token value: ((Smalltalk at: #EsAtom) intern: token value asString).
        ].
        ^token
!

scanExtendedSymbol
    "scan symbols like #. which are allowed by Squeak and ST/X but aren't standard"

    | token |

    token := RBLiteralToken value: (currentCharacter asString asSymbol) start: tokenStart stop: stream position.
    token lineNumber:tokenLineNumber.
    self step.
    ^token
!

scanIdentifierOrKeyword
        | tokenType token name |
        self scanName.

        nameSpaceCharacterIsDoubled ifTrue:[
            (currentCharacter == nameSpaceCharacter
            and:[stream peek == nameSpaceCharacter])
                    ifTrue: 
                            [token := self scanNamespaceName.
                            token notNil ifTrue: [^token]].
        ] ifFalse:[
            currentCharacter == nameSpaceCharacter
                    ifTrue: 
                            [token := self scanNamespaceName.
                            token notNil ifTrue: [^token]].
        ].

        nameSpaceCharacter2 notNil ifTrue:[
            nameSpaceCharacter2IsDoubled ifTrue:[
                (currentCharacter == nameSpaceCharacter2
                and:[stream peek == nameSpaceCharacter2])
                        ifTrue: 
                                [token := self scanNamespaceName.
                                token notNil ifTrue: [^token]].
            ] ifFalse:[
                currentCharacter == nameSpaceCharacter2
                        ifTrue: 
                                [token := self scanNamespaceName.
                                token notNil ifTrue: [^token]].
            ].
        ].

        (currentCharacter == $: and: [stream peek ~~ $=]) 
                ifTrue: 
                        [buffer nextPut: currentCharacter.
                        self step.      ":"
                        tokenType := RBKeywordToken]
                ifFalse: [tokenType := RBIdentifierToken].

        name := self bufferContents.
        name = 'true' 
                ifTrue: 
                        [^RBLiteralToken 
                                value: true
                                start: tokenStart
                                stop: self previousStepPosition
                                lineNumber: tokenLineNumber].
        name = 'false' 
                ifTrue: 
                        [^RBLiteralToken 
                                value: false
                                start: tokenStart
                                stop: self previousStepPosition
                                lineNumber: tokenLineNumber].
        name = 'nil' 
                ifTrue: 
                        [^RBLiteralToken 
                                value: nil
                                start: tokenStart
                                stop: self previousStepPosition
                                lineNumber: tokenLineNumber].
        ^tokenType value: name start: tokenStart lineNumber: tokenLineNumber

    "Modified: / 19.11.1999 / 18:30:16 / cg"
!

scanLiteralArray
        | arrayStream start startLineNumber firstElement startCol arrayToken tokenCol
          elementToken|

        arrayStream := WriteStream on: (Array new: 10).

        startCol := stream position - 1 - (lineStartPosition ? 0).

        self step.
        start := tokenStart.
        firstElement := true.

        [
            self stripSeparators.
            tokenStart := stream position.
            tokenLineNumber := lineNumber.
            tokenCol := stream position - 1 - (lineStartPosition ? 0).
            firstElement ifTrue:[startLineNumber := tokenLineNumber].
            firstElement := false.
            currentCharacter == $)
        ] whileFalse: 
            [elementToken := self scanLiteralArrayParts.
            elementToken columnNumber: tokenCol.
            arrayStream nextPut: elementToken.
            buffer reset].

        self step.
        arrayToken := RBLiteralToken 
                value: arrayStream contents
                start: start
                stop: self previousStepPosition
                lineNumber: startLineNumber.                         
        arrayToken columnNumber: startCol.
        ^ arrayToken
!

scanLiteralCharacter
        | token |
        self step.      "$"
        token := RBLiteralToken 
                                value: currentCharacter
                                start: tokenStart
                                stop: stream position
                                lineNumber: tokenLineNumber.
        self step.      "char"
        ^token
!

scanLiteralString
        ^ self scanLiteralString:RBLiteralToken

    "Modified: / 09-08-2012 / 10:39:58 / cg"
!

scanLiteralString:class 
        self step.
        
        [currentCharacter isNil 
                ifTrue: [self scannerError: 'Unmatched '' in string literal.'].
        currentCharacter == $' and: [self step ~~ $']] 
                        whileFalse: 
                                [buffer nextPut: currentCharacter.
                                self step].
        ^class 
                value: self bufferContents
                start: tokenStart
                stop: self previousStepPosition
                lineNumber: tokenLineNumber

    "Modified: / 09-08-2012 / 10:39:47 / cg"
!

scanLiteralString:class recurse:recurse
    "cg: qho calls this, ever?"

    ^ self scanLiteralString:class.

"/        self step.
"/        
"/        [currentCharacter isNil 
"/                ifTrue: [self scannerError: 'Unmatched '' in string literal.'].
"/        currentCharacter == $' and: [self step ~~ $']] 
"/                        whileFalse: 
"/                                [buffer nextPut: currentCharacter.
"/                                self step].
"/        ^class 
"/                value: self bufferContents
"/                start: tokenStart
"/                stop: self previousStepPosition
"/                lineNumber: tokenLineNumber
!

scanName
    "scan over alphanumeric characters."
    
    [characterType == #alphabetic or: [characterType == #digit ]] whileTrue:[
        currentCharacter == $_ ifTrue:[       
            allowOldStyleAssignment ifTrue:[
                forceOldStyleAssignment ifTrue:[^ self].
                (stream atEnd not and:[stream peek isSeparator]) ifTrue:[
                    buffer nextPut: currentCharacter.
                    self step.
                    ^ self
                ].
            ]
        ].            
        buffer nextPut: currentCharacter.
        self step
    ]

    "Modified: / 08-06-2010 / 13:19:08 / cg"
!

scanNamespaceName
        (extendedLiterals or:[nameSpaceCharacterIsDoubled])
                ifTrue: 
                        [stream peek == $: ifFalse: [^nil].
                        buffer next: 2 put: $:.
                        self step]
                ifFalse: 
                        [(stream atEnd or: [(self classify: stream peek) ~~ #alphabetic]) 
                                ifTrue: [^nil].
                        buffer nextPut: $.].
        self step.
        self scanName.
        currentCharacter == nameSpaceCharacter ifTrue: [self scanNamespaceName].
        ^RBIdentifierToken value: self bufferContents start: tokenStart lineNumber: tokenLineNumber
!

scanNumber
        |value|

        value := self perform: numberType.  "/ sets tokenNumberBase as side effect.
        "/ self assert:tokenStart notNil.
        ^RBLiteralNumberToken 
                value: value
                start: tokenStart
                stop: self previousStepPosition
                lineNumber: tokenLineNumber
                radix:tokenNumberBase
!

scanNumberIBM
        | number isNegative |
        tokenNumberBase := nil.
        isNegative := false.
        currentCharacter == $- 
                ifTrue: 
                        [isNegative := true.
                        self step].
        number := self scanNumberWithoutExponent.
        ^(isNegative ifTrue: [number negated] ifFalse: [number]) 
                * self scanExponentMultipler
!

scanNumberOfBase: anInteger 
	"Scan a number. Return the number or nil if the current input isn't a valid number."

	| number digits fraction isFloat succeeded |
	digits := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' copyFrom: 1 to: anInteger.
	number := 0.
	succeeded := false.
	[digits includes: currentCharacter] whileTrue: 
			[number := number * anInteger + (digits indexOf: currentCharacter) - 1.
			self step.
			succeeded := true].
	succeeded ifFalse: [^nil].
	isFloat := false.
	(currentCharacter == $. and: [digits includes: stream peek]) ifTrue: 
			[self step.
			isFloat := true.
			fraction := 1 / anInteger.
			[digits includes: currentCharacter] whileTrue: 
					[number := number + (((digits indexOf: currentCharacter) - 1) * fraction).
					fraction := fraction / anInteger.
					self step]].
	^isFloat ifTrue: [number asFloat] ifFalse: [number]
!

scanNumberVisualWorks
        | number pos1 pos2 s|
        tokenNumberBase := nil.
        stream skip: -1.
        pos1 := stream position.
        number := Number readSmalltalkSyntaxFrom: stream.
        pos2 := stream position.
        s := stream collection copyFrom:pos1+1 to:pos2.
        (s includes:$r) ifTrue:[
            tokenNumberBase := Number readFrom:(s upTo:$r) onError:nil.
        ].
        self step.
        ^number
!

scanNumberWithoutExponent
        "Scan an IBM number with the radix -- don't scan the exponent though"

        | number base |
        base := self scanNumberOfBase: 10.
        (currentCharacter == $r and: [base isInteger])
                ifTrue: 
                        [| position |
                        tokenNumberBase := base.
                        position := stream position.
                        self step.
                        number := self scanNumberOfBase: base.
                        number isNil ifTrue: 
                                        ["Did not read a correct number, r must be start of a message send."

                                        stream position: position - 1.
                                        self step.
                                        number := base]]
                ifFalse: [
                        tokenNumberBase := nil.
                        number := base].
        ^number
!

scanOldStyleAssignOrIdentifier
    "invoked when an underscore is encountered"

    (forceOldStyleAssignment or:[stream peek isNil or:[stream peek isSeparator]]) ifTrue:[
        self step.
        ^ RBOldStyleAssignmentToken start: tokenStart lineNumber: tokenLineNumber
    ].
    ^ self scanIdentifierOrKeyword
!

scanPatternVariable
        |firstChar recurse|

        firstChar := currentCharacter.
        self step.

        "/ ST/X new: `' makes it a regex-string '
        "/ ST/X new: ``' makes it a regex-string (also in any literal array element)'
        (currentCharacter == PatternVariableCharacter and:[ stream peek == $']) ifTrue:[
            recurse := true.
            self step.
        ] ifFalse:[
            recurse := false
        ].
        currentCharacter == $' 
                ifTrue: 
                        [^ (self scanLiteralString:RBPatternLiteralToken) recurse:recurse].

        buffer nextPut: firstChar.
        "/ `{ makes it a pattern block }
        currentCharacter == ${ 
                ifTrue: 
                        [self step.
                        ^RBPatternBlockToken value: '`{' start: tokenStart lineNumber: tokenLineNumber].
        "/ `identifier makes it a pattern variable
        [characterType == #alphabetic] whileFalse: 
                        [characterType == #eof 
                                ifTrue: [self scannerError: 'Meta variable expected'].
                        buffer nextPut: currentCharacter.
                        self step].
        ^self scanIdentifierOrKeyword

    "Modified: / 09-08-2012 / 10:40:04 / cg"
!

scanQualifier
        | nameStream qualifierClass |
        qualifierClass := Smalltalk at: #QualifiedName ifAbsent: [nil].
        qualifierClass isNil ifTrue: [^self scannerError: 'Unknown character'].
        self step.      "{"
        nameStream := WriteStream on: (String new: 10).
        [ currentCharacter == $} ] whileFalse:[
            currentCharacter isNil ifTrue:[
                ^ self scannerError: 'unterminated qualifier'.
            ].
            nameStream nextPut: currentCharacter.
            self step
        ].
        self step.      "}"
        ^RBLiteralToken 
                value: (qualifierClass pathString: nameStream contents)
                start: tokenStart
                stop: self previousStepPosition
                lineNumber: tokenLineNumber
!

scanSTXPrimitiveCode
    "scan an inline C-primitive; % { has already been read."

    | inPrimitive s value |

    s := WriteStream on:(String new:100).
    s nextPut:$%; nextPut:${.

    inPrimitive := true.
    [inPrimitive] whileTrue:[
        [ currentCharacter == $% ] whileFalse:[
            currentCharacter isNil ifTrue:[
"/                self syntaxError:'unterminated primitive'
"/                        position:tokenPosition to:source position.
                ^ self scannerError: 'unterminated primitive'.
                "/ ^ #Error
            ].
            currentCharacter codePoint > 255 ifTrue:[
                ^ self scannerError: 'non-ascii character in primitive'.
            ].
            s nextPut:currentCharacter.
            self step
        ].
        self step.
        s nextPut:$%.
        (currentCharacter == $} ) ifTrue:[
            s nextPut:$}.
            self step.
            inPrimitive := false.
        ]
    ].
    value := s contents.

    ^ RBSTXPrimitiveCodeToken 
                value: value
                start: tokenStart
                stop: stream position
                lineNumber: tokenLineNumber

    "Modified: / 07-01-2012 / 22:14:33 / cg"
!

scanSpecialCharacter
        | character |

        currentCharacter == $: ifTrue: 
                        [self step.
                        currentCharacter == $=
                                ifTrue: 
                                        [self step.
                                        ^ RBAssignmentToken start: tokenStart]
                                ifFalse: [^ RBSpecialCharacterToken value: $: start: tokenStart]].

        currentCharacter == $% ifTrue:[ 
            RBParser isSmalltalkX ifTrue:[
                self step.
                currentCharacter == ${ ifTrue:[
                    self step.
                    ^ self scanSTXPrimitiveCode.
                ].
                characterType := #binary.
                ^ self scanBinary:RBBinarySelectorToken alreadyRead:$%.
            ].
            ^ self scanBinary: RBBinarySelectorToken
        ].

        character := currentCharacter.
        self step.
        ^RBSpecialCharacterToken value: character start: tokenStart lineNumber: tokenLineNumber

    "Modified: / 12-08-2010 / 11:11:38 / cg"
!

scanStringSymbol
	| literalToken |
	literalToken := self scanLiteralString.
	literalToken value: literalToken value asSymbol.
	^literalToken
!

stripCommentInto:whichCommentCollection
        |ch start stop comment startCol commentStartLineNumber 
         isEOLComment isRegularComment isTokenComment commentToken lineBuffer stillInComment|

        start := stream position.
        startCol := start - (lineStartPosition ? 0).
        commentStartLineNumber := lineNumber.
        isTokenComment := isEOLComment := false.

        ch := self step.
        (stxEOLComments and:[ch == $/]) ifTrue:[
            "an EOL comment; stop is the char pos BEFORE the cr"
            [(ch == Character cr) or:[characterType == #eof]] whileFalse:[
                ch := self step.
            ].
            stop := stream position - 1.
            isEOLComment := true.
        ] ifFalse:[
            isRegularComment := true.

            (stxTokenComments and:[ch == $<]) ifTrue:[
                ch := self step.
                ch == $< ifTrue:[
                    ch := self step.
                    (ch notNil and:[ ch isLetter or:[ch == $_]]) ifTrue:[
                        commentToken := String with:ch.
                        ch := self step.
                        [(characterType ~= #eof) and:[ch isLetterOrDigit]] whileTrue:[
                            commentToken := commentToken,ch.
                            ch := self step.
                        ].
                        [(characterType ~= #eof) and:[ch == Character space]] whileTrue:[
                            commentToken := commentToken,ch.
                            ch := self step.
                        ].
                        characterType == #eof ifTrue: [
                            self scannerError: 'Unterminated token comment.'
                        ].
                        ch == Character cr ifFalse:[
                            "/ ouch - a regular old-style comment
                        ] ifTrue:[
                            commentToken := commentToken withoutSeparators.

                            "/ now, skip for a line starting with token
                            stillInComment := true.
                            [stillInComment] whileTrue:[
                                lineBuffer := '' writeStream.
                                ch := self step.
                                [(ch == Character cr) or:[characterType == #eof]] whileFalse:[
                                    lineBuffer nextPut:ch.
                                    ch := self step.
                                ].
                                ((characterType == #eof)
                                or:[lineBuffer contents startsWith:commentToken]) ifTrue:[
                                    stillInComment := false.
                                ]
                            ].
                            isRegularComment := false.
                            isEOLComment := false.
                            isTokenComment := true.
                            characterType == #eof ifTrue: [
                                self scannerError: 'Unterminated token comment.'
                            ].
                            stop := stream position - 1.
                        ].
                    ].
                ].
            ].
            isRegularComment ifTrue:[
                [ch == $"] whileFalse:[
                    characterType == #eof ifTrue: [
                        self scannerError: 'Unmatched " in comment.'
                    ].
                    ch := self step.
                ].
                stop := stream position.
                isEOLComment := false.
            ].
        ].

        self step.
        saveComments ifFalse: [^self].
        
        comment := RBComment start:start stop:stop.
        isEOLComment ifTrue:[comment beEOLComment].
        isTokenComment ifTrue:[comment beTokenComment].     

        comment characters:(stream contents copyFrom:start to:stop).
        comment startColumn:startCol.
        comment lineNumber:commentStartLineNumber.
        whichCommentCollection add:comment.

    "Modified: / 6.2.2000 / 14:25:48 / cg"
!

stripSeparators
    commentsBeforeToken isNil ifTrue:[
        commentsBeforeToken := OrderedCollection new
    ].
    ^ self stripSeparatorsAndCommentsInto:commentsBeforeToken
!

stripSeparatorsAndCommentsInto:whichCommentCollection
        
        [[characterType == #separator]
                whileTrue: [self step].
        currentCharacter == $"]
                whileTrue: [self stripCommentInto:whichCommentCollection]
! !

!RBScanner methodsFor:'scanning'!

next
        | token |
        buffer reset.
        tokenStart := stream position.
        tokenLineNumber := lineNumber.
        characterType == #eof ifTrue: [^RBEndOfFileToken start: tokenStart + 1].         "The EOF token should occur after the end of input"

        commentsAfterToken size > 0 ifTrue:[
            " shift comments "
            commentsBeforeToken isNil ifTrue:[
                commentsBeforeToken := commentsAfterToken.
            ] ifFalse:[
                commentsBeforeToken addAll:commentsAfterToken.
            ].
            commentsAfterToken := nil.
        ].
        commentsAfterToken isNil ifTrue:[
            commentsAfterToken := OrderedCollection new.
        ].

        token := self scanToken.
        tokensSoFar notNil ifTrue:[tokensSoFar add:token].

        self stripSeparatorsAndCommentsInto:commentsAfterToken.
        ^token

    "Modified: / 06-03-2012 / 11:20:00 / cg"
!

scanBinary: tokenClass 
        | val |
        buffer nextPut: currentCharacter.
        self step.
        [
            |stillScanning|

            stream peek isNil ifTrue:[
                stillScanning := false
            ] ifFalse:[
                stillScanning := characterType == #binary.
                currentCharacter == $- ifTrue:[
                    stream peek isDigit ifFalse:[stillScanning := true].
                ] ifFalse:[
                    stillScanning := stillScanning 
                                     or:[Smalltalk isSmalltalkX and:[currentCharacter == $:]].
                ].
            ].
            stillScanning
        ] whileTrue:[
            buffer nextPut: currentCharacter.
            self step
        ].
        val := buffer contents.
        val := val asSymbol.
        ^tokenClass 
            value: val start: tokenStart
            lineNumber:tokenLineNumber
!

scanLiteral
        self step.
        separatorsInLiterals ifTrue: [self stripSeparators].
        (characterType == #alphabetic or: [ currentCharacter == $: ]) ifTrue: [^self scanSymbol].
        characterType == #binary 
                ifTrue: [^(self scanBinary: RBLiteralToken) start:tokenStart stop: self previousStepPosition].
        characterType == #digit ifTrue: [ ^self scanNumber ].
        currentCharacter == $' ifTrue: [^self scanStringSymbol].
        currentCharacter == $( ifTrue: [^self scanLiteralArray].
        currentCharacter == $[ ifTrue: [^self scanByteArray].
        (extendedSymbols and: [ '._)' includes: currentCharacter ])
                ifTrue: [^self scanExtendedSymbol ].
        (separatorsInLiterals and: [currentCharacter == ${]) 
                ifTrue: [^self scanQualifier].
        (extendedLiterals and: [currentCharacter == $#]) 
                ifTrue: [^self scanExtendedLiterals].
        self scannerError: 'Expecting a literal type'
!

scanLiteralArrayParts
        currentCharacter == $# ifTrue: [^self scanLiteral].
        (characterType == #alphabetic or: [ currentCharacter == $: ])
                ifTrue: 
                        [| token value |
                        token := self scanSymbol.
                        value := token value.
                        value == #nil ifTrue: [token value: nil].
                        value == #true ifTrue: [token value: true].
                        value == #false ifTrue: [token value: false].
                        ^token].
        (characterType == #digit 
                or: [currentCharacter == $- and: [(self classify: stream peek) == #digit]]) 
                        ifTrue: [^self scanNumber].
        characterType == #binary 
                ifTrue: [^(self scanBinary: RBLiteralToken) start:tokenStart stop: self previousStepPosition].
        currentCharacter == $' ifTrue: [^self scanLiteralString].
        currentCharacter == $$ ifTrue: [^self scanLiteralCharacter].
        currentCharacter == $( ifTrue: [^self scanLiteralArray].
        currentCharacter == $[ ifTrue: [^self scanByteArray].
        ^self scannerError: 'Unknown character in literal array'
!

scanSymbol
    | lastPositionBefore lastPosition hadColonBefore hasColon value startPosition |
    
    hasColon := false.
    startPosition := lastPosition := stream position.
    currentCharacter == $: ifTrue: [
        "Squeak symbols may begin with a colon"
        buffer nextPut: $:.
        hasColon := true.
        lastPosition := stream position.
        self step. 
    ].

    [characterType == #alphabetic] whileTrue:[
        self scanName.
        currentCharacter == $: ifTrue:[
            buffer nextPut: $:.
            hadColonBefore := hasColon.
            hasColon := true.
            lastPositionBefore := lastPosition.
            lastPosition := stream position.
            self step.
            currentCharacter == $: ifTrue:[
                "/ ST/X allows #FOO::BAR (i.e. a namespace name-symbol)
                hasColon := hadColonBefore.
                lastPosition := lastPositionBefore.
                buffer nextPut: $:.
                self step.
            ].    
        ]
    ].
    value := buffer contents.
    (hasColon and: [value last ~~ $:]) ifTrue:[ 
        stream position: lastPosition.
        self step.
        value := value copyFrom: 1 to: lastPosition - startPosition + 1
    ].
    ^RBLiteralToken 
        value: value asSymbol
        start: tokenStart
        stop: self previousStepPosition
        lineNumber: tokenLineNumber
!

scanToken
        "fast-n-ugly. Don't write stuff like this. Has been found to cause cancer in laboratory rats. Basically a 
        case statement. Didn't use Dictionary because lookup is pretty slow."

        currentCharacter isNil ifTrue: [^RBEndOfFileToken start: tokenStart + 1].         "The EOF token should occur after the end of input"

        currentCharacter == $_ ifTrue:[
            allowOldStyleAssignment ifTrue:[
                " allow underscore as assignment "
                ^ self scanOldStyleAssignOrIdentifier.
            ]
        ].

        characterType == #alphabetic ifTrue: [^self scanIdentifierOrKeyword].
        (characterType == #digit
                or: [currentCharacter == $- and: [(self classify: stream peek) == #digit]])
                        ifTrue: [^self scanNumber].
        characterType == #binary ifTrue: [^self scanBinary: RBBinarySelectorToken].
        characterType == #special ifTrue: [^self scanSpecialCharacter].
        currentCharacter == $' ifTrue: [^self scanLiteralString].
        currentCharacter == $# ifTrue: [^self scanLiteral].
        currentCharacter == $$ ifTrue: [^self scanLiteralCharacter].
        extendedLanguage 
                ifTrue: 
                        [currentCharacter == PatternVariableCharacter 
                                ifTrue: [^self scanPatternVariable].
                        currentCharacter == $} ifTrue: [^self scanSpecialCharacter]].

        ^self scannerError: 'Unknown character: ' , currentCharacter asString

    "Modified: / 19.6.1998 / 00:39:43 / cg"
! !

!RBScanner methodsFor:'testing'!

atEnd
	^characterType == #eof
!

isReadable
	^true
!

isWritable
	^false
! !

!RBScanner class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


RBScanner initialize!
