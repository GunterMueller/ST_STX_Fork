"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GUIDemoNewMorphs1
	instanceVariableNames:'fgColorHolder lineHolder lineHolder2 visibilityHolder
		bulletOriginHolder blinkProcess'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-Widgets'
!


!GUIDemoNewMorphs1 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoNewMorphs1 andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoNewMorphs1 new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoNewMorphs1 open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (ArcMorphSpec
              name: 'Blinker'
              layout: (LayoutFrame 43 0 30 0 103 0 93 0)
              foregroundColor: (Color 100.0 100.0 0.0)
              line: true
              fill: true
              lineColor: (Color 100.0 0.0 0.0)
              postBuildCallback: postCreateBlinker:
            )
           (RectangleMorphSpec
              name: 'RectangleMorph1'
              layout: (LayoutFrame 117 0 85 0 180 0 148 0)
              foregroundColor: (Color 100.0 100.0 0.0)
              line: true
              fill: true
              lineColor: (Color 100.0 0.0 0.0)
              postBuildCallback: postCreateBlinker2:
            )
           (RectangleMorphSpec
              name: 'RectangleMorph2'
              layout: (LayoutFrame 36 0 170 0 99 0 230 0)
              foregroundColor: (Color 100.0 100.0 0.0)
              line: true
              fill: false
              lineColor: (Color 100.0 0.0 0.0)
              postBuildCallback: postCreateBlinker3:
            )
           (LineSegmentMorphSpec
              name: 'LineSegmentMorph1'
              visibilityChannel: visibilityHolder
              foregroundColor: (Color 100.0 100.0 0.0)
              fill: true
              lineColor: (Color 100.0 0.0 0.0)
              startPoint: (Point 213 9)
              endPoint: (Point 253 59)
              showArrow: true
              postBuildCallback: postCreateArrow1:
            )
           )
         
        )
      )
! !

!GUIDemoNewMorphs1 methodsFor:'actions'!

postCreateArrow1:anArgument
    "/ anArgument visibilityChannel:(self visibilityHolder).
!

postCreateBlinker2:anArgument
    anArgument lineHolder:(self lineHolder).
!

postCreateBlinker3:anArgument
    anArgument lineHolder:(self lineHolder2).
!

postCreateBlinker:anArgument
    anArgument foregroundColorHolder:(self fgColorHolder).
    anArgument originHolder:(self bulletOriginHolder).
! !

!GUIDemoNewMorphs1 methodsFor:'aspects'!

bulletOriginHolder
    bulletOriginHolder isNil ifTrue:[
        bulletOriginHolder := (0@0) asValue.
    ].
    ^ bulletOriginHolder
!

fgColorHolder
    fgColorHolder isNil ifTrue:[
        fgColorHolder := Color yellow asValue.
    ].
    ^ fgColorHolder
!

lineHolder
    lineHolder isNil ifTrue:[
        lineHolder := false asValue.
    ].
    ^ lineHolder
!

lineHolder2
    lineHolder2 isNil ifTrue:[
        lineHolder2 := false asValue.
    ].
    ^ lineHolder2
!

visibilityHolder
    visibilityHolder isNil ifTrue:[
        visibilityHolder := false asValue.
    ].
    ^ visibilityHolder
! !

!GUIDemoNewMorphs1 methodsFor:'hooks'!

postOpenWith:aBuilder
    |bulletOrigin|

    super postOpenWith:aBuilder.

    bulletOrigin := 10@10.

    blinkProcess := 
        [
            [
                Delay waitForSeconds:1.
                self fgColorHolder value:(Color red).
                self lineHolder value:true.
                self lineHolder2 value:false.
                self visibilityHolder value:false.
                Delay waitForSeconds:1.
                self fgColorHolder value:(Color yellow).
                self lineHolder value:false.
                self lineHolder2 value:true.
                self visibilityHolder value:true.

                bulletOrigin := bulletOrigin + (10@10).
                self bulletOriginHolder value:bulletOrigin.
            ] loop
        ] fork.
!

release
    blinkProcess terminate.
    super release
! !

!GUIDemoNewMorphs1 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoNewMorphs1.st,v 1.4 2009-05-13 16:41:46 cg Exp $'
! !
