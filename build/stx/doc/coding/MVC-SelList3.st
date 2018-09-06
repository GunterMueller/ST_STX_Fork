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

Model subclass:#SelectionInListDemoModel3
	instanceVariableNames:'list'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-MVC'
!

!SelectionInListDemoModel3 class methodsFor:'documentation'!

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
    the model-view way of using a selectionInListView

    Demonstrates the use of a SelectionInListView
    with an instance of this class as a model.

    [start with:]
        SelectionInListDemoModel3 new open    
"
! !

!SelectionInListDemoModel3 class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!SelectionInListDemoModel3 methodsFor:'initialization'!

initialize
    list := #(1 2 3) asOrderedCollection
!

open
    |top sellist|

    top:= StandardSystemView new; extent:100@100.

    sellist := SelectionInListView
	on: self
	printItems: true
	oneItem: false
	aspect: #myAspect 
	change: #listIndex:
	list: #getList
	menu: #getMenu
	initialSelection: #initialIndex
	useIndex:false.


    sellist origin:0.0@0.0 corner:1.0@1.0.
    top addSubView:sellist.

    top open.

    [
	4 to:10 do:[:i |
	    (Delay forSeconds:10) wait.
	    self addElement:i
	]
    ] forkAt:5.

    "SelectionInListDemoModel3 new open"
! !

!SelectionInListDemoModel3 methodsFor:'user actions'!

addElement:newElement
    Transcript showCR:'adding an element'.
    list add:newElement.
    self changed:#myAspect
!

getList
    "supposed to return a list"

    ^ list
!

getMenu
    "supposed to return a popupmenu"

    ^ PopUpMenu
	labels:#('m1' 'm2' 'm3')
	selectors:#(m1 m2 m3)
!

initialIndex
    ^ 1
!

listIndex:aNumber
     Transcript showCR:'selection changed to ', aNumber printString
! !

!SelectionInListDemoModel3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/MVC-SelList3.st,v 1.8 1997-01-03 19:53:18 cg Exp $'
! !
