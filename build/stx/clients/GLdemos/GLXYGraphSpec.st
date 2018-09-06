"{ Package: 'stx:clients/GLdemos' }"

"{ NameSpace: Demos }"

MenuComponentSpec subclass:#GLXYGraphSpec
	instanceVariableNames:'xMin xMax yMin yMax deltaX deltaY rotX rotY rotZ transX transY
		transZ scaleZ drawNormals drawBox backgroundColor normalsColor
		gridColor boxColor'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

!GLXYGraphSpec class methodsFor:'documentation'!

documentation
"
    Not normally used by applications.

    [author:]
        Claus Gittinger

    [see also:]
        UIBuilder
        UIPainter
"




! !

!GLXYGraphSpec class methodsFor:'class initialization'!

initialize
    "add an entry for my component to the UIPainters 
     userDef gallery"

    UISelectionPanel userClass
        addUserSpecHolder:[self graphSpec]
        label:'Graphs-3D'

    "
     self initialize
    "

    "Created: / 29.5.1998 / 21:15:21 / cg"
    "Modified: / 29.5.1998 / 21:15:55 / cg"
!

removeFromSystem
    "remove myself - this implies deinstallation from the UIGallery"

    UISelectionPanel userClass removeUserSpecWithLabel:'Graphs-3D'.
    ^ super removeFromSystem.

    "
    UISelectionPanel userClass removeUserSpecWithLabel:'Graphs-3D'.
    "

    "Modified: / 29.5.1998 / 21:53:22 / cg"
! !

!GLXYGraphSpec class methodsFor:'interface painter'!

addBindingsTo:env for:inst channel:aChannel 

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        backgroundColor
                        normalsColor 
                        gridColor
                        boxColor
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        rotX
                        rotY
                        rotZ
                        transX
                        transY
                        transZ
                        scaleZ
                        drawNormals
                        drawBox
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        xMin
                        xMax
                        yMin
                        yMax
                        deltaX
                        deltaY
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#numberOrNil.

    "Created: / 29.5.1998 / 21:18:32 / cg"
    "Modified: / 5.6.1998 / 04:02:12 / cg"
! !

!GLXYGraphSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Demos::GLXYGraphSpec andSelector:#basicsEditSpec
     Demos::GLXYGraphSpec new openInterface:#basicsEditSpec
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'Graph 2D Basic'
              #layout: #(#LayoutFrame 216 0 173 0 527 0 486 0)
              #label: 'Graph 2D Basic'
              #min: #(#Point 10 10)
              #max: #(#Point 1160 870)
              #bounds: #(#Rectangle 216 173 528 487)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#LabelSpec
                    #name: 'nameLabel'
                    #layout: #(#AlignmentOrigin 73 0 31 0 1 0.5)
                    #label: 'ID:'
                    #adjust: #right
                    #resizeForLabel: true
                    #activeHelpKey: #id
                )
                 #(#InputFieldSpec
                    #name: 'nameField'
                    #layout: #(#LayoutFrame 75 0 20 0 -2 1.0 45 0)
                    #activeHelpKey: #id
                    #model: #name
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                )
                 #(#LabelSpec
                    #name: 'modelLabel'
                    #layout: #(#AlignmentOrigin 73 0 60 0 1 0.5)
                    #label: 'Model:'
                    #resizeForLabel: true
                    #activeHelpKey: #model
                )
                 #(#InputFieldSpec
                    #name: 'modelField'
                    #layout: #(#LayoutFrame 75 0 49 0 -2 1 74 0)
                    #activeHelpKey: #model
                    #tabable: true
                    #model: #model
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                )
                 #(#UISubSpecification
                    #name: 'menuSubSpec'
                    #layout: #(#LayoutFrame 0 0.0 144 0 0 1.0 269 0)
                    #majorKey: #UISpecification
                    #minorKey: #menuSubSpec
                )
              )
          )
      )

    "Modified: / 5.6.1998 / 03:59:22 / cg"
!

channelsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Demos::GLXYGraphSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #channelsEditSpec
        #window: 
       #(#WindowSpec
          #label: 'Label Channels'
          #name: 'Label Channels'
          #min: #(#Point 10 10)
          #max: #(#Point 1280 1024)
          #bounds: #(#Rectangle 220 200 620 519)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#FramedBoxSpec
              #label: 'Channels - translation'
              #name: 'FramedBox'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 117 0)
              #labelPosition: #topLeft
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#LabelSpec
                    #label: 'x:'
                    #name: 'transXLabel'
                    #layout: #(#AlignmentOrigin 99 0 18 0 1 0.5)
                    #activeHelpKey: #xTransChannel
                    #resizeForLabel: true
                    #adjust: #right
                  )
                 #(#InputFieldSpec
                    #name: 'transXField'
                    #layout: #(#LayoutFrame 100 0 7 0 0 1 29 0)
                    #activeHelpKey: #xTransChannel
                    #model: #transX
                    #acceptOnPointerLeave: false
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 #(#LabelSpec
                    #label: 'y:'
                    #name: 'transYLabel'
                    #layout: #(#AlignmentOrigin 99 0 43 0 1 0.5)
                    #activeHelpKey: #yTransChannel
                    #resizeForLabel: true
                    #adjust: #right
                  )
                 #(#InputFieldSpec
                    #name: 'transYField'
                    #layout: #(#LayoutFrame 100 0 32 0 0 1 54 0)
                    #activeHelpKey: #yTransChannel
                    #model: #transY
                    #acceptOnPointerLeave: false
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 #(#LabelSpec
                    #label: 'z:'
                    #name: 'transZLabel'
                    #layout: #(#AlignmentOrigin 99 0 68 0 1 0.5)
                    #activeHelpKey: #zTransChannel
                    #resizeForLabel: true
                    #adjust: #right
                  )
                 #(#InputFieldSpec
                    #name: 'transZField'
                    #layout: #(#LayoutFrame 100 0 57 0 0 1 79 0)
                    #activeHelpKey: #zTransChannel
                    #model: #transZ
                    #acceptOnPointerLeave: false
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 )
               
              )
            )
           #(#FramedBoxSpec
              #label: 'Channels - rotation'
              #name: 'FramedBox1'
              #layout: #(#LayoutFrame 0 0.0 114 0.0 0 1.0 231 0)
              #labelPosition: #topLeft
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#LabelSpec
                    #label: 'x:'
                    #name: 'rotXLabel'
                    #layout: #(#AlignmentOrigin 99 0 20 0 1 0.5)
                    #activeHelpKey: #xRotChannel
                    #resizeForLabel: true
                    #adjust: #right
                  )
                 #(#InputFieldSpec
                    #name: 'rotXField'
                    #layout: #(#LayoutFrame 100 0 9 0 0 1 31 0)
                    #activeHelpKey: #xRotChannel
                    #model: #rotX
                    #acceptOnPointerLeave: false
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 #(#LabelSpec
                    #label: 'y:'
                    #name: 'rotYLabel'
                    #layout: #(#AlignmentOrigin 99 0 45 0 1 0.5)
                    #activeHelpKey: #yRotChannel
                    #resizeForLabel: true
                    #adjust: #right
                  )
                 #(#InputFieldSpec
                    #name: 'rotYField'
                    #layout: #(#LayoutFrame 100 0 34 0 0 1 56 0)
                    #activeHelpKey: #yRotChannel
                    #model: #rotY
                    #acceptOnPointerLeave: false
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 #(#LabelSpec
                    #label: 'z:'
                    #name: 'rotZLabel'
                    #layout: #(#AlignmentOrigin 99 0 70 0 1 0.5)
                    #activeHelpKey: #zRotChannel
                    #resizeForLabel: true
                    #adjust: #right
                  )
                 #(#InputFieldSpec
                    #name: 'rotZField'
                    #layout: #(#LayoutFrame 100 0 59 0 0 1 81 0)
                    #activeHelpKey: #zRotChannel
                    #model: #rotZ
                    #acceptOnPointerLeave: false
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 )
               
              )
            )
           #(#FramedBoxSpec
              #label: 'Channels - look'
              #name: 'FramedBox2'
              #layout: #(#LayoutFrame 0 0.0 228 0.0 0 1.0 318 0)
              #labelPosition: #topLeft
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#LabelSpec
                    #label: 'normals:'
                    #name: 'normalsLabel'
                    #layout: #(#AlignmentOrigin 99 0 19 0 1 0.5)
                    #activeHelpKey: #drawNormalsChannel
                    #resizeForLabel: true
                    #adjust: #right
                  )
                 #(#InputFieldSpec
                    #name: 'normalsField'
                    #layout: #(#LayoutFrame 100 0 8 0 0 1 30 0)
                    #activeHelpKey: #drawNormalsChannel
                    #model: #drawNormals
                    #acceptOnPointerLeave: false
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 #(#LabelSpec
                    #label: 'box:'
                    #name: 'boxLabel'
                    #layout: #(#AlignmentOrigin 99 0 44 0 1 0.5)
                    #activeHelpKey: #drawBoxChannel
                    #resizeForLabel: true
                    #adjust: #right
                  )
                 #(#InputFieldSpec
                    #name: 'boxField'
                    #layout: #(#LayoutFrame 100 0 33 0 0 1 55 0)
                    #activeHelpKey: #drawBoxChannel
                    #model: #drawBox
                    #acceptOnPointerLeave: false
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Demos::GLXYGraphSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #detailsEditSpec
        #window: 
       #(#WindowSpec
          #label: 'Graph Details'
          #name: 'Graph Details'
          #min: #(#Point 10 10)
          #max: #(#Point 1152 900)
          #bounds: #(#Rectangle 220 200 620 515)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#UISubSpecification
              #name: 'detailsInitSubSpec'
              #layout: #(#LayoutFrame 0 0.0 234 0 0 1.0 297 0)
              #majorKey: #UISpecification
              #minorKey: #detailsInitSubSpec
            )
           #(#FramedBoxSpec
              #label: 'Visual Attributes'
              #name: 'FramedBox1'
              #layout: #(#LayoutFrame 0 0.0 6 0.0 0 1.0 234 0)
              #labelPosition: #topLeft
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#LabelSpec
                    #label: 'BG-Color:'
                    #name: 'backgroundLabel'
                    #layout: #(#AlignmentOrigin 97 0 37 0 1 0.5)
                    #activeHelpKey: #backgroundColor
                    #resizeForLabel: true
                    #adjust: #right
                  )
                 #(#ColorMenuSpec
                    #name: 'colorMenuBG'
                    #layout: #(#LayoutFrame 100 0 25 0 0 1 47 0)
                    #activeHelpKey: #backgroundColor
                    #model: #backgroundColor
                    #labelsAreColored: false
                  )
                 #(#LabelSpec
                    #label: 'Normals:'
                    #name: 'normalsColorLabel'
                    #layout: #(#AlignmentOrigin 97 0 68 0 1 0.5)
                    #activeHelpKey: #normalsColor
                    #resizeForLabel: true
                    #adjust: #right
                  )
                 #(#ColorMenuSpec
                    #name: 'colorMenuNormals'
                    #layout: #(#LayoutFrame 100 0 55 0 0 1 77 0)
                    #activeHelpKey: #normalsColor
                    #model: #normalsColor
                    #labelsAreColored: false
                  )
                 #(#LabelSpec
                    #label: 'Graph:'
                    #name: 'gridColorLabel'
                    #layout: #(#AlignmentOrigin 97 0 99 0 1 0.5)
                    #activeHelpKey: #gridColor
                    #resizeForLabel: true
                    #adjust: #right
                  )
                 #(#ColorMenuSpec
                    #name: 'colorMenuGrid'
                    #layout: #(#LayoutFrame 100 0 85 0 0 1 107 0)
                    #activeHelpKey: #gridColor
                    #model: #gridColor
                    #labelsAreColored: false
                  )
                 #(#LabelSpec
                    #label: 'Box:'
                    #name: 'boxLabel'
                    #layout: #(#AlignmentOrigin 97 0 129 0 1 0.5)
                    #activeHelpKey: #boxColor
                    #resizeForLabel: true
                    #adjust: #right
                  )
                 #(#ColorMenuSpec
                    #name: 'colorMenuBox'
                    #layout: #(#LayoutFrame 100 0 115 0 0 1 137 0)
                    #activeHelpKey: #boxColor
                    #model: #boxColor
                    #labelsAreColored: false
                  )
                 #(#LabelSpec
                    #label: 'Border:'
                    #name: 'borderLabel'
                    #layout: #(#AlignmentOrigin 98 0 156 0 1 0.5)
                    #activeHelpKey: #borderWidth
                    #resizeForLabel: true
                    #adjust: #left
                  )
                 #(#InputFieldSpec
                    #name: 'borderField'
                    #layout: #(#LayoutFrame 100 0 145 0 150 0 167 0)
                    #activeHelpKey: #borderWidth
                    #tabable: true
                    #model: #borderWidth
                    #acceptOnPointerLeave: false
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 #(#LabelSpec
                    #label: 'Level:'
                    #name: 'levelLabel'
                    #layout: #(#AlignmentOrigin 224 0 156 0 1 0.5)
                    #activeHelpKey: #level
                    #resizeForLabel: true
                    #adjust: #left
                  )
                 #(#InputFieldSpec
                    #name: 'levelField'
                    #layout: #(#LayoutFrame 226 0 145 0 276 0 167 0)
                    #activeHelpKey: #level
                    #tabable: true
                    #model: #level
                    #acceptOnPointerLeave: false
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 #(#CheckBoxSpec
                    #label: 'Show Normals'
                    #name: 'showNormals'
                    #layout: #(#LayoutFrame 20 0 178 0 156 0 200 0)
                    #activeHelpKey: #showNormals
                    #model: #drawNormals
                    #translateLabel: true
                  )
                 #(#CheckBoxSpec
                    #label: 'Show Box'
                    #name: 'showBoxCheck'
                    #layout: #(#LayoutFrame 175 0 178 0 311 0 200 0)
                    #activeHelpKey: #showBox
                    #model: #drawBox
                    #translateLabel: true
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

