"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPParser subclass:#PPCompiledParser
	instanceVariableNames:'startSymbol context failure error'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Parsers'
!

PPCompiledParser class instanceVariableNames:'parsers constants referringParser startSymbol'

"
 No other class instance variables are inherited by this class.
"
!

!PPCompiledParser class methodsFor:'as yet unclassified'!

acceptsLoggingOfCompilation
    ^ true
!

addConstant: value as: id
    self constants at: id ifPresent: [ 
        ((self constants at: id) = value) ifFalse: [self error: 'ooups']].	
    
    self constants at: id put: value.
!

constants
    constants ifNil: [ constants := IdentityDictionary new ].
    ^ constants
!

parse: input
    ^ self new parse: input
!

referringParser
    ^ referringParser ifNil: [ ^ PPSentinel new ]
!

referringParser: aPPParser
    referringParser := aPPParser
!

startSymbol
    ^ startSymbol ifNil: [ ^ #start ]
!

startSymbol: symbol
    startSymbol := symbol
! !

!PPCompiledParser methodsFor:'as yet unclassified'!

callParser: id
    | retval |
    retval := (self class parsers at: id) parseOn: context.
    retval isPetitFailure 	ifTrue: [ self error: retval message at: retval position ]
                                    ifFalse: [ self clearError ].
    ^ retval
!

clearError
    error := false.
!

error
    ^ self error: '' at: context position
!

error: message
    ^ self error: message at: context position
!

error: aMessage at: position
    failure position < position ifTrue: [
        failure message: aMessage.
        failure position: position
    ].
    error := true.
    ^ failure
!

initialize
    super initialize.
    
"	self class constants keysAndValuesDo: [ :key :value |
        self instVarNamed: key put: value.
    ].
"

    startSymbol := self class startSymbol.

    
!

isCompiled
    ^ true
!

isError
    ^ error
!

parse: input rule: symbol
    startSymbol := symbol.
    ^ self parse: input.
!

start
    ^ self subclassResponsibility
!

startSymbol: aSymbol
    startSymbol := aSymbol
! !

!PPCompiledParser methodsFor:'parsing'!

parseOn: aPPContext
    | retval |
"	context := aPPContext asCompiledParserContext."
    context := aPPContext.
    context compiledParser: self.
    failure := PPFailure new message: nil; context: context; position: -1.
    context noteFailure: failure.
    error := false.

    retval := self perform: startSymbol.
    (retval isPetitFailure) ifTrue: [ aPPContext noteFailure: failure ].
    error ifTrue: [ aPPContext noteFailure: failure. retval := failure ].
    
"	aPPContext position: context position."
    ^ retval
! !

