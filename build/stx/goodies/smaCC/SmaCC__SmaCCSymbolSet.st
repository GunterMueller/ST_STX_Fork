"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Model subclass:#SmaCCSymbolSet
	instanceVariableNames:'symbols components'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCSymbolSet comment:'SmaCCSymbolSet represents a set of follow symbols in the LALR(1) item sets.

Instance Variables:
	components	<Collection of: SmaCCSymbolSet>	other SmaCCSymbolSets that we depend on, we include all items in these sets also
	symbols	<Collection of: SmaCCTerminalSymbol>	our follow symbols'
!


!SmaCCSymbolSet class methodsFor:'instance creation'!

basedOn: aSymbolSet 
	^(self new)
		baseOn: aSymbolSet;
		yourself
!

new
	^(super new)
		initialize;
		yourself
! !

!SmaCCSymbolSet methodsFor:'accessing'!

add: aSymbol 
	(symbols includes: aSymbol) ifTrue: [^self].
	symbols add: aSymbol.
	self changed
!

addAll: aCollection 
	| oldSize |
	oldSize := symbols size.
	symbols addAll: aCollection.
	oldSize ~= symbols size ifTrue: [self changed]
!

baseOn: aSymbolSet 
	self addComponent: aSymbolSet.
	self addAll: aSymbolSet symbols
!

mergeWith: aSymbolSet 
	self addAll: aSymbolSet symbols.
	self addComponentsFrom: aSymbolSet
! !

!SmaCCSymbolSet methodsFor:'initialize-release'!

initialize
	symbols := Set new.
	components := Set new
! !

!SmaCCSymbolSet methodsFor:'printing'!

printOn: aStream 
	symbols do: [:each | aStream nextPutAll: each printString]
		separatedBy: [aStream space]
! !

!SmaCCSymbolSet methodsFor:'private'!

addComponent: each 
	(each = self or: [components includes: each]) ifTrue: [^self].
	components add: each.
	each addDependent: self.
	self addAll: each symbols
!

addComponentsFrom: aSymbolSet 
	aSymbolSet components do: [:each | self addComponent: each]
!

components
	^components
!

symbols
	^symbols
! !

!SmaCCSymbolSet methodsFor:'public'!

allSatisfy: aBlock 
	^symbols allSatisfy: aBlock
!

includes: aSymbol 
	^symbols includes: aSymbol
!

update: anAspectSymbol with: aParameter from: aSender 
	(components includes: aSender) ifTrue: [self addAll: aSender symbols]
! !

!SmaCCSymbolSet class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCSymbolSet.st,v 1.1 2006-02-09 21:17:38 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
