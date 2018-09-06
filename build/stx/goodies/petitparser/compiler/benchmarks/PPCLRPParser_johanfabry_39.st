"{ Package: 'stx:goodies/petitparser/compiler/benchmarks' }"

"{ NameSpace: Smalltalk }"

PPCompositeParser subclass:#PPCLRPParser_johanfabry_39
	instanceVariableNames:'program variable block bra ket identifier machine body event
		transition epsilon wildcard state onentry running onexit comment
		lineTerminator statebody spawn integer errorNode success failed
		lastError styler timeoutIdentifier timeoutInteger endOfComment
		error'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Benchmarks-Core'
!


!PPCLRPParser_johanfabry_39 class methodsFor:'accessing'!

ignoredNames

    ^super ignoredNames , #(styler failed lastError)
! !

!PPCLRPParser_johanfabry_39 methodsFor:'accessing'!

error
    ^error

    "Modified (format): / 18-08-2015 / 16:56:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

styler
    ^styler ifNil:[styler := PPCLRPRubricStyler new]
!

styler: aSHStyler

    styler := aSHStyler.
!

success
    ^success
! !

!PPCLRPParser_johanfabry_39 methodsFor:'block creation'!

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
        retval := retval rewriteLRPVarNamedWrite: aVarName.
        retval := retval rewriteLRPVarNamedRead: aVarName.
    ].
    ^retval
! !

!PPCLRPParser_johanfabry_39 methodsFor:'error handing'!

failWithValue: anObject

    failed := true.
    lastError := anObject.
! !

!PPCLRPParser_johanfabry_39 methodsFor:'grammar'!

body
    ^(variable / event / state / transition / timeoutIdentifier / timeoutInteger / epsilon / wildcard / comment / errorNode) star
!

errorNode
    ^(bra,  (bra/ket)negate star , ket) token
        ==> [ :token |  
                PPCLRPErrorNode new start: token start stop: token stop; yourself.
            ]
!

event
    ^ (bra, 'event' asParser trim, identifier, block,  ket) token 
        ==> [:token | | ident |
                ident := (token parsedValue at: 3).
                (LRPEvent named: ident parsedValue
                     trigger: (token parsedValue at: 4))
                start: token start stop: token stop;
                nameRange: (ident start to: ident stop);
                yourself.
            ]
!

