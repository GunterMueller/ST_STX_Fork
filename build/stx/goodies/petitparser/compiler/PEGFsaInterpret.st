"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PEGFsaInterpret
	instanceVariableNames:'fsa debug retvals stream'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaInterpret class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PEGFsaInterpret methodsFor:'accessing'!

debug
    ^ debug
!

debug: anObject
    debug := anObject
!

fsa
    ^ fsa
!

recordFor: retval
    ^ retvals at: retval ifAbsentPut: [ PEGFsaInterpretRecord new ]
! !

!PEGFsaInterpret methodsFor:'debugging'!

reportFsa: anFsa
    debug ifTrue: [ 
        Transcript show: anFsa asString; cr.
    ]
!

reportStart
    debug ifTrue: [ 
        Transcript show: '============================'; cr.
    ]
!

reportStates: states
    debug ifTrue: [ 
        Transcript show: 'states: '; show: states printString; cr
    ]

    "Modified: / 17-08-2015 / 13:37:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PEGFsaInterpret methodsFor:'initialization'!

initialize
    super initialize.
    debug := true
! !

!PEGFsaInterpret methodsFor:'running'!

interpret
    | states newStates character run  |
    newStates := IdentitySet with: fsa startState.
    retvals := IdentityDictionary new.
    
    self recordNewState: fsa startState position: 0.
    
    self reportStart.
    self reportFsa: fsa.
    
    run := "stream atEnd not" true.
    
    [run] whileTrue: [  
        states := newStates.
        newStates := IdentitySet new.
        character := stream peek codePoint.

        self reportStates: states.

        states do: [ :state |
            self expand: state on: character into: newStates.
        ].
        
        newStates isEmpty ifFalse: [ stream next ].
        run := "stream atEnd not and: [ "newStates isEmpty not" ]".
    ].
    ^ self return: states
!

interpret: anFsa on: aStream
    fsa := anFsa.
    stream := aStream.
    
    ^ self interpret
! !

!PEGFsaInterpret methodsFor:'running support'!

allowsTransition: t from: state transitionsTaken: transitionsTaken
"	(state hasPriority) ifTrue: [ 
        ^ state priority <= t priority
    ].
"	
    "state hasPriority ifTrue: [ "
"		transitionsTaken isEmpty ifTrue: [ ^ true ].
        ^ transitionsTaken anyOne priority <= t priority.
"	"]."
    ^ true
!

expand: state on: codePoint into: newStates
    state transitions do: [ :t | 
        t isEpsilon ifTrue: [  
            (t destination isFinal) ifTrue: [ 
                newStates add: t destination.
                self recordNewState: t destination position: stream position.
            ].

            "Descent into the next state"
            self 	expand: t destination 
                    on: codePoint 
                    into: newStates.
        ] ifFalse: [  
            (t acceptsCodePoint: codePoint) ifTrue: [ 
                newStates add: t destination.
                self recordNewState: t destination.
            ]
        ] 
    ]
!

recordNewState: state
    ^ self recordNewState: state position: stream position + 1
!

recordNewState: state position: position
    | currentRecord |
    (state isFinal) ifFalse: [ 
        ^ self 
    ].

    (state isFinal) ifFalse: [ self error: 'should not happen' ].
    self assert: state hasPriority description: 'final state must have priority'.

    state retvalsAndInfosDo: [ :retval :info |
        currentRecord := self recordFor: retval.
        info isFsaFailure ifTrue: [ 
            "JK: hack, nil refers to failure!! :( Refactor!!"
            currentRecord position: nil
        ] ifFalse: [ 
     		currentRecord position: position	
        ]
    ].
!

return: states
    | return |
    return := IdentityDictionary new.
    retvals keys do:[:key | 
        | value |

        value := retvals at: key.
        (value position isNil) ifTrue:[ 
            retvals removeKey: key
        ].
    ].
    retvals keysAndValuesDo: [ :key :value |
        return at: key put: value position
    ].
    ^ return

    "Modified: / 17-08-2015 / 13:45:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sortedTransitionsFor: state
    self error: 'deprecated!!'.
    ^ (fsa transitionsFor: state) asOrderedCollection
        "Dear future me, enjoy this:"
"		sort: [ :e1 :e2 | (e1 isEpsilon not and: [e2 isEpsilon]) not ])"
        sort: [ :e1 :e2 | e1 priority > e2 priority ]
            
! !

