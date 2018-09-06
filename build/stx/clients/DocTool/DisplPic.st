"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

DisplayObject subclass:#DisplayPicture
	 instanceVariableNames:'picture form'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'Views-Document'
!

!DisplayPicture class methodsFor:'instance creation'!

fromFile:aFileName
    ^ self new fromFile:aFileName
!

from:anObject
    ^ self new from:anObject
! !

!DisplayPicture methodsFor:'accessing'!

origin:aPoint
    frame := Rectangle origin:aPoint corner:aPoint.
    self recomputeFrame
! !

!DisplayPicture methodsFor:'private'!

recomputeFrame
    |origin extent w h|

    frame isNil ifTrue:[^ self].
    origin := frame origin.
    origin isNil ifTrue:[^ self].
    picture isNil ifTrue:[^ self].
    w := picture width.
    h := picture height.
    extent := w @ h.
    frame := Rectangle origin:origin extent:extent
!

fromFile:aFileName
    picture := Image fromFile:aFileName.
    picture notNil ifTrue:[
	self recomputeFrame.
	^ self
    ].
    ^ nil
!

from:anObject
    picture := anObject.
    picture notNil ifTrue:[
	self recomputeFrame.
	^ self
    ].
    ^ nil
! !

!DisplayPicture methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    |xpos ypos origin display oldFg oldBg|

    display := aGC device.
    form notNil ifTrue:[
	(form device ~~ display) ifTrue:[
	    form := nil
	]
    ].
    form isNil ifTrue:[
	form := picture asFormOn:display
    ].
    form notNil ifTrue:[
	origin := frame origin.
	xpos := origin x + anOffset x.
	ypos := origin y + anOffset y.
	oldFg := aGC paint.
	oldBg := aGC backgroundPaint.
	(picture photometric == #blackIs0) ifTrue:[
	    aGC paint:Color white on:Color black.
	] ifFalse:[
	    aGC paint:Color black on:Color white.
	].
	aGC displayOpaqueForm:form x:xpos y:ypos.
	aGC paint:oldFg on:oldBg.
    ]
! !

!DisplayPicture methodsFor:'events'!

doubleClick
    "some picture has been doubleclicked on"
    ^ self
! !
