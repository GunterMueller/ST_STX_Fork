"{ NameSpace: CodingExamples }"

Smalltalk::OrderedCollection subclass:#OrderedCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Classes-private'
!

!OrderedCollection class methodsFor:'documentation'!

documentation
"
    a tricky (really ?) example; redefining a modified
    OrderedCollection (with an additional foo-method) for use
    within this nameSpace only ...
"
! !

!OrderedCollection methodsFor:'redefined'!

foo
    Transcript showCR:'foo'

    "
     OrderedCollection new foo
    "

    "Modified: 23.1.1997 / 01:57:12 / cg"
! !

!OrderedCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Class-redefined.st,v 1.1 1997-01-23 01:12:36 cg Exp $'
! !
