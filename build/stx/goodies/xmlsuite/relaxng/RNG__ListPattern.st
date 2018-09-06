"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Pattern subclass:#ListPattern
	instanceVariableNames:'itemPatterns repeat'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Patterns'
!


!ListPattern methodsFor:'accessing'!

charactersFromObject:aCollection 

    | s |
    s := String new writeStream.

    self patternsAndObjects:aCollection
        do:[:pattern :object|
            s nextPutAll:(pattern charactersFromObject:object); space.
        ].
    ^s contents trimSeparators.

    "Created: / 16-05-2005 / 13:41:52 / masca"
!

name
    ^'#pcdata'

    "Created: / 14-05-2005 / 18:26:57 / janfrog"
    "Modified: / 19-05-2005 / 09:57:26 / masca"
!

objectFromCharacters:aString 
    |s|

    s := Set new.
    self patternsAndObjects:aString asArrayOfSubstrings
        do:[:pattern :string | s add:(pattern objectFromCharacters:string) ].
    ^ s

    "Created: / 14-05-2005 / 18:27:14 / janfrog"
    "Modified: / 14-05-2005 / 22:15:13 / janfrog"
    "Modified: / 16-05-2005 / 13:42:27 / masca"
! !

!ListPattern methodsFor:'initialization'!

postParseFor:aSchema

    itemPatterns := self node firstChild isRepeatingNode
        ifTrue:[
            repeat := true.
            self node firstChild children collect:[:c|c pattern]]
        ifFalse:[
            repeat := false.
            self node children collect:[:c|c pattern]]

    "Created: / 14-05-2005 / 21:26:26 / janfrog"
! !

!ListPattern methodsFor:'printing'!

nameForPrint

    ^'#pcdata:list'

    "Created: / 19-05-2005 / 09:55:30 / masca"
! !

!ListPattern methodsFor:'private'!

patternsAndObjects:strings do:block 
    |idx|

    idx := 0.
    strings do:[:str | 
        (idx := idx + 1) = (itemPatterns size + 1) ifTrue:[
            self error:'No more patterns'
        ].
        block value:(itemPatterns at:idx) value:str.
        (repeat and:[ idx = itemPatterns size ]) ifTrue:[
            idx := 0
        ].
    ].
    repeat ifTrue:[
        idx = 0 ifFalse:[
            self error:'Not enough items'
        ]
    ] ifFalse:[
        idx = itemPatterns size ifFalse:[
            self error:'Not enough items'
        ]
    ]

    "Created: / 16-05-2005 / 13:42:27 / masca"
! !

!ListPattern methodsFor:'testing'!

isListPattern
    ^ true

    "Created: / 14-05-2005 / 20:34:31 / janfrog"
!

isPCDataPattern

    ^true

    "Created: / 14-05-2005 / 18:27:29 / janfrog"
! !

!ListPattern methodsFor:'validation support'!

validate:aString for:validator 
    |idx strings|

    idx := 1.
    strings := aString asArrayOfSubstrings.
    (strings isEmpty and:[ self node firstChild isOneOrMoreNode ]) ifTrue:[
        ^ validator validationError:'Empty list'
    ].
    [
        self patternsAndObjects:strings
            do:[:pattern :string | 
                pattern validate:string for:validator.
                idx := idx + 1.
            ]
    ] on:Smalltalk::Error
            do:[:ex | 
        validator 
            validationError:'Cannot validate list item ' , idx printString , ': ' 
                    , ex errorString.
        ^ false
    ].
    ^ true

    "Created: / 14-05-2005 / 18:27:34 / janfrog"
    "Modified: / 14-05-2005 / 22:10:57 / janfrog"
    "Modified: / 16-05-2005 / 13:42:27 / masca"
! !

!ListPattern class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__ListPattern.st,v 1.1.1.1 2005-11-01 22:07:13 vranyj1 Exp $'
! !