slices
    ^ #(
            (Basics    basicsEditSpec)
            (Details   detailsEditSpec)
            (Details2  subDetailsEditSpec)
            (Channels  channelsEditSpec)
       )

    "Created: / 29.5.1998 / 22:33:30 / cg"
    "Modified: / 5.6.1998 / 00:52:33 / cg"
!

subDetailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Demos::GLXYGraphSpec andSelector:#subDetailsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #subDetailsEditSpec
        #window: 
       #(#WindowSpec
          #label: 'X-Y Graph Detail'
          #name: 'X-Y Graph Detail'
          #min: #(#Point 10 10)
          #max: #(#Point 1160 870)
          #bounds: #(#Rectangle 220 200 565 417)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#FramedBoxSpec
              #label: 'Range'
              #name: 'FramedBox1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 137 0)
              #labelPosition: #topLeft
              #translateLabel: true
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#LabelSpec
                    #label: 'xMin:'
                    #name: 'xMinLabel'
                    #layout: #(#LayoutFrame 0 0 32 0 50 0 54 0)
                    #activeHelpKey: #glxGraphXMin
                    #translateLabel: true
                    #resizeForLabel: true
                    #adjust: #left
                  )
                 #(#InputFieldSpec
                    #name: 'xMinField'
                    #layout: #(#LayoutFrame 50 0 30 0 107 0 52 0)
                    #activeHelpKey: #glxGraphXMin
                    #model: #xMin
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 #(#LabelSpec
                    #label: 'yMin:'
                    #name: 'yMinLabel'
                    #layout: #(#LayoutFrame 0 0 67 0 50 0 89 0)
                    #activeHelpKey: #glxGraphYMin
                    #translateLabel: true
                    #resizeForLabel: true
                    #adjust: #left
                  )
                 #(#InputFieldSpec
                    #name: 'yMinField'
                    #layout: #(#LayoutFrame 50 0 65 0 107 0 87 0)
                    #activeHelpKey: #glxGraphYMin
                    #model: #yMin
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 #(#LabelSpec
                    #label: 'xMax:'
                    #name: 'xMaxLabel'
                    #layout: #(#LayoutFrame 116 0 32 0 168 0 54 0)
                    #activeHelpKey: #glxGraphXMax
                    #translateLabel: true
                    #resizeForLabel: true
                    #adjust: #left
                  )
                 #(#InputFieldSpec
                    #name: 'xMaxField'
                    #layout: #(#LayoutFrame 170 0 30 0 227 0 52 0)
                    #activeHelpKey: #glxGraphXMax
                    #model: #xMax
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 #(#LabelSpec
                    #label: 'yMax:'
                    #name: 'yMaxLabel'
                    #layout: #(#LayoutFrame 116 0 67 0 168 0 89 0)
                    #activeHelpKey: #glxGraphYMax
                    #translateLabel: true
                    #resizeForLabel: true
                    #adjust: #left
                  )
                 #(#InputFieldSpec
                    #name: 'yMaxField'
                    #layout: #(#LayoutFrame 170 0 65 0 227 0 87 0)
                    #activeHelpKey: #glxGraphYMax
                    #model: #yMax
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 #(#LabelSpec
                    #label: 'dX:'
                    #name: 'deltaXLabel'
                    #layout: #(#LayoutFrame 237 0 32 0 269 0 54 0)
                    #activeHelpKey: #glxGraphXStep
                    #translateLabel: true
                    #resizeForLabel: true
                    #adjust: #left
                  )
                 #(#InputFieldSpec
                    #name: 'deltaXField'
                    #layout: #(#LayoutFrame 269 0 30 0 314 0 52 0)
                    #activeHelpKey: #glxGraphXStep
                    #model: #deltaX
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 #(#LabelSpec
                    #label: 'dY:'
                    #name: 'deltaYLabel'
                    #layout: #(#LayoutFrame 236 0 67 0 269 0 89 0)
                    #activeHelpKey: #glxGraphYStep
                    #translateLabel: true
                    #resizeForLabel: true
                    #adjust: #left
                  )
                 #(#InputFieldSpec
                    #name: 'deltaYField'
                    #layout: #(#LayoutFrame 269 0 65 0 314 0 87 0)
                    #activeHelpKey: #glxGraphYStep
                    #model: #deltaY
                    #acceptChannel: #acceptChannel
                    #modifiedChannel: #modifiedChannel
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!GLXYGraphSpec class methodsFor:'interface-gallery'!

graphSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Demos::GLXYGraphSpec andSelector:#graphSpec
     Demos::GLXYGraphSpec new openInterface:#graphSpec
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'Views'
              #layout: #(#LayoutFrame 76 0 158 0 555 0 386 0)
              #label: 'Views'
              #min: #(#Point 10 10)
              #max: #(#Point 1280 1024)
              #bounds: #(#Rectangle 76 158 556 387)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#'Demos::GLXYGraphSpec'
                    #name: '3D X-Y Graph'
                    #layout: #(#LayoutFrame 15 0 10 0 180 0 90 0)
                    #rotX: 115
                    #rotY: 0
                    #rotZ: 45
                    #transZ: -5
                    #transY: -0.5
                )
                 #(#LabelSpec
                    #name: '3D X-Y Graph Label'
                    #layout: #(#Point 15 96)
                    #label: '3D X-Y Graph'
                    #style: #(#FontDescription #helvetica #medium #roman #'10')
                    #adjust: #left
                    #resizeForLabel: true
                    #canUIDrag: false
                )
              )
          )
      )

    "Modified: / 5.6.1998 / 03:51:11 / cg"
! !

!GLXYGraphSpec methodsFor:'accessing'!

backgroundColor
    "return the value of the instance variable 'backgroundColor' (automatically generated)"

    ^ backgroundColor

    "Created: / 29.5.1998 / 23:05:38 / cg"
