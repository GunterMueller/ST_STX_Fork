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




"{ Package: 'stx:clients/DirView' }"

"{ NameSpace: Demos }"

DisplayObject subclass:#DirectoryViewObject
	instanceVariableNames:'name font origin activeAction passiveAction icon mask pathName'
	classVariableNames:'All0Color All1Color'
	poolDictionaries:''
	category:'demos-DirectoryView'
!

!DirectoryViewObject class methodsFor:'documentation'!

copyright
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



! !

!DirectoryViewObject class methodsFor:'initialization'!

initialize
    All0Color := Color colorId:0.
    All1Color := Color colorId:-1

    "DirectoryViewObject initialize"
! !

!DirectoryViewObject class methodsFor:'specification'!

dragOutline
    "if true, dragging is done by drawing outline only;
     if false, dragging is done by full draw (fast servers only)
     - can be redefined in subclasses"

    ^ true
!

iconFileBaseName
    ^ self name
!

iconFileName
    ^ self iconFileBaseName 
!

maskFileName
    ^ self iconFileBaseName , '_m'
!

new
    |newObject|
    newObject := super new.
    newObject initialize.
    ^ newObject
! !

!DirectoryViewObject methodsFor:'accessing'!

action:aBlock
    activeAction := aBlock
!

asDirectoryViewObject
    ^ self
!

computeBoundingBox
    |myWidth myHeight nameWidth nameHeight f|

    name isNil ifTrue:[
        nameWidth := nameHeight := 0
    ] ifFalse:[
        nameWidth := (f := font onDevice:Display) widthOf:name.
        nameHeight := f height.
    ].

    icon isNil ifTrue:[
        myWidth := nameWidth.
        myHeight := nameHeight
    ] ifFalse:[
        myWidth := (icon width) max: nameWidth.
        myHeight := icon height + 2 + nameHeight.
    ].
    frame := Rectangle origin:origin extent:(myWidth @ myHeight)

    "Created: 24.1.1997 / 16:51:36 / cg"
    "Modified: 28.3.1997 / 23:04:30 / cg"
!

font
    ^ font
!

font:aFont
    font := aFont
!

hasFixedSize
    ^ true
!

icon
    ^ icon
!

icon:aForm
    icon := aForm
!

icon:iconForm mask:maskForm
    icon := iconForm.
    mask := maskForm
!

mask
    ^ mask
!

mask:aForm
    mask := aForm
!

moveTo:newOrigin
    origin := newOrigin.
    self computeBoundingBox
!

name
    ^ name
!

name:aString
    name := aString
!

origin
    ^ origin
!

origin:aPoint
    origin := aPoint.
    self computeBoundingBox
!

pathName
    ^ pathName
!

pathName:aString
    pathName := aString.
    name := aString asFilename baseName
! !

!DirectoryViewObject methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    self drawIn:aGC offset:anOffset with:Color black and:Color white
!

