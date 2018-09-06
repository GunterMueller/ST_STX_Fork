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

Object subclass:#FrameExample4
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Views'
!

!FrameExample4 class methodsFor:'documentation'!

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
    Tutorial example - a complex view with 2 frames

    This example differs from the previous frames by being a subclass
    of object (there is no need to do this, just for another variation).

    [author:]
        Claus Gittinger (oct 92)

    [start with:]
        FrameExample4 open
"
! !

!FrameExample4 class methodsFor:'startup'!

open
    self basicNew initialize

    "
     FrameExample4 open
    "

! !

!FrameExample4 methodsFor:'initialization'!

initialize
    |topView topPanel frame1 frame2 list1 list2 buttonPanel v|

    topView := StandardSystemView new.
    topView label:'Complex Frame Example'.

    topPanel := VariableHorizontalPanel 
                origin:(0.0 @ 0.0) corner:(1.0 @ 1.0)in:topView.

    frame1 := FramedBox
                origin:(0.0 @ 0.0) corner:(0.5 @ 1.0) in:topPanel.
    frame1 label:'list1'.

    frame2 := FramedBox origin:(0.5 @ 0.0) corner:(1.0 @ 1.0) in:topPanel.
    frame2 label:'list2'.

    v := ScrollableView for:SelectionInListView in:frame1.
    v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    list1 := v scrolledView.

    v := ScrollableView for:SelectionInListView in:frame2.
    v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    list2 := v scrolledView.

    topView open

    "
     FrameExample4 open
    "
! !

!FrameExample4 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Frame4.st,v 1.7 1997-01-03 21:43:50 cg Exp $'
! !
