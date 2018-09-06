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
 'advanced games with contexts' - demonstration
 ----------------------------------------------

 fileIn the code and read the comments in the methods of ContextDemos
"

'From Smalltalk/X, Version:2.9.2 on 13-mar-1994 at 6:21:24'!

Object subclass:#ContextDemos
	 instanceVariableNames:''
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Contexts'
!

!ContextDemos class methodsFor:'funny loops'!

loop1:aBlock while:cond
    "this is actually NOT correct: it depends on the block
     in the ifTrue: being inlined, so that the #thisContext
     sent there actually returns the methods-context.
     (It works in ST/X, but may not in other ST-versions).

     This is definitely up to the implementation, which blocks
     are, and which are not inlined.
     See loop2 for a clean version."

    cond value ifFalse:[thisContext return].
    aBlock value.
    thisContext restart

    "
     |n|

     n := 1.
     ContextDemos loop1:[n printNewline. n := n + 1] while:[n <= 10]
    "
!

loop2:aBlock while:cond
    "
     Same as loop1, but in a portable & clean version.
     No matter of any inlining strategy of the
     compiler, the returned context will be the correct one.
    "

    |thisMethod|

    thisMethod := thisContext.
    cond value ifFalse:[thisMethod return].
    aBlock value.
    thisMethod restart

    "
     |n|

     n := 1.
     ContextDemos loop2:[n printNewline. n := n + 1] while:[n <= 10]
    "
!

blockWithExit
    "see comment in loop1:while: , which also applies here ...
     This example will NOT work - showing how NOT to do it."

    1 to:10 do:[:i |
	'<:' print. i printNewline.
	i == 5 ifTrue:[
	    thisContext return  "exists the block - not the loop"
	].
	'>:' print. i printNewline.
    ].
    "
     ContextDemos blockWithExit
    "
! 

blockWithLoopExit
    "see comment in loop1:while: , which also applies here ...
     this works, but only with knowledge about which contexts are
     inlined ..."

    1 to:10 do:[:i |
	'<:' print. i printNewline.
	i == 5 ifTrue:[
	    thisContext sender return  "exists the loop"
	].
	'>:' print. i printNewline.
    ].
    'after loop' printNL.

    "
     ContextDemos blockWithLoopExit
    "
! 

blockWithLoopExit2
    "this works in a portable & clean way (independent of
     any inline strategy in compiler)"

    |con|

    con := thisContext.
    1 to:10 do:[:i |
	'<:' print. i printNewline.
	i == 5 ifTrue:[
	    con resume  "exists the loop, continuing in method"
	].
	'>:' print. i printNewline.
    ].
    'after loop' printNL.

    "
     ContextDemos blockWithLoopExit2
    "
! ! 

!ContextDemos class methodsFor:'non local gotos'!

resumeExample1
    "call helper1, which calls helper2, which continues here ..."

    'm-a' printNewline.
    self resumeHelper1.
    'm-b' printNewline.

    "
     ContextDemos resumeExample1
    "
!

returnExample1
    "call helper1, which calls helper2, which returns helper2;
     continuing execution here ..."

    'm-a' printNewline.
    self returnHelper1.
    'm-b' printNewline.

    "
     ContextDemos returnExample1
    "
!

returnExample2
    "call helper1, which calls helper2, which returns from here"

    'm-a' printNewline.
    self returnHelperB1.
    'm-b' printNewline.   "not reached"

    "
     ContextDemos returnExample2
    "
! !

!ContextDemos class methodsFor:'stack unwinding'!

unwindExample1
    "call helper1, which calls helper2 which unwinds from here"

    'm-a' printNL.
    self unwindHelper1.
    'm-b' printNL.        "not reached"

    "
     ContextDemos unwindExample1
    "
!

unwindExample2
    "call helper1, which calls helper2 which unwinds from here.
     since there is a cleanup-block, this one is evaluated before
     returning."

    'm-a' printNL.
    [
	self unwindHelperB1.
    ] valueOnUnwindDo:[
	'an unwind occured' printNL
    ].
    'm-b' printNL.         "not reached"

    "
     ContextDemos unwindExample2
    "
!

unwindExample3
    'm-a' printNL.
    [
	self blockUnwindHelper1:[^ self].
    ] valueOnUnwindDo:[
	'an unwind occured' printNL
    ].
    'm-b' printNL.          "not reached"

    "
     ContextDemos unwindExample3
    "
!

unwindExample4
    'm-a' printNL.
    self unwindExample4B:[^ self].
    'm-b' printNL.          "not reached"

    "
     ContextDemos unwindExample4
    "
!

unwindExample4B:aBlock
    'mb-a' printNL.
    [
	self blockUnwindHelper1:aBlock
    ] valueOnUnwindDo:[
	'an unwind occured' printNL
    ].
    'mb-b' printNL.          "not reached"
! !

!ContextDemos class methodsFor:'helpers'!

unwindHelper1
    'h1-a' printNewline.
    self unwindHelper2.
    'h1-b' printNewline "not reached"
!

unwindHelper2
    'h2-a' printNewline.
    thisContext sender sender sender unwind. "returns from unwindExample1"
    'h2-b' printNewline "not reached"
!

unwindHelperB1
    'h1-a' printNewline.
    self unwindHelperB2.
    'h1-b' printNewline "not reached"
!

unwindHelperB2
    'h2-a' printNewline.
    thisContext sender sender sender sender unwind. "returns from unwindExample2"
    'h2-b' printNewline "not reached"
!

blockUnwindHelper1:aBlock
    'h1-a' printNewline.
    self blockUnwindHelper2:aBlock.
    'h1-b' printNewline "not reached"
!

blockUnwindHelper2:aBlock
    'h2-a' printNewline.
    aBlock value.       "returns from unwindExample3"
    'h2-b' printNewline "not reached"
!

resumeHelper1
    'h1-a' printNewline.
    self resumeHelper2.
    'h1-b' printNewline "not reached"
!

resumeHelper2
    'h2-a' printNewline.
    thisContext sender sender resume. "continue in resumeExample1"
    'h2-b' printNewline "not reached"
! 

returnHelper1
    'h1-a' printNewline.
    self returnHelper2.
    'h1-b' printNewline "not reached"
!

returnHelper2
    'h2-a' printNewline.
    thisContext sender return. "return from helper2, continuing in returnExample1"
    'h2-b' printNewline "not reached"
! 

returnHelperB1
    'h1-a' printNewline.
    self returnHelperB2.
    'h1-b' printNewline "not reached"
!

returnHelperB2
    'h2-a' printNewline.
    thisContext sender sender return. "return from returnExample2"
    'h2-b' printNewline "not reached"
! !
