"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCLR1Item
	instanceVariableNames:'rhs symbol location followers'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCLR1Item comment:'SmaCCLR1Item represents an item in a SmaCCItemSet.

Instance Variables:
	followers	<SmaCCSymbolSet>	all possible symbols that can follow this production in this state
	location	<Integer>	the position in the rhs of the production we are at
	rhs	<SmaCCRHS>	the rhs of the production
	symbol	<SmaCCSymbol>	the symbol for the production'
!


!SmaCCLR1Item class methodsFor:'instance creation'!

symbol: productionGrammarSymbol rhs: aRHS follow: aGrammarSymbolCollection 
	^(self new)
		symbol: productionGrammarSymbol
			rhs: aRHS
			follow: aGrammarSymbolCollection;
		yourself
! !

!SmaCCLR1Item methodsFor:'accessing'!

action: aGrammarSymbol 
	location > rhs size 
		ifTrue: 
			[(symbol isStartingSymbol and: [aGrammarSymbol isEmptySymbol]) 
				ifTrue: [^SmaCCAcceptAction new].
			(followers includes: aGrammarSymbol) 
				ifTrue: [^SmaCCReduceAction symbol: symbol rhs: rhs]]
		ifFalse: [(rhs at: location) = aGrammarSymbol ifTrue: [^SmaCCShiftAction new]].
	^SmaCCRejectAction new
!

followers
	^followers
!

mergeWith: aLRItem 
	followers mergeWith: aLRItem followers
!

moveNext
	^(self copy)
		followers: (followers class basedOn: followers);
		location: location + 1;
		yourself
!

nextSymbol
	^location > rhs size 
		ifTrue: [SmaCCSymbol sentinel]
		ifFalse: [rhs at: location]
!

precedence
	"If we don't have a precedence, then assume we are the lowest precedence (which will cause a shift action)."

	| max |
	max := -1.
	rhs do: [:each | max := max max: (each precedence ifNil: [max])].
	^max
!

rest
	| newRHS |
	newRHS := SmaCCRHS new.
	location + 1 to: rhs size do: [:each | newRHS add: (rhs at: each)].
	^newRHS
! !

!SmaCCLR1Item methodsFor:'comparing'!

= anItem 
	^self class == anItem class and: 
			[location == anItem location 
				and: [rhs == anItem rhs and: [symbol == anItem symbol]]]
!

hash
	^(symbol identityHash bitXor: (location bitShift: 14)) 
		bitXor: rhs identityHash
! !

!SmaCCLR1Item methodsFor:'initialize-release'!

followers: aSymbolSet 
	followers := aSymbolSet
!

location: anInteger 
	location := anInteger
!

symbol: productionGrammarSymbol rhs: aRHS follow: aSymbolCollection 
	symbol := productionGrammarSymbol.
	rhs := aRHS.
	location := 1.
	followers := aSymbolCollection
! !

!SmaCCLR1Item methodsFor:'printing'!

printOn: aStream 
        | i |
        aStream
                nextPut: $[;
                nextPutAll: symbol printString;
                nextPutAll: ' :'.
        i := 1.
        rhs do: 
                        [:each | 
                        i = location ifTrue: [aStream nextPutAll: ' . ' asText allBold].
                        aStream
                                space;
                                nextPutAll: each printString.
                        i := i + 1].
        location > rhs size ifTrue: [aStream nextPutAll: ' . ' asText allBold].
        aStream nextPut: $;.
        followers printOn: aStream.
        aStream nextPut: $]

    "Modified: / 14-02-2008 / 12:28:48 / janfrog"
! !

!SmaCCLR1Item methodsFor:'private'!

location
	^location
!

rhs
	^rhs
!

symbol
	^symbol
! !

!SmaCCLR1Item methodsFor:'public'!

isLR1EqualTo: aLRItem 
	^self followers size = aLRItem followers size 
		and: [self followers allSatisfy: [:each | aLRItem followers includes: each]]
! !

!SmaCCLR1Item class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCLR1Item.st,v 1.2 2008-02-17 10:30:47 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
