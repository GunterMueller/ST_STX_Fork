"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Set subclass:#SmaCCItemSet
	instanceVariableNames:'type derivedFrom id'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCItemSet comment:'SmaCCItemSet represents a LALR(1) or a LR(1) item set.

Instance Variables:
	type	<Symbol>	#LALR1 or #LR1

'
!


!SmaCCItemSet class methodsFor:'instance creation'!

new: anInteger 
	^(super new: anInteger)
		initialize;
		yourself
! !

!SmaCCItemSet methodsFor:'accessing'!

action: aGrammarSymbol prefer: aClass 
	| action actionItem eachAction |
	action := SmaCCRejectAction new.
	self do: 
			[:each | 
			eachAction := each action: aGrammarSymbol.
			action class = SmaCCRejectAction 
				ifTrue: 
					[action := eachAction.
					actionItem := each]
				ifFalse: 
					[(eachAction = action or: [eachAction class = SmaCCRejectAction]) 
						ifFalse: 
							[eachAction class = SmaCCShiftAction | (action class = SmaCCShiftAction) 
								ifTrue: 
									["Shift/Reduce conflict -- check precedence"

									(aGrammarSymbol precedence isNil 
										or: [each precedence isNil or: [actionItem precedence isNil]]) 
											ifTrue: 
												["No precedence, choose shift"

												eachAction class = SmaCCShiftAction 
													ifTrue: 
														[self 
															raiseXReduceNotification: each
															with: actionItem
															type: 'Shift/Reduce Conflict'.
														action := eachAction.
														actionItem := each]
													ifFalse: 
														[self 
															raiseXReduceNotification: actionItem
															with: each
															type: 'Shift/Reduce Conflict']]
											ifFalse: 
												[(each precedence > actionItem precedence 
													or: [each precedence = actionItem precedence and: [eachAction class = aClass]]) 
														ifTrue: 
															[self 
																raiseXReduceNotification: each
																with: actionItem
																type: 'Shift/Reduce Conflict (handled by precedence rules)'.
															action := eachAction.
															actionItem := each]
														ifFalse: 
															[(each precedence = actionItem precedence and: [SmaCCRejectAction = aClass]) 
																ifTrue: 
																	[self 
																		raiseXReduceNotificationWithNoPreferredItem: actionItem
																		with: each
																		type: 'Shift/Reduce Conflict (handled by precedence rules)'.
																	^aClass new]
																ifFalse: 
																	[self 
																		raiseXReduceNotification: actionItem
																		with: each
																		type: 'Shift/Reduce Conflict (handled by precedence rules)']]]]
								ifFalse: 
									["Reduce/Reduce conflict -- just pick one and proceed"

									self 
										raiseXReduceNotification: actionItem
										with: each
										type: 'Reduce/Reduce Conflict']]]].
	^action
!

derivedFrom
    ^ derivedFrom

    "Created: / 14-02-2008 / 13:26:17 / janfrog"
!

derivedFrom:something
    derivedFrom := something.

    "Created: / 14-02-2008 / 13:26:17 / janfrog"
!

id
    ^ id

    "Created: / 14-02-2008 / 13:28:54 / janfrog"
!

id:something
    id := something.

    "Created: / 14-02-2008 / 13:28:54 / janfrog"
!

mergeWith: anItemSet 
	self == anItemSet ifTrue: [^self].
	anItemSet do: [:each | self add: each]
!

moveOn: aGrammarSymbol 
        | anItemSet |
        anItemSet := self class new.
        anItemSet type: type.
        anItemSet derivedFrom: self.
        self 
                do: [:each | each nextSymbol == aGrammarSymbol ifTrue: [anItemSet add: each moveNext]].
        ^anItemSet

    "Modified: / 14-02-2008 / 13:26:51 / janfrog"
!

raiseXReduceNotification: preferredItem with: otherItem type: aString
        | stream |
        stream := WriteStream on: (String new: 200).
        stream
                nextPutAll: preferredItem printString;
                nextPutAll: '   *****';
                cr;
                nextPutAll: otherItem printString.
        Smalltalk isSmalltalkX ifTrue:[
            SmaCCCompilationNotification raiseSignal: aString with: stream contents
        ] ifFalse:[
            SmaCCCompilationNotification signal: aString with: stream contents
        ]

