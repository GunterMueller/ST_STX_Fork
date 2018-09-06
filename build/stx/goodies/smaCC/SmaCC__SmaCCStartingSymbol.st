"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCNonTerminalSymbol subclass:#SmaCCStartingSymbol
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCStartingSymbol comment:'SmaCCStartingSymbol is the starting symbol in the grammar. A grammar can only have one starting symbol, but it can have may different starting item sets.'
!


!SmaCCStartingSymbol methodsFor:'accessing'!

asLRItemSet
	| itemSet |
	itemSet := SmaCCItemSet new.
	productions do: 
			[:each | 
			itemSet add: (SmaCCLR1Item 
						symbol: self
						rhs: each
						follow: ((SmaCCSymbolSet new)
								add: self class empty;
								yourself))].
	^itemSet
!

compileName
	^(productions first at: 1) name
! !

!SmaCCStartingSymbol methodsFor:'public'!

isStartingSymbol
	^true
! !

!SmaCCStartingSymbol class methodsFor:'documentation'!

version
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

