"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

Collection subclass:#CharacterSet
	instanceVariableNames:'bits'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Unordered'
!

!CharacterSet class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Used to represent 8-bit character sets (for now) as a bitmap.
    Bit[n] is set, if Character codePoint:(n-1) is included in the set.

    [author:]
        Claus Gittinger
"
! !

!CharacterSet class methodsFor:'instance creation'!

allSingleByteCharacters
    "return a new character set, which contains all single-byte characters"

    ^ self new addAllSingleByteCharacters
!

empty
    "return a new, empty character set"

    ^ self new
!

new
    "return a new, empty character set"

    ^ self basicNew initialize

    "Created: / 28-01-2011 / 17:29:24 / cg"
!

nonSeparators
    "return a new character set, which contains any but whitespace characters"

    ^ self new 
        addAllSingleByteCharacters;
        removeAll:(Character separators); 
        yourself
!

separators
    "return a new character set, which contains all whitespace characters"

    ^ self new 
        addAll:(Character separators); 
        yourself
! !

!CharacterSet methodsFor:'accessing'!

byteArrayMap
    ^bits
! !

!CharacterSet methodsFor:'adding & removing'!

add:aCharacter
    "add aCharacter to the collection.
     Returns aCharacter (sigh)"

    |cp byteIndex bitIndex|

    cp := aCharacter codePoint.
    self assert:(cp <= 255).
    byteIndex := (cp // 8) + 1.
    bitIndex := (cp \\ 8) + 1.
    byteIndex > bits size ifTrue:[
        bits := (ByteArray new:byteIndex) replaceFrom:1 with:bits.
    ].
    bits at:byteIndex put:((bits at:byteIndex) setBit:bitIndex).
    ^ aCharacter "/ sigh

    "Created: / 28-01-2011 / 17:44:21 / cg"
!

remove:aCharacter ifAbsent:exceptionValue
    |cp byteIndex bitIndex mask|

    cp := aCharacter codePoint.
    self assert:(cp <= 255).
    byteIndex := (cp // 8) + 1.
    bitIndex := (cp \\ 8) + 1.
    byteIndex <= bits size ifTrue:[
        ((mask := bits at:byteIndex) isBitSet:bitIndex) ifTrue:[
            bits at:byteIndex put:(mask clearBit:bitIndex).
            ^ aCharacter
        ].
    ].
    ^ exceptionValue value

    "Created: / 28-01-2011 / 17:51:22 / cg"
! !

!CharacterSet methodsFor:'comparing'!

= something
    ^ (self species = something species)
    and:[ bits = something byteArrayMap ]
!

hash
    ^ bits hash
! !

!CharacterSet methodsFor:'copying'!

postCopy
    "make sure that the bitmap is not shared with the copy"

    bits := bits copy
! !

!CharacterSet methodsFor:'initialization'!

addAllSingleByteCharacters
    bits := ByteArray new:"(256 / 8)"32 withAll:16rFF.

    "
     self assert:(
        CharacterSet new addAllCharacters
            includesAll:((Character value:0) to:(Character value:255)))

     self assert:(
        CharacterSet allCharacters
            includesAll:((Character value:0) to:(Character value:255)))
    "
!

initialize
    bits := nil "/ empty

    "Created: / 28-01-2011 / 17:29:48 / cg"
!

setByteArrayMap:aByteArray
    bits := aByteArray
! !

!CharacterSet methodsFor:'queries'!

do:aBlock
    |cp|

    cp := 0.
    bits notNil ifTrue:[
        bits do:[:eachByte |
            eachByte ~~ 0 ifTrue:[
                #(1 2 4 8 16 32 64 128) do:[:mask |
                    (eachByte bitTest:mask) ifTrue:[
                        aBlock value:(Character codePoint:cp).
                    ].
                    cp := cp + 1.
                ].
            ] ifFalse:[
                cp := cp + 8.
            ].
        ]
    ].

    "Created: / 28-01-2011 / 17:39:16 / cg"
!

includes:aCharacter
    "Return true if the set contains aCharacter"

    |cp byteIndex bitIndex|

    cp := aCharacter codePoint.
    (cp > 255) ifTrue:[^ false].

    byteIndex := (cp // 8) + 1.
    bitIndex := (cp \\ 8) + 1.
    byteIndex > bits size ifTrue:[^ false].
    ^ ((bits at:byteIndex) bitAt:bitIndex) ~~ 0
!

size
    |n|

    bits isNil ifTrue:[^ 0].

    n := 0.
    bits do:[:eachByte |
        n := n + (eachByte bitCount)
    ].
    ^ n

    "Created: / 28-01-2011 / 17:35:21 / cg"
! !

!CharacterSet methodsFor:'set operations'!

complement
    "return a character set containing all characters (from codepoint 0 to 255),
     which are NOT included in the receiver"

    ^ self class allSingleByteCharacters
        removeAll:self;
        yourself
! !

!CharacterSet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/CharacterSet.st,v 1.5 2014-12-28 14:08:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/CharacterSet.st,v 1.5 2014-12-28 14:08:18 cg Exp $'
! !

