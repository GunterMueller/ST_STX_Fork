"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

CodeModelLockPolicy subclass:#StateLockPolicy
	instanceVariableNames:'locked'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Browser'
!

StateLockPolicy comment:'StateLockPolicy is a CodeModelLockPolicy that has an explicit locked/unlocked state. The (un)locked state can be set by using lock and unlock methods.

Instance Variables:
	locked  <Boolean>       contains true if the model is locked and shouldn''t be updated'
!


!StateLockPolicy methodsFor:'accessing'!

isLocked
	^locked
!

lock
	locked := true
!

unlock
	locked := false
! !

!StateLockPolicy methodsFor:'initialize-release'!

initialize
	super initialize.
	locked := false
! !

!StateLockPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/StateLockPolicy.st,v 1.7 2003-09-23 10:47:43 cg Exp $'
! !
