"{ Package: 'stx:goodies/monticello' }"

MCPatchOperation subclass:#MCRemoval
	instanceVariableNames:'definition'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Patching'
!


!MCRemoval class methodsFor:'as yet unclassified'!

of: aDefinition
	^ self new intializeWithDefinition: aDefinition
! !

!MCRemoval methodsFor:'accessing'!

applyTo: anObject
	anObject removeDefinition: definition
!

baseDefinition
	^ definition
!

definition
	^ definition
!

fromSource
	^ definition source
!

sourceString
	^self fromSource asText
		addAttribute: TextEmphasis struckOut;
		addAttribute: TextColor blue;
		yourself
!

summary
	^ definition summary, ' (removed)'
!

summarySuffix
	^ ' (removed)'
!

targetClass
	^ definition actualClass
!

targetDefinition
	^ nil
!

toSource
	^ ''
! !

!MCRemoval methodsFor:'as yet unclassified'!

inverse
	^ MCAddition of: definition
!

isClassPatch
	^definition isClassDefinition
! !

!MCRemoval methodsFor:'initializing'!

intializeWithDefinition: aDefinition
	definition := aDefinition
! !

!MCRemoval methodsFor:'testing'!

isRemoval
	^ true
! !

!MCRemoval class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRemoval.st,v 1.4 2012-09-11 21:26:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRemoval.st,v 1.4 2012-09-11 21:26:09 cg Exp $'
!

version_SVN
    ^ '§Id: MCRemoval.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
