"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

Object subclass:#MACompatibility
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Core'
!

MACompatibility comment:'I am providing all the platform compatibility code on my class side, so that porting to different Smalltalk dialects can concentrate in a single place.'
!


!MACompatibility class methodsFor:'environment'!

allSubInstancesOf: aClass do: aBlock
	"Evaluate the aBlock for all instances of aClass and all its subclasses."

	aClass allSubInstancesDo: aBlock
!

classNamed: aString
	"Return the class named aString, nil if the class can't be found."

	^ Smalltalk classNamed: aString
!

referenceStream: aReadWriteStream
	"Return a stream instance to operate on aReadWriteStream being able to serialize and deserialize objects by sending #nextPut: and #next. Squeak: The implementation of ReferenceStream doesn't work well together with the default WriteStream implementation, therefor we have to change it on the fly."

	^ ReferenceStream on: (aReadWriteStream class = WriteStream
		ifTrue: [ RWBinaryOrTextStream on: aReadWriteStream contents ]
		ifFalse: [ aReadWriteStream ])
!

uuid
	"Answer a random object that is extremely likely to be unique over space and time."

	^ UUID new
! !

!MACompatibility class methodsFor:'user-interface'!

choose: aString from: aCollection
	"Display aString to the user and let him choose any of the items in aCollection."

	| index strings list |
	list := aCollection asOrderedCollection.
	strings := list collect: [ :each | each asString ].
	index := self
		toolbuilder: [ :tb | tb chooseFrom: strings title: aString ]
		else: [ PopUpMenu withCaption: aString chooseFrom: strings ].
	^ index isZero
		ifFalse: [ list at: index ]
!

confirm: aString
	"Display aString to the user and let him confirm."

	^ self
		toolbuilder: [ :tb | tb confirm: aString ]
		else: [ PopUpMenu confirm: aString ]
!

inform: aString
	"Display aString to the user."

	self
		toolbuilder: [ :tb | tb inform: aString ]
		else: [ PopUpMenu inform: aString ]
!

openWorkspace: aContentsString titled: aTitleString
        "Open a new workspace with the contents aContentsString and the title aTitleString."

        Smalltalk isSmalltalkX ifTrue:[
            Workspace new
                contents: (aContentsString asCollectionOfSubstringsSeparatedBy:Character cr);
                label: aTitleString;
                open
        ] ifFalse:[
            Workspace new
                contents: aContentsString;
                openLabel: aTitleString
        ].
!

request: aString default: anObject
	"Display aString and requests an input from the user, whereas anObject is the default value."

	| result |
	result := self
		toolbuilder: [ :tb | tb request: aString initialAnswer: anObject ]
		else: [ FillInTheBlankMorph request: aString initialAnswer: anObject ].
	^ result isEmpty
		ifTrue: [ nil ]
		ifFalse: [ result ]
!

toolbuilder: aBlock else: anotherBlock
	^ (Smalltalk hasClassNamed: #UIManager)
		ifTrue: [ aBlock value: (Smalltalk classNamed: #UIManager) default ]
		ifFalse: [ anotherBlock value ]
! !

!MACompatibility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MACompatibility.st,v 1.1 2009-07-29 14:47:41 cg Exp $'
! !
