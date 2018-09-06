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

Object subclass:#BlockUnwindExample
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Blocks'
!

!BlockUnwindExample class methodsFor:'documentation'!

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
 'block unwinding' - demonstration
 ---------------------------------

 read the comments in example1 and example2
 and try it.

 [start with:]
        BlockUnwindExample example1
        BlockUnwindExample example2
"

! !

!BlockUnwindExample class methodsFor:'examples'!

doSomething
    "just a dummy action"

    self goDown:5 then:[
	Transcript showCR:'now halting'.
	self halt:'press abort or continue, please'.
	Transcript showCR:'after halt'
    ]
!

example1
    "this method shows how the 'valueNowOrOnUnwindDo:' and
     'valueOnUnwindDo:' messages are used to make certain that
     cleanup actions are performed.

     'self doSomething' will be executed with a cleanup action defined (cleanup1).
     During the evaluation of doSomething, an error (halt) will happen.

     In the debugger select a context below (for example the 'example1'-context) 
     and return it (or simply abort).
     See that the cleanup action (just a print) will be executed.
     If you choose to continue in the debugger, no cleanup action is done."

    [
	self doSomething
    ] valueOnUnwindDo:[
	Transcript showCR:'cleanup action1 executed'
    ].

    Transcript showCR:'normal exit'

    "
     BlockUnwindExample example1
    "
!

example2
    "another example - see how both cleanup1 and cleanup2 actions
     will be performed in case of an abort. Only cleanup action2 will
     be executed in case of a continue."

    [
	self exampleHelper
    ] valueNowOrOnUnwindDo:[
	Transcript showCR:'cleanup action2 executed'
    ].

    Transcript showCR:'normal exit'

    "
     BlockUnwindExample example2
    "
!

example3
    "this demonstrates, that cleanup actions are not only performed when
     returning via the signal mechanism, but also for normal long returns
     via blocks ..."

    [
	self goDown:5 then:[
	    Transcript showCR:'now returning'.
	    ^ self
	]
    ] valueNowOrOnUnwindDo:[
	Transcript showCR:'cleanup action executed'
    ].

    Transcript showCR:'normal exit'

    "
     BlockUnwindExample example3
    "
!

exampleHelper
    "just a helper for example2"

    self example1
!

goDown:n then:aBlock
    Transcript showCR:'down ..'.

    n > 0 ifTrue:[
	^ self goDown:n - 1 then:aBlock
    ].
    aBlock value.
! !

!BlockUnwindExample class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Block-unwind.st,v 1.7 1997-01-03 17:51:08 cg Exp $'
! !
