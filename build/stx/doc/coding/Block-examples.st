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

Object subclass:#BlockExamples
	instanceVariableNames:''
	classVariableNames:'Restarted'
	poolDictionaries:''
	category:'examples-Blocks'
!

!BlockExamples class methodsFor:'documentation'!

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
    demonstration of block semantics.
    Read the methods sourceCode and try to understand what is
    going on ...

    [start with:]
        BlockExamples closureExample1
        Transcript showCR:BlockExamples contextExample1
        Transcript showCR:BlockExamples recursiveExample1
        Transcript showCR:BlockExamples recursiveExample2
        BlockExamples returnExample1
        BlockExamples returnExample2
        BlockExamples returnExample3
        BlockExamples returnExample4
        BlockExamples returnExample5
"
! !

!BlockExamples class methodsFor:'closure example'!

closureExample1
    "this example shows that blocks can live and access method
     locals even when their defining method has already left.
     In this example, the incBlock, decBlock and getBlock access
     a variable hidden in another methods context.
     Notice, that the method which created that variable (as a local variable)
     has already returned; beside through the blocks, there is no access
     possible to that variable. (call it an 'anonymous' variable).
     This example will probably not work in ST/V"

    | blocks incBlock decBlock getBlock|

    "get the blocks (their home method is dead when we are here again)"

    blocks := self closureExample1Helper.
    incBlock := blocks at:1.
    decBlock := blocks at:2.
    getBlock := blocks at:3.

    Transcript show:'variable value == '; showCR:getBlock value.
    Transcript showCR:'increment twice ..'. 
    incBlock value. 
    incBlock value.
    Transcript show:'variable value == '; showCR:getBlock value.

    Transcript showCR:'decrement ..'. 
    decBlock value.
    Transcript show:'variable value == '; showCR:getBlock value.

    "
     BlockExamples closureExample1
    "
! !

!BlockExamples class methodsFor:'context example'!

contextExample1
    "This examples demonstrates, that blocks have private local arguments
     will not work on PPS before 2.3 and (some?) Smalltalk/V versions"

    | collectionOfBlocks |

    collectionOfBlocks := self contextExample1Helper.
    ^ collectionOfBlocks collect:[:j | j value]

    "
     BlockExamples contextExample1  

     -> should return OrderedCollection(1 2 3 4)"
! !

!BlockExamples class methodsFor:'example helper methods'!

closureExample1Helper
    "helper for returnExample1; return an array with 3 blocks,
     which access a method local"

    |variable|

    variable := 0.
    ^ Array with:[variable := variable + 1]
	    with:[variable := variable - 1]
	    with:[variable]
!

contextExample1Helper
    "helper for contextExample1; return a collection of blocks"

    |c|

    c:=OrderedCollection new. 
    1 to:4 do:[:i|
      c add:[i]     "a block returning i"
    ].
    ^ c             "a collection of blocks returning i (1), i' (2), i'' (3) and i''' (4)"
!

returnExample1Helper
    "helper for returnExample1; return a returning block"

    ^ [ 
	Transcript showCR:'in block-1 - now returning'.
	^ 'blocks value'.
	Transcript showCR:'in block-2'.
      ]
!

returnExample2Helper
    "helper for returnExample2; return a block with a return from
     a nested block"

    ^ [
	Transcript showCR:'in block1-1'.
	[
	  Transcript showCR:'in block2-1'.
	  [
	    Transcript showCR:'in block3-1'.
	    ^ nil.
	    Transcript showCR:'in block3-2'.
	  ] value.
	  Transcript showCR:'in block2-2'
	] value.
	Transcript showCR:'in block1-2'.
    ]
!

returnExample3Helper
    "helper for returnExample3; return a block, which evaluates its
     argument block in a nested block"

    ^ [:exitBlock |
	Transcript showCR:'in block1-1'.
	[:exitBlock |
	  Transcript showCR:'in block2-1'.
	  [:exitBlock |
	    Transcript showCR:'in block3-1; now evaluating exitBlock'.
	    exitBlock value.
	    Transcript showCR:'in block3-2'.
	  ] value:exitBlock.
	  Transcript showCR:'in block2-2'
	] value:exitBlock.
	Transcript showCR:'in block1-2'.
    ]
! !

!BlockExamples class methodsFor:'recursive blocks'!

