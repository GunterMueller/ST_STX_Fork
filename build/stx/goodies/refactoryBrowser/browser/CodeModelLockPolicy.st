"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

Object subclass:#CodeModelLockPolicy
	instanceVariableNames:''
	classVariableNames:'WindowHandleCache'
	poolDictionaries:''
	category:'Refactory-Browser'
!

CodeModelLockPolicy comment:'CodeModelLockPolicy is an abstract class. It defines the protocol that CodeModels use to check to see if it is locked. The implementation of this class is for a tool that is always unlocked.'
!


!CodeModelLockPolicy class methodsFor:'instance creation'!

on: aCodeTool 
	^(self new)
		initialize;
		on: aCodeTool;
		yourself
! !

!CodeModelLockPolicy class methodsFor:'accessing'!

flushCache
	WindowHandleCache := nil
! !

!CodeModelLockPolicy methodsFor:'accessing'!

isLocked
	^false
!

lock
!

unlock
! !

!CodeModelLockPolicy methodsFor:'initialize-release'!

initialize
!

on: aCodeTool
! !

!CodeModelLockPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/CodeModelLockPolicy.st,v 1.7 2003-09-23 10:45:51 cg Exp $'
! !
