"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PPParser subclass:#PPJavaWhitespaceParser
	instanceVariableNames:'separator'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-Core'
!


!PPJavaWhitespaceParser methodsFor:'as yet unclassified'!

acceptsEpsilon
	^ true
!

acceptsEpsilonOpenSet: set
	^ true
!

firstCharParser
	^ PPFailingParser new
!

firstCharSet
	^ PPCharSetPredicate on: [:e | false ] 
!

isNullable
	^ true
!

name
	^ 'java_ws'
!

parseOn: context
        
        | start |

        [ 
                | peekTwice |
                [ context atEnd not and: [ context peek isSeparator ] ]
                        whileTrue: [ context next ].
                peekTwice := context peekTwice. 
                ((peekTwice  first = $/) and: 
                [ (peekTwice second = $*) or: [peekTwice second = $/]])
        ] whileTrue: [
                context next.
                start := context position.
                (context next = $*) 
                        ifTrue: [ context upToAll: '*/' ]
                        ifFalse: [ 
                                | position |
                                position := context position.
                                context upToAnyOf: String crlf].
         ].

    "Modified: / 10-05-2015 / 07:57:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

