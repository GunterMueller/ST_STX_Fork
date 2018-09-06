"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

Object subclass:#RxMatcher
	instanceVariableNames:'matcher ignoreCase startOptimizer stream markerPositions
		markerCount lastResult lastChar'
	classVariableNames:'Cr Lf'
	poolDictionaries:''
	category:'Regex-Matcher'
!

RxMatcher comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

This is a recursive regex matcher. Not strikingly efficient, but simple. Also, keeps track of matched subexpressions.  The life cycle goes as follows:

1. Initialization. Accepts a syntax tree (presumably produced by RxParser) and compiles it into a matcher built of other classes in this category.

2. Matching. Accepts a stream or a string and returns a boolean indicating whether the whole stream or its prefix -- depending on the message sent -- matches the regex.

3. Subexpression query. After a successful match, and before any other match, the matcher may be queried about the range of specific stream (string) positions that matched to certain parenthesized subexpressions of the original expression.

Any number of queries may follow a successful match, and any number or matches may follow a successful initialization.

Note that `matcher'' is actually a sort of a misnomer. The actual matcher is a web of Rxm* instances built by RxMatcher during initialization. RxMatcher is just the interface facade of this network.  It is also a builder of it, and also provides a stream-like protocol to easily access the stream being matched.

Instance variables:
	matcher                         <RxmLink> The entry point into the actual matcher.
	stream                          <Stream> The stream currently being matched against.
	markerPositions         <Array of: Integer> Positions of markers'' matches.
	markerCount             <Integer> Number of markers.
	lastResult                      <Boolean> Whether the latest match attempt succeeded or not.
	lastChar                        <Character | nil> character last seen in the matcher stream'
!

!RxMatcher class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxMatcher class methodsFor:'instance creation'!

for: aRegex
	"Create and answer a matcher that will match a regular expression
	specified by the syntax tree of which `aRegex' is a root."

	^self for: aRegex ignoreCase: false
!

for: aRegex ignoreCase: aBoolean
	"Create and answer a matcher that will match a regular expression
	specified by the syntax tree of which `aRegex' is a root."

	^self new
		initialize: aRegex
		ignoreCase: aBoolean
!

forString: aString
	"Create and answer a matcher that will match the regular expression
	`aString'."

	^self for: (RxParser new parse: aString)
!