recursiveExample1
    "This examples demonstrates, that blocks can be recursive;
     will not work on PPS before V2.3 and (some?) Smalltalk/V versions"

    |fBlock|

    fBlock := [:n |
	n<= 0 ifTrue:[1]
	      ifFalse:[n * (fBlock value:(n - 1))]].

    ^ (0 to:3) collect:fBlock

    "
     BlockExamples recursiveExample1

     -> should return OrderedCollection(1 1 2 6)"
!

recursiveExample2
    "This examples demonstrates, that blocks can be recursive;
     will not work on PPS before V2.3 and (some?) Smalltalk/V versions"

    |fBlock|

    fBlock := [:n |
	n<= 0 ifTrue:[1]
	      ifFalse:[(fBlock value:(n - 1)) * n]].

    ^ (0 to:3) collect:fBlock.

    "
     BlockExamples recursiveExample2

     -> should return OrderedCollection(1 1 2 6)"
! !

!BlockExamples class methodsFor:'return examples'!

returnExample1
    "this example shows that a method-return from a block is illegal,
     if the defining method has already left"

    | block |

    "get the block, which contains a return from an already
     left method"

    block := self returnExample1Helper.
    Transcript showCR:'one'.
    block value.
    Transcript showCR:'two'.

    "
     BlockExamples returnExample1
     -> should raise an error
    "
!

returnExample2
    "like returnExample1, this example shows that a method-return from a block 
     is illegal, if the defining method has already left.
     Here we return from a somewhat deeper nested block."

    | block |

    "get the block, which contains a return from an already
     left method. the return is performed in a nested block"

    block := self returnExample2Helper.

    Transcript showCR:'one'.
    block value.
    Transcript showCR:'two'.

    "
     BlockExamples returnExample2

     -> should raise an error
    "
!

returnExample3
    "this example shows how blocks could be used to
     implement some catch&throw mechanism.
     (but now, since Signals and exceptions are available,
      this is no longer a 'good' example)"

    |exitBlock block|

    exitBlock := [^ self].

    Transcript showCR:'examples starts'.
    block := self returnExample3Helper.
    Transcript showCR:'block created - now evaluate block'.
    block value:exitBlock.
    Transcript showCR:'two'. "*** not reached ***"

    "
     BlockExamples returnExample3
    "
!

returnExample3b
    "same as returnExample3 - but inline coded"

    |block|

    Transcript showCR:'examples starts'.
    block := self returnExample3Helper.
    Transcript showCR:'block created - now evaluate block'.
    block value:[^ self].
    Transcript showCR:'two'. "*** not reached ***"

    "
     BlockExamples returnExample3b
    "
!

returnExample4
    "like returnExample3, this shows that a method-return from a block is illegal,
     if the defining method has already left. 
     But since the error is reported using the normal signal mechanism, 
     we can catch this exception and handle it.
     In this case, we simply return from the block."

    | block val |

    "get the block, which contains a return from an already
     left method"

    Transcript showCR:'example starts'.
    block := self returnExample1Helper.
    Transcript showCR:'block created '.
    Context invalidReturnSignal handle:[:ex |
	"ex parameter will be the to-be-returned value"
	Transcript showCR:'caught invalid return'.
	ex proceedWith:(ex parameter).
    ] do:[
	Transcript showCR:'evaluating block'.
	val := block value.
	"*** reached ***"
	Transcript showCR:'value returned: ' , val printString.
    ].
    Transcript showCR:'two'.

    "
     BlockExamples returnExample4
    "
!

returnExample5
    "this example shows how blocks could be used to
     implement some restart mechanism. We pass down a block which,
     when evaluated, restarts the method. To avoid endless recursion,
     a flag is used to pass an exiting block the second time.
     (now, since Signals and exceptions are available,
      this is no longer a 'good' example)"

    |restartBlock exitBlock block con|

    con := thisContext.    
    restartBlock := [Restarted := true. con restart].
    exitBlock := [^ self].

    Restarted == true ifTrue:[
	Transcript showCR:'in restart action'.
	Restarted := nil.
	block value:exitBlock.
	^ self
    ].

    Transcript showCR:'example starts ...'.

    block := self returnExample3Helper.
    Transcript showCR:'block created - now evaluate block'.
    block value:restartBlock.
    Transcript showCR:'two'. "*** not reached ***"

    "
     BlockExamples returnExample5
    "
! !

!BlockExamples class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Block-examples.st,v 1.8 1997-06-16 18:47:45 cg Exp $'
! !
