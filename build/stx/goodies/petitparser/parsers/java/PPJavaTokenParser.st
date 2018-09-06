"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PPTokenParser subclass:#PPJavaTokenParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-Core'
!

!PPJavaTokenParser methodsFor:'parsing'!

parseComments: anArray on: aStream
        
        | start comments |
        comments := anArray.
        [ 
                | peekTwice |
        [ aStream atEnd not and: [ aStream peek isSeparator ] ]
                whileTrue: [ aStream next ].
        peekTwice := aStream peekTwice. 
          ((peekTwice  first = $/) and: 
                [ (peekTwice second = $*) or: [peekTwice second = $/]])] whileTrue: [
"               
                Transcript show: ('position ', aStream position asString, ' char ', aStream next asString); cr.
"               
                aStream next.
                start := aStream position.
                (aStream next = $*) 
                        ifTrue: [ aStream upToAll: '*/' ]
                        ifFalse: [ 
                                | position |
                                position := aStream position.
                                aStream upToAnyOf: (String with: (Character codePoint: 13) with: (Character codePoint: 10))].
                comments := comments copyWith: (start to: aStream position) ].
        ^ comments

    "Modified: / 21-04-2015 / 17:23:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOn: aPPContext
	| token comments memento   |
	memento := aPPContext remember.
	comments := self
		parseComments: #()
		on: aPPContext.
	token := super parseOn: aPPContext.
	token isPetitFailure ifTrue: [
		aPPContext restore: memento.
		^ token ].
	comments := self
		parseComments: comments
		on: aPPContext.
	^ token comments: comments
! !

!PPJavaTokenParser methodsFor:'private'!

defaultTokenClass
	^ PPJavaToken
! !

