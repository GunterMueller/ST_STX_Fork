"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCSymbol subclass:#SmaCCNonTerminalSymbol
	instanceVariableNames:'productions'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCNonTerminalSymbol comment:'SmaCCNonTerminalSymbol represents a non-terminal symbol in our grammar.

Instance Variables:
	productions	<SequenceableCollection of: SmaCCRHS>	our rhs'' for the symbol'
!


!SmaCCNonTerminalSymbol methodsFor:'accessing'!

addProduction: aRHS
	productions add: aRHS
!

calculateFirstTerminals
	| initialSize |
	initialSize := firstItems size.
	productions isEmpty 
		ifTrue: [firstItems add: self class empty]
		ifFalse: [productions do: [:each | firstItems addAll: each firstTerminals]].
	^initialSize ~= firstItems size
!

calculateLastTerminals
        | initialSize |
        initialSize := lastItems size.
        productions isEmpty 
                ifTrue: [lastItems add: self class empty]
                ifFalse: [productions do: [:each | lastItems addAll: each lastTerminals]].
        ^initialSize ~= lastItems size

    "Created: / 24-02-2016 / 09:39:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

positionOf: aRHS 
	^productions indexOf: aRHS
!

productionsDo: aBlock 
	productions do: aBlock
!

size
	^productions size
! !

!SmaCCNonTerminalSymbol methodsFor:'initialize-release'!

name: aString 
	super name: aString.
	productions := OrderedCollection new
! !

!SmaCCNonTerminalSymbol methodsFor:'public'!

isEmpty
	^productions isEmpty
!

isTerminal
	^false
! !

!SmaCCNonTerminalSymbol class methodsFor:'documentation'!

version
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

