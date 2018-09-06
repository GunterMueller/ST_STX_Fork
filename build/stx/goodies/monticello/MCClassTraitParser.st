"{ Package: 'stx:goodies/monticello' }"

MCDoItParser subclass:#MCClassTraitParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCClassTraitParser class methodsFor:'as yet unclassified'!

pattern
	^ '*classTrait*uses:*'
! !

!MCClassTraitParser methodsFor:'as yet unclassified'!

addDefinitionsTo: aCollection
	| tokens  definition traitCompositionString |
	tokens := Scanner new scanTokens: source.
	traitCompositionString := ((ReadStream on: source)
		match: 'uses:';
		upToEnd) withBlanksTrimmed.
	definition := MCClassTraitDefinition
		baseTraitName: (tokens at: 1) 
		classTraitComposition: traitCompositionString.
	aCollection add: definition

! !

!MCClassTraitParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCClassTraitParser.st,v 1.3 2012-09-11 21:20:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCClassTraitParser.st,v 1.3 2012-09-11 21:20:47 cg Exp $'
!

version_SVN
    ^ '§Id: MCClassTraitParser.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
