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

Object subclass:#ArrayLiteralBugDemonstration
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Bugs'
!

!ArrayLiteralBugDemonstration class methodsFor:'documentation'!

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
 'store into literal array bug' - demonstration
 ----------------------------------------------

 this file demonstrates a hard to find bug / strange feature.
 Storing into literal constants is allowed and leads to strange
 behavior. Read doc/online/../programming/classicBugs.html for
 a discussion of this (and how these bugs can be avoided in ST/X)

 FileIn this code and execute
        ArrayLiteralBugDemonstration new buggy1
        ArrayLiteralBugDemonstration new buggy2

 both with:
        Compiler arraysAreImmutable:true.

 and:
        Compiler arraysAreImmutable:false 


 You have to force recompilation after changing the immutable flag; i.e.:
        Compiler arraysAreImmutable:true.
        Smalltalk removeClass:ArrayLiteralBugDemonstration.
        Smalltalk fileIn:'../../doc/coding/Array-literalStore.st'

        Compiler arraysAreImmutable:false 
        Smalltalk removeClass:ArrayLiteralBugDemonstration.
        Smalltalk fileIn:'../../doc/coding/Array-literalStore.st'

 with Launcher, the compilers setting can also be changed via the
 'settings' menu.
"

! !

!ArrayLiteralBugDemonstration methodsFor:'bug1'!

buggy1
    "
     thats obvious ...
    "
    Transcript show:'literalArray initially returns: ';
	       showCR:(self literalArray) displayString.

    (self literalArray) at:2 put:'wrong'.

    Transcript show:'literalArray now returns: ';
	       showCR:(self literalArray) displayString.

    Transcript showCR:'but the source is still:'.
    Transcript cr.
    Transcript nextPutAll:(self class compiledMethodAt:#literalArray) source.
    Transcript cr.

    "
     ArrayLiteralBugDemonstration new buggy1
    "
!

buggy2
    "
     less obvious ... hard to track down
    "
    Transcript show:'literalArray initially returns: ';
	       showCR:(self literalArray) displayString.

    Transcript show:'literalArray modified: ';
	       showCR:(self literalArray replaceAll:'hello' by:'bug') displayString.

    Transcript show:'literalArray now returns: ';
	       showCR:(self literalArray) displayString.

    Transcript showCR:'but the source is still:'.
    Transcript cr.
    Transcript nextPutAll:(self class compiledMethodAt:#literalArray) source.
    Transcript cr.

    "
     ArrayLiteralBugDemonstration new buggy2
    "
!

literalArray
    ^ #('hello' 'there')

    "
     ArrayLiteralBugDemonstration new literalArray 
    "
! !

!ArrayLiteralBugDemonstration class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Array-literalStore.st,v 1.7 1997-01-03 15:49:46 cg Exp $'
! !
