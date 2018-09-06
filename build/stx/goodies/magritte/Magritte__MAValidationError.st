"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAError subclass:#MAValidationError
	instanceVariableNames:'resumable'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Exception'
!

MAValidationError comment:'I am a generic validation error. I reference the description that caused the validation error.'
!


!MAValidationError class methodsFor:'instance-creation'!

description: aDescription signal: aString 
"/        ^ self new
"/                setDescription: aDescription;
"/                signal: aString;
"/                yourself

    ^ (self newException
        suspendedContext:thisContext sender
        errorString:aString)
            setDescription: aDescription;
            raiseSignal.
! !

!MAValidationError methodsFor:'accessing'!

beResumable
	resumable := true
! !

!MAValidationError methodsFor:'initialization'!

setDescription: aDescription
	self tag: aDescription
! !

!MAValidationError methodsFor:'printing'!

printOn: aStream
        |tag|

        tag := self tag.
        (tag isDescription and: [ tag label notNil ])
                ifTrue: [ aStream nextPutAll: tag label; nextPutAll: ': ' ].
        aStream nextPutAll: (self messageText ? '')
! !

!MAValidationError methodsFor:'testing'!

isResumable
	^ resumable ifNil: [ resumable := false ]
! !

!MAValidationError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAValidationError.st,v 1.2 2009-07-30 08:01:56 cg Exp $'
! !
