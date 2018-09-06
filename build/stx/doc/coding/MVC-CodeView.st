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

"{ NameSpace: CodingExamples_GUI }"

Model subclass:#CodeViewDemoModel
	instanceVariableNames:'text'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-MVC'
!

!CodeViewDemoModel class methodsFor:'documentation'!

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
    the model-view way of using a codeView

    Demonstrates the use of a CodeView
    with an instance of this class as a model.

    [start with:]
        CodeViewDemoModel new open    
"
! !

!CodeViewDemoModel class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!CodeViewDemoModel methodsFor:'initialization'!

initialize
    text := '
hello world
this is some
text in a codeView
'
!

open
    |top codeview|

    top:= StandardSystemView new; extent:100@100.

    codeview := CodeView
	on: self
	aspect: #text 
	change: #acceptText:from:
	menu: #getMenu
	initialSelection:nil.

    codeview origin:0.0@0.0 corner:1.0@1.0.
    top addSubView:codeview.

    top open.

    "demonstrate that the CodeView follows my changes ..."
    [
	4 to:10 do:[:i |
	    (Delay forSeconds:10) wait.
	    self changeText
	]
    ] forkAt:5.

    "CodeViewDemoModel new open"
! !

!CodeViewDemoModel methodsFor:'user actions'!

accept:newText from:someOne
     Transcript showCR:'text changed'.
     text := newText
!

changeText
     text := text , '\more text added' withCRs.
     self changed:#text
!

getMenu
    "supposed to return a popupmenu"

    ^ PopUpMenu
	labels:#('m1' 'm2' 'm3' '-' 'copy' 'cut' 'paste')
	selectors:#(m1 m2 m3 nil copySelection cut paste)
!

m1
    Transcript showCR:'menu entry m1'.
!

m2
    Transcript showCR:'menu entry m2'.
!

m3
    Transcript showCR:'menu entry m3'.
!

text
    "supposed to return the text"

    ^ text
! !

!CodeViewDemoModel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/MVC-CodeView.st,v 1.8 1997-01-03 19:47:27 cg Exp $'
! !
