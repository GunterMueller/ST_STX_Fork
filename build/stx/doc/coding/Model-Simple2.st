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

Model subclass:#SimpleDemoModel2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-MVC-Support'
!

!SimpleDemoModel2 class methodsFor:'documentation'!

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

    Here, the selection-list is set statically and never asked for
    by the selectionInListView.

    [start with:]
        SimpleDemoModel2 new open
"
! !

!SimpleDemoModel2 methodsFor:'initialization'!

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
     selection changes, but to NOT try to update from the model
    "
    l
        initialSelectionMessage:nil; 
        listMessage:nil;
        aspectMessage:nil;
        change:#selectionChanged:;
        model:self.

    l list:#('1' '2' '3' '4').

    top open

    "
     SimpleDemoModel2 new open
    "
! !

!SimpleDemoModel2 methodsFor:'user actions'!

button1Pressed
    Transcript showCR:'button1 was pressed'
!

button2Pressed
    Transcript showCR:'button2 was pressed'
!

selectionChanged:newSelection
    Transcript showCR:'selection changed to:', newSelection displayString
! !

!SimpleDemoModel2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Model-Simple2.st,v 1.7 1997-01-03 20:11:20 cg Exp $'
! !
