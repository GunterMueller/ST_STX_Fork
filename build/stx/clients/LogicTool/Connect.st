"
 COPYRIGHT (c) 1989 by Claus Gittinger
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


"{ Package: 'stx:clients/LogicTool' }"

"{ NameSpace: Demos }"

DisplayObject subclass:#Connection
	instanceVariableNames:'srcGate dstGate srcPinNr dstPinNr'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-LogicTool-Objects'
!

!Connection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    connections

    [author:]
        Claus Gittinger (summer 89)
"




! !

!Connection class methodsFor:'instance creation'!

from:gate1 pin:pin1Nr to:gate2 pin:pin2Nr
    ^ (self basicNew) from:gate1 pin:pin1Nr
			to:gate2 pin:pin2Nr
! !

!Connection methodsFor:'accessing'!

dstGate
    ^ dstGate
!

dstPinNr
    ^ dstPinNr
!

font:aFont
    ^ self

    "Created: 10.4.1996 / 22:55:42 / cg"
!

from:gate1 pin:pin1Nr to:gate2 pin:pin2Nr
    srcGate := gate1.
    dstGate := gate2.
    srcPinNr := pin1Nr.
    dstPinNr := pin2Nr.
    self computeBoundingBox
!

fromNamedGate:gate1 pin:pin1Nr toNamedGate:gate2 pin:pin2Nr
    srcGate := gate1.
    dstGate := gate2.
    srcPinNr := pin1Nr.
    dstPinNr := pin2Nr
!

srcGate
    ^ srcGate
!

srcGate:gate1 dstGate:gate2
    srcGate := gate1.
    dstGate := gate2.
    self computeBoundingBox
!

srcPinNr
    ^ srcPinNr
! !

!Connection methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    aGC paint:(Color black).
    aGC lineWidth:1.
    aGC displayLineFrom:(self srcPosition + anOffset) 
		     to:(self dstPosition + anOffset).
    aGC lineWidth:0.
!

drawSelectedIn:aGC offset:anOffset
    self drawIn:aGC offset:anOffset
! !

!Connection methodsFor:'private'!

computeBoundingBox
    |origin corner orgY orgX cornX cornY left right top bot|

    srcGate notNil ifTrue:[
        dstGate notNil ifTrue:[
            origin := self findOrigin.
            corner := self findCorner.
            orgY := origin y.
            orgX := origin x.
            cornY := corner y.
            cornX := corner x.
            top := (orgY min:cornY) - 1.
            bot := (orgY max:cornY) + 1.
            left := (orgX min:cornX) - 1.
            right := (orgX max:cornX) + 1.
            frame notNil ifTrue:[
                top = frame top ifTrue:[
                    left = frame left ifTrue:[
                        bot = frame bottom ifTrue:[
                            right = frame right ifTrue:[
                                ^ frame
                            ]
                        ]
                    ]
                ]
            ].
            frame := Rectangle left:left top:top right:right bottom:bot
        ]
    ].
    ^ frame

    "Modified: 10.4.1996 / 22:43:50 / cg"
!

dstPosition
    ^ (dstGate inputPinLocation:dstPinNr) + (0.4@0.4)
!

findCorner
    ^ (srcGate outputPinLocation:srcPinNr) 
      max:(dstGate inputPinLocation:dstPinNr)
!

findOrigin
    ^ (srcGate outputPinLocation:srcPinNr) 
      min:(dstGate inputPinLocation:dstPinNr)
!

srcPosition
    ^ (srcGate outputPinLocation:srcPinNr) + (0.4@0.4)
! !

!Connection methodsFor:'signals'!

propagate
    dstGate input:dstPinNr value:(srcGate output:srcPinNr)
! !

!Connection methodsFor:'storing'!

storeOn:aStream
    aStream nextPut:$(.
    aStream nextPutAll:(self class name).
    aStream nextPutAll:' new'.
    aStream nextPutAll:' fromNamedGate:'. (srcGate name) storeOn:aStream.
    aStream nextPutAll:' pin:'. srcPinNr storeOn:aStream.
    aStream nextPutAll:' toNamedGate:'. (dstGate name) storeOn:aStream.
    aStream nextPutAll:' pin:'. dstPinNr storeOn:aStream.
    aStream nextPut:$)
! !

!Connection methodsFor:'testing'!

canBeMoved
    "no - connections are moved when gates are moved"

    ^ false
!

isHitBy:hitPoint withDelta:hitDelta
    "return true, if connection is hit by point"

    |originX originY cornerX cornerY
     p1 p2 hx hy dx dy expy expx|

    "quick boundary check"
    (super isHitBy:hitPoint withDelta:hitDelta) ifFalse:[
	^ false
    ].

    p1 := self findOrigin.
    p2 := self findCorner.

    originX := p1 x.
    originY := p1 y.
    cornerX := p2 x.
    cornerY := p2 y.

    "look, if hitpoint is on line"
    dx := cornerX - originX. "deltaX"
    dy := cornerY - originY. "deltaY"

    "if its a horizontal/vertical line - we're done"
    (dx == 0) ifTrue:[^ true].
    (dy == 0) ifTrue:[^ true].

    hx := hitPoint x - originX.
    hy := hitPoint y - originY.

    expy := (hx * dy) // dx.   "expected y for given hx"
    expx := (hy * dx) // dy.   "expected x for given hy"

    "for the given x, then the point on the line is x/expy.
     now, look if hitpoint is within a circle with radius delta
     around this point
    "
    hy := hy - expy.
    hx := hx - expx.
    (hy * hy) <= (hitDelta * hitDelta) ifTrue:[^ true].
    (hx * hx) <= (hitDelta * hitDelta) ifTrue:[^ true].

    ^ false

! !

!Connection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/LogicTool/Connect.st,v 1.9 2000-12-28 14:55:08 cg Exp $'
! !
