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

StandardSystemView subclass:#Example11
	 instanceVariableNames:'menu myView fileBox saveBox currentFileName'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Views-Tutorial'
!

!Example11 class methodsFor:'documentation'!

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
    The open and save functions have been implemented.
    All texts have been internationalized.

    This is a full blown editor (in one page of code) !!

    [author:]
	Claus Gittinger (spring 92)

    [start with:]
	Example11 start
"
!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Example11.st,v 1.7 1996-12-21 17:56:01 cg Exp $'
! !

!Example11 methodsFor:'initialize / release'!

initialize
    "setup view"

    |menu scrollingView|

    super initialize.

    self label:'Tutorial Example 11'.

    menu := PullDownMenu in:self.
    menu labels:(resources array:#('file' 'edit')).

    menu at:1
	    putLabels:(resources array:#('new'
					 'open ...'
					 '-'
					 'save'
					 'save as ...'
					 '-'
					 'quit')) 
	    selectors:#(doNew 
			doOpen
			nil 
			doSave
			doSaveAs
			nil 
			destroy)
	     receiver:self.

    menu at:2
	    putLabels:(resources array:#('copy' 'cut' 'paste')) 
	    selectors:#(copySelection cut paste)
	     receiver:self.

    scrollingView := ScrollableView for:EditTextView in:self.
    scrollingView origin:(0 @ menu height)
		  extent:[width @ (height - menu height)].
    myView := scrollingView scrolledView.

    myView contents:'
This example shows some more user interface components.

It allows editing, both via a pop-up menu (right button) and via
a pull-down menu (''edit''-menu). And there is a possibility to
save the text after it has been edited.

The very interesting thing here is that all user-interface texts
have been internationalized.
(open file ''Smalltalk.rs'' to see how such resources are defined.)

Finish this example by selecting ''quit'' in the ''file''-menu.'

   "Example11 start"

! !

!Example11 methodsFor:'release'!

destroy
    "destroy box when this view is destroyed"
    fileBox notNil ifTrue:[fileBox destroy. fileBox := nil].
    saveBox notNil ifTrue:[saveBox destroy. saveBox := nil].
    super destroy
!

openFile:aFileName
    |stream text|

    stream := FileStream readonlyFileNamed:aFileName.
    stream isNil ifTrue:[
	self notify:(resources string:'cannot open %1' with:aFileName).
	^ self
    ].
    text := stream contents.
    stream close.

    myView contents:text.
    currentFileName := aFileName
!

saveFile:aFileName
    |stream text|

    stream := FileStream newFileNamed:aFileName.
    stream isNil ifTrue:[
	self notify:(resources string:'cannot create %1' with:aFileName).
	^ self
    ].
    stream nextPutAll:(myView contents).
    stream close
! !

!Example11 methodsFor:'user interaction'!

doNew
    currentFileName := nil.
    myView contents:nil
!

doOpen
    fileBox isNil ifTrue:[
	fileBox := FileSelectionBox new
    ].
    fileBox action:[:string | self openFile:string].
    fileBox title:(resources string:'open file').
    fileBox okText:(resources string:'open').
    fileBox showAtPointer
!

doSave
    currentFileName isNil ifTrue:[
	^ self doSaveAs
    ].
    self saveFile:currentFileName
!

doSaveAs
    saveBox isNil ifTrue:[
	saveBox := FileSaveBox new
    ].
    saveBox action:[:string | self saveFile:string].
    saveBox title:(resources string:'save contents into:').
    saveBox okText:(resources string:'save').
    saveBox showAtPointer
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
