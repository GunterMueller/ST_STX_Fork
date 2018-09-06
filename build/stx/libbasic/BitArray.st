"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

ArrayedCollection variableByteSubclass:#BitArray
	instanceVariableNames:'tally'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!BitArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"

!

documentation
"
    BitArrays are specially tuned to store bits, and are useful for bulk bit/boolean data. 
    They require only 1/32th (32bit machines) or 1/64th (64bit machines) of the memory 
    compared to an array of booleans.

    They one stores 8 bits per byte. Since instances store bits in multiples
    of 8, the real size of the collection is kept in an extra instance variable (tally).
    It may be useful if huge boolean arrays are needed.

    There are 10 types of people in this world: 
        Those who understand binary, & those who don't.

    ATTENTION:
        Bits 1 to 8 of the BooleanArray are stored in bits 8 to 1 of the
        corresponding byte, to allow easy mapping to ASN.1 BIT STRING encoding
        in the BER. (i.e. MSB-first)
        Do not change this.
        
    [memory requirements:]
        OBJ-HEADER + ((size + 7) // 8)

    [author:]
        Claus Gittinger

    [see also:]
        BooleanArray ByteArray WordArray Array
"
!

examples
"
                                                                        [exBegin]
    (BitArray new:7) inspect
                                                                        [exEnd]
                                                                        [exBegin]
    (BitArray new:7) basicInspect
                                                                        [exEnd]
                                                                        [exBegin]
    |bits|

    bits := BitArray new:1000000.
    (bits at:9999) printCR.
    bits at:9999 put:1.
    (bits at:9999) printCR.
                                                                        [exEnd]
"
! !

!BitArray class methodsFor:'instance creation'!

fromBytes:aByteArray
    "return a new instance, capable of holding aByteArray size*8 bits, initialized from aByteArray"

    |a|

    a := self new: aByteArray size*8.
    1 to:aByteArray size do:[:i | a byteAt:i put:(aByteArray at:i)].
    ^ a

    "
     BitArray fromBytes:#[ 2r00001111 2r10101010 2r01010101]
    "
!

new
    "return a new instance, capable of holding size bits"

    ^ self new:0

    "
     BitArray new
    "
!

new:size
    "return a new instance, capable of holding size bits"

    |nBytes|

    nBytes := (size + 7) // 8.
    ^ (super new:nBytes) setTally:size

    "
     BitArray new:10
    "
!

uninitializedNew:size
    ^ self new:size
! !

!BitArray class methodsFor:'queries'!

maxVal
    "the minimum value which can be stored in instances of me.
     For BitArrays, this is 1"

    ^ 1
!

minVal
    "the minimum value which can be stored in instances of me.
     For BitArrays, this is 0"

    ^ 0
! !

!BitArray methodsFor:'accessing'!

at:index
    "retrieve the bit at index (1..)"

    |byte mask i0|

    (index between:1 and:tally) ifFalse:[
        ^ self subscriptBoundsError:index
    ].
    i0 := index - 1.
    byte := super basicAt:(i0 // 8)+1.
    mask := 1 bitShift:(7 - (i0 \\ 8)).
    ^ (byte bitTest:mask) ifTrue:[1] ifFalse:[0]

    "
     (BitArray new:1000) at:555
     (BitArray new:1000) at:400 put:1; at:400
    "

    "
     |b|

     b := BitArray new:1000.
     b at:555 put:1.
     b at:555   
    "
!

at:index put:aNumber
    "store the argument, aNumber at index (1..);    
     return the argument, aNumber (sigh)."

    |byte mask idx i0|

    (index between:1 and:tally) ifFalse:[
        ^ self subscriptBoundsError:index
    ].

    i0 := index - 1.
    idx := (i0 // 8) + 1.
    byte := super basicAt:idx.
    mask := 1 bitShift:(7 - (i0 \\ 8)).
    aNumber == 1 ifTrue:[
        byte := byte bitOr:mask
    ] ifFalse:[
        aNumber == 0 ifTrue:[
            byte := byte bitAnd:(mask bitInvert)
        ] ifFalse:[
            "/ not 0 or 1
            ^ self elementBoundsError:aNumber
        ]
    ].
    super basicAt:idx put:byte.
    ^ aNumber.

    "
     |b|

     b := BitArray new:1000.
     b at:555 put:1.
     b at:555    
    "
!

byteAt:index
    "retrieve 8 bits at index; the index is 1 for the first 8 bits, 2 for the next 8 bits etc."

    ^ self basicAt:index

    "
     ((BitArray new:8) at:1 put:1); byteAt:1
    "
!

byteAt:index put:aByte
    "store 8 bits at index; the index is 1 for the first 8 bits, 2 for the next 8 bits etc."

    ^ self basicAt:index put:aByte

    "
     ((BitArray new:8) byteAt:1 put:128); at:1     
    "
!

occurrencesOf:anElement
    "count the occurrences of the argument, anElement in the receiver"

    |nOnes|

    nOnes := self countOnes.
    anElement == 1 ifTrue:[
        ^ nOnes
    ].
    anElement == 0 ifTrue:[
        ^ tally - nOnes
    ].
    ^ 0

    "
     (BitArray new:10)
        at:4 put:1;
        at:6 put:1;
        at:7 put:1;
        occurrencesOf:1 

     (BitArray new:10)
        at:4 put:1;
        at:6 put:1;
        at:7 put:1;
        occurrencesOf:0    
    "
! !

!BitArray methodsFor:'converting'!

bytes
    "answer myself as a ByteArray containing my bytes"

    |size bytes|

    size := self basicSize.
    bytes := ByteArray new:size.
    1 to:size do:[:index|
        bytes at:index put:(self byteAt:index)
    ].
    ^ bytes
! !

!BitArray methodsFor:'filling & replacing'!

atAllPut:aNumber
    "replace all elements of the collection by the argument, aNumber.
     The argument, aBoolean must be 0 or 1.
     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    |v lastIndex|

    lastIndex := self basicSize.
    lastIndex == 0 ifTrue:[^ self].

    aNumber == 1 ifTrue:[
        v := 255
    ] ifFalse:[
        aNumber == 0 ifTrue:[
            v := 0
        ] ifFalse:[
            "/
            "/ booleanArrays can only hold true and false
            "/
            ^ self elementBoundsError:aNumber
        ]
    ].
    1 to:lastIndex-1 do:[:i |
        self basicAt:i put:v
    ].

    "/ ensure 0-bits above tally
    v := #[ 2r11111111
            2r10000000
            2r11000000
            2r11100000
            2r11110000
            2r11111000
            2r11111100
            2r11111110 ] at:(tally\\8)+1. 
    self basicAt:lastIndex put:v.

    "
     ((self new:10) atAllPut:1) countOnes  
     ((self new:8) atAllPut:1) countOnes   
    "
! !

!BitArray methodsFor:'logical operations'!

bitOr:aBitArray
    |new mySize "{ Class: SmallInteger }" otherSize "{ Class: SmallInteger }"|

    mySize := self basicSize.
    otherSize := aBitArray basicSize.

    new := self class basicNew:(mySize max:otherSize).
    new setTally:(self size max:aBitArray size).

    1 to:mySize do:[:i|
        new basicAt:i put:(self basicAt:i).
    ].
    1 to:otherSize do:[:i|
        new basicAt:i put:((new basicAt:i) bitOr:(aBitArray basicAt:i)).
    ].
    
    ^ new

    "
        ((BitArray new:5) at:3 put:1; yourself) bitOr:((BitArray new:8) at:5 put:1; yourself)
    "
! !

!BitArray methodsFor:'private'!

countOnes
    "count the 1-bits in the receiver"

    |sz bI count|

    count := 0.

    "/ because remaining bits in the highest byte are always 0,
    "/ we can simply count the 1-bits in ALL bytes... (see lastByte handling in atAllPut:)
    bI := 1.
    sz := self basicSize.
    [bI <= sz] whileTrue:[
        count := count + (self basicAt:bI) bitCount.
        bI := bI + 1.
    ].
    ^ count

"/    |i nI bI bits count|
"/    i := bI := 1.
"/    [
"/        nI := i + 8.
"/        nI <= tally
"/    ] whileTrue:[
"/        bits := self basicAt:bI.
"/        count := count + bits bitCount.
"/        bI := bI + 1.
"/        i := nI
"/    ].
"/    [i <= tally] whileTrue:[
"/        (self at:i) ifTrue:[ count := count + 1].
"/        i := i + 1.
"/    ].
"/    ^ count

    "
     (BooleanArray new:100)
        at:14 put:true; 
        at:55 put:true; 
        countOnes

     (BooleanArray new:100)
        at:14 put:true; 
        at:55 put:true; 
        occurrencesOf:true

     (BooleanArray new:100)
        at:14 put:true; 
        at:55 put:true; 
        occurrencesOf:false
    "
!

indexOfNth:n occurrenceOf:what
    "return the index of the nTh occurrence of a value, or 0 if there are not that many"

    |sz byteIndex count countInByte|

    n > self size ifTrue:[^ 0].

    count := 0.

    byteIndex := 1.
    sz := self basicSize.
    [byteIndex <= sz] whileTrue:[
        countInByte := (self basicAt:byteIndex) bitCount.
        what = self defaultElement ifTrue:[
            countInByte := 8-countInByte.
        ].
        count := count + countInByte.
        count >= n ifTrue:[
            count := count - countInByte.
            (byteIndex-1)*8+1 to:(byteIndex-1)*8+8 do:[:bitIndex |
                (self at:bitIndex) = what ifTrue:[
                    count := count + 1.
                    count = n ifTrue:[
                        ^ bitIndex.
                    ]
                ].
            ].
            ^ 0
        ].
        byteIndex := byteIndex + 1.
    ].
    ^ 0

    "
     (BooleanArray new:100)
        at:1 put:true;
        at:2 put:true;
        at:4 put:true;
        at:5 put:true;
        at:6 put:true;
        at:7 put:true;
        at:8 put:true;
        at:10 put:true;
        indexOfNth:8 occurrenceOf:false
    "
!

setTally:size
    "set my tally - that is the actual number of bits in me
     (usually a little less than the number of bits in my byte array)"

    tally := size
! !

!BitArray methodsFor:'queries'!

defaultElement
    ^ 0
!

isValidElement:anObject
    "return true, if I can hold this kind of object"

    ^ anObject == 0 or:[anObject == 1]
!

size
    "return the size of the receiver"

    ^ tally
! !

!BitArray methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitBitArray:with: to aVisitor"

    ^ aVisitor visitBitArray:self with:aParameter
! !

!BitArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

