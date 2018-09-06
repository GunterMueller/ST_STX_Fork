"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCompositeParser subclass:#PPCLRPParser
	instanceVariableNames:'program variable smalltalkBlock bra ket identifier machine body
		event transition epsilon wildcard state onentry running onexit
		comment lineTerminator statebody spawn integer errorNode success
		failed lastError styler timeoutIdentifier timeoutInteger
		endOfComment'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!

!PPCLRPParser class methodsFor:'accessing'!

ignoredNames

    ^super ignoredNames , #(styler failed lastError)
! !

!PPCLRPParser methodsFor:'accessing'!

error
    ^super error

    "Modified: / 30-07-2015 / 17:12:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

failed
    ^failed
!

lastError
    ^lastError
!

start
    ^program end
!

styler: aSHStyler

    styler := aSHStyler.
!

success
    ^success
! !

!PPCLRPParser methodsFor:'block creation'!

createSTBlockFrom: aBlockNode withVariables: aDictionary
    |compiled retval keys|
    
    keys := OrderedCollection new: aDictionary size.
    aDictionary associations do: [:asoc|
        keys add: asoc key.
    ].

    compiled := (self methodizeBlock: aBlockNode withArguments: keys) compiledMethod.
    retval := compiled valueWithReceiver: Object new options: {aDictionary}.

    ^retval.
!

methodizeBlock: parsedBlock withArguments: anArray
    
    |method retval inspoint|
    
    method := 'captureV: PPCLRPScopeVariables'.
     
    retval := PPSmalltalkParser new method parse: method , '^[1]'.
    inspoint := retval body statements first.
    parsedBlock scope: inspoint value scope.
    parsedBlock parent: inspoint.
    inspoint value: parsedBlock.
    retval source: retval asString.
    
    anArray do: [:aVarName|
        retval := retval rewritePPCLRPVarNamedWrite: aVarName.
        retval := retval rewritePPCLRPVarNamedRead: aVarName.
    ].
    ^retval
! !

!PPCLRPParser methodsFor:'error handing'!

failWithValue: anObject

    failed := true.
    lastError := anObject.
! !

!PPCLRPParser methodsFor:'grammar'!

body
    ^(variable / event / state / transition / timeoutIdentifier / timeoutInteger / epsilon / wildcard / comment / errorNode) star
!

errorNode
    ^(bra,  (bra/ket)negate star , ket) 
        ==> [ :tokens |  
                PPCLRPErrorNode new start: tokens first start stop: tokens last stop; yourself.
            ]
!

event
    ^ (bra, 'event' asParser trim, identifier, smalltalkBlock,  ket)  
        ==> [:tokens | | ident |
                ident := (tokens at: 3).
                (PPCLRPEvent named: ident inputValue 
                     trigger: (tokens  at: 4))
                start: tokens first start stop: tokens last stop;
                nameRange: (ident start to: ident stop);
                yourself.
            ]
!

