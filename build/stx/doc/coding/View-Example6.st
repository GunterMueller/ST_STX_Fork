"{ Namespace: 'CodingExamples_GUI' }"

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

StandardSystemView subclass:#Example6
       instanceVariableNames:'subview1 textview'
       classVariableNames:''
       poolDictionaries:''
       category:'examples-Views-Tutorial'
!

!Example6 class methodsFor:'documentation'!

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
    Tutorial example - a view with 2 subviews
    size ratios are variable; 2nd view is a text view showing some text;
    the textview is scrollable

    [author:]
	Claus Gittinger (spring 92)

    [start with:]
	Example6 start
"
!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Example6.st,v 1.6 1996-12-21 17:56:07 cg Exp $'
! !

!Example6 methodsFor:'initialization'!

initialize
    |hPixelPerMM vPixelPerMM helpview|

    super initialize.

    self label:'Turorial Example6'.

    hPixelPerMM := self horizontalPixelPerMillimeter rounded asInteger.
    vPixelPerMM := self verticalPixelPerMillimeter rounded asInteger.

    helpview := VariableVerticalPanel origin:(hPixelPerMM @ vPixelPerMM)
				      extent:[(width - (hPixelPerMM * 2))
					      @ 
					      (height - (vPixelPerMM * 2))]
					  in:self.

    subview1 := View origin:(0.0 @ 0.0) corner:(1.0 @ 0.5) in:helpview.
    subview1 level:-1.  "--- try changing this - see how it looks with 0 or 1"
    "subview1 level:0."  
    "subview1 level:1."  


    textview := ScrollableView for:TextView in:helpview.
    textview origin:(0.0 @ 0.5) corner:(1.0 @ 1.0).

"
    textview level:-1. 
"
    textview contents:'
This is a scrollable TextView

You can scroll the contents of this view using the scrollbar on
the left; the two buttons scroll one line up/down;

The thumb allows you to position anywhere in the text - press the
mouse on the thumb and move while keeping the mouse-button pressed.

The size of the thumb shows how much of the full text is visible in
the TextView - try resizing the view and see how the thumb changes
its size.

Notice, that this view has a popup-menu (right button)
and it supports copy.

Because its not an EditTextView, it does not support cut & paste.

see next example(s) for more ...
'

    "Example6 start"
! !
