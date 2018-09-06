"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

SharedSet subclass:#SharedIdentitySet
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!SharedIdentitySet methodsFor:'setup'!

initialize
    mutex := Semaphore forMutualExclusion.
    set := IdentitySet new.

    "Created: / 23-09-2011 / 13:35:57 / cg"
!

initializeSet
    set := IdentitySet new.

    "Created: / 23-09-2011 / 13:36:15 / cg"
! !

!SharedIdentitySet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__SharedIdentitySet.st,v 1.1 2011-09-23 11:36:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__SharedIdentitySet.st,v 1.1 2011-09-23 11:36:54 cg Exp $'
! !