!

backgroundColor:something
    "set the value of the instance variable 'backgroundColor' (automatically generated)"

    backgroundColor := something.

    "Created: / 29.5.1998 / 23:05:38 / cg"
!

boxColor
    "return the value of the instance variable 'boxColor' (automatically generated)"

    ^ boxColor

    "Created: / 5.6.1998 / 02:23:45 / cg"
!

boxColor:something
    "set the value of the instance variable 'boxColor' (automatically generated)"

    boxColor := something.

    "Created: / 5.6.1998 / 02:23:51 / cg"
!

deltaX
    "return the value of the instance variable 'deltaX' (automatically generated)"

    ^ deltaX

    "Created: / 29.5.1998 / 21:20:47 / cg"
!

deltaX:something
    "set the value of the instance variable 'deltaX' (automatically generated)"

    deltaX := something.

    "Created: / 29.5.1998 / 21:20:47 / cg"
!

deltaY
    "return the value of the instance variable 'deltaY' (automatically generated)"

    ^ deltaY

    "Created: / 29.5.1998 / 21:20:47 / cg"
!

deltaY:something
    "set the value of the instance variable 'deltaY' (automatically generated)"

    deltaY := something.

    "Created: / 29.5.1998 / 21:20:47 / cg"
!

drawBox
    "return the value of the instance variable 'drawBox' (automatically generated)"

    ^ drawBox

    "Created: / 29.5.1998 / 23:05:34 / cg"
!

drawBox:something
    "set the value of the instance variable 'drawBox' (automatically generated)"

    drawBox := something.

    "Created: / 29.5.1998 / 23:05:34 / cg"
!

drawNormals
    "return the value of the instance variable 'drawNormals' (automatically generated)"

    ^ drawNormals

    "Created: / 29.5.1998 / 23:05:33 / cg"
!

drawNormals:something
    "set the value of the instance variable 'drawNormals' (automatically generated)"

    drawNormals := something.

    "Created: / 29.5.1998 / 23:05:33 / cg"
!

gridColor
    "return the value of the instance variable 'gridColor' (automatically generated)"

    ^ gridColor

    "Created: / 29.5.1998 / 23:05:41 / cg"
!

gridColor:something
    "set the value of the instance variable 'gridColor' (automatically generated)"

    gridColor := something.

    "Created: / 29.5.1998 / 23:05:41 / cg"
