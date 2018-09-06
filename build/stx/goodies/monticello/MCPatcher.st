"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCPatcher
	instanceVariableNames:'definitions'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Patching'
!

!MCPatcher class methodsFor:'documentation'!

documentation
"
    I can add or remove or modify definitions. My main purpose is to generate
    monticello snapshot out of multiple snapshots or definitions by using my
    most used method #apply:to:.
"
! !

!MCPatcher class methodsFor:'as yet unclassified'!

apply: aPatch to: aSnapshot
	| loader |
	loader := self snapshot: aSnapshot.
	aPatch applyTo: loader.
	^ loader patchedSnapshot
!

snapshot: aSnapshot
	^ self new initializeWithSnapshot: aSnapshot
! !

!MCPatcher methodsFor:'as yet unclassified'!

addDefinition: aDefinition
	definitions add: aDefinition
!

initializeWithSnapshot: aSnapshot
	definitions := MCDefinitionIndex definitions: aSnapshot definitions
!

modifyDefinition: baseDefinition to: targetDefinition
	self addDefinition: targetDefinition
!

patchedSnapshot
	^ MCSnapshot fromDefinitions: definitions definitions
!

removeDefinition: aDefinition
	definitions remove: aDefinition
! !

!MCPatcher class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPatcher.st,v 1.5 2013-05-15 11:56:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPatcher.st,v 1.5 2013-05-15 11:56:18 cg Exp $'
!

version_SVN
    ^ '$Id: MCPatcher.st,v 1.5 2013-05-15 11:56:18 cg Exp $'
! !

