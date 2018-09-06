'From Smalltalk/X, Version:2.10.9 on 13-jul-1996 at 12:18:25 am'                !

Object subclass:#Baz
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-libFoo-example'
!

!Baz  class methodsFor:'initialization'!

deinitialize
    Transcript showCR:'the Baz class is about to be unloaded'

    "Created: 12.7.1996 / 19:13:20 / cg"
!

initialize
    Transcript showCR:'the Baz class is here'

    "Created: 12.7.1996 / 19:13:20 / cg"
! !

Baz initialize!