!

normalsColor
    "return the value of the instance variable 'normalsColor' (automatically generated)"

    ^ normalsColor

    "Created: / 29.5.1998 / 23:05:39 / cg"
!

normalsColor:something
    "set the value of the instance variable 'normalsColor' (automatically generated)"

    normalsColor := something.

    "Created: / 29.5.1998 / 23:05:39 / cg"
!

rotX
    "return the value of the instance variable 'rotX' (automatically generated)"

    ^ rotX

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

rotX:something
    "set the value of the instance variable 'rotX' (automatically generated)"

    rotX := something.

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

rotY
    "return the value of the instance variable 'rotY' (automatically generated)"

    ^ rotY

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

rotY:something
    "set the value of the instance variable 'rotY' (automatically generated)"

    rotY := something.

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

rotZ
    "return the value of the instance variable 'rotZ' (automatically generated)"

    ^ rotZ

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

rotZ:something
    "set the value of the instance variable 'rotZ' (automatically generated)"

    rotZ := something.

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

scaleZ
    "return the value of the instance variable 'scaleZ' (automatically generated)"

    ^ scaleZ

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

scaleZ:something
    "set the value of the instance variable 'scaleZ' (automatically generated)"

    scaleZ := something.

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

transX
    "return the value of the instance variable 'transX' (automatically generated)"

    ^ transX

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

transX:something
    "set the value of the instance variable 'transX' (automatically generated)"

    transX := something.

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

transY
    "return the value of the instance variable 'transY' (automatically generated)"

    ^ transY

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

transY:something
    "set the value of the instance variable 'transY' (automatically generated)"

    transY := something.

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

transZ
    "return the value of the instance variable 'transZ' (automatically generated)"

    ^ transZ

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

transZ:something
    "set the value of the instance variable 'transZ' (automatically generated)"

    transZ := something.

    "Created: / 29.5.1998 / 23:06:35 / cg"
!

xMax
    "return the value of the instance variable 'xMax' (automatically generated)"

    ^ xMax

    "Created: / 29.5.1998 / 21:20:47 / cg"
!

xMax:something
    "set the value of the instance variable 'xMax' (automatically generated)"

    xMax := something.

    "Created: / 29.5.1998 / 21:20:47 / cg"
!

xMin
    "return the value of the instance variable 'xMin' (automatically generated)"

    ^ xMin

    "Created: / 29.5.1998 / 21:20:47 / cg"
!

xMin:something
    "set the value of the instance variable 'xMin' (automatically generated)"

    xMin := something.

    "Created: / 29.5.1998 / 21:20:47 / cg"
!

yMax
    "return the value of the instance variable 'yMax' (automatically generated)"

    ^ yMax

    "Created: / 29.5.1998 / 21:20:47 / cg"
!

yMax:something
    "set the value of the instance variable 'yMax' (automatically generated)"

    yMax := something.

    "Created: / 29.5.1998 / 21:20:47 / cg"
!

yMin
    "return the value of the instance variable 'yMin' (automatically generated)"

    ^ yMin

    "Created: / 29.5.1998 / 21:20:47 / cg"
!

yMin:something
    "set the value of the instance variable 'yMin' (automatically generated)"

    yMin := something.

    "Created: / 29.5.1998 / 21:20:47 / cg"
! !

!GLXYGraphSpec methodsFor:'building'!

aspectSelectors
    "add more aspect selectors
    "
    |more|

    more := super aspectSelectors.

    (rotX        notNil and:[rotX isNumber not]) ifTrue:[more add:rotX].
    (rotY        notNil and:[rotY isNumber not]) ifTrue:[more add:rotY].
    (rotZ        notNil and:[rotZ isNumber not]) ifTrue:[more add:rotZ].
    (transX      notNil and:[transX isNumber not]) ifTrue:[more add:transX].
    (transY      notNil and:[transY isNumber not]) ifTrue:[more add:transY].
    (transZ      notNil and:[transZ isNumber not]) ifTrue:[more add:transZ].
    (scaleZ      notNil and:[scaleZ isNumber not]) ifTrue:[more add:scaleZ].

    (drawNormals notNil and:[drawNormals ~~ true and:[drawNormals ~~ false]]) ifTrue:[more add:drawNormals].
    (drawBox     notNil and:[drawBox ~~ true and:[drawBox ~~ false]]) ifTrue:[more add:drawBox].

    ^ more

    "Modified: / 5.6.1998 / 02:05:17 / cg"
!

