"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

Collection subclass:#SharedSet
	instanceVariableNames:'mutex set'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!SharedSet class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!SharedSet methodsFor:'adding & removing'!

add:anObject
    |rslt|

    mutex critical:[
        rslt := set add:anObject
    ].
    ^ rslt.
!

remove:anElement ifAbsent:exceptionBlock
    |rslt|

    mutex critical:[
        rslt := set remove:anElement ifAbsent:exceptionBlock
    ].
    ^ rslt.

    "Created: / 23-09-2011 / 21:16:59 / cg"
! !

!SharedSet methodsFor:'enumeration'!

do:aBlock
    |rslt|

    mutex critical:[
        rslt := set do:aBlock
    ].
    ^ rslt
! !

!SharedSet methodsFor:'queries'!

includes:anObject
    |rslt|

    mutex critical:[
        rslt := set includes:anObject
    ].
    ^ rslt.
!

isFixedSize
    "return true if the receiver cannot grow"

    ^ false
!

size
    ^ set size.
! !

!SharedSet methodsFor:'setup'!

initialize
    mutex := Semaphore forMutualExclusion.
    self initializeSet.

    "Modified: / 23-09-2011 / 13:36:10 / cg"
!

initializeSet
    set := Set new.

    "Created: / 23-09-2011 / 13:36:05 / cg"
! !

!SharedSet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__SharedSet.st,v 1.5 2013-06-25 11:24:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__SharedSet.st,v 1.5 2013-06-25 11:24:01 cg Exp $'
!

version_SVN
    ^ '$Id: Dolphin__SharedSet.st,v 1.5 2013-06-25 11:24:01 cg Exp $'
! !