forString: aString ignoreCase: aBoolean
	"Create and answer a matcher that will match the regular expression
	`aString'."

	^self for: (RxParser new parse: aString) ignoreCase: aBoolean
! !

!RxMatcher class methodsFor:'class initialization'!

initialize
        "RxMatcher initialize"

        (Smalltalk isSmalltalkX) ifTrue:[
            Cr := Character return.
            Lf := Character nl
        ] ifFalse:[
            Cr := TextConstants at: #CR.
            Lf := TextConstants at: #LF
        ]
! !

!RxMatcher class methodsFor:'utilities'!

signalBuildError
	"Raise a signal indicating that an error has occurred while building
	a matcher. This most probably means an internal error in the build
	algorithm, or corrupted syntax tree."

	RxParser compilationErrorSignal raise
!

signalBuildError: errorString
	"Raise a signal indicating that an error has occurred while building
	a matcher. This most probably means an internal error in the build
	algorithm, or corrupted syntax tree."

	RxParser compilationErrorSignal raiseErrorString: errorString
!

signalMatchError
	"Raise a signal indicating that an error has occurred while matching. 
	This most probably means an internal error in the matcher
	algorithm, or corrupted matcher."

	RxParser matchErrorSignal raise
! !

!RxMatcher methodsFor:'accessing'!

lastResult

	^lastResult
!

matches: aString
        "Match against a string. Return a boolean."

        ^self matchesStream: aString readStream
!

matchesPrefix: aString
        "Match against the start of the string."

        ^self matchesStreamPrefix: aString readStream
!

matchesStream: theStream
        "Match myself against a positionable stream."

        ^(self matchesStreamPrefix: theStream)
                and: [stream atEnd]
!

matchesStreamPrefix: theStream
        "Match myself against a positionable stream."

        stream := theStream.
        lastChar := nil.
        ^self tryMatch
!

search: aString
	"Search the string for occurrence of something matching myself.
	Answer a Boolean indicating success."

	^self searchStream: aString readStream
!

searchStream: aStream
        "Search the stream for occurrence of something matching myself.
        After the search has occurred, stop positioned after the end of the
        matched substring. Answer a Boolean indicating success."

        | position |
        stream := aStream.
        lastChar := nil.
        position := self position.
        [aStream atEnd] whileFalse:
                [self tryMatch ifTrue: [^true].
                self position: position.
                lastChar := aStream next.
                position := self position].
        "Try match at the very stream end too!!"
        self tryMatch ifTrue: [^true]. 
        ^false
!

subBeginning: subIndex

	^markerPositions at: subIndex * 2 - 1
!

subEnd: subIndex

	^markerPositions at: subIndex * 2
!

subexpression: subIndex
    "returns the matches for a parenthesized subexpression.
     notice that non-matching subexpressions deliver an empty matchString;
     also be careful with nested parenthesis.
     With index==1, you get the whole matchString"

    | originalPosition start end reply |

    originalPosition := self position.
    start := self subBeginning: subIndex.
    end := self subEnd: subIndex.
    (start isNil or: [end isNil]) ifTrue: [^''].
    reply := (String new: end - start) writeStream.
    self position: start.
    start to: end - 1 do: [:ignored | reply nextPut: stream next].
    self position: originalPosition.
    ^reply contents

    "
     |matcher|

     matcher := Regex::RxMatcher new
                    initializeFromString:'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[ ]+(:isDigit::isDigit:?)[ ]*,[ ]*19(:isDigit::isDigit:)'
                    ignoreCase:false.
     (matcher matches:'Aug 6, 1996') ifTrue:[
        matcher subexpression:2
     ] ifFalse:[
        self error.
     ].
    "

    "Modified: / 18-11-2010 / 13:05:21 / cg"
    "Modified (comment): / 05-02-2018 / 13:46:25 / mawalch"
!

subexpressionCount
    "returns the number of parenthesized subexpressions after a match, plus 1 (for the whole match)"

    ^markerCount // 2

    "
     |matcher|

     matcher := Regex::RxMatcher new
                    initializeFromString:'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[ ]+(:isDigit::isDigit:?)[ ]*,[ ]*19(:isDigit::isDigit:)'
                    ignoreCase:false.
     (matcher matches:'Aug 6, 1996') ifTrue:[
        matcher subexpressionCount
     ] ifFalse:[
        self error.
     ].
    "

    "Modified: / 18-11-2010 / 13:05:05 / cg"
    "Modified (comment): / 05-02-2018 / 13:44:49 / mawalch"
!

subexpressions
    "returns the matches for each parenthesized subexpression
     notice that non-matching subexpressions deliver an empty matchString;
     also be careful with nested parenthesis."

    ^ 2 to:(self subexpressionCount) collect:[:i | self subexpression:i]

    "
     |matcher|

     matcher := Regex::RxMatcher new
                    initializeFromString:'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[ ]+(:isDigit::isDigit:?)[ ]*,[ ]*19(:isDigit::isDigit:)'
                    ignoreCase:false.
     (matcher matches:'Aug 6, 1996') ifTrue:[
        matcher subexpressions
     ] ifFalse:[
        self error.
     ].
    "

    "
     |matcher|

     matcher := Regex::RxMatcher new
                    initializeFromString:'((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)|(Jan|Feb|Mär|Apr|Mai|Jun|Jul|Aug|Sep|Okt|Nov|Dez))[ ]+(:isDigit::isDigit:?)[ ]*,[ ]*19(:isDigit::isDigit:)'
                    ignoreCase:false.
     (matcher matches:'Aug 6, 1996') ifTrue:[
        matcher subexpressions
     ] ifFalse:[
        self error.
     ].
    "

    "Created: / 18-11-2010 / 12:38:58 / cg"
    "Modified (comment): / 05-02-2018 / 13:46:48 / mawalch"
! !

!RxMatcher methodsFor:'double dispatch'!

syntaxAny
	"Double dispatch from the syntax tree. 
	Create a matcher for any non-whitespace character."

	^RxmPredicate new
		predicate: [:char | (Cr = char or: [Lf = char]) not]
!

syntaxBeginningOfLine
	"Double dispatch from the syntax tree. 
	Create a matcher for beginning-of-line condition."

	^RxmSpecial new beBeginningOfLine
!

syntaxBeginningOfWord
	"Double dispatch from the syntax tree. 
	Create a matcher for beginning-of-word condition."

	^RxmSpecial new beBeginningOfWord
!

syntaxBranch: branchNode
        "Double dispatch from the syntax tree. 
        Branch node is a link in a chain of concatenated pieces.
        First build the matcher for the rest of the chain, then make 
        it for the current piece and hook the rest to it."

        | result next rest |
        branchNode branch isNil
                ifTrue: [^branchNode piece dispatchTo: self].
        "Optimization: glue a sequence of individual characters into a single string to match."
        branchNode piece isAtomic ifTrue:
                [result := CharacterWriteStream on: (String new: 40).
                next := branchNode tryMergingInto: result.
                result := result contents.
                result size > 1 ifTrue: "worth merging"
                        [rest := next notNil 
                                ifTrue: [next dispatchTo: self]
                                ifFalse: [nil].
                        ^(RxmSubstring new substring: result ignoreCase: ignoreCase)
                                pointTailTo: rest;
                                yourself]].
        "No optimization possible or worth it, just concatenate all. "
        ^(branchNode piece dispatchTo: self)
                pointTailTo: (branchNode branch dispatchTo: self);
                yourself
!

syntaxCharClass: charClassNode
	"Double dispatch from the syntax tree. 
	Special link can handle predicates."

	^charClassNode negated
		ifTrue: [RxmPredicate new bePerformNot: charClassNode selector]
		ifFalse: [RxmPredicate new bePerform: charClassNode selector]
!

syntaxCharSet: charSetNode
        "Double dispatch from the syntax tree. 
        A character set is a few characters, and we either match any of them,
        or match any that is not one of them."

        ^RxmPredicate with:(ignoreCase 
                                ifTrue:[charSetNode predicateIgnoringCase]
                                ifFalse:[charSetNode predicate])
!

syntaxCharacter: charNode
	"Double dispatch from the syntax tree. 
	We get here when no merging characters into strings was possible."

	| wanted |
	wanted := charNode character.
	^RxmPredicate new predicate: 
		(ignoreCase
			ifTrue: [[:char | char sameAs: wanted]]
			ifFalse: [[:char | char = wanted]])
!

syntaxEndOfLine
	"Double dispatch from the syntax tree. 
	Create a matcher for end-of-line condition."

	^RxmSpecial new beEndOfLine
!

syntaxEndOfWord
	"Double dispatch from the syntax tree. 
	Create a matcher for end-of-word condition."

	^RxmSpecial new beEndOfWord
!

syntaxEpsilon
        "Double dispatch from the syntax tree. Match empty string. This is unlikely
        to happen in sane expressions, so we'll live without special epsilon-nodes."

        ^RxmSubstring new
                substring: ''
                ignoreCase: ignoreCase
!

syntaxMessagePredicate: messagePredicateNode
	"Double dispatch from the syntax tree. 
	Special link can handle predicates."

	^messagePredicateNode negated
		ifTrue: [RxmPredicate new bePerformNot: messagePredicateNode selector]
		ifFalse: [RxmPredicate new bePerform: messagePredicateNode selector]
!

syntaxNonWordBoundary
	"Double dispatch from the syntax tree. 
	Create a matcher for the word boundary condition."

	^RxmSpecial new beNotWordBoundary
!

syntaxPiece: pieceNode
        "Double dispatch from the syntax tree. 
        Piece is an atom repeated a few times. Take care of a special
        case when the atom is repeated just once."

        | atom |
        atom := pieceNode atom dispatchTo: self.
        pieceNode isSingular ifTrue: [^ atom].
        pieceNode isStar ifTrue: [ ^ self makeStar: atom].
        pieceNode isPlus ifTrue: [ ^ self makePlus: atom].
        pieceNode isOptional ifTrue: [ ^ self makeOptional: atom].
        pieceNode isRepetition ifTrue: [ ^ self makeRepetition: atom min: pieceNode min max: pieceNode max].
        RxParser signalCompilationException: 'repetitions are not supported by RxMatcher'
!

syntaxPredicate: predicateNode
	"Double dispatch from the syntax tree. 
	A character set is a few characters, and we either match any of them,
	or match any that is not one of them."

	^RxmPredicate with: predicateNode predicate
!

syntaxRegex: regexNode
	"Double dispatch from the syntax tree. 
	Regex node is a chain of branches to be tried. Should compile this 
	into a bundle of parallel branches, between two marker nodes." 
	
	| startIndex endIndex endNode alternatives |
	startIndex := self allocateMarker.
	endIndex := self allocateMarker.
	endNode := RxmMarker new index: endIndex.
	alternatives := self hookBranchOf: regexNode onto: endNode.
	^(RxmMarker new index: startIndex)
		pointTailTo: alternatives;
		yourself
!

syntaxWordBoundary
	"Double dispatch from the syntax tree. 
	Create a matcher for the word boundary condition."

	^RxmSpecial new beWordBoundary
! !

!RxMatcher methodsFor:'initialize-release'!

initialize: syntaxTreeRoot
        "Compile myself for the regex with the specified syntax tree.
        See comment and `building' protocol in this class and 
        #dispatchTo: methods in syntax tree components for details 
        on double-dispatch building. 
        The argument is supposedly a RxsRegex."

        self buildFrom: syntaxTreeRoot.
        startOptimizer := RxMatchOptimizer new initialize: syntaxTreeRoot
