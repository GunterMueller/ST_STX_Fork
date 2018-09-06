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

StandardSystemView subclass:#PanelExample3
	instanceVariableNames:'listView textView editTextView'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Views'
!

!PanelExample3 class methodsFor:'documentation'!

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
    with a selectionInListViews and two textViews,
    showing the selected file both unscrollable
    and scrollable.

    [author:]
        Claus Gittinger

    [start with:]
        PanelExample3 open
"


! !

!PanelExample3 methodsFor:'initialization'!

initialize
    |frame topFrame v1 v2 v3|

    super initialize.

    frame := VariableVerticalPanel 
		 origin:0.0 @ 0.0
		 corner:1.0 @ 1.0
		 in:self.

    v1 := ScrollableView for:SelectionInListView in:frame.
    v1 origin:0.0 @ 0.0
       corner:1.0 @ 0.5.
    v1 list:(FileDirectory directoryNamed:'/etc') contents.
    v1 action:[:selNr |
	    |fullName stream text|
	    fullName := '/etc/' , v1 selectionValue.
	    stream := fullName asFilename readStream.
	    stream notNil ifTrue:[
		text := stream contents.
		v2 contents:text.
		v3 contents:text
	    ]
    ].

    v2 := TextView 
	     origin:0.0 @ 0.5 
	     corner:1.0 @ 0.8 
	     in:frame.
    v3 := ScrollableView 
	     for:EditTextView 
	     in:frame.
    v3 origin:0.0 @ 0.8 
       corner:1.0 @ 1.0.

    "PanelExample3 new open"
! !

!PanelExample3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Panel3.st,v 1.7 1997-01-03 21:40:55 cg Exp $'
! !
