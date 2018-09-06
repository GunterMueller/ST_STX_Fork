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


"{ NameSpace: CodingExamples }"

Object subclass:#DemoClass
	instanceVariableNames:'instVar1 instVar2 instVar3ToBeSkipped instVar4'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-BinaryStorage'
!

!DemoClass class methodsFor:'documentation'!

copyright
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

!

documentation
"
    BinaryStorage example of special stores.
    ---------------------------------------

    This fileIn shows how objects can be stored/retrieved 
    with some special representation 
    (for example, to not store certain instance variables).

    Please, (carefully) read the documentation on binaryStorage, for a
    detailed description, including examples and tuning tips.

    [start with:]
            DemoClass example
"

! !

!DemoClass class methodsFor:'examples'!

example
    |originalDemo loadedDemo s|

    originalDemo := self new.
    originalDemo instVar1:'value in 1'.
    originalDemo instVar2:'value in 2'.
    originalDemo instVar3:'value in 3'.
    originalDemo instVar4:'value in 4'.

    s := 'data.boss' asFilename writeStream.
    originalDemo storeBinaryOn:s.
    s close.

    s := 'data.boss' asFilename readStream.
    loadedDemo := Object readBinaryFrom:s.
    s close.

    originalDemo inspect.
    loadedDemo inspect.
! !

!DemoClass methodsFor:'accessing'!

instVar1:something
   instVar1 := something
!

instVar2:something
   instVar2 := something
!

instVar3:something
   instVar3ToBeSkipped := something
!

instVar4:something
   instVar4 := something
! !

!DemoClass methodsFor:'special binary storage'!

readBinaryContentsFromData:data manager:manager
    "special - retrieve instvars from data-array, as supplied in
     representBinaryOn:manager."

    instVar1 := data at:1.
    instVar2 := data at:2.
    instVar3ToBeSkipped := 'default value when restored'.
    instVar4 := data at:3.
!

representBinaryOn:manager
    "special representation: do not store instVar3 ..."

    |data|

    data := Array new:3.
    data at:1 put:instVar1.
    data at:2 put:instVar2.
    data at:3 put:instVar4.
    ^ data
! !

!DemoClass class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/BOSS-special.st,v 1.6 1997-01-03 15:55:45 cg Exp $'
! !
