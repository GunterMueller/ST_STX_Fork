"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCCompilationOptions
	instanceVariableNames:'options'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Core'
!

!PPCCompilationOptions class methodsFor:'instance creation'!

from: aCollection
    "Initialized options from an array containing option: value pairs.
     Example:

         PPCCompilationOptions from: { #tokenize: true }
    "
    ^ self new initializeFrom: aCollection

    "
        PPCCompilationOptions from: #( tokenize: true )
    "

    "Created: / 07-09-2015 / 10:25:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PPCCompilationOptions methodsFor:'initialization'!

initialize
    super initialize.
    options := IdentityDictionary new
!

initializeFrom: aSequenceableCollection
    aSequenceableCollection size even ifFalse:[ 
        self error: 'Invalid options'
    ].
    1 to: aSequenceableCollection size by: 2 do:[:i |  
        | option value |

        option := aSequenceableCollection at: i.
        value  := aSequenceableCollection at: i + 1.

        [ 
            self perform: option asSymbol with: value
        ] on: MessageNotUnderstood do:[:ex |    
            self error: 'Invalid option: ', option storeString.
        ]
    ].

    "Created: / 07-09-2015 / 10:36:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompilationOptions methodsFor:'options'!

mode
    ^ self at: #mode ifAbsent: #JIT

    "Created: / 26-08-2015 / 23:18:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mode: mode
    "Set the compilation mode - valid values are #JIT or #AOT.

     #JIT mode put less constraints on the original pure PetitParser
       parser (such as action blocks are not required to be purely functional,
       support mixing of compiled parsing code with custom PPParsers and so on).
       However, JIT-compiled parser class SHOULD NOT be commited into the
       repository - it won't work when loaded back. 

     #AOT mode allows for parser to be pre-compiled and generated code
       to be commited to repository. Thus, the deployed application don't need
       to contain full PetitCompiler. However, this is at cost of more contraints
       being put on the original Petit Parser. In other words, not all PetitParser
       parser may be compiled in AOT mode.
       WARNING: #AOT mode is not yet fully supported, do not use!!
    "

    (#(JIT AOT) includes: mode) ifFalse:[ 
        PPCCompilationError new signal: 'Invalid mode: option value - must be either #JIT or #AOT'.
    ].
    mode == #AOT ifTrue:[ 
        PPCCompilationWarning new signal: '#AOT mode not yet supported'.
    ].
    self at: #mode put: mode

    "Created: / 26-08-2015 / 23:07:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parserName
    ^ self at: #parserName ifAbsent: #PPGeneratedParser

    "Modified (format): / 26-08-2015 / 23:04:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parserName: aSymbol
    "Sets the name of the generated parser class.
     Defaults to #PPGeneratedParser."

    self set: #parserName to: aSymbol.

    "Modified (comment): / 26-08-2015 / 23:05:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scannerName
    ^ self at: #scannerName ifAbsent: #PPGeneratedScanner
!

scannerName: value
    "Sets the name of the generated parser class.
     Defaults to #PPGeneratedScanner."    

    self set: #scannerName to: value.

    "Modified (comment): / 26-08-2015 / 23:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tokenize
    ^ self at: #tokenize ifAbsent: false

    "Modified: / 04-09-2015 / 15:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tokenize: aBoolean
    "Build tokenizing parser, i.e., build scanner that tokenizes the input and then
     parser consuming tokens produced by scanner.

     Tokenizing parser more resemble hand-written top-down parser and
     makes hand-tuning of the parser / scanner easier. However, not all
     PetitParsers may be tokenized.

     Default value is true. If the compilation fails, try to set it to
     false
    "    
    self set: #tokenize to: aBoolean.

    "Modified (comment): / 26-08-2015 / 23:24:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompilationOptions methodsFor:'options - undocumented (do not use)'!

debug
    ^ self at: #debug ifAbsent: true
!

debug: value
    self set: #debug to: value.
!

generate
    ^ self at: #generate ifAbsent: true
!

generate: value
    ^ self set: #generate to: value
!

guards
    ^ self at: #guards ifAbsent: true
!

guards: value
    self set: #guards to: value.
!

parserSuperclass
    ^ self at: #parserSuperclass ifAbsent: nil

    "Modified: / 04-09-2015 / 16:06:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parserSuperclass: value
    self set: #parserSuperclass to: value.
!

profile
    ^ self at: #profile ifAbsent: false
!

profile: value
    self set: #profile to: value.
!

scannerSuperclass
    ^ self at: #scannerSuperclass ifAbsent: PPCDistinctScanner
!

scannerSuperclass: value
    self set: #scannerSuperclass to: value.
! !

!PPCCompilationOptions methodsFor:'private'!

at: symbol ifAbsent: defaultValue
    ^ options at: symbol ifAbsent: [ ^ defaultValue  ]
!

set: symbol to: defaultValue
    ^ options at: symbol put: defaultValue 
! !

