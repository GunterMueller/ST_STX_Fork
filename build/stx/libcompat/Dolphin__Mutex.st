"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

RecursionLock subclass:#Mutex
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!Mutex class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!Mutex class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__Mutex.st,v 1.2 2011-10-01 11:01:53 vrany Exp $'
!

version_SVN
    ^ '§Id: Dolphin__Mutex.st,v 1.1 2011/07/05 18:09:55 cg Exp §'
! !