integer 
    ^(#digit asParser) plus flatten trim token
!

machine
    ^(bra , 'machine' asParser trim , identifier , body , ket) token
        ==> [:token | | ident bod stop |
                ident := (token parsedValue at: 3).
                bod := (token parsedValue at: 4).
                bod isEmpty
                    ifTrue: [ stop := token stop - 1 ]
                 	ifFalse: [ stop := (bod at: 1) start - 1 ].
                (LRPMachine name: ident parsedValue body: bod)
                    start: token start stop: token stop;
                    nameRange: (ident start to: stop);
                    yourself.
            ]
!

onentry
    ^ (bra, 'onentry' asParser trim, (block/spawn) ,  ket ) token
        ==> [:token | 
                (LRPOnEntry block: (token parsedValue at: 3))
                start: token start stop: token stop;
                keywordEnd: (token parsedValue at: 3) start -1;
                yourself.
            ]
!

onexit
    ^ (bra, 'onexit' asParser trim, (block/spawn),  ket) token 
        ==> [:token | 
                (LRPOnExit block: (token parsedValue at: 3))
                start: token start stop: token stop;
                keywordEnd: (token parsedValue at: 3) start -1;
                yourself.
            ]
!

program
    ^ (variable / machine / comment / spawn / errorNode) star
!

running
    ^ (bra, 'running' asParser trim, (block/spawn),  ket) token 
        ==> [:token | 
                (LRPRunning block: (token parsedValue at: 3))
                start: token start stop: token stop;
                keywordEnd: (token parsedValue at: 3) start -1;
                yourself.
            ]
!

spawn
    ^(bra , 'spawn' asParser trim , identifier , identifier , ket) token
        ==> [ :token |  
                (LRPSpawn
                    machine: (token parsedValue at: 3) parsedValue
                    state: (token parsedValue at: 4) parsedValue)
                start: token start stop: token stop;
                nameRange: ((token parsedValue at: 3) start to: (token parsedValue at: 4) stop)
                yourself.
            ]
        
!

state
    ^(bra , 'state' asParser trim , identifier , statebody , ket) token
        ==> [ :token | | ident |
                ident := (token parsedValue at: 3).
                (LRPState name: ident parsedValue
                    body: (token parsedValue at: 4))
                start: token start stop: token stop;
                nameRange: (ident start to: ident stop);
                yourself.
            ]
        
!

statebody
    ^(onentry / running / onexit / machine / comment / errorNode) star
        
!

variable
    ^ (bra , 'var' asParser trim , identifier , ':=' asParser trim , block , ket) token 
        ==> [ :token | |ident|
            ident := (token parsedValue at: 3).
            (LRPVariable name: ident parsedValue
                value: (token parsedValue at: 5))
            start: token start stop: token stop;
            nameRange: (ident start to: ident stop);
            yourself.
        ]
! !

!PPCLRPParser_johanfabry_39 methodsFor:'grammar-comments'!

comment
    ^ ((PPPredicateObjectParser blank / lineTerminator) star,  ( $; asParser , (endOfComment negate star) flatten,  endOfComment)) token
    ==> [ :token |  |text|
            text := token parsedValue at: 2.
                (LRPComment text: (text copyFrom: 2 to: text size -1))
                start: token start stop: token stop;
                yourself.
        ]
!

endOfComment
    ^ #eof asParser / lineTerminator
!

lineTerminator

    ^ (Character lf asParser) / (Character cr asParser , (Character lf asParser ) optional )
! !

!PPCLRPParser_johanfabry_39 methodsFor:'grammar-common'!

block
    ^PPSmalltalkParser new block
!

bra
    ^ $( asParser trim
!

identifier 
    ^(#letter asParser ,(#letter asParser / #digit asParser /  $_ asParser) star)  flatten trim token
!

ket
    ^ $) asParser trim
! !

!PPCLRPParser_johanfabry_39 methodsFor:'grammar-transitions'!

epsilon
    ^ (bra, 'eps' asParser trim, identifier, '->' asParser trim, identifier,  identifier optional, ket) token
        ==> [ :token |  | trans name |
                name := (token parsedValue at: 6).
                name ifNil: [name := '' ] ifNotNil: [ name := name parsedValue ].
                trans := 
                    (LRPEpsilonTransition
                        from: (token parsedValue at: 3) parsedValue
                        to: (token parsedValue at: 5) parsedValue
                        name: name).
                self setTransitionRangesIn: trans for: token withArrowAt: 3. 
                trans
        ]
!

timeoutIdentifier
    ^ (bra, 'ontime' asParser trim, identifier , identifier, '->' asParser trim, identifier,  identifier optional, ket) token
        ==> (self transitionActionHandlerFor: PPCLRPTimeoutTransition).
!

timeoutInteger
    ^ (bra, 'ontime' asParser trim,  integer, identifier, '->' asParser trim, identifier,  identifier optional, ket) token
        ==> [ :token | | trans name |
        name := (token parsedValue at: 7).
        name ifNil: [name := '' ] ifNotNil: [ name := name parsedValue ].
        trans :=
            (LRPTimeoutTransition
                on: (Integer readFrom: (token parsedValue at: 3) parsedValue)
                from: (token parsedValue at: 4) parsedValue
                to: (token parsedValue at: 6) parsedValue
                name: name).
        self setTransitionRangesIn: trans for: token withArrowAt: 4.
        trans.
    ]
!

transition
    ^ (bra, 'on' asParser trim, identifier, identifier, '->' asParser trim, identifier,  identifier optional , ket) token
        ==> (self transitionActionHandlerFor: PPCLRPTransition).
!

wildcard
    ^ (bra, 'on' asParser trim, identifier,  '*->' asParser trim, identifier,  identifier optional, ket) token
        ==> [ :token |  | trans name |
                name := (token parsedValue at: 6).
                name ifNil: [name := '' ] ifNotNil: [ name := name parsedValue ].
                trans :=
                    (LRPWildcardTransition
                        on: (token parsedValue at: 3) parsedValue
                        to: (token parsedValue at: 5) parsedValue
                        name: name ).
                self setTransitionRangesIn: trans for: token withArrowAt: 3. 
                trans
            ]
        
! !

!PPCLRPParser_johanfabry_39 methodsFor:'parsing'!

parse: aString

    |parsedProgram |
    failed := false.
    parsedProgram := super parse: aString.
    
    parsedProgram isPetitFailure ifTrue:[
        parsedProgram := 
            {LRPErrorNode new 
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
!

parse: aString onError: aBlock
    |parsedProgram|
    
    parsedProgram := self parse: aString.
    
    failed ifTrue:[
        "visit pattern?"
        parsedProgram do:[:aNode|
            (aNode onErrorNode: aBlock parser: self)
        ].
    ].

    ^parsedProgram.
!

parse: aText styleOn: aViewOrMorph
    |parsedProgram|
    
    parsedProgram := self parse: aText.
    self styler view: aViewOrMorph; parser: self; nodes: parsedProgram; style: aText.
    
    ^parsedProgram.
! !

!PPCLRPParser_johanfabry_39 methodsFor:'transitions'!

setTransitionRangesIn: aTransition for: aToken withArrowAt: index
    | ident |
    ident := (aToken parsedValue at: index + 3).
    ident
        ifNil: [ aTransition nameRange: (1 to: 1) ]
        ifNotNil: [ aTransition nameRange: (ident start to: ident stop) ].
    aTransition
        start: aToken start stop: aToken stop;
        arrowRange:
                    ((aToken parsedValue at: index) stop + 1
                        to: (aToken parsedValue at: index + 2) start -1);
        keywordEnd: (aToken parsedValue at: 3) start -1
!

transitionActionHandlerFor: aTransitionClass
    ^[ :token | | trans name|
        name := (token parsedValue at: 7).
        name ifNil: [name := '' ] ifNotNil: [ name := name parsedValue ].
        trans :=
            (aTransitionClass
                on: (token parsedValue at: 3) parsedValue
                from: (token parsedValue at: 4) parsedValue
                to: (token parsedValue at: 6) parsedValue
                name: name).
        self setTransitionRangesIn: trans for: token withArrowAt: 4.
        trans.
    ]
! !

!PPCLRPParser_johanfabry_39 class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

