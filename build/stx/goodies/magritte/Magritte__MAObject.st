"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

Object subclass:#MAObject
	instanceVariableNames:'properties'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Core'
!

MAObject comment:'I provide functionality available to all Magritte objects. I implement a dictionary of properties, so that extensions can easily store additional data.'
!


!MAObject class methodsFor:'initialization'!

initialize
"/    MACompatibility openWorkspace: self license titled: 'Magritte License'

    "Modified: / 23-09-2014 / 21:20:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MAObject class methodsFor:'accessing'!

license
	"Return a string with the license of the package. This string shall not be removed or altered in any case."

	^ 'The MIT License

Copyright (c) 2003-' , Date current year asString , ' Lukas Renggli, renggli at gmail.com

Copyright (c) 2003-' , Date current year asString , ' Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.'
! !

!MAObject class methodsFor:'instance-creation'!

new
	"Create a new instance of the receiving class and checks if it is concrete."

	self isAbstract
		ifTrue: [ self error: self name , ' is abstract.' ].
	^ self basicNew initialize
! !

!MAObject class methodsFor:'reflection'!

withAllConcreteClasses
	^ Array streamContents: [ :stream |
		self withAllConcreteClassesDo: [ :each |
			stream nextPut: each ] ]
!

withAllConcreteClassesDo: aBlock
	self withAllSubclassesDo: [ :each |
		each isAbstract ifFalse: [
			aBlock value: each ] ]
! !

!MAObject class methodsFor:'testing'!

isAbstract
	^ true
! !

!MAObject methodsFor:'accessing'!

properties
	"Answer the property dictionary of the receiver."

	^ properties ifNil: [ properties := Dictionary new ]
!

propertyAt: aKey
	"Answer the value of the property ==aKey==, raises an error if the property doesn't exist."

	^ self propertyAt: aKey ifAbsent: [ self errorPropertyNotFound: aKey ]
!

propertyAt: aKey ifAbsent: aBlock
	"Answer the value of the property ==aKey==, or the result of ==aBlock== if the property doesn't exist."

	^ self properties at: aKey ifAbsent: aBlock
!

propertyAt: aKey ifAbsentPut: aBlock
	"Answer the value of the property ==aKey==, or if the property doesn't exist adds and answers the result of evaluating ==aBlock==."

	^ self properties at: aKey ifAbsentPut: aBlock
!

propertyAt: aKey ifPresent: aBlock
	"Lookup the property ==aKey==, if it is present, answer the value of evaluating ==aBlock== block with the value. Otherwise, answer ==nil==."

	^ self properties at: aKey ifPresent: aBlock
!

propertyAt: aKey put: aValue
	"Adds or replaces the property ==aKey== with ==aValue==."

	^ self properties at: aKey put: aValue
! !

!MAObject methodsFor:'comparing'!

= anObject
	"Answer whether the receiver and the argument represent the same object. This default implementation checks if the species of the compared objects are the same, so that superclasses might call super before performing their own check. Also redefine the message ==#hash== when redefining this message."

	^ self species = anObject species
!

hash
	"Answer a SmallInteger whose value is related to the receiver's identity. Also redefine the message ==#= == when redefining this message."

	^ self species hash
! !

!MAObject methodsFor:'copying'!

postCopy
	"This method is called whenever a shallow copy of the receiver is made. Redefine this method in subclasses to copy other fields as necessary. Never forget to call super, else class invariants might be violated."

	super postCopy.
	properties := properties copy
! !

!MAObject methodsFor:'initialization'!

initialize
! !

!MAObject methodsFor:'private'!

errorPropertyNotFound: aSelector 
	MAPropertyError signal: 'Property ' , aSelector , ' not found.'
! !

!MAObject methodsFor:'testing'!

hasProperty: aKey
	"Test if the property ==aKey== is defined within the receiver."

	^ self properties includesKey: aKey
! !

!MAObject methodsFor:'visiting'!

acceptMagritte: aVisitor
! !

!MAObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAObject.st,v 1.2 2014-09-23 20:30:06 vrany Exp $'
! !


MAObject initialize!
