"{ Package: 'stx:goodies/petitparser/compiler/benchmarks' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCBenchmark
	instanceVariableNames:'sources report contextClass compile parser context input compiler
		profile repetitions'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Benchmarks-Core'
!


!PPCBenchmark class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PPCBenchmark class methodsFor:'benchmarking-CalipeL'!

run
    | benchmarkSuiteClass |
    
    benchmarkSuiteClass := Smalltalk at: #BenchmarkSuite.
    benchmarkSuiteClass isNil ifTrue:[
        self error: 'CalipeL is not loaded.'
    ].
    ^ (benchmarkSuiteClass  class:self) run

  				"
    PPCBenchmark run.
    "
!

run: selectorOrSelectors
    | benchmarkSuiteClass benchmarkSuite |
    
    benchmarkSuiteClass := Smalltalk at: #BenchmarkSuite.
    benchmarkSuiteClass isNil ifTrue:[
        self error: 'CalipeL is not loaded.'
    ].
    selectorOrSelectors isSymbol ifTrue:[ 
        benchmarkSuite := (benchmarkSuiteClass  class:self selector: selectorOrSelectors ) run
    ] ifFalse:[ 
        benchmarkSuite := benchmarkSuiteClass new.
        selectorOrSelectors do:[:each | 
            benchmarkSuite addBenchmark: (BenchmarkInstance class: self selector: each)   
        ].
    ].
    ^ benchmarkSuite run
    "
    PPCBenchmark run: #benchmarkRBParserC
    "

    "Modified: / 18-08-2015 / 16:34:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spy: benchmark
    | benchmarkInstanceClass |

    benchmarkInstanceClass := Smalltalk at: #BenchmarkInstance.
    benchmarkInstanceClass isNil ifTrue:[
        self error: 'CalipeL is not loaded.'
    ].   

    ^ (benchmarkInstanceClass class:self selector:benchmark) spy

    "Created: / 11-05-2015 / 16:31:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-05-2015 / 19:19:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCBenchmark methodsFor:'accessing'!

repetitions
    ^ repetitions
!

repetitions: anObject
    repetitions := anObject
! !

!PPCBenchmark methodsFor:'benchmark support'!

compile: value
    compile := value
!

measure: aParser on: anInput name: aString
    | time result p |
    self halt: 'deprecated?'.
    context := self context.
    
    p := compile ifTrue: [ 
        aParser end compile
    ] ifFalse: [ 
        aParser end
    ].

    
    time := Time millisecondsToRun: [ result := p parse: anInput withContext: context ].

    self assert: result isPetitFailure not.
    self reportFor: aParser context: context input: anInput time: time name: aString.
!

reportFor: aParser context: aContext input: anInput time: time name: name
    Transcript crShow: (self getMetaInfo: name).
    Transcript crShow: '	Compile: ', compile asString.	
    
    Transcript crShow: '	Total time: ', time asString, ' ms'.
        
    Transcript crShow: '	Time per character: ', 
    (((time / anInput size) asFloat * 1000) asString truncateTo: 6), 
    ' microseconds'.
    
"	Transcript crShow: '	Backtrack per character: ',
    ((aContext backtrackCount / anInput size) asFloat asString truncateTo: 6),
    '.'.
    
    Transcript crShow: '	Remembers per character: ',
    ((aContext rememberCount / input size) asFloat asString truncateTo: 6),
    '.'.
"
!

reportInput: anInput time: time name: name
    | size |
    size := anInput inject: 0 into: [:r :e | r + e size  ].
    Transcript crShow: 'Size: ', size asString.
    Transcript crShow: name, ' time: ', time asString.
    Transcript crShow: 'Time per character: ', (time / size * 1000.0) asString, ' microseconds'.
    
    (context isKindOf: PPCProfilingContext) ifTrue: [ 
        context inspect.
    ]
! !

!PPCBenchmark methodsFor:'benchmarks'!

benchmarkJavaSyntax
    | time |
    
    self assert: '../java-src' asFileReference exists description: '../java-src directory with java sources expected'.

    parser := PPJavaSyntax new.
    context := PPCContext new.
    context initializeFor: parser.
    input := sources javaSourcesBig.

    time := [ input do: [ :source | parser parse: source withContext: context ]] timeToRun asMilliSeconds.
    
    self reportInput: input time: time name: 'Java Syntax'.
