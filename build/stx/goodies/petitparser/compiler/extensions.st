"{ Package: 'stx:goodies/petitparser/compiler' }"!

!Character methodsFor:'*petitcompiler'!

ppcPrintable
    ^ self asInteger > 31 and: [ self asInteger < 127 ]
! !

!Object methodsFor:'*petitcompiler'!

canHavePPCId
    ^ false
! !

!Object methodsFor:'*petitcompiler'!

isFsaFailure
    ^ false
! !

!Object methodsFor:'*petitcompiler'!

isInlinedMethod
    ^ false
! !

!PPActionParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCActionNode new
        name: self name;
        block: block;
        child: parser;
        properties: properties;
        parser: self;
        yourself
! !

!PPActionParser methodsFor:'*petitcompiler'!

compileWith: aPetitCompiler
    block isSymbol ifTrue: [  
        ^ aPetitCompiler compileSymbolBlock: block for: self 
    ].
    ^ aPetitCompiler compileBlock: block for: self
! !

!PPAndParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCAndNode new
        name: self name;
        child: parser;
        yourself
! !

!PPCharSetPredicate methodsFor:'*petitcompiler'!

= anObject
    self == anObject ifTrue: [ ^ true ].
    self class == anObject class ifFalse: [ ^ false ].
    ^ classification = anObject classification
! !

!PPCharSetPredicate methodsFor:'*petitcompiler'!

block
    ^ block
! !

!PPCharSetPredicate methodsFor:'*petitcompiler'!

classification
    ^ classification
! !

!PPCharSetPredicate methodsFor:'*petitcompiler'!

equals: anotherPredicate
    self == anotherPredicate ifTrue: [ ^ true ].
    self class == anotherPredicate class ifFalse: [ ^ false ].
    
    ^ classification  = anotherPredicate classification.
! !

!PPCharSetPredicate methodsFor:'*petitcompiler'!

hash
    ^ classification hash
! !

!PPChoiceParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCChoiceNode new
        name: self name;
        children: parsers;
        parser: self;
        yourself
! !

!PPChoiceParser methodsFor:'*petitcompiler'!

compileWith: aPetitCompiler
    ^ aPetitCompiler compileChoice: self
! !

!PPCompositeParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCForwardNode new
        name: self name;
        child: parser;
        yourself

    "Modified: / 22-05-2015 / 21:54:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPContext methodsFor:'*petitcompiler'!

asCompiledParserContext
    ^ PPCContext new
        stream: stream;
        yourself
        
! !

!PPContext methodsFor:'*petitcompiler'!

atWs
    ^ false
! !

!PPContext methodsFor:'*petitcompiler'!

comment
    ^ self globalAt: #comment ifAbsent: [ nil ].
! !

!PPContext methodsFor:'*petitcompiler'!

comment: value
    ^ self globalAt: #comment put: value
! !

!PPContext methodsFor:'*petitcompiler'!

compiledParser
    ^ self globalAt: #compiledParser
! !

!PPContext methodsFor:'*petitcompiler'!

compiledParser: aPPParser
    ^ self globalAt: #compiledParser put: aPPParser
! !

!PPContext methodsFor:'*petitcompiler'!

lwRemember
    ^ self position
! !

!PPContext methodsFor:'*petitcompiler'!

lwRestore: position
    ^ self position: position
! !

!PPContext methodsFor:'*petitcompiler'!

methodFinished: whatever
    "nothing to do"
! !

!PPContext methodsFor:'*petitcompiler'!

methodInvoked: whatever
    "nothing to do"
! !

!PPContext methodsFor:'*petitcompiler'!

peek: anInteger
    ^ stream peek: anInteger
! !

!PPContext methodsFor:'*petitcompiler'!

setWs
    "nothing to do"
! !

!PPContext methodsFor:'*petitcompiler'!

skipSeparators
    ^ stream skipSeparators
! !

!PPContext methodsFor:'*petitcompiler'!

tokenRead: whatever
    "nothing to do"
! !

!PPContext methodsFor:'*petitcompiler'!

whitespace
    ^ self globalAt: #whitespace ifAbsent: [ nil ].
! !

!PPContext methodsFor:'*petitcompiler'!

