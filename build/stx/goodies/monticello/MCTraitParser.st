"{ Package: 'stx:goodies/monticello' }"

MCDoItParser subclass:#MCTraitParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCTraitParser class methodsFor:'as yet unclassified'!

pattern
	^ 'Trait named:*'
! !

!MCTraitParser methodsFor:'as yet unclassified'!

addDefinitionsTo: aCollection
	| tokens  definition traitCompositionString |
	tokens := Scanner new scanTokens: source.
	traitCompositionString := ((ReadStream on: source)
		match: 'uses:';
		upToAll: 'category:') withBlanksTrimmed.
	definition := MCTraitDefinition
		name: (tokens at: 3) 
		traitComposition: traitCompositionString
		category:  tokens last
		comment:  ''  
		commentStamp:   ''.
	aCollection add: definition.
! !

!MCTraitParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCTraitParser.st,v 1.3 2012-09-11 21:29:58 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCTraitParser.st,v 1.3 2012-09-11 21:29:58 cg Exp $'
!

version_SVN
    ^ '§Id: MCTraitParser.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
