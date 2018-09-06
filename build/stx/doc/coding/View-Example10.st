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

StandardSystemView subclass:#Example10
	 instanceVariableNames:'menu myView openBox'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Views-Tutorial'
!

!Example10 class methodsFor:'documentation'!

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
    Tutorial example - a complete setup for a scrollable textview with a menu.
    The open function has been implemented.
    Notice - this is almost an editor !

    [author:]
	Claus Gittinger (spring 92)

    [start with:]
	Example10 start
"
!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Example10.st,v 1.7 1996-12-21 17:56:00 cg Exp $'
! !

!Example10 methodsFor:'initialize / release'!

initialize
    "setup view"

    |menu scrollingView|

    super initialize.

    self label:'Tutorial Example 10'.

    menu := PullDownMenu in:self.
    menu labels:#('file' 'edit').

    menu at:'file'
	    putLabels:#('new' 
			'open ..' 
			'-' 
			'quit')
	    selectors:#(doNew doOpen 
			nil destroy)
	     receiver:self.

    menu at:'edit'
	    putLabels:#('copy' 
			'cut' 
			'paste')
	    selectors:#(copySelection cut paste)
	     receiver:self.

    scrollingView := ScrollableView for:EditTextView in:self.
    scrollingView origin:(0 @ menu height)
		  extent:[width @ (height - menu height)].
    myView := scrollingView scrolledView.

    myView contents:'
This example shows some more user interface components.

It allows editing, both via a pop-up menu (right button) and via
a pull-down menu (''edit''-menu). 

The most interesting new thing here is the open panel (a
FileSelectionBox) which pops up when then ''open''-entry in the
''file'' menu is selected.

Finish this example by selecting ''quit'' in the ''file''-menu.'

   "Example10 start"

! !

!Example10 methodsFor:'release'!

destroy
    "destroy boxes when this view is destroyed"
    openBox notNil ifTrue:[
	openBox destroy
    ].
    super destroy
! !

!Example10 methodsFor:'user interaction'!

doNew
    myView contents:nil
!


openFile:aFileName
    |stream text|

    stream := FileStream readonlyFileNamed:aFileName.
    stream isNil ifTrue:[
	self notify:('cannot open ' , aFileName).
	^ self
    ].
    text := stream contents.
    myView contents:text
!

doOpen

    "create the open-box when we come here the first time ..."
    openBox isNil ifTrue:[
	openBox := FileSelectionBox new.
	openBox action:[:string | self openFile:string].
	openBox title:'opening file:'.
	openBox okText:'open'
    ].
    "and launch it"
    openBox showAtPointer
!

copySelection
    myView copySelection
!

cut
    myView cut
!

paste
    myView paste
! !
