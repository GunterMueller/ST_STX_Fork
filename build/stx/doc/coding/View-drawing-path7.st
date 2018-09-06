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

ApplicationModel subclass:#PathDemo7
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Paths'
!

!PathDemo7 class methodsFor:'documentation'!

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
    Demonstration of ArrowedSplines.

    draws arrowedSplines with various styles, such as solid & doubleDashed;
    filled and unfilled.

    [author:]
        Claus Gittinger (written Dec-92 / changed for Geometry May-96)

    [see also:]
        ArrowedSpline Arrow Curve EllipticalArc Circle 
        Spline LineSegment Polygon 
        Geometric
        StrokingWrapper FillingWrapper
        PathDemo1 PathDemo2 PathDemo3 PathDemo4 PathDemo5 PathDemo7 PathDemo8

    [start with:]
        PathDemo7 open
"
! !

!PathDemo7 methodsFor:'initialization'!

initElementsIn:aView
    "add various arrows as visual components to aView"

    |v|

    v := OrderedCollection new.

    v add:(50@50);
      add:(100@150);
      add:(150@25).

    aView addComponent:(
                (StrokingWrapper on:(
                    (ArrowedSpline controlPoints:v)))).


    v := OrderedCollection new.

    v add:(50@240);
      add:(100@280);
      add:(150@240);
      add:(200@280);
      add:(250@250).

    aView addComponent:(
                (StrokingWrapper on:(
                    (ArrowedSpline controlPoints:v)))).

    v := OrderedCollection new.

    v add:(250@100);
      add:(200@50);
      add:(150@100);
      add:(200@150);
      add:(250@100).

    aView addComponent:(
                (FillingWrapper on:(
                    (ArrowedSpline controlPoints:v)
                        arrowHeadPositions:(1 to:4)))
                    foregroundColor:Color red).
!

openInterface
    "create a topView, define its extent & window label"

    |top|

    top := StandardSystemView new.
    top extent:(300 @ 300).
    top label:'Arrowed Splines'.

    self initElementsIn:top.

    top open.

    "
     PathDemo7 open
    "

! !

!PathDemo7 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-drawing-path7.st,v 1.11 1997-01-03 20:34:03 cg Exp $'
! !
