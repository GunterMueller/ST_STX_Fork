"{ NameSpace: CodingExamples }"

Object subclass:#BadBecomeDemonstration
	instanceVariableNames:'i'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Bugs'
!

!BadBecomeDemonstration class methodsFor:'documentation'!

documentation
"
    demonstrates bad uses of #become.

    [start with:]
        BadBecomeDemonstration new badMethod1
        BadBecomeDemonstration new badMethod2
        BadBecomeDemonstration new fixedMethod1
        BadBecomeDemonstration new fixedMethod2

    [see also:]
        Object
        (``#become (programmers manual)'': programming/language.html#BECOME)
"
! !

!BadBecomeDemonstration methodsFor:'accessing'!

i
    "return i"

    ^ i

    "Created: 3.1.1997 / 14:41:31 / cg"
!

i:something
    "set i"

    i := something.

    "Created: 3.1.1997 / 14:41:31 / cg"
! !

!BadBecomeDemonstration methodsFor:'bad becomes'!

badMethod1
    i := 0.
    self becomeNil.
    ^ i

    "
     BadBecomeDemonstration new badMethod1
    "

    "Created: 3.1.1997 / 14:39:37 / cg"
!

badMethod2
    self becomeNil.
    i := 0.

    "
     BadBecomeDemonstration new badMethod2
    "

    "Created: 3.1.1997 / 14:39:46 / cg"
! !

!BadBecomeDemonstration methodsFor:'bad becomes - fixed'!

fixedMethod1
    self i:0.
    self becomeNil.
    ^ self i

    "
     BadBecomeDemonstration new fixedMethod1
    "

    "Created: 3.1.1997 / 14:41:52 / cg"
!

fixedMethod1_withHandler
    self i:0.
    self becomeNil.
    Object errorSignal handle:[:ex |
        ^ nil
    ] do:[
        ^ self i
    ]

    "
     BadBecomeDemonstration new fixedMethod1_withHandler
    "

    "Created: 3.1.1997 / 14:48:49 / cg"
!

fixedMethod2
    self becomeNil.
    self i:0.

    "
     BadBecomeDemonstration new fixedMethod2
    "

    "Created: 3.1.1997 / 14:42:04 / cg"
!

fixedMethod2_withHandler
    self becomeNil.
    Object errorSignal handle:[:ex |
        ^ nil
    ] do:[
        self i:0.
    ]

    "
     BadBecomeDemonstration new fixedMethod2_withHandler
    "

    "Created: 3.1.1997 / 14:49:02 / cg"
    "Modified: 3.1.1997 / 14:49:13 / cg"
! !

!BadBecomeDemonstration class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Bad-Become.st,v 1.3 1997-01-03 15:50:01 cg Exp $'
! !
