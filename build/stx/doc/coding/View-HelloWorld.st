"{ Namespace: 'CodingExamples_GUI' }"

"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

StandardSystemView subclass:#HelloView
       instanceVariableNames:''
       classVariableNames:''
       poolDictionaries:''
       category:'examples-Views-Tutorial'
!

!HelloView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    a hello world program - no system should be without one ;-)

    Notice, that this is NOT the simplest possible Hello-World
    program - a much easier one is:
	    (Label label:hello world') open

    The program here is written as a view-subclass and redefines the
    redraw method - in that, it is much more typical for user-written widgets,
    than the label demo.


    [see also:]
	( introduction to view programming :html: programming/viewintro.html )

    [start with:]
	HelloView open
	(Label label:'hello world') open
	((Label label:'hello world') extent:300@200) open

    [author:]
	Claus Gittinger (not much to do for it ..)
"
!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-HelloWorld.st,v 1.7 1996-12-21 18:34:41 cg Exp $'
! !

!HelloView class methodsFor:'startup'!

open
    |aDemo|

    aDemo := self 
		label:'Hello World'
		icon:(Image fromFile:'bitmaps/hello_world.icon')
		minExtent:(50 @ 50)
		maxExtent:(1000 @ 1000).
    aDemo extent:(300 @ 200).
    aDemo open.
    ^ aDemo

    "HelloView open"
! !

!HelloView methodsFor:'events'!

redraw
    |x y|

    x := (width - (font widthOf:'Hello World')) // 2.
    y := (height - font height) // 2.
    self displayString:'Hello World' x:x y:y
! !
