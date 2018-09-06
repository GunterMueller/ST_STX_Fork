"{ Package: 'stx:libcompat' }"

Object subclass:#MethodReference
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!


!MethodReference class methodsFor:'*monticello'!

class: aClass selector: aSelector
	^ self new setStandardClass: aClass methodSymbol: aSelector
! !

!MethodReference methodsFor:'*monticello'!

asMethodDefinition
	^ MCMethodDefinition forMethodReference: self
!

category
	^ self actualClass organization categoryOfElement: methodSymbol
!

compiledMethod
	^ self actualClass compiledMethodAt: methodSymbol
!

source
	^ (self actualClass sourceCodeAt: methodSymbol) asString withSqueakLineEndings
!

timeStamp
	^ self compiledMethod timeStamp
! !

!MethodReference class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/MethodReference.st,v 1.2 2006-11-22 17:08:24 cg Exp $'
! !
