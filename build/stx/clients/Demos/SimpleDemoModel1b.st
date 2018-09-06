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

Model subclass:#SimpleDemoModel1b
	instanceVariableNames:'selected'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-MVC-Support'
!

!SimpleDemoModel1b class methodsFor:'documentation'!

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
    the model-view way of using selectionInListViews

    setup the view with myself as model; tell it to
    ask for the selection and tell me if the selection changes. 
    Also let it ask me for the list.

    [start with:]
        SimpleDemoModel1b new open
"

!

history

    "Created: 3.1.1997 / 21:04:51 / cg"
    "Modified: 3.1.1997 / 21:06:40 / cg"
! !

!SimpleDemoModel1b methodsFor:'initialization'!

open
    |top p b1 b2 s l|

    top:= StandardSystemView new; extent:100@100.
    p := PanelView origin:0.0@0.0 corner:1.0@0.5 in:top.
    b1 := Button label:'one' in:p.
    b2 := Button label:'two' in:p.

    "
     tell the buttons to tell me when pressed
    "
    b1 model:self; change:#button1Pressed.
    b2 model:self; change:#button2Pressed.

    s := ScrollableView for:SelectionInListView in:top.
    s origin:0.0@0.5 corner:1.0@1.0.
    l := s scrolledView.

    "
     tell the selectionInListView to tell me when the 
     selection changes AND to ask me for its list
    "
    l
        initialSelectionMessage:#selection; 
        listMessage:#list;
        change:#selectionChanged:;
        model:self.

    top open

    "
     SimpleDemoModel1b new open
    "

    "Created: 3.1.1997 / 21:04:52 / cg"
    "Modified: 3.1.1997 / 21:09:18 / cg"
! !

!SimpleDemoModel1b methodsFor:'user actions'!

button1Pressed
    Transcript showCR:'button1 was pressed'.
    selected := 1.
    self changed:#selection.

    "Created: 3.1.1997 / 21:04:52 / cg"
    "Modified: 3.1.1997 / 21:08:44 / cg"
!

button2Pressed
    Transcript showCR:'button2 was pressed'.
    selected := 2.
    self changed:#selection.

    "Created: 3.1.1997 / 21:04:52 / cg"
    "Modified: 3.1.1997 / 21:08:41 / cg"
!

selectionChanged:newSelection
    Transcript showCR:'selection changed to:', newSelection displayString.
    selected := newSelection.
    self changed:#selection.

    "Created: 3.1.1997 / 21:04:52 / cg"
    "Modified: 3.1.1997 / 21:08:54 / cg"
! !

!SimpleDemoModel1b methodsFor:'view queries'!

list
    "sent by the selectionInListView, to ask for the list"

    ^ #('1' '2' '3' '4')

    "Created: 3.1.1997 / 21:09:05 / cg"
!

selection
    "sent by the selectionInListView, to ask for the selection"

    ^ selected

    "Created: 3.1.1997 / 21:08:59 / cg"
! !

!SimpleDemoModel1b class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/SimpleDemoModel1b.st,v 1.1 1997-01-03 20:10:20 cg Exp $'
! !
