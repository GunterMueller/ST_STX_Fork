"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAMemento subclass:#MACachedMemento
	instanceVariableNames:'cache'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Memento'
!

MACachedMemento comment:'I cache values being read and written without touching the model. When committing changes, the modifications will be propagated to the model all at once.'
!


!MACachedMemento class methodsFor:'testing'!

isAbstract
	^ false
! !

!MACachedMemento methodsFor:'accessing'!

cache
	^ cache
! !

!MACachedMemento methodsFor:'actions'!

commit
	super commit.
	self push: self cache.
	self reset
!

reset
	super reset.
	self setCache: self pull
! !

!MACachedMemento methodsFor:'initialization'!

setCache: aDictionary
	cache := aDictionary
! !

!MACachedMemento methodsFor:'private'!

readUsing: aDescription
	^ self cache at: aDescription
!

write: anObject using: aDescription
	self cache at: aDescription put: anObject
! !

!MACachedMemento methodsFor:'testing'!

hasChanged
	"Answer ==true==, if the cached data is different to the data in the model."

	^ self isDifferent: self cache to: self pullRaw
! !

!MACachedMemento class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MACachedMemento.st,v 1.1 2009-07-29 14:55:07 cg Exp $'
! !
