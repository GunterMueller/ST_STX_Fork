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

ApplicationModel subclass:#PathDemo4
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Paths'
!

!PathDemo4 class methodsFor:'documentation'!

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
    Demonstration of Arcs & Circles.

    draws arcs & circles with various styles, such as solid & doubleDashed;
    filled and unfilled.

    [author:]
        Claus Gittinger (written Dec-92 / changed for Geometry May-96)

    [see also:]
        EllipticalArc Circle Spline LineSegment Polygon 
        Geometric
        StrokingWrapper FillingWrapper
        PathDemo1 PathDemo2 PathDemo3 PathDemo5 PathDemo6 PathDemo7

    [start with:]
        PathDemo4 open
"
! !

!PathDemo4 methodsFor:'initialization'!

initElementsIn:aView
    "add various splines as visual components to aView"

    |v|

    aView addComponent:((
                StrokingWrapper on:(
                    EllipticalArc center:100@100 radius:50
                                 startAngle:0 endAngle:135))
                    lineWidth:5).

    aView addComponent:((
                FillingWrapper on:(
                    EllipticalArc center:80@150 radius:50
                                 startAngle:0 endAngle:135))
                    foregroundColor:Color green).

    aView addComponent:((
                StrokingWrapper on:(
                    EllipticalArc center:100@300 radius:75
                                 startAngle:0 endAngle:300))
                    lineWidth:2).

    aView addComponent:((
                FillingWrapper on:(
                    EllipticalArc center:100@300 radius:50
                                 startAngle:0 endAngle:300))
                    foregroundColor:(Image fromFile:'woodH.tiff')).

    aView addComponent:((
                StrokingWrapper on:(
                    Circle center:200@200 radius:50))
                    lineWidth:5;
                    lineStyle:#doubleDashed;
                    foregroundColor:Color black;
                    backgroundColor:Color white).

    aView addComponent:((
                FillingWrapper on:(
                    EllipticalArc boundingBox:(210@310 corner:390@390)))
                    foregroundColor:(Image fromFile:'woodH.tiff')).

    aView addComponent:((
                StrokingWrapper on:(
                    EllipticalArc center:300@300 radius:75
                                 startAngle:0 endAngle:300))
                    lineWidth:4;
                    lineStyle:#doubleDashed;
                    foregroundColor:Color red;
                    backgroundColor:Color white).

    aView addComponent:((
                StrokingWrapper on:(
                    Circle center:300@100 radius:100))
                    lineWidth:5;
                    lineStyle:#dashed;
                    foregroundColor:Color white).
!

openInterface
    "create a topView, define its extent & window label"

    |top|

    top := StandardSystemView new.
    top extent:(400 @ 400).
    top label:'Arcs & Circles'.

    self initElementsIn:top.

    top open.

    "
     PathDemo4 open
    "



! !

!PathDemo4 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-drawing-path4.st,v 1.12 1997-01-03 20:34:22 cg Exp $'
! !
