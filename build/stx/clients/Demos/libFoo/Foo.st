'From Smalltalk/X, Version:2.10.9 on 13-jul-1996 at 12:18:25 am'                !

Object subclass:#Foo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-libFoo-example'
!

!Foo  class methodsFor:'initialization'!

deinitialize
    Transcript showCR:'the Foo class is about to be unloaded'

    "Created: 12.7.1996 / 19:13:11 / cg"
!

initialize
    Transcript showCR:'the Foo class is here'

    "Created: 12.7.1996 / 19:13:11 / cg"
! !

Foo initialize!
