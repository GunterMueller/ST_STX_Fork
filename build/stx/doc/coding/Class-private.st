"{ Namespace: 'CodingExamples' }"

Object subclass:#MyClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Classes-private'
!

Object subclass:#Array
	instanceVariableNames:'v1 v2'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CodingExamples::MyClass
!

!MyClass class methodsFor:'documentation'!

documentation
"
    demonstrates private classes - here, a private class named Array
    (with completely different implementation) is used.
"
! !

!MyClass class methodsFor:'testing'!

newArray
    "returns a regular Array-instance.
     Notice, that we have to give Smalltalk as explicit nameSpace
     here; otherwise, we would get the private Array class."

    ^ Smalltalk::Array new:2

    "
     MyClass newArray inspect
    "
!

newPrivateArray
    "returns an instance of my private Array class.
     Notice, that the private Array class is found first,
     the name 'Array' refers to that one here."

    ^ Array new

    "
     MyClass newPrivateArray inspect
    "
! !

!MyClass::Array methodsFor:'accessing'!

at:index
    index == 1 ifTrue:[
	^ v1
    ].
    index == 2 ifTrue:[
	^ v2
    ].
    self subscriptBoundsError
!

at:index put:value
    index == 1 ifTrue:[
	^ v1 := value
    ].
    index == 2 ifTrue:[
	^ v2 := value
    ].
    self subscriptBoundsError
! !

!MyClass class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Class-private.st,v 1.9 1996-12-21 12:47:15 cg Exp $'
! !