whitespace: value
    ^ self globalAt: #whitespace put: value
! !

!PPDelegateParser methodsFor:'*petitcompiler'!

asCompilerNode
    self class == PPDelegateParser ifTrue: [ 
        ^ PPCForwardNode new
            name: self name;
            child: parser;
            yourself
    ].
    ^ super asCompilerNode

    "Modified: / 22-05-2015 / 21:53:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPDelegateParser methodsFor:'*petitcompiler'!

compileWith: aPetitCompiler
    (self class == PPDelegateParser) ifTrue: [ 
        (self name notNil and: [ parser name isNil ]) ifTrue: [ 
            parser name: self name.
            ^ parser compileWith: aPetitCompiler.
        ].

        (self name notNil and: [ parser name notNil ]) ifTrue: [ 
            ^ aPetitCompiler compileDelegate: self.
        ]
    ].
    ^ super compileWith: aPetitCompiler.
! !

!PPEndOfFileParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCEndOfFileNode new
        name: self name;
        yourself
! !

!PPEndOfInputParser methodsFor:'*petitcompiler'!

asCompilerNode
    
    ^ PPCEndOfInputNode new
        name: self name;
        child: parser;
        yourself	
! !

!PPEpsilonParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCNilNode new
! !

!PPEpsilonParser methodsFor:'*petitcompiler'!

compileWith: aPetitCompiler
    ^ aPetitCompiler compileNil
! !

!PPFailure methodsFor:'*petitcompiler'!

context: aPPContext
    context := aPPContext
! !

!PPFailure methodsFor:'*petitcompiler'!

message: text
    message := text
! !

!PPFailure methodsFor:'*petitcompiler'!

position: anInteger
    position := anInteger
! !

!PPLiteralObjectParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCCharacterNode new
        character: literal;
        name: self name;
        yourself
! !

!PPLiteralObjectParser methodsFor:'*petitcompiler'!

compileWith: aPetitCompiler
    ^ aPetitCompiler compileCharacter: literal.
! !

!PPLiteralParser methodsFor:'*petitcompiler'!

id
    ^ literal printString
! !

!PPLiteralSequenceParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCLiteralNode new
        literal: literal;
        name: self name;
        yourself
! !

!PPLiteralSequenceParser methodsFor:'*petitcompiler'!

compileWith: aPetitCompiler
    ^ aPetitCompiler compileLiteral: literal.
! !

!PPNotParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCNotNode new 
        child: parser;
        name: self name;
        yourself
! !

!PPNotParser methodsFor:'*petitcompiler'!

compileWith: aPetitCompiler
    ^ aPetitCompiler compileNot: self
! !

!PPOptionalParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCOptionalNode new
        name: self name;
        child: parser;
        yourself

"	^ super asCompilerNode "
! !

!PPOptionalParser methodsFor:'*petitcompiler'!

compileWith: aPetitCompiler
    ^ aPetitCompiler compileOptional: self
! !

!PPParser methodsFor:'*petitcompiler'!

allNodesDo: aBlock seen: aSet
    "Iterate over all the parse nodes of the receiver, do not visit and follow the ones contained in aSet."

    (aSet includes: self) ifTrue: [ ^ self ].
    aSet add: self.
    aBlock value: self.
    
    self children do: [ :each | 
        each allNodesDo: aBlock seen: aSet 
    ]
! !

!PPParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCUnknownNode new
        parser: self;
        name: self name;
        yourself
! !

!PPParser methodsFor:'*petitcompiler'!

asCompilerTree
    ^ self transform: [ :p | p asCompilerNode  ]
! !

!PPParser methodsFor:'*petitcompiler'!

bridge
    ^ self
! !

!PPParser methodsFor:'*petitcompiler'!

compile
    ^ self compileWithOptions: PPCCompilationOptions new

    "Modified: / 07-09-2015 / 10:54:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPParser methodsFor:'*petitcompiler'!

compileWithOptions: options
    "Compile receiver with given options. Return 
     an *instance* of the compiler parser which is 
     ready to use (repeatedly). 

     `options` may be either an instance of PPCCompilationOptions
     or an array specifying options like #( tokenizing: true debug: false )
    " 
    | compiler |

    compiler := PPCCompiler new.
    compiler options: options.
    ^compiler compile: self

    "Created: / 07-09-2015 / 10:52:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPParser methodsFor:'*petitcompiler'!