integer 
    ^(#digit asParser) plus  token trim
!

machine
    ^(bra , 'machine' asParser trim , identifier , body , ket) 
        ==> [:tokens | | ident bod stop |
                ident := (tokens at: 3).
                bod := (tokens at: 4).
                bod isEmpty
                    ifTrue: [ stop := tokens last stop - 1 ]
                 		ifFalse: [ stop := (bod at: 1) start - 1 ].
                (PPCLRPMachine name: ident inputValue body: bod)
                    start: (tokens first start) stop: (tokens last stop);
                    nameRange: (ident start to: stop);
                    yourself.
            ]
!

onentry
    ^ (bra, 'onentry' asParser trim, (smalltalkBlock/spawn) ,  ket ) 
        ==> [:tokens | 
                (PPCLRPOnEntry block: (tokens at: 3))
                start: (tokens first start) stop: (tokens last stop);
                keywordEnd: (tokens at: 3) start -1;
                yourself.
            ]
!

onexit
    ^ (bra, 'onexit' asParser trim, (smalltalkBlock/spawn),  ket)  
        ==> [:tokens | 
                (PPCLRPOnExit block: (tokens at: 3))
                start: (tokens first start) stop: (tokens last stop);
                keywordEnd: (tokens at: 3) start -1;
                yourself.
            ]
!

program
    ^ (variable / machine / comment / spawn / errorNode) star
!

running
    ^ (bra, 'running' asParser trim, (smalltalkBlock/spawn),  ket)  
        ==> [:tokens | 
                (PPCLRPRunning block: (tokens at: 3))
                start: (tokens first start) stop: (tokens last stop);
                keywordEnd: (tokens at: 3) start -1;
                yourself.
            ]
!

spawn
    ^(bra , 'spawn' asParser trim , identifier , identifier , ket) 
        ==> [ :tokens |  
                (PPCLRPSpawn
                    machine: (tokens at: 3) inputValue
                    state: (tokens at: 4) inputValue)
                start: (tokens first start) stop: (tokens last stop);
                nameRange: ((tokens at: 3) start to: (tokens at: 4) stop)
                yourself.
            ]
        
!

state
    ^(bra , 'state' asParser trim , identifier , statebody , ket) 
        ==> [ :tokens | | ident |
                ident := (tokens at: 3).
                (PPCLRPState name: ident inputValue
                    body: (tokens at: 4))
                start: (tokens first start) stop: (tokens last stop);
                nameRange: (ident start to: ident stop);
                yourself.
            ]
        
!

statebody
    ^(onentry / running / onexit / machine / comment / errorNode) star
        
!

variable
    ^ (bra , 'var' asParser trim , identifier , ':=' asParser trim , smalltalkBlock , ket) 
        ==> [ :tokens | |ident|
            ident := (tokens at: 3).
            (PPCLRPVariable name: ident inputValue value: (tokens at: 5))
                start: (tokens first start) stop: (tokens last stop);
                nameRange: (ident start to: ident stop);
                yourself.
        ]
! !

!PPCLRPParser methodsFor:'grammar-comments'!

comment
    ^ ($; asParser, (endOfComment negate star),  endOfComment) token trim 
    ==> [ :token |  |text|
            text := token inputValue.
                (PPCLRPComment text: (text copyFrom: 1 to: text size -1) trim)
                start: (token start) stop: (token stop);
                yourself.
        ]
!

endOfComment
    ^ #eof asParser / lineTerminator
!

lineTerminator

    ^ (Character lf asParser) / (Character cr asParser , (Character lf asParser ) optional )
! !

!PPCLRPParser methodsFor:'grammar-common'!

bra
    ^ $( asParser token trim
!

identifier 
    ^(#letter asParser , (#word asParser /  $_ asParser) star) token trim
!

ket
    ^ $) asParser token trim
!

smalltalkBlock
    ^PPSmalltalkParser new productionAt: #block
! !

!PPCLRPParser methodsFor:'grammar-transitions'!

epsilon
    ^ (bra, 'eps' asParser trim, identifier, '->' asParser trim, identifier,  identifier optional, ket) 
        ==> [ :tokens |  | trans name |
                name := (tokens at: 6).
                name ifNil: [name := '' ] ifNotNil: [ name := name inputValue ].
                trans := 
                    (PPCLRPEpsilonTransition
                        from: (tokens at: 3) inputValue
                        to: (tokens at: 5) inputValue
                        name: name).
                self setTransitionRangesIn: trans for: tokens withArrowAt: 3. 
                trans
        ]
!

timeoutIdentifier
    ^ (bra, 'ontime' asParser trim, identifier , identifier, '->' asParser trim, identifier,  identifier optional, ket)
        ==> [:tokens | self transitionActionHandlerFor: PPCLRPTimeoutTransition tokens: tokens ].

    "Modified: / 30-07-2015 / 17:14:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timeoutInteger
    ^ (bra, 'ontime' asParser trim,  integer, identifier, '->' asParser trim, identifier,  identifier optional, ket)
        ==> [ :tokens | | trans name |
        name := (tokens at: 7).
        name ifNil: [name := '' ] ifNotNil: [ name := name inputValue ].
        trans :=
            (PPCLRPTimeoutTransition
                on: (Integer readFrom: (tokens at: 3) inputValue)
                from: (tokens at: 4) inputValue
                to: (tokens at: 6) inputValue
                name: name).
        self setTransitionRangesIn: trans for: tokens withArrowAt: 4.
        trans.
    ]
!

transition
    ^ (bra, 'on' asParser trim, identifier, identifier, '->' asParser trim, identifier,  identifier optional , ket) 
        ==> [ :tokens | self transitionActionHandlerFor: PPCLRPTransition tokens: tokens ]

    "Modified: / 30-07-2015 / 17:15:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wildcard
    ^ (bra, 'on' asParser trim, identifier,  '*->' asParser trim, identifier,  identifier optional, ket) 
        ==> [ :tokens |  | trans name |
                name := (tokens at: 6).
                name ifNil: [name := '' ] ifNotNil: [ name := name inputValue ].
                trans :=
                    (PPCLRPWildcardTransition
                        on: (tokens at: 3) inputValue
                        to: (tokens at: 5) inputValue
                        name: name ).
                self setTransitionRangesIn: trans for: tokens withArrowAt: 3. 
                trans
            ]
        
! !

!PPCLRPParser methodsFor:'parsing'!

parse: aText styleOn: aViewOrMorph
    |parsedProgram|
    
    parsedProgram := self parsePPCLRP: aText.
    self styler view: aViewOrMorph; parser: self; nodes: parsedProgram; style: aText.
    
    ^parsedProgram.
!

parsePPCLRP: aString

    |parsedProgram |
    failed := false.
    parsedProgram := self parse: aString.
    
    parsedProgram isPetitFailure ifTrue:[
        parsedProgram := 
            {PPCLRPErrorNode new 
                start: 1;
                stop: aString size; 
                yourself.
            }
    ].
    
    "visit pattern?"
    parsedProgram do:[:aNode|
        (aNode onErrorNode: [:anErrorNode| ] parser: self)
    ].
    
    ^parsedProgram.
! !

!PPCLRPParser methodsFor:'transitions'!

setTransitionRangesIn: aTransition for: aTokenArray withArrowAt: index
    | ident |
    ident := (aTokenArray at: index + 3).
    ident
        ifNil: [ aTransition nameRange: (1 to: 1) ]
        ifNotNil: [ aTransition nameRange: (ident start to: ident stop) ].
    aTransition
        start: (aTokenArray first start) stop: (aTokenArray last stop);
        arrowRange:
                    ((aTokenArray at: index) stop + 1
                        to: (aTokenArray at: index + 2) start -1);
        keywordEnd: (aTokenArray at: 3) start -1
!

transitionActionHandlerFor: class tokens: tokens
    | trans name|
    name := (tokens  at: 7).
    name isNil ifTrue:[ name := '' ] ifFalse:[ name := name inputValue ].
    trans :=
        (class
            on: (tokens at: 3) inputValue
            from: (tokens at: 4) inputValue
            to: (tokens at: 6) inputValue
            name: name).
    self setTransitionRangesIn: trans for: tokens withArrowAt: 4.
    ^ trans.

    "Created: / 30-07-2015 / 17:12:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