createViewFor:aBuilder in:aView
    "low level create - no attributes are set.
    "
    |frameView v|

    frameView := View in:aView.
    level notNil ifTrue:[frameView level:self level].
    borderWidth notNil ifTrue:[frameView borderWidth:self borderWidth].

    aBuilder isEditing ifFalse:[
        v := super createViewFor:aBuilder in:frameView
    ] ifTrue:[
        v := GLXYGraph in:frameView
    ].
    v origin:0.0@ 0.0 corner:1.0@1.0.
    ^ frameView

    "Created: / 29.5.1998 / 21:22:29 / cg"
    "Modified: / 5.6.1998 / 01:56:06 / cg"
!

setAttributesIn:aView with:aBuilder
    |glView f|

    super setAttributesIn:aView with:aBuilder.

    "/ attention: aView is really a wrapped one ...

    aView class == View ifTrue:[
        glView := aView subViews first.
    ] ifFalse:[
        glView := aView.
    ].

    model notNil ifTrue:[
        f := self getBindingIn:aBuilder binding:model.
    ].
    f isNil ifTrue:[
        f := [:x :y | 0] asValue
    ].
    glView functionBlockChannel:f.    

    xMin notNil ifTrue:[glView xMin:(self xMin)].
    xMax notNil ifTrue:[glView xMax:(self xMax)].
    yMin notNil ifTrue:[glView yMin:(self yMin)].
    yMax notNil ifTrue:[glView yMax:(self yMax)].
    deltaX notNil ifTrue:[glView deltaX:(self deltaX)].
    deltaY notNil ifTrue:[glView deltaY:(self deltaY)].

    glView backgroundColor:backgroundColor.
    glView normalsColor:normalsColor.
    glView gridColor:gridColor.
    glView boxColor:boxColor.

    rotX notNil ifTrue:[
        rotX isNumber ifTrue:[
            glView rotXChannel value:rotX
        ] ifFalse:[
            aBuilder isEditing ifFalse:[
                glView rotXChannel:(self getBindingIn:aBuilder binding:rotX)
            ]
        ]
    ].
    rotY notNil ifTrue:[
        rotY isNumber ifTrue:[
            glView rotYChannel value:rotY
        ] ifFalse:[
            aBuilder isEditing ifFalse:[
                glView rotYChannel:(self getBindingIn:aBuilder binding:rotY)
            ]
        ]
    ].
    rotZ notNil ifTrue:[
        rotZ isNumber ifTrue:[
            glView rotZChannel value:rotZ
        ] ifFalse:[
            aBuilder isEditing ifFalse:[
                glView rotZChannel:(self getBindingIn:aBuilder binding:rotZ)
            ]
        ]
    ].
    transX notNil ifTrue:[
        transX isNumber ifTrue:[
            glView transXChannel value:transX
        ] ifFalse:[
            aBuilder isEditing ifFalse:[
                glView transXChannel:(self getBindingIn:aBuilder binding:transX)
            ]
        ]
    ].
    transY notNil ifTrue:[
        transY isNumber ifTrue:[
            glView transYChannel value:transY
        ] ifFalse:[
            aBuilder isEditing ifFalse:[
                glView transYChannel:(self getBindingIn:aBuilder binding:transY)
            ]
        ]
    ].
    transZ notNil ifTrue:[
        transZ isNumber ifTrue:[
            glView transZChannel value:transZ
        ] ifFalse:[
            aBuilder isEditing ifFalse:[
                glView transZChannel:(self getBindingIn:aBuilder binding:transZ)
            ]
        ]
    ].
    scaleZ notNil ifTrue:[
        scaleZ isNumber ifTrue:[
            glView scaleZChannel value:scaleZ
        ] ifFalse:[
            aBuilder isEditing ifFalse:[
                glView scaleZChannel:(self getBindingIn:aBuilder binding:scaleZ)
            ]
        ]
    ].
    drawNormals notNil ifTrue:[
        ((drawNormals == true) or:[drawNormals == false]) ifTrue:[
            glView drawNormalsChannel value:drawNormals
        ] ifFalse:[
            aBuilder isEditing ifFalse:[
                glView drawNormalsChannel:(self getBindingIn:aBuilder binding:drawNormals)
            ]
        ]
    ].
    drawBox notNil ifTrue:[
        ((drawBox == true) or:[drawBox == false]) ifTrue:[
            glView drawBoxChannel value:drawBox
        ] ifFalse:[
            aBuilder isEditing ifFalse:[
                glView drawBoxChannel:(self getBindingIn:aBuilder binding:drawBox)
            ]
        ]
    ].

    aBuilder isEditing ifFalse:[
        self setModelAttributeIn:glView with:aBuilder.
        self setMenuIn:glView with:aBuilder.
    ]

    "Created: / 29.5.1998 / 21:24:49 / cg"
    "Modified: / 5.6.1998 / 04:15:20 / cg"
