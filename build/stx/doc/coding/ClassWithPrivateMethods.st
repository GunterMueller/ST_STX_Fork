"{ NameSpace: CodingExamples }"

Object subclass:#ClassWithPrivateMethods
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-PrivateMethods'
!


!ClassWithPrivateMethods methodsFor:'tests'!

doFoo1
    "allowed"

    self foo.

    "
     self new doFoo1
    "

    "Created: / 31.7.1998 / 09:46:51 / cg"
    "Modified: / 31.7.1998 / 09:52:35 / cg"
!

doFoo2
    "NOT allowed"

    |var|

    var := self.
    var foo.

    "
     self new doFoo2
    "

    "Modified: / 31.7.1998 / 09:52:44 / cg"
!

doFoo3
    "allowed"

    self perform:#foo.

    "
     self new doFoo3
    "

    "Created: / 31.7.1998 / 09:47:21 / cg"
    "Modified: / 31.7.1998 / 09:53:10 / cg"
!

doFoo4
    "NOT allowed"

    |var|

    var := self.
    var perform:#foo.

    "
     self new doFoo4
    "

    "Created: / 31.7.1998 / 09:47:15 / cg"
    "Modified: / 31.7.1998 / 09:53:16 / cg"
! !

!ClassWithPrivateMethods privateMethodsFor:'tests'!

foo
    self halt.

    "
     self new foo
    "

    "Modified: / 31.7.1998 / 09:48:50 / cg"
! !

!ClassWithPrivateMethods class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/ClassWithPrivateMethods.st,v 1.1 1998-07-31 08:54:14 cg Exp $'
! !
