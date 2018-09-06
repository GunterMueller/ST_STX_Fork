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



"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#SliderExample4
	instanceVariableNames:'slider labelField'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Views'
!

!SliderExample4 class methodsFor:'documentation'!

copyright
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


!

documentation
"
  Tutorial example - a slider with a label, showing value; label moves;
  (maybe, this should be moved into libwidg as a standard class ...)

  [author:]
    Claus Gittinger (jun 93)

  [start with:]
    SliderExample4 start
"
! !

!SliderExample4 methodsFor:'initialization'!

initialize
    |h lw|

    super initialize.

    self label:'Slider Example4'.
    self extent:(250 @ 60).

    h := (device verticalPixelPerMillimeter * 3) rounded.

    labelField := Label label:'0' in:self.
    labelField adjust:#right.
    labelField origin:0.0 @ (20 + h + 5).
    lw := labelField width.

    slider := HorizontalSlider in:self.
    slider origin:0.1 @ 20
	   corner:0.9 @ (20 + h).

    slider scrollAction:[:value |
	|xPos wThumb|

	labelField label:(value rounded printString).
	wThumb := slider thumbFrame width.
	xPos := slider left + (slider width - wThumb * (value / 100)).
	labelField left:xPos rounded - (labelField width // 2) + (wThumb // 2)
    ].

    "SliderExample4 start"
!

sizeChanged:how
    |value xPos wThumb|

    super sizeChanged:how.
    "reposition label"

    value := slider thumbOrigin.
    wThumb := slider thumbFrame width.
    xPos := slider left + (slider width - wThumb * (value / 100)).
    labelField left:xPos rounded - (labelField width // 2) + (wThumb // 2)
! !

!SliderExample4 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Slider-example4.st,v 1.7 1997-01-03 21:42:00 cg Exp $'
! !
