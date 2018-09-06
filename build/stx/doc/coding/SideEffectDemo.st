"{ Package: 'stx:doc/coding' }"

Object subclass:#SideEffectDemo
	instanceVariableNames:'i'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-coding'
!


!SideEffectDemo class methodsFor:'main'!

main
        Transcript showCR:'undefinedBehavior returns: '
                          , (SideEffectDemo new i:0) undefinedBehavior printString.
        Transcript showCR:'undefinedBehavior2 returns: '
                          , (SideEffectDemo new i:0) undefinedBehavior2 printString.
! !

!SideEffectDemo methodsFor:'demo'!

i:aNumber
        i := aNumber
!

increment
        i := i + 1.
        ^ i
!

undefinedBehavior
        ^ self increment + i
!

undefinedBehavior2
        ^ i + self increment
! !

!SideEffectDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/SideEffectDemo.st,v 1.1 2002-08-06 11:16:42 cg Exp $'
! !
