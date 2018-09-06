"{ Package: 'stx:goodies/monticello' }"

MCDoItParser subclass:#MCSystemCategoryParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Chunk Format'
!

!MCSystemCategoryParser class methodsFor:'documentation'!

documentation
"
    I parse PackageInfo statement from Monticello packages file
"
! !

!MCSystemCategoryParser class methodsFor:'as yet unclassified'!

pattern
	^ 'SystemOrganization*'
! !

!MCSystemCategoryParser methodsFor:'as yet unclassified'!

addDefinitionsTo: aCollection
	| definition |
	definition := aCollection detect: [:ea | ea isOrganizationDefinition ] ifNone: [aCollection add: (MCOrganizationDefinition categories: #())].
	definition categories: (definition categories copyWith: self category).
!

category
	| tokens  |
	tokens := Scanner new scanTokens: source.
	tokens size = 3 ifFalse: [self error: 'Unrecognized category definition'].
	^ tokens at: 3
! !

!MCSystemCategoryParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSystemCategoryParser.st,v 1.5 2013-05-15 09:50:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSystemCategoryParser.st,v 1.5 2013-05-15 09:50:42 cg Exp $'
!

version_SVN
    ^ '$Id: MCSystemCategoryParser.st,v 1.5 2013-05-15 09:50:42 cg Exp $'
! !

