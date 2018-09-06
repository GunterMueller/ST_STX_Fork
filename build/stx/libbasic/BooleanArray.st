"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

BitArray variableByteSubclass:#BooleanArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!BooleanArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    BooleanArrays are specially tuned to store booleans (true and false), 
    and are useful for bulk bit/boolean data. 

    Instances require only 1/32th (32bit machines) or even 1/64th (64bit machines)
    of memory compared to a regular array of booleans.

    They store 8 booleans per byte. 
    Since instances store bits in multiples of 8, 
    the real size of the collection is kept in an extra instance variable (tally).
    It may be useful if huge boolean arrays are to be used.

    ATTENTION:
        inheriting from BitArray, bits 1 to 8 of the BooleanArray are stored in bits 8 to 1 
        of the corresponding byte, to allow easy mapping to ASN.1 BIT STRING encoding
        in the BER.
        Do not change this.

    [memory requirements:]
        OBJ-HEADER + ((size + 7) // 8)

    [see also:]
        ByteArray WordArray Array

    [author:]
        Claus Gittinger
"
!

examples
"
                                                                        [exBegin]
    (BooleanArray new:7) inspect
                                                                        [exEnd]
                                                                        [exBegin]
    (BooleanArray new:7) basicInspect
                                                                        [exEnd]
                                                                        [exBegin]
    |flags|

    flags := BooleanArray new:1000000.
    (flags at:9999) printNL.
    flags at:9999 put:true.
    (flags at:9999) printNL.
                                                                        [exEnd]
"
! !

!BooleanArray methodsFor:'accessing'!

at:index
    "retrieve the boolean at index"

    ^ (super at:index) == 1

    "
     (BooleanArray new:1000) at:555
    "

    "
     |b|

     b := BooleanArray new:1000.
     b at:555 put:true.
     b at:555   
    "

    "Modified: / 31.7.1997 / 18:37:25 / cg"
    "Modified: / 23.5.1999 / 20:02:57 / stefan"
!

at:index put:aBoolean
    "store the argument, aBoolean at index; return aBoolean (sigh)."

    |v|

    aBoolean == true ifTrue:[
        v := 1.
    ] ifFalse:[
        aBoolean == false ifTrue:[
            v := 0.
        ] ifFalse:[
            "/ not true or false
            ^ self elementBoundsError:aBoolean
        ]
    ].
    super at:index put:v.
    ^ aBoolean

    "
     |b|

     b := BooleanArray new:1000.
     b at:555 put:true.
     b at:555   
    "
!

occurrencesOf:anElement
    "count the occurrences of the argument, anElement in the receiver"

    |nOnes|

    nOnes := self countOnes.
    anElement == true ifTrue:[
        ^ nOnes
    ].
    anElement == false ifTrue:[
        ^ tally - nOnes
    ].
    ^ 0

    "
     (BooleanArray new:10)
        at:4 put:true;
        at:6 put:true;
        at:7 put:true;
        occurrencesOf:true
    "
! !

!BooleanArray methodsFor:'filling & replacing'!

atAllPut:aBoolean
    "replace all elements of the collection by the argument, aBoolean.
     The argument, aBoolean must be true or false.
     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    |v|

    aBoolean == true ifTrue:[
        v := 1
    ] ifFalse:[
        aBoolean == false ifTrue:[
            v := 0
        ] ifFalse:[
            "/ booleanArrays can only hold true and false
            ^ self elementBoundsError:aBoolean
        ]
    ].
    super atAllPut:v
! !

!BooleanArray methodsFor:'queries'!

defaultElement
    ^ false
!

isValidElement:anObject
    "return true, if I can hold this kind of object"

    ^ anObject == true or:[anObject == false]
! !

!BooleanArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

