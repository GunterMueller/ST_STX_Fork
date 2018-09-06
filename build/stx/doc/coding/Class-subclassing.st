"{ Namespace: 'CodingExamples' }"

"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

"
 'misc ways of subclassing' - demonstration
 ------------------------------------------

 these code fragments create various types of subclasses.
 FileIn this and watch the Transcript.

 They also show, that in ST/X you CAN have variableByte
 classes WITH named instance variables (i.e. subclassing String,
 Symbol etc. is allowed). 
 However, keep in mind that this is a non-portable feature, since other 
 Smalltalk implementations may not support this.

 The same warning applies to variableWord, variableFloat
 and variableDouble classes. Especially the last two were
 added to provide some (higher performance) support for
 3D graphics and vector processors.
"

"************************************************************************"

Transcript showCR:'definining a variableByte class ...'!

Object variableByteSubclass:#SubclassingExample1
	 instanceVariableNames:'inst1 inst2'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Subclassing'
!

!SubclassingExample1 methodsFor:'accessing'!

inst1:anObject
    inst1 := anObject
!

inst2:anObject
    inst2 := anObject
! !

|o|

Transcript showCR:'creating an instance ...'.
o := SubclassingExample1 new:5.
o inst1:#inst1.
o inst2:#inst2.
o at:1 put:5.
o at:2 put:4.
o at:3 put:3.
o at:4 put:2.
o at:5 put:1.
Transcript showCR:o printString; cr
!

"************************************************************************"

Transcript showCR:'definining a subclass of a variableByte class ...'!

SubclassingExample1 subclass:#SubclassingExample1b
	 instanceVariableNames:'inst3'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Subclassing'
!

!SubclassingExample1b methodsFor:'accessing'!

inst3:anObject
    inst3 := anObject
! !

|o|

Transcript showCR:'creating an instance ...'.
o := SubclassingExample1b new:5.
o inst1:#inst1.
o inst2:#inst2.
o inst3:#inst3.
o at:1 put:5.
o at:2 put:4.
o at:3 put:3.
o at:4 put:2.
o at:5 put:1.
Transcript showCR:o printString; cr
!

"************************************************************************"

Transcript showCR:'definining a subclass of string ...'!

String subclass:#SubclassingExample1c
	 instanceVariableNames:'inst1'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Subclassing'
!

!SubclassingExample1c class methodsFor:'accessing'!

new
    ^ (super new) initialize
!

new:size
    ^ (super new:size) initialize
! !

!SubclassingExample1c methodsFor:'accessing'!

instvar
    ^ inst1
!

instvar:something
    inst1 := something
! !

!SubclassingExample1c methodsFor:'setup'!

initialize
    inst1 := #additionalInstvarsValue
! !

!SubclassingExample1c methodsFor:'copying'!

copyEmpty
    ^ (super copyEmpty) instvar:inst1
! !


|o|

Transcript showCR:'creating an instance ...'.
o := SubclassingExample1c withAll:'hello world'.
Transcript show:'prints as: '; showCR:o printString.
Transcript show:'but has instance: '; showCR:o instvar printString.
Transcript show:'copy has instance: '; showCR:o copy instvar printString.
Transcript show:'compares with string: '; showCR:(o = 'hello world') printString; cr.
!

"************************************************************************"

Transcript showCR:'definining a variableWord class ...'!

Object variableWordSubclass:#SubclassingExample2
	 instanceVariableNames:'inst1 inst2'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Subclassing'
!

!SubclassingExample2 methodsFor:'accessing'!

inst1:anObject
    inst1 := anObject
!

inst2:anObject
    inst2 := anObject
! !

|o|

Transcript showCR:'creating an instance ...'.
o := SubclassingExample2 new:5.
o inst1:#inst1.
o inst2:#inst2.
o at:1 put:16rFFFF.
o at:2 put:3.
o at:3 put:2.
o at:4 put:1.
o at:5 put:0.
Transcript showCR:o printString; cr
!

"************************************************************************"

Transcript showCR:'definining a subclass of a variableWord class ...'!

SubclassingExample2 subclass:#SubclassingExample2b
	 instanceVariableNames:'inst3'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Subclassing'
!

!SubclassingExample2b methodsFor:'accessing'!

inst3:anObject
    inst3 := anObject
! !

|o|

Transcript showCR:'creating an instance ...'.
o := SubclassingExample2b new:5.
o inst1:#inst1.
o inst2:#inst2.
o inst3:#inst3.
o at:1 put:16rFFFF.
o at:2 put:3.
o at:3 put:2.
o at:4 put:1.
o at:5 put:0.
Transcript showCR:o printString; cr
!

