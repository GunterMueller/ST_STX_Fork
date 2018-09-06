"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCompiledParser subclass:#PPTokenizingCompiledParser
	instanceVariableNames:'scanner'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Parsers'
!

!PPTokenizingCompiledParser class methodsFor:'as yet unclassified'!

acceptsLoggingOfCompilation
    ^ true
"	^ self == PPTokenizingCompiledParser"
! !

!PPTokenizingCompiledParser methodsFor:'accessing'!

scanner
    ^ scanner 
! !

!PPTokenizingCompiledParser methodsFor:'initialization'!

initialize
    super initialize.
    
! !

!PPTokenizingCompiledParser methodsFor:'tokenizing'!

consumeWhitespace
    "self shouldBeImplemented "
!

nextToken
    self shouldBeImplemented 
!

parseOn: aPPContext
    | retval |

    context := aPPContext.
    context compiledParser: self.
    failure := PPFailure new message: nil; context: context; position: -1.
    context noteFailure: failure.
    error := false.
    scanner := (self class classVarNamed: #scannerClass) new.
    scanner stream: aPPContext.

    [ 
        scanner scan_consumeWhitespace.
        scanner position: context position.
        
        retval := self perform: startSymbol.
    ] on: PPCScannerError do: [ :e |
        "TODO JK: fix reporting of position?"
        retval := PPFailure message: e description at: 0.
    ].

    (retval isPetitFailure) ifTrue: [ aPPContext noteFailure: failure ].
    error ifTrue: [ aPPContext noteFailure: failure. retval := failure ].
    
"	aPPContext position: context position."
    ^ retval
! !

