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




"{ NameSpace: Demos }"

DisplayObject subclass:#HostIcon
	instanceVariableNames:'origin icon host font'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-ObjectView'
!

!HostIcon class methodsFor:'documentation'!

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



!

documentation
"
    example of a simple object to be displayed
    by an ObjectView (or -alike). See more in the HostView class.

    [author:]
        Claus Gittinger

    [see also:]
        ObjectView DrawView HostView
        DisplayObject DrawObject LogicObject
"
! !

!HostIcon class methodsFor:'instance creation'!

forHost:aHostObject
    ^ self forHost:aHostObject icon:(self defaultIcon).
!

forHost:aHostObject icon:anImage
    |newHostIcon|

    newHostIcon := super new.
    newHostIcon host:aHostObject icon:anImage.
    ^ newHostIcon
! !

!HostIcon class methodsFor:'specification'!

defaultIcon
    ^ Image fromFile:'/usr/include/X11/bitmaps/xterm.xbm'
!

dragOutline
    "if true, dragging is done by drawing outline only;
     if false, dragging is done by full draw (fast servers only)
     - can be redefined in subclasses"

    ^ true
! !

!HostIcon methodsFor:'accessing'!

computeBoundingBoxFor:aDevice
    |icon iconWidth iconHeight textWidth textHeight myWidth myHeight hostName|

    icon := self icon.
    iconWidth := icon width.
    iconHeight := icon height.

    textWidth := 0.
    textHeight := 0.
    host notNil ifTrue:[
        font isNil ifTrue:[
            font := View defaultFont.
        ].
        font := font on:aDevice.
        host isString ifTrue:[
            hostName := host
        ] ifFalse:[
            hostName := host hostName
        ].
        textWidth := font widthOf:hostName.
        textHeight := font height
    ].
    myWidth := iconWidth max:textWidth.
    myHeight := iconHeight + 2 + textHeight.
    frame := Rectangle origin:origin extent:(myWidth @ myHeight)
!

host:aHostObject icon:anImage
    host := aHostObject.
    icon := anImage.
!

icon
    ^ icon
!

origin:aPoint
    origin := aPoint.
    self computeBoundingBoxFor:Display.
! !

!HostIcon methodsFor:'drawing'!

doDrawIn:aGC offset:anOffset
    |icon x y hostName|

    icon := self icon.
    x := origin x + anOffset x.
    y := origin y + anOffset y.
    aGC clearRectangleX:x y:y width:(frame width) height:(frame height).
    aGC displayOpaqueForm:icon x:x y:y.

    host notNil ifTrue:[
        font := font on:aGC device.
        host isString ifTrue:[
            hostName := host
        ] ifFalse:[
            hostName := host hostName
        ].
        aGC displayOpaqueString:hostName x:x y:(y + icon height + font ascent)
    ]
!

drawIn:aGC
    self drawIn:aGC offset:0@0
!

drawIn:aGC offset:anOffset
    aGC paint:(Color black) on:(Color white).
    self doDrawIn:aGC offset:anOffset
!

drawSelectedIn:aGC
    self drawSelectedIn:aGC offset:0@0
!

drawSelectedIn:aGC offset:anOffset
    "draw the receiver highlighted - this is usually redefined"

    aGC device hasColors ifTrue:[
	aGC paint:(Color red:100 green:0 blue:0).
	self doDrawIn:aGC offset:anOffset
    ] ifFalse:[
	self drawIn:aGC offset:anOffset.
	self drawOutlineIn:aGC offset:anOffset
    ]
! !

!HostIcon class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/HostIcon.st,v 1.5 1997-01-24 17:10:40 cg Exp $'
! !
