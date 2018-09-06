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

ApplicationModel subclass:#PathDemo5
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Paths'
!

!PathDemo5 class methodsFor:'documentation'!

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
    Demonstration of Curves.

    draws curves with various styles, such as solid & doubleDashed;
    filled and unfilled.

    [author:]
        Claus Gittinger (written Dec-92 / changed for Geometry May-96)

    [see also:]
        Curve EllipticalArc Circle Spline LineSegment Polygon 
        Geometric
        StrokingWrapper FillingWrapper
        PathDemo1 PathDemo2 PathDemo3 PathDemo4 PathDemo6 PathDemo7

    [start with:]
        PathDemo5 open
"
! !

!PathDemo5 methodsFor:'initialization'!

initElementsIn:aView
    "add various curves as visual components to aView"

    aView addComponent:(
                (StrokingWrapper on:(
                    (Polygon vertices:(
                        Array with:50@25
                              with:100@75
                              with:150@25))))).

    aView addComponent:(
                (StrokingWrapper on:(
                    (Curve with:50@25
                           with:100@75
                           with:150@25)))
                    lineWidth:5).

    aView addComponent:(
                (StrokingWrapper on:(
                    (Polygon vertices:(
                        Array with:250@25
                              with:300@75
                              with:350@25))))).

    aView addComponent:(
                (FillingWrapper on:(
                    (Curve with:250@25
                           with:300@75
                           with:350@25)))
                    foregroundColor:Color red).

    aView addComponent:(
                (StrokingWrapper on:(
                    (Polygon vertices:(
                        Array with:50@300
                              with:100@120
                              with:150@300))))).
    aView addComponent:(
                (StrokingWrapper on:(
                    (Curve with:50@300
                           with:100@120
                           with:150@300)))
                    lineStyle:#dashed;
                    foregroundColor:Color green;
                    lineWidth:10).

    aView addComponent:(
                (StrokingWrapper on:(
                    (Polygon vertices:(
                        Array with:250@300
                              with:300@120
                              with:350@300))))).
    aView addComponent:(
                (FillingWrapper on:(
                    (Curve with:250@300
                           with:300@120
                           with:350@300)))
                    foregroundColor:Color magenta).

    aView addComponent:(
                (StrokingWrapper on:(
                    (Polygon vertices:(
                        Array with:50@320
                              with:200@380
                              with:350@320))))).
    aView addComponent:(
                (StrokingWrapper on:(
                    (Curve with:50@320
                           with:200@380
                           with:350@320)))
                    lineStyle:#doubleDashed;
                    foregroundColor:Color black;
                    backgroundColor:Color white;
                    lineWidth:3).
!

openInterface
    "create a topView, define its extent & window label"

    |top|

    top := StandardSystemView new.
    top extent:(400 @ 400).
    top label:'Curves'.

    self initElementsIn:top.

    top open.

    "
     PathDemo5 open
    "




! !

!PathDemo5 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-drawing-path5.st,v 1.11 1997-01-03 20:34:19 cg Exp $'
! !
