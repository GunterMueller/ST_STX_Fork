"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GUIDemoNewMorphs2
	instanceVariableNames:'fgColorHolder blinkProcess bulletOriginHolder xPositionHolder
		yPositionHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-Widgets'
!


!GUIDemoNewMorphs2 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoNewMorphs2 andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoNewMorphs2 new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoNewMorphs2 open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          bounds: (Rectangle 0 0 298 298)
        )
        component: 
       (SpecCollection
          collection: (
           (SliderSpec
              name: 'Slider1'
              layout: (LayoutFrame 0 0.0 277 0 -28 1.0 295 0)
              model: xPositionHolder
              orientation: horizontal
            )
           (SliderSpec
              name: 'Slider2'
              layout: (LayoutFrame 277 0 0 0.0 295 0 -27 1.0)
              model: yPositionHolder
            )
           (RectangleMorphSpec
              name: 'RectangleMorph1'
              layout: (LayoutFrame 61 0 16 0 250 0 249 0)
              foregroundColor: (Color 100.0 100.0 74.999618524453)
              line: false
              fill: true
              lineColor: (Color 100.0 0.0 0.0)
            )
           (ArcMorphSpec
              name: 'Blinker'
              layout: (LayoutFrame 15 0 14 0 75 0 70 0)
              foregroundColor: (Color 100.0 100.0 0.0)
              line: true
              fill: true
              lineColor: (Color 100.0 0.0 0.0)
              foregroundColorChannel: fgColorHolder
              originChannel: bulletOriginHolder
            )
           (RectangleMorphSpec
              name: 'RectangleMorph2'
              layout: (LayoutFrame 61 0 124 0 250 0 249 0)
              foregroundColor: (Color 66.999313344015 66.999313344015 0.0)
              line: false
              fill: true
              lineColor: (Color 100.0 0.0 0.0)
            )
           )
         
        )
      )
! !

!GUIDemoNewMorphs2 methodsFor:'aspects'!

bulletOriginHolder
    bulletOriginHolder isNil ifTrue:[
        bulletOriginHolder := BlockValue
                                with:[:x :y | (x @ y) / 100 
                                                * (self window extent - 60) ]
                                argument: self xPositionHolder
                                argument: self yPositionHolder 
    ].
    ^ bulletOriginHolder
!

fgColorHolder
    fgColorHolder isNil ifTrue:[
        fgColorHolder := Color yellow asValue.
    ].
    ^ fgColorHolder
!

xPositionHolder
    xPositionHolder isNil ifTrue:[
        xPositionHolder := 0 asValue.
    ].
    ^ xPositionHolder
!

yPositionHolder
    yPositionHolder isNil ifTrue:[
        yPositionHolder := 0 asValue.
    ].
    ^ yPositionHolder
! !

!GUIDemoNewMorphs2 methodsFor:'hooks'!

postOpenWith:aBuilder
    super postOpenWith:aBuilder.

    blinkProcess := 
        [
            [
                Delay waitForSeconds:1.
                self fgColorHolder value:(Color red).
                Delay waitForSeconds:1.
                self fgColorHolder value:(Color yellow).
            ] loop
        ] fork.
!

release
    blinkProcess terminate.
    super release.
! !

!GUIDemoNewMorphs2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/CodingExamples_GUI__GUIDemoNewMorphs2.st,v 1.2 2009-05-13 16:41:32 cg Exp $'
! !
