"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCRHS
	instanceVariableNames:'collection reduceAction variableNames'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCRHS comment:'SmaCCRHS represents the right hand side of the production.

Instance variables:
	collection	<OrderedCollection of: SmaCCSymbol> the collection of symbols that represent the rhs
	grammar <SmaCCGrammar> the grammar that the production is in
	variableNames	<Dictionary key: String value: Integer>	the name of each symbol in the rhs. These names can be used in the {} code blocks.'
!


!SmaCCRHS class methodsFor:'instance creation'!

new
	^(super new)
		initialize;
		yourself
! !

!SmaCCRHS methodsFor:'accessing'!

add: aGrammarSymbol 
	collection add: aGrammarSymbol
!

at: anInteger 
	^collection at: anInteger
!

do: aBlock
	collection do: aBlock
!

firstTerminals
	| items |
	collection isEmpty ifTrue: [^Set with: SmaCCSymbol empty].
	items := Set new.
	1 to: collection size
		do: 
			[:index | 
			items addAll: (collection at: index) firstTerminals.
			(items includes: SmaCCSymbol empty) 
				ifTrue: [index < collection size ifTrue: [items remove: SmaCCSymbol empty]]
				ifFalse: [^items]].
	^items
!

lastTerminals
        | items |
        collection isEmpty ifTrue: [^Set with: SmaCCSymbol empty].
        items := Set new.
        collection size downTo: 1 
                do: 
                        [:index | 
                        items addAll: (collection at: index) lastTerminals.
                        (items includes: SmaCCSymbol empty) 
                                ifTrue: [index > 1 ifTrue: [items remove: SmaCCSymbol empty]]
                                ifFalse: [^items]].
        ^items

    "Created: / 24-02-2016 / 09:51:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameLastItem: aString 
	variableNames at: aString put: collection size
!

reduceAction
	^reduceAction
!

reduceAction: anObject
	reduceAction := anObject
!

size
	^collection size
! !

!SmaCCRHS methodsFor:'comparing'!

= aRHS 
	^self class = aRHS class and: [collection = aRHS collection]
!

hash
	^self class hash bitXor: (collection hash bitShift: 14)
! !

!SmaCCRHS methodsFor:'initialize-release'!

initialize
	collection := OrderedCollection new.
	reduceAction := nil.
	variableNames := Dictionary new
! !

!SmaCCRHS methodsFor:'printing'!

printOn: aStream 
	^collection do: [:each | each printOn: aStream]
		separatedBy: [aStream space]
! !

!SmaCCRHS methodsFor:'private'!

collection
	^collection
!

defaultReduceAction
	^#reduceFor:
! !

!SmaCCRHS methodsFor:'public'!

compileSourceFor: aGrammarSymbol in: aClass
        | action rewriter parseTree methodName |
        action := self reduceAction.
        action isNil ifTrue: [^self defaultReduceAction].
        parseTree := RBParser parseExpression: action
                                onError: 
                                        [:s :p | 
                                        Smalltalk isSmalltalkX ifTrue:[
                                            SmaCCCompilationNotification raiseSignal: 'Invalid Smalltalk code in reduction rule'
                                                    with: aGrammarSymbol name , ' : ' , self printString , '\\' withCRs , action.
                                        ] ifFalse:[
                                            SmaCCCompilationNotification signal: 'Invalid Smalltalk code in reduction rule'
                                                    with: aGrammarSymbol name , ' : ' , self printString , '\\' withCRs , action.
                                        ].
                                        ^self defaultReduceAction].
        (parseTree isLiteral and: 
                        [parseTree value isSymbol 
                                and: [parseTree value argumentCount <= 1 and: [aClass definesMethod: parseTree value]]]) 
                ifTrue: [^parseTree value].
        rewriter := self parseTreeRewriter.
        rewriter executeTree: parseTree.
        parseTree := rewriter tree.
        methodName := ('reduceActionFor' , (self safeMethodNameFor: aGrammarSymbol) 
                                , (aGrammarSymbol positionOf: self) printString , ':') 
                                asSymbol.
        parseTree isSequence 
                ifFalse: [parseTree := RBSequenceNode statements: (Array with: parseTree)].
        parseTree := RBMethodNode 
                                selector: methodName
                                arguments: (Array with: (RBVariableNode named: 'nodes'))
                                body: parseTree.
        parseTree addReturn.
        aClass compile: parseTree formattedCode classified: 'generated-reduction actions'.
        ^methodName
!

parseTreeRewriter
        | rewriter |
        rewriter := ParseTreeRewriter basicNew initialize.
        1 to: self size
                do: 
                        [:i | 
                        rewriter replace: i printString storeString
                                with: '(nodes at: ' , i printString , ')'].
        variableNames keysAndValuesDo: 
                        [:key :value | 
                        rewriter replace: key with: '(nodes at: ' , value printString , ')'].
        ^rewriter

    "Modified: / 10-09-2012 / 10:04:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

safeMethodNameFor: aGrammarSymbol 
	^aGrammarSymbol printString 
		collect: [:each | each isAlphaNumeric ifTrue: [each] ifFalse: [$_]]
! !

!SmaCCRHS class methodsFor:'documentation'!

version
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