!

raiseXReduceNotificationWithNoPreferredItem: firstItem with: secondItem type: aString
        | stream |
        stream := WriteStream on: (String new: 200).
        stream
                nextPutAll: firstItem printString;
                cr;
                nextPutAll: secondItem printString.
        Smalltalk isSmalltalkX ifTrue:[
            SmaCCCompilationNotification raiseSignal: aString with: stream contents
        ] ifFalse:[
            SmaCCCompilationNotification signal: aString with: stream contents
        ]
        
! !

!SmaCCItemSet methodsFor:'adding'!

add: aLR1Item
        | index item |
        aLR1Item == nil ifTrue: [^aLR1Item].
        Smalltalk isSmalltalkX ifTrue:[
            index := self findKeyOrNil: aLR1Item.
            item := keyArray basicAt: index.
            item == nil 
                    ifTrue: 
                            [keyArray basicAt: index put: aLR1Item.
                             tally := tally + 1.
                            self performClosureOn: aLR1Item]
                    ifFalse: [item mergeWith: aLR1Item].
        ] ifFalse:[
            index := self findElementOrNil: aLR1Item.
            item := self basicAt: index.
            item == nil 
                    ifTrue: 
                            [self privateAt: index put: aLR1Item.
                            self performClosureOn: aLR1Item]
                    ifFalse: [item mergeWith: aLR1Item].
        ].
        ^aLR1Item
! !

!SmaCCItemSet methodsFor:'comparing'!

= anItemSet 
	self class = anItemSet class 
		ifTrue: 
			[type == #LALR1
				ifTrue: [^self isLALREqualTo: anItemSet]
				ifFalse: [^self isLREqualTo: anItemSet]].
	^false
!

hash
	^self inject: self class hash into: [:sum :each | sum bitXor: each hash]
! !

!SmaCCItemSet methodsFor:'copying'!

copyEmpty: aSize 
	^(super copyEmpty: aSize)
		type: type;
		yourself
! !

!SmaCCItemSet methodsFor:'initialize-release'!

initialize
	(self class superclass canUnderstand: #initialize) 
		ifTrue: [super initialize].
	type := #LALR1
!

type: aSymbol 
	type := aSymbol
! !

!SmaCCItemSet methodsFor:'printing'!

printOn:aStream
    id ifNotNil:
        [aStream nextPutAll: id printString asText allBold].
    derivedFrom ifNotNil:
        [derivedFrom id ifNotNil:
            [aStream 
                nextPutAll:' (derived from ';
                nextPutAll:derivedFrom id printString asText allBold;
                nextPut:$)]].
    aStream cr.

    self do:[:each | 
        aStream
            tab;
            nextPutAll:each printString;
            cr
    ]

    "Modified: / 14-02-2008 / 13:34:50 / janfrog"
! !

!SmaCCItemSet methodsFor:'private'!

itemFor: anObject 
        Smalltalk isSmalltalkX ifTrue:[
            ^keyArray basicAt: (self findKeyOrNil: anObject)
        ].
        ^self basicAt: (self findElementOrNil: anObject)
!

performClosureOn: aLR1Item 
	| nextSymbol rest first followers |
	nextSymbol := aLR1Item nextSymbol.
	nextSymbol isTerminal ifTrue: [^self].
	rest := aLR1Item rest.
	first := rest firstTerminals.
	followers := SmaCCSymbolSet new.
	(first includes: SmaCCSymbol empty) 
		ifTrue: 
			[first remove: SmaCCSymbol empty.
			followers baseOn: aLR1Item followers].
	followers addAll: first.
	nextSymbol productionsDo: 
			[:each | 
			self add: (SmaCCLR1Item 
						symbol: nextSymbol
						rhs: each
						follow: followers)]
! !

!SmaCCItemSet methodsFor:'public'!

isLALREqualTo: anItemSet 
	^anItemSet size = self size 
		and: [self allSatisfy: [:each | anItemSet includes: each]]
!

isLREqualTo: anItemSet 
	^anItemSet size = self size and: 
			[self allSatisfy: 
					[:each | 
					| item |
					(item := anItemSet itemFor: each) notNil and: [each isLR1EqualTo: item]]]
! !

!SmaCCItemSet class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCItemSet.st,v 1.2 2008-02-17 10:30:37 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
