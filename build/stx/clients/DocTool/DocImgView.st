"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

DocumentView subclass:#DocumentImageView
	 instanceVariableNames:'mag image'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'Views-Document'
!

!DocumentImageView class methodsFor:'menu definition'!

initMenu:menu for:aView
    |resources|

    resources := self classResources.
    menu labels:(resources array:#(
				  'DOCVIEW_FILE' 
				  'DOCVIEW_EDIT' 
				  'DOCVIEW_FORM' 
				  'DOCVIEW_EXTRA'
				  )).

    menu at:1
	    putLabels:(resources array:#(
			'DOCVIEW_NEW' 
			'DOCVIEW_OPEN' 
			'-' 
			'DOCVIEW_SAVE' 
			'DOCVIEW_SAVE_AS' 
			'-' 
			'DOCVIEW_PRINT'
			'-' 
			'DOCVIEW_FINISH'))
	    selectors:#(doNew doOpen nil 
			doSave doSaveAs nil doPrint
			nil doQuit)
	     receiver:aView.

    menu at:2
	    putLabels:(resources array:#(
			'DOCVIEW_COPY' 
			'DOCVIEW_CUT' 
			'DOCVIEW_PASTE'))
	    selectors:#(copySelection deleteSelection pasteBuffer)
	     receiver:aView.

    menu at:3
	    putLabels:(resources array:#(
			'DOCVIEW_SHOW_MARGINS' 
			'DOCVIEW_SHOW_GRID'
			'-'
			'DOCVIEW_HIDE_RULER'))
	    selectors:#(showMargins showGrid nil scaleOff)
	     receiver:aView.

    menu at:4
	    putLabels:(resources array:#(
			'DOCVIEW_MAGNIFY' 
		       ))
	    selectors:#(magnifyImage)
	     receiver:aView.
! !

!DocumentImageView class methodsFor:'startup'!

startOn:anObject
    |top frame docView menu label|

    (anObject isKindOf:Image) ifFalse:[
	^ super startOn:anObject
    ].
        
    label := 'unnamed'.
    top := StandardSystemView
		 label:label
		  icon:(Form fromFile:'DocView.icn' resolution:100)
	     minExtent:(100 @ 100).

    menu := PullDownMenu in:top.

    frame := HVScrollableView for:self in:top.
    frame origin:[0 @ menu height]
	  extent:[top width @ (top height - menu height)].

    docView := frame scrolledView.
    self initMenu:menu for:docView.
    top realize.

    anObject notNil ifTrue:[
	docView fromImage:anObject
    ]

    "DocumentImageView startOn:(Image fromFile:'bitmaps/claus.gif')"
    "DocumentImageView startOn:((Image fromFile:'bitmaps/claus.gif') magnifyBy:2@2)"
! !

!DocumentImageView methodsFor:'initialization'!

initialize
    super initialize.
    mag := 1@1
! !

!DocumentImageView methodsFor:'user interaction'!

magnifyImage
    mag := mag * 2.
    self fromImage:(image magnifyBy:mag)
! !

!DocumentImageView methodsFor:'accessing'!

fromImage:anImage
    "take contents from an image"

    |aStream isPicture newObject|

    image := anImage.
    self removeAll.
    newObject := DisplayPicture from:anImage.
    newObject notNil ifTrue:[
	newObject origin:(0 @ 0).
	self addWithoutRedraw:newObject
    ].
    self contentsChanged.
    self shown ifTrue:[
	self redraw
    ]
! !
