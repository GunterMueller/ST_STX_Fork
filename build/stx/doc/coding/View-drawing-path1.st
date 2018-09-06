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

ApplicationModel subclass:#PathDemo1
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Paths'
!

!PathDemo1 class methodsFor:'documentation'!

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
    Demonstration of LineSegment & GeometricWrappers.

    draws lines with various styles, such as solid, dashed & doubleDashed;
    thin & thick lines, using solid or pattern colors,
    and different endPoint (i.e. cap-) styles.

    [author:]
        Claus Gittinger (written Dec-92 / changed for Geometry May-96)

    [see also:]
        LineSegment Polygon Spline
        Geometric
        StrokingWrapper FillingWrapper
        PathDemo2 PathDemo3 PathDemo4 PathDemo5 PathDemo6 PathDemo7

    [start with:]
        PathDemo1 open
"
! !

!PathDemo1 methodsFor:'initialization'!

initElementsIn:aView
    "add various lineSegments as visual components to aView"

    |l|

    l := LineSegment from:(10@10) to:(290 @ 10).
    aView addComponent:((StrokingWrapper on:l) lineWidth:10).

    l := LineSegment from:10 @ 30 to:(290 @ 30).
    aView addComponent:((StrokingWrapper on:l) lineWidth:10; capStyle:#round).

    l := LineSegment from:10 @ 50 to:(290 @ 50).
    aView addComponent:((StrokingWrapper on:l) lineWidth:5; lineStyle:#dashed).

    l := LineSegment from:10 @ 70 to:(290 @ 70).
    aView addComponent:((StrokingWrapper on:l) lineWidth:5; lineStyle:#doubleDashed).

    l := LineSegment from:10 @ 90 to:(290 @ 190).
    aView addComponent:((StrokingWrapper on:l) 
                            lineWidth:15; 
                            lineStyle:#doubleDashed;
                            foregroundColor:Color red).

    l := LineSegment from:290 @ 90 to:(10 @ 190).
    aView addComponent:((StrokingWrapper on:l) 
                            lineWidth:5; 
                            lineStyle:#dashed;
                            foregroundColor:Color green).

    l := LineSegment from:10 @ 200 to:(290 @ 200).
    aView addComponent:((StrokingWrapper on:l) 
                            lineStyle:#solid;
                            lineWidth:8; 
                            foregroundColor:(Image fromFile:'woodH.tiff')).

    "Modified: 21.12.1996 / 17:39:29 / cg"
!

openInterface
    "create a topView, define its extent & window label"

    |top|

    top := StandardSystemView new.
    top extent:(300 @ 250).
    top label:'LineSegments'.

    self initElementsIn:top.

    top open.

    "
     PathDemo1 open
    "

    "Modified: 21.12.1996 / 17:39:29 / cg"
! !

!PathDemo1 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-drawing-path1.st,v 1.13 1997-01-03 20:34:08 cg Exp $'
! !
