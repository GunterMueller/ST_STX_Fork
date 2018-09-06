"{ Package: 'stx:goodies/petitparser' }"

Object subclass:#PPMemento
	instanceVariableNames:'result count context'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Core'
!


!PPMemento class methodsFor:'instance creation'!

new
	^ self basicNew initialize
! !

!PPMemento methodsFor:'accessing'!

contextMemento
	^ context
!

contextMemento: aPPContextMemento
	context  := aPPContextMemento 
!

result
	^ result
!

result: anObject
	result := anObject
! !

!PPMemento methodsFor:'accessing-readonly'!

count
	^ count
! !

!PPMemento methodsFor:'actions'!

increment
	count := count + 1
! !

!PPMemento methodsFor:'initialization'!

initialize
	count := 0
	
! !

!PPMemento class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPMemento.st,v 1.3 2012-05-04 22:00:45 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPMemento.st,v 1.3 2012-05-04 22:00:45 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: PPMemento.st 2 2010-12-17 18:44:23Z vranyj1 §'
! !

