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

Object subclass:#TopClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-HereSend'
!

TopClass subclass:#SubClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TopClass
!

!TopClass class methodsFor:'documentation'!

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
    this example shows, the difference between here- and self-sends
    Read the ST/X language documentation on more background info.

    have a look at the methods
        TopClass *FooIn*Class
        SubClass *FooIn*Class
    and try to understand which foo gets invoked.

    [start with:]
        TopClass testSends
"
! !

!TopClass class methodsFor:'tests'!

testSends
    'selfFooInSubClass send to SUB-inst : ' print.
    SubClass new selfFooInSubClass.

    'selfFooInTopClass send to SUB-inst : ' print.
    SubClass new selfFooInTopClass.

    'selfFooInTopClass send to TOP-inst : ' print.
    TopClass new selfFooInTopClass.

    'hereFooInSubClass send to SUB-inst : ' print.
    SubClass new hereFooInSubClass.
    'hereFooInTopClass send to SUB-inst : ' print.
    SubClass new hereFooInTopClass.

    'hereFooInTopClass send to TOP-inst : ' print.
    TopClass new hereFooInTopClass.

    'superFooInSubClass send to SUB-inst : ' print.
    SubClass new superFooInSubClass.

    "
     TopClass testSends
    "
! !

!TopClass methodsFor:'methods'!

foo
   'here is TOP foo' printNL.
! !

!TopClass methodsFor:'sends'!

hereFooInTopClass
   here foo

   "
    will reach my local foo - regardless of the receivers class
   "
   "
    TopClass new hereFooInTopClass
    SubClass new hereFooInTopClass
   "

   "
    in contrast to self-sends:
   "
   "
    TopClass new selfFooInTopClass
    SubClass new selfFooInTopClass
   "

!

selfFooInTopClass
   self foo

   "
    will reach foo of receivers class
   "
   "
    TopClass new selfFooInTopClass
    SubClass new selfFooInTopClass
   "

   "
    in contrast to here-sends:
   "
   "
    TopClass new hereFooInTopClass
    SubClass new hereFooInTopClass
   "

!

superFooInTopClass
   super foo
! !

!TopClass::SubClass methodsFor:'methods'!

foo
   'here is SUB foo' printNL.
! !

!TopClass::SubClass methodsFor:'sends'!

hereFooInSubClass
   here foo
!

selfFooInSubClass
   self foo
!

superFooInSubClass
   super foo
! !

!TopClass class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Special-hereSends.st,v 1.5 1997-01-03 19:45:05 cg Exp $'
! !