!

xxpostCreateView:v for:aBuilder
    "redefined, because we must register the wrapped view"

    |glView|

    aBuilder notNil ifTrue:[
        v class == View ifTrue:[
            glView := v subViews first.
        ] ifFalse:[
            glView := v.
        ].
        aBuilder createdComponent:glView forSpec:self named:name.
    ].
    ^ v


! !

!GLXYGraphSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    boxColor notNil ifTrue:[boxColor := boxColor decodeAsLiteralArray].
    gridColor notNil ifTrue:[gridColor := gridColor decodeAsLiteralArray].
    normalsColor notNil ifTrue:[normalsColor := normalsColor decodeAsLiteralArray].
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].

    "Created: / 5.6.1998 / 02:08:25 / cg"
    "Modified: / 5.6.1998 / 02:24:10 / cg"
!

skippedInLiteralEncoding
    "define the inst-slots which are skiped when generating a literalArrayEncoding"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    xMin isNil ifTrue:[l add:#xMin].
    xMax isNil ifTrue:[l add:#xMax].
    yMin isNil ifTrue:[l add:#yMin].
    yMax isNil ifTrue:[l add:#yMax].
    deltaX isNil ifTrue:[l add:#deltaX].
    deltaY isNil ifTrue:[l add:#deltaY].

    rotX isNil ifTrue:[l add:#rotX].
    rotY isNil ifTrue:[l add:#rotY].
    rotZ isNil ifTrue:[l add:#rotZ].

    transX isNil ifTrue:[l add:#transX].
    transY isNil ifTrue:[l add:#transY].
    transZ isNil ifTrue:[l add:#transZ].

    scaleZ isNil ifTrue:[l add:#scaleZ].
    drawNormals isNil ifTrue:[l add:#drawNormals].
    drawBox isNil ifTrue:[l add:#drawBox].

    backgroundColor isNil ifTrue:[l add:#backgroundColor].
    normalsColor isNil ifTrue:[l add:#normalsColor].
    gridColor isNil ifTrue:[l add:#gridColor].
    boxColor isNil ifTrue:[l add:#boxColor].

    ^ l

    "Created: / 29.5.1998 / 21:26:08 / cg"
    "Modified: / 5.6.1998 / 02:24:17 / cg"
! !

!GLXYGraphSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    xMin := aView xMin.
    xMax := aView xMax.
    yMin := aView yMin.
    yMax := aView yMax.
    rotX := aView rotX.
    rotY := aView rotY.
    rotZ := aView rotZ.
    transX := aView transX.
    transY := aView transY.
    transZ := aView transZ.
    scaleZ := aView scaleZ.
    drawNormals := aView isDrawingNormals.
    drawBox := aView isDrawingBox.

    super fromView:aView callBack:aBlock.

    "Modified: / 5.6.1998 / 02:52:20 / cg"
! !

!GLXYGraphSpec methodsFor:'queries'!

defaultModelValueFor:someAspect
    "used by the UIPainters aspectGenerator"

    someAspect == model ifTrue:[^ 0 ].

    someAspect == rotX ifTrue:[^ 115].
    someAspect == rotY ifTrue:[^ 0.0].
    someAspect == rotZ ifTrue:[^ 45].
    someAspect == transX ifTrue:[^ 0.0].
    someAspect == transY ifTrue:[^ 0.0].
    someAspect == transZ ifTrue:[^ 0.0].
    someAspect == scaleZ ifTrue:[^ 0.0].
    someAspect == drawNormals ifTrue:[^ true].
    someAspect == drawBox     ifTrue:[^ true].
    ^ super defaultModelValueFor:someAspect

    "Created: / 5.6.1998 / 01:09:54 / cg"
    "Modified: / 5.6.1998 / 04:07:09 / cg"
!

viewClass
    "return the corresponding view class of the spec.
     This is an instance method, since it may depend on some attribute."

    ^ GLXYGraph

    "Created: / 29.5.1998 / 22:18:34 / cg"
! !

!GLXYGraphSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLXYGraphSpec.st,v 1.8 2016-01-21 18:06:01 cg Exp $'
! !


GLXYGraphSpec initialize!
