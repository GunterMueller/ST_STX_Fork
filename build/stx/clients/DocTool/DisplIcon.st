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

DisplayObject subclass:#DisplayIcon
	 instanceVariableNames:'fileName picture icon'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'Views-Document'
!

!DisplayIcon class methodsFor:'instance creation'!

forFile:aFileName
    ^ self new forFile:aFileName
! !

!DisplayIcon methodsFor:'private'!

forFile:aFileName
    |f baseName root|

    fileName := aFileName.
    f := aFileName.
    (f endsWith:'.c') ifTrue:[
	icon := Form fromFile:'C-File.48' resolution:100.
	icon notNil ifTrue:[^ self]
    ].
    (f endsWith:'.m') ifTrue:[
	icon := Form fromFile:'C-File.48' resolution:100.
	icon notNil ifTrue:[^ self]
    ].

    (f endsWith:'.vox') ifTrue:[
	f := 'voice.tiff'
    ].
    (f endsWith:'.VOX') ifTrue:[
	f := 'voice.tiff'
    ].
    (f endsWith:'.fax') ifTrue:[
	f := 'fax.tiff'
    ].
    (f endsWith:'.FAX') ifTrue:[
	f := 'fax.tiff'
    ].
    (f endsWith:'.wn') ifTrue:[
	f := 'wn.tiff'
    ].
    (f endsWith:'.WN') ifTrue:[
	f := 'wn.tiff'
    ].

    baseName := OperatingSystem baseNameOf:f.
    picture := Image fromFile:baseName.
    picture notNil ifTrue:[
	self recomputeFrame.
	^ self
    ].
    icon isNil ifTrue:[
	icon := Form fromFile:baseName resolution:100.
	icon isNil ifTrue:[
	    root := FileDirectory rootDirectory.
	    (root isDirectory:f) ifTrue:[
		icon := Form fromFile:'DirObj.48' resolution:100
	    ].
	    icon isNil ifTrue:[
		(root isExecutable:f) ifTrue:[
		    icon := Form fromFile:'ExecObj.48' resolution:100
		]
	    ].
	    icon isNil ifTrue:[
		icon := Form fromFile:'FileObj.48' resolution:100
	    ]
	]
    ].
    icon notNil ifTrue:[
	self recomputeFrame
    ].
    ^ self
!

recomputeFrame
    |origin extent w h|

    frame isNil ifTrue:[^ self].
    origin := frame origin.
    origin isNil ifTrue:[^ self].
    picture notNil ifTrue:[
	w := picture width.
	h := picture height
    ] ifFalse:[
	icon notNil ifTrue:[
	    w := icon width.
	    h := icon height
	] ifFalse:[
	    ^ self
	]
    ].
    extent := w @ h.
    frame := Rectangle origin:origin extent:extent
! !

!DisplayIcon methodsFor:'accessing'!

origin:aPoint
    frame := Rectangle origin:aPoint corner:aPoint.
    self recomputeFrame
! !

!DisplayIcon methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    |xpos ypos origin device oldFg oldBg|

    device := aGC device.

    picture notNil ifTrue:[
	icon notNil ifTrue:[
	    (icon device ~~ device) ifTrue:[
		icon := nil
	    ]
	].
	icon isNil ifTrue:[
	    icon := picture asFormOn:device
	].
	icon notNil ifTrue:[
	    origin := frame origin.
	    xpos := origin x + anOffset x.
	    ypos := origin y + anOffset y.
	    oldFg := aGC foreground.
	    oldBg := aGC background.
	    (picture photometric == #blackIs0) ifTrue:[
		aGC foreground:(Color white) background:(Color black).
	    ] ifFalse:[
		aGC foreground:(Color black) background:(Color white).
	    ].
	    oldFg := aGC paint.
	    oldBg := aGC backgroundPaint.
	    (picture photometric == #blackIs0) ifTrue:[
		aGC paint:Color white on:Color black.
	    ] ifFalse:[
		aGC paint:Color black on:Color white.
	    ].
	    aGC displayOpaqueForm:icon x:xpos y:ypos.
	    aGC paint:oldFg on:oldBg.
	].
	^ self
    ].

    icon notNil ifTrue:[
	origin := frame origin.
	xpos := origin x + anOffset x.
	ypos := origin y + anOffset y.
	aGC displayOpaqueForm:icon x:xpos y:ypos
    ]
! !

!DisplayIcon methodsFor:'events'!

doubleClick
    "some icon has been doubleclicked on - open up a documentView for it"

    DocumentView startOn:fileName
! !

