"{ Package: '__NoProject__' }"

Object subclass:#QualifiedName
	instanceVariableNames:'pathString'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Support'
!

!QualifiedName class methodsFor:'documentation'!

documentation
"
    some mimicri, to allow filein of visualWorks code which uses qualified names
"
! !

!QualifiedName class methodsFor:'instance creation'!

for:aStringOrSymbol
    ^ self new name:aStringOrSymbol


!

makeUnambiguous
    ^ self
!

pathString:aPathString
    ^ self new pathString:aPathString
! !

!QualifiedName methodsFor:'accessing'!

asString
    ^ pathString


!

comment:aString
    "empty for now"
!

name:aStringOrSymbol
    pathString := aStringOrSymbol asSymbol

!

pathString
    "return the value of the instance variable 'pathString' (automatically generated)"

    ^ pathString
!

pathString:something
    "set the value of the instance variable 'pathString' (automatically generated)"

    pathString := something.
! !

!QualifiedName methodsFor:'conditional execution'!

value
    "return my binding value, if unbound, return nil"

    ^ self valueOrDo:[]
!

valueOrDo:aBlock
    "return my binding value, if unbound, return the result from evaluating aBlock"

    |ns path|

    path := pathString asCollectionOfSubstringsSeparatedBy:$..
    ((path size > 0) and:[path first = 'Core']) ifTrue:[
        path := path copyFrom:2
    ].
    ns := Smalltalk.
    path do:[:component |
        ns := ns at:component asSymbol ifAbsent:[ ^ aBlock value ].
    ].
    ^ ns
! !

!QualifiedName methodsFor:'defining'!

defineClass: name superclass: superclass
                indexedType: indexed
                private: private
                instanceVariableNames: instVars
                classInstanceVariableNames: classInstVars
                imports: imports
                category: category
                attributes: annotations

    |sc|

    sc := superclass value.
    sc isNil ifTrue:[
self halt.
    ].
self halt.

!

defineNameSpace: name private: private imports: imports category: category attributes: annotations
    "klduge for now"

    pathString = 'Smalltalk' ifTrue:[
        NameSpace name:name asSymbol.
    ] ifFalse:[
    self halt.
    ].

! !

!QualifiedName methodsFor:'dummy for now'!

makeUnambiguous
    ^ self


! !

!QualifiedName class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/QualifiedName.st,v 1.3 2013-10-27 10:14:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/QualifiedName.st,v 1.3 2013-10-27 10:14:09 cg Exp $'
! !

