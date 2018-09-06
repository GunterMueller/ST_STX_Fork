'From Smalltalk/X, Version:2.10.9 on 13-jul-1996 at 12:18:25 am'                !

Object subclass:#Bar
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-libFoo-example'
!

!Bar  class methodsFor:'initialization'!

deinitialize
    Transcript showCR:'the Bar class is about to be unloaded'

    "Created: 12.7.1996 / 19:13:29 / cg"
!

initialize
    Transcript showCR:'the Bar class is here'

    "Created: 12.7.1996 / 19:13:29 / cg"
! !

Bar initialize!
