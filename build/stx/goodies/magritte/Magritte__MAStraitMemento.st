"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAMemento subclass:#MAStraitMemento
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Memento'
!

MAStraitMemento comment:'I am a memento that forwards read- and write-access directly to the model. I can mostly be replaced with the model itself.'
!


!MAStraitMemento class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAStraitMemento methodsFor:'private'!

readUsing: aDescription
	^ (self model readUsing: aDescription)
		ifNil: [ aDescription default ]
!

write: anObject using: aDescription
	self model write: anObject using: aDescription
! !

!MAStraitMemento class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAStraitMemento.st,v 1.1 2009-07-29 14:53:27 cg Exp $'
! !
