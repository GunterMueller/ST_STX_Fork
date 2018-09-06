"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MCDefinitionIndex
	instanceVariableNames:'definitions'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Patching'
!

!MCDefinitionIndex class methodsFor:'documentation'!

documentation
"
    I'm a simple container of MCDefinitions which can be added or removed.
"
! !

!MCDefinitionIndex class methodsFor:'initialization'!

new
    ^self basicNew initialize
! !

!MCDefinitionIndex class methodsFor:'as yet unclassified'!

definitions: aCollection
	^ self new addAll: aCollection
! !

!MCDefinitionIndex methodsFor:'as yet unclassified'!

add: aDefinition
	definitions at: aDefinition description put: aDefinition
!

addAll: aCollection
	aCollection do: [:ea | self add: ea]
!

definitionLike: aDefinition ifPresent: foundBlock ifAbsent: errorBlock
	| definition |
	definition := definitions at: aDefinition description ifAbsent: [].
	^ definition
		ifNil: errorBlock
		ifNotNil: [foundBlock value: definition]
!

definitions
	^ definitions values
!

initialize
	super initialize.
	definitions := Dictionary new
!

remove: aDefinition
	definitions removeKey: aDefinition description ifAbsent: []
! !

!MCDefinitionIndex class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDefinitionIndex.st,v 1.5 2013-05-15 11:57:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDefinitionIndex.st,v 1.5 2013-05-15 11:57:02 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: MCDefinitionIndex.st,v 1.5 2013-05-15 11:57:02 cg Exp $'
! !

