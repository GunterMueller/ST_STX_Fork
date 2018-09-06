"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCCompiler
	instanceVariableNames:'context ir history passes'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Core'
!


!PPCCompiler class methodsFor:'as yet unclassified'!

new
    ^ self basicNew initialize

    "Modified: / 07-09-2015 / 11:06:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newWithOptions: options
    ^ self new options: options

    "Created: / 07-09-2015 / 11:06:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompiler methodsFor:'accessing'!

context
    ^ context
!

options
    ^ context options

    "Modified: / 26-08-2015 / 19:48:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

options: options
    context options: options

    "Created: / 26-08-2015 / 19:56:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

passes
    ^ passes
!

passes:aCollection
    passes := aCollection asOrderedCollection

    "Modified: / 04-09-2015 / 14:14:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompiler methodsFor:'accessing - defaults'!

defaultPassesForTokenizingParser
    ^  {
        PPCTokenDetector .
        PPCCacheFirstFollowPass .
        PPCLL1Visitor .
        PPCTokenizingVisitor .
        PPCMergingVisitor .
        PPCSpecializingVisitor .
        PPCInliningVisitor .
        PPCMergingVisitor .
        PPCCheckingVisitor .
        PPCCacheFirstFollowPass .
        PPCTokenizingCodeGenerator .
        PPCFSAVisitor .
        PPCTokenCodeGenerator .
        PPCScannerCodeGenerator .    
    } asOrderedCollection.

    "Created: / 04-09-2015 / 15:56:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultPassesForUniversalParser
    ^ {
        PPCTokenDetector.
        PPCCacheFirstFollowPass. 
        PPCSpecializingVisitor .
        PPCRecognizerComponentDetector .
        PPCSpecializingVisitor .
        PPCInliningVisitor .
        PPCMergingVisitor .
        PPCCheckingVisitor .
        PPCUniversalCodeGenerator
    } asOrderedCollection.

    "Created: / 04-09-2015 / 15:56:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompiler methodsFor:'adding / removing passes'!

removePass: pass
    | index |

    self initializePassesIfNotAlready.
    [ 
        index := passes indexOf: pass.
        index ~~ 0
    ] whileTrue:[
        "Fuck it!!  
         Pharo does not have #removeAtIndex: which is actually
         and ANSI protocol. But Pharoers do not like ANSI and don't
         give a shit about compatibility. Hence the following piece 
         of crap."
        (passes respondsTo: #removeAtIndex:) ifTrue:[ 
            passes removeAtIndex: index.
        ] ifFalse:[ 
            "Try Pharo's non-standard removeAt:"
            (passes respondsTo: #removeAt:) ifTrue:[ 
                passes removeAt: index
            ] ifFalse:[ 
                self error: 'Don''t know how to remove object at index...'
            ].
        ].
    ].

    "Created: / 04-09-2015 / 11:24:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2015 / 02:36:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompiler methodsFor:'compiling'!

compile: aPPParser
    "Compiles given parser. Return an *instance* of the compiler
     parser which is ready to use (repeatedly)"

    | time |
    self input: aPPParser.    
    time := [ self compile ] timeToRun.
    ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifFalse:[ 
        "Assume Pharo"
        time := time asMilliSeconds.
    ].
    self reportTime: time.
    
    ^ ir

    "Modified: / 17-08-2015 / 13:06:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 07-09-2015 / 10:49:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompiler methodsFor:'initialization'!

initialize
    history := OrderedCollection new.
    context := PPCCompilationContext new.

    "Modified: / 04-09-2015 / 15:56:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializePassesIfNotAlready
    passes isNil ifTrue:[ 
        context options tokenize ifTrue:[ 
            passes := self defaultPassesForTokenizingParser
        ] ifFalse:[ 
            passes := self defaultPassesForUniversalParser
        ].
    ].

    "Created: / 04-09-2015 / 16:02:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompiler methodsFor:'private'!

buildClass: clazz
    |  builder |
    builder := PPCClassBuilder new.
    
    builder compiledClassName: clazz name.
    builder compiledSuperclass: clazz superclass.
    builder methodDictionary: clazz methodDictionary.
    builder constants: clazz constants.

    ^ builder compileClass.	
!

compile
    self runPasses.
    self generateScanner.
    self generateParser.

    "Modified: / 07-09-2015 / 07:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

copyTree: somethingTransformable
    ^ somethingTransformable transform: [ :e | e copy ]
!

generateParser
    | parserClass parserSuper rootMethod |

    context options generate ifFalse:[
        ^ self
    ].
    context parserClass methodDictionary isEmpty ifTrue:[ 
        ^ self
    ].

    parserSuper := context options parserSuperclass.
    parserSuper isNil ifTrue:[ 
        parserSuper := context options tokenize 
                        ifTrue:[ PPTokenizingCompiledParser ]
                        ifFalse:[ PPCompiledParser ]   
    ].
    rootMethod := context parserClass propertyAt:#rootMethod.
    context parserClass name:context options parserName.
    context parserClass superclass: parserSuper.
    parserClass := self buildClass:context parserClass.
    parserClass startSymbol:rootMethod methodName.
    self remember:parserClass as:#parser.
    ir := parserClass new

    "Modified: / 25-08-2015 / 00:05:49 / Jan Vrany"
    "Modified: / 04-09-2015 / 16:07:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateScanner
    | scanner |

    context options generate ifFalse:[
        ^ self
    ].
    context scannerClass methodDictionary isEmpty ifTrue:[ 
        ^ self
    ].

    context scannerClass name:context options scannerName.
    context scannerClass superclass:context options scannerSuperclass.
    scanner := (self buildClass:context scannerClass).
    context parserClass addConstant:scanner as:#scannerClass.
    ir := scanner.
    self remember:scanner as:#scanner

    "Modified: / 25-08-2015 / 00:06:49 / Jan Vrany"
    "Modified: / 04-09-2015 / 15:33:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

input: aPPParser
    ir := aPPParser asCompilerTree.    
    self remember: (self copyTree: ir) as: #input

    "Modified (format): / 29-08-2015 / 07:18:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ir
    ^ ir
!

ir: whatever
    ir := whatever
!

remember: value as: key
    context options debug ifTrue: [ 
        history add: key -> value.
    ]

    "Modified: / 28-08-2015 / 14:14:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reportTime: timeInMs
    context options profile ifTrue: [ 
        Transcript show: 'Time to compile: '; show: timeInMs asString; show: ' ms'; cr.
    ]

    "Modified: / 07-09-2015 / 07:55:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runPasses
    self initializePassesIfNotAlready.
    passes do:[:each | self runPass: each  ]

    "Created: / 07-09-2015 / 07:53:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompiler methodsFor:'running'!

runPass: pass
    | p |

    p := pass asPPCPass.
    ir := p run: ir in: context.
    self remember:(self copyTree:ir) as:p class name

    "Created: / 26-08-2015 / 22:35:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-08-2015 / 07:16:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompiler class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

