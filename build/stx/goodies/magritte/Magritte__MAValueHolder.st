"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

Object subclass:#MAValueHolder
	instanceVariableNames:'contents'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Utility'
!


!MAValueHolder class methodsFor:'instance-creation'!

new
	^ self basicNew initialize
!

on: anObject
	^ self new contents: anObject
! !

!MAValueHolder methodsFor:'accessing'!

contents
	^ contents
!

contents: anObject
	contents := anObject
! !

!MAValueHolder methodsFor:'initialize-release'!

initialize
! !

!MAValueHolder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAValueHolder.st,v 1.1 2009-07-29 14:48:05 cg Exp $'
! !
