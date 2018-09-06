"{ Package: 'stx:goodies/monticello' }"

MCPatchOperation subclass:#MCModification
	instanceVariableNames:'obsoletion modification'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Patching'
!


!MCModification class methodsFor:'as yet unclassified'!

of: base to: target
	^ self new initializeWithBase: base target: target
! !

!MCModification methodsFor:'accessing'!

applyTo: anObject
	anObject modifyDefinition: obsoletion to: modification
!

baseDefinition
	^ obsoletion
!

definition
	^ modification
!

fromSource
	^ obsoletion source
!

modification
	^ modification
!

obsoletion
	^ obsoletion
!

summarySuffix
	^self fromSource = self toSource
		ifTrue: [ ' (source same but rev changed)' ]
		ifFalse: [ ' (changed)' ]
!

targetClass
	^ obsoletion actualClass
!

targetDefinition
	^ modification
!

toSource
	^ modification source
! !

!MCModification methodsFor:'as yet unclassified'!

inverse
	^ MCModification of: modification to: obsoletion
!

isClassPatch
	^obsoletion isClassDefinition
!

printAnnotations: request on: aStream
	aStream nextPutAll: 'old: '.
	obsoletion printAnnotations: request on: aStream.
	aStream cr.
	aStream nextPutAll: 'new: '.
	modification printAnnotations: request on: aStream.
! !

!MCModification methodsFor:'initializing'!

initializeWithBase: base target: target
	obsoletion := base.
	modification := target.
! !

!MCModification methodsFor:'testing'!

isModification
	^ true
! !

!MCModification class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCModification.st,v 1.4 2012-09-11 21:24:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCModification.st,v 1.4 2012-09-11 21:24:34 cg Exp $'
!

version_SVN
    ^ '§Id: MCModification.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
