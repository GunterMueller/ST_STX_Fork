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
 'multiple inheritance experiment'
 ---------------------------------

 this is a little demo of multiple inheritance - 
 ST/X supports an EXPERIMENTAL implementation of mixins, which
 allow adding other abstract classes to the superclass-set.
 Currently ONLY abstract classes can be added.
 This is EXPERIMENTAL - depending on what the testers say, 
 support for it it may or may not be added into the VM.
"

"
 the following change adds a second lookup in case of a
 doesNotUnderstand - effectively enabling MI
"
!

!Object methodsFor:'error handling'!

doesNotUnderstand:aMessage
    "enter debugger with does-not-understand-message"

    |errorString m|

    "this is an experimental implementation of Mixins
     (poor mans MI) - it will be moved into the VM if
     approved by the testers"

    m := self class lookupMethodFor:aMessage selector.
    m notNil ifTrue:[
	^ m valueWithReceiver:self arguments:(aMessage arguments) selector:aMessage selector
    ].

    aMessage selector isNil ifTrue:[
	"happens when things go mad, or a method has been
	 called by valueWithReceiver: with a wrong receiver"

	errorString := 'Message not understood: (nil)'
    ] ifFalse:[
	errorString := 'Message not understood: ' , aMessage selector
    ].
    MessageNotUnderstoodSignal
		raiseRequestWith:aMessage
		     errorString:errorString
!

baseClassResponsibility
    self error:'this method must be defined in the base class'
! !

"
 the actual MI classes:
 DerivedClass inherits both from BaseClass1 and BaseClass2 and Collection

 BaseClass2 adds #findFirst: to the protocol;
 Collection adds all enumeration stuff.
"


Object subclass:#BaseClass
	 instanceVariableNames:'v1 v2'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Classes-MI'
!

!BaseClass methodsFor:'enumeration'!

do:aBlock
    aBlock value:v1.
    aBlock value:v2
! !

Object subclass:#BaseClass2
	 instanceVariableNames:''
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Classes-MI'
!

!BaseClass2 methodsFor:'enumeration'!

do:aBlock
    self baseClassResponsibility
!

species
    ^ OrderedCollection
!

findFirst:aBlock
    self do:[:element |
	(aBlock value:element) ifTrue:[
	   ^ element
	]
    ].
    ^ nil
! !

BaseClass subclass:#DerivedClass
	 instanceVariableNames:'v3'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Classes-MI'
!

DerivedClass addSuperclass:BaseClass2!
DerivedClass addSuperclass:Collection!

!DerivedClass class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!DerivedClass methodsFor:'initialization'!

initialize
    v1 := 1.
    v2 := 2.
    v3 := 3

    "DerivedClass new"
! !

    "will lead to an error - BaseClass does not implement findFirst ..."
"
    BaseClass new findFirst:[:e | e printNewline. true]
"
    "will work as expected ..."
"
    DerivedClass new findFirst:[:e | e printNewline. true]
"
    "will lead to a funny error - since species is inherited from Object
     (not from BaseClass2), the collected-into object will be an instance
     of DerivedClass - which does not implement any add: method.

     The reason is that the implementation of the multi-lookup is not
     appropriate for this situation (its a depth-first search).
     What is really needed, is a depth-first-with-stop-at-joins search;
     i.e. stop whenever two superclass-chains join together."

"
    DerivedClass new collect:[:e | e * 10]    
"