firstSetSuchThat: block
    self halt: 'deprecated?'.
    ^ self firstSetSuchThat: block into: (OrderedCollection new) openSet: IdentitySet new.
! !

!PPParser methodsFor:'*petitcompiler'!

firstSetSuchThat: block into: aCollection openSet: aSet
    (aSet includes: self) ifTrue: [ ^ aCollection ].
    aSet add: self.
    
    (block value: self) ifTrue: [aCollection add: self. ^ aCollection ].
    self children do: [ :child | 
        child firstSetSuchThat: block into: aCollection openSet: aSet 
    ].
    ^ aCollection
! !

!PPParser methodsFor:'*petitcompiler'!

id
    self name ifNotNil: [ ^ self name ].
    ^ self hash asString
! !

!PPParser methodsFor:'*petitcompiler'!

isCompiled
    ^ false
! !

!PPParser methodsFor:'*petitcompiler'!

isContextFree
    ^ self propertyAt: #isContextFree ifAbsentPut: 
        [ self allParsers allSatisfy: [ :p | p isContextFreePrim ] ].
    
! !

!PPParser methodsFor:'*petitcompiler'!

isContextFreePrim
    ^ true
! !

!PPParser methodsFor:'*petitcompiler'!

isToken
    ^ false
! !

!PPParser methodsFor:'*petitcompiler'!

isTokenParser
    ^ false
! !

!PPParser methodsFor:'*petitcompiler'!

