"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MinneStore subclass:#MSLeaf
	instanceVariableNames:'value ids unused'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSLeaf class methodsFor:'As yet unclassified'!

Comment

"

	Leaves are held by branches.

"
!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

!

newValue: anObject id: anInteger



	^self new

		value: anObject 

		id: anInteger

                

		
! !

!MSLeaf methodsFor:'As yet unclassified'!

< anMSLeaf



        self class == anMSLeaf class

                ifFalse: [^false].
        Smalltalk isSmalltalkX ifTrue:[
            (self value isString or:[anMSLeaf value isString]) ifTrue:[
                ^ (self value compareCaselessWith:anMSLeaf value) < 0
            ]
        ].
        ^self value < anMSLeaf value.
!

<= anMSLeaf



        self class == anMSLeaf class

                ifFalse: [^false].

        Smalltalk isSmalltalkX ifTrue:[
            (self value isString or:[anMSLeaf value isString]) ifTrue:[
                ^ (self value compareCaselessWith:anMSLeaf value) <= 0
            ]
        ].
        ^self value <= anMSLeaf value.
!

addId: anInteger

	"Set my database id number that goes with the key."

    

	ids == nil ifTrue: [ 

		ids := anInteger.

		^self. ].

	ids isInteger ifTrue: [

		ids = anInteger

			ifTrue: [ ^self ]

			ifFalse: [

				ids := OrderedCollection with: ids with: anInteger.

				^self ] ].

	(ids includes: anInteger) ifFalse: [

		ids add: anInteger ].
!

ids

	"Public - Answer a collection of ids that I hold."



	ids == nil

		ifTrue: [^Array new].

	ids isInteger

		ifTrue: [^Array with: ids].

	^ids.
!

isEmpty

	"Answer true or false.  Answer true if I hold no ids."



	^ids == nil
!

printOn: aStream

	"Public - Print a textual representation of  myself onto aStream."



	super printOn: aStream.

	aStream nextPut: $( .

	value printOn: aStream.

	aStream nextPut: $: .

	"Print up to 3 of the database Ids associated with the index key."

	1 to: self ids size do: [ :x |

		x = 4   ifTrue: [ aStream nextPutAll: '...' ] .

		x < 4 ifTrue: [ aStream print: (self ids at: x); nextPut: $  ] ] .

	aStream nextPut: $)
!

removeId: anInteger

	"Remove my database id number that goes with my value.

	When ids gets empty, it is set back to nil."

    

	ids isNil ifTrue: [ ^self ].

	ids isInteger ifTrue: [

		ids = anInteger

			ifTrue: [ 

				^ids := nil ]

			ifFalse: [ ^self ]. ].

	(ids includes: anInteger) ifTrue: [

		ids remove: anInteger.

		ids isEmpty

			ifTrue: [^ids := nil].

		ids size = 1 

			ifTrue: [ids := ids first] ] .
!

value

	"Public - Answer my value instance variable."



	^value
!

value: anObject id: anInteger

	"Private - set the value and ids instance variables."



	value := anObject.

	ids := anInteger.
! !

!MSLeaf class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSLeaf.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
