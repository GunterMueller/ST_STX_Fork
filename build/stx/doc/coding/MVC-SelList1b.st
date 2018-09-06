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

Model subclass:#SelectionInListDemoModel1b
	instanceVariableNames:'currentList currentSelection'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-MVC'
!

!SelectionInListDemoModel1b class methodsFor:'documentation'!

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
        SelectionInListDemoModel1b new open    
"
! !

!SelectionInListDemoModel1b methodsFor:'initialization'!

open
    |top list|

    currentList := #('one' 'two' 'three').

    top:= StandardSystemView new; extent:100@100.

    list := SelectionInListView
	on: self
	printItems: true
	oneItem: false
	aspect: #demoAspect 
	change: #listIndex:
	list: #getList
	menu: #getMenu
	initialSelection: #initialIndex
	useIndex: true.


    list origin:0.0@0.0 corner:1.0@1.0.
    top addSubView:list.

    top open.

    "SelectionInListDemoModel1b new open"
! !

!SelectionInListDemoModel1b methodsFor:'user actions'!

getList
    "supposed to return a list"

    ^ currentList 
!

getMenu
    "supposed to return a popupmenu"

    currentSelection == 1 ifTrue:[
	currentList := #('one' 'two' 'three').
	self changed:#demoAspect.
	^ PopUpMenu
	    labels:#('a1' 'a2' 'a3')
	    selectors:#(m1 m2 m3)
    ].

    currentList := #('eins' 'zwei' 'drei').
    self changed:#demoAspect.
    ^ PopUpMenu
	labels:#('m1' 'm2' 'm3')
	selectors:#(m1 m2 m3)
!

initialIndex
    ^ 1
!

listIndex:aNumber
     currentSelection := aNumber.
     Transcript showCR:'selection changed to ', aNumber printString
! !

!SelectionInListDemoModel1b class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/MVC-SelList1b.st,v 1.8 1997-01-03 19:49:53 cg Exp $'
! !