!

initialize: syntaxTreeRoot ignoreCase: aBoolean
        "Compile myself for the regex with the specified syntax tree.
        See comment and `building' protocol in this class and 
        #dispatchTo: methods in syntax tree components for details 
        on double-dispatch building. 
        The argument is supposedly a RxsRegex."

        ignoreCase := aBoolean.
        self buildFrom: syntaxTreeRoot.
        startOptimizer := RxMatchOptimizer new initialize: syntaxTreeRoot ignoreCase: aBoolean
!

initializeFromString: aRegexString
	"Initialize the receiver from the regex string."

	self initialize: (RxParser new parse: aRegexString)
!

initializeFromString: aRegexString ignoreCase: aBoolean
        "Initialize the receiver from the regex string."

        self initialize: (RxParser new parse: aRegexString) ignoreCase: aBoolean

    "Created: / 18-11-2010 / 12:32:47 / cg"
! !

!RxMatcher methodsFor:'match enumeration'!

copy: aString replacingMatchesWith: replacementString
	"Copy <aString>, except for the matches. Replace each match with <aString>."

	| answer |
	answer := (String new: 40) writeStream.
	self
		copyStream: aString readStream
		to: answer
		replacingMatchesWith: replacementString.
	^answer contents
!

copy: aString translatingMatchesUsing: aBlock
        "Copy <aString>, except for the matches. 
         For each match, evaluate <aBlock> passing the matched substring as the argument.  
         If aBlock accepts 2 more arguments, pass start- and endIndex also.
         Expect the block to answer a String, and replace the match with the answer."

        | answer |
        answer := (String new: 40) writeStream.
        self copyStream: aString readStream to: answer translatingMatchesUsing: aBlock.
        ^answer contents
!

copyStream: aStream to: writeStream replacingMatchesWith: aString
        "Copy the contents of <aStream> on the <writeStream>, except for the matches. 
         Replace each match with <aString>."

        | searchStart matchStart matchEnd |
        stream := aStream.
        lastChar := nil.
        [searchStart := self position.
        self proceedSearchingStream: aStream] whileTrue:
                [matchStart := self subBeginning: 1.
                matchEnd := self subEnd: 1.
                self position: searchStart.
                searchStart to: matchStart - 1 do:
                        [:ignoredPos | writeStream nextPut: aStream next].
                writeStream nextPutAll: aString.
                self position: matchEnd].
        self position: searchStart.
        [aStream atEnd] whileFalse: [writeStream nextPut: aStream next]

    "Modified (comment): / 13-07-2017 / 18:53:57 / cg"
!

copyStream: aStream to: writeStream translatingMatchesUsing: aBlock
        "Copy the contents of <aStream> on the <writeStream>, except for the matches. 
         For each match, evaluate <aBlock> passing the matched substring as the argument.
         If aBlock accepts 2 more arguments, pass start- and endIndex also.
         Expect the block to answer a String, and write the answer to <writeStream> in place of the match."

        | searchStart matchStart matchEnd match |
        stream := aStream.
        lastChar := nil.
        [searchStart := self position.
        self proceedSearchingStream: aStream] whileTrue:
                [matchStart := self subBeginning: 1.
                matchEnd := self subEnd: 1.
                self position: searchStart.
                searchStart to: matchStart - 1 do:
                        [:ignoredPos | writeStream nextPut: aStream next].
                match := (String new: matchEnd - matchStart + 1) writeStream.
                matchStart to: matchEnd - 1 do:
                        [:ignoredPos | match nextPut: aStream next].
                writeStream nextPutAll: (aBlock value: match contents optionalArgument:matchStart and:matchEnd)].
        self position: searchStart.
        [aStream atEnd] whileFalse: [writeStream nextPut: aStream next]
!

hasMatchesIn:s
    "Search aString repeatedly for the matches of the receiver.
    return true, if there are any.
    Example:
        '\w+' asRegex hasMatchesIn: 'Now is the Time'
        '[0-9]+' asRegex hasMatchesIn: 'Now is the Time'
    "

    self matchesIn:s do:[:m | ^ true].
    ^ false.
!

matchesIn: aString
        "Search aString repeatedly for the matches of the receiver.  
         Answer an OrderedCollection of all matches (substrings)."

        | result |
        result := OrderedCollection new.
        self
                matchesOnStream: aString readStream
                do: [:match | result add: match].
        ^result
!

matchesIn: aString collect: aBlock
        "Search aString repeatedly for the matches of the receiver.  
         Evaluate aBlock for each match passing the matched substring as the argument, 
         collect evaluation results in an OrderedCollection, and return in. 
         The following example shows how to use this message to split a string into words:
            '\w+' asRegex matchesIn: 'Now is the Time' collect: [:each | each asLowercase]
        "

        | result |
        result := OrderedCollection new.
        self
                matchesOnStream: aString readStream
                do: [:match | result add: (aBlock value: match)].
        ^result
!

matchesIn: aString do: aBlock
        "Search aString repeatedly for the matches of the receiver.
        Evaluate aBlock for each match passing the matched substring
        as the argument.
        Example:
            '\w+' asRegex matchesIn: 'Now is the Time' do: [:each | Transcript showCR:each]"

        self
                matchesOnStream: aString readStream
                do: aBlock
!

matchesOnStream: aStream

	| result |
	result := OrderedCollection new.
	self
		matchesOnStream: aStream
		do: [:match | result add: match].
	^result
!

matchesOnStream: aStream collect: aBlock

	| result |
	result := OrderedCollection new.
	self
		matchesOnStream: aStream
		do: [:match | result add: (aBlock value: match)].
	^result
!

matchesOnStream: aStream do: aBlock
        [self searchStream: aStream] whileTrue:[
            aBlock value: (self subexpression: 1).
            aStream atEnd ifTrue:[^ self].
        ]

    "Modified (comment): / 13-04-2017 / 10:47:56 / cg"
    "Modified (format): / 04-05-2017 / 19:42:55 / mawalch"
! !

!RxMatcher methodsFor:'private'!

allocateMarker
	"Answer an integer to use as an index of the next marker."

	markerCount := markerCount + 1.
	^markerCount
!

buildFrom: aSyntaxTreeRoot
	"Private - Entry point of matcher build process."

	markerCount := 0.  "must go before #dispatchTo: !!"
	matcher := aSyntaxTreeRoot dispatchTo: self.
	matcher terminateWith: RxmTerminator new
!

hookBranchOf: regexNode onto: endMarker
	"Private - Recurse down the chain of regexes starting at
	regexNode, compiling their branches and hooking their tails 
	to the endMarker node."

	| rest |
	rest := regexNode regex isNil
		ifTrue: [nil]
		ifFalse: [self hookBranchOf: regexNode regex onto: endMarker].
	^RxmBranch new
		next: ((regexNode branch dispatchTo: self)
					pointTailTo: endMarker; 
					yourself);
		alternative: rest;
		yourself
!

isWordChar: aCharacterOrNil
        "Answer whether the argument is a word constituent character:
        alphanumeric or _."

        ^aCharacterOrNil ~~ nil
                and: [aCharacterOrNil isNationalAlphaNumeric or:[aCharacterOrNil == $_]]
!

makeOptional: aMatcher
	"Private - Wrap this matcher so that the result would match 0 or 1
	occurrences of the matcher."

	| dummy branch |
	dummy := RxmLink new.
	branch := (RxmBranch new beLoopback)
		next: aMatcher;
		alternative: dummy.
	aMatcher pointTailTo: dummy.
	^branch
!

makePlus: aMatcher
	"Private - Wrap this matcher so that the result would match 1 and more
	occurrences of the matcher."

	| loopback |
	loopback := (RxmBranch new beLoopback)
		next: aMatcher.
	aMatcher pointTailTo: loopback.
	^aMatcher
!

makeRepetition:aMatcher min:min max:max
        "Private - Wrap this matcher so that the result would match 0 or 1
        occurrences of the matcher."

        |r|

        aMatcher next isNil ifTrue:[
            aMatcher next:(RxmTerminator new).
        ].

        r := RxmRepetition new.
        r min:min max:max.
        r pattern:aMatcher.
        ^ r.
"/        r min:aMatcher
"/        | dummy branch |
"/
"/        dummy := RxmLink new.
"/        branch := (RxmBranch new beLoopback)
"/                next: aMatcher;
"/                alternative: dummy.
"/        aMatcher pointTailTo: dummy.
"/        ^branch
!

makeStar: aMatcher
	"Private - Wrap this matcher so that the result would match 0 and more
	occurrences of the matcher."

	| dummy detour loopback |
	dummy := RxmLink new.
	detour := RxmBranch new
		next: aMatcher;
		alternative: dummy.
	loopback := (RxmBranch new beLoopback)
		next: aMatcher;
		alternative: dummy.
	aMatcher pointTailTo: loopback.
	^detour
!

proceedSearchingStream: aStream

        | position |
        position := self position.
        [aStream atEnd] whileFalse:
                [self tryMatch ifTrue: [^true].
                self position: position.
                lastChar := aStream next.
                position := self position].
        "Try match at the very stream end too!!"
        self tryMatch ifTrue: [^true]. 
        ^false
!

tryMatch
        "Match myself against the current stream."

        markerPositions := Array new: markerCount.
        startOptimizer == nil
                ifTrue: [lastResult := matcher matchAgainst: self]
                ifFalse: [lastResult := (startOptimizer canStartMatch: stream peek in: self)
                                        and: [matcher matchAgainst: self]].
        ^lastResult

    "Modified (format): / 02-08-2018 / 12:25:36 / Claus Gittinger"
! !

!RxMatcher methodsFor:'privileged'!

currentState
        "Answer an opaque object that can later be used to restore the
        matcher's state (for backtracking)."

        | origPosition origLastChar |
        origPosition := self position.
        origLastChar := lastChar.
        ^ [self position: origPosition.
           lastChar := origLastChar]
!

markerPositionAt: anIndex

	^markerPositions at: anIndex
!

markerPositionAt: anIndex maybePut: position
    "Set position of the given marker, if not already set."

    (markerPositions at: anIndex) == nil ifTrue:[
        markerPositions at: anIndex put: position
    ]

    "Modified (format): / 13-07-2017 / 18:55:27 / cg"
!

restoreState: aBlock

	aBlock value
! !

!RxMatcher methodsFor:'splitting & joining'!

split: aString indicesDo: aTwoArgBlock
    | lastPosition |

    stream := aString readStream.
    lastPosition := stream position.
    [ self searchStream: stream ] whileTrue: [
        aTwoArgBlock value: lastPosition+1 value: (self subBeginning: 1) "first".
        self assert:( lastPosition < stream position ) description: 'Regex cannot match null string'.
        lastPosition := stream position 
    ].
    aTwoArgBlock value: lastPosition + 1 value: aString size.

    "
     '[a-z]+' asRegex 
        split: 'bla1234foo567baz890' 
        do: [:fragment | Transcript showCR:fragment storeString].
    "

    "Created: / 13-07-2017 / 18:42:50 / cg"
! !

!RxMatcher methodsFor:'streaming'!

atEnd

	^stream atEnd
!

next

	lastChar := stream next.
	^lastChar
!

peek

        ^ stream peek.
!

position
    ^ stream position
!

position:anInteger 
    ^ stream position:anInteger
! !

!RxMatcher methodsFor:'testing'!

atBeginningOfLine

        #CUmodified. "stupid Windows cr/lf line separator"
        ^self position = 0 or: [lastChar = Lf or: [lastChar = Cr]]
        "
        original:
        ^self position = 0 or: [lastChar = Cr]
        "
!

atBeginningOfWord

	^(self isWordChar: lastChar) not
		and: [self isWordChar: stream peek]
!

atEndOfLine

	^self atEnd or: [stream peek = Cr]
!

atEndOfWord

	^(self isWordChar: lastChar)
		and: [(self isWordChar: stream peek) not]
!

atWordBoundary

	^(self isWordChar: lastChar)
		xor: (self isWordChar: stream peek)
!

notAtWordBoundary

	^self atWordBoundary not
!

supportsSubexpressions

	^true
! !

!RxMatcher class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxMatcher.st,v 1.32 2018-08-02 10:49:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxMatcher.st,v 1.32 2018-08-02 10:49:55 cg Exp $'
! !


RxMatcher initialize!
