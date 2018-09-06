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



"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: Demos }"

StandardSystemView subclass:#ColorScaleDemo
	instanceVariableNames:'nGrey reds greens blues greys'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

!ColorScaleDemo class methodsFor:'documentation'!

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
 demonstrates use of colors - notice that the window looks good
 on monochrome and limited greyscale displays (colors will
 be automatically dithered).


 [see also:]
    GreyScaleDemo
    Color

 [start with:]
    ColorScaleDemo start

 [author:]
    Claus Gittinger - written summer 92
"
! !

!ColorScaleDemo class methodsFor:'startup'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ true

    "Created: / 7.7.1998 / 17:37:17 / cg"
!

open
    self start:13

    "Created: / 7.7.1998 / 17:38:04 / cg"
!

start
    self start:13
!

start:nGrey
    |aDemo|

    aDemo := self 
		label:'ColorScales'
		icon:(Form fromFile:'ColorScales.xbm' resolution:100)
		minExtent:(300 @ 200)
		maxExtent:(1000 @ 200).

    aDemo extent:(Display width // 2 @ 200).
    aDemo nGrey:nGrey.
    aDemo font:(Font family:'helvetica'
		       face:'bold' 
		      style:'roman'
		       size:14).
    aDemo open.
    ^ aDemo

    "ColorScaleDemo start:13"
    "MessageTally spyOn:[
ColorScaleDemo start:256]"
! !

!ColorScaleDemo methodsFor:'accessing'!

nGrey:aNumber
    |delta percent|

    nGrey := aNumber.

    reds := Array new:nGrey.
    greens := Array new:nGrey.
    blues := Array new:nGrey.
    greys := Array new:nGrey.
    delta := (100 / (nGrey - 1)) asFloat.
    percent := 0.0.
    1 to:nGrey do:[:index |
	reds at:index put:((Color red:percent green:0 blue:0) on:device).
	greens at:index put:((Color red:0 green:percent blue:0) on:device).
	blues at:index put:((Color red:0 green:0 blue:percent) on:device).
	greys at:index put:((Color grey:percent) on:device).
	percent := percent + delta
    ]
! !

!ColorScaleDemo methodsFor:'events'!

redraw
    "pretty easy; mostly complicated by rounding so that cutoff does
     not accumulate"

    |x xRounded y yRounded w wRounded h hRounded delta percent string p|

    font := font on:device.
    delta := 100 / (nGrey - 1).
    x := 0.0.
    percent := 0.
    w := width / nGrey.
    h := height / 4.
    1 to:nGrey do:[:index |
	y := 0.0.
	xRounded := x rounded asInteger.
	wRounded := (x + w) rounded asInteger - x rounded asInteger.
	yRounded := y rounded asInteger.
	hRounded := (y + h) rounded asInteger - y rounded asInteger.
	self paint:(reds at:index).
	self fillRectangleX:xRounded y:yRounded width:wRounded height:hRounded.

	y := y + h.
	yRounded := y rounded asInteger.
	hRounded := (y + h) rounded asInteger - y rounded asInteger.
	self paint:(greens at:index).
	self fillRectangleX:xRounded y:yRounded width:wRounded height:hRounded.

	y := y + h.
	yRounded := y rounded asInteger.
	hRounded := (y + h) rounded asInteger - y rounded asInteger.
	self paint:(blues at:index).
	self fillRectangleX:xRounded y:yRounded width:wRounded height:hRounded.

	y := y + h.
	yRounded := y rounded asInteger.
	hRounded := (y + h) rounded asInteger - y rounded asInteger.
	self paint:(greys at:index).
	self fillRectangleX:xRounded y:yRounded width:wRounded height:hRounded.

	p := percent rounded asInteger.
	string := p printString , '%'.

	(font widthOf:string) + 5 > wRounded ifTrue:[
	    string := p printString
	].
	(font widthOf:string) + 5 > wRounded ifFalse:[
	    (p > 60) ifTrue:[
		self paint:Black
	    ] ifFalse:[
		self paint:White
	    ].

	    self displayString:string x:(xRounded + 5) y:20.
	    self paint:Black.
	    self displayRectangleX:xRounded y:0 width:wRounded height:height
	].
	percent := (percent + delta).
	x := x + w
    ].
    self paint:White.
    self displayString:'red'   x:5 y:(20 + font ascent).
    self displayString:'green' x:5 y:(20 + (height // 4) + font ascent).
    self displayString:'blue'  x:5 y:(20 + (height // 4 * 2) + font ascent).
    self displayString:'grey'  x:5 y:(20 + (height // 4 * 3) + font ascent)

!

sizeChanged:how
    super sizeChanged:how.
    self redraw.
! !

!ColorScaleDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ColorScales.st,v 1.9 2002-10-30 13:30:11 cg Exp $'
! !
