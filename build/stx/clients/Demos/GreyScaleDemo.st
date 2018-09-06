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

StandardSystemView subclass:#GreyScaleDemo
	instanceVariableNames:'nGrey colors'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

!GreyScaleDemo class methodsFor:'documentation'!

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
    ColorScaleDemo
    Color

 [start with:]
    GreyScaleDemo start

 [author:]
    Claus Gittinger - written summer 92
"
! !

!GreyScaleDemo class methodsFor:'startup'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ true

    "Created: / 7.7.1998 / 17:33:49 / cg"
!

open
    self start:13

    "
     GreyScaleDemo open
    "

    "Modified: / 7.7.1998 / 17:33:00 / cg"
!

start
    self start:13

    "
     GreyScaleDemo start
    "
!

start:nGrey
    |aDemo|

    aDemo := self 
                label:'GreyScales'
                icon:(Form fromFile:'GreyScales.xbm' resolution:100)
                minExtent:(300 @ 50)
                maxExtent:(1000 @ 50).

    aDemo extent:(Display width // 2 @ 50).
    aDemo nGrey:nGrey.
    aDemo font:(Font family:'helvetica'
                       face:'bold' 
                      style:'roman'
                       size:14).
    aDemo open.
    ^ aDemo

    "
     GreyScaleDemo start:13
     GreyScaleDemo start:25
     GreyScaleDemo start:100
     GreyScaleDemo start:200
    "
! !

!GreyScaleDemo methodsFor:'accessing'!

nGrey:aNumber
    |delta percent|

    nGrey := aNumber.

    colors := Array new:nGrey.
    delta := 100 / (nGrey - 1).
    percent := 0.
    1 to:nGrey do:[:index |
	colors at:index put:(Color grey:percent).
	percent := percent + delta
    ]
! !

!GreyScaleDemo methodsFor:'events'!

redraw
    "pretty easy; mostly complicated by rounding so that cutoff does
     not accumulate"

    |x xRounded w wRounded delta percent string|

    shown ifFalse:[^ self].

    font := font on:device.
    delta := 100 / (nGrey - 1).
    x := 0.0.
    percent := 0.
    w := width / nGrey.
    1 to:nGrey do:[:index |
	xRounded := x rounded asInteger.
	wRounded := (x + w) rounded asInteger - x rounded asInteger.
	self paint:(colors at:index).
	self fillRectangleX:xRounded y:0 width:wRounded height:height.

	string := percent rounded asInteger printString , '%'.
	(font widthOf:string) + 5 > wRounded ifTrue:[
	    string := percent rounded asInteger printString
	].
	(font widthOf:string) + 5 > wRounded ifFalse:[
	    (percent > 50) ifTrue:[
		self paint:Black
	    ] ifFalse:[
		self paint:White
	    ].

	    self displayString:string x:(xRounded + 5) y:20.
	    self paint:Black.
	    self displayRectangleX:xRounded y:0 width:wRounded height:height
	].
	percent := percent + delta.
	x := x + w
    ]
!

sizeChanged:how
    super sizeChanged:how.
    self redraw.
! !

!GreyScaleDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GreyScaleDemo.st,v 1.11 2002-10-30 13:30:19 cg Exp $'
! !
