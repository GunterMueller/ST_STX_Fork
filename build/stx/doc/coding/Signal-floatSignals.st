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

Object subclass:#FloatExceptionHandlingExample
	 instanceVariableNames:''
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Float-Signals'!

!FloatExceptionHandlingExample class methodsFor:'examples'!

example1
    |val|

    "do something which raises a domainError exception
     and handle the exception"

    Float divisionByZeroSignal
    handle:[:ex |
	self notify:'a floating point error occured.'.
	ex return
    ] do:[
	self computationWithError:0.0
    ].
    Transcript showCR:'here after computation.'

    "FloatExceptionHandlingExample example1"
!

example2
    |val|

    "do something which raises a floating exception
     do NOT handle the exception - thus we will reach the debugger"

    self computationWithError:0.0

    "FloatExceptionHandlingExample example2"
!

computationWithError:arg
    ^ 3.0 // arg    "this raises an exception if called with bad arg"
! !