!

benchmarkJavaSyntaxCompiled
    | time |
    
    self assert: '../java-src' asFileReference exists description: '../java-src directory with java sources expected'.

    parser := PPJavaSyntax new compile.
    context := PPCContext new.
    context initializeFor: parser.
    input := sources javaSourcesBig.

    time := [ input do: [ :source | parser parse: source withContext: context ]] timeToRun asMilliSeconds.
    
    self reportInput: input time: time name: 'Java Syntax Compiled'.
! !

!PPCBenchmark methodsFor:'benchmarks - expression grammar'!

benchmarkExpressionGrammar
    | time |

    self setupExpressionGrammar.

    time := [ input do: [ :source | parser parse: source withContext: context ]] timeToRun asMilliSeconds.
    
    self reportInput: input time: time name: 'Expression Grammar'.
!

benchmarkExpressionGrammarCompiled
    | time |

    self setupExpressionGrammarCompiled.

    time := [ input do: [ :source | parser parse: source withContext: context ]] timeToRun asMilliSeconds.
    
    self reportInput: input time: time name: 'Compiled Expression Grammar'.
!

benchmarkExpressionGrammarTokenized
    | time |

    self setupExpressionGrammarTokenized.

    time := [ input do: [ :source | parser parse: source withContext: context ]] timeToRun asMilliSeconds.
    
    self reportInput: input time: time name: 'Tokenized Expression Grammar'.
!

benchmarkLL1ExpressionGrammar
    | time |

    self setupLL1ExpressionGrammar.

    time := [ input do: [ :source | parser parse: source withContext: context ]] timeToRun asMilliSeconds.
    
    self reportInput: input time: time name: 'LL1 Expression Grammar'.
!

benchmarkLL1ExpressionGrammarCompiled
    | time |

    self setupLL1ExpressionGrammarCompiled.

    time := [ input do: [ :source | parser parse: source withContext: context ]] timeToRun asMilliSeconds.
    
    self reportInput: input time: time name: 'Compiled LL1 Expression Grammar'.
!

benchmarkLL1ExpressionGrammarTokenized
    | time |

    self setupLL1ExpressionGrammarTokenized.

    time := [ input do: [ :source | parser parse: source withContext: context ]] timeToRun asMilliSeconds.
    
    self reportInput: input time: time name: 'Tokenized LL1 Expression Grammar'.
! !

!PPCBenchmark methodsFor:'benchmarks - micro'!

benchmarkAnyStar
"
    self measure: self anyStar on: sources petitParserPackage.
"	
    self measure: self anyStar on: (sources changesSized: 1000*1000) name: #anyStar.
!

benchmarkAnyStarBlock
"
    self measure: self anyStar on: sources petitParserPackage.
"	
    self measure: self anyStarBlock on: (sources changesSized: 1000*1000) name: #anyStarBlock.
!

benchmarkToken
"
    self measure: self anyStar on: sources petitParserPackage.
