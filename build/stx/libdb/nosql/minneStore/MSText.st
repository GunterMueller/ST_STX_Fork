"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MinneStore subclass:#MSText
	instanceVariableNames:'textString'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSText class methodsFor:'As yet unclassified'!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

!

lowValue

	"Answer the lowest possible value to be used in place of nil."



	^String new
!

newOn: aString

	"Public - use this instead of new"



	^self new textString: aString.
! !

!MSText methodsFor:'As yet unclassified'!

asMSText



	^self
!

isMSText



	^true
!

printOn: aStream



	super printOn: aStream.

	aStream nextPut: $(.

	textString printOn: aStream.

	aStream nextPut: $).
!

textString: aString



	textString := aString.
!

words

	"Answer a collection of words found in this text"



	| stream word coll |

	coll := OrderedCollection new.

	textString isNil ifTrue: [ ^coll ].

	stream := ReadStream on: textString.

	[ (word := FlavorCompatibility nextWordOf: stream) isNil ]

		whileFalse: [ coll add: word ].

	^coll

	
!

wordsDo: aOneArgumentBlock

	"For each word in my string execute aOneArgumentBlock"



	| stream word |

	textString isNil ifTrue: [ ^self ].

	stream := ReadStream on: textString.

	[ (word := FlavorCompatibility nextWordOf: stream) isNil ] 

		whileFalse: [ aOneArgumentBlock value: word ].

	
! !

!MSText class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSText.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
