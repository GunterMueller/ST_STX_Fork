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




"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#SliderDemo1
	instanceVariableNames:'sliderRed sliderGreen sliderBlue label1 label2 label3 color
		colorForm colorLabel'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Views'
!

!SliderDemo1 class methodsFor:'documentation'!

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
    demonstrates use of sliders and colors -

    (Notice, that there are other demo-classes for sliders
     'RGBSlider', 'HLSSlider', 'SliderBox' etc - which may offer exactly
     the functionality you need for your application)

    [start with:]
        SliderDemo1 start

    [author:]
        Claus Gittinger - written summer 92

    [see also:]
        Slider SliderDemo2 SliderDemo3 SliderDemo4
        Color
"

! !

!SliderDemo1 class methodsFor:'startup'!

start
    |aDemo|

    aDemo := self 
                label:'SliderDemo1'
                icon:(Image fromFile:'SliderDemo.xbm' resolution:100)
                minExtent:(160 @ 300)
                maxExtent:(1000 @ 1000).

    aDemo extent:(160 @ 300).
    aDemo open.
    ^ aDemo

    "SliderDemo1 start"
! !

!SliderDemo1 methodsFor:'initialization'!

initialize
    |l|

    super initialize.
    sliderRed := Slider origin:(20 @ 10) extent:(20 @ 150) in:self.
    sliderRed scrollAction:[:value | self sliderRed:value].

    sliderGreen := Slider origin:(70 @ 10) extent:(20 @ 150) in:self.
    sliderGreen scrollAction:[:value | self sliderGreen:value].

    sliderBlue := Slider origin:(120 @ 10) extent:(20 @ 150) in:self.
    sliderBlue scrollAction:[:value | self sliderBlue:value].

    l := Label origin:(10 @ 170) extent:[40 @ 20] in:self.
    l label:'r'.

    l := Label origin:(60 @ 170) extent:[40 @ 20] in:self.
    l label:'g'.

    l := Label origin:(110 @ 170) extent:[40 @ 20] in:self.
    l label:'b'.

    label1 := Label origin:(10 @ 200) extent:[40 @ 20] in:self.
    label1 level:-1.
    label1 label:'0'.

    label2 := Label origin:(60 @ 200) extent:[40 @ 20] in:self.
    label2 level:-1.
    label2 label:'0'.

    label3 := Label origin:(110 @ 200) extent:[40 @ 20] in:self.
    label3 level:-1.
    label3 label:'0'.

    colorLabel := Label origin:(10 @ 240) extent:[140 @ 40] in:self.
    colorLabel level:-1.

    colorForm := Form width:140 height:40 depth:(device depth).
    colorLabel form:colorForm.
    self setColorRed:0 green:0 blue:0
! !

!SliderDemo1 methodsFor:'private'!

setColorRed:r green:g blue:b
    "common color change action"

    color := Color red:r green:g blue:b.
    colorForm paint:color.
    colorForm fillRectangleX:0 y:0 width:(colorForm width)
                                  height:(colorForm height).
    colorLabel redraw

    "Modified: 18.5.1996 / 19:39:16 / cg"
! !

!SliderDemo1 methodsFor:'user interaction'!

sliderBlue:val
    "blue sliders action"

    label3 label:(val rounded asInteger printString).
    self setColorRed:(color red) green:(color green) blue:val.

    "Modified: 18.5.1996 / 19:39:21 / cg"
!

sliderGreen:val
    "green sliders action"

    label2 label:(val rounded asInteger printString).
    self setColorRed:(color red) green:val blue:(color blue).

    "Modified: 18.5.1996 / 19:39:25 / cg"
!

sliderRed:val
    "red sliders action"

    label1 label:(val rounded asInteger printString).
    self setColorRed:val green:(color green) blue:(color blue).

    "Modified: 18.5.1996 / 19:39:07 / cg"
! !

!SliderDemo1 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Slider-demo1.st,v 1.3 1997-01-03 21:42:37 cg Exp $'
! !
