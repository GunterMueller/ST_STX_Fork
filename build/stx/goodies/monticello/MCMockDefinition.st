"{ Package: 'stx:goodies/monticello' }"

MCDefinition subclass:#MCMockDefinition
	instanceVariableNames:'token'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Mocks'
!


!MCMockDefinition class methodsFor:'as yet unclassified'!

token: aString

	^ self new token: aString
!

wantsChangeSetLogging
	^ false
! !

!MCMockDefinition methodsFor:'as yet unclassified'!

= definition
	^definition token = token
!

asString

	^ token
!

description

	^ token first
!

hash

	^ token hash
!

printString

	^ token
!

summary

	^ token
!

token

	^ token
!

token: aString

	token := aString
! !

!MCMockDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMockDefinition.st,v 1.4 2012-09-11 21:24:16 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMockDefinition.st,v 1.4 2012-09-11 21:24:16 cg Exp $'
!

version_SVN
    ^ '§Id: MCMockDefinition.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