javaToken
    | ws |
    ws := PPJavaWhitespaceParser new.
    ^ ((ws, ((PPTokenParser on: self) tokenClass: PPJavaToken; yourself), ws) ==> #second)
        propertyAt: #'trimmingToken' put: true;
        yourself
! !

!PPParser methodsFor:'*petitcompiler'!

optimize
    ^ self copy
! !

!PPParser methodsFor:'*petitcompiler'!

optimized
    ^ self copy
! !

!PPParser methodsFor:'*petitcompiler'!

trimmingToken
    | ws |
    ws := #space asParser star.
    ^ ((ws, (PPTokenParser on: self), ws) ==> #second)
        propertyAt: #trimmingToken put: true;
        yourself
! !

!PPPluggableParser methodsFor:'*petitcompiler'!

acceptsEpsilon
    ^ true
! !

!PPPluggableParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCPluggableNode new
        block: block;
        name: self name;
        yourself
! !

!PPPossessiveRepeatingParser methodsFor:'*petitcompiler'!

asCompilerNode
    ((self min = 0) and: [ self max = SmallInteger maxVal ]) ifTrue: [
        ^ PPCStarNode new
            name: self name;
            child: parser;
            parser: self;
            yourself
    ].

    ((self min = 1) and: [ self max = SmallInteger maxVal ]) ifTrue: [
        ^ PPCPlusNode new
            name: self name;
            child: parser;
            parser: self;
            yourself
    ].
    ^ super asCompilerNode
! !

!PPPossessiveRepeatingParser methodsFor:'*petitcompiler'!

compileWith: aPetitCompiler
    ((self min = 1) and: [ self max = SmallInteger maxVal ]) ifTrue: [
        ^ aPetitCompiler compilePlus: self.
    ].	
    ((self min = 0) and: [ self max = SmallInteger maxVal ]) ifTrue: [
        ^ aPetitCompiler compileStar: self.
    ].

    ^ super compileWith: aPetitCompiler.
! !

!PPPredicateObjectParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCPredicateNode new
        name: self name;
        predicate: predicate;
        yourself
! !

!PPPredicateObjectParser methodsFor:'*petitcompiler'!

compileWith: aPetitCompiler
    (predicateMessage  = 'input expected') ifTrue: [  
        ^ aPetitCompiler compileAny.
    ].
    ^ aPetitCompiler compilePredicate: predicate.
! !

!PPPredicateObjectParser methodsFor:'*petitcompiler'!

firstCharSet
    ^ predicate
! !

!PPPredicateObjectParser methodsFor:'*petitcompiler'!

firstCharSetCached
    ^ predicate
! !

!PPSequenceParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCSequenceNode new
        children: parsers;
        name: self name;
        properties: properties;
        yourself
! !

!PPSequenceParser methodsFor:'*petitcompiler'!

compileWith: aPetitCompiler
    ^ aPetitCompiler compileSequence: self.
! !

!PPSequenceParser methodsFor:'*petitcompiler'!

firstSetSuchThat: block into: aCollection openSet: aSet
    (aSet includes: self) ifTrue: [ ^ aCollection ].
    aSet add: self.
    
    (block value: self) ifTrue: [ aCollection add: self. ^ aCollection ].
    
    self children do: [ :child | 
        child firstSetSuchThat: block into: aCollection openSet: aSet.
        child acceptsEpsilon ifFalse: [ ^ aCollection ]
    ].
    ^ aCollection
! !

!PPSequenceParser methodsFor:'*petitcompiler'!

map: aBlock
        ^ aBlock numArgs = self children size
                ifTrue: [ PPMappedActionParser on: self block: aBlock ]
                ifFalse: [ self error: aBlock numArgs asString , ' options expected.' ]

    "Modified: / 02-06-2015 / 17:16:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPSmalltalkGrammar methodsFor:'*petitcompiler'!

comment
 		^ $" asParser, $" asParser negate star, $" asParser.	
! !

!PPSmalltalkGrammar methodsFor:'*petitcompiler'!

number
    | numberChars |
    numberChars := #hex asParser / 'r' asParser / 's' asParser / '-' asParser.
    ^ $- asParser optional, #digit asParser, numberChars star, ('.' asParser, numberChars plus) optional.
    
"	^ ($- asParser optional , #digit asParser) and , [ :context | 
        [ (NumberParser on: context stream) nextNumber ] 
            on: Error
            do: [ :err | PPFailure message: err messageText at: context position ] ] 
                asParser
"
! !

!PPSmalltalkGrammar methodsFor:'*petitcompiler'!

whitespace
    ^ #space asParser plus
! !

!PPSmalltalkTokenParser methodsFor:'*petitcompiler'!

compileWith: aPetitCompiler

    ^ aPetitCompiler compileSmalltalkToken: self.
! !

!PPSmalltalkTokenParser methodsFor:'*petitcompiler'!

parseOnX: aPPContext
    | memento comments token |

    memento := aPPContext remember.
    comments := self
        parseComments: #()
        on: aPPContext.
    token := super parseOn: aPPContext.
    token isPetitFailure ifTrue: [
        aPPContext restore: memento.
        ^ token ].
    comments := self
        parseComments: comments
        on: aPPContext.
    ^ token comments: comments
! !

!PPSmalltalkTokenParser methodsFor:'*petitcompiler'!

whitespace
    ^ PPSmalltalkWhitespaceParser new
! !

!PPSmalltalkWhitespaceParser methodsFor:'*petitcompiler'!

= anotherParser
    anotherParser == self ifTrue: [ ^ true ].
    anotherParser class = self class ifFalse: [ ^ false ].
 ^ anotherParser name = self name
! !

!PPSmalltalkWhitespaceParser methodsFor:'*petitcompiler'!

acceptsEpsilon
    ^ true
! !

!PPSmalltalkWhitespaceParser methodsFor:'*petitcompiler'!

acceptsEpsilonOpenSet: set
    ^ true
! !

!PPSmalltalkWhitespaceParser methodsFor:'*petitcompiler'!

firstCharSet
    ^ PPCharSetPredicate on: [:e | false ] 
! !

!PPSmalltalkWhitespaceParser methodsFor:'*petitcompiler'!

hash
    ^ self name hash
! !

!PPSmalltalkWhitespaceParser methodsFor:'*petitcompiler'!

parseOn: aPPContext
    [ 
        [aPPContext atEnd not and: [ aPPContext uncheckedPeek isSeparator ] ]whileTrue: [ 
            aPPContext next 
        ].
        aPPContext atEnd not and: [ aPPContext uncheckedPeek = $" ] 
    ] whileTrue: [
        aPPContext next. "Eat opening $"

        "When running on Smalltalk/X, also support end-of-line comments "
        "Here, test first if the char following the opening quote is slash
         and only if so test for Smalltalk/X as this test is lot slower
         then slash test"
        ((aPPContext atEnd not and:[ aPPContext uncheckedPeek == $/ ])
            and:[(Smalltalk respondsTo: #isSmalltalkX) and:[Smalltalk isSmalltalkX]]) ifTrue:[ 
                "OK, comment start with quote-slash and we're on Smalltalk/X so eat
                 everything till the end of a line"
                | c |

                [ aPPContext atEnd or:[ c := aPPContext next codePoint. c == 13 or:[c == 10] ] ] whileFalse.
            ] ifFalse:[ 
                "Standard comment so eat till closing quot"
                [ aPPContext atEnd or: [ aPPContext next == $" ] ] whileFalse
            ].
    ].

    "Modified: / 18-08-2015 / 22:13:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPStream methodsFor:'*petitcompiler'!

peek: anInteger
    | endPosition |
    endPosition := position + anInteger  min:  readLimit.
    ^ collection copyFrom: position+1 to: endPosition.
! !

!PPToken methodsFor:'*petitcompiler'!

= anObject
    ^ self class = anObject class and: [ self inputValue = anObject inputValue ]
! !

!PPToken methodsFor:'*petitcompiler'!

hash
    ^ self inputValue hash
! !

!PPToken methodsFor:'*petitcompiler'!

isToken
    ^ true
! !

!PPTokenParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCTokenNode new
        name: self name;
        tokenClass: self tokenClass;
        child: parser;
        yourself
! !

!PPTokenParser methodsFor:'*petitcompiler'!

displayName
    ^ 'TOKEN[', parser displayName, ']'
! !

!PPTokenParser methodsFor:'*petitcompiler'!

isFirstSetTerminal
    ^ false
! !

!PPTokenParser methodsFor:'*petitcompiler'!

isTokenParser
    ^ true
! !

!PPTokenParser methodsFor:'*petitcompiler'!

optimize
    ^ self transform: [ :each | each optimized ]
! !

!PPTokenParser methodsFor:'*petitcompiler'!

parser
    ^ parser
! !

!PPTokenParser methodsFor:'*petitcompiler'!

startsWith: aCharacter
    ^ self first anySatisfy: [ :first | first startsWith: aCharacter ]
! !

!PPTokenParser methodsFor:'*petitcompiler'!

whitespace
    ^ self class whitespace 
! !

!PPTrimmingParser methodsFor:'*petitcompiler'!

asCompilerNode
    ^ PPCTrimNode new
        child: parser;
        name: self name;
        parser: self;
        yourself
! !

!RBLiteralValueNode methodsFor:'*petitcompiler'!

isLiteralNumber
    ((Smalltalk respondsTo: #isSmalltalkX) and: [Smalltalk isSmalltalkX]) ifTrue:[
        ^super isLiteralNumber
    ] ifFalse:[
        "Assume Pharo..."
         [(NumberParser on: self sourceText ) nextNumber] on: Exception do: [ ^ false ].
         ^ true
    ].

    "Modified: / 17-08-2015 / 23:17:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBProgramNode methodsFor:'*petitcompiler'!

isLiteralNumber
    ^ false
! !

!UndefinedObject methodsFor:'*petitcompiler'!

asInteger
    "
        because nil is returned as and of text on stream
        
        JK: This should be obviously rewritten in future!!
    "
    self flag: 'JK: Hack alert!!'.
    ^ 256
! !

!UndefinedObject methodsFor:'*petitcompiler'!

codePoint
    "
        because nil is returned as and of text on stream
        
        JK: This should be obviously rewritten in future!!
    "
    self flag: 'JK: Hack alert!!'.
    ^ 0
! !

!UndefinedObject methodsFor:'*petitcompiler'!

isAlphaNumeric
    ^ false
! !

!UndefinedObject methodsFor:'*petitcompiler'!

isDigit
    ^ false
! !

!UndefinedObject methodsFor:'*petitcompiler'!

isLetter
    ^ false
! !

!UndefinedObject methodsFor:'*petitcompiler'!

isSeparator
    ^ false
! !

!stx_goodies_petitparser_compiler class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