drawIn:aGC offset:anOffset with:fg and:bg
    |picWidth picHeight textWidth
     topLeftX topLeftY myWidth picture mask
     fgColor bgColor leftOffs|

    All0Color := All0Color onDevice:(aGC device).
    All1Color := All1Color onDevice:(aGC device).

    fgColor := fg onDevice:aGC device.
    bgColor := bg onDevice:aGC device.

    picture := self icon.
    picture isNil ifTrue:[
        picWidth := 0.
        picHeight := 0
    ] ifFalse:[
        picWidth := picture width.
        picHeight := picture height + 2
    ].
    name isNil ifTrue:[
        textWidth := 0
    ] ifFalse:[
        font := font onDevice:aGC device.
        textWidth := font widthOf:name.
    ].

    mask := self mask.
    myWidth := picWidth max:textWidth.
    topLeftX := origin x + anOffset x.
    topLeftY := origin y + anOffset y.

    leftOffs := (myWidth - picWidth) // 2.

    picture notNil ifTrue:[
        mask notNil ifTrue:[
            "mask out first - then or in picture; if no mask,
             overpaint picture"

            "clear mask-bits to zero"
            aGC paint:All0Color on:All1Color.
            aGC function:#and.
            aGC displayOpaqueForm:mask
                               x:(topLeftX + leftOffs)
                               y:topLeftY.

            "draw mask-bits with bg-color"
            (bgColor colorId == 0) ifFalse:[
                aGC function:#or.
                aGC paint:bgColor on:All0Color.
                aGC displayOpaqueForm:mask
                               x:(topLeftX + leftOffs)
                               y:topLeftY
            ].

            "clear picture-bits to zero"
            aGC paint:All0Color on:All1Color.
            aGC function:#and.
            aGC displayOpaqueForm:picture
                               x:(topLeftX + leftOffs)
                               y:topLeftY.

            "draw picture-bits with fg-color"
            (fgColor colorId == 0) ifFalse:[
                aGC function:#or.
                aGC paint:fgColor on:All0Color.
                aGC displayOpaqueForm:picture
                               x:(topLeftX + leftOffs)
                               y:topLeftY
            ]
        ] ifFalse:[
            aGC paint:fgColor on:bgColor.
            picture mask notNil ifTrue:[
                aGC displayForm:picture
                              x:(topLeftX + leftOffs)
                              y:topLeftY
            ] ifFalse:[
                aGC displayOpaqueForm:picture
                                   x:(topLeftX + leftOffs)
                                   y:topLeftY
            ]
        ]
    ].

    aGC function:#copy.
    aGC paint:fgColor on:bgColor.

    "
     text is overpainted
    "
    name notNil ifTrue:[
        (textWidth < myWidth) ifTrue:[
            topLeftX := topLeftX + ((myWidth - textWidth) // 2)
        ].
        font := font onDevice:(aGC device).
        aGC font:font.
        aGC displayOpaqueString:name 
                             x:topLeftX
                             y:(topLeftY + picHeight + font ascent)
    ]

    "Modified: 28.3.1997 / 23:15:36 / cg"
!

drawOutlineIn:aGC offset:anOffset
    |picWidth picHeight textWidth
     topLeftX topLeftY myWidth picture leftOffs|

    picture := self icon.
    picture isNil ifTrue:[
        picWidth := 0.
        picHeight := 0
    ] ifFalse:[
        picWidth := picture width.
        picHeight := picture height + 2
    ].
    (font isNil or:[name isNil]) ifTrue:[
        textWidth := 0
    ] ifFalse:[
        font := font onDevice:(aGC device).
        textWidth := font widthOf:name.
    ].

    myWidth := picWidth max:textWidth.
    topLeftX := origin x + anOffset x.
    topLeftY := origin y + anOffset y.

    leftOffs := (myWidth - picWidth) // 2.
    icon notNil ifTrue:[
        aGC displayRectangle:(Rectangle
                                origin:(topLeftX + leftOffs) @ topLeftY
                                extent:picWidth @ picHeight)
    ].
    name notNil ifTrue:[
        (textWidth < myWidth) ifTrue:[
            topLeftX := topLeftX + ((myWidth - textWidth) // 2)
        ].
"this one draws the string:"
        aGC font:font.
        aGC displayString:name 
                          x:topLeftX
                          y:(topLeftY + picHeight + (font ascent))

"or, this one a rectangle around:"
"
        aGC displayRectangle:(Rectangle
                               origin:topLeftX @ (topLeftY + 2 + picHeight)
                               extent:textWidth @ textHeight)
"
    ]
!

drawQuickIn:aGC offset:anOffset
    "drawQuick does not mask out - can only be used if objects frame
     does not intersect any other"

    |picWidth picHeight textWidth
     topLeftX topLeftY myWidth picture|

    picture := self icon.
    picWidth := picture width.
    picHeight := picture height.
    textWidth := font widthOf:name.
    myWidth := picWidth max: textWidth.
    topLeftX := origin x + anOffset x.
    topLeftY := origin y + anOffset y.

    aGC displayOpaqueForm:picture
			x:(topLeftX + ((myWidth - picWidth) // 2))
			y:topLeftY.

    "
     text is overpainted
    "
    name notNil ifTrue:[
	(textWidth < myWidth) ifTrue:[
	    topLeftX := topLeftX + ((myWidth - textWidth) // 2)
	].
	font := font on:(aGC device).
	aGC font:font.
	aGC displayOpaqueString:name 
			      x:topLeftX
			      y:(topLeftY + picHeight + 2 + (font ascent))
   ]
!

drawSelectedIn:aGC offset:anOffset
    self drawIn:aGC offset:anOffset with:Color white
				       and:Color black
! !

!DirectoryViewObject methodsFor:'queries'!

iconIsHitBy:aPoint withDelta:delta
    "checks hit on icon"

    |org left right top bott px py d2 iw|

    icon isNil ifTrue:[^ false].

    "check icons frame"
    iw := icon width.
    org := frame origin.
    left := org x - delta + ((frame width - iw) // 2).

    px := aPoint x.
    (px < left) ifTrue:[^ false].

    d2 := delta * 2.
    right := left + iw + d2.
    (px > right) ifTrue:[^ false].

    top := org y - delta.
    py := aPoint y.
    (py < top) ifTrue:[^ false].

    bott := top + icon height + d2.
    (py > bott) ifTrue:[^ false].

    ^ true
!

intersects:aRectangle
    "check for icon or text"

    |iw ih ix|

    (frame intersects:aRectangle) ifFalse:[^ false].
    iw := icon width.
    ih := icon height.
    ix := frame origin x + ((frame width - iw) // 2).
    ((Rectangle origin:(ix @ frame origin y)
		extent:(iw @ ih)) intersects:aRectangle) ifTrue:[^ true].

    ^ false
!

isHitBy:aPoint withDelta:delta
    "separate checks on picture frame and file-name frame"

    "check overall boundary first"
    (super isHitBy:aPoint withDelta:delta) ifFalse:[^ false].

    "check icons frame"
    (self iconIsHitBy:aPoint withDelta:delta) ifTrue:[^ true].

    "check labels frame"
    (self labelIsHitBy:aPoint withDelta:delta) ifTrue:[^ true].

    ^ false
!

labelIsHitBy:aPoint withDelta:delta
    "checks hit on label"

    |org top bott py iconHeight|

    "check icons frame"
    org := frame origin.

    icon isNil ifTrue:[
	iconHeight := 0
    ] ifFalse:[
	iconHeight := icon height
    ].

    top := org y + iconHeight + 2 - delta.
    py := aPoint y.
    (py < top) ifTrue:[^ false].

    bott := top + font height + (delta * 2).
    (py > bott) ifTrue:[^ false].

    ^ true
! !

!DirectoryViewObject methodsFor:'storing'!

storeOn:aStream
    aStream nextPut:$(.
    aStream nextPutAll:(self class name).
    aStream nextPutAll:' new origin:'.
    origin storeOn:aStream.
    aStream nextPutAll:' name:'.
    name storeOn:aStream.
    aStream nextPut:$)
! !

!DirectoryViewObject methodsFor:'user interaction'!

activate
    activeAction notNil ifTrue:[
	activeAction value:pathName
    ]
! !

!DirectoryViewObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DirView/DirVObj.st,v 1.16 2002-12-09 10:11:00 cg Exp $'
! !

DirectoryViewObject initialize!
