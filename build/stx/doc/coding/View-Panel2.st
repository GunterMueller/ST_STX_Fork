"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

StandardSystemView subclass:#PanelExample2
	instanceVariableNames:'listView1 listView2 textView'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Views'
!

!PanelExample2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    Tutorial example - a variable panel
    with two selectionInListViews and some textView.
    Multiple selections are allowed.

    [author:]
        Claus Gittinger

    [start with:]
        PanelExample2 open
"

! !

!PanelExample2 methodsFor:'initialization'!

initialize
    |frame topFrame v|

    super initialize.

    frame := VariableVerticalPanel origin:0.0 @ 0.0
                                   corner:1.0 @ 1.0
                                       in:self.

    topFrame := VariableHorizontalPanel origin:0.0 @ 0.0
                                        corner:1.0 @ 0.3
                                            in:frame.

    v := ScrollableView for:SelectionInListView in:topFrame.
    v origin:(0.0 @ 0.0) corner:(0.5 @ 1.0).
    listView1 := v scrolledView.
    listView1 action:[:lines | self select1:lines].
    listView1 multipleSelectOk:true.

    v := ScrollableView for:SelectionInListView in:topFrame.
    v origin:(0.5 @ 0.0) corner:(1.0 @ 1.0).
    listView2 := v scrolledView.
    listView2 action:[:lines | self select2:lines].
    listView2 multipleSelectOk:true.

    v := ScrollableView for:EditTextView in:frame.
    v origin:(0.0 @ 0.3) corner:(1.0 @ 1.0).
    textView := v scrolledView.

    self setupList.

    "PanelExample2 new open"
!

setupList
    listView1 list:#('item 1'
		     'item 2'
		     'item 3'
		     'item 4')
! !

!PanelExample2 methodsFor:'user actions'!

select1:aCollectionOfLines
    |first|

    textView list:nil.
    first := aCollectionOfLines first.
    listView2 list:(#(('item 1-1' 'item 1-2' 'item 1-3')
                      ('item 2-1' 'item 2-2' 'item 2-3')
                      ('item 3-1' 'item 3-2' 'item 3-3')
                      ('item 4-1' 'item 4-2' 'item 4-3')) at:first)
!

select2:aCollectionOfLines
    textView list:(Array with:'you selected ' , aCollectionOfLines printString)
! !

!PanelExample2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Panel2.st,v 1.7 1997-01-03 21:40:04 cg Exp $'
! !
