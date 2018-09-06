"
        Jun430 (2002/05/28) 

        Copyleft 1996-2002 
            AOKI Atsushi, ODA Tomohiro, HOSHI Takanori, NISHINAKA Yoshiyuki, 
            YAMADA Ryousuke, WATANABE Katsuhiro, Ankur J. Chavda, NISHIHARA Satoshi, 
            MATSUDA Ryouichi, MATSUO Minoru, Brent N. Reeves, ASAOKA Hiroko, and TANAKA Shinichi.
"
"{ Package: 'stx:libbasic2' }"

SequenceableCollection subclass:#SequenceWithSentinel
	instanceVariableNames:'sequence sentinel'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!SequenceWithSentinel class methodsFor:'documentation'!

copyright
"
        Jun430 (2002/05/28) 

        Copyleft 1996-2002 
            AOKI Atsushi, ODA Tomohiro, HOSHI Takanori, NISHINAKA Yoshiyuki, 
            YAMADA Ryousuke, WATANABE Katsuhiro, Ankur J. Chavda, NISHIHARA Satoshi, 
            MATSUDA Ryouichi, MATSUO Minoru, Brent N. Reeves, ASAOKA Hiroko, and TANAKA Shinichi.
"

    "Modified: / 27-03-2007 / 11:31:36 / cg"
!

documentation
"
    A collection with a default value for out-of-bounds accessed values.
"

    "Created: / 27-03-2007 / 11:32:14 / cg"
!

examples
"
                                                                [exBegin]
    |coll|

    coll := SequenceWithSentinel on:#(10 20 30 40 50) sentinel:'invalid'.
    Transcript show:'1->'; showCR:(coll at:1).
    Transcript show:'5->'; showCR:(coll at:5).
    Transcript show:'6->'; showCR:(coll at:6).
    coll do:[:each | Transcript showCR:each].
                                                                [exEnd]
"

    "Created: / 27-03-2007 / 11:32:14 / cg"
! !

!SequenceWithSentinel class methodsFor:'instance creation'!

new
    self shouldNotImplement

    "Modified: / 27-03-2007 / 11:36:32 / cg"
!

on: aSequence sentinel: anObject 
    "return a new collection based on aSequence but with invalid bounds-accesses returning abObject"

    | newSequence |

    newSequence := self basicNew.
    newSequence sequence: aSequence sentinel: anObject.
    ^ newSequence

    "Modified: / 27-03-2007 / 11:38:05 / cg"
! !

!SequenceWithSentinel methodsFor:'accessing'!

at: anIndex
    "return the element at anIndex, or sentinel if the index is invalid"

    ^ (anIndex between:1 and:self size)
        ifTrue: [sequence at: anIndex]
        ifFalse: [sentinel]

    "Modified: / 27-03-2007 / 11:33:23 / cg"
!

at: anIndex put: anObject 
    ^ sequence at: anIndex put: anObject

    "Modified: / 27-03-2007 / 11:33:59 / cg"
!

size
    "answer my size"

    ^ sequence size

    "Modified: / 27-03-2007 / 11:34:22 / cg"
! !

!SequenceWithSentinel methodsFor:'enumeration'!

do:aBlock
    sequence do:aBlock

    "Created: / 27-03-2007 / 11:34:46 / cg"
! !

!SequenceWithSentinel methodsFor:'growing'!

grow:howBig
    sequence grow:howBig

    "Created: / 27-03-2007 / 11:35:40 / cg"
! !

!SequenceWithSentinel methodsFor:'private'!

sentinel: anObject 
    "set the sentinel - the value returned for invalid indices"

    sentinel := anObject

    "Modified: / 27-03-2007 / 11:33:53 / cg"
!

sequence: aSequence
    "set the underlying collection"

    sequence := aSequence

    "Modified: / 27-03-2007 / 11:34:10 / cg"
!

sequence: aSequence sentinel: aSentinelValue
    "set the underlying collection and the sentinel (default)"

    sequence := aSequence.
    sentinel := aSentinelValue.

    "Created: / 27-03-2007 / 11:37:24 / cg"
! !

!SequenceWithSentinel methodsFor:'testing'!

isFixedSize
    "return true if the receiver cannot grow"

    ^ sequence isFixedSize
! !

!SequenceWithSentinel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/SequenceWithSentinel.st,v 1.2 2013-06-25 11:23:55 cg Exp $'
! !

