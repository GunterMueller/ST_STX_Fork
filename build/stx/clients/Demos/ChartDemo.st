"
 COPYRIGHT (c) 1998 by eXept Software AG
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

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#ChartDemo
	instanceVariableNames:'chartHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-Charts'
!

!ChartDemo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    Demonstrates the use of the various chart widgets.
    All of them display the same data provided for the
    widgets models.

    [author:]
        Timo Merkert

    [see also:]
        BarChartDemo ChartDescriptionDemo PieChartDemo
        BarChartWidget PieChartWidget
"


! !

!ChartDemo class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::ChartDemo andSelector:#windowSpec
     CodingExamples_GUI::ChartDemo new openInterface:#windowSpec
     CodingExamples_GUI::ChartDemo open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          min: (Point 10 10)
          max: (Point 1280 1024)
          bounds: (Rectangle 0 0 455 435)
        )
        component: 
       (SpecCollection
          collection: (
           (PieChartWidgetSpec
              label: 'test'
              name: 'ChartWidget1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 0.5 0 0.5)
              style: (FontDescription helvetica bold roman 12)
              model: giveMeAChartHolder
              foregroundColor: (Color 49.999237048905 0.0 49.999237048905)
              backgroundColor: (Color 0.0 32.999160753796 0.0)
            )
           (ChartDescriptionSpec
              name: 'ChartDescription1'
              layout: (LayoutFrame 0 0.5 0 0.0 0 1.0 0 1.0)
              model: giveMeAChartHolder
            )
           (BarChartWidgetSpec
              label: 'Wahl ''90'
              name: 'BarChartWidget1'
              layout: (LayoutFrame 0 0.0 -4 0.5 1 0.5 -4 1.0)
              style: (FontDescription helvetica bold roman 12)
              model: giveMeAChartHolder
              foregroundColor: (Color 49.999237048905 0.0 49.999237048905)
              backgroundColor: (Color 0.0 49.999237048905 0.0)
            )
           )
         
        )
      )
! !

!ChartDemo methodsFor:'aspects'!

giveMeAChartDescriptionHolder
    "provide a valueHolder for the chartDescriptionWidgets model value"

    ^ self giveMeAChartHolder
!

giveMeAChartHolder
    "provide a valueHolder for the chart- and chartDescriptionWidgets model value"

    |chart piece|

    chartHolder isNil ifTrue:[
        chart := OrderedCollection new.

        piece := Dictionary new.
        piece at:#value put:37.
        piece at:#name put:'CDU'.
        piece at:#color put:(Color black).
        chart add:piece.

        piece := Dictionary new.
        piece at:#value put:42.
        piece at:#name put:'SPD'.
        piece at:#color put:(Color red).
        chart add:piece.

        piece := Dictionary new.
        piece at:#value put:6.
        piece at:#name put:'Grüne'.
        piece at:#color put:(Color green).
        chart add:piece.

        piece := Dictionary new.
        piece at:#value put:4.
        piece at:#name put:'FDP'.
        piece at:#color put:(Color yellow).
        chart add:piece.

        piece := Dictionary new.
        piece at:#value put:4.
        piece at:#name put:'REP'.
        piece at:#color put:(Color name:'brown').
        chart add:piece.

        piece := Dictionary new.
        piece at:#value put:3.
        piece at:#name put:'Sonstige'.
        piece at:#color put:(Color grey).
        chart add:piece.

        chartHolder := ValueHolder new.
        chartHolder value:chart.
    ].
    ^ chartHolder
! !

!ChartDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ChartDemo.st,v 1.3 2009-05-13 09:51:33 cg Exp $'
! !
