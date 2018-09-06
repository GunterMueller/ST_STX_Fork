"{ Package: 'stx:goodies/petitparser/parsers/smalltalk' }"

PPParser subclass:#PPSmalltalkWhitespaceParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitSmalltalk-Core'
!



!PPSmalltalkWhitespaceParser methodsFor:'analysis'!

isNullable
	^ true
! !

!PPSmalltalkWhitespaceParser methodsFor:'initialization'!

initialize
	super initialize.
! !

!PPSmalltalkWhitespaceParser methodsFor:'parsing'!

name
	^ 'smalltalk_ws'
!

parseOn: aPPContext
        "Skip any leading whitespace"
        [ [aPPContext atEnd not and: [  aPPContext uncheckedPeek isSeparator ] ]
                whileTrue: [ aPPContext next ].

        "Check for comment"
         aPPContext atEnd not and: [ aPPContext uncheckedPeek = $" ] ] whileTrue: [
                aPPContext next.
                "Check for Smalltalk/X EOL comment"
                aPPContext uncheckedPeek == $/ ifTrue:[
                    | c |
                    aPPContext next.
                    [ aPPContext atEnd not 
                        and:[ (c := aPPContext uncheckedPeek) ~~ (Character codePoint: 15r0A) 
                        and: [ c ~~ (Character codePoint: 15r0D) ] ] ] whileTrue:[ 
                            aPPContext next.
                        ].
                    (c == (Character codePoint: 15r0D) and:[ aPPContext atEnd not and:[ aPPContext uncheckedPeek == (Character codePoint: 15r0A) ] ] ) ifTrue:[ 
                        aPPContext next
                    ].
                ] ifFalse:[ 
                    aPPContext upTo: $".
                ]
        ].

    "Modified: / 21-11-2014 / 10:10:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPSmalltalkWhitespaceParser class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

