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

StandardSystemView subclass:#Example9
	 instanceVariableNames:'menu myView'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Views-Tutorial'
!

!Example9 class methodsFor:'documentation'!

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
    Tutorial example - a complete setup for a scrollable view with a menu.
    The menu is NOT nationalized using resources.

    [author:]
	Claus Gittinger (spring 92)

    [start with:]
	Example9 start
"
!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Example9.st,v 1.7 1996-12-21 17:56:09 cg Exp $'
! !

!Example9 methodsFor:'initialize / release'!

initialize
    "setup view"

    |menu scrollingView|

    super initialize.

    self label:'Tutorial Example 9'.

    menu := PullDownMenu in:self.
    menu labels:#('Datei' 'Bearbeiten').

    menu at:'Datei'
	    putLabels:#('neu' 
			'öffnen ..' 
			'-' 
			'sichern' 
			'sichern unter ...' 
			'-' 
			'drucken'
			'-' 
			'beenden')
	    selectors:#(doNew doOpen nil 
			doSave doSaveAs nil doPrint
			nil destroy)
	     receiver:self.

    menu at:'Bearbeiten'
	    putLabels:#('kopieren' 
			'löschen' 
			'einsetzen')
	    selectors:#(copySelection cutSelection pasteBuffer)
	     receiver:self.

    scrollingView := HVScrollableView for:View in:self.
    scrollingView origin:(0 @ menu height)
		  extent:[width @ (height - menu height)].
    myView := scrollingView scrolledView

   "Example9 start"

! !

!Example9 methodsFor:'user interaction'!

doNew
    Transcript showCR:'new'
!

doOpen
    |box|

    box := FileSelectionBox new.
    box title:'Read file:'.
    box action:[:fileName | Transcript showCR:'open ' , fileName].
    box okText:'read'.
    box show.
!

doSave
    Transcript showCR:'save'
!

doSaveAs
    |box|

    box := FileSaveBox new.
    box title:'Save as:'.
    box action:[:fileName | Transcript showCR:'save as ' , fileName , ' (not really)'].
    box show.
!

doPrint
    Transcript showCR:'print'
!

copySelection
    Transcript showCR:'copy'
!

cutSelection
    Transcript showCR:'cut'
!

pasteBuffer
    Transcript showCR:'paste'
! !
