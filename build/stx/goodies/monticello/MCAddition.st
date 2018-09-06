"{ Package: 'stx:goodies/monticello' }"

MCPatchOperation subclass:#MCAddition
	instanceVariableNames:'definition'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Patching'
!


!MCAddition class methodsFor:'as yet unclassified'!

of: aDefinition
	^ self new intializeWithDefinition: aDefinition
! !

!MCAddition methodsFor:'accessing'!

applyTo: anObject
	anObject addDefinition: definition
!

baseDefinition
	^ nil
!

definition
	^ definition
!

fromSource
	^ ''
!

sourceString
	^(self toSource asText)
		addAttribute: TextColor red;
		yourself
!

summary
	^ definition summary
!

targetClass
	^definition actualClass 
!

targetDefinition
	^ definition
!

toSource
	^ definition source
! !

!MCAddition methodsFor:'as yet unclassified'!

inverse
	^ MCRemoval of: definition
!

isClassPatch
	^definition isClassDefinition
! !

!MCAddition methodsFor:'initializing'!

intializeWithDefinition: aDefinition
	definition _ aDefinition
! !

!MCAddition methodsFor:'testing'!

isAddition
	^ true
! !

!MCAddition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCAddition.st,v 1.2 2012-09-11 21:20:14 cg Exp $'
! !
