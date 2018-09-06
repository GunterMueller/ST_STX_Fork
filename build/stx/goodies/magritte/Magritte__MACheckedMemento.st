"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MACachedMemento subclass:#MACheckedMemento
	instanceVariableNames:'original'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Memento'
!

MACheckedMemento comment:'I cache values as my superclass and also remember the original values of the model at the time the cache is built. With this information I am able to detect edit conflicts and can prevent accidental loss of data by merging the changes.'
!


!MACheckedMemento methodsFor:'accessing'!

original
	^ original
! !

!MACheckedMemento methodsFor:'actions'!

reset
	super reset.
	self setOriginal: self pullRaw
!

validate
	self hasConflict
		ifFalse: [ ^ super validate ].
	self reset.
	MAConflictError
		description: self description
		signal: self description conflictErrorMessage
! !

!MACheckedMemento methodsFor:'initialization'!

setOriginal: aDictionary
	original := aDictionary
! !

!MACheckedMemento methodsFor:'testing'!

hasConflict
	"Answer ==true==, if there is an edit conflict."

	^ self hasChanged and: [ self isDifferent: self original to: self pullRaw ]
! !

!MACheckedMemento class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MACheckedMemento.st,v 1.1 2009-07-29 14:52:27 cg Exp $'
! !