"************************************************************************"

Transcript showCR:'definining a variableLong class ...'!

Object variableLongSubclass:#SubclassingExample3
	 instanceVariableNames:'inst1 inst2'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Subclassing'
!

!SubclassingExample3 methodsFor:'accessing'!

inst1:anObject
    inst1 := anObject
!

inst2:anObject
    inst2 := anObject
! !

|o|

Transcript showCR:'creating an instance ...'.
o := SubclassingExample3 new:5.
o inst1:#inst1.
o inst2:#inst2.
"o at:1 put:16rFFFFFFFF."     "this must work, retrieve a long on access"
o at:2 put:3.
o at:3 put:2.
o at:4 put:1.
o at:5 put:0.
Transcript showCR:o printString; cr
!

"************************************************************************"

Transcript showCR:'definining a subclass of a variableLong class ...'!

SubclassingExample3 subclass:#SubclassingExample3b
	 instanceVariableNames:'inst3'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Subclassing'
!

!SubclassingExample3b methodsFor:'accessing'!

inst3:anObject
    inst3 := anObject
! !

|o|

Transcript showCR:'creating an instance ...'.
o := SubclassingExample3b new:5.
o inst1:#inst1.
o inst2:#inst2.
o inst3:#inst3.
"o at:1 put:16rFFFFFFFF."
o at:2 put:3.
o at:3 put:2.
o at:4 put:1.
o at:5 put:0.
Transcript showCR:o printString; cr
!

"************************************************************************"

Transcript showCR:'definining a variableFloat class ...'!

Object variableFloatSubclass:#SubclassingExample4
	 instanceVariableNames:'inst1 inst2'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Subclassing'
!

!SubclassingExample4 methodsFor:'accessing'!

inst1:anObject
    inst1 := anObject
!

inst2:anObject
    inst2 := anObject
! !

|o|

Transcript showCR:'creating an instance ...'.
o := SubclassingExample4 new:5.
o inst1:#inst1.
o inst2:#inst2.
o at:1 put:0.0.     
o at:2 put:1.0.
o at:3 put:2.0.
o at:4 put:3.0.
o at:5 put:4.0.
Transcript showCR:o printString; cr
!

"************************************************************************"

Transcript showCR:'definining a subclass of a variableFloat class ...'!

SubclassingExample4 subclass:#SubclassingExample4b
	 instanceVariableNames:'inst3'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Subclassing'
!

!SubclassingExample4b methodsFor:'accessing'!

inst3:anObject
    inst3 := anObject
! !

|o|

Transcript showCR:'creating an instance ...'.
o := SubclassingExample4b new:5.
o inst1:#inst1.
o inst2:#inst2.
o inst3:#inst3.
o at:1 put:0.0.     
o at:2 put:1.0.
o at:3 put:2.0.
o at:4 put:3.0.
o at:5 put:4.0.
Transcript showCR:o printString; cr
!

"************************************************************************"

Transcript showCR:'definining a variableDouble class ...'!

Object variableDoubleSubclass:#SubclassingExample5
	 instanceVariableNames:'inst1 inst2'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Subclassing'
!

!SubclassingExample5 methodsFor:'accessing'!

inst1:anObject
    inst1 := anObject
!

inst2:anObject
    inst2 := anObject
! !

|o|

Transcript showCR:'creating an instance ...'.
o := SubclassingExample5 new:5.
o inst1:#inst1.
o inst2:#inst2.
o at:1 put:0.0.     
o at:2 put:1.0.
o at:3 put:2.0.
o at:4 put:3.0.
o at:5 put:4.0.
Transcript showCR:o printString; cr
!

"************************************************************************"

Transcript showCR:'definining a subclass of a variableDouble class ...'!

SubclassingExample5 subclass:#SubclassingExample5b
	 instanceVariableNames:'inst3'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Subclassing'
!

!SubclassingExample5b methodsFor:'accessing'!

inst3:anObject
    inst3 := anObject
! !

|o|

Transcript showCR:'creating an instance ...'.
o := SubclassingExample5b new:5.
o inst1:#inst1.
o inst2:#inst2.
o inst3:#inst3.
o at:1 put:0.0.     
o at:2 put:1.0.
o at:3 put:2.0.
o at:4 put:3.0.
o at:5 put:4.0.
Transcript showCR:o printString; cr
!

"************************************************************************"
