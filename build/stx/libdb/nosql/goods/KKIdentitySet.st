"{ Package: 'stx:libdb/nosql/goods' }"

Set subclass:#KKIdentitySet
	instanceVariableNames:'database'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Collections'
!

KKIdentitySet comment:''
!


!KKIdentitySet class methodsFor:'as yet unclassified'!

database: aKKDatabase
	^ self new initializeWithDatabase: aKKDatabase
! !

!KKIdentitySet methodsFor:'*goodsplatformsqueak'!

scanFor: anObject
        "Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
        | finish start element |
        start := (database keyForObject: anObject) \\ keyArray size + 1.
        finish := keyArray size.

        "Search from (hash mod size) to the end."
        start to: finish do:
                [:index | ((element := keyArray at: index) == nil or: [element yourself == anObject yourself])
                        ifTrue: [^ index ]].

        "Search from 1 to where we started."
        1 to: start-1 do:
                [:index | ((element := keyArray at: index) == nil or: [element yourself == anObject yourself])
                        ifTrue: [^ index ]].

        ^ 0  "No match AND no empty slot"
! !

!KKIdentitySet methodsFor:'initialization'!

initializeWithDatabase: aKKDatabase
	database := aKKDatabase
! !

!KKIdentitySet methodsFor:'private'!

find:key ifAbsent:aBlock
    "Look for the key in the receiver.  If it is found, return
     the index of the slot containing the key, otherwise
     return the value of evaluating aBlock."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe keyItself|

    keyItself := key yourself.
    length := keyArray basicSize.

"/
"/  length < 10 ifTrue:[
"/      "assuming, that for small collections the overhead of hashing
"/       is larger ... maybe that proves wrong 
"/       (if overhead of comparing is higher)"
"/      ^ keyArray indexOf:key ifAbsent:aBlock
"/  ].

    startIndex := index := self initialIndexForKey:key.

    [true] whileTrue:[
        probe := (keyArray basicAt:index).
        (probe notNil and:[probe ~~ DeletedEntry and:[keyItself == probe yourself]]) ifTrue:[^ index].
        (self slotIsEmpty:probe) ifTrue:[^ aBlock value].

        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        index == startIndex ifTrue:[^ aBlock value].
    ]

    "Modified: / 03-02-2011 / 13:53:18 / sr"
!

findKeyOrNil:key
    "Look for the key in the receiver.  
     If it is found, return the index of the first unused slot. 
     Grow the receiver, if key was not found, and no unused slots were present"

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe 
     delIndex keyItself|

    length := keyArray basicSize.
    startIndex := index := self initialIndexForKey:key.
    keyItself := key yourself.

    [true] whileTrue:[                                      
        probe := keyArray basicAt:index.
        (probe notNil and:[probe ~~ DeletedEntry and:[keyItself = probe yourself]]) ifTrue:[^ index].
        (self slotIsEmpty:probe) ifTrue:[
            delIndex isNil ifTrue:[^ index].
            keyArray basicAt:delIndex put:nil.
            ^ delIndex
        ].

        probe == DeletedEntry ifTrue:[
            delIndex isNil ifTrue:[
                delIndex := index
            ]
        ].

        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        index == startIndex ifTrue:[
            delIndex notNil ifTrue:[
                keyArray basicAt:delIndex put:nil.
                ^ delIndex
            ].
            ^ self grow findKeyOrNil:key
        ].
    ]

    "Modified: / 27-02-2011 / 15:30:42 / cg"
!

species
	^ IdentitySet
! !

!KKIdentitySet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKIdentitySet.st,v 1.6 2013-03-31 23:34:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKIdentitySet.st,v 1.6 2013-03-31 23:34:33 cg Exp $'
! !

