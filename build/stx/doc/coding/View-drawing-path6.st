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

ApplicationModel subclass:#PathDemo6
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Paths'
!

!PathDemo6 class methodsFor:'documentation'!

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
    Demonstration of Arrows.

    draws arrows with various styles, such as solid & doubleDashed;
    filled and unfilled.

    [author:]
        Claus Gittinger (written Dec-92 / changed for Geometry May-96)

    [see also:]
        Arrow Curve EllipticalArc Circle Spline LineSegment Polygon 
        Geometric
        StrokingWrapper FillingWrapper
        PathDemo1 PathDemo2 PathDemo3 PathDemo4 PathDemo5 PathDemo7

    [start with:]
        PathDemo6 open
"
! !

!PathDemo6 methodsFor:'initialization'!

initElementsIn:aView
    "add various arrows as visual components to aView"

    "/ varying the line & fillStyle

    aView addComponent:(
                (StrokingWrapper on:(
                    (Arrow from:10@10 to:290@10)))
          ).

    aView addComponent:(
                (StrokingWrapper on:(
                    (Arrow from:10@30 to:290@30)))
                    lineWidth:3
          ).

    aView addComponent:(
                (StrokingWrapper on:(
                    (Arrow from:10@50 to:290@50)))
                    capStyle:#round;
                    lineWidth:3
          ).

    aView addComponent:(
                (StrokingWrapper on:(
                    (Arrow from:10@70 to:290@70)))
                    lineStyle:#dashed;
                    foregroundColor:Color red;
                    lineWidth:1
          ).

    aView addComponent:(
                (StrokingWrapper on:(
                    (Arrow from:10@90 to:290@90)))
                    lineStyle:#doubleDashed;
                    lineWidth:3
          ).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:10@110 to:290@110)))
          ).

    "/ a fan off arrows

    130 to:200 by:20 do:[:y |
        aView addComponent:(
                    (FillingWrapper on:(
                        (Arrow from:130@130 to:20@y)))
              ).
    ].
    40 to:130 by:20 do:[:x |
        aView addComponent:(
                    (FillingWrapper on:(
                        (Arrow from:130@130 to:x@200)))
              ).
    ].

    "/ varying the arrowsHeads position & color

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:150@200 to:150@130)))
                    foregroundColor:(Color red)
          ).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:170@200 to:170@130)
                        arrowHeadPosition:0.7))
                    foregroundColor:(Color green darkened)
          ).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:190@200 to:190@130)
                        arrowHeadPosition:0.3))
                    foregroundColor:(Color blue)
          ).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:210@200 to:210@130)
                        arrowHeadPosition:0.0))
                    foregroundColor:(Color yellow)
          ).

    "/ varying the arrowsHeads length

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:30@230 to:30@290)
                        arrowHeadLength:20))
          ).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:50@230 to:50@290)
                        arrowHeadLength:10))
          ).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:70@230 to:70@290)
                        arrowHeadLength:5))
          ).

    "/ simulating a double-headed arrow

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:110@230 to:110@290)))).
    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:110@290 to:110@230)))).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:120@230 to:120@290)))
                    foregroundColor:Color black).
    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:120@230 to:120@230)))
                    foregroundColor:Color red).


    "/ varying the arrowsHeads angle


    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:160@230 to:160@290)
                        arrowHeadAngle:110))
          ).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:180@230 to:180@290)
                        arrowHeadAngle:120))
          ).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:200@230 to:200@290)
                        arrowHeadAngle:130))
          ).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:220@230 to:220@290)
                        arrowHeadAngle:140))
          ).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:240@230 to:240@290)
                        arrowHeadAngle:150))
          ).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:260@230 to:260@290)
                        arrowHeadAngle:160))
          ).

    aView addComponent:(
                (FillingWrapper on:(
                    (Arrow from:280@230 to:280@290)
                        arrowHeadAngle:165))
          ).
!

openInterface
    "create a topView, define its extent & window label"

    |top|

    top := StandardSystemView new.
    top extent:(300 @ 300).
    top label:'Arrows'.

    self initElementsIn:top.

    top open.

    "
     PathDemo6 open
    "
! !

!PathDemo6 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-drawing-path6.st,v 1.11 1997-01-03 20:34:13 cg Exp $'
! !
