"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

Smalltalk::Error subclass:#Error
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!Error methodsFor:'raising'!

signal
    "/ BAD BAD: 
    "/ signal is an accessor used by the exception handling code;
    "/ signal is also an alias for #raise within the Dolphin world.
    "/ cannot simply map to #raise here, because that leads to an endless recursion
    "/ in the signal handling code.
    "/ Therefore, we need a very bad trick here:
    thisContext sender method mclass nameSpace == Dolphin ifTrue:[
        ^ self raise.
    ].
    ^ super signal
! !

!Error class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin_Error.st,v 1.2 2008-09-08 09:41:24 cg Exp $'
! !