"	
    parser := (self tokenParser / #any asParser) star.
    self measure: parser on: (sources changesSized: 1000*1000) name: #token.
! !

!PPCBenchmark methodsFor:'benchmarks - smalltalk'!

benchmarkOpalCompiler
    | time  |
    parser := OpalCompiler new.
    input := sources smalltalkSourcesBig.
    time := [ input do: [ :source | parser parse: source ]] timeToRun asMilliseconds.
    
    self reportInput: input time: time name: 'Opal'
!

benchmarkSmalltalkGrammar
    | time |

    self setupSmalltalkGrammar.

    time := [ input do: [ :source | parser parse: source withContext: context ]] timeToRun asMilliSeconds.
    
    self reportInput: input time: time name: 'Smalltalk Grammar'.
!

benchmarkSmalltalkGrammarCompiled
    | time  |

    self setupSmalltalkGrammarCompiled.

    repetitions timesRepeat: [ 
        time := [ input do: [ :source | 
            parser parse: source withContext: context 
        ]] timeToRun asMilliSeconds.
        self reportInput: input time: time name: 'Compiled Smalltalk Grammar'.
    ]
!

benchmarkSmalltalkGrammarTokenized
    | time   |

    self setupSmalltalkGrammarTokenized.
    
    repetitions timesRepeat: [ 	
        time := [ input do: [ :source | 
                parser parse: source withContext: context ] 
        ] timeToRun asMilliSeconds.
        self reportInput: input time: time name: 'Tokenized Smalltalk Grammar'.
    ]
"	
    size := input inject: 0 into: [:r :e | r + e size  ].
    Transcript crShow: 'Compiled Grammar time: ', time asString.
    Transcript crShow: 'Time per character: ', (time / size * 1000.0) asString, ' microseconds'.
"
!

benchmarkSmalltalkParser
    | time |
    parser := PPSmalltalkParser new.
    context := PPContext new.
    context initializeFor: parser.
    input := sources smalltalkSourcesBig.

    time := [ input do: [ :source | parser parse: source withContext: context ]] timeToRun asMilliSeconds.
    
    self reportInput: input time: time name: 'Smalltalk Parser'.
!

benchmarkSmalltalkParserCompiled
    | time |

    compiler := PPCCompiler new.
    parser := compiler compile: (PPSmalltalkParser new).
    context := PPCContext new.
    context initializeFor:parser.
    input := sources smalltalkSourcesBig.
    time := [
            input do:[:source | 
                parser parse:source withContext:context
            ]
        ] timeToRun 
            asMilliSeconds.
    self 
        reportInput:input
        time:time
        name:'Smalltalk Parser Compiled'.

    "Modified: / 07-09-2015 / 11:38:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCBenchmark methodsFor:'benchmarks-CalipeL'!

benchmarkExpressionGrammarC
    <setup: #setupExpressionGrammar>
    <benchmark: 'Petit Expression Grammar - Standard'>
    
    input do: [ :source | parser parse: source withContext: context ]
!

benchmarkExpressionGrammarTokenizedC
    <setup: #setupExpressionGrammarTokenized>
    <teardown: #teardownExpressionGrammarTokenized>
    <benchmark: 'Petit Expression Grammar - Tokenized'>
    
    
    input do: [ :source | parser parse: source withContext: context ]
!

benchmarkJavaSyntaxC
    <setup: #setupJavaSyntax>
    <benchmark: 'Petit Java Parser - Standard'>
    
    input do: [ :source | parser parse: source withContext: context ]
!

benchmarkJavaSyntaxCompiledC
    <setup: #setupJavaSyntaxCompiled>
    <teardown: #teardownJavaSyntaxCompiled>
    <benchmark: 'Petit Java Parser - Compiled'>
    
    input do: [ :source | parser parse: source withContext: context ]
    
!

benchmarkLRPParserC
    <setup: #setupLRPParser>
    <benchmark: 'LRP Parser - Standard'>

    1000 timesRepeat:[ 
        input do: [ :source | parser parse: source withContext: context ]
    ]

    "Created: / 18-08-2015 / 16:27:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

benchmarkLRPParserCompiledC
    <setup: #setupLRPParserCompiled>
    <teardown: #teardownLRPParserCompiled>
    <benchmark: 'LRP Parser - Compiled'>
    
    1000 timesRepeat:[ 
        input do: [ :source | parser parse: source withContext: context ]
    ]

    "Created: / 18-08-2015 / 16:26:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

benchmarkLRPParser_johanfabry_39C
    <setup: #setupLRPParser>
    <benchmark: 'LRP Parser - Standard johanfabry.39'>

    1000 timesRepeat:[ 
        input do: [ :source | parser parse: source withContext: context ]
    ]

    "Created: / 18-08-2015 / 16:49:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

benchmarkRBParserC
    <setup: #setupRBParser>
    <benchmark: 'RB Smalltalk Parser'>
    
    input do: [ :source | RBParser parseMethod: source ]
!

benchmarkSmalltalkGrammarC
    <setup: #setupSmalltalkGrammar>
    <benchmark: 'Petit Smalltalk Grammar - Standard'>
    
    input do: [ :source | parser parse: source withContext: context ]
!

benchmarkSmalltalkGrammarCompiledC
    <setup: #setupSmalltalkGrammarCompiled>
    <teardown: #teardownSmalltalkGrammarCompiled>
    <benchmark: 'Petit Smalltalk Grammar - Compiled'>
    
    
    input do: [ :source | parser parse: source withContext: context ]
!

benchmarkSmalltalkGrammarTokenizedC
    <setup: #setupSmalltalkGrammarTokenized>
    <teardown: #teardownSmalltalkGrammarTokenized>
    <benchmark: 'Petit Smalltalk Grammar - Tokenized'>
    
    
    input do: [ :source | parser parse: source withContext: context ]
!

benchmarkSmalltalkNoopParserCompiledC
    <setup: #setupSmalltalkNoopParserCompiled>
    <teardown: #teardownSmalltalkNoopParserCompiled>
    <benchmark: 'Petit Smalltalk Parser (noop)- Compiled'>
    
    input do: [ :source | parser parse: source withContext: context ]

    "Created: / 16-05-2015 / 09:45:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

benchmarkSmalltalkNoopParserTokenizedC
    <setup: #setupSmalltalkNoopParserTokenized>
    <teardown: #teardownSmalltalkNoopParserTokenized>
    <benchmark: 'Petit Smalltalk Parser (noop) - Tokenized'>
    
    input do: [ :source | parser parse: source withContext: context ]

    "Created: / 16-05-2015 / 09:46:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

benchmarkSmalltalkParserC
    <setup: #setupSmalltalkParser>
    <benchmark: 'Petit Smalltalk Parser - Standard'>
    
    input do: [ :source | parser parse: source withContext: context ]
!

benchmarkSmalltalkParserCompiledC
    <setup: #setupSmalltalkParserCompiled>
    <teardown: #teardownSmalltalkParserCompiled>
    <benchmark: 'Petit Smalltalk Parser - Compiled'>
    
    input do: [ :source | parser parse: source withContext: context ]
    
!

benchmarkSmalltalkParserTokenizedC
    <setup: #setupSmalltalkParserTokenized>
    <teardown: #teardownSmalltalkParserTokenized>
    <benchmark: 'Petit Smalltalk Parser - Tokenized'>
    
    input do: [ :source | parser parse: source withContext: context ]

    "Created: / 16-05-2015 / 09:45:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCBenchmark methodsFor:'intitialization'!

context
    ^ contextClass new
!

initialize
    super initialize.
    sources := PPCResources current.
    contextClass := PPCContext.

    compile := false.
    profile := false.
    
    repetitions := 3
! !

!PPCBenchmark methodsFor:'meta'!

getMetaInfo: key
    | info |
    info := self metaInfo select: [ :each | each key = key ].
    info isEmpty ifTrue: [ ^ 'unknown benchmark' ].
    ^ info anyOne value
!

metaInfo
    ^ { 
        #anyStar -> '.* Parser'.
        #token -> 'Token Parser'.
        #tokenCompiled -> 'Token Parser Compiled'.
        #anyStarBlock -> 'context next in loop'.
    }
! !

!PPCBenchmark methodsFor:'parsers'!

anyStar
    ^ #any asParser star
!

anyStarBlock
    ^ [ :ctx | [ctx atEnd] whileFalse: [ ctx next ] ] asParser
!

tokenParser
    ^ #letter asParser, (#letter asParser / #digit asParser) star trim
! !

!PPCBenchmark methodsFor:'profiling'!

profile
    contextClass := PPCProfilingContext.
    profile := true.
! !

!PPCBenchmark methodsFor:'setup & teardown'!

setupExpressionGrammar
    
    parser := PPExpressionGrammar new.
    context := self context.
    context initializeFor: parser.
    input := sources expressionSourcesMedium.
!

setupExpressionGrammarCompiled
    compiler := PPCCompiler newWithOptions: #( #tokenize: false ).
    compiler options parserName:#PPCompiledExpressionGrammar.
    compiler options scannerName:#PPCompiledExpressionScanner.
    parser := compiler compile: (PPExpressionGrammar new).
    context := self context.
    context initializeFor:parser.
    input := sources expressionSourcesMedium.

    "Modified: / 07-09-2015 / 11:38:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupExpressionGrammarTokenized
    compiler := PPCCompiler newWithOptions: #( #tokenize: true ).
    compiler options parserName:#PPTokenizedExpressionGrammar.
    compiler options scannerName:#PPTokenizedExpressionScanner.
    parser := compiler compile: (PPExpressionGrammar new).
    context := self context.
    context initializeFor:parser.
    input := sources expressionSourcesMedium.

    "Modified: / 07-09-2015 / 11:36:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupJavaSyntax
    
    parser := PPJavaSyntax new.
    context := self context.
    context initializeFor: parser.
    input := sources javaSourcesBig.
!

setupJavaSyntaxCompiled
    parser := PPJavaSyntax new compile.
    context := self context.
    context initializeFor: parser.
    input := sources javaSourcesBig.

"	
    size := input inject: 0 into: [:r :e | r + e size  ].
    Transcript crShow: 'Compiled Grammar time: ', time asString.
    Transcript crShow: 'Time per character: ', (time / size * 1000.0) asString, ' microseconds'.
"
!

setupLL1ExpressionGrammar
    
    parser := PPLL1ExpressionGrammar new.
    context := self context.
    context initializeFor: parser.
    input := sources expressionSourcesBig.
!

setupLL1ExpressionGrammarCompiled
    compiler := PPCCompiler newWithOptions: #( #tokenize: false ).
    compiler options parserName:#PPCompiledLL1ExpressionGrammar.
    compiler options scannerName:#PPCompiledLL1ExpressionScanner.
    parser := compiler compile: (PPLL1ExpressionGrammar new).
    context := self context.
    context initializeFor:parser.
    input := sources expressionSourcesBig.

    "Modified: / 07-09-2015 / 11:37:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupLL1ExpressionGrammarTokenized
    compiler := PPCCompiler newWithOptions: #( #tokenize: true ).
    compiler options parserName:#PPTokenizedLL1ExpressionGrammar.
    compiler options scannerName:#PPTokenizedLL1ExpressionScanner.
    parser := compiler compile: (PPLL1ExpressionGrammar new).
    context := self context.
    context initializeFor:parser.
    input := sources expressionSourcesBig.

    "Modified: / 07-09-2015 / 11:36:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupLRPParser
    
    parser := PPCLRPParser new.
    context := self context.
    context initializeFor: parser.
    input := PPCLRPSourcesResource current sources

    "Created: / 18-08-2015 / 16:34:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupLRPParserCompiled
    compiler := PPCCompiler newWithOptions: #( #tokenize: false ).
    parser := compiler compile: (PPCLRPParser new).
    context := self context.
    context initializeFor:parser.
    input := PPCLRPSourcesResource current sources

    "Created: / 18-08-2015 / 16:35:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2015 / 11:37:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupLRPParser_johanfabry_39     
    
    parser := PPCLRPParser_johanfabry_39 new.
    context := self context.
    context initializeFor: parser.
    input := PPCLRPSourcesResource current sources

    "Created: / 18-08-2015 / 16:48:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupRBParser
    
    input := sources smalltalkSourcesBig.
!

setupSmalltalkGrammar
    
    parser := PPSmalltalkGrammar new.
    context := self context.
    context initializeFor: parser.
    input := sources smalltalkSourcesBig.
!

setupSmalltalkGrammarCompiled
    compiler := PPCCompiler newWithOptions: #( #tokenize: false ).
    compiler options parserName:#'PPSmalltalkGrammarC_Unviersal'.
    compiler options profile:profile.
    parser := compiler compile: (PPSmalltalkGrammar new).
    context := self context.
    context initializeFor:parser.
    profile ifTrue:[
        input := sources smalltalkSourcesSmall.
    ] ifFalse:[
        input := sources smalltalkSourcesBig.
    ]

    "Modified: / 07-09-2015 / 11:37:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupSmalltalkGrammarTokenized
    compiler := PPCCompiler newWithOptions: #( #tokenize: true ).
    compiler options parserName:#'PPSmalltalkGrammarC_Tokenizing'.
    compiler options scannerName:#'PPSmalltalkGrammarC_Scanner'.
    compiler options profile:profile.
    parser := compiler compile: (PPSmalltalkGrammar new).
    context := self context.
    context initializeFor:parser.
    profile ifTrue:[
        input := sources smalltalkSourcesSmall.
    ] ifFalse:[
        input := sources smalltalkSourcesBig.
    ]

    "Modified: / 07-09-2015 / 11:36:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupSmalltalkNoopParserCompiled
    compiler := PPCCompiler newWithOptions: #( #tokenize: false ).
    parser := compiler compile: (PPCSmalltalkNoopParser new).
    context := PPCContext new.
    context initializeFor:parser.
    input := sources smalltalkSourcesBig.

    "Created: / 16-05-2015 / 09:44:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2015 / 11:37:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupSmalltalkNoopParserTokenized
    compiler := PPCCompiler newWithOptions: #( #tokenize: true ).
    parser := compiler compile: (PPCSmalltalkNoopParser new).
    context := PPCContext new.
    context initializeFor:parser.
    input := sources smalltalkSourcesBig.

    "Created: / 16-05-2015 / 09:44:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2015 / 11:36:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupSmalltalkParser
    
    parser := PPSmalltalkParser new.
    context := self context.
    context initializeFor: parser.
    input := sources smalltalkSourcesBig.
!

setupSmalltalkParserCompiled
    compiler := PPCCompiler newWithOptions: #( #tokenize: false ).
    parser := compiler compile: (PPSmalltalkParser new).
    context := self context.
    context initializeFor:parser.
    input := sources smalltalkSourcesBig.

    "Modified: / 07-09-2015 / 11:37:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupSmalltalkParserTokenized
    compiler := PPCCompiler newWithOptions: #( #tokenize: true ).
    parser := compiler compile: (PPSmalltalkParser new).
    context := self context.
    context initializeFor:parser.
    input := sources smalltalkSourcesBig.

    "Modified: / 07-09-2015 / 11:36:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

teardownExpressionGrammarTokenized
    parser class removeFromSystem.
!

teardownJavaSyntaxCompiled
    parser class removeFromSystem.
"	
    size := input inject: 0 into: [:r :e | r + e size  ].
    Transcript crShow: 'Compiled Grammar time: ', time asString.
    Transcript crShow: 'Time per character: ', (time / size * 1000.0) asString, ' microseconds'.
"
!

teardownLRPParserCompiled
    parser class removeFromSystem.
"       
    size := input inject: 0 into: [:r :e | r + e size  ].
    Transcript crShow: 'Compiled Grammar time: ', time asString.
    Transcript crShow: 'Time per character: ', (time / size * 1000.0) asString, ' microseconds'.
"

    "Created: / 18-08-2015 / 16:36:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

teardownSmalltalkGrammarCompiled
    parser class removeFromSystem.
"	
    size := input inject: 0 into: [:r :e | r + e size  ].
    Transcript crShow: 'Compiled Grammar time: ', time asString.
    Transcript crShow: 'Time per character: ', (time / size * 1000.0) asString, ' microseconds'.
"
!

teardownSmalltalkGrammarTokenized
    parser class removeFromSystem.
"       
    size := input inject: 0 into: [:r :e | r + e size  ].
    Transcript crShow: 'Compiled Grammar time: ', time asString.
    Transcript crShow: 'Time per character: ', (time / size * 1000.0) asString, ' microseconds'.
"

    "Created: / 11-05-2015 / 16:33:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

teardownSmalltalkNoopParserCompiled
    parser class removeFromSystem.
"       
    size := input inject: 0 into: [:r :e | r + e size  ].
    Transcript crShow: 'Compiled Grammar time: ', time asString.
    Transcript crShow: 'Time per character: ', (time / size * 1000.0) asString, ' microseconds'.
"

    "Created: / 16-05-2015 / 09:44:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

teardownSmalltalkNoopParserTokenized
    parser class removeFromSystem.
"       
    size := input inject: 0 into: [:r :e | r + e size  ].
    Transcript crShow: 'Compiled Grammar time: ', time asString.
    Transcript crShow: 'Time per character: ', (time / size * 1000.0) asString, ' microseconds'.
"

    "Created: / 16-05-2015 / 09:44:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

teardownSmalltalkParserCompiled
    parser class removeFromSystem.
"	
    size := input inject: 0 into: [:r :e | r + e size  ].
    Transcript crShow: 'Compiled Grammar time: ', time asString.
    Transcript crShow: 'Time per character: ', (time / size * 1000.0) asString, ' microseconds'.
"
!

teardownSmalltalkParserTokenized
    parser class removeFromSystem.
"       
    size := input inject: 0 into: [:r :e | r + e size  ].
    Transcript crShow: 'Compiled Grammar time: ', time asString.
    Transcript crShow: 'Time per character: ', (time / size * 1000.0) asString, ' microseconds'.
"

    "Created: / 16-05-2015 / 09:47:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCBenchmark class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

